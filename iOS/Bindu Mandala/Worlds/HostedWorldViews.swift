import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · C · the worlds hosted with what exists today
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C 2. Worlds whose full
// redesign comes later (U3–U11) stand here with **the content that exists
// today, each in its own space** — never laid over another world. Every
// leaving word inside them routes to `router.back()` (`spine-and-home.md` §2 G
// #53); the point and the menu are the spine's (Part B).

// MARK: Today · the Rite

/// Today — the existing Daily Rite. Its doors to her room, the low-state door
/// and the hour's mode cross through the Router (`DailyRiteView`).
struct TodayWorld: View {
    let address: Address

    var body: some View {
        HostedWorld(address: address) {
            DailyRiteView()
        }
    }
}

// MARK: The Climb

/// The Climb — the existing climb (`WorldClimbView`), full screen, standing in
/// the ring its address names (or today's ring). Her lights cross to her room
/// in Her Home; its body chakras cross to their rooms in the 33; the held way
/// out and the edge are `router.back()`.
struct ClimbWorld: View {
    let address: Address

    @Environment(Router.self) private var router
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    /// What each room remembers — read only as a state (has he stood here).
    @Query private var rooms: [HomeMemory]

    private var todayKp: Int { AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition() }

    /// The ring he rises from: the address's, else her ring (kp thread), else today's.
    private var ring: Int {
        if let r = WorldSub.ring(in: address.sub) { return r }
        if let kp = address.kp { return KhadgamalaMap.ringNumber(forKhadgamala: kp) }
        return KhadgamalaMap.ringNumber(forKhadgamala: todayKp)
    }

    var body: some View {
        HostedWorld(address: address, doors: false) {
            WorldClimbView(live: live,
                           seats: seats,
                           met: met,
                           todayKp: todayKp,
                           startingAtRing: ring,
                           forceReduceMotion: AppRuntime.forcesReduceMotion,
                           onLeft: { _ = router.back() })
                .id(ring)
        }
    }

    private var live: [Int: HomeWorlds.LiveFacts] {
        var out: [Int: HomeWorlds.LiveFacts] = [:]
        for a in avaranas { out[a.ringNumber] = HomeWorlds.liveFacts(from: a) }
        return out
    }

    private var seats: [ClimbLights.Seat] {
        var byKp: [Int: Shakti] = [:]
        for s in shaktis { if let kp = s.khadgamalaPosition { byKp[kp] = s } }
        return (1...KhadgamalaMap.total).map { kp in
            ClimbLights.Seat(kp: kp, name: byKp[kp]?.name ?? "", quality: byKp[kp]?.quality ?? "")
        }
    }

    /// A state, never a count: the Śaktis he has felt or stood with carry
    /// their core light.
    private var met: Set<Int> {
        let felt = Set(shaktis.filter { $0.hasBeenFelt }.compactMap { $0.khadgamalaPosition })
        let stood = Set(rooms.filter { $0.known }.map { $0.khadgamalaPosition })
        return felt.union(stood)
    }
}

// MARK: A Strange Game

/// A Strange Game — the existing play field, entered through **the Eight
/// Dissolutions** (once a practice day, his own ruling; later the same day
/// "Now go play." and then the field — `TheEightDissolutions` keeps both).
/// A game named on the address opens that game; a Leela drop opens the field.
struct GameWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    private var game: PlayGame? { address.sub.flatMap { PlayGame(rawValue: $0) } }

    var body: some View {
        HostedWorld(address: address, doors: false) {
            if let game {
                PlayGameHost(game: game, startPosition: address.kp, onClose: { _ = router.back() })
                    .id(game.rawValue)
            } else {
                TheEightDissolutions(onClose: { _ = router.back() })
            }
        }
    }
}

// MARK: The Modes

/// The Modes — the existing modes door and its list, as a world; a mode named
/// on the address opens that mode, and its end is `router.back()`.
struct ModesWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    private var mode: TheModes.Mode? { address.sub.flatMap { TheModes.Mode(rawValue: $0) } }

    var body: some View {
        HostedWorld(address: address) {
            if let mode {
                ModeHost(mode: mode, onClose: { _ = router.back() })
                    .id(mode.rawValue)
            } else {
                ModesDoorView(onClose: { _ = router.back() })
            }
        }
    }
}

// MARK: Time

/// Time — the five clocks (`ThePointView`), moved out of the Portrait.
struct TimeWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    var body: some View {
        HostedWorld(address: address) {
            ThePointView(onBack: { _ = router.back() })
        }
    }
}

// MARK: Memory

/// Memory — the Portrait and the record it opens (the river, where she
/// speaks, the book, the month). Its point door crosses to Time.
struct MemoryWorld: View {
    let address: Address

    var body: some View {
        HostedWorld(address: address) {
            PortraitMandalaView()
        }
    }
}

// MARK: The Well

/// The Well — the existing Well.
struct WellWorld: View {
    let address: Address

    var body: some View {
        HostedWorld(address: address) {
            WellView()
        }
    }
}

// MARK: Beneath

/// Beneath — the low-state door, the Shadow Translator and the river of
/// letters, gathered as one place. Each door is a place inside Beneath (its
/// sub-place), so back returns to the gathering.
struct BeneathWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    var body: some View {
        HostedWorld(address: address, doors: address.sub == nil) {
            switch address.sub {
            case WorldSub.low?:
                LowStateDoorView(onClose: { _ = router.back() })
            case WorldSub.translator?:
                PlayGameHost(game: .shadowTranslator, onClose: { _ = router.back() })
            case WorldSub.river?:
                CorrespondenceView(onBack: { _ = router.back() })
            default:
                gathering
            }
        }
    }

    private var gathering: some View {
        ZStack {
            LinearGradient(colors: [Color.silenceGround, Color(red: 0.09, green: 0.04, blue: 0.03)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            RadialGradient(colors: [WorldRegistry.entry(.beneath).color.opacity(0.22), .clear],
                           center: UnitPoint(x: 0.5, y: 1.0), startRadius: 0, endRadius: 420)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            VStack(spacing: 22) {
                Spacer()
                Text(WorldRegistry.entry(.beneath).displayName)
                    .font(AppFont.sanskrit(34))
                    .foregroundStyle(Color.cream)
                    .accessibilityAddTraits(.isHeader)
                door(LowStateDoor.doorWords, label: "I am low — your own words", sub: WorldSub.low)
                door("\(PlayGame.shadowTranslator.title) · \(PlayGame.shadowTranslator.verb)",
                     label: PlayGame.shadowTranslator.title, sub: WorldSub.translator)
                door("the river ›", label: "The river of letters", sub: WorldSub.river)
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }

    private func door(_ words: String, label: String, sub: String) -> some View {
        Button {
            Haptics.soft()
            _ = router.go(to: Address(.beneath, sub: sub), via: .dissolve)
        } label: {
            Text(words)
                .font(AppFont.voice(19))
                .foregroundStyle(Color.cream.opacity(0.78))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(label))
        .accessibilityIdentifier("beneath.\(sub)")
    }
}

// MARK: The Relationship Field

/// The Relationship Field — the three connections as a simple world, a door to
/// each Śakti (her room first): Gaia at kp 31 · Ahaṅkāra, Ashrey at kp 40 ·
/// Nāma, Ram at kp 42 · Ātmā; Bīja at kp 41, the bridge. Its full design is U11.
struct RelationshipWorld: View {
    let address: Address

    @Environment(Router.self) private var router
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    /// The connections, in the brief's own words (U2 brief Part C 2).
    struct Connection: Identifiable {
        let kp: Int
        let person: String
        let essence: String
        var id: Int { kp }
    }

    static let connections: [Connection] = [
        Connection(kp: 31, person: "Gaia", essence: "Ahaṅkāra"),
        Connection(kp: 40, person: "Ashrey", essence: "Nāma"),
        Connection(kp: 42, person: "Ram", essence: "Ātmā"),
    ]
    /// Bīja, kp 41 — the bridge between them.
    static let bridge = Connection(kp: 41, person: "Bīja", essence: "the bridge")

    var body: some View {
        HostedWorld(address: address) {
            GeometryReader { geo in
                let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.46)
                let r = min(geo.size.width, geo.size.height) * 0.30
                ZStack {
                    RadialGradient(colors: [WorldRegistry.entry(.relationship).color.opacity(0.16), .clear],
                                   center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0, endRadius: 360)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    threads(centre: c, radius: r)
                    ForEach(Array(Self.connections.enumerated()), id: \.element.id) { i, conn in
                        let a = -Double.pi / 2 + Double(i) * 2 * Double.pi / 3
                        node(conn, size: 40)
                            .position(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a)))
                    }
                    node(Self.bridge, size: 26)
                        .position(c)
                }
            }
        }
    }

    private func threads(centre c: CGPoint, radius r: CGFloat) -> some View {
        Path { p in
            for i in 0..<3 {
                let a = -Double.pi / 2 + Double(i) * 2 * Double.pi / 3
                p.move(to: c)
                p.addLine(to: CGPoint(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a))))
            }
        }
        .stroke(Color.gold.opacity(0.22), style: StrokeStyle(lineWidth: 0.6, dash: [3, 4]))
        .allowsHitTesting(false)
    }

    private func node(_ conn: Connection, size: CGFloat) -> some View {
        let name = shaktis.first { $0.khadgamalaPosition == conn.kp }?.name ?? ""
        return Button {
            Haptics.light()
            WorldDoors.herHome(conn.kp, router: router)
        } label: {
            VStack(spacing: 6) {
                Circle()
                    .fill(RadialGradient(colors: [Color.cream, WorldRegistry.entry(.relationship).color.opacity(0.7), .clear],
                                         center: .center, startRadius: 0, endRadius: size / 2))
                    .frame(width: size, height: size)
                Text(conn.person)
                    .font(AppFont.sanskrit(20))
                    .foregroundStyle(Color.cream)
                Text(conn.essence)
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.7))
                if !name.isEmpty {
                    Text(name)
                        .font(AppFont.label(11))
                        .tracking(1.4)
                        .foregroundStyle(Color.gold.opacity(0.75))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(minWidth: 96, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint(Text("Opens her room."))
        .accessibilityIdentifier("relationship.kp.\(conn.kp)")
    }
}
