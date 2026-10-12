import SwiftUI

/// The ground the yantra floats in: Design's **indigo night sky**, restored.
///
/// `living-rite-mandala.jsx` lays two gradients under the field —
///
///     radial-gradient(ellipse 80% 55% at 50% 44%, ${dayAtmo.glow}, transparent 66%),
///     radial-gradient(circle at 50% 44%, #0a0611, #050308 60%, #030105)
///
/// — an indigo well lit by the day's own glow. The port that shipped painted the
/// crimson-black `Color.ground` instead, with one glow on it, and the sky went
/// red-brown (The Reading §2.3). This is the sky again, with the hour in it
/// (``TimeVariant/sky``, and `TIME_VARIANTS.ambient` — dawn's low warm light,
/// dusk's rose from above, night's silver, the new moon's red heart) and, going
/// beyond Design, two far washes of air either side of the yantra so the field
/// has depth to float in rather than a flat floor to sit on.
///
/// It is still and draws nothing a finger can reach; the stars and motes are in
/// the canvas, where they move with the camera and the clock.
struct MandalaSky: View {
    let variant: TimeVariant
    /// The day's own glow — today's Śakti's `Atmosphere.glow`.
    let dayGlow: Color

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            let h = max(geo.size.height, 1)
            let sky = variant.sky
            let ambient = variant.ambient
            ZStack {
                sky.edge
                // The indigo well: #0a0611 at the heart, #050308 by 60%, #030105 at the rim.
                RadialGradient(stops: [
                                   .init(color: sky.center, location: 0),
                                   .init(color: sky.mid, location: 0.6),
                                   .init(color: sky.edge, location: 1),
                               ],
                               center: UnitPoint(x: 0.5, y: 0.44),
                               startRadius: 0, endRadius: max(w, h) * 0.78)

                // Far air — two faint washes standing off the yantra's shoulders.
                glow(sky.air.opacity(0.32), rx: w * 0.75, ry: h * 0.32,
                     at: CGPoint(x: w * 0.18, y: h * 0.22), fade: 0.9)
                glow(sky.air.opacity(0.24), rx: w * 0.7, ry: h * 0.3,
                     at: CGPoint(x: w * 0.86, y: h * 0.74), fade: 0.9)

                // The hour's ambient light (`TIME_VARIANTS.ambient`, transparent by ~70%).
                glow(ambient.inner,
                     rx: w * CGFloat(ambient.widthFraction), ry: h * CGFloat(ambient.heightFraction),
                     at: CGPoint(x: w * ambient.center.x, y: h * ambient.center.y), fade: 0.7)

                // The day's glow: an ellipse 80% × 55% at (50%, 44%), gone by 66%.
                glow(dayGlow, rx: w * 0.8, ry: h * 0.55,
                     at: CGPoint(x: w * 0.5, y: h * 0.44), fade: 0.66)
            }
            .frame(width: w, height: h)
            .clipped()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// A CSS `radial-gradient(ellipse rx ry at x y, color, transparent fade)`:
    /// an elliptical light of radii `rx` × `ry` centred at `at`, reaching
    /// nothing at `fade` of its radius.
    private func glow(_ color: Color, rx: CGFloat, ry: CGFloat, at: CGPoint, fade: CGFloat) -> some View {
        Rectangle()
            .fill(EllipticalGradient(stops: [
                                         .init(color: color, location: 0),
                                         .init(color: color.opacity(0), location: 1),
                                     ],
                                     center: .center,
                                     startRadiusFraction: 0,
                                     endRadiusFraction: 0.5 * fade))
            .frame(width: max(rx * 2, 1), height: max(ry * 2, 1))
            .position(at)
    }
}
