import Foundation
import SwiftData

/// One of the 102 Śaktis of the Khaḍgamālā — all nine āvaraṇas, not only the
/// 16 Karṣiṇīs of Ring 2. Identity is `khadgamalaPosition` (1–102); `position`
/// is the per-ring index and recurs across rings.
/// Cached locally via SwiftData. Status is the only user-mutable field;
/// everything else mirrors the Airtable source of truth.
@Model
final class Shakti {
    /// Per-ring index 1–N. Ring 2: 1–16. Unique enforced in reconcile, not by attribute,
    /// since the same per-ring index recurs across rings (Ring 1 position 1, Ring 2 position 1, …).
    var position: Int

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

    // MARK: - Phase 1 — global identity + ring

    /// Canonical Khaḍgamālā position 1–102 (Airtable `fldI0aV1sfOeNybHI`).
    var khadgamalaPosition: Int?
    /// Ring 1–9, derived from Khaḍgamālā position at reconcile time.
    var ringNumber: Int?
    /// Airtable record id from the live schema (distinct from the legacy `airtableId`).
    var airtableRecordId: String?

    // MARK: - Phase 1 — extended Shakti fields (read from Airtable)

    var devanagari: String?           // fldDhcJ1BJQCM5llO
    var iconography: String?          // fldXJEBCQxLdHWGuP
    var codexPortrait: String?        // fldlcmg7wtfIxgcZu (polymorphic — Shakti context)
    var etymology: String?            // fldXypzqrhVILCqgh
    var appreciationPhrase: String?   // fldBqEDpBonMc2s1K
    var shaktiFunction: String?       // fldzT3dAhsAK75rKN
    var shaktiFamilyRaw: String?      // fldYAlclWH7CfJhOg

    // MARK: - Recognition mirrors (read back from Airtable)

    /// Airtable's most-recent `Last Felt` timestamp (fldWT0dGqdUQrdRGT).
    var lastFelt: Date?
    /// Airtable's authoritative recognition count (flddp0tLpf8iuxyt4).
    var serverRecognitionCount: Int?

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
        fieldNote: String? = nil,
        khadgamalaPosition: Int? = nil,
        ringNumber: Int? = nil,
        airtableRecordId: String? = nil,
        devanagari: String? = nil,
        iconography: String? = nil,
        codexPortrait: String? = nil,
        etymology: String? = nil,
        appreciationPhrase: String? = nil,
        shaktiFunction: String? = nil,
        shaktiFamilyRaw: String? = nil
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
        self.khadgamalaPosition = khadgamalaPosition
        self.ringNumber = ringNumber
        self.airtableRecordId = airtableRecordId
        self.devanagari = devanagari
        self.iconography = iconography
        self.codexPortrait = codexPortrait
        self.etymology = etymology
        self.appreciationPhrase = appreciationPhrase
        self.shaktiFunction = shaktiFunction
        self.shaktiFamilyRaw = shaktiFamilyRaw
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

    /// Her bare seed syllable — the one place the bīja field is parsed.
    /// Type-1 fields ("aṁ") are the syllable whole; Type-2 fields
    /// ("Kaṃ — governs K-row …") are cut before the first " — " (space + em
    /// dash + space). Trimmed; nil when she carries no bīja (most of the 86).
    var bijaSyllable: String? {
        let syllable = bija.components(separatedBy: " — ").first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return syllable.isEmpty ? nil : syllable
    }
}
