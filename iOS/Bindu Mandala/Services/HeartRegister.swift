import Foundation
import AVFoundation
import os

private let heartLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "heart-register")

// MARK: - Wave 6 · the heart register (Codex C-1169, C-1222, C-1297)
//
// A kīrtan/bhajan register at the heart: his chosen devotional sound — a
// harmonium-like drone on his own Sa, breathing on the one clock, and a call
// he can sing into. Call, then a held silence for his answer, then the call
// again: call-and-response, the bhajan tradition's own shape. It opens the
// heart room; it is not a playlist.
//
// **Synthesised, every sample.** No recording, no lyric, no licensed sound:
// reeds are sums of harmonics, the call is a sung-like tone with the gentle
// vibrato of a voice, and its phrases are bare scale motifs (sa re ga ma…),
// the common grammar every bhajan stands on rather than any one song. Nothing
// is claimed for any tone (truth floor).
//
// **Self-contained, on purpose.** Slice B's `SoundConductor` (one sound at a
// time across the app) is being built in parallel and was not in this tree;
// this engine owns its own graph and stops whatever it started. When the
// conductor lands, `HeartRegisterEngine.start` is the one place to ask it.
//
// The session is `.ambient` (which mixes by nature): the silent switch is honoured.

/// The register's pure grammar: Sa, the scale, the phrases, the drone's reeds.
enum HeartRegister {

    /// The Sa he may choose, in Hz — C3 … F3, the common harmonium keys for a
    /// man's voice.
    static let saChoices: [(name: String, hz: Double)] = [
        ("C", 130.81), ("C♯", 138.59), ("D", 146.83),
        ("D♯", 155.56), ("E", 164.81), ("F", 174.61),
    ]

    static let saKey = "heartRegister.sa.v1"

    static func chosenSa(_ defaults: UserDefaults = .standard) -> Int {
        let i = defaults.object(forKey: saKey) as? Int ?? 1
        return min(max(0, i), saChoices.count - 1)
    }

    static func choose(sa index: Int, _ defaults: UserDefaults = .standard) {
        defaults.set(min(max(0, index), saChoices.count - 1), forKey: saKey)
    }

    /// The drone's notes as ratios of Sa: lower Sa, Sa, Pa, upper Sa.
    static let droneRatios: [Double] = [0.5, 1, 1.5, 2]
    /// Their levels.
    static let droneGains: [Double] = [0.55, 0.7, 0.45, 0.25]
    /// A reed's harmonics: 1/n^0.8, six of them.
    static let harmonics: [Double] = (1...6).map { 1 / pow(Double($0), 0.8) }
    /// The two reeds of a harmonium beat a few cents apart.
    static let reedDetuneCents: Double = 3

    /// Semitones from Sa, as a bhajan's plain scale walks them.
    static let phrases: [[Int]] = [
        [0, 2, 4, 5, 4, 2, 0],          // sa re ga ma ga re sa
        [0, 4, 7, 9, 7, 4, 2, 0],       // sa ga pa dha pa ga re sa
        [7, 9, 7, 5, 4, 2, 0],          // pa dha pa ma ga re sa
        [0, 2, 4, 2, 0, -1, 0],         // sa re ga re sa ni sa
    ]

    /// How long each note of the call is held, and how long the silence for
    /// his answer: one breath of the one clock.
    static var noteSeconds: Double { BreathClock.breath / 8 * 0.9 }
    static var answerSeconds: Double { BreathClock.breath }

    static func hz(sa: Double, semitones: Int) -> Double {
        sa * pow(2, Double(semitones) / 12)
    }

    static func cents(_ c: Double) -> Double { pow(2, c / 1200) }
}

/// What the audio thread reads. Written from the main actor, read in render —
/// single values, as `HomeRenderState` does.
final class HeartRenderState {
    let sampleRate: Double
    var sa: Double
    var droneTarget: Double = 0
    var droneLevel: Double = 0
    var callFreq: Double
    var callFreqTarget: Double
    var callGain: Double = 0
    var callGainTarget: Double = 0

    private var dronePhases: [[Double]]
    private var callPhase: Double = 0
    private var vibratoPhase: Double = 0
    private var bellowsPhase: Double = 0

    init(sampleRate: Double, sa: Double) {
        self.sampleRate = sampleRate
        self.sa = sa
        self.callFreq = sa
        self.callFreqTarget = sa
        self.dronePhases = Array(repeating: Array(repeating: 0, count: HeartRegister.harmonics.count * 2),
                                 count: HeartRegister.droneRatios.count)
    }

    func render(into samples: UnsafeMutableBufferPointer<Float>, frameCount: Int) {
        let sr = sampleRate
        let dt = 1.0 / sr
        let levelCoef = 1 - exp(-1.0 / (1.2 * sr))
        let gainCoef = 1 - exp(-1.0 / (0.08 * sr))
        let glideCoef = 1 - exp(-1.0 / (0.06 * sr))
        let up = HeartRegister.cents(HeartRegister.reedDetuneCents)
        let down = 1 / up
        let harmonics = HeartRegister.harmonics
        for i in 0..<frameCount {
            droneLevel += (droneTarget - droneLevel) * levelCoef
            callGain += (callGainTarget - callGain) * gainCoef
            callFreq += (callFreqTarget - callFreq) * glideCoef
            // The bellows: one breath of the one clock.
            bellowsPhase += dt / BreathClock.breath
            if bellowsPhase >= 1 { bellowsPhase -= 1 }
            let bellows = 0.78 + 0.22 * (1 - cos(2 * .pi * bellowsPhase)) / 2

            var drone = 0.0
            if droneLevel > 0.00002 {
                for (v, ratio) in HeartRegister.droneRatios.enumerated() {
                    let base = sa * ratio
                    var voice = 0.0
                    for (h, amp) in harmonics.enumerated() {
                        let f = base * Double(h + 1)
                        guard f < sr * 0.45 else { continue }
                        for reed in 0..<2 {
                            let k = h * 2 + reed
                            dronePhases[v][k] += f * (reed == 0 ? up : down) * dt
                            if dronePhases[v][k] >= 1 { dronePhases[v][k] -= 1 }
                            voice += sin(2 * .pi * dronePhases[v][k]) * amp * 0.5
                        }
                    }
                    drone += voice * HeartRegister.droneGains[v]
                }
            }

            var call = 0.0
            if callGain > 0.00002 {
                vibratoPhase += 5.4 * dt
                if vibratoPhase >= 1 { vibratoPhase -= 1 }
                let f = callFreq * (1 + 0.006 * sin(2 * .pi * vibratoPhase))
                callPhase += f * dt
                if callPhase >= 1 { callPhase -= 1 }
                let p = 2 * .pi * callPhase
                // A sung tone: the fundamental, a soft second and third.
                call = (sin(p) + 0.35 * sin(2 * p) + 0.12 * sin(3 * p)) * callGain
            }

            let out = drone * droneLevel * bellows * 0.06 + call * 0.12
            samples[i] = Float(max(-1, min(1, out)))
        }
    }
}

/// The engine: his drone, the call, the silence for his answer.
final class HeartRegisterEngine {

    private let sampleRate: Double = 44_100
    private var engine: AVAudioEngine?
    private var state: HeartRenderState?
    private var schedule: Task<Void, Never>?

    @MainActor private(set) var sounding = false

    /// Begin the drone on his Sa; with `calling`, the call-and-response too.
    @MainActor
    func start(saHz: Double, calling: Bool) {
        stop()
        do {
            let session = AVAudioSession.sharedInstance()
            // `.ambient` already mixes; `.mixWithOthers` with it throws (see
            // `HomeVoiceTests`), and the graph would never sound.
            try session.setCategory(.ambient, mode: .default)
            try session.setActive(true)
        } catch {
            heartLog.error("Heart register session: \(error.localizedDescription, privacy: .public)")
        }
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }
        let engine = AVAudioEngine()
        let state = HeartRenderState(sampleRate: sampleRate, sa: saHz)
        let source = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let list = UnsafeMutableAudioBufferListPointer(abl)
            for buffer in list {
                let samples = UnsafeMutableBufferPointer<Float>(
                    start: buffer.mData?.assumingMemoryBound(to: Float.self),
                    count: Int(frameCount))
                state.render(into: samples, frameCount: Int(frameCount))
                break
            }
            return noErr
        }
        _ = engine.mainMixerNode
        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: format)
        do {
            try engine.start()
        } catch {
            heartLog.error("Heart register could not start: \(error.localizedDescription, privacy: .public)")
            return
        }
        self.engine = engine
        self.state = state
        state.droneTarget = 1
        sounding = true
        if calling { beginCalling(sa: saHz) }
    }

    @MainActor
    func setSa(_ hz: Double) {
        state?.sa = hz
    }

    /// The call, then a breath of silence for his answer, round and round.
    @MainActor
    private func beginCalling(sa: Double) {
        schedule?.cancel()
        schedule = Task { @MainActor [weak self] in
            var n = 0
            while !Task.isCancelled {
                guard let self, let state = self.state else { return }
                let phrase = HeartRegister.phrases[n % HeartRegister.phrases.count]
                n += 1
                for step in phrase {
                    if Task.isCancelled { return }
                    state.callFreqTarget = HeartRegister.hz(sa: state.sa, semitones: step)
                    state.callGainTarget = 1
                    try? await Task.sleep(for: .seconds(HeartRegister.noteSeconds))
                }
                state.callGainTarget = 0
                // His turn: the drone holds, the call is silent.
                try? await Task.sleep(for: .seconds(HeartRegister.answerSeconds))
            }
        }
    }

    @MainActor
    func setCalling(_ on: Bool) {
        if on {
            if let sa = state?.sa { beginCalling(sa: sa) }
        } else {
            schedule?.cancel()
            schedule = nil
            state?.callGainTarget = 0
        }
    }

    /// Everything stops, here — the one place that started it.
    @MainActor
    func stop() {
        schedule?.cancel()
        schedule = nil
        engine?.stop()
        engine = nil
        state = nil
        sounding = false
    }
}
