import Foundation
import SwiftData

/// A single moment of recognition — "she was felt here · [time]".
/// Local-only. Never synced. Never analyzed. The archive belongs to her.
@Model
final class RecognitionEntry {
    var timestamp: Date
    /// 1–16. Position rather than @Relationship to keep this resilient to Shakti row replacement.
    var shaktiPosition: Int
    /// Optional free-text noticing.
    var note: String?
    /// Gesture type — "felt" (from "I feel her") or "silence" (from Bindu tap).
    var gestureRaw: String

    init(timestamp: Date = .now, shaktiPosition: Int, note: String? = nil, gesture: Gesture = .felt) {
        self.timestamp = timestamp
        self.shaktiPosition = shaktiPosition
        self.note = note
        self.gestureRaw = gesture.rawValue
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
