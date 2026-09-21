import SwiftUI
import SceneKit

// MARK: - The climb, on screen
//
// The nine āvaraṇas as one space. Design's Axis hints at it in four words —
// *"scroll to climb · drag to turn"* — and the climb is the half this file
// draws: the walker rises by his own hand, and the world changes around him.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT IS NOT DRAWN HERE, AND WILL NOT BE
// ─────────────────────────────────────────────────────────────────────────────
//
// **No rail.** Design's Axis puts nine ticks down the right edge with the
// current one lit and the ones already met dimmed. That is a progress readout
// of a practice, and Phase 3.1 already ruled its twin: the rite's three beat
// pips were dropped because *"a lit dot, two dim ones, and a counter is exactly
// what the brief names in the same breath as a visit number."* Nine ticks with
// the met ones dimmed is the same thing over a whole instrument, and it would
// also be the one place in the climb that told the walker something was keeping
// track of him.
//
// What replaces it is what it was describing, and it is the whole point of this
// phase: **he knows where he is because the weather tells him.** The air is
// thicker, the light comes from somewhere else, the clock runs at a different
// rate. A rail would make all of that decoration.
//
// **No number, of anything.** There is nowhere in this file to put one:
// everything drawn comes out of ``WorldWeather``, which has no field that
// counts, and the one string is an āvaraṇa's own name.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ĀVARAṆA'S NAME IS NAMED, AND THAT IS NOT A MEASURE
// ─────────────────────────────────────────────────────────────────────────────
//
// `Trailokyamohana` is the name of an enclosure, the way a room's own label is
// the name of a room. It carries no count and says nothing about the walking.
// It is read off the base where the base has been reached (law 1) and falls
// back to Design's table where it has not, and it fades with the crossing so it
// reads as the air changing rather than as a header standing over the world.

/// The nine worlds as one climb.
struct WorldClimbView: View {

    /// The live āvaraṇa rows, keyed by ring, where the base has been reached.
    /// Airtable's name wins over Design's table; where it is silent, Design's
    /// stands rather than a blank (FIDELITY §6).
    let live: [Int: HomeWorlds.LiveFacts]

    /// Forced on for tests and captures; otherwise the environment decides.
    let forceReduceMotion: Bool

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    @State private var climb: WorldClimbSource
    /// Where the walker stood when the current drag began.
    @State private var dragFrom: Double = 0
    @State private var dragging = false
    /// Redrawn on a step, so the still path has something to change on.
    @State private var steps = 0

    init(live: [Int: HomeWorlds.LiveFacts] = [:],
         startingAtRing ring: Int = 1,
         forceReduceMotion: Bool = false) {
        self.live = live
        self.forceReduceMotion = forceReduceMotion
        _climb = State(initialValue: WorldClimbSource(
            .standing(atFraction: Double(max(1, min(HomeWorlds.rings.count, ring)) - 1))))
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        ZStack {
            WorldClimbLayer(climb: climb, reduceMotion: reduceMotion, steps: steps)
                .allowsHitTesting(false)
            name
        }
        .background(Color.ground)
        .contentShape(Rectangle())
        .gesture(rising)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(worldName(atFraction: climb.value())))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: step(by: 1)
            case .decrement: step(by: -1)
            @unknown default: break
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Rising

    /// The walker rises by his own hand. A drag up is a climb — one screen
    /// height is one band, so the whole climb is eight of them and a world is
    /// never more than a gesture away.
    ///
    /// When he lets go, Design's own settle closes on where he left it
    /// (`climb += (target - climb) * 0.06`), written as the exponential it is,
    /// so a dropped frame cannot change where he ends up.
    private var rising: some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { value in
                guard !reduceMotion else { return }
                if !dragging {
                    dragging = true
                    dragFrom = climb.value()
                }
                let bands = -value.translation.height / Self.pointsPerBand
                climb.set(.standing(atFraction: dragFrom + bands))
            }
            .onEnded { value in
                dragging = false
                guard !reduceMotion else {
                    step(by: value.translation.height < 0 ? 1 : -1)
                    return
                }
                let here = climb.value()
                let carried = -value.predictedEndTranslation.height / Self.pointsPerBand
                climb.set(.settling(from: here, to: dragFrom + carried,
                                    at: Date().timeIntervalSinceReferenceDate))
            }
    }

    /// How far the walker's hand carries him. One screen height to a band: the
    /// climb is the body, and a band is a body.
    static let pointsPerBand: Double = 640

    /// One band, by the station rather than by the hand — a flick, or
    /// VoiceOver's own adjustment.
    ///
    /// With motion on it is still **travel**: he rises to the next station at
    /// Design's own pace, because invariant 3 allows nothing else. With reduce
    /// motion on he steps there and stands, which is invariant 4's *quantized,
    /// never disabled* — every band is still passed through, and what is
    /// dropped is the frame loop between them rather than a world.
    private func step(by bands: Int) {
        let here = climb.value()
        if reduceMotion {
            climb.set(.stepping(from: here, by: bands))
        } else {
            climb.set(.rising(from: here, to: here.rounded() + Double(bands),
                              at: Date().timeIntervalSinceReferenceDate))
        }
        steps &+= 1
    }

    // MARK: - The name of where he is

    @ViewBuilder
    private var name: some View {
        if reduceMotion {
            label(atFraction: climb.value())
        } else {
            TimelineView(.animation) { _ in
                label(atFraction: climb.value())
            }
        }
    }

    private func label(atFraction f: Double) -> some View {
        // Clearest at a station and faintest between two, so the name belongs
        // to the world rather than standing over the climb. Its floor is
        // FIDELITY §4's legibility floor for meaningful text, never below it.
        let k = WorldClimbTravel.clamp(f) - WorldClimbTravel.clamp(f).rounded(.down)
        let settled = 1 - abs(k - 0.5) * 2
        return VStack {
            Spacer()
            Text(worldName(atFraction: f))
                .font(AppFont.sanskrit(Self.nameSize))
                .tracking(1.6)
                .foregroundStyle(Color.cream)
                .opacity(Self.nameFloor + (1 - Self.nameFloor) * (1 - settled))
                .padding(.bottom, 44)
        }
        .allowsHitTesting(false)
    }

    private func worldName(atFraction f: Double) -> String {
        let ring = WorldClimb.nearestRing(atFraction: f)
        return HomeWorlds.world(ring: ring, live: live[ring])?.name ?? ""
    }

    /// FIDELITY §4: meaningful text at ≥ 11 pt and ≥ ~0.5 cream alpha. The name
    /// of an enclosure is meaningful, so it never falls below the floor.
    static let nameSize: CGFloat = 15
    static let nameFloor: Double = 0.52
}

// MARK: - The SceneKit layer

struct WorldClimbLayer: UIViewRepresentable {

    let climb: WorldClimbSource
    let reduceMotion: Bool
    /// Bumped on each quantized step, so the still path is asked for a frame.
    let steps: Int

    func makeCoordinator() -> WorldClimbDriver {
        WorldClimbDriver(climb: climb, reduceMotion: reduceMotion)
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

    static func dismantleUIView(_ view: SCNView, coordinator: WorldClimbDriver) {
        coordinator.detach(from: view)
    }
}

/// Stands the walker on the climb. `SCNSceneRendererDelegate` runs on
/// SceneKit's own thread, which is where standing belongs: it is the only place
/// a frame can be prepared without racing the frame being drawn.
final class WorldClimbDriver: NSObject, SCNSceneRendererDelegate {

    let scene = WorldClimbScene()
    private let climb: WorldClimbSource
    private var reduceMotion: Bool

    /// How many times the walker has been stood somewhere.
    ///
    /// The reduce-motion proof, as a number rather than an intention: on that
    /// path it rises once per touch and not once per frame, however long the
    /// view is left on screen. The same register ``RoomDriver/posesApplied``
    /// keeps for a room.
    private(set) var standsApplied = 0

    init(climb: WorldClimbSource, reduceMotion: Bool) {
        self.climb = climb
        self.reduceMotion = reduceMotion
        super.init()
    }

    func attach(to view: SCNView) { setReduceMotion(reduceMotion, on: view) }

    func detach(from view: SCNView) {
        view.delegate = nil
        view.isPlaying = false
        view.rendersContinuously = false
    }

    /// The still path, and the whole reason it is real: no `CADisplayLink`, no
    /// `TimelineView`, no continuous rendering, no per-frame work of any kind.
    /// The climb is stood once and drawn once, and then nothing happens until a
    /// touch moves him.
    func setReduceMotion(_ on: Bool, on view: SCNView) {
        reduceMotion = on
        if on {
            view.isPlaying = false
            view.rendersContinuously = false
            view.scene?.isPaused = true
            stand()
            view.setNeedsDisplay()
        } else {
            view.scene?.isPaused = false
            view.isPlaying = true
            view.rendersContinuously = true
            stand()
        }
    }

    func stand() {
        let now = Date().timeIntervalSinceReferenceDate
        scene.stand(atFraction: climb.value(at: now), at: now)
        standsApplied += 1
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !reduceMotion else { return }
        stand()
    }
}
