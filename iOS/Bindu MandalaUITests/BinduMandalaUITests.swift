import XCTest

/// Drives the real button taps that headless launch-args can't reach: the
/// Today → Detail transition and the "I feel her" → Recognition → Portrait chain.
/// Each test launches fresh so there is no duplicate-label ambiguity between the
/// Today and Detail copies of "I feel her".
final class BinduMandalaUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    // MARK: - Delivering a press the simulator cannot silently swallow

    /// Press `element` and wait for `expected` to appear — re-pressing, up to
    /// `attempts` times, only while the button is still there to press.
    ///
    /// `XCUIElement.tap()` is a reliable way to *attempt* a press, not to land
    /// one. XCTest attaches a virtual HID digitizer to the simulator, plays a
    /// path through it (touch-down, touch-up 50 ms later) and tears the service
    /// down ~180 ms after attaching. When the host is loaded the playback is
    /// descheduled between the two frames, the lift never reaches backboardd,
    /// and backboardd cancels the still-live contact as the digitizer goes away:
    ///
    ///     BackBoard:TouchEvents  cancel -- digitizer did disappear:
    ///       <BKDirectTouchState …; contacts: [touchIdentifier: 1; touching; locked;
    ///        … sceneID:com.ashrey.bindu-mandala-default]>
    ///     BackBoard:TouchEvents  canceling paths … -- HID
    ///
    /// UIKit delivers that to the app as `UITouchPhaseCancelled`, and SwiftUI
    /// correctly discards a cancelled press — the `Button`'s action never runs,
    /// nothing changes on screen, and the app is right to do nothing. XCTest is
    /// unaware: it still reports "Synthesize event" as succeeded and then waits
    /// out the full timeout for a consequence nobody ever asked for.
    ///
    /// So the retry is not extra patience for a slow app — each attempt gets the
    /// same budget a single `tap()` had, and a press is only re-sent when the
    /// button is *still hittable*, which it is not once a cover has presented.
    /// An app that truly fails to respond fails this exactly as before.
    @discardableResult
    private func press(_ element: XCUIElement,
                       until expected: XCUIElement,
                       attempts: Int = 3,
                       eachTimeout: TimeInterval) -> Bool {
        for attempt in 0..<attempts {
            if attempt > 0 && !element.isHittable {
                // Something did happen — the press landed after all, or a cover
                // is up. Don't press blind; just wait it out.
                return expected.waitForExistence(timeout: eachTimeout)
            }
            element.tap()
            if expected.waitForExistence(timeout: eachTimeout) { return true }
        }
        return false
    }

    /// Today with a rich Ring-2 Karṣiṇī (kp 29, Kāmākarṣiṇī — carries a phonetic).
    private func launchToday() -> XCUIApplication {
        let app = XCUIApplication()
        // SYNC_OFF: the app must never write to Airtable during a UI run (honoured by AppRuntime.syncDisabled).
        app.launchArguments = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "START_TAB=rite", "ENERGY_POS=29", "SYNC_OFF"]
        app.launch()
        return app
    }

    /// Today → tap "know her ›" → her full Detail (the hero shows her phonetic,
    /// which only appears on the Detail, so it proves the transition happened).
    func testTodayOpensDetail() {
        let app = launchToday()
        let knowHer = app.buttons["know her ›"]
        XCTAssertTrue(knowHer.waitForExistence(timeout: 12), "Today should offer 'know her ›'")
        let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]
        XCTAssertTrue(press(knowHer, until: phonetic, eachTimeout: 8),
                      "Detail hero should show her phonetic")
    }

    /// Today → tap "I feel her" → the Recognition ceremony (its two-act reciprocity
    /// text appears). A poll-based query, so it needs no app-idle — the ceremony's
    /// perpetual breath animation would otherwise stall an interaction. The close →
    /// didSettle → Portrait handoff is exercised separately by the app's own
    /// RECOGNIZE_AUTOCLOSE path (verified on device), which needs no synthetic tap.
    func testFeelHerOpensRecognition() {
        let app = launchToday()
        let feelHer = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'I feel her'")).firstMatch
        XCTAssertTrue(feelHer.waitForExistence(timeout: 15), "Today should offer 'I feel her'")
        let felt = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'felt here'")).firstMatch
        XCTAssertTrue(press(feelHer, until: felt, eachTimeout: 20),
                      "Recognition ceremony should show 'she was felt here'")
    }
}
