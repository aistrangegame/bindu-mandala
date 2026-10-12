import XCTest
import simd
@testable import Bindu_Mandala

// MARK: - Wave 2 · One building — the pure half, driven
//
// Everything `Homes/TheBuilding.swift` decides, asserted without a renderer:
// the garland's corridor, the 102 on the climb and the four ring mechanisms,
// the rail, the Gates of Release, the deepening descent, Mauna, the centre
// bloom, the endless fall, the field's voices and the new ledger rows.
//
// The surviving principles are what is checked: position is identity, nothing
// grades him (no measuring words anywhere the building writes), a silence is
// never "felt", and the single ledger carries every new act.

@MainActor
final class OneBuildingTests: XCTestCase {

    // MARK: - The garland is a circle

    func testEverySeatHasTwoNeighboursAndTheCircleCloses() {
        XCTAssertEqual(Garland.neighbour(of: 1, -1), KhadgamalaMap.total)
        XCTAssertEqual(Garland.neighbour(of: KhadgamalaMap.total, 1), 1)
        XCTAssertEqual(Garland.neighbour(of: 50, 1), 51)
        XCTAssertNil(Garland.neighbour(of: 0, 1), "a position that is not a seat has no corridor")
        XCTAssertNil(Garland.neighbour(of: 103, 1))
        for kp in 1...KhadgamalaMap.total {
            let pair = Garland.neighbours(of: kp)
            XCTAssertNotNil(pair)
            XCTAssertNotEqual(pair?.before, kp)
            XCTAssertNotEqual(pair?.after, kp)
            // Walking out and back is standing where you began.
            if let after = pair?.after { XCTAssertEqual(Garland.neighbour(of: after, -1), kp) }
        }
    }

    // MARK: - The 102 on the climb

    func testAllHundredAndTwoStandAtTheirOwnAltitude() {
        var seen: [SIMD3<Double>] = []
        for kp in 1...KhadgamalaMap.total {
            let p = ClimbLights.position(kp: kp)
            XCTAssertTrue(p.x.isFinite && p.y.isFinite && p.z.isFinite, "kp \(kp) stands nowhere")
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let eye = WorldClimb.station(ring: ring) + WorldClimbScene.eyeRise
            XCTAssertLessThan(abs(p.y - eye), WorldClimb.spacing * 0.2,
                              "kp \(kp) does not stand in her own world (ring \(ring))")
            for q in seen {
                XCTAssertGreaterThan(simd_length(q - p), 1e-6, "two lights stand on one point")
            }
            seen.append(p)
        }
        XCTAssertEqual(ClimbLights.bareGarland.count, KhadgamalaMap.total)
        XCTAssertEqual((1...9).map(ClimbLights.seatsInRing), [28, 16, 8, 14, 10, 10, 12, 3, 1])
    }

    func testALightHeKnowsBreathesCalmerAndIsNeverDark() {
        let met = ClimbLights.breath(isAuthored: false, met: true)
        let stranger = ClimbLights.breath(isAuthored: false, met: false)
        let authored = ClimbLights.breath(isAuthored: true, met: false)
        XCTAssertLessThan(met.rate, stranger.rate, "she was expecting you — a met light is calmer")
        XCTAssertGreaterThan(met.size, stranger.size)
        XCTAssertGreaterThan(authored.size, stranger.size)
        for b in [met, stranger, authored] {
            for t in stride(from: 0.0, to: 60, by: 0.37) {
                let p = ClimbLights.pulse(b, kp: 17, at: t)
                XCTAssertGreaterThanOrEqual(p, 1 - 2 * b.depth - 1e-9)
                XCTAssertLessThanOrEqual(p, 1 + 1e-9)
            }
        }
        XCTAssertEqual(ClimbLights.visibility(swallow: 0), 1, accuracy: 1e-9)
        XCTAssertEqual(ClimbLights.visibility(swallow: 0.7), 0, accuracy: 1e-9)
    }

    func testTheFourMechanismsLiveInTheirOwnWorldsOnly() {
        // Ring 3 scatters at touch and gathers in stillness.
        let ringThree = KhadgamalaMap.ringStartOffset(3) + 1
        XCTAssertEqual(ClimbLights.scatter(kp: ringThree, agitation: 0), .zero)
        XCTAssertGreaterThan(simd_length(ClimbLights.scatter(kp: ringThree, agitation: 1)), 0)
        XCTAssertEqual(ClimbLights.scatter(kp: 1, agitation: 1), .zero, "the Bhūpura scattered")
        // Ring 8's three glide into one.
        let ringEight = KhadgamalaMap.ringStartOffset(8) + 1
        XCTAssertEqual(ClimbLights.gather(kp: ringEight, union: 0), .zero)
        let united = (99...101).map { ClimbLights.position(kp: $0) + ClimbLights.gather(kp: $0, union: 1) }
        let open = (99...101).map { ClimbLights.position(kp: $0) }
        XCTAssertLessThan(simd_length(united[0] - united[1]), simd_length(open[0] - open[1]) * 0.2,
                          "the three did not draw together")
        XCTAssertEqual(ClimbLights.gather(kp: 50, union: 1), .zero)
        // Ring 6's light reaches a name and whispers it; nothing else whispers.
        let points: [(kp: Int, x: Double, y: Double)] = [(77, 100, 100), (78, 300, 300), (50, 102, 102)]
        XCTAssertEqual(ClimbLights.whispered(from: points, lightX: 104, lightY: 98), 77)
        XCTAssertNil(ClimbLights.whispered(from: points, lightX: 900, lightY: 900))
        XCTAssertEqual(ClimbLights.whisperGloss(kp: 77), "made of knowing")
        XCTAssertNil(ClimbLights.whisperGloss(kp: 1))
        XCTAssertEqual(ClimbLights.ringSixGloss.count, ClimbLights.seatsInRing(6))
        // The state follows the hand as a closed form.
        XCTAssertEqual(ClimbLights.follow(0, toward: 1, dt: 0, tau: 1), 0, accuracy: 1e-12)
        XCTAssertEqual(ClimbLights.follow(0, toward: 1, dt: 100, tau: 1), 1, accuracy: 1e-9)
    }

    func testATouchChoosesTheNearestLightInFrontOfTheEye() {
        let points: [(kp: Int, x: Double, y: Double, depth: Double)] = [
            (3, 10, 10, 0.5), (4, 40, 40, 0.5), (5, 12, 12, 1.5),
        ]
        XCTAssertEqual(ClimbLights.picked(from: points, atX: 12, y: 12), 3,
                       "a light behind the eye was chosen")
        XCTAssertNil(ClimbLights.picked(from: points, atX: 300, y: 300))
    }

    func testTheFlightBeginsOnTheAxisAndEndsInHerLight() {
        XCTAssertEqual(ClimbFlight.progress(since: 10, now: 10), 0, accuracy: 1e-12)
        XCTAssertEqual(ClimbFlight.progress(since: 10, now: 10 + ClimbFlight.seconds), 1, accuracy: 1e-12)
        let axis = SIMD3<Double>(0, 1, 5), light = SIMD3<Double>(2, 1, -3)
        XCTAssertEqual(ClimbFlight.eye(from: axis, to: light, progress: 0), axis)
        XCTAssertEqual(ClimbFlight.eye(from: axis, to: light, progress: 1), light)
    }

    // MARK: - The rail of nine — place, never progress

    func testTheRailNamesNinePlacesAndCountsNothing() {
        let entries = ClimbRail.entries(here: 4, metRings: ClimbRail.metRings([3, 30, 31]))
        XCTAssertEqual(entries.map(\.ring), Array((1...9).reversed()), "the body stands: ninth at the top")
        XCTAssertEqual(entries.filter(\.isHere).map(\.ring), [4])
        XCTAssertEqual(Set(entries.filter(\.isMet).map(\.ring)), [1, 2])
        for e in entries {
            XCTAssertFalse(e.region.isEmpty)
            XCTAssertNil(Rx.first(#"\d"#, e.region), "the rail says a number: \(e.region)")
            XCTAssertTrue(NeverMeasure.measuresOutLoud(e.region).isEmpty)
        }
        // The same rail on the first day and the ten-thousandth, save for where
        // he has stood.
        XCTAssertEqual(ClimbRail.entries(here: 4, metRings: []).map(\.region), entries.map(\.region))
    }

    func testTheClimbsWordsAreDesignsAndMeasureNothing() {
        var said: [String] = [ClimbWords.hint, ClimbWords.presides]
        for ring in 1...9 {
            guard let w = HomeWorlds.world(ring: ring) else { return XCTFail("ring \(ring) has no world") }
            said += [ClimbWords.kicker(w), ClimbWords.material(w), w.weather]
        }
        said.append(ClimbWords.near(ClimbLights.Seat(kp: 4, name: "Garimā", quality: "Weightedness"),
                                    isToday: false))
        said.append(ClimbWords.near(ClimbLights.Seat(kp: 4), isToday: true))
        for s in said {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(s).isEmpty, "the climb measures out loud: \(s)")
            XCTAssertNil(Rx.first(#"\d"#, s), "the climb says a digit: \(s)")
        }
        XCTAssertEqual(ClimbWords.ordinal(1), "first")
        XCTAssertEqual(ClimbWords.ordinal(9), "ninth")
    }

    // MARK: - The Gates of Release

    func testGoingInSetsDownTheRingsMentalStateAndComingOutReceivesItsSiddhi() throws {
        let live: (Int) -> String? = { $0 == 4 ? "Turiya begins (live)" : nil }
        let siddhi: (Int) -> String? = { $0 == 4 ? "Garima (live)" : nil }

        let inward = try XCTUnwrap(TheGates.gate(from: 3, to: 4, mentalState: live, siddhi: siddhi))
        XCTAssertEqual(inward.way, .inward)
        XCTAssertEqual(inward.ring, 4, "going in, the gate is the enclosure he entered")
        XCTAssertEqual(inward.words, "Turiya begins (live)", "the live row's Mental State does not win")
        XCTAssertEqual(inward.instruction, TheGates.setDownWords)

        let outward = try XCTUnwrap(TheGates.gate(from: 4, to: 3, mentalState: live, siddhi: siddhi))
        XCTAssertEqual(outward.way, .outward)
        XCTAssertEqual(outward.ring, 4, "coming out, the gate is the enclosure he left")
        XCTAssertEqual(outward.words, "Garima (live)")
        XCTAssertEqual(outward.instruction, TheGates.receiveWords)

        XCTAssertNil(TheGates.gate(from: 5, to: 5, mentalState: live, siddhi: siddhi), "no crossing, no gate")
    }

    func testEveryRingHasItsOwnWordsWhenTheBaseIsSilent() throws {
        let none: (Int) -> String? = { _ in nil }
        XCTAssertEqual(TheGates.authoredSiddhi.count, 9)
        for ring in 1...9 {
            let inward = try XCTUnwrap(TheGates.gate(from: ring - 1, to: ring, mentalState: none, siddhi: none))
            XCTAssertEqual(inward.words, HomeWorlds.character(ring: ring)?.state)
            let outward = try XCTUnwrap(TheGates.gate(from: ring, to: ring - 1, mentalState: none, siddhi: none))
            XCTAssertEqual(outward.words, TheGates.authoredSiddhi[ring])
            for words in [inward.words, outward.words] {
                XCTAssertTrue(NeverMeasure.measuresOutLoud(words).isEmpty, words)
            }
        }
    }

    func testTheWordsArePutDownAndTheSiddhiRisesToHim() {
        let start = TheGates.putDown(0), end = TheGates.putDown(1)
        XCTAssertEqual(start.opacity, 1, accuracy: 1e-9)
        XCTAssertEqual(end.opacity, 0, accuracy: 1e-9)
        XCTAssertGreaterThan(end.dy, start.dy, "the words do not fall")
        XCTAssertLessThan(TheGates.receive(1).dy, 0, "the siddhi does not rise")
        XCTAssertGreaterThan(TheGates.offeredSeconds, TheGates.holdSeconds,
                             "a gate passes before it can be held")
    }

    // MARK: - The single ledger carries every new act

    func testTheNewActsAreLedgerRowsThatMeasureNothing() {
        let at = Date(timeIntervalSince1970: 1_790_000_000)
        for ring in 1...9 {
            let down = ActivityLedger.stateSetDown(ring: ring, state: "Pure witness", at: at)
            XCTAssertEqual(down.type, ActivityLedger.ActivityType.stateSetDown)
            XCTAssertEqual(down.descentRing, ring)
            XCTAssertEqual(down.gestureSource, ActivityLedger.GestureSource.mandala)
            XCTAssertNil(down.notes, "a gate's words are the ring's, never written as his")
            let up = ActivityLedger.siddhiReceived(ring: ring, siddhi: "Laghima (lightness)", at: at)
            XCTAssertEqual(up.type, ActivityLedger.ActivityType.siddhiReceived)
            XCTAssertEqual(up.descentRing, ring)
            for s in [down.name, down.detail, up.name, up.detail] {
                XCTAssertTrue(NeverMeasure.measuresOutLoud(s).isEmpty, "the ledger measures: \(s)")
            }
        }
        XCTAssertEqual(ActivityLedger.ActivityType.stateSetDown, "State Set Down")
        XCTAssertEqual(ActivityLedger.ActivityType.siddhiReceived, "Siddhi Received")
    }

    /// **A silence is never felt.** Mauna is a `Silence Held` row, linked to
    /// the point's own Śakti, from the silence gesture — never a recognition.
    func testMaunaIsASilenceHeldAndNeverARecognition() {
        let at = Date(timeIntervalSince1970: 1_790_000_000)
        let row = ActivityLedger.mauna(shaktiRecordId: "recPoint", name: "Mahātripurasundarī",
                                       durationSec: 31.5, at: at)
        XCTAssertEqual(row.type, ActivityLedger.ActivityType.silenceHeld)
        XCTAssertNotEqual(row.type, ActivityLedger.ActivityType.shaktiRecognized)
        XCTAssertEqual(row.gestureSource, ActivityLedger.GestureSource.silence)
        XCTAssertEqual(row.linkRecordId, "recPoint")
        XCTAssertEqual(row.durationSec, 31.5)
        for s in [row.name, row.detail] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(s).isEmpty, s)
        }
        XCTAssertEqual(MaunaSilence.pointPosition, KhadgamalaMap.total, "the point is not Lalitā's seat")
    }

    // MARK: - Mauna, the bloom, the fall

    func testMaunasWordsArriveDeeperAndThenThereIsOnlySilence() {
        XCTAssertNil(Mauna.caption(at: 3))
        XCTAssertEqual(Mauna.caption(at: 7), "All of her. Here. Always.")
        XCTAssertEqual(Mauna.caption(at: 15), "She has not gone anywhere.")
        XCTAssertEqual(Mauna.caption(at: 21), "You have not gone anywhere.")
        XCTAssertEqual(Mauna.caption(at: 40), "")
        XCTAssertEqual(Mauna.recordedAfter, 7, accuracy: 1e-9)
        for c in Mauna.captions {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(c.words).isEmpty)
            XCTAssertNil(Rx.first(#"\d"#, c.words), "Mauna counts the seconds out loud")
        }
        for t in stride(from: 0.0, to: 12, by: 0.5) {
            let b = Mauna.binduBreath(at: t)
            XCTAssertGreaterThanOrEqual(b, 1 - 1e-9)
            XCTAssertLessThanOrEqual(b, 1.1 + 1e-9)
        }
    }

    func testTheBloomDrawsTheYantraOutwardFromThePoint() {
        // Layers arrive inside-out, in Design's order.
        var firstLit: [CentreBloom.Layer: Double] = [:]
        for step in 0...1000 {
            let p = Double(step) / 1000
            for layer in CentreBloom.Layer.allCases where firstLit[layer] == nil {
                if CentreBloom.opacity(layer, bloom: p) > 0 { firstLit[layer] = p }
            }
        }
        let order = CentreBloom.Layer.allCases.sorted { (firstLit[$0] ?? 2) < (firstLit[$1] ?? 2) }
        XCTAssertEqual(order, [.trikona, .triangles, .lotus8, .lotus16, .bhupura, .names])
        XCTAssertEqual(CentreBloom.scale(bloom: 0), 0.05, accuracy: 1e-9)
        XCTAssertEqual(CentreBloom.scale(bloom: 1), 1, accuracy: 1e-9)

        // Held, it opens; let go, it returns to the point.
        let held = BloomPress().changed(holding: true, at: 0)
        XCTAssertGreaterThan(held.value(at: 2), 0.99)
        let released = held.changed(holding: false, at: 2)
        XCTAssertLessThan(released.value(at: 4), 0.01)
        XCTAssertFalse(released.isVisible(at: 10))
    }

    func testTheFallNeverReachesABottom() {
        for clock in stride(from: 0.0, to: 5, by: 0.013) {
            for layer in 0..<Pravesha.layers {
                let d = Pravesha.depth(layer: layer, clock: clock)
                XCTAssertGreaterThanOrEqual(d, 0)
                XCTAssertLessThan(d, 1)
            }
        }
        XCTAssertEqual(Pravesha.recognition(held: Pravesha.recognitionAfter), 0, accuracy: 1e-9)
        XCTAssertEqual(Pravesha.recognition(held: Pravesha.recognitionAfter + 10), 1, accuracy: 1e-9)
        XCTAssertLessThan(Pravesha.speed(holding: true, recognition: 1),
                          Pravesha.speed(holding: true, recognition: 0),
                          "the fall does not settle as the recognition arrives")
        XCTAssertLessThan(Pravesha.shepard(speed: 0.85), Pravesha.shepard(speed: 3))
        XCTAssertGreaterThan(Pravesha.scale(depth: 0.99), Pravesha.scale(depth: 0.01) * 50)
    }

    // MARK: - The field's voices

    func testEveryPlaceHasAVoiceAndTheClimbCrossfadesTwo() {
        for f in stride(from: 0.0, through: 8, by: 0.125) {
            let want = RingFieldVoice.want(climbFraction: f)
            XCTAssertFalse(want.isEmpty, "the climb is silent at \(f)")
            XCTAssertLessThanOrEqual(want.count, 2)
            XCTAssertEqual(want.values.reduce(0, +), 1, accuracy: 1e-9)
        }
        XCTAssertEqual(RingFieldVoice.want(enteredRing: 0), [0: 1], "the point is silent")
        XCTAssertEqual(RingFieldVoice.want(enteredRing: 7), [7: 1])
        XCTAssertNotNil(RingFieldVoice.steppedRoot(ring: 4))
        XCTAssertNotNil(RingFieldVoice.steppedRoot(ring: 5))
        XCTAssertGreaterThan(RingFieldVoice.stepPeriod(ring: 4), RingFieldVoice.stepPeriod(ring: 5))
        XCTAssertEqual(RingAudioService.vakFrequencies.count, 12, "the Vāk chord is not twelve voices")
        XCTAssertEqual(RingAudioService.sourcelessRoot, 136.1, accuracy: 1e-9)
    }
}
