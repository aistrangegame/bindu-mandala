import SwiftUI

// MARK: - Wave 6 · the field every mode stands on

/// Where each of the 102 sits, by position alone — the same placement
/// ``MandalaWorld/seats(from:)`` gives a whole roster, so a mode can light a
/// seat before (or without) her row being on the phone. Position is identity.
enum ModeGeometry {

    /// Her seat in the Mandala's world (Bindu at the origin, ±320).
    static func world(kp: Int) -> CGPoint {
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
        guard ring > 0 else { return .zero }
        let n = max(1, ClimbLights.seatsInRing(ring))
        let idx = CGFloat(KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1)
        switch ring {
        case 1:
            return MandalaWorld.squarePerimeter(t: (idx + 0.5) / CGFloat(n), half: MandalaWorld.ringRadius(1))
        case 9:
            return .zero
        default:
            let a = (idx / CGFloat(n)) * 2 * .pi - .pi / 2
            let r = MandalaWorld.ringRadius(ring)
            return CGPoint(x: r * cos(a), y: r * sin(a))
        }
    }

    /// The field's scale on a glass: the outer square fills `fill` of the
    /// shorter side.
    static func scale(side: CGFloat, fill: CGFloat = 0.9) -> CGFloat {
        side * fill / 2 / MandalaWorld.radius
    }

    /// Her seat on the glass.
    static func screen(kp: Int, centre: CGPoint, scale: CGFloat) -> CGPoint {
        let w = world(kp: kp)
        return CGPoint(x: centre.x + w.x * scale, y: centre.y + w.y * scale)
    }

    /// Her ring's own light.
    static func colour(kp: Int) -> Color {
        LivingStrokesLayer.color(forRing: max(1, KhadgamalaMap.ringNumber(forKhadgamala: kp)))
    }
}

/// The yantra drawn faintly behind a mode, at the same scale as its seats —
/// Ring 9's geometry (``CentreYantra``), its Bhūpura fitted to the field's.
struct ModeYantraBackdrop: View {
    /// How awake the yantra is, 0 (a breath of line) … 1 (Design's full light).
    let wake: Double
    var rotation: Angle = .zero

    var body: some View {
        Canvas { ctx, size in
            let side = min(size.width, size.height)
            let centre = CGPoint(x: size.width / 2, y: size.height / 2)
            let unit = ModeGeometry.scale(side: side) * MandalaWorld.radius / 150
            let w = max(0, min(1, wake))
            CentreYantra.draw(in: ctx, centre: centre, unit: unit,
                              opacity: { layer in
                                  layer == .names ? 0 : CentreYantra.restOpacity(layer) * (0.16 + 0.84 * w)
                              },
                              names: [], rotation: rotation)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A light at a seat: a halo of her ring's colour round a cream core.
enum ModeLight {
    static func draw(in ctx: inout GraphicsContext, at p: CGPoint, colour: Color,
                     radius: CGFloat, alpha: Double) {
        guard alpha > 0.005 else { return }
        let glow = radius * 3
        ctx.fill(Path(ellipseIn: CGRect(x: p.x - glow, y: p.y - glow, width: glow * 2, height: glow * 2)),
                 with: .radialGradient(Gradient(colors: [colour.opacity(0.6 * alpha), colour.opacity(0)]),
                                       center: p, startRadius: 0, endRadius: glow))
        ctx.fill(Path(ellipseIn: CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)),
                 with: .color(Color.cream.opacity(alpha)))
    }
}

/// The quiet way out of a mode — one word at the foot, a 44 pt target.
struct ModeRestButton: View {
    var words: String = "rest"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(words)
                .font(AppFont.label(12))
                .tracking(2.6)
                .foregroundStyle(Color.cream.opacity(0.6))
                .padding(.horizontal, 28)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// The small heading every mode carries: its name in Design's lowercase
/// italic, and Design's kicker beneath it.
struct ModeHeading: View {
    let title: String
    var kicker: String = ""

    var body: some View {
        VStack(spacing: 6) {
            Text(title.lowercased())
                .font(AppFont.voice(15))
                .tracking(4.2)
                .foregroundStyle(Color.gold.opacity(0.75))
            if !kicker.isEmpty {
                Text(kicker)
                    .font(AppFont.label(11))
                    .tracking(2.4)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 60)
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
    }
}
