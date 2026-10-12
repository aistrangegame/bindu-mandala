import Foundation

// MARK: - Wave 6 · B · the three pools: essence, memory, being
//
// a-strange-game's storage pools (`storage-pools.md`), one question each:
//
//   • **essence** — *who is walking?* Fixed. In the Mandala this is what was
//     given once and never changes: position as identity, and his own words
//     baked into the instrument (the panel declarations, the five faces' lines).
//     Nothing writes to it at run time.
//   • **memory** — *what was walked?* It accumulates and is never pruned. In the
//     Mandala this is the single ledger, App Activity (R17): every act is a row.
//   • **being** — *how is he arriving today?* Refreshed each visit. In the
//     Mandala this is a small phone-local note of today's arrival — the bell
//     that opened the day, which face spoke, whether a Leela drop came and was
//     carried. Yesterday's being is let go when today's begins.
//
// It is a quiet structure, not a screen: nothing here is drawn, and nothing
// here counts. What it decides is **where what he does lands** — which pool,
// and which of the two places that hold his practice (the Portrait, where what
// was walked becomes light; the Well, where words and asks go into the river)
// a row is routed to.

enum ThreePools {

    enum Pool: String, CaseIterable, Equatable {
        case essence, memory, being
    }

    /// Where a pool's contents are met — never as a number.
    enum Surface: String, Equatable {
        /// The Portrait: what was walked, as light.
        case portrait
        /// The Well: his words, his asks, the river.
        case well
        /// Held, never surfaced.
        case none
    }

    /// Every ledger row is memory — the ledger *is* the memory pool.
    static func pool(forActivityType type: String) -> Pool { .memory }

    /// Which surface a ledger row belongs to. Words and asks go to the Well;
    /// acts of the body and the glass go to the Portrait.
    static func surface(forActivityType type: String) -> Surface {
        typealias T = ActivityLedger.ActivityType
        switch type {
        case T.letterWritten, T.letterSealed, T.letterOpened, T.noteLeft,
             T.wagerResolved, T.leelaDrop:
            return .well
        default:
            return .portrait
        }
    }

    static func surface(for pool: Pool) -> Surface {
        switch pool {
        case .essence: return .none
        case .memory:  return .portrait
        case .being:   return .none
        }
    }

    // MARK: Being — today's arrival, refreshed each visit

    enum BeingMark: Equatable {
        case bellOpened
        case bellClosed
        case faceSpoke(GuideFace)
        case leelaArrived(String)
        case leelaAnswered(String, carried: Bool)
        case lightEntered(kp: Int)

        /// A stable token — what the note keeps.
        var token: String {
            switch self {
            case .bellOpened: return "bell.open"
            case .bellClosed: return "bell.close"
            case .faceSpoke(let f): return "face.\(f.rawValue)"
            case .leelaArrived(let id): return "leela.arrived.\(id)"
            case .leelaAnswered(let id, let carried):
                let how = carried ? "carried" : "held"
                return "leela.\(how).\(id)"
            case .lightEntered(let kp): return "light.\(kp)"
            }
        }
    }

    static let beingKey = "being_today"
    static let beingDayKey = "being_today_day"

    /// Pure: the note for today, given what was kept and on which day. A note
    /// from another day is gone — being refreshes, it does not accumulate.
    static func refreshed(kept: [String], keptDay: Int?, today: Int) -> [String] {
        keptDay == today ? kept : []
    }

    /// Pure: the note with one more mark (marks are not repeated — being is a
    /// state, not a tally).
    static func adding(_ mark: BeingMark, to note: [String]) -> [String] {
        note.contains(mark.token) ? note : note + [mark.token]
    }

    static func noteBeing(_ mark: BeingMark,
                          defaults: UserDefaults = .standard,
                          today: Int = DailyEnergyService.practiceDayIndex()) {
        let kept = defaults.stringArray(forKey: beingKey) ?? []
        let day = defaults.object(forKey: beingDayKey) as? Int
        let note = adding(mark, to: refreshed(kept: kept, keptDay: day, today: today))
        defaults.set(note, forKey: beingKey)
        defaults.set(today, forKey: beingDayKey)
    }

    /// Today's arrival, as tokens. Empty on a new day.
    static func beingToday(defaults: UserDefaults = .standard,
                           today: Int = DailyEnergyService.practiceDayIndex()) -> [String] {
        refreshed(kept: defaults.stringArray(forKey: beingKey) ?? [],
                  keptDay: defaults.object(forKey: beingDayKey) as? Int,
                  today: today)
    }

    static func isBeing(_ mark: BeingMark,
                        defaults: UserDefaults = .standard,
                        today: Int = DailyEnergyService.practiceDayIndex()) -> Bool {
        beingToday(defaults: defaults, today: today).contains(mark.token)
    }
}
