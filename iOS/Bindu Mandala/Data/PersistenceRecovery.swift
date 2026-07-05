import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "persistence")

/// Builds the app's `ModelContainer` without ever crashing the launch.
///
/// A SwiftData failure — most often a migration the lightweight migrator can't
/// perform after a model change — must never leave the practitioner staring at
/// a dead white screen. The instrument is meant to be lived with for years; its
/// front door must always open.
///
/// Strategy, in order:
///   1. Open the normal on-disk store.
///   2. On failure, move the existing store files aside (preserved, never
///      deleted) and open a fresh on-disk store — the app re-syncs from Airtable
///      and restores the recognition log + letters (see `AirtableService`).
///   3. As a last resort, an in-memory store, so the instrument still opens.
enum PersistenceRecovery {

    private static let models: [any PersistentModel.Type] = [
        Shakti.self, RecognitionEntry.self, ShaktiLetter.self,
        Avarana.self, NityaDevi.self, DescentState.self
    ]

    static func makeContainer() -> ModelContainer {
        let schema = Schema(models)

        // 1 — the normal on-disk store.
        do {
            return try ModelContainer(for: schema)
        } catch {
            log.error("Primary store failed: \(error.localizedDescription, privacy: .public) — recovering")
        }

        // 2 — preserve the old store aside, open a fresh on-disk store.
        preserveExistingStore()
        do {
            return try ModelContainer(for: schema)
        } catch {
            log.error("Fresh store failed: \(error.localizedDescription, privacy: .public) — falling back to in-memory")
        }

        // 3 — in-memory, so the app still opens even if the disk is unusable.
        do {
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            // Constructing an empty in-memory container fails only under
            // catastrophic conditions (e.g. a schema the runtime rejects).
            // Nothing is recoverable at that point.
            fatalError("Unable to create any ModelContainer: \(error)")
        }
    }

    /// Move the default SwiftData store (and its -wal/-shm sidecars) to a
    /// timestamped backup alongside it, so a corrupt or unmigratable store is
    /// set aside rather than lost.
    private static func preserveExistingStore() {
        let fm = FileManager.default
        guard let appSupport = try? fm.url(for: .applicationSupportDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil, create: false) else { return }
        let stamp = Int(Date().timeIntervalSince1970)
        for suffix in ["store", "store-wal", "store-shm"] {
            let src = appSupport.appendingPathComponent("default.\(suffix)")
            guard fm.fileExists(atPath: src.path) else { continue }
            let dst = appSupport.appendingPathComponent("default.corrupt-\(stamp).\(suffix)")
            try? fm.moveItem(at: src, to: dst)
        }
        log.notice("Preserved existing store aside as default.corrupt-\(stamp).*")
    }
}
