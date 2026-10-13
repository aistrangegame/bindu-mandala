import SwiftUI
import SwiftData

// MARK: - U2 · B · the app's root
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Arriving" and §2 A #4 (ruling
// 1: launch arrives at the Bindu). The root is the spine (`SpineRoot`): one
// world at a time from the Router's address, and every launch arrives at
// Home. The old `RootView` — five rooms behind a hamburger, a same-day
// restore of the last room, launch on the Rite — is retired; what it did
// lives in `SpineServices` and the Router (see `SpineRoot`'s header).
//
// The launch ceremony stands above the root on every launch (his ruling: the
// Homecoming every launch): Part A's Waking → Homecoming when registered
// (`WorldBuilders.registerLaunch`), else the existing `HomecomingView`. When
// Settings asks to re-enter it, the Router owes the ceremony and it is
// played again, at Home.

/// The root: the spine, and the ceremony every launch passes through.
@MainActor
struct AppRoot: View {
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @AppStorage("daily_summons_enabled") private var summonsEnabled = true
    @AppStorage("daily_summons_hour")    private var summonsHour: Int = DailySummons.defaultHour

    /// U2 merge: Home owns the arrival (the Waking, then the Homecoming — Part A's
    /// `HomeWorld`), so the shell no longer plays a second one over it. This
    /// overlay now only answers Settings → "Re-enter the Homecoming".
    @State private var showHomecoming: Bool = false

    private var router: Router { Router.shared }

    var body: some View {
        ZStack {
            SpineRoot(router: router)
            if showHomecoming {
                LaunchCeremony(isPresented: $showHomecoming)
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
        .animation(.easeInOut(duration: 0.8), value: showHomecoming)
        // Settings → "Re-enter the Homecoming": the Router owes it; play it at Home.
        .onChange(of: router.pendingCeremony) { _, owed in
            guard owed != nil, router.takeCeremony() == .homecoming else { return }
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
                // Wave 5 · the gift's fortnight stays drawn, and practice set
                // down offline (strokes, river letters, wagers) reaches the ledger.
                Task { await EnergyGift.reschedule() }
                Task { await PracticeLedger.flush(context: context) }
            case .background:
                // Ring-world voices must not keep sounding once the app leaves
                // the foreground; every drone, triad and descent stops here.
                RingAudioService.shared.stopAll()
                HomeSoundService.shared.stopAll()
                // Wave 6 · and the Om, which the field's stop leaves standing.
                SoundConductor.shared.letGo()
            default:
                break
            }
        }
        // **Keyed on the homecoming, so the prompt never lands on top of it.**
        //
        // The authorization alert used to fire from a bare `.task` at launch,
        // which put a system dialog over `HomecomingView` — the app's one
        // ceremonial greeting. Keying the task on `showHomecoming` declines
        // while the greeting is up and runs again the moment it goes.
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

/// The ceremony every launch passes through (`spine-and-home.md` §1
/// "Arriving"): Part A's, when registered; the existing Homecoming otherwise.
@MainActor
struct LaunchCeremony: View {
    @Binding var isPresented: Bool

    var body: some View {
        if let build = WorldBuilders.launchCeremony {
            build { isPresented = false }
        } else {
            HomecomingView(isPresented: $isPresented)
        }
    }
}
