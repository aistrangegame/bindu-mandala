import Foundation
import SwiftData

/// A private letter to one of the 16 Śaktis. Local-only, never synced, never read by anyone.
/// One per Shakti, addressed by `shaktiPosition` (1–16).
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
