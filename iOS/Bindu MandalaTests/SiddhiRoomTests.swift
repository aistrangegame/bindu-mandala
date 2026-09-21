import XCTest
@testable import Bindu_Mandala

// MARK: - RING 1 · PASS ONE · the ten Siddhis
//
// Khaḍgamālā 1–10, and it is not one family of ten rooms: it is **five rooms the
// grammar speaks for and five Design authored by hand**, and the authored ones
// are half of Design's whole hand-built set.
//
//   · 1 Aṇimā — ``ContractRoom``, the walls close while you stand still
//   · 2 Mahimā — ``EndlessRoom``, no far wall · it never arrives
//   · 3 Laghimā — ``ReleaseRoom``, the floor has let go (Phase 3.3, the Gate)
//   · 4 Garimā — ``PressRoom``, the ceiling comes down (Phase 3.3, the Gate)
//   · 6 Vaśitva — ``KnownRoom``, it has turned, and it rests on you
//   · 5, 7, 8, 9, 10 — ``SiddhiRoom``, the capacity lent and the room repeating it
//
// What is held here:
//
//   1. each of the ten reaches **her own** room, by position, and nobody else
//      reaches a Siddhi's
//   2. the room's answer really is her own motion **delayed**, which is the whole
//      family
//   3. the capacity shrinks while the room deepens — the premise, reversed
//   4. every mark stands clear of the stone's own grain
//   5. the three authored rooms each do a different thing with the enclosure, and
//      none of them does what the other two do
//   6. nothing in any of the ten mounts a solid
//
// **What the synthetic half proves, and what it does not.** Only Ring 2's sixteen
// rows ship in the binary; Ring 1 lives in Airtable and a bundled copy would be
// the ghost roster law 1 exists to prevent. So every row below comes from
// ``HomesCorpus``, built out of real tattva vocabulary keyed off position, and a
// difference found between two of them is weaker evidence than it looks — they
// differ partly *because* position differs. The value is in the shape of a
// failure, and in the checks that do not depend on the rows at all.
final class SiddhiRoomTests: XCTestCase {

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { (1...10).contains($0.row.position) }
    }

    /// A body altitude that puts her mark on one named surface, read off
    /// ``RoomUnits/surface(forBodyAltitude:)`` rather than chosen — two of the
    /// authored rooms below are *about* where a thing stands on the surface, and
    /// both of them read differently on a floor and on a working face.
    private static func altitude(landingOn surface: RoomSurfaceKind) -> Double? {
        stride(from: 0.0, through: 1.0, by: 0.01)
            .first { RoomUnits.surface(forBodyAltitude: $0) == surface }
    }

    /// One instant of a stay, at a chosen altitude.
    private static func stage(bodyAltitude: Double, at t: TimeInterval, seed: Int) -> RoomStage {
        var materials: [RoomSurfaceKind: RoomMaterial] = [:]
        for kind in RoomSurfaceKind.allCases {
            materials[kind] = RoomMaterial(surface: kind, seed: seed)
        }
        return RoomStage(placement: RoomUnits.placement(bodyAltitude: bodyAltitude, chamberTime: t),
                         settling: HomeGrammar.settling(chamberTime: t),
                         deep: HomeGrammar.deepProgress(chamberTime: t),
                         materials: materials)
    }

    // MARK: - 1 · each of the ten reaches her own room, by position

    /// **The dispatch is decided by position and by nothing else.**
    ///
    /// Design's `BY_NAME` keys four of its eight authored rooms with spellings
    /// that match no card, and in its own shipped Axis those four fall silently
    /// through to the grammar with no test able to see it. ``HomeRooms/authored``
    /// is keyed by khaḍgamālā position, which cannot be misspelled, and this is
    /// the check Design lacked — asked of all ten seats and from both ends.
    func testEachSiddhiReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, [
            1: "ContractRoom", 2: "EndlessRoom", 3: "ReleaseRoom", 4: "PressRoom",
            5: "SiddhiRoom", 6: "KnownRoom", 7: "SiddhiRoom", 8: "SiddhiRoom",
            9: "SiddhiRoom", 10: "SiddhiRoom",
        ], "a Siddhi is standing in somebody else's room")

        // …and nobody outside the first ten seats reaches a Siddhi's.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !(1...10).contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is SiddhiRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a Siddhi's room without standing in the first ten seats")

        // Her turn of the ten is Design's own, and no two of the five share one.
        let phases = rooms().compactMap { entry -> Double? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return reading.phase
        }
        XCTAssertEqual(phases.count, 5)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 5,
                       "two of the grammar-built Siddhis take the same turn of the ten")
    }

    // MARK: - 2 · the room does the same thing, later

    /// **The answer is her own motion, delayed — and that is the family.**
    ///
    /// Design's `displace(kind, t - 0.6 - i * 0.5, ph, 2.2)`: the room performs
    /// what she performed a moment ago, and a moment further ago the further off
    /// it stands. Read as an identity rather than as a resemblance — where the
    /// capacity stood at `t - lag` is exactly where the answer stands at `t`,
    /// along the surface, once the answer's own place on the line is taken away.
    func testTheRoomsAnswerIsHerOwnMotionDelayed() {
        guard let entry = rooms().first(where: { $0.row.position == 7 }) else {
            return XCTFail("khaḍgamālā 7 did not resolve")
        }
        guard let built = RoomMechanisms.forRoom(entry.room) as? SiddhiRoom else {
            return XCTFail("khaḍgamālā 7 is not a grammar-built Siddhi")
        }
        let t: TimeInterval = 140
        let stage = RingOneStage.stage(room: entry.room, at: t)
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return XCTFail("no material") }
        let figure = RingOne.Figure(spread: Double(SiddhiRoom.echoes) * SiddhiRoom.echoStep,
                                    part: SiddhiRoom.echoSize
                                        + Double(SiddhiRoom.echoes - 1) * SiddhiRoom.echoSizeStep,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)

        for step in 1...SiddhiRoom.echoes {
            let lag = SiddhiRoom.echoLag + Double(step - 1) * SiddhiRoom.echoLagStep
            let answer = built.place(step: step, at: t, figure: figure,
                                     stage: stage, material: material)
            let capacityThen = built.place(step: 0, at: t - lag, figure: figure,
                                           stage: stage, material: material)
            // Where the answer stands, minus where its own place on the line put
            // it, is where the capacity was a moment ago — to the damping Design
            // puts on the answers' travel along the room.
            let run = figure.length(SiddhiRoom.echoStep * Double(step))
            let axes = RoomUnits.axes(of: surface)
            let placed = material.reach(worldUnits: axes.along(design: -run, rise: run))
            let centre = stage.placement.coordinate
            XCTAssertEqual(answer.at.u, capacityThen.at.u, accuracy: 1e-9,
                           "answer \(step) is not carrying her own motion across the surface")
            XCTAssertEqual(answer.at.v - placed,
                           centre.v + (capacityThen.at.v - centre.v) * SiddhiRoom.echoDepthDamping,
                           accuracy: 1e-9,
                           "answer \(step) is not carrying her own motion along the room")
        }

        // And the delay is real: at least one answer stands somewhere the
        // capacity is not, which is what makes it an echo rather than a copy.
        let now = built.place(step: 0, at: t, figure: figure, stage: stage, material: material)
        let apart = (1...SiddhiRoom.echoes).contains { step in
            let answer = built.place(step: step, at: t, figure: figure,
                                     stage: stage, material: material)
            return abs(answer.into - now.into) > 1e-6
        }
        XCTAssertTrue(apart, "every answer is doing exactly what she is doing — there is no lag")
    }

    // MARK: - 3 · the premise, reversed

    /// **The capacity shrinks to nothing while the room holds it deeper.**
    ///
    /// Design's two lines side by side: `lent.scale.setScalar(1 - b * 0.8)` and
    /// the answers' `(1 + b * 1.4)`. It is the whole sentence — *the capacity was
    /// never lent* — and it is asserted as two numbers moving in opposite
    /// directions rather than as a word in a label.
    func testTheCapacityShrinksWhileTheRoomTakesItOver() throws {
        for (row, room) in rooms() {
            guard RoomMechanisms.forRoom(room) is SiddhiRoom else { continue }
            let atFirst = RingOneStage.marks(room: room, at: HomeMemory.firstAdaptation)
            let pastSecond = RingOneStage.marks(room: room, at: HomeMemory.secondAdaptationEnd)
            XCTAssertEqual(atFirst.count, SiddhiRoom.echoes + 1,
                           "khaḍgamālā \(row.position) is not one capacity and six answers")
            XCTAssertEqual(pastSecond.count, atFirst.count)

            XCTAssertLessThan(pastSecond[0].reach, atFirst[0].reach * 0.35,
                              """
                              khaḍgamālā \(row.position)'s capacity is still being held out in \
                              front of her past the second adaptation. Design shrinks it by four \
                              fifths; a capacity that is still there was lent.
                              """)
            let deepenedFirst = atFirst.dropFirst().map(\.depth).reduce(0, +)
            let deepenedLater = pastSecond.dropFirst().map(\.depth).reduce(0, +)
            XCTAssertGreaterThan(deepenedLater, deepenedFirst,
                                 """
                                 khaḍgamālā \(row.position): the room is not holding the capacity \
                                 any deeper than it did while the eye was settling. Nothing was \
                                 taken over.
                                 """)
        }
    }

    // MARK: - 4 · a mark that can be seen

    /// **No mark is shallower than the stone it is cut into.**
    ///
    /// The dhātu's grain stands a fortieth of a body high so that a raking light
    /// has something to fall across; a mark below it is not faint, it is absent.
    /// Ring 1's first render is the evidence — fourteen Mātṛkā letters shared down
    /// to a quarter of a mark came back as horizontal banding with nothing in it.
    func testEverySiddhiMarkStandsClearOfTheStonesOwnGrain() {
        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                for (index, mark) in RingOneStage.marks(room: room, at: t).enumerated()
                where mark.reach > 0 {
                    XCTAssertGreaterThanOrEqual(mark.depth, material.grainRelief - 1e-9,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                is \(mark.depth) deep against a grain of \
                                                \(material.grainRelief). It cannot be seen.
                                                """)
                }
            }
        }
    }

    // MARK: - 5 · three authored rooms, three different enclosures

    /// **There are exactly two things an enclosure can do, and Ring 1 holds both
    /// of Design's authored examples of them.**
    ///
    /// Aṇimā's closes in while the eye is settling; Mahimā's was never there at
    /// any instant; Laghimā's is present for the whole first adaptation and leaves
    /// as the reversal. A room that borrowed another's would be standing in it —
    /// which is why the five grammar-built Siddhis next door move no wall at all.
    func testTheThreeAuthoredEnclosuresAreThreeDifferentThings() throws {
        func wall(_ position: Int, at t: TimeInterval) throws -> Double {
            let entry = try XCTUnwrap(HomesCorpus.resolvedRooms()
                .first { $0.row.position == position })
            let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room))
            let stage = RingOneStage.stage(room: entry.room, at: t)
            return mechanism.stations(at: t, stage: stage)[.wall] ?? 0
        }

        // Aṇimā: in, while the eye is settling — and out again at the turn.
        let animaSettling = try wall(1, at: HomeMemory.firstAdaptation)
        let animaDeep = try wall(1, at: HomeMemory.secondAdaptationEnd)
        XCTAssertGreaterThan(animaSettling, 0,
                             "Aṇimā's walls are not closing in — that is her whole premise")
        XCTAssertLessThan(animaDeep, 0,
                          "Aṇimā's walls never leave — the point was not a door")

        // Mahimā: gone, at every instant, and by the same amount.
        let mahimaOpen = try wall(2, at: 0)
        let mahimaDeep = try wall(2, at: HomeMemory.secondAdaptationEnd)
        XCTAssertLessThan(mahimaOpen, 0, "Mahimā opens with an enclosure — it never arrives")
        XCTAssertEqual(mahimaOpen, mahimaDeep, accuracy: 1e-9,
                       """
                       Mahimā's enclosure changed during the stay. *It never arrives* is a \
                       statement about every instant, not about the turn.
                       """)

        // Laghimā: there the whole first adaptation, gone at the turn.
        XCTAssertEqual(try wall(3, at: HomeMemory.firstAdaptation), 0, accuracy: 1e-9,
                       "Laghimā's enclosure left before her floor did")
        XCTAssertLessThan(try wall(3, at: HomeMemory.secondAdaptationEnd), 0,
                          "Laghimā's enclosure never leaves")

        // And the five the grammar speaks for move no wall at all.
        for position in [5, 7, 8, 9, 10] {
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                XCTAssertEqual(try wall(position, at: t), 0, accuracy: 1e-9,
                               """
                               khaḍgamālā \(position) is moving the enclosure at \(t)s. Both \
                               stations are authored rooms' premises — closing in is Aṇimā's and \
                               leaving is Laghimā's — and a grammar Siddhi that borrows one is \
                               standing in a room eight seats away.
                               """)
            }
        }
    }

    // MARK: - 5b · the two authored rooms whose content is *where* it stands

    /// **Mahimā's procession runs toward the walker and past him, and not the
    /// other way round.**
    ///
    /// A surface's `v` runs to `(v - 0.5) · extent`
    /// (``RoomScene/mesh(of:extent:orientation:resolution:)``): on a floor that is
    /// **z**, so the far edge is `v = 0` and the walker's own standing point is
    /// ``RoomUnits/eyeZ`` past the middle. Read the other way round — and it was —
    /// the twenty-four frames receded from behind him toward the far wall, and the
    /// ten the turn adds, whose whole sentence is *there was no near wall either*,
    /// landed on the far half of the floor on top of the ones already standing
    /// there. Nothing in the suite read a frame's position, so all of it was green.
    func testMahimasProcessionAdvancesTowardTheWalkerAndPastHim() throws {
        let ground = try XCTUnwrap(Self.altitude(landingOn: .ground))
        let room = EndlessRoom()

        // At the opening the twenty-four stand evenly down the whole run, the
        // first of them at the far edge.
        let opening = Self.stage(bodyAltitude: ground, at: 0, seed: 2)
        let atRest = try XCTUnwrap(room.actions(at: 0, stage: opening)[.ground])
        XCTAssertEqual(atRest.count, EndlessRoom.frames * EndlessRoom.marksPerFrame,
                       "the procession is not twenty-four frames before the premise turns")
        XCTAssertEqual(atRest.first?.at.v ?? -1, 0, accuracy: 1e-9,
                       "the first frame does not stand at the far edge of the material")
        XCTAssertEqual(atRest.last?.at.v ?? -1,
                       Double(EndlessRoom.frames - 1) / Double(EndlessRoom.frames),
                       accuracy: 1e-9,
                       "the last frame of the procession is not the one nearest the walker")

        // …and they advance: a frame that has travelled further stands further
        // along the material.
        let moved = try XCTUnwrap(room.actions(at: 1, stage: Self.stage(bodyAltitude: ground,
                                                                       at: 1, seed: 2))[.ground])
        XCTAssertGreaterThan(moved.first?.at.v ?? 0, atRest.first?.at.v ?? 0,
                             "the procession is running away from the walker")

        // And the ten that continue once the premise turns stand in the near
        // stretch — past the walker's own standing point, which is where he had
        // taken the room to end.
        let t = HomeMemory.secondAdaptationEnd
        let turned = try XCTUnwrap(room.actions(at: t, stage: Self.stage(bodyAltitude: ground,
                                                                        at: t, seed: 2))[.ground])
        XCTAssertEqual(turned.count,
                       (EndlessRoom.frames + EndlessRoom.framesBehind) * EndlessRoom.marksPerFrame)
        let behind = turned.suffix(EndlessRoom.framesBehind * EndlessRoom.marksPerFrame)
        let standsAt = 0.5 + RoomUnits.eyeZ / RoomUnits.extent
        XCTAssertGreaterThanOrEqual(behind.map(\.at.v).min() ?? 0, 0.5,
                                    """
                                    the frames that continue past the walker are standing in the \
                                    far half of the room. *There was no near wall either* is about \
                                    the stretch behind him.
                                    """)
        XCTAssertGreaterThan(behind.map(\.at.v).max() ?? 0, standsAt,
                             "not one of the ten has passed the walker's own standing point")
    }

    /// **And the procession is one widening mouth on every surface**, rather than
    /// twenty-four frames clamped to one width.
    ///
    /// On a working face Design's widest frame is four times what the material can
    /// hold, and clamped frame by frame all twenty-four came out identical with
    /// forty-eight of their hundred and twenty marks standing on the material's
    /// own edge — which is ``RingOne/Figure``'s own finding: *a ring whose marks
    /// are clamped onto the edge of the material is not a ring, it is a heap*.
    func testMahimasProcessionKeepsItsWideningMouthOnAWorkingFace() throws {
        for kind in [RoomSurfaceKind.face, .ground] {
            let altitude = try XCTUnwrap(Self.altitude(landingOn: kind))
            let stage = Self.stage(bodyAltitude: altitude, at: 0, seed: 2)
            let marks = try XCTUnwrap(EndlessRoom().actions(at: 0, stage: stage)[kind])
            let widths = Set(marks.map { String(format: "%.5f", $0.reach) })
            XCTAssertEqual(widths.count, EndlessRoom.frames,
                           """
                           on a \(kind.rawValue) the twenty-four frames come in \(widths.count) \
                           widths. Design's `r = 6 + i * 0.52` is a widening mouth rather than a \
                           tunnel of one bore.
                           """)
            let onTheEdge = marks.filter { $0.at.u <= 1e-9 || $0.at.u >= 1 - 1e-9 }
            XCTAssertTrue(onTheEdge.isEmpty,
                          """
                          \(onTheEdge.count) of the procession's marks stand on the material's own \
                          edge on a \(kind.rawValue).
                          """)
        }
    }

    /// **Vaśitva's pool of attention comes to rest on the walker — in front of the
    /// eye, and wholly on the material.**
    ///
    /// It is the one lit mark in that room, and it was pinned to the material's
    /// near edge on the reading that a floor's near edge is where he is standing.
    /// It is not: he stands ``RoomUnits/eyeZ`` past the middle, and that edge is
    /// most of a room behind him. At *it has turned, and it rests on you* the only
    /// light in the room left the frame entirely.
    func testVasitvasPoolComesToRestInFrontOfTheEye() throws {
        for kind in RoomSurfaceKind.allCases where kind != .wall {
            let altitude = try XCTUnwrap(Self.altitude(landingOn: kind))
            let t = HomeMemory.secondAdaptationEnd
            let stage = Self.stage(bodyAltitude: altitude, at: t, seed: 6)
            let marks = try XCTUnwrap(KnownRoom().actions(at: t, stage: stage)[kind])
            // The pool is the last thing the room does, and the only mark in it
            // she lights: the pillars and the seat are pressed and unlit, and the
            // archetype's own answering mark — which is not hers — is laid down
            // before the room's own.
            let pool = try XCTUnwrap(marks.last)
            XCTAssertGreaterThan(pool.glow, 0,
                                 "the pool of attention is the one light in Vaśitva's room")
            let standsAt = kind == .face ? 0.5 : 0.5 + RoomUnits.eyeZ / RoomUnits.span(of: kind)
            XCTAssertEqual(pool.at.v, standsAt, accuracy: 1e-6,
                           """
                           on a \(kind.rawValue) the pool comes to rest at \(pool.at.v) and the \
                           walker stands at \(standsAt). The room's own sentence is that its light \
                           ends up on him.
                           """)
            XCTAssertLessThanOrEqual(pool.at.v + pool.reach, 1 + 1e-9,
                                     "half the pool is hanging off the edge of the material")
            XCTAssertGreaterThanOrEqual(pool.at.v - pool.reach, -1e-9)
        }
    }

    // MARK: - 5c · the ten, told apart by their geometry

    /// **Every pair of the five the grammar speaks for, above Design's tenth.**
    ///
    /// The Mudrās have had this check since they were built and Ring 2 has its
    /// own; the Siddhis and the Mātṛkās never did, and the family measure next
    /// door averages pairs rather than asking each one. Measured here pair by
    /// pair, with the authored five printed beside it rather than folded in —
    /// Ruling 10 exempts a hand-built room from the grammar-only proof, and an
    /// authored room is an outlier in whichever family it sits in by construction.
    func testEveryPairOfTheGrammarBuiltSiddhisDivergesOnGeometry() {
        let seats = RingOneFingerprint.ringOne(HomesCorpus.resolvedRooms())
            .filter { (1...10).contains($0.position) }
        XCTAssertEqual(seats.count, 10, "Ring 1's first ten seats are not all built")
        let grammared = seats.filter(\.grammared)
        XCTAssertEqual(grammared.count, 5, "the five the grammar speaks for are not five")

        var blurred: [String] = []
        var closest = (pair: "—", divergence: Double.infinity)
        for (index, a) in grammared.enumerated() {
            for b in grammared[(index + 1)...] {
                let d = RingOneFingerprint.divergence(a.print, b.print)
                if d < closest.divergence { closest = ("kp \(a.position) ↔ kp \(b.position)", d) }
                if d <= RingOneFingerprint.threshold {
                    blurred.append("kp \(a.position) ↔ kp \(b.position) — "
                                   + String(format: "%.3f", d))
                }
            }
        }
        // …and the authored five against the whole ten, printed only.
        var authored = (pair: "—", divergence: Double.infinity)
        for a in seats where !a.grammared {
            for b in seats where b.position != a.position {
                let d = RingOneFingerprint.divergence(a.print, b.print)
                if d < authored.divergence {
                    authored = ("kp \(a.position) ↔ kp \(b.position)", d)
                }
            }
        }
        print("SIDDHI_DIVERGENCE {\"closest\":\"\(closest.pair)\","
              + String(format: "\"divergence\":%.4f,", closest.divergence)
              + "\"authoredClosest\":\"\(authored.pair)\","
              + String(format: "\"authoredDivergence\":%.4f}", authored.divergence))
        XCTAssertTrue(blurred.isEmpty,
                      """
                      \(blurred.count) pair(s) of the grammar-built Siddhis blur into one another. \
                      Could this room belong to any other Śakti? Fix the room; never lower the \
                      threshold.
                      \(blurred.joined(separator: "\n"))
                      """)
    }

    // MARK: - 6 · nothing stands in her layer

    /// The binding condition, at this ring: no Siddhi room mounts a solid.
    func testNoSiddhiRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               "khaḍgamālā \(row.position) mounted a solid at \(t)s")
            }
        }
    }
}
