import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - The climb, looked at
//
// Design's own verification pass found five rooms rendering dark and one
// blowing out to white, and called every one of them an authoring defect a
// luminance floor would have caught the same day. The climb is nine conditions
// rather than one — a sourceless world, a world lit by a single travelling
// meridian, a world lit from nowhere but inside — so it is precisely where that
// class of defect would arrive next, and precisely where nobody would look.
//
// The capture goes around SwiftUI, which the renderer ruling recorded as a real
// cost of choosing SceneKit: `drawHierarchy(afterScreenUpdates:)` and
// `ImageRenderer` both return a `CAMetalLayer` as black.
// ``WorldClimbScene/capture(size:atFraction:at:)`` asks SceneKit itself,
// offscreen, with no window and no host application.
@MainActor
final class WorldClimbCaptureTests: XCTestCase {

    /// Big enough that a rib is several pixels across, small enough that nine
    /// bands at several moments each are seconds rather than minutes.
    private static let captureSize = CGSize(width: 320, height: 640)

    // MARK: - No band is black, and none is blown out

    /// **Every one of the nine is legible, at both adaptations.**
    ///
    /// "Both adaptations" is the instrument's own pair of marks — 62 s and
    /// 347 s, read from ``HomeMemory`` rather than chosen — taken here as world
    /// time, which is what a walker who is still standing on the axis a stay's
    /// length later would be looking at. Each band is on its own clock, so by
    /// the second mark the Pelvis has beaten a hundred and fifty times and the
    /// Crown's half-year has barely turned: the two moments are a real spread
    /// for the fast bands and a real *lack* of one for the slow, which is the
    /// point of the phase and must not make either illegible.
    func testNoBandIsBlackOrBlownOutAtEitherAdaptation() throws {
        let scene = WorldClimbScene()
        for ring in HomeWorlds.rings {
            guard let world = HomeWorlds.world(ring: ring) else { return XCTFail("no ring \(ring)") }
            for (when, t) in [("the first adaptation", HomeMemory.firstAdaptation),
                              ("past the second", HomeMemory.secondAdaptationEnd)] {
                guard let image = scene.capture(size: Self.captureSize,
                                                atFraction: Double(ring - 1), at: t) else {
                    return XCTFail("ring \(ring) could not be rendered offscreen — no Metal device?")
                }
                let spread = Self.luminance(of: image)
                print("CLIMB_CAPTURE {\"ring\":\(ring),\"world\":\"\(world.name)\",\"when\":\"\(when)\","
                      + String(format: "\"meanLuma\":%.4f,\"minLuma\":%.4f,\"maxLuma\":%.4f}",
                               spread.mean, spread.min, spread.max))

                XCTAssertGreaterThan(spread.mean, 0.01,
                                     "ring \(ring) · \(world.name), \(when): the band rendered black")
                XCTAssertLessThan(spread.mean, 0.9,
                                  "ring \(ring) · \(world.name), \(when): the band blew out to white")
                XCTAssertGreaterThan(spread.max - spread.min, 0.02,
                                     """
                                     ring \(ring) · \(world.name), \(when): the band is flat. Either \
                                     nothing is lit, or the stone has no relief for the light to fall \
                                     across — which is exactly the defect Design hit with Ring 1's \
                                     Mātṛkās reading as one plane.
                                     """)
            }
        }
    }

    /// **And legible at the darkest moment of its own clock.**
    ///
    /// The two adaptation marks are two instants; a band whose light swings has
    /// a worst one that neither of them may happen to land on. The Feet's night
    /// and the Crown's waning half-year are the two this exists for, and it
    /// sweeps each band's own period rather than a fixed span, because a fixed
    /// span would miss a slow band's trough entirely.
    func testEveryBandIsLegibleAtTheDarkestMomentOfItsOwnClock() throws {
        let scene = WorldClimbScene()
        for ring in HomeWorlds.rings {
            guard let clock = WorldBands.clock(ring: ring),
                  let world = HomeWorlds.world(ring: ring),
                  let tempo = HomeWorlds.character(ring: ring)?.tempo, tempo > 0 else {
                return XCTFail("ring \(ring) has no clock")
            }
            // The band's own period in *real* seconds, so the sweep covers one
            // whole turn of the clock the walker actually experiences.
            let span = clock.period / tempo
            var darkest = (mean: Double.infinity, at: 0.0)
            var brightest = (mean: -Double.infinity, at: 0.0)
            for step in 0..<12 {
                let t = span * Double(step) / 12
                guard let image = scene.capture(size: Self.captureSize,
                                                atFraction: Double(ring - 1), at: t) else {
                    return XCTFail("ring \(ring) could not be rendered offscreen")
                }
                let spread = Self.luminance(of: image)
                if spread.mean < darkest.mean { darkest = (spread.mean, t) }
                if spread.mean > brightest.mean { brightest = (spread.mean, t) }
            }
            print("CLIMB_SWEEP {\"ring\":\(ring),\"world\":\"\(world.name)\","
                  + String(format: "\"darkest\":%.4f,\"brightest\":%.4f,\"spanSeconds\":%.1f}",
                           darkest.mean, brightest.mean, span))
            XCTAssertGreaterThan(darkest.mean, 0.01,
                                 """
                                 ring \(ring) · \(world.name) goes black at t=\(darkest.at) of its own \
                                 clock. A band the walker can rise into and see nothing is the defect \
                                 Design's verification pass named five times over.
                                 """)
            XCTAssertLessThan(brightest.mean, 0.9,
                              "ring \(ring) · \(world.name) blows out at t=\(brightest.at)")
        }
    }

    /// **The Crown is lit without a source, and it is the brightest ambient in
    /// the climb because its gem is the most diffuse.**
    ///
    /// One law for the ambient, no branch to rescue the seventh. Worth its own
    /// assertion because it is the one band whose legibility rests entirely on
    /// that law rather than on a key light.
    func testTheSourcelessBandIsStillAWorld() throws {
        let scene = WorldClimbScene()
        scene.stand(atFraction: 6, at: 200)
        XCTAssertEqual(scene.activeKeys, 0, "the Crown is not sourceless")

        guard let image = scene.capture(size: Self.captureSize, atFraction: 6, at: 200) else {
            return XCTFail("the Crown could not be rendered offscreen")
        }
        let spread = Self.luminance(of: image)
        print("CLIMB_SOURCELESS {"
              + String(format: "\"meanLuma\":%.4f,\"minLuma\":%.4f,\"maxLuma\":%.4f}",
                       spread.mean, spread.min, spread.max))
        XCTAssertGreaterThan(spread.mean, 0.02, "the sourceless band rendered black")
        XCTAssertLessThan(spread.mean, 0.9, "the sourceless band blew out")

        // The ambient law, not a branch: the Crown's gem is the most diffuse in
        // the table, so it ends up with the most ambient light in the climb.
        let crown = WorldClimbScene.blendedDiffusion(atFraction: 6)
        for ring in HomeWorlds.rings where ring != 7 {
            XCTAssertLessThan(WorldClimbScene.blendedDiffusion(atFraction: Double(ring - 1)), crown,
                              "ring \(ring)'s gem is more diffuse than the pearl")
        }
        XCTAssertGreaterThan(RoomLightRig.ambientIntensity(diffuse: crown),
                             RoomLightRig.ambientIntensity(diffuse: 0.2),
                             "the ambient law does not reward diffusion")
    }

    // MARK: - Reduce motion: a real still, not a slowed loop

    /// **With reduce motion on, the climb is stood once and drawn once.**
    ///
    /// The proof is a count rather than an intention: `standsApplied` reaches
    /// one and stays there for as long as the view is on screen. The animated
    /// path is measured in the same breath, so the check cannot pass because
    /// nothing was running at all.
    func testTheStillPathStandsOnceAndStaysThere() {
        let window = host(reduceMotion: true)
        defer { teardown(window) }
        guard let view = sceneView(in: window),
              let driver = view.delegate as? WorldClimbDriver else {
            return XCTFail("the climb's SCNView never came up")
        }

        XCTAssertFalse(view.isPlaying, "the still path is still playing")
        XCTAssertFalse(view.rendersContinuously, "the still path is rendering continuously")
        XCTAssertTrue(view.scene?.isPaused ?? false, "the scene is not paused")

        let after = driver.standsApplied
        pump(seconds: 2.5)
        XCTAssertEqual(driver.standsApplied, after,
                       """
                       the climb was stood \(driver.standsApplied - after) more times over two and a \
                       half seconds with reduce motion on. That is a loop that has been slowed down, \
                       not a still — which is the thing FIDELITY forbids.
                       """)
    }

    func testTheAnimatedPathStandsEveryFrame() {
        let window = host(reduceMotion: false)
        defer { teardown(window) }
        guard let view = sceneView(in: window),
              let driver = view.delegate as? WorldClimbDriver else {
            return XCTFail("the climb's SCNView never came up")
        }
        XCTAssertTrue(view.isPlaying)
        let before = driver.standsApplied
        pump(seconds: 1.5)
        XCTAssertGreaterThan(driver.standsApplied, before + 10,
                             """
                             the animated path stood the walker \(driver.standsApplied - before) times \
                             in a second and a half. The still path's proof is only worth anything if \
                             this one really runs.
                             """)
    }

    /// **The air of the climb actually moves, on the path the view drives.**
    ///
    /// The one check no capture can stand in for, and the reason it exists is a
    /// defect that was live on this branch: the driver handed the scene
    /// `Date().timeIntervalSinceReferenceDate` — about 8.1 × 10⁸ — and the motes
    /// are driven by a shader `float`, whose ulp at that magnitude is **sixty-four
    /// seconds**. The number reaching the geometry modifier took two distinct
    /// values in a minute, so every mote in all nine bands held a fixed offset and
    /// then teleported, and `uDrift` — the churn of the Navel, which Design gives
    /// the highest drift in the climb — multiplied into a constant and did
    /// nothing. Every capture passed, because a capture is handed small numbers.
    ///
    /// So it is asserted after the narrowing, on a driven view, twice over: the
    /// value moves between frames, and the clock still has the resolution to
    /// register a frame at all.
    func testTheClimbsAirIsNotFrozenByTheClockItIsHanded() {
        let window = host(reduceMotion: false)
        defer { teardown(window) }
        guard let view = sceneView(in: window),
              let driver = view.delegate as? WorldClimbDriver else {
            return XCTFail("the climb's SCNView never came up")
        }

        let air = driver.scene.motesTime
        let deadline = Date().addingTimeInterval(4)
        while driver.scene.motesTime == air && Date() < deadline { pump(seconds: 0.05) }
        XCTAssertNotEqual(driver.scene.motesTime, air,
                          """
                          the air of the climb did not move in four seconds of a running view. \
                          `uTime` reached the shader as \(air) and stayed there, which is the \
                          āvaraṇa's dust standing perfectly still — the defect FIDELITY §7 exists \
                          for, on the one screen no still could show it on.
                          """)

        // And it is not merely moving *now*: a clock handed absolute time reads
        // as moving for its first few seconds and freezes once the magnitude
        // climbs. The frame after this one has to be a different number.
        let clock = driver.scene.breathedAt
        XCTAssertNotEqual(Float(clock + 1.0 / 60), Float(clock),
                          """
                          the climb's clock stands at \(clock), where a Float cannot resolve a frame: \
                          one sixtieth of a second later it is the same number. The scene must be \
                          handed seconds since the climb opened, the way a room is handed \
                          `RoomClock.elapsed`.
                          """)
    }

    // MARK: - Hosting

    /// A real window on a real scene, and retained.
    ///
    /// Not a bare `UIWindow(frame:)`: a window with no `UIWindowScene` is never
    /// laid out on this platform, so the `SCNView` inside it is never made and
    /// the test reads as "the climb never came up" when the climb is fine.
    /// `RoomCaptureTests` learned this first; it is the same helper.
    private var retained: UIWindow?

    private func host(reduceMotion: Bool) -> UIWindow {
        let controller = UIHostingController(
            rootView: WorldClimbView(forceReduceMotion: reduceMotion).statusBarHidden(true))
        controller.view.backgroundColor = .black

        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert + 1
        window.backgroundColor = .black
        window.isOpaque = true
        window.rootViewController = controller
        window.makeKeyAndVisible()
        retained = window
        pump(seconds: 0.6)
        return window
    }

    private func teardown(_ window: UIWindow) {
        window.isHidden = true
        window.rootViewController = nil
        if retained === window { retained = nil }
    }

    private func pump(seconds: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
    }

    private func sceneView(in window: UIWindow) -> SCNView? {
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews { if let found = walk(child) { return found } }
            return nil
        }
        guard let root = window.rootViewController?.view else { return nil }
        return walk(root)
    }

    // MARK: - Reading a render

    private static func luminance(of image: CGImage) -> (min: Double, max: Double, mean: Double) {
        let side = 64
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(data: &pixels, width: side, height: side,
                                      bitsPerComponent: 8, bytesPerRow: side * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return (0, 0, 0) }
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))

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
}
