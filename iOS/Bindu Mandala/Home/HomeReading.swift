import Foundation

// MARK: - Upgrade U2 · A · what Home reads (pure)
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Arriving" (the greeting read
// from the ledger, never from a flag — #5), "Being there" (the two weathers
// #8, the ghost yantra lit by his walking as light #12, the bloom #19) and §4
// (App Activity's today rows). The phone's own mirror of the ledger is the
// `RecognitionEntry` log: every `Shakti Recognized` and `Silence Held` row is
// written there first (`RecognitionLogStore`, `MaunaSilence`), so Home reads
// it and never a flag. Nothing here is ever shown as a number: storage may
// count, the screen may not (#84).

/// One act on the phone's mirror of the ledger: when, at which position, and
/// whether she was felt (`Shakti Recognized`) or a silence was held.
struct HomeAct: Equatable {
    let at: Date
    let kp: Int
    let felt: Bool
}

/// What Home reads from the ledger — `spine-and-home.md` #5, #8, #12, #19.
enum HomeReading {

    // MARK: The greeting (#5)

    /// The line Home greets with, if any.
    enum Greeting: Equatable {
        /// After days away: "return. / the road remembers" (2.3 s).
        case returning
        /// The first launch of an ordinary practice day: "Welcome back. The Bindu remembers." (3 s).
        case welcome

        /// The words, verbatim (#5).
        var lines: [String] {
            switch self {
            case .returning: return ["return.", "the road remembers"]
            case .welcome:   return ["Welcome back. The Bindu remembers."]
            }
        }

        /// How long the line stands (#5).
        var seconds: Double {
            switch self {
            case .returning: return 2.3
            case .welcome:   return 3
            }
        }
    }

    /// Two practice days or more since the last act is "days away".
    static let daysAway = 2

    /// The greeting for this launch.
    ///
    /// - `lastActDay`: the practice day of the newest act in the ledger before
    ///   today, or nil when there is none (the first arrival — the Homecoming's
    ///   own Origin greets him then, so Home says nothing).
    /// - `actedToday`: the ledger already holds an act today (a later launch
    ///   of a day already walked: no line).
    /// - `greetedToday`: this phone has already greeted him today (a device
    ///   event, never a gate — a later launch of the same day: no line).
    static func greeting(today: Int, lastActDay: Int?, actedToday: Bool, greetedToday: Bool) -> Greeting? {
        guard !actedToday, !greetedToday, let last = lastActDay else { return nil }
        return today - last >= daysAway ? .returning : .welcome
    }

    /// The newest act's practice day strictly before `today`.
    static func lastActDay(_ acts: [HomeAct], today: Int, dayOf: (Date) -> Int) -> Int? {
        acts.map { dayOf($0.at) }.filter { $0 < today }.max()
    }

    // MARK: The weather (#8)

    /// Met: she has been felt today (a `Shakti Recognized` row dated today).
    static func isMet(_ acts: [HomeAct], today: Int, dayOf: (Date) -> Int) -> Bool {
        acts.contains { $0.felt && dayOf($0.at) == today }
    }

    // MARK: The ghost yantra (#12) — whether, recency, length; never counts

    /// A seat he has never felt is a ghost (5–7 %).
    static let ghost: Double = 0.06

    /// His relationship with one seat, as light: whether he has felt her, how
    /// recently, and for how long he has known her. Never how many times.
    ///
    /// - felt today → `.today` (1.0)
    /// - felt within a week and first felt a month or more ago → `.embodied` (1.0)
    /// - felt within a week → `.active` (.76)
    /// - felt within a month → `.exploring` (.44)
    /// - felt longer ago → `.mapped` (.22)
    static func relationship(first: Date, last: Date, now: Date, today: Int,
                             dayOf: (Date) -> Int) -> BreathEnclosure.Relationship {
        if dayOf(last) == today { return .today }
        let days = now.timeIntervalSince(last) / 86_400
        let known = now.timeIntervalSince(first) / 86_400
        if days <= 7 { return known >= 30 ? .embodied : .active }
        if days <= 30 { return .exploring }
        return .mapped
    }

    /// The light of every seat he has felt, by position (`HouseTokens.statusLight`).
    static func seatLight(_ acts: [HomeAct], now: Date, today: Int, dayOf: (Date) -> Int) -> [Int: Double] {
        var span: [Int: (first: Date, last: Date)] = [:]
        for a in acts where a.felt && (1...KhadgamalaMap.total).contains(a.kp) {
            if let s = span[a.kp] {
                span[a.kp] = (min(s.first, a.at), max(s.last, a.at))
            } else {
                span[a.kp] = (a.at, a.at)
            }
        }
        var out: [Int: Double] = [:]
        for (kp, s) in span {
            let r = relationship(first: s.first, last: s.last, now: now, today: today, dayOf: dayOf)
            out[kp] = HouseTokens.statusLight(r)
        }
        return out
    }

    // MARK: The bloom (#19) — rises fast, falls slow

    /// Each act of the day adds .06.
    static let bloomRise = 0.06
    /// The bloom falls .012 a minute.
    static let bloomFallPerMinute = 0.012
    /// At .7 the ghost yantra itself becomes the crown.
    static let crown = 0.7

    /// The bloom now: every act today adds .06 at its own moment, and the
    /// whole falls .012 a minute between acts, never below 0, never above 1.
    static func bloom(_ acts: [HomeAct], now: Date, today: Int, dayOf: (Date) -> Int) -> Double {
        let times = acts.filter { dayOf($0.at) == today && $0.at <= now }.map(\.at).sorted()
        var b = 0.0
        var t: Date?
        for at in times {
            if let t { b = max(0, b - bloomFallPerMinute * at.timeIntervalSince(t) / 60) }
            b = min(1, b + bloomRise)
            t = at
        }
        if let t { b = max(0, b - bloomFallPerMinute * now.timeIntervalSince(t) / 60) }
        return b
    }
}
