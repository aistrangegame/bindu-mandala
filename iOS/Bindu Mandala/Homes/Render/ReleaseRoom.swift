import Foundation

// MARK: - LAGHIMĀ · khaḍgamālā position 3 · the room whose floor has let go
//
// Design's `chamberRelease`, built on the Phase 3.1 spine. Ruling 10 accepts the
// authored Gate: this room is **hand-built** and reached through the authored map
// by position.
//
// Its premise is the other half of Design's own paired example — one room must
// lift and the other must press. *"The floor has let go. Walls end before the
// ground, hems lifting. Nothing falls."* And its reversal, in Design's own words
// on the line that does it:
//
//     nothing in this room falls — including the room.
//     the room has let go of itself
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO DEFECTS DESIGN HIT IN THIS EXACT ROOM, AND WHY NEITHER CAN RECUR HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// Both are in `The Homes - the thread.md`, in the list of six real defects its
// verification pass found. Both were in Laghimā and nowhere else.
//
// **1 · She stacked additively to pure white at arm's length.** Her rising field
// was three hundred and forty additive points; at the near plane they piled on
// top of one another until the room was flat white and unreadable. Design's fix
// was to clamp the point size and push the field off the eye.
//
// It cannot recur, and not because it was remembered. *There is no additive field
// in this room.* The only thing this file can do is act on the canopy's own
// material, and a surface's emission is `min(1, …)` of a value that is itself
// bounded by how far the material moved — so there is no quantity here that can
// accumulate. The room's own weather is the spine's, which carries the spike's
// measured screen-space clamp already. `testLaghimaIsNeitherBlownOutNorDark`
// pins it at the adaptation Design's defect appeared at.
//
// **2 · She then went dark at the second adaptation, because the walls departing
// left an empty room.** This one is a real hazard here, because the walls
// departing *is* the reversal and the floor has already let go — so at the turn
// this room genuinely has no floor and no enclosure. Design's fix is the whole
// design of the reversal and it is honoured literally: *"as the walls go, the
// opening they were hanging from takes the whole room."*
//
// So the answer is the **canopy**, and it is not an absence. The opening comes
// down toward him and widens, and it is the brightest thing in the instrument's
// first ring by the time the stay is over. The reversal is not the enclosure
// removed; it is the opening arriving.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE PLACE THIS ROOM READS THE VERB THE OTHER WAY, AND WHY
// ─────────────────────────────────────────────────────────────────────────────
//
// ``RoomReversal`` answers with a **swell**, because material taking the work
// over usually comes toward the walker. An opening is the exception, and it is
// the exception by definition: an opening is material that has *drawn back*. So
// the canopy's mark here is an **impression** — the ceiling parting upward into a
// widening dome — while the canopy itself descends toward him. That is Design's
// lid exactly: a rim that comes down and a mouth that opens.
//
// The verb is still read from the travel rather than assigned: the material moves
// away from him, and away from him is an impression.
struct ReleaseRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// **How far the floor has already let go while the eye is still settling.**
    /// Design's hems lift `uLift * 2.4` on walls thirteen tall.
    static let letsGoEarly: Double = 2.4 / 13

    /// **How completely the ground it let go of is gone by the turn.**
    /// `gone.material.opacity = 0.55 * (1 - b)` — completely.
    static let letsGo: Double = 1

    /// **How far the opening grows as it takes the room over.**
    /// `lid.scale.setScalar(1 + b * 1.5)`.
    ///
    /// Through ``RoomReversal/answeringFraction(takes:)`` this brings the opening
    /// three fifths of the way down to him — which, against her own room's
    /// proportions, is where Design's lid ends up: `8.4 - b * 5.4` leaves it a
    /// little above an eye at 2.4. The saturating law arrived at Design's own
    /// staging without being told it.
    static let openingGrows: Double = 1.5

    /// **How far the enclosure departs.** `w.position.y = 1.4 + b * (15 + i * 2.4)`
    /// on walls thirteen tall: they travel further than their own height, so what
    /// is left of the enclosure is nothing. It is all of its own clearance and no
    /// more — a wall leaves outward, so there is no walker for it to pass through
    /// on the way.
    static let enclosureDeparts: Double = 1

    /// How wide the opening stands at each stage of the stay, in the canopy's own
    /// coordinates. Design's lid is a ring from 2 to 12.4 on a floor of 26 — a
    /// little under half the surface — and it grows by half as much again.
    static let openingAtRest: Double = 2 / 26
    static let openingSettled: Double = 12.4 / 26

    // MARK: - What the premise becomes

    /// The floor carried the premise by letting go of him; the opening the walls
    /// were hanging from takes the whole room.
    let becoming = HomeBecoming(premise: .ground, answer: .canopy,
                                yields: ReleaseRoom.letsGo, takes: ReleaseRoom.openingGrows)

    // MARK: - Where the room's own surfaces stand

    func stations(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: Double] {
        let altitude = stage.placement.bodyAltitude
        var out = RoomReversal.stations(becoming, deep: stage.deep, bodyAltitude: altitude)

        // It has already begun letting go while the eye is still settling — the
        // hems lifting, the ground going out from under him before anything has
        // reversed. Negative is away from him.
        out[.ground, default: 0] -= RoomReversal.clearance(of: .ground, bodyAltitude: altitude)
            * Self.letsGoEarly * stage.settling

        // And at the turn the enclosure goes the way everything loose in this room
        // has been going. Nothing in it falls, including the room.
        out[.wall] = -RoomReversal.clearance(of: .wall, bodyAltitude: altitude)
            * Self.enclosureDeparts * stage.deep
        return out
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let k = stage.settling, b = stage.deep

        // The opening, present from the first moment and widening the whole way.
        // It is hers — it is what her floor let go *into* — so it is there before
        // the reversal and the reversal is it arriving, not it appearing.
        let span = Self.openingAtRest
            + (Self.openingSettled - Self.openingAtRest) * (0.55 * k + 0.45 * b)
        let lip = RoomInscription.markDepth * (1 + 2 * k + 4 * b)

        // Bright, and brighter as the walls go, because this is the light the room
        // has instead of an enclosure. It is still the surface's own emission and
        // still multiplied by how far the surface moved, so it is a lit mouth in
        // stone rather than a lamp hung in the air.
        let glow = min(1, 0.45 + 0.2 * k + 0.35 * b)

        return [.canopy: [.impression(at: .centre, reach: span, depth: lip, glow: glow)]]
    }
}
