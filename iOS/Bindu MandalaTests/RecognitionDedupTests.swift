import XCTest
@testable import Bindu_Mandala

/// The pure half of the create-time idempotency check against App Activity:
/// the ±60 s fetch window in ISO8601 Z, the ledger formula built from it, the
/// two columns the check reads, the `Felt At` key in the form the create wrote
/// it, the "is this row this exact moment" match on link + second, and the
/// Shakti-row PATCH guard that shares the key.
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
        // The create writes `Felt At` at second precision, Z; the window must
        // be in the same form so the comparison is apples to apples — no
        // fractional seconds, no local offset.
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

    // MARK: formula — the App Activity one

    func testDedupFormulaIsTheLedgerOneWithBothBounds() {
        // The check now reads App Activity: Mandala's rows of this type, by
        // field name, within the window.
        let f = ActivityLedger.dedup(type: ActivityLedger.ActivityType.shaktiRecognized,
                                     around: utc(2026, 9, 7, 12, 0, 0))
        XCTAssertEqual(
            f,
            "AND({Source App}='Mandala', {Activity Type}='Shakti Recognized', IS_AFTER({Felt At}, '2026-09-07T11:59:00Z'), IS_BEFORE({Felt At}, '2026-09-07T12:01:00Z'))"
        )
        XCTAssertFalse(f.contains("Row Type"), "the Mandala table is no longer asked")
        XCTAssertFalse(f.contains("fld"), "the ledger is addressed by field name")
    }

    func testDedupFormulaEmbedsTheSameWindow() {
        let instant = utc(2026, 9, 7, 0, 0, 30)
        let w = RecognitionDedup.window(around: instant)
        let f = ActivityLedger.dedup(type: ActivityLedger.ActivityType.ringCrossed, around: instant)
        XCTAssertTrue(f.contains("IS_AFTER({Felt At}, '\(w.lower)')"))
        XCTAssertTrue(f.contains("IS_BEFORE({Felt At}, '\(w.upper)')"))
        XCTAssertTrue(f.contains("{Activity Type}='Ring Crossed'"))
    }

    // MARK: the columns the check reads — by name, and only the key

    func testCheckReadsTheLinkAndFeltAtByFieldName() {
        XCTAssertEqual(RecognitionDedup.readFields, ["Link to Mandala", "Felt At"])
        XCTAssertEqual(RecognitionDedup.readFields,
                       [ActivityLedger.Field.linkToMandala, ActivityLedger.Field.feltAt])
        for f in RecognitionDedup.readFields {
            XCTAssertFalse(f.hasPrefix("fld"), "no Mandala-table field ids survive in the check")
        }
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

    func testRowMatchesWhenLinkedAndSameSecond() {
        XCTAssertTrue(RecognitionDedup.rowMatches(links: ["recA"],
                                                  feltAt: "2023-11-14T22:13:20.000Z",
                                                  linkRecordId: "recA", feltAt: moment))
        XCTAssertTrue(RecognitionDedup.rowMatches(links: ["recOther", "recA"],
                                                  feltAt: "2023-11-14T22:13:20Z",
                                                  linkRecordId: "recA", feltAt: moment))
    }

    func testRetryWithSubSecondFeltAtStillMatchesTheRowItWrote() {
        // The queued item carries the original Date, fractional part and all;
        // the row holds what the create wrote from it — the truncated second.
        let queued = moment.addingTimeInterval(0.84)
        XCTAssertTrue(RecognitionDedup.rowMatches(links: ["recA"],
                                                  feltAt: "2023-11-14T22:13:20.000Z",
                                                  linkRecordId: "recA", feltAt: queued))
    }

    func testSameLinkFortySecondsApartIsAnotherMoment() {
        // Inside the fetch window, but not the same second: a genuine second
        // recognition must not be mistaken for a retry.
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA",
                                                   feltAt: moment.addingTimeInterval(40)))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA",
                                                   feltAt: moment.addingTimeInterval(1)))
    }

    func testRowDoesNotMatchAnotherLinkAtTheSameSecond() {
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recOther"],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: [],
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: nil,
                                                   feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA", feltAt: moment))
    }

    func testRowMatchIsExactNotPrefix() {
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA1"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "recA1", feltAt: moment))
    }

    func testEmptyIdNeverMatches() {
        // A crossing outside 1…9 links nothing; an empty key can claim no row.
        XCTAssertFalse(RecognitionDedup.rowMatches(links: [""], feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"], feltAt: "2023-11-14T22:13:20.000Z",
                                                   linkRecordId: "", feltAt: moment))
    }

    func testRowWithoutReadableFeltAtNeverMatches() {
        // Fail toward the create: an unreadable key cannot claim the moment.
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"], feltAt: nil,
                                                   linkRecordId: "recA", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.rowMatches(links: ["recA"], feltAt: "not a date",
                                                   linkRecordId: "recA", feltAt: moment))
    }

    // MARK: the Shakti-row PATCH guard shares the key

    func testPatchAlreadyLandedWhenLastFeltIsThisSecond() {
        XCTAssertTrue(RecognitionDedup.patchAlreadyLanded(lastFelt: "2023-11-14T22:13:20.000Z",
                                                          feltAt: moment))
        XCTAssertTrue(RecognitionDedup.patchAlreadyLanded(lastFelt: "2023-11-14T22:13:20Z",
                                                          feltAt: moment.addingTimeInterval(0.4)),
                      "the queued Date's fractional part was never written")
    }

    func testPatchNotLandedAtAnotherSecondOrWithoutLastFelt() {
        XCTAssertFalse(RecognitionDedup.patchAlreadyLanded(lastFelt: "2023-11-14T22:13:19.000Z",
                                                           feltAt: moment))
        XCTAssertFalse(RecognitionDedup.patchAlreadyLanded(lastFelt: nil, feltAt: moment))
        XCTAssertFalse(RecognitionDedup.patchAlreadyLanded(lastFelt: "", feltAt: moment))
        XCTAssertFalse(RecognitionDedup.patchAlreadyLanded(lastFelt: "not a date", feltAt: moment))
    }

    func testPatchGuardAndWasFirstAgreeOnARetry() {
        // A retry whose PATCH landed reads a count that already includes her:
        // 1 still means first, and 2 means she was felt before.
        let landed = RecognitionDedup.patchAlreadyLanded(lastFelt: "2023-11-14T22:13:20.000Z",
                                                         feltAt: moment)
        XCTAssertTrue(ActivityLedger.wasFirst(serverCount: 1, patchAlreadyLanded: landed))
        XCTAssertFalse(ActivityLedger.wasFirst(serverCount: 2, patchAlreadyLanded: landed))
        let fresh = RecognitionDedup.patchAlreadyLanded(lastFelt: nil, feltAt: moment)
        XCTAssertTrue(ActivityLedger.wasFirst(serverCount: 0, patchAlreadyLanded: fresh))
        XCTAssertFalse(ActivityLedger.wasFirst(serverCount: 1, patchAlreadyLanded: fresh))
    }
}
