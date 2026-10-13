import SwiftUI

// MARK: - U1 · Look · colour arithmetic (visual.md §1.4.4, §1.9, §1.14)
//
// The upgrade's colour law is written in oklab: a ring's wash is
// `mix(oklab, #0D0508 80 %, ring 20 %)`, the point warms `mix(oklab, gold,
// ember, depth)`, an accent too dim to be text is lifted toward cream in oklab
// until it reads at 4.5:1. `Atmosphere` blends in sRGB (an approximation its
// own comment owns); this file is the exact arithmetic the upgrade's tables
// were computed with, so every number in visual.md can be reproduced and
// asserted (`U1LookTests`).
//
// Pure value types only — nothing here draws.

/// One sRGB colour with alpha, every channel 0…1. The Look's colour currency:
/// tokens are written as hex in the world file and parsed here once.
///
/// Implements `visual.md` §1.4 (tokens as values) and §1.14 (contrast measured
/// against the pixels actually behind the glyph).
struct LookColor: Equatable, Hashable {
    var r: Double
    var g: Double
    var b: Double
    var a: Double = 1

    /// `#RRGGBB` or `#RRGGBBAA`. Anything else is black — a token typo shows as
    /// black on the glass and fails every contrast test, so it cannot hide.
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        switch s.count {
        case 6:
            r = Double((v >> 16) & 0xFF) / 255
            g = Double((v >> 8) & 0xFF) / 255
            b = Double(v & 0xFF) / 255
            a = 1
        case 8:
            r = Double((v >> 24) & 0xFF) / 255
            g = Double((v >> 16) & 0xFF) / 255
            b = Double((v >> 8) & 0xFF) / 255
            a = Double(v & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }
    }

    init(r: Double, g: Double, b: Double, a: Double = 1) {
        self.r = r; self.g = g; self.b = b; self.a = a
    }

    /// A hex token at an opacity (`rgba(240,232,220,.92)` is `LookColor(hex:
    /// "#F0E8DC", alpha: 0.92)`).
    init(hex: String, alpha: Double) {
        self.init(hex: hex)
        a = alpha
    }

    init(_ hsl: HSL, alpha: Double = 1) {
        let c = hsl.rgb
        self.init(r: c.r, g: c.g, b: c.b, a: alpha)
    }

    /// `#RRGGBB`, upper case, alpha dropped (rounded per channel as CSS does).
    var hex: String {
        func byte(_ v: Double) -> Int { Int((min(max(v, 0), 1) * 255).rounded()) }
        return String(format: "#%02X%02X%02X", byte(r), byte(g), byte(b))
    }

    var color: Color { Color(.sRGB, red: r, green: g, blue: b, opacity: a) }

    func opacity(_ alpha: Double) -> LookColor { LookColor(r: r, g: g, b: b, a: alpha) }

    /// This colour laid over an opaque `ground` (sRGB source-over — what the
    /// glass shows). An opaque colour returns itself.
    func over(_ ground: LookColor) -> LookColor {
        guard a < 1 else { return LookColor(r: r, g: g, b: b) }
        return LookColor(r: r * a + ground.r * (1 - a),
                         g: g * a + ground.g * (1 - a),
                         b: b * a + ground.b * (1 - a))
    }
}

// MARK: - OKLab (visual.md §2 #7 "new OKLab mix helper")

/// Björn Ottosson's oklab — the space CSS `color-mix(in oklab, …)` interpolates
/// in, which every mix in the upgrade's tables uses. Implements `visual.md`
/// §1.4.4 (wash / deep), §1.9 (the point's depth colour), §1.14 (readable).
enum OKLab {

    struct Lab: Equatable {
        var L: Double
        var a: Double
        var b: Double
    }

    private static func linear(_ c: Double) -> Double {
        c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
    }

    private static func gamma(_ c: Double) -> Double {
        c <= 0.0031308 ? 12.92 * c : 1.055 * pow(c, 1 / 2.4) - 0.055
    }

    private static func cbrt(_ x: Double) -> Double {
        x < 0 ? -pow(-x, 1.0 / 3.0) : pow(x, 1.0 / 3.0)
    }

    static func lab(_ c: LookColor) -> Lab {
        let r = linear(c.r), g = linear(c.g), b = linear(c.b)
        let l = cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b)
        let m = cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b)
        let s = cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b)
        return Lab(L: 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
                   a: 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
                   b: 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s)
    }

    /// Back to sRGB, gamut-clipped per channel (as the browser does when a mix
    /// lands just outside sRGB).
    static func color(_ o: Lab, alpha: Double = 1) -> LookColor {
        let l = pow(o.L + 0.3963377774 * o.a + 0.2158037573 * o.b, 3)
        let m = pow(o.L - 0.1055613458 * o.a - 0.0638541728 * o.b, 3)
        let s = pow(o.L - 0.0894841775 * o.a - 1.2914855480 * o.b, 3)
        let r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
        let g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
        let b = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
        func clip(_ v: Double) -> Double { gamma(min(max(v, 0), 1)) }
        return LookColor(r: clip(r), g: clip(g), b: clip(b), a: alpha)
    }

    /// `color-mix(in oklab, a (1 − t), b t)` — `t` is the share of `b`.
    static func mix(_ a: LookColor, _ b: LookColor, _ t: Double) -> LookColor {
        let x = lab(a), y = lab(b)
        let k = min(max(t, 0), 1)
        return color(Lab(L: x.L + (y.L - x.L) * k,
                         a: x.a + (y.a - x.a) * k,
                         b: x.b + (y.b - x.b) * k))
    }
}

// MARK: - Contrast (visual.md §1.14)

/// WCAG 2 relative luminance and contrast, and the floors the upgrade holds
/// every surface to. Implements `visual.md` §1.14.
enum Contrast {

    /// Body text: at least 4.5 : 1 against the pixels behind it.
    static let bodyFloor = 4.5
    /// Display text (≥ 24 pt, or ≥ 18.66 pt bold) and graphic marks: 3 : 1.
    static let displayFloor = 3.0
    static let graphicFloor = 3.0
    /// No text below 11 pt anywhere (sources' 8–10 px are raised to 11).
    static let minimumTextSize: CGFloat = 11
    /// Cream on a ground at α ≥ .5 (`#807670`, 4.55 : 1 on `#0D0508`); .3 is texture.
    static let creamAlphaFloor = 0.5
    /// A settled line stands at ≥ .55 α (PlayInk).
    static let settledLineAlpha = 0.55
    /// The paper accent's ink partner (`acp = mix(oklab, ac 50 %, #191919 50 %)`).
    static let paperInk = LookColor(hex: "#191919")
    /// The cream an accent is lifted toward on night grounds.
    static let cream = LookColor(hex: "#F2E8D9")

    /// Whether a size counts as display for the 3 : 1 floor ("22 px / 400 is
    /// NOT large text").
    static func isDisplay(size: CGFloat, bold: Bool) -> Bool {
        size >= 24 || (bold && size >= 18.66)
    }

    static func floor(size: CGFloat, bold: Bool = false) -> Double {
        isDisplay(size: size, bold: bold) ? displayFloor : bodyFloor
    }

    static func luminance(_ c: LookColor) -> Double {
        func lin(_ v: Double) -> Double { v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4) }
        return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b)
    }

    /// The contrast of `fg` (composited over `bg` if it carries alpha) on `bg`.
    static func ratio(_ fg: LookColor, on bg: LookColor) -> Double {
        let ground = LookColor(r: bg.r, g: bg.g, b: bg.b)
        let a = luminance(fg.over(ground)), b = luminance(ground)
        return (max(a, b) + 0.05) / (min(a, b) + 0.05)
    }

    /// `readable(accent, ground)` (§1.14): the raw accent if it already reads
    /// at `floor`, else the accent lifted toward cream in oklab, one per cent at
    /// a time, until it does. This is the arithmetic the §1.4.4 ring table's
    /// "text on wash" column was computed with (rose → `#C56583`, crimson →
    /// `#CC5D61`, wine → `#BB6597`, red → `#DE5244`).
    static func readable(_ accent: LookColor, on ground: LookColor,
                         floor: Double = bodyFloor, toward lift: LookColor = cream) -> LookColor {
        if ratio(accent, on: ground) >= floor { return accent }
        var step = 1
        while step <= 100 {
            let c = OKLab.mix(accent, lift, Double(step) / 100)
            if ratio(c, on: ground) >= floor { return c }
            step += 1
        }
        return lift
    }

    /// The accent as text on a paper ground: `mix(oklab, ac 50 %, #191919 50 %)`
    /// — never oklch, which drifted a lavender into a rose (§1.14).
    static func paperAccent(_ accent: LookColor) -> LookColor {
        OKLab.mix(accent, paperInk, 0.5)
    }
}
