import Foundation

// MARK: - The six natures of Recognition
//
// When he says "I feel her", the ceremony answers in her nature. Design drew six
// (`living-rite-core.jsx` `LR_RECOG`, and the `lrResp…` keyframes in
// `Bindu Mandala - The Living Rite.html`): fire **flares** upward, water
// **pools**, air **disperses** sideways, ether **blooms** once and holds, earth
// **settles** slow, light **radiates**. The port flattened all six into one
// scale-breath; this is the table that gives each its own motion back.
//
// Everything here is pure: numbers off Design's frames, read by
// `RecognitionMomentView` and `RecognitionLight`, and asserted in
// `RecognitionNatureTests`. Nothing here knows how often she has been felt —
// the ceremony is the same answer on the first day and the ten-thousandth.

/// How the ceremony moves when she is felt back.
enum RecognitionNature: String, CaseIterable, Equatable {
    case flare, pool, disperse, bloom, settle, radiate

    /// Her element decides her nature — one to one, never blank.
    static func of(_ element: Element) -> RecognitionNature {
        switch element {
        case .fire:  return .flare
        case .water: return .pool
        case .air:   return .disperse
        case .ether: return .bloom
        case .earth: return .settle
        case .light: return .radiate
        }
    }

    // MARK: The response — her ring's geometry and her bīja, moving

    /// One frame of the response: a drift, a scale and the light it stands at.
    /// `dx`/`dy` are points at the 390 pt reference width.
    struct Pose: Equatable {
        let dx: Double
        let dy: Double
        let scale: Double
        let opacity: Double
    }

    /// The keyframe at rest (0% and 100% of a cycle; 0% of the bloom).
    var rest: Pose {
        switch self {
        case .flare:    return Pose(dx: 0, dy: 0, scale: 1,     opacity: 0.32)
        case .pool:     return Pose(dx: 0, dy: 0, scale: 1,     opacity: 0.40)
        case .disperse: return Pose(dx: 0, dy: 0, scale: 1,     opacity: 0.30)
        case .bloom:    return Pose(dx: 0, dy: 0, scale: 0.9,   opacity: 0.30)
        case .settle:   return Pose(dx: 0, dy: 0, scale: 1,     opacity: 0.34)
        case .radiate:  return Pose(dx: 0, dy: 0, scale: 1,     opacity: 0.40)
        }
    }

    /// The keyframe at its height (50% of a cycle; 100% of the bloom, where it holds).
    var peak: Pose {
        switch self {
        case .flare:    return Pose(dx: 0,  dy: -16, scale: 1.06,  opacity: 0.58)   // fire rises
        case .pool:     return Pose(dx: 0,  dy: 0,   scale: 1.07,  opacity: 0.58)   // water widens
        case .disperse: return Pose(dx: 20, dy: 0,   scale: 1.04,  opacity: 0.52)   // air drifts sideways
        case .bloom:    return Pose(dx: 0,  dy: 0,   scale: 1.16,  opacity: 0.60)   // ether opens, once
        case .settle:   return Pose(dx: 0,  dy: 0,   scale: 1.015, opacity: 0.46)   // earth barely stirs
        case .radiate:  return Pose(dx: 0,  dy: 0,   scale: 1.05,  opacity: 0.72)   // light brightens most
        }
    }

    /// The pose a fraction of the way from rest to peak. Linear, because the
    /// curve is the animation's (ease-in-out, as Design's keyframes are), and a
    /// linear pose is what lets SwiftUI interpolate every modifier together.
    func pose(at phase: Double) -> Pose {
        let p = min(max(phase, 0), 1)
        let a = rest, b = peak
        return Pose(dx: a.dx + (b.dx - a.dx) * p,
                    dy: a.dy + (b.dy - a.dy) * p,
                    scale: a.scale + (b.scale - a.scale) * p,
                    opacity: a.opacity + (b.opacity - a.opacity) * p)
    }

    /// One whole response, rest → peak → rest (Design's `respDur`). For the
    /// bloom it is the single opening, after which it holds.
    var cycle: Double {
        switch self {
        case .flare:    return 5.5
        case .pool:     return 6.5
        case .disperse: return 6.0
        case .bloom:    return 4.8
        case .settle:   return 7.5
        case .radiate:  return 3.8
        }
    }

    /// Only the bloom happens once (`respFill: '1 forwards'`). Every other
    /// nature keeps answering for as long as the ceremony stands.
    var repeats: Bool { self != .bloom }

    /// The duration of one leg of the animation. A repeating nature autoreverses,
    /// so a leg is half its cycle; the bloom's one leg is the whole opening.
    var swing: Double { repeats ? cycle / 2 : cycle }

    /// Her bīja moves in the same manner, 1.3× slower (Design's `respDur * 1.3`),
    /// so the syllable and the geometry never lock step.
    var bijaSwing: Double { swing * 1.3 }

    // MARK: Where her light lives

    /// Where her geometry and bīja stand, as a fraction of the height (Design's `fy`).
    var focalY: Double {
        switch self {
        case .flare:    return 0.60
        case .pool:     return 0.50
        case .disperse: return 0.44
        case .bloom:    return 0.45
        case .settle:   return 0.54
        case .radiate:  return 0.44
        }
    }

    /// Where the ground's light pools, as a fraction of the height (Design's
    /// ceremony `focal`). Fire and earth are lit from the floor; the rest from
    /// near the geometry.
    var glowY: Double {
        switch self {
        case .flare:    return 0.96
        case .pool:     return 0.62
        case .disperse: return 0.40
        case .bloom:    return 0.45
        case .settle:   return 0.92
        case .radiate:  return 0.44
        }
    }

    // MARK: Ripples and motes

    /// How a ripple of recognition travels (`lrRipple`, `lrRippleRise`, `lrRippleWide`).
    enum RippleManner: Equatable { case ring, rise, wide }

    var ripple: RippleManner {
        switch self {
        case .flare:    return .rise
        case .disperse: return .wide
        default:        return .ring
        }
    }

    var rippleCount: Int {
        switch self {
        case .flare, .pool: return 4
        case .disperse, .radiate: return 5
        case .bloom: return 3
        case .settle: return 2
        }
    }

    var rippleDuration: Double {
        switch self {
        case .flare:    return 4.6
        case .pool:     return 6.4
        case .disperse: return 4.0
        case .bloom:    return 5.6
        case .settle:   return 7.6
        case .radiate:  return 3.6
        }
    }

    /// Where a ripple ends, from a 10 pt seed: its scale on each axis, how far it
    /// has risen (points at the reference width) and the light it starts at.
    struct RippleEnd: Equatable {
        let scaleX: Double
        let scaleY: Double
        let rise: Double
        let startOpacity: Double
    }

    var rippleEnd: RippleEnd {
        switch ripple {
        case .ring: return RippleEnd(scaleX: 34, scaleY: 34, rise: 0,   startOpacity: 0.5)
        case .rise: return RippleEnd(scaleX: 30, scaleY: 30, rise: 120, startOpacity: 0.55)
        case .wide: return RippleEnd(scaleX: 52, scaleY: 20, rise: 0,   startOpacity: 0.5)
        }
    }

    var motes: Int {
        switch self {
        case .flare:    return 12
        case .pool:     return 10
        case .disperse: return 14
        case .bloom:    return 10
        case .settle:   return 6
        case .radiate:  return 12
        }
    }

    // MARK: Felt back — the moment Act 2 lands

    /// The haptic that says "and she felt you back" in the body, in her manner:
    /// a spark for fire, a drop for water, a breath for air, an opening for
    /// ether, a weight for earth, a clear strike for light.
    struct Pulse: Equatable {
        enum Style: Equatable { case soft, light, medium, rigid, heavy }
        let style: Style
        let intensity: Double
    }

    var pulse: Pulse {
        switch self {
        case .flare:    return Pulse(style: .rigid,  intensity: 0.8)
        case .pool:     return Pulse(style: .soft,   intensity: 0.9)
        case .disperse: return Pulse(style: .light,  intensity: 0.7)
        case .bloom:    return Pulse(style: .soft,   intensity: 0.7)
        case .settle:   return Pulse(style: .heavy,  intensity: 0.65)
        case .radiate:  return Pulse(style: .medium, intensity: 0.8)
        }
    }

    /// How long the felt-back answer travels: the flare's tongue, the pool's
    /// spreading ring, the breath across the glass, the bloom's brightening,
    /// the ground's lift, the rays' reach.
    var answerDuration: Double {
        switch self {
        case .flare:    return 1.6
        case .pool:     return 2.4
        case .disperse: return 2.2
        case .bloom:    return 2.0
        case .settle:   return 2.8
        case .radiate:  return 1.4
        }
    }

    /// How many rays the light radiates. Only the radiating nature has rays.
    static let rayCount = 16
}

// MARK: - The ceremony's timeline

/// When each part of the ceremony arrives, in seconds from "I feel her" —
/// Design's staged arrival (`living-rite-detail.jsx` `RecognitionScreen`),
/// which supersedes the older spec's single fades.
enum RecognitionTimeline {
    /// Her name.
    static let name: Double = 0.3
    /// Her phrase, and the ghost of her bīja behind it.
    static let phrase: Double = 1.1
    /// "she was felt here".
    static let act1: Double = 2.6
    /// "and she felt you back" — the haptic, her tone, her nature's answer.
    static let act2: Double = 4.3
    /// The note and the way out, after reciprocity has landed alone.
    static let note: Double = 5.4
    /// Every staged arrival fades and rises over this long.
    static let arrive: Double = 1.4
    /// The light lifts to its full standing once she has felt him back.
    static let answerLift: Double = 1.4
    /// The ceremony gathers into the point (`lrCollapse`).
    static let collapse: Double = 0.62
    /// What stays of her light once the ceremony has gathered: a brief residue
    /// at the point, decaying, never named.
    static let afterGlow: Double = 1.8
    /// Under reduce motion the residue is still and only fades.
    static let reducedAfterGlow: Double = 1.0
    /// The debug path (`RECOGNIZE_AUTOCLOSE`) closes once the whole ceremony has landed.
    static let autoClose: Double = 6.5

    /// How far each line rises as it arrives (Design's `vis(n, dy)`), in points.
    static let nameRise: Double = 8
    static let lineRise: Double = 4
    static let noteRise: Double = 8

    /// The residue's strength `t` seconds into the after-glow: Design's
    /// after-effect curve (`riteAfterStyle`, `k²` over its duration), so it
    /// falls away fast and lingers faintly at the end. 1 at the start, 0 when done.
    static func afterGlowStrength(at t: Double, duration: Double = RecognitionTimeline.afterGlow) -> Double {
        guard duration > 0 else { return 0 }
        let k = 1 - min(max(t / duration, 0), 1)
        return k * k
    }

    /// The whole close, from the tap to the hand-off: the gathering and the residue.
    static func closeDuration(reduceMotion: Bool) -> Double {
        reduceMotion ? reducedAfterGlow : collapse + afterGlow
    }
}
