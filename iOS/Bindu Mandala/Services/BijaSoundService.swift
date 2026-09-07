import AVFoundation

/// Sounds a Śakti's bīja for any of the 102 seats.
///
/// A bundled human-voice recording wins when present — `bija_%02d` keyed by
/// `khadgamalaPosition` (1–102), so `bija_29` … `bija_44` are Ring 2. Until a
/// seat is recorded, playback falls through to synthesis: `playBija` derives a
/// soft pentatonic drone from her syllable (or from her position when she
/// carries none, as most of the 86 do), so no gesture is ever silent. The older
/// `play(forPosition:)` whole-tone sine (anchored at 174 Hz) remains as the
/// simplest fallback tone.
@MainActor
final class BijaSoundService {
    static let shared = BijaSoundService()

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var configured = false

    /// Recorded voice file player, retained so playback isn't cut short by ARC.
    private var voicePlayer: AVAudioPlayer?

    private init() {}

    func play(forPosition position: Int, duration: TimeInterval = 1.6) {
        // Prefer a recorded voice file when one is bundled. Naming convention:
        // bija_01 … bija_102 (zero-padded to two digits, keyed by khaḍgamālā
        // position; mp3 / m4a / wav). If the file is absent or playback fails,
        // fall through to the synthesized sine so the gesture is never silent.
        if playVoiceFile(forPosition: position) { return }

        let baseFreq: Double = 174.0
        // Whole-tone scale steps (2 semitones each) — keeps every interval
        // consonant and avoids accidental minor seconds.
        let semitones = Double(position - 1) * 2
        let freq = baseFreq * pow(2.0, semitones / 12.0)
        play(frequency: freq, duration: duration)
    }

    /// Returns true when a bundled voice file was found and playback started.
    /// Tries mp3 then m4a so either format can be dropped in later.
    private func playVoiceFile(forPosition position: Int) -> Bool {
        let name = String(format: "bija_%02d", position)
        let candidates: [String] = ["mp3", "m4a", "wav"]
        var url: URL?
        for ext in candidates {
            if let u = Bundle.main.url(forResource: name, withExtension: ext) {
                url = u
                break
            }
        }
        guard let url else { return false }
        do {
            try configureIfNeeded()
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.9
            player.prepareToPlay()
            voicePlayer = player
            return player.play()
        } catch {
            return false
        }
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

    /// Her seed-syllable's own tone: a soft drone (fundamental + fifth + octave)
    /// pitched deterministically from the syllable's characters onto a low
    /// pentatonic scale, so each syllable sounds like herself (ported from the
    /// prototype's `lrPlayBija`). When she carries no bīja (most of the 86), the
    /// tone is seeded off `seed` (her khaḍgamālā position) so it is still unique
    /// per Śakti — never the old per-ring collision.
    func playBija(_ bija: String, seed: Int, duration: TimeInterval = 3.2) {
        // A bundled human-voice sample (by unique position) still wins if present.
        if playVoiceFile(forPosition: seed) { return }
        let syllable = bija.trimmingCharacters(in: .whitespacesAndNewlines)
        // Low pentatonic register (~131–294 Hz) — a grounded, meditative drone.
        let scale: [Double] = [130.81, 146.83, 164.81, 196.00, 220.00, 246.94, 293.66]
        let source = syllable.isEmpty ? "kp\(seed)" : syllable
        var h = 2166136261
        for u in source.unicodeScalars { h = (h ^ Int(u.value)) &* 16777619 & 0x7fffffff }
        let freq = scale[h % scale.count]
        playDrone(frequency: freq, duration: duration)
    }

    /// A slow devotional drone — fundamental + a fifth + an octave, swelling in and
    /// out. Richer than the bare sine of `play(frequency:)`.
    private func playDrone(frequency: Double, duration: TimeInterval, volume: Double = 0.16) {
        do {
            try configureIfNeeded()
            let sampleRate: Double = 44_100
            let frameCount = AVAudioFrameCount(sampleRate * duration)
            let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
            buffer.frameLength = frameCount

            let channel = buffer.floatChannelData![0]
            let twoPi = 2.0 * Double.pi
            let total = Int(frameCount)
            let attack = Int(sampleRate * 0.55)
            let release = Int(sampleRate * 1.1)
            for i in 0..<total {
                let t = Double(i) / sampleRate
                var sample = sin(twoPi * frequency * t)
                sample += 0.6 * sin(twoPi * frequency * 1.5 * t)   // a fifth
                sample += 0.4 * sin(twoPi * frequency * 2.0 * t)   // an octave
                if i < attack {
                    sample *= Double(i) / Double(attack)
                } else if i > total - release {
                    sample *= Double(total - i) / Double(release)
                }
                channel[i] = Float(sample * volume / 2.0)
            }

            if player.isPlaying { player.stop() }
            player.scheduleBuffer(buffer, at: nil, options: [.interrupts])
            if !engine.isRunning { try engine.start() }
            player.play()
        } catch {
            // silent — the drone is a delight, not a guarantee
        }
    }

    // MARK: - Vāk Chamber (Ring 7)

    /// Plays a single Vāk-devatā bīja — fundamental sine + 2nd harmonic for warmth.
    /// Frequencies, duration, and volume per `Claude Designs/ring-worlds.jsx` `VAK_FREQS`.
    func playVakBija(frequency: Double,
                     duration: TimeInterval = 2.6,
                     volume: Double = 0.11) {
        do {
            try configureIfNeeded()
            let sampleRate: Double = 44_100
            let frameCount = AVAudioFrameCount(sampleRate * duration)
            let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
            buffer.frameLength = frameCount

            let channel = buffer.floatChannelData![0]
            let twoPi = 2.0 * Double.pi
            let totalFrames = Int(frameCount)
            let attackFrames = Int(sampleRate * 0.15)
            let releaseFrames = Int(sampleRate * 0.30)

            for i in 0..<totalFrames {
                let t = Double(i) / sampleRate
                var sample = sin(twoPi * frequency * t)
                sample += 0.25 * sin(twoPi * frequency * 2.0 * t)
                if i < attackFrames {
                    sample *= Double(i) / Double(attackFrames)
                } else if i > totalFrames - releaseFrames {
                    let remaining = totalFrames - i
                    sample *= Double(remaining) / Double(releaseFrames)
                }
                channel[i] = Float(sample * volume)
            }

            if player.isPlaying { player.stop() }
            player.scheduleBuffer(buffer, at: nil, options: [.interrupts])
            if !engine.isRunning { try engine.start() }
            player.play()
        } catch {
            // silent
        }
    }

    /// Plays all 8 Vāk bījas staggered 60ms apart as a single sustained chord.
    /// Mixed into one buffer so the entire phrase plays as a unit.
    func playVakChord(frequencies: [Double],
                      duration: TimeInterval = 3.0,
                      volume: Double = 0.06,
                      stagger: TimeInterval = 0.06) {
        guard !frequencies.isEmpty else { return }
        do {
            try configureIfNeeded()
            let sampleRate: Double = 44_100
            let totalDuration = stagger * Double(frequencies.count - 1) + duration
            let frameCount = AVAudioFrameCount(sampleRate * totalDuration)
            let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
            buffer.frameLength = frameCount

            let channel = buffer.floatChannelData![0]
            let twoPi = 2.0 * Double.pi
            let totalFrames = Int(frameCount)
            let attackFrames = Int(sampleRate * 0.20)
            let releaseFrames = Int(sampleRate * 0.30)
            let durationFrames = Int(sampleRate * duration)

            for i in 0..<totalFrames { channel[i] = 0 }

            for (voiceIdx, freq) in frequencies.enumerated() {
                let startFrame = Int(sampleRate * stagger * Double(voiceIdx))
                for relFrame in 0..<durationFrames {
                    let i = startFrame + relFrame
                    if i >= totalFrames { break }
                    let t = Double(relFrame) / sampleRate
                    var sample = sin(twoPi * freq * t)
                    sample += 0.25 * sin(twoPi * freq * 2.0 * t)
                    if relFrame < attackFrames {
                        sample *= Double(relFrame) / Double(attackFrames)
                    } else if relFrame > durationFrames - releaseFrames {
                        let remaining = durationFrames - relFrame
                        sample *= Double(remaining) / Double(releaseFrames)
                    }
                    channel[i] += Float(sample * volume)
                }
            }

            if player.isPlaying { player.stop() }
            player.scheduleBuffer(buffer, at: nil, options: [.interrupts])
            if !engine.isRunning { try engine.start() }
            player.play()
        } catch {
            // silent
        }
    }

    private func configureIfNeeded() throws {
        guard !configured else { return }
        let session = AVAudioSession.sharedInstance()
        // .playback so bīja tones play regardless of the silent switch — sacred sound
        // is the whole point of this app. .mixWithOthers preserves other audio apps.
        try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)

        engine.attach(player)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        try engine.start()
        configured = true
    }
}
