import SwiftUI

/// Slowly drifting gold particles — temple atmosphere.
/// Respects `prefers-reduced-motion` via accessibility env.
struct DustMotesView: View {
    var count: Int = 9
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Mote: Identifiable {
        let id = UUID()
        let xPercent: Double
        let drift: CGFloat
        let size: CGFloat
        let duration: Double
        let delay: Double
        let opacity: Double
    }

    private let motes: [Mote]

    init(count: Int = 9) {
        self.count = count
        // Stable pseudo-random pattern.
        self.motes = (0..<count).map { i in
            let seed = (i * 73 + 17) % 100
            return Mote(
                xPercent: Double(8 + ((seed * 7) % 84)) / 100,
                drift: CGFloat(-10 + ((seed * 13) % 20)),
                size: CGFloat(1.4) + CGFloat(((seed * 3) % 22)) / 10,
                duration: Double(16 + ((seed * 5) % 14)),
                delay: Double(seed % 80) / 8,
                opacity: 0.18 + Double((seed * 11) % 28) / 100
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(motes) { m in
                    MoteView(mote: m, height: geo.size.height, width: geo.size.width, reduceMotion: reduceMotion)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private struct MoteView: View {
        let mote: Mote
        let height: CGFloat
        let width: CGFloat
        let reduceMotion: Bool
        @State private var phase: CGFloat = 0

        var body: some View {
            Circle()
                .fill(Color.gold)
                .frame(width: mote.size, height: mote.size)
                .opacity(mote.opacity)
                .shadow(color: Color.gold.opacity(0.5), radius: mote.size * 2)
                .position(
                    x: mote.xPercent * width + mote.drift * phase,
                    y: height + 12 - phase * (height + 24)
                )
                .onAppear {
                    guard !reduceMotion else { phase = 0.5; return }
                    withAnimation(
                        .linear(duration: mote.duration)
                        .repeatForever(autoreverses: false)
                        .delay(mote.delay)
                    ) {
                        phase = 1
                    }
                }
        }
    }
}
