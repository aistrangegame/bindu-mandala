import Foundation

// MARK: - Wave 6.1 · grace, gently: his own gratitude (pure)
//
// His decision (gameplan §4.4, 12 Oct): *"Grace may rarely surface one of your
// own gratitude lines, room-matched, read-only, never counted. Emotions, SJ
// and Anger stay out."*
//
// So this reads exactly one column of exactly one table in the ASG base — the
// Gratitude table's own question, *What are you grateful for today?* — and
// nothing else: not the date, not the people, not the emotional state, not
// Gaia's analysis (which is generated, and her voice is authored, never
// generated). It writes nothing anywhere. The line comes back verbatim, as his
// words, with no date and no number beside it.
//
// **Rarer than grace, never more often.** It may speak only on a day the
// ledger's grace has nothing to return, only outside grace's own rest (the
// two share one rest: when either speaks, both rest), and then only on about
// one such day in three — chosen by the practice day, so a relaunch does not
// roll again. A line once returned is not returned again.
//
// **Room-matched where it can be.** A line that names something of today's
// Śakti — her name, the place in the body she lives, her element, a word of
// her quality — comes first; otherwise any of his lines may come.
enum GratitudeGrace {

    /// The Gratitude table in the ASG base (`app248ZTWhYJlvQj2`), read only.
    static let tableId = "tblEFiuFIijKe9ba6"
    /// *What are you grateful for today?* — his own words. The one column read.
    static let wordsFieldId = "fld85STU49AtREkfe"
    /// The same column by name, for the filter formula (Airtable formulas
    /// address columns by name).
    static let wordsFieldName = "What are you grateful for today? ⚡"

    /// Only rows he actually wrote in.
    static var formula: String { "LEN({\(wordsFieldName)}) > 0" }

    /// The prefix under which a returned line is remembered among grace's
    /// surfaced rows (a per-phone convenience; never a record).
    static let surfacedPrefix = "gratitude:"

    /// About one eligible day in this many.
    static let oneDayIn = 3

    /// The longest line returned — longer words are cut at a sentence.
    static let maxLength = 220

    struct Row: Decodable, Equatable {
        let id: String
        var fields: Fields
        struct Fields: Decodable, Equatable {
            var words: String? = nil
            enum CodingKeys: String, CodingKey { case words = "fld85STU49AtREkfe" }
        }
    }

    /// Whether today is one of the rare days it may speak at all.
    static func maySpeak(practiceDay: Int) -> Bool {
        // A fixed scatter of the day number, so the days are not a visible rhythm.
        let mixed = (practiceDay &* 2_654_435_761) & 0x7fff_ffff
        return mixed % oneDayIn == 0
    }

    /// The words of her room a line may meet: her names, her body's place,
    /// her element, the words of her quality — lower-cased, without marks,
    /// four letters or more, and never the small words every line has.
    static func roomWords(name: String, shortName: String, bodilyLocation: String,
                          tattva: String, quality: String) -> Set<String> {
        var out: Set<String> = []
        for text in [name, shortName, bodilyLocation, tattva, quality] {
            for w in words(of: text) where w.count >= 4 && !common.contains(w) { out.insert(w) }
        }
        return out
    }

    private static let common: Set<String> = [
        "that", "this", "with", "what", "where", "when", "who", "whom", "from", "into",
        "attracts", "sarva", "your", "have", "been", "them", "they", "there", "their",
    ]

    static func words(of text: String) -> [String] {
        text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
            .lowercased()
            .split(whereSeparator: { !$0.isLetter })
            .map(String.init)
    }

    /// Choose his one line, or none.
    static func choose(rows: [Row], roomWords: Set<String>, practiceDay: Int,
                       surfaced: Set<String>) -> GraceChannel.Line? {
        guard maySpeak(practiceDay: practiceDay) else { return nil }
        let fresh = rows.compactMap { row -> (id: String, text: String)? in
            guard !surfaced.contains(surfacedPrefix + row.id),
                  let raw = row.fields.words,
                  let text = trimmed(raw) else { return nil }
            return (row.id, text)
        }
        guard !fresh.isEmpty else { return nil }
        let matched = fresh.filter { !Set(words(of: $0.text)).isDisjoint(with: roomWords) }
        let pool = matched.isEmpty ? fresh : matched
        let sorted = pool.sorted { $0.id < $1.id }
        let pick = sorted[abs(practiceDay) % sorted.count]
        return GraceChannel.Line(rowId: surfacedPrefix + pick.id, text: pick.text)
    }

    /// His words, whitespace folded, cut at a sentence if long. Nil if empty.
    static func trimmed(_ raw: String) -> String? {
        let parts = raw.split(whereSeparator: { $0 == " " || $0 == "\n" || $0 == "\t" || $0 == "\r" })
        let text = parts.joined(separator: " ")
        guard !text.isEmpty else { return nil }
        guard text.count > maxLength else { return text }
        let head = String(text.prefix(maxLength))
        if let end = head.lastIndex(where: { $0 == "." || $0 == "!" || $0 == "?" }),
           head.distance(from: head.startIndex, to: end) > 40 {
            return String(head[...end])
        }
        return head.trimmingCharacters(in: .whitespaces) + "…"
    }
}
