import SwiftUI

// MARK: - Upgrade U2 · C · the doors between the hosted worlds
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C 2–4 and
// `waves/upgrade/worlds/spine-and-home.md` §2 G #53 ("every leaving word
// routes to back()"), J #71 (one router; worlds are pushed, never nested
// covers). Every place in the existing screens that used to raise another
// world over itself — her room over the Rite, her Detail over the Mandala, the
// Climb over the Field, a chakra room over the Climb, the modes over the field —
// now asks the Router to cross instead. One door, one crossing, one back.
//
// Existing screens were built before the spine existed and may be drawn
// without a Router in their environment, so these doors read the Router from
// the environment when it is there and fall back to `Router.shared` (the one
// `SpineRoot` mounts by default) — never a crash for a missing environment.

/// The sub-places inside the hosted worlds — `Address.sub` values.
///
/// Raw strings, because they travel in the journey file and in deep links.
/// Parts A and B read `source` (the Bindu's arrival from the inside); the rest
/// are the hosted worlds' own.
enum WorldSub {
    /// Home: arrive through Lalitā source (kp 102) — `spine-and-home.md` §2 A #25, #32.
    static let source = "source"
    /// The nine rings / the Climb: standing in one ring — `"ring.3"`.
    static let ringPrefix = "ring."
    /// The 33: a chakra's room, its Road position in `Address.chakra`.
    static let room = "room"
    /// The 33: the Road being walked.
    static let road = "road"
    /// Beneath: the low-state door, the Shadow Translator, the river of letters.
    static let low = "low"
    static let translator = "translator"
    static let river = "river"

    /// `"ring.N"` for a ring 1…9.
    static func ring(_ n: Int) -> String { ringPrefix + String(n) }

    /// The ring a sub-place names, when it names one (1…9).
    static func ring(in sub: String?) -> Int? {
        guard let sub, sub.hasPrefix(ringPrefix),
              let n = Int(sub.dropFirst(ringPrefix.count)), (1...9).contains(n) else { return nil }
        return n
    }
}

/// The crossings the hosted worlds make to one another — each one `router.go`.
@MainActor
enum WorldDoors {

    /// Her room, through her rite of entering — room first (U2 brief Part C 2).
    static func herHome(_ kp: Int, router: Router? = nil, from origin: CGPoint? = nil) {
        _ = (router ?? .shared).go(to: Address(.herHome, kp: kp), via: Crossing(kind: .pulseGate, origin: origin))
    }

    /// Her text page — Her Presence.
    static func herPresence(_ kp: Int, router: Router? = nil, from origin: CGPoint? = nil) {
        _ = (router ?? .shared).go(to: Address(.herPresence, kp: kp), via: .bloom(from: origin))
    }

    /// One ring of the nine, in its own space (the Veil's row, a door).
    static func ring(_ ring: Int, router: Router? = nil, from origin: CGPoint? = nil) {
        _ = (router ?? .shared).go(to: Address(.rings, sub: WorldSub.ring(min(max(ring, 1), 9))),
                      via: Crossing(kind: .veilDark, origin: origin))
    }

    /// The Climb, standing in a ring.
    static func climb(ring: Int, router: Router? = nil, from origin: CGPoint? = nil) {
        _ = (router ?? .shared).go(to: Address(.climb, sub: WorldSub.ring(min(max(ring, 1), 9))),
                      via: Crossing(kind: .passage, origin: origin))
    }

    /// A chakra's room, in the 33.
    static func chakraRoom(_ road: Int, router: Router? = nil, from origin: CGPoint? = nil) {
        _ = (router ?? .shared).go(to: Address(.the33, chakra: road, sub: WorldSub.room),
                      via: Crossing(kind: .passage, origin: origin))
    }

    /// A mode (or the modes' door when `nil`).
    static func modes(_ mode: TheModes.Mode?, router: Router? = nil) {
        _ = (router ?? .shared).go(to: Address(.modes, sub: mode?.rawValue), via: .bloom())
    }

    /// Beneath, at one of its three doors (or its gathering when `nil`).
    static func beneath(_ sub: String?, router: Router? = nil) {
        _ = (router ?? .shared).go(to: Address(.beneath, sub: sub), via: .descent())
    }

    /// Time — the five clocks.
    static func time(router: Router? = nil) {
        _ = (router ?? .shared).go(to: Address(.time, day: Address.Day(Date())), via: .bloom())
    }
}

// MARK: - The modifiers that replace a cover with a crossing

/// Where an existing screen set a position to raise her room over itself, the
/// position now crosses to Her Home and is let go at once.
@MainActor
struct CrossesToHerHome: ViewModifier {
    @Binding var kp: Int?
    /// Called once the crossing has been asked for (the Climb lands its eye).
    var then: (() -> Void)?

    @Environment(Router.self) private var envRouter: Router?

    func body(content: Content) -> some View {
        content.onChange(of: kp) { _, new in
            guard let k = new else { return }
            kp = nil
            WorldDoors.herHome(k, router: envRouter ?? .shared)
            then?()
        }
    }
}

/// The same, for a screen that held her row rather than her position.
@MainActor
struct CrossesToHerHomeFromRow: ViewModifier {
    @Binding var shakti: Shakti?

    @Environment(Router.self) private var envRouter: Router?

    func body(content: Content) -> some View {
        content.onChange(of: shakti.map { ObjectIdentifier($0) }) { _, new in
            guard new != nil, let s = shakti else { return }
            shakti = nil
            WorldDoors.herHome(s.khadgamalaPosition ?? s.playPosition, router: envRouter ?? .shared)
        }
    }
}

/// A chakra's room, crossed to in the 33 instead of raised over this world.
@MainActor
struct CrossesToChakraRoom: ViewModifier {
    @Binding var road: Int?

    @Environment(Router.self) private var envRouter: Router?

    func body(content: Content) -> some View {
        content.onChange(of: road) { _, new in
            guard let r = new else { return }
            road = nil
            WorldDoors.chakraRoom(r, router: envRouter ?? .shared)
        }
    }
}

extension View {
    /// Her room — through her rite of entering, in Her Home — whenever `kp`
    /// holds a position (U2: a crossing, never a cover over this world).
    @MainActor
    func crossesToHerHome(_ kp: Binding<Int?>, then: (() -> Void)? = nil) -> some View {
        modifier(CrossesToHerHome(kp: kp, then: then))
    }

    /// Her room, from a screen that holds her row.
    @MainActor
    func crossesToHerHome(shakti: Binding<Shakti?>) -> some View {
        modifier(CrossesToHerHomeFromRow(shakti: shakti))
    }

    /// A chakra's room, in the 33, whenever `road` holds one of the 33.
    @MainActor
    func crossesToChakraRoom(_ road: Binding<Int?>) -> some View {
        modifier(CrossesToChakraRoom(road: road))
    }
}
