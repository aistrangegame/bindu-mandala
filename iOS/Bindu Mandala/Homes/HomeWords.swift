import Foundation

// MARK: - The room's own words
//
// Wave 1 · Slice D. Every grammar room has composed its words since Phase 3.2 —
// ``HomeLabel``'s `near` (her quality, spoken in the room's own voice) and
// `deep` (the room's premise, reversed) — and nothing ever put them on a
// screen. The eight authored rooms had Design's own sentences in
// `homes-chambers.js` (*"the floor has let go"* → *"the room has let go of
// itself"*), and they were never ported at all.
//
// Design's Axis sets them in the room exactly as it sets them here: a line at
// the top naming where she is — *"{region} · the {ordinal} āvaraṇa"* — her
// name beneath it, her quality beneath that, and the room's own sentence low in
// the frame, arriving once the eye has settled and turning when the premise
// reverses.
//
// Nothing here counts anything. Every string is a place, a name, a quality or
// a sentence the room says; none is his visit, his dwell or his record.

/// What one room says, and when.
struct RoomWords: Equatable {
    /// Where she is: *"Heart · the fourth āvaraṇa"*.
    let place: String
    /// Her name.
    let name: String
    /// Her quality. May be empty.
    let quality: String
    /// The room's sentence before the premise reverses.
    let near: String
    /// …and after.
    let deep: String

    /// Every string this can put in front of the walker.
    var all: [String] { [place, name, quality, near, deep] }

    /// The three moments the words arrive with.
    enum Stage: Int, Comparable, CaseIterable {
        /// He has just come in: where he is, and whose room.
        case arriving
        /// The eye has settled: the room says what it is.
        case near
        /// The premise has reversed: the room says what it became.
        case deep

        static func < (a: Stage, b: Stage) -> Bool { a.rawValue < b.rawValue }
    }

    /// How far the eye must have settled before the room speaks.
    static let speaksAtSettling: Double = 0.25

    /// Which words a moment of her chamber clock calls for. The turn is
    /// ``HomeGrammar/secondAdaptationSwitch`` — the same instant
    /// ``HomeLabel/text(deepProgress:)`` turns — so the words and the room
    /// reverse together.
    static func stage(chamberTime t: TimeInterval) -> Stage {
        if HomeGrammar.deepProgress(chamberTime: t) > HomeGrammar.secondAdaptationSwitch {
            return .deep
        }
        if HomeGrammar.settling(chamberTime: t) >= speaksAtSettling { return .near }
        return .arriving
    }

    /// The room's sentence at a stage — nothing while he is still arriving.
    func sentence(at stage: Stage) -> String {
        switch stage {
        case .arriving: return ""
        case .near:     return near
        case .deep:     return deep
        }
    }

    // MARK: - Composition

    /// Design's ordinals, by āvaraṇa — words, so the place never reads as a
    /// count.
    static let ordinals: [Int: String] = [
        1: "first", 2: "second", 3: "third", 4: "fourth", 5: "fifth",
        6: "sixth", 7: "seventh", 8: "eighth", 9: "ninth",
    ]

    /// `homes-chambers.js`'s own sentences for the eight hand-authored rooms,
    /// near and deep, verbatim.
    static let authored: [HomeAuthoredMechanism: (near: String, deep: String)] = [
        .contract: ("the walls close while you stand still", "the point was a door all along"),
        .endless:  ("no far wall · it never arrives", "you were never inside anything"),
        .release:  ("the floor has let go", "the room has let go of itself"),
        .press:    ("the ceiling is coming down", "the weight was holding you all along"),
        .known:    ("the room exists only where attention rests", "it has turned, and it rests on you"),
        .membrane: ("no door · you were always inside", "source within source · it was never one womb"),
        .triple:   ("three rooms · one seal, only in stillness", "three and one, and always both"),
        .dissolve: ("there was never anyone here but Her", "the bindu is where you are standing"),
    ]

    /// Design's seat line, for a room the resolution order left as her seat.
    static let seatSentence = "her seat, from inside"

    /// The words for one room, from her name and quality and the room itself.
    static func compose(room: HomeRoom, name: String, quality: String) -> RoomWords {
        let ordinal = ordinals[room.ring].map { "the \($0) āvaraṇa" } ?? "the āvaraṇa"
        let region = room.world.region.trimmingCharacters(in: .whitespacesAndNewlines)
        let place = region.isEmpty ? ordinal : "\(region) · \(ordinal)"

        let near: String
        let deep: String
        switch room.kind {
        case .authored(let mechanism):
            let said = authored[mechanism] ?? (near: seatSentence, deep: seatSentence)
            near = said.near
            deep = said.deep
        case .grammar(let reading):
            near = reading.label.near
            deep = reading.label.deep
        case .seat:
            near = seatSentence
            deep = seatSentence
        }
        return RoomWords(place: place,
                         name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                         quality: quality.trimmingCharacters(in: .whitespacesAndNewlines),
                         near: near, deep: deep)
    }

    /// The words for a room that was handed no row — a preview or a capture.
    /// Her written name and her quality are the rite's own; the place and the
    /// sentences are the room's.
    static func compose(room: HomeRoom, rite: RiteWords) -> RoomWords {
        compose(room: room, name: rite.written, quality: rite.gloss)
    }
}
