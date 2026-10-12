import SwiftUI
import SwiftData

// MARK: - Wave 2 · the centre: Mauna, the bloom, and the endless fall
// MARK:   Wave 6 · shown, never reached by doing (C-1307)
//
// Three of Design's gestures at the one point:
//
//   • **Mauna** (The Eight Modes, mode 5) — the silence at the point. Wave 2
//     opened it with a tap. **Wave 6: it arrives.** When he has fallen in to
//     the innermost enclosures and left the glass untouched for one breath, the
//     point notices him and the silence comes (``CentreArrival``). His Codex,
//     C-1307: *"What is above creation cannot be attained by action."* A voice
//     reaches it by the point's own accessibility action — resting there.
//     **Wave 6.1, his decision (12 Oct):** stillness stays the main way, and a
//     gentle tap at the point also opens it, when he wants it now.
//     Design's captions at 7, 14 and 21 seconds are gone (C-1355, *"the system
//     holds the door open and never the watch"*): nothing in the silence follows
//     a clock. The threshold says only his own line, *"Who is saying that?"*,
//     over the colourless Maya light, which dissolves while he is still and
//     returns if he moves (C-1305). Then **Pointy** draws — one particle at
//     every point, line → circle → ∞ → heart (C-1306). A silence held is its
//     own ledger event (``MaunaSilence``) and is never "felt".
//   • **The centre bloom** (G17, Ring 9's *Spanda*) — *hold the centre and the
//     whole Śrī Yantra blooms outward from the single point; release, and it
//     dissolves back into it.* A gesture of play at the point, not a way in: it
//     opens nothing.
//   • **The Shepard fall** (Ring 9's *Praveśa*) — Wave 2 fell while he pressed
//     and held. **Wave 6: the fall follows his stillness** (``MaunaDepth``):
//     still, it deepens; moved, it loosens. When the recognition has come and he
//     has rested in it, the point opens into Lalitā's source — shown, not taken.
//
// The point is the Bindu's seat on the glass, wherever the camera has it.

/// The point's gestures, over the living Mandala.
@MainActor
struct TheCentre: View {
    /// Where the Bindu stands on the glass now.
    let point: CGPoint
    /// Whether the centre answers now — not while a card, the Veil or the
    /// source holds the glass.
    let active: Bool
    /// The 102 on the glass, for the names that stand round the point.
    let seats: [MandalaWorld.Seat]
    /// The ♪ control.
    let soundOn: Bool
    /// Wave 6 · when the glass last moved (`LivingMandalaView.lastMoveAt`).
    var lastMoveAt: TimeInterval = Date().timeIntervalSinceReferenceDate
    /// Wave 6 · the deepest enclosure the camera has fallen into.
    var enteredRing: Int = 0
    /// Wave 6 · the glass, for "near the middle".
    var size: CGSize = .zero
    /// The fall reached its recognition and he rested in it: the point opens.
    let onFallThrough: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var press = BloomPress()
    @State private var maunaOpen = false
    /// When a finger last rested on the point (the bloom) — a touch, too.
    @State private var lastTouchAt: TimeInterval = 0
    /// The stillness the silence last arrived in, so it does not arrive twice
    /// in one stillness: the glass must move before the point notices again.
    @State private var restedIn: TimeInterval = -1

    /// The last instant the glass or the point was touched.
    private var lastTouched: TimeInterval { max(lastMoveAt, lastTouchAt) }

    var body: some View {
        ZStack {
            if active {
                bloom
                Circle()
                    .fill(Color.clear)
                    .frame(width: 64, height: 64)
                    .contentShape(Circle())
                    .position(point)
                    // Wave 6.1 · his decision (gameplan §4.1): stillness is the
                    // main way, and a gentle tap at the point also opens the
                    // silence, when he wants it now.
                    .onTapGesture { arrive() }
                    .onLongPressGesture(minimumDuration: 0.6, maximumDistance: 30,
                                        perform: { },
                                        onPressingChanged: { pressing in hold(pressing) })
                    .accessibilityElement()
                    .accessibilityLabel(Text("The point — be still here, and the silence arrives"))
                    .accessibilityHint(Text("Or touch it gently to enter the silence now."))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { arrive() }
            }
        }
        .fullScreenCover(isPresented: $maunaOpen) {
            MaunaView(seats: seats, soundOn: soundOn, onLeave: { fellThrough in
                maunaOpen = false
                guard fellThrough else { return }
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.5))
                    onFallThrough()
                }
            })
        }
        // The point notices him: restarted whenever the glass is touched, it
        // waits out one breath and then asks whether he is still at the centre.
        .task(id: NoticeKey(touched: lastTouched, active: active)) { await notice() }
    }

    private struct NoticeKey: Equatable {
        let touched: TimeInterval
        let active: Bool
    }

    private func notice() async {
        guard active, !maunaOpen else { return }
        let since = Date().timeIntervalSinceReferenceDate - lastTouched
        let wait = max(0.2, CentreArrival.oneBreath - since)
        try? await Task.sleep(for: .seconds(wait))
        guard !Task.isCancelled, active, !maunaOpen, !press.holding else { return }
        let untouched = Date().timeIntervalSinceReferenceDate - lastTouched
        guard CentreArrival.arrives(untouchedFor: untouched, enteredRing: enteredRing,
                                    point: point, size: size,
                                    restedSinceLastMove: restedIn == lastTouched) else { return }
        arrive()
    }

    /// The silence arrives — by his stillness, or by a voice's own action.
    private func arrive() {
        guard !maunaOpen else { return }
        press = press.changed(holding: false, at: Date().timeIntervalSinceReferenceDate)
        if soundOn { RingFieldVoice.shared.bloom(0) }
        restedIn = lastTouched
        Haptics.soft()
        maunaOpen = true
    }

    private func hold(_ pressing: Bool) {
        let now = Date().timeIntervalSinceReferenceDate
        lastTouchAt = now
        press = press.changed(holding: pressing, at: now)
        if soundOn { RingFieldVoice.shared.bloom(pressing ? 1 : 0) }
    }

    // MARK: - G17 · the yantra drawn outward from the point

    @ViewBuilder
    private var bloom: some View {
        if press.isVisible(at: Date().timeIntervalSinceReferenceDate) || press.holding {
            TimelineView(.animation(paused: reduceMotion)) { tl in
                let t = tl.date.timeIntervalSinceReferenceDate
                let p = reduceMotion ? (press.holding ? 1 : 0) : press.value(at: t)
                let names = Self.ringNames(seats, ring: 2)
                Canvas { context, size in
                    let side = min(size.width, size.height)
                    let unit = side * 0.46 / 150 * CGFloat(CentreBloom.scale(bloom: p))
                    var veil = context
                    veil.opacity = 0.55 * CentreBloom.ease(p)
                    veil.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.black))
                    CentreYantra.draw(in: context, centre: point, unit: unit,
                                      opacity: { CentreBloom.opacity($0, bloom: p) },
                                      names: names, rotation: .zero)
                    CentreYantra.drawBindu(in: context, centre: point,
                                           radius: 9 * (0.8 + 0.5 * CGFloat(CentreBloom.ease(p))))
                }
                .allowsHitTesting(false)
            }
            // Drawn in the glass's own coordinates — the same frame the
            // camera's `binduScreen()` is measured in — so the bloom opens
            // exactly from the point.
        }
    }

    /// Her ring's names, from the base's own rows, in garland order.
    static func ringNames(_ seats: [MandalaWorld.Seat], ring: Int) -> [String] {
        seats
            .filter { ($0.shakti.ringNumber ?? 0) == ring }
            .sorted { ($0.shakti.khadgamalaPosition ?? 0) < ($1.shakti.khadgamalaPosition ?? 0) }
            .map { $0.shakti.name }
            .filter { !$0.isEmpty }
    }
}

/// The bloom's state between frames: where it was when the press last changed,
/// and where it is going — so the bloom is a closed form of the clock (Design's
/// `p += (target − p) · 0.06`, as the exponential it is).
struct BloomPress: Equatable {
    var holding = false
    var from: Double = 0
    var at: TimeInterval = 0

    static let tau: Double = -1 / (60 * log(1 - 0.06))

    func value(at t: TimeInterval) -> Double {
        let target = holding ? 1.0 : 0.0
        return target + (from - target) * exp(-max(0, t - at) / Self.tau)
    }

    func changed(holding: Bool, at t: TimeInterval) -> BloomPress {
        BloomPress(holding: holding, from: value(at: t), at: t)
    }

    /// Whether anything of the bloom is still on the glass.
    func isVisible(at t: TimeInterval) -> Bool { holding || value(at: t) > 0.01 }
}

/// The silence's depth between frames — ``MaunaDepth`` advanced by real time,
/// ten times a second, whatever the glass is drawing.
final class MaunaClock {
    private(set) var state = MaunaDepth()
    private var last: TimeInterval?

    func advance(now: TimeInterval, steadiness: Double, givenOver: Bool, recognition: Double) {
        let dt = last.map { max(0, now - $0) } ?? 0
        last = now
        state.advance(dt: dt, steadiness: steadiness, givenOver: givenOver, recognition: recognition)
    }
}

// MARK: - Mauna

/// The silence at the point — and, as he stays still, the fall into it.
@MainActor
struct MaunaView: View {
    let seats: [MandalaWorld.Seat]
    let soundOn: Bool
    /// He has left the silence; `true` when the point opened to him after the
    /// fall's recognition.
    let onLeave: (_ fellThrough: Bool) -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var stillness = StillnessSensor()
    @State private var openedAt = Date()
    @State private var fall = PraveshaClock()
    @State private var deep = MaunaClock()
    /// VoiceOver's "rest here" — stands for a still phone.
    @State private var givenOver = false
    @State private var left = false

    var body: some View {
        GeometryReader { geo in
            // Under reduced motion nothing moves until the fall; the glass is
            // redrawn once a second so the threshold can still give way.
            TimelineView(.animation(minimumInterval: reduceMotion && !deep.state.isFalling ? 1 : nil,
                                    paused: false)) { tl in
                let now = tl.date
                let d = deep.state
                let state = fall.advance(now: now.timeIntervalSinceReferenceDate, holding: d.isFalling)
                ZStack {
                    Color(red: 2 / 255, green: 0, blue: 1 / 255)
                    if state.held > 0.05 {
                        falling(state, size: geo.size)
                    } else {
                        silence(since: now.timeIntervalSince(openedAt), depth: d, size: geo.size)
                    }
                    words(state, depth: d)
                }
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        // Touching the glass is leaving; stillness is staying.
        .onTapGesture { leave(fellThrough: false) }
        .theEdgeWayOut(onOut: { leave(fellThrough: false) })
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Silence at the point"))
        .accessibilityAction(named: Text("Rest here")) { givenOver = true }
        .accessibilityAction { leave(fellThrough: false) }
        .onAppear {
            openedAt = Date()
            stillness.start()
            RingFieldVoice.shared.hush()
        }
        .task {
            // The depth follows his stillness, and the Shepard tone the fall's
            // speed, ten times a second.
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.1))
                deep.advance(now: Date().timeIntervalSinceReferenceDate,
                             steadiness: stillness.steadiness,
                             givenOver: givenOver,
                             recognition: fall.recognition)
                if deep.state.opens {
                    leave(fellThrough: true)
                    return
                }
                guard soundOn else { continue }
                if fall.held > 0.05 {
                    RingFieldVoice.shared.fall(intensity: Pravesha.shepard(speed: fall.speed))
                } else {
                    RingFieldVoice.shared.stopFalling()
                }
            }
        }
        .onDisappear {
            stillness.stop()
            RingFieldVoice.shared.stopFalling()
            if soundOn { RingFieldVoice.shared.resume() }
        }
    }

    private func leave(fellThrough: Bool) {
        guard !left else { return }
        left = true
        MaunaSilence.record(seconds: Date().timeIntervalSince(openedAt), context: context)
        onLeave(fellThrough)
    }

    // MARK: The silence

    private func silence(since t: TimeInterval, depth d: MaunaDepth, size: CGSize) -> some View {
        let outer = TheCentre.ringNames(seats, ring: 2)
        let inner = TheCentre.ringNames(seats, ring: 3)
        let centre = CGPoint(x: size.width / 2, y: size.height / 2)
        let scale = size.width / 390
        let arrive = reduceMotion ? 1 : min(1, t / 5)
        let breath = reduceMotion ? 1 : Mauna.binduBreath(at: t)
        return ZStack {
            ForEach(Array(outer.enumerated()), id: \.offset) { i, name in
                orbitName(name, index: i, of: outer.count, radius: 158 * scale,
                          centre: centre, alpha: 0.32 * arrive, size: 12)
            }
            ForEach(Array(inner.enumerated()), id: \.offset) { i, name in
                orbitName(name, index: i, of: inner.count, radius: 110 * scale,
                          centre: centre, alpha: 0.26 * arrive, size: 11)
            }
            mayaLight(d.maya, centre: centre, scale: scale, t: t)
            pointy(d, centre: centre, scale: scale)
            Circle()
                .fill(RadialGradient(colors: [Color.accentRed, Color.accentRed.opacity(0.65), .clear],
                                     center: .center, startRadius: 0, endRadius: 42))
                .frame(width: 84, height: 84)
                .scaleEffect(CGFloat(breath))
                .shadow(color: Color.accentRed.opacity(0.55), radius: 36)
                .position(centre)
            Circle()
                .fill(Color.cream)
                .frame(width: 22, height: 22)
                .shadow(color: Color.cream, radius: 20)
                .position(centre)
        }
        .allowsHitTesting(false)
    }

    /// The colourless Maya light round the point (C-1305): no hue of its own,
    /// thinning while he looks, whole again if he moves.
    private func mayaLight(_ amount: Double, centre: CGPoint, scale: CGFloat, t: TimeInterval) -> some View {
        Canvas { ctx, _ in
            guard amount > 0.005 else { return }
            var c = ctx
            c.blendMode = .plusLighter
            let shimmer = reduceMotion ? 0 : 0.5 + 0.5 * sin(t * 0.7)
            for i in 0..<5 {
                let r = (54 + CGFloat(i) * 15 + CGFloat(shimmer) * 4) * scale
                let rect = CGRect(x: centre.x - r, y: centre.y - r, width: r * 2, height: r * 2)
                let a = amount * (0.16 - Double(i) * 0.022)
                c.fill(Path(ellipseIn: rect),
                       with: .radialGradient(Gradient(colors: [Color.white.opacity(0), Color.white.opacity(a),
                                                               Color.white.opacity(0)]),
                                             center: centre, startRadius: r * 0.6, endRadius: r))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// Pointy (C-1306): the same particles at every point at once, drawing a
    /// line, a circle, ∞, and a heart as he stays.
    private func pointy(_ d: MaunaDepth, centre: CGPoint, scale: CGFloat) -> some View {
        let light = d.pointyLight
        let progress = reduceMotion ? d.pointy.rounded() : d.pointy
        return Canvas { ctx, _ in
            guard light > 0.005 else { return }
            var c = ctx
            c.blendMode = .plusLighter
            let reach = 96 * scale
            for i in 0..<Pointy.particles {
                let u = Pointy.place(particle: i, progress: progress)
                let p = CGPoint(x: centre.x + u.x * reach, y: centre.y + u.y * reach)
                let glow: CGFloat = 5 * scale
                c.fill(Path(ellipseIn: CGRect(x: p.x - glow, y: p.y - glow, width: glow * 2, height: glow * 2)),
                       with: .radialGradient(Gradient(colors: [Color.gold.opacity(0.55 * light), .clear]),
                                             center: p, startRadius: 0, endRadius: glow))
                let core: CGFloat = 1.3 * scale
                c.fill(Path(ellipseIn: CGRect(x: p.x - core, y: p.y - core, width: core * 2, height: core * 2)),
                       with: .color(Color.cream.opacity(light)))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func orbitName(_ name: String, index i: Int, of n: Int, radius: CGFloat,
                           centre: CGPoint, alpha: Double, size: CGFloat) -> some View {
        let angle = (Double(i) / Double(max(1, n))) * 2 * .pi - .pi / 2
        let x = centre.x + radius * CGFloat(cos(angle))
        let y = centre.y + radius * CGFloat(sin(angle))
        // Decorative: Design's names as orbital stars round the point, a
        // watermark of who is here rather than words to read.
        return Text(name)
            .font(AppFont.voice(11))
            .tracking(1.6)
            .foregroundStyle(Color.cream)
            .opacity(alpha)
            .fixedSize()
            .rotationEffect(.radians(angle + .pi / 2))
            .position(x: x, y: y)
    }

    // MARK: The fall

    private func falling(_ state: PraveshaClock.Snapshot, size: CGSize) -> some View {
        let names = TheCentre.ringNames(seats, ring: 2)
        let recognition = state.recognition
        return Canvas { context, sz in
            let centre = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let base = min(sz.width, sz.height) / 390
            var ctx = context
            ctx.blendMode = .plusLighter
            for i in 0..<Pravesha.layers {
                let d = Pravesha.depth(layer: i, clock: state.clock)
                let unit = base * CGFloat(Pravesha.scale(depth: d))
                let rot = Angle.degrees(Double((i * 47) % 360) + state.clock * 6)
                let o = Pravesha.opacity(depth: d)
                CentreYantra.draw(in: ctx, centre: centre, unit: unit,
                                  opacity: { layer in
                                      layer == .names ? 0.42 * o : o * CentreYantra.restOpacity(layer)
                                  },
                                  names: names, rotation: rot)
            }
            CentreYantra.drawBindu(in: context, centre: centre,
                                   radius: 9 * (1 + 1.7 * CGFloat(recognition)))
        }
        .allowsHitTesting(false)
    }

    // MARK: The words — his and Design's, never generated, never on a clock

    @ViewBuilder
    private func words(_ state: PraveshaClock.Snapshot, depth d: MaunaDepth) -> some View {
        VStack(spacing: 14) {
            Spacer()
            if state.held > 0.05 {
                if state.recognition > 0.01 {
                    Text(Pravesha.recognised)
                        .font(AppFont.sanskrit(27))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.cream)
                        .opacity(state.recognition)
                    Text(Avarana.appreciationPhrase(forRing: 9))
                        .font(AppFont.voice(16))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.gold)
                        .opacity(state.recognition)
                } else {
                    Text(Pravesha.falling)
                        .font(AppFont.voice(21))
                        .foregroundStyle(Color.cream)
                        .opacity(0.8)
                    Text(Pravesha.fallingBeneath)
                        .font(AppFont.voice(14))
                        .foregroundStyle(Color.gold)
                        .opacity(0.7)
                }
            } else if d.pointyLight > 0.05 {
                Text(Pointy.loves)
                    .font(AppFont.voice(18))
                    .tracking(1)
                    .foregroundStyle(Color.cream)
                    .opacity(0.72 * d.pointyLight * MaunaDepth.band(d.pointy, 2.6, 3))
            } else {
                // The threshold into silence: his own question, going as the
                // Maya light goes.
                Text(WhoIsSaying.line)
                    .font(AppFont.voice(20))
                    .tracking(1)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .opacity(0.74 * max(d.maya, 0.0))
                Text(WhoIsSaying.beneath)
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.gold)
                    .opacity(0.6 * MaunaDepth.band(1 - d.maya, 0.5, 1) * (1 - MaunaDepth.band(d.depth, MaunaDepth.pointyFrom, MaunaDepth.pointyFrom + 0.04)))
            }
            Text(Self.hint)
                .font(AppFont.label(11))
                .tracking(1.6)
                .foregroundStyle(Color.cream)
                .opacity(0.4 * d.maya)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    /// What the threshold says of itself — the stillness, never a time.
    static let hint = "be still · a touch returns you"
}


/// The fall's clock between frames — Design's `heldTime`, `speedRef` and
/// `clock`, advanced by the frame's own `dt`.
final class PraveshaClock {
    struct Snapshot {
        let held: TimeInterval
        let recognition: Double
        let clock: Double
    }

    private(set) var held: TimeInterval = 0
    private(set) var speed: Double = 0.85
    private(set) var clock: Double = 0
    private var last: TimeInterval?

    var recognition: Double { Pravesha.recognition(held: held) }

    func advance(now: TimeInterval, holding: Bool) -> Snapshot {
        let dt = last.map { min(0.05, max(0, now - $0)) } ?? 0
        last = now
        held = holding ? held + dt : max(0, held - dt * 1.4)
        let target = Pravesha.speed(holding: holding, recognition: recognition)
        speed = ClimbLights.follow(speed, toward: target, dt: dt, tau: 0.37)
        clock += dt * speed * 0.08
        return Snapshot(held: held, recognition: recognition, clock: clock)
    }
}

// MARK: - The yantra, in Design's Ring 9 geometry

/// Design's `FullYantra` (`ring-nine.jsx`), in its own ±150 coordinates.
enum CentreYantra {

    static let gold = Color(red: 201 / 255, green: 150 / 255, blue: 63 / 255)
    static let triGold = Color(red: 212 / 255, green: 160 / 255, blue: 23 / 255)
    static let trikonaGold = Color(red: 232 / 255, green: 201 / 255, blue: 122 / 255)

    /// Design's per-layer opacities in the whole glyph.
    static func restOpacity(_ layer: CentreBloom.Layer) -> Double {
        switch layer {
        case .bhupura: return 0.6
        case .lotus16: return 0.55
        case .lotus8: return 0.5
        case .triangles, .trikona: return 0.85
        case .names: return 0.5
        }
    }

    static let ups: [(apex: CGFloat, base: CGFloat, half: CGFloat)] = [
        (-88, 34, 76), (-68, 26, 60), (-50, 18, 46), (-34, 10, 34),
    ]
    static let downs: [(apex: CGFloat, base: CGFloat, half: CGFloat)] = [
        (88, -34, 76), (72, -28, 66), (56, -22, 52), (42, -16, 40), (26, -10, 26),
    ]

    static func triangle(_ t: (apex: CGFloat, base: CGFloat, half: CGFloat)) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: t.apex))
        p.addLine(to: CGPoint(x: t.half, y: t.base))
        p.addLine(to: CGPoint(x: -t.half, y: t.base))
        p.closeSubpath()
        return p
    }

    /// Design's `r9Petal(oR, iR, hw)`.
    static func petal(outer oR: CGFloat, inner iR: CGFloat, halfWidth hw: CGFloat) -> Path {
        var p = Path()
        let c1y = -iR * 1.85, c2y = -oR * 0.85, c2x = hw * 0.95
        p.move(to: CGPoint(x: 0, y: -iR))
        p.addCurve(to: CGPoint(x: 0, y: -oR),
                   control1: CGPoint(x: hw, y: c1y), control2: CGPoint(x: c2x, y: c2y))
        p.addCurve(to: CGPoint(x: 0, y: -iR),
                   control1: CGPoint(x: -c2x, y: c2y), control2: CGPoint(x: -hw, y: c1y))
        p.closeSubpath()
        return p
    }

    static func petals(_ count: Int, outer: CGFloat, inner: CGFloat, halfWidth: CGFloat) -> Path {
        var all = Path()
        let one = petal(outer: outer, inner: inner, halfWidth: halfWidth)
        for i in 0..<count {
            let a = CGFloat(i) * 2 * .pi / CGFloat(count)
            all.addPath(one, transform: CGAffineTransform(rotationAngle: a))
        }
        return all
    }

    static let bhupura: Path = {
        var p = Path(CGRect(x: -150, y: -150, width: 300, height: 300))
        for (a, b) in [((0.0, -150.0), (0.0, -168.0)), ((0.0, 150.0), (0.0, 168.0)),
                       ((-150.0, 0.0), (-168.0, 0.0)), ((150.0, 0.0), (168.0, 0.0))] {
            p.move(to: CGPoint(x: a.0, y: a.1))
            p.addLine(to: CGPoint(x: b.0, y: b.1))
        }
        return p
    }()
    static let lotus16 = petals(16, outer: 132, inner: 112, halfWidth: 20)
    static let lotus8 = petals(8, outer: 104, inner: 88, halfWidth: 30)
    static let triangles: Path = {
        var p = Path()
        for t in ups { p.addPath(triangle(t)) }
        for t in downs.prefix(4) { p.addPath(triangle(t)) }
        return p
    }()
    static let trikona: Path = triangle(downs[4])

    /// Draw the yantra at `centre`, `unit` points to one of Design's units.
    static func draw(in context: GraphicsContext, centre: CGPoint, unit: CGFloat,
                     opacity: (CentreBloom.Layer) -> Double,
                     names: [String], rotation: Angle) {
        guard unit > 0.001 else { return }
        var ctx = context
        ctx.blendMode = .plusLighter
        let place = CGAffineTransform(translationX: centre.x, y: centre.y)
            .rotated(by: CGFloat(rotation.radians))
            .scaledBy(x: unit, y: unit)
        let layers: [(CentreBloom.Layer, Path, Color, CGFloat)] = [
            (.bhupura, bhupura, gold, 1),
            (.lotus16, lotus16, gold, 0.7),
            (.lotus8, lotus8, gold, 0.7),
            (.triangles, triangles, triGold, 0.8),
            (.trikona, trikona, trikonaGold, 0.9),
        ]
        for (layer, path, colour, width) in layers {
            let o = opacity(layer)
            guard o > 0.005 else { continue }
            let placed = path.applying(place)
            ctx.stroke(placed, with: .color(colour.opacity(o * 0.35)),
                       lineWidth: max(1, width * unit * 4))
            ctx.stroke(placed, with: .color(colour.opacity(o)), lineWidth: max(0.5, width * unit))
        }
        let nameOpacity = opacity(.names)
        guard nameOpacity > 0.01, !names.isEmpty, unit > 0.35 else { return }
        var words = context
        words.opacity = nameOpacity
        for (i, name) in ringOfSixteen(names).enumerated() {
            let a = CGFloat(i) * 2 * .pi / 16 - .pi / 2 + CGFloat(rotation.radians)
            let r = 121 * unit
            let at = CGPoint(x: centre.x + r * cos(a), y: centre.y + r * sin(a))
            words.draw(Text(name)
                        .font(AppFont.voice(11))
                        .foregroundColor(Color.cream),
                       at: at)
        }
    }

    /// Sixteen names round the lotus, her ring's own, repeated if fewer.
    static func ringOfSixteen(_ names: [String]) -> [String] {
        guard !names.isEmpty else { return [] }
        return (0..<16).map { names[$0 % names.count] }
    }

    /// The point — Design's ember: a red glow with a cream heart.
    static func drawBindu(in context: GraphicsContext, centre: CGPoint, radius: CGFloat) {
        var ctx = context
        ctx.blendMode = .plusLighter
        let glow = CGRect(x: centre.x - radius * 2.6, y: centre.y - radius * 2.6,
                          width: radius * 5.2, height: radius * 5.2)
        ctx.fill(Path(ellipseIn: glow),
                 with: .radialGradient(Gradient(colors: [Color.accentRed, Color.accentRed.opacity(0)]),
                                       center: centre, startRadius: 0, endRadius: radius * 2.6))
        let heart = radius * 0.32
        ctx.fill(Path(ellipseIn: CGRect(x: centre.x - heart, y: centre.y - heart,
                                        width: heart * 2, height: heart * 2)),
                 with: .color(Color.cream))
    }
}
