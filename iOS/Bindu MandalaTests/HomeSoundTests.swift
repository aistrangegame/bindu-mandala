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
