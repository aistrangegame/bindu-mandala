import XCTest
@testable import Bindu_Mandala

// MARK: - RING 8 · the three at the source
//
// Khaḍgamālā 99–101, and the smallest ring in the instrument. None of the three
// is authored: every one is ``SourcingRoom``, tuned by her own row.
//
// **Two of the three share a physics and that is deliberate.** All three cards
// say *"at the source"*, and Design's rule order reads `/yoni|source|bhaga/ →
// spring` nine rules before `/icch|…|will/ → incline`, so `99` and `101` both
// classify as `spring`. The order is Design's and pinned by
// `HomeGrammarTests`; what is asserted here is that it does not cost the two of
// them their rooms.
//
// What is held:
//
//   1. each of the three reaches her own room by position, and her corner is
//      Design's `pos - 99`
//   2. `99` and `101` carry one physics — asserted, so the day it changes the
//      room's reasoning is re-read — and the three rooms still diverge above
//      Design's tenth
//   3. the figure turns, and every mark of it travels. A static offset cannot
//      see a cancelled motion, so what is asserted is what travels
//   4. one corner is hers and the other two are dark, and past the second
//      adaptation the two answer
//   5. the bindu is ringed and not reached — shallower than anything else in the
//      room until the premise turns, and then it opens
//   6. **Design's own defect**: the triangle stood larger than the room and the
//      corners went near-black. No mark of the figure is ever clamped onto the
//      edge of the material
//   7. the premise reverses as something the room does
//   8. every mark clears the mesh cell and the stone's own grain
//   9. nothing mounts a solid, and each of the three is legible at both
//      adaptations
//
// **What the synthetic rows prove, and what they do not.** The three live in
// Airtable and nowhere else, so their rows come from ``HomesCorpus`` and a
// difference between two of them is weaker evidence than it looks. The corner
// checks are the exception: `pos - 99` is read off position alone.
@MainActor
final class SourcingRoomTests: XCTestCase {

    private static let seats = 99...101

    /// Five: three corners, the bindu, and the one mark the reversal makes.
    private static let slots = SourcingRoom.corners + 2

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    private func built(_ position: Int) throws -> (room: HomeRoom, mechanism: SourcingRoom) {
        let entry = try XCTUnwrap(rooms().first { $0.row.position == position },
                                  "khaḍgamālā \(position) did not resolve")
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? SourcingRoom,
                                      "khaḍgamālā \(position) is not a sourcing room")
        return (entry.room, mechanism)
    }

    private func figure(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: SourcingRoom.ring,
                                  spread: SourcingRoom.radius * 2,
                                  part: SourcingRoom.mineSize / 2,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    // MARK: - 1 · each of the three reaches her own room, by position

    func testEachOfTheThreeReachesHerOwnRoomByPosition() throws {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, 8)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "SourcingRoom") }),
                       "one of the three is standing in somebody else's room")

        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is SourcingRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a sourcing room without standing in the eighth āvaraṇa")

        for (offset, position) in Self.seats.enumerated() {
            let (_, mechanism) = try built(position)
            XCTAssertEqual(mechanism.corner, offset,
                           "khaḍgamālā \(position) is not standing at her own corner")
            XCTAssertEqual(mechanism.corner, position - 99, "Design's own `card.pos - 99`")
        }

        // …and no one of the three carries a phase, which is the fact her corner
        // stands in for.
        for (row, room) in rooms() {
            guard case .grammar(let reading) = room.kind else {
                return XCTFail("khaḍgamālā \(row.position) is not a grammar room")
            }
            XCTAssertNil(reading.phase,
                         "khaḍgamālā \(row.position) now carries a phase; the room should read it")
            XCTAssertEqual(reading.sourcingCorner, row.position - 99)
        }
    }

    // MARK: - 2 · one physics between two of them, and three rooms anyway

    /// **The shared physics is asserted rather than assumed.** It is a
    /// consequence of Design's rule order — `source` nine rules before `icchā` —
    /// and this room is built against it. If the order ever changes, this fails
    /// and the reasoning in ``SourcingRoom``'s header is re-read rather than
    /// quietly becoming untrue.
    func testTwoOfTheThreeShareOnePhysicsAndStillBuildDifferentRooms() throws {
        // Design's own cards, read through the classifier rather than through the
        // corpus: the corpus makes its rows up, and this is a claim about what
        // ships.
        XCTAssertEqual(HomeGrammar.physics(tattva: "Icchā at the source",
                                           quality: "Will-to-Create"), .spring)
        XCTAssertEqual(HomeGrammar.physics(tattva: "Jñāna at the source",
                                           quality: "Manifestation-Garland"), .spring)
        XCTAssertEqual(HomeGrammar.physics(tattva: "Kriyā at the source",
                                           quality: "Lightning-Action"), .dart,
                       "only the act escapes the `source` rule, and it escapes it earlier")

        let seats = OuterRingFingerprint.ring(8, HomesCorpus.resolvedRooms(), slots: Self.slots)
        XCTAssertEqual(seats.count, 3)

        var closest = (1.0, 0, 0)
        for (index, one) in seats.enumerated() {
            for other in seats[(index + 1)...] {
                let d = OuterRingFingerprint.divergence(one.print, other.print)
                if d < closest.0 { closest = (d, one.position, other.position) }
                XCTAssertGreaterThan(d, OuterRingFingerprint.threshold,
                                     """
                                     khaḍgamālā \(one.position) and \(other.position) are \
                                     \(String(format: "%.3f", d)) apart on the geometric \
                                     fingerprint, under Design's tenth.
                                     """)
            }
        }
        print("RING8_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all three rooms. A print that is mostly padding passes by dilution.
                          """)

        // …and the two that share a physics do not share a turn of it, because her
        // corner is her phase.
        let (_, will) = try built(99)
        let (_, form) = try built(101)
        XCTAssertNotEqual(OuterRings.spread(index: will.corner, of: SourcingRoom.corners,
                                            kind: will.physics),
                          OuterRings.spread(index: form.corner, of: SourcingRoom.corners,
                                            kind: form.physics),
                          "the will and the form take the same turn of the three")
    }

    // MARK: - 3 · the figure turns

    /// **Design's `tri.rotation.z = t * 0.006`**, and it is the only continuous
    /// motion in the builder that belongs to the figure rather than to a part. It
    /// is what keeps three corners moving in a ring where two of the three rooms
    /// share a physics — so it is asserted as travel rather than as an offset.
    func testTheWholeFigureTurnsAndEveryCornerTravels() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? SourcingRoom,
                  let read = figure(room, at: 0) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            for index in 0..<SourcingRoom.corners {
                let here = mechanism.place(index: index, at: 0, figure: read.figure,
                                           stage: read.stage, material: read.material)
                let later = mechanism.place(index: index, at: OuterRings.readOver,
                                            figure: read.figure, stage: read.stage,
                                            material: read.material)
                XCTAssertNotEqual(here.at, later.at,
                                  """
                                  khaḍgamālā \(row.position), corner \(index) does not travel \
                                  across a quarter of the first adaptation. The innermost triangle \
                                  turns.
                                  """)
            }

            // The bindu does not turn with them: it is what they turn around.
            let centres = [0, 30, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd].map { t in
                mechanism.place(index: SourcingRoom.binduIndex, at: t, figure: read.figure,
                                stage: read.stage, material: read.material)
            }
            XCTAssertEqual(Set(centres.map { "\($0.at.u)|\($0.at.v)|\($0.into)" }).count, 1,
                           "khaḍgamālā \(row.position): the bindu moved. It is what they ring")

            // …and the three stand at Design's own angles, 120° apart.
            for index in 0..<SourcingRoom.corners {
                let a = SourcingRoom.angle(index, at: 0)
                XCTAssertEqual(a, SourcingRoom.firstCorner
                               + Double(index) / 3 * 2 * .pi, accuracy: 1e-12)
            }
        }
    }

    // MARK: - 4 · hers is lit and the other two are dark, until they answer

    /// *Her corner is lit; the other two are present but dark, because the three
    /// are inseparable.* And *present* is not a figure of speech here: all three
    /// corners move the stone, and what the two are missing is emission — which
    /// the eighth āvaraṇa's own key still rakes across and finds.
    func testHerCornerIsLitAndTheOtherTwoAnswerPastTheSecondAdaptation() throws {
        for (row, room) in rooms() {
            let (_, mechanism) = try built(row.position)
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            let early = OuterRingStage.marks(room: room, at: HomeMemory.firstAdaptation)
            XCTAssertEqual(early.count, SourcingRoom.corners + 1,
                           "khaḍgamālā \(row.position) is not three corners and a bindu")

            let mine = early[mechanism.corner]
            let others = (0..<SourcingRoom.corners)
                .filter { $0 != mechanism.corner }
                .map { early[$0] }
            for other in others {
                XCTAssertLessThan(other.glow, mine.glow / 2,
                                  """
                                  khaḍgamālā \(row.position): a corner that is not hers is lit at \
                                  \(other.glow) against her \(mine.glow). Only one of the three \
                                  speaks while the eye settles.
                                  """)
                // …and it is **present**: the stone was moved at the same size at
                // all three corners, which is the claim *the three are
                // inseparable* makes about the material. The depths are not
                // identical and must not be asserted to be — how hard a corner is
                // bearing is her physics at that corner's own turn
                // (``OuterRings/pressed(_:travel:)``), and a check that demanded
                // three equal numbers would be demanding that her physics stop at
                // the two that are dark.
                XCTAssertGreaterThan(other.depth, material.grainRelief,
                                     """
                                     khaḍgamālā \(row.position): a dark corner sits under the \
                                     banding it was cut into. Dark is a fact about light here, \
                                     not about depth.
                                     """)
                XCTAssertLessThan(max(other.depth, mine.depth) / min(other.depth, mine.depth), 2,
                                  """
                                  khaḍgamālā \(row.position): a dark corner is \(other.depth) \
                                  against her \(mine.depth). That is no longer one figure cut at \
                                  one size.
                                  """)
                XCTAssertGreaterThan(other.reach, 0)
            }

            // Past the second adaptation the two that were dark answer.
            let late = OuterRingStage.marks(room: room, at: HomeMemory.secondAdaptationEnd)
            let offset = late.count - (SourcingRoom.corners + 1)
            for index in 0..<SourcingRoom.corners where index != mechanism.corner {
                XCTAssertGreaterThan(late[offset + index].glow, early[index].glow * 2,
                                     """
                                     khaḍgamālā \(row.position): corner \(index) never answers. \
                                     Design's `90 + b * 700` is will discovering it was already \
                                     act and form.
                                     """)
            }
        }
    }

    // MARK: - 5 · the bindu they ring, not yet reached

    func testTheBinduIsRingedAndNotReachedUntilThePremiseTurns() throws {
        for (row, room) in rooms() {
            let (_, mechanism) = try built(row.position)
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            let early = OuterRingStage.marks(room: room, at: HomeMemory.firstAdaptation)
            let bindu = early[SourcingRoom.binduIndex]

            // Not reached: the shallowest thing in the room, and still above the
            // banding it is cut into.
            // The least the instrument lets anything ask for:
            // ``OuterRings/mark(_:from:reach:size:travel:glow:material:)`` holds a
            // size at a fifth before it reaches ``RoomInscription/depth(size:on:)``,
            // and leans it by how hard the part is bearing, so *not reached* is
            // the shallowest a mark in this room can be and still be a mark.
            XCTAssertLessThanOrEqual(bindu.depth,
                                     RoomInscription.depth(size: 0.2, on: material) + 1e-9,
                                     """
                                     khaḍgamālā \(row.position)'s bindu has already been arrived \
                                     at. It is the point they ring and have not reached.
                                     """)
            XCTAssertGreaterThanOrEqual(bindu.depth, material.grainRelief - 1e-9)
            for index in 0..<SourcingRoom.corners {
                XCTAssertGreaterThan(early[index].depth, bindu.depth,
                                     "khaḍgamālā \(row.position): a corner is shallower than the bindu")
            }
            // …but it is lit from the first instant, which is what separates it
            // from Ring 3's empty middle.
            XCTAssertGreaterThan(bindu.glow, 0,
                                 "khaḍgamālā \(row.position)'s bindu carries no light; it is not an absence")

            // And the corners' strokes close on the triangle rather than across it.
            guard let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let cut = mechanism.layout(figure: read.figure, material: read.material)
            XCTAssertGreaterThanOrEqual(cut.radius, OuterRings.clearance(ofReach: cut.mine) - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): her corner reaches \(cut.mine) \
                                        and stands \(cut.radius) from the middle, so its stroke \
                                        runs across the point it is ringing.
                                        """)
            // **Hers is the larger corner — where the material can carry the
            // difference.** Design's `mine ? 6.4 : 2.4` is a ratio of under three,
            // and on a floor or a canopy — four body-heights across — the whole
            // figure is already at one cell of the mesh
            // (``RoomInscription/narrowestMark``), so both corners sit on the
            // floor and the difference between them is smaller than anything the
            // surface can hold. It is not lost: on those surfaces Design's other
            // number carries it whole, and that number is the light — `0.95`
            // against `0.2`, which the check above asserts in every room.
            XCTAssertGreaterThanOrEqual(cut.mine, cut.other,
                                        "khaḍgamālā \(row.position): hers is the smaller corner")
            if cut.other > OuterRings.narrowestMark {
                XCTAssertGreaterThan(cut.mine, cut.other,
                                     """
                                     khaḍgamālā \(row.position): the surface can carry the \
                                     difference between her corner and the other two, and it is \
                                     not there.
                                     """)
            }

            // Past the second adaptation it opens until it has reached them.
            let late = OuterRingStage.marks(room: room, at: HomeMemory.secondAdaptationEnd)
            let offset = late.count - (SourcingRoom.corners + 1)
            let opened = late[offset + SourcingRoom.binduIndex]
            XCTAssertGreaterThan(opened.reach, bindu.reach * 1.2,
                                 """
                                 khaḍgamālā \(row.position)'s bindu never opens. Design's \
                                 `2.2 * (1 + b * 2.4)` is the source arriving.
                                 """)
            XCTAssertGreaterThan(opened.depth, bindu.depth,
                                 "khaḍgamālā \(row.position)'s bindu is no nearer being reached")
        }
    }

    // MARK: - 6 · Design's own defect: the triangle was larger than the room

    /// The Design thread recorded it — the Ring 8 triangle stood wider than the
    /// room, so its corners left the picture and what was left went near-black.
    /// ``OuterRings/Figure`` scales the whole figure rather than clamping its
    /// parts, and this is the assertion that it worked: **no mark of the figure
    /// is ever on the edge of the material**, at any moment of any stay, and the
    /// three corners are still a triangle rather than three marks on a border.
    func testTheTriangleIsInsideThePictureAndIsStillATriangle() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? SourcingRoom,
                  let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            for t in [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                var corners: [SurfaceCoordinate] = []
                for index in 0..<SourcingRoom.corners {
                    let place = mechanism.place(index: index, at: t, figure: read.figure,
                                                stage: read.stage, material: read.material)
                    XCTAssertGreaterThan(place.at.u, 0,
                                         "khaḍgamālā \(row.position), corner \(index) at \(t)s is clamped to the edge")
                    XCTAssertLessThan(place.at.u, 1,
                                      "khaḍgamālā \(row.position), corner \(index) at \(t)s is clamped to the edge")
                    XCTAssertGreaterThan(place.at.v, 0,
                                         "khaḍgamālā \(row.position), corner \(index) at \(t)s is clamped to the edge")
                    XCTAssertLessThan(place.at.v, 1,
                                      "khaḍgamālā \(row.position), corner \(index) at \(t)s is clamped to the edge")
                    corners.append(place.at)
                }
                // …and the three are not on top of one another: a triangle whose
                // corners collapsed is the same three marks in all three rooms.
                for (index, one) in corners.enumerated() {
                    for other in corners[(index + 1)...] {
                        let du = one.u - other.u, dv = one.v - other.v
                        XCTAssertGreaterThan((du * du + dv * dv).squareRoot(),
                                             RoomInscription.narrowestMark,
                                             """
                                             khaḍgamālā \(row.position) at \(t)s: two corners of \
                                             the triangle are within one mesh cell of each other.
                                             """)
                    }
                }
            }

            // **And the picture is not near-black**, which is the half of Design's
            // defect a geometric check cannot see. A sourcing room *is* dark — one
            // corner speaks and two are silent — so the mean says nothing; what
            // says it is whether there is anything bright in the frame at all.
            let scene = RoomScene(room: room)
            for (when, t) in OuterRingCapture.moments {
                guard let image = scene.capture(size: OuterRingCapture.size, atSceneTime: t) else {
                    return XCTFail("khaḍgamālā \(row.position) could not be rendered offscreen")
                }
                let spread = OuterRingCapture.luminance(of: image)
                XCTAssertGreaterThan(spread.max, 0.15,
                                     """
                                     khaḍgamālā \(row.position), \(when): the brightest thing in \
                                     her room is \(spread.max). Design's own Ring 8 went \
                                     near-black because the triangle stood larger than the room.
                                     """)
            }
        }
    }

    // MARK: - 7 · the premise reverses, as something the room does

    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd
            let part = RoomReversal.resolved(HomeBecoming.archetype(.sourcing),
                                             bodyAltitude: room.bodyAltitude)

            let yieldingSettling = OuterRingStage.stations(room: room, at: settling)[part.premise] ?? 0
            let yieldingPast = OuterRingStage.stations(room: room, at: past)[part.premise] ?? 0
            XCTAssertEqual(yieldingSettling, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s premise moved before it turned")
            XCTAssertLessThan(yieldingPast, 0,
                              "khaḍgamālā \(row.position)'s premise never yields")

            let stage = OuterRingStage.stage(room: room, at: past)
            let all = try XCTUnwrap(RoomMechanisms.forRoom(room)).actions(at: past, stage: stage)
            let answer = try XCTUnwrap((all[part.answer] ?? []).first,
                                       """
                                       khaḍgamālā \(row.position): nothing answered on the \
                                       \(part.answer.rawValue).
                                       """)
            XCTAssertEqual(answer.verb, .swell,
                           """
                           khaḍgamālā \(row.position): the answer read as \(answer.verb.rawValue). \
                           The point at the source comes toward him, so the material rises.
                           """)
            XCTAssertGreaterThan(answer.reach, 0)
        }
    }

    // MARK: - 8 · a mark that can be seen

    func testEveryMarkClearsTheMeshCellAndTheStonesGrain() {
        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
                let mine = marks.dropFirst(max(0, marks.count - (SourcingRoom.corners + 1)))
                for (index, mark) in marks.enumerated() where mark.reach > 0 {
                    XCTAssertGreaterThanOrEqual(mark.reach, RoomInscription.narrowestMark - 1e-12,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                reaches \(mark.reach) against a mesh cell of \
                                                \(RoomInscription.narrowestMark). It is sampled away.
                                                """)
                    XCTAssertGreaterThanOrEqual(mark.depth, material.grainRelief - 1e-9,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                is \(mark.depth) deep against a grain of \
                                                \(material.grainRelief). It cannot be seen.
                                                """)
                }
                for (index, mark) in mine.enumerated() where mark.reach > 0 {
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             deeper than one mark's worth. The room is not a quarry.
                                             """)
                }
            }
        }
    }

    // MARK: - 9 · no solid, and legible at both adaptations

    func testNoSourcingRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               khaḍgamālā \(row.position) mounted \(scene.solidsInHerLayer) solids \
                               at \(t)s.
                               """)
            }
        }
    }

    func testEverySourcingRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }
}
