import Foundation

// MARK: - SARVA-TRIKHAṆḌĀ · khaḍgamālā position 28 · three rooms in one place
//
// Design's `chamberTriple`, built on the Phase 3.1 spine. Authored by hand,
// reached through ``HomeRooms/authored`` **by position**, and accepted under
// Ruling 10 without a grammar-only proof. Design's own comment is the mechanism:
//
//     Three rooms in one place. In the axis this is done as three tinted shells
//     that slide into register, so it stays single-pass and the travel never cuts.
//     // the trinity is one MOVEMENT, not a puzzle that resolves. Past the second
//     // adaptation the seal stops arriving and begins to breathe.
//
//     three rooms · one seal, only in stillness
//     three and one, and always both
//
// Sarva-Trikhaṇḍā is *Trinity-as-Unity* — `Tri-eka`, three-as-one. Design's own
// `BY_NAME` keys this room as `Sarvatrikhaṇḍā` against a card reading
// `Sarva-Trikhaṇḍā`, so in its shipped Axis the room is never reached. By
// position it cannot be missed.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE MECHANISM, AND THE ONE NUMBER THAT CARRIES ALL OF IT
// ─────────────────────────────────────────────────────────────────────────────
//
// `sep` — how far apart the three stand:
//
//     const settled = 1 - smooth(t / 62);
//     const breath  = (0.5 + 0.5 * sin((t - HOLD_END) * 0.085)) * 0.58;
//     const sep     = settled * (1 - b) + breath * b;
//
// While the eye is settling the three slide **into register**: `sep` runs from 1
// to 0 over the first adaptation, the three ghosts converge, and the one seal
// arrives (`one.opacity = (1 - sep) * 0.95`). Everything about the room's premise
// is in that: *three rooms · one seal, only in stillness* — the unity is
// something that happens when you stop.
//
// And then the premise turns, and it is not that the three become one for good.
// `sep` hands over from the settling to a **breath**, and the three begin to part
// and rejoin, for ever: *three and one, and always both.* That is the sharpest
// reversal in Ring 1 — the room does not resolve, it stops pretending it was
// going to.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES IT A MUDRĀ AND NOT A MĀTṚKĀ
// ─────────────────────────────────────────────────────────────────────────────
//
// It is a **sealing**: three figures closing onto one seal. A Mātṛkā's ring goes
// round and a Siddhi's train recedes; nothing here does either. What this room
// does that no other room in the instrument does is stand **the same figure three
// times** — and that is also what makes it aniconic past argument. Three
// congruent copies of one closed outline are not a body; a body occurs once.
// `testNothingInTheTenReadsAsABodyPart` measures the congruence.
//
// ─────────────────────────────────────────────────────────────────────────────
// ONE READING OF DESIGN THIS FILE MAKES: THE RAILS ARE NOT CARRIED
// ─────────────────────────────────────────────────────────────────────────────
//
// Design draws four long lines per ghost, running the whole depth of the room
// from `z = 2` to `z = -25`. They are how a line-drawing of loops in empty space
// reads as a *room* rather than as a stack of rings. Here the loops are cut into
// the room's own material, which already is the room, so the rails have nothing
// to do — and a mark running the whole depth of a surface is one long flute, not
// a rail. That is ``EndlessRoom``'s own finding, made with a picture: *"three pale
// vertical stripes where a procession should have been."* The loops carry the
// room; the rails would only carry the flute.
struct TripleRoom: RoomSurfaceMechanism {

    // MARK: - Design's own numbers

    /// Three. Design's `tints.map(…)` — three ghosts of one room.
    static let ghosts = 3

    /// Five loops per ghost, receding: Design's `for (k = 0; k < 5; k++)`, at
    /// `z = -3 - k * 5.4` on a seat of radius 6.4.
    static let loops = 5
    static let loopFirst: Double = -3
    static let loopStep: Double = -5.4
    static let seatRadius: Double = 6.4

    /// Ring 1's own seat, from Design's `SEAT = { 1: 'square', … }` and
    /// `seatShape('square')`: the four corners of a square, which is the
    /// Trailokyamohana's own bhūpura.
    static let seat: [(x: Double, y: Double)] = [(-1, -1), (1, -1), (1, 1), (-1, 1)]

    /// How finely one loop is drawn. The vocabulary has no verb for a line
    /// (``EndlessRoom``, ``PressRoom``), so a closed outline is made of the verb
    /// there is, overlapping along its own length: two marks to an edge, which on
    /// a square is its corners and its midpoints.
    static let loopSamples = 8

    /// Where the three stand when they are apart: Design's
    /// `gh.position.set(off[i][0] * sep * 1.5, off[i][1] * sep * 1.4, 0)` on
    /// `off = [[-1, -0.42], [1, -0.22], [0.08, 1]]`. Across the room and up it —
    /// never along its depth, because all three stand in the same place and that
    /// is the room's whole premise.
    static let offsets: [(across: Double, rise: Double)] = [(-1, -0.42), (1, -0.22), (0.08, 1)]
    static let partsAcross: Double = 1.5
    static let partsUp: Double = 1.4

    /// **The breath the register hands over to.** Design's
    /// `(0.5 + 0.5 * sin((t - HOLD_END) * 0.085)) * 0.58`.
    static let breathRate: Double = 0.085
    static let breathDepth: Double = 0.58

    /// Design's own light on a ghost: `opacity = 0.28 + sep * 0.36` — they are
    /// **brightest apart**, which is why the room dims as it comes into register
    /// and begins to pulse once the register starts breathing.
    static let ghostAtRest: Double = 0.28
    static let ghostApart: Double = 0.36

    /// The one seal the three close onto: Design's `one.position.z = -24`,
    /// `opacity = (1 - sep) * 0.95 + b * 0.3`, `scale = 3 + (1 - sep) * 5 + b * 2`
    /// on a mark whose own radius is `0.4`.
    static let sealStands: Double = -24
    static let sealRadius: Double = 0.4
    static let sealSize: Double = 3
    static let sealArrives: Double = 5
    static let sealDeepens: Double = 2
    static let sealBright: Double = 0.95
    static let sealDeepLight: Double = 0.3

    // MARK: - What the premise becomes

    /// The three rooms occupying one place carried the premise — the enclosure
    /// being three enclosures — and the **one seal** at the far end takes it over.
    ///
    /// Design's own two numbers: the ghosts' `0.28 + sep * 0.36`, which is what
    /// the register costs them, and `one.scale = … + b * 2`, which is what the
    /// seal gains once the premise has turned. It answers **toward** him: a seal
    /// that was arriving from the far end of the room comes to where he is
    /// standing, and then stops arriving and breathes.
    let becoming = HomeBecoming(premise: .wall, answer: .face,
                                yields: TripleRoom.ghostApart,
                                takes: TripleRoom.sealDeepens)

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let b = stage.deep
        let axes = RoomUnits.axes(of: surface)
        let centre = stage.placement.coordinate

        let figure = RingOne.Figure(spread: abs(Self.loopFirst
                                                + Double(Self.loops - 1) * Self.loopStep),
                                    part: Self.seatRadius,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)
        let apart = Self.separation(at: chamberTime, deep: b)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.ghosts * Self.loops * Self.loopSamples + 1)

        // ── the three rooms, in one place ───────────────────────────────────
        //
        // Each is the same five receding loops of Ring 1's own seat, standing at
        // its own offset. They are **impressions** — pressed in and held, the
        // roundest of the five — because what a room standing in a place does to
        // the stone is stand in it, and the movement here is the three sliding
        // through one another rather than any one of them ploughing across.
        //
        // They are brightest **apart**, on Design's own `0.28 + sep * 0.36`, so
        // the first adaptation is a room going quiet as it comes together.
        let lit = Self.ghostAtRest + apart * Self.ghostApart
        let share = RingOne.lightShare(of: Self.ghosts * Self.loops * Self.loopSamples)
        let reach = RingOne.reach(material.reach(worldUnits: figure.length(Self.seatRadius))
                                  * 2.4 / Double(Self.loopSamples))

        // **How far off the surface a frame stands is how much of a mark it
        // makes there**, which is the reading ``MudraRoom`` makes of its own
        // arches and is the only honest way to put a figure that has a third
        // dimension onto a surface that has two. On a floor the frames stand on
        // the stone and their upper and lower edges lift clear of it; on a
        // working face it is the frames' own **depth** that lifts, so the five
        // loops stand one behind another in the same place on the panel and it is
        // the fading that says which is further — which is *three rooms in one
        // place* said in the only register the material has.
        //
        // The zero is where the figure comes **nearest** the surface rather than
        // at the room's origin, because a face's frames are all at some depth and
        // nothing about that should make the whole room faint.
        var figures: [(across: Double, along: Double, off: Double)] = []
        figures.reserveCapacity(Self.ghosts * Self.loops * Self.loopSamples)
        for ghost in 0..<Self.ghosts {
            let offset = Self.offsets[ghost]
            for loop in 0..<Self.loops {
                // A loop further down the room is further from the walker, and
                // Design lets it keep its own size: what recedes is where it
                // stands, not how big it is.
                let depth = figure.length(Self.loopFirst + Double(loop) * Self.loopStep)
                for sample in 0..<Self.loopSamples {
                    let point = Self.outline(sample)
                    let across = figure.length(point.x * Self.seatRadius
                                               + offset.across * apart * Self.partsAcross)
                    let rise = figure.length(point.y * Self.seatRadius
                                             + offset.rise * apart * Self.partsUp)
                    figures.append((across: across,
                                    along: axes.along(design: depth, rise: rise),
                                    off: abs(axes.along(design: rise, rise: depth))))
                }
            }
        }
        let nearest = figures.map(\.off).min() ?? 0
        let furthest = figures.map(\.off).max() ?? 0
        let range = max(furthest - nearest, 1e-9)

        for part in figures {
            let lift = min(1, max(0, (part.off - nearest) / range))
            marks.append(.impression(
                at: SurfaceCoordinate(u: centre.u + material.reach(worldUnits: part.across),
                                      v: centre.v + material.reach(worldUnits: part.along)).clamped,
                reach: reach,
                depth: RingOne.depth(size: (1 - lift) * (0.5 + 0.5 * (1 - apart)), on: material),
                glow: lit * share))
        }

        // ── and the one seal they close onto ────────────────────────────────
        //
        // At the far end of the room, arriving as the three come into register and
        // **deepening rather than arriving further** once the premise turns. It is
        // a **swell** — material raised from beneath, still the material — which
        // is what the answering side of a reversal is when it comes toward him
        // (``RoomReversal/actions(_:deep:stage:)``'s own reading), and it is
        // this room's **only** answer, so that generic mark is not also called:
        // a second lit disc standing on top of this one is the wash ``MatrkaRoom``
        // had to find with a picture.
        let arrived = 1 - apart
        let sealAt = figure.length(Self.sealStands)
        marks.append(.swell(
            at: SurfaceCoordinate(u: centre.u,
                                  v: centre.v + material.reach(
                                    worldUnits: axes.along(design: sealAt,
                                                           rise: -sealAt))).clamped,
            reach: RingOne.reach(material.reach(worldUnits: figure.length(
                Self.sealRadius * (Self.sealSize + arrived * Self.sealArrives
                                   + b * Self.sealDeepens)))),
            depth: RingOne.depth(size: 1, on: material),
            glow: min(1, arrived * Self.sealBright + b * Self.sealDeepLight)))

        return [surface: marks]
    }

    // MARK: - How far apart the three stand

    /// Design's own `sep`, and the whole room.
    ///
    /// `1` at the door, `0` where the eye has finished settling — the three in
    /// register, the one seal arrived — and then a **breath** once the premise
    /// turns, parting and rejoining for ever. Nothing here resolves.
    static func separation(at chamberTime: TimeInterval, deep b: Double) -> Double {
        let settled = 1 - HomeGrammar.settling(chamberTime: chamberTime)
        let breath = (0.5 + 0.5 * sin((chamberTime - HomeMemory.holdEnd) * breathRate))
            * breathDepth
        return settled * (1 - b) + breath * b
    }

    /// One point of Ring 1's own seat outline, sampled at `loopSamples` points
    /// round it: its corners, and the middle of each of its edges.
    static func outline(_ sample: Int) -> (x: Double, y: Double) {
        let steps = loopSamples / seat.count
        let corner = seat[(sample / max(1, steps)) % seat.count]
        let next = seat[(sample / max(1, steps) + 1) % seat.count]
        let along = Double(sample % max(1, steps)) / Double(max(1, steps))
        return (x: corner.x + (next.x - corner.x) * along,
                y: corner.y + (next.y - corner.y) * along)
    }
}
