import SwiftUI
import UIKit
import AVFoundation
import CoreMotion

// MARK: - Wave 4 · the instruments play is felt through
//
// Touch with its pressure (TouchSense), the phone's posture and shake
// (LightBody), sound coupled to the gesture, and the hand's own haptic. Every
// game reads the same four, so a press means the same thing in the Drum as in
// the Door.

// MARK: TouchSense — the surface

/// One touch as the glass felt it.
struct TouchSample {
    let id: ObjectIdentifier
    let location: CGPoint
    /// 0 … 1, absorbed (`TouchSense.pressure`).
    let pressure: Double
    /// `UITouch.timestamp` — seconds of system uptime, the clock every game
    /// model runs on (`PlayClock.now`).
    let time: Double
}

/// The one clock play runs on: system uptime, the same one `UITouch` stamps.
enum PlayClock {
    static var now: Double { ProcessInfo.processInfo.systemUptime }
}

/// A transparent surface that reads every finger — where it is, how hard it
/// presses, how wide its pad is — and hands each one on. SwiftUI's gestures
/// cannot see force or pad size; this can.
struct TouchSenseSurface: UIViewRepresentable {
    var onBegan: (TouchSample) -> Void = { _ in }
    var onMoved: (TouchSample) -> Void = { _ in }
    var onEnded: (TouchSample) -> Void = { _ in }

    func makeUIView(context: Context) -> SenseView {
        let v = SenseView()
        v.isMultipleTouchEnabled = true
        v.backgroundColor = .clear
        v.isOpaque = false
        apply(to: v)
        return v
    }

    func updateUIView(_ uiView: SenseView, context: Context) {
        apply(to: uiView)
    }

    private func apply(to v: SenseView) {
        v.onBegan = onBegan
        v.onMoved = onMoved
        v.onEnded = onEnded
    }

    final class SenseView: UIView {
        var onBegan: ((TouchSample) -> Void)?
        var onMoved: ((TouchSample) -> Void)?
        var onEnded: ((TouchSample) -> Void)?

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { onBegan?(sample(t)) }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { onMoved?(sample(t)) }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { onEnded?(sample(t)) }
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { onEnded?(sample(t)) }
        }

        private func sample(_ t: UITouch) -> TouchSample {
            TouchSample(id: ObjectIdentifier(t),
                        location: t.location(in: self),
                        pressure: TouchSense.pressure(force: Double(t.force),
                                                      maximumForce: Double(t.maximumPossibleForce),
                                                      majorRadius: Double(t.majorRadius)),
                        time: t.timestamp)
        }
    }
}

// MARK: LightBody — posture and shake

/// The phone's body: which way gravity falls through it, and how hard it is
/// being shaken. Read by the game models on their own clock; nothing here
/// publishes, so a sixty-a-second stream never re-renders a view by itself.
/// Device motion needs no Info.plist key (only motion *fitness* does).
final class PlayMotion {
    private let manager = CMMotionManager()
    private(set) var gravityX: Double = 0
    private(set) var gravityY: Double = -1
    private(set) var gravityZ: Double = 0
    private(set) var shake: Double = 0

    var isAvailable: Bool { manager.isDeviceMotionAvailable }

    func start() {
        guard manager.isDeviceMotionAvailable, !manager.isDeviceMotionActive else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motion, _ in
            guard let self = self, let m = motion else { return }
            self.gravityX = m.gravity.x
            self.gravityY = m.gravity.y
            self.gravityZ = m.gravity.z
            let a = m.userAcceleration
            self.shake = sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
        }
    }

    func stop() {
        if manager.isDeviceMotionActive { manager.stopDeviceMotionUpdates() }
    }

    /// −1 … 1, tipped left … right.
    var roll: Double { LightBody.roll(gravityX: gravityX) }
}

// MARK: The hand

enum PlayHaptics {
    static func tap(_ intensity: Double = 0.5) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: CGFloat(min(max(intensity, 0.05), 1)))
    }

    static func thump(_ intensity: Double = 0.8) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: CGFloat(min(max(intensity, 0.05), 1)))
    }

    static func tick() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    /// Lub — dub.
    static func heartbeat(_ intensity: Double = 0.8) {
        thump(intensity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { PlayHaptics.tap(intensity * 0.7) }
    }

    /// The light answering — her moment arriving in the hand.
    static func bloom() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// MARK: The ear

/// Play's own voice. A small synthesiser on its own engine: struck tones on a
/// rotating set of voices, the earth thump, the heartbeat, and one looping
/// drone whose gain the game sets as it is played.
///
/// **The silent switch is honoured** (charter §3 law 5): the shared session
/// is `.ambient` while a game is open and given back as `.playback` — the
/// app's standing ruling — when it closes, the way `HomeSoundService` gives
/// the room's ruling back at the door.
final class PlaySound {
    static let shared = PlaySound()

    private let engine = AVAudioEngine()
    private var voices: [AVAudioPlayerNode] = []
    private var nextVoice = 0
    private let drone = AVAudioPlayerNode()
    private var built = false
    private var droneFrequency: Double = 0
    private let rate: Double = 44_100
    private lazy var format: AVAudioFormat? = AVAudioFormat(standardFormatWithSampleRate: rate, channels: 1)

    private init() {}

    func begin() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, mode: .default)
        try? session.setActive(true)
        build()
        if built, !engine.isRunning { try? engine.start() }
    }

    func end() {
        drone.stop()
        droneFrequency = 0
        for v in voices { v.stop() }
        if engine.isRunning { engine.pause() }
        try? AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .default, options: [.mixWithOthers])
    }

    private func build() {
        guard !built, let format = format else { return }
        for _ in 0..<6 {
            let v = AVAudioPlayerNode()
            engine.attach(v)
            engine.connect(v, to: engine.mainMixerNode, format: format)
            voices.append(v)
        }
        engine.attach(drone)
        engine.connect(drone, to: engine.mainMixerNode, format: format)
        drone.volume = 0
        built = true
    }

    private func schedule(_ samples: [Float]) {
        guard built, let format = format, !samples.isEmpty else { return }
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format,
                                            frameCapacity: AVAudioFrameCount(samples.count)),
              let channel = buffer.floatChannelData?[0] else { return }
        buffer.frameLength = AVAudioFrameCount(samples.count)
        for i in 0..<samples.count { channel[i] = samples[i] }
        if !engine.isRunning { try? engine.start() }
        guard engine.isRunning else { return }
        let v = voices[nextVoice % voices.count]
        nextVoice += 1
        v.stop()
        v.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        v.play()
    }

    /// A struck tone: `partials` are (ratio, amplitude); the decay is
    /// exponential, so it rings rather than switches off.
    func tone(_ frequency: Double,
              gain: Double = 0.16,
              duration: Double = 1.4,
              partials: [(Double, Double)] = [(1, 1), (2, 0.18), (3, 0.06)]) {
        guard frequency > 0 else { return }
        let n = Int(rate * max(0.05, duration))
        let attack = Int(rate * 0.012)
        var out = [Float](repeating: 0, count: n)
        let twoPi = 2.0 * Double.pi
        let norm = partials.reduce(0) { $0 + abs($1.1) }
        for i in 0..<n {
            let t = Double(i) / rate
            var s = 0.0
            for p in partials { s += p.1 * sin(twoPi * frequency * p.0 * t) }
            var env = exp(-t * 3.2 / max(0.2, duration))
            if i < attack { env *= Double(i) / Double(max(1, attack)) }
            if i > n - 400 { env *= Double(n - i) / 400 }
            out[i] = Float(s / max(1, norm) * env * gain)
        }
        schedule(out)
    }

    /// The earth's thump — a falling sine, felt more than heard.
    func thump(depth: Double = 1) {
        let n = Int(rate * 0.45)
        var out = [Float](repeating: 0, count: n)
        var phase = 0.0
        let d = min(max(depth, 0), 1)
        for i in 0..<n {
            let t = Double(i) / rate
            let f = 42 + (95 - 42) * exp(-t * 18)
            phase += 2 * Double.pi * f / rate
            let env = exp(-t * 7.5) * min(1, Double(i) / 80)
            out[i] = Float(sin(phase) * env * (0.25 + 0.3 * d))
        }
        schedule(out)
    }

    /// Lub — dub, at 68 and 52 Hz (Sacred Experiences' `makeHeartbeat`).
    func heartbeat(gain: Double = 0.5) {
        let n = Int(rate * 0.36)
        var out = [Float](repeating: 0, count: n)
        for i in 0..<n {
            let t = Double(i) / rate
            var s = 0.0
            if t < 0.2 { s += sin(2 * Double.pi * 68 * t) * 0.45 * exp(-t * 22) }
            if t > 0.14 {
                let u = t - 0.14
                s += sin(2 * Double.pi * 52 * u) * 0.28 * exp(-u * 20)
            }
            out[i] = Float(s * gain)
        }
        schedule(out)
    }

    /// Start (or retune) the looping drone: a fundamental and its fifth.
    /// Ten seconds at a tenth-of-a-hertz grid loops without a seam.
    func drone(_ frequency: Double) {
        guard built, let format = format else { return }
        let f = (frequency * 10).rounded() / 10
        guard f > 0, f != droneFrequency else { return }
        droneFrequency = f
        let n = Int(rate * 10)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(n)),
              let channel = buffer.floatChannelData?[0] else { return }
        buffer.frameLength = AVAudioFrameCount(n)
        let twoPi = 2.0 * Double.pi
        for i in 0..<n {
            let t = Double(i) / rate
            let s = sin(twoPi * f * t) + 0.45 * sin(twoPi * f * 1.5 * t) + 0.25 * sin(twoPi * f * 2 * t)
            channel[i] = Float(s / 1.7 * 0.5)
        }
        if !engine.isRunning { try? engine.start() }
        guard engine.isRunning else { return }
        drone.stop()
        drone.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
        drone.play()
    }

    /// The drone's level, 0 … 1 (the game eases it; this sets it).
    func droneGain(_ g: Double) {
        guard built else { return }
        drone.volume = Float(min(max(g, 0), 1))
    }
}

// MARK: Light helpers for the Canvas

extension GraphicsContext {
    /// A glow — light standing in the air, additive where the caller asks.
    func glow(at c: CGPoint, radius: CGFloat, color: Color, alpha: Double) {
        guard radius > 0, alpha > 0 else { return }
        let rect = CGRect(x: c.x - radius, y: c.y - radius, width: radius * 2, height: radius * 2)
        fill(Path(ellipseIn: rect),
             with: .radialGradient(Gradient(colors: [color.opacity(min(alpha, 1)), color.opacity(0)]),
                                   center: c, startRadius: 0, endRadius: radius))
    }

    /// A small bright core.
    func core(at c: CGPoint, radius: CGFloat, color: Color, alpha: Double) {
        guard radius > 0 else { return }
        fill(Path(ellipseIn: CGRect(x: c.x - radius, y: c.y - radius, width: radius * 2, height: radius * 2)),
             with: .color(color.opacity(min(max(alpha, 0), 1))))
    }
}
