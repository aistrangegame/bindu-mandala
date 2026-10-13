import Foundation

// MARK: - U1 · Look · breath: the single 8 s clock lifted (visual.md §1.6)
//
// `BreathClock` keeps its one epoch (`timeIntervalSinceReferenceDate`, so the
// phase is the same on every screen across launches) and its phase curve
// `(1 − cos 2πt/p)/2`. What is lifted is the **snap**: Wave 6 rounded every
// period to the eighth-of-a-breath beat, which turned the home petal's 3.5 s
// into 3 s and a Score's 9.3 s into 9. Law 7: each enclosure breathes at
// Design's own period, slowing toward the centre, the Bindu a slow heart.
//
// This file **extends** `BreathClock` (Theme/BreathClock.swift is untouched in
// U1 — `period(grammar:score:)` still snaps for its one caller,
// `ScoreLightVeil`, until U2 moves it to `livePeriod`). `FieldBreath` (ring 2
// = 3 s) likewise stays for its callers and its two pinning tests; U2 switches
// them to `BreathEnclosure` and retires the 3 s.

extension BreathClock {

    /// A Score's tempo applied to a grammar period — its own breath if it gives
    /// one, else the grammar's period over its rate — **unsnapped** (§1.6, law 7).
    static func livePeriod(grammar: Double, score: ShaktiScore.Tempo?) -> Double {
        var p = grammar
        if let b = score?.breath { p = b }
        else if let r = score?.rate, r > 0 { p = grammar / r }
        return max(0, p)
    }

    /// The phase 0 → 1 → 0 of any period on the one epoch at `date`. A period of
    /// 0 holds (the Bhūpura: "the earth underfoot does not breathe").
    static func phase(at date: Date, period: Double) -> Double {
        phase(at: seconds(at: date), period: period)
    }
}

/// The nine enclosures and their metabolisms (Design's own periods). Implements
/// `visual.md` §1.6 "Per enclosure".
enum BreathEnclosure: Int, CaseIterable {
    case bhupura = 1, petals16, petals8, triangles14, outerTen, innerTen, triangles8, primary, bindu

    /// The token name the world file gives each.
    var token: String {
        switch self {
        case .bhupura:     return "ground"
        case .petals16:    return "home"
        case .petals8:     return "petal8"
        case .triangles14: return "tri1"
        case .outerTen:    return "tri2"
        case .innerTen:    return "tri3"
        case .triangles8:  return "tri4"
        case .primary:     return "root"
        case .bindu:       return "bindu"
        }
    }

    /// Seconds per breath. The Bhūpura holds (0). The sixteen petals' period is
    /// **today's petal**, 3.5 s; the others breathe by relationship
    /// (`homePetal(_:)`).
    var period: Double {
        switch self {
        case .bhupura:     return 0
        case .petals16:    return 3.5
        case .petals8:     return 8
        case .triangles14: return 9
        case .outerTen:    return 11
        case .innerTen:    return 13
        case .triangles8:  return 15
        case .primary:     return 18
        case .bindu:       return 4
        }
    }

    /// The peak scale (or brightness for the petals) each reaches. Nil where
    /// the source gives none.
    var peak: Double? {
        switch self {
        case .bhupura:     return nil
        case .petals16:    return 1.55   // today's petal brightness 1 → 1.55
        case .petals8:     return 1.18   // Ring 3 petal .9 → 1.18
        case .triangles14: return 1.25   // up-triangle peak
        case .outerTen:    return 1.20
        case .innerTen:    return 1.18
        case .triangles8:  return 1.15
        case .primary:     return nil    // "almost still"
        case .bindu:       return 1.20   // Home; the Mandala's is 1.28
        }
    }

    /// The enclosure ring n breathes as (ring 1 … 9).
    static func forRing(_ n: Int) -> BreathEnclosure? { BreathEnclosure(rawValue: n) }

    /// The petals of the home ring by his relationship with each (Home Mandala
    /// `home-petal-*`): today 3.5 · embodied 4.5 · active 6 · exploring 7.5 ·
    /// mapped 10 s.
    enum Relationship: String, CaseIterable {
        case today, embodied, active, exploring, mapped
    }

    static func homePetal(_ r: Relationship) -> Double {
        switch r {
        case .today:     return 3.5
        case .embodied:  return 4.5
        case .active:    return 6
        case .exploring: return 7.5
        case .mapped:    return 10
        }
    }

    /// Each petal starts `i × 0.18 s` after the one before (today's at 0).
    static let petalStagger = 0.18

    /// The primary triangle's down-triangles: 10 / 12 / 14 / 16 / 18 s.
    static let downTriangles: [Double] = [10, 12, 14, 16, 18]

    /// The Mandala's Bindu breathes deeper than Home's: ×1.28.
    static let mandalaBinduPeak = 1.28
}

/// Each world's own breath (§1.6 "Per world") and the world glow every world
/// shares. Implements `visual.md` §1.6.
enum WorldBreath {

    /// The period a world breathes at, where it has one breath. Nil where the
    /// breath is not one number: the rings (their enclosure × tempo), Her Home
    /// (locked to her bīja), Beneath (read from his inhale).
    static func period(_ world: WorldID) -> Double? {
        switch world {
        case .home:         return BreathEnclosure.bindu.period   // the slow heart, 4 s
        case .today:        return 10                             // feed's 0.1 Hz under everything
        case .mandala:      return BreathEnclosure.bindu.period
        case .rings:        return nil
        case .herHome:      return nil
        case .herPresence:  return 3.2                            // the Bindu ember; presences 6.8–16.5 s
        case .climb:        return climbCrownPeriod
        case .the33:        return 4                              // the orb
        case .game:         return 9                              // Lalitā's point
        case .modes:        return 6                              // the Mauna Bindu
        case .time:         return BreathClock.breath             // the only world that keeps 8 s
        case .memory:       return 8
        case .well:         return 1.2                            // tempo per step
        case .beneath:      return nil
        case .relationship: return 0.6                            // night tempo (paper 0.35)
        }
    }

    /// The crown's breath on the Climb: `.86 + .14 sin(t·.3)` — period 2π/.3 ≈ 21 s.
    static let climbCrownPeriod = 2 * Double.pi / 0.3

    /// The Rite's sigil Bindu keeps its own 5.5 s (an existing experience keeps its breath).
    static let riteSigilBindu = 5.5

    /// Her element backdrop breaths (§1.4.2 / §1.5.4).
    static func elementBackdrop(_ e: Element) -> Double { ElementLayout.of(e).backdropBreath }

    /// A ring world breathes at its enclosure's period × the world tempo (tempo
    /// scales the world clock only, never her adaptation clock): a slower world
    /// (tempo < 1) breathes longer.
    static func ring(_ n: Int, tempo: Double) -> Double {
        let p = BreathEnclosure.forRing(n)?.period ?? 0
        guard tempo > 0 else { return p }
        return p / tempo
    }

    // MARK: The world glow (§1.6)

    /// Every world's glow: opacity 0 → .07 over 12.5 s (0.08 Hz) in the world's
    /// own colour — an opacity glow, never a scale. Shares the sound's LFO.
    static let glowPeriod = 12.5
    static let glowPeak = 0.07

    static func glowOpacity(at date: Date) -> Double {
        glowPeak * BreathClock.phase(at: date, period: glowPeriod)
    }
}
