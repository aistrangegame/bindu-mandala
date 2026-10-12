import XCTest
import simd
import CoreGraphics
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

    /// **C-1284 — specialness collapses; everything ordinary is special.** Wave
    /// 2 pinned that a met light was larger and calmer than a stranger's. That
    /// split the 102 by his walking. Now *she was expecting you* is true of
    /// every seat alike: met or not, the breath is the same. Only an authored
    /// room's light is larger, which describes the building, not him.
    func testEveryLightBreathesTheSameWelcomeMetOrNot() {
        let met = ClimbLights.breath(isAuthored: false, met: true)
        let stranger = ClimbLights.breath(isAuthored: false, met: false)
        let authored = ClimbLights.breath(isAuthored: true, met: false)
        XCTAssertEqual(met, stranger, "the 102 are divided into special and not by his walking")
        XCTAssertEqual(ClimbLights.breath(isAuthored: true, met: true), authored)
        XCTAssertEqual(stranger.rate, 0.22, accuracy: 1e-12, "every light carries Design's welcomed calm")
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
        XCTAssertEqual(inward.instruction, TheGates.offerWords)

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

    /// **C-1230 — "it has to be something to get, not something to give up."**
    /// Wave 2 pinned that the words *fall* at the inward gate — a thing let
    /// drop. Now the inward gate is an offering: the words are lifted and open
    /// into the light, the instruction says *offer*, and what is left is named
    /// as his. Both crossings are gains.
    func testTheInwardGateIsAnOfferingAndBothWaysAreGains() {
        let start = TheGates.offer(0), end = TheGates.offer(1)
        XCTAssertEqual(start.opacity, 1, accuracy: 1e-9)
        XCTAssertEqual(end.opacity, 0, accuracy: 1e-9)
        XCTAssertLessThan(end.dy, start.dy, "the offering falls — it should be lifted")
        XCTAssertGreaterThan(end.scale, start.scale, "the offering closes instead of opening into the light")
        XCTAssertLessThan(TheGates.receive(1).dy, 0, "the siddhi does not rise")
        for words in [TheGates.offerWords, TheGates.offeredWords, TheGates.receiveWords, TheGates.receivedWords] {
            for loss in ["set it down", "give up", "let go of", "lose"] {
                XCTAssertFalse(words.lowercased().contains(loss), "the gate speaks of losing: \(words)")
            }
        }
        XCTAssertTrue(TheGates.offerWords.contains("offer"))
        let at = Date(timeIntervalSince1970: 1_790_000_000)
        let row = ActivityLedger.stateSetDown(ring: 4, state: "Turiya begins", at: at)
        XCTAssertTrue(row.name.hasSuffix("offered"), row.name)
        XCTAssertTrue(row.detail.hasPrefix("Offered"), row.detail)
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

    /// **C-1355 — "the system holds the door open and never the watch."**
    /// Wave 2 pinned Design's captions at 7, 14 and 21 seconds; they were a
    /// clock on his silence and are gone. What is asserted now is that the
    /// silence follows his stillness and nothing else: time alone, with the
    /// phone moving, takes it nowhere, and stillness alone takes it all the way.
    func testMaunaFollowsHisStillnessAndNeverAClock() throws {
        XCTAssertEqual(Mauna.recordedAfter, 7, accuracy: 1e-9, "the ledger's floor is unchanged")

        var moving = MaunaDepth()
        for _ in 0..<(60 * 20) { moving.advance(dt: 0.05, steadiness: 0.2, recognition: 0) }
        XCTAssertEqual(moving.depth, 0, accuracy: 1e-12, "time passed, and the silence deepened anyway")
        XCTAssertEqual(moving.maya, 1, accuracy: 1e-12, "the Maya light thinned without being looked at")
        XCTAssertFalse(moving.isFalling)

        var still = MaunaDepth()
        var everFell = false
        for _ in 0..<(60 * 20) {
            still.advance(dt: 0.05, steadiness: 1, recognition: 0)
            everFell = everFell || still.isFalling
        }
        XCTAssertEqual(still.depth, 1, accuracy: 1e-9)
        XCTAssertEqual(still.maya, 0, accuracy: 1e-9, "the Maya light did not dissolve when looked at")
        XCTAssertTrue(everFell)
        XCTAssertFalse(still.opens, "the point opened before the recognition had come")

        // Moving gives it back — a state that returns, never "you cleared it".
        var loosened = still
        for _ in 0..<40 { loosened.advance(dt: 0.05, steadiness: 0, recognition: 0) }
        XCTAssertLessThan(loosened.depth, still.depth)
        XCTAssertGreaterThan(loosened.maya, still.maya - 1e-12)

        for t in stride(from: 0.0, to: 12, by: 0.5) {
            let b = Mauna.binduBreath(at: t)
            XCTAssertGreaterThanOrEqual(b, 1 - 1e-9)
            XCTAssertLessThanOrEqual(b, 1.1 + 1e-9)
        }
        // The words in the silence are his and Design's, and none of them is a number.
        for words in [WhoIsSaying.line, WhoIsSaying.beneath, Pointy.loves, MaunaView.hint,
                      Pravesha.falling, Pravesha.fallingBeneath, Pravesha.recognised] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(words).isEmpty, words)
            XCTAssertNil(Rx.first(#"\d"#, words), "the silence speaks a digit: \(words)")
        }
        XCTAssertEqual(WhoIsSaying.line, "Who is saying that?", "C-1305, verbatim")
    }

    /// **C-1307 — "What is above creation cannot be attained by action."** The
    /// silence arrives; it is not opened. Untouched for one breath, fallen in to
    /// the innermost enclosures, with the point near the middle of the glass —
    /// and only once in one stillness.
    func testTheSilenceArrivesByStillnessAtTheCentreAndIsNeverOpened() {
        let size = CGSize(width: 390, height: 844)
        let middle = CGPoint(x: 195, y: 422)
        let breath = CentreArrival.oneBreath
        XCTAssertTrue(CentreArrival.arrives(untouchedFor: breath, enteredRing: 8, point: middle,
                                            size: size, restedSinceLastMove: false))
        XCTAssertFalse(CentreArrival.arrives(untouchedFor: breath - 0.5, enteredRing: 8, point: middle,
                                             size: size, restedSinceLastMove: false),
                       "it arrived before he had been still for one breath")
        XCTAssertFalse(CentreArrival.arrives(untouchedFor: breath * 4, enteredRing: 3, point: middle,
                                             size: size, restedSinceLastMove: false),
                       "it arrived far out in the yantra, away from the centre")
        XCTAssertFalse(CentreArrival.arrives(untouchedFor: breath * 4, enteredRing: 8,
                                             point: CGPoint(x: 20, y: 60), size: size,
                                             restedSinceLastMove: false),
                       "it arrived with the point at the edge of the glass")
        XCTAssertFalse(CentreArrival.arrives(untouchedFor: breath * 4, enteredRing: 8, point: middle,
                                             size: size, restedSinceLastMove: true),
                       "it arrived twice in one stillness")

        // Stillness stays the main way (C-1307): the point still notices him.
        // Wave 6.1 · and, by his own decision (gameplan §4.1, 12 Oct), a gentle
        // tap at the point also opens the silence when he wants it now — one
        // tap, which arrives exactly as the stillness does (`arrive()`), and
        // nothing else on the point opens it.
        guard let centre = LawSource.production("TheCentre.swift") else {
            return XCTFail("TheCentre.swift is gone")
        }
        let code = String(centre.lexed.masked)
        let theCentre = Rx.first(#"struct TheCentre: View \{[\s\S]*?\n\}"#, code) ?? ""
        XCTAssertFalse(theCentre.isEmpty, "the centre's own view could not be read")
        XCTAssertTrue(theCentre.contains("CentreArrival.arrives("), "the centre no longer notices stillness")
        XCTAssertTrue(theCentre.contains("onTapGesture { arrive() }"),
                      "his gentle tap at the point no longer opens the silence (his decision, 12 Oct)")
        XCTAssertEqual(theCentre.components(separatedBy: "onTapGesture").count - 1, 1,
                       "the point has grown a second tap")
        XCTAssertTrue(theCentre.contains("accessibilityAction"), "a voice can no longer reach the silence")
    }

    /// **The fall follows his stillness and the point opens to him** — only
    /// after the recognition has come and he has rested in it.
    func testThePointOpensOnlyAfterHeRestsInTheRecognition() {
        var d = MaunaDepth()
        for _ in 0..<(60 * 20) { d.advance(dt: 0.05, steadiness: 1, recognition: 0) }
        XCTAssertFalse(d.opens)
        for _ in 0..<20 { d.advance(dt: 0.05, steadiness: 1, recognition: 1) }
        XCTAssertFalse(d.opens, "it opened the instant the recognition came")
        for _ in 0..<200 { d.advance(dt: 0.05, steadiness: 1, recognition: 1) }
        XCTAssertTrue(d.opens)
        // A voice's "rest here" stands for a still phone.
        var voice = MaunaDepth()
        for _ in 0..<(60 * 20) { voice.advance(dt: 0.05, steadiness: 0, givenOver: true, recognition: 0) }
        XCTAssertEqual(voice.depth, 1, accuracy: 1e-9, "VoiceOver cannot reach the fall")
    }

    /// **Pointy** (C-1306): the same particles, one at every point at once —
    /// line, circle, ∞, heart — each figure whole at its own place.
    func testPointyDrawsALineACircleInfinityAndAHeart() {
        XCTAssertEqual(Pointy.particles, KhadgamalaMap.total)
        // At 0 every particle is on one line.
        for i in 0..<Pointy.particles {
            XCTAssertEqual(Pointy.place(particle: i, progress: 0).y, 0, accuracy: 1e-9)
        }
        // At 1 every particle is on the circle.
        for i in 0..<Pointy.particles {
            let p = Pointy.place(particle: i, progress: 1)
            XCTAssertEqual(hypot(p.x, p.y), 1, accuracy: 1e-9)
        }
        XCTAssertEqual(Pointy.figure(at: 0), .line)
        XCTAssertEqual(Pointy.figure(at: 1), .circle)
        XCTAssertEqual(Pointy.figure(at: 2), .infinity)
        XCTAssertEqual(Pointy.figure(at: 3), .heart)
        XCTAssertNil(Pointy.figure(at: 1.5))
        // Past the heart it stays the heart.
        let past = Pointy.place(particle: 7, progress: 9)
        let heart = Pointy.point(.heart, t: 7 / Double(Pointy.particles))
        XCTAssertEqual(past.x, heart.x, accuracy: 1e-9)
        XCTAssertEqual(past.y, heart.y, accuracy: 1e-9)
        var d = MaunaDepth()
        XCTAssertEqual(d.pointy, 0, accuracy: 1e-12)
        for _ in 0..<(60 * 20) { d.advance(dt: 0.05, steadiness: 1, recognition: 0) }
        XCTAssertEqual(d.pointy, 3, accuracy: 1e-9, "Pointy never reached the heart")
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
