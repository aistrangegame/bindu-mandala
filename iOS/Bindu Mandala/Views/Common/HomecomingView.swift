import SwiftUI
import SwiftData

/// **The Homecoming — the Bindu Origin, become Mandala's door.**
///
/// Wave 3 (`waves/wave-3-origin.md`). The Bindu Chakras app's Origin
/// (`Bindu Immersive.html`, `bindu-slice-a.js`) and G17: *the light condenses,
/// blinks, and the yantra draws itself outward from the point.*
///
/// **The first time** (and whenever he asks for it again from Settings): the
/// indigo sky, empty; motes of light drift in from everywhere and condense into
/// one point; the two lines arrive; then the covenant is offered — *rest one
/// finger on the glass, and be still* — and "tap to enter" beside it.
///
/// **Every return after the first compresses to one breath** — the Bindu's own
/// four seconds: the point is already there, it blinks, the yantra draws itself
/// outward from it, and the instrument opens. A finger laid on the glass during
/// that breath holds it open for the covenant.
///
/// **The covenant touch** — one finger, still, for one breath — is answered:
/// the point blinks (the first act of life, Design's `blink()`), the yantra
/// draws outward, and the instrument hands straight into the Recognition
/// ceremony for today's Śakti, with its two lines exactly as they are. A touch
/// that lifts before the breath is simply a way in: the yantra draws and the
/// instrument opens. Leaving is one gesture, never punished.
///
/// `SKIP_HOMECOMING` (every UI test) still never shows it; reduce motion gets
/// the same beats as stillnesses — the point present, the yantra arriving
/// whole, the words simply there.
struct HomecomingView: View {
    @Binding var isPresented: Bool
    /// Upgrade U2 · A · when Home hosts the Homecoming (`Home/HomeWorld.swift`),
    /// the covenant does not cover the instrument with the Recognition: the
    /// Homecoming finishes into Home, and Home opens the Today door after it has
    /// stood one breath (`spine-and-home.md` #2, §7 settled 1). Nil keeps the
    /// old way (RootView's shell).
    var onCovenant: (() -> Void)? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    /// Fixed at arrival: the first time, or a return.
    @State private var returning: Bool = HomecomingView.hasLaunched
    @State private var born = Date()
    @State private var line1Visible = false
    @State private var line2Visible = false
    @State private var hintVisible = false
    /// When the point blinked, and when the yantra began to draw from it.
    @State private var blinkAt: Date?
    @State private var drawAt: Date?
    /// The finger on the glass, while it is there.
    @State private var touchAt: Date?
    @State private var touchFrom: CGPoint = .zero
    @State private var touchMoved = false
    @State private var answered = false        // covenant met or way in taken
    @State private var showCeremony = false
    @State private var ceremonyShakti: Shakti?

    private let variant = LunarPhaseService.currentTimeVariant()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MandalaSky(variant: variant, dayGlow: Color.gold.opacity(0.16))
                    .ignoresSafeArea()

                TimelineView(.animation(paused: reduceMotion)) { tl in
                    let now = reduceMotion ? Date.distantFuture : tl.date
                    Canvas { ctx, size in
                        draw(ctx, size: size, now: now)
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

                words(in: geo.size)

                // §4.4: a screen left by touching anywhere has nothing under the
                // finger for a voice to find. Two actions: in, and the covenant.
                Color.clear
                    .accessibilityElement()
                    .accessibilityLabel(MandalaVoice.enterFromHomecoming)
                    .accessibilitySortPriority(-1)
                    .accessibilityAction { enter() }
                    .accessibilityAction(named: Text("Rest here, and be met")) { covenant() }
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
            .gesture(touch)
        }
        .onAppear(perform: arrive)
        .fullScreenCover(isPresented: $showCeremony, onDismiss: finish) {
            if let s = ceremonyShakti {
                RecognitionMomentView(shakti: s, isPresented: $showCeremony, source: .today)
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    // MARK: Words

    private func words(in size: CGSize) -> some View {
        let fading = drawAt != nil
        return VStack(spacing: 0) {
            Spacer(minLength: 0)
                .frame(height: size.height * 0.58)

            Text("You have always felt them.")
                .font(AppFont.voice(22))
                .tracking(1.0)
                .foregroundStyle(Color.cream)
                .multilineTextAlignment(.center)
                .opacity(line1Visible && !fading ? 1 : 0)
                .padding(.bottom, 18)

            Text("Now you will know their names.")
                .font(AppFont.voice(22))
                .tracking(1.0)
                .foregroundStyle(Color.cream)
                .multilineTextAlignment(.center)
                .opacity(line2Visible && !fading ? 1 : 0)

            Spacer()

            Text("rest one finger on the glass, and be still")
                .font(AppFont.label(11.5))
                .tracking(2.2)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 14)
                .opacity(hintVisible && !fading && touchAt == nil ? 1 : 0)

            Text("tap to enter".uppercased())
                .font(AppFont.label(11))
                .tracking(2.8)
                .foregroundStyle(Color.cream.opacity(0.50))
                .padding(.bottom, 40)
                .opacity(hintVisible && !fading ? 1 : 0)
        }
        .frame(width: size.width, height: size.height)
        .animation(.easeInOut(duration: reduceMotion ? 0.01 : 1.2), value: fading)
        .allowsHitTesting(false)
    }

    // MARK: The beats

    private func arrive() {
        born = Date()
        if returning {
            // One breath: blink, draw outward, open — unless a finger stays.
            let s = HomecomingScore.self
            DispatchQueue.main.asyncAfter(deadline: .now() + s.returnBlink) {
                guard !answered else { return }
                blinkAt = Date()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + s.returnDraw) {
                guard !answered, drawAt == nil else { return }
                drawAt = Date()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + s.breath) {
                guard !answered, touchAt == nil else { return }
                answered = true
                finish()
            }
            return
        }
        let s = HomecomingScore.self
        if reduceMotion {
            line1Visible = true
            line2Visible = true
            hintVisible = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + s.firstLine1) {
            withAnimation(.easeInOut(duration: 2.0)) { line1Visible = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + s.firstLine2) {
            withAnimation(.easeInOut(duration: 2.0)) { line2Visible = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + s.firstHint) {
            withAnimation(.easeIn(duration: 1.0)) { hintVisible = true }
        }
    }

    /// One finger: a lift before the breath is a way in; held still for the
    /// breath, it is the covenant.
    private var touch: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                guard !answered else { return }
                if touchAt == nil {
                    touchAt = Date()
                    touchFrom = v.location
                    touchMoved = false
                    let held = Date()
                    DispatchQueue.main.asyncAfter(deadline: .now() + HomecomingScore.covenantHold) {
                        // Still the same touch, still still: the covenant.
                        guard touchAt == held, !touchMoved, !answered else { return }
                        covenant()
                    }
                } else if hypot(v.location.x - touchFrom.x, v.location.y - touchFrom.y) > 14 {
                    touchMoved = true
                }
            }
            .onEnded { _ in
                touchAt = nil
                if !answered { enter() }
            }
    }

    /// The way in: the point blinks, the yantra draws outward, the instrument opens.
    private func enter() {
        guard !answered else { return }
        answered = true
        sound()
        if blinkAt == nil { blinkAt = Date() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (reduceMotion ? 0 : HomecomingScore.blink)) {
            if drawAt == nil { drawAt = Date() }
        }
        // On a return the yantra is already drawing: open as soon as it stands.
        let after = returning ? HomecomingScore.returnOpenAfterTouch
                              : HomecomingScore.enterAfter(reduceMotion: reduceMotion)
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            finish()
        }
    }

    /// The covenant met: blink, draw outward, and hand straight into the
    /// Recognition ceremony for today's Śakti.
    private func covenant() {
        guard !answered else { return }
        answered = true
        Haptics.soft()
        sound()
        blinkAt = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + (reduceMotion ? 0 : HomecomingScore.blink)) {
            drawAt = Date()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + HomecomingScore.enterAfter(reduceMotion: reduceMotion)) {
            if let onCovenant {
                finish()
                onCovenant()
                return
            }
            if let today = HomecomingView.todaysShakti(in: shaktis) {
                ceremonyShakti = today
                showCeremony = true
            } else {
                finish()
            }
        }
    }

    /// The point's own tone — 136.1 Hz with its fifth and octave — on the first
    /// touch, as Charter II's sound law asks (the point takes 136.1).
    private func sound() {
        BijaSoundService.shared.playVakChord(frequencies: [136.1, 204.15, 272.2],
                                             duration: 3.6, volume: 0.045, stagger: 0.18)
    }

    private func finish() {
        UserDefaults.standard.set(true, forKey: HomecomingView.userDefaultsKey)
        isPresented = false
    }

    // MARK: The drawing

    private func draw(_ ctx: GraphicsContext, size: CGSize, now: Date) {
        let s = HomecomingScore.self
        let centre = CGPoint(x: size.width / 2, y: size.height / 2)
        let age = now.timeIntervalSince(born)
        var add = ctx
        add.blendMode = .plusLighter

        // 1 · The light condenses (first time only).
        let condensed: Double = returning ? 1 : s.condensed(age: age)
        if !returning && condensed < 1 {
            for m in HomecomingScore.motes {
                let from = CGPoint(x: m.x * size.width, y: m.y * size.height)
                let e = condensed
                let p = CGPoint(x: from.x + (centre.x - from.x) * e, y: from.y + (centre.y - from.y) * e)
                let a = (1 - e * 0.7) * m.alpha * min(1, max(0, (age - s.firstCondenseStart) * 0.8))
                guard a > 0.01 else { continue }
                let r = m.r * CGFloat(1 - e * 0.6)
                add.fill(Path(ellipseIn: CGRect(x: p.x - r * 3, y: p.y - r * 3, width: r * 6, height: r * 6)),
                         with: .radialGradient(Gradient(colors: [Self.originGold.opacity(a), Self.originGold.opacity(0)]),
                                               center: p, startRadius: 0, endRadius: r * 3))
            }
        }

        // 2 · The yantra draws itself outward from the point.
        let drawn: Double = drawAt.map { now.timeIntervalSince($0) } ?? -1
        if drawn >= 0 {
            let scale = min(size.width, size.height) / MandalaWorld.box * 0.94
            let m = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: centre.x, ty: centre.y)
            for layer in SriYantraGeometry.layers {
                let p = s.drawProgress(meanRadius: Double(layer.meanRadius / SriYantraGeometry.radius),
                                       elapsed: drawn, span: s.drawSpan(returning: returning))
                guard p > 0 else { continue }
                let path = layer.path.applying(m).trimmedPath(from: 0, to: CGFloat(p))
                let tone: Color = layer.kind == .bhupura || layer.kind == .gate ? variant.bhupuraTone
                    : (layer.kind == .triangle ? variant.triangleTone : Color.gold)
                let w = max(0.8, layer.width * scale)
                add.stroke(path, with: .color(tone.opacity(layer.alpha * 0.22)),
                           style: StrokeStyle(lineWidth: w * 4, lineCap: .round, lineJoin: .round))
                ctx.stroke(path, with: .color(tone.opacity(min(1, layer.alpha * 1.4))),
                           style: StrokeStyle(lineWidth: w, lineCap: .round, lineJoin: .round))
                // The drawing tip carries a little light ahead of the line.
                if p < 1, let tip = path.currentPoint {
                    add.fill(Path(ellipseIn: CGRect(x: tip.x - 5, y: tip.y - 5, width: 10, height: 10)),
                             with: .radialGradient(Gradient(colors: [Color.cream.opacity(0.5), Color.cream.opacity(0)]),
                                                   center: tip, startRadius: 0, endRadius: 5))
                }
            }
        }

        // 3 · The point — gold as it condenses, warming to the Bindu's red as
        //     the yantra arrives round it; breathing on the Bindu's 4 s.
        let presence: Double = returning ? min(1, age / 0.5) : condensed
        guard presence > 0.01 else { return }
        let breath = reduceMotion ? 0 : 0.5 - 0.5 * cos(2 * .pi * age / s.breath)
        let blinkA = blinkAt.map { s.blinkOpen(since: now.timeIntervalSince($0)) } ?? 1
        let warm = drawn >= 0 ? min(1, drawn / max(0.1, s.drawSpan(returning: returning))) : 0
        let holdGlow: Double = touchAt.map { min(1, now.timeIntervalSince($0) / s.covenantHold) } ?? 0
        let r = 7 * CGFloat(1 + 0.08 * breath)

        // Glow: wider as the finger holds — the room leans in.
        let glowR = r * CGFloat(5 + 6 * holdGlow + 3 * warm)
        add.fill(Path(ellipseIn: CGRect(x: centre.x - glowR, y: centre.y - glowR, width: glowR * 2, height: glowR * 2)),
                 with: .radialGradient(Gradient(colors: [Self.originGold.opacity(0.45 * presence * (1 - warm * 0.5)),
                                                         variant.binduColor.opacity(0.35 * warm),
                                                         Color.clear]),
                                       center: centre, startRadius: 0, endRadius: glowR))
        // The point itself, blinking: an eyelid closing on the vertical.
        let core = CGRect(x: centre.x - r, y: centre.y - r * CGFloat(blinkA), width: r * 2,
                          height: max(0.6, r * 2 * CGFloat(blinkA)))
        let ink = Self.mix(Self.originGoldRGB, Self.binduRedRGB, warm)
        ctx.fill(Path(ellipseIn: core),
                 with: .color(Color(red: ink.0, green: ink.1, blue: ink.2).opacity(presence * (0.35 + 0.65 * blinkA))))
    }

    // MARK: Colour

    /// Design's Origin gold, `#E8C568` (the Map's Color Hex for the Bindu).
    private static let originGold = Color(hex: "#E8C568")
    private static let originGoldRGB = (0.910, 0.773, 0.408)
    /// The Mandala's Bindu red, `#8B1A2A`.
    private static let binduRedRGB = (0.545, 0.102, 0.165)

    private static func mix(_ a: (Double, Double, Double), _ b: (Double, Double, Double),
                            _ t: Double) -> (Double, Double, Double) {
        (a.0 + (b.0 - a.0) * t, a.1 + (b.1 - a.1) * t, a.2 + (b.2 - a.2) * t)
    }

    // MARK: Today's Śakti — the one the covenant hands into

    /// The same rule as the Rite: the pinned position, else today's of the 102,
    /// else today's of whoever is on the phone yet.
    static func todaysShakti(in shaktis: [Shakti]) -> Shakti? {
        guard !shaktis.isEmpty else { return nil }
        if let pos = AppRuntime.pinnedEnergyPosition,
           let s = shaktis.first(where: { $0.khadgamalaPosition == pos }) { return s }
        if shaktis.contains(where: { ($0.khadgamalaPosition ?? 0) > 0 }) {
            let pos = DailyEnergyService.todaysPosition()
            if let s = shaktis.first(where: { $0.khadgamalaPosition == pos }) { return s }
        }
        let sorted = shaktis.sorted {
            ($0.khadgamalaPosition ?? $0.position) < ($1.khadgamalaPosition ?? $1.position)
        }
        let idx = DailyEnergyService.todaysPosition(count: sorted.count) - 1
        return sorted[min(max(0, idx), sorted.count - 1)]
    }

    // MARK: First launch, and asking for it again

    static let userDefaultsKey = "hasLaunched"

    static var hasLaunched: Bool {
        UserDefaults.standard.bool(forKey: userDefaultsKey)
    }

    /// Settings → "Re-enter the Homecoming". U2 · the Router owes the shell
    /// the ceremony (`Router.reEnterHomecoming`), and `AppRoot` re-presents it
    /// at Home without requiring an app relaunch.
    static func reset() {
        UserDefaults.standard.set(false, forKey: userDefaultsKey)
        Task { @MainActor in Router.shared.reEnterHomecoming() }
    }
}

// MARK: - The Homecoming's score (pure)

/// The beats of the Origin, in seconds, and the shapes of its motions — pure,
/// so `HomecomingScoreTests` can hold the one-breath return to its breath.
enum HomecomingScore {
    /// The Bindu's breath on the Mandala (`MandalaBreath`, ring 9): 4 s.
    static let breath: Double = 4
    /// The covenant: one finger, still, for one breath.
    static let covenantHold: Double = breath
    /// The blink — Design's `blink()`: close ~0.36 s, rest 0.14, open ~0.45.
    static let blink: Double = 0.95

    // The first time.
    static let firstCondenseStart: Double = 2.0
    static let firstCondenseEnd: Double = 11.0
    static let firstLine1: Double = 11.8
    static let firstLine2: Double = 14.0
    static let firstHint: Double = 16.5

    // Every return: one breath.
    static let returnBlink: Double = 0.35
    static let returnDraw: Double = 0.9
    /// A touch lifted during the return's breath: the yantra is already
    /// drawing, so the instrument opens a moment later rather than a breath.
    static let returnOpenAfterTouch: Double = 1.2

    /// How long the yantra takes to draw outward from the point.
    static func drawSpan(returning: Bool) -> Double { returning ? 2.8 : 3.6 }

    /// After a way in is taken: the blink, the drawing, and a breath of the
    /// whole yantra standing before it opens.
    static func enterAfter(reduceMotion: Bool) -> Double {
        reduceMotion ? 0.8 : blink + drawSpan(returning: false) + 0.6
    }

    /// 0 → 1 over the condensation, eased in and out.
    static func condensed(age: Double) -> Double {
        let x = min(1, max(0, (age - firstCondenseStart) / (firstCondenseEnd - firstCondenseStart)))
        return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2
    }

    /// How far one layer of the yantra has drawn, `elapsed` seconds into the
    /// drawing. `meanRadius` is the layer's distance from the point as a
    /// fraction of the yantra's radius: the star starts first, the Bhūpura
    /// last — the yantra drawn **outward from the point**.
    static func drawProgress(meanRadius: Double, elapsed: Double, span: Double) -> Double {
        let start = min(1, max(0, meanRadius)) * span * 0.55
        let length = span * 0.45
        return min(1, max(0, (elapsed - start) / length))
    }

    /// The eyelid: 1 open, 0 shut. Closes, rests, opens.
    static func blinkOpen(since t: Double) -> Double {
        guard t >= 0 else { return 1 }
        if t < 0.36 { return 1 - ease(t / 0.36) }
        if t < 0.50 { return 0 }
        if t < 0.95 { return ease((t - 0.50) / 0.45) }
        return 1
    }

    private static func ease(_ x: Double) -> Double {
        x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2
    }

    /// Ninety motes scattered over the glass, seeded so they are the same every
    /// time — the light that condenses into the point.
    struct Mote { let x: CGFloat; let y: CGFloat; let r: CGFloat; let alpha: Double }
    static let motes: [Mote] = {
        var seed: UInt64 = 1_343_134_4
        func rnd() -> Double {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            return Double(seed >> 11) / Double(1 << 53)
        }
        return (0..<90).map { _ in
            Mote(x: CGFloat(rnd()), y: CGFloat(rnd()), r: CGFloat(0.6 + rnd() * 1.6),
                 alpha: 0.15 + rnd() * 0.5)
        }
    }()
}
