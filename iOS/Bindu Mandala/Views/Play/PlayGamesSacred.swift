import SwiftUI

// MARK: - Wave 6 · Slice E — the Sacred Experiences, the japa and the bhakti:
// the Scrolls, Still · Ājñā, Tat Tvam Asi, Rām japa, Bhakti at Maṇipūra

// MARK: The Scrolls — Shadow, the 3 → 4 crossing
//
// The Shadow's own words (Sacred Experiences B): what was called too much,
// compressed and stored, waiting for a bigger container. He draws each
// scroll down slowly; a pull faster than a scroll unrolls carries only what
// the scroll can give. A container of light widens with every line, and at
// the last — "You are a bigger container now." — it opens past the glass and
// the crossing goes still.

final class ShadowScrollsModel: PlayModel {
    private var scroll = ScrollUnroll()
    private var clock = FrameClock()
    private var pull: (y: CGFloat, time: Double)? = nil
    private var shownLine = -1
    private var lineAt: Double = 0
    private var openAt: Double? = nil
    private var widen: Double = 0

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        let target = Double(scroll.line) / Double(ScrollUnroll.lines.count)
        widen += (target - widen) * min(1, dt * 1.5)
        if scroll.line - 1 > shownLine {
            shownLine = scroll.line - 1
            lineAt = now
            PlaySound.shared.tone(PlayModels.pointHz * (1 + 0.04 * Double(shownLine)), gain: 0.08, duration: 2.2,
                                  partials: [(1, 1), (2, 0.2)])
            PlayHaptics.tap(0.3)
        }
        if scroll.isOpen, openAt == nil {
            openAt = now
            PlayHaptics.bloom()
        }
        if let o = openAt, now - o > 4.2 { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.46)
        let opened = openAt.map { min(1, (now - $0) / 2.5) } ?? 0
        let r = 70 + CGFloat(widen) * min(size.width, size.height) * 0.32 + CGFloat(opened) * size.height
        add.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .color(hue.opacity(0.35 * (1 - opened))), lineWidth: 1.4)
        add.glow(at: c, radius: r * 0.9, color: hue, alpha: 0.06 + 0.12 * widen)
        guard shownLine >= 0 else {
            add.core(at: c, radius: 3, color: Color.cream, alpha: 0.6)
            return
        }
        // The newest line, and the two before it, quieter, rising away.
        for back in 0..<3 {
            let i = shownLine - back
            guard i >= 0 else { break }
            let line = ScrollUnroll.lines[i]
            let fresh = back == 0 ? min(1, (now - lineAt) / 1.0) : 1
            let a = (back == 0 ? 0.88 : 0.32 - 0.12 * Double(back)) * fresh
            ctx.draw(PlayInk.text(line, size: back == 0 ? 23 : 17, alpha: a, sanskrit: back == 0),
                     in: CGRect(x: 30, y: c.y - 24 - CGFloat(back) * 58, width: size.width - 60, height: 70))
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard openAt == nil else { return }
        session.acted()
        pull = (y: s.location.y, time: s.time)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let p = pull else { return }
        scroll.pull(dy: Double(s.location.y - p.y), dt: s.time - p.time)
        pull = (y: s.location.y, time: s.time)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        pull = nil
    }
}

// MARK: Still · Ājñā — Anaṅga-Aṅkuśā (kp 51)
//
// "What do I see when I stop looking? The screen will wait. Close your eyes."
// He rests his thumbs on the glass (or lays the phone still), and the screen
// goes dark and waits. The dark deepens only while he is still and never
// lifts again; a movement only lets a little light back in. When the dark
// is whole, one point appears, and she is felt.

final class StillAjnaModel: PlayModel {
    static let lines = ["What do I see\nwhen I stop looking?", "The screen will wait.\nClose your eyes."]

    private var dark = WaitingDark()
    private var clock = FrameClock()
    private var touches: [ObjectIdentifier: CGPoint] = [:]
    private var lastMove: Double = -10
    private var stirred: Double = 0
    private var pointAt: Double? = nil
    private var touchedOnce = false

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        let restingThumbs = !touches.isEmpty && now - lastMove > 0.6
        let restingPhone = touches.isEmpty && touchedOnce && motion.isAvailable && motion.shake < 0.04
        let still = restingThumbs || restingPhone
        if motion.shake > 0.25 { stirred = 1 }
        stirred = max(0, stirred - dt * 0.6)
        let was = dark.isDeep
        dark.step(dt: dt, still: still && pointAt == nil)
        if !was, dark.isDeep {
            pointAt = now
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.08, duration: 3.2)
            PlayHaptics.tap(0.3)
        }
        if let p = pointAt, now - p > 4.0 { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        let c = CGPoint(x: size.width / 2, y: size.height * 0.44)
        let light = (1 - dark.dark) * 0.9 + 0.1 * stirred
        var add = ctx
        add.blendMode = .plusLighter
        add.glow(at: c, radius: 200, color: hue, alpha: 0.18 * light)
        if dark.dark < 0.35 {
            let a = (0.35 - dark.dark) / 0.35
            ctx.draw(PlayInk.text(Self.lines[0], size: 26, alpha: 0.85 * a, sanskrit: true), at: CGPoint(x: c.x, y: c.y - 30))
            ctx.draw(PlayInk.text(Self.lines[1], size: 17, alpha: 0.45 * a), at: CGPoint(x: c.x, y: c.y + 50))
        }
        // The dark over everything.
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.black.opacity(0.92 * dark.dark)))
        if let p = pointAt {
            let k = min(1, (now - p) / 2.5)
            add.glow(at: c, radius: 40 * CGFloat(k), color: Color.cream, alpha: 0.5 * k)
            add.core(at: c, radius: 2.5, color: Color.cream, alpha: k)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        session.acted()
        touchedOnce = true
        touches[s.id] = s.location
        lastMove = s.time
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let p = touches[s.id] else { return }
        if hypot(s.location.x - p.x, s.location.y - p.y) > 10 {
            touches[s.id] = s.location
            lastMove = s.time
            stirred = min(1, stirred + 0.3)
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        touches[s.id] = nil
    }
}

// MARK: Tat Tvam Asi — Armin, the 6 → 7 crossing
//
// Arrive. Three words, each condensing out of the light while he holds for a
// breath — Tat, then Tvam, then Asi. Then two fingers brought together join
// them into one, "Tat Tvam Asi", and the aurora — the whole spectrum,
// ONE → ALL — fills the crossing. "Nothing needed repair." It goes still.

final class TatTvamAsiModel: PlayModel {
    static let after = "Nothing needed repair."

    private var three = ThreeWords()
    private var clock = FrameClock()
    private var touches: [ObjectIdentifier: CGPoint] = [:]
    private var arrivedAt: [Double] = []
    private var joinedAt: Double? = nil

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        let before = three.arrived
        three.step(dt: dt, holding: touches.count == 1)
        if three.arrived > before {
            arrivedAt.append(now)
            let k = three.arrived - 1
            PlaySound.shared.tone(PlayModels.pointHz * [1.0, 1.25, 1.5][min(k, 2)], gain: 0.13, duration: 3.0,
                                  partials: [(1, 1), (2, 0.3)])
            PlayHaptics.tap(0.5)
        }
        if touches.count >= 2 {
            let ps = Array(touches.values)
            three.bringTogether(distance: hypot(ps[0].x - ps[1].x, ps[0].y - ps[1].y))
        }
        if three.joined, joinedAt == nil {
            joinedAt = now
            for (i, f) in [1.0, 1.25, 1.5, 2.0].enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Double(i)) {
                    PlaySound.shared.tone(PlayModels.pointHz * f, gain: 0.09, duration: 3.4)
                }
            }
            PlayHaptics.bloom()
        }
        if let j = joinedAt, now - j > 7 { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.44)
        if let j = joinedAt {
            let k = min(1, (now - j) / 3)
            // The aurora: the whole spectrum, rising.
            for band in 0..<7 {
                let h = Double(band) / 7
                let y = size.height * (0.85 - 0.1 * CGFloat(band)) - CGFloat(k) * 80
                let wave = still ? 0 : CGFloat(sin(breath * 0.6 + Double(band))) * 30
                add.glow(at: CGPoint(x: c.x + wave, y: y), radius: size.width * 0.7,
                         color: Color(hue: 0.55 + h * 0.4, saturation: 0.5, brightness: 1), alpha: 0.10 * k)
            }
            ctx.draw(PlayInk.text("Tat Tvam Asi", size: 36, alpha: 0.9 * k, sanskrit: true), at: c)
            if now - j > 3.5 {
                ctx.draw(PlayInk.text(Self.after, size: 20, alpha: min(1, (now - j - 3.5) / 1.5) * 0.7), at: CGPoint(x: c.x, y: c.y + 70))
            }
            return
        }
        let condensing = touches.count == 1 ? min(1, three.held / ThreeWords.breath) : 0
        add.glow(at: c, radius: 60 + 80 * CGFloat(condensing), color: hue, alpha: 0.15 + 0.3 * condensing)
        for (i, word) in ThreeWords.words.enumerated() where i < three.arrived {
            let k = min(1, (now - arrivedAt[i]) / 1.2)
            let y = c.y - 90 + CGFloat(i) * 90
            ctx.draw(PlayInk.text(word, size: 56, alpha: 0.88 * k, sanskrit: true), at: CGPoint(x: c.x, y: y))
        }
        for p in touches.values {
            add.glow(at: p, radius: 36, color: Color.cream, alpha: 0.2)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard joinedAt == nil else { return }
        session.acted()
        touches[s.id] = s.location
        PlayHaptics.tap(0.2)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        if touches[s.id] != nil { touches[s.id] = s.location }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        touches[s.id] = nil
    }
}

// MARK: Rām japa — his own name, at the point (ring 9)
//
// Codex C-1222: japa "Ram Ram". The name is his higher self's (C-1262,
// C-1325) — his alone, not a Śakti's — so the mālā hands to stillness, never
// to a seat. A mālā of a hundred and eight beads hangs in light; one bead
// moves on a whole breath: held as the breath comes in, let go as it leaves.
// A flick is not a breath, and moves nothing. The meru is the point; a whole
// round, home again, and the name goes quiet.

final class RamJapaModel: PlayModel {
    static let theName = "राम"

    private var mala = JapaMala()
    private var clock = FrameClock()
    private var inhaling = false
    private var breathLevel: Double = 0
    private var shown: Double = 0
    private var movedAt: Double = -10
    private var droneOn = false
    private var finishAt: Double? = nil

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        breathLevel += ((inhaling ? 1 : 0) - breathLevel) * min(1, dt * 0.7)
        shown += (Double(mala.bead) - shown) * min(1, dt * 5)
        if droneOn { PlaySound.shared.droneGain(0.04 + 0.12 * breathLevel) }
        if mala.roundWhole, finishAt == nil {
            finishAt = now + 3
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
        let rx = size.width * 0.40, ry = size.height * 0.30
        let n = Double(JapaMala.beads)
        let slide = shown - Double(mala.bead)
        for i in 0..<JapaMala.beads {
            var ph = (Double(i - mala.bead) + slide).truncatingRemainder(dividingBy: n)
            if ph < 0 { ph += n }
            let a = Double.pi / 2 + ph / n * 2 * Double.pi
            let p = CGPoint(x: c.x + rx * CGFloat(cos(a)), y: c.y + ry * CGFloat(sin(a)))
            let current = i == mala.bead % JapaMala.beads
            add.glow(at: p, radius: current ? 22 : 7, color: hue, alpha: current ? 0.6 : 0.2)
            add.core(at: p, radius: current ? 4 : 1.8, color: Color.cream, alpha: current ? 1 : 0.55)
        }
        // The meru: the point at the top of the loop.
        let meru = CGPoint(x: c.x, y: c.y - ry - 26)
        add.glow(at: meru, radius: 18, color: Color.gold, alpha: 0.5)
        add.core(at: meru, radius: 3, color: Color.gold, alpha: 0.9)
        // The name, breathing with him.
        let fresh = exp(-(now - movedAt) * 1.2)
        add.glow(at: c, radius: 50 + 60 * CGFloat(breathLevel), color: hue, alpha: 0.15 + 0.25 * breathLevel + 0.2 * fresh)
        ctx.draw(PlayInk.tinted(Self.theName, size: 44 + 6 * CGFloat(breathLevel), colour: Color.cream,
                                alpha: 0.55 + 0.35 * breathLevel + 0.1 * fresh), at: c)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil else { return }
        session.acted()
        inhaling = true
        mala.inhale(at: s.time)
        if !droneOn {
            droneOn = true
            PlaySound.shared.drone(PlayModels.pointHz)
            PlaySound.shared.droneGain(0.04)
        }
        PlayHaptics.tap(0.2)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        inhaling = false
        if mala.exhale(at: s.time) {
            movedAt = s.time
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.08, duration: 2.0,
                                  partials: [(1, 1), (2.76, 0.2), (5.4, 0.06)])
            PlayHaptics.tick()
        }
    }
}

// MARK: Bhakti at Maṇipūra — Sarva-Mahāṅkuśā (kp 24)
//
// Codex C-1230: "Bhakti is the key to Maṇipūra" — and it has to be something
// to get, not something to give up. The ārati: a lamp carried round her
// light at the navel, sunwise, at an even pace. Each whole circle comes back
// to the lamp as light received, and her light warms. Rushed, the flame only
// flickers; the other way round, it simply does not gather. Seven circles,
// and she is felt.

final class BhaktiModel: PlayModel {
    /// Each circle received sounds a step higher — a just scale above the point.
    static let scale: [Double] = [1, 1.125, 1.25, 4.0 / 3, 1.5, 5.0 / 3, 2]

    private var arati = Arati()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var lamp: CGPoint? = nil
    private var received: Double = 0
    private var receivedTarget: Double = 0
    private var trail: [(p: CGPoint, at: Double)] = []
    private var finishAt: Double? = nil

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.48) }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        received += (receivedTarget - received) * min(1, dt * 1.2)
        trail.removeAll { now - $0.at > 1.4 }
        if arati.offered, finishAt == nil {
            finishAt = now + 2.4
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.recognition) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = centre
        let b = still ? 0.5 : 0.5 + 0.5 * sin(breath * 1.1)
        add.glow(at: c, radius: 70 + 130 * CGFloat(received) + 8 * CGFloat(b), color: hue, alpha: 0.18 + 0.35 * received)
        add.glow(at: c, radius: 24 + 20 * CGFloat(received), color: Color.cream, alpha: 0.35 + 0.4 * received)
        add.core(at: c, radius: 3.5, color: Color.cream, alpha: 0.95)
        let orbit: CGFloat = min(size.width, size.height) * 0.30
        add.stroke(Path(ellipseIn: CGRect(x: c.x - orbit, y: c.y - orbit, width: orbit * 2, height: orbit * 2)),
                   with: .color(hue.opacity(0.10)), lineWidth: 1)
        for t in trail {
            let k = max(0, 1 - (now - t.at) / 1.4)
            add.glow(at: t.p, radius: 14, color: hue, alpha: 0.25 * k)
        }
        if let l = lamp {
            let flick = arati.flicker
            let jitter = CGFloat(flick) * 4 * CGFloat(sin(now * 40))
            let flame = CGPoint(x: l.x + jitter, y: l.y - 8)
            add.glow(at: flame, radius: 26 + 8 * CGFloat(b) - 8 * CGFloat(flick), color: Color(red: 0.99, green: 0.74, blue: 0.36), alpha: 0.7)
            add.core(at: flame, radius: 3.5, color: Color.cream, alpha: 0.95)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil else { return }
        session.acted()
        lamp = s.location
        arati.lift()
        _ = arati.follow(angle: atan2(Double(s.location.y - centre.y), Double(s.location.x - centre.x)), dt: 0)
    }

    private var lastTime: Double? = nil

    func moved(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil, lamp != nil else { return }
        let dt = lastTime.map { s.time - $0 } ?? 1.0 / 60
        lastTime = s.time
        lamp = s.location
        trail.append((p: s.location, at: s.time))
        let a = atan2(Double(s.location.y - centre.y), Double(s.location.x - centre.x))
        if arati.follow(angle: a, dt: max(1.0 / 240, dt)) {
            receivedTarget = min(1, Double(arati.circles) / Double(Arati.circlesToOffer))
            let step = Self.scale[max(0, min(arati.circles - 1, Self.scale.count - 1))]
            PlaySound.shared.tone(PlayModels.pointHz * 2 * step,
                                  gain: 0.11, duration: 2.6, partials: [(1, 1), (2.76, 0.22), (5.4, 0.08)])
            PlayHaptics.tap(0.55)
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        lamp = nil
        lastTime = nil
        arati.lift()
    }
}
