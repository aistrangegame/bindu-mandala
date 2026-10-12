import SwiftUI

// MARK: - Wave 6 · Slice E — the year's own small practices: the Sandhyā,
// the Great Wheel (and the seasonal yantra at its heart)
//
// Light, never dashboards: the day's junction and the year's turning are each
// one gesture, read from Wave 5's ephemeris (`Panchanga.sunTimes`,
// `Panchanga.rtu`). No hour, date or count is drawn.

// MARK: The Sandhyā — the lotus that follows the sun (ring 2)
//
// Three small practices opened by the day's own sun (temporal.jsx,
// Instrument 3). At dawn he draws the horizon open, slowly upward: "Open the
// eyes before the world opens them for you." At noon he lays the phone open
// to the sky and lets it lie still, or rests a still finger: "The sun has
// nothing to hide." At dusk he presses and lowers the light, slowly: "What
// you carried today you may set down here." A rush carries only as much as a
// breath allows. Whole, the junction goes still.

final class SandhyaModel: PlayModel {
    private let practice: SandhyaPractice
    private var light = JunctionLight()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var drag: (start: CGFloat, base: Double)? = nil
    private var restingSince: Double? = nil
    private var lastMove: Double = -10
    private var openedAt: Double = PlayClock.now
    private var wholeAt: Double? = nil

    init(now: Date) {
        let sun = Panchanga.sunTimes(on: now, place: TemporalPlace.current(at: now))
        practice = SandhyaPractice.nearest(to: now, sun: sun)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        if practice == .noon, wholeAt == nil {
            let faceUp = motion.isAvailable && motion.gravityZ < -0.85 && motion.shake < 0.06
            let fingerStill = restingSince != nil && now - lastMove > 0.5
            if faceUp || fingerStill { light.gather(dt: dt, rate: 1.0 / 40) }
        }
        if light.isWhole, wholeAt == nil {
            wholeAt = now
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.12, duration: 3.2,
                                  partials: [(1, 1), (1.5, 0.4), (2, 0.2)])
            PlayHaptics.bloom()
        }
        if let w = wholeAt, now - w > 3.0 { session.complete(.stillness) }
    }

    private var sky: [Color] {
        switch practice {
        case .dawn: return [Color(red: 0.06, green: 0.02, blue: 0.06), Color(red: 0.28, green: 0.06, blue: 0.13),
                            Color(red: 0.78, green: 0.41, blue: 0.20)]
        case .noon: return [Color(red: 0.36, green: 0.30, blue: 0.20), Color(red: 0.70, green: 0.52, blue: 0.28),
                            Color(red: 0.72, green: 0.42, blue: 0.16)]
        case .dusk: return [Color(red: 0.02, green: 0.0, blue: 0.02), Color(red: 0.31, green: 0.06, blue: 0.13),
                            Color(red: 0.77, green: 0.25, blue: 0.19)]
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let level = light.level
        let horizon = size.height * 0.70
        // The sky warms as the practice is played.
        let warmth: Double = practice == .dusk ? 1 - level : level
        let skyAlpha: Double = 0.18 + 0.5 * warmth
        let sky: [Color] = self.sky.map { $0.opacity(skyAlpha) }
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .linearGradient(Gradient(colors: sky),
                                       startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)))
        var add = ctx
        add.blendMode = .plusLighter
        var line = Path()
        line.move(to: CGPoint(x: 0, y: horizon))
        line.addLine(to: CGPoint(x: size.width, y: horizon))
        add.stroke(line, with: .color(Color.cream.opacity(0.25)), lineWidth: 0.8)
        let sunY: CGFloat
        switch practice {
        case .dawn: sunY = horizon + 40 - CGFloat(level) * size.height * 0.30
        case .noon: sunY = size.height * 0.20
        case .dusk: sunY = horizon - size.height * 0.26 + CGFloat(level) * (size.height * 0.26 + 40)
        }
        let sun = CGPoint(x: size.width / 2, y: sunY)
        let strength = practice == .noon ? 0.3 + 0.7 * level : 0.75
        add.glow(at: sun, radius: 90 + (practice == .noon ? 120 * CGFloat(level) : 0), color: hue, alpha: 0.5 * strength)
        add.glow(at: sun, radius: 34, color: Color.cream, alpha: 0.6 * strength)
        // The ground hides what has sunk below it.
        ctx.fill(Path(CGRect(x: 0, y: horizon, width: size.width, height: size.height - horizon)),
                 with: .color(Color.black.opacity(0.55)))
        let words = min(1, max(0, 1 - (now - openedAt - 6) / 3))
        if words > 0 {
            var t = ctx
            t.opacity = words
            t.draw(PlayInk.text(practice.junction, size: 13, alpha: 0.7), at: CGPoint(x: size.width / 2, y: size.height * 0.08))
            t.draw(PlayInk.text(practice.invitation, size: 22, alpha: 0.85, sanskrit: true),
                   at: CGPoint(x: size.width / 2, y: size.height * 0.40))
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard wholeAt == nil else { return }
        session.acted()
        drag = (start: s.location.y, base: light.level)
        restingSince = s.time
        lastMove = s.time
        PlayHaptics.tap(0.25)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let d = drag else { return }
        lastMove = s.time
        let travel = Double((s.location.y - d.start) / max(1, size.height * 0.45))
        switch practice {
        case .dawn: light.carry(toward: d.base - travel, dt: 1.0 / 60)
        case .dusk: light.carry(toward: d.base + travel, dt: 1.0 / 60)
        case .noon: break
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        drag = nil
        restingSince = nil
    }
}

// MARK: The Great Wheel — the year as a wheel the point turns through (ring 1)
//
// The year is one circle: its six seasons as six soft sectors, the days he
// played as small lights on the rim (presence only — a day he did not play is
// simply space, never a dark slot). He spins the wheel and lets it go; it
// slows, and near rest it is drawn the last little way, so that today comes
// to the point at the top. There, the Śrī Yantra at its heart lights in the
// season's own colour — the seasonal yantra — with the season's two lines.

final class GreatWheelModel: PlayModel {
    private var spin: GreatWheel.Spin
    private let today: Double
    private let rtu: Panchanga.Rtu
    private let played: [Double]
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var holding: (angle: Double, time: Double)? = nil
    private var restAt: Double? = nil
    private var lastTick: Double = 0

    init(now: Date, store: PlayGardenStore) {
        today = GreatWheel.angle(of: now)
        rtu = Panchanga.rtu(at: now)
        spin = GreatWheel.Spin(turn: 2.4)
        let yearAgo = now.addingTimeInterval(-365 * 86_400)
        played = store.playedDays()
            .filter { $0 > yearAgo }
            .map { GreatWheel.angle(of: $0.addingTimeInterval(43_200)) }
    }

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.46) }
    private var radius: CGFloat { min(size.width, size.height) * 0.40 }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        spin.step(dt: dt, holding: holding != nil, today: today)
        let notch = (spin.turn / (Double.pi / 12)).rounded()
        if abs(notch - lastTick) >= 1 {
            lastTick = notch
            PlayHaptics.tick()
        }
        if restAt == nil, holding == nil, spin.resting(today: today) {
            restAt = now
            let c = SeasonLight.colour(rtu)
            _ = c
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.13, duration: 3.4,
                                  partials: [(1, 1), (1.5, 0.45), (2, 0.25)])
            PlayHaptics.bloom()
        }
        if let r = restAt, now - r > 4.5 { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = centre
        let rgb = SeasonLight.colour(rtu)
        let season = Color(red: rgb.0, green: rgb.1, blue: rgb.2)
        // The six seasons, Śiśira first from the solstice.
        for k in 0..<6 {
            guard let r = Panchanga.Rtu(rawValue: k) else { continue }
            let col = SeasonLight.colour(r)
            let a0 = -Double.pi / 2 + Double(k) / 6 * 2 * Double.pi + spin.turn
            var sector = Path()
            sector.move(to: c)
            sector.addArc(center: c, radius: radius, startAngle: .radians(a0),
                          endAngle: .radians(a0 + 2 * Double.pi / 6), clockwise: false)
            sector.closeSubpath()
            add.fill(sector, with: .color(Color(red: col.0, green: col.1, blue: col.2).opacity(r == rtu ? 0.12 : 0.05)))
        }
        add.stroke(Path(ellipseIn: CGRect(x: c.x - radius, y: c.y - radius, width: radius * 2, height: radius * 2)),
                   with: .color(hue.opacity(0.35)), lineWidth: 1)
        // The days he played: lights on the rim, nothing where he did not.
        for a in played {
            let p = CGPoint(x: c.x + (radius - 10) * CGFloat(cos(a + spin.turn)),
                            y: c.y + (radius - 10) * CGFloat(sin(a + spin.turn)))
            add.core(at: p, radius: 1.6, color: Color.cream, alpha: 0.55)
        }
        // Today, and the point it comes to rest beneath.
        let t = CGPoint(x: c.x + radius * CGFloat(cos(today + spin.turn)), y: c.y + radius * CGFloat(sin(today + spin.turn)))
        add.glow(at: t, radius: 18, color: Color.cream, alpha: 0.7)
        add.core(at: t, radius: 4, color: Color.cream, alpha: 1)
        let top = CGPoint(x: c.x, y: c.y - radius - 22)
        add.glow(at: top, radius: 12, color: Color.gold, alpha: 0.5)
        add.core(at: top, radius: 2.5, color: Color.gold, alpha: 0.9)
        // The seasonal yantra at the heart.
        let lit = restAt.map { min(1, (now - $0) / 2) } ?? 0
        let scale = radius * 0.42 / (MandalaWorld.radius * SriYantraGeometry.triangleProportion)
        let intensity = SeasonLight.intensity(rtu)
        for tri in MandalaYantra.triangles {
            var p = Path()
            p.move(to: CGPoint(x: c.x + tri.0.x * scale, y: c.y + tri.0.y * scale))
            p.addLine(to: CGPoint(x: c.x + tri.1.x * scale, y: c.y + tri.1.y * scale))
            p.addLine(to: CGPoint(x: c.x + tri.2.x * scale, y: c.y + tri.2.y * scale))
            p.closeSubpath()
            add.stroke(p, with: .color(season.opacity(min(1, (0.25 + 0.6 * lit) * intensity))), lineWidth: 1 + CGFloat(lit))
        }
        add.glow(at: c, radius: radius * 0.6, color: season, alpha: (0.08 + 0.3 * lit) * min(1.2, intensity))
        if lit > 0 {
            var w = ctx
            w.opacity = lit
            w.draw(PlayInk.text(rtu.name, size: 14, alpha: 0.7), at: CGPoint(x: c.x, y: c.y + radius + 40))
            w.draw(PlayInk.text(SeasonLight.poetry(rtu), size: 18, alpha: 0.8, sanskrit: true),
                   at: CGPoint(x: c.x, y: c.y + radius + 84))
        }
    }

    private func angle(_ p: CGPoint) -> Double {
        atan2(Double(p.y - centre.y), Double(p.x - centre.x))
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard restAt == nil else { return }
        session.acted()
        holding = (angle: angle(s.location), time: s.time)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let h = holding else { return }
        let a = angle(s.location)
        spin.drag(by: PlayMath.wrap(a - h.angle), dt: s.time - h.time)
        holding = (angle: a, time: s.time)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        holding = nil
    }
}
