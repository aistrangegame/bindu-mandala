import SwiftUI

/// Body outline silhouette — used in Today variant V1 to anchor somatic awareness.
/// Vectorized from the Design/screens.jsx SVG.
struct BodyOutlineView: View {
    let clusterColor: Color
    var size: CGFloat = 90

    var body: some View {
        Canvas { context, canvasSize in
            let scale = canvasSize.width / 120
            context.translateBy(x: 0, y: 0)

            // Ambient skin glow
            let glow = Path(ellipseIn: CGRect(x: (60 - 48) * scale,
                                              y: (111 - 78) * scale,
                                              width: 96 * scale,
                                              height: 156 * scale))
            context.fill(glow, with: .radialGradient(
                Gradient(colors: [clusterColor.opacity(0.18), clusterColor.opacity(0)]),
                center: CGPoint(x: 60 * scale, y: 111 * scale),
                startRadius: 0,
                endRadius: 60 * scale
            ))

            // Stroked outline pieces
            let stroke = StrokeStyle(lineWidth: 1.2)
            func drawStroke(_ path: Path, opacity: Double) {
                context.stroke(path, with: .color(clusterColor.opacity(opacity)), style: stroke)
            }

            // Head
            let head = Path(ellipseIn: CGRect(x: (60 - 18) * scale, y: (23 - 21) * scale,
                                              width: 36 * scale, height: 42 * scale))
            drawStroke(head, opacity: 0.45)

            // Neck
            var neck = Path()
            neck.move(to: CGPoint(x: 52 * scale, y: 42 * scale))
            neck.addLine(to: CGPoint(x: 52 * scale, y: 52 * scale))
            neck.addQuadCurve(to: CGPoint(x: 68 * scale, y: 52 * scale),
                              control: CGPoint(x: 60 * scale, y: 56 * scale))
            neck.addLine(to: CGPoint(x: 68 * scale, y: 42 * scale))
            drawStroke(neck, opacity: 0.35)

            // Torso
            var torso = Path()
            torso.move(to: CGPoint(x: 52 * scale, y: 52 * scale))
            torso.addQuadCurve(to: CGPoint(x: 26 * scale, y: 68 * scale),
                               control: CGPoint(x: 32 * scale, y: 56 * scale))
            torso.addLine(to: CGPoint(x: 24 * scale, y: 130 * scale))
            torso.addQuadCurve(to: CGPoint(x: 34 * scale, y: 145 * scale),
                               control: CGPoint(x: 24 * scale, y: 142 * scale))
            torso.addLine(to: CGPoint(x: 46 * scale, y: 147 * scale))
            torso.addQuadCurve(to: CGPoint(x: 74 * scale, y: 147 * scale),
                               control: CGPoint(x: 60 * scale, y: 149 * scale))
            torso.addLine(to: CGPoint(x: 86 * scale, y: 145 * scale))
            torso.addQuadCurve(to: CGPoint(x: 96 * scale, y: 130 * scale),
                               control: CGPoint(x: 96 * scale, y: 142 * scale))
            torso.addLine(to: CGPoint(x: 94 * scale, y: 68 * scale))
            torso.addQuadCurve(to: CGPoint(x: 68 * scale, y: 52 * scale),
                               control: CGPoint(x: 88 * scale, y: 56 * scale))
            drawStroke(torso, opacity: 0.4)

            // Legs (left & right)
            var lleg = Path()
            lleg.move(to: CGPoint(x: 46 * scale, y: 147 * scale))
            lleg.addQuadCurve(to: CGPoint(x: 40 * scale, y: 192 * scale),
                              control: CGPoint(x: 42 * scale, y: 165 * scale))
            lleg.addQuadCurve(to: CGPoint(x: 46 * scale, y: 215 * scale),
                              control: CGPoint(x: 42 * scale, y: 216 * scale))
            lleg.addLine(to: CGPoint(x: 55 * scale, y: 155 * scale))
            drawStroke(lleg, opacity: 0.38)

            var rleg = Path()
            rleg.move(to: CGPoint(x: 74 * scale, y: 147 * scale))
            rleg.addQuadCurve(to: CGPoint(x: 80 * scale, y: 192 * scale),
                              control: CGPoint(x: 78 * scale, y: 165 * scale))
            rleg.addQuadCurve(to: CGPoint(x: 74 * scale, y: 215 * scale),
                              control: CGPoint(x: 78 * scale, y: 216 * scale))
            rleg.addLine(to: CGPoint(x: 65 * scale, y: 155 * scale))
            drawStroke(rleg, opacity: 0.38)
        }
        .frame(width: size, height: size * 1.85)
    }
}
