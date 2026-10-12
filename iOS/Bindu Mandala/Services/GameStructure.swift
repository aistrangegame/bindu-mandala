import Foundation

// MARK: - Wave 6 · B · the game's own structure, as he wrote it
//
// `Data/GameStructure.json` is baked by `waves/wave-6/bake_game_structure.py`
// from the ASG base, read-only: the nine Tree of Life panel declarations
// (Identity · "Tree of Life Panel") with each ring's seed message (The Map ·
// Panel Seed Message), the five faces of the Trinity of Guidance (Identity ·
// Archetype), the practice declarations, and the Leela drops — each two exact
// substrings of one Map row's Leela Story.
//
// Nothing here composes a line. Every string the walker reads from this file
// is one of his own, verbatim; the script files each under the record it was
// copied from and can re-prove it against the live row (`--verify`).

/// One panel of the Tree of Life — one āvaraṇa.
struct TreeOfLifePanel: Decodable, Equatable {
    let ring: Int
    /// The ring's verb: Press, Follow, Build, Open, Speak, Still, Receive, Hold, Dissolve.
    let verb: String
    /// His own declaration for the panel.
    let declaration: String
    /// The panel's seed message (The Map).
    let seed: String
}

/// One face of the Trinity of Guidance and her one line.
struct GuideFaceLine: Decodable, Equatable {
    let face: String
    let name: String
    let line: String
}

/// One of his practice declarations.
struct PracticeLine: Decodable, Equatable {
    let key: String
    let name: String
    let line: String
}

/// One Leela drop: a lead, and the real-world action it ends in.
struct LeelaDrop: Decodable, Equatable, Identifiable {
    let id: String
    /// The Map chakra the words were drawn from (provenance, never shown).
    let chakra: String
    /// The face the row is spoken in — its light, never a name on screen.
    let voice: String
    let lead: String
    let action: String
}

/// The bake, loaded once.
enum GameStructure {

    static let resourceName = "GameStructure"

    struct File: Decodable {
        let panels: [TreeOfLifePanel]
        let faces: [GuideFaceLine]
        let practices: [PracticeLine]
        let leelaDrops: [LeelaDrop]

        static let empty = File(panels: [], faces: [], practices: [], leelaDrops: [])
    }

    /// The whole file. Empty — never a crash — when the bundle has lost it.
    static let file: File = load(bundle: .main)

    static func load(bundle: Bundle) -> File {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return .empty }
        return decode(data)
    }

    static func decode(_ data: Data) -> File {
        (try? JSONDecoder().decode(File.self, from: data)) ?? .empty
    }

    // MARK: Reading it

    /// Ring `1…9`'s panel.
    static func panel(ring: Int) -> TreeOfLifePanel? {
        file.panels.first { $0.ring == ring }
    }

    /// A face's one line.
    static func line(for face: GuideFace) -> String? {
        file.faces.first { $0.face == face.rawValue }?.line
    }

    static func practice(_ key: String) -> PracticeLine? {
        file.practices.first { $0.key == key }
    }

    static var leelaDrops: [LeelaDrop] { file.leelaDrops }
}
