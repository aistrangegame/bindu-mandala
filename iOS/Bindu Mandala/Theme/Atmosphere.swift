import SwiftUI

/// A whole coherent palette derived deterministically from one Śakti and the
/// hour — so 102 energies feel like 102 presences without authoring 102
/// backgrounds. Everything visual (Today, Detail, Field, Portrait, Mandala) reads
/// its ground/glow/accent from here; nothing hand-picks a color per screen.
///
/// Ported from `living-rite-core.jsx` `lrAtmosphere` / `lrApplyTime` / `lrBackdrop`.
/// Pure and `Equatable` (the seed `hue` + `element` + `glowAlpha` fully determine
/// it), so derivations are asserted against reference numbers in tests.
struct Atmosphere: Equatable {
    /// The seed hue after per-Śakti jitter and any time-of-day modulation.
    let hue: HSL
    let element: Element
    let glowAlpha: Double
    /// Slow sigil rotation, degrees — deterministic per Śakti.
    let rotation: Double

    // MARK: - Derived colors (all inside the token family)

    var accent: Color { hue.color() }
    var accentBright: Color {
        HSL(h: hue.h, s: min(hue.s + 10, 88), l: min(hue.l + 18, 78)).color()
    }
    var accentSoft: Color { hue.color(alpha: 0.62) }
    var accentFaint: Color { hue.color(alpha: 0.24) }
    var glow: Color { HSL(h: hue.h, s: hue.s, l: min(hue.l + 6, 70)).color(alpha: glowAlpha) }

    /// Ground = the base ground tinted 20% toward her accent (an RGB blend
    /// approximating the prototype's `color-mix` in oklab).
    var ground: Color { Self.blend(Self.baseGround, hue.rgb, 0.20) }
    var groundDeep: Color { Self.blend(Self.baseGroundDeep, hue.rgb, 0.12) }

    // MARK: - Derivation

    /// Pure core — takes primitives so numeric tests don't build a `Shakti`.
    static func derive(ring: Int,
                       cluster: Cluster?,
                       khadgamala: Int,
                       element: Element,
                       at variant: TimeVariant? = nil) -> Atmosphere {
        let base = seedHue(ring: ring, cluster: cluster)
        var hue = HSL(h: HSL.wrap(base.h + jitter(khadgamala, 14)), s: base.s, l: base.l)
        var glowAlpha = 0.36
        if let m = variant?.modulation {
            hue = HSL(h: HSL.wrap(hue.h + m.dh),
                      s: HSL.clamp(hue.s * m.sMul, 6, 90),
                      l: HSL.clamp(hue.l + m.lAdd, 8, 82))
            glowAlpha = HSL.clamp(0.36 * m.glowMul, 0.12, 0.5)
        }
        return Atmosphere(hue: hue, element: element, glowAlpha: glowAlpha,
                          rotation: jitter(khadgamala, 44).rounded())
    }

    /// Derive for a real Śakti. Bakes in the 86-degradation: cluster hue is used
    /// **only** for Ring 2 — the 86's `clusterRaw` default of `.inner` never leaks
    /// (Ruling 7), so rings 1,3–9 always seed off their ring hue.
    static func derive(from s: Shakti, at variant: TimeVariant? = nil) -> Atmosphere {
        let ring = s.ringNumber ?? 2
        let kp = s.khadgamalaPosition ?? s.position
        let cluster: Cluster? = (ring == 2) ? s.cluster : nil
        return derive(ring: ring, cluster: cluster, khadgamala: kp, element: s.element, at: variant)
    }

    // MARK: - Hue seeds (exhaustive switches — never miss a key or return 0)

    static func seedHue(ring: Int, cluster: Cluster?) -> HSL {
        if ring == 2, let cluster { return clusterHue(cluster) }
        return ringHue(ring)
    }

    /// Ring-2 cluster hues (`LR_CLUSTER_HUES`).
    static func clusterHue(_ c: Cluster) -> HSL {
        switch c {
        case .inner:     return HSL(h: 43,  s: 78, l: 52)
        case .tanmatra:  return HSL(h: 13,  s: 47, l: 56)
        case .citta:     return HSL(h: 180, s: 49, l: 32)
        case .stability: return HSL(h: 140, s: 24, l: 38)
        case .selfBody:  return HSL(h: 270, s: 26, l: 48)
        }
    }

    /// Per-ring hues (`LR_RING_HUES`). Ring 2 with no cluster falls to the home
    /// amber; anything indeterminate falls to a terminal gold default — never blank.
    static func ringHue(_ ring: Int) -> HSL {
        switch ring {
        case 1: return HSL(h: 35,  s: 58, l: 54)
        case 2: return clusterHue(.inner)          // home ring default
        case 3: return HSL(h: 341, s: 45, l: 58)
        case 4: return HSL(h: 353, s: 55, l: 48)
        case 5: return HSL(h: 18,  s: 62, l: 55)
        case 6: return HSL(h: 194, s: 42, l: 46)
        case 7: return HSL(h: 322, s: 38, l: 50)
        case 8: return HSL(h: 2,   s: 68, l: 50)
        case 9: return HSL(h: 46,  s: 72, l: 66)
        default: return HSL(h: 43, s: 60, l: 52)   // terminal default (indeterminate ring)
        }
    }

    /// Deterministic per-Śakti jitter (`lrJitter`). Keyed off `khadgamalaPosition`
    /// (PR-0 ruling), so sisters differ but the value is stable across launches.
    static func jitter(_ kp: Int, _ range: Double) -> Double {
        (Double((kp * 2654435761) % 1000) / 1000.0 - 0.5) * range
    }

    // MARK: - Ground blending

    private static let baseGround: (Double, Double, Double) = (13/255, 5/255, 8/255)     // #0D0508
    private static let baseGroundDeep: (Double, Double, Double) = (7/255, 2/255, 5/255)   // #070205

    private static func blend(_ a: (Double, Double, Double), _ b: (r: Double, g: Double, b: Double), _ t: Double) -> Color {
        Color(red: a.0 * (1 - t) + b.r * t,
              green: a.1 * (1 - t) + b.g * t,
              blue: a.2 * (1 - t) + b.b * t)
    }
}
