import SwiftUI

/// The only navigation chrome in the app. A whisper, not a feature.
/// Full-screen overlay over `Color.ground`, four items in italic Cormorant.
struct HamburgerMenuView: View {
    @Binding var destination: RootView.Destination
    @Binding var isOpen: Bool
    var onSettings: () -> Void

    var body: some View {
        ZStack {
            Color.ground
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { close() }

            GeometryReader { geo in
                EllipticalGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.accentRed.opacity(0.08), location: 0),
                        .init(color: .clear, location: 1)
                    ]),
                    center: .center,
                    startRadiusFraction: 0,
                    endRadiusFraction: 1
                )
                .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.5)
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.4)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 22) {
                item("The Mandala", active: destination == .mandala) { select(.mandala) }
                item("Today",       active: destination == .today)   { select(.today) }
                item("The Well",    active: destination == .well)    { select(.well) }
                item("The 102",     active: destination == .the102)  { select(.the102) }
                item("Settings",    active: false) {
                    Haptics.light()
                    onSettings()
                    withAnimation(.easeInOut(duration: 0.3)) { isOpen = false }
                }
                item("The Memory",  active: destination == .memory)  { select(.memory) }
            }
        }
    }

    private func item(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.voice(28))
                .foregroundStyle(active ? Color.gold : Color.cream)
                .frame(minHeight: 44)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func select(_ d: RootView.Destination) {
        Haptics.light()
        destination = d
        withAnimation(.easeInOut(duration: 0.3)) { isOpen = false }
    }

    private func close() {
        Haptics.light()
        withAnimation(.easeInOut(duration: 0.3)) { isOpen = false }
    }
}
