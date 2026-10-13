# U2 · B · The spine shell — builder report

Branch `u2-b`, cut from `upgrade` at `ec061f0` (the U2 brief). There is no Swift compiler here, so none of this has been compiled or run. I read every type before calling it, and every touched file passes a bracket-balance check. The Mac build is the first compile.

## What was built (Part B 1–9)

| # | Brief item | Where | What it does now |
|---|---|---|---|
| 1 | New root | `Views/Root/AppRoot.swift`, `Spine/SpineRoot.swift` | `AppRoot` mounts `SpineRoot`, which draws one world at a time from `router.mounted`. Every launch arrives at `.home` (ruling 1, through `NavigationState.relaunched()`). The launch ceremony stands above the root on every launch, unless `SKIP_HOMECOMING` is set or it is the unit-test host. It plays Part A's ceremony if one is registered, otherwise the existing `HomecomingView`. `RootView` and `HamburgerMenuView` are deleted. |
| 2 | The point in every world | `Spine/SpineChrome.swift` (`PointHome`) | Sits top-right on every world except Home (top 16 / right 16 inside the safe area, a 44 pt target), drawn with `ThePoint` at 6 pt, alpha .3, in the world's `PointLook` colour, easing 1.5 s. **Tap** → Home, after a 0.3 s double-tap window. **Hold 0.9 s** (U1-D `HoldDriver`; acts on release, an early release drains) → `router.toSource()` = `Address(.home, kp: 102, sub: "source")` via `.pravesha`. **Double-tap** → the one-second practice (`OneSecondFloorView`) as a spine place. VoiceOver: default action Home, plus named actions "Fall to the source" and "One second". Id `point.home`. |
| 3 | The Constellation | `Spine/ConstellationMenu.swift` | Opened by the 2×2 mark (top-left, first dot crimson, first-run breath; id `spine.menu.mark`) or by a slow pull down from the top. Three faces on one switch: **Constellation** (the fifteen nodes on Home's ring; 17 poetic threads plus the three coloured threads, drawing in over 2.2 s staggered 400 + 80k ms; nodes arrive over .8 s staggered 80 + 55i ms; each breathes 4.2 s; the current world ×1.4 with a double glow; unbuilt worlds at .42), **List** (76 pt live discs, Cormorant italic 28, "this has not yet been composed" under placeholders) and **Veil** (by depth: the sky, the gates, rings I–VIII, the terraces, the Bindu footer IX, below the ground). Touching a world crosses there with its registry arrival crossing, and sounds `SoundMixer.hum`. The foot holds **Settings** and the coda "The only winning move is to play." Drawn above every world, never under a cover. |
| 4 | Doors along the threads | `Spine/ThreadDoors.swift` | `ThreadDoors(address:)` is reusable by any world. For each thread the address carries (kp, chakra, day) it shows a 52 pt disc to every other world that thread reaches (`WorldRegistry.doors`). Today appears only when the kp is today's. The Relationship Field appears only for kp 31/40/42. Two neighbour doors per thread (kp 1↔102, chakra 1↔33, day ±1). Kicker: "the same {Śakti, chakra or day} · in {world}". On a touch the world leans toward the destination's colour (.55 s), and the crossing begins at 520 ms from the disc. Pure plan: `ThreadDoorPlan`. Placeholders already use it. |
| 5 | Search | `Spine/SpineSearch.swift` and the menu head | Prompt: "Type one word you're carrying". The query is folded: case-, diacritic- and width-insensitive, punctuation removed. Each Śakti carries four spellings: name, `MandalaVoice.romanised(name)`, phonetic, short name (plus Devanāgarī). Each opens by position as `herHome kp`. Also indexed: the 33 by name, Sanskrit and verb (→ `the33 chakra`; sealed room 32 keeps only its public identity), the modes (→ `modes sub`), every game (→ `game sub`) and the fifteen worlds. Results come in index order, never ranked or scored. No lookup closure touches `.name` (law). |
| 6 | Back | `SpineRoot` (`SpineGesture`), `Router.backFromEdge`, `Router.back` | A leading-edge swipe (≤ 22 pt start, ≥ 72 pt travel) returns to the exact address: under the return bloom if he left that place within 45 min (#52), otherwise the bloom in the colour he left. Esc and the VoiceOver escape do the same. `back()` first closes an open menu or spine place in place. Two backs within 0.35 s count as one gesture, so the root's edge and a world's own way out heard together go back one step. A fast swipe down from the top (> 600 pt/s) → Home (the ReturnArc, #66). |
| 7 | Crossings, sound, ledger | `SpineServices.arrived`, `SpineServices.worldCrossed`, `ActivityLedger` | U1's `CrossingOverlay` plays on every Router change (unchanged). Each mounted world calls `SoundMixer.shared.enter(world, ring:)` (bed crossfade 2.6 s, threshold pitch once, after the first touch; `.soundWakesOnFirstTouch()` is on the root). One **World Crossed** row is written per crossing between worlds through `Router.onWorldCrossed`. It carries Gesture Source = the world left, Detail "from {world} to {world}", Link to Mandala when a kp is carried in, and Link to The Map when a chakra is. The vocabulary lives only in `ActivityLedger.swift`, which gains `ActivityType.worldCrossed` and Gesture Source options Home · Chakra · Climb · Time · Relationship · Beneath · Game · Modes. "World Crossed" is added to `LawsTests.eventVocabulary`. |
| 8 | The six channels and the presenters | the posters (table below) | Each poster calls its Router method, and every `Notification.Name` is gone. `RouterBridge.swift` is deleted. `.playFieldPresenter()` and `.leelaDrops()` are deleted. |
| 9 | The walk | `Bindu MandalaUITests/TheWalk.swift` | Walks: by the menu (14 worlds plus Home, then Settings as a place, left by the edge), by station + point (each station from Home, the point back), by search (14 worlds by display name), back (Home → Well → Time, edge → Well, edge → Home), by address (`OPEN_WORLD`, all 15), and a relaunch that arrives at the Bindu. Every arrival asserts that **exactly one** `world.*` sentinel is in the tree. Records go to `WALK_OUT/<WALK_WAVE default U2>/…`. |

### Where every screen and responsibility of the old root went

| `RootView` / `AppRoot` did | now |
|---|---|
| `Destination` switch of five rooms + `.id` swap | `SpineRoot` + `WorldHost(router.mounted)`. The rooms are hosted as worlds by Part C. |
| Launch → `.rite` or same-day `last_destination` | Launch → `.home`. `last_destination(_day)` are no longer read or written (left in UserDefaults, nothing deleted). |
| `START_TAB=` | Retired. Use `OPEN_WORLD=` or `OPEN_PLACE=`. |
| Hamburger + 5-room veil + first-run breath | The Constellation and the 2×2 mark. `hamburger_first_run_seen` is inherited as the default of `menu_mark_first_run_seen`. |
| Settings `.sheet` | `Router.open(place: .settings)`, drawn in place of the world (the world kept alive, hidden, untouchable). Left by the edge, Esc, the menu, or any crossing. |
| Bootstrap `.task` (seed, descent seed, backfill, summons hour, prime summons & gifts, sync, reschedule summons, gift fortnight) | `SpineServices.bootstrap(context:router:)`: same calls, same order, quiet in the test host. |
| `landOnGift()` → ShaktiDetail cover "the gift" | `GiftRouter` → `Router.giftOpened(kp:)` = Home, `sub: "card"` (§2 J #72), also taken at launch by `SpineServices.landAnyGift`. Part A must open her card for that sub-place. |
| Recognition → Portrait, from Today only | `Router.recognitionSettled` → Memory from **every** source (#73). Back returns him. |
| `MandalaWays.notification` → Mandala | `MandalaWays.ask` → `Router.askWay` → the world the way reaches (`.road` → the 33). `pending`/`take()` kept (CoherenceTests). |
| `.playFieldPresenter()` (two covers) + `OPEN_PLAY` | `PlayField.open` → `Router.openPlay` → A Strange Game, `sub` = game raw value. `OPEN_PLAY[=game]` is now read as an address by `DeepLink.launchAddress`. |
| `.leelaDrops()` overlay (zIndex 90) | `SpineServices.considerLeela`, 9 s after arriving at Home with the scene active, with his own limits in `LeelaDrops.draw()` → `Router.leelaDropped` → `game` at `leela.<id>`. `WorldHost` draws `LeelaDropPlace` (the existing `LeelaDropView`) in its own space, and the answer writes the one Leela Drop row and goes back. Skipped in the test host and snapshot launches. |
| `HomecomingView.reEnterNotification` → re-present | `HomecomingView.reset()` → `Router.reEnterHomecoming()` → `AppRoot` takes `pendingCeremony` and plays it at Home. |
| `HomeAfterEffect.didLeave` → `HerSiddhiLingers` | `HomeAfterEffect.left` → `Router.leftHerRoom`, and `HerSiddhiLingers` observes `Router.shared.afterEffect`. |

## Contracts for Parts A and C (and the merge)

1. **Registering worlds without touching my files.** `SpineRoot.init` calls `SpineWorlds.registerAll()`, which calls `registerHome()` then `registerHostedWorlds()`. Both have empty defaults on a protocol extension. Each part declares its own member, which shadows the default:
   ```swift
   extension SpineWorlds { static func registerHome() { WorldBuilders.register(.home) { AnyView(HomeWorld(address: $0)) } } }          // Part A
   extension SpineWorlds { static func registerHostedWorlds() { WorldBuilders.register(.today) { … } … } }                            // Part C
   ```
   If a part registers some other way, the merge adds one call inside `SpineWorlds.registerAll()` (`Spine/WorldRegistry.swift`). A world nobody registers draws its `WorldPlaceholder`: name, colour, thread doors, "return", and its sentinel.
2. **Launch ceremony (Part A):** `WorldBuilders.registerLaunch { done in AnyView(…) }`. Call `done()` once the ceremony gives way to Home. Without it, `HomecomingView` plays as today. **Do not also present the Homecoming inside Home**, or it plays twice.
3. **Sub-places the spine names** (`Spine/Address.swift`):

   | sub-place | address | who must read it |
   |---|---|---|
   | the source | `Address.source` = home, kp 102, `"source"` | Part A: Lalitā source. The point's hold arrives here. |
   | her card | home, kp N, `"card"` | Part A. A gift arrives here. |
   | a ring | `Address.ringPlace(n)` = rings, `"ring.<n>"`, read back with `.ringNumber` | Part C. The Veil face of the menu sends these. |
   | a game | game, `sub` = `PlayGame` raw value | Part C. |
   | a mode | modes, `sub` = `TheModes.Mode` raw value | Part C. |
   | a Leela drop | game, `"leela.<id>"` | Never reaches Part C's builder; the spine draws it. |
4. **Chrome:** the spine draws the 2×2 mark on **every** world, Home included, and the point on every world **except** Home. Part A should not draw a second mark at Home; the merge removes one if both appear. Neither part draws a second point. Worlds that place controls at the top-left or top-right should leave the two 44 pt corners on the line at safe-top + 16.
5. **Ids the walk uses:**
   - `world.<id>` on each world's root container (`.accessibilityElement(children: .contain)` + `.accessibilityIdentifier(WorldID.x.sentinel)`). Exactly one may exist at a time.
   - `station.<id>` on Home's fourteen stations. The walk taps once and, if the world has not arrived in 3 s, taps again (card first, then cross).
   - `point.home`, `spine.menu.mark`, `spine.menu`, `menu.node.<id>`, `menu.row.<id>`, `menu.veil.<id>` / `menu.veil.ring.<n>`, `menu.face.<face>`, `menu.search`, `search.result.<kind>|<link>`, `menu.settings`, `menu.close`, `spine.place.<place>`, and `door.<world>.<thread>` / `door.<thread>.previous|next`.
6. **Leaving words:** every in-world "back/close" should call `router.back()`. The root's edge swipe is simultaneous with any world's own edge; the 0.35 s debounce stops a double step.

## Every file touched

New:
- `iOS/Bindu Mandala/Spine/SpineChrome.swift` — `SpineChrome`, `PointHome` (rewritten), `ConstellationMark`
- `iOS/Bindu Mandala/Spine/ConstellationMenu.swift` — `ConstellationLayout`, `ConstellationMenu`, `MenuMarkGlyph`, `ConstellationField`, `MenuList`, `MenuVeil`
- `iOS/Bindu Mandala/Spine/ThreadDoors.swift` — `ThreadDoor`, `ThreadDoorPlan`, `ThreadDoors`
- `iOS/Bindu Mandala/Spine/SpineSearch.swift` — `SpineSearchEntry`, `SpineSearchShakti`, `SpineSearch`
- `iOS/Bindu Mandala/Spine/SpineServices.swift` — `SpineServices`
- `iOS/Bindu Mandala/Views/Root/AppRoot.swift` — `AppRoot` (moved out of `BinduMandalaApp.swift`, no longer private), `LaunchCeremony`
- `iOS/Bindu MandalaTests/U2SpineTests.swift`
- `waves/upgrade/briefs/U2-B-report.md`

Changed (Spine/, mine):
- `Spine/SpineRoot.swift` — rewritten: the root, `SpineGesture`, `SpineEscape`, `WorldHost` (Leela intercept), `SpinePlaceView`, `LeelaDropPlace`, `WorldPlaceholder`. The placeholder no longer draws its own point or edge.
- `Spine/Router.swift` — `shared` keeps no journey in the test host; `MenuFace`, `SpinePlace`, `menuFace`, `place`, `openMenu` / `closeMenu` / `open(place:)` / `closePlace`, `backFromEdge`, `toSource`; back closes menu/place first and is debounced 0.35 s (not when `settlesInstantly`); every crossing closes menu and place.
- `Spine/Address.swift` — `sourceSub`, `sourceKP`, `source`, `ringSubPrefix`, `ringPlace(_:)`, `ringNumber`, `leelaDropID`.
- `Spine/WorldRegistry.swift` — `WorldBuilders.launchCeremony` / `registerLaunch`; `SpineWorldsRegistering`, `SpineWorlds.registerAll()`.
- `Spine/DeepLink.swift` — `OPEN_PLAY` → address; `SpineLaunch` (`SPINE=1`) removed: the spine is always the root.

Deleted:
- `Spine/RouterBridge.swift`
- `Views/Root/RootView.swift`
- `Views/Root/HamburgerMenuView.swift`

Changed outside my folders. These are the minimal line-level edits item 8 requires, plus one ledger addition item 7 requires:
- `BinduMandalaApp.swift` — the private `AppRoot` was removed (now in `Views/Root/`). `AppRuntime` is untouched.
- `Data/ActivityLedger.swift` — `ActivityType.worldCrossed`, eight Gesture Source options, `gestureSource(leaving:)`, `worldCrossed(from:to:mandalaLink:mapRecordId:at:)`.
- `Views/Recognition/RecognitionMomentView.swift` — `didSettleNotification` removed; `settle()` → `Router.shared.recognitionSettled`.
- `Views/Mandala/WaysIn.swift` — `MandalaWays.notification` removed; `ask` → `Router.shared.askWay`.
- `Views/Mandala/LivingMandalaView.swift` — **three lines removed**: the `.onReceive(MandalaWays.notification)`. Part C edits this file heavily; any conflict is this one hunk, and deleting it is the resolution.
- `Services/EnergyGift.swift` — `GiftRouter.openNotification` removed; the delegate → `Router.shared.giftOpened`.
- `Views/Play/PlayGame.swift` — `PlayField.openNotification` removed; `open` → `Router.shared.openPlay`.
- `Views/Play/PlayFieldView.swift` — `PlayFieldPresenter` and `.playFieldPresenter()` removed. `PlayFieldView` and `PlayGameHost` remain for Part C.
- `Views/Common/HomecomingView.swift` — `reEnterNotification` removed; `reset()` → `Router.shared.reEnterHomecoming`. Only `reset()` changed; Part A may edit `finish()` freely.
- `Homes/HomeAfterEffect.swift` — `didLeave` removed; `left(ring:)` → `Router.shared.leftHerRoom`.
- `Views/Rooms/HerSiddhiLingers.swift` — listens to `Router.shared.afterEffect`.
- `Services/LeelaDrops.swift` — `LeelaDropPresenter` and `.leelaDrops()` removed. `LeelaDropView` is kept and is used by the spine.
- `Bindu MandalaTests/U1RouterTests.swift` — the `RootView` assertion now checks that `Router.swift` reads `DeepLink.launchAddress(`, and that `RootView` is gone. The three bridge tests are replaced by `testNoNotificationChannelIsLeft` (no `Notification.Name`, each poster calls its Router method, no global presenter) and `testEachPosterReachesItsRouterCall`.
- `Bindu MandalaTests/LawsTests.swift` — "World Crossed" added to `eventVocabulary`.
- `Bindu MandalaUITests/TheWalk.swift` — rewritten on the spine (above).

## API assumptions not verified by a compiler

- **`SpineWorlds` shadowing.** A static member declared on `SpineWorlds` in another file is chosen over the protocol-extension default when `registerAll()` calls `registerHome()` unqualified. This is Swift's usual "concrete type member beats protocol extension member" rule.
- **`@MainActor` on SwiftUI view structs** (`SpineRoot`, `PointHome`, the menu views, `ThreadDoors`, `AppRoot`). With it, the `@StateObject HoldDriver(...)` default and the calls into the `@MainActor` Router compile on both the Xcode 15 and Xcode 16 SDKs.
- **Posters outside the main actor** call `Task { @MainActor in Router.shared.… }`. This makes the route asynchronous by one run-loop turn.
- **Observation tracking.** `.onChange(of: Router.shared.afterEffect)` inside a `ViewModifier` body and `.onChange(of: router.pendingCeremony)` in `AppRoot.body` track the `@Observable` Router.
- **Gestures.** `.simultaneousGesture(DragGesture(minimumDistance: 12, coordinateSpace: .global))` at the root is heard alongside every world's own gestures. A UIKit-backed `ScrollView` may swallow a drag once it scrolls, so the edge may not fire over a scrolling list; the world's own way out remains.
- **Hardware Esc.** It works through a 1×1, .001-opacity, non-hit-testable `Button` with `.keyboardShortcut(.escape, modifiers: [])`.
- **Settings as a place.** `SettingsView` is shown without a presentation. Its `@Environment(\.dismiss)` then does nothing, which is harmless: re-entering the Homecoming crosses Home, and the crossing closes the place. Its own `.fullScreenCover` (the film) still presents.
- **`OneSecondFloorView(isPresented:)`** is bound to `router.place == .oneSecond`.
- **Canvas drawing.** `ForEach(Array(WorldID.allCases.enumerated()), id: \.element) { i, w in … }` relies on tuple destructuring. `Canvas { g, _ in }` passes the `GraphicsContext` by value to a helper that strokes.
- **`String.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale:)`** followed by an alphanumerics filter. Devanāgarī is folded the same way on both sides of the match.
- **`AppRuntime.isUnitTesting` / `PracticeVault.defaultDirectory`** are nonisolated statics read inside `Router.shared`'s initialiser.

## Choices made from the evidence (open to review)

- **Pull band.** The slow pull and the ReturnArc swipe start within 140 pt below the safe top, not "anywhere", so a world's own scrolling is never read as the menu.
- **Mark position.** The mark sits on the same line as the point (safe-top + 16), mirrored left. Design's "top 62 / left 26" is measured from the phone frame's top, status bar included.
- **One touch crosses.** The brief says "touching a world crosses there", so the menu node and the thread door cross on one touch. Design's card-first appears only on Home's stations (Part A).
- **Menu crossings start from the point.** A menu node crosses with no touch origin, so the bloom opens from the point at (W/2, .46 H). The field's coordinates are not the window's.
- **The point's colour** is `PointLook.forWorld(world).core` at .3, easing 1.5 s (#37). #36's fixed `#C0392B` is kept as `PointHome.hex` for reference.
- **Tap timing.** A single tap on the point waits .3 s for a possible double-tap. A press counts as a tap under .35 s and 9 pt.
- **Gesture Source for crossings** from worlds without a new option: rings and her presence → Mandala, her home → Room, memory → Mandala.
- **Veil face placement.** The Veil lays the worlds by depth as: sky (Time, Memory) · gates (Today, Mandala) · rings I–VIII · terraces (Her Presence, Her Home, the 33, Climb, Game, Modes, Relationship) · the Bindu footer IX · below the ground (Well, Beneath). Design places only some of these, so the terraces are my placement.

## Not built in U2 · B (named in spine-and-home but outside the brief's nine items)

The rope (#34), the quiet bar (#43), the die (#45), "?" (#46), the Margin in the chrome (#94), the ground mark (#38), the point carried by `matchedGeometryEffect` across crossings (#37 is approximated by the colour ease), the list's pitch "as the finger passes" (it hums on touch instead), neighbour doors ordered by neighbourhood (plain ±1 for now), the `bindu` URL scheme in `Info.plist` (`onOpenURL` is ready), and Home's `SoundGlyph` placement (Part A).

## For the Mac session

1. **Other UI suites will fail until retargeted.** They reach screens by `START_TAB=` or the unlabelled top-trailing hamburger: `MandalaLightReachTests`, `AccessibilityReachTests`, `TheLibraryFoldUITests`, `FeltRegisterSnapshots`, `HitAreaTests`, `TheWayInUITests`, `TheMarginUITests`, `SpikeColdLaunchTests`, `BinduMandalaUITests`. Map each `START_TAB=x` to `OPEN_WORLD=`: mandala → mandala, rite → today, well → well, 102 → rings, memory → memory. The hamburger becomes `spine.menu.mark`. `MandalaLightReachTests` :176 and :211 are retargeted to the 2×2 mark, as spine-and-home #96 asks.
2. **Two Oms are possible.** The U1 mixer is now entered on every crossing and woken on the first touch, while `RingAudioService` / `HomeSoundService` / `SoundConductor` still sound in the Mandala and the rooms. If two Oms are heard, follow U1-B's note: stop `RingAudioService.omStart` and move `SoundArbiter.gains` to `MixLaw.conductorGains`.
3. **The walk depends on the other parts:**
   - Part A's Home must carry `world.home` and `station.<id>`.
   - Each world Part C hosts must carry its `world.<id>` sentinel, with no cover or overlay leaving a second one in the tree.
   - Screenshots go to `BinduWalk/U2/<run>/` (`WALK_WAVE` defaults to `U2`).
