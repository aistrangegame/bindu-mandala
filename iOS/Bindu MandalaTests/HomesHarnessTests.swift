import XCTest
import SwiftData
@testable import Bindu_Mandala

// MARK: - Brief v2 §2.5 — the runnable slice of Design's verification pass
//
// `Claude Design Round 2/homes/homes-verify.js` and `The Homes - Verification
// V3.html` are Design's own audit: 66 checks across nine registers — canon,
// coverage, distinction, legibility, promise, felt, coherence, brief,
// iconography — run backwards from what was claimed, and built to fail loudly.
//
// Most of them ask the rooms questions, and the rooms do not exist yet. This
// file is the part of that pass that can be asked of the instrument **as it
// stands today**, ported to Swift and run against the real code rather than a
// copy of it:
//
//   · promise  · "the ceremony compresses on return but is never skipped"
//   · promise  · "the head start comes from dwell, not from visit count"
//   · promise  · "the second adaptation is reachable only through relationship"
//   · promise  · "the fifth is withheld outside the ninth world"
//   · felt     · the `MEASURING` detector, ported verbatim, over every
//                user-facing string the instrument can compose today
//   · coverage · "the known collisions resolve by position, not by name"
//   · coverage · "every authored room is actually reached" — the check Design's
//                own pass does **not** have, and the reason four of its eight
//                authored rooms fall through in its shipped Axis
//   · distinction · language uniqueness, over all 102
//   · distinction · sister divergence, at the level of logic
//
// The four `promise` checks are asked of `HomeMemoryStore` — the store, on a
// real container — and not only of the pure statics `HomeMemoryTests` already
// covers, so what is proven here is the path the rooms will actually call.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT CANNOT RUN YET, AND WHAT WILL LIGHT IT UP
// ─────────────────────────────────────────────────────────────────────────────
//
// These are deliberately **absent**, not stubbed. An empty test reads as a
// passing one, and a register reporting green while asserting nothing is the
// exact failure `homes-verify.js` was written to prevent. Each returns as a real
// check the moment the thing it interrogates exists:
//
//  1. distinction · "adjacent sisters diverge **geometrically** by more than a
//     tenth". The *logic* half of this check now runs — see
//     `testAdjacentSistersDivergeAcrossTheGrammarThatDrivesTheirRooms`, which
//     asks Design's own `divergence` of a fingerprint built from what the
//     grammar produces rather than from what a renderer draws. What is still
//     absent is the geometric half: a node graph whose children carry position,
//     scale and opacity, and a Swift port of `fingerprint(chamber, t)` over it.
//     That lights up when the rooms are built (Phase 3.4 → 3.5 → 3.6) under the
//     ruled renderer. This is the check that carries Ruling 10: the Gate's two
//     rooms are authored by hand, and the grammar is proven by sister
//     divergence across the other rooms instead.
//
//  2. distinction · "every room reverses its premise at the second adaptation".
//     The grammar composes both halves already — `HomeLabel.near` and
//     `.deep` — and `testEveryRoomSaysSomethingElseOnceThePremiseReverses`
//     asserts they are never the same words. What is absent is the *room*
//     reversing with them: the geometry that makes the ceiling's descent read
//     as having held you all along. Same build as (1).
//
//  3. distinction · "her world conditions her room". `HomeWorlds` now exists
//     and `HomeRooms.resolve` stands her in it, but the check asks for one
//     Śakti built into two different worlds and **fingerprinted**, which is the
//     geometric fingerprint of (1). Same build.
//
//  4. legibility · all five checks — no room renders black at the first
//     adaptation, none blows out to white, every room has internal contrast,
//     the second adaptation is still legible, the light visibly changes between
//     them. Needs the 102-room offscreen render and the 4×4 luminance grid
//     `makeStage()` builds against a WebGL context. Blocked twice over: on the
//     rooms (Phase 3), and on the renderer itself — Phase 2.4 spikes SceneKit
//     against `Canvas` and the ruling lands before Phase 3.3 starts. Whichever
//     wins must also offer a headless capture path, or this register can only
//     ever run on the device.
//
//  5. coverage · "every one of the 102 resolves to a built room" and "no Śakti
//     falls through to the shared seat". The *dispatch* is built and asserted
//     here — `HomeRooms.resolve` runs Design's three-step order, and the
//     authored map is keyed by Khaḍgamālā position ({1, 2, 3, 4, 6, 27, 28,
//     102} — errata §3.x, because four of Design's name keys are ghost
//     spellings). What remains is the *rooms*: a mechanism is a named
//     placeholder until Phase 3.3 fills its geometry, so "resolves to a built
//     room" is answered structurally and not yet visually.
//
//  6. canon · the six checks that trace every datum to the 102 cards. The cards
//     are Chat-side documents today (`Claude Chat/homes-shakti-cards-*.md`) and
//     the app reads Airtable. Lights up if and when a card table ships inside
//     the binary — and not before, because asserting against a copy Code typed
//     out would be exactly the invention the register exists to catch.
//
//  7. iconography · all seven checks. `HomeAttribute` now carries the 26 forms,
//     their mounting, their motion and the dissolve past the second adaptation,
//     so the register's *inputs* exist; its questions are asked of the rendered
//     actor, which waits on the renderer with (4).
//
// The two remaining registers — coherence and brief — audit Design's own
// deliverable files (the Axis, the method, the thread) rather than the app, and
// belong to Design's pass, not to this suite.

// MARK: - Ported verbatim: `homes-verify.js`'s MEASURING

/// Design's nine patterns, copied character for character out of
/// `homes-verify.js`. `js` is the literal as that file writes it — kept beside
/// the port so drift is visible on sight — and `pattern` is that literal's body,
/// unaltered.
///
/// Two faithful differences, neither of them a weakening: ICU compiles `\b`
/// against Unicode word characters where JavaScript's is ASCII-only, so a
/// keyword pressed directly against a diacritic ("ṇscore") is a boundary to JS
/// and not to ICU; and ICU carries no per-literal `/i`, so the flag travels in
/// `ignoresCase` exactly as Design set it — eight of the nine carry it, and the
/// percentage pattern has no letters to fold.
///
/// **If a string matches, that is a Ruling-2 violation in the app, not a bug in
/// the regex.** Change the copy; never soften the pattern.
///
/// Module-internal rather than file-private so every suite that composes
/// walker-facing words runs the *same* nine patterns. A second copy would drift
/// from this one, and a drifted detector is worse than none.
enum Measuring {

    struct Pattern {
        /// The JavaScript literal, as `homes-verify.js` writes it.
        let js: String
        /// Its body, for ICU.
        let pattern: String
        /// Design's `/i`.
        let ignoresCase: Bool
        /// A string this pattern exists to catch — the detector's own proof.
        let catches: String
    }

    static let patterns: [Pattern] = [
        Pattern(js: #"/\b\d+\s*(?:of|\/)\s*\d+\b/i"#,
                pattern: #"\b\d+\s*(?:of|\/)\s*\d+\b"#,
                ignoresCase: true, catches: "3 of 9"),              // "3 of 9"
        Pattern(js: #"/\b\d+\s*%/"#,
                pattern: #"\b\d+\s*%"#,
                ignoresCase: false, catches: "62% there"),          // a percentage
        Pattern(js: #"/\bvisit(?:s)?\s*[:=]\s*\d+/i"#,
                pattern: #"\bvisit(?:s)?\s*[:=]\s*\d+"#,
                ignoresCase: true, catches: "visits: 4"),           // a visit count
        Pattern(js: #"/\bstreak\b/i"#,
                pattern: #"\bstreak\b"#,
                ignoresCase: true, catches: "a nine-day streak"),
        Pattern(js: #"/\bprogress\b/i"#,
                pattern: #"\bprogress\b"#,
                ignoresCase: true, catches: "your progress"),
        Pattern(js: #"/\blevel\s*\d/i"#,
                pattern: #"\blevel\s*\d"#,
                ignoresCase: true, catches: "Level 2"),
        Pattern(js: #"/\bscore\b/i"#,
                pattern: #"\bscore\b"#,
                ignoresCase: true, catches: "her score"),
        Pattern(js: #"/\bday\s*\d+\b/i"#,
                pattern: #"\bday\s*\d+\b"#,
                ignoresCase: true, catches: "Day 11"),
        Pattern(js: #"/\b\d+\s*(?:times|visits)\b/i"#,
                pattern: #"\b\d+\s*(?:times|visits)\b"#,
                ignoresCase: true, catches: "felt 7 times"),
    ]

    /// The nine, compiled. A pattern that fails to compile is simply absent,
    /// which `testTheDetectorItselfIsFaithful` turns into a loud failure rather
    /// than a crash at static-initialisation time.
    static let compiled: [(js: String, regex: NSRegularExpression)] = patterns.compactMap {
        guard let re = try? NSRegularExpression(
            pattern: $0.pattern,
            options: $0.ignoresCase ? [.caseInsensitive] : []
        ) else { return nil }
        return (js: $0.js, regex: re)
    }

    /// `homes-verify.js`'s `measuresOutLoud` — every pattern the text trips,
    /// named by its JavaScript literal.
    static func measuresOutLoud(_ text: String) -> [String] {
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        return compiled.compactMap { entry in
            entry.regex.firstMatch(in: text, options: [], range: range) == nil ? nil : entry.js
        }
    }
}

/// One string the instrument can put in front of the practitioner, and where it
/// came from — so a failure names the surface, not only the words.
private struct Utterance {
    let origin: String
    let text: String
}

@MainActor
final class HomesHarnessTests: XCTestCase {

    /// Assert that nothing in `corpus` measures the walker, reporting every
    /// offender at once with its origin and the pattern it tripped.
    private func assertNothingMeasures(_ corpus: [Utterance],
                                       file: StaticString = #filePath,
                                       line: UInt = #line) {
        XCTAssertFalse(corpus.isEmpty, "the detector read nothing", file: file, line: line)

        var offences: [String] = []
        for u in corpus {
            let hits = Measuring.measuresOutLoud(u.text)
            if !hits.isEmpty {
                offences.append("\(u.origin) — \"\(u.text)\" trips \(hits.joined(separator: ", "))")
            }
        }
        XCTAssertTrue(offences.isEmpty,
                      """
                      \(offences.count) string(s) measure the walker out loud — a \
                      Ruling-2 / Law-2 violation. Change the copy; never weaken the pattern.
                      \(offences.joined(separator: "\n"))
                      """,
                      file: file, line: line)
    }

    // MARK: - The detector's own proof

    func testTheDetectorItselfIsFaithful() {
        XCTAssertEqual(Measuring.patterns.count, 9, "Design's MEASURING holds nine patterns")
        XCTAssertEqual(Measuring.compiled.count, Measuring.patterns.count,
                       "every pattern must compile: \(Measuring.patterns.map(\.js))")

        // Each one catches the thing Design wrote it for…
        for p in Measuring.patterns {
            XCTAssertTrue(Measuring.measuresOutLoud(p.catches).contains(p.js),
                          "\(p.js) failed to catch \"\(p.catches)\"")
        }

        // …and a measured phrase is caught wherever it sits in a sentence.
        for measured in ["You have felt her 7 times.",
                         "Day 4 of your practice",
                         "3 of 9 āvaraṇas",
                         "visits = 12",
                         "62% of the way in"] {
            XCTAssertFalse(Measuring.measuresOutLoud(measured).isEmpty,
                           "\"\(measured)\" slipped past the detector")
        }

        // …while the instrument's own vocabulary is not caught by accident.
        for clean in ["She is waiting.",
                      "Kāmākarṣiṇī — first recognition",
                      "Fell inward to the Bindu · Waning Crescent",
                      "Where do you feel her, right now?",
                      "Of the second āvaraṇa — the sixteen petals",
                      "A letter to Mahātripurasundarī",
                      "Ninth Āvaraṇa — crossed",
                      "Dwelt past the first adaptation · Full Moon"] {
            XCTAssertTrue(Measuring.measuresOutLoud(clean).isEmpty,
                          "false positive on \"\(clean)\": \(Measuring.measuresOutLoud(clean))")
        }
    }

    // MARK: - felt · nothing the ledger writes measures the walker

    /// Every string `ActivityLedger` can compose — the recognition row in its
    /// first and its return form, the crossing, the silence, and the letter —
    /// under every name the instrument ships with and every phase of the moon.
    ///
    /// The ledger's `Notes` is excluded on purpose: those are the practitioner's
    /// own words, and she may write whatever she likes in them.
    func testNothingTheLedgerWritesMeasuresTheWalker() {
        var corpus: [Utterance] = []

        // Names as the instrument ships them, plus the empty name the builders
        // substitute for ("A Śakti").
        let names = ShaktiBootstrap.all.map(\.name) + [""]

        for moment in aSynodicMonth {
            let phase = LunarPhaseService.phaseName(at: moment)
            let day = LunarPhaseService.currentDay(at: moment)

            for name in names {
                for isFirst in [true, false] {
                    let a = ActivityLedger.recognition(
                        LedgerMoment(feltAt: moment, lunarDay: day, moonPhase: phase),
                        shaktiName: name, isFirst: isFirst)
                    corpus.append(Utterance(origin: "ActivityLedger.recognition · Activity Name", text: a.name))
                    corpus.append(Utterance(origin: "ActivityLedger.recognition · Detail", text: a.detail))
                }

                let s = ActivityLedger.silence(shaktiRecordId: "recX", name: name,
                                               durationSec: 128.5, at: moment)
                corpus.append(Utterance(origin: "ActivityLedger.silence · Activity Name", text: s.name))
                corpus.append(Utterance(origin: "ActivityLedger.silence · Detail", text: s.detail))

                // The letter row, from the builder `AirtableService.saveLetter`
                // itself calls — never a copy of its words typed out here.
                let letter = ActivityLedger.letterWritten(shaktiName: name)
                corpus.append(Utterance(origin: "ActivityLedger.letterWritten · Activity Name", text: letter.name))
                corpus.append(Utterance(origin: "ActivityLedger.letterWritten · Detail", text: letter.detail))
            }

            // Every ring, and the numbers just outside the nine, so `ordinal`'s
            // "Ring 12" fallback and the blank enclosure form are read too.
            for ring in 0...10 {
                let c = ActivityLedger.crossing(ring: ring, feltAt: moment)
                corpus.append(Utterance(origin: "ActivityLedger.crossing · Activity Name", text: c.name))
                corpus.append(Utterance(origin: "ActivityLedger.crossing · Detail", text: c.detail))
                corpus.append(Utterance(origin: "ActivityLedger.ordinal", text: ActivityLedger.ordinal(ring)))
            }
        }

        // The corpus really did come out of the builders, not out of an empty
        // loop: four rows the ledger is known to write must be in it.
        let read = Set(corpus.map(\.text))
        for expected in ["Kāmākarṣiṇī — first recognition",
                         "Kāmākarṣiṇī — felt again",
                         "A Śakti — silence held",
                         "Ninth Āvaraṇa — crossed",
                         "A letter to a Śakti"] {
            XCTAssertTrue(read.contains(expected), "the corpus never built \"\(expected)\"")
        }
        XCTAssertGreaterThan(corpus.count, 5_000, "the corpus is too thin to be a pass")

        assertNothingMeasures(corpus)
    }

    /// The corpus above is only worth its name if the sky it walks really offers
    /// every phase and the whole round of lunar days.
    func testTheLedgerCorpusCoversTheWholeCycle() {
        let phases = Set(aSynodicMonth.map { LunarPhaseService.phaseName(at: $0) })
        XCTAssertEqual(phases.count, 8, "all eight moon phases must be read: \(phases.sorted())")

        let days = Set(aSynodicMonth.map { LunarPhaseService.currentDay(at: $0) })
        XCTAssertEqual(days.count, 30, "the corpus must walk a whole synodic month")
    }

    // MARK: - felt · the morning summons

    /// `DailySummons` speaks once a day at most, and never in numbers: its title
    /// and body are her name and her quality (`RootView.primeSummons`), with two
    /// wordless fallbacks for a store that has not been read yet.
    func testTheMorningSummonsNeverMeasuresTheWalker() {
        var corpus: [Utterance] = [
            // `DailySummons.reschedule`'s unprimed title, and
            // `RootView.primeSummons`'s body for a Śakti carrying no quality —
            // read from the symbols both of them speak through.
            Utterance(origin: "DailySummons.unprimedTitle", text: DailySummons.unprimedTitle),
            Utterance(origin: "DailySummons.wordlessBody", text: DailySummons.wordlessBody),
        ]

        for s in ShaktiBootstrap.all {
            let kp = s.position + KhadgamalaMap.ringStartOffset(2)
            let quality = s.quality.trimmingCharacters(in: .whitespacesAndNewlines)
            corpus.append(Utterance(origin: "DailySummons · title (kp \(kp))", text: s.name))
            corpus.append(Utterance(origin: "DailySummons · body (kp \(kp))",
                                    text: quality.isEmpty ? DailySummons.wordlessBody : quality))
        }

        assertNothingMeasures(corpus)

        // And the summons counts nothing: one a morning, no sound, no badge.
        XCTAssertEqual(DailySummons.defaultHour, 6)
    }

    // MARK: - felt · the Rite

    /// Every string `RiteContent` hands the Daily Rite's body and footer — her
    /// name, quality, prompt, spoken name, syllable and phonetic — across the
    /// sixteen the instrument ships with and across all three fallback branches
    /// (the āvaraṇa line, the universal invitation, and `ordinal`'s default).
    func testNothingTheRiteRendersMeasuresTheWalker() {
        var corpus: [Utterance] = []

        func read(_ c: RiteContent, _ origin: String) {
            corpus.append(Utterance(origin: "\(origin) · name", text: c.name))
            corpus.append(Utterance(origin: "\(origin) · quality", text: c.quality))
            corpus.append(Utterance(origin: "\(origin) · prompt", text: c.prompt))
            corpus.append(Utterance(origin: "\(origin) · spokenName", text: c.spokenName))
            if let b = c.bija { corpus.append(Utterance(origin: "\(origin) · bīja", text: b)) }
            if let p = c.phonetic { corpus.append(Utterance(origin: "\(origin) · phonetic", text: p)) }
        }

        for s in ShaktiBootstrap.all {
            let kp = s.position + KhadgamalaMap.ringStartOffset(2)
            read(RiteContent(shakti: detached(s, ring: 2, kp: kp)), "RiteContent(kp \(kp))")
        }

        // One of the 86, who carries no quality and no somatic prompt of her
        // own: every fallback branch open, for every ring — and for a ring
        // outside the nine, so `ordinal`'s "\(n)th" is read as well.
        for ring in 1...10 {
            let bare = blankShakti(ring: ring)
            read(RiteContent(shakti: bare, avaranaSubtitle: "The Sixteen Petals"),
                 "RiteContent(bare, ring \(ring), subtitle)")
            read(RiteContent(shakti: bare), "RiteContent(bare, ring \(ring), no subtitle)")
            corpus.append(Utterance(origin: "RiteContent.ordinal(\(ring))",
                                    text: RiteContent.ordinal(ring)))
        }

        assertNothingMeasures(corpus)

        // The branches above are only read if these fallbacks are really there.
        let bare = blankShakti(ring: 2)
        XCTAssertEqual(RiteContent(shakti: bare).prompt, "Where do you feel her, right now?")
        XCTAssertEqual(RiteContent(shakti: bare).quality, "")
        XCTAssertEqual(RiteContent(shakti: bare, avaranaSubtitle: "The Sixteen Petals").quality,
                       "Of the second āvaraṇa — the sixteen petals")
        XCTAssertEqual(RiteContent.ordinal(10), "10th")
        XCTAssertNil(RiteContent(shakti: bare).bija)
    }

    /// The instrument's own seed data — every word of it that can reach a
    /// screen — read through the detector directly.
    func testTheShippedShaktiDataNeverMeasuresTheWalker() {
        var corpus: [Utterance] = []
        for s in ShaktiBootstrap.all {
            let origin = "ShaktiBootstrap[\(s.position)]"
            corpus.append(contentsOf: [
                Utterance(origin: "\(origin).name", text: s.name),
                Utterance(origin: "\(origin).shortName", text: s.shortName),
                Utterance(origin: "\(origin).phonetic", text: s.phonetic),
                Utterance(origin: "\(origin).quality", text: s.quality),
                Utterance(origin: "\(origin).qualityDescription", text: s.qualityDescription),
                Utterance(origin: "\(origin).somatic", text: s.somatic),
                Utterance(origin: "\(origin).somaticPoetry", text: s.somaticPoetry),
                Utterance(origin: "\(origin).bija", text: s.bija),
                Utterance(origin: "\(origin).bodilyLocation", text: s.bodilyLocation),
                Utterance(origin: "\(origin).tattva", text: s.tattva),
                Utterance(origin: "\(origin).recognitionPhrase", text: s.recognitionPhrase),
            ])
            if let note = s.fieldNote {
                corpus.append(Utterance(origin: "\(origin).fieldNote", text: note))
            }
        }

        // The nine enclosure forms the threshold and the ledger both speak.
        for ring in 1...9 {
            corpus.append(Utterance(origin: "Avarana.enclosureForm(\(ring))",
                                    text: Avarana.enclosureForm(forRing: ring)))
        }

        XCTAssertEqual(ShaktiBootstrap.all.count, 16, "the sixteen Karṣiṇīs ship in the binary")
        XCTAssertGreaterThanOrEqual(corpus.count, 16 * 11 + 9,
                                    "every field of every seeded Śakti must be read")
        assertNothingMeasures(corpus)
    }

    // MARK: - promise · the ceremony compresses on return but is never skipped

    /// `homes-verify.js`: a first visit runs whole; a return softens; and the
    /// softening never falls to nothing, because a compression of zero is her
    /// name arriving with no writing at all.
    func testTheCeremonyCompressesOnReturnAndIsNeverSkipped() throws {
        let store = try makeStore()
        let kp = 29

        // A first visit is exactly the whole ceremony.
        XCTAssertEqual(store.compression(for: kp), 1, accuracy: 1e-12)

        // Design's probe: nine thirty-second visits.
        for _ in 0..<9 { store.record(khadgamalaPosition: kp, dwell: 30) }
        let later = store.compression(for: kp)

        XCTAssertLessThan(later, 1, "a return must soften the ceremony")
        XCTAssertGreaterThanOrEqual(later, HomeMemory.compressionFloor,
                                    "compressed past the floor is skipping, not softening")
        XCTAssertGreaterThan(later, 0.3, "Design's own bound: below 0.3 is skipping")

        // The floor is reached from the third return onward, and never moves.
        let walk = try makeStore()
        for (i, want) in [0.68, 0.4624, HomeMemory.compressionFloor].enumerated() {
            walk.record(khadgamalaPosition: kp, dwell: 30)
            XCTAssertEqual(walk.compression(for: kp), want, accuracy: 1e-12, "return \(i + 1)")
        }
        for i in 4...24 {
            walk.record(khadgamalaPosition: kp, dwell: 30)
            XCTAssertEqual(walk.compression(for: kp), HomeMemory.compressionFloor,
                           accuracy: 1e-12, "the floor must hold at return \(i)")
        }
    }

    // MARK: - promise · the head start comes from dwell, not from visit count

    /// It must not be gameable by entering and leaving. Design's probe: six
    /// visits of two-tenths of a second against one two-hundred-second stay.
    func testTheHeadStartCannotBeGamedByReEntering() throws {
        let kp = 44

        let gamed = try makeStore()
        for _ in 0..<6 { gamed.record(khadgamalaPosition: kp, dwell: 0.2) }
        let cheap = gamed.headStart(for: kp)

        let honest = try makeStore()
        honest.record(khadgamalaPosition: kp, dwell: 200)
        let earned = honest.headStart(for: kp)

        XCTAssertGreaterThan(earned, cheap * 4,
                             "gamed: \(cheap) from six glances against \(earned) from one stay")
        XCTAssertEqual(cheap, 0, accuracy: 1e-12,
                       "1.2 s of lifetime dwell is a glance, not a relationship")
        XCTAssertEqual(earned, 110, accuracy: 1e-12, "200 × 0.55")

        // Six visits *were* counted — the room knows her, and still opens at
        // its beginning, because being known is not having stood there.
        let remembered = try XCTUnwrap(gamed.existingMemory(for: kp))
        XCTAssertEqual(remembered.visits, 6)
        XCTAssertLessThan(gamed.compression(for: kp), 1, "the ceremony did soften")
    }

    // MARK: - promise · the second adaptation is reachable only through relationship

    /// Cold, the room opens at its beginning, and the hold's end at 227 seconds
    /// is out of reach inside one visit. Four two-and-a-half-minute stays later
    /// it opens at least two hundred seconds in — which is how the deeper layer
    /// becomes reachable at all.
    func testTheSecondAdaptationIsReachableOnlyThroughRelationship() throws {
        let store = try makeStore()
        let kp = 4

        let cold = store.headStart(for: kp)
        XCTAssertEqual(cold, 0, accuracy: 1e-12, "a room never stood in opens at its beginning")

        for _ in 0..<4 { store.record(khadgamalaPosition: kp, dwell: 150) }
        let warm = store.headStart(for: kp)

        XCTAssertGreaterThanOrEqual(warm, 200,
                                    "cold \(cold), warm \(warm) — the hold ends at \(HomeMemory.holdEnd)")
        XCTAssertLessThan(warm, HomeMemory.holdEnd,
                          "the head start must stop short of the hold's end, so even the "
                          + "most known room still crosses the first adaptation inside the visit")

        // And why it matters: 226 seconds on a first visit stop at the first
        // adaptation; the same 226 seconds in a room already stood in for ten
        // minutes reach the second.
        let firstVisit = HomeMemory(khadgamalaPosition: kp)
        firstVisit.record(dwell: 226)
        XCTAssertEqual(firstVisit.deepestAdaptation, 1)

        let knownRoom = HomeMemory(khadgamalaPosition: kp, accumulatedDwell: 600)
        knownRoom.record(dwell: 226)
        XCTAssertEqual(knownRoom.deepestAdaptation, 2,
                       "a return must reach what a first visit cannot")
    }

    // MARK: - promise · the fifth is withheld outside the ninth world

    func testTheFifthIsWithheldOutsideTheNinthWorld() throws {
        let store = try makeStore()
        let kp = 70

        XCTAssertEqual(store.grantsFifth(for: kp, ring: 3, elapsed: 30), 0, accuracy: 1e-12,
                       "ring 3, thirty seconds in, must grant nothing")
        XCTAssertEqual(store.grantsFifth(for: kp, ring: 9, elapsed: 30), 1, accuracy: 1e-12,
                       "the ninth world grants it outright")

        // And asking cost the store nothing.
        XCTAssertNil(store.existingMemory(for: kp))
    }

    // MARK: - coverage · the known collisions resolve by position, not by name

    /// `homes-cards.js`: *"Her POSITION is authoritative, because names collide
    /// across rings — Kāmeśvarī is both a Ring 7 Vāsinī and the Ring 8
    /// Icchā-śakti, and the Ring 4 Devīs repeat Ring 1 Mudrā names."*
    ///
    /// `KhadgamalaMap` cannot be fooled by a name because it is never given one:
    /// it takes a position and nothing else, and every position belongs to
    /// exactly one ring.
    func testKhadgamalaMapResolvesIdentityByPositionAlone() {
        // The two seats a Kāmeśvarī could occupy are in different rings.
        XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: 93), 7)
        XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: 99), 8)
        XCTAssertNotEqual(KhadgamalaMap.ringNumber(forKhadgamala: 93),
                          KhadgamalaMap.ringNumber(forKhadgamala: 99))

        // Every one of the 102 sits in exactly one ring, and the nine spans
        // partition them with no overlap and no gap — so a position can never
        // be ambiguous, whatever she is called.
        var seats: [Int: [Int]] = [:]
        for kp in 1...KhadgamalaMap.total {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            XCTAssertTrue((1...9).contains(ring), "kp \(kp)")
            seats[ring, default: []].append(kp)
        }
        XCTAssertEqual(seats.keys.sorted(), Array(1...9))
        XCTAssertEqual((1...9).map { seats[$0]?.count ?? 0 }, [28, 16, 8, 14, 10, 10, 12, 3, 1],
                       "the roster totals 102 at 28·16·8·14·10·10·12·3·1")

        // The per-ring index repeats across rings and so is never identity:
        // three different Śaktis are each "the first of her ring".
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 1), 1)
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 29), 1)
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 87), 1)
    }

    /// The shipped keyed paths — her Shakti row, her letter, her recognition
    /// log, what her room remembers — each key on Khaḍgamālā position. Two
    /// Śaktis bearing one name in two rings must stay two.
    func testTheShippedPathsKeepTwoSameNamedSistersApart() throws {
        let container = try ModelContainer(
            for: Schema(BinduSchemaV2.models, version: BinduSchemaV2.versionIdentifier),
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)

        // One name, two rings — Design's own collision.
        let inSeven = blankShakti(ring: 7, kp: 93, name: "Kāmeśvarī")
        let inEight = blankShakti(ring: 8, kp: 99, name: "Kāmeśvarī")
        inSeven.airtableRecordId = "recSeven"
        inEight.airtableRecordId = "recEight"
        context.insert(inSeven)
        context.insert(inEight)
        try context.save()

        XCTAssertEqual(inSeven.name, inEight.name, "the collision must actually be present")
        XCTAssertNotEqual(inSeven.khadgamalaPosition, inEight.khadgamalaPosition)

        // Her letter is keyed by position, so writing to one leaves the other
        // unwritten — the Ring-2-era key would have folded both into one row.
        XCTAssertEqual(inSeven.letterKey, 93)
        XCTAssertEqual(inEight.letterKey, 99)
        let letters = LetterStore(context: context)
        letters.save(letters.letter(for: inSeven.letterKey), body: "for the Vāsinī")
        XCTAssertEqual(letters.existingLetter(for: 93)?.body, "for the Vāsinī")
        XCTAssertNil(letters.existingLetter(for: 99),
                     "her sister's letter must stay unwritten — and never seeded")

        // Her recognition log, the same.
        let log = RecognitionLogStore(context: context)
        log.record(khadgamalaPosition: 93, ringNumber: 7)
        XCTAssertEqual(log.entries(forKhadgamala: 93).count, 1)
        XCTAssertEqual(log.entries(forKhadgamala: 93).first?.ringNumber, 7)
        XCTAssertEqual(log.entries(forKhadgamala: 99).count, 0)

        // What her room remembers, the same.
        let rooms = HomeMemoryStore(context: context)
        rooms.record(khadgamalaPosition: 93, dwell: 240)
        XCTAssertEqual(rooms.existingMemory(for: 93)?.visits, 1)
        XCTAssertNil(rooms.existingMemory(for: 99),
                     "a sister's room must not remember a visit she never received")

        // A pre-sync Ring-2 bootstrap row — the one case with no Khaḍgamālā
        // position yet — still resolves to a global key, never to a bare 1…16.
        let unreconciled = blankShakti(ring: 2, kp: nil, name: "Kāmākarṣiṇī")
        XCTAssertEqual(unreconciled.letterKey, 29)
    }

    /// The one place the instrument speaks a name to the server —
    /// `ActivityLedger.moments(shaktiName:)` narrows App Activity by her name in
    /// the link's primary field — is the one place a name *would* be a collision
    /// if it were trusted. It is not: the record-id match stays client-side
    /// (`AirtableService.fetchRecognitions`) and `rowMatches` demands it.
    func testHerMomentsNarrowsByNameButNeverIdentifiesByIt() {
        let formula = ActivityLedger.moments(shaktiName: "Kāmeśvarī")
        XCTAssertTrue(formula.contains("Kāmeśvarī"), "the formula narrows by name…")
        XCTAssertFalse(formula.contains("recSeven"),
                       "…and carries no record id: the identity match is the caller's")

        let felt = instant(2026, 9, 20, 14, 30, 0)
        let hers = ActivityLedger.Row(
            id: "recRowA",
            fields: .init(activityType: ActivityLedger.ActivityType.shaktiRecognized,
                          activityName: "Kāmeśvarī — first recognition",
                          feltAt: RecognitionDedup.writtenFeltAt(felt),
                          linkToMandala: ["recSeven"]))
        let sisters = ActivityLedger.Row(
            id: "recRowB",
            fields: .init(activityType: ActivityLedger.ActivityType.shaktiRecognized,
                          activityName: "Kāmeśvarī — first recognition",
                          feltAt: RecognitionDedup.writtenFeltAt(felt),
                          linkToMandala: ["recEight"]))

        // Identical words, identical second — and still two different Śaktis.
        XCTAssertEqual(hers.fields.activityName, sisters.fields.activityName)
        XCTAssertTrue(ActivityLedger.rowMatches(hers, linkRecordId: "recSeven", feltAt: felt))
        XCTAssertFalse(ActivityLedger.rowMatches(sisters, linkRecordId: "recSeven", feltAt: felt),
                       "a same-named sister's row must never match her")

        // And the restore resolves each row through the record → position map,
        // never through the words inside it.
        let restored = ActivityLedger.recognitionEntries(
            from: [hers, sisters],
            byRecord: ["recSeven": (kp: 93, ring: 7), "recEight": (kp: 99, ring: 8)])
        XCTAssertEqual(restored.count, 2)
        XCTAssertEqual(Set(restored.map { $0.kp }), [93, 99])
        XCTAssertEqual(Set(restored.map { $0.ring }), [7, 8])

        // A row whose link is not a known Śakti is skipped, never guessed at by
        // name — even when the name is right there in the row.
        let orphaned = ActivityLedger.recognitionEntries(
            from: [hers], byRecord: ["recEight": (kp: 99, ring: 8)])
        XCTAssertTrue(orphaned.isEmpty, "an unmappable link must be dropped, not name-matched")
    }

    /// The ledger writes her *name* for a human to read and her *record id* for
    /// the instrument to read, and never confuses the two.
    func testTheLedgerCarriesIdentityInTheLinkNotInTheWords() {
        let felt = instant(2026, 9, 20, 6, 0, 0)
        let a = ActivityLedger.recognition(
            LedgerMoment(shaktiRecordId: "recSeven", feltAt: felt),
            shaktiName: "Kāmeśvarī", isFirst: true)
        let b = ActivityLedger.recognition(
            LedgerMoment(shaktiRecordId: "recEight", feltAt: felt),
            shaktiName: "Kāmeśvarī", isFirst: true)

        XCTAssertEqual(a.name, b.name, "two sisters may be written with one name…")
        XCTAssertNotEqual(a.linkRecordId, b.linkRecordId, "…and are still two rows, two links")

        let fields = ActivityLedger.fields(for: a, timeZone: TimeZone(identifier: "UTC")!)
        XCTAssertEqual(fields[ActivityLedger.Field.linkToMandala] as? [String], ["recSeven"])
    }

    // MARK: - Fixtures

    private func makeStore() throws -> HomeMemoryStore {
        let container = try ModelContainer(
            for: HomeMemory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return HomeMemoryStore(context: ModelContext(container))
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: - coverage · every authored room is actually reached
    //
    // The check Design's own pass does not have, and the one that matters most.
    //
    // `homes-chambers.js` keys its eight authored mechanisms by Śakti **name**,
    // and four of those eight keys are ghost spellings that match no card:
    // `Animā` against the card's `Aṇimā`, `Vaśitā` against `Vaśitva`,
    // `Sarvayoni` against `Sarva-Yoni`, `Sarvatrikhaṇḍā` against
    // `Sarva-Trikhaṇḍā`. In Design's shipped Axis those four rooms are never
    // reached — the lookup misses and the walker silently gets the grammar
    // instead — and nothing in `homes-verify.js` can see it, because the only
    // coverage question it asks is whether *some* room was built.
    //
    // Keyed by `khadgamalaPosition`, as law 1 requires, the miss cannot happen:
    // a position is a number, and a number cannot be misspelled. These tests
    // are what makes that claim checkable rather than merely stated.
    // ─────────────────────────────────────────────────────────────────────────

    func testTheAuthoredMapIsKeyedByPositionAndHoldsDesignsEight() {
        XCTAssertEqual(Set(HomeRooms.authored.keys), [1, 2, 3, 4, 6, 27, 28, 102],
                       "the authored positions are the errata's eight (§3.x)")
        XCTAssertEqual(Set(HomeRooms.authored.values).count, HomeRooms.authored.count,
                       "each of the eight mechanisms is authored for exactly one Śakti")
        XCTAssertEqual(Set(HomeRooms.authored.values),
                       Set(HomeAuthoredMechanism.allCases),
                       "every mechanism Design wrote has a position, and none is orphaned")
    }

    func testEveryAuthoredPositionReachesItsAuthoredMechanism() {
        let rooms = Dictionary(uniqueKeysWithValues:
            HomesCorpus.resolvedRooms().map { ($0.row.position, $0) })

        for (position, expected) in HomeRooms.authored.sorted(by: { $0.key < $1.key }) {
            guard let entry = rooms[position] else {
                XCTFail("kp \(position) resolved to no room at all")
                continue
            }
            guard case .authored(let reached) = entry.room.kind else {
                XCTFail("""
                        kp \(position) fell through to \(entry.room.kind) instead of reaching \
                        its authored \(expected.designFunction). This is exactly Design's \
                        by-name miss, and the reason the map is keyed by position.
                        """)
                continue
            }
            XCTAssertEqual(reached, expected,
                           "kp \(position) reached \(reached.designFunction), not \(expected.designFunction)")
            XCTAssertTrue(entry.room.isBuilt, "an authored room is a room of her own")
            XCTAssertNil(entry.room.label,
                         "an authored room writes its own words in Phase 3.3; the grammar does not speak for her")
        }
    }

    /// The dispatch hands each authored position **its own** placeholder, and
    /// the placeholder agrees about which of the eight it is. Phase 3.3 fills
    /// these in; what is proven now is that it will fill the right one.
    func testTheDispatchHandsEachAuthoredRoomItsOwnPlaceholder() {
        for mechanism in HomeAuthoredMechanism.allCases {
            XCTAssertEqual(mechanism.placeholder.kind, mechanism,
                           "\(mechanism.rawValue)'s placeholder answers to \(mechanism.placeholder.kind)")
        }
        let placeholders = HomeAuthoredMechanism.allCases.map { String(describing: $0.placeholder) }
        XCTAssertEqual(Set(placeholders).count, placeholders.count,
                       "no two mechanisms share a placeholder type")
    }

    /// Nobody else is authored. A ninth room appearing here would mean a
    /// mechanism had been reached by a Śakti Design never wrote one for.
    func testOnlyTheEightAreAuthoredAndEveryoneElseIsResolvedByTheOrder() {
        var authored = 0, grammar = 0, seat = 0
        for entry in HomesCorpus.resolvedRooms() {
            switch entry.room.kind {
            case .authored: authored += 1
            case .grammar:  grammar += 1
            case .seat:     seat += 1
            }
        }
        XCTAssertEqual(authored, 8)
        XCTAssertEqual(grammar, KhadgamalaMap.total - 8,
                       "the other 94 are spoken for by the grammar")
        XCTAssertEqual(seat, 0,
                       "no Śakti falls through to the shared seat once the order is whole")
    }

    /// The order is an order: authored first, then the grammar, then the seat.
    func testTheOrderFallsThroughInDesignsSequence() {
        // 2 · not authored, and in a ring the grammar speaks for.
        let grammared = HomeRooms.resolve(position: 30, ring: 2, tattva: "Vāyu (Air)",
                                          quality: "She who attracts Touch",
                                          bodilyLocation: "skin")
        guard case .grammar(let reading)? = grammared?.kind else {
            return XCTFail("kp 30 should be the grammar's")
        }
        XCTAssertEqual(reading.archetype, .crossed)

        // 3 · a world the grammar declines to speak for, and no authored room:
        // her seat, gem-lit. The Bindu is the only ninth-world Śakti and she is
        // authored, so this is the floor rather than a live case.
        let seated = HomeRooms.resolve(position: 50, ring: 9, tattva: "Para-Bindu",
                                       quality: "She who is", bodilyLocation: "crown")
        XCTAssertEqual(seated?.kind, HomeRoomKind.seat)
        XCTAssertEqual(seated?.isBuilt, false)

        // …and the attribute joins whichever room resulted. Never a fourth branch.
        for room in [grammared, seated].compactMap({ $0 }) {
            XCTAssertNotNil(room.attribute,
                            "kp \(room.position): her attribute acts in whatever room she has")
        }
        XCTAssertNotNil(HomeRooms.resolve(position: 4, ring: 1, tattva: "Pṛthvī — earth",
                                          quality: "Weightedness",
                                          bodilyLocation: "Mūlādhāra / sit-bones / soles")?.attribute,
                        "an authored room's attribute joins it too")
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: - distinction · language uniqueness
    //
    // Design: *"no two Śaktis in one ring speak the same near words"*, and every
    // room must have something else to say once its premise reverses. Asked of
    // all 102 — the sixteen Karṣiṇīs as themselves, the other eighty-six over
    // real tattva vocabulary, because their rows live in Airtable and a bundled
    // card table would be the ghost roster (see `HomesCorpus`).
    // ─────────────────────────────────────────────────────────────────────────

    func testNoTwoSistersInARingComposeTheSameNearWords() {
        var byRing: [Int: [(String, HomesCorpus.Row)]] = [:]
        for entry in HomesCorpus.resolvedRooms() {
            guard let label = entry.room.label else { continue }
            byRing[entry.room.ring, default: []].append((label.near, entry.row))
        }
        XCTAssertFalse(byRing.isEmpty, "the check read no rooms")

        var collisions: [String] = []
        for (ring, spoken) in byRing.sorted(by: { $0.key < $1.key }) {
            var seen: [String: HomesCorpus.Row] = [:]
            for (words, row) in spoken {
                if let first = seen[words] {
                    collisions.append("""
                        ring \(ring): kp \(first.position) (\(first.provenance)) and \
                        kp \(row.position) (\(row.provenance)) both say "\(words)"
                        """)
                } else {
                    seen[words] = row
                }
            }
        }
        XCTAssertTrue(collisions.isEmpty,
                      """
                      \(collisions.count) pair(s) of sisters speak alike. The grammar does not \
                      distinguish them, and Phase 3 would build rooms that blur. Fix the \
                      grammar; never weaken the check.
                      \(collisions.joined(separator: "\n"))
                      """)
    }

    func testEveryRoomSaysSomethingElseOnceThePremiseReverses() {
        var same: [String] = []
        for entry in HomesCorpus.resolvedRooms() {
            guard let label = entry.room.label else { continue }
            if label.near == label.deep {
                same.append("kp \(entry.row.position) (\(entry.row.provenance)): \"\(label.near)\"")
            }
            XCTAssertFalse(label.near.isEmpty, "kp \(entry.row.position) has no near words")
            XCTAssertFalse(label.deep.isEmpty, "kp \(entry.row.position) has no deep words")
        }
        XCTAssertTrue(same.isEmpty,
                      """
                      \(same.count) room(s) say the same thing at the second adaptation as at \
                      the first — the premise never reverses.
                      \(same.joined(separator: "\n"))
                      """)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: - distinction · sister divergence, at the level of logic
    //
    // Design's check is geometric: fingerprint two chambers, and demand that
    // more than a tenth of their components differ. The geometry waits on the
    // renderer ruling — but the *thing the geometry is made of* does not, and
    // that is what this asks.
    //
    // `divergence` is Design's own, ported exactly: the fraction of fingerprint
    // components that differ. What is fingerprinted here is what the grammar
    // **produces** rather than what a renderer draws — where her displacement
    // kernel puts a thing at eight moments of a stay, where her attribute is
    // mounted and how it acts at those same moments, her altitude, her mode,
    // and the shape that acts. Physics and phase are folded into the motion
    // samples rather than counted once each, because that is how much of a room
    // they actually drive.
    //
    // Nineteen components, so the tenth bites at two of them: a pair separated
    // by a single number is **not** separated enough, and the test says so.
    // ─────────────────────────────────────────────────────────────────────────

    func testAdjacentSistersDivergeAcrossTheGrammarThatDrivesTheirRooms() {
        var byRing: [Int: [(HomesCorpus.Row, [String])]] = [:]
        for entry in HomesCorpus.resolvedRooms() {
            guard case .grammar(let reading) = entry.room.kind else { continue }
            byRing[entry.room.ring, default: []]
                .append((entry.row, HomeLogicFingerprint.of(room: entry.room, reading: reading)))
        }
        XCTAssertFalse(byRing.isEmpty, "the check read no rooms")

        var blurred: [String] = []
        var margins: [String] = []
        for (ring, rooms) in byRing.sorted(by: { $0.key < $1.key }) {
            let ordered = rooms.sorted { $0.0.position < $1.0.position }
            // Seeded above 1 on purpose: a pair whose every component differs
            // diverges at exactly 1.0, and seeding at 1.0 would report no pair
            // at all for a ring that separates its sisters perfectly.
            var closest = (pair: "—", divergence: Double.infinity)
            for (a, b) in zip(ordered, ordered.dropFirst()) {
                let d = HomeLogicFingerprint.divergence(a.1, b.1)
                let pair = "kp \(a.0.position) (\(a.0.provenance)) ↔ " +
                           "kp \(b.0.position) (\(b.0.provenance))"
                if d < closest.divergence { closest = (pair, d) }
                if d <= HomeLogicFingerprint.threshold {
                    blurred.append("ring \(ring): \(pair) — divergence \(String(format: "%.3f", d))")
                }
            }
            margins.append("  ring \(ring) · closest \(closest.pair) at "
                           + String(format: "%.3f", closest.divergence))
        }
        XCTAssertTrue(blurred.isEmpty,
                      """
                      \(blurred.count) adjacent pair(s) diverge by a tenth or less. The grammar \
                      does not actually distinguish them, and Phase 3 would build rooms that \
                      blur. Fix the grammar or the port; never lower the threshold.
                      \(blurred.joined(separator: "\n"))
                      """)
        // Not an assertion — the margin, ring by ring, printed so a slow drift
        // toward the threshold is visible in the log before it is a failure.
        print("[sister divergence] closest adjacent pair in each ring, threshold "
              + String(format: "%.3f", HomeLogicFingerprint.threshold) + "\n"
              + margins.joined(separator: "\n"))
    }

    /// The threshold has teeth. A pair that differs in exactly one of nineteen
    /// components must **fail**, or the check above is asserting nothing.
    func testTheDivergenceThresholdBites() {
        let a = (0..<19).map { "component \($0)" }
        XCTAssertEqual(HomeLogicFingerprint.divergence(a, a), 0,
                       "a room cannot diverge from itself")

        var oneApart = a; oneApart[7] = "different"
        let single = HomeLogicFingerprint.divergence(a, oneApart)
        XCTAssertLessThanOrEqual(single, HomeLogicFingerprint.threshold,
                                 "one component in nineteen is not a room of her own")

        var twoApart = oneApart; twoApart[11] = "different too"
        XCTAssertGreaterThan(HomeLogicFingerprint.divergence(a, twoApart),
                             HomeLogicFingerprint.threshold,
                             "two in nineteen clears the tenth — this is the smallest pass")

        XCTAssertEqual(HomeLogicFingerprint.divergence([], []), 0,
                       "Design's own guard: no components, no divergence")
    }

    /// The fingerprint reads the whole room, not one corner of it. If a
    /// component ever stopped varying across the 102, the divergence above
    /// would quietly get easier to pass.
    func testEveryFingerprintComponentDistinguishesSomebody() {
        let prints = HomesCorpus.resolvedRooms().compactMap { entry -> [String]? in
            guard case .grammar(let reading) = entry.room.kind else { return nil }
            return HomeLogicFingerprint.of(room: entry.room, reading: reading)
        }
        XCTAssertEqual(prints.count, KhadgamalaMap.total - 8)
        for print_ in prints {
            XCTAssertEqual(print_.count, HomeLogicFingerprint.componentCount)
        }
        for index in 0..<HomeLogicFingerprint.componentCount {
            let values = Set(prints.map { $0[index] })
            XCTAssertGreaterThan(values.count, 1,
                                 "fingerprint component \(index) is the same in every room — it "
                                 + "distinguishes nobody and should not be counted")
        }
    }
}



// MARK: - File-scope fixtures

/// The queued recognition's shape, as `AirtableService.PendingRecognition`
/// carries it into `ActivityLedger.recognition`.
private struct LedgerMoment: RecognitionMoment {
    var shaktiRecordId = "recShakti"
    var note: String? = nil
    var source = ActivityLedger.GestureSource.mandala
    var feltAt: Date
    var lunarDay = 1
    var moonPhase = "New Moon"
}

private func instant(_ y: Int, _ mo: Int, _ d: Int, _ h: Int, _ mi: Int, _ s: Int) -> Date {
    var c = Calendar(identifier: .gregorian)
    c.timeZone = TimeZone(secondsFromGMT: 0)!
    return c.date(from: DateComponents(year: y, month: mo, day: d,
                                       hour: h, minute: mi, second: s))!
}

/// Thirty moments, one a day through a whole synodic month, so every moon phase
/// and every lunar day is read out of the real service rather than named here.
private let aSynodicMonth: [Date] = (0..<30).map {
    instant(2026, 1, 1, 9, 0, 0).addingTimeInterval(Double($0) * 86_400)
}

/// A private copy of a shipped Śakti, so no test ever mutates the seed array
/// `ShaktiBootstrap.seedIfNeeded` inserts.
private func detached(_ s: Shakti, ring: Int, kp: Int) -> Shakti {
    let c = Shakti(position: s.position, name: s.name, shortName: s.shortName,
                   phonetic: s.phonetic, quality: s.quality,
                   qualityDescription: s.qualityDescription, somatic: s.somatic,
                   somaticPoetry: s.somaticPoetry, bija: s.bija,
                   bodilyLocation: s.bodilyLocation, tattva: s.tattva,
                   recognitionPhrase: s.recognitionPhrase,
                   cluster: s.cluster, status: s.status)
    c.ringNumber = ring
    c.khadgamalaPosition = kp
    return c
}

/// One of the 86 as she arrives before Airtable fills her in: a name, a ring,
/// and nothing else — every fallback branch open.
private func blankShakti(ring: Int, kp: Int? = nil, name: String = "Anonymous") -> Shakti {
    let s = Shakti(position: 1, name: name, shortName: "", phonetic: "",
                   quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                   bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                   cluster: .inner, status: .mapped)
    s.ringNumber = ring
    s.khadgamalaPosition = kp
    return s
}


// MARK: - The logic-level fingerprint
//
// Design's `fingerprint(chamber, t)` walks a built room's node graph and writes
// each object's position, scale and opacity to two decimal places; its
// `divergence(a, b)` is then the fraction of those components that differ. The
// graph waits on the renderer ruling. What does not wait is the layer beneath
// it — the displacement kernel, the attribute's motion and mount, the altitude,
// the mode and the shape — which is what a renderer would be drawing.
//
// So this is Design's method applied one level down: the same two-decimal
// quantisation, the same fraction-differing divergence, the same tenth.
private enum HomeLogicFingerprint {

    /// Design's `> 0.1`. A pair at or below it is not two rooms.
    static let threshold: Double = 0.1

    /// Eight moments of one stay, in chamber seconds: arrival, the eye still
    /// settling, the first adaptation, past it, the far side of the settling
    /// ramp, and three points through the second adaptation and beyond.
    static let sampleTimes: [TimeInterval] = [0, 8, 20, 45, 62, 120, 200, 300]

    /// Eight motion samples, eight attribute samples, and three standing facts.
    static let componentCount = 19

    private static func f(_ x: Double) -> String { String(format: "%.2f", x) }

    /// What the grammar and the attribute produce for this room, quantised.
    static func of(room: HomeRoom, reading: HomeGrammar.Reading) -> [String] {
        var out: [String] = []
        out.reserveCapacity(componentCount)

        // Where her room puts a thing, moment by moment. Physics and phase are
        // folded in here rather than counted once, because this is the share of
        // the room they drive.
        for t in sampleTimes {
            let d = reading.displacement(time: t, amplitude: 1)
            out.append("m|" + f(d.x) + "," + f(d.y) + "," + f(d.z))
        }

        // Where her attribute is held, and what it is doing there.
        for t in sampleTimes {
            guard let actor = room.attribute else {
                out.append("a|-")
                continue
            }
            let s = actor.state(atChamberTime: t)
            out.append("a|" + f(s.body.x) + "," + f(s.body.y) + "," + f(s.body.z)
                       + "|" + f(s.body.scaleX) + "|" + f(s.body.opacity)
                       + "|" + f(s.mount.y) + "," + f(s.mount.z) + "|" + f(s.mount.scale))
        }

        out.append("alt|" + f(room.bodyAltitude))
        out.append("mode|" + (reading.soundingMode.map(String.init)
                              ?? reading.matrkaLetterCount.map(String.init)
                              ?? reading.sourcingCorner.map(String.init)
                              ?? "-"))
        out.append("form|" + (room.attribute?.form.rawValue ?? "-"))
        return out
    }

    /// `homes-verify.js`'s `divergence`, ported exactly: the fraction of
    /// components that differ, over the shorter of the two.
    static func divergence(_ a: [String], _ b: [String]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var d = 0
        for i in 0..<n where a[i] != b[i] { d += 1 }
        return Double(d) / Double(n)
    }
}
