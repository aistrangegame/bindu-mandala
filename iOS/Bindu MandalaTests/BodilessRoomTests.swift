import XCTest
@testable import Bindu_Mandala

// MARK: - RING 3 · the eight Anaṅgas
//
// Khaḍgamālā 45–52, and the first ring of the outer climb. None of the eight is
// authored: every one of them is ``BodilessRoom``, tuned by her own row.
//
// What is held here:
//
//   1. each of the eight reaches her own room, by position, and nobody outside
//      the third āvaraṇa reaches a bodiless one
//   2. no two of the eight build the same room — all 28 pairs above Design's
//      tenth, and the print itself refused if it could be passed by dilution
//   3. the effect **moves** and the absence does not. A static offset cannot see
//      a cancelled motion, so what is asserted is what travels
//   4. the eight are spread over one turn of *her own kernel*, so a physics that
//      folds does not make the ring of eight move as four identical pairs
//   5. the room's own centre carries no light, while the ring around it carries
//      all of it — the binding condition's third clause, read as a picture
//   6. the premise reverses as something the room **does**: the enclosure gives
//      way, the effect opens out, and the answer arrives where the absence was
//   7. every mark clears both the mesh cell and the stone's own grain
//   8. nothing in any of the eight mounts a solid
//   9. each of the eight is legible at both adaptations, by offscreen capture
//
// **What the synthetic rows prove, and what they do not.** Only Ring 2's sixteen
// ship in the binary; the Anaṅgas live in Airtable and a bundled copy would be
// the ghost roster law 1 exists to prevent. So every row below comes from
// ``HomesCorpus``, built out of real tattva vocabulary keyed off position, and a
// difference found between two of them is weaker evidence than it looks — they
// differ partly *because* position differs. The value is in the shape of a
// failure, and in the checks that do not depend on the rows at all.
@MainActor
final class BodilessRoomTests: XCTestCase {

    private static let seats = 45...52

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    private func built(_ position: Int) throws -> (room: HomeRoom, mechanism: BodilessRoom) {
        let entry = try XCTUnwrap(rooms().first { $0.row.position == position },
                                  "khaḍgamālā \(position) did not resolve")
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? BodilessRoom,
                                      "khaḍgamālā \(position) is not a bodiless room")
        return (entry.room, mechanism)
    }

    /// The figure one of the eight is laid out on, at one instant.
    private func figure(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: BodilessRoom.ring,
                                  spread: BodilessRoom.effectRing * 2,
                                  part: BodilessRoom.effectSize / 2,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    // MARK: - 1 · each of the eight reaches her own room, by position

    /// **The dispatch is decided by position and by nothing else.**
    ///
    /// Design's `BY_NAME` keys four of its eight authored rooms with spellings
    /// that match no card, and in its own shipped Axis those four fall silently
    /// through to the grammar with no test able to see it. The outer climb is
    /// reached through ``OuterRings/outerRoom(_:)`` off an archetype that
    /// ``HomeGrammar/archetype(ring:position:)`` read from her ring and her
    /// position, and this is the check Design lacked — asked from both ends.
    func testEachAnangaReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, 3)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "BodilessRoom") }),
                       "an Anaṅga is standing in somebody else's room")

        // …and nobody outside the third āvaraṇa reaches a bodiless one.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is BodilessRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a bodiless room without standing in the third āvaraṇa")

        // Her turn of the eight is Design's own, and no two of them share one.
        let phases = rooms().compactMap { entry -> Double? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return reading.phase
        }
        XCTAssertEqual(phases.count, 8)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 8,
                       "two of the eight take the same turn of the eight")
    }

    // MARK: - 2 · no two of the eight build the same room

    /// Design's own question, asked of all 28 pairs: *could this room belong to
    /// any other Śakti?*
    func testNoTwoAnangasBuildTheSameRoom() {
        // Ten slots, not the helper's sixteen: this room stands eight effects
        // around an absence and its reversal makes one mark, so ten is exactly
        // what a bodiless room carries. Six empty slots in every print would be
        // six more components that read alike in all eight rooms.
        let seats = OuterRingFingerprint.ring(3, HomesCorpus.resolvedRooms(),
                                              slots: BodilessRoom.effects + 2)
        XCTAssertEqual(seats.count, 8)

        var closest = (1.0, 0, 0)
        for (index, one) in seats.enumerated() {
            for other in seats[(index + 1)...] {
                let d = OuterRingFingerprint.divergence(one.print, other.print)
                if d < closest.0 { closest = (d, one.position, other.position) }
                XCTAssertGreaterThan(d, OuterRingFingerprint.threshold,
                                     """
                                     khaḍgamālā \(one.position) and \(other.position) are \
                                     \(String(format: "%.3f", d)) apart on the geometric \
                                     fingerprint, under Design's tenth. Two sisters are standing \
                                     in one room.
                                     """)
            }
        }
        print("RING3_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        // …and the measure cannot be passed by dilution.
        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all eight rooms. A print that is mostly padding passes by dilution.
                          """)
    }

    // MARK: - 3 · what moves, and what does not

    /// **A static offset cannot detect a cancelled motion, so this asserts what
    /// travels.**
    ///
    /// The eight effects carry her physics; the absence is the still point they
    /// stand around, and its stillness is what makes the classifier read it as a
    /// compaction. Both halves are asserted: the ring moves over the stay (for
    /// every physics that moves at all), and the centre does not move at any
    /// instant of it.
    func testTheEffectMovesAndTheCentreDoesNot() throws {
        var moved = 0
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? BodilessRoom,
                  let read = figure(room, at: 0) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let still = HomeGrammar.stillKinds.contains(mechanism.physics)

            // The absence: the same point at every moment of the stay, against a
            // stage that is itself fixed, so this reads the room rather than the
            // mount's own travel.
            let centres = [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                           HomeMemory.secondAdaptationEnd].map { t in
                mechanism.place(index: BodilessRoom.absenceIndex, at: t,
                                figure: read.figure, stage: read.stage, material: read.material)
            }
            XCTAssertEqual(Set(centres.map { "\($0.at.u)|\($0.at.v)|\($0.into)" }).count, 1,
                           "khaḍgamālā \(row.position): the absence moved. It is the still point")

            // The ring: at least one of the eight stands somewhere else a moment
            // later, unless her physics is one that never moves at all.
            let travelled = (0..<BodilessRoom.effects).contains { index in
                let here = mechanism.place(index: index, at: 0, figure: read.figure,
                                           stage: read.stage, material: read.material)
                let later = mechanism.place(index: index, at: OuterRings.readOver,
                                            figure: read.figure, stage: read.stage,
                                            material: read.material)
                return here != later
            }
            if still {
                XCTAssertFalse(travelled,
                               "khaḍgamālā \(row.position) moves on \(mechanism.physics.rawValue), which does not move")
            } else {
                moved += 1
                XCTAssertTrue(travelled,
                              """
                              khaḍgamālā \(row.position)'s eight effects do not move across a \
                              quarter of the first adaptation. Her physics is \
                              \(mechanism.physics.rawValue) and the room is not carrying it.
                              """)
            }
        }
        XCTAssertGreaterThanOrEqual(moved, 6,
                                    "too few of the eight carry a physics that moves for this to prove anything")
    }

    // MARK: - 4 · the eight are spread over one turn of her own kernel

    /// **Design's `ph + i / 8` is an identity for half the kernel's kinds.**
    ///
    /// Their terms are all `|sin|`, whose period is half a turn of phase, so
    /// petals `i` and `i + 4` come back the same number and a ring of eight moves
    /// as four identical pairs. ``CrossingRoom`` found it in a ring of two halves;
    /// this is the same finding in a ring of eight, and
    /// ``OuterRings/spread(index:of:kind:)`` is the answer.
    ///
    /// Both limbs are asserted, because the fix must not have cost Design's
    /// number where his number said something.
    func testTheEightAreSpreadOverOneTurnOfHerOwnKernel() {
        let folding = HomePhysics.allCases.filter { kind in
            !HomeGrammar.stillKinds.contains(kind)
                && HomeGrammar.counterPhase(of: kind) != 0.5
        }
        XCTAssertFalse(folding.isEmpty, "no kind folds — the finding this guards has gone")

        for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
            var seen: Set<String> = []
            for index in 0..<BodilessRoom.effects {
                let phase = OuterRings.spread(index: index, of: BodilessRoom.effects, kind: kind)
                let offsets = stride(from: 0.0, through: 40.0, by: 2.5).map { t -> String in
                    let d = HomeGrammar.displace(kind, time: t, phase: phase, amplitude: 1)
                    return String(format: "%.6f|%.6f|%.6f", d.x, d.y, d.z)
                }
                seen.insert(offsets.joined(separator: ";"))
            }
            XCTAssertEqual(seen.count, BodilessRoom.effects,
                           """
                           \(kind.rawValue): only \(seen.count) of the eight effects move \
                           differently. A ring of eight is moving as fewer than eight.
                           """)
        }

        // …and where a half turn already said something, Design's own `i / n` is
        // untouched, to the last bit.
        for kind in HomePhysics.allCases where HomeGrammar.counterPhase(of: kind) == 0.5 {
            for index in 0..<BodilessRoom.effects {
                XCTAssertEqual(OuterRings.spread(index: index, of: BodilessRoom.effects, kind: kind),
                               Double(index) / Double(BodilessRoom.effects),
                               accuracy: 0,
                               "\(kind.rawValue) no longer carries Design's own `i / n`")
            }
        }
    }

    // MARK: - 5 · the centre holds nothing, and the ring holds all the light

    /// **The room's light comes from a point that visibly holds nothing.**
    ///
    /// Design's own sentence for this ring, and here it is arithmetic rather than
    /// an authored effect: ``RoomMaterial/emission(at:)`` multiplies a mark's glow
    /// by how far that mark actually moved the material, so a mark with no glow
    /// contributes nothing at any depth. The absence carries none; the eight
    /// effects carry all there is; and the ember the room is lit by stands at the
    /// absence's own point (``RoomUnits/emberPoint(for:)``).
    ///
    /// Read at the first adaptation, where the second has not begun and the only
    /// marks in the room are the room's own. Her attribute is not in this
    /// reading — see ``OuterRingStage/marks(room:at:)``.
    func testTheCentreOfHerRoomCarriesNoLightOfItsOwn() throws {
        for (row, room) in rooms() {
            let t = HomeMemory.firstAdaptation
            let marks = OuterRingStage.marks(room: room, at: t)
            XCTAssertEqual(marks.count, BodilessRoom.effects + 1,
                           "khaḍgamālā \(row.position) is not eight effects and an absence")

            let absence = marks[BodilessRoom.absenceIndex]
            XCTAssertEqual(absence.glow, 0,
                           "khaḍgamālā \(row.position)'s centre is lit. It holds nothing")
            XCTAssertEqual(absence.verb, .compaction,
                           """
                           khaḍgamālā \(row.position)'s centre reads as \(absence.verb.rawValue). \
                           The still point classifies as a compaction — the mark of something that \
                           bore down without moving — and nothing here assigns it.
                           """)
            for effect in marks.prefix(BodilessRoom.effects) {
                XCTAssertGreaterThan(effect.glow, 0,
                                     "khaḍgamālā \(row.position) has an unlit effect; the ring carries the light")
            }

            // …and in the material itself: the centre is dark while the ring
            // around it is not.
            var material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            material.receive(marks)
            let centre = absence.at
            let atCentre = material.emission(at: centre)
            let onTheRing = marks.prefix(BodilessRoom.effects)
                .map { material.emission(at: $0.at) }
                .max() ?? 0
            XCTAssertLessThan(atCentre, 0.01,
                              "khaḍgamālā \(row.position): the middle of her room is lit at \(atCentre)")
            XCTAssertGreaterThan(onTheRing, 0.05,
                                 "khaḍgamālā \(row.position): the ring around the absence is not lit either")
        }
    }

    // MARK: - 6 · the premise reverses, as something the room does

    /// *The effect was the only body.* Three things happen and none of them is a
    /// word in a label: the enclosure gives way, the effect opens out, and the
    /// room's own answer arrives exactly where the absence stands.
    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd

            // The enclosure is standing where it began while the eye settles, and
            // has given way by the end.
            let wallSettling = OuterRingStage.stations(room: room, at: settling)[.wall] ?? 0
            let wallPast = OuterRingStage.stations(room: room, at: past)[.wall] ?? 0
            XCTAssertEqual(wallSettling, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s enclosure moved before the premise turned")
            XCTAssertLessThan(wallPast, 0,
                              """
                              khaḍgamālā \(row.position)'s enclosure never gives way. Design's \
                              `shell.material.opacity = 1 - b * 0.8` is the premise leaving.
                              """)

            // The effect opens out.
            let early = OuterRingStage.marks(room: room, at: settling)
            let late = OuterRingStage.marks(room: room, at: past)
            let answers = late.count - (BodilessRoom.effects + 1)
            let earlyRing = early.prefix(BodilessRoom.effects).map(\.reach).max() ?? 0
            let lateRing = late.dropFirst(answers).prefix(BodilessRoom.effects)
                .map(\.reach).max() ?? 0
            XCTAssertGreaterThan(lateRing, earlyRing * 1.2,
                                 """
                                 khaḍgamālā \(row.position)'s effect does not open out past the \
                                 second adaptation.
                                 """)

            // …and the room's own answer arrives where the absence is, and is far
            // larger than it — the absence overtaken rather than removed.
            XCTAssertEqual(answers, 1,
                           "khaḍgamālā \(row.position): the reversal made \(answers) marks, not one")
            let answer = try XCTUnwrap(late.first)
            let absence = late[answers + BodilessRoom.absenceIndex]
            XCTAssertEqual(answer.at.u, absence.at.u, accuracy: 1e-9)
            XCTAssertEqual(answer.at.v, absence.at.v, accuracy: 1e-9)
            XCTAssertGreaterThan(answer.reach, absence.reach * 3,
                                 """
                                 khaḍgamālā \(row.position): what held nothing was not overtaken. \
                                 The answer is \(answer.reach) against an absence of \(absence.reach).
                                 """)

            // The absence itself is exactly where it was — it is not withdrawn.
            let earlyAbsence = early[BodilessRoom.absenceIndex]
            XCTAssertEqual(absence.reach, earlyAbsence.reach, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s absence shrank. It is overtaken, not removed")
        }
    }

    // MARK: - 7 · a mark that can be seen

    /// **Both floors, in one check.** A mark narrower than one cell of the
    /// surface's mesh has no vertex inside it and is absent rather than faint; a
    /// mark shallower than the stone's own grain sits under the banding it was cut
    /// into and is never found by the raking key. Ring 1 and Ring 2 each paid for
    /// one of these with a render.
    func testEveryMarkClearsTheMeshCellAndTheStonesGrain() {
        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
                // The room's own nine, past whatever the reversal put in front of
                // them. The answering mark is the **spine's**, and
                // ``RoomReversal`` deliberately cuts it deeper than one mark's
                // worth — it is the surface's own travel rather than a mark in it
                // — so the ceiling below is asked of the marks this room makes.
                let mine = marks.dropFirst(max(0, marks.count - (BodilessRoom.effects + 1)))
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

    /// **An effect's stroke closes on the ring it stands on, and never across
    /// it** — the geometry the absence depends on, asserted directly rather than
    /// only through the emission it produces.
    ///
    /// A furrow and a crack run ``SurfaceAction/cutoffReaches`` of their own reach
    /// along the stroke, so the ring has to be at least that far out or the two
    /// effects whose stroke points at the middle write on the absence. Measured
    /// before the fix: 0.55 of full emission in the one place this room needs
    /// dark.
    func testAnEffectsStrokeClosesOnTheRingRatherThanAcrossIt() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? BodilessRoom,
                  let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let ring = mechanism.layout(figure: read.figure, material: read.material)
            XCTAssertGreaterThanOrEqual(ring.ring,
                                        OuterRings.clearance(ofReach: ring.reach) - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): an effect reaches \(ring.reach) \
                                        and stands \(ring.ring) from the absence, so its stroke runs \
                                        across the middle of her room. The one place that has to be \
                                        dark is being written on.
                                        """)
            XCTAssertGreaterThanOrEqual(ring.reach, RoomInscription.narrowestMark - 1e-12)
        }
    }

    // MARK: - 8 · nothing mounts a solid

    /// The renderer ruling's binding condition, asked of the whole ring: her
    /// layer holds the light in what was made and no geometry at all.
    func testNoBodilessRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               khaḍgamālā \(row.position) mounted \(scene.solidsInHerLayer) \
                               solids at \(t)s. An attribute is an action on the room's own \
                               material and never a free-standing lit object.
                               """)
            }
        }
    }

    // MARK: - 9 · legible at both adaptations

    /// Design's first verification check, on every one of the eight: neither
    /// black nor blown out nor flat, at both adaptations, by offscreen capture.
    func testEveryAnangaRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }
}
