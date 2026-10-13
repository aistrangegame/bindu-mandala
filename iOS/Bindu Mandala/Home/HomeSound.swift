import UIKit

// MARK: - Upgrade U2 · A · the sound of Home
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #20 through the U1 mixer
// (`Sound/SoundMixer.swift`, `sound.md` S05): nothing sounds at launch; the
// first touch on Home wakes the mixer and the Om rises to its floor at 136.1 Hz
// (partials 272.2 and 68.05 — the mixer's FLOOR bus); Home's own voice comes
// in; and the Bells open the day at 272.2, once a practice day — the same
// once as the Rite's opening bell (`TheBells.openedDayKey`), so the day opens
// with one bell wherever he first stands.

/// Home's sound — `spine-and-home.md` #20.
@MainActor
enum HomeSound {

    /// The first touch on Home: the mixer wakes (the Om from 0 to its floor),
    /// Home's voice, and the day's opening bell if it has not yet rung.
    static func touched(mixer: SoundMixer = .shared) {
        mixer.wakeOnFirstTouch()
        arrive(mixer: mixer)
        openTheDay(mixer: mixer)
    }

    /// Home's voice, when the mixer is awake and another world was sounding.
    static func arrive(mixer: SoundMixer = .shared) {
        guard mixer.isAwake, mixer.world != .home else { return }
        mixer.enter(.home)
    }

    /// The day's opening bell (272.2 Hz), once a practice day — `TheBells`'
    /// own once, read and written under its own key.
    static func openTheDay(mixer: SoundMixer = .shared,
                           defaults: UserDefaults = .standard,
                           today: Int = DailyEnergyService.practiceDayIndex()) {
        guard !AppRuntime.isUnitTesting, mixer.isAwake else { return }
        let last = defaults.object(forKey: TheBells.openedDayKey) as? Int
        guard TheBells.opens(lastOpenedDay: last, today: today) else { return }
        defaults.set(today, forKey: TheBells.openedDayKey)
        ThreePools.noteBeing(.bellOpened, defaults: defaults, today: today)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.9)
        mixer.strike(.tone(hz: Tuning.dayBellOpen, seconds: 5.5, peak: MixLaw.eventCeiling))
    }
}
