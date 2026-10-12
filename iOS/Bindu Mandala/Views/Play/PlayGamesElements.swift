import SwiftUI

// MARK: - Wave 4 · the element games: the Drum, Root System, Water Level,
// the Fire, Rain

// MARK: The Drum — Soles · Sarva-Saṅkṣobhiṇī (kp 53)
//
// An earth verb. He strikes at the earth's own beat, one a second; every
// strike is a thump in the ear and the hand, as full as the press (absorbed).
// On the beat the root goes deeper; off it the ground shivers and the thump
// is muddied. When the root reaches the water, she is felt.

final class DrumModel: PlayModel {
    private var beat = DrumBeat()
    private var clock = FrameClock()
    private var shiver: Double = 0
    private var lastStrike: Double = -10
    private var lastOnBeat: Double? = nil
    private var shownDepth: Double = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        shiver = max(0, shiver - dt * 2.5)
        let target = Double(beat.depth) / Double(DrumBeat.depthToWater)
        shownDepth += (target - shownDepth) * min(1, dt * 4)
        if beat.reachedWater, shownDepth > 0.97 { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let skyline = size.height * 0.2
        let water = size.height * 0.9
        let jitter = CGFloat(shiver) * 3 * CGFloat(sin(now * 60))
        // Strata, warming with depth.
        for i in 0..<5 {
            let y0 = skyline + (water - skyline) * CGFloat(i) / 5
            let rect = CGRect(x: jitter, y: y0, width: size.width, height: (water - skyline) / 5)
            let warm = 0.05 + 0.025 * Double(i)
            ctx.fill(Path(rect), with: .color(Color(red: 0.35 + warm, green: 0.18 + warm * 0.5, blue: 0.08).opacity(0.18)))
        }
        var add = ctx
        add.blendMode = .plusLighter
        // The water table.
        var table = Path()
        table.move(to: CGPoint(x: 0, y: water))
        table.addLine(to: CGPoint(x: size.width, y: water))
        add.stroke(table, with: .color(Color(red: 0.45, green: 0.7, blue: 0.95).opacity(0.35 + 0.4 * shownDepth)), lineWidth: 1.5)
        // The root.
        let x = size.width / 2 + jitter
        let tipY = skyline + (water - skyline) * CGFloat(shownDepth)
        var root = Path()
        root.move(to: CGPoint(x: x, y: skyline))
        root.addLine(to: CGPoint(x: x, y: tipY))
        add.stroke(root, with: .color(hue.opacity(0.65)), lineWidth: 2.4)
        for k in stride(from: 4, through: beat.depth, by: 4) {
            let y = skyline + (water - skyline) * CGFloat(Double(k) / Double(DrumBeat.depthToWater))
            let side: CGFloat = (k / 4) % 2 == 0 ? 1 : -1
            var branch = Path()
            branch.move(to: CGPoint(x: x, y: y))
            branch.addLine(to: CGPoint(x: x + side * 38, y: y + 20))
            add.stroke(branch, with: .color(hue.opacity(0.4)), lineWidth: 1.4)
        }
        add.glow(at: CGPoint(x: x, y: tipY), radius: 26, color: hue, alpha: 0.6)
        // The earth's own beat, shown as a breath of light at the surface,
        // counted from his last true strike.
        if let on = lastOnBeat {
            let ph = (now - on).truncatingRemainder(dividingBy: DrumBeat.period) / DrumBeat.period
            let glow = exp(-ph * 6)
            add.glow(at: CGPoint(x: size.width / 2, y: skyline), radius: 90, color: hue, alpha: 0.12 + 0.3 * glow)
        }
        let strike = exp(-(now - lastStrike) * 6)
        add.glow(at: CGPoint(x: size.width / 2, y: skyline), radius: 140 * CGFloat(0.5 + strike), color: Color.cream, alpha: 0.25 * strike)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        lastStrike = s.time
        let full = DrumBeat.thump(pressure: s.pressure)
        switch beat.strike(at: s.time) {
        case .first, .onBeat:
            lastOnBeat = s.time
            PlaySound.shared.thump(depth: full)
            PlayHaptics.thump(full)
        case .offBeat:
            shiver = 1
            PlaySound.shared.thump(depth: full * 0.45)
            PlayHaptics.tap(0.4)
        }
    }
}

// MARK: Root System — Mūlādhāra · Garimā (kp 4)
//
// Hold still, grow deep. Fingers rested on the glass send roots down; only
// stillness grows them, and a moving finger only makes them wander. Every
// root stays where it grew. When they reach the depth, she — heaviness
// itself — is felt.

final class RootSystemModel: PlayModel {
    private struct Root { var points: [CGPoint]; var heading: CGFloat }
    private var growth = RootGrowth()
    private var clock = FrameClock()
    private var anchors: [ObjectIdentifier: (start: CGPoint, now: CGPoint, root: Int)] = [:]
    private var roots: [Root] = []
    private var droneOn = false
    private var nextPulse: Double = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        var stillness = 0.0
        for (_, a) in anchors {
            let moved = hypot(a.now.x - a.start.x, a.now.y - a.start.y)
            stillness = max(stillness, max(0, 1 - Double(moved) / 30))
        }
        growth.grow(dt: dt, stillness: stillness, fingers: anchors.count)
        if !anchors.isEmpty, stillness > 0.5 {
            for (_, a) in anchors where a.root < roots.count {
                var r = roots[a.root]
                if let tip = r.points.last, tip.y < size.height - 8 {
                    r.heading += CGFloat.random(in: -0.18...0.18) * CGFloat(2 - stillness)
                    r.heading = min(max(r.heading, -0.7), 0.7)
                    let step = CGFloat(dt) * 34 * CGFloat(stillness)
                    r.points.append(CGPoint(x: tip.x + sin(r.heading) * step, y: tip.y + cos(r.heading) * step))
                    if r.points.count > 900 { r.points.removeFirst(r.points.count - 900) }
                }
                roots[a.root] = r
            }
            if now >= nextPulse {
                nextPulse = now + 1.3
                PlayHaptics.tap(0.2 + 0.3 * stillness)
            }
        }
        if droneOn {
            PlaySound.shared.droneGain(anchors.isEmpty ? 0 : 0.08 + 0.22 * stillness * growth.depth)
        }
        if growth.rooted { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let warmth = growth.depth
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .linearGradient(Gradient(colors: [Color.clear, Color(red: 0.35, green: 0.18, blue: 0.06).opacity(0.15 + 0.25 * warmth)]),
                                       startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: size.height)))
        var add = ctx
        add.blendMode = .plusLighter
        for r in roots where r.points.count > 1 {
            var p = Path()
            p.move(to: r.points[0])
            for q in r.points.dropFirst() { p.addLine(to: q) }
            add.stroke(p, with: .color(hue.opacity(0.55)), lineWidth: 1.6)
            if let tip = r.points.last { add.glow(at: tip, radius: 10, color: hue, alpha: 0.6) }
        }
        for (_, a) in anchors { add.glow(at: a.start, radius: 40, color: Color.cream, alpha: 0.22) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        roots.append(Root(points: [s.location], heading: 0))
        anchors[s.id] = (start: s.location, now: s.location, root: roots.count - 1)
        if !droneOn {
            droneOn = true
            PlaySound.shared.drone(68)
        }
        PlayHaptics.thump(0.3)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let a = anchors[s.id] else { return }
        anchors[s.id] = (start: a.start, now: s.location, root: a.root)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        anchors[s.id] = nil
    }
}

// MARK: Water Level — Svādhiṣṭhāna · Vārāhī (kp 15)
//
// Balance into stillness. The water has a restoring force of its own; the
// phone's tilt leans on it, a finger dragged across the glass nudges it, and
// now and then the world does — a thought, a notification. Held level, it
// settles; held still for long enough, the surface becomes a mirror and the
// game goes quiet.

final class WaterLevelModel: PlayModel {
    private var vessel = WaterVessel()
    private var clock = FrameClock()
    private var nextThought: Double = 0
    private var nudge: Double = 0
    private var lastX: [ObjectIdentifier: CGFloat] = [:]
    private var width: CGFloat = 1
    private var droneOn = false

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        width = max(1, size.width)
        if nextThought == 0 { nextThought = now + 6 }
        if now >= nextThought {
            nextThought = now + Double.random(in: 5...8)
            nudge += Double.random(in: -0.12...0.12)
        }
        vessel.step(dt: dt, tilt: motion.roll, nudge: nudge)
        nudge = 0
        if !droneOn {
            droneOn = true
            PlaySound.shared.drone(210)
        }
        let calm = min(1, vessel.stillFor / WaterVessel.stillToSettle)
        PlaySound.shared.droneGain(0.04 + 0.22 * calm)
        if vessel.settled { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let w = size.width * 0.78, h = size.height * 0.34
        let origin = CGPoint(x: (size.width - w) / 2, y: size.height * 0.33)
        let vesselRect = CGRect(origin: origin, size: CGSize(width: w, height: h))
        let calm = min(1, vessel.stillFor / WaterVessel.stillToSettle)
        var add = ctx
        add.blendMode = .plusLighter
        add.stroke(Path(roundedRect: vesselRect, cornerRadius: 18), with: .color(hue.opacity(0.35)), lineWidth: 1.2)
        let midY = origin.y + h * 0.5
        let lift = CGFloat(sin(vessel.angle)) * w / 2
        var water = Path()
        water.move(to: CGPoint(x: origin.x, y: midY + lift))
        let ripple = still ? 0 : (1 - calm) * 4
        for i in 1...24 {
            let u = CGFloat(i) / 24
            let x = origin.x + w * u
            let y = midY + lift - 2 * lift * u + CGFloat(sin(Double(u) * 12 + breath * 3)) * CGFloat(ripple)
            water.addLine(to: CGPoint(x: x, y: y))
        }
        water.addLine(to: CGPoint(x: origin.x + w, y: origin.y + h))
        water.addLine(to: CGPoint(x: origin.x, y: origin.y + h))
        water.closeSubpath()
        var clipped = add
        clipped.clip(to: Path(roundedRect: vesselRect, cornerRadius: 18))
        clipped.fill(water, with: .linearGradient(Gradient(colors: [hue.opacity(0.35 + 0.3 * calm), hue.opacity(0.08)]),
                                                  startPoint: CGPoint(x: 0, y: midY), endPoint: CGPoint(x: 0, y: origin.y + h)))
        // The mirror: the surface brightens as it stills.
        add.glow(at: CGPoint(x: size.width / 2, y: midY), radius: w * 0.5, color: Color.cream, alpha: 0.05 + 0.3 * calm)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        lastX[s.id] = s.location.x
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        if let x = lastX[s.id] {
            nudge += Double((s.location.x - x) / width) * 0.6
        }
        lastX[s.id] = s.location.x
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        lastX[s.id] = nil
    }
}

// MARK: The Fire — Forge · Sarva-Mantramayī (kp 65)
//
// Tending without forcing. The fire burns down on its own; a touch lays a
// stick on, its size absorbed from the press. Kept within its band it is
// tended; starved, it gutters low and red-brown; overfed, it roars tall and
// smoky. A minute tended, and she is felt.

final class FireModel: PlayModel {
    private struct Spark { var p: CGPoint; var v: CGVector; var life: Double; var r: CGFloat }
    private var fire = FireBand()
    private var clock = FrameClock()
    private var sparks: [Spark] = []

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        fire.burn(dt: dt)
        let base = CGPoint(x: size.width / 2, y: size.height * 0.72)
        let n = Int(fire.fuel * 7)
        for _ in 0..<n where sparks.count < 420 {
            sparks.append(Spark(p: CGPoint(x: base.x + CGFloat.random(in: -14...14), y: base.y),
                                v: CGVector(dx: CGFloat.random(in: -0.4...0.4) * 40,
                                            dy: -CGFloat.random(in: 70...150) * CGFloat(0.6 + fire.fuel)),
                                life: 1, r: CGFloat.random(in: 5...13)))
        }
        for i in sparks.indices {
            sparks[i].p.x += sparks[i].v.dx * CGFloat(dt)
            sparks[i].p.y += sparks[i].v.dy * CGFloat(dt)
            sparks[i].life -= dt * 0.9
        }
        sparks.removeAll { $0.life <= 0 }
        if fire.kindled { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let base = CGPoint(x: size.width / 2, y: size.height * 0.72)
        let smoke = fire.roaring
        for s in sparks {
            let l = s.life
            let col = smoke
                ? Color(red: 0.75, green: 0.68, blue: 0.62)
                : Color(red: 1.0, green: 0.35 + 0.5 * l, blue: 0.08 + 0.2 * l)
            add.glow(at: s.p, radius: s.r * CGFloat(0.4 + l), color: col, alpha: 0.5 * l)
        }
        let ember = fire.guttering ? 0.18 : 0.35 + 0.4 * fire.fuel
        add.glow(at: base, radius: 46, color: hue, alpha: ember)
        add.core(at: base, radius: 5, color: Color(red: 1, green: 0.85, blue: 0.6), alpha: 0.6 + 0.4 * fire.fuel)
        // The band, as two faint horizons the flame should live between.
        for f in [FireBand.band.lowerBound, FireBand.band.upperBound] {
            let y = base.y - CGFloat(f) * size.height * 0.55
            var line = Path()
            line.move(to: CGPoint(x: size.width * 0.3, y: y))
            line.addLine(to: CGPoint(x: size.width * 0.7, y: y))
            add.stroke(line, with: .color(hue.opacity(0.14)), lineWidth: 0.8)
        }
        let tended = fire.tended / FireBand.tendToKindle
        add.glow(at: CGPoint(x: size.width / 2, y: size.height * 0.45), radius: size.width * 0.6,
                 color: hue, alpha: 0.04 + 0.16 * tended)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        fire.feed(pressure: s.pressure)
        PlaySound.shared.tone(320, gain: 0.08, duration: 1.2,
                              partials: [(1, 1), (2.76, 0.4), (5.4, 0.2)])
        PlayHaptics.tap(0.4 + 0.5 * s.pressure)
    }
}

// MARK: Rain — Prāṇa · Sarva-Kāmapradā (kp 71)
//
// Breath as wind on water. A press calls the rain where the finger is; a slow
// sweep across the glass is an out-breath, and it leans the rain as wind; the
// phone's own tilt leans it too. Four long breaths and the rain softens to
// still water, and she is felt.

final class RainModel: PlayModel {
    private struct Drop { var p: CGPoint; var vy: CGFloat; var len: CGFloat; var a: Double }
    private var wind = RainWind()
    private var clock = FrameClock()
    private var drops: [Drop] = []
    private var ripples: [PlayRipple] = []
    private var fingers: [ObjectIdentifier: CGPoint] = [:]
    private var width: CGFloat = 1
    private var nextChime: Double = 0
    private var shownCalm: Double = 0
    private static let chimes: [Double] = [426, 480, 568, 640]

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        width = max(1, size.width)
        wind.decay(dt: dt)
        let lean = CGFloat(wind.wind + motion.roll * 0.35)
        let calm = Double(wind.breaths) / Double(RainWind.breathsToCalm)
        shownCalm += (calm - shownCalm) * min(1, dt)
        let rate = (1 - 0.7 * shownCalm) * (2 + Double(fingers.count) * 6)
        let spawn = Int(rate) + (Double.random(in: 0...1) < rate.truncatingRemainder(dividingBy: 1) ? 1 : 0)
        for _ in 0..<spawn where drops.count < 500 {
            var x = CGFloat.random(in: 0...size.width)
            if let f = fingers.values.randomElement(), Double.random(in: 0...1) < 0.65 {
                x = f.x + CGFloat.random(in: -30...30)
            }
            drops.append(Drop(p: CGPoint(x: x, y: -10), vy: CGFloat.random(in: 380...600),
                              len: CGFloat.random(in: 8...16), a: Double.random(in: 0.15...0.5)))
        }
        var landed: [CGPoint] = []
        for i in drops.indices {
            drops[i].p.y += drops[i].vy * CGFloat(dt)
            drops[i].p.x += lean * drops[i].vy * CGFloat(dt)
            if drops[i].p.y > size.height - 30 { landed.append(drops[i].p) }
        }
        drops.removeAll { $0.p.y > size.height - 30 }
        for p in landed.prefix(6) {
            ripples.append(PlayRipple(center: CGPoint(x: p.x, y: size.height - 30), born: now,
                                      color: Color(red: 0.6, green: 0.8, blue: 1), life: 1.1, reach: 22))
        }
        ripples.removeAll { !$0.alive(now) }
        if ripples.count > 160 { ripples.removeFirst(ripples.count - 160) }
        if !fingers.isEmpty, now >= nextChime {
            nextChime = now + 0.3
            if let hz = Self.chimes.randomElement() {
                PlaySound.shared.tone(hz, gain: 0.035, duration: 0.6)
            }
        }
        if wind.calm, shownCalm > 0.95 { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let lean = CGFloat(wind.wind)
        for d in drops {
            var p = Path()
            p.move(to: d.p)
            p.addLine(to: CGPoint(x: d.p.x - lean * d.len * 0.5, y: d.p.y - d.len))
            add.stroke(p, with: .color(hue.opacity(d.a)), lineWidth: 0.9)
        }
        for r in ripples {
            let ph = r.phase(now)
            guard ph < 1 else { continue }
            let rr = 2 + r.reach * CGFloat(ph)
            add.stroke(Path(ellipseIn: CGRect(x: r.center.x - rr, y: r.center.y - rr * 0.35, width: rr * 2, height: rr * 0.7)),
                       with: .color(hue.opacity(0.4 * (1 - ph))), lineWidth: 0.7)
        }
        // The water, stilling with each breath.
        let surface = size.height - 30
        add.glow(at: CGPoint(x: size.width / 2, y: surface), radius: size.width * 0.7,
                 color: hue, alpha: 0.06 + 0.22 * shownCalm)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        fingers[s.id] = s.location
        wind.began(at: s.time)
        PlayHaptics.tap(0.2)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        if let prev = fingers[s.id] {
            wind.push(dx: Double((s.location.x - prev.x) / width))
        }
        fingers[s.id] = s.location
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        fingers[s.id] = nil
        if wind.ended(at: s.time) {
            PlaySound.shared.tone(213, gain: 0.1, duration: 3.2, partials: [(1, 1), (1.5, 0.3), (2, 0.2)])
            PlayHaptics.tap(0.5)
        }
    }
}
