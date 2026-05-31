import Foundation
import SwiftData

/// One of the 15 Nityā Devīs presiding over the tithis of the waxing fortnight.
/// Position 16 (full moon) is Lalitā — the Ring 9 Bindu — and has no separate Nityā record.
@Model
final class NityaDevi {
    @Attribute(.unique) var tithiPosition: Int  // 1–15
    var airtableRecordId: String
    var sanskritName: String                    // fldJOatnYrw9l6tff
    var tithiName: String?
    var quality: String?                         // fldnwcu7zv7uV1ta2
    var qualityDescription: String?              // fldTwrtI5CyUnJV2F (polymorphic — Nityā context)
    var lastSyncedAt: Date?

    init(tithiPosition: Int, airtableRecordId: String, sanskritName: String) {
        self.tithiPosition = tithiPosition
        self.airtableRecordId = airtableRecordId
        self.sanskritName = sanskritName
    }
}
