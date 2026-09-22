import Foundation
import XCTest
@testable import Bindu_Mandala

// MARK: - THE WHOLE INSTRUMENT · all 102 rooms, asked at once
//
// Every pass before this one proved its own ring. This suite is the first that
// could not have been written before now, because until the outer climb closed
// there was no moment at which **all 102 seats had a room**. It asks the four
// questions the building as a whole can be asked, and no question a single ring
// could answer on its own:
//
//   1. **Does every one of the 102 resolve to a built room, by position alone?**
//      Not "does the resolution return something" — the order always returns
//      something, because its third branch is the bare gem-lit seat. The question
//      is whether anybody is still *on* that branch.
//   2. **Does anybody fall through to a shared room?** There are two shared rooms
//      in the instrument and they are different failures. `.seat` is the room the
//      resolution gives a Śakti it has nothing to say about. `GrammarReversal` and
//      `ArchetypeReversal` are the *bare archetype turn* — a room that has her
//      ring's reversal and none of her own physics, which is one generic room worn
//      by everyone in the ring. Either one means her room is not hers.
//   3. **Do Design's eight authored rooms arrive at their own positions?** Keyed
//      `{1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane,
//      28 triple, 102 dissolve}`, asserted as the concrete mechanism type rather
//      than as the enum case, because the enum case is satisfied by the
//      placeholder fallback that stands in for a room Design named and Code has
//      not built. kp 2 is Vastness and kp 3 is Lightness; a check keyed by name
//      could get that wrong and one keyed by position cannot.
//   4. **Does every ring tell its own sisters apart, and is every room legible?**
//
// ─────────────────────────────────────────────────────────────────────────────
// ONE RULER, NINE RINGS — AND WHY ITS SLOT COUNT IS MEASURED AND NOT TYPED
// ─────────────────────────────────────────────────────────────────────────────
//
// Each ring's own suite chose its own print width against its own builder: 48 in
// Ring 1's three families, 19 in the Vāsinīs, `corners + 2` at the source. Those
// are right there and wrong here — a single number across nine rings is either
// too narrow for Ring 1, which truncates a hundred-and-seventy-mark room down to
// its first sixteen and throws away the difference, or too wide for the Triad,
// where three real marks would sit in empty slots.
//
// So the width is **measured off the ring itself**: the most marks any room of
// that ring makes at any of the sampled moments, plus two. Nothing is truncated
// anywhere.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND THEN: A SLOT NEITHER ROOM USED IS NOT EVIDENCE THAT THEY ARE ALIKE
// ─────────────────────────────────────────────────────────────────────────────
//
// **This is a finding, and it was measured here rather than reasoned.** A width
// wide enough to truncate nobody is, in a ring whose rooms differ wildly in how
// many marks they make, wide enough to drown the rooms that make few. Ring 1 is
// the extreme case: one of its rooms works a hundred and seventy-two marks and
// the Gate's two work a handful, so at a width of 174 the Gate's prints are some
// nine parts padding to one part room — and `release` and `press`, which are
// Design's own two authored opposites and could not be more different, came back
// **0.037 apart**, three times *under* Design's bar. Nothing was wrong with
// either room. The ruler was measuring its own empty slots.
//
// That is the dilution Ring 2's suite named, arriving from the other side: not
// from a print that is mostly padding in *every* room, which
// ``OuterRingFingerprint/refusesDilution(_:)`` already catches, but from a pair
// of rooms that happen to be padded in the same places. So the comparison skips
// **every component both prints left empty** — an unused slot, or a surface
// neither room shaped. It is not a weakening: the skipped components are
// identical *and* silent in both rooms, so dropping them can never hide a
// difference, only stop the absence of one from being counted as agreement. It
// moves this measure back toward Design's own, which walked a chamber's real
// objects and had no empty slots to count.
//
// The bar itself is never moved. Design's tenth is the tenth in all nine rings,
// and a ring that cannot clear it is a finding, not a threshold to retune.
@MainActor
final class WholeInstrumentTests: XCTestCase {

    // MARK: - The instrument, resolved once

    /// All 102, through the shipped resolution order and nothing else.
    private func instrument() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms()
    }

    // MARK: - 1 · all 102 exist

    /// **Every seat of the khaḍgamālā resolves to a room, and the key is her
    /// position.**
    func testAllHundredTwoResolveToARoomByPosition() {
        let rooms = instrument()
        XCTAssertEqual(rooms.count, 102,
                       "\(rooms.count) of the 102 resolved. A seat with no room is a walker "
                       + "standing in front of a door that does not open.")
        XCTAssertEqual(Set(rooms.map(\.row.position)), Set(1...102),
                       "The 102 rooms do not stand at the 102 positions.")

        // Nine rings, and the counts the errata fixes: 28 and 16 in the two built
        // rings, 58 across the outer climb.
        var perRing: [Int: Int] = [:]
        for (row, _) in rooms { perRing[row.ring, default: 0] += 1 }
        XCTAssertEqual(perRing, [1: 28, 2: 16, 3: 8, 4: 14, 5: 10,
                                 6: 10, 7: 12, 8: 3, 9: 1],
                       "The rings do not hold the seats the errata fixes for them.")
        XCTAssertEqual(perRing.values.reduce(0, +), 102)
    }

    /// **Nobody is still on the bare seat.**
    ///
    /// The resolution order's third branch is the gem-lit seat, which exists so a
    /// Śakti the instrument cannot yet speak for is not left with nothing. Until
    /// this phase closed, fifty-eight of them were on it. The whole point of 3.6
    /// is that it is now empty.
    func testNobodyFallsThroughToTheSharedSeat() {
        var onTheSeat: [Int] = []
        for (row, room) in instrument() {
            if case .seat = room.kind { onTheSeat.append(row.position) }
        }
        XCTAssertEqual(onTheSeat, [],
                       "khaḍgamālā \(onTheSeat.map(String.init).joined(separator: ", ")) still "
                       + "resolve to the shared gem-lit seat rather than to a room of their own.")
    }

    /// **Every one of the 102 has a mechanism, and it is her own.**
    ///
    /// The bare archetype turn is the second shared room, and the more dangerous
    /// of the two because it looks built: the room reverses, the light moves, and
    /// every Śakti of the ring is standing in exactly the same one. A room that
    /// carries her ring's reversal and none of her physics is the generic
    /// intensification Design's own verification pass found under seventy-eight of
    /// its hundred and two rooms.
    func testEveryRoomHasItsOwnMechanismAndNotTheBareArchetypeTurn() {
        var missing: [Int] = []
        var bare: [Int] = []
        for (row, room) in instrument() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                missing.append(row.position); continue
            }
            if mechanism is GrammarReversal || mechanism is ArchetypeReversal {
                bare.append(row.position)
            }
        }
        XCTAssertEqual(missing, [],
                       "khaḍgamālā \(missing.map(String.init).joined(separator: ", ")) reach no "
                       + "mechanism at all.")
        XCTAssertEqual(bare, [],
                       "khaḍgamālā \(bare.map(String.init).joined(separator: ", ")) fall back to "
                       + "the bare archetype turn — her ring's reversal wearing her name, which "
                       + "is one generic room shared by everybody in the ring.")
    }

    // MARK: - 2 · Design's eight, by position

    /// **All eight of Design's authored rooms are reached by their positions.**
    ///
    /// The concrete type is asserted, not the enum case: `RoomMechanisms.forRoom`
    /// answers an authored room the grammar has not built with her ring's
    /// placeholder turn, so a check that only asked "is this room authored" would
    /// have passed through the whole of Phase 3.3 and 3.5 while five of the eight
    /// were still unbuilt.
    func testDesignsEightAuthoredRoomsAreReachedByTheirPositions() {
        let expected: [Int: (HomeAuthoredMechanism, String)] = [
            1:   (.contract, String(describing: ContractRoom.self)),
            2:   (.endless,  String(describing: EndlessRoom.self)),
            3:   (.release,  String(describing: ReleaseRoom.self)),
            4:   (.press,    String(describing: PressRoom.self)),
            6:   (.known,    String(describing: KnownRoom.self)),
            27:  (.membrane, String(describing: MembraneRoom.self)),
            28:  (.triple,   String(describing: TripleRoom.self)),
            102: (.dissolve, String(describing: DissolveRoom.self)),
        ]
        XCTAssertEqual(Set(expected.keys), Set(HomeRooms.authored.keys),
                       "The authored map no longer holds Design's eight positions.")

        let byPosition = Dictionary(uniqueKeysWithValues:
                                        instrument().map { ($0.row.position, $0.room) })
        for (position, want) in expected.sorted(by: { $0.key < $1.key }) {
            guard let room = byPosition[position] else {
                XCTFail("khaḍgamālā \(position) does not resolve at all."); continue
            }
            guard case .authored(let mechanism) = room.kind else {
                XCTFail("khaḍgamālā \(position) resolves to \(room.kind), not to the authored "
                        + "room Design wrote for her."); continue
            }
            XCTAssertEqual(mechanism, want.0,
                           "khaḍgamālā \(position) carries \(mechanism) where Design wrote "
                           + "\(want.0).")
            guard let built = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(position)'s authored room reaches no mechanism."); continue
            }
            XCTAssertEqual(String(describing: type(of: built)), want.1,
                           "khaḍgamālā \(position) is dispatched to "
                           + "\(String(describing: type(of: built))) rather than to Design's own "
                           + "\(want.1) — she is standing in the placeholder turn.")
        }

        // And nobody else is authored: the other ninety-four go through the
        // grammar, which is what makes them hers rather than Design's.
        let authoredPositions = instrument().filter {
            if case .authored = $0.room.kind { return true }
            return false
        }.map(\.row.position).sorted()
        XCTAssertEqual(authoredPositions, [1, 2, 3, 4, 6, 27, 28, 102])
    }

    // MARK: - 3 · sister divergence, ring by ring

    /// The most marks any room of a ring makes at any sampled moment — the ring's
    /// own print width, measured rather than typed. See the header.
    private func slots(forRing ring: Int,
                       _ rooms: [(row: HomesCorpus.Row, room: HomeRoom)]) -> Int {
        var widest = 0
        for (_, room) in rooms where room.ring == ring {
            let scene = RoomScene(room: room)
            for t in OuterRingFingerprint.sampleTimes {
                let shaped = scene.shaped(at: t)
                widest = max(widest, shaped[scene.receivingSurface]?.actions.count ?? 0)
            }
        }
        return widest + 2
    }

    /// **A component both rooms left empty.**
    ///
    /// The two the print can carry: an unused mark slot, which
    /// ``OuterRingFingerprint`` writes as `a|<slot>|-`, and a surface neither room
    /// shaped, written `m|-`. Both say *nothing happened here* — in both rooms —
    /// and two silences agreeing is not two rooms resembling each other.
    private func bothSilent(_ a: String, _ b: String) -> Bool {
        guard a == b else { return false }
        return (a.hasPrefix("a|") && a.hasSuffix("|-")) || a == "m|-"
    }

    /// Design's `divergence`, over the components at least one of the two rooms
    /// actually used. See the header: with nothing skipped this is Design's own
    /// number to the last bit, because Design's prints had no empty slots.
    private func divergence(_ a: [String], _ b: [String]) -> (value: Double, read: Int) {
        let n = min(a.count, b.count)
        var differing = 0, counted = 0
        for i in 0..<n where !bothSilent(a[i], b[i]) {
            counted += 1
            if a[i] != b[i] { differing += 1 }
        }
        guard counted > 0 else { return (0, 0) }
        return (Double(differing) / Double(counted), counted)
    }

    /// **Every ring tells its own sisters apart, at Design's own tenth.**
    ///
    /// Asked of all nine rings with one instrument, which is the question this
    /// phase exists to make askable. A pair under the bar is a real finding and a
    /// blocker: two Śaktis standing in one room.
    func testEveryRingTellsItsSistersApart() {
        let rooms = instrument()
        var report: [String] = []

        for ring in 1...9 {
            let width = slots(forRing: ring, rooms)
            let seats = OuterRingFingerprint.ring(ring, rooms, slots: width)
            guard seats.count > 1 else {
                // Ring 9 is one room. There is nobody for the Bindu to blur into,
                // and a ring of one is not a weaker check — it is a smaller one.
                XCTAssertEqual(ring, 9, "Ring \(ring) came back with \(seats.count) seats.")
                report.append("{\"ring\":9,\"seats\":\(seats.count),\"closest\":null}")
                continue
            }

            var closest = (value: 1.0, a: 0, b: 0, read: 0)
            for (index, one) in seats.enumerated() {
                for other in seats[(index + 1)...] {
                    let (d, read) = divergence(one.print, other.print)
                    if d < closest.value { closest = (d, one.position, other.position, read) }
                    XCTAssertGreaterThan(d, OuterRingFingerprint.threshold,
                                         """
                                         Ring \(ring): khaḍgamālā \(one.position) and \
                                         \(other.position) are \(String(format: "%.3f", d)) apart \
                                         on the geometric fingerprint over the \(read) components \
                                         at least one of them used, under Design's tenth. Two \
                                         sisters are standing in one room.
                                         """)
                }
            }

            let dilution = OuterRingFingerprint.refusesDilution(seats)
            let constant = Double(dilution.constant) / Double(max(1, dilution.total))
            XCTAssertLessThan(constant, 0.5,
                              """
                              Ring \(ring): \(dilution.constant) of \(dilution.total) components \
                              read the same in all \(seats.count) rooms. A print that is mostly \
                              padding passes by dilution rather than by difference.
                              """)

            report.append("{\"ring\":\(ring),\"seats\":\(seats.count),\"slots\":\(width),"
                          + "\"closestPair\":[\(closest.a),\(closest.b)],"
                          + "\"componentsRead\":\(closest.read),"
                          + String(format: "\"divergence\":%.4f,", closest.value)
                          + String(format: "\"constantShare\":%.3f}", constant))
        }

        print("WHOLE_INSTRUMENT_DIVERGENCE [" + report.joined(separator: ",") + "]")
    }

    // MARK: - 4 · the light, in all 102

    /// **Every room in the building is legible at both adaptations.**
    ///
    /// Design's first verification check, asked of the whole instrument: neither
    /// black, nor blown out, nor flat, at the first adaptation and past the
    /// second. A room that renders black is a Śakti the walker cannot see; a flat
    /// one is a room whose material has no relief for the light to fall across,
    /// which is the defect Design's own pass hit in Ring 1.
    func testEveryRoomIsLegibleAtBothAdaptations() {
        for (row, room) in instrument() {
            OuterRingCapture.assertLegible(
                room, called: "khaḍgamālā \(row.position) (ring \(row.ring), \(row.provenance))")
        }
    }
}
