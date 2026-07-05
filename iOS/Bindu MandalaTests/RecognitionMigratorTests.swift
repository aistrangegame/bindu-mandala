import XCTest
import SwiftData
@testable import Bindu_Mandala

/// The one-time Phase-2 backfill that carries legacy Ring-2 recognitions onto
/// the Khaḍgamālā key without dropping a single moment.
@MainActor
final class RecognitionMigratorTests: XCTestCase {

    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: RecognitionEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    func testLegacyEntryIsBackfilled() throws {
        let context = try makeContext()

        // A pre-Phase-2 entry: only the legacy per-ring position is set.
        let entry = RecognitionEntry(khadgamalaPosition: 0, ringNumber: 0)
        entry.shaktiPosition = 5
        context.insert(entry)
        try context.save()

        RecognitionMigrator.backfillIfNeeded(context: context)

        XCTAssertEqual(entry.khadgamalaPosition, 33, "Ring 2 offset is +28")
        XCTAssertEqual(entry.ringNumber, 2)
        XCTAssertEqual(entry.shaktiPosition, 5, "Legacy field is preserved, not erased")
    }

    func testInvalidLegacyEntryIsLeftAlone() throws {
        let context = try makeContext()
        let entry = RecognitionEntry(khadgamalaPosition: 0, ringNumber: 0)
        // shaftiPosition left at its default 0 — no valid legacy key.
        context.insert(entry)
        try context.save()

        RecognitionMigrator.backfillIfNeeded(context: context)

        XCTAssertEqual(entry.khadgamalaPosition, 0, "The archive refuses to invent a position")
    }

    func testAlreadyMigratedEntryIsUntouched() throws {
        let context = try makeContext()
        let entry = RecognitionEntry(khadgamalaPosition: 42, ringNumber: 3)
        context.insert(entry)
        try context.save()

        RecognitionMigrator.backfillIfNeeded(context: context)

        XCTAssertEqual(entry.khadgamalaPosition, 42)
        XCTAssertEqual(entry.ringNumber, 3)
    }
}
