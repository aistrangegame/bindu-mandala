# THE REGISTER · 20 · Code: Play and Rooms, and the 33 parity check

*Reader 20 · second reading · 12 Oct 2026 · read-only*

**Scope.** I read every `.swift` file in `iOS/Bindu Mandala/Views/Play/` (17 files, 6,906 lines) and `iOS/Bindu Mandala/Views/Rooms/` (15 files, 3,923 lines) in full, line 1 to the end.

Section B asks why the 33 rooms read as text pages. To answer it with file and line, I also read the whole of the chakra room's own code:

- `Views/Chakra/ChakraRoomView.swift`, `ChakraRoomDoor.swift`, `ChakraMovementPractice.swift` and `ClimbBodyChakras.swift`
- `Models/ChakraConstellation.swift`, `ChakraTeaching.swift` and `ChakraMovement.swift`

I parsed the shipped bake `Data/ChakraConstellation.json` structurally, with field presence only. I compared all of this with registers 05 and 06, and Section D lists every range read.

**Paths used below.**

- `P/` = `iOS/Bindu Mandala/Views/Play/`
- `R/` = `iOS/Bindu Mandala/Views/Rooms/`
- `C/` = `iOS/Bindu Mandala/Views/Chakra/`
- `M/` = `iOS/Bindu Mandala/Models/`

**One-line answer.** The app has two room systems. The **102 Śakti rooms** (`R/`) are fully immersive:

- a SceneKit room you travel into through a three-beat rite
- a five-station descent
- a held way out
- a corridor to neighbours
- an activation cycle
- an after-effect on the whole app

The **33 chakra rooms** (`C/ChakraRoomView.swift`) are one `ScrollView` of stacked headed text sections over a background. That background has **7 looks shared by kind**, not 33 (`C/ChakraRoomView.swift:88-102`; `C/ChakraRoomDoor.swift:88-143`).

Several parts of the corpus's braid are missing entirely: the DotStage protagonist, the SilenceEngine, breath pacing, the gate types, the dance strand and the pulse. The immersive grammar was built for the Śaktis and never applied to the chakras.

---

## A · INVENTORY — per-file map

Each entry gives: file · lines · purpose · world · register items · data · hard-coded restrictions · defects.

### A.1 `Views/Play/` (A Strange Game / Lalitā's field)

**A.1.1 `P/PlayModels.swift` · 131 lines.** This is the protocol every game implements.

- **Purpose.**
  - `PlayModel` (`advance`, `draw`, `began`, `moved`, `ended`, `hasCaption`, `caption`, `give(word:)`, `meet(_ words:)`) is at :10-36.
  - `PlayWords {name, appreciation, function, quality}` is at :39-44.
  - `FrameClock` clamps dt to ≤1/20 s (:56-64).
  - `PlayRipple` is at :67-85: life 1.6 s, reach 140, radius `6 + reach·(1−(1−p)^2.2)`, alpha `.55(1−p)`.
  - The factory `PlayModels.make` covers 36 cases (:88-127).
  - `pointHz = 136.1` is the point's pitch (:130).
- **World:** A Strange Game.
- **Data:** `PlayGardenStore.shared` is used by Seed, World in a Box and Great Wheel.
  - Rosary starts at `startPosition ?? 102`.
  - Letter is addressed `to: startPosition ?? 88`.
- **Restrictions:** the doc says words given to a game are "released from the view when the game ends, never kept on the glass", except the Letter (:25-30). Answers come only from her rows, "charter law 8: authored, never generated" (:32-34).
- **Defects:** none.

**A.1.2 `P/PlayGame.swift` · 423 lines.** The 36 games and where they live.

- **Purpose.**
  - `PlayAddress` = `.seat(kp)`, `.ring(r)`, `.threshold(from,to)` or `.garland` (:19-44).
  - `PlayHandoff` = `.recognition` or `.stillness` (:48-51). Its doc says "Never a screen that congratulates him".
  - `PlayGame` (:55-356) gives each game a `title`, a `verb` (:143-181, the one word under its light), a `hint` (:185-224, shown about 7 s), `usesMotion` (:227-233: waterLevel, shakeToClear, rain, mirrorMaze, stillAjna, sandhya, worldInABox, leela), `address` (:237-281), `handoff` (:284-297), `hue` (:301-340) and a `ground` per ring (:343-355).
  - `PlayAddressBook` (:360-390): `door(forPosition:)` returns the seat's game, or else the rosary opened at her bead. As a result, every one of the 102 has a game door.
  - `Shakti.playPosition = khadgamalaPosition ?? position+28` (:398).
  - `PlayField.open` posts the notification `BinduPlayFieldOpen`; `PlayField.host` builds a host (:407-423).
- **Addresses (verbatim table, :239-279):**

| Game | Address |
|---|---|
| corridor | threshold 3→4 |
| pulse | seat 70 |
| spineWalk | seat 84 |
| echo | seat 80 |
| fingerGarden | seat 69 |
| rain | seat 71 |
| drum | seat 53 |
| rootSystem | seat 4 |
| waterLevel | seat 15 |
| fire | seat 65 |
| shakeToClear | seat 82 |
| door | seat 94 |
| yantraTrace | seat 102 |
| rosary | garland |
| bijaTones | ring 1 |
| coherence | seat 70 |
| seed | seat 26 |
| mandalaCompletion | ring 7 |
| twelve | ring 7 |
| bodyMap | seat 77 |
| shadowTranslator | seat 101 |
| mirrorMaze | seat 30 |
| letter | seat 88 |
| worldInABox | ring 9 |
| colourRivers | seat 20 |
| shadowScrolls | threshold 3→4 |
| stillAjna | seat 51 |
| flash | seat 91 |
| tatTvamAsi | threshold 6→7 |
| leela | seat 102 |
| turn | ring 8 |
| join | seat 92 |
| ramJapa | seat 42 (his name; his ruling of 12 Oct) |
| bhakti | seat 24 |
| sandhya | ring 2 |
| greatWheel | ring 1 |

- **Hand-offs.** `.stillness` for corridor, waterLevel, shakeToClear, bijaTones, mandalaCompletion, twelve, letter, worldInABox, shadowScrolls, tatTvamAsi, turn, ramJapa, sandhya, greatWheel and rosary (a held bead gives Recognition). Every other game hands off to Recognition.
- **Restrictions:** the game title is "never a heading on the glass" (:98-99). Each game has one verb word and a hint for its first breaths only.
- **Defects:** `rosary` defaults to `.stillness` (:291-293) but completes `.recognition` on a held bead. That is intended, but the comment conflicts with the switch.

**A.1.3 `P/PlayFieldView.swift` · 317 lines.** Lalitā's field: all 36 games as lights on one screen.

- **Layout.**
  - `PlayFieldLayout.point` places each light by address: the ring distance is `radius·(9−ring)/8`; seat angle = `−π/2 + 2π(i−1)/n`; twins are nudged ±0.16; ring-9 lights sit at 0.16 radius; the garland sits at 1.1 radius.
  - `relaxed()` eases the lights apart to a minimum of 50 pt over 80 passes. The Śrī Yantra light is pinned to the centre (:73-110).
- **Drawing (:245-274).**
  - Rings 2–8 in gold at 0.07–0.10 alpha.
  - A square rim.
  - A glow in the seasonal ṛtu colour.
  - A garland of 102 beads turning once every 180 s.
  - Her point (accentRed 120 pt, gold 40 pt) breathing on a 9 s cycle.
- **Words.** The header reads **"LALITĀ · THE PLAY THAT KNOWS ITSELF"** (:167). The back button reads "‹ return". The foot words are "the modes" (opens `ModesDoorView`) and "the road" (`MandalaWays.ask(.road)`) (:177-183).
- **Entering a game.** A tap plays a 272.2 Hz tone and opens `PlayGameHost` as a full-screen cover (:221-243).
- **Presenter.** `PlayFieldPresenter` answers `OPEN_PLAY[=<game>]` and the notification (:283-313).
- **World:** A Strange Game. This is the one place every game is gathered.
- **Restrictions:** "a way, not a list" (:203). There is no menu, no grouping and no title per light, only the verb.
- **Defects.**
  - **Design defect:** 36 lights crowd one disc. This is exactly the "worlds flattened into one screen" pattern the brief names. No game has its own world before it is entered.
  - Lights are labelled only by verb, so "become small", "bring together" and so on are hard to find again.

**A.1.4 `P/PlayGameHost.swift` · 491 lines.** The one host every game is played inside.

- **`PlaySession` (:18-83).** Phases are playing → gathering → still.
  - `engaged` = acts ≥ 3 and ≥ 6 s.
  - `rest(on:)` (garland), `playing(ring:)` (bīja tones), `complete(_:at:)`, and `ask(_:prompt:)` for word games.
- **`PlayLedger` (:87-134).** Writes one App Activity row through `ActivityLedger.played(game:place:linkRecordId:seconds:at:)`.
  - The link goes to her Shakti record, or else the Avaraṇa record of the ring.
  - The place is "The Shadow crossing", "The Armin crossing", "The garland" or "Nth Āvaraṇa".
- **Host (:138-368).**
  - Draws the ground, then the stage, then stillness.
  - Shows the hint for 7 s, then fades it over 1.6 s.
  - "‹ leave" writes the ledger row if engaged.
  - The word field is set in Sanskrit type at 30 pt and asks "one word" (:255-277).
  - Hand-off: the row is written first, the drone goes to 0, a bloom haptic plays, then after 1.6 s it either feels her (`RecognitionMomentView(source: .play)`) or settles.
  - `writeOnce` also notes `PlayTraceStore` (Portrait layers) and `PlayGardenStore.record` (World in a Box) (:349-367).
- **`PlayStillness` (:442-491).** A 9 s breath of glow plus her name. "Feel her — ..." opens Recognition.
- **Data:** Shakti `name`, `appreciationPhrase`, `shaktiFunction`, `quality`, `airtableRecordId` and `khadgamalaPosition`.
- **Restrictions (verbatim, :12-13):** *"There is no end screen. Nothing on this glass says how long he played, how well, or how often — storage may count; the screen may not."*
- **Defects.**
  - The header comment says "One shell for all sixteen" (:6), but there are 36.
  - The hint disappears after 7 s and cannot be recalled.

**A.1.5 `P/PlayInstruments.swift` · 348 lines.** The touch, motion, sound and haptic instruments.

- **`TouchSenseSurface`** (:34-88) is a UIKit view that reads force or pad radius into a pressure value.
- **`PlayMotion`** (:96-124) reads CoreMotion at 60 Hz: gravity x/y/z, `shake = |userAcceleration|` and `roll`.
- **`PlayHaptics`** (:128-151):
  - tap = soft impact
  - thump = heavy impact
  - tick = selection
  - heartbeat = thump, then a tap at 0.7 after 0.15 s
  - bloom = success notification
- **`PlaySound`** (:163-328) is its own AVAudioEngine with 6 voices plus a looping drone.
  - The session is `.ambient` while a game is open and returns to `.playback` with mixWithOthers on close. It claims `SoundConductor` as `.play`.
  - `tone(f, gain, duration, partials)` is a struck tone: 12 ms attack, decay `exp(−3.2t/dur)`.
  - `thump(depth)` sweeps 95→42 Hz over 0.45 s.
  - `heartbeat` is lub 68 Hz then dub 52 Hz at +0.14 s, 0.36 s long.
  - `drone(f)` loops a 10 s sum of f + 0.45·1.5f + 0.25·2f.
- **`GraphicsContext.glow` / `core`** helpers are at :332-347.
- **Restrictions:** honours the silent switch.
- **Defects:** none seen.

**A.1.6 `P/PlayPhysics.swift` · 556 lines.** Pure physics for the Wave 4 games.

- **Laws (verbatim, :9-18):** "Failure is present-tense physics … Force is absorbed, never punished … Storage may count; the screen may not."
- **Constants:**
  - **TouchSense:** absorb = `tanh(1.6x)/tanh(1.6)`; pad = `(majorRadius−7)/28`.
  - **CorridorPace:** a step every 0.8–1.2 s; 24 steps to cross; a hurried step adds 0.34 to `press`, which relaxes at 0.45/s.
  - **HeartbeatCatch:** a gap over 2.4 s resets; caught at ≥8 taps with steadiness ≥ .55; a plausible period is 0.4–1.5 s.
  - **SpineLight:** 10 stations at 0.05 + 0.1·i; rest 0.9 s; max speed 0.55/s.
  - **EchoExchange:** ratios 1, 9/8, 5/4, 4/3, 3/2; base 272.2; rhythm match within 28%.
  - **GardenGrowth:** rate `1/(1+s/180)`; drone gain `min(.18, n·.014)`; bloom at 12 stems.
  - **RainWind:** 4 breaths; a breath is a swipe of 2.2–9 s with travel > 0.35.
  - **DrumBeat:** period 1.0 ± 0.18 s; depth 20.
  - **RootGrowth:** `depth += dt·s²·reach/22`.
  - **WaterVessel:** stiffness 9, damping 1.6, max angle .45, settles after 12 s still.
  - **FireBand:** band 0.15–0.82; burns at 0.11/s; needs 60 s tended; feed adds 0.12 + 0.14·p.
  - **ShakeClear:** threshold 0.9 g.
  - **DoorHold:** 2.8 s; gentle ≤ 0.62. Wave 6, C-1357: a hard press is absorbed and the door no longer dims.
  - **YantraTrace:** triangle order [4,8,3,7,2,6,1,5,0]; tolerance; `traces()`.
  - **Rosary:** slip 0.35 s; rest to feel 1.6 s.
  - **AwakeningTones:** rings 1–8 → 174, 210, 320, 341, 384, 426, 480, 528 Hz, and ring 9 = silence. Pulse period = `60/(f/5)`; tuned when the last 6 intervals are within 6%.
  - **Coherence:** breath 5–14 s; meeting ≥ 0.7 for three breaths.
- **Defects:** none in the physics.

**A.1.7 `P/PlayPhysicsWhole.swift` · 796 lines.** Pure physics for the Wave 6 games.

- **Helpers:** `PlayMath` (clamp, wrap, carry, a deterministic shuffle).
- **Per-game physics:**
  - **SeedGrowth:** seed < 2 h, sprout < 8 h, sapling < 24 h, tree < 72 h, then bloom. **SeedPress:** 2.4 s still.
  - **MandalaPetals:** rounds of 8, 12 and 16 petals; the missing petal = `(round·5+3) % n`.
  - **TwelveCircle:** a circle of fifths from 272.2 Hz, folded below 544.4 Hz.
  - **BodyListening:** 1.2 s rest; pressure < .12 = open, < .55 = alive, else held.
  - **TurningWord:** max rate 1.6 rad/s.
  - **MazeFall:** 7 lenses; opening .26; fall rate .16; lens y = .16 + .11k.
  - **WaxSeal:** 2.2 s. **LetterFold:** rate .7. **FlashCatch:** shows .95 s; reach 70.
  - **WaitingDark:** 30 s. **ThreeWords:** Tat / Tvam / Asi; one breath = 2.6 s.
  - **ScrollUnroll:** **12 lines verbatim (:361-374)**, ending *"You are a bigger container now."* 110 pt of pull per line; max 260 pt/s.
  - **RiverMingle:** reaches the sea after 14 s of overlap.
  - **WorldBox:** game → thing map (:422-435); gifts = one per whole day away, at most 3; golden-angle placement.
  - **LeelaBoard (:456-477):** 33 squares; held = 32; arrows {5:8, 12:18, 13:20, 26:29}; snakes {15:6, 19:10, 28:21, 30:9}.
  - **LeelaWalk (:479-507):** starts unborn; a six = born at square 1; overshoot rests; exact 33 = arrived. The board spot is a spiral of 1.5 turns, `radius = sin(uπ)`.
  - **TurningRings:** tolerance .09, friction 1.8, coupling .3.
  - **JoinMeeting:** touch 34; gentle ≤ 260.
  - **JapaMala:** 108 beads; a breath in lasts 1.8–14 s.
  - **Arati:** gentle 0.3–2.4 rad/s; 7 circles.
  - **SandhyaPractice:** invitations are verbatim at :639-641. Junction names: Prātaḥ, Madhyāhna, Sāyaṃ.
  - **JunctionLight:** rate .12.
  - **SeasonLight:** colour, intensity and **poetry** for each ṛtu (:721-727).
  - **GreatWheel:** the year's angle from the solstice; spin friction .9; catch within .35.
  - **LotusSun:** openness.
- **Defects.**
  - The `TurningWord` doc (:193-196) speaks of "the ring's Mental State … its Siddhi". The real mapping is a letter-sum into kp 1–10. The doc is stale.
  - `LeelaWalk` has **no "a six throws again"** rule and no triple-six rule (corpus C.8: "every six throws again"). This is a ruling gap, not a crash.

**A.1.8 `P/PlayGamesElements.swift` · 431 lines.** Drum (kp 53), Root System (kp 4), Water Level (kp 15), Fire (kp 65), Rain (kp 71).

- **Drum:** strata, a root growing toward the water table, branches every 4 depths. On-beat strikes thump and haptic; off-beat strikes shiver.
- **Root System:** each still finger grows a root; drone at 68 Hz; a haptic every 1.3 s.
- **Water Level:** tilt plus finger nudges plus random "thoughts" every 5–8 s; drone at 210 Hz; the surface brightens to a mirror.
- **Fire:** up to 420 sparks; smoke when roaring; two horizon lines mark the band; a stick plays 320 Hz with partials 2.76 and 5.4.
- **Rain:** up to 500 drops; wind from swipes and roll; chimes from [426, 480, 568, 640]; a breath tone at 213 Hz.
- **Defects:** none.

**A.1.9 `P/PlayGamesField.swift` · 200 lines.** Finger Garden (kp 69) and Shake to Clear (kp 82).

- **Finger Garden:** up to 24 stems; each tone is 220 × [1, 9/8, 5/4, 3/2, 5/3]; drone at 110 Hz; bloom at 12 stems.
- **Shake to Clear:** **22 drifting words, verbatim (:187-192):** "should have, what if, not enough, tomorrow, remember, sorry, always, never, too much, they said, I said, why did I, I should, maybe, one more, I meant to, almost, eventually, if only, somehow, but still, deadline".
- **Defects:** none.

**A.1.10 `P/PlayGamesHeart.swift` · 231 lines.** Pulse (kp 70), Coherence (kp 70) and Echo (kp 80).

- **Pulse:** after 8 steady taps, the light beats three more times at his period, then Recognition.
- **Coherence:** the left half of the screen is the breath and the right half is the heart. A breath wave and a heart wave meet. The drone sits at 136.1 Hz.
- **Echo:** he taps a call, waits 1.6 s, and she answers his rhythm. Each echo climbs root → 2nd → 3rd → 4th → 5th, and the fifth hands to Recognition.
- **Defects:** none.

**A.1.11 `P/PlayGamesPassage.swift` · 239 lines.** Corridor (3→4), Door (kp 94) and Spine Walk (kp 84).

- **Corridor:** 12 rings travel outward with each step (`pow(.74,k)`). The walls cool and press closer when he hurries. A door of light grows to `10 + 120·shown^1.6`.
- **Door:** 7 rings scale with `1+1.6·open²`; an arch path; a quarter tone at 480·(1+.06q).
- **Spine Walk:** 10 stations on a just scale from 272.2 Hz (:179).
- **Defects:** none.

**A.1.12 `P/PlayGamesPattern.swift` · 636 lines.** Mandala Completion, the Twelve, Turn, Join and Leela.

- **Mandala Completion:** a dashed ghost petal; a stroke that misses fades over 0.8 s; three rounds.
- **Twelve:** drag to swap two lights; a closing chord on tones 0, 4 and 8.
- **Turn:** 3 rings with a notch tick every π/6.
- **Join:** two names drawn from the Road (`road[i]`, `road[i+16]`). When they meet, the third light shows **Invention's (kp 92) Map essence** (:347-349).
- **Leela (:452-636):**
  - The road is drawn as a spiral path. Arrows are gold lines; snakes are dashed violet curves.
  - The squares are coloured with Map hex values. Square 32 is drawn as an empty ring (:565-568).
  - The token is peacock-coloured (0.06, 0.62, 0.60).
  - The die shows pips, never a numeral (:587-596). Hold the die, then let go: the throw lasts 0.6–1.4 s by how long it was held. A shake above 1.4 g is also a throw (:494-498).
  - Gliding plays a tick and a tone at 272.2·(1 + n/33).
  - **A landing draws the chakra's name (22 pt Sanskrit type) and its Map essence (15 pt) at the top of the screen (:597-606). That is the whole landing.**
  - Arrival at 33 hands to Recognition of kp 102 after 2.6 s.
- **Defects.**
  - The Leela walk lives only in the model. Leaving loses it; there is nothing like corpus `asg.leela33`.
  - There is no intention ("What are you bringing to the board?"), no square sheet, no "One move", and no "Throw again / Rest here".
  - Landings write no ledger row; only the whole game writes one.

**A.1.13 `P/PlayGamesSacred.swift` · 429 lines.** The Scrolls (3→4), Still · Ājñā (kp 51), Tat Tvam Asi (6→7), Rām japa (kp 42) and Bhakti (kp 24).

- **Verbatim lines:**
  - Still · Ājñā: *"What do I see\nwhen I stop looking?"* · *"The screen will wait.\nClose your eyes."* (:93)
  - Tat Tvam Asi: *"Nothing needed repair."* (:169)
  - Rām japa: the name **राम** (:264)
  - Bhakti scale: 1, 1.125, 1.25, 4/3, 1.5, 5/3, 2 (:349)
- **Tat Tvam Asi aurora:** 7 bands, hue 0.55–0.95.
- **Rām japa:** an elliptical mālā of 108 beads with the meru in gold.
- **Defects:** none.

**A.1.14 `P/PlayGamesTime.swift` · 257 lines.** The Sandhyā (ring 2) and the Great Wheel (ring 1).

- **Sandhyā:** the junction is chosen from today's sun times. The dawn, noon and dusk skies are gradient triplets (:53-62). Dawn is drawn up, noon is still or face-up, dusk is drawn down.
- **Great Wheel:** six season sectors; the days he played are lights on the rim; today is drawn to the top; the seasonal yantra lights up with the ṛtu name and poetry.
- **Defects:** dead code `let c = SeasonLight.colour(rtu); _ = c` (:173-174).

**A.1.15 `P/PlayGamesWords.swift` · 486 lines.** Shadow Translator (kp 101), Mirror Maze (kp 30), the Letter (kp 88) and Flash (kp 91).

- **Shadow Translator:**
  - The burden word → `gift = 1 + letterSum % 10` → one of the 10 Siddhi Śaktis (kp 1–10).
  - The coin is turned by circling; its back shows her name and Appreciation Phrase.
- **Mirror Maze:** the 7 energy chakras by Road act as lenses; tones come from `AwakeningTones` by ring; essences appear under each lens.
- **Letter:** sealed into `CorrespondenceStore` with `.tithiReturns` (:295-297).
- **Flash:** verbatim lines *"One breath." / "Something already knows." / "Don't word it yet." / "Give it one word."* (:374). An in-breath of at least 2 s, then flashes.
- **Restrictions:** no AI. *"here every answer is his own word or a Śakti's own row"* (:6-8).
- **Defects:** Mirror Maze completes through `DispatchQueue.main.asyncAfter(2.2)` (:182). If he leaves inside that window, the call can fire after the session is dismissed. This is benign but untidy.

**A.1.16 `P/PlayGamesGrowth.swift` · 618 lines.** `PlayInk`, the Seed (kp 26), Colour Rivers (kp 20), Body Map (kp 77) and the World in a Box (ring 9).

- **PlayInk:** alpha is clamped 0–1; "a settled line stands at 0.55 or more (FIDELITY rule 4)".
- **Seed:** grows in real time; at bloom it plants the next seed and hands to Recognition.
- **Colour Rivers:** 4 colours; a 10×18 grid detects where colours meet.
- **Body Map:** 10 centres in Map Body order, *Soles, Forge, Prāṇa, Hands, Pulse, Sonar, Echo, Vision, Axis, Crow* (:323-324).
- **World in a Box:** the last 240 traces become objects; tilt or drag turns the box; gifts become stones.
- **Defects:** none.

**A.1.17 `P/PlayGamesYantra.swift` · 318 lines.** Śrī Yantra trace (kp 102), the Garland (all 102) and Bīja Tones (ring 1 opening).

- **Śrī Yantra:** 27 edges in the order the yantra draws itself; tolerance 18 pt; each edge plays its ring's awakening tone.
- **Garland:** pull down = next bead; rest 1.6 s = feel her; caption = her name.
- **Bīja Tones:** nine bands. Ring 9 asks him "to touch nothing at all" for 9 s.
- **Defects:** none.

### A.2 `Views/Rooms/` (the 102 Śakti rooms and the Climb)

**A.2.1 `R/HerRoomDoor.swift` · 140 lines.** The door every way in passes through.

- **Purpose.** `.herRoom($kp)` → `HerRoomPassage`, which always goes through `RiteOfEnteringView.entering`.
  - Neighbour doors: the seat before and after in the garland, plus a **sister door** (`ShaktiFactsCache.sister`).
  - `RoomGameLayer` sits over the room.
- **World:** Her Home.
- **Restrictions:** "Every way in passes the rite of entering"; "Leaving is one gesture, never punished" (:16-25).
- **Defects (performance):** `seat(_:in:)` and `corridor(of:)` each fetch **every** Shakti row with no predicate (:120-139), and `seat` is called twice per body render (:92, :102).

**A.2.2 `R/RiteOfEntering.swift` · 655 lines.** The ceremony, as arithmetic.

- **Three beats.** phrase (her or her ring's appreciation) → written (Devanāgarī or her name, three strokes) → roots (etymology or the compound parts, with her quality as the gloss).
- **Stations:** [0, .3, .62, .88, 1].
- **Timing:** writing 2.4 s (3.4 s with reduced motion) × compression. The compression is 1, then .68, then .46, with a floor of .36.
- **Other constants:** phrase alpha .94; strokeHold .72; roots part over .58 and rejoin from .52 over .48; gloss from .6 over .4 at alpha .6; prompt alpha .55.
- **Prompts (verbatim):** "touch to go on" · "touch to enter" · "touch to go deeper".
- **Name parts:** prefixes Sarva, Anaṅga, Mahā, Tripura, Kāmeśvarī, Vajreśvarī, Bhaga. Suffixes ākarṣiṇī, karṣiṇī, mayī, pradā, kāriṇī, sundarī, mālinī, eśvarī, iṇī, inī.
- **Strike pitch:** taken from `HomeCarrier.strikeFrequency(ring, beat, syllable)`.
- **Restrictions:** no beat indicator, no visit count, no "welcome back" (:31-44).
- **Defects:** none. The reduced-motion fix is documented at :229-271.

**A.2.3 `R/RiteOfEnteringView.swift` · 869 lines.** The rite drawn over the real `RoomView` (SceneKit).

- **Layers:** `ScoreLightVeil`, `RoomWordsView`, the descent ("goingDeeper"), `NeighbourDoorsView`, `.theWayOut` (hold 2.2 s), `.theEdgeWayOut`.
- **Type sizes:** phrase 23, written 38, roots 25, gloss 16.5, prompt 11, descent 19.
- **Arrival:** starts the chamber clock at the head start, then `voice.inside` and `dwelling.begin`.
- **Leaving:** runs the crossing backwards; a withdrawal watchdog with 0.6 s slack; `HomeAfterEffect.left(ring:)`.
- **`entering(_:remembering:)`** builds everything from her row (:789-847).
- **World:** Her Home.
- **Defects:** none found.

**A.2.4 `R/TheDescent.swift` · 144 lines.** Five stations into her mark.

- `isOffered` always returns true (Wave 2). `onward(reach:)` cycles 0…floor, then back to 0.
- **Restriction (verbatim, :12-21):** *"Touch to go on, hold to go out. That is the whole vocabulary of the rooms layer … there is no control, no chevron and no sheet anywhere in it."* **Ruling 10 lifts the "three controls" kind of restriction, so this is now a candidate to relax.**

**A.2.5 `R/TheStay.swift` · 75 lines.** Stay bookkeeping: handed over once, a let-go undoes the ending, an abandoned rite files nothing. No defects.

**A.2.6 `R/TheWayOut.swift` · 216 lines.** The held way out.

- 2.2 s (`RoomApproach.releaseSeconds`). Reduced motion makes it a single touch.
- **Words:** "hold to withdraw" / "touch to withdraw".
- **Restriction:** the type holds only Bools and closures, so it can never show a number (:49-56).

**A.2.7 `R/TheEdgeWayOut.swift` · 66 lines.** The leading-edge swipe: 22 pt edge, 72 pt travel. It is an equal way out.

**A.2.8 `R/NeighbourDoorsView.swift` · 125 lines.** The corridor doors.

- Vertical 1 pt seams at x = 26 and width − 26, y = .34H + 75, with the names rotated ±90°.
- The sister door is a horizontal seam at H − 150. The doors fade in over 0.8 s.

**A.2.9 `R/RoomWordsView.swift` · 125 lines.** The room's words.

- **Heading:** place 11, name 28, quality 15.
- **Sentence:** 18.5 pt, near → deep crossfade. Stages are read at 2 Hz. The sentence steps back during the descent.

**A.2.10 `R/ScoreLightVeil.swift` · 42 lines.** Her live Score's hue and glow, breathing at `BreathClock.period(grammar 8 s, score)`. Read once from `ShaktiFactsCache.score(position)`.

**A.2.11 `R/HerSiddhiLingers.swift` · 153 lines.** The after-effect on the whole app.

- Fires on `HomeAfterEffect.didLeave`. Each ring has a scale, brightness and contrast look that decays as k².
- The line *"her siddhi is still on the instrument"* holds about 12 s; the lift fades over about 24 s.

**A.2.12 `R/RoomGameLayer.swift` · 28 lines.** `TrinityVoiceLayer(place: .room(kp))` plus `ActivationCycleLayer`. Start delay is 16 s if a Trinity face is seated here (Gaia at Ahaṅkārākarṣiṇī, the Higher Self at Ātmākarṣiṇī), else 5 s. Sets the `SoundConductor` depth.

**A.2.13 `R/ActivationCycle.swift` · 423 lines.** Knowledge → Will → Action inside each Śakti room.

- **Gesture families by element:**
  - fire: hold 3.0 s, with a rising haptic every 0.45 s
  - water: an unhurried pour of 180 pt below 240 pt/s
  - air: a 10 s 4-in/6-out breath with no touch
  - earth: a still hold of 3.5 s
  - ether: 8 s of not touching
  - light: one touch within ±0.22 s of the peak, period 2.4 s
  - presence (rings 7–9): 6 s
- **Recession:** rings 1–3 ask ×1, rings 4–6 ×0.6, rings 7–9 nothing. Jitter is 0.85–1.15 by kp.
- **Close:** three lines, knowledge = quality, will = family word, action = somatic. Ledger row `Light Entered`; `ThreePools.noteBeing(.lightEntered)`; `BijaSoundService.playBija(shakti.bija, seed: kp)`.
- **Source quote (verbatim, :6-9):** a-strange-game's line *"Knowledge is what they receive. Will is who they are. Action is what they commit to. Light is what enters when these three close."*
- **Defects:** none.

**A.2.14 `R/ClimbGuide.swift` · 24 lines.** `TrinityVoiceLayer(place: .climb(ring:))`. Bindu speaks at the foot, Lalitā at the summit, once a day.

**A.2.15 `R/WorldClimbView.swift` · 837 lines.** The Climb (Axis): nine āvaraṇas in SceneKit and 102 lights.

- **Gestures:** drag up to rise (640 pt per band); drag across to turn (0.0024 rad/pt, max π).
- **Touching a light:** flies into it, then `herRoom`.
- **Ring mechanisms:**
  - Ring 3: the lights scatter and gather.
  - Ring 6: a light follows the finger and whispers the name it reaches.
  - Ring 7: touching the air sounds the twelve-voice chord.
  - Ring 8: holding unites the three lights.
  - Rings 1, 4 and 5 answer a still hand.
  - Ring 2: the lotus follows the sun.
- **Rail of nine** (rest alpha .55). **Empty summit** words. `ClimbBodyChakras` is mounted (:124).
- **Sound:** RingFieldVoice and HomeSoundService grounds, every 0.1 s.
- **Defects.**
  - **Entered from a chakra room**, `ChakraRingClimb` passes `live: [:]` and `todayKp: nil` (`C/ChakraRoomView.swift:712-718`). The climb's world words therefore lack live āvaraṇa facts and the crown light.

---

## B · PARITY — what renders today vs the design, and the gifts

### B.1 The 33 rooms: why they read as text pages

**The code path.**

- Touch one of the 33, either a light in the Mandala's constellation (`Views/Mandala/ChakraLayerOverlay.swift:101-103, 117`) or a body chakra on the Climb (`C/ClimbBodyChakras.swift:60-63, 93`).
- That opens `ChakraRoomHost` (`C/ChakraRoomDoor.swift:38-50`), then `ChakraRoomView`.

**What `ChakraRoomView` is (`C/ChakraRoomView.swift:84-132`).**

- A `ZStack` of `ChakraRoomField` (background), then **`ScrollView(.vertical)`**, then a `VStack` of `arrival · story · practiceSection · wakeUp · gateSection · doors`, then a top bar "‹ leave the room".
- Every section is headed text:
  - **arrival** (:136-195): voice label, name at 44 pt, Sanskrit, subtitle, verb, Core Question at 24 pt, Hero Threshold, Signature Phrase.
  - **story** (:225-263): heading "the story", the Story Thread as paragraphs, then four toggle buttons "act one · act two · the Bindu, after · the witness" that reveal more paragraphs.
  - **practice** (:268-357): heading "the practice", the Practice Prompt paragraphs, "Three Ways In" as expandable text rows, and **movement buttons** only where `ChakraMovement.byRoad` has one.
  - **wake-up** (:362-402): heading "the wake-up", the bīja as text, the Mirror Frequency Instruction as text, and a **"sound LAM"-style button** (`BijaSoundService.playBija(syllable, seed: 0, duration: 4.2)`).
  - **gate** (:407-519): heading "the gate · <type>", the gate instruction as text, a `TextField` for Textarea/Canvas gates, and **one 1.4 s long-press capsule for every gate type**. Walking it writes the row, plays the chord 110/165/220, and the offering lifts (`OfferingLeaving`, :740-797). Then the Writing Reflection and the Leela Story appear as text.
  - **doors** (:524-579): "into <her>'s room ›", "into the Nth āvaraṇa, on the climb ›", and "<Game> · <verb> ›".
- Entering plays one 110 Hz vāk tone at 0.05 gain (:608-616).

**The background (`C/ChakraRoomDoor.swift:60-145`)** has one look per `kind`:

- **energy** (rooms 2–8): 5 breathing rings
- **body** (rooms 10–19): 28 rising motes
- **mind** (rooms 21–29): one circle stroke
- **summit / bindu** (rooms 1, 30–33): a gold-line triangle; room 31 uses gold; room 32 adds a green ground
- **shadow** (room 9): darkened, with 40 twinkling stars
- **armin** (room 20): 33 beads turning

So **10 body rooms share one picture, 9 mind rooms share one picture, and 7 energy rooms share one picture.** The only thing per room is the Map hex tone.

**So the rooms read as text pages because:**

1. **There is no protagonist.** The corpus's DotStage (one dot that wanders, leans, blinks, condenses and carries the story without words; register 05 A.0.1, C.4 "motion carries meaning") is not in the app. The room never moves except the background.
2. **The order is the Map's columns, not the braid.** The room lays out the Map's columns as a reading document. Story, practice, wake-up and gate are scroll sections, not separate moments, each a breath long and the walker's to do.
3. **There is no breath pacing.** "Nothing arrives in under a breath (~5s × pace)" (05 C.4). Everything fades in together over 1.6 s (:100-101, :608-609).
4. **The gate types are labels only.** The gate type appears as heading text (:410), but every gate is the same capsule hold. Sound Response (mic: rooms 10, 11, 12, 13, 15, 16), Tap Rhythm (room 14), Device Tilt (rooms 18, 19) and the **Canvas point** (room 1) are not built. Room 1's "place the point" becomes a text field.
5. **There is no SilenceEngine and no awakening ladder.** The wake-up is text plus one bīja button. The panel builds (P1–P9 binaural, 174→528 Hz awakening tones, hold gates, the body point, the word thread, release on timers, the next-colour bleed) are absent.
6. **There is no dance strand at all.** A search for `Dance` in `Views/` and `Models/` finds nothing.
7. **There is no pulse from room 9 to room 32** (a search for ThePulse or a 58 Hz pulse finds nothing).
8. **Practice is held only for 10 of the 33 rooms** (`M/ChakraMovement.swift:130-141`, keyed by Road 2, 5, 6, 10, 13, 14, 15, 16, 17, 19). Elsewhere the practice is prose.

**Room by room.**

- "Text" = text page only, with the kind background.
- "Movement" = a held `ChakraMovementPractice` surface (Canvas + touch + motion), which is genuinely built.
- "Game door" = a link out to a Play game, which leaves the room.

| # | Room | Kind look | Story | Practice | Wake-up | Dance | Gate (Map type → app) | Game doors from room | Status |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Bindu | triangle (summit/bindu) | text + 4 layers | text | text (no syllable, no button) | — | Canvas → **text field** + hold | Śrī Yantra, World in a Box, **Leela** | text page |
| 2 | Muladhara | 5 rings | text | text + **fear, in waves** | text + "sound LAM" | — | Textarea → field + hold | Root System | text + 1 movement |
| 3 | Svadhisthana | 5 rings | text | text | text + VAM | — | Textarea | Water Level | text page |
| 4 | Manipura | 5 rings | text | text | text + RAM | — | Textarea | Seed, Colour Rivers, Bhakti | text page |
| 5 | Anahata | 5 rings | text | text + **hṛdayam, home** | text + YAM | — | Textarea | Mirror Maze, Rām japa | text + 1 movement |
| 6 | Vishuddha | 5 rings | text | text + **Ham·Het·Hum**, **roar, and silence** | text + HAM | — | Textarea | — | text + 2 movements |
| 7 | Ajna | 5 rings | text | text | text + OM | — | Textarea | Still · Ājñā | text page |
| 8 | Sahasrara | 5 rings | text | text | text (silence) | — | Textarea | Sandhyā (ring 2) | text page |
| 9 | Shadow | dark + stars | text | text | text | — | Textarea → field | Corridor, Scrolls | text page; the threshold moment is separate (`MandalaThresholdMoment`) |
| 10 | Soles | motes | text | text + **feeling it through** | text + LAM | — | Sound Response → **hold only** | Drum | text + 1 movement |
| 11 | Forge | motes | text | text | text + RAM | — | Sound Response → hold | Fire | text page |
| 12 | Prana | motes | text | text | text + VAM | — | Sound Response → hold | Rain | text page |
| 13 | Hands | motes | text | text + **euphoria pulse** | text + YAM | — | Sound Response → hold | Finger Garden | text + 1 movement |
| 14 | Pulse | motes | text | text + **euphoria pulse** | text + YAM | — | Tap Rhythm → **hold only** | Pulse, Coherence | text + 1 movement |
| 15 | Sonar | motes | text | text + Ham·Het·Hum, roar | text + HAM | — | Sound Response → hold | — | text + 2 movements |
| 16 | Echo | motes | text | text + Ham·Het·Hum | text + HAM | — | Sound Response → hold | Echo | text + 1 movement |
| 17 | Vision | motes | text | text + **last memories** | text + OM | — | Textarea | Body Map | text + 1 movement |
| 18 | Axis | motes | text | text | text + OM | — | Device Tilt → **hold only** | Spine Walk | text page |
| 19 | Crow | motes | text | text + **restlessness** | text (Silence) | — | Device Tilt → hold | Shake to Clear | text + 1 movement |
| 20 | Armin | 33 beads | text | text | text (Tat Tvam Asi) | — | Textarea | Tat Tvam Asi | text page; threshold moment separate |
| 21 | Inception | one circle | text | text | text | — | Textarea | — | text page |
| 22 | Intention | circle | text | text | text | — | Textarea | Letter | text page |
| 23 | Inspiration | circle | text | text | text | — | Textarea | — | text page |
| 24 | Insight | circle | text | text | text | — | Textarea | — | text page |
| 25 | Intuition | circle | text | text | text | — | Textarea | Flash | text page |
| 26 | Invention | circle | text | text | text | — | Textarea (canon: two fields) → one field | Join | text page |
| 27 | Incarnation | circle | text | text | text | — | Textarea (canon: Gaia's Siddhi letter) | — | text page |
| 28 | Innocence | circle | text | text | text | — | Textarea | Door | text page |
| 29 | Integration | circle | text | text | text | — | Textarea (canon: Gaia's farewell letter) | Mandala Completion, Twelve | text page |
| 30 | Maya | triangle | text | text | text | — | Textarea | — | text page; **the signature reads "…only the Bindu, playing."** |
| 31 | Aatma | gold triangle | text | text | text | — | Textarea (canon: one-word gate) | — | text page |
| 32 | Ego Reveal | triangle + green ground | **all text shown** | text | text | — | Textarea | Shadow Translator | **sealed words exposed** (see D) |
| 33 | Lalita | triangle | text | text | text | — | Textarea (canon: no question) | Śrī Yantra, World in a Box, Leela | text page; gate text shown freely |

**Built vs designed, by strand.**

- **Story** is text in all 33. Corpus: built only for room 1 (slice B, wordless DotStage) and the legacy 2/3 two-act engine. Under ruling 5 the prose is Feed material. The *energy* of the story belongs here as motion.
- **Practice:** 10 rooms have held movements (8 kinds). The other 23 are prose. Corpus register cards give a mechanism for every room (05 A.2 "Mechanism" lines).
- **Wake-up:** 0 rooms built. There is a bīja button in the 16 or so rooms with a syllable.
- **Dance:** 0 rooms.
- **Gate:** 1 generic hold in all 33; 0 of the 5 typed gates are built.
- **Pulse 9→32:** not built.
- **Gate braid sealing:** not built. Every gate is always open. This is consistent with the open-access law, but the "warm / waits / walked" states are absent too.

### B.2 Every game and play experience: built vs designed

**Built (36, all in `P/`).** Each is a real physical verb with a skill, sound and haptics, and ends in Recognition or stillness:

- corridor, pulse, spineWalk, echo, fingerGarden, rain, drum, rootSystem, waterLevel, fire, shakeToClear, door, yantraTrace, rosary, bijaTones, coherence
- seed, mandalaCompletion, twelve, bodyMap, shadowTranslator, mirrorMaze, letter, worldInABox, colourRivers, shadowScrolls, stillAjna, flash, tatTvamAsi, leela, turn, join, ramJapa, bhakti, sandhya, greatWheel

They are reached from Lalitā's field (all 36 on one disc), from Śakti detail doors (`PlayAddressBook.door`) and from chakra room "doors".

**Also built (chakra rooms):** 8 `ChakraMovement` practices: euphoriaPulse, roarAndSilence, lastMemories, hamHetHum, fearInWaves, feelingThrough, restlessness, heartHome.

**Designed in the corpus but not built (registers 05 B, 06 B.9):**

| Designed piece | Source | App state |
|---|---|---|
| **The 108** (108 taps, 4 rings 40/32/24/12, lines from bead 54) | 05 B.3.1 | not built. Rām japa (108 on breath) and the Garland (102) are relatives. |
| **Mantra Tuner** | 05 B.3.5 | folded into Bīja Tones |
| **The Draw** (24 cards, one a day, deck hold 1.9 s, flip 1.3 s, bell 740, weekday planets) | 06 B.9 G-ENGINE | **not built** |
| **The Sakshi Pause** (hold orb 4 s = in, release 5.2 s = out, 3 beads) | 06 B.9 | **not built** (Coherence and Rām japa are cousins) |
| **The Book** ("What you chose to keep") | 06 B.9 | not built (the river and Correspondence hold letters only) |
| **Sketchbook: Choose** (story with consequences) | 06 B.9 #1 | not built. Needs AI; story belongs in Feed. |
| **Sketchbook: Talk** (ring of ten vantages, verbatim lines; Ask / Tell / Wonder / Stay quiet) | 06 B.9 #2 | not built. Fits the Relationship Field and the Trinity. |
| **Sketchbook: Manage** (squad and seasons, "never rated") | 06 B.9 #3 | not built |
| **Sketchbook: Trace** (inward spiral → "The point.") | 06 B.9 #6 | not built (Yantra Trace is a cousin) |
| **Sketchbook: Still** (tilt a drop to the centre, 7 s → "Held.") | 06 B.9 #7 | not built (Water Level is a cousin) |
| **Sketchbook: Beat** (60 bpm at 98 Hz, taps within 130 ms; a second drum at 147 Hz after 8) | 06 B.9 #8 | not built (Drum and Pulse are cousins). The playtest rated it **"Fun"**. |
| **Sketchbook: Release** (seven cards set down; seven bodily gifts rise; bells 440+40k) | 06 B.9 #9 | not built |
| **Sketchbook: Seal** (letter: tomorrow / a week / a season, wax) | 06 B.9 #10 | partly: the Letter seals to the tithi |
| **Chakra Game 7 experiences** (quiz, river draw, reflection, 4-2-6-2 breath, word reveal, oracle flip, matching) | 05 B.2 | not built (the quiz breaks canon anyway) |
| **Sacred Experiences "Pulse" lines** ("The most reliable relationship you have ever been in.") | 05 B.4.1 | the mechanic is built (Pulse); the words are not used |
| **Sanctuary Gates / Field / Mirror**; **Body as Scripture**; **Child Space** (door hold 2.8 s, "This door is small."); **Seven Gates** (Crown→Root lay-down hold 2.6 s); **Correspondence** (built separately in Memory) | 05 B.5 | most not built here; several need AI (refused by charter law 8) |
| **Tree-of-Life panels P1–P9** and the **P10 Axis triptych** | 06 B.4 | not built |
| **The VX dances** (seven dancers, mirror words, ALIVE FRUIT) | 06 B.6 | not built |
| **V5 Two-Act engine** (veil, eyes blink, 1.8 s ring, word-by-word Act 2) | 05 A.0.2 | not built |
| **SilenceEngine** (OM 68.05 / 136.1 / 272.2 at .15/1/.3, LFO .05 Hz, gain from 0) | 05 A.0.1 | not built as an engine. The 136.1 pitch is used as `pointHz`. |
| **DotStage** (r 7, 6 s breath ±9%, wander, lean ≤5 px, trail, blink, condense 90 motes / 12 s) | 05 A.0.1 | **not built** |
| **ThePulse** (58 Hz, 60 bpm LFO, depth .028, glow arc) | 05 B.1.15 | **not built** |
| **One-second floor** ("Blink. Breathe. Press.") | 05 B.1.10 | not in Play/Rooms (outside my scope to confirm elsewhere) |
| **Persistent 6 px Bindu dot** (#C0392B, .3, never explained) | 06 B.11 M-DOT | not in Play/Rooms |

### B.3 Leela: how landings work now vs "every landing opens the chakra's energy"

**Now** (`P/PlayGamesPattern.swift:452-636`, `P/PlayPhysicsWhole.swift:456-507`):

- **Where it is.** The game is one of 36 lights in Lalitā's field. It is also a door from rooms 1 and 33, because kp 102 is the address of both.
- **The board.** It starts **unborn**; there is no intention prompt. The die pips are drawn at the bottom. He holds and releases, or shakes (> 1.4 g).
- **The walk.** A six → born on square 1. Otherwise the token glides square by square with a tick and a rising tone.
  - Arrows play a 408 Hz tone (`pointHz·3`). Snakes play 136.1 Hz with an octave-below partial.
  - **Each landing draws only the square's name and its Map essence at the top of the screen (:597-606).**
  - Square 32 is a hollow ring with no words (:565-568, :598).
- **Arrival.** An exact 33 → the whole path glides to 33 → after 2.6 s, **Recognition of kp 102** (her) or stillness.
- **The record.** One ledger row for the whole game ("Leela on the Thirty-Three" at Mahātripurasundarī). Nothing is persisted; leaving loses the walk.

**Designed** (ruling 5, plus 06 C.8 engine version: *"Every landing opens a room: practice first, then the letter."*):

- **A landing should open that square's chakra room as an energy space.** Its moving point, practice, wake-up and gate, at that room's own register, are entered with a crossing and left back to the board, with the board's state kept.
- **Arrows** are "an act of giving or service". **Snakes** are "this square's practice, made small — a lesson, not a fall". The square sheet carries "One move" as the verb ("{Verb}, once, today.") and the via-line ("An arrow from N…").
- **Intention first:** "What are you bringing to the board?" with **My life** / **What I'm building**.
- **Every six throws again** (Johari). Triple-six is open for his ruling.
- **Square 32: "This square is held for its own walk."**
- **Arrival:** "You arrived at Lalita." / "The walk is complete. Begin again whenever you like." The closing gives the intention back. "No score, no verdict."
- **Footer:** "If today is heavy, the board can wait. Three breaths is a whole game."

**What is missing:**

- the room-opening on landing
- the intention
- the six-again rule
- persistence of the walk
- the square sheet's verb move
- a ledger row per landing
- the held die ring with its breath words ("Breathe in." / "Let go when the ring closes." / "No hurry.")
- a sound and visual world of its own (the corpus engine uses peacock cloth #0F4A50, marigold dot #F2B632, ivory #F4EBDA, a bell set, and step / rise / settle sounds)

### B.4 Gifts for the upgrade

Each row gives: what · source · world(s) · how it would work · needs · energy or story.

| # | What | Source (file:line) | World(s) | Mechanism there | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **The Śakti-room grammar applied to the 33** (rite → room → descent → way out → corridor) | `R/RiteOfEnteringView.swift:255-321`, `R/RiteOfEntering.swift:98-428` | the 33 | Each chakra room becomes a space you cross into in three touch-paced beats: verb → signature → core question. The descent's five stations are the braid (story-motion / practice / wake-up / dance / gate). Hold to withdraw. The corridor walks to the previous/next Road room and the **Subtle Mirror twin** (the sister door). | A RoomScene look per room (33, not 7); a `ChakraRite` with the same arithmetic; braid stations instead of the descent's five fields | energy |
| 2 | **DotStage protagonist** in every room | corpus `shell/bindu-engine.js` via 05 A.0.1 | the 33, Home | One Canvas dot per room, never unmounted: r 7, breath 6 s ±9%, wander, lean ≤5 px, trail, blink, condense. Each room's register card sets its behaviour (e.g. 2 heavy and low; 3 never still; 4 flicker at the edges; 7 subtraction; 8 the system breathes you). | A new `DotStage` model on the `PlayModel` protocol (shape already exists in `P/PlayModels.swift:10-36`) | energy |
| 3 | **SilenceEngine** | 05 A.0.1; OM stack | the 33, Bindu, deep zoom | Gain starts at 0 and "learns to sound" through the room: `breathe(target)`, `bell(hz)`. Reuse PlaySound's drone (`P/PlayInstruments.swift:301-321`) with 3 partials at 68.05 / 136.1 / 272.2. | Extend PlaySound or a new service under SoundConductor | energy |
| 4 | **Typed gates** | Map `gateType`; 06 A.2 | the 33 | **Canvas:** place a point (room 1) and hold 4.6 s → lift. **Sound Response:** mic, humming in bins 2–12 average > 40 (rooms 10, 11), breath in bins 1–40 > 20 (12), friction in bins 1–30 > 25 (13), speech in bins 3–15 > 35 for 3 frames (15), presence only for 2:00 (16). **Tap Rhythm:** heartbeat taps → reuse `HeartbeatCatch` (`P/PlayPhysics.swift:93-133`). **Device Tilt:** spirit level for 18; a 30 s shake (> 7 m/s²) then stillness (< 1.8 m/s²) for 19, reusing `PlayMotion`. **Textarea:** keep the offering that lifts (`C/ChakraRoomView.swift:740-797`). | AVAudioEngine input tap (needs mic permission); new gate models | energy |
| 5 | **Pulse room 9 → 32** | 05 B.1.15, C.2; 06 B.10 BCA-PULSE | the 33, Leela board | A warm ~60 bpm haptic plus a 58 Hz glow arc at the bottom of the glass in every room from Shadow to Ego Reveal. Never explained. At 32 it is spoken from. | A global layer keyed by Road 9…32 | energy (the words at 32 are sealed) |
| 6 | **Awakening ladder and panel wake-ups** | 06 A.2, B.4 P1–P9 | rooms 2–8, 30, 31 | Hold gate (4000 ms; P7 3000; P8 1500) → awakening tone (174 / 210 / 320 / 341 / 384 / 426 / 480 / 528 Hz, P9 silence) → binaural pair (P1 128→132→130 … P8 512/512.5) → body-point tap → breath cycles → release on timers → next-colour bleed at 24 s. | Synth with harmonics, sub and noise transient; true L/R binaural | energy (drop "now Breathing" as congratulation, 05 E.10) |
| 7 | **Panel mechanics per room** | 06 B.4 | rooms 2–8 | P1 tap six Siddhi roots; P2 trace six drifting Karṣiṇī lights within 35 px; P3 shake to assemble 24 embers in 8 Ananga clusters (rhythmic > 9 m/s², violent scatters); P4 pinch out the knot 55 px per layer; P5 sound into the mic to spread 35 lines; P6 hold the phone still (< 4°/s) for clarity, with the journey's points as stars; P7 body points rise to the crown in 6 s, white light at 17 s. | `PlayMotion`, mic | energy |
| 8 | **Maya Mirror: eight inverse actions** (no skip) | 06 B.4 P9 | room 30 (and the summit) | S1 touch-then-release · S2 let the word drift 8 s · S3 don't tap the 8 particles for 6 s · S4 pinch the name in · S5 10 s of silence · S6 8 s eyes closed · S7 swipe up / hold 3 s · S8 hold 3 s then let go. Then the K-W-A closing and **"Go Play"**. | Words he gave in earlier rooms (a word thread) | energy (canon line per ruling 8: "only You, playing") |
| 9 | **The dance strand** | 06 B.6 | the 33 (the dance draws on every archetype, ruling 6) | Offer one word → seven named dancers (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey's web; plus Lalita and others per ruling) on Canvas, moved by the song's onset and energy arrays, mirror words at set times, the word revealed at the peak, "I Love You" just after. Fruit lines. | Songs (licensing, bundle), pre-analysed arrays (as in the dance HTML); the Bindu Field Score bake may supply this | energy |
| 10 | **Leela landing → room** | ruling 5; 06 C.8 engine | A Strange Game, the 33 | On `.walked` / `.arrow` / `.snake` in `LeelaModel.land` (`P/PlayGamesPattern.swift:510-534`), after the glide, present that square's chakra room (gift 1) as a cover. On leaving, return to the board with `LeelaWalk` persisted. Arrow = an act of giving; snake = the square's practice made small. | Persist `LeelaWalk` (it is a value type, so easy); room cover from inside a game cover (the `PlayField.host` pattern) | energy |
| 11 | **Leela intention and closing** | 06 C.8 | A Strange Game | "What are you bringing to the board?" uses the host's word field (`P/PlayGameHost.swift:255-288`). At 33 the intention is given back in his own words. | `give(word:)` already exists | energy |
| 12 | **The Draw** | 06 B.9 | A Strange Game, Today | One card a day from 24 titles; hold the deck 1.9 s; flip. | 24 card bodies (Ashrey's or Map's words, never generated) | energy |
| 13 | **The Sakshi Pause** | 06 B.9 | A Strange Game, Today | Hold = in (r 46→110 over 4 s), release = out over 5.2 s, three beads. "One breath is a whole practice." | trivial model | energy |
| 14 | **Sketchbook Beat, Trace, Still, Release** | 06 B.9 | A Strange Game (each its own world) | Beat: 60 bpm at 98 Hz, a second drum at 147 Hz after 8 near taps. Trace: inward spiral r = 320 − 16.5t. Still: tilt a drop into the centre, ring fills over 7 s. Release: seven cards set down, seven bodily gifts rise. | new PlayModels | energy |
| 15 | **Talk: ring of ten vantages** (verbatim lines) | 06 B.9 #2 | Relationship Field | Ten faces stand round a ring with their one line; Ask / Tell / Wonder / Stay quiet. | His decision on Neev and Shweta | story-leaning → partly Feed |
| 16 | **Every game its own world** | foundation | A Strange Game | Replace the one disc of 36 (`P/PlayFieldView.swift:141-148`) with Leela at the centre and worlds by family (elements, heart, passage, pattern, words, time, sacred), each entered as a space. | new navigation | energy |
| 17 | **ActivationCycle for chakras** | `R/ActivationCycle.swift:66-130` | the 33 | The gesture-family engine maps to the chakra families: STILLNESS 2–8, MOVEMENT 10–19, VISUALIZATION 21–29, RECOGNITION 1, 9, 20, 30–33 (06 B.10). Hold lengths fall from 3500 ms at the root to ~1800 ms at the crown. | a family table | energy |
| 18 | **Next-colour bleed** at room exits | 06 B.11 M-BLEED | the 33 | The next room's hex rises from the bottom edge at 24 s, or during the crossing. | Map hexes (in the bake) | energy |
| 19 | **Word thread / body points** across rooms | 06 B.11 M-WORDTHREAD, M-BODYMAP | the 33, Memory | Store the words and body taps he offers; room 7 shows them as stars; rooms 8 and 30 replay them. | ThreePools / a local store; never shown as a count | energy |
| 20 | **Gate states warm / waits / walked** | 05 A.0.1 slice-a | the 33 | Shape only: "The gate is warm." / "The gate knows how to wait too." No lock. | — | energy |
| 21 | **Story motion, wordless** (slice B: Flicker → forms fail → Aurora → Covenant → Dawn "Go.") | 05 A.0.1 | room 1, model for all | Story as DotStage choreography. The prose story threads and act voices move to **Bindu Feed**. | new choreography per room | prose = **story → Feed** (ruling 5: "energies, not stories") |
| 22 | **Room prose** (Story Thread, Act 1/2, Bindu Reflection, Witness, Leela Story) | `C/ChakraRoomView.swift:225-263, 491-493` | — | Flag for Bindu Feed; keep at most the signature phrase and core question in the room. | — | **story** |
| 23 | **Sealing room 32 and the Lalita gate** | ruling 2; 05 E.20 | rooms 32, 33 | Room 32 opens as energy only (pulse plus Gaia ground). Its words are held. | a sealed set in the bake reader | — |

---

## C · WHAT THE UPGRADE MUST BUILD, AND CONFLICTS AND GAPS

### C.1 Room by room (the 33)

**Common to all 33:**

1. **Crossing in** with the rite grammar (gift 1).
2. **A moving point** (DotStage) as protagonist.
3. **SilenceEngine** under it.
4. **Braid stations:** story-as-motion · practice · wake-up · dance · gate. Each is its own moment, a breath long, and none is a scroll section.
5. **Typed gate** (gift 4) with the offering that lifts.
6. **Hold to withdraw** and the edge way out.
7. **Corridor** to the previous and next Road room and the Subtle-Mirror twin.
8. **Door** to the Home and to its games, plus Leela return when entered from the board.
9. **Pulse** for rooms 9–32.
10. **Ledger:** one `Chakra Practiced` row per strand. This already exists (`C/ChakraRoomView.swift:642-655`).
11. **A per-room look:** 33, not 7.

Prose moves to Bindu Feed (ruling 5).

| # | Room | Practice to build (mechanism) | Wake-up | Gate | Reuse in code |
|---|---|---|---|---|---|
| 1 | Bindu | Canvas point, Yoni mudra 3 × 8 s; wordless 5-movement story (slice B); still-touch the dot 1 breath | silence; "one finger, one point" | **Canvas** place-the-point → hold 4.6 s → lift | Yantra Trace, World in a Box, Leela; deep zoom |
| 2 | Muladhara | press-and-hold heavy (3500 ms), 4·4·4, text low; ten breaths pressing; six Siddhi roots (P1) | P1: 174 Hz, binaural 128→132→130 | Textarea "I feel the ground holding me" | Root System; fear, in waves; Drum (root pair) |
| 3 | Svadhisthana | never still; trace six drifting lights (P2); 4·0·6 | P2: 210 Hz; 144→150→148 | Textarea | Water Level |
| 4 | Manipura | flicker edges, short strokes; shake to assemble embers (P3); 3·3·6 | P3: 320 Hz gong; 160→168→172 | Textarea | Seed, Colour Rivers, Bhakti, Fire (gift pair) |
| 5 | Anahata | space widens, optional 341 Hz under-tone; pinch the knot (P4); 5·5·8 | P4: 341 Hz bowl; 256→262→260 | Textarea, hand on chest | hṛdayam; Mirror Maze; Rām japa |
| 6 | Vishuddha | layout narrows then opens after writing; mic spreads lines (P5); 4·7·8 | P5: 384 Hz; 384→392 | Textarea | Ham·Het·Hum; roar and silence; Mirror Maze (throat pair) |
| 7 | Ajna | subtraction (elements removed), eyes closed; hold still for clarity (P6); 6·0·6 | P6: 426 Hz plus a 1.5 Hz twin | Textarea eyes closed | Still · Ājñā |
| 8 | Sahasrara | the system breathes you (AUTO 5·2·7 × 3); two-wave cascade plus SILENCE inscription; body points rise to the crown (P7) | P7: 480 Hz; 480→481→silence | Textarea "Stop doing." | Sandhyā |
| 9 | Shadow | three-breath dark entry; 12 scrolls; LOOK hold 3 s; word offering; **pulse begins**; exit = dark thins at one edge; press-and-hold 700 ms per step | no tone; deepest 2.5 Hz | Textarea (word to the dark) | Corridor, Scrolls; `MandalaThresholdMoment` |
| 10 | Soles | stand barefoot; teaches Blink·Breathe·Press | LAM mirror | **Sound Response** (hum) | Drum; feeling it through; Root System |
| 11 | Forge | hand on belly, radial glow | RAM mirror | **Sound Response** | Fire |
| 12 | Prana | mic listens to real breath; visual expands and contracts | VAM mirror | **Sound Response** (breath, 3 breaths) | Rain |
| 13 | Hands | multi-touch palms on glass, warming long-press zones; rub 15 s | YAM mirror | **Sound Response** (friction) | Finger Garden; euphoria pulse |
| 14 | Pulse | tap your heartbeat, room syncs | YAM mirror | **Tap Rhythm** (only one) | Pulse, Coherence (`HeartbeatCatch`) |
| 15 | Sonar | speak aloud; one outgoing ripple per utterance | HAM send | **Sound Response** (speech) | Ham·Het·Hum (HUM), roar |
| 16 | Echo | total quiet; mic level as faint concentric arrival; 2:00 | HAM receive | **Sound Response** (presence) | Echo; HAM |
| 17 | Vision | eyes-closed flash; auto-commit after stillness | OM mirror | Textarea auto-commit | Body Map; last memories |
| 18 | Axis | spirit level, hold vertical; blink as access; P10 triptych (design only) | OM mirror | **Device Tilt** | Spine Walk |
| 19 | Crow | 30 s shake, then sudden stillness; violet sky | Silence | **Device Tilt** (shake then still) | Shake to Clear; restlessness |
| 20 | Armin | aurora of every dyad braiding; opens (corridor's inverse) | D2 drone 55 s, never resolves | Textarea | Tat Tvam Asi; threshold moment |
| 21 | Inception | held beat on the threshold; name what you carry | — | Textarea, eyes-closed tap → write | (Seed as gate offering) |
| 22 | Intention | stillest mind room: nothing moves after the tap | — | "I'm holding it." | Letter |
| 23 | Inspiration | brightest; accent leans toward the walker | — | "I feel it." | — |
| 24 | Insight | frame inverts for one breath on tap | — | "I'm inside it." | — |
| 25 | Intuition | pre-dawn palette brightens one degree per tap | — | "It's there." | Flash |
| 26 | Invention | two fields with a visible gap | — | **two fields** "Both are here." | Join |
| 27 | Incarnation | exit is a letter being read (Gaia's Siddhi letter) | — | letter | (Correspondence ancestor) |
| 28 | Innocence | softest; the interface visibly does nothing until something arrives | — | "Something arrived." | Door; Child Space ancestor |
| 29 | Integration | Sarva Beeja begins; prismatic accent | — | Gaia's farewell letter | Mandala Completion, Twelve |
| 30 | Maya | the only transparency mechanic: a named construction turns see-through; ghost tree; P9 Mirror inverse actions | P9: OM 136.1 stack, no awakening tone | Textarea (one construction) | — (new) |
| 31 | Aatma | one-word gate (Will / Knowledge / Action); three rhythms: hand on chest, one breath, one blink; P8 triangle holds 4 s each | P8: 528 Hz trinity; 512/512.5 | **one word** | Turn (ring 8, "the three made one", currently in no room), ActivationCycle |
| 32 | Ego Reveal | energy only: pulse and Gaia ground arrive together; **words sealed** | — (sealed) | sealed | Shadow Translator (gift ancestor; currently an open door) |
| 33 | Lalita | gate has no question; Reveal held in build | laughter | no-question field | Leela, Śrī Yantra, World in a Box |

### C.2 Game by game: A Strange Game

1. **Leela at the centre of A Strange Game.** Build:
   - intention
   - persisted walk
   - six throws again (rule triple-six later)
   - a breath ring on the die hold
   - **landing → that room's energy space**, then back to the board
   - arrow = giving, snake = the practice made small
   - square-sheet move "{Verb}, once, today."
   - 32 held
   - a ledger row per landing
   - an arrival closing with his intention given back
   - its own world: cloth, marigold dot, bells
2. **Every game its own world.** Split Lalitā's single disc into worlds:
   - elements: Drum, Root, Water, Fire, Rain
   - heart: Pulse, Coherence, Echo
   - passage: Corridor, Door, Spine, Scrolls, Tat Tvam Asi
   - pattern: Yantra, Mandala, Twelve, Turn, Join
   - words: Translator, Maze, Letter, Flash
   - growth: Seed, Rivers, Body Map, World in a Box
   - sacred: Still · Ājñā, Rām japa, Bhakti, Garland, Bīja Tones
   - time: Sandhyā, Great Wheel

   Each world is entered as a space with all its games standing in it. Keep the field as one overview.
3. **New games:** The 108, The Draw, The Sakshi Pause, Beat, Trace, Still, Release; Talk (Relationship Field).
4. **Homeless games:** place Turn, Bīja Tones, Great Wheel and the Garland in chakra rooms. Today they are reached from no room. Turn → 31; Bīja Tones → each energy room's wake-up; Great Wheel → Time; the Garland → Mandala.
5. **The Book:** a single place for what he chose to keep, on the phone.

### C.3 Conflicts and gaps

1. **Ruling 2 is violated.** Room 32's words are all rendered. `ChakraRoomView` shows the story, act voice, Bindu reflection, witness, practice, gate and Leela Story for Road 32 (bake has 15 of 17 teaching fields populated). It opens from the constellation (`Views/Mandala/ChakraLayerOverlay.swift:101-103`) and its Shadow Translator door is live. Only Leela holds square 32 (`P/PlayPhysicsWhole.swift:459`). **This must be sealed.**
2. **Ruling 8 is violated.** Maya's signature in the bake reads *"There was never anything to fear. There was only the Bindu, playing."*. The ruling is "only You, playing". It is rendered at `C/ChakraRoomView.swift:184-191`.
3. **Room 33** gate text and Leela Story render freely. Register 05 E.20 says room 33's content "sits next to the sealed Reveal". This needs a ruling.
4. **Ruling 3 (Axis 18, Crow 19)** matches the bake and `BodyMapModel.centres` (`P/PlayGamesGrowth.swift:323-324`). OK.
5. **Ruling 10 lifts restrictions that are still written as law in code:**
   - "the whole vocabulary of the rooms layer" is two gestures (`R/TheDescent.swift:12-21`)
   - no beat indicator and no returning line (`R/RiteOfEntering.swift:31-44`)
   - the game title is never a heading (`P/PlayGame.swift:98-99`)
   - the hint is only for the first breaths (`P/PlayGame.swift:183-184`)
   - one sound claim at a time (`P/PlayInstruments.swift:183-186`, `SoundConductor.claim(.play)`)
   - "a way, not a list" (`P/PlayFieldView.swift:203`)

   These are candidates to relax. Floors still hold: no count on the glass, the two Recognition lines, App Activity.
6. **The awakening tones are keyed to rings, not rooms.** `AwakeningTones` maps rings 1–8 to 174–528 Hz (`P/PlayPhysics.swift:506-532`). In the corpus they are per room (P1 = Muladhara … P7 = Sahasrara, P8 = Aatma). In the yantra Muladhara, Svadhisthana and Manipura are all ring 1 per the bake, so Bīja Tones ring 2 = 210 Hz is Svadhisthana's tone at Anahata's ring. Decide one ladder.
7. **Bake oddity.** Sahasrara (Road 8) has `avarana: 2` with empty `kp`, so the Sandhyā (ring 2) shows as Sahasrara's game door. Worth checking against The Map.
8. **The braid's sealing law** ("a room's gate unseals only when its other threads have passed"; "Lalita opens only when all 33 offerings") conflicts with ASG D10 "no gates" and ruling 10. The app has no sealing. Keep the gate *states* as shape only.
9. **Hold times disagree** (05 E.8): register 3500 → 1800 ms; panels 4000; shell one breath of 5 s; veil 1.8 s. The app uses 1.4 s for chakra gates (`C/ChakraRoomView.swift:77`), 2.2 s for the Śakti way out, and 2.8 s for the Door. Needs one ladder.
10. **Three frequency systems** (06 E.4): awakening, VX2, solfeggio. The app uses awakening plus 136.1 / 272.2. Solfeggio should stay out.
11. **"Now Breathing"** in the panels is a declaration of achievement. Do not port it as is.
12. **Dancer names are real people** (sid, arch, karishma, ashrey). Ruling 6 accepts all named archetypes, so this is resolved by the ruling. Neev and Shweta also appear in Talk.
13. **Leela board** is a first draft awaiting his ruling: arrows/snakes, triple-six, the reading voice. The code ships the draft as is.
14. **Story material in the rooms** (Story Thread, Act 1/2, reflections, Leela Story) is reading. Per ruling 5, flag it for Bindu Feed: the 33 story threads are 221–1,401 chars each in the bake.
15. **Code defects** (small):
    - `ChakraRingClimb` passes empty `live` and nil `todayKp` (`C/ChakraRoomView.swift:712-718`).
    - `HerRoomPassage` refetches all rows on each render (`R/HerRoomDoor.swift:92, 102, 120-139`).
    - Mirror Maze uses an async completion after leave (`P/PlayGamesWords.swift:182`).
    - Great Wheel has dead code (`P/PlayGamesTime.swift:173-174`).
    - Stale comments: `P/PlayGameHost.swift:6` "sixteen"; `P/PlayPhysicsWhole.swift:193-196` "Mental State".
    - Leela walk not persisted; no ledger row per landing.
16. **Gaps.**
    - no DotStage, SilenceEngine or ThePulse
    - no dance strand
    - no typed gates
    - no mic input anywhere in Play/Rooms/Chakra (the Sound Response gates need it, with mic permission)
    - no wake-up panels
    - no Maya Mirror
    - no P10 triptych (design only even in the corpus)

---

## D · COVERAGE PROOF

### D.1 Assigned files, all read in full with the Read tool

| File | Lines | Read | Method | md5 |
|---|---|---|---|---|
| P/PlayFieldView.swift | 317 | 1–317 | Read | 2841b6f8 |
| P/PlayGame.swift | 423 | 1–423 | Read | 69355be9 |
| P/PlayGameHost.swift | 491 | 1–491 | Read | 3b0fc892 |
| P/PlayGamesElements.swift | 431 | 1–431 | Read | 04dcfbae |
| P/PlayGamesField.swift | 200 | 1–200 | Read | 6bc49c1a |
| P/PlayGamesGrowth.swift | 618 | 1–618 | Read | a716447d |
| P/PlayGamesHeart.swift | 231 | 1–231 | Read | f63002b6 |
| P/PlayGamesPassage.swift | 239 | 1–239 | Read | 95fbd93e |
| P/PlayGamesPattern.swift | 636 | 1–636 | Read | 3f4d3adb |
| P/PlayGamesSacred.swift | 429 | 1–429 | Read | 28166b27 |
| P/PlayGamesTime.swift | 257 | 1–257 | Read | 31df67ca |
| P/PlayGamesWords.swift | 486 | 1–486 | Read | 9b4a5333 |
| P/PlayGamesYantra.swift | 318 | 1–318 | Read | 88bc313b |
| P/PlayInstruments.swift | 348 | 1–348 | Read | 5fd037a3 |
| P/PlayModels.swift | 131 | 1–131 | Read | 3d600f54 |
| P/PlayPhysics.swift | 556 | 1–556 | Read | 34de3db9 |
| P/PlayPhysicsWhole.swift | 796 | 1–796 | Read | aba2cc57 |
| R/ActivationCycle.swift | 423 | 1–423 | Read | c58ebcb5 |
| R/ClimbGuide.swift | 24 | 1–24 | Read | 0dec7d68 |
| R/HerRoomDoor.swift | 140 | 1–140 | Read | 7697dbf1 |
| R/HerSiddhiLingers.swift | 153 | 1–153 | Read | bc1dacfb |
| R/NeighbourDoorsView.swift | 125 | 1–125 | Read | 6af864bf |
| R/RiteOfEntering.swift | 655 | 1–655 | Read | 9fae77a9 |
| R/RiteOfEnteringView.swift | 869 | 1–869 | Read | aa35d774 |
| R/RoomGameLayer.swift | 28 | 1–28 | Read | 1f4df287 |
| R/RoomWordsView.swift | 125 | 1–125 | Read | c343307c |
| R/ScoreLightVeil.swift | 42 | 1–42 | Read | 7f40cdbe |
| R/TheDescent.swift | 144 | 1–144 | Read | 3f1d0bb2 |
| R/TheEdgeWayOut.swift | 66 | 1–66 | Read | 55195bf2 |
| R/TheStay.swift | 75 | 1–75 | Read | 9f89d2b8 |
| R/TheWayOut.swift | 216 | 1–216 | Read | c0f65bc3 |
| R/WorldClimbView.swift | 837 | 1–837 | Read | 9ebab72c |

### D.2 Supplementary files (read for the parity check)

| File | Lines | Read | Method | md5 |
|---|---|---|---|---|
| C/ChakraRoomView.swift | 797 | 1–797 | Read, full | 718bac66 |
| C/ChakraRoomDoor.swift | 145 | 1–145 | Read, full | 62bad8a6 |
| C/ChakraMovementPractice.swift | 756 | 1–756 | Read, full | 5316afe5 |
| C/ClimbBodyChakras.swift | 95 | 1–95 | Read, full | 6b82b6ca |
| M/ChakraConstellation.swift | 244 | 1–244 | Read, full | 9aedadde |
| M/ChakraTeaching.swift | 343 | 1–343 | Read, full | 33435ac0 |
| M/ChakraMovement.swift | 179 | 1–179 | Read, full | d39bc5f4 |
| Views/Mandala/ChakraLayerOverlay.swift | 285 | 90–130 | sed excerpt | dbd8854f |
| Views/Mandala/MandalaThresholdMoment.swift | 332 | 1–40 | sed excerpt | 17baf5da |
| Services/LeelaDrops.swift | 204 | 1–40 | sed excerpt | 4e4138ce |
| Data/ChakraConstellation.json | 327,662 bytes | structural | `python3 -I`: per room the road, name, kind, address, kp, avarana, crossing, gateType, voice, bija head and field presence; story-thread lengths; room 30 signature in full. The private or sealed contents of 32 and 33 were not printed. | 70211e07 |

### D.3 Comparison registers and the brief

| File | Lines | Read | Method | md5 |
|---|---|---|---|---|
| waves/register/05-chakra-corpus.md | 3392 | 1–569, 2742–3261, 3355–3392, plus a grep of every room's Mechanism / Build / Gate / Dance line (425–2736) | Read + grep | 5175d0c3 |
| waves/register/06-chakra-skills.md | 2616 | 93–141, 1212–1240 (head), 1238–1422, 1537–1695, 1803–2366, 2584–2616, plus a heading grep | Read + grep | d85befa7 |
| waves/register/READER-BRIEF-2.md | 42 | 1–42 | Read | 813bf3dd |

**Not read in full, and why.**

- In register 05, the per-room dossiers 03–33 (lines 570–2735) were taken through their Mechanism, Build, Gate and Dance lines by grep only. The verbatim prose in between is story material (ruling 5) and is already registered by reader 05.
- In register 06, A.1 and A.3 per-chakra detail, B.1–B.3, B.5, B.7, B.8, C.3 tails and D were not read; they fall outside the assigned sections.
- The three Swift excerpts are outside my assignment and were read only to confirm entry points.
