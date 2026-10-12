import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Wave 6 · Slice C — the modes, the rites, and his laws, as pure logic.
///
/// Each check is a law of his Codex, stated where it applies: nothing counts
/// him (C-1195, C-1286), stillness is what deepens (C-1307, C-1355), a low
/// state is met with his own words and never a prompt (C-1002), and every word
/// he writes is kept (charter §4.1).
@MainActor
final class ModesAndRitesTests: XCTestCase {

    private var directories: [URL] = []

    override func tearDown() {
        for d in directories { try? FileManager.default.removeItem(at: d) }
        directories = []
        super.tearDown()
    }

    private func freshDirectory() -> URL {
        let d = FileManager.default.temporaryDirectory
            .appendingPathComponent("modes-rites-\(UUID().uuidString)", isDirectory: true)
        directories.append(d)
        return d
    }

    private var cal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "America/New_York")!
        return c
    }

    private func local(_ d: Int, _ h: Int) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 10, day: d, hour: h))!
    }

    // MARK: - The door

    func testTheDoorOffersEveryModeAtEveryHourAndNeverMauna() {
        for hour in 0..<24 {
            let order = ModesDoor.order(hour: hour)
            XCTAssertEqual(Set(order), Set(TheModes.Mode.allCases), "a mode is locked at \(hour):00")
            XCTAssertEqual(order.count, TheModes.Mode.allCases.count)
        }
        XCTAssertEqual(ModesDoor.order(hour: 6).first, .svapna, "the dream does not come first at dawn")
        XCTAssertEqual(ModesDoor.order(hour: 19).first, .puja, "the offering does not come first at dusk")
        for m in TheModes.Mode.allCases {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(m.gloss).isEmpty, m.gloss)
            XCTAssertNil(Rx.first(#"\d"#, m.gloss), m.gloss)
        }
        XCTAssertTrue(TheModes.maunaGloss.contains("still"), "Mauna is offered as something to open")
    }

    // MARK: - Darśana

    /// Beholding deepens by stillness and nothing else; its three places are
    /// Design's, and none of its words is a time.
    func testDarshanaWakesToStillnessAndGivesWayToMovement() {
        var d = DarshanaDepth()
        XCTAssertEqual(d.stage, .arriving)
        for _ in 0..<(10 * 600) { d.advance(dt: 0.1, steadiness: 0.1) }
        XCTAssertEqual(d.depth, 0, accuracy: 1e-12, "time alone woke the yantra")
        for _ in 0..<(10 * 40) { d.advance(dt: 0.1, steadiness: 1) }
        XCTAssertEqual(d.stage, .holding)
        for _ in 0..<(10 * 120) { d.advance(dt: 0.1, steadiness: 1) }
        XCTAssertEqual(d.stage, .entered)
        for _ in 0..<(10 * 3) { d.advance(dt: 0.1, steadiness: 0) }
        XCTAssertNotEqual(d.stage, .entered, "moving did not loosen it")
        for stage in [DarshanaDepth(), d] {
            XCTAssertNil(Rx.first(#"\d"#, stage.words), "Darśana counts: \(stage.words)")
        }
    }

    // MARK: - Sādhana

    func testTheGarlandIsRecitedInOrderRingByRingAndEnds() {
        XCTAssertEqual(Sadhana.order, Array(1...KhadgamalaMap.total), "the garland is not in its own order")
        XCTAssertEqual(Sadhana.index(elapsed: 0), 0)
        XCTAssertEqual(Sadhana.index(elapsed: Sadhana.perName * 1.5), 1)
        XCTAssertEqual(Sadhana.index(elapsed: Sadhana.wholeSeconds - 1), KhadgamalaMap.total - 1)
        XCTAssertNil(Sadhana.index(elapsed: Sadhana.wholeSeconds + 1), "the garland never ends")
        XCTAssertEqual(Sadhana.wholeSeconds, 28 * 60, accuracy: 1e-9, "Design's twenty-eight minutes")

        var crossings: [(Int, Int)] = []
        for i in 1..<Sadhana.order.count {
            if let c = Sadhana.crossing(from: Sadhana.order[i - 1], to: Sadhana.order[i]) {
                crossings.append((c.leaving, c.entering))
            }
        }
        XCTAssertEqual(crossings.map { $0.0 }, Array(1...8))
        XCTAssertEqual(crossings.map { $0.1 }, Array(2...9), "the garland does not travel inward ring by ring")

        for line in Sadhana.sankalpa + Sadhana.visarjana + Sadhana.remains + [Sadhana.sankalpaNote] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(line).isEmpty, line)
            XCTAssertNil(Rx.first(#"\d"#, line), "the garland counts out loud: \(line)")
        }
    }

    // MARK: - Smṛti

    /// Every recognition as light — a state, never a count (C-1286).
    func testSmritiLightsEverySeatHeFeltOnceAndThreadsTheDays() {
        let moments = [Smriti.Moment(kp: 31, day: 10), Smriti.Moment(kp: 31, day: 10),
                       Smriti.Moment(kp: 31, day: 11), Smriti.Moment(kp: 45, day: 10),
                       Smriti.Moment(kp: 102, day: 10), Smriti.Moment(kp: 7, day: 12),
                       Smriti.Moment(kp: 0, day: 12), Smriti.Moment(kp: 200, day: 12)]
        XCTAssertEqual(Smriti.lit(moments), [7, 31, 45, 102], "a seat outside the garland was lit")
        // Felt a thousand times is still one light.
        let many = Array(repeating: Smriti.Moment(kp: 31, day: 3), count: 1000)
        XCTAssertEqual(Smriti.lit(many), [31])
        XCTAssertEqual(Smriti.threads(moments), [[31, 45, 102]],
                       "a day with one seat is a star, not a thread; a day with several is one constellation")
        XCTAssertTrue(Smriti.threads([]).isEmpty)
        for line in [SmritiView.alive, SmritiView.waiting] {
            XCTAssertFalse(line.contains("most"), "Smṛti ranks where she is: \(line)")
            XCTAssertNil(Rx.first(#"\d"#, line))
        }
    }

    // MARK: - Svapna and Pūjā

    func testSvapnaGivesBackYesterdaysRecordAndPujaGathersToday() {
        let dayOf: (Date) -> Int = { DailyEnergyService.practiceDayIndex(for: $0, calendar: self.cal) }
        let moments: [(kp: Int, at: Date)] = [
            (kp: 33, at: local(11, 9)), (kp: 40, at: local(11, 14)), (kp: 33, at: local(11, 20)),
            (kp: 50, at: local(12, 8)), (kp: 61, at: local(12, 12)), (kp: 0, at: local(11, 10)),
            (kp: 70, at: local(9, 10)),
        ]
        let now = local(12, 16)
        XCTAssertEqual(Svapna.walkedThrough(moments, now: now, dayOf: dayOf), [33, 40],
                       "who walked through last night is yesterday's record, each once, in order")
        XCTAssertEqual(Puja.gathered(moments, now: now, dayOf: dayOf), [50, 61])
        XCTAssertTrue(Svapna.walkedThrough([], now: now, dayOf: dayOf).isEmpty)
        XCTAssertEqual(Svapna.stillNight, "The night was still.", "Design's words")
        XCTAssertEqual(Puja.received, ["The day is received.", "Tomorrow opens again."], "Design's words")

        // The offering draws in, rises, and is gone.
        let start = Puja.release(0), mid = Puja.release(0.4), end = Puja.release(1)
        XCTAssertEqual(start.gather, 0, accuracy: 1e-12)
        XCTAssertEqual(mid.gather, 1, accuracy: 1e-12)
        XCTAssertEqual(mid.rise, 0, accuracy: 1e-12)
        XCTAssertEqual(end.rise, 1, accuracy: 1e-12)
        XCTAssertEqual(end.light, 0, accuracy: 1e-12)
        for line in [Puja.emptyDay, Puja.offer, Puja.title] + Svapna.question {
            XCTAssertNil(Rx.first(#"\d"#, line), "Pūjā or Svapna counts: \(line)")
        }
    }

    // MARK: - The field every mode stands on

    func testEverySeatHasItsOwnPlaceOnTheModesField() {
        var seen: [CGPoint] = []
        for kp in 1...KhadgamalaMap.total {
            let p = ModeGeometry.world(kp: kp)
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            if ring == 9 {
                XCTAssertEqual(p, .zero, "the point is not at the centre")
            } else if ring > 1 {
                XCTAssertEqual(hypot(p.x, p.y), MandalaWorld.ringRadius(ring), accuracy: 1e-6,
                               "kp \(kp) is not on her ring")
            }
            for q in seen { XCTAssertGreaterThan(hypot(q.x - p.x, q.y - p.y), 1e-6, "two seats share a place") }
            seen.append(p)
        }
    }

    // MARK: - The Rite's openings

    func testTheRiteOpensOnceInEachHalfOfTheDayWithHisOwnWords() {
        XCTAssertEqual(RiteOpening.stop, "Stop. Breathe. Remember.", "C-1303, verbatim")
        XCTAssertEqual(RiteOpening.pause.count, 3, "the Sacred Pause is three breaths (C-1160)")
        XCTAssertEqual(RiteOpening.kind(hour: 6), .dawn)
        XCTAssertEqual(RiteOpening.kind(hour: 12), .day)
        XCTAssertEqual(RiteOpening.kind(hour: 19), .dusk)
        XCTAssertEqual(RiteOpening.kind(hour: 23), .night)
        XCTAssertEqual(RiteOpening.kind(hour: 2), .night)
        XCTAssertNotNil(RiteOpening.call(.dawn))
        XCTAssertNotNil(RiteOpening.call(.dusk))
        XCTAssertEqual(RiteOpening.phaseWord(.dawn), "Śṛṣṭi")
        XCTAssertEqual(RiteOpening.phaseWord(.dusk), "Saṃhāra")

        // Once in the light half, once in the dark half of one practice day.
        XCTAssertTrue(RiteOpening.opens(lastKey: nil, practiceDay: 2000, hour: 7))
        let morning = RiteOpening.key(practiceDay: 2000, hour: 7)
        XCTAssertFalse(RiteOpening.opens(lastKey: morning, practiceDay: 2000, hour: 13),
                       "the opening came twice in one morning")
        XCTAssertTrue(RiteOpening.opens(lastKey: morning, practiceDay: 2000, hour: 18), "dusk is its own rite")
        XCTAssertTrue(RiteOpening.opens(lastKey: morning, practiceDay: 2001, hour: 7), "a new day opens again")

        // The dusk rite is an offering, never a giving-up (C-1230).
        let dusk = RiteOpening.call(.dusk) ?? ""
        XCTAssertTrue(dusk.contains("offered"))
        XCTAssertFalse(dusk.lowercased().contains("set down"))

        // The year of a hundred and two is felt as light, never numbered.
        XCTAssertEqual(RiteOpening.yearPlace(practiceDay: 0), 0, accuracy: 1e-12)
        XCTAssertEqual(RiteOpening.yearPlace(practiceDay: KhadgamalaMap.total - 1), 1, accuracy: 1e-12)
        XCTAssertEqual(RiteOpening.yearPlace(practiceDay: KhadgamalaMap.total), 0, accuracy: 1e-12,
                       "the year does not turn again")
        XCTAssertGreaterThan(RiteOpening.yearLight(practiceDay: 0), RiteOpening.yearLight(practiceDay: 90))
        XCTAssertGreaterThan(RiteOpening.yearLight(practiceDay: 101), 0.5, "the year's end goes dark")

        for line in [RiteOpening.stop] + RiteOpening.pause + [RiteOpening.call(.dawn) ?? "", dusk] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(line).isEmpty, line)
            XCTAssertNil(Rx.first(#"\d"#, line), line)
        }
    }

    func testTheSixStationsAndTheirCloseComeFromHerRows() {
        XCTAssertEqual(RiteStation.allCases.map(\.name),
                       ["Arrival", "Summons", "Meeting", "Being-with", "Offering", "Carry"])
        XCTAssertEqual(RiteStation.offering.next, .carry)
        XCTAssertNil(RiteStation.carry.next, "the Rite does not rest after Carry")

        let both = RiteStation.closing(appreciation: "  Thank you for this touch. ",
                                       recognition: "You are extraordinary.", somaticLine: "skin, warming")
        XCTAssertEqual(both.offering, "Thank you for this touch.")
        XCTAssertEqual(both.carry, "skin, warming")
        let fallback = RiteStation.closing(appreciation: nil, recognition: "You are extraordinary.",
                                           somaticLine: "  ")
        XCTAssertEqual(fallback.offering, "You are extraordinary.")
        XCTAssertNil(fallback.carry, "a Carry with no line of hers was invented")
        XCTAssertNil(RiteStation.closing(appreciation: "", recognition: "", somaticLine: nil).offering)
    }

    // MARK: - The low-state door

    /// His own words, never a prompt (C-1002, C-1120).
    func testTheLowStateDoorGivesBackOnlyHisOwnWords() {
        let sources = ["I was here before the fear.",
                       "  ",
                       "ok",
                       "You held me through the whole winter. I did not know it then! And now I do.",
                       "I was here before the fear."]
        let lines = LowStateDoor.lines(from: sources, practiceDay: 0)
        XCTAssertEqual(Set(lines), ["I was here before the fear.",
                                    "You held me through the whole winter. I did not know it then! And now I do."])
        XCTAssertEqual(lines.count, 2, "a line was handed back twice")
        for l in lines {
            XCTAssertTrue(sources.contains { $0.contains(l) }, "the door said something he did not write: \(l)")
        }
        // A long letter is cut at its sentences and every piece is his.
        let long = String(repeating: "The light was in the kitchen this morning and I stood in it. ", count: 6)
        let cut = LowStateDoor.sentences(long)
        XCTAssertFalse(cut.isEmpty)
        for s in cut {
            XCTAssertLessThanOrEqual(s.count, LowStateDoor.longest)
            XCTAssertTrue(long.contains(s))
        }
        // The same day opens the same way; another day opens elsewhere.
        let three = ["First line of mine here.", "Second line of mine here.", "Third line of mine here."]
        XCTAssertEqual(LowStateDoor.lines(from: three, practiceDay: 4), LowStateDoor.lines(from: three, practiceDay: 4))
        XCTAssertNotEqual(LowStateDoor.lines(from: three, practiceDay: 4).first,
                          LowStateDoor.lines(from: three, practiceDay: 5).first)
        XCTAssertTrue(LowStateDoor.lines(from: [], practiceDay: 3).isEmpty)
        // The door itself never asks.
        for words in [LowStateDoor.doorWords, LowStateDoor.heading, LowStateDoor.empty] {
            XCTAssertFalse(words.contains("?"), "the low-state door asks him something: \(words)")
        }
    }

    // MARK: - What the rites keep

    /// His words beside her witness page are never overwritten, never blank,
    /// and survive a relaunch.
    func testWitnessWritingIsKeptWholeAndSurvivesARelaunch() throws {
        let d = freshDirectory()
        let store = RitesPractice(directory: d)
        XCTAssertNil(store.write(witness: "   \n", for: 31), "a blank page wrote something")
        XCTAssertNil(store.write(witness: "words", for: 0), "a position outside the garland was kept")
        let first = try XCTUnwrap(store.write(witness: "She was in the doorway.", for: 31, at: local(12, 9)))
        XCTAssertEqual(store.write(witness: "She was in the doorway.", for: 31)?.id, first.id,
                       "unchanged words were kept twice")
        let second = try XCTUnwrap(store.write(witness: "She is the doorway.", for: 31, at: local(12, 10)))
        XCTAssertNotEqual(first.id, second.id)
        XCTAssertEqual(store.witness(for: 31)?.body, "She is the doorway.")
        XCTAssertEqual(store.archive.witness.map(\.body), ["She was in the doorway.", "She is the doorway."],
                       "an earlier page was overwritten")

        let again = RitesPractice(directory: d)
        XCTAssertEqual(again.witness(for: 31)?.body, "She is the doorway.")
        XCTAssertEqual(again.allWitness.map(\.khadgamalaPosition), [31])
    }

    /// Each act reaches the one ledger once, in its own words.
    func testTheRitesReachTheLedgerOnceEach() {
        let store = RitesPractice(directory: freshDirectory())
        store.write(witness: "Beside her page.", for: 40, at: local(12, 9))
        store.recite(startedAt: local(12, 6), endedAt: local(12, 7), reachedRing: 3, whole: false)
        store.recite(startedAt: local(12, 20), endedAt: local(12, 21), reachedRing: 9, whole: true)
        store.offerTheDay(todayPosition: 55, at: local(12, 21))

        let rows: [Int: (id: String, name: String)] = [40: ("rec40", "Sparśākarṣiṇī"),
                                                       102: ("recPoint", "Mahātripurasundarī")]
        let first = store.takeUnledgered(record: { rows[$0] })
        XCTAssertEqual(first.map(\.type), [ActivityLedger.ActivityType.witnessWritten,
                                           ActivityLedger.ActivityType.garlandRecited,
                                           ActivityLedger.ActivityType.garlandRecited,
                                           ActivityLedger.ActivityType.dayOffered])
        XCTAssertEqual(first[0].notes, "Beside her page.", "his words, and only his, in Notes")
        XCTAssertEqual(first[0].linkRecordId, "rec40")
        XCTAssertEqual(first[1].linkRecordId, "recPoint", "the garland is offered back at the point")
        XCTAssertTrue(first[1].detail.hasPrefix("Recited inward to the third enclosure"), first[1].detail)
        XCTAssertTrue(first[2].detail.hasPrefix("The whole garland"), first[2].detail)
        XCTAssertEqual(first[3].linkRecordId, "", "a day with no known row is still offered")
        XCTAssertTrue(store.takeUnledgered(record: { rows[$0] }).isEmpty, "an act reached the ledger twice")

        for row in first {
            XCTAssertNil(row.name.rangeOfCharacter(from: .decimalDigits), row.name)
            XCTAssertNil(row.detail.rangeOfCharacter(from: .decimalDigits), row.detail)
            XCTAssertTrue(NeverMeasure.measuresOutLoud(row.name + " " + row.detail).isEmpty)
            XCTAssertNil(row.durationSec, "a rite row carries a duration")
        }
        XCTAssertEqual(ActivityLedger.ActivityType.witnessWritten, "Witness Written")
        XCTAssertEqual(ActivityLedger.ActivityType.garlandRecited, "Garland Recited")
        XCTAssertEqual(ActivityLedger.ActivityType.dayOffered, "Day Offered")
    }

    /// A witness page waits for her row rather than being lost.
    func testAWitnessPageWaitsForHerRow() {
        let store = RitesPractice(directory: freshDirectory())
        store.write(witness: "Before the base answered.", for: 60)
        XCTAssertTrue(store.takeUnledgered(record: { _ in nil })
                        .filter { $0.type == ActivityLedger.ActivityType.witnessWritten }.isEmpty)
        let later = store.takeUnledgered(record: { $0 == 60 ? ("rec60", "her") : nil })
        XCTAssertEqual(later.filter { $0.type == ActivityLedger.ActivityType.witnessWritten }.count, 1)
    }

    // MARK: - The one-page answer and the witness page

    func testTheOnePageAnswerAndTheWitnessPageComeFromHerRows() {
        XCTAssertEqual(OnePageAnswerSection.line(appreciation: " Thank you. ", quality: "She who attracts"),
                       "Thank you.")
        XCTAssertEqual(OnePageAnswerSection.line(appreciation: nil, quality: "She who attracts"),
                       "She who attracts")
        XCTAssertNil(OnePageAnswerSection.line(appreciation: "", quality: " "))
        XCTAssertEqual(HerWitnessPage.page(function: "Draws touch inward.", qualityDescription: "q"),
                       "Draws touch inward.")
        XCTAssertEqual(HerWitnessPage.page(function: nil, qualityDescription: "q"), "q")
        XCTAssertNil(HerWitnessPage.page(function: "  ", qualityDescription: ""),
                     "a witness page was offered with nothing of hers on it")
    }
}
