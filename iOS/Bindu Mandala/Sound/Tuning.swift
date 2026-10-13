import Foundation

// MARK: - Upgrade U1 · B · the one tuning
//
// `waves/upgrade/worlds/sound.md` §1.4 (S10). Every pitch the instrument sounds
// is either derived from Design's ring roots and the just intervals by a stated
// rule, or is a named exception carrying its source. Nothing else.
//
// **Retired** (sound.md §1.4 and S15) — each keeps its mechanism; only its
// pitches move, to what stands on the right:
//
//   • the hash pentatonic (`lrPlayBija`, BijaSoundService FNV, 130.81…293.66)
//       → her carrier (`carrier(ring:syllable:)`, S13)
//   • RITE_BIJA_HZ (Aim 136.1, Klīm 144, Sauḥ 126.2, Hrīm 152.7, Hsraim 160.4,
//     Hsklhrīm 118.6, Hsauḥ 172.1)
//       → today's Śakti's ring ground and carrier (S24)
//   • VAK_FREQS 220 … 659.25 (`RingAudioService.vakFrequencies`)
//       → `vakLadder`, 196 × the hexatonic ratios, the fifth withheld (S35)
//   • the Ring 8 minor triad 261.63 / 311.13 / 392 (→ 130.81)
//       → `triad`, 220 × [1, 1.26, 1.5] uniting at 110 (S37)
//   • LR_RING_FREQ 392 → 196 (Design's eight ring chimes)
//       → `bells`, bell(r) = root(10 − r) × 4, nine of them (S26)
//   • ringChime / RingBija at 528 × 0.917^(r−1)
//       → `bells` and `fallingMantra(ring:vowel:)` (S26, S27)
//   • RingAudioService's second root set (73.42 + 110, 130.81, 116.5, 207.65,
//     steps 146.84 / 164.82)
//       → `ringRoots` (the grounds are HomeSoundService's voicings, S28)
//   • solfeggio 396 – 963 (Climb ladder, Tone Ceremony, Hub, Sanctuary Gates,
//     Colour Rivers, Echo, Mantra Tuner)
//       → ring roots or the rooms' fixed tones (S40, S48, S72)
//   • the VX2 map tones (Muladhara 256, Svadhisthana 288; Crow + Soles 480 → 256)
//       → the rooms' fixed tones (`RoomTones`, S48)
//   • the Pythagorean chime ladder on 256
//       → `bells` (S26)
//   • pseudo-binaural (one sine panned by the gyroscope)
//       → true L/R binaural on the mixer's BINAURAL bus (S57)

/// The one tuning every engine reads — `sound.md` §1.4 (S10): Design's ring
/// roots and the just intervals, the rules derived from them, and the named
/// exceptions.
///
/// The roots are Design's own `ROOTS` (`Design/Corpus/homes-sound.js`); the
/// absolute pitch is a design choice, *"what is canonical is the ORDER"*.
/// `HomeCarrier.roots` holds the same nine numbers today and the tests hold the
/// two together; U2 points `HomeCarrier` here.
enum Tuning {

    // MARK: The spine

    /// R1 … R9, feet to totality (Hz).
    static let ringRoots: [Double] = [55.00, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47]

    /// The just intervals within the octave, indexed by place in the series.
    static let just: [Double] = [
        1, 16.0 / 15.0, 9.0 / 8.0, 6.0 / 5.0, 5.0 / 4.0, 4.0 / 3.0,
        45.0 / 32.0, 3.0 / 2.0, 8.0 / 5.0, 5.0 / 3.0, 16.0 / 9.0, 15.0 / 8.0,
    ]

    /// The ring's root; rings outside 1…9 clamp, as Design's index clamp does.
    static func root(ring: Int) -> Double {
        ringRoots[max(0, min(ringRoots.count - 1, ring - 1))]
    }

    // MARK: Derived by stated rule

    /// The ring's ground (S28): its root, voiced by the ring's own technique.
    static func ground(ring: Int) -> Double { root(ring: ring) }

    /// Her carrier (S11, Design's law verbatim): root(ring) × JUST[varṇa(stem) mod 12] × 2;
    /// no syllable → the bare root. The stem and the varṇamālā are
    /// `HomeCarrier`'s, which ported them from `homes-sound.js`.
    static func carrier(ring: Int, syllable: String?) -> Double {
        HomeCarrier.carrierFor(root: root(ring: ring), syllable: syllable)
    }

    /// The fifth above her carrier — the interval that is withheld (S12).
    static let fifthRatio: Double = 1.5
    /// Its gain once fully granted.
    static let withheldFifthGain: Double = 0.05

    /// How much of the fifth is granted (S12): ring 9 → 1, else
    /// max(clamp((chamberT − 227) / 120), clamp((dwell − 180) / 300)).
    static func grantsFifth(ring: Int, chamberSeconds: Double, dwellSeconds: Double) -> Double {
        if ring == 9 { return 1 }
        func clamp(_ x: Double) -> Double { max(0, min(1, x)) }
        return max(clamp((chamberSeconds - 227) / 120), clamp((dwellSeconds - 180) / 300))
    }

    /// The rite's struck tones (S12): [1, 2, 4] × carrier while the fifth is
    /// not yet granted (grantsFifth < 0.5), Design's [1, 1.5, 2] once it is and
    /// always in ring 9 — beat 2 no longer gives the fifth away on entry.
    static func strikeRatios(grantsFifth g: Double, ring: Int) -> [Double] {
        (ring == 9 || g >= 0.5) ? [1, 1.5, 2] : [1, 2, 4]
    }

    /// One struck tone as beat `beat` (1…3, clamped) of the rite lands.
    static func strike(ring: Int, beat: Int, syllable: String?, grantsFifth g: Double) -> Double {
        let ratios = strikeRatios(grantsFifth: g, ring: ring)
        return carrier(ring: ring, syllable: syllable) * ratios[max(0, min(ratios.count - 1, beat - 1))]
    }

    /// The enclosure bell (S26): bell(r) = root(10 − r) × 4 — the Climb's roots
    /// in reverse, two octaves up, falling inward.
    static func bell(ring r: Int) -> Double {
        let ring = max(1, min(9, r))
        return root(ring: 10 - ring) * 4
    }

    /// The nine bells, ring 1 … ring 9: 493.88 · 440 · 392 · 370 · 329.64 ·
    /// 293.68 · 277.2 · 246.96 · 220.
    static var bells: [Double] { (1...9).map { bell(ring: $0) } }

    /// Design's bell, kept verbatim (`lrRingChime`, `living-rite-core.jsx`):
    /// 1.7 s, master .0001 → .085 in 12 ms, lowpass 2400 → 700 over 80 %.
    enum BellVoice {
        static let duration: Double = 1.7
        static let designPeak: Double = 0.085
        static let attack: Double = 0.012
        static let lowpassFrom: Double = 2400
        static let lowpassTo: Double = 700
        static let lowpassFraction: Double = 0.8
        /// (ratio × bell, gain, duration as a fraction of 1.7 s).
        static let partials: [(ratio: Double, gain: Double, durationFraction: Double)] = [
            (1, 1, 1), (2, 0.30, 0.7), (2.76, 0.16, 0.5), (0.5, 0.22, 0.9),
        ]
    }

    /// The four vowels a ring's bīja falls on (S27) and their intervals.
    enum MantraVowel: String, CaseIterable {
        case a, i, ai, au
        var interval: Double {
            switch self {
            case .a: return 1
            case .i: return 3.0 / 2.0
            case .ai: return 5.0 / 4.0
            case .au: return 5.0 / 3.0
            }
        }
    }

    /// The falling mantra (S27): bell(r) × the vowel's interval.
    static func fallingMantra(ring: Int, vowel: MantraVowel) -> Double {
        bell(ring: ring) * vowel.interval
    }

    /// Its duration: 1.2 × bell(1) / bell(r) s — ring 1 1.2 s … ring 9 2.69 s.
    static func fallingMantraDuration(ring: Int) -> Double {
        1.2 * bell(ring: 1) / bell(ring: ring)
    }

    /// It follows its bell by 180 ms at 0.6 × the bell's gain.
    static let fallingMantraDelay: Double = 0.18
    static let fallingMantraGain: Double = 0.6

    /// The Vāk ladder's base (S35): ring 7's root, one octave up.
    static var vakBase: Double { root(ring: 7) * 2 }
    /// The hexatonic ratios — the fifth (3/2) withheld.
    static let vakRatios: [Double] = [1, 9.0 / 8.0, 5.0 / 4.0, 4.0 / 3.0, 5.0 / 3.0, 15.0 / 8.0,
                                      2, 9.0 / 4.0, 5.0 / 2.0, 8.0 / 3.0, 10.0 / 3.0, 15.0 / 4.0]
    /// The twelve voices of kp 87–98 in kp order.
    static var vakLadder: [Double] { vakRatios.map { vakBase * $0 } }

    /// Ring 8's triad (S37): ring 8's root one octave up × [1, 1.26, 1.5].
    static var triadBase: Double { root(ring: 8) * 2 }
    static let triadRatios: [Double] = [1, 1.26, 1.5]
    /// Icchā 220 · Jñāna 277.2 · Kriyā 330.
    static var triad: [Double] { triadRatios.map { triadBase * $0 } }
    /// Where the three unite: ring 8's root.
    static var triadUnison: Double { root(ring: 8) }

    /// The Shepard fall (S38): fMin = root(9) / 4, seven octave-stacked voices.
    static var shepardFMin: Double { root(ring: 9) / 4 }
    static let shepardVoices: Int = 7

    /// The Climb's narrowing beat (S40), rings 1 … 9; 4 Hz at the summit.
    static let climbBeats: [Double] = [8, 7.5, 7, 6.5, 6, 5.5, 5, 4.5, 4.2]
    static let summitBeat: Double = 4
    static func climbBeat(ring: Int) -> Double { climbBeats[max(0, min(8, ring - 1))] }
    /// The Climb's binaural carrier: the current root × 2.
    static func climbCarrier(ring: Int) -> Double { root(ring: ring) * 2 }

    /// A wake-up panel's binaural carrier (S50): the room's fixed tone ÷ 2.
    static func wakeUpCarrier(roomTone hz: Double) -> Double { hz / 2 }

    // MARK: Named exceptions — each sourced, each keeps its character (BC-09)

    /// The Om stack (S16, `TreeOfLife.omHz`): 68.05 · 136.1 · 272.2, and 408.3
    /// in the summit chord (S40).
    enum Om {
        static let sub: Double = 68.05
        static let root: Double = 136.1
        static let octave: Double = 272.2
        static let summitFifth: Double = 408.3
        /// (Hz, gain): the root whole, its octave at 30 %, its sub at 15 %.
        static let partials: [(hz: Double, gain: Double)] = [(68.05, 0.15), (136.1, 1.0), (272.2, 0.30)]
        /// The summit chord, over 9 s.
        static let summitChord: [Double] = [136.1, 272.2, 408.3]
    }

    /// A named, sourced pitch that is not derived from the roots.
    struct NamedTone: Equatable {
        let name: String
        let hz: Double
        /// Where it comes from (sound.md element, register line).
        let source: String
    }

    /// The day bells (S24, `Today/TheBells.swift`).
    static let dayBellOpen: Double = 272.2
    static let dayBellClose: Double = 136.1

    /// The planetary breath carriers (S20, Cousto; Bindu Field Frequency rows 101–111).
    static let planetary: [NamedTone] = [
        NamedTone(name: "Earth-year (the Om)", hz: 136.1, source: "S20"),
        NamedTone(name: "Earth-day", hz: 194.18, source: "S20"),
        NamedTone(name: "Venus", hz: 221.23, source: "S20"),
        NamedTone(name: "the mathematician's C", hz: 256, source: "S20"),
        NamedTone(name: "chest", hz: 80, source: "S20"),
        NamedTone(name: "deepest (night)", hz: 60, source: "S20"),
    ]

    /// The Heart Register's Sa, his choice of C … F (S70, `HeartRegister.swift`);
    /// default C♯ 138.59 = ring 3's root × 2.
    static let heartRegisterSa: [Double] = [130.81, 138.59, 146.83, 155.56, 164.81, 174.61]
    static let heartRegisterDefaultSa: Double = 138.59

    /// A Strange Game's palette, kept verbatim (S72, `PlayInstruments.swift`).
    static let gamePalette: [Double] = [196, 330, 660, 495, 990, 247, 123, 174, 261,
                                        880, 523, 392, 740, 95, 42, 68, 52, 272.2]

    /// The Mirror's blips (S74): arrival 174 · tunnel/look 220 · glass/inversion
    /// 196 · carve 233 · carved 246.9 · exit 261.6 then 329.6.
    static let mirrorBlips: [Double] = [174, 220, 196, 233, 246.9, 261.6, 329.6]

    /// The Well's Mirror held tone (S74): 110 Hz carrier, 3.5 Hz beat.
    static let mirrorHeldCarrier: Double = 110
    static let mirrorHeldBeat: Double = 3.5

    /// Two lights meeting (S18): 132 and 140 Hz gliding to the Om over 6 s.
    static let convergence: (low: Double, high: Double, seconds: Double) = (132, 140, 6)

    /// The beat offered alone (S19): 136.1 left / 136.6 right.
    static let beatAlone: (left: Double, right: Double) = (136.1, 136.6)

    /// Spanda, Ring 9's second visit (S38).
    static let spanda: [Double] = [146.83, 220, 73.42]

    /// The Rite's sealing bowl and the ink tone (S24).
    static let sealingBowl: Double = 220
    static let inkTone: Double = 174

    /// The Shadow room's deepest binaural (S48): 2.5 Hz δ on 136.1.
    static let shadowBeat: Double = 2.5

    /// Beats placed only where designed, each badged (S60, S61).
    static let binduBeat: Double = 2.69
    static let schumann: Double = 7.83

    /// Each song's Score carrier, **only during its dance** (S56, S65–S68).
    /// Keyed by recording path (`Recordings`).
    static let songCarriers: [String: Double] = [
        "tree-of-life/muladhara.mp3": 146.8,
        "tree-of-life/svadhisthana.mp3": 146.8,
        "tree-of-life/manipura.mp3": 164.8,
        "tree-of-life/anahata.mp3": 155.6,
        "tree-of-life/vishuddha.mp3": 138.6,
        "tree-of-life/ajna.mp3": 138.6,
        "tree-of-life/sahasrara.mp3": 146.8,
        "bindu/in_shadow.mp3": 146.8,
        "tree-of-life/maya.mp3": 155.6,
        "tree-of-life/aatma.mp3": 130.8,
        "bindu/cross.mp3": 110,
        "bindu/kingdom.mp3": 146.8,
        "bindu/before.mp3": 110,
        "bindu/purity.mp3": 123.5,
        "bindu/levelup.mp3": 123.5,
    ]

    /// Every named exception that is a pitch, flat.
    static var namedExceptions: [Double] {
        var out: [Double] = Om.partials.map { $0.hz }
        out += [Om.summitFifth, dayBellOpen, dayBellClose]
        out += planetary.map { $0.hz }
        out += heartRegisterSa
        out += gamePalette
        out += mirrorBlips
        out += [mirrorHeldCarrier, convergence.low, convergence.high, beatAlone.left, beatAlone.right]
        out += spanda
        out += [sealingBowl, inkTone]
        out += Array(songCarriers.values)
        out += RoomTones.all.compactMap { $0.hz }
        return out
    }

    /// Every pitch derived by a stated rule, flat: roots and their octaves,
    /// every carrier (root × just × 2) and its strikes and fifth, the bells,
    /// the falling mantras, the Vāk ladder, the triad, the Shepard floor, the
    /// Climb's carriers and the wake-up carriers.
    static var derived: [Double] {
        var out: [Double] = []
        for r in ringRoots { out += [r / 2, r, r * 2, r * 4] }
        for r in ringRoots {
            for j in just {
                let c = r * j * 2
                out += [c, c * fifthRatio, c * 2, c * 4, c * 0.75]
            }
        }
        out += bells
        for ring in 1...9 { for v in MantraVowel.allCases { out.append(fallingMantra(ring: ring, vowel: v)) } }
        out += vakLadder + triad + [triadUnison, shepardFMin]
        out += (1...9).map { climbCarrier(ring: $0) }
        out += RoomTones.all.compactMap { $0.hz }.map { wakeUpCarrier(roomTone: $0) }
        return out
    }

    /// Whether `hz` is in the one tuning: derived, or a named exception —
    /// within `tolerance` Hz (the parity check measures to ~0.2 Hz; the tables
    /// write one or two decimals).
    static func isAllowed(_ hz: Double, tolerance: Double = 0.05) -> Bool {
        (derived + namedExceptions).contains { abs($0 - hz) <= tolerance }
    }

    /// The retired sets (S15) as data: what each was, and what replaces it.
    /// `retiredOnly` are the pitches of these sets that no rule or exception
    /// re-admits — the tests hold that none of them is allowed.
    struct RetiredSet {
        let name: String
        let pitches: [Double]
        let replacement: String
    }

    static let retired: [RetiredSet] = [
        RetiredSet(name: "RITE_BIJA_HZ", pitches: [144, 126.2, 152.7, 160.4, 118.6, 172.1],
                   replacement: "her ring ground + carrier (S24)"),
        RetiredSet(name: "VAK_FREQS", pitches: [246.94, 261.63, 293.66, 329.63, 349.23, 392.00,
                                                440.00, 493.88, 523.25, 587.33, 659.25],
                   replacement: "vakLadder (S35)"),
        RetiredSet(name: "R8 minor triad", pitches: [261.63, 311.13, 392, 130.81],
                   replacement: "triad → 110 (S37)"),
        RetiredSet(name: "LR_RING_FREQ", pitches: [392.0, 349.2, 329.6, 293.7, 261.6, 246.9, 220.0, 196.0],
                   replacement: "bells (S26)"),
        RetiredSet(name: "ringChime / RingBija 528 × 0.917^(r−1)",
                   pitches: (2...8).map { 528 * pow(0.917, Double($0 - 1)) },
                   replacement: "bells + fallingMantra (S26, S27)"),
        RetiredSet(name: "solfeggio", pitches: [396, 417, 639, 741, 852, 963],
                   replacement: "ring roots / room tones (S40, S48, S72)"),
        RetiredSet(name: "VX2 map tones", pitches: [288],
                   replacement: "room fixed tones (S48)"),
    ]

    /// Pitches of the retired sets that nothing re-admits. (587.33, 659.25,
    /// 396 and 528 × 0.917² fall within 0.05 Hz of a derived strike or carrier,
    /// so they are not listed: the set is retired, those numbers are not.)
    static let retiredOnly: [Double] = [144, 126.2, 152.7, 160.4, 118.6, 172.1,
                                        311.13, 349.23,
                                        417, 639, 741, 852, 963, 288]
        + [2, 4, 5, 6, 7, 8].map { 528 * pow(0.917, Double($0 - 1)) }
}
