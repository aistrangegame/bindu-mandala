import SwiftUI

/// The beholding's depth between frames — ``DarshanaDepth`` advanced by real
/// time, ten times a second.
final class DarshanaClock {
    private(set) var state = DarshanaDepth()
    private var last: TimeInterval?

    func advance(now: TimeInterval, steadiness: Double) {
        let dt = last.map { max(0, now - $0) } ?? 0
        last = now
        state.advance(dt: dt, steadiness: steadiness)
    }
}

/// **Darśana · beholding** (The Eight Modes, mode 1, completed in Wave 6).
/// *"The yantra wakes to your stillness. Time stretches."* Hold the phone still:
/// the yantra comes up from a breath of line to its full light and begins to
/// turn, the point brightens, and at the deepest the light radiates outward. Move, and it gives way — nothing is lost. Nothing on the glass
/// counts the stillness; Design's "beholding · 30s" is said as "beholding".
struct DarshanaView: View {
    let onEnd: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var stillness = StillnessSensor()
    @State private var clock = DarshanaClock()
    @State private var openedAt = Date()

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 30, paused: false)) { tl in
            let d = clock.state
            let t = tl.date.timeIntervalSince(openedAt)
            ZStack {
                ground(d)
                radiance(d, t: t)
                ModeYantraBackdrop(wake: d.depth,
                                   rotation: .degrees(reduceMotion ? 0 : t * 0.4 * d.depth))
                point(d, t: t)
                VStack {
                    ModeHeading(title: TheModes.Mode.darshana.title)
                    Spacer()
                    Text(d.words)
                        .font(AppFont.voice(17))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream)
                        .opacity(d.stage == .entered ? 0.8 : 0.62)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 2), value: d.stage)
                    ModeRestButton(action: onEnd)
                        .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .theEdgeWayOut(onOut: onEnd)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Darśana — hold the phone still, and the yantra wakes"))
        .onAppear {
            openedAt = Date()
            stillness.start()
        }
        .onDisappear { stillness.stop() }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.1))
                clock.advance(now: Date().timeIntervalSinceReferenceDate,
                              steadiness: stillness.steadiness)
            }
        }
    }

    /// Design's three grounds, darkening toward the centre as she wakes.
    private func ground(_ d: DarshanaDepth) -> some View {
        let k = d.depth
        return RadialGradient(colors: [Color(red: (10 + 5 * k) / 255, green: 6 / 255, blue: 8 / 255),
                                       Color(red: 3 / 255, green: 1 / 255, blue: 3 / 255),
                                       Color.black],
                              center: .center, startRadius: 0, endRadius: 520 - 120 * k)
            .ignoresSafeArea()
    }

    /// The outward radiance of the entered state — Design's `darsanaRadiance`.
    private func radiance(_ d: DarshanaDepth, t: TimeInterval) -> some View {
        let entered = max(0, (d.depth - 0.85) / 0.15)
        let breath = reduceMotion ? 1 : 0.85 + 0.15 * sin(t * 2 * .pi / BreathClock.breath)   // Wave 6.1 · the one clock
        return Circle()
            .fill(RadialGradient(colors: [Color.gold.opacity(0.22 * entered * breath),
                                          Color.accentRed.opacity(0.10 * entered), .clear],
                                 center: .center, startRadius: 0, endRadius: 270))
            .frame(width: 540, height: 540)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    /// The point at the heart, brightening as the beholding deepens.
    private func point(_ d: DarshanaDepth, t: TimeInterval) -> some View {
        let breath = reduceMotion ? 1 : Mauna.binduBreath(at: t)
        return ZStack {
            Circle()
                .fill(RadialGradient(colors: [Color.accentRed, Color.accentRed.opacity(0)],
                                     center: .center, startRadius: 0, endRadius: 30 + 20 * d.depth))
                .frame(width: 120, height: 120)
                .scaleEffect(CGFloat(breath))
            Circle()
                .fill(Color.cream)
                .frame(width: 10 + 8 * d.depth, height: 10 + 8 * d.depth)
                .shadow(color: Color.cream, radius: 10 + 14 * d.depth)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
