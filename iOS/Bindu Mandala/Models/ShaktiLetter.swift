import Foundation
import SwiftData

/// A private letter to one of the 102 Śaktis of the Khaḍgamālā. One per Śakti,
/// keyed by `khadgamalaPosition` (1–102) — the same global identity the Shakti
/// row, the recognition log and the ledger all speak.
///
/// Offline-first, not local-only: this row is the source of truth, and its body
/// is mirrored up to the Shakti row's `Letter` field (`AirtableService.saveLetter`,
/// queued when offline), restored from Airtable on sync when no local draft exists
/// (`seedLetterIfMissing`), and the first non-empty letter for a Śakti is ledgered
/// once to App Activity. Private to the practitioner's own base.
///
/// The words are the practitioner's alone. Nothing ever writes a body but her:
/// no seed text, no placeholder, no generated draft — and merely *opening* a
/// letter writes nothing at all (see `LetterStore`).
@Model
final class ShaktiLetter {
    /// Identity: the global Khaḍgamālā position, 1–102.
    @Attribute(.unique) var khadgamalaPosition: Int

    /// Provenance only. Before Schema V2 a letter was keyed by the Ring-2
    /// per-ring index (1–16); the V1→V2 stage preserves that legacy key here
    /// beside the Khaḍgamālā one so a migrated row can always be traced back
    /// to the store it came from. `0` means "never had a per-ring key" — every
    /// letter created from V2 onward.
    var shaktiPosition: Int

    var body: String
    var updatedAt: Date

    init(khadgamalaPosition: Int,
         shaktiPosition: Int = 0,
         body: String = "",
         updatedAt: Date = .now) {
        self.khadgamalaPosition = khadgamalaPosition
        self.shaktiPosition = shaktiPosition
        self.body = body
        self.updatedAt = updatedAt
    }
}

extension Shakti {
    /// The Khaḍgamālā position her letter is keyed by. A pre-Phase-1 bootstrap
    /// row that sync has not yet reconciled carries only the Ring-2 per-ring
    /// index, so the ring's offset restores the global key.
    var letterKey: Int {
        khadgamalaPosition ?? (position + KhadgamalaMap.ringStartOffset(2))
    }
}
