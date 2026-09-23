import AVFoundation
import Foundation

// MARK: - The techniques

/// One voicing per āvaraṇa. The names are Design's own (`homes-sound.js`
/// `TECHNIQUE`), and the handoff's §5 table is the ruling: 1 ground drone ·
/// 2 home breath · 3 & 6 sustained breathy voice · 4 & 5 stepped notes (4
/// slower than 5) · 7 the witness, sourceless · 8 triad collapse · 9 Shepard
/// tone. Each ring's ground is voiced its own way rather than nine copies of
/// one drone.
enum HomeTechnique: String {
    case drone
    case breath
    case breathy
    case stepped
    case sourceless
    case triad
    case shepard
}

/// The oscillator shapes the voice is built from, under Web Audio's names —
/// Design's `osc('sine' | 'triangle' | 'sawtooth', …)`.
enum HomeWave {
    case sine, triangle, saw
}

// MARK: - The voice as pure data

/// One partial of a ground: everything Design's `osc(...)` call carries, with
/// the frequency held as a multiple of the ring's root so the table reads the
/// way Design wrote it.
struct HomePartialSpec: Equatable {
    var wave: HomeWave
    var multiple: Double
    var gain: Double
    /// Routed through the ground's own bandpass rather than straight out.
    var throughBand: Bool = false
    var lfoRate: Double = 0
    var lfoDepth: Double = 0
    /// Web Audio's `setTargetAtTime` time constant for a frequency change.
    /// Zero is `setValueAtTime` — a step, not a glide.
    var glideTau: Double = 0
}

/// A ground's own bandpass, its frequency a multiple of the ring's root.
struct HomeBandSpec: Equatable {
    var multiple: Double
    var q: Double
}

/// One āvaraṇa's whole ground.
struct HomeGroundSpec: Equatable {
    var partials: [HomePartialSpec]
    var band: HomeBandSpec?
    /// The home ring breathes: an LFO on the ground's own amplitude.
    var amRate: Double = 0
    var amDepth: Double = 0
}

// MARK: - The carrier — pure, and the whole contract

/// The arithmetic of the Homes' voice, with no engine anywhere near it.
///
/// Her bīja is the carrier; her āvaraṇa's drone is the ground. The varṇamālā is
/// an ordered series and that order is the canon: each bīja the cards name is
/// located in it, and its position becomes a just interval above her āvaraṇa's
/// root, folded into one octave above. The pitch and the register are ours; the
/// interval is hers. Where the cards name no syllable the carrier is simply the
/// root — silence about what we do not know, rather than a plausible number.
///
/// **Roots.** Design's per-ring `ROOTS` are the reference here, not
/// `RingAudioService`'s constants. Build Brief v2 §2.3 says to take the roots
/// from that service, but it has no root at all for rings 4, 5 and 7 (they are
/// discrete-note and sourceless techniques there), so it cannot serve; Design's
/// set is complete and deliberate. Recorded in `BUILD-BRIEF-V2-ERRATA.md`,
/// ruling of 2026-09-07. The absolute pitch is a design choice and nothing
/// more; what is canonical is the ORDER — feet to totality.
enum HomeCarrier {

    /// One root per āvaraṇa, ascending the body.
    static let roots: [Double] = [55.0, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47]

    /// The varṇamālā, in order. The order is the canon; the index is the interval.
    static let varna: [String] = [
        "a", "ā", "i", "ī", "u", "ū", "ṛ", "ṝ", "ḷ", "ḹ", "e", "ai", "o", "au", "aṃ", "aḥ",
        "ka", "kha", "ga", "gha", "ṅa", "ca", "cha", "ja", "jha", "ña",
        "ṭa", "ṭha", "ḍa", "ḍha", "ṇa", "ta", "tha", "da", "dha", "na",
        "pa", "pha", "ba", "bha", "ma", "ya", "ra", "la", "va", "śa", "ṣa", "sa", "ha",
    ]

    /// Just intervals within the octave, indexed by position in the series.
    static let just: [Double] = [
        1, 16.0 / 15.0, 9.0 / 8.0, 6.0 / 5.0, 5.0 / 4.0, 4.0 / 3.0,
        45.0 / 32.0, 3.0 / 2.0, 8.0 / 5.0, 5.0 / 3.0, 16.0 / 9.0, 15.0 / 8.0,
    ]

    /// Her āvaraṇa's root. Rings outside 1…9 clamp, as Design's own index clamp does.
    static func root(forRing ring: Int) -> Double {
        roots[max(0, min(roots.count - 1, ring - 1))]
    }

    /// The ground's voicing for a ring.
    static func technique(forRing ring: Int) -> HomeTechnique {
        switch max(1, min(9, ring)) {
        case 1: return .drone
        case 2: return .breath
        case 3: return .breathy
        case 4, 5: return .stepped
        case 6: return .breathy
        case 7: return .sourceless
        case 8: return .triad
        default: return .shepard
        }
    }

    /// The syllable reduced to its place in the series: a trailing anusvāra
    /// (ṃ / ṁ) or visarga (ḥ) is dropped, and a syllable that was nothing but
    /// one of those is the bare vowel. `nil` for an absent syllable — the
    /// caller then keeps the bare root.
    ///
    /// Surrounding whitespace is trimmed and the string is precomposed before
    /// the strip, so a decomposed "aṃ" off the wire reduces the same way a
    /// precomposed one does. Design's JS assumes both.
    static func stem(_ syllable: String?) -> String? {
        guard let syllable else { return nil }
        var x = syllable
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .precomposedStringWithCanonicalMapping
            .lowercased()
        guard !x.isEmpty else { return nil }
        if let last = x.last, last == "\u{1E43}" || last == "\u{1E41}" { x.removeLast() }
        if x.last == "\u{1E25}" { x.removeLast() }
        if x.isEmpty { x = "a" }
        return x
    }

    /// Her carrier: her root times the just interval her syllable stands at,
    /// folded one octave up so a drone sits low enough to be felt rather than
    /// heard. A compound bīja (Aiṃ, Klīṃ, Sauḥ, Hrīṃ) that is not itself in the
    /// series takes its first letter's place. A missing syllable yields the
    /// bare root.
    static func carrierFor(root: Double, syllable: String?) -> Double {
        guard let x = stem(syllable) else { return root }
        var index = varna.firstIndex(of: x) ?? -1
        if index < 0 {
            let first = x.first
            index = varna.firstIndex(where: { $0.first == first }) ?? 0
        }
        return root * just[index % just.count] * 2
    }

    /// The same, from her ring rather than a raw root.
    static func carrierFor(ring: Int, syllable: String?) -> Double {
        carrierFor(root: root(forRing: ring), syllable: syllable)
    }

    /// One struck tone as a beat of the rite lands: her carrier at the unison,
    /// the fifth, or the octave. Design indexes `[1, 1.5, 2][beat - 1]`
    /// unguarded; a beat outside 1…3 clamps here rather than becoming a NaN.
    static func strikeFrequency(ring: Int, beat: Int, syllable: String?) -> Double {
        let ratio = strikeRatios[max(0, min(strikeRatios.count - 1, beat - 1))]
        return carrierFor(ring: ring, syllable: syllable) * ratio
    }

    /// The three beats: the unison, the fifth, the octave.
    static let strikeRatios: [Double] = [1, fifthRatio, 2]

    /// The fifth above her carrier — the interval that is withheld.
    static let fifthRatio: Double = 1.5

    /// Below this the master counts as silence, as Design's `on` getter has it.
    static let soundingFloor: Double = 0.001

    /// Her adaptation opens the room's filter.
    static func filterCutoff(adaptation a: Double) -> Double { 220 + 1500 * a }

    /// The air layer — Design's single bandpassed-noise room, which the brief
    /// names twice ("roomtone", "breath layer"). One layer, not two.
    static func airGain(adaptation a: Double) -> Double { 0.006 + 0.012 * a }
    static func airCutoff(adaptation a: Double) -> Double { 380 + 700 * a }

    /// **The fifth is withheld.** It is silent unless granted: the second
    /// adaptation grants it, and the ninth world grants it outright.
    static func fifthGain(b: Double, ring: Int) -> Double {
        let allow = ring == 9 ? 1.0 : b
        return allow * fifthLevel
    }

    /// The fifth's level once it has been granted.
    static let fifthLevel: Double = 0.05

    /// The ground's level when it is the one you are standing in.
    static let groundLevel: Double = 0.16
    /// The carrier's level at full entry.
    static let carrierLevel: Double = 0.1
    /// Where `wake` brings the master.
    static let wakeLevel: Double = 0.5

    // MARK: The rest of Design's table

    /// Every `setTargetAtTime` time constant in `homes-sound.js`, named by what
    /// it moves. Together they are the room's whole sense of time — a drifted
    /// one is a different instrument — so they are named here rather than left
    /// buried in the engine's initialiser.
    enum Tau {
        /// `wake()` — the master coming up.
        static let master: Double = 1.2
        /// `stop()` — the master going down.
        static let masterOut: Double = 0.5
        /// `setGround` — the climb's crossfade.
        static let ground: Double = 0.9
        /// `setCarrier`.
        static let carrierFreq: Double = 0.6
        static let carrierGain: Double = 0.7
        /// `setRoom` — the lowpass her adaptation opens.
        static let room: Double = 1.4
        static let fifthFreq: Double = 0.8
        static let fifthGain: Double = 2.0
        static let airGain: Double = 1.5
        static let airCutoff: Double = 1.6
    }

    /// Where the carrier, the fifth and the air sit before anyone has entered
    /// anyone — Design's oscillator and filter defaults, untouched until the
    /// first `setCarrier` or `setRoom`.
    static let initialCarrierHz: Double = 136.1
    static let initialFifthHz: Double = 204.15
    static let initialAirHz: Double = 460

    /// The room's lowpass and the air's bandpass.
    static let roomQ: Double = 0.7
    static let airQ: Double = 0.6

    /// Design's noise buffer: four seconds, looped, at half scale.
    static let noiseSeconds: Double = 4
    static let noiseAmplitude: Double = 0.5

    /// Rings 4 and 5 step through these; 4 is the slower of the two.
    static let steps: [Double] = [1, 9.0 / 8.0, 5.0 / 4.0, 3.0 / 2.0]
    static func stepPeriod(forRing ring: Int) -> Double { ring == 4 ? 5.2 : 3.4 }

    /// Ring 8's triad collapses toward its root and reopens.
    static let triadPeriod: Double = 14
    static let triadGlideTau: Double = 3.4

    /// A rising that never arrives: five voices an octave apart, each drifting
    /// at its own rate and detuned by its own few cents.
    static let shepardVoices: Int = 5
    static let shepardGain: Double = 0.22
    static let shepardRate: Double = 0.021
    static let shepardDetuneCents: Double = 3
    static let shepardRateCents: Double = 40

    /// The struck tone's envelope: nothing to `strikePeak` over `strikeAttack`,
    /// then an exponential fall to `strikeFloor` at `strikeFall`, the voice
    /// released at `strikeRelease`.
    static let strikePeak: Double = 0.05
    static let strikeAttack: Double = 0.02
    static let strikeFloor: Double = 0.0001
    static let strikeFall: Double = 3.4
    static let strikeRelease: Double = 3.6

    /// Cents as a frequency ratio — Web Audio's `detune`.
    static func cents(_ c: Double) -> Double { pow(2, c / 1200) }

    /// Each ring's ground, voiced its own way — Design's `build()` branch by
    /// branch, as data.
    ///
    /// The order within `partials` is Design's own and it is load-bearing:
    /// rings 4 and 5 step their **first** partial, and ring 8 collapses its
    /// **second and third** toward the first. The tests hold that order.
    static func ground(forRing ring: Int) -> HomeGroundSpec {
        switch technique(forRing: ring) {
        case .drone:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
                HomePartialSpec(wave: .sine, multiple: 1.0035, gain: 0.8),
                HomePartialSpec(wave: .triangle, multiple: 2, gain: 0.16),
            ], band: nil)
        case .breath:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
                HomePartialSpec(wave: .sine, multiple: 1.5, gain: 0.3),
            ], band: nil, amRate: 0.14, amDepth: 0.55)
        case .breathy:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 1, gain: 0.7),
                HomePartialSpec(wave: .saw, multiple: 1.002, gain: 0.1),
                HomePartialSpec(wave: .saw, multiple: 2.01, gain: 0.05, throughBand: true),
            ], band: HomeBandSpec(multiple: 4, q: 1.6))
        case .stepped:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
                HomePartialSpec(wave: .sine, multiple: 0.5, gain: 0.4),
            ], band: nil)
        case .sourceless:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 2, gain: 0.42),
                HomePartialSpec(wave: .sine, multiple: 3, gain: 0.26),
                HomePartialSpec(wave: .sine, multiple: 5, gain: 0.14),
            ], band: nil)
        case .triad:
            return HomeGroundSpec(partials: [
                HomePartialSpec(wave: .sine, multiple: 1, gain: 0.7),
                HomePartialSpec(wave: .sine, multiple: 1.26, gain: 0.6, glideTau: triadGlideTau),
                HomePartialSpec(wave: .sine, multiple: 1.5, gain: 0.6, glideTau: triadGlideTau),
            ], band: nil)
        case .shepard:
            return HomeGroundSpec(partials: (0..<shepardVoices).map { k in
                HomePartialSpec(
                    wave: .sine,
                    multiple: pow(2, Double(k) - 1) * cents(Double(k) * shepardDetuneCents),
                    gain: shepardGain,
                    lfoRate: shepardRate * cents(Double(k) * shepardRateCents),
                    lfoDepth: shepardGain
                )
            }, band: nil)
        }
    }

    // MARK: Ours, not Design's — the lifecycle its JS never had

    /// How many struck tones may ring at once. Design creates an oscillator per
    /// strike and lets the graph collect it; a render block cannot allocate, so
    /// the voices are a fixed pool and the oldest yields.
    static let strikeVoices: Int = 8
    /// An interruption ducks faster than a `stop()`: the room did not ask.
    static let pauseTau: Double = 0.2
    /// How long a fade is given to land before the nodes go.
    static let pauseDelay: Double = 0.35
    static let teardownDelay: Double = 0.8
}

// MARK: - Render primitives

/// An RBJ-cookbook biquad — the formulas Web Audio's `BiquadFilterNode` uses,
/// so Design's `lowpass` and `bandpass` land on the same coefficients here.
struct HomeBiquad {
    private var b0 = 1.0, b1 = 0.0, b2 = 0.0, a1 = 0.0, a2 = 0.0
    private var x1 = 0.0, x2 = 0.0, y1 = 0.0, y2 = 0.0

    mutating func setLowpass(frequency: Double, q: Double, sampleRate: Double) {
        let (cosw, alpha, a0) = Self.terms(frequency, q, sampleRate)
        b0 = ((1 - cosw) / 2) / a0
        b1 = (1 - cosw) / a0
        b2 = b0
        a1 = (-2 * cosw) / a0
        a2 = (1 - alpha) / a0
    }

    mutating func setBandpass(frequency: Double, q: Double, sampleRate: Double) {
        let (cosw, alpha, a0) = Self.terms(frequency, q, sampleRate)
        b0 = alpha / a0
        b1 = 0
        b2 = -alpha / a0
        a1 = (-2 * cosw) / a0
        a2 = (1 - alpha) / a0
    }

    private static func terms(_ frequency: Double,
                              _ q: Double,
                              _ sampleRate: Double) -> (Double, Double, Double) {
        let f = max(10.0, min(frequency, sampleRate * 0.45))
        let w0 = 2 * Double.pi * f / sampleRate
        let alpha = sin(w0) / (2 * max(0.0001, q))
        return (cos(w0), alpha, 1 + alpha)
    }

    mutating func process(_ x: Double) -> Double {
        let y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
        x2 = x1; x1 = x
        y2 = y1; y1 = y
        return y
    }
}

/// A partial of a ground voice. `freqCoef` of 1 is Web Audio's
/// `setValueAtTime` (a step); anything smaller is `setTargetAtTime` (a glide).
///
/// Everything here is **render-owned**: the render thread reads the struct at
/// the top of each block and writes it back whole at the bottom. Where a
/// partial is *heading* is therefore not here — see `HomeGround.targetFreqs`.
struct HomePartial {
    var wave: HomeWave = .sine
    var freq: Double = 0
    var freqCoef: Double = 1
    var gain: Double = 0
    var phase: Double = 0
    var lfoPhase: Double = 0
    var lfoRate: Double = 0
    var lfoDepth: Double = 0
    /// Routed through the ground's own bandpass rather than straight out.
    var throughBand: Bool = false
}

/// One āvaraṇa's ground — all nine run, all silent but the one you are in.
final class HomeGround {
    var target: Float = 0
    var current: Float = 0
    var partials: [HomePartial] = []
    /// Where each partial is heading, parallel to `partials`.
    ///
    /// **Control-owned:** the main actor writes here and the render thread only
    /// ever reads. It is kept out of `HomePartial` precisely because the render
    /// thread writes that struct back whole on every block: a step set between
    /// its read and its write would be swallowed, and ring 4 or 5 would miss a
    /// note until the next tick some seconds later.
    var targetFreqs: [Double] = []
    var band: HomeBiquad?
    /// The home ring breathes: an LFO on its own amplitude.
    var amPhase: Double = 0
    var amRate: Double = 0
    var amDepth: Double = 0
    /// Stepped notes (rings 4 and 5).
    var stepBase: Double = 0
    var stepIndex: Int = 0
    /// Triad collapse (ring 8).
    var triadBase: Double = 0
    var triadCollapsed = false

    func render(sampleRate sr: Double) -> Double {
        var direct = 0.0
        var banded = 0.0
        for k in partials.indices {
            var p = partials[k]
            let target = k < targetFreqs.count ? targetFreqs[k] : p.freq
            if p.freqCoef >= 1 {
                p.freq = target
            } else {
                p.freq += (target - p.freq) * p.freqCoef
            }
            let increment = p.freq / sr
            p.phase += increment
            if p.phase >= 1 { p.phase -= 1 }
            var gain = p.gain
            if p.lfoDepth != 0 {
                p.lfoPhase += p.lfoRate / sr
                if p.lfoPhase >= 1 { p.lfoPhase -= 1 }
                gain += p.lfoDepth * sin(p.lfoPhase * 2 * .pi)
            }
            let value = HomeGround.wave(p.wave, p.phase, increment) * gain
            if p.throughBand { banded += value } else { direct += value }
            partials[k] = p
        }
        if let filtered = band?.process(banded) { direct += filtered }
        var amplitude = 1.0
        if amDepth != 0 {
            amPhase += amRate / sr
            if amPhase >= 1 { amPhase -= 1 }
            amplitude = 1 + amDepth * sin(amPhase * 2 * .pi)
        }
        return direct * amplitude * Double(current)
    }

    private static func wave(_ shape: HomeWave, _ phase: Double, _ increment: Double) -> Double {
        switch shape {
        case .sine:
            return sin(phase * 2 * .pi)
        case .triangle:
            return 4 * abs(phase - 0.5) - 1
        case .saw:
            // PolyBLEP — Web Audio's `sawtooth` is band-limited; a naive ramp
            // at these fundamentals would alias audibly.
            var value = 2 * phase - 1
            if phase < increment {
                let t = phase / increment
                value -= t + t - t * t - 1
            } else if phase > 1 - increment {
                let t = (phase - 1) / increment
                value -= t * t + t + t + 1
            }
            return value
        }
    }
}

/// One struck tone, decaying.
struct HomeStrike {
    var active = false
    var freq: Double = 0
    var phase: Double = 0
    var elapsed: Double = 0
    var amplitude: Double = 0
    var decay: Double = 1
}

// MARK: - Render state

/// Boxed render-block state, in the idiom `RingAudioService` already uses:
/// parameters are written from the main actor, samples are read on the render
/// thread. Single-producer / single-consumer, so a torn read costs at most a
/// tone glitch and never a crash.
final class HomeRenderState {
    let sampleRate: Double

    // The master, and its fade — `stop` is tau 0.5, `wake` is tau 1.2.
    var masterTarget: Float = 0
    var masterCurrent: Float = 0
    var masterCoef: Float

    // The room's lowpass, which her adaptation opens.
    var lowpassTarget: Double = HomeCarrier.filterCutoff(adaptation: 0)
    var lowpassCurrent: Double = HomeCarrier.filterCutoff(adaptation: 0)
    let lowpassCoef: Double
    var lowpass = HomeBiquad()

    // Nine grounds, all running, all silent but the one you are in.
    var grounds: [HomeGround] = []
    let groundCoef: Double

    // Her carrier — silent until you enter her.
    var carrierFreqTarget: Double = HomeCarrier.initialCarrierHz
    var carrierFreqCurrent: Double = HomeCarrier.initialCarrierHz
    var carrierGainTarget: Double = 0
    var carrierGainCurrent: Double = 0
    var carrierPhase: Double = 0
    let carrierFreqCoef: Double
    let carrierGainCoef: Double

    // The withheld fifth.
    var fifthFreqTarget: Double = HomeCarrier.initialFifthHz
    var fifthFreqCurrent: Double = HomeCarrier.initialFifthHz
    var fifthGainTarget: Double = 0
    var fifthGainCurrent: Double = 0
    var fifthPhase: Double = 0
    let fifthFreqCoef: Double
    let fifthGainCoef: Double

    // Air — the room's own breath, bandpassed noise.
    var airGainTarget: Double = 0
    var airGainCurrent: Double = 0
    var airFreqTarget: Double = HomeCarrier.initialAirHz
    var airFreqCurrent: Double = HomeCarrier.initialAirHz
    let airGainCoef: Double
    let airFreqCoef: Double
    var airBand = HomeBiquad()
    var noise: [Float]
    var noiseIndex: Int = 0

    var strikes: [HomeStrike]
    private var controlCounter: Int = 0

    init(sampleRate: Double) {
        self.sampleRate = sampleRate
        func coef(_ tau: Double) -> Double { 1 - exp(-1.0 / (tau * sampleRate)) }
        self.masterCoef = Float(coef(HomeCarrier.Tau.master))
        self.lowpassCoef = coef(HomeCarrier.Tau.room)
        self.groundCoef = coef(HomeCarrier.Tau.ground)
        self.carrierFreqCoef = coef(HomeCarrier.Tau.carrierFreq)
        self.carrierGainCoef = coef(HomeCarrier.Tau.carrierGain)
        self.fifthFreqCoef = coef(HomeCarrier.Tau.fifthFreq)
        self.fifthGainCoef = coef(HomeCarrier.Tau.fifthGain)
        self.airGainCoef = coef(HomeCarrier.Tau.airGain)
        self.airFreqCoef = coef(HomeCarrier.Tau.airCutoff)
        self.strikes = Array(repeating: HomeStrike(), count: HomeCarrier.strikeVoices)

        // Four seconds of noise, looped — Design's own buffer.
        let count = Int(sampleRate * HomeCarrier.noiseSeconds)
        var buffer = [Float](repeating: 0, count: count)
        var seed: UInt64 = 0x9E3779B97F4A7C15
        for i in 0..<count {
            seed ^= seed << 13
            seed ^= seed >> 7
            seed ^= seed << 17
            let unit = Double(seed >> 11) / Double(UInt64(1) << 53)
            buffer[i] = Float((unit * 2 - 1) * HomeCarrier.noiseAmplitude)
        }
        self.noise = buffer

        lowpass.setLowpass(frequency: lowpassCurrent, q: HomeCarrier.roomQ, sampleRate: sampleRate)
        airBand.setBandpass(frequency: airFreqCurrent, q: HomeCarrier.airQ, sampleRate: sampleRate)
    }

    /// Coefficient for a Web Audio `setTargetAtTime` time constant.
    func coefficient(tau: Double) -> Double { 1 - exp(-1.0 / (tau * sampleRate)) }

    func fire(strike frequency: Double) {
        var slot = strikes.firstIndex(where: { !$0.active })
        if slot == nil {
            // No free voice — take the oldest.
            slot = strikes.indices.max(by: { strikes[$0].elapsed < strikes[$1].elapsed })
        }
        guard let index = slot else { return }
        // Nothing to the peak over the attack, then an exponential fall to the
        // floor — Design's linear ramp and `exponentialRampToValueAtTime`.
        let ratio = HomeCarrier.strikeFloor / HomeCarrier.strikePeak
        let fall = HomeCarrier.strikeFall - HomeCarrier.strikeAttack
        strikes[index] = HomeStrike(
            active: true,
            freq: frequency,
            phase: 0,
            elapsed: 0,
            amplitude: 0,
            decay: pow(ratio, 1.0 / (fall * sampleRate))
        )
    }

    func render(into samples: UnsafeMutableBufferPointer<Float>, frameCount: Int) {
        let sr = sampleRate
        let dt = 1.0 / sr
        for i in 0..<frameCount {
            if controlCounter == 0 {
                lowpass.setLowpass(frequency: lowpassCurrent, q: HomeCarrier.roomQ, sampleRate: sr)
                airBand.setBandpass(frequency: airFreqCurrent, q: HomeCarrier.airQ, sampleRate: sr)
            }
            controlCounter = (controlCounter + 1) & 31

            masterCurrent += (masterTarget - masterCurrent) * masterCoef
            lowpassCurrent += (lowpassTarget - lowpassCurrent) * lowpassCoef
            airGainCurrent += (airGainTarget - airGainCurrent) * airGainCoef
            airFreqCurrent += (airFreqTarget - airFreqCurrent) * airFreqCoef
            carrierFreqCurrent += (carrierFreqTarget - carrierFreqCurrent) * carrierFreqCoef
            carrierGainCurrent += (carrierGainTarget - carrierGainCurrent) * carrierGainCoef
            fifthFreqCurrent += (fifthFreqTarget - fifthFreqCurrent) * fifthFreqCoef
            fifthGainCurrent += (fifthGainTarget - fifthGainCurrent) * fifthGainCoef

            // Grounds, carrier and fifth all pass through the room's filter.
            var pre = 0.0
            for ground in grounds {
                ground.current += (ground.target - ground.current) * Float(groundCoef)
                // A silent ground costs nothing; its phase simply waits.
                if ground.current < 0.00002 && ground.target < 0.00002 { continue }
                pre += ground.render(sampleRate: sr)
            }
            carrierPhase += carrierFreqCurrent * dt
            if carrierPhase >= 1 { carrierPhase -= 1 }
            pre += sin(carrierPhase * 2 * .pi) * carrierGainCurrent
            fifthPhase += fifthFreqCurrent * dt
            if fifthPhase >= 1 { fifthPhase -= 1 }
            pre += sin(fifthPhase * 2 * .pi) * fifthGainCurrent
            let filtered = lowpass.process(pre)

            // Air and the strikes reach the master directly.
            noiseIndex += 1
            if noiseIndex >= noise.count { noiseIndex = 0 }
            let air = airBand.process(Double(noise[noiseIndex])) * airGainCurrent

            var struck = 0.0
            for k in strikes.indices where strikes[k].active {
                var s = strikes[k]
                s.elapsed += dt
                if s.elapsed >= HomeCarrier.strikeRelease {
                    s.active = false
                } else {
                    if s.elapsed < HomeCarrier.strikeAttack {
                        s.amplitude = HomeCarrier.strikePeak * (s.elapsed / HomeCarrier.strikeAttack)
                    } else {
                        s.amplitude *= s.decay
                    }
                    s.phase += s.freq * dt
                    if s.phase >= 1 { s.phase -= 1 }
                    struck += sin(s.phase * 2 * .pi) * s.amplitude
                }
                strikes[k] = s
            }

            samples[i] = Float((filtered + air + struck) * Double(masterCurrent))
        }
    }
}

// MARK: - The service

/// The per-Śakti carrier — Build Brief v2 §2.3, ported from Design's
/// `homes-sound.js`.
///
/// Her bīja is the carrier; her āvaraṇa's drone is the ground. Climbing
/// crossfades the ground; entering brings her carrier up; her adaptation opens
/// the filter. The fifth is withheld until the ninth world, or until a very
/// long stay.
///
/// This runs its **own** `AVAudioEngine`, parallel to `RingAudioService` and
/// coexisting with it — the ring techniques there are untouched (Build Brief v2
/// §2.3 is explicit). Both services set the same session category
/// (`.playback` + `.mixWithOthers`), so the two graphs mix rather than evict
/// one another, and neither evicts the practitioner's own music.
///
/// Two things Design's JS gets away with and Swift must not: its `setInterval`
/// steppers are never cleared (here they are cancellable `Task`s, cancelled in
/// `stopAll`), and it has no lifecycle at all (here `start()` / `stopAll()`,
/// with `stopAll` idempotent and safe when nothing ever started).
///
/// The descent is silent here. Build Brief v2 names a "descent glissando";
/// nothing of the kind exists anywhere in Design's package, so none was
/// invented — Phase 3.9, where the descent is actually built, owns it.
@MainActor
final class HomeSoundService {
    static let shared = HomeSoundService()

    private let sampleRate: Double = 44_100

    private var engine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var mixer: AVAudioMixerNode?
    private var state: HomeRenderState?

    private var isBuilt = false
    private var isPaused = false
    /// Bumped on every teardown so a pending fade cannot reach a fresh graph.
    private var generation = 0
    private var scheduled: [Task<Void, Never>] = []
    private var observers: [NSObjectProtocol] = []

    /// When true the instrument is configured `.ambient` and the hardware
    /// silent switch stops it. Default `false` — `.playback` + `.mixWithOthers`,
    /// exactly as `RingAudioService` and `BijaSoundService` already set it, so
    /// sacred sound is not muted by a switch flipped for a notification. Set it
    /// before the first `start()`.
    var respectsSilentSwitch = false

    private init() {}

    /// True while the instrument is actually sounding.
    var isSounding: Bool {
        guard isBuilt, let state else { return false }
        return Double(state.masterCurrent) > HomeCarrier.soundingFloor
    }

    // MARK: Lifecycle

    /// Build the graph if it is not built, resume it if it was paused, and
    /// bring the master up. Design splits this into `start()` (build/resume)
    /// and `wake()` (raise the master); a caller that wants the graph running
    /// but silent calls `start()` then `quiet()`.
    func start() {
        if isBuilt {
            resume()
            wakeMaster()
            return
        }
        guard configureSession() else { return }
        build()
        guard isBuilt, let engine else { return }
        do {
            try engine.start()
        } catch {
            // Silent — the instrument's voice is a delight, not a guarantee.
            teardown()
            return
        }
        observeSession()
        startSchedule()
        wakeMaster()
    }

    private func wakeMaster() {
        guard let state else { return }
        state.masterCoef = Float(state.coefficient(tau: HomeCarrier.Tau.master))
        state.masterTarget = Float(HomeCarrier.wakeLevel)
    }

    /// Fade to silence but keep the graph — Design's `stop()`.
    func quiet() {
        guard isBuilt, let state else { return }
        state.masterCoef = Float(state.coefficient(tau: HomeCarrier.Tau.masterOut))
        state.masterTarget = 0
    }

    /// Stop everything and let it all go. Idempotent, and safe when nothing
    /// ever started: the whole graph is lazy, so a service that never sounded
    /// holds no engine to stop.
    func stopAll() {
        for task in scheduled { task.cancel() }
        scheduled.removeAll()
        removeObservers()
        guard isBuilt else {
            isPaused = false
            return
        }
        isBuilt = false
        isPaused = false
        generation &+= 1
        let mark = generation
        if let state {
            state.masterCoef = Float(state.coefficient(tau: HomeCarrier.Tau.masterOut))
            state.masterTarget = 0
        }
        // Let the fade land before the nodes go.
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(HomeCarrier.teardownDelay))
            guard let self, self.generation == mark, !self.isBuilt else { return }
            self.teardown()
        }
    }

    private func teardown() {
        if let engine {
            if engine.isRunning { engine.stop() }
            if let sourceNode {
                engine.disconnectNodeOutput(sourceNode)
                engine.detach(sourceNode)
            }
            if let mixer {
                engine.disconnectNodeOutput(mixer)
                engine.detach(mixer)
            }
        }
        sourceNode = nil
        mixer = nil
        engine = nil
        state = nil
        isBuilt = false
        restoreSession()
    }

    // MARK: Session

    private func configureSession() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            // **`.mixWithOthers` is not valid with `.ambient`.** The option is
            // documented for `.playAndRecord`, `.playback` and `.multiRoute`
            // only, and `.ambient` mixes by definition; passing it anyway throws
            // `-50`, `configureSession` answers `false`, and `start()` returns
            // without ever building the graph. That branch had never been taken
            // — Phase 2.3 shipped the flag with no caller — so the whole carrier
            // would have been silent on the first stay that asked for the silent
            // switch to be honoured, with no error anywhere to say why.
            if respectsSilentSwitch {
                try session.setCategory(.ambient, mode: .default)
            } else {
                try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            }
            try session.setActive(true)
            return true
        } catch {
            return false
        }
    }

    /// Put the shared session back the way the rest of the app asks for it.
    ///
    /// `RingAudioService` and `BijaSoundService` each set `.playback` **once**,
    /// behind a `configured` flag, and never again — so a session this service
    /// left on `.ambient` would quietly silence every later bīja tap under a
    /// silent switch, on screens that ruled the other way and never knew this
    /// one had been here. The room's ruling is the room's, and it is given back
    /// at the door.
    private func restoreSession() {
        guard respectsSilentSwitch else { return }
        try? AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .default, options: [.mixWithOthers])
    }

    /// An interruption (a call, Siri) or a route change (headphones pulled)
    /// pauses cleanly rather than sounding into a room that did not ask.
    /// `RingAudioService` does not do this; this is confined to this service.
    private func observeSession() {
        guard observers.isEmpty else { return }
        let center = NotificationCenter.default
        let session = AVAudioSession.sharedInstance()
        observers.append(center.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: .main
        ) { [weak self] note in
            let type = (note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt) ?? 0
            let options = (note.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt) ?? 0
            Task { @MainActor in self?.handleInterruption(type: type, options: options) }
        })
        observers.append(center.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: session,
            queue: .main
        ) { [weak self] note in
            let reason = (note.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt) ?? 0
            Task { @MainActor in self?.handleRouteChange(reason: reason) }
        })
    }

    private func removeObservers() {
        for observer in observers { NotificationCenter.default.removeObserver(observer) }
        observers.removeAll()
    }

    private func handleInterruption(type: UInt, options: UInt) {
        if type == AVAudioSession.InterruptionType.began.rawValue {
            pause()
        } else if type == AVAudioSession.InterruptionType.ended.rawValue {
            let shouldResume = AVAudioSession.InterruptionOptions(rawValue: options)
                .contains(.shouldResume)
            if shouldResume { resume() }
        }
    }

    private func handleRouteChange(reason: UInt) {
        // Headphones pulled: never let the room hear it.
        if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
            pause()
        }
    }

    private func pause() {
        guard isBuilt, !isPaused, let state else { return }
        isPaused = true
        state.masterCoef = Float(state.coefficient(tau: HomeCarrier.pauseTau))
        state.masterTarget = 0
        let mark = generation
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(HomeCarrier.pauseDelay))
            guard let self, self.generation == mark, self.isPaused else { return }
            self.engine?.pause()
        }
    }

    private func resume() {
        guard isBuilt, isPaused, let engine, let state else { return }
        isPaused = false
        _ = configureSession()
        if !engine.isRunning {
            do { try engine.start() } catch { return }
        }
        state.masterCoef = Float(state.coefficient(tau: HomeCarrier.Tau.master))
        state.masterTarget = Float(HomeCarrier.wakeLevel)
    }

    // MARK: The graph

    private func build() {
        // A `start()` inside `stopAll`'s fade window still has the old graph
        // alive; let it go before a new one is built, or it would sound on with
        // nothing left holding it.
        if self.engine != nil { teardown() }
        let engine = AVAudioEngine()
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            return
        }
        let state = HomeRenderState(sampleRate: sampleRate)
        state.grounds = Self.makeGrounds(sampleRate: sampleRate)

        let source = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let bufferList = UnsafeMutableAudioBufferListPointer(abl)
            guard let first = bufferList.first else { return noErr }
            let samples = UnsafeMutableBufferPointer<Float>(
                start: first.mData?.assumingMemoryBound(to: Float.self),
                count: Int(frameCount)
            )
            state.render(into: samples, frameCount: Int(frameCount))
            return noErr
        }
        let mixer = AVAudioMixerNode()
        mixer.outputVolume = 1.0

        // Touch the main mixer so the graph has an output before `start()`.
        _ = engine.mainMixerNode
        engine.attach(source)
        engine.attach(mixer)
        engine.connect(source, to: mixer, format: format)
        engine.connect(mixer, to: engine.mainMixerNode, format: format)

        self.engine = engine
        self.sourceNode = source
        self.mixer = mixer
        self.state = state
        self.isBuilt = true
        self.isPaused = false
    }

    /// Nine grounds, each voiced by its own ring's technique rather than nine
    /// copies of one drone. Every number comes from `HomeCarrier`'s table, so
    /// the table and the sound cannot drift apart.
    private static func makeGrounds(sampleRate: Double) -> [HomeGround] {
        HomeCarrier.roots.enumerated().map { index, hz in
            let ring = index + 1
            let technique = HomeCarrier.technique(forRing: ring)
            let spec = HomeCarrier.ground(forRing: ring)
            let ground = HomeGround()
            ground.amRate = spec.amRate
            ground.amDepth = spec.amDepth
            if let band = spec.band {
                var filter = HomeBiquad()
                filter.setBandpass(frequency: hz * band.multiple,
                                   q: band.q,
                                   sampleRate: sampleRate)
                ground.band = filter
            }
            for partial in spec.partials {
                var p = HomePartial()
                p.wave = partial.wave
                p.freq = hz * partial.multiple
                p.gain = partial.gain
                p.throughBand = partial.throughBand
                p.lfoRate = partial.lfoRate
                p.lfoDepth = partial.lfoDepth
                p.freqCoef = partial.glideTau > 0
                    ? 1 - exp(-1.0 / (partial.glideTau * sampleRate))
                    : 1
                ground.partials.append(p)
                ground.targetFreqs.append(p.freq)
            }
            // The two techniques whose ground keeps moving after it is built.
            if technique == .stepped { ground.stepBase = hz }
            if technique == .triad { ground.triadBase = hz }
            return ground
        }
    }

    // MARK: The schedule — cancellable, unlike Design's `setInterval`

    private func startSchedule() {
        // Rings 4 and 5 step; 4 is the slower of the two.
        for ring in [4, 5] {
            let period = HomeCarrier.stepPeriod(forRing: ring)
            scheduled.append(Task { @MainActor [weak self] in
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(period))
                    if Task.isCancelled { return }
                    self?.advanceStep(ring: ring)
                }
            })
        }
        // Ring 8's triad collapses and reopens.
        scheduled.append(Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(HomeCarrier.triadPeriod))
                if Task.isCancelled { return }
                self?.advanceTriad()
            }
        })
    }

    /// Rings 4 and 5: the **first** partial steps, as Design's `st` does.
    private func advanceStep(ring: Int) {
        guard isBuilt, let ground = ground(atIndex: ring - 1) else { return }
        guard !ground.targetFreqs.isEmpty else { return }
        ground.stepIndex = (ground.stepIndex + 1) % HomeCarrier.steps.count
        ground.targetFreqs[0] = ground.stepBase * HomeCarrier.steps[ground.stepIndex]
    }

    /// Ring 8: the **second and third** partials collapse toward the first, and
    /// reopen to where the table put them.
    private func advanceTriad() {
        guard isBuilt, let ground = ground(atIndex: 7) else { return }
        guard ground.targetFreqs.count >= 3 else { return }
        ground.triadCollapsed.toggle()
        let hz = ground.triadBase
        let open = HomeCarrier.ground(forRing: 8).partials
        ground.targetFreqs[1] = ground.triadCollapsed ? hz : hz * open[1].multiple
        ground.targetFreqs[2] = ground.triadCollapsed ? hz : hz * open[2].multiple
    }

    private func ground(atIndex index: Int) -> HomeGround? {
        guard let state, state.grounds.indices.contains(index) else { return nil }
        return state.grounds[index]
    }

    // MARK: The instrument's four gestures

    /// Climbing: which ground, and how much of the next one.
    /// `i0` and `i1` are ground indices (0 = the first āvaraṇa), `k` the blend.
    func setGround(index i0: Int, next i1: Int, blend k: Double) {
        guard isBuilt, let state else { return }
        let blend = max(0, min(1, k))
        for (i, ground) in state.grounds.enumerated() {
            let want: Double
            if i == i0 {
                want = (1 - blend) * HomeCarrier.groundLevel
            } else if i == i1 {
                want = blend * HomeCarrier.groundLevel
            } else {
                want = 0
            }
            ground.target = Float(want)
        }
    }

    /// Entering her: the carrier comes up, the ground recedes.
    func setCarrier(ring: Int, amount: Double, syllable: String?) {
        guard isBuilt, let state else { return }
        state.carrierFreqTarget = HomeCarrier.carrierFor(ring: ring, syllable: syllable)
        state.carrierGainTarget = max(0, min(1, amount)) * HomeCarrier.carrierLevel
    }

    /// Her adaptation opens the filter; the second adaptation grants the fifth.
    func setRoom(a: Double, b: Double, ring: Int, syllable: String?) {
        guard isBuilt, let state else { return }
        let first = max(0, min(1, a))
        let second = max(0, min(1, b))
        state.lowpassTarget = HomeCarrier.filterCutoff(adaptation: first)
        state.fifthFreqTarget = HomeCarrier.carrierFor(ring: ring, syllable: syllable)
            * HomeCarrier.fifthRatio
        state.fifthGainTarget = HomeCarrier.fifthGain(b: second, ring: ring)
        state.airGainTarget = HomeCarrier.airGain(adaptation: first)
        state.airFreqTarget = HomeCarrier.airCutoff(adaptation: first)
    }

    /// One struck tone as a beat of the rite lands.
    func strike(ring: Int, beat: Int, syllable: String?) {
        guard isBuilt, let state else { return }
        state.fire(strike: HomeCarrier.strikeFrequency(ring: ring, beat: beat, syllable: syllable))
    }
}
