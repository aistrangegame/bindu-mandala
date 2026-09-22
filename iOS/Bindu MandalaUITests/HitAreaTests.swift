import XCTest

// MARK: - The eight controls a thumb could not find
//
// Audit §H4 swept all 28 `Button` sites and both non-`Button` interactives and
// came back with eight under 44 × 44 — the worst a bare `Text` at about 19 pt
// tall, which is the *exit* from the Bindu. FIDELITY rule 4 names the bar:
// **interactive controls ≥ 44 × 44 pt**.
//
// This file measures them on a running app. `XCUIElement.frame` is the frame
// iOS itself hit-tests and the frame VoiceOver announces — so a control that
// passes here passes for a thumb and for a finger that cannot see. A source
// grep would only prove that somebody typed `.frame(minHeight: 44)` somewhere
// near it; `HitAreaIdiomTests` in the unit target does that much as a second
// lock, for the two sites a launched app cannot reach.
//
// Every growth here is paid for in the same view's own padding, so the drawn
// composition does not move — `FeltRegisterSnapshots` is the proof of that half,
// and the two tests are meant to be read together.

final class HitAreaTests: XCTestCase {

    /// FIDELITY rule 4, as a number.
    private let minimum: CGFloat = 44

    override func setUp() { continueAfterFailure = true }

    private func launch(_ extra: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = SnapshotScreen.base + extra
        app.launch()
        return app
    }

    private func assertReachable(_ element: XCUIElement, _ what: String,
                                 file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(element.waitForExistence(timeout: 25), "\(what): never appeared",
                      file: file, line: line)
        guard element.exists else { return }
        let f = element.frame
        XCTAssertGreaterThanOrEqual(f.height, minimum,
                                    String(format: "%@: %.1f pt tall — under FIDELITY rule 4's 44",
                                           what, f.height), file: file, line: line)
        XCTAssertGreaterThanOrEqual(f.width, minimum,
                                    String(format: "%@: %.1f pt wide — under FIDELITY rule 4's 44",
                                           what, f.width), file: file, line: line)
    }

    // 1 · The worst of the eight, and the one that matters most: the way *out*
    //     of the Bindu. Its padding sat on the `Button` rather than on the
    //     label, so the tappable thing was the bare line of text.
    func testReturnToTheFieldIsReachable() {
        let app = launch(["START_TAB=mandala", "OPEN_SILENCE"])
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'return to the field'")).firstMatch
        assertReachable(control, "LalitaSourceView · return to the field")
    }

    // 2 · The Field's way into an āvaraṇa's threshold. Reached by opening a ring.
    func testTheThresholdRowIsReachable() {
        let app = launch(["START_TAB=102"])
        let ring = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'Āvaraṇa'")).firstMatch
        XCTAssertTrue(ring.waitForExistence(timeout: 25), "the Field never listed a ring")
        ring.tap()
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'the threshold'")).firstMatch
        assertReachable(control, "TheHundredTwoView · the threshold ›")
    }

    // 3 · The descent film's only exit. Opened by `OPEN_FILM` rather than by
    //     scrolling Settings to its fourth card: that route needs four flicks
    //     down a sheet whose height differs by device, and it failed outright on
    //     a loaded host — which is a test that reports on the machine it ran on
    //     rather than on the control it is named after.
    func testFilmCloseIsReachable() {
        let app = launch(["START_TAB=well", "OPEN_FILM"])
        let control = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'close'")).firstMatch
        assertReachable(control, "DescentFilmView · CLOSE")
    }

    // 4 · Today's celestial strip — the one line that opens the Nityā.
    func testCelestialStripIsReachable() {
        let app = launch(["START_TAB=rite"])
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] '›' AND NOT (label CONTAINS[c] 'know her')"))
            .firstMatch
        assertReachable(control, "DailyRiteView · celestial strip")
    }

    // 5 · The Rite's way into her full presence.
    func testKnowHerIsReachable() {
        let app = launch(["START_TAB=rite"])
        let control = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'know her'")).firstMatch
        assertReachable(control, "RiteBlockView · know her ›")
    }

    // 6 · Settings' rename field — the only place the practitioner types a name
    //     of his own into the instrument.
    func testRenameFieldIsReachable() {
        let app = launch(["START_TAB=well"])
        SnapshotScreen.openSettings(app)
        let control = app.textFields.firstMatch
        assertReachable(control, "SettingsView · rename field")
    }

    // 7 · The Portrait's export, behind the long press that makes it.
    func testHoldThisImageIsReachable() {
        let app = launch(["START_TAB=memory"])
        XCTAssertTrue(SnapshotScreen.text(app, "she is felt, not measured"),
                      "the Portrait never arrived")
        Thread.sleep(forTimeInterval: 2.4)
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45))
            .press(forDuration: 1.4)
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'hold this image'")).firstMatch
        assertReachable(control, "PortraitMandalaView · hold this image")
    }

    // The eighth — Detail's hold-to-cross pill — appears only when a Śakti is
    // *ready* to cross, which takes a practice history no launched simulator
    // has. It is pinned in the unit target instead (`HitAreaIdiomTests`), which
    // reads the source of the pill itself.
}
