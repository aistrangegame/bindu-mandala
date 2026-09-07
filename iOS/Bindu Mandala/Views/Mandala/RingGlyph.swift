import SwiftUI

/// A 36pt bespoke glyph for one of the nine Avaraṇas — drawn for each crossing
/// in The Memory's descent film (`DescentFilmView`).
/// Square (1) · 16-rayed star (2) · 8-rayed star (3) · crossed triangles (4–7)
/// · downward triangle (8) · filled bindu (9).
struct RingGlyph: View {
    let ring: Int
    let color: Color
    var size: CGFloat = 36

    var body: some View {
        Canvas { ctx, frame in
            let cx = frame.width / 2
            let cy = frame.height / 2
            switch ring {
            case 1: drawBhupura(ctx: ctx, cx: cx, cy: cy)
            case 2: drawSixteenStar(ctx: ctx, cx: cx, cy: cy)
            case 3: drawEightStar(ctx: ctx, cx: cx, cy: cy)
            case 4, 5, 6, 7: drawCrossedTriangles(ctx: ctx, cx: cx, cy: cy)
            case 8: drawMulaTrikona(ctx: ctx, cx: cx, cy: cy)
            case 9: drawBindu(ctx: ctx, cx: cx, cy: cy)
            default: break
            }
        }
        .frame(width: size, height: size)
    }

    private func drawBhupura(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        let r: CGFloat = 13
        ctx.stroke(
            Path(CGRect(x: cx - r, y: cy - r, width: 2*r, height: 2*r)),
            with: .color(color), lineWidth: 1.0
        )
        // T-gate hints — short tick on each cardinal
        let g: CGFloat = 3
        for (x1, y1, x2, y2) in [
            (cx, cy - r - 2, cx, cy - r + g),
            (cx, cy + r - g, cx, cy + r + 2),
            (cx - r - 2, cy, cx - r + g, cy),
            (cx + r - g, cy, cx + r + 2, cy),
        ] {
            var p = Path()
            p.move(to: CGPoint(x: x1, y: y1))
            p.addLine(to: CGPoint(x: x2, y: y2))
            ctx.stroke(p, with: .color(color.opacity(0.7)), lineWidth: 0.8)
        }
    }

    private func drawSixteenStar(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        for i in 0..<16 {
            let theta = (Double(i) * 22.5 - 90) * .pi / 180
            var p = Path()
            p.move(to: CGPoint(x: cx + 7 * cos(theta), y: cy + 7 * sin(theta)))
            p.addLine(to: CGPoint(x: cx + 14 * cos(theta), y: cy + 14 * sin(theta)))
            ctx.stroke(p, with: .color(color), lineWidth: 0.9)
        }
        ctx.fill(
            Path(ellipseIn: CGRect(x: cx - 1.5, y: cy - 1.5, width: 3, height: 3)),
            with: .color(color)
        )
    }

    private func drawEightStar(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        for i in 0..<8 {
            let theta = (Double(i) * 45 - 90) * .pi / 180
            var p = Path()
            p.move(to: CGPoint(x: cx + 6 * cos(theta), y: cy + 6 * sin(theta)))
            p.addLine(to: CGPoint(x: cx + 14 * cos(theta), y: cy + 14 * sin(theta)))
            ctx.stroke(p, with: .color(color), lineWidth: 1.1)
        }
        ctx.fill(
            Path(ellipseIn: CGRect(x: cx - 1.5, y: cy - 1.5, width: 3, height: 3)),
            with: .color(color)
        )
    }

    private func drawCrossedTriangles(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        let R: CGFloat = 12.5
        let h = R * sqrt(3) / 2
        let half = R / 2

        var down = Path()
        down.move(to: CGPoint(x: cx, y: cy + R))
        down.addLine(to: CGPoint(x: cx + h, y: cy - half))
        down.addLine(to: CGPoint(x: cx - h, y: cy - half))
        down.closeSubpath()
        ctx.stroke(down, with: .color(color), lineWidth: 0.9)

        var up = Path()
        up.move(to: CGPoint(x: cx, y: cy - R))
        up.addLine(to: CGPoint(x: cx + h, y: cy + half))
        up.addLine(to: CGPoint(x: cx - h, y: cy + half))
        up.closeSubpath()
        ctx.stroke(up, with: .color(color), lineWidth: 0.9)
    }

    private func drawMulaTrikona(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        let R: CGFloat = 13.5
        let h = R * sqrt(3) / 2
        let half = R / 2

        var down = Path()
        down.move(to: CGPoint(x: cx, y: cy + R))
        down.addLine(to: CGPoint(x: cx + h, y: cy - half))
        down.addLine(to: CGPoint(x: cx - h, y: cy - half))
        down.closeSubpath()
        ctx.stroke(down, with: .color(color), lineWidth: 1.0)
    }

    private func drawBindu(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat) {
        let outerR: CGFloat = 9
        ctx.fill(
            Path(ellipseIn: CGRect(x: cx - outerR, y: cy - outerR, width: 2*outerR, height: 2*outerR)),
            with: .color(Color.accentRed.opacity(0.7))
        )
        let innerR: CGFloat = 3.5
        ctx.fill(
            Path(ellipseIn: CGRect(x: cx - innerR, y: cy - innerR, width: 2*innerR, height: 2*innerR)),
            with: .color(Color.cream)
        )
    }
}
