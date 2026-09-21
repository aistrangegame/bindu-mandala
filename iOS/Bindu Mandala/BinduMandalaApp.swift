import SwiftUI
import SwiftData

/// Runtime facts the app consults at launch.
enum AppRuntime {
    /// True when the process is hosting an XCTest bundle. Launch-time side
    /// effects (network sync, the periodic re-sync loop, notification
    /// authorization) are skipped so unit tests run against a quiet host.
    static let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

    /// True when this process must never touch Airtable: the XCTest host, a
    /// UI-test launch (`SYNC_OFF` argument), or an explicit `BINDU_SYNC_OFF=1`
    /// environment. `AirtableService` returns early from sync, the flushes and
    /// every write, so a tested app never enqueues or writes a row. Main-actor
    /// isolated because every reader (the service, the scene) already is.
    @MainActor static var syncDisabled: Bool = isUnitTesting
        || ProcessInfo.processInfo.arguments.contains("SYNC_OFF")
        || ProcessInfo.processInfo.environment["BINDU_SYNC_OFF"] == "1"

    /// Debug: skip the first-launch notification-authorization prompt so it never
    /// obscures screenshots. Pass `SKIP_SUMMONS` as a launch argument.
    static let skipsSummons = ProcessInfo.processInfo.arguments.contains("SKIP_SUMMONS")

    /// Debug: pin today's energy to a fixed khaḍgamālā position (1–102) so the
    /// Rite and the Mandala highlight a chosen Śakti in screenshots. Pass
    /// `ENERGY_POS=<n>` as a launch argument.
    static let pinnedEnergyPosition: Int? = {
        guard let arg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("ENERGY_POS=") }),
              let pos = Int(arg.dropFirst("ENERGY_POS=".count)) else { return nil }
        return pos
    }()
}

@main
struct BinduMandalaApp: App {
    let container: ModelContainer

    init() {
        AppFont.audit()
        // Never crash the launch on a store failure — recover the container,
        // preserving any existing store aside. The recognition log and letters
        // then restore from Airtable on the next sync.
        container = PersistenceRecovery.makeContainer()
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
            switch newPhase {
            case .active:
                // Drain any queued recognition writes whenever the app returns to active.
                // Also reschedule the rolling summons window so dates ahead stay primed
                // and today's slot is dropped if the rite was already done.
                guard !AppRuntime.isUnitTesting else { return }
                Task { await AirtableService.shared.flushPending(context: context) }
                Task { await DailySummons.reschedule(enabled: summonsEnabled, hour: summonsHour) }
            case .background:
                // Ring-world voices must not keep sounding once the app leaves
                // the foreground; every drone, triad and descent stops here.
                RingAudioService.shared.stopAll()
                HomeSoundService.shared.stopAll()
            default:
                break
            }
        }
        .task {
            guard !AppRuntime.isUnitTesting, !AppRuntime.skipsSummons else { return }
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
            guard scenePhase == .active, !AppRuntime.isUnitTesting else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(300))
                if Task.isCancelled { return }
                await AirtableService.shared.sync(context: context)
            }
        }
    }
}
