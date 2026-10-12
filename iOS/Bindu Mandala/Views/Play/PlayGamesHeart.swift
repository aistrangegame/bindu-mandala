import SwiftUI

// MARK: - Wave 4 · the heart games: Pulse, Coherence, Echo

// MARK: Pulse — Sarva-Maṅgalakāriṇī (kp 70)
//
// The way in to Recognition: catching her in the act. He feels for his own
// heartbeat and taps with it; each tap is a heartbeat in the ear and the
// hand. When his finger has been steady with his heart for eight beats, the
// light keeps beating on its own at his period — hers now — three times, and
// she is felt.

final class PulseModel: PlayModel {
    private var catcher = HeartbeatCatch()
    private var clock = FrameClock()
    private var ripples: [PlayRipple] = []
    private var lastBeat: Double = -10
    private var answer: (start: Double, period: Double)? = nil
    private var answered = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        _ = clock.tick(now)
        ripples.removeAll { !$0.alive(now) }
        if answer == nil, catcher.caught, let p = catcher.period {
            answer = (start: now + p, period: p)
        }
        if let a = answer {
            let due = a.start + Double(answered) * a.period
            if answered < 3, now >= due {
                answered += 1
                lastBeat = now
                PlaySound.shared.heartbeat(gain: 0.42)
                PlayHaptics.heartbeat(0.75)
                ripples.append(PlayRipple(center: CGPoint(x: size.width / 2, y: size.height * 0.45),
                                          born: now, color: Color.cream, life: 1.6, reach: 200))
            }
            if answered >= 3, now >= due + a.period * 0.6 { session.complete(.recognition) }
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let c = CGPoint(x: size.width / 2, y: size.height * 0.45)
        var add = ctx
        add.blendMode = .plusLighter
        let since = now - lastBeat
        let beat = exp(-since * 5)
        let steady = catcher.steadiness
        add.glow(at: c, radius: 120 + 40 * CGFloat(beat), color: hue, alpha: 0.14 + 0.2 * steady + 0.2 * beat)
        add.glow(at: c, radius: 46 + 14 * CGFloat(beat), color: Color.cream, alpha: 0.25 + 0.4 * beat)
        add.core(at: c, radius: 3 + 2 * CGFloat(beat), color: Color.cream, alpha: 0.95)
        for r in ripples { r.draw(in: add, now: now, width: 1.4) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard answer == nil else { return }
        session.acted()
        catcher.tap(at: s.time)
        lastBeat = s.time
        PlaySound.shared.heartbeat(gain: 0.5)
        PlayHaptics.heartbeat(0.55 + 0.4 * s.pressure)
        ripples.append(PlayRipple(center: s.location, born: s.time, color: Color.cream, life: 1.2, reach: 120))
    }
}

// MARK: Coherence — Pulse; the Rite's breath
//
// Heart and breath meeting. The left thumb holds while the breath comes in
// and lets go as it leaves; the right thumb taps the heart. Two lights, one
// rising and falling with the breath and one beating with the heart, draw
// together as the breath comes to hold a whole number of heartbeats. Three
// slow breaths in which they meet, and she is felt.

final class CoherenceModel: PlayModel {
    private var heart = HeartbeatCatch()
    private var clock = FrameClock()
    private var breaths: [Double] = []
    private var lastInhale: Double? = nil
    private var inhaling = false
    private var breathLevel: Double = 0
    private var lastBeat: Double = -10
    private var width: CGFloat = 1
    private var droneOn = false
    private var breathFinger: ObjectIdentifier? = nil

    private var meeting: Double {
        guard let b = breaths.last, let h = heart.period else { return 0 }
        return Coherence.meeting(breathPeriod: b, heartPeriod: h)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        width = max(1, size.width)
        breathLevel += ((inhaling ? 1 : 0) - breathLevel) * min(1, dt * 0.9)
        if droneOn { PlaySound.shared.droneGain(0.05 + 0.2 * breathLevel) }
        if Coherence.met(breaths: breaths, heartPeriod: heart.period) { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let m = meeting
        let midY = size.height * 0.45
        let gap = (1 - m) * Double(size.height) * 0.18
        let breathY = midY - CGFloat(gap) - CGFloat(breathLevel) * 30
        let beat = exp(-(now - lastBeat) * 5)
        let heartY = midY + CGFloat(gap)
        let breathColor = Color(red: 0.55, green: 0.75, blue: 0.98)
        var wave = Path()
        var pulse = Path()
        let steps = 60
        for i in 0...steps {
            let x = size.width * CGFloat(i) / CGFloat(steps)
            let u = Double(i) / Double(steps)
            let by = breathY + CGFloat(sin(u * .pi * 2 + breath * 0.6)) * 18 * CGFloat(0.4 + breathLevel)
            let hy = heartY + CGFloat(sin(u * .pi * 8 + breath * 4)) * 10 * CGFloat(0.3 + beat)
            if i == 0 {
                wave.move(to: CGPoint(x: x, y: by))
                pulse.move(to: CGPoint(x: x, y: hy))
            } else {
                wave.addLine(to: CGPoint(x: x, y: by))
                pulse.addLine(to: CGPoint(x: x, y: hy))
            }
        }
        add.stroke(wave, with: .color(breathColor.opacity(0.55)), lineWidth: 1.6)
        add.stroke(pulse, with: .color(hue.opacity(0.6)), lineWidth: 1.6)
        let c = CGPoint(x: size.width / 2, y: midY)
        add.glow(at: c, radius: 60 + 140 * CGFloat(m), color: Color.cream, alpha: 0.1 + 0.4 * m)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        if s.location.x < width / 2 {
            breathFinger = s.id
            inhaling = true
            if let l = lastInhale { breaths.append(s.time - l) }
            if breaths.count > 6 { breaths.removeFirst() }
            lastInhale = s.time
            if !droneOn {
                droneOn = true
                PlaySound.shared.drone(PlayModels.pointHz)
                PlaySound.shared.droneGain(0.05)
            }
            PlayHaptics.tap(0.25)
        } else {
            heart.tap(at: s.time)
            lastBeat = s.time
            PlaySound.shared.heartbeat(gain: 0.42)
            PlayHaptics.heartbeat(0.5 + 0.4 * s.pressure)
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        if s.id == breathFinger {
            inhaling = false
            breathFinger = nil
        }
    }
}

// MARK: Echo — Sarvajñānamayī (kp 80)
//
// She answers. He taps a call and waits; she sounds his rhythm back from the
// centre. When his next call echoes her answer, she answers a step higher —
// root, second, third, fourth — and on the fifth she is felt. A call that
// does not echo her is simply answered again where she stands.

final class EchoModel: PlayModel {
    private var exchange = EchoExchange()
    private var clock = FrameClock()
    private var taps: [Double] = []
    private var pending: [Double] = []      // when her notes sound
    private var pendingHz: Double = EchoExchange.base
    private var ripples: [PlayRipple] = []
    private var center = CGPoint.zero
    private var finishingAt: Double? = nil

    private static let waitForAnswer: Double = 1.6

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        _ = clock.tick(now)
        center = CGPoint(x: size.width / 2, y: size.height * 0.45)
        ripples.removeAll { !$0.alive(now) }
        if let last = taps.last, now - last >= Self.waitForAnswer, pending.isEmpty, finishingAt == nil {
            if taps.count >= 2 {
                let intervals = (1..<taps.count).map { taps[$0] - taps[$0 - 1] }
                let answer = exchange.call(intervals: intervals)
                pendingHz = exchange.frequency
                var t = now + 0.35
                pending = [t]
                for iv in answer { t += iv; pending.append(t) }
                if exchange.reachedFifth { finishingAt = t + 1.8 }
            }
            taps.removeAll()
        }
        while let first = pending.first, now >= first {
            pending.removeFirst()
            PlaySound.shared.tone(pendingHz, gain: 0.14, duration: 1.8,
                                  partials: [(1, 1), (1.5, exchange.reachedFifth ? 0.35 : 0.05), (2, 0.15)])
            PlayHaptics.tap(0.3)
            ripples.append(PlayRipple(center: center, born: now, color: Color.cream, life: 1.8, reach: 220))
        }
        if let f = finishingAt, now >= f { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.45)
        let climb = Double(exchange.degree) / Double(EchoExchange.ratios.count - 1)
        add.glow(at: c, radius: 90 + 70 * CGFloat(climb), color: hue, alpha: 0.18 + 0.3 * climb)
        add.glow(at: c, radius: 30, color: Color.cream, alpha: 0.35 + 0.3 * climb)
        add.core(at: c, radius: 3, color: Color.cream, alpha: 0.95)
        // The steps she has climbed, as a quiet stair of light above her.
        for i in 0...exchange.degree {
            let p = CGPoint(x: c.x, y: c.y - 90 - CGFloat(i) * 26)
            add.glow(at: p, radius: 12, color: hue, alpha: 0.35)
        }
        for r in ripples { r.draw(in: add, now: now) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard pending.isEmpty, finishingAt == nil else { return }
        session.acted()
        taps.append(s.time)
        if taps.count > 8 { taps.removeFirst() }
        PlaySound.shared.tone(EchoExchange.base * 0.5, gain: 0.12, duration: 0.9,
                              partials: [(1, 1), (2, 0.25)])
        PlayHaptics.tap(0.35 + 0.4 * s.pressure)
        ripples.append(PlayRipple(center: s.location, born: s.time, color: Color.gold, life: 1.2, reach: 100))
    }
}
