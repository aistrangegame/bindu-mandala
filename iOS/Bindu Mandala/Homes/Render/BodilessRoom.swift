import Foundation

// MARK: - RING 3 · the eight Anaṅgas · the room whose cause is empty
//
// Design's `bodiless(world, card, G)`, built on the Phase 3.1 spine. Its own
// header is the whole design:
//
//     RING 3 · BODILESS — you feel it, and there is nothing there to feel.
//     Her effect is fully present; her cause is empty. The room's light comes
//     from a point that visibly holds nothing.
//
// and the thread says it once more: *"Her effect fills the room and the centre
// visibly holds nothing — a rim of light around an absence. Second adaptation:
// the effect was the only body."*
//
// **Anaṅga means limbless — without a body.** That is the hard word for this
// instrument, because the renderer ruling's binding condition allows a room
// exactly one register: *an action on the room's own material*. There is no
// floating thing, no free-standing lit solid, nowhere in the air for a bodiless
// effect to be. The tension is not a problem to be solved around; **it is the
// room.** Something that has no body still leaves a mark, and eight of those
// marks stand in a ring around a place where nothing has happened.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM AN ANAṄGA AND NOT ANY OTHER SISTER
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's own question is *could this room belong to any other Śakti?* Two
// answers, one about the ring and one about the seat.
//
// **The ring.** No other archetype in the hundred and two addresses an **empty
// centre**. The Siddhi's train recedes, the Mātṛkā's letters close a ring that is
// *full* — one of them being spoken at every instant — the Karṣiṇī's two halves
// converge on each other, the Mudrā's vaults open. Here eight effects stand
// around a place, and the thing they are the effect *of* is not there. That is
// the one arrangement in the instrument whose subject is an absence.
//
// **The seat.** Her tattva picks the physics the eight effects move on, her
// position takes her turn of the eight, her bodily location decides which surface
// the ring is cut into and where in the frame it sits, her attribute acts inside
// it, and her gem lights it. Eight sisters, eight different rings.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE THREE READINGS OF DESIGN THIS FILE MAKES, AND WHY
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · The absence is concentric with the effect, and it is where her mark
// falls.** Design stands the eight petals on a ring at `z = -3` and the rim of
// light at `z = -6.5`, further back, because in three.js the rim carries the
// `PointLight` and a key behind a subject rim-lights it. Its own comments say
// what the two *are*: the petals are *"orbiting nothing"* and the rim is
// *"the absence at the centre"*. So they are concentric here, and the centre they
// are concentric with is the one point the instrument already has for *where she
// is felt* — ``RoomPlacement/coordinate``, which is also where
// ``RoomUnits/emberPoint(for:)`` stands the room's own light and where
// ``RoomReversal`` opens the answering mark. Design's staging offset is a
// three.js lighting arrangement; its meaning is a concentric one.
//
// **2 · The eight effects are lit and the absence is not — and that is the whole
// sentence.** Design's petals are glow sprites; its rim is a `TorusGeometry` of
// tube radius **0.02**, which is a line, and ``CrossingRoom`` already settled what
// a line becomes here: *"a tube of 0.028 in a petal of 11 is a line, and a line
// lights nothing"*. So the absence is **drawn and never lit** — read only by the
// room's own key raking across it.
//
// Which means the room's sentence is delivered by the instrument's own
// arithmetic rather than by an effect somebody authored. ``RoomMaterial``'s third
// condition is that light is only ever a property of a disturbance: an action's
// `glow` is multiplied by how far it actually moved the material. The absence
// carries `glow` **0** and the eight effects carry all the light there is — so
// the one place in her room that emits nothing is the exact point the ember
// stands at. *The room's light comes from a point that visibly holds nothing*,
// and it is true because of how light is defined here, not because a torus was
// given a low opacity.
//
// **3 · The absence's verb is `compaction`, and it was not chosen.**
// ``RoomInscription/verb(for:previous:)`` reads which of the five verbs a part
// performs from its own travel, and the absence does not travel: it is the still
// centre of a turning ring. A part that bears on the stone without moving
// classifies as a **compaction** — *"driven down and densified, with almost no
// relief: the mark of something that bore down without moving"*. That is the
// definition of Anaṅga arrived at through the classifier rather than written into
// it: the material carries the imprint of something that has no body.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT DESIGN'S `(1 - b)` ON THE RIM IS SPENT ON
// ─────────────────────────────────────────────────────────────────────────────
//
// Design fades the rim to nothing across the second adaptation. Here the rim
// carries no light, so there is no opacity for that number to be; and a mark may
// not be faded by going *shallower* — ``RingOne`` refused that once already,
// because *"a mark that grew shallower would stop being seen while it was still
// there, which is a different thing from leaving"*.
//
// So it is spent where the deep sentence points. *The effect was the only body*:
// the absence is not removed, it is **overtaken**. The eight effects open out by
// Design's own growth, the enclosure gives way, and ``RoomReversal`` opens the
// answering mark **at the centre, on the same point the absence stands on** — a
// mark that ends the stay twenty times the absence's width. Nothing had to be
// taken away. What held nothing became the room.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND THE ONE THING THAT IS AT THE CENTRE
// ─────────────────────────────────────────────────────────────────────────────
//
// Her **attribute** acts there, because Design mounts every one of the hundred
// and two attributes where she is felt — *"her attribute joins whatever room she
// has; the room is the mechanism, the attribute is the one thing acting inside
// it"* — and this room does not make an exception of itself. That is not a leak
// in the absence; it is the sentence finishing. What stands at the centre of an
// Anaṅga's room is her **effect**, and the room's own material under it has had
// nothing happen to it but a flattening. The cause is what is missing, and the
// cause is the room.
//
// So every claim this file makes about the absence is a claim about *the room's*
// marks, and the suite reads them through the mechanism rather than through the
// finished surface, which is the same separation ``OuterRingStage/marks(room:at:)``
// keeps for every ring.
struct BodilessRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 45–52. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the eight — Design's `(card.pos % 8) / 8`.
    let phase: Double

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
    }

    /// The third āvaraṇa. Position decides who stands in it; nothing here
    /// consults a name.
    static let ring = 3

    // MARK: - Design's own numbers

    /// Eight. Design's `for (let i = 0; i < 8; i++)`, and the same eight her
    /// phase divisor counts (``HomeGrammar/phaseDivisor(for:)``).
    static let effects = 8

    /// The ring the effects stand on: Design's `cos(a) * 5.4` / `sin(a) * 5.4`.
    static let effectRing: Double = 5.4

    /// How large one effect is: Design's `sprite(glow(…), G.c, 4.2, 0.8)`, whose
    /// 4.2 is the sprite's whole span — so an effect's reach is half of it.
    static let effectSize: Double = 4.2

    /// The absence at the centre: Design's `TorusGeometry(1.5, 0.02)`. The 1.5 is
    /// the rim's radius; the 0.02 is a line, which is why it carries no light
    /// here (see the header, reading 2).
    static let absenceRadius: Double = 1.5

    /// Design's displacement amplitude for the effects — `displace(kind, t, ph +
    /// i / 8, 2.6)`.
    static let travel: Double = 2.6

    /// Design's own opacity on an effect: `(0.42 + 0.5 * k) * (1 - b * 0.4)`.
    static let effectFloor: Double = 0.42
    static let settlingLift: Double = 0.5
    static let effectFades: Double = 0.4

    /// **How shallow the absence is.**
    ///
    /// Nought, which is the least a mark may ask for:
    /// ``OuterRings/mark(_:from:reach:size:travel:glow:material:)`` holds a size at
    /// a fifth before it reaches ``RoomInscription/depth(size:on:)``, so the absence
    /// ends a little over a tenth of the way from the stone's own grain to one
    /// mark's full depth — the shallowest thing in the room and still above the
    /// banding it is cut into.
    ///
    /// A compaction is *"driven down and densified, with almost no relief"*, and
    /// the whole point of this one is that it is the least eventful place in her
    /// room. It stays above the grain rather than under it, because a mark under
    /// the banding is not faint — it is nothing, which is a different claim from
    /// the one this room is making.
    static let absenceRelief: Double = 0

    /// Where the absence stands among the room's marks — last, as Design builds
    /// it last, and named so a check can ask for it without counting.
    static var absenceIndex: Int { effects }

    // MARK: - The ring, and why it is not simply Design's

    /// **The ring the eight stand on, and how large one of them may be — which
    /// are one question and not two.**
    ///
    /// Design's petal is a glow sprite of span 4.2 on a ring of radius 5.4, and
    /// a glow sprite is a light with a soft edge. A mark here is not: three of
    /// the five verbs are round, but a **furrow** and a **crack** run
    /// ``SurfaceAction/cutoffReaches`` of their own reach *along* the stroke, so
    /// a mark of Design's size on Design's ring makes a stroke **longer than the
    /// ring is wide**. The two effects whose stroke happens to point at the
    /// middle then lit the absence they were standing around — measured at 0.55
    /// of full emission in the one place this room's whole sentence needs dark,
    /// and found by the room's own check rather than by looking.
    ///
    /// So the two are tied together, and the rule is one sentence: **an effect's
    /// stroke closes on the ring it stands on, and never across it.**
    ///
    ///   * a mark reaches at most a quarter of the way to the absence
    ///     (``OuterRings/clearance(ofReach:)`` is the same fact from the other
    ///     end), which on a working face is Design's own ring exactly and asks
    ///     nothing of it;
    ///   * where the surface's own mesh has forced the mark **up** to a cell — a
    ///     floor and a canopy are four body-heights across, so one cell is four
    ///     times the thing it is on a face — the ring opens out until the strokes
    ///     close around it again;
    ///   * and it opens out by **however far her own physics can carry an effect
    ///     toward the middle**, which is
    ///     ``OuterRings/inPlaneExcursion(_:amplitude:)`` and is hers rather than
    ///     the kernel's widest. Design's petals *orbit* nothing, and a ring whose
    ///     own motion swings it through its centre is not orbiting anything.
    ///
    /// The last two limbs are what cost something, and they are paid
    /// deliberately: on the large surfaces the ring then reaches past the picture
    /// rather than sitting inside it. That is the right way round for this
    /// archetype and only for this one. Design's own petals ring the walker at
    /// `z = -3 ± 5.4`, which passes *behind* where he stands; her effect is not a
    /// figure held out in front of him, it is the thing he is inside. A ring that
    /// fitted the frame at the price of lighting its own centre would have lost
    /// the room.
    func layout(figure: OuterRings.Figure, material: RoomMaterial) -> (reach: Double, ring: Double) {
        let reach = figure.reach(min(Self.effectSize / 2,
                                     Self.effectRing / SurfaceAction.cutoffReaches))
        let design = material.reach(worldUnits: figure.length(Self.effectRing))
        let swing = material.reach(worldUnits: OuterRings.inPlaneExcursion(
            physics, amplitude: figure.length(Self.travel)))
        return (reach, max(design, OuterRings.clearance(ofReach: reach) + swing))
    }

    // MARK: - What the premise becomes

    /// **The effect was the only body.** Design's own deep sentence, and its two
    /// numbers: `shell.material.opacity = 1 - b * 0.8` — the enclosure gives way —
    /// and `p.scale.setScalar(1 + b * 1.6)` — the effect, which had no cause,
    /// opens out past where he stands.
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which is where the ten archetype
    /// reversals are, so this room and the grammar agree about the Anaṅga's turn
    /// by construction rather than by two people writing down the same numbers.
    var becoming: HomeBecoming { .archetype(.bodiless) }

    /// What Design's growth leaves for a mark: the instrument's own saturating
    /// fraction of it, which is the law that already holds every answering
    /// surface short of the walker. The rest of the growth is the enclosure's,
    /// through ``becoming``.
    var effectGrows: Double { RoomReversal.answeringFraction(takes: becoming.takes) }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        // The whole figure — the ring of eight and the absence they stand
        // around — brought into the picture the walker is looking at.
        let figure = OuterRings.Figure(ring: Self.ring,
                                       spread: Self.effectRing * 2,
                                       part: Self.effectSize / 2,
                                       on: material,
                                       bodyAltitude: stage.placement.bodyAltitude)
        let travel = figure.length(Self.travel)
        let share = OuterRings.lightShare(of: Self.effects)
        let grows = effectGrows
        let ring = layout(figure: figure, material: material)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.effects + 1)

        // ── the effect: eight marks orbiting nothing ────────────────────────
        //
        // Present at full strength from the first instant, each on her own
        // physics at its own turn of the eight. They are the room's premise: an
        // effect that is entirely here, with no cause anywhere in the room.
        //
        // **They carry every bit of light there is**, and they open out as the
        // premise turns while the light in them falls — Design's two lines side
        // by side. That is also what keeps the room readable: the lit area grows
        // by half again while the light in it drops, so the room never becomes
        // the pale structureless wash ``PressRoom`` and ``CrossingRoom`` each had
        // to find with a picture.
        for index in 0..<Self.effects {
            let here = place(index: index, at: chamberTime,
                             figure: figure, stage: stage, material: material)
            let before = place(index: index, at: chamberTime - OuterRings.readOver,
                               figure: figure, stage: stage, material: material)
            // **The growth is applied after the figure's own floor and never
            // under it** (``OuterRings/reach(_:)``): on a floor four body-heights
            // across, Design's effect is smaller than one cell of the mesh, and a
            // growth folded in before the floor would be swallowed by it.
            let opens = min(OuterRings.widestMark, ring.reach * (1 + b * grows))
            marks.append(OuterRings.mark(here, from: before,
                                         reach: opens,
                                         size: 1,
                                         travel: travel,
                                         glow: (Self.effectFloor + Self.settlingLift * k)
                                             * (1 - b * Self.effectFades) * share,
                                         material: material))
        }

        // ── and the absence at the centre ───────────────────────────────────
        //
        // The one mark in the room with no light of its own, standing on the one
        // point the room's own light stands at. It does not move, so the
        // classifier reads it as a compaction and nothing here has to say so; and
        // it is the shallowest thing the stone can carry, so what the key finds
        // when it rakes across the middle of her room is a place where almost
        // nothing happened.
        //
        // It is not withdrawn as the premise turns. It is overtaken — see the
        // header.
        let centre = place(index: Self.absenceIndex, at: chamberTime,
                           figure: figure, stage: stage, material: material)
        let centreBefore = place(index: Self.absenceIndex, at: chamberTime - OuterRings.readOver,
                                 figure: figure, stage: stage, material: material)
        marks.append(OuterRings.mark(centre, from: centreBefore,
                                     reach: figure.reach(Self.absenceRadius),
                                     size: Self.absenceRelief,
                                     travel: travel,
                                     glow: 0,
                                     material: material))

        // …and the archetype's own reversal on top: the enclosure giving way,
        // and the answering mark opening exactly where the absence is.
        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - Where one part of the room's work stands

    /// Where one of the eight effects stands at one moment, or — at
    /// ``absenceIndex`` — the absence they are standing around.
    ///
    /// Design's own placement is a ring in the **horizontal plane** at her
    /// altitude — `cos(a) * 5.4` in `x` and `sin(a) * 5.4` in `z` — with her
    /// physics on top of it at that effect's own turn.
    ///
    /// **The ring's plane is the surface, and that is this room's own reading of
    /// Design's three axes.** ``RoomUnits/axes(of:)`` is the instrument's general
    /// rule and it is right for a figure Design drew standing up: on a working
    /// face it maps Design's *rise* along the surface. But a bodiless ring is
    /// drawn lying down, so its two in-plane axes — `x` and `z` — are the two
    /// that run along the stone, and the one that leaves the plane, `y`, is the
    /// one that runs **into** it. On a floor and a canopy that is exactly what
    /// ``RoomUnits/axes(of:)`` already says; on a face it is not, and taking the
    /// general rule there put Design's off-plane motion *across* the ring — which
    /// is how a Śakti whose physics is expansion lit the absence she was standing
    /// around, measured at 0.55 where the room needs dark.
    ///
    /// Which way *into* is, is still the instrument's: ``RoomUnits/SurfaceAxes``'
    /// own `outward`, so rising off a floor and rising off a ceiling are the same
    /// fact seen from two sides.
    ///
    /// The absence carries no angle and no displacement. It is the still point,
    /// and its stillness is what the verb classifier reads.
    func place(index: Int, at chamberTime: TimeInterval,
               figure: OuterRings.Figure, stage: RoomStage,
               material: RoomMaterial) -> OuterRings.Place {
        let centre = stage.placement.coordinate
        guard index >= 0, index < Self.effects else {
            return OuterRings.Place(at: centre, into: 0)
        }

        let axes = RoomUnits.axes(of: material.surface)
        let travel = figure.length(Self.travel)
        let ring = layout(figure: figure, material: material).ring
        let angle = Double(index) / Double(Self.effects) * 2 * .pi

        // Her physics, at this effect's own turn of the eight — Design's
        // `ph + i / 8`, read against her own kernel's turn rather than typed
        // (``OuterRings/spread(index:of:kind:)``). For every kind that does not
        // fold this is Design's number exactly; for the kinds that do, a literal
        // `i / 8` would make the ring of eight move as four identical pairs.
        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime,
            phase: phase + OuterRings.spread(index: index, of: Self.effects, kind: physics),
            amplitude: travel)

        let u = ring * cos(angle) + material.reach(worldUnits: drift.x)
        let v = ring * sin(angle) + material.reach(worldUnits: drift.z)
        return OuterRings.Place(at: SurfaceCoordinate(u: centre.u + u, v: centre.v + v).clamped,
                                into: drift.y * axes.outward)
    }
}
