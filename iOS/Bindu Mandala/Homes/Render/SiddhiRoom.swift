import Foundation

// MARK: - RING 1 · the ten Siddhis · the room that lends
//
// Design's `siddhi(world, card, G)`, built on the Phase 3.1 spine. Its own
// header is the whole design:
//
//     RING 1 · SIDDHI — the room grants her capacity, and asks nothing.
//     A power is not demonstrated at you; it is lent. Her one capacity operates
//     on the room itself while you stand in it.
//
// and the handoff (§4.3) says it in four words: *Siddhis lend a capacity.*
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM A SIDDHI AND NOT A MĀTṚKĀ OR A MUDRĀ
// ─────────────────────────────────────────────────────────────────────────────
//
// Ring 1 is three families and not one ring of twenty-eight, and the three must
// not blur. Design draws each of them as a different *arrangement in the room*,
// and the arrangement is the family:
//
//   · **the Siddhi** — one thing, and then the room doing the same thing, later
//     and further off. Design: a single `lent` form at the room's own centre and
//     six `echo` loops receding behind it, each running her physics at
//     `t - 0.6 - i * 0.5` — the *same motion, delayed*.
//   · the Mātṛkā — a closed ring of `n` letters standing around the walker, one
//     of which is being spoken at any instant.
//   · the Mudrā — five long vaults you stand between, opening.
//
// So the Siddhi's signature is **echo in depth**: seven marks on one line running
// away from the walker, every one of them her own motion at a different moment of
// its own past, growing as they recede. Nothing else in Ring 1 recedes, and
// nothing else repeats her.
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO READINGS OF DESIGN THIS FILE MAKES, AND WHY
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · The echoes are drawn, and only the lent capacity is lit.** Design's
// echoes are additive line loops whose opacity rises with the second adaptation
// (`(0.1 + 0.3 * k) * (1 - i / 8) * (1 + b * 1.4)`). A loop is a *line*, and
// ``CrossingRoom`` already had to settle what a line becomes here: a shape
// pressed into the stone and read by the room's own key raking across it, because
// a line lights nothing and a lit area erases relief rather than revealing it —
// which is the finding ``PressRoom`` wrote down and Design's own first Laghimā
// defect said twice. Seven lit discs receding down the middle of the floor is
// that failure in a third costume.
//
// So Design's `(1 + b * 1.4)` is spent on **how deep the room holds them** rather
// than on how brightly they burn. That is also the truer sentence: *the capacity
// was never lent* — the room takes it over by holding it, not by lighting up.
//
// **2 · The enclosure does not move.** Design fades its shell to a third
// (`shell.material.opacity = 1 - b * 0.7`). Fading is not a station, and the two
// stations an enclosure has in this instrument are already two other rooms'
// premises: closing in is Aṇimā's (``ContractRoom``) and departing is Laghimā's
// (``ReleaseRoom``). Borrowing either would make ten Siddhis look like one of the
// two authored rooms standing eight seats away, which is the one thing Ring 1's
// pass must not do. The giving-way this room needs is where Design's own second
// line puts it: `lent.scale.setScalar(1 - b * 0.8)`, and the ground taking the
// work over.
struct SiddhiRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 1–10. The only key.
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

    // MARK: - Design's own numbers

    /// Six. Design's `for (let i = 0; i < 6; i++)`.
    static let echoes = 6

    /// The capacity itself: Design's `OctahedronGeometry(1.5, 1)`.
    static let lentSize: Double = 1.5

    /// How large the room's first answer is, and how much larger each one after
    /// it: Design's loop radius `2.4 + i * 1.5`.
    static let echoSize: Double = 2.4
    static let echoSizeStep: Double = 1.5

    /// How far each answer stands behind the one in front of it: Design's
    /// `l.position.z = -9 - i * 2.4`, against the capacity's own `-9`.
    static let echoStep: Double = 2.4

    /// **The lag that makes this a room that lends rather than a room that
    /// repeats.** Design's `displace(kind, t - 0.6 - l.userData.i * 0.5, ph, 2.2)`
    /// — the room is doing what she did, a moment ago, and a moment further ago
    /// the further off it is.
    static let echoLag: TimeInterval = 0.6
    static let echoLagStep: TimeInterval = 0.5

    /// Design damps the echoes' travel along the room's own depth — `e[2] * 0.4`
    /// — so the train stays a train rather than shuffling through itself.
    static let echoDepthDamping: Double = 0.4

    /// Design's displacement amplitude for everything in this room —
    /// `displace(kind, …, 2.2)`.
    static let travel: Double = 2.2

    /// How far back each answer stands: Design's `(1 - i / 8)`, which leaves the
    /// sixth at a quarter of the first.
    static let echoRecedes: Double = 1.0 / 8.0

    /// **How much deeper the room holds the capacity once the premise turns.**
    /// Design's `(1 + b * 1.4)` on the echoes' opacity, spent on depth — see the
    /// header, reading 1.
    static let echoDeepens: Double = 1.4

    /// Design's own emissive ramp on the capacity, `2.4 + k * 1.6 + b * 2.4`,
    /// against its own ceiling of 6.4 so it reads as a share of the light rather
    /// than as a three.js intensity.
    static let lentBurnsCeiling: Double = 2.4 + 1.6 + 2.4
    static let lentBurnsAtRest: Double = 2.4
    static let lentBurnsSettling: Double = 1.6
    static let lentBurnsDeep: Double = 2.4

    // MARK: - What the premise becomes

    /// **The capacity was never lent.** Design's own deep sentence, and its two
    /// numbers: `lent.scale.setScalar(1 - b * 0.8)` — what was held out in front
    /// of her shrinks to nothing — and what is left is what she was standing on
    /// all along.
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which is where the ten archetype
    /// reversals are, so this room and the grammar agree about the Siddhi's turn
    /// by construction rather than by two people writing down the same numbers.
    var becoming: HomeBecoming { .archetype(.siddhi) }

    /// How completely the capacity shrinks — ``HomeBecoming/yields``, which for
    /// this archetype is Design's `1 - b * 0.8`.
    var lentShrinks: Double { becoming.yields }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        // The whole figure — the capacity, and the train of answers behind it —
        // brought onto the surface it is happening to.
        let figure = RingOne.Figure(spread: Double(Self.echoes) * Self.echoStep,
                                    part: Self.echoSize
                                        + Double(Self.echoes - 1) * Self.echoSizeStep,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)
        let travel = figure.length(Self.travel)
        let share = RingOne.lightShare(of: Self.echoes + 1)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.echoes + 1)

        // ── the capacity, lent ──────────────────────────────────────────────
        //
        // One mark, at her own place in the room, moving on her own physics from
        // the first moment. It is the room's premise: a thing held out in front
        // of her, asking nothing.
        //
        // **It shrinks and brightens at the same time**, which is Design's two
        // lines side by side and is also what keeps the room readable: the lit
        // area falls by five while the light in it rises by less than two, so the
        // brightest moment of the stay is the smallest the mark has ever been.
        // A light that grew instead is the pale structureless wash ``PressRoom``
        // and ``CrossingRoom`` each had to find with a picture.
        let shrink = 1 - b * lentShrinks
        let here = place(step: 0, at: chamberTime, figure: figure, stage: stage, material: material)
        let before = place(step: 0, at: chamberTime - RingOne.readOver,
                           figure: figure, stage: stage, material: material)
        let burns = (Self.lentBurnsAtRest
                     + Self.lentBurnsSettling * k
                     + Self.lentBurnsDeep * b) / Self.lentBurnsCeiling
        marks.append(RingOne.mark(here, from: before,
                                  // **The shrink is applied after the figure's own
                                  // floor and never under it** (``RingOne/reach(_:)``):
                                  // a capacity held open at one mesh cell is a
                                  // capacity that was never lent, which is this
                                  // room's whole premise reversed back again.
                                  reach: figure.reach(Self.lentSize) * shrink,
                                  size: 1,
                                  travel: travel,
                                  glow: burns * share,
                                  material: material))

        // ── and the room's answer: it does the same thing, later ────────────
        //
        // Six marks receding from hers, each carrying her own motion at a
        // different moment of its own past and each wider than the one in front
        // of it. They are not a decoration of the capacity — they are the room
        // performing it, which is why they are still there, and deeper, after the
        // capacity itself has gone.
        for step in 1...Self.echoes {
            let index = Double(step - 1)
            let here = place(step: step, at: chamberTime,
                             figure: figure, stage: stage, material: material)
            let before = place(step: step, at: chamberTime - RingOne.readOver,
                               figure: figure, stage: stage, material: material)
            // Design's own falling-back, and his own deepening past the turn.
            let recedes = max(0.2, 1 - index * Self.echoRecedes)
            marks.append(RingOne.mark(here, from: before,
                                      reach: figure.reach(Self.echoSize
                                                          + index * Self.echoSizeStep),
                                      size: recedes * (1 + b * Self.echoDeepens),
                                      travel: travel,
                                      glow: 0,
                                      material: material))
        }

        // …and the archetype's own reversal on top: the ground she was standing
        // on all along, taking the work over.
        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: marks)
        return out
    }

    // MARK: - Where one mark of the train stands

    /// Where the capacity (`step` 0) or one of the room's six answers stands at
    /// one moment, in the coordinates of the surface it is happening to.
    ///
    /// Design's own placement is a straight line running away from the walker —
    /// `-9 - i * 2.4` — and her physics on top of it at her own phase, delayed by
    /// the answer's own lag. Which of Design's three axes runs along the surface
    /// and which runs into it is ``RoomUnits/axes(of:)``: on a floor or a canopy
    /// the train recedes, and on a working face it climbs, because a face has no
    /// depth to recede along and the surface's own way out of reach is up.
    func place(step: Int, at chamberTime: TimeInterval,
               figure: RingOne.Figure, stage: RoomStage,
               material: RoomMaterial) -> RingOne.Place {
        let index = Double(max(0, step))
        let axes = RoomUnits.axes(of: material.surface)
        let travel = figure.length(Self.travel)

        // Her physics, at this answer's own moment of her past.
        let lag = step == 0 ? 0 : Self.echoLag + Double(step - 1) * Self.echoLagStep
        let drift = HomeGrammar.displace(physics,
                                         time: chamberTime - lag,
                                         phase: phase,
                                         amplitude: travel)
        let damp = step == 0 ? 1 : Self.echoDepthDamping

        // Design's line, from where her mark already falls.
        let run = figure.length(Self.echoStep * index)
        let centre = stage.placement.coordinate
        let u = material.reach(worldUnits: axes.across(drift))
        let v = material.reach(worldUnits: axes.along(design: -run, rise: run)
                               + axes.along(drift) * damp)
        return RingOne.Place(at: SurfaceCoordinate(u: centre.u + u, v: centre.v + v).clamped,
                             into: axes.into(drift) * damp)
    }
}
