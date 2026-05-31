import SwiftUI

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r, g, b, a: Double
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
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    // Ground & Surface
    static let ground        = Color(hex: "#0D0508")
    static let surface       = Color(hex: "#1A0C10")
    static let darkVeil      = Color(hex: "#080307")
    static let silenceGround = Color(hex: "#040104")

    // Primary
    static let gold       = Color(hex: "#C9963F")
    static let goldDeep   = Color(hex: "#A07830")
    static let goldWarm   = Color(hex: "#CF9443")  // Bhūpura / Ring 1 amber
    static let cream      = Color(hex: "#F2E8D9")
    static let accentRed  = Color(hex: "#8B1A2A")

    // Cluster colors
    static let clusterInner     = Color(hex: "#D4A017")
    static let clusterSense     = Color(hex: "#C4725A")
    static let clusterCitta     = Color(hex: "#2A7A7A")
    static let clusterStability = Color(hex: "#4A7A5A")
    static let clusterSelf      = Color(hex: "#7A5A9A")
}

extension Color {
    static let creamMid   = Color.cream.opacity(0.65)
    static let creamFaint = Color.cream.opacity(0.35)
    static let goldFaint  = Color.gold.opacity(0.12)
}
