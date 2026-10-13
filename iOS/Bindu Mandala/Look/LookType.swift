import SwiftUI
import UIKit

// MARK: - U1 · Look · the sixteen faces (visual.md §1.15)
//
// Law 9: type changes only where a crossing means something. Each world names
// its display and UI faces (§1.3 / §1.4); this file is where a face becomes a
// `Font`.
//
// **Only two faces ship today** — `CormorantGaramond-Light.ttf` and
// `-LightItalic.ttf` (`Fonts/`, `Info.plist` `UIAppFonts`). Every other face
// in §1.15 is still to be bundled (`TypeFamily.toBundle`). Until it is, a
// token resolves to its fallback, chosen so the register survives:
//
//  · Cormorant at a weight not bundled (Regular, Medium, Italic 400) → the
//    bundled Light / Light Italic — the same family, one weight lighter.
//  · every other family → the system face of the same design (serif, sans or
//    mono) at the token's weight and italic.
//
// The moment a face's file is added and registered, `UIFont(name:)` finds its
// PostScript name and the token draws in it — no call site changes.
//
// Sizes go through Dynamic Type exactly as `AppFont` does: a bundled face via
// `Font.custom(_:size:relativeTo:)`, a system fallback through
// `AppFont.labelPointSize` (UIFontMetrics, normalised so the designed size is
// the designed size at the default category).

/// The families of §1.15 (0–16) plus the system face. Implements `visual.md`
/// §1.15 "Type: crossings and the sixteen faces".
enum TypeFamily: String, CaseIterable, Equatable {
    case cormorant = "Cormorant Garamond"
    case lora = "Lora"
    case dmSans = "DM Sans"
    case dmMono = "DM Mono"
    case cinzel = "Cinzel"
    case ebGaramond = "EB Garamond"
    case fraunces = "Fraunces"
    case spectral = "Spectral"
    case instrumentSans = "Instrument Sans"
    case instrumentSerif = "Instrument Serif"
    case newsreader = "Newsreader"
    case gloock = "Gloock"
    case inter = "Inter"
    case geist = "Geist"
    case geistMono = "Geist Mono"
    case spaceMono = "Space Mono"
    case jetBrainsMono = "JetBrains Mono"
    /// SF — the small-caps strips (`AppFont.label`).
    case system = "System"

    /// The system design a fallback keeps (serif stays serif, mono stays mono).
    var fallbackDesign: Font.Design {
        switch self {
        case .cormorant, .lora, .cinzel, .ebGaramond, .fraunces, .spectral,
             .instrumentSerif, .newsreader, .gloock:
            return .serif
        case .dmMono, .geistMono, .spaceMono, .jetBrainsMono:
            return .monospaced
        case .dmSans, .instrumentSans, .inter, .geist, .system:
            return .default
        }
    }

    /// The faces still to be bundled (§1.15: "Sixteen to add, plus Cormorant
    /// extended"), each with the weights / styles the worlds ask for.
    static let toBundle: [(family: TypeFamily, styles: String)] = [
        (.cormorant, "Regular 400, Medium 500, Italic 400"),
        (.lora, "400, 400 Italic, 300 Italic"),
        (.dmSans, "400, 500"),
        (.dmMono, "300, 400"),
        (.cinzel, "400"),
        (.ebGaramond, "400, Italic"),
        (.fraunces, "300, 400 Italic (opsz)"),
        (.spectral, "300, 400"),
        (.instrumentSans, "400, 500"),
        (.instrumentSerif, "400, Italic"),
        (.newsreader, "300 Italic, 400"),
        (.gloock, "400"),
        (.inter, "400, 500"),
        (.geist, "400"),
        (.geistMono, "400"),
        (.spaceMono, "400"),
        (.jetBrainsMono, "300, 400"),
    ]

    /// The font files that ship today (`Fonts/`, `UIAppFonts`).
    static let bundledFiles = ["CormorantGaramond-Light.ttf", "CormorantGaramond-LightItalic.ttf"]
}

/// One face: a family at a weight, upright or italic.
struct TypeFace: Equatable {
    var family: TypeFamily
    var weight: Font.Weight = .regular
    var italic: Bool = false

    /// The PostScript name the face will register under once bundled (Google
    /// Fonts' static-instance naming, `Family-WeightStyle`). An assumption
    /// until each file is added — listed in the U1-C report. Nil for system.
    var postScriptName: String? {
        let base: String
        switch family {
        case .system: return nil
        case .cormorant:       base = "CormorantGaramond"
        case .lora:            base = "Lora"
        case .dmSans:          base = "DMSans"
        case .dmMono:          base = "DMMono"
        case .cinzel:          base = "Cinzel"
        case .ebGaramond:      base = "EBGaramond"
        case .fraunces:        base = "Fraunces"
        case .spectral:        base = "Spectral"
        case .instrumentSans:  base = "InstrumentSans"
        case .instrumentSerif: base = "InstrumentSerif"
        case .newsreader:      base = "Newsreader"
        case .gloock:          base = "Gloock"
        case .inter:           base = "Inter"
        case .geist:           base = "Geist"
        case .geistMono:       base = "GeistMono"
        case .spaceMono:       base = "SpaceMono"
        case .jetBrainsMono:   base = "JetBrainsMono"
        }
        let w: String
        switch weight {
        case .ultraLight, .thin: w = "ExtraLight"
        case .light:             w = "Light"
        case .medium:            w = "Medium"
        case .semibold:          w = "SemiBold"
        case .bold, .heavy, .black: w = "Bold"
        default:                 w = "Regular"
        }
        if italic { return "\(base)-\(w == "Regular" ? "" : w)Italic" }
        return "\(base)-\(w)"
    }

    /// True when this exact face is registered with UIKit on this device.
    var isAvailable: Bool {
        guard let ps = postScriptName else { return true }
        return UIFont(name: ps, size: 12) != nil
    }

    // The faces the worlds name (§1.3 / §1.4).
    static let cormorantLight = TypeFace(family: .cormorant, weight: .light)
    static let cormorantLightItalic = TypeFace(family: .cormorant, weight: .light, italic: true)
    static let cormorantRegular = TypeFace(family: .cormorant)
    static let cormorantMedium = TypeFace(family: .cormorant, weight: .medium)
    static let cormorantItalic = TypeFace(family: .cormorant, italic: true)
    static let systemCaps = TypeFace(family: .system)
}

/// A text token: a face at a designed size (pt at Dynamic Type "Large"), its
/// tracking in em, and whether it is set in capitals. Implements `visual.md`
/// §1.4 (type rows) and the §1.14 floor (no text below 11 pt).
struct TypeToken: Equatable {
    let face: TypeFace
    /// Never below 11 pt — the source's 8–10 px are raised (§1.4, §1.14).
    let size: CGFloat
    /// Letter-spacing in em (`.22 em` → 0.22).
    var trackingEm: CGFloat = 0
    var uppercase: Bool = false

    init(_ face: TypeFace, _ size: CGFloat, tracking: CGFloat = 0, uppercase: Bool = false) {
        self.face = face
        self.size = max(size, Contrast.minimumTextSize)
        self.trackingEm = tracking
        self.uppercase = uppercase
    }

    /// Tracking in points at the designed size (`.tracking(_:)` takes points).
    var trackingPoints: CGFloat { trackingEm * size }

    /// The `Font` this token draws with on this device today (see the file
    /// header for the fallback rule).
    var font: Font {
        let style = AppFont.style(forSize: size)
        if let ps = face.postScriptName, UIFont(name: ps, size: size) != nil {
            return .custom(ps, size: size, relativeTo: style)
        }
        if face.family == .cormorant {
            // Same family, the bundled weight: Light or Light Italic.
            return face.italic ? AppFont.voice(size, style) : AppFont.sanskrit(size, style)
        }
        let base = Font.system(size: AppFont.labelPointSize(size, style),
                               weight: face.weight, design: face.family.fallbackDesign)
        return face.italic ? base.italic() : base
    }
}

extension View {
    /// Set a run of text in a Look type token: face, Dynamic Type size, tracking,
    /// capitals.
    func lookType(_ token: TypeToken) -> some View {
        self.font(token.font)
            .tracking(token.trackingPoints)
            .textCase(token.uppercase ? .uppercase : nil)
    }
}
