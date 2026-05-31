import SwiftUI
import SwiftData

/// Ring 2 World — the Inhabited Lotus.
/// The 16-petal lotus fills the screen, each petal known, breathing per status.
/// Long-press on today's petal enters invocation; release returns.
struct RingTwoWorldView: View {
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var detailFor: Shakti?
    @State private var dragOffset: CGFloat = 0

    @State private var invocationActive = false
    @State private var invocNameVisible = false
    @State private var invocBijaVisible = false
    @State private var invocQualityVisible = false
    @State private var invocHintVisible = false
    @State private var settleTask: Task<Void, Never>? = nil

    // Lower-left sound toggle — home breath drone.
    @State private var soundOn: Bool = false

    @State private var phaseToday: CGFloat = 0
    @State private var phaseEmbodied: CGFloat = 0
    @State private var phaseActive: CGFloat = 0
    @State private var phaseExploring: CGFloat = 0
    @State private var phaseMapped: CGFloat = 0

    private var todayIndex: Int { LunarPhaseService.todayPetalIndex() }

    private var ring2Shaktis: [Shakti] {
        shaktis.filter { ($0.ringNumber ?? 2) == 2 }
            .sorted { $0.position < $1.position }
    }

    private var todayShakti: Shakti? {
        ring2Shaktis.first { $0.position == todayIndex + 1 }
    }

    var body: some View {
        // NavigationStack is wrapped externally by MandalaScreenView's
        // fullScreenCover so the back-button hierarchy stays local to this
        // world (back from ShaktiDetail returns here, not to the bare Mandala).
        content
            .navigationDestination(item: $detailFor) { shakti in
                ShaktiDetailView(shakti: shakti)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .offset(y: dragOffset)
            .gesture(swipeDown)
            .overlay(alignment: .bottomLeading) {
                RingSoundDot(
                    isOn: $soundOn,
                    label: "home",
                    color: Color.gold,
                    onToggle: toggleHomeBreath
                )
                .padding(.leading, 22)
                .padding(.bottom, 50)
            }
            .onAppear(perform: startBreathing)
            .onDisappear {
                RingAudioService.shared.homeBreathStop()
                settleTask?.cancel()
            }
    }

    private var content: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy: CGFloat = min(430, geo.size.height * 0.51)

            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "#0A0608"), location: 0),
                        .init(color: Color(hex: "#060104"), location: 0.6),
                        .init(color: Color(hex: "#050103"), location: 1)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.gold.opacity(0.10), location: 0),
                        .init(color: .clear, location: 0.7)
                    ]),
                    center: .center, startRadius: 0, endRadius: 300
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                FaintRingMemory()
                    .allowsHitTesting(false)

                DustMotesView(count: 10)
                    .allowsHitTesting(false)

                returnArc(width: geo.size.width)
                    .allowsHitTesting(false)

                Text("Sarvāśā-Paripūraka · the Sixteen")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(2.3)
                    .foregroundStyle(Color.gold.opacity(0.85))
                    .position(x: cx, y: 100)
                    .allowsHitTesting(false)

                InnerRingGhostLayer(dim: invocationActive)
                    .position(x: cx, y: cy)
                    .allowsHitTesting(false)

                lotusLayer(cx: cx, cy: cy)

                centerBindu(invoc: invocationActive)
                    .position(x: cx, y: cy)
                    .allowsHitTesting(false)

                if invocationActive {
                    invocationOverlay
                }
            }
        }
    }

    // MARK: - Lotus

    @ViewBuilder
    private func lotusLayer(cx: CGFloat, cy: CGFloat) -> some View {
        ForEach(0..<16, id: \.self) { i in
            if let shakti = ring2Shaktis.first(where: { $0.position == i + 1 }) {
                petalView(at: i, shakti: shakti, cx: cx, cy: cy)
            }
        }
        ForEach(0..<16, id: \.self) { i in
            if let shakti = ring2Shaktis.first(where: { $0.position == i + 1 }) {
                petalLabel(at: i, shakti: shakti, cx: cx, cy: cy)
            }
        }
    }

    @ViewBuilder
    private func petalView(at i: Int, shakti: Shakti, cx: CGFloat, cy: CGFloat) -> some View {
        let angle = Double(i) * 22.5
        let isToday = i == todayIndex
        let isInvocOther = invocationActive && !isToday
        let cluster = shakti.cluster.color
        let baseOp = shakti.status.opacity
        let finalOp = isInvocOther ? baseOp * 0.18 : baseOp
        let brightness = brightnessFor(shakti.status, isToday: isToday)

        ZStack {
            if isToday {
                RingTwoLotusPetal()
                    .rotation(.degrees(angle))
                    .fill(cluster.opacity(0.42))
                    .blur(radius: 11)
            }
            if shakti.status == .embodied && !isInvocOther {
                RingTwoLotusPetal()
                    .rotation(.degrees(angle))
                    .fill(cluster.opacity(0.25))
                    .blur(radius: 6)
            }
            RingTwoLotusPetal()
                .rotation(.degrees(angle))
                .fill(cluster)
                .opacity(finalOp)
                .brightness(brightness)
        }
        .frame(width: 360, height: 360)
        .contentShape(RingTwoLotusPetal().rotation(.degrees(angle)))
        .position(x: cx, y: cy)
        .modifier(PetalGestures(
            invocationActive: invocationActive,
            onTap: {
                Haptics.light()
                detailFor = shakti
            },
            onLongPress: { startInvocation() },
            onRelease: { endInvocation() }
        ))
        .animation(.easeOut(duration: invocationActive ? 0.6 : 0.4),
                   value: invocationActive)
    }

    private func petalLabel(at i: Int, shakti: Shakti, cx: CGFloat, cy: CGFloat) -> some View {
        let angle = Double(i) * 22.5
        let theta = (angle - 90) * .pi / 180
        let labelR: CGFloat = 138
        let lx = cx + labelR * cos(theta)
        let ly = cy + labelR * sin(theta)
        let isToday = i == todayIndex
        let isInvocOther = invocationActive && !isToday
        let labelOp: Double = {
            if isInvocOther { return 0.10 }
            return isToday ? 1.0 : 0.55
        }()
        return Text(shakti.shortName)
            .font(.custom(AppFont.cormorantItalic, size: 10))
            .tracking(0.4)
            .foregroundStyle(Color.cream.opacity(labelOp))
            .opacity(isInvocOther ? 0.5 : 1)
            .position(x: lx, y: ly)
            .allowsHitTesting(false)
            .animation(.easeOut(duration: 0.5), value: invocationActive)
    }

    // MARK: - Bindu (small, distant)

    private func centerBindu(invoc: Bool) -> some View {
        ZStack {
            Circle()
                .fill(Color.accentRed)
                .opacity(invoc ? 0.4 : 0.85)
                .frame(width: 20, height: 20)
            Circle()
                .fill(Color.cream)
                .opacity(invoc ? 0.5 : 0.95)
                .frame(width: 8, height: 8)
                .shadow(color: Color.cream.opacity(0.7), radius: 4)
        }
        .animation(.easeOut(duration: 0.6), value: invoc)
    }

    // MARK: - Invocation overlay

    @ViewBuilder
    private var invocationOverlay: some View {
        if let s = todayShakti {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Text(s.name)
                        .font(.custom(AppFont.cormorant, size: 34))
                        .tracking(2.7)
                        .foregroundStyle(Color.cream)
                        .multilineTextAlignment(.center)
                        .opacity(invocNameVisible ? 1 : 0)
                        .offset(y: invocNameVisible ? 0 : 8)
                        .padding(.bottom, 8)

                    Text(s.bija)
                        .font(.custom(AppFont.cormorantItalic, size: 26))
                        .tracking(3.1)
                        .foregroundStyle(Color.gold)
                        .opacity(invocBijaVisible ? 1 : 0)
                        .offset(y: invocBijaVisible ? 0 : 8)
                        .padding(.bottom, 18)

                    Text(s.quality)
                        .font(.custom(AppFont.cormorantItalic, size: 16))
                        .tracking(0.6)
                        .foregroundStyle(Color.cream.opacity(0.62))
                        .multilineTextAlignment(.center)
                        .opacity(invocQualityVisible ? 1 : 0)
                        .offset(y: invocQualityVisible ? 0 : 8)
                        .padding(.horizontal, 36)
                        .padding(.bottom, 36)

                    Text("RELEASE · SHE REMAINS")
                        .font(.system(size: 9))
                        .tracking(2.8)
                        .foregroundStyle(Color.cream.opacity(0.40))
                        .opacity(invocHintVisible ? 1 : 0)
                        .offset(y: invocHintVisible ? 0 : 8)
                }
                .padding(.bottom, 140)
            }
            .allowsHitTesting(false)
        }
    }

    // MARK: - Helpers

    private func brightnessFor(_ status: ShaktiStatus, isToday: Bool) -> Double {
        let phase: CGFloat
        let amplitude: Double
        if isToday {
            phase = phaseToday
            amplitude = 0.20
        } else {
            switch status {
            case .embodied:  phase = phaseEmbodied;  amplitude = 0.09
            case .active:    phase = phaseActive;    amplitude = 0.05
            case .exploring: phase = phaseExploring; amplitude = 0.045
            case .mapped:    phase = phaseMapped;    amplitude = 0.035
            }
        }
        return sin(Double(phase) * 2 * .pi) * amplitude
    }

    private func startBreathing() {
        guard !reduceMotion else { return }
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: false)) { phaseToday = 1 }
        withAnimation(.easeInOut(duration: 4.5).repeatForever(autoreverses: false)) { phaseEmbodied = 1 }
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: false)) { phaseActive = 1 }
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: false)) { phaseExploring = 1 }
        withAnimation(.easeInOut(duration: 11.0).repeatForever(autoreverses: false)) { phaseMapped = 1 }
    }

    private func startInvocation() {
        guard !invocationActive else { return }
        Haptics.medium()
        settleTask?.cancel()
        ensureSoundStarted()
        RingAudioService.shared.homeBreathGain(0.075)

        invocationActive = true
        invocNameVisible = false
        invocBijaVisible = false
        invocQualityVisible = false
        invocHintVisible = false
        let curve = Animation.easeOut(duration: 1.4)
        withAnimation(curve.delay(0.3))  { invocNameVisible = true }
        withAnimation(curve.delay(0.9))  { invocBijaVisible = true }
        withAnimation(curve.delay(1.5))  { invocQualityVisible = true }
        withAnimation(curve.delay(2.4))  { invocHintVisible = true }
    }

    /// On release: settle the breath, then clear the overlay after 2.6s so
    /// the practitioner can sit with her presence before she dissolves.
    private func endInvocation() {
        RingAudioService.shared.homeBreathGain(0.045)
        settleTask?.cancel()
        settleTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.6))
            if Task.isCancelled { return }
            withAnimation(.easeOut(duration: 0.6)) {
                invocationActive = false
                invocNameVisible = false
                invocBijaVisible = false
                invocQualityVisible = false
                invocHintVisible = false
            }
        }
    }

    /// Lazy-start the home-breath drone on first interaction.
    private func ensureSoundStarted() {
        guard !soundOn else { return }
        RingAudioService.shared.homeBreathStart()
        soundOn = true
    }

    private func toggleHomeBreath() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.homeBreathStop()
            soundOn = false
        } else {
            RingAudioService.shared.homeBreathStart()
            soundOn = true
        }
    }

    private func returnArc(width: CGFloat) -> some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: 11))
            p.addQuadCurve(to: CGPoint(x: 80, y: 11),
                           control: CGPoint(x: 40, y: 3))
        }
        .stroke(Color.gold.opacity(0.32),
                style: StrokeStyle(lineWidth: 0.7, lineCap: .round))
        .frame(width: 80, height: 14)
        .position(x: width / 2, y: 60)
    }

    private var swipeDown: some Gesture {
        DragGesture()
            .onChanged { v in
                if invocationActive { return }
                if v.translation.height > 0 {
                    dragOffset = v.translation.height * 0.6
                }
            }
            .onEnded { v in
                if invocationActive { return }
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

// MARK: - Petal gesture modifier

private struct PetalGestures: ViewModifier {
    let invocationActive: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onRelease: () -> Void

    func body(content: Content) -> some View {
        // Every petal supports both modes per the brief — short tap pushes
        // ShaktiDetail; press-and-hold (>0.28s) raises the invocation overlay.
        // The brief originally pinned long-press to today's petal only, but
        // the Session-D upgrade extends invocation to any petal Ash chooses.
        content
            .onLongPressGesture(
                minimumDuration: 0.28,
                perform: { onLongPress() },
                onPressingChanged: { pressing in
                    if !pressing && invocationActive {
                        onRelease()
                    }
                }
            )
            .onTapGesture { onTap() }
    }
}

// MARK: - Ring 2 World petal shape (larger than home — oR=172, iR=96, hw=32)

private struct RingTwoLotusPetal: Shape {
    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let oR: CGFloat = 172, iR: CGFloat = 96, hw: CGFloat = 32
        let c1y = -iR * 1.85
        let c2y = -oR * 0.85
        let c2x = hw * 0.95
        var p = Path()
        p.move(to: CGPoint(x: cx, y: cy - iR))
        p.addCurve(
            to: CGPoint(x: cx, y: cy - oR),
            control1: CGPoint(x: cx + hw, y: cy + c1y),
            control2: CGPoint(x: cx + c2x, y: cy + c2y)
        )
        p.addCurve(
            to: CGPoint(x: cx, y: cy - iR),
            control1: CGPoint(x: cx - c2x, y: cy + c2y),
            control2: CGPoint(x: cx - hw, y: cy + c1y)
        )
        p.closeSubpath()
        return p
    }
}

// MARK: - Inner-ring ghost geometry (4 nested triangle pairs at center)

private struct InnerRingGhostLayer: View {
    let dim: Bool
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            for r in [80.0, 65.0, 50.0, 36.0] {
                let R = CGFloat(r)
                let h = R * sqrt(3) / 2
                let half = R / 2
                var down = Path()
                down.move(to: CGPoint(x: cx, y: cy - R))
                down.addLine(to: CGPoint(x: cx + h, y: cy + half))
                down.addLine(to: CGPoint(x: cx - h, y: cy + half))
                down.closeSubpath()
                var up = Path()
                up.move(to: CGPoint(x: cx, y: cy + R))
                up.addLine(to: CGPoint(x: cx + h, y: cy - half))
                up.addLine(to: CGPoint(x: cx - h, y: cy - half))
                up.closeSubpath()
                ctx.stroke(down, with: .color(Color.gold), lineWidth: 0.4)
                ctx.stroke(up,   with: .color(Color.gold), lineWidth: 0.4)
            }
        }
        .frame(width: 200, height: 200)
        .opacity(dim ? 0.04 : 0.08)
        .animation(.easeOut(duration: 0.6), value: dim)
    }
}

// MARK: - Faint ring memory (Bhūpura ghost at screen edges)

private struct FaintRingMemory: View {
    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                let cx = size.width / 2
                let cy = size.height / 2
                let outer = CGRect(x: cx - 180, y: cy - 180, width: 360, height: 360)
                ctx.stroke(Path(outer),
                           with: .color(Color.gold.opacity(0.06)),
                           lineWidth: 0.4)
                let inner = CGRect(x: cx - 168, y: cy - 168, width: 336, height: 336)
                ctx.stroke(Path(inner),
                           with: .color(Color.gold.opacity(0.05)),
                           lineWidth: 0.4)
                _ = geo
            }
        }
    }
}
