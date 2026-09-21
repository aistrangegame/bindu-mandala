import Foundation

// MARK: - MAHIMĀ · khaḍgamālā position 2 · the room with no far wall
//
// Design's `chamberEndless`, built on the Phase 3.1 spine. Authored by hand,
// reached through ``HomeRooms/authored`` **by position**, and accepted under
// Ruling 10 without a grammar-only proof.
//
// Design's two sentences:
//
//     no far wall · it never arrives
//     you were never inside anything
//
// Mahimā is Vastness — `Mahat`, the vast, felt at *the periphery, the horizon of
// attention*. Note that she is at khaḍgamālā **2** and Laghimā is at 3: a map
// keyed by name cannot tell you that, and ``HomeRooms/authored`` cannot get it
// wrong.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ROOM HAS NO ENCLOSURE, FROM THE FIRST MOMENT — AND THAT IS NOT LAGHIMĀ
// ─────────────────────────────────────────────────────────────────────────────
//
// `chamberEndless` builds **no shell at all**. There is no wall material in it,
// no seams, no box: twenty-four frames flowing toward the walker down a span of
// a hundred and twenty, a haze, and dust. The absence is the room.
//
// So the enclosure here is gone **at `t = 0` and at every instant after it**, and
// it never moves again. That is what separates this room from ``ReleaseRoom``,
// whose walls are present for the whole of the first adaptation and leave *as the
// reversal* — and from ``ContractRoom``, whose walls close in. Three authored
// rooms, three different things an enclosure can do, and this one's is the
// simplest: it was never there.
//
// It also means the light in this room cannot come from the walls, and Design's
// does not: the frames themselves carry it, `sin(π · clamp01((z + SPAN) / SPAN))
// * 0.95 + 0.06`, brightest in the middle distance and gone at both ends.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE PROCESSION, AND WHY IT IS NOT THE SIDDHI'S TRAIN
// ─────────────────────────────────────────────────────────────────────────────
//
// A Siddhi's six answers stand still and carry her own motion at six moments of
// its past (``SiddhiRoom``). Mahimā's frames **flow**: they advance with the
// clock at Design's `t * 3.4` and wrap, so a frame that has reached the walker is
// replaced by one that has not — which is the only way to say *it never arrives*
// in a room that has to end somewhere. Nothing else in Ring 1 moves along the
// room rather than in place.
struct EndlessRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// Twenty-four. Design's `N = 24`.
    static let frames = 24

    /// …and the ten that continue behind him once the premise turns.
    static let framesBehind = 10

    /// The depth the procession runs down, and the room Design draws it in:
    /// `SPAN = 120`, in a room whose frames begin at a radius of 6.
    ///
    /// The span is not carried as a length — a hundred and twenty is twenty
    /// body-heights and no surface in this instrument is twenty bodies long. It
    /// is carried as what it *is*: the whole run of the material, from the far
    /// edge to the walker. That is Design's own reading of it, which is why its
    /// frames are faded in at one end and out at the other rather than stopped.
    static let designSpan: Double = 120

    /// How fast the procession advances: Design's `flow = t * 3.4`, as a fraction
    /// of the whole run per second.
    static let flows: Double = 3.4 / EndlessRoom.designSpan

    /// How large the frames are: Design's `r = 6 + i * 0.52`, which is a widening
    /// mouth rather than a tunnel of one bore.
    static let frameSize: Double = 6
    static let frameSizeStep: Double = 0.52

    /// …and how wide the last of them is, which is what has to fit the material.
    static var widestFrame: Double {
        frameSize + Double(max(frames, framesBehind) - 1) * frameSizeStep
    }

    /// Design's own light on a frame, at the height of its arc and at its ends:
    /// `Math.sin(Math.PI * clamp01(…)) * 0.95 + 0.06`.
    static let frameBrightest: Double = 0.95
    static let frameFloor: Double = 0.06

    /// …and on the ten that continue past him: `b * sin(…) * 0.75`.
    static let behindBrightest: Double = 0.75

    // MARK: - What the premise becomes

    /// The enclosure carried the premise by not being there; the ground he is
    /// standing on takes it over by running on past him.
    ///
    /// **Negative, and the sign is the sentence.** *You were never inside
    /// anything*: the room does not arrive at him, it goes on through where he is
    /// standing and out the other side. ``RoomReversal`` reads a negative
    /// `takes` as material travelling away from the walker, which on a ground is
    /// the one direction a ground is allowed to travel.
    let becoming = HomeBecoming(premise: .wall, answer: .ground,
                                yields: 1, takes: -EndlessRoom.behindBrightest)

    // MARK: - Where the room's own surfaces stand

    func stations(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: Double] {
        let altitude = stage.placement.bodyAltitude
        var out = RoomReversal.stations(becoming, deep: stage.deep, bodyAltitude: altitude)

        // **There is no enclosure, and there never was.** Not a wall that leaves
        // at the turn — that is Laghimā's room, eight seats along — but a room
        // that opened without one. Negative is away from him, and this is all of
        // the enclosure's own clearance, so nothing is left of it at any moment of
        // the stay. It does not depend on the clock, which is the whole point:
        // *it never arrives* is a statement about every instant.
        out[.wall] = -RoomReversal.clearance(of: .wall, bodyAltitude: altitude)
        return out
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let b = stage.deep

        // **The procession is one figure and not twenty-four.** Where the widest
        // frame does not fit the material, the whole run of them is scaled by the
        // same number rather than each frame being clamped on its own — which is
        // ``RingOne/Figure``'s rule, applied by hand here because that type bounds
        // a figure by the picture at *one* distance and this procession is the one
        // thing in Ring 1 that runs down the room's own depth. Clamped frame by
        // frame it was a tunnel of one bore: on a working face all twenty-four
        // came out the same width with forty-eight of their hundred and twenty
        // marks standing on the material's own edge, and Design's widening mouth
        // was gone.
        // …and *including the marks it is made of*, or the widest frame's own ends
        // stand on the material's edge with half of each mark hanging over it.
        let widest = material.reach(worldUnits: RingOne.inRoom(Self.widestFrame))
            * (1 + Self.markShare)
        let fits = widest > RoomReversal.answeringSpan
            ? RoomReversal.answeringSpan / widest
            : 1

        var marks: [SurfaceAction] = []
        marks.reserveCapacity((Self.frames + Self.framesBehind) * Self.marksPerFrame)

        // One frame's share of the light, so that twenty-four of them do not
        // stack to a flat field — ``RingOne/lightShare(of:)``, which is
        // ``RoomInscription``'s own arithmetic for a form with many parts.
        let share = RingOne.lightShare(of: Self.frames)
        // Deep enough to stand clear of the stone's own grain, which is the floor
        // every Ring 1 mark keeps (``RingOne/depth(size:on:)``): a frame shallower
        // than the banding it is cut into is not a frame the walker can see.
        let depth = RingOne.depth(size: share, on: material)

        // ── the procession ──────────────────────────────────────────────────
        //
        // Twenty-four frames evenly spaced down the whole run of the material and
        // advancing with the clock, wrapping when they reach the walker. Where
        // `away` is `0` the frame is at the far edge and where it is `1` it has
        // come past him; on a working face, which has no depth to recede along,
        // the same run climbs the panel instead — see ``frame(away:size:depth:glow:fits:material:)``.
        for index in 0..<Self.frames {
            let offset = Double(index) / Double(Self.frames)
            let away = Self.wrapped(offset + chamberTime * Self.flows)
            // Design's own arc of light: nothing at the far edge, full at the
            // middle distance, nothing again as it passes him.
            let lit = sin(.pi * away) * Self.frameBrightest + Self.frameFloor
            marks.append(contentsOf: Self.frame(away: away,
                                                size: Self.frameSize
                                                    + Double(index) * Self.frameSizeStep,
                                                depth: depth,
                                                glow: lit * share,
                                                fits: fits,
                                                material: material))
        }

        // ── and they continue behind him ────────────────────────────────────
        //
        // Ten more, in the near stretch he had taken for the end of the room,
        // arriving only as the premise turns. There was no near wall either. They
        // run to the material's own edge and are clamped there, which is as far as
        // a surface can say *past him* — the rest of that sentence is the ground's
        // own station, going away under his feet.
        guard b > 0 else { return [surface: marks] }
        for index in 0..<Self.framesBehind {
            let along = Double(index) / Double(Self.framesBehind)
            let away = Self.wrapped(1 - along * 0.5 + chamberTime * Self.flows)
            let lit = b * sin(.pi * (1 - along)) * Self.behindBrightest
            marks.append(contentsOf: Self.frame(away: max(away, 1 - along * 0.5),
                                                size: Self.frameSize
                                                    + Double(index) * Self.frameSizeStep,
                                                depth: depth,
                                                glow: lit * share,
                                                fits: fits,
                                                material: material))
        }
        return [surface: marks]
    }

    /// How many marks one frame is made of.
    ///
    /// **A frame runs across the room and the vocabulary has no verb that does.**
    /// ``SurfaceVerb/furrow`` is a trough *across `u` running the length of `v`*,
    /// which on a working face is a vertical line and on a floor is a stripe
    /// pointing away — and twenty-four of them at one `u` are not twenty-four
    /// frames, they are one long flute. The first render of this room is exactly
    /// that: three pale vertical stripes where a procession should have been.
    ///
    /// So a frame is built the way ``PressRoom`` builds a bed: *"the vocabulary
    /// has no verb for a line — so a bed is made of the verb there is,
    /// overlapping along its own length."* Five impressions across, which at this
    /// room's own frame width is close enough spacing to read as one line and far
    /// enough that a line is not a bar.
    static let marksPerFrame = 5

    /// How wide one of those marks is, against the frame's own half-width: its
    /// own spacing and a fifth again, which is close enough to read as one line
    /// across the room and far enough that a line is not a bar.
    static let markShare: Double = 1.2 / Double(marksPerFrame - 1)

    /// One frame of the procession, as a line of marks across the room.
    ///
    /// They are **impressions** — pressed in and held, the roundest of the five —
    /// because what a frame does to the stone is stand in it, not travel through
    /// it. The procession's motion is the frames replacing one another, not any
    /// one of them ploughing across the floor.
    static func frame(away: Double, size: Double, depth: Double, glow: Double,
                      fits: Double, material: RoomMaterial) -> [SurfaceAction] {
        // **`away` is `v`, on every surface**, and the two were inverted until the
        // room was read against the mesh. A surface's `v` runs to `(v - 0.5) ·
        // extent` (``RoomScene/mesh(of:extent:orientation:resolution:)``): on a
        // floor or a canopy that is **z**, so the far edge is `v = 0` and the
        // walker's own standing point is a little past `v = 0.5`; on a working
        // face it is **y**, so the procession climbs the panel as `v` rises.
        // Either way a frame that has travelled further has a larger `v`.
        //
        // Read the other way round — and it was — the twenty-four receded from
        // behind the walker toward the far wall and wrapped there, and the ten
        // that continue *past him* landed on the far half of the floor on top of
        // the ones already there. *There was no near wall either*, which is the
        // whole content of this room's reversal, never arrived anywhere at all.
        let v = away
        let half = min(RoomReversal.answeringSpan,
                       material.reach(worldUnits: RingOne.inRoom(size)) * fits)
        let steps = Double(max(1, marksPerFrame - 1))
        let reach = RingOne.reach(half * markShare)
        return (0..<marksPerFrame).map { index in
            let across = -half + Double(index) / steps * half * 2
            return .impression(at: SurfaceCoordinate(u: 0.5 + across, v: v).clamped,
                               reach: reach, depth: depth, glow: glow)
        }
    }

    /// Design's own `((z % SPAN) + SPAN) % SPAN`, as a turn of the run.
    static func wrapped(_ x: Double) -> Double {
        let r = x.truncatingRemainder(dividingBy: 1)
        return r < 0 ? r + 1 : r
    }
}
