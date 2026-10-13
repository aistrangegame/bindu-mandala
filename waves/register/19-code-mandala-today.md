# THE REGISTER · 19 — Code reader: the Mandala, Today/the Rite, Root, Recognition, Chakra (parity check)

Reader 19 · 12 Oct 2026 (night) · read-only.
Source root: `iOS/Bindu Mandala/Views/`. The task gave the path as `iOS/Bindu Mandala/Bindu Mandala/Views/`, which does not exist; the only `Views` folder in the repo is `iOS/Bindu Mandala/Views/` (`find iOS -type d -name Views`), so that folder is the one read.
Scope: 46 Swift files, 12,871 lines, each read in full with the Read tool (§D). For comparison I also read `03-mandala-worlds-layers.md` in full and `02-rite-axis-field.md` §A2 (L309–1067).

**Legend.** `file:line` refers to the Swift file under `Views/`. "Design" means the register's record of the Claude Design exports: R03 for `03-mandala-worlds-layers.md` and R02 for `02-rite-axis-field.md`. World names follow the foundation's fifteen.

---

## A · Inventory: a map of each file

Each block covers the file's purpose, its world, its register items, the data it reads or writes, any hard-coded restrictions, and its defects.

### A1 · Root/

**Root/RootView.swift** (227 lines). *The shell.*
- **Navigation.** `enum Destination { mandala, rite, well, the102, memory }` (L17). There are five destinations, and only one is shown at a time through a `switch` (L56–67) keyed `.id(destination)` (L69). Each destination has its own insertion transition (L40–49):
  - Mandala: scale 1.06.
  - Rite: 1.015.
  - Well and the 102: 0.98 from the top.
  - Memory: 0.965.
- **Launch.** Launch goes to `.rite` unless the app was relaunched on the same practice day. In that case it restores `last_destination` (L19–36). Launch arguments can force a start (`START_TAB=`).
- **Chrome.** The hamburger floats over everything at top 16 and trailing 16 (L73–77). The menu veil sits at `zIndex(1)` (L79–87). Settings opens in a `.sheet` (L89).
- **Global presenters:**
  - `.playFieldPresenter()` (L93)
  - `.leelaDrops()` (L95)
  - a gift `fullScreenCover`, which opens ShaktiDetail with "the gift" as its back label (L134–138)
- **Notification-driven routing.**
  - `RecognitionMomentView.didSettleNotification` switches to `.memory`, but only when the recognition came from Today (L100–110).
  - `MandalaWays.notification` switches to `.mandala` (L127–129).
  - `GiftRouter.openNotification` triggers `landOnGift` (L131–133).
- **Bootstrap `.task`** (L111–124). It seeds the store, backfills recognitions, migrates the summons hour, primes the summons and gift providers (each Śakti's quality, or her Appreciation Phrase, else her Function), syncs Airtable, and reschedules both.
- **HamburgerButton** (L181–227). Three bars, 19×1, at gold .75, spaced 6 apart. On first run it breathes once (1.6 s up after 0.6 s, then 1.6 s down) and stores `hamburger_first_run_seen`.
- **World:** the shell.
- **Data:** Shakti (quality, appreciationPhrase, shaktiFunction), the AppStorage keys `last_destination` and `last_destination_day`.
- **Hard-coded restrictions:**
  - Only five destinations (L17).
  - There is no back stack. The destination is overwritten, and `.id(destination)` destroys the previous world's state.
  - Launch lands on the Rite, not the Bindu (L35).
- **Defects:**
  - Ruling 1 ("Launch arrives at the Bindu") is not built.
  - Every menu visit rebuilds the Mandala: camera, focus, Road and constellation-session state are all lost.
  - Routing is done by three ad-hoc NotificationCenter channels plus static singletons (`MandalaWays.pending`, `GiftRouter`). There is no router.

**Root/HamburgerMenuView.swift** (71 lines). *"The only navigation chrome in the app. A whisper, not a feature."* (L4)
- It is a full-screen veil lit by the day (`LightField(Backdrop.veil(day))`, L22).
- **Items** (L31–36): The Mandala · The Rite · The Well · The Field · The Memory · Settings. The five room items are Cormorant 32 with tracking 1.2. Settings is 22 at cream .6. The active item is in `day.accentBright` with a glow of 18.
- Tapping off the items closes the veil (L25–28). All animations are easeInOut 0.3.
- **Restrictions:** the header calls it the "only navigation chrome" (L4).
- **Defect:** no other world is reachable from here — not Home/Bindu, the 33, the Climb, the Modes, A Strange Game, Time, Beneath, the Relationship Field or Her Home. The menu also exists only at root level, so it disappears under every `fullScreenCover`.

### A2 · Mandala/

**Mandala/LivingMandalaView.swift** (772 lines). *The host of the whole Mandala.*
- **What it says it is:** "one continuous Śrī Yantra you fall through … The nine ring-worlds are gone — they live now as the Field's rows" (L4–15).
- **State it carries** (L27–73): camera (scale 0.5); focus; descent; detailFor; soundOn (`lr_sound`, default **on**, L38); roomFor; enteredRing; ringHeldAt; flash; constellation; veilOpen; chakraLayer; modesOpen; waysOpen; climbOpen; the precomputed seats, atmos, feltKp and voices; variant.
- **Two clocks.**
  - `stillSeconds` ticks once a second and stops at `MandalaLight.tratakFull` (L175–186).
  - The hour is re-read every 60 s (L190–199).
- **The ZStack's z-order** (L104–164) is answered in §B2.
- **Gestures** (L232–258, L521–550):
  - One `DragGesture(minimumDistance: 0)` pans. If the finger travels less than 6 px it counts as a tap (L527).
  - `MagnifyGesture` zooms at the start location.
  - A spatial double-tap on empty space zooms ×1.7 over 0.42 s.
  - A long-press of `TreeOfLife.holdSeconds(ring:)` (maximum distance 14) sets `ringHeldAt`.
- **Tap logic** (L554–613):
  - Nearest reachable seat within 34 pt. A seat in ring 9 opens the descent. Tapping the seat already in focus opens ShaktiDetail. Otherwise `flyTo`: scale 3, the seat at (w/2, 0.36h), easeOut 0.72 s, and the constellation threads draw in over 0.8 s after a 0.15 s delay.
- **Descent** (L615–629): easeIn 0.95 s to the descent camera (scale 5.4, Bindu at 0.44h), then `recordCrossing(9)`, then `descent = true` (0.5 s).
- **Controls** (L315–331) are two discs, 46 pt, at top 70 and trailing 16, spaced 10 apart:
  - ♪ (sound)
  - ✶ (ways in). It also carries the VoiceOver actions Fall in ×1.4, Rise out ÷1.4 and The whole yantra.
  - The header comment says "three quiet controls (gameplan §1)".
- **Header** (L260–282): "Śrī Yantra" (Sanskrit 24, tracking 1.4); the tier hint at 11.5; the TemporalMark, a 6 pt dot in `variant.markColor` at .6.
- **Veil host** (L438–511):
  - `height: min(size.height * 0.8, 660)` (L451).
  - A black .45 dimming layer behind it (L443).
  - Animation `timingCurve(0.22, 1, 0.36, 1, duration: 0.52)`, or easeOut 0.2 under reduce motion (L480–483).
  - `fallTo(ring:)` closes the Veil and sends the camera to `.ringTarget` over 0.9 s.
- **Crossings** (L671–696): `updateEntered()` registers inward crossings only. Each one brings the flash, `chakraLayer.noteCrossing`, the ring's bīja (light on) or a chime, and `recordCrossing`, which `DescentState.enter` writes to Airtable once per new depth.
- **Launch arguments:** `OPEN_SILENCE`, `OPEN_DETAIL=`, `OPEN_RING=` (L734–752).
- **Worlds:** the Mandala, nine rings, the 33, Modes, Climb, A Strange Game, Home (the Bindu). They are all hosted here.
- **Register items:** R02 L-15 and L-16; R03 A5 (Veil), A10 (Ring 9).
- **Data:**
  - reads Shakti, DescentState, RecognitionEntry (felt gesture only), `MandalaLight.enabled`
  - writes DescentState and Airtable `recordCrossing`
- **Restrictions:**
  - "three quiet controls" (L310)
  - the Veil height is capped at 660
  - Climb opens at `max(1, enteredRing or veilHere)`
- **Defects:** see §B2/§B3: the Veil height, the pile-up at the foot of the glass, the hit-target collisions, and `lalitaShakti` falling back to `shaktis.last` (L516).

**Mandala/MandalaCanvasLayer.swift** (701 lines). *The whole field in one Canvas, under one `TimelineView(.animation)`.*
- **Draw order** (L66–79): starfield → motes → enclosures → today's ring → flash → yantra → Bindu glow → family constellation → **the 33 (`ChakraConstellationDrawing.draw`)** → seats → enclosure names → Tratak.
- **Starfield** (L147–175, L680–700): **120 stars**, LCG seed **20240517**, radius 120–740, r 0.5–1.9, opacity 0.1–0.5. Every fifth star is gold, and 40 % twinkle (5+phase s, 0.15–0.7).
- **Motes** follow `variant.motes`: the moteRise envelope rises to 8 %, eases to 0.5 by 92 %, and is gone at 100 % (L184–213).
- **Enclosures.**
  - With the light off they are hairlines at gold .06.
  - With the light on they are gem bands (`MandalaLightField`, L243–257).
- **Today's ring:** a dashed circle in `dayAccent` that pulses 0.42 ± 0.16·sin(1.1t) (L294–310).
- **Ring flash:** up to 0.85 by 0.27 s, gone at 1.5 s (L314–327).
- **Yantra:** `SriYantraGeometry.layers`. Each layer keeps its ring's breath, under an 8 s shimmer and the time gains. With the light on, each line is drawn three times (×5 and ×2.2 additive glows). There are gate lights in the four mouths (L343–387).
- **Bindu glow:** r = max(0.1R·scale, 10) × `variant.binduScale` × breath, on a 4 s breath; a halo of ×2.6 with the light on (L422–442).
- **Seats** (L496–632):
  - Radii: focus 7, today 6, family 5.5, felt **4.4**, unfelt **3** (the count ramp was removed, L480–494).
  - Breath: today ×1.35 at 2.4 rad/s; the others breathe on their ring's breath.
  - Flare cycle 8 + kp mod 13 s. The felt halo is ×4.2.
  - The today/focus ring repeats every 2.6 s.
  - Names appear at tier ≥ 1. At tier 2 the line "bīja {syllable}" appears at +24.
- **Tratak:** white light drifts behind the red point after stillness (L648–671).
- **World:** the Mandala.
- **Register:** R02 L-15 (geometry, seats, tiers, flare); R03 HM-02 (time variants).
- **Data:** atmospheres precomputed by the host; `felt` is a set.
- **Restrictions:** felt is one size ("whether, never how often").
- **Defect:** the starfield is not Design's. Design has **150** stars, seed **20260711**, size .5–2.3, opacity .12–.62 (R02 L-15).

**Mandala/SriYantraGeometry.swift** (252 lines). *Design's yantra, element for element.*
- Bhūpura squares: 1.0/.94/.88 R, width 1.1, opacity .5/.4/.3.
- T-gates: half-width .11R, depth .05R, opacity .45.
- Circles: .90/.80/.70/.615, opacity .30→.24.
- Lotus16: petals .80–.90, opacity .34.
- Lotus8: petals .615–.70, turned 22.5°, opacity .36.
- Holding circle: .60, opacity .4.
- Nine triangles at **.585R**, opacity .5 (L36, L160–196).
- `MandalaYantra.down/up` (L214–221) match Design's SY_DOWN/SY_UP exactly. `ring(ofTriangle:)` maps the downs to rings 4–8 and the ups to rings 4–7 (L247–251).
- **Status:** **Built, exact.**

**Mandala/MandalaWorld.swift** (108 lines).
- Radius 320, box 760, centre 380.
- Ring radii: 306/268/224/178/145/116/88/52/0. These match SY_RING_R.
- Ring 1 sits on the square's perimeter; the other rings are circles starting at −90°. Seats are ordered by kp.
- `family()`: in ring 2, by cluster; in every other ring, the whole ring.
- **Status:** **Built, exact.**

**Mandala/MandalaCamera.swift** (148 lines).
- The camera is an Animatable value: scale .32–5.5, `fitted` .94.
- Fly: scale 3, at 0.36h.
- Descent: scale 5.4, at 0.44h.
- `ringTarget`: the viewport reaches halfway to the next ring.
- Tiers: < 1.15 / < 2.3.
- `enteredRing`: the deepest ring whose radius exceeds the viewport radius.
- **Status:** built, and it matches R02 L-15.

**Mandala/MandalaBreath.swift** (130 lines). *Nine metabolisms.*
- Periods: ring 1 none · 3 · 8 · 9 · 11 · 13 · 15 · 18 · Bindu 4 s.
- Lifts per ring: .28/.70/.47/.50/.57/.55/.86/.33.
- Shimmer: 8 s, .82↔1.
- Bindu swell ×1.28. Seat swell .22 on her ring's clock, offset by kp mod 16.
- Under reduce motion the breath is held at its middle.
- **Status:** **Built**, from R03 A0.3, HM-05 and the v2 CSS.

**Mandala/MandalaSky.swift** (79 lines).
- Design's indigo sky across the hour: a radial from sky.center to mid (60 %) to edge, centred at 0.44h; two faint washes of far air; the hour's ambient; the day's glow at 80 %×55 %, fading out by 66 %.
- **Status:** **Built.**

**Mandala/TimeVariant.swift** (340 lines).
- Design's `TIME_VARIANTS` verbatim: bg, ambient, petalSat, petalBrightness, petalOpacityMul, lotusInnerOp, triStroke/Op/Width, bhupura, binduScale (1/1/1.05/1.1/1.6), binduColor, motes 8/6/9/12/3, markColor (L5–179).
- The Living Rite's modulation (dh, lAdd, sMul, glowMul, moteMul). New moon is code-derived ("invention-by-design", L202–205).
- The sky table, gains, `binduGlow` (1/1/1.08/1.15/1.35) and `temper()`.
- **Status:** **Built.**

**Mandala/MandalaVeil.swift** (478 lines). *The Veil.*
- `VeilLight` here/open/ground/ahead/veiled (L37–103):
  - Glyph: .95/.85/.60/.30/.18.
  - Name alpha: .96/.88/.74/.62/.55, raised to a floor above Design's .36/.22.
  - Sub alpha: .70→.50.
- The light is read from **position**, not progress (`light(ring:here:)`, L121–127).
- **Peek** (L158–194): a chevron 22×9, gold .62, lifting −3 every 2 s, plus "THE NINE ĀVARAṆAS" at 11.5. It opens on a tap or a swipe up of more than 24.
- **Sheet** (L212–251):
  - The column covers rings 1–8, with Ring IX as a footer.
  - Ground: a gradient from (13,4,9)@.93 to (8,2,6)@.995, plus a gold wash standing where the walker is.
  - Radius 22, a stroke at gold .22, shadows.
  - A swipe down of more than 60 closes it.
- **Rows:** RingGlyph 36, the Sanskrit name 20, a subtitle "form · state", the ring's Notes paragraph where he stands, a Roman numeral, a wash, and a dashed threshold line for ahead/veiled.
- **Bindu footer:** the breathing red point, the name, the state, and "THE BINDU · IX".
- **World:** the Mandala (the Veil).
- **Register:** R03 A5, LG-01/02.
- **Data:** `HomeWorlds` names, `RingFactsCache.notes`.
- **Status:** see §B3.

**Mandala/WaysIn.swift** (184 lines). *The "ways in" mark (✶).*
- Six ways: ✦ the chakras · ☉ the road · ◌ the modes · ✧ her field · ⇡ the climb · ⤢ the whole (L25–84).
- `WaysInRing`: radius 150; the items sweep from 180° to 90° around the mark (L109–122).
- The view lays a black .35 dim, and the items spring out from the mark to their places (response .42, damping .86) (L126–179).
- `MandalaWays.ask/take` is a static pending way plus a notification (L89–102).
- Header quote, gameplan §1: *"If all 36 games, 33 rooms, 8 modes, 4 doors and 3 toggles appear as buttons, the instrument becomes a menu."*
- **Restriction:** "at most three quiet controls" (L7–8). This is lifted by ruling 10.
- **Worlds:** a doorway to the 33, Modes, A Strange Game and the Climb.

**Mandala/ChakraConstellationLayer.swift** (370 lines). *The 33 drawn **into the Mandala's own Canvas**.*
- **What is drawn, by address:**
  - Centre: the Bindu r15 / Lalitā r22 rings.
  - Presiding: a dashed breath round the whole ring.
  - Thread: through her seats, inset by section.
  - Seat corona: r10; the body chakras get a travelling mote.
  - Shadow: a dark band with 14 stars.
  - Armin: a garland of 33 beads turning at .04 rad/s.
- **Breath periods:** energy 11, body 6, mind/summit 15, thresholds/Bindu 8 (L98–109).
- **Colour:** the Map's hex, lifted toward cream (L80–92).
- **`ChakraConstellationVoices`** (L301–343): with `onOpen` set, every chakra anchor becomes a **44 pt hit-testing Button** placed over the glass.
- **Worlds:** the 33 (placed into the Mandala).
- **Data:** `Chakra33` bake (colorHex, kind, address, kp, avarana, road, sectionNumber).
- **Defect:** the 44 pt chakra buttons sit exactly on Śakti seats (the body, mind and summit chakras live at a seat). They intercept taps meant for those seats. §B2.

**Mandala/ChakraRoad.swift** (118 lines). *The Road as camera stops on the same yantra.*
- Seats are framed at scale 2.5 and the centre at 3.0. A ring arc is fitted at fitRadius×1.6/span. A presiding ring is whole. A threshold sits a quarter-turn on.
- The camera stands each stop at 0.42h.
- **Travel** is 2–4 s. **Dwell:**
  - 5 s by default
  - 7 s for road 33
  - 6.5 s at the Bindu
  - ≥ 6.5 s at the thresholds
  - **16 s** at the Atma and Gaia stations (L93–117)
- **World:** the 33 (the Road), hosted on the Mandala.
- **Restriction:** "a way *through* the one yantra, never a second screen" (L12–13). This conflicts with the foundation.

**Mandala/ChakraLayerOverlay.swift** (285 lines). *The layer state and its overlay.*
- `ChakraLayerState`: constellationOn is stored per phone (`chakra_constellation`), plus walking, roadIndex, the thresholds queue, focusRoad, roadAsked and leaveRoadAsked (L26–64).
- **The overlay's own z-order:**
  1. the constellation voices (only when on, not walking, and not `hidden`)
  2. while walking, `roadCatcher` (**a full-screen tap catcher**) plus `roadWords`
  3. the first queued **threshold moment** (L97–116)
- **Road words** (bottom padding 92):
  - the station kicker
  - the name (Sanskrit 28)
  - the subtitle, the verb and the Core Question
  - at a station, the **story thread**, scrolling up to 190 pt
  - "enter its room" and "leave the road" (L141–225)
- The walk's clock waits while a room is open (L257–270).
- Rooms open through `.chakraRoom($openRoad)` (L117).
- **Defects:**
  - The threshold moment ignores `hidden` (L109). It plays under the focus card or Veil if one is open.
  - `roadCatcher` lies above the Mandala's controls, so ♪ and ✶ cannot be reached while walking (§B2).

**Mandala/MandalaThresholdMoment.swift** (332 lines). *Shadow and Armin.*
- **Shadow.** The corridor's walls close in over 0–1.2 s, hold until 2.6 s, then the left wall thins (1.2 s). There are 18 stars, a gold seam, and Soles red at the left horizon. The phrase "please come back home" is revealed in its own reveal order, starting at 2.8 s, one word every 0.9 s (L102–141, L236–280).
- **Armin.** A garland of 33 gathers (1.4 s), then the gate opens (1.6–3.2 s) with a seam rising. **"Tat · Tvam · Asi"** arrives word by word at 34 pt, then the Signature Phrase. A 5-band aurora follows the three words (L143–192, L284–329).
- **Words at the foot** (bottom 132): the name, the verb, and "into {phase}" from the ring rows of 4 and 7 (L65–88).
- **Haptics:** soft 0.9 for Shadow; three light beads for Armin.
- **Sound:** Shadow is 110 Hz, 3.2 s at .07. Armin is the chord 136.1/204.15/272.2, 3.4 s, staggered .12 (L197–218).
- **Accessibility:** a VoiceOver announcement. The view is `allowsHitTesting(false)` and `.ignoresSafeArea()`.
- **Worlds:** the 33 (thresholds) and the Climb.
- **Register:** charter §2, C-1345.
- **Gift:** the corridor, the gate and the aurora are fully built light rites. They belong in the 33 world as crossings.

**Mandala/GatesOfReleaseLayer.swift** (186 lines).
- On an inward crossing the gate offers the ring's Mental State: "hold to offer it", and the words rise. On an outward crossing it receives the Siddhi.
- The gate stands for `TheGates.offeredSeconds` (the comment says nine seconds).
- The hold ring is 76 pt, bottom padding 112. The ring's Mudrā is shown as words.
- The ledger writes `stateSetDown` or `siddhiReceived` (L170–185).
- **Worlds:** the nine rings.
- **Data:** Avarana.mentalState, RingFacts.siddhi/mudra; App Activity writes.

**Mandala/TreeOfLifeRingLayer.swift** (294 lines). *Tree of Life panels at ring thresholds.*
- **Sequence:**
  1. the Presiding Form, 2.8 s
  2. the declaration (`GameStructure.panel.declaration`) for max(8, breath) s
  3. a 2.4 s fade (top padding 150)
- **The verb and guide words** thin out ring by ring.
- **Breath arc** (bottom 170).
- **Progressive luminance:** warm white round the Bindu, 5 → 90 %.
- **Collective breath:** after a hold, or stillness from ring 6 on, every seat in the ring glows together for three beats.
- **Om floor:** `SoundConductor.setDepth`.
- **Trinity voice:** Sakshi, once, at the witness ring.
- **Worlds:** the nine rings, plus Time (the breath).
- **Defect:** it piles onto the same glass as the gate and the thresholds (§B2).

**Mandala/TheCentre.swift** (664 lines). *The point.*
- **The 64 pt point** at `binduScreen`:
  - A tap opens Mauna.
  - A hold blooms the yantra (G17 Spanda, `BloomPress`, tau from 6 % per frame).
  - **Stillness** at ring ≥ 7 near the middle opens Mauna by itself (L68–132).
- **`MaunaView`** (fullScreenCover):
  - the ring 2 and ring 3 names orbiting at 158/110×scale
  - the colourless Maya light
  - **Pointy:** 102 particles, line → circle → ∞ → heart
  - the crimson Bindu, 84 pt, with a cream core of 22
  - Praveśa: seven nested yantras falling, with a Shepard tone
  - **His lines:** "Who is saying that?" / "awareness is the space it is said in" / "the pointy loves" / `Pravesha.falling` / `recognised` + the ring-9 appreciation phrase / "be still · a touch returns you" (L436–495)
  - A touch leaves. `MaunaSilence.record` writes on leaving. If he fell through, the point opens to Lalitā (L92–99).
- **`CentreYantra`** is Design's `FullYantra` in ±150 units (L529–664).
- **Worlds:** Home (the Bindu), Beneath, Ring 9.
- **Register:** R03 R9-A/R9-B and M5; Codex C-1305/1306/1307/1355.

**Mandala/StillnessAtTheCentre.swift** (207 lines). *Pure rules.*
- `CentreArrival`: one breath (`BreathClock.breath`), ring ≥ 7, within 0.28 of the shorter side.
- `MaunaDepth`:
  - stillEnough .85; it deepens at 1/48 per second and loosens at 1/10
  - Maya gone by .18; Pointy from .14 to .52; the fall at .5; rest 4 s before it opens
- `WhoIsSaying`, and `Pointy` (lemniscate of Gerono; the heart curve normalised by /17).
- **Worlds:** Home and Beneath.

**Mandala/LalitaSourceView.swift** (382 lines). *The Bindu opens.*
- **The red bloom:** 1400 pt across over 1.6 s; it rises to full by 34 %, then settles to .55.
- **The returning field:** the 102 at ×.82, turning once in 160 s, arriving over 2.4 s after a 0.4 s delay.
- **Her presence:** cream / gold 34 % / red 62 % / gone 78 %, breathing every 6.5 s.
- **Words** (delays 1.5→3.3, emerging over 1.1 s):
  - "NINTH ĀVARAṆA · THE BINDU"
  - "the point that contains all points"
  - her short name at 64
  - her full name
  - quality
  - "There is nothing else here…" (Design verbatim, R02 L-16)
  - ॐ "SOUND THE SOURCE"
  - "enter her presence"
  - **"play in her field"** (Wave 4)
  - "↑ return to the field"
- "Play" opens TheEightDissolutions (L68–72).
- **Worlds:** Home (the Bindu) and Her Presence (kp 102). The gate into A Strange Game.
- **Status:** built at near parity. The name is 64 rather than Design's 68.

**Mandala/TheEightDissolutions.swift** (318 lines). *Panel 9.*
- There is one station per ring, 1–8. Each shows his declaration, and each is released by the inverse verb: lift, hold then release, offer up, fold in, move, let go, be still, silence.
- The ground warms from dark to the panel's paper (.91/.89/.87) as the stations pass.
- The Om swells with each release.
- Then the Mirror's recognition, the closing lines, and "Now go play." → `PlayFieldView`.
- **Writes nothing.** Walked once per practice day (`dissolved_day`); later the same day it goes straight to play.
- **Worlds:** A Strange Game (the threshold into Leela).
- **Restriction:** once per day (L72–83).

**Mandala/SignificanceCard.swift** (133 lines).
- Contents: a family kicker; × close; name 30; phonetic; quality; "threaded to N sisters"; the bīja button "SOUND HER"; significance (qualityDescription, else somaticPoetry, 3 lines); "enter her presence" (red capsule); **"be with her ›"** (her room).
- The ground is `Color.ground` at .92, radius 20, with the accentSoft stroke and the glow shadow.
- **Status:** see §B3: partly. Design's text is `description | av.personalConnection | av.subtitle`.

**Mandala/MandalaAccessibilityLayer.swift** (143 lines).
- One element per on-screen seat and enclosure, in garland order with negative priorities. It is not hit-testable.
- Each target is 44 pt.
- **Status:** built (accessibility floor).

**Mandala/MandalaVoice.swift** (302 lines).
- The IAST romanisation table; `speakablePhonetic`; ordinals and cardinals spelled out as words, *"a numeral beside a total is the shape a score arrives in"* (L195–198).
- Seat label: "{name}. {quality}. {Ordinal} enclosure, {nth} of the one hundred and two."
- `enclosureForms` as spoken words.
- `closeCeremony` "Close this moment and return."
- **Status:** built (accessibility).

**Mandala/MandalaFieldVoice.swift** (74 lines).
- The Mandala's sound is on by default and plays through an ambient session.
- The voice of the enclosure the glass has fallen into.
- Ring 7 strikes the twelve-voice chord on crossing 6→7.
- In ring 8, the triad unites after 6 s of stillness.
- In the descent, the Shepard tone falls through.
- **Worlds:** the nine rings (as sound only). This is the remnant of the Ring Worlds.

**Mandala/RingGlyph.swift** (123 lines).
- Nine 36 pt glyphs: square + T-ticks · 16 ticks · 8 ticks · crossed triangles for 4–7 · Mūla trikoṇa · Bindu.
- **Defect (parity):** rings 4–7 share one glyph. Design gives 4 a star, 5 an up triangle pair, 6 a down pair and 7 a circle with 12 dots (R03 LG-02).

### A3 · Today/ (including Rite/)

**Today/DailyRiteView.swift** (514 lines). *The Rite.*
- **Today's Śakti:** the pinned `ENERGY_POS`, else `DailyEnergyService.todaysPosition()` (6 am boundary) (L49–66).
- **Layers** (L198–224), in order:
  1. AtmosphereBackground (flipLeft)
  2. sigil layer (opacity `DayLight.riteSigilOpacity`, over the sigil's duration and delay)
  3. veil name (ether)
  4. DustMotes 16 by element
  5. DepthOverlay
  6. the column: celestial strip / centre stack (plan-ordered blocks) / foot
  7. LowStateDoorButton at top-leading
- **Openings:** the Rite's opening plays once in each light and dark half of the day (`RiteOpening.opens`), at zIndex 10.
- **Closing stations** play once a day after a recognition closes (L176–187), at zIndex 5.
- **Covers:** LowStateDoor, ModeHost (the hour's mode), RecognitionMomentView, ShaktiDetail ("today"), `.herRoom`, and the Nityā `.sheet` (medium/large) (L103–130).
- **Foot** (L411–452):
  - RiteGraceLine
  - **"I feel her"** (Sanskrit 23, 60 tall, `FeelHerPill`: red → feelHerEnd, breathing at her ring's rate, pulse style for rings 4–8)
  - **"{kp} of 102 · bīja {x}"** as a door to her room
  - RiteDayDoors
- **Celestial label:** "{Śukla|Kṛṣṇa} {tithi} · {Nityā}", or "Pūrṇimā · Lalitā Mahātripurasundarī" (L365–375). The Nityā slot is mirrored on the waning half (L475–486).
- **Worlds:** Today / the Rite.
- **Register:** R02 L-12, L-20.
- **Data:** Shakti, NityaDevi, Avarana; UserDefaults keys for opening, closing and bells.
- **Defects:**
  - It inherits Design's mirrored tithi name (R02 L-05 ⚠). Kṛṣṇa pratipadā reads as the 14th.
  - "{kp} of 102" is a numeral beside a total, which MandalaVoice warns against (L195–198). Design carries it too.

**Today/Rite/RiteComposition.swift** (87 lines). *Six element plans.*
- `TD_PLANS`, verbatim (L25–62):

| element | archetype | block order | align | sigil | scale | other |
|---|---|---|---|---|---|---|
| fire | ascension | kicker, prompt, rule, quality, name, phon, know | center | bottom | 1.0 | nameCap 58 |
| water | descent | kicker, name, phon, know, rule, quality, prompt | center | bottomWide | 1.15 | nameCap 58 |
| air | horizon | kicker, name, phon, know, rule, quality, prompt | **lean** | side | 1.0 | horizonLine, nameCap 66 |
| ether | veil | kicker, nameSmall, rule, quality, prompt, know | center | center | 0.9 | **veilName**, nameCap 58 |
| earth | foundation | kicker, name, phon, know, rule, quality, prompt | center | bottomBig | 1.3 | nameCap 58 |
| light | radiance | kicker, name, phon, rule, quality, prompt, know | center | centerBig | 1.15 | nameCap 52 |

- `RiteComposition.derive` uses kp·2654435761. It gives flip, spin, sigilScale .86–1.26 and nameTier with nudges [0, 2, −2, 3]. Design's gradAngle is omitted; Design never uses it.
- **Status:** **Built, exact.**

**Today/Rite/RiteContent.swift** (78 lines).
- Quality falls back to "Of the {ordinal} āvaraṇa — {subtitle}".
- Prompt falls back to somatic, then the first line of her poetry, then **"Where do you feel her, right now?"** (L44–52).
- `nameSize` tapers by length: ≤9 / 12 / 15 / 18 → cap / 56 / 48 / 42 / 37.
- Both fallbacks are Design's (R02 L-06). They are copy written in Design, not taken from Airtable.

**Today/Rite/RiteBlockView.swift** (154 lines).
- Blocks: kicker "{Ordinal} Āvaraṇa · cluster" (+ dot for ring 2) · name (button) · nameSmall 27 · phonetic 12.5 · **"know her ›"** · rule 54×1 · quality 25 · prompt in quotes 20.
- **Status:** built (R02 L-12).

**Today/Rite/RiteSigil.swift** (250 lines).
- `LrSigil` path for path with ×1.7. There is a blurred halo (blur 2.6·w, opacity .75, ×2.2 width). It is additive.
- Spin period 140 + hue mod 60.
- Geometry per ring: square, lotus16/8, tri14 / tri10o / tri10i, tri8, trikona, bindu.
- **Status:** built (R02 L-08).

**Today/Rite/RiteSigilPlacement.swift** (65 lines).
- TdSigil placements in points: base 620/760/560 at a reference width of 390.
- bottom +40 · bottomWide +140 · bottomBig +220 · side ±220 at 0.40h · center at 0.46h ×.95. The horizon line is at 0.43.
- **Status:** built.

**Today/RiteDayLayer.swift** (462 lines).
- **Grace line:** at most once every 24 h. It returns one ledger moment. Rarely it is a gratitude line of his own, in quotes, never dated (L24–112). *(It reads his Gratitude journal. It is private and read-only.)*
- **The pulse** (`RitePulseButtonStyle`): a heartbeat haptic while the pill is held in rings 4–8.
- **RiteDayDoors:** three doors by the hour — her room / one sound / the one-second floor / close the day.
- **OneSecondFloorView:** blink (eyelid 0.36 s + 0.45 s) → breathe 4-4-4 → press and hold `RiteDay.floorPress` → "done". It lets him go after 6 s.
- **SakshiCloseView:** one witnessing sentence from today's moments on the phone (names, silences, deepest ring, the floor walked) and the closing bell.
- **Worlds:** Today and Memory.
- **Restriction:** grace speaks once, then rests.

**Today/RiteOpeningView.swift** (366 lines).
- **Arrival:** the hour's call → "Stop. Breathe. Remember." (C-1303) → the Sacred Pause's three breaths. The circle grows with `yearLight`.
- **The hour's ways:** mode and game words. "a touch passes" (L11–167).
- **RiteClosingStations:** "offering" (her Appreciation Phrase, 6 s) → "carry" (somatic line, "into your day", 8 s), then they fade (L175–252).
- **LowStateDoor:** his own words — margin notes, the Well's letters, readable river letters, witness pages — one at a time. A sealed letter stays sealed (L276–366).
- **The stations:** Arrival · [the nine beats] · Offering · Carry. The full six-station law lives in `Services/RiteOpenings.swift`, outside this scope.

**Today/NityaDetailView.swift** (127 lines).
- The sheet carries the Nityā name 42, the tithi label, the framing line and the body prose.
- The framing text is Design's verbatim (R02 L-20). It is not taken from Airtable's Nityā quality.
- **Gift:** the Nityā's Airtable quality, bīja and dhyāna (R03 TMP-6) are not read here.

**Today/MoonPhaseView.swift** (45 lines).
- A 22 pt crescent mask plus `LunarPhaseService.headerLabel`.

**Today/DustMotesView.swift** (154 lines).
- `LrMotes`: rise / fall / drift / still / twinkle, set by element. Envelope and seeds as in Design.

**Today/TheBells.swift** (58 lines).
- **Opening bell:** 272.2 Hz, 5.5 s at .2, with a rigid haptic. Once per practice day.
- **Closing bell:** 136.1 Hz, 7 s at .22, with a double soft haptic.
- **World:** Time.

### A4 · Recognition/

**Recognition/RecognitionMomentView.swift** (502 lines).
- **Timeline:** name .3 → phrase 1.1 → **"she was felt here · h:mm a"** (shown uppercase) 2.6 → **"and she felt you back · h:mm:ss"** 4.3 (timestamped when it actually appears) → the note "What did you notice?" 5.4 → "TAP ANYWHERE TO CLOSE".
- **Practice data first:** `RecognitionLogStore.record` and `markRiteCompleted` run before any motion.
- **Close:** commit the note → Airtable `recordRecognition` → collapse .62 s → after-glow 1.8 s → `didSettleNotification`.
- **Floors:** both lines are verbatim (L270, L288).
- **Defect:** `khadgamalaPositionOrFallback = position + 28` (L499–501), a legacy guess.

**Recognition/RecognitionNature.swift** (282 lines).
- The six natures: flare / pool / disperse / bloom / settle / radiate.
- Rest and peak poses, cycles 5.5/6.5/6.0/4.8/7.5/3.8; focalY and glowY.
- Ripples: ring/rise/wide, counts 4/4/5/3/2/5, durations.
- Motes 12/10/14/10/6/12.
- Haptic pulses; answer durations.
- `RecognitionTimeline` constants.
- **Status:** **Built, exact** to R02 L-14 `LR_RECOG`.

**Recognition/RecognitionLight.swift** (513 lines).
- The backdrop with a second light per nature.
- The nature's standing light: tongue, lens, streams, bloom disc, horizon band, 16 rays.
- The emissive core; ripples; the one-time answer at Act 2; the after-glow (k² decay); haptics.
- **Status:** built, and beyond Design (additive light).

### A5 · Chakra/

**Chakra/ChakraRoomView.swift** (797 lines). *One chakra's room: the Map row as a vertical scroll.*
- **The sections, in order** (L84–132):
  1. **Arrival:** voice, name 44, Sanskrit, subtitle, verb, Core Question, Hero Threshold, Signature Phrase.
  2. **Story:** the Story Thread, plus voice layers in tabs: act one / act two / the Bindu, after / the witness.
  3. **Practice:** Practice Prompt; Three Ways In as three expandable doors; movement doors.
  4. **Wake-up:** the bīja text; the Mirror Frequency Instruction; "sound {syllable}".
  5. **The gate:** Gate Text; optional Writing Prompt plus text field; a hold capsule of 1.4 s. Then the offering leaves: **"The room keeps what you gave it. You walk lighter."** (L80). Then the Writing Reflection and the **Leela Story**.
  6. **Doors:** her room (HerRoomPassage), the ring on the Climb (ChakraRingClimb), and games.
- **Way out:** "‹ leave the room", or the edge.
- **Ledger:** one `Chakra Practiced` row per practice per visit (L642–655).
- **World:** the 33 (a room). Ruling 5 makes the room the chakra's energy.
- **Story material:** storyThread, act1Voice, act2Voice, binduReflection, witnessPerspective, leelaStory. Flag them for Bindu Feed (§C3).
- **Defects:**
  - `soundOn` is read once at init (L73).
  - `ChakraRoomExitView` → `ChakraRingClimb` → `WorldClimbView`, whose ClimbBodyChakras can open another room → nested `fullScreenCover`s with no depth limit and no single way home.

**Chakra/ChakraRoomDoor.swift** (145 lines).
- `.chakraRoom($road)` presents a `fullScreenCover`.
- `ChakraRoomField` gives each kind its own light:
  - energy: 5 breathing rings
  - body: 28 rising motes
  - mind: one circle
  - summit/bindu: a triangle (gold at Atma)
  - Gaia: a green ground rising
  - Shadow: dark with 40 stars
  - Armin: 33 beads

**Chakra/ChakraMovementPractice.swift** (756 lines). *Eight held practices on the play clock.* Each takes touch, shake or tilt (`TouchSenseSurface`, `PlayMotion`):
- euphoriaPulse: shake to charge → three heart pulses + chord 110/165/220
- roarAndSilence: hold for the roar at 110 Hz with thumping haptics → release → silence for 6 s
- lastMemories: name the memory (kept only if he chooses) → eyelids close → vibrate → open
- **Ham · Het · Hum:** three breaths × three cycles
- fearInWaves: violet wash → release → prāṇa
- feelingThrough: a column of light, spreading over 9 s
- restlessness: 64 motes under gravity
- heartHome: a mote out and back to the heart

Nothing is counted. A practice writes one row when it settles.
- **Gift:** these are Codex movements as instruments. They belong in the 33 world's practice.

**Chakra/ClimbBodyChakras.swift** (95 lines).
- The ten body chakras at their heights on the Climb. Their presence follows the walker's height.
- Each is a 64×44 button labelled with name and verb. A tap opens the room.
- **World:** the Climb (Axis).

---

## B · Answers (exact, with file:line)

### B1 · How navigation works today

**Root.** `BinduMandalaApp` (not in scope) hosts `RootView`.
- RootView is a `ZStack`: ground; the current destination switched on `Destination`; the hamburger; and the menu veil when it is open (RootView.swift:52–88).
- **Launch.** The app opens on **the Rite**. Within the same practice day it restores the last destination instead (L19–36).
- **No Bindu home exists.** Ruling 1 is unbuilt.

**The five top-level screens**, all reached only through the hamburger veil (HamburgerMenuView.swift:31–35):

| Menu item | View | Notes |
|---|---|---|
| The Mandala | `LivingMandalaView` | |
| The Rite | `DailyRiteView` | |
| The Well | `WellView` | out of scope |
| The Field | `TheHundredTwoView` | out of scope |
| The Memory | `PortraitMandalaView` | out of scope |
| Settings | `.sheet` | RootView:89 |

- **Leaving a top-level screen:** only through the menu. Selecting an item replaces `destination`. `.id(destination)` (L69) discards the old view's state.
- **There is no back.** The only automatic switches are:
  - Recognition from Today → Memory (L100–110)
  - a requested Mandala way → Mandala (L127)

**What overlays what.** Everything below is a `fullScreenCover` or `sheet`, so it hides the hamburger and the menu while open.

| From | Overlay | Reached by | Left by |
|---|---|---|---|
| Root | ShaktiDetail ("the gift") | a gift notification (L134–138) | its back |
| Root | PlayField (global presenter) | `PlayField.open()` from anywhere (L93) | play's close |
| Root | Leela drops | `.leelaDrops()` (L95) | (outside scope) |
| Rite | RiteOpeningView | in-view `zIndex 10` (DailyRiteView:88–96) | a touch, or its timer |
| Rite | RiteClosingStations | in-view `zIndex 5` (L77–86) | a touch, or its timer |
| Rite | RecognitionMomentView | "I feel her" (L119–121) | a tap once the name is up |
| Rite | ShaktiDetail ("today") | the name, "know her", or the veil name (L122–124) | back |
| Rite | Her room | the seat line, or a door (L125, L433) | the room's own way out |
| Rite | Nityā sheet | the celestial strip (L126–130) | swipe down |
| Rite | LowStateDoor | top-left line (L106) | rest, or the edge |
| Rite | ModeHost | the hour's way (L110) | — |
| Rite | OneSecondFloor, SakshiClose | the three doors (RiteDayLayer:205–208) | "go", "rest" |
| Mandala | Significance card | first tap on a seat (LivingMandalaView:159, 293–308) | × or ⤢ |
| Mandala | ShaktiDetail | second tap, or "enter her presence" (L202–204) | back |
| Mandala | Her room | "be with her ›" (L219, L303) | the room's own way out |
| Mandala | Veil sheet | peek tap or swipe up (L439–467) | tap the dim, swipe down, handle |
| Mandala | Ways ring | ✶ (L318–322, L347–358) | any tap |
| Mandala | ModesDoorView | the ways ring (L206–208) | its close |
| Mandala | ChakraRingClimb | the ways ring (L211–214) | its own exit |
| Mandala | Constellation (drawn into the canvas) | the ways ring | toggled off |
| Mandala | Road (camera and words on the same glass) | the ways ring | "leave the road" |
| Mandala | Chakra room | a light in the constellation, or "enter its room" on the Road (ChakraLayerOverlay:101–103, 193–206, 117) | "‹ leave the room" |
| Mandala | MaunaView | the point: tap, or stillness at ring ≥ 7 (TheCentre:91–100) | a touch |
| Mandala | Lalitā source | in-view `zIndex 40` (L163, L421–431) | "↑ return to the field" |
| Lalitā source | TheEightDissolutions → PlayFieldView | "play in her field" (LalitaSourceView:68–72) | — |
| Lalitā source | ShaktiDetail | "enter her presence" | back |
| Chakra room | Movement practice | in-room `zIndex 2` | "‹ back to the room" |
| Chakra room | ChakraRoomExitView (HerRoomPassage / ChakraRingClimb / PlayField.host) | the doors (ChakraRoomView:126–128) | its own exit |
| Climb | ClimbBodyChakras → chakra room | a body light (ClimbBodyChakras:93) | its own exit, and so on, recursively |

**The ways out vary from screen to screen.** They include "‹ leave the room", "↑ return to the field", ×, "rest", "go", "not now", "a touch passes", `.theEdgeWayOut`, a tap anywhere, and swipe down.
- No overlay can reach the menu.
- No overlay knows what is beneath it beyond its own binding.
- Crossings between worlds are made by notifications (`MandalaWays`, `GiftRouter`, `didSettle`) and global presenters (`PlayField.open`).

### B2 · Why chakras, the Road and Tat Tvam Asi overlap on the Mandala, and why the chakra menu "collapsed downward"

**1. All of it is drawn on one glass, in one ZStack.** The z-order runs back to front (LivingMandalaView.swift:104–164):

| # | Layer | Line | Notes |
|---|---|---|---|
| 1 | `background` (MandalaSky) | 105 | |
| 2 | `MandalaCanvasLayer` | 107–119 | One Canvas. Draw order (MandalaCanvasLayer:66–79): stars → motes → enclosures → today → flash → yantra → Bindu → family threads → **the 33 chakras** (`chakras: chakraLayer.drawn`, `roadFocus`) → **the 102 seats** → enclosure names → Tratak. The 33 are drawn *under* the seats and names, in the same pixels. |
| 3 | `MandalaAccessibilityLayer` | 127 | no hits |
| 4 | `gestureCatcher` | 132 | pan, pinch, double-tap, hold |
| 5 | `TheCentre` | 137 | 64 pt hit circle at the Bindu |
| 6 | `GatesOfReleaseLayer` | 141 | gate words + 76 pt hold ring, **bottom padding 112** (GatesOfReleaseLayer:147) |
| 7 | `TreeOfLifeRingLayer` | 143 | Presiding Form and declaration at **top 150** (TreeOfLife:154); breath arc at **bottom 170** (L259); luminance over the whole glass |
| 8 | `header` | 146 | |
| 9 | `controls` | 150 | ♪, ✶ at top 70 |
| 10 | `ChakraLayerOverlay` | 152–158 | chakra voice buttons; **Road catcher + Road words at bottom 92** (ChakraLayerOverlay:134–139, 219); **threshold moment**, full-screen `ignoresSafeArea`: Shadow corridor / Armin gate + "Tat · Tvam · Asi" at centre −40, words at **bottom 132** (MandalaThresholdMoment:87, 140, 166) |
| 11 | Significance card | 159 | |
| 12 | Veil | 160 | peek at **bottom 30**; sheet `zIndex 20` |
| 13 | Ways ring | 162 | `zIndex 30` |
| 14 | Lalitā | 163 | `zIndex 40` |

- **The 33 are not a place.** They are a toggle drawn into the yantra's own canvas (ChakraLayerState.drawn, ChakraLayerOverlay:46–48).
- **The Road is not a place either.** It is the same camera moved over the same canvas (ChakraRoad:5–13, "never a second screen"). Its words are laid at the foot of that glass.
- **Tat Tvam Asi is a full-screen light rite.** Any inward crossing from 6 to 7 queues it, whether made by pinch, by Veil row or by Road stop (`noteCrossing`, LivingMandalaView:676; ChakraLayerState:52–58; ChakraLayerOverlay:281–283). It plays over the field, with no hit testing.

**2. One crossing triggers five systems at once, because each listens to `enteredRing` independently.**
- A Veil row tap calls `fallTo`. It assigns the target camera and calls `updateEntered()` in the same instant (LivingMandalaView:507–510), so `enteredRing` jumps straight from 0 (or today's ring) to the target.
- On a jump to 7 or deeper, this happens simultaneously:
  - the ring flash (L675)
  - **both** Shadow and Armin are queued (thresholdsCrossed 0→7) and play one after another
  - the Gates layer offers ring 7's Mental State at the foot (GatesOfRelease:56, 156–166)
  - TreeOfLife names the Presiding Form at the top and starts the breath arc low (TreeOfLife:66–71, 88–110)
  - the ring's bīja sounds and the ring-7 chord strikes (L680–683; MandalaFieldVoice:39)
  - the Om floor moves (TreeOfLife:67)
- **The foot of the glass holds, at the same time:** gate words (bottom 112) · threshold words (bottom 132) · breath arc (bottom 170) · Road words (bottom 92) · Veil peek (bottom 30).
- **The middle holds:** "Tat · Tvam · Asi" (centre −40) · the Bindu's 64 pt point · the luminance.
- **Only some layers get out of the way:**
  - The Gates and TreeOfLife check `!descent && focus == nil && !veilOpen` (L141–145).
  - They do **not** check `chakraLayer.walking` or whether a threshold moment is playing.
  - The threshold moment checks nothing. `hidden` gates only the voices (ChakraLayerOverlay:99 vs 109).

**3. Hit-target collisions on the same glass.**
- With the constellation on, every chakra anchor becomes a 44 pt `Button` above the gesture catcher (ChakraConstellationLayer:315–328; ChakraLayerOverlay:101–103).
- Body, mind and summit chakras are anchored *on a Śakti's seat* (`anchor` → `.seat`, L272–274).
- So a tap on those seats opens the chakra's room instead of flying to her, and a pan that starts there is swallowed.
- While walking the Road, `roadCatcher` is a full-screen `Color.clear` that takes every tap (ChakraLayerOverlay:134–139). It lies above `controls` (layer 9 under layer 10). ♪ and ✶ go dead; "leave the road" is the only exit on the glass.

**4. Why the chakra menu "collapsed downward".**
- The chakras are reached through the ✶ "ways in" mark, the second disc of the control column. Its centre is at `x = w − 16 − 23`, `y = 70 + 46 + 10 + 23 = 149` (LivingMandalaView:340–343).
- Opening it lays a black .35 dim over the glass (WaysIn:140). The six ways spring out *from the mark itself* (`position(open ? p : centre)`, L171) onto a quarter arc of radius 150.
- That arc runs from straight left (180°) to **straight beneath** (90°) (WaysIn:110–116). The menu therefore hangs down the right edge of the glass — from (w−189, 149) to (w−39, 299) — over the upper-right quadrant of the yantra, like a dropdown falling from the corner.
- Above it, RootView's hamburger stays live at top 16 (RootView:73–77, 44 pt, so y 16–60). Two menus are stacked in the same corner.
- Choosing "the chakras" does not open anywhere. It calls `toggleConstellation()` (L365–366), which draws the 33 *into* the yantra beneath. The menu closes back into the mark and the chakras appear inside the Mandala, overlapping the seats.
- **Root cause:** the 33, the Road, the thresholds, the Climb, the Modes and Lalitā's field were folded into one "ways in" ring on the Mandala (WaysIn:3–21). This followed the gameplan's "three quiet controls" restriction, which ruling 10 now lifts.

### B3 · Parity against Design

**The Mandala** (R02 L-15, R03 A5/HM):

| Item | Design | Code | Verdict |
|---|---|---|---|
| Yantra geometry | SY .585R etc. | SriYantraGeometry:30–200 | **built** |
| Seat placement and radii | SY_RING_R | MandalaWorld:20–69 | **built** |
| Camera clamp, fit, fly 3.0 at .36h, 720 ms, double-tap ×1.7, tiers | as in Design | MandalaCamera; LivingMandalaView:247–258, 603–613 | **built** |
| +, −, ⤢ buttons | three buttons | only VoiceOver actions on ✶, plus the "whole" way (L324–326) | partly |
| Header and tier hints | 25 px / 9.5 px | 24 / 11.5 (L262–267) | built (sizes nudged up) |
| Starfield | 150 stars, seed 20260711, size .5–2.3, opacity .12–.62 | 120 stars, seed 20240517, r .5–1.9, opacity .1–.5 (MandalaCanvasLayer:680–700) | **wrong** |
| Seat breath | per kp (3.4 + kp mod 7 · .7) s | per ring metabolism (MandalaBreath:124–129) | deliberate change |
| Felt dot ramp | 4 + min(n,6)·.4 | one size (L480–494) | deliberate (law) |
| Family threads, dim .28 | yes | L446–476, L537 | **built** |
| Significance card | description \| personalConnection \| subtitle | qualityDescription \| somaticPoetry, plus "be with her ›" (SignificanceCard:23–28) | partly |
| ♪ default | off | on (L38) | deliberate (Wave 2) |
| Ring-entry chime (bell frequencies per ring) | bell | ring bīja when light on, else chime (L680–683) | partly |
| Auto-descent at scale > 4.3 | yes | not built; replaced by tap and stillness Mauna | deliberate (never auto-advance) |
| Background sky | yes | MandalaSky | **built** |
| Lalitā source (bloom, field 160 s, presence 6.5 s, words 1.5–3.3 s) | yes | LalitaSourceView | **built** (name 64 vs 68; "play in her field" added) |
| Held yantra "look, do not operate", eyebrow "2nd Avaraṇa · Sarvāśā-Paripūraka" | Veil resting state | not built. The code yantra stays fully interactive | **not** |
| Home Mandala five temporal states and TemporalMark | yes | TimeVariant + header dot | **built** (the mark is centred, as in Design) |

**The Veil** (R03 A5, VL-01 to VL-04):

| Spec | Design | Code | Verdict |
|---|---|---|---|
| Sheet height | **720** | `min(h·0.8, 660)` (LivingMandalaView:451) | **wrong** |
| Peek | the sheet's top **108** visible (closed offset 612) | a separate chevron and label button at bottom 30, about 48 tall (MandalaVeil:158–194; LivingMandalaView:463–466). The sheet is absent when closed | **wrong** (concept partly kept) |
| Drag tracking (the sheet follows the finger, clamped 0…612) | yes | none. The sheet is inserted with `.move(edge: .bottom)`. The peek opens on a swipe of more than 24; the sheet closes on a drag of more than 60 (MandalaVeil:186–188, 248–250) | **not** |
| Tap < 6 px | toggle | it is a Button tap | partly (same effect, different mechanism) |
| Snap at 42 % (offset < 257) | yes | none | **not** |
| 0.52 s cubic-bezier(.22,1,.36,1) | yes | `timingCurve(0.22,1,0.36,1, 0.52)` (L480–483) | **built** |
| Yantra dims to 0.5, proportional to offset | `0.5 + 0.5·offset/612` | a fixed black .45 overlay (≈0.55) (L443) | partly |
| Backdrop tap closes | yes | L445–446 | **built** |
| Handle 40×4, "The Nine Avaraṇas" + "DESCEND" | yes | L270–301 | **built** |
| Rows I–VIII, Bindu footer IX, Roman numerals, wash, dashed line | yes | L304–429 | **built** |
| LUM table | home / unlocked / ancient / locked / deep_ghost from progress | here / open / ground / ahead / veiled from **position**, name alpha floored at ≥ .55 | deliberate change (law) |
| Row meta "{form} · {count} forces" | yes | subtitle "form · state", no count | partly |
| Routing on tap | Ring II → **RingTwoWorld**; others → **Avaraṇa Threshold** ceremony | camera `fallTo(ring)` through the same yantra (L499–511) | **wrong** (the ring worlds are not built) |
| RingGlyph per ring | nine distinct | rings 4–7 share one (RingGlyph:20) | partly |

**The ring worlds** (R03 A0.3, A7–A10). The code says outright: *"The nine ring-worlds are gone"* (LivingMandalaView:7–8).

| Ring | Design verb | Code | Verdict |
|---|---|---|---|
| 1 Earth-City | meet / illumine / ignite 28 lights; drone 73.42 + 110 | only the Gates and TreeOfLife layer for ring 1; no world | **not** |
| 2 Inhabited Lotus | press a petal to invoke; others mute to .18; "release · she remains" 2.6 s; C3 voice | none (the Field rows are out of scope) | **not** |
| 3 Smoke Lotus | stillness gathers, reaching scatters (800 ms); seed hsauṁ | none | **not** |
| 4 Lineage | transmission every 340 ms | none | **not** |
| 5 Overflow | rays; flood | none | **not** |
| 6 Concealed | light reveals within 92 px | none | **not** |
| 7 Vāk | 12 syllable nodes; chord at 55 ms; healed at ≥ 7 | only the chord on crossing (MandalaFieldVoice:39) | partly (sound only) |
| 8 Mūla Trikoṇa | tap a vertex to collapse → Bindu; triad → C3 | only the triad uniting on stillness (MandalaFieldVoice:46–49) | partly (sound only) |
| 9 Praveśa | hold to fall; recognition 6.5–8.7 s; Shepard tone | MaunaView: the fall follows stillness, Shepard tone, "You did not arrive…" via `Pravesha` (TheCentre:409–492) | **built** (reached by stillness, not hold, by his ruling) |
| 9 Spanda (explored) | hold the centre to bloom | the centre bloom (TheCentre:143–168) | **built** |
| Per-world sound toggle and return arc | yes | none | **not** |

New, beyond Design, standing in for the worlds on the glass: Gates of Release, Tree of Life panels, Progressive luminance, collective breath.

**The Living Rite** (R02 L-07 to L-14, L-20, L-24):

| Item | Verdict |
|---|---|
| Six element plans (`TD_PLANS`), exact block orders, lean/air, veil name/ether, nameCaps 66/52/58 | **built, exact** (RiteComposition:25–62) |
| Composition per kp (flip, spin, sigilScale, nameTier) | **built** (gradAngle omitted; Design never used it) |
| Sigil placement (TdSigil) and geometry ×1.7, spin period | **built** (RiteSigilPlacement, RiteSigil) |
| Element motes; LrDepth | **built** (DustMotesView; DepthOverlay is out of scope) |
| Arrival beats .1/.25/.4/.55/.7/.8/.9/1.05/1.25, sigil 2.4 s | **built** through ArrivalBeat/StagedArrival (out of scope; wired at DailyRiteView:205, 399, 451) |
| Celestial strip → Nityā sheet | **built** (with Design's mirrored-tithi label bug) |
| Foot: "I feel her" gradient pill, "{kp} of 102 · bīja" | **built**, plus breath, pulse and doors beyond Design |
| Recognition: six natures, timeline, collapse .62 | **built, exact**, plus after-glow 1.8 s beyond Design |
| Recognition → Memory settle | **built** (only from the Rite: RootView:105–106; Design always settles) |
| Nityā sheet text | **built**, verbatim Design copy |
| Menu items and hamburger | partly (order differs; Settings live) |
| **The stations** | Arrival (opening) · the nine beats · Offering · Carry are **built** (RiteOpeningView). The middle stations are carried by the existing beats. The six-station law is in `Services/RiteOpenings.swift`, outside scope |

---

## C · Conflicts and gaps: what must leave the Mandala, and what the spine must replace

### C1 · Moving off the Mandala, each into its own world

The foundation says the Mandala world is **the held yantra plus the Veil**, and "never laid over another". Everything below currently lives on, or launches from, `LivingMandalaView`.

| Now on the Mandala (file:line) | Belongs in | Why / how |
|---|---|---|
| The 33 constellation drawn in the yantra canvas (MandalaCanvasLayer:74–76; ChakraConstellationLayer) | **the 33** world | Its own space, so it never overlaps the 102. The Mandala keeps at most a faint door: a light at each address, entered through the point. |
| The Road: camera path and words (ChakraRoad; ChakraLayerOverlay:131–284) | **the 33** — "story told by a moving point" | The moving point already exists as camera stops. It needs its own canvas, so no seats sit under it and no Mandala controls are covered. |
| Shadow and Armin threshold moments (MandalaThresholdMoment) | **the 33** (crossings) and **the Climb** | Played when crossing *between* chakra spaces, not on every Mandala pinch past rings 3→4 and 6→7. |
| Chakra rooms (ChakraRoomView, opened from the overlay and the Climb) | **the 33** (room = energy) | Already full-screen. They need a place in the 33 world and a back to it. |
| Gates of Release (GatesOfReleaseLayer) | **the nine rings** (each ring's world, at its threshold) | Arrival at a ring, not a toast over the field. |
| Tree of Life panels, breath arc, collective breath, luminance (TreeOfLifeRingLayer) | **the nine rings** | Each ring's verb, done inside the ring's world (R03 A0.3). |
| Mauna, Pointy, Praveśa (TheCentre, StillnessAtTheCentre) | **Home (the Bindu)** / **Beneath** | The Bindu is home (foundation). Deep zoom into the Bindu stays (ruling 9) as the Mandala's way *to* home. |
| Lalitā source (LalitaSourceView) | **Home** / **Her Presence** (kp 102) | The arrival at the point, as the crossing into home. |
| The Eight Dissolutions → PlayField (TheEightDissolutions) | **A Strange Game** (the doorway into Leela) | |
| The modes door (`ModesDoorView` via ways) | **the Modes** | |
| The Climb (`ChakraRingClimb` via ways) | **the Climb (Axis)** | |
| The ways-in ring (WaysIn) | replaced by **the menu** and **doors** | Restriction lifted (ruling 10). |
| Ring-world sound (MandalaFieldVoice: ring 7 chord, ring 8 unite) | **the nine rings** | The worlds' own sound recipes are in R03 A7–A10. |

### C2 · What the spine has to replace

| Today | Problem | The spine needs |
|---|---|---|
| `RootView.Destination` holds 5 cases (L17), swapped with `.id` (L69) | No Home, 10 worlds missing, state destroyed | A **world enum of 15** plus Home, each world keeping its own state alive. |
| Launch → `.rite` (L35) | Ruling 1 | Launch → **the Bindu**, with Today as the first door. |
| Hamburger and HamburgerMenuView at root only | Hidden by every `fullScreenCover`; "only chrome" | A **menu available everywhere** (a root-level overlay above presented worlds, not under them). |
| No history: destination overwritten, Detail back via `backLabel` strings | No "back to where you were" | A **back stack** (world, plus thread position: kp, chakra road, day) pushed on every crossing. |
| NotificationCenter routing: `MandalaWays.notification` (WaysIn:90), `didSettleNotification` (RecognitionMomentView:21), `GiftRouter.openNotification` (RootView:131); `PlayField.open()` global | Ad hoc, one-off, and crossings are untraceable | **One router.** Crossings go through the point (a transition through the Bindu) and carry the three threads. |
| Nested `fullScreenCover` chains (ChakraRoom → Climb → body chakra → room …; Lalitā → Dissolutions → PlayField) | Unbounded depth; every screen has a different way out | Worlds pushed onto the stack. One "home" (the point) and one back available everywhere. |
| Many different "leave" idioms ("‹ leave the room", "↑ return to the field", ×, rest, go, a touch, edge) | Inconsistent | Keep each world's own word for leaving, but route it to `back()`. Keep `theEdgeWayOut` as the universal gesture. |
| `MandalaWays.pending` static and `GiftRouter.peek/take` | Global mutable state | Router state. |
| Threads: today's kp in `DailyEnergyService`; chakra road in `ChakraSeat`; the day in practiceDayIndex | Not passed between worlds | Thread values carried on every route (kp 1–102, road 1–33, day). |
| Search | absent | New. |

### C3 · Other conflicts and gaps

1. **Ruling 5: energies, not stories.** These are story material, all real Map/Codex text. **Flag them for Bindu Feed; do not drop them.**
   - ChakraRoomView's story section: Story Thread; Act 1/Act 2 voice; Bindu reflection; witness; Leela Story after the gate (L197–263, L491–493)
   - the Road's station story threads (ChakraLayerOverlay:181–192)
2. **Ruling 2: chakra 32 = the Ego Reveal (Gaia).** Its words stay sealed.
   - The Road dwells **16 s** at the "Gaia reveal" station and shows its story thread (ChakraRoad:103–117; ChakraLayerOverlay:181).
   - The room field paints Gaia's ground (ChakraRoomDoor:118–126).
   - Verify that road 32's text is sealed. The code shows `storyThread` at any station.
3. **"Three quiet controls"** (LivingMandalaView:310; WaysIn:7) and **"the only navigation chrome"** (HamburgerMenuView:4). Ruling 10 lifts both.
4. **Ruling 9 versus the current descent.** Deep zoom into the Bindu (camera max 5.5, descent 5.4) stays. The auto-descent is not built (deliberate). Mauna also opens by stillness and by tap.
5. **The Veil's routing** (R03 D-4): Design routes to the ring worlds and the Threshold ceremony. Code only moves the camera. The v2 Avaraṇa Threshold ceremony (line by line over ~7.8 s, "Enter this Avaraṇa") is not in scope and not on the Mandala.
6. **Design-authored copy in place of Airtable.** Under the floor "nothing invented", decide whether Design copy counts as authored. The instances:
   - the Nityā framing and body prose (NityaDetailView:94–121)
   - "Where do you feel her, right now?" (RiteContent:51)
   - "Of the {n} āvaraṇa — …" (RiteContent:38)
   - "There is nothing else here…" (LalitaSourceView:280)
7. **"{kp} of 102"** (DailyRiteView:435) against MandalaVoice's own warning (L195–198). Position is identity, so the line probably stands, but the two contradict each other.
8. **Mirrored tithi label** (DailyRiteView:368–369, 481–482), inherited from Design.
9. **A threshold queued while another overlay is up** plays underneath (ChakraLayerOverlay:109).
10. **`lalitaShakti` falls back to `shaktis.last`** (LivingMandalaView:516). Mid-sync, the wrong Śakti could open as Lalitā.
11. **The Recognition kp fallback `position + 28`** (RecognitionMomentView:500).
12. **Once-a-day gates hold experiences back.** Ruling 10 lifts restrictions, so decide whether these remain:
    - the Dissolutions (TheEightDissolutions:72–83)
    - the closing stations (DailyRiteView:178–187)
    - the opening twice a day
    - grace's rest

### C4 · Gifts for the upgrade

| What | Source | World(s) | How it would work there | What it needs | Energy or story |
|---|---|---|---|---|---|
| Shadow corridor / Armin gate / aurora, with "please come back home" and "Tat · Tvam · Asi" word by word | MandalaThresholdMoment:102–329 | the 33, the Climb | Play at the crossing between chakra rooms 3→4 and 6→7 in the 33 world, full screen, alone | Move only | energy |
| Eight held practices (euphoria pulse, roar and silence, last memories, Ham·Het·Hum, fear in waves, feeling through, restlessness, heart home) | ChakraMovementPractice | the 33 (practice), Modes | The practice step of each room's braid | Exists | energy |
| Pointy (102 particles, line → ∞ → heart) and the Maya light | TheCentre:342–388; StillnessAtTheCentre:150–207 | Home, Beneath | Home's resting state at the Bindu | Exists | energy |
| Praveśa fall and Shepard tone; recognition lines | TheCentre:407–492 | Home (deep zoom), Ring 9 | Deep zoom into the point (ruling 9) | Exists | energy |
| Centre bloom (Spanda) | TheCentre:143–201 | Home | A hold at the Bindu blooms the yantra | Exists | energy |
| The Eight Dissolutions, "Now go play." | TheEightDissolutions | A Strange Game | The threshold into Leela | Exists | energy |
| Gates of Release (offer / receive), ledger rows | GatesOfReleaseLayer | the nine rings | At each ring world's door | Exists | energy |
| Tree of Life panel (Presiding Form, declaration, verb, breath arc, collective breath, luminance 5 → 90 %) | TreeOfLifeRingLayer | the nine rings | Each ring world's arrival | Exists | energy |
| Ring 7 chord, ring 8 triad unite | MandalaFieldVoice | Ring 7, Ring 8 worlds | Folded into R03's world recipes | Exists, plus R03 recipes | energy |
| Six recognition natures and the after-glow | Recognition/* | Today, anywhere "felt" | Reused for every recognition | Exists | energy |
| The six Rite plans and per-kp composition | Today/Rite/* | Today | As is | Exists | energy |
| One-second floor; Sakshi close; bells | RiteDayLayer; TheBells | Today, Time | Time's day bookends | Exists | energy |
| Low-state door (his own words) | RiteOpeningView:276–366 | Memory, Today | A door that is always there | Exists (private) | energy |
| Lalitā source bloom, returning field, presence | LalitaSourceView | Home (arrival at the point), Her Presence | The crossing animation through the point | Exists | energy |
| Veil column with position light | MandalaVeil | the Mandala | Keep. Fix to 720 / 108 / drag / 42 % / proportional dim, and route rows to the ring worlds | Drag code | energy |
| Climb body chakras at their heights | ClimbBodyChakras | the Climb | As is | Exists | energy |
| Chakra room light fields (energy rings, body motes, mind circle, summit triangle, Gaia ground, Shadow stars, Armin beads) | ChakraRoomDoor:60–145 | the 33 | Each room's ground | Exists | energy |
| Story Thread, act voices, Bindu reflection, witness, Leela Story | ChakraRoomView:197–263, 491 | **Bindu Feed** | Story → Feed (ruling 5) | — | **story** |
| Grace (one ledger moment returned; his gratitude line) | RiteDayLayer:24–112 | Today, Memory | As is | Exists (private) | energy |

---

## D · Coverage proof

**Method.** Every file listed was opened with the Read tool from line 1 to its last line in one call. `wc -l` and `md5sum` were run from `iOS/Bindu Mandala/Views/` (the task's path, `…/Bindu Mandala/Bindu Mandala/Views/`, does not exist).

The 03 register was read in five consecutive ranges: 1–340, 340–559, 560–719, 720–859, 860–995. Every line was read.

From 02, §A2 was read in two ranges: L309–688 and L689–1067. The heading index came from a heading grep.

| File | Lines (wc -l) | Lines read | Method | md5 (8) |
|---|---|---|---|---|
| Root/RootView.swift | 227 | 1–227 | Read | 976ffdfb |
| Root/HamburgerMenuView.swift | 71 | 1–71 | Read | eb1d2b6a |
| Mandala/ChakraConstellationLayer.swift | 370 | 1–370 | Read | c301b6df |
| Mandala/ChakraLayerOverlay.swift | 285 | 1–285 | Read | dbd8854f |
| Mandala/ChakraRoad.swift | 118 | 1–118 | Read | 3dbf961a |
| Mandala/GatesOfReleaseLayer.swift | 186 | 1–186 | Read | 95f13409 |
| Mandala/LalitaSourceView.swift | 382 | 1–382 | Read | 1467b620 |
| Mandala/LivingMandalaView.swift | 772 | 1–772 | Read | 13a94bcb |
| Mandala/MandalaAccessibilityLayer.swift | 143 | 1–143 | Read | d7ec9d07 |
| Mandala/MandalaBreath.swift | 130 | 1–130 | Read | 92fb8397 |
| Mandala/MandalaCamera.swift | 148 | 1–148 | Read | 5bf6a6b5 |
| Mandala/MandalaCanvasLayer.swift | 701 | 1–701 | Read | de7f7cdd |
| Mandala/MandalaFieldVoice.swift | 74 | 1–74 | Read | dd9f83e4 |
| Mandala/MandalaSky.swift | 79 | 1–79 | Read | 6020f7f9 |
| Mandala/MandalaThresholdMoment.swift | 332 | 1–332 | Read | 17baf5da |
| Mandala/MandalaVeil.swift | 478 | 1–478 | Read | 93f1c790 |
| Mandala/MandalaVoice.swift | 302 | 1–302 | Read | ff69be53 |
| Mandala/MandalaWorld.swift | 108 | 1–108 | Read | db4ad498 |
| Mandala/RingGlyph.swift | 123 | 1–123 | Read | 21ff9f82 |
| Mandala/SignificanceCard.swift | 133 | 1–133 | Read | 05527e5d |
| Mandala/SriYantraGeometry.swift | 252 | 1–252 | Read | 5e9ba7c6 |
| Mandala/StillnessAtTheCentre.swift | 207 | 1–207 | Read | 8f3388e3 |
| Mandala/TheCentre.swift | 664 | 1–664 | Read | 0179728e |
| Mandala/TheEightDissolutions.swift | 318 | 1–318 | Read | 112bf5f5 |
| Mandala/TimeVariant.swift | 340 | 1–340 | Read | e8073b00 |
| Mandala/TreeOfLifeRingLayer.swift | 294 | 1–294 | Read | ac66d055 |
| Mandala/WaysIn.swift | 184 | 1–184 | Read | 5f643cd2 |
| Today/DailyRiteView.swift | 514 | 1–514 | Read | cd1d982d |
| Today/DustMotesView.swift | 154 | 1–154 | Read | 06be44f2 |
| Today/MoonPhaseView.swift | 45 | 1–45 | Read | 679dc017 |
| Today/NityaDetailView.swift | 127 | 1–127 | Read | 8fa9e3b5 |
| Today/RiteDayLayer.swift | 462 | 1–462 | Read | 4e9d7a5b |
| Today/RiteOpeningView.swift | 366 | 1–366 | Read | 1efcb4bc |
| Today/TheBells.swift | 58 | 1–58 | Read | ea258a23 |
| Today/Rite/RiteBlockView.swift | 154 | 1–154 | Read | ae94f331 |
| Today/Rite/RiteComposition.swift | 87 | 1–87 | Read | dba58b9b |
| Today/Rite/RiteContent.swift | 78 | 1–78 | Read | f5f3b3a7 |
| Today/Rite/RiteSigil.swift | 250 | 1–250 | Read | 9c4d6ee5 |
| Today/Rite/RiteSigilPlacement.swift | 65 | 1–65 | Read | 4835a9e2 |
| Recognition/RecognitionLight.swift | 513 | 1–513 | Read | 0ba0c807 |
| Recognition/RecognitionMomentView.swift | 502 | 1–502 | Read | 48eb77b4 |
| Recognition/RecognitionNature.swift | 282 | 1–282 | Read | 8ec7ef6c |
| Chakra/ChakraMovementPractice.swift | 756 | 1–756 | Read | 5316afe5 |
| Chakra/ChakraRoomDoor.swift | 145 | 1–145 | Read | 62bad8a6 |
| Chakra/ChakraRoomView.swift | 797 | 1–797 | Read | 718bac66 |
| Chakra/ClimbBodyChakras.swift | 95 | 1–95 | Read | 6b82b6ca |
| **Swift total (46 files)** | **12,871** | **all** | | |
| waves/register/03-mandala-worlds-layers.md | 995 | 1–995 | Read, 5 ranges | de0c0687 |
| waves/register/02-rite-axis-field.md (§A2) | 1673 | 309–1067 (§A2 in full), plus a heading index | Read, 2 ranges | c9cb6e9b |

Nothing assigned was left unread. The rest of 02 (§A1, §A3–§D) was not in this assignment.
