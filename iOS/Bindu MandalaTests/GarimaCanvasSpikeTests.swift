// Measures the Debug build's spike apparatus, which is compiled out of Release.
// The scheme's test action builds Debug, so these always run; a Release-configured
// test run simply has no spike suite rather than failing to compile.
#if DEBUG
import XCTest
import SwiftUI
import UIKit
import QuartzCore
@testable import Bindu_Mandala

/// Variant B of the charter §4 renderer spike — Garimā drawn in `Canvas` +
/// `TimelineView` — held to the same three registers Design's own V3 harness
/// holds a room to, plus the G5 ruler.
///
/// * **canon** — her light is `Atmosphere`'s, her clock is Design's, her rock is
///   keyed to her khaḍgamālā position.
/// * **distinction** — the room reverses its premise at the second adaptation,
///   and the reversal is *what the pressing made*, not the press undone.
/// * **legibility** — the room really renders: never black, never blown out,
///   always internally contrasted, always visibly changed. Design verified the
///   web room by `gl.readPixels`; this verifies the Swift room by reading the
///   pixels `ImageRenderer` actually produced.
///
/// The frame-time bench is gated (see `benchEnabled`) because it holds a
/// simulator for about a minute. Everything else is pure and always runs.
final class GarimaCanvasSpikeTests: XCTestCase {

    private let plate = CGSize(width: 393, height: 852)   // iPhone 17, points

    override func setUp() {
        super.setUp()
        executionTimeAllowance = 600
    }

    // MARK: - Canon · her light is Atmosphere's, not a gemstone's

    func testHerLightIsTheAppsOwnAtmosphere() {
        let her = GarimaCanvasRoom.garima()
        XCTAssertEqual(her.khadgamalaPosition, 4, "position is identity")
        XCTAssertEqual(her.ringNumber, 1, "Garimā sits in Trailokyamohana")
        XCTAssertEqual(her.element, .earth, "Pṛthvī — Ring 1's element")

        // The seed, unpicked: ring 1's hue plus her own ±7° jitter.
        let seed = Atmosphere.ringHue(1)
        XCTAssertEqual(seed.h, 35, accuracy: 0.0001)
        let jitter = Atmosphere.jitter(4, 14)
        XCTAssertEqual(jitter, -6.384, accuracy: 0.001,
                       "the 2654435761 hash over range 14 — her jitter, not anyone's")

        let atmosphere = Atmosphere.derive(from: her)
        XCTAssertEqual(atmosphere.hue.h, HSL.wrap(35 + jitter), accuracy: 0.0001,
                       "the room's hue must be the seed plus her jitter and nothing else")
        XCTAssertEqual(atmosphere.hue.s, seed.s, accuracy: 0.0001)
        XCTAssertEqual(atmosphere.hue.l, seed.l, accuracy: 0.0001)

        // Ring 1 is topaz at 0.20 — carried as behaviour, and it is the room's.
        XCTAssertEqual(GarimaCanvasRoom.gemDiffusionForTesting(ring: 1), 0.20, accuracy: 0.0001)
        XCTAssertEqual(GarimaCanvasRoom.gemDiffusionForTesting(ring: 7), 0.95, accuracy: 0.0001,
                       "pearl is sourceless — the table is the whole nine, not one entry")

        // Her seat in the body sets where the room's one warm light sits, and it
        // is the lowest reading in the garland.
        XCTAssertEqual(GarimaCanvasRoom.altitudeForTesting(of: her.bodilyLocation), 0.0, accuracy: 0.0001,
                       "Mūlādhāra / sit-bones / soles — the ember is on the ground")
        XCTAssertGreaterThan(GarimaCanvasRoom.altitudeForTesting(of: "Crown and spine alignment"), 0.9,
                             "the same reader must place a crown Śakti's light overhead")
    }

    /// Law 1: her rock is hers. Two sisters of one ring get two floors.
    func testTheStrataAreKeyedToHerPositionAlone() {
        let hers = GarimaCanvasRoom.bedHeightsForTesting(position: 4)
        let sister = GarimaCanvasRoom.bedHeightsForTesting(position: 2)
        XCTAssertEqual(hers.count, 33, "thirty-two beds, so thirty-three contacts")
        XCTAssertEqual(hers, GarimaCanvasRoom.bedHeightsForTesting(position: 4),
                       "the bed table must be the same on every read — no Math.random() survived the port")
        XCTAssertNotEqual(hers, sister, "Mahimā's floor is not Garimā's floor")

        var divergence = 0
        for (a, b) in zip(hers, sister) where abs(a - b) > 0.1 { divergence += 1 }
        XCTAssertGreaterThan(Double(divergence) / Double(hers.count), 0.5,
                             "adjacent sisters must diverge in geometry, not only in hue")
        // Design's own walk: values clamped 14…232 out of 255, normalised here.
        XCTAssertTrue(hers.allSatisfy { $0 >= 0 && $0 <= 1 }, "a bed height outside the table's range")
    }

    // MARK: - Canon · the clock is Design's

    func testTheClockIsDesignsAndIsDrivenNotWaitedOn() {
        XCTAssertEqual(GarimaCanvasRoom.firstAdaptation, 62)
        XCTAssertEqual(GarimaCanvasRoom.holdEnd, 227)
        XCTAssertEqual(GarimaCanvasRoom.secondSpan, 120)
        XCTAssertEqual(GarimaCanvasRoom.secondAdaptationEnd, 347)

        // The harness drives it; nobody waits six minutes.
        let clock = SpikeMetrics.Clock(offset: 347)
        XCTAssertGreaterThanOrEqual(clock.sceneTime(), 347)
        XCTAssertLessThan(clock.sceneTime(), 348)

        // The first adaptation resolves at 62 and then holds, flat, to 227.
        let k = GarimaCanvasRoom.progressForTesting
        XCTAssertEqual(k(0).first, 0, accuracy: 0.0001)
        XCTAssertGreaterThan(k(31).first, 0.4)
        XCTAssertLessThan(k(31).first, 0.6)
        XCTAssertEqual(k(62).first, 1, accuracy: 0.0001)
        XCTAssertEqual(k(226).second, 0, accuracy: 0.0001, "nothing turns before 227")
        XCTAssertEqual(k(347).second, 1, accuracy: 0.0001, "and it is wholly turned by 347")
        XCTAssertGreaterThan(k(287).second, 0.4)
        XCTAssertLessThan(k(287).second, 0.6)
    }

    // MARK: - Distinction · the premise, and then its reversal

    /// The first adaptation presses: the mass comes down, the floor thickens,
    /// the raking light is squeezed out. The second does not undo it — the mass
    /// lifts, but what the pressing *made* is what now carries the light.
    func testTheRoomPressesAndThenReversesItsOwnPremise() {
        let open = GarimaCanvasRoom.stateForTesting(at: 0)
        let pressed = GarimaCanvasRoom.stateForTesting(at: 227)
        let turned = GarimaCanvasRoom.stateForTesting(at: 400)

        // The press.
        XCTAssertLessThan(pressed.massBottomY, open.massBottomY - 6,
                          "the ceiling must actually come down")
        XCTAssertGreaterThan(pressed.displacement, open.displacement * 4,
                             "the floor must actually thicken into strata")
        XCTAssertLessThan(pressed.raking, open.raking,
                          "the raking light fades as the mass takes the room")
        XCTAssertLessThan(pressed.litFloorDepth, open.litFloorDepth * 0.6,
                          "and the lit strip on the floor is squeezed toward the walker")

        // The reversal — not the press undone.
        XCTAssertGreaterThan(turned.massBottomY, pressed.massBottomY + 4,
                             "the weight lifts")
        XCTAssertGreaterThan(turned.displacement, pressed.displacement,
                             """
                             the strata must KEEP growing past the second adaptation. If the floor \
                             relaxed, the reversal would be the press undone, which is the one thing \
                             Design's rule forbids.
                             """)
        XCTAssertEqual(pressed.emissive, 0, accuracy: 0.0001,
                       "the floor carries no light of its own during the press")
        XCTAssertEqual(turned.emissive, 1, accuracy: 0.0001,
                       "and it is the room's source once the room has turned")
        XCTAssertLessThan(turned.raking, pressed.raking * 0.55,
                          "the side light all but goes — the room is lit from what it is standing on")
        XCTAssertGreaterThan(turned.impressionScale, pressed.impressionScale * 2.5,
                             "the impression opens")
        XCTAssertLessThan(turned.settle, 0,
                          "the dust stops falling and comes up through the light from below")
        XCTAssertGreaterThan(pressed.settle, 0, "during the press it falls")
    }

    // MARK: - Legibility · the room really renders

    /// Design verified the web rooms with `gl.readPixels` luminance grids and
    /// reported Garimā at 13→204 with a real shadow band. This is the same
    /// check, on the pixels `ImageRenderer` produced.
    @MainActor
    func testTheRoomIsLegibleAtBothAdaptationsAndVisiblyChanges() throws {
        let press = try grid(at: GarimaCanvasRoom.firstAdaptation)
        let turn = try grid(at: GarimaCanvasRoom.secondAdaptationEnd + 53)

        for (label, g) in [("first adaptation", press), ("past the second", turn)] {
            let lo = g.min() ?? 0, hi = g.max() ?? 0
            let mean = g.reduce(0, +) / Double(g.count)
            print(String(format: "GARIMA_LUMA {\"window\":\"%@\",\"min\":%.0f,\"max\":%.0f,\"mean\":%.1f}",
                         label, lo, hi, mean))
            XCTAssertGreaterThan(hi, 90, "\(label): the room is black — nothing is lit")
            XCTAssertLessThan(lo, 70, "\(label): the room has no shadow — it is a wash, not a lit space")
            XCTAssertGreaterThan(hi - lo, 70, "\(label): the room is not internally contrasted")
            XCTAssertLessThan(mean, 175, "\(label): the room is blown out")
            XCTAssertGreaterThan(mean, 8, "\(label): the room is too dark to read")
        }

        // Visibly changed — Design's own legibility register.
        var delta = 0.0
        for (a, b) in zip(press, turn) { delta += abs(a - b) }
        delta /= Double(press.count)
        print(String(format: "GARIMA_LUMA {\"window\":\"delta\",\"meanAbs\":%.1f}", delta))
        XCTAssertGreaterThan(delta, 9,
                             "the two adaptations look the same — the reversal never reached the screen")
    }

    /// The reduce-motion path is a real one: no `TimelineView` is built, the
    /// scene time is quantised to a resting state, and the room that arrives is
    /// the settled one rather than a frozen mid-transition.
    @MainActor
    func testReduceMotionReachesTheSettledStateWithoutAnimating() throws {
        // Quantisation: anything late in the visit resolves to the turned room.
        XCTAssertEqual(GarimaCanvasRoom.restingState(near: 400), 400)
        XCTAssertEqual(GarimaCanvasRoom.restingState(near: 300), 400,
                       "past the second adaptation the resting state is the turned room")
        XCTAssertEqual(GarimaCanvasRoom.restingState(near: 200), GarimaCanvasRoom.holdEnd,
                       "mid-hold, the resting state is the room with its first adaptation resolved")
        XCTAssertEqual(GarimaCanvasRoom.restingState(near: 20), 0, "and at the opening, the opening")

        // Nothing in the scene depends on the clock's phase when motion is off:
        // two instants a second apart must be the same room, exactly.
        let a = GarimaCanvasRoom.census(shakti: GarimaCanvasRoom.garima(),
                                        at: 400, in: plate, reduceMotion: true)
        let b = GarimaCanvasRoom.census(shakti: GarimaCanvasRoom.garima(),
                                        at: 400.97, in: plate, reduceMotion: true)
        XCTAssertEqual(a, b, "a term is still oscillating under reduce-motion")

        // And it renders — the settled room, legible.
        let still = try grid(at: 400, reduceMotion: true)
        XCTAssertGreaterThan(still.max() ?? 0, 90, "the reduce-motion room is black")
        XCTAssertGreaterThan((still.max() ?? 0) - (still.min() ?? 0), 70,
                             "the reduce-motion room is not internally contrasted")
    }

    // MARK: - The census · exact, not modelled

    /// Unlike `MandalaDrawCensus`, this is not a model of the draw — the renderer
    /// tallies through the same `Draftsman` that issues the primitives, so a nil
    /// context turns the render itself into the count. It is therefore a pure
    /// function of the clock and the frame, reproducible on any machine.
    func testCensusIsDeterministicAndWithinTheG5Family() {
        let her = GarimaCanvasRoom.garima()
        for (window, offset) in [("A · into the first adaptation", 42.0),
                                 ("B · past the second adaptation", 347.0)] {
            var total = 0, worst = 0
            var worstBreakdown = ""
            let frames = 1200            // 20 seconds at 60 Hz
            for f in 0..<frames {
                let t = offset + Double(f) / 60.0
                let tally = GarimaCanvasRoom.census(shakti: her, at: t, in: plate, reduceMotion: false)
                total += tally.total
                if tally.total > worst { worst = tally.total; worstBreakdown = tally.breakdown }
            }
            let mean = Double(total) / Double(frames)
            print(String(format:
                "GARIMA_CENSUS {\"room\":\"garima-canvas\",\"window\":\"%@\",\"frames\":%d,"
                + "\"primitivesMean\":%.1f,\"primitivesWorst\":%d,\"worstBreakdown\":\"%@\"}",
                window, frames, mean, worst, worstBreakdown))

            // The G5 baseline's own family: the shipped tier-0 Mandala draws 263
            // primitives a frame and the deep-zoom bloom 80. A room that drew an
            // order more than the instrument it lives inside would be the finding,
            // whatever its frame time said.
            XCTAssertGreaterThan(mean, 60, "\(window): the room draws almost nothing — it is not rendering")
            XCTAssertLessThan(mean, 280, "\(window): the room draws more than the whole Living Mandala")
            XCTAssertLessThanOrEqual(worst, 300, "\(window): a frame worse than the G5 baseline ever saw")
        }

        // Determinism: the same instant counts the same, always.
        let once = GarimaCanvasRoom.census(shakti: her, at: 123.456, in: plate, reduceMotion: false)
        let twice = GarimaCanvasRoom.census(shakti: her, at: 123.456, in: plate, reduceMotion: false)
        XCTAssertEqual(once, twice)
        XCTAssertEqual(once.total,
                       once.air + once.farWall + once.sideWalls + once.mass + once.strata
                       + once.crests + once.impression + once.bloom + once.dust + once.veil,
                       "the breakdown must account for the whole frame")
    }

    // MARK: - The stills

    /// Writes the two screenshots the spike is judged on. Cheap — two
    /// `ImageRenderer` passes — so it runs with the ordinary suite.
    @MainActor
    func testWritesTheStills() throws {
        let shots: [(String, TimeInterval, Bool)] = [
            ("garima-canvas-first-adaptation", GarimaCanvasRoom.firstAdaptation, false),
            ("garima-canvas-past-second-adaptation", GarimaCanvasRoom.secondAdaptationEnd + 53, false),
            ("garima-canvas-opening", 0, false),
            ("garima-canvas-reduce-motion-settled", 400, true),
        ]
        for (name, t, reduce) in shots {
            let image = try XCTUnwrap(render(at: t, reduceMotion: reduce),
                                      "\(name): the room produced no image")
            let data = try XCTUnwrap(UIImage(cgImage: image).pngData())
            let url = Self.shotsDirectory.appendingPathComponent("\(name).png")
            try data.write(to: url)
            print("GARIMA_SHOT \(url.path)")
        }
    }

    /// `…/wt-garima-canvas/iOS/Bindu MandalaTests/…` → the worktree, then out to
    /// the scratchpad the task names. Falls back to the simulator's own tmp when
    /// that is not writable, and prints wherever it landed either way.
    private static let shotsDirectory: URL = {
        let repoRoot = URL(fileURLWithPath: #filePath)
            .resolvingSymlinksInPath()
            .deletingLastPathComponent()    // Bindu MandalaTests
            .deletingLastPathComponent()    // iOS
            .deletingLastPathComponent()    // worktree
        let wanted = repoRoot
            .deletingLastPathComponent()    // scratchpad
            .appendingPathComponent("garima-shots/canvas", isDirectory: true)
        if (try? FileManager.default.createDirectory(at: wanted, withIntermediateDirectories: true)) != nil,
           FileManager.default.isWritableFile(atPath: wanted.path) {
            return wanted
        }
        let fallback = FileManager.default.temporaryDirectory
            .appendingPathComponent("garima-shots/canvas", isDirectory: true)
        try? FileManager.default.createDirectory(at: fallback, withIntermediateDirectories: true)
        return fallback
    }()

    // MARK: - The bench
    //
    // Frame time, memory and the host's load, taken with the committed ruler —
    // `SpikeMetrics.FrameSampler` — so this room and the shipped Mandala are
    // measured by exactly the same instrument. Gated: build with
    // `SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH"`.
    //
    // Every figure is a **simulator** figure. See `SpikeMetrics`.

    private var benchEnabled: Bool {
        #if SPIKE_BENCH
        return true
        #else
        return ProcessInfo.processInfo.environment["SPIKE_BENCH"] == "1"
        #endif
    }

    private static let skipReason =
        "build with SWIFT_ACTIVE_COMPILATION_CONDITIONS=\"DEBUG SPIKE_BENCH\" to run the Garimā bench"

    /// Construction of the room to its first presented frame. Not the app's cold
    /// start — the process is already alive under XCTest — so the process's own
    /// age is reported beside it rather than dressed up as a launch figure.
    @MainActor
    func test1ColdLaunchToFirstFrame() async throws {
        try XCTSkipUnless(benchEnabled, Self.skipReason)
        let load = SpikeMetrics.hostLoadAverage()
        let before = CACurrentMediaTime()
        var firstFrame: CFTimeInterval = 0

        CATransaction.begin()
        CATransaction.setCompletionBlock { firstFrame = CACurrentMediaTime() }
        let window = GarimaRoomLaunch.present(.init(sceneTime: 0), shakti: GarimaCanvasRoom.garima())
        window.layoutIfNeeded()
        CATransaction.commit()

        for _ in 0..<600 where firstFrame == 0 {
            try? await Task.sleep(nanoseconds: 5_000_000)
        }
        GarimaRoomLaunch.dismiss(window)

        let ms = (firstFrame > 0 ? firstFrame - before : -1) * 1000
        print(String(format:
            "GARIMA_LAUNCH {\"roomToFirstFrameMs\":%.1f,\"processAgeSec\":%.2f,"
            + "\"footprintMB\":%.1f,\"hostLoad\":%.2f,\"device\":\"%@\"}",
            ms, SpikeMetrics.processAgeSeconds(), SpikeMetrics.footprintMB(),
            load, SpikeBench.deviceLabel))
        XCTAssertGreaterThan(firstFrame, 0, "the room never presented a frame")
    }

    @MainActor
    func test2FrameTimeAtBothAdaptations() async throws {
        try XCTSkipUnless(benchEnabled, Self.skipReason)
        for (window, offset, reduce) in [
            ("A · into the first adaptation (t=42→62s)", 42.0, false),
            ("B · past the second adaptation (t=347→367s)", 347.0, false),
            ("C · reduce-motion, settled", 400.0, true),
        ] {
            let report = await bench(window: window, offset: offset, reduceMotion: reduce)
            SpikeMetrics.emit(report)
            XCTAssertGreaterThan(report.frames, 60, "\(window) produced too few frames to mean anything")
            if report.hostLoadAtStart > 6 || report.hostLoadAtEnd > 6 {
                print("GARIMA_WARNING {\"window\":\"\(window)\",\"reason\":\"host load above 6 on 8 cores — throw this window out and retake it\"}")
            }
        }
    }

    @MainActor
    private func bench(window: String,
                       offset: TimeInterval,
                       reduceMotion: Bool,
                       seconds: TimeInterval = 20) async -> SpikeMetrics.Report {
        let clock = SpikeMetrics.Clock(offset: offset)
        let host = UIHostingController(
            rootView: GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                                       clock: clock,
                                       reduceMotion: reduceMotion))
        host.view.backgroundColor = .black
        let benchWindow = makeWindow(root: host)

        // The app's own root — the Rite, breathing — is alive underneath the test
        // host. Hidden for the window so the CPU this report attributes to the
        // room is the room's, exactly as `SpikeBench` does it.
        var quieted: [UIWindow] = []
        for scene in UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }) {
            for w in scene.windows where w !== benchWindow && !w.isHidden {
                w.isHidden = true
                quieted.append(w)
            }
        }

        try? await Task.sleep(nanoseconds: UInt64(SpikeBench.warmupSeconds * 1_000_000_000))
        clock.restart(offset: offset)

        let sampler = SpikeMetrics.FrameSampler()
        sampler.start()
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        sampler.stop()

        let note = reduceMotion
            ? "reduce-motion: no TimelineView is built, so the room is a still and the presented-frame cadence is the display's, not the room's"
            : "scene clock driven to t=\(Int(offset))s (no waiting); primitive counts are in the GARIMA_CENSUS lines, which are exact rather than sampled"
        let report = sampler.finish(
            label: "garimā · canvas + TimelineView",
            device: SpikeBench.deviceLabel,
            window: window,
            clockNote: note,
            census: SpikeMetrics.CensusAccumulator())

        for w in quieted { w.isHidden = false }
        benchWindow.isHidden = true
        benchWindow.rootViewController = nil
        try? await Task.sleep(nanoseconds: 400_000_000)
        return report
    }

    @MainActor
    private func makeWindow(root: UIViewController) -> UIWindow {
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
        return w
    }

    // MARK: - Rendering helpers

    @MainActor
    private func render(at sceneTime: TimeInterval, reduceMotion: Bool = false) -> CGImage? {
        let room = GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                                    clock: SpikeMetrics.Clock(),
                                    reduceMotion: reduceMotion,
                                    frozenSceneTime: sceneTime)
            .frame(width: plate.width, height: plate.height)
        let renderer = ImageRenderer(content: room)
        renderer.scale = 2
        renderer.isOpaque = true
        return renderer.cgImage
    }

    /// A luminance grid — Design's `gl.readPixels` check, done on a CGImage.
    @MainActor
    private func grid(at sceneTime: TimeInterval,
                      reduceMotion: Bool = false,
                      cells: Int = 24) throws -> [Double] {
        let image = try XCTUnwrap(render(at: sceneTime, reduceMotion: reduceMotion),
                                  "the room produced no image at t=\(sceneTime)")
        let count = cells * cells
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
        buffer.initialize(repeating: 0, count: count)
        defer { buffer.deinitialize(count: count); buffer.deallocate() }
        let ctx = try XCTUnwrap(CGContext(data: buffer,
                                          width: cells, height: cells,
                                          bitsPerComponent: 8, bytesPerRow: cells,
                                          space: CGColorSpaceCreateDeviceGray(),
                                          bitmapInfo: CGImageAlphaInfo.none.rawValue))
        ctx.interpolationQuality = .medium
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: cells, height: cells))
        return (0..<count).map { Double(buffer[$0]) }
    }
}
#endif
