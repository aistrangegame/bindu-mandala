import Foundation
import SwiftData

/// Wave 2 · Mauna — the silence held at the point — and its one entry point.
///
/// The `.silence` gesture's true home (the Reading, §4: *"Mauna — tap the
/// centre for silence"*). A silence held past ``Mauna/recordedAfter`` is kept
/// exactly the way the room's R11 silence is kept (``SilenceDwell``):
///
///   1. **locally first** — a `RecognitionEntry` with `gesture: .silence`, at
///      the point's own seat (Lalitā, kp 102, the ninth āvaraṇa), so the record
///      exists on this phone before any network does;
///   2. then one `Silence Held` row in the App Activity ledger, the single
///      ledger (§4.3), built by ``ActivityLedger/mauna(shaktiRecordId:name:durationSec:at:)``
///      at the same instant, fire-and-forget.
///
/// **A silence is never "felt".** The entry's gesture is `.silence`, which no
/// seat reads as felt (Wave 0 · B3), and the ledger row is its own type, never
/// a `Shakti Recognized`. The duration lives in the archive and is never shown.
@MainActor
enum MaunaSilence {

    /// The point's seat — position is identity.
    static let pointPosition = KhadgamalaMap.total

    /// Whether a silence of this length is kept at all. A tap in and out of
    /// the silence is not a silence held.
    static func isHeld(_ seconds: TimeInterval) -> Bool { seconds >= Mauna.recordedAfter }

    /// Keep one held silence at the point.
    static func record(seconds: TimeInterval, at: Date = .now, context: ModelContext) {
        guard isHeld(seconds) else { return }
        let entry = RecognitionLogStore(context: context).record(
            khadgamalaPosition: pointPosition,
            ringNumber: KhadgamalaMap.ringNumber(forKhadgamala: pointPosition),
            gesture: .silence)
        let rows = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        let lalita = rows.first { $0.khadgamalaPosition == pointPosition }
        guard let recordId = lalita?.airtableRecordId, !recordId.isEmpty else { return }
        let item = ActivityLedger.mauna(shaktiRecordId: recordId,
                                        name: lalita?.name ?? "",
                                        durationSec: seconds,
                                        at: entry.timestamp)
        Task { await AirtableService.shared.logActivity(item) }
    }
}
