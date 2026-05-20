import AVFoundation

/// Plays a pure sine tone for one of the 16 bīja syllables.
/// Each position gets a distinct frequency along a meditative scale anchored at
/// 174 Hz (the lowest Solfeggio frequency — "foundation"). Whole-tone steps
/// upward from there give 16 distinct, harmonically related tones.
///
/// This is the Phase 5 implementation — Phase 6+ plan is to ship recorded
/// human-voice samples (`bija_01.mp3` …) and prefer them when present.
@MainActor
final class BijaSoundService {
    static let shared = BijaSoundService()

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var configured = false

    private init() {}

    func play(forPosition position: Int, duration: TimeInterval = 1.6) {
        let baseFreq: Double = 174.0
        // Whole-tone scale steps (2 semitones each) — keeps every interval
        // consonant and avoids accidental minor seconds.
        let semitones = Double(position - 1) * 2
        let freq = baseFreq * pow(2.0, semitones / 12.0)
        play(frequency: freq, duration: duration)
    }

    func play(frequency: Double, duration: TimeInterval) {
        do {
            try configureIfNeeded()
            let sampleRate: Double = 44_100
            let frameCount = AVAudioFrameCount(sampleRate * duration)
            let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
            buffer.frameLength = frameCount

            let channel = buffer.floatChannelData![0]
            let twoPi = 2.0 * Double.pi
            let fadeFrames = Int(sampleRate * 0.06) // 60ms attack/release to avoid clicks
            for i in 0..<Int(frameCount) {
                let t = Double(i) / sampleRate
                var sample = sin(twoPi * frequency * t)
                // Linear fade in / out
                if i < fadeFrames {
                    sample *= Double(i) / Double(fadeFrames)
                } else if i > Int(frameCount) - fadeFrames {
                    sample *= Double(Int(frameCount) - i) / Double(fadeFrames)
                }
                channel[i] = Float(sample * 0.28) // gentle volume
            }

            if player.isPlaying { player.stop() }
            player.scheduleBuffer(buffer, at: nil, options: [.interrupts])
            if !engine.isRunning {
                try engine.start()
            }
            player.play()
        } catch {
            // Silent — bīja sound is a delight, not a guarantee.
        }
    }

    private func configureIfNeeded() throws {
        guard !configured else { return }
        let session = AVAudioSession.sharedInstance()
        // .ambient so it mixes with anything else playing and respects mute switch.
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)

        engine.attach(player)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        try engine.start()
        configured = true
    }
}
