import XCTest
@testable import Bindu_Mandala

/// The Homes' voice, checked where it can be checked: the arithmetic.
///
/// `HomeCarrier` is deliberately engine-free — no `AVAudioEngine`, no session,
/// no hardware — so every number Design's `homes-sound.js` fixes can be
/// asserted here by hand. The one engine-touching thing these tests exercise is
/// `stopAll()` on a service that never started, which by construction allocates
/// nothing.
@MainActor
final class HomeSoundTests: XCTestCase {

    private let epsilon = 0.000001

    // MARK: - The roots

    /// Design's per-ring roots, feet to totality. These — not
    /// `RingAudioService`'s constants — are the carrier's reference, because
    /// that service has no root at all for rings 4, 5 and 7.
    func testRootsAreDesignsTable() {
        XCTAssertEqual(HomeCarrier.roots,
                       [55.0, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47])
    }

    func testRootPerRingReadsTheTableAndClamps() {
        XCTAssertEqual(HomeCarrier.root(forRing: 1), 55.0, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.root(forRing: 9), 123.47, accuracy: epsilon)
        // Design clamps the index rather than trapping.
        XCTAssertEqual(HomeCarrier.root(forRing: 0), 55.0, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.root(forRing: 42), 123.47, accuracy: epsilon)
    }

    func testVarnaIsTheFortyNineAndJustIsTwelve() {
        XCTAssertEqual(HomeCarrier.varna.count, 49)
        XCTAssertEqual(HomeCarrier.varna.first, "a")
        XCTAssertEqual(HomeCarrier.varna.last, "ha")
        XCTAssertEqual(HomeCarrier.just.count, 12)
    }

    // MARK: - The techniques

    /// The handoff's §5 keep-and-extend table, all nine rings.
    func testTechniqueMapsEveryRing() {
        let expected: [Int: String] = [
            1: "drone", 2: "breath", 3: "breathy", 4: "stepped", 5: "stepped",
            6: "breathy", 7: "sourceless", 8: "triad", 9: "shepard",
        ]
        for ring in 1...9 {
            XCTAssertEqual(HomeCarrier.technique(forRing: ring).rawValue,
                           expected[ring],
                           "ring \(ring)")
        }
    }

    /// Seven is the witness — left sourceless, no fundamental at all.
    func testSeventhIsSourceless() {
        XCTAssertEqual(HomeCarrier.technique(forRing: 7), .sourceless)
    }

    // MARK: - stem()

    func testStemDropsTrailingAnusvara() {
        XCTAssertEqual(HomeCarrier.stem("aṃ"), "a")
        XCTAssertEqual(HomeCarrier.stem("Hrīṃ"), "hrī")
        // The other anusvāra spelling (ṁ, U+1E41) reduces the same way.
        XCTAssertEqual(HomeCarrier.stem("aṁ"), "a")
    }

    func testStemDropsTrailingVisarga() {
        XCTAssertEqual(HomeCarrier.stem("aḥ"), "a")
        XCTAssertEqual(HomeCarrier.stem("Sauḥ"), "sau")
    }

    func testStemOfNothingIsNothingAndOfBareAnusvaraIsTheVowel() {
        XCTAssertNil(HomeCarrier.stem(nil))
        XCTAssertNil(HomeCarrier.stem(""))
        XCTAssertNil(HomeCarrier.stem("   "))
        XCTAssertEqual(HomeCarrier.stem("ṃ"), "a")
    }

    func testStemIsIndifferentToDecomposition() {
        // "aṃ" written as a + combining dot-below reduces like the precomposed one.
        XCTAssertEqual(HomeCarrier.stem("am\u{0323}"), "a")
    }

    // MARK: - carrierFor()

    /// A vowel bīja: Aṃ stems to "a", index 0, JUST[0] = 1, folded an octave up.
    func testCarrierForVowelBija() {
        XCTAssertEqual(HomeCarrier.carrierFor(root: 55.0, syllable: "Aṃ"),
                       110.0, accuracy: epsilon)
    }

    /// A consonant bīja: "ka" stands at 16 in the series; 16 % 12 = 4, and
    /// JUST[4] is 5/4. 55 × 5/4 × 2 = 137.5.
    func testCarrierForConsonantBija() {
        XCTAssertEqual(HomeCarrier.carrierFor(root: 55.0, syllable: "ka"),
                       137.5, accuracy: epsilon)
    }

    /// A compound bīja takes its first letter's place: Klīṃ → "klī", which is
    /// not in the series, so it stands where "ka" stands.
    func testCompoundBijaTakesItsFirstLetter() {
        XCTAssertEqual(HomeCarrier.carrierFor(root: 55.0, syllable: "Klīṃ"),
                       HomeCarrier.carrierFor(root: 55.0, syllable: "ka"),
                       accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.carrierFor(root: 55.0, syllable: "Klīṃ"),
                       137.5, accuracy: epsilon)
        // Hrīṃ → "hrī" → "ha" at 48; 48 % 12 = 0, so the bare octave.
        XCTAssertEqual(HomeCarrier.carrierFor(root: 61.74, syllable: "Hrīṃ"),
                       123.48, accuracy: epsilon)
        // Sauḥ → "sau" → "sa" at 47; 47 % 12 = 11, and JUST[11] is 15/8.
        XCTAssertEqual(HomeCarrier.carrierFor(root: 123.47, syllable: "Sauḥ"),
                       123.47 * (15.0 / 8.0) * 2, accuracy: epsilon)
    }

    /// Where the cards name no syllable, the carrier is simply the root —
    /// silence about what we do not know, rather than a plausible number.
    func testMissingSyllableIsTheBareRoot() {
        XCTAssertEqual(HomeCarrier.carrierFor(root: 92.50, syllable: nil),
                       92.50, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.carrierFor(root: 92.50, syllable: ""),
                       92.50, accuracy: epsilon)
    }

    /// Two intervals computed by hand straight off Design's tables.
    func testExactRatiosForKnownSyllables() {
        // "ma" is 40 in the series; 40 % 12 = 4 → 5/4. Ring 5's root is 82.41.
        XCTAssertEqual(HomeCarrier.carrierFor(ring: 5, syllable: "ma"),
                       82.41 * 1.25 * 2, accuracy: epsilon)
        // "ai" is 11 in the series → 15/8. Ring 1's root is 55.
        XCTAssertEqual(HomeCarrier.carrierFor(ring: 1, syllable: "ai"),
                       55.0 * (15.0 / 8.0) * 2, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.carrierFor(ring: 1, syllable: "ai"),
                       206.25, accuracy: epsilon)
    }

    /// Kaumārī's Caṃ stands in a fixed relation to Brāhmī's Aṃ because the
    /// alphabet puts them there: "ca" is 21, 21 % 12 = 9 → 5/3.
    func testTheAlphabetFixesTheRelation() {
        let am = HomeCarrier.carrierFor(root: 55.0, syllable: "Aṃ")
        let cam = HomeCarrier.carrierFor(root: 55.0, syllable: "Caṃ")
        XCTAssertEqual(cam / am, 5.0 / 3.0, accuracy: epsilon)
    }

    /// An unknown letter that matches nothing at all falls to the head of the
    /// series rather than off it.
    func testUnknownLetterFallsToTheFirstPlace() {
        XCTAssertEqual(HomeCarrier.carrierFor(root: 55.0, syllable: "zzz"),
                       110.0, accuracy: epsilon)
    }

    // MARK: - The strike

    func testStrikeSoundsUnisonFifthAndOctave() {
        let carrier = HomeCarrier.carrierFor(ring: 1, syllable: "ka")
        XCTAssertEqual(HomeCarrier.strikeFrequency(ring: 1, beat: 1, syllable: "ka"),
                       carrier, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeFrequency(ring: 1, beat: 2, syllable: "ka"),
                       carrier * 1.5, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeFrequency(ring: 1, beat: 3, syllable: "ka"),
                       carrier * 2, accuracy: epsilon)
        // Out of range clamps rather than becoming Design's NaN.
        XCTAssertEqual(HomeCarrier.strikeFrequency(ring: 1, beat: 0, syllable: "ka"),
                       carrier, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeFrequency(ring: 1, beat: 9, syllable: "ka"),
                       carrier * 2, accuracy: epsilon)
    }

    // MARK: - The withheld fifth

    /// Silent unless granted.
    func testFifthIsWithheldUntilGranted() {
        for ring in 1...8 {
            XCTAssertEqual(HomeCarrier.fifthGain(b: 0, ring: ring), 0, accuracy: epsilon,
                           "ring \(ring) should withhold the fifth")
        }
        // The second adaptation grants it.
        XCTAssertEqual(HomeCarrier.fifthGain(b: 1, ring: 3), 0.05, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.fifthGain(b: 0.5, ring: 3), 0.025, accuracy: epsilon)
    }

    /// The ninth world grants it outright, with no adaptation at all.
    func testNinthWorldGrantsTheFifthOutright() {
        XCTAssertEqual(HomeCarrier.fifthGain(b: 0, ring: 9), 0.05, accuracy: epsilon)
    }

    // MARK: - The room

    func testAdaptationOpensTheFilterAndTheOneAirLayer() {
        XCTAssertEqual(HomeCarrier.filterCutoff(adaptation: 0), 220, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.filterCutoff(adaptation: 1), 1720, accuracy: epsilon)
        // Design has one air layer, not a roomtone and a breath layer.
        XCTAssertEqual(HomeCarrier.airGain(adaptation: 0), 0.006, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.airGain(adaptation: 1), 0.018, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.airCutoff(adaptation: 0), 380, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.airCutoff(adaptation: 1), 1080, accuracy: epsilon)
    }

    func testLevelsMatchDesign() {
        XCTAssertEqual(HomeCarrier.groundLevel, 0.16, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.carrierLevel, 0.1, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.wakeLevel, 0.5, accuracy: epsilon)
    }

    // MARK: - Design's table, line by line

    // Everything below is `homes-sound.js` read across into assertions, so that
    // a constant which drifts from Design's file fails the build rather than
    // quietly becoming a different instrument. Where the JS computes a value
    // rather than writing it out, the computation is repeated here by hand.

    /// Feet to totality. The order is what is canonical — Design says so in its
    /// own margin — so it is asserted as an order, not only as a list.
    func testTheRootsAscend() {
        XCTAssertEqual(HomeCarrier.roots.count, 9)
        for i in 1..<HomeCarrier.roots.count {
            XCTAssertGreaterThan(HomeCarrier.roots[i], HomeCarrier.roots[i - 1],
                                 "root \(i + 1) must sit above root \(i)")
        }
    }

    /// The varṇamālā exactly as Design writes it — all forty-nine, in order.
    /// Reorder two and every carrier above them moves, so it is asserted whole
    /// rather than by its ends.
    func testVarnamalaIsDesignsSeriesInOrder() {
        XCTAssertEqual(HomeCarrier.varna, [
            "a", "ā", "i", "ī", "u", "ū", "ṛ", "ṝ", "ḷ", "ḹ", "e", "ai", "o", "au", "aṃ", "aḥ",
            "ka", "kha", "ga", "gha", "ṅa", "ca", "cha", "ja", "jha", "ña",
            "ṭa", "ṭha", "ḍa", "ḍha", "ṇa", "ta", "tha", "da", "dha", "na",
            "pa", "pha", "ba", "bha", "ma", "ya", "ra", "la", "va", "śa", "ṣa", "sa", "ha",
        ])
    }

    func testJustIntervalsAreDesignsTwelve() {
        let expected: [Double] = [
            1, 16.0 / 15.0, 9.0 / 8.0, 6.0 / 5.0, 5.0 / 4.0, 4.0 / 3.0,
            45.0 / 32.0, 3.0 / 2.0, 8.0 / 5.0, 5.0 / 3.0, 16.0 / 9.0, 15.0 / 8.0,
        ]
        XCTAssertEqual(HomeCarrier.just.count, expected.count)
        for (i, value) in expected.enumerated() {
            XCTAssertEqual(HomeCarrier.just[i], value, accuracy: epsilon, "JUST[\(i)]")
        }
    }

    /// Every `setTargetAtTime` time constant in the JS. Together they are the
    /// room's whole sense of time.
    func testTimeConstantsAreDesignsSetTargetAtTimes() {
        XCTAssertEqual(HomeCarrier.Tau.master, 1.2, accuracy: epsilon)        // wake()
        XCTAssertEqual(HomeCarrier.Tau.masterOut, 0.5, accuracy: epsilon)     // stop()
        XCTAssertEqual(HomeCarrier.Tau.ground, 0.9, accuracy: epsilon)        // setGround
        XCTAssertEqual(HomeCarrier.Tau.carrierFreq, 0.6, accuracy: epsilon)   // setCarrier
        XCTAssertEqual(HomeCarrier.Tau.carrierGain, 0.7, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.Tau.room, 1.4, accuracy: epsilon)          // setRoom
        XCTAssertEqual(HomeCarrier.Tau.fifthFreq, 0.8, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.Tau.fifthGain, 2.0, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.Tau.airGain, 1.5, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.Tau.airCutoff, 1.6, accuracy: epsilon)
    }

    /// Where the graph sits before anyone has entered anyone.
    func testTheGraphsOwnDefaultsAreDesigns() {
        XCTAssertEqual(HomeCarrier.initialCarrierHz, 136.1, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.initialFifthHz, 204.15, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.initialAirHz, 460, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.roomQ, 0.7, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.airQ, 0.6, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.noiseSeconds, 4, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.noiseAmplitude, 0.5, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.fifthLevel, 0.05, accuracy: epsilon)
        // The lowpass opens from exactly where `setRoom` would put it at rest.
        XCTAssertEqual(HomeCarrier.filterCutoff(adaptation: 0), 220, accuracy: epsilon)
    }

    /// Nothing to the peak over the attack, then an exponential fall to the
    /// floor, the voice released after it.
    func testStrikeEnvelopeIsDesigns() {
        XCTAssertEqual(HomeCarrier.strikePeak, 0.05, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeAttack, 0.02, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeFloor, 0.0001, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeFall, 3.4, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.strikeRelease, 3.6, accuracy: epsilon)
        // An exponential fall can never reach zero, and the voice must outlive it.
        XCTAssertGreaterThan(HomeCarrier.strikeFloor, 0)
        XCTAssertGreaterThan(HomeCarrier.strikeRelease, HomeCarrier.strikeFall)
        XCTAssertGreaterThan(HomeCarrier.strikeFall, HomeCarrier.strikeAttack)
    }

    /// Rings 4 and 5 step through four degrees; ring 8's triad collapses and
    /// reopens. Four is the slower of the two — the brief says so and Design's
    /// two intervals say so.
    func testSteppedAndTriadMovementsAreDesigns() {
        XCTAssertEqual(HomeCarrier.steps, [1, 9.0 / 8.0, 5.0 / 4.0, 3.0 / 2.0])
        XCTAssertEqual(HomeCarrier.stepPeriod(forRing: 4), 5.2, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.stepPeriod(forRing: 5), 3.4, accuracy: epsilon)
        XCTAssertGreaterThan(HomeCarrier.stepPeriod(forRing: 4),
                             HomeCarrier.stepPeriod(forRing: 5))
        XCTAssertEqual(HomeCarrier.triadPeriod, 14, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.triadGlideTau, 3.4, accuracy: epsilon)
    }

    /// The three beats of the rite, and the interval the room withholds.
    func testTheStrikeRatiosAndTheFifthAreDesigns() {
        XCTAssertEqual(HomeCarrier.strikeRatios, [1, 1.5, 2])
        XCTAssertEqual(HomeCarrier.fifthRatio, 1.5, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.soundingFloor, 0.001, accuracy: epsilon)
        // The fifth the strike sounds is the fifth the room withholds.
        XCTAssertEqual(HomeCarrier.strikeRatios[1], HomeCarrier.fifthRatio, accuracy: epsilon)
    }

    func testCentsIsWebAudiosDetune() {
        XCTAssertEqual(HomeCarrier.cents(0), 1, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.cents(1200), 2, accuracy: epsilon)
        XCTAssertEqual(HomeCarrier.cents(-1200), 0.5, accuracy: epsilon)
    }

    // MARK: - The nine grounds

    /// Design's `build()`, branch by branch. Eight of the nine are literal
    /// tables and are asserted whole; the ninth is computed and is checked on
    /// its own below.
    func testEveryGroundIsDesignsBranch() {
        XCTAssertEqual(HomeCarrier.ground(forRing: 1), HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
            HomePartialSpec(wave: .sine, multiple: 1.0035, gain: 0.8),
            HomePartialSpec(wave: .triangle, multiple: 2, gain: 0.16),
        ], band: nil), "ring 1 — the ground drone")

        XCTAssertEqual(HomeCarrier.ground(forRing: 2), HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
            HomePartialSpec(wave: .sine, multiple: 1.5, gain: 0.3),
        ], band: nil, amRate: 0.14, amDepth: 0.55), "ring 2 — the home breath")

        let breathy = HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 1, gain: 0.7),
            HomePartialSpec(wave: .saw, multiple: 1.002, gain: 0.1),
            HomePartialSpec(wave: .saw, multiple: 2.01, gain: 0.05, throughBand: true),
        ], band: HomeBandSpec(multiple: 4, q: 1.6))
        XCTAssertEqual(HomeCarrier.ground(forRing: 3), breathy, "ring 3 — the breathy voice")
        XCTAssertEqual(HomeCarrier.ground(forRing: 6), breathy, "ring 6 — the breathy voice")

        let stepped = HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 1, gain: 1),
            HomePartialSpec(wave: .sine, multiple: 0.5, gain: 0.4),
        ], band: nil)
        XCTAssertEqual(HomeCarrier.ground(forRing: 4), stepped, "ring 4 — stepped notes")
        XCTAssertEqual(HomeCarrier.ground(forRing: 5), stepped, "ring 5 — stepped notes")

        XCTAssertEqual(HomeCarrier.ground(forRing: 7), HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 2, gain: 0.42),
            HomePartialSpec(wave: .sine, multiple: 3, gain: 0.26),
            HomePartialSpec(wave: .sine, multiple: 5, gain: 0.14),
        ], band: nil), "ring 7 — the witness")

        XCTAssertEqual(HomeCarrier.ground(forRing: 8), HomeGroundSpec(partials: [
            HomePartialSpec(wave: .sine, multiple: 1, gain: 0.7),
            HomePartialSpec(wave: .sine, multiple: 1.26, gain: 0.6, glideTau: 3.4),
            HomePartialSpec(wave: .sine, multiple: 1.5, gain: 0.6, glideTau: 3.4),
        ], band: nil), "ring 8 — the triad collapse")
    }

    /// The ninth is computed rather than written out: five voices an octave
    /// apart, each detuned three cents further and drifting forty cents faster.
    func testShepardIsFiveVoicesDetunedInCents() {
        let spec = HomeCarrier.ground(forRing: 9)
        XCTAssertNil(spec.band)
        XCTAssertEqual(spec.amDepth, 0, accuracy: epsilon)
        XCTAssertEqual(spec.partials.count, 5)
        for (k, partial) in spec.partials.enumerated() {
            XCTAssertEqual(partial.wave, .sine, "voice \(k)")
            XCTAssertEqual(partial.multiple,
                           pow(2, Double(k) - 1) * pow(2, Double(k) * 3 / 1200),
                           accuracy: epsilon, "voice \(k)")
            XCTAssertEqual(partial.gain, 0.22, accuracy: epsilon, "voice \(k)")
            XCTAssertEqual(partial.lfoDepth, 0.22, accuracy: epsilon, "voice \(k)")
            XCTAssertEqual(partial.lfoRate,
                           0.021 * pow(2, Double(k) * 40 / 1200),
                           accuracy: epsilon, "voice \(k)")
        }
        // An octave below the root at the bottom, three above it at the top —
        // each nudged by its own few cents, which is the whole point of them.
        XCTAssertEqual(spec.partials[0].multiple, 0.5, accuracy: epsilon)
        XCTAssertEqual(spec.partials[4].multiple, 8 * HomeCarrier.cents(12), accuracy: epsilon)
        // The drift is a shimmer, never a transposition: the topmost voice sits
        // less than a quarter tone off its octave.
        let topDetune = Double(HomeCarrier.shepardVoices - 1) * HomeCarrier.shepardDetuneCents
        XCTAssertLessThan(topDetune, 50)
    }

    /// The order within a ground is not cosmetic. `advanceStep` moves the
    /// first partial and `advanceTriad` the second and third, exactly as
    /// Design's `st`, `t2` and `t3` do — reorder a table and the wrong voice
    /// moves, silently.
    func testTheOrderWithinAGroundIsLoadBearing() {
        for ring in [4, 5] {
            let spec = HomeCarrier.ground(forRing: ring)
            XCTAssertEqual(spec.partials.count, 2, "ring \(ring)")
            // The one that steps stands at the root; the drone beneath it stays put.
            XCTAssertEqual(spec.partials[0].multiple, 1, accuracy: epsilon, "ring \(ring)")
            XCTAssertEqual(spec.partials[1].multiple, 0.5, accuracy: epsilon, "ring \(ring)")
            // Notes that step rather than glide.
            XCTAssertEqual(spec.partials[0].glideTau, 0, accuracy: epsilon, "ring \(ring)")
        }
        let triad = HomeCarrier.ground(forRing: 8)
        XCTAssertEqual(triad.partials.count, 3)
        XCTAssertEqual(triad.partials[0].multiple, 1, accuracy: epsilon)
        XCTAssertEqual(triad.partials[1].multiple, 1.26, accuracy: epsilon)
        XCTAssertEqual(triad.partials[2].multiple, 1.5, accuracy: epsilon)
        // The two that collapse glide; the one they collapse toward does not.
        XCTAssertEqual(triad.partials[0].glideTau, 0, accuracy: epsilon)
        XCTAssertEqual(triad.partials[1].glideTau, HomeCarrier.triadGlideTau, accuracy: epsilon)
        XCTAssertEqual(triad.partials[2].glideTau, HomeCarrier.triadGlideTau, accuracy: epsilon)
    }

    /// Seven is the witness: no partial at the fundamental at all, only its
    /// overtones. It is the one ground you cannot point at.
    func testTheWitnessHasNoFundamental() {
        let spec = HomeCarrier.ground(forRing: 7)
        XCTAssertFalse(spec.partials.contains { $0.multiple == 1 })
        XCTAssertEqual(spec.partials.map(\.multiple), [2, 3, 5])
    }

    /// Three and six carry air inside the voice: a bandpassed saw two octaves
    /// up. No other ring has a band at all.
    func testOnlyTheBreathyRingsCarryABand() {
        for ring in [3, 6] {
            let spec = HomeCarrier.ground(forRing: ring)
            XCTAssertEqual(spec.band, HomeBandSpec(multiple: 4, q: 1.6), "ring \(ring)")
            XCTAssertEqual(spec.partials.filter(\.throughBand).count, 1, "ring \(ring)")
        }
        for ring in [1, 2, 4, 5, 7, 8, 9] {
            XCTAssertNil(HomeCarrier.ground(forRing: ring).band, "ring \(ring)")
            XCTAssertTrue(HomeCarrier.ground(forRing: ring).partials.allSatisfy { !$0.throughBand },
                          "ring \(ring)")
        }
    }

    /// Two is the home ring, and the home ring breathes. It is the only one.
    func testOnlyTheHomeRingBreathes() {
        let spec = HomeCarrier.ground(forRing: 2)
        XCTAssertEqual(spec.amRate, 0.14, accuracy: epsilon)
        XCTAssertEqual(spec.amDepth, 0.55, accuracy: epsilon)
        for ring in [1, 3, 4, 5, 6, 7, 8, 9] {
            XCTAssertEqual(HomeCarrier.ground(forRing: ring).amDepth, 0, accuracy: epsilon,
                           "ring \(ring)")
        }
    }

    /// Every ring has a voice, and a ring outside 1…9 clamps rather than
    /// trapping — a render path must never be handed an empty ground.
    func testEveryRingHasAVoiceAndTheEndsClamp() {
        for ring in 1...9 {
            XCTAssertFalse(HomeCarrier.ground(forRing: ring).partials.isEmpty, "ring \(ring)")
        }
        XCTAssertEqual(HomeCarrier.ground(forRing: 0), HomeCarrier.ground(forRing: 1))
        XCTAssertEqual(HomeCarrier.ground(forRing: 42), HomeCarrier.ground(forRing: 9))
    }

    /// Ours, not Design's — the lifecycle its JS never had. These are checked
    /// against each other rather than against a source, because there is no
    /// source: Design's voice cannot be paused, interrupted or torn down.
    func testTheLifecycleWeAddedHangsTogether() {
        // A render block cannot allocate, so the struck voices are a fixed pool.
        XCTAssertGreaterThan(HomeCarrier.strikeVoices, 1)
        // An interruption ducks faster than an ordinary stop: the room did not ask.
        XCTAssertLessThan(HomeCarrier.pauseTau, HomeCarrier.Tau.masterOut)
        // Each fade is given longer to land than the constant that drives it.
        XCTAssertGreaterThan(HomeCarrier.pauseDelay, HomeCarrier.pauseTau)
        XCTAssertGreaterThan(HomeCarrier.teardownDelay, HomeCarrier.Tau.masterOut)
    }

    // MARK: - Lifecycle

    /// Design's voice has no lifecycle at all. Ours does, and stopping a thing
    /// that never started — twice — must be a no-op, not a crash.
    func testStopAllIsHarmlessAndIdempotent() {
        let service = HomeSoundService.shared
        service.stopAll()
        service.stopAll()
        XCTAssertFalse(service.isSounding)
    }

    /// The gestures are guarded on a built graph, so they are inert before
    /// `start()` — a caller may set the room before there is a room.
    func testGesturesBeforeStartAreInert() {
        let service = HomeSoundService.shared
        service.setGround(index: 0, next: 1, blend: 0.5)
        service.setCarrier(ring: 2, amount: 1, syllable: "Hrīṃ")
        service.setRoom(a: 1, b: 1, ring: 9, syllable: "Sauḥ")
        service.strike(ring: 1, beat: 2, syllable: "Aṃ")
        service.quiet()
        XCTAssertFalse(service.isSounding)
    }

    /// The default is `.playback` + `.mixWithOthers`, as both existing audio
    /// services already set it — the silent switch is opt-in, not the default.
    func testSilentSwitchIsOptIn() {
        XCTAssertFalse(HomeSoundService.shared.respectsSilentSwitch)
    }
}
