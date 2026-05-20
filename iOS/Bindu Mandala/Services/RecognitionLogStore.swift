import Foundation
import SwiftData

/// Thin façade over the SwiftData ModelContext for recognition entries.
/// Local-only by construction — the type exists nowhere else.
@MainActor
struct RecognitionLogStore {
    let context: ModelContext

    /// Record a "she was felt here" moment.
    @discardableResult
    func record(position: Int, note: String? = nil, gesture: RecognitionEntry.Gesture = .felt) -> RecognitionEntry {
        let entry = RecognitionEntry(timestamp: .now, shaktiPosition: position, note: note, gesture: gesture)
        context.insert(entry)
        try? context.save()
        return entry
    }

    /// All entries for one Shakti, newest first.
    func entries(for position: Int) -> [RecognitionEntry] {
        var d = FetchDescriptor<RecognitionEntry>(
            predicate: #Predicate { $0.shaktiPosition == position },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        d.fetchLimit = 200
        return (try? context.fetch(d)) ?? []
    }

    /// Most recent entry across all Shaktis.
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

    func letter(for position: Int) -> ShaktiLetter {
        let d = FetchDescriptor<ShaktiLetter>(predicate: #Predicate { $0.shaktiPosition == position })
        if let existing = (try? context.fetch(d))?.first { return existing }
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
