import Foundation

// MARK: - What a stay was worth, and the once it is handed over
//
// The bookkeeping of leaving a room, lifted out of the view that draws it.
//
// It was three `@State` flags and two guards inside `RiteOfEnteringView`, which
// made every claim about it a claim about source text: the suite could assert
// that a particular `guard` line was still spelled a particular way, and a
// refactor that kept the spelling and inverted the meaning would have passed.
// The rules below are small, they are the whole of the way out that is not a
// gesture, and they are worth being able to *drive*:
//
//   · a stay ends where the walker decided it ended — the instant he began to
//     cross out — and not where the surface happened to go away;
//   · a walker who let go of the crossing did not leave, so the ending is
//     undone and he goes on accruing;
//   · what is handed over is handed over **once**, by whichever of the two
//     doors closes first — the way out, or the view disappearing under him;
//   · a room he never entered has nothing to hand over at all.
//
// It says nothing and draws nothing. It is arithmetic about one visit that is
// handed straight to ``HomeMemoryStore`` and never to a screen — the compression
// it buys is *felt*, in a ceremony that writes faster, and law 2 is why there is
// no path from here to a `Text`.

/// The stay's own bookkeeping: when it ended, and whether it has been filed.
struct TheStay: Equatable {

    /// What the stay was worth at the instant he began to cross out, or `nil`
    /// while he is still in the room.
    ///
    /// The walk out is no more time in her room than the walk in was.
    private(set) var endedAt: TimeInterval?

    /// Filed once, and then never again.
    private(set) var handedOver = false

    /// He has begun to cross out. The first such instant is the one that counts:
    /// a press reported twice does not shorten the stay twice.
    mutating func ends(at elapsed: TimeInterval) {
        guard endedAt == nil else { return }
        endedAt = elapsed
    }

    /// He let go of the crossing, so he did not leave. The ending is undone and
    /// the stay goes on from where it was.
    ///
    /// Answers whether there was anything to undo, which is what tells the
    /// surface whether to close the room back on him: a let-go that follows no
    /// beginning is a stray callback, and it moves nothing.
    @discardableResult
    mutating func goesOn() -> Bool {
        guard endedAt != nil else { return false }
        endedAt = nil
        return true
    }

    /// What to file, or `nil` if there is nothing to file.
    ///
    /// `entered` is the room's own answer — a clock still held at her threshold
    /// is a ceremony the walker abandoned, and an abandoned ceremony is not a
    /// stay. `elapsedNow` is what the stay is worth *now*, used only when he
    /// never began to cross out (the still path, where leaving is a touch, and
    /// the surface simply going away).
    ///
    /// Never negative: a clock that reports backwards files nothing rather than
    /// a negative dwell that would make the next ceremony longer.
    mutating func handOver(elapsedNow: @autoclosure () -> TimeInterval,
                           entered: Bool) -> TimeInterval? {
        guard !handedOver, entered else { return nil }
        handedOver = true
        return max(0, endedAt ?? elapsedNow())
    }
}
