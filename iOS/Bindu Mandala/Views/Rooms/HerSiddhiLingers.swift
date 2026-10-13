import SwiftUI

// MARK: - Her siddhi lingers on the instrument
//
// Wave 1 · Slice D. The after-effect of a stay, on the whole instrument
// (``HomeAfterEffect``): when he crosses out of a room the light of the app
// lifts and fades over twenty-four seconds, and for three minutes the
// instrument is a little lighter, heavier, sharper or wider, by her āvaraṇa,
// decaying as the square of what is left. Felt, never named: no line says it
// (ruling 15, 12 Oct 2026).
//
// **Nothing about it is a measure.** It is the same after-effect for every stay
// in a ring, it carries no number, and it says nothing about how long he stayed
// or how often he has come. It is her, still present, and then gone.
//
// HOW IT IS DRAWN, AND WHY THIS WAY
//
// The whole app is the content, so the content is never wrapped in anything
// that changes its identity — a branch here would rebuild every screen in the
// instrument the moment a room was left. The light is an *overlay* that exists
// only while it lingers, and the size change is a scale that stands at exactly
// one the rest of the time. No filter sits over the app when nothing lingers.
//
// The decay is SwiftUI's own animation over the full duration rather than a
// timeline at the root of the app: one change of state, animated once, with a
// curve that is Design's `e = k²` (a quadratic ease-out from one to nothing).
// With Reduce Motion on the scale does not move at all; the light still fades,
// because a one-shot fade is not a loop (`iOS/FIDELITY.md`).

struct HerSiddhiLingers: ViewModifier {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var kind: HomeAfterEffect.Kind?
    /// What is left of her siddhi, 1 at the moment of leaving and 0 when gone.
    @State private var lingering: Double = 0
    /// What is left of the exposure lift.
    @State private var lift: Double = 0
    @State private var fading: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchoredLow ? .bottom : .center)
            .overlay {
                if let kind {
                    light(kind)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
            // U2 · the Router carries her after-effect across worlds.
            .onChange(of: Router.shared.afterEffect) { _, mark in
                guard let mark else { return }
                begin(HomeAfterEffect.kind(ring: mark.ring))
            }
    }

    // MARK: - The look

    /// The scale at full strength for the kind, and how much of it is left.
    private var scale: CGFloat {
        guard !reduceMotion, let kind else { return 1 }
        let full = HomeAfterEffect.look(kind: kind, age: 0).scale
        return CGFloat(1 + (full - 1) * lingering)
    }

    private var anchoredLow: Bool {
        guard let kind else { return false }
        return HomeAfterEffect.look(kind: kind, age: 0).anchoredLow
    }

    /// The light over the instrument: the Axis's lift, and the Rite's kind.
    @ViewBuilder
    private func light(_ kind: HomeAfterEffect.Kind) -> some View {
        let full = HomeAfterEffect.look(kind: kind, age: 0)
        // The lift alone, at the moment of leaving — the part that fades in 24 s.
        let liftAmount = HomeAfterEffect.exposureLift / 1.04 / 2
        let kindBrightness = full.brightness - liftAmount
        ZStack {
            Color.cream
                .opacity(liftAmount * 2 * lift)
                .blendMode(.screen)
            if kindBrightness > 0 {
                Color.cream
                    .opacity(kindBrightness * 2 * lingering)
                    .blendMode(.screen)
            } else if kindBrightness < 0 {
                Color.black
                    .opacity(-kindBrightness * 2 * lingering)
            }
            if full.contrast > 1 {
                Color.white
                    .opacity((full.contrast - 1) * 0.6 * lingering)
                    .blendMode(.softLight)
            }
        }
    }

    // MARK: - Leaving

    private func begin(_ kind: HomeAfterEffect.Kind) {
        fading?.cancel()
        var still = Transaction()
        still.disablesAnimations = true
        withTransaction(still) {
            self.kind = kind
            lingering = 1
            lift = 1
        }
        fading = Task { @MainActor in
            // One frame at full strength, so the decay has somewhere to start.
            try? await Task.sleep(nanoseconds: 50_000_000)
            guard !Task.isCancelled else { return }
            withAnimation(.timingCurve(0.333, 0.667, 0.667, 1.0, duration: HomeAfterEffect.lingers)) {
                lingering = 0
            }
            withAnimation(.linear(duration: HomeAfterEffect.liftFades)) {
                lift = 0
            }
            try? await Task.sleep(nanoseconds: UInt64(HomeAfterEffect.lingers * 1_000_000_000))
            guard !Task.isCancelled else { return }
            self.kind = nil
        }
    }
}

extension View {
    /// The after-effect of a stay in one of her rooms, on everything beneath.
    func herSiddhiLingers() -> some View {
        modifier(HerSiddhiLingers())
    }
}
