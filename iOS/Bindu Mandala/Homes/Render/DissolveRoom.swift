import Foundation

// MARK: - RING 9 · khaḍgamālā position 102 · Lalitā Mahātripurasundarī · the Bindu
//
// Design's `chamberDissolve`, and the last of the eight rooms it authored by
// hand. The handoff names it apart from every other piece of work in the
// instrument:
//
//     Ring 9 (Mahātripurasundarī) should be built last and by hand.
//     *There was never anyone here but Her.*
//
// and the thread says what the room is:
//
//     | 9 | the Bindu | authored — the yantra turns inside out. |
//     | **Mahātripurasundarī** | No room. The enclosure is gone; the yantra is
//     | what you are inside. | yantra as geometry at nine depths |
//
// and what its second adaptation does:
//
//     *the bindu is where you are standing* — the yantra turns inside out and
//     grows past you; the point arrives at your position.
//
// ``HomeGrammar`` returns `nil` for ring 9 on purpose — ``HomeRooms/grammarRings``
// stops at 8, and `HomesCorpus.readings()` therefore counts 101 and not 102. The
// grammar **declines to speak for her**, so there is no `Reading` here, no
// physics kind, no phase and no archetype: every number below is Design's own,
// read off `homes-chambers.js`, and the room is reached by position through
// ``HomeRooms/authored``.
//
// ─────────────────────────────────────────────────────────────────────────────
// COULD THIS ROOM BELONG TO ANY OTHER ŚAKTI?
// ─────────────────────────────────────────────────────────────────────────────
//
// It is the one room in the hundred and two whose figure is **the instrument
// itself**. Ninety-nine other rooms lay out a figure of their own — a ring of
// eight effects, a train of lent capacity, a row of letters, two halves of a
// crossing. This room lays out the **yantra**: the nine enclosures the whole
// Mandala is built of, cut into the room's own stone, one inside the next, with
// her at the point they are all enclosures of.
//
// Design's own phrase for the instrument is *one building, ninety-nine
// reflections and the source* — and the figure comes out at exactly that.
// ``yantra`` is **ninety-nine marks**, and the hundredth is the source. That is
// not arranged: it is three squares of eight, two circles of twelve, sixteen
// petals, eight petals and nine triangles of three corners, which is
// 24 + 24 + 16 + 8 + 27, and `testTheFigureIsNinetyNineAndTheSource` holds it
// there so a later hand cannot quietly make it ninety-eight.
//
// No sister could stand in it. A Karṣiṇī's room crosses two faculties, an
// Anaṅga's holds an absence at its centre, a Mātṛkā's turns one letter at a time
// — and this one is the whole mandala with the walker outside it, looking in at
// the point at its far end, until the point turns out to be where he is standing.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE FOUR READINGS OF DESIGN THIS FILE MAKES
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · The yantra's plane is the surface, and Design's depth is the cut.**
//
// ``RoomUnits/axes(of:)`` is the instrument's general rule and it is right for a
// figure Design drew standing up and *facing* the walker: on a working face it
// maps Design's rise along the surface and its depth into it. Design's yantra
// is drawn that way — its loops are in `x`/`y` at nine values of `z`. But it is
// **concentric**, and a concentric figure carried through the general rule onto a
// floor loses its concentricity: Design's `y` becomes the axis that leaves the
// stone, and nine nested courts come back as nine nested ellipses flattened to
// lines. ``BodilessRoom`` made the mirror-image reading for the mirror-image
// reason — *"a bodiless ring is drawn lying down, so its two in-plane axes are
// the two that run along the stone"* — and this is the same sentence for a
// figure drawn standing up: **the yantra's own plane is whatever surface she is
// felt on**, its two in-plane axes are Design's `x` and `y`, and the one that
// leaves the plane — Design's `z`, the nine depths — is the one that runs
// **into** the material.
//
// So the nine depths become nine depths of cut. The bhūpura is scratched at the
// surface and the source is the deepest thing in the room, and what the key finds
// when it rakes across her floor is a yantra in stone.
//
// It also disposes of the axis trap that ran a whole procession backwards in
// ``EndlessRoom``: because the plane is declared rather than mapped, **no axis
// here has a surface-dependent sign at all**. The figure is the same figure on a
// floor, a canopy and a working face, and the two rotations that matter — the
// courts one way and the triangles the other, Design's `+0.0075` against its
// `-0.014` — keep their relation on every one of them.
//
// **2 · A court is drawn with marks, and how many says which court it is.**
//
// The vocabulary has no verb for a line (``EndlessRoom``, ``PressRoom``), so a
// closed outline is made of the verb there is, sampled round itself —
// ``TripleRoom``'s own reading, at its own proportion. A square is eight: its
// corners and the middle of its edges. A circle is **twelve and not eight**,
// because eight points on a circle stand at the same eight angles a square's do
// and the two courts would come back the same court rotated. The sixteen petals
// are sixteen and the eight are eight, one mark at each petal's own angle and
// its own mid-radius; the nine triangles are their corners, which is where a
// triangle is a triangle.
//
// **3 · A court leaves by going past the picture, not by going shallow.**
//
// Design's `yantra.position.z = b * 7.4` on a figure 8.4 deep carries the whole
// yantra **past the walker** — it grows to 3.1 times itself and it is gone. Here
// there is no camera to pass: the figure is cut into a surface. So it leaves the
// way a figure on a surface can leave, which is by opening out past the picture
// the walker is actually looking at, and its light goes with it —
// ``inPicture(radius:halfWidth:)``.
//
// It is a claim about **light and never about depth**. ``RingOne`` refused the
// other way once already, and the refusal is the instrument's: *"a mark that grew
// shallower would stop being seen while it was still there, which is a different
// thing from leaving."* The stone keeps every court that was ever cut into it, at
// its own depth, for the whole stay. What changes is how much of the figure is
// still in front of him.
//
// **4 · The source is a swell, and it is constructed rather than classified.**
//
// Every other mark in this room goes through ``OuterRings/mark(_:from:reach:size:travel:glow:material:)``
// and has its verb read off its own travel. The source does not, and the reason
// is arithmetic: the classifier reads a **speed**, and the source travels a fifth
// of a body over the two minutes of the second adaptation. At any rate a
// classifier can see, that is below ``RoomInscription/workingSpeed`` — it comes
// back a **compaction**, *"the mark of something that bore down without moving"*,
// which is ``BodilessRoom``'s absence and is the exact opposite of what this mark
// is doing.
//
// What it is doing is Design's own line: `bindu.position.z = -8.4 + b * 8.4` —
// it comes **out** of the depth of the figure to where the walker stands. Material
// coming out of the surface is a **swell** — *"raised from beneath: the material
// pushed out, never a thing set on top of it"* — and that is read from the sign
// of its own travel rather than assigned. ``TripleRoom`` constructs its one seal
// the same way and for the same kind of reason.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE LIGHT DOES, WHICH IS THE WHOLE SECOND ADAPTATION
// ─────────────────────────────────────────────────────────────────────────────
//
// Design fades the bindu's own glow as it arrives: `opacity = 0.95 * (1 - b * 0.55)`
// on a mark that is at the same time growing to 3.8 times itself. Read once, that
// looks like a mistake — the thing the room is about gets dimmer. It is the
// sentence. A point of light at the far end of a hall is something you are
// looking at; the same light arrived at where you are standing is something you
// are **inside**, and a light you are inside is not a light you see. Design's
// §4.4 says it for all hundred and two — *the attribute does not brighten into an
// object, it becomes the room* — and here it is said of the source itself.
//
// So past the second adaptation her room is: the courts gone past the edges of
// the picture, and one very wide, very quiet swell in the material at the place
// the walker is standing. *There was never anyone here but Her.*
struct DissolveRoom: RoomSurfaceMechanism {

    /// The ninth āvaraṇa, and the only seat in it. Position is the key; nothing
    /// here consults a name.
    static let ring = 9
    /// `khadgamalaPosition` 102 — the Bindu, and the last seat of the khaḍgamālā.
    static let position = 102

    // MARK: - Design's own numbers

    /// The bhūpura: Design's `[[13, 0], [11.6, -0.9], [10.2, -1.8]]` on
    /// `loop(sq(r), z, GOLD, 0.3 - i * 0.06)` — three squares, each a little
    /// smaller, a little deeper and a little fainter than the last.
    static let squares: [(radius: Double, depth: Double, opacity: Double)] = [
        (13, 0, 0.30), (11.6, -0.9, 0.24), (10.2, -1.8, 0.18),
    ]

    /// Design's two circles: `[[9, 56, -2.6], [8.1, 56, -3.1]]` at opacity 0.34.
    /// The 56 is how finely three.js draws a circle, not how many things stand
    /// on it.
    static let circles: [(radius: Double, depth: Double)] = [(9, -2.6), (8.1, -3.1)]
    static let circleOpacity: Double = 0.34

    /// Design's two petal rings: `petalRing(16, 6.4, 8.9, -3.6, 0.62)` and
    /// `petalRing(8, 4.9, 6.3, -4.4, 0.78)`, both at opacity 0.3.
    static let petalRings: [(count: Int, inner: Double, outer: Double, depth: Double)] = [
        (16, 6.4, 8.9, -3.6), (8, 4.9, 6.3, -4.4),
    ]
    static let petalOpacity: Double = 0.3

    /// Design's nine triangles — four standing on their base and five on their
    /// apex, each `[[0, ay], [ay * 0.92, base], [-ay * 0.92, base]]` at its own
    /// depth, `z = -5 - i * 0.55` and `-5.3 - i * 0.55`, at opacity 0.46. They
    /// are the brightest court in the figure and the deepest cut in it, which is
    /// Design's own arrangement: the triangles are where a Śrī Yantra is a Śrī
    /// Yantra.
    static let upward: [(span: Double, base: Double)] = [
        (5.5, -2.2), (4.4, -1.7), (3.4, -1.3), (2.3, -0.85),
    ]
    static let downward: [(span: Double, base: Double)] = [
        (5.5, -2.2), (4.7, -1.9), (3.9, -1.55), (3.0, -1.2), (1.9, -0.75),
    ]
    static let upwardFirst: Double = -5
    static let downwardFirst: Double = -5.3
    static let triangleStep: Double = -0.55
    static let triangleWidth: Double = 0.92
    static let triangleOpacity: Double = 0.46

    /// The source: Design's `bindu.position.z = -8.4`, its inner glow's span
    /// `sprite(glow('b1', …), 0xfff6de, 7.5, 0.95)`, and the pulse it keeps the
    /// whole stay, `0.85 + 0.2 * sin(t * 0.19)`.
    ///
    /// Design's second sprite — span 22 at opacity 0.3 — is a halo, which is
    /// light standing in the air. This instrument has exactly one of those and it
    /// is ``RoomLightRig``'s ember, which already stands at her placement in
    /// every one of the hundred and two rooms. A second one authored here would
    /// be the free-standing lit solid the renderer ruling exists to prevent.
    static let sourceDepth: Double = -8.4
    static let sourceRadius: Double = 7.5 / 2
    static let sourceLight: Double = 0.95
    static let sourceBreathRate: Double = 0.19
    static let sourceBreathFloor: Double = 0.85
    static let sourceBreathDepth: Double = 0.2

    /// **The turn.** Design's `yantra.rotation.z = t * 0.0075` and
    /// `tris.rotation.z = -t * 0.014`: the courts turn one way and the nine
    /// triangles turn the other, nearly twice as fast. Two rotations against
    /// each other, and neither of them fast enough to be a spin.
    static let yantraTurn: Double = 0.0075
    static let triangleTurn: Double = 0.014

    /// **The breath.** Design's `0.94 + 0.07 * sin(t * 0.115)` on the whole
    /// yantra's scale.
    static let yantraBreathRate: Double = 0.115
    static let yantraBreathFloor: Double = 0.94
    static let yantraBreathDepth: Double = 0.07

    /// **The turning inside out.** Design's `yantra.scale.setScalar(… * (1 + b * 2.1))`
    /// — the whole figure opens to three times itself as the premise turns.
    static let yantraOpens: Double = 2.1

    /// How far Design carries the yantra past the walker: `yantra.position.z = b * 7.4`,
    /// on a figure whose own depth is ``sourceDepth``. It is where ``becoming``'s
    /// `yields` comes from — the enclosure gives up all but a ninth of itself.
    static let yantraLeaves: Double = 7.4

    /// How far the source grows: Design's `bindu.scale.setScalar(… * (1 + b * 2.8))`.
    static let sourceGrows: Double = 2.8

    /// How far the source's own light falls as it arrives: Design's
    /// `(1 - b * 0.55)`. See the header — a light you are inside is not a light
    /// you see.
    static let sourceFades: Double = 0.55

    // MARK: - How large one mark of a court is

    /// ``TripleRoom``'s proportion, which is Design's seat radius over its own
    /// sample count at `2.4`: a closed outline drawn as marks needs each mark to
    /// be a fraction of the gap between them, or the court is a smear rather than
    /// a figure.
    static let markShare: Double = 2.4

    /// How large one mark of a court is, in Design's units — the smaller of what
    /// its own spacing allows and what its own court can hold.
    ///
    /// The second limb is ``BodilessRoom``'s finding, and it is here for the same
    /// reason: a **furrow** holds its whole depth for the length of its stroke
    /// and a **crack** is still at a quarter of its own where it closes, so both
    /// of them run ``SurfaceAction/cutoffReaches`` of their reach *along* the
    /// stroke. A mark sized only by its spacing makes a stroke longer than the
    /// court it stands on, and the outer bhūpura then writes across the triangles
    /// and the source. *A court's stroke closes on the court it stands on, and
    /// never across the figure.*
    static func part(spread: Double, count: Int) -> Double {
        guard count > 0 else { return 0 }
        return min(abs(spread) * markShare / Double(count),
                   abs(spread) / SurfaceAction.cutoffReaches)
    }

    // MARK: - The figure

    /// One mark of the yantra, in Design's own units.
    ///
    /// **There is no third coordinate here that could name a point in the air.**
    /// `depth` is Design's `z` and it becomes how far **into the material** the
    /// mark is cut (header, reading 1); `part` is how large it is; `counter` is
    /// the one court that turns against the rest.
    struct Inscribed: Equatable {
        let x: Double
        let y: Double
        let depth: Double
        let opacity: Double
        let part: Double
        /// True for the nine triangles, which turn Design's other way.
        let counter: Bool
    }

    /// **Ninety-nine marks**, which is the whole yantra bar the point it is a
    /// yantra of. See the header: three squares of eight, two circles of twelve,
    /// sixteen petals, eight petals and nine triangles of three corners.
    static let yantra: [Inscribed] = {
        var out: [Inscribed] = []

        // ── the bhūpura: three squares, each shallower than the next court in ──
        //
        // Eight marks: the four corners and the middle of each edge, which is
        // ``TripleRoom``'s own reading of how a closed outline is drawn with a
        // vocabulary that has no verb for a line.
        for court in squares {
            let size = part(spread: court.radius, count: squareSamples)
            for sample in 0..<squareSamples {
                let point = squareOutline(sample)
                out.append(Inscribed(x: point.x * court.radius, y: point.y * court.radius,
                                     depth: court.depth, opacity: court.opacity,
                                     part: size, counter: false))
            }
        }

        // ── the two circles ────────────────────────────────────────────────────
        //
        // **Twelve and not eight.** Eight points on a circle stand at the same
        // eight angles a square's eight do, and the two courts would come back as
        // one court drawn twice at two radii. Twelve is the next division that
        // shares nothing with four.
        for court in circles {
            let size = part(spread: court.radius, count: circleSamples)
            for sample in 0..<circleSamples {
                let angle = Double(sample) / Double(circleSamples) * 2 * .pi
                out.append(Inscribed(x: cos(angle) * court.radius,
                                     y: sin(angle) * court.radius,
                                     depth: court.depth, opacity: circleOpacity,
                                     part: size, counter: false))
            }
        }

        // ── the two lotuses ───────────────────────────────────────────────────
        //
        // One mark at each petal's own angle, standing at the middle of the
        // petal's own reach — Design's `rIn` to `rOut`. A petal is a shape with a
        // tip, and the vocabulary has no verb for a tip either; what a lotus is,
        // in this room, is a court with sixteen things on it rather than eight,
        // which is what tells it from the court outside it.
        for ring in petalRings {
            let middle = (ring.inner + ring.outer) / 2
            let size = part(spread: middle, count: ring.count)
            for index in 0..<ring.count {
                let angle = Double(index) / Double(ring.count) * 2 * .pi
                out.append(Inscribed(x: cos(angle) * middle, y: sin(angle) * middle,
                                     depth: ring.depth, opacity: petalOpacity,
                                     part: size, counter: false))
            }
        }

        // ── the nine triangles, at their own nine depths ──────────────────────
        //
        // Three marks each: the apex and the two corners of the base, which is
        // where a triangle is a triangle. They carry `counter`, so they turn
        // against every other court — Design's `-t * 0.014` against its
        // `+t * 0.0075`.
        let widest = max(upward.first?.span ?? 0, downward.first?.span ?? 0)
        let size = part(spread: widest, count: (upward.count + downward.count) * 3)
        for (index, triangle) in upward.enumerated() {
            let depth = upwardFirst + Double(index) * triangleStep
            for point in corners(of: triangle, pointingUp: true) {
                out.append(Inscribed(x: point.x, y: point.y, depth: depth,
                                     opacity: triangleOpacity, part: size, counter: true))
            }
        }
        for (index, triangle) in downward.enumerated() {
            let depth = downwardFirst + Double(index) * triangleStep
            for point in corners(of: triangle, pointingUp: false) {
                out.append(Inscribed(x: point.x, y: point.y, depth: depth,
                                     opacity: triangleOpacity, part: size, counter: true))
            }
        }
        return out
    }()

    /// How finely a square is drawn: its corners and its edges' middles.
    static let squareSamples = 8
    /// How finely a circle is drawn. See ``figure`` — twelve, so a circle is not
    /// a square in disguise.
    static let circleSamples = 12

    /// One point of a square's outline, `-1` to `1` on both axes.
    static func squareOutline(_ sample: Int) -> (x: Double, y: Double) {
        let corners: [(x: Double, y: Double)] = [(-1, -1), (1, -1), (1, 1), (-1, 1)]
        let steps = max(1, squareSamples / corners.count)
        let from = corners[(sample / steps) % corners.count]
        let to = corners[(sample / steps + 1) % corners.count]
        let along = Double(sample % steps) / Double(steps)
        return (x: from.x + (to.x - from.x) * along,
                y: from.y + (to.y - from.y) * along)
    }

    /// One triangle's three corners, in Design's own arrangement.
    static func corners(of triangle: (span: Double, base: Double),
                        pointingUp: Bool) -> [(x: Double, y: Double)] {
        let sign: Double = pointingUp ? 1 : -1
        return [(x: 0, y: sign * triangle.span),
                (x: triangle.span * triangleWidth, y: sign * triangle.base),
                (x: -triangle.span * triangleWidth, y: sign * triangle.base)]
    }

    /// The whole figure's width in Design's units — the outermost court, both
    /// ways off the centre. What ``OuterRings/Figure`` is asked to bring into the
    /// picture.
    static var spread: Double { (squares.first?.radius ?? 0) * 2 }

    // MARK: - What the premise becomes

    /// **The bindu is where you are standing.**
    ///
    /// The premise is the **enclosure**: nine courts standing around the walker
    /// with the source at the far end of them, and the thread's own line for the
    /// turn is *"the enclosure is gone"*. It yields by Design's own travel — the
    /// yantra is carried 7.4 past him out of a figure 8.4 deep, which is all but
    /// a ninth of itself — and what takes the work over is the **ground**, by
    /// Design's own word: *where you are standing*.
    ///
    /// The instrument's own law then does something this room wants rather than
    /// suffers. ``RoomReversal/stations(_:deep:bodyAltitude:)`` refuses to bring
    /// the ground toward the walker, because he is standing on it and nothing in
    /// the instrument moves the walker — so the answer arrives as **material**
    /// and not as a surface advancing on him. That is the sentence exactly: the
    /// source does not come at him, it turns out to have been underfoot.
    ///
    /// And the answering mark is this room's **own** (see ``actions(at:stage:)``),
    /// not ``RoomReversal``'s generic one, for ``TripleRoom``'s reason: a second
    /// lit disc on top of the source is the wash ``MatrkaRoom`` had to find with
    /// a picture.
    let becoming = HomeBecoming(premise: .wall, answer: .ground,
                                yields: DissolveRoom.yantraLeaves / abs(DissolveRoom.sourceDepth),
                                takes: DissolveRoom.sourceGrows)

    // MARK: - The two numbers that carry the room

    /// **How far open the yantra stands**, at one moment of the stay.
    ///
    /// Design's two lines multiplied, exactly as Design multiplies them:
    /// `(0.94 + 0.07 * sin(t * 0.115)) * (1 + b * 2.1)`. The breath is there the
    /// whole stay; the opening is the premise turning.
    static func opening(at chamberTime: TimeInterval, deep b: Double) -> Double {
        (yantraBreathFloor + yantraBreathDepth * sin(chamberTime * yantraBreathRate))
            * (1 + b * yantraOpens)
    }

    /// **How large the source stands**, at one moment of the stay. Design's
    /// `(0.85 + 0.2 * sin(t * 0.19)) * (1 + b * 2.8)`.
    static func swelling(at chamberTime: TimeInterval, deep b: Double) -> Double {
        (sourceBreathFloor + sourceBreathDepth * sin(chamberTime * sourceBreathRate))
            * (1 + b * sourceGrows)
    }

    /// **How much of a court the walker can still see**: `1` while it stands
    /// inside the picture, falling to `0` once it has opened to twice it.
    ///
    /// See the header, reading 3. It is a claim about light and never about
    /// depth: the stone keeps every court at its own depth for the whole stay,
    /// and what leaves is how much of the figure is still in front of him.
    static func inPicture(radius: Double, halfWidth: Double) -> Double {
        guard halfWidth > 0 else { return 0 }
        return 1 - RoomMaterial.smooth(radius / halfWidth - 1)
    }

    /// Half the picture the walker is looking at, where the room has come as near
    /// as it ever comes — the same bound ``OuterRings/Figure`` sizes the figure
    /// against, read at the same instant so the two cannot disagree.
    static func picture(bodyAltitude: Double) -> Double {
        let settled = RoomUnits.placement(bodyAltitude: bodyAltitude,
                                          chamberTime: HomeMemory.secondAdaptationEnd)
        return RoomUnits.visibleHalfWidth(atDistance: RoomUnits.distance(fromEyeTo: settled))
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let b = stage.deep
        let centre = stage.placement.coordinate

        let figure = OuterRings.Figure(ring: Self.ring,
                                       spread: Self.spread,
                                       part: Self.sourceRadius,
                                       on: material,
                                       bodyAltitude: stage.placement.bodyAltitude)
        let halfWidth = Self.picture(bodyAltitude: stage.placement.bodyAltitude)
        let open = Self.opening(at: chamberTime, deep: b)
        let share = OuterRings.lightShare(of: Self.yantra.count)
        // What the classifier reads a travel against: the whole depth of the
        // figure, which is the furthest anything in this room moves along the
        // surface's own normal.
        let travel = figure.length(abs(Self.sourceDepth))

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.yantra.count + 1)

        // ── the ninety-nine: the yantra, cut into her room's own stone ────────
        //
        // Each court at its own depth and its own light, turning — and the nine
        // triangles turning the other way. While the eye is settling they only
        // breathe; as the premise turns they open out, which the classifier reads
        // as marks **travelling across** the stone rather than standing in it. A
        // court held still and a court leaving are two different verbs, and
        // nothing here had to say which.
        for index in 0..<Self.yantra.count {
            let part = Self.yantra[index]
            let here = Self.place(index, at: chamberTime,
                                  figure: figure, centre: centre, material: material)
            let before = Self.place(index, at: chamberTime - OuterRings.readOver,
                                    figure: figure, centre: centre, material: material)

            // The whole figure scales together — Design's `yantra.scale` is on
            // the group — so a court's marks open out with the court they are
            // on. The floor is applied to the scaled size and never under it
            // (``OuterRings/reach(_:)``): a mark narrower than one cell of the
            // mesh is absent rather than faint, and a breath that dipped a mark
            // below the cell would put the figure out for part of every turn.
            let reach = min(OuterRings.widestMark,
                            OuterRings.reach(material.reach(worldUnits: figure.length(part.part * open))))

            // Design's own opacity for that court, shared among the ninety-nine,
            // and dimmed by however much of the court has opened past the
            // picture.
            let radius = figure.length((part.x * part.x + part.y * part.y).squareRoot() * open)
            let glow = part.opacity * share * Self.inPicture(radius: radius, halfWidth: halfWidth)

            marks.append(OuterRings.mark(here, from: before,
                                         reach: reach,
                                         // How deep this court is cut: its own
                                         // place among Design's nine depths. The
                                         // bhūpura is scratched at the surface
                                         // and the innermost triangle is nearly
                                         // as deep as the source.
                                         size: Self.cut(at: part.depth),
                                         travel: travel,
                                         glow: glow,
                                         material: material))
        }

        // ── and the hundredth: the source ────────────────────────────────────
        //
        // It stands where she is felt, which is where every attribute in the
        // instrument is mounted and where the ember already stands. While the eye
        // settles it is the deepest thing in the room — a point at the far end of
        // nine enclosures. As the premise turns it comes out of that depth to the
        // surface (Design's `-8.4 + b * 8.4`), opens to nearly four times itself,
        // and its own light falls away.
        //
        // A **swell**, constructed rather than classified: see the header,
        // reading 4.
        let swell = Self.swelling(at: chamberTime, deep: b)
        let sourceReach = min(OuterRings.widestMark,
                              OuterRings.reach(material.reach(
                                worldUnits: figure.length(Self.sourceRadius * swell))))
        marks.append(.swell(at: centre,
                            reach: sourceReach,
                            depth: RoomInscription.depth(size: 1, on: material),
                            glow: Self.sourceLight * (1 - b * Self.sourceFades)))

        return [surface: marks]
    }

    // MARK: - Where one mark of the yantra stands

    /// How deep a court is cut, `0` at the surface and `1` at the source —
    /// Design's own nine depths, normalised by the deepest of them.
    ///
    /// ``OuterRings/mark(_:from:reach:size:travel:glow:material:)`` holds a size
    /// at a fifth before it reaches ``RoomInscription/depth(size:on:)``, so even
    /// the outermost square stands clear of the stone's own banding. Nothing in
    /// this room is ever cut shallower than the grain, which is the finding
    /// ``CrossingRoom`` paid for — *"a mark shallower than the grain is a mark
    /// nobody can see"*.
    static func cut(at depth: Double) -> Double {
        guard sourceDepth != 0 else { return 1 }
        return min(1, max(0, depth / sourceDepth))
    }

    /// Where one of the ninety-nine stands at one moment.
    ///
    /// The figure turns — Design's `+t * 0.0075`, and the nine triangles at
    /// `-t * 0.014` — and it breathes and opens by ``opening(at:deep:)``. Its
    /// plane is the surface and its depth is the cut (header, reading 1), so
    /// there is no axis here whose sign a surface could invert.
    ///
    /// The moment's own `deep` is read from the clock rather than handed in,
    /// because this is called twice — now, and one of her own turns ago — and a
    /// reading taken at two instants with one room's `b` would say the figure had
    /// not moved when it had.
    static func place(_ index: Int, at chamberTime: TimeInterval,
                      figure: OuterRings.Figure, centre: SurfaceCoordinate,
                      material: RoomMaterial) -> OuterRings.Place {
        guard index >= 0, index < Self.yantra.count else {
            return OuterRings.Place(at: centre, into: 0)
        }
        let part = Self.yantra[index]
        let b = HomeGrammar.deepProgress(chamberTime: chamberTime)
        let open = opening(at: chamberTime, deep: b)
        let turn = chamberTime * (part.counter ? -triangleTurn : yantraTurn)
        let c = cos(turn), s = sin(turn)
        let x = (part.x * c - part.y * s) * open
        let y = (part.x * s + part.y * c) * open
        return OuterRings.Place(
            at: SurfaceCoordinate(u: centre.u + material.reach(worldUnits: figure.length(x)),
                                  v: centre.v + material.reach(worldUnits: figure.length(y))).clamped,
            into: figure.length(part.depth))
    }

    /// Where the source stands at one moment, along the surface's own normal:
    /// Design's `bindu.position.z = -8.4 + b * 8.4`, which is the deepest thing
    /// in the room coming out of the stone to the place the walker is standing.
    ///
    /// Read by the suite rather than by the room — the room constructs the swell
    /// directly (header, reading 4) — so that what moves is asserted rather than
    /// what merely stands somewhere.
    static func source(at chamberTime: TimeInterval) -> Double {
        sourceDepth * (1 - HomeGrammar.deepProgress(chamberTime: chamberTime))
    }
}
