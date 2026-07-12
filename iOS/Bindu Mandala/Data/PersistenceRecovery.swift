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

    /// Build the container. `storeURL` is injectable purely so tests can drive the
    /// real recovery path against a hermetic temp store (the app always passes nil
    /// → SwiftData's default location). The versioned `BinduMigrationPlan` is what
    /// keeps an additive, defaulted model change opening in place instead of
    /// throwing — so the preserve-and-recover path fires only on true corruption.
    static func makeContainer(storeURL: URL? = nil) -> ModelContainer {
        let schema = Schema(BinduSchemaV1.models)
        func configuration() -> ModelConfiguration {
            if let storeURL { return ModelConfiguration(schema: schema, url: storeURL) }
            return ModelConfiguration(schema: schema)
        }

        // 1 — the normal on-disk store, migrated by the versioned plan.
        do {
            return try ModelContainer(for: schema,
                                      migrationPlan: BinduMigrationPlan.self,
                                      configurations: configuration())
        } catch {
            log.error("Primary store failed: \(error.localizedDescription, privacy: .public) — recovering")
        }

        // 2 — preserve the old store aside, open a fresh on-disk store.
        preserveExistingStore(storeURL: storeURL)
        do {
            return try ModelContainer(for: schema,
                                      migrationPlan: BinduMigrationPlan.self,
                                      configurations: configuration())
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

    /// Move the SwiftData store (and its -wal/-shm sidecars) to a timestamped
    /// backup alongside it, so a corrupt or unmigratable store is set aside rather
    /// than lost. Operates on the injected store when present, else the default.
    private static func preserveExistingStore(storeURL: URL?) {
        let fm = FileManager.default
        let base: URL
        if let storeURL {
            base = storeURL
        } else {
            guard let appSupport = try? fm.url(for: .applicationSupportDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil, create: false) else { return }
            base = appSupport.appendingPathComponent("default.store")
        }
        let dir = base.deletingLastPathComponent()
        let name = base.lastPathComponent
        let stamp = Int(Date().timeIntervalSince1970)
        for suffix in ["", "-wal", "-shm"] {
            let src = dir.appendingPathComponent(name + suffix)
            guard fm.fileExists(atPath: src.path) else { continue }
            let dst = dir.appendingPathComponent("\(name).corrupt-\(stamp)\(suffix)")
            try? fm.moveItem(at: src, to: dst)
        }
        log.notice("Preserved existing store aside as \(name).corrupt-\(stamp).*")
    }
}
