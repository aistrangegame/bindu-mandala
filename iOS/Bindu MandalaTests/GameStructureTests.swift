import XCTest
@testable import Bindu_Mandala

/// Wave 6 · B · the game's own structure — the pure logic under it: the bake of
/// his words, the Tree of Life's tables and curves, Leela's rarity, the
/// Trinity's places, the activation cycle's recession, the three pools, and
/// the conductor's arbitration.
final class GameStructureTests: XCTestCase {

    private var baked: GameStructure.File {
        let url = SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Data/GameStructure.json")
        guard let data = try? Data(contentsOf: url) else { return .empty }
        return GameStructure.decode(data)
    }

    // MARK: The bake — his words

    func testTheBakeHoldsTheNinePanelsInRingOrder() {
        XCTAssertEqual(baked.panels.map(\.ring), Array(1...9))
        XCTAssertEqual(baked.panels.map(\.verb), TreeOfLife.verbs,
                       "the Identity rows' verbs and the Tree of Life's nine have drifted apart")
        for p in baked.panels {
            XCTAssertFalse(p.declaration.isEmpty, "panel \(p.ring) has no declaration")
            XCTAssertFalse(p.seed.isEmpty, "panel \(p.ring) has no seed message")
        }
        XCTAssertEqual(GameStructure.file.panels.count, 9, "the bundled bake should load all nine")
    }

    func testTheFiveFacesEachHaveTheirOneLine() {
        XCTAssertEqual(Set(baked.faces.map(\.face)), Set(GuideFace.allCases.map(\.rawValue)))
        for f in baked.faces { XCTAssertFalse(f.line.isEmpty, "\(f.face) has no line") }
    }

    func testEveryLeelaDropEndsInAnActionAndNoneMeasures() {
        XCTAssertGreaterThanOrEqual(baked.leelaDrops.count, 6)
        XCTAssertEqual(Set(baked.leelaDrops.map(\.id)).count, baked.leelaDrops.count, "a drop id repeats")
        for d in baked.leelaDrops {
            XCTAssertFalse(d.lead.isEmpty)
            XCTAssertFalse(d.action.isEmpty)
            XCTAssertNotNil(GuideFace(rawValue: d.voice), "\(d.id) speaks in no face")
            XCTAssertTrue(NeverMeasure.measuresOutLoud(d.lead + " " + d.action).isEmpty, d.id)
        }
        // The sealed rows — the Reveal and the convergence — are never drawn from.
        for sealed in ["Ego Reveal", "Lalita"] {
            XCTAssertFalse(baked.leelaDrops.contains { $0.chakra == sealed }, "\(sealed) is sealed")
        }
    }

    // MARK: The Tree of Life

    func testTheRingsAnswerLessAsTheyDeepen() {
        for r in 1...5 { XCTAssertNotNil(TreeOfLife.answer(ring: r).pressSeconds, "ring \(r)") }
        for r in 6...8 { XCTAssertNotNil(TreeOfLife.answer(ring: r).stillnessSeconds, "ring \(r)") }
        XCTAssertEqual(TreeOfLife.answer(ring: 9), .none, "the source is not reached by doing")
        let presses = (1...5).compactMap { TreeOfLife.answer(ring: $0).pressSeconds }
        XCTAssertEqual(presses, presses.sorted(), "the hold should lengthen inward")
        XCTAssertGreaterThan(TreeOfLife.holdSeconds(ring: 7), 600, "a stillness ring is never held for")
    }

    func testTheGuidesWordsAreGoneByTheSeventh() {
        let words = (1...9).map { TreeOfLife.guideWords(ring: $0) }
        XCTAssertEqual(words.first, 1)
        XCTAssertEqual(words, words.sorted(by: >), "the guide's words should only thin")
        for r in 7...9 { XCTAssertEqual(TreeOfLife.guideWords(ring: r), 0, "ring \(r)") }
    }

    func testTheBreathArcTakesItsOwnLabelsAway() {
        XCTAssertEqual(TreeOfLife.breath(ring: 1)?.phases.compactMap(\.label), ["in", "hold", "out"])
        XCTAssertEqual(TreeOfLife.breath(ring: 6)?.phases.compactMap(\.label), ["in", "see"])
        XCTAssertEqual(TreeOfLife.breath(ring: 7)?.phases.compactMap(\.label), [], "P7 says nothing")
        XCTAssertNil(TreeOfLife.breath(ring: 8))
        XCTAssertNil(TreeOfLife.breath(ring: 9))
        XCTAssertEqual(TreeOfLife.breath(ring: 1)?.seconds, 36)
    }

    func testTheBreathArcViewFollowsTheBreath() throws {
        let arc = try XCTUnwrap(TreeOfLife.breath(ring: 1))
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 2).fill, 0.5, accuracy: 1e-9)
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 2).label, "in")
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 6).fill, 1, accuracy: 1e-9)
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 6).label, "hold")
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 10).fill, 0.5, accuracy: 1e-9)
        XCTAssertEqual(BreathArcView.moment(arc: arc, at: 99).presence, 0, "the arc ends")
    }

    func testTheLightBuildsFromFivePerCentToTheWhole() {
        XCTAssertEqual(TreeOfLife.luminance(ring: 0), 0)
        XCTAssertEqual(TreeOfLife.luminance(ring: 1), 0.05, accuracy: 1e-9)
        XCTAssertEqual(TreeOfLife.luminance(ring: 8), 0.90, accuracy: 1e-9)
        XCTAssertEqual(TreeOfLife.luminance(ring: 9), 1, accuracy: 1e-9)
        let curve = (0...9).map { TreeOfLife.luminance(ring: $0) }
        XCTAssertEqual(curve, curve.sorted(), "the light should only build inward")
    }

    func testTheOmIsTheEarthsOwnPitchAndRisesWithDepth() {
        XCTAssertEqual(TreeOfLife.omHz, 136.1, accuracy: 1e-9)
        XCTAssertEqual(TreeOfLife.omPartials.map { $0.0 }, [272.2, 68.05])
        let floors = (0...9).map { TreeOfLife.omFloor(depth: $0) }
        XCTAssertEqual(floors, floors.sorted())
        XCTAssertGreaterThan(floors[0], 0, "the Om is always playing")
        XCTAssertLessThan(floors[9], 0.05, "the Om is a floor, never a crescendo of its own")
    }

    func testPanelNineUndoesTheEightAndNamesNothing() {
        XCTAssertEqual(TreeOfLife.dissolutions.map(\.ring), Array(1...8))
        XCTAssertEqual(Set(TreeOfLife.dissolutions.map(\.instruction)).count, 8)
        XCTAssertFalse(TreeOfLife.theBinduIsNamed, "the naming is the veil")
        XCTAssertEqual(TreeOfLife.nowGoPlay, "Now go play.")
        XCTAssertEqual(TreeOfLife.legibility(ring: 1), 1, accuracy: 1e-9)
        XCTAssertLessThan(TreeOfLife.legibility(ring: 9), 0.2)
    }

    // MARK: Leela

    func testALeelaDropIsRareAndNeverTwiceInADay() {
        // Never in the first days, never twice a day, never within the gap.
        XCTAssertFalse(LeelaDrops.shouldDrop(today: 10, firstSeenDay: 9, lastDropDay: nil,
                                             lastConsideredDay: nil, roll: 0))
        XCTAssertTrue(LeelaDrops.shouldDrop(today: 12, firstSeenDay: 9, lastDropDay: nil,
                                            lastConsideredDay: nil, roll: 0))
        XCTAssertFalse(LeelaDrops.shouldDrop(today: 12, firstSeenDay: 9, lastDropDay: nil,
                                             lastConsideredDay: 12, roll: 0))
        XCTAssertFalse(LeelaDrops.shouldDrop(today: 14, firstSeenDay: 0, lastDropDay: 12,
                                             lastConsideredDay: nil, roll: 0))
        // Even past the gap, only by chance.
        XCTAssertFalse(LeelaDrops.shouldDrop(today: 30, firstSeenDay: 0, lastDropDay: 12,
                                             lastConsideredDay: nil, roll: 0.99))
        // Over a long run, at most one every few days.
        var last: Int? = nil
        var considered: Int? = nil
        var drops: [Int] = []
        var rng = SystemRandomNumberGenerator()
        for day in 0..<2000 {
            for _ in 0..<3 {   // three openings a day
                let go = LeelaDrops.shouldDrop(today: day, firstSeenDay: 0, lastDropDay: last,
                                               lastConsideredDay: considered,
                                               roll: Double.random(in: 0..<1, using: &rng))
                considered = day
                if go { last = day; drops.append(day) }
            }
        }
        for (a, b) in zip(drops, drops.dropFirst()) {
            XCTAssertGreaterThanOrEqual(b - a, LeelaDrops.minimumGapDays)
        }
        XCTAssertLessThan(Double(drops.count), 2000.0 / Double(LeelaDrops.minimumGapDays))
    }

    func testTheSameDropNeverComesTwiceInARow() {
        let drops = baked.leelaDrops
        guard let first = drops.first else { return XCTFail("no drops baked") }
        for roll in stride(from: 0.0, to: 1.0, by: 0.05) {
            XCTAssertNotEqual(LeelaDrops.choose(from: drops, after: first.id, roll: roll)?.id, first.id)
        }
        XCTAssertNil(LeelaDrops.choose(from: [], after: nil, roll: 0.5))
    }

    func testTheLeelaRowGradesNothing() {
        let carried = ActivityLedger.leelaDrop(chakra: "Forge", carried: true, at: Date())
        let held = ActivityLedger.leelaDrop(chakra: "Forge", carried: false, at: Date())
        XCTAssertEqual(carried.type, ActivityLedger.ActivityType.leelaDrop)
        XCTAssertTrue(carried.linkRecordId.isEmpty, "The Map is not the Mandala table")
        XCTAssertNil(carried.notes, "the words were the game's, not his")
        for row in [carried, held] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(row.name + " " + row.detail).isEmpty)
        }
        let light = ActivityLedger.lightEntered(shaktiRecordId: "recX", name: "Aṇimā",
                                                family: "earth", seconds: 42, at: Date())
        XCTAssertEqual(light.type, ActivityLedger.ActivityType.lightEntered)
        XCTAssertEqual(light.gestureSource, ActivityLedger.GestureSource.room)
        XCTAssertTrue(NeverMeasure.measuresOutLoud(light.name + " " + light.detail).isEmpty)
    }

    // MARK: The Trinity of Guidance

    func testEachFaceSpeaksAtItsOwnPlace() {
        XCTAssertEqual(TrinityOfGuidance.face(at: .room(kp: 31)), .gaia)
        XCTAssertEqual(TrinityOfGuidance.face(at: .room(kp: 42)), .higherSelf)
        XCTAssertNil(TrinityOfGuidance.face(at: .room(kp: 30)))
        XCTAssertEqual(TrinityOfGuidance.face(at: .climb(ring: 1)), .bindu)
        XCTAssertEqual(TrinityOfGuidance.face(at: .climb(ring: 9)), .lalita)
        XCTAssertNil(TrinityOfGuidance.face(at: .climb(ring: 5)))
        XCTAssertEqual(TrinityOfGuidance.face(at: .descent(ring: 7)), .sakshi)
        XCTAssertNil(TrinityOfGuidance.face(at: .descent(ring: 6)))
        XCTAssertEqual(GuideFace.gaia.axis, .ground)
        XCTAssertEqual(GuideFace.lalita.axis, .player)
        XCTAssertEqual(GuideFace.higherSelf.axis, .witness)
    }

    func testAFaceSpeaksOnceADay() throws {
        let suite = "GameStructureTests.trinity"
        let d = try XCTUnwrap(UserDefaults(suiteName: suite))
        d.removePersistentDomain(forName: suite)
        XCTAssertTrue(TrinityOfGuidance.claimSpeaking(.gaia, defaults: d, today: 5))
        XCTAssertFalse(TrinityOfGuidance.claimSpeaking(.gaia, defaults: d, today: 5))
        XCTAssertTrue(TrinityOfGuidance.claimSpeaking(.sakshi, defaults: d, today: 5))
        XCTAssertTrue(TrinityOfGuidance.claimSpeaking(.gaia, defaults: d, today: 6))
        d.removePersistentDomain(forName: suite)
    }

    // MARK: Knowledge — Will — Action

    func testTheGestureRecedesToNothingByTheSeventhRing() {
        XCTAssertEqual(ActivationCycle.family(element: .fire, ring: 5), .fire)
        XCTAssertEqual(ActivationCycle.family(element: .water, ring: 4), .water)
        for r in 7...9 {
            XCTAssertEqual(ActivationCycle.family(element: .fire, ring: r), .presence, "ring \(r)")
        }
        XCTAssertGreaterThan(ActivationCycle.need(.fire, ring: 1, kp: 3),
                             ActivationCycle.need(.fire, ring: 5, kp: 3),
                             "the will asks less as the rings deepen")
        XCTAssertEqual(Set(GestureFamily.allCases.map(\.willed)).count, GestureFamily.allCases.count)
    }

    func testHerJitterIsHersAndSmall() {
        let all = (1...102).map { ActivationCycle.jitter(kp: $0) }
        for j in all { XCTAssertTrue((0.85...1.15).contains(j)) }
        XCTAssertGreaterThan(Set(all.map { ($0 * 1000).rounded() }).count, 50,
                             "fourteen fire-Śaktis should not all feel alike")
    }

    func testPatienceMakesHerAnswerFullerAndNeverBelowAFloor() {
        let need = 3.0
        XCTAssertEqual(ActivationCycle.fullness(.fire, need: need, given: need), 0.6, accuracy: 1e-9)
        XCTAssertEqual(ActivationCycle.fullness(.fire, need: need, given: need * 1.5), 1, accuracy: 1e-9)
        XCTAssertEqual(ActivationCycle.fullness(.light, need: 2.4, given: 0), 1, accuracy: 1e-9)
        XCTAssertGreaterThanOrEqual(ActivationCycle.fullness(.light, need: 2.4, given: 0.22), 0.4)
        XCTAssertEqual(ActivationCycle.fromPeak(t: 1.2, period: 2.4), 0, accuracy: 1e-9)
    }

    // MARK: The three pools

    func testBeingRefreshesEachDayAndNeverTallies() {
        let a = ThreePools.adding(.bellOpened, to: [])
        XCTAssertEqual(ThreePools.adding(.bellOpened, to: a), a, "being is a state, not a tally")
        XCTAssertEqual(ThreePools.refreshed(kept: a, keptDay: 3, today: 3), a)
        XCTAssertEqual(ThreePools.refreshed(kept: a, keptDay: 3, today: 4), [], "being refreshes")
        XCTAssertEqual(ThreePools.pool(forActivityType: ActivityLedger.ActivityType.played), .memory)
        XCTAssertEqual(ThreePools.surface(forActivityType: ActivityLedger.ActivityType.letterSealed), .well)
        XCTAssertEqual(ThreePools.surface(forActivityType: ActivityLedger.ActivityType.leelaDrop), .well)
        XCTAssertEqual(ThreePools.surface(forActivityType: ActivityLedger.ActivityType.shaktiRecognized),
                       .portrait)
        XCTAssertEqual(ThreePools.surface(for: .essence), .none)
    }

    // MARK: One sound at a time

    func testOneBedSoundsAndTheRestAreHeldAtNothing() {
        let g = SoundArbiter.gains(beds: [.field, .room], accenting: false)
        XCTAssertEqual(g[.room], 1, "her room stands in front of the field")
        XCTAssertEqual(g[.field], 0, "the field is held, not piled under the room")
        XCTAssertEqual(g[.om], SoundArbiter.omUnderBed)

        let game = SoundArbiter.gains(beds: [.field, .room, .play], accenting: false)
        XCTAssertEqual(game[.play], 1)
        XCTAssertEqual(game[.room], 0)
        XCTAssertEqual(game[.field], 0)

        let alone = SoundArbiter.gains(beds: [], accenting: false)
        XCTAssertEqual(alone[.om], 1, "with nothing else sounding, the Om is heard — noise decreasing")

        let struck = SoundArbiter.gains(beds: [.field], accenting: true)
        XCTAssertEqual(struck[.field], SoundArbiter.bedUnderAccent, "a struck bīja ducks the bed")
        XCTAssertEqual(struck[.om], 0)
        XCTAssertEqual(struck[.bija], 1)

        // Never more than one bed at full voice, whatever is asking.
        let beds: [SoundVoice] = [.field, .room, .play]
        for mask in 0..<8 {
            let asking = Set(beds.enumerated().filter { mask & (1 << $0.offset) != 0 }.map(\.element))
            let full = SoundArbiter.gains(beds: asking, accenting: false)
                .filter { $0.key.role == .bed && $0.value > 0 }
            XCTAssertLessThanOrEqual(full.count, 1, "\(asking) sounds \(full.count) beds at once")
        }
    }

    /// Wave 6.1 · his decision (gameplan §4.6): on the Climb the ring voices
    /// stand in front; the room's drone waits for the room. The Om stays beneath.
    func testOnTheClimbTheRingVoicesStandInFront() {
        let climb = SoundArbiter.gains(beds: [.field, .room], accenting: false, climbing: true)
        XCTAssertEqual(climb[.field], 1, "the ring voices in front on the climb")
        XCTAssertEqual(climb[.room], 0, "the grounds wait for the room")
        XCTAssertEqual(climb[.om], SoundArbiter.omUnderBed, "the Om beneath")

        let room = SoundArbiter.gains(beds: [.room], accenting: false, climbing: false)
        XCTAssertEqual(room[.room], 1, "in her room, her room's voice")

        let heart = SoundArbiter.gains(beds: [.field, .room, .play, .heart], accenting: false)
        XCTAssertEqual(heart[.heart], 1, "the heart register he chose stands in front")
        XCTAssertEqual(heart[.play], 0)
    }

    func testTheOmFollowsDepthAndPanelNinesSwell() {
        XCTAssertEqual(SoundArbiter.omLevel(depth: 3, multiplier: 1, swell: nil),
                       TreeOfLife.omFloor(depth: 3), accuracy: 1e-9)
        XCTAssertEqual(SoundArbiter.omLevel(depth: 3, multiplier: 0, swell: nil), 0)
        XCTAssertGreaterThan(SoundArbiter.omLevel(depth: 0, multiplier: 1, swell: 1),
                             SoundArbiter.omLevel(depth: 0, multiplier: 1, swell: 0))
    }

    // MARK: The bells

    func testTheOpeningBellRingsOnceADay() {
        XCTAssertTrue(TheBells.opens(lastOpenedDay: nil, today: 4))
        XCTAssertFalse(TheBells.opens(lastOpenedDay: 4, today: 4))
        XCTAssertTrue(TheBells.opens(lastOpenedDay: 3, today: 4))
        XCTAssertEqual(TheBells.closingHz, 136.1, accuracy: 1e-9)
        XCTAssertEqual(TheBells.openingHz, 272.2, accuracy: 1e-9)
    }
}
