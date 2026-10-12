# Wave 1 · Slice D · The Homes — decisions

*2026-10-12 · Build Charter II (Emergence) · owns `Homes/` and `Views/Rooms/`*

The 102 rooms come home to Design's language of light. Every call below was made
in the expansive direction (charter §1: *when in doubt, build the fuller
version*), and every one is reversible.

## 1 · HDR and bloom on, the light caps lifted

- **`RoomExposure`** (`Homes/Render/RoomAir.swift`): every room camera now has
  `wantsHDR = true`, exposure adaptation off (so a capture is the same picture on
  every run), and a per-world bloom. Exposure bias +0.20 … +0.40 EV in the dark
  worlds, **−0.10 at the Crown** (its fog is pearl and already near white), bloom
  threshold 0.70–0.80 (0.92 at the Crown) so only what is genuinely hot spreads.
  Design measures rooms ≈ 80–255 on 0–255; the restrained build measured ≈ 11–65.
  The bias was chosen to lift the room without touching the existing luminance
  bounds (mean < 0.9, Laghimā < 0.7, ≤ 25% at white); the new light bodies carry
  the rest, and the SwiftUI light pass adds on top on screen.
- **The light pass** (`RoomLightPass.metal`): the 0.86 clamp is gone (the
  `.screen` blend already keeps every pixel ≤ white), the wash ×0.09 → ×0.15,
  gravity ×0.16 → ×0.22, suspended light ×0.10 → ×0.16, shafts ×0.34 → ×0.46, the
  mark's bloom ×1.25, and the rake's retreat on reversal 22% → 8%. Signature and
  Swift-side arguments unchanged.
- **The rig**: ember 3,200 → 4,200, ambient floor 320 → 460. **The marks**:
  emission floor/ceiling 0.06/0.42 → 0.10/0.62. **The dust**: transparency
  0.20 + 0.34·veil → 0.34 + 0.40·veil.
- **The climb** (`WorldClimbScene`): HDR on, +0.3 EV, bloom 0.8 at threshold 0.8.
  Nothing else on the climb was touched — Wave 2 rebuilds it.

## 2 · The binding condition lifted to its first principle

The rule ("every attribute is an action on the room's own material, never a
free-standing lit solid", extended phase by phase to all light) is retired. What
survives is **no figural depiction of a Śakti**.

- **How it is held in the graph now.** Every node that *is* light — emissive,
  additive, drawing its own colour — is marked with `RoomScene.lightBodyCategory`
  (`markAsLight(_:)`). `solids(in:)` counts only what is left: opaque, modelled
  bodies lit by something else, the only kind of thing a figure could be made of.
  `solidsInHerLayer` (alias `figuresInHerLayer`) stays zero in every room. New
  facts: `lights(in:)`, `nodeNames(in:)`.
- **Her layer now holds her light**: a hot core and a wide halo at her mark
  (`HerLight`), blooming in HDR. The core is hottest once the eye settles and
  softens past the second adaptation while the halo widens — Design §4.4, the mark
  becoming the room rather than hardening into a lamp.
- **What was kept as behaviour, not law**: `RoomMaterial`'s five verbs and its
  arithmetic are untouched (the marks still live in the stone and still light in
  proportion to how far the stone moved); `RoomSurfaceMechanism` is unchanged; the
  scene graph is still not vended (that protects the room from being mutated by any
  view, which is still worth having).

## 3 · Seat-shaped shells (`Homes/Render/RoomShell.swift`)

Design's `rite-core.jsx` `room:` column: **1 square · 2–3 petal · 4, 6, 8
triangle pointing away (tri-up) · 5, 7 triangle opening away (tri-down) · 9
circle.**

- Square: the court as it always was (so the Gate's rooms are geometrically
  unchanged). Petal: a ring of `SCNShape` petals (16 in the second āvaraṇa, 8 in
  the third) round a centre beyond her mark, open behind him. Triangle: two
  walls to a far apex, or two walls from an apex **behind where the rite's
  crossing begins** to a far base wall. Circle: sixteen panels, open behind him.
- **Why the openings**: the rite's crossing stands the eye a body-height back; a
  closed drum or a near apex would have him looking at the *outside* of his own
  room for the whole ceremony. `testNoShellCrossesHisLineOfSight` holds this for
  every shape from the far end of the crossing to her furthest mark.
- **Stations**: a wall now closes toward her seat's own centre (the origin in the
  court; the centre of the lotus/circle; the **centroid** for a triangle). A
  triangle closes by *shrinking about its centroid* (each side toward it and
  shorter by the same fraction), because two inclined sides translated toward a
  centre cross in front of him. The departing (rising) station is unchanged.
- **The seat's plan in light**: a thin additive seam in her lifted hue where each
  wall meets the floor, so the shape reads even where fog has closed over the
  walls.

## 4 · Design's per-band physics (`RoomAir`)

`homes-worlds.js`'s nine bands, brought into each room at `roomHeight / 18` of
Design's scale, on the band's own tempo-scaled clock (`breathe(at:)`), pure in
time (reduce motion poses once):

| Band | Built as |
|---|---|
| 1 Feet | the low sun's disc (glow) swinging across the far wall on the day–night clock, a warm point light following it; 90 motes |
| 2 Pelvis | seven red rings expanding on the pulse through a cold-blue wash (one floor plane, fragment shader, `bpm = t·1.05`, `sys = sin⁶`); a pulsing glow and beat light; 120 motes |
| 3 Navel | **2,600-point curl flow** (Design's three-sine curl verbatim in a geometry modifier; 1 in 7 points hot) and the churn light |
| 4 Heart | **RGB caustics** — three separated spectra on their own drifts in one floor shader, gain on the lunar fortnight; a **diamond prism** (clear octahedron, three R/G/B edge copies offset for dispersion, a hot spark) turning `t·0.07, t·0.11` |
| 5 Throat | the **72-rib colonnade** (three arcs of 24, flattened into one draw, open in a 60° wedge toward him), 24 standing **light shafts** between them waxing on the lunar month, the green core |
| 6 Forehead | **nine translucent ruby lanterns** (geodesic, emissive past 1 on the season), each with a hot marrow glow inside and three of Design's nine inner lights; 90 motes |
| 7 Crown | luminous **pearl fog** — five veils of light, at a little over half Design's alpha (the fog beneath is pearl already); 150 motes |
| 8 Above crown | the **chatoyant band** (Design's meridian shader on a shell behind her), the bar of light turning with the year, the sweep light and its halo |
| 9 Totality | **nine gem lamps orbiting** in Design's nine colours (three carry real light), the yantra's three circles and three triangle pairs turning `t·0.008`; 220 motes |

Every light body writes its whole pixel premultiplied onto an additive blend
from a fragment modifier, so none of it depends on how SceneKit folds ambient
into a lighting model. Budget: the largest band is one 2,600-point draw; the
colonnade is one flattened draw; at most four extra point lights per room.

## 5 · The room's own words (`Homes/HomeWords.swift`, `Views/Rooms/RoomWordsView.swift`)

The grammar's `HomeLabel` near/deep words were composed since Phase 3.2 and shown
nowhere; the eight authored rooms' sentences in `homes-chambers.js` were never
ported. Both now speak, set as the Axis sets them: *"{region} · the {ordinal}
āvaraṇa"* (gold label), her name (Cormorant 28), her quality (italic), and the
room's sentence low in the frame. Stages off her chamber clock: **arriving**
(place, name, quality fade in), **near** (settling ≥ 0.25: the room says what it
is), **deep** (past `secondAdaptationSwitch`: the sentence crossfades and the
heading steps back to 0.62). The sentence stands back while the descent speaks.
Reduce motion: no timeline; the settled instant's words. Ordinals are words, not
digits; nothing counts him.

## 6 · The after-effect (`Homes/HomeAfterEffect.swift`, `Views/Rooms/HerSiddhiLingers.swift`)

On crossing out of a room: the Axis's exposure lift (+0.12, fading over 24 s), the
Axis's line *"her siddhi is still on the instrument"* for 12 s, and the older
Rite's per-āvaraṇa kind — sharper · wider · lighter · wider · sharper · heavier ·
wider · lighter · wider — for 180 s, decaying as `e = k²`. Drawn as an overlay
that exists only while it lingers plus a scale that is exactly 1 otherwise, so no
filter ever sits over the app and the app's identity never changes. Never a
score: the same for every stay in a ring.

**Shared file touched (one line, additive):** `BinduMandalaApp.swift` —
`AppRoot().herSiddhiLingers()`.

## 7 · Tests

- `RoomSceneTests`: the four binding-condition checks rewritten to the surviving
  principle — `testEveryVerbMovesTheMaterialItActsOn` (kept behaviour),
  `testAMarksOwnLightLivesInTheMark` (kept behaviour), **`testNoRoomInAnyWorldHoldsAFigure`**
  (every node name in every layer, one room per world, against the figural
  vocabulary), **`testHerLayerHoldsLightAndNoFigure`**. Removed: the import list /
  private-initialiser / two-axis source pins on `RoomMaterial.swift` and the exact
  mechanism-signature pins — they enforced only the lifted rule.
- The ~15 `solidsInHerLayer == 0` assertions across the room suites are left as
  they are: with light no longer counted as a solid they now assert exactly the
  surviving principle.
- `RoomCaptureTests`: header comment updated (the 0.86 clamp is gone).
- New `HomesWaveOneTests`: seat shapes per ring, shell counts, no shell across his
  line of sight, every room stands in its seat, Design's band counts, the
  colonnade and lanterns leave his line of sight open, every world's air is light
  and its own, HDR per world (Crown gentlest), her light's arc, the words' stages
  and authored sentences, no room word measures, the after-effect's kinds and
  decay.

## Not done here (named, for later waves)

Floor traces, the Well letter as an object in the room, neighbour doors along the
corridor, "you have stood here before", the yantra beyond the far wall at the
second adaptation, Rooms in 3D's cloth displacement / true transmission / triple
exposure for the authored rooms, the climb's 102 lights (Wave 2).
