import Foundation

// MARK: - U2 · B · search — "Type one word you're carrying"
//
// `waves/upgrade/worlds/spine-and-home.md` §2 F #50: one field at the
// Constellation's head. It finds every Śakti by four spellings (her name as
// written, the same name with every diacritic folded — `MandalaVoice.romanised`
// — her phonetic line, her short name, and her Devanāgarī where the base
// carries it), every chakra of the 33 (name, Sanskrit, verb), the modes,
// every game, and the fifteen worlds. Results are places, opened by position
// through the Router; never a score, never a rank shown.
//
// Position is identity (law): an entry carries the Śakti's khaḍgamālā
// position and its spellings as data; nothing here finds her *by* a name —
// the query is matched against an entry's `words`, and the entry opens by kp.
// Chakra 32's words stay sealed: it is found by its public identity only.

/// One thing search can find, and where it opens.
struct SpineSearchEntry: Identifiable, Equatable {
    enum Kind: String, CaseIterable {
        case world, shakti, chakra, mode, game
    }

    let kind: Kind
    /// What the result row shows.
    let title: String
    /// Every spelling it answers to, already folded (`SpineSearch.fold`).
    let words: [String]
    /// Where it opens.
    let to: Address

    var id: String { kind.rawValue + "|" + DeepLink.url(for: to).absoluteString }

    /// Does the folded query live in any of its spellings?
    func answers(_ folded: String) -> Bool {
        guard !folded.isEmpty else { return false }
        // Matched on code units, not graphemes: a Devanāgarī query ends where
        // her name runs on (स्पर्श inside स्पर्शाकर्षिणी, the श joined to its ā).
        return words.contains { ($0 as NSString).range(of: folded, options: .literal).location != NSNotFound }
    }
}

/// A Śakti as search reads her: her position and the spellings to fold.
struct SpineSearchShakti: Equatable {
    let kp: Int
    let title: String
    let spellings: [String]
}

/// The index and the query — pure.
enum SpineSearch {

    /// Design's own words for the field (§2 F #50).
    static let prompt = "Type one word you're carrying"

    /// Case-, width- and diacritic-insensitive, spaces and the phonetic
    /// line's dots removed: "Spar · SHAH · kar" and "sparshakar" meet.
    static func fold(_ s: String) -> String {
        let plain = s.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive],
                              locale: Locale(identifier: "en_US_POSIX"))
        return String(plain.unicodeScalars.filter {
            CharacterSet.alphanumerics.contains($0)
        }.map { Character($0) })
    }

    /// All four spellings of a Śakti, folded and de-duplicated.
    static func spellings(of shakti: SpineSearchShakti) -> [String] {
        var out: [String] = []
        for raw in shakti.spellings where !raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            for f in [fold(raw), fold(MandalaVoice.romanised(raw))] where !f.isEmpty && !out.contains(f) {
                out.append(f)
            }
        }
        return out
    }

    /// The fifteen worlds, by the names they are shown and spoken by.
    static var worldEntries: [SpineSearchEntry] {
        WorldID.allCases.map { w in
            let e = WorldRegistry.entry(w)
            var words = [fold(e.displayName), fold(w.title), fold(w.rawValue)]
            if w == .home { words.append(fold("home")) }
            return SpineSearchEntry(kind: .world, title: e.displayName, words: words, to: Address(w))
        }
    }

    /// The 33 by name, Sanskrit and verb — opened as its room in the 33.
    static func chakraEntries(_ chakras: [Chakra33] = ChakraConstellation.all) -> [SpineSearchEntry] {
        chakras.compactMap { c -> SpineSearchEntry? in
            guard Address.chakraRange.contains(c.road) else { return nil }
            var raw = [c.name]
            if let s = c.sanskrit { raw.append(s) }
            if let v = c.verb { raw.append(v) }
            let words = raw.map(fold).filter { !$0.isEmpty }
            return SpineSearchEntry(kind: .chakra, title: c.name, words: words, to: Address(.the33, chakra: c.road))
        }
    }

    /// The modes, by their names and Design's glosses.
    static var modeEntries: [SpineSearchEntry] {
        TheModes.Mode.allCases.map { m in
            SpineSearchEntry(kind: .mode, title: m.title,
                             words: [fold(m.title), fold(MandalaVoice.romanised(m.title)), fold(m.rawValue), fold(m.gloss)],
                             to: Address(.modes, sub: m.rawValue))
        }
    }

    /// Every game, by its own name.
    static var gameEntries: [SpineSearchEntry] {
        PlayGame.allCases.map { g in
            SpineSearchEntry(kind: .game, title: g.title,
                             words: [fold(g.title), fold(MandalaVoice.romanised(g.title)), fold(g.rawValue)],
                             to: Address(.game, sub: g.rawValue))
        }
    }

    /// The 102 — opened by position, as her room in Her Home (§2 E #47's first kp door).
    static func shaktiEntries(_ shaktis: [SpineSearchShakti]) -> [SpineSearchEntry] {
        shaktis.compactMap { s -> SpineSearchEntry? in
            guard Address.kpRange.contains(s.kp) else { return nil }
            return SpineSearchEntry(kind: .shakti, title: s.title, words: spellings(of: s),
                                    to: Address(.herHome, kp: s.kp))
        }
    }

    /// The whole index.
    static func index(shaktis: [SpineSearchShakti], chakras: [Chakra33] = ChakraConstellation.all) -> [SpineSearchEntry] {
        worldEntries + shaktiEntries(shaktis) + chakraEntries(chakras) + modeEntries + gameEntries
    }

    /// What one word finds, in the index's own order (worlds, the 102 in
    /// garland order, the 33 in Road order, modes, games) — an order of
    /// place, never a rank. At most `limit` places.
    static func results(for query: String, in index: [SpineSearchEntry], limit: Int = 24) -> [SpineSearchEntry] {
        let q = fold(query)
        guard !q.isEmpty else { return [] }
        return Array(index.filter { $0.answers(q) }.prefix(limit))
    }
}
