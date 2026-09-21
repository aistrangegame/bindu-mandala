// Measures the Debug build's spike apparatus, which is compiled out of Release.
// The scheme's test action builds Debug, so these always run; a Release-configured
// test run simply has no spike suite rather than failing to compile.
#if DEBUG
import XCTest
import SwiftUI
@testable import Bindu_Mandala

/// The G5 baseline run: what the shipped Living Mandala already costs.
///
/// Gated — see `enabled` below for the two ways to open it. It holds the device
/// for about three minutes and must never slow the ordinary suite.
///
/// **Read every number it prints as a simulator number.** It measures the real
/// shipped `MandalaCanvasLayer` — unmodified, not a copy — but it measures it on a
/// simulator, whose GPU is the Mac's and whose CPU is not the phone's. Absolute
/// milliseconds and megabytes here do not predict device behaviour. Only the
/// relative standing of two variants measured the same way in the same session is
/// worth anything, which is exactly what a baseline is for.
final class SpikeBaselineBenchTests: XCTestCase {

    /// The bench holds a simulator for about three minutes, so it is gated and never
    /// runs in the ordinary suite. Two ways to open it, because the two ways people
    /// run tests differ:
    ///
    /// * **From Xcode** — add `SPIKE_BENCH=1` to the scheme's Test action environment.
    /// * **From `xcodebuild`** — build with the compilation condition:
    ///   `SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH"`.
    ///
    /// `TEST_RUNNER_SPIKE_BENCH=1` does **not** work for this one, and the reason is
    /// worth writing down: `xcodebuild` forwards `TEST_RUNNER_*` into a *UI-test
    /// runner* process, not into a unit test's host app. Measured 2026-09-21 on
    /// Xcode 26.5 — with that setting accepted and echoed by `xcodebuild`, the host
    /// app's environment carried only `TESTMANAGERD_SIM_SOCK` and
    /// `TESTMANAGERD_REMOTE_AUTOMATION_SIM_SOCK`. A gate that silently skips is
    /// worse than no gate, so it reads a flag the command line can genuinely set.
    private var enabled: Bool {
        #if SPIKE_BENCH
        return true
        #else
        return ProcessInfo.processInfo.environment["SPIKE_BENCH"] == "1"
        #endif
    }

    /// XCTest's execution-time allowance kills the host with `signal kill` part way
    /// through a long residency, and the kill reads as a crash rather than a
    /// timeout, which cost an hour to diagnose the first time. Each measured window
    /// is 1.5 s of warm-up plus 20 s of sampling plus a 0.4 s teardown, so a
    /// two-window test is a little under 45 s; the allowance is raised anyway so a
    /// slow host cannot turn a measurement into a failure.
    override func setUp() {
        super.setUp()
        executionTimeAllowance = 600
    }

    // The four scenes are separate tests, numbered so the default alphabetical
    // ordering runs them floor-first. They still share one process — XCTest does not
    // relaunch the host between methods — so the footprint figures remain
    // comparable across them, which was the whole point of one long residency.
    // Splitting only bounds how much of the baseline a single kill can take with it.

    /// The floor: ground + day glow, no canvas. Subtract it and what remains is the
    /// Mandala's own cost.
    @MainActor
    func test1ControlFloor() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await run(.control, windows: [("control", 0)])
    }

    @MainActor
    func test2Tier0AllSeats() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await run(.tier0AllSeats, windows: Self.bothWindows)
    }

    @MainActor
    func test3Tier2Bloom() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await run(.tier2Bloom, windows: Self.bothWindows)
    }

    @MainActor
    func test4Descent() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await run(.descent, windows: Self.bothWindows)
    }

    // MARK: - The shared run

    /// The room at its opening, and the room with the scripted clock driven past a
    /// second adaptation.
    private static let bothWindows: [(String, TimeInterval)] = [
        ("A · first adaptation (t=0)", 0),
        ("B · past second adaptation (t=347s)", 347),
    ]

    private static let skipReason =
        "build with SWIFT_ACTIVE_COMPILATION_CONDITIONS=\"DEBUG SPIKE_BENCH\" (or SPIKE_BENCH=1 in the scheme) to run the spike bench"

    @MainActor
    private func run(_ scene: SpikeScene, windows: [(String, TimeInterval)]) async throws {
        let field = SpikeField()
        for (window, offset) in windows {
            let r = await SpikeBench.measure(
                scene: scene, window: window, clockOffset: offset, field: field)
            SpikeMetrics.emit(r)
            XCTAssertGreaterThan(r.frames, 60,
                                 "\(r.label) / \(r.window) produced too few frames to mean anything")
        }
    }
}
#endif
