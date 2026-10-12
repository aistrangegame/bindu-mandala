import SwiftUI
import UIKit

// MARK: - The ceremony's light
//
// Light standing in the air, in her nature. Everything here is geometry and
// glow — gradients, rings, rays, a point — and none of it is a figure of her
// (Law 4 in its true form: light is welcome, a depiction is not). Additive
// light (`.plusLighter`) is how a glow stands *in* the air rather than being
// painted on the ground under it.
//
// Every repeating motion here is gated on reduce motion: under it, each
// nature is its still light, the ripples do not travel, and the answer at
// Act 2 is the light lifting, not moving.

// MARK: Backdrop — where the light lives on the glass

/// The ceremony's ground, layer for layer: the deepening night, her glow at
/// the nature's focal (Design's ceremony gradient, 105% × 72%), and the
/// nature's own second light from `lrBackdrop`.
struct RecognitionBackdrop: View {
    let atmosphere: Atmosphere
    let nature: RecognitionNature

    static let night = Color(red: 5/255, green: 2/255, blue: 3/255)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(colors: [atmosphere.groundDeep, Self.night],
                               startPoint: .top, endPoint: .bottom)
                Self.ellipse([Gradient.Stop(color: atmosphere.glow, location: 0),
                              Gradient.Stop(color: .clear, location: 0.74)],
                             width: w * 1.05 * 2, height: h * 0.72 * 2)
                    .position(x: w * 0.5, y: h * CGFloat(nature.glowY))
                secondLight(w: w, h: h)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// One CSS `radial-gradient(ellipse …)`: a box the size of the ellipse's
    /// diameters, filled from its centre to its rim.
    static func ellipse(_ stops: [Gradient.Stop], width: CGFloat, height: CGFloat) -> some View {
        Rectangle()
            .fill(EllipticalGradient(gradient: Gradient(stops: stops), center: .center,
                                     startRadiusFraction: 0, endRadiusFraction: 0.5))
            .frame(width: max(width, 1), height: max(height, 1))
    }

    @ViewBuilder
    private func secondLight(w: CGFloat, h: CGFloat) -> some View {
        switch nature {
        case .flare:
            // a faint answering light at the top of the glass
            Self.ellipse([Gradient.Stop(color: atmosphere.accentFaint, location: 0),
                          Gradient.Stop(color: .clear, location: 0.6)],
                         width: w * 1.2 * 2, height: h * 0.4 * 2)
                .position(x: w * 0.5, y: h * -0.10)
        case .pool:
            // the water's own light, low and wide
            Self.ellipse([Gradient.Stop(color: atmosphere.accentSoft, location: 0),
                          Gradient.Stop(color: .clear, location: 0.68)],
                         width: w * 1.3 * 2, height: h * 0.52 * 2)
                .opacity(0.55)
                .position(x: w * 0.5, y: h * 1.06)
        case .disperse:
            // air's light stands off to one side — which side is hers, by her seat
            Self.ellipse([Gradient.Stop(color: atmosphere.glow, location: 0),
                          Gradient.Stop(color: .clear, location: 0.6)],
                         width: w * 0.78 * 2, height: h * 0.96 * 2)
                .position(x: w * (atmosphere.rotation >= 0 ? 0.82 : 0.18), y: h * 0.40)
        case .bloom:
            let r = (w * w * 0.25 + h * h * 0.3136).squareRoot()
            Self.ellipse([Gradient.Stop(color: atmosphere.accentFaint, location: 0),
                          Gradient.Stop(color: .clear, location: 0.42)],
                         width: r * 2, height: r * 2)
                .position(x: w * 0.5, y: h * 0.44)
        case .settle:
            Self.ellipse([Gradient.Stop(color: atmosphere.glow, location: 0),
                          Gradient.Stop(color: .clear, location: 0.66)],
                         width: w * 1.4 * 2, height: h * 0.48 * 2)
                .position(x: w * 0.5, y: h * 0.96)
        case .radiate:
            let r = (w * w * 0.25 + h * h * 0.3364).squareRoot()
            Self.ellipse([Gradient.Stop(color: atmosphere.accentSoft, location: 0),
                          Gradient.Stop(color: atmosphere.glow, location: 0.26),
                          Gradient.Stop(color: .clear, location: 0.62)],
                         width: r * 2, height: r * 2)
                .opacity(0.7)
                .position(x: w * 0.5, y: h * 0.42)
        }
    }
}

// MARK: Her nature's standing light

/// The light each nature stands in the air while the ceremony holds: a tongue
/// of fire from the floor, a lens of water under her point, streams of air
/// drifting sideways, ether's bloom, earth's horizon, light's rays. It moves
/// with the same pose as her geometry, and lifts when she has felt him back.
struct RecognitionNatureLight: View {
    let atmosphere: Atmosphere
    let nature: RecognitionNature
    let pose: RecognitionNature.Pose
    let focal: CGPoint
    let scale: CGFloat
    let size: CGSize
    /// Act 2 has landed: the light stands at its full strength.
    let answered: Bool

    private var lift: Double { answered ? 1.0 : 0.7 }
    private var s: CGFloat { scale }

    var body: some View {
        ZStack {
            natureLayer
            // The point she answers from — an emissive core at the focal.
            RecognitionCore(atmosphere: atmosphere, radius: 44 * s)
                .scaleEffect(CGFloat(pose.scale))
                .opacity(min(1, pose.opacity * 1.5))
                .position(focal)
        }
        // The lift is its own modifier, so the answer at Act 2 never interrupts
        // the breath running on the light inside it.
        .opacity(lift)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var natureLayer: some View {
        switch nature {
        case .flare:
            // A tongue of light standing from the floor up through her point.
            let tongueH = max(size.height - focal.y, 0) + 120 * s
            Ellipse()
                .fill(EllipticalGradient(colors: [atmosphere.accentBright.opacity(0.55), atmosphere.glow, .clear],
                                         center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                .frame(width: 150 * s, height: tongueH)
                .scaleEffect(x: 1, y: CGFloat(pose.scale), anchor: .bottom)
                .offset(y: CGFloat(pose.dy) * s * 2)
                .blur(radius: 16 * s)
                .blendMode(.plusLighter)
                .opacity(min(1, pose.opacity * 1.4))
                .position(x: focal.x, y: focal.y - 60 * s + tongueH * 0.5)

        case .pool:
            // A lens of light where she pools, below her point, and the
            // surface's own rings breathing with it.
            ZStack {
                Ellipse()
                    .fill(EllipticalGradient(colors: [atmosphere.accentSoft, atmosphere.glow, .clear],
                                             center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                    .frame(width: 440 * s, height: 110 * s)
                    .scaleEffect(x: CGFloat(pose.scale), y: 1)
                    .blur(radius: 8 * s)
                ForEach(0..<2, id: \.self) { i in
                    Ellipse()
                        .stroke(atmosphere.accentSoft, lineWidth: 0.8)
                        .frame(width: (180 + 120 * CGFloat(i)) * s, height: (32 + 22 * CGFloat(i)) * s)
                        .scaleEffect(CGFloat(pose.scale) + 0.04 * CGFloat(i))
                        .opacity(0.8 - 0.3 * Double(i))
                }
            }
            .blendMode(.plusLighter)
            .opacity(min(1, pose.opacity * 1.3))
            .position(x: focal.x, y: focal.y + 170 * s)

        case .disperse:
            // Streams of air drifting sideways through her point, each a little
            // further than the one above it.
            ZStack {
                ForEach(0..<Self.streamRows.count, id: \.self) { i in
                    stream(i)
                }
            }
            .blendMode(.plusLighter)
            .opacity(min(1, pose.opacity * 1.5))
            .position(focal)

        case .bloom:
            // Ether opens once and holds: a disc of light and its rim.
            ZStack {
                Circle()
                    .fill(EllipticalGradient(colors: [atmosphere.accentBright.opacity(0.32), atmosphere.glow, .clear],
                                             center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                    .frame(width: 440 * s, height: 440 * s)
                Circle()
                    .stroke(atmosphere.accentSoft, lineWidth: 0.8)
                    .frame(width: 320 * s, height: 320 * s)
                Circle()
                    .stroke(atmosphere.accentFaint, lineWidth: 0.6)
                    .frame(width: 236 * s, height: 236 * s)
            }
            .scaleEffect(CGFloat(pose.scale))
            .blendMode(.plusLighter)
            .opacity(min(1, pose.opacity * 1.3))
            .position(focal)

        case .settle:
            // The ground she settles onto: a horizon band of light along the
            // floor and its line, barely stirring.
            ZStack {
                Ellipse()
                    .fill(EllipticalGradient(colors: [atmosphere.glow, atmosphere.accentFaint, .clear],
                                             center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                    .frame(width: size.width * 1.5, height: 170 * s)
                    .scaleEffect(x: 1, y: CGFloat(pose.scale))
                    .position(x: size.width * 0.5, y: size.height - 30 * s)
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, atmosphere.accentSoft, .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: size.width * 0.78, height: 0.75)
                    .position(x: size.width * 0.5, y: size.height - 20 * s)
            }
            .blendMode(.plusLighter)
            .opacity(min(1, pose.opacity * 1.6))

        case .radiate:
            // Light radiates: rays from her point, long and short alternating.
            RecognitionRays(color: atmosphere.accentBright, inner: 30 * s)
                .frame(width: 560 * s, height: 560 * s)
                .scaleEffect(CGFloat(pose.scale))
                .rotationEffect(.degrees(atmosphere.rotation * 0.1))
                .blendMode(.plusLighter)
                .opacity(min(1, pose.opacity * 1.2))
                .position(focal)
        }
    }

    /// The four streams' heights around the focal, at the 390 pt reference.
    private static let streamRows: [CGFloat] = [-72, -26, 28, 82]

    /// One stream of air. Alternate streams drift opposite ways, and each one
    /// lower down drifts a little further, so the air never moves as a block.
    private func stream(_ i: Int) -> some View {
        let even = i % 2 == 0
        let way: CGFloat = even ? 1 : -1
        let reach: CGFloat = 1.5 + CGFloat(i)
        let drift: CGFloat = CGFloat(pose.dx) * s * reach * way
        let length: CGFloat = (even ? 260 : 300) * s
        let thickness: CGFloat = (even ? 3 : 2) * s
        let row: CGFloat = Self.streamRows[i] * s
        let strength: Double = 0.9 - 0.15 * Double(i)
        return Capsule()
            .fill(LinearGradient(colors: [.clear, atmosphere.accentBright.opacity(0.7), .clear],
                                 startPoint: .leading, endPoint: .trailing))
            .frame(width: length, height: thickness)
            .blur(radius: 2 * s)
            .offset(x: drift, y: row)
            .opacity(strength)
    }
}

/// An emissive point: hot centre, her colour, falling to nothing.
struct RecognitionCore: View {
    let atmosphere: Atmosphere
    let radius: CGFloat

    var body: some View {
        Circle()
            .fill(RadialGradient(gradient: Gradient(colors: [atmosphere.accentBright, atmosphere.glow, .clear]),
                                 center: .center, startRadius: 0, endRadius: radius))
            .frame(width: radius * 2, height: radius * 2)
            .blendMode(.plusLighter)
    }
}

/// Rays from a point, drawn once; the caller moves and lights them.
struct RecognitionRays: View {
    let color: Color
    let inner: CGFloat

    var body: some View {
        Canvas { ctx, sz in
            let c = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let outer = min(sz.width, sz.height) / 2
            let n = RecognitionNature.rayCount
            ctx.blendMode = .plusLighter
            for i in 0..<n {
                let a = Double(i) / Double(n) * 2 * Double.pi
                let long = i % 2 == 0
                let reach = long ? outer : outer * 0.62
                let p0 = CGPoint(x: c.x + CGFloat(cos(a)) * inner, y: c.y + CGFloat(sin(a)) * inner)
                let p1 = CGPoint(x: c.x + CGFloat(cos(a)) * reach, y: c.y + CGFloat(sin(a)) * reach)
                var ray = Path()
                ray.move(to: p0)
                ray.addLine(to: p1)
                ctx.stroke(ray,
                           with: .linearGradient(Gradient(colors: [color, color.opacity(0)]),
                                                 startPoint: p0, endPoint: p1),
                           lineWidth: long ? 1.2 : 0.8)
            }
        }
    }
}

// MARK: Ripples of recognition

/// One ripple, travelling forever from her point in her element's manner:
/// a ring, a ring that rises (fire), a ring that spreads wide (air).
struct RecognitionRipple: View {
    let color: Color
    let nature: RecognitionNature
    let index: Int
    let scale: CGFloat
    let reduceMotion: Bool

    @State private var travelling = false

    var body: some View {
        let end = nature.rippleEnd
        Circle()
            .stroke(color, lineWidth: 1)
            .frame(width: 10, height: 10)
            .scaleEffect(x: travelling ? CGFloat(end.scaleX) * scale : 1,
                         y: travelling ? CGFloat(end.scaleY) * scale : 1)
            .offset(y: travelling ? -CGFloat(end.rise) * scale : 0)
            .opacity(travelling ? 0 : end.startOpacity)
            .onAppear {
                guard !reduceMotion else { return }
                let duration = nature.rippleDuration
                let delay = Double(index) * duration / Double(max(nature.rippleCount, 1))
                withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false).delay(delay)) {
                    travelling = true
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

// MARK: The answer — "and she felt you back", in light

/// The one-time answer at Act 2, in her nature: the flare's tongue leaping,
/// a ring spreading over the pool, a breath crossing the glass, the bloom's
/// rim opening, light settling to the ground, the rays reaching. Shown only
/// when motion is allowed; under reduce motion the standing light lifts instead.
struct RecognitionAnswer: View {
    let atmosphere: Atmosphere
    let nature: RecognitionNature
    let focal: CGPoint
    let scale: CGFloat
    let size: CGSize

    @State private var run = false
    private var s: CGFloat { scale }

    var body: some View {
        answer
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .onAppear {
                withAnimation(.easeOut(duration: nature.answerDuration)) { run = true }
            }
    }

    @ViewBuilder
    private var answer: some View {
        switch nature {
        case .flare:
            Ellipse()
                .fill(EllipticalGradient(colors: [atmosphere.accentBright, atmosphere.glow, .clear],
                                         center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                .frame(width: 90 * s, height: 260 * s)
                .scaleEffect(x: run ? 0.7 : 1, y: run ? 1.5 : 0.5, anchor: .bottom)
                .offset(y: run ? -220 * s : 0)
                .blur(radius: 10 * s)
                .blendMode(.plusLighter)
                .opacity(run ? 0 : 0.9)
                .position(x: focal.x, y: focal.y - 100 * s)

        case .pool:
            ZStack {
                Ellipse()
                    .stroke(atmosphere.accentBright, lineWidth: 1.2)
                    .frame(width: 40 * s, height: 9 * s)
                    .scaleEffect(run ? 11 : 1)
                    .opacity(run ? 0 : 0.85)
                    .position(x: focal.x, y: focal.y + 170 * s)
                RecognitionCore(atmosphere: atmosphere, radius: 60 * s)
                    .opacity(run ? 0 : 0.8)
                    .position(x: focal.x, y: focal.y + 170 * s)
            }

        case .disperse:
            Capsule()
                .fill(LinearGradient(colors: [.clear, atmosphere.accentBright.opacity(0.6), .clear],
                                     startPoint: .leading, endPoint: .trailing))
                .frame(width: size.width * 0.6, height: 70 * s)
                .blur(radius: 20 * s)
                .blendMode(.plusLighter)
                .offset(x: run ? size.width : -size.width)
                .position(focal)

        case .bloom:
            ZStack {
                Circle()
                    .stroke(atmosphere.accentBright, lineWidth: 1.2)
                    .frame(width: 40 * s, height: 40 * s)
                    .scaleEffect(run ? 9 : 1)
                    .opacity(run ? 0 : 0.9)
                RecognitionCore(atmosphere: atmosphere, radius: 150 * s)
                    .scaleEffect(run ? 1.3 : 0.4)
                    .opacity(run ? 0 : 0.8)
            }
            .position(focal)

        case .settle:
            ZStack {
                // light comes to rest on the ground…
                RecognitionCore(atmosphere: atmosphere, radius: 50 * s)
                    .position(x: focal.x, y: run ? size.height - 30 * s : focal.y)
                    .opacity(run ? 0 : 0.75)
                // …and the ground takes its weight.
                Ellipse()
                    .fill(EllipticalGradient(colors: [atmosphere.accentBright.opacity(0.5), atmosphere.glow, .clear],
                                             center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                    .frame(width: size.width * 1.4, height: 200 * s)
                    .blendMode(.plusLighter)
                    .opacity(run ? 0 : 0.6)
                    .position(x: size.width * 0.5, y: size.height - 30 * s)
            }

        case .radiate:
            RecognitionRays(color: atmosphere.accentBright, inner: 30 * s)
                .frame(width: 560 * s, height: 560 * s)
                .scaleEffect(run ? 1.6 : 0.8)
                .blendMode(.plusLighter)
                .opacity(run ? 0 : 1)
                .position(focal)
        }
    }
}

// MARK: The after-glow — what stays of her light

/// When the ceremony has gathered into the point, a brief residue of her light
/// stays there: an ember at the point, one halo leaving it (the Portrait's own
/// settle), and the glass a little lifted, all falling away on Design's
/// after-effect curve. Never named, never a score — only light, going.
struct RecognitionAfterGlow: View {
    let atmosphere: Atmosphere
    let focal: CGPoint
    let scale: CGFloat
    let reduceMotion: Bool

    @State private var start = Date()
    @State private var faded = false

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: reduceMotion)) { context in
            let t = context.date.timeIntervalSince(start)
            let strength = reduceMotion ? 1.0 : RecognitionTimeline.afterGlowStrength(at: t)
            let travel = reduceMotion ? 0.0 : min(max(t / RecognitionTimeline.afterGlow, 0), 1)
            residue(strength: strength, travel: travel)
        }
        .opacity(reduceMotion && faded ? 0 : 1)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            start = Date()
            guard reduceMotion else { return }
            withAnimation(.easeOut(duration: RecognitionTimeline.reducedAfterGlow)) { faded = true }
        }
    }

    private func residue(strength: Double, travel: Double) -> some View {
        ZStack {
            // the glass, still a little lifted by her
            Rectangle()
                .fill(atmosphere.glow)
                .blendMode(.plusLighter)
                .opacity(0.5 * strength)
            // the ember at the point
            RecognitionCore(atmosphere: atmosphere, radius: 58 * scale)
                .scaleEffect(CGFloat(0.7 + 0.5 * travel))
                .opacity(strength)
                .position(focal)
            // one halo leaving it
            Circle()
                .stroke(Color.gold, lineWidth: 1)
                .frame(width: 12 * scale, height: 12 * scale)
                .scaleEffect(CGFloat(1 + 5 * travel))
                .opacity(reduceMotion ? 0 : 0.8 * (1 - travel))
                .position(focal)
        }
    }
}

// MARK: The felt-back haptic

/// Her nature's pulse, in the hand. A haptic is felt, not seen: it carries no
/// number and nothing to compare.
enum RecognitionHaptic {
    static func play(_ pulse: RecognitionNature.Pulse) {
        let style: UIImpactFeedbackGenerator.FeedbackStyle
        switch pulse.style {
        case .soft:   style = .soft
        case .light:  style = .light
        case .medium: style = .medium
        case .rigid:  style = .rigid
        case .heavy:  style = .heavy
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred(intensity: CGFloat(pulse.intensity))
    }
}
