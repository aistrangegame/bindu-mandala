import SwiftUI
import SwiftData

/// The home is not a screen — it is a presence.
/// The yantra fills the surface. The hamburger is the minimum concession.
struct RootView: View {
    @Environment(\.modelContext) private var context
    @State private var destination: Destination = Self.initialDestination()
    @State private var menuOpen = false
    @State private var settingsPresented = false

    enum Destination { case mandala, today, well, the102, memory }

    private static func initialDestination() -> Destination {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("START_TAB=today")  { return .today }
        if args.contains("START_TAB=well")   { return .well }
        if args.contains("START_TAB=102")    { return .the102 }
        if args.contains("START_TAB=memory") { return .memory }
        return .mandala
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.ground.ignoresSafeArea()

            Group {
                switch destination {
                case .mandala:
                    MandalaScreenView(
                        onPetalTap: { _ in
                            // Phase 5: present Shakti Detail.
                        },
                        onBinduTap: {
                            // Phase 6: present Silence screen.
                        }
                    )
                case .today:
                    TodayView()
                case .well:
                    WellView()
                case .the102:
                    TheHundredTwoView()
                case .memory:
                    PortraitMandalaView()
                }
            }

            HamburgerButton {
                withAnimation(.easeInOut(duration: 0.3)) { menuOpen = true }
            }
            .padding(.top, 16)
            .padding(.trailing, 16)

            if menuOpen {
                HamburgerMenuView(
                    destination: $destination,
                    isOpen: $menuOpen,
                    onSettings: { settingsPresented = true }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsView()
        }
        .task {
            ShaktiBootstrap.seedIfNeeded(context: context)
            await AirtableService.shared.sync(context: context)
        }
    }
}

private struct HamburgerButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            Haptics.light()
            action()
        } label: {
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gold.opacity(0.45))
                        .frame(width: 18, height: 1)
                }
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
