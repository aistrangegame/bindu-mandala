import Foundation

// MARK: - The approach: the walker's own distance from her room
//
// The rite of entering is not a screen shown before a room — it is the crossing
// toward one, and the three beats are three stretches of that crossing
// (handoff §4.5, the thread: *"The rite IS the distance."*). This file is the
// distance half: where the walker stands, and how that changes when he touches.
//
// It is deliberately in `Homes/Render/` rather than with the rite. A room has to
// know how to be looked at from outside itself, and every later way in — the
// doors of §4.7, which begin the crossing *from where you stand*, and the
// descent of §4.6 — is the same motion with a different reason. The ceremony
// that happens *during* the crossing is the rite's; the crossing is the room's.
//
// ─────────────────────────────────────────────────────────────────────────────
// A CLOSED FORM, NOT A FRAME LOOP
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's Axis moves the walker with a per-frame lerp — `trav += (travTo -
// trav) * 0.03` — which is an exponential approach sampled at 60 Hz. Written as
// the exponential it already is, the walker's distance becomes a pure function
// of the clock, exactly as ``RoomPose`` is. Three things follow, and all three
// matter more than the arithmetic:
//
//   * it can be **asserted** without a renderer, at any instant;
//   * the reduce-motion path can stand still at a station rather than being a
//     frame loop that has been slowed down;
//   * a dropped frame cannot change where the walker ends up, only when he is
//     seen to get there. The Axis's lerp is frame-rate dependent and drifts.
//
// Design's own rates are kept as the rates — `0.03`, and `0.018` under reduced
// motion — and the time constant is derived from them rather than chosen, so
// the motion is Design's motion and the derivation is visible.

/// How far the walker has come toward her room, as a function of the clock.
///
/// `0` is the far end of the approach — one body-height behind where he will
/// stand, ``RoomUnits/approachStandOff`` — and `1` is standing in the room.
struct RoomApproach: Equatable {

    /// How the crossing between two points is shaped.
    enum Motion: Equatable {
        /// Design's per-frame lerp toward a station, as the exponential it is.
        /// It closes on its target and never quite arrives, which is what makes
        /// a station feel like a place the walker has come to rest rather than
        /// a mark he has hit.
        case easing(tau: TimeInterval)
        /// The release, on the third touch: what is left of the distance,
        /// crossed at a steady rate, so the walker genuinely arrives.
        case steady(seconds: TimeInterval)
        /// Standing still. The reduce-motion path's whole motion vocabulary.
        case still
    }

    /// Where the walker stood when this stretch began.
    var from: Double
    /// Where this stretch is taking him.
    var to: Double
    /// When it began, on the reference-date clock.
    var since: TimeInterval
    var motion: Motion

    /// Where the walker stands at an instant.
    func value(at now: TimeInterval) -> Double {
        let elapsed = max(0, now - since)
        switch motion {
        case .still:
            return to
        case .easing(let tau):
            guard tau > 0 else { return to }
            return to - (to - from) * exp(-elapsed / tau)
        case .steady(let seconds):
            guard seconds > 0 else { return to }
            return from + (to - from) * min(1, elapsed / seconds)
        }
    }

    /// How long this stretch takes to complete, where it completes at all.
    /// An easing stretch never formally arrives, so it has no duration — which
    /// is why the release is the one stretch that is not one.
    var duration: TimeInterval? {
        if case .steady(let seconds) = motion { return seconds }
        return nil
    }
}

// MARK: - Design's own rates, and the stations they carry the walker between

extension RoomApproach {

    /// Design's per-frame lerp rate toward a station, `homes/The Homes - The
    /// Axis.html`: `trav += (travTo - trav) * (reduced ? 0.018 : 0.03)`.
    static let ratePerFrame: Double = 0.03
    static let reducedRatePerFrame: Double = 0.018

    /// The frame rate that per-frame rate was written against.
    static let framesPerSecond: Double = 60

    /// The seconds it takes a per-frame lerp to close to `1/e` of its distance.
    ///
    /// Derived rather than chosen: after `n` frames a lerp of rate `r` has
    /// `(1 - r)^n` of the distance left, and `exp(-t / tau)` is the same curve
    /// when `tau = -1 / (fps · ln(1 - r))`. Design's `0.03` is therefore
    /// `0.547 s`, and `0.018` is `0.918 s`.
    static func tau(ratePerFrame rate: Double) -> TimeInterval {
        guard rate > 0, rate < 1 else { return 0 }
        return -1 / (framesPerSecond * log(1 - rate))
    }

    /// The release, on the third touch. Design's `trav += dt / (reduced ? 3.4 :
    /// 2.2)` — and it is deliberately **not** compressed by her memory: the
    /// ceremony softens on a return, the distance to her does not.
    static let releaseSeconds: TimeInterval = 2.2
    static let reducedReleaseSeconds: TimeInterval = 3.4

    /// Standing at one place, going nowhere.
    static func standing(at place: Double) -> RoomApproach {
        RoomApproach(from: place, to: place, since: 0, motion: .still)
    }

    /// Standing in her room, the approach over.
    static let arrived = RoomApproach.standing(at: 1)

    /// The next stretch of the crossing, toward a station.
    ///
    /// Under reduced motion the walker **steps** to the station rather than
    /// gliding to it: Design's invariant 4 asks for reduced motion to be
    /// *"longer and quantized, never disabled"*, and `iOS/FIDELITY.md` — which
    /// the charter names as standing law — forbids the loop a glide would need.
    /// Quantized satisfies both, and it is the same reading the render spine
    /// already took for the room itself (`RoomView`'s header).
    static func crossing(from here: Double,
                         to station: Double,
                         at now: TimeInterval,
                         reduceMotion: Bool) -> RoomApproach {
        guard !reduceMotion else { return .standing(at: station) }
        return RoomApproach(from: here, to: station, since: now,
                            motion: .easing(tau: tau(ratePerFrame: ratePerFrame)))
    }

    /// The last stretch, on the third touch: whatever is left, crossed steadily.
    ///
    /// Under reduced motion it is the same step the stations take — he is
    /// simply inside.
    static func releasing(from here: Double,
                          at now: TimeInterval,
                          reduceMotion: Bool) -> RoomApproach {
        guard !reduceMotion else { return .arrived }
        return RoomApproach(from: here, to: 1, since: now,
                            motion: .steady(seconds: releaseSeconds(remaining: 1 - here,
                                                                    reduceMotion: false)))
    }

    /// How long the release takes from where the walker stands. The whole
    /// crossing is Design's `2.2` seconds, so what is left of it is that much
    /// of the remaining distance — a walker who has come most of the way does
    /// not wait out the whole of it again.
    static func releaseSeconds(remaining: Double, reduceMotion: Bool) -> TimeInterval {
        let whole = reduceMotion ? reducedReleaseSeconds : releaseSeconds
        return whole * min(1, max(0, remaining))
    }
}

// MARK: - What the room's own driver reads

/// The walker's distance, held where the room's driver can read it every frame.
///
/// A reference on purpose. The rite owns the approach and changes it on a
/// touch — three times in a whole ceremony — while the room's driver reads it
/// sixty times a second on SceneKit's thread. Passing it as a value would mean
/// re-rendering the SwiftUI tree every frame to move the eye, which is the one
/// thing a render spine must never need.
///
/// `@unchecked Sendable` for the same reason ``RoomClock`` is: a `Double` and a
/// small struct of them, written on the main thread at a touch and read on the
/// render thread, with no ordering requirement between the two — the worst a
/// race can do is show the walker one frame of the stretch he was on a moment
/// ago.
final class RoomApproachSource: @unchecked Sendable {

    private(set) var approach: RoomApproach

    init(_ approach: RoomApproach = .arrived) {
        self.approach = approach
    }

    /// Standing at the far end of the crossing, before the first beat.
    static func atTheDoor() -> RoomApproachSource {
        RoomApproachSource(.standing(at: 0))
    }

    func set(_ approach: RoomApproach) {
        self.approach = approach
    }

    func value(at now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> Double {
        approach.value(at: now)
    }
}
