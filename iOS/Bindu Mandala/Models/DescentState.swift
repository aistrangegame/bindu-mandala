import Foundation
import SwiftData

/// The practitioner's place on the descent. One row, by design — a single
/// pilgrimage through the nine āvaraṇas.
///
/// Memory, not a gate. The Mandala is an open instrument: every ring is
/// reachable at any time and nothing is unlocked by crossing. This row only
/// remembers where the practitioner has been — `LivingMandalaView` writes it
/// via `enter(ring:)` as the viewport falls inward, and The Memory's descent
/// film (`DescentFilmView`) reads it back as the visible timeline.
///
/// Semantics:
///   • `currentRing` is the ring she is inside *now* (1 = Bhūpura … 9 = Bindu).
///   • `deepestReached` is the furthest ring ever crossed into.
///   • `crossings` records when each new-deepest threshold was crossed; each is
///     mirrored once as a `Ring Crossed` row in the App Activity ledger, linked
///     to the Avaraṇa (`AirtableService.recordCrossing`), and read back from
///     there by `restoreDescentIfLocalEmpty` after a reinstall. The Mandala
///     table holds no crossing rows.
///   • `enteredCurrentAt` is the last time the practitioner stepped into
///     `currentRing`. Nothing gates on it.
@Model
final class DescentState {
    var currentRing: Int
    var deepestReached: Int
    var crossings: [Date]
    var enteredCurrentAt: Date

    init(currentRing: Int = 2,
         deepestReached: Int = 2,
         crossings: [Date] = [],
         enteredCurrentAt: Date = .now) {
        self.currentRing = currentRing
        self.deepestReached = deepestReached
        self.crossings = crossings
        self.enteredCurrentAt = enteredCurrentAt
    }

    /// Mark that the practitioner has crossed into `ring`. Idempotent:
    /// re-entering a previously-reached ring just updates currentRing and the
    /// timestamp. Crossing into a *new* ring appends a date and lifts the floor.
    ///
    /// Returns `true` only when this is a genuinely new deepest crossing — the
    /// caller uses that to write the ledger's `Ring Crossed` row exactly once
    /// (Ruling 8), never on a shallower re-entry.
    @discardableResult
    func enter(ring: Int) -> Bool {
        let now = Date()
        var newCrossing = false
        if ring > deepestReached {
            crossings.append(now)
            deepestReached = ring
            newCrossing = true
        }
        if ring != currentRing {
            currentRing = ring
            enteredCurrentAt = now
        }
        return newCrossing
    }

    /// Rebuild the descent timeline from crossings restored out of the App
    /// Activity ledger (`ActivityLedger.crossings`, after a reinstall / store
    /// recovery). Pure and testable — no network.
    ///
    /// Zero rows leaves the bootstrap floor (2 / 2) untouched — a fresh device
    /// with no crossings on the server must never regress or invent a descent.
    /// `deepestReached`/`currentRing` never drop below the floor of 2.
    func restore(from restored: [(ring: Int, date: Date)]) {
        guard !restored.isEmpty else { return }
        let deepest = max(2, restored.map(\.ring).max() ?? 2)
        crossings = restored.map(\.date)
        deepestReached = deepest
        currentRing = deepest
        enteredCurrentAt = restored.last?.date ?? Date()
    }
}
