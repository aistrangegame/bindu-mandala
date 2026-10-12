import Foundation
import Observation

/// Wave 6 · the Living Mandala's play-fed layers need to know what was played
/// and where, on the phone. Every game already writes one `Played` row to the
/// ledger (`PlayLedger`); this keeps the same act beside it, locally, so the
/// Portrait can show it as a *state* — the garland strung, roots grown, the
/// seed in bloom — and never as a count. Practice data: atomic JSON, never
/// deleted.
struct PlayTrace: Codable, Equatable {
    /// `PlayGame.rawValue`.
    var game: String
    /// The seat it was played at, when it was hers.
    var position: Int?
    var ring: Int
    var at: Date
}

struct PlayTraceArchive: Codable, Equatable {
    var traces: [PlayTrace] = []
}

@MainActor
@Observable
final class PlayTraceStore {

    static let shared = PlayTraceStore()
    static let fileName = "play-traces"

    let directory: URL
    private(set) var archive = PlayTraceArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(PlayTraceArchive.self, named: Self.fileName, in: directory)
            ?? PlayTraceArchive()
    }

    var traces: [PlayTrace] { archive.traces }

    func note(game: String, position: Int?, ring: Int, at: Date = .now) {
        archive.traces.append(PlayTrace(game: game, position: position, ring: ring, at: at))
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}

// MARK: - The layers' states (pure)

/// What the play-fed layers are, now: each one dormant, or kindled with a
/// warmth that cools by real time since it was last fed. A state of the
/// picture — never a number shown, never a tally of plays.
enum PlayLayers {

    enum Layer: String, CaseIterable {
        /// The bead ring — the Garland game.
        case beads
        /// The root web — the Drum and Root System.
        case roots
        /// The body-map petals — the body's own games.
        case body
        /// The seed bloom — the growing games.
        case seed
        /// The practice wheel — every game, a spoke each.
        case wheel

        /// Which games feed it.
        var games: Set<String> {
            switch self {
            case .beads: return ["rosary"]
            case .roots: return ["drum", "rootSystem"]
            case .body:  return ["pulse", "spineWalk", "coherence", "shakeToClear", "waterLevel"]
            case .seed:  return ["fingerGarden", "rain", "fire"]
            case .wheel: return Set(PlayLayers.wheelOrder)
            }
        }
    }

    /// The wheel's spokes, in the order the games are told.
    static let wheelOrder = ["corridor", "pulse", "spineWalk", "echo", "fingerGarden", "rain",
                             "drum", "rootSystem", "waterLevel", "fire", "shakeToClear", "door",
                             "yantraTrace", "rosary", "bijaTones", "coherence"]

    /// Warmth of a thing last fed `at`: 1 the day it was fed, cooling to an
    /// ember (never zero once kindled) over about two moons.
    static func warmth(lastFed at: Date?, now: Date) -> Double {
        guard let at else { return 0 }
        let days = max(0, now.timeIntervalSince(at) / 86_400)
        return 0.25 + 0.75 * exp(-days / 21)
    }

    /// When the layer was last fed, or nil (dormant).
    static func lastFed(_ layer: Layer, traces: [PlayTrace]) -> Date? {
        traces.filter { layer.games.contains($0.game) }.map(\.at).max()
    }

    /// The seats the Garland has touched — each a bead that holds its light.
    static func beadSeats(traces: [PlayTrace]) -> Set<Int> {
        Set(traces.filter { $0.game == "rosary" }.compactMap(\.position))
    }

    /// Each spoke of the wheel: its game, and when it was last played.
    static func spokes(traces: [PlayTrace]) -> [(game: String, last: Date?)] {
        wheelOrder.map { g in (g, traces.filter { $0.game == g }.map(\.at).max()) }
    }
}
