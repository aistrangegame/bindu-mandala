import SwiftUI
import SceneKit

// MARK: - The climb, on screen
//
// The nine āvaraṇas as one space, and — Wave 2 — Design's Axis whole: the 102
// Śaktis standing in it as breathing points of light at their own altitude.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THIS SURFACE HOLDS NOW (Wave 2 · One building)
// ─────────────────────────────────────────────────────────────────────────────
//
//   • **The 102 lights** (``ClimbLights``), each in her own world, breathing on
//     her own clock; a Śakti he has stood with carries Design's core light —
//     *she was expecting you* — and today's Śakti carries the crown light
//     *you did not choose her*.
//   • **Fly into her light.** A touch on a light flies the eye into it while the
//     air thickens, and her rite of entering begins from inside the light
//     (``HerRoomDoor`` — the one threshold every way in passes through).
//   • **The rail of nine** down the right edge — region words, the one he
//     stands in lit, a gold tick on a world he has stood in. Place, never
//     progress (§4.6): the same rail on the first day and the ten-thousandth,
//     save for where he has stood, which he may always be shown.
//   • **The weather sentences** — Design's `writeWorld`: the form, the ordinal
//     and the region; the name; the gem on the dhātu and the clock; and the one
//     line of what the air does.
//   • **Drag to turn** — Design's `tYaw -= dx · 0.0024`, beside drag to rise.
//   • **The four Ring Worlds' mechanisms, reborn in their worlds**: Ring 3's
//     lights scatter under the moving finger and gather in stillness; Ring 6's
//     light follows the finger and the name it reaches whispers; a touch on the
//     empty air of Ring 7 strikes the twelve-voice chord; holding in Ring 8
//     glides its three tones (and its three lights) into one.
//   • **Sound** — every world has its voice (``RingFieldVoice``, and
//     ``HomeSoundService``'s nine grounds crossfading on the climb's own
//     weights). The silent switch is honoured.
//
// The rule the Phase 3.2 header wrote here — *no rail, no number* — was lifted
// by Charter II to its first principle: nothing grades him. The rail says
// where; nothing on this surface counts.

/// The nine worlds as one climb, and the 102 standing in it.
@MainActor
struct WorldClimbView: View {

    /// The live āvaraṇa rows, keyed by ring, where the base has been reached.
    let live: [Int: HomeWorlds.LiveFacts]
    /// The 102, with the names the base gives them.
    let seats: [ClimbLights.Seat]
    /// The Śaktis he has stood with or felt — they carry a core light.
    let met: Set<Int>
    /// Today's Śakti — she carries the crown light.
    let todayKp: Int?

    /// Forced on for tests and captures; otherwise the environment decides.
    let forceReduceMotion: Bool

    /// Called once, when he has crossed off the axis — the Field takes him off
    /// it. See ``TheWayOut``.
    let onLeft: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    @State private var climb: WorldClimbSource
    /// Reaches the driver, for the questions only the renderer can answer
    /// (which light is under a finger).
    @State private var box = ClimbDriverBox()
    /// Where the walker stood when the current drag began, and how he was
    /// turned.
    @State private var dragFrom: Double = 0
    @State private var yawFrom: Double = 0
    @State private var dragging = false
    @State private var moved = false
    /// Redrawn on a step, so the still path has something to change on.
    @State private var steps = 0
    /// Whether the walker has moved on the axis yet, this time he is on it.
    /// Not written down, not read back — see the Phase 3.7 note in git history.
    @State private var risen = false
    /// How far out of the world he has been carried by the hold, 0 … 1.
    @State private var withdrawn: Double = 0
    /// The Śakti whose room is open — through ``HerRoomDoor``.
    @State private var roomKp: Int?
    /// The light nearest the eye, for Design's `low` line.
    @State private var nearKp: Int?
    /// Ring 6's whisper: whose name the moving light reached, and when.
    @State private var whisper: ClimbWhisper?

    init(live: [Int: HomeWorlds.LiveFacts] = [:],
         seats: [ClimbLights.Seat] = ClimbLights.bareGarland,
         met: Set<Int> = [],
         todayKp: Int? = nil,
         startingAtRing ring: Int = 1,
         forceReduceMotion: Bool = false,
         onLeft: (() -> Void)? = nil) {
        self.live = live
        self.seats = seats
        self.met = met
        self.todayKp = todayKp
        self.forceReduceMotion = forceReduceMotion
        self.onLeft = onLeft
        _climb = State(initialValue: WorldClimbSource(
            .standing(atFraction: Double(max(1, min(HomeWorlds.rings.count, ring)) - 1))))
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        ZStack {
            WorldClimbLayer(climb: climb, box: box, seats: seats, met: met, todayKp: todayKp,
                            reduceMotion: reduceMotion, steps: steps)
                .allowsHitTesting(false)
            // The hand on the climb, on its own layer beneath the rail — the
            // Mandala's own arrangement, so the rail's buttons answer first.
            Color.clear
                .contentShape(Rectangle())
                .gesture(handOnTheClimb)
            words
            hint
            whisperLine
            // Wave 6 · B · Bindu at the foot of the climb, Lalitā at its
            // summit — each one line, once a day; and the Om's floor follows
            // the world he stands in.
            ClimbGuide(ring: hereRing, roomOpen: roomKp != nil)
            // Wave 6 · the ten body chakras, touchable at their own heights.
            ClimbBodyChakras(source: climb, reduceMotion: reduceMotion)
            rail
            // The world going out from under him as he withdraws from it. See
            // ``withdrawing``.
            Color.ground
                .opacity(withdrawn)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
        .background(Color.ground)
        .contentShape(Rectangle())
        // The same way out of the axis as out of a room, drawn by the same file
        // and held for the same length of crossing.
        .theWayOut(reduceMotion: reduceMotion,
                   onBegan: { seconds in withdrawing(over: seconds) },
                   onLetGo: { stayOn() },
                   onOut: { leaveTheClimb() })
        // Wave 2 · and the equal way out, from the edge.
        .theEdgeWayOut(onOut: { leaveTheClimb() })
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
        // Wave 2 · her room, through her rite, from inside her light.
        // U2 · C · her room is Her Home, its own world: the Climb crosses
        // there (back returns him to the axis) and lands its eye at once.
        .crossesToHerHome($roomKp, then: { landed() })
        // Wave 2 · the climb sounds, world by world. Paused while her room is
        // open (the room's own voice takes the instrument), resumed on return.
        .task(id: roomKp == nil) { await soundTheClimb() }
        // Design's `low` line: the light nearest the eye, asked four times a
        // second and written only when it changes, so a still climb is still.
        .task { await watchTheNearestLight() }
        .onDisappear {
            guard roomKp == nil, !AppRuntime.isUnitTesting else { return }
            RingFieldVoice.shared.silence()
            HomeSoundService.shared.stopAll()
        }
    }

    // MARK: - The hand on the climb

    /// One gesture for the whole climb, as the Mandala has one: a drag up is a
    /// rise (one screen height to a band), a drag across turns (Design's
    /// `0.0024` rad a point), a touch that does not move chooses — a light, or
    /// in Ring 7 the empty air's chord. While the finger is down the ring
    /// mechanisms answer it.
    private var handOnTheClimb: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if !dragging {
                    dragging = true
                    moved = false
                    dragFrom = climb.value()
                    yawFrom = climb.yawTarget
                    climb.touching = true
                    if hereRing == 8 { RingFieldVoice.shared.unite(1) }
                }
                let distance = abs(value.translation.width) + abs(value.translation.height)
                if distance > 8 { moved = true; climb.moving = true }
                guard moved, !reduceMotion else { return }
                risen = true
                let bands = -value.translation.height / Self.pointsPerBand
                climb.set(.standing(atFraction: dragFrom + bands))
                climb.yawTarget = max(-Self.maxYaw, min(Self.maxYaw,
                                       yawFrom - Double(value.translation.width) * Self.yawPerPoint))
                // Ring 6: the light follows the finger, and whispers.
                if hereRing == 6 {
                    box.driver?.follow(at: value.location)
                    if let kp = box.driver?.whispered(at: value.location), kp != whisper?.kp {
                        whisper = ClimbWhisper(kp: kp, at: Date())
                    }
                } else {
                    climb.follow = nil
                }
            }
            .onEnded { value in
                dragging = false
                climb.touching = false
                climb.moving = false
                climb.follow = nil
                if hereRing == 8 { RingFieldVoice.shared.unite(0) }
                guard moved else {
                    touch(at: value.location)
                    return
                }
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

    /// How far the walker's hand carries him. One screen height to a band.
    static let pointsPerBand: Double = 640
    /// Design's `tYaw -= (dx) * 0.0024`.
    static let yawPerPoint: Double = 0.0024
    /// How far he may turn either way — far enough to face any of her sisters.
    static let maxYaw: Double = .pi

    /// A touch that did not move: a light, or the empty air.
    private func touch(at point: CGPoint) {
        if let kp = box.driver?.pick(at: point) {
            flyInto(kp)
            return
        }
        // Ring 7: the empty air strikes the twelve-voice chord.
        if hereRing == 7 {
            Haptics.soft()
            RingFieldVoice.shared.chord()
        }
    }

    /// **Fly into her light** — Design's `beginEnter`. The eye leaves the axis
    /// and flies into her point while the air thickens, and her rite begins
    /// inside the light. Under reduced motion he steps in: no flight, the same
    /// rite.
    private func flyInto(_ kp: Int) {
        guard roomKp == nil, climb.flight == nil else { return }
        Haptics.medium()
        risen = true
        if reduceMotion {
            roomKp = kp
            return
        }
        climb.flight = (kp: kp, since: Date().timeIntervalSinceReferenceDate)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(ClimbFlight.seconds))
            roomKp = kp
        }
    }

    /// He has come out of her room (or out of the corridor). The eye returns to
    /// the axis through the ground he came in by, and the lights are marked
    /// again — a Śakti he has now stood with carries her core.
    private func landed() {
        climb.flight = nil
        withdrawn = 1
        steps &+= 1
        withAnimation(.easeOut(duration: reduceMotion ? 0.01 : 0.9)) { withdrawn = 0 }
    }

    /// One band, by the station rather than by the hand — a flick, the rail,
    /// or VoiceOver's own adjustment.
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

    /// To a world, from the rail.
    private func rise(toRing ring: Int) {
        let here = climb.value().rounded()
        let bands = Int(Double(ring - 1) - here)
        guard bands != 0 else { return }
        Haptics.light()
        step(by: bands)
    }

    private func leaveTheClimb() {
        if !AppRuntime.isUnitTesting {
            RingFieldVoice.shared.silence()
            HomeSoundService.shared.stopAll()
        }
        onLeft?()
    }

    /// The world he is standing in, now.
    private var hereRing: Int { WorldClimb.nearestRing(atFraction: climb.value()) }

    // MARK: - Withdrawing from the axis

    /// What travels through the hold here: the world itself goes, over exactly
    /// the length of the hold, and comes back at the station rate if he lets go.
    private func withdrawing(over seconds: TimeInterval) {
        withAnimation(.linear(duration: max(0, seconds))) { withdrawn = 1 }
    }

    private func stayOn() {
        withAnimation(.linear(duration: WorldClimbView.returningSeconds)) { withdrawn = 0 }
    }

    /// How fast the world comes back when he lets go.
    static let returningSeconds: TimeInterval = 0.45

    // MARK: - The words of where he is (Design's `writeWorld`)

    @ViewBuilder
    private var words: some View {
        if reduceMotion {
            wordsBlock(atFraction: climb.value())
        } else {
            TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { _ in
                wordsBlock(atFraction: climb.value())
            }
        }
    }

    private func wordsBlock(atFraction f: Double) -> some View {
        // Clearest at a station and faintest between two, so the words belong
        // to the world rather than standing over the climb — never below
        // FIDELITY §4's floor.
        let clamped = WorldClimbTravel.clamp(f)
        let k = clamped - clamped.rounded(.down)
        let between = 1 - abs(k - 0.5) * 2
        let alpha = Self.nameFloor + (1 - Self.nameFloor) * (1 - between)
        let ring = WorldClimb.nearestRing(atFraction: f)
        let world = HomeWorlds.world(ring: ring, live: live[ring])
        let presides = todayKp.map { KhadgamalaMap.ringNumber(forKhadgamala: $0) == ring } ?? false
        // Wave 6 · the empty summit (C-1260): at the top nobody is standing,
        // so no name is spoken there; his line and the Totality close are.
        let empty = ClimbSummit.emptiness(atFraction: clamped)
        let near = empty > 0.5 ? nil : nearKp.flatMap { kp in seats.first { $0.kp == kp } }
        return VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(world.map { ClimbWords.kicker($0) } ?? "")
                    .font(AppFont.label(11))
                    .tracking(2.4)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.gold)
                    .multilineTextAlignment(.center)
                Text(world?.name ?? "")
                    .font(AppFont.sanskrit(28))
                    .tracking(0.6)
                    .foregroundStyle(Color.cream)
                    .shadow(color: .black.opacity(0.9), radius: 18)
                Text(world.map { ClimbWords.material($0) } ?? "")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream)
                    .opacity(0.7)
            }
            .padding(.horizontal, 64)
            .padding(.top, 52)
            .opacity(alpha)
            Spacer()
            if empty > 0.01 {
                VStack(spacing: 12) {
                    Text(ClimbSummit.becoming)
                        .font(AppFont.sanskrit(26))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.cream)
                        .shadow(color: .black.opacity(0.9), radius: 18)
                        .opacity(empty)
                    Text(ClimbSummit.alreadyDid)
                        .font(AppFont.voice(18))
                        .foregroundStyle(Color.gold)
                        .opacity(ClimbSummit.closeLight(atFraction: clamped))
                }
                .padding(.horizontal, 48)
                Spacer()
            }
            VStack(spacing: 10) {
                Text(world?.weather ?? "")
                    .font(AppFont.voice(18))
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .opacity(0.92)
                    .shadow(color: .black.opacity(0.95), radius: 20)
                    .fixedSize(horizontal: false, vertical: true)
                if presides {
                    Text(ClimbWords.presides)
                        .font(AppFont.label(11))
                        .tracking(2.6)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.gold)
                }
                if let near {
                    Text(ClimbWords.near(near, isToday: near.kp == todayKp))
                        .font(AppFont.label(11))
                        .tracking(1.8)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.cream)
                        .opacity(0.6)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 64)
            .opacity(alpha)
            // Clear of ``TheWayOut``'s own line at the foot of the frame.
            .padding(.bottom, 124)
        }
        .allowsHitTesting(false)
    }

    // MARK: - That the space can be climbed, turned, and entered

    @ViewBuilder
    private var hint: some View {
        VStack {
            if !risen {
                Text(Self.hintWords)
                    .font(AppFont.label(Self.hintSize))
                    .textCase(.uppercase)
                    .tracking(Self.hintSize * 0.3)
                    .foregroundStyle(Color.cream)
                    .opacity(RiteOfEntering.promptAlpha)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 160)
                    .frame(minHeight: 44)
                    .transition(.opacity)
            }
            Spacer()
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: risen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    /// The gestures this surface offers, in the rite's own words.
    static let hintWords = ClimbWords.hint
    /// The rite's own prompt size and alpha, which clear FIDELITY §4's floor.
    static let hintSize: CGFloat = 11

    // MARK: - Ring 6's whisper

    @ViewBuilder
    private var whisperLine: some View {
        if let whisper, let seat = seats.first(where: { $0.kp == whisper.kp }) {
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: reduceMotion)) { tl in
                let age = tl.date.timeIntervalSince(whisper.at)
                let fade = max(0, 1 - age / ClimbLights.whisperSeconds)
                VStack(spacing: 4) {
                    Text(seat.name)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream)
                        .opacity(fade)
                    if let gloss = ClimbLights.whisperGloss(kp: seat.kp) {
                        Text(gloss)
                            .font(AppFont.voice(13))
                            .foregroundStyle(Color.cream)
                            .opacity(fade)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 120)
            }
            .allowsHitTesting(false)
        }
    }

    // MARK: - The rail of nine

    /// The rail follows where he stands; on the still path it changes only on
    /// a step, which re-renders the surface anyway.
    @ViewBuilder
    private var rail: some View {
        if reduceMotion {
            railBody
        } else {
            TimelineView(.periodic(from: .now, by: 0.25)) { _ in railBody }
        }
    }

    private var railBody: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(railEntries) { entry in
                    Button {
                        rise(toRing: entry.ring)
                    } label: {
                        HStack(spacing: 8) {
                            Text(entry.region)
                                .font(AppFont.label(11))
                                .tracking(1.4)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.cream)
                                .opacity(entry.isHere ? 1 : Self.railRest)
                            Rectangle()
                                .fill(entry.isMet ? Color.gold : Color.cream)
                                .frame(width: entry.isHere ? 24 : 14, height: entry.isHere ? 2 : 1)
                                .opacity(entry.isHere || entry.isMet ? 1 : Self.railRest)
                        }
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(entry.region))
                    .accessibilityAddTraits(entry.isHere ? .isSelected : [])
                }
            }
            .padding(.trailing, 18)
        }
        .frame(maxHeight: .infinity)
    }

    /// The rail at rest: present, and quieter than where he stands. Design
    /// drew it at 0.32; FIDELITY's floor for a word is 0.5.
    static let railRest: Double = 0.55

    private var railEntries: [ClimbRail.Entry] {
        _ = steps
        return ClimbRail.entries(here: hereRing, metRings: ClimbRail.metRings(met), live: live)
    }

    // MARK: - The sound of the climb

    /// Every world has its voice. Ten times a second, the worlds he is between
    /// are sounded at the climb's own weights — HomeSoundService's nine grounds
    /// (Design's climb voice) and the ring voices (``RingFieldVoice``).
    private func soundTheClimb() async {
        guard roomKp == nil, !AppRuntime.isUnitTesting else { return }
        // Wave 6.1 · his ruling: on the Climb the ring voices stand in front,
        // and the grounds wait for the room. The loop stops while her room is
        // open, which hands the front back to the room's own voice.
        SoundConductor.shared.setClimbing(true)
        defer { SoundConductor.shared.setClimbing(false) }
        HomeSoundService.shared.respectsSilentSwitch = true
        HomeSoundService.shared.start()
        while !Task.isCancelled {
            let f = climb.value()
            RingFieldVoice.shared.sound(RingFieldVoice.want(climbFraction: f))
            let near = WorldClimb.weights(atFraction: f)
            let i0 = (near.first?.ring ?? 1) - 1
            let i1 = (near.count > 1 ? near[1].ring : near.first?.ring ?? 1) - 1
            let k = near.count > 1 ? near[1].weight : 0
            HomeSoundService.shared.setGround(index: i0, next: i1, blend: k)
            try? await Task.sleep(for: .seconds(0.1))
        }
        RingFieldVoice.shared.silence()
    }

    private func watchTheNearestLight() async {
        while !Task.isCancelled {
            // On the still path the climb only moves on a touch, so the question
            // is asked slowly; the answer is written only when it changes.
            try? await Task.sleep(for: .seconds(reduceMotion ? 1 : 0.25))
            let found = box.driver?.nearest()
            if found != nearKp { nearKp = found }
        }
    }

    private func worldName(atFraction f: Double) -> String {
        let ring = WorldClimb.nearestRing(atFraction: f)
        return HomeWorlds.world(ring: ring, live: live[ring])?.name ?? ""
    }

    /// FIDELITY §4: meaningful text at ≥ 11 pt and ≥ ~0.5 cream alpha.
    static let nameFloor: Double = 0.52
}

/// Ring 6's whisper.
struct ClimbWhisper: Equatable {
    let kp: Int
    let at: Date
}

/// A reference the view keeps to its renderer's driver.
final class ClimbDriverBox {
    weak var driver: WorldClimbDriver?
}

// MARK: - The SceneKit layer

struct WorldClimbLayer: UIViewRepresentable {

    let climb: WorldClimbSource
    let box: ClimbDriverBox
    let seats: [ClimbLights.Seat]
    let met: Set<Int>
    let todayKp: Int?
    let reduceMotion: Bool
    /// Bumped on each quantized step, so the still path is asked for a frame.
    let steps: Int

    func makeCoordinator() -> WorldClimbDriver {
        let driver = WorldClimbDriver(climb: climb, reduceMotion: reduceMotion)
        driver.scene.hold(seats: seats, met: met, today: todayKp)
        driver.marked = (met, todayKp)
        return driver
    }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        context.coordinator.scene.install(into: view)
        view.preferredFramesPerSecond = 60
        view.delegate = context.coordinator
        context.coordinator.attach(to: view)
        box.driver = context.coordinator
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        box.driver = context.coordinator
        context.coordinator.remark(met: met, today: todayKp)
        context.coordinator.update(reduceMotion: reduceMotion, steps: steps, on: view)
    }

    static func dismantleUIView(_ view: SCNView, coordinator: WorldClimbDriver) {
        coordinator.detach(from: view)
    }
}

/// Stands the walker on the climb. `SCNSceneRendererDelegate` runs on
/// SceneKit's own thread, which is where standing belongs.
final class WorldClimbDriver: NSObject, SCNSceneRendererDelegate {

    let scene = WorldClimbScene()
    private let climb: WorldClimbSource
    private var reduceMotion: Bool
    private weak var view: SCNView?

    /// How many times the walker has been stood somewhere — the reduce-motion
    /// proof, as a number: on that path it rises once per touch, never per frame.
    private(set) var standsApplied = 0

    /// The instant the climb opened; the world's own seconds count from here.
    private let epoch = Date().timeIntervalSinceReferenceDate

    /// The marks last handed to the lights, so they are moved only on change.
    var marked: (met: Set<Int>, today: Int?) = ([], nil)

    /// The hand's state, integrated frame to frame.
    private var gestures = ClimbGestures()
    private var lastStand: TimeInterval?
    /// Wave 6 · Ring 2's lotus, read from the day's sun once a minute.
    private var lotusReadAt: TimeInterval = -1_000
    private var lotusOpenness: Double = 1

    init(climb: WorldClimbSource, reduceMotion: Bool) {
        self.climb = climb
        self.reduceMotion = reduceMotion
        super.init()
    }

    func attach(to view: SCNView) {
        self.view = view
        setReduceMotion(reduceMotion, on: view)
    }

    func detach(from view: SCNView) {
        view.delegate = nil
        view.isPlaying = false
        view.rendersContinuously = false
    }

    /// The marks on the lights moved — a Śakti newly stood with, or the day
    /// turned. Only on change.
    @MainActor
    func remark(met: Set<Int>, today: Int?) {
        guard met != marked.met || today != marked.today else { return }
        marked = (met, today)
        scene.hold(seats: [], met: met, today: today)
        view?.setNeedsDisplay()
    }

    /// The step token the still path was last stood for.
    private var lastSteps: Int?

    /// SwiftUI asked the layer to update. The walker is stood again only when
    /// something that moves him changed — the motion setting, or a step — so a
    /// line of words changing above the climb never re-stands a still climb
    /// (the still path's proof is that it is stood once per touch).
    func update(reduceMotion on: Bool, steps: Int, on view: SCNView) {
        let changed = on != reduceMotion || steps != lastSteps
        lastSteps = steps
        guard changed || standsApplied == 0 else { return }
        setReduceMotion(on, on: view)
    }

    /// The still path: stood once and drawn once, and then nothing happens
    /// until a touch moves him.
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
            if standsApplied == 0 { stand() }
            view.isPlaying = true
            view.rendersContinuously = true
        }
    }

    func stand() {
        let now = Date().timeIntervalSinceReferenceDate
        let dt = lastStand.map { max(0, min(0.1, now - $0)) } ?? 0
        lastStand = now
        let f = climb.value(at: now)
        let ring = WorldClimb.nearestRing(atFraction: f)

        // Design's turn: `yaw += (tYaw - yaw) * 0.06`, as the exponential it is.
        let settle = RoomApproach.tau(ratePerFrame: RoomApproach.climbRatePerFrame)
        gestures.yaw = reduceMotion ? climb.yawTarget
            : ClimbLights.follow(gestures.yaw, toward: climb.yawTarget, dt: dt, tau: settle)
        // Ring 3 scatters under the moving finger and gathers in stillness.
        let chased = climb.touching && climb.moving && ring == 3
        gestures.agitation = ClimbLights.follow(
            gestures.agitation, toward: chased ? 1 : 0, dt: dt,
            tau: chased ? ClimbLights.scatterRise : ClimbLights.scatterSettle)
        // Ring 8's three glide into one while he holds.
        let holding = climb.touching && ring == 8
        gestures.union = ClimbLights.follow(
            gestures.union, toward: holding ? 1 : 0, dt: dt,
            tau: holding ? ClimbLights.unionRise : ClimbLights.unionSettle)
        gestures.follow = climb.follow
        standTheWholeMechanisms(ring: ring, now: now, dt: dt)
        if let flight = climb.flight {
            gestures.flight = .init(kp: flight.kp,
                                    progress: reduceMotion ? 1
                                        : ClimbFlight.progress(since: flight.since, now: now))
        } else {
            gestures.flight = nil
        }

        scene.gestures = gestures
        scene.stand(atFraction: f, at: now - epoch)
        standsApplied += 1
    }

    /// Wave 6 · the Ring Worlds mechanisms not yet reborn (`RingMechanisms.swift`):
    /// rings 1, 4 and 5 answer a still hand, Ring 2 follows the sun, and
    /// Ring 8's other two lights collapse into the one he flies into.
    private func standTheWholeMechanisms(ring: Int, now: TimeInterval, dt: Double) {
        let stillHand = climb.touching && !climb.moving
        func answer(_ value: Double, _ on: Bool) -> Double {
            ClimbLights.follow(value, toward: on ? 1 : 0, dt: dt,
                               tau: on ? ClimbLights.stillHandRise : ClimbLights.stillHandSettle)
        }
        gestures.settle = answer(gestures.settle, stillHand && ring == 1)
        gestures.overflow = answer(gestures.overflow, stillHand && ring == 5)
        let teaching = stillHand && ring == 4
        gestures.lineageGlow = answer(gestures.lineageGlow, teaching)
        if teaching { gestures.lineage += dt / ClimbLights.lineageSecondsPerSeat }
        if now - lotusReadAt > 60 {
            lotusReadAt = now
            let date = Date()
            let sun = Panchanga.sunTimes(on: date, place: TemporalPlace.current(at: date))
            lotusOpenness = LotusSun.openness(at: date, sun: sun)
        }
        gestures.lotus = lotusOpenness
        if let flight = climb.flight, KhadgamalaMap.ringNumber(forKhadgamala: flight.kp) == 8 {
            gestures.collapseInto = flight.kp
            gestures.collapse = reduceMotion ? 1
                : min(1, ClimbFlight.progress(since: flight.since, now: now) * 2)
        } else {
            gestures.collapseInto = nil
            gestures.collapse = 0
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !reduceMotion else { return }
        stand()
    }

    // MARK: - Questions only the renderer can answer (main thread)

    /// The lights near where he stands, as screen points.
    @MainActor
    private func projected() -> [(kp: Int, x: Double, y: Double, depth: Double)] {
        guard let view else { return [] }
        let f = climb.value()
        return scene.lightPoints(nearFraction: f).map { entry in
            let p = view.projectPoint(SCNVector3(Float(entry.position.x),
                                                 Float(entry.position.y),
                                                 Float(entry.position.z)))
            return (kp: entry.kp, x: Double(p.x), y: Double(p.y), depth: Double(p.z))
        }
    }

    /// The light under a finger, if any.
    @MainActor
    func pick(at point: CGPoint) -> Int? {
        ClimbLights.picked(from: projected(), atX: Double(point.x), y: Double(point.y))
    }

    /// The light nearest the middle of the glass, within reach of it.
    @MainActor
    func nearest() -> Int? {
        guard let view else { return nil }
        let cx = Double(view.bounds.midX), cy = Double(view.bounds.midY)
        let reach = Double(min(view.bounds.width, view.bounds.height)) * 0.35
        return ClimbLights.picked(from: projected(), atX: cx, y: cy, reach: reach)
    }

    /// Ring 6: carry the moving light to where the finger is, at the depth of
    /// her ring.
    @MainActor
    func follow(at point: CGPoint) {
        guard let view else { return }
        let centre = ClimbLights.position(kp: KhadgamalaMap.ringStartOffset(6) + 1)
        let anchor = view.projectPoint(SCNVector3(0, Float(centre.y), Float(ClimbLights.ringCentreZ)))
        let w = view.unprojectPoint(SCNVector3(Float(point.x), Float(point.y), anchor.z))
        climb.follow = SIMD3(Double(w.x), Double(w.y), Double(w.z))
    }

    /// Ring 6: the name the moving light has reached.
    @MainActor
    func whispered(at point: CGPoint) -> Int? {
        let points = projected().map { (kp: $0.kp, x: $0.x, y: $0.y) }
        return ClimbLights.whispered(from: points, lightX: Double(point.x), lightY: Double(point.y))
    }
}
