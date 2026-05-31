import SwiftUI

/// One of five atmospheric states the Mandala reads from time-of-day + lunar phase.
/// Values translated verbatim from `Claude Designs/home-mandala.jsx` `TIME_VARIANTS`.
enum TimeVariant: String, CaseIterable, Hashable {
    case dawn, noon, dusk, night, newmoon

    // MARK: - Background

    var bg: Color {
        switch self {
        case .dawn:    return Color(hex: "#0A0610")
        case .noon:    return Color(hex: "#060104")
        case .dusk:    return Color(hex: "#0A0508")
        case .night:   return Color(hex: "#020308")
        case .newmoon: return Color(hex: "#020001")
        }
    }

    struct Ambient {
        let center: UnitPoint
        let inner: Color
        let widthFraction: Double
        let heightFraction: Double
    }

    var ambient: Ambient {
        switch self {
        case .dawn:
            return .init(center: UnitPoint(x: 0.5, y: 0.60),
                         inner: Color(red: 232/255, green: 150/255, blue: 80/255).opacity(0.13),
                         widthFraction: 0.65, heightFraction: 0.55)
        case .noon:
            return .init(center: UnitPoint(x: 0.5, y: 0.48),
                         inner: Color(red: 201/255, green: 150/255, blue: 63/255).opacity(0.07),
                         widthFraction: 0.65, heightFraction: 0.55)
        case .dusk:
            return .init(center: UnitPoint(x: 0.5, y: 0.40),
                         inner: Color(red: 199/255, green: 90/255, blue: 80/255).opacity(0.13),
                         widthFraction: 0.60, heightFraction: 0.50)
        case .night:
            return .init(center: UnitPoint(x: 0.5, y: 0.50),
                         inner: Color(red: 140/255, green: 180/255, blue: 220/255).opacity(0.08),
                         widthFraction: 0.65, heightFraction: 0.55)
        case .newmoon:
            return .init(center: UnitPoint(x: 0.5, y: 0.50),
                         inner: Color(red: 139/255, green: 26/255, blue: 42/255).opacity(0.22),
                         widthFraction: 0.50, heightFraction: 0.45)
        }
    }

    // MARK: - Petal-layer color & opacity modulation

    var petalSat: Double {
        switch self {
        case .dawn, .noon: return 1.0
        case .dusk:        return 0.85
        case .night:       return 0.45
        case .newmoon:     return 0.30
        }
    }

    var petalBrightness: Double {
        switch self {
        case .dawn, .noon: return 1.0
        case .dusk:        return 0.92
        case .night:       return 0.75
        case .newmoon:     return 0.50
        }
    }

    var petalOpacityMul: Double {
        switch self {
        case .dawn:    return 0.95
        case .noon:    return 1.00
        case .dusk:    return 0.85
        case .night:   return 0.55
        case .newmoon: return 0.30
        }
    }

    var lotusInnerOp: Double {
        switch self {
        case .dawn:    return 0.55
        case .noon:    return 0.50
        case .dusk:    return 0.40
        case .night:   return 0.28
        case .newmoon: return 0.15
        }
    }

    // MARK: - Triangle zone (Rings 4-8)

    var triStroke: Color {
        switch self {
        case .dawn:    return Color(hex: "#D4A067")
        case .noon:    return Color(hex: "#C9963F")
        case .dusk:    return Color(hex: "#C99443")
        case .night:   return Color(hex: "#A4B8CC")
        case .newmoon: return Color(red: 201/255, green: 150/255, blue: 63/255).opacity(0.35)
        }
    }

    var triOpacity: Double {
        switch self {
        case .dawn:    return 0.62
        case .noon:    return 0.70
        case .dusk:    return 0.55
        case .night:   return 0.42
        case .newmoon: return 0.18
        }
    }

    var triStrokeWidth: Double {
        switch self {
        case .dawn:    return 0.70
        case .noon:    return 0.65
        case .dusk:    return 0.60
        case .night:   return 0.55
        case .newmoon: return 0.50
        }
    }

    // MARK: - Bhūpura

    var bhupuraColor: Color {
        switch self {
        case .dawn:    return Color(red: 207/255, green: 148/255, blue: 67/255).opacity(0.30)
        case .noon:    return Color(red: 207/255, green: 148/255, blue: 67/255).opacity(0.25)
        case .dusk:    return Color(red: 184/255, green: 132/255, blue: 62/255).opacity(0.22)
        case .night:   return Color(red: 180/255, green: 200/255, blue: 220/255).opacity(0.18)
        case .newmoon: return Color(red: 201/255, green: 150/255, blue: 63/255).opacity(0.10)
        }
    }

    // MARK: - Bindu

    var binduScale: Double {
        switch self {
        case .dawn, .noon: return 1.0
        case .dusk:        return 1.05
        case .night:       return 1.10
        case .newmoon:     return 1.60
        }
    }

    var binduColor: Color {
        switch self {
        case .dawn:    return Color(hex: "#A8341F")
        case .noon:    return Color(hex: "#8B1A2A")
        case .dusk:    return Color(hex: "#7A1620")
        case .night:   return Color(hex: "#8B1A2A")
        case .newmoon: return Color(hex: "#8B1A2A")
        }
    }

    // MARK: - Atmospheric extras

    var motes: Int {
        switch self {
        case .dawn:    return 8
        case .noon:    return 6
        case .dusk:    return 9
        case .night:   return 12
        case .newmoon: return 3
        }
    }

    /// TemporalMark dot color.
    var markColor: Color {
        switch self {
        case .dawn:    return Color(hex: "#E8C97A")
        case .noon:    return Color(hex: "#F2E8D9")
        case .dusk:    return Color(hex: "#C99443")
        case .night:   return Color(hex: "#A4B8CC")
        case .newmoon: return Color(hex: "#3A1A20")
        }
    }
}
