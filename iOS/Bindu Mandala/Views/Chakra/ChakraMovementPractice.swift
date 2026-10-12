import SwiftUI
import UIKit

// MARK: - Wave 6 · a held movement or breath, inside a chakra's room
//
// One surface for the eight practices `ChakraMovement` names. Each is a model
// on the play clock — it advances, it draws its light into a `Canvas`, it feels
// touches from the `TouchSenseSurface` and the phone's body from `PlayMotion` —
// the same shape every game in `Views/Play/` has, so a shake means the same
// thing here as in Shake to Clear.
//
// Light and haptics, never a score. Nothing on this glass counts: not the
// waves, not the breaths, not how hard he shook. A practice ends by settling,
// and the room writes one ledger row the first time it does (practice first:
// the row is written before the light settles).

/// The practice's state on the play clock. A class that publishes nothing: the
/// timeline redraws it every frame, the words are read off it in that same
/// frame, and nothing about it ever re-renders a view on its own.
final class MovementField {
    let movement: ChakraMovement
    /// Which third of Ham · Het · Hum this room holds, if any.
    let breathIndex: Int?
    let soundOn: Bool

    /// Called once, the first time the practice settles.
    var onComplete: () -> Void = {}

    /// What the words read: each practice's own steps, never shown as a number.
    private(set) var stage = 0
    private(set) var completed = false
    let startedAt = PlayClock.now

    // The hand.
    private(set) var touch: CGPoint?
    private var touchBegan: Double?
    private var lastTouch: (p: CGPoint, t: Double)?
    private var rub: Double = 0

    // The body of the phone.
    private var shake: Double = 0
    private var gravity = CGVector(dx: 0, dy: -1)

    // Shared light.
    private var lastNow: Double?
    private var size: CGSize = .zero
    private var charge: Double = 0
    private var pulses: [(born: Double, at: CGPoint)] = []
    private var lastHaptic: Double = 0

    // Roar and silence.
    private var roar: Double = 0
    private var roarSounded = false
    private var silenceSince: Double?

    // Last memories.
    private var lids: Double = 0
    private(set) var eyesClosed = false
    private(set) var readyToOpen = false

    // Ham · Het · Hum.
    private var breathStart: Double?
    private(set) var breathPhase: Int?
    private var lastBreathPhase: Int?

    // Fear, in waves.
    private var washing: Double = 0
    private var prana: Double = 0
    private var waves = 0
    private var releasedAt: Double?
    private var washOrigin: CGPoint = .zero

    // Feeling it through.
    private var spread: Double = 0
    private var pool: CGPoint?

    // Restlessness, allowed.
    private var motes: [(p: CGPoint, v: CGVector)] = []
    private var stirred: Double = 0

    // The heart, home.
    private var mote: CGPoint?
    private var wentOut = false
    private var heartGlow: Double = 0

    init(movement: ChakraMovement, breathIndex: Int?, soundOn: Bool) {
        self.movement = movement
        self.breathIndex = breathIndex
        self.soundOn = soundOn
    }

    /// Where the heart is on this glass — the home everything returns to.
    func heart(in size: CGSize) -> CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.46) }

    // MARK: Touch

    func began(_ s: TouchSample) {
        touch = s.location
        touchBegan = s.time
        lastTouch = (p: s.location, t: s.time)
        switch movement {
        case .hamHetHum:
            if breathStart == nil { breathStart = s.time; stage = 1 }
        case .fearInWaves:
            guard stage < 3 else { break }
            washOrigin = s.location
            stage = 1
        case .feelingThrough:
            if pool == nil { pool = s.location }
            if stage == 0 { stage = 1 }
        case .roarAndSilence:
            guard silenceSince == nil else { break }
            roarSounded = false
        case .lastMemories:
            if readyToOpen { open() }
        default:
            break
        }
    }

    func moved(_ s: TouchSample) {
        if let last = lastTouch {
            let dt = max(1.0 / 240, s.time - last.t)
            let d = hypot(s.location.x - last.p.x, s.location.y - last.p.y)
            // A finger rubbed fast across the glass is a shake too.
            rub = max(rub, Double(d) / dt / 1500)
        }
        lastTouch = (p: s.location, t: s.time)
        touch = s.location
    }

    func ended(_ s: TouchSample) {
        let held = touchBegan.map { s.time - $0 } ?? 0
        touch = nil
        touchBegan = nil
        lastTouch = nil
        switch movement {
        case .roarAndSilence:
            if silenceSince == nil, held >= ChakraMovement.roarHold {
                silenceSince = s.time
                stage = 1
                Haptics.soft()
            }
        case .fearInWaves:
            guard stage == 1, washing > 0.25 else { break }
            waves += 1
            prana = 1
            releasedAt = s.time
            stage = 2
            PlayHaptics.tap(0.5)
        default:
            break
        }
    }

    private func open() {
        guard readyToOpen, eyesClosed else { return }
        eyesClosed = false
        readyToOpen = false
        stage = 3
        PlayHaptics.bloom()
        complete()
    }

    func closeEyes() {
        guard movement == .lastMemories, !eyesClosed, stage == 0 else { return }
        eyesClosed = true
        stage = 1
        Haptics.soft()
    }

    // MARK: The clock

    func advance(now: Double, size: CGSize, motion: PlayMotion, reduceMotion: Bool) {
        self.size = size
        let dt = lastNow.map { min(max(now - $0, 0), 1.0 / 20) } ?? 0
        lastNow = now
        shake = motion.shake
        gravity = CGVector(dx: motion.gravityX, dy: motion.gravityY)
        let effectiveShake = max(shake, rub)
        rub = max(0, rub - dt * 3)
        pulses.removeAll { now - $0.born > 2.6 }
        heartGlow = max(0, heartGlow - dt * 0.6)

        switch movement {
        case .euphoriaPulse:
            charge = ChakraMovement.charge(charge, shake: effectiveShake, dt: dt)
            if charge >= ChakraMovement.pulseCharge { sendPulse(now: now) }

        case .roarAndSilence:
            if let since = silenceSince {
                roar = max(0, roar - dt * 1.6)
                if now - since > 6 { complete() }
            } else if touch != nil {
                roar = min(1, roar + dt / 1.6)
                if !roarSounded {
                    roarSounded = true
                    sound(low: 110, seconds: 2.6, volume: 0.09)
                }
                if now - lastHaptic > 0.14 {
                    lastHaptic = now
                    PlayHaptics.thump(0.25 + 0.6 * roar)
                }
            } else {
                roar = max(0, roar - dt * 0.9)
            }

        case .lastMemories:
            lids += ((eyesClosed ? 1 : 0) - lids) * min(1, dt * 2.2)
            if eyesClosed && !readyToOpen {
                // Vibrating: the phone shaken, or a finger held on the glass.
                let held = touch != nil ? 0.9 : 0
                charge = ChakraMovement.charge(charge, shake: max(effectiveShake, held), dt: dt)
                if charge >= ChakraMovement.pulseCharge {
                    charge = 0
                    readyToOpen = true
                    stage = 2
                    pulses.append((born: now, at: heart(in: size)))
                    PlayHaptics.heartbeat(0.7)
                }
            }

        case .hamHetHum:
            guard let start = breathStart, !completed else { break }
            let cycle = ChakraMovement.hamHetHumBreaths.reduce(0.0) { $0 + $1.seconds }
            let t = now - start
            if t >= cycle * 3 {
                breathPhase = nil
                stage = 2
                complete()
                break
            }
            let within = t.truncatingRemainder(dividingBy: cycle)
            var acc = 0.0
            var phase = 0
            for (i, b) in ChakraMovement.hamHetHumBreaths.enumerated() {
                if within < acc + b.seconds { phase = i; break }
                acc += b.seconds
            }
            breathPhase = phase
            if phase != lastBreathPhase {
                lastBreathPhase = phase
                PlayHaptics.tick()
                if phase == 2 { sound(low: 110, seconds: 3.6, volume: 0.06) }
            }

        case .fearInWaves:
            if touch != nil && stage == 1 {
                washing = min(1, washing + dt / 2.2)
                if now - lastHaptic > 0.5 {
                    lastHaptic = now
                    PlayHaptics.tap(0.2 + 0.5 * washing)
                }
            } else {
                washing = max(0, washing - dt / 1.4)
            }
            prana = max(0, prana - dt / 3.5)
            if stage == 2, let r = releasedAt,
               waves >= ChakraMovement.fearWaves || now - r > 7 {
                stage = 3
                complete()
            }

        case .feelingThrough:
            if touch != nil, let p = touch {
                if pool == nil { pool = p }
                spread = min(1, spread + dt / 9)
                if now - lastHaptic > 0.7 {
                    lastHaptic = now
                    PlayHaptics.tap(0.15 + 0.3 * (1 - spread))
                }
            }
            if spread > 0 {
                stage = max(stage, min(4, 1 + Int(spread * 3.2)))
            }
            if spread >= 1 { complete() }

        case .restlessness:
            seedMotes(in: size)
            let agitation = min(1.5, effectiveShake)
            if agitation > 0.08 || touch != nil { stirred += dt }
            let pull = CGVector(dx: gravity.dx * 90, dy: -gravity.dy * 90)
            let cdt = CGFloat(dt)
            let kick = CGFloat(reduceMotion ? 0 : agitation * 420)
            let damp = CGFloat(1 - min(0.9, dt * 1.4))
            for i in motes.indices {
                var m = motes[i]
                let sx = CGFloat(sin(now * 3.1 + Double(i)))
                let sy = CGFloat(cos(now * 2.7 + Double(i) * 1.7))
                m.v.dx += (pull.dx + sx * kick) * cdt
                m.v.dy += (pull.dy + sy * kick) * cdt
                if let t = touch {
                    m.v.dx += (t.x - m.p.x) * 0.8 * cdt
                    m.v.dy += (t.y - m.p.y) * 0.8 * cdt
                }
                m.v.dx *= damp
                m.v.dy *= damp
                m.p.x = min(max(0, m.p.x + m.v.dx * cdt), size.width)
                m.p.y = min(max(0, m.p.y + m.v.dy * cdt), size.height)
                motes[i] = m
            }
            if stirred > 4, stage == 0 { stage = 1 }
            if stirred > 14 { complete() }

        case .heartHome:
            let home = heart(in: size)
            var m = mote ?? home
            let follow = CGFloat(min(1, dt * 4))
            let back = CGFloat(min(1, dt * 2.2))
            if let t = touch {
                m.x += (t.x - m.x) * follow
                m.y += (t.y - m.y) * follow
                if hypot(m.x - home.x, m.y - home.y) > 60 { wentOut = true }
            } else {
                m.x += (home.x - m.x) * back
                m.y += (home.y - m.y) * back
                if wentOut, hypot(m.x - home.x, m.y - home.y) < 6 {
                    wentOut = false
                    heartGlow = 1
                    PlayHaptics.heartbeat(0.8)
                    complete()
                }
            }
            mote = m
        }
    }

    private func sendPulse(now: Double) {
        charge = 0
        pulses.append((born: now, at: heart(in: size)))
        stage = 1
        heartGlow = 1
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.62 * Double(i)) {
                PlayHaptics.heartbeat(0.85)
            }
        }
        if soundOn {
            Task { @MainActor in
                BijaSoundService.shared.playVakChord(frequencies: [110, 165, 220],
                                                     duration: 3.2, volume: 0.05, stagger: 0.1)
            }
        }
        complete()
    }

    private func sound(low hz: Double, seconds: Double, volume: Double) {
        guard soundOn else { return }
        Task { @MainActor in
            BijaSoundService.shared.playVakBija(frequency: hz, duration: seconds, volume: volume)
        }
    }

    private func complete() {
        guard !completed else { return }
        completed = true
        DispatchQueue.main.async { [weak self] in self?.onComplete() }
    }

    private func seedMotes(in size: CGSize) {
        guard motes.isEmpty, size.width > 0 else { return }
        for i in 0..<64 {
            let x = CGFloat((i * 37) % 100) / 100 * size.width
            let y = CGFloat((i * 61 + 13) % 100) / 100 * size.height
            motes.append((p: CGPoint(x: x, y: y), v: CGVector.zero))
        }
    }

    // MARK: The light

    func draw(_ ctx: GraphicsContext, size: CGSize, now: Double, tone: Color, reduceMotion: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let heart = self.heart(in: size)
        let dim = max(size.width, size.height)
        let beat = reduceMotion ? 0.3 : pow(max(0, sin(2 * .pi * now)), 8)

        for p in pulses {
            let age = now - p.born
            let r = CGFloat(age) * dim * 0.45
            let a = max(0, 0.6 * (1 - age / 2.6))
            add.stroke(Path(ellipseIn: CGRect(x: p.at.x - r, y: p.at.y - r, width: r * 2, height: r * 2)),
                       with: .color(tone.opacity(a)), lineWidth: 2.2)
            add.stroke(Path(ellipseIn: CGRect(x: p.at.x - r * 0.92, y: p.at.y - r * 0.92,
                                              width: r * 1.84, height: r * 1.84)),
                       with: .color(Color.cream.opacity(a * 0.5)), lineWidth: 1)
        }

        switch movement {
        case .euphoriaPulse:
            let k = charge / ChakraMovement.pulseCharge
            add.glow(at: heart, radius: 60 + 90 * CGFloat(k) + 30 * CGFloat(heartGlow),
                     color: tone, alpha: 0.18 + 0.25 * k + 0.12 * beat + 0.3 * heartGlow)
            add.core(at: heart, radius: 4 + 3 * CGFloat(beat), color: Color.cream, alpha: 0.9)
            // The shaking: motes low on the glass, trembling with the hand.
            let amp = CGFloat(min(1, max(shake, rub))) * (reduceMotion ? 4 : 22)
            for i in 0..<18 {
                let bx = size.width * (0.2 + 0.6 * CGFloat(i) / 17)
                let by = size.height * 0.78
                let jx = CGFloat(sin(now * 31 + Double(i) * 2.1)) * amp
                let jy = CGFloat(cos(now * 27 + Double(i) * 1.3)) * amp
                add.glow(at: CGPoint(x: bx + jx, y: by + jy), radius: 10, color: tone, alpha: 0.25 + 0.4 * Double(amp / 22))
            }

        case .roarAndSilence:
            if silenceSince != nil {
                // The silence: the light goes out but one point, breathing slowly.
                let b = reduceMotion ? 0.5 : 0.5 - 0.5 * cos(2 * .pi * now / 8)
                ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.black.opacity(0.55)))
                add.glow(at: heart, radius: 26 + 8 * CGFloat(b), color: Color.cream, alpha: 0.10 + 0.08 * b)
                add.core(at: heart, radius: 2.4, color: Color.cream, alpha: 0.85)
            } else {
                let mouth = CGPoint(x: size.width / 2, y: size.height * 0.40)
                add.glow(at: mouth, radius: 40 + 220 * CGFloat(roar), color: tone, alpha: 0.15 + 0.45 * roar)
                let rays = 32
                for i in 0..<rays {
                    let a = Double(i) / Double(rays) * 2 * .pi
                    let wob = reduceMotion ? 1 : 0.6 + 0.4 * sin(now * 13 + Double(i) * 2.3)
                    let len = CGFloat(30 + 300 * roar * wob)
                    var ray = Path()
                    ray.move(to: mouth)
                    ray.addLine(to: CGPoint(x: mouth.x + CGFloat(cos(a)) * len, y: mouth.y + CGFloat(sin(a)) * len))
                    add.stroke(ray, with: .color(tone.opacity(0.10 + 0.5 * roar)), lineWidth: 1.4)
                }
                add.core(at: mouth, radius: 3 + 5 * CGFloat(roar), color: Color.cream, alpha: 0.9)
            }

        case .lastMemories:
            add.glow(at: heart, radius: 120, color: tone, alpha: stage == 3 ? 0.42 : 0.12)
            let k = charge / ChakraMovement.pulseCharge
            if eyesClosed {
                add.glow(at: heart, radius: 30 + 80 * CGFloat(k), color: Color.cream, alpha: 0.06 + 0.25 * k)
            }
            // The lids: dark from above and below, meeting at the eye.
            let half = size.height / 2 * CGFloat(lids)
            let dark = Color(red: 0.02, green: 0.01, blue: 0.02)
            ctx.fill(Path(CGRect(x: 0, y: 0, width: size.width, height: half)), with: .color(dark.opacity(0.9 * lids)))
            ctx.fill(Path(CGRect(x: 0, y: size.height - half, width: size.width, height: half)),
                     with: .color(dark.opacity(0.9 * lids)))
            if eyesClosed {
                add.glow(at: heart, radius: 14 + 40 * CGFloat(k), color: tone, alpha: 0.2 + 0.5 * k)
            }

        case .hamHetHum:
            let cycle = ChakraMovement.hamHetHumBreaths.reduce(0.0) { $0 + $1.seconds }
            var r: CGFloat = 44
            if let start = breathStart, let phase = breathPhase {
                let within = (now - start).truncatingRemainder(dividingBy: cycle)
                let s0 = ChakraMovement.hamHetHumBreaths[0].seconds
                let s1 = ChakraMovement.hamHetHumBreaths[1].seconds
                switch phase {
                case 0: r = 44 + 120 * CGFloat(min(1, within / s0))
                case 1: r = 164
                default:
                    let k = min(1, (within - s0 - s1) / ChakraMovement.hamHetHumBreaths[2].seconds)
                    r = 164 - 120 * CGFloat(k)
                    let out = CGFloat(k) * dim * 0.5
                    add.stroke(Path(ellipseIn: CGRect(x: heart.x - out, y: heart.y - out, width: out * 2, height: out * 2)),
                               with: .color(tone.opacity(0.35 * (1 - k))), lineWidth: 1.6)
                }
            }
            add.glow(at: heart, radius: r * 1.6, color: tone, alpha: 0.22)
            add.stroke(Path(ellipseIn: CGRect(x: heart.x - r, y: heart.y - r, width: r * 2, height: r * 2)),
                       with: .color(Color.cream.opacity(0.45)), lineWidth: 1)
            add.core(at: heart, radius: 3.5, color: Color.cream, alpha: 0.9)

        case .fearInWaves:
            if washing > 0 {
                let r = CGFloat(washing) * dim * 1.2
                let violet = Color(red: 0.32, green: 0.07, blue: 0.20)
                ctx.fill(Path(ellipseIn: CGRect(x: washOrigin.x - r, y: washOrigin.y - r, width: r * 2, height: r * 2)),
                         with: .radialGradient(Gradient(colors: [violet.opacity(0.75 * washing), violet.opacity(0.35 * washing)]),
                                               center: washOrigin, startRadius: 0, endRadius: max(r, 1)))
            }
            if prana > 0 {
                let air = Color(red: 0.74, green: 0.92, blue: 0.96)
                add.glow(at: heart, radius: 80 + CGFloat(1 - prana) * dim * 0.6, color: air, alpha: 0.4 * prana)
            }
            add.glow(at: heart, radius: 60, color: tone, alpha: stage == 3 ? 0.35 : 0.16)
            add.core(at: heart, radius: 3, color: Color.cream, alpha: 0.85)

        case .feelingThrough:
            // His body, as a column of light from the ground to the crown.
            let column = CGRect(x: size.width * 0.39, y: size.height * 0.12,
                                width: size.width * 0.22, height: size.height * 0.76)
            add.fill(Path(roundedRect: column, cornerRadius: column.width / 2),
                     with: .linearGradient(Gradient(colors: [tone.opacity(0.10), tone.opacity(0.22), tone.opacity(0.10)]),
                                           startPoint: CGPoint(x: column.midX, y: column.minY),
                                           endPoint: CGPoint(x: column.midX, y: column.maxY)))
            if let p = pool {
                let intensity = spread < 0.6 ? spread / 0.6 : max(0, 1 - (spread - 0.6) / 0.4)
                let r = 20 + CGFloat(spread) * dim * 0.9
                add.glow(at: p, radius: r, color: tone, alpha: 0.5 * intensity)
                add.glow(at: p, radius: 18, color: Color.cream, alpha: 0.4 * intensity)
            }

        case .restlessness:
            for (i, m) in motes.enumerated() {
                let speed = min(1, Double(hypot(m.v.dx, m.v.dy)) / 240)
                add.glow(at: m.p, radius: 8 + 10 * CGFloat(speed), color: i % 3 == 0 ? Color.cream : tone,
                         alpha: 0.18 + 0.4 * speed)
            }

        case .heartHome:
            let m = mote ?? heart
            var thread = Path()
            thread.move(to: heart)
            thread.addLine(to: m)
            add.stroke(thread, with: .color(tone.opacity(0.25)), lineWidth: 1)
            add.glow(at: heart, radius: 70 + 50 * CGFloat(heartGlow), color: tone,
                     alpha: 0.2 + 0.1 * beat + 0.35 * heartGlow)
            add.core(at: heart, radius: 4, color: Color.cream, alpha: 0.9)
            add.glow(at: m, radius: 16, color: Color.cream, alpha: 0.45)
            add.core(at: m, radius: 2.5, color: Color.cream, alpha: 0.95)
        }
    }

    /// The words this frame reads — his lines, reached as the practice reaches them.
    func visibleLines() -> [String] {
        let l = movement.lines
        func at(_ i: Int) -> [String] { i < l.count ? [l[i]] : [] }
        switch movement {
        case .euphoriaPulse:  return stage == 0 ? at(0) + at(1) : at(2) + at(3)
        case .roarAndSilence: return stage == 0 ? at(0) : at(1)
        case .lastMemories:
            switch stage {
            case 0:  return []
            case 1:  return at(1) + at(2)
            case 2:  return at(3)
            default: return []
            }
        case .hamHetHum:      return l
        case .fearInWaves:    return at(min(stage, 3))
        case .feelingThrough: return at(min(stage, 4))
        case .restlessness:   return at(min(stage, 1))
        case .heartHome:      return l
        }
    }
}

// MARK: - The surface

struct ChakraMovementPractice: View {
    let movement: ChakraMovement
    let chakra: Chakra33
    let soundOn: Bool
    /// The practice settled — with his words when, and only when, he chose to keep them.
    let onComplete: (_ words: String?, _ seconds: Double) -> Void
    let onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var field: MovementField
    @State private var motion = PlayMotion()
    /// Last memories: naming the memory comes before the eyes close.
    @State private var naming = true
    @State private var memory = ""
    @State private var keepWords = false

    init(movement: ChakraMovement, chakra: Chakra33, soundOn: Bool,
         onComplete: @escaping (_ words: String?, _ seconds: Double) -> Void,
         onClose: @escaping () -> Void) {
        self.movement = movement
        self.chakra = chakra
        self.soundOn = soundOn
        self.onComplete = onComplete
        self.onClose = onClose
        _field = State(initialValue: MovementField(movement: movement,
                                                   breathIndex: ChakraMovement.breathIndex(forRoad: chakra.road),
                                                   soundOn: soundOn))
    }

    private var tone: Color { ChakraConstellationDrawing.tone(chakra) }

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            RadialGradient(colors: [tone.opacity(0.10), Color.ground.opacity(0)],
                           center: .center, startRadius: 0, endRadius: 520)
                .blendMode(.plusLighter)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            TimelineView(.animation) { _ in
                ZStack {
                    Canvas { ctx, size in
                        let now = PlayClock.now
                        field.advance(now: now, size: size, motion: motion, reduceMotion: reduceMotion)
                        field.draw(ctx, size: size, now: now, tone: tone, reduceMotion: reduceMotion)
                    }
                    words
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)

            if !(movement == .lastMemories && naming) {
                TouchSenseSurface(onBegan: { field.began($0) },
                                  onMoved: { field.moved($0) },
                                  onEnded: { field.ended($0) })
                    .ignoresSafeArea()
                    .accessibilityElement()
                    .accessibilityLabel(movement.title)
                    .accessibilityHint(movement.lines.joined(separator: " "))
                    .accessibilityAddTraits(.allowsDirectInteraction)
            }

            if movement == .lastMemories && naming { namingPanel }

            VStack {
                HStack {
                    leaveButton
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            field.onComplete = {
                let kept = keepWords ? memory.trimmingCharacters(in: .whitespacesAndNewlines) : ""
                onComplete(kept.isEmpty ? nil : kept, PlayClock.now - field.startedAt)
            }
            motion.start()
        }
        .onDisappear { motion.stop() }
        .preferredColorScheme(.dark)
    }

    // MARK: Words

    @ViewBuilder
    private var words: some View {
        VStack(spacing: 14) {
            Text(movement.title)
                .font(AppFont.label(11.5))
                .tracking(2.6)
                .textCase(.uppercase)
                .foregroundStyle(tone.opacity(0.9))
                .padding(.top, 96)
            if movement == .hamHetHum { breathWords }
            Spacer()
            VStack(spacing: 10) {
                ForEach(field.visibleLines(), id: \.self) { line in
                    Text(line)
                        .font(AppFont.voice(19))
                        .foregroundStyle(Color.cream.opacity(0.86))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 34)
            .padding(.bottom, 90)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Ham · Het · Hum: the three syllables, this room's own the brightest, the
    /// one being breathed lit — and the breath and line of that third.
    @ViewBuilder
    private var breathWords: some View {
        let phase = field.breathPhase
        HStack(spacing: 22) {
            ForEach(Array(ChakraMovement.hamHetHumBreaths.enumerated()), id: \.offset) { pair in
                let lit = phase == pair.offset
                let ours = field.breathIndex == pair.offset
                Text(pair.element.syllable)
                    .font(AppFont.sanskrit(lit ? 34 : 26))
                    .tracking(2)
                    .foregroundStyle(ours ? Color.gold : Color.cream.opacity(lit ? 0.95 : 0.55))
            }
        }
        .padding(.top, 18)
        if let p = phase {
            let b = ChakraMovement.hamHetHumBreaths[p]
            Text(b.breath)
                .font(AppFont.label(12))
                .tracking(2.2)
                .textCase(.uppercase)
                .foregroundStyle(Color.cream.opacity(0.7))
            if let line = b.line {
                Text(line)
                    .font(AppFont.voice(18))
                    .foregroundStyle(Color.cream.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
            }
        }
    }

    // MARK: Last memories — the memory, named, kept only if he says so

    private var namingPanel: some View {
        VStack(spacing: 18) {
            Spacer()
            if let first = movement.lines.dropFirst().first {
                Text(first)
                    .font(AppFont.voice(19))
                    .foregroundStyle(Color.cream.opacity(0.86))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
            }
            TextField("", text: $memory, axis: .vertical)
                .font(AppFont.voice(18))
                .foregroundStyle(Color.cream)
                .lineLimit(1...4)
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).stroke(Color.cream.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 34)
                .accessibilityLabel("A memory, in your own words — optional")
            Button {
                keepWords.toggle()
                Haptics.light()
            } label: {
                Text(keepWords ? "these words will be kept in the record" : "these words will not be kept")
                    .font(AppFont.label(12))
                    .tracking(1.2)
                    .foregroundStyle(Color.cream.opacity(keepWords ? 0.85 : 0.6))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Nothing you write here is kept unless you choose it.")
            Button {
                naming = false
                field.closeEyes()
            } label: {
                Text(movement.lines.first ?? "")
                    .font(AppFont.sanskrit(24))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .padding(.horizontal, 28)
                    .frame(minHeight: 54)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Spacer().frame(height: 80)
        }
    }

    private var leaveButton: some View {
        Button {
            PlayHaptics.tap(0.3)
            onClose()
        } label: {
            Text("‹ back to the room")
                .font(AppFont.voice(16))
                .foregroundStyle(Color.cream.opacity(0.6))
                .padding(.horizontal, 6)
                .frame(minWidth: 64, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.leading, 14)
        .padding(.top, 8)
        .accessibilityLabel("Back to the room")
    }
}
