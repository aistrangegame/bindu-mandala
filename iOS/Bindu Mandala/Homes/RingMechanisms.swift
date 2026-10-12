import Foundation

// MARK: - Wave 6 · Slice E — the Ring Worlds mechanisms not yet reborn
//
// Wave 2 brought four of the Ring Worlds' mechanisms home inside the climb's
// own lights (Ring 3 scatters, Ring 6 follows, Ring 7's chord, Ring 8's three
// gliding into one). These are the rest, as the same kind of pure offsets on
// a light's place, so the climb's scene adds them exactly as it adds Wave 2's:
//
//   • **Ring 1 · the Earth-City** — held still, the twenty-eight settle onto
//     the Bhūpura's three squares, family by family: the Siddhis on the outer
//     line, the Mātṛkās on the middle, the Mudrās on the inner.
//   • **Ring 2 · the lotus following the sun** — the sixteen open with the
//     day and close at night (`LotusSun`, from Wave 5's ephemeris). Pressing a
//     petal still flies into her, as every light does.
//   • **Ring 4 · Sampradāya, the lineage** — held still, a teaching travels
//     round the fourteen, teacher to student, each light lifting as it passes.
//   • **Ring 5 · Kulottīrṇa, the overflow** — held still, the ten swell past
//     the circle that holds them, light spilling over its boundary.
//   • **Ring 8 · the vertex collapse** — touching one of the three, the other
//     two collapse into it as the flight carries him in: three becoming one
//     becoming none, dissolving into her.
//
// Every offset is zero at rest, so the climb stands exactly as Wave 2 built
// it until a hand asks.

extension ClimbLights {

    /// Ring 1's three families by position (Design's `R1_FAMILY`): 1–10
    /// Siddhis, 11–18 Mātṛkās, 19–28 Mudrās — the outer, middle and inner
    /// lines of the Bhūpura.
    static func earthFamily(kp: Int) -> (line: Int, index: Int, size: Int)? {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 1 else { return nil }
        let i = KhadgamalaMap.perRingIndex(forKhadgamala: kp)
        if i <= 10 { return (0, i - 1, 10) }
        if i <= 18 { return (1, i - 11, 8) }
        return (2, i - 19, 10)
    }

    /// A point `u` (0 … 1) of the way round a square of half-side `h`,
    /// starting at the top middle and going clockwise.
    static func squarePoint(_ u: Double, half h: Double) -> (x: Double, z: Double) {
        let t = (u - floor(u)) * 8          // eight half-sides
        switch t {
        case ..<1:  return (t * h, -h)
        case ..<3:  return (h, -h + (t - 1) * h)
        case ..<5:  return (h - (t - 3) * h, h)
        case ..<7:  return (-h, h - (t - 5) * h)
        default:    return (-h + (t - 7) * h, -h)
        }
    }

    /// **Ring 1 — the Earth-City.** `settle` 0 … 1.
    static func earthCity(kp: Int, settle: Double) -> SIMD3<Double> {
        guard let f = earthFamily(kp: kp), settle > 0 else { return .zero }
        let r = ringRadius(1)
        let half = r * [0.92, 0.70, 0.48][f.line]
        let q = squarePoint(Double(f.index) / Double(max(1, f.size)), half: half)
        let p = position(kp: kp)
        let target = SIMD3(q.x, p.y, ringCentreZ + q.z)
        return (target - p) * clamp01(settle)
    }

    /// **Ring 2 — the lotus following the sun.** `openness` 0 … 1, where 1
    /// is the lotus as Wave 2 stood it (full noon) and less draws the petals in.
    static func lotus(kp: Int, openness: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 2 else { return .zero }
        let close = 1 - clamp01(openness)
        guard close > 0 else { return .zero }
        let a = angle(kp: kp)
        let inward = -ringRadius(2) * 0.45 * close
        return SIMD3(cos(a) * inward, 0.6 * unit * close, sin(a) * inward)
    }

    /// **Ring 4 — the lineage.** `wave` is where the teaching has reached,
    /// in seats round the ring; `glow` 0 … 1 how strongly it travels.
    static func lineage(kp: Int, wave: Double, glow: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 4, glow > 0 else { return .zero }
        let n = Double(seatsInRing(4))
        let i = Double(KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1)
        var d = abs((i - wave).truncatingRemainder(dividingBy: n))
        d = min(d, n - d)
        let lift = exp(-d * d / 0.9) * 1.1 * unit * clamp01(glow)
        return SIMD3(0, lift, 0)
    }

    /// How fast the teaching travels: one seat in this many seconds.
    static let lineageSecondsPerSeat: Double = 0.6

    /// **Ring 5 — the overflow.** `fullness` 0 … 1.
    static func overflow(kp: Int, fullness: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 5, fullness > 0 else { return .zero }
        let a = angle(kp: kp)
        let k = clamp01(fullness)
        let outward = ringRadius(5) * 0.6 * k
        return SIMD3(cos(a) * outward, sin(Double(kp) * 1.3) * 0.5 * unit * k, sin(a) * outward)
    }

    /// **Ring 8 — the vertex collapse.** The two lights that were not touched
    /// draw into the one that was, by `amount` 0 … 1.
    static func collapse(kp: Int, into vertex: Int, amount: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 8,
              KhadgamalaMap.ringNumber(forKhadgamala: vertex) == 8,
              kp != vertex, amount > 0 else { return .zero }
        return (position(kp: vertex) - position(kp: kp)) * (0.96 * clamp01(amount))
    }

    /// Every Wave 6 mechanism at once, for the scene's `placed`.
    static func wholeMechanisms(kp: Int, settle: Double, openness: Double,
                                lineageWave: Double, lineageGlow: Double,
                                overflow fullness: Double,
                                collapseInto vertex: Int?, collapse amount: Double) -> SIMD3<Double> {
        var out = earthCity(kp: kp, settle: settle)
        out += lotus(kp: kp, openness: openness)
        out += lineage(kp: kp, wave: lineageWave, glow: lineageGlow)
        out += overflow(kp: kp, fullness: fullness)
        if let v = vertex { out += collapse(kp: kp, into: v, amount: amount) }
        return out
    }

    /// Settle, lineage and overflow rise under a still hand and ease back.
    static let stillHandRise: Double = 1.2
    static let stillHandSettle: Double = 2.0
}
