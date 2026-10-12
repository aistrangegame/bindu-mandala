import Foundation

// MARK: - Wave 6 · the raw Codex write (pure)
//
// Bindu Feed's Wave 3 was the first Bindu instrument to write a raw row into
// the **Codex** (`tblDF4OCMcRoxkQjU`) from inside itself; the Mandala is the
// second. What is written is **his note, not an event**: a spoken or typed
// word he asks to become Codex ("leave my own word"), with `Source App` set to
// "Bindu Mandala" and `Status` deliberately left unset, so no downstream Codex
// automation fires unasked (the Feed's carve-out, kept exactly as narrow).
//
// The ledger stays the single event ledger (R17): a Codex note writes no App
// Activity row, and App Activity's vocabulary never appears here. This file is
// pure — shapes, field ids, the dedup match — and `AirtableService` owns the
// HTTP, through the same offline queue that never drops an item.
//
// Field ids read from the live schema, read-only, 12 Oct 2026:
//   Title            fldxmZqObGiIoHHll  singleLineText
//   Date             fldth1fgVdc2HgIyn  date
//   RAW voice memo   fld459YeVBZBgB8zh  richText
//   Source App       fldaii08WVwJQA5qP  singleSelect — "Bindu Mandala" (selhkTEAbJE3DUuce)
//   Status           fldisxPP9sNKMyiYb  singleSelect — never written
enum CodexWrite {

    /// The Codex table, base `app248ZTWhYJlvQj2`.
    static let tableId = "tblDF4OCMcRoxkQjU"

    /// Written by field id, as the Mandala table is read.
    enum FieldID {
        static let title     = "fldxmZqObGiIoHHll"
        static let date      = "fldth1fgVdc2HgIyn"
        static let rawMemo   = "fld459YeVBZBgB8zh"
        static let sourceApp = "fldaii08WVwJQA5qP"
        /// Named so a test can prove it is never written.
        static let status    = "fldisxPP9sNKMyiYb"
    }

    /// This instrument's `Source App` option on the Codex table — a different
    /// field, with a different choice set, from App Activity's `Source App`.
    static let sourceApp = "Bindu Mandala"

    /// How a note came to be.
    enum Spoken: String, Codable { case spoken, typed }

    /// The title a note carries: his first line, as he said it, clipped — the
    /// Codex's own title column is how he will find it there.
    static func title(for body: String) -> String {
        let firstLine = body
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n", omittingEmptySubsequences: true)
            .first.map(String.init) ?? ""
        let t = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
        guard t.count > 80 else { return t.isEmpty ? "A word from the Mandala" : t }
        return String(t.prefix(79)) + "…"
    }

    /// The `fields` of one POST to the Codex. `Status` is never present.
    static func fields(for note: PendingCodexNote, timeZone: TimeZone = .current) -> [String: Any] {
        let body = note.body.trimmingCharacters(in: .whitespacesAndNewlines)
        return [
            FieldID.title:     title(for: body),
            FieldID.date:      ActivityLedger.activityDate(note.at, timeZone: timeZone),
            FieldID.rawMemo:   body,
            FieldID.sourceApp: sourceApp,
        ]
    }

    /// The idempotency read: this instrument's rows on the note's day (a
    /// handful at most). Field ids work inside a formula, as the Mandala
    /// table's own `{fldw33m8YqrINlvrN}` read shows.
    static func dedupFormula(for note: PendingCodexNote, timeZone: TimeZone = .current) -> String {
        let day = ActivityLedger.activityDate(note.at, timeZone: timeZone)
        return "AND({\(FieldID.sourceApp)}='\(sourceApp)', "
            + "DATETIME_FORMAT({\(FieldID.date)}, 'YYYY-MM-DD')='\(day)')"
    }

    /// One Codex row as the dedup read returns it (by field id).
    struct Row: Decodable, Equatable {
        let id: String
        var fields: Fields
        struct Fields: Decodable, Equatable {
            var rawMemo: String? = nil
            enum CodingKeys: String, CodingKey { case rawMemo = "fld459YeVBZBgB8zh" }
        }
    }

    /// Text as a rich-text cell returns it: markdown escapes and trailing
    /// newline folded away, whitespace collapsed — so the same words match.
    static func normalised(_ s: String) -> String {
        var t = s.replacingOccurrences(of: "\\", with: "")
        t = t.replacingOccurrences(of: "\r", with: "")
        let parts = t.split(whereSeparator: { $0 == " " || $0 == "\n" || $0 == "\t" })
        return parts.joined(separator: " ")
    }

    /// Is this row the same note? Same words, after normalising.
    static func rowMatches(_ row: Row, body: String) -> Bool {
        let mine = normalised(body)
        guard !mine.isEmpty, let theirs = row.fields.rawMemo else { return false }
        return normalised(theirs) == mine
    }
}

/// One Codex note waiting to be written — held in UserDefaults until the
/// network returns, never dropped (`PendingQueuePolicy.maxFailures` is nil).
struct PendingCodexNote: Codable, PendingQueueItem, Equatable {
    var id: String = UUID().uuidString
    let body: String
    let at: Date
    var spoken: CodexWrite.Spoken = .typed
    var failCount: Int = 0
}

/// Wave 6 · his Codex notes, kept on the phone as well — the Book's pages and
/// the Month Mirror read them. Practice data: atomic JSON, never deleted.
struct CodexNote: Codable, Equatable, Identifiable {
    var id: UUID
    var body: String
    var at: Date
    var spoken: CodexWrite.Spoken
    /// Where he left it from ("the month", "the book", "the Portrait").
    var origin: String?
    /// His own voice, if he spoke it: a file in `Practice/voice/`.
    var voiceFile: String?
}

struct CodexNoteArchive: Codable, Equatable {
    var notes: [CodexNote] = []
}
