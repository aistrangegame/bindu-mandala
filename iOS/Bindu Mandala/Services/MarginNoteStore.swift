import Foundation
import SwiftData

/// Thin façade over the SwiftData context for the practitioner's notes, in
/// `LetterStore`'s shape and for the same reasons.
///
/// **No read ever writes.** Opening the composer must leave the store exactly as
/// it found it — a blank row is not a note, and one written on open would put an
/// empty sentence in his list and an empty row in the ledger's way. The insert
/// belongs to ``save(_:body:)``, which is called on the first keystroke that
/// changes anything, and updates that same row thereafter: one note, one row,
/// however many autosaves.
///
/// **There is no counting API here, and there will not be one.** Law 2 forbids
/// the instrument telling him how many notes he has written, and the surest way
/// to keep that true is for the number never to exist: no `count`, no `isEmpty`
/// that a screen could phrase as a quantity, nothing a `Text` could reach.
/// `LawsTests.testTheMarginHandsBackWordsAndNeverACount` fails the day one is
/// added. A *list* of his notes is his own words handed back, which is correct;
/// a count of them is a score.
@MainActor
struct MarginNoteStore {
    let context: ModelContext

    /// Every note, newest first — the order the list reads in, and the only
    /// order it has. Nothing is limited: his words are not rationed.
    func all() -> [MarginNote] {
        let d = FetchDescriptor<MarginNote>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(d)) ?? []
    }

    /// The notes that have never reached the ledger, oldest first, at most
    /// `limit` of them. `limit` is a bound on one sweep's work and is never read
    /// back by anything — nothing here answers *how many*.
    func awaitingLedger(limit: Int) -> [MarginNote] {
        var d = FetchDescriptor<MarginNote>(
            predicate: #Predicate { $0.ledgeredAt == nil },
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        d.fetchLimit = limit
        return (try? context.fetch(d)) ?? []
    }

    /// Which of those a sweep may actually post: not blank, and **not the one
    /// he is still typing into**. Pure, so the rule is proven without a network
    /// — it is the rule that decides whether a half-written sentence becomes the
    /// only copy of a note that ever leaves the phone.
    static func sweepable(_ notes: [MarginNote], openInComposer: UUID?) -> [MarginNote] {
        notes.filter { !$0.isBlank && $0.noteId != openInComposer }
    }

    /// A **transient, unsaved** note the composer may show and type into. It
    /// enters the store only when `save` is called on it, so a composer he
    /// opens and abandons leaves no trace at all.
    func blank() -> MarginNote { MarginNote() }

    /// Write the body. A note becomes real at the moment it has words in it: if
    /// this one is still transient, that is when it is inserted. A body that is
    /// nothing but air is never saved — and a note already saved that is emptied
    /// back to air is left exactly as it was rather than blanked, because the
    /// row he can already see in his list is not something an edit may erase.
    @discardableResult
    func save(_ note: MarginNote, body: String) -> Bool {
        guard !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        if note.modelContext == nil { context.insert(note) }
        note.body = body
        note.updatedAt = .now
        try? context.save()
        return true
    }
}
