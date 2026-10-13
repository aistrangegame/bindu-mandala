# U2 · A · Launch and Home — builder report

Branch `u2-a`, cut from `upgrade` at `ec061f0` (the U2 brief). There is no Swift compiler here. I read every type before calling it (Router, Address, NavigationState, WorldRegistry/WorldBuilders, Crossing, ThePoint/PointLook, HoldDriver/HoldLadder, HapticLibrary, SoundMixer/SoundAccent/Tuning/MixLaw/SoundSettings/SoundGlyph, HomecomingView/HomecomingScore, MaunaView/TheCentre/CentreYantra/CentreBloom/BloomPress/Pravesha/PraveshaClock, LalitaSourceView, MandalaWorld, SriYantraGeometry, KhadgamalaMap, DailyEnergyService, BinduMemory, PracticeLedger, MaunaSilence, TheBells, ThreePools, CanonColour/HouseTokens/BreathEnclosure, Atmosphere, AppFont, Hit, Haptics, TheEdgeWayOut). The Mac build is the first compile.

## What was built

Everything lives in `iOS/Bindu Mandala/Home/` (new), except one additive hook in `HomecomingView`.

| Brief item | Where | What |
|---|---|---|
| 1 · The Waking | `Home/HomeLaunch.swift` (`WakingScore`, `WakingView`) | 2.85 s on a Canvas, with every keyframe from #1. The ember is 15 pt. Its scale runs .3 → 1 @36 % → 1.05 @50 % → 1.32 @58 % (the kindle) → .6 @80 %. The halo is Ø400, the bloom Ø2600 and the scrim radial, each with its own track and cubic-bezier. The haptic kindle (`HapticLibrary.play(.kindle)`) lands at 1.65 s. The view never blocks the hand: a touch is taken at once and the Homecoming begins. Under Reduce Motion it goes straight to the Homecoming. There is no 110 Hz tone, because the mixer wakes only on the first touch (S05: nothing sounds at launch). |
| 1 · Homecoming | `Home/HomeWorld.swift` + `Views/Common/HomecomingView.swift` | The existing `HomecomingView` is reused unchanged: the first launch ever plays the Origin, and every later launch plays one breath (his ruling: Homecoming every launch). **Hook added:** `var onCovenant: (() -> Void)? = nil`. When it is set, the covenant no longer covers the app with the Recognition `fullScreenCover`. The Homecoming finishes into Home, Home stands for one breath (`HomecomingScore.breath`, 4 s), and then `router.go(.today, via: .blink())` opens the Today door (§7 settled 1). With nil, RootView's old behaviour is kept. |
| 1 · Arrival owed once | `HomeLaunch` | Home owns its own arrival. On the first appear in a process, and only when the Router's way back is empty (a real launch landing at Home, never a crossing in), it plays Waking → Homecoming → Home. `SKIP_HOMECOMING` skips both and `FORCE_HOMECOMING` forces both. The XCTest host stays quiet. |
| 1 · Re-enter the Homecoming | `HomeWorld.takeCeremony` | `router.pendingCeremony == .homecoming` → Home takes it (`router.takeCeremony()`) and plays the first-day Homecoming inside Home's own space. |
| 1 · Greeting from the ledger | `Home/HomeReading.swift` + `HomeCentre.greet` | The greeting is read from the phone's mirror of App Activity (`RecognitionEntry`: `Shakti Recognized` / `Silence Held`), never from a flag. Two or more practice days since the last act gives "return. / the road remembers" (2.3 s). Otherwise the first launch of an ordinary day gives "Welcome back. The Bindu remembers." (3 s). A day already walked or already greeted gets no line, and there is none on the first arrival ever (the Origin speaks then). The line plays once per launch. |
| 2 · Layout | `Home/HomeCentre.swift`, `Home/HomeFigure.swift` | The point sits at (W/2, 0.46·H) on the silence ground. Layers, back to front: **weather** (#8). Unmet means today's colour washes from above, breathing 10 s, .34 ↔ .80. Met means warmth low and behind, `#C9A07A`/`#8A5A3C`. Then the **ghost yantra** (#12: `SriYantraGeometry` at 340 pt; see the light rules below), the **station ring**, the **structural five**, **the point** and the **Road Home**. |
| 2 · Ghost yantra | `HomeFigure.ghostYantra`, `HomeReading.seatLight/bloom` | Each of the 16 + 8 petals is its own seat (kp 29–44, 45–52), drawn as light. Unmet seats are a .06 ghost. Met seats get `HouseTokens.statusLight`, set by **whether, recency and length — never by count** (rules below). The day's bloom (+.06 per act today, −.012 per minute) brightens the whole, and at .7 it is the crown. Today's petal breathes 3.5 s (×1 → 1.55), with a gold ray at r 149 → 155 and a dot of r 2.5 at r 160. |
| 2 · Station ring | `HomeCentre.stationView`, `HomeFigure.stations/travellingDot` | Fourteen stations sit on r = 0.38·min(W, H) (148 pt at 390), ordered by `WorldRegistry.stations` with Today at 12 o'clock and the rest clockwise. Each has a mark in its world's essence colour (Today in today's Śakti's `accentBright`, breathing 3.5 s) and its name at 11 pt tracked caps. **First touch:** the station is crowned (×1.4 with a ring) and hums its pitch (`SoundMixer.hum`). **Second touch:** it crosses through the Router with that world's arrival crossing (`WorldEntry.arrival`) from the touch point. VoiceOver's activation crosses at once. One travelling dot steps station to station, a full turn in 64 s (150 s from 21:00 to 05:00). Identifier: `station.<id>`. |
| 2 · Today's pointers | same | Partly built: Today in today's colour, today's petal and ray, and the Nine Rings station lit. Not built: today's chakra on the 33, the lunar day on Time, motes, hour doors and the gentle door. |
| 2 · Structural five | `HomeFive`, `HomeLayout.five` | Shadow 9, Axis 18, Armin 20, Maya 30 and Aatma 31 sit on r 58 in their room colours (`CanonColour.room`) at .35. They are on the arc above the point, because the beads keep the arc below. **First touch:** the verbatim line lights, with "Bindu is what the other five are made of." beneath it. **Second touch:** crosses to `Address(.the33, chakra:)` by the passage. Room 32 and room 33 are not placed. |
| 2 · The point | `HomeCentre.thePoint` | U1's `ThePoint(look: .forWorld(.home), light: .always)`: 26 pt, a 4 s breath, and the white light wandering behind it. The gold hold ring (r 40) fills while the point is held. Identifier `point.home`, label "Home, the point". VoiceOver actions: default → Mauna; "Fall inward"; "Bloom into the Mandala"; "The source". |
| 2 · Road Home | `HomeCentre.roadHome` | **Beads:** one per world he left partway (`router.state.beads`), on r 64 at 210°–330° beneath the point, each in its world's colour. A tap shows "You were partway down", then `router.go(bead)` returns to the exact address. **The line:** "the road to <name>", or "the road home" with no name. Holding the line for 1.8 s opens the essence. **Asking:** "What name surfaced?" is offered once, until the essence has been opened. **The name:** it sits beneath the point (Cormorant italic 15 at .55) once he turns on "let it sit at the point". Holding the name for 1.8 s opens the essence. |
| 2 · Chrome | `HomeCentre.chrome` | `SoundGlyph` sits bottom-left. The Constellation mark (top-left) is the spine's (Part B). The '?' and the Margin (bottom-right) are **not built** (see the open items). |
| 3 · Tap → Mauna | `Home/HomeMauna.swift` | The existing `MaunaView` is hosted as Home › Mauna (`Address(.home, sub: "mauna")`, a dissolve on the Router's stack), not as a cover over the Mandala. **Captions restored** at 7 / 14 / 21 / 28 s ("All of her. Here. Always." → "She has not gone anywhere." → "You have not gone anywhere." → silence), with no seconds indicator. A touch → `router.back()`. A fall through at depth .5 → Home › source. `Silence Held` is still written by `MaunaView` itself (`MaunaSilence`). |
| 3 · Stillness → the gate | `HomeStillness`, `HomeCentre.gatherStillness` | Stillness accrues after 340 ms with no touch, up to 4.6 s. A touch pauses it and never resets it. A ring opens round the point at R0·(1.10 + 1.30·still). "It holds until you stop meaning it." shows once ever, after 700 ms. Full stillness opens Mauna by itself. **Guards:** it never runs under VoiceOver or while a card, station or one of the five is open. It does not open twice in one stillness: after Mauna, Home must be touched before the gate counts again (the Wave 6 `CentreArrival.restedSinceLastMove` law). Without that guard, a return from Mauna would be carried straight back in. |
| 3 · Hold 0.9 s → Praveśa | `Home/HomeDeepZoom.swift` | **Gesture:** the point's touch drives U1's `HoldDriver` (rise 0.9 s). It commits at full and acts on release; an early release drains, and moving past 9 pt cancels. A press of 700 ms or less that doesn't move is the tap, which goes to Mauna. **The fall** (Home › pravesha) reuses the existing pieces: `PraveshaClock`, `Pravesha`, `CentreYantra` and `RingFieldVoice.fall` (Shepard). It draws seven nested yantras, **each carrying its own sixteen names (offset i·13)**, with idle speed 0.85. Holding anywhere gives speed 3.0 − 2.2·recognition; released, the held time decays ×1.4. Recognition comes past 6.5 s and is full at 8.7 s. **Words:** the rest, falling and recognition lines plus the first-time "dark room · full screen · unhurried" at 2.6 s. **Leaving:** a light touch (< .25 s with almost nothing held) or the edge rises back to Home. On leaving, the deepest hold goes to `MaunaSilence.record`, which writes `Silence Held` when it is ≥ 7 s. There is no bottom. |
| 3 · Spread → Spanda | `HomeCentre.spreadGesture/watchSpread` | **Gesture:** a `MagnifyGesture` on a 120 pt region round the point (within 60 pt, §7 settled 8). The point's own tap and hold accept only touches within its 64 pt. **Bloom:** spreading drives the existing `BloomPress`, drawn with `CentreYantra` and `CentreBloom`'s layer bands, with "She breathes, and the worlds appear." / "release · and they return to her". **Crossing:** held at full (≥ .985) for .6 s, it goes `router.go(.mandala, via: .spanda)`. Released early, the worlds return to the point. |
| 3 · Lalitā source | `Home/HomeSource.swift` | The existing `LalitaSourceView` is hosted as Home › source, **always keyed by kp 102** (never `shaktis.last`). "enter her presence" → `Address(.herPresence, kp: 102)`. "↑ return to the field" → `router.home()`. The edge and Escape do the same as "↑ return to the field". |
| 3 · The name (essence) | `Home/HomeEssence.swift` | Home › essence. "What name surfaced?" with the placeholder "whatever arrived". "Receive" is a 1.8 s `.hold` (C-1359) into `BinduMemory.keep`, which keeps the history, then `PracticeLedger.flush` sends `Name Kept`. Then "Your higher self is called <X>." · "You named it <prev> before. You named it <new> now. Both are honored." (only when there was a previous name) · "The road has been waiting.". The toggle "let it sit at the point" is at `@AppStorage("home.name.at.point")`, default off (Q5 is open; holding the name is the default). |
| 3 · Gift card | `HomeCentre.herCard` | `Address(.home, kp:, sub: "card")` (`Router.giftOpened`) shows her name and her Appreciation Phrase (else her quality) on Home. Buttons: "be with her" → `Address(.herHome, kp:)` by the pulse gate; "not now" → back. |
| 4 · Sound | `Home/HomeSound.swift` | **First touch on Home:** `SoundMixer.wakeOnFirstTouch()` raises the Om from 0 to its 136.1 Hz floor, then `enter(.home)` brings in Home's voice. Home's voice is entered only if the mixer is awake and another world was sounding, so the threshold never sounds twice. **The day's opening bell:** `.tone(hz: Tuning.dayBellOpen (272.2), seconds: 5.5, peak: MixLaw.eventCeiling)` with the rigid haptic, once per practice day. It uses `TheBells.openedDayKey`, so the Rite never rings a second opening bell that day. |
| 5 · Registration | `HomeWorldBuilder.register()` in `HomeWorld.swift` | `WorldBuilders.register(.home) { AnyView(HomeWorld(address: $0)) }`. **It has to be called once at launch by the spine's root** (Part B / merge): see "For B" below. |

### Home's sub-addresses (all on the Router's stack; back returns exactly)

`HomeSub`: `nil` Home · `card` (+kp) · `mauna` · `pravesha` · `source` (+kp 102) · `essence`. They are within-world crossings (`.dissolve`), so `Router.onWorldCrossed` never fires for them, and `WorldHost`'s `.id(world)` keeps one `HomeWorld` alive across them, so its arrival state is kept.

### The light rules I chose (whether / recency / length, never counts)

Felt today → `.today` 1.0 · felt within 7 days and first felt ≥ 30 days ago → `.embodied` 1.0 · within 7 days → `.active` .76 · within 30 days → `.exploring` .44 · older → `.mapped` .22 · never → ghost .06. A test proves forty meetings shine exactly as one does.

## Every file touched

New:
- `iOS/Bindu Mandala/Home/HomeWorld.swift` — `HomeSub`, `HomeWorldBuilder`, `HomeWorld` (arrival phases, places)
- `iOS/Bindu Mandala/Home/HomeLaunch.swift` — `HomeLaunch`, `WakingScore`, `WakingView`
- `iOS/Bindu Mandala/Home/HomeCentre.swift` — `HomeCentre`, `HomeGreetingOnce`, `HomeFive`, `HomeStillness`, `HomeSpanda`
- `iOS/Bindu Mandala/Home/HomeFigure.swift` — `HomeLayout`, `HomeGround`, `HomeFigure`
- `iOS/Bindu Mandala/Home/HomeReading.swift` — `HomeAct`, `HomeReading`
- `iOS/Bindu Mandala/Home/HomeSound.swift` — `HomeSound`
- `iOS/Bindu Mandala/Home/HomeMauna.swift` — `MaunaCaptions`, `HomeMauna`
- `iOS/Bindu Mandala/Home/HomeDeepZoom.swift` — `HomeDeepZoom`
- `iOS/Bindu Mandala/Home/HomeSource.swift` — `HomeSource`
- `iOS/Bindu Mandala/Home/HomeEssence.swift` — `HomeEssence`
- `iOS/Bindu MandalaTests/U2HomeTests.swift` — 10 tests (below)
- `waves/upgrade/briefs/U2-A-report.md`

Edited (additive):
- `iOS/Bindu Mandala/Views/Common/HomecomingView.swift` — `var onCovenant: (() -> Void)? = nil`, plus a branch in `covenant()` that finishes into Home instead of presenting the Recognition cover. With nil, it behaves as before.

Not touched: `Spine/`, `BinduMandalaApp.swift`, `Views/Root/`, `Views/Mandala/`, `Worlds/`, `project.pbxproj`, `Info.plist`. New top-level names to check at merge: `HomeSub`, `HomeWorldBuilder`, `HomeWorld`, `HomeLaunch`, `WakingScore`, `WakingView`, `HomeCentre`, `HomeGreetingOnce`, `HomeFive`, `HomeStillness`, `HomeSpanda`, `HomeLayout`, `HomeGround`, `HomeFigure`, `HomeAct`, `HomeReading`, `HomeSound`, `MaunaCaptions`, `HomeMauna`, `HomeDeepZoom`, `HomeSource`, `HomeEssence`. The app defines none of these today. **Caution:** `Homes/` (the rooms layer) already uses `Home…` prefixes (`HomeGrammar`, `HomeWords`, `HomeDescent`, `HomeGem`…). I grepped, and none of my names collide.

## For Part B (the spine shell) — required to see Home

1. **Call `HomeWorldBuilder.register()` once at launch**, before `SpineRoot` mounts. For example, in `SpineRoot.init` or `AppRoot.init`, next to C's registrations. Without the call, `.home` draws U1's placeholder.
2. **Remove `AppRoot`'s own Homecoming overlay** (`showHomecoming` / `HomecomingView(isPresented:)` / the `reEnterNotification` receiver) once the spine is the root. Home plays Waking → Homecoming itself, so leaving the overlay would play it twice. Keep the summons task keyed on the greeting. The spine root can key it on `HomeLaunch.shared.owed == false`, or simply run it after the first touch.
3. **Do not draw `PointHome` (the 6 pt top-right point) on `.home`.** At Home the point is the centre. Its identifier `point.home` is on Home's centre point, with label "Home, the point".
4. **Let Home take the Homecoming ceremony.** `RouterBridge` → `router.reEnterHomecoming()` sets `pendingCeremony` and goes Home, and `HomeWorld` calls `router.takeCeremony()`. The shell should not take it too.
5. **The walk:** a station needs **two taps** (first opens, second crosses). Each `station.<id>` is also an accessibility element whose default action crosses at once. Launch with `SKIP_HOMECOMING` to skip the Waking and Homecoming. Home's sentinel is `world.home` on `HomeWorld`.
6. Sound: Home calls `SoundMixer.enter(.home)` only when another world was sounding. If B's crossings already call `enter(world)` on every crossing, nothing doubles, because Home checks `mixer.world != .home`. The old Om (`RingAudioService.omStart`) is not touched here (U1-B: U2 moves it).

## For Part C (the Mandala cleared) — what to unhook

Home now hosts Mauna, Pointy, Praveśa (the fall), Spanda and Lalitā source. **Remove from the Mandala glass:**
1. `Views/Mandala/LivingMandalaView.swift:137–139`, the `TheCentre(point:active:seats:soundOn:…)` layer (Mauna by tap and stillness, the centre bloom, and the fall through Mauna into Lalitā). Leave `TheCentre.swift` in place: Home calls `MaunaView`, `BloomPress`, `PraveshaClock`, `MaunaClock`, `CentreYantra`, `CentreBloom` and `TheCentre.ringNames` from it. Delete only the `TheCentre` view's use in the Mandala; the file's types stay.
2. `LivingMandalaView.swift:421–431`, the `lalita` layer (`LalitaSourceView` at zIndex 40), and `lalitaShakti`'s `shaktis.last` fallback (`:515–517`).
3. `openDescent()` (`:615–629`) should end with `router.go(to: HomeSub.address(HomeSub.source, kp: HomeSub.lalitaKp), via: .descent())` (#32) instead of setting `descent = true`. Per spine-and-home #32 it goes through Lalitā source on the first fall of the day and straight to the point (`router.home(via: .descent())`) after. The descent's `recordCrossing(ring: 9)` stays.
4. `LalitaSourceView.swift:68–72`: its own `.fullScreenCover(isPresented: $playing) { TheEightDissolutions… }` is still a cover over Home's source. "play in her field" should cross to A Strange Game through the Router (the Eight Dissolutions as that world's entry, once a day). Also add the missing "her room" door → `Address(.herHome, kp: 102)` (#25). The name should be 68 pt, not 64. These are C's file edits; Home's host calls the view as it stands.
5. Mauna by stillness at ring ≥ 7 on the Mandala (`CentreArrival`) goes with item 1. `OneBuildingTests.testTheSilenceArrivesByStillnessAtTheCentreAndIsNeverOpened` reads `struct TheCentre` out of `TheCentre.swift`. Keep that struct, or retarget the test to `HomeCentre` / `HomeStillness`.

## API assumptions not verified by a compiler

- `@Environment(Router.self)` is read inside every Home view (SpineRoot injects `.environment(router)` above `WorldHost`).
- `switch address.sub { case .some(HomeSub.mauna): … }` is an expression pattern on an `Optional<String>`, inside a `@ViewBuilder`.
- `HomecomingView(isPresented:onCovenant:)` is the memberwise init. The private `@State`, `@Environment` and `@Query` properties have defaults and are not parameters. The callers' existing `HomecomingView(isPresented:)` still compiles.
- `HomeCentre.init(cardKp:)` sets `_hold = StateObject(wrappedValue: HoldDriver(rise:))` inside a `@MainActor` struct's init (U1-D's `OwnedHold` pattern).
- `MagnifyGesture` (iOS 17) is used with `value.magnification`. `DragGesture(minimumDistance: 0)` is the point's gesture, with `.simultaneousGesture(MagnifyGesture)` on the same 120 pt view and a root-level `.simultaneousGesture(DragGesture(minimumDistance: 0))` for "any touch". **Assumption to check on the device:** Buttons, `onTapGesture` and the `.hold` modifiers inside still fire under that root simultaneous drag.
- `@Environment(\.accessibilityVoiceOverEnabled)`.
- `TimelineView(.periodic(from: .now, by: 1))` is used, as are `.animation(minimumInterval:paused:)`, `Canvas` with `GraphicsContext.opacity`/`blendMode`, `RadialGradient(stops:center:startRadius:endRadius:)`, and `Circle().trim(from:to:)`.
- `@State` holds a tuple optional `(previous: String?, now: String)?` in `HomeEssence`.
- `@MainActor static var` stores (`HomeGreetingOnce.done`, `HomeStillness.restedSinceTouch`) are in Swift 5 mode.
- `Task.sleep(for: .milliseconds/.seconds)` is used.
- Shorthand `if let x` is used on properties (`if let kept`, `if let partway`), Swift 5.7.
- The tests mark each method `@MainActor` because they read statics on `@MainActor` view types (`HomeDeepZoom`, `ThePoint`).

## Tests — `iOS/Bindu MandalaTests/U2HomeTests.swift` (each can fail)

| Test | Proves | Planted / how it fails |
|---|---|---|
| `testEveryHomeLineIsVerbatimInTheWorldFile` | The five's lines, "at the point", Mauna's captions, both greetings, the stillness line, the first-time line and the recognition lines are each found in `spine-and-home.md` | A missing file throws (a failure, not a skip). A line one word off ("…distorting.") is not found. |
| `testTheWakingKeyframesAreTheWorldFiles` | Ember, halo, bloom and scrim values at their keys; the kindle at 58 % | Any key moves; the mid-segment lies between its keys |
| `testTheArrivalIsOwedOnceAndOnlyAtLaunch` | Played once per process; never when Home is entered by a crossing; SKIP, FORCE and the XCTest host | A second take, or a crossing taken as a launch |
| `testTheGreetingIsReadFromTheLedger` | "return" after ≥ 2 days away, "welcome" after 1; nothing on a walked or greeted day or on the first arrival; durations; met = felt today | A silence counted as a meeting (planted) |
| `testHisRecordIsLightNeverACount` | The five relationship lights; a silence lights nothing | **40 meetings ≠ 1 meeting** fails if the screen ever counts |
| `testTheBloomRisesFastAndFallsSlow` | +.06 per act, −.012 per minute, floors at 0, yesterday doesn't bloom | Planted: yesterday's acts |
| `testTheStationsStandRoundThePointClockwiseFromToday` | 0.46·H; r 148.2 at 390; Today up, Game down, clockwise; the five on r 58 above; the beads on r 64 below; 32 not placed | Any reorder or collision |
| `testMaunasCaptionsDeepenOnTheirSeconds` | 7 / 14 / 21 / 28 s and then silence | A caption early, or one after 28 s |
| `testTheStillnessGateIsPausedByATouchAndOpensOnce` | 340 ms, 4.6 s, touch pauses, VoiceOver never, never twice in one stillness | Each guard dropped |
| `testEachLayerOfTheFallCarriesItsOwnSixteen` | Slices of 16 at offset i·13; the hold is 0.9 s | Layers sharing one slice |

These tests are pure. I checked the arithmetic here by hand (the bloom numbers, the relationship days, the station and bead angles).

## Not built in U2-A (honest list)

- **Home:** the Initiation (#7, a ceremony of its own); the thesis lines during the Homecoming breath (#6); the hour greeting pool (#9, Q2 open); motes, hour doors, the gentle door and today's chakra/lunar pointers (#14 c–g); the Road Home card's five doors and three doorways (#15); the bloom stages (orbital rings, rays, organism vignette) beyond brightening the ghost (#19); "the visit told back" dots (#22); the stillness gate's 174 / 261 → 348 Hz tone (it needs a sustained HER voice, which the mixer's `setHer` could carry in U3+); TIME_VARIANTS relighting of Home's ground and the TemporalMark and moon glyph (#13); the nine metabolisms beyond today's petal and the point.
- **The point:** the point's lean and blink to a still finger and its Lissajous orbit with sound (#18).
- **The deep zoom:** its flash-void recognition instant (#29), the Ring 9 line at ×26, and the word stars (#28).
- **Mauna:** per-ring orbitals (#24).
- **Chrome:** the '?' sheet and the Margin at bottom-right (#10). `MarginNoteComposerView`'s header says "‹ Settings" and calls `dismiss()`, so it cannot be hosted as a place without an edit to `Views/Common/MarginView.swift`. That is for B or whoever makes Settings a place.
- **The spine:** the rope (#34) and the two hands (#67).
