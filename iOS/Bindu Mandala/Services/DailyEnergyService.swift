import Foundation

/// Chooses which of the 102 energies greets the practitioner today.
///
/// The practice day turns at **6am local** — a new energy arrives each morning,
/// stays for the whole day, and is the same one the 6am notification names.
/// Selection is a **deterministic shuffled cycle**: within any window of `count`
/// practice-days every energy appears exactly once (no repeats), and each new
/// cycle re-shuffles the order. Pure and offline — the same date always yields
/// the same energy, on device and in tests.
enum DailyEnergyService {

    /// The hour (local) at which the day's energy turns over.
    static let dayBoundaryHour = 6

    /// Fixed anchor for counting practice-days: 2020-01-01 00:00 UTC.
    /// Only the *difference* from this instant matters, so its exact value is
    /// arbitrary as long as it never changes.
    private static let epoch = Date(timeIntervalSince1970: 1_577_836_800)

    /// Whole practice-days between the epoch and `date`, incrementing at 6am
    /// local. 05:59 belongs to the previous practice-day; 06:01 to the new one.
    static func practiceDayIndex(for date: Date = .now,
                                 calendar: Calendar = .current) -> Int {
        let shift = TimeInterval(dayBoundaryHour * 3600)
        let shiftedNow   = date.addingTimeInterval(-shift)
        let shiftedEpoch = epoch.addingTimeInterval(-shift)
        let startNow   = calendar.startOfDay(for: shiftedNow)
        let startEpoch = calendar.startOfDay(for: shiftedEpoch)
        return calendar.dateComponents([.day], from: startEpoch, to: startNow).day ?? 0
    }

    /// The Khaḍgamālā position (1…count) presiding over a given practice-day.
    /// `count` defaults to the full 102 but accepts a smaller pool before the
    /// first Airtable sync (when only the 16 bootstrap Karṣiṇīs are loaded), so
    /// a fresh install still greets the practitioner with a real energy.
    static func position(forPracticeDay day: Int,
                         count: Int = KhadgamalaMap.total) -> Int {
        guard count > 0 else { return 1 }
        let cycle = floorDiv(day, count)
        let slot  = floorMod(day, count)
        return shuffledPositions(count: count, seed: seed(forCycle: cycle))[slot]
    }

    /// The energy presiding over `date` (default now).
    static func todaysPosition(for date: Date = .now,
                               count: Int = KhadgamalaMap.total,
                               calendar: Calendar = .current) -> Int {
        position(forPracticeDay: practiceDayIndex(for: date, calendar: calendar),
                 count: count)
    }

    // MARK: - Deterministic shuffle

    /// A permutation of 1…count produced by Fisher–Yates over a seeded PRNG.
    private static func shuffledPositions(count: Int, seed: UInt64) -> [Int] {
        var positions = Array(1...count)
        var rng = SplitMix64(state: seed)
        var i = count - 1
        while i >= 1 {
            let j = Int(rng.next() % UInt64(i + 1))
            positions.swapAt(i, j)
            i -= 1
        }
        return positions
    }

    private static func seed(forCycle cycle: Int) -> UInt64 {
        // Mix the cycle into a stable non-zero seed. Bit-pattern keeps negative
        // cycles well-defined; the constant de-correlates adjacent cycles.
        UInt64(bitPattern: Int64(cycle)) ^ 0xD1B54A32D192ED03
    }

    // MARK: - Floored integer math (well-defined for negative days)

    private static func floorDiv(_ a: Int, _ b: Int) -> Int {
        let q = a / b
        return (a % b != 0 && (a < 0) != (b < 0)) ? q - 1 : q
    }

    private static func floorMod(_ a: Int, _ b: Int) -> Int {
        let r = a % b
        return r != 0 && (r < 0) != (b < 0) ? r + b : r
    }
}

/// SplitMix64 — a tiny, fast, well-distributed seeded PRNG. Deterministic given
/// its seed, which is exactly what a repeatable daily shuffle needs.
private struct SplitMix64 {
    var state: UInt64

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
