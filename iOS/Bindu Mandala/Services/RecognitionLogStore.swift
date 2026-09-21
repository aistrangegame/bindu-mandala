import Foundation
import SwiftData

/// Thin façade over the SwiftData ModelContext for recognition entries.
/// Local-only by construction — the type exists nowhere else.
///
/// Phase 2: the store reads and writes the new Khaḍgamālā key. Pre-Phase-2
/// entries written under the legacy `shaktiPosition` key are picked up by
/// `RecognitionMigrator.backfillIfNeeded` at startup, so by the time any
/// reader queries this store, every entry has a valid `khadgamalaPosition`.
@MainActor
struct RecognitionLogStore {
    let context: ModelContext

    /// Record a "she was felt here" moment. Caller supplies the global
    /// Khaḍgamālā position (1-102) and the ring (1-9, denormalized for
    /// fast per-ring queries from the Portrait).
    @discardableResult
    func record(khadgamalaPosition: Int,
                ringNumber: Int,
                note: String? = nil,
                gesture: RecognitionEntry.Gesture = .felt) -> RecognitionEntry {
        let entry = RecognitionEntry(
            timestamp: .now,
            khadgamalaPosition: khadgamalaPosition,
            ringNumber: ringNumber,
            note: note,
            gesture: gesture
        )
        context.insert(entry)
        try? context.save()
        return entry
    }

    /// All entries for one Śakti by global position, newest first. The limit is
    /// a display bound the caller opts into — the store itself never silently
    /// drops a lifetime of moments (pass `nil`, the default, for the full log).
    func entries(forKhadgamala position: Int, limit: Int? = nil) -> [RecognitionEntry] {
        var d = FetchDescriptor<RecognitionEntry>(
            predicate: #Predicate { $0.khadgamalaPosition == position },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        if let limit { d.fetchLimit = limit }
        return (try? context.fetch(d)) ?? []
    }

    /// Most recent entry across all Śaktis.
    func latest() -> RecognitionEntry? {
        var d = FetchDescriptor<RecognitionEntry>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        d.fetchLimit = 1
        return (try? context.fetch(d))?.first
    }
}

/// Thin façade for private letters, keyed by Khaḍgamālā position (1–102) —
/// every one of the 102 may be written to, not only the 16 Karṣiṇīs.
///
/// **No read ever writes.** Opening a letter that has never been written must
/// leave the store exactly as it found it: a blank row is not a draft, and one
/// written on open would masquerade as one — blocking her letter on the server
/// from ever seeding back, and putting a phantom row in the ledger's way.
@MainActor
struct LetterStore {
    let context: ModelContext

    /// The stored letter for this Khaḍgamālā position, if she has ever been
    /// written to. A pure read: it inserts nothing.
    func existingLetter(for khadgamalaPosition: Int) -> ShaktiLetter? {
        let d = FetchDescriptor<ShaktiLetter>(
            predicate: #Predicate { $0.khadgamalaPosition == khadgamalaPosition }
        )
        return (try? context.fetch(d))?.first
    }

    /// The letter for this position — the stored row when there is one, otherwise
    /// a **transient, unsaved** letter the caller may show and type into. It
    /// enters the store only when `save` is called on it, so a letter that is
    /// merely opened leaves no trace.
    func letter(for khadgamalaPosition: Int) -> ShaktiLetter {
        existingLetter(for: khadgamalaPosition)
            ?? ShaktiLetter(khadgamalaPosition: khadgamalaPosition)
    }

    /// Write the body. A letter becomes real at the moment it has words in it:
    /// if this one is still transient, that is when it is inserted.
    func save(_ letter: ShaktiLetter, body: String) {
        if letter.modelContext == nil { context.insert(letter) }
        letter.body = body
        letter.updatedAt = .now
        try? context.save()
    }
}
