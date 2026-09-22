import XCTest

// MARK: - MandalaLightReachTests — the lit instrument, on a running app
//
// Phase 5. `MandalaLightTests` proves the arithmetic off-device; this proves
// that turning the light on does not cost the screen anything it already had.
//
// Everything here launches with **`MANDALA_LIGHT=on`**, which is the whole
// point: the existing suites run the Mandala with the flag off, so without this
// file the lit path would ship having been rendered by nobody. The three things
// checked are the three a new lighting pass is most likely to take away —
//
//   · a voice still reaches all the seats and the enclosures, and still hears
//     no numeral (a veil that dimmed an element out of the tree, or a light
//     that put a brightness into a label, would show up here and nowhere else);
//   · the hamburger is still on the glass, at every size including the SE — the
//     RootView oversized-child trap, which any new full-bleed layer springs;
//   · nothing the light draws is hittable, so the seats a finger reaches are
//     still exactly the seats the shipped canvas offered.
//
// The seats are drawn into one `Canvas` and are not elements; the spoken layer
// beside it is. So "the light did not eat a seat" is asked of the spoken layer,
// which is the only tree there is.

final class MandalaLightReachTests: XCTestCase {

    override func setUp() { continueAfterFailure = true }

    /// The lit Mandala, on a store that lives and dies with the launch.
    private func litMandala() -> XCUIApplication {
        Reach.app(["START_TAB=mandala", "MANDALA_LIGHT=on"])
    }

    /// The same Mandala with the phase flag off — the control for anything that
    /// could be the host rather than the light.
    private func unlitMandala() -> XCUIApplication {
        Reach.app(["START_TAB=mandala"])
    }

    /// The hamburger, found where it lives rather than by a name this phase
    /// would have had to invent: the shell exposes no label for it (audit §H5),
    /// so it is the 44×44 control in the top-trailing corner.
    private func hamburger(in app: XCUIApplication) -> XCUIElement? {
        let bounds = app.frame
        return app.buttons.allElementsBoundByIndex.first {
            $0.exists && $0.frame.maxX > bounds.width - 76
                && $0.frame.minY < 140 && $0.frame.height >= 40 && $0.frame.width >= 40
        }
    }

    /// Press until the menu is up, in the shape DECISIONS.md ruled for this
    /// harness (*"The press that was never delivered"*): under load XCTest's
    /// virtual digitizer can be torn down between touch-down and touch-up, so a
    /// press is cancelled and the button's action never runs. Retry — but stop
    /// pressing the moment the element is no longer hittable, because then
    /// something *did* happen and a second press would land somewhere else.
    private func opensTheMenu(_ app: XCUIApplication,
                              attempts: Int = 5,
                              eachTimeout: TimeInterval = 8) -> Bool {
        let settings = app.buttons.matching(NSPredicate(format: "label == 'Settings'")).firstMatch
        guard let button = hamburger(in: app) else { return false }
        for attempt in 0..<attempts {
            if attempt > 0 && !button.isHittable {
                return settings.waitForExistence(timeout: eachTimeout)
            }
            button.tap()
            if settings.waitForExistence(timeout: eachTimeout) { return true }
        }
        return false
    }

    /// **The light does not take a seat out of the tree.**
    ///
    /// Idea 30 veils the deep enclosures until a walker is still and close, and
    /// the obvious way to get that wrong is to stop drawing them — which would
    /// take them out of a voice's reach as well as out of sight. The spoken
    /// layer is independent of the veil by construction, and this is where that
    /// is actually true or not.
    func testTheLitFieldIsStillReachedByAVoice() {
        let app = litMandala()
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the lit Mandala never arrived")

        let field = Reach.spokenField(app)
        XCTAssertGreaterThanOrEqual(field.count, 17,
                                    "the lit canvas has gone silent: the sixteen seated Karṣiṇīs "
                                    + "and their enclosure should each still be an element")
        let seats = field.filter { $0.label.contains("of the one hundred and two") }
        let enclosures = field.filter { !$0.label.contains("of the one hundred and two") }
        XCTAssertGreaterThanOrEqual(seats.count, 16,
                                    "the light has cost the field \(16 - seats.count) seats")
        XCTAssertGreaterThanOrEqual(enclosures.count, 1,
                                    "no enclosure is named aloud under the light")

        for element in field {
            let label = element.label
            XCTAssertNil(label.first(where: \.isNumber),
                         "the lit Mandala speaks a numeral: “\(label)”")
            XCTAssertFalse(label.lowercased().contains("times"),
                           "the lit Mandala speaks a tally: “\(label)”")
            XCTAssertGreaterThanOrEqual(element.frame.width, 43.5,
                                        "“\(label)” is a target a finger cannot find")
            XCTAssertGreaterThanOrEqual(element.frame.height, 43.5,
                                        "“\(label)” is a target a finger cannot find")
        }
    }

    /// **Nothing on the lit screen says how he is doing.**
    ///
    /// Every string the lit Mandala puts on the glass, read off the running app
    /// rather than out of the source, and asked the one question this phase can
    /// most easily get wrong. The canvas's own drawn strings are not elements —
    /// they are ink — so what this reaches is the header, the tier hint, the
    /// controls and the spoken layer: everything with words that a walker can
    /// be told something by.
    func testNothingOnTheLitMandalaMeasuresHim() {
        let app = litMandala()
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the lit Mandala never arrived")

        let words = ["times", "streak", "progress", "complete", "%", "visits", "sessions", "total"]
        for element in app.staticTexts.allElementsBoundByIndex where element.exists {
            let label = element.label.lowercased()
            for word in words {
                XCTAssertFalse(label.contains(word),
                               "the lit Mandala measures: “\(element.label)”")
            }
        }
    }

    /// **The hamburger survives the light.** The one concession on the home
    /// screen, and the thing an oversized fixed-size layer pushes off the glass
    /// without any test noticing — `.frame(maxWidth: .infinity)` grows rather
    /// than clamps, so a full-bleed gazing field is exactly the shape that
    /// springs the trap. Tratak is therefore drawn inside the existing canvas
    /// and adds no layer at all; this is the assertion that says so out loud.
    ///
    /// Asked on whatever screen the run is given, and the SE is the one that
    /// matters: it is the narrowest, so it is where a layer that grew would
    /// take the button off the edge first.
    func testTheHamburgerIsStillOnTheGlass() {
        let app = litMandala()
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the lit Mandala never arrived")

        let bounds = app.frame
        guard let button = hamburger(in: app) else {
            return XCTFail("the hamburger is not on the lit Mandala at \(bounds.size)")
        }
        XCTAssertLessThanOrEqual(button.frame.maxX, bounds.maxX + 0.5,
                                 "the hamburger has been pushed off the right edge at \(bounds.size)")
        XCTAssertGreaterThanOrEqual(button.frame.minX, bounds.minX - 0.5)
        XCTAssertGreaterThanOrEqual(button.frame.minY, bounds.minY - 0.5)
        XCTAssertLessThanOrEqual(button.frame.maxY, bounds.maxY + 0.5)
        XCTAssertTrue(button.isHittable,
                      "the hamburger is on the glass but something is drawn over it")
    }

    /// **And it still opens the menu.** On screen is not the same as reachable,
    /// and the light adds a one-second state tick that a tap could in principle
    /// land inside.
    ///
    /// Two launches, not one, and the unlit launch is the point. A single lit
    /// launch that failed would be unreadable: this harness cancels presses
    /// under load (DECISIONS.md, *"The press that was never delivered"*), so a
    /// red here could be the machine as easily as the light. Asking the same
    /// question of the same screen with the flag off separates them.
    ///
    /// Three outcomes, and each is reported as what it is. The lit launch opens
    /// the menu: **pass**. The lit launch does not and the unlit one does: the
    /// light has taken the one control on the home screen, and that is a
    /// **failure**. Neither launch opens it: the machine could not deliver a
    /// press at all, so the question was never put — a **skip**, said out loud,
    /// rather than a red that would teach whoever sees it to ignore this file.
    /// This was written after watching it happen, twice, on a host running
    /// three simulators.
    func testTheHamburgerStillOpensTheMenuUnderTheLight() throws {
        let lit = litMandala()
        XCTAssertTrue(Reach.text(lit, "Śrī Yantra"), "the lit Mandala never arrived")
        let litOpened = opensTheMenu(lit)
        lit.terminate()

        guard !litOpened else { return }

        let unlit = unlitMandala()
        XCTAssertTrue(Reach.text(unlit, "Śrī Yantra"), "the unlit Mandala never arrived")
        let unlitOpened = opensTheMenu(unlit)
        unlit.terminate()

        if unlitOpened {
            return XCTFail("the hamburger opens the menu with the phase flag off and not with it "
                           + "on — the light has taken the one control on the home screen")
        }
        throw XCTSkip("the hamburger opened the menu on neither launch, lit or unlit, so this "
                      + "machine could not deliver a press at all and the question was never put. "
                      + "XCTest's digitizer drops presses under load (DECISIONS.md, “The press "
                      + "that was never delivered”). Re-run on a quieter host.")
    }

    /// The lit controls are still reachable — the sound toggle most of all,
    /// because it is what governs the falling mantra (idea 31). A bīja that
    /// could not be turned off would be a second unconditional sound.
    func testTheSoundToggleStillGovernsTheCrossing() {
        let app = litMandala()
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the lit Mandala never arrived")
        let toggle = app.buttons.allElementsBoundByIndex.first {
            $0.exists && ($0.label == "♪" || $0.label == "♪̸")
        }
        guard let toggle else { return XCTFail("the sound toggle is not on the lit Mandala") }
        XCTAssertTrue(toggle.isHittable, "the sound toggle cannot be reached under the light")
        XCTAssertGreaterThanOrEqual(toggle.frame.width, 43.5)
        XCTAssertGreaterThanOrEqual(toggle.frame.height, 43.5)
    }
}
