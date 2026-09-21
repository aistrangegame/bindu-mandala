// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here — including SpikeBench's hiding and restoring of
// the practitioner's own window — can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import Combine
import SwiftUI

/// The three moments of the shipped Living Mandala the G5 baseline is taken at,
/// plus the floor they are measured above.
enum SpikeScene: String, CaseIterable, Codable {
    /// Ground + day glow only. Everything the room costs *before* the canvas —
    /// subtract it and what is left is the Mandala.
    case control
    /// Tier 0 — the whole instrument fitted, all 102 seats on screen.
    case tier0AllSeats
    /// Tier 2 — flown to a seat at scale 3, her family threads blooming.
    case tier2Bloom
    /// The fall to the Bindu, looped, so a 20-second window holds eight of them.
    case descent

    var label: String {
        switch self {
        case .control:       return "control · ground + glow"
        case .tier0AllSeats: return "tier 0 · all 102 seats"
        case .tier2Bloom:    return "tier 2 · deep-zoom bloom"
        case .descent:       return "the descent"
        }
    }
}

/// The scripted state of a scene at a given scene time. Pure: the harness renders
/// from it and the census counts from it, so the two can never disagree about what
/// frame was on screen.
struct SpikeSceneState {
    var camera: MandalaCamera
    var focusKp: Int?
    var familyKp: Set<Int> = []
    var constellation: Double = 0
    var constellationStart: TimeInterval?
    var flash: MandalaCanvasLayer.RingFlash?
}

/// The scripted run. Everything is a pure function of scene time, which comes from
/// `SpikeMetrics.Clock` — the test-only time input. Advance the clock's offset and
/// the script is instantly wherever you asked for, with no waiting.
struct SpikeScript {
    let scene: SpikeScene
    let field: SpikeField
    let clock: SpikeMetrics.Clock

    /// The bloom's focus, resolved once at construction. Both of these are constant
    /// for the whole window, and both walk all 102 SwiftData models to compute —
    /// doing that per frame (the census replays one `state` per sampled frame) is
    /// what stalled the main actor and got the first bench run killed.
    private let bloomPoint: CGPoint
    private let bloomFamily: Set<Int>

    init(scene: SpikeScene, field: SpikeField, clock: SpikeMetrics.Clock) {
        self.scene = scene
        self.field = field
        self.clock = clock
        if scene == .tier2Bloom {
            self.bloomPoint = field.seat(kp: SpikeField.bloomFocusKp)?.point ?? .zero
            self.bloomFamily = field.family(ofKp: SpikeField.bloomFocusKp)
        } else {
            self.bloomPoint = .zero
            self.bloomFamily = []
        }
    }

    /// A bloom restarts every four seconds, so a 20-second window contains five
    /// full constellation cascades rather than one cascade and nineteen seconds of
    /// a finished picture.
    static let bloomPeriod: TimeInterval = 4
    /// The shipped descent is `.easeIn(duration: 0.95)`; the loop then holds at the
    /// Bindu and re-arms, giving eight falls in a 20-second window.
    static let descentFall: TimeInterval = 0.95
    static let descentPeriod: TimeInterval = 2.5

    func state(atScene s: TimeInterval, in size: CGSize) -> SpikeSceneState {
        switch scene {
        case .control, .tier0AllSeats:
            return SpikeSceneState(camera: .fitted(in: size), focusKp: nil)

        case .tier2Bloom:
            let cycleStart = (s / Self.bloomPeriod).rounded(.down) * Self.bloomPeriod
            return SpikeSceneState(
                camera: .flyTarget(to: bloomPoint, in: size),
                focusKp: SpikeField.bloomFocusKp,
                familyKp: bloomFamily,
                constellation: 1,
                constellationStart: clock.referenceTime(forScene: cycleStart + 0.15))

        case .descent:
            let phase = s.truncatingRemainder(dividingBy: Self.descentPeriod)
            let from = MandalaCamera.fitted(in: size)
            let to = MandalaCamera.descentTarget(in: size)
            let p = min(max(phase / Self.descentFall, 0), 1)
            let e = Self.easeIn(p)
            return SpikeSceneState(camera: Self.lerp(from, to, e), focusKp: nil)
        }
    }

    static func lerp(_ a: MandalaCamera, _ b: MandalaCamera, _ t: CGFloat) -> MandalaCamera {
        MandalaCamera(scale: a.scale + (b.scale - a.scale) * t,
                      tx: a.tx + (b.tx - a.tx) * t,
                      ty: a.ty + (b.ty - a.ty) * t)
    }

    /// SwiftUI's `.easeIn` is `cubic-bezier(0.42, 0, 1, 1)`. Solved here rather than
    /// approximated so the scripted camera track is the one the shipped animation
    /// would have flown, and so the census and the render agree exactly.
    static func easeIn(_ x: Double) -> CGFloat {
        CGFloat(unitBezier(x, p1x: 0.42, p1y: 0, p2x: 1, p2y: 1))
    }

    private static func unitBezier(_ x: Double, p1x: Double, p1y: Double, p2x: Double, p2y: Double) -> Double {
        let cx = 3 * p1x, bx = 3 * (p2x - p1x) - cx, ax = 1 - cx - bx
        let cy = 3 * p1y, by = 3 * (p2y - p1y) - cy, ay = 1 - cy - by
        func sampleX(_ t: Double) -> Double { ((ax * t + bx) * t + cx) * t }
        func sampleY(_ t: Double) -> Double { ((ay * t + by) * t + cy) * t }
        func dX(_ t: Double) -> Double { (3 * ax * t + 2 * bx) * t + cx }
        var t = x
        for _ in 0..<8 {
            let e = sampleX(t) - x
            if abs(e) < 1e-6 { return sampleY(t) }
            let d = dX(t)
            if abs(d) < 1e-6 { break }
            t -= e / d
        }
        var lo = 0.0, hi = 1.0
        t = x
        while lo < hi {
            let e = sampleX(t)
            if abs(e - x) < 1e-6 { return sampleY(t) }
            if x > e { lo = t } else { hi = t }
            let next = (hi - lo) * 0.5 + lo
            if abs(next - t) < 1e-9 { break }
            t = next
        }
        return sampleY(t)
    }
}

/// The bench itself: the **shipped** `MandalaCanvasLayer`, unmodified, over the
/// shipped background, driven by a scripted camera.
///
/// It deliberately leaves out the room's chrome — the header, the four control
/// buttons and the significance card. Those are static SwiftUI text and shapes that
/// do not invalidate between frames, so they cost nothing per frame; including them
/// would only add a constant that every variant would carry equally. What is
/// measured is the part that redraws sixty times a second.
///
/// Nothing in the app presents this view. It is entered only from the test targets.
struct SpikeMandalaHarness: View {
    let script: SpikeScript
    var reduceMotion: Bool = false

    @State private var bloomTick = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                background
                content(in: geo.size)
            }
        }
        .ignoresSafeArea()
    }

    /// The shipped room's background, layer for layer.
    private var background: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            GeometryReader { geo in
                RadialGradient(colors: [script.field.dayAtmosphere.glow.opacity(0.5), .clear],
                               center: UnitPoint(x: 0.5, y: 0.44),
                               startRadius: 0, endRadius: max(geo.size.width, 320) * 0.9)
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func content(in size: CGSize) -> some View {
        switch script.scene {
        case .control:
            EmptyView()
        case .descent:
            // Only the descent needs a per-frame camera, so only the descent pays
            // for an outer TimelineView. The other scenes hand the canvas a fixed
            // camera and let its own animation clock do the work, exactly as the
            // shipped room does when the practitioner's hand is still.
            TimelineView(.animation(paused: reduceMotion)) { tl in
                let s = script.clock.sceneTime(now: tl.date.timeIntervalSinceReferenceDate)
                canvas(script.state(atScene: s, in: size), size: size)
            }
        case .tier2Bloom:
            // One state change every four seconds re-arms the cascade, so a
            // 20-second window holds five blooms instead of one bloom and
            // nineteen seconds of a finished picture. Nothing else is disturbed.
            canvas(script.state(atScene: script.clock.sceneTime(), in: size), size: size)
                .id(bloomTick)
                .onReceive(Timer.publish(every: SpikeScript.bloomPeriod, on: .main, in: .common).autoconnect()) { _ in
                    bloomTick &+= 1
                }
        case .tier0AllSeats:
            // A still hand: a fixed camera, and the canvas's own clock doing the
            // work — exactly the shipped room at rest.
            canvas(script.state(atScene: script.clock.sceneTime(), in: size), size: size)
        }
    }

    private func canvas(_ st: SpikeSceneState, size: CGSize) -> some View {
        let focusBright = st.focusKp.flatMap { script.field.atmos[$0]?.accentBright } ?? Color.gold
        return MandalaCanvasLayer(
            camera: st.camera,
            size: size,
            seats: script.field.seats,
            atmos: script.field.atmos,
            dayAccent: script.field.dayAtmosphere.accent,
            todayKp: script.field.todayKp,
            focusKp: st.focusKp,
            familyKp: st.familyKp,
            focusAccentBright: focusBright,
            countByKp: script.field.countByKp,
            flash: st.flash,
            constellation: st.constellation,
            constellationStart: st.constellationStart,
            tier: st.camera.tier,
            reduceMotion: reduceMotion)
    }
}
#endif
