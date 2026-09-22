import Foundation

// MARK: - RING 4 · the fourteen Sampradāya Śaktis · the room at the scale of worlds
//
// Design's `cosmic(world, card, G)`, built on the Phase 3.1 spine. Its own header
// is the whole design:
//
//     RING 4 · COSMIC — her one gesture, at the scale of worlds.
//     The same movement repeated outward through fourteen shells until it is
//     weather.
//
// and its own `update(t)` says it once more, in a comment on the one line that
// matters: *"the SAME displacement, delayed outward — one movement becoming
// cosmic"*.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM A SAMPRADĀYA AND NOT ANY OTHER SISTER
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's own question is *could this room belong to any other Śakti?* Two
// answers, and the first one is sharper here than anywhere else in the instrument
// because **two built rooms already repeat her**.
//
// **The ring, against the two rooms nearest it.**
//
//   * A **Siddhi** is one capacity and the room performing it *again, later and
//     further off* — seven marks on **one line running away from the walker**
//     (``SiddhiRoom``). Echo in **depth**.
//   * An **Anaṅga** stands eight effects on **one ring of one radius**, each at
//     its own independent turn, around a centre where nothing has happened
//     (``BodilessRoom``). A ring of equals around an absence.
//   * A **Sampradāya** is neither. Her gesture leaves a centre that is the
//     brightest thing in the room and arrives at fourteen shells whose radius,
//     whose size and whose swing all grow outward — and the phase each shell is
//     at **is a function of how far out it stands**. That is not an echo and not
//     a ring: it is a **wave**, and the whole of it is visible at once, from
//     where it began to where it is arriving.
//
// Nothing else in the hundred and two lays a single motion out across a radius.
// The Siddhi's echoes are behind one another; the Anaṅga's eight are beside one
// another; hers are *the same gesture at fourteen moments of its own travel,
// standing at the fourteen distances it has reached.*
//
// **The seat.** Her tattva picks the physics the wave is made of, her position
// takes her turn of the fourteen, her bodily location decides which surface the
// coil is cut into and where in the frame it sits, her attribute acts at its
// centre, and her gem lights it. Fourteen sisters, fourteen different weathers.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE FOUR READINGS OF DESIGN THIS FILE MAKES, AND WHY
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · A shell is a closed figure around a centre, and a closed figure cannot
// be one mark — so the fourteen are stood at fourteen bearings of one turn.**
//
// Design's shell is `loop([[0, r], [r * 0.92, -r * 0.6], [-r * 0.92, -r * 0.6]])`
// — a triangle inscribed in radius `r`, fourteen of them nested, `r = 3.4 + 2.1i`.
// The vocabulary here has no annulus and no ring: the five verbs are all *local*,
// and a shell drawn as fourteen nested chains of marks is arithmetic the stone
// cannot carry. Fourteen marks along one radius need fourteen cells of the
// surface's own mesh to stand in — 0.22 of the whole surface, against a picture
// 0.20 of it wide — so a nest of fourteen concentric rings is not a small figure,
// it is an impossible one.
//
// What the fourteen *can* be is fourteen **bearings**, which is where the arc
// between neighbours does the separating instead of the radius. So each shell is
// the one place on itself the gesture has reached, and the fourteen wind once
// around her placement while the radius grows: **the fourteenth of a turn a shell
// stands at, and how far out it stands, and how far behind the gesture it is, are
// one number.** The wave travels around and outward at once, and what the walker
// is looking at is the whole of one gesture, laid out from its centre to the wall.
//
// **2 · "Delayed outward" is read against her own kernel's turn, not in
// seconds.** Design writes `displace(kind, t - i * 0.42, ph, …)` — a delay in its
// own three.js clock. Carried literally that is a defect twice over: the kernel's
// terms turn at between 0.03 and 0.6 radians a second, so on the slow kinds
// thirteen shells' worth of delay is a fortieth of a turn and the fourteen move as
// one rigid body; and it is the same trap ``OuterRings/spread(index:of:kind:)``
// exists for, arriving through the time axis instead of the phase axis.
//
// So the delay is **one turn of her own kernel, laid out across the fourteen**,
// read off ``OuterRings/spread(index:of:kind:)`` and subtracted rather than added.
// Design's `i / n` where his number says something, a quarter turn where a half
// turn would fold it, and a *lag* because the outer shell is doing what the inner
// shell did — which is the difference between a wave going out and a wave coming
// in. ``BodilessRoom`` adds the same number, because a ring of independents has no
// direction to go in; this one subtracts it, and the sign is the archetype.
//
// **3 · The swing is a fraction of the coil, and that is Design's own ratio
// rather than Design's own number.** Design's amplitude is `1 + i * 0.22`, a
// length in a room 26 units wide; brought into a picture 1.3 units wide as a bare
// length it is four hundredths of a scene unit, which is a wave that does not
// move. So it is carried as the fraction of Design's own outermost shell it is —
// a thirtieth of the coil at the centre, an eighth of it at the wall — and the
// gesture grows outward on every surface, which is *"one movement becoming
// cosmic"*.
//
// And it is what puts the **verb** in the right place without anything assigning
// one: ``RoomInscription/verb(for:previous:)`` reads a travelling mark as a furrow
// and a bearing-down one as a compaction, and a shell's travel grows with its
// radius. So the gesture leaves the centre as something bearing on the stone and
// arrives at the wall as something drawn across it. Nobody wrote that down.
//
// **4 · Design's figure is drawn standing up, so the general axis rule is the
// right one here.** The triangles stand in `x`–`y` and are stacked along `z`
// (`tri.position.set(0, y, -2 - i * 1.5)`), which is exactly what
// ``RoomUnits/axes(of:)`` already says: on a working face Design's rise runs up
// the stone and `z` runs into it; on a floor or a canopy the coil lies down and
// the recession goes into the material. ``BodilessRoom`` had to override that rule
// because its ring is drawn *lying down*; this room must not, and the difference
// between the two is a fact about the two figures rather than a preference.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE THING THE EXPANSION HAPPENS INSIDE OF
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's own thread records the defect at this ring by name: the Ring 4 rooms
// **had no wall**, the shells expanded past the frame, and the room went black at
// depth. Design's own answer is the `SphereGeometry(26)` its later pass adds —
// but its shells reach 30.7, so the fix is a wall the gesture still leaves.
//
// Here it is closed in three places, and none of them is a clamp:
//
//   * **The figure is asked for the coil it will have grown into**, not the one
//     it rests at (``figure(on:bodyAltitude:)`` passes ``widestGrowth``), so what
//     ``OuterRings/Figure`` fits into the picture is the *end* of the stay. A
//     figure that fitted at rest and burst its frame at the turn is the same
//     defect arriving ninety seconds later.
//   * **The coil is read off the picture rather than off Design's radii.** The
//     outermost shell stands where the picture ends and the innermost at Design's
//     own ratio inside it, floored at what the stone can carry
//     (``coil(figure:material:)``). Nothing is ever clamped onto the edge of the
//     material, and the suite asserts it at every moment of every stay.
//   * **And the enclosure answers by leaving.** ``HomeBecoming/archetype(_:)``
//     gives this archetype `premise: .face, answer: .wall, takes: -0.52` — so what
//     the expansion arrives at is a surface going the way the gesture is going,
//     and *"the gesture is at the scale of the walls"* is the room's own stone
//     standing further out rather than a mark piled against it. A wall is never
//     marked here (``RoomReversal``), and this room does not ask it to be.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE CENTRE DOES — *"the gesture had no centre to leave"*
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's heart is a glow sprite at the middle of the room whose whole update is
// `heart.scale.setScalar(1 + 0.2 * sin(t * 0.2) - b * 0.34)`: it beats while the
// eye settles, and it **empties** as the premise turns. `0.34` is the number
// ``HomeBecoming`` reads as this archetype's `yields`, so the centre's emptying
// and the working face's yielding are the same fact and are not written down
// twice.
//
// **The centre is the smallest thing in the room and it loses its light, not its
// footing.** Design's heart is 2.5 against an outer shell of 30.7 — eight per cent
// — and brought into the picture that is under one cell of the surface's own mesh
// on every surface, so it rests at ``RoomInscription/narrowestMark`` and cannot
// withdraw below it. It must not: ``RingOne`` settled that a mark giving the room
// up withdraws by its reach and never by its depth, *"because a mark that grew
// shallower would stop being seen while it was still there"*, and a mark that
// shrank under the mesh cell would not be faint, it would be **absent** — which is
// a different sentence, and it is ``BodilessRoom``'s.
//
// So what empties is the light. At the first adaptation the centre is the
// brightest mark in her room and the shells are the dimmest; past the second, the
// shells carry Design's `(1 + b * 0.8)` and the centre carries its own scale, and
// **the innermost shell is brighter than the centre it came from**. The light does
// not go out; it moves outward, which is the only thing the gesture was ever
// doing. The centre had nothing to leave because it was never where the gesture
// was.
//
// That is also the exact opposite of the ring one seat below it, and deliberately:
// an Anaṅga's centre is **dark from the first instant** and never a source, and a
// Sampradāya's centre is the source and empties. Two rooms about a middle, saying
// opposite things.
struct CosmicRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 53–66. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the fourteen — Design's `(card.pos % 14) / 14`.
    let phase: Double

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
    }

    /// The fourth āvaraṇa. Position decides who stands in it; nothing here
    /// consults a name.
    static let ring = 4

    // MARK: - Design's own numbers

    /// Fourteen. Design's `for (let i = 0; i < 14; i++)`, and the same fourteen
    /// her phase divisor counts (``HomeGrammar/phaseDivisor(for:)``).
    static let shells = 14

    /// Design's radii: `const r = 3.4 + i * 2.1`.
    static let innerRadius: Double = 3.4
    static let radiusStep: Double = 2.1

    /// The furthest shell — Design's own `3.4 + 13 * 2.1`.
    static var outerRadius: Double { innerRadius + radiusStep * Double(shells - 1) }

    /// How much wider the outermost shell stands than the innermost, in Design's
    /// own room. The coil keeps this ratio wherever the picture and the stone let
    /// it (``coil(figure:material:)``).
    static var radiusRatio: Double { outerRadius / innerRadius }

    /// The centre: Design's `sprite(glow('cs' + world.n, …), G.c, 5, 0.8)`, whose
    /// 5 is the sprite's whole span — so its reach is half of it.
    static let heartSpan: Double = 5

    /// Design's amplitude growth across the shells — `displace(kind, …, 1 + i *
    /// 0.22)`, read against its own radius (header, reading 3).
    static let amplitudeStep: Double = 0.22
    static let amplitudeBase: Double = 1

    /// Design's own opacity on a shell:
    /// `(0.14 + 0.4 * k) * (1 - i / 20) * (1 + b * 0.8)`.
    static let shellFloor: Double = 0.14
    static let settlingLift: Double = 0.4
    static let shellFade: Double = 20
    static let shellBrightens: Double = 0.8

    /// Design's growth on a shell as the premise turns —
    /// `s.scale.setScalar(1 + b * (0.22 + i * 0.03))`. Each shell's own number,
    /// so the outer shells take the room over further than the inner ones.
    static let growthBase: Double = 0.22
    static let growthStep: Double = 0.03

    /// Design's own centre: `sprite(…, 0.8)` and
    /// `heart.scale.setScalar(1 + 0.2 * sin(t * 0.2) - b * 0.34)`. The `0.34` is
    /// not here — it is ``HomeBecoming/archetype(_:)``'s `yields`, read through
    /// ``heartScale(at:deep:)`` so the centre's emptying and the working face's
    /// yielding cannot drift apart.
    static let heartGlow: Double = 0.8
    static let heartPulse: Double = 0.2
    static let heartRate: Double = 0.2

    // MARK: - Where the room's marks stand in the list it makes

    /// The centre is made first, because that is where the gesture starts.
    static let heartIndex = 0
    /// Shell `i`, among the room's own marks.
    static func shellIndex(_ index: Int) -> Int { index + 1 }
    /// Fourteen shells and the centre they left.
    static var markCount: Int { shells + 1 }

    // MARK: - The coil

    /// Half the angle between two neighbouring shells, as a chord of a unit
    /// circle: `sin(π / n)`. How much room one shell has on its own arc, and
    /// therefore how large its mark may be before it is writing on the shell
    /// beside it.
    static var arc: Double { sin(.pi / Double(shells)) }

    /// **How far shell `index` takes the room over past the second adaptation.**
    ///
    /// Design's own per-shell number, `0.22 + 0.03 * i`, at the instrument's own
    /// saturating fraction (``RoomReversal/answeringFraction(takes:)``) — which is
    /// the law that already holds every answering surface short of the walker.
    /// Monotone outward: the shell nearest the wall goes furthest, which is the
    /// gesture becoming weather.
    static func growth(of index: Int) -> Double {
        RoomReversal.answeringFraction(takes: growthBase + growthStep * Double(index))
    }

    /// The most any shell grows — what the figure has to be fitted for, rather
    /// than the coil it rests at.
    static var widestGrowth: Double { growth(of: shells - 1) }

    /// **How far a shell swings, as a fraction of the coil's own reach** —
    /// Design's `1 + 0.22 i` read against his own outermost shell, so it runs from
    /// a thirtieth of the coil at the centre to an eighth of it at the wall.
    ///
    /// **A fraction, and read against the coil rather than against the shell's own
    /// radius.** Against the shell's own radius it would be Design's other ratio,
    /// 0.29 falling to 0.13 — true in Design's room, where the coil opens ninefold,
    /// and false on a floor, where one cell of the mesh is four times the thing it
    /// is on a face and the coil can only open twofold. There the gesture would
    /// *shrink* as it travelled outward, which is this archetype backwards. Read
    /// against the coil it grows on every surface, which is what *"one movement
    /// becoming cosmic"* says, and on a working face it comes out at Design's own
    /// 0.26 of the innermost shell's radius anyway.
    static func swing(of index: Int) -> Double {
        guard outerRadius > 0 else { return 0 }
        return (amplitudeBase + amplitudeStep * Double(index)) / outerRadius
    }

    /// The coil the fourteen stand on, in the surface's own coordinates.
    struct Coil: Equatable {
        /// Where the innermost shell stands.
        let inner: Double
        /// Where the outermost stands, at rest.
        let outer: Double

        /// Shell `index` of `count`, linear between the two — Design's own
        /// `3.4 + 2.1 i` is linear, and so is this.
        func radius(of index: Int, of count: Int) -> Double {
            guard count > 1 else { return inner }
            let step = (outer - inner) / Double(count - 1)
            return inner + step * Double(min(max(0, index), count - 1))
        }
    }

    /// **The whole figure, brought into the picture it will have grown into.**
    ///
    /// `spread` is the coil's **radius** and not its diameter, because
    /// ``OuterRings/Figure`` measures what is wanted against the picture's own
    /// *half*-width — the furthest the figure's outer edge may stand from its
    /// centre. And both it and the mark allowance carry ``widestGrowth``, so the
    /// coil at the end of the stay is what was fitted.
    func figure(on material: RoomMaterial, bodyAltitude: Double) -> OuterRings.Figure {
        OuterRings.Figure(ring: Self.ring,
                          spread: Self.outerRadius * (1 + Self.widestGrowth),
                          part: Self.outerRadius * 2 * Self.arc * (1 + Self.widestGrowth),
                          on: material,
                          bodyAltitude: bodyAltitude)
    }

    /// **Where the fourteen stand, and why it is not simply Design's radii.**
    ///
    /// Design's coil runs 3.4 to 30.7 in a room whose body is 8 — the outermost
    /// shell is nearly four body-heights out, which is the wall the thread records
    /// this ring's rooms expanding past. So what is carried is the **ratio** and
    /// not the lengths:
    ///
    ///   * the **outermost** shell stands where the picture ends, which is what
    ///     ``figure(on:bodyAltitude:)`` has already fitted with its growth counted;
    ///   * the **innermost** stands Design's own ratio inside it, and never nearer
    ///     the centre than one cell of the surface's own mesh — a shell inside its
    ///     own minimum mark is a shell standing on the middle of the room rather
    ///     than around it;
    ///   * and the outermost is at least one cell beyond the innermost, because
    ///     **two shells inside one cell are one shell**, and a coil that does not
    ///     expand is not this archetype.
    ///
    /// The floor is what binds on a floor and a canopy, which are four
    /// body-heights across and whose one cell is therefore four times the thing it
    /// is on a working face: there the coil opens less, and the expansion is
    /// carried by the marks' own growth and by their swing rather than by the
    /// radius. That is the coarse stone saying what it can hold, and it is the
    /// same finding ``RoomInscription/narrowestMark`` is.
    func coil(figure: OuterRings.Figure, material: RoomMaterial) -> Coil {
        let picture = material.reach(worldUnits: figure.length(Self.outerRadius))
        let inner = max(picture / Self.radiusRatio, OuterRings.narrowestMark)
        return Coil(inner: inner,
                    outer: max(picture, inner + OuterRings.narrowestMark))
    }

    /// How large shell `index`'s mark is at rest, in the surface's own
    /// coordinates: **half the arc it stands on**, so a shell's mark closes before
    /// the shell beside it — and never finer than the stone can carry, nor wider
    /// than one mark of an outer room may open (``OuterRings/reach(_:)``).
    func reach(of index: Int, coil: Coil) -> Double {
        OuterRings.reach(coil.radius(of: index, of: Self.shells) * Self.arc)
    }

    /// How far shell `index` travels, in scene units: the coil's own reach times
    /// Design's own fraction for that shell (header, reading 3). Strictly
    /// increasing outward, on every surface.
    func travel(of index: Int, coil: Coil, material: RoomMaterial) -> Double {
        coil.outer * material.span * Self.swing(of: index)
    }

    /// Where shell `index` stands on its own turn, and how far behind the gesture
    /// it is — one number, because in this room they are the same number.
    ///
    /// Read off ``OuterRings/spread(index:of:kind:)`` and **subtracted**: the
    /// outer shell is doing what the inner shell did. See the header, reading 2.
    func lag(of index: Int) -> Double {
        OuterRings.spread(index: index, of: Self.shells, kind: physics)
    }

    /// The bearing shell `index` stands on — its own fourteenth of one turn.
    static func bearing(of index: Int) -> Double {
        Double(index) / Double(shells) * 2 * .pi
    }

    // MARK: - What the premise becomes

    /// **The gesture had no centre to leave.** Design's own deep sentence, and its
    /// two numbers: `heart.scale.setScalar(… - b * 0.34)` — the centre empties —
    /// and `s.scale.setScalar(1 + b * (0.22 + i * 0.03))` over the shells, until
    /// the gesture is at the scale of the walls.
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which is where the ten archetype
    /// reversals are, so this room and the grammar agree about the Sampradāya's
    /// turn by construction rather than by two people writing down the same
    /// numbers. Its answer is the **enclosure**, and an enclosure answers by
    /// moving rather than by being marked — which is why nothing below adds a
    /// mark for the reversal and the suite asserts that it does not.
    var becoming: HomeBecoming { .archetype(.cosmic) }

    /// The centre, at a moment of the stay: Design's
    /// `1 + 0.2 * sin(t * 0.2) - b * 0.34`, with the beat carrying **her** turn of
    /// the fourteen so that no two of the fourteen centres beat alike, and with
    /// the emptying read off ``becoming`` rather than typed.
    func heartScale(at chamberTime: TimeInterval, deep: Double) -> Double {
        max(0, 1
            + Self.heartPulse * sin(chamberTime * Self.heartRate + phase * 2 * .pi)
            - deep * becoming.yields)
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        let figure = figure(on: material, bodyAltitude: stage.placement.bodyAltitude)
        let coil = coil(figure: figure, material: material)
        let share = OuterRings.lightShare(of: Self.markCount)
        let widest = reach(of: Self.shells - 1, coil: coil)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.markCount)

        // ── the centre the gesture left ─────────────────────────────────────
        //
        // The brightest mark in her room while the eye settles, and the smallest:
        // Design's own eight per cent of the outer shell is under one cell of the
        // surface's mesh, so it rests at the stone's own minimum and stays there.
        // What it loses as the premise turns is its **light** — see the header.
        //
        // It does not travel, so ``RoomInscription/verb(for:previous:)`` reads it
        // as a compaction and nothing here says so; and its size is held at full,
        // because a mark that is giving the room up withdraws by its reach and
        // never by its depth.
        let centre = place(index: Self.heartIndex, at: chamberTime,
                           figure: figure, stage: stage, material: material)
        let centreBefore = place(index: Self.heartIndex, at: chamberTime - OuterRings.readOver,
                                 figure: figure, stage: stage, material: material)
        let beat = heartScale(at: chamberTime, deep: b)
        marks.append(OuterRings.mark(centre, from: centreBefore,
                                     reach: OuterRings.reach(
                                        material.reach(worldUnits: figure.length(Self.heartSpan / 2))
                                            * beat),
                                     size: 1,
                                     travel: max(travel(of: 0, coil: coil, material: material),
                                                 0.0001),
                                     glow: Self.heartGlow * beat * share,
                                     material: material))

        // ── and the gesture, at the fourteen distances it has reached ────────
        //
        // One movement, laid out across one turn of her own kernel: shell `i`
        // stands a fourteenth of the turn further round, a fourteenth of the coil
        // further out, and a fourteenth of a turn further behind. Its mark grows
        // with its arc, its swing is Design's own fraction of its own radius, and
        // its light falls outward exactly as Design's `(1 - i / 20)` does.
        for index in 0..<Self.shells {
            let here = place(index: Self.shellIndex(index), at: chamberTime,
                             figure: figure, stage: stage, material: material)
            let before = place(index: Self.shellIndex(index),
                               at: chamberTime - OuterRings.readOver,
                               figure: figure, stage: stage, material: material)
            let rest = reach(of: index, coil: coil)
            // **The growth is applied after the figure's own floor and never under
            // it** (``OuterRings/reach(_:)``): on a floor four body-heights across
            // every shell's mark is already at one cell of the mesh, and a growth
            // folded in before the floor would be swallowed by it and the coil
            // would end the stay exactly the size it began.
            let opens = min(OuterRings.widestMark, rest * (1 + b * Self.growth(of: index)))
            marks.append(OuterRings.mark(here, from: before,
                                         reach: opens,
                                         size: widest > 0 ? rest / widest : 1,
                                         travel: travel(of: index, coil: coil, material: material),
                                         glow: (Self.shellFloor + Self.settlingLift * k)
                                             * (1 - Double(index) / Self.shellFade)
                                             * (1 + b * Self.shellBrightens) * share,
                                         material: material))
        }

        // …and the archetype's own reversal on top, which for a room whose answer
        // is the enclosure is nothing in material: a wall is not marked, it moves,
        // and it moves through ``stations(at:stage:)``.
        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - Where one part of the room's work stands

    /// Where one of the room's marks stands at one moment, **before the material's
    /// own edge is applied** — two numbers along the surface and one into it.
    ///
    /// At ``heartIndex`` it is the centre, which carries no bearing, no radius and
    /// no displacement: it is the place the gesture started from, and it is the
    /// same place at every instant of the stay.
    ///
    /// Everywhere else it is shell `index - 1`: Design's own placement on its
    /// nested figure — a bearing and a radius — with her physics on top of it at
    /// that shell's own lag.
    ///
    /// **Which of Design's three axes runs along the stone and which runs into it
    /// is ``RoomUnits/axes(of:)``'s**, and here the general rule is the right one:
    /// Design draws this figure standing up, in `x`–`y`, receding along `z`
    /// (header, reading 4). Which way *into* is, is the instrument's own
    /// ``RoomUnits/SurfaceAxes`` `outward`, so rising off a floor and rising off a
    /// ceiling are the same fact seen from two sides.
    func station(index: Int, at chamberTime: TimeInterval,
                 figure: OuterRings.Figure, stage: RoomStage,
                 material: RoomMaterial) -> (u: Double, v: Double, into: Double) {
        let centre = stage.placement.coordinate
        let shell = index - Self.shellIndex(0)
        guard shell >= 0, shell < Self.shells else { return (centre.u, centre.v, 0) }

        let axes = RoomUnits.axes(of: material.surface)
        let coil = coil(figure: figure, material: material)
        let radius = coil.radius(of: shell, of: Self.shells)
        let bearing = Self.bearing(of: shell)

        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime,
            phase: phase - lag(of: shell),
            amplitude: travel(of: shell, coil: coil, material: material))

        return (centre.u + radius * cos(bearing)
                    + material.reach(worldUnits: axes.across(drift)),
                centre.v + radius * sin(bearing)
                    + material.reach(worldUnits: axes.along(drift)),
                axes.into(drift))
    }

    /// The same, on the material — which is where a mark has to be.
    func place(index: Int, at chamberTime: TimeInterval,
               figure: OuterRings.Figure, stage: RoomStage,
               material: RoomMaterial) -> OuterRings.Place {
        let station = station(index: index, at: chamberTime,
                              figure: figure, stage: stage, material: material)
        return OuterRings.Place(at: SurfaceCoordinate(u: station.u, v: station.v).clamped,
                                into: station.into)
    }
}
