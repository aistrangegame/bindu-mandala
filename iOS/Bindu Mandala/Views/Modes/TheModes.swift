import Foundation

// MARK: - Wave 6 · the Eight Modes, finished (pure)
//
// Design's *The Eight Modes* (`modes.jsx`) built two of eight — Mauna and
// Recognition. Saṅgha is ruled out. These are the rest, reached from the
// Mandala by one door (``ModesDoorView``):
//
//   • **Darśana** — beholding. Hold the phone still and the yantra wakes to
//     the stillness; three depths, arriving · holding · entered — by stillness,
//     never by a clock on the glass.
//   • **Sādhana** — the Khaḍgamālā. The hundred and two names in turn, ring by
//     ring inward, each lighting her seat; at the point the garland is offered
//     back.
//   • **Smṛti** — memory. Every recognition he has made, as light on the
//     yantra: a seat he has felt is lit, and the seats felt on one day are
//     threaded together. A state, never a count.
//   • **Svapna** — the dream. At dawn, who walked through last night: the
//     Śaktis of yesterday's record as dream-light.
//   • **Pūjā** — the evening offering. The day's catches gathered, offered,
//     released: "The day is received. Tomorrow opens again."
//
// Mauna is not on the door: it is not opened, it arrives (C-1307).
//
// Every mode ends in stillness. Every word is Design's or his own, authored;
// nothing is generated, nothing counts him, and nothing is locked.

enum TheModes {

    enum Mode: String, CaseIterable, Identifiable {
        case darshana, sadhana, smriti, svapna, puja
        var id: String { rawValue }

        var title: String {
            switch self {
            case .darshana: return "Darśana"
            case .sadhana:  return "Sādhana"
            case .smriti:   return "Smṛti"
            case .svapna:   return "Svapna"
            case .puja:     return "Pūjā"
            }
        }

        /// Design's own line for each mode.
        var gloss: String {
            switch self {
            case .darshana: return "beholding — the yantra wakes to your stillness"
            case .sadhana:  return "the garland — every name in turn, inward to the point"
            case .smriti:   return "memory — every recognition, as light"
            case .svapna:   return "the dream — who walked through last night"
            case .puja:     return "the offering — the day received"
            }
        }
    }

    /// The door's word for the one mode it does not open.
    /// Wave 6.1 · stillness stays the main way; a gentle touch at the point is
    /// his other (his decision, 12 Oct). The door still does not open it.
    static let maunaGloss = "Mauna is not opened here. Fall to the centre and be still — it arrives; or touch the point gently."

    /// What the door is called on the Mandala.
    static let doorLabel = "The modes"
}

// MARK: - Darśana

/// How deep the beholding has gone. It gathers while the phone is held still
/// and gives way when it moves; its three places are Design's.
struct DarshanaDepth: Equatable {

    enum Stage: Equatable { case arriving, holding, entered }

    private(set) var depth: Double = 0

    static let stillEnough: Double = 0.85
    /// Design's three depths came at 3 s, 30 s and 2 min of stillness; the
    /// same shape as a pace of stillness, never shown as one.
    static let gathering: Double = 1.0 / 120
    static let loosening: Double = 1.0 / 8
    static let holdingFrom: Double = 0.25

    mutating func advance(dt: TimeInterval, steadiness: Double) {
        let h = max(0, min(1.2, dt))
        if steadiness >= Self.stillEnough {
            depth = min(1, depth + h * Self.gathering)
        } else {
            depth = max(0, depth - h * Self.loosening)
        }
    }

    var stage: Stage {
        if depth >= 1 { return .entered }
        if depth >= Self.holdingFrom { return .holding }
        return .arriving
    }

    /// Design's words beneath the yantra: an invitation, then the name of the
    /// state, then only the sign of the endless.
    var words: String {
        switch stage {
        case .arriving: return "hold still · she wakes"
        case .holding:  return "beholding"
        case .entered:  return "∞"
        }
    }
}

// MARK: - Sādhana

enum Sadhana {

    /// Design's whole recitation, about twenty-eight minutes, spread evenly
    /// over the hundred and two — the garland's own pace, never shown.
    static let wholeSeconds: TimeInterval = 28 * 60
    static var perName: TimeInterval { wholeSeconds / Double(KhadgamalaMap.total) }

    /// Design's saṅkalpa.
    static let sankalpa = ["I begin the garland", "not to gain anything,",
                           "but to remember", "what I have always been."]
    static let sankalpaNote = "The names will arrive in sequence, ring by ring inward. Sit upright. Breath low."

    /// Design's visarjana — the garland offered back.
    static let visarjana = ["What I have received,", "the garland is offered back",
                            "to the one who wove it.", "The hundred and two return to the One."]
    /// And the stillness after it.
    static let remains = ["Every name has been said.", "What remains is what was always there."]

    /// The garland's order — position is identity, and the Khaḍgamālā is
    /// recited in it, from the Bhūpura inward to the point.
    static var order: [Int] { Array(1...KhadgamalaMap.total) }

    /// Where the recitation stands after `elapsed` seconds: the index into
    /// ``order``, or `nil` once every name has been said.
    static func index(elapsed: TimeInterval) -> Int? {
        guard elapsed >= 0 else { return 0 }
        let i = Int(elapsed / perName)
        return i < KhadgamalaMap.total ? i : nil
    }

    /// A ring crossed between two names — the moment Design's "You leave … You
    /// enter …" stands.
    static func crossing(from previous: Int, to next: Int) -> (leaving: Int, entering: Int)? {
        let a = KhadgamalaMap.ringNumber(forKhadgamala: previous)
        let b = KhadgamalaMap.ringNumber(forKhadgamala: next)
        return b != a ? (a, b) : nil
    }
}

// MARK: - Smṛti

enum Smriti {

    /// One felt moment, reduced to what Smṛti draws: whose seat, and which
    /// practice day it belonged to.
    struct Moment: Equatable {
        let kp: Int
        let day: Int
    }

    /// Every seat he has felt — lit, and only lit. A seat felt once and a seat
    /// felt a thousand times carry the same light (C-1286: light cannot be
    /// measured, only witnessed).
    static func lit(_ moments: [Moment]) -> Set<Int> {
        Set(moments.map(\.kp).filter { (1...KhadgamalaMap.total).contains($0) })
    }

    /// The constellations: the seats felt on one day, threaded together in the
    /// order of the garland. A day with one seat is a star, not a thread.
    static func threads(_ moments: [Moment]) -> [[Int]] {
        var byDay: [Int: Set<Int>] = [:]
        for m in moments where (1...KhadgamalaMap.total).contains(m.kp) {
            byDay[m.day, default: []].insert(m.kp)
        }
        return byDay.keys.sorted().compactMap { day -> [Int]? in
            let seats = (byDay[day] ?? []).sorted()
            return seats.count > 1 ? seats : nil
        }
    }
}

// MARK: - Svapna

enum Svapna {

    static let question = ["Who walked through", "last night?"]
    /// Design's words when the night left no one in the record.
    static let stillNight = "The night was still."

    /// The Śaktis of yesterday's record, in the order they were met, each once:
    /// those he felt on the practice day before this one.
    static func walkedThrough(_ moments: [(kp: Int, at: Date)], now: Date,
                              dayOf: (Date) -> Int) -> [Int] {
        let yesterday = dayOf(now) - 1
        var out: [Int] = []
        for m in moments.sorted(by: { $0.at < $1.at })
        where dayOf(m.at) == yesterday && (1...KhadgamalaMap.total).contains(m.kp) && !out.contains(m.kp) {
            out.append(m.kp)
        }
        return out
    }
}

// MARK: - Pūjā

enum Puja {

    static let title = "Pūjā · the offering"
    static let offer = "offer the day"
    static let received = ["The day is received.", "Tomorrow opens again."]
    /// When nothing was caught today, the day is still offered whole.
    static let emptyDay = "Nothing was caught today. The day itself is offered."
    /// The hold that offers it.
    static let holdSeconds: TimeInterval = 2.4

    /// Today's catches, in the order they were made, each Śakti once.
    static func gathered(_ moments: [(kp: Int, at: Date)], now: Date,
                         dayOf: (Date) -> Int) -> [Int] {
        let today = dayOf(now)
        var out: [Int] = []
        for m in moments.sorted(by: { $0.at < $1.at })
        where dayOf(m.at) == today && (1...KhadgamalaMap.total).contains(m.kp) && !out.contains(m.kp) {
            out.append(m.kp)
        }
        return out
    }

    /// How far the gathered lights have risen and gone, `p` after the
    /// offering (0 … 1): they draw in to the point, then rise and dissolve.
    static func release(_ p: Double) -> (gather: Double, rise: Double, light: Double) {
        let k = min(1, max(0, p))
        let gather = min(1, k / 0.4)
        let rise = max(0, (k - 0.4) / 0.6)
        return (gather, rise, 1 - rise)
    }
}
