import Foundation
import CoreGraphics

// MARK: - Wave 6 · the centre is shown, never reached by doing (pure)
//
// His Codex, C-1307: *"What is above creation cannot be attained by action."*
// Waves 2–5 opened Mauna with a tap on the point and the Praveśa fall with a
// held press. Both were actions. Here the centre **notices him**: when he has
// fallen in to the innermost enclosures and stopped touching the glass for one
// breath, the silence arrives by itself; inside it, the fall deepens with the
// phone's stillness and the point opens to Lalitā when the recognition has
// come and he is still. Moving the phone loosens it; touching the glass is
// leaving. Nothing here is a clock shown to him (C-1355): every value follows
// his stillness, and none of them is ever written on the glass.
//
// Also here, the threshold's own words and figures:
//   • ``WhoIsSaying``  — "Who is saying that?" at the threshold into silence,
//                        over the colourless Maya light that dissolves when it
//                        is looked at (C-1305, C-1313).
//   • ``Pointy``       — one particle at every point at once: line → circle →
//                        ∞ → heart. "The pointy loves." (C-1306)

/// When the silence arrives at the point.
enum CentreArrival {

    /// One breath untouched — Wave 6.1: the one breath clock's own breath
    /// (``BreathClock/breath``), not a second clock of the centre's own.
    static let oneBreath: TimeInterval = BreathClock.breath

    /// How far in the glass must have fallen: the inner triangles and closer.
    static let innermostRing = 7

    /// How near the middle of the glass the point must stand, as a fraction of
    /// the glass's shorter side.
    static let nearTheMiddle: CGFloat = 0.28

    /// Whether the point notices him now.
    ///
    /// - `untouchedFor`: how long the glass has lain untouched.
    /// - `enteredRing`: the deepest enclosure the camera has fallen into.
    /// - `point` / `size`: where the Bindu stands on the glass.
    /// - `restedSinceLastMove`: he has already been in the silence since the
    ///   glass last moved — it does not arrive twice in one stillness.
    static func arrives(untouchedFor: TimeInterval, enteredRing: Int,
                        point: CGPoint, size: CGSize,
                        restedSinceLastMove: Bool) -> Bool {
        guard !restedSinceLastMove, untouchedFor >= oneBreath else { return false }
        guard enteredRing >= innermostRing else { return false }
        return isNearTheMiddle(point, size: size)
    }

    static func isNearTheMiddle(_ point: CGPoint, size: CGSize) -> Bool {
        let side = min(size.width, size.height)
        guard side > 0 else { return false }
        let d = hypot(point.x - size.width / 2, point.y - size.height / 2)
        return d <= side * nearTheMiddle
    }
}

/// How deep the silence has gone — a state that follows his stillness, never
/// the seconds he has spent in it.
///
/// `steadiness` is the phone's stillness, 0 (moving) … 1 (still), as
/// ``StillnessSensor`` reads it. While the phone is still the depth gathers;
/// when it moves, the depth recedes. Its stages are places, not marks: the Maya
/// light thins, Pointy draws, the fall begins, the recognition comes, and the
/// point opens.
struct MaunaDepth: Equatable {

    /// 0 at the threshold … 1 where the point opens.
    private(set) var depth: Double = 0
    /// How long the recognition has been whole with him still, so the point
    /// opens only after he has rested in it.
    private(set) var restedInRecognition: TimeInterval = 0

    /// How still is still enough to deepen.
    static let stillEnough: Double = 0.85
    /// The pace of deepening while still, in depth per second. The whole way
    /// takes a few slow breaths of real stillness — a pace, never a timer: any
    /// movement gives some of it back.
    static let deepening: Double = 1.0 / 48
    /// The pace at which a moving phone loosens it.
    static let loosening: Double = 1.0 / 10

    /// Where each figure lives on the way in.
    static let mayaGone: Double = 0.18
    static let pointyFrom: Double = 0.14
    static let pointyTo: Double = 0.52
    static let fallFrom: Double = 0.5
    /// How long he rests in the whole recognition before the point opens.
    static let restBeforeOpening: TimeInterval = 4

    /// Advance by `dt` seconds at this steadiness. `givenOver` is VoiceOver's
    /// accessibility action: he has said he is resting here, which stands for a
    /// still phone.
    mutating func advance(dt: TimeInterval, steadiness: Double, givenOver: Bool = false,
                          recognition: Double) {
        let h = max(0, min(0.25, dt))
        let still = givenOver || steadiness >= Self.stillEnough
        if still {
            depth = min(1, depth + h * Self.deepening)
        } else {
            depth = max(0, depth - h * Self.loosening)
        }
        if still && recognition >= 0.99 {
            restedInRecognition += h
        } else {
            restedInRecognition = 0
        }
    }

    /// How much of the colourless Maya light is still there: whole at the
    /// threshold, gone once he has looked long enough. It returns if he moves.
    var maya: Double { 1 - Self.band(depth, 0, Self.mayaGone) }

    /// How far Pointy has drawn: 0 a line … 3 the heart.
    var pointy: Double { 3 * Self.band(depth, Self.pointyFrom, Self.pointyTo) }

    /// Pointy's own light — rising in, and giving way to the fall.
    var pointyLight: Double {
        let rise = Self.band(depth, Self.pointyFrom, Self.pointyFrom + 0.06)
        let fade = 1 - Self.band(depth, Self.pointyTo + 0.04, Self.pointyTo + 0.14)
        return rise * fade
    }

    /// Whether the fall is under way: the Praveśa clock's own `holding`.
    var isFalling: Bool { depth >= Self.fallFrom }

    /// Whether the point has opened to him — the recognition whole, and he
    /// rested in it.
    var opens: Bool { restedInRecognition >= Self.restBeforeOpening }

    static func band(_ x: Double, _ lo: Double, _ hi: Double) -> Double {
        guard hi > lo else { return x >= hi ? 1 : 0 }
        return min(1, max(0, (x - lo) / (hi - lo)))
    }
}

/// The threshold's one line, his own (C-1305). Authored, never generated.
enum WhoIsSaying {
    static let line = "Who is saying that?"
    /// The line beneath it as the Maya light goes — awareness as space.
    static let beneath = "awareness is the space it is said in"
}

/// **Pointy** (C-1306): *one particle at every point at once.* The same 102
/// particles — one for each seat — draw a line, then a circle, then ∞, then a
/// heart. *"The pointy loves."* Pure: a particle's place is a function of
/// which particle it is and how far the drawing has come.
enum Pointy {

    /// One particle for each of the 102.
    static let particles = KhadgamalaMap.total

    enum Figure: Int, CaseIterable { case line, circle, infinity, heart }

    /// The words when the heart is drawn — his.
    static let loves = "the pointy loves"

    /// The figure at parameter `t` (0…1 round it), in unit coordinates centred
    /// on the point, roughly within ±1.
    static func point(_ figure: Figure, t: Double) -> CGPoint {
        let a = t * 2 * .pi
        switch figure {
        case .line:
            // Out and back along one line, so a closed walk lies on it.
            return CGPoint(x: -cos(a), y: 0)
        case .circle:
            return CGPoint(x: sin(a), y: -cos(a))
        case .infinity:
            // The lemniscate of Gerono, lying down.
            return CGPoint(x: sin(a), y: sin(a) * cos(a))
        case .heart:
            // The classic heart, normalised to about ±1, point downward on screen.
            let x = 16 * pow(sin(a), 3)
            let y = 13 * cos(a) - 5 * cos(2 * a) - 2 * cos(3 * a) - cos(4 * a)
            return CGPoint(x: x / 17, y: -y / 17)
        }
    }

    /// Where particle `i` stands when the drawing has come `progress` of the
    /// way (0 the line … 3 the heart), easing between neighbouring figures.
    static func place(particle i: Int, progress: Double) -> CGPoint {
        let n = max(1, particles)
        let t = Double(i) / Double(n)
        let p = min(3, max(0, progress))
        let lower = min(2, Int(p.rounded(.down)))
        let k = smooth(p - Double(lower))
        guard let from = Figure(rawValue: lower), let to = Figure(rawValue: lower + 1) else {
            return point(.heart, t: t)
        }
        let a = point(from, t: t), b = point(to, t: t)
        return CGPoint(x: a.x + (b.x - a.x) * k, y: a.y + (b.y - a.y) * k)
    }

    /// Which figure is whole at this progress, if any.
    static func figure(at progress: Double) -> Figure? {
        let r = progress.rounded()
        guard abs(progress - r) < 0.04 else { return nil }
        return Figure(rawValue: Int(r))
    }

    static func smooth(_ x: Double) -> Double {
        let k = min(1, max(0, x))
        return k * k * (3 - 2 * k)
    }
}
