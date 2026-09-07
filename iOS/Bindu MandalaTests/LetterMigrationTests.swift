import XCTest
import SwiftData
@testable import Bindu_Mandala

/// Schema V1 → V2: every letter carried off the Ring-2 per-ring key (1–16) and
/// onto the Khaḍgamālā key (29–44), word for word.
///
/// The words in a letter are the practitioner's alone, so the bar here is not
/// "a row survived" but "the bytes survived": body identical to the byte, the
/// hour she last wrote it unchanged, and no store quietly set aside and
/// replaced with an empty one along the way.
///
/// Deterministic and offline — a real store on disk under a temp directory,
/// opened through the app's own `PersistenceRecovery`, no network anywhere.
@MainActor
final class LetterMigrationTests: XCTestCase {

    private var directories: [URL] = []

    override func tearDown() {
        for dir in directories { try? FileManager.default.removeItem(at: dir) }
        directories = []
        super.tearDown()
    }

    private func freshStoreURL() -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("bindu-letter-migration-\(UUID().uuidString)", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        directories.append(dir)
        return dir.appendingPathComponent("default.store")
    }

    /// Did the recovery path fire? A `*.corrupt-*` sidecar next to the store is
    /// the fingerprint of a migration that failed and got wiped past.
    private func preservedStoreExists(beside url: URL) -> Bool {
        let dir = url.deletingLastPathComponent()
        let files = (try? FileManager.default.contentsOfDirectory(atPath: dir.path)) ?? []
        return files.contains { $0.contains(".corrupt-") }
    }

    /// Write a store on disk at V1 exactly as a pre-Phase-2.1 build left it.
    private func writeV1Store(at url: URL, letters: [(position: Int, body: String, updatedAt: Date)]) throws {
        let schema = Schema(BinduSchemaV1.models, version: BinduSchemaV1.versionIdentifier)
        let container = try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(schema: schema, url: url)
        )
        let ctx = ModelContext(container)
        for l in letters {
            ctx.insert(BinduSchemaV1.ShaktiLetter(shaktiPosition: l.position,
                                                  body: l.body,
                                                  updatedAt: l.updatedAt))
        }
        try ctx.save()
    }

    // MARK: - The headline: a V1 store's letters arrive intact at V2

    func testV1LettersMigrateOntoKhadgamalaKey() throws {
        let url = freshStoreURL()

        // An empty one, a written one, one ending in a newline, and one whose
        // last character is a space — the shapes a trimming bug would eat.
        let emptyBody = ""
        let writtenBody = "I lie you too"
        let newlineBody = "Mnanakarisini\n"
        let trailingSpaceBody = String(repeating: "a", count: 68) + " "
        XCTAssertEqual(trailingSpaceBody.count, 69, "The 69th character must be the space itself")

        let t1 = Date(timeIntervalSince1970: 1_000_000)
        let t11 = Date(timeIntervalSince1970: 1_111_111)
        let t12 = Date(timeIntervalSince1970: 1_222_222)
        let t16 = Date(timeIntervalSince1970: 1_333_333)

        try writeV1Store(at: url, letters: [
            (1,  emptyBody,          t1),
            (11, writtenBody,        t11),
            (12, newlineBody,        t12),
            (16, trailingSpaceBody,  t16),
        ])

        // Reopen through the app's own door: latest schema + BinduMigrationPlan.
        let container = PersistenceRecovery.makeContainer(storeURL: url)
        let ctx = ModelContext(container)
        let letters = try ctx.fetch(
            FetchDescriptor<ShaktiLetter>(sortBy: [SortDescriptor(\.khadgamalaPosition)])
        )

        XCTAssertFalse(preservedStoreExists(beside: url),
                       "A migration, not a wipe — no store may be set aside here")
        XCTAssertEqual(letters.count, 4, "Four letters went in; four must come out")
        XCTAssertEqual(letters.map(\.khadgamalaPosition), [29, 39, 40, 44],
                       "Ring 2 is Khaḍgamālā 29–44: legacy n maps to n + 28")

        // Byte-identical bodies, in mapped order.
        let expected = [emptyBody, writtenBody, newlineBody, trailingSpaceBody]
        for (letter, body) in zip(letters, expected) {
            XCTAssertEqual(letter.body, body, "Body changed at kp \(letter.khadgamalaPosition)")
            XCTAssertEqual(Array(letter.body.utf8), Array(body.utf8),
                           "Body is not byte-identical at kp \(letter.khadgamalaPosition)")
        }
        XCTAssertEqual(letters[3].body.count, 69)
        XCTAssertTrue(letters[3].body.hasSuffix(" "), "The trailing space must survive untrimmed")

        // The hour she last wrote is hers, not the migration's.
        XCTAssertEqual(letters.map(\.updatedAt), [t1, t11, t12, t16])

        // Provenance: the legacy per-ring key rides along beside the new one.
        XCTAssertEqual(letters.map(\.shaktiPosition), [1, 11, 12, 16])
    }

    /// Reopening a store that is already at V2 must not re-run the stage —
    /// a second pass over an emptied stash would delete every letter.
    func testSecondReopenLeavesMigratedLettersAlone() throws {
        let url = freshStoreURL()
        try writeV1Store(at: url, letters: [(4, "her words", Date(timeIntervalSince1970: 900_000))])

        do {
            let first = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
            XCTAssertEqual(try first.fetch(FetchDescriptor<ShaktiLetter>()).count, 1)
        }

        let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
        let letters = try ctx.fetch(FetchDescriptor<ShaktiLetter>())

        XCTAssertEqual(letters.count, 1)
        XCTAssertEqual(letters.first?.khadgamalaPosition, 32)
        XCTAssertEqual(letters.first?.body, "her words")
        XCTAssertFalse(preservedStoreExists(beside: url))
    }

    // MARK: - A store born at V2

    /// A brand-new store opens straight at the latest schema — no stage runs,
    /// nothing is preserved aside, and it starts empty.
    func testFreshStoreNeedsNoMigration() throws {
        let url = freshStoreURL()
        do {
            let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
            XCTAssertEqual(try ctx.fetch(FetchDescriptor<ShaktiLetter>()).count, 0)
            XCTAssertFalse(preservedStoreExists(beside: url),
                           "A fresh store has nothing to migrate and nothing to preserve")

            // And it reopens as itself, still without recovering.
            ctx.insert(ShaktiLetter(khadgamalaPosition: 44, body: "the sixteenth"))
            try ctx.save()
        }

        let reopened = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
        XCTAssertEqual(try reopened.fetch(FetchDescriptor<ShaktiLetter>()).first?.body, "the sixteenth")
        XCTAssertFalse(preservedStoreExists(beside: url))
    }

    /// The point of the whole change: a letter to a Śakti outside Ring 2 — here
    /// kp 7, in the Bhūpura — is storable, and survives a reopen.
    func testLetterOutsideRingTwoRoundTrips() throws {
        let url = freshStoreURL()
        let written = Date(timeIntervalSince1970: 1_444_444)
        let body = "To the seventh of the Bhūpura.\n"

        do {
            let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
            ctx.insert(ShaktiLetter(khadgamalaPosition: 7, body: body, updatedAt: written))
            try ctx.save()
        }

        let ctx = ModelContext(PersistenceRecovery.makeContainer(storeURL: url))
        let letters = try ctx.fetch(FetchDescriptor<ShaktiLetter>())

        XCTAssertEqual(letters.count, 1)
        XCTAssertEqual(letters.first?.khadgamalaPosition, 7)
        XCTAssertEqual(letters.first?.body, body)
        XCTAssertEqual(letters.first.map { Array($0.body.utf8) }, Array(body.utf8))
        XCTAssertEqual(letters.first?.updatedAt, written)
        XCTAssertEqual(letters.first?.shaktiPosition, 0,
                       "A letter born at V2 never had a per-ring key")
        XCTAssertFalse(preservedStoreExists(beside: url))
    }

    // MARK: - The store keys on Khaḍgamālā, and reading writes nothing

    func testLetterStoreKeysByKhadgamalaAndNeverWritesOnRead() throws {
        let container = try ModelContainer(
            for: ShaktiLetter.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let ctx = ModelContext(container)
        let store = LetterStore(context: ctx)

        // Reading an unwritten letter inserts nothing — the write-on-open bug.
        XCTAssertNil(store.existingLetter(for: 39))
        let transient = store.letter(for: 39)
        XCTAssertEqual(transient.khadgamalaPosition, 39)
        XCTAssertNil(transient.modelContext, "A letter merely opened is not in the store")
        try ctx.save()
        XCTAssertEqual(try ctx.fetch(FetchDescriptor<ShaktiLetter>()).count, 0,
                       "Opening a letter must leave the store exactly as it found it")

        // Saving is what makes it real.
        store.save(transient, body: "now she has words")
        XCTAssertEqual(try ctx.fetch(FetchDescriptor<ShaktiLetter>()).count, 1)
        XCTAssertEqual(store.existingLetter(for: 39)?.body, "now she has words")

        // And a second save finds the same row rather than colliding on the key.
        store.save(store.letter(for: 39), body: "and more")
        XCTAssertEqual(try ctx.fetch(FetchDescriptor<ShaktiLetter>()).count, 1)
        XCTAssertEqual(store.existingLetter(for: 39)?.body, "and more")
    }

    /// A legacy position the Ring-2 mapping cannot place is parked above 102,
    /// never on top of one of the Śaktis and never on top of another such row.
    func testQuarantineKeyIsOutOfRangeAndCollisionFree() {
        let legacies = [0, 17, 99, 102, -1, -3, -899, -900, Int.min / 4]
        var seen = Set<Int>()
        for legacy in legacies {
            let key = BinduMigrationPlan.quarantineKey(forLegacy: legacy)
            XCTAssertGreaterThan(key, 102,
                                 "Legacy \(legacy) must not be parked on a real Śakti")
            XCTAssertTrue(seen.insert(key).inserted,
                          "Legacy \(legacy) collided with an earlier quarantined letter")
        }
    }
}
