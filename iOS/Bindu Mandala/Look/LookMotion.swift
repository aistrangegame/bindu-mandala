import SwiftUI

// MARK: - U1 · Look · motion, pace and space (visual.md §1.4 "Shared motion constants")
//
// The named curves every world moves on (rupakarshini R13:834–846, ported in
// `visual.md` §1.4), the three pace pairs, the space scale and the base
// durations. A curve is a cubic-bezier and a duration; `animation` is the
// SwiftUI value. Reduce Motion is not decided here — `ReducedMotion` says what
// each class of motion becomes (§1.13).

/// One cubic-bezier curve with its designed duration. Implements `visual.md`
/// §1.4 (motion constants).
struct MotionCurve: Equatable {
    let name: String
    let c1x: Double
    let c1y: Double
    let c2x: Double
    let c2y: Double
    /// Seconds.
    let duration: Double

    var animation: Animation { .timingCurve(c1x, c1y, c2x, c2y, duration: duration) }

    /// The same curve at another duration (a board hop, a world arriving in beats).
    func animation(duration d: Double) -> Animation { .timingCurve(c1x, c1y, c2x, c2y, duration: d) }

    func with(duration d: Double) -> MotionCurve {
        MotionCurve(name: name, c1x: c1x, c1y: c1y, c2x: c2x, c2y: c2y, duration: d)
    }
}

/// The shared motion constants (§1.4 table). Implements `visual.md` §1.4.
enum LookMotion {
    /// Everyday crossing into a light world.
    static let veilLight = MotionCurve(name: "veilLight", c1x: 0.22, c1y: 0.61, c2x: 0.36, c2y: 1, duration: 1.05)
    /// The bloom inside a light Veil crossing.
    static let veilLightBloom = MotionCurve(name: "veilLightBloom", c1x: 0.16, c1y: 1, c2x: 0.3, c2y: 1, duration: 1.05)
    /// Crossing into a dark world.
    static let veilDark = MotionCurve(name: "veilDark", c1x: 0.5, c1y: 0, c2x: 0.15, c2y: 1, duration: 1.5)
    /// Home → Well, Home → Beneath, the first entry beneath; the deep zoom per enclosure step.
    static let descent = MotionCurve(name: "descent", c1x: 0.66, c1y: 0, c2x: 0.24, c2y: 1, duration: 2.35)
    /// Launch.
    static let waking = MotionCurve(name: "waking", c1x: 0.22, c1y: 1, c2x: 0.3, c2y: 1, duration: 2.85)
    /// Return after time away.
    static let surfacing = MotionCurve(name: "surfacing", c1x: 0.22, c1y: 0.61, c2x: 0.36, c2y: 1, duration: 0.95)
    /// Paper sheets, cards.
    static let sheetRise = MotionCurve(name: "sheetRise", c1x: 0.22, c1y: 1, c2x: 0.36, c2y: 1, duration: 1.1)
    /// The Leela board's hop (sheetRise at 0.55 s).
    static let boardHop = sheetRise.with(duration: 0.55)
    /// Verbs, mode arrivals.
    static let verb = MotionCurve(name: "verb", c1x: 0.16, c1y: 1, c2x: 0.3, c2y: 1, duration: 0.6)
    /// A world arriving in beats (the verb curve at 1.1 s).
    static let verbWorld = verb.with(duration: 1.1)
    /// The blink crossing (Home → Rite).
    static let blinkLids = MotionCurve(name: "blinkLids", c1x: 0.62, c1y: 0.02, c2x: 0.4, c2y: 1, duration: 0.66)
    /// Light reaching text.
    static let lightReach = MotionCurve(name: "lightReach", c1x: 0.2, c1y: 0.7, c2x: 0.2, c2y: 1, duration: 2.6)
    /// Names arriving (1.4–1.8 s; 1.6 designed).
    static let nameFade = MotionCurve(name: "nameFade", c1x: 0.25, c1y: 0.1, c2x: 0.25, c2y: 1, duration: 1.6)
    /// Small UI (0.25 s default).
    static let rkOut = MotionCurve(name: "rkOut", c1x: 0.22, c1y: 0.61, c2x: 0.36, c2y: 1, duration: 0.25)
    /// `rkOut(d)` — small UI at another duration.
    static func rkOutLasting(_ d: Double) -> MotionCurve { rkOut.with(duration: d) }
    /// Reveals (height 0.5 s + opacity 0.4 s).
    static let soft = MotionCurve(name: "soft", c1x: 0.4, c1y: 0, c2x: 0.2, c2y: 1, duration: 0.5)
    static let softOpacityDuration = 0.4

    /// Every named curve, for the parity test.
    static let all: [MotionCurve] = [veilLight, veilLightBloom, veilDark, descent, waking, surfacing,
                                     sheetRise, verb, blinkLids, lightReach, nameFade, rkOut, soft]

    // MARK: Base durations (R13:686–691)

    static let fast = 0.15
    static let base = 0.25
    static let slow = 0.5
    /// A hold's base duration in the studio scale (the hold *engine* is Part D's).
    static let hold = 0.7

    // MARK: The crossing as the eye meets it (§1.2, §1.15)

    /// "Dark first, then the room": 0.4 s at the destination's deep ground …
    static let darkFirst = 0.4
    /// … then a 1.4 s rise of its light.
    static let roomRise = 1.4
    /// Type changes only at the crossing's hold frame: 45 % of the duration.
    static let typeSwapFraction = 0.45
    /// A crossing is light (Veil-light) when the destination ground's luminance
    /// is above this, else dark (§5 Doors).
    static let lightGroundLuminance = 0.5

    /// The Veil variant for a destination ground (§5): light 1.05 s or dark 1.5 s.
    static func veil(into ground: LookColor) -> MotionCurve {
        Contrast.luminance(ground) > lightGroundLuminance ? veilLight : veilDark
    }
}

/// The three pace pairs (R13:847): a duration and a rise in points. Implements
/// `visual.md` §1.4 "Pace pairs".
enum LookPace: CaseIterable {
    case still, measured, quick

    var duration: Double {
        switch self {
        case .still:    return 0.5
        case .measured: return 0.25
        case .quick:    return 0.18
        }
    }

    var rise: CGFloat {
        switch self {
        case .still:    return 16
        case .measured: return 24
        case .quick:    return 32
        }
    }
}

/// The space scale `[4, 8, 12, 16, 24, 32, 48, 64, 96]` and the layout numbers
/// §1.4 / §2 #40 name. Implements `visual.md` §1.4 "Space scale" and §2 #40.
enum LookSpace {
    static let scale: [CGFloat] = [4, 8, 12, 16, 24, 32, 48, 64, 96]

    /// Step `i` of the scale (0 → 4 pt … 8 → 96 pt), clamped.
    static func step(_ i: Int) -> CGFloat { scale[min(max(i, 0), scale.count - 1)] }

    /// The yantra keeps at least this much negative space (§1.4.1).
    static let yantraNegativeSpace: CGFloat = 200
    static let statusBar: CGFloat = 60
    static let safeTop: CGFloat = 54
    /// Bottom scroll fade.
    static let bottomScrollFade: CGFloat = 28
    /// Reading measure, characters.
    static let readingMeasure = 60
}
