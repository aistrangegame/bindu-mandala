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

    /// Called once, when he has crossed off the axis — the Field takes him off
    /// it. See ``TheWayOut``.
    let onLeft: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    @State private var climb: WorldClimbSource
    /// Where the walker stood when the current drag began.
    @State private var dragFrom: Double = 0
    @State private var dragging = false
    /// Redrawn on a step, so the still path has something to change on.
    @State private var steps = 0
    /// Whether the walker has moved on the axis yet, this time he is on it.
    ///
    /// The one thing the hint below is allowed to know. It is not written down,
    /// not read back, and does not outlive the surface: the axis has no idea
    /// whether he has ever climbed before, and an instruction that went away
    /// because it had been *followed once, ever* would be the instrument keeping
    /// a record of him. It goes away because he is already doing the thing.
    @State private var risen = false
    /// How far out of the world he has been carried by the hold, 0 … 1.
    @State private var withdrawn: Double = 0

    init(live: [Int: HomeWorlds.LiveFacts] = [:],
         startingAtRing ring: Int = 1,
         forceReduceMotion: Bool = false,
         onLeft: (() -> Void)? = nil) {
        self.live = live
        self.forceReduceMotion = forceReduceMotion
        self.onLeft = onLeft
        _climb = State(initialValue: WorldClimbSource(
            .standing(atFraction: Double(max(1, min(HomeWorlds.rings.count, ring)) - 1))))
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        ZStack {
            WorldClimbLayer(climb: climb, reduceMotion: reduceMotion, steps: steps)
                .allowsHitTesting(false)
            name
            hint
            // The world going out from under him as he withdraws from it. See
            // ``withdrawing``.
            Color.ground
                .opacity(withdrawn)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
        .background(Color.ground)
        .contentShape(Rectangle())
        .gesture(rising)
        // The same way out of the axis as out of a room, drawn by the same file
        // and held for the same length of crossing. One way out of the Homes
        // layer, learned once — and the hold has something travelling through
        // it here as it does in a room, which is the condition ``TheWayOut``'s
        // own header sets for asking for a hold at all.
        .theWayOut(reduceMotion: reduceMotion,
                   onBegan: { seconds in withdrawing(over: seconds) },
                   onLetGo: { stayOn() },
                   onOut: { onLeft?() })
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
                risen = true
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
        risen = true
    }

    // MARK: - Withdrawing from the axis

    /// **What travels through the hold here.**
    ///
    /// ``TheWayOut`` asks for a hold rather than a touch because leaving is a
    /// crossing, and its own header sets the condition: *a hold is only legible
    /// while something is travelling through it.* In her room the eye stands
    /// away from her through the āvaraṇa's air for the whole of it. The axis had
    /// no approach to unwind — it has a height, not a distance — so it stood the
    /// same two and a fifth seconds with nothing moving at all, which is exactly
    /// the stopped clock the still path was given a step to avoid.
    ///
    /// So the world itself goes: the enclosure's air, its light and its name
    /// recede into the ground he came in through, over precisely the length of
    /// the hold. Letting go brings it back at the same rate, because a walker
    /// who thought about leaving and did not has not left.
    ///
    /// Untouched on the still path, where the way out is a touch and this is
    /// never called.
    private func withdrawing(over seconds: TimeInterval) {
        withAnimation(.linear(duration: max(0, seconds))) { withdrawn = 1 }
    }

    private func stayOn() {
        withAnimation(.linear(duration: WorldClimbView.returningSeconds)) { withdrawn = 0 }
    }

    /// How fast the world comes back when he lets go — the station rate a room
    /// closes on him at, so the two ways out breathe alike.
    static let returningSeconds: TimeInterval = 0.45

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
                // Clear of ``TheWayOut``'s own line, which stands at the foot of
                // the frame here exactly as it does in a room. The instruction
                // is the lowest thing on any Homes surface and the world's own
                // name stands above it, because the name belongs to the world
                // and the instruction belongs to the walker.
                .padding(.bottom, 124)
        }
        .allowsHitTesting(false)
    }

    // MARK: - That the space can be climbed at all

    /// **The axis used to arrive mute.**
    ///
    /// Two lines stood on it: the āvaraṇa's name, and the way out. A walker who
    /// arrived, waited and saw nothing change was told only how to leave the
    /// thing he had just opened — the whole instruction budget of the surface
    /// spent on the exit, with no word that the space rises. The climb is the
    /// payload of this phase's second door, and it was invisible.
    ///
    /// Design's own Axis carries four words for it: *"scroll to climb · drag to
    /// turn"*. Half of that is this file's gesture, so half of it is what is
    /// said — in the rite's own prompt type, in the rite's own voice, at the top
    /// of the frame where nothing else stands.
    ///
    /// **It is not a measure and it cannot become one.** It says what the hand
    /// may do, which is the same register as *"hold to withdraw"* two inches
    /// below it, and it knows one thing: whether he has moved yet, *on this
    /// visit to the axis*. Nothing is written down, nothing is read back, and
    /// the next time he rises it is there again. An instruction that vanished
    /// for good the first time it was obeyed would be the instrument
    /// remembering him, which is the one thing it may never do.
    @ViewBuilder
    private var hint: some View {
        VStack {
            // Taken out of the tree rather than faded to nothing, so a line that
            // has been answered is not still there to be read by a finger or by
            // a voice.
            if !risen {
                Text(Self.hintWords)
                    .font(AppFont.label(Self.hintSize))
                    .textCase(.uppercase)
                    .tracking(Self.hintSize * 0.3)
                    .foregroundStyle(Color.cream)
                    .opacity(RiteOfEntering.promptAlpha)
                    .padding(.top, 72)
                    .frame(minHeight: 44)
                    .transition(.opacity)
            }
            Spacer()
        }
        // Quantized, never disabled: on the still path the line is simply gone
        // once he has moved, with no fade to watch.
        .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: risen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    /// The gesture this file actually offers, in the rite's own words. The way
    /// out says *"hold to withdraw"*; this says what the other hand may do.
    static let hintWords = "drag to rise"
    /// The rite's own prompt size and alpha, which clear FIDELITY §4's floor.
    static let hintSize: CGFloat = 11

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

    /// The instant the climb opened, and the only reference-date number in this
    /// file that reaches the scene.
    ///
    /// The climb is the one place in the Homes layer that had no clock of its
    /// own: a room has ``RoomClock``, whose `elapsed` is seconds since the stay
    /// began, and the axis was handing the scene raw reference-date time
    /// instead. That is roughly 8.1 × 10⁸ today, and the air is driven through a
    /// shader `float` whose ulp at that magnitude is **sixty-four seconds** — so
    /// the motes held one offset for a minute and then jumped, which is the
    /// āvaraṇa's dust standing perfectly still all over again, one phase later.
    /// Design's own axis never has this shape: its `t` starts at zero and
    /// accumulates `dt`.
    ///
    /// The travel keeps absolute time — ``RoomApproach`` is anchored to the
    /// instant the drag or the rise began — so only the world's own seconds are
    /// counted from here.
    private let epoch = Date().timeIntervalSinceReferenceDate

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
            // Once, and only before the loop has ever run. This is the main
            // thread; `renderer(_:updateAtTime:)` is SceneKit's, and standing
            // the walker from both would be two threads writing one scene while
            // a frame is drawn out of it. See ``RoomDriver/setReduceMotion(_:on:)``,
            // which carries the whole argument.
            if standsApplied == 0 { stand() }
            view.isPlaying = true
            view.rendersContinuously = true
        }
    }

    func stand() {
        let now = Date().timeIntervalSinceReferenceDate
        scene.stand(atFraction: climb.value(at: now), at: now - epoch)
        standsApplied += 1
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !reduceMotion else { return }
        stand()
    }
}
