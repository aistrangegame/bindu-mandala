import SwiftUI
import SwiftData

// MARK: - Wave 2 · the centre: Mauna, the bloom, and the endless fall
//
// Three of Design's gestures at the one point, none of which the built
// instrument had a home for:
//
//   • **Mauna** (The Eight Modes, mode 5) — *tap the centre for silence.* The
//     `.silence` gesture's true home. The field goes dark and quiet, the names
//     stand as faint stars round the point, and Design's three captions arrive
//     at 7, 14 and 21 seconds; at 28 there is only silence. A silence held is
//     its own ledger event (``MaunaSilence``) and is never "felt".
//   • **The centre bloom** (G17, Ring 9's *Spanda*) — *hold the centre and the
//     whole Śrī Yantra blooms outward from the single point; release, and it
//     dissolves back into it.* Drawn over the living field while held, with
//     the point's own 136.1 swelling under it.
//   • **The Shepard fall** (Ring 9's *Praveśa*) — inside the silence, *press
//     and hold — fall inward*: self-similar yantras emerge from the point
//     forever, each carrying its own bindu, to a Shepard tone that never
//     reaches a bottom. Held past the recognition (Design's 6.5 s), the fall
//     settles and Design's words arrive; let go then, and the point opens into
//     Lalitā's source, which is where the fall was always going.
//
// The point is the Bindu's seat on the glass, wherever the camera has it.

/// The point's three gestures, over the living Mandala.
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
    /// The fall reached its recognition and he let go: the point opens.
    let onFallThrough: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var press = BloomPress()
    @State private var maunaOpen = false

    var body: some View {
        ZStack {
            if active {
                bloom
                Circle()
                    .fill(Color.clear)
                    .frame(width: 64, height: 64)
                    .contentShape(Circle())
                    .position(point)
                    .onTapGesture { openMauna() }
                    .onLongPressGesture(minimumDuration: 0.6, maximumDistance: 30,
                                        perform: { },
                                        onPressingChanged: { pressing in hold(pressing) })
                    .accessibilityElement()
                    .accessibilityLabel(Text("The point — touch for silence, hold to breathe the yantra open"))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { openMauna() }
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
    }

    private func openMauna() {
        hold(false)
        Haptics.soft()
        maunaOpen = true
    }

    private func hold(_ pressing: Bool) {
        let now = Date().timeIntervalSinceReferenceDate
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
            .ignoresSafeArea()
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

// MARK: - Mauna

/// The silence at the point — and, held, the fall into it.
@MainActor
struct MaunaView: View {
    let seats: [MandalaWorld.Seat]
    let soundOn: Bool
    /// He has left the silence; `true` when he let go after the fall's
    /// recognition, and the point should open.
    let onLeave: (_ fellThrough: Bool) -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var openedAt = Date()
    @State private var holding = false
    @State private var fall = PraveshaClock()
    @State private var left = false

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation(paused: reduceMotion && !holding)) { tl in
                let now = tl.date
                let state = fall.advance(now: now.timeIntervalSinceReferenceDate, holding: holding)
                ZStack {
                    Color(red: 2 / 255, green: 0, blue: 1 / 255)
                    if state.held > 0.05 {
                        falling(state, size: geo.size)
                    } else {
                        silence(since: now.timeIntervalSince(openedAt), size: geo.size)
                    }
                    words(state, since: now.timeIntervalSince(openedAt))
                }
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { leave(fellThrough: false) }
        .onLongPressGesture(minimumDuration: 0.3, maximumDistance: 60,
                            perform: { },
                            onPressingChanged: { pressing in
                                holding = pressing
                                if !pressing, fall.recognition >= 0.99 { leave(fellThrough: true) }
                            })
        .theEdgeWayOut(onOut: { leave(fellThrough: false) })
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Silence at the point"))
        .accessibilityAction { leave(fellThrough: false) }
        .onAppear {
            openedAt = Date()
            RingFieldVoice.shared.hush()
        }
        .task {
            // The Shepard tone follows the fall's speed, ten times a second.
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.1))
                guard soundOn else { continue }
                if fall.held > 0.05 {
                    RingFieldVoice.shared.fall(intensity: Pravesha.shepard(speed: fall.speed))
                } else {
                    RingFieldVoice.shared.stopFalling()
                }
            }
        }
        .onDisappear {
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

    private func silence(since t: TimeInterval, size: CGSize) -> some View {
        let outer = TheCentre.ringNames(seats, ring: 2)
        let inner = TheCentre.ringNames(seats, ring: 3)
        let centre = CGPoint(x: size.width / 2, y: size.height / 2)
        let scale = size.width / 390
        let arrive = reduceMotion ? 1 : min(1, t / 5)
        return ZStack {
            ForEach(Array(outer.enumerated()), id: \.offset) { i, name in
                orbitName(name, index: i, of: outer.count, radius: 158 * scale,
                          centre: centre, alpha: 0.32 * arrive, size: 12)
            }
            ForEach(Array(inner.enumerated()), id: \.offset) { i, name in
                orbitName(name, index: i, of: inner.count, radius: 110 * scale,
                          centre: centre, alpha: 0.26 * arrive, size: 11)
            }
            let breath = reduceMotion ? 1 : Mauna.binduBreath(at: t)
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

    // MARK: The words — Design's, never generated

    @ViewBuilder
    private func words(_ state: PraveshaClock.Snapshot, since t: TimeInterval) -> some View {
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
            } else {
                if let caption = Mauna.caption(at: t), !caption.isEmpty {
                    Text(caption)
                        .font(AppFont.voice(18))
                        .tracking(1)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.cream)
                        .opacity(0.7)
                        .transition(.opacity)
                        .id(caption)
                }
                if t < 7 {
                    Text(Pravesha.rest)
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.cream)
                        .opacity(0.56)
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
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
        for i in 0..<16 {
            let a = CGFloat(i) * 2 * .pi / 16 - .pi / 2 + CGFloat(rotation.radians)
            let r = 121 * unit
            let at = CGPoint(x: centre.x + r * cos(a), y: centre.y + r * sin(a))
            words.draw(Text(names[i % names.count])
                        .font(AppFont.voice(11))
                        .foregroundColor(Color.cream),
                       at: at)
        }
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
