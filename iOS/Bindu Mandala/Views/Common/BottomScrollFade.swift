import SwiftUI

/// A short bottom-edge fade overlay for ScrollViews whose content runs past
/// the viewport. Hints to the practitioner that more text exists below.
///
/// Sits above a ScrollView via `.overlay(alignment: .bottom)`. Pointer events
/// pass through to the scroll content beneath.
struct BottomScrollFade: View {
    var height: CGFloat = 28
    var backgroundColor: Color = .ground

    var body: some View {
        LinearGradient(
            colors: [backgroundColor.opacity(0), backgroundColor.opacity(0.95)],
            startPoint: .top, endPoint: .bottom
        )
        .frame(height: height)
        .allowsHitTesting(false)
    }
}
