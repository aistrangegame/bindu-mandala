import Foundation

// MARK: - RING 5 · the ten Kulottīrṇa Śaktis · the room something arrives in
//
// Design's `giving(world, card, G)`, built on the Phase 3.1 spine and the outer
// climb's shared ground. Its own header is the whole design:
//
//     RING 5 · GIVING — something arrives, and it is already yours.
//     Her gift travels in from beyond the room and settles into your hands.
//
// Kulottīrṇa means *beyond the clan* — she is not of the circle, she comes from
// outside it, and every one of the ten **bestows**. The gesture is outward and it
// is not hers to keep: something is handed over, released toward the walker
// rather than withheld.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM A KULOTTĪRṆĀ AND NOT ANY OTHER SISTER
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's own question is *could this room belong to any other Śakti?* Two
// answers, one about the ring and one about the seat.
//
// **The ring.** This is the one arrangement in the hundred and two whose parts
// are **not in the room when the stay begins**. Everything else the instrument
// builds is already here and does something: the Anaṅga's eight effects stand
// around an absence from the first instant, the Sampradāya's fourteen shells are
// one gesture repeated outward, the Nigarbha's truth was in the room the whole
// time and a veil thins off it, the Karṣiṇī's two halves converge on each other,
// the Siddhi's train recedes, the Mudrā's vault opens. **Here the room's work
// crosses into it from beyond its own edge.** A room whose subject is arrival
// cannot be any of those, and none of them can be this.
//
// **The seat.** Her tattva picks the physics that carries each gift as it
// crosses; her position takes her turn of the ten; her bodily location decides
// which of the room's surfaces the giving happens on and where in the frame it
// lands; her attribute acts at the place the gifts land in; and her gem lights
// it. Ten sisters, ten different arrivals.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE FOUR READINGS OF DESIGN THIS FILE MAKES, AND WHY
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · A gift is not a thing in the air. It is the arrival, in the stone.**
// Design's gifts are glow sprites falling through a cylinder; the renderer
// ruling's binding condition allows a room exactly one register, *an action on
// the room's own material*, and there is nothing a sprite could be here. So a
// gift **is** the disturbance it makes: a mark that crosses the room's own
// material from beyond its edge, bearing on it a little at first and driven into
// it as it lands. Design's own fall says which is which — the gift starts seven
// of the room's units *above* her plane and ends two *below* it, so it passes
// through the surface at a little over three quarters of its crossing, and
// ``OuterRings/Place/into`` carries that as how far it has been driven against
// the stone. Nothing floats; what the walker sees is the material moving, and
// how far it moves is how far the gift has arrived.
//
// **2 · The fall is the arrival and not a direction in the room.**
// ``BodilessRoom`` settled the plane: a figure drawn *lying down* has its two
// in-plane axes along the stone and the third into it, and taking
// ``RoomUnits/axes(of:)``' general rule on a working face put Design's off-plane
// motion across the ring instead of into it. That reading holds here — the
// spiral is drawn lying down — with one thing added that only an arriving room
// needs. **The fall is toward the stone it is given into, on every surface.** A
// gift falling onto a canopy is rising, in the room's own coordinates; if the
// descent were multiplied by the surface's ``RoomUnits/SurfaceAxes/outward`` the
// way her physics' off-plane term rightly is, a crown Śakti's whole procession
// would run backwards — the gifts drawing *out* of her ceiling for the length of
// every stay. That is the third of the five defects earlier passes hit, and it is
// avoided by saying what the fall means rather than which way it points. Her
// physics keeps `outward`, because a drift **is** a direction in the room.
//
// **3 · The light is in the crossing and not in what landed.** Design's own
// `s.material.opacity = Math.sin(Math.PI * u)`: a gift carries nothing at the
// moment it enters and nothing at the moment it lands, and everything in
// between. That is the archetype's whole sentence in one number — **the giving
// disappears into the given.** What is left where a gift landed is not a bright
// object sitting in the walker's hands; it is a place in the material that has
// been borne down on, which is the one mark in this room that does not travel.
//
// It is also what carries *"arriving, unasked"* on the room's own large surfaces.
// Where the flight overruns the stone — a working face is one body-height across
// and Design's hall is four — a gift is simply **not a mark until it has crossed
// in**, because beyond the material there is nothing to mark and a mark clamped
// onto the rim would be twelve gifts piled on an edge rather than a procession.
// Where the flight fits inside the surface, the gift is in the stone from the
// first instant of its crossing and **invisible**, because light here is only
// ever a property of a disturbance and `sin(π · 0)` is nought. Either way it
// arrives out of nothing. Neither limb is a special case: the room emits a mark
// where there is material and Design's own opacity does the rest.
//
// **4 · The receiving place is a compaction, and it was not chosen.**
// ``RoomInscription/verb(for:previous:)`` reads which of the five verbs a part
// performs from its own travel. The place the gifts land in does not travel —
// Design's cup only brightens and opens — so it classifies as a **compaction**,
// *"driven down and densified, with almost no relief: the mark of something that
// bore down without moving"*. That is the right word for a place that has been
// receiving: it is not doing anything, it is being given to.
//
// **And it is the exact opposite of ``BodilessRoom``'s absence, which is the
// other still centre in the outer climb.** The Anaṅga's centre carries `glow` 0
// and the least relief the stone can hold: it is where *nothing* happened, and
// the room's light comes from a point that visibly holds nothing. This one
// carries the room's own brightest light while the eye settles and the **deepest**
// mark the room makes: it is where *everything* arrived. Two rings, two still
// centres, and nothing generic between them.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE SECOND ADAPTATION IS SPENT ON
// ─────────────────────────────────────────────────────────────────────────────
//
// *The giving and the given are one.* **Its reversal is what the giving has left
// behind, and never the giving undone.** Nothing is withdrawn and nothing stops:
// the gifts go on crossing in for the whole of the stay, and they open out by
// Design's own `s.scale.setScalar(… * (1 + b))` as they do it.
//
// What changes is the place they land in. Design's two lines are
// `cup.material.opacity = … * (1 - b * 0.8)` and `cup.scale.setScalar(1 + b *
// 4.2)`: it stops being a bright point and becomes wide and low and unlit —
// which is to say it stops being a place in the room and becomes the room's
// floor. ``HomeBecoming/archetype(_:)`` carries the same two numbers as the
// archetype's own turn, so the canopy the gifts were coming through gives way and
// ``RoomReversal`` opens the answering swell on the **ground**, at her own depth
// across it. What was given is the ground he is standing on.
//
// A mark may not be faded by going shallower — ``RingOne`` refused that once
// already, because *"a mark that grew shallower would stop being seen while it
// was still there, which is a different thing from leaving"* — so the receiving
// place keeps its full depth and loses only its light. It is not taken away. It
// is spread out until it is underfoot.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND THE ONE THING THAT IS AT THE CENTRE
// ─────────────────────────────────────────────────────────────────────────────
//
// Her **attribute** acts where the gifts land, because Design mounts every one of
// the hundred and two attributes where she is felt and this room does not make an
// exception of itself. In a giving room that is the sentence finishing rather
// than an intrusion: the thing that arrives, arrives into her own hand's work.
// So every claim this file makes about the arrival is a claim about *the room's*
// marks, and the suite reads them through the mechanism rather than through the
// finished surface (``OuterRingStage/marks(room:at:)``).
struct GivingRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 67–76. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the ten — Design's `(card.pos % 10) / 10`.
    let phase: Double

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
    }

    /// The fifth āvaraṇa. Position decides who stands in it; nothing here
    /// consults a name.
    static let ring = 5

    // MARK: - Design's own numbers

    /// Twelve. Design's `for (let i = 0; i < 12; i++)`.
    ///
    /// **Not her phase divisor, and the two are different things.** Her turn of
    /// the ring is one of ten (``HomeGrammar/phaseDivisor(for:)``); the
    /// procession that crosses her room is twelve. Design writes both in the same
    /// builder and they are not the same number.
    static let gifts = 12

    /// How much of one crossing passes in a chamber second — Design's
    /// `t * 0.055`.
    static let arrivalRate: Double = 0.055

    /// How long one gift takes to cross, in chamber seconds. A little over
    /// eighteen, so with twelve of them staggered one lands about every second
    /// and a half.
    static let crossing: TimeInterval = 1 / arrivalRate

    /// Where a gift's crossing begins and ends, in Design's own units — her
    /// `16 * (1 - u) + 1.4 * u`.
    static let farRadius: Double = 16
    static let nearRadius: Double = 1.4

    /// The fall. Design's `y + 7 - u * 9`: a gift enters seven of the room's own
    /// units above her plane and ends two below it, so it passes **through** the
    /// surface at `7/9` of its crossing.
    static let fallFrom: Double = 7
    static let fallBy: Double = 9

    /// How far the crossing turns as it comes in — Design's `u * 1.2`. It is what
    /// makes the flight a spiral rather than a spoke.
    static let turn: Double = 1.2

    /// How large one gift is: Design's `sprite(glow(…), G.c, 1.5, 0.7)`, whose
    /// 1.5 is the sprite's whole span — so a gift's reach is half of it.
    static let giftSize: Double = 1.5

    /// Design's `s.scale.setScalar((0.9 + u * 0.9) * (1 + b))` — a gift opens as
    /// it comes, and again once the premise turns.
    static let giftEntry: Double = 0.9
    static let giftOpens: Double = 0.9
    static let giftOpensDeep: Double = 1

    /// Design's displacement amplitude for a gift — `displace(kind, t, ph + i /
    /// 12, 0.9)`.
    static let travel: Double = 0.9

    /// Design's own opacity on a gift: `sin(π u) * (0.4 + 0.4 * k)`.
    static let giftFloor: Double = 0.4
    static let settlingLift: Double = 0.4

    /// The place they land in: Design's `TorusGeometry(1.9, 0.03)` standing at
    /// `y - 1.4`. The 1.9 is how wide the place is; the 1.4 is how far below her
    /// own plane it sits, which is how far into the stone it has been borne.
    static let receivingRadius: Double = 1.9
    static let receivingDepth: Double = 1.4

    /// Design's own opacity on it: `(0.2 + 0.35 * k) * (1 - b * 0.8)` — it comes
    /// up as the eye settles and goes out as the premise turns.
    static let receivingFloor: Double = 0.2
    static let receivingLift: Double = 0.35
    static let receivingFades: Double = 0.8

    /// Where the receiving place stands among the room's marks — last, as Design
    /// builds its cup last, and named so a check can ask for it without counting.
    /// The gifts are a variable number (reading 3), so it cannot be counted to.
    static var receivingIndex: Int { gifts }

    // MARK: - The clock a crossing is read on

    /// **How long a reading of a crossing gift is taken over.**
    ///
    /// ``OuterRings/readOver`` is a quarter of the first adaptation because her
    /// *physics* turns at 0.03–0.6 radians a second, and a kernel sampled at a
    /// gesture's quarter-second has barely moved. A gift is not only drifting: it
    /// is **transported**, at Design's own 0.055 of a crossing a second, and a
    /// window of fifteen and a half seconds is longer than five sixths of the
    /// whole journey.
    ///
    /// Read over a window that long, the classifier does not see a crossing. It
    /// sees the **cycle wrapping**: a gift a tenth of the way in would have its
    /// previous sample taken three quarters of the way *down*, and would read as
    /// travelling outward at speed. So the window is the shorter of the two —
    /// enough of her kernel's turn to carry her physics, never more than a
    /// quarter of a gift's own crossing.
    ///
    /// The other half of the same fact is in ``crossed(index:at:)``' caller: a
    /// crossing is a **one-way journey** and the cycle is only how the twelve are
    /// staggered, so a gift younger than this window is read from the far edge it
    /// entered at rather than from the previous gift's position.
    static let readOver: TimeInterval = min(OuterRings.readOver, crossing / 4)

    /// How much of a crossing passes in one reading.
    static let crossedOver: Double = readOver * arrivalRate

    /// **Where a gift stands on its own crossing** — `0` at the far edge it
    /// enters from, `1` where it lands. Design's `(t * 0.055 + i / 12) % 1`.
    ///
    /// **Design's `i / 12` is literal here and that is not an oversight.**
    /// ``OuterRings/spread(index:of:kind:)`` exists because `ph + i / n` read
    /// into the *displacement kernel* is an identity for the kinds whose terms
    /// are all `|sin|`. This `i / 12` is not a kernel phase: it is a spread of
    /// **arrival times** along a linear cycle, where a twelfth of a turn is a
    /// twelfth of a turn for every Śakti alive. The kernel phase in this room
    /// goes through ``OuterRings/spread(index:of:kind:)``, in ``place`` — the two
    /// numbers look alike in Design's one line and are different quantities.
    static func crossed(index: Int, at chamberTime: TimeInterval) -> Double {
        let x = chamberTime * arrivalRate + Double(index) / Double(gifts)
        return x - floor(x)
    }

    // MARK: - What the premise becomes

    /// **The giving and the given are one.** Design's own deep sentence, and its
    /// two numbers: `cup.material.opacity = … * (1 - b * 0.8)` — the place they
    /// were landing goes out — and `cup.scale.setScalar(1 + b * 4.2)` — and opens
    /// until it is the ground he is on.
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which is where the ten archetype
    /// reversals are, so this room and the grammar agree about the Kulottīrṇā's
    /// turn by construction rather than by two people writing down the same
    /// numbers.
    var becoming: HomeBecoming { .archetype(.giving) }

    /// What Design's growth leaves for a mark: the instrument's own saturating
    /// fraction of it, which is the law that already holds every answering
    /// surface short of the walker. The rest of the growth is the ground's,
    /// through ``becoming``.
    var receivingOpens: Double { RoomReversal.answeringFraction(takes: becoming.takes) }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        // **The figure is sized on what is received, and never on how far it
        // came.** That is this room's own reading of ``OuterRings/Figure`` and it
        // is the opposite of ``BodilessRoom``'s, for a reason that belongs to the
        // archetype rather than to taste.
        //
        // A bodiless ring is one ring and has to be laid out as one. A giving has
        // an **arrival** and a **flight**, and only the arrival has to be in the
        // picture: the flight's whole business is to come from somewhere that is
        // not in it. Sized against Design's own thirty-two-unit hall the figure
        // would scale by about a twelfth, and the place the gifts land in — 1.9
        // of her units — would collapse onto the mesh's own floor with twelve
        // gifts jostling in it. Sized against the arrival, the flight simply
        // overruns the stone, which is where reading 3 begins.
        let figure = OuterRings.Figure(ring: Self.ring,
                                       spread: Self.receivingRadius * 2,
                                       part: Self.giftSize / 2,
                                       on: material,
                                       bodyAltitude: stage.placement.bodyAltitude)

        // **What `into` is normalised against**, which in this room is the whole
        // of the fall rather than the kernel's off-plane term.
        // ``OuterRings/pressed(_:travel:)`` divides by `travel × widestTerm`
        // because in every room built so far `into` is the kernel's own doing. It
        // is not here: the fall is ten times the amplitude her physics is handed,
        // so normalising by the kernel would rail every gift at full depth for the
        // whole of its crossing — the exact failure ``CrossingRoom`` measured on
        // Cittā and Ātmā. The fall's own range is handed in instead, so `pressed`
        // runs from a gift barely bearing on the stone to one driven into it.
        let bearing = figure.length(Self.fallBy) / HomeGrammar.widestTerm

        let opens = receivingOpens

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.gifts + 1)

        // ── the gifts, arriving ─────────────────────────────────────────────
        //
        // Twelve crossings staggered over one cycle, each on her own physics at
        // its own turn of the twelve. They are the room's premise: something that
        // was not in the room is, and it came from beyond it.
        //
        // The light is Design's `sin(π u)` — nothing as it enters, nothing as it
        // lands, everything in between. The size is his `0.9 + u * 0.9`,
        // normalised against the largest a gift becomes, so a gift **deepens** as
        // it arrives as well as widening.
        for index in 0..<Self.gifts {
            let u = Self.crossed(index: index, at: chamberTime)
            let here = place(index: index, crossed: u, at: chamberTime,
                             figure: figure, stage: stage, material: material)

            // A gift beyond the material is not a mark, because there is no
            // material there to mark. It is not clamped onto the rim — see
            // reading 3.
            guard Self.inTheRoom(here) else { continue }

            // **A gift younger than one reading is read from the moment it
            // entered — in time as well as in crossing.**
            //
            // Pinning the previous sample's *crossing* to the far edge while
            // letting its *time* run a whole window back reads the gift over a
            // pairing that never happened: four and a half seconds of her
            // physics' drift against a six-hundredth of a crossing. The fall
            // contributes nothing over that pairing and the drift contributes
            // everything, so a gift that has just entered reads as whatever her
            // kernel's off-plane term was doing — and khaḍgamālā 72's gift 11,
            // two thousandths of the way in at the end of the stay, came back a
            // **swell**: drawn up out of the stone, which is the one thing an
            // arrival never is.
            //
            // So the window is the shorter of the reading and the gift's own
            // **age**, and it is taken off both axes together. For a gift older
            // than one reading this is `max(0, u - crossedOver)` exactly as
            // before; for a new one it is the far edge it entered at, at the
            // moment it entered.
            let age = min(Self.readOver, u / Self.arrivalRate)
            let before = place(index: index, crossed: u - age * Self.arrivalRate,
                               at: chamberTime - age,
                               figure: figure, stage: stage, material: material)

            // **The growth is applied after the figure's own floor and never
            // under it** (``OuterRings/reach(_:)``): on a floor four body-heights
            // across, a gift is smaller than one cell of the mesh, and a growth
            // folded in before the floor would be swallowed by it.
            let open = figure.reach(Self.giftSize / 2 * Self.opening(at: u))
                * (1 + b * Self.giftOpensDeep)
            marks.append(OuterRings.mark(here, from: before,
                                         reach: min(OuterRings.widestMark, open),
                                         size: Self.opening(at: u) / Self.widestOpening,
                                         travel: bearing,
                                         glow: Self.light(at: u, settling: k),
                                         material: material))
        }

        // ── and the place they land in ──────────────────────────────────────
        //
        // The one mark in the room that does not travel, standing on the one
        // point the room's own light stands at, carrying the deepest mark the
        // room makes. It does not move, so the classifier reads it as a
        // compaction and nothing here has to say so.
        //
        // It is not withdrawn as the premise turns. It opens out and goes dark —
        // see the header.
        let landing = place(index: Self.receivingIndex, crossed: 1, at: chamberTime,
                            figure: figure, stage: stage, material: material)
        let landingBefore = place(index: Self.receivingIndex, crossed: 1,
                                  at: chamberTime - Self.readOver,
                                  figure: figure, stage: stage, material: material)
        marks.append(OuterRings.mark(landing, from: landingBefore,
                                     reach: min(OuterRings.widestMark,
                                                figure.reach(Self.receivingRadius)
                                                    * (1 + b * opens)),
                                     size: 1,
                                     travel: bearing,
                                     glow: (Self.receivingFloor + Self.receivingLift * k)
                                         * (1 - b * Self.receivingFades),
                                     material: material))

        // …and the archetype's own reversal on top: the canopy the gifts were
        // coming through giving way, and the answering swell opening on the
        // ground at her own depth across it.
        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - How wide a gift is, at a point of its crossing

    /// Design's `0.9 + u * 0.9`.
    static func opening(at crossed: Double) -> Double {
        giftEntry + min(1, max(0, crossed)) * giftOpens
    }

    /// The widest a gift becomes, which is what its depth is read against so a
    /// gift arriving is the deepest one in the flight.
    static let widestOpening: Double = opening(at: 1)

    /// **How much light one gift carries at a point of its crossing.**
    ///
    /// Design's `s.material.opacity = Math.sin(Math.PI * u) * (0.4 + 0.4 * k)`,
    /// shared among the twelve so that a flight converging on one place does not
    /// stack to a flat field (``OuterRings/lightShare(of:)``).
    ///
    /// It is nought at both ends of a crossing and that is the archetype's whole
    /// sentence: the gift carries nothing as it enters and nothing as it lands,
    /// and what is left where it landed is the place rather than the gift. Light
    /// here is only ever a property of a disturbance, so a gift at either end of
    /// its crossing is in the stone and cannot be seen.
    static func light(at crossed: Double, settling k: Double) -> Double {
        sin(.pi * min(1, max(0, crossed))) * (giftFloor + settlingLift * k)
            * OuterRings.lightShare(of: gifts)
    }

    /// **How far a gift stands from the place it lands in**, at a point of its
    /// crossing and before her physics has swung it — Design's
    /// `16 * (1 - u) + 1.4 * u`, in scene units.
    ///
    /// It is named because it is the crossing itself, and her drift is laid over
    /// it rather than folded into it. Design's own amplitude for a gift is `0.9`
    /// against a landing radius of `1.4`, so a Śakti whose physics is Mahat's
    /// widening swings a gift further than the place it is landing in is wide —
    /// which is the room being hers, and is why the convergence is a fact about
    /// this number rather than about where a gift ends up.
    static func crossingRadius(at crossed: Double, figure: OuterRings.Figure) -> Double {
        let u = min(1, max(0, crossed))
        return figure.length(farRadius * (1 - u) + nearRadius * u)
    }

    /// Whether a place is on the room's own material at all.
    ///
    /// A surface coordinate outside `0…1` names a point past the edge of the
    /// stone. ``SurfaceCoordinate/clamped`` would put it on the rim, which is
    /// right for a mark that belongs in the room and wrong for one that has not
    /// arrived in it: twelve gifts clamped to an edge are a heap, and a heap is
    /// the same heap in every room of the ring.
    static func inTheRoom(_ place: OuterRings.Place) -> Bool {
        place.at.u >= 0 && place.at.u <= 1 && place.at.v >= 0 && place.at.v <= 1
    }

    // MARK: - Where one part of the room's work stands

    /// Where one gift stands at one moment of its crossing, or — at
    /// ``receivingIndex`` — the place they land in.
    ///
    /// Design's own placement is a spiral in the **horizontal plane** around the
    /// landing — `cos(a + u * 1.2) * r` in `x` and `sin(a + u * 1.2) * r` in `z`
    /// — with the fall in `y` and her physics on top of both.
    ///
    /// **The spiral's plane is the surface**, which is ``BodilessRoom``'s reading
    /// of Design's three axes and it holds for the same reason: a figure drawn
    /// lying down has `x` and `z` running along the stone and `y` leaving it.
    /// ``RoomUnits/axes(of:)`` is the instrument's general rule and it is right
    /// for a figure Design drew standing up; taken on a working face it would put
    /// the fall *across* the room instead of into it.
    ///
    /// **And the fall itself does not take the surface's own `outward`.** It is
    /// the arrival, not a direction — a gift falls toward the stone it is given
    /// into, and on a canopy that is upward. Her physics' off-plane term does take
    /// it, because a drift **is** a direction in the room, and which way *into*
    /// is, is still the instrument's: ``RoomUnits/SurfaceAxes/outward``, so
    /// rising off a floor and rising off a ceiling are the same fact seen from two
    /// sides.
    ///
    /// The landing carries no angle and no crossing. It is the still point, and
    /// its stillness is what the verb classifier reads.
    func place(index: Int, crossed u: Double, at chamberTime: TimeInterval,
               figure: OuterRings.Figure, stage: RoomStage,
               material: RoomMaterial) -> OuterRings.Place {
        let centre = stage.placement.coordinate
        guard index >= 0, index < Self.gifts else {
            // How far into the stone the landing has been borne: Design's own
            // `y - 1.4`, below her plane and therefore into the material.
            return OuterRings.Place(at: centre, into: -figure.length(Self.receivingDepth))
        }

        let axes = RoomUnits.axes(of: material.surface)
        let crossed = min(1, max(0, u))

        // Design's own placement, in her room: the spiral, closing on the
        // landing as it turns.
        let angle = Double(index) / Double(Self.gifts) * 2 * .pi + crossed * Self.turn
        let radius = Self.crossingRadius(at: crossed, figure: figure)

        // Her physics, at this gift's own turn of the twelve — Design's
        // `ph + i / 12`, read against her own kernel's turn rather than typed
        // (``OuterRings/spread(index:of:kind:)``). For every kind that does not
        // fold this is Design's number exactly; for the kinds that do, a literal
        // `i / 12` would make the twelve drift as six identical pairs.
        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime,
            phase: phase + OuterRings.spread(index: index, of: Self.gifts, kind: physics),
            amplitude: figure.length(Self.travel))

        let across = material.reach(worldUnits: radius * cos(angle) + drift.x)
        let along = material.reach(worldUnits: radius * sin(angle) + drift.z)
        return OuterRings.Place(
            at: SurfaceCoordinate(u: centre.u + across, v: centre.v + along),
            into: figure.length(Self.fallFrom - Self.fallBy * crossed)
                + drift.y * axes.outward)
    }
}
