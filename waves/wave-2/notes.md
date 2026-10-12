# Wave 2 · One building — decisions

*2026-10-12 · Build Charter II (Emergence) · tiebreaker: build the fuller version; Design is the floor*

## 1 · The climb holds the 102 (Design's Axis)

- **Layout is Design's `presences`, ported as proportions of the spacing** (`ClimbLights`):
  radius `5.6 + min(n, 28)·0.1`, angle `(k/n)·2π − π/2`, height `y + 0.6 + sin(k·1.7)·0.5`
  read against Design's eye at `climb + 1.2`, the ring centred `9 + 1.4` units in front of
  the eye. Every light is a billboard glow (`RoomAir.glow`) marked as light.
- **Breath, core, crown — Design's numbers.** Halo `1.5` authored / `0.95`, met ×1.25;
  opacity `0.95 / 0.9 / 0.5`; rate `0.22 / 0.9 / 0.4`; depth `0.09 / 0.2`. Core `0.5` at `0.9`
  for a Śakti **he has stood with or felt** (HomeMemory known ∪ felt — a state, never a
  count). Crown `3.4`, breathing `0.86 + 0.14·sin(0.3t)`, on today's Śakti (the same pin
  every screen obeys).
- **A third layer on the climb.** `WorldClimbScene.Layer` gains `.presences`. The binding
  condition that kept the axis to two meshes is lifted to its first principle (no figure);
  `everyPresenceIsLight` holds every mesh in the third layer to `RoomScene.lightBodyCategory`.
- **The rail of nine** (`ClimbRail`): region words, ninth at the top, the one he stands in
  lit, a gold tick on a world he has stood in. Rest alpha 0.55 (Design 0.32 sits under
  FIDELITY's word floor). Tapping a world rises to it. Place, never progress.
- **The weather sentences** are Design's `writeWorld`: `form · the ordinal āvaraṇa · region`,
  the name, `gem on dhātu · clock`, the weather line, *she presides today*, and the `low`
  line for the light nearest the eye (`name — quality`, or *hers is the day*).
- **Drag to turn**: Design's `tYaw -= dx·0.0024`, settled at the climb's `0.06`, clamped ±π.
  One gesture (`DragGesture(minimumDistance: 0)`) on its own layer under the rail, like the
  Mandala's catcher: vertical rises, horizontal turns, a still touch chooses.
- **The still path stays still.** `WorldClimbDriver.update(reduceMotion:steps:on:)` re-stands
  the walker only when the motion setting or the step token changed, so the `low` line and
  the marks changing never re-stand a still climb (`testTheStillPathStandsOnceAndStaysThere`).

## 2 · Fly into her light → the rite

- A touch on a light (projected through `SCNView.projectPoint`, nearest within 48 pt and in
  front of the eye) sets `climb.flight`; the driver lerps the eye `axis → light + (0,0,7.4u(1−p))`
  over 1.1 s (`ClimbFlight`), looking into her, while the fog thickens on the rite's own law
  (`fogDensity(entering:)`) and the lights fade by `1 − swallow` (gone by 0.7). Then
  `HerRoomDoor` presents her rite. Reduce motion: no flight, the same rite.
- On return (`landed`) the eye is back on the axis through a 0.9 s rise out of the ground.

## 3 · One threshold, many doors

- **`HerRoomDoor` / `.herRoom($kp)`** is now the only caller of `RiteOfEnteringView.entering`
  in the shell; `RoomView(` is still built only by the rite. Doors: Detail (`herDoor`
  unchanged, still asks only whether she has a room), the Mandala card (*be with her ›*),
  the Rite's foot (her seat line is a button), the Field (a doorway arch on every seat row),
  the climb (her light), the corridor.
- **The corridor** (`Garland`): kp ±1 round the whole garland, wrapping 102 ↔ 1 — the
  brief's "kp ±1 within the garland" (Design's Axis uses ring-and-cluster neighbours; the
  garland reading is the simpler and the one position-as-identity gives without a table).
  Two seams of light at the room's edges, a third of the way down, her neighbour's name up
  each (Design's `.door`), hidden during the ceremony and in the shaft. Walking a door hands
  the stay over exactly as the way out does, then the passage re-keys to the next position
  and her rite runs. No after-effect on the corridor (Design's `walkTo` has none).
- **Accessibility labels**: only the Detail's door begins "Be with her" — the UI suite uses
  that prefix as its sentinel for her Detail; the other doors say "Enter her room", "Her seat
  — enter her room", "Enter the room of …".

## 4 · Leaving

- The 2.2 s hold is untouched. `TheEdgeWayOut`: a swipe from the leading 22 pt carrying
  ≥ 72 pt in, through the same `out()` (room) / `leaveTheClimb()` (climb) / `leave` (Mauna).
  Not offered during the rite's three beats (a threshold has no cancel).

## 5 · Descent never locked

- `TheDescent.isOffered` answers true always (kept for its callers). `DescentReach`: three
  stations (tattva, location, etymology) until the first adaptation, five after — so his
  accumulated dwell (head start ≥ 62 s) opens the full shaft on arrival. `onward(reach:)`
  closes the circle at whatever floor the shaft reaches.
- The descent sounds: `Glissando` glides from her carrier down a just minor third per
  station (back up the same path), through `HomeVoice.descends` → `RingAudioService.glide`
  (`GlissandoVoice`). Nothing structural; a muted stay decides the same.

## 6 · Sound everywhere

- **`RingFieldVoice`** conducts `RingAudioService`'s six voices: point (0, new, 136.1 + 204.15),
  ground drone (1), home breath (2), sustained 116.5 (3), stepped notes (4, 5 — Design's roots
  ×2, steps 1 · 9/8 · 5/4 · 3/2 at 5.2 / 3.4 s), sustained 207.65 (6), the witness (7, new —
  136.1's 2nd, 3rd, 5th partials, no fundamental), triad (8), Shepard (9).
- **The climb** sounds both HomeSoundService's nine grounds (Design's climb voice, `setGround`
  on the climb's weights) and the ring voices, ten times a second; paused while a room is
  open (HomeVoice takes the instrument) and resumed on return.
- **The Mandala** sounds the entered enclosure; **on by default** (`lr_sound` absent → on);
  the ♪ still governs it. Ring 7 entered inward strikes the twelve-voice chord (Design's
  `VAK_FREQS`, 55 ms stagger); Ring 8's triad glides into one after 6 s of stillness; the
  fall into the Bindu sounds a Shepard swell.
- **Silent switch**: RingAudioService now sets `.ambient` (re-asserted on each voice, since
  BijaSoundService sets `.playback` once) and gives `.playback` back in `stopAll`. While the
  field sounds, a struck bīja also honours the switch — the charter's law 5 reads as global.

## 7 · Gates of Release (the Mandala's descent through the nine)

- On an inward crossing into ring *e* the gate holds *e*'s Mental State; on an outward
  crossing out of *e*, its Siddhi. A 2.6 s hold (the Seven Gates' own) puts the words down
  (`translateY 34, scale 0.9, fade`, 1.7 s) or raises the Siddhi to him; unanswered, the gate
  passes after 9 s. The Seven Gates' generated gatekeeper is refused (law 8).
- **Siddhi** is read live: `AvaranaFields.siddhi = fldx9jXyTVWxp19o1` (verified 12 Oct via the
  Airtable MCP), cached beside the store in `RingFactsCache.Facts.siddhi` (optional, so old
  caches decode — no `@Model` change). The base's own nine strings stand offline.
- Ledger: `State Set Down` / `Siddhi Received`, linked to the Avaraṇa row, Gesture Source
  Mandala, Descent Ring set, no Notes. Added to `LedgerIsTheRecord.eventVocabulary`.

## 8 · The centre

- A 64 pt target at `camera.binduScreen()` (active when no card, Veil or source is up).
  **Tap → Mauna**: dark ground, ring-2 and ring-3 names as orbital stars (decorative), the
  breathing Bindu, Design's captions at 7 / 14 / 21 s, silence at 28. Design's *"7 seconds
  in"* depth line is **not** drawn (a count of his silence). Leaving ≥ 7 s writes a local
  `.silence` entry at kp 102 and a `Silence Held` row (`ActivityLedger.mauna`) — never felt.
- **Hold → G17 centre bloom**: Design's Spanda layers (trikoṇa 0.06 → names 0.80) drawn
  outward from the point over the living field, the point's 136.1 swelling under it.
- **Inside Mauna, hold → Praveśa**: seven nested yantras emerging forever, the Shepard tone
  on the fall's speed; held past 6.5 s the fall settles and Design's words arrive (*"You did
  not arrive. You were the arriving."* and the ninth āvaraṇa's appreciation). Let go after
  the recognition and the point opens into Lalitā's source (`openDescent`).
- This takes the Bindu tap from the descent: the source is reached through Mauna's fall,
  the Veil's footer, and VoiceOver's activation of the ninth seat (unchanged).

## Tests changed, and why

- `TheWayInTests`: `testTheDoorIsCutInOnePlaceAndItIsHerOwnScreen` → `testEveryDoorPassesTheOneThreshold`
  (the one-door rule was lifted; what survives is one threshold builder and doors at the five
  places); `testTheClimbIsOpenedFromTheFieldAndNotFromTheMenu` → `testTheClimbIsReachableAndOpensRoomsThroughTheOneThreshold`
  (climb-only-from-the-Field and the `Destination` equality pin enforced the lifted rule);
  `testNeitherNewSurfaceMeasuresHim` derives surfaces from `.herRoom(` too. New:
  `testTheCorridorWalksThroughTheRiteAndHandsTheStayOver`, `testTheEdgeIsAnEqualWayOut`.
- `WorldClimbTests.testTheClimbHoldsNothingStandingInTheAir` rewritten to the surviving
  principle (three layers; every presence mesh is light); new `testTheCoresAreHisMetAndTheCrownIsTodays`.
- `HomeDescentTests.testTheWayDownIsEarnedByDwellAndNeverAnnounced` →
  `testTheWayDownIsAlwaysOfferedAndDwellingDeepensIt`; new shallow-floor and glissando tests.
- `LawsTests`: event vocabulary gains the two new types.
- New `OneBuildingTests` for all pure logic in `TheBuilding.swift`, the ledger builders, and
  the field voices' levels.

## Shared files touched (for the merge)

`Views/Mandala/LivingMandalaView.swift` (sound default, `roomFor`, two layer lines, two
modifier lines, the card's `onEnterRoom`), `Views/Mandala/SignificanceCard.swift` (optional
`onEnterRoom`), `Views/Today/DailyRiteView.swift` (seat line as a door + `.herRoom`),
`Views/Common/TheHundredTwoView.swift`, `Views/Common/ShaktiDetailView.swift`,
`Data/AirtableService.swift` (one field), `Data/RingFactsCache.swift`, `Data/ActivityLedger.swift`,
`Services/RingAudioService.swift`, `Services/HomeVoice.swift`, `Services/HomeSoundService.swift`
(`start()` now builds the graph before configuring the session — a pre-existing ordering
whose teardown gave `.playback` back after a room had asked for `.ambient`).
