import Foundation
import SwiftData

/// A note left in the margin of the instrument — what the practitioner saw and
/// wanted said, in his own words, written from Settings and kept.
///
/// It is **authored content**, not a practice event. Recognitions, crossings,
/// silences and dwells are the instrument watching him walk, and law 2 forbids
/// counting those back to him; a note is the thing he made, in the same category
/// as a letter, which may run to a hundred lines without measuring anything.
/// So a *list* of notes is his own words handed back and is correct — a count,
/// a badge, an ordinal, "your twelfth note", is the law broken. Nothing in this
/// type, in ``MarginNoteStore``, or in either screen that shows it, counts.
///
/// **The local row is the record, and it is also the queue.** His words are
/// never lost because the network was down: the note is saved here on the first
/// keystroke that changes it and appears in his list at once, and the ledger row
/// follows when a token answers. ``ledgeredAt`` is stamped only on a confirmed
/// create, so a note that has never reached App Activity is found again by
/// `AirtableService.flushUnledgeredNotes` on every later sync — for a note the
/// ledger row is the *only* copy that will ever leave the phone, so the
/// three-strike UserDefaults queue (whose own justification is that "local
/// SwiftData is already canonical, so the only loss is the Airtable mirror")
/// is the wrong queue for it and is not used.
///
/// Identity is a local `UUID`. *Position is identity* governs the 102 seats of
/// the khaḍgamālā; a note is not a seat, and there is no natural key for a
/// sentence. Every stored property is defaulted or optional, and the whole
/// entity is new — which is what makes `BinduSchemaV2 → V3` a **lightweight**
/// stage with nothing to rewrite (see `BinduSchema.swift`).
@Model
final class MarginNote {

    /// Local identity. Never shown, never spoken, never sent.
    ///
    /// Named `noteId` rather than `id`: `PersistentModel` already vends an `id`
    /// (its `persistentModelID`) to satisfy `Identifiable`, and a stored
    /// property of the same name would shadow it for every `ForEach` and
    /// `navigationDestination(item:)` in the tree.
    @Attribute(.unique) var noteId: UUID

    /// His words, exactly as typed. The one field that is his.
    var body: String

    /// When the note was first written. This — never the flush time — is the
    /// instant the ledger row carries, so a note queued offline for three days
    /// still lands on the day he wrote it.
    var createdAt: Date

    /// When it was last edited in the composer it was written in.
    var updatedAt: Date

    /// When App Activity confirmed the row. `nil` means it has never reached the
    /// ledger and the next sync must try again.
    var ledgeredAt: Date?

    init(noteId: UUID = UUID(),
         body: String = "",
         createdAt: Date = .now,
         updatedAt: Date = .now,
         ledgeredAt: Date? = nil) {
        self.noteId = noteId
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.ledgeredAt = ledgeredAt
    }
}

extension MarginNote {
    /// His words with the surrounding air taken off — the form that is saved,
    /// posted and compared. A note whose trim is empty is not a note.
    var trimmedBody: String {
        body.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// True when there is nothing in it but air.
    var isBlank: Bool { trimmedBody.isEmpty }
}
