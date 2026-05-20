import SwiftUI
import UIKit
import os

private let fontLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "fonts")

enum AppFont {
    static let cormorant = "CormorantGaramond-Light"
    static let cormorantItalic = "CormorantGaramond-LightItalic"

    static func sanskrit(_ size: CGFloat) -> Font {
        .custom(cormorant, size: size)
    }

    static func voice(_ size: CGFloat) -> Font {
        .custom(cormorantItalic, size: size)
    }

    static func label(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .regular)
    }

    /// One-shot audit at launch — logs whether our custom fonts are actually
    /// registered with UIKit. If you see "MISSING", the .ttf didn't make it
    /// into the bundle or its PostScript name doesn't match what we ask for.
    static func audit() {
        let want = [cormorant, cormorantItalic]
        for name in want {
            if let _ = UIFont(name: name, size: 12) {
                fontLog.notice("✓ \(name, privacy: .public) registered.")
            } else {
                fontLog.error("✗ \(name, privacy: .public) MISSING — falling back to system serif.")
            }
        }
    }
}

extension View {
    func tracked(_ tracking: CGFloat) -> some View {
        self.tracking(tracking)
    }
}
