import XCTest

// MARK: - Phase 3.7, driven on the running app
//
// `TheWayInTests` proves the doors are cut, that they are cut in one place each,
// and that every one of the hundred and two answers the call the door makes.
// None of that is the same as a walker getting there, which is what this file
// does: **from a cold launch, on the real shell, with a finger.**
//
// Nothing here is seeded, pinned or shortcut past. The app opens where it opens
// on a fresh install, the walker finds today's Śakti, opens her, crosses her
// threshold, stands in her room, and comes out of it — and the assertion at the
// end is the one that matters for the way out: **he is back on the screen he
// left from**, not on a screen the way out happened to land him on.
//
// `EPHEMERAL_STORE` is why this is re-runnable. A stay writes to `HomeMemory`
// now, and a store that remembered the last run would hand the next one a
// compressed ceremony — a different instrument than the one every launch here is
// meant to be reading. With a store of its own, nothing this suite does outlives
// it, and the disk is never touched.
//
// **Two things are asserted at the unit level instead, and for a reason rather
// than for convenience.** The Gate (khaḍgamālā 3 and 4) and the other eighty-six
// have no rows in a `SYNC_OFF` app — `ShaktiBootstrap` seeds the sixteen Ring-2
// Karṣiṇīs and nothing else — so a UI test could only reach them by letting the
// app talk to Airtable, which no UI run may do. `TheWayInTests` drives the same
// production call over all 102 and over both halves of the Gate. What this file
// adds that no unit test can is that the call is actually *reached by a finger*.
final class TheWayInUITests: XCTestCase {

    override func setUp() { continueAfterFailure = false }

    /// A cold launch onto Today, with a fresh in-memory store and no network.
    private func coldLaunch(_ extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                               "ENERGY_POS=29", "EPHEMERAL_STORE"] + extra
        app.launch()
        return app
    }

    /// The way out, wherever he is standing: the only control on a Homes
    /// surface, found by the words it says.
    private func wayOut(_ app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'withdraw'")).firstMatch
    }

    private func beWithHer(_ app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Be with her'")).firstMatch
    }

    /// Touch the ceremony through to the room.
    ///
    /// The rite is touch-paced — three beats, then the last stretch of the
    /// crossing — and it has no named control, so the touches land on the glass
    /// the way a walker's do. The loop is the same shape as `press(_:until:)`
    /// and absorbs the same flake: a touch that the digitizer teardown cancels
    /// simply does not advance the beat, and the next pass sends another.
    ///
    /// It waits *first*, so the beat has finished writing before it is touched
    /// on: nothing advances on a timer here, but a walker does not touch through
    /// a word that is still being written either.
    @discardableResult
    private func crossTheThreshold(_ app: XCUIApplication, attempts: Int = 8) -> Bool {
        let out = wayOut(app)
        let glass = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.28))
        for _ in 0..<attempts {
            if out.waitForExistence(timeout: 3.5) { return true }
            glass.tap()
        }
        return out.waitForExistence(timeout: 6)
    }

    // MARK: - Her room

    /// **The whole of it, once, from a cold launch.**
    ///
    /// Today → know her → be with her → the threshold → her room → out, and back
    /// where he came from.
    func testFromAColdLaunchAWalkerReachesARoomAndComesOutWhereHeStarted() {
        let app = coldLaunch(["START_TAB=rite"])

        // 1 · Today offers her, and she opens.
        let knowHer = app.buttons["know her ›"]
        XCTAssertTrue(knowHer.waitForExistence(timeout: 20), "Today should offer 'know her ›'")
        let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]
        XCTAssertTrue(press(knowHer, until: phonetic, eachTimeout: 10),
                      "her Detail should open on her phonetic")

        // 2 · Her screen offers her room. This is the door Phase 3.7 cut.
        let door = beWithHer(app)
        XCTAssertTrue(door.waitForExistence(timeout: 10),
                      "her Detail offers no way into her room — the instrument is unreachable")

        // 3 · And it opens onto the *threshold*, never onto the room. The rite's
        //     own prompt is the proof: it exists only while he is still outside.
        let ritePrompt = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'touch to'")).firstMatch
        XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12),
                      "the way in did not open the rite of entering")
        XCTAssertFalse(wayOut(app).exists,
                       "the way out is offered at the threshold — a threshold is not a dialog")

        // 4 · He crosses, and he is inside. The way out appears only there.
        XCTAssertTrue(crossTheThreshold(app),
                      "the ceremony never carried him into the room")

        // 5 · He crosses out — held, for the crossing's own length.
        let out = wayOut(app)
        XCTAssertTrue(out.isHittable, "the way out is on screen but cannot be reached")
        out.press(forDuration: TheWayInUITests.crossing + 1.4)

        // 6 · And he is on the screen he left from, with the door still there.
        XCTAssertTrue(door.waitForExistence(timeout: 12),
                      "the way out did not put him back on her own screen")
        XCTAssertTrue(phonetic.exists, "he came out somewhere other than where he went in")
        XCTAssertFalse(wayOut(app).exists, "the room is still on screen after he left it")

        // 7 · And the door still works, which is what makes a stay a stay rather
        //     than a one-way trip. The second crossing is the compressed one —
        //     felt, never announced, so what is asserted is that it happens.
        XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12),
                      "her room cannot be entered a second time")
        XCTAssertTrue(crossTheThreshold(app), "the second crossing never completed")
    }

    /// Letting go of the crossing keeps him in the room. A stay is not ended by
    /// a finger that touched the glass and changed its mind.
    func testLettingGoOfTheCrossingLeavesHimInTheRoom() {
        let app = coldLaunch(["START_TAB=rite"])
        let knowHer = app.buttons["know her ›"]
        XCTAssertTrue(knowHer.waitForExistence(timeout: 20))
        let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]
        XCTAssertTrue(press(knowHer, until: phonetic, eachTimeout: 10))
        let door = beWithHer(app)
        XCTAssertTrue(door.waitForExistence(timeout: 10))
        let ritePrompt = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'touch to'")).firstMatch
        XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12))
        XCTAssertTrue(crossTheThreshold(app))

        let out = wayOut(app)
        out.press(forDuration: TheWayInUITests.crossing * 0.35)
        XCTAssertTrue(wayOut(app).waitForExistence(timeout: 4),
                      "a crossing he let go of took him out of the room anyway")
        XCTAssertFalse(door.isHittable,
                       "he is on her Detail after letting go of the way out")
    }

    // MARK: - The climb

    /// The Field offers the nine as one ascent, and the ascent lets him off it.
    func testTheFieldOpensTheClimbAndTheClimbLetsHimOut() {
        let app = coldLaunch(["START_TAB=102"])

        let field = app.staticTexts["The Field"]
        XCTAssertTrue(field.waitForExistence(timeout: 20), "the Field never arrived")

        let door = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Rise through'")).firstMatch
        XCTAssertTrue(door.waitForExistence(timeout: 10),
                      "the Field offers no way onto the axis — the nine āvaraṇas are unreachable")

        // He rises from the āvaraṇa he has open, which on a cold launch is
        // today's: kp 29 is a Karṣiṇī, so the second enclosure names itself.
        let out = wayOut(app)
        XCTAssertTrue(press(door, until: out, eachTimeout: 14),
                      "the climb did not open")
        XCTAssertTrue(app.staticTexts["Sarvāśāparipūraka"].waitForExistence(timeout: 8),
                      "the climb opened somewhere other than the āvaraṇa the Field had open")

        out.press(forDuration: TheWayInUITests.crossing + 1.4)
        XCTAssertTrue(door.waitForExistence(timeout: 12),
                      "the way off the axis did not put him back on the Field")
        XCTAssertFalse(wayOut(app).exists, "the climb is still on screen after he left it")
    }

    /// `OPEN_CLIMB` reaches the axis directly, the way `OPEN_THRESHOLD` reaches
    /// an āvaraṇa's — so a later pass measuring the climb does not have to drive
    /// the Field to get to it.
    func testTheClimbCanBeOpenedDirectly() {
        let app = coldLaunch(["START_TAB=102", "OPEN_CLIMB"])
        XCTAssertTrue(wayOut(app).waitForExistence(timeout: 25),
                      "OPEN_CLIMB did not arrive on the axis")
    }

    // MARK: - Nothing on either new surface measures him

    /// **What the new surfaces add to the screen, and nothing else.**
    ///
    /// A whole-tree digit scan would be a lie here: a `fullScreenCover` leaves
    /// the screen beneath it in the accessibility tree, so a room opened over
    /// her Detail reads that Detail's own *"29 · 102"* — her seat in the
    /// garland, which is identity and is allowed to be on a screen. The same
    /// reading that makes the snapshot lock honest makes this one honest:
    /// compare the surface against what was there before it, and judge only what
    /// **arrived**.
    ///
    /// What may arrive is exactly what each surface draws — the way out
    /// everywhere, the āvaraṇa's own name on the axis — and none of it carries a
    /// digit. A room and an axis are where a walker is most alone with the
    /// instrument, and there is nothing there to count at.
    func testWhatTheRoomAndTheAxisAddToTheScreenSaysNoNumber() {
        for surface in ["a room", "the axis"] {
            let app = coldLaunch(surface == "a room" ? ["START_TAB=rite"] : ["START_TAB=102"])
            let before: Set<String>

            if surface == "a room" {
                let knowHer = app.buttons["know her ›"]
                XCTAssertTrue(knowHer.waitForExistence(timeout: 20))
                let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]
                XCTAssertTrue(press(knowHer, until: phonetic, eachTimeout: 10))
                let door = beWithHer(app)
                XCTAssertTrue(door.waitForExistence(timeout: 10))
                before = labels(of: app)
                let ritePrompt = app.staticTexts
                    .matching(NSPredicate(format: "label CONTAINS[c] 'touch to'")).firstMatch
                XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12))
                XCTAssertTrue(crossTheThreshold(app))
            } else {
                XCTAssertTrue(app.staticTexts["The Field"].waitForExistence(timeout: 20))
                let door = app.buttons
                    .matching(NSPredicate(format: "label CONTAINS[c] 'Rise through'")).firstMatch
                XCTAssertTrue(door.waitForExistence(timeout: 10))
                before = labels(of: app)
                XCTAssertTrue(press(door, until: wayOut(app), eachTimeout: 14))
            }

            let arrived = labels(of: app).subtracting(before)
            XCTAssertFalse(arrived.isEmpty, "\(surface) drew nothing a reader can see")
            let counting = arrived.filter { $0.rangeOfCharacter(from: .decimalDigits) != nil }
            XCTAssertTrue(counting.isEmpty,
                          "\(surface) says a number out loud: \(counting.sorted())")
            app.terminate()
        }
    }

    private func labels(of app: XCUIApplication) -> Set<String> {
        var out: Set<String> = []
        for element in app.staticTexts.allElementsBoundByIndex + app.buttons.allElementsBoundByIndex
        where element.exists && !element.label.isEmpty {
            out.insert(element.label)
        }
        return out
    }

    /// Design's release, which is what the hold lasts. Restated here because a
    /// UI test target cannot import the app; `TheWayInTests` pins the app's own
    /// value against `RoomApproach.releaseSeconds`, so the two cannot drift
    /// without one of them going red.
    static let crossing: TimeInterval = 2.2
}
