import XCTest
import SwiftData
@testable import Bindu_Mandala

/// The R11 dwell's entry point writes the local `.silence` entry first, keyed
/// by her Khaḍgamālā position and ring. The ledger half is fire-and-forget
/// behind it and, in the test host, returns at the sync flag — so what these
/// tests see is exactly what the practitioner's device holds offline.
@MainActor
final class SilenceDwellTests: XCTestCase {

    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: RecognitionEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    private func makeShakti(name: String, position: Int, kp: Int?, ring: Int?) -> Shakti {
        let s = Shakti(position: position, name: name, shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: .inner, status: .mapped)
        s.khadgamalaPosition = kp
        s.ringNumber = ring
        return s
    }

    func testDwellRecordsOneSilenceEntryOnHerPositionAndRing() throws {
        let context = try makeContext()
        let her = makeShakti(name: "Sarva-Sammohinī", position: 6, kp: 70, ring: 5)

        SilenceDwell.record(shakti: her, durationSec: 93.5, context: context)

        let entries = try context.fetch(FetchDescriptor<RecognitionEntry>())
        XCTAssertEqual(entries.count, 1, "one dwell, one entry")
        let entry = try XCTUnwrap(entries.first)
        XCTAssertEqual(entry.gesture, .silence)
        XCTAssertEqual(entry.khadgamalaPosition, 70)
        XCTAssertEqual(entry.ringNumber, 5)
        XCTAssertNil(entry.note, "a silence carries no words")
        XCTAssertEqual(entry.shaktiPosition, 0, "new writers leave the legacy key alone")
        XCTAssertLessThan(abs(entry.timestamp.timeIntervalSinceNow), 5, "stamped now")
    }

    func testPreSyncRingTwoSeatFallsBackToTheKhadgamalaOffset() throws {
        let context = try makeContext()
        // A bootstrap Karṣiṇī that sync has not yet keyed: per-ring index only.
        let her = makeShakti(name: "Nāmākarṣiṇī", position: 5, kp: nil, ring: nil)

        SilenceDwell.record(shakti: her, durationSec: 62, context: context)

        let entry = try XCTUnwrap(context.fetch(FetchDescriptor<RecognitionEntry>()).first)
        XCTAssertEqual(entry.gesture, .silence)
        XCTAssertEqual(entry.khadgamalaPosition, 33, "Ring 2 offset is +28")
        XCTAssertEqual(entry.ringNumber, 2, "the ring follows the Khaḍgamālā key")
    }

    func testEachDwellIsItsOwnEntry() throws {
        let context = try makeContext()
        let her = makeShakti(name: "Bindu", position: 1, kp: 102, ring: 9)

        SilenceDwell.record(shakti: her, durationSec: 120, context: context)
        SilenceDwell.record(shakti: her, durationSec: 240, context: context)

        let entries = try context.fetch(FetchDescriptor<RecognitionEntry>())
        XCTAssertEqual(entries.count, 2, "once-per-visit is the caller's rule, not the store's")
        XCTAssertTrue(entries.allSatisfy { $0.gesture == .silence && $0.khadgamalaPosition == 102 })
    }

    func testTheDwellNeverWritesAFeltEntry() throws {
        let context = try makeContext()
        let her = makeShakti(name: "Sparśākarṣiṇī", position: 1, kp: 29, ring: 2)

        SilenceDwell.record(shakti: her, durationSec: 75, context: context)

        let felt = try context.fetch(FetchDescriptor<RecognitionEntry>())
            .filter { $0.gesture == .felt }
        XCTAssertTrue(felt.isEmpty, "a silence is held, not a recognition tapped")
    }
}
