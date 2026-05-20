import Foundation

/// Maps the current moment to one of the 16 Karṣiṇī Śaktis using lunar age.
///
/// Today's Shakti index = `floor(moon_age_in_days) mod 16` → 0–15
/// (so petal index — petal 0 sits at 12 o'clock).
///
/// Moon age is computed as days since a known new moon epoch, modulo the
/// synodic period. This is local-only and deterministic — no network.
enum LunarPhaseService {

    /// Synodic month — average days between new moons.
    static let synodicMonth: Double = 29.53058867

    /// Reference new moon: 2000-01-06 18:14 UTC (well-known epoch).
    static let referenceNewMoon: Date = {
        var c = DateComponents()
        c.year = 2000; c.month = 1; c.day = 6
        c.hour = 18;   c.minute = 14
        c.timeZone = TimeZone(identifier: "UTC")
        return Calendar(identifier: .gregorian).date(from: c) ?? Date(timeIntervalSince1970: 947182440)
    }()

    /// Days since the most recent new moon at `date`. Range [0, synodicMonth).
    static func moonAgeDays(at date: Date = .now) -> Double {
        let elapsed = date.timeIntervalSince(referenceNewMoon) / 86_400
        let age = elapsed.truncatingRemainder(dividingBy: synodicMonth)
        return age < 0 ? age + synodicMonth : age
    }

    /// 0–15. Maps to Shakti.position via `+ 1`.
    static func todayPetalIndex(at date: Date = .now) -> Int {
        let age = floor(moonAgeDays(at: date))
        return Int(age.truncatingRemainder(dividingBy: 16))
    }

    /// 1–16.
    static func todayPosition(at date: Date = .now) -> Int {
        todayPetalIndex(at: date) + 1
    }

    /// Phase 0…1 around the synodic cycle (0 = new moon, 0.5 = full).
    static func phaseFraction(at date: Date = .now) -> Double {
        moonAgeDays(at: date) / synodicMonth
    }

    enum Phase {
        case newMoon, waxingCrescent, firstQuarter, waxingGibbous
        case fullMoon, waningGibbous, lastQuarter, waningCrescent

        var label: String {
            switch self {
            case .newMoon:         return "New Moon"
            case .waxingCrescent:  return "Waxing Crescent"
            case .firstQuarter:    return "First Quarter"
            case .waxingGibbous:   return "Waxing Gibbous"
            case .fullMoon:        return "Full Moon"
            case .waningGibbous:   return "Waning Gibbous"
            case .lastQuarter:     return "Last Quarter"
            case .waningCrescent:  return "Waning Crescent"
            }
        }
    }

    static func phase(at date: Date = .now) -> Phase {
        let f = phaseFraction(at: date)
        switch f {
        case ..<0.03:  return .newMoon
        case ..<0.22:  return .waxingCrescent
        case ..<0.28:  return .firstQuarter
        case ..<0.47:  return .waxingGibbous
        case ..<0.53:  return .fullMoon
        case ..<0.72:  return .waningGibbous
        case ..<0.78:  return .lastQuarter
        case ..<0.97:  return .waningCrescent
        default:       return .newMoon
        }
    }

    /// "Waning Crescent · 23rd Night" — for the Today header.
    static func headerLabel(at date: Date = .now) -> String {
        let p = phase(at: date)
        let night = Int(floor(moonAgeDays(at: date))) + 1
        return "\(p.label) · \(ordinalNight(night)) Night"
    }

    private static func ordinalNight(_ n: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .ordinal
        return f.string(from: NSNumber(value: n)) ?? "\(n)"
    }

    /// Illuminated fraction 0…1 — used by the moon SVG.
    static func illumination(at date: Date = .now) -> Double {
        let f = phaseFraction(at: date)
        return (1 - cos(2 * .pi * f)) / 2
    }
}
