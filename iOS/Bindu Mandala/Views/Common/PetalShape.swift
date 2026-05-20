import SwiftUI

/// One lotus petal — a cubic-bezier almond pointing straight up from the
/// origin. Drawn so that the rect's center is the lotus center; the petal
/// occupies the upper half (negative Y in the path math).
///
/// Use `frame(width: diameter, height: diameter)` then `.rotationEffect` to
/// place each of the 16 petals around the wheel.
struct PetalShape: Shape {
    /// Outer radius as fraction of frame width (default per DESIGN_SPEC).
    var outerRatio: CGFloat = 0.435
    /// Inner radius (petal base) as fraction of frame width.
    var innerRatio: CGFloat = 0.117
    /// Half-width as fraction of frame width.
    var halfWidthRatio: CGFloat = 0.087

    func path(in rect: CGRect) -> Path {
        let d = min(rect.width, rect.height)
        let cx = rect.midX
        let cy = rect.midY
        let outerR = d * outerRatio
        let innerR = d * innerRatio
        let hw = d * halfWidthRatio

        // All Y values are negative (above center) because the petal points up.
        var p = Path()
        let base = CGPoint(x: cx, y: cy - innerR)
        let tip  = CGPoint(x: cx, y: cy - outerR)

        p.move(to: base)
        // Right side: base → tip
        p.addCurve(
            to: tip,
            control1: CGPoint(x: cx + hw,        y: cy - innerR * 1.85),
            control2: CGPoint(x: cx + hw * 0.95, y: cy - outerR * 0.85)
        )
        // Left side: tip → base
        p.addCurve(
            to: base,
            control1: CGPoint(x: cx - hw * 0.95, y: cy - outerR * 0.85),
            control2: CGPoint(x: cx - hw,        y: cy - innerR * 1.85)
        )
        p.closeSubpath()
        return p
    }
}

/// Larger outer ghost petal — used for the 8 locked avaraṇas surrounding
/// the lotus. Same overall shape but pushed outward.
struct GhostPetalShape: Shape {
    var innerRatio: CGFloat = 0.479  // outerR * 1.10
    var outerRatio: CGFloat = 0.574  // outerR * 1.32
    var halfWidthRatio: CGFloat = 0.052

    func path(in rect: CGRect) -> Path {
        let d = min(rect.width, rect.height)
        let cx = rect.midX
        let cy = rect.midY
        let outerR = d * outerRatio
        let innerR = d * innerRatio
        let hw = d * halfWidthRatio

        var p = Path()
        let base = CGPoint(x: cx, y: cy - innerR)
        let tip  = CGPoint(x: cx, y: cy - outerR)

        p.move(to: base)
        p.addCurve(
            to: tip,
            control1: CGPoint(x: cx + hw * 0.6, y: cy - outerR * 0.91),
            control2: CGPoint(x: cx + hw * 0.5, y: cy - outerR * 0.97)
        )
        p.addCurve(
            to: base,
            control1: CGPoint(x: cx - hw * 0.5, y: cy - outerR * 0.97),
            control2: CGPoint(x: cx - hw * 0.6, y: cy - outerR * 0.91)
        )
        p.closeSubpath()
        return p
    }
}
