import Foundation
import SwiftData

/// A private letter to one of the 16 Karṣiṇīs of Ring 2 — the only ring The Well
/// addresses. One per Śakti, keyed by `shaktiPosition` (1–16).
///
/// Offline-first, not local-only: this row is the source of truth, and its body
/// is mirrored up to the Shakti row's `Letter` field (`AirtableService.saveLetter`,
/// queued when offline), restored from Airtable on sync when no local draft exists
/// (`seedLetterIfMissing`), and the first non-empty letter for a Śakti is ledgered
/// once to App Activity. Private to the practitioner's own base.
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
