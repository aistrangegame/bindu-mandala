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

    /// The fifteen tithi names, indexed 1…15. Canonical and stable — the source
    /// of truth for the tithi label, since the `tithiName` column isn't seeded.
    static let tithiNames = [
        "Pratipadā", "Dvitīyā", "Tṛtīyā", "Caturthī", "Pañcamī",
        "Ṣaṣṭhī", "Saptamī", "Aṣṭamī", "Navamī", "Daśamī",
        "Ekādaśī", "Dvādaśī", "Trayodaśī", "Caturdaśī", "Pūrṇimā",
    ]

    /// The canonical Sanskrit tithi name for this Nityā's position. Prefers a
    /// synced `tithiName` if one ever lands, else the stable table.
    var tithiDisplayName: String {
        if let t = tithiName?.trimmingCharacters(in: .whitespaces), !t.isEmpty { return t }
        guard tithiPosition >= 1, tithiPosition <= Self.tithiNames.count else { return "this tithi" }
        return Self.tithiNames[tithiPosition - 1]
    }
}
