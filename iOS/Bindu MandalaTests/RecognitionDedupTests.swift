import XCTest
@testable import Bindu_Mandala

/// The pure half of the create-time idempotency check: the ±60 s window in
/// ISO8601 Z, the formula built from it, and the "is this row hers" match.
final class RecognitionDedupTests: XCTestCase {

    private func utc(_ year: Int, _ month: Int, _ day: Int,
                     _ hour: Int, _ minute: Int, _ second: Int) -> Date {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: year, month: month, day: day,
                                           hour: hour, minute: minute, second: second))!
    }

    // MARK: window

    func testWindowIsExactlyPlusMinusSixtySecondsInZ() {
        XCTAssertEqual(RecognitionDedup.windowSeconds, 60)
        let w = RecognitionDedup.window(around: utc(2026, 9, 7, 12, 0, 0))
        XCTAssertEqual(w.lower, "2026-09-07T11:59:00Z")
        XCTAssertEqual(w.upper, "2026-09-07T12:01:00Z")
    }

    func testWindowCrossesDayBoundaryCorrectly() {
        let w = RecognitionDedup.window(around: utc(2026, 9, 7, 0, 0, 30))
        XCTAssertEqual(w.lower, "2026-09-06T23:59:30Z")
        XCTAssertEqual(w.upper, "2026-09-07T00:01:30Z")
    }

    func testWindowIsSecondPrecisionLikeTheWrittenFeltAt() {
        // The create wrote `Felt At` through a default ISO8601DateFormatter
        // (seconds, Z); the window must be in the same form so the comparison
        // is apples to apples — no fractional seconds, no local offset.
        let w = RecognitionDedup.window(around: utc(2026, 9, 7, 12, 0, 0).addingTimeInterval(0.7))
        XCTAssertEqual(w.lower, "2026-09-07T11:59:00Z")
        XCTAssertEqual(w.upper, "2026-09-07T12:01:00Z")
        XCTAssertTrue(w.lower.hasSuffix("Z"))
        XCTAssertFalse(w.lower.contains("."))
    }

    func testWindowIsIndependentOfDeviceTimeZone() {
        // Bounds are stated in Z regardless of the device zone: the same
        // instant yields the same strings.
        let instant = Date(timeIntervalSince1970: 1_700_000_000)   // 2023-11-14T22:13:20Z
        let w = RecognitionDedup.window(around: instant)
        XCTAssertEqual(w.lower, "2023-11-14T22:12:20Z")
        XCTAssertEqual(w.upper, "2023-11-14T22:14:20Z")
    }

    // MARK: formula

    func testFilterFormulaEmbedsBothBoundsAndRowType() {
        let f = RecognitionDedup.filterFormula(around: utc(2026, 9, 7, 12, 0, 0))
        XCTAssertEqual(
            f,
            "AND({Row Type}='Recognition', IS_AFTER({Felt At}, '2026-09-07T11:59:00Z'), IS_BEFORE({Felt At}, '2026-09-07T12:01:00Z'))"
        )
    }

    // MARK: match

    func testRowMatchesOnlyWhenOfShaktiContainsTheId() {
        XCTAssertTrue(RecognitionDedup.rowMatches(ofShakti: ["recA"], shaktiRecordId: "recA"))
        XCTAssertTrue(RecognitionDedup.rowMatches(ofShakti: ["recOther", "recA"], shaktiRecordId: "recA"))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recOther"], shaktiRecordId: "recA"))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: [], shaktiRecordId: "recA"))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: nil, shaktiRecordId: "recA"))
    }

    func testRowMatchIsExactNotPrefix() {
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA1"], shaktiRecordId: "recA"))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], shaktiRecordId: "recA1"))
    }

    func testEmptyIdNeverMatches() {
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: [""], shaktiRecordId: ""))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], shaktiRecordId: ""))
    }

    func testOfShaktiFieldIdIsTheLinkField() {
        XCTAssertEqual(RecognitionDedup.ofShaktiFieldId, "fldaDjmaPvu57sJVg")
    }
}
