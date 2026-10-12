import SwiftUI

/// The element-shaped ground for any Śakti — `lrBackdrop`, layer for layer.
///
/// Design lit each element with two or three lights of its own shape: fire a
/// low wide updraft *and* a faint crown of her colour above, water a soft pool
/// below the floor, air one tall lamp off to the side of a slanted ground,
/// ether two concentric lights pervading the middle, earth a long low band,
/// light a hot point whose core is her colour and whose halo is her glow. The
/// first port kept one round radial gradient for all six; this draws every
/// layer the JSX wrote (`Backdrop.layers(for:flipLeft:)`), with the lights
/// added onto the ground rather than painted over it.
///
/// Beyond Design: the lights breathe. Her element's own response tempo
/// (`LR_RECOG`'s `respDur`, doubled to suit a ground) slowly widens and
/// narrows their reach. The ground never moves; reduce motion stills the
/// breath on the next frame.
///
/// Every atmosphere consumer (Today, Detail, the threshold) drops this in.
struct AtmosphereBackground: View {
    let atmosphere: Atmosphere
    /// The composition's `_flipLeft` — which side air's lamp stands on.
    var flipLeft: Bool = false
    var breathes: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let layers = Backdrop.layers(for: atmosphere, flipLeft: flipLeft)
        let ground = layers.filter { !$0.isLight }
        let lights = layers.filter { $0.isLight }
        let still = !breathes || reduceMotion || AppRuntime.forcesReduceMotion
        let period = Self.breathPeriod(atmosphere.element)
        let anchor = Self.lightCenter(of: lights)

        ZStack {
            LightField(layers: ground)
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: still)) { context in
                let b = still ? 0 : FieldBreath.phase(at: context.date.timeIntervalSinceReferenceDate,
                                                      period: period)
                LightField(layers: lights)
                    .equatable()
                    .scaleEffect(1 + 0.05 * b, anchor: anchor)
                    .blendMode(.plusLighter)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    /// Her element's breath, in seconds — `LR_RECOG[element].respDur` × 2.
    static func breathPeriod(_ e: Element) -> Double {
        switch e {
        case .fire:  return 11.0
        case .water: return 13.0
        case .air:   return 12.0
        case .ether: return 9.6
        case .earth: return 15.0
        case .light: return 7.6
        }
    }

    /// Where the principal light stands, so the breath swells from it.
    static func lightCenter(of lights: [LightLayer]) -> UnitPoint {
        guard let last = lights.last else { return .center }
        switch last {
        case .ellipse(let c, _, _, _), .circle(let c, _), .shade(let c, _, _, _):
            return c
        case .linear, .fill:
            return .center
        }
    }
}
