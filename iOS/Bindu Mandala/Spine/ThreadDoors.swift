import SwiftUI

// MARK: - U2 · B · doors along the threads
//
// `waves/upgrade/worlds/spine-and-home.md` §2 E #47 (thread doors on every
// world: kp · chakra · day) and #48 (two neighbour doors on each thread).
// Every world stands on the threads its address carries; for each, a door to
// every other world that thread reaches (from `WorldRegistry`), and the two
// neighbours on the same thread in this world. A door is a 52 pt disc of the
// destination's own colour, ringed in this world's accent, with its kicker
// "the same {Śakti | chakra | day} · in {world}". Touching one leans the
// world toward the destination's colour (.55 over .55 s) and the crossing
// begins at 520 ms, blooming from the disc.
//
// Placed by any world: `ThreadDoors(address: address)` — Home and every
// hosted world (Part C) use the same view.

/// One door on a thread — `spine-and-home.md` §2 E #47–#48.
struct ThreadDoor: Identifiable, Equatable {
    enum Kind: Equatable {
        /// The same thread value, in another world (#47).
        case across
        /// The previous (−1) or next (+1) value on the thread, in this world (#48).
        case neighbour(Int)
    }

    let thread: WorldThread
    let kind: Kind
    let to: Address
    /// The words beside the disc (no count, no number of him).
    let kicker: String

    var id: String {
        switch kind {
        case .across:           return "door.\(to.world.rawValue).\(thread.rawValue)"
        case .neighbour(let s): return "door.\(thread.rawValue).\(s < 0 ? "previous" : "next")"
        }
    }
}

/// Which doors an address shows (pure — `U2SpineTests` holds it).
enum ThreadDoorPlan {

    /// The thread's own word in a kicker.
    static func noun(_ thread: WorldThread) -> String {
        switch thread {
        case .kp:     return "Śakti"
        case .chakra: return "chakra"
        case .day:    return "day"
        }
    }

    /// #48: kp neighbours round the garland 1 ↔ 102.
    static func neighbour(kp: Int, step: Int) -> Int {
        let n = Address.kpRange.count
        return ((kp - 1 + step) % n + n) % n + 1
    }

    /// #48: chakra neighbours along the Road 1 ↔ 33.
    static func neighbour(chakra: Int, step: Int) -> Int {
        let n = Address.chakraRange.count
        return ((chakra - 1 + step) % n + n) % n + 1
    }

    /// Every door for `address`. `todaysKP` is today's Śakti: Today is a kp
    /// door only when she is today's (#47 "Today (when hers)").
    static func doors(for address: Address, todaysKP: Int?) -> [ThreadDoor] {
        let here = WorldRegistry.entry(address.world)
        var out: [ThreadDoor] = []

        if let kp = address.kp, Address.kpRange.contains(kp) {
            for to in WorldRegistry.doors(kp: kp) where to.world != address.world {
                if to.world == .today, kp != todaysKP { continue }
                out.append(ThreadDoor(thread: .kp, kind: .across, to: to,
                                      kicker: "the same \(noun(.kp)) · in \(WorldRegistry.entry(to.world).displayName)"))
            }
            if here.threads.contains(.kp), here.kpDoors == nil {
                for step in [-1, 1] {
                    out.append(ThreadDoor(thread: .kp, kind: .neighbour(step),
                                          to: Address(address.world, kp: neighbour(kp: kp, step: step)),
                                          kicker: step < 0 ? "the Śakti before" : "the Śakti after"))
                }
            }
        }

        if let ch = address.chakra, Address.chakraRange.contains(ch) {
            for to in WorldRegistry.doors(chakra: ch) where to.world != address.world {
                out.append(ThreadDoor(thread: .chakra, kind: .across, to: to,
                                      kicker: "the same \(noun(.chakra)) · in \(WorldRegistry.entry(to.world).displayName)"))
            }
            if here.threads.contains(.chakra) {
                for step in [-1, 1] {
                    out.append(ThreadDoor(thread: .chakra, kind: .neighbour(step),
                                          to: Address(address.world, chakra: neighbour(chakra: ch, step: step)),
                                          kicker: step < 0 ? "the chakra before" : "the chakra after"))
                }
            }
        }

        if let day = address.day {
            for to in WorldRegistry.doors(day: day) where to.world != address.world {
                out.append(ThreadDoor(thread: .day, kind: .across, to: to,
                                      kicker: "the same \(noun(.day)) · in \(WorldRegistry.entry(to.world).displayName)"))
            }
            if here.threads.contains(.day) {
                for step in [-1, 1] {
                    out.append(ThreadDoor(thread: .day, kind: .neighbour(step),
                                          to: Address(address.world, day: day.adding(days: step)),
                                          kicker: step < 0 ? "the day before" : "the day after"))
                }
            }
        }
        return out
    }
}

/// The doors, drawn — `spine-and-home.md` §2 E #47–#48. Shows nothing when
/// the address stands on no thread.
@MainActor
struct ThreadDoors: View {
    let address: Address

    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// The door being walked through: the world leans toward its colour.
    @State private var leaning: ThreadDoor?

    /// #47: a 52 pt disc.
    static let disc: CGFloat = 52
    /// #47: the world leans .55 toward the destination over .55 s …
    static let lean = 0.55
    static let leanSeconds = 0.55
    /// … and the crossing begins at 520 ms.
    static let crossAt = 0.52

    private var doors: [ThreadDoor] {
        ThreadDoorPlan.doors(for: address,
                             todaysKP: AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition())
    }

    var body: some View {
        let list = doors
        if !list.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(list) { door in
                        doorView(door)
                    }
                }
                .padding(.horizontal, 20)
            }
            .background(
                (leaning.map { WorldRegistry.entry($0.to.world).color } ?? Color.clear)
                    .opacity(leaning == nil ? 0 : Self.lean * 0.3)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            )
        }
    }

    private func doorView(_ door: ThreadDoor) -> some View {
        let dest = WorldRegistry.entry(door.to.world)
        let here = WorldRegistry.entry(address.world)
        return GeometryReader { g in
            Button { walk(door, from: CGPoint(x: g.frame(in: .global).midX, y: g.frame(in: .global).minY + Self.disc / 2)) } label: {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(dest.color.opacity(0.18))
                        Circle()
                            .stroke(here.color.opacity(0.7), lineWidth: 1)
                        Circle()
                            .fill(dest.color)
                            .frame(width: 8, height: 8)
                            .shadow(color: dest.color.opacity(0.6), radius: 6)
                    }
                    .frame(width: Self.disc, height: Self.disc)
                    Text(door.kicker)
                        .font(AppFont.label(11))
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: 92)
                .contentShape(Rectangle())
                .opacity(leaning == nil || leaning == door ? 1 : 0.2)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 92, height: Self.disc + 44)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(door.kicker))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier(door.id)
        .accessibilityAction { walk(door, from: nil) }
    }

    private func walk(_ door: ThreadDoor, from origin: CGPoint?) {
        guard leaning == nil else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: Self.leanSeconds)) { leaning = door }
        let kind = door.kind == .across ? WorldRegistry.entry(door.to.world).arrival : .dissolve
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0 : Self.crossAt))
            _ = router.go(to: door.to, via: Crossing(kind: kind, origin: origin))
            leaning = nil
        }
    }
}
