import Foundation

// MARK: - Upgrade U1 · A · the bridge from the six channels to the Router
//
// `waves/upgrade/worlds/spine-and-home.md` §2 J #71: one router replaces the
// six NotificationCenter channels and the global presenters. U1 does not
// delete a channel (the U1 brief, Part A 3): it lists each one here with the
// Router call that answers it, and `RouterBridge.listen` lets the Router hear
// all six while `SpineRoot` is mounted. U2 switches each poster to its Router
// call and then deletes the channel.
//
// | channel | posted by | heard today by | Router call |
// |---|---|---|---|
// | `RecognitionMomentView.didSettleNotification` | `RecognitionMomentView.settle()` | `RootView` (→ Portrait, from Today only) | `recognitionSettled(source:)` — Memory, from every source (#73) |
// | `MandalaWays.notification` | `MandalaWays.ask(_:)` (Lalitā's field → the Road) | `RootView` (→ Mandala) | `askWay(_:)` — the world the way reaches |
// | `GiftRouter.openNotification` | `GiftRouter` (a tapped gift) | `RootView.landOnGift()` (Detail cover) | `giftOpened(kp:)` — Home, her card open (#72) |
// | `PlayField.openNotification` | `PlayField.open(_:)` | `PlayFieldPresenter` (covers) | `openPlay(_:)` — A Strange Game at the game |
// | `HomecomingView.reEnterNotification` | `HomecomingView.reset()` (Settings) | `AppRoot` | `reEnterHomecoming()` |
// | `HomeAfterEffect.didLeave` | `HomeAfterEffect.left(ring:)` (leaving her room) | `HerSiddhiLingers` | `leftHerRoom(ring:)` — carried across worlds (#39) |
//
// The global presenters, routed by the same Router: `.playFieldPresenter()`
// → `openPlay(_:)`; `.leelaDrops()` → `leelaDropped(id:)` (#74); the static
// `MandalaWays.pending` and `GiftRouter.peek/take` are read by the bridge
// below (the gift is taken once, here, when the Router is listening).

/// The six NotificationCenter channels the Router replaces (§2 J #71).
enum SpineChannel: String, CaseIterable {
    case recognitionSettled
    case mandalaWayAsked
    case giftOpened
    case playFieldOpen
    case homecomingReEnter
    case herSiddhiLingers

    /// The channel's notification, exactly as its owner declares it.
    @MainActor
    var notificationName: Notification.Name {
        switch self {
        case .recognitionSettled: return RecognitionMomentView.didSettleNotification
        case .mandalaWayAsked:    return MandalaWays.notification
        case .giftOpened:         return GiftRouter.openNotification
        case .playFieldOpen:      return PlayField.openNotification
        case .homecomingReEnter:  return HomecomingView.reEnterNotification
        case .herSiddhiLingers:   return HomeAfterEffect.didLeave
        }
    }

    /// The Router method U2 switches the channel's poster to.
    var routerCall: String {
        switch self {
        case .recognitionSettled: return "recognitionSettled(source:)"
        case .mandalaWayAsked:    return "askWay(_:)"
        case .giftOpened:         return "giftOpened(kp:)"
        case .playFieldOpen:      return "openPlay(_:)"
        case .homecomingReEnter:  return "reEnterHomecoming()"
        case .herSiddhiLingers:   return "leftHerRoom(ring:)"
        }
    }
}

/// Hands each channel's notification to its Router call (§2 J #71).
@MainActor
enum RouterBridge {

    /// One notification, answered by the Router.
    static func handle(_ channel: SpineChannel, _ note: Notification, router: Router) {
        switch channel {
        case .recognitionSettled:
            router.recognitionSettled(source: note.object as? String)
        case .mandalaWayAsked:
            // `MandalaWays.pending` stays for the Mandala to take when it stands.
            if let raw = note.object as? String, let way = WayIn(rawValue: raw) {
                router.askWay(way)
            }
        case .giftOpened:
            if let kp = GiftRouter.shared.take() { router.giftOpened(kp: kp) }
        case .playFieldOpen:
            router.openPlay((note.object as? String).flatMap { PlayGame(rawValue: $0) })
        case .homecomingReEnter:
            router.reEnterHomecoming()
        case .herSiddhiLingers:
            if let ring = note.userInfo?["ring"] as? Int { router.leftHerRoom(ring: ring) }
        }
    }

    /// Let the Router hear all six channels. Keep the tokens; `stop` them when
    /// the Router's root leaves.
    static func listen(_ router: Router, center: NotificationCenter = .default) -> [NSObjectProtocol] {
        SpineChannel.allCases.map { channel in
            center.addObserver(forName: channel.notificationName, object: nil, queue: .main) { [weak router] note in
                MainActor.assumeIsolated {
                    guard let router else { return }
                    RouterBridge.handle(channel, note, router: router)
                }
            }
        }
    }

    static func stop(_ tokens: [NSObjectProtocol], center: NotificationCenter = .default) {
        for t in tokens { center.removeObserver(t) }
    }
}
