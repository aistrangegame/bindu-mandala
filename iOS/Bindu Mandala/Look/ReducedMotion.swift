import SwiftUI

// MARK: - U1 · Look · Reduce Motion (visual.md §1.13)
//
// Settled scoping (C21, laws 16 and 19): **decorative loops pause; mechanisms
// stretch; holds keep their length.** The Living Rite's `* { animation: none }`
// and the Concept Board's frozen-at-62 s are rejected — they disable the
// mechanism. Every function here is pure; a view passes in
// `@Environment(\.accessibilityReduceMotion)`.

/// What each class of motion becomes under Reduce Motion. Implements
/// `visual.md` §1.13 "Reduce Motion".
enum ReducedMotion {

    /// The seven classes of §1.13.
    enum Kind: CaseIterable {
        /// Motes, twinkle, shimmer, sigil spin, drift, world glow, page breath.
        case decorativeLoop
        /// Her Home's and the Rite of Entering's adaptation.
        case adaptation
        /// The breath of the point and the yantra.
        case breath
        /// Veil, Descent, blink, flood, passage.
        case crossing
        /// Holds and gates.
        case hold
        /// The Climb's flight, the deep zoom.
        case cameraFlight
        /// Clause by clause, sharpen.
        case textReveal
    }

    /// A decorative loop is paused on a mid-flight frame
    /// (`TimelineView(.animation(paused: reduceMotion))`); nothing else pauses.
    static func pauses(_ kind: Kind, reduceMotion: Bool) -> Bool {
        reduceMotion && kind == .decorativeLoop
    }

    // MARK: Adaptation — quantized and longer, never frozen

    /// Adaptation `a` moves in 4 steps, `b` in 3.
    static let adaptationASteps = 4
    static let adaptationBSteps = 3
    /// Seconds under Reduce Motion: adapt 160 · hold 190 · second 150.
    static let adaptSeconds: Double = 160
    static let holdSeconds: Double = 190
    static let secondSeconds: Double = 150

    /// A continuous 0…1 value moved in `steps` discrete steps (it still reaches 1).
    static func quantize(_ x: Double, steps: Int) -> Double {
        guard steps > 0 else { return x }
        let v = min(max(x, 0), 1)
        return (v * Double(steps)).rounded(.down) / Double(steps)
    }

    // MARK: Breath — an opacity step each half-period, period unchanged

    /// The breath under Reduce Motion: no scale; full for the first half of
    /// each period, then `1 / peak` for the second — the same breath, as light.
    static func breathOpacity(at t: TimeInterval, period: Double, peak: Double) -> Double {
        guard period > 0, peak > 0 else { return 1 }
        let local = t.truncatingRemainder(dividingBy: period)
        let pos = local < 0 ? local + period : local
        return pos < period / 2 ? 1 : 1 / peak
    }

    // MARK: Crossings and flights — a 0.2 s cross-fade, silent

    static let crossFadeSeconds: Double = 0.2

    /// A crossing's duration: its own, or the 0.2 s cross-fade.
    static func crossingDuration(_ designed: Double, reduceMotion: Bool) -> Double {
        reduceMotion ? crossFadeSeconds : designed
    }

    /// A crossing is silent under Reduce Motion.
    static func crossingSounds(reduceMotion: Bool) -> Bool { !reduceMotion }

    /// The type still changes at the cross-fade's midpoint.
    static func typeSwapFraction(reduceMotion: Bool) -> Double {
        reduceMotion ? 0.5 : LookMotion.typeSwapFraction
    }

    // MARK: Holds — the same length; the ring fills in 4 steps

    static let holdRingSteps = 4

    static func holdDuration(_ designed: Double, reduceMotion: Bool) -> Double { designed }

    static func holdProgress(_ p: Double, reduceMotion: Bool) -> Double {
        reduceMotion ? quantize(p, steps: holdRingSteps) : min(max(p, 0), 1)
    }

    // MARK: Text — appears whole, in order

    static func revealsWhole(reduceMotion: Bool) -> Bool { reduceMotion }

    /// The animation a class of motion runs with: nil (no animation) for the
    /// classes that cut or appear whole, a 0.2 s ease for crossings and flights.
    static func animation(_ kind: Kind, designed: Animation, reduceMotion: Bool) -> Animation? {
        guard reduceMotion else { return designed }
        switch kind {
        case .crossing, .cameraFlight: return .easeInOut(duration: crossFadeSeconds)
        case .hold:                    return designed
        case .decorativeLoop, .breath, .textReveal, .adaptation: return nil
        }
    }
}
