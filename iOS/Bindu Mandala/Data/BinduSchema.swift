import SwiftData

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
/// When that ever stops being possible, add a `V2` here plus a `MigrationStage`
/// — never let the model drift without a versioned step.
///
/// On Ruling 2 ("open instrument; descent is memory-only"): memory-only means the
/// descent is not a server-enforced gate — `DescentState` still *persists* locally
/// and is mirrored to Airtable so a store reset can restore it. Nothing here gates.
enum BinduSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Shakti.self, RecognitionEntry.self, ShaktiLetter.self,
         Avarana.self, NityaDevi.self, DescentState.self]
    }
}

enum BinduMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [BinduSchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}
