import Foundation
import SwiftData

/// A single moment of recognition — "she was felt here · [time]".
/// Local-only. Never synced. Never analyzed. The archive belongs to her.
///
/// Phase-2 schema:
/// - `khadgamalaPosition` is the authoritative key (1-102, globally unique).
/// - `ringNumber` is denormalized for fast per-ring queries (the Portrait).
/// - `shaktiPosition` is the legacy per-ring index (1-16, Ring 2 only). It
///   stays in the schema so older entries are preserved and backfilled at
///   startup by `RecognitionMigrator` — every archived moment survives.
@Model
final class RecognitionEntry {
    var timestamp: Date

    /// Authoritative Khaḍgamālā position 1-102. Equals 0 for pre-Phase-2
    /// entries until the startup backfill runs.
    var khadgamalaPosition: Int = 0

    /// Denormalized ring number 1-9. Equals 0 for pre-Phase-2 entries until
    /// backfill — every pre-Phase-2 entry is Ring 2 by construction (the
    /// only writers before Phase 2 were Today / Recognition / Silence, all
    /// of which addressed the 16 Karṣiṇīs).
    var ringNumber: Int = 0

    /// Legacy per-ring index 1-16 (Ring 2 only). Carried forward losslessly;
    /// new writers leave this at 0 and write `khadgamalaPosition` directly.
    var shaktiPosition: Int = 0

    var note: String?
    var gestureRaw: String

    init(timestamp: Date = .now,
         khadgamalaPosition: Int,
         ringNumber: Int,
         note: String? = nil,
         gesture: Gesture = .felt) {
        self.timestamp = timestamp
        self.khadgamalaPosition = khadgamalaPosition
        self.ringNumber = ringNumber
        self.note = note
        self.gestureRaw = gesture.rawValue
        self.shaktiPosition = 0
    }

    var gesture: Gesture {
        get { Gesture(rawValue: gestureRaw) ?? .felt }
        set { gestureRaw = newValue.rawValue }
    }

    enum Gesture: String, Codable, CaseIterable {
        case felt      // "I feel her" tap
        case silence   // Bindu / Silence dwell
    }
}
