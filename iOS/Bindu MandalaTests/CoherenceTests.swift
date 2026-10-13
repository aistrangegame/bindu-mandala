import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Wave 6.1 · Coherence — the five Wave 6 drafts as one instrument.
///
/// The gameplan's answer to "the instrument becomes a menu" (§1): things are
/// found where they live, and Lalitā's field is the one place everything is
/// gathered. And his decisions of 12 October (§4), where the drafts differed.
///
/// U0: "no menu / three quiet controls" and "one breath clock" are lifted
/// (ruling 10); their tests are retired and the ways-in ring is rewritten as
/// the seed of the World Registry. Rām japa at kp 42 and gratitude, gently,
/// are floors and stay unchanged.
final class CoherenceTests: XCTestCase {

    // MARK: The ways in — the seed of the World Registry
    //
    // U0 (verification.md §2.2): `testTheMandalaCarriesThreeQuietControls`
    // (VER-L-0733, "no menu / three quiet controls") is retired — the menu and
    // every control the worlds need are allowed. The six-way ring's exact list
    // and its no-digit clause (VER-L-0757) went with it; what stays is its
    // rewrite as the seed of the World Registry (VER-L-0734).

    /// Every way the ring holds leads into a world of the registry, and a voice
    /// still finds the constellation and the Road by the names their own
    /// switches carried.
    func testTheWaysInSeedTheWorldRegistry() {
        for way in WayIn.allCases {
            XCTAssertFalse(way.word.isEmpty)
            XCTAssertTrue(WorldID.allCases.contains(WorldID.reached(by: way)), "\(way) leads nowhere")
        }
        XCTAssertEqual(WorldID.reached(by: .constellation), .the33)
        XCTAssertEqual(WorldID.reached(by: .road), .the33)
        XCTAssertEqual(WorldID.reached(by: .climb), .climb)
        XCTAssertEqual(WorldID.reached(by: .modes), .modes)
        XCTAssertEqual(WayIn.constellation.spoken(constellationOn: false, walking: false),
                       "Show the thirty-three chakras")
        XCTAssertEqual(WayIn.road.spoken(constellationOn: false, walking: true), "Leave the road")
        XCTAssertEqual(WayIn.modes.spoken(constellationOn: false, walking: false), TheModes.doorLabel)
    }

    /// The ring opens into the glass, never off its trailing edge, and every
    /// way keeps a finger's room from its neighbour.
    func testTheRingOpensIntoTheGlassWithRoomForAFinger() {
        let width: CGFloat = 375
        let centre = CGPoint(x: width - 16 - 23, y: 70 + 46 + 10 + 23)
        let n = WayIn.allCases.count
        var points: [CGPoint] = []
        for i in 0..<n {
            let p = WaysInRing.point(index: i, of: n, around: centre)
            XCTAssertLessThanOrEqual(p.x, centre.x + 0.001, "a way stands off the trailing edge")
            XCTAssertGreaterThan(p.x, 23, "a way stands off the leading edge")
            XCTAssertGreaterThanOrEqual(p.y, centre.y - 0.001, "a way stands above the mark")
            points.append(p)
        }
        for i in 1..<n {
            let d = hypot(points[i].x - points[i - 1].x, points[i].y - points[i - 1].y)
            XCTAssertGreaterThanOrEqual(d, 44, "two ways closer than a finger")
        }
    }

    /// A way asked for elsewhere is taken once.
    func testAWayAskedElsewhereIsTakenOnce() {
        MandalaWays.ask(.road)
        XCTAssertEqual(MandalaWays.take(), .road)
        XCTAssertNil(MandalaWays.take())
    }

    // MARK: Found where they live

    /// A mode at its hour: the dream at dawn, the offering at dusk, the
    /// Sandhyā at both junctions — and nothing pressed on the open day.
    func testAModeIsOfferedAtItsHour() {
        XCTAssertEqual(RiteOpening.ways(.dawn), [.mode(.svapna), .game(.sandhya)])
        XCTAssertEqual(RiteOpening.ways(.dusk), [.mode(.puja), .game(.sandhya)])
        XCTAssertTrue(RiteOpening.ways(.day).isEmpty)
        XCTAssertTrue(RiteOpening.ways(.night).isEmpty)
    }

    // MARK: His decisions (12 October)

    /// Rām japa at Ātmākarṣiṇī, beside the Higher Self — still ending in
    /// stillness, never in her Recognition.
    func testRamJapaStandsBesideTheHigherSelf() {
        XCTAssertEqual(PlayGame.ramJapa.address, .seat(TrinityOfGuidance.higherSelfSeat))
        XCTAssertEqual(TrinityOfGuidance.higherSelfSeat, 42)
        XCTAssertEqual(PlayGame.ramJapa.handoff, .stillness)
        XCTAssertTrue(PlayAddressBook.games(atPosition: 42).contains(.ramJapa))
    }

    // U0 · retired (VER-L-0740): `testThereIsOneBreath` — "one 8 s breath
    // clock" is lifted. Each world keeps its own clock: the nine metabolisms
    // (ring 1 holds; rings 2–9 at 3/8/9/11/13/15/18/4 s), Homecoming's 4 s
    // (`RiteDayTests.testEveryReturnIsOneBreath`), the Rite's own pause,
    // Coherence's 8 s.

    // MARK: Gratitude, gently

    func testGratitudeReadsOneColumnOfHisOwnWords() throws {
        XCTAssertEqual(GratitudeGrace.tableId, "tblEFiuFIijKe9ba6")
        XCTAssertEqual(GratitudeGrace.wordsFieldId, "fld85STU49AtREkfe")
        // Read only: the reader is a fetch, never a create or an update.
        let service = try XCTUnwrap(LawSource.production("AirtableService.swift"))
        let reader = try XCTUnwrap(Rx.first(#"func gratitudeRows\(\)[\s\S]*?\n    \}"#, service.text))
        XCTAssertTrue(reader.contains("fetch("))
        XCTAssertFalse(reader.contains("httpMethod"), "the gratitude reader writes")
        // Emotions, SJ and Anger stay out: no other table of his is named.
        let grace = try XCTUnwrap(LawSource.production("GratitudeGrace.swift"))
        let ids = Set(Rx.all(#"tbl[A-Za-z0-9]{14}"#, grace.text))
        XCTAssertTrue(ids.isSubset(of: [GratitudeGrace.tableId]))
    }

    func testGratitudeIsRareRoomMatchedAndNeverRepeats() {
        let rows = [
            GratitudeGrace.Row(id: "recA", fields: .init(words: "the morning light on the water")),
            GratitudeGrace.Row(id: "recB", fields: .init(words: "my heart, open to my son")),
            GratitudeGrace.Row(id: "recC", fields: .init(words: "   ")),
        ]
        let room = GratitudeGrace.roomWords(name: "Ātmākarṣiṇī", shortName: "Ātma",
                                            bodilyLocation: "heart", tattva: "Pure Being (Sat)",
                                            quality: "She who attracts the Self")
        XCTAssertTrue(room.contains("heart"))
        // It speaks on about one day in three, never every day.
        let days = (0..<300).filter { GratitudeGrace.maySpeak(practiceDay: $0) }
        XCTAssertFalse(days.isEmpty)
        XCTAssertLessThan(days.count, 150)
        let day = days[0]
        let line = GratitudeGrace.choose(rows: rows, roomWords: room, practiceDay: day, surfaced: [])
        XCTAssertEqual(line?.rowId, "gratitude:recB", "the line that meets her room comes first")
        XCTAssertEqual(line?.text, "my heart, open to my son", "his words, verbatim")
        XCTAssertNil(line?.text.rangeOfCharacter(from: .decimalDigits))
        // Once returned, not returned again; the empty row is never a line.
        let next = GratitudeGrace.choose(rows: rows, roomWords: room, practiceDay: day,
                                         surfaced: ["gratitude:recB"])
        XCTAssertEqual(next?.rowId, "gratitude:recA")
        XCTAssertNil(GratitudeGrace.choose(rows: rows, roomWords: room, practiceDay: day,
                                           surfaced: ["gratitude:recA", "gratitude:recB"]))
        // A day that may not speak says nothing.
        if let quiet = (0..<300).first(where: { !GratitudeGrace.maySpeak(practiceDay: $0) }) {
            XCTAssertNil(GratitudeGrace.choose(rows: rows, roomWords: room, practiceDay: quiet, surfaced: []))
        }
    }

    func testALongGratitudeLineIsCutAtASentence() {
        let long = String(repeating: "Thank you for the long walk by the river today. ", count: 8)
        let cut = GratitudeGrace.trimmed(long)
        XCTAssertNotNil(cut)
        XCTAssertLessThanOrEqual(cut?.count ?? 999, GratitudeGrace.maxLength)
        XCTAssertTrue(cut?.hasSuffix(".") ?? false)
    }
}
