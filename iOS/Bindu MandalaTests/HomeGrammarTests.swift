import XCTest
@testable import Bindu_Mandala

// MARK: - The grammar, asked the questions Design's own ordering makes necessary
//
// `HomeGrammar` is the layer that makes a room hers rather than anyone else's.
// It is a port of `Claude Design Round 2/homes/homes-grammar.js`, and almost
// everything that can go wrong in a port of it is silent:
//
//   · a classifier rule re-sorted into a tidier order changes which physics a
//     Śakti gets, and nothing crashes;
//   · a displacement expression copied approximately still moves, just not the
//     way she moves;
//   · a formula off by one at a boundary still returns a number;
//   · a label that starts measuring still reads as a sentence.
//
// So each of those is asked directly, and the load-bearing ones are pinned hard
// enough that a "cleanup" fails the suite rather than the instrument.
//
// **No roster is bundled to run this.** The sixteen Karṣiṇīs that ship in the
// binary are driven as themselves; the other eighty-six are *synthetic* — real
// tattva vocabulary, not copied cards — because their rows live in Airtable and
// nowhere else. That is the point: the grammar reads a vocabulary, not a table.

@MainActor
final class HomeGrammarTests: XCTestCase {

    // MARK: - The classifier is whole

    func testTheClassifierIsWhole() {
        XCTAssertEqual(HomeGrammar.physicsRules.count, 50,
                       "Design's PHYSICS holds fifty rules")
        XCTAssertEqual(HomeGrammar.compiledPhysicsRules.count, HomeGrammar.physicsRules.count,
                       "every rule must compile: \(HomeGrammar.physicsRules.map(\.js))")

        // Fifty kinds, plus `breathe` — the fall-through, which is a named case
        // so the kernel's switch is exhaustive.
        XCTAssertEqual(HomePhysics.allCases.count, 51)
        let ruled = Set(HomeGrammar.physicsRules.map(\.kind))
        XCTAssertEqual(ruled.count, 50, "no two rules may claim the same physics")
        XCTAssertFalse(ruled.contains(.breathe),
                       "`breathe` is never a rule's verdict — only the absence of one")
        XCTAssertEqual(Set(HomePhysics.allCases).subtracting(ruled), [.breathe])
    }

    /// **The pin.** Design's ordering is a set of priorities, not a list to be
    /// sorted. If this fails because the array was re-ordered, it is the
    /// re-ordering that is wrong.
    func testTheRuleOrderIsLoadBearing() {
        let expected: [HomePhysics] = [
            .arrest, .expand, .widen, .shrink, .flow, .well, .settle, .flare, .lift, .open,
            .stir, .draw, .waver, .merge, .dart, .encircle, .point, .reach, .trace, .dissolve,
            .fill, .compress, .spring, .sustain, .sound, .clarify, .assert, .lean, .swell, .ground,
            .incline, .arrive, .bloom, .recur, .call, .turn, .persist, .land, .stand, .rest,
            .thread, .rise, .align, .brighten, .unbind, .mend, .tint, .converge, .centre, .surge,
        ]
        XCTAssertEqual(HomeGrammar.physicsRules.map(\.kind), expected,
                       """
                       the fifty rules are out of Design's order. First match wins, so an \
                       order change is a behaviour change in every room whose tattva trips \
                       two rules — see `testSourceFiresBeforeIccha`.
                       """)
    }

    /// The case the ordering exists for: `source` is read before `icchā`, so a
    /// Śakti whose tattva names both the will and the source springs rather
    /// than inclines. kp 99 and kp 101 land in the same physics because of it.
    func testSourceFiresBeforeIccha() {
        let source = HomeGrammar.physicsRules.firstIndex { $0.kind == .spring }
        let iccha = HomeGrammar.physicsRules.firstIndex { $0.kind == .incline }
        XCTAssertNotNil(source); XCTAssertNotNil(iccha)
        XCTAssertLessThan(source!, iccha!,
                          "`source` must be read before `icchā`, or the Triad changes physics")

        // Both words present: source wins.
        XCTAssertEqual(
            HomeGrammar.physics(tattva: "Icchā Śakti — the will at its source", quality: ""),
            .spring,
            "a tattva naming both the will and the source resolves to `spring`"
        )
        // The will alone still inclines, so the earlier rule shadows nothing it
        // should not.
        XCTAssertEqual(
            HomeGrammar.physics(tattva: "Icchā Śakti, pure willing", quality: ""),
            .incline
        )
    }

    /// A rule that can never fire is dead weight pretending to be coverage.
    /// Each of the fifty is probed with a word out of its own alternation.
    func testEveryRuleCanFire() {
        for (probe, kind) in Self.ruleProbes {
            XCTAssertEqual(HomeGrammar.physics(tattva: probe, quality: ""), kind,
                           "\"\(probe)\" should read as \(kind.rawValue)")
        }
        XCTAssertEqual(Set(Self.ruleProbes.map { $0.1 }).count, 50,
                       "one probe per rule, and all fifty reachable")
    }

    /// The audit that caused Design's rewrite: 78 of 102 rooms — better than
    /// three in four — were falling through to one generic motion. The default
    /// must stay reachable, because a classifier that never falls through is
    /// lying about its own coverage, and it must stay far from the common case.
    ///
    /// The share measured here is a **ceiling, not the instrument's number**.
    /// Eighty-five of these rooms are synthetic single-word tattvas, where a
    /// real card offers the classifier a whole tattva line *and* a quality
    /// sentence to read; the sixteen real ones fall through not once — see
    /// `testTheSixteenKarsinisReadAsRoomsOfTheSecondRing`. What residue there
    /// is, is a genuine gap in Design's vocabulary rather than in the port (the
    /// six kañcukas and the Spanda words have no rule), and it is recorded in
    /// `DECISIONS.md` for the rooms layer rather than tuned away here.
    func testTheBreatheDefaultIsRareRatherThanTheCommonCase() {
        let readings = Self.allOneHundredAndTwo()
        XCTAssertEqual(readings.count, 101,
                       "rings 1–8 hold 101 rooms; the Bindu's is authored, not grammared")

        var tally: [HomePhysics: Int] = [:]
        for r in readings { tally[r.physics, default: 0] += 1 }

        let breathe = tally[.breathe] ?? 0
        XCTAssertGreaterThan(breathe, 0,
                             "the fall-through must stay reachable, or it is a lie")
        XCTAssertLessThan(Double(breathe) / Double(readings.count), 0.25,
                          "`breathe` claims \(breathe) of \(readings.count) rooms; Design's audit found 78 of 102 doing exactly that")
        XCTAssertGreaterThanOrEqual(tally.keys.count, 20,
                                    "the rooms should speak a vocabulary, not a dozen words")
    }

    /// The sixteen that ship in the binary, read as themselves.
    func testTheSixteenKarsinisReadAsRoomsOfTheSecondRing() {
        let rooms = Self.karsiniReadings()
        XCTAssertEqual(rooms.count, 16)

        for r in rooms {
            XCTAssertEqual(r.ring, 2)
            XCTAssertEqual(r.archetype, .crossed)
            let phase = try? XCTUnwrap(r.phase)
            XCTAssertEqual(phase ?? -1,
                           Double(HomeGrammar.mod(r.position, 16)) / 16,
                           accuracy: 1e-12,
                           "Ring 2 phases in sixteenths of her position")
        }
        XCTAssertEqual(rooms.map(\.position), Array(29...44), "Ring 2 is kp 29–44")

        // Her tattva, not a default, is what moves her room: the elements the
        // sixteen actually carry come through as distinct physics.
        let kinds = Set(rooms.map(\.physics))
        XCTAssertGreaterThanOrEqual(kinds.count, 6,
                                    "the sixteen should not collapse into a handful of motions")
        let breathing = rooms.filter { $0.physics == .breathe }.count
        XCTAssertEqual(breathing, 0,
                       "\(breathing) of the sixteen fall through — on real cards the classifier reads every one")
    }

    /// The other half of why the order matters, and this one is visible in the
    /// only real cards the binary holds. Every Karṣiṇī's quality says "she who
    /// **attracts** …", which trips the `ākarṣaṇa` rule — and `ākarṣaṇa` is the
    /// twelfth rule, two behind the five elements. So her *tattva* decides her
    /// room, and the verb all sixteen share is only what is left when her
    /// tattva names no element. Sort the rules and the whole ring collapses
    /// into one motion.
    func testHerTattvaOutranksTheVerbHerSistersShare() {
        XCTAssertEqual(HomeGrammar.physics(tattva: "Fire (Agni)",
                                           quality: "She who attracts Desire"), .flare)
        XCTAssertEqual(HomeGrammar.physics(tattva: "Water (Jala)",
                                           quality: "She who attracts Taste"), .well)
        XCTAssertEqual(HomeGrammar.physics(tattva: "Space (Ākāśa)",
                                           quality: "She who attracts Sound"), .open)

        // Where her tattva names no element, the shared verb is what is left —
        // and "she who attracts" is exactly what a Karṣiṇī is.
        XCTAssertEqual(HomeGrammar.physics(tattva: "Pure Being (Sat)",
                                           quality: "She who attracts the Self"), .draw)

        let element = HomeGrammar.physicsRules.firstIndex { $0.kind == .flare }
        let attract = HomeGrammar.physicsRules.firstIndex { $0.kind == .draw }
        XCTAssertNotNil(element); XCTAssertNotNil(attract)
        XCTAssertLessThan(element!, attract!,
                          "the elements must be read before `attract`, or Ring 2 becomes one room")
    }

    // MARK: - The displacement kernel

    /// Pure: the same four inputs always give the same offset, and nothing in
    /// it reads a clock, a memory or a walker.
    func testTheKernelIsAPureFunction() {
        for kind in HomePhysics.allCases {
            let a = HomeGrammar.displace(kind, time: 41.5, phase: 0.375, amplitude: 1.7)
            let b = HomeGrammar.displace(kind, time: 41.5, phase: 0.375, amplitude: 1.7)
            XCTAssertEqual(a, b, "\(kind.rawValue) is not a pure function of its inputs")
        }
    }

    func testTheKernelMovesWithTime() {
        var still: Set<HomePhysics> = []
        for kind in HomePhysics.allCases {
            let early = HomeGrammar.displace(kind, time: 3, phase: 0.2, amplitude: 1)
            let later = HomeGrammar.displace(kind, time: 97, phase: 0.2, amplitude: 1)
            if early == later { still.insert(kind) }
        }
        XCTAssertEqual(still, HomeGrammar.stillKinds,
                       """
                       exactly two kinds hold still — `arrest` and `centre`. A third \
                       means an expression was copied as a constant.
                       """)
    }

    func testTheKernelRestsAtZeroAmplitude() {
        for kind in HomePhysics.allCases {
            XCTAssertEqual(HomeGrammar.displace(kind, time: 12.25, phase: 0.6, amplitude: 0),
                           .zero,
                           "\(kind.rawValue) must scale with amplitude, not add to it")
        }
    }

    /// Her phase is what stops neighbours moving alike: the same physics at a
    /// different turn of the cycle is a different room.
    ///
    /// A **quarter** turn, deliberately. Eight of the kinds move on a rectified
    /// sine — `|sin|`, whose period is half a turn — so a half-turn apart they
    /// are genuinely identical and would prove nothing. The quarter turn is the
    /// separation Design's own divisors actually hand neighbours.
    func testPhaseSeparatesNeighbours() {
        let moving = HomePhysics.allCases.filter { !HomeGrammar.stillKinds.contains($0) }
        for kind in moving {
            let a = HomeGrammar.displace(kind, time: 8, phase: 0, amplitude: 2)
            let b = HomeGrammar.displace(kind, time: 8, phase: 0.25, amplitude: 2)
            XCTAssertNotEqual(a, b, "\(kind.rawValue) ignores her phase")
        }
    }

    /// Three transcriptions, checked against the arithmetic by hand — one plain
    /// sine, one half-rectified pulse, one two-term sum — so an "approximately"
    /// ported expression is caught rather than trusted.
    func testTheArithmeticIsPortedFaithfully() {
        let t = 7.0, phase = 0.25, amp = 1.5
        let p = phase * Double.pi * 2

        XCTAssertEqual(HomeGrammar.displace(.expand, time: t, phase: phase, amplitude: amp).y,
                       sin(t * 0.09 + p) * amp * 1.6, accuracy: 1e-12)

        XCTAssertEqual(HomeGrammar.displace(.settle, time: t, phase: phase, amplitude: amp).y,
                       -abs(sin(t * 0.07 + p)) * amp * 1.3, accuracy: 1e-12)

        XCTAssertEqual(HomeGrammar.displace(.sound, time: t, phase: phase, amplitude: amp).y,
                       sin(t * 1.6 + p) * amp * 0.3 + sin(t * 0.2 + p) * amp * 0.5,
                       accuracy: 1e-12)

        // `ground` carries a constant offset as well as a pulse — it is the one
        // kind that sits below the line even at rest.
        XCTAssertEqual(HomeGrammar.displace(.ground, time: t, phase: phase, amplitude: amp).y,
                       -amp * 0.5 - abs(sin(t * 0.04 + p)) * amp * 0.3, accuracy: 1e-12)
    }

    // MARK: - The family dispatch

    func testRingOneSplitsThreeWaysAtItsBoundaries() {
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 1), .siddhi)
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 10), .siddhi)
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 11), .matrka)
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 18), .matrka)
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 19), .mudra)
        XCTAssertEqual(HomeGrammar.archetype(ring: 1, position: 28), .mudra)
    }

    func testEachRingGetsItsArchetypeAndTheBinduGetsNone() {
        XCTAssertEqual(HomeGrammar.archetype(ring: 2, position: 29), .crossed)
        XCTAssertEqual(HomeGrammar.archetype(ring: 3, position: 45), .bodiless)
        XCTAssertEqual(HomeGrammar.archetype(ring: 4, position: 53), .cosmic)
        XCTAssertEqual(HomeGrammar.archetype(ring: 5, position: 67), .giving)
        XCTAssertEqual(HomeGrammar.archetype(ring: 6, position: 77), .revealing)
        XCTAssertEqual(HomeGrammar.archetype(ring: 7, position: 87), .sounding)
        XCTAssertEqual(HomeGrammar.archetype(ring: 8, position: 99), .sourcing)

        XCTAssertNil(HomeGrammar.archetype(ring: 9, position: 102),
                     "the Bindu's room is authored; the grammar declines rather than inventing one")
        XCTAssertNil(HomeGrammar.read(position: 102, ring: 9,
                                      tattva: "Para-bindu", quality: "she who is the point",
                                      bodilyLocation: "crown"))
    }

    // MARK: - The per-archetype formulas, at their boundaries

    func testThePhaseDivisors() {
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .bodiless), 8)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .matrka), 8)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .cosmic), 14)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .giving), 10)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .revealing), 10)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .siddhi), 10)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .mudra), 10)
        XCTAssertEqual(HomeGrammar.phaseDivisor(for: .crossed), 16)
        XCTAssertNil(HomeGrammar.phaseDivisor(for: .sounding),
                     "SOUNDING phases its nodes by their own index within her mode")
        XCTAssertNil(HomeGrammar.phaseDivisor(for: .sourcing),
                     "SOURCING phases by which of the three corners is lit")
    }

    func testPhaseWrapsAtTheDivisor() throws {
        // A multiple of the divisor lands back at the start of the cycle…
        func phase(_ a: HomeArchetype, _ pos: Int) throws -> Double {
            try XCTUnwrap(HomeGrammar.phase(archetype: a, position: pos))
        }
        XCTAssertEqual(try phase(.crossed, 32), 0, accuracy: 1e-12)
        XCTAssertEqual(try phase(.crossed, 33), 1.0 / 16, accuracy: 1e-12)
        XCTAssertEqual(try phase(.crossed, 31), 15.0 / 16, accuracy: 1e-12)
        XCTAssertEqual(try phase(.cosmic, 56), 0, accuracy: 1e-12)
        XCTAssertEqual(try phase(.bodiless, 47), 7.0 / 8, accuracy: 1e-12)

        // …and every phase is a turn, never outside it.
        for pos in 1...102 {
            for archetype in HomeArchetype.allCases {
                guard let p = HomeGrammar.phase(archetype: archetype, position: pos) else { continue }
                XCTAssertGreaterThanOrEqual(p, 0)
                XCTAssertLessThan(p, 1)
            }
        }
    }

    func testAltitudeIsTallerInTheNearRings() {
        // (0.5 − alt) × 9 in rings 1–3, × 8 elsewhere.
        XCTAssertEqual(HomeGrammar.altitude(ring: 1, bodyAltitude: 0.94), (0.5 - 0.94) * 9, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.altitude(ring: 3, bodyAltitude: 0.1), (0.5 - 0.1) * 9, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.altitude(ring: 4, bodyAltitude: 0.1), (0.5 - 0.1) * 8, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.altitude(ring: 8, bodyAltitude: 0.94), (0.5 - 0.94) * 8, accuracy: 1e-12)

        // The middle of the body is the middle of the room, in every ring.
        for ring in 1...9 {
            XCTAssertEqual(HomeGrammar.altitude(ring: ring, bodyAltitude: 0.5), 0, accuracy: 1e-12)
        }
    }

    func testSoundingModeAcrossTheSeventhRing() {
        // 2 + (pos % 8): two waves at the least, nine at the most.
        XCTAssertEqual(HomeGrammar.soundingMode(position: 88), 2)  // 88 % 8 == 0
        XCTAssertEqual(HomeGrammar.soundingMode(position: 87), 9)
        XCTAssertEqual(HomeGrammar.soundingMode(position: 89), 3)
        for pos in 87...98 {
            let n = HomeGrammar.soundingMode(position: pos)
            XCTAssertTrue((2...9).contains(n), "mode \(n) at kp \(pos) is outside her rows")
        }
        // Ring 7 holds twelve seats and eight modes, so her wave cycles through
        // every one of them before any is heard twice.
        XCTAssertEqual(Set((87...94).map { HomeGrammar.soundingMode(position: $0) }),
                       Set(2...9),
                       "the first eight of the Vāsinīs must sound all eight modes")
    }

    func testMatrkaLetterCountAcrossHerEightRows() {
        // 5 + ((pos − 11) % 4) × 3 — five, eight, eleven, fourteen, repeating.
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 11), 5)
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 12), 8)
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 13), 11)
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 14), 14)
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 15), 5)
        XCTAssertEqual(HomeGrammar.matrkaLetterCount(position: 18), 14)
        XCTAssertEqual(Set((11...18).map { HomeGrammar.matrkaLetterCount(position: $0) }),
                       [5, 8, 11, 14])
    }

    func testSourcingCornerIsTheTriad() {
        XCTAssertEqual(HomeGrammar.sourcingCorner(position: 99), 0)   // icchā
        XCTAssertEqual(HomeGrammar.sourcingCorner(position: 100), 1)  // kriyā
        XCTAssertEqual(HomeGrammar.sourcingCorner(position: 101), 2)  // jñāna
    }

    /// Her position is the only key, and every formula must survive one outside
    /// its own band without turning a turn backwards.
    func testTheFormulasNeverTurnBackwards() {
        XCTAssertEqual(HomeGrammar.mod(-1, 4), 3)
        XCTAssertEqual(HomeGrammar.mod(0, 4), 0)
        XCTAssertEqual(HomeGrammar.mod(7, 4), 3)
        XCTAssertEqual(HomeGrammar.mod(5, 0), 0)
        XCTAssertGreaterThanOrEqual(HomeGrammar.matrkaLetterCount(position: 1), 5,
                                    "a position below her band must not yield a negative row")
    }

    // MARK: - Her altitude, across the zone vocabulary

    func testBodyAltitudeAcrossTheZoneVocabulary() {
        let expected: [(String, Double)] = [
            ("soles", 0.94), ("feet", 0.94), ("mūlādhāra", 0.94),
            ("belly", 0.66), ("navel", 0.66), ("yoni", 0.66), ("abundance", 0.66),
            ("solar plexus", 0.6),
            ("waist", 0.68),
            ("diaphragm", 0.56),
            ("sternum", 0.46), ("chest", 0.46), ("heart", 0.46),
            ("throat", 0.34), ("palate", 0.34), ("mouth", 0.34),
            ("behind the eyes", 0.26), ("eyes", 0.26), ("face", 0.26),
            ("forehead", 0.2), ("third eye", 0.2),
            ("crown", 0.1), ("above the head", 0.1),
            ("spine", 0.5), ("whole body", 0.5), ("whole field", 0.5),
            ("cellular", 0.5), ("totality", 0.5),
        ]
        for (word, altitude) in expected {
            XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: word), altitude, accuracy: 1e-12,
                           "\"\(word)\" sits at the wrong height")
        }

        // Design's zones carry `/i`, so her card's capitalisation cannot move her.
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "The Heart"), 0.46, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "CROWN"), 0.1, accuracy: 1e-12)

        // A word the vocabulary does not know sits at the middle — the same
        // honest answer the spine and the whole body get, not a guess.
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "skin"), 0.5, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: ""), 0.5, accuracy: 1e-12)
    }

    /// The zones are first-match-wins too, and the order is Design's reading:
    /// "between the eyes" reaches the *eyes* rule before the *third eye* one.
    /// Recorded as behaviour so a later re-sort is visible rather than silent.
    func testTheZoneOrderIsLoadBearing() {
        let eyes = HomeGrammar.bodyZones.firstIndex { $0.altitude == 0.26 }
        let brow = HomeGrammar.bodyZones.firstIndex { $0.altitude == 0.2 }
        XCTAssertNotNil(eyes); XCTAssertNotNil(brow)
        XCTAssertLessThan(eyes!, brow!)
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "between the eyes"), 0.26,
                       accuracy: 1e-12,
                       "the eyes are read before the brow — Design's order, not a slip")

        XCTAssertEqual(HomeGrammar.bodyZones.count, 11)
        XCTAssertEqual(HomeGrammar.compiledBodyZones.count, HomeGrammar.bodyZones.count,
                       "every zone must compile: \(HomeGrammar.bodyZones.map(\.js))")
    }

    // MARK: - Her words

    func testTheNearLabelIsHerQualitySpokenInTheRoomsVoice() {
        let l = HomeGrammar.label(archetype: .giving, position: 67,
                                  quality: "She who attracts Abundance")
        XCTAssertEqual(l.near, "she who attracts abundance · arriving, unasked")
        XCTAssertEqual(l.deep, "the giving and the given are one")
    }

    func testHerSeedSyllableSpeaksWhereSheCarriesOne() {
        let withBija = HomeGrammar.label(archetype: .sounding, position: 87,
                                         quality: "She who abides in Sound", bija: "aṃ")
        XCTAssertEqual(withBija.near, "she who abides in sound · aṃ")

        // Most of the 102 carry none, and the room falls back to Design's words
        // rather than to a blank.
        let without = HomeGrammar.label(archetype: .sounding, position: 87,
                                        quality: "She who abides in Sound", bija: nil)
        XCTAssertEqual(without.near, "she who abides in sound · the room is her sound")
    }

    func testSourcingSpeaksItsCornerWithoutHerQualityInFront() {
        // Design wrote the three corners as whole sentences; a quality in front
        // of them says the same thing twice.
        XCTAssertFalse(HomeGrammar.prefixesQuality(.sourcing))
        for a in HomeArchetype.allCases where a != .sourcing {
            XCTAssertTrue(HomeGrammar.prefixesQuality(a))
        }
        XCTAssertEqual(HomeGrammar.label(archetype: .sourcing, position: 99, quality: "x").near,
                       "will, before there is anything to will")
        XCTAssertEqual(HomeGrammar.label(archetype: .sourcing, position: 100, quality: "x").near,
                       "the act, before there is a deed")
        XCTAssertEqual(HomeGrammar.label(archetype: .sourcing, position: 101, quality: "x").deep,
                       "form was already will and act")
        // A position outside the Triad still speaks, rather than trapping.
        XCTAssertEqual(HomeGrammar.label(archetype: .sourcing, position: 7, quality: "x").near,
                       "at the source")
    }

    func testTheKeyPairingNamesItselfAtTheSecondAdaptation() {
        XCTAssertEqual(HomeGrammar.label(archetype: .crossed, position: 44, quality: "x").deep,
                       "body and mind were one point")
        XCTAssertEqual(HomeGrammar.label(archetype: .crossed, position: 43, quality: "x").deep,
                       "the drawing and the drawn are one")
    }

    /// The room reverses its own premise past the second adaptation — and it is
    /// the *depth of this stay* that switches it, never a visit or a count.
    func testTheDeepLabelSwitchesPastTheSecondAdaptation() {
        let l = HomeGrammar.label(archetype: .bodiless, position: 45, quality: "She who is Bodiless")
        XCTAssertEqual(l.text(deepProgress: 0), l.near)
        XCTAssertEqual(l.text(deepProgress: 0.45), l.near, "the switch is strictly past 0.45")
        XCTAssertEqual(l.text(deepProgress: 0.4501), l.deep)
        XCTAssertEqual(l.text(deepProgress: 1), l.deep)

        // And the depth comes from the chamber clock's own marks.
        XCTAssertEqual(HomeGrammar.deepProgress(chamberTime: HomeMemory.holdEnd), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.deepProgress(chamberTime: HomeMemory.holdEnd - 40), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.deepProgress(chamberTime: HomeMemory.secondAdaptationEnd), 1,
                       accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.deepProgress(chamberTime: 10_000), 1, accuracy: 1e-12)

        let midway = (HomeMemory.holdEnd + HomeMemory.secondAdaptationEnd) / 2
        XCTAssertEqual(HomeGrammar.deepProgress(chamberTime: midway), 0.5, accuracy: 1e-12)
        XCTAssertGreaterThan(HomeGrammar.deepProgress(chamberTime: midway + 5),
                             HomeGrammar.secondAdaptationSwitch,
                             "the reversal is reached inside the second adaptation, not after it")
    }

    func testTheSettlingRampIsTheFirstAdaptation() {
        XCTAssertEqual(HomeGrammar.settling(chamberTime: 0), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.settling(chamberTime: HomeMemory.firstAdaptation), 1,
                       accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.settling(chamberTime: HomeMemory.firstAdaptation / 2), 0.5,
                       accuracy: 1e-12)
    }

    // MARK: - Nothing the grammar says measures the walker

    /// Every label the grammar can compose, for every one of the 101 grammared
    /// rooms, at both depths — run through Design's nine `MEASURING` patterns,
    /// the same nine `HomesHarnessTests` holds. Law 2 / Ruling 2.
    func testNoComposedLabelMeasuresTheWalker() {
        var offences: [String] = []
        var seen = 0

        for r in Self.allOneHundredAndTwo() {
            for (depth, text) in [("near", r.label.near), ("deep", r.label.deep)] {
                seen += 1
                let hits = Measuring.measuresOutLoud(text)
                if !hits.isEmpty {
                    offences.append("kp \(r.position) \(r.archetype.rawValue) \(depth) — \"\(text)\" trips \(hits.joined(separator: ", "))")
                }
            }
        }

        // Every archetype's own words, independent of any Śakti's card.
        for archetype in HomeArchetype.allCases {
            for pos in [1, 44, 99, 100, 101] {
                let t = HomeGrammar.tag(for: archetype, position: pos, bija: nil)
                for text in [t.near, t.deep] {
                    seen += 1
                    let hits = Measuring.measuresOutLoud(text)
                    if !hits.isEmpty {
                        offences.append("\(archetype.rawValue) tag — \"\(text)\" trips \(hits.joined(separator: ", "))")
                    }
                }
            }
        }

        XCTAssertGreaterThan(seen, 200, "the detector read too little to mean anything")
        XCTAssertTrue(offences.isEmpty,
                      """
                      \(offences.count) label(s) measure the walker out loud — a Law-2 \
                      violation. Change the words; never weaken the pattern.
                      \(offences.joined(separator: "\n"))
                      """)
    }

    /// The check above has teeth only if a measuring label would actually trip
    /// it. This proves it does, through the composer rather than beside it.
    func testTheDetectorWouldCatchAMeasuringLabel() {
        let bad = HomeGrammar.label(archetype: .mudra, position: 19, quality: "felt 7 times")
        XCTAssertFalse(Measuring.measuresOutLoud(bad.near).isEmpty,
                       "a measuring quality must trip the detector once composed")
    }

    /// Belt and braces, and the plainer statement of the same law: no digit
    /// reaches a label at all.
    func testNoLabelCarriesANumber() {
        let digits = CharacterSet.decimalDigits
        for r in Self.allOneHundredAndTwo() {
            XCTAssertNil(r.label.near.rangeOfCharacter(from: digits),
                         "kp \(r.position) near label carries a number: \"\(r.label.near)\"")
            XCTAssertNil(r.label.deep.rangeOfCharacter(from: digits),
                         "kp \(r.position) deep label carries a number: \"\(r.label.deep)\"")
        }
    }

    /// Her words are hers: within a ring, no two sisters say the same thing
    /// while the eye is still settling.
    func testNoTwoSistersInARingSpeakTheSameNearWords() {
        var byRing: [Int: [String]] = [:]
        for r in Self.allOneHundredAndTwo() {
            byRing[r.ring, default: []].append(r.label.near)
        }
        for (ring, words) in byRing {
            XCTAssertEqual(Set(words).count, words.count,
                           "ring \(ring) has sisters speaking alike: \(words)")
        }
    }

    // MARK: - Reading her row

    func testARowThatHasNotBeenReKeyedHasNoRoom() {
        // A row of her own, not one of the shared bootstrap instances: this test
        // writes to it, and the sixteen in the binary are read by other suites.
        let s = Shakti(
            position: 1, name: "", shortName: "", phonetic: "",
            quality: "She who attracts Desire", qualityDescription: "",
            somatic: "", somaticPoetry: "", bija: "aṁ",
            bodilyLocation: "heart", tattva: "Fire (Agni)",
            recognitionPhrase: "", cluster: .inner, status: .mapped
        )
        s.khadgamalaPosition = nil
        XCTAssertNil(HomeGrammar.read(s),
                     "no khaḍgamālā position is no identity, and so no room")

        s.khadgamalaPosition = 29
        s.ringNumber = nil
        XCTAssertNil(HomeGrammar.read(s))

        s.ringNumber = 2
        let room = HomeGrammar.read(s)
        XCTAssertEqual(room?.position, 29)
        XCTAssertEqual(room?.archetype, .crossed)
    }
}

// MARK: - The corpus
//
// Rings 1 and 3–8 live in Airtable, not in the binary, so they are built here
// from **synthetic** Śakti values over the real tattva vocabulary. That is
// deliberate: a bundled 102-card table would be the ghost roster the laws
// forbid, and the thing under test is whether the grammar reads a vocabulary at
// all. Ring 2 is driven from the sixteen that genuinely ship.

private extension HomeGrammarTests {

    /// One probe per classifier rule, drawn from that rule's own alternation.
    static let ruleProbes: [(String, HomePhysics)] = [
        ("stambha", .arrest), ("vikāsa", .expand), ("mahat", .widen), ("aṇu", .shrink),
        ("dravat", .flow), ("apaḥ", .well), ("pṛthivī", .settle), ("tejas", .flare),
        ("vāyu", .lift), ("ākāśa", .open), ("kṣobha", .stir), ("ākarṣaṇa", .draw),
        ("moha", .waver), ("advaita", .merge), ("vega", .dart), ("pāśa", .encircle),
        ("aṅkuśa", .point), ("viraha", .reach), ("rekhā", .trace), ("pralaya", .dissolve),
        ("pūrṇa", .fill), ("bīja", .compress), ("yoni", .spring), ("sthiti", .sustain),
        ("śabda", .sound), ("jñāna", .clarify), ("ahaṅkāra", .assert), ("śrotra", .lean),
        ("ānanda", .swell), ("ādhāra", .ground), ("icchā", .incline), ("prāpti", .arrive),
        ("saundarya", .bloom), ("smṛti", .recur), ("nāma", .call), ("ātman", .turn),
        ("amṛta", .persist), ("śarīra", .land), ("dhairya", .stand), ("citta", .rest),
        ("kula", .thread), ("aiśvarya", .rise), ("saṃyama", .align), ("maṅgala", .brighten),
        ("duḥkha", .unbind), ("ārogya", .mend), ("rañjana", .tint), ("trinity", .converge),
        ("totality", .centre), ("śakti", .surge),
    ]

    /// The vocabulary and the roster now live in one place —
    /// `HomesCorpus` — because `HomesHarnessTests` asks the same 102 rooms the
    /// same questions, and two rosters would let one suite pass against data
    /// the other never saw. These three forward to it and are kept so the tests
    /// below read as they did.
    static var syntheticTattvas: [String] { HomesCorpus.syntheticTattvas }
    static var syntheticLocations: [String] { HomesCorpus.syntheticLocations }

    /// Her khaḍgamālā position is the only key, so a synthetic Śakti needs
    /// nothing but a position, a ring and three fields off her row.
    static func syntheticReading(position pos: Int) -> HomeGrammar.Reading? {
        let row = HomesCorpus.syntheticRow(position: pos)
        return HomeGrammar.read(position: row.position, ring: row.ring, tattva: row.tattva,
                                quality: row.quality, bodilyLocation: row.bodilyLocation,
                                bija: row.bija)
    }

    /// The sixteen that ship in the binary, read at their khaḍgamālā positions.
    static func karsiniReadings() -> [HomeGrammar.Reading] {
        HomesCorpus.karsiniRows().compactMap {
            HomeGrammar.read(position: $0.position, ring: $0.ring, tattva: $0.tattva,
                             quality: $0.quality, bodilyLocation: $0.bodilyLocation,
                             bija: $0.bija)
        }
    }

    /// Every room the grammar speaks for: the sixteen real ones, and synthetic
    /// rows everywhere else. Ring 9 is absent by design — the Bindu's room is
    /// authored, so there are 101, not 102.
    static func allOneHundredAndTwo() -> [HomeGrammar.Reading] {
        let real = Dictionary(uniqueKeysWithValues: karsiniReadings().map { ($0.position, $0) })
        return (1...102).compactMap { real[$0] ?? syntheticReading(position: $0) }
    }
}
