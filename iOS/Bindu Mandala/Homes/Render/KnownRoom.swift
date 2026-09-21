import Foundation

// MARK: - VAŚITVA · khaḍgamālā position 6 · the room that has turned toward you
//
// Design's `chamberKnown`, built on the Phase 3.1 spine. Authored by hand,
// reached through ``HomeRooms/authored`` **by position**, and accepted under
// Ruling 10 without a grammar-only proof.
//
// Design's two sentences, and the comment between them, which is the room:
//
//     the room exists only where attention rests
//     // mastery is not holding attention. It is being found by it.
//     it has turned, and it rests on you
//
// Vaśitva is Mastery — `Saṃyama`, integration, felt at *the throat and the
// lungs*. Note the name: Design's own `BY_NAME` keys this room as `Vaśitā`,
// which matches no card in its own data, so in Design's shipped Axis this room is
// never reached at all and its harness cannot see it happen. Keyed by position it
// cannot be misspelled.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ROOM IS DARK, AND ONE POOL OF ATTENTION WANDERS IT
// ─────────────────────────────────────────────────────────────────────────────
//
// `chamberKnown` is the only one of Design's chambers built around a **shadow**:
// a spotlight with a shadow map, six pillars that cast, a seat, and an ambient so
// low the room is legible only where the pool happens to be. Everything else in
// the instrument is lit by its own marks; this room is lit by one moving light
// falling across stone that is standing there whether it is lit or not.
//
// Carried into the five verbs, that is exactly what it becomes: the pillars and
// the seat are **compactions in the room's own floor** — the feet of the things
// that are there — and the pool is **one travelling mark**, whose own light is
// the only light in the room. What a spotlight does to a surface and what a
// travelling mark does to a surface are the same fact seen from two sides, and
// only one of them can be written here.
//
// ─────────────────────────────────────────────────────────────────────────────
// ONE WANDERING MARK, AND WHY IT IS NOT ANY OTHER RING 1 ROOM
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's pool moves on a Lissajous of its own — `wx = sin(t * 0.16) * 5.2 +
// sin(t * 0.058) * 1.8`, `wz = -11 + cos(t * 0.125) * 5.4` — which is **not her
// physics**. It is the room's own searching, and it is the one place in Ring 1
// where a room moves by something other than the walker's Śakti. That is
// deliberate and it is the whole sentence: mastery is not holding attention, it
// is being found by it, and a thing that is looking for you does not move the way
// you do.
//
// Past the turn the search stops: `x = wx * (1 - b)`, `z = wz * (1 - b) + b * 0.8`
// — the pool comes to rest where the walker is. Nothing else in the ring converges
// on him; the Mātṛkās draw in to a column of their own and the Mudrās open away.
struct KnownRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// The pool's own wandering, in Design's room: two rates across and one
    /// along, none of them hers.
    static let sweepFast: Double = 0.16
    static let sweepSlow: Double = 0.058
    static let sweepAlong: Double = 0.125
    static let sweepAcrossFar: Double = 5.2
    static let sweepAcrossNear: Double = 1.8
    static let sweepAlongFar: Double = 5.4
    /// Design's `wz = -11 + …` — the middle of the room's own depth, which here
    /// is where her mark already falls.
    static let sweepCentre: Double = -11

    /// How wide the pool of attention is: Design's spot at `angle = 0.4` falling
    /// from `(0, 3.2, -4)` onto `(0, -3.4, -11)`, which opens to a little under
    /// three units on the floor.
    static let poolSize: Double = 2.9

    /// …and how much it narrows as it settles on him: Design's
    /// `pool.angle = 0.4 - b * 0.17`.
    static let poolNarrows: Double = 0.17 / 0.4

    /// How much brighter it burns when it has found him: Design's
    /// `pool.intensity = 2400 * (1 + b * 0.7)`.
    static let poolBrightens: Double = 0.7

    /// Design's six pillars, `i % 2 ? 5.6 : -5.6` across and
    /// `-3 - floor(i / 2) * 7` along: three pairs standing down the room.
    static let pillars = 6
    static let pillarAcross: Double = 5.6
    static let pillarFirst: Double = -3
    static let pillarStep: Double = -7
    /// Their own footing: `CylinderGeometry(0.42, 0.5, 10, 20)`.
    static let pillarFoot: Double = 0.5

    /// The seat the pool begins on: `CylinderGeometry(1.9, 2.3, 0.5, 32)` at
    /// `(0, -4.7, -11)`, with a ring of 1.5 standing on it.
    static let seatFoot: Double = 2.3
    static let seatRing: Double = 1.5

    /// How completely the ring on the seat gives the room up: Design's
    /// `ring2.material.opacity = … * (1 - b * 0.72)`.
    static let seatYields: Double = 0.72

    // MARK: - What the premise becomes

    /// The working face carried the premise — the room out there, existing only
    /// where attention happened to rest — and the **ground** takes it over, which
    /// is where he is standing.
    ///
    /// A ground that takes the work over does it as *material*, never as a
    /// station: he is standing on it, and nothing in the instrument moves the
    /// walker (``RoomReversal/stations(_:deep:bodyAltitude:)``). Which is right
    /// here — *it rests on you* is a thing that happens to the floor under him,
    /// not a floor that rises to meet him.
    let becoming = HomeBecoming(premise: .face, answer: .ground,
                                yields: KnownRoom.seatYields,
                                takes: KnownRoom.poolBrightens)

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let b = stage.deep
        let axes = RoomUnits.axes(of: surface)
        let centre = stage.placement.coordinate

        // The room's furniture, and the pool, as one figure — so that a room that
        // has to stand on a working face one body square keeps its shape instead
        // of losing its far pillars over the edge.
        let figure = RingOne.Figure(spread: abs(Self.pillarFirst
                                                + Double(Self.pillars / 2 - 1) * Self.pillarStep),
                                    part: Self.seatFoot,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.pillars + 3)

        // ── what is standing in the room whether it is lit or not ───────────
        //
        // Six pillar feet and a seat, driven into the floor and densified, with
        // no light of their own at any moment of the stay. A compaction is the
        // mark of something that bore down without moving, which is what a pillar
        // does, and it is the one verb in the vocabulary that leaves almost no
        // relief — so what the pool finds is a floor with things standing on it
        // rather than a floor with holes in it.
        for index in 0..<Self.pillars {
            let across = index % 2 == 0 ? -Self.pillarAcross : Self.pillarAcross
            let along = Self.pillarFirst + Double(index / 2) * Self.pillarStep
            marks.append(.compaction(at: Self.on(surface: centre,
                                                 across: figure.length(across),
                                                 along: figure.length(along),
                                                 axes: axes, material: material),
                                     reach: figure.reach(Self.pillarFoot),
                                     depth: RingOne.depth(size: 0.5, on: material)))
        }
        marks.append(.compaction(at: centre,
                                 reach: figure.reach(Self.seatFoot),
                                 depth: RingOne.depth(size: 0.8, on: material)))

        // …and the ring standing on the seat, which is the one thing in the room
        // that was ever addressed to him, and which gives the room up at the turn.
        // **It withdraws by its reach and not by its depth.** A mark that grew
        // shallower would stop being seen while it was still there, which is a
        // different thing from leaving — and below the stone's own grain it is not
        // a faint mark, it is no mark (``RingOne/depth(size:on:)``).
        let ring = figure.reach(Self.seatRing) * (1 - b * Self.seatYields)
        if ring > 0 {
            marks.append(.furrow(at: centre, reach: ring,
                                 depth: RingOne.depth(size: 0.4, on: material)))
        }

        // ── the pool of attention ───────────────────────────────────────────
        //
        // One mark, wandering on the room's own search — **not hers** — and
        // narrowing, brightening and coming to rest on him as the premise turns.
        // A travelling mark is a furrow, and the verb is read from the travel by
        // ``RingOne/mark(_:from:reach:share:travel:glow:material:)`` rather than
        // named here.
        let here = pool(at: chamberTime, figure: figure, stage: stage,
                        axes: axes, material: material)
        let before = pool(at: chamberTime - RingOne.readOver, figure: figure, stage: stage,
                          axes: axes, material: material)
        let narrowed = 1 - b * Self.poolNarrows
        marks.append(RingOne.mark(here, from: before,
                                  reach: figure.reach(Self.poolSize) * narrowed,
                                  size: 1,
                                  travel: figure.length(Self.sweepAcrossFar),
                                  // The only light in the room, and brighter once
                                  // it has found him: Design's `2400 * (1 + b *
                                  // 0.7)` against its own ceiling.
                                  glow: (1 + b * Self.poolBrightens) / (1 + Self.poolBrightens),
                                  material: material))

        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - Where the pool is looking

    /// Where the pool of attention stands at one moment: Design's own Lissajous
    /// while the eye is settling, and where the walker stands once it has turned.
    func pool(at chamberTime: TimeInterval, figure: RingOne.Figure, stage: RoomStage,
              axes: RoomUnits.SurfaceAxes, material: RoomMaterial) -> RingOne.Place {
        let t = chamberTime, b = stage.deep
        let across = sin(t * Self.sweepFast) * Self.sweepAcrossFar
            + sin(t * Self.sweepSlow) * Self.sweepAcrossNear
        let along = cos(t * Self.sweepAlong) * Self.sweepAlongFar

        // …and it comes to rest. Design: `x = wx * (1 - b)`, `z = wz * (1 - b) +
        // b * 0.8` — the search stops and what is left is where he is.
        let searching = RingOne.Place(
            at: Self.on(surface: stage.placement.coordinate,
                        across: figure.length(across),
                        along: figure.length(along),
                        axes: axes, material: material),
            into: 0)
        // Where the walker is, on the surface's own coordinates: the near edge,
        // which on a floor or a canopy is where he is standing and on a working
        // face is the middle of the panel in front of him.
        let onHim = RingOne.Place(
            at: SurfaceCoordinate(u: 0.5, v: axes.alongIsRise ? 0.5 : 1).clamped,
            into: 0)
        return searching.drawn(toward: onHim, by: b)
    }

    /// A point in Design's room, on the surface this room is happening to.
    static func on(surface centre: SurfaceCoordinate,
                   across: Double, along: Double,
                   axes: RoomUnits.SurfaceAxes, material: RoomMaterial) -> SurfaceCoordinate {
        SurfaceCoordinate(u: centre.u + material.reach(worldUnits: across),
                          v: centre.v + material.reach(worldUnits:
                                axes.along(design: along, rise: along))).clamped
    }
}
