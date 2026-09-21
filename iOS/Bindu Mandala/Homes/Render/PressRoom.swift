import Foundation

// MARK: - GARIMĀ · khaḍgamālā position 4 · the room that presses
//
// Design's `chamberPress`, built on the Phase 3.1 spine. Ruling 10 accepts the
// authored Gate: this room is **hand-built** and reached through the authored map
// by position, not produced by the grammar.
//
// Its premise, in Design's own words: *"Her ceiling descends the whole time you
// are in it and the floor thickens into strata beneath you."* And its reversal,
// which Design also wrote out, in the file, as a comment on the line that does it:
//
//     the weight was never above you. It is what you are standing on,
//     and it has been holding you the whole time.
//
// **So the reversal is not the press undone.** Nothing is given back. The strata
// stay compacted — what the pressing *made* is kept — and what changes is that
// the bedding beneath him rises into a plinth and carries him, while the mass
// lifts away. ``HomeBecoming`` is handed exactly that: the canopy yields, and the
// ground it made takes the work over.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE BINDING CONDITION, AND THE ONE PLACE THE SPIKE BROKE IT
// ─────────────────────────────────────────────────────────────────────────────
//
// `Views/Spike/GarimaSceneKitRoom.swift` is the proven treatment of this room and
// was read in full. One thing in it does **not** come across, and it is the exact
// failure the renderer ruling was written to prevent: the spike mounts the palm's
// mark as a cylinder with its own emissive material, lying on the floor — a
// free-standing lit solid, which is the props cupboard in one object. Design's
// three.js does the same, with `emissiveIntensity: 1.4` on a cylinder.
//
// Here the press is what it says it is: a **compaction** in the ground, driven
// down and densified with almost no relief, whose light is the ground's own
// emission and is therefore multiplied by how far the ground actually moved
// (``RoomMaterial/emission(at:)``). There is nothing to pick up because there is
// no thing. `testNeitherGateRoomMountsASolidInHerLayer` holds it.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY HER MARK IS LOW IN THE FRAME, AND WHY THAT IS NOT A CAMERA
// ─────────────────────────────────────────────────────────────────────────────
//
// Her bodily location is *"Mūlādhāra / sit-bones / soles"*, which Design's zone
// table reads at 0.94 — the lowest altitude it gives. ``RoomUnits`` puts the
// floor where the soles' extreme resolves to, so her working surface is the
// ground and her mark is in it. Nothing in this file touches the camera, and
// `testGarimasMarkSitsLowInTheFrame` reads the rendered frame rather than the
// intention.
struct PressRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// **How much of the gap between the mass and the walker it closes.**
    ///
    /// Design's room is not body-scaled — its slab starts 11 above the origin with
    /// the eye at about 2.4, and `slab.position.y = 11 - k * 7.4` brings it down
    /// 7.4 of the 8.6 that separated them. What carries across is not the 7.4; it
    /// is the *proportion*, because the proportion is what the walker feels. The
    /// mass closes six sevenths of its own distance to him and stops short of him
    /// — which is the rule ``RoomReversal`` already holds every surface to.
    static let closes: Double = 7.4 / 8.6

    /// **How much of that descent it gives back once the premise turns.**
    /// Design's `+ b * 5.2` against the same `k * 7.4`.
    static let liftsBack: Double = 5.2 / 7.4

    /// **How far the bedding thickens.** Design's
    /// `groundMat.displacementScale = 0.5 + k * 1.9`, as a multiple of its resting
    /// half: the beds end up nearly five times the relief they began with.
    static let thickens: Double = 1.9 / 0.5

    /// **How much the pressing goes on making after the turn** — `… + b * 1.4` on
    /// the same base — and how far the mark itself grows,
    /// `press.scale.setScalar(1 + b * 1.8)`.
    static let keepsMaking: Double = 1.4 / 0.5
    static let markGrows: Double = 1.8

    /// How much deeper the crater is than the beds around it. This is where the
    /// weight actually landed.
    static let craterDeepens: Double = 1.9

    /// How many beds the room's own depth is bedded into.
    ///
    /// Eleven, and it is a count of *this* room rather than a copy of Design's
    /// thirty-two-pixel canvas: across four body-heights of floor that is one bed
    /// every two fifths of a body, which is what makes a bed read as a bed at the
    /// near edge instead of as a texture.
    static let beds = 11

    /// How many compactions make one bed.
    ///
    /// A bed is a line of stone driven down, and the vocabulary has no verb for a
    /// line — so a bed is made of the verb there is, overlapping along its own
    /// length. This is the constraint doing its job: the five verbs are not
    /// extended to suit the room, the room is built out of the five verbs.
    ///
    /// Twenty-one, with a reach under half the gap between beds, and both numbers
    /// answer the same question from opposite sides. A compaction is round, so it
    /// spreads across the beds as readily as along them: reach far enough to make
    /// a continuous line and the beds merge into one another until the floor has
    /// simply sunk — which is a floor that has sunk, not a floor bedded into
    /// strata. So the reach is set by the *gap between beds* and the count by
    /// what it then takes to keep the line continuous.
    static let pressesPerBed = 21

    // MARK: - What the premise becomes

    /// The canopy carried the weight; the ground it made takes it over.
    let becoming = HomeBecoming(premise: .canopy, answer: .ground,
                                yields: PressRoom.liftsBack, takes: PressRoom.markGrows)

    // MARK: - Where the room's own surfaces stand

    func stations(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: Double] {
        var out = RoomReversal.stations(becoming, deep: stage.deep,
                                        bodyAltitude: stage.placement.bodyAltitude)
        // The press itself. Positive is toward him, so the mass coming down is a
        // positive station on the canopy — and the reversal's own negative term,
        // already in `out`, is what lifts it away again. One line, two adaptations,
        // and the second one genuinely reverses the first rather than continuing it.
        let gap = RoomReversal.clearance(of: .canopy,
                                         bodyAltitude: stage.placement.bodyAltitude)
        out[.canopy, default: 0] += gap * Self.closes * stage.settling
        return out
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        guard let ground = stage.materials[.ground] else { return [:] }
        let k = stage.settling, b = stage.deep
        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.beds * Self.pressesPerBed + 3)

        // ── the floor thickening into strata ────────────────────────────────
        //
        // A bed is stone that was driven down and densified, which is the
        // compaction's own definition. Each keeps its own amplitude, seeded off her
        // khaḍgamālā position, so the bedding is hers and is the same bedding on
        // every launch — the principle `Atmosphere` jitters her hue by.
        //
        // The beds go on deepening past the turn (`keepsMaking`). They are not
        // undone, because the reversal is what the pressing made.
        //
        // Design's three numbers are a *ratio* — 0.5 at rest, 2.4 settled, 3.8
        // made — and it is the ratio that carries, not the units: a three.js
        // displacement scale over a normalised map says nothing about how deep a
        // bed is in a room one body tall. So the whole ramp is normalised against
        // ``RoomInscription/markDepth``, which is the instrument's own answer to
        // how deep anything may go — *"the room is not a quarry"*. Fully made
        // bedding is exactly one mark deep, and Design's ratio is exact at every
        // point along the way.
        let made = 1 + Self.thickens + Self.keepsMaking
        let bedDepth = RoomInscription.markDepth
            * (1 + Self.thickens * k + Self.keepsMaking * b) / made
        // Under half the gap between beds, so two beds never become one.
        let bedReach = 0.45 / Double(Self.beds)
        for bed in 0..<Self.beds {
            let v = (Double(bed) + 0.5) / Double(Self.beds)
            let amplitude = 0.35 + Self.grain(ground.seed, bed) * 0.65
            for step in 0..<Self.pressesPerBed {
                let u = (Double(step) + 0.5) / Double(Self.pressesPerBed)
                marks.append(.compaction(at: SurfaceCoordinate(u: u, v: v),
                                         reach: bedReach,
                                         depth: bedDepth * amplitude))
            }
        }

        // ── the mark: one palm-press, set into the ground and still glowing ──
        //
        // Deeper than the beds around it, because this is where the weight
        // actually landed. Its light is the ground's own, so it exists exactly as
        // far as the ground moved and no further.
        let at = stage.placement.coordinate
        let pressReach = ground.reach(worldUnits: stage.placement.footprint)
        marks.append(.compaction(at: at, reach: pressReach, depth: bedDepth * Self.craterDeepens))

        // …and the press still burning in the middle of it.
        //
        // **The crater is wide and the light in it is not**, and the difference is
        // Design's. Her mount opens the whole inscription out through the second
        // adaptation — the attribute stops being an object and becomes the room —
        // while what she *lights* is one press, grown by `press.scale.setScalar(1
        // + b * 1.8)` and no more. Lighting the crater instead came back as a pale
        // structureless wash over the lower half of the frame with every bed she
        // had made lost inside it: a compaction is flat-bottomed, so its emission
        // is full strength right out to its reach, and at her settled footprint
        // that is a fifth of the floor at once.
        let resting = RoomUnits.placement(bodyAltitude: stage.placement.bodyAltitude,
                                          chamberTime: 0).footprint
        let burning = ground.reach(worldUnits: resting) * (1 + Self.markGrows * b)

        // And as it widens it **dims**, by Design's own mount fade — the same
        // `1 - b * 0.55` every attribute in the instrument fades by, for the same
        // reason she wrote it: *"the attribute stops being a bright thing and
        // becomes part of what the room is made of."* Without it, the press grows
        // nearly threefold and brightens at once, at exactly the moment the mark
        // is nearest the eye, and it stops being a press and becomes the frame.
        let fade = HomeAttribute.mount(bodyAltitude: stage.placement.bodyAltitude,
                                       chamberTime: chamberTime).opacityFactor
        marks.append(.compaction(at: at,
                                 reach: burning,
                                 depth: bedDepth * 0.5,
                                 glow: (0.34 + 0.22 * k + 0.44 * b) * fade))

        // ── and what the pressing made, once the premise turns ───────────────
        //
        // The spike raised the ground under him with two terms: a mound under the
        // mark and a broad rise under the whole floor, *"or the reversal reads as
        // the room getting vaguely higher instead of as a thing you are standing
        // on."* Only the mound is authored here, and the reason is that the broad
        // rise already exists: the ground's own **station** carries the whole floor
        // toward him, which is the same fact said once instead of twice. Written
        // both ways the broad swell spreads past the beds and cancels them, and the
        // strata the room exists to keep stop being kept.
        //
        // How deep it stands is **read off the room rather than chosen**: the
        // plinth fills the hollow the pressing actually made at that point — every
        // bed and the crater together, measured, not estimated — and then stands
        // proud of it. So it cannot drift if the bedding is ever retuned, and the
        // thing he ends up standing on is literally what was pressed into the
        // floor, turned out.
        //
        // What it stands proud by is two marks' worth and both are named. One is
        // Design's own growth of the press, `press.scale.setScalar(1 + b * 1.8)`.
        // The other is one whole mark, because **her attribute is still working in
        // the top of the plinth**: the room's mechanism acts first and her
        // attribute acts into whatever the room turned out to be, so the palm goes
        // on pressing into the plinth after it has risen. Without that mark's
        // worth the two cancel and her mark ends the stay a shallow hollow — which
        // is the room having reversed everything except the one thing he is
        // looking at.
        if b > 0 {
            let hollow = marks.reduce(0.0) { $0 + max(0, -$1.relief(at: at)) }
            let proud = RoomInscription.markDepth * (1 + Self.markGrows)
            //
            // **And it does not glow.** The light in this room is the press —
            // Design lights the mark and nothing else, `emissiveIntensity = 1.4 +
            // b * 3.4`, and the spike's plinth carries no emission at all. Lit,
            // the plinth came out as a pale featureless mass filling the lower
            // half of the frame with the strata lost behind it; unlit, it is stone
            // with a hollow in the top of it that is still burning. That is the
            // difference between a room and a light, and only looking at it says
            // which one you have.
            marks.append(.swell(at: at,
                                reach: pressReach,
                                depth: (hollow + proud) * b))
        }
        return [.ground: marks]
    }

    /// One bed's own amplitude, deterministic in her position. The same hash the
    /// spike's strata used and `Atmosphere` jitters her hue by — her room is her
    /// room on every launch and on every machine.
    static func grain(_ seed: Int, _ index: Int) -> Double {
        let mixed = (index &+ seed &* 977) &* 2_654_435_761
        return Double((mixed % 1_000 + 1_000) % 1_000) / 1_000
    }
}
