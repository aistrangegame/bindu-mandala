import SwiftUI
import SwiftData

/// The Silence screen — entered by tapping the Bindu at the lotus center.
/// No status bar. No tab bar. No navigation chrome. Pure presence.
struct SilenceView: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]

    @State private var binduBreath: CGFloat = 0
    @State private var captionVisible = false
    @State private var entered = Date()
    @State private var loggedDeparture = false
    @State private var namesAppeared: Set<Int> = []

    /// Captures her undifferentiated form.
    /// All 16 Sanskrit short names appear as stars in a faint circle.
    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()

            // Vignette — draws the eye to center
            RadialGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.65)]),
                center: .center,
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy = geo.size.height / 2
                ZStack {
                    // 16 names — stars in a faint circle, rotated tangentially
                    ForEach(Array(shaktis.enumerated()), id: \.offset) { (i, s) in
                        let angle = (Double(i) * 22.5 - 90) * .pi / 180
                        let r: CGFloat = 156
                        let x = cx + r * cos(angle)
                        let y = cy + r * sin(angle)
                        Text(s.shortName)
                            .font(.custom(AppFont.cormorantItalic, size: 11))
                            .tracking(2.0)
                            .foregroundStyle(Color.cream.opacity(0.16))
                            .rotationEffect(.degrees(Double(i) * 22.5))
                            .position(x: x, y: y)
                            .opacity(namesAppeared.contains(i) ? 1 : 0)
                            .shadow(color: Color.gold.opacity(0.15), radius: 6)
                    }

                    // 3 faint outer concentric rings
                    Canvas { ctx, _ in
                        let radii: [(CGFloat, Double, Bool)] = [
                            (200, 0.05, false),
                            (220, 0.035, true),
                            (240, 0.025, false),
                        ]
                        for (r, alpha, dashed) in radii {
                            let rect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
                            let path = Path(ellipseIn: rect)
                            if dashed {
                                let p = path.strokedPath(StrokeStyle(lineWidth: 0.5, dash: [2, 8]))
                                ctx.fill(p, with: .color(Color.gold.opacity(alpha)))
                            } else {
                                ctx.stroke(path, with: .color(Color.gold.opacity(alpha)), lineWidth: 0.5)
                            }
                        }
                    }
                    .allowsHitTesting(false)

                    // Outer gentle ring of light — 132pt
                    Circle()
                        .stroke(Color.gold.opacity(0.18), lineWidth: 0.5)
                        .frame(width: 132, height: 132)
                        .position(x: cx, y: cy)

                    // Bindu — large slow breath, her undifferentiated form
                    binduGlyph
                        .scaleEffect(scaleForBreath)
                        .position(x: cx, y: cy)

                    // Caption — appears only after presence has settled
                    Text("All of her. Here. Always.")
                        .font(.custom(AppFont.cormorantItalic, size: 18))
                        .tracking(0.7)
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .opacity(captionVisible ? 1 : 0)
                        .position(x: cx, y: cy + 220)

                    // Tap to return hint — almost invisible
                    Text("Tap to return".uppercased())
                        .font(.system(size: 9))
                        .tracking(2.8)
                        .foregroundStyle(Color.cream.opacity(0.14))
                        .position(x: cx, y: geo.size.height - 38)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { closeSilence() }
        .onAppear(perform: enterSilence)
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    private var binduGlyph: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.accentRed,
                            Color.accentRed.opacity(0.7),
                            Color.clear
                        ]),
                        center: .center, startRadius: 0, endRadius: 40
                    )
                )
                .frame(width: 76, height: 76)
                .blur(radius: 2)
            Circle()
                .fill(Color.cream)
                .frame(width: 20, height: 20)
                .shadow(color: Color.cream.opacity(0.6), radius: 12)
                .shadow(color: Color.cream.opacity(0.4), radius: 22)
        }
    }

    private var scaleForBreath: CGFloat {
        guard !reduceMotion else { return 1.0 }
        return 1.0 + sin(binduBreath * .pi * 2) * 0.08
    }

    private func enterSilence() {
        entered = Date()
        // Stagger names in
        for i in 0..<shaktis.count {
            let delay = 0.15 + Double(i) * 0.12
            if reduceMotion {
                namesAppeared.insert(i)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeIn(duration: 1.2)) {
                        _ = namesAppeared.insert(i)
                    }
                }
            }
        }
        // Bindu slow breath — 6s ease-in-out infinite
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: false)) {
                binduBreath = 1
            }
        }
        // Caption fades in after ~7s
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            withAnimation(.easeIn(duration: reduceMotion ? 0.01 : 2.0)) {
                captionVisible = true
            }
        }
    }

    private func closeSilence() {
        guard !loggedDeparture else { isPresented = false; return }
        loggedDeparture = true
        // Silence is logged silently as its own gesture type — no confirmation,
        // no animation, no celebration. She was simply held in undifferentiated form.
        let duration = Date().timeIntervalSince(entered)
        if duration >= 1.0 {
            let store = RecognitionLogStore(context: context)
            // Use position 0 to mark this as not bound to a single Śakti — but our
            // model requires a position. Use the today's position so it groups with
            // her log even though the gesture is .silence.
            let pos = LunarPhaseService.todayPosition()
            store.record(position: pos, gesture: .silence)
        }
        isPresented = false
    }
}
