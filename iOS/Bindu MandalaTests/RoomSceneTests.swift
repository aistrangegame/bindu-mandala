import XCTest
import SceneKit
@testable import Bindu_Mandala

// MARK: - The render spine, judged
//
// Phase 3.1 builds the layer every one of the 102 rooms is assembled on, so
// almost everything here is a check on a *shape* rather than on a room: get the
// shape right and 3.3 through 3.6 are assembly; get it wrong and ninety rooms
// inherit the mistake.
//
// Four of these checks exist because of the renderer ruling rather than in
// spite of it, and they are the ones to read first if it is ever revisited:
//
//   * `testTheMaterialVocabularyCannotNameAnObject`
//   * `testLightCannotExistWithoutDeformation`
//   * `testAMechanismCanOnlyReturnActionsOnSurfaces`
//   * `testHerLayerHoldsNoSolid`
//
// Together they are the ruling's own precondition — *"if Phase 3.1 cannot
// express 'an action on the room's own material' as the only way to mount an
// attribute, then the aniconic risk is unbounded"* — held to, in four different
// registers: the type system, the arithmetic, the protocol, and the live graph.
@MainActor
final class RoomSceneTests: XCTestCase {

    // MARK: - Fixtures

    /// The render spine's own source, read off disk. The same technique
    /// `LawsTests` uses and for the same reason: some of what is asserted here
    /// is about what the source has no room to grow, which no run-time value
    /// can show.
    private func renderSource(_ name: String) throws -> String {
        let url = URL(fileURLWithPath: #filePath)
            .resolvingSymlinksInPath()
            .deletingLastPathComponent()      // Bindu MandalaTests
            .deletingLastPathComponent()      // iOS
            .appendingPathComponent("Bindu Mandala/Homes/Render/\(name)")
        return try String(contentsOf: url, encoding: .utf8)
    }

    /// A room at a position, built from plain values so nothing is bundled.
    /// Ring 2's sixteen are the only Śaktis that ship in the binary; everything
    /// else is driven by real tattva vocabulary keyed off position, exactly as
    /// `HomeGrammarTests` and `HomesHarnessTests` drive theirs.
    private func room(position: Int, ring: Int,
                      tattva: String = "Pṛthivī", quality: String = "she who attracts",
                      bodilyLocation: String) -> HomeRoom {
        guard let room = HomeRooms.resolve(position: position, ring: ring,
                                           tattva: tattva, quality: quality,
                                           bodilyLocation: bodilyLocation) else {
            fatalError("no room resolved at position \(position)")
        }
        return room
    }

    private var solesRoom: HomeRoom { room(position: 4, ring: 1, bodilyLocation: "soles") }
    private var crownRoom: HomeRoom { room(position: 93, ring: 7, bodilyLocation: "crown") }
    private var heartRoom: HomeRoom { room(position: 57, ring: 4, bodilyLocation: "heart") }

    // MARK: - The units: the room is the body

    /// The grammar's altitude curve and the attribute's mount are the same
    /// curve in different units, and ``RoomUnits`` is where they are made one.
    ///
    /// This is the finding the whole conversion rests on. The grammar writes
    /// `(0.5 - alt) * 9` in rings 1–3 and `* 8` elsewhere; the attribute writes
    /// `(0.5 - alt) * 6.4 - 0.4`. Normalise the grammar's span into the room's
    /// own height, add the mount's own offset, and the two land on the same
    /// point in every ring, at every altitude. If they ever stop agreeing, a
    /// room's furniture and a room's mark are in two different rooms.
    func testTheTwoAltitudeCurvesAreOneCurve() {
        for ring in HomeWorlds.rings {
            for step in 0...20 {
                let altitude = Double(step) / 20
                let grammar = HomeGrammar.altitude(ring: ring, bodyAltitude: altitude)
                XCTAssertEqual(RoomUnits.height(forGrammarAltitude: grammar, ring: ring),
                               RoomUnits.height(forBodyAltitude: altitude),
                               accuracy: 1e-9,
                               "ring \(ring) at altitude \(altitude): the grammar and the mount disagree about where she is")
            }
        }
    }

    /// The room's floor, canopy and eye are consequences of the body, not
    /// choices — and nothing in the spine restates them.
    func testTheRoomIsTheBody() throws {
        XCTAssertEqual(RoomUnits.floorY,
                       HomeAttribute.mount(bodyAltitude: 1, chamberTime: 0).y, accuracy: 1e-9,
                       "the floor is not where the soles' extreme resolves to")
        XCTAssertEqual(RoomUnits.canopyY,
                       HomeAttribute.mount(bodyAltitude: 0, chamberTime: 0).y, accuracy: 1e-9,
                       "the canopy is not where the crown's extreme resolves to")
        XCTAssertGreaterThan(RoomUnits.roomHeight, 0)
        XCTAssertEqual(RoomUnits.roomHeight, RoomUnits.canopyY - RoomUnits.floorY, accuracy: 1e-9)

        // The eye stands where the body's eyes are, read off Design's own zone
        // vocabulary rather than chosen.
        XCTAssertEqual(RoomUnits.eyeAltitude,
                       HomeGrammar.bodyAltitude(bodilyLocation: "behind the eyes"), accuracy: 1e-9)
        XCTAssertGreaterThan(RoomUnits.eyeY, RoomUnits.floorY, "the eye is under the floor")
        XCTAssertLessThan(RoomUnits.eyeY, RoomUnits.canopyY, "the eye is above the ceiling")
        // …and nearer the crown than the floor, because eyes are.
        XCTAssertGreaterThan(RoomUnits.eyeY - RoomUnits.floorY,
                             RoomUnits.canopyY - RoomUnits.eyeY,
                             "the eye sits in the lower half of the body")

        // Not one clock mark and not one altitude number is written down twice.
        for name in ["RoomUnits.swift", "RoomScene.swift", "RoomLightRig.swift",
                     "RoomView.swift", "RoomMaterial.swift"] {
            let source = try renderSource(name)
            for restated in ["6.4", "-4.6", "0.94", "227", "347"] {
                XCTAssertFalse(source.contains(" = \(restated)") || source.contains("(\(restated))"),
                               "\(name) restates \(restated) — it belongs to HomeAttribute, HomeGrammar or HomeMemory")
            }
        }
    }

    /// Which surface an altitude acts on, at both ends of the body and in the
    /// middle. There is no fourth answer, and no answer that is "in the air".
    func testTheSurfaceAnAltitudeActsOnIsTheOneNearestIt() {
        XCTAssertEqual(RoomUnits.surface(forBodyAltitude: HomeGrammar.bodyAltitude(bodilyLocation: "soles")),
                       .ground, "a Śakti felt at the soles does not act on the floor")
        XCTAssertEqual(RoomUnits.surface(forBodyAltitude: HomeGrammar.bodyAltitude(bodilyLocation: "crown")),
                       .canopy, "a Śakti felt at the crown does not act overhead")
        XCTAssertEqual(RoomUnits.surface(forBodyAltitude: HomeGrammar.bodyAltitude(bodilyLocation: "heart")),
                       .face, "a Śakti felt at the heart has no face to act on")

        // Every zone Design writes resolves to a surface, and the surface's
        // height is always inside the room.
        for zone in HomeGrammar.bodyZones {
            let y = RoomUnits.surfaceHeight(forBodyAltitude: zone.altitude)
            XCTAssertGreaterThanOrEqual(y, RoomUnits.floorY - 1e-9, "\(zone.js) is under the floor")
            XCTAssertLessThanOrEqual(y, RoomUnits.canopyY + 1e-9, "\(zone.js) is above the ceiling")
        }
    }

    /// The conversion is Design's mount, unchanged: the depth that closes on
    /// the walker and the footprint that grows are hers, not this file's.
    func testThePlacementIsDesignsMountAndNothingElse() {
        for altitude in [0.94, 0.5, 0.1] {
            for t in [0.0, HomeMemory.firstAdaptation, HomeMemory.holdEnd, HomeMemory.secondAdaptationEnd] {
                let mount = HomeAttribute.mount(bodyAltitude: altitude, chamberTime: t)
                let placement = RoomUnits.placement(bodyAltitude: altitude, chamberTime: t)
                XCTAssertEqual(placement.depth, mount.z, accuracy: 1e-9)
                XCTAssertEqual(placement.footprint, mount.scale * RoomUnits.footprintFactor, accuracy: 1e-9)
                XCTAssertEqual(placement.bodyAltitude, altitude, accuracy: 1e-9)
            }
        }

        // The attribute comes toward the walker as the stay deepens; it never
        // retreats, and it never arrives behind her.
        let near = RoomUnits.placement(bodyAltitude: 0.5, chamberTime: HomeMemory.secondAdaptationEnd)
        let far = RoomUnits.placement(bodyAltitude: 0.5, chamberTime: 0)
        XCTAssertGreaterThan(near.depth, far.depth, "the attribute did not grow into the room")
        XCTAssertLessThan(near.depth, RoomUnits.eyeZ, "the attribute arrived behind the walker")
        XCTAssertGreaterThan(near.footprint, far.footprint)
    }

    /// **Her mark lands where her body altitude says, and the spike caught this
    /// exact thing inverted.**
    ///
    /// A Śakti felt at the soles must read LOW in the frame and one felt at the
    /// crown must read HIGH — at the opening, at the first adaptation and past
    /// the second, and on screen throughout. Nothing here is tuned: the camera
    /// stands where ``RoomUnits`` puts it and the mark falls where Design's
    /// mount puts it.
    func testHerMarkLandsWhereHerBodyAltitudeSays() {
        let size = CGSize(width: 393, height: 852)   // a phone, in points
        let soles = HomeGrammar.bodyAltitude(bodilyLocation: "soles")
        let crown = HomeGrammar.bodyAltitude(bodilyLocation: "crown")

        for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
            let low = RoomUnits.markOnScreen(bodyAltitude: soles, chamberTime: t, size: size)
            let high = RoomUnits.markOnScreen(bodyAltitude: crown, chamberTime: t, size: size)

            XCTAssertGreaterThan(low.y / size.height, 0.55,
                                 "at t=\(Int(t)) a Śakti felt at the soles is not low in the frame")
            XCTAssertLessThan(low.y / size.height, 1.0,
                              "at t=\(Int(t)) her mark has left the bottom of the frame")
            XCTAssertLessThan(high.y / size.height, 0.5,
                              "at t=\(Int(t)) a Śakti felt at the crown is not high in the frame")
            XCTAssertGreaterThan(high.y / size.height, 0.0,
                                 "at t=\(Int(t)) her mark has left the top of the frame")
            XCTAssertGreaterThan(low.y, high.y,
                                 "at t=\(Int(t)) the soles and the crown are the same way up")
            // And both are straight in front of the walker, not off to a side.
            XCTAssertEqual(low.x, size.width / 2, accuracy: 1)
            XCTAssertEqual(high.x, size.width / 2, accuracy: 1)
        }

        // Every zone in the body, in order, reads in order on screen. This is
        // the check that would fail if the camera were ever tuned per room.
        let ordered = HomeGrammar.bodyZones.map(\.altitude).sorted()
        var lastY = -Double.infinity
        for altitude in ordered {
            let y = Double(RoomUnits.markOnScreen(bodyAltitude: altitude,
                                                  chamberTime: HomeMemory.firstAdaptation,
                                                  size: size).y)
            XCTAssertGreaterThanOrEqual(y, lastY - 1e-6,
                                        "altitude \(altitude) breaks the order of the body in the frame")
            lastY = y
        }
    }

    /// The climb is one continuous vertical world — and the two places where
    /// Design's region vocabulary cannot carry it are named rather than fixed.
    func testTheWorldClimbIsMonotoneAndTheRegionVocabularyHasTwoGaps() {
        var last = -Double.infinity
        for ring in HomeWorlds.rings {
            let y = RoomUnits.worldFloorY(ring: ring)
            XCTAssertGreaterThan(y, last, "ring \(ring) does not stand above ring \(ring - 1)")
            last = y
        }
        XCTAssertEqual(RoomUnits.climbHeight,
                       RoomUnits.roomHeight * Double(HomeWorlds.rings.count), accuracy: 1e-9)

        // The gap, asserted out loud so it stays a known finding rather than a
        // silent wrong answer. `Pelvis` reaches no rule at all and falls to the
        // middle of the body; `Above crown` reaches the `crown|above` rule and
        // so shares the Crown's altitude exactly. The fix belongs with the live
        // rows, not with a word invented in the spine.
        let middle = HomeGrammar.bodyAltitude(bodilyLocation: "")
        XCTAssertEqual(RoomUnits.worldRegionAltitude(ring: 2), middle, accuracy: 1e-9,
                       "ring 2's region `Pelvis` now resolves — the recorded gap has closed and this note is stale")
        XCTAssertEqual(RoomUnits.worldRegionAltitude(ring: 8),
                       RoomUnits.worldRegionAltitude(ring: 7), accuracy: 1e-9,
                       "ring 8's `Above crown` no longer shares the Crown's altitude — the recorded gap has changed")
    }

    // MARK: - The binding condition · the type system

    /// **The material vocabulary cannot name an object.**
    ///
    /// The ruling asks for the free-standing lit solid to be *unrepresentable*
    /// rather than forbidden. Three things make it so, and all three are read
    /// off the file itself, because a run-time value cannot show what a type
    /// has no room for:
    ///
    ///   * the file imports nothing that can draw, so no noun in it denotes a
    ///     body;
    ///   * ``SurfaceAction``'s memberwise initialiser is private, so the five
    ///     verbs are the only way one exists;
    ///   * the placement vocabulary has two axes, so there is nowhere in the
    ///     air for an object to be.
    func testTheMaterialVocabularyCannotNameAnObject() throws {
        let source = try renderSource("RoomMaterial.swift")

        // 1 · nothing that can draw is even in scope.
        for forbidden in ["import SceneKit", "import SwiftUI", "import UIKit", "import Metal",
                         "import SpriteKit", "import RealityKit"] {
            XCTAssertFalse(source.contains(forbidden),
                           "RoomMaterial.swift imports \(forbidden) — the vocabulary can now name a body")
        }
        for noun in ["SCNNode", "SCNGeometry", "SCNBox", "SCNSphere", "SCNCone", "SCNCylinder",
                     "SCNPlane", "SCNMaterial", "SCNLight", "SCNScene", "MTKMesh", "UIBezierPath"] {
            XCTAssertFalse(source.contains(noun),
                           "RoomMaterial.swift names \(noun) — an attribute could now be a thing")
        }

        // 2 · the only initialiser is private, and the only constructors are
        //     the five verbs.
        XCTAssertTrue(source.contains("private init(verb:"),
                      "SurfaceAction's initialiser is no longer private — anything can be constructed now")
        let constructors = Set(matches(#"static func ([a-zA-Z]+)\(at where_:"#, in: source))
        XCTAssertEqual(constructors, Set(SurfaceVerb.allCases.map(\.rawValue)),
                       """
                       the ways of making a SurfaceAction have changed. Every one of them must be \
                       something that happens to a surface. A sixth has to be argued for here, where \
                       the ruling is.
                       """)

        // 3 · the placement vocabulary has two axes and no third.
        XCTAssertEqual(Mirror(reflecting: SurfaceCoordinate.centre).children.count, 2,
                       "SurfaceCoordinate grew an axis — a mark can now be somewhere other than on a surface")

        // And every verb really moves material: none of them is a no-op that a
        // glow could be hung on.
        for verb in SurfaceVerb.allCases {
            let action = Self.action(verb, at: .centre, reach: 0.2, depth: 0.5, glow: 1)
            XCTAssertGreaterThan(abs(action.relief(at: .centre)), 0.01,
                                 "\(verb.rawValue) does nothing to the material it is acting on")
        }
    }

    /// **Light cannot exist without deformation.**
    ///
    /// The third thing a free-standing solid would need is its own light. There
    /// is none here: an action's `glow` is multiplied by how far that action
    /// actually moved the material, so a mark that does nothing to the surface
    /// emits nothing, anywhere, at any strength.
    func testLightCannotExistWithoutDeformation() {
        for verb in SurfaceVerb.allCases {
            // Asking for the brightest possible mark with no depth at all.
            var material = RoomMaterial(surface: .ground, seed: 4)
            material.receive(Self.action(verb, at: .centre, reach: 0.3, depth: 0, glow: 1))
            for step in 0...10 {
                let point = SurfaceCoordinate(u: Double(step) / 10, v: Double(step) / 10)
                XCTAssertEqual(material.emission(at: point), 0, accuracy: 1e-12,
                               "\(verb.rawValue) emits light without touching the material")
            }

            // …and with depth, the light exists only where the material moved.
            var marked = RoomMaterial(surface: .ground, seed: 4)
            marked.receive(Self.action(verb, at: .centre, reach: 0.05, depth: 0.4, glow: 1))
            XCTAssertGreaterThan(marked.emission(at: .centre), 0.1,
                                 "\(verb.rawValue) makes a mark that does not light")
            let faraway = SurfaceCoordinate(u: 0.95, v: 0.95)
            XCTAssertEqual(marked.emission(at: faraway), 0, accuracy: 1e-9,
                           "\(verb.rawValue) lights material it never touched")
        }

        // A zero-reach mark is nothing happening, and lights nothing.
        var nothing = RoomMaterial(surface: .ground, seed: 1)
        nothing.receive(.impression(at: .centre, reach: 0, depth: 1, glow: 1))
        XCTAssertEqual(nothing.emission(at: .centre), 0, accuracy: 1e-12)
    }

    /// **A mechanism can only return actions on surfaces.**
    ///
    /// The binding condition for Phase 3.3, which builds the eight authored
    /// rooms. The hook's return type is the whole of it: there is no path out
    /// of a mechanism for a node, a mesh, a light or a shape, and the stage it
    /// is handed carries no scene for it to reach around into.
    func testAMechanismCanOnlyReturnActionsOnSurfaces() throws {
        let source = try renderSource("RoomScene.swift")
        XCTAssertTrue(source.contains(
            "func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]]"),
            "the mechanism hook's signature has changed — it is the binding condition for the authored eight")

        // The stage vends materials and numbers, and nothing that could hold a
        // child.
        let stage = RoomStage(placement: RoomUnits.placement(bodyAltitude: 0.5, chamberTime: 0),
                              settling: 0, deep: 0, materials: [:])
        for child in Mirror(reflecting: stage).children {
            let type = String(describing: Swift.type(of: child.value))
            XCTAssertFalse(type.contains("SCN"),
                           "RoomStage carries \(type) — a mechanism can now reach the scene graph")
        }
    }

    /// **Her layer holds no solid.** The binding condition, in the live graph.
    ///
    /// Design's third depth layer is her mechanism, and under the ruling it
    /// owns no mesh: what it holds is the light in the mark it made. This walks
    /// the assembled scene of rooms at all three surfaces and counts.
    func testHerLayerHoldsNoSolid() {
        for room in [solesRoom, crownRoom, heartRoom] {
            let scene = RoomScene(room: room)
            XCTAssertEqual(scene.solidsInHerLayer, 0,
                           """
                           position \(room.position): a geometry appeared under her own layer. Every \
                           attribute in every room is an action on the room's own material — an \
                           impression, a furrow, a crack, a swell — and never a free-standing lit solid.
                           """)
            XCTAssertGreaterThan(scene.herLayer.childNodes.count, 0,
                                 "her layer is empty — the light in her mark is missing")
        }
    }

    /// Her attribute reaches the room as actions on its material, and as
    /// nothing else — for every one of Design's twenty-six forms.
    func testEveryFormActsOnTheMaterialAndOnlyOnIt() {
        var verbsSeen: Set<SurfaceVerb> = []
        var formsRead = 0
        let material = RoomMaterial(surface: .ground, seed: 4)
        let placement = RoomUnits.placement(bodyAltitude: 0.94, chamberTime: 0)

        for (position, key) in HomeAttribute.attributeKeys.sorted(by: { $0.key < $1.key }) {
            guard let actor = HomeAttribute.actor(atPosition: position, bodilyLocation: "soles"),
                  HomeAttribute.resolve(designKey: key) != nil else { continue }
            formsRead += 1
            for t in stride(from: 0.0, through: 240.0, by: 30.0) {
                let actions = RoomInscription.actions(for: actor, at: t,
                                                      on: material, placement: placement)
                XCTAssertFalse(actions.isEmpty, "position \(position) does nothing to the room")
                for action in actions {
                    verbsSeen.insert(action.verb)
                    // Nothing can be placed outside the material it is acting on.
                    XCTAssertGreaterThanOrEqual(action.at.u, 0)
                    XCTAssertLessThanOrEqual(action.at.u, 1)
                    XCTAssertGreaterThanOrEqual(action.at.v, 0)
                    XCTAssertLessThanOrEqual(action.at.v, 1)
                    XCTAssertLessThanOrEqual(action.depth, RoomInscription.markDepth * 2 + 1e-9,
                                             "position \(position) digs deeper than a mark")
                }
            }
        }

        XCTAssertEqual(formsRead, 102, "the attribute table was not read: \(formsRead)")
        XCTAssertGreaterThanOrEqual(verbsSeen.count, 3,
                                    """
                                    the twenty-six forms produce only \(verbsSeen.map { $0.rawValue }.sorted()) \
                                    across a whole stay. The verb is supposed to be read from what a part \
                                    does — if they all read alike, the classifier is not reading.
                                    """)
    }

    // MARK: - The light rig

    /// Her light, ring by ring — and the seventh really has no source.
    func testTheLightRigIsPerRingAndTheSeventhIsSourceless() {
        for ring in HomeWorlds.rings {
            guard let world = HomeWorlds.world(ring: ring) else {
                return XCTFail("ring \(ring) has no world")
            }
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: nil)
            let rig = RoomLightRig(gem: gem, world: world)

            if ring == HomeGem.sourcelessRing {
                XCTAssertNil(rig.key,
                             """
                             ring 7's pearl is sourceless at 0.95 and must have **no directional light \
                             at all** — not a dim one. A dim light is a direction to orient by, which \
                             is the one thing the Crown does not give.
                             """)
                XCTAssertTrue(rig.isSourceless)
            } else {
                guard let key = rig.key else {
                    return XCTFail("ring \(ring) lost its key light")
                }
                XCTAssertEqual(key.type, .directional)
                XCTAssertTrue(key.castsShadow, "ring \(ring) throws no shadow")
                XCTAssertEqual(Double(key.shadowRadius),
                               RoomLightRig.shadowRadius(diffuse: gem.diffuse), accuracy: 1e-6,
                               "ring \(ring)'s shadow does not follow its gem's diffusion")
            }

            // A room with no source is still a room: the ambient is one law for
            // all nine, and it gives the most diffuse gem the most light.
            XCTAssertEqual(Double(rig.ambient.intensity),
                           RoomLightRig.ambientIntensity(diffuse: gem.diffuse), accuracy: 1e-6)
            XCTAssertGreaterThan(Double(rig.ambient.intensity), 0)
            XCTAssertEqual(rig.ember.type, .omni)
        }

        // The Crown is the brightest-ambient room in the instrument, because it
        // is the most diffuse — not because a branch was written to rescue it.
        let crown = RoomLightRig.ambientIntensity(
            diffuse: HomeGem.behaviour[HomeGem.sourcelessRing]!.diffuse)
        for (ring, behaviour) in HomeGem.behaviour where ring != HomeGem.sourcelessRing {
            XCTAssertLessThan(RoomLightRig.ambientIntensity(diffuse: behaviour.diffuse), crown,
                              "ring \(ring) has more ambient light than the sourceless one")
        }

        // And the shader is told about sourcelessness in exactly one way: it is
        // handed no direction.
        let sourceless = RoomLightRig.rakeDirection(keyPosition: SIMD3(3, 4, 0), sourceless: true)
        XCTAssertEqual(sourceless, .zero)
        let directed = RoomLightRig.rakeDirection(keyPosition: SIMD3(3, 4, 0), sourceless: false)
        XCTAssertEqual(Double(directed.x * directed.x + directed.y * directed.y), 1, accuracy: 1e-9)
        XCTAssertLessThan(directed.y, 0, "screen y runs against world y, and the sign has flipped")
    }

    // MARK: - The clock

    /// The clock's marks are ``HomeMemory``'s, and the room cannot drift from
    /// the memory.
    func testTheClockIsHerMemorysAndNotTheRoomsOwn() {
        XCTAssertEqual(RoomClock.settled, HomeMemory.secondAdaptationEnd,
                       "the settled state is not the end of the second adaptation")

        let settled = RoomPose(sceneTime: RoomClock.settled, room: solesRoom)
        XCTAssertEqual(settled.settling, 1, accuracy: 1e-9)
        XCTAssertEqual(settled.deep, 1, accuracy: 1e-9)

        let opening = RoomPose(sceneTime: 0, room: solesRoom)
        XCTAssertEqual(opening.settling, 0, accuracy: 1e-9)
        XCTAssertEqual(opening.deep, 0, accuracy: 1e-9)

        let first = RoomPose(sceneTime: HomeMemory.firstAdaptation, room: solesRoom)
        XCTAssertEqual(first.settling, 1, accuracy: 1e-9)
        XCTAssertEqual(first.deep, 0, accuracy: 1e-9)

        let hold = RoomPose(sceneTime: HomeMemory.holdEnd, room: solesRoom)
        XCTAssertEqual(hold.deep, 0, accuracy: 1e-9, "the second adaptation began before the hold ended")

        // A returning walker's stay opens where her accumulated dwell says, and
        // the head start is the memory's function rather than a second copy.
        for dwell in [0.0, 11.0, 60.0, 4000.0] {
            let clock = RoomClock(accumulatedDwell: dwell)
            XCTAssertEqual(clock.opening, HomeMemory.headStart(dwell: dwell), accuracy: 1e-9)
            XCTAssertLessThanOrEqual(clock.opening, HomeMemory.headStartCap,
                                     "a return skipped past the hold — the ceremony is never skipped")
        }

        // The world's tempo scales the weather and never her adaptation.
        for ring in HomeWorlds.rings {
            XCTAssertEqual(HomeWorlds.adaptationClock(100, ring: ring), 100, accuracy: 1e-9,
                           "ring \(ring) buys a cheaper second adaptation than its neighbours")
        }
        let slow = RoomPose(sceneTime: 100, room: crownRoom)
        XCTAssertLessThan(slow.worldTime, 100, "ring 7's weather is not running on its own clock")
        XCTAssertEqual(RoomPose(sceneTime: 100, room: solesRoom).settling,
                       slow.settling, accuracy: 1e-9,
                       "two rings adapt at different rates — depth bought by which world she is in")
    }

    /// The room is a pure function of its clock, which is what lets the
    /// reduce-motion path pose once and draw once.
    func testTheRoomIsAPureFunctionOfItsClock() {
        for t in [0.0, 31.0, HomeMemory.firstAdaptation, 300.0, RoomClock.settled] {
            XCTAssertEqual(RoomPose(sceneTime: t, room: heartRoom),
                           RoomPose(sceneTime: t, room: heartRoom),
                           "the same instant produced two different rooms")
        }

        // The morph weights never overshoot, at any instant of a whole stay.
        for step in 0...400 {
            let t = Double(step)
            let pose = RoomPose(sceneTime: t, room: heartRoom)
            XCTAssertGreaterThanOrEqual(pose.firstWeight, -1e-9)
            XCTAssertGreaterThanOrEqual(pose.secondWeight, -1e-9)
            XCTAssertLessThanOrEqual(pose.firstWeight + pose.secondWeight, 1 + 1e-9,
                                     "at t=\(t) the room is past the shape it was built to reach")
        }
    }

    /// Design's three depth layers are really three, named, and populated.
    func testTheThreeDepthLayersAreNamedAndPopulated() {
        let scene = RoomScene(room: heartRoom)
        XCTAssertEqual(scene.building.name, "building")
        XCTAssertEqual(scene.weather.name, "world")
        XCTAssertEqual(scene.herLayer.name, "her mechanism")

        XCTAssertGreaterThanOrEqual(scene.building.childNodes.count, 4,
                                    "the building is missing surfaces")
        XCTAssertGreaterThanOrEqual(scene.weather.childNodes.count, 2,
                                    "the world has no weather and no light")
        XCTAssertEqual(scene.receivingSurface, .face,
                       "a Śakti felt at the heart should be acting on a face")

        // The building's surfaces really morph: base plus two targets, which is
        // the pattern the spike proved.
        var morphed = 0
        for node in scene.building.childNodes where node.morpher != nil {
            morphed += 1
            XCTAssertEqual(node.morpher?.targets.count, 2,
                           "\(node.name ?? "?") does not carry both adaptations")
            XCTAssertEqual(node.morpher?.calculationMode, .normalized,
                           "additive morphing would overshoot every mark by a whole adaptation")
        }
        XCTAssertGreaterThanOrEqual(morphed, 3, "only \(morphed) surfaces adapt")
    }

    // MARK: - Helpers

    /// One action of each verb, built through the only constructors there are.
    private static func action(_ verb: SurfaceVerb, at point: SurfaceCoordinate,
                               reach: Double, depth: Double, glow: Double) -> SurfaceAction {
        switch verb {
        case .impression: return .impression(at: point, reach: reach, depth: depth, glow: glow)
        case .furrow:     return .furrow(at: point, reach: reach, depth: depth, glow: glow)
        case .crack:      return .crack(at: point, reach: reach, depth: depth, glow: glow)
        case .swell:      return .swell(at: point, reach: reach, depth: depth, glow: glow)
        case .compaction: return .compaction(at: point, reach: reach, depth: depth, glow: glow)
        }
    }

    private func matches(_ pattern: String, in text: String) -> [String] {
        guard let re = try? NSRegularExpression(pattern: pattern) else { return [] }
        let ns = text as NSString
        return re.matches(in: text, range: NSRange(location: 0, length: ns.length)).compactMap {
            $0.numberOfRanges > 1 ? ns.substring(with: $0.range(at: 1)) : nil
        }
    }
}
