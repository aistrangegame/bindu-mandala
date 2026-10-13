import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · C · Her Home and Her Presence
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C 2: **room first.**
// Touching a Śakti anywhere opens her room — through her rite of entering —
// in Her Home; her text page becomes Her Presence, and the room's library door
// leads to it. Both stand on the kp thread (`spine-and-home.md` §5).

/// Her Home — the existing rite → room path (`HerRoomPassage`, the one place a
/// threshold is built), in its own space. Leaving the room — the held way
/// out, its edge, the corridor's end — is `router.back()`.
struct HerHomeWorld: View {
    let address: Address

    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var context

    /// Her position; with none on the address, today's Śakti.
    private var kp: Int {
        address.kp ?? (AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition())
    }

    var body: some View {
        HostedWorld(address: address, doors: false) {
            HerRoomPassage(startingAt: kp, context: context,
                           onLeft: { _ = router.back() },
                           onPresence: { at in WorldDoors.herPresence(at, router: router) })
                // A new position is a new room, through its own rite.
                .id(kp)
        }
    }
}

/// Her Presence — the existing `ShaktiDetailView`, her text page, in its own
/// space. Its back word is `router.back()`; her room is Her Home, crossed to.
struct HerPresenceWorld: View {
    let address: Address

    @Environment(Router.self) private var router
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    private var kp: Int {
        address.kp ?? (AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition())
    }

    private var shakti: Shakti? { shaktis.first { $0.khadgamalaPosition == kp } }

    var body: some View {
        HostedWorld(address: address) {
            if let s = shakti {
                NavigationStack {
                    ShaktiDetailView(shakti: s, backLabel: "return", source: .mandala,
                                     onBack: { _ = router.back() })
                }
                .id(kp)
            } else {
                // Her row has not arrived yet (first sync): the ground holds,
                // and the point and the edge still lead out.
                Color.silenceGround.ignoresSafeArea()
            }
        }
    }
}
