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
enum BinduSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Shakti.self, RecognitionEntry.self, ShaktiLetter.self,
         Avarana.self, NityaDevi.self, DescentState.self]
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
    static let lettersOntoKhadgamalaKey = MigrationStage.custom(
        fromVersion: BinduSchemaV1.self,
        toVersion: BinduSchemaV2.self,
        willMigrate: { context in
            let rows = try context.fetch(FetchDescriptor<BinduSchemaV1.ShaktiLetter>())
            LetterMigrationStash.hold(rows.map {
                LetterMigrationStash.Held(legacyPosition: $0.shaktiPosition,
                                          body: $0.body,
                                          updatedAt: $0.updatedAt)
            })
            guard !rows.isEmpty else { return }
            for row in rows { context.delete(row) }
            try context.save()
            log.notice("Letter migration: lifted \(rows.count) letter(s) off the V1 key")
        },
        didMigrate: { context in
            let held = LetterMigrationStash.release()
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

/// Carries the V1 letter rows across the custom stage.
///
/// `willMigrate` and `didMigrate` are two separate closures with no shared
/// context between them, so the rows have to wait somewhere. The migration runs
/// synchronously inside `ModelContainer` init, on whatever thread opened the
/// store, so a lock-guarded static is the whole mechanism — and `release()`
/// empties it, so nothing lingers after the stage.
private enum LetterMigrationStash {
    struct Held {
        let legacyPosition: Int
        let body: String
        let updatedAt: Date
    }

    private static let lock = NSLock()
    nonisolated(unsafe) private static var rows: [Held] = []

    static func hold(_ held: [Held]) {
        lock.lock()
        rows = held
        lock.unlock()
    }

    static func release() -> [Held] {
        lock.lock()
        let held = rows
        rows = []
        lock.unlock()
        return held
    }
}
