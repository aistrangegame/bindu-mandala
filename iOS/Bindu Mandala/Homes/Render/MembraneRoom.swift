import Foundation

// MARK: - SARVA-YONI · khaḍgamālā position 27 · no door · you were always inside
//
// Design's `chamberMembrane`, built on the Phase 3.1 spine. Authored by hand,
// reached through ``HomeRooms/authored`` **by position**, and accepted under
// Ruling 10 without a grammar-only proof.
//
// Design's two sentences are the room:
//
//     no door · you were always inside
//     source within source · it was never one womb
//
// Sarva-Yoni is *Source* — `Yoni`, the source-aperture, felt at the lower belly.
// Note the name again: Design's own `BY_NAME` keys this room as `Sarvayoni`,
// which matches no card in its own data, so in Design's shipped Axis it is never
// reached and its harness cannot see it happen. Keyed by khaḍgamālā position it
// cannot be misspelled.
//
// ─────────────────────────────────────────────────────────────────────────────
// ANICONIC, AND NOT NARROWLY
// ─────────────────────────────────────────────────────────────────────────────
//
// This is a womb, and law 4 forbids figural imagery. Design resolves it before
// the port has to: `chamberMembrane` builds a **lathe** — a surface of
// revolution, rotationally symmetric about the room's own axis — with a
// transmissive material, eight veins running down its inside, and one aperture.
// Nothing about it is a body; it is a vessel, and a vessel is a shape.
//
// The port keeps the rotational symmetry as the thing the aniconic check holds
// onto: the eight veins stand at Design's own `(i / 8) * 2π`, equally spaced on
// one circle, and the three vessels beyond are concentric. A form with eight-fold
// symmetry about the walker is not a body part, and
// `testNothingInTheTenReadsAsABodyPart` says so by measuring the spacing rather
// than by trusting the word.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE THING THIS ROOM DOES THAT NO OTHER ROOM DOES: THE ENCLOSURE BREATHES
// ─────────────────────────────────────────────────────────────────────────────
//
// Ring 1 already holds three enclosures and each is a different fact about one:
// Aṇimā's closes in (``ContractRoom``), Mahimā's never arrives (``EndlessRoom``),
// Laghimā's is there for the whole first adaptation and leaves at the turn
// (``ReleaseRoom``). This is the fourth and it is none of them: Design's
// `vessel.scale.set(1 + br * 0.032, 1 - br * 0.02, 1 + br * 0.032)` on
// `br = sin(t * 0.28)` — the enclosure **breathes**, at every instant of the
// stay, widening as it shortens. That is *"you were always inside"* said as a
// station rather than as a word: a room that is breathing around you is one you
// are inside of, and it never once stops or leaves.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE PREMISE BECOMES: THE MEMBRANE CLEARS
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's own reversal is a **material** change, which is the only one of the
// eight authored rooms where that is true: `mat.thickness = (3.4 + br * 0.7) *
// (1 - b * 0.72)` and `mat.attenuationDistance = 2.6 + br * 0.35 + b * 5.4`. The
// membrane he is inside stops being opaque, and past it are three more vessels
// — `NEST = [1.55, 2.3, 3.2]`, at opacity zero until the second adaptation.
//
// Carried into the two registers a reversal has: the enclosure **yields** by
// Design's own 0.72, and the **source-aperture** takes the room over —
// `ap.scale.setScalar(0.7 + 0.4 * k + b * 0.5)` — with the three vessels beyond
// opening concentrically around it as rings in the same material. *It was never
// one womb* is three further sources standing outside the one he took for the
// only one, and a ring of material is the honest way to say "further out" in a
// room whose beyond is not a place the walker can be shown.
struct MembraneRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// The vessel's own breath: Design's `br = Math.sin(t * 0.28)`, at
    /// `+3.2%` across and `-2%` in height.
    static let breathRate: Double = 0.28
    static let widens: Double = 0.032
    static let shortens: Double = 0.02

    /// **How completely the membrane clears.** Design's
    /// `mat.thickness = … * (1 - b * 0.72)`.
    static let membraneClears: Double = 0.72

    /// **How far the source-aperture opens.** Design's
    /// `ap.scale.setScalar(0.7 + 0.4 * k + b * 0.5)`, on the aperture at
    /// `(0, -3.4, -5.4)`.
    static let apertureAtRest: Double = 0.7
    static let apertureSettling: Double = 0.4
    static let apertureOpens: Double = 0.5
    /// Design's `aperture(ring, 'tri-down')` stands a little over two across in
    /// its own room; it is read here as the vessel's own mouth at its narrowest
    /// profile point, which is what the lathe puts there.
    static let apertureSize: Double = 2.2
    static let apertureLow: Double = -3.4
    static let apertureStands: Double = -5.4

    /// The vessel itself: Design's lathe profile reaches `7.6` across and runs
    /// from `-9` to `+9.4`.
    static let vesselRadius: Double = 7.6

    /// Design's eight veins, running down the inside of the vessel from `+8.4` to
    /// `-8.6`, wandering by `sin(u * 3.1 + i) * 0.16` and standing at `0.94` of
    /// the profile.
    static let veins = 8
    static let veinSamples = 9
    static let veinRadius: Double = MembraneRoom.vesselRadius * 0.94
    static let veinWander: Double = 0.16
    static let veinWanders: Double = 3.1
    /// Design's `opacity = (0.16 + 0.34 * k * …) * (1 - b * 0.5)` — the veins
    /// fade as the membrane clears, because they were the membrane's own depth.
    static let veinAtRest: Double = 0.16
    static let veinSettling: Double = 0.34
    static let veinFades: Double = 0.5

    /// **The vessels beyond the vessel.** Design's `NEST = [1.55, 2.3, 3.2]`,
    /// dormant until the second adaptation:
    /// `opacity = clamp01(b * 2 - i * 0.5) * (0.12 - i * 0.024)`.
    static let nested: [Double] = [1.55, 2.3, 3.2]
    static let nestedSamples = 12
    static let nestedArrives: Double = 2
    static let nestedLags: Double = 0.5
    static let nestedBrightest: Double = 0.12
    static let nestedDims: Double = 0.024

    // MARK: - What the premise becomes

    /// The enclosure carried the premise — a vessel with no door, breathing
    /// around him — and the **source-aperture** takes the room over as the
    /// membrane clears.
    ///
    /// Design's own two numbers: `(1 - b * 0.72)` on the membrane's thickness,
    /// and `+ b * 0.5` on the aperture's own opening. It is a small `takes` and
    /// that is right: this room's reversal is not something arriving, it is
    /// something that was always there becoming visible.
    let becoming = HomeBecoming(premise: .wall, answer: .face,
                                yields: MembraneRoom.membraneClears,
                                takes: MembraneRoom.apertureOpens)

    // MARK: - Where the room's own surfaces stand

    func stations(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: Double] {
        let altitude = stage.placement.bodyAltitude
        var out = RoomReversal.stations(becoming, deep: stage.deep, bodyAltitude: altitude)

        // **The breath, at every instant of the stay.** Positive is toward him,
        // so the vessel widening is the enclosure standing off and the enclosure
        // coming in again, over and over, on Design's own slow sine. It does not
        // depend on the second adaptation and it never stops: *you were always
        // inside* is a statement about every moment, exactly as *it never
        // arrives* is in ``EndlessRoom``.
        //
        // Design widens the vessel and shortens it in the same breath, so the
        // canopy comes down as the sides go out. Nothing is added to the ground:
        // he is standing on it, and nothing in the instrument moves the walker.
        let br = sin(chamberTime * Self.breathRate)
        out[.wall, default: 0] -= br * Self.widens
            * RoomReversal.clearance(of: .wall, bodyAltitude: altitude)
        out[.canopy, default: 0] += br * Self.shortens
            * RoomReversal.clearance(of: .canopy, bodyAltitude: altitude)
        return out
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep
        let axes = RoomUnits.axes(of: surface)
        let centre = stage.placement.coordinate
        let br = sin(chamberTime * Self.breathRate)

        // The whole vessel as one figure: the outermost of the three beyond is
        // what has to fit, so the room keeps its shape rather than losing its
        // furthest source over the edge of the material.
        let figure = RingOne.Figure(spread: Self.vesselRadius * (Self.nested.last ?? 1),
                                    part: Self.apertureSize,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(1 + Self.veins * Self.veinSamples
                              + Self.nested.count * Self.nestedSamples)

        // ── the source-aperture ─────────────────────────────────────────────
        //
        // One mark, low and a little in front of her, present from the first
        // moment and opening on Design's own ramp. It is an **impression**:
        // material drawn back out of the way, which is what an aperture is, and
        // the same reading ``ContractRoom`` makes of its own point and
        // ``ReleaseRoom`` of its lid.
        //
        // **It is this room's only answer**, so ``RoomReversal/actions(_:deep:stage:)``
        // is not also called: a generic answering swell standing on top of the
        // aperture would be the second, brighter mark ``MatrkaRoom`` had to find
        // with a picture, and this room's own answer is an opening rather than an
        // arrival. The other half of the reversal is the membrane clearing, which
        // is a station.
        let opened = Self.apertureAtRest + Self.apertureSettling * k + b * Self.apertureOpens
        // Design's own `(0, -3.4, -5.4)`: in front of her, and below her. Which of
        // those two runs along the surface is ``RoomUnits/axes(of:)`` — on a floor
        // the aperture lies further into the room, and on a working face it stands
        // lower down the panel.
        marks.append(.impression(
            at: SurfaceCoordinate(u: centre.u,
                                  v: centre.v + material.reach(
                                    worldUnits: axes.along(
                                        design: figure.length(Self.apertureStands),
                                        rise: figure.length(Self.apertureLow)))).clamped,
            reach: min(RingOne.widestMark,
                       material.reach(worldUnits: figure.length(Self.apertureSize / 2)) * opened),
            depth: RingOne.depth(size: 1, on: material),
            glow: min(1, opened / (Self.apertureAtRest + Self.apertureSettling
                                   + Self.apertureOpens))))

        // ── the eight veins, running down the inside ────────────────────────
        //
        // Design's own eight, equally spaced about the room's axis and wandering
        // as they descend. A vein is a line and the vocabulary has no verb for
        // one, so it is made of the verb there is — a **crack**, *"narrow, sharp,
        // and with no volume of its own"*, which is the only one of the five that
        // is a line at all — overlapping along its own length.
        //
        // **They arrive on the surface as a rosette, and that is the lathe seen
        // honestly.** Design's veins run down the *inside* of a surface of
        // revolution; the walker is inside it, and what a surface of revolution's
        // inside looks like from inside is eight spokes going out from its axis.
        // The descent is carried by Design's own profile term, which takes a vein
        // from 0.39 of the radius out to all of it and back as it falls.
        //
        // They fade as the membrane clears, because they *were* the membrane's
        // own depth: Design's `(1 - b * 0.5)`.
        let veinLit = (Self.veinAtRest + Self.veinSettling * k) * (1 - b * Self.veinFades)
        let veinShare = RingOne.lightShare(of: Self.veins * Self.veinSamples)
        // A vein sweeps most of the vessel's own radius as it descends — Design's
        // profile term takes it from 0.39 of the radius out to all of it and back
        // — so its samples stand about a twelfth of that radius apart, and a mark
        // a little over half that reads as one continuous line.
        let veinReach = min(RingOne.widestMark,
                            material.reach(worldUnits: figure.length(Self.veinRadius)) * 0.08)
        for index in 0..<Self.veins {
            for sample in 0..<Self.veinSamples {
                let point = Self.vein(index, sample: sample, breath: br)
                marks.append(.crack(at: Self.on(centre, across: figure.length(point.across),
                                                along: figure.length(point.along),
                                                axes: axes, material: material),
                                    reach: veinReach,
                                    depth: RingOne.depth(size: 0.35, on: material),
                                    glow: veinLit * veinShare))
            }
        }

        // ── and the vessels beyond the vessel ───────────────────────────────
        //
        // *It was never one womb.* Three rings of material standing concentric
        // outside the one he is in, at Design's own 1.55, 2.3 and 3.2, arriving
        // in turn as the second adaptation comes on. They are **swells** —
        // material raised from beneath, still the material — because a source
        // beyond this one is not a hole in this one.
        guard b > 0 else { return [surface: marks] }
        for (index, scale) in Self.nested.enumerated() {
            let arrived = min(1, max(0, b * Self.nestedArrives - Double(index) * Self.nestedLags))
            guard arrived > 0 else { continue }
            let lit = arrived * (Self.nestedBrightest - Double(index) * Self.nestedDims)
            let radius = material.reach(worldUnits: figure.length(Self.vesselRadius * scale))
            let reach = min(RingOne.widestMark,
                            .pi * radius / Double(Self.nestedSamples) * 1.2)
            for sample in 0..<Self.nestedSamples {
                let a = Double(sample) / Double(Self.nestedSamples) * 2 * .pi
                marks.append(.swell(at: SurfaceCoordinate(u: centre.u + cos(a) * radius,
                                                          v: centre.v + sin(a) * radius).clamped,
                                    reach: reach,
                                    depth: RingOne.depth(size: arrived * 0.5, on: material),
                                    glow: lit / Self.nestedBrightest
                                        * RingOne.lightShare(of: Self.nestedSamples)))
            }
        }
        return [surface: marks]
    }

    // MARK: - Where one vein runs

    /// One sample of one vein, in Design's own room: `a0 = (i / 8) * 2π`,
    /// wandering by `sin(u * 3.1 + i) * 0.16`, at `0.94` of the vessel's profile
    /// and descending as `u` runs from the top of the vessel to its floor.
    ///
    /// The vessel's breath carries the veins with it — Design's
    /// `veins.scale.copy(vessel.scale)`.
    static func vein(_ index: Int, sample: Int,
                     breath: Double) -> (across: Double, along: Double) {
        let u = Double(sample) / Double(max(1, veinSamples - 1))
        let a = angle(ofVein: index) + sin(u * veinWanders + Double(index)) * veinWander
        // Design's own profile term, read at the vein's own height.
        let r = veinRadius * pow(max(0, sin(.pi * (0.12 + 0.78 * (1 - u)))), 0.82)
            * (1 + breath * widens)
        return (across: cos(a) * r, along: sin(a) * r)
    }

    /// Where a vein stands about the room's own axis: Design's `(i / 8) * 2π`,
    /// **equally spaced**, which is the room's eight-fold symmetry and the reason
    /// nothing here can be read as a body part.
    static func angle(ofVein index: Int) -> Double {
        Double(index) / Double(veins) * 2 * .pi
    }

    /// A point in Design's room, on the surface this room is happening to.
    static func on(_ centre: SurfaceCoordinate, across: Double, along: Double,
                   axes: RoomUnits.SurfaceAxes, material: RoomMaterial) -> SurfaceCoordinate {
        SurfaceCoordinate(u: centre.u + material.reach(worldUnits: across),
                          v: centre.v + material.reach(worldUnits:
                                axes.along(design: along, rise: along))).clamped
    }
}
