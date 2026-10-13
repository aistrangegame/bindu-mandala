import SwiftUI

// MARK: - Upgrade U1 · A · the crossing, drawn
//
// `waves/upgrade/worlds/spine-and-home.md` §2 H #55 (through the point,
// blooming from the touch in the colour of the world entered), #56 (the
// Descent), #57 (the blink), G #52 (the return bloom). Drawn above the one
// mounted world, never hit-testable, gone when the crossing settles. Silent
// (#55); haptics arrive with Part D's library in U2. The other kinds of the
// library are drawn as the bloom until their worlds build them.

/// The figure of one crossing — `spine-and-home.md` §2 H #55–#57, G #52.
struct CrossingOverlay: View {
    let flight: CrossingInFlight

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { ctx in
                figure(elapsed: flight.elapsed(at: ctx.date), size: geo.size)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var colour: Color { Color(hex: flight.colourHex) }

    @ViewBuilder
    private func figure(elapsed e: Double, size: CGSize) -> some View {
        let t = flight.timing
        if e >= t.total {
            Color.clear
        } else if t.isReduced {
            // Reduced motion: a .2 s cross-fade in the destination's colour.
            colour.opacity(0.6 * (1 - abs(2 * e / t.total - 1)))
        } else {
            switch flight.crossing.kind {
            case .descent:
                descent(p: e / t.total, size: size)
            case .blink:
                blink(elapsed: e, size: size)
            case .returnBloom:
                colour.opacity(1 - t.curve.value(at: e / t.total))
            case .dissolve:
                Color.clear
            case .bloom, .veilLight, .veilDark, .passage, .pulseGate, .spanda, .pravesha:
                bloom(elapsed: e, size: size)
            }
        }
    }

    /// #55: after the gather, a radial in the destination's colour opens from
    /// the touch to 2.6 × the larger side.
    private func bloom(elapsed e: Double, size: CGSize) -> some View {
        let t = flight.timing
        let span = max(0.0001, t.total - t.gather)
        let p = min(1, max(0, (e - t.gather) / span))
        let side = max(size.width, size.height)
        let d = side * CGFloat(Crossing.bloomReach)
        let origin = flight.crossing.origin ?? CGPoint(x: size.width / 2, y: size.height * 0.46)
        let stops = Crossing.bloomFillStops.map {
            Gradient.Stop(color: colour.opacity($0.opacity), location: $0.location)
        }
        return Circle()
            .fill(RadialGradient(gradient: Gradient(stops: stops), center: .center,
                                 startRadius: 0, endRadius: d / 2))
            .frame(width: d, height: d)
            .scaleEffect(Crossing.bloomScale.value(at: p))
            .opacity(e < t.gather ? 0 : Crossing.bloomOpacity.value(at: p))
            .position(origin)
    }

    /// #56: the dark plane wells up from below to the seam at 55 %, an ember
    /// crosses it, and the dark gives way to the world beneath.
    private func descent(p: Double, size: CGSize) -> some View {
        let eased = Crossing.Curve.descent.value(at: p)
        let hexes = Crossing.descentPlaneHexes
        let plane = RadialGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: Color(hex: hexes[0]), location: 0),
                Gradient.Stop(color: Color(hex: hexes[1]), location: 0.55),
                Gradient.Stop(color: Color(hex: hexes[2]), location: 1),
            ]),
            center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0,
            endRadius: max(size.width, size.height) * 0.75)
        let fade = p <= Crossing.descentSeam ? 1 : 1 - (p - Crossing.descentSeam) / (1 - Crossing.descentSeam)
        let ember = Color(hex: Crossing.descentEmberHex)
        return ZStack {
            Rectangle()
                .fill(plane)
                .offset(y: size.height * CGFloat(Crossing.descentPlaneOffset.value(at: eased)))
                .opacity(fade)
            Circle()
                .fill(ember)
                .frame(width: Crossing.descentEmberPoints, height: Crossing.descentEmberPoints)
                .shadow(color: ember.opacity(0.6), radius: 6)
                .shadow(color: ember.opacity(0.3), radius: 16)
                .scaleEffect(Crossing.descentEmberScale.value(at: p))
                .opacity(Crossing.descentEmberOpacity.value(at: p) * fade)
                .position(x: size.width / 2, y: size.height * 0.46)
        }
    }

    /// #57: the lids close over .66 s, the seam glints in the destination's
    /// colour, the Rite opens at 780 ms and the lids part again.
    private func blink(elapsed e: Double, size: CGSize) -> some View {
        let close = Crossing.Curve.blinkLids.value(at: e / Crossing.blinkLidSeconds)
        let reopen = e <= Crossing.blinkOpenSeconds ? 0
            : Crossing.Curve.blinkLids.value(at: (e - Crossing.blinkOpenSeconds) / Crossing.blinkLidSeconds)
        let lid = size.height * 0.5 * CGFloat(close * (1 - reopen))
        let glint = Keyframes([(Crossing.blinkGlintDelay, 0),
                               (Crossing.blinkGlintDelay + Crossing.blinkGlintSeconds / 2, 1),
                               (Crossing.blinkGlintDelay + Crossing.blinkGlintSeconds, 0)]).value(at: e)
        let dark = Color(hex: Crossing.descentPlaneHexes[2])
        return ZStack {
            VStack(spacing: 0) {
                dark.frame(height: lid)
                Spacer(minLength: 0)
                dark.frame(height: lid)
            }
            Rectangle()
                .fill(colour)
                .frame(width: size.width * 0.6, height: 1)
                .shadow(color: colour, radius: 6)
                .opacity(glint)
                .position(x: size.width / 2, y: size.height / 2)
        }
    }
}
