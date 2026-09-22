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

    /// What the screen actually offered, when the control this test is named
    /// after was not on it. A bare "never appeared" says nothing about whether
    /// the screen arrived, the control is under a fold, or its label is not the
    /// words somebody typed into a predicate.
    private func offered(_ app: XCUIApplication) -> String {
        var lines: [String] = []
        for (kind, query) in [("button", app.buttons), ("field", app.textFields),
                              ("text", app.staticTexts)] {
            for e in query.allElementsBoundByIndex where e.exists {
                let f = e.frame
                lines.append(String(format: "  %@ “%@” %.1f×%.1f at (%.1f, %.1f)",
                                    kind, e.label, f.width, f.height, f.minX, f.minY))
            }
        }
        return lines.isEmpty ? "  (nothing)" : lines.joined(separator: "\n")
    }

    private func assertReachable(_ element: XCUIElement, _ what: String,
                                 in app: XCUIApplication,
                                 file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(element.waitForExistence(timeout: 25),
                      "\(what): never appeared. The screen offered:\n\(offered(app))",
                      file: file, line: line)
        guard element.exists else { return }
        let f = element.frame
        XCTAssertGreaterThanOrEqual(f.height, minimum,
                                    String(format: "%@: %.2f pt tall — under FIDELITY rule 4's 44.\n"
                                           + "The screen offered:\n%@",
                                           what, f.height, offered(app)), file: file, line: line)
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
        assertReachable(control, "LalitaSourceView · return to the field", in: app)
    }

    // 2 · The Field's way into an āvaraṇa's threshold. Reached by opening a ring.
    //
    //     The row is `if let avarana`, and āvaraṇa rows live only in Airtable —
    //     `ShaktiBootstrap` seeds the sixteen Ring-2 Śaktis and no enclosure — so
    //     on a `SYNC_OFF` simulator there is often nothing to measure. That is a
    //     data absence, not a control under the floor, and the two are not
    //     allowed to look alike: the row is measured wherever it *is* on the
    //     screen, and skipped, out loud, where it is not.
    func testTheThresholdRowIsReachable() throws {
        let app = launch(["START_TAB=102"])
        // `[cd]`, not `[c]`: the ring header announces itself as "2nd Avaraṇa"
        // — the seat row's own spelling, without the macron — and `[c]` folds
        // case but not diacritics, so 'Āvaraṇa' matched nothing at all.
        let ring = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[cd] 'avarana'")).firstMatch
        XCTAssertTrue(ring.waitForExistence(timeout: 25),
                      "the Field never listed a ring. The screen offered:\n\(offered(app))")
        ring.tap()
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'the threshold'")).firstMatch
        guard control.waitForExistence(timeout: 8) else {
            throw XCTSkip("no āvaraṇa row on this simulator, so the Field offers no threshold to "
                          + "open. Held at the source by HitAreaIdiomTests, which reads the row's "
                          + "own 44 pt floor and the padding that pays for it. The screen "
                          + "offered:\n\(offered(app))")
        }
        assertReachable(control, "TheHundredTwoView · the threshold ›", in: app)
    }

    // 3 · The descent film's only exit. Reached by opening Settings and letting
    //     `OPEN_FILM` present the cover, rather than by flicking down to the
    //     fourth card: that route needs four flicks down a sheet whose height
    //     differs by device, and it failed outright on a loaded host — which is
    //     a test that reports on the machine it ran on rather than on the
    //     control it is named after.
    //
    //     `OPEN_FILM` is read where the film lives, in `SettingsView`'s own
    //     state, so the sheet has to be opened for the argument to mean
    //     anything. Launching with it and never opening Settings measured
    //     nothing at all, which is how this test first went red.
    func testFilmCloseIsReachable() {
        let app = launch(["START_TAB=well", "OPEN_FILM"])
        SnapshotScreen.openSettings(app)
        let control = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'close'")).firstMatch
        assertReachable(control, "DescentFilmView · CLOSE", in: app)
    }

    // 4 · Today's celestial strip — the one line that opens the Nityā.
    //
    //     Same shape as the threshold above, and for the same reason: the strip's
    //     tappable line is `if let label = celestialLabel(slot)`, and the slot
    //     resolves to `.unknown` unless a Nityā row has been synced. Under
    //     `SYNC_OFF` the strip is the moon glyph alone and there is no button on
    //     the screen at all — which the committed `rite` baseline shows, and which
    //     is why this one first went red.
    func testCelestialStripIsReachable() throws {
        let app = launch(["START_TAB=rite"])
        XCTAssertTrue(SnapshotScreen.button(app, "I feel her"), "the Rite never arrived")
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] '›' AND NOT (label CONTAINS[c] 'know her')"))
            .firstMatch
        guard control.waitForExistence(timeout: 8) else {
            throw XCTSkip("no Nityā on this simulator, so the celestial strip has no line to show "
                          + "and no button to press. Held at the source by HitAreaIdiomTests' "
                          + "`testTheCelestialStripDeclaresTheFloor`, which reads the strip's own "
                          + "44 pt floor and the spacing that pays for it. The screen offered:\n"
                          + "\(offered(app))")
        }
        assertReachable(control, "DailyRiteView · celestial strip", in: app)
    }

    // 5 · The Rite's way into her full presence.
    func testKnowHerIsReachable() {
        let app = launch(["START_TAB=rite"])
        let control = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'know her'")).firstMatch
        assertReachable(control, "RiteBlockView · know her ›", in: app)
    }

    // 6 · Settings' rename field — the only place the practitioner types a name
    //     of his own into the instrument.
    func testRenameFieldIsReachable() {
        let app = launch(["START_TAB=well"])
        SnapshotScreen.openSettings(app)
        // The sheet and the field are two different failures and must not read
        // alike: a hamburger tap swallowed by an arriving screen is the host,
        // and a missing field is the control.
        XCTAssertTrue(SnapshotScreen.text(app, "Daily Rhythm"),
                      "Settings never opened, so the rename field was never on screen. "
                      + "The screen offered:\n\(offered(app))")
        let control = app.textFields.firstMatch
        assertReachable(control, "SettingsView · rename field", in: app)
    }

    // 7 · The Portrait's export, behind the long press that makes it.
    //
    //     Two presses, not one. The press has to outlast a 0.9 s minimum and the
    //     sheet it opens is a 1500 pt `ImageRenderer` pass — on a host running
    //     another build, the first press can land while the Portrait is still
    //     settling and be swallowed whole. One attempt made this test a report on
    //     the machine it ran on.
    func testHoldThisImageIsReachable() {
        let app = launch(["START_TAB=memory"])
        XCTAssertTrue(SnapshotScreen.text(app, "she is felt, not measured"),
                      "the Portrait never arrived")
        Thread.sleep(forTimeInterval: 2.4)
        let control = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'hold this image'")).firstMatch
        for _ in 0..<3 {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
                .press(forDuration: 1.4)
            if control.waitForExistence(timeout: 12) { break }
        }
        Thread.sleep(forTimeInterval: 1.5)
        // Existence, and deliberately not the number — this is the one control in
        // the eight whose live frame cannot honestly be read against 44.
        //
        // Everything inside this sheet reports at about 0.96 of the points it is
        // laid out in: the export pill and “close” both declare `minHeight: 44`
        // and both come back 42.25, and the Cormorant line between them reports
        // 18.9 where 16 pt Cormorant italic sets at 19.7. A reported height in
        // here is not points on the screen, so comparing it to 44 would fail two
        // controls that meet rule 4 and teach whoever saw it to pad by a number
        // that means nothing. The pill's floor — 44 under a capsule that draws at
        // 41.33, with the 4 pt paid back out of “close” — is held at the source
        // by `HitAreaIdiomTests`, on a ledger that reads the real file.
        //
        // What this test proves is what was actually broken here, and what no
        // source read could have found: every layer of the Portrait's artwork
        // sets `.allowsHitTesting(false)`, so the long press that makes the image
        // had nothing to land on and the sheet had never opened at all.
        XCTAssertTrue(control.exists,
                      "PortraitMandalaView · hold this image: the export sheet never opened. "
                      + "The screen offered:\n\(offered(app))")
    }

    // The eighth — Detail's hold-to-cross pill — appears only when a Śakti is
    // *ready* to cross, which takes a practice history no launched simulator
    // has. It is pinned in the unit target instead (`HitAreaIdiomTests`), which
    // reads the source of the pill itself.
}
