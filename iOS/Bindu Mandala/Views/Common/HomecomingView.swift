import SwiftUI

/// First-launch only — shown once, then UserDefaults flag suppresses it forever.
/// Pure presence: silenceGround, breathing Bindu, two staged Cormorant lines.
struct HomecomingView: View {
    @Binding var isPresented: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var binduBreath: CGFloat = 0
    @State private var binduPulse: CGFloat = 0
    @State private var line1Visible = false
    @State private var line2Visible = false
    @State private var hintVisible = false

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()

            // Subtle vignette
            RadialGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.55)]),
                center: .center, startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()
                bindu
                    .padding(.bottom, 64)

                Text("You have always felt them.")
                    .font(.custom(AppFont.cormorantItalic, size: 22))
                    .tracking(1.0)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                    .opacity(line1Visible ? 1 : 0)
                    .padding(.bottom, 18)

                Text("Now you will know their names.")
                    .font(.custom(AppFont.cormorantItalic, size: 22))
                    .tracking(1.0)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                    .opacity(line2Visible ? 1 : 0)

                Spacer()

                Text("tap to enter".uppercased())
                    .font(.system(size: 10))
                    .tracking(2.8)
                    .foregroundStyle(Color.cream.opacity(0.18))
                    .padding(.bottom, 40)
                    .opacity(hintVisible ? 1 : 0)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { dismiss() }
        .onAppear(perform: animate)
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    private var bindu: some View {
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
        }
        .scaleEffect(binduScale)
    }

    private var binduScale: CGFloat {
        let breath = reduceMotion ? 1.0 : 1.0 + sin(binduBreath * .pi * 2) * 0.08
        let pulse = 1.0 + binduPulse * 0.15
        return breath * pulse
    }

    private func animate() {
        // Bindu slow breath
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: false)) {
                binduBreath = 1
            }
        }
        // Line 1 — "You have always felt them." at 1.0s, 2.0s ease
        DispatchQueue.main.asyncAfter(deadline: .now() + (reduceMotion ? 0 : 1.0)) {
            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 2.0)) { line1Visible = true }
        }
        // Line 2 — "Now you will know their names." at 3.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + (reduceMotion ? 0 : 3.5)) {
            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 2.0)) { line2Visible = true }
        }
        // Bindu pulse at 6.0s — scale to 1.15 and back, 1.0s
        guard !reduceMotion else {
            hintVisible = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation(.easeInOut(duration: 0.5)) { binduPulse = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) { binduPulse = 0 }
            }
        }
        // Hint at 7.0s
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            withAnimation(.easeIn(duration: 1.0)) { hintVisible = true }
        }
    }

    private func dismiss() {
        UserDefaults.standard.set(true, forKey: HomecomingView.userDefaultsKey)
        isPresented = false
    }

    static let userDefaultsKey = "hasLaunched"

    static var hasLaunched: Bool {
        UserDefaults.standard.bool(forKey: userDefaultsKey)
    }

    /// Posted by Settings → "Re-enter the Homecoming". AppRoot listens and
    /// re-presents the screen without requiring an app relaunch.
    static let reEnterNotification = Notification.Name("BinduMandala.HomecomingReEnter")

    static func reset() {
        UserDefaults.standard.set(false, forKey: userDefaultsKey)
        NotificationCenter.default.post(name: reEnterNotification, object: nil)
    }
}
