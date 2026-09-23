import Foundation

// MARK: - Going deeper: the bookkeeping, lifted out of the view that draws it
//
// ``HomeDescent`` is where the stations are and ``DescentShaft`` is what draws
// them; this is the small set of rules about *when* a walker may go deeper and
// where a touch takes him. It is ``TheStay``'s neighbour and is built the same
// way, for the same reason: rules worth having are rules worth being able to
// **drive**, rather than claims about how a `guard` in a view is spelled.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ROOM HAS TWO GESTURES, AND THE DESCENT ADDS NONE
// ─────────────────────────────────────────────────────────────────────────────
//
// Touch to go on, hold to go out. That is the whole vocabulary of the rooms
// layer, and the rite taught it at the threshold: three touches carried him in,
// and the last prompt he read was *touch to enter*. Going deeper is the same
// motion continued — Design's own sentence, *"you do not leave her room, you
// keep going"* — so it is the same touch, and there is no control, no chevron
// and no sheet anywhere in it. A touch at the floor of the descent brings him
// back up into the room, because the khaḍgamālā is a circle and so is this.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE WAY DOWN IS EARNED, AND HE IS NEVER TOLD THAT IT WAS
// ─────────────────────────────────────────────────────────────────────────────
//
// **The descent is not offered until her room has adapted.** Not a timer and not
// a gate: the first adaptation is the moment the room shows its second layer
// (``HomeMemory/firstAdaptation``), and going into her mark before the eye has
// settled would be going past what there is to see. The prompt simply is not
// there, and then it is.
//
// The consequence is the thing this phase is for, and it is the law's sharpest
// edge held on the right side. A room opens on the chamber clock at the head
// start his accumulated dwell has earned (``HomeMemory/headStart(dwell:)``), and
// a head start past sixty-two seconds means the room is **already adapted when
// he walks in** — so a Śakti he has truly stood with lets him go deeper at once,
// and one he has never met makes him wait out the settling first. That is a room
// answering to what it remembers of him. Nothing announces it, nothing counts
// it, and there is no sentence anywhere in the instrument that could: the only
// difference is that the way down is open.
//
// A walker who never returns to anybody still reaches every station of every
// descent. Nothing is withheld — only deferred by exactly as long as it takes
// the room to open, which is a fact about the room and not about him.

/// Where the walker is in the descent, and what a touch does next.
struct TheDescent: Equatable {

    /// Which station he has reached: `0` standing in her room, `1`…`5` one of
    /// Design's five. It is not shown, spoken, or counted anywhere — it is a
    /// place in the shaft, and the shaft is what says where he is.
    private(set) var reached: Int = 0

    /// Where he was when he began to cross out, so a let-go can put him back.
    private(set) var leftFrom: Int?

    /// How many stations the descent has.
    static var stations: Int { DescentStation.allCases.count }

    /// True once he has gone in at all.
    var isOpen: Bool { reached > 0 }

    /// Where the eye is travelling to, as ``HomeDescent``'s own co-ordinate.
    var travel: Double { Double(reached) }

    /// Which of her fields is at the station he has reached.
    var station: DescentStation? { HomeDescent.station(atTravel: travel) }

    /// Whether the way down is open at this moment of the stay — see the header.
    ///
    /// It asks the **chamber clock**, which is the clock the room's own layers
    /// are drawn by and the clock a returning walker's head start opens. Real
    /// dwell would make a relationship count for nothing here.
    static func isOffered(atChamberTime t: TimeInterval) -> Bool {
        HomeMemory.adaptation(atChamberTime: t) >= 1
    }

    /// A touch, once he is inside her room and the way down is open.
    ///
    /// The next station, or back up into the room from the floor. Answers where
    /// he is now going, so the caller has one thing to move him to.
    @discardableResult
    mutating func onward() -> Double {
        reached = reached >= Self.stations ? 0 : reached + 1
        leftFrom = nil
        return travel
    }

    /// He has begun to cross out from inside the descent. The shaft is unwound
    /// to its mouth over the length of the hold — the way in, run the other way,
    /// which is what leaving is everywhere else in the rooms layer.
    ///
    /// Answers whether there was anything to unwind: a hold begun while he is
    /// simply standing in her room is the room's own way out and not this one.
    @discardableResult
    mutating func withdraws() -> Bool {
        guard reached > 0 else { return false }
        leftFrom = reached
        reached = 0
        return true
    }

    /// He let go of the crossing out. He did not leave, so he is put back where
    /// he was standing — at the same station, not at the mouth.
    ///
    /// Answers whether there was anything to put back.
    @discardableResult
    mutating func goesOn() -> Bool {
        guard let from = leftFrom else { return false }
        reached = from
        leftFrom = nil
        return true
    }
}

// MARK: - The one instruction the descent carries

extension TheDescent {

    /// What the prompt says at the station he has reached: the rite's own
    /// *touch to go on*, the whole way down and at the floor as well.
    ///
    /// **One instruction, at every one of the five**, and see ``RitePrompt``'s
    /// own note for why the floor does not get a word of its own. It does not
    /// say how far he has come, how far is left, or that there is a *far* at
    /// all — there is nowhere in two words to put one.
    var prompt: RitePrompt? { isOpen ? .goOn : nil }

    /// The prompt at the mouth, for a walker standing in a room that has opened
    /// far enough to go into. It is the same word the threshold used, because it
    /// is the same motion.
    static var mouthPrompt: RitePrompt { .goDeeper }
}
