import SwiftUI
import SwiftData

@main
struct BinduMandalaApp: App {
    let container: ModelContainer

    init() {
        AppFont.audit()
        do {
            container = try ModelContainer(
                for: Shakti.self, RecognitionEntry.self, ShaktiLetter.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRoot()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}

/// Wraps RootView and gates the Homecoming screen on first launch.
private struct AppRoot: View {
    @State private var showHomecoming: Bool = {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("FORCE_HOMECOMING") { return true }
        if args.contains("SKIP_HOMECOMING")  { return false }
        return !HomecomingView.hasLaunched
    }()

    var body: some View {
        ZStack {
            RootView()
            if showHomecoming {
                HomecomingView(isPresented: $showHomecoming)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.8), value: showHomecoming)
        .onReceive(NotificationCenter.default.publisher(for: HomecomingView.reEnterNotification)) { _ in
            showHomecoming = true
        }
    }
}
