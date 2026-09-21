import Foundation

// MARK: - RING 2 · the sixteen Karṣiṇīs · the room that crosses
//
// Design's `crossed(world, card, G, syllable, cross)`, built on the Phase 3.1
// spine. It is the **home ring**: the sixteen rooms with the most standing in
// them, and the one ring whose rows ship inside the binary and sync from the
// base, so everything below is tuned against her real quality, tattva, bodily
// location and bīja rather than against a card typed out here.
//
// Design's own header on that builder is the whole design:
//
//     RING 2 · CROSSED — she draws one faculty and is given another organ.
//     So: the room PRESENTS one sense and ANSWERS in the other, and the two
//     halves are not aligned until the second adaptation.
//
// and the handoff (§4.3.1) says the mechanism in one line: *"two halves running
// her physics in opposite phase, converging only at the second adaptation."*
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ORDERING FINDING, AND WHY HER TATTVA IS WHAT CLAIMS HER
// ─────────────────────────────────────────────────────────────────────────────
//
// The classifier's fifty rules are in Design's load-bearing order, and the
// twelfth of them is `ākarṣaṇa|karṣaṇa|magnet|attract` → ``HomePhysics/draw``.
// **Every one of the sixteen says "she who attracts"** — it is what Ākarṣiṇī
// means, and the base writes it into all sixteen qualities. The five element
// rules stand at six through ten, two rules in front of it.
//
// So a Karṣiṇī whose tattva names an element is claimed by her element, and one
// whose tattva names something the classifier has no element for falls through
// to the drawing they all share. Read against the shipped sixteen that is:
//
//   · flare — Kāma 29, Rūpā 34, Bījā 41 (Fire)
//   · lift — Buddhyā 30, Sparśā 33 (Air)
//   · open — Ahaṅkārā 31, Śabdā 32, Nāmā 40 (Space)
//   · well — Rasā 35, Smṛtyā 39 (Water)
//   · settle — Gandhā 36, Dhairyā 38, Śarīrā 44 (Earth)
//   · draw — Cittā 37 (Cit), Ātmā 42 (Sat), Amṛtā 43 (Amṛta)
//
// which is to say **her tattva is what actually claims her**, and the three whose
// tattva is not an element are left holding the ring's own gesture — the drawing
// itself — which is the truthful answer for Consciousness, the Self and the
// Deathless rather than a gap. Nothing here overrides the classifier to make the
// sixteen look more various than the base says they are.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THIS FILE DOES NOT DO
// ─────────────────────────────────────────────────────────────────────────────
//
// It builds no object. Under the renderer ruling a mechanism can return actions
// on the room's own material and distances for the surfaces the room already
// has, and that is all this file returns. The two halves are not fourteen lit
// sprites hung in the air — Design's are — they are fourteen things **happening
// to her working surface**: a stone that is being pressed, drawn across, raised
// and borne down on in two counterposed rhythms until the two rhythms are one.
// `testNoCrossingMountsASolidInHerLayer` holds it over all sixteen.
//
// And it assigns no verb. Which of the five each mark performs is read from its
// own travel through ``RoomInscription/verb(for:previous:)`` — the classifier the
// attribute layer already uses — so the ring's vocabulary is a consequence of her
// physics rather than a table somebody chose.
struct CrossingRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 29–44. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the sixteen — Design's `(card.pos % 16) / 16`.
    let phase: Double
    /// kp 44, Śarīrākarṣiṇī: body and mind at the exact same point, marked in
    /// the base as **THE KEY PAIRING** and named as the key in Design's own
    /// builder (`const isKey = card.pos === 44`).
    let isKey: Bool

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
        self.isKey = reading.position == CrossingRoom.keyPosition
    }

    /// Design's key pairing, by position and never by name.
    static let keyPosition = 44

    // MARK: - Design's own numbers

    /// Seven a side. Design's `for (let i = 0; i < 7; i++)`, twice.
    static let marksPerHalf = 7

    /// The arc the halves stand on: `a = -0.8 + (i / 6) * 1.6`.
    static let sweep: Double = 1.6

    /// **The lag that keeps the two halves from being one half seen twice.**
    ///
    /// Design's `displace(kind, t + 3.2, …)`, and it is load-bearing in a way its
    /// own file does not say out loud: the counter-phase alone is not enough.
    /// Half the kernel's fifty kinds move on `|sin|`, whose period is half a
    /// turn, so a half-turn of phase returns *exactly the same number* — Earth's
    /// settling, Water's welling, and the drawing the last three share are all
    /// like that. Without the lag the answering half of Gandhā's room, and of
    /// Rasā's, and of Śarīrā's, would sit on top of the presenting half from the
    /// first moment and the room would have no crossing in it at all.
    static let answerLag: TimeInterval = 3.2

    /// Design's `ph + 0.5` — the far half a half-turn out of step.
    static let counterPhase: Double = 0.5

    /// Design's own per-mark spread within a half: `ph + i / 14`, fourteen being
    /// the two halves' marks counted together.
    static let spreadDivisor: Double = 14

    /// The near half — what she draws. Formed, and addressed to the walker.
    /// Design: `m.position.set(sin(a) * 2.6, y + 0.6, -5 + cos(a) * 0.6)`.
    static let presentingAcross: Double = 2.6
    static let presentingAlong: Double = 0.6
    static let presentingRise: Double = 0.6
    static let presentingDepth: Double = -5

    /// The far half — the organ she was given. Offset, other, in counterpoint.
    /// Design: `s.position.set(sin(a) * 3.4, y - 0.8, -6.4 + cos(a) * 0.8)`.
    static let answeringAcross: Double = 3.4
    static let answeringAlong: Double = 0.8
    static let answeringRise: Double = -0.8
    static let answeringDepth: Double = -6.4

    /// How large each mark of the near half is: Design's torus radii,
    /// `0.7 + i * 0.16`.
    static let presentingSizeAtCentre: Double = 0.7
    static let presentingSizeStep: Double = 0.16

    /// …and of the far half: `sprite(…, 1.4, 0.4)`, one size for all seven.
    static let answeringSize: Double = 1.4

    /// How far the far half grows as it takes the room over —
    /// `s.scale.setScalar(1.4 * (1 + b * (isKey ? 2.6 : 1.2)))`.
    ///
    /// **Where that growth is spent is the one real decision in this file.**
    /// Design's number is a *scale on a glow sprite*, and Design's own sentence
    /// for it is "the organ she was given grows until it is the room around him".
    /// Spent literally, the far half's mark ends the stay a quarter of the
    /// surface across with its own light on all of it — and looking at that is
    /// conclusive: seven of them converging made a pale structureless mass across
    /// the middle of the frame with every ring she had pressed lost inside it.
    /// It is the finding ``PressRoom`` already wrote down in this instrument —
    /// *"a lit area erases relief rather than revealing it"* — arriving a second
    /// time, and Design's own first Laghimā defect arriving a third.
    ///
    /// So the growth is spent where Design's sentence actually points: on **the
    /// room**. It is the enclosure that departs by this number
    /// (``becoming``), which is ``RoomReversal``'s own rule that an enclosure
    /// answers by moving rather than by being marked, and it is the key pairing's
    /// enclosure that goes furthest. What is left for the mark itself is the
    /// instrument's own saturating fraction of it — a mark half again as wide by
    /// the end of the stay, and still a mark.
    static let answeringGrows: Double = 1.2
    static let keyAnsweringGrows: Double = 2.6

    /// Design's own opacities.
    /// Near: `(0.26 + 0.34 * k) * (1 - b * 0.3)` — what she drew fades from in
    /// front of her. Far: `(0.24 + 0.34 * k) * (1 + b * 0.8)` — the organ she was
    /// given brightens as it arrives.
    static let presentingFloor: Double = 0.26
    static let answeringFloor: Double = 0.24
    static let settlingLift: Double = 0.34
    static let presentingFades: Double = 0.3
    static let answeringBrightens: Double = 0.8

    /// **The near half is drawn, and the far half is lit.**
    ///
    /// Design says which is which in the materials rather than in a comment: the
    /// near half is seven `TorusGeometry` rings with a tube radius of 0.028 on a
    /// `MeshBasicMaterial`, and the far half is seven glow sprites. A tube of
    /// 0.028 in a petal of 11 is a **line**, and a line lights nothing; a glow
    /// sprite is a light and nothing else. Carried across, the near half is a
    /// shape pressed into her wall — read by the room's own key raking across it,
    /// exactly as ``PressRoom``'s bedding is read — and the light in the room is
    /// the far half, arriving.
    ///
    /// Which also makes the reversal legible *in light* and not only in
    /// geometry: what she drew is dark and formed, what she was given is the only
    /// thing burning, and by the end of the stay the burning is standing exactly
    /// where the drawing is.
    static let presentingIsLit = false

    /// One mark's share of the light, so that seven converging on seven do not
    /// stack to a flat field. The same root ``RoomInscription`` shares one mark's
    /// worth of material among a rosary's twenty-seven beads by, for the same
    /// reason and by the same arithmetic.
    static let lightShare: Double = 1 / Double(marksPerHalf).squareRoot()

    /// **The room she is actually standing in, against the room Design drew.**
    ///
    /// Design's petal is a sphere of radius 11 inside walls thirteen tall, and
    /// every number above is a length in that room. Carried as a *proportion* —
    /// the same discipline ``PressRoom`` carries its slab by — against the one
    /// thing the two rooms both have, which is a body's height: Design's is
    /// thirteen and this one is ``RoomUnits/roomHeight``.
    ///
    /// **Against the body and not against the surface**, and the difference is
    /// the whole legibility of the ring. A Karṣiṇī's working surface is her own
    /// face, one body square, and the floor and the ceiling are four bodies
    /// across; reading Design's numbers as fractions of *the surface* made the
    /// same arc four times smaller on a ceiling than on a face, and on a face it
    /// made every ring she presses shallower than the stone's own grain — which
    /// is a mark that cannot be seen, in a room whose only content is marks.
    /// Looking at it was conclusive: seven rings, buried.
    static let designRoomHeight: Double = 13

    /// A length in Design's room, in this one's scene units.
    static func inRoom(_ designUnits: Double) -> Double {
        designUnits / designRoomHeight * RoomUnits.roomHeight
    }

    /// Design's displacement amplitude for both halves — `displace(kind, …, 1.2)`
    /// — in the room's own units rather than hers.
    static let travel: Double = 1.2 / designRoomHeight * RoomUnits.roomHeight

    /// The largest multiple of its own amplitude the displacement kernel puts on
    /// any one axis, so that a depth read off the kernel can be normalised
    /// against what the kernel can actually produce rather than against the
    /// amplitude it was given.
    ///
    /// Read from ``HomeGrammar/widestTerm``, which is where the kernel is: Ring
    /// 1's three families need the same number for the same reason, and the
    /// instrument has already paid once for a table that was written down twice.
    /// `testTheKernelNeverExceedsItsWidestTerm` holds it over all fifty-one
    /// kinds, so a new kind that reached further would fail there rather than
    /// quietly rail a ring's marks.
    static let kernelWidest: Double = HomeGrammar.widestTerm

    /// **How long a reading of a half is taken over, and why it is not a quarter
    /// of a second.**
    ///
    /// ``RoomInscription`` reads a moving part over ``RoomInscription/sampleGap``
    /// because Design's twenty-six attribute forms are *gestures* — a noose
    /// casting, a lotus opening — and a gesture moves at the rate a quarter of a
    /// second can see. Her physics does not. The displacement kernel's terms turn
    /// at between 0.03 and 0.6 radians a second, so a mark sampled at a gesture's
    /// rate has barely moved, every one of the fifty kinds classifies below
    /// ``RoomInscription/workingSpeed``, and the whole ring comes back as one verb
    /// — which is the ring having no physics.
    ///
    /// So the halves are read across a quarter of the first adaptation, which is
    /// the interval her own kernel turns in. The classifier is unchanged and
    /// still reads the travel rather than a name; what changes is the clock the
    /// travel is read on, and the clock is hers.
    static let readOver: TimeInterval = HomeMemory.firstAdaptation / 4

    // MARK: - What the premise becomes

    /// **The crossing, reversed.** Design's own deep sentence for this archetype
    /// is *"the drawing and the drawn are one"*, and at the key pairing *"body
    /// and mind were one point"*.
    ///
    /// The premise is carried by the working face — the near half, formed and
    /// held out in front of her — and it is answered by the enclosure, because
    /// Design's answering half *"grows until it is the room around him"*. The
    /// numbers are read off its `update(t)`: `(1 - b * 0.3)` on the near half's
    /// opacity, and the far half's growth on its scale.
    ///
    /// At the key pairing the growth is Design's larger one, so Śarīrā's
    /// enclosure goes furthest of the sixteen. That is the one place in this ring
    /// where a room is given more than her sisters, and it is Design's own
    /// `isKey`, not a preference.
    var becoming: HomeBecoming {
        HomeBecoming(premise: .face,
                     answer: .wall,
                     yields: Self.presentingFades,
                     takes: -(isKey ? Self.keyAnsweringGrows : Self.answeringGrows))
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.marksPerHalf * 2)

        // ── the near half — what she draws ──────────────────────────────────
        //
        // Present from the first moment, at her own phase, on her own physics.
        // It is the room's premise: a thing formed and held out in front of her.
        var presenting: [Place] = []
        presenting.reserveCapacity(Self.marksPerHalf)
        for index in 0..<Self.marksPerHalf {
            let here = place(index: index, answering: false, at: chamberTime,
                             surface: surface, material: material)
            let before = place(index: index, answering: false,
                               at: chamberTime - Self.readOver,
                               surface: surface, material: material)
            presenting.append(here)
            marks.append(mark(here, from: before,
                              size: Self.presentingSizeAtCentre
                                  + Double(index) * Self.presentingSizeStep,
                              glow: Self.presentingIsLit
                                  ? (Self.presentingFloor + Self.settlingLift * k)
                                      * (1 - b * Self.presentingFades) * Self.lightShare
                                  : 0,
                              material: material))
        }

        // ── the far half — the organ she was given ──────────────────────────
        //
        // Offset, other, and a half-turn plus Design's lag out of step with the
        // near half — and **converging**. At the second adaptation it arrives
        // exactly where the near half is, and the two rhythms that were a
        // counterpoint for the whole of the first adaptation are one rhythm.
        // That is the room's reversal in its own material, under the enclosure
        // leaving in ``becoming``.
        // What Design's growth leaves for the mark: the instrument's own
        // saturating fraction of it, which is the law that already holds every
        // answering surface short of the walker. The rest of the growth is the
        // enclosure's, in ``becoming``.
        let grows = RoomReversal.answeringFraction(takes: becoming.takes)
        for index in 0..<Self.marksPerHalf {
            let free = place(index: index, answering: true, at: chamberTime,
                             surface: surface, material: material)
            let earlier = place(index: index, answering: true,
                                at: chamberTime - Self.readOver,
                                surface: surface, material: material)
            let here = free.converged(onto: presenting[index], by: b)
            let before = earlier.converged(onto: presenting[index], by: b)
            marks.append(mark(here, from: before,
                              size: Self.answeringSize * (1 + b * grows),
                              glow: (Self.answeringFloor + Self.settlingLift * k)
                                  * (1 + b * Self.answeringBrightens) * Self.lightShare,
                              material: material))
        }

        // …and whatever her archetype's own reversal does on top, which for a
        // room whose answer is the enclosure is nothing in material: a wall is
        // not marked, it moves, and it moves through ``stations(at:stage:)``.
        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - Where one mark of one half stands

    /// One mark of one half, in the coordinates of the surface it is happening
    /// to: two numbers along the surface, and one across it.
    ///
    /// **There is no third axis here that could name a point in the air.** `into`
    /// is not a height — it is how far the half's own travel has carried it
    /// against the material, which is how deep the mark it is making goes. A
    /// mark's place is still two numbers on a surface, exactly as
    /// ``SurfaceCoordinate`` allows and no further.
    struct Place: Equatable {
        var at: SurfaceCoordinate
        /// How far the half has travelled along the surface's own normal, in
        /// scene units. Negative is into the material.
        var into: Double

        func converged(onto target: Place, by amount: Double) -> Place {
            let b = min(1, max(0, amount))
            return Place(at: SurfaceCoordinate(u: at.u * (1 - b) + target.at.u * b,
                                               v: at.v * (1 - b) + target.at.v * b),
                         into: into * (1 - b) + target.into * b)
        }
    }

    /// Where one mark of one half stands at one moment: Design's own base
    /// position on the arc, plus her physics at that mark's own phase.
    func place(index: Int, answering: Bool, at chamberTime: TimeInterval,
               surface: RoomSurfaceKind, material: RoomMaterial) -> Place {
        let steps = Double(max(1, Self.marksPerHalf - 1))
        let a = -Self.sweep / 2 + (Double(index) / steps) * Self.sweep

        // Design's own placement, in her room.
        let across = (answering ? Self.answeringAcross : Self.presentingAcross) * sin(a)
        let along = (answering ? Self.answeringDepth : Self.presentingDepth)
            + (answering ? Self.answeringAlong : Self.presentingAlong) * cos(a)
        let rise = answering ? Self.answeringRise : Self.presentingRise

        // …and her physics on top of it, in ours. The far half runs at Design's
        // lag and a half-turn of counter-phase; the near half runs at hers.
        let spread = Double(index) / Self.spreadDivisor
        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime + (answering ? Self.answerLag : 0),
            phase: phase + spread + (answering ? Self.counterPhase : 0),
            amplitude: Self.travel)

        // Which of Design's three axes runs along the surface and which runs
        // into it is the one thing a floor and a wall disagree about, and it is
        // settled here rather than in fourteen places.
        let axes = Self.axes(of: surface)
        let u = material.reach(worldUnits: Self.inRoom(across) + axes.across(drift))
        let v = material.reach(worldUnits: Self.inRoom(axes.along(design: along, rise: rise))
                               + axes.along(drift))
        return Place(at: SurfaceCoordinate(u: 0.5 + u, v: 0.5 + v).clamped,
                     into: axes.into(drift))
    }

    /// One mark, as one action on the material.
    ///
    /// The verb is ``RoomInscription``'s, read from this mark's own travel over
    /// her own clock; the depth is the instrument's own mark depth, shared out
    /// among the fourteen exactly as ``RoomInscription`` shares one mark's worth
    /// among a rosary's beads; and the light is the surface's, which is to say it
    /// exists exactly as far as the surface moved.
    func mark(_ here: Place, from before: Place,
              size: Double, glow: Double, material: RoomMaterial) -> SurfaceAction {
        let reach = material.reach(worldUnits: Self.inRoom(size))

        // How far this half's travel has carried it against the stone. A mark
        // driven into the material is deeper; one drawn back out of it is
        // shallower, to nothing.
        //
        // **Read against the kernel's own widest term rather than against the
        // amplitude it was handed**, and that is not a nicety. The kernel
        // multiplies its amplitude by as much as 2.2, so a normalisation by the
        // amplitude alone leaves the fast axes railed at ±1 for most of every
        // turn — and a mark that is railed has stopped carrying her phase at
        // all. Measured, it was Cittā and Ātmā it cost: both drawing, both felt
        // on a working face, their halves pinned to the same two depths for most
        // of the stay and their rooms 4% apart on the geometric fingerprint, well
        // under Design's tenth. Against the widest term nothing rails and her
        // turn of the sixteen is in the stone at every moment of the stay.
        let pressed = min(1, max(-1, -here.into / max(Self.travel * Self.kernelWidest, 0.0001)))

        // One mark's depth, and **never more than one mark's worth**:
        // ``RoomInscription/markDepth`` is the instrument's own answer to how
        // deep anything may go, and fourteen marks do not get fourteen answers.
        // Deep enough to be read over the stone's own grain, which stands a
        // fortieth of a body high — a mark shallower than the grain is a mark
        // nobody can see.
        let relative = min(1, max(0.2, size / Self.answeringSize))
        let depth = RoomInscription.markDepth * relative * (0.55 + 0.45 * pressed)

        let motion = Self.motion(here, span: material.span)
        let previous = Self.motion(before, span: material.span)
        switch RoomInscription.verb(for: motion, previous: previous) {
        case .impression: return .impression(at: here.at, reach: reach, depth: depth, glow: glow)
        case .furrow:     return .furrow(at: here.at, reach: reach, depth: depth, glow: glow)
        case .crack:      return .crack(at: here.at, reach: reach, depth: depth, glow: glow)
        case .swell:      return .swell(at: here.at, reach: reach, depth: depth, glow: glow)
        case .compaction: return .compaction(at: here.at, reach: reach, depth: depth, glow: glow)
        }
    }

    /// A mark's place, as the classifier reads a moving part: `y` is always the
    /// way out of the material, so *down onto the stone* means the same thing on
    /// a floor, a ceiling and a wall.
    ///
    /// **In scene units, and the conversion is not cosmetic.**
    /// ``RoomInscription/workingSpeed`` and ``RoomInscription/strikeSpeed`` are
    /// distances the room is measured in; a surface coordinate is a fraction of a
    /// surface, and the two surfaces a Karṣiṇī can stand at differ by a factor of
    /// four in span. Handing the classifier fractions would make the same travel
    /// read as four different speeds depending on where on her body she is felt.
    static func motion(_ place: Place, span: Double) -> AttributeMotion {
        AttributeMotion(x: place.at.u * span, y: place.into, z: place.at.v * span)
    }

    // MARK: - Design's room, in this one

    /// Which way is which, on one surface — ``RoomUnits/axes(of:)``.
    ///
    /// It moved there when Ring 1's three families needed the same answer: a
    /// floor and a ceiling run away from the walker and a working face runs up,
    /// and that is a fact about the room's coordinate system rather than about
    /// this ring. The name is kept here because the crossing's own reading of
    /// Design's three axes is what the ring's tests speak in.
    typealias Axes = RoomUnits.SurfaceAxes

    static func axes(of surface: RoomSurfaceKind) -> Axes { RoomUnits.axes(of: surface) }
}
