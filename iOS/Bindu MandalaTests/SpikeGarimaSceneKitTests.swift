// Measures the Debug build's spike apparatus, which is compiled out of Release.
// The scheme's test action builds Debug, so these always run; a Release-configured
// test run simply has no spike suite rather than failing to compile.
#if DEBUG
import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

/// The renderer spike, variant A — SceneKit under a SwiftUI Metal light pass —
/// held to the same ruler the G5 baseline was taken with.
///
/// Two halves, deliberately:
///
/// * **The cheap half runs always.** It asserts the things that are true of the
///   room whether or not anybody renders it: that she is Garimā and not a sister,
///   that the mechanism presses and then reverses, that the reduce-motion path is
///   genuinely not animating, and that the census counts the scene that is really
///   there. These are pure and take milliseconds, so they belong in the ordinary
///   suite where a regression is noticed the same day.
/// * **The measured half is gated**, exactly as `SpikeBaselineBenchTests` is, and
///   for the same reason: it holds a simulator for minutes. Open it with
///   `SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH"` or `SPIKE_BENCH=1`
///   in the scheme's Test action.
///
/// **Every millisecond and megabyte here is a simulator number.** The simulator
/// renders on the Mac's GPU through a translation layer and its CPU is not the
/// phone's. Only the relative standing of two variants measured the same way, on
/// the same host, in the same session is worth anything — and the host's load
/// average is recorded at both ends of every window so a contaminated one can be
/// thrown out rather than believed.
@MainActor
final class SpikeGarimaSceneKitTests: XCTestCase {

    private var enabled: Bool {
        #if SPIKE_BENCH
        return true
        #else
        return ProcessInfo.processInfo.environment["SPIKE_BENCH"] == "1"
        #endif
    }

    private static let skipReason =
        "build with SWIFT_ACTIVE_COMPILATION_CONDITIONS=\"DEBUG SPIKE_BENCH\" (or SPIKE_BENCH=1 in the scheme) to run the spike bench"

    override func setUp() {
        super.setUp()
        executionTimeAllowance = 600
    }

    // MARK: - The room is hers, and no one else's

    /// Everything the room is built from comes off position 4 — and off a sister's
    /// position it comes out different. That second half is the real assertion:
    /// a room that would serve Garimā and Mahimā equally is the failure Design's
    /// own thread records, so it is checked rather than hoped for.
    func testTheIngredientsAreGarimasAndNotASisters() {
        let garima = GarimaSceneKitRoom.Ingredients.garima(from: nil)

        XCTAssertEqual(garima.khadgamalaPosition, 4, "position is identity")
        XCTAssertEqual(garima.ring, 1, "Garimā sits in the first āvaraṇa")
        XCTAssertEqual(garima.diffusion, 0.20, accuracy: 0.0001,
                       "ring 1 is topaz — diffusion 0.20, and the gem gives nothing else")
        XCTAssertEqual(garima.altitude, 0.94, accuracy: 0.0001,
                       "the soles and the Mūlādhāra — the lowest reading Design's zone table gives")

        // Her hue is Atmosphere's, jittered off her own position. Not the gem's.
        let expected = Atmosphere.derive(ring: 1, cluster: nil, khadgamala: 4, element: .earth)
        XCTAssertEqual(garima.atmosphere, expected,
                       "her light is a verbatim read of Atmosphere.derive, never re-derived")
        XCTAssertEqual(garima.atmosphere.hue.h,
                       HSL.wrap(35 + Atmosphere.jitter(4, 14)), accuracy: 0.0001)
        XCTAssertEqual(garima.atmosphere.hue.h, 28.616, accuracy: 0.01,
                       "ring 1's 35° jittered by −6.384° — the repo's own ±7° hash")

        // Her card's one colour word, on her attribute and nowhere else.
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        garima.attributeTint.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(Double(red), 0xB8 / 255.0, accuracy: 0.005)
        XCTAssertEqual(Double(green), 0x26 / 255.0, accuracy: 0.005)
        XCTAssertEqual(Double(blue), 0x3C / 255.0, accuracy: 0.005)

        // And the sisters she stands beside are not her.
        for sister in [1, 2, 3] {
            let other = GarimaSceneKitRoom.Ingredients.make(khadgamalaPosition: sister, from: nil)
            XCTAssertNotEqual(other.atmosphere.hue.h, garima.atmosphere.hue.h,
                              "kp \(sister) must not share her hue")
            XCTAssertNotEqual(other.phase, garima.phase,
                              "kp \(sister) must not share her phase")
        }
    }

    /// Her physics comes out of her tattva, and a sister's tattva takes a different
    /// branch. `settle` has no upward term at all; `lift` is nothing but one.
    func testHerPhysicsIsEarthAndHerSistersAreNot() {
        typealias Physics = GarimaSceneKitRoom.Physics

        XCTAssertEqual(Physics.classify(tattva: "Pṛthvī — earth",
                                        quality: "Weightedness", element: .earth), .settle)
        XCTAssertEqual(Physics.classify(tattva: "Vāyu — air, movement",
                                        quality: "Lightness", element: .earth), .lift,
                       "Laghimā's tattva must beat Ring 1's element floor")
        XCTAssertEqual(Physics.classify(tattva: "Mahat — the vast",
                                        quality: "Vastness", element: .earth), .widen)
        XCTAssertEqual(Physics.classify(tattva: "Aṇu — the atomic",
                                        quality: "Smallness", element: .earth), .shrink)
        // No tattva at all still lands on her element, never on a generic motion.
        XCTAssertEqual(Physics.classify(tattva: "", quality: "", element: .earth), .settle)

        // `settle` only ever sinks. Sampled across a whole cycle, not twice —
        // Design's verifier was wrong once for sampling too thinly.
        var rises = 0
        for step in 0..<400 {
            let t = Double(step) * 0.6
            let d = Physics.settle.displacement(t: t, phase: 0.044, amplitude: 1)
            if d.y > 0.0001 { rises += 1 }
            XCTAssertEqual(d.x, 0, accuracy: 1e-9, "her motion has no lateral term")
            XCTAssertEqual(d.z, 0, accuracy: 1e-9, "her motion has no lateral term")
        }
        XCTAssertEqual(rises, 0, "Garimā's room may never rise on her own physics")

        var lifts = 0
        for step in 0..<400 where
            Physics.lift.displacement(t: Double(step) * 0.6, phase: 0.044, amplitude: 1).y > 0.0001 {
            lifts += 1
        }
        XCTAssertGreaterThan(lifts, 300, "Laghimā's room is the one that lifts")
    }

    // MARK: - The mechanism, and the reversal

    /// The premise: the mass comes down and the floor thickens beneath you, the
    /// whole time. Then, past the second adaptation, the premise reverses.
    func testTheRoomPressesAndThenReversesItsOwnPremise() {
        let her = GarimaSceneKitRoom.Ingredients.garima(from: nil)
        func pose(_ t: TimeInterval) -> GarimaSceneKitRoom.Pose {
            GarimaSceneKitRoom.Pose(sceneTime: t, ingredients: her)
        }

        let opening = pose(0)
        let first = pose(62)
        let held = pose(200)
        let second = pose(347)

        // The press.
        XCTAssertEqual(opening.thickening, 0, accuracy: 0.001)
        XCTAssertEqual(first.thickening, 1, accuracy: 0.001, "the first adaptation resolves at 62 s")
        XCTAssertEqual(held.plinth, 0, accuracy: 0.001, "and then holds, to 227 s")
        XCTAssertEqual(second.plinth, 1, accuracy: 0.001, "the second resolves 120 s after that")

        XCTAssertLessThan(first.massY, opening.massY - 5, "the mass must come down")
        XCTAssertGreaterThan(first.thickening, held.thickening - 0.001)
        XCTAssertLessThan(opening.eyePitch, 0, "the eye starts tipped toward the floor")
        XCTAssertLessThan(first.eyePitch, opening.eyePitch, "and tips further as the mass arrives")
        XCTAssertGreaterThan(second.eyeZ, first.eyeZ + 2,
                             "and stands back far enough to see what is holding you")

        // The reversal. Not the press undone — the strata stay compacted, and what
        // changes is that they are now holding you up.
        XCTAssertEqual(second.thickening, 1, accuracy: 0.001,
                       "what the pressing made is kept; the reversal does not give it back")
        XCTAssertGreaterThan(second.massY, first.massY + 4, "the mass lifts away")
        // Carried up by roughly half a standing height. Not to the mound's own crest
        // — you are beside it, not on its peak — but the ground you are on is
        // demonstrably the thing that rose.
        XCTAssertGreaterThan(second.eyeY, first.eyeY + 1.5,
                             "you are carried up by the thing that was crushing you")
        XCTAssertGreaterThan(second.markEmission, first.markEmission * 2,
                             "the mark she left brightens as the room turns over")
        XCTAssertGreaterThan(second.markScale, first.markScale * 1.7,
                             "and grows, until it is most of what is in front of you")
        XCTAssertLessThan(second.rakingIntensity, first.rakingIntensity * 0.4,
                          "the rake hands its job to the ground")
        XCTAssertLessThan(second.rakingPosition.y, 0,
                          "past the reversal the light is below the floor line")

        // The whole track is continuous — no cut, only travel (Design's invariant 3).
        var previous = pose(0)
        for step in 1...1600 {
            let now = pose(Double(step) / 4)
            XCTAssertLessThan(abs(now.massY - previous.massY), 0.25,
                              "the mass jumped at t=\(Double(step) / 4)")
            XCTAssertLessThan(abs(now.eyeY - previous.eyeY), 0.25,
                              "the eye jumped at t=\(Double(step) / 4)")
            XCTAssertLessThan(abs(now.markY - previous.markY), 0.25,
                              "the mark jumped at t=\(Double(step) / 4)")
            previous = now
        }
    }

    /// The reduce-motion path reaches the settled state, and does not animate to
    /// get there. Both halves are asserted: the state, and the absence of motion.
    func testReduceMotionIsSettledAndReallyStill() {
        let her = GarimaSceneKitRoom.Ingredients.garima(from: nil)
        let settled = GarimaSceneKitRoom.Pose(
            sceneTime: GarimaSceneKitRoom.Ingredients.settledSceneTime, ingredients: her)

        XCTAssertGreaterThanOrEqual(GarimaSceneKitRoom.Ingredients.settledSceneTime,
                                    GarimaSceneKitRoom.Ingredients.secondEnds,
                                    "the settled state is past the second adaptation, not before it")
        XCTAssertEqual(settled.thickening, 1, accuracy: 0.001)
        XCTAssertEqual(settled.plinth, 1, accuracy: 0.001)

        // And on screen: no display link, no continuous rendering, no frames.
        let window = host(clock: SpikeMetrics.Clock(offset: 0), reduceMotion: true)
        defer { teardown(window) }
        pump(seconds: 1.2)

        guard let view = sceneView(in: window) else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertFalse(view.isPlaying, "reduce motion must stop the scene clock")
        XCTAssertFalse(view.rendersContinuously, "reduce motion must stop the render loop")
        XCTAssertEqual(view.scene?.isPaused, true)

        let sampler = SpikeMetrics.FrameSampler()
        sampler.start()
        pump(seconds: 1.0)
        sampler.stop()
        // The display link still ticks — it is the room that has stopped — so the
        // proof is that nothing in the scene moved across those frames, not that
        // the frames are absent.
        let before = view.pointOfView?.position.y
        pump(seconds: 1.0)
        XCTAssertEqual(view.pointOfView?.position.y, before,
                       "the eye moved with reduce motion on")
    }

    // MARK: - The census

    /// The census walks the live scene rather than modelling it, so it cannot drift
    /// from the room it counts. This checks it is really reading — and that the
    /// shadow pass is really there, which is the whole claim of variant A.
    func testTheCensusCountsTheSceneThatIsActuallyThere() {
        let window = host(clock: SpikeMetrics.Clock(offset: 62), reduceMotion: false)
        defer { teardown(window) }
        pump(seconds: 1.5)

        guard let scene = sceneView(in: window)?.scene else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        let census = GarimaSceneKitRoom.census(of: scene)

        XCTAssertEqual(census.shadowCastingLights, 1,
                       "one raking light, casting real shadows — Design's `shadows: true`")
        XCTAssertGreaterThanOrEqual(census.visibleNodes, 8,
                                    "ground, mass, underside, rim, three walls, the mark, the dust")
        XCTAssertGreaterThanOrEqual(census.colourPassDraws, 8)
        XCTAssertGreaterThanOrEqual(census.shadowPassDraws, 1,
                                    """
                                    The mass must cast. It is the only thing in the room above you, \
                                    and the shadow it throws across the bedding is the whole claim \
                                    of this variant — the mark does not cast, because a hollow \
                                    pressed into a floor has nothing to throw.
                                    """)
        XCTAssertEqual(census.lightPassDraws, 1, "one SwiftUI shader pass")
        XCTAssertGreaterThan(census.triangles, 15_000,
                             "the strata are real geometry, not a displacement texture")
        XCTAssertGreaterThan(census.points, 400, "and the dust is real points")

        print("SPIKE_CENSUS {\"scene\":\"garima-scenekit\",\"window\":\"A · t=62s\","
              + "\"draws\":\(census.total),\"colourPass\":\(census.colourPassDraws),"
              + "\"shadowPass\":\(census.shadowPassDraws),\"lightPass\":\(census.lightPassDraws),"
              + "\"triangles\":\(census.triangles),\"points\":\(census.points),"
              + "\"breakdown\":\"\(census.breakdown)\","
              + "\"note\":\"SceneKit draw submissions — NOT comparable one-for-one with the "
              + "canvas baseline's GraphicsContext primitives (tier 0: 263, deep-zoom bloom: 80)\"}")
    }

    /// The renderer is really rendering.
    ///
    /// Worth its own test because the first screenshot run came back with the
    /// SwiftUI light pass floating on black, which has two completely different
    /// causes — a capture that cannot see a `CAMetalLayer`, or a SceneKit view that
    /// never drew. `snapshot()` asks SceneKit itself for the picture, so it
    /// separates them: if this passes and the window capture is still empty, the
    /// capture is what is broken.
    func testSceneKitReallyDraws() {
        GarimaSceneKitRoom.ColdOpen.shared.reset()
        let window = host(clock: SpikeMetrics.Clock(offset: 62), reduceMotion: false)
        defer { teardown(window) }
        pump(seconds: 2.5)

        guard let view = sceneView(in: window) else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertGreaterThan(view.bounds.width, 100, "the SCNView was never laid out")
        XCTAssertGreaterThan(view.bounds.height, 100, "the SCNView was never laid out")

        let shot = view.snapshot()
        let spread = Self.luminanceSpread(of: shot)
        print("SPIKE_RENDER {\"bounds\":\"\(view.bounds.size)\","
              + "\"isPlaying\":\(view.isPlaying),"
              + String(format: "\"minLuma\":%.3f,\"maxLuma\":%.3f,\"meanLuma\":%.3f,",
                       spread.min, spread.max, spread.mean)
              + "\"coldOpenMs\":\(GarimaSceneKitRoom.ColdOpen.shared.milliseconds.map { String(format: "%.0f", $0) } ?? "null")}")

        XCTAssertGreaterThan(spread.max - spread.min, 0.05,
                             "the SceneKit render is flat — nothing is lit, or nothing is there")
        XCTAssertGreaterThan(spread.mean, 0.01, "the room rendered black")
        XCTAssertLessThan(spread.mean, 0.9, "the room blew out to white")
        XCTAssertNotNil(GarimaSceneKitRoom.ColdOpen.shared.milliseconds,
                        "no frame was ever presented — the render delegate never fired")
    }

    /// The darkest, brightest and mean luminance of an image, on a coarse grid.
    /// Design's invariant 7 and FIDELITY's contrast floor both live here: a room
    /// that renders black or blows out to white is a defect, at either adaptation.
    private static func luminanceSpread(of image: UIImage) -> (min: Double, max: Double, mean: Double) {
        guard let cg = image.cgImage else { return (0, 0, 0) }
        let side = 64
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let ctx = CGContext(data: &pixels, width: side, height: side,
                                  bitsPerComponent: 8, bytesPerRow: side * 4,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return (0, 0, 0) }
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: side, height: side))
        var low = 1.0, high = 0.0, total = 0.0
        for index in stride(from: 0, to: pixels.count, by: 4) {
            let luma = (0.2126 * Double(pixels[index])
                        + 0.7152 * Double(pixels[index + 1])
                        + 0.0722 * Double(pixels[index + 2])) / 255
            low = Swift.min(low, luma)
            high = Swift.max(high, luma)
            total += luma
        }
        return (low, high, total / Double(side * side))
    }

    /// The launch-argument entry point answers only to this room, and carries the
    /// clock the harness needs.
    func testTheLaunchArgumentEntryPointIsThisRoomsAlone() {
        typealias Request = GarimaSceneKitRoom.LaunchRequest
        XCTAssertNil(Request.parse([]))
        XCTAssertNil(Request.parse(["SPIKE_ROOM=garima-canvas", "SPIKE_T=347"]),
                     "the other variant's room is not this one's to open")

        let opening = Request.parse([Request.token])
        XCTAssertEqual(opening?.sceneTime, 0)
        XCTAssertEqual(opening?.reduceMotion, false)

        let past = Request.parse([Request.token, "SPIKE_T=347", "SPIKE_REDUCE_MOTION"])
        XCTAssertEqual(past?.sceneTime, 347)
        XCTAssertEqual(past?.reduceMotion, true)
    }

    /// The light pass is handed the mark's real screen position, so the bloom sits
    /// where the ember is rather than where it looked about right.
    func testTheLightPassFollowsTheMarkDownAndThenUp() {
        let her = GarimaSceneKitRoom.Ingredients.garima(from: nil)
        let size = CGSize(width: 393, height: 852)
        func emberY(_ t: TimeInterval) -> CGFloat {
            GarimaSceneKitRoom.emberScreenPoint(
                pose: .init(sceneTime: t, ingredients: her), size: size).y
        }
        for t in stride(from: 0.0, through: 400.0, by: 10.0) {
            let y = emberY(t)
            XCTAssertTrue(y.isFinite, "the projection went non-finite at t=\(t)")
            XCTAssertGreaterThan(y, 0, "the mark cannot project above the room at t=\(t)")
            // The bloom has to be where the ember is. Projecting from the mark's
            // *rest* height put it below the bottom edge past the reversal, while the
            // ember it blooms from was plainly on screen.
            XCTAssertLessThan(y, size.height,
                              "the bloom fell off the bottom of the frame at t=\(t)")
            XCTAssertGreaterThan(y, size.height * 0.5,
                                 "she is felt at the soles — the mark stays low at t=\(t)")
        }

        // The wash must agree with the shadows. At the opening the raking light is
        // up and to the right; past the reversal it is underneath you.
        let opening = GarimaSceneKitRoom.rakeDirection(
            pose: .init(sceneTime: 0, ingredients: her))
        XCTAssertGreaterThan(opening.x, 0, "the light comes from her right")
        XCTAssertLessThan(opening.y, 0, "and from above — screen y runs against world y")
        let reversed = GarimaSceneKitRoom.rakeDirection(
            pose: .init(sceneTime: 400, ingredients: her))
        XCTAssertGreaterThan(reversed.y, 0,
                             "past the reversal the light comes up out of the ground")
    }

    // MARK: - The measured half

    /// The room at its opening, holding through the first adaptation.
    func test1FirstAdaptation() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await measure(window: "A · first adaptation (t=0)", clockOffset: 0)
    }

    /// The room with the clock driven past the second adaptation — the state a
    /// returning practitioner reaches, and the one no one would ever wait for.
    func test2PastSecondAdaptation() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await measure(window: "B · past second adaptation (t=347s)", clockOffset: 347)
    }

    /// The non-animated path, measured, because "it does not animate" is a claim
    /// about CPU and not only about a boolean.
    func test3ReduceMotion() async throws {
        try XCTSkipUnless(enabled, Self.skipReason)
        try await measure(window: "C · reduce motion, settled", clockOffset: 0, reduceMotion: true)
    }

    /// Holds the room in each of its three states long enough for the host to
    /// photograph the simulator's actual display, and records the room's cold open.
    ///
    /// **Why the host takes the picture.** The first attempt captured in-process
    /// with `drawHierarchy(in:afterScreenUpdates:)` and came back with the SwiftUI
    /// light pass floating on black: that path cannot see a `CAMetalLayer`, and the
    /// whole SceneKit half of this variant lives in one.
    /// `testSceneKitReallyDraws` proved the renderer was fine and the capture was
    /// not. So the composite — SceneKit's render with the shader screened over it —
    /// is photographed off the simulator with `xcrun simctl io … screenshot`, which
    /// is the real display and cannot miss a layer. The SceneKit half is *also*
    /// saved from `snapshot()`, because a picture of the geometry and its shadows
    /// with no light pass over it is worth having on its own.
    ///
    /// That is a finding about the renderer, not a workaround: anything in this app
    /// that wants to screenshot a SceneKit room — a snapshot test, a share card,
    /// the Portrait's `ImageRenderer` — has to go around SwiftUI to do it.
    func test4RoomStatesForCapture() throws {
        try XCTSkipUnless(enabled, Self.skipReason)

        var opens: [Double] = []
        for (name, offset, reduce) in Self.captureStates {
            GarimaSceneKitRoom.ColdOpen.shared.reset()
            let window = host(clock: SpikeMetrics.Clock(offset: offset), reduceMotion: reduce)
            pump(seconds: 2.0)
            if let ms = GarimaSceneKitRoom.ColdOpen.shared.milliseconds { opens.append(ms) }

            // A marker *file*, not a printed line: `xcodebuild`'s stdout is block
            // buffered when it is redirected, so a host watching the log sees nothing
            // until the run is nearly over and photographs an empty screen. A file
            // write lands immediately.
            Self.holdMarker(name)
            print("SPIKE_HOLD {\"name\":\"\(name)\",\"state\":\"open\"}")
            pump(seconds: 8.0)   // the host photographs the display inside this window
            Self.clearHoldMarker()
            print("SPIKE_HOLD {\"name\":\"\(name)\",\"state\":\"closing\"}")

            if let view = sceneView(in: window) {
                let spread = Self.luminanceSpread(of: view.snapshot())
                // The contrast floor, at every state: no room may render black or
                // blow out to white. Design's verification pass caught five dark
                // rooms and one pure-white one exactly here.
                XCTAssertGreaterThan(spread.mean, 0.01, "\(name) rendered black")
                XCTAssertLessThan(spread.mean, 0.9, "\(name) blew out to white")
                let url = write(view.snapshot(), named: name + "-scenekit-only")
                print("SPIKE_SHOT {\"name\":\"\(name)-scenekit-only\","
                      + "\"path\":\"\(url?.path ?? "")\","
                      + String(format: "\"meanLuma\":%.3f,\"minLuma\":%.3f,\"maxLuma\":%.3f}",
                               spread.mean, spread.min, spread.max))
            }
            teardown(window)
            pump(seconds: 0.6)
        }

        // Two of the three, and that is the point. `SCNSceneRendererDelegate`'s
        // callbacks *are* the render loop, so the reduce-motion room — which stops
        // that loop and draws once on demand — reports no first frame at all. It is
        // the cleanest proof the still path is genuinely still that this run
        // produces: the room is plainly on screen in its screenshot, and nothing
        // ever called back.
        let animated = Self.captureStates.filter { !$0.2 }.count
        XCTAssertGreaterThanOrEqual(opens.count, animated,
                                    "an animated room never presented its first frame")
        let mean = opens.reduce(0, +) / Double(max(1, opens.count))
        print("SPIKE_LAUNCH {\"scene\":\"garima-scenekit room open\","
              + "\"iterations\":\(opens.count),"
              + String(format: "\"meanMs\":%.0f,\"bestMs\":%.0f,\"worstMs\":%.0f,",
                       mean, opens.min() ?? 0, opens.max() ?? 0)
              + "\"eachMs\":[\(opens.map { String(format: "%.0f", $0) }.joined(separator: ", "))],"
              + "\"note\":\"scene assembly to first presented frame, inside a live host — NOT the "
              + "app's process cold launch, which SpikeColdLaunchTests measures for the shipped "
              + "Mandala with a UI test this spike may not add\"}")
    }

    /// `<shots>/.holding` — the room currently on screen, for the host that is
    /// photographing it. Removed the moment the room comes down.
    private static var holdMarkerURL: URL { shotsDirectory.appendingPathComponent(".holding") }

    private static func holdMarker(_ name: String) {
        try? FileManager.default.createDirectory(at: shotsDirectory, withIntermediateDirectories: true)
        try? name.write(to: holdMarkerURL, atomically: true, encoding: .utf8)
    }

    private static func clearHoldMarker() {
        try? FileManager.default.removeItem(at: holdMarkerURL)
    }

    static let captureStates: [(String, TimeInterval, Bool)] = [
        ("garima-scenekit-first-adaptation", 62, false),
        ("garima-scenekit-past-second-adaptation", 347, false),
        ("garima-scenekit-reduce-motion", 0, true),
    ]

    // MARK: - The shared run

    private func measure(window label: String,
                         clockOffset: TimeInterval,
                         reduceMotion: Bool = false,
                         seconds: TimeInterval = 20) async throws {
        let clock = SpikeMetrics.Clock(offset: clockOffset)
        let window = host(clock: clock, reduceMotion: reduceMotion)
        defer { teardown(window) }

        // Warm up exactly as the baseline does: the first frames of any scene pay
        // for view-graph construction, geometry upload and shader compilation.
        try? await Task.sleep(nanoseconds: UInt64(SpikeBench.warmupSeconds * 1_000_000_000))
        clock.restart(offset: clockOffset)

        let sampler = SpikeMetrics.FrameSampler()
        sampler.start()
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        sampler.stop()

        // `primitivesMean` comes back 0 on purpose: this scene issues no
        // `GraphicsContext` primitives at all, and filling that field with a
        // SceneKit draw count would make the two baselines look comparable when
        // they are not. The SceneKit census is emitted on its own line below.
        let report = sampler.finish(
            label: "garima · SceneKit + SwiftUI shader",
            device: SpikeBench.deviceLabel,
            window: label,
            clockNote: reduceMotion
                ? "reduce motion: the scene is posed once at t=\(Int(GarimaSceneKitRoom.Ingredients.settledSceneTime))s and the render loop is stopped"
                : "scene clock driven to t=\(Int(clockOffset))s (no waiting); this room reads the injected SpikeMetrics.Clock for every term, so nothing in it is still on the wall clock",
            census: SpikeMetrics.CensusAccumulator())
        SpikeMetrics.emit(report)

        if let scene = sceneView(in: window)?.scene {
            let census = GarimaSceneKitRoom.census(of: scene)
            print("SPIKE_CENSUS {\"scene\":\"garima-scenekit\",\"window\":\"\(label)\","
                  + "\"draws\":\(census.total),\"colourPass\":\(census.colourPassDraws),"
                  + "\"shadowPass\":\(census.shadowPassDraws),\"lightPass\":\(census.lightPassDraws),"
                  + "\"triangles\":\(census.triangles),\"points\":\(census.points),"
                  + String(format: "\"hostLoadAtEnd\":%.2f}", SpikeMetrics.hostLoadAverage()))
        }

        if reduceMotion {
            XCTAssertLessThan(report.cpuMsPerFrame, 4.0,
                              "a still room must cost almost nothing per frame")
        } else {
            XCTAssertGreaterThan(report.frames, 60,
                                 "\(label) produced too few frames to mean anything")
        }
    }

    // MARK: - Windowing

    private var retained: UIWindow?

    private func host(clock: SpikeMetrics.Clock, reduceMotion: Bool) -> UIWindow {
        let request = GarimaSceneKitRoom.LaunchRequest(sceneTime: clock.offset,
                                                       reduceMotion: reduceMotion)
        let window = GarimaSceneKitRoom.present(request: request, shakti: nil, clock: clock)
        retained = window
        return window ?? UIWindow(frame: UIScreen.main.bounds)
    }

    private func teardown(_ window: UIWindow) {
        window.isHidden = true
        window.rootViewController = nil
        if retained === window { retained = nil }
    }

    /// Let the run loop actually run — a `Task.sleep` inside a synchronous test
    /// would not, and a scene that never gets a frame proves nothing.
    private func pump(seconds: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
    }

    private func sceneView(in window: UIWindow) -> SCNView? {
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews {
                if let found = walk(child) { return found }
            }
            return nil
        }
        guard let root = window.rootViewController?.view else { return nil }
        return walk(root)
    }

    // MARK: - Screenshots

    /// `…/scratchpad/garima-shots/scenekit`, computed from this file's own path
    /// rather than from an environment variable — `xcodebuild` cannot set the
    /// environment of a unit test's *host app*, only of a UI-test runner, which
    /// `SpikeBaselineBenchTests` writes down at length and this file will not
    /// rediscover the hard way.
    private static var shotsDirectory: URL {
        let repoRoot = URL(fileURLWithPath: #filePath)
            .resolvingSymlinksInPath()
            .deletingLastPathComponent()   // Bindu MandalaTests
            .deletingLastPathComponent()   // iOS
            .deletingLastPathComponent()   // the worktree
        return repoRoot
            .deletingLastPathComponent()   // scratchpad
            .appendingPathComponent("garima-shots/scenekit", isDirectory: true)
    }

    private func write(_ image: UIImage, named name: String) -> URL? {
        guard let data = image.pngData() else { return nil }
        for directory in [Self.shotsDirectory,
                          URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)] {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let url = directory.appendingPathComponent("\(name).png")
            if (try? data.write(to: url)) != nil { return url }
        }
        return nil
    }
}
#endif
