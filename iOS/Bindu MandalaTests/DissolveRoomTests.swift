import XCTest
@testable import Bindu_Mandala

// MARK: - RING 9 · khaḍgamālā 102 · the Bindu
//
// One seat, and the last of Design's eight authored mechanisms. There is no
// sister to diverge from, so the question *could this room belong to any other
// Śakti?* is asked the other way round: **no other Śakti may reach it**, and
// what it does may not be anything a grammar room already does.
//
// What is held here:
//
//   1. kp 102 reaches the authored dissolve **by position**, and nobody else
//      reaches it; the grammar is still declining to speak for ring 9
//   2. the figure is ninety-nine and the source, which is Design's own phrase for
//      the instrument
//   3. what **moves**: the yantra turns, the two rotations run against each
//      other, the figure opens out, and the source comes out of the stone. A
//      check that measured a static offset could not see any of it cancelled
//   4. the premise reverses as something the room does — the enclosure gives
//      way, the courts open past the picture and their light goes with them,
//      and the source arrives where he is standing, wider and quieter
//   5. every mark clears the mesh cell and the stone's own grain
//   6. the centre of her room is the brightest place in it, at both adaptations
//   7. nothing in her layer is a solid
//   8. she is legible at both adaptations, by offscreen capture, wherever on the
//      body she is felt
//   9. the reduce-motion path reaches the settled state with the premise still
//      reversed
//
// **The row is synthetic.** Only Ring 2's sixteen ship in the binary; kp 102
// lives in Airtable, and a bundled copy would be the ghost roster law 1 exists
// to prevent. So her row comes from ``HomesCorpus``. It costs this suite less
// than most: the room is authored and reads **nothing** off her row but her
// bodily location, so every check below except the altitude sweep would read the
// same against the real card.
@MainActor
final class DissolveRoomTests: XCTestCase {

    private static let bindu = 102

    private func room() throws -> HomeRoom {
        try XCTUnwrap(HomesCorpus.resolvedRooms().first { $0.row.position == Self.bindu }?.room,
                      "khaḍgamālā 102 did not resolve to a room at all")
    }

    private func mechanism() throws -> DissolveRoom {
        try XCTUnwrap(RoomMechanisms.forRoom(room()) as? DissolveRoom,
                      "khaḍgamālā 102 is not the authored dissolve")
    }

    /// Her room at one altitude, so the figure can be read on all three surfaces.
    private func room(bodyAltitude location: String) -> HomeRoom? {
        HomeRooms.resolve(position: Self.bindu,
                          ring: 9,
                          tattva: "Bindu-tattva",
                          quality: "She who is the source",
                          bodilyLocation: location)
    }

    /// The figure her room is laid out on, at one instant.
    private func read(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: DissolveRoom.ring,
                                  spread: DissolveRoom.spread,
                                  part: DissolveRoom.sourceRadius,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    /// The marks the **room** makes, past whatever the spine put in front of
    /// them. This room writes its own answer (``DissolveRoom/becoming``), so the
    /// count is exactly the figure plus the source and this asserts it.
    private func marks(_ room: HomeRoom, at t: TimeInterval) -> [SurfaceAction] {
        OuterRingStage.marks(room: room, at: t)
    }

    // MARK: - 1 · she is reached by position, and by nobody else

    /// **The whole of ring nine is one line in ``RoomMechanisms/authored(_:)``.**
    ///
    /// Design's `BY_NAME` keys four of its eight authored rooms with spellings
    /// that match no card, and in its own shipped Axis those four fall silently
    /// through to the grammar with nothing able to see it happen. The Bindu is
    /// the one seat that could not fall through to anything: ``HomeRooms``'
    /// second branch stops at ring 8, so a miss here is not a different room, it
    /// is the bare seat. Asked from both ends.
    func testTheBinduIsReachedByPositionAndNobodyElseReachesHer() throws {
        let hers = try room()
        XCTAssertEqual(hers.ring, 9)
        XCTAssertEqual(hers.kind, .authored(.dissolve),
                       "kp 102 did not land on the authored dissolve")
        XCTAssertTrue(hers.isBuilt, "the Bindu fell through to the shared seat")
        XCTAssertNil(hers.label,
                     "an authored room writes no grammar words; the grammar declines for ring 9")

        let strangers = HomesCorpus.resolvedRooms()
            .filter { $0.row.position != Self.bindu }
            .filter { RoomMechanisms.forRoom($0.room) is DissolveRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached the Bindu's own room")

        // The grammar is still silent about her, which is what makes this room
        // entirely authored rather than an archetype with a hand-built front.
        XCTAssertFalse(HomeRooms.grammarRings.contains(9))
        XCTAssertNil(HomeGrammar.read(position: Self.bindu, ring: 9,
                                      tattva: "Bindu-tattva", quality: "the source",
                                      bodilyLocation: "whole body"),
                     "the grammar spoke for ring 9")
    }

    // MARK: - 2 · ninety-nine, and the source

    /// Design's own phrase for the instrument is *one building, ninety-nine
    /// reflections and the source*, and the figure comes out at exactly that:
    /// three squares of eight, two circles of twelve, sixteen petals, eight
    /// petals, and nine triangles of three corners.
    ///
    /// It is held here so a later hand cannot quietly make it ninety-eight — and
    /// because the count is what tells the courts apart. A circle drawn with
    /// **eight** points stands at the same eight angles a square's eight do, and
    /// the two courts would come back as one court drawn twice.
    func testTheFigureIsNinetyNineAndTheSource() throws {
        XCTAssertEqual(DissolveRoom.yantra.count, 99,
                       "the yantra is \(DissolveRoom.yantra.count) marks, not ninety-nine")

        let squares = DissolveRoom.squares.count * DissolveRoom.squareSamples
        let circles = DissolveRoom.circles.count * DissolveRoom.circleSamples
        let petals = DissolveRoom.petalRings.reduce(0) { $0 + $1.count }
        let triangles = (DissolveRoom.upward.count + DissolveRoom.downward.count) * 3
        XCTAssertEqual(squares + circles + petals + triangles, 99)
        XCTAssertNotEqual(DissolveRoom.circleSamples, DissolveRoom.squareSamples,
                          "a circle drawn on a square's own angles is a square")

        // Nine depths, which is the thread's own description of the figure and is
        // also the number of āvaraṇas the building has.
        let depths = Set(DissolveRoom.yantra.map { String(format: "%.4f", $0.depth) })
        XCTAssertGreaterThanOrEqual(depths.count, 9,
                                    "the yantra stands at \(depths.count) depths")
        XCTAssertTrue(DissolveRoom.yantra.allSatisfy { $0.depth <= 0 },
                      "a court stands in front of the surface rather than cut into it")

        // …and the room makes exactly one more mark than the figure has: the
        // source. The generic answering mark is deliberately not called — a
        // second lit disc on top of the source is the wash `MatrkaRoom` found.
        let hers = try room()
        for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
            XCTAssertEqual(marks(hers, at: t).count, 100,
                           "her room made \(marks(hers, at: t).count) marks at \(t)s, not 99 and the source")
        }
        XCTAssertEqual(marks(hers, at: HomeMemory.secondAdaptationEnd).last?.verb, .swell,
                       "the source is not a swell. A compaction at the centre is an absence")
    }

    // MARK: - 3 · what moves

    /// **A check that measures a static offset cannot see a cancelled motion**,
    /// so this asserts what travels — all four of the room's movements, each one
    /// separately.
    func testTheYantraTurnsOpensAndTheSourceComesOut() throws {
        let hers = try room()
        guard let early = read(hers, at: 0) else { return XCTFail("the room did not lay out") }

        // 1 · it turns. Every court stands somewhere else one of her own turns
        // later, while the eye is still settling and nothing has opened yet.
        let turned = (0..<DissolveRoom.yantra.count).filter { index in
            DissolveRoom.place(index, at: 0, figure: early.figure,
                               centre: early.stage.placement.coordinate, material: early.material)
                != DissolveRoom.place(index, at: OuterRings.readOver, figure: early.figure,
                                      centre: early.stage.placement.coordinate,
                                      material: early.material)
        }
        XCTAssertGreaterThan(turned.count, 80,
                             "only \(turned.count) of the ninety-nine moved across a quarter of the first adaptation")

        // 2 · the two rotations run **against** each other. Design's `+0.0075`
        // on the yantra and `-0.014` on the nine triangles: read as one turn
        // they would be a rigid figure, which is a different room.
        XCTAssertLessThan(DissolveRoom.yantraTurn * -DissolveRoom.triangleTurn, 0,
                          "the triangles turn with the courts rather than against them")
        let court = try XCTUnwrap(DissolveRoom.yantra.first { !$0.counter })
        let triangle = try XCTUnwrap(DissolveRoom.yantra.first { $0.counter })
        func bearing(_ part: DissolveRoom.Inscribed, at t: TimeInterval) -> Double {
            let turn = t * (part.counter ? -DissolveRoom.triangleTurn : DissolveRoom.yantraTurn)
            return atan2(part.x * sin(turn) + part.y * cos(turn),
                         part.x * cos(turn) - part.y * sin(turn))
        }
        let apart = abs((bearing(triangle, at: 600) - bearing(triangle, at: 0))
                        - (bearing(court, at: 600) - bearing(court, at: 0)))
        XCTAssertGreaterThan(apart, 0.01,
                             """
                             the courts and the triangles came round to the same place over ten \
                             minutes: the counter-turn is cancelled and the figure is rigid.
                             """)

        // 3 · it opens out. Design's `(1 + b * 2.1)` on the whole figure.
        let atDoor = DissolveRoom.opening(at: 0, deep: 0)
        let atTurn = DissolveRoom.opening(at: HomeMemory.secondAdaptationEnd,
                                          deep: HomeGrammar.deepProgress(chamberTime: HomeMemory.secondAdaptationEnd))
        XCTAssertGreaterThan(atTurn, atDoor * 2,
                             "the yantra does not open out: \(atDoor) → \(atTurn)")

        // 4 · the source comes out of the stone, and it is monotone. Design's
        // `bindu.position.z = -8.4 + b * 8.4`.
        let travel = [0, 60, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      280, HomeMemory.secondAdaptationEnd].map { DissolveRoom.source(at: $0) }
        XCTAssertEqual(travel.first ?? 0, DissolveRoom.sourceDepth, accuracy: 1e-9,
                       "the source does not begin at the far end of the figure")
        XCTAssertEqual(travel.last ?? -1, 0, accuracy: 1e-9,
                       "the source does not arrive where he is standing")
        for (a, b) in zip(travel, travel.dropFirst()) {
            XCTAssertGreaterThanOrEqual(b, a - 1e-12, "the source went back into the stone")
        }
    }

    // MARK: - 4 · the premise reverses, as something the room does

    /// *The bindu is where you are standing.* Four things happen, and not one of
    /// them is a word in a label: the enclosure gives way, the courts open past
    /// the picture and their light goes with them, the source opens to nearly
    /// four times itself, and its own light falls away.
    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        let hers = try room()
        let settling = HomeMemory.firstAdaptation
        let past = HomeMemory.secondAdaptationEnd

        // The enclosure stands where it began while the eye settles, and has
        // given way by the end. Design's own travel: 7.4 of a figure 8.4 deep.
        let wallSettling = OuterRingStage.stations(room: hers, at: settling)[.wall] ?? 0
        let wallPast = OuterRingStage.stations(room: hers, at: past)[.wall] ?? 0
        XCTAssertEqual(wallSettling, 0, accuracy: 1e-9,
                       "the enclosure moved before the premise turned")
        XCTAssertLessThan(wallPast, 0, "the enclosure never gives way. *The enclosure is gone*")

        // The ground never comes toward him — he is standing on it — so the
        // answer arrives as material rather than as a surface advancing. That
        // law is this room's own sentence and not a loss.
        let ground = OuterRingStage.stations(room: hers, at: past)[.ground] ?? 0
        XCTAssertLessThanOrEqual(ground, 0,
                                 "the floor came toward the walker. Nothing in the instrument moves him")

        let early = marks(hers, at: settling)
        let late = marks(hers, at: past)

        // The courts open out, and their light goes past the picture with them.
        let earlyCourts = early.dropLast(), lateCourts = late.dropLast()
        XCTAssertGreaterThan(lateCourts.map(\.reach).max() ?? 0,
                             (earlyCourts.map(\.reach).max() ?? 0) * 1.5,
                             "the courts do not open out past the second adaptation")
        // …and they leave **from the outside in**, which is what turning inside
        // out looks like on a surface. Design builds the bhūpura first and the
        // nine triangles last, so the first mark of the figure is its outermost
        // court and the last is the one standing closest to the source: the
        // outer one has opened past the picture and its light has gone with it,
        // and the inner one is still there at the end, opened with the rest.
        //
        // The room was measured the wrong way round once: `max(glow)` over the
        // whole figure could not fall, because the innermost court never leaves
        // the picture and is the brightest of the ninety-nine at every instant.
        let outermost = 0, innermost = DissolveRoom.yantra.count - 1
        XCTAssertLessThan(late[outermost].glow, early[outermost].glow * 0.8,
                          "the bhūpura kept its light after opening past the picture")
        XCTAssertEqual(late[innermost].glow, early[innermost].glow, accuracy: 1e-9,
                       "the innermost court left the picture too. The figure turns inside out")
        // …and it opened with the rest. Read as **where it stands** rather than as
        // how wide its mark is: the innermost court's mark is already at one cell
        // of the mesh at the door — ``RoomInscription/narrowestMark``, the floor
        // under everything — so its *reach* cannot grow, and a check that asked
        // for it would be asking the floor to move. What opens is the court.
        let centre = OuterRingStage.stage(room: hers, at: past).placement.coordinate
        func radius(_ mark: SurfaceAction) -> Double {
            let du = mark.at.u - centre.u, dv = mark.at.v - centre.v
            return (du * du + dv * dv).squareRoot()
        }
        XCTAssertGreaterThan(radius(late[innermost]), radius(early[innermost]) * 1.5,
                             "the innermost court did not open with the rest of the figure")

        // …and none of them was faded by being made shallower, which is the one
        // way the instrument refuses to let a mark leave.
        XCTAssertGreaterThanOrEqual(lateCourts.map(\.depth).min() ?? 0,
                                    (earlyCourts.map(\.depth).min() ?? 0) - 1e-9,
                                    "a court was withdrawn by its depth. The stone keeps what was cut into it")

        // The source opens, and dims. A light you are inside is not a light you
        // see: Design's `(1 + b * 2.8)` against its `(1 - b * 0.55)`.
        let earlySource = try XCTUnwrap(early.last)
        let lateSource = try XCTUnwrap(late.last)
        XCTAssertGreaterThan(lateSource.reach, earlySource.reach * 1.5,
                             "the source does not open out: \(earlySource.reach) → \(lateSource.reach)")
        XCTAssertLessThan(lateSource.glow, earlySource.glow * 0.7,
                          "the source's own light does not fall as it arrives")
        XCTAssertGreaterThan(lateSource.glow, 0,
                             "the source went out altogether. It becomes the room, it does not leave")
    }

    // MARK: - 5 · a mark that can be seen

    /// **Both floors, at every altitude.** A mark narrower than one cell of the
    /// surface's mesh has no vertex inside it and is absent rather than faint; a
    /// mark shallower than the stone's own grain sits under the banding it was
    /// cut into and is never found by the raking key. Ring 1 and Ring 2 each paid
    /// for one of these with a render, and a floor is four body-heights across
    /// against a working face's one — so the sweep is over all three surfaces.
    func testEveryMarkClearsTheMeshCellAndTheStonesGrain() throws {
        for location in ["crown", "heart", "soles"] {
            guard let hers = room(bodyAltitude: location) else {
                return XCTFail("the Bindu did not resolve at \(location)")
            }
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: hers.bodyAltitude),
                                        seed: hers.position)
            for t in [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                for (index, mark) in marks(hers, at: t).enumerated() where mark.reach > 0 {
                    XCTAssertGreaterThanOrEqual(mark.reach, RoomInscription.narrowestMark - 1e-12,
                                                """
                                                \(location), mark \(index) at \(t)s reaches \
                                                \(mark.reach) against a mesh cell of \
                                                \(RoomInscription.narrowestMark). It is sampled away.
                                                """)
                    XCTAssertLessThanOrEqual(mark.reach, OuterRings.widestMark + 1e-12,
                                             "\(location), mark \(index) at \(t)s is wider than the material holds")
                    XCTAssertGreaterThanOrEqual(mark.depth, material.grainRelief - 1e-9,
                                                """
                                                \(location), mark \(index) at \(t)s is \(mark.depth) \
                                                deep against a grain of \(material.grainRelief). \
                                                It cannot be seen.
                                                """)
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             "\(location), mark \(index) at \(t)s is deeper than one mark's worth")
                }
            }
        }
    }

    // MARK: - 6 · the centre is the source

    /// The one claim this room cannot be allowed to lose: **the brightest place
    /// in her room is the point at the middle of the figure**, at both
    /// adaptations, and it is brighter than anything the ninety-nine do.
    ///
    /// Read as emission off the material rather than off the numbers, so a court
    /// whose stroke happened to run across the middle would show up here — which
    /// is exactly how ``BodilessRoom`` found its own centre being lit, at 0.55 of
    /// full emission, in the one place that room needs dark. This room needs the
    /// opposite, and the same instrument answers it.
    func testTheCentreOfHerRoomIsTheBrightestPlaceInIt() throws {
        let hers = try room()
        for t in [HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
            guard let at = read(hers, at: t) else { return XCTFail("the room did not lay out") }
            var material = at.material
            material.receive(marks(hers, at: t))
            let centre = at.stage.placement.coordinate
            let source = material.emission(at: centre)
            XCTAssertGreaterThan(source, 0.05,
                                 "at \(t)s the source emits \(source). It is the only light in the room")

            // Every court, read at its own place: none of them outshines the
            // point they are all enclosures of.
            var brightest = 0.0
            for index in 0..<DissolveRoom.yantra.count {
                let place = DissolveRoom.place(index, at: t, figure: at.figure,
                                               centre: centre, material: material)
                brightest = max(brightest, material.emission(at: place.at))
            }
            XCTAssertGreaterThan(source, brightest,
                                 """
                                 at \(t)s a court emits \(brightest) against the source's \(source). \
                                 The figure is outshining the point it is a figure of.
                                 """)
        }
    }

    // MARK: - 7 · nothing mounts a solid

    /// The renderer ruling's binding condition: her layer holds the light in what
    /// was made and no geometry at all. Asked of the one room whose figure is the
    /// whole mandala, because a yantra is the easiest thing in the instrument to
    /// reach for as an object.
    func testTheBinduMountsNoSolid() throws {
        for location in ["crown", "heart", "soles"] {
            guard let hers = room(bodyAltitude: location) else {
                return XCTFail("the Bindu did not resolve at \(location)")
            }
            let scene = RoomScene(room: hers)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               the Bindu at \(location) mounted \(scene.solidsInHerLayer) solids \
                               at \(t)s. The yantra is an action on the room's own material.
                               """)
            }
            // …and every one of her marks is one of the five verbs, which is the
            // only vocabulary there is.
            let verbs = Set(marks(hers, at: HomeMemory.secondAdaptationEnd).map(\.verb))
            XCTAssertFalse(verbs.isEmpty)
            XCTAssertTrue(verbs.isSubset(of: Set(SurfaceVerb.allCases)))
        }
    }

    // MARK: - 8 · legible at both adaptations

    /// Design's first verification check, wherever on the body she is felt:
    /// neither black nor blown out nor flat, at both adaptations, by offscreen
    /// capture. The sweep is over all three surfaces because the yantra's plane
    /// is declared to **be** the surface (``DissolveRoom``'s first reading), and
    /// a reading that only held on a working face would be a reading that held
    /// nowhere.
    func testTheBinduIsLegibleAtBothAdaptationsOnEverySurface() throws {
        for location in ["crown", "heart", "soles"] {
            guard let hers = room(bodyAltitude: location) else {
                return XCTFail("the Bindu did not resolve at \(location)")
            }
            OuterRingCapture.assertLegible(hers, called: "the Bindu, felt at the \(location)")
        }
    }

    // MARK: - 9 · reduce motion arrives at the settled room

    /// FIDELITY's reduce-motion path is **real**: the room is posed once, at the
    /// settled state, and drawn once. What that has to mean for a room is that
    /// the still frame is the room a walker who stayed would have arrived at —
    /// with the premise already turned, not a frozen middle.
    ///
    /// Held as arithmetic rather than as a render, because the number the still
    /// path poses at is the whole of it: `RoomCaptureTests` already proves the
    /// loop is stopped, and what this asks is that the instant it stops at is one
    /// where the Bindu's room has reversed.
    func testTheStillPathArrivesAtTheReversedRoom() throws {
        let hers = try room()
        let still = RoomClock().stillInstant()
        XCTAssertEqual(still, HomeMemory.secondAdaptationEnd)

        // A clock still held at her threshold poses the room's opening instead —
        // a room he has not entered has not adapted.
        XCTAssertEqual(RoomClock.held().stillInstant(), 0)

        let settled = marks(hers, at: still)
        let opening = marks(hers, at: 0)
        XCTAssertEqual(settled.count, opening.count)

        // The premise is turned at the instant the still path draws.
        XCTAssertLessThan(OuterRingStage.stations(room: hers, at: still)[.wall] ?? 0, 0,
                          "the still room's enclosure has not given way")
        let source = try XCTUnwrap(settled.last)
        XCTAssertGreaterThan(source.reach, (try XCTUnwrap(opening.last)).reach,
                             "the still room's source has not arrived")
        XCTAssertEqual(DissolveRoom.source(at: still), 0, accuracy: 1e-9)

        // And the room is a pure function of that instant: posing it twice is the
        // same room, which is what lets the still path draw exactly once.
        let scene = RoomScene(room: hers)
        scene.pose(at: still)
        let first = OuterRingFingerprint.at(scene, still)
        scene.pose(at: still)
        XCTAssertEqual(first, OuterRingFingerprint.at(scene, still))
    }
}
