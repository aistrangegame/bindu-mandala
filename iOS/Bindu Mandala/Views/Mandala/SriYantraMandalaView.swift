import SwiftUI

/// The full nine-ring Śrī Yantra.
/// All geometry constants are pixel values for a 344pt design diameter,
/// scaled by `diameter / 344` so other sizes lay out correctly.
struct SriYantraMandalaView: View {
    let shaktis: [Shakti]
    let todayIndex: Int?
    let variant: TimeVariant
    var diameter: CGFloat = 344
    var onShaktiTap: (Shakti) -> Void = { _ in }
    var onBinduTap: () -> Void = {}            // Ring 9 only — other rings route via the Veil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var scale: CGFloat { diameter / 344 }
    private var ring2Shaktis: [Shakti] {
        shaktis.filter { ($0.ringNumber ?? 2) == 2 }
               .sorted { $0.position < $1.position }
    }

    var body: some View {
        ZStack {
            // Ambient center warmth
            Canvas { ctx, size in
                let cx = size.width / 2, cy = size.height / 2
                let r = cx * 0.9
                let rect = CGRect(x: cx - r, y: cy - r, width: 2*r, height: 2*r)
                let grad = Gradient(stops: [
                    .init(color: Color.gold.opacity(0.05), location: 0),
                    .init(color: .clear, location: 1)
                ])
                ctx.fill(Path(ellipseIn: rect),
                         with: .radialGradient(grad, center: CGPoint(x: cx, y: cy),
                                               startRadius: 0, endRadius: r))
            }
            .allowsHitTesting(false)

            // Ring 1 — Bhūpura (ancient ground, no breath)
            BhupuraLayer(variant: variant, scale: scale)

            // Faint Ring 2 outer boundary (just past the lotus tips)
            boundaryCircle(radius: 135, opacity: 0.07, width: 0.4)

            // Ring 2 — Home Lotus, 16 cluster-colored petals
            Ring2Layer(shaktis: ring2Shaktis,
                       todayIndex: todayIndex,
                       variant: variant,
                       scale: scale,
                       reduceMotion: reduceMotion,
                       onTap: onShaktiTap)
                .saturation(variant.petalSat)
                .brightness(variant.petalBrightness - 1)

            // Ring 2/3 boundary
            boundaryCircle(radius: 91, opacity: 0.10, width: 0.4)

            // Ring 3 — Anaṅga Lotus, 8 petals (held, no breath)
            Ring3Layer(variant: variant, scale: scale, reduceMotion: reduceMotion)

            // Ring 3/triangles boundary
            boundaryCircle(radius: 87, opacity: 0.07, width: 0.35)

            // Rings 4-7 — Triangle pairs (each its own breath)
            TriangleZoneLayer(variant: variant, scale: scale, reduceMotion: reduceMotion)

            // Ring 8 — Mūla Trikoṇa
            MulaTrikonaLayer(variant: variant, scale: scale, reduceMotion: reduceMotion)

            // TODAY indicator (ray + dot, no text)
            if let todayIndex {
                TodayIndicatorLayer(todayIndex: todayIndex, scale: scale)
            }

            // Ring 9 — Bindu (overlay, always alive)
            BinduLayer(variant: variant, scale: scale, reduceMotion: reduceMotion, onTap: onBinduTap)
        }
        .frame(width: diameter, height: diameter)
    }

    private func boundaryCircle(radius: CGFloat, opacity: Double, width: CGFloat) -> some View {
        Circle()
            .stroke(Color.gold.opacity(opacity), lineWidth: width)
            .frame(width: radius * 2 * scale, height: radius * 2 * scale)
            .allowsHitTesting(false)
    }

}

// MARK: - Ring 1 · Bhūpura

private struct BhupuraLayer: View {
    let variant: TimeVariant
    let scale: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2, cy = size.height / 2
            let o: CGFloat = 161 * scale
            let i: CGFloat = 149 * scale
            let g: CGFloat = 11 * scale
            let col = variant.bhupuraColor
            let style = StrokeStyle(lineWidth: 0.5, lineJoin: .miter)

            // Outer square
            ctx.stroke(
                Path(CGRect(x: cx - o, y: cy - o, width: 2*o, height: 2*o)),
                with: .color(col), style: style
            )

            // Inner square as 8 line segments — gaps at each cardinal center
            let segs: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx-i, cy-i, cx-g, cy-i), (cx+g, cy-i, cx+i, cy-i),   // top
                (cx+i, cy-i, cx+i, cy-g), (cx+i, cy+g, cx+i, cy+i),   // right
                (cx+i, cy+i, cx+g, cy+i), (cx-g, cy+i, cx-i, cy+i),   // bottom
                (cx-i, cy+i, cx-i, cy+g), (cx-i, cy-g, cx-i, cy-i),   // left
            ]
            // T-gate connectors
            let gates: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx-g, cy-i, cx-g, cy-o), (cx+g, cy-i, cx+g, cy-o),   // top gate
                (cx-g, cy+i, cx-g, cy+o), (cx+g, cy+i, cx+g, cy+o),   // bottom gate
                (cx-i, cy-g, cx-o, cy-g), (cx-i, cy+g, cx-o, cy+g),   // left gate
                (cx+i, cy-g, cx+o, cy-g), (cx+i, cy+g, cx+o, cy+g),   // right gate
            ]
            for (x1, y1, x2, y2) in segs + gates {
                var p = Path()
                p.move(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x2, y: y2))
                ctx.stroke(p, with: .color(col), style: style)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Lotus petal shape (Rings 2 & 3)

private struct LotusPetal: Shape {
    let outerR: CGFloat
    let innerR: CGFloat
    let halfW: CGFloat

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let oR = outerR, iR = innerR, hw = halfW
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

// MARK: - Ring 2 · Home Lotus (16 petals, 3s wave breath)

private struct Ring2Layer: View {
    let shaktis: [Shakti]
    let todayIndex: Int?
    let variant: TimeVariant
    let scale: CGFloat
    let reduceMotion: Bool
    let onTap: (Shakti) -> Void

    @State private var phase: CGFloat = 0

    // R2 geometry adopted from Claude Designs/home-mandala.jsx (PureMandala),
    // which sizes the lotus to fit cleanly inside the Bhūpura in the full
    // nine-ring context (the bezier shoulders bulge past R2_OUTER, so the
    // mandala-v2 values 147/116/28 actually overflow at ~160).
    private let oR: CGFloat = 134, iR: CGFloat = 112, hw: CGFloat = 22
    private var labelR: CGFloat { (oR + iR) / 2 * scale }
    private var sOR: CGFloat { oR * scale }
    private var sIR: CGFloat { iR * scale }
    private var sHW: CGFloat { hw * scale }

    var body: some View {
        ZStack {
            ForEach(0..<16, id: \.self) { i in
                petal(at: i)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }

    @ViewBuilder
    private func petal(at i: Int) -> some View {
        if let shakti = shaktis.first(where: { $0.position == i + 1 }) {
            let angle = Double(i) * 22.5
            let cluster = shakti.cluster.color
            let isToday = (i == todayIndex)
            let isEmbodied = (shakti.status == .embodied)
            let staggerDelay = isToday ? 0.0 : Double(i) * 0.18
            let modulated = (Double(phase) + staggerDelay / 3.0)
                .truncatingRemainder(dividingBy: 1.0)
            let breath = sin(modulated * 2 * .pi) * 0.10
            let baseOp = shakti.status.opacity * variant.petalOpacityMul
            let opacity = max(0, min(1, baseOp + breath))

            ZStack {
                if isEmbodied {
                    LotusPetal(outerR: sOR, innerR: sIR, halfW: sHW)
                        .rotation(.degrees(angle))
                        .fill(cluster.opacity(0.15))
                        .blur(radius: 5)
                }
                LotusPetal(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(cluster)
                    .opacity(opacity)
                    .shadow(color: isToday ? cluster.opacity(0.6) : .clear,
                            radius: isToday ? 14 : 0)
                    .contentShape(
                        LotusPetal(outerR: sOR, innerR: sIR, halfW: sHW * 1.15)
                            .rotation(.degrees(angle))
                    )
                    .onTapGesture {
                        Haptics.light()
                        onTap(shakti)
                    }
                label(at: i, shortName: shakti.shortName, color: cluster,
                      opacity: shakti.status.opacity)
            }
        }
    }

    private func label(at i: Int, shortName: String, color: Color, opacity: Double) -> some View {
        let angle = Double(i) * 22.5
        let theta = (angle - 90) * .pi / 180
        let lop = min(0.82, opacity + 0.18)
        let center = (344 / 2) * scale
        return Text(shortName)
            .font(.custom(AppFont.cormorant, size: 11 * scale))
            .foregroundStyle(color.opacity(lop))
            .position(
                x: center + labelR * cos(theta),
                y: center + labelR * sin(theta)
            )
            .allowsHitTesting(false)
    }
}

// MARK: - Ring 3 · Unlocked Lotus (8 petals, 8s breath)

private struct Ring3Layer: View {
    let variant: TimeVariant
    let scale: CGFloat
    let reduceMotion: Bool   // accepted for API parity; the held yantra never breathes here

    private let oR: CGFloat = 114, iR: CGFloat = 91, hw: CGFloat = 34
    private var sOR: CGFloat { oR * scale }
    private var sIR: CGFloat { iR * scale }
    private var sHW: CGFloat { hw * scale }

    var body: some View {
        let petalOp = variant.lotusInnerOp
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                let angle = Double(i) * 45
                LotusPetal(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(Color.gold.opacity(petalOp))
                    .overlay(
                        LotusPetal(outerR: sOR, innerR: sIR, halfW: sHW)
                            .rotation(.degrees(angle))
                            .stroke(Color.gold.opacity(petalOp), lineWidth: 0.5)
                    )
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Triangle path

private struct TriPath: Shape {
    let R: CGFloat
    let up: Bool

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let h = R * sqrt(3) / 2
        let half = R / 2
        var p = Path()
        if up {
            p.move(to: CGPoint(x: cx, y: cy - R))
            p.addLine(to: CGPoint(x: cx + h, y: cy + half))
            p.addLine(to: CGPoint(x: cx - h, y: cy + half))
        } else {
            p.move(to: CGPoint(x: cx, y: cy + R))
            p.addLine(to: CGPoint(x: cx + h, y: cy - half))
            p.addLine(to: CGPoint(x: cx - h, y: cy - half))
        }
        p.closeSubpath()
        return p
    }
}

// MARK: - Rings 4-7 · Triangle Zone

private struct TriangleZoneLayer: View {
    let variant: TimeVariant
    let scale: CGFloat
    let reduceMotion: Bool

    private let pairs: [(d: CGFloat, u: CGFloat, sw: CGFloat, period: Double)] = [
        (87, 79, 0.70, 9.0),    // Ring 4
        (70, 62, 0.65, 11.0),   // Ring 5
        (54, 46, 0.60, 13.0),   // Ring 6
        (40, 33, 0.55, 15.0),   // Ring 7
    ]

    var body: some View {
        ZStack {
            ForEach(0..<pairs.count, id: \.self) { i in
                TrianglePair(
                    d: pairs[i].d * scale,
                    u: pairs[i].u * scale,
                    sw: pairs[i].sw,
                    period: pairs[i].period,
                    variant: variant,
                    reduceMotion: reduceMotion
                )
            }
        }
        .allowsHitTesting(false)
    }
}

private struct TrianglePair: View {
    let d: CGFloat
    let u: CGFloat
    let sw: Double
    let period: Double
    let variant: TimeVariant
    let reduceMotion: Bool   // accepted for API parity; the held yantra never breathes here

    var body: some View {
        ZStack {
            TriPath(R: d, up: false)
                .stroke(variant.triStroke,
                        style: StrokeStyle(lineWidth: variant.triStrokeWidth, lineJoin: .round))
                .opacity(variant.triOpacity)
            TriPath(R: u, up: true)
                .stroke(variant.triStroke,
                        style: StrokeStyle(lineWidth: variant.triStrokeWidth, lineJoin: .round))
                .opacity(variant.triOpacity)
        }
    }
}

// MARK: - Ring 8 · Mūla Trikoṇa

private struct MulaTrikonaLayer: View {
    let variant: TimeVariant
    let scale: CGFloat
    let reduceMotion: Bool   // accepted for API parity; the held yantra never breathes here

    var body: some View {
        TriPath(R: 24 * scale, up: false)
            .stroke(variant.triStroke,
                    style: StrokeStyle(lineWidth: 0.45, lineJoin: .round))
            .opacity(variant.triOpacity)
            .allowsHitTesting(false)
    }
}

// MARK: - TODAY Indicator (ray + dot)

private struct TodayIndicatorLayer: View {
    let todayIndex: Int
    let scale: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulsePhase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let a = (Double(todayIndex) * 22.5 - 90) * .pi / 180
            let cosA = cos(a), sinA = sin(a)
            // r1 starts just past the new R2 petal edge (oR=134 + 2 buffer);
            // r2 ends past the Bhūpura outer (161); dot floats 10pt beyond.
            let r1: CGFloat = 136 * scale
            let r2: CGFloat = 168 * scale
            let r3: CGFloat = 178 * scale
            let pulse = reduceMotion ? 0 : sin(Double(pulsePhase) * 2 * .pi) * 0.15
            let rayOpacity = max(0.4, min(1.0, 0.85 + pulse))
            let dotOpacity = max(0.5, min(1.0, 0.95 + pulse * 0.5))

            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: cx + r1 * cosA, y: cy + r1 * sinA))
                    p.addLine(to: CGPoint(x: cx + r2 * cosA, y: cy + r2 * sinA))
                }
                .stroke(Color.gold.opacity(rayOpacity), lineWidth: 1.0)

                Circle()
                    .fill(Color.gold)
                    .opacity(dotOpacity)
                    .frame(width: 7, height: 7)
                    .shadow(color: Color.gold.opacity(0.7), radius: 4)
                    .position(x: cx + r3 * cosA, y: cy + r3 * sinA)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: false)) {
                pulsePhase = 1
            }
        }
    }
}

// MARK: - Ring 9 · Bindu

private struct BinduLayer: View {
    let variant: TimeVariant
    let scale: CGFloat
    let reduceMotion: Bool
    let onTap: () -> Void

    @State private var phase: CGFloat = 0

    private let base: CGFloat = 22

    var body: some View {
        let breath = reduceMotion ? 0 : sin(Double(phase) * 2 * .pi) * 0.06
        let size = base * scale * CGFloat(variant.binduScale) * (1 + breath)
        let core = size * 0.38

        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: variant.binduColor, location: 0),
                            .init(color: variant.binduColor.opacity(0.65), location: 0.52),
                            .init(color: .clear, location: 1)
                        ]),
                        center: .center, startRadius: 0, endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)

            Circle()
                .fill(Color.cream)
                .opacity(0.95)
                .frame(width: core, height: core)
                .shadow(color: Color.cream.opacity(0.55), radius: 9 * scale)
        }
        .frame(width: 64, height: 64)
        .contentShape(Circle())
        .onTapGesture {
            Haptics.light()
            onTap()
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}
