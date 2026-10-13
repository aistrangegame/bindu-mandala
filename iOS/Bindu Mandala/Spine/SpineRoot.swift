import SwiftUI

// MARK: - Upgrade U1 · A · the root the Router draws
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "The spine in every world" and
// §2 J #71: the Router at the root, one world mounted at a time (never a
// sheet or a cover over a world — V14), the crossing drawn above it, the
// point on every world. U1 mounts this only under the DEBUG `SPINE=1` launch
// (`SpineLaunch`), so the walk reaches all fifteen worlds by `OPEN_WORLD` /
// `OPEN_PLACE`; U2 makes it the app's root and gives each world its view.

/// The root of the fifteen worlds — `spine-and-home.md` §2 J #71.
struct SpineRoot: View {
    @State private var router: Router
    @State private var channelTokens: [NSObjectProtocol] = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(router: Router = .shared) {
        _router = State(initialValue: router)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.silenceGround.ignoresSafeArea()
                TimelineView(.animation(minimumInterval: nil, paused: router.inFlight == nil)) { ctx in
                    WorldHost(address: router.mounted)
                        .id(router.mounted.world)
                        .scaleEffect(gather(at: ctx.date), anchor: gatherAnchor(in: geo.size))
                }
                if let flight = router.inFlight {
                    CrossingOverlay(flight: flight)
                        .ignoresSafeArea()
                }
            }
        }
        .environment(router)
        .onAppear {
            router.reduceMotion = reduceMotion
            if channelTokens.isEmpty { channelTokens = RouterBridge.listen(router) }
        }
        .onDisappear {
            RouterBridge.stop(channelTokens)
            channelTokens = []
        }
        .onChange(of: reduceMotion) { _, now in router.reduceMotion = now }
        .onOpenURL { url in _ = router.open(url) }
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

/// The one world view for an address (its registered builder, or its placeholder).
struct WorldHost: View {
    let address: Address

    var body: some View {
        WorldBuilders.view(for: address)
    }
}

// MARK: - U1's placeholder world

/// What every world shows until U2 builds it: its name, its colour, the point,
/// and a way back — enough for the walk to reach and leave each of the
/// fifteen. Carries the world's sentinel `world.<id>` (V11, V14).
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
                        Text("this has not yet been composed")
                            .font(AppFont.voice(17))
                            .foregroundStyle(Color.cream.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.46)
                    leaving
                    PointHome()
                        .position(x: geo.size.width - 16 - 22, y: geo.safeAreaInsets.top + 16 + 22)
                }
            }
            .contentShape(Rectangle())
            .gesture(edgeWayOut)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(address.world.sentinel)
        .accessibilityAction(.escape) { _ = router.back() }
    }

    private var ground: some View {
        ZStack {
            Color.silenceGround
            RadialGradient(colors: [entry.color.opacity(address.world == .home ? 0 : 0.18), .clear],
                           center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0, endRadius: 420)
        }
        .ignoresSafeArea()
    }

    /// Home: the point at the centre and the fourteen stations round it
    /// (§1 "Being there" #2). A placeholder crosses on one tap; U2 gives the
    /// station its card first (two taps, never one).
    private func stationRing(in size: CGSize) -> some View {
        let centre = CGPoint(x: size.width / 2, y: size.height * 0.46)
        return ZStack {
            Circle()
                .fill(Color(hex: entry.essenceHex))
                .frame(width: 26, height: 26)
                .frame(width: 44, height: 44)
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

    /// The edge is a way out everywhere (§2 G #53: leading edge 22 pt, travel 72 pt).
    private var edgeWayOut: some Gesture {
        DragGesture(minimumDistance: 12)
            .onEnded { v in
                if v.startLocation.x <= 22, v.translation.width >= 72 { _ = router.back() }
            }
    }
}

/// The point on every world but Home — `spine-and-home.md` §2 C #36: 6 pt
/// #C0392B at .3, top 16 / right 16, a 44 pt target; tap → Home. (The hold →
/// the source and the double-tap → one second arrive with Part D's hold engine
/// in U2; Part C's `ThePoint` will draw it.)
struct PointHome: View {
    @Environment(Router.self) private var router
    @State private var frame: CGRect = .zero

    static let hex = "#C0392B"
    static let opacity = 0.3
    static let diameter: CGFloat = 6
    static let target: CGFloat = 44

    var body: some View {
        Button {
            _ = router.home(via: .bloom(from: CGPoint(x: frame.midX, y: frame.midY)))
        } label: {
            Circle()
                .fill(Color(hex: Self.hex).opacity(Self.opacity))
                .frame(width: Self.diameter, height: Self.diameter)
                .frame(width: Self.target, height: Self.target)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(GeometryReader { g in
            Color.clear
                .onAppear { frame = g.frame(in: .global) }
                .onChange(of: g.frame(in: .global)) { _, f in frame = f }
        })
        .accessibilityLabel(Text("Home, the point"))
        .accessibilityIdentifier("point.home")
    }
}
