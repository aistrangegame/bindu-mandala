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

    /// Debug: open a **fresh in-memory store** instead of the practitioner's own,
    /// so a UI-test launch reads the instrument exactly as a new install does and
    /// writes nothing that a later launch — or a later test in the same run — can
    /// read back. Pass `EPHEMERAL_STORE` as a launch argument.
    ///
    /// Law 8 (*Ashrey's practice is sacred data*) is why this is written the way
    /// it is: the argument exists only in a DEBUG build, and even there it never
    /// opens, moves or deletes the on-disk store — it simply does not go near it.
    /// `EphemeralStoreTests` holds both halves of that sentence.
    static let usesEphemeralStore: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("EPHEMERAL_STORE")
        #else
        return false
        #endif
    }()

    /// Debug: draw the Homes layer on its **still path** — the rite, the room
    /// and the axis as a walker with the system's own Reduce Motion on sees
    /// them — without asking the host to change a system setting mid-suite.
    /// Pass `REDUCE_MOTION` as a launch argument.
    ///
    /// It is the same `forceReduceMotion` the captures and the room suites
    /// already take, reached from the shell so the *whole* path can be driven by
    /// a finger: the still way out is a touch rather than a hold, and nothing
    /// short of the running app proves that one touch really leaves the room.
    /// DEBUG only, so no shipped build has a way to reach it.
    static let forcesReduceMotion: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("REDUCE_MOTION")
        #else
        return false
        #endif
    }()

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
        // **Keyed on the homecoming, so the prompt never lands on top of it.**
        //
        // The authorization alert used to fire from a bare `.task` at launch,
        // which put a system dialog over `HomecomingView` — the app's one
        // ceremonial greeting, and on the smallest screen it covered both lines
        // of it outright. Worse than covering them: while the alert is up the
        // homecoming's tap-to-enter is inert, so the very first thing a new
        // walker does is swallowed, and he has learned before anything else
        // that touching this app does nothing.
        //
        // The prompt costs nothing after the greeting is dismissed, and keying
        // the task on `showHomecoming` is the whole fix: it declines while the
        // greeting is up and runs again the moment it goes. On every launch
        // after the first, `showHomecoming` is already false and the timing is
        // exactly what it was.
        .task(id: showHomecoming) {
            guard !AppRuntime.isUnitTesting, !AppRuntime.skipsSummons else { return }
            guard !showHomecoming else { return }
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
