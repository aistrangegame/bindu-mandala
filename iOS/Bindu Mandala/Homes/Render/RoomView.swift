import SwiftUI
import SceneKit
import QuartzCore

// MARK: - The host: a room on screen
//
// The renderer ruling's sixth file: the `SCNView` bridge, the `.colorEffect`
// pass over it, the injectable clock, and the real non-animated reduce-motion
// path.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE CLOCK IS HER CLOCK, AND ITS MARKS ARE NOT WRITTEN HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// The first adaptation at 62 seconds, the hold's end at 227, the second at 347
// — every one of those lives in ``HomeMemory`` and is read from there. Not one
// of them is restated in this file, and `RoomSceneTests` asserts that the room
// and the memory cannot drift apart. The clock is injectable for exactly one
// reason: a test that had to wait 347 seconds would not be run.
//
// And the clock is **never scaled by the world's tempo**. A slow āvaraṇa must
// not hand the walker a cheaper second adaptation than a fast one — that would
// be depth bought by which ring she happened to be standing in rather than by
// how long she stayed, which is the never-measure law at the timing layer.
// ``HomeWorlds/adaptationClock(_:ring:)`` exists to say so and does nothing;
// the tempo reaches the weather and stops there.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT REDUCE MOTION MEANS HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// It does not slow the stay down and it does not shorten it. It **stops the
// render loop**: no `CADisplayLink`, no `TimelineView`, no continuous
// rendering, no per-frame work of any kind. The room is posed once at the
// settled state and drawn once, and then nothing happens until something
// outside asks for another frame.
//
// Design's invariant 4 asks for reduced motion *"longer and quantized, never
// disabled — the mechanism is perceptual adaptation."* `iOS/FIDELITY.md` says
// the opposite about loops: *"the one-shot fades may stay; the loops may not."*
// They cannot both be obeyed. It goes to FIDELITY, because the charter names
// FIDELITY as standing law. A walker with reduce motion on is given the
// **outcome** of the adaptation rather than nothing: the room as it is once she
// has been in it, arrived at rather than withheld.
//
// It is proven by measurement rather than asserted: ``RoomDriver/posesApplied``
// counts every time the room was put at an instant, and on this path it stays
// at one however long the view is left on screen. The spike proved the same
// thing in milliseconds — 0.386 against 3.231 above the control floor — and
// `RoomCaptureTests` records both the count and the cost.

/// Where a stay is on her chamber clock.
///
/// Injectable so a test can stand past the second adaptation in one frame, and
/// so a returning walker's stay can open where her accumulated dwell says it
/// opens. Its marks are ``HomeMemory``'s, never its own.
final class RoomClock: @unchecked Sendable {

    /// Where the stay opens on the chamber clock. On a first visit this is
    /// zero; on a return it is ``HomeMemory/headStart(dwell:)``, which comes
    /// from accumulated dwell and so cannot be gamed by entering and leaving.
    private(set) var opening: TimeInterval
    /// The reference-date instant this stay began.
    private(set) var epoch: TimeInterval

    /// A stay that has not begun. The rite of entering holds the clock here for
    /// the whole crossing: the ceremony at her threshold is not time stood in
    /// her room, and a clock that ran through it would hand a walker who lingered
    /// over her name an adaptation he did not stay for.
    private(set) var isHeld: Bool

    init(opening: TimeInterval = 0, epoch: TimeInterval? = nil, held: Bool = false) {
        self.opening = opening
        self.epoch = epoch ?? Date().timeIntervalSinceReferenceDate
        self.isHeld = held
    }

    /// A clock waiting at the threshold.
    static func held() -> RoomClock { RoomClock(opening: 0, held: true) }

    /// A returning walker's clock, opened by her relationship rather than by a
    /// count of her visits.
    convenience init(accumulatedDwell dwell: TimeInterval) {
        self.init(opening: HomeMemory.headStart(dwell: dwell))
    }

    func restart(opening: TimeInterval) {
        self.opening = opening
        self.epoch = Date().timeIntervalSinceReferenceDate
        self.isHeld = false
    }

    /// The stay begins: the crossing is over and the room opens where her
    /// accumulated dwell says it opens.
    func begin(opening: TimeInterval,
               at now: TimeInterval = Date().timeIntervalSinceReferenceDate) {
        self.opening = opening
        self.epoch = now
        self.isHeld = false
    }

    /// How far into the stay we are. A held clock has not started, so it stands
    /// at its opening however long the threshold takes.
    func chamberTime(now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> TimeInterval {
        isHeld ? opening : (now - epoch) + opening
    }

    /// Real seconds since this clock was made or begun — **the world's** time
    /// rather than hers. It runs through the threshold, because the āvaraṇa's
    /// air is not hers and does not wait at her door.
    func elapsed(now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> TimeInterval {
        max(0, now - epoch)
    }

    /// Where the reduce-motion path poses the room: the end of the second
    /// adaptation, read from ``HomeMemory`` rather than chosen. At exactly this
    /// instant both adaptations are complete, so the still room is the room a
    /// walker who stayed would have arrived at — not a frozen middle.
    static var settled: TimeInterval { HomeMemory.secondAdaptationEnd }

    /// The one instant the still path draws, wherever the walker is.
    ///
    /// Once he is inside, it is the settled room, as above. While he is still at
    /// her threshold it is the room's own opening, because **a room he has not
    /// entered has not adapted** — handing a walker with reduce motion on a
    /// fully-adapted room to cross toward would give him the end of a stay he
    /// has not begun. One fact, so the geometry and the light pass cannot draw
    /// two different instants of the same room.
    func stillInstant() -> TimeInterval {
        isHeld ? chamberTime() : Self.settled
    }
}

/// One Śakti's room, on screen.
struct RoomView: View {

    /// Her room, resolved by ``HomeRooms``. Position is the only key.
    let room: HomeRoom
    let clock: RoomClock
    /// The mechanism acting on her room, where Phase 3.3 has built one.
    let mechanism: RoomSurfaceMechanism?
    /// Where the walker stands on his crossing toward the room. `nil` is the
    /// ordinary case — he is in it.
    let approach: RoomApproachSource?
    /// Forced on for tests and captures; otherwise the environment decides.
    let forceReduceMotion: Bool
    /// How many times the walker has been moved — the still path's redraw
    /// token, and the same device ``WorldClimbView`` carries as `steps`.
    ///
    /// **It is not decoration, and the room did not always have one.** With the
    /// render loop stopped, the room is posed once and the light pass evaluated
    /// once, and the only thing that can ask for another of either is SwiftUI
    /// updating this view. ``RoomApproachSource`` is a *reference*, held so the
    /// driver can read it on SceneKit's thread without re-rendering the tree —
    /// so moving the walker changes nothing SwiftUI can see, and the redraw that
    /// followed a touch was incidental rather than declared. A reduce-motion
    /// walker was carried to his station by an update somebody else happened to
    /// cause; two more stored properties on the rite were enough to stop that
    /// happening, and he stood at the door for the whole ceremony.
    ///
    /// Bumping this makes the ask explicit: the walker moved, so the still room
    /// needs a frame. Callers that never move him leave it at zero and pose
    /// exactly once, which is what ``RoomDriver/posesApplied`` asserts.
    let moves: Int

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    init(room: HomeRoom,
         clock: RoomClock = RoomClock(),
         mechanism: RoomSurfaceMechanism? = nil,
         approach: RoomApproachSource? = nil,
         forceReduceMotion: Bool = false,
         moves: Int = 0) {
        self.room = room
        self.clock = clock
        self.mechanism = mechanism
        self.approach = approach
        self.forceReduceMotion = forceReduceMotion
        self.moves = moves
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoomSceneLayer(room: room, clock: clock, mechanism: mechanism,
                               approach: approach, reduceMotion: reduceMotion, moves: moves)
                RoomLightPassLayer(room: room, clock: clock, approach: approach,
                                   reduceMotion: reduceMotion, size: geo.size, moves: moves)
                    .allowsHitTesting(false)
            }
        }
        .background(Color(uiColor: RoomLightRig.colour(room.gem.ink)))
        .ignoresSafeArea()
    }
}

// MARK: - The SceneKit layer

struct RoomSceneLayer: UIViewRepresentable {

    let room: HomeRoom
    let clock: RoomClock
    let mechanism: RoomSurfaceMechanism?
    let approach: RoomApproachSource?
    let reduceMotion: Bool
    /// The still path's redraw token — see ``RoomView/moves``. It is read by
    /// nothing in this layer on purpose: what it does is make this view *differ*
    /// when the walker has moved, so SwiftUI calls `updateUIView` and the room
    /// is posed where he now stands.
    let moves: Int

    func makeCoordinator() -> RoomDriver {
        RoomDriver(room: room, clock: clock, mechanism: mechanism,
                   approach: approach, reduceMotion: reduceMotion)
    }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        context.coordinator.scene.install(into: view)
        view.preferredFramesPerSecond = 60
        view.delegate = context.coordinator
        context.coordinator.attach(to: view)
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.setReduceMotion(reduceMotion, on: view)
    }

    static func dismantleUIView(_ view: SCNView, coordinator: RoomDriver) {
        coordinator.detach(from: view)
    }
}

/// Poses the room. `SCNSceneRendererDelegate` runs on SceneKit's own thread,
/// which is where posing belongs: it is the only place a frame can be prepared
/// without racing the frame being drawn.
final class RoomDriver: NSObject, SCNSceneRendererDelegate {

    let scene: RoomScene
    private let clock: RoomClock
    private let approach: RoomApproachSource?
    private var reduceMotion: Bool

    /// How many times the room has been put at an instant.
    ///
    /// The reduce-motion proof, as a number rather than an intention: on that
    /// path it reaches one and stays there for as long as the view is on
    /// screen. `RoomCaptureTests` reads it.
    private(set) var posesApplied = 0

    init(room: HomeRoom, clock: RoomClock, mechanism: RoomSurfaceMechanism?,
         approach: RoomApproachSource?, reduceMotion: Bool) {
        self.scene = RoomScene(room: room, mechanism: mechanism)
        self.clock = clock
        self.approach = approach
        self.reduceMotion = reduceMotion
        super.init()
    }

    func attach(to view: SCNView) {
        setReduceMotion(reduceMotion, on: view)
    }

    func detach(from view: SCNView) {
        view.delegate = nil
        view.isPlaying = false
        view.rendersContinuously = false
    }

    /// The still path, and the whole reason it is real.
    func setReduceMotion(_ on: Bool, on view: SCNView) {
        reduceMotion = on
        if on {
            view.isPlaying = false
            view.rendersContinuously = false
            view.scene?.isPaused = true
            pose(at: clock.stillInstant())
            view.setNeedsDisplay()
        } else {
            view.scene?.isPaused = false
            view.isPlaying = true
            view.rendersContinuously = true
            pose(at: clock.chamberTime())
        }
    }

    func pose(at chamberTime: TimeInterval) {
        scene.pose(at: chamberTime)
        // Her stay has not begun, but the enclosure's air is not hers: it keeps
        // moving while he is still crossing toward her, on the world's own
        // clock. Without this the dust stands perfectly still for the whole
        // ceremony, which the room's first screenshot showed and no assertion
        // about the room could have.
        if clock.isHeld {
            scene.breathe(at: HomeWorlds.worldClock(clock.elapsed(), ring: scene.room.ring))
        }
        // Where he is standing, after where the room is: the pose stands the eye
        // in the room, and the crossing is the one thing that moves it out.
        if let approach { scene.stand(atApproach: approach.value()) }
        posesApplied += 1
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !reduceMotion else { return }
        pose(at: clock.chamberTime())
    }
}

// MARK: - The light pass

/// The Metal shader that carries the light standing in the air.
///
/// Composited with `.screen`, so it can only add light and can never drive a
/// pixel past white — Design's invariant 7, enforced by the blend.
struct RoomLightPassLayer: View {

    let room: HomeRoom
    let clock: RoomClock
    let approach: RoomApproachSource?
    let reduceMotion: Bool
    let size: CGSize
    /// The still path's redraw token — see ``RoomView/moves``.
    let moves: Int

    var body: some View {
        Group {
            if reduceMotion {
                // No timeline, no animation: one evaluation, at the settled
                // state, and then nothing. On a crossing that is quantized to
                // its stations, the evaluation happens once per touch, because
                // a touch is the only thing that moves him.
                pass(at: clock.stillInstant())
            } else {
                TimelineView(.animation) { timeline in
                    pass(at: clock.chamberTime(now: timeline.date.timeIntervalSinceReferenceDate))
                }
            }
        }
        .blendMode(.screen)
    }

    private func pass(at chamberTime: TimeInterval) -> some View {
        let pose = RoomPose(sceneTime: chamberTime, room: room)
        let crossed = approach?.value() ?? 1
        let mark = RoomUnits.markOnScreen(bodyAltitude: room.bodyAltitude,
                                          chamberTime: chamberTime,
                                          size: size,
                                          approach: crossed)
        let rake = RoomLightRig.rakeDirection(keyPosition: pose.keyPosition,
                                              sourceless: room.gem.isSourceless)
        return Rectangle()
            .fill(.white)
            .colorEffect(
                ShaderLibrary.roomLightPass(
                    .float2(Float(size.width), Float(size.height)),
                    .float2(Float(mark.x), Float(mark.y)),
                    .float2(Float(rake.x), Float(rake.y)),
                    .float4(Float(pose.settling),
                            Float(pose.deep),
                            Float(room.bodyAltitude),
                            Float(RoomLightPassLayer.phase(of: room))),
                    .float4(Float(room.gem.diffuse),
                            Float(RoomLightPassLayer.bloomRadius(size: size)),
                            Float(room.world.character.veil),
                            0),
                    .color(room.gem.hue.color()),
                    .color(room.gem.bright.color())))
    }

    /// The bloom's radius at the room's opening, in points — a fraction of the
    /// short edge, so it is the same size on a small phone and a large one.
    static func bloomRadius(size: CGSize) -> CGFloat {
        max(18, min(size.width, size.height) * 0.085)
    }

    /// Her deterministic phase, `0…1`, off the same jitter ``Atmosphere`` keys
    /// her hue with — her position, and nothing else. `jitter` is centred on
    /// zero, so it is carried into a turn rather than re-derived from a second
    /// hash that could disagree with her colour.
    static func phase(of room: HomeRoom) -> Double {
        Atmosphere.jitter(room.position, 1) + 0.5
    }
}

// MARK: - Where the light travels, as arithmetic

extension RoomLightRig {

    /// The direction the key travels across the frame, from its own position.
    ///
    /// `.zero` in a sourceless room, and that zero is the *only* thing the
    /// shader is told about the Crown: it has no direction to be lit from, so
    /// it is handed none. One fact, expressed once.
    ///
    /// Screen x runs with world x and screen y runs **against** world y.
    /// Getting that second sign wrong mirrors the wash onto the side the light
    /// is not on, and the shafts then contradict the shadows SceneKit is
    /// actually throwing — which the spike found the hard way.
    static func rakeDirection(keyPosition: SIMD3<Double>, sourceless: Bool) -> CGPoint {
        guard !sourceless else { return .zero }
        let x = keyPosition.x
        let y = -keyPosition.y
        let length = max(0.0001, (x * x + y * y).squareRoot())
        return CGPoint(x: x / length, y: y / length)
    }
}
