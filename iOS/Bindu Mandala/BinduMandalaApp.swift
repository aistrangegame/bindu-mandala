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
    /// U0 · a `SNAPSHOT=<date>` launch (DEBUG) is never live either: it reads
    /// the dated export (`SnapshotSource`) and its writes go to `SnapshotLedger`.
    @MainActor static var syncDisabled: Bool = isUnitTesting
        || ProcessInfo.processInfo.arguments.contains("SYNC_OFF")
        || ProcessInfo.processInfo.environment["BINDU_SYNC_OFF"] == "1"
        || SnapshotSource.isActive

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
    /// **The LAST `ENERGY_POS` wins**, so a screen may override a suite-wide
    /// default by appending its own. With a single argument — every real launch,
    /// and every caller before this — the answer is identical to taking the
    /// first. `FeltRegisterSnapshots` relies on it: its base pins kp 29 for the
    /// Rite, and the Field appends a position outside the bootstrap roster so
    /// its composition stops depending on which day the suite is run.
    static let pinnedEnergyPosition: Int? = {
        guard let arg = ProcessInfo.processInfo.arguments.last(where: { $0.hasPrefix("ENERGY_POS=") }),
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
        // Wave 5 · a tapped gift lands on her. Installed before launch finishes,
        // so a gift that opens the app is not missed.
        GiftRouter.shared.install()
        // U2 · every world is given its view as the root is made, before it
        // first draws (`SpineRoot.init` → `SpineWorlds.registerAll()`).
    }

    var body: some Scene {
        WindowGroup {
            // U2 · the root is the spine (`Views/Root/AppRoot.swift`): one
            // world at a time, every launch arriving at the Bindu (ruling 1).
            AppRoot()
                // Wave 1 · the Homes: her siddhi lingers on the whole
                // instrument after a stay (`Views/Rooms/HerSiddhiLingers.swift`).
                .herSiddhiLingers()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
