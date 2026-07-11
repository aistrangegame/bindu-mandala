import SwiftUI

/// A hue/saturation/lightness triple — the seed the Atmosphere engine derives a
/// whole per-Śakti palette from. Pure and `Equatable` so derivations are testable
/// against reference numbers. `h` in [0,360), `s`/`l` in [0,100].
struct HSL: Equatable {
    var h: Double
    var s: Double
    var l: Double

    /// HSL → RGB in [0,1]. Standard piecewise conversion.
    var rgb: (r: Double, g: Double, b: Double) {
        let sN = s / 100, lN = l / 100
        let c = (1 - abs(2 * lN - 1)) * sN
        let hp = h / 60
        let x = c * (1 - abs(hp.truncatingRemainder(dividingBy: 2) - 1))
        let m = lN - c / 2
        let (r1, g1, b1): (Double, Double, Double)
        switch Int(hp) {
        case 0:  (r1, g1, b1) = (c, x, 0)
        case 1:  (r1, g1, b1) = (x, c, 0)
        case 2:  (r1, g1, b1) = (0, c, x)
        case 3:  (r1, g1, b1) = (0, x, c)
        case 4:  (r1, g1, b1) = (x, 0, c)
        default: (r1, g1, b1) = (c, 0, x)
        }
        return (r1 + m, g1 + m, b1 + m)
    }

    func color(alpha: Double = 1) -> Color {
        let (r, g, b) = rgb
        return Color(red: r, green: g, blue: b, opacity: alpha)
    }

    /// Wrap a hue into [0,360).
    static func wrap(_ hue: Double) -> Double {
        let m = hue.truncatingRemainder(dividingBy: 360)
        return m < 0 ? m + 360 : m
    }

    static func clamp(_ v: Double, _ lo: Double, _ hi: Double) -> Double {
        min(max(v, lo), hi)
    }
}
