import XCTest
@testable import Bindu_Mandala

/// The pure half of the create-time idempotency check: the ±60 s fetch window
/// in ISO8601 Z, the formula built from it, the `Felt At` key in the form the
/// create wrote it, and the "is this row this exact moment of hers" match.
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

    // MARK: key — Felt At as written and as the API returns it

    func testWrittenFeltAtIsSecondPrecisionZ() {
        let s = RecognitionDedup.writtenFeltAt(utc(2026, 9, 7, 12, 0, 37).addingTimeInterval(0.6))
        XCTAssertEqual(s, "2026-09-07T12:00:37Z", "same form the create sends to Felt At")
    }

    func testServerFeltAtWithMillisecondsNormalizesToWrittenForm() {
        // Airtable hands back `…:33.000Z`; the create wrote `…:33Z`.
        XCTAssertEqual(RecognitionDedup.normalizedServerFeltAt("2026-07-13T21:25:33.000Z"),
                       "2026-07-13T21:25:33Z")
    }

    func testServerFeltAtWithoutMillisecondsNormalizesToItself() {
        XCTAssertEqual(RecognitionDedup.normalizedServerFeltAt("2026-07-13T21:25:33Z"),
                       "2026-07-13T21:25:33Z")
    }

    func testUnreadableServerFeltAtIsNil() {
        XCTAssertNil(RecognitionDedup.normalizedServerFeltAt(""))
        XCTAssertNil(RecognitionDedup.normalizedServerFeltAt("yesterday"))
        XCTAssertNil(RecognitionDedup.normalizedServerFeltAt("2026-07-13"))
    }

    // MARK: match

    private let moment = Date(timeIntervalSince1970: 1_700_000_000)   // 2023-11-14T22:13:20Z

    func testRowMatchesWhenHersAndSameSecond() {
        XCTAssertTrue(RecognitionDedup.rowMatches(ofShakti: ["recA"],
                                                  feltAt: "2023-11-14T22:13:20.000Z",
                                                  shaktiRecordId: "recA", feltAt: moment))
        XCTAssertTrue(RecognitionDedup.rowMatches(ofShakti: ["recOther", "recA"],
                                                  feltAt: "2023-11-14T22:13:20Z",
                                                  shaktiRecordId: "recA", feltAt: moment))
    }

    func testRetryWithSubSecondFeltAtStillMatchesTheRowItWrote() {
        // The queued item carries the original Date, fractional part and all;
        // the row holds what the create wrote from it — the truncated second.
        let queued = moment.addingTimeInterval(0.84)
        XCTAssertTrue(RecognitionDedup.rowMatches(ofShakti: ["recA"],
                                                  feltAt: "2023-11-14T22:13:20.000Z",
                                                  shaktiRecordId: "recA", feltAt: queued))
    }

    func testSameShaktiFortySecondsApartIsAnotherMoment() {
        // Inside the fetch window, but not the same second: a genuine second
        // recognition must not be mistaken for a retry.
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA",
                                                   feltAt: moment.addingTimeInterval(40)))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA",
                                                   feltAt: moment.addingTimeInterval(1)))
    }

    func testRowDoesNotMatchAnotherShaktiAtTheSameSecond() {
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recOther"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: [],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: nil,
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA", feltAt: moment))
    }

    func testRowMatchIsExactNotPrefix() {
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA1"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "recA1", feltAt: moment))
    }

    func testEmptyIdNeverMatches() {
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: [""], feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   shaktiRecordId: "", feltAt: moment))
    }

    func testRowWithoutReadableFeltAtNeverMatches() {
        // Fail toward the create: an unreadable key cannot claim the moment.
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], feltAt: nil,
                                                   shaktiRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(ofShakti: ["recA"], feltAt: "not a date",
                                                   shaktiRecordId: "recA", feltAt: moment))
    }

    func testFieldIdsAreTheLinkAndFeltAtFields() {
        XCTAssertEqual(RecognitionDedup.ofShaktiFieldId, "fldaDjmaPvu57sJVg")
        XCTAssertEqual(RecognitionDedup.feltAtFieldId, "fldk4BdikzJQOautw")
    }
}
