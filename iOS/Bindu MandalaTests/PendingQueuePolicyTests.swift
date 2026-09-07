import XCTest
@testable import Bindu_Mandala

/// The offline-queue policy every Airtable flush applies (§0.6 "make the pipe
/// honest"): a failure bumps and retires the item at `maxFailures`; no token
/// holds the queue exactly as it is. Pure — no network, no UserDefaults.
final class PendingQueuePolicyTests: XCTestCase {

    private struct Item: PendingQueueItem, Equatable, Codable {
        let id: String
        var failCount: Int = 0
    }

    /// A queued letter-shaped item for the newest-per-key rule.
    private struct Dated: PendingQueueItem, Equatable {
        let id: String
        let key: String
        let at: Date
        var failCount: Int = 0
    }

    // MARK: decide

    func testSuccessRemovesItemWhateverItsHistory() {
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: true, failCount: 0), .remove)
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: true, failCount: 2), .remove)
    }

    func testFailureBumpsUntilMaxThenDrops() {
        XCTAssertEqual(PendingQueuePolicy.maxFailures, 3)
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: false, failCount: 0),
                       .retain(failCount: 1))
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: false, failCount: 1),
                       .retain(failCount: 2))
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: false, failCount: 2),
                       .drop(failCount: 3))
    }

    func testCustomMaxFailuresIsHonoured() {
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: false, failCount: 0, maxFailures: 1),
                       .drop(failCount: 1))
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: true, succeeded: false, failCount: 3, maxFailures: 5),
                       .retain(failCount: 4))
    }

    func testNoTokenHoldsRegardlessOfResultOrHistory() {
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: false, succeeded: false, failCount: 0), .hold)
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: false, succeeded: false, failCount: 2), .hold)
        XCTAssertEqual(PendingQueuePolicy.decide(hasToken: false, succeeded: true,  failCount: 0), .hold)
    }

    // MARK: update (whole queue)

    func testUpdateWithoutTokenLeavesQueueUntouched() {
        let queue = [Item(id: "a", failCount: 2), Item(id: "b", failCount: 0)]
        let r = PendingQueuePolicy.update(queue, hasToken: false, succeeded: [false, false])
        XCTAssertEqual(r.remaining, queue, "no token: no bump, no drop, same order")
        XCTAssertTrue(r.dropped.isEmpty)
    }

    func testUpdateRemovesBumpsAndDrops() {
        let queue = [Item(id: "ok"), Item(id: "retry", failCount: 1), Item(id: "gone", failCount: 2)]
        let r = PendingQueuePolicy.update(queue, hasToken: true, succeeded: [true, false, false])
        XCTAssertEqual(r.remaining, [Item(id: "retry", failCount: 2)])
        XCTAssertEqual(r.dropped, [Item(id: "gone", failCount: 3)], "dropped items carry their final count")
    }

    func testUpdatePreservesOrderOfSurvivors() {
        let queue = [Item(id: "a"), Item(id: "b"), Item(id: "c")]
        let r = PendingQueuePolicy.update(queue, hasToken: true, succeeded: [false, true, false])
        XCTAssertEqual(r.remaining.map(\.id), ["a", "c"])
        XCTAssertEqual(r.remaining.map(\.failCount), [1, 1])
    }

    func testUpdateTreatsMissingResultAsFailure() {
        let r = PendingQueuePolicy.update([Item(id: "a")], hasToken: true, succeeded: [])
        XCTAssertEqual(r.remaining, [Item(id: "a", failCount: 1)])
        XCTAssertTrue(r.dropped.isEmpty)
    }

    func testUpdateOnEmptyQueueIsEmpty() {
        let r = PendingQueuePolicy.update([Item](), hasToken: true, succeeded: [])
        XCTAssertTrue(r.remaining.isEmpty)
        XCTAssertTrue(r.dropped.isEmpty)
    }

    // MARK: merge (enqueue while a drain is in flight)

    func testMergeKeepsItemEnqueuedBehindTheSnapshot() {
        // Drain took [a]; a failed; meanwhile b was enqueued, so the store is [a, b].
        let snapshot = [Item(id: "a")]
        let stored   = [Item(id: "a"), Item(id: "b")]
        let r = PendingQueuePolicy.merge(remaining: [Item(id: "a", failCount: 1)],
                                         drained: snapshot, stored: stored)
        XCTAssertEqual(r, [Item(id: "a", failCount: 1), Item(id: "b")],
                       "b survives; a carries the drain's bumped count, not the stale stored one")
    }

    func testMergeDoesNotResurrectRemovedOrDroppedItems() {
        // a succeeded (removed), c was dropped; only b (new) should remain.
        let snapshot = [Item(id: "a"), Item(id: "c", failCount: 2)]
        let stored   = [Item(id: "a"), Item(id: "c", failCount: 2), Item(id: "b")]
        let r = PendingQueuePolicy.merge(remaining: [], drained: snapshot, stored: stored)
        XCTAssertEqual(r, [Item(id: "b")])
    }

    func testMergeWithNothingEnqueuedIsJustRemaining() {
        let snapshot = [Item(id: "a"), Item(id: "b")]
        let r = PendingQueuePolicy.merge(remaining: [Item(id: "b", failCount: 1)],
                                         drained: snapshot, stored: snapshot)
        XCTAssertEqual(r, [Item(id: "b", failCount: 1)])
    }

    func testMergeSurvivesAStoreClearedUnderneath() {
        let r = PendingQueuePolicy.merge(remaining: [Item(id: "a", failCount: 1)],
                                         drained: [Item(id: "a")], stored: [])
        XCTAssertEqual(r, [Item(id: "a", failCount: 1)])
    }

    // MARK: latestPerKey (the letter queue's newest-body rule)

    func testLatestPerKeyKeepsNewestPerKeyInFirstSeenOrder() {
        let t0 = Date(timeIntervalSince1970: 1_000)
        let old   = Dated(id: "1", key: "recX", at: t0, failCount: 1)
        let newer = Dated(id: "2", key: "recX", at: t0.addingTimeInterval(30))
        let other = Dated(id: "3", key: "recY", at: t0.addingTimeInterval(10))
        let r = PendingQueuePolicy.latestPerKey([old, other, newer], key: \.key, at: \.at)
        XCTAssertEqual(r, [newer, other], "recX collapses to its newest body; key order is first-seen")
    }

    func testLatestPerKeyLeavesDistinctKeysAlone() {
        let t0 = Date(timeIntervalSince1970: 1_000)
        let a = Dated(id: "1", key: "recA", at: t0)
        let b = Dated(id: "2", key: "recB", at: t0)
        XCTAssertEqual(PendingQueuePolicy.latestPerKey([a, b], key: \.key, at: \.at), [a, b])
    }

    // MARK: storage (queues written before item ids must survive the upgrade)

    func testDecodePassesThroughItemsThatHaveIds() throws {
        let data = try JSONEncoder().encode([Item(id: "a", failCount: 2), Item(id: "b")])
        let (queue, stamped): ([Item], Bool) = PendingQueueStorage.decode(data)
        XCTAssertEqual(queue, [Item(id: "a", failCount: 2), Item(id: "b")])
        XCTAssertFalse(stamped)
    }

    func testDecodeStampsFreshIdsOnLegacyItems() throws {
        let legacy = Data(#"[{"failCount":1},{"failCount":0}]"#.utf8)
        let (queue, stamped): ([Item], Bool) = PendingQueueStorage.decode(legacy)
        XCTAssertTrue(stamped, "caller must persist so the ids hold across loads")
        XCTAssertEqual(queue.map(\.failCount), [1, 0], "nothing else about the items changes")
        XCTAssertEqual(Set(queue.map(\.id)).count, 2, "each item gets its own id")
        XCTAssertTrue(queue.allSatisfy { UUID(uuidString: $0.id) != nil })
    }

    func testDecodeOfUnreadableDataIsEmptyNotACrash() {
        let (queue, stamped): ([Item], Bool) = PendingQueueStorage.decode(Data("nope".utf8))
        XCTAssertTrue(queue.isEmpty)
        XCTAssertFalse(stamped)
    }
}
