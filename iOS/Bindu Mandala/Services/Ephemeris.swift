import Foundation

// MARK: - The ephemeris (Wave 5 · the Temporal Layer)
//
// "A wrong tithi is a false statement." Until Wave 5 the instrument's moon was a
// mean synodic month counted from one new moon in January 2000 — right on
// average and up to about fourteen hours wrong on any given day, which is long
// enough to name the wrong tithi (and so the wrong Nityā) for half a day.
//
// This file is the real sky, at low precision:
//
//   • the Sun — Meeus, *Astronomical Algorithms* (2nd ed.), ch. 25, the
//     low-accuracy method (≈ 0.01°);
//   • the Moon — Meeus ch. 47, the periodic terms of table 47.A truncated to the
//     sixty longitude terms plus the three additive terms (A1, L′−F, A2); the
//     largest dropped term is under 0.0003°, so the series is good to well
//     under 0.1° — a few minutes of tithi time;
//   • the Lahiri (Chitrapakṣa) ayanāṃśa — 23.857092° at J2000.0, moving with
//     general precession, 50.290966″ a year (≈ 24.23° in October 2026).
//
// UT is used for TT (ΔT ≈ 69 s moves the Moon about 0.01°), and nutation enters
// both longitudes through the same −0.00478° sin Ω term, so it cancels in the
// elongation that defines a tithi.
//
// `LunarPhaseService` — the app's moon header, Nityā and ledger lunar day — is
// now a façade over this file, so the instrument runs one definition of the
// moon, not two. `EphemerisTests` holds the fixtures and their sources.

enum Ephemeris {

    // MARK: Time

    /// Julian Day (UT) of an instant.
    static func julianDay(_ date: Date) -> Double {
        date.timeIntervalSince1970 / 86_400 + 2_440_587.5
    }

    /// Julian centuries since J2000.0.
    static func centuries(_ date: Date) -> Double {
        (julianDay(date) - 2_451_545.0) / 36_525
    }

    static func normalized(_ degrees: Double) -> Double {
        let r = degrees.truncatingRemainder(dividingBy: 360)
        return r < 0 ? r + 360 : r
    }

    /// −180 < x ≤ 180.
    static func signed(_ degrees: Double) -> Double {
        let n = normalized(degrees)
        return n > 180 ? n - 360 : n
    }

    static func radians(_ degrees: Double) -> Double { degrees * .pi / 180 }
    static func degrees(_ radians: Double) -> Double { radians * 180 / .pi }

    // MARK: The Sun (Meeus ch. 25, low accuracy)

    /// Geometric mean longitude of the Sun, degrees.
    static func sunMeanLongitude(_ t: Double) -> Double {
        normalized(280.46646 + 36_000.76983 * t + 0.0003032 * t * t)
    }

    /// Apparent ecliptic longitude of the Sun (tropical, of date), degrees.
    static func sunLongitude(_ date: Date) -> Double {
        let t = centuries(date)
        let l0 = sunMeanLongitude(t)
        let m = radians(357.52911 + 35_999.05029 * t - 0.0001537 * t * t)
        let c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(m)
            + (0.019993 - 0.000101 * t) * sin(2 * m)
            + 0.000289 * sin(3 * m)
        let omega = radians(125.04 - 1_934.136 * t)
        return normalized(l0 + c - 0.00569 - 0.00478 * sin(omega))
    }

    // MARK: The Moon (Meeus ch. 47, truncated)

    /// One row of table 47.A: multiples of D, M, M′, F and the longitude
    /// coefficient in millionths of a degree.
    private struct LunarTerm {
        let d: Double
        let m: Double
        let mp: Double
        let f: Double
        let l: Double
        init(_ d: Double, _ m: Double, _ mp: Double, _ f: Double, _ l: Double) {
            self.d = d; self.m = m; self.mp = mp; self.f = f; self.l = l
        }
    }

    private static let lunarTerms: [LunarTerm] = [
        LunarTerm(0, 0, 1, 0, 6_288_774), LunarTerm(2, 0, -1, 0, 1_274_027),
        LunarTerm(2, 0, 0, 0, 658_314), LunarTerm(0, 0, 2, 0, 213_618),
        LunarTerm(0, 1, 0, 0, -185_116), LunarTerm(0, 0, 0, 2, -114_332),
        LunarTerm(2, 0, -2, 0, 58_793), LunarTerm(2, -1, -1, 0, 57_066),
        LunarTerm(2, 0, 1, 0, 53_322), LunarTerm(2, -1, 0, 0, 45_758),
        LunarTerm(0, 1, -1, 0, -40_923), LunarTerm(1, 0, 0, 0, -34_720),
        LunarTerm(0, 1, 1, 0, -30_383), LunarTerm(2, 0, 0, -2, 15_327),
        LunarTerm(0, 0, 1, 2, -12_528), LunarTerm(0, 0, 1, -2, 10_980),
        LunarTerm(4, 0, -1, 0, 10_675), LunarTerm(0, 0, 3, 0, 10_034),
        LunarTerm(4, 0, -2, 0, 8_548), LunarTerm(2, 1, -1, 0, -7_888),
        LunarTerm(2, 1, 0, 0, -6_766), LunarTerm(1, 0, -1, 0, -5_163),
        LunarTerm(1, 1, 0, 0, 4_987), LunarTerm(2, -1, 1, 0, 4_036),
        LunarTerm(2, 0, 2, 0, 3_994), LunarTerm(4, 0, 0, 0, 3_861),
        LunarTerm(2, 0, -3, 0, 3_665), LunarTerm(0, 1, -2, 0, -2_689),
        LunarTerm(2, 0, -1, 2, -2_602), LunarTerm(2, -1, -2, 0, 2_390),
        LunarTerm(1, 0, 1, 0, -2_348), LunarTerm(2, -2, 0, 0, 2_236),
        LunarTerm(0, 1, 2, 0, -2_120), LunarTerm(0, 2, 0, 0, -2_069),
        LunarTerm(2, -2, -1, 0, 2_048), LunarTerm(2, 0, 1, -2, -1_773),
        LunarTerm(2, 0, 0, 2, -1_595), LunarTerm(4, -1, -1, 0, 1_215),
        LunarTerm(0, 0, 2, 2, -1_110), LunarTerm(3, 0, -1, 0, -892),
        LunarTerm(2, 1, 1, 0, -810), LunarTerm(4, -1, -2, 0, 759),
        LunarTerm(0, 2, -1, 0, -713), LunarTerm(2, 2, -1, 0, -700),
        LunarTerm(2, 1, -2, 0, 691), LunarTerm(2, -1, 0, -2, 596),
        LunarTerm(4, 0, 1, 0, 549), LunarTerm(0, 0, 4, 0, 537),
        LunarTerm(4, -1, 0, 0, 520), LunarTerm(1, 0, -2, 0, -487),
        LunarTerm(2, 1, 0, -2, -399), LunarTerm(0, 0, 2, -2, -381),
        LunarTerm(1, 1, 1, 0, 351), LunarTerm(3, 0, -2, 0, -340),
        LunarTerm(4, 0, -3, 0, 330), LunarTerm(2, -1, 2, 0, 327),
        LunarTerm(0, 2, 1, 0, -323), LunarTerm(1, 1, -1, 0, 299),
        LunarTerm(2, 0, 3, 0, 294),
    ]

    /// Apparent ecliptic longitude of the Moon (tropical, of date), degrees.
    static func moonLongitude(_ date: Date) -> Double {
        let t = centuries(date)
        let t2 = t * t
        let t3 = t2 * t
        let t4 = t3 * t
        let lp = 218.3164477 + 481_267.88123421 * t - 0.0015786 * t2 + t3 / 538_841 - t4 / 65_194_000
        let d = 297.8501921 + 445_267.1114034 * t - 0.0018819 * t2 + t3 / 545_868 - t4 / 113_065_000
        let m = 357.5291092 + 35_999.0502909 * t - 0.0001536 * t2 + t3 / 24_490_000
        let mp = 134.9633964 + 477_198.8675055 * t + 0.0087414 * t2 + t3 / 69_699 - t4 / 14_712_000
        let f = 93.2720950 + 483_202.0175233 * t - 0.0036539 * t2 - t3 / 3_526_000 + t4 / 863_310_000
        let e = 1 - 0.002516 * t - 0.0000074 * t2

        var sum = 0.0
        for term in lunarTerms {
            let arg = term.d * d + term.m * m + term.mp * mp + term.f * f
            var coefficient = term.l
            if abs(term.m) == 1 { coefficient *= e }
            if abs(term.m) == 2 { coefficient *= e * e }
            sum += coefficient * sin(radians(arg))
        }
        let a1 = 119.75 + 131.849 * t
        let a2 = 53.09 + 479_264.290 * t
        sum += 3_958 * sin(radians(a1)) + 1_962 * sin(radians(lp - f)) + 318 * sin(radians(a2))

        let omega = radians(125.04452 - 1_934.136261 * t)
        return normalized(lp + sum / 1_000_000 - 0.00478 * sin(omega))
    }

    /// Moon minus Sun, 0 ≤ x < 360. 0 is the new moon, 180 the full.
    static func elongation(_ date: Date) -> Double {
        normalized(moonLongitude(date) - sunLongitude(date))
    }

    // MARK: The sidereal zodiac

    /// The Lahiri ayanāṃśa, degrees.
    static func lahiriAyanamsa(_ date: Date) -> Double {
        let years = (julianDay(date) - 2_451_545.0) / 365.25
        return 23.857092 + years * 50.290966 / 3_600
    }

    static func siderealMoonLongitude(_ date: Date) -> Double {
        normalized(moonLongitude(date) - lahiriAyanamsa(date))
    }

    static func siderealSunLongitude(_ date: Date) -> Double {
        normalized(sunLongitude(date) - lahiriAyanamsa(date))
    }

    // MARK: The Sun on the sky, for the sandhyās

    /// Mean obliquity of the ecliptic, degrees (Meeus 22.2, truncated).
    static func obliquity(_ t: Double) -> Double {
        23.439291 - 0.0130042 * t
    }

    /// Declination of the Sun, degrees.
    static func sunDeclination(_ date: Date) -> Double {
        let eps = radians(obliquity(centuries(date)))
        let lambda = radians(sunLongitude(date))
        return degrees(asin(sin(eps) * sin(lambda)))
    }

    /// The equation of time, minutes (apparent minus mean solar time).
    static func equationOfTimeMinutes(_ date: Date) -> Double {
        let t = centuries(date)
        let eps = radians(obliquity(t))
        let lambda = radians(sunLongitude(date))
        let alpha = normalized(degrees(atan2(cos(eps) * sin(lambda), cos(lambda))))
        let e = signed(sunMeanLongitude(t) - 0.0057183 - alpha)
        return e * 4
    }
}

// MARK: - Where the sun is being watched from

/// The place the sandhyās are reckoned for. The instrument asks for no
/// location permission: it is one practitioner's, and he is at home in
/// Bensalem, Pennsylvania. When the phone's time zone says he is somewhere
/// else, the longitude follows the zone's standard meridian (good to about
/// half an hour of sun) and the latitude stays home's. Tithi, nakṣatra, ṛtu and
/// ayana do not depend on any of this — only the junctions of the day do.
struct TemporalPlace: Equatable {
    let latitude: Double
    let longitude: Double

    static let home = TemporalPlace(latitude: 40.1046, longitude: -74.9516)
    /// Home's standard offset — US Eastern.
    static let homeStandardOffset: TimeInterval = -5 * 3_600

    static func current(timeZone: TimeZone = .current, at date: Date = .now) -> TemporalPlace {
        let standard = TimeInterval(timeZone.secondsFromGMT(for: date)) - timeZone.daylightSavingTimeOffset(for: date)
        if abs(standard - homeStandardOffset) < 1 { return home }
        return TemporalPlace(latitude: home.latitude, longitude: standard / 3_600 * 15)
    }
}

// MARK: - The pañcāṅga the clocks read

enum Panchanga {

    // MARK: Tithi

    /// The tithi, 1…30: 1–15 the bright fortnight (Śukla), 16–30 the dark
    /// (Kṛṣṇa); 15 is Pūrṇimā and 30 Amāvasyā. floor(elongation / 12) + 1.
    static func tithi(at date: Date) -> Int {
        min(30, max(1, Int(Ephemeris.elongation(date) / 12) + 1))
    }

    static func isShukla(_ tithi: Int) -> Bool { tithi <= 15 }

    /// The tithi within its fortnight, 1…15.
    static func tithiInPaksha(_ tithi: Int) -> Int { tithi <= 15 ? tithi : tithi - 15 }

    static func tithiName(_ tithi: Int) -> String {
        if tithi == 30 { return "Amāvasyā" }
        let i = tithiInPaksha(max(1, min(30, tithi))) - 1
        let names = NityaDevi.tithiNames
        return (0..<names.count).contains(i) ? names[i] : "Pratipadā"
    }

    static func pakshaName(_ tithi: Int) -> String { isShukla(tithi) ? "Śukla" : "Kṛṣṇa" }

    /// The next instant tithi `tithi` begins, strictly after `date` — found on the
    /// real moon (Newton on the elongation), not by counting mean days.
    static func nextStart(ofTithi tithi: Int, after date: Date) -> Date {
        let target = Double(max(1, min(30, tithi)) - 1) * 12
        let rate = 12.190749   // mean elongation, degrees per day
        let ahead = Ephemeris.normalized(target - Ephemeris.elongation(date))
        let lead = ahead < 0.01 ? 360 : ahead
        var guess = date.addingTimeInterval(lead / rate * 86_400)
        for _ in 0..<10 {
            let miss = Ephemeris.signed(Ephemeris.elongation(guess) - target)
            guess = guess.addingTimeInterval(-miss / rate * 86_400)
            if abs(miss) < 0.0005 { break }
        }
        if guess <= date { guess = guess.addingTimeInterval(29.530589 * 86_400) }
        return guess
    }

    // MARK: Nakṣatra

    static let nakshatraNames = [
        "Aśvinī", "Bharaṇī", "Kṛttikā", "Rohiṇī", "Mṛgaśīrṣā", "Ārdrā", "Punarvasu",
        "Puṣya", "Āśleṣā", "Maghā", "Pūrva Phalgunī", "Uttara Phalgunī", "Hasta",
        "Citrā", "Svātī", "Viśākhā", "Anurādhā", "Jyeṣṭhā", "Mūla", "Pūrvāṣāḍhā",
        "Uttarāṣāḍhā", "Śravaṇa", "Dhaniṣṭhā", "Śatabhiṣā", "Pūrva Bhādrapadā",
        "Uttara Bhādrapadā", "Revatī",
    ]

    /// The Moon's nakṣatra, 1…27, on the Lahiri sidereal zodiac.
    static func nakshatra(at date: Date) -> Int {
        min(27, max(1, Int(Ephemeris.siderealMoonLongitude(date) / (360.0 / 27)) + 1))
    }

    static func nakshatraName(_ n: Int) -> String {
        nakshatraNames[max(1, min(27, n)) - 1]
    }

    // MARK: Sun — rāśi, ayana, ṛtu

    static let rashiNames = [
        "Meṣa", "Vṛṣabha", "Mithuna", "Karka", "Siṃha", "Kanyā",
        "Tulā", "Vṛścika", "Dhanu", "Makara", "Kumbha", "Mīna",
    ]

    /// The Sun's sidereal sign, 0…11.
    static func sunRashi(at date: Date) -> Int {
        min(11, Int(Ephemeris.siderealSunLongitude(date) / 30))
    }

    /// Uttarāyaṇa — the Sun's northward half, solstice to solstice (the true,
    /// tropical ayana: λ from 270° through 0° to 90°).
    static func isUttarayana(at date: Date) -> Bool {
        let l = Ephemeris.sunLongitude(date)
        return l >= 270 || l < 90
    }

    static func ayanaName(at date: Date) -> String {
        isUttarayana(at: date) ? "Uttarāyaṇa" : "Dakṣiṇāyana"
    }

    /// The six seasons, each two solar months, reckoned on the tropical Sun
    /// (Śiśira opens at the winter solstice).
    enum Rtu: Int, CaseIterable {
        case shishira, vasanta, grishma, varsha, sharad, hemanta

        var name: String {
            switch self {
            case .shishira: return "Śiśira"
            case .vasanta:  return "Vasanta"
            case .grishma:  return "Grīṣma"
            case .varsha:   return "Varṣā"
            case .sharad:   return "Śarad"
            case .hemanta:  return "Hemanta"
            }
        }

        var english: String {
            switch self {
            case .shishira: return "late winter"
            case .vasanta:  return "spring"
            case .grishma:  return "summer"
            case .varsha:   return "the rains"
            case .sharad:   return "autumn"
            case .hemanta:  return "early winter"
            }
        }
    }

    static func rtu(at date: Date) -> Rtu {
        let fromSolstice = Ephemeris.normalized(Ephemeris.sunLongitude(date) - 270)
        return Rtu(rawValue: min(5, Int(fromSolstice / 60))) ?? .shishira
    }

    // MARK: The day's junctions

    struct SunTimes: Equatable {
        let rise: Date?
        let noon: Date
        let set: Date?
    }

    /// Sunrise, solar noon and sunset for the local calendar day containing
    /// `day` (NOAA's method on the Meeus Sun; h₀ = −0.833°).
    static func sunTimes(on day: Date,
                         place: TemporalPlace,
                         calendar: Calendar = .current) -> SunTimes {
        let ymd = calendar.dateComponents([.year, .month, .day], from: day)
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let midnight = utc.date(from: DateComponents(year: ymd.year, month: ymd.month, day: ymd.day)) ?? day

        var noon = midnight.addingTimeInterval((720 - 4 * place.longitude) * 60)
        for _ in 0..<2 {
            let eot = Ephemeris.equationOfTimeMinutes(noon)
            noon = midnight.addingTimeInterval((720 - 4 * place.longitude - eot) * 60)
        }

        func hourAngle(at instant: Date) -> Double? {
            let phi = Ephemeris.radians(place.latitude)
            let delta = Ephemeris.radians(Ephemeris.sunDeclination(instant))
            let cosH = (sin(Ephemeris.radians(-0.833)) - sin(phi) * sin(delta)) / (cos(phi) * cos(delta))
            guard cosH >= -1, cosH <= 1 else { return nil }
            return Ephemeris.degrees(acos(cosH))
        }

        var rise: Date?
        var set: Date?
        if let h = hourAngle(at: noon) {
            let r0 = noon.addingTimeInterval(-h * 4 * 60)
            let s0 = noon.addingTimeInterval(h * 4 * 60)
            rise = hourAngle(at: r0).map { noon.addingTimeInterval(-$0 * 4 * 60) } ?? r0
            set = hourAngle(at: s0).map { noon.addingTimeInterval($0 * 4 * 60) } ?? s0
        }
        return SunTimes(rise: rise, noon: noon, set: set)
    }

    /// The three sandhyās — the junctions of the day — and the stretches
    /// between them. A sandhyā is one muhūrta (48 minutes) centred on its
    /// junction.
    enum Sandhya: Equatable {
        case pratah, madhyahna, sayam, day, night

        var name: String {
            switch self {
            case .pratah:    return "Prātaḥ sandhyā"
            case .madhyahna: return "Madhyāhna sandhyā"
            case .sayam:     return "Sāyaṃ sandhyā"
            case .day:       return "the day"
            case .night:     return "the night"
            }
        }

        var gloss: String {
            switch self {
            case .pratah:    return "the morning junction"
            case .madhyahna: return "the noon junction"
            case .sayam:     return "the evening junction"
            case .day:       return "the sun is up"
            case .night:     return "the sun is down"
            }
        }

        var isJunction: Bool { self == .pratah || self == .madhyahna || self == .sayam }
    }

    static let sandhyaHalfWidth: TimeInterval = 24 * 60

    static func sandhya(at date: Date,
                        place: TemporalPlace = .current(),
                        calendar: Calendar = .current) -> Sandhya {
        let times = sunTimes(on: date, place: place, calendar: calendar)
        func near(_ t: Date?) -> Bool {
            guard let t else { return false }
            return abs(date.timeIntervalSince(t)) <= sandhyaHalfWidth
        }
        if near(times.rise) { return .pratah }
        if near(times.noon) { return .madhyahna }
        if near(times.set) { return .sayam }
        if let rise = times.rise, let set = times.set {
            return (date > rise && date < set) ? .day : .night
        }
        // Polar day or night: the noon side of the sky decides.
        return Ephemeris.sunDeclination(date) * place.latitude > 0 ? .day : .night
    }
}
