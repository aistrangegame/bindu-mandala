import SwiftUI
import SwiftData

/// Ring 5 World — Kulottīrṇa, the Overflow.
///
/// Ten triangles inside a containing boundary circle. Tap one — her light
/// spills past the boundary. Tap center — all ten overflow at once, the
/// boundary dissolves into a dashed memory, light floods.
struct RingFiveWorldView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var active: Int? = nil
    @State private var flood: Bool = false
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0

    private let gold = Color(hex: "#D4A017")

    /// Reverent glosses, one per Kulottīrṇa (Khaḍgamālā 67–76). Placeholder
    /// until Airtable supplies per-Shakti quality lines.
    private let glosses: [String] = [
        "grants attainment", "grants abundance", "makes beloved",
        "the auspicious one", "grants every desire", "the liberator",
        "conqueror of death", "remover of obstacles",
        "beauty in all limbs", "grantor of grace"
    ]

    private var ring5Shaktis: [Shakti] {
        Array(allShaktis.filter { $0.ringNumber == 5 }
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
            .prefix(10))
    }

    var body: some View {
        ZStack {
            // Ground
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#0E0A04"), location: 0),
                    .init(color: Color(hex: "#080502"), location: 0.55),
                    .init(color: Color(hex: "#050301"), location: 1)
                ]),
                center: UnitPoint(x: 0.5, y: 0.44),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()

            // Ambient — shifts when flooding
            RadialGradient(
                gradient: Gradient(stops: flood ? [
                    .init(color: gold.opacity(0.22), location: 0),
                    .init(color: Color.cream.opacity(0.06), location: 0.45),
                    .init(color: .clear, location: 0.85)
                ] : [
                    .init(color: gold.opacity(0.10), location: 0),
                    .init(color: .clear, location: 0.72)
                ]),
                center: UnitPoint(x: 0.5, y: 0.44),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .animation(.easeInOut(duration: 1.2), value: flood)

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy: CGFloat = min(392, geo.size.height * 0.46)
                let ringR: CGFloat = 116
                let boundR: CGFloat = 142
                let nodes = (0..<10).map { i -> (a: Double, p: CGPoint) in
                    let a = (Double(i) / 10.0) * 2 * .pi - .pi / 2
                    let p = CGPoint(x: cx + ringR * CGFloat(cos(a)),
                                    y: cy + ringR * CGFloat(sin(a)))
                    return (a, p)
                }

                ZStack {
                    // Ring identity
                    VStack(spacing: 5) {
                        Text("Sarvārthasādhaka · the Kulottīrṇas")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(2.8)
                            .foregroundStyle(gold.opacity(0.78))
                            .multilineTextAlignment(.center)
                        Text("TEN · OVERFLOWING WHAT CONTAINS THEM")
                            .font(.system(size: 10))
                            .tracking(3.0)
                            .foregroundStyle(Color.cream.opacity(0.45))
                    }
                    .position(x: cx, y: 96)
                    .allowsHitTesting(false)

                    // Boundary circle
                    Circle()
                        .stroke(
                            gold.opacity(flood ? 0.12 : 0.40),
                            style: StrokeStyle(
                                lineWidth: flood ? 0.4 : 0.9,
                                dash: flood ? [2, 8] : []
                            )
                        )
                        .frame(width: boundR * 2, height: boundR * 2)
                        .position(x: cx, y: cy)
                        .animation(.easeInOut(duration: 1.2), value: flood)
                        .allowsHitTesting(false)

                    // Overflow rays
                    ForEach(0..<10, id: \.self) { i in
                        if flood || active == i {
                            overflowRay(angle: nodes[i].a, cx: cx, cy: cy,
                                        ringR: ringR, boundR: boundR)
                                .allowsHitTesting(false)
                                .transition(.opacity)
                        }
                    }

                    // 10 triangles
                    ForEach(0..<10, id: \.self) { i in
                        triangleStation(
                            at: nodes[i].p,
                            angle: nodes[i].a,
                            isActive: active == i,
                            isFlooding: flood,
                            tap: { tap(i) }
                        )
                    }

                    // Center dot
                    Circle()
                        .fill(gold.opacity(0.70))
                        .frame(width: 6, height: 6)
                        .position(x: cx, y: cy)
                        .allowsHitTesting(false)

                    // Center gesture target (transcend the kula)
                    Color.clear
                        .frame(width: 48, height: 48)
                        .contentShape(Circle())
                        .position(x: cx, y: cy)
                        .onTapGesture { overflowAll() }

                    // Caption
                    captionBlock
                        .frame(maxWidth: geo.size.width - 72)
                        .position(x: cx, y: geo.size.height - 224)

                    // Hint
                    Text("TOUCH ONE TO OVERFLOW · THE CENTER TO TRANSCEND THE KULA")
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
        .offset(y: dragOffset)
        .gesture(swipeDown)
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
                label: "overflow",
                color: gold,
                onToggle: { Haptics.light(); soundOn.toggle() }
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
    }

    // MARK: - Triangle station

    @ViewBuilder
    private func triangleStation(at position: CGPoint,
                                  angle: Double,
                                  isActive: Bool,
                                  isFlooding: Bool,
                                  tap: @escaping () -> Void) -> some View {
        let on = isFlooding || isActive
        let opacity: Double = on ? 0.95 : (active != nil ? 0.22 : 0.50)

        ZStack {
            if on {
                RingTriangle(size: 15, up: true)
                    .fill(gold.opacity(0.18))
                    .blur(radius: 5)
            }
            RingTriangle(size: 13, up: true)
                .stroke(on ? Color.cream : gold, lineWidth: 0.9)
                .opacity(opacity)
        }
        .frame(width: 36, height: 36)
        .rotationEffect(.degrees(angle * 180 / .pi + 90))
        .contentShape(Rectangle())
        .position(position)
        .onTapGesture(perform: tap)
        .animation(.easeInOut(duration: 0.6), value: on)
        .animation(.easeInOut(duration: 0.6), value: opacity)
    }

    // MARK: - Overflow ray

    @ViewBuilder
    private func overflowRay(angle: Double,
                              cx: CGFloat, cy: CGFloat,
                              ringR: CGFloat, boundR: CGFloat) -> some View {
        let startR = ringR - 10
        let endR = boundR + 70
        let startPoint = CGPoint(
            x: cx + CGFloat(cos(angle)) * startR,
            y: cy + CGFloat(sin(angle)) * startR
        )
        let endPoint = CGPoint(
            x: cx + CGFloat(cos(angle)) * endR,
            y: cy + CGFloat(sin(angle)) * endR
        )
        Path { p in
            p.move(to: startPoint)
            p.addLine(to: endPoint)
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.cream.opacity(0.50), location: 0),
                    .init(color: gold.opacity(0), location: 1)
                ]),
                startPoint: UnitPoint(
                    x: 0.5 - CGFloat(cos(angle)) * 0.5,
                    y: 0.5 - CGFloat(sin(angle)) * 0.5
                ),
                endPoint: UnitPoint(
                    x: 0.5 + CGFloat(cos(angle)) * 0.5,
                    y: 0.5 + CGFloat(sin(angle)) * 0.5
                )
            ),
            lineWidth: 6
        )
    }

    // MARK: - Caption

    @ViewBuilder
    private var captionBlock: some View {
        if let i = active, i < ring5Shaktis.count {
            let s = ring5Shaktis[i]
            VStack(spacing: 6) {
                Text(s.name.isEmpty ? "Station \(i + 1)" : s.name)
                    .font(.custom(AppFont.cormorant, size: 34))
                    .tracking(1.7)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                Text(glosses[safeIndex: i] ?? "")
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(0.3)
                    .foregroundStyle(gold.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else if flood {
            VStack(spacing: 12) {
                Text("The accomplishment overflows the one who sought it.")
                    .font(.custom(AppFont.cormorantItalic, size: 23))
                    .tracking(0.3)
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.80))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text("THE BOUNDARY CANNOT HOLD HER")
                    .font(.system(size: 9))
                    .tracking(2.8)
                    .foregroundStyle(gold.opacity(0.55))
            }
            .transition(.opacity)
        } else {
            Text("Ten forces the circle was meant to hold — and cannot.")
                .font(.custom(AppFont.cormorantItalic, size: 19))
                .tracking(0.3)
                .lineSpacing(6)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        }
    }

    // MARK: - Interactions

    private func tap(_ i: Int) {
        Haptics.light()
        flood = false
        active = i
        if soundOn {
            RingAudioService.shared.playSteppedNote(freq: 261.6, duration: 1.8, volume: 0.05)
        }
    }

    private func overflowAll() {
        Haptics.medium()
        active = nil
        flood = true
        if soundOn {
            for k in 0..<4 {
                let delay = Double(k) * 0.09
                let freq = 261.6 * pow(2.0, Double(k) / 12.0)
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(delay))
                    RingAudioService.shared.playSteppedNote(freq: freq, duration: 2.4, volume: 0.04)
                }
            }
        }
    }

    private func release() {
        active = nil
        flood = false
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
