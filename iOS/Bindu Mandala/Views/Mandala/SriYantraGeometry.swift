import SwiftUI

// MARK: - The full Śrī Yantra, in world space
//
// Wave 1 · Slice A. Design's `SriYantraGeometry()` (living-rite-mandala.jsx),
// restored element for element. The port that shipped drew three squares and
// nine triangles *stretched to the Bhūpura* — the triangles reached 0.99 of the
// outer square, so the whole star sat on top of both lotus rings and the gates,
// both lotuses and every inner circle were simply gone (The Reading §2.3).
//
// Design draws, inside one shimmering group:
//
//   · the Bhūpura — three nested squares (1.0 / 0.94 / 0.88 R, 1.1 wide,
//     0.5 / 0.4 / 0.3) and **four T-gates** cut into the outer square
//     (0.11 R half-width, 0.05 R deep, 1 wide, 0.45);
//   · **four circles** (0.90 / 0.80 / 0.70 / 0.615 R, 0.8 wide, 0.30 → 0.24);
//   · the **sixteen-petal lotus** between 0.80 R and 0.90 R (0.9 wide, 0.34);
//   · the **eight-petal lotus** between 0.615 R and 0.70 R, turned 22.5°
//     (0.9 wide, 0.36);
//   · the circle that holds the triangles, 0.60 R (1 wide, 0.4);
//   · the **nine interlocking triangles at 0.585 R** (1 wide, 0.5) — the true
//     proportion, inside the lotuses, not stretched to the square;
//   · the Bindu's red glow, 0.10 R, breathing.
//
// Everything here is a pure value computed once (`static let`), in world
// coordinates with the Bindu at the origin. The canvas maps each path to the
// screen with one affine transform per frame, so a drag costs a matrix
// multiply per layer and never a rebuild.

enum SriYantraGeometry {

    /// The yantra's radius in world units — the outer Bhūpura square.
    static var radius: CGFloat { MandalaWorld.radius }

    /// The triangles' true proportion of the yantra (Design: `SY_R * 0.585`).
    static let triangleProportion: CGFloat = 0.585

    // MARK: - One stroked layer

    /// One drawn element of the yantra: its path, the weight and strength
    /// Design gave it, and the āvaraṇa whose breath it keeps.
    struct Layer {
        let path: Path
        /// Design's stroke width, in world units (it scales with the camera,
        /// as an SVG stroke inside Design's scaled layer did).
        let width: CGFloat
        /// Design's opacity for this element — the true weight, with no
        /// dimmer stacked on it.
        let alpha: Double
        /// Āvaraṇa 1–9: whose breath this line keeps (see ``MandalaBreath``).
        let ring: Int
        /// What it is — read by the tone the time of day gives it.
        let kind: Kind
        /// How far from the Bindu the line runs on average, in world units —
        /// what the source's reach is read at when the light is on.
        let meanRadius: CGFloat
    }

    enum Kind: Equatable {
        case bhupura, gate, circle, lotus16, lotus8, triangle
    }

    // MARK: - The parts, as Design proportions them

    /// The three nested squares: fraction of R, width, opacity.
    static let squares: [(fraction: CGFloat, width: CGFloat, alpha: Double)] = [
        (1.00, 1.1, 0.5), (0.94, 1.1, 0.4), (0.88, 1.1, 0.3),
    ]

    /// The four circles: fraction of R and opacity (Design: `0.3 - i*0.02`),
    /// with the ring each bounds.
    static let circles: [(fraction: CGFloat, alpha: Double, ring: Int)] = [
        (0.90, 0.30, 2), (0.80, 0.28, 2), (0.70, 0.26, 3), (0.615, 0.24, 3),
    ]

    /// The gate's half-width and depth, as fractions of R.
    static let gateHalfWidth: CGFloat = 0.11
    static let gateDepth: CGFloat = 0.05

    // MARK: - Petals

    /// Design's `lrPetalPath`: a two-quadratic petal from `innerR` (its base)
    /// to `outerR` (its tip), its belly `halfWidthDeg` either side of its axis
    /// at 62% of the way out, pointing at `angleDeg` clockwise from 12 o'clock.
    static func petal(innerR: CGFloat, outerR: CGFloat,
                      halfWidthDeg: Double, angleDeg: Double) -> Path {
        let a = angleDeg * .pi / 180
        let w = halfWidthDeg * .pi / 180
        func at(_ r: CGFloat, _ angle: Double) -> CGPoint {
            CGPoint(x: r * CGFloat(sin(angle)), y: -r * CGFloat(cos(angle)))
        }
        let midR = innerR + (outerR - innerR) * 0.62
        var p = Path()
        p.move(to: at(innerR, a))
        p.addQuadCurve(to: at(outerR, a), control: at(midR, a - w))
        p.addQuadCurve(to: at(innerR, a), control: at(midR, a + w))
        p.closeSubpath()
        return p
    }

    /// The sixteen petals of the second enclosure, as one path.
    static let lotus16: Path = {
        let r = SriYantraGeometry.radius
        var p = Path()
        for i in 0..<16 {
            p.addPath(SriYantraGeometry.petal(innerR: r * 0.80, outerR: r * 0.90,
                            halfWidthDeg: 360.0 / 16.0 / 2.4,
                            angleDeg: Double(i) * 360.0 / 16.0))
        }
        return p
    }()

    /// The eight petals of the third enclosure, turned half a petal, as one path.
    static let lotus8: Path = {
        let r = SriYantraGeometry.radius
        var p = Path()
        for i in 0..<8 {
            p.addPath(SriYantraGeometry.petal(innerR: r * 0.615, outerR: r * 0.70,
                            halfWidthDeg: 360.0 / 8.0 / 2.5,
                            angleDeg: Double(i) * 360.0 / 8.0 + 22.5))
        }
        return p
    }()

    // MARK: - The Bhūpura's gates

    /// The four T-gates, as Design cuts them into the outer square: a notch
    /// `gateHalfWidth` either side of each cardinal, `gateDepth` deep.
    static let gates: Path = {
        let hg = SriYantraGeometry.radius
        let gw = SriYantraGeometry.radius * SriYantraGeometry.gateHalfWidth
        let gd = SriYantraGeometry.radius * SriYantraGeometry.gateDepth
        let directions: [(CGFloat, CGFloat)] = [(0, -1), (1, 0), (0, 1), (-1, 0)]
        var p = Path()
        for (dx, dy) in directions {
            let gx = dx * hg, gy = dy * hg
            let px: CGFloat = dy != 0 ? 1 : 0
            let py: CGFloat = dx != 0 ? 1 : 0
            p.move(to: CGPoint(x: gx - px * gw, y: gy - py * gw))
            p.addLine(to: CGPoint(x: gx - px * gw - dx * gd, y: gy - py * gw - dy * gd))
            p.addLine(to: CGPoint(x: gx + px * gw - dx * gd, y: gy + py * gw - dy * gd))
            p.addLine(to: CGPoint(x: gx + px * gw, y: gy + py * gw))
        }
        return p
    }()

    /// The mouths of the four gates in world space — where the canvas stands
    /// a soft light in each doorway.
    static let gateMouths: [CGPoint] = {
        let r = SriYantraGeometry.radius
        return [CGPoint(x: 0, y: -r), CGPoint(x: r, y: 0),
                CGPoint(x: 0, y: r), CGPoint(x: -r, y: 0)]
    }()

    // MARK: - Every stroked layer, outside in

    /// The whole yantra as stroked layers, outermost first. The triangles are
    /// ``MandalaYantra/triangles`` — one source for the star — each keeping the
    /// breath of the āvaraṇa it belongs to.
    static let layers: [Layer] = {
        let r = SriYantraGeometry.radius
        var out: [Layer] = []
        for sq in SriYantraGeometry.squares {
            let h = r * sq.fraction
            out.append(Layer(path: Path(CGRect(x: -h, y: -h, width: h * 2, height: h * 2)),
                             width: sq.width, alpha: sq.alpha, ring: 1, kind: .bhupura,
                             meanRadius: h * 1.15))
        }
        out.append(Layer(path: SriYantraGeometry.gates, width: 1, alpha: 0.45, ring: 1, kind: .gate,
                         meanRadius: r))
        for c in SriYantraGeometry.circles {
            let cr = r * c.fraction
            out.append(Layer(path: Path(ellipseIn: CGRect(x: -cr, y: -cr, width: cr * 2, height: cr * 2)),
                             width: 0.8, alpha: c.alpha, ring: c.ring, kind: .circle,
                             meanRadius: cr))
        }
        out.append(Layer(path: SriYantraGeometry.lotus16, width: 0.9, alpha: 0.34, ring: 2, kind: .lotus16,
                         meanRadius: r * 0.85))
        out.append(Layer(path: SriYantraGeometry.lotus8, width: 0.9, alpha: 0.36, ring: 3, kind: .lotus8,
                         meanRadius: r * 0.66))
        let hold = r * 0.60
        out.append(Layer(path: Path(ellipseIn: CGRect(x: -hold, y: -hold, width: hold * 2, height: hold * 2)),
                         width: 1, alpha: 0.4, ring: 4, kind: .circle, meanRadius: hold))
        for (i, tri) in MandalaYantra.triangles.enumerated() {
            var p = Path()
            p.move(to: tri.0)
            p.addLine(to: tri.1)
            p.addLine(to: tri.2)
            p.closeSubpath()
            let mean = (hypot(tri.0.x, tri.0.y) + hypot(tri.1.x, tri.1.y) + hypot(tri.2.x, tri.2.y)) / 3
            out.append(Layer(path: p, width: 1, alpha: 0.5,
                             ring: MandalaYantra.ring(ofTriangle: i), kind: .triangle,
                             meanRadius: mean))
        }
        return out
    }()

    /// The radius of the Bindu's red glow in world units (Design: `SY_R * 0.10`).
    static var binduGlowRadius: CGFloat { radius * 0.10 }
}

/// The interlocking triangles of the Śrī Yantra, as world-space vertex triples
/// (Bindu at origin). Ported from the prototype's `SY_DOWN` / `SY_UP`.
///
/// **At Design's true proportion, 0.585 of the yantra** (`syTriPaths(SY_R*0.585)`).
/// The first port multiplied by the full radius, which stretched the star out
/// to the Bhūpura and over both lotuses; the fractions below are Design's own,
/// unchanged — only the radius they are taken of is restored.
///
/// The type and the count are unchanged on purpose: `MandalaDrawCensus` reads
/// `triangles.count` (nine), and the star still has nine triangles.
enum MandalaYantra {
    /// The five Śakti (downward) triangles, outermost first: (topY, apexY, halfWidth).
    static let down: [(CGFloat, CGFloat, CGFloat)] = [
        (-0.30, 1.00, 0.98), (-0.48, 0.80, 0.80), (-0.64, 0.58, 0.62),
        (-0.79, 0.36, 0.45), (-0.91, 0.16, 0.29),
    ]
    /// The four Śiva (upward) triangles, outermost first: (botY, apexY, halfWidth).
    static let up: [(CGFloat, CGFloat, CGFloat)] = [
        (0.33, -0.99, 0.92), (0.51, -0.77, 0.75), (0.67, -0.55, 0.57), (0.81, -0.31, 0.41),
    ]

    static let triangles: [(CGPoint, CGPoint, CGPoint)] = {
        let r = MandalaWorld.radius * SriYantraGeometry.triangleProportion
        var out: [(CGPoint, CGPoint, CGPoint)] = []
        for t in MandalaYantra.down {
            out.append((CGPoint(x: -t.2 * r, y: t.0 * r),
                        CGPoint(x: t.2 * r, y: t.0 * r),
                        CGPoint(x: 0, y: t.1 * r)))
        }
        for t in MandalaYantra.up {
            out.append((CGPoint(x: -t.2 * r, y: t.0 * r),
                        CGPoint(x: t.2 * r, y: t.0 * r),
                        CGPoint(x: 0, y: t.1 * r)))
        }
        return out
    }()

    /// Which āvaraṇa a triangle keeps the breath of.
    ///
    /// `mandala-v2.jsx` breathes the triangle zone as four interlocked pairs —
    /// rings 4, 5, 6 and 7, each a down and an up of matching size — with the
    /// innermost downward triangle alone as ring 8, the mūla trikoṇa that holds
    /// the Bindu. In ``triangles`` the five downs come first (indices 0–4), then
    /// the four ups (5–8), each outermost first, so:
    /// down *i* → ring 4 + *i* (the fifth down → ring 8), up *i* → ring 4 + *i*.
    static func ring(ofTriangle index: Int) -> Int {
        if index < down.count { return index == down.count - 1 ? 8 : 4 + index }
        let u = index - down.count
        return 4 + min(max(u, 0), up.count - 1)
    }
}
