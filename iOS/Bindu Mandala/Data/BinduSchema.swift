import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "schema-migration")

/// The versioned SwiftData schema for the instrument.
///
/// Adopting a `VersionedSchema` + `SchemaMigrationPlan` is the guard that keeps a
/// future model change from ever tripping `PersistenceRecovery` into moving the
/// store aside and opening a fresh, empty one (which would silently lose years of
/// recognitions, letters, and the descent timeline).
///
/// **The invariant that keeps every future stage lightweight:** every new stored
/// property added to a model is **Optional or has a default value**. Additive,
/// defaulted changes migrate `.lightweight` and never require a custom stage.
/// When that ever stops being possible — as it did for `ShaktiLetter` in V2,
/// whose *unique key itself* changed — add a new version here plus a
/// `MigrationStage`, and never let the model drift without a versioned step.
///
/// On Ruling 2 ("open instrument; descent is memory-only"): memory-only means the
/// descent is not a server-enforced gate — `DescentState` still *persists* locally
/// and is mirrored to Airtable so a store reset can restore it. Nothing here gates.

// MARK: - V1 — as shipped through Phase 1

/// The schema every store written before Phase 2.1 conforms to.
///
/// Only `ShaktiLetter` is frozen at its V1 shape (below); the other five models
/// are unchanged across V1 and V2 and so are listed by their live types. Any
/// future change to one of *those* must freeze it here the same way first.
enum BinduSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Shakti.self, RecognitionEntry.self, BinduSchemaV1.ShaktiLetter.self,
         Avarana.self, NityaDevi.self, DescentState.self]
    }

    /// The V1 letter row: keyed by the Ring-2 per-ring index (1–16), because
    /// Ring 2 was the only ring The Well addressed.
    ///
    /// Nested deliberately. SwiftData names an entity by its **unqualified**
    /// type name, so this is the very same `ShaktiLetter` entity a V1 store on
    /// disk holds — while the top-level `ShaktiLetter` is free to move to the
    /// Khaḍgamālā key. Never referenced outside the migration.
    @Model
    final class ShaktiLetter {
        @Attribute(.unique) var shaktiPosition: Int
        var body: String
        var updatedAt: Date

        init(shaktiPosition: Int, body: String = "", updatedAt: Date = .now) {
            self.shaktiPosition = shaktiPosition
            self.body = body
            self.updatedAt = updatedAt
        }
    }
}

// MARK: - V2 — letters keyed by Khaḍgamālā position

/// Phase 2.1: a letter belongs to any of the 102, not only the 16 Karṣiṇīs.
/// `ShaktiLetter`'s identity becomes `khadgamalaPosition` (1–102) and the legacy
/// per-ring key survives as plain provenance.
///
/// Phase 2.2 adds `HomeMemory` to this same version. A **new** entity is the
/// lightweight case by definition — no existing row changes shape, and a V1
/// store simply arrives at V2 with one more, empty table — so it needs no stage
/// of its own and rides the letter stage already here. (`LetterMigrationTests`
/// and `SchemaMigrationTests` are the proof: they migrate and reopen real
/// stores on disk with this model list.)
enum BinduSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Shakti.self, RecognitionEntry.self, ShaktiLetter.self,
         Avarana.self, NityaDevi.self, DescentState.self, HomeMemory.self]
    }
}

/// The single place that names the version the app runs on today. Every site
/// that opens a container builds *this* — never a pinned version — so adding a
/// V3 is one edit here plus its stage.
enum BinduSchema {
    static var latest: any VersionedSchema.Type { BinduSchemaV2.self }

    /// The `Schema` the app opens its store with.
    static func makeLatest() -> Schema {
        Schema(latest.models, version: latest.versionIdentifier)
    }
}

// MARK: - The plan

enum BinduMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [BinduSchemaV1.self, BinduSchemaV2.self] }
    static var stages: [MigrationStage] { [lettersOntoKhadgamalaKey] }

    /// Ring-2 offset: per-ring index 1–16 → Khaḍgamālā 29–44.
    private static let ringTwoOffset = KhadgamalaMap.ringStartOffset(2)

    /// V1 → V2: carry every letter from the per-ring key onto the Khaḍgamālā key.
    ///
    /// It has to be a *custom* stage. `khadgamalaPosition` is `@Attribute(.unique)`,
    /// so a lightweight migration — which gives every existing row the property's
    /// default — would hand all sixteen letters the same key and collide. So the
    /// rows are lifted out on the V1 side, the (now empty) table is migrated, and
    /// they are put back on the V2 side under their mapped keys. Nothing is
    /// rewritten in flight: body and `updatedAt` are carried across untouched, and
    /// the legacy key is preserved beside the new one.
    ///
    /// Idempotent by construction: SwiftData runs a stage only when the store on
    /// disk is actually at V1, so a reopened V2 store never re-enters it.
    ///
    /// **The lift never lives only in RAM.** The delete on the V1 side is
    /// *committed*, and the rows do not return until `didMigrate` — so a kill
    /// inside that window (the launch watchdog, jetsam, a force-quit of a launch
    /// that looks hung) would take every letter with it, with no `.corrupt-`
    /// copy to recover from, because nothing failed. So the bodies are written to
    /// a sidecar beside the store *before* the delete and unlinked only after
    /// they are back in the store; the next launch restores from that file.
    static let lettersOntoKhadgamalaKey = MigrationStage.custom(
        fromVersion: BinduSchemaV1.self,
        toVersion: BinduSchemaV2.self,
        willMigrate: { context in
            let store = LetterMigrationStash.storeURL(for: context)
            let rows = try context.fetch(FetchDescriptor<BinduSchemaV1.ShaktiLetter>())
            let held = rows.map {
                LetterMigrationStash.Held(legacyPosition: $0.shaktiPosition,
                                          body: $0.body,
                                          updatedAt: $0.updatedAt)
            }
            LetterMigrationStash.hold(held, for: store)
            // Nothing to lift — and, on a re-entered stage over an already
            // emptied table, nothing to overwrite: the sidecar from the attempt
            // that emptied it stays exactly where it is.
            guard !rows.isEmpty else { return }
            try LetterMigrationStash.writeSidecar(held, besideStoreAt: store)
            for row in rows { context.delete(row) }
            try context.save()
            log.notice("Letter migration: lifted \(rows.count) letter(s) off the V1 key")
        },
        didMigrate: { context in
            let store = LetterMigrationStash.storeURL(for: context)
            // The sidecar wins over the stash: on the ordinary path the two hold
            // the same rows, and after a kill inside the stage the stash died
            // with the process while the file did not.
            let inMemory = LetterMigrationStash.release(for: store)
            let onDisk = LetterMigrationStash.readSidecar(besideStoreAt: store)
            let held = onDisk.isEmpty ? inMemory : onDisk
            if !onDisk.isEmpty && inMemory.isEmpty {
                log.notice("Letter migration: \(onDisk.count) letter(s) recovered from the sidecar — a previous attempt did not finish")
            }
            // Nothing to put back. Any file still lying there is one this stage
            // could not read, and an unreadable copy of her words is still the
            // only copy — it is left where it is rather than unlinked.
            guard !held.isEmpty else { return }

            var restored = 0
            var quarantined = 0
            for row in held {
                let key: Int
                if (1...16).contains(row.legacyPosition) {
                    key = row.legacyPosition + ringTwoOffset
                    restored += 1
                } else {
                    // There are none of these today — V1 only ever wrote 1–16.
                    // Should one exist, her words are not ours to throw away:
                    // park it on a key that cannot collide with any of the 102
                    // (the V1 key was unique, so these stay unique too), keep
                    // the legacy value verbatim in `shaktiPosition`, and say so.
                    key = quarantineKey(forLegacy: row.legacyPosition)
                    quarantined += 1
                    log.error("""
                        Letter migration: legacy position \(row.legacyPosition) is outside \
                        Ring 2 (1–16) — preserved at Khaḍgamālā key \(key) rather than dropped
                        """)
                }
                context.insert(ShaktiLetter(khadgamalaPosition: key,
                                            shaktiPosition: row.legacyPosition,
                                            body: row.body,
                                            updatedAt: row.updatedAt))
            }
            try context.save()
            // Only now, with the bodies committed under their new keys, does the
            // copy of last resort go.
            LetterMigrationStash.removeSidecar(besideStoreAt: store)
            log.notice("Letter migration: \(restored) letter(s) onto the Khaḍgamālā key, \(quarantined) preserved out of range")
        }
    )

    /// A key for a legacy position the Ring-2 mapping cannot place: always above
    /// 102, so it can never be mistaken for one of the Śaktis, and one-to-one in
    /// the legacy value (the zig-zag fold keeps a negative apart from its
    /// positive twin), so two such rows can never land on each other either.
    static func quarantineKey(forLegacy legacy: Int) -> Int {
        1000 + (legacy >= 0 ? 2 * legacy : -2 * legacy + 1)
    }
}

/// Carries the V1 letter rows across the custom stage — in memory for the
/// ordinary pass, and on disk so no kill inside the stage can be the end of them.
///
/// `willMigrate` and `didMigrate` are two separate closures with no shared
/// context between them, so the rows have to wait somewhere. The migration runs
/// synchronously inside `ModelContainer` init, on whatever thread opened the
/// store, so a lock-guarded static is the whole mechanism — and `release()`
/// empties it, so nothing lingers after the stage.
///
/// The static alone is not enough, because the process can end between the two
/// closures with the V1 delete already committed. So `willMigrate` also writes
/// the bodies to `<store>.letter-migration.json` beside the store and syncs it
/// to disk before deleting anything, and `didMigrate` prefers that file, deleting
/// it only once the rows are saved under their new keys. Internal rather than
/// private so `LetterMigrationTests` can stage that unfinished state with the
/// very code that writes it, instead of a hand-copied JSON shape.
enum LetterMigrationStash {
    struct Held: Codable {
        let legacyPosition: Int
        let body: String
        let updatedAt: Date
    }

    private static let lock = NSLock()
    nonisolated(unsafe) private static var rows: [Held] = []
    /// Which store the rows were lifted from, so a full stash is never handed to
    /// a different store's stage.
    nonisolated(unsafe) private static var heldFor: URL?

    /// Hold the lifted rows. An **empty** hold never clobbers a full one for the
    /// same store: if attempt 1 lifted the rows out and the container init then
    /// failed, attempt 2 re-enters `willMigrate` over an emptied table and would
    /// otherwise replace the held letters with `[]`.
    static func hold(_ held: [Held], for store: URL?) {
        lock.lock()
        defer { lock.unlock() }
        if held.isEmpty, !rows.isEmpty, heldFor == store { return }
        rows = held
        heldFor = store
    }

    /// The rows lifted from `store`, and nothing if the stash belongs to another
    /// store (whose own retry may still need them).
    static func release(for store: URL?) -> [Held] {
        lock.lock()
        defer { lock.unlock() }
        guard heldFor == store else { return [] }
        let held = rows
        rows = []
        heldFor = nil
        return held
    }

    // MARK: - The copy on disk

    /// The store the migrating context is opening, when it can be known.
    static func storeURL(for context: ModelContext) -> URL? {
        context.container.configurations.first?.url
    }

    /// `default.store.letter-migration.json`, beside the store itself.
    static func sidecarURL(besideStoreAt store: URL) -> URL {
        store.deletingLastPathComponent()
            .appendingPathComponent(store.lastPathComponent + ".letter-migration.json")
    }

    /// Write the bodies down and fsync them **before** the rows leave the store.
    ///
    /// Throwing here fails the migration, which is the safe end of it: the V1
    /// delete has not been committed yet, so `PersistenceRecovery` sets the store
    /// aside whole rather than emptied. Only an unknowable store URL is tolerated
    /// — refusing a migration that would otherwise succeed would be the worse
    /// trade, and it leaves the in-memory stash exactly as it was before.
    static func writeSidecar(_ held: [Held], besideStoreAt store: URL?) throws {
        guard let store else {
            log.error("Letter migration: no store URL — the lift is held in memory only")
            return
        }
        let url = sidecarURL(besideStoreAt: store)
        let data = try JSONEncoder().encode(held)
        try data.write(to: url, options: [.atomic])
        if let handle = try? FileHandle(forUpdating: url) {
            try? handle.synchronize()
            try? handle.close()
        }
        log.notice("Letter migration: \(held.count) letter(s) staged on disk before the delete")
    }

    /// What a previous, unfinished attempt left behind — empty when there is
    /// nothing, and empty rather than fatal when the file cannot be read.
    static func readSidecar(besideStoreAt store: URL?) -> [Held] {
        guard let store else { return [] }
        let url = sidecarURL(besideStoreAt: store)
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let held = try? JSONDecoder().decode([Held].self, from: data) else {
            log.error("Letter migration: the staged letters could not be read — leaving \(url.lastPathComponent) in place")
            return []
        }
        return held
    }

    static func removeSidecar(besideStoreAt store: URL?) {
        guard let store else { return }
        try? FileManager.default.removeItem(at: sidecarURL(besideStoreAt: store))
    }
}
