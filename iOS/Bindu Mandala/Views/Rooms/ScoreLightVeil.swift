import SwiftUI

/// Wave 6 · her live Score, laid over the grammar's room: the light it names
/// (a hue, how much glow stands in her air) breathing at the tempo it names,
/// read through the one breath clock. A Score that says nothing about light
/// draws nothing — the room is the grammar's, whole. It never takes a touch.
struct ScoreLightVeil: View {
    let position: Int
    let reduceMotion: Bool

    @State private var score: ShaktiScore? = nil
    @State private var read = false

    /// The grammar's own room breath this tempo is laid on (seconds).
    static let grammarBreath: Double = 8

    var body: some View {
        Group {
            if let s = score, let hue = s.light.hue {
                let glow = s.light.glow ?? 0.5
                let period = BreathClock.period(grammar: Self.grammarBreath, score: s.breathing)
                TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: reduceMotion)) { tl in
                    let b = reduceMotion ? 0.5 : BreathClock.phase(at: BreathClock.seconds(at: tl.date),
                                                                    period: period)
                    let colour = HSL(h: hue, s: 70, l: 60).color()
                    RadialGradient(colors: [colour.opacity(0.10 + 0.28 * glow * (0.6 + 0.4 * b)), .clear],
                                   center: UnitPoint(x: 0.5, y: 0.42),
                                   startRadius: 0, endRadius: 360 + 80 * b)
                        .blendMode(.plusLighter)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            guard !read else { return }
            read = true
            score = ShaktiFactsCache.score(position)
        }
    }
}
