import Foundation

// MARK: - RING 8 · the three at the source · will, act and form
//
// Design's `sourcing(world, card, G)`, built on the Phase 3.1 spine. Its own
// header is the whole design:
//
//     RING 8 · SOURCING — will, act, form, at the origin.
//     One corner of the innermost triangle. Her corner is lit; the other two are
//     present but dark, because the three are inseparable.
//
// Three seats: `99` Kāmeśvarī, icchā · `100` Vajreśī, kriyā · `101` Bhagamālinī,
// jñāna. Her corner is `pos - 99` and it is the one number her position gives
// this archetype — SOURCING, like SOUNDING, has no phase divisor at all
// (``HomeGrammar/phaseDivisor(for:)``).
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO OF THE THREE SHARE A PHYSICS, AND THAT IS DELIBERATE
// ─────────────────────────────────────────────────────────────────────────────
//
// All three cards say *"at the source"*. Design's rule order reads
// `/yoni|source|bhaga/ → spring` **nine rules before** `/icch|…|will/ → incline`,
// so `99`'s *Icchā at the source* and `101`'s *Jñāna at the source* both classify
// as `spring`; only `100` escapes, because *Kriyā* and *Lightning-Action* reach
// `/vega|veloc|impulse|lightning|kriyā/ → dart` earlier still. The order is
// Design's and it is pinned by a test, so it is not touched here.
//
// Which means a Ring 8 room may not rest on her physics, and the three are told
// apart by everything else her row says. Two of those are structural and neither
// is invented:
//
//   * **Which corner is hers** decides which of the three marks the room's light
//     is in and which two are cut dark, so `99` and `101` are lit at opposite
//     ends of the same figure.
//   * **Her corner is also her phase.** Design phases the three lamps by
//     `displace(kind, t, i / 3, 0.8)` — by *lamp index*, with nothing of the
//     Śakti in it — so with one physics between them `99` and `101` would move
//     identically and differ only in which mark was bright. Her corner's own turn
//     of the three is what every other archetype receives as `ph`, and it is read
//     here from the one number her position gives this one.
//
// Her altitude, her attribute, her gem and her words then do what they do in all
// 102.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE TRIANGLE STANDS UP, AND THAT IS THE OPPOSITE OF THE TWO RINGS BEFORE IT
// ─────────────────────────────────────────────────────────────────────────────
//
// ``BodilessRoom`` reads Design's ring as lying down — `cos(a)` in **x** and
// `sin(a)` in **z**, at her altitude — and ``SoundingRoom`` reads its wall's ring
// the same way. Design's triangle is not: it is `cos(a) * R` in **x** and
// `sin(a) * R` in **y**, at a fixed `z` of `-9.5`. It stands upright, facing the
// walker.
//
// So this figure's two in-plane axes are Design's `x` and `y`, and the one that
// leaves the plane is `z` — which is the reverse of the two rings before it. The
// rule underneath is the same in all three and it is the figure's rather than the
// surface's: **a figure's own plane is the surface it is cut into.** Taking
// ``RoomUnits/axes(of:)``' general reading here instead would put the whole
// triangle's rise into `design: 0, rise: y`, which on a floor or a canopy is
// `along = 0` — three corners collapsed onto one line, and a procession running
// in an axis that is not there. Which way *into* is, is still the instrument's
// own ``RoomUnits/SurfaceAxes/outward``.
//
// ─────────────────────────────────────────────────────────────────────────────
// DESIGN'S OWN DEFECT: THE TRIANGLE WAS LARGER THAN THE ROOM
// ─────────────────────────────────────────────────────────────────────────────
//
// The Design thread recorded it: Ring 8's triangle stood wider than the room it
// was in, so its corners fell outside the picture and what the walker saw went
// near-black. That is exactly the failure ``OuterRings/Figure`` exists for, and
// it is why the whole figure is brought into the frame **as a whole** — its
// layout and the size of its parts by one number — rather than having its corners
// clamped onto the edge of the material. A triangle whose corners are clamped is
// not a triangle, it is three marks on a border, and it is the same three marks
// in all three rooms.
//
// Unlike ``BodilessRoom``, which deliberately lets its ring pass behind the
// walker because an Anaṅga's effect is the thing he is *inside*, this figure is
// held out in front of him: Design stands it at a fixed depth and lights it from
// its own corners. So it fits the picture, and the suite asserts that no mark of
// it is ever clamped.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THE ROOM DOES TO ITS OWN MATERIAL
// ─────────────────────────────────────────────────────────────────────────────
//
// Four marks, and Design's own line is drawn by what is at their ends rather
// than by a line: ``CrossingRoom`` settled that *"a tube of 0.028 in a petal of
// 11 is a line, and a line lights nothing"*, and Design's `tri` is a
// `LineBasicMaterial` of no width at all.
//
//   * **her corner**, at Design's `mine ? 6.4 : 2.4` span and `0.95` opacity —
//     the one mark in the room that carries light of its own from the first
//     instant;
//   * **the other two**, cut at the same depth and carrying `0.2 + b * 0.7`.
//     *Present but dark* is arithmetic here rather than an authored dimness:
//     the stone is moved exactly as far at all three corners, and what is missing
//     at two of them is emission. The seventh āvaraṇa is the sourceless one; this
//     is the eighth, so the room's own key still rakes across the two dark
//     corners and finds them. They are there, and they are not speaking;
//   * **the bindu they ring, not yet reached** — at the centre, at
//     `0.16 + 0.3 * k + 0.5 * b`, and cut shallower than anything else in the
//     room until the premise turns, because it has not been arrived at.
//
// **And the whole figure turns.** Design's `tri.rotation.z = t * 0.006` is the
// only continuous motion in the builder that belongs to the figure rather than to
// a part, and it is what keeps the three corners moving in a room whose physics
// two of the three share. Her physics is then on top of it, at her corner's own
// turn.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE SECOND ADAPTATION IS SPENT ON
// ─────────────────────────────────────────────────────────────────────────────
//
// *Will was already act and form.* Design's two numbers are
// `L.l.intensity = L.mine ? 900 : 90 + b * 700` — the two corners that were dark
// answer — and `bindu.scale.setScalar(2.2 * (1 + b * 2.4))` — the point at the
// source opens until it has reached the three that were ringing it. Both are
// here, and ``HomeBecoming/archetype(_:)`` carries the third: the working face
// yields and the **canopy** takes the work over, which is where the triangle's
// own apex is.
struct SourcingRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 99–101. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality. Two of the three
    /// share it — see the header.
    let physics: HomePhysics
    /// **Which corner of the innermost triangle is hers** — Design's
    /// `card.pos - 99`: `0` icchā, `1` kriyā, `2` jñāna.
    let corner: Int

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.corner = reading.sourcingCorner ?? HomeGrammar.sourcingCorner(position: reading.position)
    }

    /// The eighth āvaraṇa.
    static let ring = 8

    // MARK: - Design's own numbers

    /// Three. Design's `[0, 1, 2].map(…)`, and the three the archetype is.
    static let corners = 3

    /// The triangle's radius: Design's `const R = 4.6`.
    static let radius: Double = 4.6

    /// Where the first corner stands: Design's `-Math.PI / 2 + (i / 3) * TAU`.
    static let firstCorner: Double = -.pi / 2

    /// How fast the whole figure turns: Design's `tri.rotation.z = t * 0.006`.
    static let turn: Double = 0.006

    /// How large a corner is: Design's `sprite(…, mine ? 6.4 : 2.4, …)`, whose
    /// number is the sprite's whole span — so a mark's reach is half of it.
    static let mineSize: Double = 6.4
    static let otherSize: Double = 2.4

    /// Design's own opacity on a corner: `mine ? 0.95 : 0.2 + b * 0.7`.
    static let mineGlow: Double = 0.95
    static let otherFloor: Double = 0.2
    static let otherAnswers: Double = 0.7

    /// The bindu: `sprite(…, 2.6, 0.4)` at the centre, at
    /// `0.16 + 0.3 * k + 0.5 * b`, scaled `2.2 * (1 + b * 2.4)`.
    static let binduSize: Double = 2.6
    static let binduFloor: Double = 0.16
    static let binduSettles: Double = 0.3
    static let binduOpens: Double = 0.5
    static let binduGrows: Double = 2.4

    /// Design's displacement amplitude for the lamps — `displace(kind, t, i / 3,
    /// 0.8)`.
    static let travel: Double = 0.8

    /// Where the bindu stands among the room's marks — last, as Design builds it
    /// last, and named so a check can ask for it without counting.
    static var binduIndex: Int { corners }

    // MARK: - Where one corner stands in Design's own figure

    /// The angle of the `index`-th corner at one moment: Design's own
    /// `-π/2 + (i / 3) * TAU`, turning at `t * 0.006`.
    static func angle(_ index: Int, at chamberTime: TimeInterval) -> Double {
        firstCorner + Double(index) / Double(corners) * 2 * .pi + turn * chamberTime
    }

    /// Whether the `index`-th corner is hers.
    func isMine(_ index: Int) -> Bool { index == corner }

    // MARK: - What the premise becomes

    /// *Will was already act and form.* The working face yields and the canopy
    /// takes the work over — read from ``HomeBecoming/archetype(_:)``, so this
    /// room and the grammar agree by construction.
    var becoming: HomeBecoming { .archetype(.sourcing) }

    /// Design's `2.2 * (1 + b * 2.4)` on the bindu, through the instrument's own
    /// saturating fraction.
    var opens: Double { RoomReversal.answeringFraction(takes: becoming.takes) }

    // MARK: - The figure, and why it opens out

    /// **How large a corner may be, and how far out the triangle must stand.**
    ///
    /// ``BodilessRoom``'s rule, at a figure of three: a **furrow** and a **crack**
    /// run ``SurfaceAction/cutoffReaches`` of their own reach *along* the stroke,
    /// so a corner cut at Design's own size on Design's own radius makes a stroke
    /// that closes **past the middle** — and the middle is the bindu they are
    /// ringing and have not reached. So a corner's stroke closes on the triangle
    /// it stands on, and never across it.
    ///
    /// Hers is larger than the other two in Design's own ratio, and all three are
    /// floored at what the material can carry (``OuterRings/reach(_:)``).
    func layout(figure: OuterRings.Figure, material: RoomMaterial)
        -> (mine: Double, other: Double, radius: Double) {
        let mine = figure.reach(min(Self.mineSize / 2,
                                    Self.radius / SurfaceAction.cutoffReaches))
        let other = OuterRings.reach(mine * Self.otherSize / Self.mineSize)
        let design = material.reach(worldUnits: figure.length(Self.radius))
        let swing = material.reach(worldUnits: OuterRings.inPlaneExcursion(
            physics, amplitude: figure.length(Self.travel)))
        return (mine, other, max(design, OuterRings.clearance(ofReach: mine) + swing))
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        let figure = OuterRings.Figure(ring: Self.ring,
                                       spread: Self.radius * 2,
                                       part: Self.mineSize / 2,
                                       on: material,
                                       bodyAltitude: stage.placement.bodyAltitude)
        let travel = figure.length(Self.travel)
        let share = OuterRings.lightShare(of: Self.corners + 1)
        let cut = layout(figure: figure, material: material)

        var made: [SurfaceAction] = []
        made.reserveCapacity(Self.corners + 1)

        // ── the three at the source ─────────────────────────────────────────
        //
        // Cut to the same depth, all three, because the three are inseparable and
        // what differs between them is not how far the stone moved. Hers carries
        // light from the first instant; the other two carry almost none until the
        // premise turns, and the room's own key finds them anyway.
        for index in 0..<Self.corners {
            let here = place(index: index, at: chamberTime,
                             figure: figure, stage: stage, material: material)
            let before = place(index: index, at: chamberTime - OuterRings.readOver,
                               figure: figure, stage: stage, material: material)
            made.append(OuterRings.mark(here, from: before,
                                        reach: isMine(index) ? cut.mine : cut.other,
                                        size: 1,
                                        travel: travel,
                                        glow: (isMine(index)
                                               ? Self.mineGlow
                                               : Self.otherFloor + Self.otherAnswers * b) * share,
                                        material: material))
        }

        // ── and the bindu they ring, not yet reached ────────────────────────
        //
        // At the centre, and the only mark in the room that is **shallower** than
        // one mark's worth until the premise turns — not reached is a fact about
        // how far the material has moved, and it deepens as the point at the
        // source opens out. It is not a second absence: it carries light from the
        // first instant, which is what separates it from ``BodilessRoom``'s empty
        // middle.
        let centre = place(index: Self.binduIndex, at: chamberTime,
                           figure: figure, stage: stage, material: material)
        let centreBefore = place(index: Self.binduIndex, at: chamberTime - OuterRings.readOver,
                                 figure: figure, stage: stage, material: material)
        made.append(OuterRings.mark(centre, from: centreBefore,
                                    reach: min(OuterRings.widestMark,
                                               figure.reach(Self.binduSize / 2) * (1 + b * opens)),
                                    size: b,
                                    travel: travel,
                                    glow: (Self.binduFloor + Self.binduSettles * k
                                           + Self.binduOpens * b) * share,
                                    material: material))

        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: made)
        return out
    }

    // MARK: - Where one part of the figure stands

    /// Where one corner of the innermost triangle stands at one moment, or — at
    /// ``binduIndex`` — the point they are ringing.
    ///
    /// **The triangle's plane is the surface**, which for this figure means
    /// Design's `x` and `y` run along the stone and Design's `z` runs into it —
    /// the reverse of the two rings before it, and the header says why.
    ///
    /// The bindu carries no angle. It stands where she is felt, which is also
    /// where the ember stands and where ``RoomReversal`` opens the answering mark;
    /// it turns with nothing and it is not displaced, because the three are what
    /// move and it is what they move around.
    func place(index: Int, at chamberTime: TimeInterval,
               figure: OuterRings.Figure, stage: RoomStage,
               material: RoomMaterial) -> OuterRings.Place {
        let centre = stage.placement.coordinate
        guard index >= 0, index < Self.corners else {
            return OuterRings.Place(at: centre, into: 0)
        }

        let axes = RoomUnits.axes(of: material.surface)
        let radius = layout(figure: figure, material: material).radius
        let a = Self.angle(index, at: chamberTime)

        // Design's `ph + i / 3`, where `ph` is **her corner's own turn** — the one
        // number her position gives this archetype, standing in for the phase
        // SOURCING has no divisor for. Read against her own kernel's turn rather
        // than typed (``OuterRings/spread(index:of:kind:)``).
        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime,
            phase: OuterRings.spread(index: index, of: Self.corners, kind: physics)
                + OuterRings.spread(index: corner, of: Self.corners, kind: physics),
            amplitude: figure.length(Self.travel))

        let u = radius * cos(a) + material.reach(worldUnits: drift.x)
        let v = radius * sin(a) + material.reach(worldUnits: drift.y)
        return OuterRings.Place(at: SurfaceCoordinate(u: centre.u + u, v: centre.v + v).clamped,
                                into: drift.z * axes.outward)
    }
}
