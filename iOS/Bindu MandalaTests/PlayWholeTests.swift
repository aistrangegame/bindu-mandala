import XCTest
import CoreGraphics
import simd
@testable import Bindu_Mandala

// MARK: - Wave 6 · Slice E — every game
//
// The physics of the twenty games Wave 6 brings home, the store they leave
// behind on the phone, Lalitā's field holding all thirty-six, and the Ring
// Worlds mechanisms reborn on the climb. The screen laws (no digit, no red,
// no verdict, no store of its own) are `PlayScreenTests`, which already read
// every file in `Views/Play/` — the new games included.

final class PlayWholePhysicsTests: XCTestCase {

    func testEveryGameHasAModelAndWords() {
        for g in PlayGame.allCases {
            _ = PlayModels.make(g, startPosition: nil)
            XCTAssertFalse(g.title.isEmpty)
            XCTAssertFalse(g.verb.isEmpty)
            XCTAssertFalse(Rx.matches(#"\d"#, g.hint), "\(g) hint carries a digit")
            XCTAssertFalse(Rx.matches(#"\d"#, g.verb), "\(g) verb carries a digit")
        }
    }

    func testTheSeedGrowsByRealTimeAndIsPlantedOnlyByAStillPress() {
        XCTAssertEqual(SeedGrowth.stage(hours: 0.5), .seed)
        XCTAssertEqual(SeedGrowth.stage(hours: 3), .sprout)
        XCTAssertEqual(SeedGrowth.stage(hours: 12), .sapling)
        XCTAssertEqual(SeedGrowth.stage(hours: 30), .tree)
        XCTAssertEqual(SeedGrowth.stage(hours: 80), .bloom)
        XCTAssertLessThan(SeedGrowth.growth(hours: 2), SeedGrowth.growth(hours: 40))
        XCTAssertEqual(SeedGrowth.growth(hours: 500), 1, accuracy: 1e-9)

        var restless = SeedPress()
        for _ in 0..<600 { restless.step(dt: 1.0 / 60, pressing: true, stillness: 0) }
        XCTAssertFalse(restless.planted, "a press that never rests plants nothing")
        var still = SeedPress()
        for _ in 0..<120 { still.step(dt: 1.0 / 60, pressing: true, stillness: 1) }
        let reached = still.sunk
        for _ in 0..<300 { still.step(dt: 1.0 / 60, pressing: false, stillness: 1) }
        XCTAssertEqual(still.sunk, reached, "lifting the finger takes nothing back")
        for _ in 0..<120 { still.step(dt: 1.0 / 60, pressing: true, stillness: 1) }
        XCTAssertTrue(still.planted)
    }

    func testTheTwelveCloseOnlyAsTheCircleOfFifths() {
        XCTAssertTrue(TwelveCircle(order: Array(0..<12)).isWhole)
        XCTAssertTrue(TwelveCircle(order: Array((0..<12).reversed())).isWhole, "either way round")
        for seed in UInt64(0)..<40 {
            let c = TwelveCircle(seed: seed)
            XCTAssertFalse(c.isWhole, "a scrambled board never opens already whole")
            XCTAssertEqual(Set(c.order), Set(0..<12))
        }
        var c = TwelveCircle(order: [1, 0] + Array(2..<12))
        XCTAssertFalse(c.isWhole)
        c.swap(0, 1)
        XCTAssertTrue(c.isWhole)
        for k in 0..<12 {
            let f = TwelveCircle.frequency(tone: k)
            XCTAssertGreaterThanOrEqual(f, 272.2 - 1e-6)
            XCTAssertLessThan(f, 544.4)
        }
    }

    func testTheBodyIsListenedToAndEveryMarkIsWelcome() {
        XCTAssertNil(BodyListening.mark(meanPressure: 0.4, rested: 0.5), "a passing touch leaves no mark")
        XCTAssertEqual(BodyListening.mark(meanPressure: 0.05, rested: 2), .open)
        XCTAssertEqual(BodyListening.mark(meanPressure: 0.3, rested: 2), .alive)
        XCTAssertEqual(BodyListening.mark(meanPressure: 0.9, rested: 2), .held)
        XCTAssertEqual(BodyMapModel.centres.count, 10, "the ten body chakras of The Map")
    }

    func testTheBurdenTurnsOverAtThePaceOfFeelingAndStaysTurned() {
        var coin = TurningWord()
        coin.turn(by: 40)
        coin.step(dt: 0.1)
        XCTAssertFalse(coin.turned, "a rushed circle leaves the coin behind")
        XCTAssertLessThanOrEqual(coin.face, TurningWord.maxRate * 0.1 + 1e-9)
        for _ in 0..<200 { coin.step(dt: 0.05) }
        XCTAssertTrue(coin.turned)
        coin.step(dt: 1)
        XCTAssertEqual(coin.face, Double.pi, accuracy: 1e-9)
        // The same burden always turns into the same gift, one of the ten Siddhis.
        for w in ["fear", "anger", "the deadline", "Fear"] {
            let kp = ShadowTranslatorModel.gift(for: w)
            XCTAssertTrue((1...10).contains(kp), w)
            XCTAssertEqual(kp, ShadowTranslatorModel.gift(for: w))
        }
        XCTAssertEqual(ShadowTranslatorModel.gift(for: "fear"), ShadowTranslatorModel.gift(for: "FEAR"))
    }

    func testTheWordFallsThroughSevenLensesAndAMissOnlyRisesAgain() {
        var maze = MazeFall()
        var bounces = 0
        for _ in 0..<(120 * 60) {
            let target = MazeFall.lens(min(maze.passed, MazeFall.lenses - 1)).centre
            let before = maze.bounce
            maze.step(dt: 1.0 / 60, steer: (target - maze.x) * 3)
            if maze.bounce > before + 0.5 { bounces += 1 }
            if maze.through { break }
        }
        XCTAssertTrue(maze.through)
        var stray = MazeFall()
        for _ in 0..<(10 * 60) { stray.step(dt: 1.0 / 60, steer: 1) }
        XCTAssertGreaterThanOrEqual(stray.passed, 0)
        XCTAssertLessThan(stray.passed, MazeFall.lenses, "hard against the wall, the light waits above a lens")
    }

    func testTheLetterFoldsAndTheWaxSetsUnderAnyPress() {
        var fold = LetterFold()
        fold.pull(toward: 1, dt: 0.1)
        XCTAssertLessThan(fold.folded, 0.1, "a rushed pull folds only as far as a page folds")
        for _ in 0..<120 { fold.pull(toward: 1, dt: 1.0 / 60) }
        XCTAssertTrue(fold.isFolded)
        fold.pull(toward: 0, dt: 1)
        XCTAssertTrue(fold.isFolded, "a fold is never undone")
        var light = WaxSeal(), hard = WaxSeal()
        for _ in 0..<60 { light.press(dt: 1.0 / 60, pressure: 0.1); hard.press(dt: 1.0 / 60, pressure: 9) }
        XCTAssertGreaterThan(hard.warmth, light.warmth, "a harder press warms faster")
        for _ in 0..<600 { light.press(dt: 1.0 / 60, pressure: 0.1) }
        XCTAssertTrue(light.isSet, "never wrongly: a light press sets it too")
    }

    func testAFlashIsCaughtOnlyWhileItIsThere() {
        let p = CGPoint(x: 100, y: 100)
        XCTAssertTrue(FlashCatch.caught(tap: CGPoint(x: 120, y: 110), flash: p, since: 0.3))
        XCTAssertFalse(FlashCatch.caught(tap: CGPoint(x: 120, y: 110), flash: p, since: 2))
        XCTAssertFalse(FlashCatch.caught(tap: CGPoint(x: 300, y: 300), flash: p, since: 0.3))
    }

    func testTheDarkDeepensOnlyInStillnessAndNeverLifts() {
        var d = WaitingDark()
        for _ in 0..<600 { d.step(dt: 1.0 / 60, still: false) }
        XCTAssertEqual(d.dark, 0)
        for _ in 0..<600 { d.step(dt: 1.0 / 60, still: true) }
        let reached = d.dark
        for _ in 0..<600 { d.step(dt: 1.0 / 60, still: false) }
        XCTAssertEqual(d.dark, reached)
        for _ in 0..<(30 * 60) { d.step(dt: 1.0 / 60, still: true) }
        XCTAssertTrue(d.isDeep)
    }

    func testTatTvamAsiArrivesWordByWordAndThenAsOne() {
        var t = ThreeWords()
        t.bringTogether(distance: 10)
        XCTAssertFalse(t.joined, "the three are joined only once all three have come")
        for _ in 0..<3 {
            for _ in 0..<170 { t.step(dt: 1.0 / 60, holding: true) }
            for _ in 0..<10 { t.step(dt: 1.0 / 60, holding: false) }
        }
        XCTAssertTrue(t.allArrived)
        t.bringTogether(distance: 300)
        XCTAssertFalse(t.joined)
        t.bringTogether(distance: 20)
        XCTAssertTrue(t.joined)
    }

    func testTheScrollsUnrollAtTheirOwnPace() {
        XCTAssertEqual(ScrollUnroll.lines.last, "You are a bigger container now.")
        XCTAssertEqual(ScrollUnroll.lines.count, 12)
        var s = ScrollUnroll()
        s.pull(dy: 1000, dt: 0.1)
        XCTAssertLessThanOrEqual(s.unrolled, ScrollUnroll.maxRate * 0.1 / ScrollUnroll.pullPerLine + 1e-9)
        s.pull(dy: -500, dt: 0.1)
        XCTAssertGreaterThan(s.unrolled, 0, "pulling back takes nothing back")
        for _ in 0..<2000 { s.pull(dy: 3, dt: 1.0 / 60) }
        XCTAssertTrue(s.isOpen)
    }

    func testTheRiversMingleOnlyWhereColoursMeet() {
        var m = RiverMingle()
        m.flow(overlap: 0, dt: 100)
        XCTAssertEqual(m.mingled, 0)
        for _ in 0..<(20 * 60) { m.flow(overlap: 1, dt: 1.0 / 60) }
        XCTAssertTrue(m.reachedSea)
        let mix = RiverColours.blend((1, 0, 0), (0, 0, 1))
        XCTAssertEqual(mix.0, 0.5, accuracy: 1e-9)
        XCTAssertEqual(mix.2, 0.5, accuracy: 1e-9)
    }

    func testTheWorldKeepsObjectsNeverTotalsAndGiftsAreNeverADebt() {
        XCTAssertEqual(WorldBox.thing(forGame: "fingerGarden"), .plant)
        XCTAssertEqual(WorldBox.thing(forGame: "seed"), .tree)
        XCTAssertEqual(WorldBox.thing(forGame: "rosary"), .firefly)
        XCTAssertEqual(WorldBox.thing(forGame: "something new"), .stone)
        let now = Date(timeIntervalSince1970: 1_791_000_000)
        XCTAssertEqual(WorldBox.gifts(lastVisit: nil, now: now), 1, "the first visit brings one gift")
        XCTAssertEqual(WorldBox.gifts(lastVisit: now.addingTimeInterval(-3600), now: now), 0)
        XCTAssertEqual(WorldBox.gifts(lastVisit: now.addingTimeInterval(-2.5 * 86_400), now: now), 2)
        XCTAssertEqual(WorldBox.gifts(lastVisit: now.addingTimeInterval(-90 * 86_400), now: now), 3,
                       "a long absence brings a little, never a pile")
        for i in 0..<200 {
            let p = WorldBox.place(i)
            XCTAssertTrue((0...1).contains(p.x) && (0...1).contains(p.z), "object \(i) stands outside the box")
        }
    }

    func testLeelaCannotBeLostOnlyNotYetArrived() {
        var w = LeelaWalk()
        XCTAssertEqual(w.throwDie(3), .unbornRests)
        XCTAssertNil(w.square)
        XCTAssertEqual(w.throwDie(6), .born, "a six brings him in")
        XCTAssertEqual(w.square, 1)
        XCTAssertEqual(w.throwDie(4), .arrow(from: 5, to: 8))
        XCTAssertEqual(w.square, 8)
        XCTAssertEqual(w.throwDie(4), .arrow(from: 12, to: 18))
        XCTAssertEqual(w.throwDie(2), .walked(to: 20))
        var s = LeelaWalk()
        _ = s.throwDie(6)
        _ = s.throwDie(5)                       // 6
        _ = s.throwDie(3)                       // 9
        _ = s.throwDie(6)                       // 15 → the snake
        XCTAssertEqual(s.square, 6, "a snake is a turn of the road, not a loss")
        // Exact landing at Lalitā; an overshoot rests.
        var e = LeelaWalk()
        _ = e.throwDie(6)
        for n in [6, 6, 6, 6, 6] { _ = e.throwDie(n) }
        XCTAssertFalse(e.arrived)
        var guardRail = 0
        while !e.arrived && guardRail < 400 {
            guardRail += 1
            let need = LeelaBoard.squares - (e.square ?? 0)
            _ = e.throwDie(min(6, max(1, need)))
        }
        XCTAssertTrue(e.arrived)
        XCTAssertEqual(e.throwDie(6), .rests)
        XCTAssertEqual(LeelaBoard.held, 32)
        for (from, to) in LeelaBoard.arrows { XCTAssertGreaterThan(to, from) }
        for (from, to) in LeelaBoard.snakes { XCTAssertLessThan(to, from) }
        XCTAssertEqual(LeelaWalk.spot(1).radius, 0, accuracy: 1e-9)
        XCTAssertEqual(LeelaWalk.spot(33).radius, 0, accuracy: 1e-9, "the road ends at the point it began")
    }

    func testTheRingsAlignOnlyAtRestWithTheirMarksMet() {
        var t = TurningRings(angles: [0, 0, 0])
        XCTAssertTrue(t.aligned)
        t.drag(ring: 2, by: 1, dt: 0.1)
        XCTAssertEqual(t.angles[1], TurningRings.coupling, accuracy: 1e-9, "turning a ring carries the one inside it")
        XCTAssertFalse(t.aligned)
        var spinning = TurningRings(angles: [0, 0, 0])
        spinning.drag(ring: 0, by: 0.001, dt: 0.0001)
        XCTAssertFalse(spinning.aligned, "a ring still turning has not come to rest")
        for _ in 0..<(30 * 60) { spinning.step(dt: 1.0 / 60, holding: []) }
        XCTAssertEqual(spinning.velocities[0], 0)
    }

    func testTwoLightsJoinOnlyWhenTheyMeetGently() {
        XCTAssertEqual(JoinMeeting.meet(distance: 200, closingSpeed: 10), .apart)
        XCTAssertEqual(JoinMeeting.meet(distance: 20, closingSpeed: 100), .join)
        XCTAssertEqual(JoinMeeting.meet(distance: 20, closingSpeed: 2000), .bounce)
    }

    func testTheJapaMovesOneBeadForOneWholeBreath() {
        var m = JapaMala()
        m.inhale(at: 0)
        XCTAssertFalse(m.exhale(at: 0.2), "a flick is not a breath")
        XCTAssertEqual(m.bead, 0)
        var t = 1.0
        for _ in 0..<JapaMala.beads {
            m.inhale(at: t)
            t += 4
            XCTAssertTrue(m.exhale(at: t))
            t += 4
        }
        XCTAssertTrue(m.roundWhole)
        XCTAssertEqual(JapaMala.beads, 108)
        m.inhale(at: t)
        XCTAssertFalse(m.exhale(at: t + 4), "a whole round goes quiet")
    }

    func testTheAratiGathersOnlySunwiseAndAtAnEvenPace() {
        var sunwise = Arati()
        var a = 0.0
        _ = sunwise.follow(angle: a, dt: 0)
        var offered = 0
        for _ in 0..<(60 * 60) {
            a += 1.0 / 60          // one radian a second
            if sunwise.follow(angle: a, dt: 1.0 / 60) { offered += 1 }
        }
        XCTAssertTrue(sunwise.offered)
        XCTAssertEqual(offered, Arati.circlesToOffer)
        var widdershins = Arati()
        a = 0
        _ = widdershins.follow(angle: a, dt: 0)
        for _ in 0..<(60 * 60) { a -= 1.0 / 60; _ = widdershins.follow(angle: a, dt: 1.0 / 60) }
        XCTAssertFalse(widdershins.offered, "the other way round simply does not gather")
        var rushed = Arati()
        a = 0
        _ = rushed.follow(angle: a, dt: 0)
        for _ in 0..<600 { a += 0.2; _ = rushed.follow(angle: a, dt: 1.0 / 60) }
        XCTAssertEqual(rushed.circles, 0)
        XCTAssertGreaterThan(rushed.flicker, 0, "a rush only makes the flame flicker")
    }

    func testTheSandhyaIsTheJunctionTheDayIsNearest() {
        let noon = Date(timeIntervalSince1970: 1_791_000_000)
        let sun = Panchanga.SunTimes(rise: noon.addingTimeInterval(-6 * 3600), noon: noon,
                                     set: noon.addingTimeInterval(6 * 3600))
        XCTAssertEqual(SandhyaPractice.nearest(to: noon.addingTimeInterval(-5.5 * 3600), sun: sun), .dawn)
        XCTAssertEqual(SandhyaPractice.nearest(to: noon.addingTimeInterval(600), sun: sun), .noon)
        XCTAssertEqual(SandhyaPractice.nearest(to: noon.addingTimeInterval(5 * 3600), sun: sun), .dusk)
        XCTAssertEqual(SandhyaPractice.nearest(to: noon.addingTimeInterval(9 * 3600), sun: sun), .dusk)
        XCTAssertEqual(SandhyaPractice.nearest(to: noon.addingTimeInterval(-9 * 3600), sun: sun), .dawn)
        XCTAssertEqual(SandhyaPractice.dusk.invitation, "What you carried today\nyou may set down here.")
        var l = JunctionLight()
        l.carry(toward: 1, dt: 1)
        XCTAssertEqual(l.level, JunctionLight.rate, accuracy: 1e-9, "a rush carries only a breath's worth")
        l.carry(toward: 0, dt: 5)
        XCTAssertEqual(l.level, JunctionLight.rate, accuracy: 1e-9, "the light is never taken back")
    }

    func testTheLotusOpensWithTheSunAndRestsAtNight() {
        let noon = Date(timeIntervalSince1970: 1_791_000_000)
        let sun = Panchanga.SunTimes(rise: noon.addingTimeInterval(-6 * 3600), noon: noon,
                                     set: noon.addingTimeInterval(6 * 3600))
        XCTAssertEqual(LotusSun.openness(at: noon, sun: sun), 1, accuracy: 1e-9)
        XCTAssertEqual(LotusSun.openness(at: noon.addingTimeInterval(8 * 3600), sun: sun), 0.35, accuracy: 1e-9)
        XCTAssertLessThan(LotusSun.openness(at: noon.addingTimeInterval(-5 * 3600), sun: sun), 1)
    }

    func testTheGreatWheelComesToRestWithTodayAtThePoint() {
        let today = GreatWheel.angle(of: Date(timeIntervalSince1970: 1_791_000_000))
        var spin = GreatWheel.Spin(turn: 2.4)
        spin.drag(by: 0.3, dt: 0.1)
        for _ in 0..<(60 * 60) { spin.step(dt: 1.0 / 60, holding: false, today: today) }
        // Wherever the fling left it, near the point it is drawn in; far from
        // it, it simply rests until flung again.
        let off = abs(PlayMath.wrap(spin.turn + today + Double.pi / 2))
        if off < GreatWheel.Spin.catchWithin {
            XCTAssertTrue(spin.resting(today: today))
        }
        var near = GreatWheel.Spin(turn: -today - Double.pi / 2 + 0.2)
        for _ in 0..<(30 * 60) { near.step(dt: 1.0 / 60, holding: false, today: today) }
        XCTAssertTrue(near.resting(today: today), "a wheel let go near today settles at today")
        for r in Panchanga.Rtu.allCases {
            XCTAssertFalse(SeasonLight.poetry(r).isEmpty)
            XCTAssertGreaterThan(SeasonLight.intensity(r), 0)
        }
    }
}

// MARK: - What play leaves on the phone

final class PlayGardenStoreTests: XCTestCase {

    private func temporaryDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("play-garden-\(UUID().uuidString)", isDirectory: true)
    }

    func testTracesAndSeedsSurviveARelaunchAndNothingIsEverRemoved() {
        let dir = temporaryDirectory()
        let at = Date(timeIntervalSince1970: 1_791_000_000)
        let a = PlayGardenStore(directory: dir)
        a.record(game: "drum", at: at)
        a.record(game: "seed", at: at.addingTimeInterval(60))
        a.plant(at: 26, at: at)
        a.plant(at: 26, at: at.addingTimeInterval(86_400 * 4))
        a.visitWorld(at: at)
        let b = PlayGardenStore(directory: dir)
        XCTAssertEqual(b.traces.map(\.game), ["drum", "seed"])
        XCTAssertEqual(b.archive.seeds.count, 2, "a new planting never replaces the last")
        XCTAssertEqual(b.growingSeed?.plantedAt, at.addingTimeInterval(86_400 * 4))
        XCTAssertEqual(b.worldVisitedAt, at)
        XCTAssertEqual(b.playedDays(calendar: Calendar(identifier: .gregorian)).count, 1)
    }
}

// MARK: - Lalitā's field holds all thirty-six

final class PlayFieldWholeTests: XCTestCase {

    func testEveryLightCanBeTouchedOnAPhone() {
        for (w, h) in [(390.0, 844.0), (430.0, 932.0), (375.0, 667.0)] {
            let c = CGPoint(x: w / 2, y: h * 0.47)
            let r = CGFloat(min(w * 0.42, h * 0.36))
            let spots = PlayFieldLayout.relaxed(center: c, radius: r)
            XCTAssertEqual(spots.keys.count, PlayGame.allCases.count)
            let pts = PlayGame.allCases.compactMap { spots[$0] }
            var closest = CGFloat.greatestFiniteMagnitude
            for i in 0..<pts.count {
                for j in (i + 1)..<pts.count {
                    closest = min(closest, hypot(pts[i].x - pts[j].x, pts[i].y - pts[j].y))
                }
            }
            XCTAssertGreaterThanOrEqual(closest, 46, "two lights stand under one finger on a \(w)-wide glass")
            XCTAssertEqual(spots[.yantraTrace]?.x ?? 0, c.x, accuracy: 0.001, "the Śrī Yantra stays on the point")
            XCTAssertEqual(spots[.yantraTrace]?.y ?? 0, c.y, accuracy: 0.001)
            for p in pts {
                XCTAssertLessThanOrEqual(hypot(p.x - c.x, p.y - c.y), r * 1.18 + 0.01)
            }
        }
    }
}

// MARK: - The Ring Worlds mechanisms, reborn on the climb

final class RingMechanismTests: XCTestCase {

    func testEveryMechanismIsStillAtRest() {
        for kp in 1...KhadgamalaMap.total {
            let off = ClimbLights.wholeMechanisms(kp: kp, settle: 0, openness: 1, lineageWave: 0,
                                                  lineageGlow: 0, overflow: 0,
                                                  collapseInto: nil, collapse: 0)
            XCTAssertEqual(off, .zero, "kp \(kp) moves with no hand on the climb")
        }
    }

    func testEachMechanismMovesOnlyItsOwnRing() {
        for kp in 1...KhadgamalaMap.total {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            if ring != 1 { XCTAssertEqual(ClimbLights.earthCity(kp: kp, settle: 1), .zero) }
            if ring != 2 { XCTAssertEqual(ClimbLights.lotus(kp: kp, openness: 0), .zero) }
            if ring != 4 { XCTAssertEqual(ClimbLights.lineage(kp: kp, wave: 3, glow: 1), .zero) }
            if ring != 5 { XCTAssertEqual(ClimbLights.overflow(kp: kp, fullness: 1), .zero) }
            if ring != 8 { XCTAssertEqual(ClimbLights.collapse(kp: kp, into: 99, amount: 1), .zero) }
        }
        XCTAssertNotEqual(ClimbLights.lotus(kp: 29, openness: 0), .zero, "a closed lotus draws its petals in")
        XCTAssertNotEqual(ClimbLights.overflow(kp: 67, fullness: 1), .zero)
        XCTAssertGreaterThan(ClimbLights.lineage(kp: 56, wave: 3, glow: 1).y,
                             ClimbLights.lineage(kp: 60, wave: 3, glow: 1).y,
                             "the teaching lifts the seat it has reached")
    }

    func testTheEarthCitySettlesFamilyByFamilyOntoThreeSquares() {
        XCTAssertEqual(ClimbLights.earthFamily(kp: 1)?.line, 0)
        XCTAssertEqual(ClimbLights.earthFamily(kp: 11)?.line, 1)
        XCTAssertEqual(ClimbLights.earthFamily(kp: 28)?.line, 2)
        XCTAssertNil(ClimbLights.earthFamily(kp: 29))
        let q = ClimbLights.squarePoint(0, half: 2)
        XCTAssertEqual(q.x, 0, accuracy: 1e-9)
        XCTAssertEqual(q.z, -2, accuracy: 1e-9)
    }

    func testRingEightsOtherTwoCollapseIntoTheOneTouched() {
        let into = ClimbLights.position(kp: 100)
        for kp in [99, 101] {
            let moved = ClimbLights.position(kp: kp) + ClimbLights.collapse(kp: kp, into: 100, amount: 1)
            XCTAssertLessThan(simd_distance(moved, into), simd_distance(ClimbLights.position(kp: kp), into) * 0.1)
        }
        XCTAssertEqual(ClimbLights.collapse(kp: 100, into: 100, amount: 1), .zero, "the vertex itself stays")
    }
}
