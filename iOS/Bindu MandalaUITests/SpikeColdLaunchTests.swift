// Measures the Debug build's spike apparatus, which is compiled out of Release.
// The scheme's test action builds Debug, so these always run; a Release-configured
// test run simply has no spike suite rather than failing to compile.
#if DEBUG
import XCTest

/// Cold launch to the Mandala's first frame — measured on the **real shipped app**,
/// with nothing added to it. `START_TAB=mandala` already exists as a launch
/// argument, so the room is the first screen and the app's cold start *is* the
/// room's cold start.
///
/// What the number is: wall clock from just before `XCUIApplication.launch()` to
/// the moment the room's title is queryable. That is an upper bound — it carries
/// the XCUITest launch handshake and the accessibility query, neither of which a
/// practitioner pays. Take the best of the iterations as the closest thing to the
/// truth and the mean as the honest headline. And it is still a simulator figure.
///
/// Gated — see `enabled` below for the two ways to open it, so the ordinary
/// suite is not slowed.
final class SpikeColdLaunchTests: XCTestCase {

    override func setUp() { continueAfterFailure = false }

    /// The bench holds a simulator for about three minutes, so it is gated and never
    /// runs in the ordinary suite. Two ways to open it, because the two ways people
    /// run tests differ:
    ///
    /// * **From Xcode** — add `SPIKE_BENCH=1` to the scheme's Test action environment.
    /// * **From `xcodebuild`** — build with the compilation condition:
    ///   `SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH"`.
    ///
    /// `TEST_RUNNER_SPIKE_BENCH=1` would also reach *this* one — `xcodebuild`
    /// forwards `TEST_RUNNER_*` into a UI-test runner process. It does not reach a
    /// unit test's host app, which is where the frame bench lives, so both suites
    /// take the compilation condition instead and the baseline has one recipe
    /// rather than two.
    private var enabled: Bool {
        #if SPIKE_BENCH
        return true
        #else
        return ProcessInfo.processInfo.environment["SPIKE_BENCH"] == "1"
        #endif
    }

    func testColdLaunchToMandalaFirstFrame() throws {
        try XCTSkipUnless(enabled, "build with SWIFT_ACTIVE_COMPILATION_CONDITIONS=\"DEBUG SPIKE_BENCH\" (or SPIKE_BENCH=1 in the scheme) to run the spike bench")

        var samples: [Double] = []
        for _ in 0..<5 {
            let app = XCUIApplication()
            // SYNC_OFF so no launch measures a network round trip; SKIP_HOMECOMING
            // and SKIP_SUMMONS so nothing covers the room on the way in.
            app.launchArguments = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "START_TAB=mandala",
                                   "ENERGY_POS=29", "SYNC_OFF"]
            let t0 = Date()
            app.launch()
            let title = app.staticTexts["Śrī Yantra"]
            XCTAssertTrue(title.waitForExistence(timeout: 20), "the Mandala should arrive")
            samples.append(Date().timeIntervalSince(t0) * 1000)
            app.terminate()
        }

        let mean = samples.reduce(0, +) / Double(samples.count)
        let best = samples.min() ?? 0
        let worst = samples.max() ?? 0
        let each = samples.map { String(format: "%.0f", $0) }.joined(separator: ", ")
        print("SPIKE_LAUNCH {\"scene\":\"shipped Living Mandala (START_TAB=mandala)\","
              + "\"iterations\":\(samples.count),"
              + String(format: "\"meanMs\":%.0f,\"bestMs\":%.0f,\"worstMs\":%.0f,", mean, best, worst)
              + "\"eachMs\":[\(each)],"
              + "\"note\":\"simulator; wall clock around XCUITest launch + first accessible element — an upper bound, not a device figure\"}")
    }
}
#endif
