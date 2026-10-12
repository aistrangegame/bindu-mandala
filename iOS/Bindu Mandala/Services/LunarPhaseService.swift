import Foundation

/// The instrument's moon: phase, lunar day (tithi), header and time state.
///
/// **Wave 5 — one moon, the real one.** Until Wave 5 this counted mean synodic
/// days from one new moon in January 2000, which is right on average and up to
/// about fourteen hours wrong on a given day — long enough to name the wrong
/// tithi, and so the wrong Nityā. It is now a façade over `Ephemeris` /
/// `Panchanga` (Meeus ch. 25 and 47): the phase is the Moon's true elongation
/// from the Sun, and the lunar day is the true tithi, `floor(elongation / 12) + 1`.
/// The Temporal Layer's clocks read the same functions, so the Rite's Nityā,
/// the ledger's `Lunar Day` and the clock around the point never disagree.
///
/// Local-only and deterministic — no network.
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

    /// The Moon's age in mean days, [0, synodicMonth): the true elongation
    /// scaled onto the mean month. Kept for callers that think in days.
    static func moonAgeDays(at date: Date = .now) -> Double {
        phaseFraction(at: date) * synodicMonth
    }

    /// Phase 0…1 around the synodic cycle (0 = new moon, 0.5 = full) — the
    /// Moon's true elongation from the Sun over 360°.
    static func phaseFraction(at date: Date = .now) -> Double {
        Ephemeris.elongation(date) / 360
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
        let night = currentDay(at: date)
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

    /// Lunar day 1–30 — the true tithi (Wave 5): 1–15 Śukla, 16–30 Kṛṣṇa.
    /// Used by Recognition writes (`Lunar Day` on the ledger row) and the
    /// Rite's Nityā.
    static func currentDay(at date: Date = .now) -> Int {
        Panchanga.tithi(at: date)
    }

    /// Human-readable phase name — "Waxing Crescent", "Full Moon", etc.
    /// Used by Phase 6 Recognition writes (`Moon Phase` field).
    static func phaseName(at date: Date = .now) -> String {
        phase(at: date).label
    }

    /// The astronomical tithi 1–15 within the current fortnight. Synodic day
    /// 1–15 = waxing tithi 1–15; synodic day 16–30 = waning tithi 1–15 (currentDay − 15).
    ///
    /// NOTE: this is the *tithi within the fortnight*, NOT the Nityā position.
    /// The Nityā mapping (see `DailyRiteView.nityaSlot`) mirrors the waning
    /// fortnight back down — `15 − (day − 15)`, reusing the 15 Nityās in reverse,
    /// per the prototype's `lrMoon`. Do not wire this method into Nityā resolution.
    static func currentTithi(at date: Date = .now) -> Int {
        let day = currentDay(at: date)
        return day <= 15 ? day : (day - 15)
    }

    /// True for synodic day 1–15 (Śukla Pakṣa).
    static func isWaxingFortnight(at date: Date = .now) -> Bool {
        currentDay(at: date) <= 15
    }

    /// The Mandala's atmospheric state. New moon overrides everything;
    /// otherwise hour-of-day → dawn / noon / dusk / night, contiguously.
    ///
    /// Wave 5: "new moon" is the `.newMoon` phase on both sides of the
    /// conjunction (fraction < 0.03 or ≥ 0.97). On the true moon the
    /// conjunction itself reads 0.9999…, and with only the after-side counted
    /// the darkest night of the month would not have been the new moon at all.
    static func currentTimeVariant(at date: Date = .now,
                                   calendar: Calendar = .current) -> TimeVariant {
        if phase(at: date) == .newMoon { return .newmoon }
        let hour = calendar.component(.hour, from: date)
        if hour < 5 || hour >= 21 { return .night }
        if hour < 10                { return .dawn }
        if hour < 15                { return .noon }
        return .dusk
    }
}
