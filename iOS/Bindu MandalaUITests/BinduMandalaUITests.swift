import XCTest

/// Drives the real button taps that headless launch-args can't reach: the
/// Today → Detail transition and the "I feel her" → Recognition → Portrait chain.
/// Each test launches fresh so there is no duplicate-label ambiguity between the
/// Today and Detail copies of "I feel her".
final class BinduMandalaUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// Today with a rich Ring-2 Karṣiṇī (kp 29, Kāmākarṣiṇī — carries a phonetic).
    private func launchToday() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "START_TAB=rite", "ENERGY_POS=29"]
        app.launch()
        return app
    }

    /// Today → tap "know her ›" → her full Detail (the hero shows her phonetic,
    /// which only appears on the Detail, so it proves the transition happened).
    func testTodayOpensDetail() {
        let app = launchToday()
        let knowHer = app.buttons["know her ›"]
        XCTAssertTrue(knowHer.waitForExistence(timeout: 12), "Today should offer 'know her ›'")
        knowHer.tap()
        let phonetic = app.staticTexts["KAH · MAH · KAR · SHI · NEE"]
        XCTAssertTrue(phonetic.waitForExistence(timeout: 8), "Detail hero should show her phonetic")
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
        feelHer.tap()
        let felt = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'felt here'")).firstMatch
        XCTAssertTrue(felt.waitForExistence(timeout: 20), "Recognition ceremony should show 'she was felt here'")
    }
}
