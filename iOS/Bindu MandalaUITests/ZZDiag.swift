import XCTest

final class ZZDiag: XCTestCase {
    func testDumpDetailTail() {
        let app = XCUIApplication()
        app.launchArguments = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                               "ENERGY_POS=29", "EPHEMERAL_STORE",
                               "START_TAB=mandala", "OPEN_DETAIL=33"]
        app.launch()
        _ = app.buttons.matching(NSPredicate(format: "label == 'her moments'"))
            .firstMatch.waitForExistence(timeout: 40)
        Thread.sleep(forTimeInterval: 2.0)
        for f in ScreenReader.read(app) {
            print("DIAG \(f.line)")
        }
        print("DIAG bounds \(app.frame)")
    }
}
