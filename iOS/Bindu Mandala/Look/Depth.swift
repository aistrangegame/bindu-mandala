import SwiftUI

// MARK: - U1 · Look · depth: chrome thins, colour warms (visual.md §1.8, §1.9)
//
// rupakarshini's laws 5 and 6, and his Zero Gap (C-1307): *action recedes with
// depth* — labels at the outer ring, none at the centre — and the point warms
// from gold at the surface to ember red at the centre. Both are pure functions
// of one number, the depth of the place the eye is in.

/// The five depth steps and the chrome each keeps: **100 → 80 → 60 → 25 → 0 %**.
/// Implements `visual.md` §1.8 "Interfaces thin with depth".
enum ChromeStep: Int, CaseIterable, Comparable {
    case surface = 0
    case one = 1
    case two = 2
    case three = 3
    case centre = 4

    static func < (a: ChromeStep, b: ChromeStep) -> Bool { a.rawValue < b.rawValue }

    /// The chrome's opacity at this step.
    var chromeOpacity: Double {
        switch self {
        case .surface: return 1.0
        case .one:     return 0.8
        case .two:     return 0.6
        case .three:   return 0.25
        case .centre:  return 0.0
        }
    }

    /// The depth (0 surface … 1 centre) this step stands for.
    var depth: Double { Double(rawValue) / 4 }

    /// The nearest step to a depth 0…1 (a point's depth from §1.10 → its chrome).
    static func forDepth(_ d: Double) -> ChromeStep {
        let i = Int((min(max(d, 0), 1) * 4).rounded())
        return ChromeStep(rawValue: i) ?? .surface
    }

    /// Zero Gap (C-1307): labels stand at the outer rings and none at the centre.
    var showsLabels: Bool { self != .centre }

    /// At 0 % a faint "surface" mark remains: cream at α .25, still a 44 pt target.
    static let surfaceMarkOpacity = 0.25
    /// Touch anywhere brings the chrome back for 4 s.
    static let wakeSeconds: Double = 4

    // MARK: The table (§1.8)

    /// A world's chrome at rest (where it has one step). Worlds that step inside
    /// themselves read the functions below.
    static func atRest(_ world: WorldID) -> ChromeStep {
        switch world {
        case .home:         return .centre   // Home is the Bindu (depth 1)
        case .today:        return .one
        case .mandala:      return .surface  // "Mandala at whole instrument"
        case .rings:        return ring(1)
        case .herHome:      return .three
        case .herPresence:  return .two
        case .climb:        return climb(band: 1)
        case .the33:        return .one      // the 33 index; a room is `.two`
        case .game:         return .surface
        case .modes:        return .surface
        case .time:         return .surface
        case .memory:       return .surface
        case .well:         return .three
        case .beneath:      return forDepth(PointLook.forWorld(.beneath).depth)
        case .relationship: return .surface
        }
    }

    /// Ring n's chrome: R1 100 · R2–3 80 · R4–5 60 · R6–8 25 · R9 0 (§1.8, §1.4.4).
    static func ring(_ n: Int) -> ChromeStep {
        switch n {
        case ...1:  return .surface
        case 2, 3:  return .one
        case 4, 5:  return .two
        case 6...8: return .three
        default:    return .centre
        }
    }

    /// The Climb by band: 1–3 → 80 · 4–6 → 60 · 7–8 → 25 · the summit → 0.
    static func climb(band: Int) -> ChromeStep {
        switch band {
        case ...3:  return .one
        case 4...6: return .two
        case 7, 8:  return .three
        default:    return .centre
        }
    }

    /// A room of the 33 sits one step in from the index.
    static let the33Room: ChromeStep = .two
    /// Beneath's deepest band and the deep zoom are the centre.
    static let deepest: ChromeStep = .centre
}

/// The point's colour by depth: `mix(oklab, gold #C9963F, ember #C0392B, depth)`
/// — depth 0 `#C9963F` · .25 `#C9813A` · .5 `#C76B35` · .75 `#C45430` · 1
/// `#C0392B`. Implements `visual.md` §1.9 "Colour warms to ember red at the centre".
enum DepthColour {
    static let gold = LookColor(hex: "#C9963F")
    static let ember = LookColor(hex: "#C0392B")
    /// At the Bindu the point *is* ember, on its crimson ground.
    static let binduGround = LookColor(hex: "#8B1A2A")

    static func point(depth: Double) -> LookColor {
        OKLab.mix(gold, ember, depth)
    }
}

// MARK: - Chrome in a view

extension View {
    /// Chrome at its depth step (§1.8). `awake` is true for the four seconds
    /// after any touch in the world (`wakesChrome`), when the chrome stands at
    /// 100 % whatever the depth. At 0 % the chrome takes no touches (the spine's
    /// surface mark and the left-edge drag still leave).
    func chromeDepth(_ step: ChromeStep, awake: Bool = false,
                     reduceMotion: Bool = false) -> some View {
        let o = awake ? 1 : step.chromeOpacity
        return self
            .opacity(o)
            .allowsHitTesting(o > 0)
            .animation(reduceMotion ? nil : LookMotion.soft.animation, value: o)
    }

    /// Put on a world's root: any touch sets `awake` for `ChromeStep.wakeSeconds`
    /// and lets it sink again after. Never consumes the touch.
    func wakesChrome(_ awake: Binding<Bool>) -> some View {
        modifier(ChromeWake(awake: awake))
    }
}

/// The touch-anywhere wake for thinned chrome (§1.8: "Touch anywhere brings
/// chrome back for 4 s").
struct ChromeWake: ViewModifier {
    @Binding var awake: Bool
    @State private var generation = 0

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0).onChanged { _ in wake() }
        )
    }

    private func wake() {
        if !awake { awake = true }
        generation &+= 1
        let mine = generation
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(ChromeStep.wakeSeconds * 1_000_000_000))
            if mine == generation { awake = false }
        }
    }
}
