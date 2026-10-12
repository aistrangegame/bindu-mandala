import XCTest
@testable import Bindu_Mandala

/// Wave 5 · the random gift: at most once a day, inside his window, never in
/// the past, and the same draw every time the fortnight is redrawn — so a
/// reschedule can never deliver a day's gift twice.
final class EnergyGiftTests: XCTestCase {

    private var newYork: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "America/New_York")!
        return c
    }

    private func local(_ d: Int, _ h: Int, _ m: Int = 0) -> Date {
        newYork.date(from: DateComponents(year: 2026, month: 10, day: d, hour: h, minute: m))!
    }

    func testAtMostOneGiftADayInsideTheWindow() {
        let cal = newYork
        let plan = EnergyGift.plan(from: local(12, 6), days: 14, windowStart: 10, windowEnd: 20,
                                   salt: 0xBADA55, calendar: cal)
        XCTAssertEqual(plan.count, 14, "the window has not opened yet today, so today keeps its gift")
        let days = plan.map { cal.startOfDay(for: $0.fireAt) }
        XCTAssertEqual(Set(days).count, plan.count, "never two on one day")
        for gift in plan {
            let h = cal.component(.hour, from: gift.fireAt)
            XCTAssertTrue((10..<20).contains(h), "\(gift.fireAt) is outside his window")
            XCTAssertTrue((1...KhadgamalaMap.total).contains(gift.khadgamalaPosition))
        }
    }

    func testNothingIsPlannedInThePast() {
        let cal = newYork
        let now = local(12, 19, 59)
        let plan = EnergyGift.plan(from: now, days: 3, windowStart: 10, windowEnd: 20, salt: 7, calendar: cal)
        XCTAssertTrue(plan.allSatisfy { $0.fireAt > now })
        XCTAssertLessThanOrEqual(plan.count, 3)
    }

    func testTheSameDayDrawsTheSameGiftEveryTime() {
        let cal = newYork
        let a = EnergyGift.plan(from: local(12, 6), days: 14, windowStart: 9, windowEnd: 21, salt: 42, calendar: cal)
        let b = EnergyGift.plan(from: local(12, 9), days: 14, windowStart: 9, windowEnd: 21, salt: 42, calendar: cal)
        // Redrawing later the same morning keeps every gift where it was.
        let laterDays = Dictionary(uniqueKeysWithValues: b.map { (cal.startOfDay(for: $0.fireAt), $0) })
        for gift in a where gift.fireAt > local(12, 9) {
            XCTAssertEqual(laterDays[cal.startOfDay(for: gift.fireAt)], gift)
        }
        let other = EnergyGift.plan(from: local(12, 6), days: 14, windowStart: 9, windowEnd: 21, salt: 43, calendar: cal)
        XCTAssertNotEqual(a, other, "another install's gifts are its own")
    }

    func testTheWindowIsMadeSane() {
        XCTAssertTrue(EnergyGift.window(start: 10, end: 20) == (10, 20))
        XCTAssertTrue(EnergyGift.window(start: 20, end: 10) == (20, 21), "an inverted window is one hour")
        XCTAssertTrue(EnergyGift.window(start: -3, end: 99) == (0, 24))
        XCTAssertTrue(EnergyGift.window(start: 23, end: 23) == (23, 24))
    }

    func testANarrowWindowStillHoldsItsGift() {
        let cal = newYork
        let plan = EnergyGift.plan(from: local(12, 0), days: 5, windowStart: 7, windowEnd: 8, salt: 9, calendar: cal)
        XCTAssertEqual(plan.count, 5)
        XCTAssertTrue(plan.allSatisfy { cal.component(.hour, from: $0.fireAt) == 7 })
    }
}
