import XCTest
@testable import Bindu_Mandala

/// The offline-queue policy every Airtable flush applies (§0.6 "make the pipe
/// honest"): a failure bumps and retires the item at `maxFailures`; no token
/// holds the queue exactly as it is. Pure — no network, no UserDefaults.
final class PendingQueuePolicyTests: XCTestCase {

    private struct Item: PendingQueueItem, Equatable {
        let id: String
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
}
