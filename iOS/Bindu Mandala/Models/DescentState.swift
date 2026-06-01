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
    func enter(ring: Int) {
        let now = Date()
        if ring > deepestReached {
            // A new crossing — record the moment.
            crossings.append(now)
            deepestReached = ring
        }
        if ring != currentRing {
            currentRing = ring
            enteredCurrentAt = now
        }
    }
}
