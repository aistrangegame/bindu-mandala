# THE REGISTER · 18 — Code reader: `Homes/` (the built Homes engine) and its parity with Design

*Reader 18 · second reading · 12 Oct 2026 · read-only. Source: `iOS/Bindu Mandala/Homes/` (45 `.swift` files, 19,078 lines, plus `Render/RoomLightPass.metal`), compared against `waves/register/01-homes.md` (Design's Homes package, all 1,043 lines) and `02-rite-axis-field.md` §A1 (the Rite of Entering, R-01…R-14). To trace the real path from tapping a Śakti to what renders, I also read `Views/Common/ShaktiDetailView.swift`, `Views/Rooms/HerRoomDoor.swift`, `Views/Rooms/RiteOfEnteringView.swift`, `ScoreLightVeil.swift` and `RoomGameLayer.swift` in full, plus the tap handlers in `LivingMandalaView.swift`. Paths below are relative to `iOS/Bindu Mandala/` unless they start with `waves/`.*

**The short answer to the three questions:**
1. **Why a Śakti Home looks like a basic page.** Every ordinary way of tapping a Śakti lands on `ShaktiDetailView`, which is a 2D scrolling text page: a hero, sections, folds and an "I feel her" button. The 3D room exists, but it sits behind a small gold text button at the foot of that page ("be with her ›"), or behind "or the whole of her home ›" in the middle of the scroll. Design meant the opposite: the room is the home, and the Detail becomes the library folded *beneath* it. Inside the room, the eight authored rooms and the 94 grammar rooms are drawn only as **dents, swells and furrows in three slabs of dark stone**, at a 64×64 mesh. That comes from a "binding condition" that Charter II has since lifted, but the room code was never rebuilt. So even the room reads as a dark box with marks in it, where Design had lit cloth, membranes, pillars, frames and yantras.
2. **Reachability.** The **3D rooms are reachable** (six kinds of door, every one through the threshold `RiteOfEnteringView`). The **Rite of Entering's "light room"** (R-09 Seat Interior: the saturated aperture light field, her aperture face, the Śrī Yantra beyond, the shaft, portrait lines surfacing in stillness, the letter, the five descent chambers and "the floor of her") **was never built and cannot be reached**. Only its three-beat threshold (as an overlay on the 3D room), its seat-shape table and its after-effect table were ported.
3. **Keying.** Rooms are **keyed by kp** (`HomeRooms.authored` = {1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve}, `Homes/HomeRooms.swift:201-210`). All eight authored rooms are built and dispatched (`Render/RoomReversal.swift:303-319`). Design's four lost rooms (Aṇimā, Vaśitva, Sarva-Yoni, Sarva-Trikhaṇḍā) are restored. The attribute, tint, gem, memory and doors are also keyed by position.

---

## A · Per-file map

Column key: **ports** = the Design item it carries. **Data** = what it reads or writes. **Restrictions** = hard-coded limits. Every file is pure logic unless it says SceneKit or SwiftUI.

### A.1 · The pure layers (top of `Homes/`)

| file · lines | what it does | ports | data read / written | hard-coded restrictions |
|---|---|---|---|---|
| `HomeRooms.swift` · 286 | Resolution order (authored → grammar → seat) plus the attribute. `HomeRoom` value type. `HomeAuthoredMechanism` with 8 cases and placeholder types (L93-114, now vestigial). | H-RESOLVE, H-ARCH §4.3 | reads `Shakti.khadgamalaPosition, ringNumber, tattva, quality, bodilyLocation, bijaSyllable` and live `HomeWorlds.LiveFacts`. Writes nothing. | Position is the only key (L201-215). Ring 9 has no grammar (`grammarRings` 1–8, L219). No name lookup at all. |
| `HomeWorlds.swift` · 329 | The nine-world table: `RING_CHARACTER` (form, phase, yoginī, veil, state, tempo, verb, bīja) and `WORLDS` (name, gem, dhātu, clock, region, weather, fog hex, density). Veil scales fog ×(1+veil·0.55). Two clocks: `worldClock` (×tempo) and `adaptationClock` (an identity function). | H-WORLDS table, §4.2 RingWorld | Airtable overlays 9 strings from `Avarana` and `RingFactsCache` (name, form, yoginī, state, gem, dhātu, clock, region, bīja), L251-292. Weather, fog and tempo are Swift-only. | Tempo deliberately non-monotone (L160-165). Tempo never reaches the adaptation clock (L325-328). Region is never overlaid from Subtle Body Chakra (L79-84). |
| `HomeGrammar.swift` · 931 | Physics classifier: Design's **50 regexes in load-bearing order** plus 3 appended (Priyatā → swell, Saubhāgya → brighten, Cāpa → compress, L265-282). The 51-kind displacement kernel (L371-436). Body zones: Design's 11 plus 7 appended (L456-536). Archetype dispatch, phase divisors, Mātṛkā letter count, sounding mode, sourcing corner. Words (near/deep) and the Ring-2 crossing sentence read from the row (L712-721). | H-GRAMMAR (50 motions, archetypes), H-CARDS bodyAltitude | reads the Shakti row. No bundled SYLLABLE/CROSSED/ATTRIBUTE tables (L36-38). | Mudrā deep line rewritten as "the seal has opened, and let go of what it held" (law 4, L686-694). No number in any label. The kañcuka words were deliberately left without rules (L256-263). |
| `HomeAttribute.swift` · 930 | The 26 attribute forms as pure `act(t)` motion: shape, action, moving parts, period. `ATTRIBUTE` keys for kp 1–102 (L739-767). `KIN` substitutions (L775-788). 15 `ATTR_TINT` (L792-800). Mount `(0.5−alt)·6.4−0.4`, z −4.6 → −1.2, scale 0.9 → 3.5, opacity ×(1−0.55b) applied once rather than per frame (L868-875). | H-ATTR (all 26 forms, KIN, tints) | position plus `bodilyLocation`. | Three forms renamed to stay aniconic: seal → foldingCapsules, palm → linedDisc, skullcup → shell (L160-176). No fallback form (L809-816). Grain uses golden-ratio seeds instead of `Math.random` (L610-614). |
| `HomeGem.swift` · 125 | Her light. Hue, saturation and lightness come from `Atmosphere` (ring seed, ±7° jitter, Ring 2 cluster seeds). The gem gives only `diffuse` (topaz .20 … pearl .95). Crown is sourceless (L46). `ink` is (h, s·0.55, l 12). `bright` is (s+10, l+18). | H-LIGHT, §4.1 Gem | `Atmosphere`, `KhadgamalaMap`, `Cluster`. | Gem never sets hue. Diffusion is keyed by ring (fixes Design's element-keying bug). |
| `HomeBecoming.swift` · 211 | The "deep term": each archetype's reversal stated as premise surface → answer surface, yields, takes (signed). 10 archetype reversals read from Design's own update lines (L122-209). | H-CLOCK "every room reverses its premise", §4.3 | none | `answer ≠ premise` is enforced. No case for "a thing in the air" (L51-55). |
| `HomeWords.swift` · 130 | `RoomWords`: place ("{region} · the {ordinal} āvaraṇa"), name, quality, near/deep. The **8 authored near/deep sentences verbatim** (L84-93). Seat sentence "her seat, from inside". Stages arriving → near → deep: settling ≥ 0.25, deep > 0.45 (L56-62). | H-MECH words, H-AXIS mid-line | name and quality from the row | No measuring strings. |
| `HomeDescent.swift` · 345 | Descent arithmetic: STATION_Z [−16,−34,−52,−70,−88], 46 rungs, r 5.4·0.985ⁱ, bands 34 and 22 (L96-147). Travel, height that comes to her altitude (L179-183), her own register of 13 (fixes Design's dead `mine`, L222-235), root orbit 14 s / r 3.4 / 0.12 (L239-257), quality swell, floor closing. `DescentWords` builds the 5 lines (tattva, location, etymology roots, quality, phrase) from the row (L304-345). | H-DESCENT (Axis version) | tattva, bodilyLocation, etymology, quality, appreciationPhrase, name | **No solids** in the descent: "Design's torus knot / 13 boxes / sprites / icosahedron / 3 tori" refused (L21-37). No station counter (L60-66). |
| `TheBuilding.swift` · 657 | "One building": `Garland` (±1 neighbours on a circle, L35-51). `ClimbLights` (102 presences at Design's R = 5.6+min(n,28)·0.1, angle, y, Wave 6 "all 102 alike" breath, core, crown 3.4; ring 3 scatter, ring 8 gather, ring 6 whisper glosses, L61-280). `ClimbFlight` 1.1 s (L287-307). `ClimbRail`. `ClimbWords` (kicker, material, "she presides today", near line, hint). `TheGates` (offer the Mental State inward / receive the Siddhi outward, hold 2.6 s, authored Siddhi strings, L395-492). `DescentReach` (3 stations shallow, 5 once adapted). `Glissando` (minor third per station, 2.4 s). `Mauna` (record after 7 s; captions removed). `CentreBloom` (G17 layer opacities). `Pravesha` (Ring 9 endless fall, 7 layers, recognition after 6.5 s, Shepard intensity, 4 authored lines L653-656). | H-AXIS presences, rail, writeWorld, flight; Gates of Release; Mauna; Ring 9 descent | Siddhi strings `fldx9jXyTVWxp19o1` used as fallback; seat names and qualities | Design's met/not-met split removed (C-1284, L139-166). Mauna captions at 7/14/21 s removed (C-1355). No gatekeeper voice (law 8). Gates' "lay it down" became an offering (C-1230). |
| `RingMechanisms.swift` · 124 | Wave 6 climb mechanisms as light offsets: Ring 1 Earth-City (families settle onto 3 squares), Ring 2 lotus follows the sun, Ring 4 lineage wave (0.6 s/seat), Ring 5 overflow, Ring 8 vertex collapse. | Ring Worlds (Design's nine screens, now on the climb) | none | Zero at rest. |
| `HomeAfterEffect.swift` · 116 | After leaving: lighter/heavier/sharper/wider by ring (the Rite's `after:` column), 180 s quadratic decay, plus the Axis exposure lift of 0.12 over 24 s. Line "her siddhi is still on the instrument" for 12 s. Posts `didLeave`. | R-07 + H-AXIS leaving | ring only | The line **names** the siddhi. Design's brief says "never named" (see C). |
| `ClimbSummit.swift` · 49 | Wave 6 empty summit: the ring 9 light thins near the top. "I am what I am becoming." / "I already did." | Codex C-1260/1278 (not Design) | none | Authored strings only. |

### A.2 · The render spine (`Homes/Render/`, SceneKit)

| file · lines | what it does | ports | data | restrictions |
|---|---|---|---|---|
| `RoomUnits.swift` · 555 | The room is the body. Floor and canopy come from the attribute mount. Eye at the "behind the eyes" altitude 0.26. `gaze` 0.55. Extent 4 body-heights. Face span 1 body. FOV 62. Surface choice from altitude (ground / face / canopy, L331-336). Placement, ember, axes per surface. Climb floors per ring. Projection. | Design's mount and altitude; Axis climb | bodyAltitude | **Exactly 4 surfaces; no `.none` or "in the air"** (L54-71). `frameAspect` 0.5. |
| `RoomMaterial.swift` · 537 | **THE BINDING CONDITION.** `SurfaceAction` has a private init and only 5 verbs (impression, furrow, crack, swell, compaction). Light exists only as relief × glow (L327-334). `RoomInscription` reads the verb from velocity (strike 6, working 0.35, L448-460). markDepth = roomHeight/20, grain floor, narrowestMark = 1/64. | H-ATTR rendered as surface marks | attribute actor | Header L17-23: *"Every attribute in every room is an action on the room's own material … never a free-standing emissive solid."* |
| `RoomScene.swift` · 1242 | Assembles one room. Layers building / world / her (named). Ground, canopy and face meshes are 64×64 height fields with 2 normalised morph targets (L882-944). Walls follow the seat shape (`RoomShell`). Motes 420. `RoomAir` weather. HDR exposure per ring. Ember plus "her light" core/halo (Wave 1). Pose = pure function of time. Stations move surfaces; walls close toward the seat centre, never past 0.2, or depart upward (L541-563). Descent install. Capture for tests. Solids and lights counted. | H-CORE layers; chamberSeat generalised; H-CLOCK | room | `solidsInHerLayer` must be 0 (L827-833). Mesh resolution 64. Emission floor 0.10 → ceiling 0.62. Drift amplitude roomHeight/20. |
| `RoomView.swift` · 498 | SwiftUI host. `RoomClock` (held at threshold, head start, `settled` = 347 for reduce-motion). `RoomSceneLayer` → `RoomDriver` (SCNSceneRendererDelegate). `RoomLightPassLayer` = Metal `.colorEffect` with `.screen` blend. | HomeView (§4.5, render half) | clock, approach, descent sources | **Reduce motion stops the render loop entirely** and poses once at the settled state (L29-54). This contradicts Design invariant 4 ("longer and quantized, never disabled"); FIDELITY is chosen instead. |
| `RoomLightPass.metal` · 162 | Air-light pass: rake wash, gem shafts (none in a sourceless room), suspended luminous air ∝ diffusion × veil, bloom at her mark widening with b, altitude gravity, grain. Clamp 0…1. | Design's Turrell light in the air | uniforms only | Additive only; no glyph. |
| `RoomLightRig.swift` · 264 | Key directional 2600 (**nil in ring 7**), ember omni 4200, ambient 460 + 2600·diffuse·0.45. Key positions and strengths over k and b. Fog band from veiled density. | H-LIGHT diffusion behaviour, sourceless Crown | gem, world | Colours only from `Atmosphere`. |
| `RoomShell.swift` · 263 | Walls shaped like her seat: square (3 panels), petal 16 / 8, triangle pointing away or toward, circle (16 panels with a mouth). A seam of light where the wall meets the floor. | rite-core `room:` column (R-01), H-SEAT | ring | Panels behind the walker are omitted. |
| `RoomAir.swift` · 1118 | Wave 1 "light stands in the air": the nine bands brought into every room. Feet sun disc and omni; Pelvis 7 pulse rings shader and heart; Navel 2,600-point curl flow; Heart caustics shader (3 spectra) plus a **diamond octahedron (solid)** with 3 dispersed edge sets; Throat **72-rib colonnade (solid cylinders)** and 24 shafts; Forehead **9 ruby lanterns (solid geodesic spheres)** with marrow glows; Crown 5 pearl veils; Above-crown chatoyance shell, travelling bar and sweep; Totality 9 gem lamps and a yantra line figure. Motes per band. `RoomExposure` HDR and bloom per ring. `HerLight` core and halo. | H-WORLDS W1–W9 (full recipes), Charter II §3 law 3 | ring, world time | Counts are Design's. These solids live in the **world** layer, so they are allowed even though the mechanism layer may not hold any. |
| `RoomReversal.swift` · 335 | Turns `HomeBecoming` into stations (saturating fraction `takes/(1+takes)`; ground never rises toward him) plus one answering swell or impression. `GrammarReversal`, `ArchetypeReversal`. **`RoomMechanisms.forRoom`**: authored → the 8 hand rooms; grammar → Crossing / Siddhi / Mātṛkā / Mudrā / OuterRings; seat → nil (L254-319). | H-RESOLVE dispatch, second-adaptation reversal | room | Walls are never marked (L191-194). |
| `RoomApproach.swift` · 200 | Crossing distance as a closed form. Design's 0.03 lerp → τ 0.547 s; release 2.2 s (reduced 3.4). Reduce motion steps. `RoomApproachSource` reference. | H-AXIS STATION travel (0/.30/.62/.88/1) | none | Release is never compressed. |
| `DescentShaft.swift` · 257 | Draws the descent: 46 line-loop rims (lobes = her attribute's moving parts, minimum 3), root rims orbiting, turn / throw / swell / closing per station. | H-DESCENT shaft | room, roots | `solids` = 0 forever; line primitives only. |
| `ContractRoom.swift` · 172 | kp 1 Aṇimā. Walls close by 2/3 while settling, held off her work. A point (impression on the answer surface) widens toward the elevenfold opening. Glow ∝ (closed/shell)². | M1 CONTRACT | stage | Design's 0.34 closing is held back so the walls never pass her mark. No "beyond" sprites. |
| `EndlessRoom.swift` · 260 | kp 2 Mahimā. No enclosure at any instant. 24 frames, each 5 impressions, flowing at 3.4/120 per second with Design's sin arc of light; 10 "behind" frames at the turn. | M2 ENDLESS | stage | Frames are rows of dents, not lit seat-shaped frames. |
| `ReleaseRoom.swift` · 170 | kp 3 Laghimā. The floor lets go early; at the turn the walls depart upward; a canopy impression ("the opening") widens from 2/26 to 12.4/26. | M3 RELEASE | stage | No cloth walls, no hems, no rising field, no unmoored seat. |
| `PressRoom.swift` · 277 | kp 4 Garimā. The canopy descends 7.4/8.6 of the gap and lifts back by 5.2/7.4. 11 beds × 21 compactions; crater; a palm-sized lit compaction; a plinth swell at the turn. | M8 PRESS | stage, seed | Design's emissive palm cylinder refused. The fog-thickening from Rooms-in-3D is not carried. |
| `KnownRoom.swift` · 244 | kp 6 Vaśitva. 6 pillar feet and a seat as compactions, a ring furrow, a wandering pool mark on Design's Lissajous that comes to rest on him at the turn. | M4 KNOWN | stage | **No spotlight, no pillars standing, no shadow.** The pool is a lit mark, not a light. |
| `MembraneRoom.swift` · 337 | kp 27 Sarva-Yoni. The enclosure breathes (sin 0.28 t, +3.2 % / −2 %). Aperture impression, 8 veins as crack runs (rosette), 3 nested rings of swells arriving with b. | M5 MEMBRANE | stage | No transmissive lathe membrane, no backlights, no sheen. |
| `TripleRoom.swift` · 269 | kp 28 Sarva-Trikhaṇḍā. 3 ghosts × 5 square loops × 8 samples (120 impressions) separated by Design's `sep` (settle, then breathe at 0.085); one seal swell at the far end. | M6 TRIPLE | stage | No tints (Design's red / green / blue ghosts), no render-target triple exposure, no rails. |
| `DissolveRoom.swift` · 608 | kp 102 the Bindu. **99 marks of the yantra** (3 squares × 8, 2 circles × 12, 16 + 8 petals, 9 triangles × 3) cut at nine depths, counter-rotating (0.0075 / −0.014), opening ×(1+2.1b) past the picture; the source swell grows ×(1+2.8b) and fades by 0.55. | M7 DISSOLVE | stage | The yantra is dents in stone, not Design's gold line yantra in air; the source halo is refused (L200-204). |
| `RingOne.swift` · 322 | Names Ring 1's rooms speak in; forwards everything to `OuterRings`. | Ring 1 three families | — | — |
| `SiddhiRoom.swift` · 261 | kp 1–10 (bar 1, 2, 3, 4, 6). The lent capacity (one mark, shrinks by 0.8b) plus 6 receding echoes delayed 0.6+0.5i s. | ARCH-R1-SIDDHI | reading | The enclosure does not move (stations are reserved for Aṇimā and Laghimā). Echoes carry no light. |
| `MatrkaRoom.swift` · 300 | kp 11–18. A ring of n = 5/8/11/14 letters, one spoken at a time (sin⁸, 0.22); a column swell. | ARCH-R1-MATRKA | reading, letter count | Letters grow only until they touch. No floor disc. |
| `MudraRoom.swift` · 416 | kp 19–28 (bar 27, 28). 5 mirror-symmetric vaults × 17 samples tipping open by 0.42b(1+0.1i); the held mark opens and dims. | ARCH-R1-MUDRA | reading | Mirror symmetry asserted (aniconic). |
| `CrossingRoom.swift` · 504 | kp 29–44. Presenting half (7, unlit) and answering half (7, lit) with a 3.2 s lag and counter-phase read off the kernel, converging at b; kp 44 is the key pairing. | ARCH-R2-CROSSED | reading | Rings pressed into stone; no tori or sprites. |
| `OuterRings.swift` · 435 | Shared arithmetic for rings 3–9: `inRoom`, `Figure` (fits the whole figure to the frame at end of stay), reach floors and ceilings, readOver = 15.5 s, `spread` (kernel-aware i/n), `mark`, `outerRoom` dispatch. | — | — | `widestMark` = 0.25 of the surface. |
| `BodilessRoom.swift` · 392 | kp 45–52. 8 lit effects around an unlit compaction (the absence). | ARCH-R3 | reading | — |
| `CosmicRoom.swift` · 541 | kp 53–66. 14 shells as bearings of one coil, delayed outward (a wave); the heart empties of light. | ARCH-R4 | reading | No nested triangles (they become bearings). |
| `GivingRoom.swift` · 540 | kp 67–76. 12 gifts spiral in, light sin(πu); the receiving place compaction opens and dims. | ARCH-R5 | reading | Gifts outside the surface are omitted. |
| `RevealingRoom.swift` · 508 | kp 77–86. 10 buried truths at constant depth and light under a lit compaction veil thinning by 0.72−0.46k−0.26b. | ARCH-R6 | reading | — |
| `SoundingRoom.swift` · 509 | kp 87–98. 2n marks of a standing wave (silences / soundings), axial envelope from her altitude. | ARCH-R7 | reading, mode | The travelling term is dropped as self-contradictory. |
| `SourcingRoom.swift` · 338 | kp 99–101. Triangle of 3 corners (hers lit 0.95, others 0.2+0.7b) and a bindu mark; turns at 0.006. | ARCH-R8 | reading | — |
| `WorldClimb.swift` · 481 | Climb as numbers: spacing = 1 body. Band weights (tent), veil, fog, density (+swallow×1.6), relief, emission, wholeness, `weather()`. Rise 3.4/30 bands/s, settle 0.06. `WorldClimbSource` (yaw, touching, follow, flight). | H-AXIS climb, weather blending | — | Keyed by ring rather than by region words (two vocabulary gaps). |
| `WorldBands.swift` · 729 | 9 band clocks verbatim (0.05, 1.05, flow, 0.0398, 0.0199, 0.0066, 0.0033, 0.062, 0.008 / 0.13), the 9 readings (key direction, strength, ambient, glow, drift), band stones as RoomMaterial (11 swells, 7 rows, 26 cracks, …). | W1–W9 clocks | — | **No band objects on the axis**: stones, ribs and lanterns become relief only (L52-78). |
| `WorldClimbScene.swift` · 963 | The axis scene: one ground morphing over 9 band materials, motes 900, one blended key (nil at ring 7), HDR. **Wave 2: 102 presences** (halo, core for all, crown for today), follow light, flight camera, fog swallow. | H-AXIS (the instrument) | seats, met, today | `solidsInTheClimb` tested. Sway on real time. |

---

## B · Parity table against `01-homes.md` (and `02` §A1)

Statuses: **BUILT**, **PARTLY** (what is missing), **NOT BUILT**, **BUILT WRONG / OVER-RESTRICTED**.

| Design element (register ref) | status | evidence (file:line) |
|---|---|---|
| Resolution order authored → grammar → seat (H-RESOLVE) | BUILT | `HomeRooms.swift:234-269` |
| Authored rooms keyed by position: 1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve (D §2) | BUILT. All 8 reachable by kp; Design's 4 lost rooms are restored. | `HomeRooms.swift:201-210`; `RoomReversal.swift:303-319` |
| M1–M8 mechanisms as Design drew them (H-MECH) | BUILT WRONG / OVER-RESTRICTED. Every number is ported, but each room is drawn as impressions in 3 stone slabs. Missing: Laghimā's cloth walls with lifting hems, rising field and unmoored seat; Sarva-Yoni's transmissive veined lathe with backlights; Vaśitva's spotlight, standing pillars and real shadow; Mahimā's lit seat-shaped frames and haze; Trikhaṇḍā's three tinted ghost rooms and triple-exposure composite; Aṇimā's "beyond" travelling toward you; the Bindu's gold line yantra standing in air and the source halo; Garimā's slab casting shadow, strata displacement and thickening fog. | `RoomMaterial.swift:17-23` (binding condition); `RoomScene.swift:79-129` (mechanisms may return only surface actions and stations); each room file's header lists what it refused (e.g. `PressRoom.swift:26-37`, `DissolveRoom.swift:200-204`, `KnownRoom.swift:31-36`) |
| Grammar: 50 tattva motions, first match wins (H-GRAMMAR) | BUILT, plus 3 appended rules, so 0 of 102 fall to `breathe` (Design had 3) | `HomeGrammar.swift:135-283, 371-436` |
| Archetype rooms rings 1–8 (siddhi / matrka / mudra / crossed / bodiless / cosmic / giving / revealing / sounding / sourcing) | PARTLY. Each mechanism and reversal is ported faithfully as marks. Design's lit objects (octahedra, letter slats, digit tubes, tori, sprites, icosahedra, wall shader) are flattened into the floor or face. | `RoomReversal.swift:256-298`; `OuterRings.swift:424-434` |
| Every room reverses its premise at b (H-CLOCK) | BUILT (stations plus answering mark, and words) | `HomeBecoming.swift:122-209`; `RoomReversal.swift:147-225`; `HomeWords.swift:56-71` |
| Adaptation clock 62 / 227 / 347; labels flip at 0.45 | BUILT (`HomeMemory` constants; RoomClock) | `RoomView.swift:61-135`; `HomeGrammar.swift:642-664` |
| Rite of Entering threshold: 3 touch-paced beats (phrase, Devanāgarī written, roots part over quality), compressed on return, stations .30/.62/.88 | BUILT as an overlay on the live 3D room | `Views/Rooms/RiteOfEnteringView.swift:257-446, 562-598` |
| Beat indicator pips (R-10, H-AXIS) | NOT BUILT, refused as a progress readout | `RiteOfEnteringView.swift:60-63` |
| The point becomes her room: flight from the axis, fog swallow ×1.6, presences vanish past 0.7 | BUILT on the climb only (the 1.1 s flight, then a full-screen cover hard-cuts to the rite) | `TheBuilding.swift:287-307`; `WorldClimbScene.swift:906-926`; `WorldClimbView.swift:247-260` |
| Nine worlds as weather W1–W9 (H-WORLDS) | BUILT twice: on the climb as ground relief and blended light, and inside every room as `RoomAir` bodies | `WorldBands.swift:218-533`; `RoomAir.swift:268-710` |
| World tempo on the world clock only; veil ×0.55 | BUILT | `HomeWorlds.swift:308-328` |
| Gem diffusion; Crown sourceless (no key) | BUILT (`key = nil`) | `RoomLightRig.swift:104-124`; `WorldBands.swift:450-467` |
| Atmosphere hue port, ±7° jitter, Ring 2 cluster seeds | BUILT | `HomeGem.swift:99-124` |
| Seat shape per ring (rite-core `room:`) | BUILT (RoomShell); not Design's extruded seatShell cross-section | `RoomShell.swift:46-56, 105-188` |
| Her attribute, the room's one actor: 26 forms, 52 keys, KIN, 15 tints, mount, grows to 3.5 (H-ATTR) | PARTLY. The motion and keys are exact, but **the form is never seen**: it is inscribed as dents whose verbs are read from velocity, and the tint is carried in `HomeAttributeActor` but no render path reads it. Design rendered noose, cup, lotus etc. as emissive shapes. | `HomeAttribute.swift:177-722`; `RoomScene.swift:471-477`; `RoomMaterial.swift:470-536` (no tint used) |
| Physics drift on the whole building | BUILT (roomHeight/20) | `RoomScene.swift:187-191, 497-498` |
| Descent "go deeper": 5 stations of the card as motion (H-DESCENT) | PARTLY. The shaft and the 5 words are there. The station objects (torus knot, 13 bars, root sprites, icosahedron, 3 tori) are refused and drawn as rim behaviours. The Rite's richer descent (R-12: function / somatic / icon chambers, depth bars, "the floor of her" card, rise control) is not built. | `HomeDescent.swift:21-43`; `DescentShaft.swift:163-208`; `RiteOfEnteringView.swift:462-503` |
| Descent station 2 lights *her* body bar (Design defect) | BUILT (fixed: her register runs true) | `HomeDescent.swift:212-235` |
| Doors: two neighbours; Ring 1 within family, Ring 2 within cluster first (§4.7, H-AXIS neighbourOf) | BUILT DIFFERENTLY. Plain ±1 on the garland, plus a third "sister" door. The family and cluster corridors are not built. | `TheBuilding.swift:35-51`; `Views/Rooms/HerRoomDoor.swift:126-139` |
| Crossing to a neighbour "from where you stand", no cut | PARTLY. The rite re-runs, but the passage swaps rooms with a 0.7 s opacity transition. | `HerRoomDoor.swift:84-98` |
| Library folded *beneath* the room (§4.5, H-AXIS library) | BUILT INVERTED. The Detail page is the front and the room is behind it. No library inside the room. | `ShaktiDetailView.swift:65-123, 179-199` |
| Well letter as a folded object in the room (§4.5) | NOT BUILT (no letter object anywhere in `Homes` or the rite) | grep: none |
| Portrait lines surfacing "at the pace of stillness" (brief; R-06) | NOT BUILT | grep: none |
| Return: compression 0.68ⁿ floor 0.36; head start 0.55·dwell capped at 221 s; dwell-keyed; record on leaving | BUILT (`HomeMemoryStore` keyed by kp) | `RiteOfEnteringView.swift:815-846`; `Models/HomeMemory.swift:82-131` |
| "you have stood here before" (once on return); floor traces (max 7); core light on met | NOT BUILT / REMOVED. No returning line (DECISIONS). Traces absent. Cores given to all 102 (C-1284). | `RiteOfEnteringView.swift:65`; `TheBuilding.swift:139-166` |
| Withheld fifth / per-ring sound / carrier from syllable | Outside `Homes/` (HomeVoice, HomeSoundService). `Glissando` added (minor third per station) | `TheBuilding.swift:523-541` |
| After-effect lighter / heavier / sharper / wider, decaying over minutes, **never named** | PARTLY. Kinds and the 180 s decay are built, **but the line "her siddhi is still on the instrument" is shown for 12 s** | `HomeAfterEffect.swift:28-46, 101-104` |
| Today: crown on her light, "she presides today", 6am handover | BUILT on the climb (`hold(seats:met:today:)`) | `WorldClimbScene.swift:807-852`; `TheBuilding.swift:369` |
| Instrument opens at today's āvaraṇa | NOT IN HOMES (the climb opens at the ring the Field has open; launch is the Bindu per ruling 1) | `TheHundredTwoView.swift:110-121` |
| Axis presences: 102 points of light, authored ones larger | BUILT | `TheBuilding.swift:61-188`; `WorldClimbScene.swift:807-852` |
| Climb rail of nine (region words, met tick) | BUILT (data); rendered in WorldClimbView | `TheBuilding.swift:315-341` |
| Ring Worlds mechanisms (scatter, follow / whisper, triad union, earth-city, lotus-sun, lineage, overflow, collapse) | BUILT as offsets on climb lights | `TheBuilding.swift:195-277`; `RingMechanisms.swift:27-124` |
| Gates of Release on ring crossings | BUILT (data; layer in `Views/Mandala/GatesOfReleaseLayer.swift`) | `TheBuilding.swift:395-492` |
| Ring 9 Praveśa / centre bloom / Mauna | BUILT as data (consumed in TheCentre, MaunaSilence) | `TheBuilding.swift:552-657` |
| **Rite of Entering light room R-09** (one-point seat interior: farL 20 → 82 % saturated aperture light field, per-Śakti aperture face point / triad / tri-down / ring16 / band / lens, `RiteYantraBeyond` at 0.34+0.5b arriving at b, bloom, shaft "light as a volume you are standing in", dhātu grain, sharpening blur, motes after a > .2) | NOT BUILT, NOT REACHABLE. Only `SeatShape` (room column) and `HomeAfterEffect.kinds` (after column) were taken from rite-core. | `RoomShell.swift:9-20`; `HomeAfterEffect.swift:28-32`; grep for ApertureFace / YantraBeyond: none |
| R-11 dwelling overlay: Devanāgarī cut into the wall above the light (30 px), quality, portrait band, letter slip, doors lit along the seat's edges, "go deeper" fading in at a ≈ .28 | PARTLY: `RoomWordsView` shows place / name / quality / near / deep; neighbour doors exist; the rest is not built | `HomeWords.swift:22-129` |
| R-02 rates (fast / even / slow / late: adaptation ×0.72–1.38) | NOT BUILT. The adaptation is a fixed 62 s for all 102 | `Models/HomeMemory.swift:82` |
| Personal Connection marginalia (the 9 paragraphs) | NOT BUILT in rooms | — |
| Bīja-locked visual rhythm; tattva as light / material modifier (brief gaps) | NOT BUILT (tattva sets only the motion) | `HomeGrammar.swift:299-307` |
| Reduced motion "longer and quantized, never disabled" (inv. 4) | BUILT WRONG against Design. The room is posed once at the settled state; there is no adaptation at all (FIDELITY chosen) | `RoomView.swift:29-54, 322-336` |
| Design-harness tests ported (own-ring resolution, no twin words, reversal, divergence, legibility, not gameable, no measuring) | Present as tests named throughout (`HomesHarnessTests`, `RoomSceneTests` …); not verified here (read-only) | e.g. `HomeRooms.swift:50-51` |

### B.1 · The view path, traced: from tapping a Śakti to what renders

1. **Mandala (LivingMandalaView).** The first tap on a seat flies to it and shows `SignificanceCard`, which offers "know her ›" and **"be with her ›"** (`Views/Mandala/SignificanceCard.swift:109-121`; `LivingMandalaView.swift:297-303`). A **second tap on the focused seat** opens `ShaktiDetailView` in a full-screen cover (`LivingMandalaView.swift:566-571, 202-203`). Tapping ring 9 (kp 102) opens the Mandala's Bindu descent instead (`:568`), so the DissolveRoom is never reached from the Mandala seat tap.
2. **Today** "know her ›" → `ShaktiDetailView` (`DailyRiteView.swift:122-123`). Today also has `RiteDayDoors` → room (`:433, 447`).
3. **Field (TheHundredTwoView)** row → `navigationDestination` `ShaktiDetailView` (`:44-45`). A separate onEnterRoom → room (`:184`).
4. **Gift (RootView)**, **Where She Speaks** → `ShaktiDetailView` (`RootView.swift:136`; `WhereSheSpeaksView.swift:114`).
5. **`ShaktiDetailView` (what most taps land on)** is a 2D SwiftUI page. `AtmosphereBackground` + `LightField` crown + `RiteSigil` + 10 `DustMotesView` + `DepthOverlay` (L204-222), then a `ScrollView`: hero (kicker "N Āvaraṇa", name 44 pt, Devanāgarī, phonetic, quality, description, cluster), one-page answer, codex portrait, somatic, bīja tap-to-hear, appreciation, doorways, witness page, deepening, embodiment ladder, field connection, two folds (L70-98). Footer: "be with her ›" (L180-199), play, and "I feel her" (L227-252). **This is Design's *Her Presence* (02 L-13), not her Home.**
6. Pressing "be with her ›" or "or the whole of her home ›" sets `herRoomKp`. `.herRoom` (`HerRoomDoor.swift:43-50`) presents `HerRoomPassage` full-screen. That calls `RiteOfEnteringView.entering(shakti, …)` (`:103-109`), which resolves `HomeRooms.resolve(shakti)` (`RiteOfEnteringView.swift:798`) and draws `RoomView` (3D SceneKit and Metal light pass) under the three beats, `ScoreLightVeil` (a radial plus-lighter gradient) and, once inside, `RoomWordsView`, `NeighbourDoorsView` and `RoomGameLayer` (Trinity voice and ActivationCycle) (`RiteOfEnteringView.swift:256-292`; `HerRoomDoor.swift:85-96`).
7. **The climb** (WorldClimbView, from the Field's "rise through them ›" or the Mandala's ways-in "climb") → touch a light → a 1.1 s flight → the same `.herRoom` (`WorldClimbView.swift:247-260, 154`).

**Why it looks basic.** (a) The default landing is the Presence page, with the Home behind a text link. (b) Inside the Home, the mechanism layer may only dent three dark stone surfaces (ink at l = 12 %) at 64², so the authored rooms' luminous geometry (Design measured rooms at 80–255 luminance) is reduced to relief raked by one key. (c) The R-09 saturated light room never existed in Swift. (d) Reduce motion freezes the room at its end state, so on a device with Reduce Motion on, the room never adapts at all.

---

## C · What the upgrade must do: Her Home and Her Presence at Design parity

**Her Home (the room)**
1. **Make the room the Home and the Detail the library.** A tap on a Śakti, and Today's door, should open `HerRoomPassage` directly (through the rite). Move `ShaktiDetailView`'s sections into an in-room "the library" sheet, as Design's H-AXIS library (rows: quality, tattva, location, etymology, inscription, Devanāgarī, bīja, āvaraṇa, form, world, clock, altitude, yoginī, state, verb). Keep the Detail reachable as Her Presence. Mandala ring 9 should offer DissolveRoom as well as the Bindu descent.
2. **Lift the binding condition in the mechanism layer, as Charter II §4.5 already did for the air.** Let `RoomSurfaceMechanism` return light bodies and non-figural geometry in the `her` and `world` layers (cloth planes with a vertex shader, a transmissive lathe, pillars plus a spotlight with shadows, line-loop frames and yantras, tinted ghost shells). Port each authored room's three.js recipe from 01 H-MECH M1–M8 literally; the current files already hold every number. Then upgrade the ten archetypes from 01 H-GRAMMAR to their Design objects: octahedron capacity plus echo loops, letter slats plus voice column, digit tubes, tori plus sprites, the petal sprites around a rim, 14 triangle loops, the spiral gifts and cup, icosahedra under a lit veil sphere, the sounding wall shader with node sprites, the triangle with three lamps. Keep the stone inscription as a second register, not the only one.
3. **Show her attribute as a lit, aniconic performing shape** (H-ATTR geometry table) at her mount, tinted by `HomeAttribute.tints`. The motion code in `HomeAttribute.act(at:)` is ready to drive transforms directly.
4. **Build the Rite light room (02 R-09/R-11) as a mode of the Home**: the one-point seat interior with farL 20 → 82 %, aperture faces per Śakti, the Yantra Beyond arriving at b, the shaft volume, grain, sharpening blur, motes after a > .2, the Devanāgarī cut above the light, and the **portrait lines surfacing by stillness** (10.5 s + 6.5 s per line, ratcheted, only after a ≥ .4, from codex portrait or Function / Somatic / Icon). Add the **Well letter slip** (read only, by kp) and the **rates** channel (fast / even / slow / late multiplying the 62 s adaptation) as the second uniqueness channel.
5. **Doors as Design ruled**: Ring 1 within family, Ring 2 within cluster, then ±1; the crossing starts from where you stand (no full-screen swap); keep the sister door.
6. **Descent**: restore Design's station objects (torus knot, body bars with hers alight, root sprites joining into one word, icosahedron, phrase tori) and add the Rite's chambers (function / somatic / icon) plus "the floor of her" card. Data: Function, Somatic and Iconography text per kp.
7. **Return**: "you have stood here before" once, floor traces (max 7), forget-me. These are felt rulings for Ashrey; rule on them against C-1284.
8. **After-effect**: decide whether the "her siddhi is still on the instrument" line stays (Design says never named).
9. **Reduce motion**: quantized adaptation steps (02 R-04: a in 4 steps, b in 3, longer durations) instead of a frozen end state.
10. **Sound per room** (outside Homes): verify the withheld fifth against beat 2's ×1.5 strike.

**Her Presence (the portrait page)**: `ShaktiDetailView` already matches 02 L-13 closely (hero, portrait, somatic, bīja rings, appreciation, embodiment, moments, go deeper, "I feel her"). To reach parity: kicker "{Ordinal} Āvaraṇa · {form}" (it lacks the form, `ShaktiDetailView.swift:379-385`); portrait fallback to the ring's `personalConnection`; go-deeper rows Her ring / Form / Mental state / Chakra (currently iconography, lineage, function, tattva, seat, etymology); and remove the stacked Wave 5–6 sections (doorways, witness, deepening) that turn the presence into a long page. It should not be the gate to the Home.

**Gaps and conflicts noted**
- `RoomMaterial.swift` still calls itself binding (L17-28) while `RoomScene.swift:33-50` and `RoomAir.swift:6-20` say Charter II lifted the binding condition. The air holds solids (ribs, lanterns, prism) but her mechanism may not. That inconsistency is the root of the flat rooms.
- `HomeRooms.swift:86-133` still carries "PHASE 3.3 fills these in" placeholder types; they are dead now that `RoomMechanisms.authored` exists.
- The attribute tint is computed and never rendered.
- `ClimbLights.breath(met:)` ignores `met` on purpose. Design's met distinction is gone (Codex ruling C-1284, not Design).
- Story-flavoured lines (ClimbSummit "I am what I am becoming." / "I already did."; Pravesha's four lines) are Codex or Design text in an energy app. Flag them for the Bindu Feed question; do not drop them.

---

## D · Coverage proof

All `.swift` files under `Homes/` were read with the Read tool, line 1 to EOF, in single reads (no file exceeded the page). md5 is the first 8 characters.

| file | lines (wc -l) | read | method | md5 |
|---|---|---|---|---|
| Homes/ClimbSummit.swift | 49 | 1–49 | Read | 3c75bfab |
| Homes/HomeAfterEffect.swift | 116 | 1–116 | Read | 68da84c7 |
| Homes/RingMechanisms.swift | 124 | 1–124 | Read | ff2fff6e |
| Homes/HomeGem.swift | 125 | 1–125 | Read | 4c5f0948 |
| Homes/HomeWords.swift | 130 | 1–130 | Read | 3aab0396 |
| Homes/HomeBecoming.swift | 211 | 1–211 | Read | 7b766c00 |
| Homes/HomeRooms.swift | 286 | 1–286 | Read | 38acb17c |
| Homes/HomeWorlds.swift | 329 | 1–329 | Read | e1f143d8 |
| Homes/HomeDescent.swift | 345 | 1–345 | Read | e779511f |
| Homes/TheBuilding.swift | 657 | 1–657 | Read | d42b917e |
| Homes/HomeAttribute.swift | 930 | 1–930 | Read | 95d805b3 |
| Homes/HomeGrammar.swift | 931 | 1–931 | Read | a17092bd |
| Homes/Render/ReleaseRoom.swift | 170 | 1–170 | Read | 3d326165 |
| Homes/Render/ContractRoom.swift | 172 | 1–172 | Read | dc6fa300 |
| Homes/Render/RoomApproach.swift | 200 | 1–200 | Read | 7b9fee72 |
| Homes/Render/KnownRoom.swift | 244 | 1–244 | Read | 96c8ed10 |
| Homes/Render/DescentShaft.swift | 257 | 1–257 | Read | 65a1841c |
| Homes/Render/EndlessRoom.swift | 260 | 1–260 | Read | 0988fec7 |
| Homes/Render/SiddhiRoom.swift | 261 | 1–261 | Read | 5f57b105 |
| Homes/Render/RoomShell.swift | 263 | 1–263 | Read | dddbeefb |
| Homes/Render/RoomLightRig.swift | 264 | 1–264 | Read | 5ff0afdb |
| Homes/Render/TripleRoom.swift | 269 | 1–269 | Read | 91693407 |
| Homes/Render/PressRoom.swift | 277 | 1–277 | Read | 81bbb0e8 |
| Homes/Render/MatrkaRoom.swift | 300 | 1–300 | Read | 0b157070 |
| Homes/Render/RingOne.swift | 322 | 1–322 | Read | 0db320a2 |
| Homes/Render/RoomReversal.swift | 335 | 1–335 | Read | 491f501d |
| Homes/Render/MembraneRoom.swift | 337 | 1–337 | Read | 8ac6fa4c |
| Homes/Render/SourcingRoom.swift | 338 | 1–338 | Read | 61da80db |
| Homes/Render/BodilessRoom.swift | 392 | 1–392 | Read | a41d1eea |
| Homes/Render/MudraRoom.swift | 416 | 1–416 | Read | 285c37fd |
| Homes/Render/OuterRings.swift | 435 | 1–435 | Read | a6319b05 |
| Homes/Render/WorldClimb.swift | 481 | 1–481 | Read | 7d70c5df |
| Homes/Render/RoomView.swift | 498 | 1–498 | Read | 55bf6877 |
| Homes/Render/CrossingRoom.swift | 504 | 1–504 | Read | 1d6f9db0 |
| Homes/Render/RevealingRoom.swift | 508 | 1–508 | Read | c32591dd |
| Homes/Render/SoundingRoom.swift | 509 | 1–509 | Read | da88f7e3 |
| Homes/Render/RoomMaterial.swift | 537 | 1–537 | Read | 81179f53 |
| Homes/Render/GivingRoom.swift | 540 | 1–540 | Read | cd5b902b |
| Homes/Render/CosmicRoom.swift | 541 | 1–541 | Read | 377ee6ab |
| Homes/Render/RoomUnits.swift | 555 | 1–555 | Read | f5ee64ba |
| Homes/Render/DissolveRoom.swift | 608 | 1–608 | Read | 56655447 |
| Homes/Render/WorldBands.swift | 729 | 1–729 | Read | a155e42f |
| Homes/Render/WorldClimbScene.swift | 963 | 1–963 | Read | 10daea7b |
| Homes/Render/RoomAir.swift | 1118 | 1–1118 | Read | 9c5268c1 |
| Homes/Render/RoomScene.swift | 1242 | 1–1242 | Read | 276332c1 |
| **Homes total (45 .swift)** | **19,078** | all | | |
| Homes/Render/RoomLightPass.metal (extra) | 162 | 1–162 | Read | fc7bc569 |
| waves/register/01-homes.md | 1043 | 1–1043 | Read (pages 1–150, 150–270, 270–390, 390–540, 540–700, 700–880, 880–1043) | 8381e766 |
| waves/register/02-rite-axis-field.md | 1673 | 1–308 (§A1 in full) and 677–721 (L-13 Her Presence) | Read; rest of the file not assigned | c9cb6e9b |
| Views/Common/ShaktiDetailView.swift (trace) | 1145 | 1–1145 | Read | e642cab2 |
| Views/Rooms/HerRoomDoor.swift (trace) | 140 | 1–140 | Read | 7697dbf1 |
| Views/Rooms/RiteOfEnteringView.swift (trace) | 869 | 1–869 | Read | aa35d774 |
| Views/Rooms/ScoreLightVeil.swift, RoomGameLayer.swift (trace) | 42, 28 | all | cat | 7f40cdbe, 1f4df287 |
| Views/Mandala/LivingMandalaView.swift (trace) | 772 | 280–319, 360–384, 550–579, 725–754 plus grep | partial, tap handlers only (not assigned) | 13a94bcb |
| Services/HomeDwelling.swift (trace) | 225 | ~1–125 skimmed | partial (not assigned) | 600a8884 |

---

**Return message:** `waves/register/18-code-homes.md` (about 230 lines). Ten most valuable gifts and findings:
1. The 3D room engine is real and keyed by kp, with all 8 authored rooms reachable (Design's 4 lost rooms are restored). What remains is **routing**: make the room the Home, not a link at the foot of the Detail page.
2. Every Design number for M1–M8 and the 10 archetypes is already in Swift. A renderer upgrade can draw Design's luminous geometry from these files without re-deriving anything.
3. Lift the mechanism-layer binding condition, as Charter II already did for `RoomAir`. That inconsistency is the main cause of the flat rooms.
4. Port the never-built **Rite light room (R-09)** as a Home mode: saturated aperture field 20 → 82 %, per-Śakti aperture face, the Yantra Beyond arriving at b.
5. **Portrait lines surfacing by stillness** (10.5 s + 6.5 s per line, ratcheted) are not built.
6. **Her attribute forms** (26, with tints) are computed every frame but invisible. Render them as lit aniconic shapes.
7. `RoomAir` already carries all nine band recipes (caustics, 72-rib colonnade, ruby lanterns, chatoyance, gem lamps and yantra) and can be reused on the climb, which currently shows only relief.
8. Design's **family and cluster corridors** for doors and the **rates** uniqueness channel are not built.
9. The **descent chambers** (function / somatic / icon) and the "floor of her" card from the Rite are missing; the Axis descent objects were refused.
10. Reduce motion freezes rooms at their end state. Quantized adaptation (02 R-04) would restore the mechanism for those walkers.
