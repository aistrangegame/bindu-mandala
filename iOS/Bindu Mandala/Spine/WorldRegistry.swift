import SwiftUI

// MARK: - Upgrade U1 · A · the World Registry
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Being there" #2 (the station
// ring), §1 "The spine in every world", §2 J #71 (one World registry) and §5
// (Doors); colours from `waves/upgrade/worlds/visual.md` §1.3, §1.9 and §1.10.
// Every world, once: its display name, its place in the constellation, the
// colour a crossing into it blooms in, the threads whose doors reach it, the
// crossing it is entered by from Home, and the builder that draws it. U1
// registers a placeholder builder for every world (its name and the point), so
// the walk can reach all fifteen today; U2 registers the real views.

/// One of the three threads every world stands on (`spine-and-home.md` §2 E #47).
enum WorldThread: String, Codable, CaseIterable {
    /// Her position, kp 1–102 (gold #C9963F).
    case kp
    /// The chakra on the Road, 1–33 (#D62F29).
    case chakra
    /// The day (cream #F2E8D9).
    case day
}

/// One world in the registry — `spine-and-home.md` §2 J #71.
struct WorldEntry: Equatable {

    /// Where a world stands round the point — `spine-and-home.md` §1 "Being
    /// there" #2: the fourteen other worlds on r ≈ 148 pt, Today at 12 o'clock,
    /// then clockwise. The Constellation (§2 D #40) lays the fifteen out as
    /// Home's own ring, so this one place serves both.
    enum Station: Equatable {
        /// Home: the point itself.
        case centre
        /// The n-th station clockwise from 12 o'clock (Today is 0).
        case ring(Int)

        /// §1 #2: r ≈ 148 pt.
        static let radius: Double = 148
        /// Fourteen stations round the point.
        static let count = 14

        /// Clockwise from 12 o'clock, in degrees.
        var degrees: Double {
            switch self {
            case .centre:      return 0
            case .ring(let i): return Double(i) * 360 / Double(Self.count)
            }
        }

        /// Offset from the point in pt (y grows downward, as on screen).
        var offset: CGPoint {
            switch self {
            case .centre:
                return .zero
            case .ring:
                let a = degrees * .pi / 180
                return CGPoint(x: Self.radius * sin(a), y: -Self.radius * cos(a))
            }
        }

        var index: Int? {
            if case .ring(let i) = self { return i }
            return nil
        }
    }

    /// Which world file a colour was read from, so a test can find it there.
    struct Source: Equatable {
        /// File under `waves/upgrade/worlds/`.
        let file: String
        let section: String
    }

    let id: WorldID
    /// The name beneath its station (11 pt, §1 #2). The voice hears `id.title`.
    let displayName: String
    let station: Station
    /// The colour a crossing into this world blooms in (§2 H #55) and the
    /// point takes as it arrives (§2 C #37). U2 may refine per address through
    /// `Router.colourResolver` (her accent in Today, the room's hex in the 33).
    let essenceHex: String
    let colourSource: Source
    /// The threads whose doors reach this world (§5 "thread doors that reach it").
    let threads: Set<WorldThread>
    /// Positions a kp door may carry here, when not the whole garland
    /// (the Relationship Field: kp 31 / 40 / 42, §5).
    let kpDoors: Set<Int>?
    /// How it is entered from Home (§5 "from Home (station → crossing)").
    let arrival: Crossing.Kind

    var color: Color { Color(hex: essenceHex) }

    /// The plain address of this world, carrying whichever threads are given.
    func address(kp: Int? = nil, chakra: Int? = nil, day: Address.Day? = nil, sub: String? = nil) -> Address {
        Address(id, kp: kp, chakra: chakra, day: day, sub: sub)
    }

    /// Does a door on this thread, carrying this value, reach this world?
    func hasDoor(_ thread: WorldThread, kp: Int? = nil) -> Bool {
        guard threads.contains(thread) else { return false }
        if thread == .kp, let kp, let allowed = kpDoors { return allowed.contains(kp) }
        return true
    }
}

/// The fifteen worlds, each once — `spine-and-home.md` §2 J #71.
enum WorldRegistry {

    /// Every world, in `WorldID` order.
    static let entries: [WorldEntry] = WorldID.allCases.map { WorldRegistry.entry($0) }

    /// The fourteen stations round the point, clockwise from Today.
    static var stations: [WorldEntry] {
        entries.compactMap { e in e.station.index.map { (i: $0, e: e) } }
            .sorted { $0.i < $1.i }
            .map { $0.e }
    }

    /// The registry row of a world. Total: a new `WorldID` case fails to
    /// compile until it is given its row here.
    static func entry(_ id: WorldID) -> WorldEntry {
        let visual = "visual.md"
        switch id {
        case .home:
            return WorldEntry(id: id, displayName: "the Bindu", station: .centre,
                              essenceHex: "#C0392B", colourSource: .init(file: visual, section: "§1.4.1 / §1.10 the point at centre"),
                              threads: [], kpDoors: nil, arrival: .bloom)
        case .today:
            return WorldEntry(id: id, displayName: "Today", station: .ring(0),
                              essenceHex: "#C9813A", colourSource: .init(file: visual, section: "§1.9 depth .25 / §1.10 Today"),
                              threads: [.day, .kp], kpDoors: nil, arrival: .blink)
        case .herPresence:
            return WorldEntry(id: id, displayName: "Her Presence", station: .ring(1),
                              essenceHex: "#C76B35", colourSource: .init(file: visual, section: "§1.9 depth .5 (§1.8 step 2)"),
                              threads: [.kp], kpDoors: nil, arrival: .bloom)
        case .herHome:
            return WorldEntry(id: id, displayName: "Her Home", station: .ring(2),
                              essenceHex: "#C45430", colourSource: .init(file: visual, section: "§1.9 depth .75 (§1.8 step 3)"),
                              threads: [.kp], kpDoors: nil, arrival: .pulseGate)
        case .mandala:
            return WorldEntry(id: id, displayName: "the Mandala", station: .ring(3),
                              essenceHex: "#C9963F", colourSource: .init(file: visual, section: "§1.4.3 yantra strokes gold"),
                              threads: [.kp], kpDoors: nil, arrival: .spanda)
        case .rings:
            return WorldEntry(id: id, displayName: "the Nine Rings", station: .ring(4),
                              essenceHex: "#CE9546", colourSource: .init(file: visual, section: "§1.4.4 Ring 1 amber, the first enclosure"),
                              threads: [.kp, .day], kpDoors: nil, arrival: .bloom)
        case .climb:
            return WorldEntry(id: id, displayName: "the Climb", station: .ring(5),
                              essenceHex: "#D8B658", colourSource: .init(file: visual, section: "§1.4.7 ascent sky"),
                              threads: [.kp, .chakra], kpDoors: nil, arrival: .passage)
        case .the33:
            return WorldEntry(id: id, displayName: "the 33", station: .ring(6),
                              essenceHex: "#D62F29", colourSource: .init(file: "spine-and-home.md", section: "§1 the chakra thread"),
                              threads: [.chakra], kpDoors: nil, arrival: .passage)
        case .game:
            return WorldEntry(id: id, displayName: "A Strange Game", station: .ring(7),
                              essenceHex: "#0F4A50", colourSource: .init(file: "game.md", section: "§1 ways in: cloth"),
                              threads: [.chakra], kpDoors: nil, arrival: .bloom)
        case .modes:
            return WorldEntry(id: id, displayName: "the Modes", station: .ring(8),
                              essenceHex: "#D46453", colourSource: .init(file: visual, section: "§1.4.10 field voice coral"),
                              threads: [], kpDoors: nil, arrival: .bloom)
        case .time:
            return WorldEntry(id: id, displayName: "Time", station: .ring(9),
                              essenceHex: "#F2E8D9", colourSource: .init(file: "spine-and-home.md", section: "§1 the day thread"),
                              threads: [.day], kpDoors: nil, arrival: .bloom)
        case .memory:
            return WorldEntry(id: id, displayName: "Memory", station: .ring(10),
                              essenceHex: "#BE5A4E", colourSource: .init(file: visual, section: "§1.10 Memory spark"),
                              threads: [.day], kpDoors: nil, arrival: .bloom)
        case .well:
            return WorldEntry(id: id, displayName: "the Well", station: .ring(11),
                              essenceHex: "#F3B05A", colourSource: .init(file: visual, section: "§1.10 Well ember"),
                              threads: [.day], kpDoors: nil, arrival: .descent)
        case .beneath:
            return WorldEntry(id: id, displayName: "Beneath", station: .ring(12),
                              essenceHex: "#7A2F14", colourSource: .init(file: visual, section: "§1.10 Beneath ember"),
                              threads: [], kpDoors: nil, arrival: .descent)
        case .relationship:
            return WorldEntry(id: id, displayName: "the Relationship Field", station: .ring(13),
                              essenceHex: "#F9E3A7", colourSource: .init(file: visual, section: "§1.10 walked gold"),
                              threads: [.kp], kpDoors: [31, 40, 42], arrival: .bloom)
        }
    }

    // MARK: Doors along the threads (§2 E #47)

    /// The worlds a door for her position reaches, in station order.
    static func doors(kp: Int) -> [Address] {
        guard Address.kpRange.contains(kp) else { return [] }
        return stations.filter { $0.hasDoor(.kp, kp: kp) }.map { $0.address(kp: kp) }
    }

    /// The worlds a door for a chakra reaches, in station order.
    static func doors(chakra: Int) -> [Address] {
        guard Address.chakraRange.contains(chakra) else { return [] }
        return stations.filter { $0.hasDoor(.chakra) }.map { $0.address(chakra: chakra) }
    }

    /// The worlds a door for a day reaches, in station order.
    static func doors(day: Address.Day) -> [Address] {
        stations.filter { $0.hasDoor(.day) }.map { $0.address(day: day) }
    }
}

// MARK: - The builders

/// Each world's builder closure (`spine-and-home.md` §2 J #71). U1 registers
/// none, so every world draws as its placeholder (its name and the point);
/// U2 calls `register` with the real view for each world.
@MainActor
enum WorldBuilders {

    private static var registered: [WorldID: (Address) -> AnyView] = [:]

    /// Give a world its real view.
    static func register(_ world: WorldID, _ build: @escaping (Address) -> AnyView) {
        registered[world] = build
    }

    /// Back to the placeholder (tests).
    static func unregister(_ world: WorldID) {
        registered[world] = nil
    }

    static func isPlaceholder(_ world: WorldID) -> Bool { registered[world] == nil }

    /// The one view for an address.
    static func view(for address: Address) -> AnyView {
        if let build = registered[address.world] { return build(address) }
        return AnyView(WorldPlaceholder(address: address))
    }

    // MARK: U2 · the launch ceremony

    /// U2 · The ceremony every launch passes through before Home stands
    /// (`spine-and-home.md` §1 "Arriving": the Waking → the Homecoming). Part A
    /// registers it; until it does, the shell plays the existing
    /// `HomecomingView`, so nothing that greets him today is lost. The closure
    /// is handed `done`, which it calls once the ceremony has given way to Home.
    private(set) static var launchCeremony: ((_ done: @escaping () -> Void) -> AnyView)?

    /// Give the launch its ceremony (Part A).
    static func registerLaunch(_ build: @escaping (_ done: @escaping () -> Void) -> AnyView) {
        launchCeremony = build
    }
}

// MARK: - U2 · where the worlds are registered

/// U2 · The one moment every world is given its view: `SpineWorlds.registerAll()`,
/// called once by the app before the root first draws (`BinduMandalaApp.init`).
///
/// The parts that build worlds hook in **without touching this file** — each
/// declares its own member on `SpineWorlds` in its own folder, and that member
/// shadows the empty default below:
///
/// ```swift
/// // Home/ (Part A)
/// extension SpineWorlds {
///     static func registerHome() {
///         WorldBuilders.register(.home) { AnyView(HomeWorld(address: $0)) }
///         WorldBuilders.registerLaunch { done in AnyView(TheWaking(onDone: done)) }   // optional
///     }
/// }
/// // Worlds/ (Part C)
/// extension SpineWorlds {
///     static func registerHostedWorlds() {
///         WorldBuilders.register(.today) { AnyView(TodayWorld(address: $0)) }
///         …
///     }
/// }
/// ```
///
/// A world nobody registers draws as its `WorldPlaceholder` (its name, its
/// doors, the way back), so the root works whether or not a part has landed.
@MainActor
protocol SpineWorldsRegistering {}

extension SpineWorldsRegistering {
    /// Part A's hook (Home, `.home`). Empty until Part A declares its own.
    static func registerHome() {}
    /// Part C's hook (every other world). Empty until Part C declares its own.
    static func registerHostedWorlds() {}
}

/// U2 · The worlds' registration point — see `SpineWorldsRegistering`.
@MainActor
enum SpineWorlds: SpineWorldsRegistering {

    private static var done = false

    /// Register every world once. Idempotent.
    static func registerAll() {
        guard !done else { return }
        done = true
        registerHome()
        registerHostedWorlds()
    }
}
