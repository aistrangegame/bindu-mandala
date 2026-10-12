import SwiftUI

// MARK: - Wave 6 · one breath, one point, across every screen
//
// Bindu Feed's shared kit holds a single `Breath` — one clock from load, never
// restarted, that every surface reads — and a single `BinduParticle`, the same
// point at every scale, never explained. The Field breathes all 102 on one
// wall clock (`(now mod 8000)/8000`). The Mandala had many breaths: nine ring
// rates, six element periods, each reading the wall clock on its own.
//
// Integrated gently, as the brief asks. There is now **one** clock and one
// epoch. The breath is eight seconds (the Field's). Every other rhythm in the
// instrument is a *multiple of its beat* — one eighth of a breath, a second —
// read off this same clock, so the nine metabolisms keep Design's own periods
// (3 · 8 · 9 · 11 · 13 · 15 · 18 s, the Bindu at 4) and all of them return to
// rest together on the breath's own lattice. The third ring breathes exactly
// one breath; the Bindu, half of one.
enum BreathClock {

    /// One breath, in seconds — the Field's wall-clock breath.
    static let breath: Double = 8

    /// The beat every period is a multiple of: an eighth of a breath.
    static var beat: Double { breath / 8 }

    /// The epoch every screen shares: the reference date, so the phase is the
    /// same on every screen at the same instant, across launches.
    static func seconds(at date: Date) -> TimeInterval { date.timeIntervalSinceReferenceDate }

    /// 0 → 1 → 0 across one period, eased like CSS `ease-in-out` breath.
    static func phase(at t: TimeInterval, period: Double) -> Double {
        guard period > 0 else { return 0 }
        return (1 - cos(2 * .pi * t / period)) / 2
    }

    /// The one breath itself, 0 → 1 → 0 over eight seconds.
    static func breathPhase(at date: Date) -> Double {
        phase(at: seconds(at: date), period: breath)
    }

    /// A period expressed in beats (`multiple` × the beat).
    static func period(beats multiple: Double) -> Double { max(0, multiple) * beat }

    /// A Score's tempo applied to a grammar period: its own breath if it gives
    /// one, else the grammar's period divided by its rate — always snapped to
    /// the beat, so it still lands on the one clock's lattice.
    static func period(grammar: Double, score: ShaktiScore.Tempo?) -> Double {
        var p = grammar
        if let b = score?.breath { p = b }
        else if let r = score?.rate, r > 0 { p = grammar / r }
        let snapped = (p / beat).rounded() * beat
        return max(beat, snapped)
    }
}

/// The one point. Never explained, never a measurable circle: a small warm
/// light that breathes on the one clock — the same point on the Portrait, the
/// Book, the Month Mirror and the heart register.
struct BinduPoint: View {
    var size: CGFloat = 10
    var color: Color = Color.accentRed
    /// When false the point is held still (reduce motion, a held frame).
    var breathes: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let still = !breathes || reduceMotion
        TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: still)) { tl in
            let b = still ? 0.5 : BreathClock.breathPhase(at: tl.date)
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [color.opacity(0.55 + 0.25 * b), .clear],
                                         center: .center, startRadius: 0,
                                         endRadius: size * (1.6 + 0.5 * b)))
                    .frame(width: size * 4, height: size * 4)
                    .blendMode(.plusLighter)
                Circle()
                    .fill(Color.cream)
                    .frame(width: size * (0.42 + 0.08 * b), height: size * (0.42 + 0.08 * b))
                    .shadow(color: Color.cream.opacity(0.6), radius: size * 0.6)
            }
        }
        .frame(width: size * 4, height: size * 4)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
