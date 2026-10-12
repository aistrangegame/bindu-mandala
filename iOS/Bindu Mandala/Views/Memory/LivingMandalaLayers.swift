import SwiftUI

// MARK: - The Living Mandala's layers (Wave 5)
//
// The Portrait was a field that only he could light, by being with her. Wave 5
// lets his own hand into it: strokes drawn in a ring are mirrored by that ring,
// the year accretes round the rim at its own days, the gaps kept as space
// (Wave 6, C-1348), and the centre carries a
// live state. Every layer here is drawn from shapes — paths, circles and light —
// and every one of them goes into the exported Record with the rest.

/// His strokes, each mirrored n-fold by the ring it was begun in.
struct LivingStrokesLayer: View {
    let strokes: [PortraitStroke]
    /// The stroke under his finger right now, in unit coordinates.
    let live: [CGPoint]
    let diameter: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let half = min(size.width, size.height) / 2
            let centre = CGPoint(x: size.width / 2, y: size.height / 2)
            ctx.blendMode = .plusLighter
            for stroke in strokes {
                draw(stroke.points.map(\.cgPoint), ring: stroke.ring,
                     in: &ctx, centre: centre, half: half, alpha: 0.6)
            }
            if live.count > 1, let first = live.first {
                draw(live, ring: LivingMandala.ring(of: first),
                     in: &ctx, centre: centre, half: half, alpha: 0.95)
            }
        }
        .allowsHitTesting(false)
    }

    /// A ring's own hue, lifted so it carries on the night ground.
    static func color(forRing ring: Int) -> Color {
        let h = Atmosphere.ringHue(ring)
        return HSL(h: h.h, s: min(90, h.s + 10), l: max(58, h.l)).color()
    }

    private func draw(_ points: [CGPoint], ring: Int, in ctx: inout GraphicsContext,
                      centre: CGPoint, half: CGFloat, alpha: Double) {
        let colour = Self.color(forRing: ring)
        let width = max(0.6, 1.1 * diameter / 344)
        for copy in LivingMandala.copies(of: points, folds: LivingMandala.folds(forRing: ring)) {
            var path = Path()
            for (i, p) in copy.enumerated() {
                let q = CGPoint(x: centre.x + p.x * half, y: centre.y + p.y * half)
                if i == 0 { path.move(to: q) } else { path.addLine(to: q) }
            }
            ctx.stroke(path, with: .color(colour.opacity(alpha * 0.3)),
                       style: StrokeStyle(lineWidth: width * 4, lineCap: .round, lineJoin: .round))
            ctx.stroke(path, with: .color(colour.opacity(alpha)),
                       style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
        }
    }
}

/// One day he practised, as a bead on the year's rim, in that day's own light.
struct YearBead: Identifiable {
    let day: Date
    let color: Color
    var id: Date { day }
}

/// The year, accreting: one bead for every day he practised this year, at that
/// day's own place on the rim. Wave 6 (C-1348): the days between are kept as
/// space — never a slot, never a missing bead, never filled.
struct YearRingLayer: View {
    let beads: [YearBead]
    let diameter: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let half = min(size.width, size.height) / 2
            let centre = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = half * 0.977
            let scale = diameter / 344
            // Wave 6 (C-1348): each bead at its own day of the year, so the
            // days between stay as space — inhabited, never filled.
            for bead in beads {
                let a = LivingMandala.dayAngle(bead.day)
                let p = CGPoint(x: centre.x + r * CGFloat(cos(a)), y: centre.y + r * CGFloat(sin(a)))
                let glow = 4.5 * scale
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - glow, y: p.y - glow, width: glow * 2, height: glow * 2)),
                         with: .radialGradient(Gradient(colors: [bead.color.opacity(0.55), .clear]),
                                               center: p, startRadius: 0, endRadius: glow))
                let core = 1.4 * scale
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - core, y: p.y - core, width: core * 2, height: core * 2)),
                         with: .color(bead.color))
            }
        }
        .allowsHitTesting(false)
    }
}

/// Where his finger draws while the Portrait is open to him. A stroke is kept
/// in unit coordinates, so it is the same stroke on every screen and in the
/// Record.
struct StrokeCaptureLayer: View {
    let diameter: CGFloat
    @Binding var live: [CGPoint]
    let onLift: ([CGPoint]) -> Void

    var body: some View {
        Color.clear
            .frame(width: diameter, height: diameter)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        live.append(unit(value.location))
                    }
                    .onEnded { _ in
                        let points = live
                        live = []
                        onLift(points)
                    }
            )
            .accessibilityLabel("The Portrait, open to your hand. Draw into a ring and it is mirrored round her seats.")
    }

    private func unit(_ p: CGPoint) -> CGPoint {
        let half = diameter / 2
        return CGPoint(x: (p.x - half) / half, y: (p.y - half) / half)
    }
}

/// The centre's live state while a letter is sealed: the eye is closed. A lid
/// of light drawn across the point, the point itself dimmed beneath it — and it
/// opens again when the last sealed letter's day has come.
struct SealedLid: View {
    let diameter: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let w = 15 * diameter / 344
            var lid = Path()
            lid.move(to: CGPoint(x: c.x - w, y: c.y))
            lid.addQuadCurve(to: CGPoint(x: c.x + w, y: c.y), control: CGPoint(x: c.x, y: c.y + w * 0.75))
            ctx.stroke(lid, with: .color(Color.cream.opacity(0.75)),
                       style: StrokeStyle(lineWidth: 1.2, lineCap: .round))
            var upper = Path()
            upper.move(to: CGPoint(x: c.x - w, y: c.y))
            upper.addQuadCurve(to: CGPoint(x: c.x + w, y: c.y), control: CGPoint(x: c.x, y: c.y + w * 0.45))
            ctx.stroke(upper, with: .color(Color.gold.opacity(0.45)),
                       style: StrokeStyle(lineWidth: 0.8, lineCap: .round))
        }
        .frame(width: 44 * diameter / 344, height: 44 * diameter / 344)
        .allowsHitTesting(false)
    }
}
