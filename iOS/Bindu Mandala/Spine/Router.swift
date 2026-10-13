import Foundation
import CoreGraphics
import Observation

// MARK: - Upgrade U1 · A · the Router
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "The spine in every world" ("One
// router replaces the six NotificationCenter channels and the global
// presenters"), §2 G #51–#53 (back to exactly where you were), H #54–#55 and
// #64 (every crossing through the point, once per crossing between worlds) and
// J #71–#74 (go, back, home, open(url); the gift, Recognition and Leela as
// routes). One source of truth: `state` (where he is and the way back) — and
// exactly one world mounted at a time (`mounted`), which changes only at the
// crossing's mount beat, under its bloom. Nothing is ever laid over a world.
//
// U2 · B: the Router is the app's root. The six NotificationCenter channels
// are gone — every poster calls its Router method directly (`RecognitionMomentView`
// → `recognitionSettled`, `MandalaWays.ask` → `askWay`, `GiftRouter` →
// `giftOpened`, `PlayField.open` → `openPlay`, `HomecomingView.reset` →
// `reEnterHomecoming`, `HomeAfterEffect.left` → `leftHerRoom`). The Router
// also holds the spine's own two states that are not worlds: the menu (the
// Constellation, §2 D #40–#42, above every world) and a spine place (Settings
// #95, the one-second practice #35) drawn *in place of* the world, never over it.

/// A crossing on its way — what `CrossingOverlay` draws.
struct CrossingInFlight: Equatable, Identifiable {
    let id: UUID
    let crossing: Crossing
    let from: Address
    let to: Address
    /// The colour it blooms in: the world entered (go), the world left (back) — §2 G #51, H #55.
    let colourHex: String
    let startedAt: Date
    let timing: Crossing.Timing

    /// Seconds since the touch.
    func elapsed(at date: Date) -> Double { max(0, date.timeIntervalSince(startedAt)) }

    /// 0…1 over the whole crossing.
    func progress(at date: Date) -> Double {
        guard timing.total > 0 else { return 1 }
        return min(1, elapsed(at: date) / timing.total)
    }
}

/// The router — `spine-and-home.md` §2 J #71 (`WorldRouter`).
@MainActor
@Observable
final class Router {

    /// The app's one router. In the unit-test host it keeps no journey file,
    /// so a test that reaches a poster (`MandalaWays.ask`) writes nothing to disk.
    static let shared = Router(directory: AppRuntime.isUnitTesting ? nil : PracticeVault.defaultDirectory)

    /// `PracticeVault` file of the journey (§4 "On the phone": `journey`).
    static let journeyFile = "journey"

    /// A ceremony the shell owes him (Settings → "Re-enter the Homecoming").
    enum Ceremony: String, Codable {
        case homecoming
    }

    /// He crossed out of a room in this āvaraṇa (§2 C #39) — carried across worlds.
    struct AfterEffectMark: Equatable {
        let ring: Int
        let at: Date
    }

    /// U2 · The menu's three faces (§2 D #40 the Constellation, #41 the list,
    /// #42 the Veil) — one switch; he stays where he is.
    enum MenuFace: String, CaseIterable {
        case constellation
        case list
        case veil
    }

    /// U2 · A place the spine itself keeps that is not one of the fifteen
    /// worlds. It is drawn *in place of* the world (the world stays alive
    /// beneath, hidden and untouchable), never over it.
    enum SpinePlace: String, CaseIterable {
        /// Settings becomes a place, never a sheet over a world (§2 M #95).
        case settings
        /// Blink · Breathe · Press — the one-second practice (§2 C #35).
        case oneSecond
    }

    /// Where he is, and the way back. The one source of truth.
    private(set) var state: NavigationState
    /// The one world drawn now. Follows `state.current` at each crossing's
    /// mount beat; never two.
    private(set) var mounted: Address
    /// The crossing being drawn, if any.
    private(set) var inFlight: CrossingInFlight?
    /// The last crossing begun (kept after it settles).
    private(set) var lastCrossing: CrossingInFlight?
    /// A ceremony asked for and not yet taken by the shell.
    private(set) var pendingCeremony: Ceremony?
    /// Her room's after-effect, carried across worlds (§2 C #39).
    private(set) var afterEffect: AfterEffectMark?
    /// U2 · The menu, when open, and on which face (§2 D #40–#42).
    private(set) var menuFace: MenuFace?
    /// U2 · The spine place drawn in place of the world, if any.
    private(set) var place: SpinePlace?

    /// Set by the root from the environment: every crossing becomes the .2 s cross-fade.
    var reduceMotion = false

    /// Called once per crossing between worlds (§2 H #64: the App Activity
    /// row `World Crossed` — U2 wires it to the ledger). Never within a world.
    @ObservationIgnored var onWorldCrossed: ((_ from: Address, _ to: Address) -> Void)?
    /// U2: a colour for an address finer than its world's (her accent in
    /// Today, the room's Map hex in the 33 — `the-33-architecture.md` §1).
    @ObservationIgnored var colourResolver: ((Address) -> String?)?

    private let directory: URL?
    private let settlesInstantly: Bool
    private let clock: () -> Date
    /// U2 · The last back, so the root's edge and a world's own way out,
    /// heard together for one swipe, take him back one step and not two.
    @ObservationIgnored private var lastBackAt: Date?
    /// U2 · Two backs closer than this are one gesture heard twice.
    static let backDebounceSeconds = 0.35

    /// - Parameters:
    ///   - directory: where the journey is kept (`nil`: nowhere — tests).
    ///   - launch: the walk's address (`OPEN_PLACE` / `OPEN_WORLD`, DEBUG only).
    ///   - settlesInstantly: mount at once instead of at the crossing's beat (tests).
    init(directory: URL? = PracticeVault.defaultDirectory,
         launch: Address? = DeepLink.launchAddress(),
         settlesInstantly: Bool = false,
         clock: @escaping () -> Date = { Date() }) {
        self.directory = directory
        self.settlesInstantly = settlesInstantly
        self.clock = clock
        let saved = directory.flatMap {
            PracticeVault.read(NavigationState.self, named: Router.journeyFile, in: $0)
        }
        var start = saved?.relaunched() ?? NavigationState()
        if let launch, launch.isValid { start.current = launch }
        self.state = start
        self.mounted = start.current
    }

    // MARK: Going

    /// Cross to an address. Refuses an invalid address and the place he is
    /// already standing on. The place he leaves goes on the way back, exactly.
    @discardableResult
    func go(to address: Address, via crossing: Crossing = .bloom()) -> Bool {
        guard address.isValid else { return false }
        let from = state.current
        guard address.place != from.place else { return false }
        state.push(from, at: clock())
        state.current = address
        begin(crossing, from: from, to: address, colourOf: address)
        persist()
        return true
    }

    /// Back to exactly where he was (§2 G #51): the last step of the way back,
    /// camera and all, under a bloom in the colour of the world he leaves. With
    /// no way back, the edge still leads out: Home. At Home with no way back,
    /// nothing happens.
    @discardableResult
    func back(via crossing: Crossing = .bloom()) -> Bool {
        // U2 · back first closes what the spine has open, in place.
        if menuFace != nil { closeMenu(); return true }
        if place != nil { closePlace(); return true }
        if !settlesInstantly {
            let now = clock()
            if let last = lastBackAt, now.timeIntervalSince(last) < Self.backDebounceSeconds { return false }
            lastBackAt = now
        }
        guard let entry = state.pop() else {
            guard state.current.place != Address.home else { return false }
            return home(via: crossing)
        }
        let from = state.current
        state.remember(from)
        state.current = entry.address
        begin(crossing, from: from, to: entry.address, colourOf: from)
        persist()
        return true
    }

    /// To the centre (the point's tap, §2 C #36). The place he leaves goes on
    /// the way back, so back returns him there.
    @discardableResult
    func home(via crossing: Crossing = .bloom()) -> Bool {
        go(to: .home, via: crossing)
    }

    /// U2 · Back by the edge (§2 G #51–#53): under the return bloom when he
    /// left that place within 45 minutes (#52), else the bloom from the touch.
    @discardableResult
    func backFromEdge(origin: CGPoint? = nil) -> Bool {
        let recent = state.backStack.last.map {
            clock().timeIntervalSince($0.at) <= Crossing.returnWindowMinutes * 60
        } ?? false
        return back(via: Crossing(kind: recent ? .returnBloom : .bloom, origin: origin))
    }

    /// U2 · The point's hold (§2 C #36): straight to the source — Home, at
    /// Lalitā source, keyed by kp 102 — through the deep zoom's crossing.
    @discardableResult
    func toSource(from origin: CGPoint? = nil) -> Bool {
        go(to: .source, via: Crossing(kind: .pravesha, origin: origin))
    }

    // MARK: U2 · The menu and the spine's places

    /// Open the Constellation (or one of its faces) above the world.
    func openMenu(_ face: MenuFace = .constellation) {
        menuFace = face
    }

    /// Close the menu; the world beneath is exactly as he left it.
    func closeMenu() {
        menuFace = nil
    }

    /// Draw a spine place in place of the world (the world kept alive beneath).
    func open(place p: SpinePlace) {
        menuFace = nil
        place = p
    }

    /// Leave the spine place; the world returns as it was.
    func closePlace() {
        place = nil
    }

    /// Keep where the camera / scroll / zoom now rests in this place, without
    /// crossing (§2 G #51: "every 700 ms inside a corridor").
    func note(anchor: Address.Anchor?) {
        state.current.anchor = anchor
        if mounted.place == state.current.place { mounted.anchor = anchor }
        persist()
    }

    /// Open a link (§2 J #71 `open(url)`).
    @discardableResult
    func open(_ url: URL, via crossing: Crossing = .bloom()) -> Bool {
        guard let a = DeepLink.address(from: url) else { return false }
        return go(to: a, via: crossing)
    }

    /// Finish the crossing now: the destination is mounted, the figure gone.
    func settle() {
        mounted = state.current
        inFlight = nil
    }

    // MARK: The routes that replaced the six channels (U2: called directly)

    /// Recognition has settled: memory settles in, from every source (§2 J #73).
    /// `source` is `AirtableService.RecognitionSource`'s raw value, kept for U2.
    func recognitionSettled(source: String?) {
        _ = source
        go(to: Address(.memory, day: Address.Day(clock())))
    }

    /// A way asked for from elsewhere (`MandalaWays.ask`): the world it reaches.
    func askWay(_ way: WayIn) {
        go(to: Address(WorldID.reached(by: way)))
    }

    /// A gift was opened: Home, with her card already open (§2 J #72).
    func giftOpened(kp: Int) {
        go(to: Address(.home, kp: kp, sub: Address.cardSub))
    }

    /// `PlayField.open(_:)` / the play presenter: A Strange Game, at one game or the whole field.
    func openPlay(_ game: PlayGame?) {
        go(to: Address(.game, sub: game?.rawValue))
    }

    /// A Leela drop is presented as a place in A Strange Game (§2 J #74).
    func leelaDropped(id: String) {
        go(to: Address(.game, sub: Address.leelaSubPrefix + id))
    }

    /// Settings → "Re-enter the Homecoming": the shell owes him the Homecoming,
    /// and he stands at Home for it.
    func reEnterHomecoming() {
        pendingCeremony = .homecoming
        home()
    }

    /// The shell takes the ceremony it owes, once.
    func takeCeremony() -> Ceremony? {
        defer { pendingCeremony = nil }
        return pendingCeremony
    }

    /// He crossed out of her room in this ring (`HomeAfterEffect.left(ring:)`).
    func leftHerRoom(ring: Int) {
        afterEffect = AfterEffectMark(ring: ring, at: clock())
    }

    // MARK: The crossing's clock

    private func colour(for address: Address) -> String {
        colourResolver?(address) ?? WorldRegistry.entry(address.world).essenceHex
    }

    private func begin(_ crossing: Crossing, from: Address, to: Address, colourOf colourAddress: Address) {
        // U2 · every crossing closes the menu and any spine place: he arrives
        // in the world, never under something.
        menuFace = nil
        place = nil
        let timing = crossing.timing(reduceMotion: reduceMotion)
        let flight = CrossingInFlight(id: UUID(), crossing: crossing, from: from, to: to,
                                      colourHex: colour(for: colourAddress),
                                      startedAt: clock(), timing: timing)
        inFlight = flight
        lastCrossing = flight
        if from.world != to.world { onWorldCrossed?(from, to) }
        WalkTrace.mark("router.\(from.world.rawValue)>\(to.world.rawValue)")
        if settlesInstantly {
            settle()
            return
        }
        let id = flight.id
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(max(0, timing.mountAt) * 1_000_000_000))
            guard let self, self.inFlight?.id == id else { return }
            self.mounted = self.state.current
            try? await Task.sleep(nanoseconds: UInt64(max(0, timing.total - timing.mountAt) * 1_000_000_000))
            guard self.inFlight?.id == id else { return }
            self.inFlight = nil
        }
    }

    private func persist() {
        guard let directory else { return }
        try? PracticeVault.write(state, named: Self.journeyFile, in: directory)
    }
}
