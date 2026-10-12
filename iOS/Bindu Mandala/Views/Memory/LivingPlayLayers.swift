import SwiftUI

// MARK: - Wave 6 · the Living Mandala's play-fed layers
//
// Claude Design's *Living Mandala* grew its layers from play: the bead ring
// from the Garland, a root web from the earth games, petals along the body's
// axis, a seed that blooms, a wheel of every practice. Here each layer is fed
// by the `Played` acts kept on the phone (`PlayTraceStore`) and drawn as a
// **state** — dormant (absent), or kindled with a warmth that cools by real
// time to an ember and never to nothing. No count anywhere; a hundred games
// and one game draw the same kindled layer, warmer only for being recent.
//
// Every layer is light and geometry, never a figure; every one goes into the
// exported Record with the rest of the artwork.

struct LivingPlayLayers: View {
    let traces: [PlayTrace]
    let diameter: CGFloat
    /// Ring of a seat (1–9) — for each bead's own light.
    var now: Date = .now

    var body: some View {
        Canvas { ctx, size in
            let half = min(size.width, size.height) / 2
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let scale = diameter / 344
            ctx.blendMode = .plusLighter

            // The root web — beneath the yantra, reaching down and in.
            let roots = PlayLayers.warmth(lastFed: PlayLayers.lastFed(.roots, traces: traces), now: now)
            if roots > 0 { drawRoots(&ctx, c: c, half: half, warmth: roots, scale: scale) }

            // The practice wheel — a spoke for every game, lit if it was played.
            if PlayLayers.lastFed(.wheel, traces: traces) != nil {
                drawWheel(&ctx, c: c, half: half, scale: scale)
            }

            // The body-map petals — places of light along the axis.
            let body = PlayLayers.warmth(lastFed: PlayLayers.lastFed(.body, traces: traces), now: now)
            if body > 0 { drawBodyPetals(&ctx, c: c, half: half, warmth: body, scale: scale) }

            // The seed bloom — round the point.
            let seed = PlayLayers.warmth(lastFed: PlayLayers.lastFed(.seed, traces: traces), now: now)
            if seed > 0 { drawSeed(&ctx, c: c, half: half, warmth: seed, scale: scale) }

            // The bead ring — the garland strung round the whole.
            let beads = PlayLayers.warmth(lastFed: PlayLayers.lastFed(.beads, traces: traces), now: now)
            if beads > 0 { drawBeads(&ctx, c: c, half: half, warmth: beads, scale: scale) }
        }
        .allowsHitTesting(false)
    }

    private func drawRoots(_ ctx: inout GraphicsContext, c: CGPoint, half: CGFloat,
                           warmth: Double, scale: CGFloat) {
        let colour = Color(red: 0.62, green: 0.42, blue: 0.24)
        for i in 0..<9 {
            let t = Double(i) / 8
            let startA = Double.pi / 2 + (t - 0.5) * 1.3
            var p = Path()
            let start = CGPoint(x: c.x + half * 0.9 * CGFloat(cos(startA)),
                                y: c.y + half * 0.9 * CGFloat(sin(startA)))
            p.move(to: start)
            let end = CGPoint(x: c.x + half * 0.42 * CGFloat(cos(startA + 0.25 * sin(Double(i)))),
                              y: c.y + half * 0.42 * CGFloat(sin(startA)))
            let ctrl = CGPoint(x: (start.x + end.x) / 2 + CGFloat(sin(Double(i) * 1.7)) * 18 * scale,
                               y: (start.y + end.y) / 2)
            p.addQuadCurve(to: end, control: ctrl)
            ctx.stroke(p, with: .color(colour.opacity(0.22 * warmth)),
                       style: StrokeStyle(lineWidth: 2.4 * scale, lineCap: .round))
            ctx.stroke(p, with: .color(colour.opacity(0.5 * warmth)),
                       style: StrokeStyle(lineWidth: 0.6 * scale, lineCap: .round))
        }
    }

    private func drawWheel(_ ctx: inout GraphicsContext, c: CGPoint, half: CGFloat, scale: CGFloat) {
        let spokes = PlayLayers.spokes(traces: traces)
        let inner = half * 0.30, outer = half * 0.37
        for (i, spoke) in spokes.enumerated() {
            let w = PlayLayers.warmth(lastFed: spoke.last, now: now)
            guard w > 0 else { continue }
            let a = 2 * Double.pi * Double(i) / Double(spokes.count) - Double.pi / 2
            var p = Path()
            p.move(to: CGPoint(x: c.x + inner * CGFloat(cos(a)), y: c.y + inner * CGFloat(sin(a))))
            p.addLine(to: CGPoint(x: c.x + outer * CGFloat(cos(a)), y: c.y + outer * CGFloat(sin(a))))
            let hue = LivingStrokesLayer.color(forRing: 1 + i % 9)
            ctx.stroke(p, with: .color(hue.opacity(0.7 * w)),
                       style: StrokeStyle(lineWidth: 1.0 * scale, lineCap: .round))
        }
    }

    private func drawBodyPetals(_ ctx: inout GraphicsContext, c: CGPoint, half: CGFloat,
                                warmth: Double, scale: CGFloat) {
        // Seven places along the axis, soles to crown — light, never a body.
        for k in 0..<7 {
            let y = c.y + half * CGFloat(0.62 - 0.2 * Double(k))
            let hue = LivingStrokesLayer.color(forRing: 1 + k)
            let r = 5.5 * scale
            var petal = Path()
            petal.move(to: CGPoint(x: c.x - r * 1.6, y: y))
            petal.addQuadCurve(to: CGPoint(x: c.x + r * 1.6, y: y), control: CGPoint(x: c.x, y: y - r * 1.4))
            petal.addQuadCurve(to: CGPoint(x: c.x - r * 1.6, y: y), control: CGPoint(x: c.x, y: y + r * 1.4))
            ctx.fill(petal, with: .color(hue.opacity(0.28 * warmth)))
        }
    }

    private func drawSeed(_ ctx: inout GraphicsContext, c: CGPoint, half: CGFloat,
                          warmth: Double, scale: CGFloat) {
        let colour = Color(red: 0.55, green: 0.85, blue: 0.55)
        let r = half * CGFloat(0.06 + 0.06 * warmth)
        for k in 0..<8 {
            let a = 2 * Double.pi * Double(k) / 8
            var p = Path()
            p.move(to: c)
            let tip = CGPoint(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a)))
            let l = CGPoint(x: c.x + r * 0.55 * CGFloat(cos(a - 0.45)), y: c.y + r * 0.55 * CGFloat(sin(a - 0.45)))
            let rr = CGPoint(x: c.x + r * 0.55 * CGFloat(cos(a + 0.45)), y: c.y + r * 0.55 * CGFloat(sin(a + 0.45)))
            p.addQuadCurve(to: tip, control: l)
            p.addQuadCurve(to: c, control: rr)
            ctx.fill(p, with: .color(colour.opacity(0.22 * warmth)))
        }
    }

    private func drawBeads(_ ctx: inout GraphicsContext, c: CGPoint, half: CGFloat,
                           warmth: Double, scale: CGFloat) {
        let touched = PlayLayers.beadSeats(traces: traces)
        let r = half * 0.945
        let total = KhadgamalaMap.total
        // The thread first: the garland is whole once it has been turned.
        let thread = Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: 2 * r, height: 2 * r))
        ctx.stroke(thread, with: .color(Color.gold.opacity(0.12 * warmth)), lineWidth: 0.4)
        for kp in 1...total {
            let a = 2 * Double.pi * Double(kp - 1) / Double(total) - Double.pi / 2
            let p = CGPoint(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a)))
            let held = touched.contains(kp)
            let hue = LivingStrokesLayer.color(forRing: KhadgamalaMap.ringNumber(forKhadgamala: kp))
            let core = (held ? 1.5 : 0.7) * scale
            if held {
                let g = 4 * scale
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - g, y: p.y - g, width: 2 * g, height: 2 * g)),
                         with: .radialGradient(Gradient(colors: [hue.opacity(0.5 * warmth), .clear]),
                                               center: p, startRadius: 0, endRadius: g))
            }
            ctx.fill(Path(ellipseIn: CGRect(x: p.x - core, y: p.y - core, width: 2 * core, height: 2 * core)),
                     with: .color(hue.opacity((held ? 0.9 : 0.3) * warmth)))
        }
    }
}
