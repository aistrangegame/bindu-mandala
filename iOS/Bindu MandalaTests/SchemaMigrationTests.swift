import XCTest
import SwiftData
@testable import Bindu_Mandala

/// The durability guard: a versioned container must open, round-trip, and reopen
/// **without ever firing the preserve-and-recover (store-wipe) path** on a clean store.
@MainActor
final class SchemaMigrationTests: XCTestCase {

    private func freshStoreURL() -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("bindu-schema-test-\(UUID().uuidString)", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("default.store")
    }

    /// Headline anti-wipe proof: open the versioned container, add data, then reopen
    /// at the same store — every row survives AND no `*.corrupt-*` sidecar appears
    /// (the preserve-and-recover path never fired).
    func testReopenKeepsDataAndNeverPreserves() throws {
        let url = freshStoreURL()

        do {
            let container = PersistenceRecovery.makeContainer(storeURL: url)
            let ctx = ModelContext(container)
            ctx.insert(DescentState(currentRing: 5, deepestReached: 5,
                                    crossings: [Date(timeIntervalSince1970: 1000)]))
            ctx.insert(ShaktiLetter(khadgamalaPosition: 3, body: "a letter that must survive"))
            try ctx.save()
        }

        let container2 = PersistenceRecovery.makeContainer(storeURL: url)
        let ctx2 = ModelContext(container2)
        let states = try ctx2.fetch(FetchDescriptor<DescentState>())
        let letters = try ctx2.fetch(FetchDescriptor<ShaktiLetter>())

        XCTAssertEqual(states.count, 1)
        XCTAssertEqual(states.first?.deepestReached, 5)
        XCTAssertEqual(letters.first?.body, "a letter that must survive")

        let dir = url.deletingLastPathComponent()
        let files = (try? FileManager.default.contentsOfDirectory(atPath: dir.path)) ?? []
        XCTAssertFalse(files.contains { $0.contains(".corrupt-") },
                       "A clean reopen must not preserve/wipe the store — found: \(files)")
    }

    /// A brand-new store opens on the versioned plan without error and is empty.
    func testFreshStoreOpensEmpty() throws {
        let container = PersistenceRecovery.makeContainer(storeURL: freshStoreURL())
        let ctx = ModelContext(container)
        XCTAssertEqual(try ctx.fetch(FetchDescriptor<DescentState>()).count, 0)
    }

    // MARK: - V2 → V3 · the margin arrives, and nothing that exists moves
    //
    // **This is the check that would have caught the one dangerous way to build
    // this.** `MarginNote` could have been added to `BinduSchemaV2.models` in
    // place — one line, no new version, and green on a fresh simulator forever.
    // On the phone it would have been a silent catastrophe: build 58's store is
    // at V2 *as V2 was defined then*, the code's V2 would no longer describe it,
    // step 1 of `PersistenceRecovery.makeContainer` would throw, and **step 2
    // would move the whole store aside and open an empty one.** Letters and
    // recognitions come back from Airtable; `HomeMemory` cannot — it is
    // phone-only by R17 and is never synced — so every room's accumulated dwell,
    // visit softening and deepest adaptation would be gone on a launch where
    // nothing reported an error. A charter §7 halt condition.
    //
    // So the assertion that matters is the last one in each test: the preserve
    // path was **never taken**.

    /// Write a real store on disk at V2 — letters, recognitions, home memories,
    /// the descent — then reopen it the way the app opens it. Every row
    /// survives, the margin arrives empty, and nothing was set aside.
    func testAV2StoreOnDiskArrivesAtV3WithEveryRowIntact() throws {
        let url = freshStoreURL()

        do {
            let v2 = Schema(BinduSchemaV2.models, version: BinduSchemaV2.versionIdentifier)
            let container = try ModelContainer(
                for: v2, migrationPlan: BinduMigrationPlan.self,
                configurations: ModelConfiguration(schema: v2, url: url))
            let ctx = ModelContext(container)
            ctx.insert(ShaktiLetter(khadgamalaPosition: 29, body: "her words, which must survive"))
            ctx.insert(ShaktiLetter(khadgamalaPosition: 44, body: "and these"))
            ctx.insert(RecognitionEntry(timestamp: Date(timeIntervalSince1970: 5000),
                                        khadgamalaPosition: 33, ringNumber: 2,
                                        note: "she was felt here", gesture: .felt))
            ctx.insert(HomeMemory(khadgamalaPosition: 33, visits: 7,
                                  accumulatedDwell: 412, longestDwell: 190,
                                  lastDwell: 80, lastVisit: Date(timeIntervalSince1970: 6000),
                                  deepestAdaptation: 2))
            ctx.insert(DescentState(currentRing: 4, deepestReached: 4,
                                    crossings: [Date(timeIntervalSince1970: 1000)]))
            try ctx.save()
        }

        // …and now the app opens it, at the latest version, through the plan.
        let container = PersistenceRecovery.makeContainer(storeURL: url)
        let ctx = ModelContext(container)

        let letters = try ctx.fetch(FetchDescriptor<ShaktiLetter>())
            .sorted { $0.khadgamalaPosition < $1.khadgamalaPosition }
        XCTAssertEqual(letters.map(\.khadgamalaPosition), [29, 44])
        XCTAssertEqual(letters.map(\.body), ["her words, which must survive", "and these"])

        let felt = try ctx.fetch(FetchDescriptor<RecognitionEntry>())
        XCTAssertEqual(felt.count, 1)
        XCTAssertEqual(felt.first?.khadgamalaPosition, 33)

        // The one thing that can never be restored from anywhere.
        let remembered = try ctx.fetch(FetchDescriptor<HomeMemory>())
        XCTAssertEqual(remembered.count, 1, "HomeMemory is phone-only — if it is gone, it is gone")
        XCTAssertEqual(remembered.first?.visits, 7)
        XCTAssertEqual(remembered.first?.accumulatedDwell, 412)
        XCTAssertEqual(remembered.first?.deepestAdaptation, 2)

        XCTAssertEqual(try ctx.fetch(FetchDescriptor<DescentState>()).first?.deepestReached, 4)

        XCTAssertTrue(try ctx.fetch(FetchDescriptor<MarginNote>()).isEmpty,
                      "the margin arrives as one more, empty table")

        assertNothingWasPreserved(beside: url,
                                  "a V2 store must migrate in place — the preserve path is a wipe")
    }

    /// The reopen is idempotent: a V3 store opens again as a V3 store, with the
    /// margin he has since written still in it.
    func testAV3StoreReopensWithItsMargin() throws {
        let url = freshStoreURL()
        do {
            let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
            ctx.insert(MarginNote(body: "the descent is hard to leave",
                                  createdAt: Date(timeIntervalSince1970: 7000)))
            try ctx.save()
        }
        let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
        XCTAssertEqual(try ctx.fetch(FetchDescriptor<MarginNote>()).map(\.body),
                       ["the descent is hard to leave"])
        assertNothingWasPreserved(beside: url, "a clean V3 reopen must not set the store aside")
    }

    /// The plan's own shape, pinned. A shipped version's model list is **never**
    /// mutated: V2 is what build 58's store is, byte for byte, and the margin
    /// belongs to a version of its own.
    func testTheShippedVersionsAreNeverMutated() {
        XCTAssertEqual(BinduSchema.latest.versionIdentifier, Schema.Version(3, 0, 0))
        XCTAssertEqual(BinduMigrationPlan.schemas.count, 3)
        XCTAssertEqual(BinduMigrationPlan.stages.count, 2)

        let names = { (models: [any PersistentModel.Type]) in Set(models.map { "\($0)" }) }
        XCTAssertFalse(names(BinduSchemaV2.models).contains("MarginNote"),
                       """
                       MarginNote has been added to a version that is already on his phone. \
                       The code's V2 and the store's V2 are now different schemas, the container \
                       init will throw, and PersistenceRecovery will move his store aside and \
                       open an empty one — taking every room's HomeMemory with it, which nothing \
                       can restore. Add a version; never mutate a shipped one.
                       """)
        XCTAssertTrue(names(BinduSchemaV3.models).contains("MarginNote"))
        XCTAssertEqual(names(BinduSchemaV3.models).subtracting(names(BinduSchemaV2.models)),
                       ["MarginNote"],
                       "V3 is V2 plus one new entity and nothing else — that is what makes it lightweight")
    }

    private func assertNothingWasPreserved(beside url: URL, _ message: String,
                                           file: StaticString = #filePath, line: UInt = #line) {
        let dir = url.deletingLastPathComponent()
        let files = (try? FileManager.default.contentsOfDirectory(atPath: dir.path)) ?? []
        XCTAssertFalse(files.contains { $0.contains(".corrupt-") },
                       "\(message) — found: \(files)", file: file, line: line)
    }
}
