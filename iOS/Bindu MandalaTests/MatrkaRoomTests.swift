import XCTest
@testable import Bindu_Mandala

// MARK: - RING 1 · PASS TWO · the eight Mātṛkās
//
// Khaḍgamālā 11–18. Design authored none of these by hand, so all eight are the
// grammar speaking — and they are the one family in the instrument with a fifth
// channel: **a count**.
//
//     const n = 5 + ((card.pos - 11) % 4) * 3;   // how many letters her row governs
//
// which over the eight seats is 5, 8, 11, 14, 5, 8, 11, 14. What is held here:
//
//   1. all eight reach the Mātṛkā's room by position, with her own count
//   2. **one letter is at the front of the speaking at any instant**, every
//      letter takes its turn, and the rate it hands on at is her own count's —
//      the family's signature, and the sharpest thing in Ring 1
//   3. the letters grow until they are touching and stop there, so there are
//      still that many of them when the premise has turned
//   4. the column of voice is this room's **only** answer
//   5. every mark stands clear of the stone's own grain
//   6. nothing mounts a solid
//
// The rows are ``HomesCorpus``'s synthetic half — real tattva vocabulary keyed
// off position, because Ring 1 lives in Airtable and a bundled copy would be the
// ghost roster law 1 exists to prevent — so a difference found between two of
// them is weaker evidence than it looks. None of the checks below depends on it:
// the count, the speaking, the growing and the answer are all facts about the
// room rather than about the row.
final class MatrkaRoomTests: XCTestCase {

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { (11...18).contains($0.row.position) }
    }

    private func built(_ room: HomeRoom) -> MatrkaRoom? {
        RoomMechanisms.forRoom(room) as? MatrkaRoom
    }

    // MARK: - 1 · all eight, by position, each with her own count

    func testEveryMatrkaReachesHerRowByPosition() {
        var counts: [Int: Int] = [:]
        for (row, room) in rooms() {
            guard let matrka = built(room) else {
                XCTFail("khaḍgamālā \(row.position) did not reach a Mātṛkā's room")
                continue
            }
            XCTAssertEqual(matrka.position, row.position,
                           "the Mātṛkā at khaḍgamālā \(row.position) believes she is somebody else")
            counts[row.position] = matrka.letters
        }
        XCTAssertEqual(counts, [11: 5, 12: 8, 13: 11, 14: 14,
                                15: 5, 16: 8, 17: 11, 18: 14],
                       "Design's own `5 + ((pos - 11) % 4) * 3` is not what the rooms are holding")

        let strangers = HomesCorpus.resolvedRooms()
            .filter { !(11...18).contains($0.row.position) }
            .filter { built($0.room) != nil }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a Mātṛkā's room without standing in her eight seats")

        // Her turn of the eight is Design's own, and no two share one.
        let phases = rooms().map { built($0.room)?.phase ?? -1 }
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 8,
                       "two Mothers take the same turn of the eight")
    }

    // MARK: - 2 · the speaking, travelling

    /// **One letter is at its peak at any instant, every letter takes the peak,
    /// and the rate it hands on at is her own count's.**
    ///
    /// Design's `Math.pow(Math.max(0, Math.sin(Math.PI * turn)), 8) * 5` is a
    /// narrow window — past half its own brightness for about a quarter of a turn
    /// — so what travels round the ring is a point of light with a few letters
    /// glowing behind it, not a strobe. What must be true is that there is one
    /// letter at the front of it, that none is skipped, and that a row of five
    /// hands on more slowly than a row of fourteen, because that is her count
    /// being heard rather than counted.
    func testTheSpeakingTravelsRoundTheRingAtHerOwnCountsRate() {
        var handOff: [Int: Double] = [:]
        for (row, room) in rooms() {
            guard let matrka = built(room) else { continue }
            let n = matrka.letters
            var tookThePeak = Array(repeating: false, count: n)
            var order: [Int] = []

            let turn = 1 / MatrkaRoom.speaks
            let steps = 2000
            for step in 0..<steps {
                let t = Double(step) / Double(steps) * turn
                var best = (index: -1, spoken: -1.0)
                var level: [Int] = []
                for index in 0..<n {
                    let phase = MatrkaRoom.wrapped(t * MatrkaRoom.speaks
                                                   + Double(index) / Double(n))
                    let spoken = pow(max(0, sin(.pi * phase)), MatrkaRoom.spokenSharpness)
                    if spoken > best.spoken + 1e-12 { best = (index, spoken); level = [index] }
                    else if abs(spoken - best.spoken) <= 1e-12 { level.append(index) }
                }
                // **Two at the same height is the hand-off itself**, and it is one
                // instant of a turn: the letter that has been speaking and the one
                // taking it over pass through each other's level exactly once. Two
                // that are *not* neighbours on the ring would be a second point of
                // light somewhere else on it, which is the thing this check exists
                // to refuse.
                XCTAssertLessThanOrEqual(level.count, 2,
                                         """
                                         khaḍgamālā \(row.position): \(level.count) of her \(n) \
                                         letters are at the front of the speaking at once. The room \
                                         is the mouth before sound, and a mouth says one thing at a \
                                         time.
                                         """)
                if level.count == 2 {
                    let gap = abs(level[0] - level[1])
                    XCTAssertTrue(gap == 1 || gap == n - 1,
                                  """
                                  khaḍgamālā \(row.position) is speaking at two places on the ring \
                                  at once — letters \(level[0]) and \(level[1]) of \(n). What goes \
                                  round is one point of light, handing on to its neighbour.
                                  """)
                }
                tookThePeak[best.index] = true
                if order.last != best.index { order.append(best.index) }
            }
            XCTAssertFalse(tookThePeak.contains(false),
                           """
                           khaḍgamālā \(row.position): a letter of her row never comes to the point \
                           of being spoken in a whole turn of the ring. She is the Mother of all of \
                           them.
                           """)
            handOff[n] = turn / Double(max(1, order.count - 1))
        }
        guard let five = handOff[5], let fourteen = handOff[14] else {
            return XCTFail("the counts under test are not the counts Design writes")
        }
        XCTAssertGreaterThan(five, fourteen * 2,
                             """
                             a row of five hands the speaking on at \(five)s and a row of fourteen \
                             at \(fourteen)s. Her count is supposed to set the rate.
                             """)
    }

    // MARK: - 3 · the letters grow until they touch

    /// **The letters were never separate from the voice — and there are still
    /// that many of them.**
    ///
    /// Design's own gesture is that the letters grow where they stand while the
    /// column opens, and this room carries it with one bound: a letter may grow
    /// until it is touching its neighbours and no further, because past that the
    /// row is an annulus and an annulus has stopped saying how many letters are
    /// in it. How far that is, is her count's own — which is why a row of five
    /// and a row of fourteen do not arrive at the same room.
    ///
    /// The first version of this file closed the *ring* instead. It is worth
    /// recording that this check is what caught it: at Design's own radius a row
    /// of fourteen is already touching, so two of the eight rooms had no
    /// convergence in them at all.
    func testTheLettersGrowUntilTheyTouchAndNotPastIt() {
        var grew: [Int: Double] = [:]
        for (row, room) in rooms() {
            guard let matrka = built(room) else { continue }
            let early = RingOneStage.marks(room: room, at: HomeMemory.firstAdaptation)
            let late = RingOneStage.marks(room: room, at: HomeMemory.secondAdaptationEnd)
            XCTAssertEqual(early.count, matrka.letters + 1,
                           "khaḍgamālā \(row.position) is not a column and \(matrka.letters) letters")
            XCTAssertEqual(late.count, early.count)

            // The column is first; the letters follow.
            let before = early[1].reach, after = late[1].reach
            XCTAssertGreaterThan(after, before,
                                 "khaḍgamālā \(row.position)'s letters never grow toward one another")

            // …and they stop at touching: the gap between two neighbours' centres
            // is never less than the two reaches that meet in it.
            func neighbours(_ marks: [SurfaceAction]) -> Double {
                let letters = Array(marks.dropFirst())
                guard letters.count > 1 else { return .infinity }
                var nearest = Double.infinity
                for index in 0..<letters.count {
                    let a = letters[index], b = letters[(index + 1) % letters.count]
                    let du = a.at.u - b.at.u, dv = a.at.v - b.at.v
                    nearest = min(nearest, (du * du + dv * dv).squareRoot())
                }
                return nearest
            }
            let gap = neighbours(late)
            XCTAssertGreaterThanOrEqual(gap, after * 1.8,
                                        """
                                        khaḍgamālā \(row.position)'s letters stand \(gap) apart with \
                                        a reach of \(after): her row has become one annulus, and an \
                                        annulus does not say how many letters are in it.
                                        """)
            grew[matrka.letters] = after / before
        }
        guard let five = grew[5], let fourteen = grew[14] else {
            return XCTFail("the counts under test are not the counts Design writes")
        }
        XCTAssertGreaterThan(five, fourteen,
                             """
                             a row of five grows \(five)× and a row of fourteen \(fourteen)×. How \
                             far a letter may grow is set by how many of them have to fit round the \
                             ring, and that is the one channel this family has.
                             """)
    }

    // MARK: - 4 · one answer, not two

    /// **The column of voice is the only answering mark this room makes.**
    ///
    /// A room that answered twice would have two answers, and the second is a lit
    /// disc standing in front of the first — which is what the render showed:
    /// ``RoomReversal``'s generic answering mark plus the column left the near
    /// half of Vārāhī's frame five times as bright past the second adaptation as
    /// at the first, on a room whose own light is Design's faint additive
    /// cylinder.
    func testTheColumnIsTheOnlyAnswerTheRoomMakes() {
        for (row, room) in rooms() {
            guard let matrka = built(room) else { continue }
            let stage = RingOneStage.stage(room: room, at: HomeMemory.secondAdaptationEnd)
            let made = matrka.actions(at: HomeMemory.secondAdaptationEnd, stage: stage)
            XCTAssertEqual(made.count, 1,
                           """
                           khaḍgamālā \(row.position) acts on \(made.count) surfaces. The column is \
                           the answer and the enclosure moves rather than being marked.
                           """)
            let marks = made[stage.placement.surface] ?? []
            XCTAssertEqual(marks.count, matrka.letters + 1)

            // Design's own ramp, and its ceiling: `0.06 + 0.12 * k + b * 0.22`.
            let column = marks[0]
            XCTAssertEqual(column.verb, .swell, "the column is not raised out of the material")
            XCTAssertLessThanOrEqual(column.glow,
                                     MatrkaRoom.columnAtRest + MatrkaRoom.columnSettling
                                     + matrka.becoming.yields + 1e-9,
                                     """
                                     khaḍgamālā \(row.position)'s column is brighter than Design's \
                                     own cylinder ever gets.
                                     """)

            // And the reversal is still the instrument's: the enclosure travels.
            let stations = matrka.stations(at: HomeMemory.secondAdaptationEnd, stage: stage)
            XCTAssertNotNil(stations[.wall], "the enclosure is not giving the room up")
            XCTAssertNotNil(stations[stage.placement.surface],
                            "her working face is not taking the room over")
        }
    }

    // MARK: - 5 and 6 · a mark that can be seen, and nothing standing in it

    func testEveryMatrkaMarkStandsClearOfTheStonesOwnGrain() {
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
                                                \(material.grainRelief). It cannot be seen — and \
                                                this family is the one Design's own verification \
                                                pass found reading as a flat plane.
                                                """)
                }
            }
        }
    }

    func testNoMatrkaRoomMountsASolid() {
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
