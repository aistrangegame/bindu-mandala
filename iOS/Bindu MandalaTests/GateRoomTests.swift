import XCTest
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - THE GATE, JUDGED
//
// Build Brief v2 §3.3: Laghimā at khaḍgamālā 3 and Garimā at khaḍgamālā 4 — the
// first two rooms actually lived in, and Design's own paired example. One room
// must lift and the other must press.
//
// Two things are on trial here and they are not the same thing.
//
// **The Gate itself**, which Ruling 10 accepts as hand-authored: does each room
// do what Design wrote, does it reverse its own premise rather than intensify,
// does it avoid the two defects Design hit in *these two rooms specifically*, and
// are the two of them unmistakably different from each other.
//
// **The deep term**, which is the Phase 3.1 review's own scheduled gap: the
// second adaptation was one generic intensification shared by all 102 rooms,
// because nothing a room was handed could say what its premise *becomes*. That is
// now ``HomeBecoming``, and the checks below hold it on the two authored rooms
// *and* on the ninety-four the grammar speaks for, because a term proven on two
// rooms and inherited by nobody would be two rooms rather than a term.
@MainActor
final class GateRoomTests: XCTestCase {

    /// Big enough that a mark is several pixels across, small enough that the
    /// captures are seconds rather than minutes. The same size `RoomCaptureTests`
    /// reads its own legibility spread at.
    private static let captureSize = CGSize(width: 320, height: 640)

    /// The stay's two adaptations, read from ``HomeMemory`` rather than restated.
    private static let firstAdaptation = HomeMemory.firstAdaptation
    private static let pastTheSecond = HomeMemory.secondAdaptationEnd

    // MARK: - The two rooms, from her row and nothing else

    /// Laghimā's row as the base carries it: `Lightness`, `Vāyu — air, movement`,
    /// felt at the solar plexus rising upward.
    private func laghima(name: String = "Laghimā") -> HomeRoom {
        room(position: 3, quality: "Lightness", tattva: "Vāyu — air, movement",
             bodilyLocation: "Solar plexus rising upward", name: name)
    }

    /// Garimā's row: `Weightedness`, `Pṛthvī — earth`, felt at the Mūlādhāra, the
    /// sit-bones and the soles.
    private func garima(name: String = "Garimā") -> HomeRoom {
        room(position: 4, quality: "Weightedness", tattva: "Pṛthvī — earth",
             bodilyLocation: "Mūlādhāra / sit-bones / soles", name: name)
    }

    /// Resolved through ``HomeRooms/resolve(_:live:)`` — off a row, the way the
    /// app does it, so the name really is carried and really is not consulted.
    private func room(position: Int, quality: String, tattva: String,
                      bodilyLocation: String, name: String) -> HomeRoom {
        let row = Shakti(position: position, name: name, shortName: "", phonetic: "",
                         quality: quality, qualityDescription: "", somatic: "",
                         somaticPoetry: "", bija: "", bodilyLocation: bodilyLocation,
                         tattva: tattva, recognitionPhrase: "", cluster: .inner,
                         status: .mapped)
        row.ringNumber = 1
        row.khadgamalaPosition = position
        guard let resolved = HomeRooms.resolve(row) else {
            fatalError("no room resolved at khaḍgamālā \(position)")
        }
        return resolved
    }

    // MARK: - Position is identity, and the Gate proves it

    /// **Both authored rooms are reached by position, and a name cannot reach
    /// them.**
    ///
    /// Design's `homes-chambers.js` keys its eight rooms by Śakti *name*, and four
    /// of those keys are ghost spellings that match no card — its own Axis
    /// silently hands those four the grammar instead. The port is keyed by
    /// ``Shakti/khadgamalaPosition``, so the two halves of the Gate arrive at
    /// their own rooms whatever the row happens to be called.
    ///
    /// Driven with the names deliberately wrong, because a check that passes her
    /// real name in cannot see the difference.
    func testTheGateIsReachedByPositionAndNeverByName() {
        XCTAssertEqual(HomeRooms.authoredMechanism(atPosition: 3), .release)
        XCTAssertEqual(HomeRooms.authoredMechanism(atPosition: 4), .press)

        for name in ["Laghimā", "Laghima", "", "Sarvakāmāvalī", "ANONYMOUS"] {
            let lifts = RoomMechanisms.forRoom(laghima(name: name))
            XCTAssertTrue(lifts is ReleaseRoom,
                          """
                          khaḍgamālā 3 called \"\(name)\" did not reach the room whose floor lets go. \
                          The authored map is keyed by position for exactly this reason: the shipped \
                          data has drifted from the base on 61 of 102 names, and Ring 1 carries no \
                          Garimā at all.
                          """)
        }
        for name in ["Garimā", "Garima", "", "Sarvakāmāvalī"] {
            let presses = RoomMechanisms.forRoom(garima(name: name))
            XCTAssertTrue(presses is PressRoom,
                          "khaḍgamālā 4 called \"\(name)\" did not reach the room that presses")
        }

        // …and neither room's own source consults a name. `HomeRooms` is the only
        // place a room is chosen, and it is handed a number.
        for room in [laghima(), garima()] {
            guard case .authored = room.kind else {
                return XCTFail("khaḍgamālā \(room.position) did not resolve to an authored room")
            }
        }
    }

    // MARK: - The binding condition, in the two rooms that could break it

    /// **Neither room mounts a solid in her layer.**
    ///
    /// The spike's Garimā put the palm's mark on the floor as a cylinder with its
    /// own emissive material — a free-standing lit solid, which is the props
    /// cupboard in one object and the failure the renderer ruling exists to
    /// prevent. Design's three.js does the same. The press here is a compaction in
    /// the ground and there is nothing to pick up.
    func testNeitherGateRoomMountsASolidInHerLayer() {
        for room in [laghima(), garima()] {
            let scene = RoomScene(room: room)
            for t in [0, Self.firstAdaptation, Self.pastTheSecond] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               khaḍgamālā \(room.position) grew a geometry in her own layer at t=\(Int(t)). \
                               Every attribute in every room is an action on the room's own material — \
                               never a free-standing lit solid.
                               """)
            }
            XCTAssertGreaterThan(scene.childCount(in: .her), 0,
                                 "khaḍgamālā \(room.position): her layer is empty — the light in her mark is missing")
        }
    }

    /// Everything either room does to the material goes through the five verbs,
    /// and the enclosure is never marked — a wall carries no morphing material, so
    /// a mark on one would be a promise the render could not keep.
    func testTheGateActsThroughTheFiveVerbsAndNeverOnTheEnclosure() throws {
        for room in [laghima(), garima()] {
            let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room))
            for t in stride(from: 0.0, through: Self.pastTheSecond, by: 29.0) {
                let stage = Self.stage(room: room, at: t)
                let acted = mechanism.actions(at: t, stage: stage)
                XCTAssertNil(acted[.wall],
                             "khaḍgamālā \(room.position) marks the enclosure, which carries no material")
                for (surface, marks) in acted {
                    for mark in marks {
                        XCTAssertTrue(SurfaceVerb.allCases.contains(mark.verb))
                        XCTAssertLessThanOrEqual(mark.at.u, 1)
                        XCTAssertGreaterThanOrEqual(mark.at.u, 0)
                        XCTAssertLessThanOrEqual(mark.at.v, 1)
                        XCTAssertGreaterThanOrEqual(mark.at.v, 0)
                        XCTAssertGreaterThan(mark.depth, 0,
                                             "khaḍgamālā \(room.position) puts a mark of no depth on \(surface.rawValue) — "
                                             + "light without deformation is nothing, so this mark is nothing")
                    }
                }
            }
        }
    }

    // MARK: - GARIMĀ · the premise reverses, and it is not the press undone

    /// **The mass comes down the whole first adaptation, and then the ground it
    /// made lifts him.**
    ///
    /// Design writes the reversal out in her own file: *"the weight was never
    /// above you. It is what you are standing on, and it has been holding you the
    /// whole time."* So the thing asserted is not that the press stops. It is
    /// that the work **moves from the canopy to the ground** — and that the strata
    /// the pressing made are *kept*, deeper at the end than they were at the
    /// first adaptation. A press that simply undid itself would pass a brightness
    /// check and fail this one.
    func testGarimaPressesAndThenTheGroundSheMadeTakesItOver() throws {
        let room = garima()
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room))
        let scene = RoomScene(room: room)

        // 1 · the premise: the mass descends while the eye settles.
        scene.pose(at: 0)
        let opening = scene.stood[.canopy] ?? 0
        scene.pose(at: Self.firstAdaptation)
        let pressed = try XCTUnwrap(scene.stood[.canopy])
        XCTAssertGreaterThan(pressed, opening + 0.1,
                             "the ceiling does not come down — the room has no premise to reverse")

        // 2 · the reversal: the mass lifts away, and the ground answers.
        //
        // The ground answers in **material** rather than by standing somewhere
        // else, and that is a rule of the instrument rather than a detail of this
        // room: he is standing on the floor, so a floor cannot come toward him
        // without lifting him, and nothing in the instrument moves the walker.
        // Step 4 is where the ground's answer is read.
        scene.pose(at: Self.pastTheSecond)
        let lifted = try XCTUnwrap(scene.stood[.canopy])
        XCTAssertLessThan(lifted, pressed - 0.1,
                          """
                          the mass is still coming down past the second adaptation. Design is explicit \
                          that the second adaptation is never more of the same — this room is a loop.
                          """)
        XCTAssertLessThanOrEqual(scene.stood[.ground] ?? 0, 0,
                                 "the floor has come up toward a walker who is standing on it")

        // 3 · and the press is **not undone**: what it made is kept and goes on
        //     being made. The bedding away from her mark is deeper at the end of
        //     the stay than it was at the first adaptation.
        let bedding = SurfaceCoordinate(u: 0.5, v: 0.5 / Double(PressRoom.beds))
        let settled = try XCTUnwrap(scene.shaped(at: Self.firstAdaptation)[.ground])
        let deepened = try XCTUnwrap(scene.shaped(at: Self.pastTheSecond)[.ground])
        let atFirst = abs(settled.relief(at: bedding) - settled.grain(at: bedding))
        let atSecond = abs(deepened.relief(at: bedding) - deepened.grain(at: bedding))
        XCTAssertGreaterThan(atSecond, atFirst,
                             """
                             the strata are shallower past the second adaptation than at the first: \
                             \(atSecond) against \(atFirst). The reversal is not the press undone — \
                             nothing is given back, something was made.
                             """)

        // 4 · the mark itself turns over: a hollow in the floor at the first
        //     adaptation, and a plinth standing proud of the same floor past the
        //     second. Read against the floor *beside* it at the same moment,
        //     because that is the comparison a walker makes and the one that
        //     cannot be satisfied by the whole room moving.
        func standsProud(_ material: RoomMaterial, at t: TimeInterval) -> Double {
            let here = RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                           chamberTime: t).coordinate
            let beside = SurfaceCoordinate(u: 0.95, v: here.v)
            return (material.relief(at: here) - material.grain(at: here))
                - (material.relief(at: beside) - material.grain(at: beside))
        }
        let hollow = standsProud(settled, at: Self.firstAdaptation)
        let plinth = standsProud(deepened, at: Self.pastTheSecond)
        print(String(format: "GATE_PLINTH {\"hollow\":%.4f,\"plinth\":%.4f}", hollow, plinth))
        XCTAssertLessThan(hollow, 0,
                          "her mark is not a hollow at the first adaptation — nothing has pressed anything")
        XCTAssertGreaterThan(plinth, 0,
                             """
                             her mark is still a hollow past the second adaptation (\(plinth) against the \
                             floor beside it). The bedding beneath him is supposed to rise into a plinth \
                             and carry him — it is the only way to *see* that he is standing on what \
                             pressed him, and it is the difference between a reversal and a brightness.
                             """)

        // 5 · and the deep term says all of it, before anything is drawn.
        XCTAssertEqual(mechanism.becoming.premise, .canopy)
        XCTAssertEqual(mechanism.becoming.answer, .ground)
        XCTAssertTrue(mechanism.becoming.isAReversal)
    }

    /// **What her press grows into is depth, not lit floor.**
    ///
    /// Design grows the press — `press.scale.setScalar(1 + b * 1.8)` — on a
    /// cylinder standing seven units away on a floor forty-six wide. Carried over
    /// as a growth of the *emissive* reach, it read very differently: her mark
    /// also rides her mount toward the walker, so past the second adaptation the
    /// lit disc was 2.8 times its resting footprint and lying directly under the
    /// eye. Measured on the render, the near half of the frame went from a mean
    /// luminance of 0.081 to 0.343 while the structure in it did not change, so
    /// what the walker had was a pale wash with every bed she had made lost
    /// inside it — the exact failure the file above it says it avoided, one step
    /// further in. Emission is additive and is not shaded by the surface normal:
    /// a lit *area* erases relief instead of revealing it.
    ///
    /// So the check is on the area, in the room's own material, where it can be
    /// stated exactly rather than inferred from a mean: **the floor her press
    /// lights does not spread as the stay deepens.** What grows is the crater
    /// around it, which is relief and is therefore shaded.
    func testGarimasPressLightsNoMoreOfTheFloorAsItDeepens() throws {
        let room = garima()
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room))

        /// How much of the ground the room's own actions light, on a grid.
        func litArea(at t: TimeInterval) -> Double {
            let placement = RoomUnits.placement(bodyAltitude: room.bodyAltitude, chamberTime: t)
            var ground = RoomMaterial(surface: .ground, seed: room.position)
            let stage = RoomStage(placement: placement,
                                  settling: HomeGrammar.settling(chamberTime: t),
                                  deep: HomeGrammar.deepProgress(chamberTime: t),
                                  materials: [.ground: ground])
            ground.receive(mechanism.actions(at: t, stage: stage)[.ground] ?? [])
            var lit = 0.0, total = 0.0
            for i in 0...120 {
                for j in 0...120 {
                    let point = SurfaceCoordinate(u: Double(i) / 120, v: Double(j) / 120)
                    total += 1
                    if ground.emission(at: point) > 0.02 { lit += 1 }
                }
            }
            return lit / total
        }

        let first = litArea(at: Self.firstAdaptation)
        let deep = litArea(at: Self.pastTheSecond)
        print(String(format: "GATE_PRESS_LIGHT {\"litAtFirst\":%.4f,\"litPastSecond\":%.4f}", first, deep))
        XCTAssertGreaterThan(first, 0, "her press is not lighting anything at all")
        XCTAssertLessThanOrEqual(deep, first * 1.1,
                                 """
                                 her press lights \(deep) of the floor past the second adaptation \
                                 against \(first) at the first. The mark comes toward the eye as it \
                                 deepens, so a lit area that also grows arrives as a wash across the \
                                 near half of the frame — Design's own reading of this room is \
                                 "a real shadow band and the press glowing", which is a press glowing \
                                 in a dark room, not a lit floor.
                                 """)
    }

    /// **Her mark sits low in the frame, because her bodily location is the soles.**
    ///
    /// Design's zone table reads *"Mūlādhāra / sit-bones / soles"* at 0.94, the
    /// lowest altitude it gives. Nothing in her room touches the camera: the floor
    /// stands where the soles' extreme resolves to, so her mark is in it. The
    /// spike's first draft got this inverted — her mark climbed into the upper
    /// half of the frame — which is why it is read off the projection at every
    /// moment of the stay rather than once.
    func testGarimasMarkSitsLowInTheFrame() {
        let room = garima()
        XCTAssertEqual(RoomUnits.surface(forBodyAltitude: room.bodyAltitude), .ground,
                       "Garimā is not acting on the floor — the check below proves nothing")
        XCTAssertEqual(room.bodyAltitude, 0.94, accuracy: 1e-9,
                       "her altitude is no longer the lowest reading Design's zone table gives")

        for t in [0, Self.firstAdaptation, HomeMemory.holdEnd, Self.pastTheSecond] {
            let mark = RoomUnits.markOnScreen(bodyAltitude: room.bodyAltitude,
                                              chamberTime: t, size: Self.captureSize)
            let downTheFrame = mark.y / Self.captureSize.height
            print("GATE_MARK {\"room\":\"press\",\"t\":\(Int(t)),"
                  + String(format: "\"downTheFrame\":%.3f}", downTheFrame))
            XCTAssertGreaterThan(downTheFrame, 0.5,
                                 """
                                 at t=\(Int(t)) a Śakti felt at the soles has her mark in the upper half \
                                 of the frame. That is the inversion the spike caught, and it means a \
                                 camera has been tuned instead of the room being the body.
                                 """)
        }
    }

    // MARK: - LAGHIMĀ · the premise reverses, and the reversal is not absence

    /// **The floor lets go, and then the opening it let go into takes the whole
    /// room.**
    ///
    /// Design's own words on the line that does it: *"as the walls go, the opening
    /// they were hanging from takes the whole room."* The reversal is not the
    /// enclosure removed — that was the defect. It is the opening arriving.
    func testLaghimaLetsGoAndTheOpeningTakesTheRoom() throws {
        let room = laghima()
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room))
        let scene = RoomScene(room: room)

        // 1 · the premise: the ground is already going out from under him.
        scene.pose(at: Self.firstAdaptation)
        let lettingGo = try XCTUnwrap(scene.stood[.ground])
        XCTAssertLessThan(lettingGo, -0.05, "the floor has not let go of anything")

        // 2 · the reversal: it lets go completely, the enclosure departs, and the
        //     opening comes down and takes the room.
        scene.pose(at: Self.pastTheSecond)
        let gone = try XCTUnwrap(scene.stood[.ground])
        let departed = try XCTUnwrap(scene.stood[.wall])
        let opening = try XCTUnwrap(scene.stood[.canopy])
        XCTAssertLessThan(gone, lettingGo - 0.1, "the ground stopped letting go")
        XCTAssertLessThan(departed, -0.1,
                          "the enclosure is still here — nothing in this room falls, including the room")
        XCTAssertGreaterThan(opening, 0.1,
                             """
                             the opening did not come down. This is Design's own second defect in this \
                             exact room: the walls departing left an empty room and it went dark. The \
                             opening has to take over as they go.
                             """)

        // 2b · and it departs **upward**, which is the one sentence this room
        //      exists to say. Design's own line on the walls is `w.position.y =
        //      1.4 + b * (15 + i * 2.4)` on walls thirteen tall: they rise
        //      further than their own height. Read as a widening — which is what
        //      a station applied as a scale of where a wall stands comes out as —
        //      *"nothing in this room falls, including the room"* arrives as the
        //      room getting bigger, and that is Mahimā's authored premise, not
        //      hers. The Gate's whole job is that these two are not each other.
        XCTAssertGreaterThan(scene.enclosureRose, 0.1,
                             """
                             the enclosure did not rise: it travelled \(scene.enclosureRose) upward for \
                             a station of \(departed). Nothing in this room falls, including the room.
                             """)
        XCTAssertLessThanOrEqual(scene.enclosureSpread, 1.0,
                                 """
                                 the enclosure stands at \(scene.enclosureSpread) of where it began — \
                                 the room widened. A room with no far wall that never arrives is \
                                 Mahimā's premise; Laghimā's walls go up.
                                 """)

        // 3 · and the opening is **material**, widening, not a light switched on.
        let atFirst = try XCTUnwrap(scene.shaped(at: Self.firstAdaptation)[.canopy])
        let atSecond = try XCTUnwrap(scene.shaped(at: Self.pastTheSecond)[.canopy])
        let mouthFirst = abs(atFirst.relief(at: .centre) - atFirst.grain(at: .centre))
        let mouthSecond = abs(atSecond.relief(at: .centre) - atSecond.grain(at: .centre))
        XCTAssertGreaterThan(mouthSecond, mouthFirst * 1.5,
                             """
                             the opening does not open: \(mouthSecond) against \(mouthFirst). A reversal \
                             carried by brightness alone is the generic intensification this term exists \
                             to replace.
                             """)

        // …and the light in it is the light of the opening, which is to say it
        // exists exactly as far as the material moved.
        let wide = SurfaceCoordinate(u: 0.5, v: 0.5 + 0.25)
        XCTAssertGreaterThan(atSecond.emission(at: wide), atFirst.emission(at: wide),
                             "the opening is no wider in light than it was — it has not taken the room")

        XCTAssertEqual(mechanism.becoming.premise, .ground)
        XCTAssertEqual(mechanism.becoming.answer, .canopy)
    }

    /// **Neither of Design's two Laghimā defects.**
    ///
    /// Both are in the thread's list of six, and both were in this room alone:
    /// her rising field stacked additively to pure white at arm's length, and she
    /// then went dark at the second adaptation when the walls departed. They are
    /// pinned at the two adaptations they appeared at, on the real render.
    func testLaghimaIsNeitherBlownOutNorDark() throws {
        let scene = RoomScene(room: laghima())
        var readings: [(String, Luminance)] = []

        for (when, t) in [("the first adaptation", Self.firstAdaptation),
                          ("past the second", Self.pastTheSecond)] {
            guard let image = scene.capture(size: Self.captureSize, atSceneTime: t) else {
                return XCTFail("Laghimā could not be rendered offscreen — no Metal device?")
            }
            let spread = Self.luminance(of: image)
            readings.append((when, spread))
            print("GATE_LUMA {\"room\":\"release\",\"when\":\"\(when)\","
                  + String(format: "\"mean\":%.4f,\"min\":%.4f,\"max\":%.4f,\"saturated\":%.4f}",
                           spread.mean, spread.low, spread.high, spread.saturated))
        }

        let first = readings[0].1, second = readings[1].1

        // Defect 1 — pure white at arm's length.
        XCTAssertLessThan(first.mean, 0.7,
                          "the first adaptation blew out to white — Design's own first Laghimā defect")
        XCTAssertLessThan(first.saturated, 0.25,
                          """
                          \(Int(first.saturated * 100))% of the frame is at white at the first adaptation. \
                          Design's rising field stacked additively until the room was flat and \
                          unreadable; nothing here may accumulate that way.
                          """)

        // Defect 2 — dark when the walls depart.
        XCTAssertGreaterThan(second.mean, 0.02,
                             "she went dark past the second adaptation — Design's own second Laghimā defect")
        XCTAssertGreaterThan(second.mean, first.mean * 0.75,
                             """
                             she is markedly darker past the second adaptation (\(second.mean)) than at \
                             the first (\(first.mean)). That is the defect exactly: the walls departing \
                             leave an empty room unless the opening they hung from takes it over.
                             """)
        XCTAssertLessThan(second.saturated, 0.25,
                          "the opening taking the room over blew the room out instead")

        // …and the room is a room at both, rather than a flat field.
        for (when, spread) in readings {
            XCTAssertGreaterThan(spread.high - spread.low, 0.02,
                                 "\(when): the render is flat — nothing for a raking light to fall across")
        }
    }

    /// Both halves of the Gate are legible at both adaptations — Design's first
    /// legibility register, on the two rooms it is being applied to first.
    func testBothGateRoomsAreLegibleAtBothAdaptations() throws {
        for (what, room) in [("release · khaḍgamālā 3", laghima()),
                             ("press · khaḍgamālā 4", garima())] {
            let scene = RoomScene(room: room)
            for (when, t) in [("the first adaptation", Self.firstAdaptation),
                              ("past the second", Self.pastTheSecond)] {
                guard let image = scene.capture(size: Self.captureSize, atSceneTime: t) else {
                    return XCTFail("\(what) could not be rendered offscreen")
                }
                let spread = Self.luminance(of: image)
                print("GATE_LEGIBILITY {\"room\":\"\(what)\",\"when\":\"\(when)\","
                      + String(format: "\"mean\":%.4f,\"min\":%.4f,\"max\":%.4f}",
                               spread.mean, spread.low, spread.high))
                XCTAssertGreaterThan(spread.mean, 0.01, "\(what), \(when): rendered black")
                XCTAssertLessThan(spread.mean, 0.9, "\(what), \(when): blew out to white")
                XCTAssertGreaterThan(spread.high - spread.low, 0.02, "\(what), \(when): flat")
            }
        }
    }

    // MARK: - The pair Design chose as the hardest case

    /// **The two rooms diverge far above Design's tenth, on geometry.**
    ///
    /// Design's own sample-before-batch gate was these two: *"Laghimā and Garimā,
    /// same world, differ by 100% of their geometry and 116 of luminance."* They
    /// share a ring, a world, a gem table and a light rig, so anything that
    /// separates them has to be what the room *does*.
    ///
    /// This is the geometric half of the fingerprint, which waited on rooms
    /// existing: where each of the room's four surfaces stands, and what the
    /// material of the two that carry marks is doing, at seven moments of one
    /// stay, quantised to two decimals exactly as `homes-verify.js` quantises.
    func testTheTwoHalvesOfTheGateDivergeOnGeometry() {
        let lift = GateFingerprint.of(RoomScene(room: laghima()))
        let press = GateFingerprint.of(RoomScene(room: garima()))
        XCTAssertEqual(lift.count, press.count)

        let divergence = GateFingerprint.divergence(lift, press)
        print(String(format: "GATE_DIVERGENCE {\"pair\":\"3|4\",\"divergence\":%.4f,\"components\":%d}",
                     divergence, lift.count))
        XCTAssertGreaterThan(divergence, 0.5,
                             """
                             the two halves of the Gate differ in only \(Int(divergence * 100))% of their \
                             geometry. Design chose this pair as the hardest case and measured them at \
                             100%; the threshold the harness holds every sister pair to is a tenth, and \
                             the Gate has to clear it by a distance or the authored rooms are palette.
                             """)

        // …and it is not one moment carrying it: they differ at the opening, at
        // the first adaptation and past the second.
        for (when, t) in [("the opening", 0.0),
                          ("the first adaptation", Self.firstAdaptation),
                          ("past the second", Self.pastTheSecond)] {
            let a = GateFingerprint.at(RoomScene(room: laghima()), t)
            let b = GateFingerprint.at(RoomScene(room: garima()), t)
            XCTAssertGreaterThan(GateFingerprint.divergence(a, b), 0.3,
                                 "\(when): the two rooms are doing nearly the same thing")
        }
    }

    // MARK: - The deep term, on the other hundred

    /// **No two archetypes reverse alike.**
    ///
    /// The whole point of the term: before it, the second adaptation was one
    /// generic intensification and a Vāk Devī's room turned exactly as a Nigarbha
    /// Yoginī's did. Ten archetypes, ten different turns, each read out of
    /// Design's own builder.
    func testNoTwoArchetypesReverseAlike() {
        var seen: [HomeBecoming: HomeArchetype] = [:]
        for archetype in HomeArchetype.allCases {
            let becoming = HomeBecoming.archetype(archetype)
            XCTAssertTrue(becoming.isAReversal,
                          "\(archetype) does not reverse — its room is a loop")
            XCTAssertNotEqual(becoming.premise, becoming.answer,
                              "\(archetype) answers its premise with itself, which is an intensification")
            if let already = seen[becoming] {
                XCTFail("\(archetype) turns exactly as \(already) does — two rings share one reversal")
            }
            seen[becoming] = archetype
        }
        XCTAssertEqual(seen.count, HomeArchetype.allCases.count)

        // Both ways round are used. A term where every answer arrived at the
        // walker would be one gesture with ten labels: Ring 5's gift becomes the
        // ground he stands on, and Ring 4's gesture leaves past him.
        let toward = HomeArchetype.allCases.filter { HomeBecoming.archetype($0).takes > 0 }
        XCTAssertFalse(toward.isEmpty)
        XCTAssertNotEqual(toward.count, HomeArchetype.allCases.count,
                          "every archetype's answer comes toward the walker — the sign is doing nothing")
    }

    /// **Every room that has a premise reverses it, and the work really moves.**
    ///
    /// The term has to be inherited or it is two authored rooms wearing a new
    /// name. Driven over the whole corpus: each room's premise and answer are
    /// resolved against the surfaces *that* room actually has, and the two are
    /// never the same stone.
    ///
    /// **All one hundred and two, and the one exception this check used to carry
    /// is now filled.** The ninth āvaraṇa holds one Śakti, Mahātripurasundarī at
    /// khaḍgamālā 102, and the grammar declines to speak for her —
    /// ``HomeRooms/grammarRings`` stops at eight, because the Bindu's room is
    /// authored (`chamberDissolve`, *"the room stops being a room"*). She had no
    /// archetype to inherit a turn from and none was invented for her; Phase 3.6
    /// built her room instead (``DissolveRoom``), and its reversal is Design's own
    /// — the enclosure gives way and the source arrives where he is standing. So
    /// `silent` is now empty, and it stays asserted: a room that turns up in it is
    /// a room that holds still past the second adaptation, which is a loop.
    func testEveryRoomReversesAndTheWorkAlwaysMoves() throws {
        var reversing = 0
        var silent: [Int] = []
        for (_, room) in HomesCorpus.resolvedRooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                silent.append(room.position)
                continue
            }
            let becoming = mechanism.becoming
            let parts = RoomReversal.resolved(becoming, bodyAltitude: room.bodyAltitude)
            XCTAssertNotEqual(parts.premise, parts.answer,
                              """
                              khaḍgamālā \(room.position): the premise and the answer land on the same \
                              stone once they are resolved against her own room, which is an \
                              intensification rather than a reversal.
                              """)

            // The room genuinely stands somewhere else past the second adaptation
            // than at the first, and it is not a brightness that moved.
            let atFirst = RoomReversal.stations(becoming, deep: 0,
                                                bodyAltitude: room.bodyAltitude)
            let atSecond = RoomReversal.stations(becoming, deep: 1,
                                                 bodyAltitude: room.bodyAltitude)
            XCTAssertTrue(atFirst.isEmpty,
                          "khaḍgamālā \(room.position) has already reversed before the second adaptation")
            let moved = atSecond.values.map(abs).max() ?? 0
            XCTAssertGreaterThan(moved, 0.05,
                                 "khaḍgamālā \(room.position)'s reversal moves nothing in the room")
            reversing += 1
        }
        XCTAssertEqual(reversing, 102, "only \(reversing) rooms carry a reversal")
        XCTAssertEqual(silent, [],
                       """
                       the rooms with no reversal are \(silent), and since Phase 3.6 built the Bindu \
                       there should be none. A room that turns up here is a room that holds still past \
                       the second adaptation, which is a loop rather than a room.
                       """)
    }

    /// **The room comes toward him and never reaches him.**
    ///
    /// The saturating fraction is what makes that arithmetic rather than a clamp
    /// somebody has to remember, and it is the one property of the reversal that
    /// could hurt a walker if it were ever tuned away.
    func testNoReversalEverReachesTheWalker() {
        for archetype in HomeArchetype.allCases {
            let becoming = HomeBecoming.archetype(archetype)
            XCTAssertLessThan(RoomReversal.answeringFraction(takes: becoming.takes), 1,
                              "\(archetype)'s answer arrives at the walker")
        }
        // …including for a growth far past anything Design authors.
        XCTAssertLessThan(RoomReversal.answeringFraction(takes: 1_000), 1)
        XCTAssertEqual(RoomReversal.answeringFraction(takes: 0), 0)

        // And in the two authored rooms, read off the room rather than the rule.
        for room in [laghima(), garima()] {
            let scene = RoomScene(room: room)
            scene.pose(at: Self.pastTheSecond)
            let ground = RoomUnits.floorY + (scene.stood[.ground] ?? 0)
            let canopy = RoomUnits.canopyY - (scene.stood[.canopy] ?? 0)
            XCTAssertLessThan(ground, RoomUnits.eyeY,
                              "khaḍgamālā \(room.position): the floor has risen past the walker's eye")
            XCTAssertGreaterThan(canopy, RoomUnits.eyeY,
                                 "khaḍgamālā \(room.position): the ceiling has come down through the walker")
        }
    }

    // MARK: - Helpers

    private static func stage(room: HomeRoom, at t: TimeInterval) -> RoomStage {
        var materials: [RoomSurfaceKind: RoomMaterial] = [:]
        for kind in RoomSurfaceKind.allCases {
            materials[kind] = RoomMaterial(surface: kind, seed: room.position)
        }
        return RoomStage(placement: RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                                        chamberTime: t),
                         settling: HomeGrammar.settling(chamberTime: t),
                         deep: HomeGrammar.deepProgress(chamberTime: t),
                         materials: materials)
    }

    struct Luminance {
        let low: Double
        let high: Double
        let mean: Double
        /// What fraction of the frame is at or near white. Design's own first
        /// Laghimā defect is a mean that looks fine over a frame that is mostly
        /// blown, so it is counted rather than averaged away.
        let saturated: Double
    }

    private static func luminance(of image: CGImage) -> Luminance {
        let side = 64
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(data: &pixels, width: side, height: side,
                                      bitsPerComponent: 8, bytesPerRow: side * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return Luminance(low: 0, high: 0, mean: 0, saturated: 0) }
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))

        var low = 1.0, high = 0.0, total = 0.0, blown = 0
        for index in stride(from: 0, to: pixels.count, by: 4) {
            let luma = (0.2126 * Double(pixels[index])
                        + 0.7152 * Double(pixels[index + 1])
                        + 0.0722 * Double(pixels[index + 2])) / 255
            low = Swift.min(low, luma)
            high = Swift.max(high, luma)
            total += luma
            if luma > 0.94 { blown += 1 }
        }
        let count = Double(side * side)
        return Luminance(low: low, high: high, mean: total / count,
                         saturated: Double(blown) / count)
    }
}

// MARK: - The geometric fingerprint
//
// Design's `fingerprint(chamber, t)` walks a built room's graph and writes each
// object's position, scale and opacity to two decimals; `divergence(a, b)` is the
// fraction of those components that differ. `HomesHarnessTests` ports the method
// one level down, at the layer beneath the geometry, because the geometry waited
// on the renderer.
//
// It does not wait any more. This is the same method at the level Design applied
// it: where the room's own surfaces stand, and what their material is doing.
private enum GateFingerprint {

    /// Seven moments of one stay: the opening, the eye settling, the first
    /// adaptation, the hold, the turn, and two points past it.
    static let sampleTimes: [TimeInterval] = [0, 24, HomeMemory.firstAdaptation, 140,
                                              HomeMemory.holdEnd, 287,
                                              HomeMemory.secondAdaptationEnd]

    /// Where on a surface the material is read. Five points along the axis the
    /// walker is looking down, which is the axis every one of Design's rooms
    /// moves along.
    static let probes: [SurfaceCoordinate] = (0..<5).map {
        SurfaceCoordinate(u: 0.5, v: (Double($0) + 0.5) / 5)
    }

    private static func f(_ x: Double) -> String { String(format: "%.2f", x) }

    static func at(_ scene: RoomScene, _ t: TimeInterval) -> [String] {
        var out: [String] = []
        scene.pose(at: t)
        for surface in RoomSurfaceKind.allCases {
            out.append("s|" + surface.rawValue + "|" + f(scene.stood[surface] ?? 0))
        }
        let shaped = scene.shaped(at: t)
        for surface in [RoomSurfaceKind.ground, .canopy] {
            guard let material = shaped[surface] else {
                out.append("m|" + surface.rawValue + "|-")
                continue
            }
            for probe in probes {
                out.append("m|" + surface.rawValue + "|"
                           + f(material.relief(at: probe) - material.grain(at: probe))
                           + "|" + f(material.emission(at: probe)))
            }
        }
        return out
    }

    static func of(_ scene: RoomScene) -> [String] {
        sampleTimes.flatMap { at(scene, $0) }
    }

    /// `homes-verify.js`'s `divergence`, ported exactly.
    static func divergence(_ a: [String], _ b: [String]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var differing = 0
        for i in 0..<n where a[i] != b[i] { differing += 1 }
        return Double(differing) / Double(n)
    }
}
