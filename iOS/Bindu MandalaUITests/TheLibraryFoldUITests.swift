import XCTest

// MARK: - Phase 3.8, driven on the running app
//
// `TheLibraryFoldTests` reads the source: that the register is built only behind
// its shelf, that both shelves start shut, that nothing is written down. None of
// that is the same as a walker finding what went behind them, and none of it can
// measure the thing this phase is actually for.
//
// **The claim with teeth is a measurement, and it can only be made here.** Her
// Moments grows a row every time she is felt. Before this fold, the quantity of
// a walker's practice with a Śakti was drawn in the length of her screen — no
// digit anywhere, and the difference in his hand every time he reached the foot
// of it. Law 2 does not care which way a measure is drawn. So this suite opens
// the same Śakti's screen twice in one run — once after she has been felt, once
// before — and asserts the composition is the same to the point.
//
// The rest is the other half of a fold: **nothing may become unreachable.** Every
// element the composition lock lets the Detail lose is named in
// `FeltRegisterClassifications.folded` with the control it went behind, and this
// suite opens every one of those controls and finds every one of those elements
// again, by the same key the lock compares on. An element that had merely been
// deleted has no door to name and nothing here that could find it.
//
// `EPHEMERAL_STORE` is what makes it re-runnable: the recognition this suite
// writes lives and dies with its launch, and the disk is never touched.
final class TheLibraryFoldUITests: XCTestCase {

    override func setUp() { continueAfterFailure = false }

    private static let base = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                               "ENERGY_POS=29", "EPHEMERAL_STORE"]

    private func launch(_ extra: [String], type largest: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = Self.base + extra
            + (largest ? ["-UIPreferredContentSizeCategoryName",
                          "UICTContentSizeCategoryAccessibilityXXXL"] : [])
        app.launch()
        return app
    }

    /// The library's shelves, found by the words they say. They are `Button`s and
    /// they never rename themselves, which is what makes this query the same
    /// query whether the shelf is open or shut.
    private func shelf(_ app: XCUIApplication, _ name: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label == %@", name)).firstMatch
    }

    /// **The same shelf, but only once it has opened.**
    ///
    /// Phase 3.7 paid for this lesson twice and wrote it down: a press the
    /// simulator cancels looks exactly like a press that landed unless what is
    /// waited on exists *only* after it. A shelf that is open is the same button
    /// with the same words — the whole point of it is that it does not rename
    /// itself — so the thing that is only true afterwards is the state it speaks:
    /// `accessibilityValue` is "unfolded", and it is "folded" until the toggle
    /// really ran. This is the sentinel for every shelf press in this file, and
    /// it doubles as the proof that a voice is genuinely told which state the
    /// shelf is in, on the running app rather than in the source.
    private func openedShelf(_ app: XCUIApplication, _ name: String) -> XCUIElement {
        app.buttons
            .matching(NSPredicate(format: "label == %@ AND value == 'unfolded'", name))
            .firstMatch
    }

    private func beWithHer(_ app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Be with her'")).firstMatch
    }

    /// Her Detail, opened straight onto the seat the snapshot baseline was
    /// recorded from.
    private func herScreen(_ app: XCUIApplication) -> Bool {
        shelf(app, "her moments").waitForExistence(timeout: 35)
    }

    // MARK: - Reaching a shelf at all

    /// **Both shelves stand below the fold of the glass, and `exists` does not
    /// mean a finger can get to them.**
    ///
    /// The Detail's scroll is a plain `VStack` in a `ScrollView`, so every
    /// element of it is built and every one is in the accessibility tree —
    /// `detail.geom` records `go deeper` at y 1066.50 on a 667 pt screen for
    /// exactly that reason. `exists` is therefore true for a control a walker
    /// would have to scroll a long way to see, `isHittable` is false, and
    /// `tap()` on it does not land. This is the same `exists`-against-`isHittable`
    /// distinction Phase 3.7 hit from the other side, and at the largest
    /// accessibility size the distance is several screenfuls rather than one.
    ///
    /// So the shelf is brought into the glass before it is pressed, by the
    /// gesture 3.7 found actually reaches a scrolling view on the smallest
    /// screen: a press and a drag, not `swipeUp()`. It stops as soon as the
    /// control is reachable, so a screen that needs no scrolling is not scrolled
    /// at all.
    ///
    /// **The drag starts from the scroll's own floor, measured, not from a
    /// fraction of the glass.** Phase 3.7 put two controls in a footer *outside*
    /// the `ScrollView`, and a drag that begins on the footer moves nothing —
    /// which is invisible at the default type size, where a fixed fraction lands
    /// in the scroll by luck, and fatal at the largest, where the footer's own
    /// words have tripled and eaten the bottom half of the screen. `be with her`
    /// is the top of that footer, so the scroll ends just above it.
    @discardableResult
    private func reveal(_ element: XCUIElement, in app: XCUIApplication,
                        attempts: Int = 30) -> Bool {
        guard element.waitForExistence(timeout: 20) else { return false }
        let bounds = app.frame
        let door = beWithHer(app)
        let floor = (door.exists ? door.frame.minY : bounds.maxY) - 12
        let ceiling = bounds.minY + bounds.height * 0.16   // clear of the nav bar
        guard floor - ceiling > 40 else { return element.isHittable }

        var drags = 0
        while !element.isHittable && drags < attempts {
            let origin = app.coordinate(withNormalizedOffset: .zero)
            let from = origin.withOffset(CGVector(dx: bounds.width * 0.5, dy: floor))
            let to   = origin.withOffset(CGVector(dx: bounds.width * 0.5, dy: ceiling))
            from.press(forDuration: 0.08, thenDragTo: to)
            drags += 1
        }
        return element.isHittable
    }

    /// Reach a shelf and open it, and do not believe it opened until it says so.
    @discardableResult
    private func unfold(_ name: String, in app: XCUIApplication,
                        file: StaticString = #filePath, line: UInt = #line) -> Bool {
        let control = shelf(app, name)
        XCTAssertTrue(reveal(control, in: app),
                      "“\(name)” never came within reach of a finger — it is in the tree, below "
                      + "the glass, and no amount of scrolling brought it up",
                      file: file, line: line)
        return press(control, until: openedShelf(app, name), attempts: 3, eachTimeout: 10)
    }

    // MARK: - 1 · Her screen says nothing of his practice, and still holds all of it

    /// **The measure that was being drawn rather than printed — and the register
    /// it was drawn in, still whole.**
    ///
    /// One launch, one Śakti, one screen, read twice with exactly one thing
    /// different between the readings: in between, she is felt.
    ///
    /// Her Moments grows a row every time that happens. Before this fold, the
    /// quantity of a walker's practice with a Śakti was therefore drawn in the
    /// length of her screen — no digit anywhere, and the difference in his hand
    /// every time he reached the foot of it. Law 2 does not care which way a
    /// measure is drawn, so the register stands behind a shelf that is shut on
    /// every arrival, and her screen is the same screen on the first visit and
    /// the hundredth.
    ///
    /// Then the other half, which is what makes it a fold and not a deletion:
    /// the shelf is opened and the register is behind it, in her own words.
    ///
    /// **The walk.** She is opened from the Mandala; she is felt through her own
    /// footer; the ceremony settles the app onto the Portrait, which is what it
    /// has always done and is not this phase's to change; and the menu carries
    /// him back to the Mandala, where `OPEN_DETAIL` opens her again — the same
    /// seat, reached the same way, over the same screen. Both readings are
    /// therefore of one composition, and the only variable in them is the
    /// recognition.
    func testHerScreenReportsNothingOfHisPracticeAndStillHoldsAllOfIt() {
        let app = launch(["START_TAB=mandala", "OPEN_DETAIL=29", "RECOGNIZE_AUTOCLOSE"])
        XCTAssertTrue(herScreen(app), "her Detail never arrived")
        Thread.sleep(forTimeInterval: 2.0)
        let unfelt = composition(of: app)
        XCTAssertGreaterThanOrEqual(unfelt.count, 8,
                                    "her screen exposed almost nothing to read — a screen that "
                                    + "reports nothing holds every composition it is given")

        feelHer(app)
        returnToHerScreen(app)
        Thread.sleep(forTimeInterval: 2.0)
        let felt = composition(of: app)

        var moved: [String] = []
        var compared = 0
        for (key, was) in unfelt.sorted(by: { $0.key < $1.key }) {
            guard let now = felt[key] else {
                moved.append("gone once she had been felt — \(key)")
                continue
            }
            compared += 1
            let dx = abs(now.minX - was.minX), dy = abs(now.minY - was.minY)
            if dx > 1.0 || dy > 1.0 {
                moved.append(String(format: "%@ moved (dx %.2f, dy %.2f) because she had been felt",
                                    key, dx, dy))
            }
        }
        for key in felt.keys where unfelt[key] == nil {
            moved.append("arrived on her screen because she had been felt — \(key)")
        }
        XCTAssertGreaterThanOrEqual(compared, 8, "only \(compared) elements were comparable")
        XCTAssertTrue(moved.isEmpty,
                      "**her screen reports her practice in its own geometry.** The register "
                      + "belongs behind a shut shelf precisely so that a Śakti felt a hundred "
                      + "times and one felt never have the same screen:\n"
                      + moved.joined(separator: "\n"))

        // …and it was folded, not thrown away. With the shelf shut the
        // register's own first line is nowhere on her screen; one touch brings
        // the whole of it back.
        let register = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'she was felt here'"))
        XCTAssertEqual(register.count, 0, "the register is on her screen with its shelf shut")

        XCTAssertTrue(unfold("her moments", in: app), "the register's shelf never opened")
        XCTAssertTrue(register.firstMatch.waitForExistence(timeout: 10),
                      "the shelf opened and her moments were not behind it — the register that "
                      + "went behind this door has been thrown away rather than folded")

        // The footer does not scroll, so opening a shelf may not disturb it:
        // Phase 3.7's way into her room is still where it was put.
        XCTAssertTrue(beWithHer(app).isHittable,
                      "opening the library put the way into her room out of reach")
    }

    /// Her screen's composition, by the composition lock's own key and frame.
    private func composition(of app: XCUIApplication) -> [String: CGRect] {
        var out: [String: CGRect] = [:]
        for frame in ScreenReader.read(app) {
            out[frame.key] = CGRect(x: frame.x, y: frame.y, width: frame.w, height: frame.h)
        }
        return out
    }

    /// She is felt, through her own footer, the way a walker feels her.
    private func feelHer(_ app: XCUIApplication) {
        let feel = app.buttons
            .matching(NSPredicate(format: "label BEGINSWITH 'I feel her'")).firstMatch
        XCTAssertTrue(feel.waitForExistence(timeout: 20), "her screen offers no recognition")
        let line = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'and she felt you back'")).firstMatch
        XCTAssertTrue(press(feel, until: line, attempts: 4, eachTimeout: 20),
                      "the ceremony never reached its second line, so she was never felt")
        // **The ceremony is not left by a synthetic tap, and it cannot be.**
        // §4.4 gave the tap-anywhere exit an element of its own so a voice can
        // find it — `MandalaVoice.closeCeremony` — but that element is a
        // `Color.clear` that `allowsHitTesting(false)`: it carries an
        // accessibility action, not a touch path. A finger leaves by the
        // `onTapGesture` on the whole screen, and `XCUIElement.tap()` aims at
        // the *centre* of what it is given, which on this screen is the note
        // card — whose own `onTapGesture` exists precisely to say *"don't
        // dismiss the screen when tapping inside the note card."* Tapping the
        // named exit would focus the note and leave the ceremony standing.
        //
        // So the ceremony closes itself, by the debug path the shipped suite
        // already leans on for exactly this: `RECOGNIZE_AUTOCLOSE` runs
        // `beginClose()` once the moment has landed. That the exit is reachable
        // *by name* is `VoiceOverCeremonyExitTests`' claim and is not restated
        // here. What this needs is the walk continued, and the Portrait's own
        // line — on that screen and no other in the shell — is what says the
        // shell settled.
        XCTAssertTrue(app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'Close this moment'"))
            .firstMatch.waitForExistence(timeout: 15),
                      "the ceremony's way out was never reachable")
        let settled = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'she is felt, not measured'")).firstMatch
        XCTAssertTrue(settled.waitForExistence(timeout: 40),
                      "the ceremony never settled onto the Portrait")
    }

    /// Back to her screen, by the menu and the same launch argument that opened
    /// it the first time. `RootView` keys its destinations by `.id`, so the
    /// Mandala is built afresh and opens her again exactly as it did at launch.
    private func returnToHerScreen(_ app: XCUIApplication) {
        // The shell is still moving when the Portrait's own line arrives:
        // `RootView` crossfades to `.memory` over 0.9 s and the destination
        // transition runs 0.5 s on top of it. Enumerating the tree through that
        // is what makes the corner button a moving target.
        Thread.sleep(forTimeInterval: 2.0)
        let mandala = app.buttons.matching(NSPredicate(format: "label == 'The Mandala'")).firstMatch
        for _ in 0..<3 {
            tapHamburger(app)
            if mandala.waitForExistence(timeout: 6) { break }
        }
        XCTAssertTrue(mandala.exists, "the menu never opened after the ceremony settled")
        XCTAssertTrue(press(mandala, until: shelf(app, "her moments"), attempts: 3, eachTimeout: 20),
                      "her screen never came back")
    }

    /// The hamburger carries no label — `FeltRegisterSnapshots` records the same
    /// fact — so it is found where it lives: the top-trailing 44 × 44.
    ///
    /// **Found as an element, pressed as a place.** `allElementsBoundByIndex`
    /// resolves against a snapshot of the tree, and this is called on a screen
    /// the shell has just crossfaded into: a button that is index 1 when the
    /// list is taken can be gone by the time `tap()` asks for it again, and
    /// XCUITest *throws* on that rather than missing — *"no matches found for
    /// Element at index 1"* — which ends the whole walk rather than costing it a
    /// retry. The corner is the same corner either way, so the element is used
    /// to find out **where** and the press goes to that point.
    private func tapHamburger(_ app: XCUIApplication) {
        let bounds = app.frame
        let corner = app.buttons.allElementsBoundByIndex.first {
            $0.exists && $0.frame.maxX > bounds.width - 76
                && $0.frame.minY < 140 && $0.frame.height >= 40 && $0.frame.width >= 40
        }
        guard let where_ = corner?.frame, where_.width > 0 else { return }
        app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: where_.midX, dy: where_.midY))
            .tap()
    }

    // MARK: - 2 · Everything the lock lets her lose comes back through its own door

    /// **The half of a fold a composition lock cannot see.**
    ///
    /// `FeltRegisterClassifications.folded` lets an element disappear from a
    /// screen on one condition: that the entry names the control it went behind
    /// and that control is on the screen. The lock checks the second half. This
    /// checks the first, and it is the one that matters — a name alone would let
    /// anything be deleted and pointed at a nearby button.
    ///
    /// Every entry for the Detail, driven: read the screen shut, assert the
    /// element is not there, open the door the entry names, and find it again by
    /// the key the lock compares on. Not by a substring of its words: **the same
    /// key**, so an element that came back smaller, renamed, or as a different
    /// kind of thing is not the element that went away.
    func testEveryFoldedElementComesBackThroughTheDoorItsEntryNames() {
        let entries = FeltRegisterClassifications.folded.filter { $0.screen == "detail" }
        XCTAssertFalse(entries.isEmpty, "no element on the Detail is classified as folded")

        let app = launch(["START_TAB=mandala", "OPEN_DETAIL=33"])
        XCTAssertTrue(herScreen(app), "her Detail never arrived")
        Thread.sleep(forTimeInterval: 2.0)

        let shut = Set(ScreenReader.read(app).map(\.key))
        for entry in entries {
            XCTAssertFalse(shut.contains(where: { $0.contains(entry.keyContains) }),
                           "“\(entry.keyContains)” is on her screen with the library shut — it is "
                           + "classified as folded and it is not folded")
        }

        for door in Set(entries.map(\.behind)) {
            XCTAssertTrue(unfold(door, in: app),
                          "“\(door)” is named as the door \(entries.count) element(s) went behind, "
                          + "and it never opened")
            Thread.sleep(forTimeInterval: 1.2)
        }

        let open = Set(ScreenReader.read(app).map(\.key))
        var lost: [String] = []
        for entry in entries where !open.contains(where: { $0.contains(entry.keyContains) }) {
            lost.append("“\(entry.keyContains)” never came back out of “\(entry.behind)”")
        }
        XCTAssertTrue(lost.isEmpty,
                      "the composition lock was told these were folded, and they are gone:\n"
                      + lost.joined(separator: "\n"))
    }

    // MARK: - 3 · Both shelves hold at the largest type on the smallest screen

    /// §4.3, extended to what the folds now hold. The largest accessibility size
    /// is where a control whose words tripled and whose box did not comes apart,
    /// and until this phase the six reference sections were never read at that
    /// size with their fold open. They are now, and so is the register.
    ///
    /// Width is asserted everywhere; height is not, because her Detail scrolls
    /// and a column taller than the glass is what a scroll view is for.
    func testBothShelvesHoldWithTheLargestTypeOnTheSmallestScreen() {
        let app = launch(["START_TAB=mandala", "OPEN_DETAIL=33"], type: true)
        XCTAssertTrue(herScreen(app), "her Detail never arrived at the largest type size")
        Thread.sleep(forTimeInterval: 2.0)

        // `go deeper` is conditional on her carrying reference matter at all, so
        // a Śakti without it has one shelf and not two; `her moments` is
        // unconditional and its absence is a failure. Both are opened from the
        // top down, because opening the first pushes the second further below
        // the glass and `reveal` has to run again for it.
        var opened = 0
        for name in ["her moments", "go deeper"] {
            let control = shelf(app, name)
            guard control.exists else {
                XCTAssertNotEqual(name, "her moments",
                                  "the register's shelf is unconditional and it is not on her screen")
                continue
            }
            XCTAssertTrue(reveal(control, in: app),
                          "“\(name)” never came within reach at the largest accessibility size")
            XCTAssertGreaterThanOrEqual(control.frame.height, 43.5,
                                        "“\(name)” is \(control.frame.height) pt tall at the "
                                        + "largest accessibility size")
            XCTAssertTrue(press(control, until: openedShelf(app, name), attempts: 3, eachTimeout: 10),
                          "“\(name)” never opened at the largest accessibility size")
            opened += 1
            Thread.sleep(forTimeInterval: 1.2)
        }
        XCTAssertGreaterThanOrEqual(opened, 1, "no shelf was opened, so nothing below was read")

        let bounds = app.frame
        var failures: [String] = []
        var read = 0
        for element in app.staticTexts.allElementsBoundByIndex {
            guard element.exists, element.frame.width > 0, element.frame.height > 0 else { continue }
            read += 1
            let f = element.frame
            if f.minX < -0.5 || f.maxX > bounds.width + 0.5 {
                failures.append(String(format: "“%@” spans %.1f…%.1f on a %.0f pt screen",
                                       element.label, f.minX, f.maxX, bounds.width))
            }
        }
        XCTAssertGreaterThanOrEqual(read, 10,
                                    "only \(read) strings were read with the library open — the "
                                    + "shelves never opened, and this check judged the screen shut")

        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "library-open-ax5"
        shot.lifetime = .keepAlways
        add(shot)

        XCTAssertTrue(failures.isEmpty,
                      "With the library open at the largest accessibility size, text left the "
                      + "screen sideways:\n" + failures.joined(separator: "\n"))
    }
}

// MARK: - The vocabulary itself, held to the shape of a claim

/// `FeltRegisterClassifications.folded` is the one place in the composition lock
/// where an element may leave a screen. `ClassifiedShift`'s own history is the
/// reason this class exists: a bound written `keyContains: "|"` matches every key
/// there is, and three of the shift entries are written exactly that way, so a
/// fold entry written loosely would let a whole screen empty itself and stay
/// green.
///
/// An entry is a claim about one element and the door it went behind. These are
/// the shape of that claim.
final class TheFoldVocabularyTests: XCTestCase {

    func testNoFoldEntryCanStandForAWholeScreen() {
        for entry in FeltRegisterClassifications.folded {
            let parts = entry.keyContains.components(separatedBy: "|")
            XCTAssertGreaterThanOrEqual(parts.count, 2,
                                        "“\(entry.keyContains)” does not name an element's type — a "
                                        + "key is `type|label|ordinal`, and an entry has to say "
                                        + "which kind of thing went behind the door")
            let words = parts.dropFirst().joined(separator: "|")
            XCTAssertGreaterThanOrEqual(words.count, 6,
                                        "“\(entry.keyContains)” names \(words.count) characters of "
                                        + "one element's words — that is a screenful, not an "
                                        + "element")
            XCTAssertFalse(entry.behind.isEmpty,
                           "“\(entry.keyContains)” is folded behind nothing at all")
            XCTAssertGreaterThanOrEqual(entry.reason.count, 60,
                                        "“\(entry.keyContains)” went behind “\(entry.behind)” for "
                                        + "\(entry.reason.count) characters of reason. An entry "
                                        + "with a vague reason is a regression somebody talked "
                                        + "their way past.")
            XCTAssertFalse(entry.screen.isEmpty)
        }
    }

    // MARK: - The other vocabulary this phase added: a shift that names a device

    /// A device is one of the three the lock actually runs on. `deviceKey`
    /// derives "promax" / "phone" / "se" from the screen's own points and names
    /// the baseline directory with it; an entry pinned to anything else is an
    /// entry that can never answer for anything, and would leave the blanket
    /// bound below it silently in charge of a move somebody thought they had
    /// written down.
    func testEveryDeviceAShiftNamesIsOneTheLockRunsOn() {
        let known: Set<String> = ["se", "phone", "promax"]
        for shift in ClassifiedShift.table {
            guard let device = shift.device else { continue }
            XCTAssertTrue(known.contains(device),
                          "“\(shift.keyContains)” on \(shift.screen) is classified for a device "
                          + "called “\(device)”, and the lock runs on \(known.sorted()). An entry "
                          + "no run can match classifies nothing.")
        }
    }

    /// **And it is the entry that actually answers.**
    ///
    /// `allowance` takes the *first* match, so a device-specific entry written
    /// below a blanket one for the same element is dead: the blanket entry
    /// answers on every device and the sharper number is never consulted. That
    /// is a silent failure — the lock still passes, at the looser bound, with a
    /// sentence in the file saying otherwise. So each one is asked to answer for
    /// itself.
    func testEveryDeviceSpecificEntryIsTheOneThatAnswersForItsDevice() {
        for shift in ClassifiedShift.table {
            guard let device = shift.device else { continue }
            let answered = ClassifiedShift.allowance(screen: shift.screen,
                                                     key: shift.keyContains,
                                                     device: device)
            XCTAssertEqual(answered?.reason, shift.reason,
                           "“\(shift.keyContains)” on \(shift.screen)/\(device) is classified at "
                           + "\(shift.settlesDescription) ± \(shift.maxDelta), and a broader entry "
                           + "above it answers instead. Move it up: the first match wins.")
        }
    }

    /// Every door named in the vocabulary is a door `TheLibraryFoldUITests`
    /// actually opens. A screen added to `folded` whose door nobody opens would
    /// be a disappearance with a sentence beside it and nothing checking the
    /// sentence.
    func testEveryScreenInTheVocabularyIsDrivenBySomething() {
        let screens = Set(FeltRegisterClassifications.folded.map(\.screen))
        XCTAssertEqual(screens, ["detail"],
                       "the fold vocabulary now covers \(screens.sorted()), and only the Detail's "
                       + "doors are opened by a test. Add the driving before the entry.")
    }
}
