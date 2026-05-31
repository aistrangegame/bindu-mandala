import SwiftUI

/// Nine dots indicating ring presence and sacred depth.
/// Sits below the "I feel her" CTA on Today. Ring 2 is the home (largest,
/// pulsing); other rings progressively smaller and quieter toward Ring 9 —
/// not because they're restricted, but because each inner ring is more interior.
struct RingPositionIndicatorView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulsePhase: CGFloat = 0

    private struct DotSpec {
        let ring: Int
        let baseSize: CGFloat
        let baseOpacity: Double
        let isAmber: Bool  // Ring 1 uses Bhūpura amber
    }

    private let specs: [DotSpec] = [
        .init(ring: 1, baseSize: 5,   baseOpacity: 0.42, isAmber: true),
        .init(ring: 2, baseSize: 7,   baseOpacity: 0.95, isAmber: false),
        .init(ring: 3, baseSize: 5,   baseOpacity: 0.50, isAmber: false),
        .init(ring: 4, baseSize: 4,   baseOpacity: 0.20, isAmber: false),
        .init(ring: 5, baseSize: 4,   baseOpacity: 0.16, isAmber: false),
        .init(ring: 6, baseSize: 3.5, baseOpacity: 0.13, isAmber: false),
        .init(ring: 7, baseSize: 3.5, baseOpacity: 0.10, isAmber: false),
        .init(ring: 8, baseSize: 3,   baseOpacity: 0.06, isAmber: false),
        .init(ring: 9, baseSize: 3,   baseOpacity: 0.05, isAmber: false),
    ]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(specs, id: \.ring) { s in
                dot(for: s)
            }
        }
        .padding(.vertical, 6)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                pulsePhase = 1
            }
        }
    }

    @ViewBuilder
    private func dot(for s: DotSpec) -> some View {
        let color: Color = s.isAmber ? Color.goldWarm : Color.gold
        let scale: CGFloat = (s.ring == 2 && !reduceMotion)
            ? 1 + sin(pulsePhase * .pi) * 0.06
            : 1

        Circle()
            .fill(color)
            .opacity(s.baseOpacity)
            .frame(width: s.baseSize, height: s.baseSize)
            .shadow(color: s.ring == 2 ? color.opacity(0.55) : .clear,
                    radius: s.ring == 2 ? 4 : 0)
            .scaleEffect(scale)
    }
}
