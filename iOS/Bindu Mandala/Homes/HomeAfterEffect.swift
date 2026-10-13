import Foundation

// MARK: - The after-effect: her siddhi lingers on the instrument, felt, never named
//
// Wave 1 · Slice D. Design built this twice and the restrained build shipped
// neither:
//
//   * the Axis (`The Homes - The Axis.html`, `beginLeave`): on leaving, the
//     whole instrument's exposure lifts — `1.04 + 0.12 × (1 − age / 24)` (the
//     Axis also wrote a line naming it; ruling 15, 12 Oct 2026: the after-effect
//     is felt, never named, so that line is not carried);
//   * the older Rite (`rite-core.jsx`, `riteAfterStyle`): for 180 seconds the
//     instrument is a little **lighter**, **heavier**, **sharper** or **wider**,
//     by her āvaraṇa, decaying as the square of what is left — *"Her Siddhi
//     lingers on the whole instrument. Decays over minutes. Never named."*
//
// Both come home. The four kinds are the Rite's; the lift is the Axis's
// exposure. No words name it (ruling 15). None of it is a score: it says nothing about
// how long he stayed or how often he has come, and it is the same after-effect
// for every stay in a ring. It is her, still present, and then gone.

enum HomeAfterEffect {

    /// What her siddhi does to the instrument.
    enum Kind: String, CaseIterable, Equatable {
        case lighter, heavier, sharper, wider
    }

    /// `rite-core.jsx`'s `after:` column, by āvaraṇa.
    static let kinds: [Int: Kind] = [
        1: .sharper, 2: .wider, 3: .lighter, 4: .wider, 5: .sharper,
        6: .heavier, 7: .wider, 8: .lighter, 9: .wider,
    ]

    static func kind(ring: Int) -> Kind { kinds[ring] ?? .wider }

    /// `RITE_AFTER_DUR = 180` — how long it lingers.
    static let lingers: TimeInterval = 180
    /// The Axis's exposure lift fades over 24 seconds.
    static let liftFades: TimeInterval = 24
    /// The Axis's `0.12` of exposure, at the moment of leaving.
    static let exposureLift: Double = 0.12

    /// The instrument, at one moment after leaving, as numbers a view applies.
    struct Look: Equatable {
        /// Added brightness, SwiftUI's `.brightness` scale (0 is unchanged).
        var brightness: Double = 0
        /// Multiplied contrast (1 is unchanged).
        var contrast: Double = 1
        /// Multiplied saturation (1 is unchanged).
        var saturation: Double = 1
        /// Scale of the whole instrument (1 is unchanged).
        var scale: Double = 1
        /// Whether it scales from the floor rather than the middle — Design's
        /// `transformOrigin: 'bottom center'` for heavier.
        var anchoredLow: Bool = false

        static let unchanged = Look()
    }

    /// Design's `riteAfterStyle(kind, age)`, plus the Axis's exposure lift.
    ///
    /// CSS `brightness(x)` multiplies; SwiftUI's adds. Over the dark ground the
    /// instrument stands on, a multiple of `1 + d` reads as an addition of
    /// about `d / 2`, which is how it is carried.
    static func look(kind: Kind, age: TimeInterval) -> Look {
        guard age >= 0 else { return .unchanged }
        var look = Look()
        let k = 1 - min(1, max(0, age / lingers))
        let e = k * k
        if e > 0.001 {
            switch kind {
            case .lighter:
                look.brightness = 0.07 * e / 2
                look.saturation = 1 - 0.06 * e
            case .heavier:
                look.brightness = -0.06 * e / 2
                look.contrast = 1 + 0.04 * e
                look.scale = 1 + 0.01 * e
                look.anchoredLow = true
            case .sharper:
                look.contrast = 1 + 0.1 * e
                look.saturation = 1 + 0.05 * e
                look.scale = 1 - 0.014 * e
            case .wider:
                look.brightness = 0.03 * e / 2
                look.scale = 1 + 0.018 * e
            }
        }
        // The Axis: `expo = 1.04 + 0.12 * (1 - age / 24)`, over the 1.04 it
        // rests at.
        let lift = 1 - min(1, max(0, age / liftFades))
        look.brightness += exposureLift / 1.04 * lift / 2
        return look
    }

    // MARK: - Leaving

    /// The notification a room posts when he crosses out of it. The ring is in
    /// `userInfo["ring"]`, and nothing else is — not the stay, not her position.
    static let didLeave = Notification.Name("bindu.homes.herSiddhiLingers")

    /// He has crossed out of a room in this āvaraṇa.
    static func left(ring: Int) {
        NotificationCenter.default.post(name: didLeave, object: nil, userInfo: ["ring": ring])
    }
}
