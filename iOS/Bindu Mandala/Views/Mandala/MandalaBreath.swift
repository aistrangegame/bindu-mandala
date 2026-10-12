import Foundation

// MARK: - Nine metabolisms, one shimmer
//
// Wave 1 · Slice A. `mandala-v2.jsx`'s header says it in three lines: *"Nine
// rings. Nine metabolisms. The ground does not breathe — it holds. The center
// never stopped calling."* Its stylesheet (`Mandala App v2.html`) is the table:
//
//   ring 1  the Bhūpura          — no animation: the earth underfoot holds
//   ring 2  the home lotus       — 3 s   (ring2TodayBreathe)
//   ring 3  the eight petals     — 8 s   (ring3PetalBreathe)
//   ring 4  triangles            — 9 s   (lockR4)
//   ring 5  triangles            — 11 s  (lockR5)
//   ring 6  triangles            — 13 s  (lockR6)
//   ring 7  triangles            — 15 s  (lockR7)
//   ring 8  the mūla trikoṇa     — 18 s  (deepGhostTri)
//   ring 9  the Bindu            — 4 s   (mandalaBinduBreathe)
//
// and each ring's lift is the ratio of its own keyframes (lockR4 0.15 → 0.22
// is a 47% lift; the deep ghost 0.028 → 0.052 is 86%). Over all of it,
// `living-rite-mandala.jsx` lays one **8 s shimmer** (`syShimmer`, 0.82 ↔ 1),
// and the Bindu swells **×1.28** (`syBinduBreath`).
//
// Pure arithmetic of the clock, so the whole table is testable off-device. It
// knows a ring and a time and nothing else — no count, no visit, nothing the
// walker has done.

enum MandalaBreath {

    /// Seconds per breath for an āvaraṇa, or `nil` where the ring holds.
    ///
    /// Ring 1 holds — *"the ground does not breathe"* — and anything outside
    /// 1–9 holds too, rather than inventing a tenth metabolism.
    static func period(ring: Int) -> TimeInterval? {
        switch ring {
        case 2: return 3
        case 3: return 8
        case 4: return 9
        case 5: return 11
        case 6: return 13
        case 7: return 15
        case 8: return 18
        case 9: return 4
        default: return nil
        }
    }

    /// How far a ring's light lifts at the top of its breath, as a fraction of
    /// its resting light — the ratio of Design's own keyframes for that ring.
    static func lift(ring: Int) -> Double {
        switch ring {
        case 2: return 0.28     // 0.78 → 1.0
        case 3: return 0.70     // 0.17 → 0.29
        case 4: return 0.47     // 0.15 → 0.22
        case 5: return 0.50     // 0.10 → 0.15
        case 6: return 0.57     // 0.07 → 0.11
        case 7: return 0.55     // 0.045 → 0.07
        case 8: return 0.86     // 0.028 → 0.052
        case 9: return 0.33     // the Bindu's glow, 0.75 → 1.0
        default: return 0
        }
    }

    /// Where a ring is in its breath, 0 at rest and 1 at the full inhale —
    /// CSS `ease-in-out` between 0% and 50% approximated by a raised cosine,
    /// which is what an ease-in-out keyframe pair looks like over a loop.
    ///
    /// `offset` is a fraction of a breath, so neighbours can breathe a little
    /// apart (Design's `animationDelay`) without ever changing their rate.
    ///
    /// Under reduce motion the breath is held **at its middle** — the light a
    /// ring has on average, standing still — rather than at rest, so asking for
    /// less motion never costs the light.
    static func phase(ring: Int, at t: TimeInterval, offset: Double = 0,
                      reduceMotion: Bool = false) -> Double {
        guard let p = period(ring: ring) else { return 0 }
        if reduceMotion { return 0.5 }
        let cycles = t / p + offset
        return 0.5 - 0.5 * cos(2 * .pi * cycles)
    }

    /// A ring's light multiplier at time `t`: 1 at rest, `1 + lift` at the top.
    static func gain(ring: Int, at t: TimeInterval, offset: Double = 0,
                     reduceMotion: Bool = false) -> Double {
        1 + lift(ring: ring) * phase(ring: ring, at: t, offset: offset, reduceMotion: reduceMotion)
    }

    // MARK: - The shimmer

    /// `syShimmer`: the whole yantra between 0.82 and 1, every 8 s.
    static let shimmerPeriod: TimeInterval = 8
    static let shimmerFloor: Double = 0.82

    /// The shimmer's strength at `t`, in 0.82…1. Under reduce motion: 1 —
    /// paused at its brightest, so the light is kept and only the motion goes.
    static func shimmer(at t: TimeInterval, reduceMotion: Bool = false) -> Double {
        if reduceMotion { return 1 }
        let x = 0.5 - 0.5 * cos(2 * .pi * t / shimmerPeriod)
        return shimmerFloor + (1 - shimmerFloor) * x
    }

    // MARK: - The Bindu

    /// `syBinduBreath`'s swell: the point grows to ×1.28 at the top of its breath.
    static let binduSwell: Double = 1.28

    /// The Bindu's scale at `t` (1…1.28), on the ninth ring's 4 s breath.
    /// Under reduce motion it rests at 1 and its glow stays lit.
    static func binduScale(at t: TimeInterval, reduceMotion: Bool = false) -> Double {
        if reduceMotion { return 1 }
        return 1 + (binduSwell - 1) * phase(ring: 9, at: t)
    }

    // MARK: - The seats

    /// `syBreath`: each seat swells to ×1.22 at the top of her breath.
    static let seatSwell: Double = 0.22

    /// A seat's breath. She breathes at **her enclosure's** rate — the field
    /// moves as nine metabolisms, not as a hundred and two random clocks — and
    /// her khaḍgamālā position sets only where in that breath she is, so
    /// sisters ripple round their ring rather than heaving as one. A seat on
    /// the Bhūpura holds, as its ground does.
    static func seatScale(ring: Int, kp: Int, at t: TimeInterval,
                          reduceMotion: Bool = false) -> Double {
        if reduceMotion { return 1 }
        let offset = Double(kp % 16) / 16.0
        return 1 + seatSwell * phase(ring: ring, at: t, offset: offset)
    }
}
