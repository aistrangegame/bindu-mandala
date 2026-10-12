import Foundation

// MARK: - Wave 6 · the empty summit, and the Totality close
//
// His Codex, C-1260 (*Anchor Points to Self-Realization*): climb toward the
// deity, and at the summit no one is there — *"I am what I am becoming."* And
// C-1307: what is above creation is not attained by action, so the summit is
// not a prize at the top of a climb. As the walker rises into Totality (band
// nine), the one light that stood there thins away into the world's own
// sourceless light, and his line arrives. Beneath it, the Totality close
// (C-1278, C-1281, the trunk of the Hall of Perspectives): *"I already did."*
//
// The light is not gone from the record or the building: a touch where it
// stood still opens her room (one building, no cuts). It is only that, at the
// top, nobody is standing there.

enum ClimbSummit {

    /// The climb's top fraction — Totality's station.
    static var top: Double { WorldClimb.fractionRange.upperBound }

    /// How far below the top the emptying begins, in bands.
    static let reach: Double = 0.55

    /// How empty the summit is at this height: 0 below it … 1 at the top.
    static func emptiness(atFraction f: Double) -> Double {
        let from = top - reach
        guard f > from else { return 0 }
        let k = min(1, (f - from) / reach)
        return k * k * (3 - 2 * k)
    }

    /// Whether a light is the one the summit empties of: the ninth āvaraṇa's.
    static func empties(kp: Int) -> Bool {
        KhadgamalaMap.ringNumber(forKhadgamala: kp) == HomeWorlds.rings.count
    }

    /// His line at the summit (C-1260). Authored, never generated.
    static let becoming = "I am what I am becoming."

    /// The Totality close (C-1278, C-1281).
    static let alreadyDid = "I already did."

    /// The close arrives after his line, at the very top.
    static func closeLight(atFraction f: Double) -> Double {
        let e = emptiness(atFraction: f)
        return max(0, min(1, (e - 0.6) / 0.4))
    }
}
