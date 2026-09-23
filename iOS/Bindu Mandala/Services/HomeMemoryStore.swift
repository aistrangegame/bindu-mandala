import Foundation
import SwiftData

/// Thin façade over the SwiftData `ModelContext` for what a room remembers —
/// the same shape as `LetterStore`, and beside `RecognitionLogStore` where the
/// handoff (§4.9) asks for it.
///
/// **Phone-only by construction.** Ruling 17 at the data layer: a `HomeMemory`
/// is felt data, never an event. Nothing in this file touches `AirtableService`
/// or `ActivityLedger`, and nothing should — the ledger's business is the R11
/// silence, not the dwell underneath it.
///
/// **No read ever writes.** Asking what a room remembers must leave the store
/// exactly as it found it: `memory(for:)` hands back a transient, unsaved row
/// for a room never visited, so merely walking in — or a Phase-3 view merely
/// asking her compression while it draws — leaves no trace on disk.
///
/// Zero call sites. Phase 3.6 wires the dwelling to it; until then nothing does.
@MainActor
struct HomeMemoryStore {
    let context: ModelContext

    /// What this room remembers, if it has ever been left. A pure read: it
    /// inserts nothing.
    func existingMemory(for khadgamalaPosition: Int) -> HomeMemory? {
        let d = FetchDescriptor<HomeMemory>(
            predicate: #Predicate { $0.khadgamalaPosition == khadgamalaPosition }
        )
        return (try? context.fetch(d))?.first
    }

    /// This room's memory — the stored row when there is one, otherwise a
    /// **transient, unsaved** one whose every value is the beginning. It enters
    /// the store only when a visit is recorded on it.
    func memory(for khadgamalaPosition: Int) -> HomeMemory {
        existingMemory(for: khadgamalaPosition)
            ?? HomeMemory(khadgamalaPosition: khadgamalaPosition)
    }

    /// Her entering ceremony's compression. Unvisited rooms answer `1`, the
    /// whole ceremony, without a row being made to say so.
    func compression(for khadgamalaPosition: Int) -> Double {
        HomeMemory.compression(visits: existingMemory(for: khadgamalaPosition)?.visits ?? 0)
    }

    /// Where her room opens on the chamber clock. `0` for a room never stood in.
    func headStart(for khadgamalaPosition: Int) -> TimeInterval {
        HomeMemory.headStart(dwell: existingMemory(for: khadgamalaPosition)?.accumulatedDwell ?? 0)
    }

    /// Everything ever stood in her room. `0` for a room never stood in.
    ///
    /// The one raw value this façade hands out, and it is handed to exactly one
    /// caller: ``HomeVoice``, which needs it because the withheld fifth is
    /// withheld against the whole relationship and not against this stay. It is
    /// felt data like the rest — there is no path from here to a screen, and
    /// `LawsTests` would have something to say if one appeared.
    func accumulatedDwell(for khadgamalaPosition: Int) -> TimeInterval {
        existingMemory(for: khadgamalaPosition)?.accumulatedDwell ?? 0
    }

    /// Her fifth at `elapsed` seconds on the chamber clock.
    func grantsFifth(for khadgamalaPosition: Int, ring: Int, elapsed: TimeInterval) -> Double {
        HomeMemory.grantsFifth(ring: ring,
                               elapsed: elapsed,
                               dwell: existingMemory(for: khadgamalaPosition)?.accumulatedDwell ?? 0)
    }

    /// Called once, on leaving her: the visit is counted and the dwell kept.
    /// The row is created here if this was her first — a memory becomes real at
    /// the moment there is something to remember.
    @discardableResult
    func record(khadgamalaPosition: Int,
                dwell: TimeInterval,
                at moment: Date = .now) -> HomeMemory {
        let memory = self.memory(for: khadgamalaPosition)
        if memory.modelContext == nil { context.insert(memory) }
        memory.record(dwell: dwell, at: moment)
        try? context.save()
        return memory
    }
}

/// One visit to one room, held by the dwelling for as long as the practitioner
/// is inside it — and the guard that keeps R11's silence to **once per visit**.
///
/// `SilenceDwell.record` deliberately writes an entry every time it is called
/// ("once per visit is the caller's rule, not this one's"); this is that rule,
/// in the one shape every room will use. A visit is a value, so leaving the
/// room and coming back means a new one, and a new silence may be held.
///
/// Which clock "past the first adaptation" means — the chamber clock, which on
/// a return opens at ``HomeMemory/headStart(dwell:)``, or real dwell — is open
/// (errata §3.x) and is the caller's ruling: ``claimSilence(at:)`` simply takes
/// the clock it is given. ``chamberClock(atDwell:)`` is here for the caller that
/// rules the chamber clock.
///
/// Zero call sites. Phase 3.6 wires it.
struct HomeVisit {

    /// Whose room this visit is in.
    let khadgamalaPosition: Int

    /// Where her chamber clock opened for this visit — the head start her
    /// accumulated dwell had earned *before* she was entered.
    let headStart: TimeInterval

    /// Has this visit's silence already been held? Felt data like the rest:
    /// it exists so the second write never happens, not so anything is shown.
    private(set) var silenceHeld = false

    init(khadgamalaPosition: Int, headStart: TimeInterval = 0) {
        self.khadgamalaPosition = khadgamalaPosition
        self.headStart = max(0, headStart)
    }

    /// Open a visit to the room this memory belongs to, at the head start it
    /// has earned.
    init(memory: HomeMemory) {
        self.init(khadgamalaPosition: memory.khadgamalaPosition, headStart: memory.headStart)
    }

    /// The chamber clock at `dwell` seconds of real time inside the room.
    func chamberClock(atDwell dwell: TimeInterval) -> TimeInterval {
        headStart + max(0, dwell)
    }

    /// `true` exactly once per visit: the first time the clock the caller keeps
    /// stands at or past the first adaptation. Every later tick answers `false`,
    /// so the dwelling may ask on each one.
    mutating func claimSilence(at clock: TimeInterval) -> Bool {
        guard !silenceHeld, clock >= HomeMemory.firstAdaptation else { return false }
        silenceHeld = true
        return true
    }
}
