import Foundation
import CoreGraphics

// MARK: - The room's coordinate system
//
// The renderer ruling (DECISIONS.md, charter §2.4) names this file first, and
// names the reason: *"Design's constants are three.js numbers … the SceneKit
// builder had to re-derive almost every one of them by hand for a single room.
// 102 rooms is 102 sets of that unless this file exists before the second room
// does."*
//
// So this is the one place where the pure layers' output becomes scene space.
// No room does its own arithmetic. If a number about *where* something is has
// to be worked out, it is worked out here, once, and every room reads it.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE IDEA: THE ROOM IS THE BODY
// ─────────────────────────────────────────────────────────────────────────────
//
// Design places her mark by body altitude — ``HomeAttribute/mount(bodyAltitude:chamberTime:)``
// puts it at `(0.5 - alt) * 6.4 - 0.4`, at depth `-4.6` — and its worlds by a
// vertical climb from the Feet to Totality. Both are statements about a *body*,
// so the room is built as one:
//
//   * the **floor** stands at the height the soles' extreme resolves to,
//   * the **canopy** at the height the crown's extreme resolves to,
//   * the **eye** stands where the body's own eyes are — read through the same
//     conversion, off ``HomeGrammar/bodyZones``, never as a separate number.
//
// The consequence is the thing the spike had to discover by trial: a Śakti felt
// at the soles reads LOW in the frame and one felt at the crown reads HIGH,
// because the room's own geometry says so rather than because a camera was
// tuned until it looked right. `RoomSceneTests` asserts both ends.
//
// ─────────────────────────────────────────────────────────────────────────────
// ALMOST NOTHING HERE IS A NEW NUMBER
// ─────────────────────────────────────────────────────────────────────────────
//
// The whole vertical axis is *derived* — from ``HomeAttribute``'s mount, from
// ``HomeGrammar``'s altitude curve and body-zone table, from ``HomeMemory``'s
// clock. Four constants are genuinely this file's own, and each one says why:
// ``extentFactor``, ``gaze``, ``fieldOfView``, and the two clip planes.
//
// And one identity is worth naming, because it is the reason a single
// conversion is possible at all: **the grammar's altitude curve and the
// attribute's mount are the same curve in different units.** The grammar writes
// `(0.5 - alt) * 9` in rings 1–3 and `* 8` elsewhere; the attribute writes
// `(0.5 - alt) * 6.4 - 0.4`. Normalise the grammar's span into the room's own
// height and subtract the mount's offset and the two land on the same point, to
// the last decimal, in every ring. `testTheTwoAltitudeCurvesAreOneCurve` proves
// it. That is why ``height(forBodyAltitude:)`` can be the only vertical
// conversion in the instrument.

/// Which of the room's own surfaces a thing acts on.
///
/// There is no `.none`, and no fourth case for "in the air". A room is made of
/// material, and everything that happens in it happens to some of that material
/// — that is the binding condition the renderer ruling carries, stated in the
/// coordinate system before ``RoomMaterial`` states it in the API.
enum RoomSurfaceKind: String, CaseIterable, Equatable {
    /// The bedded floor. Everything felt low in the body acts here.
    case ground
    /// The mass overhead, seen from beneath. Everything felt at the crown.
    case canopy
    /// The working face: a panel of the room's own stone, standing at her own
    /// altitude and joined to the floor by a riser. Everything between.
    case face
    /// The room's sides. The world's weather falls across them; no attribute
    /// ever acts here, because a wall is not where a body is felt.
    case wall
}

/// A point on a surface. Two numbers, both `0…1`, and deliberately only two:
/// a coordinate that cannot name a third axis cannot name a point in the air.
struct SurfaceCoordinate: Equatable {
    /// Across the surface. `0.5` is straight in front of the walker.
    var u: Double
    /// Along the surface, away from the walker on the floor and the canopy,
    /// and up the face.
    var v: Double

    static let centre = SurfaceCoordinate(u: 0.5, v: 0.5)

    /// Clamped into the surface. A mark that wandered off the material is a
    /// mark on nothing, so it is brought back onto it rather than dropped.
    var clamped: SurfaceCoordinate {
        SurfaceCoordinate(u: min(1, max(0, u)), v: min(1, max(0, v)))
    }
}

/// Where in the room one Śakti's mark falls, and on what.
struct RoomPlacement: Equatable {
    /// `0` crown … `1` soles, straight off her row.
    let bodyAltitude: Double
    /// The surface her altitude puts her on.
    let surface: RoomSurfaceKind
    /// The scene height of that surface where the mark lands.
    let height: Double
    /// The scene depth of the mark: negative is away from the walker.
    let depth: Double
    /// The footprint radius of everything she does, in scene units. Grows
    /// through the second adaptation, exactly as Design's mount does.
    let footprint: Double
    /// Where on that surface the mark lands.
    let coordinate: SurfaceCoordinate

    /// The mark's point in scene space — for a light to sit at, and for the
    /// light pass to project. Never for a mesh: nothing in the spine turns a
    /// point into a solid.
    var point: SIMD3<Double> { SIMD3(0, height, depth) }
}

/// The room's coordinate system, and the single place grammar output becomes
/// scene space.
enum RoomUnits {

    // MARK: - The vertical axis, derived

    /// The scene height of a body altitude — **the only vertical conversion in
    /// the instrument.**
    ///
    /// Read straight out of ``HomeAttribute/mount(bodyAltitude:chamberTime:)``
    /// rather than restated, so the mark, the surfaces, the camera and the
    /// lights can never drift from Design's own placement.
    static func height(forBodyAltitude altitude: Double) -> Double {
        HomeAttribute.mount(bodyAltitude: altitude, chamberTime: 0).y
    }

    /// The floor: where the soles' extreme resolves to.
    static let floorY: Double = height(forBodyAltitude: 1)

    /// The canopy: where the crown's extreme resolves to.
    static let canopyY: Double = height(forBodyAltitude: 0)

    /// The room is exactly one body tall.
    static let roomHeight: Double = canopyY - floorY

    /// The mount's own offset — `-0.4` in Design's numbers, read rather than
    /// typed. It is what makes the room's middle sit a little below the body's.
    static let mountOffset: Double = height(forBodyAltitude: 0.5)

    /// The grammar's altitude span in a ring: `9` in rings 1–3, `8` elsewhere.
    /// Derived from ``HomeGrammar/altitude(ring:bodyAltitude:)`` at the crown,
    /// so a change there arrives here instead of being missed.
    static func grammarSpan(ring: Int) -> Double {
        HomeGrammar.altitude(ring: ring, bodyAltitude: 0) * 2
    }

    /// The grammar's own altitude, expressed in the room's units.
    ///
    /// This is the identity the header names: for every ring and every
    /// altitude, this returns exactly ``height(forBodyAltitude:)``. It exists
    /// as a named function anyway, because a room holding a
    /// ``HomeGrammar/Reading`` has its `altitude` in hand and must not be
    /// tempted to divide by 9 itself.
    static func height(forGrammarAltitude altitude: Double, ring: Int) -> Double {
        let span = grammarSpan(ring: ring)
        guard span != 0 else { return mountOffset }
        return altitude * roomHeight / span + mountOffset
    }

    // MARK: - The eye

    /// Where the body's eyes are, read off the zone table rather than chosen.
    /// The vocabulary word is Design's own — `behind the eyes|eyes|face` — and
    /// the altitude it resolves to is Design's 0.26.
    static let eyeAltitude: Double = HomeGrammar.bodyAltitude(bodilyLocation: "behind the eyes")

    /// The walker's eye height. A consequence, not a choice.
    static let eyeY: Double = height(forBodyAltitude: eyeAltitude)

    /// How far back the walker stands from the room's origin: half a body's
    /// height, so a mark at its resting depth is a little over one body-height
    /// away — close enough to read, far enough to be a room rather than a face
    /// pressed against one.
    static let eyeZ: Double = roomHeight / 2

    /// How far the eye inclines toward her mark, as a fraction of the whole
    /// angle to it.
    ///
    /// **This is the constant that keeps her altitude legible.** At `1` the eye
    /// would look straight at her and every Śakti's mark would sit dead centre,
    /// which would erase the difference between the soles and the crown — the
    /// exact inversion the spike caught. At `0` her mark leaves the frame
    /// entirely once the second adaptation brings it close. A little over half
    /// way keeps a soles mark low in the frame and a crown mark high, at both
    /// adaptations, with the mark on screen throughout.
    static let gaze: Double = 0.55

    /// The eye's pitch for a placement, in radians. Negative looks down.
    static func eyePitch(toward placement: RoomPlacement) -> Double {
        eyePitch(toward: placement, fromDepth: eyeZ)
    }

    /// The same, from somewhere other than where he will stand — the approach.
    ///
    /// One formula, not two: the crossing toward her room changes only how far
    /// back the eye is, so it is the same inclination read at a longer distance,
    /// and her altitude stays legible the whole way in rather than becoming
    /// legible on arrival.
    static func eyePitch(toward placement: RoomPlacement, fromDepth depth: Double) -> Double {
        let distance = depth - placement.depth
        guard distance > 0.0001 else { return 0 }
        return -gaze * atan2(eyeY - placement.height, distance)
    }

    /// How far behind his standing place the walker begins the crossing in.
    ///
    /// **One body-height, and it is derived rather than tuned.** The room is one
    /// body tall (``roomHeight``), so beginning one body behind where he will
    /// stand puts him exactly one room's depth outside it — far enough that the
    /// approach is a real crossing, near enough that her room is the thing he is
    /// crossing toward rather than a light in the distance.
    ///
    /// Nothing else about the approach is a number. The air does the rest by
    /// itself: SceneKit's fog is a **distance** band, and the world's own veil
    /// already sets where it closes (``RoomLightRig/applyFog(to:)``), so a
    /// walker standing a body-height further out is genuinely looking through
    /// more of the world's air — thin in the first āvaraṇa, nearly opaque in the
    /// ninth. The veil is not re-stated here, and it must not be: it is the same
    /// fact seen from further away.
    static let approachStandOff: Double = roomHeight

    /// Where the eye stands at a point on the crossing, `0` at the far end and
    /// `1` in the room.
    static func eyeDepth(approach: Double) -> Double {
        eyeZ + (1 - HomeGrammar.smooth(approach)) * approachStandOff
    }

    // MARK: - The horizontal axis

    /// How many body-heights the room reaches, across and away.
    ///
    /// The one proportion this file chooses. Four is far enough that the walls
    /// are not in the walker's face at the mark's resting depth of 4.6 units,
    /// and near enough that a world's fog closes on a wall the walker can still
    /// see. Design's own rooms are halls; a hall that cannot be crossed is a
    /// field.
    static let extentFactor: Double = 4

    /// The floor's width and depth, in scene units.
    static let extent: Double = roomHeight * extentFactor
    static let halfExtent: Double = extent / 2

    /// The working face is one body-height square: large enough to be a wall of
    /// the room rather than a panel hung in it, small enough that a mark on it
    /// reads as a mark rather than as weather.
    static let faceSpan: Double = roomHeight

    /// How deep the riser is — the column of the room's own stone the working
    /// face is the top of. A third of the face's span, which is what makes it a
    /// column rather than a fin.
    ///
    /// It is named here because two places need it and need to agree: the box is
    /// built this deep, and it is then stood back by half of it so that it rises
    /// *behind* her working surface rather than through it.
    static let riserDepth: Double = faceSpan * 0.3

    /// The span of one surface in scene units, so a world-space footprint can
    /// be turned into a surface-space reach without a room knowing which
    /// surface it is standing on.
    static func span(of surface: RoomSurfaceKind) -> Double {
        switch surface {
        case .ground, .canopy, .wall: return extent
        case .face: return faceSpan
        }
    }

    // MARK: - The camera

    /// Design's own field of view, carried through the spike. SceneKit reads
    /// `fieldOfView` on the larger axis, which in portrait is the vertical one.
    static let fieldOfView: Double = 62

    /// Near enough that the face at full depth is not clipped; far enough that
    /// the ninth world's climb is still in front of the walker.
    static let zNear: Double = 0.1
    static let zFar: Double = climbHeight + extent

    // MARK: - Which surface, and where on it

    /// How close to the floor or the canopy a mark must be before it stops
    /// standing on a face of its own and becomes an impression in the room's
    /// own floor or ceiling.
    ///
    /// Derived from the zone table's extremes rather than chosen: the deepest
    /// zone Design writes is the soles at `0.94` and the highest is the crown
    /// at `0.10`, so this is exactly the gap between the room's own floor and
    /// the lowest place a body is felt — the distance that means *at the floor*.
    static let fuseReach: Double = {
        let deepest = HomeGrammar.bodyZones.map(\.altitude).max() ?? 1
        let highest = HomeGrammar.bodyZones.map(\.altitude).min() ?? 0
        return max(height(forBodyAltitude: deepest) - floorY,
                   canopyY - height(forBodyAltitude: highest))
    }()

    /// Which of the room's surfaces this altitude acts on.
    static func surface(forBodyAltitude altitude: Double) -> RoomSurfaceKind {
        let y = height(forBodyAltitude: altitude)
        if y - floorY <= fuseReach { return .ground }
        if canopyY - y <= fuseReach { return .canopy }
        return .face
    }

    /// The scene height of the surface an altitude acts on. The floor and the
    /// canopy keep their own height — a mark in a floor is at the floor, not
    /// hovering above it — and a face stands at her altitude exactly.
    static func surfaceHeight(forBodyAltitude altitude: Double) -> Double {
        switch surface(forBodyAltitude: altitude) {
        case .ground: return floorY
        case .canopy: return canopyY
        case .face, .wall: return height(forBodyAltitude: altitude)
        }
    }

    /// Where one Śakti's mark falls at a moment of her chamber clock.
    ///
    /// Everything about the placement except the altitude comes out of
    /// ``HomeAttribute/mount(bodyAltitude:chamberTime:)``: the depth that
    /// closes on the walker through the second adaptation, and the footprint
    /// that grows as the attribute stops being an object and becomes the room.
    static func placement(bodyAltitude altitude: Double,
                          chamberTime t: TimeInterval) -> RoomPlacement {
        let mount = HomeAttribute.mount(bodyAltitude: altitude, chamberTime: t)
        let kind = surface(forBodyAltitude: altitude)
        let height = surfaceHeight(forBodyAltitude: altitude)
        let footprint = mount.scale * footprintFactor
        let coordinate: SurfaceCoordinate
        switch kind {
        case .ground, .canopy, .wall:
            // Depth across the floor or the canopy, from the walker toward the
            // far wall. The room's own origin is the middle of the surface.
            coordinate = SurfaceCoordinate(u: 0.5, v: 0.5 + mount.z / extent).clamped
        case .face:
            // The face stands at her altitude and the mark is its centre; the
            // face itself is what moves toward the walker.
            coordinate = .centre
        }
        return RoomPlacement(bodyAltitude: altitude,
                             surface: kind,
                             height: height,
                             depth: mount.z,
                             footprint: footprint,
                             coordinate: coordinate)
    }

    /// How far the mark's own ember stands off the surface it was made in.
    ///
    /// **Off, not up.** The ember is the light *in* a mark, so it belongs on
    /// the walker's side of the material the mark is in — above a floor, below
    /// a canopy, in front of a face. Reading "off" as "up" everywhere puts a
    /// crown Śakti's ember on the far side of her own ceiling: the canopy's
    /// normals point down into the room, so the surface her mark is in receives
    /// nothing at all from the light that is supposed to be coming out of it,
    /// and the grain this file gives the stone — which exists so that a raking
    /// light has something to fall across — goes unlit for the whole stay. That
    /// is the authoring defect Design's own verification pass named, with Ring
    /// 1's Mātṛkās reading as one flat plane.
    ///
    /// An eighth of a body-height, and it is one distance for all three: what
    /// changes between surfaces is which way *off* points, not how far.
    static let emberStandOff: Double = roomHeight * 0.12

    /// Which way off the surface, in scene units.
    static func emberOffset(for surface: RoomSurfaceKind) -> SIMD3<Double> {
        switch surface {
        case .ground, .wall: return SIMD3(0, emberStandOff, 0)
        case .canopy:        return SIMD3(0, -emberStandOff, 0)
        case .face:          return SIMD3(0, 0, emberStandOff)
        }
    }

    /// Where the ember stands for one placement — the mark, offset onto the
    /// walker's side of the material it is in.
    static func emberPoint(for placement: RoomPlacement) -> SIMD3<Double> {
        let offset = emberOffset(for: placement.surface)
        return SIMD3(offset.x, placement.height + offset.y, placement.depth + offset.z)
    }

    /// What one unit of Design's mount scale is worth on a surface.
    ///
    /// A quarter of a body-height. At rest the mount is `0.9`, so her footprint
    /// is a little over a third of a body-height across; past the second
    /// adaptation it is `3.5`, and her footprint is one and a half. That is
    /// Design's §4.4 — the attribute grows into the room — in scene units.
    static let footprintFactor: Double = roomHeight / 4

    // MARK: - The climb

    /// The nine worlds as one continuous vertical world, floor to floor.
    ///
    /// Design's nine āvaraṇas are a single climb from the Feet to Totality, so
    /// each ring's floor stands one body-height above the last and the whole
    /// climb is nine bodies tall.
    ///
    /// **Keyed by ring, not by the region's words, and deliberately.** The
    /// region names in ``HomeWorlds/worlds`` are `Feet · Pelvis · Navel · Heart
    /// · Throat · Forehead · Crown · Above crown · Totality`, and two of them
    /// fall outside Design's own zone vocabulary: `Pelvis` has no rule at all
    /// and lands at the middle of the body, and `Above crown` reaches the
    /// `crown|above` rule and so shares the Crown's altitude exactly. Reading
    /// the climb off those words would give a world below the one beneath it
    /// and two worlds at the same height. The gap is Design's, it is recorded
    /// here rather than papered over — `testTheWorldRegionVocabularyHasTwoGaps`
    /// asserts it out loud — and the fix belongs with the live rows, not with a
    /// word invented in this file.
    static func worldFloorY(ring: Int) -> Double {
        floorY + Double(ring - 1) * roomHeight
    }

    /// The whole climb, from the first world's floor to the ninth's canopy.
    static let climbHeight: Double = roomHeight * Double(HomeWorlds.rings.count)

    /// The altitude the ring's own body region resolves to, for a world's
    /// weather rather than for its station in the climb. Carries the two gaps
    /// named above; callers that need a monotone climb use ``worldFloorY(ring:)``.
    static func worldRegionAltitude(ring: Int) -> Double {
        guard let world = HomeWorlds.world(ring: ring) else { return 0.5 }
        return HomeGrammar.bodyAltitude(bodilyLocation: world.region)
    }

    // MARK: - Projection

    /// Where a scene point lands on the layer, in points.
    ///
    /// Computed here rather than asked of a renderer, for the reason the spike
    /// wrote down: the camera track is a pure function of the placement and the
    /// clock, so the light pass can be evaluated — and asserted — for any scene
    /// time with no view in the room.
    static func project(_ point: SIMD3<Double>,
                        eye: SIMD3<Double>,
                        pitch: Double,
                        size: CGSize) -> CGPoint {
        guard size.width > 0, size.height > 0 else { return .zero }
        let dx = point.x - eye.x
        let dy = point.y - eye.y
        let dz = point.z - eye.z
        let c = cos(-pitch), s = sin(-pitch)
        let y = dy * c - dz * s
        let z = dy * s + dz * c
        // Behind the eye, or level with it: report the bottom of the frame
        // rather than a mirrored ghost in front.
        guard z < -0.05 else { return CGPoint(x: size.width / 2, y: size.height) }
        let focal = 1 / tan(fieldOfView * .pi / 180 / 2)
        let aspect = max(0.0001, size.width / size.height)
        let ndcX = (dx * focal / -z) / aspect
        let ndcY = y * focal / -z
        return CGPoint(x: (ndcX * 0.5 + 0.5) * size.width,
                       y: (0.5 - ndcY * 0.5) * size.height)
    }

    /// Where her mark lands on the layer at a moment of her stay — the whole
    /// camera track and projection in one call, so no room repeats it.
    ///
    /// `approach` is where the walker stands on his way in, `1` being in the
    /// room. It is here rather than in the light pass because the mark's place
    /// on the layer and the eye's place in the room are one fact: leave it out
    /// and the light in her mark sits where the walker is *going to* stand
    /// instead of where he is.
    static func markOnScreen(bodyAltitude altitude: Double,
                             chamberTime t: TimeInterval,
                             size: CGSize,
                             approach: Double = 1) -> CGPoint {
        let placement = placement(bodyAltitude: altitude, chamberTime: t)
        let depth = eyeDepth(approach: approach)
        return project(placement.point,
                       eye: SIMD3(0, eyeY, depth),
                       pitch: eyePitch(toward: placement, fromDepth: depth),
                       size: size)
    }
}
