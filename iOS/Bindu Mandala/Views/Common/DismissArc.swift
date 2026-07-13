import SwiftUI

/// The subtle curved arc at the top of every ring world — visually identical
/// to the existing return-arc decoration, but with a 60pt tap target so it
/// dismisses the world. Attached via `.overlay(alignment: .top)` and bound
/// to a tap with `.highPriorityGesture` so it fires before any background
/// drag gesture (scatter mechanic, hold mechanic, light-follow) can claim
/// the touch.
struct DismissArc: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 16)
            Canvas { ctx, size in
                let mid = size.width / 2
                var path = Path()
                path.move(to: CGPoint(x: mid - 36, y: 11))
                path.addQuadCurve(
                    to: CGPoint(x: mid + 36, y: 11),
                    control: CGPoint(x: mid, y: 3)
                )
                ctx.stroke(
                    path,
                    with: .color(Color.cream.opacity(0.22)),
                    style: StrokeStyle(lineWidth: 0.7, lineCap: .round)
                )
            }
            .frame(width: 80, height: 14)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
