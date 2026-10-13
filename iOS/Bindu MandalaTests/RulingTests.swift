import XCTest
@testable import Bindu_Mandala

// MARK: - V34 · his rulings, each pinned by a test (U0)
//
// `waves/upgrade/worlds/verification.md` V34. Each ruling of 12 Oct 2026 that
// can be held in data or source is held here, in one place, so a wave that
// breaks one fails here by name:
//
//   · ruling 2  — chakra 32 (the Ego Reveal) is sealed: its words are not in
//                 the bake, and no view model or spoken label carries them;
//   · ruling 3  — Axis is chakra 18, Crow is chakra 19;
//   · ruling 4  — Ahaṅ fire (kp 31), Nāma air (40), Ātma light (42), Amṛta
//                 water (43), through Element and Recognition's nature;
//   · ruling 8  — Maya's last line is "…There was only You, playing." in both bakes;
//   · ruling 15 — "her siddhi is still on the instrument" is nowhere in the app;
//   · floors    — the two Recognition lines verbatim; no generated voice (no
//                 text-to-speech API anywhere in the shipping source).
//
// Leela's constants (≥ 3 days, then 30 %) are pinned in `GameStructureTests`,
// the deep zoom (descentTarget 5.4) in `MandalaCameraTests`, Rām japa at kp 42
// in `CoherenceTests`.
//
// Every check here was shown able to fail on a planted defect (see
// `waves/upgrade/briefs/U0-C-report.md`); the synthetic-bake checks below keep
// that proof in the suite.

final class RulingTests: XCTestCase {

    // MARK: Fixtures

    private static func bakeURL(_ name: String) -> URL {
        SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Data/\(name).json")
    }

    private static func json(_ name: String) throws -> [String: Any] {
        let data = try Data(contentsOf: bakeURL(name))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any],
                             "\(name).json is not a JSON object")
    }

    private static func chakras() throws -> [[String: Any]] {
        try XCTUnwrap(json("ChakraConstellation")["chakras"] as? [[String: Any]],
                      "ChakraConstellation.json has no chakras")
    }

    private static func room(_ road: Int) throws -> [String: Any] {
        try XCTUnwrap(chakras().first { ($0["road"] as? Int) == road }, "road \(road) is not in the bake")
    }

    /// Room 32's public identity — the only keys its bake may carry (Part B, ruling 2).
    static let sealedIdentityKeys: Set<String> = [
        "road", "recordId", "name", "subtitle", "verb", "colorHex", "primaryColor",
        "shaktiName", "mudra", "kind", "avarana", "kp", "address", "crossing", "sealed",
    ]

    // MARK: Ruling 2 · chakra 32 sealed

    func testRoom32CarriesOnlyItsPublicIdentityInTheBake() throws {
        let sealed = try Self.room(ChakraConstellation.sealedRoad)
        XCTAssertEqual(sealed["sealed"] as? Bool, true, "room 32 is not marked sealed")
        let extra = Set(sealed.keys).subtracting(Self.sealedIdentityKeys)
        XCTAssertTrue(extra.isEmpty, "room 32's bake carries more than its identity: \(extra.sorted())")
        // Its identity is still there — sealed, not erased.
        XCTAssertEqual(sealed["name"] as? String, "Ego Reveal")
        // And no other room is sealed.
        for c in try Self.chakras() where (c["road"] as? Int) != ChakraConstellation.sealedRoad {
            XCTAssertNotEqual(c["sealed"] as? Bool, true, "road \(c["road"] ?? "?") is sealed too")
        }
    }

    func testNoViewModelOrSpokenLabelCarriesRoom32sWords() throws {
        let data = try Data(contentsOf: Self.bakeURL("ChakraConstellation"))
        let all = ChakraConstellation.decode(data)
        let c = try XCTUnwrap(all.first { $0.road == ChakraConstellation.sealedRoad })
        XCTAssertTrue(c.isSealed)
        for (what, value) in [("coreQuestion", c.coreQuestion), ("signaturePhrase", c.signaturePhrase),
                              ("practicePrompt", c.practicePrompt), ("threeWaysIn", c.threeWaysIn),
                              ("gateText", c.gateText), ("storyThread", c.storyThread),
                              ("leelaStory", c.leelaStory), ("act1Voice", c.act1Voice),
                              ("act2Voice", c.act2Voice), ("binduReflection", c.binduReflection),
                              ("witnessPerspective", c.witnessPerspective), ("voice", c.voice),
                              ("writingPrompt", c.writingPrompt), ("teachingText", c.teachingText),
                              ("panelSeedMessage", c.panelSeedMessage), ("gaiaVoice", c.gaiaVoice)] {
            XCTAssertNil(value, "room 32's \(what) reached its view model")
        }
        XCTAssertNil(ChakraTeaching.gate(c.gateText))
        XCTAssertNil(ChakraTeaching.threeWays(c.threeWaysIn))
        XCTAssertTrue(ChakraTeaching.tatTvamAsi(c).isEmpty)

        // What a voice hears of it: its name, subtitle, place — and that it is held.
        let spoken = ChakraConstellation.spokenLabel(c, seatName: nil)
        XCTAssertTrue(spoken.hasPrefix(c.name))
        XCTAssertTrue(spoken.hasSuffix(ChakraConstellation.sealedLine), spoken)
        XCTAssertEqual(ChakraConstellation.sealedLine, "held for its own walk")
    }

    /// The seal holds at the one door every surface reads through, even for a
    /// bake that still carried the words (a planted defect, kept in the suite).
    func testTheSealHoldsEvenIfABakeCarriedTheWords() throws {
        let planted = """
        {"chakras": [{"road": 32, "recordId": "recPLANTEDxxxxxxx", "name": "Ego Reveal",
          "kind": "mind", "kp": [101], "address": "seat",
          "coreQuestion": "PLANTED", "gateText": "PLANTED", "gaiaVoice": "PLANTED"}]}
        """
        let c = try XCTUnwrap(ChakraConstellation.decode(Data(planted.utf8)).first)
        XCTAssertTrue(c.isSealed, "road 32 is not sealed by position")
        XCTAssertNil(c.coreQuestion, "a bake that carried room 32's words would show them")
        XCTAssertNil(c.gateText)
        XCTAssertNil(c.gaiaVoice)
    }

    // MARK: Ruling 3 · Axis 18, Crow 19

    func testAxisIsEighteenAndCrowIsNineteen() throws {
        XCTAssertEqual(try Self.room(18)["name"] as? String, "Axis")
        XCTAssertEqual(try Self.room(19)["name"] as? String, "Crow")
    }

    // MARK: Ruling 4 · the elements, through Recognition

    func testRulingFourReachesRecognitionsNature() {
        func her(_ kp: Int) -> Shakti {
            let s = Shakti(position: kp - 28, name: "x", shortName: "", phonetic: "",
                           quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                           bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                           cluster: .inner, status: .mapped)
            s.ringNumber = 2
            s.khadgamalaPosition = kp
            return s
        }
        XCTAssertEqual(RecognitionNature.of(her(31).element), .flare, "Ahaṅ is fire — it flares")
        XCTAssertEqual(RecognitionNature.of(her(40).element), .disperse, "Nāma is air — it disperses")
        XCTAssertEqual(RecognitionNature.of(her(42).element), .radiate, "Ātma is light — it radiates")
        XCTAssertEqual(RecognitionNature.of(her(43).element), .pool, "Amṛta is water — it pools")
    }

    // MARK: Ruling 8 · Maya's last line, in both bakes

    static let mayasLine = "There was only You, playing."

    func testMayasLineIsOnlyYouPlayingInBothBakes() throws {
        let maya = try Self.room(30)
        XCTAssertEqual(maya["name"] as? String, "Maya")
        for field in ["signaturePhrase", "panelSeedMessage"] {
            let line = try XCTUnwrap(maya[field] as? String, "Maya's \(field) is not in the bake")
            XCTAssertTrue(line.hasSuffix(Self.mayasLine), "Maya's \(field) ends otherwise: \(line)")
        }
        let panels = try XCTUnwrap(Self.json("GameStructure")["panels"] as? [[String: Any]])
        let nine = try XCTUnwrap(panels.first { ($0["ring"] as? Int) == 9 }, "panel 9 is not baked")
        let seed = try XCTUnwrap(nine["seed"] as? String)
        XCTAssertTrue(seed.hasSuffix(Self.mayasLine), "the ninth seed ends otherwise: \(seed)")
        // The bundled decoder reads the same line.
        XCTAssertTrue(GameStructure.file.panels.first { $0.ring == 9 }?.seed.hasSuffix(Self.mayasLine) ?? false)
    }

    // MARK: Ruling 15 · the after-effect is felt, never named

    static let siddhiLine = "her siddhi is still on the instrument"

    func testTheNamedAfterEffectIsNowhereInTheApp() throws {
        XCTAssertGreaterThanOrEqual(LawSource.production.count, 60, "the shipping source was not read")
        for f in LawSource.production {
            for lit in f.literals {
                XCTAssertFalse(lit.text.lowercased().contains(Self.siddhiLine),
                               "\(f.path) still says \"\(Self.siddhiLine)\"")
            }
        }
        for bake in ["ChakraConstellation", "GameStructure"] {
            let text = try String(contentsOf: Self.bakeURL(bake), encoding: .utf8)
            XCTAssertFalse(text.lowercased().contains(Self.siddhiLine), "\(bake).json names the after-effect")
        }
        // The detector can fail.
        let planted = synthetic(#"let line = "her siddhi is still on the instrument""#)
        XCTAssertTrue(planted.literals.contains { $0.text.lowercased().contains(Self.siddhiLine) })
    }

    // MARK: Floors · the two Recognition lines, verbatim

    func testTheTwoRecognitionLinesAreVerbatimInTheCeremony() throws {
        XCTAssertEqual(RecognitionLines.feltHere, "she was felt here")
        XCTAssertEqual(RecognitionLines.feltBack, "and she felt you back")
        let ceremony = try XCTUnwrap(LawSource.production("RecognitionMomentView.swift"))
        let texts = ceremony.literals.map(\.text)
        for line in RecognitionLines.both {
            XCTAssertTrue(texts.contains { $0.contains(line) }, "the ceremony no longer says \"\(line)\"")
        }
    }

    // MARK: Floors · no generated voice

    static let speechAPIs = [#"\bAVSpeechSynthesizer\b"#, #"\bAVSpeechUtterance\b"#,
                             #"\bAVSpeechSynthesisVoice\b"#, #"\bNSSpeechSynthesizer\b"#,
                             #"\bAVSpeechSynthesisProviderAudioUnit\b"#]

    func testNoTextToSpeechAnywhereInTheShippingSource() {
        var read = 0
        for f in LawSource.production {
            read += 1
            let code = String(f.lexed.masked)
            for api in Self.speechAPIs where Rx.matches(api, code) {
                XCTFail("\(f.path) uses \(api) — no generated voice")
            }
        }
        XCTAssertGreaterThanOrEqual(read, 60)
        // The scan can fail.
        let planted = synthetic("let s = AVSpeechSynthesizer(); s.speak(AVSpeechUtterance(string: x))")
        XCTAssertTrue(Self.speechAPIs.contains { Rx.matches($0, String(planted.lexed.masked)) })
    }

    // MARK: -

    private func synthetic(_ text: String) -> SourceFile {
        SourceFile(path: "Synthetic.swift", name: "Synthetic.swift", text: text, lexed: SwiftLexer.lex(text))
    }
}
