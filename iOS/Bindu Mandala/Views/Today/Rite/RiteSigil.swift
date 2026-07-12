import SwiftUI

/// Her ring's geometry as a large, faint, slowly-spinning backdrop — element-lit
/// through the Atmosphere. A recognizable abstraction of the āvaraṇa's form
/// (Bhūpura square → lotus → triangle rings → mūla trikoṇa → bindu), ported in
/// spirit from `LrSigil`. Drawn once as a `Canvas`, rotated by the Śakti's stable
/// `rotation`, and spun so the same energy still breathes with life.
struct RiteSigil: View {
    let atmosphere: Atmosphere
    let ring: Int
    let size: CGFloat
    let spin: Double            // +1 / -1
    var reduceMotion: Bool = false

    @State private var angle: Double = 0

    private var accent: Color { atmosphere.accent }

    var body: some View {
        Canvas { ctx, sz in draw(into: ctx, size: sz) }
            .frame(width: size, height: size)
            .rotationEffect(.degrees(atmosphere.rotation + angle))
            .opacity(0.9)
            .onAppear {
                guard !reduceMotion else { return }
                let period = 140.0 + atmosphere.hue.h.truncatingRemainder(dividingBy: 60)
                withAnimation(.linear(duration: period).repeatForever(autoreverses: false)) {
                    angle = 360 * spin
                }
            }
    }

    private func draw(into ctx: GraphicsContext, size sz: CGSize) {
        let c = min(sz.width, sz.height) / 2
        switch RiteGeometry.forRing(ring) {
        case .square:
            for (i, f) in [0.94, 0.80, 0.66].enumerated() {
                let r = c * f
                let rect = CGRect(x: c - r, y: c - r, width: 2 * r, height: 2 * r)
                ctx.stroke(Path(rect), with: .color(accent.opacity(0.30 - Double(i) * 0.06)), lineWidth: 1)
            }
        case .lotus16, .lotus8:
            let n = (RiteGeometry.forRing(ring) == .lotus16) ? 16 : 8
            let pr = c * 0.62, pw = c * 0.16, ph = c * 0.5
            for i in 0..<n {
                var p = ctx
                p.translateBy(x: c, y: c)
                p.rotate(by: .degrees(Double(i) / Double(n) * 360))
                p.translateBy(x: 0, y: -pr)
                let petal = Path(ellipseIn: CGRect(x: -pw / 2, y: -ph / 2, width: pw, height: ph))
                p.stroke(petal, with: .color(accent.opacity(0.24)), lineWidth: 1)
            }
            ring(ctx, c: c, r: c * 0.42, color: .gold, opacity: 0.20)
        case .tri14, .tri10o, .tri10i:
            let g = RiteGeometry.forRing(ring)
            let n = (g == .tri14) ? 14 : 10
            let ringR = (g == .tri10i) ? c * 0.52 : c * 0.66
            triRing(ctx, c: c, ringR: ringR, n: n, tri: c * 0.14)
            ring(ctx, c: c, r: ringR + c * 0.22, color: .gold, opacity: 0.16)
            ring(ctx, c: c, r: ringR - c * 0.22, color: .gold, opacity: 0.14)
        case .tri8:
            triRing(ctx, c: c, ringR: c * 0.5, n: 8, tri: c * 0.16)
        case .trikona:
            for (i, f) in [0.72, 0.5, 0.3].enumerated() {
                downTriangle(ctx, c: c, r: c * f,
                             color: i == 2 ? .gold : accent,
                             opacity: [0.34, 0.22, 0.16][i], width: [1.2, 1.0, 0.8][i])
            }
        case .bindu:
            ring(ctx, c: c, r: c * 0.62, color: accent, opacity: 0.28)
            ring(ctx, c: c, r: c * 0.44, color: .gold, opacity: 0.18)
            let dot = Path(ellipseIn: CGRect(x: c - 5, y: c - 5, width: 10, height: 10))
            ctx.fill(dot, with: .color(accent.opacity(0.5)))
        }
    }

    private func ring(_ ctx: GraphicsContext, c: CGFloat, r: CGFloat, color: Color, opacity: Double) {
        ctx.stroke(Path(ellipseIn: CGRect(x: c - r, y: c - r, width: 2 * r, height: 2 * r)),
                   with: .color(color.opacity(opacity)), lineWidth: 0.8)
    }

    private func triRing(_ ctx: GraphicsContext, c: CGFloat, ringR: CGFloat, n: Int, tri: CGFloat) {
        for i in 0..<n {
            var p = ctx
            p.translateBy(x: c, y: c)
            p.rotate(by: .degrees(Double(i) / Double(n) * 360))
            p.translateBy(x: 0, y: -ringR)
            var path = Path()
            path.move(to: CGPoint(x: 0, y: -tri))
            path.addLine(to: CGPoint(x: -tri * 0.72, y: tri * 0.5))
            path.addLine(to: CGPoint(x: tri * 0.72, y: tri * 0.5))
            path.closeSubpath()
            p.stroke(path, with: .color(accent.opacity(0.22)), lineWidth: 1)
        }
    }

    private func downTriangle(_ ctx: GraphicsContext, c: CGFloat, r: CGFloat, color: Color, opacity: Double, width: CGFloat) {
        var path = Path()
        path.move(to: CGPoint(x: c, y: c + r))                        // apex down
        path.addLine(to: CGPoint(x: c - r * 0.866, y: c - r * 0.5))
        path.addLine(to: CGPoint(x: c + r * 0.866, y: c - r * 0.5))
        path.closeSubpath()
        ctx.stroke(path, with: .color(color.opacity(opacity)), lineWidth: width)
    }
}

/// The āvaraṇa geometry per ring (from the AVARANAS data).
enum RiteGeometry {
    case square, lotus16, lotus8, tri14, tri10o, tri10i, tri8, trikona, bindu

    static func forRing(_ ring: Int) -> RiteGeometry {
        switch ring {
        case 1: return .square
        case 2: return .lotus16
        case 3: return .lotus8
        case 4: return .tri14
        case 5: return .tri10o
        case 6: return .tri10i
        case 7: return .tri8
        case 8: return .trikona
        case 9: return .bindu
        default: return .lotus16
        }
    }
}
