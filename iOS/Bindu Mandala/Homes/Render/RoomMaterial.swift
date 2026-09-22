import Foundation

// MARK: - THE BINDING CONDITION
//
// The renderer ruling (DECISIONS.md, charter §2.4) chose SceneKit, and it
// chose it over one real objection which it did not dismiss:
//
//     A lit 3D solid reads as a THING in a way a canvas fill never does. In the
//     composite still of the SceneKit room past the second adaptation, her mark
//     has grown into a large pink lozenge lying on the floor — lit, discrete,
//     plainly a solid. It does not trip `LawsTests`, and it is not figural, and
//     it is still exactly the failure the law exists to prevent: a free-standing
//     object where there should be an action. Multiply that by 102 rooms and 26
//     attribute forms — a noose, a cup, a bow, a plough, a skull-cup as lit
//     solids — and the risk is a props cupboard.
//
// The ruling's answer is this file, and it is binding rather than advisory:
//
//     Every attribute in every room is an action on the room's own material —
//     an impression, a furrow, a crack, a swell, a compaction — and never a
//     free-standing emissive solid. Phase 3.1 encodes this as an API shape, not
//     a note: the room-building layer offers no way to mount a lit object that
//     is not bound to the surface it acts on.
//
// The ruling also names the condition under which it would be reopened:
// *"if Phase 3.1 cannot express 'an action on the room's own material' as the
// only way to mount an attribute, then the aniconic risk is unbounded."* So the
// shape below is not a style; it is the ruling's own precondition.
//
// ─────────────────────────────────────────────────────────────────────────────
// HOW THE ILLEGAL THING IS MADE UNREPRESENTABLE, RATHER THAN DISCOURAGED
// ─────────────────────────────────────────────────────────────────────────────
//
// A free-standing lit solid needs four things. This file withholds all four,
// and withholds them in the type system rather than in a comment:
//
// 1 · **A place in the air.** The only placement vocabulary is
//     ``SurfaceCoordinate`` — two numbers on a surface. There is no type here
//     that can name a point in space, so there is nowhere for a free object to
//     be. (Its third number, the height, is not a parameter at all: it is
//     whatever the surface is, at that point, after it has been acted on.)
//
// 2 · **A body.** Nothing in this file imports SceneKit, and nothing in it
//     names a mesh, a geometry, a node or a shape. The vocabulary contains no
//     noun that denotes an object — only five verbs that denote something
//     happening to material. `RoomSceneTests` reads this file off disk and
//     fails the build if an import or a geometry type appears in it.
//
// 3 · **Its own light.** ``SurfaceAction/glow`` is not a brightness; it is how
//     much the *surface's own emission* rises inside the mark, and
//     ``RoomMaterial/emission(at:)`` multiplies it by the mark's own relief. An
//     action that does not deform the material therefore emits nothing,
//     anywhere, at any strength. **Light is only ever a property of a
//     disturbance.** This is arithmetic, not a convention, and
//     `testLightCannotExistWithoutDeformation` proves it over every verb.
//
// 4 · **A constructor.** ``SurfaceAction``'s memberwise initialiser is private.
//     The only way to make one is one of five named static constructors, and
//     every one of them is a thing that happens to a surface. A sixth cannot be
//     added without editing this file, which is where the law is.
//
// The five verbs are the ruling's own list, and they are deliberately not
// extended. Design's §4.4 already says the attribute stops being an object past
// the second adaptation and grows into the room; under this shape it never got
// to be one.

// MARK: - The vocabulary

/// What a surface can be asked to do. Five verbs, and every one of them is
/// something that happens **to** material.
///
/// There is no verb for *place*, *mount*, *add* or *hang*, and there is no case
/// for a shape. A form that wants to be seen has to do something to the room.
enum SurfaceVerb: String, CaseIterable, Equatable {
    /// Pressed in and held — a bowl the material keeps. A palm, a heel, a cup
    /// set down.
    case impression
    /// Drawn across — a trough with a lip thrown up on either side. A plough,
    /// a noose closing, anything that travels.
    case furrow
    /// Split — long, narrow and sharp-edged, with no volume of its own. A
    /// vajra's strike, a thing that is irreversible.
    case crack
    /// Raised from beneath — the material pushed out, never a thing set on top
    /// of it. A lotus opening, a seed swelling, a flame's heat under stone.
    case swell
    /// Driven down and densified, with almost no relief: the mark of something
    /// that bore down without moving. A ground, a load, a sceptre held level.
    case compaction

    /// Which way the material goes. `-1` into the surface, `+1` out of it.
    ///
    /// A swell comes out of the surface and is still the surface — that is the
    /// whole difference between a swell and a solid, and it is why `+1` here is
    /// not a loophole: the material is continuous either way, and nothing about
    /// a swell can be detached from what it rose out of.
    var sense: Double { self == .swell ? 1 : -1 }
}

/// One thing happening to a surface.
///
/// **There is no public initialiser.** Every way of making one is a verb below,
/// and every verb is an action on material. That is the binding condition.
struct SurfaceAction: Equatable {

    /// What is happening.
    let verb: SurfaceVerb
    /// Where on the surface it is happening.
    let at: SurfaceCoordinate
    /// How far it reaches, in the surface's own `0…1` coordinates.
    let reach: Double
    /// How deep, in scene units. Always positive; ``SurfaceVerb/sense`` decides
    /// which way the material goes.
    let depth: Double
    /// How hard the mark's edge is, `0` soft to `1` sharp.
    let edge: Double

    /// **How far past its own reach an action still moves material**, as a
    /// multiple of the reach.
    ///
    /// It is a fact about the profiles below rather than a tuning: three of the
    /// five verbs are round and are already nothing long before this, but a
    /// **furrow** holds its whole depth for the length of its stroke and a
    /// **crack** is still at a quarter of its own when it arrives, so both of them
    /// are closed smoothly at exactly this distance. Which makes it the answer to
    /// a question a room that lays out a *figure* has to ask: how much clear
    /// material one mark needs around it before it stops reaching its neighbours.
    /// ``BodilessRoom`` asks it of the ring its eight effects stand on, so their
    /// strokes close around the absence at its centre instead of across it.
    static let cutoffReaches: Double = 4
    /// How much the **surface's own emission** rises inside the mark, `0…1`.
    ///
    /// Not a brightness and not a light: it is scaled by the mark's own relief,
    /// so where the material is undisturbed it contributes nothing, at any
    /// value. See ``RoomMaterial/emission(at:)``.
    let glow: Double

    /// Private, and this is the point. See the header, condition 4.
    private init(verb: SurfaceVerb, at: SurfaceCoordinate,
                 reach: Double, depth: Double, edge: Double, glow: Double) {
        self.verb = verb
        self.at = at.clamped
        // A mark with no reach and a mark with no depth are both nothing
        // happening; they are allowed, and they do nothing, rather than being
        // a special case somebody has to remember.
        self.reach = max(0, reach)
        self.depth = max(0, depth)
        self.edge = min(1, max(0, edge))
        self.glow = min(1, max(0, glow))
    }

    // MARK: The five, and nothing else

    /// Pressed in and held.
    static func impression(at where_: SurfaceCoordinate, reach: Double,
                           depth: Double, glow: Double = 0) -> SurfaceAction {
        SurfaceAction(verb: .impression, at: where_, reach: reach,
                      depth: depth, edge: 0.35, glow: glow)
    }

    /// Drawn across, with a lip thrown up on either side.
    static func furrow(at where_: SurfaceCoordinate, reach: Double,
                       depth: Double, glow: Double = 0) -> SurfaceAction {
        SurfaceAction(verb: .furrow, at: where_, reach: reach,
                      depth: depth, edge: 0.55, glow: glow)
    }

    /// Split. Narrow, sharp, and with no volume of its own.
    static func crack(at where_: SurfaceCoordinate, reach: Double,
                      depth: Double, glow: Double = 0) -> SurfaceAction {
        SurfaceAction(verb: .crack, at: where_, reach: reach,
                      depth: depth, edge: 1, glow: glow)
    }

    /// Raised from beneath — the material pushed out, still the material.
    static func swell(at where_: SurfaceCoordinate, reach: Double,
                      depth: Double, glow: Double = 0) -> SurfaceAction {
        SurfaceAction(verb: .swell, at: where_, reach: reach,
                      depth: depth, edge: 0.15, glow: glow)
    }

    /// Driven down and densified, with almost no relief.
    static func compaction(at where_: SurfaceCoordinate, reach: Double,
                           depth: Double, glow: Double = 0) -> SurfaceAction {
        SurfaceAction(verb: .compaction, at: where_, reach: reach,
                      depth: depth, edge: 0.05, glow: glow)
    }

    // MARK: The profile

    /// How far the material moves at a point, in scene units. Signed: negative
    /// is into the surface.
    ///
    /// Each verb is a different falloff over the same distance, which is what
    /// makes five verbs read as five different things rather than five names
    /// for one bowl.
    func relief(at point: SurfaceCoordinate) -> Double {
        guard depth > 0, reach > 0 else { return 0 }
        let du = point.u - at.u
        let dv = point.v - at.v
        // Far outside the mark, the material is untouched. Stated rather than
        // left to a falloff that rounds to nothing, because a room's surface is
        // meshed at four thousand points and a form can carry sixty parts: the
        // cutoff is what makes the height field O(what was marked) instead of
        // O(everything × everyone).
        let cutoff = reach * SurfaceAction.cutoffReaches
        if abs(du) > cutoff || abs(dv) > cutoff { return 0 }
        let r = (du * du + dv * dv).squareRoot() / reach
        let along = abs(du) / reach

        // **A stroke has to end, not be sawn off.** Three of the five verbs are
        // round — they fall away in every direction at once, and are already
        // nothing long before the cutoff. Two of them run *along* `v`: a furrow
        // holds its whole depth for the length of the stroke, and a crack is
        // still at a quarter of its own when the cutoff arrives. Without this
        // they would each stop at a vertical cliff of a mark's depth, with a
        // hard-edged rectangle of the mark's own light on top of it — which is
        // to say, a discrete object with square ends, which is the one thing
        // the five verbs exist to prevent. So the two directional verbs are
        // given a length, and it closes smoothly exactly where the cutoff is.
        // `testEveryVerbReachesNothingAtItsOwnCutoff` holds all five to it.
        let ends = 1 - RoomMaterial.smooth(abs(dv) / cutoff)

        let shape: Double
        switch verb {
        case .impression:
            shape = exp(-r * r * 2.2)
        case .furrow:
            // A trough across `u`, running the length of `v`; the material it
            // displaced stands up as a lip on either side, and the stroke
            // finishes rather than running on to the edge of the material.
            let trough = exp(-along * along * 4.5)
            let lip = exp(-pow((along - 1.15) * 2.6, 2)) * 0.32
            shape = (trough - lip) * ends
        case .crack:
            // Narrow and hard-edged, and it does not close: the falloff is
            // linear in the distance rather than Gaussian. Across its width,
            // that is — along its length it runs out, the way a split does.
            shape = max(0, 1 - along * 6) * exp(-abs(dv) / max(reach * 3, 0.0001)) * ends
        case .swell:
            shape = exp(-r * r * 1.1)
        case .compaction:
            // Flat-bottomed: it goes down once and stays down out to its reach,
            // because what it did was densify, not dig.
            shape = 1 - RoomMaterial.smooth(r)
        }
        return shape * depth * verb.sense
    }
}

// MARK: - The material that receives them

/// One surface's material: what it is made of, and everything that has been
/// done to it.
///
/// The **only** mutating entry point is ``receive(_:)``, and the only thing it
/// takes is a ``SurfaceAction``. There is no `add`, no `mount`, no `place`, and
/// nothing that takes a shape.
struct RoomMaterial: Equatable {

    /// Which surface this is.
    let surface: RoomSurfaceKind
    /// The surface's own span in scene units, so a world-space reach can be put
    /// into surface coordinates in one place.
    let span: Double
    /// The dhātu's grain, seeded off her khaḍgamālā position: the low relief
    /// the room's own stone has before anything happens to it.
    ///
    /// It is here because a surface with no relief at all has nothing for a
    /// raking light to fall across — Design's verification pass found exactly
    /// that, Ring 1's Mātṛkās reading as one flat plane, and called it an
    /// authoring defect.
    let seed: Int
    /// How high the grain stands, in scene units.
    let grainRelief: Double

    /// Everything that has been done to this surface, in the order it was done.
    private(set) var actions: [SurfaceAction] = []

    init(surface: RoomSurfaceKind, seed: Int, grainRelief: Double? = nil) {
        self.surface = surface
        self.span = RoomUnits.span(of: surface)
        self.seed = seed
        // A fortieth of a body-height: deep enough that the light finds it at
        // the near edge of the floor, shallow enough that it is a grain rather
        // than a landscape.
        self.grainRelief = grainRelief ?? RoomUnits.roomHeight / 40
    }

    /// The one way anything happens to a surface.
    mutating func receive(_ action: SurfaceAction) {
        actions.append(action)
    }

    /// The one way a whole form's action happens to a surface.
    mutating func receive(_ batch: [SurfaceAction]) {
        actions.append(contentsOf: batch)
    }

    /// Nothing has been done to it yet.
    var isUndisturbed: Bool { actions.isEmpty }

    /// A reach in scene units, in this surface's own coordinates.
    func reach(worldUnits: Double) -> Double {
        guard span > 0 else { return 0 }
        return worldUnits / span
    }

    // MARK: The height field

    /// How far the material stands from its resting plane at a point, in scene
    /// units — the grain, plus everything that has been done to it.
    func relief(at point: SurfaceCoordinate) -> Double {
        var y = grain(at: point)
        for action in actions { y += action.relief(at: point) }
        return y
    }

    /// The surface's own emission at a point, `0…1`.
    ///
    /// **This is condition 3 of the binding condition, in arithmetic.** An
    /// action's `glow` is multiplied by how far that action actually moved the
    /// material at that point, normalised by how far it could have. Where the
    /// material is untouched the product is zero, so a mark that does nothing
    /// to the surface cannot be seen however bright it asks to be — and there
    /// is no other route to light in this file.
    func emission(at point: SurfaceCoordinate) -> Double {
        var lit = 0.0
        for action in actions where action.glow > 0 && action.depth > 0 {
            let moved = abs(action.relief(at: point)) / action.depth
            lit += action.glow * min(1, moved)
        }
        return min(1, lit)
    }

    /// The room's own stone, before anything happened to it. Deterministic in
    /// her position, so a room is the same room on every launch and on every
    /// machine — the same principle ``Atmosphere`` jitters her hue by.
    func grain(at point: SurfaceCoordinate) -> Double {
        guard grainRelief > 0 else { return 0 }
        let s = Double(seed % 97)
        let bands = sin((point.v * 23 + s * 0.11) * .pi) * 0.6
            + sin((point.v * 7.3 + point.u * 1.7 + s * 0.31) * .pi) * 0.3
            + sin((point.u * 11.5 + s * 0.07) * .pi) * 0.1
        return bands * grainRelief
    }

    /// Design's `smooth`, kept here so the profile functions need nothing else.
    static func smooth(_ x: Double) -> Double {
        let t = min(1, max(0, x))
        return t * t * (3 - 2 * t)
    }
}

// MARK: - Her attribute, as an action on the room

/// The bridge from ``HomeAttributeActor`` — which is numbers — to what those
/// numbers **do to the room's material**.
///
/// This is the only way an attribute reaches a room, and it has one return
/// type: actions on a surface. There is no sibling that returns a node, a
/// geometry or anything that could stand on its own; adding one would mean
/// writing it here, under this header, which is where the ruling is.
///
/// ─────────────────────────────────────────────────────────────────────────────
/// THE VERB IS READ FROM THE MOTION, NOT ASSIGNED BY NAME
/// ─────────────────────────────────────────────────────────────────────────────
///
/// Design's twenty-six forms already say what each moving part *does*, in
/// numbers, at every instant. So which of the five verbs a part performs is
/// classified from its own motion — the same way ``HomeGrammar`` classifies her
/// physics from her tattva rather than from a table of names:
///
///   * fast and bright → a **crack**; a strike is over before it is seen
///   * coming down onto the material → an **impression**
///   * going up out of it → a **swell**
///   * travelling across it → a **furrow**
///   * bearing down without moving → a **compaction**
///
/// Nothing is keyed by the form's name, so law 1 holds here as everywhere: the
/// only key is her position, and the only input is what her attribute does.
enum RoomInscription {

    /// How far apart the two samples the classifier reads are, in chamber
    /// seconds. Short enough to be a velocity, long enough that the slowest of
    /// Design's actions — the sceptre, whose period is over fifty minutes — is
    /// still moving measurably across it.
    static let sampleGap: TimeInterval = 0.25

    /// Above this speed a part is striking rather than working, and what it
    /// leaves is a crack. In scene units per chamber second.
    static let strikeSpeed: Double = 6

    /// Below this rate a part is bearing down rather than travelling.
    static let workingSpeed: Double = 0.35

    /// The deepest any single mark goes: a twentieth of a body-height. The room
    /// is not a quarry, and a mark that swallows the walker is the lozenge in
    /// another costume.
    static let markDepth: Double = RoomUnits.roomHeight / 20

    /// **How deep a mark goes, and the floor no mark falls below.**
    ///
    /// The dhātu's grain stands a fortieth of a body high
    /// (``RoomMaterial/grainRelief``) and one mark's own depth is a twentieth, so
    /// a mark at half strength is *exactly* the grain and a mark below that is
    /// invisible — not faint, invisible, since what the walker sees is a raking
    /// light falling across relief and the relief it falls across is the grain's.
    ///
    /// The finding is ``CrossingRoom``'s, written down when Ring 2's lengths were
    /// still read against the surface rather than against the body — *"seven
    /// rings, buried"* — and it was enforced only in Ring 1 until Ring 2's own
    /// marks were measured mark by mark rather than at their deepest. Four of the
    /// seven a Karṣiṇī draws stood under the banding they were cut into for the
    /// whole of every stay, in ten of the sixteen rooms. It is here, beside
    /// ``markDepth``, because it is the instrument's answer to *how deep may
    /// anything go* and there cannot be two of those.
    ///
    /// So the grain is the floor and one mark's depth is the ceiling, and `size`
    /// — how large this mark is against the largest the room makes — moves it
    /// between them. Many parts may still share the **light**; they do not share
    /// their footing. A mark that is *giving the room up* therefore withdraws by
    /// its **reach** and never by its depth: a mark that grew shallower would
    /// stop being seen while it was still there, which is a different thing from
    /// leaving.
    static func depth(size: Double, on material: RoomMaterial) -> Double {
        let floor = min(material.grainRelief, markDepth)
        return floor + (markDepth - floor) * min(1, max(0, size))
    }

    /// **The narrowest a mark may be and still be a mark**: one cell of the
    /// surface's own mesh.
    ///
    /// A surface is meshed and lit at ``RoomScene/resolution`` points a side, and
    /// both ``RoomMaterial/relief(at:)`` and ``RoomMaterial/emission(at:)`` are
    /// read **at those points and nowhere else**. A mark narrower than the gap
    /// between two of them has no vertex inside it: it moves no material, and
    /// because light here is only ever a property of a disturbance, it emits
    /// nothing either. It is not faint, it is absent.
    ///
    /// It is the same number for every surface, which is the point — a floor is
    /// four body-heights across and a working face is one, so the same mark is
    /// four times smaller in a floor's own coordinates, and what a floor can
    /// carry is four times larger a thing.
    static let narrowestMark: Double = 1 / Double(RoomScene.resolution)

    /// The verb one moving part is performing at this instant.
    static func verb(for part: AttributeMotion, previous: AttributeMotion) -> SurfaceVerb {
        let dy = (part.y - previous.y) / sampleGap
        let dx = (part.x - previous.x) / sampleGap
        let dz = (part.z - previous.z) / sampleGap
        let across = (dx * dx + dz * dz).squareRoot()
        let speed = (across * across + dy * dy).squareRoot()

        if speed >= strikeSpeed && part.intensity >= 1 { return .crack }
        if dy <= -workingSpeed { return .impression }
        if dy >= workingSpeed { return .swell }
        if across >= workingSpeed { return .furrow }
        return .compaction
    }

    /// Everything her attribute is doing to the room at this moment of her stay.
    ///
    /// The form's own group carries the mark; each moving part carries its own,
    /// placed by where the part is and sized by how large it has grown. All of
    /// it is scaled by Design's mount, so the whole inscription widens and comes
    /// toward the walker through the second adaptation — the attribute growing
    /// into the room, which under this shape is the only thing it was ever
    /// doing.
    static func actions(for actor: HomeAttributeActor,
                        at chamberTime: TimeInterval,
                        on material: RoomMaterial,
                        placement: RoomPlacement) -> [SurfaceAction] {
        let state = actor.state(atChamberTime: chamberTime)
        let earlier = actor.form.act(at: chamberTime - sampleGap)
        let footprint = placement.footprint
        let centre = placement.coordinate

        var out: [SurfaceAction] = []
        out.reserveCapacity(state.parts.count + 1)

        // The form's own group: what the whole shape is doing, as one mark.
        out.append(action(part: state.body,
                          previous: earlier.body,
                          centre: centre,
                          footprint: footprint,
                          material: material,
                          mount: state.mount,
                          weight: 1))

        // Each moving part, placed by where it is relative to the form.
        for (index, part) in state.parts.enumerated() {
            let previous = index < earlier.parts.count ? earlier.parts[index] : part
            let offset = SurfaceCoordinate(
                u: centre.u + material.reach(worldUnits: part.x * footprint),
                v: centre.v + material.reach(worldUnits: part.z * footprint))
            out.append(action(part: part,
                              previous: previous,
                              centre: offset,
                              footprint: footprint,
                              material: material,
                              mount: state.mount,
                              // Many parts share one mark's worth of material
                              // between them, so a rosary's twenty-seven beads
                              // do not dig twenty-seven times as deep as a
                              // lamp's one wick.
                              weight: 1 / Double(max(1, state.parts.count)).squareRoot()))
        }
        return out
    }

    /// One part, as one action on the material.
    private static func action(part: AttributeMotion,
                               previous: AttributeMotion,
                               centre: SurfaceCoordinate,
                               footprint: Double,
                               material: RoomMaterial,
                               mount: AttributeMount,
                               weight: Double) -> SurfaceAction {
        let kind = verb(for: part, previous: previous)
        let reach = material.reach(worldUnits: max(0.01, part.scale) * footprint * 0.5)
        let depth = markDepth * weight * min(2, max(0.1, part.scale))
        // Her light is the surface's, and it fades exactly as Design's mount
        // fades a transparent material past the second adaptation: the mark
        // stops being a bright thing and becomes part of what the room is made
        // of.
        let glow = mount.fading(part.opacity) * min(1, part.intensity) * 0.6

        switch kind {
        case .impression: return .impression(at: centre, reach: reach, depth: depth, glow: glow)
        case .furrow:     return .furrow(at: centre, reach: reach, depth: depth, glow: glow)
        case .crack:      return .crack(at: centre, reach: reach, depth: depth, glow: glow)
        case .swell:      return .swell(at: centre, reach: reach, depth: depth, glow: glow)
        case .compaction: return .compaction(at: centre, reach: reach, depth: depth, glow: glow)
        }
    }
}
