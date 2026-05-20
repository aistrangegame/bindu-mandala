import SwiftUI

/// The full 16-petal lotus.
///
/// - `shaktis`: ordered by position 1–16 (caller's responsibility).
/// - `todayIndex`: petal index 0–15 (= position − 1) that should breathe and
///   carry the TODAY ray/label. Pass `nil` to suppress the active state.
/// - `onPetalTap`: invoked with the tapped petal's position (1–16).
/// - `onBinduTap`: invoked when the center is tapped.
struct LotusMandalaView: View {
    let shaktis: [Shakti]
    let todayIndex: Int?
    let diameter: CGFloat
    var onPetalTap: ((Int) -> Void)?
    var onBinduTap: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breathePhase: CGFloat = 0
    @State private var binduPhase: CGFloat = 0

    private var outerR: CGFloat { diameter * 0.435 }
    private var innerR: CGFloat { diameter * 0.117 }
    private var labelR: CGFloat { (innerR + outerR) * 0.5 }

    var body: some View {
        ZStack {
            ghostGeometry
            petals
            todayRay
            bindu
        }
        .frame(width: diameter, height: diameter)
        .onAppear(perform: startBreathing)
    }

    // MARK: - Petals

    @ViewBuilder
    private var petals: some View {
        if shaktis.isEmpty {
            skeletonPetals
        } else {
            ZStack {
                ForEach(0..<16, id: \.self) { i in
                    let shakti = shakti(at: i)
                    let angle = Double(i) * 22.5
                    petalView(for: shakti, at: i, angle: angle)
                }
            }
        }
    }

    /// Drawn while `shaktis` is empty (pre-bootstrap / sync error).
    /// Faint petal outlines arranged in the 16-fold geometry. No labels,
    /// no fills, no tap targets — the lotus reads as "not yet inhabited."
    private var skeletonPetals: some View {
        ZStack {
            ForEach(0..<16, id: \.self) { i in
                PetalShape()
                    .stroke(Color.gold.opacity(0.10), lineWidth: 0.5)
                    .rotationEffect(.degrees(Double(i) * 22.5))
            }
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func petalView(for shakti: Shakti, at index: Int, angle: Double) -> some View {
        let clusterColor = shakti.cluster.color
        let baseOpacity = shakti.status.opacity
        let isToday = index == todayIndex
        let isEmbodied = shakti.status == .embodied
        // Breathing modulates a thin band around the base opacity.
        let breathBoost: CGFloat = isToday && !reduceMotion ? (sin(breathePhase * .pi * 2) * 0.18) : 0
        let effectiveOpacity = max(0, min(1, baseOpacity + Double(breathBoost)))

        // Bake the rotation into the Shape's path rather than applying a
        // .rotationEffect to the view. .rotationEffect is render-only and
        // does NOT rotate the contentShape's interpretation — so every
        // petal's hit area ends up stacked at the top of the un-rotated
        // parent frame, and only the last petal in the ZStack ever wins
        // a tap. Using .rotation on the Shape itself keeps the painted
        // path and the contentShape in the same coordinate space at the
        // same angle.
        PetalShape()
            .rotation(.degrees(angle))
            .fill(clusterColor)
            .opacity(effectiveOpacity)
            .blur(radius: isEmbodied ? 0.6 : 0)
            .shadow(color: isToday ? clusterColor.opacity(0.6) : .clear,
                    radius: isToday ? 14 : 0)
            .contentShape(petalHitArea(angle: angle))
            .onTapGesture {
                Haptics.light()
                onPetalTap?(shakti.position)
            }
            .overlay(petalLabel(for: shakti, at: angle, opacity: baseOpacity))
    }

    /// Loosely-fitted hit area to make petal taps comfortable on iPhone.
    /// The angle is baked into the path so the hit region sits over the
    /// painted petal — see `petalView` for why this can't be a
    /// .rotationEffect.
    private func petalHitArea(angle: Double) -> some Shape {
        PetalShape(outerRatio: 0.46, innerRatio: 0.10, halfWidthRatio: 0.11)
            .rotation(.degrees(angle))
    }

    @ViewBuilder
    private func petalLabel(for shakti: Shakti, at angle: Double, opacity: Double) -> some View {
        // Labels float along the wheel, oriented horizontally (counter-rotated).
        let theta = (angle - 90) * .pi / 180
        let x = diameter / 2 + labelR * cos(theta)
        let y = diameter / 2 + labelR * sin(theta)
        Text(shakti.shortName)
            .font(.custom(AppFont.cormorant, size: diameter * 0.021))
            .foregroundStyle(Color.cream.opacity(opacity > 0.5 ? 0.82 : 0.38))
            .position(x: x, y: y)
            .allowsHitTesting(false)
    }

    // MARK: - Ghost geometry (outer avaraṇas)

    private var ghostGeometry: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // 3 concentric outer rings
            let ringSpecs: [(scale: CGFloat, alpha: Double, dashed: Bool)] = [
                (1.08, 0.07, false),
                (1.14, 0.055, false),
                (1.20, 0.04, true),
            ]
            for (scale, alpha, dashed) in ringSpecs {
                let r = outerR * scale
                let rect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
                let path = Path(ellipseIn: rect)
                if dashed {
                    let dashed = path.strokedPath(StrokeStyle(lineWidth: 0.6, dash: [4, 7]))
                    ctx.fill(dashed, with: .color(Color.gold.opacity(alpha)))
                } else {
                    ctx.stroke(path, with: .color(Color.gold.opacity(alpha)), lineWidth: 0.6)
                }
            }

            // Inner geometry rings (close to bindu)
            let inner1 = Path(ellipseIn: CGRect(
                x: cx - innerR * 0.8, y: cy - innerR * 0.8,
                width: innerR * 1.6, height: innerR * 1.6))
            ctx.stroke(inner1, with: .color(Color.gold.opacity(0.2)), lineWidth: 0.5)
            let inner2 = Path(ellipseIn: CGRect(
                x: cx - innerR * 1.4, y: cy - innerR * 1.4,
                width: innerR * 2.8, height: innerR * 2.8))
            ctx.stroke(inner2, with: .color(Color.gold.opacity(0.1)), lineWidth: 0.5)
        }
        .overlay(ghostOuterPetals)
        .allowsHitTesting(false)
    }

    /// The 8-petal locked ring sitting just outside the 16-petal lotus.
    /// Offset by 22.5° so they sit between the inner petals.
    private var ghostOuterPetals: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                let angle = Double(i) * 45.0 + 22.5
                GhostPetalShape()
                    .fill(Color.gold.opacity(0.04))
                    .overlay(
                        GhostPetalShape()
                            .stroke(Color.gold.opacity(0.08), lineWidth: 0.5)
                    )
                    .rotationEffect(.degrees(angle))
            }
        }
    }

    // MARK: - TODAY ray / dot / label

    @ViewBuilder
    private var todayRay: some View {
        if let index = todayIndex {
            let angle = (Double(index) * 22.5 - 90) * .pi / 180
            let cosA = cos(angle), sinA = sin(angle)
            let r1 = outerR * 1.06
            let r2 = outerR * 1.21
            let r3 = outerR * 1.34
            let cx = diameter / 2, cy = diameter / 2

            Path { p in
                p.move(to: CGPoint(x: cx + r1 * cosA, y: cy + r1 * sinA))
                p.addLine(to: CGPoint(x: cx + r2 * cosA, y: cy + r2 * sinA))
            }
            .stroke(Color.gold.opacity(0.55), lineWidth: 0.6)

            Circle()
                .fill(Color.gold.opacity(0.85))
                .frame(width: diameter * 0.015, height: diameter * 0.015)
                .position(x: cx + r2 * cosA, y: cy + r2 * sinA)

            // TODAY label — drawn just past the dot, oriented horizontally.
            Text("TODAY")
                .font(.system(size: diameter * 0.027))
                .tracking(2.6)
                .foregroundStyle(Color.gold.opacity(0.7))
                .position(x: cx + r3 * cosA, y: cy + r3 * sinA)
                .allowsHitTesting(false)
        }
    }

    // MARK: - Bindu

    private var bindu: some View {
        let scale: CGFloat = reduceMotion ? 1.0 : 1.0 + sin(binduPhase * .pi * 2) * 0.06
        return ZStack {
            // Outer glow disk
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.accentRed,
                            Color.accentRed.opacity(0.7),
                            Color.accentRed.opacity(0)
                        ]),
                        center: .center, startRadius: 0, endRadius: diameter * 0.045
                    )
                )
                .frame(width: diameter * 0.092, height: diameter * 0.092)
                .blur(radius: 2)
            // Cream core
            Circle()
                .fill(Color.cream)
                .frame(width: diameter * 0.035, height: diameter * 0.035)
                .shadow(color: Color.cream.opacity(0.6), radius: 6)
        }
        .scaleEffect(scale)
        .contentShape(Circle().path(in: CGRect(x: 0, y: 0, width: 64, height: 64)))
        .frame(width: 64, height: 64) // 44pt+ hit target around the visual bindu
        .onTapGesture {
            Haptics.light()
            onBinduTap?()
        }
    }

    // MARK: - Helpers

    private func shakti(at index: Int) -> Shakti {
        // Defensive: if a position is missing, return the closest available.
        if let exact = shaktis.first(where: { $0.position == index + 1 }) { return exact }
        return shaktis[index % shaktis.count]
    }

    private func startBreathing() {
        guard !reduceMotion else { return }
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: false)) {
            breathePhase = 1
        }
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: false)) {
            binduPhase = 1
        }
    }
}
