import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - RING 5 · the ten Kulottīrṇa Śaktis
//
// Khaḍgamālā 67–76, the givers. None of the ten is authored: every one of them
// is ``GivingRoom``, tuned by her own row.
//
// What is held here:
//
//   1. each of the ten reaches her own room, by position, and nobody outside the
//      fifth āvaraṇa reaches a giving one
//   2. no two of the ten build the same room — all 45 pairs above Design's tenth,
//      and the print itself refused if it could be passed by dilution
//   3. the gifts **cross** and the place they land in does not. A static offset
//      cannot see a cancelled motion, so what is asserted is what travels
//   4. the twelve are spread over one turn of *her own kernel*, so a physics that
//      folds does not make the flight drift as six identical pairs
//   5. the light is in the crossing and not in what landed — nought at both ends
//      of a crossing, and the landing lit and deepest instead
//   6. the premise reverses as **what the giving left behind**, never as the
//      giving undone: the gifts keep arriving, and the place they land in opens
//      out and goes dark until the ground carries it
//   7. every mark clears both the mesh cell and the stone's own grain
//   8. nothing in any of the ten mounts a solid
//   9. each of the ten is legible at both adaptations, by offscreen capture
//  10. a gift beyond the material is not a mark, because there is nothing there
//      to mark — and nothing is clamped onto the rim instead
//  11. a crossing is read over less than itself, so the classifier sees the
//      crossing rather than the cycle wrapping
//
// **What the synthetic rows prove, and what they do not.** Only Ring 2's sixteen
// ship in the binary; the Kulottīrṇās live in Airtable and a bundled copy would
// be the ghost roster law 1 exists to prevent. So every row below comes from
// ``HomesCorpus``, built out of real tattva vocabulary keyed off position, and a
// difference found between two of them is weaker evidence than it looks — they
// differ partly *because* position differs. The value is in the shape of a
// failure, and in the checks that do not depend on the rows at all.
@MainActor
final class GivingRoomTests: XCTestCase {

    private static let seats = 67...76

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    /// The figure one of the ten is laid out on, at one instant.
    private func figure(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: GivingRoom.ring,
                                  spread: GivingRoom.receivingRadius * 2,
                                  part: GivingRoom.giftSize / 2,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    /// Everything one of the ten does to every surface at one instant — the
    /// mechanism's own dictionary rather than one surface of it, because this
    /// room's premise and its answer stand on two different ones.
    private func work(_ room: HomeRoom, at t: TimeInterval) -> [RoomSurfaceKind: [SurfaceAction]] {
        guard let mechanism = RoomMechanisms.forRoom(room) else { return [:] }
        return mechanism.actions(at: t, stage: OuterRingStage.stage(room: room, at: t))
    }

    /// The place the gifts land in — the **last** mark the room makes on her own
    /// surface, because ``GivingRoom`` appends it after the flight and whatever
    /// the reversal put in front of them.
    private func landing(_ room: HomeRoom, at t: TimeInterval) -> SurfaceAction? {
        OuterRingStage.marks(room: room, at: t).last
    }

    /// The flight: every mark on her own surface except the landing and except
    /// whatever the reversal opened before them.
    private func flight(_ room: HomeRoom, at t: TimeInterval) -> [SurfaceAction] {
        let marks = OuterRingStage.marks(room: room, at: t)
        // The reversal's own mark, where it lands on the same surface, is first.
        let answering = Swift.max(0, marks.count - countOfMine(room, at: t))
        return Array(marks.dropFirst(answering).dropLast())
    }

    /// How many of the marks on her own surface are this room's own.
    private func countOfMine(_ room: HomeRoom, at t: TimeInterval) -> Int {
        guard let mechanism = RoomMechanisms.forRoom(room) as? GivingRoom,
              let read = figure(room, at: t) else { return 0 }
        var mine = 1 // the landing
        for index in 0..<GivingRoom.gifts {
            let u = GivingRoom.crossed(index: index, at: t)
            let here = mechanism.place(index: index, crossed: u, at: t,
                                       figure: read.figure, stage: read.stage,
                                       material: read.material)
            if GivingRoom.inTheRoom(here) { mine += 1 }
        }
        return mine
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
    func testEachKulottirnaReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, 5)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "GivingRoom") }),
                       "a Kulottīrṇā is standing in somebody else's room")

        // …and nobody outside the fifth āvaraṇa reaches a giving one.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is GivingRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a giving room without standing in the fifth āvaraṇa")

        // Her turn of the ten is Design's own, and no two of them share one.
        let phases = rooms().compactMap { entry -> Double? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return reading.phase
        }
        XCTAssertEqual(phases.count, 10)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 10,
                       "two of the ten take the same turn of the ten")
    }

    // MARK: - 2 · no two of the ten build the same room

    /// Design's own question, asked of all 45 pairs: *could this room belong to
    /// any other Śakti?*
    func testNoTwoKulottirnasBuildTheSameRoom() {
        // Fourteen slots, not the helper's sixteen: a giving room stands a flight
        // of twelve and one place for them to land in, and the reversal's own
        // mark falls on the same surface for the sisters felt at the soles. Two
        // empty slots in every print would be two more components that read alike
        // in all ten rooms, which is the dilution the guard below exists for.
        let seats = OuterRingFingerprint.ring(5, HomesCorpus.resolvedRooms(),
                                              slots: GivingRoom.gifts + 2)
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
        print("RING5_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        // …and the measure cannot be passed by dilution.
        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all ten rooms. A print that is mostly padding passes by dilution.
                          """)
    }

    // MARK: - 3 · what crosses, and what does not

    /// **A static offset cannot detect a cancelled motion, so this asserts what
    /// travels.**
    ///
    /// The whole premise of this ring is that something arrives, so the thing to
    /// assert is the arriving, in the two registers it happens in: a gift closes
    /// on the place it lands in, and it **bears further on the stone** every step
    /// of the way.
    ///
    /// The second is asserted on the placed part itself, because the fall is the
    /// arrival and nothing may cancel it. The first is asserted on
    /// ``GivingRoom/crossingRadius(at:figure:)`` rather than on where the gift
    /// ends up, and that is the room being honest about itself: Design's own
    /// amplitude swings a gift further than the landing is wide, so a Śakti whose
    /// physics is Mahat's widening does not come in on a neat spiral. She comes in
    /// on hers.
    ///
    /// And the other half: the place they land in is the same point at every
    /// moment of the stay, which is what makes the classifier read it as a
    /// compaction.
    func testTheGiftsCrossAndTheLandingDoesNot() throws {
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? GivingRoom,
                  let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let t = HomeMemory.firstAdaptation

            var closing = Double.infinity
            for step in 0...10 {
                let u = Double(step) / 10
                let radius = GivingRoom.crossingRadius(at: u, figure: read.figure)
                XCTAssertLessThan(radius, closing,
                                  """
                                  khaḍgamālā \(row.position): at \(u) of a crossing a gift stands \
                                  \(radius) from the place it lands in, no nearer than it was. \
                                  Nothing is arriving.
                                  """)
                closing = radius
            }

            for index in 0..<GivingRoom.gifts {
                var deepest = Double.infinity
                for step in 0...10 {
                    let u = Double(step) / 10
                    let here = mechanism.place(index: index, crossed: u, at: t,
                                               figure: read.figure, stage: read.stage,
                                               material: read.material)
                    XCTAssertLessThan(here.into, deepest,
                                      """
                                      khaḍgamālā \(row.position), gift \(index) is not bearing \
                                      further on the stone as it lands. Her physics has cancelled \
                                      the fall, and the fall is the arrival.
                                      """)
                    deepest = here.into
                }
            }

            // The landing: the same point at every moment of the stay, against a
            // stage that is itself fixed, so this reads the room rather than the
            // mount's own travel.
            let landings = [0, 30, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                            HomeMemory.secondAdaptationEnd].map { moment in
                mechanism.place(index: GivingRoom.receivingIndex, crossed: 1, at: moment,
                                figure: read.figure, stage: read.stage, material: read.material)
            }
            XCTAssertEqual(Set(landings.map { "\($0.at.u)|\($0.at.v)|\($0.into)" }).count, 1,
                           "khaḍgamālā \(row.position): the place they land in moved")

            // …and the room's own marks are somewhere else a reading later, which
            // is the crossing arriving in the material rather than only in the
            // arithmetic.
            let now = OuterRingStage.marks(room: room, at: t)
            let later = OuterRingStage.marks(room: room, at: t + GivingRoom.readOver)
            XCTAssertNotEqual(now, later,
                              """
                              khaḍgamālā \(row.position)'s room is identical a reading later. \
                              Nothing crossed.
                              """)
        }
    }

    // MARK: - 4 · the twelve are spread over one turn of her own kernel

    /// **Design's `ph + i / 12` is an identity for half the kernel's kinds.**
    ///
    /// Their terms are all `|sin|`, whose period is half a turn of phase, so
    /// gifts `i` and `i + 6` drift by the same number and a flight of twelve
    /// wobbles as six identical pairs. ``CrossingRoom`` found it in a ring of two
    /// halves and ``BodilessRoom`` in a ring of eight;
    /// ``OuterRings/spread(index:of:kind:)`` is the answer and this is it asked
    /// at twelve.
    ///
    /// Both limbs are asserted, because the fix must not have cost Design's
    /// number where his number said something.
    func testTheTwelveAreSpreadOverOneTurnOfHerOwnKernel() {
        let folding = HomePhysics.allCases.filter { kind in
            !HomeGrammar.stillKinds.contains(kind)
                && HomeGrammar.counterPhase(of: kind) != 0.5
        }
        XCTAssertFalse(folding.isEmpty, "no kind folds — the finding this guards has gone")

        for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
            var seen: Set<String> = []
            for index in 0..<GivingRoom.gifts {
                let phase = OuterRings.spread(index: index, of: GivingRoom.gifts, kind: kind)
                let offsets = stride(from: 0.0, through: 40.0, by: 2.5).map { t -> String in
                    let d = HomeGrammar.displace(kind, time: t, phase: phase, amplitude: 1)
                    return String(format: "%.6f|%.6f|%.6f", d.x, d.y, d.z)
                }
                seen.insert(offsets.joined(separator: ";"))
            }
            XCTAssertEqual(seen.count, GivingRoom.gifts,
                           """
                           \(kind.rawValue): only \(seen.count) of the twelve gifts drift \
                           differently. A flight of twelve is moving as fewer than twelve.
                           """)
        }

        // …and where a half turn already said something, Design's own `i / n` is
        // untouched, to the last bit.
        for kind in HomePhysics.allCases where HomeGrammar.counterPhase(of: kind) == 0.5 {
            for index in 0..<GivingRoom.gifts {
                XCTAssertEqual(OuterRings.spread(index: index, of: GivingRoom.gifts, kind: kind),
                               Double(index) / Double(GivingRoom.gifts),
                               accuracy: 0,
                               "\(kind.rawValue) no longer carries Design's own `i / n`")
            }
        }

        // **And the crossing's own `i / 12` is NOT the kernel's.** It is a spread
        // of arrival times along a linear cycle, where a twelfth of a turn is a
        // twelfth of a turn for every Śakti alive — so the twelve are staggered
        // evenly whatever her physics is, and the whole flight never stands at one
        // point of its crossing.
        for t in [0.0, 9.0, 37.0, HomeMemory.holdEnd] {
            let crossings = (0..<GivingRoom.gifts).map { GivingRoom.crossed(index: $0, at: t) }
            XCTAssertEqual(Set(crossings.map { String(format: "%.6f", $0) }).count,
                           GivingRoom.gifts,
                           "two gifts stand at the same point of the crossing at \(t)s")
            for value in crossings {
                XCTAssertGreaterThanOrEqual(value, 0)
                XCTAssertLessThan(value, 1)
            }
        }
    }

    // MARK: - 5 · the light is in the crossing, and what is left is the place

    /// **The giving disappears into the given.**
    ///
    /// Design's own `sin(π u)` on a gift's opacity, and here it is the archetype's
    /// whole sentence rather than a fade: a gift carries nothing as it enters and
    /// nothing as it lands, and what is left where it landed is not the gift but
    /// the place — which carries the room's own brightest light while the eye
    /// settles and the **deepest** mark the room makes.
    ///
    /// That last pair is also what keeps this ring's still centre from being
    /// ``BodilessRoom``'s. The Anaṅgā's absence carries no light and the least
    /// relief the stone can hold — it is where nothing happened. This one is where
    /// everything arrived, and the two are asserted apart.
    func testTheLightIsInTheCrossingAndWhatIsLeftIsThePlace() throws {
        // The crossing's own profile, which needs no row at all.
        XCTAssertEqual(GivingRoom.light(at: 0, settling: 1), 0, accuracy: 1e-12,
                       "a gift is lit as it enters. It arrives out of nothing")
        XCTAssertEqual(GivingRoom.light(at: 1, settling: 1), 0, accuracy: 1e-12,
                       "a gift is still lit where it lands. The giving disappears into the given")
        XCTAssertGreaterThan(GivingRoom.light(at: 0.5, settling: 0), 0)
        for step in 1...5 {
            let u = Double(step) / 10
            XCTAssertGreaterThan(GivingRoom.light(at: u, settling: 1),
                                 GivingRoom.light(at: u - 0.1, settling: 1))
            XCTAssertGreaterThan(GivingRoom.light(at: 1 - u, settling: 1),
                                 GivingRoom.light(at: 1 - u + 0.1, settling: 1))
        }

        for (row, room) in rooms() {
            let t = HomeMemory.firstAdaptation
            let marks = OuterRingStage.marks(room: room, at: t)
            let place = try XCTUnwrap(marks.last,
                                      "khaḍgamālā \(row.position) made no marks at all")

            XCTAssertEqual(place.verb, .compaction,
                           """
                           khaḍgamālā \(row.position)'s landing reads as \(place.verb.rawValue). \
                           A place that is being given to does not travel, and a part that bears \
                           on the stone without moving classifies as a compaction — nothing here \
                           assigns it.
                           """)
            XCTAssertGreaterThan(place.glow, 0,
                                 """
                                 khaḍgamālā \(row.position)'s landing carries no light. This is \
                                 where everything arrived, not a bodiless room's absence.
                                 """)
            for other in marks.dropLast() where other.reach > 0 {
                XCTAssertLessThan(other.glow, place.glow,
                                  """
                                  khaḍgamālā \(row.position): something in the flight is brighter \
                                  than the place it lands in. The light is in the crossing, and \
                                  what it is crossing toward is brighter still.
                                  """)
            }

            // …and in the material itself: the place is lit, and lit by what it
            // has been given rather than by an authored effect.
            var material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            material.receive(marks)
            XCTAssertGreaterThan(material.emission(at: place.at), 0.02,
                                 """
                                 khaḍgamālā \(row.position): the place the giving lands in is \
                                 dark in her own stone.
                                 """)
        }
    }

    // MARK: - 6 · the premise reverses, as what the giving left behind

    /// *The giving and the given are one.* Four things happen and none of them is
    /// a word in a label — and none of them is the giving being undone.
    ///
    /// The gifts **keep arriving**, and open out as they do it. The place they
    /// land in opens out and goes dark, keeping every bit of its depth, because a
    /// mark that grew shallower would stop being seen while it was still there.
    /// The canopy they were coming through gives way. And the room's own answer
    /// opens on the **ground**, which is what the place they were landing in has
    /// become.
    func testThePremiseReversesAsWhatTheGivingLeftBehind() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd

            // The canopy is standing where it began while the eye settles, and
            // has given way by the end.
            let canopySettling = OuterRingStage.stations(room: room, at: settling)[.canopy] ?? 0
            let canopyPast = OuterRingStage.stations(room: room, at: past)[.canopy] ?? 0
            XCTAssertEqual(canopySettling, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s canopy moved before the premise turned")
            XCTAssertLessThan(canopyPast, 0,
                              """
                              khaḍgamālā \(row.position): where the giving was coming through \
                              never gives way.
                              """)

            // The place they land in opens out, goes dark, and keeps its depth.
            let early = try XCTUnwrap(landing(room, at: settling))
            let late = try XCTUnwrap(landing(room, at: past))
            XCTAssertGreaterThan(late.reach, early.reach * 1.2,
                                 """
                                 khaḍgamālā \(row.position): the place the giving lands in does \
                                 not open out past the second adaptation.
                                 """)
            XCTAssertLessThan(late.glow, early.glow,
                              """
                              khaḍgamālā \(row.position): the place the giving lands in is still \
                              a bright point at the end of the stay. It becomes the ground.
                              """)
            XCTAssertEqual(late.depth, early.depth, accuracy: 1e-9,
                           """
                           khaḍgamālā \(row.position)'s landing changed depth. It is spread out, \
                           not taken away.
                           """)

            // **And the giving is not undone.** The flight is still crossing at
            // the end of the stay, and each of its marks is wider than it was.
            let flying = flight(room, at: past)
            XCTAssertGreaterThan(flying.count, 0,
                                 """
                                 khaḍgamālā \(row.position): nothing is arriving past the second \
                                 adaptation. The reversal is what the giving left behind, never \
                                 the giving stopped.
                                 """)
            let widestEarly = flight(room, at: settling).map(\.reach).max() ?? 0
            let widestLate = flying.map(\.reach).max() ?? 0
            XCTAssertGreaterThan(widestLate, widestEarly,
                                 """
                                 khaḍgamālā \(row.position)'s gifts do not open out past the \
                                 second adaptation.
                                 """)

            // …and the room's own answer opens on the ground.
            let ground = work(room, at: past)[.ground] ?? []
            let answer = try XCTUnwrap(ground.first,
                                       """
                                       khaḍgamālā \(row.position): nothing answers on the ground. \
                                       What was given is what he is standing on.
                                       """)
            XCTAssertEqual(answer.verb, .swell,
                           "khaḍgamālā \(row.position)'s answer reads as \(answer.verb.rawValue)")
            XCTAssertGreaterThan(answer.reach, late.reach,
                                 """
                                 khaḍgamālā \(row.position): the answer on the ground is smaller \
                                 than the place it came from.
                                 """)
            XCTAssertTrue((work(room, at: settling)[.ground] ?? []).isEmpty
                            || RoomUnits.surface(forBodyAltitude: room.bodyAltitude) == .ground,
                          "khaḍgamālā \(row.position) answered before the premise turned")
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
            for t in [0, 17, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
                XCTAssertGreaterThan(marks.count, 1,
                                     "khaḍgamālā \(row.position) made \(marks.count) marks at \(t)s")
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
                // The room's own marks, past whatever the reversal put in front of
                // them. The answering mark is the **spine's**, and ``RoomReversal``
                // deliberately cuts it deeper than one mark's worth — it is the
                // surface's own travel rather than a mark in it.
                let mine = marks.suffix(countOfMine(room, at: t))
                for (index, mark) in mine.enumerated() where mark.reach > 0 {
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             deeper than one mark's worth. The room is not a quarry.
                                             """)
                    XCTAssertLessThanOrEqual(mark.reach, OuterRings.widestMark + 1e-12,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             wider than one mark of an outer room may open.
                                             """)
                }
            }
        }
    }

    // MARK: - 8 · nothing mounts a solid

    /// The renderer ruling's binding condition, asked of the whole ring: her
    /// layer holds the light in what was made and no geometry at all. It is the
    /// hard one for an archetype whose whole subject is a **thing arriving**, and
    /// it is why a gift here is the mark it makes rather than the sprite Design
    /// drew.
    func testNoGivingRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               khaḍgamālā \(row.position) mounted \(scene.solidsInHerLayer) \
                               solids at \(t)s. A gift is an action on the room's own material \
                               and never a free-standing lit object.
                               """)
            }
        }
    }

    // MARK: - 9 · legible at both adaptations

    /// Design's first verification check, on every one of the ten: neither black
    /// nor blown out nor flat, at both adaptations, by offscreen capture.
    func testEveryKulottirnaRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }

    // MARK: - 10 · a gift beyond the material is not a mark

    /// **Beyond the stone there is nothing to mark.**
    ///
    /// The flight is sized against the body and the arrival is what is brought
    /// into the picture, so on the room's small surfaces Design's hall overruns
    /// the stone and a gift is genuinely outside the room for part of its
    /// crossing. It is not clamped onto the rim: twelve gifts held against an edge
    /// are a heap, and a heap is the same heap in every room of the ring.
    ///
    /// Two things are asserted — that every mark the room makes is **on** the
    /// material, and that at least one of the ten has a gift that is not.
    func testAGiftBeyondTheMaterialIsNotAMark() throws {
        var overran = 0
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? GivingRoom else {
                return XCTFail("khaḍgamālā \(row.position) is not a giving room")
            }
            for t in [0, 11, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                for mark in OuterRingStage.marks(room: room, at: t) {
                    XCTAssertTrue((0...1).contains(mark.at.u) && (0...1).contains(mark.at.v),
                                  """
                                  khaḍgamālā \(row.position) marked \(mark.at.u), \(mark.at.v) at \
                                  \(t)s, which is past the edge of her own stone.
                                  """)
                }
                guard let read = figure(room, at: t) else { continue }
                let beyond = (0..<GivingRoom.gifts).filter { index in
                    !GivingRoom.inTheRoom(
                        mechanism.place(index: index,
                                        crossed: GivingRoom.crossed(index: index, at: t),
                                        at: t, figure: read.figure, stage: read.stage,
                                        material: read.material))
                }
                if !beyond.isEmpty { overran += 1 }
            }
        }
        XCTAssertGreaterThan(overran, 0,
                             """
                             not one of the ten has a gift outside her own room at any moment. \
                             Nothing is arriving from beyond anything — the flight has been \
                             squeezed inside the stone.
                             """)

        // …and the far edge of a crossing is outside the room wherever the stone
        // is one body across, which is the case that made the rule.
        let onAFace = rooms().first {
            RoomUnits.surface(forBodyAltitude: $0.room.bodyAltitude) == .face
        }
        let entry = try XCTUnwrap(onAFace, "no Kulottīrṇā is felt on a working face")
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? GivingRoom)
        let read = try XCTUnwrap(figure(entry.room, at: HomeMemory.firstAdaptation))
        let far = mechanism.place(index: 0, crossed: 0, at: HomeMemory.firstAdaptation,
                                  figure: read.figure, stage: read.stage, material: read.material)
        XCTAssertFalse(GivingRoom.inTheRoom(far),
                       """
                       khaḍgamālā \(entry.row.position) begins her crossing inside her own room. \
                       A Kulottīrṇā comes from beyond the clan.
                       """)
    }

    // MARK: - 11 · a crossing is read over less than itself

    /// **A window longer than the crossing reads the cycle wrapping.**
    ///
    /// ``OuterRings/readOver`` is a quarter of the first adaptation because her
    /// physics is slow. A gift is transported as well as drifted, and over
    /// fifteen and a half seconds it covers five sixths of its whole journey — so
    /// a gift a tenth of the way in would have its previous sample taken three
    /// quarters of the way down, and would read as travelling outward at speed.
    ///
    /// Three things are held. The window is shorter than a crossing. The sample a
    /// reading ago is never ahead of a gift on its own crossing — a crossing is a
    /// one-way journey, and a gift younger than one reading is read from the far
    /// edge it entered at rather than from where the *previous* gift was. And the
    /// consequence in the stone, which is the observable one: **nothing in the
    /// flight ever reads as a swell.**
    ///
    /// That last is the failure a wrapped window produces. A swell is a part
    /// drawn *up out of* the material; a gift only ever bears further into it, so
    /// a flight with a swell in it is a flight the classifier is reading
    /// backwards.
    func testACrossingIsReadOverLessThanItself() throws {
        XCTAssertLessThan(GivingRoom.readOver, GivingRoom.crossing / 2,
                          "a crossing is read over more than half of itself")
        XCTAssertGreaterThan(GivingRoom.readOver, 0)
        XCTAssertLessThanOrEqual(GivingRoom.readOver, OuterRings.readOver,
                                 "a gift is read over more than her physics is")
        XCTAssertLessThan(GivingRoom.crossedOver, 1)
        for index in 0..<GivingRoom.gifts {
            for t in [0.0, 6.0, 23.0, HomeMemory.firstAdaptation, HomeMemory.holdEnd] {
                let u = GivingRoom.crossed(index: index, at: t)
                XCTAssertLessThanOrEqual(max(0, u - GivingRoom.crossedOver), u,
                                         "gift \(index) is read from ahead of itself at \(t)s")
            }
        }

        for (row, room) in rooms() {
            for t in [0, 11, 29, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                for (index, mark) in flight(room, at: t).enumerated() {
                    XCTAssertNotEqual(mark.verb, .swell,
                                      """
                                      khaḍgamālā \(row.position), gift \(index) at \(t)s reads as \
                                      a swell — drawn up out of the stone. A gift only ever bears \
                                      further into it, so the classifier is reading the cycle \
                                      wrapping rather than the crossing.
                                      """)
                }
            }
        }
    }

    // MARK: - 12 · reduce motion

    /// **The still path arrives at the settled room, reversed, and never
    /// animates.**
    ///
    /// Asked of a Kulottīrṇā rather than of the spine's own example, because what
    /// has to survive the still path here is an archetype whose whole premise is
    /// **transport**: twelve gifts crossing in on a cycle. A room that is posed
    /// once has to be posed at a moment when the giving has already happened —
    /// not at the top of a cycle with the flight out beyond the stone and nothing
    /// in the room but the place they were going to land in.
    func testReduceMotionReachesTheSettledRoomWithoutAnimating() throws {
        let entry = try XCTUnwrap(rooms().first, "no Kulottīrṇā resolved")

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

        // And what it is still at is the settled room. **Not the enclosure** —
        // this archetype's premise is the canopy and its answer is the ground
        // (``HomeBecoming/archetype(_:)``), so a Kulottīrṇā's walls never move and
        // a check written against them would pass on a room that did nothing.
        // What is asked is what *this* reversal does.
        let settled = RoomPose(sceneTime: RoomClock.settled, room: entry.room)
        XCTAssertEqual(settled.deep, 1, accuracy: 1e-9)
        XCTAssertLessThan(OuterRingStage.stations(room: entry.room, at: RoomClock.settled)[.canopy] ?? 0,
                          0,
                          "the still room is not posed where a walker who stayed would have arrived")

        // …and the giving has happened. At the moment the still room stands at,
        // gifts are in the stone and the place they land in has opened past where
        // it began — the reversal being what the giving left behind rather than
        // the giving undone.
        let still = OuterRingStage.marks(room: entry.room, at: RoomClock.settled)
        let atRest = OuterRingStage.marks(room: entry.room, at: 0)
        XCTAssertGreaterThan(still.count, 1,
                             "the still room holds nothing but the place they were going to land in")
        let landed = try XCTUnwrap(still.last)
        XCTAssertGreaterThan(landed.reach, try XCTUnwrap(atRest.last).reach,
                             "the place they landed in did not open out. The giving was undone rather than left behind")
        XCTAssertEqual(landed.verb, .compaction,
                       "the place they land in reads as \(landed.verb.rawValue) in the still room")
    }
}
