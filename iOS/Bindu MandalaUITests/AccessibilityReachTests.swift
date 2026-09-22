import XCTest

// MARK: - AccessibilityReachTests — the instrument, on a running app
//
// Brief v2 §4.3 and §4.4, proved where they have to be proved: on the app, not
// on the source. `MandalaVoiceTests` says what the 102 sound like; this says the
// screen is actually wired to it, and that the type grows without the
// composition coming apart.
//
// Two launch arguments do the work of two hands:
//
//  · `-UIPreferredContentSizeCategoryName UICTContentSizeCategoryAccessibilityXXXL`
//    is the largest accessibility size, set on the app itself. `AppFont`'s
//    `UIFontMetrics` reads the same preferred category, and `Font.custom(…​,
//    relativeTo:)` reads it through the environment, so both halves of §4.3 are
//    measured here rather than asserted at the default and hoped for.
//
//  · The device this runs on decides which half of §4.3 is being tested. The
//    brief asks for the largest size on the **smallest screen**, so the checks
//    that are about width only assert on a phone-class screen and say so out
//    loud when they are skipped, rather than passing quietly on a Pro Max.

enum Reach {
    /// The same base the snapshot suite uses, and for the same reasons: no
    /// summons, no homecoming, no network, a pinned energy, and a store that
    /// lives and dies with the launch.
    static let base = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                       "ENERGY_POS=29", "EPHEMERAL_STORE"]

    /// The largest size iOS offers. Everything §4.3 is for happens here or
    /// nowhere.
    static let largestType = ["-UIPreferredContentSizeCategoryName",
                              "UICTContentSizeCategoryAccessibilityXXXL"]

    static func app(_ arguments: [String], type largest: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = base + arguments + (largest ? largestType : [])
        app.launch()
        return app
    }

    /// A screen has arrived when its own words are on it. Some of those words
    /// are a control's label rather than a line of type — the Rite's "I feel
    /// her" is a `Button`, and reading only `staticTexts` reports that screen as
    /// never having arrived, which is a failure about the query and not about
    /// the app.
    static func text(_ app: XCUIApplication, _ fragment: String, _ timeout: TimeInterval = 30) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", fragment)
        if app.staticTexts.matching(predicate).firstMatch.waitForExistence(timeout: timeout) {
            return true
        }
        return app.buttons.matching(predicate).firstMatch.exists
    }

    /// Every element the Mandala's spoken layer put on the screen, in the order
    /// the tree reports them.
    ///
    /// They come back as **buttons**, and that was not chosen — no `.isButton`
    /// trait is declared anywhere in the layer. iOS assigns the trait itself,
    /// because an accessibility element that carries an activate action *is* a
    /// button as far as the system is concerned, and these carry one so a voice
    /// can arrive at a seat. It is the right answer for a walker, and it is why
    /// `FeltRegisterClassifications.appeared` has to name them: the composition
    /// reader counts buttons.
    ///
    /// They are found by the word "enclosure", which every seat and every
    /// enclosure says — no identifier had to be invented that the walker would
    /// then have to hear.
    static func spokenField(_ app: XCUIApplication) -> [XCUIElement] {
        app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] %@", "enclosure"))
            .allElementsBoundByIndex
            .filter { $0.exists }
    }
}

// MARK: - §4.4 · VoiceOver reaches the 102

final class AccessibilityReachTests: XCTestCase {

    override func setUp() { continueAfterFailure = true }

    /// The sixteen Karṣiṇīs are the only rows that ship in the binary, so a
    /// simulator with `SYNC_OFF` seats sixteen and not a hundred and two. That
    /// is the whole field this test can see, and it says so rather than
    /// asserting a number it cannot reach: the count is checked against what the
    /// Field itself reports, and every one of them is checked for a real name.
    func testEverySeatOnTheScreenIsAnElementThatSpeaksHerName() {
        let app = Reach.app(["START_TAB=mandala"])
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the Mandala never arrived")

        let field = Reach.spokenField(app)
        XCTAssertGreaterThanOrEqual(field.count, 17,
                                    "the canvas Mandala is still silent: the sixteen seated "
                                    + "Karṣiṇīs and their enclosure should each be an element")

        // A seat and an enclosure are told apart by what they say, not by what
        // kind of element they are: a seat ends with her place in the garland,
        // an enclosure with the form the yantra draws there.
        let seats = field.filter { $0.label.contains("of the one hundred and two") }
        let enclosures = field.filter { !$0.label.contains("of the one hundred and two") }
        XCTAssertGreaterThanOrEqual(enclosures.count, 1, "no enclosure is named aloud")
        XCTAssertGreaterThanOrEqual(seats.count, 16,
                                    "sixteen seats ship in the binary; \(seats.count) are spoken")

        for seat in seats {
            let label = seat.label
            XCTAssertFalse(label.hasPrefix("Second enclosure"),
                           "a seat is speaking its ring before her name: “\(label)”")
            XCTAssertTrue(label.contains("of the one hundred and two"),
                          "a seat does not say where in the garland she sits: “\(label)”")
            XCTAssertNil(label.first(where: \.isNumber),
                         "a spoken label carries a numeral: “\(label)”")
            XCTAssertGreaterThanOrEqual(seat.frame.width, 43.5,
                                        "“\(label)” is a target a finger cannot find")
            XCTAssertGreaterThanOrEqual(seat.frame.height, 43.5,
                                        "“\(label)” is a target a finger cannot find")
        }
    }

    /// Ring 2's sixteen, each saying something of her own.
    ///
    /// Not a list of expected names typed out here — that is the ghost roster the
    /// laws exist to prevent, and these sixteen are the only rows the app
    /// genuinely ships and syncs. What is asserted is the shape of a real name:
    /// sixteen seats, sixteen *different* announcements, each beginning with a
    /// name rather than the fallback a nameless row would get, each carrying the
    /// quality the base actually wrote for her, and none of them carrying a
    /// character a voice cannot say.
    ///
    /// One is pinned exactly, and deliberately: Sparśākarṣiṇī at khaḍgamālā 33,
    /// whose `phonetic` field the base really holds. That line is the whole of
    /// §4.4 in one string — the transliteration rather than the diacritics, the
    /// middle dots gone, `SHAH` no longer spelled out as three letters, her
    /// quality, and her place in the garland said in words.
    func testTheSeatedSixteenAreEachFindableByHerOwnName() {
        let app = Reach.app(["START_TAB=mandala"])
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the Mandala never arrived")

        let seats = Reach.spokenField(app).map(\.label)
            .filter { $0.contains("of the one hundred and two") }
        XCTAssertGreaterThanOrEqual(seats.count, 16,
                                    "sixteen Karṣiṇīs ship in the binary; \(seats.count) speak")
        XCTAssertEqual(Set(seats).count, seats.count,
                       "two seats say the same thing — a walker cannot tell them apart:\n"
                       + seats.joined(separator: "\n"))

        for label in seats {
            let name = String(label.prefix(while: { $0 != "." }))
            XCTAssertFalse(name.isEmpty, "a seat announces itself with nothing: “\(label)”")
            XCTAssertFalse(name.hasSuffix(" seat"),
                           "“\(name)” is the fallback a nameless row gets — the sixteen have names")
            XCTAssertTrue(label.contains("She who attracts"),
                          "a Karṣiṇī no longer says what she draws: “\(label)”")
            XCTAssertTrue(name.allSatisfy { $0.isLetter || $0 == " " || $0 == "-" },
                          "“\(name)” carries something a voice cannot say")
        }

        XCTAssertTrue(seats.contains("Spar Shah kar shi nee. She who attracts Touch. "
                                     + "Second enclosure, thirty-third of the one hundred and two."),
                      "khaḍgamālā 33 does not say the line §4.4 exists to produce:\n"
                      + seats.joined(separator: "\n"))
    }

    /// The order is the garland: the enclosure, then its seats, ascending. A
    /// walker swiping right through the field should travel the ring the way the
    /// ring is strung, not the way SwiftUI happens to lay the rectangles out.
    func testTheFieldIsSpokenInGarlandOrder() {
        let app = Reach.app(["START_TAB=mandala"])
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the Mandala never arrived")

        let labels = Reach.spokenField(app).map(\.label)
        guard !labels.isEmpty else { return XCTFail("nothing is spoken on the field") }

        // The enclosure comes before the seats inside it: the screen says who is
        // in it before it says who is on it.
        guard let enclosure = labels.firstIndex(where: { $0.hasPrefix("Second enclosure.") }) else {
            return XCTFail("the enclosure is not spoken at all: \(labels.joined(separator: " | "))")
        }
        guard let firstSeat = labels.firstIndex(where: {
            $0.contains("of the one hundred and two")
        }) else { return XCTFail("no seat is spoken") }
        XCTAssertLessThan(enclosure, firstSeat,
                          "the sixteen are announced before the lotus they sit in")

        // "…, twenty-ninth of the one hundred and two." — the ordinals in the
        // order they were spoken, matched against the order they are strung.
        let garland = (29...44).map { "\(ordinalWord($0)) of the one hundred and two" }
        let spokenSeats = labels.compactMap { label in
            garland.first { label.contains($0) }
        }
        XCTAssertEqual(spokenSeats, garland.filter { spokenSeats.contains($0) },
                       "the seats are not spoken in the order they are strung")
    }

    /// The element sits where the seat is drawn. Tapping it goes through the
    /// layer — which hit-tests nothing — to the field's own gesture underneath,
    /// which finds the nearest seat. If the element were in the wrong place the
    /// card that blooms would carry a different name, or none.
    func testActivatingASeatOpensHerSignificance() {
        let app = Reach.app(["START_TAB=mandala"])
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the Mandala never arrived")

        let target = Reach.spokenField(app).first {
            $0.label.contains("thirty-third of the one hundred and two")
        }
        guard let target else { return XCTFail("kp 33's seat is not on the spoken field") }
        let name = String(target.label.prefix(while: { $0 != "." }))
        target.tap()

        XCTAssertTrue(app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] %@", "enter her presence"))
            .firstMatch.waitForExistence(timeout: 10),
                      "activating \(name)'s seat did not open her significance")
    }

    private func ordinalWord(_ n: Int) -> String {
        let ones = ["", "first", "second", "third", "fourth", "fifth", "sixth", "seventh",
                    "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth",
                    "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth",
                    "nineteenth"]
        let tens = ["", "", "twenty", "thirty", "forty"]
        if n < 20 { return ones[n] }
        let unit = n % 10
        return unit == 0 ? "\(tens[n / 10])th" : "\(tens[n / 10])-\(ones[unit])"
    }
}

// MARK: - §4.3 · The type grows, and the screens hold

final class DynamicTypeReachTests: XCTestCase {

    override func setUp() { continueAfterFailure = true }

    /// Every screen this phase owns, opened at the largest accessibility size,
    /// and read for the two things that go wrong there: a string that has run
    /// off the side of the glass, and a string that is no longer on the screen
    /// at all.
    ///
    /// Horizontal always; vertical **only on a screen that cannot scroll**, and
    /// that distinction is the whole of it. A column that grew taller than the
    /// screen is what a scroll view is for, and XCUITest reports frames below
    /// the fold as being below the fold — a blanket vertical bound would fail on
    /// every scrolling screen in the app for the wrong reason, which is why this
    /// test measured width alone and reported green on a Rite whose moon had
    /// been pushed up under the status bar. So the screen is asked whether it
    /// has anywhere to scroll, and if it has not, a string outside the glass is
    /// a string with nothing to reach it — exactly the horizontal case, turned
    /// ninety degrees.
    func testNothingRunsOffTheSideOfTheSmallestScreen() {
        let screens: [(name: String, args: [String], settles: String)] = [
            ("the Mandala",   ["START_TAB=mandala"],            "Śrī Yantra"),
            ("her presence",  ["START_TAB=mandala", "OPEN_DETAIL=33"], "Embodiment"),
            ("the Rite",      ["START_TAB=rite"],               "I feel her"),
            ("the Field",     ["START_TAB=102"],                "The Field"),
            ("the Well",      ["START_TAB=well"],               "Your Letters"),
            ("the Portrait",  ["START_TAB=memory"],             "she is felt, not measured"),
            ("the Bindu",     ["START_TAB=mandala", "OPEN_SILENCE"], "THE BINDU"),
        ]

        var failures: [String] = []
        for screen in screens {
            let app = Reach.app(screen.args, type: true)
            guard Reach.text(app, screen.settles, 35) else {
                failures.append("\(screen.name): never arrived at the largest type size")
                app.terminate()
                continue
            }
            Thread.sleep(forTimeInterval: 2.0)

            let bounds = app.frame
            let canScroll = app.scrollViews.firstMatch.exists
            var read = 0
            for element in app.staticTexts.allElementsBoundByIndex {
                guard element.exists else { continue }
                let f = element.frame
                guard f.width > 0, f.height > 0 else { continue }
                read += 1
                if f.minX < -0.5 || f.maxX > bounds.width + 0.5 {
                    failures.append(String(format: "%@: “%@” spans %.1f…%.1f on a %.0f pt screen",
                                           screen.name, element.label, f.minX, f.maxX, bounds.width))
                }
                if !canScroll, f.minY < -0.5 || f.maxY > bounds.height + 0.5 {
                    failures.append(String(format: "%@: “%@” sits %.1f…%.1f on a %.0f pt screen "
                                           + "with nothing to scroll",
                                           screen.name, element.label, f.minY, f.maxY, bounds.height))
                }
            }
            XCTAssertGreaterThanOrEqual(read, 2,
                                        "\(screen.name) exposed almost nothing to read — a screen "
                                        + "that reports nothing passes every check it is given")

            let shot = XCTAttachment(screenshot: app.screenshot())
            shot.name = "ax5-\(screen.name)"
            shot.lifetime = .keepAlways
            add(shot)
            app.terminate()
        }
        XCTAssertTrue(failures.isEmpty,
                      "At the largest accessibility size, text left the screen sideways:\n"
                      + failures.joined(separator: "\n"))
    }

    /// The failure the check above cannot see, because truncation keeps a string
    /// inside every bound it is given: a column with nowhere to grow does not
    /// overflow, it *compresses*, and SwiftUI answers a height proposal it
    /// cannot meet by cutting the string to an ellipsis. At the largest
    /// accessibility size on an SE the Rite's own question read "\u{201C}Where does
    /// w\u{2026}" — the most meaningful sentence on the app's home screen, gone —
    /// while every frame stayed dutifully inside the glass and this suite
    /// reported green.
    ///
    /// No public API asks an element whether it was truncated, and the width a
    /// label needs cannot be computed without knowing the token it was set in.
    /// But one thing is always true and needs neither: **bigger type is never
    /// shorter.** A string read at the largest size that occupies less height
    /// than the same string at the default has not grown and re-wrapped — it has
    /// been cut. So each screen is read twice, and its strings are matched by
    /// the same folded key the composition lock uses, which is what makes a moon
    /// phase and a clock the same string across two launches.
    func testNoStringIsCutShortByAColumnThatCannotGrow() {
        let screens: [(name: String, args: [String], settles: String)] = [
            ("the Rite",  ["START_TAB=rite"],                    "I feel her"),
            ("the Well",  ["START_TAB=well"],                    "Your Letters"),
            ("the Bindu", ["START_TAB=mandala", "OPEN_SILENCE"], "THE BINDU"),
        ]

        var failures: [String] = []
        for screen in screens {
            let small = heights(screen.args, settles: screen.settles, largest: false)
            let large = heights(screen.args, settles: screen.settles, largest: true)
            guard !small.isEmpty, !large.isEmpty else {
                failures.append("\(screen.name): never arrived at both type sizes")
                continue
            }
            var grew = 0
            for (key, was) in small.sorted(by: { $0.key < $1.key }) {
                guard let now = large[key] else { continue }
                // A one-line string with `minimumScaleFactor` is *allowed* to
                // give a few points back to stay on its line — that is exactly
                // what the source-level lock requires of it, and the Bindu's
                // sixty-point name legitimately returns about three per cent.
                // A cut takes whole lines: the Rite's question went from three
                // lines to one. The bar sits between the two, far enough above
                // a scale-to-fit that no honest one costs a failure, and far
                // enough below one line lost from six that no cut hides.
                if now < was * 0.92 {
                    failures.append(String(format: "%@: \u{201C}%@\u{201D} is %.1f pt tall at the "
                                           + "default size and %.1f pt at the largest — bigger type "
                                           + "made it shorter, which is a cut and not a re-wrap",
                                           screen.name, key, was, now))
                }
                if now > was + 0.5 { grew += 1 }
            }
            XCTAssertGreaterThan(grew, 0,
                                 "\(screen.name): not one string grew between the default and the "
                                 + "largest accessibility size — this check is reading an app that "
                                 + "ignores the setting, and would pass on anything")
        }
        XCTAssertTrue(failures.isEmpty,
                      "At the largest accessibility size, these strings were cut short:\n"
                      + failures.joined(separator: "\n"))
    }

    /// Every string on a screen, by the composition lock's own folded key, with
    /// the height it was drawn at.
    private func heights(_ args: [String], settles: String, largest: Bool) -> [String: Double] {
        let app = Reach.app(args, type: largest)
        defer { app.terminate() }
        guard Reach.text(app, settles, 35) else { return [:] }
        Thread.sleep(forTimeInterval: 2.0)
        var out: [String: Double] = [:]
        for element in app.staticTexts.allElementsBoundByIndex {
            guard element.exists else { continue }
            let f = element.frame
            guard f.width > 0, f.height > 0 else { continue }
            let key = ElementFrame.normalize(element.label)
            out[key] = max(out[key] ?? 0, Double(f.height))
        }
        return out
    }

    /// The type genuinely grew. Without this, every check above would pass on an
    /// app that ignored the setting entirely — which is precisely the state the
    /// audit found, and precisely the state a green suite must not be able to
    /// describe.
    func testTheTypeActuallyGrows() {
        // Both halves of §4.3, because they reach the setting by different
        // roads. The Field's title is Cormorant through
        // `Font.custom(_:size:relativeTo:)`, which SwiftUI scales from the
        // environment. The strip under it is the system sans through
        // `UIFontMetrics`, which reads the app's own preferred content size
        // category. Only one of those is proved by arithmetic in
        // `DynamicTypeTests`; this is the other one, on a running app.
        let atDefault = fieldHeader(largest: false)
        let atLargest = fieldHeader(largest: true)

        XCTAssertGreaterThan(atDefault.title, 0, "the Field's title was never found")
        XCTAssertGreaterThan(atLargest.title, atDefault.title * 1.4,
                             String(format: "the Field's title is %.1f pt tall at the default and "
                                    + "%.1f pt at the largest accessibility size — Cormorant is "
                                    + "still nailed to the glass", atDefault.title, atLargest.title))

        XCTAssertGreaterThan(atDefault.strip, 0, "the Field's ring strip was never found")
        XCTAssertGreaterThan(atLargest.strip, atDefault.strip * 1.4,
                             String(format: "the strip under it is %.1f pt tall at the default and "
                                    + "%.1f pt at the largest — `AppFont.label` is not reading the "
                                    + "preferred content size category", atDefault.strip, atLargest.strip))
    }

    /// The two headers' heights in one launch: Cormorant, and the system sans.
    private func fieldHeader(largest: Bool) -> (title: Double, strip: Double) {
        let app = Reach.app(["START_TAB=102"], type: largest)
        defer { app.terminate() }
        let title = app.staticTexts
            .matching(NSPredicate(format: "label == %@", "The Field"))
            .firstMatch
        guard title.waitForExistence(timeout: 35) else { return (0, 0) }
        Thread.sleep(forTimeInterval: 1.5)
        let strip = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] %@", "NINE RINGS"))
            .firstMatch
        return (Double(title.frame.height), strip.exists ? Double(strip.frame.height) : 0)
    }

    /// The controls are still controls. A button whose label tripled and whose
    /// box did not is a button that reads as a smear — and §4.2's eight targets
    /// were paid for in points that Dynamic Type can spend again.
    func testEveryControlIsStillReachableAtTheLargestSize() {
        let app = Reach.app(["START_TAB=mandala", "OPEN_DETAIL=33"], type: true)
        XCTAssertTrue(Reach.text(app, "Embodiment", 35), "her presence never arrived")
        Thread.sleep(forTimeInterval: 2.0)

        let bounds = app.frame
        var failures: [String] = []
        for button in app.buttons.allElementsBoundByIndex {
            guard button.exists, button.frame.width > 0, button.frame.height > 0 else { continue }
            let f = button.frame
            if f.height < 43.5 || f.width < 43.5 {
                failures.append(String(format: "“%@” is %.1f × %.1f", button.label, f.width, f.height))
            }
            if f.minX < -0.5 || f.maxX > bounds.width + 0.5 {
                failures.append(String(format: "“%@” spans %.1f…%.1f", button.label, f.minX, f.maxX))
            }
        }
        XCTAssertTrue(failures.isEmpty,
                      "At the largest accessibility size, these controls came apart:\n"
                      + failures.joined(separator: "\n"))
    }
}


// MARK: - §4.4 · the tap-anywhere exit
//
// Its own class, and the name is doing work: XCTest runs test classes in
// alphabetical order, and this one writes a real recognition — the only test in
// this file that writes anything. `FeltRegisterSnapshots` says in its own header
// that the screen which records one has to be **last**, because every screen read
// after it is reading a different instrument. A `V` puts this after `S`, so the
// shipped suite, the snapshots and the hit-area walk all run on an instrument
// nothing has been felt in.

final class VoiceOverCeremonyExitTests: XCTestCase {

    override func setUp() { continueAfterFailure = true }

    /// §4.4's other half: the screens a walker leaves by touching anywhere at
    /// all. A tap-anywhere exit gives a sighted walker the whole screen and a
    /// VoiceOver walker nothing, unless something says so.
    func testTheTapAnywhereExitIsAnElementAVoiceCanFind() {
        let app = Reach.app(["START_TAB=rite", "AUTO_RECOGNIZE"])
        XCTAssertTrue(Reach.text(app, "and she felt you back", 40),
                      "the ceremony never reached its second line")

        let exit = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] %@", "Close this moment"))
            .firstMatch
        XCTAssertTrue(exit.waitForExistence(timeout: 10),
                      "the ceremony's tap-anywhere exit is unreachable by name")
    }

}
