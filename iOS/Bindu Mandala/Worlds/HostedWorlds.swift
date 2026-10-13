import SwiftUI

// MARK: - Upgrade U2 · C · the worlds in their own spaces
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C 2: every world but Home is
// hosted, with the content that exists today, **in its own space** — one world
// on the glass at a time, never laid over another (`spine-and-home.md` §2 J
// #71, verification V14). Each is registered here as its world's builder in
// the U1 registry (`WorldBuilders`); Home is Part A's.
//
// The spine draws the point in every world and the menu above it (Part B); a
// hosted world draws neither. Each carries its sentinel `world.<id>` for the
// walk, answers Escape with `router.back()`, and stands its thread doors
// (`ThreadDoors`, Part B) where its address carries a kp, a chakra or a day.

extension WorldBuilders {

    /// Every hosted world's builder (all but `.home`, which Part A registers).
    /// **The spine's root calls this once, before the first world is drawn.**
    static func registerHostedWorlds() {
        register(.today)        { AnyView(TodayWorld(address: $0)) }
        register(.mandala)      { AnyView(MandalaHeldWorld(address: $0)) }
        register(.rings)        { AnyView(RingsWorld(address: $0)) }
        register(.herHome)      { AnyView(HerHomeWorld(address: $0)) }
        register(.herPresence)  { AnyView(HerPresenceWorld(address: $0)) }
        register(.climb)        { AnyView(ClimbWorld(address: $0)) }
        register(.the33)        { AnyView(The33World(address: $0)) }
        register(.game)         { AnyView(GameWorld(address: $0)) }
        register(.modes)        { AnyView(ModesWorld(address: $0)) }
        register(.time)         { AnyView(TimeWorld(address: $0)) }
        register(.memory)       { AnyView(MemoryWorld(address: $0)) }
        register(.well)         { AnyView(WellWorld(address: $0)) }
        register(.beneath)      { AnyView(BeneathWorld(address: $0)) }
        register(.relationship) { AnyView(RelationshipWorld(address: $0)) }
    }

    /// The worlds Part C hosts — every world but Home.
    static let hostedWorlds: [WorldID] = WorldID.allCases.filter { $0 != .home }
}

/// The frame every hosted world stands in: its own ground, its sentinel, the
/// Escape key as back, and its thread doors.
struct HostedWorld<Content: View>: View {
    let address: Address
    /// Whether this world stands the thread doors at its foot. Worlds whose
    /// foot is already the world's own (a room's way out, the Climb's rail)
    /// leave it off.
    var doors: Bool = true
    @ViewBuilder let content: () -> Content

    @Environment(Router.self) private var router

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()
            content()
            if doors { WorldThreadDoorsSlot(address: address) }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(address.world.sentinel)
        .accessibilityAction(.escape) { _ = router.back() }
    }
}

/// Where a hosted world stands Part B's `ThreadDoors` (`spine-and-home.md` §2
/// E #47–#48): only when the address carries a kp, a chakra or a day.
struct WorldThreadDoorsSlot: View {
    let address: Address

    private var standsOnAThread: Bool {
        address.kp != nil || address.chakra != nil || address.day != nil
    }

    var body: some View {
        if standsOnAThread {
            VStack {
                Spacer()
                ThreadDoors(address: address)
            }
            .padding(.bottom, 8)
        }
    }
}
