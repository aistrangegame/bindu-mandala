import XCTest
import SwiftUI
import SwiftData
@testable import Bindu_Mandala

// MARK: - Phase 3.8 · the library fold
//
// Her Detail is now two things at once. It is where a walker meets her — the
// landing of *know her ›* — and it is the threshold of her room, since Phase 3.7
// cut that door into its footer. The brief's word for what is left over is a
// **library**: *"the existing Detail screen's reference sections — kept, folded,
// for when you want the text."*
//
// This suite holds the four claims the fold makes, and the first is the one with
// teeth.
//
//   1. **Her screen is the same length whether she has been felt or not.**
//      Her Moments grows a row every time she is felt, so before this fold the
//      quantity of his practice was drawn in scroll height — never printed, but
//      in his hand every time he reached the foot of her screen. Law 2 does not
//      care which way a measure is drawn. The proof is structural here (the
//      register is built **only** inside the fold, so a shut fold asks the store
//      nothing) and measured on the running app in `TheLibraryFoldUITests`.
//   2. **Nothing is lost.** Every section that went behind a shelf is still
//      declared, still drawn, and still reached by one touch — and by a voice.
//   3. **The fold is state, not memory.** Both shelves are shut every time she
//      is opened. Nothing about how he left them is written anywhere, because a
//      screen that remembered how he left it is a screen keeping a record of
//      him.
//   4. **Nothing that stays out moves.** The shelves are the last things in the
//      scroll, which is why. The composition lock is what actually judges that;
//      what is held here is the shape that makes it possible.
@MainActor
final class TheLibraryFoldTests: XCTestCase {

    /// Her screen, twice: **masked** — comments and the contents of every string
    /// literal blanked, so a word in a doc comment cannot be mistaken for code —
    /// and **written**, which is the only place the words themselves survive.
    /// Structure is read from the first, wording from the second.
    private func detail() throws -> (file: SourceFile, code: String, written: String) {
        let f = try XCTUnwrap(LawSource.production("ShaktiDetailView.swift"),
                              "her screen is not where this suite reads it")
        return (f, String(f.lexed.masked), f.text)
    }

    private func body(_ code: String) throws -> String {
        try XCTUnwrap(Rx.first(#"var body: some View \{[\s\S]*?\n    \}"#, code),
                      "the Detail no longer has a `body` this check can read")
    }

    // MARK: - 1 · The register is built only behind the fold

    /// **The claim that makes the fold a law fix rather than a tidy-up.**
    ///
    /// `HerMomentsList` is the one thing on this screen whose size is a function
    /// of how much he has practised. If it were built and merely hidden — an
    /// `.opacity(0)`, a `.frame(height: 0)`, a `hidden()` — the screen would
    /// still be as long as his walking, the accessibility tree would still carry
    /// every row of it, and every other check here would still be green.
    ///
    /// So it is asked of the source: the list is constructed **once**, that
    /// construction is inside `herMomentsSection`, and `herMomentsSection`
    /// appears in the body of the view **only** inside the shelf's `if`. Delete
    /// the `if` and this goes red.
    func testTheRegisterIsBuiltOnlyWhenTheShelfIsOpen() throws {
        let (_, code, _) = try detail()

        let constructions = Rx.all(#"HerMomentsList\("#, code)
        XCTAssertEqual(constructions.count, 1,
                       "`HerMomentsList` is constructed \(constructions.count) times — the register "
                       + "has exactly one home, and it is behind the shelf")

        let fold = try XCTUnwrap(Rx.first(#"private var herMomentsFold: some View \{[\s\S]*?\n    \}"#, code),
                                 "`herMomentsFold` is gone")
        XCTAssertTrue(fold.contains("if momentsExpanded {"),
                      "the register is no longer gated on the shelf being open — it is built on "
                      + "every appearance of her screen, and her screen is as long as his walking "
                      + "again:\n\(fold)")
        XCTAssertTrue(fold.contains("herMomentsSection"),
                      "the shelf no longer holds the register")

        // …and it is built nowhere else. Two mentions: the declaration, and the
        // one use inside the fold.
        let mentions = Rx.all(#"\bherMomentsSection\b"#, code)
        XCTAssertEqual(mentions.count, 2,
                       "`herMomentsSection` appears \(mentions.count) times — it is declared once "
                       + "and drawn once, inside the shelf, and neither may go missing")

        // The body reaches the register through the fold and never around it.
        let body = try body(code)
        XCTAssertTrue(body.contains("herMomentsFold"), "the shelf is declared but never drawn")
        XCTAssertFalse(body.contains("herMomentsSection"),
                       "the register is drawn in the body as well as behind the shelf")
    }

    // MARK: - 2 · Nothing that went behind a shelf is lost

    /// Every section the two shelves hold is still declared and still drawn —
    /// exactly once each, from inside a fold. A fold that quietly dropped one of
    /// the six would look identical to a fold that holds it, until somebody
    /// opened it.
    func testEverySectionBehindAShelfIsStillDrawn() throws {
        let (_, code, _) = try detail()

        let reference = ["iconographySection", "lineageSection", "cosmicFunctionSection",
                         "tattvaSection", "bodilySeatSection", "etymologySection"]
        let goDeeper = try XCTUnwrap(
            Rx.first(#"private var goDeeperSection: some View \{[\s\S]*?\n    \}"#, code),
            "`goDeeperSection` is gone")
        for name in reference {
            XCTAssertEqual(Rx.all("\\b\(name)\\b", code).count, 2,
                           "\(name) is declared once and drawn once; it is not")
            XCTAssertTrue(goDeeper.contains(name),
                          "\(name) is no longer on the library's second shelf")
        }
        XCTAssertTrue(goDeeper.contains("if goDeeperExpanded {"),
                      "the reference matter is no longer behind its shelf")
    }

    // MARK: - 3 · The shelves are shut when she is opened, and never written down

    /// Both shelves are `@State` `Bool`s that start `false`. `@State` is rebuilt
    /// with the view, so every arrival at her screen is a screen with its
    /// library shut — on the first visit and on the thousandth, with nothing
    /// asked of any store about which it was.
    func testBothShelvesAreShutEveryTimeSheIsOpened() throws {
        let (_, code, _) = try detail()
        let stored = SwiftProperties.stored(in: code)

        for name in ["momentsExpanded", "goDeeperExpanded"] {
            let p = try XCTUnwrap(stored.first { $0.name == name },
                                  "`\(name)` is no longer a stored property of her screen")
            XCTAssertTrue(p.attributes.contains("@State"),
                          "`\(name)` is \(p.attributes) — a shelf that is anything but `@State` "
                          + "outlives the screen, and a shelf that outlives the screen is the "
                          + "instrument remembering him")
            XCTAssertEqual(p.type, "Bool", "`\(name)` holds \(p.type); a shelf is open or shut")
            // `SwiftProperties` keeps the written type and drops the
            // initialiser, so the default is read off the declaration itself.
            XCTAssertTrue(Rx.matches("@State private var \(name): Bool = false", code),
                          "`\(name)` does not start shut — her library is open on arrival, and "
                          + "how it was left is the one thing a screen may not carry forward")
        }
    }

    /// **And nowhere on her screen is anything written down at all.**
    ///
    /// The check above says the two shelves are `@State`. This says there is no
    /// second road: no `@AppStorage`, no `@SceneStorage`, no `UserDefaults`, no
    /// `HomeMemory`, nowhere on this screen for a fold — or for anything else —
    /// to be remembered between visits.
    func testHerScreenWritesNothingDownAboutHim() throws {
        let (_, code, _) = try detail()
        for road in ["@AppStorage", "@SceneStorage", "UserDefaults", "@Environment(\\.scenePhase)"] {
            XCTAssertFalse(code.contains(road),
                           "her screen reaches for `\(road)`. Nothing about how a walker left this "
                           + "screen may survive his leaving it.")
        }

        // The one store this screen touches, and it neither reads nor writes
        // it: `HomeMemoryStore` is handed straight to the rite, which is what
        // compresses a return. Phase 3.7 owns that line; what is held here is
        // that there is exactly one of it and it is inside the threshold.
        let uses = Rx.all(#"HomeMemoryStore\("#, code)
        XCTAssertEqual(uses.count, 1, "her screen builds \(uses.count) memory stores")
        let cover = try XCTUnwrap(
            Rx.first(#"fullScreenCover\(isPresented: \$showHerRoom\)[\s\S]*?\n        \}"#, code),
            "the threshold is no longer where this check reads it")
        XCTAssertTrue(cover.contains("HomeMemoryStore("),
                      "what a room remembers is reached from somewhere on her screen that is not "
                      + "the threshold")
    }

    // MARK: - 4 · The shelves are unconditional, and they never change with him

    /// **A shelf that appeared, vanished, or changed its words with his walking
    /// would measure him as surely as a digit.**
    ///
    /// `her moments` asks nothing at all before it draws — not whether she has
    /// been felt, not how often, not whether the base has answered — so it is
    /// the same row for a Śakti felt a hundred times and one felt never. This is
    /// the same discipline `testTheDoorAsksOnlyWhetherSheHasARoom` holds for the
    /// door one line below it in the footer.
    ///
    /// `go deeper` is conditional, and on the one thing it may be: whether any
    /// of the six reference words exist **for her**. That is a fact about the
    /// Śakti, fixed before the app was installed.
    func testNeitherShelfAsksAnythingAboutHisWalking() throws {
        let (_, code, written) = try detail()

        let fold = try XCTUnwrap(Rx.first(#"private var herMomentsFold: some View \{[\s\S]*?\n    \}"#, code))
        // Everything between the declaration and the shelf's own `shelf(` call
        // is what it asks before it draws. There is nothing there.
        let head = try XCTUnwrap(fold.components(separatedBy: "shelf(").first)
        XCTAssertFalse(head.contains("if "),
                       "the first shelf asks a question before it draws:\n\(head)")

        let goDeeper = try XCTUnwrap(
            Rx.first(#"private var goDeeperSection: some View \{[\s\S]*?\n    \}"#, code))
        let condition = try XCTUnwrap(Rx.first(#"let hasContent = [\s\S]*?\n        if hasContent"#, goDeeper),
                                      "`go deeper`'s condition is no longer where this check reads it")
        for what in NeverMeasure.practiceTouched(in: condition) {
            XCTFail("`go deeper` appears or vanishes with \(what) — a shelf may ask about her, "
                    + "never about him:\n\(condition)")
        }

        // The words on both shelves are fixed strings chosen at the call site,
        // never composed from anything.
        let shelves = Rx.groups(#"shelf\("([^"]*)", holding: "([^"]*)""#, written)
        XCTAssertEqual(shelves.count, 2, "there are \(shelves.count) shelves; the library has two")
        XCTAssertEqual(shelves.map { $0[1] }.sorted(), ["go deeper", "her moments"])
    }

    // MARK: - 5 · The shelves stand at the foot, under everything that stays

    /// **The whole reason nothing that stays out moves.**
    ///
    /// A fold placed in the middle of a scroll lifts everything beneath it by
    /// whatever it swallowed; a fold at the foot lifts nothing. That is the same
    /// argument Phase 3.7 made for putting the door in the footer — *a door that
    /// disturbs the screen it joins has been put in the wrong place* — and it is
    /// why this phase's entire cost to the composition lock is one classified
    /// translation of one control.
    ///
    /// It also fixes the order of the library itself: the record he made first,
    /// the reference tradition wrote second.
    func testTheShelvesAreTheLastThingsInTheScrollAndInThatOrder() throws {
        let (_, code, _) = try detail()
        let body = try body(code)

        let order = ["heroSection", "codexPortraitSection", "somaticSection", "bijaSection",
                     "appreciationPhraseSection", "embodimentSection", "fieldConnectionSection",
                     "herMomentsFold", "goDeeperSection"]
        var last = body.startIndex
        for name in order {
            let at = try XCTUnwrap(body.range(of: name, range: last..<body.endIndex),
                                   "\(name) is no longer in the body, or is out of order")
            last = at.upperBound
        }

        // The two doors are still outside the scroll and still in the ladder's
        // order. Phase 3.7 owns both facts; this phase must not have moved them.
        let scroll = try XCTUnwrap(Rx.first(#"ScrollView \{[\s\S]*?\n                    \}"#, body),
                                   "the Detail's ScrollView is no longer where this check reads it")
        XCTAssertTrue(scroll.contains("herMomentsFold") && scroll.contains("goDeeperSection"),
                      "the library is no longer inside the scroll")
        XCTAssertFalse(scroll.contains("herDoor"), "the way into her room fell into the scroll")
        XCTAssertFalse(scroll.contains("recognitionFooter"), "the recognition fell into the scroll")
        let scrolled = try XCTUnwrap(body.range(of: scroll))
        let door = try XCTUnwrap(body.range(of: "herDoor"))
        let felt = try XCTUnwrap(body.range(of: "recognitionFooter"))
        XCTAssertTrue(scrolled.upperBound <= door.lowerBound && door.lowerBound < felt.lowerBound,
                      "the footer's ladder — the scroll, then her room, then the recognition — "
                      + "is no longer in that order")
    }

    // MARK: - 6 · What the shelf says, and what it will not say

    /// The shelf's own words, through the same two registers `LawsTests` reads
    /// every walker-facing string with: Design's nine measuring patterns over
    /// the literals, and the practice record over everything bound in.
    ///
    /// The shelf is the most obvious place on this screen for a count to arrive
    /// — it stands in front of the one section that grows — so *"her moments
    /// (14)"*, *"she has been felt 14 times"*, a pip, a dot, and every other
    /// shape of the same thing are refused here by construction: the row takes
    /// two fixed strings and a `Bool`, and holds nothing else.
    func testTheShelfCannotSayANumber() throws {
        let (file, code, _) = try detail()

        let row = try XCTUnwrap(
            Rx.first(#"private func shelf\([\s\S]*?\n    \}"#, code),
            "the shared shelf row is gone")
        let signature = try XCTUnwrap(row.components(separatedBy: "{").first)
        for symbol in NeverMeasure.practiceSymbols where Rx.matches(symbol.pattern, row) {
            XCTFail("the shelf row touches \(symbol.what)")
        }
        XCTAssertTrue(signature.contains("_ title: String") && signature.contains("holding what: String")
                      && signature.contains("isOpen: Bool"),
                      "the shelf row takes something other than two words and whether it is open — "
                      + "a value it holds is a value it can be made to show:\n\(signature)")

        var read = 0
        var offences: [String] = []
        for call in file.calls(to: LawSource.walkerFacingCallees) {
            for lit in call.literals {
                read += 1
                if !NeverMeasure.measuresOutLoud(lit.text).isEmpty {
                    offences.append("\(call.origin) — \"\(lit.text)\"")
                }
            }
        }
        XCTAssertGreaterThanOrEqual(read, 20, "only \(read) strings were read from her screen")
        XCTAssertTrue(offences.isEmpty,
                      "her screen measures him out loud:\n" + offences.joined(separator: "\n"))
    }

    /// **A voice is told which state a shelf is in, because an eye is.**
    ///
    /// An eye reads a shelf's state from what is directly beneath it. A voice
    /// has nothing beneath it until it swipes, so the state is its `value` —
    /// §4.4's parity rule, which says the instrument may not give a VoiceOver
    /// walker less than the screen gives everybody else.
    ///
    /// The two shelves also carry **different names at all times**, which is the
    /// one thing that stopped `go deeper` keeping the word it used to show while
    /// open: *"less"* on both shelves would have been the same word naming two
    /// different doors, indistinguishable to a finger reaching for the right one
    /// and to a voice reading them in order.
    func testEachShelfSaysWhatItIsAndWhetherItIsOpen() throws {
        let (_, _, written) = try detail()
        let row = try XCTUnwrap(Rx.first(#"private func shelf\([\s\S]*?\n    \}"#, written),
                                "the shared shelf row is gone")

        XCTAssertTrue(row.contains(#"accessibilityValue(isOpen ? "unfolded" : "folded")"#),
                      "a shelf no longer says whether it is open")
        XCTAssertTrue(row.contains("accessibilityHint("),
                      "a shelf no longer says what it holds")
        XCTAssertFalse(Rx.matches(#"Text\(isOpen \?"#, row),
                       "a shelf renames itself when it opens. Two shelves stand on this screen; "
                       + "if either one changes its word for an open state, both say it, and the "
                       + "same word then names two different doors.")
    }
}
