import SwiftUI
import SwiftData

/// Ring 9 — Praveśa, the Endless Indwelling.
///
/// Press and hold to fall inward. Self-similar Śrī Yantras emerge from the
/// center and scroll past, each carrying its own Bindu. Hold past the falling
/// (≈ 6.5s) and the descent settles into stillness; the point swells; the
/// recognition arrives — *"You did not arrive. You were the arriving."*
struct RingNineDescentView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var avaranas: [Avarana]

    @State private var holding: Bool = false
    @State private var heldTime: Double = 0
    @State private var clock: Double = 0
    @State private var speed: Double = 0.85
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var lastTick: Date = Date()

    private static let layerCount = 7
    private static let recognitionThreshold: Double = 6.5

    private var recognition: Double {
        max(0, min(1, (heldTime - Self.recognitionThreshold) / 2.2))
    }

    private var ring9Avarana: Avarana? {
        avaranas.first(where: { $0.ringNumber == 9 })
    }

    var body: some View {
        ZStack {
            // Ground
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#0B0410"), location: 0),
                    .init(color: Color(hex: "#04020A"), location: 0.50),
                    .init(color: Color(hex: "#010005"), location: 1)
                ]),
                center: UnitPoint(x: 0.5, y: 0.49),
                startRadius: 0, endRadius: 460
            )
            .ignoresSafeArea()

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy: CGFloat = min(408, geo.size.height * 0.48)

                ZStack {
                    // Ring identity
                    VStack(spacing: 5) {
                        Text("Sarvānandamaya · the Bindu")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(2.8)
                            .foregroundStyle(Color.gold.opacity(0.55))
                            .multilineTextAlignment(.center)
                        Text("THE RING THAT IS NOT A RING")
                            .font(.system(size: 10))
                            .tracking(3.0)
                            .foregroundStyle(Color.cream.opacity(0.45))
                    }
                    .position(x: cx, y: 96)
                    .allowsHitTesting(false)

                    // 7 nested yantras driven by TimelineView (display refresh)
                    yantraStack
                        .frame(width: 1, height: 1)        // anchor at point
                        .position(x: cx, y: cy)

                    // Vignette darkens the edges
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .clear, location: 0.42),
                            .init(color: Color(red: 1/255, green: 0/255, blue: 5/255).opacity(0.55), location: 1.0)
                        ]),
                        center: UnitPoint(x: 0.5, y: 0.49),
                        startRadius: 0, endRadius: 460
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                    // The Bindu — swells at recognition
                    binduCenter
                        .position(x: cx, y: cy)
                        .allowsHitTesting(false)

                    // Captions stack — rest / descending / recognition
                    captionStack
                        .frame(maxWidth: geo.size.width - 64)
                        .position(x: cx, y: geo.size.height - 220)
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Top 80pt is the dismiss zone — hold does not engage from
                    // there so the arc-tap can claim the touch first.
                    guard value.startLocation.y > 80 else { return }
                    if !holding {
                        holding = true
                        ensureShepardStarted()
                    }
                }
                .onEnded { value in
                    guard value.startLocation.y > 80 else { return }
                    holding = false
                }
        )
        .offset(y: dragOffset)
        // `.simultaneousGesture` so verticalSwipe isn't blocked by the hold
        // DragGesture (which has minimumDistance:0 and claims touches first).
        .simultaneousGesture(verticalSwipe)
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
                label: "tone",
                color: Color.gold,
                onToggle: toggleShepard
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
        .onDisappear {
            RingAudioService.shared.shepardStop()
        }
    }

    // MARK: - Yantra stack

    private var yantraStack: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { context in
            ZStack {
                ForEach(0..<Self.layerCount, id: \.self) { i in
                    yantraLayer(index: i, date: context.date)
                }
            }
            .onChange(of: context.date) { _, newDate in
                tick(to: newDate)
            }
        }
    }

    @ViewBuilder
    private func yantraLayer(index i: Int, date: Date) -> some View {
        let frac = ((clock + Double(i) / Double(Self.layerCount))
                    .truncatingRemainder(dividingBy: 1.0) + 1.0)
                    .truncatingRemainder(dividingBy: 1.0)
        let scale = 0.03 * pow(2.0, frac * 6.4)
        let opacity: Double = {
            if frac < 0.1 { return frac / 0.1 }
            if frac > 0.72 { return max(0, (1 - frac) / 0.28) }
            return 1.0
        }() * 0.72
        let rotation = Double((i * 47) % 360) + clock * 6

        MiniFullYantra()
            .stroke(Color.gold, lineWidth: 1)
            .frame(width: 300, height: 300)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
    }

    // MARK: - Bindu

    private var binduCenter: some View {
        let r = recognition
        let scale = 1 + 1.7 * r
        let glow = 22 + 60 * r
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.accentRed, location: 0),
                            .init(color: Color.accentRed.opacity(0.6), location: 0.55),
                            .init(color: .clear, location: 1.0)
                        ]),
                        center: .center, startRadius: 0, endRadius: 18
                    )
                )
                .frame(width: 32, height: 32)
                .shadow(color: Color.accentRed.opacity(0.55 + 0.30 * r), radius: glow)

            Circle()
                .fill(Color.cream)
                .frame(width: 6, height: 6)
                .shadow(color: Color.cream, radius: 10)
        }
        .scaleEffect(scale)
        .animation(.easeOut(duration: 0.5), value: scale)
    }

    // MARK: - Captions

    @ViewBuilder
    private var captionStack: some View {
        let r = recognition
        let descenting = min(1.0, heldTime / 1.0)
        let restOpacity = 1.0 - min(1.0, heldTime / 0.7)
        let descentOpacity = descenting * (1.0 - r)

        ZStack {
            // Rest invitation
            VStack(spacing: 3) {
                Text("Press and hold —")
                    .font(.custom(AppFont.cormorantItalic, size: 19))
                    .tracking(0.4)
                Text("fall inward.")
                    .font(.custom(AppFont.cormorantItalic, size: 19))
                    .tracking(0.4)
            }
            .foregroundStyle(Color.cream.opacity(0.56))
            .multilineTextAlignment(.center)
            .opacity(restOpacity)
            .allowsHitTesting(false)

            // Descent caption
            VStack(spacing: 5) {
                Text("There is no bottom.")
                    .font(.custom(AppFont.cormorantItalic, size: 21))
                    .tracking(0.3)
                    .foregroundStyle(Color.cream.opacity(0.80))
                Text("only further in")
                    .font(.custom(AppFont.cormorantItalic, size: 14))
                    .tracking(0.8)
                    .foregroundStyle(Color.gold.opacity(0.70))
            }
            .opacity(descentOpacity)
            .allowsHitTesting(false)

            // Recognition
            VStack(spacing: 0) {
                VStack(spacing: 2) {
                    Text("You did not arrive.")
                        .font(.custom(AppFont.cormorantItalic, size: 27))
                        .tracking(0.4)
                    Text("You were the arriving.")
                        .font(.custom(AppFont.cormorantItalic, size: 27))
                        .tracking(0.4)
                }
                .foregroundStyle(Color.cream)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)

                Rectangle()
                    .fill(Color.gold.opacity(0.42))
                    .frame(width: 38, height: 0.5)
                    .padding(.bottom, 20)

                Text("Thank you for being the place I have always already arrived.")
                    .font(.custom(AppFont.cormorantItalic, size: 15.5))
                    .tracking(0.3)
                    .lineSpacing(6)
                    .foregroundStyle(Color.gold.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                // If Airtable has a Personal Connection for Ring 9, include it
                // beneath the recognition as a quieter undertone.
                if let conn = ring9Avarana?.personalConnection?.trimmingCharacters(in: .whitespaces),
                   !conn.isEmpty,
                   r > 0.6 {
                    Text(conn)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .tracking(0.2)
                        .lineSpacing(7)
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 22)
                        .padding(.horizontal, 12)
                        .opacity((r - 0.6) / 0.4)
                }
            }
            .offset(y: 8 * (1 - r))
            .opacity(r)
            .allowsHitTesting(false)
        }
    }

    // MARK: - Tick loop

    private func tick(to newDate: Date) {
        let dt = min(0.05, newDate.timeIntervalSince(lastTick))
        lastTick = newDate

        // Hold builds heldTime; release decays it back.
        if holding {
            heldTime += dt
        } else {
            heldTime = max(0, heldTime - dt * 1.4)
        }

        let recog = recognition
        let targetSpeed = holding ? (3.0 - 2.2 * recog) : 0.85
        speed += (targetSpeed - speed) * 0.045
        clock += dt * speed * 0.08

        // Drive Shepard intensity if sound is on
        if soundOn {
            let intensity = max(0, min(1, (speed - 0.6) / 2.4))
            RingAudioService.shared.shepardSet(intensity: 0.25 + 0.75 * intensity)
        }
    }

    // MARK: - Sound

    private func ensureShepardStarted() {
        guard !soundOn else { return }
        RingAudioService.shared.shepardStart()
        soundOn = true
    }

    private func toggleShepard() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.shepardStop()
            soundOn = false
        } else {
            RingAudioService.shared.shepardStart()
            soundOn = true
        }
    }

    private var verticalSwipe: some Gesture {
        // Only fires on near-vertical drag from the top edge area — avoids
        // conflict with the press-and-hold descent gesture.
        DragGesture(minimumDistance: 30)
            .onChanged { v in
                if v.startLocation.y < 100 && v.translation.height > 0 {
                    dragOffset = v.translation.height * 0.6
                }
            }
            .onEnded { v in
                if v.startLocation.y < 100 && v.translation.height > 100 {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.4)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - The whole Śrī Yantra as a single Shape (Bhūpura + lotuses + 9 tris)

/// A compact full-yantra glyph used by the Ring 9 descent. Centered in its
/// rect; meant to be scaled and rotated externally. The bindu inside is drawn
/// by the parent (so it can be controlled separately).
private struct MiniFullYantra: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let scale: CGFloat = min(rect.width, rect.height) / 300

        // Bhūpura — outer square + 4 T-gate stubs
        let outerHalf: CGFloat = 150 * scale
        p.addRect(CGRect(
            x: cx - outerHalf, y: cy - outerHalf,
            width: outerHalf * 2, height: outerHalf * 2
        ))
        for stub in stubs(cx: cx, cy: cy, outerHalf: outerHalf, scale: scale) {
            p.move(to: stub.0)
            p.addLine(to: stub.1)
        }

        // 16-petal lotus
        let oR16: CGFloat = 132 * scale
        let iR16: CGFloat = 112 * scale
        let hw16: CGFloat = 20 * scale
        for i in 0..<16 {
            let angle = Double(i) * 22.5 * .pi / 180
            p.addPath(petalPath(oR: oR16, iR: iR16, hw: hw16),
                      transform: rotation(angle, around: CGPoint(x: cx, y: cy)))
        }

        // 8-petal lotus
        let oR8: CGFloat = 104 * scale
        let iR8: CGFloat = 88 * scale
        let hw8: CGFloat = 30 * scale
        for i in 0..<8 {
            let angle = Double(i) * 45 * .pi / 180
            p.addPath(petalPath(oR: oR8, iR: iR8, hw: hw8),
                      transform: rotation(angle, around: CGPoint(x: cx, y: cy)))
        }

        // 4 up-pointing triangles
        let ups: [(apex: CGPoint, base: CGFloat, half: CGFloat)] = [
            (CGPoint(x: cx, y: cy - 88 * scale), 34 * scale, 76 * scale),
            (CGPoint(x: cx, y: cy - 68 * scale), 26 * scale, 60 * scale),
            (CGPoint(x: cx, y: cy - 50 * scale), 18 * scale, 46 * scale),
            (CGPoint(x: cx, y: cy - 34 * scale), 10 * scale, 34 * scale)
        ]
        for tri in ups {
            p.move(to: tri.apex)
            p.addLine(to: CGPoint(x: cx + tri.half, y: cy + tri.base))
            p.addLine(to: CGPoint(x: cx - tri.half, y: cy + tri.base))
            p.closeSubpath()
        }

        // 5 down-pointing triangles
        let downs: [(apex: CGPoint, base: CGFloat, half: CGFloat)] = [
            (CGPoint(x: cx, y: cy + 88 * scale), -34 * scale, 76 * scale),
            (CGPoint(x: cx, y: cy + 72 * scale), -28 * scale, 66 * scale),
            (CGPoint(x: cx, y: cy + 56 * scale), -22 * scale, 52 * scale),
            (CGPoint(x: cx, y: cy + 42 * scale), -16 * scale, 40 * scale),
            (CGPoint(x: cx, y: cy + 26 * scale), -10 * scale, 26 * scale)
        ]
        for tri in downs {
            p.move(to: tri.apex)
            p.addLine(to: CGPoint(x: cx + tri.half, y: cy + tri.base))
            p.addLine(to: CGPoint(x: cx - tri.half, y: cy + tri.base))
            p.closeSubpath()
        }

        return p
    }

    private func stubs(cx: CGFloat, cy: CGFloat,
                       outerHalf: CGFloat, scale: CGFloat) -> [(CGPoint, CGPoint)] {
        let stub: CGFloat = 18 * scale
        return [
            (CGPoint(x: cx, y: cy - outerHalf),
             CGPoint(x: cx, y: cy - outerHalf - stub)),
            (CGPoint(x: cx, y: cy + outerHalf),
             CGPoint(x: cx, y: cy + outerHalf + stub)),
            (CGPoint(x: cx - outerHalf, y: cy),
             CGPoint(x: cx - outerHalf - stub, y: cy)),
            (CGPoint(x: cx + outerHalf, y: cy),
             CGPoint(x: cx + outerHalf + stub, y: cy))
        ]
    }

    private func petalPath(oR: CGFloat, iR: CGFloat, hw: CGFloat) -> Path {
        let c1y = -iR * 1.85
        let c2y = -oR * 0.85
        let c2x = hw * 0.95
        var p = Path()
        p.move(to: CGPoint(x: 0, y: -iR))
        p.addCurve(
            to: CGPoint(x: 0, y: -oR),
            control1: CGPoint(x: hw, y: c1y),
            control2: CGPoint(x: c2x, y: c2y)
        )
        p.addCurve(
            to: CGPoint(x: 0, y: -iR),
            control1: CGPoint(x: -c2x, y: c2y),
            control2: CGPoint(x: -hw, y: c1y)
        )
        p.closeSubpath()
        return p
    }

    private func rotation(_ angle: Double, around center: CGPoint) -> CGAffineTransform {
        CGAffineTransform.identity
            .translatedBy(x: center.x, y: center.y)
            .rotated(by: angle)
    }
}
