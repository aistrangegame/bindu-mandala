import Foundation
import SwiftData

/// One of the nine Avaraṇas of the Śrī Yantra.
/// Each Avaraṇa is a ring — its own territory with its own atmosphere.
/// All rings are accessible from day one; the model holds ceremony data only.
@Model
final class Avarana {
    @Attribute(.unique) var ringNumber: Int  // 1–9
    var airtableRecordId: String
    var sanskritName: String
    var subtitle: String?
    var form: String?
    var presidingForm: String?         // fldTwrtI5CyUnJV2F (polymorphic — Avaraṇa context)
    var mentalState: String?
    var subtleBodyChakra: String?      // fld6deGFzModjBmoj
    var geometricShape: String?
    var personalConnection: String?    // fldlcmg7wtfIxgcZu (polymorphic — Avaraṇa context)
    var yogini: String?                // "Yogini Class" — e.g. "Gupta Yoginis (Secret)"
    var lastSyncedAt: Date?

    init(ringNumber: Int, airtableRecordId: String, sanskritName: String) {
        self.ringNumber = ringNumber
        self.airtableRecordId = airtableRecordId
        self.sanskritName = sanskritName
    }
}
