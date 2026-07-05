import XCTest
@testable import Bindu_Mandala

/// The morning-greeting selection: a 6am day-boundary and a deterministic
/// shuffled cycle that covers all 102 exactly once before repeating.
final class DailyEnergyServiceTests: XCTestCase {

    private var utc: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

    private func date(_ y: Int, _ mo: Int, _ d: Int, _ h: Int, _ mi: Int) -> Date {
        var c = DateComponents()
        c.year = y; c.month = mo; c.day = d; c.hour = h; c.minute = mi
        return utc.date(from: c)!
    }

    // MARK: - 6am boundary

    func testDayTurnsOverAtSixAM() {
        let before = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 10, 5, 59), calendar: utc)
        let after  = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 10, 6, 1),  calendar: utc)
        XCTAssertEqual(after, before + 1, "Crossing 06:00 must advance the practice day")
    }

    func testSameDayIsStableAllDay() {
        let morning = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 10, 6, 1),  calendar: utc)
        let night   = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 10, 23, 30), calendar: utc)
        XCTAssertEqual(morning, night, "The energy is fixed for the whole practice day")
    }

    func testConsecutiveDaysIncrementByOne() {
        let a = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 10, 12, 0), calendar: utc)
        let b = DailyEnergyService.practiceDayIndex(for: date(2026, 3, 11, 12, 0), calendar: utc)
        XCTAssertEqual(b, a + 1)
    }

    // MARK: - Determinism

    func testDeterministic() {
        XCTAssertEqual(DailyEnergyService.position(forPracticeDay: 5000),
                       DailyEnergyService.position(forPracticeDay: 5000))
        let d = date(2026, 7, 5, 9, 0)
        XCTAssertEqual(DailyEnergyService.todaysPosition(for: d, calendar: utc),
                       DailyEnergyService.todaysPosition(for: d, calendar: utc))
    }

    func testPositionsAlwaysInRange() {
        for day in 0..<500 {
            let p = DailyEnergyService.position(forPracticeDay: day)
            XCTAssertTrue((1...102).contains(p), "position \(p) out of range on day \(day)")
        }
    }

    // MARK: - Full coverage per cycle

    private func cyclePositions(cycle: Int, count: Int = 102) -> [Int] {
        let base = cycle * count
        return (0..<count).map { DailyEnergyService.position(forPracticeDay: base + $0, count: count) }
    }

    func testEveryEnergyAppearsExactlyOncePerCycle() {
        let positions = cyclePositions(cycle: 7)
        XCTAssertEqual(Set(positions).count, 102, "A 102-day cycle must hit all 102 with no repeats")
        XCTAssertEqual(positions.min(), 1)
        XCTAssertEqual(positions.max(), 102)
    }

    func testCyclesReshuffle() {
        let a = cyclePositions(cycle: 7)
        let b = cyclePositions(cycle: 8)
        XCTAssertNotEqual(a, b, "Each cycle should present a fresh order")
        // …yet both remain complete coverings.
        XCTAssertEqual(Set(a), Set(b))
        XCTAssertEqual(Set(b).count, 102)
    }

    // MARK: - Pre-sync fallback pool

    func testSmallPoolStillFullyCovers() {
        let positions = (0..<16).map { DailyEnergyService.position(forPracticeDay: 16 * 3 + $0, count: 16) }
        XCTAssertEqual(Set(positions).count, 16)
        XCTAssertEqual(positions.min(), 1)
        XCTAssertEqual(positions.max(), 16)
    }
}
