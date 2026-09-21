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
//  1. distinction · "adjacent sisters diverge geometrically by more than a
//     tenth". Needs `HomeChambers.build(world:shakti:)` returning a node graph
//     whose children carry position, scale and opacity, plus a Swift port of
//     `fingerprint(chamber, t)` and `divergence(a, b)`. Lights up when Ring 2's
//     sixteen rooms are built (Phase 3.4), then widens ring by ring through 3.5
//     and 3.6. This is the check that carries Ruling 10: the Gate's two rooms
//     are authored by hand, and the grammar is proven by sister divergence
//     across the other rooms instead.
//
//  2. distinction · "no two Śaktis in one ring speak the same near words".
//     Needs each chamber's `label` at the first adaptation (t = 20), compared
//     within a ring. Same build as (1).
//
//  3. distinction · "every room reverses its premise at the second adaptation".
//     Needs a chamber's `label` at t = 20 and again at t = 300. Same build.
//
//  4. distinction · "her world conditions her room". Needs one Śakti built into
//     two different worlds and fingerprinted. Lights up with `HomeWorlds`
//     (Phase 3.2).
//
//  5. legibility · all five checks — no room renders black at the first
//     adaptation, none blows out to white, every room has internal contrast,
//     the second adaptation is still legible, the light visibly changes between
//     them. Needs the 102-room offscreen render and the 4×4 luminance grid
//     `makeStage()` builds against a WebGL context. Blocked twice over: on the
//     rooms (Phase 3), and on the renderer itself — Phase 2.4 spikes SceneKit
//     against `Canvas` and Ashrey rules it before Phase 3 starts. Whichever
//     wins must also offer a headless capture path, or this register can only
//     ever run on the device.
//
//  6. coverage · "every one of the 102 resolves to a built room" and "no Śakti
//     falls through to the shared seat". Needs the room set plus Design's
//     authored `BY_NAME` map ported by Khaḍgamālā position ({1, 2, 3, 4, 6, 27,
//     28, 102} — errata §3.x, because four of Design's name keys are ghost
//     spellings). Lights up progressively: Phase 3.3 (the Gate), 3.4 (Ring 2),
//     3.5 (Ring 1), 3.6 (Rings 3–9 — 58 rooms, not 74; errata §3.x).
//
//  7. canon · the six checks that trace every datum to the 102 cards. The cards
//     are Chat-side documents today (`Claude Chat/homes-shakti-cards-*.md`) and
//     the app reads Airtable. Lights up if and when a card table ships inside
//     the binary — and not before, because asserting against a copy Code typed
//     out would be exactly the invention the register exists to catch.
//
//  8. iconography · all seven checks. Needs `HomeAttribute` — the 26 forms,
//     their mounting, their motion, her card's colour word, and the dissolve
//     past the second adaptation.
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
private enum Measuring {

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

                // The letter row, exactly as `AirtableService.saveLetter`
                // composes it before handing it to `logActivity`.
                let letterName = "A letter to \(name.isEmpty ? "a Śakti" : name)"
                corpus.append(Utterance(origin: "Letter Written · Activity Name", text: letterName))
                corpus.append(Utterance(origin: "Letter Written · Detail", text: "First letter written"))
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
            // `DailySummons.reschedule`'s unprimed title.
            Utterance(origin: "DailySummons · unprimed title", text: "She is waiting."),
            // `RootView.primeSummons`'s body for a Śakti carrying no quality.
            Utterance(origin: "DailySummons · quality-less body", text: "She greets you this morning."),
        ]

        for s in ShaktiBootstrap.all {
            let kp = s.position + KhadgamalaMap.ringStartOffset(2)
            let quality = s.quality.trimmingCharacters(in: .whitespacesAndNewlines)
            corpus.append(Utterance(origin: "DailySummons · title (kp \(kp))", text: s.name))
            corpus.append(Utterance(origin: "DailySummons · body (kp \(kp))",
                                    text: quality.isEmpty ? "She greets you this morning." : quality))
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
