import UIKit

// MARK: - Wave 6 · B · the two bells
//
// a-strange-game's Junction 1 (the playing side, 01 and 05): *"Two bells."* The
// day is one round of play, and a bell opens it and a bell closes it — the
// traditions' shared grammar (bell · body · word · offering · release),
// borrowed without its rules. Bells come to him; nothing is missed when one is
// not heard, and nothing counts them.
//
//   • **The opening bell** — the first time the Rite opens on a practice day:
//     a struck bowl an octave above the Om (272.2), bright, and a firm haptic.
//   • **The closing bell** — whenever the Sakshi close opens: the bowl on the
//     Om's own 136.1, lower, and a softer haptic that falls away.
//
// Sound and haptic both, so a phone on silent still feels the day open. The
// two are the Rite's only change in this slice (the Rite's openings belong to
// Slice C).

enum TheBells {

    /// The opening bell's pitch: the Om's octave.
    static let openingHz: Double = TreeOfLife.omHz * 2
    /// The closing bell's pitch: the Om itself.
    static let closingHz: Double = TreeOfLife.omHz

    static let openedDayKey = "bell_opened_day"

    /// Pure: does the opening bell ring now? Once a practice day.
    static func opens(lastOpenedDay: Int?, today: Int) -> Bool {
        lastOpenedDay != today
    }

    /// The Rite has opened. Rings the day's opening bell if it has not yet rung.
    @MainActor
    static func riteOpened(defaults: UserDefaults = .standard,
                           today: Int = DailyEnergyService.practiceDayIndex()) {
        guard !AppRuntime.isUnitTesting else { return }
        let last = defaults.object(forKey: openedDayKey) as? Int
        guard opens(lastOpenedDay: last, today: today) else { return }
        defaults.set(today, forKey: openedDayKey)
        ThreePools.noteBeing(.bellOpened, defaults: defaults, today: today)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.9)
        BijaSoundService.shared.playBell(frequency: openingHz, duration: 5.5, volume: 0.2)
    }

    /// The day is being closed.
    @MainActor
    static func riteClosed() {
        guard !AppRuntime.isUnitTesting else { return }
        ThreePools.noteBeing(.bellClosed)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.4)
        }
        BijaSoundService.shared.playBell(frequency: closingHz, duration: 7, volume: 0.22)
    }
}
