import Foundation
import CoreGraphics

// MARK: - Upgrade U1 · A · the crossing library
//
// `waves/upgrade/worlds/spine-and-home.md` §2 H #54–#58 and G #52, with the
// motion curves of `waves/upgrade/worlds/visual.md` §1.4 ("Shared motion
// constants"). Law 4: every crossing passes through something — never a slide,
// never a hard swap. U1 builds the portal bloom (#55) in full and the Descent
// (#56) and the blink (#57) minimally; the rest of the library is declared with
// its numbers and drawn as the bloom until its own world builds it (U2+).
//
// Every number below is quoted from the world file it comes from;
// `U1RouterTests` reads the world files and holds these constants to them.

/// How one world is left for another — `spine-and-home.md` §2 H #54.
struct Crossing: Equatable {

    /// The crossing library (#54).
    enum Kind: String, Codable, CaseIterable {
        /// Within a world: dissolve .28 s.
        case dissolve
        /// Between worlds: through the point, blooming from the touch in the
        /// colour of the world entered (#55) — the everyday crossing.
        case bloom
        /// The Veil bloom into light, 1.05 s (#54; `visual.md` veilLight).
        case veilLight
        /// The Veil bloom into dark, 1.5 s (#54; `visual.md` veilDark).
        case veilDark
        /// Paper lifts, dark wells up — 2.35 s (#56): Home → the Well, Home →
        /// Beneath, the first entry to any room beneath.
        case descent
        /// The blink into the Rite — lids .66 s, the Rite opens at 780 ms (#57).
        case blink
        /// Wormhole in, white hole out — 5.4 s (#58). Declared; drawn as the bloom in U1.
        case passage
        /// Hold, and the circle becomes the room — ×40 (#59). Declared; drawn as the bloom in U1.
        case pulseGate
        /// The yantra blooms out of the point into the Mandala (#31). Declared; drawn as the bloom in U1.
        case spanda
        /// The deep zoom into the Bindu (#27). Declared; drawn as the bloom in U1.
        case pravesha
        /// Back after time away: the departed colour covers, the jump happens
        /// under it, and it settles over 900 ms (#52).
        case returnBloom

        /// U1 draws this kind with its own figure (the rest fall back to the bloom).
        var isDrawnInU1: Bool {
            switch self {
            case .bloom, .descent, .blink, .dissolve, .returnBloom: return true
            default: return false
            }
        }
    }

    var kind: Kind
    /// Where the touch was, in window coordinates. Nil: from the point at
    /// Home's centre (W/2, 0.46·H — `spine-and-home.md` §1 "Being there").
    var origin: CGPoint?

    init(kind: Kind, origin: CGPoint? = nil) {
        self.kind = kind
        self.origin = origin
    }

    static func bloom(from origin: CGPoint? = nil) -> Crossing { Crossing(kind: .bloom, origin: origin) }
    static func descent(from origin: CGPoint? = nil) -> Crossing { Crossing(kind: .descent, origin: origin) }
    static func blink(from origin: CGPoint? = nil) -> Crossing { Crossing(kind: .blink, origin: origin) }
    static let dissolve = Crossing(kind: .dissolve)

    // MARK: The numbers

    /// #55: Gather (.30 s) — the world he leaves draws toward the point (×.96).
    static let gatherSeconds = 0.30
    /// #55: the gathering world's scale.
    static let gatherScale = 0.96
    /// #55: Bloom (.72 s).
    static let bloomSeconds = 0.72
    /// #55: the destination mounts at .62 s of the bloom.
    static let bloomMountSeconds = 0.62
    /// #55: the radial opens to 2.6 × the larger side.
    static let bloomReach = 2.6
    /// #54: within a world, dissolve .28 s.
    static let dissolveSeconds = 0.28
    /// #54: Veil bloom into light 1.05 s / into dark 1.5 s.
    static let veilLightSeconds = 1.05
    static let veilDarkSeconds = 1.5
    /// #56: the Descent, 2.35 s.
    static let descentSeconds = 2.35
    /// #56: the dark plane has risen fully at 55 % (and the haptic lands there).
    static let descentSeam = 0.55
    /// #57: the lids grow 0 → 50 % over .66 s.
    static let blinkLidSeconds = 0.66
    /// #57: the seam glints after .3 s, for .5 s.
    static let blinkGlintDelay = 0.3
    static let blinkGlintSeconds = 0.5
    /// #57: the Rite opens at 780 ms.
    static let blinkOpenSeconds = 0.78
    /// #58: the passage, 5.4 s; its landing smear .75 s.
    static let passageSeconds = 5.4
    static let passageLandingSeconds = 0.75
    /// #52: going back within 45 min plays the return bloom, which settles over 900 ms.
    static let returnWindowMinutes = 45.0
    static let returnSettleSeconds = 0.9
    /// #55: reduced motion — a .2 s cross-fade.
    static let reducedSeconds = 0.2

    // MARK: Curves (`visual.md` §1.4, shared motion constants)

    /// `Animation.timingCurve(c1x, c1y, c2x, c2y, duration:)` — and its value,
    /// for drawing by hand inside a `TimelineView`.
    struct Curve: Equatable {
        let c1x: Double, c1y: Double, c2x: Double, c2y: Double

        /// `veilLight`'s bloom curve (0.16, 1, 0.3, 1).
        static let bloom = Curve(c1x: 0.16, c1y: 1, c2x: 0.3, c2y: 1)
        /// `veilLight` (0.22, 0.61, 0.36, 1), also `rkOut` and `surfacing`.
        static let veilLight = Curve(c1x: 0.22, c1y: 0.61, c2x: 0.36, c2y: 1)
        /// `veilDark` (0.5, 0, 0.15, 1).
        static let veilDark = Curve(c1x: 0.5, c1y: 0, c2x: 0.15, c2y: 1)
        /// `descent` (0.66, 0, 0.24, 1).
        static let descent = Curve(c1x: 0.66, c1y: 0, c2x: 0.24, c2y: 1)
        /// `blinkLids` (0.62, 0.02, 0.4, 1).
        static let blinkLids = Curve(c1x: 0.62, c1y: 0.02, c2x: 0.4, c2y: 1)
        static let linear = Curve(c1x: 0, c1y: 0, c2x: 1, c2y: 1)

        /// The eased value at progress `x` in 0…1 (solves the cubic Bézier for x).
        func value(at x: Double) -> Double {
            let x = min(1, max(0, x))
            if x == 0 || x == 1 { return x }
            func bez(_ t: Double, _ p1: Double, _ p2: Double) -> Double {
                let u = 1 - t
                return 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t
            }
            var lo = 0.0, hi = 1.0, t = x
            for _ in 0..<40 {
                let bx = bez(t, c1x, c2x)
                if abs(bx - x) < 1e-7 { break }
                if bx < x { lo = t } else { hi = t }
                t = (lo + hi) / 2
            }
            return bez(t, c1y, c2y)
        }
    }

    /// The clock of one crossing.
    struct Timing: Equatable {
        /// Seconds from the touch to the last frame.
        let total: Double
        /// Seconds from the touch to the moment the destination is mounted in
        /// place of the world left (one world at a time, never two).
        let mountAt: Double
        /// Seconds of the gather beat before the figure opens (the bloom's .30 s).
        let gather: Double
        let curve: Curve
        /// Drawn as the reduced-motion cross-fade.
        let isReduced: Bool
    }

    /// The clock for this crossing (reduced motion: the .2 s cross-fade).
    func timing(reduceMotion: Bool = false) -> Timing {
        if reduceMotion {
            return Timing(total: Self.reducedSeconds, mountAt: Self.reducedSeconds / 2,
                          gather: 0, curve: .linear, isReduced: true)
        }
        switch kind {
        case .dissolve:
            return Timing(total: Self.dissolveSeconds, mountAt: 0, gather: 0, curve: .veilLight, isReduced: false)
        case .bloom, .pulseGate, .spanda, .pravesha:
            return Self.bloomTiming
        case .veilLight:
            // Assumption (report): the veil mounts where the portal does, at
            // .62/.72 of its span.
            let s = Self.veilLightSeconds
            return Timing(total: s, mountAt: s * Self.bloomMountSeconds / Self.bloomSeconds,
                          gather: 0, curve: .veilLight, isReduced: false)
        case .veilDark:
            let s = Self.veilDarkSeconds
            return Timing(total: s, mountAt: s * Self.bloomMountSeconds / Self.bloomSeconds,
                          gather: 0, curve: .veilDark, isReduced: false)
        case .descent:
            return Timing(total: Self.descentSeconds, mountAt: Self.descentSeconds * Self.descentSeam,
                          gather: 0, curve: .descent, isReduced: false)
        case .blink:
            // Assumption (report): after the Rite opens at 780 ms the lids part
            // again over the same .66 s.
            return Timing(total: Self.blinkOpenSeconds + Self.blinkLidSeconds, mountAt: Self.blinkOpenSeconds,
                          gather: 0, curve: .blinkLids, isReduced: false)
        case .passage:
            return Timing(total: Self.passageSeconds,
                          mountAt: Self.passageSeconds - Self.passageLandingSeconds,
                          gather: 0, curve: .linear, isReduced: false)
        case .returnBloom:
            // The jump happens under the cover at once; the cover settles.
            return Timing(total: Self.returnSettleSeconds, mountAt: 0, gather: 0,
                          curve: .veilLight, isReduced: false)
        }
    }

    static let bloomTiming = Timing(total: gatherSeconds + bloomSeconds,
                                    mountAt: gatherSeconds + bloomMountSeconds,
                                    gather: gatherSeconds, curve: .bloom, isReduced: false)

    // MARK: Keyframes (#55, #56), in Design's own notation

    /// #55 into light: bloom opacity 0 → .95@14% → .5@62% → 0.
    static let bloomOpacity = Keyframes([(0, 0), (0.14, 0.95), (0.62, 0.5), (1, 0)])
    /// #55 into light: scale .04 → .16@14% → 1@62% → 1.35.
    static let bloomScale = Keyframes([(0, 0.04), (0.14, 0.16), (0.62, 1), (1, 1.35)])
    /// #55: the radial's fill stops — .95 at the centre, .55 at 32 %, clear at 68 %.
    static let bloomFillStops: [(location: Double, opacity: Double)] = [(0, 0.95), (0.32, 0.55), (0.68, 0)]
    /// #56: the ember, scale .45 → 1@13% → 1.18@55% → 1@76% → .7.
    static let descentEmberScale = Keyframes([(0, 0.45), (0.13, 1), (0.55, 1.18), (0.76, 1), (1, 0.7)])
    /// #56: the ember, 0 → 1@13%, held.
    static let descentEmberOpacity = Keyframes([(0, 0), (0.13, 1), (1, 1)])
    /// #56: the dark plane, translateY 104% → hold 9% → 0@55%.
    static let descentPlaneOffset = Keyframes([(0, 1.04), (0.09, 1.04), (0.55, 0), (1, 0)])
    /// #56: the ember's size, 11 pt, and the Well's ember colour (`visual.md` §1.4.13).
    static let descentEmberPoints = 11.0
    static let descentEmberHex = "#F3B05A"
    /// #56: the dark plane's radial — #14100A, #0A0806 at 55 %, #060402.
    static let descentPlaneHexes = ["#14100A", "#0A0806", "#060402"]
}

/// A piecewise-linear track over progress 0…1 — Design's keyframe lists.
struct Keyframes: Equatable {
    let stops: [Stop]

    struct Stop: Equatable {
        let at: Double
        let value: Double
    }

    init(_ pairs: [(Double, Double)]) {
        stops = pairs.map { Stop(at: $0.0, value: $0.1) }
    }

    func value(at t: Double) -> Double {
        guard let first = stops.first, let last = stops.last else { return 0 }
        if t <= first.at { return first.value }
        if t >= last.at { return last.value }
        for i in 1..<stops.count where t <= stops[i].at {
            let a = stops[i - 1], b = stops[i]
            let span = b.at - a.at
            guard span > 0 else { return b.value }
            return a.value + (b.value - a.value) * (t - a.at) / span
        }
        return last.value
    }

    /// Design's own notation: `.04 → .16@14% → 1@62% → 1.35` — so a test can
    /// find these very words in the world file.
    var designNotation: String {
        var words: [String] = []
        for (i, s) in stops.enumerated() {
            let v = Self.number(s.value)
            if i == 0 || i == stops.count - 1 {
                words.append(v)
            } else {
                words.append("\(v)@\(Int((s.at * 100).rounded()))%")
            }
        }
        return words.joined(separator: " → ")
    }

    static func number(_ v: Double) -> String {
        if v == v.rounded() { return String(Int(v)) }
        var s = String(format: "%.3f", v)
        while s.hasSuffix("0") { s.removeLast() }
        if s.hasPrefix("0.") { s.removeFirst() }
        return s
    }
}
