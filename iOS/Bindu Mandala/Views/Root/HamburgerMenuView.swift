import SwiftUI
import SwiftData

/// The only navigation chrome in the app. A whisper, not a feature.
/// Full-screen veil, six items in italic Cormorant — the five rooms in descent
/// order, then Settings last.
///
/// Wave 1: the veil is lit by the day (`MenuVeil`): today's glow standing in
/// the middle of her deep ground, the room you are in written in her bright
/// accent. It was a fixed 8% red over the base ground — the same veil on every
/// day of the year.
struct HamburgerMenuView: View {
    @Binding var destination: RootView.Destination
    @Binding var isOpen: Bool
    var onSettings: () -> Void

    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    var body: some View {
        let day = DayLight.atmosphere(shaktis)
        ZStack {
            LightField(layers: Backdrop.veil(day))
                .ignoresSafeArea()
            // A tap anywhere off the six closes the veil.
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture { close() }

            VStack(spacing: 14) {
                item("The Mandala", active: destination == .mandala, day: day) { select(.mandala) }
                item("The Rite",    active: destination == .rite, day: day)    { select(.rite) }
                item("The Well",    active: destination == .well, day: day)    { select(.well) }
                item("The Field",   active: destination == .the102, day: day)  { select(.the102) }
                item("The Memory",  active: destination == .memory, day: day)  { select(.memory) }
                item("Settings",    active: false, day: day, quiet: true) {
                    Haptics.light()
                    onSettings()
                    withAnimation(.easeInOut(duration: 0.3)) { isOpen = false }
                }
                .padding(.top, 18)
            }
        }
    }

    private func item(_ title: String, active: Bool, day: Atmosphere, quiet: Bool = false,
                      action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.voice(quiet ? 22 : 32))
                .tracking(quiet ? 0.4 : 1.2)
                .foregroundStyle(active ? day.accentBright : (quiet ? Color.cream.opacity(0.6) : Color.cream))
                .shadow(color: active ? day.glow : .clear, radius: 18)
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
