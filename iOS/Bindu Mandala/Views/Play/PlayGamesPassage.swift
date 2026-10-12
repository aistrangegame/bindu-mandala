import SwiftUI

// MARK: - Wave 4 · the passage games: the Corridor, the Door, Spine Walk

// MARK: The Corridor — Shadow, the 3→4 crossing
//
// The passage itself. The rings of the yantra stand as walls around him and
// move past as he steps; a step at the pace his body allows carries him
// deeper, and a hurried step makes the walls press close and the light cool.
// Nothing is taken back. At the far end the door of light opens, and the
// crossing hands him into stillness.

final class CorridorModel: PlayModel {
    private var pace = CorridorPace()
    private var clock = FrameClock()
    private var shown: Double = 0          // depth as drawn, eased
    private var stepFlash: Double = 0
    private var ripples: [PlayRipple] = []

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        pace.relax(dt: dt)
        shown += (pace.depth - shown) * min(1, dt * 3)
        stepFlash = max(0, stepFlash - dt * 1.8)
        ripples.removeAll { !$0.alive(now) }
        if pace.crossed, shown > 0.97 { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let c = CGPoint(x: size.width / 2, y: size.height * 0.46)
        let maxR = max(size.width, size.height) * 0.75
        var add = ctx
        add.blendMode = .plusLighter
        let press = pace.press
        // Nine rings, the yantra's own enclosures, travelling outward with him.
        let travel = shown * 9
        for i in 0..<12 {
            let k = Double(i) - travel.truncatingRemainder(dividingBy: 1)
            let r = maxR * CGFloat(pow(0.74, k)) * CGFloat(1 - 0.22 * press)
            guard r > 6 else { continue }
            let near = max(0, min(1, Double(r / maxR)))
            let warm = Color(red: 0.95, green: 0.82, blue: 0.62)
            let cool = Color(red: 0.55, green: 0.60, blue: 0.95)
            let col = press > 0.3 ? cool : (i % 3 == 0 ? warm : hue)
            add.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                       with: .color(col.opacity((0.10 + 0.32 * near) * (1 - 0.5 * press) + 0.25 * press * near)),
                       lineWidth: 1 + 2.2 * CGFloat(near) + CGFloat(press) * 1.5)
        }
        // The door of light at the end — it grows as he walks, and dims
        // while the walls press.
        let door = 10 + 120 * CGFloat(pow(shown, 1.6))
        add.glow(at: c, radius: door * 2.2, color: hue, alpha: (0.15 + 0.35 * shown) * (1 - 0.6 * press))
        add.glow(at: c, radius: door, color: Color.cream, alpha: (0.25 + 0.55 * shown) * (1 - 0.5 * press) + 0.25 * stepFlash)
        add.core(at: c, radius: 2.5, color: Color.cream, alpha: 0.9)
        for r in ripples { r.draw(in: add, now: now) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        switch pace.step(at: s.time) {
        case .first, .inPace:
            stepFlash = 1
            PlaySound.shared.tone(PlayModels.pointHz, gain: 0.13, duration: 1.1,
                                  partials: [(1, 1), (2, 0.3), (3, 0.08)])
            PlayHaptics.tap(0.45)
            ripples.append(PlayRipple(center: s.location, born: s.time, color: Color.cream, life: 1.2, reach: 90))
        case .hurried:
            PlaySound.shared.thump(depth: 0.2)
            PlayHaptics.tap(0.15)
        case .lingering:
            PlayHaptics.tap(0.25)
        }
    }
}

// MARK: The Door — Innocence · Kaulinī
//
// The threshold verb. The door is small; he must become small to pass. A
// light hold opens it, and as it opens the world grows around him — he is the
// one getting smaller. Pressing hard does not force it: the door dims and
// waits, and the force is absorbed. Lifting the finger leaves it as open as it
// was.

final class DoorModel: PlayModel {
    private var hold = DoorHold()
    private var clock = FrameClock()
    private var touches: [ObjectIdentifier: Double] = [:]   // pressure per finger
    private var lastQuarter = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        let pressure = touches.values.max() ?? 0
        hold.step(dt: dt, holding: !touches.isEmpty, pressure: pressure)
        let q = Int(hold.opened * 4)
        if q > lastQuarter {
            lastQuarter = q
            PlayHaptics.tap(0.3 + 0.15 * Double(q))
            PlaySound.shared.tone(480 * (1 + 0.06 * Double(q)), gain: 0.07, duration: 1.6)
        }
        if hold.isOpen { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let c = CGPoint(x: size.width / 2, y: size.height * 0.5)
        let open = hold.opened
        let dim = hold.dim
        // He becomes small: the field around the door grows.
        let grow = CGFloat(1 + 1.6 * open * open)
        var add = ctx
        add.blendMode = .plusLighter
        for i in 0..<7 {
            let r = CGFloat(60 + i * 44) * grow
            add.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                       with: .color(hue.opacity(0.06 + 0.03 * Double(7 - i))), lineWidth: 0.8)
        }
        // The small door: an arch of light, its inside brightening as it opens.
        let w: CGFloat = 46 * grow
        let h: CGFloat = 70 * grow
        let arch = Self.arch(center: CGPoint(x: c.x, y: c.y + h * 0.15), width: w, height: h)
        let inner = (0.12 + 0.75 * open) * (1 - 0.7 * dim)
        add.fill(arch, with: .radialGradient(Gradient(colors: [Color.cream.opacity(inner), hue.opacity(inner * 0.5), hue.opacity(0)]),
                                             center: CGPoint(x: c.x, y: c.y), startRadius: 0, endRadius: h))
        add.stroke(arch, with: .color(hue.opacity(0.55 * (1 - 0.6 * dim) + 0.2)), lineWidth: 1.4)
        add.glow(at: c, radius: 60 + 260 * CGFloat(open), color: hue, alpha: 0.12 + 0.4 * open * (1 - dim))
        if open > 0.98 {
            add.glow(at: c, radius: max(size.width, size.height), color: Color.cream, alpha: 0.35)
        }
    }

    static func arch(center c: CGPoint, width w: CGFloat, height h: CGFloat) -> Path {
        var p = Path()
        let left = c.x - w / 2, right = c.x + w / 2
        let bottom = c.y + h / 2
        let springLine = c.y - h / 2 + w / 2
        p.move(to: CGPoint(x: left, y: bottom))
        p.addLine(to: CGPoint(x: left, y: springLine))
        // The round head, drawn point by point over the top (y grows downward,
        // so 180° → 360° passes through "up").
        let r = w / 2
        for step in 0...24 {
            let a = Double.pi + Double.pi * Double(step) / 24
            p.addLine(to: CGPoint(x: c.x + r * CGFloat(cos(a)), y: springLine + r * CGFloat(sin(a))))
        }
        p.addLine(to: CGPoint(x: right, y: bottom))
        p.closeSubpath()
        return p
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        touches[s.id] = s.pressure
        PlayHaptics.tap(0.2)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        touches[s.id] = s.pressure
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        touches[s.id] = nil
    }
}

// MARK: Spine Walk — Axis · Sarvānandamayī
//
// The Climb's own gesture. A light on the spine follows his finger, but no
// faster than attention can travel; a rushing finger leaves it behind. Where
// it rests on one of the ten body centres, that centre lights and sounds.
// When all ten have been rested in, she is felt.

final class SpineWalkModel: PlayModel {
    private var light = SpineLight()
    private var clock = FrameClock()
    private var target: Double? = nil
    private var sounded: Set<Int> = []
    private var height: CGFloat = 1

    /// The ten centres, rising — a just scale above the point's pitch.
    private static let ratios: [Double] = [1, 9.0 / 8, 5.0 / 4, 4.0 / 3, 3.0 / 2, 5.0 / 3, 15.0 / 8, 2, 9.0 / 4, 5.0 / 2]

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        height = max(1, size.height)
        if let t = target { light.follow(target: t, dt: dt) }
        for i in light.lit where !sounded.contains(i) {
            sounded.insert(i)
            PlaySound.shared.tone(PlayModels.pointHz * 2 * Self.ratios[i], gain: 0.12, duration: 2.2)
            PlayHaptics.tap(0.35 + 0.05 * Double(i))
        }
        if light.arrived { session.complete(.recognition) }
    }

    private func y(for fraction: Double, size: CGSize) -> CGFloat {
        let top = size.height * 0.10, bottom = size.height * 0.88
        return bottom - CGFloat(fraction) * (bottom - top)
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let x = size.width / 2
        var add = ctx
        add.blendMode = .plusLighter
        var spine = Path()
        spine.move(to: CGPoint(x: x, y: y(for: 0, size: size)))
        spine.addLine(to: CGPoint(x: x, y: y(for: 1, size: size)))
        add.stroke(spine, with: .color(hue.opacity(0.22)), lineWidth: 1.2)
        for (i, f) in SpineLight.stations.enumerated() {
            let p = CGPoint(x: x, y: y(for: f, size: size))
            let isLit = light.lit.contains(i)
            add.glow(at: p, radius: isLit ? 34 : 14, color: hue, alpha: isLit ? 0.45 : 0.16)
            add.core(at: p, radius: isLit ? 3.5 : 2.2, color: isLit ? Color.cream : hue, alpha: isLit ? 0.95 : 0.5)
        }
        let p = CGPoint(x: x, y: y(for: light.y, size: size))
        let b = still ? 0.5 : 0.5 + 0.5 * sin(breath * 2)
        add.glow(at: p, radius: 46 + 6 * CGFloat(b), color: Color.cream, alpha: 0.38)
        add.glow(at: p, radius: 16, color: hue, alpha: 0.8)
        add.core(at: p, radius: 4, color: Color.cream, alpha: 1)
        if light.arrived {
            add.glow(at: CGPoint(x: x, y: y(for: 1, size: size)), radius: 220, color: hue, alpha: 0.35)
        }
    }

    private func fraction(_ s: TouchSample) -> Double {
        let top = height * 0.10, bottom = height * 0.88
        return Double((bottom - s.location.y) / max(1, bottom - top))
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        target = fraction(s)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        target = fraction(s)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        target = nil
    }
}
