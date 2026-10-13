# U1 · A · Router — builder report

Branch `u1-a` from `upgrade` @ `f22eb7e`. No Swift compiler in this container: every type called was read in source before use; nothing here has been compiled yet. The Mac build is the first compile.

## What was built (Part A 1–6)

| # | Brief item | Where | Notes |
|---|---|---|---|
| 1 | `WorldRegistry` | `Spine/WorldRegistry.swift` | `WorldEntry` per `WorldID`: display name, `Station` (centre or ring index 0–13 clockwise from 12 o'clock, r 148 pt, `offset`), `essenceHex` + `colourSource` (file + section), `threads` (kp / chakra / day doors, §5), `kpDoors` (Relationship Field: 31/40/42), `arrival` crossing from Home (§5). `entry(_:)` is a total `switch`, so a new `WorldID` case will not compile until it has a row. `doors(kp:)`, `doors(chakra:)`, `doors(day:)` give the thread doors in station order. `WorldBuilders` (`@MainActor`) holds the builder closures: none are registered in U1, so every world draws as its `WorldPlaceholder`; U2 calls `WorldBuilders.register(_:_:)`. |
| 2 | `Address`, `NavigationState` | `Spine/Address.swift`, `Spine/NavigationState.swift` | `Address(world, kp 1–102?, chakra 1–33?, day?, sub?, anchor?)`. `Address.Day` is a Gregorian `yyyy-MM-dd` value (rejects 30 Feb). `Address.Anchor` holds scale, offset, scroll step, zoom and breath phase. `place` is the address without its anchor. `NavigationState` holds `current`, `backStack` (`Entry {address, at}`), `lastByWorld` (the Road Home beads) and `before`. It is `Codable` and kept in `PracticeVault` as `journey`. `relaunched()` follows ruling 1: every launch arrives at Home, the beads and `before` are kept, and the back stack is cleared. `extension WorldID: Codable {}` is declared here. |
| 3 | `Router` | `Spine/Router.swift` | `@MainActor @Observable`. Main API: `go(to:via:)`, `back(via:)`, `home(via:)`, `note(anchor:)`, `open(_ url:)` and `settle()`. `state` is the one source of truth. `mounted` is the one world drawn, and it follows `state` only at the crossing's mount beat. `inFlight` and `lastCrossing` describe the crossing. Two hooks are left for U2: `onWorldCrossed` (§2 H #64, the "World Crossed" ledger row, which U1 does **not** write) and `colourResolver` (her accent, the room's hex). `back()` blooms in the colour of the world he leaves; with an empty stack it goes Home; at Home with an empty stack it does nothing. |
| 3 | Bridge for the six channels | `Spine/RouterBridge.swift` | `SpineChannel` lists each channel, its `Notification.Name` (read from the owner's own static) and its Router call. `RouterBridge.handle` maps a notification to that call, and `RouterBridge.listen/stop` subscribe the Router while `SpineRoot` is mounted. **No channel was deleted and no caller was switched.** The table in the file header lists poster, current listener and Router call. |
| 4 | `Crossing` | `Spine/Crossing.swift`, `Spine/CrossingOverlay.swift` | Covers the whole library (#54): dissolve, bloom, veilLight, veilDark, descent, blink, passage, pulseGate, spanda, pravesha and returnBloom. Each kind has its numbers, `Timing` (total, mountAt, gather, curve, reduced) and the `visual.md` curves (`Curve.value(at:)` solves the cubic Bézier). Bloom (#55) is drawn in full: a 0.30 s gather to ×0.96 toward the touch (in `SpineRoot`), a 0.72 s radial in the destination colour from the touch to 2.6 × the larger side, the destination mounted at 0.62 s, and Design's opacity and scale keyframes. Descent (#56) and blink (#57) are drawn minimally. Return bloom and reduced motion (a 0.2 s cross-fade) are drawn. Passage, pulse gate, Spanda, Praveśa and the veils are declared and drawn as the bloom. Crossings are silent and carry no haptics; Part D's library arrives in U2. |
| 5 | Deep links, `OPEN_WORLD` | `Spine/DeepLink.swift` | Link forms: `bindu://place?world=&kp=&ch=&day=&sub=`, plus `bindu://kp/N` (her Home), `bindu://road/N` (the 33), `bindu://day/yyyy-MM-dd` (Today) and `bindu://world/<id>`. The walk uses `OPEN_PLACE=world:kp:ch:day`. `DeepLink.launchAddress(arguments:)` takes the last `OPEN_PLACE` or `OPEN_WORLD` and is DEBUG-only. **`OPEN_WORLD` now routes through it** (RootView hook below). `SpineLaunch` (`SPINE=1`, DEBUG only) mounts `SpineRoot` in place of `RootView`. |
| 6 | Tests | `iOS/Bindu MandalaTests/U1RouterTests.swift` | Described below. |
| — | Root and placeholders | `Spine/SpineRoot.swift` | `SpineRoot` mounts exactly one `WorldHost(address: router.mounted)`. It draws the crossing above that world, injects the router (`.environment(router)`), passes Reduce Motion to the router, listens to the bridge and answers `onOpenURL`. `WorldPlaceholder` shows the world's name, its colour wash, "this has not yet been composed", `point.home`, a "return" control (calls `back()`), a leading-edge way out (22 pt / 72 pt) and Escape. It carries the sentinel `world.<id>`. At Home the placeholder draws the point (`point.home`, 26 pt) and the fourteen stations (`station.<id>`, one tap crosses with that world's arrival crossing). `PointHome` is 6 pt `#C0392B` at 0.3, top 16 / right 16, with a 44 pt target; a tap calls `home()` and blooms from the point. |

### Router calls that replace the channels and presenters

| channel / presenter | Router call |
|---|---|
| `RecognitionMomentView.didSettleNotification` | `recognitionSettled(source:)`: Memory from every source (#73), and back returns him |
| `MandalaWays.notification` | `askWay(_:)`: `WorldID.reached(by:)` (`MandalaWays.pending` is left for the Mandala) |
| `GiftRouter.openNotification` | `giftOpened(kp:)`: Home with her card open (`sub: "card"`). The bridge takes the gift once. |
| `PlayField.openNotification` | `openPlay(_:)`: A Strange Game, `sub` = the game's raw value |
| `HomecomingView.reEnterNotification` | `reEnterHomecoming()`: sets `pendingCeremony = .homecoming` (U2 shell takes it with `takeCeremony()`) and goes Home |
| `HomeAfterEffect.didLeave` | `leftHerRoom(ring:)`: `afterEffect {ring, at}` carried across worlds |
| `.playFieldPresenter()` | `openPlay(_:)` |
| `.leelaDrops()` | `leelaDropped(id:)`: A Strange Game, `sub` = `"leela." + id` |

## Every file touched

New:
- `iOS/Bindu Mandala/Spine/Address.swift`
- `iOS/Bindu Mandala/Spine/Crossing.swift`
- `iOS/Bindu Mandala/Spine/CrossingOverlay.swift`
- `iOS/Bindu Mandala/Spine/DeepLink.swift`
- `iOS/Bindu Mandala/Spine/NavigationState.swift`
- `iOS/Bindu Mandala/Spine/Router.swift`
- `iOS/Bindu Mandala/Spine/RouterBridge.swift`
- `iOS/Bindu Mandala/Spine/SpineRoot.swift`
- `iOS/Bindu Mandala/Spine/WorldRegistry.swift`
- `iOS/Bindu MandalaTests/U1RouterTests.swift`
- `waves/upgrade/briefs/U1-A-report.md`

Minimal additive hooks elsewhere. Both are needed: the brief asks that `OPEN_WORLD` route through the Router and that the walk reach all fifteen worlds today.
- `iOS/Bindu Mandala/BinduMandalaApp.swift`, `AppRoot`: `if SpineLaunch.isRequested { SpineRoot() } else { RootView() }`. This only acts under the DEBUG `SPINE=1` argument; without it the app is unchanged.
- `iOS/Bindu Mandala/Views/Root/RootView.swift`, `initialDestination()`: `WorldID.fromLaunchArguments(args)` became `DeepLink.launchAddress(arguments: args)?.world`. The U0 screen mapping (`u0Destination`) is unchanged, and `OPEN_PLACE` is now honoured too.

Not touched: `Services/WorldID.swift`. Its `case` lines are read by `TheWalk.testTheWalkKnowsEveryWorld`, so `Codable` is added from `Spine/Address.swift` instead. No channel, presenter or existing screen was changed, and nothing was added to `project.pbxproj` or `Info.plist`.

New top-level type names, to check against parts B–D at merge: `Address`, `WorldThread`, `WorldEntry`, `WorldRegistry`, `WorldBuilders`, `NavigationState`, `Router`, `CrossingInFlight`, `Crossing`, `Keyframes`, `CrossingOverlay`, `DeepLink`, `SpineLaunch`, `SpineChannel`, `RouterBridge`, `SpineRoot`, `WorldHost`, `WorldPlaceholder`, `PointHome`. Names nested on purpose to avoid collisions: `Address.Anchor` (SwiftUI has `Anchor`), `Address.Day`, and `WorldThread` (Foundation has `Thread`). `ChakraConstellation.Address` is nested, so the top-level `Address` does not shadow it outside that type.

## API assumptions not verified by a compiler

- `extension WorldID: Codable {}` in another file picks up the stdlib `RawRepresentable` (String) Codable defaults.
- `@Observable final class Router` has `private(set)` stored properties, `@ObservationIgnored var` closure properties, plain `private let` properties, and is initialised in `init` before use. This follows `BinduMemory`'s pattern.
- `.environment(router)` and `@Environment(Router.self)` use the iOS 17 Observation environment.
- `TimelineView(.animation(minimumInterval: nil, paused:))`, `.onChange(of:) { _, new in }` and `.accessibilityAction(.escape)` are used.
- `MainActor.assumeIsolated` is used inside `NotificationCenter.addObserver(forName:object:queue: .main)`. Swift 5 mode may warn about Sendable here.
- `SpineChannel.notificationName` is `@MainActor`, because it reads static lets on SwiftUI `View` types (`RecognitionMomentView`, `HomecomingView`). The tests that read it are `@MainActor`.
- CGFloat and Double are converted implicitly at SwiftUI call sites; the mixed multiplications were made explicit.
- `URL.host` is used and is deprecated since iOS 16 (warning only).
- `URLComponents.percentEncodedQuery` is set to a value encoded by hand from `urlQueryAllowed` minus `&=+#`.
- `Gradient.Stop(color:location:)` is given a Double location.
- `Task { [weak self] in … }` inside a `@MainActor` method inherits the main actor.

## Numbers and choices to review

- **Essence colours.** The registry needs one colour per world for the bloom and the point, but the world files give only some of them. Each colour below is taken word for word from the file it cites, and a test checks that. They are open to Part C / U2 refinement through `Router.colourResolver`.

  | World | Colour | Source |
  |---|---|---|
  | Home | `#C0392B` | visual §1.4.1 / §1.10 |
  | Today | `#C9813A` | visual §1.9 / §1.10, depth .25 |
  | Her Presence | `#C76B35` | visual §1.9, depth .5 = §1.8 step 2 |
  | Her Home | `#C45430` | visual §1.9, depth .75 = §1.8 step 3 |
  | Mandala | `#C9963F` | visual §1.4.3, yantra gold |
  | Nine Rings | `#CE9546` | visual §1.4.4, ring 1 |
  | Climb | `#D8B658` | visual §1.4.7, ascent |
  | the 33 | `#D62F29` | spine-and-home §1, chakra thread |
  | A Strange Game | `#0F4A50` | game.md:20, cloth |
  | Modes | `#D46453` | visual §1.4.10, voice coral |
  | Time | `#F2E8D9` | spine-and-home §1, day thread |
  | Memory | `#BE5A4E` | visual §1.10 |
  | Well | `#F3B05A` | visual §1.10 |
  | Beneath | `#7A2F14` | visual §1.10 |
  | Relationship Field | `#F9E3A7` | visual §1.10 |

- **Two timings are assumptions**, written as comments in `Crossing.timing`:
  - The veil crossings mount at 0.62/0.72 of their span, the same fraction as the portal.
  - The blink's lids part again over 0.66 s after the Rite opens at 0.78 s, so its total is 1.44 s.
- **Placeholder Home crosses on one tap.** The designed "first touch opens the card, the second crosses" is U2's.
- **The point's hold and double-tap are not wired.** Hold should fall to the source and double-tap should give one second; both need Part D's hold engine.

## How each test fails (V30)

Every test file reads the world files from `SourceTree.repoRoot/waves/upgrade/worlds/`. A missing file throws `DesignCorpus.Missing`, which counts as a failure, never a skip. Each test also carries a planted defect that it is shown to catch.

| Test | Proves | Fails when / planted defect |
|---|---|---|
| `testTheRegistryHoldsEveryWorldOnce` | 15 entries in `WorldID` order; stations 0–13 once; Home alone at the centre; Today first; names and colours unique; no measuring words | A station appears twice or a world is missing (planted: `stationsAreWhole` on a registry with a duplicate `.ring(0)` and one with the last world dropped, both asserted false) |
| `testTheStationRingIsTheWorldFilesOrder` | The ring order and r 148 match the sentence in spine-and-home.md; Today is straight up, A Strange Game straight down, and the ring runs clockwise | The file or the registry is reordered (planted: two neighbours swapped ≠ file order) |
| `testEveryEssenceColourIsReadFromItsSource` | Each world's hex is found in the file it cites | A colour is retyped or invented (planted: `#123457` not found in visual.md) |
| `testEveryWorldIsReachableFromHomeByGo` | Each of the 14 worlds is reached by `go` from `home()` and mounted, and `back()` returns Home; every kp 1–102, chakra 1–33 and day door is reached; the doors together reach the right 12 worlds; the Relationship Field's kp door opens only for 31/40/42 | A world is unreachable or a door is missing (planted: kp 0 and 103, chakra 34 and "the place he stands on" are all refused, and state is unchanged) |
| `testBackReturnsTheExactAddress` | A→B→C, back to B and then A exactly, anchors included; a noted camera comes back; Home then back returns; an empty stack leads Home; at Home, back does nothing | The camera is lost (planted: `a.place != a`, so equality holds the anchor) |
| `testOneWorldIsMountedAtATime` | `mounted` stays on the old world until the mount beat, and is exactly one of from or to; through two quick crossings it stays the old world until the last one settles | The world swaps at the touch or two worlds are mounted |
| `testTheSpineLaysNothingOverAWorld` | No `.sheet`, `.fullScreenCover` or `.popover` in `Spine/`; exactly one `WorldHost(` in the app | A cover is added, or a second host (planted: two synthetic covers detected) |
| `testWhereHeWasSurvivesARelaunch` | The `journey` file is written; a relaunch arrives at Home (ruling 1) with `before`, the beads in station order (anchors kept) and an empty stack; `OPEN_WORLD` still wins a launch; the JSON round-trips | A bead is lost (planted: relaunched state without beads ≠ saved) |
| `testADayIsWrittenAndReadAsItsDate` | Days are `yyyy-MM-dd` and step ±1 across month ends | Impossible days are accepted (planted: 30 Feb, month 13, "13 Oct" all nil) |
| `testTheCrossingNumbersAreTheWorldFiles` | Every crossing constant (gather, bloom, mount, reach ×2.6, reduced 0.2, dissolve 0.28, veils 1.05/1.5, passage 5.4/0.75, descent 2.35 with seam 55 % and ember 11 pt, blink 0.66/0.78/0.3/0.5, return 45 min/900 ms) is parsed from spine-and-home.md; the four curves and their durations are parsed from visual.md's motion table; every kind's reduced timing is 0.2 s and every mount falls within its crossing | Any constant drifts (planted: `.31` is not found) |
| `testTheKeyframesAreDesignsOwnWords` | The bloom opacity and scale, the ember scale, the plane colours and the fill stops, written in Design's own notation, appear verbatim in the file; the tracks and curves evaluate correctly | A keyframe is retyped (planted: a track one stop off is not found) |
| `testEveryAddressHasALinkAndBack` | Every kp 1–102, road 1–33, world and full address round-trips as a link (the camera excluded); short forms work | A bad link resolves (planted: 8 bad links, all nil) |
| `testTheWalksLaunchArgumentsNameAddresses` | `OPEN_PLACE` and `OPEN_WORLD` parse, the last one wins, RootView reads through `DeepLink.launchAddress`, and DEBUG only | A malformed place is accepted (planted: 6 malformed places, all nil) |
| `testEveryChannelInTheTreeIsBridged` | Every `Notification.Name("…")` declared in the app is one of the 6 bridged channels | A 7th channel appears (planted: an extra name ≠ bridged) |
| `testEachChannelReachesItsRouterCall` | Each channel's notification moves the Router as its row says; the gift is taken once; the Homecoming is owed once | A wrong route (planted: an unknown way leaves state unchanged) |
| `testTheRouterHearsTheChannelsWhileListening` | A post on a NotificationCenter moves the Router, and nothing moves after `stop` | The bridge keeps listening after it is stopped |
| `testTheCrossingCarriesTheColourAndCountsOnlyBetweenWorlds` | A go blooms in the world entered and a back in the world left; `onWorldCrossed` fires only between worlds; `colourResolver` overrides; Reduce Motion gives the 0.2 s cross-fade | A crossing within a world is counted, or the wrong colour is used |

## For the merge and U2

1. **Xcode Cloud bundling.** These tests read `waves/upgrade/worlds/*.md`. On the Mac the checkout is read through `#filePath`. On Xcode Cloud, the "Bundle the source tree" phase must also copy `waves/upgrade/worlds`, or these tests fail there because a missing source counts as a failure. Parts B–D likely need the same. One line in the phase's script (`project.pbxproj`, after the `Design` rsync) does it: `if [ -d "${REPO}/waves/upgrade/worlds" ]; then mkdir -p "${DEST}/waves/upgrade"; rsync -a --delete "${REPO}/waves/upgrade/worlds" "${DEST}/waves/upgrade/"; fi`. I did not add it, to keep `pbxproj` free of conflicts between the four parts.
2. **`testEveryChannelInTheTreeIsBridged` pins exactly six `Notification.Name`s.** If another part adds a channel, this test fails by design. Either bridge it or decide it is not navigation.
3. **`SPINE=1` mounts `SpineRoot` instead of `RootView`.** Under it, RootView's seed, sync and gift tasks and its `.playFieldPresenter()` / `.leelaDrops()` presenters do not run. The placeholders need no data. U2 moves those tasks to the root.
4. **The walk.** Add steps with `SPINE=1` plus `OPEN_WORLD=<id>` (or `OPEN_PLACE`). Each placeholder carries `world.<id>`, `point.home`, `spine.back` and `place.<link>`. Home carries `station.<id>` for all fourteen. `WalkTrace` marks `router.<from>><to>` on every crossing.
5. **The URL scheme.** `bindu` is not registered (`CFBundleURLTypes`). `SpineRoot.onOpenURL` is ready for when it is.
6. **The ledger.** `onWorldCrossed` is the hook for "World Crossed" (§2 H #64). U2 adds the vocabulary to `ActivityLedger` and wires it, keeping the ledger-vocabulary law: the words live only in the ledger file.
7. **Existing engines.** No existing engine was wrapped. The Router replaces nothing yet: it bridges to the six channels and reuses `PracticeVault` (journey), `WalkTrace`, `WorldID`, `WayIn` / `WorldID.reached(by:)`, `GiftRouter` and `PlayGame`.
