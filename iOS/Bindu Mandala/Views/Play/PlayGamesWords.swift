import SwiftUI

// MARK: - Wave 6 · Slice E — the word games: Shadow Translator, Mirror Maze,
// the Letter, Flash
//
// The corpus built three of these on live AI. Charter law 8 refuses that:
// here every answer is his own word or a Śakti's own row, and nothing is
// generated.

// MARK: Shadow Translator — Ego Reveal · Bhagamālinī (kp 101)
//
// Name the burden; find the gift. He names one thing he carries, in his own
// word. It stands before him as a coin of light, and he circles it slowly to
// turn it over; rushed, it lags behind the finger and simply waits. Its far
// face is a gift — one of the ten Siddhi Śaktis of the Bhūpura (kp 1–10),
// the same one for the same word every time — her name, and her own
// Appreciation Phrase from her row. Turned over, it hands him to her.

final class ShadowTranslatorModel: PlayModel {
    private var burden: String? = nil
    private var coin = TurningWord()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var lastAngle: Double? = nil
    private var words: [Int: PlayWords] = [:]
    private var turnedAt: Double? = nil
    private var asked = false
    private var lastTick: Double = 0

    /// The Siddhi Śakti a word turns into — by the word's own letters, so the
    /// same burden always turns into the same gift.
    static func gift(for word: String) -> Int {
        let sum = word.lowercased().unicodeScalars.reduce(0) { ($0 &+ Int($1.value)) % 9_973 }
        return 1 + sum % 10
    }

    func meet(_ words: [Int: PlayWords]) { self.words = words }

    func give(word: String, session: PlaySession) {
        burden = word
        PlaySound.shared.thump(depth: 0.4)
    }

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.44) }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        if !asked {
            asked = true
            session.ask(true, prompt: "what you carry")
        }
        let was = coin.turned
        coin.step(dt: dt)
        if !was, coin.turned, let b = burden {
            turnedAt = now
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.12, duration: 2.6,
                                  partials: [(1, 1), (1.5, 0.45), (2, 0.2)])
            PlayHaptics.bloom()
            session.complete(.recognition, at: Self.gift(for: b))
        }
        _ = turnedAt
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = centre
        guard let b = burden else {
            add.glow(at: c, radius: 50, color: hue, alpha: 0.2)
            return
        }
        let w = coin.width
        let rx = 120 * CGFloat(max(0.04, abs(w)))
        let rect = CGRect(x: c.x - rx, y: c.y - 120, width: rx * 2, height: 240)
        let gold = Color(red: 0.98, green: 0.84, blue: 0.52)
        add.fill(Path(ellipseIn: rect), with: .radialGradient(
            Gradient(colors: [(w >= 0 ? hue : gold).opacity(0.28), (w >= 0 ? hue : gold).opacity(0.02)]),
            center: c, startRadius: 0, endRadius: 140))
        add.stroke(Path(ellipseIn: rect), with: .color((w >= 0 ? hue : gold).opacity(0.6)), lineWidth: 1.2)
        var face = ctx
        face.translateBy(x: c.x, y: c.y)
        face.scaleBy(x: CGFloat(max(0.04, abs(w))), y: 1)
        if w >= 0 {
            face.draw(PlayInk.text(b, size: 30, alpha: 0.9, sanskrit: true), at: .zero)
        } else {
            let kp = Self.gift(for: b)
            let her = words[kp]
            face.draw(PlayInk.tinted(her?.name ?? b, size: 28, colour: gold, alpha: 0.95), at: CGPoint(x: 0, y: -14))
            if let line = her?.appreciation, !line.isEmpty {
                face.draw(PlayInk.text(line, size: 15, alpha: 0.7), in: CGRect(x: -110, y: 18, width: 220, height: 90))
            }
        }
        // The path of the circling finger.
        let ring = CGRect(x: c.x - 160, y: c.y - 160, width: 320, height: 320)
        add.stroke(Path(ellipseIn: ring), with: .color(hue.opacity(0.10)), lineWidth: 1)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard burden != nil, !coin.turned else { return }
        session.acted()
        lastAngle = atan2(Double(s.location.y - centre.y), Double(s.location.x - centre.x))
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let last = lastAngle else { return }
        let a = atan2(Double(s.location.y - centre.y), Double(s.location.x - centre.x))
        coin.turn(by: PlayMath.wrap(a - last))
        lastAngle = a
        if s.time - lastTick > 0.12 {
            lastTick = s.time
            PlayHaptics.tick()
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        lastAngle = nil
    }
}

// MARK: Mirror Maze — Buddhyākarṣiṇī (kp 30)
//
// One word through seven lenses. His word falls as a light through the seven
// energy chakras of The Map, root to crown; he steers it with the phone's
// tilt (or a finger). Through each lens the word takes that chakra's colour,
// and the chakra's own essence stands beside it — The Map's words, never a
// generated one. A light that misses a lens rises above it and falls again.

final class MirrorMazeModel: PlayModel {
    private var fall = MazeFall()
    private var clock = FrameClock()
    private var word: String? = nil
    private var asked = false
    private var steerFinger: CGFloat? = nil
    private var width: CGFloat = 1
    private var passedAt: [Double] = []
    private var done = false
    private let lenses: [Chakra33]

    init() {
        lenses = Array(ChakraConstellation.all.filter { $0.kind == .energy }
            .sorted { $0.road < $1.road }
            .prefix(MazeFall.lenses))
    }

    func give(word: String, session: PlaySession) {
        self.word = word
    }

    private func colour(_ k: Int) -> Color {
        guard lenses.indices.contains(k), let hex = lenses[k].colorHex else { return Color.cream }
        return Color(hex: hex)
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        width = max(1, size.width)
        if !asked {
            asked = true
            session.ask(true)
        }
        guard word != nil, !done else { return }
        var steer = motion.roll * 2.2
        if let f = steerFinger { steer = Double((f / width) - CGFloat(fall.x)) * 4 }
        let before = fall.passed
        let bounced = fall.bounce
        fall.step(dt: dt, steer: steer)
        if fall.passed > before {
            passedAt.append(now)
            let k = fall.passed - 1
            PlaySound.shared.tone(AwakeningTones.frequency(ring: min(8, k + 1)) ?? PlayModels.pointHz * 2,
                                  gain: 0.12, duration: 2.0)
            PlayHaptics.tap(0.5)
        }
        if fall.bounce > bounced + 0.5 {
            PlaySound.shared.thump(depth: 0.2)
            PlayHaptics.tap(0.2)
        }
        if fall.through {
            done = true
            PlayHaptics.bloom()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { session.complete(.recognition) }
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        for k in 0..<MazeFall.lenses {
            let l = MazeFall.lens(k)
            let y = CGFloat(l.y) * size.height
            let gapL = CGFloat(l.centre - MazeFall.opening / 2) * size.width
            let gapR = CGFloat(l.centre + MazeFall.opening / 2) * size.width
            let lit = k < fall.passed
            let col = colour(k)
            var left = Path(); left.move(to: CGPoint(x: 16, y: y)); left.addLine(to: CGPoint(x: gapL, y: y))
            var right = Path(); right.move(to: CGPoint(x: gapR, y: y)); right.addLine(to: CGPoint(x: size.width - 16, y: y))
            add.stroke(left, with: .color(col.opacity(lit ? 0.7 : 0.35)), lineWidth: lit ? 2 : 1.2)
            add.stroke(right, with: .color(col.opacity(lit ? 0.7 : 0.35)), lineWidth: lit ? 2 : 1.2)
            if lit, lenses.indices.contains(k), let e = lenses[k].essence {
                var t = ctx
                t.opacity = 0.55
                t.draw(PlayInk.text(e, size: 12, alpha: 1), at: CGPoint(x: size.width / 2, y: y + 14))
            }
        }
        guard let w = word else { return }
        let p = CGPoint(x: CGFloat(fall.x) * size.width, y: CGFloat(fall.y) * size.height)
        let col = fall.passed > 0 ? colour(fall.passed - 1) : Color.cream
        add.glow(at: p, radius: 40 + 20 * CGFloat(fall.bounce), color: col, alpha: 0.5)
        ctx.draw(PlayInk.tinted(w, size: 24, colour: fall.passed > 0 ? col : Color.cream, alpha: 0.95), at: p)
        if fall.through {
            add.glow(at: CGPoint(x: size.width / 2, y: size.height * 0.95), radius: size.width, color: hue, alpha: 0.25)
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard word != nil else { return }
        session.acted()
        steerFinger = s.location.x
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        if steerFinger != nil { steerFinger = s.location.x }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        steerFinger = nil
    }
}

// MARK: The Letter — Intention · Kāmeśī (kp 88)
//
// Written now, opened later. He writes a few words to her; the page stands
// in light. He draws the page down over itself to fold it, and presses the
// wax; the wax warms under his thumb (a harder press warms it faster, never
// wrongly) and sets. The letter is sealed into his river, to open when this
// moon returns — kept there, as every letter is.

final class LetterModel: PlayModel {
    private let kp: Int
    private var words: String? = nil
    private var asked = false
    private var fold = LetterFold()
    private var wax = WaxSeal()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var pulling: (start: CGFloat, base: Double)? = nil
    private var pressing: [ObjectIdentifier: Double] = [:]
    private var sealedAt: Double? = nil
    private var lastWarm = 0

    init(to kp: Int) {
        self.kp = (1...KhadgamalaMap.total).contains(kp) ? kp : 88
    }

    func give(word: String, session: PlaySession) {
        words = word
        PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.06, duration: 1.2)
    }

    private var page: CGRect {
        let w = size.width * 0.72
        let h = size.height * 0.44 * CGFloat(1 - 0.5 * fold.folded)
        return CGRect(x: (size.width - w) / 2, y: size.height * 0.16, width: w, height: h)
    }

    private var waxPoint: CGPoint { CGPoint(x: page.midX, y: page.maxY - 30) }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        if !asked {
            asked = true
            session.ask(true, prompt: "a few words to her")
        }
        guard words != nil, sealedAt == nil else {
            if let s = sealedAt, now - s > 2.0 { session.complete(.stillness) }
            return
        }
        if fold.isFolded, let p = pressing.values.max() {
            wax.press(dt: dt, pressure: p)
            let q = Int(wax.warmth * 4)
            if q > lastWarm {
                lastWarm = q
                PlayHaptics.tap(0.25 + 0.1 * Double(q))
            }
            if wax.isSet { seal(now: now) }
        }
    }

    private func seal(now: Double) {
        guard let body = words, sealedAt == nil else { return }
        sealedAt = now
        let to = kp
        Task { @MainActor in
            CorrespondenceStore.shared.seal(body: body, to: to, opening: .tithiReturns)
        }
        PlaySound.shared.thump(depth: 0.9)
        PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.1, duration: 2.4)
        PlayHaptics.bloom()
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        guard let body = words else { return }
        var add = ctx
        add.blendMode = .plusLighter
        let r = page
        let away = sealedAt.map { min(1, (now - $0) / 1.6) } ?? 0
        let shifted = r.offsetBy(dx: 0, dy: CGFloat(away) * size.height * 0.5)
        add.fill(Path(roundedRect: shifted, cornerRadius: 6), with: .color(hue.opacity(0.06 * (1 - away))))
        add.stroke(Path(roundedRect: shifted, cornerRadius: 6), with: .color(hue.opacity(0.5 * (1 - away))), lineWidth: 1)
        if fold.folded > 0 {
            var crease = Path()
            crease.move(to: CGPoint(x: shifted.minX, y: shifted.minY + 2))
            crease.addLine(to: CGPoint(x: shifted.maxX, y: shifted.minY + 2))
            add.stroke(crease, with: .color(Color.cream.opacity(0.4 * fold.folded * (1 - away))), lineWidth: 1.4)
        }
        var t = ctx
        t.opacity = (1 - 0.85 * fold.folded) * (1 - away)
        t.draw(PlayInk.text(body, size: 20, alpha: 0.85, sanskrit: true),
               in: shifted.insetBy(dx: 18, dy: 18))
        if fold.isFolded {
            let w = waxPoint.applying(CGAffineTransform(translationX: 0, y: CGFloat(away) * size.height * 0.5))
            let amber = Color(red: 0.86, green: 0.56, blue: 0.24)
            let warm = wax.warmth
            add.glow(at: w, radius: 30 + 16 * CGFloat(warm), color: amber, alpha: (0.35 + 0.4 * warm) * (1 - away))
            add.fill(Path(ellipseIn: CGRect(x: w.x - 16, y: w.y - 16, width: 32, height: 32)),
                     with: .color(amber.opacity((0.4 + 0.5 * warm) * (1 - away))))
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard words != nil, sealedAt == nil else { return }
        session.acted()
        if fold.isFolded {
            if hypot(s.location.x - waxPoint.x, s.location.y - waxPoint.y) < 60 {
                pressing[s.id] = s.pressure
            }
        } else {
            pulling = (start: s.location.y, base: fold.folded)
        }
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        if pressing[s.id] != nil { pressing[s.id] = s.pressure }
        guard let p = pulling else { return }
        let goal = p.base + Double((s.location.y - p.start) / max(1, size.height * 0.35))
        let was = fold.isFolded
        fold.pull(toward: goal, dt: 1.0 / 60)
        if !was, fold.isFolded {
            pulling = nil
            PlaySound.shared.tone(PlayModels.pointHz * 1.5, gain: 0.07, duration: 1.0)
            PlayHaptics.tap(0.5)
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        pressing[s.id] = nil
        pulling = nil
    }
}

// MARK: Flash · Intuition — Aruṇā (kp 91)
//
// "Something already knows. Don't word it yet." One breath first: he holds
// as the breath comes in and lets go. Then a light flashes somewhere on the
// glass and is gone; touching it while it is there is the skill — trusting
// the first movement. A flash missed simply fades, and another comes. Caught,
// it asks for one word, and the word is given back as light; then she is felt.

final class FlashModel: PlayModel {
    private enum Stage { case breath, waiting, flashing, word, given }

    static let lines = ["One breath.", "Something already knows.", "Don't word it yet.", "Give it one word."]

    private var stage: Stage = .breath
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var inhaleAt: Double? = nil
    private var breathLevel: Double = 0
    private var stageAt: Double = 0
    private var flash: (p: CGPoint, at: Double)? = nil
    private var nextFlash: Double = 0
    private var word: String? = nil
    private var ripples: [PlayRipple] = []

    func give(word: String, session: PlaySession) {
        self.word = word
        stage = .given
        stageAt = PlayClock.now
        PlaySound.shared.tone(PlayModels.pointHz * 3, gain: 0.1, duration: 2.4)
        PlayHaptics.bloom()
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        ripples.removeAll { !$0.alive(now) }
        breathLevel += ((inhaleAt != nil ? 1 : 0) - breathLevel) * min(1, dt * 0.8)
        switch stage {
        case .breath:
            break
        case .waiting:
            if now - stageAt > 3.5 {
                stage = .flashing
                nextFlash = now + Double.random(in: 0.8...2.4)
            }
        case .flashing:
            if let f = flash, now - f.at > FlashCatch.shows {
                flash = nil
                nextFlash = now + Double.random(in: 1.2...3.2)
            }
            if flash == nil, now >= nextFlash {
                flash = (p: CGPoint(x: CGFloat.random(in: 60...max(61, size.width - 60)),
                                    y: CGFloat.random(in: 120...max(121, size.height - 160))),
                         at: now)
                PlaySound.shared.tone(Double.random(in: 900...1300), gain: 0.03, duration: 0.3)
            }
        case .word:
            break
        case .given:
            if now - stageAt > 3.0 { session.complete(.recognition) }
        }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
        let line: String
        switch stage {
        case .breath:   line = Self.lines[0]
        case .waiting:  line = now - stageAt < 1.6 ? Self.lines[1] : Self.lines[2]
        case .flashing: line = ""
        case .word:     line = Self.lines[3]
        case .given:    line = ""
        }
        add.glow(at: c, radius: 50 + 70 * CGFloat(breathLevel), color: hue, alpha: 0.2 + 0.25 * breathLevel)
        if !line.isEmpty {
            ctx.draw(PlayInk.text(line, size: 22, alpha: 0.7), at: CGPoint(x: c.x, y: c.y + 130))
        }
        if let f = flash {
            let k = max(0, 1 - (now - f.at) / FlashCatch.shows)
            add.glow(at: f.p, radius: 40, color: Color.cream, alpha: 0.8 * k)
            add.core(at: f.p, radius: 4, color: Color.cream, alpha: k)
        }
        if stage == .given, let w = word {
            let k = min(1, (now - stageAt) / 1.2)
            add.glow(at: c, radius: 60 + 160 * CGFloat(k), color: hue, alpha: 0.4)
            ctx.draw(PlayInk.tinted(w, size: 34, colour: Color.cream, alpha: k), at: c)
        }
        for r in ripples { r.draw(in: add, now: now) }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        switch stage {
        case .breath:
            session.acted()
            inhaleAt = s.time
            PlayHaptics.tap(0.25)
        case .flashing:
            session.acted()
            if let f = flash, FlashCatch.caught(tap: s.location, flash: f.p, since: s.time - f.at) {
                flash = nil
                stage = .word
                stageAt = s.time
                ripples.append(PlayRipple(center: s.location, born: s.time, color: Color.cream, life: 1.6, reach: 160))
                PlaySound.shared.tone(PlayModels.pointHz * 4, gain: 0.08, duration: 1.6)
                PlayHaptics.tap(0.7)
                session.ask(true)
            }
        default:
            break
        }
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        guard stage == .breath, let i = inhaleAt else { return }
        inhaleAt = nil
        if s.time - i >= 2.0 {
            stage = .waiting
            stageAt = s.time
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.06, duration: 2.0)
        }
    }
}
