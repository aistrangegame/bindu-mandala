import SwiftUI

/// Her ring's geometry — `LrSigil`, at the brightness Design drew it.
///
/// **Wave 1 · the light comes home.** Every stroke in `LrSigil` is drawn at
/// `opacity={o * 1.7}`; the first port matched the `o`s and dropped the ×1.7,
/// then laid a 0.9 over the whole sigil. Every surface that wears this — the
/// Rite, Her Presence, Recognition, the Field's chips and rooms, the Well — was
/// therefore drawn at 0.53× Design before its own layer dimmed it again. Both
/// are gone: the ×1.7 is `strokeLift`, applied to every stroke, and nothing
/// inside the sigil dims it. A surface sets its own layer opacity (DayLight).
///
/// The geometry is Design's own, path for path: the Bhūpura's three squares
/// with their four T-gates in gold, the lotus petals as `lrPetalPath`'s
/// quadratic petals (the port had ellipses), the triangle rings alternating up
/// and down as `lrTriRingPaths` lays them, the root triangle, the point.
///
/// Beyond Design, light stands in the air: each stroke carries a soft halo of
/// itself, and the whole sigil is added onto the ground (`.plusLighter`), so
/// the lines read as light rather than as ink.
///
/// It turns once every `140 + hue mod 60` seconds, driven by one clock that
/// reduce motion pauses — live, mid-session.
struct RiteSigil: View {
    let atmosphere: Atmosphere
    let ring: Int
    let size: CGFloat
    let spin: Double            // +1 / -1
    /// Whether it turns at all (the Field's chips turn only when open).
    var spinning: Bool = true
    /// Design scales the whole SVG with CSS `transform: scale(s)`, so its
    /// strokes thicken with it. A surface that sizes the sigil up passes the
    /// same factor here.
    var lineScale: CGFloat = 1
    var halo: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `LrSigil`'s `opacity={o * 1.7}`.
    static let strokeLift: Double = 1.7

    /// A stroke's drawn opacity: Design's `o × 1.7`, never past full.
    static func lifted(_ o: Double) -> Double { min(1, o * strokeLift) }

    /// Seconds per turn (`lrSpinCW … ${140 + (atmo.hue.h % 60)}s`).
    static func period(hue: Double) -> Double { 140 + hue.truncatingRemainder(dividingBy: 60) }

    /// The turn at time `t`, degrees.
    static func turn(at t: TimeInterval, hue: Double, spin: Double) -> Double {
        let p = period(hue: hue)
        return (t / p).truncatingRemainder(dividingBy: 1) * 360 * spin
    }

    var body: some View {
        let still = !spinning || reduceMotion || AppRuntime.forcesReduceMotion
        TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: still)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            SigilArt(atmosphere: atmosphere, ring: ring, size: size,
                     lineScale: lineScale, halo: halo)
                .equatable()
                .rotationEffect(.degrees(atmosphere.rotation
                                         + Self.turn(at: t, hue: atmosphere.hue.h, spin: spin)))
                .blendMode(.plusLighter)
        }
        .frame(width: size, height: size)
        .allowsHitTesting(false)
    }
}

/// The drawing itself — Equatable so the clock that turns it never redraws it.
private struct SigilArt: View, Equatable {
    let atmosphere: Atmosphere
    let ring: Int
    let size: CGFloat
    let lineScale: CGFloat
    let halo: Bool

    var body: some View {
        let strokes = SigilGeometry.strokes(for: RiteGeometry.forRing(ring), size: size)
        let accent = atmosphere.accent
        let gold = Color.gold
        let w = lineScale
        Canvas { ctx, _ in
            ctx.blendMode = .plusLighter
            func draw(_ g: GraphicsContext, widen: CGFloat) {
                for s in strokes {
                    let color = s.gold ? gold : accent
                    g.stroke(s.path, with: .color(color.opacity(RiteSigil.lifted(s.opacity))),
                             lineWidth: s.width * w * widen)
                }
                if let dot = SigilGeometry.binduDot(for: RiteGeometry.forRing(ring), size: size) {
                    g.fill(dot, with: .color(accent.opacity(0.5)))
                }
            }
            if halo {
                ctx.drawLayer { layer in
                    layer.addFilter(.blur(radius: max(1.5, 2.6 * w)))
                    layer.opacity = 0.75
                    draw(layer, widen: 2.2)
                }
            }
            draw(ctx, widen: 1)
        }
        .frame(width: size, height: size)
    }
}

/// One stroke of the sigil: a path, Design's width and Design's `o`.
struct SigilStroke {
    let path: Path
    let width: CGFloat
    let opacity: Double
    let gold: Bool
}

/// `LrSigil`'s geometry, ported path for path. Pure — the stroke counts and
/// opacities per ring are asserted in `DayLightTests`.
enum SigilGeometry {

    static func strokes(for g: RiteGeometry, size S: CGFloat) -> [SigilStroke] {
        let c = S / 2
        var out: [SigilStroke] = []
        func add(_ p: Path, _ w: CGFloat, _ o: Double, gold: Bool = false) {
            out.append(SigilStroke(path: p, width: w, opacity: o, gold: gold))
        }

        switch g {
        case .square:
            for (i, f) in [0.94, 0.80, 0.66].enumerated() {
                let r = c * CGFloat(f)
                add(Path(CGRect(x: c - r, y: c - r, width: 2 * r, height: 2 * r)), 1, 0.30 - Double(i) * 0.06)
            }
            // The four T-gates on the middle square, in gold.
            let r = c * 0.80, gw = c * 0.12, gd = c * 0.10
            for (dx, dy) in [(0.0, -1.0), (0.0, 1.0), (-1.0, 0.0), (1.0, 0.0)] {
                let gx = c + CGFloat(dx) * r, gy = c + CGFloat(dy) * r
                let px: CGFloat = dy != 0 ? 1 : 0
                let py: CGFloat = dx != 0 ? 1 : 0
                var p = Path()
                p.move(to: CGPoint(x: gx - px * gw, y: gy - py * gw))
                p.addLine(to: CGPoint(x: gx - px * gw + CGFloat(dx) * gd, y: gy - py * gw + CGFloat(dy) * gd))
                p.move(to: CGPoint(x: gx + px * gw, y: gy + py * gw))
                p.addLine(to: CGPoint(x: gx + px * gw + CGFloat(dx) * gd, y: gy + py * gw + CGFloat(dy) * gd))
                add(p, 1, 0.26, gold: true)
            }

        case .lotus16, .lotus8:
            let n = g == .lotus16 ? 16 : 8
            for i in 0..<n {
                add(petal(c: c, innerR: c * 0.42, outerR: c * 0.88,
                          halfWidthDeg: 360 / Double(n) / 2.6, angleDeg: Double(i) * 360 / Double(n)),
                    1, 0.24)
            }
            add(polygon(c: c, r: c * 0.42, sides: 48, rotDeg: 0), 0.8, 0.20, gold: true)

        case .tri14, .tri10o, .tri10i:
            let n = g == .tri14 ? 14 : 10
            let ringR = g == .tri10i ? c * 0.52 : c * 0.66
            for p in triRing(c: c, r: ringR, n: n, triR: c * 0.14) { add(p, 1, 0.22) }
            add(polygon(c: c, r: ringR + c * 0.22, sides: 64, rotDeg: 0), 0.8, 0.16, gold: true)
            add(polygon(c: c, r: ringR - c * 0.22, sides: 64, rotDeg: 0), 0.8, 0.14, gold: true)

        case .tri8:
            for p in triRing(c: c, r: c * 0.5, n: 8, triR: c * 0.16) { add(p, 1, 0.24) }

        case .trikona:
            add(triangle(c: c, r: c * 0.72, up: false), 1.2, 0.34)
            add(triangle(c: c, r: c * 0.5, up: false), 1.0, 0.22)
            add(triangle(c: c, r: c * 0.3, up: false), 0.8, 0.16, gold: true)

        case .bindu:
            add(polygon(c: c, r: c * 0.62, sides: 72, rotDeg: 0), 1, 0.28)
            add(polygon(c: c, r: c * 0.44, sides: 72, rotDeg: 0), 0.8, 0.18, gold: true)
        }
        return out
    }

    /// The Bindu's filled point (`<circle r={5} opacity={0.5}>`), ring 9 only.
    static func binduDot(for g: RiteGeometry, size S: CGFloat) -> Path? {
        guard g == .bindu else { return nil }
        let c = S / 2
        return Path(ellipseIn: CGRect(x: c - 5, y: c - 5, width: 10, height: 10))
    }

    // MARK: Paths (`lrPolygonPath`, `lrTrianglePath`, `lrPetalPath`, `lrTriRingPaths`)

    static func polygon(c: CGFloat, r: CGFloat, sides: Int, rotDeg: Double, at center: CGPoint? = nil) -> Path {
        let o = center ?? CGPoint(x: c, y: c)
        let rot = rotDeg * .pi / 180
        var p = Path()
        for i in 0..<sides {
            let a = rot + Double(i) * 2 * .pi / Double(sides) - .pi / 2
            let pt = CGPoint(x: o.x + r * CGFloat(cos(a)), y: o.y + r * CGFloat(sin(a)))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }

    static func triangle(c: CGFloat, r: CGFloat, up: Bool, at center: CGPoint? = nil) -> Path {
        polygon(c: c, r: r, sides: 3, rotDeg: up ? 0 : 60, at: center)
    }

    static func petal(c: CGFloat, innerR: CGFloat, outerR: CGFloat,
                      halfWidthDeg: Double, angleDeg: Double) -> Path {
        let a = angleDeg * .pi / 180
        let w = halfWidthDeg * .pi / 180
        func at(_ r: CGFloat, _ ang: Double) -> CGPoint {
            CGPoint(x: c + r * CGFloat(sin(ang)), y: c - r * CGFloat(cos(ang)))
        }
        let tip = at(outerR, a)
        let base = at(innerR, a)
        let midR = innerR + (outerR - innerR) * 0.62
        var p = Path()
        p.move(to: base)
        p.addQuadCurve(to: tip, control: at(midR, a - w))
        p.addQuadCurve(to: base, control: at(midR, a + w))
        p.closeSubpath()
        return p
    }

    /// A ring of `n` triangles, alternating up and down, unrotated.
    static func triRing(c: CGFloat, r: CGFloat, n: Int, triR: CGFloat) -> [Path] {
        (0..<n).map { i in
            let a = Double(i) * 2 * .pi / Double(n) - .pi / 2
            let pt = CGPoint(x: c + r * CGFloat(cos(a)), y: c + r * CGFloat(sin(a)))
            return triangle(c: c, r: triR, up: i % 2 == 0, at: pt)
        }
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
