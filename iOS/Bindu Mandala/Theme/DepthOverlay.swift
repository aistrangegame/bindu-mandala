import SwiftUI

/// The atmospheric depth pass — a soft elliptical vignette that sinks the edges
/// into the ground, plus a faint film grain so the flat gradients read as lit
/// space rather than screen. Ported from the prototype's `LrDepth`.
///
/// Drop it in *above* the atmosphere (background + sigil + motes) and *below* the
/// content. It never intercepts touches. One primitive lifts Today, Detail,
/// Field, and Portrait at once.
struct DepthOverlay: View {
    /// How dark the edges sink. 0.55 matches the prototype.
    var vignette: Double = 0.55
    /// Grain strength. Subtler than the web's 0.22 — Retina + overlay blend read
    /// stronger on-device.
    var grain: Double = 0.11

    var body: some View {
        ZStack {
            // Vignette — clear at the heart (~52%), sinking to near-black by the
            // edge. An ellipse so it hugs a portrait frame, centred a touch high.
            EllipticalGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.52),
                    .init(color: Color(red: 4 / 255, green: 1 / 255, blue: 3 / 255).opacity(vignette),
                          location: 1.0),
                ]),
                center: UnitPoint(x: 0.5, y: 0.46),
                startRadiusFraction: 0,
                endRadiusFraction: 0.82
            )
            FilmGrain(opacity: grain)
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

/// A static, deterministic film grain drawn once as a `Canvas` and blended in
/// `.overlay` so it lightens the lit areas and darkens the sunk ones — the same
/// role the prototype's fractal-noise SVG plays. Deterministic (a seeded LCG) so
/// it never shimmers between redraws.
private struct FilmGrain: View {
    var opacity: Double

    var body: some View {
        Canvas(rendersAsynchronously: true) { ctx, size in
            var rng: UInt64 = 0x9E3779B97F4A7C15
            func next() -> Double {
                rng = rng &* 6364136223846793005 &+ 1442695040888963407
                return Double(rng >> 40) / Double(1 << 24)   // 0…1
            }
            let step: CGFloat = 2.5
            var y: CGFloat = 0
            while y < size.height {
                var x: CGFloat = 0
                while x < size.width {
                    let v = next()
                    if v > 0.55 {
                        let a = (v - 0.55) / 0.45 * opacity
                        ctx.fill(Path(CGRect(x: x, y: y, width: 1, height: 1)),
                                 with: .color(.white.opacity(a)))
                    }
                    x += step
                }
                y += step
            }
        }
        .blendMode(.overlay)
        .allowsHitTesting(false)
    }
}
