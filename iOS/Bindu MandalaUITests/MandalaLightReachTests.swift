import XCTest
import CoreGraphics
import UIKit

// MARK: - MandalaLightReachTests — the lit instrument, on a running app
//
// Phase 5. `MandalaLightTests` proves the arithmetic off-device; this proves
// that turning the light on does not cost the screen anything it already had.
//
// Everything here launches with **no `MANDALA_LIGHT` argument at all**, which
// since the flag was inverted is the whole point: this is the launch Ashrey
// gets, rendered by the suite rather than by nobody. While the light was being
// built these tests asked for `MANDALA_LIGHT=on` and every other suite ran
// unlit; now it is the other way round, and the one launch that has to be
// spelled out is the control. The things checked are the ones a new lighting
// pass is most likely to take away —
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
    ///
    /// **No `MANDALA_LIGHT` argument.** That is the assertion: the light is on
    /// because it is on by default, not because this file asked for it, so every
    /// check below is a check on the build that ships. If the flag were ever put
    /// back the way it was, these tests would go on passing against an unlit
    /// screen and say nothing — which is why
    /// `MandalaLightTests.testTheLightIsOnByDefault` exists beside them and why
    /// `testTheLightIsOnInTheLaunchThatShips` asks it again of a running app.
    private func litMandala() -> XCUIApplication {
        Reach.app(["START_TAB=mandala"])
    }

    /// The same Mandala with the phase flag off — the control for anything that
    /// could be the host rather than the light.
    ///
    /// This is now the launch that has to name the flag. It must keep naming it:
    /// if both launches were the default, the three-outcome logic in
    /// `testTheHamburgerStillOpensTheMenuUnderTheLight` would collapse into two
    /// and stop being able to tell a light that ate the control apart from a
    /// digitizer that dropped the press.
    private func unlitMandala() -> XCUIApplication {
        Reach.app(["START_TAB=mandala", "MANDALA_LIGHT=off"])
    }

    /// The hamburger, found where it lives rather than by a name this phase
    /// would have had to invent: the shell exposes no label for it (audit §H5),
    /// so it is the 44×44 control in the top-trailing corner.
    ///
    /// **The topmost one, and never a labelled one — and both halves were paid
    /// for.** The Mandala's own zoom column also lives against the trailing
    /// edge, and its first control — the sound toggle — sits about 129 pt down
    /// on a Pro and about 90 pt down on an SE, inside the 140 pt band a
    /// first-match query accepts. This test tapped *that* five times, left
    /// `lr_sound` on in the simulator's defaults, and `FeltRegisterSnapshots`
    /// then reported the whole composition moved — on three screens, in a later
    /// run, with no code change between them. The suite was right and this file
    /// was wrong.
    ///
    /// So: the hamburger is the **highest** control in the corner, which is
    /// true on every screen size rather than true at one threshold, and it
    /// carries no label, which the five marks in the zoom column all do.
    private func hamburger(in app: XCUIApplication) -> XCUIElement? {
        let bounds = app.frame
        let marks: Set<String> = ["♪", "♪̸", "+", "−", "⤢", "×", "‹"]
        return app.buttons.allElementsBoundByIndex
            .filter {
                $0.exists && $0.frame.maxX > bounds.width - 76
                    && $0.frame.minY < 140 && $0.frame.height >= 40 && $0.frame.width >= 40
                    && !marks.contains($0.label)
            }
            .min { $0.frame.minY < $1.frame.minY }
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

    // MARK: - the light is on, and still cannot be counted

    /// **The light is on in the launch that ships — proved on a running app,
    /// not off the source.**
    ///
    /// `MandalaLightTests.testTheLightIsOnByDefault` reads the switch. This
    /// reads the glass, because a switch that is on and a light that is drawn
    /// are two different claims and only the second one is what Ashrey opens.
    /// The lit path draws each of the nine enclosures as a three-stroke gem-light
    /// band instead of a 0.5 pt hairline and lights the Bhūpura and the nine
    /// triangles from the centre, so the two paths differ over a large,
    /// structural fraction of the yantra — nothing like the handful of pixels a
    /// clock glyph or a blinking cursor could move.
    ///
    /// Both launches are `REDUCE_MOTION`, which is what makes this a test rather
    /// than a coin toss: the still path consults no clock, so each launch draws
    /// one settled frame and draws the same one every time. The comparison is
    /// cropped to the middle of the glass, away from the status bar, so a clock
    /// that ticked between the two launches cannot be what passes it.
    func testTheLightIsOnInTheLaunchThatShips() throws {
        let shipped = Reach.app(["START_TAB=mandala", "REDUCE_MOTION"])
        XCTAssertTrue(Reach.text(shipped, "Śrī Yantra"), "the shipped Mandala never arrived")
        let litShot = shipped.screenshot().image
        shipped.terminate()

        let control = Reach.app(["START_TAB=mandala", "REDUCE_MOTION", "MANDALA_LIGHT=off"])
        XCTAssertTrue(Reach.text(control, "Śrī Yantra"), "the unlit Mandala never arrived")
        let unlitShot = control.screenshot().image
        control.terminate()

        let moved = try Self.fractionDiffering(litShot, unlitShot)
        XCTAssertGreaterThan(moved, 0.01,
            String(format: "the launch with no MANDALA_LIGHT argument draws the same glass as "
                   + "MANDALA_LIGHT=off (%.4f of the yantra differs). Either the flag has been "
                   + "put back the way it was, or the light is no longer being built — and the "
                   + "screen Ashrey opens first is the shipped canvas without its light.", moved))
    }

    /// **And with the light on, there is still nothing on the screen he can read
    /// a number about himself off — including through a voice.**
    ///
    /// The whole accessibility tree of the shipped launch: every label and every
    /// value, on every kind of element, not just the static texts. A veil, a
    /// band width and a reach are three new numeric channels, and the way a
    /// number escapes a drawing layer is not usually as ink — it is as the label
    /// somebody added so the drawn thing could be spoken.
    ///
    /// Three things are refused. **A digit**, anywhere: the instrument's spoken
    /// surface is words, and the seats say "of the one hundred and two" for
    /// exactly this reason. **A measure word**, so a tally spelled out in
    /// letters is caught too. And **a progress-shaped value**, because an
    /// accessibility `value` is the one place a scale can reach a voice without
    /// ever appearing as a label — a bar that reads "40%" to VoiceOver is a
    /// readout whatever it looks like.
    ///
    /// **What is not refused, and the distinction is the whole law.** The first
    /// version of this test refused the bare ordinals too, and went red on
    /// twenty-one perfectly lawful labels: *"Spar Shah kar shi nee. She who
    /// attracts Touch. Second enclosure, thirty-third of the one hundred and
    /// two."* That ordinal is **her address** — position is identity, and where
    /// she sits in the garland is the one number this instrument is built on. It
    /// says nothing about him and it does not change. What the law forbids is a
    /// number about *his practice*, and the two are told apart by whose fact it
    /// is, not by whether a number is spoken. So the refusal below is practice
    /// words only, and the ordinals are refused exactly where they would become
    /// his — attached to a time, a visit or a turn.
    func testNothingUnderTheLightCanBeCountedEvenByAVoice() {
        let app = litMandala()
        XCTAssertTrue(Reach.text(app, "Śrī Yantra"), "the shipped Mandala never arrived")

        // A tally spelled out, a scale, a legend, a standing — all of them his.
        let measures = ["times", "streak", "progress", "complete", "completed", "percent",
                        "visits", "visited", "sessions", "total", "count", "counted",
                        "so far", "remaining", "left to", "score", "streaks",
                        "you have", "you've", "your first", "your second"]
        // And an ordinal turned into a tally of him: her seat may be the third of
        // the hundred and two, and nothing may be his third anything.
        let ordinals = ["first", "second", "third", "fourth", "fifth"]
        let his = [" time", " visit", " turn", " today", " again"]
        var examined = 0
        for element in app.descendants(matching: .any).allElementsBoundByIndex where element.exists {
            let label = element.label
            let value = (element.value as? String) ?? ""
            for text in [label, value] where !text.isEmpty {
                examined += 1
                XCTAssertNil(text.first(where: \.isNumber),
                             "the lit Mandala speaks a numeral: “\(text)”")
                let lowered = text.lowercased()
                for measure in measures {
                    XCTAssertFalse(lowered.contains(measure),
                                   "the lit Mandala speaks a measure (“\(measure)”): “\(text)”")
                }
                XCTAssertFalse(lowered.contains("%"),
                               "the lit Mandala speaks a percentage: “\(text)”")
                for ordinal in ordinals {
                    for tail in his {
                        XCTAssertFalse(lowered.contains(ordinal + tail),
                                       "the lit Mandala counts his turns: “\(text)”")
                    }
                }
            }
        }
        XCTAssertGreaterThan(examined, 20,
                             "the tree came back all but empty — this check proves nothing")
    }

    // MARK: - helpers

    /// The fraction of pixels that differ between two screenshots, over the
    /// middle of the glass.
    ///
    /// Cropped to 10…90% of the width and 20…85% of the height: the status bar
    /// and the home indicator are outside it, and the whole yantra is inside it.
    /// A pixel counts as moved when any channel differs by more than 8 of 255,
    /// which ignores compression and colour-management noise and does not ignore
    /// a stroke that went from a hairline to a band.
    private static func fractionDiffering(_ a: UIImage, _ b: UIImage) throws -> Double {
        guard let ga = a.cgImage, let gb = b.cgImage else {
            throw XCTSkip("a screenshot came back without a bitmap")
        }
        guard ga.width == gb.width, ga.height == gb.height else {
            XCTFail("the two launches produced different screenshot sizes — "
                    + "\(ga.width)×\(ga.height) and \(gb.width)×\(gb.height)")
            return 0
        }
        let x0 = Int(Double(ga.width) * 0.10), x1 = Int(Double(ga.width) * 0.90)
        let y0 = Int(Double(ga.height) * 0.20), y1 = Int(Double(ga.height) * 0.85)
        let w = x1 - x0, h = y1 - y0
        guard w > 0, h > 0 else { throw XCTSkip("the screenshots are too small to compare") }

        func bytes(_ image: CGImage) throws -> [UInt8] {
            var buffer = [UInt8](repeating: 0, count: w * h * 4)
            guard let ctx = CGContext(data: &buffer, width: w, height: h,
                                      bitsPerComponent: 8, bytesPerRow: w * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                throw XCTSkip("this host would not give a bitmap context for the comparison")
            }
            ctx.draw(image, in: CGRect(x: -x0, y: -(image.height - y1),
                                       width: image.width, height: image.height))
            return buffer
        }
        let pa = try bytes(ga), pb = try bytes(gb)
        var moved = 0
        for i in stride(from: 0, to: pa.count, by: 4) {
            if abs(Int(pa[i]) - Int(pb[i])) > 8
                || abs(Int(pa[i + 1]) - Int(pb[i + 1])) > 8
                || abs(Int(pa[i + 2]) - Int(pb[i + 2])) > 8 {
                moved += 1
            }
        }
        return Double(moved) / Double(w * h)
    }
}
