import Foundation
import CoreGraphics

/// The pure geometry of the Portrait as the Living Mandala (Wave 5).
///
/// His strokes are drawn into the Portrait and mirrored n-fold by the ring he
/// draws them in: a ring is mirrored by as many as sit in it — twenty-eight in
/// the Bhūpura, sixteen in the petal ring, eight, fourteen in the triangles,
/// ten, ten, twelve (the Vāk ring), three, and the Bindu is one. The count is a
/// fact about the yantra, never about him.
///
/// Coordinates are **unit coordinates**: the Portrait's centre is (0, 0) and
/// its edge is radius 1 (the 344-pt artwork's half-width, 172). That is what is
/// stored, so a stroke drawn on one screen size is the same stroke on another
/// and in the exported Record.
enum LivingMandala {

    /// The Portrait's ring radii on its own 344-pt base (`PortraitPoint.radiusBase`),
    /// outermost first, the Bindu last.
    static let ringRadiiBase: [Double] = [158, 123, 95, 78, 65, 52, 40, 26, 0]
    static let halfBase: Double = 172

    /// How many seats the ring holds — and so how many ways his stroke is mirrored.
    static func folds(forRing ring: Int) -> Int {
        guard (1...9).contains(ring) else { return 1 }
        if ring == 9 { return 1 }
        return KhadgamalaMap.ringStartOffset(ring + 1) - KhadgamalaMap.ringStartOffset(ring)
    }

    /// The ring a point at unit radius `r` belongs to: the ring whose circle it
    /// is nearest, with the boundaries halfway between neighbouring circles.
    static func ring(atUnitRadius r: Double) -> Int {
        let base = r * halfBase
        let radii = ringRadiiBase
        for i in 0..<(radii.count - 1) {
            let boundary = (radii[i] + radii[i + 1]) / 2
            if base > boundary { return i + 1 }
        }
        return 9
    }

    static func ring(of point: CGPoint) -> Int {
        ring(atUnitRadius: Double(hypot(point.x, point.y)))
    }

    /// The `folds` rotated copies of a stroke about the centre, the first being
    /// the stroke itself.
    static func copies(of points: [CGPoint], folds: Int) -> [[CGPoint]] {
        let n = max(1, folds)
        return (0..<n).map { k in
            let a = 2 * Double.pi * Double(k) / Double(n)
            let c = CGFloat(cos(a))
            let s = CGFloat(sin(a))
            return points.map { p in CGPoint(x: p.x * c - p.y * s, y: p.x * s + p.y * c) }
        }
    }

    /// A stroke thinned as it is captured: a point closer than `spacing` (unit)
    /// to the last one kept adds nothing, and a stroke never holds more than
    /// `cap` points. The last point is always kept, so the stroke ends where his
    /// finger did.
    static func thinned(_ points: [CGPoint], spacing: CGFloat = 0.008, cap: Int = 256) -> [CGPoint] {
        guard let first = points.first else { return [] }
        var out: [CGPoint] = [first]
        for p in points.dropFirst() {
            guard let last = out.last else { continue }
            if hypot(p.x - last.x, p.y - last.y) >= spacing { out.append(p) }
        }
        if let end = points.last, out.last != end { out.append(end) }
        if out.count > cap {
            let step = Double(out.count - 1) / Double(cap - 1)
            out = (0..<cap).map { out[min(out.count - 1, Int((Double($0) * step).rounded()))] }
        }
        return out
    }

    // MARK: The year, accreting

    /// The days he practised in `year`, as the start of each local day, oldest
    /// first — one bead each. A day he did not practise has **no slot at all**:
    /// the ring is always whole, and it grows denser, never emptier.
    static func practiceDays(_ instants: [Date], inYearOf reference: Date,
                             calendar: Calendar = .current) -> [Date] {
        let year = calendar.component(.year, from: reference)
        var days = Set<Date>()
        for t in instants where calendar.component(.year, from: t) == year {
            days.insert(calendar.startOfDay(for: t))
        }
        return days.sorted()
    }

    /// Bead `index` of `total` sits at this angle (radians, 12 o'clock = −π/2,
    /// clockwise) — evenly round the whole circle, so there is never a gap.
    static func beadAngle(index: Int, total: Int) -> Double {
        guard total > 0 else { return -Double.pi / 2 }
        return 2 * Double.pi * Double(index) / Double(total) - Double.pi / 2
    }
}
