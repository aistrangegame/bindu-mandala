import XCTest

/// The margin, on the running app.
///
/// Everything here is driven by a finger, because the three things this phase
/// claims are things only a running app can answer: that the doors are where a
/// walker can press them without scrolling, that what he typed comes back, and
/// that nothing in the whole spoken surface is a digit.
///
/// `EPHEMERAL_STORE` is what makes it re-runnable — every launch reads the
/// instrument as a new install does, his own store is never opened, and the
/// notes these tests write die with the process. `SYNC_OFF` means no row is ever
/// posted. Every press goes through `press(_:until:)` with a sentinel that
/// exists **only** on the destination, because a raw `tap()` is a reliable way
/// to attempt a press and not to land one.
final class TheMarginUITests: XCTestCase {

    override func setUp() { continueAfterFailure = false }

    private static let base = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                               "ENERGY_POS=29", "EPHEMERAL_STORE", "START_TAB=well"]

    private func launch(_ extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = Self.base + extra
        app.launch()
        return app
    }

    /// Settings, reached the way a finger reaches it.
    private func openSettings(_ app: XCUIApplication) -> XCUIElement {
        SnapshotScreen.openSettings(app)
        let door = app.buttons["Leave a note"]
        XCTAssertTrue(door.waitForExistence(timeout: 20), "Settings should offer the margin")
        return door
    }

    // MARK: The doors are reachable without a scroll

    /// **The margin is the first section, and this is what that buys.** Its two
    /// doors are hittable the moment Settings opens — no flick, no guess at
    /// where one landed. `exists` would be true for a control at the foot of a
    /// sheet that is off-screen on every width, which is why this asks
    /// `isHittable`.
    func testBothDoorsAreUnderHisFingerTheMomentSettingsOpens() {
        let app = launch()
        let leave = openSettings(app)
        let what = app.buttons["What you have left"]
        XCTAssertTrue(leave.isHittable, "\"Leave a note\" is not reachable without scrolling")
        XCTAssertTrue(what.exists && what.isHittable,
                      "\"What you have left\" is not reachable without scrolling")
    }

    /// Every target in the margin clears 44 × 44 — the two doors, and a row in
    /// the list once there is one.
    func testEveryTargetInTheMarginIsBigEnough() {
        let app = launch()
        let leave = openSettings(app)
        for door in [leave, app.buttons["What you have left"]] {
            XCTAssertGreaterThanOrEqual(door.frame.height, 44, "\(door.label) is under 44 pt tall")
            XCTAssertGreaterThanOrEqual(door.frame.width, 44, "\(door.label) is under 44 pt wide")
        }

        write("the way out is hard to find near the bezel", in: app, from: leave)
        let list = openList(app)
        let row = list.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "near the bezel")).firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 10))
        XCTAssertGreaterThanOrEqual(row.frame.height, 44, "a note's row is under 44 pt tall")
        XCTAssertGreaterThanOrEqual(row.frame.width, 44, "a note's row is under 44 pt wide")
    }

    // MARK: His words come back

    /// The whole gesture, end to end: he opens the margin, says what he saw,
    /// leaves, and finds it in his list — and then opens it and reads it whole.
    ///
    /// Each of the three pages is attached as a screenshot: FIDELITY rule 7
    /// asks for a human's eye on a small screen and a large one, and a test that
    /// only asserts frames cannot catch an atmosphere that drained out.
    func testHeLeavesANoteAndFindsItAgain() {
        let app = launch()
        let leave = openSettings(app)
        let words = "the descent is hard to leave from the deepest station"

        write(words, in: app, from: leave)

        let list = openList(app)
        let row = list.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "hard to leave")).firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 12),
                      "his note is not in the list he was promised it would be in")

        shoot(app, "margin-list")

        // …and whole, in the reader.
        let whole = app.staticTexts.matching(NSPredicate(format: "label == %@", words)).firstMatch
        XCTAssertTrue(press(row, until: whole, eachTimeout: 10),
                      "the note does not open to be read in full")
        shoot(app, "margin-note")
    }

    /// One screenshot, kept, named for the device it was read on.
    private func shoot(_ app: XCUIApplication, _ name: String) {
        let bounds = app.frame
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "\(SnapshotStore.deviceClass(width: bounds.width, height: bounds.height))-\(name)"
        shot.lifetime = .keepAlways
        add(shot)
    }

    /// Opening the composer and leaving without typing writes nothing — the
    /// letter's discipline, on the glass. An empty margin says so as a *state*,
    /// never as a quantity.
    func testAComposerHeAbandonsLeavesNothingBehind() {
        let app = launch()
        let leave = openSettings(app)

        XCTAssertTrue(press(leave, until: app.textViews["marginComposer"], eachTimeout: 12),
                      "the composer did not open")
        XCTAssertTrue(app.staticTexts["Say what you see. It will be read."].exists,
                      "the empty composer does not say what it is for")
        back(app, to: "Leave a note")

        let list = openList(app)
        XCTAssertTrue(list.staticTexts["Nothing left here yet."].waitForExistence(timeout: 10),
                      "a note he never typed into ended up in his list")
    }

    // MARK: Law 2 · nothing here is a quantity, and nothing is a digit

    /// **Every label and every value in the whole margin, read off the running
    /// app, with no numeral in any of them.** An accessibility *value* is where
    /// a scale reaches a voice without ever becoming ink, which is the lesson
    /// Phase 5 learned, so both are read. His own words are excluded from the
    /// digit check and from nothing else — he may write whatever he likes, and
    /// the instrument may never add a number to it.
    func testNothingInTheMarginIsSpokenAsANumber() {
        let app = launch()
        let leave = openSettings(app)
        let words = "the corridor doors are hard to tell apart"
        write(words, in: app, from: leave)
        let list = openList(app)

        // Scoped to the margin's own screen: a sheet leaves the screen beneath
        // it in the tree, and the Well's "2nd Avaraṇa" is not this phase's to
        // answer for.
        let root = list.otherElements["marginListRoot"]
        XCTAssertTrue(root.waitForExistence(timeout: 10),
                      "the margin's own container is not in the tree — this check would otherwise "
                      + "read the whole app and prove nothing about the margin")

        var read = 0
        for kind in [root.staticTexts, root.buttons, root.textViews, root.images] {
            for element in kind.allElementsBoundByIndex where element.exists {
                let spoken = [element.label, (element.value as? String) ?? ""]
                for said in spoken where !said.isEmpty {
                    read += 1
                    let withoutHisWords = said.replacingOccurrences(of: words, with: "")
                    XCTAssertFalse(withoutHisWords.contains(where: \.isNumber),
                                   """
                                   the margin says "\(said)" — a numeral in the spoken surface. \
                                   A list of his notes is his own words handed back; a count, an \
                                   ordinal or a date said as a digit is the instrument measuring.
                                   """)
                    for forbidden in ["note 1", "notes)", "of 1", "1 note", "total"] {
                        XCTAssertFalse(said.lowercased().contains(forbidden),
                                       "the margin counts out loud: \"\(said)\"")
                    }
                }
            }
        }
        XCTAssertGreaterThan(read, 3, "the reader found almost nothing — it is proving nothing")
    }

    // MARK: Backgrounding mid-sentence

    /// **He is interrupted while typing, and his words are still there.**
    ///
    /// The composer is left through the home button rather than through its own
    /// back control, which is the case `onDisappear` never sees: the app goes
    /// inactive with an unsaved draft and a debounce still pending. On the
    /// return the words are on the screen, and they are in his list afterwards.
    ///
    /// **What this can and cannot prove.** It drives the real `scenePhase`
    /// transition on the real app, so a composer that dropped its draft on
    /// resume, or that came back blank, fails here. It cannot stage a *jetsam
    /// kill*: an `EPHEMERAL_STORE` launch keeps the whole store in memory, so a
    /// terminated process takes the note with it whatever the code does, and
    /// staging the kill against his own store on disk is what law 8 forbids.
    /// The save on `.inactive` itself is held in source by
    /// `LawsTheMarginTests.testTheComposerWritesOnlyWhatHeTyped`.
    func testBeingInterruptedMidSentenceDoesNotCostHimTheSentence() {
        let app = launch()
        let leave = openSettings(app)
        let words = "the way out is hard to find near the bezel"

        let editor = app.textViews["marginComposer"]
        XCTAssertTrue(press(leave, until: editor, eachTimeout: 12), "the composer did not open")
        if !editor.hasFocus { editor.tap() }
        editor.typeText(words)

        // Straight out, inside the debounce window — the app goes inactive with
        // a draft that nothing has written down yet.
        XCUIDevice.shared.press(.home)
        app.activate()

        XCTAssertTrue(editor.waitForExistence(timeout: 20),
                      "the composer did not come back after the interruption")
        XCTAssertTrue((editor.value as? String)?.contains(words) == true,
                      "what he had typed is gone after backgrounding")

        back(app, to: "Leave a note")
        let list = openList(app)
        let row = list.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "near the bezel")).firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 12),
                      "the note he was interrupted in the middle of never reached his list")
    }

    // MARK: The sheet does not grow with his writing

    /// **The claim the door exists to make, proven on the glass.** If the notes
    /// rendered inline, Settings would be longer the more he had written, and
    /// "Re-enter the Homecoming" would sink a little further with every note —
    /// a measure *drawn* rather than printed, which is exactly the Phase 3.8
    /// breach. So the distance the margin occupies is measured with an empty
    /// margin and again with notes in it, and it is the same distance.
    ///
    /// It also prints that distance, which is the number
    /// `FeltRegisterClassifications` classifies the whole sheet's translation by.
    func testTheSheetIsTheSameLengthHoweverMuchHeHasWritten() {
        let app = launch()
        let leave = openSettings(app)
        let empty = marginHeight(app)
        XCTAssertGreaterThan(empty, 0, "the margin's own two rows could not be measured")

        for words in ["the corridor doors are hard to tell apart",
                      "her name is cut on the smallest screen",
                      "the bell sounds twice on a fast return"] {
            write(words, in: app, from: app.buttons["Leave a note"])
        }

        let after = marginHeight(app)
        let bounds = app.frame
        let device = SnapshotStore.deviceClass(width: bounds.width, height: bounds.height)
        print("MARGIN-HEIGHT \(device) empty=\(empty) after=\(after) "
              + "homecoming=\(app.buttons["Re-enter the Homecoming"].frame.minY)")

        XCTAssertEqual(after, empty, accuracy: 0.5,
                       """
                       Settings grew by \(after - empty) pt because he wrote three notes. The \
                       sheet must be the same length on the first day and the thousandth — the \
                       notes live behind a door for exactly this reason.
                       """)
        _ = leave
    }

    /// From the top of the margin's own title to the top of the next section's —
    /// the whole of what this phase adds to the sheet, spacing included.
    private func marginHeight(_ app: XCUIApplication) -> Double {
        let mine = app.staticTexts["THE MARGIN"]
        let next = app.staticTexts["DAILY RHYTHM"]
        guard mine.waitForExistence(timeout: 12), next.exists else { return 0 }
        return Double(next.frame.minY - mine.frame.minY)
    }

    // MARK: The still path

    /// **Reduce motion reaches the margin, and there is nothing there to still.**
    /// The whole walk is driven again with the system's own Reduce Motion
    /// forced: the margin introduces no ambient motion, so the still path is the
    /// only path, and this proves it by walking it rather than by reading the
    /// source. A screen whose still path had been merely *asserted* would pass a
    /// grep and fail a finger.
    func testTheStillPathWalksTheWholeMargin() {
        let app = launch(["REDUCE_MOTION"])
        let leave = openSettings(app)
        let words = "the rite reads oddly on the smallest screen"
        write(words, in: app, from: leave)

        let list = openList(app)
        let row = list.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "reads oddly")).firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 12),
                      "a walker with reduce motion on cannot reach his own notes")
    }

    // MARK: - Driving

    /// Open the composer from `door`, type `words`, and come back to Settings.
    private func write(_ words: String, in app: XCUIApplication, from door: XCUIElement) {
        let editor = app.textViews["marginComposer"]
        XCTAssertTrue(press(door, until: editor, eachTimeout: 12), "the composer did not open")
        shoot(app, "margin-composer")
        // Focused on appear, so the keyboard is already up; the tap is belt and
        // braces against a host that lost the first responder.
        if !editor.hasFocus { editor.tap() }
        editor.typeText(words)
        XCTAssertTrue(app.staticTexts[words].waitForExistence(timeout: 8)
                        || (editor.value as? String)?.contains(words) == true,
                      "what he typed is not on the screen he typed it on")
        back(app, to: "Leave a note")
    }

    /// Leave the current page and wait until a Settings door is pressable again.
    private func back(_ app: XCUIApplication, to door: String) {
        let out = app.buttons["Back to settings"]
        XCTAssertTrue(out.waitForExistence(timeout: 8), "there is no way back to Settings")
        let home = app.buttons[door]
        for _ in 0..<3 {
            out.tap()
            if home.waitForExistence(timeout: 6), home.isHittable { return }
            if !out.exists { break }
        }
        XCTAssertTrue(home.waitForExistence(timeout: 8) && home.isHittable,
                      "the walk did not land back on Settings")
    }

    /// Open "What you have left" and return the app, on that screen.
    @discardableResult
    private func openList(_ app: XCUIApplication) -> XCUIApplication {
        let door = app.buttons["What you have left"]
        XCTAssertTrue(door.waitForExistence(timeout: 12))
        // The list's own header, which is true only once the list has arrived.
        let arrived = app.staticTexts["marginListTitle"]
        XCTAssertTrue(press(door, until: arrived, eachTimeout: 12), "the list did not open")
        return app
    }
}
