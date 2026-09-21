import XCTest
@testable import Bindu_Mandala

/// HER ATTRIBUTE — the checks that used to be a pair of eyes.
///
/// `HomeAttribute.swift` is the pure half of Design's `homes-attribute.js`:
/// which shape acts in each of the 102 rooms, what tints it, where it is
/// mounted, and the parameter curves that make it act rather than sit. There is
/// no renderer to look at, so everything Ashrey would have checked by looking
/// is asked here instead — including the aniconic law, which this layer is the
/// most exposed part of the whole build.
final class HomeAttributeTests: XCTestCase {

    // Design's own twenty-six keys, from `homes-attribute.js`'s `FORMS`.
    private let designKeys: Set<String> = [
        "noose", "goad", "cup", "arrows", "bow", "mirror", "lotus", "flame",
        "rosary", "trident", "vajra", "skullcup", "plough", "sceptre", "garland",
        "seed", "gem", "grain", "lamp", "chain", "herb", "ground", "radiance",
        "seal", "palm", "line",
    ]

    // MARK: - The twenty-six

    func testThereAreExactlyTwentySixForms() {
        XCTAssertEqual(HomeAttributeForm.allCases.count, 26)
        XCTAssertEqual(Set(HomeAttributeForm.allCases.map(\.designKey)), designKeys)
        // no two forms share Design's key
        XCTAssertEqual(HomeAttributeForm.byDesignKey.count, 26)
    }

    func testEveryFormActsAndIsDescribed() {
        for form in HomeAttributeForm.allCases {
            XCTAssertFalse(form.shape.isEmpty, "\(form) draws nothing")
            XCTAssertFalse(form.action.isEmpty, "\(form) does nothing")
            XCTAssertFalse(form.movingParts.isEmpty, "\(form) has no moving part")
            XCTAssertGreaterThan(form.period, 0, "\(form) has no cycle")
        }
    }

    // MARK: - All 102, by position and by nothing else

    func testEveryPositionResolvesToAFormAndNoneFallsToADefault() {
        XCTAssertEqual(HomeAttribute.attributeKeys.count, 102)
        for position in 1...102 {
            guard let key = HomeAttribute.designKey(atPosition: position) else {
                return XCTFail("position \(position) has no attribute")
            }
            // Design falls back to `seal` for an unknown word. Nothing may
            // arrive there: every key is a form's own, or a named kinship.
            XCTAssertTrue(HomeAttributeForm.byDesignKey[key] != nil
                          || HomeAttribute.kin[key] != nil,
                          "position \(position) would fall to a bare default (\(key))")
            XCTAssertNotNil(HomeAttribute.form(atPosition: position),
                            "position \(position) resolves to no form")
        }
    }

    func testPositionsOutsideTheKhadgamalaHaveNoRoom() {
        XCTAssertNil(HomeAttribute.form(atPosition: 0))
        XCTAssertNil(HomeAttribute.form(atPosition: 103))
        XCTAssertNil(HomeAttribute.form(atPosition: -1))
    }

    func testEveryFormIsReachedByAtLeastOnePosition() {
        let reached = Set((1...102).compactMap { HomeAttribute.form(atPosition: $0) })
        XCTAssertEqual(reached.count, 26, "a form nobody holds is a form nobody needs")
    }

    func testTheKinMapIsTwentySevenAliasesOntoTheTwentySix() {
        XCTAssertEqual(HomeAttribute.kin.count, 27)
        for (alias, target) in HomeAttribute.kin {
            XCTAssertNotNil(HomeAttributeForm.byDesignKey[target],
                            "\(alias) leads to \(target), which is no form")
        }
        // the aniconic redirections, spot-checked: a card that names a figure
        // is answered by a shape
        XCTAssertEqual(HomeAttribute.resolve(designKey: "hand"), .linedDisc)
        XCTAssertEqual(HomeAttribute.resolve(designKey: "ear"), .linedDisc)
        XCTAssertEqual(HomeAttribute.resolve(designKey: "gaze"), .radiance)
        XCTAssertEqual(HomeAttribute.resolve(designKey: "spine"), .sceptre)
        // and a few of Design's other kinships
        XCTAssertEqual(HomeAttribute.resolve(designKey: "spear"), .trident)
        XCTAssertEqual(HomeAttribute.resolve(designKey: "brush"), .line)
        XCTAssertEqual(HomeAttribute.resolve(designKey: "shield"), .ground)
        XCTAssertNil(HomeAttribute.resolve(designKey: "nothing-she-carries"))
    }

    func testTheAssignmentIsDesignsOwn() {
        // the corners of the table, and the two rings the Gate opens on
        XCTAssertEqual(HomeAttribute.form(atPosition: 1), .noose)
        XCTAssertEqual(HomeAttribute.form(atPosition: 29), .noose)
        XCTAssertEqual(HomeAttribute.form(atPosition: 34), .mirror)
        XCTAssertEqual(HomeAttribute.form(atPosition: 44), .linedDisc)
        XCTAssertEqual(HomeAttribute.form(atPosition: 49), .line)
        XCTAssertEqual(HomeAttribute.form(atPosition: 63), .gem)
        XCTAssertEqual(HomeAttribute.form(atPosition: 94), .shell)
        XCTAssertEqual(HomeAttribute.form(atPosition: 102), .arrows)
    }

    // MARK: - The tints

    func testTheFifteenTintOverrides() {
        XCTAssertEqual(HomeAttribute.tints.count, 15)
        let expected: [Int: UInt32] = [
            1: 0xf2ecd8, 4: 0xb8263c, 7: 0xff7a3c, 13: 0xffb45c, 15: 0x6a5f78,
            17: 0xd8d2c4, 18: 0xffd76a, 29: 0xff6a7c, 45: 0xffb0c4, 62: 0xff8ab0,
            91: 0xff7a5c, 92: 0xffd76a, 99: 0xfff6e2, 100: 0xff4a5c, 101: 0xffd76a,
        ]
        for (position, hex) in expected {
            XCTAssertEqual(HomeAttribute.tint(atPosition: position), AttributeTint(hex),
                           "position \(position) lost its colour word")
        }
        // every other room takes its own light, untinted
        for position in 1...102 where expected[position] == nil {
            XCTAssertNil(HomeAttribute.tint(atPosition: position),
                         "position \(position) was tinted by nobody's card")
        }
        let red = AttributeTint(0xb8263c)
        XCTAssertEqual(red.red, 184.0 / 255, accuracy: 1e-12)
        XCTAssertEqual(red.green, 38.0 / 255, accuracy: 1e-12)
        XCTAssertEqual(red.blue, 60.0 / 255, accuracy: 1e-12)
    }

    // MARK: - The action

    private let sampleTimes: [Double] = [0, 3.1, 17.9, 61.3, 128.7, 226.5, 301.4]

    func testActIsPure() {
        for form in HomeAttributeForm.allCases {
            let first = sampleTimes.map { form.act(at: $0) }
            // the same instants again, asked in the opposite order: nothing a
            // call leaves behind may change what the next one answers
            let again = sampleTimes.reversed().map { form.act(at: $0) }.reversed()
            XCTAssertEqual(first, Array(again), "\(form) remembers being asked")
        }
    }

    func testEveryFormCarriesEveryMovingPartAtEveryInstant() {
        for form in HomeAttributeForm.allCases {
            for t in sampleTimes {
                XCTAssertEqual(form.act(at: t).parts.count, form.movingParts.count,
                               "\(form) at \(t) lost a part")
            }
        }
    }

    func testEveryFormRepeatsAtItsOwnPeriod() {
        for form in HomeAttributeForm.allCases {
            for t in sampleTimes {
                let here = form.act(at: t)
                let later = form.act(at: t + form.period)
                assertSameMotion(here.body, later.body, form: form, part: "body", t: t)
                XCTAssertEqual(here.parts.count, later.parts.count)
                for (index, pair) in zip(here.parts, later.parts).enumerated() {
                    assertSameMotion(pair.0, pair.1, form: form,
                                     part: form.movingParts[index], t: t)
                }
            }
        }
    }

    func testEveryFormActuallyActs() {
        // a form that reads the same at every instant is an object sitting
        // there, which is the one thing Design's brief forbids
        for form in HomeAttributeForm.allCases {
            let steps = stride(from: 0.0, to: form.period, by: form.period / 37)
            let frames = Set(steps.map { String(describing: form.act(at: $0)) })
            XCTAssertGreaterThan(frames.count, 1, "\(form) only sits there")
        }
    }

    func testTheActionStaysWithinTheRoom() {
        // nothing runs away: every channel stays finite and in a sane band over
        // a long sweep, so no room can be blown out by its own attribute
        for form in HomeAttributeForm.allCases {
            for step in 0..<400 {
                let frame = form.act(at: Double(step) * 1.37)
                for motion in [frame.body] + frame.parts {
                    for value in [motion.x, motion.y, motion.z,
                                  motion.scaleX, motion.scaleY, motion.scaleZ,
                                  motion.opacity, motion.intensity] {
                        XCTAssertTrue(value.isFinite, "\(form) went off the scale")
                        XCTAssertLessThanOrEqual(abs(value), 16, "\(form) went off the scale")
                    }
                    XCTAssertGreaterThanOrEqual(motion.opacity, 0, "\(form) went negative")
                }
            }
        }
    }

    // MARK: - The mount

    func testTheMountBeforeTheSecondAdaptation() {
        // her own altitude, a little in front of her seat, at rest
        let mount = HomeAttribute.mount(bodyAltitude: 0.46,
                                        chamberTime: HomeMemory.firstAdaptation)
        XCTAssertEqual(mount.y, (0.5 - 0.46) * 6.4 - 0.4, accuracy: 1e-12)
        XCTAssertEqual(mount.z, -4.6, accuracy: 1e-12)
        XCTAssertEqual(mount.scale, 0.9, accuracy: 1e-12)
        XCTAssertEqual(mount.opacityFactor, 1, accuracy: 1e-12)

        // the second adaptation's own mark is still the resting mount: the
        // growth begins there, it does not jump there
        let atHoldEnd = HomeAttribute.mount(bodyAltitude: 0.46,
                                            chamberTime: HomeMemory.holdEnd)
        XCTAssertEqual(atHoldEnd.scale, 0.9, accuracy: 1e-12)
        XCTAssertEqual(atHoldEnd.z, -4.6, accuracy: 1e-12)
    }

    func testTheMountAtFullDepth() {
        let mount = HomeAttribute.mount(bodyAltitude: 0.46,
                                        chamberTime: HomeMemory.secondAdaptationEnd)
        // it has grown into the room and stopped being an object
        XCTAssertEqual(mount.scale, 3.5, accuracy: 1e-12)
        XCTAssertEqual(mount.z, -1.2, accuracy: 1e-12)
        XCTAssertEqual(mount.opacityFactor, 0.45, accuracy: 1e-12)
        XCTAssertEqual(mount.fading(0.6), 0.27, accuracy: 1e-12)
        XCTAssertEqual(mount.fading(1), 0.45, accuracy: 1e-12)

        // past the end it holds there, and never inverts
        let beyond = HomeAttribute.mount(bodyAltitude: 0.46, chamberTime: 4000)
        XCTAssertEqual(beyond.scale, 3.5, accuracy: 1e-12)
        XCTAssertEqual(beyond.z, -1.2, accuracy: 1e-12)
    }

    func testTheMountHalfwayThroughTheSecondAdaptation() {
        let half = (HomeMemory.holdEnd + HomeMemory.secondAdaptationEnd) / 2
        let mount = HomeAttribute.mount(bodyAltitude: 0.94, chamberTime: half)
        XCTAssertEqual(HomeAttribute.deep(atChamberTime: half), 0.5, accuracy: 1e-12)
        XCTAssertEqual(mount.scale, 0.9 + 1.3, accuracy: 1e-12)
        XCTAssertEqual(mount.z, -4.6 + 1.7, accuracy: 1e-12)
        XCTAssertEqual(mount.opacityFactor, 1 - 0.275, accuracy: 1e-12)
        // the soles sit low, and the altitude never moves with the clock
        XCTAssertEqual(mount.y, (0.5 - 0.94) * 6.4 - 0.4, accuracy: 1e-12)
    }

    func testAltitudeIsReadFromHerBodyLocation() {
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Soles of the feet"), 0.94)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Waist / encircling field"), 0.68)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Throat"), 0.34)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Heart / olfactory threshold"), 0.46)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Crown"), 0.1)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Between the eyes"), 0.26)

        // Design's band order is load-bearing, and these two cards prove it: a
        // card that names two places is read at the first band it meets, so
        // "Throat / sternum" and "Heart hook / between the eyes" both sit at
        // the chest rather than at the throat or the brow. Her attribute is
        // mounted where the room already puts her, and the order is the room's.
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Throat / sternum"), 0.46)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Heart hook / between the eyes"), 0.46)
        // the eye band is still read before the brow band, as Design has it
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "Eyes / spine inclining"), 0.26)
        // a blank is guarded, not assumed
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: ""), 0.5)
        XCTAssertEqual(HomeAttribute.bodyAltitude(forBodilyLocation: "somewhere unwritten"), 0.5)
    }

    // MARK: - The actor

    func testTheActorIsKeyedByPositionAndNeverByName() {
        // two rows carrying the same name at different positions — the Ring 7
        // Vāsinī and the Ring 8 Icchā-śakti both answer to Kāmeśvarī — must
        // reach different rooms
        let seven = shakti(named: "Kāmeśvarī", position: 89, location: "Throat")
        let eight = shakti(named: "Kāmeśvarī", position: 99, location: "Crown")
        XCTAssertEqual(HomeAttribute.actor(for: seven)?.form, .cup)
        XCTAssertEqual(HomeAttribute.actor(for: eight)?.form, .radiance)
        XCTAssertEqual(HomeAttribute.actor(for: eight)?.tint, AttributeTint(0xfff6e2))
        XCTAssertNil(HomeAttribute.actor(for: seven)?.tint)
        XCTAssertEqual(HomeAttribute.actor(for: eight)?.bodyAltitude, 0.1)

        // a row that has not been given a position has no room, and no actor
        let unplaced = shakti(named: "Kāmeśvarī", position: nil, location: "Crown")
        XCTAssertNil(HomeAttribute.actor(for: unplaced))
    }

    func testTheActorCarriesBothTheFrameAndTheMount() {
        guard let actor = HomeAttribute.actor(atPosition: 95, bodilyLocation: "Heart") else {
            return XCTFail("position 95 has no actor")
        }
        XCTAssertEqual(actor.form, .arrows)
        XCTAssertEqual(actor.designKey, "arrows")
        XCTAssertEqual(actor.restingMount.scale, 0.9, accuracy: 1e-12)

        let state = actor.state(atChamberTime: HomeMemory.secondAdaptationEnd)
        XCTAssertEqual(state.parts.count, 5)
        XCTAssertEqual(state.mount.scale, 3.5, accuracy: 1e-12)
        XCTAssertEqual(state.body, actor.form.act(at: HomeMemory.secondAdaptationEnd).body)
    }

    // MARK: - Aniconic

    /// **The law this layer is most exposed to.** No form may be a figure, and
    /// no form may be *read* as one either — so the check runs over everything
    /// that says what is drawn: the form's own identity, the shape, the action,
    /// and every moving part it names.
    ///
    /// Design's card words are deliberately **not** checked here. `hand`, `ear`,
    /// `gaze` and `spine` are what her card says, and `HomeAttribute.kin` exists
    /// precisely to answer them with a shape; testing the words away would be
    /// testing the mechanism away. What must never be figural is what the
    /// renderer is told to draw, which is everything below.
    func testNoFormCarriesFiguralVocabulary() {
        let figural: Set<String> = [
            "hand", "palm", "finger", "digit", "thumb", "fist", "wrist", "arm",
            "elbow", "shoulder", "head", "face", "eye", "ear", "nose", "mouth",
            "lip", "tongue", "brow", "throat", "neck", "chest", "breast",
            "heart", "belly", "navel", "womb", "hip", "thigh", "knee", "leg",
            "foot", "feet", "toe", "skull", "bone", "skin", "hair", "torso",
            "body", "limb", "figure", "portrait", "statue", "idol", "goddess",
            "deity", "woman", "female", "posture", "gesture",
        ]
        for form in HomeAttributeForm.allCases {
            let said = [form.rawValue, form.shape, form.action] + form.movingParts
            for phrase in said {
                for word in Self.words(in: phrase) {
                    XCTAssertFalse(figural.contains(word),
                                   "\(form) is drawn as a figure: \"\(word)\" in \"\(phrase)\"")
                }
            }
        }
    }

    /// The three forms Design named with a body word, and what they are here.
    ///
    /// All three were already abstract in Design's drawing — five capsules, a
    /// disc with three lines, a hemispherical shell. The rename only stops a
    /// later reader of this file from restoring a figure the drawing never had.
    /// The more restrained abstraction was chosen in each case, and Design's
    /// key is kept so the port stays traceable.
    func testTheThreeBodyWordsWereRenamedToTheirShapes() {
        XCTAssertEqual(HomeAttributeForm.foldingCapsules.designKey, "seal")
        XCTAssertEqual(HomeAttributeForm.linedDisc.designKey, "palm")
        XCTAssertEqual(HomeAttributeForm.shell.designKey, "skullcup")

        let renamed: Set<HomeAttributeForm> = [.foldingCapsules, .linedDisc, .shell]
        for form in HomeAttributeForm.allCases {
            if renamed.contains(form) {
                XCTAssertNotEqual(form.rawValue, form.designKey, "\(form) kept a body word")
            } else {
                XCTAssertEqual(form.rawValue, form.designKey,
                               "\(form) drifted from Design's key for no reason")
            }
        }

        // and they still do what Design had them do
        XCTAssertEqual(HomeAttributeForm.foldingCapsules.movingParts.count, 5)
        XCTAssertEqual(HomeAttributeForm.linedDisc.movingParts, ["disc"])
        XCTAssertEqual(HomeAttributeForm.shell.movingParts, ["held", "rim"])
    }

    // MARK: - Helpers

    private func shakti(named name: String, position: Int?, location: String) -> Shakti {
        Shakti(position: 1, name: name, shortName: "", phonetic: "",
               quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
               bija: "", bodilyLocation: location, tattva: "", recognitionPhrase: "",
               cluster: .inner, status: .mapped, khadgamalaPosition: position)
    }

    /// Positions, scales, opacity and intensity must match outright. Rotations
    /// are angles — a form that spins continuously has turned a whole number of
    /// times in a period, which is the same pose.
    private func assertSameMotion(_ a: AttributeMotion, _ b: AttributeMotion,
                                  form: HomeAttributeForm, part: String, t: Double,
                                  file: StaticString = #filePath, line: UInt = #line) {
        let plain: [(String, Double, Double)] = [
            ("x", a.x, b.x), ("y", a.y, b.y), ("z", a.z, b.z),
            ("scaleX", a.scaleX, b.scaleX), ("scaleY", a.scaleY, b.scaleY),
            ("scaleZ", a.scaleZ, b.scaleZ),
            ("opacity", a.opacity, b.opacity), ("intensity", a.intensity, b.intensity),
        ]
        for (channel, here, later) in plain {
            XCTAssertEqual(here, later, accuracy: 1e-6,
                           "\(form) · \(part) · \(channel) at \(t) never came back",
                           file: file, line: line)
        }
        let angles: [(String, Double, Double)] = [
            ("pitch", a.pitch, b.pitch), ("yaw", a.yaw, b.yaw), ("roll", a.roll, b.roll),
        ]
        for (channel, here, later) in angles {
            XCTAssertEqual(Self.angleGap(here, later), 0, accuracy: 1e-6,
                           "\(form) · \(part) · \(channel) at \(t) never came back",
                           file: file, line: line)
        }
    }

    private static func angleGap(_ a: Double, _ b: Double) -> Double {
        let tau = Double.pi * 2
        let d = abs((a - b).truncatingRemainder(dividingBy: tau))
        return min(d, tau - d)
    }

    /// Words, split on case and punctuation, with a plural's tail removed so
    /// "hands" is caught and "bears" is not mistaken for an ear.
    private static func words(in phrase: String) -> [String] {
        var out: [String] = []
        var current = ""
        for character in phrase {
            if character.isLetter {
                if character.isUppercase && !current.isEmpty {
                    out.append(current)
                    current = ""
                }
                current.append(contentsOf: character.lowercased())
            } else if !current.isEmpty {
                out.append(current)
                current = ""
            }
        }
        if !current.isEmpty { out.append(current) }
        return out.map { $0.count > 3 && $0.hasSuffix("s") ? String($0.dropLast()) : $0 }
    }
}
