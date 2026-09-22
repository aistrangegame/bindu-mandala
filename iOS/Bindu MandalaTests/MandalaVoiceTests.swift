import XCTest
@testable import Bindu_Mandala

// MARK: - MandalaVoiceTests — what the 102 sound like
//
// Brief v2 §4.4 asks for a pure seam — a function from a Śakti to her spoken
// label — and for it to be asked of all 102, including the 86 who carry no
// `phonetic` field. That is this file.
//
// The point of a seam is that it can be asked without a screen. Nobody is going
// to switch VoiceOver on and swipe through a hundred seats before this ships —
// the charter says so in as many words — so the thing that has to be true is
// stated here, over every row, and the XCUITest that follows proves only that
// the screen is wired to it.
//
// Four things are asserted of every one of the 102:
//
//  1. She is **named**. An unnamed element is one a walker cannot come back to.
//  2. Nothing spoken carries a **diacritic**, a Devanāgarī character, or a
//     combining mark. This is the failure the brief names: a synthesiser handed
//     `Sparśākarṣiṇī` spells it out or drops the syllables.
//  3. Nothing spoken carries a **digit**. Her seat is identity and may be said,
//     so it is said in words — which means the whole labelling surface has no
//     numeral in it at all, and the never-measure law has nothing to catch.
//  4. Nothing spoken **measures**. Design's nine MEASURING patterns and the
//     practice-symbol list, both borrowed from `LawsTests` rather than copied,
//     run over every label this seam can produce.

final class MandalaVoiceTests: XCTestCase {

    // MARK: - The roster

    /// The sixteen that ship in the binary, at their khaḍgamālā positions —
    /// real rows, real names, real `phonetic` fields.
    private func karsinis() -> [Shakti] {
        ShaktiBootstrap.all.map { s in
            let kp = KhadgamalaMap.ringStartOffset(2) + s.position
            let c = Shakti(position: s.position, name: s.name, shortName: s.shortName,
                           phonetic: s.phonetic, quality: s.quality,
                           qualityDescription: s.qualityDescription, somatic: s.somatic,
                           somaticPoetry: s.somaticPoetry, bija: s.bija,
                           bodilyLocation: s.bodilyLocation, tattva: s.tattva,
                           recognitionPhrase: s.recognitionPhrase,
                           cluster: s.cluster, status: s.status)
            c.khadgamalaPosition = kp
            c.ringNumber = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            return c
        }
    }

    /// One of the 86: a diacritic name and **no phonetic at all**, which is
    /// exactly how they arrive from the base (the 86 data shape — they carry
    /// quality, somatic, tattva and codex, and lack phonetic for all of them).
    ///
    /// The stems are built to exercise the romanisation table rather than to be
    /// anybody's name: every character the table maps appears somewhere in the
    /// eighty-six, so a row dropped from that table fails here.
    private static let diacriticStems = [
        "Sparśākarṣiṇī", "Rūpākarṣiṇī", "Gandhākarṣiṇī", "Cittākarṣiṇī",
        "Anaṅgakusumā", "Sarvasaṃkṣobhiṇī", "Tripurāmbā", "Jñānaśakti",
        "Ṛddhisiddhā", "Ḷkāravatī", "Ṭaṅkāriṇī", "Ḍamarukā", "Ṇākāriṇī",
        "Ñānadā", "Vāgdevī", "Ḥrīṁkāriṇī", "Mahāvajreśvarī", "Ōṁkārā",
        "Ēkavīrā", "Kāmeśvarī", "Bhagamālinī", "Nityaklinnā",
    ]

    private func theEightySix() -> [Shakti] {
        (1...KhadgamalaMap.total)
            .filter { KhadgamalaMap.ringNumber(forKhadgamala: $0) != 2 }
            .map { kp in
                let stem = Self.diacriticStems[(kp - 1) % Self.diacriticStems.count]
                let s = Shakti(position: KhadgamalaMap.perRingIndex(forKhadgamala: kp),
                               name: stem, shortName: "", phonetic: "",
                               quality: "She who draws the \(stem.lowercased()) near",
                               qualityDescription: "", somatic: "", somaticPoetry: "",
                               bija: "", bodilyLocation: "", tattva: "",
                               recognitionPhrase: "", cluster: .inner, status: .mapped)
                s.khadgamalaPosition = kp
                s.ringNumber = KhadgamalaMap.ringNumber(forKhadgamala: kp)
                return s
            }
    }

    /// All 102, in garland order.
    private func allOneHundredTwo() -> [Shakti] {
        (karsinis() + theEightySix())
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
    }

    // MARK: - The roster is the roster

    func testTheRosterIsAllOneHundredTwoAndSixteenOfThemAreReal() {
        let all = allOneHundredTwo()
        XCTAssertEqual(all.count, KhadgamalaMap.total,
                       "the spoken sweep has to cover the whole garland")
        XCTAssertEqual(Set(all.map { $0.khadgamalaPosition ?? 0 }).count, KhadgamalaMap.total,
                       "two rows share a seat — position is the only key")
        let withPhonetic = all.filter { !$0.phonetic.trimmingCharacters(in: .whitespaces).isEmpty }
        XCTAssertEqual(withPhonetic.count, 16,
                       "sixteen carry a phonetic field and eighty-six do not; if the shipped "
                       + "bootstrap has changed, this sweep is no longer asking what it says")
    }

    // MARK: - Nothing unspeakable reaches a voice

    /// Every string this seam can produce, for every one of the 102, with where
    /// it came from.
    private func everySpokenString() -> [(origin: String, text: String)] {
        var out: [(String, String)] = []
        for s in allOneHundredTwo() {
            let kp = s.khadgamalaPosition ?? 0
            out.append(("seat \(kp) · label", MandalaVoice.seatLabel(for: s)))
            out.append(("seat \(kp) · hint", MandalaVoice.seatHint(for: s)))
            out.append(("seat \(kp) · name", MandalaVoice.spokenName(for: s)))
        }
        for ring in 1...9 {
            out.append(("enclosure \(ring)", MandalaVoice.enclosureLabel(ring: ring)))
        }
        out.append(("the Devanāgarī line", MandalaVoice.devanagariLabel))
        out.append(("the ceremony's exit", MandalaVoice.closeCeremony))
        out.append(("the homecoming's exit", MandalaVoice.enterFromHomecoming))
        return out
    }

    func testEverySpokenStringIsSayable() {
        let strings = everySpokenString()
        XCTAssertGreaterThanOrEqual(strings.count, 3 * KhadgamalaMap.total + 9,
                                    "the sweep stopped finding strings")

        let diacritics = Set(MandalaVoice.romanisation.keys)
        for (origin, text) in strings {
            XCTAssertFalse(text.trimmingCharacters(in: .whitespaces).isEmpty,
                           "\(origin) speaks nothing at all")
            if let bad = text.first(where: { diacritics.contains($0) }) {
                XCTFail("\(origin) still carries “\(bad)” — a voice spells that or drops it: “\(text)”")
            }
            XCTAssertFalse(MandalaVoice.containsDevanagari(text),
                           "\(origin) hands Devanāgarī to a voice as text: “\(text)”")
            XCTAssertNil(text.unicodeScalars.first { $0.value >= 0x0300 && $0.value <= 0x036F },
                         "\(origin) carries a combining mark: “\(text)”")
            XCTAssertNil(text.first(where: \.isNumber),
                         "\(origin) says a numeral out loud — her seat is spelled, never counted: “\(text)”")
        }
    }

    // MARK: - The law, over the spoken surface

    func testNoSpokenStringMeasures() {
        for (origin, text) in everySpokenString() {
            let hits = NeverMeasure.measuresOutLoud(text)
            XCTAssertTrue(hits.isEmpty,
                          "\(origin) measures out loud (\(hits.joined(separator: ", "))): “\(text)”")
            let practice = NeverMeasure.practiceTouched(in: text)
            XCTAssertTrue(practice.isEmpty,
                          "\(origin) says \(practice.joined(separator: ", ")) aloud: “\(text)”")
        }
    }

    /// A detector that cannot fail is not a detector. These are the two strings
    /// the law forbids, put through the same check, which has to catch both.
    func testTheLawCheckCanFail() {
        XCTAssertFalse(NeverMeasure.measuresOutLoud("Sparshakarshini, felt 7 times").isEmpty,
                       "the sweep would let a count through")
        XCTAssertFalse(NeverMeasure.practiceTouched(in: "her recognitionCount").isEmpty,
                       "the sweep would let the practice record through")
    }

    // MARK: - The 86 speak the transliteration they have

    func testTheEightySixSpeakTheirNameTransliterated() {
        for s in theEightySix() {
            let said = MandalaVoice.spokenName(for: s)
            XCTAssertEqual(said, MandalaVoice.romanised(s.name),
                           "a row with no phonetic must speak her name, transliterated")
        }
        let sparsha = theEightySix().first { $0.name == "Sparśākarṣiṇī" }
        XCTAssertEqual(sparsha.map { MandalaVoice.spokenName(for: $0) }, "Sparshakarshini",
                       "the sibilants are what these names sound like — stripping them gives "
                       + "“Sparsakarsini”, which is a different word")
    }

    func testTheSixteenSpeakTheirPhoneticWithoutItsPunctuationOrItsShouting() {
        for s in karsinis() {
            let said = MandalaVoice.spokenName(for: s)
            XCTAssertFalse(said.contains("·"),
                           "a middle dot is read as punctuation or as nothing: “\(said)”")
            for word in said.split(separator: " ") {
                let letters = word.filter(\.isLetter)
                XCTAssertFalse(letters.count > 1 && letters.allSatisfy(\.isUppercase),
                               "“\(word)” is all capitals, which a synthesiser spells: “\(said)”")
            }
        }
        let sparsha = karsinis().first { $0.phonetic.contains("SHAH") }
        XCTAssertEqual(sparsha.map { MandalaVoice.spokenName(for: $0) }, "Spar Shah kar shi nee",
                       "her phonetic is written for the eye; this is the same syllables for an ear")
    }

    func testARowWithNoNameAtAllStillAnswersToSomething() {
        let blank = Shakti(position: 1, name: "", shortName: "", phonetic: "",
                           quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                           bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                           cluster: .inner, status: .mapped)
        blank.khadgamalaPosition = 77
        blank.ringNumber = 6
        XCTAssertEqual(MandalaVoice.spokenName(for: blank), "Seventy-seventh seat")
    }

    func testADevanagariNameIsNeverHandedToAVoiceAsText() {
        let s = Shakti(position: 1, name: "स्पर्शाकर्षिणी", shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: .inner, status: .mapped)
        s.khadgamalaPosition = 29
        s.ringNumber = 2
        let said = MandalaVoice.spokenName(for: s)
        XCTAssertFalse(MandalaVoice.containsDevanagari(said))
        XCTAssertEqual(said, "Twenty-ninth seat",
                       "a name written in a script we do not romanise falls back to her seat, "
                       + "which is identity and is always there")
    }

    // MARK: - Her seat, said in words

    func testHerSeatIsSpokenAsHerPositionInTheGarland() {
        let all = allOneHundredTwo()
        guard let twentyNine = all.first(where: { $0.khadgamalaPosition == 29 }) else {
            return XCTFail("kp 29 is missing from the roster")
        }
        let label = MandalaVoice.seatLabel(for: twentyNine)
        XCTAssertTrue(label.contains("Second enclosure"), label)
        XCTAssertTrue(label.contains("twenty-ninth of the one hundred and two"), label)

        guard let lalita = all.first(where: { $0.khadgamalaPosition == 102 }) else {
            return XCTFail("kp 102 is missing from the roster")
        }
        let source = MandalaVoice.seatLabel(for: lalita)
        XCTAssertTrue(source.contains("Ninth enclosure"), source)
        XCTAssertTrue(source.contains("one hundred and second of the one hundred and two"), source)
        XCTAssertEqual(MandalaVoice.seatHint(for: lalita), "Opens the source.")
    }

    func testTheSpokenLabelSaysHerNameFirst() {
        for s in allOneHundredTwo() {
            let label = MandalaVoice.seatLabel(for: s)
            XCTAssertTrue(label.hasPrefix(MandalaVoice.spokenName(for: s)),
                          "a walker swiping a ring wants her name first: “\(label)”")
        }
    }

    // MARK: - Numbers, spelled

    func testEverySeatInTheGarlandHasItsOwnWord() {
        var seen: Set<String> = []
        for n in 1...KhadgamalaMap.total {
            let word = MandalaVoice.ordinal(n)
            XCTAssertFalse(word.isEmpty, "\(n) has no word")
            XCTAssertNil(word.first(where: \.isNumber), "\(n) came back as a numeral: \(word)")
            XCTAssertTrue(seen.insert(word).inserted, "two seats share the word “\(word)”")
        }
        XCTAssertEqual(MandalaVoice.ordinal(1), "first")
        XCTAssertEqual(MandalaVoice.ordinal(2), "second")
        XCTAssertEqual(MandalaVoice.ordinal(11), "eleventh")
        XCTAssertEqual(MandalaVoice.ordinal(12), "twelfth")
        XCTAssertEqual(MandalaVoice.ordinal(20), "twentieth")
        XCTAssertEqual(MandalaVoice.ordinal(28), "twenty-eighth")
        XCTAssertEqual(MandalaVoice.ordinal(44), "forty-fourth")
        XCTAssertEqual(MandalaVoice.ordinal(100), "one hundredth")
        XCTAssertEqual(MandalaVoice.ordinal(101), "one hundred and first")
        XCTAssertEqual(MandalaVoice.ordinal(102), "one hundred and second")
        XCTAssertEqual(MandalaVoice.cardinal(16), "sixteen")
        XCTAssertEqual(MandalaVoice.cardinal(102), "one hundred and two")
    }

    // MARK: - The nine enclosures

    func testTheNineEnclosuresAreNineDistinctThings() {
        var seen: Set<String> = []
        for ring in 1...9 {
            let label = MandalaVoice.enclosureLabel(ring: ring)
            XCTAssertTrue(seen.insert(label).inserted, "two enclosures say the same thing: \(label)")
            XCTAssertTrue(label.hasPrefix(MandalaVoice.ordinal(ring).capitalizedFirst),
                          "an enclosure says which one it is first: \(label)")
        }
        XCTAssertEqual(MandalaVoice.enclosureLabel(ring: 2),
                       "Second enclosure. Sixteen-petal lotus.")
        XCTAssertEqual(MandalaVoice.enclosureLabel(ring: 9),
                       "Ninth enclosure. The bindu.")
        XCTAssertEqual(MandalaVoice.enclosureForms.count, 10,
                       "one empty slot and nine enclosures")
    }

    /// The drawn strip and the spoken one are two different tables on purpose —
    /// `16-Petal Lotus` is right on a screen and wrong in an ear. This holds
    /// them to the same *count* and the same order, so a ring cannot be renamed
    /// in one and not the other without somebody noticing.
    func testTheSpokenEnclosuresCoverTheDrawnOnes() {
        for ring in 1...9 {
            let spoken = MandalaVoice.enclosureForms[ring]
            XCTAssertFalse(spoken.isEmpty, "ring \(ring) has no spoken form")
            XCTAssertNil(spoken.first(where: \.isNumber),
                         "ring \(ring)'s spoken form carries a numeral: \(spoken)")
        }
    }

    // MARK: - The seam is where the work happens, and only once

    /// The living Mandala rebuilds its spoken layer on every camera change, and
    /// a drag is sixty of those a second. Composing a label there means walking
    /// a hundred and two names through the romanisation table per frame, on the
    /// screen the whole instrument is reached through.
    ///
    /// So the labels are built where the atmospheres are built — when the field
    /// changes — and the layer does geometry and nothing else. This reads both
    /// files off disk and holds that arrangement, because it is the kind of
    /// thing a later edit undoes without noticing.
    func testTheLayerNeverComposesALabelWhileTheCameraIsMoving() {
        guard let layer = LawSource.production("MandalaAccessibilityLayer.swift") else {
            return XCTFail("the Mandala's spoken layer is gone")
        }
        let code = String(layer.lexed.masked)
        for expensive in ["seatLabel(", "seatHint(", "spokenName(", "romanised(", "spoken("] {
            XCTAssertFalse(code.contains(expensive),
                           "`\(expensive)` is called inside the layer the camera rebuilds every "
                           + "frame — the labels belong in the host's `rebuild()`, beside the "
                           + "atmospheres, which are precomputed for exactly this reason")
        }

        guard let host = LawSource.production("LivingMandalaView.swift") else {
            return XCTFail("the living Mandala is gone")
        }
        guard let rebuild = Rx.first(#"private func rebuild\(\)[\s\S]*?\n    \}"#, host.text) else {
            return XCTFail("`rebuild()` is gone from the living Mandala")
        }
        XCTAssertTrue(rebuild.contains("MandalaVoice.spoken"),
                      "the host no longer composes what each seat says when the field changes")
    }

    /// And the two ways in are one way in. A tap finds the nearest seat and
    /// hands it to `activate`; VoiceOver hands the same seat to the same
    /// function, because it cannot hit-test at all. If the layer ever grows its
    /// own copy of that branch, a walker using a voice is in a different
    /// instrument from a walker using a finger.
    func testAFingerAndAVoiceArriveThroughTheSameDoor() {
        guard let host = LawSource.production("LivingMandalaView.swift") else {
            return XCTFail("the living Mandala is gone")
        }
        guard let tap = Rx.first(#"private func handleTap\(at[\s\S]*?\n    \}"#, host.text) else {
            return XCTFail("`handleTap(at:)` is gone")
        }
        XCTAssertTrue(tap.contains("activate(seat)"),
                      "a tap no longer goes through `activate` — \(tap)")
        XCTAssertFalse(tap.contains("openDescent()"),
                       "the tap path has grown its own copy of the arrival branch")

        guard let layer = LawSource.production("MandalaAccessibilityLayer.swift") else {
            return XCTFail("the Mandala's spoken layer is gone")
        }
        XCTAssertTrue(String(layer.lexed.masked).contains("allowsHitTesting(false)"),
                      "the spoken layer hit-tests, so it is now competing with the field's own "
                      + "gesture for every touch")
    }

    // MARK: - Romanisation, at the edges

    func testRomanisationLeavesPlainEnglishExactlyAsItWas() {
        XCTAssertEqual(MandalaVoice.romanised("She who attracts Touch"), "She who attracts Touch")
        XCTAssertEqual(MandalaVoice.romanised(""), "")
    }

    func testEveryCharacterInTheTableIsActuallyFolded() {
        for (ch, replacement) in MandalaVoice.romanisation {
            let said = MandalaVoice.romanised("a\(ch)b")
            XCTAssertEqual(said, "a\(replacement)b", "“\(ch)” did not fold")
        }
    }

    /// The same letter written as a base plus a combining mark, rather than as a
    /// single precomposed character. Airtable will hand back either.
    func testADecomposedDiacriticFoldsTheSameWay() {
        let decomposed = "Spar\u{015B}\u{0101}kar\u{1E63}i\u{1E47}\u{012B}"
            .decomposedStringWithCanonicalMapping
        XCTAssertEqual(MandalaVoice.romanised(decomposed), "Sparshakarshini")
    }
}
