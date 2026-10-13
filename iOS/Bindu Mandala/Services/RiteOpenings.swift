import Foundation

// MARK: - Wave 6 · the Rite's openings, its six stations, and the low-state door (pure)
//
// The Rite keeps its nine-beat arrival (Wave 1) and its day layer (Wave 3).
// What Wave 6 adds stands around them:
//
//   • **The openings** — before the nine beats (once in each half of a practice
//     day until U0; ruling 16 lifted that): *"Stop. Breathe. Remember."*
//     (C-1303), then **the Sacred Pause** (C-1160) — three breaths: release the
//     past · ground in now · let the answer open through the feeling body.
//   • **Dawn and dusk are two rites** (expansion #17). At first light the
//     opening is Śṛṣṭi — creation, warm, with Design's Prātaḥ line; at dusk it
//     is Saṃhāra — dissolution, cool, an offering. The phase of the day is the
//     phase of the rings.
//   • **The liturgical year** (expansion #19). One Śakti a day is a year of a
//     hundred and two days with a shape: its first days Śṛṣṭi-bright, its last
//     dissolving toward the Bindu. The opening's light carries where in it the
//     day stands — felt, never numbered.
//   • **Six stations** (expansion #16): Arrival → Summons → Meeting →
//     Being-with → Offering → Carry. Arrival is the opening, Summons the nine
//     beats, Meeting the ceremony, Being-with the composed screen; Offering and
//     Carry close the Rite after she is felt.
//   • **The low-state door** (C-1002, C-1120): when he says he is low, his own
//     words come back — never a prompt to reflect.

/// Where the Rite's bells (and anything else that marks its edges) may hang.
/// Wave 6.1 · the two drafts meet here: Slice B's two bells (``TheBells``)
/// are what these hooks ring. The opening bell is once a practice day however
/// often it is asked (the Rite's own arrival asks too); the closing bell rings
/// as the day is offered in Pūjā, as it does when the Sakshi close opens.
@MainActor
enum RiteHooks {
    /// The Rite's opening has begun (the first bell's moment).
    static var openingBegan: @MainActor () -> Void = { TheBells.riteOpened() }
    /// The day has been offered and closed (the closing bell's moment).
    static var dayClosed: @MainActor () -> Void = { TheBells.riteClosed() }
}

enum RiteOpening {

    enum Kind: Equatable {
        /// Prātaḥ — first light. Śṛṣṭi.
        case dawn
        /// The open day.
        case day
        /// Sāyam — dusk. Saṃhāra.
        case dusk
        /// The night.
        case night
    }

    static func kind(hour: Int) -> Kind {
        switch hour {
        case 4..<9:   return .dawn
        case 9..<17:  return .day
        case 17..<21: return .dusk
        default:      return .night
        }
    }

    /// His words (C-1303), verbatim.
    static let stop = "Stop. Breathe. Remember."

    /// The Sacred Pause (C-1160): three breaths.
    static let pause = [
        "Let what has passed fall away.",
        "Land here, now.",
        "Let the answer open through the body.",
    ]

    /// How long one breath of the pause takes — in and out. Wave 6.1: the
    /// one breath clock's breath (``BreathClock/breath``), so the Rite's pause
    /// breathes with every other screen.
    static let breathSeconds: TimeInterval = BreathClock.breath

    /// The hour's own call before the pause, where the hour has one. Dawn is
    /// Design's Prātaḥ; dusk is the Saṃhāra of the day, as an offering
    /// (C-1230: never a giving-up).
    static func call(_ kind: Kind) -> String? {
        switch kind {
        case .dawn: return "Open the eyes before the world opens them for you."
        case .dusk: return "What you carried today may be offered here."
        case .day, .night: return nil
        }
    }

    /// Which phase of the rings the hour is: Śṛṣṭi at dawn, Saṃhāra at dusk.
    static func phaseWord(_ kind: Kind) -> String? {
        switch kind {
        case .dawn: return "Śṛṣṭi"
        case .dusk: return "Saṃhāra"
        case .day, .night: return nil
        }
    }

    /// The day's place in the year of a hundred and two days, 0 at its first
    /// day … 1 at its last. Felt as light, never shown.
    static func yearPlace(practiceDay: Int) -> Double {
        let n = KhadgamalaMap.total
        let slot = ((practiceDay % n) + n) % n
        return Double(slot) / Double(n - 1)
    }

    /// The opening's light from the year's place: Śṛṣṭi-bright at the start,
    /// quieter as the year dissolves toward the point.
    static func yearLight(practiceDay: Int) -> Double {
        1 - 0.45 * yearPlace(practiceDay: practiceDay)
    }

    /// The half of the day an opening belongs to — so it comes once in the
    /// morning half and once in the evening half, and never again in between.
    static func half(hour: Int) -> String {
        switch kind(hour: hour) {
        case .dawn, .day: return "light"
        case .dusk, .night: return "dark"
        }
    }

    /// The key an opening is remembered under on this phone.
    static func key(practiceDay: Int, hour: Int) -> String { "\(practiceDay)·\(half(hour: hour))" }

    static let lastOpeningKey = "rite_opening_last"

    // MARK: Wave 6.1 · a mode at its hour

    /// What the hour itself offers — found where it lives (gameplan §1), not
    /// on a list: at first light the night's dream (Svapna), at dusk the day's
    /// offering (Pūjā), and at both junctions of the day the Sandhyā.
    enum HourWay: Equatable, Identifiable {
        case mode(TheModes.Mode)
        case game(PlayGame)

        var id: String {
            switch self {
            case .mode(let m): return "mode." + m.rawValue
            case .game(let g): return "game." + g.rawValue
            }
        }

        /// The one quiet word the opening writes at its foot.
        var word: String {
            switch self {
            case .mode(.svapna): return "the night's dream"
            case .mode(.puja):   return "offer the day"
            case .mode(let m):   return m.title
            case .game(let g):   return g.verb
            }
        }

        var spoken: String {
            switch self {
            case .mode(let m): return "\(m.title) — \(m.gloss)"
            case .game(let g): return "\(g.title) — \(g.verb)"
            }
        }
    }

    static func ways(_ kind: Kind) -> [HourWay] {
        switch kind {
        case .dawn: return [.mode(.svapna), .game(.sandhya)]
        case .dusk: return [.mode(.puja), .game(.sandhya)]
        case .day, .night: return []
        }
    }

    /// Whether the opening is held to once in each half of a practice day.
    /// An app-added limit, lifted by ruling 16 (12 Oct 2026): false.
    static let oncePerHalfDay = false

    /// Whether the opening comes now. With the limit lifted, always; with it
    /// on, not if it already came in this half of this practice day.
    static func opens(lastKey: String?, practiceDay: Int, hour: Int) -> Bool {
        guard oncePerHalfDay else { return true }
        return lastKey != key(practiceDay: practiceDay, hour: hour)
    }
}

// MARK: - The six stations

enum RiteStation: Int, CaseIterable, Equatable {
    case arrival, summons, meeting, beingWith, offering, carry

    var name: String {
        switch self {
        case .arrival:   return "Arrival"
        case .summons:   return "Summons"
        case .meeting:   return "Meeting"
        case .beingWith: return "Being-with"
        case .offering:  return "Offering"
        case .carry:     return "Carry"
        }
    }

    /// The station that follows, or `nil` after Carry — the Rite returns to
    /// Being-with and rests there.
    var next: RiteStation? { RiteStation(rawValue: rawValue + 1) }

    /// The words Offering and Carry say: her Appreciation Phrase returned, and
    /// her own somatic line into the day — her rows, never generated.
    static func closing(appreciation: String?, recognition: String,
                        somaticLine: String?) -> (offering: String?, carry: String?) {
        let a = (appreciation ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let r = recognition.trimmingCharacters(in: .whitespacesAndNewlines)
        let offering = a.isEmpty ? (r.isEmpty ? nil : r) : a
        let c = (somaticLine ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return (offering, c.isEmpty ? nil : c)
    }

    /// The day the Rite last closed this way (kept on the phone).
    static let closedDayKey = "rite_carry_day"

    /// Whether the closing stations are held to once a practice day (expansion
    /// #24). An app-added limit, lifted by ruling 16 (12 Oct 2026): false.
    static let oncePerDay = false
}

// MARK: - The low-state door

/// When he says he is low, the door gives back his own words — a margin note,
/// a line of a letter he wrote her, a sentence he set beside a witness page.
/// Never a question, never a prompt to reflect (C-1002: *"reflection becomes
/// your worst enemy"*), never a mood written down or shown back.
enum LowStateDoor {

    /// The door's own words.
    static let doorWords = "I am low"
    static let heading = "your own words"
    static let empty = "When you have written, your words will wait here for you."

    /// The shortest and longest line the door will hand back on its own.
    static let shortest = 12
    static let longest = 240

    /// His lines, from everything he has written: each source split into its
    /// sentences, kept whole when short, the blank and the fragmentary left out,
    /// each line once. Ordered by the day so the door does not open on the same
    /// line every time, and so the same day always opens the same way.
    static func lines(from sources: [String], practiceDay: Int) -> [String] {
        var seen: Set<String> = []
        var out: [String] = []
        for source in sources {
            for line in sentences(source) where !seen.contains(line) {
                seen.insert(line)
                out.append(line)
            }
        }
        guard !out.isEmpty else { return [] }
        let shift = ((practiceDay % out.count) + out.count) % out.count
        return Array(out[shift...] + out[..<shift])
    }

    /// A source cut into the lines the door can hand back.
    static func sentences(_ text: String) -> [String] {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        if trimmed.count <= longest, trimmed.count >= shortest { return [trimmed] }
        var out: [String] = []
        var current = ""
        for ch in trimmed {
            current.append(ch)
            if ".!?\n".contains(ch) {
                let s = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if s.count >= shortest && s.count <= longest { out.append(s) }
                current = ""
            }
        }
        let tail = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if tail.count >= shortest && tail.count <= longest { out.append(tail) }
        return out
    }
}
