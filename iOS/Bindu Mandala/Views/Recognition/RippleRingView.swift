import SwiftUI

/// One expanding gold ring. Four of these are stacked on the Recognition Moment.
/// Each ring runs exactly 3 expand/fade cycles, then settles into stillness —
/// the ceremony stops pulsing once it has been received.
struct RippleRingView: View {
    var delay: Double = 0
    var color: Color = .gold
    var maxScale: CGFloat = 4.5
    @State private var animating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 0.8)
            .frame(width: 80, height: 80)
            .scaleEffect(animating ? maxScale : 0.6)
            .opacity(animating ? 0 : 0.85)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    .easeOut(duration: 4)
                    .repeatCount(3, autoreverses: false)
                    .delay(delay)
                ) {
                    animating = true
                }
            }
            .allowsHitTesting(false)
    }
}
