import Foundation

// MARK: - Upgrade U1 · B · seven buses, fifteen voices
//
// `waves/upgrade/worlds/sound.md` §1.2 (the buses, S01) and §1.5 (each world's
// voice, S22). The beds are WORLD_ESSENCE's (register 14-aistrangegame.md,
// DH:3621–3676), moved onto the one tuning where sound.md says so; the engine
// law is DH:4208–4376: lowpass Q .65, one shared 0.08 Hz LFO at depth
// cutoff × 0.25, ±2 cents per partial, 2.6 s crossfade, outgoing stopped at
// 2.9 s, bed to 0.028 over 2.4 s.

/// The seven layers of the mixer — `sound.md` §1.2 (S01). Additive: nothing
/// mutes anything; only SONG is exclusive.
enum SoundBus: String, CaseIterable, Hashable {
    /// Om 68.05 / 136.1 / 272.2 + pink noise. Never ducked below its floor.
    case floor
    /// The world's bed voice.
    case world
    /// Ring ground + her carrier + air, or a 33 room's fixed tone.
    case her
    /// True L/R carrier + beat (an isochronic pulse under Mono Audio / speaker).
    case binaural
    /// His recording under a Score. Exclusive.
    case song
    /// Bells, strikes, chimes, bījas, answers to the hand.
    case accent
    /// Core Haptics on the same clock (Part D's library plays it).
    case haptic

    /// The Sound sheet's slider name (S06).
    var label: String {
        switch self {
        case .floor: return "Om floor"
        case .world: return "World voice"
        case .her: return "Her / room"
        case .binaural: return "Binaural"
        case .song: return "Songs"
        case .accent: return "Bells and answers"
        case .haptic: return "Haptics"
        }
    }
}

/// One partial of a world bed (`sound.md` §1.5): ratio × the bed’s fundamental, its gain and its
/// wave (Design's oscillator names, `HomeWave`).
struct VoicePartial: Equatable {
    let wave: HomeWave
    let ratio: Double
    let gain: Double
}

/// WORLD_ESSENCE’s own filter LFO (depth Hz · rate Hz; `sound.md` S08), kept as the record;
/// the engine sweeps every bed with the one world breath instead (S08).
struct EssenceLFO: Equatable {
    let depth: Double
    let rate: Double
}

/// How a world's WORLD bus sounds — `sound.md` §1.5's "bed" column.
enum WorldBed: Equatable {
    /// No bed: the Om (or her carrier on the HER bus) is the voice.
    case none
    /// A sum of partials on one fundamental through a lowpass (Q .65).
    case partials(fundamental: Double, partials: [VoicePartial], lowpass: Double?, essence: EssenceLFO?)
    /// A ring's ground in its Design technique (HomeSoundService's voicings, S28).
    case ringGround(RingGroundRule)
    /// Pink noise under the Om (the Well, S58).
    case pinkNoise(gain: Double)
    /// A Score's recording is the bed (Beneath: Kingdom, S65) — played on SONG.
    case score(recording: String)
}

/// Which ring's ground a ring-ground bed sounds.
enum RingGroundRule: Equatable {
    /// Today's Śakti's ring, at 0.16 (S24).
    case todaysShakti
    /// The enclosure the glass is in, quieter deeper: 0.16 − 0.0125·(r − 1) (S25).
    case enclosure
    /// The ring world's own ring, at 0.16 (S28).
    case ring
    /// The nine grounds crossfading with the climb fraction (S40).
    case climb

    /// The ground's level in ring `r`.
    func level(ring r: Int) -> Double {
        let ring = max(1, min(9, r))
        switch self {
        case .enclosure: return HomeCarrier.groundLevel - 0.0125 * Double(ring - 1)
        default: return HomeCarrier.groundLevel
        }
    }
}

/// A world's threshold pitch — `sound.md` §1.5's last column (S09).
enum ThresholdPitch: Equatable {
    case fixed(Double)
    /// Her carrier (Today, Her Home, Her Presence).
    case herCarrier
    /// root(r) × 2 of the ring he stands in (Mandala 110 at arrival, rings, Climb).
    case ringRootTimesTwo
}

/// One world's sound — a row of `sound.md` §1.5.
struct WorldVoice: Equatable {
    let world: WorldID
    let bed: WorldBed
    /// The buses its SoundScene uses (FLOOR always).
    let buses: Set<SoundBus>
    let threshold: ThresholdPitch
    /// The threshold tone's peak (0.032; the Well's 110 at 0.016).
    let thresholdPeak: Double

    /// The threshold pitch resolved for a ring and a carrier.
    func thresholdHz(ring: Int = 1, herCarrier: Double? = nil) -> Double {
        switch threshold {
        case .fixed(let hz): return hz
        case .herCarrier: return herCarrier ?? Tuning.Om.root
        case .ringRootTimesTwo: return Tuning.root(ring: ring) * 2
        }
    }
}

/// The fifteen world voices and the engine’s crossing law — `sound.md` §1.5, S09, S22.
enum WorldVoices {

    // MARK: The engine law (DH:4208–4376, S22)

    static let lowpassQ: Double = 0.65
    /// The one world breath: 12.5 s, 0.08 Hz (S08).
    static let breathHz: Double = 0.08
    /// Its depth on each bed's cutoff: cutoff × 0.25.
    static let breathDepth: Double = 0.25
    /// ±2 cents of random detune per partial.
    static let detuneCents: Double = 2
    /// Equal-power crossfade between beds.
    static let crossfade: Double = 2.6
    /// The outgoing bed is stopped here.
    static let outgoingStop: Double = 2.9
    /// Master to bed.
    static let bedLevel: Double = 0.028
    /// …over this.
    static let bedRise: Double = 2.4
    /// A ring-ground bed stands where HomeSoundService stands it: groundLevel
    /// (0.16, or the enclosure's) × its wake level 0.5, through the room's
    /// closed lowpass (220 Hz) — the character kept (BC-09).
    static let ringGroundMaster: Double = HomeCarrier.wakeLevel
    static var ringGroundLowpass: Double { HomeCarrier.filterCutoff(adaptation: 0) }

    /// The equal-power crossfade at `t` seconds into a crossing of `duration`:
    /// outgoing cos, incoming sin of (π/2 · t/duration). out² + incoming² = 1.
    static func equalPower(t: Double, duration: Double = crossfade) -> (out: Double, incoming: Double) {
        let p = max(0, min(1, duration > 0 ? t / duration : 1))
        return (cos(p * .pi / 2), sin(p * .pi / 2))
    }

    // MARK: The threshold tone (S09)

    enum Threshold {
        static let duration: Double = 1.8
        /// sine f + f × 2.002 at 0.22.
        static let partialRatio: Double = 2.002
        static let partialGain: Double = 0.22
        static let peak: Double = 0.032
        /// The envelope peaks at 0.42 of its duration.
        static let peakAt: Double = 0.42
        /// A world-point hums its threshold at 0.010 as the finger passes (menu).
        static let menuHum: Double = 0.010
    }

    /// The threshold envelope at `t` (s): a rise to `peak` at 0.42 · 1.8 s and
    /// a fall to nothing at 1.8 s, both linear.
    static func thresholdEnvelope(t: Double, peak: Double = Threshold.peak) -> Double {
        let d = Threshold.duration
        let top = Threshold.peakAt * d
        guard t > 0, t < d else { return 0 }
        return t <= top ? peak * t / top : peak * (d - t) / (d - top)
    }

    // MARK: The fifteen (sound.md §1.5)

    private static func p(_ w: HomeWave, _ r: Double, _ g: Double) -> VoicePartial {
        VoicePartial(wave: w, ratio: r, gain: g)
    }

    static let all: [WorldVoice] = WorldID.allCases.map { WorldVoices.voice(for: $0) }

    static func voice(for world: WorldID) -> WorldVoice {
        switch world {
        case .home:
            // The Om is its voice; binaural only at the deepest zoom (S23, S60).
            return WorldVoice(world: world, bed: .none, buses: [.floor, .binaural],
                              threshold: .fixed(Tuning.Om.root), thresholdPeak: Threshold.peak)
        case .today:
            return WorldVoice(world: world, bed: .ringGround(.todaysShakti),
                              buses: [.floor, .world, .her, .accent, .binaural],
                              threshold: .herCarrier, thresholdPeak: Threshold.peak)
        case .mandala:
            return WorldVoice(world: world, bed: .ringGround(.enclosure),
                              buses: [.floor, .world, .accent],
                              threshold: .ringRootTimesTwo, thresholdPeak: Threshold.peak)
        case .rings:
            return WorldVoice(world: world, bed: .ringGround(.ring),
                              buses: [.floor, .world, .accent, .haptic],
                              threshold: .ringRootTimesTwo, thresholdPeak: Threshold.peak)
        case .herHome:
            return WorldVoice(world: world, bed: .none,
                              buses: [.floor, .her, .accent, .binaural],
                              threshold: .herCarrier, thresholdPeak: Threshold.peak)
        case .herPresence:
            return WorldVoice(world: world, bed: .none, buses: [.floor, .her, .accent],
                              threshold: .herCarrier, thresholdPeak: Threshold.peak)
        case .climb:
            return WorldVoice(world: world, bed: .ringGround(.climb),
                              buses: [.floor, .world, .her, .binaural, .accent],
                              threshold: .ringRootTimesTwo, thresholdPeak: Threshold.peak)
        case .the33:
            // WORLD_ESSENCE road — "Stately bell — the spine holds everything";
            // 146.8 = R4 × 2.
            return WorldVoice(world: world,
                              bed: .partials(fundamental: 146.8,
                                             partials: [p(.sine, 1, 0.36), p(.sine, 2, 0.18),
                                                        p(.sine, 3, 0.10), p(.sine, 5, 0.05)],
                                             lowpass: 920, essence: EssenceLFO(depth: 200, rate: 0.08)),
                              buses: [.floor, .world, .her, .binaural, .song, .haptic],
                              threshold: .fixed(146.8), thresholdPeak: Threshold.peak)
        case .game:
            // WORLD_ESSENCE holi; 196 = R7 × 2. The register gives no gains for
            // holi — an equal share stands until DH:3621–3676 is read (U1-B report).
            return WorldVoice(world: world,
                              bed: .partials(fundamental: 196,
                                             partials: [p(.sine, 1, 0.33), p(.triangle, 1.25, 0.33),
                                                        p(.sine, 1.5, 0.33)],
                                             lowpass: 900, essence: EssenceLFO(depth: 260, rate: 0.12)),
                              buses: [.floor, .world, .accent],
                              threshold: .fixed(196), thresholdPeak: Threshold.peak)
        case .modes:
            // WORLD_ESSENCE book, on 138.6 (R3 × 2).
            return WorldVoice(world: world,
                              bed: .partials(fundamental: 138.6,
                                             partials: [p(.triangle, 1, 0.42), p(.sine, 0.5, 0.22)],
                                             lowpass: 440, essence: EssenceLFO(depth: 140, rate: 0.05)),
                              buses: [.floor, .world, .her, .binaural, .accent],
                              threshold: .fixed(138.6), thresholdPeak: Threshold.peak)
        case .time:
            return WorldVoice(world: world, bed: timeDay,
                              buses: [.floor, .world, .accent],
                              threshold: .fixed(194.18), thresholdPeak: Threshold.peak)
        case .memory:
            // WORLD_ESSENCE sid: 98.0 = R7.
            return WorldVoice(world: world,
                              bed: .partials(fundamental: 98.0, partials: [p(.sine, 1, 0.55)],
                                             lowpass: 360, essence: EssenceLFO(depth: 90, rate: 0.04)),
                              buses: [.floor, .world, .accent],
                              threshold: .fixed(196), thresholdPeak: Threshold.peak)
        case .well:
            return WorldVoice(world: world, bed: .pinkNoise(gain: MixLaw.pinkNoiseGain),
                              buses: [.floor, .world, .binaural],
                              threshold: .fixed(110), thresholdPeak: 0.016)
        case .beneath:
            return WorldVoice(world: world, bed: .score(recording: Recordings.kingdom),
                              buses: [.floor, .song, .accent, .binaural],
                              threshold: .fixed(123.47), thresholdPeak: Threshold.peak)
        case .relationship:
            // WORLD_ESSENCE field, moved to the Om's octave: 272.2 × 0.005 =
            // a 1.36 Hz beat.
            return WorldVoice(world: world,
                              bed: .partials(fundamental: 272.2,
                                             partials: [p(.sine, 1, 0.28), p(.sine, 1.005, 0.28),
                                                        p(.sine, 1.5, 0.15), p(.sine, 2, 0.09)],
                                             lowpass: 1100, essence: EssenceLFO(depth: 240, rate: 0.06)),
                              buses: [.floor, .world, .accent, .song],
                              threshold: .fixed(272.2), thresholdPeak: Threshold.peak)
        }
    }

    // MARK: Time's three beds (S20)

    /// The day: 194.18 sine (Earth-day). sound.md gives no gain or filter; the
    /// one-sine bed of the table (sid) stands at .55, so this does too.
    static let timeDay: WorldBed = .partials(fundamental: 194.18,
                                             partials: [VoicePartial(wave: .sine, ratio: 1, gain: 0.55)],
                                             lowpass: nil, essence: nil)
    /// The year view: the Om's own pitch.
    static let timeYear: WorldBed = .partials(fundamental: 136.1,
                                              partials: [VoicePartial(wave: .sine, ratio: 1, gain: 0.55)],
                                              lowpass: nil, essence: nil)
    /// The night: 60 Hz (its 1.5 Hz beat rides the BINAURAL bus).
    static let timeNight: WorldBed = .partials(fundamental: 60,
                                               partials: [VoicePartial(wave: .sine, ratio: 1, gain: 0.55)],
                                               lowpass: nil, essence: nil)
    static let timeNightBeat: Double = 1.5
}
