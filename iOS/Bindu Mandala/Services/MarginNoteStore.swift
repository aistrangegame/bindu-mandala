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
    /// nothing but air is never *saved over* words that are already there —
    /// an emptied field is not an erase instruction while he is still in the
    /// composer, it is an intermediate state between two sentences.
    ///
    /// What it means when he empties the field **and leaves** is a different
    /// question, and ``discard(_:typed:)`` answers it.
    @discardableResult
    func save(_ note: MarginNote, body: String) -> Bool {
        guard !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        if note.modelContext == nil { context.insert(note) }
        note.body = body
        note.updatedAt = .now
        try? context.save()
        return true
    }

    /// He deleted every word and walked out. The note goes.
    ///
    /// **Without this, anything typed becomes permanent two seconds later and
    /// nothing anywhere in the app can take it back.** The autosave inserts the
    /// row after two seconds of quiet; `save` then refuses an emptied body, so
    /// wiping the field leaves the old sentence standing; and there is no delete
    /// this pass. So he opens the margin to say something is broken, starts on
    /// the wrong thought or mistypes, clears it — and the wrong thought is now a
    /// permanent row in his list *and* a permanent row in the ledger. He asked
    /// to *"save it as a new entry"*; he never asked for immutability, and the
    /// screen said empty while the store said otherwise. Leaving is saving here,
    /// and leaving nothing must therefore save nothing.
    ///
    /// **A note that has already reached the ledger is never discarded**, and
    /// that is the line between this and a delete feature. The ledger has only a
    /// POST path in this house, so removing a ledgered note locally would leave
    /// a row nothing can reconcile — and the next restore would bring the note
    /// straight back, which is worse than not deleting it. In the composer the
    /// case cannot arise: `ledgerIfNeeded` runs on the way out, and the sweep
    /// excludes the note he has open. The guard is here because the rule is the
    /// rule, not because the path is reachable.
    @discardableResult
    func discard(_ note: MarginNote, typed body: String) -> Bool {
        guard Self.shouldDiscard(typed: body, ledgeredAt: note.ledgeredAt) else { return false }
        guard note.modelContext != nil else { return false }
        context.delete(note)
        try? context.save()
        return true
    }

    /// The rule itself, pure: nothing but air left in the field, and the note
    /// has never reached the ledger.
    static func shouldDiscard(typed: String, ledgeredAt: Date?) -> Bool {
        typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && ledgeredAt == nil
    }
}
