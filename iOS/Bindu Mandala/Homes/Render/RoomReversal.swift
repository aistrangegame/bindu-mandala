import Foundation

// MARK: - The reversal, as something the room does
//
// ``HomeBecoming`` says what a room's premise becomes. This file is the only
// place that turns it into the room doing it, and it does so in exactly two
// registers, both of which are the room's own material:
//
//   * **stations** — where each of the room's four surfaces stands. A station is
//     one number per surface, a displacement of a surface that already exists
//     along the one axis that surface has. It cannot make a surface, cannot name
//     a node and cannot put anything anywhere: the whole return type is
//     `[RoomSurfaceKind: Double]`.
//   * **the answering mark** — one action, through the five verbs, on the surface
//     the work moved to.
//
// Everything a reversal is, is in those two. There is no third register and no
// door here for a solid, which is the renderer ruling's binding condition holding
// at the layer that was missing when Phase 3.1 shipped.
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO RULES, AND NEITHER OF THEM IS A CONSTANT
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · A surface travels a fraction of its own distance to the walker.** There
// is no `reversalThrow` here and there must not be: how far the canopy can come
// down is how far the canopy *is*, and it is a different distance from how far
// the floor can rise. ``clearance(of:bodyAltitude:)`` is that distance, read off
// ``RoomUnits``, and every travel below is a fraction of it.
//
// **2 · The room comes toward him and never reaches him.** The answering
// fraction is `takes / (1 + takes)`, which saturates: Design's largest growth —
// Ring 5's cup at `1 + b * 4.2` — reaches 0.81 of the clearance and nothing
// reaches 1. The walker is never touched by the room, and that is arithmetic
// rather than a clamp somebody has to remember.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE VERB IS READ FROM THE TRAVEL, NOT ASSIGNED
// ─────────────────────────────────────────────────────────────────────────────
//
// ``RoomInscription`` already classifies which of the five verbs a moving part is
// performing from its own velocity, and a reversal is held to the same
// discipline: material coming toward the walker is a **swell**, material going
// away from him is an **impression**. Nothing here is keyed by an archetype's
// name or by a room's name — the same law as everywhere else in the instrument.
enum RoomReversal {

    // MARK: - Which surfaces a becoming actually names in this room

    /// A becoming's two parts, resolved against the room she is actually in.
    ///
    /// ``HomeBecoming`` speaks of a **working face** — the stone standing at her
    /// own altitude — because that is the part of the room her work happens on.
    /// Where her altitude fuses that face into the floor or the ceiling
    /// (``RoomUnits/surface(forBodyAltitude:)``), her working surface *is* the
    /// floor or the ceiling, and the becoming means that.
    ///
    /// One consequence needs a rule of its own: a Śakti felt at the soles whose
    /// archetype answers the face with the ground would have the premise and the
    /// answer land on the same stone, and a premise answered by itself is not a
    /// reversal. So the answer passes to the opposite pole. That is what "the
    /// work moved" means when her own surface is already the floor.
    static func resolved(_ becoming: HomeBecoming,
                         bodyAltitude: Double) -> (premise: RoomSurfaceKind, answer: RoomSurfaceKind) {
        let working = RoomUnits.surface(forBodyAltitude: bodyAltitude)
        func place(_ part: RoomSurfaceKind) -> RoomSurfaceKind {
            part == .face ? working : part
        }
        let premise = place(becoming.premise)
        var answer = place(becoming.answer)
        if answer == premise {
            answer = premise == .canopy ? .ground : .canopy
        }
        return (premise, answer)
    }

    // MARK: - How far a surface can travel

    /// How far this surface stands from the walker's eye — the whole distance it
    /// could ever travel toward him, and the scale everything below is a fraction
    /// of.
    ///
    /// Read off ``RoomUnits`` in every case, so a room that is re-proportioned
    /// arrives here rather than being missed. The working face's clearance is
    /// measured from where her mount has already brought it by the end of the
    /// second adaptation, so the reversal and the mount cannot double-count the
    /// same travel.
    static func clearance(of surface: RoomSurfaceKind, bodyAltitude: Double) -> Double {
        switch surface {
        case .ground:
            return RoomUnits.eyeY - RoomUnits.floorY
        case .canopy:
            return RoomUnits.canopyY - RoomUnits.eyeY
        case .face:
            // **A working face may come to the middle of the room and no
            // further, and this is a fact about a panel rather than a tuning.**
            //
            // A face is one body square standing at her own altitude, and her
            // mount has already brought it most of the way in by the end of the
            // second adaptation. Measured to the *eye*, its remaining clearance
            // is four and a half units — so a face that travelled three quarters
            // of it, which is what Design's own Mātṛkā growth asks for, ends the
            // stay a third of a body from the eye with a span five times the
            // height of the frame. Looking at it is conclusive: all eight Mātṛkā
            // rooms rendered as one flat grey field at 0.70 luminance with a
            // spread of 0.013, which is the *whole picture* being her working
            // surface. Nothing in the suite could see it — a face answering a
            // premise had never been rendered, because Ring 2's answer is the
            // enclosure and the Gate's two are the floor and the ceiling.
            //
            // So the half of the room between its middle and the eye is the
            // walker's own standing room — it is exactly ``RoomUnits/eyeZ``, half
            // a body — and no surface enters it. What is left is how far the face
            // still is from the room's own origin, which is what it may travel.
            // It is the same law the ground already has one line below, said for
            // the one surface that stands in front of him rather than under him.
            let settled = RoomUnits.placement(bodyAltitude: bodyAltitude,
                                              chamberTime: HomeMemory.secondAdaptationEnd)
            return max(0, -settled.depth)
        case .wall:
            return RoomUnits.halfExtent
        }
    }

    /// Design's growth, as the fraction of its clearance the answering surface
    /// travels. Saturating, so the room never reaches the walker.
    ///
    /// Unsigned: how *far*. Which way is ``HomeBecoming/answerComes``, and the two
    /// are kept apart because only one of them can ever put a surface where the
    /// walker is.
    static func answeringFraction(takes: Double) -> Double {
        let size = abs(takes)
        return size <= 0 ? 0 : size / (1 + size)
    }

    // MARK: - The stations

    /// Where each of the room's surfaces stands as the premise turns.
    ///
    /// Positive is **toward the walker**, along that surface's own way off the
    /// material — the same direction ``RoomUnits/emberOffset(for:)`` gives, so
    /// there is one answer in the instrument to "which way is out of this stone".
    ///
    /// Nothing happens until the second adaptation begins: while the eye is still
    /// settling the room is standing in its premise, which is what makes the turn
    /// a turn.
    static func stations(_ becoming: HomeBecoming,
                         deep: Double,
                         bodyAltitude: Double) -> [RoomSurfaceKind: Double] {
        guard becoming.isAReversal, deep > 0 else { return [:] }
        let part = resolved(becoming, bodyAltitude: bodyAltitude)
        let yielding = clearance(of: part.premise, bodyAltitude: bodyAltitude)
            * becoming.yields * deep
        var taking = clearance(of: part.answer, bodyAltitude: bodyAltitude)
            * answeringFraction(takes: becoming.takes) * deep * becoming.answerComes

        // **The ground never comes toward him, and this is a fact about walking
        // rather than a tuning.** He is standing on it. A floor that rose toward
        // his eye would have to have lifted him with it, and nothing in the
        // instrument moves the walker — so a ground that "takes the work over"
        // does it as *material*: the plinth, the bedding, the thing he is standing
        // on, which is where it belongs anyway. Looking at the room is what found
        // this: with the station allowed, Garimā past the second adaptation was a
        // pale wall filling four fifths of the frame and every bed she had made
        // was gone behind it.
        //
        // Going away is untouched. A floor can let go under him — that is
        // Laghimā's whole premise.
        if part.answer == .ground { taking = min(0, taking) }
        return [part.premise: -yielding, part.answer: taking]
    }

    // MARK: - The answering mark

    /// How wide the answering mark opens on its surface, at full depth: half the
    /// surface, so what the work moved to reads as the room rather than as a
    /// patch on it. Design's reversals are all *"and then it was the whole
    /// room"*; half the span is the widest a mark can be and still have material
    /// around it to be a mark in.
    static let answeringSpan: Double = 0.5

    /// What the answering surface does as it takes the work over.
    ///
    /// One action, of one of the five verbs, read from which way the surface is
    /// travelling. It opens from nothing at the start of the second adaptation to
    /// a mark half the surface wide, and it carries light in exactly the way
    /// every other mark in the instrument does — as a property of how far the
    /// material moved, and never as a brightness of its own
    /// (``RoomMaterial/emission(at:)``).
    ///
    /// The enclosure is not marked, and that is deliberate: a wall is the room's
    /// own sides, it carries no morphing material, and Design never marks one. An
    /// enclosure that answers does so by moving — which is a station, and is the
    /// other half of this file.
    static func actions(_ becoming: HomeBecoming,
                        deep: Double,
                        stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        guard becoming.isAReversal, deep > 0 else { return [:] }
        let altitude = stage.placement.bodyAltitude
        let part = resolved(becoming, bodyAltitude: altitude)
        guard part.answer != .wall, let material = stage.materials[part.answer] else { return [:] }

        let fraction = answeringFraction(takes: becoming.takes)
        let reach = answeringSpan * fraction * deep
        guard reach > 0 else { return [:] }

        // How far the material moves, in scene units: the surface's own travel,
        // which is the distance the station is already carrying it. A mark that
        // stood still while its surface travelled would be light on undisturbed
        // stone, which is the defect the mark-light fix already had to close once.
        let depth = RoomInscription.markDepth * (1 + fraction)
        let glow = min(1, 0.35 + 0.5 * fraction)

        // Toward him the material rises out of the surface; away from him it is
        // drawn back into it. Read from the travel, exactly as
        // `RoomInscription.verb(for:previous:)` reads its own — nothing here is
        // keyed by an archetype's name or by a room's.
        let where_ = SurfaceCoordinate(u: 0.5, v: material.surface == .face
                                       ? 0.5
                                       : stage.placement.coordinate.v)
        let mark = becoming.answerComes > 0
            ? SurfaceAction.swell(at: where_, reach: reach, depth: depth, glow: glow)
            : SurfaceAction.impression(at: where_, reach: reach, depth: depth, glow: glow)
        return [part.answer: [mark]]
    }
}

// MARK: - The ninety-four rooms the grammar speaks for

/// A room whose reversal is her archetype's.
///
/// This is what closes the Phase 3.1 gap for everybody who is not one of the
/// authored eight: her ring's archetype already decides what her room *is*, and
/// ``HomeBecoming/archetype(_:)`` reads Design's own builder for what its premise
/// **becomes**. Ten archetypes, ten different turns, arriving through the same
/// door the authored rooms walk through.
struct GrammarReversal: RoomSurfaceMechanism {
    let becoming: HomeBecoming

    init(_ reading: HomeGrammar.Reading) {
        self.becoming = .archetype(reading.archetype)
    }
}

// MARK: - Which mechanism a room gets

/// The dispatch from a resolved room to the mechanism that acts in it.
///
/// It reads ``HomeRoom/kind``, which is decided by ``HomeRooms`` by position and
/// by nothing else, so this file cannot become a second resolution order. A seat
/// — a Śakti the grammar declines to speak for — gets no mechanism, because a
/// room with no premise has no premise to reverse, and inventing one would be the
/// generic intensification under a new name.
enum RoomMechanisms {

    static func forRoom(_ room: HomeRoom) -> RoomSurfaceMechanism? {
        switch room.kind {
        case .authored(let mechanism):
            if let built = authored(mechanism) { return built }
            // One of the six Design authored and Phase 3.3 has not built yet. She
            // keeps her ring's own reversal in the meantime rather than none: a
            // room that does not reverse is a loop, and a half-built Gate must
            // not cost the other six the turn they already had.
            return archetypeReversal(ring: room.ring, position: room.position)
        case .grammar(let reading):
            // Ring 2 is built. Her archetype is the crossing and ``CrossingRoom``
            // is Design's own `crossed(…)`, so the sixteen get the room rather
            // than the bare turn their archetype would otherwise hand them.
            //
            // Keyed off the archetype the resolution already read, which is
            // decided by ring and position and by nothing else — there is no
            // second resolution order here and no name is consulted.
            // `testEveryKarsiniReachesTheCrossingByPosition` asserts all sixteen
            // arrive, by position, and that nobody else does.
            switch reading.archetype {
            case .crossed: return CrossingRoom(reading)
            // Ring 1 is three families and not one ring of twenty-eight, so it
            // arrives as three rooms and not one. The archetype was decided by
            // ``HomeGrammar/ringOneFamily(position:)`` from her position alone,
            // which is the only key the laws allow.
            case .siddhi: return SiddhiRoom(reading)
            case .matrka: return MatrkaRoom(reading)
            default: return GrammarReversal(reading)
            }
        case .seat:
            return nil
        }
    }

    /// The hand-built rooms. Phase 3.3 built the Gate — Laghimā at khaḍgamālā 3
    /// and Garimā at khaḍgamālā 4 — and Phase 3.5 builds the five Design named in
    /// Ring 1 and never finished, in its three family passes.
    static func authored(_ mechanism: HomeAuthoredMechanism) -> RoomSurfaceMechanism? {
        switch mechanism {
        case .release:  return ReleaseRoom()
        case .press:    return PressRoom()
        case .contract: return ContractRoom()
        case .endless:  return EndlessRoom()
        case .known:    return KnownRoom()
        // The Mātṛkās' and the Mudrās' passes follow; ``MembraneRoom`` and
        // ``TripleRoom`` are Mudrā seats and arrive with them, and the Bindu's
        // own room waits for Ring 9.
        case .membrane, .triple, .dissolve: return nil
        }
    }

    /// Her ring's archetype reversal, for a room the grammar was not asked to
    /// read. Position is the only key, exactly as it is in ``HomeRooms``.
    static func archetypeReversal(ring: Int, position: Int) -> RoomSurfaceMechanism? {
        guard let archetype = HomeGrammar.archetype(ring: ring, position: position) else {
            return nil
        }
        return ArchetypeReversal(becoming: .archetype(archetype))
    }
}

/// A reversal taken straight from an archetype, for a room that carries no
/// ``HomeGrammar/Reading`` of its own.
struct ArchetypeReversal: RoomSurfaceMechanism {
    let becoming: HomeBecoming
}
