// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here — including SpikeBench's hiding and restoring of
// the practitioner's own window — can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import SwiftUI
import UIKit

/// Runs one measured window: puts a scene on screen in its own window, samples it
/// for a fixed wall-clock stretch, and hands back a report.
///
/// It is written so a spike variant needs to supply only a `View` — the ruler,
/// the warm-up, the windowing and the reporting are shared, which is the whole
/// point of measuring a baseline first.
///
/// Every number it produces is a **simulator** number. See `SpikeMetrics`.
@MainActor
enum SpikeBench {

    /// Frames thrown away at the head of every window. The first frames of any
    /// SwiftUI scene pay for view-graph construction, font resolution and the first
    /// texture allocations; counting them would make whichever variant ran first
    /// look worst.
    static let warmupSeconds: TimeInterval = 1.5

    /// The device this process is running on, named the way the report should name it.
    static var deviceLabel: String {
        let env = ProcessInfo.processInfo.environment
        let model = env["SIMULATOR_MODEL_IDENTIFIER"] ?? "unknown-model"
        let name = env["SIMULATOR_DEVICE_NAME"] ?? UIDevice.current.name
        let udid = env["SIMULATOR_UDID"] ?? "no-udid"
        return "\(name) [\(model)] \(udid)"
    }

    /// Measure one scene for `seconds`, with the scripted clock placed at `clockOffset`.
    ///
    /// - Parameter clockOffset: scene time to start at. 0 is the room's opening;
    ///   347+ is past a second adaptation. The harness's own script obeys it.
    ///   The shipped `MandalaCanvasLayer` reads its own `TimelineView` date and
    ///   cannot be fast-forwarded without editing it, which this spike may not do —
    ///   so for the baseline the offset moves the scripted camera track and bloom
    ///   cadence, and the canvas's internal breath stays on the real clock. That
    ///   limitation is written into every report's `clockNote`.
    static func measure(scene: SpikeScene,
                        window: String,
                        clockOffset: TimeInterval,
                        seconds: TimeInterval = 20,
                        reduceMotion: Bool = false,
                        field: SpikeField = SpikeField()) async -> SpikeMetrics.Report {

        let clock = SpikeMetrics.Clock(offset: clockOffset)
        let script = SpikeScript(scene: scene, field: field, clock: clock)
        let host = UIHostingController(
            rootView: SpikeMandalaHarness(script: script, reduceMotion: reduceMotion))
        host.view.backgroundColor = .black

        let benchWindow = makeWindow(root: host)
        let size = benchWindow.bounds.size

        // Warm up: build the view graph, resolve the fonts, let the first textures land.
        try? await Task.sleep(nanoseconds: UInt64(warmupSeconds * 1_000_000_000))
        // Then re-zero the scripted clock so the measured window truly begins at
        // `clockOffset` rather than `clockOffset + warmup`.
        clock.restart(offset: clockOffset)

        let sampler = SpikeMetrics.FrameSampler()
        sampler.start()
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        sampler.stop()

        // Census replayed off the clock, after the window closed, so counting costs
        // the measurement nothing.
        var census = SpikeMetrics.CensusAccumulator()
        if scene != .control {
            let censusSeats = field.censusSeats
            for (n, t) in sampler.frameRefTimes.enumerated() {
                // The replay runs on the main actor, and a main actor held for long
                // enough reads as an unresponsive app: the first bench run was killed
                // with `signal kill` part way through the bloom for exactly that.
                // The work is cheap now that the census walks plain values, but
                // yielding keeps that failure mode permanently out of reach.
                if n % 64 == 0 { await Task.yield() }
                let st = script.state(atScene: clock.sceneTime(now: t), in: size)
                census.add(MandalaDrawCensus.tally(.init(
                    camera: st.camera, size: size, seats: censusSeats,
                    todayKp: field.todayKp, focusKp: st.focusKp, familyKp: st.familyKp,
                    countByKp: field.countByKp,
                    flashRing: st.flash?.ring, flashBornAt: st.flash?.bornAt,
                    constellation: st.constellation, constellationStart: st.constellationStart,
                    reduceMotion: reduceMotion, t: t)))
            }
        }

        let report = sampler.finish(
            label: scene.label,
            device: deviceLabel,
            window: window,
            clockNote: clockNote(offset: clockOffset),
            census: census)

        teardown(benchWindow)
        // Let the window actually go away before the next scene is built.
        try? await Task.sleep(nanoseconds: 400_000_000)
        return report
    }

    private static func clockNote(offset: TimeInterval) -> String {
        offset == 0
            ? "scene clock at t=0"
            : "scene clock driven to t=\(Int(offset))s (no waiting); the shipped canvas's own breath/twinkle/flare read the system clock and were not fast-forwarded — editing them is out of scope for this spike"
    }

    // MARK: - Windowing

    private static var retained: UIWindow?
    private static var quieted: [UIWindow] = []

    /// The bench runs inside the app that hosts the unit tests, so the app's own
    /// root — the Rite, with its own breathing — is alive underneath. Hidden for the
    /// duration of a window and restored afterwards, so the CPU the report attributes
    /// to a scene is the scene's and not the room next door's.
    private static func quietOtherWindows(except mine: UIWindow) {
        for scene in UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }) {
            for w in scene.windows where w !== mine && !w.isHidden {
                w.isHidden = true
                quieted.append(w)
            }
        }
    }

    private static func restoreOtherWindows() {
        for w in quieted { w.isHidden = false }
        quieted.removeAll()
    }

    private static func makeWindow(root: UIViewController) -> UIWindow {
        let w: UIWindow
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first {
            w = UIWindow(windowScene: scene)
        } else {
            w = UIWindow(frame: UIScreen.main.bounds)
        }
        w.windowLevel = .alert + 1
        w.backgroundColor = .black
        w.isOpaque = true
        w.rootViewController = root
        w.makeKeyAndVisible()
        retained = w
        quietOtherWindows(except: w)
        return w
    }

    private static func teardown(_ w: UIWindow) {
        restoreOtherWindows()
        w.isHidden = true
        w.rootViewController = nil
        if retained === w { retained = nil }
    }
}
#endif
