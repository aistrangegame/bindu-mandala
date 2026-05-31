import SwiftUI
import SwiftData

/// Atmospheric seed for Rings 1, 4, 5, and 6.
///
/// Each shows: the ring's geometric form (upper area, faint gold), the
/// Avaraṇa's Sanskrit name and type, and the practitioner's Personal
/// Connection in a ScrollView. Held still — no animation. Presented as a sheet
/// with `.presentationDetents([.large])` so the native pull-down dismiss
/// coexists cleanly with the ScrollView's content scrolling.
struct RingWorldView: View {
    let ring: Int
    @Query private var avaranas: [Avarana]

    private var avarana: Avarana? {
        avaranas.first(where: { $0.ringNumber == ring })
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#020001"), Color(hex: "#060103")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    geometryArea
                        .frame(height: 280)
                        .padding(.top, 24)
                    titleBlock
                        .padding(.top, 8)
                    connectionBlock
                        .padding(.top, 20)
                        .padding(.bottom, 48)
                }
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) { BottomScrollFade() }
        }
    }

    // MARK: - Geometry (upper area, gold stroke at 4.5% opacity)

    @ViewBuilder
    private var geometryArea: some View {
        switch ring {
        case 1: BhupuraSeed()
        case 4: TriFourteenSeed()
        case 5: TriStarSeed(downR: 70, upR: 62, strokeWidth: 0.65)
        case 6: TriStarSeed(downR: 54, upR: 46, strokeWidth: 0.60)
        default: Color.clear
        }
    }

    // MARK: - Title block

    private var titleBlock: some View {
        VStack(spacing: 8) {
            Text(avarana?.sanskritName ?? fallbackLabel)
                .font(.custom(AppFont.cormorant, size: 22))
                .tracking(1.76)
                .foregroundStyle(Color.gold.opacity(0.70))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 32)

            if let label = ringTypeLabel {
                Text(label)
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(0.4)
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
        }
    }

    // MARK: - Personal Connection

    @ViewBuilder
    private var connectionBlock: some View {
        if let conn = avarana?.personalConnection, !conn.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.gold.opacity(0.20))
                    .frame(width: 36, height: 0.5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 20)
                Text(conn)
                    .font(.custom(AppFont.cormorantItalic, size: 15))
                    .tracking(0.15)
                    .lineSpacing(11)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Labels

    private var fallbackLabel: String {
        switch ring {
        case 1: return "1st Avaraṇa"
        case 2: return "2nd Avaraṇa"
        case 3: return "3rd Avaraṇa"
        default: return "\(ring)th Avaraṇa"
        }
    }

    private var ringTypeLabel: String? {
        switch ring {
        case 1: return "Bhūpura · the Ancient Ground"
        case 4: return "the Fourteen Triangles"
        case 5: return "the Ten Outer Triangles"
        case 6: return "the Ten Inner Triangles"
        default: return nil
        }
    }
}

// MARK: - Ring 1 · Bhūpura seed

private struct BhupuraSeed: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            // Scale to fill ~85% of the area, matching the brief's "fill top 35%".
            let outer = min(size.width, size.height) * 0.45
            let inner = outer * (149.0 / 161.0)
            let gate = outer * (11.0 / 161.0)
            let style = StrokeStyle(lineWidth: 1, lineJoin: .miter)
            let col = Color.gold

            ctx.stroke(
                Path(CGRect(x: cx - outer, y: cy - outer,
                            width: 2 * outer, height: 2 * outer)),
                with: .color(col), style: style
            )

            let segs: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx - inner, cy - inner, cx - gate, cy - inner),
                (cx + gate, cy - inner, cx + inner, cy - inner),
                (cx + inner, cy - inner, cx + inner, cy - gate),
                (cx + inner, cy + gate, cx + inner, cy + inner),
                (cx + inner, cy + inner, cx + gate, cy + inner),
                (cx - gate, cy + inner, cx - inner, cy + inner),
                (cx - inner, cy + inner, cx - inner, cy + gate),
                (cx - inner, cy - gate, cx - inner, cy - inner)
            ]
            let gates: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx - gate, cy - inner, cx - gate, cy - outer),
                (cx + gate, cy - inner, cx + gate, cy - outer),
                (cx - gate, cy + inner, cx - gate, cy + outer),
                (cx + gate, cy + inner, cx + gate, cy + outer),
                (cx - inner, cy - gate, cx - outer, cy - gate),
                (cx - inner, cy + gate, cx - outer, cy + gate),
                (cx + inner, cy - gate, cx + outer, cy - gate),
                (cx + inner, cy + gate, cx + outer, cy + gate)
            ]
            for (x1, y1, x2, y2) in segs + gates {
                var p = Path()
                p.move(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x2, y: y2))
                ctx.stroke(p, with: .color(col), style: style)
            }
        }
        .opacity(0.045)
        .allowsHitTesting(false)
    }
}

// MARK: - Ring 4 · Fourteen-triangle seed

private struct TriFourteenSeed: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            // Nested triangle pairs, sized to fill the area.
            let baseR = min(size.width, size.height) * 0.45
            ctx.translateBy(x: cx, y: cy)
            for fraction in [1.0, 0.81, 0.65] {
                let R = baseR * CGFloat(fraction)
                let upR = R * 0.88
                ctx.stroke(triPath(R: R, up: false),
                           with: .color(Color.gold),
                           style: StrokeStyle(lineWidth: 0.7, lineJoin: .round))
                ctx.stroke(triPath(R: upR, up: true),
                           with: .color(Color.gold),
                           style: StrokeStyle(lineWidth: 0.7, lineJoin: .round))
            }
        }
        .opacity(0.045)
        .allowsHitTesting(false)
    }
}

// MARK: - Rings 5 & 6 · ten-pointed star seed

private struct TriStarSeed: View {
    let downR: CGFloat
    let upR: CGFloat
    let strokeWidth: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            // Use the radii as a ratio of an area-fitting base. The mandala-v2
            // radii (e.g. 70/62) are tuned for a 344pt yantra; scale to fit
            // ~85% of whichever dimension is smaller.
            let baseSize: CGFloat = 87  // Ring 4 outer-most as reference
            let scale = min(size.width, size.height) * 0.45 / baseSize
            let scaledDown = downR * scale
            let scaledUp = upR * scale

            ctx.translateBy(x: cx, y: cy)
            let base = ctx.transform
            for i in 0..<5 {
                let angle = Double(i) * 72.0
                ctx.rotate(by: .degrees(angle))
                ctx.stroke(triPath(R: scaledDown, up: false),
                           with: .color(Color.gold),
                           style: StrokeStyle(lineWidth: strokeWidth, lineJoin: .round))
                ctx.transform = base
            }
            for i in 0..<5 {
                let angle = Double(i) * 72.0 + 36.0
                ctx.rotate(by: .degrees(angle))
                ctx.stroke(triPath(R: scaledUp, up: true),
                           with: .color(Color.gold),
                           style: StrokeStyle(lineWidth: strokeWidth, lineJoin: .round))
                ctx.transform = base
            }
        }
        .opacity(0.045)
        .allowsHitTesting(false)
    }
}

// MARK: - Shared triangle path

private func triPath(R: CGFloat, up: Bool) -> Path {
    let h = R * sqrt(3) / 2
    let half = R / 2
    var p = Path()
    if up {
        p.move(to: CGPoint(x: 0, y: -R))
        p.addLine(to: CGPoint(x: h, y: half))
        p.addLine(to: CGPoint(x: -h, y: half))
    } else {
        p.move(to: CGPoint(x: 0, y: R))
        p.addLine(to: CGPoint(x: h, y: -half))
        p.addLine(to: CGPoint(x: -h, y: -half))
    }
    p.closeSubpath()
    return p
}
