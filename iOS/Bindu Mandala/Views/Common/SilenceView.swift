import SwiftUI
import SwiftData

/// The Silence screen — entered by tapping the Bindu at the lotus center.
/// No status bar. No tab bar. No navigation chrome. Pure presence.
struct SilenceView: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var binduBreath: CGFloat = 0
    @State private var entered = Date()
    @State private var loggedDeparture = false
    @State private var namesAppeared: Set<Int> = []        // Ring 2
    @State private var anangaAppeared: Set<Int> = []       // Ring 3
    @State private var captionStage: CaptionStage = .beforeFirst

    private enum CaptionStage: Int { case beforeFirst, first, second, third, faded }

    private var ring2Shaktis: [Shakti] {
        allShaktis.filter { ($0.ringNumber ?? 2) == 2 }
            .sorted { $0.position < $1.position }
    }

    private var ring3Shaktis: [Shakti] {
        allShaktis.filter { $0.ringNumber == 3 }
            .sorted { $0.position < $1.position }
    }

    private var binduOuter: CGFloat { 78 }

    /// Captures her undifferentiated form.
    /// All 16 Sanskrit short names appear as stars in a faint outer orbital.
    /// 8 Anaṅga names form a second, deeper orbital near the Bindu.
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
                    // 16 Ring 2 names — outer orbital at 156pt.
                    // Deliberate sub-floor: these are a felt shimmer around
                    // the Bindu, not a roll-call to be read.
                    ForEach(Array(ring2Shaktis.enumerated()), id: \.offset) { (i, s) in
                        let angle = (Double(i) * 22.5 - 90) * .pi / 180
                        let r: CGFloat = 156
                        let x = cx + r * cos(angle)
                        let y = cy + r * sin(angle)
                        Text(s.shortName.isEmpty ? s.name : s.shortName)
                            .font(.custom(AppFont.cormorantItalic, size: 11))
                            .tracking(2.0)
                            .foregroundStyle(Color.cream.opacity(0.16))
                            .rotationEffect(.degrees(Double(i) * 22.5))
                            .position(x: x, y: y)
                            .opacity(namesAppeared.contains(i) ? 1 : 0)
                            .shadow(color: Color.gold.opacity(0.15), radius: 6)
                    }

                    // 8 Ring 3 Anaṅga names — inner orbital at 108pt.
                    // Same deliberate sub-floor as the outer ring — texture, not labels.
                    ForEach(Array(ring3Shaktis.prefix(8).enumerated()), id: \.offset) { (i, s) in
                        let angle = (Double(i) * 45 - 90) * .pi / 180
                        let r: CGFloat = 108
                        let x = cx + r * cos(angle)
                        let y = cy + r * sin(angle)
                        Text(s.shortName.isEmpty ? s.name : s.shortName)
                            .font(.custom(AppFont.cormorantItalic, size: 10))
                            .tracking(1.4)
                            .foregroundStyle(Color.cream.opacity(0.11))
                            .rotationEffect(.degrees(Double(i) * 45))
                            .position(x: x, y: y)
                            .opacity(anangaAppeared.contains(i) ? 1 : 0)
                            .shadow(color: Color.gold.opacity(0.10), radius: 4)
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

                    // Bindu — large slow breath, her undifferentiated form.
                    // Grows to 78pt when Ring 3 is unlocked.
                    binduGlyph
                        .scaleEffect(scaleForBreath)
                        .position(x: cx, y: cy)

                    // Captions — single 7s caption when Ring 3 locked,
                    // four-stage sequence (7 / 14 / 21 / 28s) when unlocked.
                    captionLayer
                        .position(x: cx, y: cy + 220)

                    // Tap to return hint — quiet, but findable in daylight.
                    Text("Tap to return".uppercased())
                        .font(.system(size: 11))
                        .tracking(2.8)
                        .foregroundStyle(Color.cream.opacity(0.40))
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
                .frame(width: binduOuter, height: binduOuter)
                .blur(radius: 2)
            Circle()
                .fill(Color.cream)
                .frame(width: 20, height: 20)
                .shadow(color: Color.cream.opacity(0.6), radius: 12)
                .shadow(color: Color.cream.opacity(0.4), radius: 22)
        }
    }

    private var captionLayer: some View {
        ZStack {
            captionText("All of her. Here. Always.")
                .opacity(captionStage == .first ? 1 : 0)
            captionText("She has not gone anywhere.")
                .opacity(captionStage == .second ? 1 : 0)
            captionText("You have not gone anywhere.")
                .opacity(captionStage == .third ? 1 : 0)
        }
    }

    private func captionText(_ s: String) -> some View {
        Text(s)
            .font(.custom(AppFont.cormorantItalic, size: 18))
            .tracking(0.7)
            .foregroundStyle(Color.cream.opacity(0.55))
            .multilineTextAlignment(.center)
    }

    private var scaleForBreath: CGFloat {
        guard !reduceMotion else { return 1.0 }
        return 1.0 + sin(binduBreath * .pi * 2) * 0.08
    }

    private func enterSilence() {
        entered = Date()

        // Ring 2 — 16 names stagger in
        for i in 0..<ring2Shaktis.count {
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

        // Ring 3 — 8 Anaṅga names stagger in
        let n = min(8, ring3Shaktis.count)
        for i in 0..<n {
            let delay = 0.30 + Double(i) * 0.18
            if reduceMotion {
                anangaAppeared.insert(i)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeIn(duration: 1.4)) {
                        _ = anangaAppeared.insert(i)
                    }
                }
            }
        }

        // Bindu slow breath
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: false)) {
                binduBreath = 1
            }
        }

        // Captions — four-stage sequence at 7 / 14 / 21 / 28s
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            withAnimation(.easeIn(duration: reduceMotion ? 0.01 : 2.0)) {
                captionStage = .first
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 14.0) {
            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 1.5)) {
                captionStage = .second
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 21.0) {
            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 1.5)) {
                captionStage = .third
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 28.0) {
            withAnimation(.easeOut(duration: reduceMotion ? 0.01 : 2.0)) {
                captionStage = .faded
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
            // Use today's Ring 2 position so the entry groups with her log
            // even though the gesture is .silence. Convert per-ring position
            // (1-16) into the global Khaḍgamālā key (29-44) so Phase 2's
            // 102-aware Portrait can see every Silence dwell.
            let pos = LunarPhaseService.todayPosition()
            store.record(
                khadgamalaPosition: pos + 28,
                ringNumber: 2,
                gesture: .silence
            )

            // Fire-and-forget Airtable write. Failure is silent; queued for retry.
            Task {
                await AirtableService.shared.recordSilence(durationSec: duration)
            }
        }
        isPresented = false
    }
}
