import SwiftUI

/// The element-shaped ground for any Śakti: her `groundDeep` with her `glow`
/// placed where her element lives — fire low, water pooled, air high-asymmetric,
/// ether pervasive, earth grounded, light central (ported from `lrBackdrop`).
/// Every atmosphere consumer (Today, Detail, Field, Portrait) can drop this in.
struct AtmosphereBackground: View {
    let atmosphere: Atmosphere

    var body: some View {
        GeometryReader { geo in
            let d = max(geo.size.width, geo.size.height)
            ZStack {
                atmosphere.groundDeep.ignoresSafeArea()
                RadialGradient(
                    gradient: Gradient(colors: [atmosphere.glow, .clear]),
                    center: glowCenter,
                    startRadius: 0,
                    endRadius: d * glowRadiusFraction
                )
                .ignoresSafeArea()
            }
        }
        .allowsHitTesting(false)
    }

    /// Where her light pools, by element.
    private var glowCenter: UnitPoint {
        switch atmosphere.element {
        case .fire:  return UnitPoint(x: 0.5,  y: 0.92)   // rises from below
        case .water: return UnitPoint(x: 0.5,  y: 0.74)   // pooled low
        case .air:   return UnitPoint(x: 0.72, y: 0.24)   // high, off-axis
        case .ether: return UnitPoint(x: 0.5,  y: 0.5)    // pervasive, centered
        case .earth: return UnitPoint(x: 0.5,  y: 0.84)   // grounded
        case .light: return UnitPoint(x: 0.5,  y: 0.44)   // the point
        }
    }

    /// Ether pervades widest; light concentrates; the rest sit between.
    private var glowRadiusFraction: Double {
        switch atmosphere.element {
        case .ether: return 0.95
        case .light: return 0.55
        case .air:   return 0.70
        default:     return 0.80
        }
    }
}
