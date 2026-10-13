import Foundation

// MARK: - Upgrade U1 · A · the journey (one source of truth)
//
// `waves/upgrade/worlds/spine-and-home.md` §2 G #51: every crossing pushes an
// entry; back pops to that exact place; depth unbounded but one home and one
// back. Saved to the practice vault as `journey` (§4 "On the phone": "the back
// stack and the per-world last entries that become Road Home beads"). Across a
// relaunch, launch still arrives at Home (ruling 1) and each world's last entry
// becomes a Road Home bead ("You were partway down").

/// Where he is, and the way back — `spine-and-home.md` §2 G #51 and §4.
struct NavigationState: Codable, Equatable {

    /// One step of the journey: the exact address he left, and when.
    struct Entry: Codable, Equatable {
        var address: Address
        var at: Date
    }

    /// Where he stands now.
    var current: Address
    /// The way back, oldest first; `back()` takes the last.
    var backStack: [Entry]
    /// The last address he stood at in each world (by `WorldID` raw value) —
    /// the Road Home's beads (§1 "Being there" #6, §2 B #15).
    var lastByWorld: [String: Address]
    /// Where he stood when the instrument was last closed (a relaunch arrives
    /// at Home, ruling 1; this is where "partway down" points).
    var before: Address?

    init(current: Address = .home,
         backStack: [Entry] = [],
         lastByWorld: [String: Address] = [:],
         before: Address? = nil) {
        self.current = current
        self.backStack = backStack
        self.lastByWorld = lastByWorld
        self.before = before
    }

    /// Leave `address` for somewhere else: it goes on the way back, and is the
    /// last place in its world.
    mutating func push(_ address: Address, at: Date) {
        backStack.append(Entry(address: address, at: at))
        remember(address)
    }

    /// The way back's last step, taken.
    mutating func pop() -> Entry? {
        backStack.popLast()
    }

    /// Keep `address` as the last place in its world (Home keeps no bead).
    mutating func remember(_ address: Address) {
        guard address.world != .home else { return }
        lastByWorld[address.world.rawValue] = address
    }

    /// The Road Home's beads: one per world he left partway, in station order.
    var beads: [Address] {
        WorldRegistry.stations.compactMap { lastByWorld[$0.id.rawValue] }
    }

    /// The state a new launch opens on: Home (ruling 1), the way back cleared,
    /// every world's last place kept as a bead, and where he stood kept as
    /// `before`.
    func relaunched() -> NavigationState {
        var next = NavigationState(current: .home, backStack: [], lastByWorld: lastByWorld, before: nil)
        next.remember(current)
        next.before = current.world == .home ? before : current
        return next
    }
}
