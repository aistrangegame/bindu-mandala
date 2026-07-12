import Foundation
import SwiftData

/// The practitioner's place on the descent. One row, by design — a single
/// pilgrimage through the nine āvaraṇas.
///
/// Semantics:
///   • `currentRing` is the ring she is inside *now* (1 = Bhūpura … 9 = Bindu).
///   • `deepestReached` is the furthest ring ever crossed into. Reached rings
///     stay revisitable; the Veil always offers them as open rows.
///   • `crossings` records when each threshold was crossed. The Portrait
///     may later show this as the visible timeline of the descent.
///   • `enteredCurrentAt` is the last time the practitioner stepped into
///     `currentRing`. Readiness *hints* may consult it ("days dwelt"), but
///     crossing remains a chosen act.
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
    /// caller uses that to mirror the crossing to Airtable exactly once
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

    /// Rebuild the descent timeline from crossings restored out of Airtable
    /// (after a reinstall / store recovery). Pure and testable — no network.
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
