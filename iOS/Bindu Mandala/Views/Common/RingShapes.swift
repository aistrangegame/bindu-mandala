import SwiftUI

/// Equilateral triangle pointing up or down, sized by edge half-radius.
/// Shared by Ring 4 (stations), Ring 5 (overflow triangles), Ring 6 (concealed
/// triangles), Ring 8 (vertex backdrop), and the home Mandala's atmospheric
/// backdrops.
struct RingTriangle: Shape {
    let size: CGFloat
    let up: Bool

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let h = size * sqrt(3) / 2
        let half = size / 2
        var p = Path()
        if up {
            p.move(to: CGPoint(x: cx, y: cy - size))
            p.addLine(to: CGPoint(x: cx + h, y: cy + half))
            p.addLine(to: CGPoint(x: cx - h, y: cy + half))
        } else {
            p.move(to: CGPoint(x: cx, y: cy + size))
            p.addLine(to: CGPoint(x: cx + h, y: cy - half))
            p.addLine(to: CGPoint(x: cx - h, y: cy - half))
        }
        p.closeSubpath()
        return p
    }
}

extension Array {
    /// Bounds-checked subscript that returns `nil` instead of trapping.
    /// Useful for parallel arrays where index validity isn't guaranteed.
    subscript(safeIndex index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

/// English ordinal ("1st", "2nd", "3rd", "4th", …) — used by ring-world
/// captions (e.g. "the 1st of fourteen · received, and passed on").
func ringOrdinal(_ n: Int) -> String {
    let suffixes = ["th", "st", "nd", "rd"]
    let v = n % 100
    let idx = (v - 20) % 10
    let suffix: String
    if (1...3).contains(idx) {
        suffix = suffixes[idx]
    } else if (1...3).contains(v) {
        suffix = suffixes[v]
    } else {
        suffix = suffixes[0]
    }
    return "\(n)\(suffix)"
}
