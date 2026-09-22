import XCTest
import CoreGraphics
@testable import Bindu_Mandala

// MARK: - MandalaLightTests — the Mandala's light, proved off-device
//
// Phase 5's arithmetic is a pure value type on purpose, exactly as ``HomeGem``
// and ``HomeWorlds`` are, so the one screen Ashrey opens first can be checked
// without a simulator, a camera or a frame.
//
// Four things are asserted here that nothing else in the suite can see:
//
//   1. **the light is one light** — one source, falling with distance, bent by
//      behaviour and never by a gemstone's name;
//   2. **nothing in it measures him** — not the veil, not the brightness, not
//      the radius, and the source itself carries no count-family identifier;
//   3. **the veil stays above FIDELITY §4's legibility floor** at its deepest;
//   4. **reduce motion gets a real still path**, and Tratak is not handed to it
//      early in exchange.
//
// Three of those are source scans as well as arithmetic, because the failure
// they guard against is a line somebody adds later, not a number that is wrong
// today. The scans reuse `LawsTests`' own corpus reader (`LawSource`) so they
// read the shipping files off disk rather than a copy typed out here.

final class MandalaLightTests: XCTestCase {

    // MARK: - 27 · one source, nine refractions

    /// The Bindu is the source, and the light falls as it travels out.
    func testTheLightFallsFromTheBinduOutward() {
        XCTAssertEqual(MandalaLight.reach(ring: 9), 1, accuracy: 1e-12,
                       "ring 9 is the Bindu: it does not receive the light, it is the light")
        for ring in 1..<9 {
            XCTAssertLessThan(MandalaLight.reach(ring: ring),
                              MandalaLight.reach(ring: ring + 1),
                              "the \(ring)th enclosure should hold less of the source than the \(ring + 1)th")
        }
        // Far, not dark: the Bhūpura's rooms must still be lit enough to read as
        // seats rather than as absences.
        XCTAssertGreaterThan(MandalaLight.reach(ring: 1), 0.3,
                             "the outermost enclosure has gone dark rather than distant")
    }

    /// The source is `Atmosphere`'s own ninth-ring hue, not a colour invented
    /// for this file — so the Mandala and every Home are lit by one palette.
    func testTheSourceIsTheInstrumentsOwnNinthHue() {
        XCTAssertEqual(MandalaLight.source, Atmosphere.ringHue(9))
    }

    /// The gem does exactly one job — it bends — and the amount it bends by is
    /// its `diffuse`, straight from ``HomeGem``.
    func testTheGemIsTakenAsBehaviourAndNothingElse() {
        for ring in 1...9 {
            let gem = HomeGem.behaviour[ring]
            XCTAssertNotNil(gem, "ring \(ring) has no gem behaviour")
            XCTAssertEqual(MandalaLight.scatter(ring: ring), gem!.diffuse, accuracy: 1e-12)
            XCTAssertEqual(MandalaLight.refraction(ring: ring),
                           (1 - gem!.diffuse) * MandalaLight.refractionLimit, accuracy: 1e-12)
        }
        // A ring nobody has heard of inherits the home ring's behaviour rather
        // than none — the light is never behaviourless (HomeGem's own fallback).
        XCTAssertEqual(MandalaLight.scatter(ring: 42), HomeGem.behaviour[2]!.diffuse, accuracy: 1e-12)
    }

    /// **The corrected mistake stays corrected.** `HomeGem`'s header records
    /// that Design derived a room's colour from the gemstone's name and then
    /// took it back: *"topaz is not a hue the walker's light is allowed to come
    /// from."* Idea 27 as the expansion doc writes it asks for exactly that
    /// again. This reads the shipped file and refuses it.
    func testNoGemstoneNameAppearsInTheLight() {
        guard let file = LawSource.production("MandalaLight.swift") else {
            return XCTFail("MandalaLight.swift is not in the shipping corpus")
        }
        let body = String(file.lexed.masked)     // comments blanked, code intact
        for ring in 1...9 {
            let gem = HomeGem.behaviour[ring]!.gem
            XCTAssertFalse(body.lowercased().contains(gem.lowercased()),
                           "the light names the gemstone “\(gem)”; the gem is a behaviour, never a colour")
        }
    }

    /// A Śakti is always more herself than she is the source. The refraction is
    /// bounded, and a seat's arriving hue never crosses the halfway point.
    func testRefractionNeverTakesHerPastHerself() {
        for ring in 1...9 {
            XCTAssertLessThanOrEqual(MandalaLight.refraction(ring: ring),
                                     MandalaLight.refractionLimit)
            let light = MandalaLightField(viewportRadius: 400, stillness: 0).light(ring: ring)
            for kp in [1, 29, 44, 57, 102] {
                let own = Atmosphere.derive(ring: ring, cluster: nil, khadgamala: kp,
                                            element: .ether).hue
                let arrived = light.refracted(own)
                let toSource = Self.arc(own.h, MandalaLight.source.h)
                let travelled = Self.arc(own.h, arrived.h)
                XCTAssertLessThanOrEqual(travelled, toSource * MandalaLight.refractionLimit + 1e-9,
                                         "ring \(ring), seat \(kp): her hue travelled further than the limit")
                XCTAssertLessThanOrEqual(travelled, toSource / 2 + 1e-9,
                                         "ring \(ring), seat \(kp): she is now more the source than herself")
            }
        }
    }

    /// Hues mix along the shorter arc. A red seat on its way to the Bindu's gold
    /// must not travel backwards through every colour in between.
    func testHuesMixTheShortWayRound() {
        let red = HSL(h: 341, s: 45, l: 58)          // Atmosphere's third ring
        let gold = MandalaLight.source               // h 46
        let half = MandalaLight.mix(red, gold, 0.5)
        // 341 → 46 the short way is +65°, so halfway is 13.5°, not 193.5°.
        XCTAssertEqual(half.h, 13.5, accuracy: 0.001)
        XCTAssertEqual(MandalaLight.mix(red, gold, 0).h, red.h, accuracy: 1e-9)
        XCTAssertEqual(MandalaLight.mix(red, gold, 1).h, gold.h, accuracy: 1e-9)
        // Out-of-range t is clamped, never extrapolated past either end.
        XCTAssertEqual(MandalaLight.mix(red, gold, 4).h, gold.h, accuracy: 1e-9)
        XCTAssertEqual(MandalaLight.mix(red, gold, -4).h, red.h, accuracy: 1e-9)
    }

    /// **Position is identity, in the light too.** All 102 seats, lit through
    /// this engine, come back 102 different colours — the light adds a term to
    /// `Atmosphere`, it does not collapse the field into nine.
    func testEverySeatStillResolvesByPosition() {
        let field = MandalaLightField(viewportRadius: 400, stillness: 1)
        var seen: [String: Int] = [:]
        for kp in 1...KhadgamalaMap.total {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let cluster = HomeGem.ring2Cluster(ring: ring, khadgamalaPosition: kp)
            let own = Atmosphere.derive(ring: ring, cluster: cluster, khadgamala: kp,
                                        element: .ether).hue
            let lit = field.light(ring: ring).seatColor(own: own, felt: false)
            let key = String(format: "%.4f/%.4f/%.4f", lit.h, lit.s, lit.l)
            if let other = seen[key] {
                XCTFail("seats \(other) and \(kp) are lit identically — the light has lost her position")
            }
            seen[key] = kp
        }
        XCTAssertEqual(seen.count, KhadgamalaMap.total)
    }

    /// The reduction from a count to a state lives on the **model**, not on the
    /// screen — so the number never travels to a surface that draws, and a
    /// future refactor has nothing there to turn into a dimension.
    func testWhetherSheHasBeenFeltIsAnsweredByTheStoreNotTheScreen() {
        guard let model = LawSource.production("Shakti.swift"),
              let host = LawSource.production("LivingMandalaView.swift") else {
            return XCTFail("the model or its host is not in the shipping corpus")
        }
        XCTAssertTrue(String(model.lexed.masked).contains("hasBeenFelt"),
                      "the store no longer answers whether she has been felt")
        XCTAssertTrue(String(host.lexed.masked).contains("hasBeenFelt"),
                      "the Mandala no longer asks the store; it is deriving the state itself")
        XCTAssertFalse(String(host.lexed.masked).contains("serverRecognitionCount"),
                       "the Mandala reaches the count again")
    }

    /// Whether she has been felt is a state and may be seen. It is a `Bool` and
    /// there is nothing behind it.
    func testTheOnlyThingTheLightKnowsAboutPracticeIsWhetherNotHowOften() {
        let l = MandalaLightField(viewportRadius: 400, stillness: 1).light(ring: 2)
        let own = Atmosphere.ringHue(2)
        XCTAssertNotEqual(l.seatColor(own: own, felt: true), l.seatColor(own: own, felt: false),
                          "a felt seat should look different — the instrument remembering is not a measure")
        // Called twice with the same answer, the light is the same light: there
        // is no accumulator anywhere in it.
        XCTAssertEqual(l.seatColor(own: own, felt: true), l.seatColor(own: own, felt: true))
    }

    // MARK: - 30 · the veil

    /// The gradient is `HomeWorlds`' own, and it is monotone inward. Nothing is
    /// derived here that the āvaraṇa table has already said.
    func testTheVeilIsTheAvaranaTablesOwnGradient() {
        let field = MandalaLightField(viewportRadius: 400, stillness: 0)
        for ring in 1...9 {
            XCTAssertEqual(field.light(ring: ring).veil, HomeWorlds.veils[ring - 1], accuracy: 1e-12)
        }
        for ring in 1..<9 {
            XCTAssertLessThan(HomeWorlds.veils[ring - 1], HomeWorlds.veils[ring],
                              "secrecy must deepen inward")
        }
    }

    /// **The one that would have gone wrong if nobody said so now.** A veil that
    /// lifts with familiarity is a completion meter drawn as fog — unreadable as
    /// a number, perfectly readable as *how far along I am*. Its inputs are the
    /// ring, how near the viewport is and how still the glass is, and this
    /// reads the shipped file to prove nothing else can reach it.
    func testTheVeilCanNeverKnowWhatHeHasDone() {
        guard let file = LawSource.production("MandalaLight.swift") else {
            return XCTFail("MandalaLight.swift is not in the shipping corpus")
        }
        let body = String(file.lexed.masked)
        let forbidden = ["countByKp", "serverRecognitionCount", "recognitionCount",
                         "RecognitionEntry", "RecognitionLogStore", "HomeMemory",
                         "HomeMemoryStore", "lastFelt", "ActivityLedger", "feltCount",
                         "streak", "visits"]
        for id in forbidden {
            XCTAssertFalse(body.contains(id),
                           "the light reaches \(id) — the veil may only know ring, nearness and stillness")
        }
        // And the same for the canvas's own veil call sites: the whole render
        // path is count-free after this phase.
        guard let canvas = LawSource.production("MandalaCanvasLayer.swift") else {
            return XCTFail("MandalaCanvasLayer.swift is not in the shipping corpus")
        }
        let canvasBody = String(canvas.lexed.masked)
        for id in ["countByKp", "serverRecognitionCount", "recognitionCount"] {
            XCTAssertFalse(canvasBody.contains(id),
                           "the canvas still reaches \(id)")
        }
    }

    /// Far away it stands; close and still it clears; and it closes again the
    /// moment she moves. All three are present-tense — the same on the first day
    /// and the ten-thousandth.
    func testTheVeilClearsOnlyFromNearnessAndStillnessAndAlwaysCloses() {
        let deep = 8
        let far = MandalaLight.veiling(ring: deep, viewportRadius: 900, stillness: 1)
        let nearMoving = MandalaLight.veiling(ring: deep, viewportRadius: 40, stillness: 0)
        let nearStill = MandalaLight.veiling(ring: deep, viewportRadius: 40, stillness: 1)

        XCTAssertGreaterThan(far, nearMoving, "falling toward an enclosure should begin to clear it")
        XCTAssertGreaterThan(nearMoving, nearStill, "holding still should finish what nearness began")
        XCTAssertEqual(nearStill, 0, accuracy: 1e-12, "still and close, the veil is gone")
        XCTAssertEqual(far, HomeWorlds.veils[deep - 1] * (1 - 52.0 / 900.0 * MandalaLight.nearnessShare
                                                         - 52.0 / 900.0 * (1 - MandalaLight.nearnessShare)),
                       accuracy: 1e-9)

        // Waiting from far away buys nothing at all.
        let farPatient = MandalaLight.veiling(ring: deep, viewportRadius: 100_000, stillness: 1)
        XCTAssertEqual(farPatient, HomeWorlds.veils[deep - 1], accuracy: 1e-3,
                       "stillness at a distance must not clear a secret")

        // Moving again closes it: the same inputs give the same answer, and a
        // reset of the stillness clock restores the standing veil exactly.
        XCTAssertEqual(MandalaLight.veiling(ring: deep, viewportRadius: 40, stillness: 0), nearMoving)

        // Monotone in both inputs, over a grid rather than at three points.
        for radius in stride(from: 20.0, through: 1200.0, by: 40) {
            var previous = Double.infinity
            for s in stride(from: 0.0, through: 1.0, by: 0.05) {
                let v = MandalaLight.veiling(ring: deep, viewportRadius: radius, stillness: s)
                XCTAssertLessThanOrEqual(v, previous + 1e-12,
                                         "the veil thickened while she held still")
                previous = v
            }
        }
    }

    /// The Bindu is a point and has no radius, so it answers nearness with the
    /// last place there is to be before arriving. Without this it would be the
    /// one enclosure that could never clear.
    func testTheBinduCanBeArrivedAt() {
        XCTAssertGreaterThan(MandalaLight.veilRadius(ring: 9), 0)
        XCTAssertEqual(MandalaLight.nearness(ring: 9, viewportRadius: 10), 1)
        XCTAssertEqual(MandalaLight.veiling(ring: 9, viewportRadius: 10, stillness: 1), 0, accuracy: 1e-12)
    }

    /// **FIDELITY §4's floor holds at the deepest veil.** Mist dims a mark; it
    /// does not make a name unreadable.
    func testTheDeepestVeilStillClearsTheLegibilityFloor() {
        for ring in 1...9 {
            for radius in stride(from: 10.0, through: 4000.0, by: 25) {
                for s in stride(from: 0.0, through: 1.0, by: 0.1) {
                    let l = MandalaLightField(viewportRadius: radius, stillness: s).light(ring: ring)
                    for base in [0.5, 0.55, 0.6, 0.85, 1.0] {
                        XCTAssertGreaterThanOrEqual(
                            l.veiledText(base), MandalaLight.legibleTextAlpha - 1e-12,
                            "ring \(ring) veiled a \(base)-alpha word below the legibility floor")
                    }
                    // A mark may dim, but never to nothing.
                    XCTAssertGreaterThan(l.veiledMark(1), 0.5,
                                         "ring \(ring) took more than half a mark's light")
                }
            }
        }
    }

    // MARK: - reduce motion, and the gaze

    /// **A real still path, not a zero-duration animation.** Under reduce motion
    /// the veil is handed the value it comes to rest at, without consulting a
    /// clock — the same answer for every elapsed time there is, including none.
    func testReduceMotionGetsTheSettledVeilRatherThanAFastOne() {
        for dt in [-5.0, 0, 0.001, 1, 3.999, 4, 40, 4000] {
            XCTAssertEqual(MandalaLight.stillness(untouchedFor: dt, reduceMotion: true), 1,
                           "reduce motion should be given the settled veil at every moment")
        }
        // And with motion it genuinely settles over the span, from nothing.
        XCTAssertEqual(MandalaLight.stillness(untouchedFor: 0, reduceMotion: false), 0)
        XCTAssertEqual(MandalaLight.stillness(untouchedFor: MandalaLight.stillnessSpan / 2,
                                              reduceMotion: false), 0.5, accuracy: 1e-12)
        XCTAssertEqual(MandalaLight.stillness(untouchedFor: MandalaLight.stillnessSpan * 9,
                                              reduceMotion: false), 1)
    }

    /// Tratak is earned by stillness and by nothing else — and reduce motion
    /// does not buy it early. It takes no `reduceMotion` argument at all, which
    /// is the strongest form of that promise available in a signature.
    func testTratakIsEarnedAndIsNotShortenedForAnyone() {
        XCTAssertEqual(MandalaLight.tratak(untouchedFor: 0), 0)
        XCTAssertEqual(MandalaLight.tratak(untouchedFor: MandalaLight.tratakOnset), 0)
        XCTAssertEqual(MandalaLight.tratak(untouchedFor: MandalaLight.tratakFull), 1)
        XCTAssertEqual(MandalaLight.tratak(untouchedFor: MandalaLight.tratakFull * 10), 1)
        var previous = -1.0
        for dt in stride(from: 0.0, through: 90.0, by: 0.5) {
            let v = MandalaLight.tratak(untouchedFor: dt)
            XCTAssertGreaterThanOrEqual(v, previous)
            previous = v
        }
        XCTAssertGreaterThan(MandalaLight.tratakOnset, 10,
                             "a gaze that arrives in a few seconds is not a gaze")

        // Under reduce motion there is no coming-up to watch: nothing, and then
        // the whole thing, at the same moment everyone else's finishes. Never
        // earlier than the moving form, at any point of the gaze.
        for dt in stride(from: 0.0, through: 120.0, by: 0.25) {
            let moving = MandalaLight.tratak(untouchedFor: dt, reduceMotion: false)
            let still = MandalaLight.tratak(untouchedFor: dt, reduceMotion: true)
            XCTAssertTrue(still == 0 || still == 1,
                          "reduce motion was given a partial gaze at \(dt)s — that is a fade")
            XCTAssertLessThanOrEqual(still, moving + 1e-12,
                                     "reduce motion was handed Tratak early at \(dt)s")
            XCTAssertEqual(moving, MandalaLight.tratak(untouchedFor: dt), accuracy: 1e-12)
        }
        XCTAssertEqual(MandalaLight.tratak(untouchedFor: MandalaLight.tratakFull,
                                           reduceMotion: true), 1)
    }

    // MARK: - 31 · the fall speaks the mantra

    /// The nine syllables are the āvaraṇa table's, retyped nowhere.
    func testTheNineBijasAreTheAvaranaTablesOwn() {
        for ring in 1...9 {
            XCTAssertEqual(RingBija.syllable(ring: ring),
                           HomeWorlds.ringCharacter[ring]!.bija)
            XCTAssertFalse(RingBija.syllable(ring: ring).isEmpty, "ring \(ring) has no bīja")
        }
        // The eighth carries the three-syllable core, and sounds as three.
        XCTAssertEqual(RingBija.syllables(ring: 8).count, 3)
        for ring in [1, 2, 3, 4, 5, 6, 7, 9] {
            XCTAssertEqual(RingBija.syllables(ring: ring).count, 1,
                           "ring \(ring) should sound as one syllable")
        }
    }

    /// The descent keeps the pitch contour it always had — the crossing is a
    /// substitution of what sounds, never of where the descent sits in the ear.
    func testTheCrossingKeepsThePitchItAlwaysHad() {
        for ring in 1...9 {
            let old = 528.0 * pow(0.917, Double(ring - 1))
            XCTAssertEqual(RingBija.root(ring: ring), old, accuracy: 1e-9)
            for note in RingBija.voicing(ring: ring) {
                XCTAssertEqual(note.frequency, old, accuracy: 1e-9)
                XCTAssertGreaterThanOrEqual(note.partial, note.frequency)
                XCTAssertGreaterThan(note.duration, 0)
                XCTAssertGreaterThanOrEqual(note.delay, 0)
            }
        }
        // A lower tone sustains longer, so the syllables hang further down —
        // monotone across all nine, from the pitch and from nothing else.
        for ring in 1..<9 {
            XCTAssertLessThan(RingBija.duration(ring: ring), RingBija.duration(ring: ring + 1))
        }
        XCTAssertEqual(RingBija.duration(ring: 1), 1.2, accuracy: 1e-9)

        // And it is **not** taken from the world's tempo. `WorldClimbTests`
        // pins that constant to the two files that define and report it, so a
        // third reader has to be argued for; a bell that happens to ring for
        // about as long as a world's clock is slow is a coincidence of shape,
        // not an argument. This is the assertion that keeps the door shut.
        if let file = LawSource.production("RingBija.swift") {
            let body = String(file.lexed.masked)
            XCTAssertFalse(body.contains("tempo"), "the falling mantra reads the world's tempo")
            XCTAssertFalse(body.contains("tempi"))
        } else {
            XCTFail("RingBija.swift is not in the shipping corpus")
        }
    }

    /// The vowel is what opens the interval, read off the syllable rather than
    /// assigned beside it — and read longest-first, so `ai` is never mistaken
    /// for a bare vowel.
    func testTheIntervalComesFromTheSyllablesOwnVowel() {
        XCTAssertEqual(RingBija.interval(forSyllable: "Aim"), 5.0 / 4.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Hsraim"), 5.0 / 4.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Sauḥ"), 5.0 / 3.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Hsauḥ"), 5.0 / 3.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Klīm"), 3.0 / 2.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Hrīm"), 3.0 / 2.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "Hsklhrīm"), 3.0 / 2.0, accuracy: 1e-12)
        XCTAssertEqual(RingBija.interval(forSyllable: "ma"), 1, accuracy: 1e-12)
    }

    /// **Sounded, never stacked.** A falling mantra that is also written down
    /// the glass is a list of the enclosures crossed — a position indicator
    /// while you are in it and a completion list if it survived the session. No
    /// view may read this type.
    func testTheMantraIsSoundedAndNeverWritten() {
        let views = LawSource.production.filter { $0.path.hasPrefix("Views/") }
        XCTAssertGreaterThan(views.count, 20, "the view corpus went empty — this check proves nothing")
        // The distinction is exact and load-bearing: a view may *sound* the
        // crossing — `RingAudioService.ringBija(_:)` is the same opt-in hook the
        // bell used — but no view may reach the **type**, because the type is
        // where the syllables are and a syllable a view can read is a syllable a
        // view can draw.
        for file in views {
            XCTAssertFalse(String(file.lexed.masked).contains("RingBija."),
                           "\(file.path) reads the falling mantra's syllables; "
                           + "they are sounded, never written")
        }
        // Nor does a voice say it: the spoken surface is `MandalaVoice`'s, and
        // it is already complete without a syllable a synthesiser cannot say.
        if let voice = LawSource.production("MandalaVoice.swift") {
            XCTAssertFalse(String(voice.lexed.masked).contains("RingBija"))
            XCTAssertFalse(String(voice.lexed.masked).contains("bija"))
        }
    }

    // MARK: - the flag

    /// Off unless asked for, and asked for the way every other launch switch in
    /// this app is asked for.
    func testThePhaseFlagIsOffUnlessTheLaunchAsksForIt() {
        XCTAssertFalse(MandalaLight.enabled,
                       "the unit-test host did not pass MANDALA_LIGHT=on, so the light must be off")
    }

    /// **The flag genuinely gates.** With it off no light is ever built: the
    /// canvas's one construction site sits behind the guard, and every `draw*`
    /// that takes a light falls back to the shipped expression when it is nil.
    func testWithTheFlagOffNoLightIsEverBuilt() {
        guard let canvas = LawSource.production("MandalaCanvasLayer.swift") else {
            return XCTFail("MandalaCanvasLayer.swift is not in the shipping corpus")
        }
        let body = String(canvas.lexed.masked)
        let sites = body.components(separatedBy: "MandalaLightField(").count - 1
        XCTAssertEqual(sites, 1, "the light should be built in exactly one place in the canvas")
        guard let build = body.range(of: "MandalaLightField("),
              let gate = body.range(of: "guard lightOn else { return nil }") else {
            return XCTFail("the canvas no longer guards its one light on the phase flag")
        }
        XCTAssertLessThan(gate.lowerBound, build.lowerBound,
                          "the light is built before the flag is consulted")

        // And the switch is read in one file in the whole app.
        let readers = LawSource.production.filter {
            String($0.lexed.masked).contains("MandalaLight.enabled")
        }
        XCTAssertEqual(readers.map(\.name), ["LivingMandalaView.swift"],
                       "the phase flag should be read in exactly one file")
    }

    /// The count-free radius, on **both** sides of the flag.
    ///
    /// The flag gates the light. It does not gate a law: the seven-step ramp
    /// that sized each seat by how many times she had been felt is gone whether
    /// the light is on or off, which is the one respect in which the unlit
    /// canvas is deliberately not what `main` drew.
    func testTheSeatRadiusIsAStateAndNotATally() {
        guard let canvas = LawSource.production("MandalaCanvasLayer.swift") else {
            return XCTFail("MandalaCanvasLayer.swift is not in the shipping corpus")
        }
        let body = String(canvas.lexed.masked)
        XCTAssertFalse(body.contains("min(CGFloat(n), 6)"),
                       "the seven-step practice ramp is back in the canvas")
        XCTAssertTrue(body.contains("feltRadius"), "the felt radius should be one named number")
        XCTAssertTrue(body.contains("unfeltRadius"))
    }

    // MARK: - helpers

    /// The shorter arc between two hues, in degrees.
    private static func arc(_ a: Double, _ b: Double) -> Double {
        var d = abs(HSL.wrap(b - a))
        if d > 180 { d = 360 - d }
        return d
    }
}
