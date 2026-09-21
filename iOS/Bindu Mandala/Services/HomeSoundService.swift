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
        let ratios: [Double] = [1, 1.5, 2]
        let ratio = ratios[max(0, min(ratios.count - 1, beat - 1))]
        return carrierFor(ring: ring, syllable: syllable) * ratio
    }

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
        return allow * 0.05
    }

    /// The ground's level when it is the one you are standing in.
    static let groundLevel: Double = 0.16
    /// The carrier's level at full entry.
    static let carrierLevel: Double = 0.1
    /// Where `wake` brings the master.
    static let wakeLevel: Double = 0.5
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

enum HomeWave {
    case sine, triangle, saw
}

/// A partial of a ground voice. `freqCoef` of 1 is Web Audio's
/// `setValueAtTime` (a step); anything smaller is `setTargetAtTime` (a glide).
struct HomePartial {
    var wave: HomeWave = .sine
    var freq: Double = 0
    var targetFreq: Double = 0
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
            if p.freqCoef >= 1 {
                p.freq = p.targetFreq
            } else {
                p.freq += (p.targetFreq - p.freq) * p.freqCoef
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
    var lowpassTarget: Double = 220
    var lowpassCurrent: Double = 220
    let lowpassCoef: Double
    var lowpass = HomeBiquad()

    // Nine grounds, all running, all silent but the one you are in.
    var grounds: [HomeGround] = []
    let groundCoef: Double

    // Her carrier — silent until you enter her.
    var carrierFreqTarget: Double = 136.1
    var carrierFreqCurrent: Double = 136.1
    var carrierGainTarget: Double = 0
    var carrierGainCurrent: Double = 0
    var carrierPhase: Double = 0
    let carrierFreqCoef: Double
    let carrierGainCoef: Double

    // The withheld fifth.
    var fifthFreqTarget: Double = 204.15
    var fifthFreqCurrent: Double = 204.15
    var fifthGainTarget: Double = 0
    var fifthGainCurrent: Double = 0
    var fifthPhase: Double = 0
    let fifthFreqCoef: Double
    let fifthGainCoef: Double

    // Air — the room's own breath, bandpassed noise.
    var airGainTarget: Double = 0
    var airGainCurrent: Double = 0
    var airFreqTarget: Double = 460
    var airFreqCurrent: Double = 460
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
        self.masterCoef = Float(coef(1.2))
        self.lowpassCoef = coef(1.4)
        self.groundCoef = coef(0.9)
        self.carrierFreqCoef = coef(0.6)
        self.carrierGainCoef = coef(0.7)
        self.fifthFreqCoef = coef(0.8)
        self.fifthGainCoef = coef(2.0)
        self.airGainCoef = coef(1.5)
        self.airFreqCoef = coef(1.6)
        self.strikes = Array(repeating: HomeStrike(), count: 8)

        // Four seconds of noise, looped — Design's own buffer.
        let count = Int(sampleRate * 4)
        var buffer = [Float](repeating: 0, count: count)
        var seed: UInt64 = 0x9E3779B97F4A7C15
        for i in 0..<count {
            seed ^= seed << 13
            seed ^= seed >> 7
            seed ^= seed << 17
            let unit = Double(seed >> 11) / Double(UInt64(1) << 53)
            buffer[i] = Float((unit * 2 - 1) * 0.5)
        }
        self.noise = buffer

        lowpass.setLowpass(frequency: lowpassCurrent, q: 0.7, sampleRate: sampleRate)
        airBand.setBandpass(frequency: airFreqCurrent, q: 0.6, sampleRate: sampleRate)
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
        // 0 → 0.05 over 20 ms, then an exponential fall to 0.0001 at 3.4 s.
        let ratio = 0.0001 / 0.05
        strikes[index] = HomeStrike(
            active: true,
            freq: frequency,
            phase: 0,
            elapsed: 0,
            amplitude: 0,
            decay: pow(ratio, 1.0 / (3.38 * sampleRate))
        )
    }

    func render(into samples: UnsafeMutableBufferPointer<Float>, frameCount: Int) {
        let sr = sampleRate
        let dt = 1.0 / sr
        for i in 0..<frameCount {
            if controlCounter == 0 {
                lowpass.setLowpass(frequency: lowpassCurrent, q: 0.7, sampleRate: sr)
                airBand.setBandpass(frequency: airFreqCurrent, q: 0.6, sampleRate: sr)
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
                if s.elapsed >= 3.6 {
                    s.active = false
                } else {
                    if s.elapsed < 0.02 {
                        s.amplitude = 0.05 * (s.elapsed / 0.02)
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
        return state.masterCurrent > 0.001
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
        state.masterCoef = Float(state.coefficient(tau: 1.2))
        state.masterTarget = Float(HomeCarrier.wakeLevel)
    }

    /// Fade to silence but keep the graph — Design's `stop()`.
    func quiet() {
        guard isBuilt, let state else { return }
        state.masterCoef = Float(state.coefficient(tau: 0.5))
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
            state.masterCoef = Float(state.coefficient(tau: 0.5))
            state.masterTarget = 0
        }
        // Let the fade land before the nodes go.
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(0.8))
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
    }

    // MARK: Session

    private func configureSession() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            let category: AVAudioSession.Category = respectsSilentSwitch ? .ambient : .playback
            try session.setCategory(category, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            return true
        } catch {
            return false
        }
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
        state.masterCoef = Float(state.coefficient(tau: 0.2))
        state.masterTarget = 0
        let mark = generation
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(0.35))
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
        state.masterCoef = Float(state.coefficient(tau: 1.2))
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
    /// copies of one drone.
    private static func makeGrounds(sampleRate: Double) -> [HomeGround] {
        HomeCarrier.roots.enumerated().map { index, hz in
            let ring = index + 1
            let ground = HomeGround()
            func partial(_ wave: HomeWave,
                         _ freq: Double,
                         _ gain: Double,
                         band: Bool = false,
                         lfoRate: Double = 0,
                         lfoDepth: Double = 0,
                         glideTau: Double = 0) {
                var p = HomePartial()
                p.wave = wave
                p.freq = freq
                p.targetFreq = freq
                p.gain = gain
                p.throughBand = band
                p.lfoRate = lfoRate
                p.lfoDepth = lfoDepth
                p.freqCoef = glideTau > 0 ? 1 - exp(-1.0 / (glideTau * sampleRate)) : 1
                ground.partials.append(p)
            }

            switch HomeCarrier.technique(forRing: ring) {
            case .drone:
                partial(.sine, hz, 1)
                partial(.sine, hz * 1.0035, 0.8)
                partial(.triangle, hz * 2, 0.16)
            case .breath:
                // The home ring breathes: an LFO on its own amplitude.
                partial(.sine, hz, 1)
                partial(.sine, hz * 1.5, 0.3)
                ground.amRate = 0.14
                ground.amDepth = 0.55
            case .breathy:
                // A sustained voice with air in it.
                partial(.sine, hz, 0.7)
                partial(.saw, hz * 1.002, 0.1)
                var band = HomeBiquad()
                band.setBandpass(frequency: hz * 4, q: 1.6, sampleRate: sampleRate)
                ground.band = band
                partial(.saw, hz * 2.01, 0.05, band: true)
            case .stepped:
                // Notes that step rather than glide.
                partial(.sine, hz, 1)
                partial(.sine, hz / 2, 0.4)
                ground.stepBase = hz
            case .sourceless:
                // The witness: no fundamental at all, only its overtones.
                partial(.sine, hz * 2, 0.42)
                partial(.sine, hz * 3, 0.26)
                partial(.sine, hz * 5, 0.14)
            case .triad:
                // Three that collapse toward one.
                partial(.sine, hz, 0.7)
                partial(.sine, hz * 1.26, 0.6, glideTau: 3.4)
                partial(.sine, hz * 1.5, 0.6, glideTau: 3.4)
                ground.triadBase = hz
            case .shepard:
                // A rising that never arrives.
                for k in 0..<5 {
                    let detune = pow(2.0, Double(k) * 3.0 / 1200.0)
                    let rate = 0.021 * pow(2.0, Double(k) * 40.0 / 1200.0)
                    partial(.sine, hz * pow(2.0, Double(k) - 1) * detune, 0.22,
                            lfoRate: rate, lfoDepth: 0.22)
                }
            }
            return ground
        }
    }

    // MARK: The schedule — cancellable, unlike Design's `setInterval`

    private func startSchedule() {
        // Rings 4 and 5 step; 4 is the slower of the two.
        for ring in [4, 5] {
            let period: Double = ring == 4 ? 5.2 : 3.4
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
                try? await Task.sleep(for: .seconds(14))
                if Task.isCancelled { return }
                self?.advanceTriad()
            }
        })
    }

    private func advanceStep(ring: Int) {
        guard isBuilt, let ground = ground(atIndex: ring - 1) else { return }
        let steps: [Double] = [1, 9.0 / 8.0, 5.0 / 4.0, 3.0 / 2.0]
        ground.stepIndex = (ground.stepIndex + 1) % steps.count
        guard !ground.partials.isEmpty else { return }
        ground.partials[0].targetFreq = ground.stepBase * steps[ground.stepIndex]
    }

    private func advanceTriad() {
        guard isBuilt, let ground = ground(atIndex: 7) else { return }
        guard ground.partials.count >= 3 else { return }
        ground.triadCollapsed.toggle()
        let hz = ground.triadBase
        ground.partials[1].targetFreq = ground.triadCollapsed ? hz : hz * 1.26
        ground.partials[2].targetFreq = ground.triadCollapsed ? hz : hz * 1.5
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
        state.fifthFreqTarget = HomeCarrier.carrierFor(ring: ring, syllable: syllable) * 1.5
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
