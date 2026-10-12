import AVFoundation
import Foundation

// MARK: - GlissandoVoice — one glide, then let go (Wave 2)

/// A single sine (with a soft octave above it for warmth) gliding
/// exponentially from one pitch to another over a fixed length, under a
/// rise-and-fall envelope. Built for one glide by
/// ``RingAudioService/glide(fromHz:toHz:seconds:)``, and detached once it has
/// sounded — the descent into her mark heard as falling (``Glissando``).
@MainActor
final class GlissandoVoice {
    private weak var engine: AVAudioEngine?
    private let sourceNode: AVAudioSourceNode
    private let mixer: AVAudioMixerNode
    private let state: GlissandoState
    private let length: TimeInterval

    init(engine: AVAudioEngine, sampleRate: Double,
         from: Double, to: Double, seconds: TimeInterval) {
        let length = max(0.1, seconds)
        self.engine = engine
        self.length = length

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let mixer = AVAudioMixerNode()
        self.mixer = mixer

        let state = GlissandoState()
        state.from = max(20, from)
        state.to = max(20, to)
        state.total = max(1, Int(length * sampleRate))
        self.state = state

        let sr = sampleRate
        self.sourceNode = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let bufferList = UnsafeMutableAudioBufferListPointer(abl)
            guard let firstBuf = bufferList.first else { return noErr }
            let samples = UnsafeMutableBufferPointer<Float>(
                start: firstBuf.mData?.assumingMemoryBound(to: Float.self),
                count: Int(frameCount)
            )
            let ratio = state.to / state.from
            for i in 0..<Int(frameCount) {
                guard state.running, state.elapsed < state.total else {
                    samples[i] = 0
                    continue
                }
                let k = Double(state.elapsed) / Double(state.total)
                let f = state.from * pow(ratio, k)
                state.phase += f / sr
                if state.phase > 1 { state.phase -= 1 }
                state.octave += 2 * f / sr
                if state.octave > 1 { state.octave -= 1 }
                // Rise over the first eighth, fall away over the rest.
                let env: Double = k < 0.125 ? k / 0.125 : pow(1 - (k - 0.125) / 0.875, 1.6)
                let s = sin(state.phase * 2 * .pi) + 0.22 * sin(state.octave * 2 * .pi)
                samples[i] = Float(s * env * 0.05)
                state.elapsed += 1
            }
            return noErr
        }

        engine.attach(self.sourceNode)
        engine.attach(self.mixer)
        engine.connect(self.sourceNode, to: self.mixer, format: format)
        engine.connect(self.mixer, to: engine.mainMixerNode, format: format)
    }

    /// Sound the glide, and let the voice go once it has.
    func start() {
        state.running = true
        let hold = length + 0.4
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(hold))
            self.state.running = false
            self.engine?.disconnectNodeOutput(self.sourceNode)
            self.engine?.disconnectNodeOutput(self.mixer)
            self.engine?.detach(self.sourceNode)
            self.engine?.detach(self.mixer)
        }
    }
}

/// Boxed render-block state, as ``VoiceState`` is.
final class GlissandoState {
    var from: Double = 220
    var to: Double = 110
    var total: Int = 1
    var elapsed: Int = 0
    var phase: Double = 0
    var octave: Double = 0
    var running = false
}
