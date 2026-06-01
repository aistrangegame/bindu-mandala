import SwiftUI
import SwiftData

/// Ring 3 World — the Anaṅga Field (the Smoke Lotus).
///
/// Eight bodyless plumes around a shared seed (hsauṁ). The teaching is in the
/// interaction: when you reach (move your finger), the plumes scatter and
/// thin; when you are still, they gather into a full lotus. Tap a plume to
/// meet her quality; tap the seed to gather all eight into one longing.
struct RingThreeWorldView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var avaranas: [Avarana]
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var active: Int? = nil
    @State private var unified: Bool = false
    @State private var moving: Bool = false
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var moveTimer: Task<Void, Never>? = nil
    @State private var unifyTask: Task<Void, Never>? = nil

    private let rose = Color(hex: "#C4725A")
    private let warm = Color(hex: "#E0937A")

    private var ring3Avarana: Avarana? {
        avaranas.first(where: { $0.ringNumber == 3 })
    }

    private var ring3Shaktis: [Shakti] {
        Array(allShaktis.filter { $0.ringNumber == 3 }
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
            .prefix(8))
    }

    var body: some View {
        ZStack {
            // Atmospheric ground
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#160A0C"), location: 0),
                    .init(color: Color(hex: "#0A0406"), location: 0.55),
                    .init(color: Color(hex: "#060103"), location: 1)
                ]),
                center: UnitPoint(x: 0.5, y: 0.46),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()

            // Rose ambient
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: rose.opacity(0.13), location: 0),
                    .init(color: Color.accentRed.opacity(0.05), location: 0.50),
                    .init(color: .clear, location: 0.78)
                ]),
                center: UnitPoint(x: 0.5, y: 0.44),
                startRadius: 0, endRadius: 380
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Dust motes — every other ring world had these; Ring 3 was
            // missing them, which made the air feel dead even with the
            // plumes lit.
            DustMotesView(count: 7)
                .allowsHitTesting(false)

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy: CGFloat = min(392, geo.size.height * 0.46)

                ZStack {
                    // Ring identity
                    VStack(spacing: 5) {
                        Text("Sarvasaṅkṣobhaṇa · the Anaṅgas")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(2.8)
                            .foregroundStyle(rose.opacity(0.78))
                        Text("EIGHT FORMS · ONE BODILESS LONGING")
                            .font(.system(size: 10))
                            .tracking(3.0)
                            .foregroundStyle(Color.cream.opacity(0.45))
                    }
                    .position(x: cx, y: 96)
                    .allowsHitTesting(false)

                    // 8 smoke plumes
                    ForEach(0..<8, id: \.self) { i in
                        plume(at: i, cx: cx, cy: cy)
                    }

                    // hsauṁ seed at center — tap to unify
                    seedView(cx: cx, cy: cy)

                    // Caption block
                    captionBlock
                        .frame(maxWidth: geo.size.width - 72)
                        .position(x: cx, y: geo.size.height - 224)

                    // Hint line
                    Text("BE STILL TO LET HER GATHER · TOUCH A PLUME · THE SEED FOR ALL EIGHT")
                        .font(.system(size: 8.5))
                        .tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.40))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 28)
                        .position(x: cx, y: geo.size.height - 96)
                        .allowsHitTesting(false)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { release() }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Carve out the top 80pt as a clean dismiss zone — drags
                    // starting there do NOT trigger the scatter mechanic, so
                    // the arc-tap dismiss has a clear path to the touch.
                    guard value.startLocation.y > 80 else { return }
                    onMove()
                }
        )
        .offset(y: dragOffset)
        // `.simultaneousGesture` rather than `.gesture` so the swipe-down
        // dismiss can co-exist with the scatter mechanic above. A plain
        // `.gesture(swipeDown)` would be blocked because the scatter's
        // minimumDistance:0 claims the touch first.
        .simultaneousGesture(swipeDown)
        .overlay(alignment: .top) {
            DismissArc()
                .frame(height: 60)
                .contentShape(Rectangle())
                .highPriorityGesture(
                    TapGesture().onEnded { dismiss() }
                )
        }
        .overlay(alignment: .bottomLeading) {
            RingSoundDot(
                isOn: $soundOn,
                label: "longing",
                color: rose,
                onToggle: toggleSound
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
        .onDisappear {
            RingAudioService.shared.sustainedVoiceStop()
            moveTimer?.cancel()
            unifyTask?.cancel()
        }
    }

    // MARK: - Plume

    @ViewBuilder
    private func plume(at i: Int, cx: CGFloat, cy: CGFloat) -> some View {
        let angle = Double(i) * 45
        let isActive = (active == i)
        let gather = unified || isActive || !moving

        // Per-state visuals
        let opacity: Double = {
            if unified { return 0.92 }
            if isActive { return 1.0 }
            if active != nil { return 0.22 }
            return gather ? 0.66 : 0.18
        }()
        let scale: Double = isActive ? 1.06 : (gather ? 1.0 : 1.18)
        let blurRadius: Double = gather ? 5.5 : 10.0
        let drift: Double = gather ? 0 : 24

        // Brightness ladder — *screened* warm overlay rather than additive
        // `.brightness()`. The original JSX used CSS `filter: brightness(1.5)`
        // (multiplicative). SwiftUI's `.brightness()` is additive and only
        // lightens by a trace, so plumes never glowed. A screen-blended warm
        // overlay recovers the original lift.
        //   active brightest → unified → gathered → scattered dimmest
        let glowAmount: Double = {
            if isActive { return 0.65 }
            if unified  { return 0.45 }
            if gather   { return 0.18 }
            return 0.0
        }()

        ZStack {
            // Base plume — warm gradient body
            AnangaPlume(outerR: 116, innerR: 30, halfW: 52)
                .rotation(.degrees(angle))
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: warm.opacity(0.90), location: 0),
                            .init(color: rose.opacity(0.50), location: 0.55),
                            .init(color: Color.accentRed.opacity(0), location: 1.0)
                        ]),
                        center: UnitPoint(x: 0.5, y: 0.38),
                        // Reach the plume's tip (outerR) instead of stopping
                        // at 92 — at 92 the form's edge was unpainted muddy.
                        startRadius: 0, endRadius: 116
                    )
                )

            // Glow overlay — keyed to state; nil when scattered.
            if glowAmount > 0 {
                AnangaPlume(outerR: 116, innerR: 30, halfW: 52)
                    .rotation(.degrees(angle))
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: warm.opacity(glowAmount), location: 0),
                                .init(color: warm.opacity(glowAmount * 0.4), location: 0.5),
                                .init(color: .clear, location: 1.0)
                            ]),
                            center: UnitPoint(x: 0.5, y: 0.38),
                            startRadius: 0, endRadius: 116
                        )
                    )
                    .blendMode(.screen)
            }
        }
        .frame(width: 232, height: 232)
        .offset(y: -drift)
        .scaleEffect(scale)
        .opacity(opacity)
        .blur(radius: blurRadius)
        .animation(.easeInOut(duration: 1.1), value: gather)
        .animation(.easeInOut(duration: 1.1), value: unified)
        .animation(.easeInOut(duration: 1.1), value: active)
        .position(x: cx, y: cy)
        .contentShape(
            AnangaPlume(outerR: 116, innerR: 30, halfW: 52)
                .rotation(.degrees(angle))
        )
        .onTapGesture { touch(i) }
    }

    // MARK: - Seed

    @ViewBuilder
    private func seedView(cx: CGFloat, cy: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(unified
                    ? RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: warm.opacity(0.40), location: 0),
                            .init(color: .clear, location: 0.70)
                        ]),
                        center: .center, startRadius: 0, endRadius: 30)
                    : RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .clear, location: 1)
                        ]),
                        center: .center, startRadius: 0, endRadius: 30)
                )
                .frame(width: 54, height: 54)

            Text("hsauṁ")
                .font(.custom(AppFont.cormorantItalic, size: 22))
                .tracking(1.32)
                .foregroundStyle(unified
                    ? Color.cream
                    : (moving ? warm.opacity(0.45) : warm.opacity(0.92)))
                .shadow(color: rose.opacity(0.6), radius: 16)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .frame(width: 80, height: 54)
        .contentShape(Rectangle())
        .onTapGesture { unify() }
        .position(x: cx, y: cy)
        .animation(.easeInOut(duration: 0.8), value: unified)
        .animation(.easeInOut(duration: 0.8), value: moving)
    }

    // MARK: - Caption block

    @ViewBuilder
    private var captionBlock: some View {
        if let i = active, i < ring3Shaktis.count {
            let s = ring3Shaktis[i]
            VStack(spacing: 6) {
                Text(displayName(for: s))
                    .font(.custom(AppFont.cormorant, size: 36))
                    .tracking(1.8)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                if !s.quality.isEmpty {
                    Text(s.quality)
                        .font(.custom(AppFont.cormorantItalic, size: 17))
                        .tracking(0.3)
                        .lineSpacing(5)
                        .foregroundStyle(Color.cream.opacity(0.62))
                        .multilineTextAlignment(.center)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else if unified {
            Text("Eight forms, one longing. The desire that arrives without a body.")
                .font(.custom(AppFont.cormorantItalic, size: 22))
                .tracking(0.3)
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.78))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        } else if moving {
            Text("The more you reach for her, the more she thins.")
                .font(.custom(AppFont.cormorantItalic, size: 20))
                .tracking(0.3)
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        } else {
            Text("Be still — and the bodiless longing gathers.")
                .font(.custom(AppFont.cormorantItalic, size: 20))
                .tracking(0.3)
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.65))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        }
    }

    // MARK: - Helpers

    private func displayName(for shakti: Shakti) -> String {
        if !shakti.name.isEmpty { return shakti.name }
        return shakti.shortName
    }

    // MARK: - Interactions

    private func onMove() {
        moving = true
        moveTimer?.cancel()
        moveTimer = Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.8))
            if Task.isCancelled { return }
            moving = false
        }
    }

    private func ensureSoundStarted() {
        guard !soundOn else { return }
        RingAudioService.shared.sustainedVoiceStart(freq: 116.5, vol: 0.045, vibrato: 6)
        soundOn = true
    }

    private func touch(_ i: Int) {
        Haptics.light()
        ensureSoundStarted()
        unified = false
        active = i
        RingAudioService.shared.sustainedVoiceGain(0.06)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.4))
            RingAudioService.shared.sustainedVoiceGain(0.03)
        }
    }

    private func unify() {
        Haptics.medium()
        ensureSoundStarted()
        active = nil
        unified = true
        RingAudioService.shared.sustainedVoiceGain(0.075)
        unifyTask?.cancel()
        unifyTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.6))
            if Task.isCancelled { return }
            unified = false
            RingAudioService.shared.sustainedVoiceGain(0.03)
        }
    }

    private func release() {
        active = nil
        unified = false
    }

    private func toggleSound() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.sustainedVoiceStop()
            soundOn = false
        } else {
            RingAudioService.shared.sustainedVoiceStart(freq: 116.5, vol: 0.045, vibrato: 6)
            soundOn = true
        }
    }

    private var swipeDown: some Gesture {
        DragGesture()
            .onChanged { v in
                if v.translation.height > 0 {
                    dragOffset = v.translation.height * 0.6
                }
            }
            .onEnded { v in
                if v.translation.height > 80 {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.4)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - Anaṅga plume — radial gradient petal that fills wider than Ring 2

private struct AnangaPlume: Shape {
    let outerR: CGFloat
    let innerR: CGFloat
    let halfW: CGFloat

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let c1y = -innerR * 1.85
        let c2y = -outerR * 0.85
        let c2x = halfW * 0.95
        var p = Path()
        p.move(to: CGPoint(x: cx, y: cy - innerR))
        p.addCurve(
            to: CGPoint(x: cx, y: cy - outerR),
            control1: CGPoint(x: cx + halfW, y: cy + c1y),
            control2: CGPoint(x: cx + c2x, y: cy + c2y)
        )
        p.addCurve(
            to: CGPoint(x: cx, y: cy - innerR),
            control1: CGPoint(x: cx - c2x, y: cy + c2y),
            control2: CGPoint(x: cx - halfW, y: cy + c1y)
        )
        p.closeSubpath()
        return p
    }
}
