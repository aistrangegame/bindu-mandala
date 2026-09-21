import XCTest
@testable import Bindu_Mandala

/// The nine worlds and the gem light — the pure half of Design's `homes-worlds.js`
/// and the gem block of `homes-chambers.js`.
///
/// Everything asserted here is a number Design chose or a number the repo
/// already owned. The point of the file is that neither can drift: the tables
/// are checked value by value, the two non-obvious shapes (the veil's monotone
/// climb, the tempo's deliberate *non*-monotone dip at ring 3) are pinned, the
/// light is checked against `Atmosphere` rather than against a copy of it, and
/// the tempo scalar is proven never to reach an adaptation clock.
final class HomeWorldsTests: XCTestCase {

    // MARK: - RING_CHARACTER, all nine, value by value

    func testRingCharacterCoversAllNineRings() {
        XCTAssertEqual(HomeWorlds.ringCharacter.count, 9)
        for ring in 1...9 {
            XCTAssertNotNil(HomeWorlds.character(ring: ring), "ring \(ring) has a character")
            XCTAssertEqual(HomeWorlds.character(ring: ring)?.ring, ring)
        }
        XCTAssertNil(HomeWorlds.character(ring: 0), "there is no tenth āvaraṇa")
        XCTAssertNil(HomeWorlds.character(ring: 10))
    }

    func testRingCharacterExactValues() {
        let expected: [(Int, String, String, String, Double, String, Double, String, String)] = [
            (1, "Tripurā", "Śṛṣṭi", "Prakaṭa — manifest", 0.00, "Jāgrat — waking", 1.00, "AGITATE", "Aim"),
            (2, "Tripureśī", "Śṛṣṭi", "Gupta — secret", 0.12, "Svapna — dreaming", 0.82, "LIQUEFY", "Klīm"),
            (3, "Tripurasundarī", "Śṛṣṭi", "Guptatara — more secret", 0.24, "Suṣupti — deep sleep", 0.62, "DRAW", "Sauḥ"),
            (4, "Tripuravāsinī", "Sthiti", "Sampradāya — lineage", 0.36, "Turīya begins", 0.72, "OPEN", "Hrīm"),
            (5, "Tripuraśrī", "Sthiti", "Kulottīrṇa — beyond clan", 0.48, "Turīya deepening", 0.66, "VOICE", "Hsraim"),
            (6, "Tripuramālinī", "Sthiti", "Nigarbha — in the womb", 0.60, "Turīyātīta begins", 0.50, "STILL", "Hsklhrīm"),
            (7, "Tripurasiddhā", "Saṃhāra", "Rahasya — secret", 0.72, "Pure witness", 0.44, "WITNESS", "Hsauḥ"),
            (8, "Tripurāmbā", "Saṃhāra", "Atirahasya — most secret", 0.86, "Source-consciousness", 0.36, "SEED", "Aim Klīm Sauḥ"),
            (9, "Mahātripurasundarī", "Saṃhāra", "Parāparāraharasya", 1.00, "Pure being", 0.28, "ARRIVE", "Hrīm"),
        ]
        for (ring, form, phase, yogini, veil, state, tempo, verb, bija) in expected {
            guard let c = HomeWorlds.character(ring: ring) else {
                return XCTFail("ring \(ring) missing")
            }
            XCTAssertEqual(c.form, form, "ring \(ring) form")
            XCTAssertEqual(c.phase, phase, "ring \(ring) phase")
            XCTAssertEqual(c.yogini, yogini, "ring \(ring) yoginī")
            XCTAssertEqual(c.veil, veil, accuracy: 1e-9, "ring \(ring) veil")
            XCTAssertEqual(c.state, state, "ring \(ring) state")
            XCTAssertEqual(c.tempo, tempo, accuracy: 1e-9, "ring \(ring) tempo")
            XCTAssertEqual(c.verb, verb, "ring \(ring) verb")
            XCTAssertEqual(c.bija, bija, "ring \(ring) bīja")
        }
    }

    /// The bīja column is the expansion doc's āvaraṇa table, unchanged:
    /// Aim · Klīm · Sauḥ · Hrīm · Hsraim · Hsklhrīm · Hsauḥ · Aim Klīm Sauḥ · Hrīm.
    func testRingBijasMatchTheAvaranaTable() {
        XCTAssertEqual((1...9).compactMap { HomeWorlds.character(ring: $0)?.bija },
                       ["Aim", "Klīm", "Sauḥ", "Hrīm", "Hsraim", "Hsklhrīm",
                        "Hsauḥ", "Aim Klīm Sauḥ", "Hrīm"])
    }

    // MARK: - The veil climbs; the tempo does not simply fall

    func testVeilIsMonotoneAndSpansZeroToOne() {
        let veils = (1...9).compactMap { HomeWorlds.character(ring: $0)?.veil }
        XCTAssertEqual(veils, HomeWorlds.veils)
        XCTAssertEqual(veils.first, 0.00, "the Bhūpura is unveiled")
        XCTAssertEqual(veils.last, 1.00, "the Bindu is wholly veiled")
        for i in 1..<veils.count {
            XCTAssertGreaterThan(veils[i], veils[i - 1], "secrecy deepens inward at ring \(i + 1)")
        }
    }

    /// The one shape that would be "corrected" by anyone porting from memory.
    func testTempoIsNotMonotone() {
        let tempi = (1...9).compactMap { HomeWorlds.character(ring: $0)?.tempo }
        XCTAssertEqual(tempi, HomeWorlds.tempi)
        XCTAssertEqual(tempi.first, 1.00, "the waking world runs at its own rate")
        XCTAssertLessThan(tempi[2], tempi[3],
                          "ring 3 (Suṣupti, 0.62) runs SLOWER than ring 4 (0.72) — Design's choice")
        let isDescending = zip(tempi, tempi.dropFirst()).allSatisfy { $0 > $1 }
        XCTAssertFalse(isDescending, "the tempo ramp must not be flattened into a monotone fall")
        XCTAssertEqual(tempi.min(), 0.28, "the Bindu is the slowest world")
        XCTAssertEqual(tempi.max(), 1.00)
    }

    // MARK: - WORLDS, all nine, value by value

    func testWorldsCoverAllNineRings() {
        XCTAssertEqual(HomeWorlds.worlds.count, 9)
        for ring in 1...9 {
            XCTAssertNotNil(HomeWorlds.world(ring: ring), "ring \(ring) has a world")
        }
        XCTAssertNil(HomeWorlds.world(ring: 0))
        XCTAssertNil(HomeWorlds.world(ring: 10))
    }

    func testWorldExactValues() {
        let expected: [(Int, String, String, String, String, String, Int, Double)] = [
            (1, "Trailokyamohana", "Topaz", "Rasa", "day–night", "Feet", 0x1d1206, 0.0125),
            (2, "Sarvāśāparipūraka", "Sapphire", "Rakta", "the hour", "Pelvis", 0x0a1330, 0.017),
            (3, "Sarvasaṅkṣobhaṇa", "Coral", "Māṃsa", "the day", "Navel", 0x2a0c06, 0.021),
            (4, "Sarvasaubhāgyadāyaka", "Diamond", "Medas", "lunar fortnight", "Heart", 0x0b1219, 0.014),
            (5, "Sarvārthasādhaka", "Emerald", "Asthi", "lunar month", "Throat", 0x06180e, 0.018),
            (6, "Sarvarakṣākara", "Ruby", "Majjā", "season", "Forehead", 0x1a0409, 0.022),
            (7, "Sarvarogahara", "Pearl", "Śukra", "solar half-year", "Crown", 0xd8d2c4, 0.034),
            (8, "Sarvasiddhiprada", "Cat's eye", "Ojas", "year", "Above crown", 0x0f0b04, 0.015),
            (9, "Sarvānandamaya", "All gems", "Tejas", "kāla–akāla", "Totality", 0x141008, 0.009),
        ]
        for (ring, name, gem, dhatu, clock, region, fog, density) in expected {
            guard let w = HomeWorlds.world(ring: ring) else { return XCTFail("ring \(ring) missing") }
            XCTAssertEqual(w.name, name, "ring \(ring) name")
            XCTAssertEqual(w.gem, gem, "ring \(ring) gem")
            XCTAssertEqual(w.dhatu, dhatu, "ring \(ring) dhātu")
            XCTAssertEqual(w.clock, clock, "ring \(ring) clock")
            XCTAssertEqual(w.region, region, "ring \(ring) body region")
            XCTAssertEqual(w.fog.hex, fog, "ring \(ring) fog colour")
            XCTAssertEqual(w.fogDensity, density, accuracy: 1e-9, "ring \(ring) fog density")
            XCTAssertFalse(w.weather.isEmpty, "ring \(ring) has weather")
            XCTAssertEqual(w.character, HomeWorlds.character(ring: ring),
                           "every world carries its character")
        }
    }

    /// The gem names on the world table and the gem names on the light must be
    /// the same nine words — one table cannot drift from the other.
    func testGemNamesAgreeBetweenWorldAndLight() {
        for ring in 1...9 {
            XCTAssertEqual(HomeWorlds.world(ring: ring)?.gem,
                           HomeGem.gemFor(ring: ring, khadgamalaPosition: nil).gem,
                           "ring \(ring) gem name")
        }
    }

    func testFogColourComponents() {
        // 0xd8d2c4 — the Crown's pale, and the only world whose fog is light.
        guard let crown = HomeWorlds.world(ring: 7) else { return XCTFail("ring 7 missing") }
        XCTAssertEqual(crown.fog.red, 216 / 255, accuracy: 1e-9)
        XCTAssertEqual(crown.fog.green, 210 / 255, accuracy: 1e-9)
        XCTAssertEqual(crown.fog.blue, 196 / 255, accuracy: 1e-9)
        for ring in 1...9 {
            guard let f = HomeWorlds.world(ring: ring)?.fog else { return XCTFail("ring \(ring)") }
            for c in [f.red, f.green, f.blue] {
                XCTAssertTrue((0...1).contains(c), "ring \(ring) fog component in range")
            }
        }
    }

    // MARK: - The veil scales the fog, and nothing else

    func testVeilScalesFogDensity() {
        for ring in 1...9 {
            guard let w = HomeWorlds.world(ring: ring) else { return XCTFail("ring \(ring)") }
            XCTAssertEqual(w.veiledFogDensity,
                           w.fogDensity * (1 + w.character.veil * 0.55),
                           accuracy: 1e-12, "ring \(ring) veiled density")
        }
    }

    func testUnveiledWorldKeepsItsAuthoredDensityAndTheBinduIsThickest() {
        guard let bhupura = HomeWorlds.world(ring: 1), let bindu = HomeWorlds.world(ring: 9) else {
            return XCTFail("rings 1 and 9 missing")
        }
        XCTAssertEqual(bhupura.veiledFogDensity, bhupura.fogDensity, accuracy: 1e-12,
                       "veil 0 leaves the air exactly as authored")
        XCTAssertEqual(bindu.veiledFogDensity, bindu.fogDensity * 1.55, accuracy: 1e-12,
                       "veil 1 is 1.55× the fog")
    }

    func testVeiledDensityNeverShrinksTheAir() {
        for ring in 1...9 {
            guard let w = HomeWorlds.world(ring: ring) else { return XCTFail("ring \(ring)") }
            XCTAssertGreaterThanOrEqual(w.veiledFogDensity, w.fogDensity,
                                        "ring \(ring): the veil may only thicken")
        }
    }

    // MARK: - Law 1 — the live base wins over Design's strings

    func testLiveBaseOverridesTheFourAirtableStrings() {
        let live = HomeWorlds.LiveFacts(sanskritName: "Sarvāśāparipūraka Cakra",
                                        presidingForm: "Tripureśī Devī",
                                        yogini: "Gupta Yoginis (Secret)",
                                        mentalState: "Svapna (Dream)")
        guard let w = HomeWorlds.world(ring: 2, live: live) else { return XCTFail("ring 2") }
        XCTAssertEqual(w.name, "Sarvāśāparipūraka Cakra")
        XCTAssertEqual(w.character.form, "Tripureśī Devī")
        XCTAssertEqual(w.character.yogini, "Gupta Yoginis (Secret)")
        XCTAssertEqual(w.character.state, "Svapna (Dream)")
        // Everything the base does not carry is untouched.
        XCTAssertEqual(w.gem, "Sapphire")
        XCTAssertEqual(w.dhatu, "Rakta")
        XCTAssertEqual(w.clock, "the hour")
        XCTAssertEqual(w.region, "Pelvis")
        XCTAssertEqual(w.character.veil, 0.12, accuracy: 1e-9)
        XCTAssertEqual(w.character.tempo, 0.82, accuracy: 1e-9)
        XCTAssertEqual(w.character.bija, "Klīm")
        XCTAssertEqual(w.fogDensity, 0.017, accuracy: 1e-9)
    }

    func testSilentBaseLeavesTheAuthoredValueStanding() {
        let blank = HomeWorlds.LiveFacts(sanskritName: "", presidingForm: nil,
                                         yogini: "   ", mentalState: nil)
        guard let w = HomeWorlds.world(ring: 6, live: blank),
              let authored = HomeWorlds.world(ring: 6) else { return XCTFail("ring 6") }
        XCTAssertEqual(w, authored, "empty and absent both mean the base has nothing to say")
    }

    func testNoLiveFactsIsTheAuthoredWorld() {
        for ring in 1...9 {
            XCTAssertEqual(HomeWorlds.world(ring: ring, live: nil), HomeWorlds.world(ring: ring))
        }
        XCTAssertNil(HomeWorlds.world(ring: 12, live: HomeWorlds.LiveFacts(sanskritName: "x")))
    }

    // MARK: - The gem light IS the app's light

    /// The world shown empty: the ring's unjittered seed, straight off `Atmosphere`.
    func testEmptyWorldLightMatchesAtmosphereSeed() {
        for ring in 1...9 {
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: nil)
            let seed = Atmosphere.seedHue(ring: ring, cluster: nil)
            XCTAssertEqual(gem.hue, seed, "ring \(ring) empty-world seed")
            XCTAssertNil(gem.cluster, "an empty world has no seat")
        }
    }

    /// Every one of the 102 seats: the gem light and `Atmosphere.derive` must
    /// produce the same hue, because they are the same derivation.
    func testGemForAgreesWithAtmosphereForAllOneHundredTwoSeats() {
        for kp in 1...KhadgamalaMap.total {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: kp)
            let atmosphere = Atmosphere.derive(ring: ring, cluster: gem.cluster,
                                               khadgamala: kp, element: .ether)
            XCTAssertEqual(gem.hue.h, atmosphere.hue.h, accuracy: 1e-9, "kp \(kp) hue")
            XCTAssertEqual(gem.hue.s, atmosphere.hue.s, accuracy: 1e-9, "kp \(kp) saturation")
            XCTAssertEqual(gem.hue.l, atmosphere.hue.l, accuracy: 1e-9, "kp \(kp) lightness")
        }
    }

    /// All sixteen ring-2 cluster seats, by position and by hue.
    func testRingTwoSeatsSeedFromTheirClusterNotTheRing() {
        let expected: [Int: Cluster] = [
            29: .inner, 30: .inner, 31: .inner,
            32: .tanmatra, 33: .tanmatra, 34: .tanmatra, 35: .tanmatra, 36: .tanmatra,
            37: .citta,
            38: .stability, 39: .stability, 40: .stability, 41: .stability,
            42: .selfBody, 43: .selfBody, 44: .selfBody,
        ]
        XCTAssertEqual(expected.count, 16)
        for kp in 29...44 {
            let gem = HomeGem.gemFor(ring: 2, khadgamalaPosition: kp)
            XCTAssertEqual(gem.cluster, expected[kp], "kp \(kp) cluster seat")
            guard let cluster = gem.cluster else { return XCTFail("kp \(kp) has no seat") }
            let clusterSeed = Atmosphere.clusterHue(cluster)
            XCTAssertEqual(gem.hue.s, clusterSeed.s, accuracy: 1e-9, "kp \(kp) cluster saturation")
            XCTAssertEqual(gem.hue.l, clusterSeed.l, accuracy: 1e-9, "kp \(kp) cluster lightness")
            XCTAssertEqual(gem.hue.h,
                           Atmosphere.derive(ring: 2, cluster: cluster,
                                             khadgamala: kp, element: .ether).hue.h,
                           accuracy: 1e-9, "kp \(kp) jittered cluster hue")
        }
        // Sisters of one cluster share a light; neighbours across a boundary do not.
        XCTAssertEqual(HomeGem.gemFor(ring: 2, khadgamalaPosition: 29).hue.s,
                       HomeGem.gemFor(ring: 2, khadgamalaPosition: 31).hue.s, accuracy: 1e-9)
        XCTAssertNotEqual(HomeGem.gemFor(ring: 2, khadgamalaPosition: 31).hue.s,
                          HomeGem.gemFor(ring: 2, khadgamalaPosition: 32).hue.s)
    }

    /// The `.inner` default that all 86 carry must never reach a light outside
    /// ring 2 (Ruling 7) — the seat is read off the position, not off a field.
    func testTheEightySixNeverSeedFromACluster() {
        for kp in 1...KhadgamalaMap.total where !(29...44).contains(kp) {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            XCTAssertNil(HomeGem.gemFor(ring: ring, khadgamalaPosition: kp).cluster,
                         "kp \(kp) is not a lotus seat")
        }
        // Even asked for ring 2 with a position that is not in the lotus.
        XCTAssertNil(HomeGem.gemFor(ring: 2, khadgamalaPosition: 70).cluster)
    }

    // MARK: - The ±7° jitter

    func testJitterStaysWithinSevenDegreesForEveryPosition() {
        for kp in 1...KhadgamalaMap.total {
            let j = Atmosphere.jitter(kp, HomeGem.jitterRange)
            XCTAssertTrue((-7.0...7.0).contains(j), "kp \(kp) jitter \(j) outside ±7°")

            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: kp)
            let seed = Atmosphere.seedHue(ring: ring, cluster: gem.cluster)
            // Compare on the circle: the seed hue may be near 0 and wrap.
            var delta = gem.hue.h - seed.h
            if delta > 180 { delta -= 360 }
            if delta < -180 { delta += 360 }
            XCTAssertLessThanOrEqual(abs(delta), 7.0 + 1e-9,
                                     "kp \(kp) hue moved \(delta)° off its ring seed")
            XCTAssertTrue((0..<360).contains(gem.hue.h), "kp \(kp) hue wrapped into [0,360)")
        }
    }

    func testJitterIsStableAndDistinguishesSisters() {
        XCTAssertEqual(HomeGem.gemFor(ring: 2, khadgamalaPosition: 29).hue,
                       HomeGem.gemFor(ring: 2, khadgamalaPosition: 29).hue,
                       "the light is the same on every launch")
        XCTAssertNotEqual(HomeGem.gemFor(ring: 2, khadgamalaPosition: 29).hue.h,
                          HomeGem.gemFor(ring: 2, khadgamalaPosition: 30).hue.h,
                          "sisters differ")
    }

    // MARK: - GEM_BEHAVIOUR

    func testDiffusionPerRing() {
        let expected: [Int: (String, Double)] = [
            1: ("Topaz", 0.20), 2: ("Sapphire", 0.30), 3: ("Coral", 0.45),
            4: ("Diamond", 0.15), 5: ("Emerald", 0.25), 6: ("Ruby", 0.55),
            7: ("Pearl", 0.95), 8: ("Cat's eye", 0.10), 9: ("All gems", 0.70),
        ]
        XCTAssertEqual(HomeGem.behaviour.count, 9)
        for ring in 1...9 {
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: nil)
            XCTAssertEqual(gem.gem, expected[ring]?.0, "ring \(ring) gem")
            XCTAssertEqual(gem.diffuse, expected[ring]?.1 ?? -1, accuracy: 1e-9,
                           "ring \(ring) diffusion")
            XCTAssertTrue((0...1).contains(gem.diffuse))
        }
        XCTAssertEqual(HomeGem.gemFor(ring: 8, khadgamalaPosition: nil).diffuse, 0.10,
                       accuracy: 1e-9, "cat's eye is the hardest light")
        XCTAssertEqual(HomeGem.gemFor(ring: 7, khadgamalaPosition: nil).diffuse, 0.95,
                       accuracy: 1e-9, "pearl is the softest")
    }

    /// The Crown alone is lit from nowhere — no directional light in ring 7.
    func testOnlyTheCrownIsSourceless() {
        for ring in 1...9 {
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: nil)
            if ring == 7 {
                XCTAssertTrue(gem.isSourceless, "the Crown is sourceless")
                XCTAssertFalse(gem.hasDirectionalLight, "ring 7 admits no directional light")
            } else {
                XCTAssertFalse(gem.isSourceless, "ring \(ring) has a source")
                XCTAssertTrue(gem.hasDirectionalLight, "ring \(ring) admits a directional key")
            }
        }
        XCTAssertEqual(HomeGem.sourcelessRing, 7)
        // It holds for a seated Śakti too, not only for the empty world.
        XCTAssertTrue(HomeGem.gemFor(ring: 7, khadgamalaPosition: 90).isSourceless)
    }

    func testBrightAndInkStayInsideTheTokenFamily() {
        for kp in 1...KhadgamalaMap.total {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: kp)
            XCTAssertEqual(gem.bright.h, gem.hue.h, accuracy: 1e-9, "kp \(kp): bright keeps her hue")
            XCTAssertLessThanOrEqual(gem.bright.s, 88)
            XCTAssertLessThanOrEqual(gem.bright.l, 78)
            XCTAssertGreaterThanOrEqual(gem.bright.l, gem.hue.l)
            XCTAssertEqual(gem.ink.h, gem.hue.h, accuracy: 1e-9, "kp \(kp): the dhātu is her hue")
            XCTAssertEqual(gem.ink.l, 12, accuracy: 1e-9)
            XCTAssertLessThan(gem.ink.s, gem.hue.s + 1e-9)
        }
    }

    // MARK: - The two clocks, which must never become one

    func testTempoScalesTheWorldClock() {
        for ring in 1...9 {
            guard let tempo = HomeWorlds.character(ring: ring)?.tempo else { return XCTFail("ring \(ring)") }
            XCTAssertEqual(HomeWorlds.worldClock(100, ring: ring), 100 * tempo, accuracy: 1e-9,
                           "ring \(ring) world clock")
        }
        XCTAssertGreaterThan(HomeWorlds.worldClock(100, ring: 1),
                             HomeWorlds.worldClock(100, ring: 9),
                             "the Bindu's weather moves slowest")
        XCTAssertEqual(HomeWorlds.worldClock(100, ring: 42), 100, accuracy: 1e-9,
                       "an unknown ring is left unscaled")
    }

    /// The law at the timing layer: a slow ring must not buy a cheaper
    /// adaptation than a fast one. The tempo scalar never reaches this clock.
    func testTempoIsNeverAppliedToAnAdaptationClock() {
        let marks: [TimeInterval] = [0, 1, 30, 61.9, 62, 226.9, 227, 346.9, 347, 600]
        for ring in 1...9 {
            for t in marks {
                XCTAssertEqual(HomeWorlds.adaptationClock(t, ring: ring), t, accuracy: 1e-12,
                               "ring \(ring): the adaptation clock is never scaled at \(t)s")
            }
        }
    }

    func testEveryRingCrossesEveryAdaptationAtTheSameSecond() {
        let first = HomeMemory.firstAdaptation      // 62
        let hold = HomeMemory.holdEnd               // 227
        for ring in 1...9 {
            let justBeforeFirst = HomeWorlds.adaptationClock(first - 0.1, ring: ring)
            let atFirst = HomeWorlds.adaptationClock(first, ring: ring)
            let justBeforeSecond = HomeWorlds.adaptationClock(hold - 0.1, ring: ring)
            let atSecond = HomeWorlds.adaptationClock(hold, ring: ring)
            XCTAssertEqual(HomeMemory.adaptation(atChamberTime: justBeforeFirst), 0,
                           "ring \(ring) has not adapted before 62s")
            XCTAssertEqual(HomeMemory.adaptation(atChamberTime: atFirst), 1,
                           "ring \(ring) adapts at 62s, not sooner")
            XCTAssertEqual(HomeMemory.adaptation(atChamberTime: justBeforeSecond), 1,
                           "ring \(ring) has not reached the second before 227s")
            XCTAssertEqual(HomeMemory.adaptation(atChamberTime: atSecond), 2,
                           "ring \(ring) reaches the second at 227s, not sooner")
        }
    }

    /// The concrete cheat the separation prevents: had the world clock been
    /// handed to the adaptation, the Bindu (tempo 0.28) would have reached the
    /// second adaptation at 227s of *its* time — 63 real seconds — while the
    /// Bhūpura still waited the full 227.
    func testASlowRingCannotReachTheSecondAdaptationEarly() {
        let hold = HomeMemory.holdEnd
        let cheat = HomeWorlds.worldClock(hold, ring: 9)
        XCTAssertLessThan(cheat, hold, "the slow world's clock does run behind")
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: cheat), 1,
                       "and that lag is precisely why it must never be the adaptation clock")
        XCTAssertEqual(HomeMemory.adaptation(
            atChamberTime: HomeWorlds.adaptationClock(hold, ring: 9)), 2)
    }
}
