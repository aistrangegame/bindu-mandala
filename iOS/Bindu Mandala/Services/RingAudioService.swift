import AVFoundation
import Foundation

/// Continuous and modulated audio for the nine ring worlds.
///
/// `BijaSoundService` handles discrete bīja taps from ShaktiDetail and the Ring 7
/// chamber. This service handles every other ring-world voice — drones, sustained
/// breathy tones, the Ring 8 triad collapse, and the Ring 9 Shepard descent.
///
/// All voices are lazily started on first user gesture, run quietly (master
/// gain ~0.05–0.07), and stop cleanly when the view dismisses. Each ring world
/// owns its on/off state via the lower-left `RingSoundDot`.
@MainActor
final class RingAudioService {
    static let shared = RingAudioService()

    private let engine = AVAudioEngine()
    private let sampleRate: Double = 44_100
    private var configured = false

    // Active voices, keyed by ring world. Detaching on stop releases the node.
    private var groundDrone: ContinuousVoice?
    private var homeBreath: ContinuousVoice?
    private var sustainedVoice: ContinuousVoice?
    private var r8Triad: TriadVoice?
    private var shepard: ShepardVoice?

    private init() {}

    // MARK: - Engine lifecycle

    private func configureIfNeeded() throws {
        guard !configured else { return }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
        // Touching mainMixerNode (and through it, outputNode) ensures the
        // engine graph has the required output before `start()` is called —
        // otherwise AVFAudio throws `inputNode != nullptr || outputNode != nullptr`.
        _ = engine.mainMixerNode
        configured = true
        // The engine is started after each voice attaches its source node,
        // not here. See `startEngineIfNeeded()`.
    }

    private func startEngineIfNeeded() {
        guard engine.isRunning == false else { return }
        do {
            try engine.start()
        } catch {
            // Silent — audio is a delight, not a guarantee.
        }
    }

    // MARK: - Ring 1 · Ground drone (root 73.42 + fifth 110, LFO 0.07, fade 2.2s)

    func groundDroneStart() {
        guard groundDrone == nil else { return }
        do { try configureIfNeeded() } catch { return }
        let voice = ContinuousVoice(
            engine: engine,
            sampleRate: sampleRate,
            spec: .init(
                fundamental: 73.42,
                harmonics: [(110.0, 0.40)],
                lfoRate: 0.07,
                lfoDepth: 0.018,
                targetGain: 0.05,
                fadeIn: 2.2
            )
        )
        voice.start()
        groundDrone = voice
        startEngineIfNeeded()
    }

    func groundDroneStop() {
        groundDrone?.stop()
        groundDrone = nil
    }

    // MARK: - Ring 2 · Home breath (130.81 + 196 fifth, LFO 0.18 ±0.02)

    func homeBreathStart() {
        guard homeBreath == nil else { return }
        do { try configureIfNeeded() } catch { return }
        let voice = ContinuousVoice(
            engine: engine,
            sampleRate: sampleRate,
            spec: .init(
                fundamental: 130.81,
                harmonics: [(196.00, 0.45)],
                lfoRate: 0.18,
                lfoDepth: 0.020,
                targetGain: 0.045,
                fadeIn: 0.6
            )
        )
        voice.start()
        homeBreath = voice
        startEngineIfNeeded()
    }

    /// Set the target gain (0.045 idle, 0.075 on petal press).
    func homeBreathGain(_ value: Float) { homeBreath?.setGain(value) }

    func homeBreathStop() {
        homeBreath?.stop()
        homeBreath = nil
    }

    // MARK: - Rings 3 & 6 · Sustained breathy voice (single freq + vibrato LFO)

    /// `freq`: 116.5 for Ring 3, 207.65 for Ring 6.
    /// `vol`: initial target gain.
    /// `vibrato`: ± Hz on the carrier frequency at 0.25 Hz LFO rate.
    func sustainedVoiceStart(freq: Double, vol: Float, vibrato: Float) {
        guard sustainedVoice == nil else { return }
        do { try configureIfNeeded() } catch { return }
        let voice = ContinuousVoice(
            engine: engine,
            sampleRate: sampleRate,
            spec: .init(
                fundamental: freq,
                harmonics: [],
                lfoRate: 0.25,
                lfoDepth: 0,
                targetGain: vol,
                fadeIn: 0.4,
                vibratoHz: vibrato
            )
        )
        voice.start()
        sustainedVoice = voice
        startEngineIfNeeded()
    }

    func sustainedVoiceGain(_ value: Float) { sustainedVoice?.setGain(value) }

    func sustainedVoiceStop() {
        sustainedVoice?.stop()
        sustainedVoice = nil
    }

    // MARK: - Ring 4 & 5 · Discrete stepped notes (delegate to BijaSoundService)

    /// Used by Ring 4 (lineage transmission) and Ring 5 (overflow swell).
    nonisolated func playSteppedNote(freq: Double,
                                     duration: TimeInterval = 1.2,
                                     volume: Float = 0.09) {
        Task { @MainActor in
            BijaSoundService.shared.playVakBija(
                frequency: freq,
                duration: duration,
                volume: Double(volume)
            )
        }
    }

    /// A soft bell as an enclosure is crossed inward in the living Mandala.
    /// Deeper enclosures ring lower; the Bindu is the ground tone. Opt-in — the
    /// caller only invokes this when the practitioner has enabled ring chimes, and
    /// only on inward crossings (silent on the way out).
    nonisolated func ringChime(_ ring: Int) {
        let clamped = max(1, min(9, ring))
        // Ring 1 (outer) brightest, falling ~a whole tone per enclosure inward.
        let freq = 528.0 * pow(0.917, Double(clamped - 1))
        playSteppedNote(freq: freq, duration: 1.5, volume: 0.06)
    }

    // MARK: - Ring 8 · Triad collapse (3 sines glide between targets)

    enum R8Target {
        case triad           // each voice at its own R8_FREQS index
        case vertex(Int)     // all three glide to R8_FREQS[index]
        case bindu           // all three glide to 130.81 (octave below Icchā)
    }

    /// R8_FREQS: Icchā · Jñāna · Kriyā (a minor triad).
    static let r8Frequencies: [Double] = [261.63, 311.13, 392.00]

    func r8Start() {
        guard r8Triad == nil else { return }
        do { try configureIfNeeded() } catch { return }
        let voice = TriadVoice(
            engine: engine,
            sampleRate: sampleRate,
            frequencies: Self.r8Frequencies,
            targetMasterGain: 0.06,
            fadeIn: 0.5
        )
        voice.start()
        r8Triad = voice
        startEngineIfNeeded()
    }

    func r8Set(_ target: R8Target) {
        guard let voice = r8Triad else { return }
        let targets: [Double]
        switch target {
        case .triad:
            targets = Self.r8Frequencies
        case .vertex(let idx):
            let freq = Self.r8Frequencies[max(0, min(2, idx))]
            targets = [freq, freq, freq]
        case .bindu:
            targets = [130.81, 130.81, 130.81]
        }
        voice.glide(to: targets, tau: 0.55)
    }

    func r8Stop() {
        r8Triad?.stop()
        r8Triad = nil
    }

    // MARK: - Ring 9 · Shepard tone (7 octave-stacked descending sines, bell amp)

    func shepardStart() {
        guard shepard == nil else { return }
        do { try configureIfNeeded() } catch { return }
        let voice = ShepardVoice(engine: engine, sampleRate: sampleRate)
        voice.start()
        shepard = voice
        startEngineIfNeeded()
    }

    /// `value`: 0 (silent) … 1 (full descent). Tracked from the view's descent speed.
    func shepardSet(intensity value: Double) {
        shepard?.setIntensity(value)
    }

    func shepardStop() {
        shepard?.stop()
        shepard = nil
    }

    // MARK: - Global stop (used on app background)

    func stopAll() {
        groundDroneStop()
        homeBreathStop()
        sustainedVoiceStop()
        r8Stop()
        shepardStop()
    }
}

// MARK: - ContinuousVoice — a sustained tone with optional fifth + LFOs

@MainActor
final class ContinuousVoice {
    struct Spec {
        var fundamental: Double
        /// Each harmonic: (frequency in Hz, relative gain weight 0-1).
        var harmonics: [(Double, Double)]
        var lfoRate: Double = 0   // amplitude LFO rate, Hz
        var lfoDepth: Double = 0  // amplitude LFO depth (added to gain)
        var targetGain: Float
        var fadeIn: TimeInterval
        var vibratoHz: Float = 0  // ± Hz on the fundamental at lfoRate
    }

    private weak var engine: AVAudioEngine?
    private let sourceNode: AVAudioSourceNode
    private let mixer: AVAudioMixerNode
    private let spec: Spec

    // Atomic-ish state read by the render thread. Float is small + aligned;
    // for non-real-time correctness this is sufficient at our cadence.
    private var phases: [Double]
    private var carrierFreq: Double
    private var harmonicFreqs: [Double]
    private var targetGain: Float
    private var currentGain: Float = 0
    private var lfoPhase: Double = 0
    private let sampleRate: Double

    init(engine: AVAudioEngine, sampleRate: Double, spec: Spec) {
        self.engine = engine
        self.sampleRate = sampleRate
        self.spec = spec
        self.carrierFreq = spec.fundamental
        self.harmonicFreqs = spec.harmonics.map(\.0)
        self.phases = Array(repeating: 0, count: 1 + spec.harmonics.count)
        self.targetGain = spec.targetGain

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let mixer = AVAudioMixerNode()
        mixer.outputVolume = 1.0
        self.mixer = mixer

        // Snapshot values for the render block — avoid capturing `self`.
        let nHarmonics = spec.harmonics.count
        let harmonicWeights = spec.harmonics.map(\.1)
        let lfoRate = spec.lfoRate
        let lfoDepth = spec.lfoDepth
        let vibrato = Double(spec.vibratoHz)
        let sr = sampleRate

        // State held via NSLock-free reads; this is single-producer for params,
        // single-consumer for samples — race risks are bounded to a tone glitch.
        let state = VoiceState()
        state.carrier = spec.fundamental
        state.harmonics = spec.harmonics.map(\.0)
        state.phases = Array(repeating: 0, count: 1 + nHarmonics)
        state.targetGain = spec.targetGain
        state.currentGain = 0
        state.lfoPhase = 0

        self.sourceNode = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let bufferList = UnsafeMutableAudioBufferListPointer(abl)
            guard let firstBuf = bufferList.first else { return noErr }
            let samples = UnsafeMutableBufferPointer<Float>(
                start: firstBuf.mData?.assumingMemoryBound(to: Float.self),
                count: Int(frameCount)
            )
            let smoothing: Float = 0.0002   // gain follow per sample
            for i in 0..<Int(frameCount) {
                // Amplitude LFO (slow breath)
                state.lfoPhase += lfoRate / sr
                if state.lfoPhase > 1 { state.lfoPhase -= 1 }
                let lfo = sin(state.lfoPhase * 2 * .pi) * lfoDepth
                // Vibrato (carrier frequency wobble)
                let vibratoOffset: Double = vibrato == 0 ? 0
                    : vibrato * sin(state.lfoPhase * 2 * .pi)

                // Fundamental
                var sample: Double = 0
                let f0 = state.carrier + vibratoOffset
                state.phases[0] += f0 / sr
                if state.phases[0] > 1 { state.phases[0] -= 1 }
                sample += sin(state.phases[0] * 2 * .pi)

                // Harmonics
                for h in 0..<nHarmonics {
                    let fH = state.harmonics[h]
                    state.phases[h + 1] += fH / sr
                    if state.phases[h + 1] > 1 { state.phases[h + 1] -= 1 }
                    sample += sin(state.phases[h + 1] * 2 * .pi) * harmonicWeights[h]
                }

                // Apply gain with light smoothing toward target
                state.currentGain += (state.targetGain - state.currentGain) * smoothing
                let amp = Float(max(0, Double(state.currentGain) + lfo))
                samples[i] = Float(sample) * amp
            }
            return noErr
        }
        self.voiceState = state

        engine.attach(self.sourceNode)
        engine.attach(self.mixer)
        engine.connect(self.sourceNode, to: self.mixer, format: format)
        engine.connect(self.mixer, to: engine.mainMixerNode, format: format)
    }

    // Hold reference to render-block state so it isn't deinited.
    private let voiceState: VoiceState

    func start() {
        // Bring up over `fadeIn`. The render block reads `targetGain` via state.
        voiceState.targetGain = spec.targetGain
        // The smoothing constant in the render block effects a soft fade.
        // For long fade-ins (Ring 1's 2.2s), nudge target gradually via a Task.
        if spec.fadeIn > 0.5 {
            let target = spec.targetGain
            let steps = 32
            let delay = spec.fadeIn / Double(steps)
            voiceState.targetGain = 0
            Task { @MainActor in
                for i in 1...steps {
                    try? await Task.sleep(for: .seconds(delay))
                    self.voiceState.targetGain = target * Float(i) / Float(steps)
                }
            }
        }
    }

    func setGain(_ value: Float) { voiceState.targetGain = value }

    func stop() {
        voiceState.targetGain = 0
        // Detach after the gain has had time to settle to silence.
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(0.8))
            guard let self else { return }
            self.engine?.disconnectNodeOutput(self.sourceNode)
            self.engine?.disconnectNodeOutput(self.mixer)
            self.engine?.detach(self.sourceNode)
            self.engine?.detach(self.mixer)
        }
    }
}

/// Boxed render-block state. Direct stored properties are referenced by the
/// AVAudioSourceNode closure; this avoids capturing the actor-isolated voice.
final class VoiceState {
    var phases: [Double] = []
    var carrier: Double = 0
    var harmonics: [Double] = []
    var targetGain: Float = 0
    var currentGain: Float = 0
    var lfoPhase: Double = 0
}

// MARK: - TriadVoice — 3 sines that glide to target frequencies (Ring 8)

@MainActor
final class TriadVoice {
    private weak var engine: AVAudioEngine?
    private let sourceNode: AVAudioSourceNode
    private let mixer: AVAudioMixerNode
    private let state: TriadState
    private let sampleRate: Double
    private let targetMasterGain: Float
    private let fadeIn: TimeInterval

    init(engine: AVAudioEngine,
         sampleRate: Double,
         frequencies: [Double],
         targetMasterGain: Float,
         fadeIn: TimeInterval) {
        self.engine = engine
        self.sampleRate = sampleRate
        self.targetMasterGain = targetMasterGain
        self.fadeIn = fadeIn

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let mixer = AVAudioMixerNode()
        self.mixer = mixer

        let state = TriadState()
        state.targetFreqs = frequencies
        state.currentFreqs = frequencies
        state.phases = Array(repeating: 0, count: frequencies.count)
        state.targetMasterGain = 0
        state.currentMasterGain = 0
        self.state = state

        let sr = sampleRate
        let n = frequencies.count
        self.sourceNode = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let bufferList = UnsafeMutableAudioBufferListPointer(abl)
            guard let firstBuf = bufferList.first else { return noErr }
            let samples = UnsafeMutableBufferPointer<Float>(
                start: firstBuf.mData?.assumingMemoryBound(to: Float.self),
                count: Int(frameCount)
            )
            let gainSmoothing: Float = 0.0003
            let freqSmoothing: Double = 0.00002
            for i in 0..<Int(frameCount) {
                // Glide frequencies toward targets (setTargetAtTime analog).
                for j in 0..<n {
                    state.currentFreqs[j] +=
                        (state.targetFreqs[j] - state.currentFreqs[j]) * freqSmoothing
                }
                // Mix the three voices, each weighted 1/3.
                var sample: Double = 0
                for j in 0..<n {
                    state.phases[j] += state.currentFreqs[j] / sr
                    if state.phases[j] > 1 { state.phases[j] -= 1 }
                    sample += sin(state.phases[j] * 2 * .pi) / Double(n)
                }
                state.currentMasterGain +=
                    (state.targetMasterGain - state.currentMasterGain) * gainSmoothing
                samples[i] = Float(sample) * state.currentMasterGain
            }
            return noErr
        }

        engine.attach(self.sourceNode)
        engine.attach(self.mixer)
        engine.connect(self.sourceNode, to: self.mixer, format: format)
        engine.connect(self.mixer, to: engine.mainMixerNode, format: format)
    }

    func start() {
        state.targetMasterGain = targetMasterGain
    }

    /// `tau` is informational — the render-thread smoothing constant is fixed,
    /// but the perceived glide approximates Web Audio's `setTargetAtTime(_, _, tau)`.
    func glide(to targets: [Double], tau: Double) {
        guard targets.count == state.targetFreqs.count else { return }
        state.targetFreqs = targets
    }

    func stop() {
        state.targetMasterGain = 0
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(0.8))
            guard let self else { return }
            self.engine?.disconnectNodeOutput(self.sourceNode)
            self.engine?.disconnectNodeOutput(self.mixer)
            self.engine?.detach(self.sourceNode)
            self.engine?.detach(self.mixer)
        }
    }
}

final class TriadState {
    var phases: [Double] = []
    var currentFreqs: [Double] = []
    var targetFreqs: [Double] = []
    var targetMasterGain: Float = 0
    var currentMasterGain: Float = 0
}

// MARK: - ShepardVoice — 7 octave-stacked descending sines with bell amplitude

@MainActor
final class ShepardVoice {
    private weak var engine: AVAudioEngine?
    private let sourceNode: AVAudioSourceNode
    private let mixer: AVAudioMixerNode
    private let state: ShepardState
    private let sampleRate: Double

    private static let voiceCount = 7
    private static let fMin: Double = 32.7
    private static let octaveSpan: Double = 7.0

    init(engine: AVAudioEngine, sampleRate: Double) {
        self.engine = engine
        self.sampleRate = sampleRate

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let mixer = AVAudioMixerNode()
        self.mixer = mixer

        let state = ShepardState()
        state.phases = (0..<Self.voiceCount).map { Double($0) / Double(Self.voiceCount) }
        state.intensity = 0
        self.state = state

        let sr = sampleRate
        let n = Self.voiceCount
        let fMin = Self.fMin
        let span = Self.octaveSpan

        self.sourceNode = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let bufferList = UnsafeMutableAudioBufferListPointer(abl)
            guard let firstBuf = bufferList.first else { return noErr }
            let samples = UnsafeMutableBufferPointer<Float>(
                start: firstBuf.mData?.assumingMemoryBound(to: Float.self),
                count: Int(frameCount)
            )
            for i in 0..<Int(frameCount) {
                // Phase descent rate scales with intensity.
                let intensity = state.intensity
                let rate = 0.05 + 0.10 * intensity
                let dt = 1.0 / sr
                var sample: Double = 0
                for j in 0..<n {
                    state.phases[j] -= dt * rate
                    if state.phases[j] < 0 { state.phases[j] += 1 }
                    let phase = state.phases[j]
                    let freq = fMin * pow(2.0, phase * span)
                    state.phaseAccumulators[j] += freq / sr
                    if state.phaseAccumulators[j] > 1 {
                        state.phaseAccumulators[j] -= 1
                    }
                    // Bell-shaped amplitude over the phase range
                    let bellArg = (phase - 0.5) / 0.26
                    let amplitude = exp(-bellArg * bellArg) * 0.42
                    sample += sin(state.phaseAccumulators[j] * 2 * .pi) * amplitude
                }
                let masterGain = 0.07 * intensity
                samples[i] = Float(sample * masterGain)
            }
            return noErr
        }

        engine.attach(self.sourceNode)
        engine.attach(self.mixer)
        engine.connect(self.sourceNode, to: self.mixer, format: format)
        engine.connect(self.mixer, to: engine.mainMixerNode, format: format)
    }

    func start() {
        state.intensity = 0.25
        state.phaseAccumulators = Array(repeating: 0, count: Self.voiceCount)
    }

    func setIntensity(_ value: Double) {
        state.intensity = max(0, min(1, value))
    }

    func stop() {
        state.intensity = 0
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(0.8))
            guard let self else { return }
            self.engine?.disconnectNodeOutput(self.sourceNode)
            self.engine?.disconnectNodeOutput(self.mixer)
            self.engine?.detach(self.sourceNode)
            self.engine?.detach(self.mixer)
        }
    }
}

final class ShepardState {
    var phases: [Double] = []
    var phaseAccumulators: [Double] = Array(repeating: 0, count: 7)
    var intensity: Double = 0
}
