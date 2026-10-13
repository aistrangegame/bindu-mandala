import Foundation

// MARK: - Upgrade U0 · the World Registry's seed
//
// `waves/upgrade/worlds/verification.md` V11: one World enum, exactly the
// fifteen worlds round the Bindu, each addressable for the walk by
// `OPEN_WORLD=<id>`. U1 builds the router on this enum; U0 only names the
// worlds and, for the walk, maps each to the **closest screen that exists
// today** (`u0Destination`), because no world is redesigned in U0.
//
// The raw values are the walk's ids and never change: a ledger row, a walk
// record and a launch argument all name a world by them.

/// The fifteen worlds (Home is the Bindu, the centre; the others stand round it).
enum WorldID: String, CaseIterable, Equatable {
    case home
    case today
    case mandala
    case rings
    case herHome
    case herPresence
    case climb
    case the33
    case game
    case modes
    case time
    case memory
    case well
    case beneath
    case relationship

    /// The world asked for by `OPEN_WORLD=<id>` — DEBUG walk scheme only; a
    /// Release build never honours it (V50: no forced state in a shipped build).
    /// The last `OPEN_WORLD` wins, as `ENERGY_POS` does.
    static func fromLaunchArguments(_ arguments: [String] = ProcessInfo.processInfo.arguments) -> WorldID? {
        #if DEBUG
        guard let arg = arguments.last(where: { $0.hasPrefix(openWorldPrefix) }) else { return nil }
        return WorldID(rawValue: String(arg.dropFirst(openWorldPrefix.count)))
        #else
        return nil
        #endif
    }

    static let openWorldPrefix = "OPEN_WORLD="

    /// U0 only: the existing top-level screen (`RootView.Destination` raw value)
    /// that comes closest to this world, until U1/U2 give each world its own
    /// space. Documented in `waves/upgrade/briefs/U0-C-report.md`.
    ///
    /// | world | today | why |
    /// |---|---|---|
    /// | home | mandala | the Bindu lives at the Mandala's centre (`TheCentre`) |
    /// | today | rite | the Daily Rite is Today |
    /// | mandala | mandala | |
    /// | rings | the102 | the Field holds the nine rings and their thresholds |
    /// | herHome | the102 | her room is entered from her seat's doorway in the Field |
    /// | herPresence | rite | her presence and Recognition are met in the Rite |
    /// | climb | the102 | the Climb rises from the Field (`opensClimb`) |
    /// | the33 | mandala | the constellation and the Road are drawn on the Mandala |
    /// | game | mandala | Lalitā's field opens over the Mandala (`opensPlayField`) |
    /// | modes | mandala | the modes door stands in the Mandala's ways-in ring |
    /// | time | rite | the moon, tithi and Nityā are read in the Rite |
    /// | memory | memory | the Portrait |
    /// | well | well | |
    /// | beneath | mandala | the descent opens from the Mandala (`opensDescent`) |
    /// | relationship | the102 | the Field (Field Connections live in Settings) |
    var u0Destination: String {
        switch self {
        case .home, .mandala, .the33, .game, .modes, .beneath: return "mandala"
        case .today, .herPresence, .time:                      return "rite"
        case .rings, .herHome, .climb, .relationship:          return "the102"
        case .memory:                                          return "memory"
        case .well:                                            return "well"
        }
    }

    /// U0: the screen's own existing launch path that this world also opens.
    var opensClimb: Bool { self == .climb }
    var opensPlayField: Bool { self == .game }
    var opensDescent: Bool { self == .beneath }

    /// The sentinel accessibility identifier each world carries once U1 builds
    /// it (V11, V14: exactly one `world.*` sentinel hit-testable at a time).
    var sentinel: String { "world.\(rawValue)" }

    /// The words a voice hears for the world (no quantity, no digit needed).
    var title: String {
        switch self {
        case .home:         return "The Bindu"
        case .today:        return "Today"
        case .mandala:      return "The Mandala"
        case .rings:        return "The nine rings"
        case .herHome:      return "Her Home"
        case .herPresence:  return "Her Presence"
        case .climb:        return "The Climb"
        case .the33:        return "The thirty-three"
        case .game:         return "A Strange Game"
        case .modes:        return "The Modes"
        case .time:         return "Time"
        case .memory:       return "Memory"
        case .well:         return "The Well"
        case .beneath:      return "Beneath"
        case .relationship: return "The Relationship Field"
        }
    }

    /// Where each of the Mandala's ways in leads (seeded from the six-way ring,
    /// `WayIn`, which this registry replaces in U1). The ways keep the spoken
    /// labels their own switches carried.
    static func reached(by way: WayIn) -> WorldID {
        switch way {
        case .constellation, .road: return .the33
        case .modes:                return .modes
        case .field:                return .game
        case .climb:                return .climb
        case .whole:                return .mandala
        }
    }
}
