import Foundation

// MARK: - AṆIMĀ · khaḍgamālā position 1 · the room that closes in
//
// Design's `chamberContract`, built on the Phase 3.1 spine. One of the eight
// rooms Design authored by hand and one of the six it never finished; Ruling 10
// accepts an authored room without a grammar-only proof, and this one is reached
// through ``HomeRooms/authored`` **by position**.
//
// Design's own two sentences for it are the whole room:
//
//     the walls close while you stand still
//     the point was a door all along
//
// Aṇimā is Smallness — `Aṇu`, the atomic, felt at *the bindu point at the crown,
// a single point of attention*. Her room is the one room in the instrument whose
// **enclosure comes in**, and the first thing a walker in it notices is that he
// has not moved and the room has.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE THING THIS ROOM DOES THAT NO OTHER ROOM MAY
// ─────────────────────────────────────────────────────────────────────────────
//
// There are exactly two things an enclosure can do — it closes in, or it leaves
// — and Ring 1 holds both of Design's authored examples of them. Laghimā's walls
// leave (``ReleaseRoom``), and they leave **at the turn**, as her reversal.
// Aṇimā's walls close in, and they close **while the eye is still settling**, as
// her premise. A room that borrowed either would be standing in the other's.
//
// That is why the grammar-built Siddhis next door do not move their enclosure at
// all (``SiddhiRoom``, reading 2): the two stations are spoken for.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND THE ONE PLACE DESIGN'S NUMBER IS HELD BACK
// ─────────────────────────────────────────────────────────────────────────────
//
// Design closes its shell to 0.34 of itself, and its shell holds nothing: the
// aperture is a flat sprite on the far wall and there is no mark in the room to
// pass in front of. Here the room holds **her mark**, standing at her own mount's
// depth, and a far wall closing to 0.34 of half the room arrives in front of it —
// which is the enclosure standing between the walker and the one thing he came
// to see.
//
// So the walls close by Design's own two thirds, held to the far side of her own
// work. It is the same rule the instrument already holds everywhere else, one
// step further in: nothing in any of the 102 rooms may reach the walker, and
// nothing may close in front of what he came for.
struct ContractRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// **How far in the walls come while the eye is settling.** Design's
    /// `k = 0.34 + 0.66 * (1 - smooth(t / 62))` — the room ends the first
    /// adaptation at a third of the size it opened at.
    static let closes: Double = 0.66

    /// …and what is left of it then, which is the same number said the other way.
    static let closedTo: Double = 1 - closes

    /// **How far the point opens once the premise turns.** Design's
    /// `ap.scale.setScalar((0.5 + 0.5 / k) * (1 + b * 11))` — elevenfold, which
    /// is the largest growth anywhere in Design's hundred and two rooms.
    ///
    /// Through ``RoomReversal/answeringFraction(takes:)`` that is 0.917 of the
    /// door's own clearance: the nearest any surface in the instrument comes to
    /// the walker, and still short of him, by the saturating law rather than by a
    /// clamp. Which is right — this is the room that closes in.
    static let pointOpens: Double = 11

    /// How much the point has already widened by the end of the first
    /// adaptation, purely because the room around it shrank: Design's
    /// `0.5 + 0.5 / k`, read at its own `k`.
    static let pointWidensAsTheRoomCloses: Double = 0.5

    /// **How completely the enclosure is given up at the turn.** Design's
    /// `mat.opacity = 1 - b * 0.94` — what closed in is very nearly not there.
    static let enclosureYields: Double = 0.94

    /// Design's key, `900 / (k * k)`: the room's light rises as the square of how
    /// far it has closed, so the point burns eight times brighter at the first
    /// adaptation than at the door.
    static let keyAtRest: Double = 900

    // MARK: - What the premise becomes

    /// The enclosure carried the premise by closing in; the point it was closing
    /// toward takes the whole room.
    ///
    /// Answered by her **working face** — which at the crown, where Aṇimā is
    /// felt, is the stone overhead (``RoomReversal/resolved(_:bodyAltitude:)``).
    /// That is Design's own card read literally: *the bindu point at the crown*,
    /// widening until it is the way through.
    let becoming = HomeBecoming(premise: .wall, answer: .face,
                                yields: ContractRoom.enclosureYields,
                                takes: ContractRoom.pointOpens)

    // MARK: - Where the room's own surfaces stand

    func stations(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: Double] {
        let altitude = stage.placement.bodyAltitude
        var out = RoomReversal.stations(becoming, deep: stage.deep, bodyAltitude: altitude)

        // The walls, coming in while he stands still. Positive is toward him, so
        // closing in is a positive station on the enclosure — and the reversal's
        // own negative term, already in `out`, is what takes it away again at the
        // turn. One room, two adaptations, and the second genuinely reverses the
        // first rather than continuing it.
        out[.wall, default: 0] += Self.travelIn(stage: stage) * stage.settling
        return out
    }

    /// How far in the enclosure may come: Design's two thirds, or the far side of
    /// her own work, whichever is nearer. See the header.
    static func travelIn(stage: RoomStage) -> Double {
        let altitude = stage.placement.bodyAltitude
        let gap = RoomReversal.clearance(of: .wall, bodyAltitude: altitude)
        // Where her work stands, and how wide it is, at the moment the room has
        // finished closing. Read off the placement rather than chosen, so a
        // re-proportioned mount arrives here instead of being missed.
        let settled = RoomUnits.placement(bodyAltitude: altitude,
                                          chamberTime: HomeMemory.firstAdaptation)
        let standOff = abs(settled.depth) + settled.footprint
        return max(0, min(gap * closes, gap - standOff))
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let altitude = stage.placement.bodyAltitude
        let answer = RoomReversal.resolved(becoming, bodyAltitude: altitude).answer
        guard stage.materials[answer] != nil else { return [:] }
        let k = stage.settling, b = stage.deep

        // ── the point ───────────────────────────────────────────────────────
        //
        // Present from the first moment, and at the first moment it is a point:
        // the room has not closed yet, so there is nothing to have widened it. It
        // opens on Design's own two ramps — the first because the room around it
        // is shrinking, the second because the premise has turned — and the two
        // are normalised against what they themselves end at, so the door is half
        // the surface when the stay is over and a point when it began.
        let shell = 1 - Self.closes * k
        let widened = (Self.pointWidensAsTheRoomCloses
                       + Self.pointWidensAsTheRoomCloses / max(shell, Self.closedTo))
            * (1 + b * Self.pointOpens)
        let full = (Self.pointWidensAsTheRoomCloses
                    + Self.pointWidensAsTheRoomCloses / Self.closedTo)
            * (1 + Self.pointOpens)
        let reach = RoomReversal.answeringSpan * min(1, widened / full)

        // **An opening, and so an impression.** ``RoomReversal`` answers with a
        // swell because material taking the work over usually comes toward the
        // walker; an opening is the exception, and it is the exception by
        // definition — an opening is material that has drawn back. That is the
        // same reading ``ReleaseRoom`` makes of its own lid, and the verb is
        // still read from the travel rather than assigned: the material goes away
        // from him, and away from him is an impression. The *surface* it is in
        // comes toward him, which is the station above.
        let lip = RoomInscription.markDepth * (1 + 2 * k + 4 * b)

        // Design's key rises as the **square** of how far the room has closed —
        // `900 / (k * k)`, which is eight and a half times brighter by the end of
        // the first adaptation — normalised against what it reaches then, so it
        // reads as a share of the light rather than as a three.js intensity. The
        // point is therefore at its brightest exactly while it is still small,
        // and the light in the room is the way out of it.
        let rises = (Self.closedTo * Self.closedTo) / max(shell * shell, 1e-6)
        let glow = min(1, 0.3 + 0.45 * rises + 0.25 * b)

        return [answer: [.impression(at: .centre, reach: reach, depth: lip, glow: glow)]]
    }
}
