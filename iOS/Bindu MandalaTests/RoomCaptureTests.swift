import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - The room, looked at
//
// Two things this suite proves that no pure check can:
//
// **The shader really reached the bundle.** The canvas spike's headline finding
// was that `ShaderLibrary` builds only from a compiled `.metallib`, so a
// SwiftUI shader needs a real `.metal` file in the *shipping* target and cannot
// be `#if DEBUG`-ed out. The project uses `PBXFileSystemSynchronizedRootGroup`,
// so dropping `RoomLightPass.metal` into the app folder ought to be the whole
// of the wiring — and "ought to" is exactly the kind of thing that is true
// until it silently is not. This reads the built bundle.
//
// **A room is neither black nor blown out, at both adaptations.** The first of
// Design's five legibility checks, and the one that can run as soon as a room
// exists: its own verification pass found five rooms rendering dark and one
// blowing out to white, and every one of those was an authoring defect that a
// luminance floor would have caught the same day.
//
// The capture goes around SwiftUI, which the renderer ruling recorded as a real
// cost of choosing SceneKit: `drawHierarchy(afterScreenUpdates:)` and
// `ImageRenderer` both return a `CAMetalLayer` as black. `RoomScene.capture`
// asks SceneKit itself, offscreen, with no window and no host. What it judges is
// therefore the **geometry half** of the composite — the ruling says so in the
// same breath, and measured that half at 0.077 → 0.079 mean luminance with the
// light pass missing. The light pass can only add (it composites with `.screen`),
// so a geometry half that is legible cannot become an illegible composite by
// being darkened; it could only be blown out, and the shader clamps at 0.86.
@MainActor
final class RoomCaptureTests: XCTestCase {

    /// Big enough that a mark is several pixels across, small enough that nine
    /// rings of captures are seconds rather than minutes.
    private static let captureSize = CGSize(width: 320, height: 640)

    private func room(position: Int, ring: Int, bodilyLocation: String,
                      tattva: String = "Pṛthivī",
                      quality: String = "she who attracts") -> HomeRoom {
        guard let room = HomeRooms.resolve(position: position, ring: ring,
                                           tattva: tattva, quality: quality,
                                           bodilyLocation: bodilyLocation) else {
            fatalError("no room resolved at position \(position)")
        }
        return room
    }

    // MARK: - The shader reached the shipping bundle

    /// `RoomLightPass.metal` compiled into `default.metallib`, in the app that
    /// actually runs — verified rather than assumed.
    func testTheLightPassCompiledIntoTheBundle() throws {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib") else {
            return XCTFail("""
                there is no `default.metallib` in the bundle. `ShaderLibrary` has no from-source \
                initialiser, so with no metallib the room has no light pass at all — and the failure \
                is silent at run time.
                """)
        }
        let library = try Data(contentsOf: url)
        XCTAssertGreaterThan(library.count, 1_024, "the metallib is empty")

        // The function's own name, in the compiled library. A `[[stitchable]]`
        // function keeps its name, which is how `ShaderLibrary.roomLightPass`
        // finds it.
        guard let needle = "roomLightPass".data(using: .utf8) else {
            return XCTFail("could not encode the shader's name")
        }
        XCTAssertNotNil(library.range(of: needle),
                        """
                        `roomLightPass` is not in the compiled Metal library. The file is in the app \
                        folder and the project synchronises that folder, so if this fails the \
                        synchronisation has stopped covering `.metal` files and the pbxproj needs a \
                        real look.
                        """)
    }

    // MARK: - Legibility, at both adaptations

    /// **Design's first legibility check.** No room renders black and no room
    /// blows out to white — at the first adaptation, and past the second.
    ///
    /// Run across the body and across the gem table rather than on one room: a
    /// Śakti at the soles acting on the floor, one at the heart acting on a
    /// face, and one at the crown in the sourceless seventh āvaraṇa, which is
    /// the room with no key light at all and therefore the one most likely to
    /// come back dark.
    func testARoomIsNeitherBlackNorBlownOutAtBothAdaptations() throws {
        let rooms: [(String, HomeRoom)] = [
            ("ring 1 · the soles · topaz, the hardest light",
             room(position: 4, ring: 1, bodilyLocation: "soles")),
            ("ring 4 · the heart · diamond",
             room(position: 57, ring: 4, bodilyLocation: "heart", tattva: "Ākāśa")),
            ("ring 6 · the forehead · ruby, the softest shadow",
             room(position: 77, ring: 6, bodilyLocation: "forehead", tattva: "Tejas")),
            ("ring 7 · the crown · pearl, SOURCELESS",
             room(position: 93, ring: 7, bodilyLocation: "crown", tattva: "Vāk")),
        ]

        for (what, room) in rooms {
            let scene = RoomScene(room: room)
            for (when, t) in [("the first adaptation", HomeMemory.firstAdaptation),
                              ("past the second", HomeMemory.secondAdaptationEnd)] {
                guard let image = scene.capture(size: Self.captureSize, atSceneTime: t) else {
                    return XCTFail("\(what) could not be rendered offscreen — no Metal device?")
                }
                let spread = Self.luminance(of: image)
                print("ROOM_CAPTURE {\"room\":\"\(what)\",\"when\":\"\(when)\","
                      + String(format: "\"meanLuma\":%.4f,\"minLuma\":%.4f,\"maxLuma\":%.4f}",
                               spread.mean, spread.min, spread.max))

                XCTAssertGreaterThan(spread.mean, 0.01,
                                     "\(what), \(when): the room rendered black")
                XCTAssertLessThan(spread.mean, 0.9,
                                  "\(what), \(when): the room blew out to white")
                XCTAssertGreaterThan(spread.max - spread.min, 0.02,
                                     """
                                     \(what), \(when): the render is flat. Either nothing is lit, or the \
                                     material has no relief for the light to fall across — which is \
                                     exactly the defect Design hit with Ring 1's Mātṛkās.
                                     """)
            }
        }
    }

    /// The seventh āvaraṇa is lit without a source. Worth its own assertion
    /// because it is the one room whose legibility rests entirely on the
    /// ambient law rather than on a key light.
    func testTheSourcelessRoomIsStillARoom() throws {
        let crown = room(position: 93, ring: HomeGem.sourcelessRing,
                         bodilyLocation: "crown", tattva: "Vāk")
        let scene = RoomScene(room: crown)
        XCTAssertTrue(scene.rig.isSourceless, "the Crown has been given a source")

        guard let image = scene.capture(size: Self.captureSize,
                                        atSceneTime: HomeMemory.firstAdaptation) else {
            return XCTFail("the Crown could not be rendered offscreen")
        }
        let spread = Self.luminance(of: image)
        XCTAssertGreaterThan(spread.mean, 0.01,
                             "the sourceless room rendered black — a room with no key light is still a room")
    }

    // MARK: - The reduce-motion path, measured

    /// **The still path is genuinely still, and it is the settled room.**
    ///
    /// Proven the way the spike proved it — by measurement rather than by
    /// intention. Two things are read:
    ///
    ///   * the room is posed exactly **once** and never again, however long the
    ///     view is left on screen. `posesApplied` is the whole per-frame cost of
    ///     a room, so one pose is not "less animation" — it is none;
    ///   * the per-pose cost is recorded, so the two paths can be compared on
    ///     the same ruler in the same session, as the spike's 0.386 ms against
    ///     3.231 ms was.
    func testTheStillPathReachesTheSettledStateWithoutAnimating() {
        let her = room(position: 57, ring: 4, bodilyLocation: "heart", tattva: "Ākāśa")

        let still = host(room: her, reduceMotion: true)
        defer { teardown(still.window) }
        pump(seconds: 1.5)

        guard let view = sceneView(in: still.window), let driver = view.delegate as? RoomDriver else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertFalse(view.isPlaying, "reduce motion must stop the scene clock")
        XCTAssertFalse(view.rendersContinuously, "reduce motion must stop the render loop")
        XCTAssertEqual(view.scene?.isPaused, true)

        let posesAfterFirstSecond = driver.posesApplied
        let eyeBefore = view.pointOfView?.position.y
        pump(seconds: 1.5)
        XCTAssertEqual(driver.posesApplied, posesAfterFirstSecond,
                       """
                       the room was posed again with reduce motion on. A reduce-motion path is not a \
                       slow-motion path: the render loop is stopped, and the room is drawn once.
                       """)
        XCTAssertEqual(view.pointOfView?.position.y, eyeBefore, "the eye moved with reduce motion on")

        // And what it is still *at* is the settled room — the outcome of the
        // adaptation, arrived at rather than withheld.
        let settled = RoomPose(sceneTime: RoomClock.settled, room: her)
        XCTAssertEqual(settled.settling, 1, accuracy: 1e-9)
        XCTAssertEqual(settled.deep, 1, accuracy: 1e-9)
        XCTAssertEqual(Double(view.pointOfView?.eulerAngles.x ?? 0), settled.eyePitch, accuracy: 1e-4,
                       "the still room is not posed where a walker who stayed would have arrived")

        // The cost of the thing that is not happening, on this host, in this
        // minute — so the two paths are comparable rather than merely asserted.
        let scene = driver.scene
        let started = CFAbsoluteTimeGetCurrent()
        let samples = 600
        for index in 0..<samples { scene.pose(at: Double(index) * 0.5) }
        let msPerPose = (CFAbsoluteTimeGetCurrent() - started) * 1000 / Double(samples)
        print(String(format: "ROOM_STILL {\"posesWhileAnimating\":%d,\"posesWhileStill\":%d,"
                     + "\"msPerPoseWhenAnimating\":%.4f,\"msPerPoseWhenStill\":0.0}",
                     samples, driver.posesApplied - posesAfterFirstSecond, msPerPose))
        XCTAssertLessThan(msPerPose, 4.0,
                          "a pose costs more than a frame — the room can no longer be animated at all")
    }

    /// The animated path really does animate, so the comparison above is
    /// between two different things rather than between two still rooms.
    func testTheAnimatedPathPosesEveryFrame() {
        let her = room(position: 57, ring: 4, bodilyLocation: "heart", tattva: "Ākāśa")
        let moving = host(room: her, reduceMotion: false)
        defer { teardown(moving.window) }
        pump(seconds: 1.5)

        guard let view = sceneView(in: moving.window), let driver = view.delegate as? RoomDriver else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertTrue(view.isPlaying)
        XCTAssertGreaterThan(driver.posesApplied, 10,
                             "the animated room was posed \(driver.posesApplied) times in a second and a half")
    }

    // MARK: - Hosting

    private var retained: UIWindow?

    private func host(room: HomeRoom, reduceMotion: Bool) -> (window: UIWindow, clock: RoomClock) {
        let clock = RoomClock(opening: HomeMemory.firstAdaptation)
        let view = RoomView(room: room, clock: clock, forceReduceMotion: reduceMotion)
        let controller = UIHostingController(rootView: view.statusBarHidden(true))
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
        return (window, clock)
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

    // MARK: - Reading a render

    /// The darkest, brightest and mean luminance of a render, on a coarse grid.
    /// Design's invariant 7 and FIDELITY's contrast floor both live here.
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
