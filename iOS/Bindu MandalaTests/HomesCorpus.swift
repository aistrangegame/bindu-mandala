import Foundation
@testable import Bindu_Mandala

// MARK: - The corpus the Homes suites are asked against
//
// **One corpus, not three.** `HomeGrammarTests` and `HomesHarnessTests` each
// need all 102 rooms, and each had begun to carry its own synthetic roster.
// They are unified here: this is the single place a Śakti row is made up, so a
// check that passes in one suite cannot be passing against different data in
// the other.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY EIGHTY-SIX OF THEM ARE SYNTHETIC, AND WHAT THAT COSTS
// ─────────────────────────────────────────────────────────────────────────────
//
// Only the sixteen Karṣiṇīs of Ring 2 ship inside the binary. The other
// eighty-six live in Airtable and nowhere else, and bundling a 102-card table
// to test against would be the ghost roster the laws exist to prevent — the app
// would then be asserting against a copy Code typed out rather than against the
// base.
//
// So the eighty-six are built from real tattva **vocabulary** — the words the
// cards speak — keyed off position and nothing else. That is honest about what
// it proves and what it does not:
//
//   · Ring 2 is **real**. Its sixteen rows are the ones the app ships and syncs,
//     and a check that passes there has passed against the base's own data.
//   · Rings 1 and 3–9 are **synthetic**, and their rows are derived from
//     position. A divergence check over them is therefore weaker evidence than
//     it looks: position-derived rows differ *because* position differs. The
//     value is in the shape of the failure when one appears, not in the green.
//
// Every failure message in the suites says which half a Śakti came from, so a
// finding can be weighed without reading this file.

enum HomesCorpus {

    // MARK: - The vocabulary

    /// Tattva vocabulary as the cards actually speak it — elements, powers,
    /// senses, principles, and a handful the classifier has no rule for, so the
    /// fall-through stays honest.
    static let syntheticTattvas: [String] = [
        "Pṛthivī (Earth)", "Āpas (Water)", "Tejas (Fire)", "Vāyu (Air)", "Ākāśa (Ether)",
        "Icchā Śakti", "Kriyā Śakti", "Jñāna Śakti",
        "Śrotra (hearing)", "Tvak (skin)", "Cakṣus (sight)", "Jihvā (tongue)", "Ghrāṇa (scent)",
        "Ahaṅkāra", "Buddhi", "Manas", "Citta",
        "Ānanda", "Amṛta", "Smṛti", "Nāma", "Ātman",
        "Māyā", "Kāla", "Niyati", "Rāga", "Vidyā", "Kalā",
        "Bīja", "Yoni", "Pūrṇa", "Sthiti",
        "Saundarya", "Maṅgala", "Ārogya", "Rañjana", "Dhairya", "Kula", "Aiśvarya", "Saṃyama",
        "Pralaya", "Kṣobha", "Ākarṣaṇa", "Moha", "Advaita", "Vega", "Pāśa", "Aṅkuśa",
        "Viraha", "Rekhā", "Stambha", "Vikāsa", "Mahat", "Aṇu", "Dravatva", "Ādhāra",
        "Śarīra", "Duḥkha", "Totality", "Spanda", "Vimarśa", "Unmeṣa", "Nimeṣa",
        "Sampradāya", "Saṃskāra", "Vṛtti", "Guṇa", "Bindu-tattva",
    ]

    /// Body-location vocabulary, as `Shakti.bodilyLocation` carries it.
    static let syntheticLocations: [String] = [
        "soles", "belly", "solar plexus", "waist", "diaphragm", "heart", "throat",
        "eyes", "forehead", "crown", "spine", "whole body", "skin", "the hands",
    ]

    // MARK: - One row

    /// The four fields every Homes layer reads off a Śakti row, plus where the
    /// row came from, so a failure can name its own evidence.
    struct Row: Equatable {
        let position: Int
        let ring: Int
        let tattva: String
        let quality: String
        let bodilyLocation: String
        let bija: String?
        /// `true` for the sixteen that genuinely ship and sync.
        let isReal: Bool

        var provenance: String { isReal ? "real" : "synthetic" }
    }

    /// A synthetic row for a position outside the sixteen.
    ///
    /// Her khaḍgamālā position is the only key, so nothing else is needed. Her
    /// quality is composed from her own vocabulary rather than copied from a
    /// card — the words are real words, the sentence is not anybody's name.
    static func syntheticRow(position pos: Int) -> Row {
        let tattva = syntheticTattvas[(pos - 1) % syntheticTattvas.count]
        let location = syntheticLocations[(pos * 5 - 1) % syntheticLocations.count]
        return Row(position: pos,
                   ring: KhadgamalaMap.ringNumber(forKhadgamala: pos),
                   tattva: tattva,
                   quality: "She who holds the \(tattva.lowercased()) of the \(location)",
                   bodilyLocation: location,
                   // A few carry a seed syllable, as the base has them; most do not.
                   bija: pos % 7 == 0 ? "aṃ" : nil,
                   isReal: false)
    }

    /// The sixteen that ship in the binary, at their khaḍgamālā positions.
    static func karsiniRows() -> [Row] {
        ShaktiBootstrap.all.map { s in
            let pos = KhadgamalaMap.ringStartOffset(2) + s.position
            return Row(position: pos,
                       ring: KhadgamalaMap.ringNumber(forKhadgamala: pos),
                       tattva: s.tattva,
                       quality: s.quality,
                       bodilyLocation: s.bodilyLocation,
                       bija: s.bijaSyllable,
                       isReal: true)
        }
    }

    /// All 102 rows, in khaḍgamālā order: the sixteen real ones where they
    /// stand, synthetic rows everywhere else.
    static func rows() -> [Row] {
        let real = Dictionary(uniqueKeysWithValues: karsiniRows().map { ($0.position, $0) })
        return (1...KhadgamalaMap.total).map { real[$0] ?? syntheticRow(position: $0) }
    }

    /// Every room the **grammar** speaks for. Ring 9 is absent by design — the
    /// Bindu's room is authored — so there are 101, not 102.
    static func readings() -> [HomeGrammar.Reading] {
        rows().compactMap {
            HomeGrammar.read(position: $0.position, ring: $0.ring, tattva: $0.tattva,
                             quality: $0.quality, bodilyLocation: $0.bodilyLocation,
                             bija: $0.bija)
        }
    }

    /// Every room the **resolution order** produces — all 102, whichever of the
    /// three branches each one landed on.
    static func resolvedRooms() -> [(row: Row, room: HomeRoom)] {
        rows().compactMap { row in
            guard let room = HomeRooms.resolve(position: row.position, ring: row.ring,
                                               tattva: row.tattva, quality: row.quality,
                                               bodilyLocation: row.bodilyLocation,
                                               bija: row.bija) else { return nil }
            return (row: row, room: room)
        }
    }
}
