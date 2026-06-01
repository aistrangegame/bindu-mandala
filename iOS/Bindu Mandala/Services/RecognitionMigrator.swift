import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "recognition-migrator")

/// One-time lossless backfill for Phase-2 recognition entries.
///
/// Pre-Phase-2 entries were keyed by `shaktiPosition` (per-ring 1-16, Ring 2
/// only). Phase 2 introduces `khadgamalaPosition` (global 1-102) and
/// `ringNumber` (1-9). This migrator finds any entry whose new fields are
/// still 0 and fills them from the legacy `shaktiPosition`:
///
///   khadgamalaPosition = shaktiPosition + 28   // Ring 2 Khaḍgamālā offset
///   ringNumber         = 2
///
/// Idempotent — re-running is a no-op. Safe to call on every launch. The
/// archive belongs to her: no entry is dropped, and the legacy field is
/// preserved alongside the new keys.
enum RecognitionMigrator {

    @MainActor
    static func backfillIfNeeded(context: ModelContext) {
        // Fetch every entry whose Phase-2 key is uninitialized. The predicate
        // covers both the freshly-migrated schema (default 0) and any genuine
        // legacy rows.
        let descriptor = FetchDescriptor<RecognitionEntry>(
            predicate: #Predicate { $0.khadgamalaPosition == 0 }
        )
        guard let stale = try? context.fetch(descriptor), !stale.isEmpty else {
            return
        }

        var migrated = 0
        var skipped = 0
        for entry in stale {
            let legacy = entry.shaktiPosition
            guard (1...16).contains(legacy) else {
                // Defensive: any entry without a valid legacy position is
                // left alone rather than written with a guess. The archive
                // refuses to invent.
                skipped += 1
                continue
            }
            entry.khadgamalaPosition = legacy + 28
            entry.ringNumber = 2
            migrated += 1
        }

        if migrated > 0 {
            try? context.save()
            log.notice("Recognition backfill: migrated \(migrated) entry/entries to Phase-2 keys; \(skipped) skipped.")
        }
    }
}
