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

/// Thin façade for private letters.
@MainActor
struct LetterStore {
    let context: ModelContext

    /// The letter for this position if one has ever been saved. A read that
    /// inserts nothing — for opening and display, so merely looking at a
    /// letter never writes a blank row.
    func existingLetter(for position: Int) -> ShaktiLetter? {
        let d = FetchDescriptor<ShaktiLetter>(predicate: #Predicate { $0.shaktiPosition == position })
        return (try? context.fetch(d))?.first
    }

    /// The letter for this position, created on demand — for a save.
    func letter(for position: Int) -> ShaktiLetter {
        if let existing = existingLetter(for: position) { return existing }
        let new = ShaktiLetter(shaktiPosition: position)
        context.insert(new)
        try? context.save()
        return new
    }

    func save(_ letter: ShaktiLetter, body: String) {
        letter.body = body
        letter.updatedAt = .now
        try? context.save()
    }
}
