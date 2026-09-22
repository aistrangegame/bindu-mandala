import SwiftUI

/// Motes of temple air — element-expressive. Fire rises, water falls, air drifts,
/// earth holds still and only breathes, ether/light twinkle. Coloured from her
/// atmosphere (gold every third, else her bright accent). Ported from `LrMotes`.
/// Respects `prefers-reduced-motion`.
///
/// Backward compatible: `DustMotesView(count:)` still works and reads as gold
/// rising motes (the historical Today behaviour) unless an element/accent is given.
struct DustMotesView: View {
    var count: Int = 9
    var element: Element = .fire      // .fire == rise, the original behaviour
    var accent: Color = .gold
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// How a mote of this element moves.
    enum Motion { case rise, fall, drift, still, twinkle }

    private var motion: Motion {
        switch element {
        case .fire:            return .rise
        case .water:           return .fall
        case .air:             return .drift
        case .earth:           return .still
        case .ether, .light:   return .twinkle
        }
    }

    private struct Mote: Identifiable {
        let id: Int
        let xFrac: Double
        let yFrac: Double
        let size: CGFloat
        let baseOpacity: Double
        let duration: Double
        let delay: Double
        let isGold: Bool
    }

    private let motes: [Mote]

    init(count: Int = 9, element: Element = .fire, accent: Color = .gold) {
        self.count = count
        self.element = element
        self.accent = accent
        self.motes = (0..<count).map { i in
            // Two decorrelated pseudo-random streams per mote (as in the prototype).
            let seed = Double((i * 733 + 97) % 1000) / 1000
            let seed2 = Double((i * 397 + 211) % 1000) / 1000
            return Mote(
                id: i,
                xFrac: 0.04 + seed * 0.92,
                yFrac: 0.06 + seed2 * 0.88,
                size: 1.5 + CGFloat(seed) * 2.2,
                baseOpacity: 0.20 + seed2 * 0.35,
                duration: 9 + seed * 14,
                delay: seed2 * 20,
                isGold: i % 3 == 0
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(motes) { m in
                    MoteView(mote: m, motion: motion,
                             color: m.isGold ? .gold : accent,
                             width: geo.size.width, height: geo.size.height,
                             reduceMotion: reduceMotion)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private struct MoteView: View {
        let mote: Mote
        let motion: Motion
        let color: Color
        let width: CGFloat
        let height: CGFloat
        let reduceMotion: Bool
        @State private var phase: Double = 0

        var body: some View {
            let travel = offset(for: phase)
            Circle()
                .fill(color)
                .frame(width: mote.size, height: mote.size)
                .scaleEffect(scale(for: phase))
                .opacity(opacity(for: phase))
                .shadow(color: color.opacity(0.5), radius: mote.size * 2)
                .position(x: mote.xFrac * width + travel.x,
                          y: mote.yFrac * height + travel.y)
                .onAppear { follow() }
                .onChange(of: reduceMotion) { _, _ in follow() }
        }

        /// The one place a mote's loop is started or stopped.
        ///
        /// Reduce motion switched on *mid-session* has to replace an animation
        /// that is already running: a plain assignment would be picked up by the
        /// repeat still in flight and simply animate to the new value, and the
        /// mote would go on moving until the screen was left. Setting the still
        /// phase inside a transaction with animations disabled removes the
        /// repeat outright. Switched back off, the loop starts again from the
        /// same place it always did.
        private func follow() {
            guard !reduceMotion else {
                var stop = Transaction()
                stop.disablesAnimations = true
                withTransaction(stop) { phase = 0.5 }
                return
            }
            var restart = Transaction()
            restart.disablesAnimations = true
            withTransaction(restart) { phase = 0 }
            // rise/fall loop one direction; drift/still/twinkle breathe.
            let autoreverse = (motion == .drift || motion == .still || motion == .twinkle)
            withAnimation(.linear(duration: mote.duration)
                .repeatForever(autoreverses: autoreverse)
                .delay(mote.delay)) {
                phase = 1
            }
        }

        /// Local travel from the mote's anchor, by element.
        private func offset(for p: Double) -> CGPoint {
            switch motion {
            case .rise:  return CGPoint(x: 0, y: 24 - p * 134)          // 24 → -110
            case .fall:  return CGPoint(x: 0, y: -16 + p * 86)          // -16 → 70
            case .drift: return CGPoint(x: p * 34, y: p * -14)          // wander (autoreversed)
            case .still, .twinkle: return .zero
            }
        }

        private func scale(for p: Double) -> Double {
            guard motion == .twinkle else { return 1 }
            return 0.8 + p * 0.35                                        // 0.8 → 1.15
        }

        private func opacity(for p: Double) -> Double {
            switch motion {
            case .rise, .fall:
                // Fade in fast, hold, fade out — an envelope over the one-way loop.
                let env: Double
                if p < 0.14 { env = p / 0.14 }
                else if p > 0.86 { env = (1 - p) / 0.14 }
                else { env = 1 }
                return mote.baseOpacity * env
            case .drift:
                return mote.baseOpacity
            case .still:
                return 0.18 + p * 0.24                                   // 0.18 ↔ 0.42
            case .twinkle:
                return 0.12 + p * 0.43                                   // 0.12 ↔ 0.55
            }
        }
    }
}
