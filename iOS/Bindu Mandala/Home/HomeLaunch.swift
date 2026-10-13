import SwiftUI

// MARK: - Upgrade U2 · A · every launch arrives at the Bindu
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Arriving" and §2 A #1–#4:
// every cold launch, the Waking (0–2.85 s, a growing white dot the picture
// forms around), then the Homecoming (the existing `HomecomingView` — the
// Origin the first time ever, one breath every return after, his own ruling:
// Homecoming every launch), then Home. Launch always arrives at Home (ruling
// 1), so Home owns its arrival: the Router's root mounts `.home` and Home plays
// the ceremony it is owed, once per process, inside its own space — nothing
// is laid over another world.
//
// `SKIP_HOMECOMING` (every UI test not about launch) skips both; the XCTest
// host stays quiet; `FORCE_HOMECOMING` forces them.

/// Whether this process still owes him the arrival — `spine-and-home.md` #1–#4.
@MainActor
final class HomeLaunch {

    static let shared = HomeLaunch()

    /// The ceremony this process has not yet played.
    private(set) var owed: Bool

    init(arguments: [String] = ProcessInfo.processInfo.arguments,
         isUnitTesting: Bool = AppRuntime.isUnitTesting) {
        if arguments.contains("FORCE_HOMECOMING") {
            owed = true
        } else if arguments.contains("SKIP_HOMECOMING") {
            owed = false
        } else {
            owed = !isUnitTesting
        }
    }

    /// Take the arrival once. Only a launch that lands on Home is owed it: if
    /// the first world was another (a walk's `OPEN_WORLD`), Home is later
    /// reached by a crossing, with a way back behind it, and is not a launch.
    func take(wayBackIsEmpty: Bool) -> Bool {
        defer { owed = false }
        return owed && wayBackIsEmpty
    }
}

// MARK: - #1 · The Waking

/// The Waking's numbers — `spine-and-home.md` §2 A #1, verbatim.
enum WakingScore {
    /// The whole Waking: 2.85 s.
    static let seconds: Double = 2.85
    /// The kindle: ×1.32 at 58 % (1.65 s), a soft haptic (.6/.2).
    static let kindleAt: Double = 1.65

    /// The ember: 15 pt.
    static let emberDiameter: CGFloat = 15
    /// Ember scale .3 → 1 @36 % → 1.05 @50 % → 1.32 @58 % (the kindle) → .6 @80 %.
    static let emberScale: [(Double, Double)] = [(0, 0.3), (0.36, 1), (0.50, 1.05), (0.58, 1.32), (0.80, 0.6), (1, 0.6)]

    /// Halo Ø400; opacity 0 → hold 13 % → 1 @42 % → 1 @56 % → 0 @74 %.
    static let haloDiameter: CGFloat = 400
    static let haloOpacity: [(Double, Double)] = [(0, 0), (0.13, 0), (0.42, 1), (0.56, 1), (0.74, 0), (1, 0)]
    /// Halo scale .7 → 1 → 1.08 → 1.22, cubic-bezier(.4,0,.3,1).
    static let haloScale: [(Double, Double)] = [(0, 0.7), (0.13, 0.7), (0.42, 1), (0.56, 1.08), (0.74, 1.22), (1, 1.22)]
    static let haloCurve = Crossing.Curve(c1x: 0.4, c1y: 0, c2x: 0.3, c2y: 1)

    /// Bloom Ø2600; opacity 0 → hold 58 % → .9 @66 % → 1 @87 %.
    static let bloomDiameter: CGFloat = 2600
    static let bloomOpacity: [(Double, Double)] = [(0, 0), (0.58, 0), (0.66, 0.9), (0.87, 1), (1, 0)]
    /// Bloom scale .02 → .05 @58 % → .16 @66 % → .95 @87 % → 1.35, cubic-bezier(.22,1,.3,1).
    static let bloomScale: [(Double, Double)] = [(0, 0.02), (0.58, 0.05), (0.66, 0.16), (0.87, 0.95), (1, 1.35)]
    static let bloomCurve = Crossing.Curve(c1x: 0.22, c1y: 1, c2x: 0.3, c2y: 1)

    /// Scrim radial(#181009, #080605 62 %, #060402): 1 → hold 64 % → 0 @87 %.
    static let scrimOpacity: [(Double, Double)] = [(0, 1), (0.64, 1), (0.87, 0), (1, 0)]

    /// A keyframe track read at progress `p` (0…1), each segment eased by `curve`.
    static func value(_ track: [(Double, Double)], at p: Double, curve: Crossing.Curve = .linear) -> Double {
        guard let first = track.first else { return 0 }
        if p <= first.0 { return first.1 }
        for i in 1..<track.count {
            let a = track[i - 1], b = track[i]
            if p <= b.0 {
                let span = b.0 - a.0
                let k = span > 0 ? curve.value(at: (p - a.0) / span) : 1
                return a.1 + (b.1 - a.1) * k
            }
        }
        return track[track.count - 1].1
    }
}

/// The Waking — `spine-and-home.md` §2 A #1: the screen black, a white dot at
/// the point that kindles and keeps growing until the picture forms around it.
/// It never blocks his hand: a touch is taken at once, and the Homecoming
/// begins.
@MainActor
struct WakingView: View {
    /// The point's place, as a fraction of the height (Home's 0.46).
    var pointY: CGFloat = 0.46
    let onDone: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var born = Date()
    @State private var done = false

    var body: some View {
        TimelineView(.animation(paused: done)) { tl in
            let p = reduceMotion ? 1 : min(1, tl.date.timeIntervalSince(born) / WakingScore.seconds)
            Canvas { ctx, size in
                draw(ctx, size: size, p: p)
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { finish() }
        .accessibilityElement()
        .accessibilityLabel(Text("The Bindu"))
        .accessibilityAction { finish() }
        .onAppear {
            born = Date()
            if reduceMotion {
                finish()
                return
            }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(WakingScore.kindleAt))
                guard !done else { return }
                HapticLibrary.shared.play(.kindle)
                try? await Task.sleep(for: .seconds(WakingScore.seconds - WakingScore.kindleAt))
                finish()
            }
        }
    }

    private func finish() {
        guard !done else { return }
        done = true
        onDone()
    }

    private func draw(_ ctx: GraphicsContext, size: CGSize, p: Double) {
        let s = WakingScore.self
        let c = CGPoint(x: size.width / 2, y: size.height * pointY)
        let side = max(size.width, size.height)

        // The scrim — radial(#181009, #080605 62 %, #060402).
        let scrim = s.value(s.scrimOpacity, at: p)
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color(hex: "#060402")))
        if scrim > 0.001 {
            var g = ctx
            g.opacity = scrim
            g.fill(Path(CGRect(origin: .zero, size: size)),
                   with: .radialGradient(Gradient(stops: [
                        .init(color: Color(hex: "#181009"), location: 0),
                        .init(color: Color(hex: "#080605"), location: 0.62),
                        .init(color: Color(hex: "#060402"), location: 1),
                   ]), center: c, startRadius: 0, endRadius: side * 0.75))
        }

        var add = ctx
        add.blendMode = .plusLighter

        // The bloom — Ø2600, the picture forming round the dot.
        let bloomO = s.value(s.bloomOpacity, at: p, curve: s.bloomCurve)
        if bloomO > 0.001 {
            let r = s.bloomDiameter / 2 * CGFloat(s.value(s.bloomScale, at: p, curve: s.bloomCurve))
            var g = add
            g.opacity = bloomO
            g.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .radialGradient(Gradient(stops: [
                        .init(color: Color(red: 1, green: 248 / 255, blue: 232 / 255).opacity(0.95), location: 0),
                        .init(color: Color(red: 247 / 255, green: 213 / 255, blue: 163 / 255).opacity(0.55), location: 0.32),
                        .init(color: Color.clear, location: 0.68),
                   ]), center: c, startRadius: 0, endRadius: r))
        }

        // The halo — Ø400, warm gold → ember → crimson.
        let haloO = s.value(s.haloOpacity, at: p, curve: s.haloCurve)
        if haloO > 0.001 {
            let r = s.haloDiameter / 2 * CGFloat(s.value(s.haloScale, at: p, curve: s.haloCurve))
            var g = add
            g.opacity = haloO
            g.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .radialGradient(Gradient(stops: [
                        .init(color: Color(red: 252 / 255, green: 182 / 255, blue: 102 / 255).opacity(0.78), location: 0),
                        .init(color: Color(red: 240 / 255, green: 120 / 255, blue: 52 / 255).opacity(0.42), location: 0.17),
                        .init(color: Color(red: 218 / 255, green: 59 / 255, blue: 18 / 255).opacity(0.22), location: 0.40),
                        .init(color: Color.clear, location: 0.66),
                   ]), center: c, startRadius: 0, endRadius: r))
        }

        // The ember — 15 pt radial(#FFFCF4 0, #F7C478 46 %, crimson #8B1A2A edge).
        let r = s.emberDiameter / 2 * CGFloat(s.value(s.emberScale, at: p))
        let emberO = p < 0.87 ? 1 : max(0, 1 - (p - 0.87) / 0.13)
        var e = ctx
        e.opacity = emberO
        e.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
               with: .radialGradient(Gradient(stops: [
                    .init(color: Color(hex: "#FFFCF4"), location: 0),
                    .init(color: Color(hex: "#F7C478"), location: 0.46),
                    .init(color: Color(hex: "#8B1A2A"), location: 1),
               ]), center: c, startRadius: 0, endRadius: r))
    }
}
