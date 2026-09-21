import Foundation
import SwiftData

/// What one room remembers of the practitioner, and never says.
///
/// Design's contract is `Claude Design Round 2/homes/homes-memory.js` and its
/// numbers are law; this is that model, keyed by Khaḍgamālā position instead of
/// a `localStorage` bucket. Two values are load-bearing there: `visits`, which
/// softens her entering ceremony on a return, and `accumulatedDwell`, which
/// decides how far along her room opens. The other four are Brief v2 §2.2's
/// additions — a room that has held one very long stay is not the same room as
/// one that has held forty short ones, and only the extras can tell them apart.
///
/// **Nothing here ever reaches a screen.** Law 2 and handoff §6.2: no counter,
/// no percentage, no streak, no badge, and never "you have been here N times".
/// The instrument may know everything about the walking and must display none
/// of it. What it may do is *feel* different — a ceremony a little faster, a
/// room already open, a fifth that can be reached at all.
///
/// **Nothing here ever leaves the phone.** Ruling 17 at the data layer: this is
/// felt data, not an event. It is never an Airtable field, never a ledger row,
/// never synced. `AirtableService` has no business with this type; what the
/// ledger records is the R11 silence itself, never the dwell that earned it.
///
/// The head start comes from accumulated **dwell**, not from visit count, so it
/// cannot be gamed by entering and leaving. The consequence Design names: the
/// second adaptation — 227 seconds into the chamber clock, and so out of reach
/// on a first visit — becomes reachable only through relationship.
@Model
final class HomeMemory {

    /// Identity: the global Khaḍgamālā position, 1–102. Position is identity;
    /// names collide across rings (handoff §6.6).
    @Attribute(.unique) var khadgamalaPosition: Int

    /// How many visits to her room have ended. Design's `v`. Felt only as the
    /// compression of her entering ceremony — never counted out loud.
    var visits: Int

    /// Every second ever stood in her room, summed, capped at ``dwellCap``.
    /// Design's `d`. The head start and the bond half of the fifth read this.
    var accumulatedDwell: TimeInterval

    /// The longest single stay. Brief addition.
    var longestDwell: TimeInterval

    /// The stay that ended most recently. Brief addition.
    var lastDwell: TimeInterval

    /// When that stay ended. `nil` until the first visit is recorded — a room
    /// that has never been left has no last visit, and a zero date would lie.
    var lastVisit: Date?

    /// The deepest adaptation her chamber clock has ever reached in one visit:
    /// `0` before the first, `1` past ``firstAdaptation``, `2` past ``holdEnd``.
    /// Brief addition; see ``adaptation(atChamberTime:)`` for which clock.
    var deepestAdaptation: Int

    init(khadgamalaPosition: Int,
         visits: Int = 0,
         accumulatedDwell: TimeInterval = 0,
         longestDwell: TimeInterval = 0,
         lastDwell: TimeInterval = 0,
         lastVisit: Date? = nil,
         deepestAdaptation: Int = 0) {
        self.khadgamalaPosition = khadgamalaPosition
        self.visits = visits
        self.accumulatedDwell = accumulatedDwell
        self.longestDwell = longestDwell
        self.lastDwell = lastDwell
        self.lastVisit = lastVisit
        self.deepestAdaptation = deepestAdaptation
    }
}

// MARK: - The chamber clock's marks

extension HomeMemory {

    /// The first adaptation: the eye settles, and the room shows its second
    /// layer. `homes-chambers` via `homes-memory.js`'s `ADAPT`.
    static let firstAdaptation: TimeInterval = 62

    /// The end of the hold, where the second adaptation begins. `HOLD_END`.
    static let holdEnd: TimeInterval = 227

    /// The end of the second adaptation. `SECOND_END`.
    static let secondAdaptationEnd: TimeInterval = 347

    /// Accumulated dwell stops accruing here. Design: `Math.min(4000, …)`.
    /// A ceiling, not a goal — nothing is displayed as it is approached.
    static let dwellCap: TimeInterval = 4000

    /// The ceremony never vanishes, however known she is. Design's `0.36`.
    static let compressionFloor: Double = 0.36

    /// The head start can never carry past the hold's end, so a return still
    /// crosses the first adaptation with room to spare. Design: `HOLD_END - 6`.
    static let headStartCap: TimeInterval = holdEnd - 6   // 221
}

// MARK: - The three functions, ported from `homes-memory.js`

extension HomeMemory {

    /// Her entering ceremony softens on return — **never skipped**, only
    /// written a little faster, because the name is already known.
    /// `1` on the first meeting, falling to the floor and staying there.
    ///
    /// Pure, over a plain value: no container, no row, no context.
    static func compression(visits: Int) -> Double {
        guard visits > 0 else { return 1 }
        return max(compressionFloor, pow(0.68, Double(min(visits, 4))))
    }

    /// Where her room opens on the chamber clock, from accumulated dwell.
    /// Under twelve seconds of lifetime dwell it opens at the beginning, so a
    /// glance is not a relationship; above that it opens at a little over half
    /// the time already stood there, capped at ``headStartCap``.
    static func headStart(dwell: TimeInterval) -> TimeInterval {
        guard dwell >= 12 else { return 0 }
        return min(dwell * 0.55, headStartCap)
    }

    /// Her fifth, `0`–`1`: the ninth world, a very long single stay, or a long
    /// relationship. Ring 9 grants it outright; otherwise it is whichever of
    /// the two is further along — the chamber clock past ``holdEnd`` (full at
    /// ``secondAdaptationEnd``), or accumulated dwell past three minutes.
    static func grantsFifth(ring: Int, elapsed: TimeInterval, dwell: TimeInterval) -> Double {
        if ring == 9 { return 1 }
        let bySecond = clamp01((elapsed - holdEnd) / (secondAdaptationEnd - holdEnd))
        let byBond = clamp01((dwell - bondFloor) / bondSpan)
        return max(bySecond, byBond)
    }

    /// Which adaptation a chamber clock at `t` has crossed.
    ///
    /// The marks are the **chamber clock's**, not real dwell's — that is the
    /// clock `homes-chambers` counts them on, and on a return visit the chamber
    /// clock starts at ``headStart(dwell:)``. Which clock R11's "past the first
    /// adaptation" means is still open (errata §3.x) and is ruled at the call
    /// site, not here.
    static func adaptation(atChamberTime t: TimeInterval) -> Int {
        if t >= holdEnd { return 2 }
        if t >= firstAdaptation { return 1 }
        return 0
    }

    /// A long relationship begins at three minutes of accumulated dwell…
    private static let bondFloor: TimeInterval = 180
    /// …and is whole five minutes after that.
    private static let bondSpan: TimeInterval = 300

    private static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }
}

// MARK: - Reading and keeping one room's memory

extension HomeMemory {

    /// Has she been met at all? The climb rail's boolean — never a count
    /// (Design's `known`).
    var known: Bool { visits > 0 }

    /// Her ceremony's compression, for this room as it stands.
    var compression: Double { Self.compression(visits: visits) }

    /// Where her room opens on the chamber clock, for this room as it stands.
    var headStart: TimeInterval { Self.headStart(dwell: accumulatedDwell) }

    /// Her fifth at `elapsed` seconds on the chamber clock, for this room.
    func grantsFifth(ring: Int, elapsed: TimeInterval) -> Double {
        Self.grantsFifth(ring: ring, elapsed: elapsed, dwell: accumulatedDwell)
    }

    /// Called once, on leaving her — Design's `record(shakti, dwellSeconds)`.
    ///
    /// The visit is counted, the dwell added and capped, and the four extras
    /// brought up to date. A negative dwell adds nothing (Design's `max(0, …)`)
    /// and a stay that is not the longest leaves ``longestDwell`` alone.
    ///
    /// ``deepestAdaptation`` is the high-water mark on the **chamber clock**,
    /// which for this visit opened at the head start her dwell had earned
    /// *before* it — so the mark records how deep the room actually went, not
    /// how long she was held.
    ///
    /// `at` exists so a test can name the hour; every real caller leaves it.
    func record(dwell: TimeInterval, at moment: Date = .now) {
        let held = max(0, dwell)
        let openedAt = Self.headStart(dwell: accumulatedDwell)

        visits += 1
        accumulatedDwell = min(Self.dwellCap, accumulatedDwell + held)
        lastDwell = held
        longestDwell = max(longestDwell, held)
        lastVisit = moment
        deepestAdaptation = max(deepestAdaptation,
                                Self.adaptation(atChamberTime: openedAt + held))
    }
}
