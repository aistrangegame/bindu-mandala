# U2 · C · The worlds in their own spaces — report

Branch `u2-c` from `upgrade` @ `ec061f0`. No Swift compiler here: every type called was read in source first; nothing has been compiled. The Mac build is the first compile.

## For the merge — three things to do (read first)

1. **Register the hosted worlds.** Part B's root must call `WorldBuilders.registerHostedWorlds()` once, before the first world is drawn (e.g. in `SpineRoot.init` or the app's root `init`), next to Part A's `.home` registration. Without that call every world except Home still draws as its U1 placeholder. (I did not edit `Spine/` or `BinduMandalaApp.swift`; they are B's.)
2. **ThreadDoors.** Part B's `ThreadDoors` did not exist when I built this. Its one call site is marked `U2-MERGE · ThreadDoors` in `Worlds/HostedWorlds.swift` (`WorldThreadDoorsSlot`). Replace the `EmptyView()` under that comment with `ThreadDoors(address: address)`, adjusting to B's real init. The slot shows only when the address carries a kp, a chakra or a day, and every hosted world passes through it.
3. **`WorldSub.source` (`"source"`).** The Mandala's bindu hold, the Mandala's descent (the first fall of the day) and the ninth ring's fall all cross to `Address(.home, kp: 102, sub: "source")`. Part A's Home should open Lalitā source when it sees that sub. Part B's point-hold can use the same address.

## What moved where

### The Mandala, cleared (`Views/Mandala/LivingMandalaView.swift`, rewritten)

What it keeps: the held yantra on the indigo sky, the hour's five states, the breaths, the seats in her own light, pan/pinch/double-tap to fall through, a seat's card, the inward bell (or bīja), Tratak, and the sound control (with Fall in / Rise out / The whole yantra as its accessibility actions). It also adds Design's resting caption, *"the instrument · look, do not operate"*, which fades as the Veil rises.

Where each removed piece went:

| Was on the glass | Now |
|---|---|
| 33 constellation layer and its 44 pt chakra buttons (`chakras:` to the canvas, `ChakraLayerOverlay`) | **the 33** (`The33World`) |
| The Road, Shadow/Armin thresholds, "Tat · Tvam · Asi" | **the 33**, played in the Road's crossings (the overlay's own logic) |
| Chakra rooms (cover from the overlay) | **the 33**, as a place inside it (`chakra` + `sub "room"`); back returns to the lights |
| `GatesOfReleaseLayer`, `TreeOfLifeRingLayer`, the ring long-press, `.mandalaFieldVoice` (ring 7 chord, ring 8 unite) | **the nine rings** (`RingSpace`), one ring at a time |
| `TheCentre` (Mauna, BloomPress, the fall) | removed from the glass, and the views are untouched and callable for Part A. The bindu is now a door: tap → Home (bloom from the touch), hold 0.9 s → `home/source` |
| `LalitaSourceView` (zIndex 40) | removed from the glass, untouched and callable for Part A |
| Descent (ring-9 seat, Veil footer, fall-through) | the camera still eases 0.95 s to 5.4 and *Ring Crossed* (9) is written. It then crosses into Home through `.pravesha`: to `home/source` on the first fall of a practice day (`mandala_source_day`), plain Home after. New: pinching inward at the clamp with the bindu within 64 pt of centre also begins it (M40, never automatic) |
| Ways-in ring (`WaysInRingView`), the ✶ mark, `MandalaWays` receive | gone from the Mandala. `WaysIn.swift` is untouched (its labels and `MandalaWays` are still used by B's bridge and by tests) |
| Modes cover, Climb cover, `PlayField.open()` | **the Modes**, **the Climb**, **A Strange Game** |
| `ShaktiDetailView` cover (second tap / "enter her presence") | second tap on a seat → **Her Home** (room first). The card's "enter her presence" → **Her Presence**; the card's "be with her" → **Her Home** |
| `.herRoom($roomFor)` cover | **Her Home** |

**Back to exactly here:** every 700 ms of camera stillness, and before every crossing out, the camera (scale, tx, ty) is written to the address as `Address.Anchor(scale:offsetX:offsetY:)` through `router.note(anchor:)`. It is only written while the router is still in the Mandala. On return, `LivingMandalaView(address:)` restores it.

### The Veil (`Views/Mandala/MandalaVeil.swift`)

`MandalaVeilPeek` and `MandalaVeilSheet` are replaced by **`MandalaVeilDrawer`**, built to Design's numbers:

- **Size:** the sheet is 720 high and always present. At rest its top 108 shows; that peek is the sheet's own edge (closed offset 612). On a glass shorter than 744 the height becomes `glass − 24`, and the peek stays 108.
- **Drag:** a drag on the edge follows the finger live, clamped 0…closed, with animations disabled under it.
- **Release:** a move of less than 6 pt is a tap and toggles. Otherwise the sheet opens if offset < 0.42 × closed (257.04 on Design's glass), else it closes. It moves in 0.52 s, `timingCurve(.22, 1, .36, 1)`, or 0.2 s easeOut under Reduce Motion.
- **Dim:** the yantra dims live to `0.5 + 0.5 × offset/closed`, and is never hidden. A tap on the dimmed yantra lowers the sheet.
- **Edge:** the chevron breathes on a 3.2 s cycle and turns over once the sheet has risen. At rest the edge reads "THE NINE ĀVARAṆAS"; as it rises, "The Nine Āvaraṇas" and "DESCEND" fade in.
- **Destinations:**
  - Rows I–VIII cross to `Address(.rings, sub: "ring.N")`, blooming from the row (`veilDark`). The camera is never moved several rings at once.
  - The Bindu footer crosses to ring IX.
- **Accessibility:**
  - The edge is a button whose action toggles the sheet.
  - The rows leave the accessibility tree while the sheet is down.
  - Identifiers: `mandala.veil.handle` and `mandala.veil.ring.N`.

`VeilLight` and the `MandalaVeil` enum are unchanged, as the tests require.

### The hosted worlds (`Worlds/`, new)

| World | Hosts | Leaving / doors |
|---|---|---|
| Today | `DailyRiteView` | her name / "know her" / her seat → **Her Home** (room first); low-state door → **Beneath** `low`; the hour's mode → **the Modes** `<mode>`. Recognition, the Nityā sheet, the floor and closing stations stay as Today's own ceremonies |
| Mandala | `LivingMandalaView(address:router:)` | as above |
| Nine rings | `RingSpace(ring)`: the enclosure framed at `MandalaCamera.ringTarget`, the Tree of Life panel and its collective breath, the Gate of Release (set down going in; received going out when he moves outward between rings), ring 7/8 sound, and in IX the point with "Press and hold — fall inward." (a 0.9 s hold) → `MaunaView` in-world, and a fall-through → `home/source` | ring chooser I–IX (`.dissolve`, one ring at a time); "the hundred and two ›" → sub `field` (the existing `TheHundredTwoView`, so the Field stays reachable); "rise through them ›" → **the Climb** at this ring; a seat of this ring → **Her Home**. The ring is the address's `ring.N`, else her ring (kp), else today's ring |
| Her Home | `HerRoomPassage` (the one rite → room path) | room first. New **library door** "enter her presence ›" appears once he is inside (never during the rite) → **Her Presence**; leaving the room → `router.back()` |
| Her Presence | `ShaktiDetailView` (new `onBack` → `router.back()`) | her room → **Her Home** (`.crossesToHerHome`) |
| Climb | `WorldClimbView` with live facts, seats, met (felt ∪ stood) and today | her light → **Her Home**; a body chakra → **the 33** room; way out / edge → `router.back()` |
| the 33 | `The33Field`: the constellation alone on the night (no yantra, no seats) with pan/pinch, `ChakraLayerOverlay` (lights → rooms, the Road, the thresholds), and "walk the road ›"; sub `road` starts the Road | a room (`chakra` + `room`) is `ChakraRoomHost` in-world, and its leave → `router.back()`; the room's doors: her room → **Her Home**, the ring → **the Climb** |
| A Strange Game | no sub: `TheEightDissolutions` (once a practice day, then "Now go play." → the field, its own logic); sub = a game → `PlayGameHost` | field's "the modes" → **the Modes**; close → `router.back()` |
| Modes | `ModesDoorView`; sub = a mode → `ModeHost` | `router.back()` |
| Time | `ThePointView` (new `onBack`) | "‹ back" → `router.back()` |
| Memory | `PortraitMandalaView` | "the point ›" and the point → **Time**. The river, where she speaks, the book and the month stay Memory's own |
| Well | `WellView` | — |
| Beneath | a gathering of three doors: "I am low" → `low` (`LowStateDoorView`), "Shadow Translator · {verb}" → `translator` (`PlayGameHost(.shadowTranslator)`), "the river ›" → `river` (`CorrespondenceView`, new `onBack`) | each door is a sub-place, so back returns to the gathering |
| Relationship Field | the three connections (Gaia kp 31 · Ahaṅkāra, Ashrey kp 40 · Nāma, Ram kp 42 · Ātmā) on a triangle, with Bīja kp 41 the bridge at the centre, each showing her name from the base | each → **Her Home** |

`HostedWorld` (the frame for every hosted world) provides:

- the silence ground;
- the sentinel `world.<id>`;
- Escape → `router.back()`;
- the ThreadDoors slot.

It draws **no point and no menu** (B's).

Worlds/ holds **no `.sheet`, `.fullScreenCover` or `.popover`** (asserted).

### Overlays over another world → crossings (`Worlds/WorldDoors.swift`)

`WorldDoors.herHome / herPresence / ring / climb / chakraRoom / modes / beneath / time`, and three modifiers that replace a cover with a crossing:

- `.crossesToHerHome($kp, then:)`
- `.crossesToHerHome(shakti:)`
- `.crossesToChakraRoom($road)`

They read the Router from the environment, and fall back to `Router.shared` when it is absent, so a screen drawn outside the spine never crashes.

| File | Was | Now |
|---|---|---|
| `Views/Today/DailyRiteView.swift` | covers: Detail, her room, LowStateDoor, ModeHost | crossings |
| `Views/Common/TheHundredTwoView.swift` | push Detail; Climb cover; her room cover | room first; `WorldDoors.climb(ring: effectiveOpen ?? todayRing)`; her room |
| `Views/Common/ShaktiDetailView.swift` | `.herRoom` cover; `dismiss()` back | `.crossesToHerHome`; `onBack` |
| `Views/Rooms/WorldClimbView.swift` | `.herRoom` cover | `.crossesToHerHome($roomKp, then: landed)` |
| `Views/Chakra/ClimbBodyChakras.swift` | `.chakraRoom` cover | `.crossesToChakraRoom` |
| `Views/Chakra/ChakraRoomView.swift` | exit covers her / ring | `WorldDoors.herHome` / `.climb`. **The game exit stays a cover**: it carries the room's Map record (U0 · C14 `Link to The Map`), which an address cannot carry yet |
| `Views/Memory/PortraitMandalaView.swift` | `ThePointView` cover | → Time |
| `Views/Play/PlayFieldView.swift` | modes cover | → the Modes |
| `Views/Rooms/HerRoomDoor.swift` | — | `HerRoomPassage(…, onPresence:)`: the library door (default nil, so other callers are unchanged) |
| `Views/Mandala/ChakraLayerOverlay.swift` | room cover | `onOpenRoom:` hook (default nil, so the old behaviour is kept) |
| `Views/Memory/ThePointView.swift`, `CorrespondenceView.swift` | `dismiss()` back | `onBack` (default nil = dismiss) |

## Every file touched

New:

- `iOS/Bindu Mandala/Worlds/HostedWorlds.swift`
- `iOS/Bindu Mandala/Worlds/WorldDoors.swift`
- `iOS/Bindu Mandala/Worlds/HerWorlds.swift`
- `iOS/Bindu Mandala/Worlds/RingsWorld.swift`
- `iOS/Bindu Mandala/Worlds/MandalaAnd33Worlds.swift`
- `iOS/Bindu Mandala/Worlds/HostedWorldViews.swift`
- `iOS/Bindu MandalaTests/U2WorldsTests.swift`
- `waves/upgrade/briefs/U2-C-report.md`

Edited:

- `Views/Mandala/LivingMandalaView.swift` (rewritten)
- `Views/Mandala/MandalaVeil.swift`
- `Views/Mandala/ChakraLayerOverlay.swift`
- `Views/Today/DailyRiteView.swift`
- `Views/Common/TheHundredTwoView.swift`
- `Views/Common/ShaktiDetailView.swift`
- `Views/Rooms/WorldClimbView.swift`
- `Views/Rooms/HerRoomDoor.swift`
- `Views/Chakra/ClimbBodyChakras.swift`
- `Views/Chakra/ChakraRoomView.swift`
- `Views/Memory/PortraitMandalaView.swift`
- `Views/Memory/ThePointView.swift`
- `Views/Memory/CorrespondenceView.swift`
- `Views/Play/PlayFieldView.swift`
- `iOS/Bindu MandalaTests/TheWayInTests.swift` (the doors to her room are now crossings; the Climb is hosted in `ClimbWorld`, and the Field crosses to it)

Not touched:

- `Spine/`, `BinduMandalaApp.swift`, `Views/Root/`
- `TheCentre.swift`, `StillnessAtTheCentre.swift`, `LalitaSourceView.swift`, `TheEightDissolutions.swift`, `WaysIn.swift`
- `project.pbxproj`, `Info.plist`

New type names, to check at merge:

- `WorldSub`, `WorldDoors`
- `CrossesToHerHome`, `CrossesToHerHomeFromRow`, `CrossesToChakraRoom`
- `HostedWorld`, `WorldThreadDoorsSlot`
- `TodayWorld`, `MandalaHeldWorld`, `RingsWorld`, `RingSpace`, `HerHomeWorld`, `HerPresenceWorld`, `ClimbWorld`, `The33World`, `The33Field`, `GameWorld`, `ModesWorld`, `TimeWorld`, `MemoryWorld`, `WellWorld`, `BeneathWorld`, `RelationshipWorld`
- `MandalaVeilDrawer`, `VeilBreathingChevron`, `VeilRingRow`, `VeilBinduFooter` (the last three are private)
- Extension: `WorldBuilders.registerHostedWorlds()` / `hostedWorlds`

## API assumptions not verified by a compiler

- **Optional environment:** `@Environment(Router.self) private var envRouter: Router?` (the iOS 17 optional Observable environment).
- **Accessing `Router.shared`:** it is read from View computed properties and closures, and from `@MainActor` ViewModifiers. Under the iOS 17 SDK, Swift 5 mode may at most warn here.
- **SwiftUI APIs used:**
  - `onTapGesture(coordinateSpace: .local) { p in }` (iOS 17)
  - `withTransaction(Transaction(disablesAnimations))` to set the drag offset
  - `accessibilityAddTraits(cond ? .isSelected : [])`
  - `XCTAssertNotEqual(_:_:accuracy:)`
- **`HostedWorld`'s init:** it relies on the synthesized memberwise init with a `@ViewBuilder let content` stored property, called with a trailing closure after a defaulted `doors:`.
- **Memberwise inits used from other files:** `LivingMandalaView(address:router:)`, `ChakraLayerOverlay(... onOpenRoom:)` and `CorrespondenceView(onBack:)` (alongside `@State private` properties with defaults). This is the same pattern the app already relies on.
- **Optional patterns in a ViewBuilder `switch`:** `case WorldSub.low?:` on `String?`.
- **The game exit and `withAnimation` completion:** `ChakraRoomView`'s game exit is still a cover. `withAnimation(…) { } completion: { }` calls `router.go` from its completion block.
- **When the Mandala unmounts:** the Router mounts the next world at the crossing's beat. Until then the Mandala keeps drawing at the descent camera.

## Choices made from the evidence (re-examinable)

- **Second tap on a seat → Her Home.** `mandala-and-rings.md` §1A says Her Presence, but the newer U2 brief rules room first for every tap on a Śakti. The card keeps "enter her presence" for the text page.
- **The descent crosses with `.pravesha`** (crimson — Home's colour, "Lalitā's red bloom takes over"), not `.descent`, which is the Well's paper-lifting crossing.
- **The Veil's footer → ring IX** of the nine rings, and the bindu's hold → `home/source`.
- **The Field (`TheHundredTwoView`) lives inside the nine rings** (sub `field`). It was a top-level screen, and nothing that was reachable may be lost.
- **A body chakra's room from the Climb** crosses to the 33. Her room from the Climb crosses to Her Home. Back returns to the Climb at the ring it was opened at; the exact climb position inside it is not yet kept.
- **The corridor inside Her Home** (neighbour doors) walks inside the passage and does not push the router. The held way out therefore leaves the building in one step, rather than walking back room by room.
- **Still nested within their own worlds** (not raised over another world):
  - Recognition (Today, Her Presence)
  - the Nityā sheet and the floor/closing stations (Today)
  - Memory's river, body, book and month
  - the Well's river
  - games inside the play field
  - the room's game exit (C14)

## Tests (`U2WorldsTests`) and how each fails

| Test | Proves | Planted defect |
|---|---|---|
| `testEveryWorldButHomeIsHostedAndRegistered` | 14 builders registered, no placeholder | an unregistered world is seen as a placeholder |
| `testTheHostedWorldsLayNothingOverAnother` | no cover in `Worlds/`; the 11 old covers are gone from their screens | a synthetic cover is caught |
| `testTheMandalaIsCleared` | none of the 16 moved-out callees is on the Mandala; the Veil drawer and room door are there | each callee, planted, is caught |
| `testTheVeilIsDesignsNumbers` | the world file's own phrases (720, 0…612, 6 px, 42 %, 257.04, .52 s curve, the dim formula) and the drawer's constants and rules agree; a short glass keeps the peek | a 6 pt drag is not a tap; the old fixed .55 dim ≠ the new one |
| `testRoomFirstAndTheDoorsCross` | each door lands on its exact address; back from Her Presence returns to her room; rings clamp to IX | ring.0 / ring.10 / no ring are refused |
| `testTheRelationshipFieldStandsOnItsThreeConnections` | the world's kps equal the registry's kp doors (31/40/42); the bridge is 41 | adding 41 to the doors is caught |

## For the walk on his phone

| Step | What he should see |
|---|---|
| Mandala | the yantra, the header, the caption and the Veil's edge. Nothing else stands on the glass |
| Drag the edge | the sheet follows the finger and the yantra dims with it |
| A row | crosses into that ring's own world |
| Second tap on a seat | her rite, then her room. "enter her presence ›" stands at the top once he is inside |
| Bindu | a tap goes Home; a 0.9 s hold goes to the source |
