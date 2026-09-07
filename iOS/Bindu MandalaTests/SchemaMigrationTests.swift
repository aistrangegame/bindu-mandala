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
}
