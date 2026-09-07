import Foundation
import SwiftData

/// The R11 silence dwell's one entry point. A dwell held past the first
/// adaptation is recorded **locally first** — a `RecognitionEntry` with
/// `gesture: .silence` through `RecognitionLogStore`, the read-time source of
/// truth — and then, fire-and-forget, as one `Silence Held` row in the App
/// Activity ledger (`AirtableService.recordSilence`), carrying the same
/// instant and the duration. The ledger write never gates the dwell; without
/// a token or a record id the local entry stays the whole record.
///
/// Never displayed as a count (Law 2) — the entry exists for the archive and
/// the restore, not for a score. Zero call sites until Phase 3.6 wires the
/// dwell ("once per visit" is the caller's rule, not this one's).
@MainActor
enum SilenceDwell {

    /// Record one held silence for `shakti`, `durationSec` long.
    static func record(shakti: Shakti, durationSec: Double, context: ModelContext) {
        // The Khaḍgamālā key, with the Ring-2 fallback every screen uses for a
        // pre-Phase-2 seat (per-ring index + 28).
        let kp = shakti.khadgamalaPosition ?? (shakti.position + 28)
        let ring = shakti.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: kp)

        // Local first — the store stamps the instant.
        let entry = RecognitionLogStore(context: context).record(
            khadgamalaPosition: kp,
            ringNumber: ring,
            gesture: .silence
        )

        // Then the ledger, at the same instant, in the background.
        let at = entry.timestamp
        Task {
            await AirtableService.shared.recordSilence(shakti: shakti, durationSec: durationSec, at: at)
        }
    }
}
