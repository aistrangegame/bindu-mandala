import SwiftUI

// MARK: - Light, layer for layer
//
// Design's grounds are CSS backgrounds: two or three gradients stacked, each a
// light with a place and a reach (`lrBackdrop`, the Field's crown glow, the
// menu veil, the Memory's pool). The first port collapsed every one of them to
// a single radial gradient, and a SwiftUI `RadialGradient` is a *circle* — so a
// light Design drew as a wide, low ellipse ("ellipse 140% 48% at 50% 96%")
// arrived as a round lamp of the wrong reach.
//
// This file is the CSS vocabulary those grounds were written in, so a backdrop
// can be ported line for line and read back against the JSX:
//
//   radial-gradient(ellipse W% H% at X Y, …)  →  LightLayer.ellipse
//   radial-gradient(circle at X Y, …)         →  LightLayer.circle
//   linear-gradient(<angle>, …)               →  LightLayer.linear
//
// The radial layers are composited **additively** (`.plusLighter`) over the
// linear ground. On a ground this dark that is the difference between a light
// painted onto the wall and a light standing in the air in front of it.

/// One colour stop. `location` is 0…1 along the gradient ray, as in CSS.
struct LightStop: Equatable {
    let color: Color
    let location: CGFloat

    init(_ color: Color, _ location: CGFloat) {
        self.color = color
        self.location = location
    }

    /// CSS `transparent` after a colour. Fading to the *same* colour at zero
    /// alpha, not to clear black, is what keeps the falloff from greying.
    static func fade(_ color: Color, _ location: CGFloat) -> LightStop {
        LightStop(color.opacity(0), location)
    }
}

/// One layer of a ground. Every geometric value is a fraction of the box, so a
/// layer means the same thing on an SE and on a Pro Max.
enum LightLayer: Equatable {
    /// `radial-gradient(ellipse rx% ry% at center, stops)` — the radii are
    /// fractions of the box's own width and height, as CSS reads them.
    case ellipse(center: UnitPoint, rx: CGFloat, ry: CGFloat, stops: [LightStop])
    /// `radial-gradient(circle at center, stops)` — CSS's default reach is the
    /// farthest corner.
    case circle(center: UnitPoint, stops: [LightStop])
    /// `linear-gradient(angle, stops)` — 180° runs top to bottom, 120° runs
    /// toward the lower right, exactly as CSS measures it.
    case linear(angle: Double, stops: [LightStop])
    /// A flat ground.
    case fill(Color)
    /// The same ellipse as `.ellipse`, laid down rather than added: a shadow
    /// (`LrDepth`'s vignette) has to be able to darken.
    case shade(center: UnitPoint, rx: CGFloat, ry: CGFloat, stops: [LightStop])

    /// Whether this layer is a light (added) or a ground (laid down).
    var isLight: Bool {
        switch self {
        case .ellipse, .circle:        return true
        case .linear, .fill, .shade:   return false
        }
    }

    /// CSS's gradient-line length for an angle in a box: |w·sin a| + |h·cos a|.
    static func linearLength(angle: Double, in size: CGSize) -> CGFloat {
        let a = angle * .pi / 180
        return abs(size.width * CGFloat(sin(a))) + abs(size.height * CGFloat(cos(a)))
    }

    /// The farthest-corner radius from a point in a box.
    static func farthestCorner(from p: CGPoint, in size: CGSize) -> CGFloat {
        let dx = max(p.x, size.width - p.x)
        let dy = max(p.y, size.height - p.y)
        return sqrt(dx * dx + dy * dy)
    }

    func draw(in ctx: GraphicsContext, size: CGSize) {
        var c = ctx
        if isLight { c.blendMode = .plusLighter }
        switch self {
        case .fill(let color):
            c.fill(Path(CGRect(origin: .zero, size: size)), with: .color(color))

        case .linear(let angle, let stops):
            let a = angle * .pi / 180
            let len = Self.linearLength(angle: angle, in: size)
            let dir = CGPoint(x: CGFloat(sin(a)), y: CGFloat(-cos(a)))
            let mid = CGPoint(x: size.width / 2, y: size.height / 2)
            let start = CGPoint(x: mid.x - dir.x * len / 2, y: mid.y - dir.y * len / 2)
            let end = CGPoint(x: mid.x + dir.x * len / 2, y: mid.y + dir.y * len / 2)
            c.fill(Path(CGRect(origin: .zero, size: size)),
                   with: .linearGradient(Self.gradient(stops), startPoint: start, endPoint: end))

        case .circle(let center, let stops):
            let p = CGPoint(x: center.x * size.width, y: center.y * size.height)
            let r = max(1, Self.farthestCorner(from: p, in: size))
            c.fill(Path(CGRect(origin: .zero, size: size)),
                   with: .radialGradient(Self.gradient(stops), center: p, startRadius: 0, endRadius: r))

        case .ellipse(let center, let rxF, let ryF, let stops),
             .shade(let center, let rxF, let ryF, let stops):
            let cx = center.x * size.width
            let cy = center.y * size.height
            let rx = max(1, rxF * size.width)
            let ry = max(1, ryF * size.height)
            let sy = ry / rx
            // Draw a circle of radius rx in a space squashed by ry/rx: the
            // rectangle below is the whole box, expressed in that space.
            c.translateBy(x: cx, y: cy)
            c.scaleBy(x: 1, y: sy)
            let rect = CGRect(x: -cx, y: -cy / sy, width: size.width, height: size.height / sy)
            c.fill(Path(rect),
                   with: .radialGradient(Self.gradient(stops), center: .zero, startRadius: 0, endRadius: rx))
        }
    }

    private static func gradient(_ stops: [LightStop]) -> Gradient {
        Gradient(stops: stops.map { Gradient.Stop(color: $0.color, location: $0.location) })
    }
}

/// A stack of `LightLayer`s, drawn once into one `Canvas`. Equatable, so a
/// parent that breathes (a `TimelineView`) can wrap it in `.equatable()` and
/// the gradients are not redrawn on every frame of the breath.
struct LightField: View, Equatable {
    let layers: [LightLayer]

    var body: some View {
        Canvas { ctx, size in
            for layer in layers { layer.draw(in: ctx, size: size) }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - The grounds, as Design wrote them

/// Every ground in the day's light, ported line for line from the JSX. Pure —
/// the layer counts and positions are asserted in `DayLightTests`.
enum Backdrop {

    /// `lrBackdrop(atmo)` — where her light lives on the screen, by element.
    /// `flipLeft` is the composition's `_flipLeft` (air's glow side).
    static func layers(for a: Atmosphere, flipLeft: Bool = false) -> [LightLayer] {
        let g = a.glow, gd = a.groundDeep, gr = a.ground
        let af = a.accentFaint, asoft = a.accentSoft
        switch a.element {
        case .fire:
            // radial-gradient(ellipse 95% 62% at 50% 104%, g, transparent 62%),
            // radial-gradient(ellipse 120% 40% at 50% -10%, af, transparent 60%),
            // linear-gradient(#080203, gd)
            return [
                .linear(angle: 180, stops: [LightStop(Color(hex: "#080203"), 0), LightStop(gd, 1)]),
                .ellipse(center: UnitPoint(x: 0.5, y: -0.10), rx: 1.20, ry: 0.40,
                         stops: [LightStop(af, 0), .fade(af, 0.60)]),
                .ellipse(center: UnitPoint(x: 0.5, y: 1.04), rx: 0.95, ry: 0.62,
                         stops: [LightStop(g, 0), .fade(g, 0.62)]),
            ]
        case .water:
            // radial-gradient(ellipse 130% 52% at 50% 106%, as, transparent 68%),
            // linear-gradient(gr, gd)
            return [
                .linear(angle: 180, stops: [LightStop(gr, 0), LightStop(gd, 1)]),
                .ellipse(center: UnitPoint(x: 0.5, y: 1.06), rx: 1.30, ry: 0.52,
                         stops: [LightStop(asoft, 0), .fade(asoft, 0.68)]),
            ]
        case .air:
            // radial-gradient(ellipse 78% 96% at {82|18}% 40%, g, transparent 60%),
            // linear-gradient(120deg, gr, gd)
            return [
                .linear(angle: 120, stops: [LightStop(gr, 0), LightStop(gd, 1)]),
                .ellipse(center: UnitPoint(x: flipLeft ? 0.82 : 0.18, y: 0.40), rx: 0.78, ry: 0.96,
                         stops: [LightStop(g, 0), .fade(g, 0.60)]),
            ]
        case .ether:
            // radial-gradient(circle at 50% 44%, g, transparent 58%),
            // radial-gradient(circle at 50% 44%, af, transparent 42%),
            // linear-gradient(gr, gd)
            return [
                .linear(angle: 180, stops: [LightStop(gr, 0), LightStop(gd, 1)]),
                .circle(center: UnitPoint(x: 0.5, y: 0.44), stops: [LightStop(af, 0), .fade(af, 0.42)]),
                .circle(center: UnitPoint(x: 0.5, y: 0.44), stops: [LightStop(g, 0), .fade(g, 0.58)]),
            ]
        case .earth:
            // radial-gradient(ellipse 140% 48% at 50% 96%, g, transparent 66%),
            // linear-gradient(gr, gd)
            return [
                .linear(angle: 180, stops: [LightStop(gr, 0), LightStop(gd, 1)]),
                .ellipse(center: UnitPoint(x: 0.5, y: 0.96), rx: 1.40, ry: 0.48,
                         stops: [LightStop(g, 0), .fade(g, 0.66)]),
            ]
        case .light:
            // radial-gradient(circle at 50% 42%, as, g 26%, transparent 62%),
            // linear-gradient(gd, #060305)
            return [
                .linear(angle: 180, stops: [LightStop(gd, 0), LightStop(Color(hex: "#060305"), 1)]),
                .circle(center: UnitPoint(x: 0.5, y: 0.42),
                        stops: [LightStop(asoft, 0), LightStop(g, 0.26), .fade(g, 0.62)]),
            ]
        }
    }

    /// The Field and the Well: `linear-gradient(ground, groundDeep)` under
    /// `radial-gradient(ellipse 130% 40% at 50% -5%, glow, transparent 70%)`.
    static func crown(_ a: Atmosphere) -> [LightLayer] {
        [
            .linear(angle: 180, stops: [LightStop(a.ground, 0), LightStop(a.groundDeep, 1)]),
            .ellipse(center: UnitPoint(x: 0.5, y: -0.05), rx: 1.30, ry: 0.40,
                     stops: [LightStop(a.glow, 0), .fade(a.glow, 0.70)]),
        ]
    }

    /// Her Presence's crowning glow, laid over `lrBackdrop`:
    /// `radial-gradient(ellipse 130% 55% at 50% -5%, glow, transparent 70%)`.
    static func presenceCrown(_ a: Atmosphere) -> [LightLayer] {
        [
            .ellipse(center: UnitPoint(x: 0.5, y: -0.05), rx: 1.30, ry: 0.55,
                     stops: [LightStop(a.glow, 0), .fade(a.glow, 0.70)]),
        ]
    }

    /// The menu veil: `radial-gradient(ellipse 80% 55% at 50% 42%, glow,
    /// transparent 75%), groundDeep`.
    static func veil(_ a: Atmosphere) -> [LightLayer] {
        [
            .fill(a.groundDeep),
            .ellipse(center: UnitPoint(x: 0.5, y: 0.42), rx: 0.80, ry: 0.55,
                     stops: [LightStop(a.glow, 0), .fade(a.glow, 0.75)]),
        ]
    }

    /// A sheet (the Nityā, Settings): `radial-gradient(ellipse 120% 60% at 50%
    /// 0%, glow, transparent 70%), linear-gradient(ground, groundDeep)`.
    static func sheet(_ a: Atmosphere) -> [LightLayer] {
        [
            .linear(angle: 180, stops: [LightStop(a.ground, 0), LightStop(a.groundDeep, 1)]),
            .ellipse(center: UnitPoint(x: 0.5, y: 0.0), rx: 1.20, ry: 0.60,
                     stops: [LightStop(a.glow, 0), .fade(a.glow, 0.70)]),
        ]
    }

    /// The Memory: `radial-gradient(ellipse 100% 60% at 50% 45%, glow,
    /// transparent 75%), linear-gradient(groundDeep, #050203)`.
    static func memory(_ a: Atmosphere) -> [LightLayer] {
        [
            .linear(angle: 180, stops: [LightStop(a.groundDeep, 0), LightStop(Color(hex: "#050203"), 1)]),
            .ellipse(center: UnitPoint(x: 0.5, y: 0.45), rx: 1.00, ry: 0.60,
                     stops: [LightStop(a.glow, 0), .fade(a.glow, 0.75)]),
        ]
    }
}
