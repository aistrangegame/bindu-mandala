import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - RING 4 · the fourteen Sampradāya Śaktis
//
// Khaḍgamālā 53–66, and the second ring of the outer climb. None of the fourteen
// is authored: every one of them is ``CosmicRoom``, tuned by her own row.
//
// What is held here:
//
//   1. each of the fourteen reaches her own room, by position, and nobody outside
//      the fourth āvaraṇa reaches a cosmic one
//   2. no two of the fourteen build the same room — all 91 pairs above Design's
//      tenth, and the print itself refused if it could be passed by dilution
//   3. the gesture **travels**, and outward. A static offset cannot see a
//      cancelled motion, so what is asserted is what moves: the fourteen are one
//      turn of *her own kernel* laid across the coil, no two of them alike, the
//      lag grows outward and the swing grows with it
//   4. the coil expands, and it expands **inside** the room: nothing is ever
//      clamped onto the edge of the material, at any moment of any stay
//   5. the centre empties and the shells take the room over — the light moves
//      outward, which is the archetype's own sentence read as a picture
//   6. the premise reverses as something the room **does**: the working face
//      yields, the enclosure departs, and the reversal adds no mark because an
//      enclosure answers by moving
//   7. every mark clears the mesh cell and the stone's own grain
//   8. the coil winds the same way on every surface — the defect that ran a whole
//      procession backwards, asked of this one
//   9. nothing in any of the fourteen mounts a solid
//  10. each of the fourteen is legible at both adaptations, by offscreen capture
//  11. reduce motion arrives at the settled room, reversed, without animating
//
// **What the synthetic rows prove, and what they do not.** Only Ring 2's sixteen
// ship in the binary; the Sampradāyas live in Airtable and a bundled copy would be
// the ghost roster law 1 exists to prevent. So every row below comes from
// ``HomesCorpus``, built out of real tattva vocabulary keyed off position, and a
// difference found between two of them is weaker evidence than it looks — they
// differ partly *because* position differs. The value is in the shape of a
// failure, and in the checks that do not depend on the rows at all.
@MainActor
final class CosmicRoomTests: XCTestCase {

    private static let seats = 53...66

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    private func built(_ position: Int) throws -> (room: HomeRoom, mechanism: CosmicRoom) {
        let entry = try XCTUnwrap(rooms().first { $0.row.position == position },
                                  "khaḍgamālā \(position) did not resolve")
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? CosmicRoom,
                                      "khaḍgamālā \(position) is not a cosmic room")
        return (entry.room, mechanism)
    }

    /// The figure one of the fourteen is laid out on, at one instant.
    private func read(_ room: HomeRoom, _ mechanism: CosmicRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure, coil: CosmicRoom.Coil)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        let figure = mechanism.figure(on: material, bodyAltitude: stage.placement.bodyAltitude)
        return (stage, material, figure, mechanism.coil(figure: figure, material: material))
    }

    /// Her own marks, at one instant — the mechanism's, with her attribute left
    /// out (``OuterRingStage/marks(room:at:)``).
    private func marks(_ room: HomeRoom, at t: TimeInterval) -> [SurfaceAction] {
        OuterRingStage.marks(room: room, at: t)
    }

    // MARK: - 1 · each of the fourteen reaches her own room, by position

    /// **The dispatch is decided by position and by nothing else.**
    ///
    /// Design's `BY_NAME` keys four of its eight authored rooms with spellings
    /// that match no card, and in its own shipped Axis those four fall silently
    /// through to the grammar with no test able to see it. The outer climb is
    /// reached through ``OuterRings/outerRoom(_:)`` off an archetype that
    /// ``HomeGrammar/archetype(ring:position:)`` read from her ring and her
    /// position, and this is the check Design lacked — asked from both ends.
    func testEachSampradayaReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, CosmicRoom.ring)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "CosmicRoom") }),
                       "a Sampradāya is standing in somebody else's room")

        // …and nobody outside the fourth āvaraṇa reaches a cosmic one.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is CosmicRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a cosmic room without standing in the fourth āvaraṇa")

        // Her turn of the fourteen is Design's own, and no two of them share one.
        let phases = rooms().compactMap { entry -> Double? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return reading.phase
        }
        XCTAssertEqual(phases.count, CosmicRoom.shells)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, CosmicRoom.shells,
                       "two of the fourteen take the same turn of the fourteen")
    }

    // MARK: - 2 · no two of the fourteen build the same room

    /// Design's own question, asked of all 91 pairs: *could this room belong to
    /// any other Śakti?*
    func testNoTwoSampradayasBuildTheSameRoom() {
        // Fifteen slots, not the helper's sixteen: this room makes exactly the
        // centre and the fourteen shells, and its reversal makes no mark at all,
        // because an enclosure answers by moving. A sixteenth slot in every print
        // would be one more component that reads alike in all fourteen rooms.
        let seats = OuterRingFingerprint.ring(CosmicRoom.ring, HomesCorpus.resolvedRooms(),
                                              slots: CosmicRoom.markCount)
        XCTAssertEqual(seats.count, CosmicRoom.shells)

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
        print("RING4_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        // …and the measure cannot be passed by dilution.
        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all fourteen rooms. A print that is mostly padding passes by dilution.
                          """)
    }

    // MARK: - 3 · the gesture travels, and outward

    /// **A static offset cannot detect a cancelled motion, so this asserts what
    /// travels.**
    ///
    /// Three limbs, and each one is a way this room could be built and be still:
    /// the shells have to *move* at all (for every physics that moves), the
    /// fourteen have to move **differently** — Design's `t - i * 0.42` is a
    /// fortieth of a turn on the slow kinds and would make the fourteen one rigid
    /// body — and the swing has to grow **outward**, which is the direction the
    /// whole archetype is.
    func testTheGestureTravelsAndGrowsOutward() throws {
        var moved = 0
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? CosmicRoom,
                  let seen = read(room, mechanism, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let still = HomeGrammar.stillKinds.contains(mechanism.physics)

            // The centre: the same point at every moment of the stay, against a
            // stage that is itself fixed, so this reads the room rather than the
            // mount's own travel. It is the place the gesture started from.
            let hearts = [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                          HomeMemory.secondAdaptationEnd].map { t in
                mechanism.place(index: CosmicRoom.heartIndex, at: t, figure: seen.figure,
                                stage: seen.stage, material: seen.material)
            }
            XCTAssertEqual(Set(hearts.map { "\($0.at.u)|\($0.at.v)|\($0.into)" }).count, 1,
                           "khaḍgamālā \(row.position): the centre moved. It is where the gesture began")

            // The shells: at least one of the fourteen stands somewhere else a
            // moment later, unless her physics is one that never moves at all.
            let travelled = (0..<CosmicRoom.shells).contains { index in
                let here = mechanism.place(index: CosmicRoom.shellIndex(index), at: 0,
                                           figure: seen.figure, stage: seen.stage,
                                           material: seen.material)
                let later = mechanism.place(index: CosmicRoom.shellIndex(index),
                                            at: OuterRings.readOver, figure: seen.figure,
                                            stage: seen.stage, material: seen.material)
                return here != later
            }
            if still {
                XCTAssertFalse(travelled,
                               """
                               khaḍgamālā \(row.position) moves on \
                               \(mechanism.physics.rawValue), which does not move
                               """)
            } else {
                moved += 1
                XCTAssertTrue(travelled,
                              """
                              khaḍgamālā \(row.position)'s fourteen shells do not move across a \
                              quarter of the first adaptation. Her physics is \
                              \(mechanism.physics.rawValue) and the room is not carrying it.
                              """)
            }

            // The swing grows outward, on her own surface, whatever surface it is.
            var last = -1.0
            for index in 0..<CosmicRoom.shells {
                let swing = mechanism.travel(of: index, coil: seen.coil, material: seen.material)
                XCTAssertGreaterThan(swing, last,
                                     """
                                     khaḍgamālā \(row.position): shell \(index) swings \(swing) \
                                     against \(last) a shell further in. The gesture is shrinking \
                                     as it travels outward, which is this archetype backwards.
                                     """)
                last = swing
            }
        }
        XCTAssertGreaterThanOrEqual(moved, 10,
                                    "too few of the fourteen carry a physics that moves for this to prove anything")
    }

    /// **The fourteen are one turn of her own kernel, laid across the coil.**
    ///
    /// Design's `ph + i / n` is an identity for the kinds whose terms are all
    /// `|sin|`, and ``OuterRings/spread(index:of:kind:)`` is the answer. What this
    /// ring adds is the **sign**: the lag is subtracted, so the outer shell is
    /// doing what the inner shell did, and it grows outward.
    func testTheFourteenAreOneTurnOfHerOwnKernelLaidOutward() throws {
        for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
            var seen: Set<String> = []
            var last = -1.0
            for index in 0..<CosmicRoom.shells {
                let lag = OuterRings.spread(index: index, of: CosmicRoom.shells, kind: kind)
                XCTAssertGreaterThan(lag, last,
                                     "\(kind.rawValue): the lag does not grow outward at shell \(index)")
                last = lag
                let offsets = stride(from: 0.0, through: 40.0, by: 2.5).map { t -> String in
                    let d = HomeGrammar.displace(kind, time: t, phase: -lag, amplitude: 1)
                    return String(format: "%.6f|%.6f|%.6f", d.x, d.y, d.z)
                }
                seen.insert(offsets.joined(separator: ";"))
            }
            XCTAssertEqual(seen.count, CosmicRoom.shells,
                           """
                           \(kind.rawValue): only \(seen.count) of the fourteen shells move \
                           differently. The gesture is arriving at fewer than fourteen distances.
                           """)
        }

        // …and in the room itself, the shells run behind one another rather than
        // ahead — the lag is subtracted, which is a wave going out.
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? CosmicRoom else {
                return XCTFail("khaḍgamālā \(row.position) is not a cosmic room")
            }
            guard !HomeGrammar.stillKinds.contains(mechanism.physics) else { continue }
            for index in 1..<CosmicRoom.shells {
                XCTAssertGreaterThan(mechanism.lag(of: index), mechanism.lag(of: index - 1),
                                     "khaḍgamālā \(row.position): shell \(index) is not behind the one inside it")
            }
        }
    }

    // MARK: - 4 · the coil expands, and it expands inside the room

    /// **Design's own thread records this ring's rooms expanding past the frame
    /// and going black at depth.** So the coil is read off the picture rather than
    /// off Design's radii, and the figure is fitted for the coil it will have
    /// *grown into*. Both halves are asserted: it expands, and nothing it does
    /// ever reaches the edge of the material.
    func testTheCoilExpandsAndIsNeverClampedOntoTheEdge() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? CosmicRoom else {
                return XCTFail("khaḍgamālā \(row.position) is not a cosmic room")
            }
            for t in [0, 24, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                guard let seen = read(room, mechanism, at: t) else {
                    return XCTFail("khaḍgamālā \(row.position) did not lay out")
                }
                XCTAssertGreaterThan(seen.coil.outer, seen.coil.inner,
                                     """
                                     khaḍgamālā \(row.position): the coil does not expand. Two \
                                     shells inside one cell of the mesh are one shell.
                                     """)
                XCTAssertGreaterThanOrEqual(seen.coil.inner, OuterRings.narrowestMark - 1e-12,
                                            "khaḍgamālā \(row.position): the innermost shell stands on the middle of her room")

                for index in 0..<CosmicRoom.markCount {
                    let station = mechanism.station(index: index, at: t, figure: seen.figure,
                                                    stage: seen.stage, material: seen.material)
                    XCTAssertTrue((0...1).contains(station.u) && (0...1).contains(station.v),
                                  """
                                  khaḍgamālā \(row.position), mark \(index) at \(t)s stands at \
                                  (\(station.u), \(station.v)) and has been clamped onto the edge \
                                  of the material. The expansion has left the room.
                                  """)
                }
            }
        }
    }

    // MARK: - 5 · the centre empties and the shells take the room over

    /// **The light moves outward, which is the whole sentence.**
    ///
    /// At the first adaptation the centre is the brightest mark in her room and
    /// the shells are the dimmest. Past the second, the shells carry Design's
    /// `(1 + b * 0.8)` and the centre carries its own falling scale, and the
    /// innermost shell is brighter than the centre it came from. *The gesture had
    /// no centre to leave* — the light did not go out, it went outward.
    ///
    /// **The centre's beat has to be integrated out, and a handful of instants
    /// does not do it.** Design's own `0.2 * sin(t * 0.2)` is wider than half the
    /// `0.34` emptying, so a single instant can read either way — and *a scatter
    /// of instants is no better*, because five samples twenty seconds apart
    /// against a beat whose period is `2π / 0.2 ≈ 31.4` seconds is an aliased
    /// reading of a sine rather than a mean of one. Measured that way three of the
    /// fourteen — khaḍgamālā 60, 61 and 62, whose turns of the fourteen put the
    /// beat where the aliasing bites — reported the centre emptying by a fifth
    /// when it empties by a third.
    ///
    /// So each window is **exactly one period of her own beat**, sampled evenly:
    /// `N` points at `period / N` cancel a sine of that period to the last bit, at
    /// every one of the fourteen phases, so what is compared is the whole of the
    /// settling against the whole of the turn and the beat is not in the answer at
    /// all. The windows end at ``HomeMemory/holdEnd`` and at
    /// ``HomeMemory/secondAdaptationEnd`` — the last turn of the beat before the
    /// premise starts to reverse, and the last turn of it at the end of the stay.
    func testTheCentreEmptiesAndTheShellsTakeTheRoomOver() throws {
        /// One turn of Design's own `sin(t * 0.2)`.
        let beat = 2 * Double.pi / CosmicRoom.heartRate
        /// `count` moments ending at `end`, spread evenly across one beat.
        func aBeatEndingAt(_ end: TimeInterval, count: Int = 8) -> [TimeInterval] {
            (0..<count).map { end - beat * Double(count - 1 - $0) / Double(count) }
        }
        let settling = aBeatEndingAt(HomeMemory.holdEnd)
        let past = aBeatEndingAt(HomeMemory.secondAdaptationEnd)

        for (row, room) in rooms() {
            func heart(_ moments: [TimeInterval]) -> Double {
                moments.map { marks(room, at: $0)[CosmicRoom.heartIndex].glow }
                    .reduce(0, +) / Double(moments.count)
            }
            func shell(_ index: Int, _ moments: [TimeInterval]) -> Double {
                moments.map { marks(room, at: $0)[CosmicRoom.shellIndex(index)].glow }
                    .reduce(0, +) / Double(moments.count)
            }

            XCTAssertLessThan(heart(past), heart(settling) * 0.8,
                              """
                              khaḍgamālā \(row.position): the centre did not empty. It is the one \
                              thing this archetype's second sentence is about.
                              """)
            XCTAssertGreaterThan(shell(0, past), shell(0, settling),
                                 "khaḍgamālā \(row.position): the shells did not take the room over")

            // While the eye settles, the centre is the brightest thing in her
            // room; past the turn, the innermost shell is brighter than it.
            let early = marks(room, at: HomeMemory.firstAdaptation)
            let late = marks(room, at: HomeMemory.secondAdaptationEnd)
            XCTAssertEqual(early.count, CosmicRoom.markCount)
            let brightest = early.dropFirst().map(\.glow).max() ?? 0
            XCTAssertGreaterThan(early[CosmicRoom.heartIndex].glow, brightest,
                                 """
                                 khaḍgamālā \(row.position): the centre is not the brightest mark \
                                 while the eye is settling. The gesture has to leave from somewhere.
                                 """)
            XCTAssertGreaterThan(late[CosmicRoom.shellIndex(0)].glow,
                                 late[CosmicRoom.heartIndex].glow,
                                 """
                                 khaḍgamālā \(row.position): the centre is still the brightest mark \
                                 past the second adaptation. The light never went outward.
                                 """)

            // …and the shells fall off outward the whole way, exactly as Design's
            // `(1 - i / 20)` does, so the coil reads as one gesture arriving
            // rather than as fourteen lamps.
            for index in 1..<CosmicRoom.shells {
                XCTAssertLessThan(late[CosmicRoom.shellIndex(index)].glow,
                                  late[CosmicRoom.shellIndex(index - 1)].glow,
                                  "khaḍgamālā \(row.position): shell \(index) is not dimmer than the one inside it")
            }

            // The centre keeps its footing while it loses its light: a mark that
            // grew shallower or narrower than the stone can carry would stop
            // being seen while it was still there, which is a different sentence.
            XCTAssertLessThanOrEqual(late[CosmicRoom.heartIndex].reach,
                                     early[CosmicRoom.heartIndex].reach + 1e-12)
            XCTAssertGreaterThanOrEqual(late[CosmicRoom.heartIndex].reach,
                                        OuterRings.narrowestMark - 1e-12)
            XCTAssertEqual(late[CosmicRoom.heartIndex].verb, .compaction,
                           """
                           khaḍgamālā \(row.position)'s centre reads as \
                           \(late[CosmicRoom.heartIndex].verb.rawValue). It does not travel, so the \
                           classifier reads it as a compaction and nothing here assigns it.
                           """)
        }
    }

    // MARK: - 6 · the premise reverses, as something the room does

    /// *The gesture had no centre to leave.* Three things happen and none of them
    /// is a word in a label: the working face yields, every shell opens out by its
    /// own share, and the enclosure departs — **without being marked**, because an
    /// enclosure answers by moving.
    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd
            let working = RoomUnits.surface(forBodyAltitude: room.bodyAltitude)

            let early = OuterRingStage.stations(room: room, at: settling)
            let late = OuterRingStage.stations(room: room, at: past)

            // Nothing has moved while the eye is still settling: that is what
            // makes the turn a turn.
            XCTAssertEqual(early[.wall] ?? 0, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s enclosure moved before the premise turned")
            XCTAssertEqual(early[working] ?? 0, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s working face moved before the premise turned")

            // The working face gives the gesture up…
            XCTAssertLessThan(late[working] ?? 0, 0,
                              """
                              khaḍgamālā \(row.position)'s working face never yields. Design's \
                              `heart.scale.setScalar(… - b * 0.34)` is the centre letting go.
                              """)
            // …and the enclosure goes the way the gesture is going.
            XCTAssertLessThan(late[.wall] ?? 0, 0,
                              """
                              khaḍgamālā \(row.position)'s enclosure never departs. The gesture has \
                              nothing to arrive at.
                              """)

            // Every shell opens out, and the outer ones further than the inner.
            let before = marks(room, at: settling)
            let after = marks(room, at: past)
            XCTAssertEqual(after.count, CosmicRoom.markCount,
                           """
                           khaḍgamālā \(row.position): the reversal added \
                           \(after.count - CosmicRoom.markCount) marks. A wall is not marked — it \
                           moves, and it moves through the stations.
                           """)
            for index in 0..<CosmicRoom.shells {
                let slot = CosmicRoom.shellIndex(index)
                XCTAssertGreaterThan(after[slot].reach, before[slot].reach,
                                     "khaḍgamālā \(row.position): shell \(index) does not open out")
            }
            let inner = after[CosmicRoom.shellIndex(0)].reach / before[CosmicRoom.shellIndex(0)].reach
            let outer = after[CosmicRoom.shellIndex(CosmicRoom.shells - 1)].reach
                / before[CosmicRoom.shellIndex(CosmicRoom.shells - 1)].reach
            XCTAssertGreaterThan(outer, inner,
                                 """
                                 khaḍgamālā \(row.position): the outermost shell does not take more \
                                 of the room over than the innermost. Design's own growth is \
                                 `0.22 + 0.03 * i`.
                                 """)
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
                for (index, mark) in marks(room, at: t).enumerated() where mark.reach > 0 {
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
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             deeper than one mark's worth. The room is not a quarry.
                                             """)
                    XCTAssertLessThanOrEqual(mark.reach, OuterRings.widestMark + 1e-12,
                                             "khaḍgamālā \(row.position), mark \(index) is wider than one mark may open")
                }
            }
        }
    }

    // MARK: - 8 · the coil winds the same way on every surface

    /// **A material axis inverted on one surface ran a whole procession
    /// backwards**, once, in this instrument. This room lays a figure out around a
    /// centre on whichever of three surfaces her altitude puts her, so it is asked
    /// directly: with her physics taken out of it, the coil winds the same way and
    /// grows outward on the floor, the canopy and the working face alike.
    ///
    /// Her physics is taken out by asking the question of a Śakti whose physics is
    /// stillness — ``HomePhysics/arrest`` — which is the one reading that leaves
    /// the layout and nothing else.
    func testTheCoilWindsTheSameWayOnEverySurface() {
        let still = HomeGrammar.Reading(
            position: 53, ring: CosmicRoom.ring, archetype: .cosmic, physics: .arrest,
            bodyAltitude: 0.5, altitude: 0, phase: 0, soundingMode: nil,
            matrkaLetterCount: nil, sourcingCorner: nil,
            label: HomeLabel(near: "", deep: ""))
        let mechanism = CosmicRoom(still)

        for surface in [RoomSurfaceKind.ground, .canopy, .face] {
            let material = RoomMaterial(surface: surface, seed: 53)
            let stage = RoomStage(placement: RoomUnits.placement(bodyAltitude: 0.5, chamberTime: 0),
                                  settling: 0, deep: 0,
                                  materials: [surface: material])
            let figure = mechanism.figure(on: material, bodyAltitude: 0.5)
            let coil = mechanism.coil(figure: figure, material: material)
            let centre = stage.placement.coordinate

            var lastRadius = -1.0
            var winding = 0.0
            var previous: (u: Double, v: Double)?
            for index in 0..<CosmicRoom.shells {
                let station = mechanism.station(index: CosmicRoom.shellIndex(index), at: 0,
                                                figure: figure, stage: stage, material: material)
                let u = station.u - centre.u, v = station.v - centre.v
                let radius = (u * u + v * v).squareRoot()
                XCTAssertGreaterThan(radius, lastRadius,
                                     "\(surface.rawValue): shell \(index) does not stand further out than the one inside it")
                lastRadius = radius
                if let previous {
                    let cross = previous.u * v - previous.v * u
                    if winding == 0 { winding = cross > 0 ? 1 : -1 }
                    XCTAssertEqual(cross > 0 ? 1.0 : -1.0, winding,
                                   "\(surface.rawValue): the coil reverses its winding at shell \(index)")
                }
                previous = (u, v)

                // …and the shell's own mark closes before the shell beside it,
                // wherever the stone is fine enough to carry that.
                XCTAssertGreaterThanOrEqual(mechanism.reach(of: index, coil: coil),
                                            OuterRings.narrowestMark - 1e-12)
            }
            XCTAssertEqual(winding, 1,
                           "\(surface.rawValue): the coil winds the other way round than its sisters")
        }
    }

    // MARK: - 9 · nothing mounts a solid

    /// The renderer ruling's binding condition, asked of the whole ring: her layer
    /// holds the light in what was made and no geometry at all.
    func testNoCosmicRoomMountsASolid() {
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

    /// Design's first verification check, on every one of the fourteen: neither
    /// black nor blown out nor flat, at both adaptations, by offscreen capture.
    /// This is the register that would have caught *"the room went black at
    /// depth"*, and it is the reason the coil is fitted to the picture it will
    /// have grown into.
    func testEverySampradayaRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }

    // MARK: - 11 · reduce motion

    /// **The still path arrives at the settled room, reversed, and never
    /// animates.** Asked of a Sampradāya rather than of the spine's own example,
    /// because what has to survive the still path in this ring is the *arrival*:
    /// a room posed once must be posed at the moment the gesture has already
    /// reached the walls and the centre has already emptied.
    func testReduceMotionReachesTheSettledRoomWithoutAnimating() throws {
        let entry = try XCTUnwrap(rooms().first, "no Sampradāya resolved")

        let view = RoomView(room: entry.room, clock: RoomClock(opening: 0), forceReduceMotion: true)
        let controller = UIHostingController(rootView: view.statusBarHidden(true))
        controller.view.backgroundColor = .black
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert + 1
        window.rootViewController = controller
        window.makeKeyAndVisible()
        defer { window.isHidden = true; window.rootViewController = nil }

        RunLoop.current.run(until: Date().addingTimeInterval(1.5))
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews {
                if let found = walk(child) { return found }
            }
            return nil
        }
        guard let root = controller.view, let sceneView = walk(root),
              let driver = sceneView.delegate as? RoomDriver else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertFalse(sceneView.isPlaying, "reduce motion must stop the scene clock")
        XCTAssertFalse(sceneView.rendersContinuously)
        let posed = driver.posesApplied
        RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        XCTAssertEqual(driver.posesApplied, posed,
                       "the room was posed again with reduce motion on")

        // And what it is still at is the settled room: the premise reversed, the
        // enclosure gone the way the gesture went, and the centre emptied.
        let settled = RoomPose(sceneTime: RoomClock.settled, room: entry.room)
        XCTAssertEqual(settled.deep, 1, accuracy: 1e-9)
        XCTAssertGreaterThan(driver.scene.enclosureRose, 0.05,
                             "the still room is not posed where a walker who stayed would have arrived")

        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? CosmicRoom)
        XCTAssertLessThan(mechanism.heartScale(at: RoomClock.settled, deep: 1),
                          mechanism.heartScale(at: RoomClock.settled, deep: 0),
                          "the still room stopped before the centre had emptied")
    }
}
