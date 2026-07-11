import XCTest
@testable import Bindu_Mandala

/// The pure descent-timeline logic behind the Airtable mirror (Ruling 8):
/// `enter` fires a crossing only on a new deepest, and `restore` rebuilds from
/// Airtable rows without ever regressing below the bootstrap floor.
final class DescentMirrorTests: XCTestCase {

    func testEnterReturnsTrueOnlyOnNewDeepest() {
        let s = DescentState(currentRing: 2, deepestReached: 2, crossings: [])
        XCTAssertTrue(s.enter(ring: 3), "first descent past the floor is a crossing")
        XCTAssertEqual(s.deepestReached, 3)
        XCTAssertEqual(s.crossings.count, 1)
        XCTAssertFalse(s.enter(ring: 2), "re-entering a shallower ring is not a crossing")
        XCTAssertFalse(s.enter(ring: 3), "re-entering the same depth is not a crossing")
        XCTAssertEqual(s.crossings.count, 1)
        XCTAssertTrue(s.enter(ring: 6), "a deeper ring is a new crossing")
        XCTAssertEqual(s.deepestReached, 6)
        XCTAssertEqual(s.crossings.count, 2)
    }

    func testRestoreZeroRowsLeavesBootstrapFloor() {
        let s = DescentState(currentRing: 2, deepestReached: 2, crossings: [])
        s.restore(from: [])
        XCTAssertEqual(s.deepestReached, 2)
        XCTAssertEqual(s.currentRing, 2)
        XCTAssertTrue(s.crossings.isEmpty)
    }

    func testRestoreRebuildsTimeline() {
        let s = DescentState(currentRing: 2, deepestReached: 2, crossings: [])
        let d1 = Date(timeIntervalSince1970: 1000)
        let d2 = Date(timeIntervalSince1970: 5000)
        s.restore(from: [(ring: 3, date: d1), (ring: 6, date: d2)])
        XCTAssertEqual(s.deepestReached, 6)
        XCTAssertEqual(s.currentRing, 6)
        XCTAssertEqual(s.crossings, [d1, d2])
        XCTAssertEqual(s.enteredCurrentAt, d2)
    }

    func testRestoreNeverRegressesBelowFloor() {
        let s = DescentState(currentRing: 2, deepestReached: 2, crossings: [])
        s.restore(from: [(ring: 1, date: Date(timeIntervalSince1970: 500))])
        XCTAssertEqual(s.deepestReached, 2, "deepest never drops below the floor of 2")
    }
}
