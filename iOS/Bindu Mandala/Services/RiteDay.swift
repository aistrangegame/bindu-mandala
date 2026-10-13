import Foundation

// MARK: - The day layer, folded into the Rite (pure)
//
// Wave 3. The Bindu Chakras app designed a day around its walk (Experience
// Brief v2 §§4, 5, 7, 8, 10): three doors, never five; a one-second floor that
// is a complete day; the pulse as a haptic; grace — the ledger read back once,
// room-matched, then rest; and the day closed on one witnessing sentence. In
// Mandala these fold into the Rite, around today's Śakti, without adding a
// screen or a count. Everything here is pure, so `RiteDayTests` can hold it.
//
// Under the surviving law (Charter II §4.6) none of it grades him: no door is
// "done" or "left", the floor is complete in itself, grace is a single line
// that rests for days after it speaks, and the close names places, never
// numbers. The exact grace lines and closing sentences are authored here, in
// the build — the Chakras brief keeps them sealed until they are walked.
enum RiteDay {

    // MARK: Three doors

    enum Door: String, CaseIterable, Equatable {
        /// Her Śakti's presence — the way to her room.
        case herRoom
        /// Her bīja, sounded once.
        case oneSound
        /// The floor: Blink. Breathe. Press.
        case oneSecond
        /// The Sakshi close.
        case closeTheDay
    }

    enum Period: Equatable { case morning, midday, evening }

    static func period(hour: Int) -> Period {
        switch hour {
        case 5..<12: return .morning
        case 12..<18: return .midday
        default: return .evening
        }
    }

    /// Three doors, never five. The morning offers directions, the middle of
    /// the day sizes, the evening a way to close it — and one of the three is
    /// always the one-second floor.
    static func doors(hour: Int) -> [Door] {
        switch period(hour: hour) {
        case .morning: return [.herRoom, .oneSound, .oneSecond]
        case .midday:  return [.oneSecond, .oneSound, .herRoom]
        case .evening: return [.oneSecond, .herRoom, .closeTheDay]
        }
    }

    /// The words on a door, by the hour it is offered in.
    static func title(_ door: Door, hour: Int) -> String {
        let p = period(hour: hour)
        switch door {
        case .herRoom:     return p == .midday ? "Her whole room" : (p == .morning ? "Toward her" : "Her room")
        case .oneSound:    return p == .morning ? "Let her sound" : "One sound"
        case .oneSecond:   return "One second"
        case .closeTheDay: return "Close the day"
        }
    }

    // MARK: The one-second floor

    /// The floor's three movements, in order.
    static let floorWords = ["Blink.", "Breathe.", "Press."]

    /// Muladhara's guided breath, 4-4-4 (the root's breath on the Map's
    /// guided-breath table): in, hold, out.
    static let floorBreath: [Double] = [4, 4, 4]

    /// How long the press is held — the Sakshi press-and-hold ring's 1.8 s.
    static let floorPress: Double = 1.8

    /// What the floor says when it is done. Canon (Experience Brief v2 §5).
    static let floorComplete = "That was a full day of walking. Everything else today is extra."

    // MARK: The pulse

    /// The pulse lives in the yantra between the Shadow corridor and Ego
    /// Reveal — the body's rings and the mind's, four through eight — where
    /// the Chakras brief makes the phone her body. Under the thumb only, never
    /// explained.
    static func pulseLives(inRing ring: Int) -> Bool { (4...8).contains(ring) }

    /// The heartbeat, about sixty a minute: a firm beat, a softer one 160 ms
    /// later, then rest to the second.
    static let pulseBeat: (first: Double, second: Double, gap: Double, period: Double) = (0.75, 0.4, 0.16, 1.0)
}

// MARK: - Grace — the quiet co-reader

/// Grace draws one real moment out of the App Activity ledger and returns it,
/// room-matched — her own room first, then a sister's in the same enclosure —
/// once, and then rests. It is read only: nothing is written back.
///
/// It never counts. It says *when* (in nights and days, as words) and *what*
/// (in a verb of the moment's own type), names whom, and says where it was
/// standing. Silence when nothing genuinely fits.
enum GraceChannel {

    /// After grace speaks it rests this many days before it may speak again.
    /// Was 3 — an app-added limit, lifted by ruling 16 (12 Oct 2026). It still
    /// never repeats a moment it has returned (`surfaced`).
    static let restDays = 0
    /// How far back grace reads.
    static let reachDays = 30

    /// The ledger rows that could be room-matched at all: those linked to a
    /// Mandala row, inside the reach.
    static var formula: String {
        let link = ActivityLedger.Field.linkToMandala
        let day = ActivityLedger.Field.activityDate
        return "AND({\(link)}, IS_AFTER({\(day)}, DATEADD(TODAY(), -\(reachDays + 1), 'days')))"
    }

    /// The columns grace reads (by name, as the ledger is read).
    static let fields: [String] = [
        ActivityLedger.Field.activityType,
        ActivityLedger.Field.activityName,
        ActivityLedger.Field.activityDate,
        ActivityLedger.Field.feltAt,
        ActivityLedger.Field.linkToMandala,
        // Wave 6 · grace reads the sisters too (Feed, Learning — any row the
        // ledger links to her), so it must know whose moment it is returning.
        ActivityLedger.Field.sourceApp,
    ]

    struct Line: Equatable {
        let rowId: String
        let text: String
    }

    /// Choose the one line, or none.
    ///
    /// - `herRecordId`: today's Śakti's Mandala row.
    /// - `sisterRecordIds`: the other rows of her enclosure.
    /// - `names`: Mandala record id → her name, from the phone's own roster
    ///   (a row whose name is not known is passed over, never guessed).
    /// - `lastSurfaced` / `surfaced`: when grace last spoke, and which rows it
    ///   has already returned — so it rests, and never repeats itself.
    static func choose(rows: [ActivityLedger.Row],
                       herRecordId: String?,
                       sisterRecordIds: Set<String>,
                       names: [String: String],
                       now: Date,
                       calendar: Calendar = .current,
                       lastSurfaced: Date?,
                       surfaced: Set<String>) -> Line? {
        if let last = lastSurfaced,
           let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: last),
                                              to: calendar.startOfDay(for: now)).day,
           days < restDays {
            return nil
        }
        let today = calendar.startOfDay(for: now)
        guard let earliest = calendar.date(byAdding: .day, value: -reachDays, to: today) else { return nil }

        struct Candidate { let row: ActivityLedger.Row; let at: Date; let link: String; let hers: Bool }
        var candidates: [Candidate] = []
        for row in rows where !surfaced.contains(row.id) {
            guard let type = row.fields.activityType,
                  verb(for: type) != nil || sisterVerb(for: type) != nil else { continue }
            guard let at = ActivityLedger.serverDate(row.fields.feltAt)
                    ?? ActivityLedger.legacyTimestamp(activityDate: row.fields.activityDate,
                                                      timeZone: calendar.timeZone) else { continue }
            guard at < today, at >= earliest else { continue }
            let links = row.fields.linkToMandala ?? []
            if let her = herRecordId, links.contains(her) {
                candidates.append(Candidate(row: row, at: at, link: her, hers: true))
            } else if let sister = links.first(where: { sisterRecordIds.contains($0) }) {
                candidates.append(Candidate(row: row, at: at, link: sister, hers: false))
            }
        }
        let ordered = candidates.sorted {
            if $0.hers != $1.hers { return $0.hers }
            return $0.at > $1.at
        }
        for c in ordered {
            guard let name = names[c.link], !name.isEmpty,
                  let type = c.row.fields.activityType,
                  let text = compose(type: type, name: name, at: c.at, hers: c.hers,
                                     now: now, calendar: calendar) else { continue }
            return Line(rowId: c.row.id, text: text)
        }
        return nil
    }

    /// The moment, in a verb of its own type — or nil for a type grace does
    /// not speak of (a crossing, a note, a milestone row of the archive).
    static func verb(for type: String) -> String? {
        switch type {
        case ActivityLedger.ActivityType.shaktiRecognized: return "you knew %@ as she passed"
        case ActivityLedger.ActivityType.silenceHeld:      return "you kept a silence with %@"
        case ActivityLedger.ActivityType.letterWritten:    return "you wrote to %@"
        case ActivityLedger.ActivityType.firstDwelling:    return "you stayed with %@ until her room changed"
        default: return nil
        }
    }

    /// Wave 6 · a sister instrument's moment, in a verb of its own type — the
    /// Feed's and Learning's acts, when the ledger links them to her. Never
    /// more than the type says (the truth floor): no title, no excerpt.
    static func sisterVerb(for type: String) -> String? {
        switch type {
        case "Story Met":         return "a story met you in the Feed"
        case "Ash Replied":       return "you answered a story in your own words"
        case "Walk Completed":    return "you walked to the centre of the Feed"
        case "Veil Lifted":       return "you stood inside the Light"
        case "Chapter Completed": return "you finished a door in your reading"
        case "Topic Opened":      return "you opened a new reading"
        default: return nil
        }
    }

    static func compose(type: String, name: String, at: Date, hers: Bool,
                        now: Date, calendar: Calendar = .current) -> String? {
        guard let pattern = verb(for: type) ?? sisterVerb(for: type),
              let when = when(at, now: now, calendar: calendar) else { return nil }
        let what = pattern.replacingOccurrences(of: "%@", with: name)
        let where_ = hers ? "It was standing in this room." : "It was standing in this enclosure."
        return "\(when), \(what). \(where_)"
    }

    private static let counted = ["", "", "Two", "Three", "Four", "Five", "Six"]

    /// "Last night", "Three days ago", "A week ago", "A moon ago" — in words,
    /// by the evening or the day the moment belonged to. Nil for today or the
    /// future (grace is never about now).
    static func when(_ at: Date, now: Date, calendar: Calendar = .current) -> String? {
        let start = calendar.startOfDay(for: now)
        guard at < start,
              let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: at), to: start).day,
              days >= 1 else { return nil }
        let hour = calendar.component(.hour, from: at)
        let night = hour >= 18 || hour < 5
        switch days {
        case 1: return night ? "Last night" : "Yesterday"
        case 2...6: return "\(counted[days]) \(night ? "nights" : "days") ago"
        case 7...13: return "A week ago"
        case 14...20: return "Two weeks ago"
        case 21...27: return "Three weeks ago"
        default: return "A moon ago"
        }
    }

    // MARK: Rest (this phone's own memory of when grace spoke)

    static let lastSurfacedKey = "grace_last_surfaced"
    static let surfacedKey = "grace_surfaced_rows"

    static func lastSurfaced(_ defaults: UserDefaults = .standard) -> Date? {
        defaults.object(forKey: lastSurfacedKey) as? Date
    }

    static func surfaced(_ defaults: UserDefaults = .standard) -> Set<String> {
        Set(defaults.stringArray(forKey: surfacedKey) ?? [])
    }

    static func markSurfaced(_ line: Line, at: Date = .now, _ defaults: UserDefaults = .standard) {
        defaults.set(at, forKey: lastSurfacedKey)
        var ids = defaults.stringArray(forKey: surfacedKey) ?? []
        ids.append(line.rowId)
        defaults.set(Array(ids.suffix(240)), forKey: surfacedKey)
    }
}

// MARK: - The Sakshi close

/// The day closes on one witnessing sentence — never accounting. It names what
/// was walked today, by place and by name, and what waited.
enum SakshiClose {

    /// What today held, gathered by the caller from the phone's own record.
    struct Today: Equatable {
        var floorWalked = false
        /// Names of the Śaktis he stopped for today, in the order he did.
        var met: [String] = []
        /// Names he kept a silence with today.
        var silences: [String] = []
        /// The deepest enclosure the Mandala fell to today (0 = none).
        var deepestRing = 0
        /// Today's Śakti, and whether she was among those met.
        var todaysName: String?
        var todayMet = false
    }

    static func sentence(_ d: Today) -> String {
        var walked: [String] = []
        if d.floorWalked { walked.append("walked one second") }
        if !d.met.isEmpty { walked.append("stopped for \(list(d.met))") }
        if !d.silences.isEmpty { walked.append("kept a silence with \(list(d.silences))") }
        if d.deepestRing >= 1 && d.deepestRing <= 9 {
            walked.append(d.deepestRing == 9 ? "fell all the way to the point"
                          : "fell inward to the \(ChakraConstellation.ordinal(d.deepestRing)) enclosure")
        }

        var out: String
        if walked.isEmpty {
            out = "Nothing was asked of you today. The yantra stood open the whole time"
        } else {
            out = "Today you " + phrases(walked)
        }
        out += "."
        if let name = d.todaysName, !d.todayMet {
            out += " \(name) waited. She knows how to wait."
        }
        out += " It trusts you."
        return out
    }

    /// The day's movements joined as one sentence: "a", "a and b", "a, b and c".
    static func phrases(_ items: [String]) -> String {
        guard let last = items.last else { return "" }
        guard items.count > 1 else { return last }
        return items.dropLast().joined(separator: ", ") + " and " + last
    }

    /// "a", "a and b", "a, b and c" — and, past three, "a, b, c and others",
    /// so the sentence can never be read as a tally.
    static func list(_ items: [String]) -> String {
        var seen: [String] = []
        for i in items where !seen.contains(i) { seen.append(i) }
        switch seen.count {
        case 0: return ""
        case 1: return seen[0]
        case 2: return "\(seen[0]) and \(seen[1])"
        case 3: return "\(seen[0]), \(seen[1]) and \(seen[2])"
        default: return "\(seen[0]), \(seen[1]), \(seen[2]) and others"
        }
    }

    // MARK: The floor's day mark (this phone only)

    static let floorDayKey = "floor_practice_day"

    static func floorWalkedToday(_ defaults: UserDefaults = .standard, now: Date = .now) -> Bool {
        guard defaults.object(forKey: floorDayKey) != nil else { return false }
        return defaults.integer(forKey: floorDayKey) == DailyEnergyService.practiceDayIndex(for: now)
    }

    static func markFloorWalked(_ defaults: UserDefaults = .standard, now: Date = .now) {
        defaults.set(DailyEnergyService.practiceDayIndex(for: now), forKey: floorDayKey)
    }
}
