import XCTest
import CoreGraphics
@testable import Bindu_Mandala

// MARK: - Wave 4 · Play
//
// Four things are held here:
//
//  1. **The address table.** Every game sits at the seat the walk gave it, and
//     each seat is the Śakti the rows say it is. The names below were read off
//     the Mandala table (`fldI0aV1sfOeNybHI` → `fldJOatnYrw9l6tff`) on
//     2026-10-12; only Ring 2 ships inside the binary, so for every other seat
//     the pin is the evidence and position stays the only key.
//  2. **The physics.** Each game's skill, and the law that failure is present-
//     tense physics: nothing reached is ever taken back.
//  3. **The ledger.** One `Played` row per game, in the ledger's own shape.
//  4. **The screen.** No file in `Views/Play/` says a number about him, uses red
//     as failure, congratulates him, or keeps a store of its own.

final class PlayAddressTests: XCTestCase {

    /// game → (khaḍgamālā position, her name as the row writes it, her ring).
    static let seats: [PlayGame: (kp: Int, name: String, ring: Int)] = [
        .pulse:        (70, "Sarva-Maṅgalakāriṇī", 5),
        .coherence:    (70, "Sarva-Maṅgalakāriṇī", 5),
        .spineWalk:    (84, "Sarvānandamayī", 6),
        .echo:         (80, "Sarvajñānamayī", 6),
        .fingerGarden: (69, "Sarva-Priyaṅkarī", 5),
        .rain:         (71, "Sarva-Kāmapradā", 5),
        .drum:         (53, "Sarva-Saṅkṣobhiṇī (Devī)", 4),   // The Map: Soles
        .rootSystem:   (4,  "Garimā", 1),                      // body location "Mūlādhāra / sit-bones / soles"
        .waterLevel:   (15, "Vārāhī", 1),                      // "Belly / sacrum" — Svādhiṣṭhāna's Mātṛkā
        .fire:         (65, "Sarva-Mantramayī", 4),            // The Map: Forge
        .shakeToClear: (82, "Sarvādhārasvarūpā", 6),           // The Map: Crow
        .door:         (94, "Kaulinī", 7),                     // The Map: Innocence
        .yantraTrace:  (102, "Mahātripurasundarī", 9),
        // Wave 6 · Slice E — read off the Mandala table (name `fldJOatnYrw9l6tff`,
        // body location `fld6P1u43B0eqKU5e`) and The Map on 2026-10-12.
        .seed:             (26,  "Sarva-Bīja (Mudrā)", 1),        // "the seed that holds everything"
        .colourRivers:     (20,  "Sarva-Vidrāviṇī (Mudrā)", 1),   // "joints / fluid systems" — melting
        .bhakti:           (24,  "Sarva-Mahāṅkuśā (Mudrā)", 1),   // "navel hook" — the one Maṇipūra seat at the navel
        .mirrorMaze:       (30,  "Buddhyākarṣiṇī", 2),            // buddhi — the mind that reflects
        .stillAjna:        (51,  "Anaṅga-Aṅkuśā", 3),             // Ājñā, "between the eyes"
        .bodyMap:          (77,  "Sarvajñā", 6),                  // The Map: Vision
        .letter:           (88,  "Kāmeśī", 7),                    // The Map: Intention
        .flash:            (91,  "Aruṇā", 7),                     // The Map: Intuition
        .join:             (92,  "Jayinī", 7),                    // The Map: Invention — "the third thing"
        .shadowTranslator: (101, "Bhagamālinī", 8),               // The Map: Ego Reveal
        .leela:            (102, "Mahātripurasundarī", 9),        // The Map: Lalitā — the play
        // Wave 6.1 · his decision (gameplan §4.12): beside the Higher Self.
        .ramJapa:          (42,  "Ātmākarṣiṇī", 2),
    ]

    func testEverySeatedGameIsAtTheSeatTheRowsName() {
        for (game, pin) in Self.seats {
            XCTAssertEqual(game.address, .seat(pin.kp), "\(game) moved off \(pin.name)")
            XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: pin.kp), pin.ring,
                           "\(pin.name) at \(pin.kp) is not in āvaraṇa \(pin.ring)")
            XCTAssertEqual(game.address.ring, pin.ring)
        }
        // And nothing seated is missing from the pin.
        let seated = Set(PlayGame.allCases.filter { $0.address.position != nil })
        XCTAssertEqual(seated, Set(Self.seats.keys))
    }

    func testTheUnseatedGamesLiveAtARingAThresholdOrTheWholeGarland() {
        XCTAssertEqual(PlayGame.corridor.address, .threshold(from: 3, to: 4), "the Shadow crossing")
        XCTAssertEqual(PlayGame.rosary.address, .garland)
        XCTAssertEqual(PlayGame.bijaTones.address, .ring(1))
        // Wave 6.
        XCTAssertEqual(PlayGame.shadowScrolls.address, .threshold(from: 3, to: 4), "the Shadow's own scrolls")
        XCTAssertEqual(PlayGame.tatTvamAsi.address, .threshold(from: 6, to: 7), "Armin")
        XCTAssertEqual(PlayGame.mandalaCompletion.address, .ring(7), "Integration")
        XCTAssertEqual(PlayGame.twelve.address, .ring(7), "the Vāk ring")
        XCTAssertEqual(PlayGame.turn.address, .ring(8), "the three made one")
        XCTAssertEqual(PlayGame.worldInABox.address, .ring(9))
        // Wave 6.1 · Rām japa moved to Ātmākarṣiṇī (kp 42), beside the Higher
        // Self (his decision, 12 Oct). The name is his own, so wherever it
        // stands it still ends in stillness, never in her Recognition.
        XCTAssertEqual(PlayGame.ramJapa.address, .seat(TrinityOfGuidance.higherSelfSeat))
        XCTAssertEqual(PlayGame.ramJapa.handoff, .stillness)
        XCTAssertEqual(PlayGame.sandhya.address, .ring(2), "the lotus that follows the sun")
        XCTAssertEqual(PlayGame.greatWheel.address, .ring(1))
    }

    func testEveryAddressIsInsideTheGarland() {
        for game in PlayGame.allCases {
            if let kp = game.address.position {
                XCTAssertTrue((1...KhadgamalaMap.total).contains(kp), "\(game) at \(kp)")
            }
            XCTAssertTrue((1...9).contains(game.address.ring), "\(game)")
        }
        XCTAssertEqual(PlayGame.allCases.count, 36,
                       "Wave 4's sixteen and Wave 6's twenty: every game in the corpus is home")
    }

    /// Her Detail's door asks only her position, and every one of the 102 has
    /// one: the game at her seat, or her own bead in the garland.
    func testEveryOneOfTheHundredAndTwoHasAPlayDoor() {
        for kp in 1...KhadgamalaMap.total {
            let game = PlayAddressBook.door(forPosition: kp)
            if let seated = PlayAddressBook.games(atPosition: kp).first {
                XCTAssertEqual(game, seated)
            } else {
                XCTAssertEqual(game, .rosary, "kp \(kp) should open her bead")
            }
        }
        XCTAssertEqual(PlayAddressBook.door(forPosition: 53), .drum)
        XCTAssertEqual(PlayAddressBook.door(forPosition: 70), .pulse, "Pulse leads at her seat; Coherence is beside it")
        XCTAssertEqual(PlayAddressBook.door(forPosition: 33), .rosary)
        XCTAssertEqual(PlayAddressBook.door(forPosition: 102), .yantraTrace,
                       "the Śrī Yantra leads at the Bindu; Leela's board is beside it")
        XCTAssertEqual(PlayAddressBook.door(forPosition: 24), .bhakti)
        XCTAssertEqual(PlayAddressBook.door(forPosition: 26), .seed)
        XCTAssertEqual(PlayAddressBook.games(at: .ring(7)), [.mandalaCompletion, .twelve])
        XCTAssertTrue(PlayAddressBook.games(inRing: 7).contains(.letter))
        XCTAssertFalse(PlayAddressBook.games(inRing: 9).contains(.rosary), "the garland is everywhere, not one ring")
    }

    func testEveryGameEndsInRecognitionOrStillnessAndIsGivenWordsOnce() {
        for game in PlayGame.allCases {
            XCTAssertFalse(game.title.isEmpty)
            XCTAssertFalse(game.verb.isEmpty)
            XCTAssertFalse(game.hint.isEmpty)
            XCTAssertTrue(NeverMeasure.measuresOutLoud(game.hint).isEmpty, game.hint)
            XCTAssertTrue(NeverMeasure.measuresOutLoud(game.verb).isEmpty, game.verb)
        }
        XCTAssertEqual(PlayGame.corridor.handoff, .stillness)
        XCTAssertEqual(PlayGame.waterLevel.handoff, .stillness)
        XCTAssertEqual(PlayGame.door.handoff, .recognition)
        XCTAssertEqual(PlayGame.pulse.handoff, .recognition)
    }

    func testLalitasFieldStandsEachLightAtItsRing() {
        let c = CGPoint(x: 200, y: 400)
        let r: CGFloat = 160
        // The Bindu's game stands on the point itself.
        let bindu = PlayFieldLayout.point(for: .yantraTrace, center: c, radius: r)
        XCTAssertEqual(bindu.x, c.x, accuracy: 0.001)
        XCTAssertEqual(bindu.y, c.y, accuracy: 0.001)
        // Two games at one seat do not stand on each other.
        let pulse = PlayFieldLayout.point(for: .pulse, center: c, radius: r)
        let coherence = PlayFieldLayout.point(for: .coherence, center: c, radius: r)
        XCTAssertGreaterThan(hypot(pulse.x - coherence.x, pulse.y - coherence.y), 10)
        // Inner rings stand nearer the point.
        let d4 = hypot(PlayFieldLayout.point(for: .drum, center: c, radius: r).x - c.x,
                       PlayFieldLayout.point(for: .drum, center: c, radius: r).y - c.y)
        let d7 = hypot(PlayFieldLayout.point(for: .door, center: c, radius: r).x - c.x,
                       PlayFieldLayout.point(for: .door, center: c, radius: r).y - c.y)
        XCTAssertGreaterThan(d4, d7)
        XCTAssertEqual(PlayFieldLayout.seats(inRing: 1), 28)
        XCTAssertEqual(PlayFieldLayout.seats(inRing: 9), 1)
    }
}

// MARK: - The physics

final class PlayPhysicsTests: XCTestCase {

    func testForceIsAbsorbedNeverPunished() {
        XCTAssertEqual(TouchSense.absorb(0), 0, accuracy: 1e-12)
        XCTAssertEqual(TouchSense.absorb(1), 1, accuracy: 1e-9)
        XCTAssertLessThanOrEqual(TouchSense.absorb(50), 1)
        XCTAssertLessThan(TouchSense.absorb(0.2), TouchSense.absorb(0.5))
        // A sensor reading, and the pad of a finger where there is none.
        XCTAssertEqual(TouchSense.pressure(force: 0, maximumForce: 0, majorRadius: 4), 0, accuracy: 1e-9)
        XCTAssertGreaterThan(TouchSense.pressure(force: 0, maximumForce: 0, majorRadius: 30), 0.6)
        XCTAssertLessThanOrEqual(TouchSense.pressure(force: 9, maximumForce: 6.6, majorRadius: 10), 1)
    }

    func testPostureReadsLevelWhenTheGlassLiesFlat() {
        XCTAssertEqual(LightBody.roll(gravityX: 0), 0)
        XCTAssertEqual(LightBody.roll(gravityX: 3), 1)
        XCTAssertEqual(LightBody.uprightness(gravityZ: -1), 0)
        XCTAssertEqual(LightBody.uprightness(gravityZ: 0), 1)
    }

    func testTheCorridorIsCrossedAtTheBodysPaceAndHurryTakesNothingBack() {
        var c = CorridorPace()
        XCTAssertEqual(c.step(at: 0), .first)
        var t = 0.0
        for _ in 0..<10 { t += 1.0; XCTAssertEqual(c.step(at: t), .inPace) }
        let before = c.depth
        t += 0.3
        XCTAssertEqual(c.step(at: t), .hurried)
        XCTAssertEqual(c.depth, before, "a hurried step presses the walls; it does not walk him back")
        XCTAssertGreaterThan(c.press, 0)
        t += 3
        XCTAssertEqual(c.step(at: t), .lingering)
        XCTAssertEqual(c.depth, before)
        c.relax(dt: 10)
        XCTAssertEqual(c.press, 0)
        for _ in 0..<CorridorPace.stepsToCross { t += 0.95; _ = c.step(at: t) }
        XCTAssertTrue(c.crossed)
    }

    func testPulseCatchesASteadyHeartAndNotAScatteredOne() {
        var steady = HeartbeatCatch()
        for i in 0..<8 { steady.tap(at: Double(i) * 0.82) }
        XCTAssertTrue(steady.caught)
        XCTAssertEqual(steady.period ?? 0, 0.82, accuracy: 1e-9)

        var scattered = HeartbeatCatch()
        var t = 0.0
        for i in 0..<10 { scattered.tap(at: t); t += i % 2 == 0 ? 0.4 : 1.3 }
        XCTAssertFalse(scattered.caught)

        var tooFast = HeartbeatCatch()
        for i in 0..<10 { tooFast.tap(at: Double(i) * 0.2) }
        XCTAssertFalse(tooFast.caught, "a finger drumming is not a heart")
    }

    func testTheSpineLightCannotBeRushedAndLightsWhereItRests() {
        var s = SpineLight()
        s.follow(target: 1, dt: 0.1)
        XCTAssertLessThanOrEqual(s.y, 0.02 + SpineLight.maxSpeed * 0.1 + 1e-9)
        var rest = SpineLight()
        for _ in 0..<12 { rest.follow(target: SpineLight.stations[0], dt: 0.1) }
        XCTAssertTrue(rest.lit.contains(0))
        XCTAssertFalse(rest.arrived)
        // Walking the whole spine, resting at each centre, arrives.
        var walk = SpineLight()
        for st in SpineLight.stations {
            for _ in 0..<40 { walk.follow(target: st, dt: 0.05) }
        }
        XCTAssertTrue(walk.arrived)
    }

    func testEchoClimbsWhenHeEchoesHerAndEndsOnTheFifth() {
        var e = EchoExchange()
        _ = e.call(intervals: [0.5, 0.25])
        XCTAssertEqual(e.degree, 0)
        _ = e.call(intervals: [0.9])                      // not an echo: she stays
        XCTAssertEqual(e.degree, 0)
        _ = e.call(intervals: [0.9])
        XCTAssertEqual(e.degree, 1)
        for _ in 0..<3 { _ = e.call(intervals: [0.92]) }
        XCTAssertTrue(e.reachedFifth)
        XCTAssertEqual(e.frequency / EchoExchange.base, 1.5, accuracy: 1e-9)
        XCTAssertTrue(EchoExchange.rhythmMatches([0.5, 0.5], [0.55, 0.45]))
        XCTAssertFalse(EchoExchange.rhythmMatches([0.5, 0.5], [0.5]))
    }

    func testTheGardensDroneSwellsWithItsStems() {
        XCTAssertEqual(GardenGrowth.droneGain(stems: 0), 0)
        XCTAssertLessThan(GardenGrowth.droneGain(stems: 3), GardenGrowth.droneGain(stems: 8))
        XCTAssertEqual(GardenGrowth.droneGain(stems: 40), 0.18, accuracy: 1e-12)
        XCTAssertGreaterThan(GardenGrowth.rate(fingerSpeed: 0), GardenGrowth.rate(fingerSpeed: 600))
    }

    func testRainCountsOnlyLongBreaths() {
        var r = RainWind()
        r.began(at: 0)
        for _ in 0..<10 { r.push(dx: 0.06) }
        XCTAssertTrue(r.ended(at: 3.5))
        r.began(at: 10)
        r.push(dx: 0.5)
        XCTAssertFalse(r.ended(at: 10.4), "a flick is not a breath")
        XCTAssertLessThanOrEqual(abs(r.wind), 0.6)
        r.decay(dt: 5)
        XCTAssertLessThan(abs(r.wind), 0.6)
    }

    func testTheDrumGoesDeeperOnTheBeatAndAnOffBeatTakesNothing() {
        var d = DrumBeat()
        XCTAssertEqual(d.strike(at: 0), .first)
        XCTAssertEqual(d.strike(at: 1.05), .onBeat)
        XCTAssertEqual(d.depth, 1)
        XCTAssertEqual(d.strike(at: 1.4), .offBeat)
        XCTAssertEqual(d.depth, 1)
        var t = 1.4
        for _ in 0..<30 { t += 1; _ = d.strike(at: t) }
        XCTAssertTrue(d.reachedWater)
        XCTAssertLessThanOrEqual(DrumBeat.thump(pressure: 9), 1)
    }

    func testRootsGrowOnlyFromStillness() {
        var r = RootGrowth()
        r.grow(dt: 10, stillness: 0, fingers: 1)
        XCTAssertEqual(r.depth, 0)
        r.grow(dt: 10, stillness: 1, fingers: 0)
        XCTAssertEqual(r.depth, 0, "no finger, no root")
        for _ in 0..<30 { r.grow(dt: 1, stillness: 1, fingers: 1) }
        XCTAssertTrue(r.rooted)
    }

    func testTheWaterSettlesWhenHeldLevelAndNotWhenTipped() {
        var level = WaterVessel()
        level.step(dt: 1.0 / 60, tilt: 0, nudge: 0.3)
        for _ in 0..<(25 * 60) { level.step(dt: 1.0 / 60, tilt: 0) }
        XCTAssertTrue(level.settled)

        var tipped = WaterVessel()
        for _ in 0..<(25 * 60) { tipped.step(dt: 1.0 / 60, tilt: 0.5) }
        XCTAssertFalse(tipped.settled)
        XCTAssertLessThanOrEqual(abs(tipped.angle), WaterVessel.maxAngle)
    }

    func testTheFireIsTendedInItsBandAndStarvingItOnlyGutters() {
        var starved = FireBand()
        for _ in 0..<(20 * 60) { starved.burn(dt: 1.0 / 60) }
        XCTAssertTrue(starved.guttering)
        let kept = starved.tended
        for _ in 0..<(10 * 60) { starved.burn(dt: 1.0 / 60) }
        XCTAssertEqual(starved.tended, kept, "a guttering fire keeps what was tended")

        var tended = FireBand()
        for _ in 0..<(70 * 60) {
            if tended.fuel < 0.35 { tended.feed(pressure: 0.3) }
            tended.burn(dt: 1.0 / 60)
        }
        XCTAssertTrue(tended.kindled)
    }

    func testShakingClearsTheFieldAndStillnessNeverRefillsIt() {
        var s = ShakeClear()
        for _ in 0..<(10 * 60) { s.feel(acceleration: 2, dt: 1.0 / 60) }
        XCTAssertTrue(s.isClear)
        var half = ShakeClear()
        for _ in 0..<60 { half.feel(acceleration: 2, dt: 1.0 / 60) }
        let c = half.cleared
        for _ in 0..<600 { half.feel(acceleration: 0, dt: 1.0 / 60) }
        XCTAssertGreaterThanOrEqual(half.cleared, c)
    }

    /// **C-1357 — never tell him he is doing something wrong.** Wave 4 pinned
    /// that a hard press *dims* the Door: a reaction aimed at him, a correction.
    /// Now force is absorbed — under a hard press the door neither opens nor
    /// dims; nothing about it answers how he pressed.
    func testTheDoorOpensToALightHoldAndAbsorbsForceWithoutCorrecting() {
        var d = DoorHold()
        for _ in 0..<100 { d.step(dt: 0.05, holding: true, pressure: 0.95) }
        XCTAssertEqual(d.opened, 0, "pressing hard does not force the door")
        XCTAssertEqual(d.dim, 0, accuracy: 1e-12, "the door dims at him under force — a correction")
        var half = DoorHold()
        for _ in 0..<10 { half.step(dt: 0.05, holding: true, pressure: 0.2) }
        let before = half
        for _ in 0..<100 { half.step(dt: 0.05, holding: true, pressure: 1) }
        XCTAssertEqual(half.opened, before.opened, accuracy: 1e-12, "force took something back")
        XCTAssertEqual(half.dim, before.dim, accuracy: 1e-12, "force changed the door at all")
        for _ in 0..<20 { d.step(dt: 0.05, holding: true, pressure: 0.2) }
        let reached = d.opened
        XCTAssertGreaterThan(reached, 0)
        for _ in 0..<100 { d.step(dt: 0.05, holding: false, pressure: 0) }
        XCTAssertEqual(d.opened, reached, "lifting the finger takes nothing back")
        for _ in 0..<60 { d.step(dt: 0.05, holding: true, pressure: 0.2) }
        XCTAssertTrue(d.isOpen)
    }

    func testTheYantraIsTracedLineByLineAtItsTrueGeometry() {
        let edges = YantraTrace.edges(MandalaYantra.triangles)
        XCTAssertEqual(edges.count, 27, "nine triangles, three lines each")
        XCTAssertEqual(Set(YantraTrace.triangleOrder), Set(0..<9))
        XCTAssertEqual(YantraTrace.triangleOrder.first, 4, "the mūla trikoṇa is drawn first")

        let a = CGPoint(x: 0, y: 0), b = CGPoint(x: 200, y: 0)
        let along = (0...10).map { CGPoint(x: CGFloat($0) * 20, y: CGFloat($0 % 2) * 4) }
        XCTAssertTrue(YantraTrace.traces(along, edge: (a, b), tolerance: 18))
        XCTAssertTrue(YantraTrace.traces(Array(along.reversed()), edge: (a, b), tolerance: 18))
        let astray = (0...10).map { CGPoint(x: CGFloat($0) * 20, y: 60) }
        XCTAssertFalse(YantraTrace.traces(astray, edge: (a, b), tolerance: 18))
        let half = (0...5).map { CGPoint(x: CGFloat($0) * 20, y: 0) }
        XCTAssertFalse(YantraTrace.traces(half, edge: (a, b), tolerance: 18), "half a line is not the line")
    }

    func testTheGarlandIsOneHundredAndTwoBeadsAndPositionIsTheBead() {
        var r = Rosary(startingAt: 101)
        XCTAssertTrue(r.pull(at: 0))
        XCTAssertEqual(r.bead, 102)
        XCTAssertFalse(r.pull(at: 0.1), "a pull too quick slips")
        XCTAssertEqual(r.bead, 102)
        XCTAssertTrue(r.pull(at: 1))
        XCTAssertEqual(r.bead, 1, "the garland closes: after the Bindu, the first seat")
        var t = 1.0
        while !r.roundComplete { t += 0.5; r.pull(at: t) }
        XCTAssertEqual(r.bead, 101, "a whole round brings him home to the bead he began on")
        XCTAssertEqual(r.phase(of: r.bead), 0, accuracy: 1e-12)
        XCTAssertEqual(Rosary(startingAt: 500).bead, 1, "a position outside the garland is not a bead")
    }

    func testTheBijaTonesAreTheWalksOwnAwakeningTable() {
        XCTAssertEqual(AwakeningTones.frequency(ring: 1), 174)
        XCTAssertEqual(AwakeningTones.frequency(ring: 4), 341)
        XCTAssertEqual(AwakeningTones.frequency(ring: 8), 528)
        XCTAssertNil(AwakeningTones.frequency(ring: 9), "the Bindu's tone is silence")
        // Not the solfeggio ladder the corpus shipped.
        for ring in 1...8 {
            XCTAssertFalse([396.0, 417, 639, 741, 852, 963].contains(AwakeningTones.frequency(ring: ring) ?? 0))
        }
        let p = AwakeningTones.pulsePeriod(ring: 3) ?? 0
        let taps = (0..<8).map { Double($0) * p }
        XCTAssertTrue(AwakeningTones.isTuned(taps: taps, ring: 3))
        let off = (0..<8).map { Double($0) * p * 1.3 }
        XCTAssertFalse(AwakeningTones.isTuned(taps: off, ring: 3))
    }

    func testHeartAndBreathMeetOnAWholeNumberOfBeats() {
        XCTAssertEqual(Coherence.meeting(breathPeriod: 8, heartPeriod: 1), 1, accuracy: 1e-9)
        XCTAssertEqual(Coherence.meeting(breathPeriod: 8.5, heartPeriod: 1), 0, accuracy: 1e-9)
        XCTAssertTrue(Coherence.met(breaths: [8, 8.1, 7.95], heartPeriod: 1))
        XCTAssertFalse(Coherence.met(breaths: [3, 3, 3], heartPeriod: 1), "a quick breath is not the Rite's")
        XCTAssertFalse(Coherence.met(breaths: [8, 8], heartPeriod: 1))
    }
}

// MARK: - The ledger

final class PlayLedgerTests: XCTestCase {

    private let at = Date(timeIntervalSince1970: 1_791_000_000)

    func testAPlayedGameIsOneLedgerRowInTheLedgersOwnShape() {
        let row = ActivityLedger.played(game: "Finger Garden", place: "Sarva-Priyaṅkarī",
                                        linkRecordId: "recOd2lzI8Mus9QUr", seconds: 84.5, at: at)
        XCTAssertEqual(row.type, ActivityLedger.ActivityType.played)
        XCTAssertEqual(row.type, "Played")
        XCTAssertEqual(row.gestureSource, ActivityLedger.GestureSource.play)
        XCTAssertEqual(row.durationSec, 84.5)
        XCTAssertNil(row.notes, "words a game sets down are released from the view; the act is the row")

        let f = ActivityLedger.fields(for: row, timeZone: TimeZone(identifier: "America/New_York")!)
        XCTAssertEqual(f[ActivityLedger.Field.sourceApp] as? String, "Mandala")
        XCTAssertEqual(f[ActivityLedger.Field.activityType] as? String, "Played")
        XCTAssertEqual(f[ActivityLedger.Field.gestureSource] as? String, "Play")
        XCTAssertEqual(f[ActivityLedger.Field.linkToMandala] as? [String], ["recOd2lzI8Mus9QUr"])
        XCTAssertEqual(f[ActivityLedger.Field.durationSec] as? Double, 84.5)
        XCTAssertNil(f[ActivityLedger.Field.notes])
        XCTAssertNotNil(f[ActivityLedger.Field.feltAt])
        // The words it writes do not measure, even in the archive.
        XCTAssertTrue(NeverMeasure.measuresOutLoud(row.name).isEmpty, row.name)
        XCTAssertTrue(NeverMeasure.measuresOutLoud(row.detail).isEmpty, row.detail)
    }

    func testTheRecognitionAPlayHandsToIsFiledAsPlay() {
        XCTAssertEqual(AirtableService.RecognitionSource.play.rawValue, ActivityLedger.GestureSource.play)
    }

    func testAGameIsFiledAtHerRowOrAtItsRingNeverNowhere() {
        let hers = PlayLedger.row(game: .door, ring: 7, shaktiName: "Kaulinī",
                                  shaktiRecordId: "recAcreZcJUyk0Qcq", seconds: 40, at: at)
        XCTAssertEqual(hers.linkRecordId, "recAcreZcJUyk0Qcq")
        XCTAssertEqual(hers.name, "Kaulinī — played")

        // Her row not synced yet: the act is still filed — in her ring.
        let unsynced = PlayLedger.row(game: .door, ring: 7, shaktiName: "Kaulinī",
                                      shaktiRecordId: nil, seconds: 40, at: at)
        XCTAssertEqual(unsynced.linkRecordId, AirtableService.avaranaRecordId(forRing: 7))
        XCTAssertFalse(unsynced.linkRecordId.isEmpty)

        let tones = PlayLedger.row(game: .bijaTones, ring: 5, shaktiName: nil,
                                   shaktiRecordId: nil, seconds: 30, at: at)
        XCTAssertEqual(tones.name, "Fifth Āvaraṇa — played")
        XCTAssertEqual(tones.linkRecordId, AirtableService.avaranaRecordId(forRing: 5))

        let crossing = PlayLedger.row(game: .corridor, ring: 4, shaktiName: nil,
                                      shaktiRecordId: nil, seconds: 30, at: at)
        XCTAssertEqual(crossing.name, "The Shadow crossing — played")
        XCTAssertTrue(crossing.detail.hasPrefix("The Corridor · "))
    }

    func testTheQueueStillDecodesAPlayedRow() throws {
        let row = ActivityLedger.played(game: "The Drum", place: "Sarva-Saṅkṣobhiṇī (Devī)",
                                        linkRecordId: "recookwVJWiLej7y3", seconds: 12, at: at)
        let data = try JSONEncoder().encode([row])
        let back = try JSONDecoder().decode([PendingActivity].self, from: data)
        XCTAssertEqual(back, [row], "an offline game rides the same queue, and comes back whole")
    }
}

// MARK: - The screen

final class PlayScreenTests: XCTestCase {

    private var playFiles: [SourceFile] {
        LawSource.production.filter { $0.path.hasPrefix("Views/Play/") }
    }

    func testThePlayCorpusIsReallyRead() {
        XCTAssertGreaterThanOrEqual(playFiles.count, 10, "Views/Play/ was not found: \(playFiles.map(\.path))")
        let calls = playFiles.flatMap { $0.calls(to: LawSource.walkerFacingCallees) }
        XCTAssertGreaterThanOrEqual(calls.count, 12, "only \(calls.count) walker-facing calls were read")
    }

    /// No number about him. Every walker-facing string in `Views/Play/` — its
    /// words, and the values bound into it — against the narrow floor, the
    /// practice record and each game's own measure of his play. (U0: digits
    /// and structural counts are allowed now.)
    func testNoPlayScreenShowsANumberAboutHim() {
        var offences: [String] = []
        for f in playFiles {
            for call in f.calls(to: LawSource.walkerFacingCallees) {
                for lit in call.literals {
                    if !NeverMeasure.measuresOutLoud(NeverMeasure.probe(lit.shape)).isEmpty {
                        offences.append("\(call.origin) — \"\(lit.shape)\"")
                    }
                    // U0 (VER-L-0762): the digit ban is retired (ruling 10).
                }
                for expr in call.expressions where !expr.isEmpty {
                    for what in NeverMeasure.practiceTouched(in: expr) {
                        offences.append("\(call.origin) — binds \(what)")
                    }
                    // U0: a structural count may be shown; a game's measure of
                    // his play (below) may not — the narrow floor.
                    if Rx.matches(#"(?i)\b(depth|tended|turned|acts|drawn|degree|cleared|opened|breaths|stillFor|seconds|startedAt)\b"#, expr) {
                        offences.append("\(call.origin) — binds a game's own measure: \(expr)")
                    }
                }
            }
        }
        XCTAssertTrue(offences.isEmpty,
                      "a play screen says how far, how long or how well — storage may count; the screen may not:\n"
                      + offences.joined(separator: "\n"))
    }

    /// Failure is physics, never red. The only red in the field is her own
    /// point at the centre of Lalitā's field.
    func testRedIsNeverFailure() {
        var offences: [String] = []
        for f in playFiles {
            let code = String(f.lexed.masked)
            for m in Rx.all(#"\bColor\.red\b|\bUIColor\.red\b|systemRed|[(:,]\s*\.red\b"#, code) {
                offences.append("\(f.path) — \(m)")
            }
            for m in Rx.all(#"accentRed"#, code) where f.path != "Views/Play/PlayFieldView.swift" {
                offences.append("\(f.path) — \(m)")
            }
        }
        XCTAssertTrue(offences.isEmpty, "red reached a game:\n" + offences.joined(separator: "\n"))
        if let field = playFiles.first(where: { $0.path == "Views/Play/PlayFieldView.swift" }) {
            XCTAssertEqual(Rx.all(#"accentRed"#, String(field.lexed.masked)).count, 1,
                           "Lalitā's point is the one red in play")
        } else {
            XCTFail("PlayFieldView.swift is missing")
        }
    }

    /// No end screen congratulates him, and nothing on a play screen gives a
    /// verdict.
    func testNothingCongratulatesOrGivesAVerdict() {
        let verdicts = #"(?i)\b(well done|congrat\w*|great job|perfect|success\w*|you win|you won|won|lost|fail\w*|wrong|try again|game over|too fast|too slow|complete[d]?|best|record|score|streak|high score)\b"#
        var offences: [String] = []
        for f in playFiles {
            for call in f.calls(to: LawSource.walkerFacingCallees) {
                for lit in call.literals where Rx.matches(verdicts, lit.text) {
                    offences.append("\(call.origin) — \"\(lit.text)\"")
                }
            }
        }
        for game in PlayGame.allCases where Rx.matches(verdicts, game.hint) {
            offences.append("\(game) hint — \"\(game.hint)\"")
        }
        XCTAssertTrue(offences.isEmpty, "a play screen judges him:\n" + offences.joined(separator: "\n"))
    }

    /// U0 · retired (VER-L-0803): "play keeps no store of its own" —
    /// `PlayGardenStore` and `PlayTraceStore` exist and fold into the
    /// PracticeStoreContract. What stays: the ledger is reached through its
    /// one door.
    func testPlayReachesTheLedgerThroughItsOneDoor() {
        let host = playFiles.first { $0.path == "Views/Play/PlayGameHost.swift" }
        XCTAssertNotNil(host)
        XCTAssertTrue(String(host?.lexed.masked ?? []).contains("AirtableService.shared.logActivity("))
    }

    /// No figure (U0 rewrite, VER-L-0773 / VER-FL-0888): play may draw an
    /// image, but nothing it hands a drawing primitive names a figure.
    func testPlayDrawsNoFigure() {
        for f in playFiles {
            for call in f.calls(to: Aniconic.drawingCallees) {
                XCTAssertNil(Rx.first(Aniconic.figuralVocabulary, call.argumentCode),
                             "\(f.path) draws a figure: \(call.origin)")
                for lit in call.literals {
                    XCTAssertNil(Rx.first(Aniconic.figuralVocabulary, lit.text),
                                 "\(f.path) draws a figure: \"\(lit.text)\"")
                }
            }
        }
    }
}
