import SwiftUI
import SwiftData

/// The sacred doorway. Tapping an Avaraṇa opens this nine-step reveal.
/// The territory names itself piece by piece, then the practitioner reads the
/// Personal Connection — Ash's own lived encounter — by scrolling.
///
/// Pushed onto the Field's navigation stack (`TheHundredTwoView`'s
/// `.navigationDestination(item:)`), so the native back swipe handles dismiss
/// without competing with the ScrollView. No sheet, no custom drag gestures.
struct AvaranaThresholdView: View {
    let avarana: Avarana
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var line1Visible = false
    @State private var line2Visible = false
    @State private var line3Visible = false
    @State private var line4Visible = false
    @State private var line5Visible = false
    @State private var line6Visible = false
    @State private var line7Visible = false
    @State private var connectionVisible = false
    @State private var chevronVisible = false

    private var ring: Int { avarana.ringNumber }
    private var isRing9: Bool { ring == 9 }
    /// Ring 9 — the deepest threshold — fades slower per brief.
    private var connectionDuration: Double { isRing9 ? 2.0 : 1.6 }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#060103"), Color.ground],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ThresholdBackground(ring: ring)
                .allowsHitTesting(false)

            ScrollView {
                VStack(spacing: 0) {
                    content
                        .padding(.top, 24)
                    connectionBlock
                        .padding(.top, 22)
                    HStack {
                        Spacer()
                        ChevronGlyph()
                            .opacity(chevronVisible ? 0.18 : 0)
                        Spacer()
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 36)
                }
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) { BottomScrollFade() }
        }
        .onAppear { revealCeremony() }
    }

    // MARK: - Top content (t-line-1 through t-line-7)

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(ordinal(ring)) Āvaraṇa · \(avarana.enclosureForm)".uppercased())
                    .font(.system(size: 11.5))
                    .tracking(2.4)
                    .foregroundStyle(Color.gold.opacity(0.75))
                Text("\(avarana.shaktiCount) śakti\(avarana.shaktiCount == 1 ? "" : "s")")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.5))
            }
            .fixedSize(horizontal: false, vertical: true)
            .opacity(line1Visible ? 1 : 0)
            .offset(y: line1Visible ? 0 : 7)
            .padding(.bottom, 12)

            Text(avarana.sanskritName)
                .font(.custom(AppFont.cormorant, size: 34))
                .tracking(2.7)
                .foregroundStyle(Color.gold)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(line1Visible ? 1 : 0)
                .offset(y: line1Visible ? 0 : 7)
                .padding(.bottom, 6)

            if let sub = avarana.subtitle, !sub.isEmpty {
                Text(sub)
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(0.5)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(line2Visible ? 1 : 0)
                    .offset(y: line2Visible ? 0 : 7)
                    .padding(.bottom, 18)

                Rectangle()
                    .fill(Color.gold.opacity(0.4))
                    .frame(width: 40, height: 0.5)
                    .opacity(line2Visible ? 1 : 0)
                    .offset(y: line2Visible ? 0 : 7)
                    .padding(.bottom, 20)
            }

            staggeredLine(text: avarana.geometricShape, visible: line3Visible,
                          font: .custom(AppFont.cormorant, size: 15),
                          color: Color.cream.opacity(0.82))

            staggeredLine(text: avarana.presidingForm, visible: line4Visible,
                          font: .custom(AppFont.cormorant, size: 14),
                          color: Color.cream.opacity(0.60))

            staggeredLine(text: avarana.yogini, visible: line5Visible,
                          font: .custom(AppFont.cormorantItalic, size: 13),
                          color: Color.cream.opacity(0.55))

            staggeredLine(text: avarana.mentalState, visible: line6Visible,
                          font: .custom(AppFont.cormorantItalic, size: 13),
                          color: Color.cream.opacity(0.55))

            staggeredLine(text: avarana.subtleBodyChakra, visible: line7Visible,
                          font: .custom(AppFont.cormorant, size: 12),
                          color: Color.gold.opacity(0.85),
                          tracking: 1.2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
    }

    @ViewBuilder
    private func staggeredLine(text: String?,
                                visible: Bool,
                                font: Font,
                                color: Color,
                                tracking: CGFloat = 0) -> some View {
        if let t = text, !t.isEmpty {
            Text(t)
                .font(font)
                .tracking(tracking)
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(visible ? 1 : 0)
                .offset(y: visible ? 0 : 7)
                .padding(.bottom, 12)
        }
    }

    // MARK: - Personal Connection (the readable body)

    private var connectionBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.gold.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: 0.5)
                .opacity(connectionVisible ? 1 : 0)
                .padding(.bottom, 22)

            if let conn = avarana.personalConnection, !conn.isEmpty {
                Text(conn)
                    .font(.custom(AppFont.cormorantItalic, size: 15.5))
                    .tracking(0.15)
                    .lineSpacing(11)
                    .foregroundStyle(Color.cream.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(connectionVisible ? 1 : 0)
                    .offset(y: connectionVisible ? 0 : 7)
            }

            // The gratitude offered on crossing this threshold.
            if !avarana.appreciationPhrase.isEmpty {
                Text("“\(avarana.appreciationPhrase)”")
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(0.3)
                    .lineSpacing(7)
                    .foregroundStyle(Color.gold)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(connectionVisible ? 1 : 0)
                    .offset(y: connectionVisible ? 0 : 7)
                    .padding(.top, 24)
            }
        }
        .padding(.horizontal, 32)
    }

    /// "First" … "Ninth" for the āvaraṇa kicker.
    private func ordinal(_ n: Int) -> String {
        let names = ["", "First", "Second", "Third", "Fourth", "Fifth",
                     "Sixth", "Seventh", "Eighth", "Ninth"]
        return (1...9).contains(n) ? names[n] : "\(n)th"
    }

    // MARK: - Reveal ceremony

    private func revealCeremony() {
        guard !reduceMotion else {
            line1Visible = true; line2Visible = true; line3Visible = true
            line4Visible = true; line5Visible = true; line6Visible = true
            line7Visible = true; connectionVisible = true; chevronVisible = true
            return
        }

        withAnimation(stagger(1.4, delay: 0.3)) { line1Visible = true }
        withAnimation(stagger(1.2, delay: 1.1)) { line2Visible = true }
        withAnimation(stagger(1.0, delay: 1.8)) { line3Visible = true }
        withAnimation(stagger(1.0, delay: 2.4)) { line4Visible = true }
        withAnimation(stagger(1.0, delay: 3.0)) { line5Visible = true }
        withAnimation(stagger(1.0, delay: 3.6)) { line6Visible = true }
        withAnimation(stagger(1.0, delay: 4.2)) { line7Visible = true }
        withAnimation(stagger(connectionDuration, delay: 5.6)) { connectionVisible = true }
        withAnimation(stagger(1.4, delay: 6.4)) { chevronVisible = true }
    }

    private func stagger(_ duration: Double, delay: Double) -> Animation {
        .timingCurve(0.25, 0.1, 0.25, 1.0, duration: duration).delay(delay)
    }
}

// MARK: - Chevron — the only affordance

private struct ChevronGlyph: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: 0))
            p.addLine(to: CGPoint(x: 10, y: 7))
            p.addLine(to: CGPoint(x: 20, y: 0))
        }
        .stroke(Color.cream,
                style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
        .frame(width: 22, height: 9)
    }
}

// MARK: - Background geometry

/// Faint geometric form filling the upper portion of the threshold screen.
/// Gold strokes at 4–5% opacity — a whisper of the ring's form. No animation.
private struct ThresholdBackground: View {
    let ring: Int

    var body: some View {
        switch ring {
        case 1: BhupuraBackground()
        case 2: Lotus16Background()
        case 3: LotusEightBackground()
        case 4: Tri14Background()
        case 5: TriStarBackground(downR: 70, upR: 62)
        case 6: TriStarBackground(downR: 54, upR: 46)
        case 7: VakChamberBackground()
        case 8: MulaTrikonaBackground()
        case 9: BinduPointBackground()
        default: Color.clear
        }
    }
}

// MARK: Ring 1 · Bhūpura

private struct BhupuraBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310
            let o: CGFloat = 161, i: CGFloat = 149, g: CGFloat = 11
            let col = Color.gold
            let style = StrokeStyle(lineWidth: 0.5, lineJoin: .miter)

            ctx.stroke(
                Path(CGRect(x: cx - o, y: cy - o, width: 2*o, height: 2*o)),
                with: .color(col), style: style
            )

            let segs: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx-i, cy-i, cx-g, cy-i), (cx+g, cy-i, cx+i, cy-i),
                (cx+i, cy-i, cx+i, cy-g), (cx+i, cy+g, cx+i, cy+i),
                (cx+i, cy+i, cx+g, cy+i), (cx-g, cy+i, cx-i, cy+i),
                (cx-i, cy+i, cx-i, cy+g), (cx-i, cy-g, cx-i, cy-i),
            ]
            let gates: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
                (cx-g, cy-i, cx-g, cy-o), (cx+g, cy-i, cx+g, cy-o),
                (cx-g, cy+i, cx-g, cy+o), (cx+g, cy+i, cx+g, cy+o),
                (cx-i, cy-g, cx-o, cy-g), (cx-i, cy+g, cx-o, cy+g),
                (cx+i, cy-g, cx+o, cy-g), (cx+i, cy+g, cx+o, cy+g),
            ]
            for (x1, y1, x2, y2) in segs + gates {
                var p = Path()
                p.move(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x2, y: y2))
                ctx.stroke(p, with: .color(col), style: style)
            }
        }
        .opacity(0.045)
    }
}

// MARK: Ring 2 · 16-petal lotus

private struct Lotus16Background: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310
            let oR: CGFloat = 147, iR: CGFloat = 116, hw: CGFloat = 28

            let c1y = -iR * 1.85
            let c2y = -oR * 0.85
            let c2x = hw * 0.95
            var petal = Path()
            petal.move(to: CGPoint(x: 0, y: -iR))
            petal.addCurve(to: CGPoint(x: 0, y: -oR),
                           control1: CGPoint(x: hw, y: c1y),
                           control2: CGPoint(x: c2x, y: c2y))
            petal.addCurve(to: CGPoint(x: 0, y: -iR),
                           control1: CGPoint(x: -c2x, y: c2y),
                           control2: CGPoint(x: -hw, y: c1y))
            petal.closeSubpath()

            ctx.translateBy(x: cx, y: cy)
            let base = ctx.transform
            for i in 0..<16 {
                ctx.rotate(by: .degrees(Double(i) * 22.5))
                ctx.stroke(petal, with: .color(Color.gold), lineWidth: 0.7)
                ctx.transform = base
            }
        }
        .opacity(0.045)
    }
}

// MARK: Ring 3 · 8-petal lotus

private struct LotusEightBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310
            let oR: CGFloat = 148, iR: CGFloat = 98, hw: CGFloat = 44

            let c1y = -iR * 1.85
            let c2y = -oR * 0.85
            let c2x = hw * 0.95
            var petal = Path()
            petal.move(to: CGPoint(x: 0, y: -iR))
            petal.addCurve(to: CGPoint(x: 0, y: -oR),
                           control1: CGPoint(x: hw, y: c1y),
                           control2: CGPoint(x: c2x, y: c2y))
            petal.addCurve(to: CGPoint(x: 0, y: -iR),
                           control1: CGPoint(x: -c2x, y: c2y),
                           control2: CGPoint(x: -hw, y: c1y))
            petal.closeSubpath()

            ctx.translateBy(x: cx, y: cy)
            let base = ctx.transform
            for angle in stride(from: 0.0, to: 360.0, by: 45.0) {
                ctx.rotate(by: .degrees(angle))
                ctx.stroke(petal, with: .color(Color.gold), lineWidth: 0.9)
                ctx.transform = base
            }

            let r1: CGFloat = iR + 4
            let r2: CGFloat = oR + 8
            ctx.stroke(
                Path(ellipseIn: CGRect(x: -r1, y: -r1, width: 2*r1, height: 2*r1)),
                with: .color(Color.gold), lineWidth: 0.5
            )
            ctx.stroke(
                Path(ellipseIn: CGRect(x: -r2, y: -r2, width: 2*r2, height: 2*r2)),
                with: .color(Color.gold), lineWidth: 0.4
            )
        }
        .opacity(0.045)
    }
}

// MARK: Ring 4 · 14 triangles (representational)

private struct Tri14Background: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310

            ctx.translateBy(x: cx, y: cy)
            for r in [145.0, 118.0, 94.0] {
                let R = CGFloat(r)
                let upR = R * 0.88
                ctx.stroke(triPath(R: R, up: false), with: .color(Color.gold), lineWidth: 0.8)
                ctx.stroke(triPath(R: upR, up: true), with: .color(Color.gold), lineWidth: 0.8)
            }
        }
        .opacity(0.045)
    }
}

// MARK: Rings 5 & 6 · interlocked triangle stars

/// Five downward and five upward triangles, rotated to form a ten-pointed
/// star reminiscent of Rings 5 and 6 of the Śrī Yantra.
private struct TriStarBackground: View {
    let downR: CGFloat
    let upR: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310

            ctx.translateBy(x: cx, y: cy)
            let base = ctx.transform
            for i in 0..<5 {
                let angle = Double(i) * 72.0
                ctx.rotate(by: .degrees(angle))
                ctx.stroke(triPath(R: downR, up: false),
                           with: .color(Color.gold), lineWidth: 0.7)
                ctx.transform = base
            }
            for i in 0..<5 {
                let angle = Double(i) * 72.0 + 36.0
                ctx.rotate(by: .degrees(angle))
                ctx.stroke(triPath(R: upR, up: true),
                           with: .color(Color.gold), lineWidth: 0.7)
                ctx.transform = base
            }
        }
        .opacity(0.045)
    }
}

// MARK: Ring 7 · Vāk Chamber

/// Eight radial points suggesting the eight Vāgdevatā positions, connected
/// by a faint ring arc.
private struct VakChamberBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310
            let R: CGFloat = 40        // Ring 7 radius (mandala-v2 d=40)
            let dotR: CGFloat = 2.5

            ctx.stroke(
                Path(ellipseIn: CGRect(x: cx - R, y: cy - R, width: 2*R, height: 2*R)),
                with: .color(Color.gold), lineWidth: 0.5
            )

            for i in 0..<8 {
                let angle = (Double(i) * 45.0 - 90.0) * .pi / 180
                let x = cx + R * cos(angle)
                let y = cy + R * sin(angle)
                ctx.fill(
                    Path(ellipseIn: CGRect(x: x - dotR, y: y - dotR,
                                           width: 2*dotR, height: 2*dotR)),
                    with: .color(Color.gold)
                )
            }
        }
        .opacity(0.045)
    }
}

// MARK: Ring 8 · Mūla Trikoṇa

private struct MulaTrikonaBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310

            ctx.translateBy(x: cx, y: cy)
            ctx.stroke(triPath(R: 24, up: false),
                       with: .color(Color.gold),
                       style: StrokeStyle(lineWidth: 0.6, lineJoin: .round))
        }
        .opacity(0.045)
    }
}

// MARK: Ring 9 · Bindu point

private struct BinduPointBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy: CGFloat = 310
            let r: CGFloat = 8

            ctx.stroke(
                Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2*r, height: 2*r)),
                with: .color(Color.gold), lineWidth: 0.6
            )
        }
        .opacity(0.045)
    }
}

// MARK: - Shared helpers

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
