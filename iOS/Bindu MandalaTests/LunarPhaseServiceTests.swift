import XCTest
@testable import Bindu_Mandala

/// The offline lunar math that drives the moon header, tithi Nityā, and
/// the home's atmosphere.
final class LunarPhaseServiceTests: XCTestCase {

    private var utc: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

    func testNewAndFullMoonPhases() {
        let newMoon = LunarPhaseService.referenceNewMoon
        XCTAssertEqual(LunarPhaseService.phase(at: newMoon), .newMoon)

        let full = newMoon.addingTimeInterval(LunarPhaseService.synodicMonth / 2 * 86_400)
        XCTAssertEqual(LunarPhaseService.phase(at: full), .fullMoon)
    }

    func testIlluminationSymmetry() {
        let newMoon = LunarPhaseService.referenceNewMoon
        let full = newMoon.addingTimeInterval(LunarPhaseService.synodicMonth / 2 * 86_400)
        XCTAssertEqual(LunarPhaseService.illumination(at: newMoon), 0, accuracy: 0.02)
        XCTAssertEqual(LunarPhaseService.illumination(at: full), 1, accuracy: 0.02)
    }

    func testTithiMappingMatchesLunarDay() {
        // Across a full synodic cycle, tithi is the waxing day directly, then
        // mirrors in the waning fortnight (day − 15).
        let base = LunarPhaseService.referenceNewMoon
        for dayOffset in 0..<29 {
            let d = base.addingTimeInterval(Double(dayOffset) * 86_400 + 43_200) // midday
            let day = LunarPhaseService.currentDay(at: d)
            let tithi = LunarPhaseService.currentTithi(at: d)
            XCTAssertTrue((1...15).contains(tithi), "tithi \(tithi) out of range on day \(day)")
            let expected = day <= 15 ? day : day - 15
            XCTAssertEqual(tithi, expected)
        }
    }

    func testTimeVariantHourBuckets() {
        // Ten days in — well clear of the new-moon override (fraction ≈ 0.34).
        let base = LunarPhaseService.referenceNewMoon.addingTimeInterval(10 * 86_400)
        func atHour(_ h: Int) -> Date {
            var c = utc.dateComponents([.year, .month, .day], from: base)
            c.hour = h; c.minute = 0
            return utc.date(from: c)!
        }
        XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: atHour(3), calendar: utc), .night)
        XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: atHour(7), calendar: utc), .dawn)
        XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: atHour(12), calendar: utc), .noon)
        XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: atHour(18), calendar: utc), .dusk)
        XCTAssertEqual(LunarPhaseService.currentTimeVariant(at: atHour(22), calendar: utc), .night)
    }

    func testNewMoonOverridesTimeVariant() {
        // At the reference new moon, fraction < 0.03 regardless of hour.
        let v = LunarPhaseService.currentTimeVariant(at: LunarPhaseService.referenceNewMoon, calendar: utc)
        XCTAssertEqual(v, .newmoon)
    }
}
