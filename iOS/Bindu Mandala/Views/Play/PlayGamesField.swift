import SwiftUI

// MARK: - Wave 4 · the field games: Finger Garden, Shake to Clear

// MARK: Finger Garden — Hands · Sarva-Priyaṅkarī (kp 69)
//
// The best sound-and-touch coupling in the corpus. A touch plants a stem that
// grows while the finger stays; a still finger grows it tall, a busy one lets
// it wander. Under the garden a drone sounds, and it swells with every stem.
// When the garden is in bloom, the drone carries him to her.

final class FingerGardenModel: PlayModel {
    private struct Stem {
        var points: [CGPoint]
        var maxPoints: Int
        var drift: CGFloat
        var hueShift: Double
        var width: CGFloat
        var growing: Bool
        var bloom: Double = 0
    }

    private var stems: [Stem] = []
    private var clock = FrameClock()
    private var holding: [ObjectIdentifier: (stem: Int, at: CGPoint, speed: Double)] = [:]
    private var gain: Double = 0
    private var droneOn = false

    private var bloomed: Int { stems.filter { $0.bloom >= 1 }.count }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        for (_, h) in holding where h.stem < stems.count {
            grow(h.stem, by: GardenGrowth.rate(fingerSpeed: h.speed) * dt * 60)
        }
        for i in stems.indices where !stems[i].growing {
            grow(i, by: dt * 30)    // a released stem finishes growing by itself
        }
        for i in stems.indices where stems[i].points.count >= stems[i].maxPoints {
            stems[i].bloom = min(1, stems[i].bloom + dt * 0.8)
        }
        let target = GardenGrowth.droneGain(stems: stems.count) / 0.18
        gain += (target - gain) * min(1, dt * 1.2)
        if droneOn { PlaySound.shared.droneGain(gain * 0.6) }
        if bloomed >= GardenGrowth.bloomStems { session.complete(.recognition) }
    }

    private func grow(_ i: Int, by amount: Double) {
        guard i < stems.count, stems[i].points.count < stems[i].maxPoints, let tip = stems[i].points.last else { return }
        var budget = amount
        var p = tip
        while budget >= 1, stems[i].points.count < stems[i].maxPoints {
            p = CGPoint(x: p.x + stems[i].drift * 0.3 + CGFloat.random(in: -0.45...0.45), y: p.y - 1.8)
            stems[i].points.append(p)
            budget -= 1
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        add.fill(Path(CGRect(x: 0, y: size.height * 0.82, width: size.width, height: size.height * 0.18)),
                 with: .linearGradient(Gradient(colors: [hue.opacity(0), Color(red: 0.4, green: 0.25, blue: 0.08).opacity(0.18)]),
                                       startPoint: CGPoint(x: 0, y: size.height * 0.82),
                                       endPoint: CGPoint(x: 0, y: size.height)))
        for s in stems where s.points.count > 1 {
            var p = Path()
            p.move(to: s.points[0])
            for q in s.points.dropFirst() { p.addLine(to: q) }
            let col = Color(hue: (0.22 + s.hueShift).truncatingRemainder(dividingBy: 1), saturation: 0.55, brightness: 0.75)
            add.stroke(p, with: .color(col.opacity(0.7)), lineWidth: s.width)
            if let top = s.points.last, s.bloom > 0 {
                let sway = still ? 0 : CGFloat(sin(breath * 1.5 + s.hueShift * 20)) * 1.5
                let c = CGPoint(x: top.x + sway, y: top.y)
                add.glow(at: c, radius: 16 * CGFloat(s.bloom), color: hue, alpha: 0.75 * s.bloom)
                add.core(at: c, radius: 2.5 * CGFloat(s.bloom), color: Color.cream, alpha: 0.9)
            }
        }
        add.glow(at: CGPoint(x: size.width / 2, y: size.height * 0.85), radius: size.width * 0.7,
                 color: hue, alpha: 0.05 + 0.2 * gain)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        if !droneOn {
            droneOn = true
            PlaySound.shared.drone(110)
            PlaySound.shared.droneGain(0)
        }
        guard stems.count < 24 else { return }
        stems.append(Stem(points: [s.location],
                          maxPoints: Int.random(in: 40...72),
                          drift: CGFloat.random(in: -0.5...0.5),
                          hueShift: Double.random(in: 0...0.12),
                          width: 1 + 1.6 * CGFloat(s.pressure),
                          growing: true))
        holding[s.id] = (stem: stems.count - 1, at: s.location, speed: 0)
        PlaySound.shared.tone(220 * [1, 1.125, 1.25, 1.5, 1.667].randomElement()!, gain: 0.06, duration: 1.6)
        PlayHaptics.tap(0.25 + 0.3 * s.pressure)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let h = holding[s.id] else { return }
        let d = Double(hypot(s.location.x - h.at.x, s.location.y - h.at.y))
        holding[s.id] = (stem: h.stem, at: s.location, speed: d * 60)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        if let h = holding[s.id], h.stem < stems.count { stems[h.stem].growing = false }
        holding[s.id] = nil
    }
}

// MARK: Shake to Clear — Crow · Sarvādhārasvarūpā (kp 82)
//
// Clearing the field. The loops and lists drift in the air as faint words;
// shaking the phone scatters them outward and away, and a tap is a small
// shake for a phone that lies still. The words are released from the view —
// nothing he set down is kept on the glass — and when the field is clear only
// the light remains, and the game goes quiet.

final class ShakeToClearModel: PlayModel {
    private struct Mote { var word: Int; var p: CGPoint; var v: CGVector; var size: CGFloat }
    private var shake = ShakeClear()
    private var clock = FrameClock()
    private var motes: [Mote] = []
    private var seeded = false
    private var nextRustle: Double = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        if !seeded {
            seeded = true
            for i in 0..<ShakeWords.all.count {
                motes.append(Mote(word: i,
                                  p: CGPoint(x: CGFloat.random(in: 40...max(41, size.width - 40)),
                                             y: CGFloat.random(in: 80...max(81, size.height - 80))),
                                  v: CGVector(dx: CGFloat.random(in: -6...6), dy: CGFloat.random(in: -5...5)),
                                  size: CGFloat.random(in: 0.85...1.25)))
            }
        }
        shake.feel(acceleration: motion.shake, dt: dt)
        let e = CGFloat(shake.energy)
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        for i in motes.indices {
            let away = CGVector(dx: motes[i].p.x - c.x, dy: motes[i].p.y - c.y)
            let len = max(1, hypot(away.dx, away.dy))
            motes[i].v.dx += away.dx / len * e * 400 * CGFloat(dt) + CGFloat.random(in: -1...1) * e * 30
            motes[i].v.dy += away.dy / len * e * 400 * CGFloat(dt) + CGFloat.random(in: -1...1) * e * 30
            motes[i].p.x += motes[i].v.dx * CGFloat(dt)
            motes[i].p.y += motes[i].v.dy * CGFloat(dt)
            motes[i].v.dx *= 0.985
            motes[i].v.dy *= 0.985
        }
        if shake.energy > 0.25, now >= nextRustle {
            nextRustle = now + 0.18
            PlaySound.shared.tone(Double.random(in: 900...1500), gain: 0.025 * shake.energy, duration: 0.25,
                                  partials: [(1, 1), (1.41, 0.5)])
            PlayHaptics.tap(0.2 + 0.5 * shake.energy)
        }
        if shake.isClear { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let fade = 1 - shake.cleared
        for m in motes {
            var c = ctx
            c.opacity = fade
            c.draw(ShakeWords.text(m.word, scale: m.size), at: m.p)
        }
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        add.glow(at: c, radius: 60 + 220 * CGFloat(shake.cleared), color: hue, alpha: 0.08 + 0.3 * shake.cleared)
        add.core(at: c, radius: 2.5, color: Color.cream, alpha: 0.4 + 0.6 * shake.cleared)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        shake.tapShake()
        PlayHaptics.tap(0.35)
    }
}

/// The loops, the lists, the replays (`games-body.jsx`'s own words).
enum ShakeWords {
    static let all: [String] = [
        "should have", "what if", "not enough", "tomorrow", "remember", "sorry",
        "always", "never", "too much", "they said", "I said", "why did I",
        "I should", "maybe", "one more", "I meant to", "almost", "eventually",
        "if only", "somehow", "but still", "deadline",
    ]

    static func text(_ i: Int, scale: CGFloat) -> Text {
        let word = all[i % all.count]
        return scale > 1.05
            ? Text(word).font(AppFont.voice(18)).foregroundColor(Color.cream.opacity(0.62))
            : Text(word).font(AppFont.voice(15)).foregroundColor(Color.cream.opacity(0.55))
    }
}
