import SwiftUI

// MARK: - U1 · Look · the palette engine — one hue per Śakti (visual.md §1.5)
//
// "Every surface is generated from the Śakti herself — her ring, cluster,
// tattva/element, and the hour of day. Do not hand-pick colors per screen."
//
// **Extends, never replaces** `Atmosphere` (R01:26): the seed hues, the ±7°
// jitter and the ground blends are `Atmosphere.derive`'s, and the composition
// bits are `RiteComposition.derive`'s. What this adds is what §1.5 settled and
// the existing engine does not yet do:
//
//  · the whole engine keyed by position alone (kp → ring → cluster → element),
//    so any surface can light a Śakti from her kp;
//  · relit by the hour with **the settled table** (§1.5.3), including the new
//    moon row the upgrade fixed (dh −7 · lAdd −12 · sMul .55 · glowMul .85 ·
//    moteMul .5) — `TimeVariant.modulation` still carries Wave 1's invented
//    new-moon row (−16 / 1.12 / .4) and its pinning test; U2 switches the
//    consumers here and retires that row;
//  · the settled windows (C16): dawn 05–09 · noon 09–16 · dusk 16–20 · night
//    otherwise · new moon when the lunar phase is < .03 or > .97;
//  · `moteMul` read (Design defect G1-0467: never read);
//  · the grounds mixed in oklab, as Design's `color-mix(in oklab, …)` does;
//  · the six element layouts with ruling 4's table and ether at 280°.

/// The settled relight of one hour (§1.5.3). Implements `visual.md` §1.5.3.
struct Relight: Equatable {
    let dh: Double
    let lAdd: Double
    let sMul: Double
    let glowMul: Double
    let tint: String
    let tintA: Double
    let moteMul: Double

    static func of(_ v: TimeVariant) -> Relight {
        switch v {
        case .dawn:    return Relight(dh: 8, lAdd: 6, sMul: 1.02, glowMul: 1.15, tint: "#3A1C22", tintA: 0.12, moteMul: 1.0)
        case .noon:    return Relight(dh: -5, lAdd: 13, sMul: 0.88, glowMul: 0.80, tint: "#242838", tintA: 0.07, moteMul: 0.7)
        case .dusk:    return Relight(dh: 3, lAdd: 2, sMul: 1.16, glowMul: 1.25, tint: "#331306", tintA: 0.14, moteMul: 1.15)
        case .night:   return Relight(dh: -7, lAdd: -9, sMul: 1.06, glowMul: 1.05, tint: "#060716", tintA: 0.16, moteMul: 1.3)
        case .newmoon: return Relight(dh: -7, lAdd: -12, sMul: 0.55, glowMul: 0.85, tint: "#04030C", tintA: 0.18, moteMul: 0.5)
        }
    }

    /// `lrApplyTime` on one HSL: hue turned, `s` clamped 6…90, `l` clamped 8…82.
    func apply(_ c: HSL) -> HSL {
        HSL(h: HSL.wrap(c.h + dh),
            s: HSL.clamp(c.s * sMul, 6, 90),
            l: HSL.clamp(c.l + lAdd, 8, 82))
    }

    /// The glow's alpha: `clamp(.36 × glowMul, .12, .5)`.
    var glowAlpha: Double { HSL.clamp(0.36 * glowMul, 0.12, 0.5) }
}

/// How each element composes a surface (§1.5.4) — structure, not recolour.
/// Implements `visual.md` §1.5.4 "Six element layouts, ruling 4, and the ether hue".
struct ElementLayout: Equatable {
    /// ascension · descent · horizon · veil · foundation · radiance.
    let archetype: String
    /// How the motes move.
    let motes: DustMotesView.Motion
    /// The backdrop's breath, seconds.
    let backdropBreath: Double
    /// The hue a world tints by when it colours *by element* (the Modes,
    /// element vocabularies) — `hsl(h, 55, 68)`. Never a Mandala world's hue:
    /// there her ring / cluster seed sets the hue.
    let tintHue: Double

    var tint: HSL { HSL(h: tintHue, s: 55, l: 68) }

    /// Ether's hue, settled at 280° (the crown's, "beyond form").
    static let etherHue: Double = 280

    static func of(_ e: Element) -> ElementLayout {
        switch e {
        case .fire:  return ElementLayout(archetype: "ascension", motes: .rise, backdropBreath: 11, tintHue: 25)
        case .water: return ElementLayout(archetype: "descent", motes: .fall, backdropBreath: 13, tintHue: 210)
        case .air:   return ElementLayout(archetype: "horizon", motes: .drift, backdropBreath: 12, tintHue: 195)
        case .ether: return ElementLayout(archetype: "veil", motes: .twinkle, backdropBreath: 9.6, tintHue: etherHue)
        case .earth: return ElementLayout(archetype: "foundation", motes: .still, backdropBreath: 15, tintHue: 15)
        case .light: return ElementLayout(archetype: "radiance", motes: .twinkle, backdropBreath: 7.6, tintHue: 50)
        }
    }
}

/// The palette engine keyed by position (kp 1…102). Implements `visual.md` §1.5
/// "The palette engine — one hue per Śakti".
enum ShaktiPalette {

    // MARK: Seed (§1.5.1)

    static func ring(kp: Int) -> Int { KhadgamalaMap.ringNumber(forKhadgamala: kp) }

    /// Ring 2's cluster by position (29–31 inner · 32–36 tanmātra · 37 citta ·
    /// 38–41 stability · 42–44 self·body); nil for every other ring, so the
    /// 86's `.inner` default never seeds a hue (ruling 7).
    static func cluster(kp: Int) -> Cluster? {
        guard ring(kp: kp) == 2 else { return nil }
        return Cluster.forPosition(KhadgamalaMap.perRingIndex(forKhadgamala: kp))
    }

    /// Her element: ruling 4's explicit kp table for Ring 2 first, the per-ring
    /// temperament otherwise (1 earth · 3 air · 4 water · 5 fire · 6 ether ·
    /// 7 air · 8 fire · 9 light).
    static func element(kp: Int) -> Element {
        Element.forRing2(kp: kp) ?? Element.forRing(ring(kp: kp))
    }

    /// The unjittered seed — "the world shown empty".
    static func seed(kp: Int) -> HSL {
        Atmosphere.seedHue(ring: ring(kp: kp), cluster: cluster(kp: kp))
    }

    // MARK: Jitter by position (§1.5.2)

    /// `frac = ((kp × 2654435761) mod 1000 + 1000) mod 1000 / 1000` — position is identity.
    static func frac(kp: Int) -> Double {
        Double((((kp &* 2654435761) % 1000) + 1000) % 1000) / 1000
    }

    /// `jitter(kp, range) = (frac − 0.5) × range`.
    static func jitter(kp: Int, _ range: Double) -> Double { (frac(kp: kp) - 0.5) * range }

    /// Flip, spin, sigil scale .86–1.26 and name tier from `m = (kp × 2654435761) >>> 0`.
    static func composition(kp: Int) -> RiteComposition {
        RiteComposition.derive(kp: kp, element: element(kp: kp))
    }

    // MARK: Relit by the hour (§1.5.3)

    /// The settled windows (C16): dawn 05–09 · noon 09–16 · dusk 16–20 · night
    /// otherwise; the new moon (phase < .03 or > .97) overrides night only.
    static func timeVariant(hour: Int, lunarPhase: Double) -> TimeVariant {
        let h = ((hour % 24) + 24) % 24
        switch h {
        case 5..<9:   return .dawn
        case 9..<16:  return .noon
        case 16..<20: return .dusk
        default:
            return (lunarPhase < 0.03 || lunarPhase > 0.97) ? .newmoon : .night
        }
    }

    /// The hour now, by the device clock and the real moon.
    static func timeVariant(at date: Date = .now, calendar: Calendar = .current) -> TimeVariant {
        timeVariant(hour: calendar.component(.hour, from: date),
                    lunarPhase: LunarPhaseService.phaseFraction(at: date))
    }

    /// Her atmosphere from her position alone, relit by the settled table. With
    /// no hour it is `Atmosphere.derive` exactly (the timeless ring light).
    static func atmosphere(kp: Int, at variant: TimeVariant? = nil) -> Atmosphere {
        let unlit = Atmosphere.derive(ring: ring(kp: kp), cluster: cluster(kp: kp),
                                      khadgamala: kp, element: element(kp: kp), at: nil)
        guard let variant else { return unlit }
        let r = Relight.of(variant)
        return Atmosphere(hue: r.apply(unlit.hue), element: unlit.element,
                          glowAlpha: r.glowAlpha, rotation: unlit.rotation, timeKey: variant)
    }

    /// A surface's mote count at this hour — `moteMul` is read (G1-0467).
    static func motes(_ base: Int, at variant: TimeVariant?) -> Int {
        guard let variant else { return base }
        return max(0, Int((Double(base) * Relight.of(variant).moteMul).rounded()))
    }

    // MARK: Grounds in oklab (§1.4.2, §1.4.4)

    static let houseGround = LookColor(hex: "#0D0508")
    static let houseGroundDeep = LookColor(hex: "#070205")

    /// `mix(oklab, #0D0508 80 %, accent 20 %)`, then the hour's tint at its tintA.
    static func ground(_ a: Atmosphere) -> LookColor {
        tinted(OKLab.mix(houseGround, LookColor(a.hue), 0.20), by: a.timeKey)
    }

    /// `mix(oklab, #070205 88 %, accent 12 %)`, then the hour's tint.
    static func groundDeep(_ a: Atmosphere) -> LookColor {
        tinted(OKLab.mix(houseGroundDeep, LookColor(a.hue), 0.12), by: a.timeKey)
    }

    private static func tinted(_ c: LookColor, by v: TimeVariant?) -> LookColor {
        guard let v else { return c }
        let r = Relight.of(v)
        return OKLab.mix(c, LookColor(hex: r.tint), r.tintA)
    }

    /// A ring's wash and deep from its hex (§1.4.4 "wash / deep").
    static func wash(_ ringHex: LookColor) -> LookColor { OKLab.mix(houseGround, ringHex, 0.20) }
    static func deep(_ ringHex: LookColor) -> LookColor { OKLab.mix(houseGroundDeep, ringHex, 0.12) }
}
