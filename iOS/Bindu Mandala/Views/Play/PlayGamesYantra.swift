import SwiftUI

// MARK: - Wave 4 · the yantra games: Śrī Yantra, the Garland, Bīja Tones

// MARK: Śrī Yantra — the Bindu · Mahātripurasundarī (kp 102)
//
// Drawing her address line by line. The nine triangles at their true
// proportion (`MandalaYantra.triangles`), drawn outward from the point the way
// the yantra draws itself in the Homecoming: one edge at a time, from the
// glowing end to the hollow one. A stroke that strays simply fades; the lines
// already drawn stay drawn. When the last line closes, the whole yantra
// lights and she is felt.

final class YantraTraceModel: PlayModel {
    private let edges = YantraTrace.edges(MandalaYantra.triangles)
    private var drawn = 0
    private var stroke: [CGPoint] = []
    private var fading: [(points: [CGPoint], born: Double)] = []
    private var lastLine: Double = -10
    private var size: CGSize = .zero
    private var completeAt: Double? = nil

    private var scale: CGFloat {
        min(size.width, size.height) * 0.46 / (MandalaWorld.radius * SriYantraGeometry.triangleProportion)
    }

    private var origin: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.47) }

    private func screen(_ p: CGPoint) -> CGPoint {
        CGPoint(x: origin.x + p.x * scale, y: origin.y + p.y * scale)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        self.size = size
        fading.removeAll { now - $0.born > 0.8 }
        if drawn >= edges.count, completeAt == nil { completeAt = now + 1.6 }
        if let c = completeAt, now >= c { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let whole = drawn >= edges.count
        // The whole address, faint, so he can see where he is going.
        for (i, e) in edges.enumerated() {
            var p = Path()
            p.move(to: screen(e.0))
            p.addLine(to: screen(e.1))
            if i < drawn {
                add.stroke(p, with: .color(hue.opacity(whole ? 0.95 : 0.8)), lineWidth: whole ? 2.2 : 1.8)
            } else {
                add.stroke(p, with: .color(hue.opacity(0.09)), lineWidth: 0.8)
            }
        }
        if drawn < edges.count {
            let e = edges[drawn]
            let a = screen(e.0), b = screen(e.1)
            var guide = Path()
            guide.move(to: a)
            guide.addLine(to: b)
            add.stroke(guide, with: .color(hue.opacity(0.28)), style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
            let b2 = still ? 0.5 : 0.5 + 0.5 * sin(breath * 2.4)
            add.glow(at: a, radius: 18 + 4 * CGFloat(b2), color: hue, alpha: 0.7)
            add.core(at: a, radius: 3.5, color: Color.cream, alpha: 0.95)
            add.stroke(Path(ellipseIn: CGRect(x: b.x - 6, y: b.y - 6, width: 12, height: 12)),
                       with: .color(Color.cream.opacity(0.6)), lineWidth: 1)
        }
        if stroke.count > 1 {
            var p = Path()
            p.move(to: stroke[0])
            for q in stroke.dropFirst() { p.addLine(to: q) }
            add.stroke(p, with: .color(Color.cream.opacity(0.55)), lineWidth: 2)
        }
        for f in fading where f.points.count > 1 {
            var p = Path()
            p.move(to: f.points[0])
            for q in f.points.dropFirst() { p.addLine(to: q) }
            add.stroke(p, with: .color(Color.cream.opacity(0.4 * max(0, 1 - (now - f.born) / 0.8))), lineWidth: 1.6)
        }
        let flash = exp(-(now - lastLine) * 3)
        add.glow(at: origin, radius: 40 + 200 * CGFloat(Double(drawn) / Double(max(1, edges.count))),
                 color: hue, alpha: 0.08 + 0.2 * flash + (whole ? 0.35 : 0))
        add.core(at: origin, radius: 3, color: Color.cream, alpha: 0.95)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard drawn < edges.count else { return }
        session.acted()
        stroke = [s.location]
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard !stroke.isEmpty else { return }
        stroke.append(s.location)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        guard drawn < edges.count, !stroke.isEmpty else { return }
        stroke.append(s.location)
        let e = edges[drawn]
        if YantraTrace.traces(stroke, edge: (screen(e.0), screen(e.1)), tolerance: 18) {
            let triangle = YantraTrace.triangleOrder[drawn / 3]
            let ring = MandalaYantra.ring(ofTriangle: triangle)
            drawn += 1
            lastLine = s.time
            PlaySound.shared.tone(AwakeningTones.frequency(ring: ring) ?? PlayModels.pointHz * 2,
                                  gain: 0.12, duration: 2.0)
            PlayHaptics.tap(0.5)
        } else {
            fading.append((points: stroke, born: s.time))
        }
        stroke = []
    }
}

// MARK: The Garland — all 102, every bead a Śakti
//
// Japa where position is identity you can touch. The thread hangs in a loop
// with the bead under his thumb at the foot; a pull draws the next bead down,
// with a tick in the hand and her ring's own tone. A pull too quick slips and
// the bead stays. Resting a still finger on the thread hands to the Śakti of
// that bead; a whole round, home again, goes quiet.

final class RosaryModel: PlayModel {
    private var rosary: Rosary
    private var shown: Double = 0               // beads turned, eased, for the loop's motion
    private var clock = FrameClock()
    private var press: (start: CGPoint, at: Double, pulled: Bool)? = nil
    private var restingSince: Double? = nil

    init(startingAt kp: Int) {
        rosary = Rosary(startingAt: kp)
    }

    var hasCaption: Bool { true }

    func caption(names: [Int: String]) -> String {
        names[rosary.bead] ?? ""
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        shown += (Double(rosary.turned) - shown) * min(1, dt * 8)
        if let p = press, !p.pulled, now - p.at >= Rosary.restToFeel {
            press = nil
            session.complete(.recognition, at: rosary.bead)
        }
        if rosary.roundComplete { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
        let rx = size.width * 0.40, ry = size.height * 0.30
        let n = Double(KhadgamalaMap.total)
        let slide = (shown - Double(rosary.turned))     // −1 … 0 while a bead is still falling
        var thread = Path()
        thread.addEllipse(in: CGRect(x: c.x - rx, y: c.y - ry, width: rx * 2, height: ry * 2))
        add.stroke(thread, with: .color(hue.opacity(0.16)), lineWidth: 0.8)
        for kp in 1...KhadgamalaMap.total {
            let ph = rosary.phase(of: kp) + slide / n
            let a = Double.pi / 2 + ph * 2 * Double.pi       // the current bead at the foot
            let p = CGPoint(x: c.x + rx * CGFloat(cos(a)), y: c.y + ry * CGFloat(sin(a)))
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let isCurrent = kp == rosary.bead
            let isMeru = ring == 9
            let r: CGFloat = isCurrent ? 9 : (isMeru ? 6 : 3.2)
            add.glow(at: p, radius: r * 3, color: isMeru ? Color.gold : hue, alpha: isCurrent ? 0.7 : 0.18)
            add.core(at: p, radius: r * 0.55, color: isCurrent ? Color.cream : hue, alpha: isCurrent ? 1 : 0.6)
        }
        if let pr = press, !pr.pulled {
            let held = min(1, (now - pr.at) / Rosary.restToFeel)
            let foot = CGPoint(x: c.x, y: c.y + ry)
            add.glow(at: foot, radius: 30 + 60 * CGFloat(held), color: Color.cream, alpha: 0.2 + 0.4 * held)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        press = (start: s.location, at: s.time, pulled: false)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let p = press else { return }
        let dy = s.location.y - p.start.y
        let travel = hypot(s.location.x - p.start.x, dy)
        if dy > 26 {
            pull(at: s.time, session: session)
            press = (start: s.location, at: s.time, pulled: true)
        } else if travel > 12, !p.pulled {
            press = (start: p.start, at: s.time, pulled: false)   // moving is not resting
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        if let p = press, !p.pulled, s.time - p.at < 0.35 {
            pull(at: s.time, session: session)                     // a tap is a pull too
        }
        press = nil
    }

    private func pull(at t: Double, session: PlaySession) {
        guard rosary.pull(at: t) else {
            PlayHaptics.tap(0.12)                                  // it slipped
            return
        }
        session.rest(on: rosary.bead)
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: rosary.bead)
        PlaySound.shared.tone(AwakeningTones.frequency(ring: ring) ?? PlayModels.pointHz,
                              gain: 0.09, duration: 1.4)
        PlayHaptics.tick()
    }
}

// MARK: Bīja Tones — the walk's own Awakening table
//
// The Mantra Tuner, retuned. Nine rings of light; touching one sounds its
// Awakening tone as a drone and sets its pulse breathing in the light. Taps
// on the ring that land with its pulse tune it — the tone opens into its
// fifth — and the game goes quiet. The Bindu's ring has no tone: there the
// skill is to touch nothing at all.

final class BijaTonesModel: PlayModel {
    private var ring: Int? = nil
    private var taps: [Double] = []
    private var chosenAt: Double = 0
    private var size: CGSize = .zero
    private var tunedAt: Double? = nil
    private var lastTap: Double = -10

    private var center: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.46) }
    private var outer: CGFloat { min(size.width, size.height) * 0.46 }

    /// Ring r's band: from `radius(r + 1)` to `radius(r)`; ring 9 is the disc.
    private func radius(_ r: Int) -> CGFloat { outer * CGFloat(10 - r) / 9 }

    private func band(at p: CGPoint) -> Int? {
        let d = hypot(p.x - center.x, p.y - center.y)
        guard d <= outer else { return nil }
        for r in (1...9).reversed() where d <= radius(r) { return r }
        return nil
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        self.size = size
        guard let r = ring, tunedAt == nil else {
            if let t = tunedAt, now - t > 2.4 { session.complete(.stillness) }
            return
        }
        let tuned: Bool
        if r == 9 {
            tuned = now - max(chosenAt, lastTap) >= 9
        } else {
            tuned = AwakeningTones.isTuned(taps: taps, ring: r)
        }
        if tuned {
            tunedAt = now
            if let f = AwakeningTones.frequency(ring: r) {
                PlaySound.shared.tone(f, gain: 0.16, duration: 3.2, partials: [(1, 1), (1.5, 0.5), (2, 0.25)])
            }
            PlaySound.shared.droneGain(0)
            PlayHaptics.bloom()
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = center
        for r in 1...9 {
            let rad = radius(r)
            let chosen = r == ring
            var pulse = 0.0
            if chosen, let p = AwakeningTones.pulsePeriod(ring: r) {
                let ph = (now - chosenAt).truncatingRemainder(dividingBy: p) / p
                pulse = exp(-ph * 5)
            }
            let a = chosen ? 0.35 + 0.4 * pulse : 0.12
            add.stroke(Path(ellipseIn: CGRect(x: c.x - rad, y: c.y - rad, width: rad * 2, height: rad * 2)),
                       with: .color(hue.opacity(a)), lineWidth: chosen ? 2 + 2 * CGFloat(pulse) : 0.9)
        }
        if let r = ring {
            let tuned = tunedAt != nil
            add.glow(at: c, radius: radius(r) * (tuned ? 1.4 : 0.9), color: hue, alpha: tuned ? 0.45 : 0.14)
        }
        let tap = exp(-(now - lastTap) * 6)
        add.glow(at: c, radius: 24 + 30 * CGFloat(tap), color: Color.cream, alpha: 0.3 + 0.3 * tap)
        add.core(at: c, radius: 3, color: Color.cream, alpha: 0.95)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard tunedAt == nil, let touched = band(at: s.location) else { return }
        session.acted()
        if touched != ring {
            ring = touched
            chosenAt = s.time
            taps.removeAll()
            session.playing(ring: touched)
            if let f = AwakeningTones.frequency(ring: touched) {
                PlaySound.shared.drone(f / 2)
                PlaySound.shared.droneGain(0.18)
                PlaySound.shared.tone(f, gain: 0.12, duration: 2.2)
            } else {
                PlaySound.shared.droneGain(0)
            }
            PlayHaptics.tap(0.4)
            return
        }
        lastTap = s.time
        taps.append(s.time)
        if taps.count > 12 { taps.removeFirst() }
        if let f = AwakeningTones.frequency(ring: touched) {
            PlaySound.shared.tone(f, gain: 0.08, duration: 0.7, partials: [(1, 1), (2, 0.2)])
        }
        PlayHaptics.tap(0.3 + 0.4 * s.pressure)
    }
}
