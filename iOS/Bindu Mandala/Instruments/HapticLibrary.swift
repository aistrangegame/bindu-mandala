import Foundation
import CoreHaptics
import UIKit

// MARK: - U1 · D · the haptics library
//
// `waves/upgrade/worlds/sound.md` §1.10 and §2 S78 (the library), S53 (the
// pulse 60 bpm from Shadow to the Reveal), S71 (the body rooms' element
// grammars), S36 (Ring 7's breath); `the-33-architecture.md` §2 rows 31 (the
// hold's feel), 66 and 70 (the dance's haptics); `score-format-v2.md` §3.19.
//
// *"There is one Core Haptics library on the conductor's clock. It is warm,
// never sharp."* Sharpness stays ≤ 0.3 unless a pattern is named otherwise
// (S78: tick and word .4, completion .5).
//
// The web wrote its haptics as `navigator.vibrate` millisecond arrays — on,
// off, on, off. `HapticPattern.vibration` turns one into Core Haptics events
// (S78: "Web ms arrays convert to CHHapticEvent transients/continuous
// segments"): a pulse shorter than 30 ms is a transient, a longer one a
// continuous segment of its own length.
//
// Where the hardware has no Core Haptics, every transient falls back to a
// `UIImpactFeedbackGenerator` (the app's existing way, `Theme/Haptics.swift`).
// `Theme/Haptics.swift` is left as it is in U1; U2 routes its callers here.

/// One haptic event: a tap (transient) or a held vibration (continuous)
/// (sound.md S78: "Web ms arrays convert to CHHapticEvent transients/continuous
/// segments").
struct HapticEvent: Equatable {
    enum Kind: Equatable {
        case transient
        case continuous
    }
    let kind: Kind
    /// Seconds from the pattern's start.
    let time: TimeInterval
    /// Seconds; 0 for a transient.
    let duration: TimeInterval
    /// 0…1.
    let intensity: Double
    /// 0…1. Warm is low.
    let sharpness: Double

    static func transient(at time: TimeInterval = 0, intensity: Double, sharpness: Double) -> HapticEvent {
        HapticEvent(kind: .transient, time: time, duration: 0, intensity: intensity, sharpness: sharpness)
    }

    static func continuous(at time: TimeInterval = 0, for duration: TimeInterval,
                           intensity: Double, sharpness: Double) -> HapticEvent {
        HapticEvent(kind: .continuous, time: time, duration: duration, intensity: intensity, sharpness: sharpness)
    }
}

/// A named haptic pattern — sound.md S78's library as data. Pure, so a test
/// reads every number without hardware.
struct HapticPattern: Equatable {
    let name: String
    let events: [HapticEvent]
    /// For a pulse (a heartbeat): the period it repeats on. nil = plays once.
    let period: TimeInterval?

    init(name: String, events: [HapticEvent], period: TimeInterval? = nil) {
        self.name = name
        self.events = events
        self.period = period
    }

    /// The pattern's length in seconds.
    var duration: TimeInterval { events.map { $0.time + $0.duration }.max() ?? 0 }

    /// Beats per minute, for a pulse.
    var bpm: Double? { period.map { 60 / $0 } }

    /// A pulse shorter than this (ms) is felt as a tap.
    static let transientBelowMs: Double = 30

    /// The web's vibrate array as Core Haptics events: even entries vibrate,
    /// odd entries rest (ms). `intensity` / `sharpness` are the defaults the
    /// web could not say (a vibrate array has no strength); 0.6 / 0.3 stays
    /// warm (S78 "warm, never sharp").
    static func vibration(_ name: String, ms: [Double], intensity: Double = 0.6,
                          sharpness: Double = 0.3, period: TimeInterval? = nil) -> HapticPattern {
        var events: [HapticEvent] = []
        var t = 0.0
        for (i, raw) in ms.enumerated() {
            let d = max(0, raw) / 1000
            if i % 2 == 0, raw > 0 {
                if raw < transientBelowMs {
                    events.append(.transient(at: t, intensity: intensity, sharpness: sharpness))
                } else {
                    events.append(.continuous(at: t, for: d, intensity: intensity, sharpness: sharpness))
                }
            }
            t += d
        }
        return HapticPattern(name: name, events: events, period: period)
    }

    /// One felt beat repeated at `bpm`.
    static func pulse(_ name: String, bpm: Double, intensity: Double, sharpness: Double,
                      lengthMs: Double? = nil) -> HapticPattern {
        let beat: HapticEvent
        if let ms = lengthMs, ms >= transientBelowMs {
            beat = .continuous(for: ms / 1000, intensity: intensity, sharpness: sharpness)
        } else {
            beat = .transient(intensity: intensity, sharpness: sharpness)
        }
        return HapticPattern(name: name, events: [beat], period: 60 / max(1, bpm))
    }

    /// The same pattern at `k` × its intensity (a hit's strength, a bell's).
    func scaled(_ k: Double) -> HapticPattern {
        let f = max(0, k)
        return HapticPattern(name: name, events: events.map {
            HapticEvent(kind: $0.kind, time: $0.time, duration: $0.duration,
                        intensity: min(1, $0.intensity * f), sharpness: $0.sharpness)
        }, period: period)
    }
}

// MARK: - The library (sound.md S78, S53, S71, S36)

extension HapticPattern {

    // Gestures (S78: "tick .3/.4; word .3/.4; heart .5/.3; … completion .8/.5;
    // Descent .9/.15 at 55%; kindle .6/.2; Still Point .25 → .15 → none").

    /// A tick — and the press of a hold (G0 "a tick at press").
    static let tick = HapticPattern(name: "tick", events: [.transient(intensity: 0.3, sharpness: 0.4)])
    /// A word arriving.
    static let word = HapticPattern(name: "word", events: [.transient(intensity: 0.3, sharpness: 0.4)])
    /// A heart.
    static let heart = HapticPattern(name: "heart", events: [.transient(intensity: 0.5, sharpness: 0.3)])
    /// Completion — the one latch when a hold reaches full (G0 "one latch at
    /// completion").
    static let completion = HapticPattern(name: "completion", events: [.transient(intensity: 0.8, sharpness: 0.5)])
    /// The peak at every Recognition (S78 "a peak haptic at every Recognition";
    /// the-33 row 70 "missing peak haptic is a smell") — felt as completion.
    static let recognition = HapticPattern(name: "recognition", events: [.transient(intensity: 0.8, sharpness: 0.5)])
    /// Kindle.
    static let kindle = HapticPattern(name: "kindle", events: [.transient(intensity: 0.6, sharpness: 0.2)])

    /// The Descent's floor giving way: .9 / .15 at 55 % of the passage
    /// (G14's passage is 2.35 s).
    static func descent(passage: TimeInterval = 2.35) -> HapticPattern {
        HapticPattern(name: "descent", events: [.transient(at: passage * 0.55, intensity: 0.9, sharpness: 0.15)])
    }

    /// The Still Point's seven stages recede: .25 → .15 → nothing ("The reward
    /// for depth is quiet."). Stage 0, 1, then nil from 2 on.
    static func stillPoint(stage: Int) -> HapticPattern? {
        switch stage {
        case ...0: return HapticPattern(name: "stillPoint", events: [.transient(intensity: 0.25, sharpness: 0.2)])
        case 1: return HapticPattern(name: "stillPoint", events: [.transient(intensity: 0.15, sharpness: 0.2)])
        default: return nil
        }
    }

    // Panels (S78: gate 80 ms, continue 40, pivot 50; D19 press start 12 ms,
    // complete 20-40-30, none on tap-to-advance).

    static let panelGate = vibration("panelGate", ms: [80])
    static let panelContinue = vibration("panelContinue", ms: [40])
    static let panelPivot = vibration("panelPivot", ms: [50])
    static let pressStart = vibration("pressStart", ms: [12])
    static let pressComplete = vibration("pressComplete", ms: [20, 40, 30])

    // The Scores' set (S78; score-format-v2 §3.19 — cross's own arrays).

    /// Crossing — footsteps crossing the threshold
    /// (cross `haptics.patterns.crossing_peak`).
    static let crossing = vibration("crossing", ms: [12, 40, 12, 40, 12, 60, 30, 12, 40])
    /// A bell, × the hit's intensity.
    static let bell = vibration("bell", ms: [20, 30, 40, 30, 20])
    /// A mirror word's flash.
    static let mirror = vibration("mirror", ms: [8])
    /// The strike.
    static let strike = vibration("strike", ms: [8, 20, 8, 400])
    /// The thunder roll.
    static let thunderRoll = vibration("thunderRoll", ms: [30, 40, 50, 40, 30])
    /// Charge — [25] at 46 bpm.
    static let charge = pulse("charge", bpm: 46, intensity: 0.6, sharpness: 0.3)

    /// The heartbeat: the pulse from Shadow (room 9) to the Reveal (room 32)
    /// — 60 bpm, transient intensity .35, sharpness .15, under the palm
    /// (S53). Never explained.
    static let heartbeat = pulse("heartbeat", bpm: 60, intensity: 0.35, sharpness: 0.15)
    /// The long-silence heart: 50 bpm in the longest silence (the fulcrum,
    /// [30] at 50 bpm; score-format §3.18 `t5_closing.longest_silence_heartbeat`).
    static let longSilenceHeart = pulse("longSilenceHeart", bpm: 50, intensity: 0.6, sharpness: 0.3, lengthMs: 30)
    /// Ring 7's breath: a continuous .12 / .1 swelling on each 15 s breath (S36).
    static let ringSevenBreath = HapticPattern(name: "ringSevenBreath",
                                               events: [.continuous(for: 7.5, intensity: 0.12, sharpness: 0.1)],
                                               period: 15)

    /// A hit from the song's onsets: `i · 20` ms when `i > .4`; nothing below
    /// (the-33 row 70; S62).
    static func hit(intensity i: Double) -> HapticPattern? {
        guard i > 0.4 else { return nil }
        return vibration("hit", ms: [i * 20], intensity: min(1, i))
    }

    /// A drop: 100 ms (the-33 row 70).
    static let drop = vibration("drop", ms: [100])

    // The body rooms' element grammars (S71, `06-chakra-skills.md:1732-1741`).

    /// EARTH "da-DUM war drum": [i·30, 40, i·50].
    static func earth(intensity i: Double) -> HapticPattern {
        vibration("earth", ms: [i * 30, 40, i * 50], intensity: min(1, max(0.1, i)))
    }
    static let fireCrackle = vibration("fireCrackle", ms: [15, 5, 15, 5, 20, 5, 15])
    static let fireBackdraft = vibration("fireBackdraft", ms: [40, 10, 40, 10, 40, 10, 40, 10, 60])
    /// HEART "thub-THUB", three strengths.
    static let heartThub = [
        vibration("heartThub", ms: [25, 80, 50]),
        vibration("heartThub", ms: [18, 90, 35]),
        vibration("heartThub", ms: [12, 100, 25]),
    ]
    static let heartGasp = vibration("heartGasp", ms: [15, 30, 15, 30, 15, 50, 40, 15, 30])
    static let heartAmbient = vibration("heartAmbient", ms: [8, 60, 15])
    static let throatSustained = vibration("throatSustained", ms: [15, 40, 12, 50, 10, 60, 8])
    /// Below .3 "the whisper doesn't vibrate the body"; the silence's own
    /// trace is [4].
    static let silence = vibration("silence", ms: [4])

    /// Every fixed pattern, for the warmth check and the library's listing.
    static var library: [HapticPattern] {
        var all: [HapticPattern] = [tick, word, heart, completion, recognition, kindle, descent()]
        all.append(contentsOf: [panelGate, panelContinue, panelPivot, pressStart, pressComplete])
        all.append(contentsOf: [crossing, bell, mirror, strike, thunderRoll, charge])
        all.append(contentsOf: [heartbeat, longSilenceHeart, ringSevenBreath, drop])
        all.append(contentsOf: [earth(intensity: 1), fireCrackle, fireBackdraft, heartGasp])
        all.append(contentsOf: [heartAmbient, throatSustained, silence])
        all.append(contentsOf: heartThub)
        if let s = stillPoint(stage: 0) { all.append(s) }
        if let s = stillPoint(stage: 1) { all.append(s) }
        return all
    }

    /// The patterns S78 names as sharper than warm, with their ceiling.
    static let namedSharpness: [String: Double] = ["tick": 0.4, "word": 0.4, "completion": 0.5, "recognition": 0.5]
    /// "warm, never sharp (sharpness ≤ .3 unless named)".
    static let warmCeiling: Double = 0.3
}

// MARK: - The engine

/// Plays the library on Core Haptics (UIKit impact fallback). One owner; the
/// hold engine, the Score player and every world call in.
///
/// Silent in the unit-test host, and silent when he has switched haptics off
/// (the Sound sheet's switch, sound.md §1.3 / S78 "respects system haptics and
/// the Sound sheet switch") — a step is never lost by it (§1.11).
@MainActor
final class HapticLibrary {

    static let shared = HapticLibrary()

    /// The Sound sheet's haptics switch (a per-device convenience).
    static let enabledKey = "instruments.haptics.enabled"

    var isEnabled: Bool {
        get { UserDefaults.standard.object(forKey: Self.enabledKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Self.enabledKey) }
    }

    /// Whether this device plays Core Haptics (else the UIKit fallback).
    let hasCoreHaptics: Bool

    private var engine: CHHapticEngine?
    private var hold: CHHapticAdvancedPatternPlayer?
    private var pulses: [String: CHHapticAdvancedPatternPlayer] = [:]
    private var fallbackPulses: [String: Task<Void, Never>] = [:]

    private var silent: Bool { AppRuntime.isUnitTesting || !isEnabled }

    private init() {
        hasCoreHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    // MARK: Patterns

    /// Play a pattern once (a pulse plays one beat; use `startPulse`).
    func play(_ pattern: HapticPattern, scale: Double = 1) {
        guard !silent else { return }
        let p = scale == 1 ? pattern : pattern.scaled(scale)
        if hasCoreHaptics, let engine = ready(), let chp = Self.coreHapticPattern(p) {
            do {
                let player = try engine.makePlayer(with: chp)
                try player.start(atTime: CHHapticTimeImmediate)
            } catch {
                fallback(p)
            }
        } else {
            fallback(p)
        }
    }

    /// Begin a repeating pulse (the heartbeat, the long-silence heart, Ring 7's
    /// breath). Starting the same name again restarts it.
    func startPulse(_ pattern: HapticPattern) {
        guard !silent, let period = pattern.period, period > 0 else { return }
        stopPulse(named: pattern.name)
        if hasCoreHaptics, let engine = ready(), let chp = Self.coreHapticPattern(pattern) {
            do {
                let player = try engine.makeAdvancedPlayer(with: chp)
                player.loopEnabled = true
                player.loopEnd = period
                try player.start(atTime: CHHapticTimeImmediate)
                pulses[pattern.name] = player
                return
            } catch {}
        }
        fallbackPulses[pattern.name] = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                self?.fallback(pattern)
                try? await Task.sleep(for: .seconds(period))
            }
        }
    }

    func stopPulse(named name: String) {
        if let p = pulses.removeValue(forKey: name) { try? p.stop(atTime: CHHapticTimeImmediate) }
        fallbackPulses.removeValue(forKey: name)?.cancel()
    }

    func stopAllPulses() {
        for name in Array(pulses.keys) + Array(fallbackPulses.keys) { stopPulse(named: name) }
    }

    // MARK: The hold's feel (G0: tick at press; ramp .15 → .6 at ≈ .3; one
    // latch at completion; nothing on early release)

    func holdPressed() {
        guard !silent else { return }
        play(.tick)
        guard hasCoreHaptics, let engine = ready() else { return }
        // One long continuous event at full strength; its felt strength is
        // steered by the intensity control (0.15 → 0.6).
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(HoldLadder.rampSharpness)),
        ], relativeTime: 0, duration: 30)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makeAdvancedPlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hold = player
            holdProgress(0)
        } catch {
            hold = nil
        }
    }

    func holdProgress(_ p: Double) {
        guard let hold else { return }
        let control = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                               value: Float(HoldLadder.rampIntensity(at: p)),
                                               relativeTime: 0)
        try? hold.sendParameters([control], atTime: CHHapticTimeImmediate)
    }

    /// The ramp stops — on the commit (followed by the latch) or on an early
    /// release (followed by nothing).
    func holdEnded() {
        if let hold { try? hold.stop(atTime: CHHapticTimeImmediate) }
        hold = nil
    }

    func holdLatched() {
        holdEnded()
        play(.completion)
    }

    // MARK: Core Haptics

    private func ready() -> CHHapticEngine? {
        if let engine {
            try? engine.start()
            return engine
        }
        do {
            let e = try CHHapticEngine()
            e.isAutoShutdownEnabled = true
            e.resetHandler = { [weak e] in try? e?.start() }
            try e.start()
            engine = e
            return e
        } catch {
            return nil
        }
    }

    /// The pattern as Core Haptics events. nil if it holds nothing.
    static func coreHapticPattern(_ p: HapticPattern) -> CHHapticPattern? {
        guard !p.events.isEmpty else { return nil }
        let events: [CHHapticEvent] = p.events.map { e in
            let params = [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(e.intensity)),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(e.sharpness)),
            ]
            switch e.kind {
            case .transient:
                return CHHapticEvent(eventType: .hapticTransient, parameters: params, relativeTime: e.time)
            case .continuous:
                return CHHapticEvent(eventType: .hapticContinuous, parameters: params,
                                     relativeTime: e.time, duration: e.duration)
            }
        }
        return try? CHHapticPattern(events: events, parameters: [])
    }

    // MARK: UIKit fallback

    /// Each event as one impact at its moment: soft below .7, medium above
    /// (the hold's latch is "medium impact native", G0).
    private func fallback(_ p: HapticPattern) {
        for e in p.events {
            let style: UIImpactFeedbackGenerator.FeedbackStyle = e.intensity >= 0.7 ? .medium : .soft
            let strength = CGFloat(min(1, max(0.05, e.intensity)))
            if e.time <= 0 {
                UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: strength)
            } else {
                let wait = e.time
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(wait))
                    UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: strength)
                }
            }
        }
    }
}
