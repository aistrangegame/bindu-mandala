import XCTest
import SceneKit
@testable import Bindu_Mandala

// MARK: - The descent, judged
//
// Three registers, and they are deliberately separate:
//
//   * the arithmetic (``HomeDescent``) — Design's own numbers, and the travel;
//   * the graph (``DescentShaft``) — that every station is an action on rims of
//     the room's own material and that the descent holds **no solid**, over all
//     102 rooms;
//   * the rules (``TheDescent``) — when the way down is open, and what a touch
//     does, including the one thing this phase turns on: a room answering to
//     what it remembers.
@MainActor
final class HomeDescentTests: XCTestCase {

    // MARK: - Fixtures

    private func room(position: Int) -> HomeRoom {
        let row = HomesCorpus.rows().first { $0.position == position }!
        return HomeRooms.resolve(position: row.position, ring: row.ring,
                                 tattva: row.tattva, quality: row.quality,
                                 bodilyLocation: row.bodilyLocation, bija: row.bija)!
    }

    // MARK: - Design's numbers, kept

    func testDesignsOwnDepthsAndRimsAreKeptLiterally() {
        // `STATION_Z` in `homes-descent.js`.
        XCTAssertEqual(HomeDescent.stationDepths, [-16, -34, -52, -70, -88])
        // 46 rims, `-8 - i * 2.2`, `5.4 * 0.985^i`.
        XCTAssertEqual(HomeDescent.rungs, 46)
        XCTAssertEqual(HomeDescent.rungDepth(0), -8, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.rungDepth(45), -8 - 45 * 2.2, accuracy: 1e-9)
        XCTAssertEqual(HomeDescent.rungRadius(0), 5.4, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.rungRadius(1), 5.4 * 0.985, accuracy: 1e-12)
        // `0.05 + near * 0.34`, over a band of 34.
        XCTAssertEqual(HomeDescent.rungLight(0, eyeDepth: -8), 0.39, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.rungLight(0, eyeDepth: -8 - 34), 0.05, accuracy: 1e-12)
        // A station is not there at all past its own band.
        XCTAssertEqual(HomeDescent.presence(of: .tattva, eyeDepth: -16), 1, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.presence(of: .tattva, eyeDepth: -16 - 22), 0, accuracy: 1e-12)
        // Design's roots: 14-second cycle, radius 3.4, rate 0.12.
        XCTAssertEqual(HomeDescent.rootCycle, 14, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.rootRadius, 3.4, accuracy: 1e-12)
        XCTAssertEqual(HomeDescent.rootRate, 0.12, accuracy: 1e-12)
    }

    /// Design's `STATION_Z` are three.js units in a room whose body is 6.4 tall,
    /// and this one's is too — which is the whole reason they can be kept
    /// literally rather than rescaled. If ``RoomUnits/roomHeight`` ever moves,
    /// this fails rather than the descent silently landing in the wrong place.
    func testTheDescentAndDesignAgreeAboutHowBigABodyIs() {
        XCTAssertEqual(RoomUnits.roomHeight, 6.4, accuracy: 1e-9)
    }

    // MARK: - The travel

    func testTravelRunsFromTheRoomToTheFloorWithoutJumping() {
        XCTAssertEqual(HomeDescent.depth(atTravel: 0), RoomUnits.eyeZ, accuracy: 1e-12)
        for (i, z) in HomeDescent.stationDepths.enumerated() {
            XCTAssertEqual(HomeDescent.depth(atTravel: Double(i + 1)), z, accuracy: 1e-12)
        }
        // Monotone, and continuous: no stretch doubles back and none skips.
        var previous = HomeDescent.depth(atTravel: 0)
        var s = 0.0
        while s <= HomeDescent.floor {
            let here = HomeDescent.depth(atTravel: s)
            XCTAssertLessThanOrEqual(here, previous + 1e-9, "the descent went back up at \(s)")
            XCTAssertLessThan(previous - here, 1.0, "the descent jumped at \(s)")
            previous = here
            s += 0.02
        }
        // Past the floor it stands still rather than running off.
        XCTAssertEqual(HomeDescent.depth(atTravel: 99),
                       HomeDescent.stationDepths.last!, accuracy: 1e-12)
    }

    /// **Going deeper is coming to her level** — and nothing in the arithmetic
    /// knows whether that is down or up.
    func testTheEyeArrivesAtHerOwnAltitudeAndNothingSaysWhichWay() {
        let soles = HomeDescent.height(atTravel: 1, bodyAltitude: 1)
        let crown = HomeDescent.height(atTravel: 1, bodyAltitude: 0)
        XCTAssertEqual(soles, RoomUnits.height(forBodyAltitude: 1), accuracy: 1e-9)
        XCTAssertEqual(crown, RoomUnits.height(forBodyAltitude: 0), accuracy: 1e-9)
        XCTAssertLessThan(soles, RoomUnits.eyeY, "a soles Śakti is gone down into")
        XCTAssertGreaterThan(crown, RoomUnits.eyeY, "a crown Śakti is gone up into")
        // It begins exactly where the walker already stands, so nothing cuts.
        XCTAssertEqual(HomeDescent.height(atTravel: 0, bodyAltitude: 1),
                       RoomUnits.eyeY, accuracy: 1e-12)
    }

    func testTheStationHeIsAtIsTheOneHeHasReached() {
        XCTAssertNil(HomeDescent.station(atTravel: 0))
        XCTAssertNil(HomeDescent.station(atTravel: 0.99))
        XCTAssertEqual(HomeDescent.station(atTravel: 1), .tattva)
        XCTAssertEqual(HomeDescent.station(atTravel: 1.6), .tattva)
        XCTAssertEqual(HomeDescent.station(atTravel: 5), .phrase)
        XCTAssertEqual(HomeDescent.station(atTravel: 9), .phrase)
    }

    /// Design's own defect, named and not inherited: `Math.round(6 + (0.5 - 0.5)
    /// * 6)` is `6` for every Śakti alive, so in the shipped Axis the body's
    /// station never actually finds her.
    func testHerOwnRegisterIsHersAndNotEverybodysSixth() {
        XCTAssertEqual(HomeDescent.herRegister(bodyAltitude: 0), 0)
        XCTAssertEqual(HomeDescent.herRegister(bodyAltitude: 1), HomeDescent.registers - 1)
        XCTAssertEqual(HomeDescent.herRegister(bodyAltitude: 0.5), 6)
        var seen = Set<Int>()
        for room in HomesCorpus.resolvedRooms() {
            seen.insert(HomeDescent.herRegister(bodyAltitude: room.room.bodyAltitude))
        }
        XCTAssertGreaterThan(seen.count, 1,
                             "every Śakti in the instrument landed on one register")
        // …and the shaft runs true through hers, and is thrown off everywhere else.
        let station = HomeDescent.stationDepths[DescentStation.location.rawValue]
        let mine = HomeDescent.herRegister(bodyAltitude: 0.25)
        let hers = station - Double(mine) * HomeDescent.rungSpacing
        XCTAssertEqual(HomeDescent.registerThrow(rungAt: hers, bodyAltitude: 0.25),
                       0, accuracy: 1e-9)
        let other = station - Double((mine + 3) % HomeDescent.registers) * HomeDescent.rungSpacing
        XCTAssertNotEqual(HomeDescent.registerThrow(rungAt: other, bodyAltitude: 0.25), 0)
    }

    func testTheRootsOrbitInwardUntilTheyAreOne() {
        let apart = HomeDescent.rootOffset(0, of: 4, at: 0)
        XCTAssertEqual((apart.x * apart.x + apart.y * apart.y).squareRoot(),
                       HomeDescent.rootRadius, accuracy: 1e-9)
        // At the end of Design's own cycle they have come to the axis.
        let t = HomeDescent.rootCycle - 1e-6
        for k in 0..<4 {
            let o = HomeDescent.rootOffset(k, of: 4, at: t)
            XCTAssertLessThan((o.x * o.x + o.y * o.y).squareRoot(), 1e-5)
        }
        // Design's `max(2, min(4, …))`.
        XCTAssertEqual(HomeDescent.rootCount(0), 2)
        XCTAssertEqual(HomeDescent.rootCount(9), 4)
    }

    // MARK: - Her five fields, as words

    func testHerFieldsArriveInDesignsOrderAndAMissingOneIsSilent() {
        let words = DescentWords.compose(tattva: " Vāyu — air ",
                                         bodilyLocation: "skin",
                                         etymology: "Sparśa + ākarṣiṇī",
                                         quality: "She who attracts Touch",
                                         appreciationPhrase: "Thank you for the world I can touch.",
                                         name: "Sparśākarṣiṇī")
        XCTAssertEqual(words[.tattva], "Vāyu — air")
        XCTAssertEqual(words[.location], "skin")
        XCTAssertEqual(words[.etymology], "Sparśa + ākarṣiṇī")
        XCTAssertEqual(words[.quality], "She who attracts Touch")
        XCTAssertEqual(words[.phrase], "Thank you for the world I can touch.")
        XCTAssertEqual(words.roots, ["Sparśa", "ākarṣiṇī"])

        // A field the base has not filled in is empty, never invented.
        let bare = DescentWords.compose(tattva: nil, bodilyLocation: "   ", etymology: nil,
                                        quality: nil, appreciationPhrase: nil,
                                        name: "Sarva-Yoni")
        XCTAssertEqual(bare[.tattva], "")
        XCTAssertEqual(bare[.location], "")
        XCTAssertEqual(bare[.quality], "")
        XCTAssertEqual(bare[.phrase], "")
        XCTAssertEqual(bare.roots, ["Sarva", "Yoni"], "her name still opens")
    }

    /// The whole corpus: every one of the 102 composes five lines and at least
    /// two roots, whatever her row carries.
    func testAllHundredTwoComposeADescent() {
        for room in HomesCorpus.resolvedRooms() {
            let words = DescentWords.compose(tattva: room.row.tattva,
                                             bodilyLocation: room.row.bodilyLocation,
                                             etymology: nil,
                                             quality: room.row.quality,
                                             appreciationPhrase: nil,
                                             name: "Śakti \(room.row.position)")
            XCTAssertEqual(words.lines.count, DescentStation.allCases.count,
                           "kp \(room.row.position)")
            XCTAssertGreaterThanOrEqual(HomeDescent.rootCount(words.roots.count), 2)
        }
    }

    // MARK: - The shaft, in the graph

    /// The binding condition, in the one part of Design's package that let it
    /// go. Design's descent hangs a torus knot, thirteen boxes, an icosahedron
    /// and three tori in the air; this one hangs nothing at all.
    func testTheDescentHoldsNoSolidInAnyRoom() {
        for room in HomesCorpus.resolvedRooms() {
            let shaft = DescentShaft(room: room.room, roots: 3)
            XCTAssertEqual(shaft.solids, 0,
                           "kp \(room.row.position) put a solid in the descent")
        }
    }

    /// …and opening it does not put one in **her** layer either, which is the
    /// check the whole render spine is built around.
    func testOpeningTheDescentLeavesHerLayerEmpty() {
        for position in [1, 4, 29, 57, 93, 102] {
            let scene = RoomScene(room: room(position: position))
            XCTAssertEqual(scene.solidsInHerLayer, 0)
            scene.openTheDescent(roots: 3)
            XCTAssertEqual(scene.solidsInHerLayer, 0, "kp \(position)")
            XCTAssertGreaterThan(scene.solids(in: .building), 0)
        }
    }

    func testTheShaftIsBuiltOnceAndLetGoAtTheMouth() {
        let scene = RoomScene(room: room(position: 29))
        XCTAssertNil(scene.descent)
        let first = scene.openTheDescent(roots: 2)
        XCTAssertTrue(first === scene.openTheDescent(roots: 4), "a second ask built a second shaft")
        scene.closeTheDescent()
        XCTAssertNil(scene.descent)
    }

    func testTheShaftIsTheRoomsOwnRimRepeatingInward() {
        let room = room(position: 29)
        let shaft = DescentShaft(room: room, roots: 3)
        XCTAssertEqual(shaft.rimCount, HomeDescent.rungs + 3)
        // Narrowing away, and lit by nearness.
        shaft.put(at: HomeDescent.stationDepths[0], worldTime: 0)
        XCTAssertGreaterThan(shaft.width(ofRim: 0), shaft.width(ofRim: 45))
        XCTAssertGreaterThan(shaft.light(ofRim: 4), shaft.light(ofRim: 45))
        // Her rim carries as many lobes as her attribute has moving parts.
        let parts = room.attribute?.state(atChamberTime: 0).parts.count ?? 0
        XCTAssertEqual(DescentShaft.lobes(of: room), max(DescentShaft.fewestLobes, parts))
    }

    func testEachStationActsOnTheRimsAndOnNothingElse() {
        let room = room(position: 57)
        let shaft = DescentShaft(room: room, roots: 4)
        let near = { (s: DescentStation) in HomeDescent.stationDepths[s.rawValue] }
        let rim = { (s: DescentStation) -> Int in
            Int(((HomeDescent.firstRungDepth - near(s)) / HomeDescent.rungSpacing).rounded())
        }

        // · the tattva turns the rims, and only where it is.
        shaft.put(at: near(.tattva), worldTime: 20)
        XCTAssertNotEqual(shaft.turn(ofRim: rim(.tattva)), 0, accuracy: 1e-6)
        shaft.put(at: near(.phrase), worldTime: 20)
        XCTAssertEqual(shaft.turn(ofRim: rim(.tattva)), 0, accuracy: 1e-6)

        // · the body throws the shaft off its axis, and the roots orbit.
        shaft.put(at: near(.location), worldTime: 11)
        let thrown = (0..<HomeDescent.rungs).map { abs(shaft.place(ofRim: $0).y) }.max() ?? 0
        XCTAssertGreaterThan(thrown, 0)
        shaft.put(at: near(.etymology), worldTime: 3)
        let spread = shaft.rootPlaces.map { ($0.x * $0.x + $0.y * $0.y).squareRoot() }
        XCTAssertGreaterThan(spread.max() ?? 0, 0)

        // · the quality swells the rims rather than turning them.
        shaft.put(at: near(.quality), worldTime: 8.2)
        let swollen = shaft.width(ofRim: rim(.quality))
        XCTAssertNotEqual(swollen, HomeDescent.rungRadius(rim(.quality)), accuracy: 1e-6)
        XCTAssertEqual(shaft.turn(ofRim: rim(.quality)), 0, accuracy: 1e-6)

        // · the floor draws the shaft in about its own axis and dims as he
        //   arrives — and it is **still there**. A station that closed to
        //   nothing would leave the last of every descent a black screen with
        //   one line of her on it, which is a sheet of facts arrived at the long
        //   way round and is the exact thing §4.6 refuses.
        let atRest = shaft.width(ofRim: rim(.phrase))
        shaft.put(at: near(.phrase), worldTime: 0)
        XCTAssertLessThan(shaft.width(ofRim: rim(.phrase)), atRest * 0.35)
        XCTAssertGreaterThan(shaft.width(ofRim: rim(.phrase)), 0)
        XCTAssertGreaterThan(shaft.light(ofRim: rim(.phrase)), 0.1,
                             "the floor of the descent went dark")
    }

    /// The still path, for the descent: **time alone never poses it**. The same
    /// proof ``RoomDriver/posesApplied`` gives for the room.
    func testNothingButTheWalkerPutsTheShaftAtADepth() {
        let shaft = DescentShaft(room: room(position: 29), roots: 2)
        let posed = shaft.posesApplied
        XCTAssertGreaterThan(posed, 0, "it is posed once when it is built")
        // Two moves, two poses. Nothing between them.
        shaft.put(at: -16, worldTime: 0)
        shaft.put(at: -34, worldTime: 1)
        XCTAssertEqual(shaft.posesApplied, posed + 2)
    }

    // MARK: - The rules of going deeper

    func testATouchCarriesHimTheNextStretchAndTheFloorBringsHimBack() {
        var descent = TheDescent()
        XCTAssertFalse(descent.isOpen)
        XCTAssertNil(descent.station)
        XCTAssertEqual(descent.onward(), 1)
        XCTAssertEqual(descent.station, .tattva)
        XCTAssertTrue(descent.isOpen)
        for expected in [2.0, 3, 4, 5] { XCTAssertEqual(descent.onward(), expected) }
        XCTAssertEqual(descent.station, .phrase)
        // …and from the floor, back up into the room.
        XCTAssertEqual(descent.onward(), 0)
        XCTAssertFalse(descent.isOpen)
    }

    func testTheWayOutFromInsideTheMarkRisesAndALetGoPutsHimBack() {
        var descent = TheDescent()
        // Standing in the room, the way out is the room's own, not this one.
        XCTAssertFalse(descent.withdraws())
        descent.onward(); descent.onward(); descent.onward()
        XCTAssertTrue(descent.withdraws())
        XCTAssertEqual(descent.travel, 0, "he rises to the mouth as he crosses out")
        XCTAssertTrue(descent.goesOn())
        XCTAssertEqual(descent.travel, 3, "he is put back where he was standing")
        XCTAssertFalse(descent.goesOn(), "a let-go with no beginning moves nothing")
    }

    /// **The sharpest edge of the return memory, and it is felt rather than
    /// read.** The way down opens when her room has adapted — so a walker whose
    /// accumulated dwell has already opened the room past the adaptation can go
    /// deeper the moment he arrives, and a stranger waits out the settling.
    func testTheWayDownIsEarnedByDwellAndNeverAnnounced() {
        XCTAssertFalse(TheDescent.isOffered(atChamberTime: 0))
        XCTAssertFalse(TheDescent.isOffered(atChamberTime: HomeMemory.firstAdaptation - 0.001))
        XCTAssertTrue(TheDescent.isOffered(atChamberTime: HomeMemory.firstAdaptation))

        // A room never stood in opens at the beginning: he waits.
        XCTAssertEqual(HomeMemory.headStart(dwell: 0), 0)
        XCTAssertFalse(TheDescent.isOffered(atChamberTime: HomeMemory.headStart(dwell: 0)))
        // Two minutes of accumulated dwell opens it on arrival.
        XCTAssertTrue(TheDescent.isOffered(atChamberTime: HomeMemory.headStart(dwell: 120)))
        // And the head start is capped short of the second adaptation, so the
        // relationship opens the way down and never buys the room's floor.
        XCTAssertLessThan(HomeMemory.headStart(dwell: HomeMemory.dwellCap),
                          HomeMemory.holdEnd)
    }

    /// Nothing in the descent's own surface counts, and there is nowhere to put
    /// a number: two prompts of four words and five lines that are hers.
    func testTheDescentSaysNothingAboutHowDeepHeIs() {
        var descent = TheDescent()
        let spoken = [TheDescent.mouthPrompt.words, RitePrompt.goOn.words]
        for words in spoken {
            XCTAssertFalse(words.contains(where: \.isNumber), words)
            for banned in ["of", "step", "level", "stage", "deep"] where words.hasSuffix(banned) {
                XCTFail("\(words) counts")
            }
        }
        // One instruction at every station, the floor included: a word for
        // coming back is a word about having been somewhere, and
        // `testTheRiteNeverSaysHeHasBeenHereBefore` refuses the rite one.
        XCTAssertNil(descent.prompt, "the mouth is not a station")
        for _ in 0..<TheDescent.stations {
            descent.onward()
            XCTAssertEqual(descent.prompt, .goOn)
        }
        // Two instructions in the whole descent, and no third.
        XCTAssertEqual(Set(spoken), ["touch to go deeper", "touch to go on"])
    }

    // MARK: - The wire, read off the shipping source

    /// The still path, for the descent: **every place the walker is moved into
    /// her mark asks the still room for a frame.** The same claim
    /// `testEveryPlaceTheWalkerMovesAsksTheStillRoomForAFrame` makes about the
    /// crossing, for the motion this phase added — and it is the defect the
    /// render spine has already paid for once, because ``RoomApproachSource`` is
    /// a reference and moving the walker changes nothing SwiftUI can see.
    func testEveryPlaceHeIsMovedIntoHerMarkAsksForAFrame() throws {
        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(rite.lexed.masked)
        let sets = Rx.all(#"descending\.set\("#, code)
        XCTAssertEqual(sets.count, 1,
                       "the rite moves him into her mark from \(sets.count) places")
        let descend = try XCTUnwrap(
            Rx.first(#"private func descend\(to travel: Double, over motion: RoomApproach\.Motion\) \{[^}]*\}"#,
                     code),
            "the rite no longer has one place that takes him deeper")
        XCTAssertTrue(descend.contains("descending.set(") && descend.contains("moves &+= 1"),
                      "going deeper no longer asks the still room for a frame")
        // …and the shaft really is handed to the room.
        XCTAssertTrue(code.contains("descent: descending"), "the room is not handed the shaft")
    }

    /// The descent's instruction does not stand on the way out's.
    ///
    /// ``TheWayOut`` draws its own prompt 64 points off the floor and the rite
    /// could put one there safely only because the way out is not offered during
    /// the ceremony. This one is offered at the same time, so a shared 64 would
    /// have been two instructions on the same pixels — which no assertion about
    /// either file alone could have seen.
    func testTheTwoInstructionsInARoomDoNotStandOnEachOther() throws {
        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let out = try XCTUnwrap(LawSource.production("TheWayOut.swift"))
        let floor = try XCTUnwrap(Rx.first(#"padding\(\.bottom, (\d+)\)"#,
                                           String(out.lexed.masked)))
        XCTAssertTrue(floor.contains("64"), "the way out moved; the descent's prompt must follow")
        let code = String(rite.lexed.masked)
        let descentPrompt = try XCTUnwrap(
            Rx.first(#"descentPrompt[\s\S]{0,900}?padding\(\.bottom, [^)]*\)"#, code),
            "the descent's prompt no longer says where it stands")
        XCTAssertFalse(descentPrompt.hasSuffix("padding(.bottom, 64)"),
                       "the descent's instruction is drawn on top of the way out's")
    }

    /// A man on his way out is not going deeper — the overlap the two gestures
    /// create, refused at the one place a touch is answered.
    func testAWalkerCrossingOutCannotBeCarriedDeeperByTheSameTouch() throws {
        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let touch = try XCTUnwrap(
            Rx.first(#"private func touch\(\) \{[\s\S]*?\n    \}"#, String(rite.lexed.masked)),
            "the rite no longer has one place that answers a touch")
        XCTAssertTrue(touch.contains("stay.endedAt == nil"),
                      "a touch during a withdrawal can still carry him deeper")
    }

    /// **The descent is drawn, not merely declared.**
    ///
    /// The lesson 3.7 paid for: every other check here reads the descent's
    /// arithmetic, its graph and its rules, and deleting the one line that puts
    /// its surface in the room's body would leave all of them green while the
    /// walker never saw a prompt and never found the way down. So the body is
    /// read, and the shaft is asserted to be handed to the room from inside it.
    func testTheWayDownStandsInTheBodyOfTheRoom() throws {
        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(rite.lexed.masked)
        let body = try XCTUnwrap(Rx.first(#"var body: some View \{[\s\S]*?\n    \}"#, code),
                                 "the rite no longer has a body")
        XCTAssertTrue(body.contains("goingDeeper"),
                      "the descent's surface is written but never drawn")
        XCTAssertTrue(body.contains("descent: descending"),
                      "the room is handed no shaft from the body")
        XCTAssertTrue(body.contains("wayDownIsOpen"),
                      "the way down is drawn whether or not the room has opened")
    }
}
