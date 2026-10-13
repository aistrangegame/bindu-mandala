import SwiftUI
import SwiftData

// MARK: - Upgrade U1 · A / U2 · B · the root the Router draws
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "The spine in every world" and
// §2 J #71: the Router at the root, one world mounted at a time (never a
// sheet or a cover over a world — V14), the crossing drawn above it, the
// point on every world.
//
// U2 · B: this is the app's root (`AppRoot` mounts it; the old `RootView`
// with its five rooms and hamburger is retired). Back to front:
//
//   1. the one mounted world (`WorldHost`) — hidden, alive and untouchable
//      while a spine place stands in its stead;
//   2. a spine place, drawn *in place of* the world (Settings #95, the
//      one-second practice #35);
//   3. the spine's chrome: the Constellation mark top-left, the point
//      top-right on every world but Home (Home's point is its centre);
//   4. the Constellation menu, above every world (#40–#46, #50);
//   5. the crossing, never hit-testable.
//
// Gestures the root hears *alongside* every world (never instead of it):
// the leading edge → back (#53), a slow pull from the top → the menu (#40),
// a fast swipe down from the top → Home (the ReturnArc, #66). Esc → back.
//
// What `RootView` did and where it went (U2 · B report):
//   • seed / backfill / summons / sync / the gift's fortnight → `SpineServices.bootstrap`
//   • a gift that opened the app → `GiftRouter` → `Router.giftOpened` (Home, her card)
//   • Recognition → Memory (now from every source) → `Router.recognitionSettled`
//   • Lalitā's field's way to the Road → `Router.askWay`
//   • `.playFieldPresenter()` → `PlayField.open` → `Router.openPlay` (A Strange Game)
//   • `.leelaDrops()` → `SpineServices.considerLeela` → `Router.leelaDropped` (a place in A Strange Game)
//   • Settings' sheet → a spine place (`Router.open(place: .settings)`)
//   • the hamburger and its five-room veil → the Constellation (`ConstellationMenu`)
//   • `last_destination(_day)` → retired; where he was is the journey (`NavigationState`)

/// The root of the fifteen worlds — `spine-and-home.md` §2 J #71.
@MainActor
struct SpineRoot: View {
    @State private var router: Router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    /// How far a slow pull from the top has travelled (0 at rest).
    @State private var pull: CGFloat = 0

    init(router: Router = .shared) {
        // Every world is given its view before the root first draws (Home by
        // Part A, the hosted worlds by Part C — `SpineWorlds`). Idempotent.
        SpineWorlds.registerAll()
        _router = State(initialValue: router)
    }

    /// While the menu or a spine place stands, the world is held, untouched.
    private var worldIsHeld: Bool { router.menuFace != nil || router.place != nil }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.silenceGround.ignoresSafeArea()

                // 1 · the one world
                TimelineView(.animation(minimumInterval: nil, paused: router.inFlight == nil)) { ctx in
                    WorldHost(address: router.mounted)
                        .id(router.mounted.world)
                        .scaleEffect(gather(at: ctx.date), anchor: gatherAnchor(in: geo.size))
                }
                .opacity(router.place == nil ? Double(1 - SpineGesture.dim(forPull: pull)) : 0)
                .allowsHitTesting(!worldIsHeld)
                .accessibilityHidden(worldIsHeld)

                // 2 · a spine place, in the world's stead
                if let place = router.place {
                    SpinePlaceView(place: place)
                        .transition(.opacity)
                }

                // 3 · the chrome every world carries
                if router.menuFace == nil {
                    SpineChrome(world: router.mounted.world, size: geo.size)
                }

                // 4 · the menu, above every world
                if router.menuFace != nil {
                    ConstellationMenu()
                        .transition(.opacity)
                        .zIndex(10)
                }

                // 5 · the crossing
                if let flight = router.inFlight {
                    CrossingOverlay(flight: flight)
                        .ignoresSafeArea()
                        .zIndex(20)
                }

                SpineEscape { _ = router.back() }
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.4), value: router.menuFace)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.4), value: router.place)
            .simultaneousGesture(spineGesture(in: geo))
        }
        .environment(router)
        .soundWakesOnFirstTouch()
        .accessibilityAction(.escape) { _ = router.back() }
        .onAppear {
            router.reduceMotion = reduceMotion
            router.onWorldCrossed = { from, to in
                SpineServices.worldCrossed(from: from, to: to, context: context)
            }
            SpineServices.landAnyGift(router: router)
        }
        .onChange(of: reduceMotion) { _, now in router.reduceMotion = now }
        .onChange(of: router.mounted, initial: true) { _, now in
            SpineServices.arrived(at: now)
        }
        .onOpenURL { url in _ = router.open(url) }
        .task {
            await SpineServices.bootstrap(context: context, router: router)
        }
        // Leela drops: a breath after he arrives at Home (§2 J #74).
        .task(id: LeelaWatch(world: router.mounted.world, active: scenePhase == .active)) {
            await SpineServices.considerLeela(router: router, active: scenePhase == .active)
        }
    }

    // MARK: The gestures heard alongside every world

    private func spineGesture(in geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 12, coordinateSpace: .global)
            .onChanged { v in
                let next = SpineGesture.pullDistance(start: v.startLocation, translation: v.translation,
                                                     safeTop: geo.safeAreaInsets.top)
                if next != pull, router.menuFace == nil, router.place == nil { pull = next }
            }
            .onEnded { v in
                defer { pull = 0 }
                guard router.inFlight == nil else { return }
                let intent = SpineGesture.intent(start: v.startLocation, translation: v.translation,
                                                 predictedEnd: v.predictedEndTranslation,
                                                 safeTop: geo.safeAreaInsets.top)
                switch intent {
                case .back:
                    _ = router.backFromEdge(origin: v.location)
                case .menu:
                    if router.menuFace == nil, router.place == nil { router.openMenu() }
                case .home:
                    if router.menuFace == nil, router.state.current.place != Address.home {
                        _ = router.home(via: .bloom(from: v.location))
                    }
                case .none:
                    break
                }
            }
    }

    /// #55 · the gather: the world he leaves draws toward the point (×.96)
    /// over the first .30 s, until the destination is mounted.
    private func gather(at date: Date) -> CGFloat {
        guard let f = router.inFlight, f.timing.gather > 0, router.mounted.place == f.from.place else { return 1 }
        let p = min(1, f.elapsed(at: date) / f.timing.gather)
        return CGFloat(1 - (1 - Crossing.gatherScale) * p)
    }

    private func gatherAnchor(in size: CGSize) -> UnitPoint {
        guard let o = router.inFlight?.crossing.origin, size.width > 0, size.height > 0 else {
            return UnitPoint(x: 0.5, y: 0.46)
        }
        return UnitPoint(x: o.x / size.width, y: o.y / size.height)
    }
}

/// The `.task(id:)` key for the Leela watch: which world, and whether the
/// scene is in front of him.
private struct LeelaWatch: Equatable {
    let world: WorldID
    let active: Bool
}

/// The root's gestures, as pure geometry — so `U2SpineTests` can hold them.
/// `spine-and-home.md` §2 D #40 (the slow pull: follows pull/120·10 pt, the
/// world dims 1 − pull/120·.35, opens past 84 pt), G #53 (the edge: leading
/// 22 pt, travel 72 pt) and I #66 (the ReturnArc: a fast swipe down from the
/// top, > 600 pt/s, → Home).
enum SpineGesture {

    enum Intent: Equatable { case none, back, menu, home }

    /// G #53: the edge is the leading 22 pt …
    static let edgeWidth: CGFloat = 22
    /// … and a way out once the finger has travelled 72 pt.
    static let edgeTravel: CGFloat = 72
    /// D #40: the pull opens the menu past 84 pt …
    static let pullOpens: CGFloat = 84
    /// … and dims the world by up to .35 over 120 pt.
    static let pullSpan: CGFloat = 120
    static let pullDimMax: CGFloat = 0.35
    /// I #66: faster than 600 pt/s is the ReturnArc's swipe, not the pull.
    static let fastSwipe: CGFloat = 600
    /// The band below the status bar a pull or the ReturnArc starts in (pt
    /// below the safe top). U2's reading of "a slow pull anywhere": the pull
    /// starts near the top, so a world's own scrolling is never taken for it.
    static let topBand: CGFloat = 140
    /// DragGesture predicts the end ~0.25 s ahead; its lead over the actual
    /// translation is the swipe's speed × that horizon.
    static let predictionHorizon: CGFloat = 0.25

    static func startsAtTop(_ start: CGPoint, safeTop: CGFloat) -> Bool {
        start.y >= safeTop && start.y <= safeTop + topBand
    }

    /// The pull as the menu sees it while the finger moves (0 when it is not one).
    static func pullDistance(start: CGPoint, translation: CGSize, safeTop: CGFloat) -> CGFloat {
        guard startsAtTop(start, safeTop: safeTop),
              translation.height > 0,
              abs(translation.width) < translation.height else { return 0 }
        return translation.height
    }

    /// The world dims as he pulls: 1 − pull/120·.35 → this returns the .35 part.
    static func dim(forPull pull: CGFloat) -> CGFloat {
        guard pull > 0 else { return 0 }
        return min(1, pull / pullSpan) * pullDimMax
    }

    /// What a finished drag meant.
    static func intent(start: CGPoint, translation: CGSize, predictedEnd: CGSize, safeTop: CGFloat) -> Intent {
        let dx = translation.width, dy = translation.height
        if start.x <= edgeWidth, dx >= edgeTravel, abs(dy) < dx {
            return .back
        }
        if startsAtTop(start, safeTop: safeTop), dy > 0, abs(dx) < dy {
            let speed = max(0, predictedEnd.height - dy) / predictionHorizon
            if speed > fastSwipe, dy >= 40 { return .home }
            if dy >= pullOpens { return .menu }
        }
        return .none
    }
}

/// Esc on a hardware keyboard: back, everywhere (§2 G #53).
private struct SpineEscape: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) { Color.clear }
            .keyboardShortcut(.escape, modifiers: [])
            .frame(width: 1, height: 1)
            .opacity(0.001)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

/// The one world view for an address (its registered builder, or its placeholder).
/// A Leela drop is the spine's own place in A Strange Game (§2 J #74): the
/// game's builder never sees a `leela.*` sub-place.
@MainActor
struct WorldHost: View {
    let address: Address

    var body: some View {
        if let id = address.leelaDropID {
            LeelaDropPlace(dropID: id)
        } else {
            WorldBuilders.view(for: address)
        }
    }
}

// MARK: - A spine place, in the world's stead

/// Settings (#95) and the one-second practice (#35), drawn in place of the
/// world. Leaving is `closePlace()` — the world beneath returns as it was.
@MainActor
struct SpinePlaceView: View {
    let place: Router.SpinePlace
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            switch place {
            case .settings:
                SettingsView()
            case .oneSecond:
                OneSecondFloorView(isPresented: Binding(
                    get: { router.place == .oneSecond },
                    set: { if !$0 { router.closePlace() } }))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("spine.place.\(place.rawValue)")
    }
}

// MARK: - A Leela drop, as a place

/// The drop, in A Strange Game, its own space (§2 J #74; `Services/LeelaDrops.swift`).
/// Answering it — carried, or held in silence — writes its one ledger row and
/// returns him to where it found him.
@MainActor
struct LeelaDropPlace: View {
    let dropID: String
    @Environment(Router.self) private var router

    private var drop: LeelaDrop? {
        GameStructure.leelaDrops.first { $0.id == dropID }
    }

    var body: some View {
        Group {
            if let d = drop {
                LeelaDropView(drop: d, onAnswer: { carried in
                    SpineServices.answerLeela(d, carried: carried)
                    _ = router.back()
                })
            } else {
                Color.silenceGround.ignoresSafeArea()
                    .onAppear { _ = router.back() }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(WorldID.game.sentinel)
    }
}

// MARK: - U1's placeholder world

/// What every world shows until its part builds it: its name, its colour,
/// its doors along the threads it stands on, and a way back — enough for the
/// walk to reach and leave each of the fifteen. Carries the world's sentinel
/// `world.<id>` (V11, V14). The point is the spine's (`SpineChrome`), never
/// drawn here a second time.
@MainActor
struct WorldPlaceholder: View {
    let address: Address
    @Environment(Router.self) private var router

    private var entry: WorldEntry { WorldRegistry.entry(address.world) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ground
                if address.world == .home {
                    stationRing(in: geo.size)
                } else {
                    VStack(spacing: 12) {
                        Text(entry.displayName)
                            .font(AppFont.sanskrit(34))
                            .foregroundStyle(Color.cream)
                            .multilineTextAlignment(.center)
                            .accessibilityIdentifier("place." + DeepLink.url(for: address).absoluteString)
                        Text(WorldPlaceholder.notYet)
                            .font(AppFont.voice(17))
                            .foregroundStyle(Color.cream.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.40)
                    VStack {
                        Spacer()
                        ThreadDoors(address: address)
                            .padding(.bottom, 84)
                    }
                    leaving
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(address.world.sentinel)
    }

    /// Design's words for a world not yet composed (§2 D #40).
    static let notYet = "this has not yet been composed"

    private var ground: some View {
        ZStack {
            Color.silenceGround
            RadialGradient(colors: [entry.color.opacity(address.world == .home ? 0 : 0.18), .clear],
                           center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0, endRadius: 420)
        }
        .ignoresSafeArea()
    }

    /// Home: the point at the centre and the fourteen stations round it
    /// (§1 "Being there" #2). A placeholder crosses on one tap; Part A's Home
    /// gives the station its card first (two taps, never one).
    private func stationRing(in size: CGSize) -> some View {
        let centre = CGPoint(x: size.width / 2, y: size.height * 0.46)
        return ZStack {
            ThePoint(look: PointLook.forWorld(.home), light: .always, label: "Home, the point",
                     onTap: nil, onHold: nil)
                .position(centre)
                .accessibilityHidden(true)
            Color.clear
                .frame(width: 44, height: 44)
                .contentShape(Circle())
                .position(centre)
                .accessibilityElement()
                .accessibilityLabel(Text("Home, the point"))
                .accessibilityIdentifier("point.home")
            ForEach(WorldRegistry.stations, id: \.id) { station in
                let at = CGPoint(x: centre.x + station.station.offset.x, y: centre.y + station.station.offset.y)
                Button {
                    _ = router.go(to: station.address(), via: Crossing(kind: station.arrival, origin: at))
                } label: {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(station.color)
                            .frame(width: 11, height: 11)
                        Text(station.displayName)
                            .font(AppFont.label(11))
                            .foregroundStyle(Color.cream.opacity(0.8))
                            .fixedSize()
                    }
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(station.id.title))
                .accessibilityIdentifier("station.\(station.id.rawValue)")
                .position(at)
            }
        }
    }

    /// The world's own word for leaving, routed to `back()` (§2 G #53).
    private var leaving: some View {
        VStack {
            Spacer()
            HStack {
                Button { _ = router.back() } label: {
                    Text("return")
                        .font(AppFont.label(12))
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .frame(minWidth: 44, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("spine.back")
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.bottom, 24)
        }
    }
}
