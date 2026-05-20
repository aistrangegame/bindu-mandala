import Foundation
import SwiftData

/// One of the 16 Karṣiṇī Śaktis of the 2nd Avaraṇa.
/// Cached locally via SwiftData. Status is the only user-mutable field;
/// everything else mirrors the Airtable source of truth.
@Model
final class Shakti {
    /// Position 1–16 (also drives petal index 0–15 via `pos - 1`).
    @Attribute(.unique) var position: Int

    var name: String              // "Sparśākarṣiṇī"
    var shortName: String         // "Sparśa"
    var phonetic: String          // "Spar · SHAH · kar · shi · nee"
    var quality: String           // "She who attracts Touch"
    var qualityDescription: String
    var somatic: String           // prompt — "Where is she landing on your skin right now?"
    var somaticPoetry: String     // multi-line poem
    var bija: String              // "uṁ"
    var bodilyLocation: String    // "skin"
    var tattva: String            // "Air (Vāyu)"
    var recognitionPhrase: String // "You are extraordinary for bringing me this touch."

    /// Cluster as raw value (enum stored as String).
    var clusterRaw: String
    /// User-mutable status.
    var statusRaw: String
    /// Optional Airtable record id, set after first sync.
    var airtableId: String?
    /// Optional field-connection (positions 3 / 12 / 14).
    var fieldName: String?
    var fieldNote: String?

    /// Last time this row was reconciled from Airtable.
    var lastSyncedAt: Date?

    init(
        position: Int,
        name: String,
        shortName: String,
        phonetic: String,
        quality: String,
        qualityDescription: String,
        somatic: String,
        somaticPoetry: String,
        bija: String,
        bodilyLocation: String,
        tattva: String,
        recognitionPhrase: String,
        cluster: Cluster,
        status: ShaktiStatus,
        airtableId: String? = nil,
        fieldName: String? = nil,
        fieldNote: String? = nil
    ) {
        self.position = position
        self.name = name
        self.shortName = shortName
        self.phonetic = phonetic
        self.quality = quality
        self.qualityDescription = qualityDescription
        self.somatic = somatic
        self.somaticPoetry = somaticPoetry
        self.bija = bija
        self.bodilyLocation = bodilyLocation
        self.tattva = tattva
        self.recognitionPhrase = recognitionPhrase
        self.clusterRaw = cluster.rawValue
        self.statusRaw = status.rawValue
        self.airtableId = airtableId
        self.fieldName = fieldName
        self.fieldNote = fieldNote
    }

    var cluster: Cluster {
        get { Cluster(rawValue: clusterRaw) ?? .inner }
        set { clusterRaw = newValue.rawValue }
    }

    var status: ShaktiStatus {
        get { ShaktiStatus(rawValue: statusRaw) ?? .mapped }
        set { statusRaw = newValue.rawValue }
    }

    /// Petal index — 0 at 12 o'clock, clockwise.
    var petalIndex: Int { position - 1 }

    var hasFieldConnection: Bool {
        guard let f = fieldName, !f.isEmpty else { return false }
        return true
    }
}
