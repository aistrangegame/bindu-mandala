import XCTest
@testable import Bindu_Mandala

/// Wave 3 · the day layer folded into the Rite, and the Homecoming's score —
/// the pure parts, held to the surviving law: nothing grades him, and grace
/// speaks once and rests.
final class RiteDayTests: XCTestCase {

    private var calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "America/New_York")!
        return c
    }()

    private func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
    }

    // MARK: The day's doors
    //
    // U0 · widened (VER-L-0735): "three doors, never five" was a restriction
    // ("three controls") and is lifted, with its no-digit clause (VER-L-0759).
    // What stays is the floor of kindness: the one-second door is always
    // offered, and every door says what it is.

    func testTheOneSecondDoorIsAlwaysOffered() {
        for hour in 0..<24 {
            let doors = RiteDay.doors(hour: hour)
            XCTAssertFalse(doors.isEmpty, "hour \(hour)")
            XCTAssertEqual(Set(doors).count, doors.count, "a door offered twice — hour \(hour)")
            XCTAssertTrue(doors.contains(.oneSecond), "the floor is always offered — hour \(hour)")
            for d in doors {
                XCTAssertFalse(RiteDay.title(d, hour: hour).isEmpty)
            }
        }
        XCTAssertTrue(RiteDay.doors(hour: 21).contains(.closeTheDay), "the evening offers the close")
    }

    func testThePulseLivesFromTheCorridorToTheSummit() {
        XCTAssertEqual((1...9).filter(RiteDay.pulseLives(inRing:)), [4, 5, 6, 7, 8])
        XCTAssertEqual(RiteDay.pulseBeat.period, 1.0, accuracy: 0.001, "about sixty a minute")
    }

    func testTheFloorIsThreeMovementsAndSaysTheDayIsWhole() {
        XCTAssertEqual(RiteDay.floorWords, ["Blink.", "Breathe.", "Press."])
        XCTAssertEqual(RiteDay.floorBreath, [4, 4, 4])
        XCTAssertEqual(RiteDay.floorComplete,
                       "That was a full day of walking. Everything else today is extra.")
    }

    // MARK: Grace

    private func row(_ id: String, _ type: String, _ feltAt: String, _ link: String) -> ActivityLedger.Row {
        ActivityLedger.Row(id: id, fields: .init(activityType: type, feltAt: feltAt, linkToMandala: [link]))
    }

    private let names = ["recHER": "Vajreśī", "recSIS": "Kāmeśvarī", "recFAR": "Aṇimā"]

    func testGracePrefersHerOwnRoomAndSpeaksInWords() throws {
        let now = date(2026, 10, 12, 9)
        let rows = [
            row("r1", ActivityLedger.ActivityType.silenceHeld, "2026-10-10T23:17:11.000Z", "recSIS"),
            row("r2", ActivityLedger.ActivityType.silenceHeld, "2026-10-09T23:17:11.000Z", "recHER"),
            row("r3", ActivityLedger.ActivityType.shaktiRecognized, "2026-10-11T13:00:00.000Z", "recFAR"),
        ]
        let line = try XCTUnwrap(GraceChannel.choose(rows: rows, herRecordId: "recHER",
                                                     sisterRecordIds: ["recSIS"], names: names,
                                                     now: now, calendar: calendar,
                                                     lastSurfaced: nil, surfaced: []))
        XCTAssertEqual(line.rowId, "r2", "her own room before a sister's, even when older")
        XCTAssertEqual(line.text, "Three nights ago, you kept a silence with Vajreśī. It was standing in this room.")
    }

    func testGraceReturnsASistersMomentToTheEnclosure() throws {
        let now = date(2026, 10, 12, 9)
        let rows = [row("r1", ActivityLedger.ActivityType.shaktiRecognized, "2026-10-11T13:00:00.000Z", "recSIS")]
        let line = try XCTUnwrap(GraceChannel.choose(rows: rows, herRecordId: "recHER",
                                                     sisterRecordIds: ["recSIS"], names: names,
                                                     now: now, calendar: calendar,
                                                     lastSurfaced: nil, surfaced: []))
        XCTAssertTrue(line.text.hasPrefix("Yesterday, "), line.text)
        XCTAssertTrue(line.text.hasSuffix("It was standing in this enclosure."), line.text)
    }

    func testGraceIsSilentWhenNothingFits() {
        let now = date(2026, 10, 12, 9)
        // Another room altogether; a crossing (a type grace does not speak of);
        // today's own moment; a name the phone does not hold.
        let rows = [
            row("r1", ActivityLedger.ActivityType.silenceHeld, "2026-10-10T23:17:11.000Z", "recFAR"),
            row("r2", ActivityLedger.ActivityType.ringCrossed, "2026-10-10T23:17:11.000Z", "recHER"),
            row("r3", ActivityLedger.ActivityType.silenceHeld, "2026-10-12T12:00:00.000Z", "recHER"),
            row("r4", ActivityLedger.ActivityType.silenceHeld, "2026-10-10T12:00:00.000Z", "recNONAME"),
        ]
        XCTAssertNil(GraceChannel.choose(rows: rows, herRecordId: "recHER",
                                         sisterRecordIds: ["recNONAME"], names: names,
                                         now: now, calendar: calendar,
                                         lastSurfaced: nil, surfaced: []))
    }

    func testGraceSpeaksOnceThenRests() {
        let now = date(2026, 10, 12, 9)
        let rows = [row("r1", ActivityLedger.ActivityType.letterWritten, "2026-10-08T15:00:00.000Z", "recHER")]
        XCTAssertNil(GraceChannel.choose(rows: rows, herRecordId: "recHER", sisterRecordIds: [],
                                         names: names, now: now, calendar: calendar,
                                         lastSurfaced: date(2026, 10, 11), surfaced: []),
                     "inside the rest it says nothing")
        XCTAssertNil(GraceChannel.choose(rows: rows, herRecordId: "recHER", sisterRecordIds: [],
                                         names: names, now: now, calendar: calendar,
                                         lastSurfaced: nil, surfaced: ["r1"]),
                     "a moment it has returned is never returned again")
        XCTAssertNotNil(GraceChannel.choose(rows: rows, herRecordId: "recHER", sisterRecordIds: [],
                                            names: names, now: now, calendar: calendar,
                                            lastSurfaced: date(2026, 10, 1), surfaced: []))
    }

    func testGraceSaysWhenInWordsAndNeverOfToday() {
        let now = date(2026, 10, 12, 9)
        XCTAssertNil(GraceChannel.when(date(2026, 10, 12, 7), now: now, calendar: calendar))
        XCTAssertEqual(GraceChannel.when(date(2026, 10, 11, 21), now: now, calendar: calendar), "Last night")
        XCTAssertEqual(GraceChannel.when(date(2026, 10, 9, 10), now: now, calendar: calendar), "Three days ago")
        XCTAssertEqual(GraceChannel.when(date(2026, 10, 3, 10), now: now, calendar: calendar), "A week ago")
        XCTAssertEqual(GraceChannel.when(date(2026, 9, 13, 10), now: now, calendar: calendar), "A moon ago")
    }

    func testGraceReadsOnlyWhatItCanRoomMatch() {
        XCTAssertTrue(GraceChannel.formula.contains(ActivityLedger.Field.linkToMandala))
        XCTAssertTrue(GraceChannel.fields.contains(ActivityLedger.Field.linkToMandala))
    }

    // MARK: The Sakshi close

    func testTheCloseWitnessesWithoutCounting() {
        var d = SakshiClose.Today()
        d.floorWalked = true
        d.met = ["Aruṇā", "Vimalā", "Kaulinī", "Modinī", "Aruṇā"]
        d.silences = ["Vajreśī"]
        d.deepestRing = 7
        d.todaysName = "Sarvajñā"
        let s = SakshiClose.sentence(d)
        // U0: the no-digit clause is retired (VER-L-0759); the narrow floor —
        // never a tally of whom he met — is the "and others" line below.
        XCTAssertTrue(s.contains("walked one second"), s)
        XCTAssertTrue(s.contains("Aruṇā, Vimalā, Kaulinī and others"), "past three it is never a tally: \(s)")
        XCTAssertTrue(s.contains("seventh enclosure"), s)
        XCTAssertTrue(s.contains("Sarvajñā waited."), s)
        XCTAssertTrue(s.hasSuffix("It trusts you."), s)
    }

    func testAnEmptyDayIsNotADebt() {
        let s = SakshiClose.sentence(SakshiClose.Today())
        XCTAssertTrue(s.hasPrefix("Nothing was asked of you today."), s)
        // "again" is allowed now (ruling 10); the words of a debt are not.
        for word in ["missed", "streak", "behind", "only"] {
            XCTAssertFalse(s.lowercased().contains(word), "\(word) in \(s)")
        }
    }

    // MARK: The Homecoming's score

    func testEveryReturnIsOneBreath() {
        let s = HomecomingScore.self
        XCTAssertEqual(s.breath, 4, "the Bindu's own breath")
        XCTAssertLessThan(s.returnBlink, s.returnDraw)
        XCTAssertLessThanOrEqual(s.returnDraw + s.drawSpan(returning: true), s.breath,
                                 "the yantra stands whole inside the one breath")
        XCTAssertEqual(s.covenantHold, s.breath, "the covenant is one breath, still")
    }

    func testTheYantraDrawsOutwardFromThePoint() {
        let span = HomecomingScore.drawSpan(returning: false)
        // Early on, the star (near the point) has begun and the Bhūpura has not.
        let t = span * 0.3
        let star = HomecomingScore.drawProgress(meanRadius: 0.3, elapsed: t, span: span)
        let square = HomecomingScore.drawProgress(meanRadius: 1.15, elapsed: t, span: span)
        XCTAssertGreaterThan(star, 0)
        XCTAssertEqual(square, 0)
        // At the end of the span, every layer is whole.
        for r in [0.0, 0.3, 0.6, 0.9, 1.0, 1.15] {
            XCTAssertEqual(HomecomingScore.drawProgress(meanRadius: r, elapsed: span, span: span), 1,
                           accuracy: 0.0001, "radius \(r)")
        }
    }

    func testTheBlinkClosesAndOpensOnce() {
        XCTAssertEqual(HomecomingScore.blinkOpen(since: 0), 1, accuracy: 0.001)
        XCTAssertEqual(HomecomingScore.blinkOpen(since: 0.42), 0, accuracy: 0.001)
        XCTAssertEqual(HomecomingScore.blinkOpen(since: HomecomingScore.blink), 1, accuracy: 0.001)
        XCTAssertEqual(HomecomingScore.blinkOpen(since: 30), 1, accuracy: 0.001)
    }

    func testTheLightCondensesOnce() {
        XCTAssertEqual(HomecomingScore.condensed(age: 0), 0, accuracy: 0.001)
        XCTAssertEqual(HomecomingScore.condensed(age: HomecomingScore.firstCondenseEnd), 1, accuracy: 0.001)
        XCTAssertLessThan(HomecomingScore.firstCondenseEnd, HomecomingScore.firstLine1,
                          "the words come after the light has gathered")
        XCTAssertEqual(HomecomingScore.motes.count, 90)
    }
}
