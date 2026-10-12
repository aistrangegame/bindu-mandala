import Foundation

// MARK: - Wave 2 · the field's voices, wired at last
//
// `RingAudioService` was written for the nine Ring Worlds and kept, after July
// cut them, as "the carrier for the Homes" — and then six of its voices had no
// caller anywhere: the ground drone, the home breath, the sustained breathy
// voice, the stepped notes, the triad and the Shepard tone. The Reading's §3
// row *"Sound restraint"* lifts the silence they were left in: *"Wire the ring
// voices into the climb and the Mandala."*
//
// This is the conductor: each place says where it stands, and the voice of
// that place sounds. The climb crossfades two worlds' voices on its own blend
// weights (the same numbers its fog and light are blended on); the Mandala
// sounds the enclosure the glass has fallen into. Existing pitches keep their
// character (rupakarshini law 10); the two new voices take 136.1 Hz, the
// worlds' and the point's own pitch.
//
// | ring | voice                    | pitch                         |
// |------|--------------------------|-------------------------------|
// | 0    | the point                | 136.1 + Design's fifth 204.15 |
// | 1    | ground drone             | 73.42 + 110 (existing)        |
// | 2    | home breath              | 130.81 + 196 (existing)       |
// | 3    | sustained breathy voice  | 116.5 (existing)              |
// | 4, 5 | stepped notes            | Design's roots ×2, 1 · 9/8 · 5/4 · 3/2 |
// | 6    | sustained breathy voice  | 207.65 (Design's Ring 6)      |
// | 7    | the witness, sourceless  | 136.1's 2nd, 3rd, 5th partials |
// | 8    | triad, gliding into one  | 261.63 · 311.13 · 392 (existing) |
// | 9    | Shepard tone             | 32.7 Hz × 7 octaves (existing) |
//
// Nothing here is structural: no place decides anything by sound, and a muted
// phone loses exactly the sound. The silent switch is honoured
// (`RingAudioService.honourSilentSwitch`).

@MainActor
final class RingFieldVoice {

    static let shared = RingFieldVoice()

    /// Every voice the field can carry, and how loud each stands now, 0…1.
    private(set) var levels: [Int: Double] = [:]
    private var steppers: [Int: Task<Void, Never>] = [:]
    private var falling: Task<Void, Never>?

    /// No sound in a unit-test host: the suites ask what a place decides.
    private var allowed: Bool { !AppRuntime.isUnitTesting }

    private init() {}

    // MARK: - Where each place stands, as levels (pure)

    /// The climb at a height: the two worlds he is between, on the climb's own
    /// weights.
    nonisolated static func want(climbFraction f: Double) -> [Int: Double] {
        var out: [Int: Double] = [:]
        for entry in WorldClimb.weights(atFraction: f) where entry.weight > 0 {
            out[entry.ring] = entry.weight
        }
        return out
    }

    /// The Mandala: the enclosure the glass has fallen into, or the point
    /// itself (`0`) while he holds the whole instrument in view.
    nonisolated static func want(enteredRing ring: Int) -> [Int: Double] {
        [max(0, min(9, ring)): 1]
    }

    /// Design's stepped-note pitches for rings 4 and 5: its own roots
    /// (`homes-sound.js`), an octave up so a phone can carry them.
    nonisolated static func steppedRoot(ring: Int) -> Double? {
        switch ring {
        case 4: return 73.42 * 2
        case 5: return 82.41 * 2
        default: return nil
        }
    }

    /// Design's step period: ring 4 the slower of the two.
    nonisolated static func stepPeriod(ring: Int) -> TimeInterval { ring == 4 ? 5.2 : 3.4 }

    nonisolated static let steps: [Double] = [1, 9.0 / 8.0, 5.0 / 4.0, 3.0 / 2.0]

    // MARK: - Sounding

    /// Sound exactly these voices at these levels, and let every other go.
    func sound(_ want: [Int: Double]) {
        guard allowed else { levels = want; return }
        let audio = RingAudioService.shared
        let threshold = 0.02
        // The sustained voice is one slot shared by rings 3 and 6, which are
        // never neighbours — if both are asked for, the louder wins.
        let sustainedRing: Int? = {
            let three = want[3] ?? 0, six = want[6] ?? 0
            if max(three, six) <= threshold { return nil }
            return three >= six ? 3 : 6
        }()
        let previousSustained: Int? = {
            let three = levels[3] ?? 0, six = levels[6] ?? 0
            if max(three, six) <= threshold { return nil }
            return three >= six ? 3 : 6
        }()

        for ring in 0...9 {
            let level = want[ring] ?? 0
            let on = level > threshold
            let was = (levels[ring] ?? 0) > threshold
            switch ring {
            case 0:
                if on { audio.pointStart(); audio.pointGain(Float(0.035 * level)) }
                else if was { audio.pointStop() }
            case 1:
                if on { audio.groundDroneStart(); audio.groundDroneGain(Float(0.05 * level)) }
                else if was { audio.groundDroneStop() }
            case 2:
                if on { audio.homeBreathStart(); audio.homeBreathGain(Float(0.045 * level)) }
                else if was { audio.homeBreathStop() }
            case 3, 6:
                break
            case 4, 5:
                if on { startStepping(ring) } else { stopStepping(ring) }
            case 7:
                if on { audio.sourcelessStart(); audio.sourcelessGain(Float(0.022 * level)) }
                else if was { audio.sourcelessStop() }
            case 8:
                if on { audio.r8Start(); audio.r8Gain(Float(0.06 * level)) }
                else if was { audio.r8Stop() }
            case 9:
                if on {
                    audio.shepardStart()
                    audio.shepardSet(intensity: 0.25 * level)
                } else if was, falling == nil {
                    audio.shepardStop()
                }
            default:
                break
            }
        }

        if sustainedRing != previousSustained, previousSustained != nil {
            audio.sustainedVoiceStop()
        }
        if let ring = sustainedRing {
            let level = want[ring] ?? 0
            let freq = ring == 3 ? 116.5 : 207.65
            let base: Float = ring == 3 ? 0.03 : 0.02
            if sustainedRing != previousSustained {
                audio.sustainedVoiceStart(freq: freq, vol: base * Float(level),
                                          vibrato: ring == 3 ? 2 : 3)
            } else {
                audio.sustainedVoiceGain(base * Float(level))
            }
        }
        levels = want
    }

    /// Let every voice go.
    func silence() {
        for ring in Array(steppers.keys) { stopStepping(ring) }
        falling?.cancel()
        falling = nil
        levels = [:]
        guard allowed else { return }
        RingAudioService.shared.stopAll()
    }

    /// Mauna: every voice goes quiet, and what was sounding is remembered.
    func hush() {
        let was = levels
        silence()
        remembered = was
    }

    /// Back from Mauna: the place sounds again as it did.
    func resume() {
        let want = remembered
        remembered = [:]
        guard !want.isEmpty else { return }
        sound(want)
    }

    private var remembered: [Int: Double] = [:]

    /// G17 · the centre bloom: the point's own 136.1 swells with the yantra
    /// drawn outward from it, and settles back as it dissolves.
    func bloom(_ e: Double) {
        guard allowed else { return }
        let audio = RingAudioService.shared
        let resting = 0.035 * (levels[0] ?? 0)
        if e > 0.01 {
            audio.pointStart()
            audio.pointGain(Float(max(resting, 0.07 * min(1, e))))
        } else if resting > 0 {
            audio.pointGain(Float(resting))
        } else {
            audio.pointStop()
        }
    }

    // MARK: - The mechanisms' sounds

    /// Ring 7 — the twelve-voice chord (Design's `strikeChord`).
    func chord() {
        guard allowed else { return }
        RingAudioService.shared.vakChord()
    }

    /// Ring 8 — three tones gliding into one while he holds, opening again as
    /// he lets go (Design's `r8Set('bindu' | 'triad')`).
    func unite(_ union: Double) {
        guard allowed else { return }
        RingAudioService.shared.r8Set(union > 0.5 ? .bindu : .triad)
    }

    /// Ring 9 — the Shepard fall: an endless descent, at an intensity that
    /// follows the fall's speed (``Pravesha/shepard(speed:)``).
    func fall(intensity: Double) {
        guard allowed else { return }
        RingAudioService.shared.shepardStart()
        RingAudioService.shared.shepardSet(intensity: intensity)
    }

    /// The Shepard fall, once, through the point — the Mandala's fall into the
    /// Bindu: it swells as the glass falls and lets go as Lalitā arrives.
    func fallThrough(seconds: TimeInterval = 3.2) {
        guard allowed else { return }
        falling?.cancel()
        let audio = RingAudioService.shared
        audio.shepardStart()
        falling = Task { @MainActor [weak self] in
            let steps = 32
            for i in 0...steps {
                if Task.isCancelled { return }
                let k = Double(i) / Double(steps)
                // Rise fast, fall away slowly.
                let intensity = k < 0.25 ? k / 0.25 : 1 - (k - 0.25) / 0.75
                audio.shepardSet(intensity: max(0, intensity))
                try? await Task.sleep(for: .seconds(seconds / Double(steps)))
            }
            if (self?.levels[9] ?? 0) <= 0.02 { audio.shepardStop() }
            self?.falling = nil
        }
    }

    /// Let the fall go now.
    func stopFalling() {
        falling?.cancel()
        falling = nil
        guard allowed else { return }
        if (levels[9] ?? 0) <= 0.02 { RingAudioService.shared.shepardStop() }
    }

    // MARK: - Rings 4 and 5 step

    private func startStepping(_ ring: Int) {
        guard steppers[ring] == nil, let root = Self.steppedRoot(ring: ring) else { return }
        let period = Self.stepPeriod(ring: ring)
        steppers[ring] = Task { @MainActor [weak self] in
            var k = 0
            while !Task.isCancelled {
                let level = self?.levels[ring] ?? 0
                if level > 0.02 {
                    RingAudioService.shared.playSteppedNote(
                        freq: root * RingFieldVoice.steps[k % RingFieldVoice.steps.count],
                        duration: 2.2,
                        volume: Float(0.06 * level))
                }
                k += 1
                try? await Task.sleep(for: .seconds(period))
            }
        }
    }

    private func stopStepping(_ ring: Int) {
        steppers[ring]?.cancel()
        steppers[ring] = nil
    }
}
