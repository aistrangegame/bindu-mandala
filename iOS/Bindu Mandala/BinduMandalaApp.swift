import SwiftUI
import SwiftData

@main
struct BinduMandalaApp: App {
    let container: ModelContainer

    init() {
        AppFont.audit()
        do {
            container = try ModelContainer(
                for: Shakti.self, RecognitionEntry.self, ShaktiLetter.self,
                     Avarana.self, NityaDevi.self
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
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @AppStorage("daily_summons_enabled") private var summonsEnabled = true
    @AppStorage("daily_summons_hour")    private var summonsHour: Int = DailySummons.defaultHour

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
        .onChange(of: scenePhase) { _, newPhase in
            // Drain any queued recognition writes whenever the app returns to active.
            // Also reschedule the rolling summons window so dates ahead stay primed
            // and today's slot is dropped if the rite was already done.
            if newPhase == .active {
                Task { await AirtableService.shared.flushPending(context: context) }
                Task { await DailySummons.reschedule(enabled: summonsEnabled, hour: summonsHour) }
            }
        }
        .task {
            // First-launch authorization for the default-on summons. Silent
            // once the system has a decision; only runs while still
            // .notDetermined, so the practitioner sees the prompt at most once.
            guard summonsEnabled else { return }
            let status = await DailySummons.authorizationStatus()
            switch status {
            case .notDetermined:
                let ok = await DailySummons.requestAuthorization()
                if ok {
                    await DailySummons.reschedule(enabled: true, hour: summonsHour)
                } else {
                    summonsEnabled = false
                }
            case .authorized, .provisional:
                await DailySummons.reschedule(enabled: true, hour: summonsHour)
            default:
                summonsEnabled = false
            }
        }
        .task(id: scenePhase) {
            // Periodic background re-sync while the app is foregrounded, so
            // Airtable edits made elsewhere show up without a relaunch. The
            // task is cancelled and reissued on every scenePhase change, so
            // backgrounding cleanly stops the loop.
            guard scenePhase == .active else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(300))
                if Task.isCancelled { return }
                await AirtableService.shared.sync(context: context)
            }
        }
    }
}
