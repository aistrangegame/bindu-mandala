import SwiftUI

// MARK: - Wave 6 · Slice E — the growing games: The Seed, Colour Rivers,
// Body Map, the World in a Box

/// Words drawn into a game's light. One door for every line a Wave 6 game
/// draws, so the type is the same everywhere and nothing reaches the glass
/// but the string handed in.
enum PlayInk {
    ///
    /// The alpha is the caller's, held to 0…1. Every caller names its own: a
    /// settled line stands at 0.55 or more (FIDELITY rule 4); anything lower is
    /// a line still fading in or out on its way to that.
    static func text(_ s: String, size: CGFloat, alpha: Double, sanskrit: Bool = false) -> Text {
        let font = sanskrit ? AppFont.sanskrit(size) : AppFont.voice(size)
        let held = min(max(alpha, 0), 1)
        return Text(s).font(font).foregroundColor(Color.cream.opacity(held))
    }

    static func tinted(_ s: String, size: CGFloat, colour: Color, alpha: Double) -> Text {
        let held = min(max(alpha, 0), 1)
        return Text(s).font(AppFont.sanskrit(size)).foregroundColor(colour.opacity(held))
    }
}

// MARK: The Seed — Sarva-Bīja (kp 26)
//
// "The seed is not yours to grow. You only need to plant it." He presses the
// seed into the earth and stays; a still press sinks it, and the earth closes
// over it. It grows by real time while he is away — seed, sprout, sapling,
// tree, bloom — and the phone keeps the planting. Returning, he rests a
// finger on what has grown; a bloom hands him to her, and lets fall a new
// seed for the next planting. Nothing is ever uprooted.

final class SeedModel: PlayModel {
    private let store: PlayGardenStore
    private var press = SeedPress()
    private var clock = FrameClock()
    private var planting: SeedPlanting?
    private var touches: [ObjectIdentifier: CGPoint] = [:]
    private var lastMove: Double = -10
    private var finishAt: Double? = nil
    private var finishWith: PlayHandoff = .stillness
    private var closing: Double = 0
    private var ripples: [PlayRipple] = []
    private var position = 26

    init(store: PlayGardenStore) {
        self.store = store
        planting = store.growingSeed
    }

    private var hours: Double {
        guard let p = planting else { return 0 }
        return max(0, Date().timeIntervalSince(p.plantedAt)) / 3600
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        ripples.removeAll { !$0.alive(now) }
        let still = now - lastMove > 0.4 ? 1.0 : 0.15
        let was = press.planted
        press.step(dt: dt, pressing: !touches.isEmpty, stillness: still)
        if !was, press.planted { finish(now: now, size: size) }
        if finishAt != nil { closing = min(1, closing + dt * 0.8) }
        if let f = finishAt, now >= f {
            finishAt = nil
            session.complete(finishWith)
        }
    }

    private func finish(now: Double, size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height * 0.74)
        if planting == nil {
            planting = store.plant(at: position)
            finishWith = .stillness
            PlaySound.shared.thump(depth: 0.8)
            PlayHaptics.thump(0.6)
        } else if SeedGrowth.stage(hours: hours) == .bloom {
            // The bloom lets fall its seed: the next planting begins.
            _ = store.plant(at: position)
            finishWith = .recognition
            PlaySound.shared.tone(PlayModels.pointHz * 3, gain: 0.12, duration: 2.6,
                                  partials: [(1, 1), (1.5, 0.4), (2, 0.2)])
            PlayHaptics.bloom()
        } else {
            finishWith = .stillness
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.1, duration: 2.0)
            PlayHaptics.tap(0.5)
        }
        ripples.append(PlayRipple(center: c, born: now, color: Color.cream, life: 2.2, reach: 220))
        finishAt = now + 1.8
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let ground = size.height * 0.74
        let cx = size.width / 2
        ctx.fill(Path(CGRect(x: 0, y: ground, width: size.width, height: size.height - ground)),
                 with: .linearGradient(Gradient(colors: [Color(red: 0.30, green: 0.19, blue: 0.09).opacity(0.38),
                                                         Color(red: 0.10, green: 0.06, blue: 0.03).opacity(0.10)]),
                                       startPoint: CGPoint(x: 0, y: ground),
                                       endPoint: CGPoint(x: 0, y: size.height)))
        var add = ctx
        add.blendMode = .plusLighter
        var soil = Path()
        soil.move(to: CGPoint(x: size.width * 0.12, y: ground))
        soil.addLine(to: CGPoint(x: size.width * 0.88, y: ground))
        add.stroke(soil, with: .color(Color(red: 0.75, green: 0.55, blue: 0.30).opacity(0.35)), lineWidth: 1.2)

        let sway = still ? 0 : CGFloat(sin(breath * 0.9)) * 3
        if planting != nil {
            let g = SeedGrowth.growth(hours: hours)
            let stage = SeedGrowth.stage(hours: hours)
            if stage == .seed {
                let p = CGPoint(x: cx, y: ground + 8)
                add.glow(at: p, radius: 26, color: hue, alpha: 0.35)
                add.core(at: p, radius: 4, color: Color.cream, alpha: 0.8)
            } else {
                let h = CGFloat(g) * size.height * 0.40
                let top = CGPoint(x: cx + sway, y: ground - h)
                var stem = Path()
                stem.move(to: CGPoint(x: cx, y: ground))
                stem.addQuadCurve(to: top, control: CGPoint(x: cx - sway * 2, y: ground - h * 0.5))
                add.stroke(stem, with: .color(hue.opacity(0.7)), lineWidth: 1.4 + 3 * CGFloat(g))
                let pairs = stage == .sprout ? 1 : (stage == .sapling ? 3 : 5)
                for k in 0..<pairs {
                    let u = CGFloat(k + 1) / CGFloat(pairs + 1)
                    let y = ground - h * u
                    let spread = 14 + 18 * CGFloat(g) * (1 - u * 0.5)
                    add.glow(at: CGPoint(x: cx - spread + sway * u, y: y), radius: 12 + 8 * CGFloat(g), color: hue, alpha: 0.32)
                    add.glow(at: CGPoint(x: cx + spread + sway * u, y: y - 6), radius: 12 + 8 * CGFloat(g), color: hue, alpha: 0.32)
                }
                if stage == .tree || stage == .bloom {
                    add.glow(at: top, radius: 60 + 50 * CGFloat(g), color: hue, alpha: 0.26)
                }
                if stage == .bloom {
                    let blossom = Color(red: 0.97, green: 0.70, blue: 0.80)
                    for k in 0..<7 {
                        let a = Double(k) / 7 * 2 * Double.pi + breath * 0.05
                        let p = CGPoint(x: top.x + CGFloat(cos(a)) * 34, y: top.y + CGFloat(sin(a)) * 24)
                        add.glow(at: p, radius: 10, color: blossom, alpha: 0.6)
                        add.core(at: p, radius: 2.4, color: Color.cream, alpha: 0.9)
                    }
                }
            }
        } else {
            // The seed in the open hand of the earth, waiting.
            let p = CGPoint(x: cx, y: ground - 10 + CGFloat(press.sunk) * 22)
            add.glow(at: p, radius: 30, color: hue, alpha: 0.4 * (1 - 0.6 * press.sunk))
            add.core(at: p, radius: 4.5, color: Color.cream, alpha: 0.9 * (1 - 0.5 * press.sunk))
        }
        for p in touches.values {
            add.glow(at: p, radius: 40 + 50 * CGFloat(press.sunk), color: Color.cream, alpha: 0.15 + 0.3 * press.sunk)
        }
        if closing > 0 {
            add.glow(at: CGPoint(x: cx, y: ground), radius: 80 + 200 * CGFloat(closing), color: hue, alpha: 0.3 * closing)
        }
        for r in ripples { r.draw(in: add, now: now) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil else { return }
        session.acted()
        touches[s.id] = s.location
        lastMove = s.time
        PlaySound.shared.thump(depth: 0.3 + 0.4 * s.pressure)
        PlayHaptics.tap(0.3 + 0.3 * s.pressure)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let p = touches[s.id] else { return }
        if hypot(s.location.x - p.x, s.location.y - p.y) > 12 {
            touches[s.id] = s.location
            lastMove = s.time
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        touches[s.id] = nil
    }
}

// MARK: Colour Rivers — Sarva-Vidrāviṇī (kp 20)
//
// Melting. Each finger pours a river of one colour; the rivers run downhill
// and spread, and where two colours meet they mix as light mixes. When the
// waters have mingled enough to reach the sea, she is felt. A finger that
// pours too fast only splashes — the river runs on.

final class ColourRiversModel: PlayModel {
    private struct Drop { var p: CGPoint; var v: CGVector; var colour: Int; var born: Double }

    private static let palette: [(Double, Double, Double)] = [
        (0.97, 0.66, 0.30), (0.90, 0.45, 0.62), (0.40, 0.66, 0.96), (0.50, 0.86, 0.60),
    ]

    private var drops: [Drop] = []
    private var mingle = RiverMingle()
    private var clock = FrameClock()
    private var pouring: [ObjectIdentifier: (colour: Int, at: CGPoint)] = [:]
    private var nextColour = 0
    private var lastTone: Double = 0
    private var sea: Double = 0
    private var done = false

    private static func colour(_ i: Int, _ a: Double) -> Color {
        let c = palette[((i % palette.count) + palette.count) % palette.count]
        return Color(red: c.0, green: c.1, blue: c.2).opacity(a)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        drops.removeAll { now - $0.born > 10 }
        for i in drops.indices {
            drops[i].v.dy += CGFloat(22 * dt)
            drops[i].v.dx *= CGFloat(pow(0.4, dt))
            drops[i].v.dy *= CGFloat(pow(0.6, dt))
            drops[i].p.x += drops[i].v.dx * CGFloat(dt)
            drops[i].p.y += drops[i].v.dy * CGFloat(dt)
            if drops[i].p.y > size.height - 30 {
                drops[i].p.y = size.height - 30
                drops[i].v.dy = 0
            }
        }
        // Where colours meet: a coarse grid of the glass.
        let cols = 10, rows = 18
        var cells = [Int](repeating: 0, count: cols * rows)
        for d in drops {
            let cx = min(cols - 1, max(0, Int(d.p.x / max(1, size.width) * CGFloat(cols))))
            let cy = min(rows - 1, max(0, Int(d.p.y / max(1, size.height) * CGFloat(rows))))
            cells[cy * cols + cx] |= 1 << (d.colour % Self.palette.count)
        }
        var wet = 0, met = 0
        for m in cells where m != 0 {
            wet += 1
            if m & (m - 1) != 0 { met += 1 }
        }
        let overlap = wet > 0 ? Double(met) / Double(wet) : 0
        mingle.flow(overlap: overlap * 2.2, dt: dt)
        sea += (mingle.mingled - sea) * min(1, dt * 2)
        if mingle.reachedSea, !done {
            done = true
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.14, duration: 3.0,
                                  partials: [(1, 1), (1.25, 0.4), (1.5, 0.3)])
            session.complete(.recognition)
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        // The sea the rivers run to, rising as they mingle.
        let seaTop = size.height - 30 - CGFloat(sea) * size.height * 0.18
        add.fill(Path(CGRect(x: 0, y: seaTop, width: size.width, height: size.height - seaTop)),
                 with: .linearGradient(Gradient(colors: [hue.opacity(0.04 + 0.16 * sea), Color.cream.opacity(0.02 + 0.1 * sea)]),
                                       startPoint: CGPoint(x: 0, y: seaTop),
                                       endPoint: CGPoint(x: 0, y: size.height)))
        for d in drops {
            let age = now - d.born
            let a = max(0, 1 - age / 10) * 0.3
            let r = CGFloat(5 + min(10, age * 2))
            add.fill(Path(ellipseIn: CGRect(x: d.p.x - r, y: d.p.y - r, width: r * 2, height: r * 2)),
                     with: .color(Self.colour(d.colour, a)))
        }
        for (_, p) in pouring {
            add.glow(at: p.at, radius: 34, color: Self.colour(p.colour, 1), alpha: 0.5)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard !done else { return }
        session.acted()
        let c = nextColour
        nextColour += 1
        pouring[s.id] = (colour: c, at: s.location)
        pour(at: s.location, v: CGVector(dx: 0, dy: 20), colour: c, now: s.time, n: 4)
        PlaySound.shared.tone(220 * [1.0, 1.25, 1.5, 1.875][c % 4], gain: 0.06, duration: 1.4)
        PlayHaptics.tap(0.3)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard !done, let p = pouring[s.id] else { return }
        let dx = s.location.x - p.at.x, dy = s.location.y - p.at.y
        let travel = hypot(dx, dy)
        guard travel > 4 else { return }
        // A rush splashes: the drops scatter instead of running as a river.
        let rushed = travel > 40
        let v = rushed ? CGVector(dx: CGFloat.random(in: -60...60), dy: CGFloat.random(in: -60...60))
                       : CGVector(dx: dx * 6, dy: dy * 6)
        pour(at: s.location, v: v, colour: p.colour, now: s.time, n: rushed ? 1 : 3)
        pouring[s.id] = (colour: p.colour, at: s.location)
        if s.time - lastTone > 0.22 {
            lastTone = s.time
            PlaySound.shared.tone(220 * [1.0, 1.25, 1.5, 1.875][p.colour % 4] * 2, gain: 0.025, duration: 0.6)
            PlayHaptics.tick()
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        pouring[s.id] = nil
    }

    private func pour(at p: CGPoint, v: CGVector, colour: Int, now: Double, n: Int) {
        for _ in 0..<n {
            drops.append(Drop(p: CGPoint(x: p.x + CGFloat.random(in: -6...6), y: p.y + CGFloat.random(in: -6...6)),
                              v: CGVector(dx: v.dx + CGFloat.random(in: -10...10), dy: v.dy + CGFloat.random(in: -10...10)),
                              colour: colour, born: now))
        }
        if drops.count > 520 { drops.removeFirst(drops.count - 520) }
    }
}

// MARK: Body Map — Vision · Sarvajñā (kp 77)
//
// Where is it felt right now? The ten body centres stand on one line of
// light, foot to crown (The Map's Body system, in its own order). He rests a
// finger on a centre and presses as it feels: a light touch is energy and the
// centre blooms; a firm press is holding, a knot of light simply there; a
// touch with no weight is open space. Every mark is welcome. When each
// centre has been listened to, she is felt.

final class BodyMapModel: PlayModel {
    static let centres = ["Soles", "Forge", "Prāṇa", "Hands", "Pulse",
                          "Sonar", "Echo", "Vision", "Axis", "Crow"]

    private var marks: [Int: BodyMark] = [:]
    private var resting: [ObjectIdentifier: (centre: Int, since: Double, sum: Double, samples: Int, at: CGPoint)] = [:]
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var finishAt: Double? = nil
    private var ripples: [PlayRipple] = []
    private var bornAt: [Int: Double] = [:]

    private func point(_ i: Int) -> CGPoint {
        let top = size.height * 0.12, bottom = size.height * 0.86
        let y = bottom - CGFloat(i) / CGFloat(Self.centres.count - 1) * (bottom - top)
        return CGPoint(x: size.width / 2, y: y)
    }

    private func centre(near p: CGPoint) -> Int? {
        var best: Int? = nil
        var bestD = CGFloat.greatestFiniteMagnitude
        for i in Self.centres.indices {
            let d = hypot(point(i).x - p.x, point(i).y - p.y)
            if d < bestD { bestD = d; best = i }
        }
        return bestD < 44 ? best : nil
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        _ = clock.tick(now)
        self.size = size
        ripples.removeAll { !$0.alive(now) }
        for (id, r) in resting {
            let mean = r.samples > 0 ? r.sum / Double(r.samples) : 0
            if let m = BodyListening.mark(meanPressure: mean, rested: now - r.since), marks[r.centre] != m {
                marks[r.centre] = m
                bornAt[r.centre] = now
                answer(m, at: point(r.centre), now: now)
                resting[id] = (centre: r.centre, since: now + 1000, sum: 0, samples: 0, at: r.at)
            }
        }
        if finishAt == nil, marks.keys.count >= Self.centres.count {
            finishAt = now + 1.8
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.recognition) }
    }

    private func answer(_ m: BodyMark, at p: CGPoint, now: Double) {
        switch m {
        case .alive:
            PlaySound.shared.tone(384, gain: 0.1, duration: 1.8, partials: [(1, 1), (2, 0.3)])
            PlayHaptics.tap(0.5)
        case .held:
            PlaySound.shared.thump(depth: 0.7)
            PlayHaptics.thump(0.5)
        case .open:
            PlaySound.shared.tone(768, gain: 0.04, duration: 2.4, partials: [(1, 1), (1.5, 0.3)])
            PlayHaptics.tap(0.2)
        }
        ripples.append(PlayRipple(center: p, born: now, color: Color.cream, life: 1.6, reach: 90))
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        var axis = Path()
        axis.move(to: point(0))
        axis.addLine(to: point(Self.centres.count - 1))
        add.stroke(axis, with: .color(hue.opacity(0.2)), lineWidth: 1)
        let b = still ? 0.5 : 0.5 + 0.5 * sin(breath * 1.3)
        for i in Self.centres.indices {
            let p = point(i)
            let fresh = bornAt[i].map { exp(-(now - $0) * 1.5) } ?? 0
            switch marks[i] {
            case .alive?:
                add.glow(at: p, radius: 40 + 8 * CGFloat(b) + 30 * CGFloat(fresh), color: Color(red: 0.98, green: 0.80, blue: 0.50), alpha: 0.5)
                add.core(at: p, radius: 4, color: Color.cream, alpha: 0.95)
            case .held?:
                add.stroke(Path(ellipseIn: CGRect(x: p.x - 12, y: p.y - 12, width: 24, height: 24)),
                           with: .color(hue.opacity(0.75)), lineWidth: 2.2)
                add.glow(at: p, radius: 22, color: hue, alpha: 0.35)
            case .open?:
                let r: CGFloat = 34 + 6 * CGFloat(b)
                add.stroke(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                           with: .color(Color.cream.opacity(0.22)), lineWidth: 0.8)
            case nil:
                add.glow(at: p, radius: 14, color: hue, alpha: 0.18)
                add.core(at: p, radius: 2.2, color: hue, alpha: 0.5)
            }
            var label = ctx
            label.opacity = 0.42
            label.draw(PlayInk.text(Self.centres[i], size: 13, alpha: 1), at: CGPoint(x: p.x + 58, y: p.y), anchor: .leading)
        }
        for (_, r) in resting where r.since < now {
            let k = min(1, (now - r.since) / BodyListening.restToMark)
            add.glow(at: point(r.centre), radius: 20 + 30 * CGFloat(k), color: Color.cream, alpha: 0.12 + 0.3 * k)
        }
        for r in ripples { r.draw(in: add, now: now) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil, let i = centre(near: s.location) else { return }
        session.acted()
        resting[s.id] = (centre: i, since: s.time, sum: s.pressure, samples: 1, at: s.location)
        PlayHaptics.tick()
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let r = resting[s.id] else { return }
        if hypot(s.location.x - r.at.x, s.location.y - r.at.y) > 30 {
            if let i = centre(near: s.location) {
                resting[s.id] = (centre: i, since: s.time, sum: s.pressure, samples: 1, at: s.location)
            } else {
                resting[s.id] = nil
            }
            return
        }
        resting[s.id] = (centre: r.centre, since: r.since, sum: r.sum + s.pressure, samples: r.samples + 1, at: r.at)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        resting[s.id] = nil
    }
}

// MARK: The World in a Box — Lalitā's field as a living world (ring 9)
//
// Every practice leaves an object, never a total. The box holds one thing
// for every game he has played — a plant for the garden, a cloud for the
// rain, a firefly for the garland, a tree for the seed — standing where it
// was set. Gifts arrive while he is away. He tilts the box to turn the world
// and touches what has arrived to gather it in; with nothing new, the point
// in the middle is the day's own gift.

final class WorldInABoxModel: PlayModel {
    private struct Thing { let kind: WorldBox.Thing; let x: Double; let z: Double; let seed: Double }

    private let store: PlayGardenStore
    private var things: [Thing] = []
    private var gifts: [(x: Double, z: Double, gathered: Bool)] = []
    private var yaw: Double = 0
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var finishAt: Double? = nil
    private var dragYaw: (start: CGFloat, yaw: Double)? = nil
    private var ripples: [PlayRipple] = []

    init(store: PlayGardenStore) {
        self.store = store
        let traces = store.traces.suffix(240)
        for (i, t) in traces.enumerated() {
            let spot = WorldBox.place(i)
            things.append(Thing(kind: WorldBox.thing(forGame: t.game), x: spot.x, z: spot.z,
                                seed: Double(i) * 0.731))
        }
        let n = WorldBox.gifts(lastVisit: store.worldVisitedAt, now: Date())
        if n == 0 {
            gifts = [(x: 0.5, z: 0.5, gathered: false)]
        } else {
            for k in 0..<n {
                let a = Double(k) * 2.1 + 0.4
                gifts.append((x: 0.5 + 0.42 * cos(a), z: 0.5 + 0.42 * sin(a), gathered: false))
            }
        }
    }

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.52) }
    private var span: CGFloat { min(size.width, size.height) * 0.40 }

    /// The box's floor, seen from above and in front, turned by `yaw`.
    private func screen(x: Double, z: Double, lift: Double = 0) -> CGPoint {
        let px = x - 0.5, pz = z - 0.5
        let rx = px * cos(yaw) - pz * sin(yaw)
        let rz = px * sin(yaw) + pz * cos(yaw)
        return CGPoint(x: centre.x + CGFloat(rx) * span * 2,
                       y: centre.y + CGFloat(rz) * span * 0.9 - CGFloat(lift) * span)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        ripples.removeAll { !$0.alive(now) }
        if dragYaw == nil {
            let target = motion.roll * 0.9
            yaw += (target - yaw) * min(1, dt * 1.5)
        }
        if finishAt == nil, !gifts.isEmpty, gifts.allSatisfy({ $0.gathered }) {
            finishAt = now + 2.4
            store.visitWorld()
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        // The glass box: its floor and its four standing edges.
        let corners = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)]
        var floor = Path()
        for (i, c) in corners.enumerated() {
            let p = screen(x: c.0, z: c.1)
            if i == 0 { floor.move(to: p) } else { floor.addLine(to: p) }
        }
        floor.closeSubpath()
        add.fill(floor, with: .color(hue.opacity(0.05)))
        add.stroke(floor, with: .color(hue.opacity(0.35)), lineWidth: 1)
        for c in corners {
            var edge = Path()
            edge.move(to: screen(x: c.0, z: c.1))
            edge.addLine(to: screen(x: c.0, z: c.1, lift: 0.55))
            add.stroke(edge, with: .color(hue.opacity(0.16)), lineWidth: 0.8)
        }
        // Everything he has played, standing where it was set — far first.
        let order = things.indices.sorted { screen(x: things[$0].x, z: things[$0].z).y < screen(x: things[$1].x, z: things[$1].z).y }
        for i in order {
            drawThing(things[i], in: add, now: now, breath: still ? 0 : breath, hue: hue)
        }
        // What arrived while he was away.
        let b = still ? 0.5 : 0.5 + 0.5 * sin(breath * 2)
        for g in gifts where !g.gathered {
            let p = screen(x: g.x, z: g.z, lift: 0.05)
            add.glow(at: p, radius: 26 + 8 * CGFloat(b), color: Color.cream, alpha: 0.4)
            add.core(at: p, radius: 3.5, color: Color.cream, alpha: 0.95)
        }
        for r in ripples { r.draw(in: add, now: now) }
    }

    private func drawThing(_ t: Thing, in add: GraphicsContext, now: Double, breath: Double, hue: Color) {
        let base = screen(x: t.x, z: t.z)
        switch t.kind {
        case .plant:
            let top = screen(x: t.x, z: t.z, lift: 0.08)
            var p = Path(); p.move(to: base); p.addLine(to: top)
            add.stroke(p, with: .color(Color(red: 0.6, green: 0.85, blue: 0.5).opacity(0.6)), lineWidth: 1.2)
            add.glow(at: top, radius: 7, color: Color(red: 0.75, green: 0.95, blue: 0.5), alpha: 0.6)
        case .cloud:
            let p = screen(x: t.x, z: t.z, lift: 0.42 + 0.02 * sin(breath * 0.3 + t.seed))
            add.glow(at: p, radius: 22, color: Color(red: 0.7, green: 0.82, blue: 0.97), alpha: 0.22)
        case .drum:
            add.stroke(Path(ellipseIn: CGRect(x: base.x - 7, y: base.y - 3.5, width: 14, height: 7)),
                       with: .color(Color(red: 0.95, green: 0.7, blue: 0.45).opacity(0.6)), lineWidth: 1.2)
        case .firefly:
            let p = screen(x: t.x + 0.02 * sin(breath * 0.7 + t.seed), z: t.z, lift: 0.15 + 0.08 * sin(breath * 0.5 + t.seed))
            let blink = 0.5 + 0.5 * sin(breath * 2.3 + t.seed * 5)
            add.glow(at: p, radius: 6, color: Color(red: 0.95, green: 0.9, blue: 0.5), alpha: 0.6 * blink)
        case .tree:
            let top = screen(x: t.x, z: t.z, lift: 0.2)
            var p = Path(); p.move(to: base); p.addLine(to: top)
            add.stroke(p, with: .color(Color(red: 0.7, green: 0.55, blue: 0.35).opacity(0.6)), lineWidth: 2)
            add.glow(at: top, radius: 20, color: Color(red: 0.5, green: 0.9, blue: 0.74), alpha: 0.4)
        case .letter:
            add.stroke(Path(CGRect(x: base.x - 6, y: base.y - 9, width: 12, height: 8)),
                       with: .color(Color(red: 0.6, green: 0.8, blue: 0.95).opacity(0.6)), lineWidth: 1)
        case .gate:
            add.stroke(DoorModel.arch(center: CGPoint(x: base.x, y: base.y - 9), width: 10, height: 18),
                       with: .color(hue.opacity(0.6)), lineWidth: 1)
        case .flame:
            let p = screen(x: t.x, z: t.z, lift: 0.04)
            add.glow(at: p, radius: 10 + 2 * CGFloat(sin(breath * 6 + t.seed)), color: Color(red: 0.98, green: 0.65, blue: 0.3), alpha: 0.6)
        case .shell:
            add.stroke(Path(ellipseIn: CGRect(x: base.x - 5, y: base.y - 5, width: 10, height: 10)),
                       with: .color(Color.gold.opacity(0.6)), lineWidth: 1)
            add.core(at: base, radius: 1.5, color: Color.gold, alpha: 0.8)
        case .stone:
            add.core(at: base, radius: 3, color: Color.cream, alpha: 0.45)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil else { return }
        session.acted()
        for i in gifts.indices where !gifts[i].gathered {
            let p = screen(x: gifts[i].x, z: gifts[i].z, lift: 0.05)
            if hypot(p.x - s.location.x, p.y - s.location.y) < 44 {
                gifts[i].gathered = true
                things.append(Thing(kind: .stone, x: 0.5 + (gifts[i].x - 0.5) * 0.6,
                                    z: 0.5 + (gifts[i].z - 0.5) * 0.6, seed: Double(i)))
                ripples.append(PlayRipple(center: p, born: s.time, color: Color.cream, life: 1.6, reach: 120))
                PlaySound.shared.tone(PlayModels.pointHz * 3, gain: 0.1, duration: 1.8)
                PlayHaptics.tap(0.6)
                return
            }
        }
        dragYaw = (start: s.location.x, yaw: yaw)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let d = dragYaw else { return }
        yaw = d.yaw + Double(s.location.x - d.start) * 0.006
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        dragYaw = nil
    }
}
