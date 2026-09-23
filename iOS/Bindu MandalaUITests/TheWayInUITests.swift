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

    /// One climb of the axis, by a thumb: a press and a drag up the glass,
    /// given as fractions of the screen so it is the same gesture on every size.
    private func rise(_ app: XCUIApplication) {
        let from = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.66))
        let to = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.18))
        from.press(forDuration: 0.08, thenDragTo: to)
    }

    private func beWithHer(_ app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Be with her'")).firstMatch
    }

    /// Today → her Detail, by a finger, with the tap actually landing.
    ///
    /// **What it waits for is the door itself, and finding a sentinel that
    /// worked took three runs.** `press(_:until:)` absorbs the cancelled-press
    /// flake `DECISIONS.md` records only when what it waits for is something the
    /// *new* screen has and the old one does not — and Today's own card carries
    /// both of the obvious candidates. Her phonetic is drawn there, in the same
    /// caps; so is **I feel her**, because she can be recognised from anywhere
    /// she is met and the Daily Rite is one of those places. Waiting on either
    /// returned `true` for a screen that had never opened, and the failure
    /// surfaced two assertions later as *"the instrument is unreachable"*.
    ///
    /// `be with her ›` is on her Detail and nowhere else in the shell. That
    /// makes the wait and the claim the same fact, which is the right shape
    /// here: the phase's whole assertion is that this door exists where she is,
    /// and a run that never sees it has failed whichever line says so.
    private func openHerDetail(_ app: XCUIApplication) -> XCUIElement {
        let knowHer = app.buttons["know her ›"]
        XCTAssertTrue(knowHer.waitForExistence(timeout: 20), "Today should offer 'know her ›'")
        let door = beWithHer(app)
        // Patient rather than lenient: four attempts at eighteen seconds is the
        // cancelled-press helper given room to work on a host under load — the
        // condition `DECISIONS.md` rules is contention and never a defect. What
        // is asserted is unchanged; only how long it is willing to wait for it.
        XCTAssertTrue(press(knowHer, until: door, attempts: 4, eachTimeout: 18),
                      "her Detail never opened, or it opened with no way into her room — "
                      + "the instrument is unreachable")
        XCTAssertTrue(app.staticTexts["KAH · MAH · KAR · SHI · NEE"].exists,
                      "her Detail opened without her phonetic on it")
        XCTAssertTrue(door.isHittable, "her door is on her screen but cannot be reached")
        return door
    }

    /// **He is outside when the room is gone, not when her Detail can be seen.**
    ///
    /// A `fullScreenCover` leaves the screen beneath it in the accessibility
    /// tree — the walker's own reading of a room found every element of her
    /// Detail present and only the way out hittable — so `door.exists` is true
    /// *inside* the room, and waiting on it says nothing at all about having
    /// left. The way out is the one control a Homes surface has: when it is
    /// gone, he is out. Everything below asks that, and asks `isHittable` of
    /// her Detail rather than `exists`.
    private func hasLeftTheRoom(_ app: XCUIApplication, timeout: TimeInterval = 8) -> Bool {
        wayOut(app).waitForNonExistence(timeout: timeout)
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

        // 1 · Today offers her, she opens, and her screen offers her room.
        //     That door is what Phase 3.7 cut.
        let door = openHerDetail(app)
        let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]

        // 2 · And it opens onto the *threshold*, never onto the room. The rite's
        //     own prompt is the proof: it exists only while he is still outside.
        let ritePrompt = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'touch to'")).firstMatch
        XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12),
                      "the way in did not open the rite of entering")
        XCTAssertFalse(wayOut(app).exists,
                       "the way out is offered at the threshold — a threshold is not a dialog")

        // 3 · He crosses, and he is inside. The way out appears only there.
        XCTAssertTrue(crossTheThreshold(app),
                      "the ceremony never carried him into the room")

        // 4 · He crosses out — held, for the crossing's own length.
        let out = wayOut(app)
        XCTAssertTrue(out.isHittable, "the way out is on screen but cannot be reached")
        out.press(forDuration: TheWayInUITests.crossing + 1.4)

        // 5 · And he is on the screen he left from, with the door still there.
        XCTAssertTrue(hasLeftTheRoom(app, timeout: 12),
                      "the room is still on screen after the crossing out")
        XCTAssertTrue(door.isHittable,
                      "the way out did not put him back on her own screen, with her door reachable")
        XCTAssertTrue(phonetic.exists, "he came out somewhere other than where he went in")

        // 6 · And the door still works, which is what makes a stay a stay rather
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
        let door = walkIntoHerRoom(app)

        let out = wayOut(app)
        out.press(forDuration: TheWayInUITests.crossing * 0.35)
        XCTAssertTrue(wayOut(app).waitForExistence(timeout: 4),
                      "a crossing he let go of took him out of the room anyway")
        XCTAssertTrue(wayOut(app).isHittable,
                      "the room is on screen but he can no longer leave it — a crossing he let go "
                      + "of left the surface in a state with no way out of it")
        XCTAssertFalse(door.isHittable,
                       "he is on her Detail after letting go of the way out")
    }

    /// Today → know her → be with her → the threshold → her room. Returns the
    /// door, so a caller can assert he came back to it.
    @discardableResult
    private func walkIntoHerRoom(_ app: XCUIApplication) -> XCUIElement {
        let door = openHerDetail(app)
        let ritePrompt = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'touch to'")).firstMatch
        XCTAssertTrue(press(door, until: ritePrompt, eachTimeout: 12))
        XCTAssertTrue(crossTheThreshold(app))
        return door
    }

    // MARK: - The still path, walked

    /// **Reduced motion, from the cold launch to back out of the room.**
    ///
    /// Nothing in the suite had ever set reduce motion and asserted that the way
    /// out really is a *step* there: that the word is different, that one touch
    /// leaves the room, and that one touch is enough — no hold, no second try.
    /// `iOS/FIDELITY.md` asks for a real still path, and a still path nobody has
    /// walked is a claim rather than a path.
    ///
    /// `REDUCE_MOTION` is the DEBUG launch argument the shell hands to the rite
    /// and the axis as `forceReduceMotion`; it is the same flag the captures and
    /// the room suites use, reached from outside so the whole walk can be driven.
    func testUnderReducedMotionOneTouchLeavesTheRoom() {
        let app = coldLaunch(["START_TAB=rite", "REDUCE_MOTION"])
        let door = walkIntoHerRoom(app)

        // The word follows the gesture: a step, not a walk held through.
        let stepped = app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'touch to withdraw'")).firstMatch
        XCTAssertTrue(stepped.waitForExistence(timeout: 8),
                      "the still path still asks for a hold through a room that is not moving")
        XCTAssertFalse(app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] 'hold to withdraw'")).firstMatch.exists,
                       "both ways out are on screen at once")
        XCTAssertTrue(stepped.isHittable)

        // One touch, and he is outside. The loop is the cancelled-press flake
        // and nothing else — every attempt is a single `tap()`, never a hold,
        // so leaving at all is the proof that a touch is enough here.
        var left = false
        for _ in 0..<3 where !left {
            guard stepped.isHittable else { break }
            stepped.tap()
            left = hasLeftTheRoom(app, timeout: 6)
        }
        XCTAssertTrue(left, "one touch did not take a reduce-motion walker out of the room")
        XCTAssertTrue(door.isHittable, "he came out somewhere other than onto her own screen")
        XCTAssertTrue(app.staticTexts["KAH · MAH · KAR · SHI · NEE"].exists,
                      "he came out somewhere other than where he went in")
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
        XCTAssertTrue(hasLeftTheRoom(app, timeout: 12),
                      "the axis is still on screen after the crossing off it")
        XCTAssertTrue(door.isHittable,
                      "the way off the axis did not put him back on the Field")
    }

    /// **The axis says the space can be climbed.**
    ///
    /// It used to put exactly two lines on screen — the āvaraṇa's name and the
    /// way out — so a walker who arrived, waited and saw nothing change was told
    /// only how to leave the thing he had just opened. The climb is the payload
    /// of this phase's second door and it was invisible. A gesture hint is not a
    /// measure: it says what the hand may do, in the same register as the way
    /// out two inches below it, and it knows nothing but whether he has moved
    /// on this visit.
    func testTheAxisSaysItCanBeClimbed() {
        let app = coldLaunch(["START_TAB=102", "OPEN_CLIMB"])
        let out = wayOut(app)
        XCTAssertTrue(out.waitForExistence(timeout: 25), "OPEN_CLIMB did not arrive on the axis")

        let hint = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'drag to rise'")).firstMatch
        XCTAssertTrue(hint.waitForExistence(timeout: 8),
                      "the axis arrives mute — the one instruction on it is how to leave it")

        // And it goes when he is already doing it, rather than staying to be
        // read. Which enclosure he lands in is his hand's business — what is
        // asserted is that he left the one he opened on.
        let opened = app.staticTexts["Sarvāśāparipūraka"]
        XCTAssertTrue(opened.waitForExistence(timeout: 10),
                      "the climb opened somewhere other than the āvaraṇa the Field had open")
        // **A deliberate drag, not `swipeUp()`.** The axis rises on a
        // `DragGesture`, and on the SE a flick sent at the app element did not
        // reach it at all — the hint stayed and the enclosure never changed.
        // A press-and-drag between two named points on the glass is the gesture
        // a walker's thumb actually makes, and it is the same on every screen
        // size because both ends are given as fractions of it.
        var gone = false
        for _ in 0..<4 where !gone {
            rise(app)
            gone = hint.waitForNonExistence(timeout: 5)
        }
        XCTAssertTrue(gone, "the hint is still on screen after he has risen")

        // …and the axis really does rise under him. How far one drag carries him
        // is his hand's business and the settle's — a screen height is one band
        // — so it is asked again rather than assumed, which is a wait, not a
        // weakening: he must leave the enclosure he opened on.
        var climbed = opened.waitForNonExistence(timeout: 5)
        for _ in 0..<5 where !climbed {
            rise(app)
            climbed = opened.waitForNonExistence(timeout: 5)
        }
        XCTAssertTrue(climbed, "the axis did not climb")
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
                let door = openHerDetail(app)
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

            // **A digit is not the only way to measure.** "your third stay",
            // "welcome back", "again" and a streak spelled out in words all
            // carry no digit and all say the same forbidden thing. Design's own
            // nine `MEASURING` patterns are applied at source level by
            // `LawsTests`; these are the ones that can only be caught *here*,
            // on the running app, where what is on the glass is the evidence
            // rather than what a literal says before it is interpolated.
            let measuring = arrived.filter { label in
                TheWayInUITests.wordsThatMeasure.contains { word in
                    label.range(of: word, options: [.caseInsensitive]) != nil
                }
            }
            XCTAssertTrue(measuring.isEmpty,
                          "\(surface) measures him in words: \(measuring.sorted())")
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

    /// What a surface may never say to him without a digit in it.
    ///
    /// Ordinals, returns and totals — the three ways a count arrives spelled
    /// out. `again` and `back` are here because a room that greets a returning
    /// walker has told him it has been keeping his returns, which is the same
    /// breach as a visit number and is easier to write by accident.
    static let wordsThatMeasure: [String] = [
        "streak", "progress", "score", "total", "complete", "completed",
        "first time", "welcome back", "once more", "again", "so far", "as usual",
        "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth",
        "times", "visit", "your stay", "you have been",
    ]
}
