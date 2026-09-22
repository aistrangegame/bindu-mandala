import Foundation
import SwiftData

// MARK: - The dwelling: what a stay records, and what it never shows
//
// Phase 3.6's wire. Three pieces existed and none of them was connected to
// anything:
//
//   * ``SilenceDwell/record(shakti:durationSec:context:)`` — a local
//     `RecognitionEntry` with `gesture: .silence` plus one `Silence Held` row in
//     the App Activity ledger. Its own header: *"once per visit is the caller's
//     rule, not this one's."*
//   * ``HomeVisit/claimSilence(at:)`` — that rule, as a guard that answers `true`
//     exactly once per visit and only at or past the first adaptation.
//   * ``AirtableService/recordFirstDwelling(shakti:chamberTime:at:)`` — the
//     once-ever milestone for a second adaptation reached in any room.
//
// This is the caller. It owns one visit to one room, it wakes at the stay's two
// marks, and it does nothing else at all.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT IS INVISIBLE, AND THAT IS THE WHOLE SPECIFICATION
// ─────────────────────────────────────────────────────────────────────────────
//
// Nothing here returns anything a view could draw. There is no published
// property, no observable state, no callback that carries a number outward, and
// no way for a screen to ask whether the silence was held. Ruling 11 says the
// row is *never displayed*, and law 2 says no count, streak, percentage or visit
// number ever reaches the walker — so the dwelling is built with nothing to show:
// a count that cannot be read cannot be shown by accident.
//
// The two things it writes are an entry in the local recognition log and a row
// in the ledger. Neither touches the **Mandala table** — R17 keeps that table to
// Śaktis and Āvaraṇas, and a `Silence Held` is an event. That is true by
// construction and not by care: the only writers reachable from here are
// ``RecognitionLogStore`` (SwiftData, phone-only) and ``AirtableService``'s
// activity path, which POSTs to ``ActivityLedger/tableId`` and nowhere else.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHICH CLOCK "PAST THE FIRST ADAPTATION" MEANS
// ─────────────────────────────────────────────────────────────────────────────
//
// ``HomeMemoryStore``'s own header leaves it open — *"which clock … is the
// caller's ruling"* — and hands the caller that rules the chamber clock a helper
// to do it with, ``HomeVisit/chamberClock(atDwell:)``. So it is ruled here, and
// it is the **chamber clock**:
//
//   * it is the clock `homes-chambers` counts adaptations on, and the clock
//     ``HomeMemory/adaptation(atChamberTime:)`` reads. An adaptation is a state
//     of the room, and the room is where it happens;
//   * ``RoomView``'s reduce-motion path poses at a chamber instant, the mark
//     light and the morph weights are chamber-clock functions, and a silence
//     recorded on a second clock would disagree with the room it was held in;
//   * the head start it opens at comes from *accumulated dwell*
//     (``HomeMemory/headStart(dwell:)``), so it cannot be gamed by entering and
//     leaving — which is the one thing a second clock would have been protecting
//     against.
//
// The consequence, written down rather than discovered later: a walker whose
// accumulated dwell has opened her room past the first adaptation holds that
// room's silence on arrival. That is the head start doing exactly what it is for
// — the relationship carried him past the adaptation, and he does not have to
// re-earn it — and it is capped, because Design caps the head start six seconds
// short of the *second* adaptation and this file adds nothing to that.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY IT WAKES RATHER THAN POLLS
// ─────────────────────────────────────────────────────────────────────────────
//
// The stay has exactly two marks on it, and both are known the moment the clock
// begins. A poll would mean a timer running for the whole of every stay in order
// to notice two instants, and on the reduce-motion path there is deliberately no
// render loop at all to hang one on (``RoomView``'s header: *"no `CADisplayLink`,
// no `TimelineView`, no continuous rendering, no per-frame work of any kind"*).
// So the dwelling sleeps until each mark and asks then — and ``observe`` re-asks
// both guards when it wakes, so a wake that is early, late, or repeated changes
// nothing.

/// One visit to one room: the R11 silence, and the once-ever first dwelling.
///
/// Held for as long as the walker is inside. ``begin(clock:)`` when the stay
/// opens, ``end()`` when he leaves — leaving before a mark simply means the mark
/// never arrives, which is what *a dwell held* means.
@MainActor
final class HomeDwelling {

    // MARK: - What the marks do

    /// What the dwelling does when one of the stay's two marks is passed.
    ///
    /// Injected rather than called directly, for one reason: the suite has to be
    /// able to watch the marks arrive without a token, a network or a store, and
    /// a dwelling that reached for `AirtableService.shared` inside itself could
    /// only be tested by letting it write. ``forRoom(_:ring:context:)`` is what
    /// every real caller uses.
    struct Marks {
        /// R11 — one `Silence Held`, once per visit, past the first adaptation.
        var silenceHeld: (_ durationSec: TimeInterval) -> Void
        /// The once-ever milestone — a second adaptation reached, in any room.
        var firstDwelling: (_ chamberTime: TimeInterval) -> Void

        /// The two marks, doing nothing. For a room stood in with no Śakti row
        /// behind it, and for a suite that is asking about the guards rather than
        /// about the writes.
        static let none = Marks(silenceHeld: { _ in }, firstDwelling: { _ in })
    }

    /// The real marks, for one synced Śakti.
    ///
    /// Both writes are fire-and-forget and neither can fail the stay: the local
    /// entry is a SwiftData insert, and the ledger row queues in UserDefaults if
    /// the network is away and drains with every other event.
    static func forRoom(_ shakti: Shakti, context: ModelContext) -> Marks {
        Marks(
            silenceHeld: { duration in
                SilenceDwell.record(shakti: shakti, durationSec: duration, context: context)
            },
            firstDwelling: { chamberTime in
                Task { @MainActor in
                    await AirtableService.shared.recordFirstDwelling(shakti: shakti,
                                                                     chamberTime: chamberTime)
                }
            }
        )
    }

    // MARK: - The visit

    /// The R11 guard, and the only state this object has that is about the
    /// walker. It is `private(set)` so the suite can read the guard; nothing in
    /// the app reads it, and there is nothing in it to read but a boolean.
    private(set) var visit: HomeVisit

    /// Whether this stay has already asked about the first dwelling. The
    /// milestone's real guard is once-ever and lives on the server
    /// (``AirtableService/recordMilestone(_:row:)``); this one only stops one
    /// stay asking twice.
    private(set) var reachedTheSecond = false

    private let marks: Marks
    private var waking: [Task<Void, Never>] = []

    init(visit: HomeVisit, marks: Marks = .none) {
        self.visit = visit
        self.marks = marks
    }

    /// The dwelling for one room, opened at the head start its own memory has
    /// earned.
    convenience init(memory: HomeMemory, marks: Marks = .none) {
        self.init(visit: HomeVisit(memory: memory), marks: marks)
    }

    deinit { waking.forEach { $0.cancel() } }

    // MARK: - The two marks of a stay

    /// Where the R11 silence is claimed, on the chamber clock. See the header.
    static var silenceAt: TimeInterval { HomeMemory.firstAdaptation }

    /// Where the second adaptation is reached, on the chamber clock — read off
    /// ``HomeMemory/adaptation(atChamberTime:)``'s own mark rather than chosen,
    /// so the milestone and the room agree about what a second adaptation is.
    static var dwellingAt: TimeInterval { HomeMemory.holdEnd }

    // MARK: - Asking

    /// Ask both guards at one moment of the stay.
    ///
    /// Pure in its decisions and idempotent: a wake that is early answers
    /// nothing, a wake that is late answers the same thing a punctual one would,
    /// and a wake that repeats answers nothing the second time. Everything that
    /// follows from it goes out through ``Marks``.
    ///
    /// `dwell` is real seconds in the room, which is what the ledger row carries
    /// as `Duration (sec)` — the archive's record of how long the silence was,
    /// and never anything the walker is told.
    func observe(chamberTime: TimeInterval, dwell: TimeInterval) {
        if visit.claimSilence(at: chamberTime) {
            marks.silenceHeld(max(0, dwell))
        }
        if !reachedTheSecond, HomeMemory.adaptation(atChamberTime: chamberTime) >= 2 {
            reachedTheSecond = true
            marks.firstDwelling(chamberTime)
        }
    }

    /// The same, read off a room's own clock — the one a ``RoomView`` is drawing
    /// by, so the dwelling and the room cannot stand at two different instants.
    func observe(_ clock: RoomClock) {
        observe(chamberTime: clock.chamberTime(), dwell: clock.elapsed())
    }

    // MARK: - Beginning and leaving

    /// The stay opens: sleep until each of the two marks, and ask there.
    ///
    /// A mark the clock already stands past is asked **now** rather than skipped
    /// — a returning walker's room opens at her head start, and the marks it has
    /// already carried her past are marks she has reached.
    func begin(clock: RoomClock) {
        end()
        for mark in [Self.silenceAt, Self.dwellingAt] {
            waking.append(wake(clock, at: mark))
        }
    }

    /// He has left. Nothing is written on the way out — a mark that had not
    /// arrived does not arrive, which is what *a dwell held* means.
    func end() {
        waking.forEach { $0.cancel() }
        waking.removeAll()
    }

    private func wake(_ clock: RoomClock, at mark: TimeInterval) -> Task<Void, Never> {
        let wait = mark - clock.chamberTime()
        return Task { @MainActor [weak self] in
            if wait > 0 {
                try? await Task.sleep(nanoseconds: UInt64(min(wait, 86_400) * 1_000_000_000))
            }
            guard !Task.isCancelled else { return }
            self?.observe(clock)
        }
    }
}
