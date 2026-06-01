import SwiftUI

/// Ring 7 World — the Vāk Sound Chamber.
/// Eight speech-goddesses arranged as a sonic field. Tap a Vāk to hear her bīja.
/// Tap center for the full chord. Frequencies hardcoded from the design.
struct RingSevenWorldView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var activeIndex: Int? = nil
    @State private var chordActive = false
    @State private var dragOffset: CGFloat = 0

    /// The set of Vāgdevatā indices that have been sounded at least once.
    /// Healing arrives when this reaches seven or more.
    @State private var sounded: Set<Int> = []
    private var healed: Bool { sounded.count >= 7 }

    // Sound-ring phases driven on each strike.
    @State private var ringPhase0: CGFloat = 0
    @State private var ringPhase1: CGFloat = 0
    @State private var ringPhase2: CGFloat = 0
    @State private var ringPhase3: CGFloat = 0
    @State private var ringsCenter: CGPoint = .zero
    @State private var ringsColor: Color = .clear

    private let orbitR: CGFloat = 158

    /// Vāk-devatā frequencies, from `Claude Designs/ring-worlds.jsx` VAK_FREQS.
    private struct Vak {
        let name: String
        let bija: String
        let freq: Double
    }
    /// The full twelve Vāgdevatās per Session D — extended from Phase 3's
    /// eight. Healing arrives once seven or more voices have sounded.
    private let vaks: [Vak] = [
        .init(name: "Vāśinī",     bija: "aṁ",  freq: 220.00),
        .init(name: "Kāmeśvarī",  bija: "āṁ",  freq: 246.94),
        .init(name: "Modinī",     bija: "iṁ",  freq: 261.63),
        .init(name: "Vimalā",     bija: "īṁ",  freq: 293.66),
        .init(name: "Aruṇā",      bija: "uṁ",  freq: 329.63),
        .init(name: "Jayinī",     bija: "ūṁ",  freq: 349.23),
        .init(name: "Sarveśvarī", bija: "eṁ",  freq: 392.00),
        .init(name: "Kaulinī",    bija: "aiṁ", freq: 440.00),
        .init(name: "Vāṅmayī",    bija: "oṁ",  freq: 493.88),
        .init(name: "Onmādinī",   bija: "auṁ", freq: 523.25),
        .init(name: "Mantreśī",   bija: "aṃ",  freq: 587.33),
        .init(name: "Śaktimayī",  bija: "aḥ",  freq: 659.25),
    ]

    private let amber = Color(hex: "#E8C97A")
    private let amberDim = Color(red: 232/255, green: 201/255, blue: 122/255).opacity(0.85)

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .offset(y: dragOffset)
            .gesture(swipeDown)
    }

    private var content: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy: CGFloat = min(410, geo.size.height * 0.485)

            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "#0E0703"), location: 0),
                        .init(color: Color(hex: "#0A0502"), location: 0.5),
                        .init(color: Color(hex: "#060301"), location: 1)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 212/255, green: 160/255, blue: 23/255).opacity(0.16), location: 0),
                        .init(color: Color(red: 139/255, green: 90/255, blue: 40/255).opacity(0.06), location: 0.45),
                        .init(color: .clear, location: 0.75)
                    ]),
                    center: .center, startRadius: 0, endRadius: 300
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                DustMotesView(count: 8)
                    .allowsHitTesting(false)

                returnArc(width: geo.size.width)
                    .allowsHitTesting(false)

                Text("Sarvarogahara · the Vāk Chamber")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(2.3)
                    .foregroundStyle(Color(red: 212/255, green: 160/255, blue: 80/255).opacity(0.6))
                    .position(x: cx, y: 100)
                    .allowsHitTesting(false)

                backgroundTriangles(cx: cx, cy: cy)
                    .allowsHitTesting(false)

                // Sound rings (drawn behind the Vāk circles)
                soundRings()

                // 12 Vāk circles
                ForEach(0..<vaks.count, id: \.self) { i in
                    vakNode(at: i, cx: cx, cy: cy)
                }

                // Chord center
                chordCircle(at: CGPoint(x: cx, y: cy))
                    .position(x: cx, y: cy)

                captionLayer(width: geo.size.width)
            }
        }
    }

    // MARK: - Vāk node

    private func vakNode(at i: Int, cx: CGFloat, cy: CGFloat) -> some View {
        let position = vakPosition(at: i, cx: cx, cy: cy)
        let isActive = (activeIndex == i)

        return VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: isActive ? [
                                .init(color: amber.opacity(0.32), location: 0),
                                .init(color: amber.opacity(0.05), location: 1)
                            ] : [
                                .init(color: amber.opacity(0.06), location: 0),
                                .init(color: .clear, location: 0.8)
                            ]),
                            center: .center, startRadius: 0, endRadius: 28
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(amber.opacity(isActive ? 0.95 : 0.45), lineWidth: 1)
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: isActive ? amber.opacity(0.55) : .clear, radius: 18)

                Text(vaks[i].bija)
                    .font(.custom(AppFont.cormorantItalic, size: 22))
                    .tracking(1.3)
                    .foregroundStyle(isActive ? Color.cream : amberDim)
            }
            Text(vaks[i].name)
                .font(.custom(AppFont.cormorantItalic, size: 12))
                .tracking(0.5)
                .foregroundStyle(isActive ? amber : Color.cream.opacity(0.55))
        }
        .position(x: position.x, y: position.y + 14)  // shift down so label centers below circle
        .onTapGesture {
            Haptics.light()
            strikeOne(i, at: position)
        }
        .animation(.easeInOut(duration: 0.5), value: isActive)
    }

    private func vakPosition(at i: Int, cx: CGFloat, cy: CGFloat) -> CGPoint {
        // 12 voices on the ring — 360°/12 = 30° spacing. (Pre-Session D this
        // was 45° for 8 voices; when the Vāks extended to twelve, voices 9–12
        // landed exactly on top of voices 1–4 because the spacing wasn't
        // updated. Widening orbitR to 158 keeps tap-targets comfortable.)
        let theta = (Double(i) * 30 - 90) * .pi / 180
        return CGPoint(x: cx + orbitR * cos(theta), y: cy + orbitR * sin(theta))
    }

    // MARK: - Chord center

    private func chordCircle(at center: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: chordActive ? [
                            .init(color: Color.cream.opacity(0.85), location: 0),
                            .init(color: amber.opacity(0.40), location: 0.5),
                            .init(color: .clear, location: 1)
                        ] : [
                            .init(color: amber.opacity(0.18), location: 0),
                            .init(color: amber.opacity(0.04), location: 0.6),
                            .init(color: .clear, location: 1)
                        ]),
                        center: .center, startRadius: 0, endRadius: 30
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color.cream.opacity(chordActive ? 0.6 : 0.18), lineWidth: 0.5)
                )
                .frame(width: 60, height: 60)
                .shadow(color: chordActive ? amber.opacity(0.45) : amber.opacity(0.12),
                        radius: chordActive ? 26 : 8)
            Circle()
                .fill(Color.cream)
                .opacity(chordActive ? 1.0 : 0.7)
                .frame(width: 6, height: 6)
        }
        .contentShape(Circle())
        .onTapGesture {
            Haptics.light()
            strikeChord(at: center)
        }
        .animation(.easeInOut(duration: 0.6), value: chordActive)
    }

    // MARK: - Background geometry

    private func backgroundTriangles(cx: CGFloat, cy: CGFloat) -> some View {
        Canvas { ctx, size in
            for r in [80.0, 65.0, 52.0, 40.0] {
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
                ctx.stroke(down, with: .color(amber.opacity(0.12)), lineWidth: 0.5)
                ctx.stroke(up,   with: .color(amber.opacity(0.12)), lineWidth: 0.5)
                _ = size
            }
        }
    }

    // MARK: - Sound rings (expanding circles on strike)

    @ViewBuilder
    private func soundRings() -> some View {
        if activeIndex != nil || chordActive {
            soundRing(phase: ringPhase0)
            soundRing(phase: ringPhase1)
            soundRing(phase: ringPhase2)
            if chordActive {
                soundRing(phase: ringPhase3)
            }
        }
    }

    private func soundRing(phase: CGFloat) -> some View {
        let baseSize: CGFloat = 40
        let maxSize: CGFloat = 240
        let size = baseSize + (maxSize - baseSize) * phase
        let opacity = 0.7 * Double(1 - phase)
        return Circle()
            .stroke(ringsColor.opacity(opacity), lineWidth: 0.6)
            .frame(width: size, height: size)
            .position(ringsCenter)
            .allowsHitTesting(false)
    }

    // MARK: - Caption

    private func captionLayer(width: CGFloat) -> some View {
        VStack(spacing: 8) {
            Text(captionText)
                .font(.custom(AppFont.cormorantItalic,
                              size: healed && activeIndex == nil && !chordActive ? 17 : 15))
                .tracking(0.6)
                .foregroundStyle(captionColor)
                .multilineTextAlignment(.center)
                .frame(minHeight: 22)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 38)
            Text(subCaption)
                .font(.system(size: 9))
                .tracking(2.8)
                .foregroundStyle(Color.cream.opacity(0.40))
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
        .position(x: width / 2, y: 800)
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.6), value: activeIndex)
        .animation(.easeInOut(duration: 0.6), value: chordActive)
        .animation(.easeInOut(duration: 0.6), value: healed)
    }

    private var captionText: String {
        if chordActive { return "the full chord — all twelve at once" }
        if let i = activeIndex { return vaks[i].name }
        if healed { return "The word that healed what the mind could not reach." }
        return "tap a syllable · tap center for the chord"
    }

    private var subCaption: String {
        if healed && activeIndex == nil && !chordActive {
            return "SHE WHO REMOVES ALL DISEASE"
        }
        return "\(sounded.count) OF 12 VOICES SOUNDED"
    }

    private var captionColor: Color {
        if activeIndex != nil || chordActive { return amber }
        if healed { return Color.cream.opacity(0.78) }
        return Color.cream.opacity(0.45)
    }

    // MARK: - Actions

    private func strikeOne(_ i: Int, at center: CGPoint) {
        activeIndex = i
        chordActive = false
        ringsCenter = center
        ringsColor = amber
        sounded.insert(i)
        BijaSoundService.shared.playVakBija(frequency: vaks[i].freq,
                                            duration: 2.6, volume: 0.11)
        startRings(count: 3, stagger: 0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            if activeIndex == i { activeIndex = nil }
        }
    }

    private func strikeChord(at center: CGPoint) {
        activeIndex = nil
        chordActive = true
        ringsCenter = center
        ringsColor = Color.cream
        sounded = Set(0..<vaks.count)
        let freqs = vaks.map(\.freq)
        BijaSoundService.shared.playVakChord(frequencies: freqs,
                                              duration: 3.0, volume: 0.06, stagger: 0.06)
        startRings(count: 4, stagger: 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if chordActive { chordActive = false }
        }
    }

    private func startRings(count: Int, stagger: TimeInterval) {
        ringPhase0 = 0; ringPhase1 = 0; ringPhase2 = 0; ringPhase3 = 0
        let curve = Animation.easeOut(duration: 1.5)
        if count >= 1 { withAnimation(curve)                              { ringPhase0 = 1 } }
        if count >= 2 { withAnimation(curve.delay(stagger))                { ringPhase1 = 1 } }
        if count >= 3 { withAnimation(curve.delay(stagger * 2))            { ringPhase2 = 1 } }
        if count >= 4 { withAnimation(curve.delay(stagger * 3))            { ringPhase3 = 1 } }
    }

    // MARK: - Return arc + swipe

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
