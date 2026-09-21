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

    // MARK: - Invariant Śrī-Yantra structure
    //
    // The nine enclosures are fixed geometry — their form, seat-count, form
    // description, and gratitude phrase never change and are not authored in
    // Airtable, so they live here as the source of truth (like NityaDevi's tithi
    // names). Ported verbatim from the prototype's Avaraṇa data.

    private static let forms = [
        "Bhūpura", "16-Petal Lotus", "8-Petal Lotus", "14 Triangles",
        "10 Outer Triangles", "10 Inner Triangles", "Vāk Ring", "Mūla Trikoṇa", "Bindu",
    ]
    private static let counts = [28, 16, 8, 14, 10, 10, 12, 3, 1]
    private static let formDescriptions = [
        "The outer square — the boundary of the manifest world, four T-gates opening in each cardinal direction",
        "The lotus of completeness — sixteen petals of attraction, sense, and consciousness",
        "The inner lotus — eight petals of the Anaṅga forces, the bodiless desires that move without a name",
        "Fourteen interlocked triangular forces — where luck is recognized as intelligence",
        "Ten outer forces — where intention crystallizes into accomplished form",
        "Ten inner forces — the field of sovereign protection that requires nothing from you",
        "Twelve speech goddesses — the level where language and life have not yet separated",
        "The root triangle — will, knowledge, and action as a single undivided power",
        "The point — seed and destination of the entire yantra, from which all rings breathe outward",
    ]
    private static let appreciations = [
        "Thank you for the world I have walked through without knowing it was you.",
        "Thank you for the desire that moves me and the awareness that knows it.",
        "Thank you for the longing that arrives without asking permission.",
        "Thank you for the good fortune I did not manufacture.",
        "Thank you for the completion I did not force.",
        "Thank you for the grace I didn't know was holding me.",
        "Thank you for the word that healed what the mind could not reach.",
        "Thank you for the perfection that moved through me.",
        "Thank you for being the place I have always already arrived.",
    ]

    private var idx: Int? { (1...9).contains(ringNumber) ? ringNumber - 1 : nil }

    /// The enclosure's form name — "Bhūpura" … "Bindu".
    var enclosureForm: String { Self.enclosureForm(forRing: ringNumber) }

    /// The form name for any ring 1…9 without a model row — the ledger's
    /// `Ring Crossed` detail ("Fell inward to the Bindu"). `""` outside 1…9.
    static func enclosureForm(forRing ring: Int) -> String {
        (1...9).contains(ring) ? forms[ring - 1] : ""
    }
    /// How many of the 102 are seated in this enclosure.
    var shaktiCount: Int { idx.map { Self.counts[$0] } ?? 0 }
    /// One line on the enclosure's geometry.
    var formDescription: String { idx.map { Self.formDescriptions[$0] } ?? "" }
    /// The gratitude the threshold offers on crossing.
    var appreciationPhrase: String { Self.appreciationPhrase(forRing: ringNumber) }

    /// The same, for any ring 1…9 without a model row — the rite of entering
    /// stands behind a Śakti's own phrase with her enclosure's, and it must be
    /// able to do so while a room is being built, before any context is at
    /// hand. `""` outside 1…9.
    static func appreciationPhrase(forRing ring: Int) -> String {
        (1...9).contains(ring) ? appreciations[ring - 1] : ""
    }
}
