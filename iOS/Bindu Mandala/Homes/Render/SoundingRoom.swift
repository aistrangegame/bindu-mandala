import Foundation

// MARK: - RING 7 · the twelve Vāsinīs · the room made of her syllable
//
// Design's `sounding(world, card, G, bija)`, built on the Phase 3.1 spine. Its
// own header is the whole design:
//
//     RING 7 · SOUNDING — the room is made of her syllable.
//     Standing waves in her own row of the alphabet; the geometry IS the
//     vibration.
//
// and the deep line is *"you are inside the syllable"*.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE THINNEST RING IN THE INSTRUMENT, AND WHAT IS DONE ABOUT IT
// ─────────────────────────────────────────────────────────────────────────────
//
// Every other archetype hands a Śakti a **phase** — Design's `ph + i / n`, where
// `ph` is `(card.pos % N) / N`. SOUNDING has no divisor at all
// (``HomeGrammar/phaseDivisor(for:)`` returns `nil` for it), so
// ``HomeGrammar/Reading/phase`` is `nil` for all twelve and Design phases the
// room's parts by **node index** instead. Her own position reaches the builder
// through exactly one number: `n = 2 + (pos % 8)`, her row's mode.
//
// That is real structural thinness, and it bites twice over twelve seats:
//
//   * **Four pairs share a mode.** `87 · 95` both stand at nine, `88 · 96` at
//     two, `89 · 97` at three, `90 · 98` at four — the eight speech Vāsinīs and
//     the four weapons wrap the same modulus.
//   * **Eight of the twelve share a physics.** Positions 87–94 all carry `vāc`
//     or `speech` in their tattva or their quality, so
//     ``HomeGrammar/physics(tattva:quality:)`` classifies every one of them as
//     `sound` — correctly, and the classifier has nothing finer to say. Their
//     bodily locations collapse too: seven of the eight are *throat*, *palate* or
//     *mouth*, which is one zone (``HomeGrammar/bodyZones``) and one altitude.
//
// So a SOUNDING room that took only what the grammar hands it would be a mode
// number and nothing else, and the Design thread's own finding — seventy-eight
// of a hundred and two rooms falling to one generic physics — would arrive here
// by a different door. What this file does about it is take **more of what her
// row actually says**, not invent a number:
//
//   1 · **her mode decides how many marks her room has**, 2n of them rather than
//       a fixed count, which is the one register the other five archetypes do not
//       have — the outer climb otherwise stands eight, fourteen, twelve, ten and
//       three parts regardless of who is standing in the room;
//   2 · **her mode decides how wide the wall must open**, because a standing wave
//       needs a wall long enough to carry it (``layout(figure:material:)``);
//   3 · **her altitude sets the phase of the wave's own breath**, through Design's
//       second wave term read at the height she is felt at
//       (``axial(at:bodyAltitude:)``) — the one number in Design's shader that
//       varies with where on the body she lives, and it is the difference between
//       a room whose wall is swelling and a sister's whose wall is drawn in at the
//       same instant;
//   4 · **her physics presses the silences into the stone**, which is Design's
//       `s.position.y = y + d[1]` and is the only place her tattva reaches this
//       room at all — read through ``SoundingRoom/bearing(of:atAngle:)``, because
//       Design's line taken literally loses a dozen of the kernel's kinds
//       outright, two of them hers.
//
// Her attribute, her gem and her words then do what they do in all 102.
//
// ─────────────────────────────────────────────────────────────────────────────
// A STANDING WAVE, AND THE ONE PLACE DESIGN'S OWN SHADER CONTRADICTS ITSELF
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's wall is `w = sin(ang * uMode + uTime * 0.5) * cos(p.y * 0.5 + uTime *
// 0.3)`, and its comment calls it *"a standing wave: her syllable, held in the
// wall"*. Its nodes are placed once, at fixed angles, and labelled *"the nodes of
// her wave — where the syllable is silent"*.
//
// Those two cannot both be true. `sin(ang * uMode + uTime * 0.5)` **travels**:
// its zeros move around the cylinder at `0.5 / uMode` radians a second, so a
// sprite pinned at a fixed angle is at a node only for an instant and the room
// has no silence anywhere. A wave whose nodes stand still is
// `sin(ang * uMode) * cos(ωt)`, which is what Design's comment, Design's fixed
// node sprites and the word *standing* all describe.
//
// So the angular term stands here and the time-varying term is the **axial** one
// Design already wrote — `cos(p.y * 0.5 + uTime * 0.3)`, the envelope the whole
// wave breathes on. Nothing is invented and nothing is dropped; the two terms are
// read as the product they are, with the travelling `uTime * 0.5` left out
// because it is the one thing in the expression that destroys the room's own
// sentence.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THE ROOM DOES TO ITS OWN MATERIAL
// ─────────────────────────────────────────────────────────────────────────────
//
// `2n` marks stand around one ring, alternating:
//
//   * **the `n` silences**, at Design's own angles `j · 2π / n`. A node is the
//     place the wave never carries anywhere: it has **no travel along the wall**,
//     at any moment of any stay. What it does have is her physics bearing on it
//     from off the plane — Design's `d[1]` — so the material under a silence is
//     driven down and back without ever being drawn sideways. That is what the
//     verb classifier reads as a **compaction**, and nothing here assigns it.
//   * **the `n` soundings** between them, at the quarter-turns of her own
//     wavelength, where `sin` is at ±1. These are the only marks in the room that
//     move **along** the stone, and they move radially — Design's
//     `p.xz *= 1.0 + w * 0.05 * amp`, which is a displacement along the
//     cylinder's own radius and nothing else.
//
// **Their signs alternate**, because the wave's do: one sounding is driven out
// while the next is drawn in, and the pair swaps as the axial envelope turns
// through zero. No other room in the hundred and two moves its material outward
// and inward around a single ring at once — a Bodiless room's eight all carry the
// same physics at eight turns of one phase, a Cosmic room's shells are
// concentric, a Sourcing room has three corners. This alternation is the picture
// of a standing wave and it belongs to this archetype alone.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY EVERY MARK CARRIES LIGHT, AND THE SILENCES ARE NOT A SECOND ABSENCE
// ─────────────────────────────────────────────────────────────────────────────
//
// Ring 3's absence carries `glow` **0** and the eight effects carry all the
// light. It would be easy, and wrong, to write the same room again here with the
// silences dark.
//
// Design does not: its nodes are the **lit** sprites, at
// `(0.24 + 0.4 * k) * (1 - b * 0.4)`, and its wall's alpha is
// `0.6 + 0.4 * vA` with `vA = 0.35 + 0.65 * |w|` — brightest exactly at the
// soundings. So both are lit and the soundings are brighter, which is Design's
// own arrangement and is carried over unchanged.
//
// It is also the only arrangement that survives this ring's light. Ring 7 is
// **pearl at 0.95 and sourceless** — ``RoomLightRig`` gives it no directional
// light at all (``HomeGem/isSourceless``), so there is no raking key to find
// relief the material does not emit for itself. A room whose silences were dark
// would be `n` lit points in a void, and the wall heaving between them would not
// be in the picture at all.
//
// One part's share of the light is ``OuterRings/lightShare(of:)``, so a mode of
// nine does not stack eighteen marks into a flat field where a mode of two stands
// four.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHAT THE SECOND ADAPTATION IS SPENT ON
// ─────────────────────────────────────────────────────────────────────────────
//
// *The standing waves stop being a wall he is looking at; they pass him, and the
// sound becomes what he is standing in.* Design's two numbers are
// `s.scale.setScalar(1.8 * (1 + b * 1.2))` — the silences open out — and
// `amp = 0.5 + uDeep * 1.6` — the wave's own excursion more than trebles. Both are
// here, and ``HomeBecoming/archetype(_:)`` carries the third: the enclosure
// yields and the **ground** takes the work over, which is the only outer
// archetype whose answer is the thing he is standing on.
struct SoundingRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 87–98. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// **Her row's mode number**, `2 + (pos % 8)` — Design's `n`, and the one
    /// number her position reaches this archetype through.
    let mode: Int

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.mode = reading.soundingMode ?? HomeGrammar.soundingMode(position: reading.position)
    }

    /// The seventh āvaraṇa.
    static let ring = 7

    // MARK: - Design's own numbers

    /// The ring her nodes stand on: Design's `cos(a) * 8.4` / `sin(a) * 8.4`.
    static let nodeRing: Double = 8.4

    /// How large one node is: Design's `sprite(glow(…), G.c, 1.8, 0.6)`, whose
    /// 1.8 is the sprite's whole span — so a mark's reach is half of it.
    static let nodeSize: Double = 1.8

    /// The wall itself: `CylinderGeometry(9, 9, 24, …)`.
    static let skinRadius: Double = 9

    /// How far the wave carries the wall off its own radius, as a fraction of it:
    /// Design's `p.xz *= 1.0 + w * 0.05 * amp`.
    static let waveReach: Double = 0.05

    /// Design's `amp = 0.5 + uDeep * 1.6` — the excursion while the eye settles,
    /// and how much more of it the second adaptation opens.
    static let waveFloor: Double = 0.5
    static let waveOpens: Double = 1.6

    /// Design's displacement amplitude for the nodes — `displace(kind, t, i / n,
    /// 0.7)`.
    static let travel: Double = 0.7

    /// Design's own opacity on a node: `(0.24 + 0.4 * k) * (1 - b * 0.4)`.
    static let silenceFloor: Double = 0.24
    static let settlingLift: Double = 0.4
    static let silenceFades: Double = 0.4

    /// Design's wall alpha, `0.6 + 0.4 * vA` over `vA = 0.35 + 0.65 * |w|`.
    static let soundingFloor: Double = 0.6
    static let soundingSwing: Double = 0.4
    static let waveFloorAlpha: Double = 0.35
    static let waveLift: Double = 0.65

    /// The two terms of Design's axial wave, `cos(p.y * 0.5 + uTime * 0.3)`.
    ///
    /// The `0.35` is `0.5` read at the height Design's own nodes stand at against
    /// the skin's own centre: the nodes are at `y` and the wall is mounted at
    /// `y * 0.3`, so a node's height in the cylinder's own coordinates is
    /// `0.7 * y` and the shader's `p.y * 0.5` is `0.35 * y`.
    static let axialByHeight: Double = 0.35
    static let axialByTime: Double = 0.3

    // MARK: - How many marks her room has, and where they stand

    /// **Two for every one of Design's nodes** — the silence, and the sounding
    /// that follows it.
    var marks: Int { 2 * mode }

    /// Whether the `index`-th mark is one of the silences. The even ones are:
    /// they stand at Design's own angles, and the soundings are the quarter-turns
    /// between them.
    func isSilence(_ index: Int) -> Bool { index % 2 == 0 }

    /// Where the `index`-th mark stands around the ring, in radians.
    ///
    /// Marks are spread at `π / n`, so the silences land on Design's `(i / n) *
    /// TAU` exactly and the soundings sit halfway between two of them.
    func angle(_ index: Int) -> Double { Double(index) * .pi / Double(mode) }

    /// **The wave, at the `index`-th mark** — `sin(n · θ / 2)`, which is the mode
    /// with `n` zeros around a full turn.
    ///
    /// `0` at every silence and `±1` at every sounding, alternating: the first
    /// sounding is driven out, the next drawn in, and so on around her wall. That
    /// alternation is the mode, and it is why the count alone would not have been
    /// enough.
    func wave(_ index: Int) -> Double {
        sin(Double(mode) * angle(index) / 2)
    }

    /// **The envelope the whole wave breathes on**, and the one term in Design's
    /// shader that carries where on the body she is felt.
    ///
    /// Design's `cos(p.y * 0.5 + uTime * 0.3)`, read at her own seat. It sweeps
    /// its whole range about every twenty-one seconds, so no room is ever stuck at
    /// a null — and her altitude is the offset it sweeps from, which is what makes
    /// two sisters at two heights be at two different points of one breath.
    static func axial(at chamberTime: TimeInterval, bodyAltitude: Double, ring: Int) -> Double {
        let y = RoomUnits.grammarSpan(ring: ring) * (0.5 - bodyAltitude)
        return cos(axialByHeight * y + axialByTime * chamberTime)
    }

    // MARK: - How her physics reaches a silence

    /// **How hard her physics bears on the silence standing at `angle`.**
    ///
    /// Design writes `s.position.y = y + d[1]` — the node takes the `y` term of
    /// her displacement and nothing else. Taken literally that loses her tattva
    /// **entirely** for every kind whose kernel has no `y` term at all, and there
    /// are a dozen of them: `turn`, `recur`, `compress`, `encircle`, `point`,
    /// `draw`, `align`, `widen`, `dart`, `flow`, `merge`, `arrive`. Two of the
    /// twelve Vāsinīs are among them on the real cards — `pāśa` classifies as
    /// `encircle` and `aṅkuśa` as `point` — so the one place her tattva reaches
    /// this archetype would reach two of its rooms not at all. In a ring with no
    /// phase divisor and eight of twelve sharing one physics, that is the blur
    /// this whole file is built against.
    ///
    /// So the node is read as what a node **is**: the place the wall is held.
    /// Design's three axes are resolved in the ring's own frame and each one is
    /// spent where a held point can spend it.
    ///
    ///   * **off the plane** — Design's `d[1]`, unchanged. This is the whole
    ///     answer for the eight speech Vāsinīs, whose `sound` kernel is `y` and
    ///     nothing else, so Design's own line is reproduced exactly for the eight
    ///     seats it was written for.
    ///   * **across the ring** — her displacement along the radius. In Design's
    ///     room the wall is a cylinder and the radius is the way **off** it, so
    ///     this is a press rather than a travel, and it is the one that differs
    ///     from node to node: the same motion bears hardest where the ring faces
    ///     into it.
    ///   * **along the ring** — refused. That is ``hold(of:atAngle:)``, and it is a
    ///     second channel rather than a third term here, because a refusal is not
    ///     a displacement: summed into the same number it would cancel the radial
    ///     press outright wherever the two came out equal, which for a kernel on
    ///     one in-plane axis is every node at a diagonal — measured, and
    ///     `point` and `arrive` lost two of a mode of eight to it.
    ///
    /// Nothing here consults a name or a table of which kinds have a `y`.
    static func bearing(of drift: HomeOffset, atAngle angle: Double) -> Double {
        drift.y + drift.x * cos(angle) + drift.z * sin(angle)
    }

    /// **How hard the silence at `angle` is being held**, `0` to `1`.
    ///
    /// The travel her physics would have carried the node **along** the wall, and
    /// which a node by definition refuses. It does not vanish: it is what the
    /// stone is holding against, so it is how deep the mark goes
    /// (``RoomInscription/depth(size:on:)``, whose floor is the grain).
    ///
    /// So a silence's two numbers are its two answers to her physics: how far the
    /// stone is driven, and how hard it is held. A Vāsinī whose kernel is `sound`
    /// — which is the eight of the twelve who speak — refuses nothing, because her
    /// motion is entirely off the plane, and her silences are the shallowest marks
    /// the stone can carry while her soundings are the deepest. A Vāsinī whose
    /// kernel lies in the plane is held hard at the nodes her motion runs along,
    /// and barely at the ones it runs into.
    ///
    /// Read against ``HomeGrammar/widestTerm`` for the same reason
    /// ``OuterRings/pressed(_:travel:)`` is: the kernel multiplies its amplitude by
    /// as much as 2.2, and a size normalised by the amplitude alone would rail.
    static func hold(of drift: HomeOffset, atAngle angle: Double, travel: Double) -> Double {
        let along = -drift.x * sin(angle) + drift.z * cos(angle)
        return min(1, abs(along) / max(travel * HomeGrammar.widestTerm, 0.0001))
    }

    // MARK: - What the premise becomes

    /// *You are inside the syllable.* The enclosure yields and the ground takes
    /// the work over — read from ``HomeBecoming/archetype(_:)``, so this room and
    /// the grammar agree by construction.
    var becoming: HomeBecoming { .archetype(.sounding) }

    /// Design's `1 + b * 1.2` on a node, through the instrument's own saturating
    /// fraction — the same law that holds every answering surface short of the
    /// walker.
    var silenceOpens: Double { RoomReversal.answeringFraction(takes: becoming.takes) }

    /// Design's `amp = 0.5 + uDeep * 1.6`.
    func excursion(deep: Double) -> Double {
        Self.waveFloor + Self.waveOpens * min(1, max(0, deep))
    }

    // MARK: - The ring, and why her mode decides it

    /// **How wide a mark may be, and how far out the ring must stand — which for
    /// this archetype are one question.**
    ///
    /// A standing wave needs a wall long enough to carry it. Her room stands `2n`
    /// marks around one ring and a **furrow** or a **crack** runs
    /// ``SurfaceAction/cutoffReaches`` of its own reach *along* the stroke, so
    /// where the ring is too small for her mode each sounding writes straight
    /// through the silence beside it and the room has no silences at all — which
    /// is Ring 3's finding (*"an effect's stroke closes on the ring it stands
    /// on"*) arriving at the one archetype where the count is the Śakti.
    ///
    /// So the ring is the larger of Design's own and what her mode needs: the
    /// **chord** between two neighbouring marks has to be at least one stroke
    /// wide, which for `2n` marks on a ring of `R` is `2R · sin(π / 2n)`, plus the
    /// radial swing the wave itself carries a sounding through at its widest. The
    /// chord and not the arc, because a stroke is straight and a mode of nine
    /// stands its marks twenty degrees apart — where the two differ by a
    /// twentieth, which is the whole margin this room has.
    ///
    /// A mode of nine therefore stands on a wider wall than a mode of two, and the
    /// walker is further inside it — which is the archetype's own sentence.
    ///
    /// The growth past the second adaptation is inside the requirement rather than
    /// applied after it, because a silence that opened out into its neighbour's
    /// stroke would lose the room at exactly the moment the room is supposed to
    /// arrive.
    func layout(figure: OuterRings.Figure, material: RoomMaterial) -> (reach: Double, ring: Double) {
        let reach = figure.reach(Self.nodeSize / 2)
        let design = material.reach(worldUnits: figure.length(Self.nodeRing))
        let swing = material.reach(worldUnits: figure.length(
            Self.skinRadius * Self.waveReach * excursion(deep: 1)))
        let widest = OuterRings.clearance(ofReach: reach * (1 + silenceOpens))
        let needed = widest / (2 * sin(.pi / Double(marks)))
        return (reach, max(design, needed + swing))
    }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep

        let figure = OuterRings.Figure(ring: Self.ring,
                                       spread: Self.nodeRing * 2,
                                       part: Self.nodeSize / 2,
                                       on: material,
                                       bodyAltitude: stage.placement.bodyAltitude)
        let travel = figure.length(Self.travel)
        let share = OuterRings.lightShare(of: marks)
        let ring = layout(figure: figure, material: material)
        let envelope = Self.axial(at: chamberTime,
                                  bodyAltitude: stage.placement.bodyAltitude,
                                  ring: Self.ring)

        var made: [SurfaceAction] = []
        made.reserveCapacity(marks)

        for index in 0..<marks {
            let here = place(index: index, at: chamberTime,
                             figure: figure, stage: stage, material: material)
            let before = place(index: index, at: chamberTime - OuterRings.readOver,
                               figure: figure, stage: stage, material: material)

            let glow: Double
            let reach: Double
            if isSilence(index) {
                // Design's node: its light falls as the premise turns, and it
                // opens out. **The growth is applied after the material's own
                // floor and never under it** (``OuterRings/reach(_:)``) — on a
                // floor four body-heights across, Design's node is smaller than
                // one cell of the mesh and a growth folded in first would be
                // swallowed by it.
                glow = (Self.silenceFloor + Self.settlingLift * k)
                    * (1 - b * Self.silenceFades) * share
                reach = min(OuterRings.widestMark, ring.reach * (1 + b * silenceOpens))
            } else {
                // Design's wall, at a sounding: brightest where the wave is
                // widest, and its excursion is what the second adaptation opens
                // rather than its light.
                let amplitude = abs(wave(index) * envelope)
                glow = (Self.soundingFloor
                        + Self.soundingSwing * (Self.waveFloorAlpha + Self.waveLift * amplitude))
                    * share
                reach = ring.reach
            }

            made.append(OuterRings.mark(here, from: before,
                                        reach: reach,
                                        size: isSilence(index)
                                            ? held(index: index, at: chamberTime, travel: travel)
                                            : 1,
                                        travel: travel,
                                        glow: glow,
                                        material: material))
        }

        var out = RoomReversal.actions(becoming, deep: b, stage: stage)
        out[surface, default: []].append(contentsOf: made)
        return out
    }

    /// How hard the `index`-th silence is held at one moment, on her own kernel.
    /// `0` for anything that is not a silence: a sounding is not held, it moves.
    func held(index: Int, at chamberTime: TimeInterval, travel: Double) -> Double {
        guard index >= 0, index < marks, isSilence(index) else { return 0 }
        let drift = HomeGrammar.displace(
            physics,
            time: chamberTime,
            phase: OuterRings.spread(index: index / 2, of: mode, kind: physics),
            amplitude: travel)
        return Self.hold(of: drift, atAngle: angle(index), travel: travel)
    }

    // MARK: - Where one mark of the wave stands

    /// Where the `index`-th mark of her wave stands at one moment.
    ///
    /// **The ring lies in the surface**, for ``BodilessRoom``'s own reason:
    /// Design's ring is drawn lying down — `cos(a) * 8.4` in `x`, `sin(a) * 8.4`
    /// in `z`, at her altitude — so its two in-plane axes are the two that run
    /// along the stone and `y` is the one that runs into it. Which way *into* is,
    /// is still ``RoomUnits/SurfaceAxes``' own `outward`.
    ///
    /// **A silence never travels along the wall.** It carries no radial
    /// displacement at any moment of any stay, which is what makes it a silence
    /// and what the verb classifier reads. Her physics bears on it from off the
    /// plane instead — Design's `s.position.y = y + d[1]`, read through
    /// ``bearing(of:atAngle:)`` so that a kernel with no `y` term still reaches
    /// the room — and so a silence is driven into the stone without ever being
    /// drawn sideways.
    ///
    /// **A sounding travels radially and nowhere else**, by the wave's own
    /// amount: Design's `p.xz *= 1.0 + w * 0.05 * amp`, which scales a point's
    /// distance from the axis and leaves its angle alone.
    func place(index: Int, at chamberTime: TimeInterval,
               figure: OuterRings.Figure, stage: RoomStage,
               material: RoomMaterial) -> OuterRings.Place {
        let centre = stage.placement.coordinate
        guard index >= 0, index < marks else {
            return OuterRings.Place(at: centre, into: 0)
        }

        let axes = RoomUnits.axes(of: material.surface)
        let ring = layout(figure: figure, material: material).ring
        let a = angle(index)

        var radius = ring
        var into = 0.0
        if isSilence(index) {
            // Design's `ph + i / n` over her own nodes, read against her own
            // kernel's turn rather than typed (``OuterRings/spread(index:of:kind:)``):
            // written literally, `i / n` is an identity for every kind whose terms
            // are `|sin|`, and a mode of eight would press four identical pairs.
            let drift = HomeGrammar.displace(
                physics,
                time: chamberTime,
                phase: OuterRings.spread(index: index / 2, of: mode, kind: physics),
                amplitude: figure.length(Self.travel))
            into = Self.bearing(of: drift, atAngle: a) * axes.outward
        } else {
            let envelope = Self.axial(at: chamberTime,
                                      bodyAltitude: stage.placement.bodyAltitude,
                                      ring: Self.ring)
            let swing = figure.length(Self.skinRadius * Self.waveReach
                                      * excursion(deep: stage.deep))
            radius += material.reach(worldUnits: swing * wave(index) * envelope)
        }

        return OuterRings.Place(at: SurfaceCoordinate(u: centre.u + radius * cos(a),
                                                      v: centre.v + radius * sin(a)).clamped,
                                into: into)
    }
}
