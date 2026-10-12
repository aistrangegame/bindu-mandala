import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Wave 6 · the 33 alive — the re-bake of The Map, the room's pure logic, the
/// body chakras on the Climb, the thresholds' own words, the Road's stations,
/// the held practices, and the ledger's `Link to The Map`.
final class ChakraRoomTests: XCTestCase {

    private var baked: [Chakra33] {
        let url = SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Data/ChakraConstellation.json")
        guard let data = try? Data(contentsOf: url) else { return [] }
        return ChakraConstellation.decode(data)
    }

    private func chakra(_ road: Int) throws -> Chakra33 {
        try XCTUnwrap(baked.first { $0.road == road }, "road \(road) is not in the bake")
    }

    // MARK: The re-bake — everything The Map holds, copied, never invented

    func testEveryRoomCarriesTheMapsTeaching() {
        let all = baked
        XCTAssertEqual(all.count, 33)
        for c in all {
            XCTAssertTrue(c.recordId.hasPrefix("rec") && c.recordId.count == 17, "\(c.road) record id")
            for (what, v) in [("Core Question", c.coreQuestion), ("Signature Phrase", c.signaturePhrase),
                              ("Practice Prompt", c.practicePrompt), ("Three Ways In", c.threeWaysIn),
                              ("Practice Gate Type", c.gateType), ("Gate Text", c.gateText),
                              ("Story Thread", c.storyThread), ("Leela Story", c.leelaStory),
                              ("Act 1 Voice", c.act1Voice), ("Bindu Reflection", c.binduReflection),
                              ("Witness Perspective", c.witnessPerspective), ("Voice", c.voice),
                              ("Writing Prompt", c.writingPrompt),
                              ("Mirror Frequency Instruction", c.mirrorFrequencyInstruction)] {
                XCTAssertNotNil(v, "road \(c.road) lost its \(what)")
            }
        }
        // The Map's own partial columns stay partial: absent, never filled.
        XCTAssertEqual(all.filter { $0.act2Voice != nil }.count, 10, "Act 2 Voice is 10 of 33 in the Map")
        XCTAssertEqual(all.filter { $0.codexReferences != nil }.count, 4, "Codex References is 4 of 33")
        XCTAssertEqual(all.filter { $0.mirrorFrequency != nil }.count, 10, "Mirror Frequency is 10 of 33")
    }

    func testNoTeachingCellIsBlank() {
        for c in baked {
            for v in [c.coreQuestion, c.signaturePhrase, c.heroThreshold, c.practicePrompt, c.threeWaysIn,
                      c.gateType, c.gateText, c.storyThread, c.leelaStory, c.act1Voice, c.act2Voice,
                      c.binduReflection, c.witnessPerspective, c.writingPrompt, c.writingReflection,
                      c.mirrorFrequencyInstruction, c.mirrorFrequency, c.subtleMirror, c.voice,
                      c.codexReferences] {
                if let v { XCTAssertFalse(v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "\(c.road)") }
            }
        }
    }

    func testTheMapsOwnWordsAreVerbatim() throws {
        XCTAssertEqual(try chakra(9).signaturePhrase, "please come back home.")
        XCTAssertEqual(try chakra(20).signaturePhrase, "Nothing needed repair. Only arrival.")
        XCTAssertEqual(try chakra(2).coreQuestion, "Am I safe here?")
        XCTAssertEqual(try chakra(33).coreQuestion, "Who is playing?")
        XCTAssertEqual(try chakra(10).gateType, "Sound Response")
        XCTAssertEqual(try chakra(14).gateType, "Tap Rhythm")
        XCTAssertEqual(try chakra(1).codexReferences, "C-1325, C-1337, C-1237")
    }

    /// A bake from before Wave 6 — none of the teaching columns — still decodes,
    /// and the room simply says less.
    func testABakeWithoutTheTeachingStillDecodes() throws {
        let json = """
        {"chakras": [{"road": 1, "recordId": "recKAQWX7yUIB3ktW", "name": "Bindu", "kind": "bindu",
          "kp": [102], "address": "centre"}]}
        """
        let decoded = ChakraConstellation.decode(Data(json.utf8))
        let c = try XCTUnwrap(decoded.first)
        XCTAssertNil(c.coreQuestion)
        XCTAssertNil(c.gateText)
        XCTAssertNil(ChakraTeaching.gate(c.gateText))
        XCTAssertNil(ChakraTeaching.threeWays(c.threeWaysIn))
        XCTAssertTrue(ChakraTeaching.tatTvamAsi(c).isEmpty)
    }

    // MARK: The room, cut where the Map cuts

    func testEveryRoomHasThreeWaysIn() throws {
        for c in baked {
            let ways = try XCTUnwrap(ChakraTeaching.threeWays(c.threeWaysIn), "\(c.road)")
            XCTAssertEqual(ways.ways.count, 3, "road \(c.road) — the Map writes three ways in")
            for w in ways.ways {
                XCTAssertFalse(w.hasPrefix("①") || w.hasPrefix("②") || w.hasPrefix("③"))
                XCTAssertFalse(ChakraTeaching.door(of: w).head.isEmpty)
            }
        }
        XCTAssertNotNil(try ChakraTeaching.threeWays(chakra(20).threeWaysIn)?.intro,
                        "Armin's line before its three ways is kept as the intro")
    }

    func testTheGateNamesItsOwnButton() throws {
        let soles = try XCTUnwrap(ChakraTeaching.gate(chakra(10).gateText))
        XCTAssertEqual(soles.button, "I feel the ground")
        XCTAssertFalse(soles.instruction.contains("Button:"))
        XCTAssertTrue(soles.instruction.hasPrefix("Stand up."))
        let maya = try XCTUnwrap(ChakraTeaching.gate(chakra(30).gateText))
        XCTAssertNil(maya.button, "Maya's gate is one field — the Map gives it no button")
        for c in baked { XCTAssertNotNil(ChakraTeaching.gate(c.gateText), "\(c.road)") }
    }

    func testOnlyASyllableIsSoundedAsABija() throws {
        XCTAssertEqual(ChakraTeaching.soundedSyllable(try chakra(2).bija), "LAM")
        XCTAssertEqual(ChakraTeaching.soundedSyllable(try chakra(10).bija), "LAM")
        XCTAssertEqual(ChakraTeaching.soundedSyllable(try chakra(7).bija), "OM")
        XCTAssertEqual(ChakraTeaching.soundedSyllable(try chakra(15).bija), "HAM")
        for road in [1, 8, 9, 19, 20, 21, 30, 31, 32, 33] {
            XCTAssertNil(ChakraTeaching.soundedSyllable(try chakra(road).bija),
                         "road \(road)'s bīja is words, not a syllable — never sounded as one")
        }
    }

    func testTheHomeDoorFollowsTheAddress() throws {
        XCTAssertEqual(ChakraTeaching.homeDoor(try chakra(10)), .seat(53))
        XCTAssertEqual(ChakraTeaching.homeDoor(try chakra(2)), .ring(1))
        XCTAssertEqual(ChakraTeaching.homeDoor(try chakra(8)), .ring(2), "Sahasrāra presides over the whole ring")
        XCTAssertEqual(ChakraTeaching.homeDoor(try chakra(1)), .seat(102))
        XCTAssertEqual(ChakraTeaching.homeDoor(try chakra(21)), .seat(87))
        XCTAssertNil(ChakraTeaching.homeDoor(try chakra(9)), "a threshold is a crossing, not a Home")
        XCTAssertNil(ChakraTeaching.homeDoor(try chakra(20)))
    }

    func testEachRoomOffersTheGameWaveFourPlacedThere() throws {
        XCTAssertEqual(ChakraTeaching.games(try chakra(9)), [.corridor])
        XCTAssertEqual(ChakraTeaching.games(try chakra(14)), [.pulse, .coherence])
        XCTAssertEqual(ChakraTeaching.games(try chakra(2)), [.rootSystem])
        XCTAssertEqual(ChakraTeaching.games(try chakra(3)), [.waterLevel])
        XCTAssertEqual(ChakraTeaching.games(try chakra(18)), [.spineWalk])
        XCTAssertEqual(ChakraTeaching.games(try chakra(28)), [.door])
        XCTAssertTrue(ChakraTeaching.games(try chakra(20)).isEmpty)
    }

    // MARK: The thresholds, in the Map's own words

    func testArminSaysTatTvamAsiFromItsOwnRow() throws {
        XCTAssertEqual(ChakraTeaching.tatTvamAsi(try chakra(20)), ["Tat", "Tvam", "Asi"])
        XCTAssertTrue(ChakraTeaching.tatTvamAsi(try chakra(9)).isEmpty)
    }

    func testShadowsPhraseIsRevealedInTheMapsOwnOrder() throws {
        XCTAssertEqual(ChakraTeaching.revealOrder(try chakra(9)), ["home", "come", "please", "back"],
                       "Shadow's Act 2 Voice: home / come / please / back — back arriving last")
        // Without that cell, the phrase's own order — nothing is typed in.
        var bare = try chakra(9)
        bare.act2Voice = nil
        XCTAssertEqual(ChakraTeaching.revealOrder(bare), ["please", "come", "back", "home"])
    }

    func testTheRoadStandsThroughTheThresholdsWords() throws {
        let size = CGSize(width: 390, height: 844)
        var seats: [Int: CGPoint] = [:]
        for kp in 1...102 { seats[kp] = ChakraConstellation.canonicalPoint(kp: kp) }
        let stops = ChakraRoad.stops(baked, seats: seats, in: size)
        let shadow = try XCTUnwrap(stops.first { $0.chakra.kind == .shadow })
        XCTAssertGreaterThanOrEqual(ChakraRoad.dwell(at: shadow), ChakraTeaching.thresholdMomentSeconds)
    }

    // MARK: The Road's two stations

    func testTheRoadDwellsAtAtmaAndTheGaiaReveal() throws {
        XCTAssertEqual(ChakraTeaching.station(try chakra(31)), .atma)
        XCTAssertEqual(ChakraTeaching.station(try chakra(32)), .gaiaReveal)
        XCTAssertEqual(baked.compactMap { ChakraTeaching.station($0) }.count, 2)
        let size = CGSize(width: 390, height: 844)
        var seats: [Int: CGPoint] = [:]
        for kp in 1...102 { seats[kp] = ChakraConstellation.canonicalPoint(kp: kp) }
        let stops = ChakraRoad.stops(baked, seats: seats, in: size)
        let atma = try XCTUnwrap(stops.first { $0.chakra.road == 31 })
        let lalita = try XCTUnwrap(stops.first { $0.chakra.road == 33 })
        XCTAssertGreaterThan(ChakraRoad.dwell(at: atma), ChakraRoad.dwell(at: lalita))
        XCTAssertNotNil(atma.chakra.storyThread, "a station shows the Map's own story thread")
    }

    // MARK: The ten body chakras on the Climb

    func testTheTenStandOnTheClimbSoleToCrown() {
        let bodies = ClimbChakras.bodies(baked)
        XCTAssertEqual(bodies.count, 10)
        let h = ClimbChakras.heights(baked)
        XCTAssertEqual(h.count, 10)
        let ordered = bodies.compactMap { h[$0.road] }
        XCTAssertEqual(ordered.first, 0, "Soles stands at the first band (canon A)")
        XCTAssertEqual(ordered.last, 6, "Crow stands at Sahasrāra's band, its Subtle Mirror")
        for (a, b) in zip(ordered, ordered.dropFirst()) { XCTAssertLessThan(a, b) }
        // Soles keeps its other lens: the fourth āvaraṇa in the constellation.
        XCTAssertEqual(bodies.first?.avarana, 4)
    }

    @MainActor
    func testABodyChakraMovesWithTheWalkersOwnHand() {
        XCTAssertEqual(ClimbChakras.screenY(height: 2, here: 2, eyeY: 400), 400)
        XCTAssertEqual(ClimbChakras.screenY(height: 2.5, here: 2, eyeY: 400), 400 - 0.5 * ClimbChakras.pointsPerBand)
        XCTAssertNil(ClimbChakras.screenY(height: 4, here: 2, eyeY: 400), "out of reach, out of the way")
        XCTAssertEqual(ClimbChakras.presence(height: 2, here: 2), 1, accuracy: 1e-9)
        XCTAssertEqual(ClimbChakras.presence(height: 3, here: 2), 0)
        XCTAssertEqual(ClimbChakras.pointsPerBand, WorldClimbView.pointsPerBand,
                       "a band on the glass is a band of the hand")
    }

    // MARK: The body chakras as movement and breath

    func testEachCodexPracticeLivesInItsChakrasRoom() {
        let all = baked
        func roads(_ m: ChakraMovement) -> Set<Int> {
            Set(ChakraMovement.byRoad.filter { $0.value.contains(m) }.map { $0.key })
        }
        XCTAssertEqual(roads(.euphoriaPulse), [13, 14], "Hands and Pulse (C-1311)")
        XCTAssertEqual(roads(.hamHetHum), [6, 15, 16], "Viśuddha, Sonar, Echo (C-1342)")
        XCTAssertEqual(roads(.roarAndSilence), [6, 15])
        XCTAssertEqual(roads(.fearInWaves), [2], "Mūlādhāra (C-1166)")
        XCTAssertEqual(roads(.restlessness), [19])
        XCTAssertEqual(roads(.heartHome), [5])
        XCTAssertEqual(roads(.lastMemories), [17])
        XCTAssertEqual(roads(.feelingThrough), [10])
        for road in ChakraMovement.byRoad.keys {
            XCTAssertNotNil(all.first { $0.road == road }, "road \(road) is not one of the 33")
        }
        XCTAssertEqual(ChakraMovement.breathIndex(forRoad: 16), 0, "Echo receives — HAM")
        XCTAssertEqual(ChakraMovement.breathIndex(forRoad: 6), 1, "Viśuddha holds — HET")
        XCTAssertEqual(ChakraMovement.breathIndex(forRoad: 15), 2, "Sonar transmits — HUM")
        XCTAssertEqual(ChakraMovement.hamHetHum.map(\.syllable), ["HAM", "HET", "HUM"])
    }

    /// Never a score: nothing a practice says counts or measures.
    func testNoPracticeWordMeasures() {
        var words: [String] = []
        for m in ChakraMovement.allCases {
            words.append(m.title)
            words.append(contentsOf: m.lines)
        }
        words.append(contentsOf: ChakraMovement.hamHetHum.compactMap(\.line))
        for w in words {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(w).isEmpty, "\"\(w)\" measures")
            XCTAssertNil(w.rangeOfCharacter(from: .decimalDigits), "\"\(w)\" carries a digit")
        }
    }

    func testShakingChargesAndAPauseIsNotALoss() {
        var c = 0.0
        for _ in 0..<60 { c = ChakraMovement.charge(c, shake: 1.2, dt: 1.0 / 60) }
        XCTAssertGreaterThan(c, 0.5)
        let held = c
        c = ChakraMovement.charge(c, shake: 0, dt: 1.0 / 60)
        XCTAssertGreaterThan(c, held * 0.9, "a still hand lets it ebb slowly")
        XCTAssertEqual(ChakraMovement.charge(0, shake: 0, dt: 1), 0, "never below nothing")
    }

    // MARK: The ledger — one row, and Link to The Map

    func testAPracticeIsOneRowLinkedToItsChakra() throws {
        let soles = try chakra(10)
        let at = Date(timeIntervalSince1970: 1_791_800_000)
        let row = ActivityLedger.chakraPracticed(mapRecordId: soles.recordId, chakraName: soles.name,
                                                 practice: ChakraMovement.feelingThrough.title,
                                                 mandalaLink: "recSHAKTI00000053", words: nil,
                                                 seconds: 42, at: at)
        XCTAssertEqual(row.type, ActivityLedger.ActivityType.chakraPracticed)
        XCTAssertEqual(row.type, "Chakra Practiced")
        let f = ActivityLedger.fields(for: row)
        XCTAssertEqual(f["Link to The Map"] as? [String], [soles.recordId])
        XCTAssertEqual(f["Link to Mandala"] as? [String], ["recSHAKTI00000053"])
        XCTAssertEqual(f["Gesture Source"] as? String, "Mandala")
        XCTAssertEqual(f["Source App"] as? String, "Mandala")
        XCTAssertNil(f["Notes"], "no words given, no Notes")
        XCTAssertEqual(f["Duration (sec)"] as? Double, 42)
    }

    func testAThresholdPracticeIsFiledByItsMapLinkAlone() throws {
        let shadow = try chakra(9)
        let row = ActivityLedger.chakraPracticed(mapRecordId: shadow.recordId, chakraName: shadow.name,
                                                 practice: "the gate", mandalaLink: "",
                                                 words: "  a word given to the dark  ", seconds: nil, at: .now)
        let f = ActivityLedger.fields(for: row)
        XCTAssertNil(f["Link to Mandala"])
        XCTAssertEqual(f["Link to The Map"] as? [String], [shadow.recordId])
        XCTAssertEqual(f["Notes"] as? String, "a word given to the dark", "his words, trimmed, untouched")
    }

    func testTheMapDedupMatchesOnlyItsOwnSecond() throws {
        let at = Date(timeIntervalSince1970: 1_791_800_000)
        let stamp = RecognitionDedup.writtenFeltAt(at)
        let json = """
        {"id": "recROW", "fields": {"Link to The Map": ["recMAP"], "Felt At": "\(stamp)"}}
        """
        let row = try JSONDecoder().decode(ActivityLedger.Row.self, from: Data(json.utf8))
        XCTAssertEqual(row.fields.linkToMap, ["recMAP"])
        XCTAssertTrue(ActivityLedger.mapRowMatches(row, mapRecordId: "recMAP", feltAt: at))
        XCTAssertFalse(ActivityLedger.mapRowMatches(row, mapRecordId: "recOTHER", feltAt: at))
        XCTAssertFalse(ActivityLedger.mapRowMatches(row, mapRecordId: "recMAP", feltAt: at.addingTimeInterval(1)))
        XCTAssertEqual(ActivityLedger.mapDedupFields, ["Link to The Map", "Felt At"])
    }

    /// Never dropped from the offline queue: a queue written before Wave 6
    /// still decodes, and the Map link survives the round trip.
    func testTheQueueKeepsTheMapLinkAndStillReadsOldItems() throws {
        var item = ActivityLedger.chakraPracticed(mapRecordId: "recMAP", chakraName: "Soles",
                                                  practice: "the gate", mandalaLink: "", words: nil,
                                                  seconds: nil, at: Date(timeIntervalSince1970: 1_791_800_000))
        let round = try JSONDecoder().decode(PendingActivity.self, from: JSONEncoder().encode(item))
        XCTAssertEqual(round.linkToMap, ["recMAP"])
        XCTAssertEqual(round, item)

        item.linkToMap = nil
        var old = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(item)) as? [String: Any])
        old.removeValue(forKey: "linkToMap")
        let legacy = try JSONDecoder().decode(PendingActivity.self,
                                              from: JSONSerialization.data(withJSONObject: old))
        XCTAssertNil(legacy.linkToMap)
        XCTAssertNil(ActivityLedger.fields(for: legacy)["Link to The Map"])
    }

    func testNothingAChakraRowSaysMeasures() {
        let at = Date(timeIntervalSince1970: 1_791_800_000)
        let practices = ChakraMovement.allCases.map(\.title) + ["the gate", ""]
        for c in baked {
            for p in practices {
                let row = ActivityLedger.chakraPracticed(mapRecordId: c.recordId, chakraName: c.name,
                                                         practice: p, mandalaLink: "", words: nil,
                                                         seconds: 12, at: at)
                XCTAssertTrue(NeverMeasure.measuresOutLoud(row.name).isEmpty, row.name)
                XCTAssertTrue(NeverMeasure.measuresOutLoud(row.detail).isEmpty, row.detail)
            }
        }
    }
}
