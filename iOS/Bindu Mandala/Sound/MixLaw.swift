import Foundation

// MARK: - Upgrade U1 · B · the law of the mix
//
// `waves/upgrade/worlds/sound.md` §1.2 and S01–S07, S80: layers add together
// and nothing is muted; an accent ducks WORLD and HER to 0.6; the Om is never
// ducked below its floor; only SONG is exclusive; synthesised events ≤ 0.075,
// binaural 0.003–0.050, a limiter at −1 dBFS. Pure — no engine, no session —
// so every clause is a unit test.
//
// This replaces `SoundArbiter.gains` (Wave 6's "one bed at a time", which
// zeroed every bed but the front one and let the Om down to 15 % of its floor
// under a bed). `conductorGains` is the summed law in the conductor's own
// shape, so U2 switches `SoundConductor.apply()` over with one line.

/// The mixing law — `sound.md` §1.2 (S01, S02, S04), S05–S07, S80.
enum MixLaw {

    // MARK: Ceilings (S04, S80)

    /// No synthesised event's voice gain above this.
    static let eventCeiling: Double = 0.075
    /// The binaural lives here (0.10 is too loud on headphones).
    static let binauralRange: ClosedRange<Double> = 0.003...0.050
    /// The limiter, in dBFS…
    static let limiterDBFS: Double = -1
    /// …as a linear ceiling (≈ 0.891).
    static var limiterCeiling: Double { pow(10, limiterDBFS / 20) }
    /// No sudden onset: every voice takes at least this to arrive (s).
    static let minimumAttack: Double = 0.012

    static func clampEvent(_ gain: Double) -> Double { max(0, min(eventCeiling, gain)) }
    static func clampBinaural(_ gain: Double) -> Double {
        min(binauralRange.upperBound, max(binauralRange.lowerBound, gain))
    }

    // MARK: Master (S06)

    static let defaultMasterVolume: Double = 0.8
    /// Tap: stop τ 0.5 s, wake τ 1.2 s (Design's RingSoundToggle).
    static let muteTau: Double = 0.5
    static let wakeTau: Double = 1.2

    // MARK: The Om (S05, S16, S17)

    /// The first touch: the Om from 0 to its floor over 2.4 s (τ 1.2 s).
    static let omWakeSeconds: Double = 2.4
    static let omWakeTau: Double = 1.2
    /// Its slow breath: 0.05 Hz, ±0.008 — applied upward only, so the Om never
    /// dips under its floor.
    static let omBreathHz: Double = 0.05
    static let omBreathDepth: Double = 0.008
    /// The Om's highest (room 33, "Go Play").
    static let omSwellCeiling: Double = 0.20

    /// The Om's floor at a depth (0 Home … 9 the source): 0.004 + 0.026·d/9.
    static func omFloor(depth: Int) -> Double { TreeOfLife.omFloor(depth: depth) }

    /// The Om's level: its floor, or a swell — never below the floor, never
    /// above 0.20. Only master mute silences it (handled at the master).
    static func omLevel(depth: Int, swell: Double?) -> Double {
        let floor = omFloor(depth: depth)
        guard let swell else { return floor }
        return max(floor, min(omSwellCeiling, swell))
    }

    // MARK: Ducking (S01)

    /// An accent ducks WORLD and HER to this.
    static let duckLevel: Double = 0.6
    static let duckAttackTau: Double = 0.12
    /// Released over 0.9 s (τ = 0.3 reaches 95 % in 0.9 s).
    static let duckRelease: Double = 0.9
    static var duckReleaseTau: Double { duckRelease / 3 }

    /// What a bus is multiplied by while an accent rings, at duck depth `d`
    /// (0 none … 1 full). The Om (FLOOR) is never ducked.
    static func duckMultiplier(_ bus: SoundBus, depth d: Double) -> Double {
        switch bus {
        case .world, .her: return 1 - (1 - duckLevel) * max(0, min(1, d))
        default: return 1
        }
    }

    /// Every bus's gain multiplier for a scene: FLOOR always stands; a bus the
    /// scene does not use is 0; the Sound sheet's layer gain (default 1); the
    /// duck. Additive — nothing here zeroes a bus the scene uses.
    static func busGains(scene: Set<SoundBus>, layers: [SoundBus: Double] = [:],
                         duck d: Double = 0) -> [SoundBus: Double] {
        var out: [SoundBus: Double] = [:]
        for bus in SoundBus.allCases {
            let inScene = bus == .floor || scene.contains(bus)
            let layer = max(0, min(1, layers[bus] ?? 1))
            out[bus] = inScene ? layer * duckMultiplier(bus, depth: d) : 0
        }
        return out
    }

    // MARK: SONG (S02, S04)

    static let songGain: Double = 0.8
    /// Fade in 0 → 0.8, +0.015 per 50 ms (≈ 2.7 s; "over 3 s").
    static let songFadeStep: Double = 0.015
    static let songFadeTick: Double = 0.05
    /// Starting a song stops any other over 2 s.
    static let songSwapFade: Double = 2.0

    // MARK: Leaving and the seam (S07)

    static let leavingFade: Double = 2.0
    /// The departing carrier holds at 0.004 for 3.0 s, then decays τ 1.4 s.
    static let seamGain: Double = 0.004
    static let seamHold: Double = 3.0
    static let seamTau: Double = 1.4

    // MARK: Pink noise (S58)

    static let pinkNoiseGain: Double = 0.015
    static let pinkNoiseLowpass: Double = 4000

    // MARK: Binaural or pulse (S57, S80)

    /// What the BINAURAL bus plays: true L/R, an isochronic pulse on the same
    /// carrier, or nothing. Mono Audio always makes it a pulse; `auto` plays the
    /// true pair only on headphones, a pulse on the speaker.
    enum BinauralRendering: Equatable { case stereo, pulse, off }

    static func binauralRendering(mode: SoundBinauralMode, monoAudio: Bool,
                                  headphones: Bool) -> BinauralRendering {
        switch mode {
        case .off: return .off
        case .always: return monoAudio ? .pulse : .stereo
        case .auto: return (monoAudio || !headphones) ? .pulse : .stereo
        }
    }

    /// The isochronic pulse's depth (AM at the beat, depth .5).
    static let pulseDepth: Double = 0.5

    // MARK: The conductor's shape (bridge for U2)

    /// The summed law in `SoundArbiter.gains`'s shape: every claimed bed
    /// sounds (×0.6 while an accent rings), an unclaimed bed waits at 0,
    /// accents at 1, and the Om at 1 — never under its floor.
    static func conductorGains(beds: Set<SoundVoice>, accenting: Bool) -> [SoundVoice: Double] {
        var out: [SoundVoice: Double] = [:]
        for v in SoundVoice.allCases {
            switch v.role {
            case .bed: out[v] = beds.contains(v) ? (accenting ? duckLevel : 1) : 0
            case .floor: out[v] = 1
            case .accent: out[v] = 1
            }
        }
        return out
    }
}

// MARK: - One song source (S02, his C-1350)

/// Only one SONG source plays at a time anywhere: starting a song stops any
/// other (2 s fade); starting the same source twice stops the first. Every
/// start is a fresh session id, so a superseded one is recognised at once.
struct SongSlot: Equatable {

    struct Session: Equatable {
        let id: Int
        let path: String
    }

    enum Action: Equatable {
        /// Start `session`, fading out `stopping` if one was playing.
        case start(Session, stopping: Session?)
        /// Stop `session` (the same source pressed again, or `stop()`).
        case stop(Session)
    }

    private(set) var current: Session?
    private var nextID = 1

    /// He pressed play on `path`.
    mutating func press(_ path: String) -> Action {
        if let playing = current, playing.path == path {
            current = nil
            return .stop(playing)
        }
        let session = Session(id: nextID, path: path)
        nextID += 1
        let previous = current
        current = session
        return .start(session, stopping: previous)
    }

    /// Stop whatever plays (leaving a world: the song never follows him).
    mutating func stop() -> Action? {
        guard let playing = current else { return nil }
        current = nil
        return .stop(playing)
    }

    /// A session finished on its own.
    mutating func finished(_ id: Int) {
        if current?.id == id { current = nil }
    }

    func isCurrent(_ id: Int) -> Bool { current?.id == id }
}

// MARK: - One audio session (S03)

/// What the one session must be: `.ambient` by default (the silent switch is
/// honoured), `.playback` only while he has pressed play on a song (his act),
/// `.playAndRecord` only while a listening gate is open.
enum SoundSessionNeed: Equatable {
    case ambient
    case playback
    case listening

    static func need(songPressed: Bool, listening: Bool) -> SoundSessionNeed {
        if listening { return .listening }
        if songPressed { return .playback }
        return .ambient
    }
}
