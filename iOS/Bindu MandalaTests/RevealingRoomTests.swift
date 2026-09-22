import XCTest
@testable import Bindu_Mandala

// MARK: - RING 6 · the ten Nigarbha Śaktis
//
// Khaḍgamālā 77–86. None of the ten is authored: every one of them is
// ``RevealingRoom``, tuned by her own row.
//
// What is held here:
//
//   1. each of the ten reaches her own room, by position, and nobody outside the
//      sixth āvaraṇa reaches a revealing one
//   2. no two of the ten build the same room — all 45 pairs above Design's
//      tenth, and the print itself refused if it could be passed by dilution
//   3. **the figure does not change and the covering does** — this ring's own
//      claim, and the one thing no other room in the instrument says. The ten
//      are one depth and one light at every instant; the veil's light is the
//      only thing in the room with a clock. And they **move**, because a static
//      offset cannot see a cancelled motion
//   4. the ten are spread over one turn of *her own kernel*, so a physics that
//      folds does not make the ring of ten move as five identical pairs
//   5. **the veil obscures something that is still there** — the Design thread's
//      recorded defect for this ring, asserted from both ends: the veil is lit
//      while it is there, and what it lies over is lit the whole time
//   6. the premise reverses as something the room **does**: the enclosure that
//      was around him gives way and the canopy comes down to take the work over
//   7. the ten are buried at ten different depths, in Design's own order, and
//      even the deepest clears the stone's own grain
//   8. every mark clears both the mesh cell and the grain
//   9. nothing in any of the ten mounts a solid
//  10. each of the ten is legible at both adaptations, by offscreen capture
//
// **What the synthetic rows prove, and what they do not.** Only Ring 2's sixteen
// ship in the binary; the Nigarbha Śaktis live in Airtable and a bundled copy
// would be the ghost roster law 1 exists to prevent. So every row below comes
// from ``HomesCorpus``, built out of real tattva vocabulary keyed off position,
// and a difference found between two of them is weaker evidence than it looks —
// they differ partly *because* position differs. The value is in the shape of a
// failure, and in the checks that do not depend on the rows at all.
@MainActor
final class RevealingRoomTests: XCTestCase {

    private static let seats = 77...86

    /// Ten truths, one veil, and one mark the reversal makes. Twelve is exactly
    /// what a revealing room carries, so no slot is padding — the dilution
    /// ``OuterRingFingerprint/refusesDilution(_:)`` exists to catch.
    private static let slots = RevealingRoom.truths + 2

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    /// The figure one of the ten is laid out on, at one instant.
    private func figure(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: RevealingRoom.ring,
                                  spread: RevealingRoom.truthRing * 2,
                                  part: RevealingRoom.truthSize,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    /// The room's own marks at one instant, past whatever the reversal put in
    /// front of them. The answering mark lands on the **canopy** in this ring, so
    /// it is only in this list for a Śakti the canopy is already her working
    /// surface for — which is why it is counted rather than assumed.
    private func mine(_ room: HomeRoom, at t: TimeInterval) -> ArraySlice<SurfaceAction> {
        let marks = OuterRingStage.marks(room: room, at: t)
        return marks.dropFirst(max(0, marks.count - Self.slots + 1))
    }

    // MARK: - 1 · each of the ten reaches her own room, by position

    /// **The dispatch is decided by position and by nothing else.**
    ///
    /// Design's `BY_NAME` keys four of its eight authored rooms with spellings
    /// that match no card, and in its own shipped Axis those four fall silently
    /// through to the grammar with no test able to see it. The outer climb is
    /// reached through ``OuterRings/outerRoom(_:)`` off an archetype that
    /// ``HomeGrammar/archetype(ring:position:)`` read from her ring and her
    /// position, and this is the check Design lacked — asked from both ends.
    func testEachNigarbhaReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, 6)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "RevealingRoom") }),
                       "a Nigarbha Śakti is standing in somebody else's room")

        // …and nobody outside the sixth āvaraṇa reaches a revealing one.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is RevealingRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a revealing room without standing in the sixth āvaraṇa")

        // Her turn of the ten is Design's own, and no two of them share one.
        let phases = rooms().compactMap { entry -> Double? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return reading.phase
        }
        XCTAssertEqual(phases.count, 10)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 10,
                       "two of the ten take the same turn of the ten")

        // …and her words are the archetype's, which is the one line the walker
        // is ever given for this ring.
        for (row, _) in rooms() {
            let tag = HomeGrammar.tag(for: .revealing, position: row.position)
            XCTAssertEqual(tag.deep, "it was never hidden · you were the veil")
        }
    }

    // MARK: - 2 · no two of the ten build the same room

    /// Design's own question, asked of all 45 pairs: *could this room belong to
    /// any other Śakti?*
    func testNoTwoNigarbhasBuildTheSameRoom() {
        let seats = OuterRingFingerprint.ring(6, HomesCorpus.resolvedRooms(), slots: Self.slots)
        XCTAssertEqual(seats.count, 10)

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
        print("RING6_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        // …and the measure cannot be passed by dilution.
        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all ten rooms. A print that is mostly padding passes by dilution.
                          """)
    }

    // MARK: - 3 · the figure does not change, and the covering does

    /// **This ring's own claim, and no other room in the instrument makes it.**
    ///
    /// The ten are cut to their own depths at the first instant and nothing about
    /// them is a function of the clock — not their depth, not their reach, not
    /// their light. What has a clock is the veil, whose light falls by Design's
    /// own two terms and reaches nothing.
    ///
    /// Asserted across the whole stay rather than at two points, because a room
    /// that changed and came back would pass a two-point reading.
    func testWhatIsAlreadyHereDoesNotChangeAndTheVeilDoes() {
        let moments = Array(stride(from: 0.0, to: HomeMemory.secondAdaptationEnd, by: 12.0))
            + [HomeMemory.secondAdaptationEnd]
        for (row, room) in rooms() {
            var depths: [Set<String>] = Array(repeating: [], count: RevealingRoom.truths)
            var reaches: [Set<String>] = Array(repeating: [], count: RevealingRoom.truths)
            var glows: Set<String> = []
            var veilGlows: [Double] = []

            for t in moments {
                let marks = Array(mine(room, at: t))
                XCTAssertEqual(marks.count, RevealingRoom.truths + 1,
                               "khaḍgamālā \(row.position) is not ten and a veil at \(t)s")
                guard marks.count == RevealingRoom.truths + 1 else { continue }
                for index in 0..<RevealingRoom.truths {
                    depths[index].insert(String(format: "%.12f", marks[index].depth))
                    reaches[index].insert(String(format: "%.12f", marks[index].reach))
                    glows.insert(String(format: "%.12f", marks[index].glow))
                }
                veilGlows.append(marks[RevealingRoom.veilIndex].glow)
            }

            for index in 0..<RevealingRoom.truths {
                XCTAssertEqual(depths[index].count, 1,
                               """
                               khaḍgamālā \(row.position): what is already here changed depth \
                               across the stay (\(depths[index].count) values at mark \(index)). \
                               It was already here.
                               """)
                XCTAssertEqual(reaches[index].count, 1,
                               "khaḍgamālā \(row.position): mark \(index) changed reach across the stay")
            }
            XCTAssertEqual(glows.count, 1,
                           """
                           khaḍgamālā \(row.position): the ten carry \(glows.count) different \
                           lights across the stay. It was never hidden — the light does not move.
                           """)

            // …and the veil is the only thing in the room with a clock.
            XCTAssertGreaterThan(veilGlows.count, 3)
            for (before, after) in zip(veilGlows, veilGlows.dropFirst()) {
                XCTAssertLessThanOrEqual(after, before + 1e-12,
                                         "khaḍgamālā \(row.position): the veil thickened again")
            }
            XCTAssertGreaterThan(veilGlows.first ?? 0, 0.5,
                                 "khaḍgamālā \(row.position): the veil was already gone at the door")
            XCTAssertEqual(veilGlows.last ?? 1, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position): the veil never clears")
        }
    }

    /// **A static offset cannot detect a cancelled motion, so this asserts what
    /// travels.**
    ///
    /// The ten drift on her physics — a room with no physics in it is a room that
    /// could be anyone's — and the veil is the still skin they are under, which
    /// is what makes the classifier read it as a compaction.
    func testTheTenDriftAndTheVeilDoesNot() throws {
        var moved = 0
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? RevealingRoom,
                  let read = figure(room, at: 0) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let still = HomeGrammar.stillKinds.contains(mechanism.physics)

            let veils = [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                         HomeMemory.secondAdaptationEnd].map { t in
                mechanism.place(index: RevealingRoom.veilIndex, at: t,
                                figure: read.figure, stage: read.stage, material: read.material)
            }
            XCTAssertEqual(Set(veils.map { "\($0.at.u)|\($0.at.v)|\($0.into)" }).count, 1,
                           "khaḍgamālā \(row.position): the veil travelled. It is the still skin")

            let travelled = (0..<RevealingRoom.truths).contains { index in
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
                              khaḍgamālā \(row.position)'s ten do not move across a quarter of \
                              the first adaptation. Her physics is \(mechanism.physics.rawValue) \
                              and the room is not carrying it.
                              """)
            }

            // …and the veil's stillness is what the classifier reads, rather than
            // anything in the file saying so.
            let veil = Array(mine(room, at: HomeMemory.firstAdaptation))[RevealingRoom.veilIndex]
            XCTAssertEqual(veil.verb, .compaction,
                           """
                           khaḍgamālā \(row.position)'s veil reads as \(veil.verb.rawValue). A \
                           still skin classifies as a compaction — driven down and densified, \
                           with almost no relief — and nothing here assigns it.
                           """)
        }
        XCTAssertGreaterThanOrEqual(moved, 8,
                                    "too few of the ten carry a physics that moves for this to prove anything")
    }

    // MARK: - 4 · the ten are spread over one turn of her own kernel

    /// **Design's `ph + i / 10` is an identity for kinds whose terms are `|sin|`.**
    ///
    /// Their period is half a turn of phase, so parts `i` and `i + 5` come back
    /// the same number and a ring of ten moves as five identical pairs.
    /// ``CrossingRoom`` found it in a ring of two halves;
    /// ``OuterRings/spread(index:of:kind:)`` is the answer, and both limbs are
    /// asserted so the fix cannot have cost Design's number where his number said
    /// something.
    func testTheTenAreSpreadOverOneTurnOfHerOwnKernel() {
        for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
            var seen: Set<String> = []
            for index in 0..<RevealingRoom.truths {
                let phase = OuterRings.spread(index: index, of: RevealingRoom.truths, kind: kind)
                let offsets = stride(from: 0.0, through: 40.0, by: 2.5).map { t -> String in
                    let d = HomeGrammar.displace(kind, time: t, phase: phase, amplitude: 1)
                    return String(format: "%.6f|%.6f|%.6f", d.x, d.y, d.z)
                }
                seen.insert(offsets.joined(separator: ";"))
            }
            XCTAssertEqual(seen.count, RevealingRoom.truths,
                           """
                           \(kind.rawValue): only \(seen.count) of the ten move differently. A \
                           ring of ten is moving as fewer than ten.
                           """)
        }

        for kind in HomePhysics.allCases where HomeGrammar.counterPhase(of: kind) == 0.5 {
            for index in 0..<RevealingRoom.truths {
                XCTAssertEqual(OuterRings.spread(index: index, of: RevealingRoom.truths, kind: kind),
                               Double(index) / Double(RevealingRoom.truths),
                               accuracy: 0,
                               "\(kind.rawValue) no longer carries Design's own `i / n`")
            }
        }
    }

    // MARK: - 5 · the veil obscures something that is still there

    /// **The Design thread's recorded defect for this ring, asserted from both
    /// ends.**
    ///
    /// *Ring 6's veil was unlit, so it read as extinguished rather than as
    /// obscured. A veil must obscure something that is still there.*
    ///
    /// So: the veil carries more light than anything else in the room while it is
    /// there, and what it lies over carries light at every instant including the
    /// first. And in the material itself — the ten stand inside a lit field at
    /// the first instant, and stand in the dark by the end, having done nothing.
    func testTheVeilIsLitAndWhatItCoversIsStillThere() throws {
        for (row, room) in rooms() {
            let opening = Array(mine(room, at: 0))
            let veil = opening[RevealingRoom.veilIndex]
            XCTAssertGreaterThan(veil.glow, 0,
                                 """
                                 khaḍgamālā \(row.position)'s veil is unlit. An unlit veil does \
                                 not obscure — it extinguishes, and then there is nothing behind \
                                 it to reveal.
                                 """)
            for (index, truth) in opening.prefix(RevealingRoom.truths).enumerated() {
                XCTAssertGreaterThan(truth.glow, 0,
                                     "khaḍgamālā \(row.position): mark \(index) is unlit at the door. It was already here")
                XCTAssertGreaterThan(veil.glow, truth.glow,
                                     "khaḍgamālā \(row.position): the veil is dimmer than what it covers")
            }

            // …and in the stone: read at the **middle of the ring**, which is the
            // one place inside the veil where nothing is buried and where no
            // mark's stroke reaches (``RevealingRoom/layout(figure:material:)``).
            // Whatever is lit there is the covering and nothing else.
            guard let read = figure(room, at: 0) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let empty = read.stage.placement.coordinate

            func field(at t: TimeInterval) -> (onOne: Double, empty: Double) {
                var material = RoomMaterial(
                    surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                    seed: room.position)
                let marks = Array(mine(room, at: t))
                material.receive(marks)
                let onOne = marks.prefix(RevealingRoom.truths)
                    .map { material.emission(at: $0.at) }.max() ?? 0
                return (onOne, material.emission(at: empty))
            }

            let door = field(at: 0)
            XCTAssertGreaterThan(door.empty, door.onOne * 0.5,
                                 """
                                 khaḍgamālā \(row.position): the ten are not inside a lit field at \
                                 the door — \(door.empty) where nothing is buried against \
                                 \(door.onOne) on one of them. They are being revealed before the \
                                 veil has thinned.
                                 """)

            let past = field(at: HomeMemory.secondAdaptationEnd)
            XCTAssertGreaterThan(past.onOne, 0,
                                 "khaḍgamālā \(row.position): nothing is lit past the second adaptation")
            XCTAssertLessThan(past.empty, past.onOne * 0.1,
                              """
                              khaḍgamālā \(row.position): the field over the ten is still there \
                              past the second adaptation — \(past.empty) against \(past.onOne). \
                              The veil has not cleared.
                              """)
        }
    }

    // MARK: - 6 · the premise reverses, as something the room does

    /// *It was never hidden · you were the veil.* Two things happen and neither
    /// of them is a word in a label: the enclosure that was around him gives way,
    /// and the canopy comes down to take the work over.
    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd

            let wallSettling = OuterRingStage.stations(room: room, at: settling)[.wall] ?? 0
            let wallPast = OuterRingStage.stations(room: room, at: past)[.wall] ?? 0
            XCTAssertEqual(wallSettling, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s enclosure moved before the premise turned")
            XCTAssertLessThan(wallPast, 0,
                              """
                              khaḍgamālā \(row.position)'s enclosure never gives way. Design's \
                              `- b * 0.26` on the veil is the premise leaving.
                              """)

            let canopyPast = OuterRingStage.stations(room: room, at: past)[.canopy] ?? 0
            XCTAssertGreaterThan(canopyPast, 0,
                                 """
                                 khaḍgamālā \(row.position)'s canopy does not come down. What the \
                                 veil hid was overhead the whole time.
                                 """)

            // …and the answering material does something where the work moved to.
            let stage = OuterRingStage.stage(room: room, at: past)
            let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room))
            let answer = try XCTUnwrap(mechanism.actions(at: past, stage: stage)[.canopy]?.first,
                                       "khaḍgamālā \(row.position): nothing happened on the canopy")
            XCTAssertEqual(answer.verb, .swell,
                           """
                           khaḍgamālā \(row.position): the canopy reads as \(answer.verb.rawValue). \
                           Material coming toward the walker is a swell, and it is read from the \
                           travel rather than assigned.
                           """)
            XCTAssertGreaterThan(answer.reach, 0)

            // …and nothing that happened to the ten is what did it: they are the
            // same marks they were while the eye was still settling.
            let early = Array(mine(room, at: settling)).prefix(RevealingRoom.truths)
            let late = Array(mine(room, at: past)).prefix(RevealingRoom.truths)
            XCTAssertEqual(early.map(\.reach), late.map(\.reach))
            XCTAssertEqual(early.map(\.depth), late.map(\.depth))
            XCTAssertEqual(early.map(\.glow), late.map(\.glow))
        }
    }

    // MARK: - 7 · buried at ten different depths

    /// Design's `sin(i * 1.7) * 2.6`, read as a burial rather than as scatter:
    /// ten different depths in the stone, in Design's own order, and the deepest
    /// of them still above the banding it is cut into.
    func testTheTenAreBuriedAtTenDifferentDepths() throws {
        let burials = (0..<RevealingRoom.truths).map { RevealingRoom.burial($0) }
        XCTAssertEqual(Set(burials.map { String(format: "%.9f", $0) }).count, RevealingRoom.truths,
                       "two of the ten are buried at the same depth")
        for (index, burial) in burials.enumerated() {
            XCTAssertEqual(burial, (1 - sin(Double(index) * 1.7)) / 2, accuracy: 1e-12,
                           "the burial is no longer Design's own `sin(i * 1.7)`")
        }

        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            let marks = Array(mine(room, at: HomeMemory.firstAdaptation))
                .prefix(RevealingRoom.truths)
            let depths = marks.map(\.depth)
            XCTAssertEqual(Set(depths.map { String(format: "%.9f", $0) }).count,
                           RevealingRoom.truths,
                           """
                           khaḍgamālā \(row.position): \(Set(depths).count) distinct depths among \
                           the ten. They are buried at ten different depths, not at one.
                           """)
            // Design's order: the least buried stands proudest.
            let byBurial = zip(burials, depths).sorted { $0.0 < $1.0 }.map(\.1)
            XCTAssertEqual(byBurial, byBurial.sorted(by: >),
                           "khaḍgamālā \(row.position): a deeper burial is standing prouder of the stone")
            XCTAssertGreaterThan(depths.min() ?? 0, material.grainRelief,
                                 "khaḍgamālā \(row.position): the deepest-buried of the ten is under the grain")
        }
    }

    // MARK: - 8 · a mark that can be seen

    /// **Both floors, in one check.** A mark narrower than one cell of the
    /// surface's mesh has no vertex inside it and is absent rather than faint; a
    /// mark shallower than the stone's own grain sits under the banding it was
    /// cut into and is never found by the raking key. Ring 1 and Ring 2 each paid
    /// for one of these with a render.
    func testEveryMarkClearsTheMeshCellAndTheStonesGrain() {
        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
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
                // The room's own marks, past whatever the reversal put in front
                // of them. The answering mark is the **spine's**, and
                // ``RoomReversal`` deliberately cuts it deeper than one mark's
                // worth — it is the surface's own travel rather than a mark in it.
                for (index, mark) in mine(room, at: t).enumerated() where mark.reach > 0 {
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             deeper than one mark's worth. The room is not a quarry.
                                             """)
                }
            }
        }
    }

    /// **The veil lies over the whole figure**, which is the geometry every claim
    /// about obscuring depends on: a veil that left the outermost of the ten
    /// standing clear of it would be obscuring nine and revealing the tenth from
    /// the first instant. Asserted against the veil's own **flat bottom** rather
    /// than against its bare reach, because a compaction's edge falls away and a
    /// scrim's does not.
    func testTheVeilLiesOverTheWholeFigure() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? RevealingRoom,
                  let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let plan = mechanism.layout(figure: read.figure, material: read.material)
            XCTAssertGreaterThanOrEqual(plan.veil, plan.ring + plan.reach - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): the veil reaches \(plan.veil) \
                                        and the figure stands out to \(plan.ring + plan.reach). \
                                        Part of what is already here was never covered.
                                        """)
            XCTAssertGreaterThanOrEqual(plan.veil * RevealingRoom.veilFlat,
                                        plan.ring + plan.reach - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): the ten stand out on the veil's \
                                        falloff rather than under it.
                                        """)
            XCTAssertLessThanOrEqual(plan.veil, RoomReversal.answeringSpan + 1e-12,
                                     "khaḍgamālā \(row.position): the veil is wider than the widest a mark may be")

            // …and nothing is written in the middle of the room, which is where
            // nothing is buried. A furrow and a crack run
            // ``SurfaceAction/cutoffReaches`` of their reach along the stroke.
            XCTAssertGreaterThanOrEqual(plan.ring,
                                        OuterRings.clearance(ofReach: plan.reach) - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): a mark reaches \(plan.reach) \
                                        and stands \(plan.ring) from the middle, so its stroke runs \
                                        across the one place in her room with nothing under it.
                                        """)

            // …and the same floor keeps the ten off one another.
            let apart = 2 * plan.ring * sin(.pi / Double(RevealingRoom.truths))
            XCTAssertGreaterThanOrEqual(apart, 2 * plan.reach - 1e-12,
                                        """
                                        khaḍgamālā \(row.position): the ten stand \(apart) apart \
                                        with a reach of \(plan.reach) each. They are writing on \
                                        one another.
                                        """)
        }
    }

    // MARK: - 9 · nothing mounts a solid

    /// The renderer ruling's binding condition, asked of the whole ring: her
    /// layer holds the light in what was made and no geometry at all.
    func testNoRevealingRoomMountsASolid() {
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

    // MARK: - 10 · legible at both adaptations

    /// Design's first verification check, on every one of the ten: neither black
    /// nor blown out nor flat, at both adaptations, by offscreen capture.
    func testEveryNigarbhaRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }
}
