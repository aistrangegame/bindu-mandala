import Foundation

// MARK: - Wave 6 · the ledger rows of the modes and rites
//
// The type names live in `ActivityLedger.swift` with the rest of the ledger's
// vocabulary; these are only the builders. Each row says what was done and
// grades nothing: no count, no duration in a name or a detail, and his own
// words — where there are any — ride in `Notes` and nowhere else.

extension ActivityLedger {

    /// His perspective, written beside her sealed witness page (C-1280).
    /// Linked to her Śakti row; his words in `Notes`, never quoted elsewhere.
    static func witnessWritten(shaktiRecordId: String, name shaktiName: String,
                               body: String, at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "a Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.witnessWritten,
            linkRecordId: shaktiRecordId,
            name: "Beside the witness page — \(name)",
            detail: "Written after asking for help · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            notes: body
        )
    }

    /// Sādhana — the garland recited. Linked to the point's own row (Lalitā),
    /// where the garland is offered back. `whole` when he stayed to the
    /// offering; otherwise the enclosure he had reached, named, never counted.
    static func garlandRecited(pointRecordId: String, whole: Bool, reachedRing: Int,
                               at: Date) -> PendingActivity {
        let detail: String
        if whole {
            detail = "The whole garland, offered back"
        } else if (1...9).contains(reachedRing) {
            detail = "Recited inward to the \(ordinal(reachedRing).lowercased()) enclosure"
        } else {
            detail = "Begun"
        }
        return PendingActivity(
            type: ActivityType.garlandRecited,
            linkRecordId: pointRecordId,
            name: "The Khaḍgamālā — recited",
            detail: "\(detail) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    /// Pūjā — the day offered at evening. Linked to the day's Śakti when her
    /// row is known.
    static func dayOffered(todayRecordId: String, todayName: String, at: Date) -> PendingActivity {
        let name = todayName.isEmpty ? "the day" : "the day of \(todayName)"
        return PendingActivity(
            type: ActivityType.dayOffered,
            linkRecordId: todayRecordId,
            name: "Pūjā — \(name), offered",
            detail: "The day is received · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }
}
