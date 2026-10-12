import XCTest
@testable import Bindu_Mandala

// MARK: - EphemerisTests — the real sky, against published values
//
// "A wrong tithi is a false statement." Every fixture here is a published value
// from an outside source, named beside it, checked on 2026-10-12:
//
//   [USNO-PH]  U.S. Naval Observatory, Astronomical Applications — Moon phases,
//              https://aa.usno.navy.mil/api/moon/phases/date?date=2026-09-01&nump=12
//              (times in UT): New 2026-09-11 03:27 · Full 09-26 16:49 ·
//              New 10-10 15:50 · First Q 10-18 16:12 · Full 10-26 04:12 ·
//              Last Q 11-01 20:28 · Full 11-24 14:53.
//   [SKY]      TheSkyLive — https://theskylive.com/new-moon-october-2026 and
//              …/full-moon-october-2026: new moon 2026-10-10 16:50 BST (15:50 UT);
//              full moon 2026-10-26 04:12 GMT. Agrees with [USNO-PH].
//   [SHUBH]    Shubh Panchang, https://shubhpanchang.com/calendar/2026-10-26
//              (IST, UTC+5:30): Purnima ends 09:41 (04:11 UT); Ashvini ends
//              17:41 (12:11 UT), then Bharani.
//   [VEDIC]    Vedic Marga, https://vedicmarga.com/hindu-calendar/2026/10/26/
//              (Kathmandu, UTC+5:45): Purnima ends 09:56 (04:11 UT); Ashwini ends
//              17:56 (12:11 UT). Agrees with [SHUBH].
//   [USNO-RS]  USNO rise/set, https://aa.usno.navy.mil/api/rstt/oneday?
//              date=2026-10-12&coords=40.1046,-74.9516&tz=-4 — Bensalem, PA:
//              rise 07:07, transit 12:46, set 18:25 EDT.
//
// The low-precision series is good to a few hundredths of a degree here; the
// tolerances are set at a quarter of a degree (≈ 30 minutes of the Moon's
// motion against the Sun) and the tithi and nakṣatra fixtures sit two hours
// either side of each boundary, so a pass means the sky is right, not lucky.
final class EphemerisTests: XCTestCase {

    private func utc(_ y: Int, _ mo: Int, _ d: Int, _ h: Int, _ mi: Int) -> Date {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: y, month: mo, day: d, hour: h, minute: mi))!
    }

    private func phaseMiss(_ date: Date, _ target: Double) -> Double {
        abs(Ephemeris.signed(Ephemeris.elongation(date) - target))
    }

    // MARK: Phases — [USNO-PH], [SKY]

    func testNewAndFullMoonsOfAutumn2026() {
        let fixtures: [(Date, Double, String)] = [
            (utc(2026, 9, 11, 3, 27), 0, "new moon 2026-09-11 03:27 UT [USNO-PH]"),
            (utc(2026, 9, 26, 16, 49), 180, "full moon 2026-09-26 16:49 UT [USNO-PH]"),
            (utc(2026, 10, 10, 15, 50), 0, "new moon 2026-10-10 15:50 UT [USNO-PH][SKY]"),
            (utc(2026, 10, 18, 16, 12), 90, "first quarter 2026-10-18 16:12 UT [USNO-PH]"),
            (utc(2026, 10, 26, 4, 12), 180, "full moon 2026-10-26 04:12 UT [USNO-PH][SKY]"),
            (utc(2026, 11, 1, 20, 28), 270, "last quarter 2026-11-01 20:28 UT [USNO-PH]"),
            (utc(2026, 11, 24, 14, 53), 180, "full moon 2026-11-24 14:53 UT [USNO-PH]"),
        ]
        for (date, target, what) in fixtures {
            XCTAssertLessThan(phaseMiss(date, target), 0.25, what)
        }
    }

    /// The old service's own epoch — the new moon of 2000-01-06 18:14 UT
    /// (Meeus, *Astronomical Algorithms*, the example new moon of January 2000).
    func testTheOldEpochIsANewMoonOnTheRealSky() {
        XCTAssertLessThan(phaseMiss(LunarPhaseService.referenceNewMoon, 0), 0.25)
    }

    // MARK: Tithi — [USNO-PH], [SHUBH], [VEDIC]

    func testTheTithiTurnsAtTheNewMoon() {
        XCTAssertEqual(Panchanga.tithi(at: utc(2026, 10, 10, 13, 50)), 30, "Amāvasyā two hours before")
        XCTAssertEqual(Panchanga.tithi(at: utc(2026, 10, 10, 17, 50)), 1, "Śukla Pratipadā two hours after")
        XCTAssertEqual(Panchanga.tithiName(30), "Amāvasyā")
        XCTAssertEqual(Panchanga.tithiName(1), "Pratipadā")
    }

    func testPurnimaEndsAtTheFullMoon() {
        // [SHUBH] Purnima ends 09:41 IST = 04:11 UT; [VEDIC] 09:56 NPT = 04:11 UT.
        XCTAssertEqual(Panchanga.tithi(at: utc(2026, 10, 26, 2, 12)), 15)
        XCTAssertEqual(Panchanga.tithiName(15), "Pūrṇimā")
        XCTAssertEqual(Panchanga.tithi(at: utc(2026, 10, 26, 6, 12)), 16, "Kṛṣṇa Pratipadā")
        XCTAssertEqual(Panchanga.pakshaName(16), "Kṛṣṇa")
        XCTAssertEqual(Panchanga.tithiInPaksha(16), 1)
    }

    func testTheNextTithiStartIsFoundOnTheRealMoon() {
        // Tithi 16 begins at the full moon; tithi 1 at the new.
        let full = Panchanga.nextStart(ofTithi: 16, after: utc(2026, 10, 12, 0, 0))
        XCTAssertEqual(full.timeIntervalSince(utc(2026, 10, 26, 4, 12)), 0, accuracy: 15 * 60,
                       "the full moon of 2026-10-26 04:12 UT [USNO-PH]")
        let new = Panchanga.nextStart(ofTithi: 1, after: utc(2026, 10, 1, 0, 0))
        XCTAssertEqual(new.timeIntervalSince(utc(2026, 10, 10, 15, 50)), 0, accuracy: 15 * 60,
                       "the new moon of 2026-10-10 15:50 UT [USNO-PH]")
        // Strictly after, even from the very instant a tithi begins.
        let again = Panchanga.nextStart(ofTithi: 16, after: full)
        XCTAssertGreaterThan(again.timeIntervalSince(full), 25 * 86_400)
    }

    // MARK: Nakṣatra — [SHUBH], [VEDIC]

    func testTheMoonLeavesAshviniForBharaniOnTheFullMoonDay() {
        // Both sources: Ashvini ends 12:11 UT on 2026-10-26.
        XCTAssertEqual(Panchanga.nakshatra(at: utc(2026, 10, 26, 8, 0)), 1)
        XCTAssertEqual(Panchanga.nakshatraName(1), "Aśvinī")
        XCTAssertEqual(Panchanga.nakshatra(at: utc(2026, 10, 26, 16, 0)), 2)
        XCTAssertEqual(Panchanga.nakshatraName(2), "Bharaṇī")
        // And the boundary itself is within a quarter degree of 13°20′.
        let edge = Ephemeris.siderealMoonLongitude(utc(2026, 10, 26, 12, 11))
        XCTAssertEqual(edge, 360.0 / 27, accuracy: 0.25)
    }

    func testTheLahiriAyanamsaIn2026() {
        // 23.857° at J2000 drifting 50.29″ a year: ≈ 24.23° in October 2026.
        XCTAssertEqual(Ephemeris.lahiriAyanamsa(utc(2026, 10, 12, 0, 0)), 24.23, accuracy: 0.02)
    }

    // MARK: Sun — season, ayana, rāśi, sandhyās — [USNO-RS]

    func testTheSunOnTheTwelfthOfOctober() {
        let day = utc(2026, 10, 12, 16, 0)
        XCTAssertEqual(Panchanga.rtu(at: day), .sharad, "the Sun at ≈199° tropical is in Śarad")
        XCTAssertFalse(Panchanga.isUttarayana(at: day), "between the solstices of June and December")
        XCTAssertEqual(Panchanga.ayanaName(at: day), "Dakṣiṇāyana")
        XCTAssertEqual(Panchanga.rashiNames[Panchanga.sunRashi(at: day)], "Kanyā",
                       "sidereal ≈175°: the Sun is in Kanyā until Tulā saṅkrānti on 17 October")
        // The seasons turn at the solstices and equinoxes on the true Sun.
        XCTAssertEqual(Panchanga.rtu(at: utc(2026, 1, 1, 12, 0)), .shishira)
        XCTAssertTrue(Panchanga.isUttarayana(at: utc(2026, 1, 1, 12, 0)))
        XCTAssertEqual(Panchanga.rtu(at: utc(2026, 7, 4, 12, 0)), .varsha)
    }

    func testSunriseNoonAndSunsetAtHome() throws {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        let t = Panchanga.sunTimes(on: utc(2026, 10, 12, 16, 0), place: .home, calendar: cal)
        let rise = try XCTUnwrap(t.rise)
        let set = try XCTUnwrap(t.set)
        XCTAssertEqual(rise.timeIntervalSince(utc(2026, 10, 12, 11, 7)), 0, accuracy: 120, "07:07 EDT [USNO-RS]")
        XCTAssertEqual(t.noon.timeIntervalSince(utc(2026, 10, 12, 16, 46)), 0, accuracy: 120, "12:46 EDT [USNO-RS]")
        XCTAssertEqual(set.timeIntervalSince(utc(2026, 10, 12, 22, 25)), 0, accuracy: 120, "18:25 EDT [USNO-RS]")

        XCTAssertEqual(Panchanga.sandhya(at: utc(2026, 10, 12, 11, 7), place: .home, calendar: cal), .pratah)
        XCTAssertEqual(Panchanga.sandhya(at: utc(2026, 10, 12, 16, 46), place: .home, calendar: cal), .madhyahna)
        XCTAssertEqual(Panchanga.sandhya(at: utc(2026, 10, 12, 22, 25), place: .home, calendar: cal), .sayam)
        XCTAssertEqual(Panchanga.sandhya(at: utc(2026, 10, 12, 14, 0), place: .home, calendar: cal), .day)
        XCTAssertEqual(Panchanga.sandhya(at: utc(2026, 10, 13, 3, 0), place: .home, calendar: cal), .night)
    }

    func testThePlaceIsHomeInHomesZone() throws {
        let ny = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        XCTAssertEqual(TemporalPlace.current(timeZone: ny, at: utc(2026, 10, 12, 12, 0)), .home)
        XCTAssertEqual(TemporalPlace.current(timeZone: ny, at: utc(2026, 1, 12, 12, 0)), .home)
        let kolkata = try XCTUnwrap(TimeZone(identifier: "Asia/Kolkata"))
        XCTAssertEqual(TemporalPlace.current(timeZone: kolkata).longitude, 82.5, accuracy: 0.001,
                       "away from home, the zone's standard meridian")
    }

    // MARK: One moon — `LunarPhaseService` is the same sky

    func testTheServiceAndThePanchangaNeverDisagree() {
        var d = utc(2026, 10, 1, 0, 0)
        for _ in 0..<120 {
            XCTAssertEqual(LunarPhaseService.currentDay(at: d), Panchanga.tithi(at: d))
            XCTAssertEqual(LunarPhaseService.phaseFraction(at: d), Ephemeris.elongation(d) / 360, accuracy: 1e-12)
            d = d.addingTimeInterval(6 * 3_600)
        }
        XCTAssertEqual(LunarPhaseService.phase(at: utc(2026, 10, 26, 4, 12)), .fullMoon)
        XCTAssertEqual(LunarPhaseService.phase(at: utc(2026, 10, 10, 15, 50)), .newMoon)
    }

    func testTheNewMoonDarkensBothSidesOfTheConjunction() {
        var utcCal = Calendar(identifier: .gregorian)
        utcCal.timeZone = TimeZone(secondsFromGMT: 0)!
        for offset in [-12.0, -1, 0, 1, 12] {
            let d = utc(2026, 10, 10, 15, 50).addingTimeInterval(offset * 3_600)
            XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: d, calendar: utcCal), .newmoon,
                           "\(offset) h from the conjunction")
        }
        XCTAssertNotEqual(LunarPhaseService.currentTimeVariant(at: utc(2026, 10, 14, 12, 0), calendar: utcCal),
                          .newmoon)
    }

    // MARK: The Temporal Layer's reading

    func testTheFiveClocksReadTheSameSky() throws {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        let r = TemporalReading(at: utc(2026, 10, 26, 8, 0), calendar: cal, place: .home)
        XCTAssertEqual(r.tithi, 16)
        XCTAssertEqual(r.tithiWords, "Kṛṣṇa Pratipadā")
        XCTAssertEqual(r.nakshatraWords, "Aśvinī")
        XCTAssertEqual(r.rtu, .sharad)
        XCTAssertEqual(r.hourFraction, 4.0 / 24, accuracy: 1e-9, "04:00 EDT")
        XCTAssertTrue(r.sunWords.hasSuffix("Dakṣiṇāyana"))
    }
}
