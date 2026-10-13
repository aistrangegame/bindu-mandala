# Beneath · The Relationship Field — world design (stage 2)

*Upgrade map, 13 Oct 2026. Slices read in full: `index/by-world/beneath.jsonl` (177 rows) and `index/by-world/relationship.jsonl` (218 rows; 4 rows are in both, so 391 unique ids). Thin rows were opened at their register lines (03:684-693, 03:810-863, 05:3030-3080, 06:1896-1905, 11:75-116, 11:286-310, 11:410-465, 11:575-624, 16:5, 16:47, 16:132-134, 16:194, 16:294-296, 16:337-339). Code refs were checked against `iOS/Bindu Mandala/` at commit 8067d8b.*

Two worlds are in this file. **Beneath** is what lies under the ground of every world. **The Relationship Field** is the outer Saṅgha given its own world. They share one law: nothing he lays down is kept, nothing about him is counted, and the people in the Field and the words he gives Beneath stay on his device and in his own ledger.

Abbreviations: `G14` etc. are padakarshini gestures (`11-padakarshini-forms.md:286-310`). `REL-1…6` are Design's six relationship instruments (`03-mandala-worlds-layers.md:810-863`). `kp` is her position, 1–102. "(set here)" marks a number this map sets because no source gives one.

---

# PART ONE · BENEATH

## B1 · The world

### B1.1 What it is

**In his words and Design's.** The Foundation puts it *"Under the ground: the Well, letters (A3), witness, Shadow Translator. S15 Mirror, G14 descent"* (`foundation/FOUNDATION-2026-10-12.md:16`). The code readers found that **no Beneath place exists**: the pieces are scattered. The Well is a list off the hamburger, the witness page sits on her Detail, the descent film is in Settings, the book has a "go down" door that leads nowhere underground, and the Shadow Translator is a Play game (G6-0916, G7-0591). Design's form for it is padakarshini **A2, the Mirror walk: "a walk under the floor"**. Its recognition line is *"I am under the floor now; nothing here is asked of me but to look."* (S15, `13-rupakarshini.md:130`). The descent's standing rule is *"Reference matter is never deleted — it becomes the floor of the descent."* (`01-homes.md:769-770`).

His own law for low days is **C-1002**, and it governs this world: *"When I'm angry I don't want to hear that I'll be ok. When I'm low, I don't want to hear that everything will be just fine. In these moments, I feel reflection becomes your worst enemy … So today morning I simply jumped in the app and just started reading everything I've added in the app, about my identity habits, my WhY's, my goals, my routines, my focuses, my codex everything. I simply started writing them down in the book"* (`07-codex.md:45-48`). Two more entries shape the deep end. **C-1120**: *"this space that gets created in between where it's almost like I end up being in this like void space where I am intensely creative … use that void space where I can realign reality"* (`07-codex.md:285-288`). **C-1313**: *"the absorption of the darkness at the core is what allows the light on the outside to flourish … when you go to the center of the black hole … you see there's nothing there"* (`07-codex.md:870-873`).

**What it is, as built.** Beneath is **one descending shaft**. Seven strata of near-black ground warm toward a single ember at the bottom. Each stratum holds chambers, and each chamber is its own space, entered by zooming into its light:

1. **The surface**: still water, leaves, and the low-state door (his own words). When he enters from her room, **her shaft** (five stations) and **the floor of her** come first.
2. **The Mirror**: the sky of walks, his vows, the Sanctuary mirror, the breath field, the Body as Scripture.
3. **The Gates**: the seven gates of release, the Shadow Translator (the DISTANCE figure, then the coin), the erosion.
4. **The Witness**: his witness pages, Sakshi's unlocks, the descent film.
5. **The small door**: the Child Space.
6. **The road**: the practices as stations on a road, and the long sits (In Shadow, Kingdom, the storm floor of Thunderclouds).
7. **The dark**: the eyelids that open on the inhale, the Still Point, map-and-no-map, the darkness at the core, the subtractive silence. Below it is the fall that never lands.

### B1.2 Arriving — the hold that resists, then gives

- **From anywhere:** a **two-finger press-and-hold** anywhere in any world (movement < 10 pt, so it never collides with pinch or pan). The veil rises under his fingers. **At 1250 ms the floor gives.** If he releases early, the hold drains and is refused with nothing said (G0 hold engine: commit on threshold, drain on early release). This is G14 (`11:288`, G4-0738).
- **Other doors that start the same crossing:** a one-finger hold on Beneath's point in the menu constellation. A tap on a **dark tile** wherever a world has something beneath it (her room, the Well's page, the Archive book's middle page "go down"). The low-state word on Today.
- **The passage** (2.35 s, `cubic-bezier(0.66,0,0.24,1)`; G5-0113):
  - The lit page lifts `0 → −104%` between 9% and 55% of the time.
  - The dark plane wells `104% → 0`. Its ground is radial(120% 90% at 50% 46%, `#14100A`, `#0A0806` 55%, `#060402`) with a warm horizon linear(180°, `rgba(243,176,90,.16)` 0, `rgba(218,59,18,.05)` 5%, transparent 13%).
  - The ember (11 pt; seed radial `#FFFCF4`, `#F7C478` 46%, `#DA3B12`) fades in by 13%. It scales .45 → 1 at 13%, → 1.18 at 55%, → 1 at 76%, → .7.
  - A ~4% seam between the planes shows the real destination.
  - Haptic: intensity .9, sharpness .15, at 55%.
- **Sound of the passage:** 110 Hz plus a +6 ¢ twin (110.38 Hz) plus a fifth at 164.81 Hz, gain .13. It peaks at ~0.8 s and is gone by 1.25 s.
- **When the full passage plays:** the first descent ever, and every true threshold (the first descent of a local day, or entering from her room). Otherwise the everyday dark veil plays (1.5 s).
- **Reduced motion:** the same 1250 ms hold, then a 0.3 s fade.
- **The first descent ever** also shows *"dark room · full screen · unhurried"* at 2.6 s, a breath ring at 2.8 s and the hint at 3.6 s (G5-0613).
- **He lands on the surface,** at the stratum where he last was if he has been here this day ("restore quietly, never past the furthest step actually reached"; G4-0776).

### B1.3 Being there — the shaft

- **Movement.** A vertical drag descends. The shaft is a paged vertical corridor: each stratum is one full-height step that snaps with `scroll-snap-stop: always`, and pieces arrive with opacity 1.1 s and transform 1.3 s `cubic-bezier(.16,1,.3,1)` from scale .86 (inward). The current step is the one whose centre is nearest the viewport centre, throttled at 80 ms and never gated on a frame callback. It idles when the scene is not active. There is no "i / N" count (no-counts floor). Source: G4-0776, G5-0010.
- **Four constants that never reset** (XMB-02, SH-01/02; G2-0218, G2-0304):
  1. **The ember anchor:** the ember stays at x 50%, y 78% through the whole shaft.
  2. **One pulse:** the ember breathes, and the breath slows the deeper he goes — 4 s at the surface, 6 s at stratum 6, still at the Still Point (DA1-13, G2-0127).
  3. **Sound as glissando:** a falling minor third per stratum crossed, 2.4 s (TheBuilding `Glissando`, G6-0968).
  4. **The depth-trail:** a 1 pt line from the top of the shaft to the ember. The part he has walked is drawn at .30, the rest at .06.
- **Three depth layers at different speeds:** far dust motes ×0.5, chamber lights ×1.0, near stratum edges ×1.6. Geometry swells past the frame as he passes.
- **Holdable velocity:** a still finger on the lower third keeps falling, its speed rising from 0 to 1 screen/s over 3 s (set here).
- **Ground temperature.** Fifteen near-black temperatures, top to bottom, interpolated in OKLab by scroll position, inward warming to the point (G5-0496, G5-0526):
  - Strata 1–3: `#0A0A0C · #09090E · #0C0904 · #07090E · #080808 · #0C0A07`
  - Stratum 4: `#0E0B09 · #0A0A0C` (threshold)
  - Strata 5–7: `#0A0A0C · #09090E · #0D0907 · #080A0E · #090B09 · #0C0A08 · #0F0B09`
  - Ground grain: 2% fractal noise.
- **The creative void** (C-1120). Between strata a band of 40% viewport height carries nothing but ground and the trail.
- **Chamber lights.** Chambers stand as lights on the trail, like the sky of walks: waiting lights violet `oklch(.62 .09 300)`, visited lights warm `oklch(.92 .08 90)`, each breathing on a staggered 3.2–6.2 s. A tap zooms into the light (scale 7, 1.15 s) and the chamber fills the screen as its own space.
- **His touch lights the dark.** A 320 pt soft radial `rgba(245,226,214,.055)` with screen blend follows the finger (lerp .12) and fades 0.6 s after he lifts (G5-0641).
- **The ground's heartbeat.** A 72 BPM pulse at 0.5% brightness, which never stops while he is beneath (Voice II's heartbeat, mechanism only; G3-0237).
- **The wandering point.** After 20 s idle (set here) a 9 pt point drifts by sum-of-sines (`x = sin(t·.3)·.6 + cos(t·.17)·.4 + sin(t·.53+1.2)·.3`, `y = cos(t·.23)·.5 + sin(t·.41+.7)·.35`). Its halo pulses 3.2–4 s and it scales 1.08 every 3.4 s. It cannot be caught: *"Presence, not target."* (G5-0140).

### B1.4 Sound of Beneath

- **The Om is always playing** (G5-0690, TreeOfLife `omHz`; G6-0829). It is 136.1 Hz with partials 272.2 at .30 and 68.05 at .15, and a master LFO of 0.05 Hz ±0.008. The floor gain is `0.004 + 0.026·d`, where d = depth through the shaft, 0 to 1. *"The crescendo is noise decreasing, not volume increasing."*
- **Pink noise** (OL-1, 7-coefficient, low-pass 4 kHz; G4-0165) sits at gain .015 at the surface and falls to .002 at the Still Point.
- **The chime ladder** (G5-0135). Crossing into stratum k = 1…7 strikes a Pythagorean chime on 256: 256, 288, 324, 384, 432, 486, 512 Hz. Each rises in .4 s and is gone by 2.9 s. Rising back out strikes them descending and ends on 136 Hz.
- **Binaural** 100 / 107 Hz at gain .03, within the film rule's .036–.040 ceiling (G4-0582). In stratum 7 the right carrier glides over 20 s to 102.69 Hz, a 2.69 Hz beat: *"the fingerprint awakening leaves"* (G4-0588). This is the only place in the app outside the Home deep zoom where 2.69 is designed.
- **The subtractive silence** at the bottom (G4-0395). Every tone ramps to zero over 0.35 s, stays silent until 1.5 s from the start, and ramps back whole over 0.35 s: *"the ground can vanish and nothing falls."*
- **Beneath the bottom: the Shepard fall** (G5-0416, G6-0875). K = 7 sines from fMin 32.7 Hz; rate `.05 + .10·intensity` oct/s; amplitude `exp(−((phase−.5)/.26)²)·.42`; master `.07·intensity`; intensity = held fall velocity. The strata wrap endlessly: *a fall that never lands.*
- **Engine.** Everything runs through `SoundConductor` with a new `.beneath` voice that claims the bed. It reuses `RingAudioService`'s Om (348–377), Shepard voice (420–437) and glide (410–416). No song drone plays unless a long sit or the storm floor is open (settled point: "a song's drone plays only during its dance").

### B1.5 The chambers, stratum by stratum

**Stratum 1 · The surface**

- **Still water** (practice--stillness WATER; G4-0807, G5-0267).
  - The surface settles from ripples to stillness: `calm` 0 → 1, rising 1/20 per second while untouched (set here) and dropping to 0 on touch.
  - Ripple opacity is `1 − calm·.85`; ripple period is `4 + calm·14` s. A touch makes a ripple ring that lasts 2.6 s.
  - He may type a thought. It rides a leaf for 13 s off the page and is **never kept**. Ambient leaves pass every 11 s.
  - One line, verbatim: *"You are the one on the bank."*
  - The Learning topic "6.6 Mindful Exercise: Leaves on a Stream" (L-1067) is this practice; its title is shown verbatim when he long-presses the water.
- **The low-state door** (C-1002; existing `LowStateDoor`).
  - A quiet word sits at the water's edge: `LowStateDoor.doorWords`. A tap opens a chamber of **his own words only**, one line at a time, rotated by day, 12–240 characters per line.
  - Sources: margin notes; the Well's letters; readable river letters (a sealed letter stays sealed); his witness pages; **and, new**, his Identity Declarations, Values and Mantras (Identity table, Declaration `fldry3UX62Eedqb9F`) and sentences from his Codex. These are the "identity habits, my WhY's … my codex" he named.
  - Each line is read by holding (G1; B42).
  - Beneath each line is a blank ruled line where he may **write it again by hand** (finger or Pencil). The ink fades after 8 s and is never stored. This is C-1002's "writing them down in the book".
  - **While this door has been opened, every chamber that asks a question is quiet for the rest of the visit:** the Mirror walk's question, the gates' questions and the small door's question all stand as lights without asking. No reassurance line appears anywhere.
  - The empty state, verbatim: *"When you have written, your words will wait here for you."*

**When entered from her room (kp context): her shaft and the floor of her** (above stratum 1)

- **Her shaft — five stations** (TheDescent, HomeDescent; G7-0320, G7-0982, G7-0694, G6-1067).
  - Stations sit at Z −16, −34, −52, −70, −88. There are 46 rims at depth `−8 − i·2.2`, radius `5.4·.985^i`. Light is .05 + near ×.34.
  - **DescentWords** come from her five fields — tattva, bodilyLocation, etymology, quality, appreciationPhrase. An empty field is never invented.
  - The glissando falls a minor third per station. The prompts are only *"touch to go deeper"* and *"touch to go on"*.
  - **All five stations are offered from the first visit**: the gating `DescentReach.shallow` (3 of 5 until 62 s) is lifted (G7-1033).
  - **Design's station objects return** (C6): a torus knot, body bars with hers alight, root sprites joining into one word, an icosahedron and phrase tori.
- **The floor of her** (G1-0453, G1-0007, G1-0087, G1-0323).
  - After the fifth station an overlay `rgba(3,1,2,.9)` falls in 900 ms. The title is *"the floor of her"*.
  - Her reference rows are **revealed one per beat**, never as a page (ruling 17). Word timing is ~250 ms a word, +430 ms at a full stop, +180 ms at a comma, each word sharpening from a 4 px blur.
  - Rows, in order, empty ones omitted: Āvaraṇa (`{ord} — {name}`) · Her seat (the bhūpura / a lotus petal / the bindu / a triangle) · Bodily location · Bīja (world; only if known) · Śakti family · Gem · dhātu · Clock · Quality · Esoteric tattva · Etymology (roots joined " + ") · Inscription · Devanāgarī · Presiding form · Altitude · Yoginī class · Mental state · Verb · Function · Somatic signature · Iconography.
  - Last, an **outside door** to her chakra's or ring's web page (Map URL `fld5wkzZkM30kmeyU`; enclosure and vertebra pages; G6-0482, G6-0750).
  - The control *"rise back into her room"* plus the rise chevron at top 50, left 6. `ShaktiDetailView`'s sections become this floor and nothing is deleted. The orphaned `RiteLibrary` sheet is retired (G1-0454).

**Stratum 2 · The Mirror**

- **The sky of walks and the Mirror walk** (A2 / S15; G4-0676; cross-ref G5-0222, G5-0447).
  - Each walk is a light in the stratum's sky. Walked walks are warm `#F9E3A7`, waiting walks violet. A tap zooms in (scale 7, 1.15 s).
  - **The walk:**
    1. **Door.** A held threshold of 1.25 s; an early release refuses. The gates fill +0.075 per 55 ms.
    2. **Arrival.** Three first-person lines.
    3. **Three teachings,** word by word, with a hold between each. The figure deepens +0.011 per 80 ms to depths **.32 / .60 / .85** (or the walk's Depth 1–3).
    4. **"look"**
    5. **One question with a field.** It can be skipped, and then it becomes *"the unnamed"*.
    6. **The glass** returns his word with one reflection (a held gate).
    7. **The vow,** offered in the second person (Vow You) and **carved in the first (Vow I)** by a ~2 s hold (G32: +0.05 per 110 ms; an early release drains).
    8. **The walk out.** The figure completes, light floods over 1.4 s, and *"the sky receives you, one star warmer."*
  - Ground `#0E0C14 → #07060C`. **The typeface changes at the crossing** to Newsreader 300 italic.
  - Sound only while holding: the walk's Root Hz (default 110) and Beat Hz (default 3.5).
  - A walk may be walked at once or **"let it grow"**: the next part opens at 2 h, 8 h, 24 h and 72 h (walk--growing, G4-0700). He chooses; nothing is locked.
  - Content is read-only from **Walks** (`tblJ2sg5ubhN5CH5M`, 20 Live Walk rows). The 3 private Entry rows are never read.
  - **No person is ever attached** (table law, 16:134).
- **His vows** (G5-0411). Every carved vow stays on dark glass in this stratum, marked ● *"a vow · arrived"* or ○ *"still living"*, with a terra `#C47A52` glow. He may redraw a vow's mark once a day.
- **The Sanctuary mirror** (G22; G4-0746; B.5.10 words, 05:3078).
  - The front camera is mirrored and dimmed (brightness .8) inside a 1 px silver ring `#C8CCD8` that fills over 60 s.
  - Whispers, verbatim: *"find your eyes"* at the start and *"stay"* at 30 s. At the end, *"What did you see?"*: his one word, released and stored nowhere.
  - The closing line *"you were here"* has letter-spacing closing from .2em to .04em.
  - With no camera, the ring fills over dark for 60 s with the same words (the no-camera path is complete).
  - The generated sentence is refused (no generated voice).
- **The breath field** (Sanctuary FieldView; G2-0896).
  - Breath 4-4-6 × 3 cycles: a circle r 46 → 110 on the inhale (4 s), held 4 s, out over 6 s.
  - The safe-place practices hang here as named lights, titles verbatim from Learning: "3.3 Safe Place Exercise Introduction" L-1021 · "3.3 Safe Place Exercise" L-1022 · "Bonus: Safe place (with background and music)" L-1203 · "Bonus: Safe Place (with background, no music)" L-1204 · "Bonus: Safe Place Exercise Without Music" L-1205 · "Bonus: Safe Place Exercise" L-1206 · "Bonus: Stream Of Light Exercise" L-1207 · "Happy Place Meditation: Relax and Fall Asleep Faster" L-1056 · "6.1 Simple Mindfulness" L-1062.
  - Each opens the breath field under its title. Course body text is never copied (Therapy content; 16:239-246).
  - "84 hearts in the field" is refused (simulated presence floor).
- **The Body as Scripture** (G40; G2-0897, G4-0764, G5-0216).
  - A one-line body figure with seven points. The regions are crown, brow, throat, heart, hands, belly, sacrum, base and legs; anchors reuse `SomaticRegion` (18+ regions).
  - A tap on a region opens a screen in that region's colour asking for a quality — tightness, warmth, ache, tingling, numbness, heaviness, lightness or hollowness — plus **one word of his**.
  - Region · quality · his word is one verse of **"The Book of the Body"** (at most 108).
  - The Body Map keeps three inks — alive, tight, absent — with past sessions faint under today's.
  - The generated verses are refused; his word is the verse. This matches `worlds/game.md` §7.7.

**Stratum 3 · The Gates**

- **The seven gates of release** (A4; G4-0678, G26, G33, G5-0207, G5-0431; content from Release/Seven Gates, 06:1902-1905, 05:3085-3088).
  - Seven arches stand down one line, Crown → Root.
  - **Arch states:** a hairline gradient across the seven chakra colours. **Only the next arch is lit**, its opacity flickering .85–1 at 6–10 Hz. Passed arches keep an outline and an inner glow with *"· passed ·"*. The rest wait faintly.
  - **At each gate** a whisper, then a card. The cards in order: *a certainty / a self-picture / a story / a protection / an effort / a borrowed desire / the grip itself*.
  - He writes the thing, if he wants, in the field.
  - **Set it down** by holding 2600 ms (G33). The words sink, starting after 0.2 s and lasting 1.7 s: opacity 1 → 0, translateY 0 → 34 px, scale 1 → .9, blur 0 → 2 px.
  - Or **drag it**: past 90 px down it is set down (falls 420 px, scale .8, 1.1 s); past 90 px up it is kept (rises 320 px, .8 s) — *"That's allowed."* While dragging, the card tilts `dy/40`° and fades `1 − min(.6, |dy|/400)`.
  - The gate then reads *"· passed ·"* with the first of his words in small italic, **in this visit only. A laid-down word is stored nowhere**, not even in the ledger.
  - The ground darkens one OKLCH L step (−.012) per gate.
  - **The return rises,** lightening a step per gate. At each gate one gift rises to be tapped, verbatim, Root → Crown: *steadiness, in your feet; warmth, in your belly; a breath that needs nothing; an open hand; a true word, in your throat; clear sight, behind the eyes; space, above the head.* The words he kept rise with them.
  - Bells at **440 + 40·k Hz** (k = 0…6).
  - Progress is kept between visits and nothing is locked.
- **The Shadow Translator** (teaching--skill DISTANCE; G4-0813; plus the existing coin, `ShadowTranslatorModel`, PlayGamesWords.swift:19).
  - On arrival the figure plays itself once, at 2.2 s per stage, with the variant's own sample line.
  - Then he types a charged line and it moves away from "you" in three stages:
    1. `{t}`: gap 4 px, type 26–34 pt, ink 1.
    2. *"I'm having the thought that {t}"*: gap 26–56, type 19–24, ink .86.
    3. *"I notice I'm having the thought that {t}"*: gap 48–110, type 16.5–20, ink .74.
  - The capitalisation rule for names applies. *"Nothing you type is stored or sent anywhere."*
  - Then **the coin**: the burden word gives `1 + letterSum % 10`, one of the ten Siddhi Śaktis (kp 1–10). He turns the coin by circling, and its back shows her name and Appreciation Phrase. A tap crosses to her presence.
  - The model is shared with A Strange Game (`worlds/game.md` E57). This is the same space with two doors, and Beneath is the door "in shadow".
- **The erosion** (Atlantis build–hold–erode; G5-0592).
  - A word he gives builds character by character at 40 ms, holds 3 s, then erodes over 10 s. The erosion is weighted so longer words lose characters first.
  - A fallen character fades over 0.8 s and moves over 1.2 s (translateY + rotate). Type 36 pt.
  - *"hold to witness"* breathes with a 2.5 s gold text-shadow. Haptic 50 ms per falling character, at most one per 200 ms.
  - Sound: a 68 Hz sine with overtones 136.1 · 204.15 · 272.2 Hz added during the build, all of them during the hold, stripped in reverse to 68 Hz, then silence.
  - Its source text goes to Bindu Feed.

**Stratum 4 · The Witness**

- **His witness pages** (G7-0555; `HerWitnessPage` opened view reused).
  - Every page he has written beside her (ledger *Witness Written*, his words in Notes) hangs as a **sealed envelope light** at the height of her ring.
  - Hold 1.8 s to open: her Function / description, with his perspective beside it. It **reseals on leaving**.
- **Sakshi's unlocks** (G6-0760). When a chakra's gate has been walked, its Witness Perspective (Gaia table, Type Witness Perspective, Unlock Trigger) appears as one new sealed light showing **its first line only**. The full body is a door to Bindu Feed (story).
- *"Who is saying that?"* (C-1305) appears once, after 7 s of stillness in this chamber (G7-0963).
- **The descent film** (G7-0541).
  - *"The descent, remembered"*: one frame per ring crossed — RingGlyph 96 gold, Sanskrit name, subtitle, *"the way opened · {date}"*.
  - 4.5 s per frame; a tap advances. Ring 1 is *"the ground"*, ring 2 *"home"*.
  - **Fix:** dates come from the ledger's *Ring Crossed* rows for every ring, including 1 and 2 (today `DescentFilmView.swift:35-38` assumes ring = 3 + i; G7-0542).
  - Reached here, from the book's middle page (which crosses into Beneath at this chamber) and from the old Settings line, which becomes a door here.

**Stratum 5 · The small door** (Child Space; G34, G2-0898, G4-0758; shared with `worlds/game.md` E88)

- **The door.** Hold 2800 ms (+50/2800 every 50 ms). The words shrink toward 55% and the door warms from amber `#C47820` to `#F8D870`. It opens after 1.4 s.
- **The words, verbatim:** *"This door is small."* on the door; *"Welcome."* the first time; *"Welcome back. You remembered how."* after (Child Space's own line; G34's shorter "Welcome back." yields to it).
- **Inside:**
  - **One of the 20 questions,** in daily rotation (Child Space.html). He answers in his own word, kept in the Child Space store and the ledger.
  - **A letter from the child**, which he writes.
  - **A promise**, using the source's starters verbatim.
  - **Play with no goal:** a drone of 110 + 220 Hz; every touch makes something and a sound; there is no end.
- The generated reflection and the child voice are refused.
- Room 28 Innocence keeps its own form (the-33); a door joins the two.

**Stratum 6 · The road**

- **The road beneath** (map--path PATH; G4-0798, G5-0263, G5-0312).
  - The road is drawn faint in full; the walked part draws in; the end **runs off the edge** — *"a road does not stop where the map does."*
  - Stations sit on S-curves. Segments draw by dashoffset over 1.6 s; the live station has a ring of r 22; a tap opens a station.
  - The stations are the Beneath practices, titles verbatim from Learning: The Bardo Thodol · Phowa · Maranasati · Tibetan Chöd · Dzogchen · Mahamudra · Vipassana · Tonglen · fire kasina.
  - A station's body is shown **only where authored and attributed**; otherwise the PATH figure stands alone with the title.
  - **Play:** a hold lets the tide rise to 18% over 2.6 s and wait. Letting go, it falls over 8 s — *"a long exhale, untaught."*
  - The grace line, verbatim: *"It was never written for the dead alone. It is practice for the living, told as a road."*
- **The long sit — In Shadow** (G4-0451, G4-0582; `bindu/in_shadow.mp3`, 780 s).
  - **Score:** carrier D3 146.8 Hz, deeply absent (presence .15). Shadow theta 3–3.5 Hz, then a 2.5 Hz delta at the awakening (540–725 s). Binaural gain no higher than .040 (*"The film leads. The binaural completes."*). The drone ends at .008; tremolo .12 / .11. Sakshi-led.
  - **Seed:** *"The witness was never inside what it was watching."*, once at the start.
  - **Visual — the depth field** (G4-0585):
    - The background darkens with the brainwave depth.
    - The carrier thread is a sine wave oscillating at the beat rate.
    - 55 particles follow smoothEnergy.
    - A central bloom, and an 18-particle burst at each phase transition.
    - A descending depth dot.
  - **The silences:**
    - **Silence honoured** (G4-0274): when E < floor, the dot alone and the carrier alone.
    - **The longest silence** gets a visible, felt 50 bpm pulse (G4-0478).
  - **Panning:** left carrier = iḍā, right = piṅgalā, beat = suṣumnā (G4-0572; this is how binaural is wired, and it is never labelled).
- **The long sit — Kingdom** (G4-0219, G4-0452; `bindu/kingdom.mp3`, 835 s). The carrier and beat follow the **scored file** (110 Hz / 5.5 θ; 09:712); the 146.8 "absent root" in `BF/songs/kingdom.md` is the story file's reading. It holds the 55 s drone that does not fade. One word: *"Sovereign"*. Seed: *"The throne at the center of every kingdom is empty."* The Home deep zoom also uses Kingdom as its bed (home world).
- **The storm floor — Thunderclouds** (G4-0388, 0394, 0396, 0397, 0456, 0390; `bindu/play.mp3`).
  - **Metaphor:** weather-v1. Palette: hue 258, saturation 12–28; the strike 268, saturation 70–95; the ground 40. **No rainbow anywhere.**
  - **The arc:** no ground for 0–47.5 s, the ground arriving whole, and the ground vanishing at the brightest instant (the flash-void, 138–155 s: near-white canvas, everything else near-zero alpha) — *and nothing falls.*
  - **Binaural:**
    - Carrier B2 123.5 Hz, presence .68.
    - Beat schedule 8.5 · 8 · 7 · 6.5 · 7.5 · 5.5 · *null* (carrier void) · 4.0 at Nothing Fell · 4.5 · 5.5 · 6.5 → 9 · 10.
    - Carrier dropout from 140.0 s: both oscillators ramp to zero over .35 s, stay silent to 141.15 and are back by 141.5.
    - Gain ×1.15 for 0–47.5, ×1.25 for 141.5–155, ×.8 after 191.
  - **Seed (his):** *"What are you afraid of that will never pass?"* — "Do not clarify this seed." The fruit uses `{word}` verbatim.
  - **Haptics:** `the_strike` [8,20,8,400]; `charge_pulse` [25] at 46 bpm over 0–47.5; `thunder_roll` [30,40,50,40,30] after 141.5; `mirror` [8].
  - **Karishma glows in the groundlessness** (1 − EB).
  - It is rendered by the Bindu Field dance engine (the-33's renderer, reused).

**Stratum 7 · The dark**

- **Eyelids that open only on the inhale** (G5-0070). After ≈12 s of stillness the room opens: `eyeOpen += dt/28` only while still **and** inhaling (BreathClock phase). The lids are `#08070B` with an 18% soft edge and blink every 18–40 s.
- **The Still Point** (G10; G5-0116, G5-0357). Five stages of ≈1.3 s. Each stage removes framing — chevron, trail, motes, temperature, the line — while type grows 18 → 25 → 29 → 33 → 41 pt. Haptics go .25 → .15 → none, until only the ember breathes. *"Surface"* is always there.
- **Map and no map** (Anatta; G5-0313, G5-1131). The whole shaft — every stratum, light and trail — is drawn once, faint, over 3 s, then erased over 6 s, leaving the ember. There are no words; Maya's *"only You, playing"* stays room 30's (ruling 8).
- **The darkness at the core** (C-1313). After the erasure the ember's centre turns dark: a 4 pt black core inside its light, which flourishes 1.0 → 1.15 as the core absorbs. **The subtractive silence plays here.**
- **Below:** a held drag continues into the endless Shepard fall.

### B1.6 Leaving

- **Rising:**
  - The rise chevron (top 50, left 6) and the point (top centre, home) are always present.
  - A swipe up on the surface rises.
  - Surfacing is the reverse veil, .95 s.
  - The chime ladder descends and ends on 136 Hz.
- **Out to another world:** the old bed **holds at gain .004 for ~3 s** while the next world fades in — *"The seam is a phase, not a gap."* (G4-0581, G4-0269).
- **Back to exactly where he was** before the two-finger hold (spine law).

### B1.7 Visual language and type

- **Chassis:** blink (temperatures warming toward the point) plus learning dark (G5-0526).
  - **Ground:** the fifteen temperatures above.
  - **Ink and ember:** cream ink `#DBD5CC` (88%), ink-2 `#807E79`. Ember `#7A2F14`, lit `#94472C`; gold answer `#C8A96E`.
  - **Learning dark** inside the chambers: `#0A0806` / `#14100A`, ink `#F4ECDA`, ember `#DD3E16` (4.54:1), gold `#F3B05A`, deep `#060402`.
  - **The Mirror stratum** wears lalita "under": `#0E0C14` / `#07060C`, ink-2 `#B9B2C9`, tempo 1200 ms.
- **Type:**
  - Lora for body text at the crossing.
  - DM Sans 9 pt caps, tracked 3–4 pt, for kickers.
  - Newsreader 300 italic inside the Mirror walk.
  - Her names in the house Cormorant (bundled).
  - Lora, DM Sans and Newsreader are new bundled fonts (OFL).
- **Contrast law** (G4-0778): text tint = OKLab mix(accent 50%, `#191919`) per ground; worst case 5.39:1. Chrome over a figure ground is solid ink, never alpha.

## B2 · Every element, placed

| # | element | what it does (mechanism + numbers) | source | status today (code) | reuse / move / new |
|---|---|---|---|---|---|
| B01 | The Descent crossing | two-finger hold anywhere; 1250 ms resists then gives; early release refused silently; passage 2.35 s cubic(.66,0,.24,1); page 0→−104% (9–55%); dark 104%→0; ember 11 pt .45→1→1.18@55%→1@76%→.7; ~4% seam; 110 + 110.38 + 164.81 Hz gain .13 peak .8 s gone 1.25 s; haptic .9/.15 at 55%; full passage first ever + first of the day + from her room, else dark veil 1.5 s; reduced motion 1250 ms then .3 s fade | G4-0738, G5-0113 · 11:288, 12:406, 13:154-158 | not built | **new** `BeneathCrossing` (root overlay, 2-touch long-press) |
| B02 | Dark tile on a lit page | `#0A0806→#14100A` tile with the chamber's figure at 8%; tap = Descent the first time, dark veil after; on her room, the Well's page, the Archive book's middle page | G5-0114, G5-0357 · 12:405, 13:167-168 | not built | new |
| B03 | First-descent guidance line | "dark room · full screen · unhurried" at 2.6 s, breath ring 2.8 s, hint 3.6 s — first descent ever only | G5-0613 · 14:511 | not built | new (verbatim) |
| B04 | The ground's heartbeat | 72 BPM pulse at 0.5% brightness, never stops while beneath | G3-0237 (mechanism) · 06:1794-1801 | not built | new |
| B05 | The shaft (corridor) | vertical paged corridor, one stratum per step, snap stop always; pieces opacity 1.1 s / transform 1.3 s cubic(.16,1,.3,1) from scale .86; nearest-centre activation, 80 ms throttle, idles when not active; restores last stratum quietly, never past furthest; no "i/N" | G4-0776, G5-0010 · 11:338-350, 12:77-91 | not built | **new** `CorridorView` (paged ScrollView + scrollPosition) — shared with the 33 |
| B06 | Strata temperatures | 15 grounds in order (B1.3), OKLab interpolated by scroll, warming to `#0F0B09` at the point; 2% grain | G5-0496, G5-0526 · 13:668-673, 13:780 | not built | new tokens |
| B07 | Four constants + parallax | ember anchored x50% y78%; ember breath 4 s → 6 s → still; minor third per stratum 2.4 s; depth-trail 1 pt (.30 walked / .06 ahead); layers ×0.5 / ×1.0 / ×1.6; holdable velocity 0→1 screen/s over 3 s | G2-0218, G2-0304, G2-0127 · 04:344, 04:488-489, 04:208 | not built (`Glissando` built in TheBuilding) | reuse `Glissando`; new shaft camera |
| B08 | Touch lights the dark | 320 pt radial rgba(245,226,214,.055), screen blend, lerp .12, fades .6 s after lift | G5-0641 · 14:701-703 | not built | new (shared with the Well) |
| B09 | The wandering point | after 20 s idle; 9 pt radial(35% 35%, rgba(200,140,100,.6), #7A2F14 70%); sum-of-sines path; halo 3.2–4 s; self-pulse 3.4 s ×1.08; cannot be caught | G5-0140 · 14:648-659 | not built | new |
| B10 | Contrast law | OKLab mix(accent 50%, #191919); worst 5.39:1; chrome solid ink | G4-0778 · 11:351-352 | not built | new `readable(accent, ground)` helper |
| B11 | Rise and leaving | rise chevron top 50 left 6; point top centre; surfacing .95 s; descending chimes end on 136 Hz; bed held at .004 for ~3 s into the next world; back to exactly where he was | G1-0453, G4-0581, G4-0269, G5-0493 · 02:271-273, 10:268, 08:1209 | not built | new |
| B12 | Om bed + noise decreasing | 136.1 + 272.2@.30 + 68.05@.15; LFO .05 Hz ±.008; floor .004 + .026·d; pink noise 7-coef LP 4 kHz .015 → .002 by depth | G5-0690, G4-0165, G6-0829, G6-0814 · 14:958-961, 08:803, 17:548 | Om built (RingAudioService 348-377; TreeOfLife 159-169); noise not | reuse Om; new noise node; `SoundConductor` gains `.beneath` |
| B13 | Chime ladder + binaural + 2.69 | 256, 288, 324, 384, 432, 486, 512 Hz going down (rise .4 s, gone 2.9 s); reverse rising, ending 136 Hz; binaural 100/107 at .03; stratum 7 right carrier → 102.69 over 20 s | G5-0135, G4-0588, G4-0610 · 12:434, 13:421-423, 10:289, 10:296-297 | not built | new (BinauralEngine voice in `RingAudioService`) |
| B14 | Subtractive silence | all tone → 0 over .35 s, silent to 1.5 s, back whole over .35 s; at the darkness at the core | G4-0395 · 09:648 | not built | new (ramps; device-verify) |
| B15 | The fall that never lands | K 7, fMin 32.7 Hz, rate .05+.10·i, bell exp(−((p−.5)/.26)²)·.42, master .07·i; i = held fall velocity; strata wrap | G5-0416, G6-0875, G6-0893 · 13:379-380, 17:734 | built as voice (RingAudioService 420-437) | reuse; new visual wrap |
| B16 | The surface — water | calm 0→1 (+1/20 per s untouched); ripple opacity 1−calm·.85; period 4+calm·14 s; touch ring 2.6 s; typed thought rides a leaf 13 s, never kept; ambient leaf every 11 s; "You are the one on the bank."; L-1067 title on long-press | G4-0807, G5-0267, G5-0727 · 11:436-439, 12:635 | not built | new |
| B17 | The low-state door | his own words only, one line at a time, rotated by day, 12–240 chars; sources notes / Well letters / readable river letters / witness pages + Identity Declarations, Values, Mantras + Codex sentences; held reading; copy-by-hand line, ink fades 8 s, never stored; questions in every chamber quiet for the visit; empty state verbatim | G3-0328 (C-1002), G6-0884, G7-0126, G7-0998 · 07:45-48, 17:534, 19:427 | built on Today (`RiteOpenings.swift:210-263`, `RiteOpeningView.swift:258-366`) | **move** a door into Beneath (Today keeps its door); new Identity + Codex sources; new hand line; fix citation C-1120 → C-1002/C-1057 (`RiteOpenings.swift:24`) |
| B18 | The creative void | 40% viewport of bare ground between strata | G3-0376 (C-1120) · 07:285-288 | not built | new |
| B19 | Her shaft — five stations | Z −16/−34/−52/−70/−88; 46 rims at −8−i·2.2, r 5.4·.985^i; light .05 + near ×.34; DescentWords from her five fields, empty never invented; minor third per station; "touch to go deeper"/"touch to go on"; all five offered; Design's solids return | G7-0320, G7-0982, G7-0694, G6-1067, G7-1033 · 20:352-354, 22:256-260, 18:145, 22:646 | built (`Views/Rooms/TheDescent.swift`, HomeDescent) with shallow gating and no solids | **move** under Beneath (kp-keyed top); lift `DescentReach.shallow`; new SceneKit solids |
| B20 | The floor of her | overlay rgba(3,1,2,.9) 900 ms; "the floor of her"; rows one per beat (250 ms/word, +430 full stop, +180 comma, 4 px blur sharpen); 21 rows in order, empty omitted; outside door to the web page; "rise back into her room" | G1-0453, G1-0007, G1-0087, G1-0454, G1-0323, G6-0482, G6-0750 · 02:271-277, 01:7, 01:238, 01:769, 15:62, 16:301 | `ShaktiDetailView` exists as a page; RiteLibrary orphaned | **move** ShaktiDetailView sections here (nothing deleted); retire RiteLibrary; new beat reveal |
| B21 | Mirror walk + sky of walks | lights warm #F9E3A7 / violet, breathing 3.2–6.2 s; zoom scale 7, 1.15 s; door hold 1.25 s; gates +.075/55 ms; depths .32/.60/.85 at +.011/80 ms; word timing; question skippable → "the unnamed"; carve ~2 s (+.05/110 ms); light floods 1.4 s, "one star warmer"; Newsreader at the crossing; Root 110 / Beat 3.5 Hz only while holding; "let it grow" 2/8/24/72 h; Walks read-only, no person | G4-0676, G4-0700 · 11:75-80, 11:578, 16:134, 16:294 | not built | new; reads Walks |
| B22 | His vows | ● "a vow · arrived" / ○ "still living"; terra #C47A52 glow; one redraw a day | G5-0411 · 13:360, 12:325 | not built | new |
| B23 | Seven gates of release | seven arches Crown→Root; next lit, flicker .85–1 at 6–10 Hz; passed outline + "· passed ·"; seven cards verbatim; set down by hold 2600 ms (sink after .2 s over 1.7 s: opacity 1→0, y 0→34, scale →.9, blur →2 px) or drag ±90 px (down falls 420 px .8 scale 1.1 s / up rises 320 px .8 s; tilt dy/40°); laid-down words stored nowhere; ground −.012 L per gate; return gifts verbatim; bells 440+40·k; progress kept | G4-0678, G4-0750, G4-0757, G5-0207, G5-0431, G2-0375 · 11:88-92, 11:300, 11:307, 13:404-407, 06:1902-1905 | not built (Climb's `TheGates` is the nine-ring exchange) | new (shares hold engine with `TheGates`) |
| B24 | The Shadow Translator | DISTANCE: plays itself once (2.2 s/stage); his line through 3 stages (gap 4→26–56→48–110 px; type 26–34→19–24→16.5–20; ink 1→.86→.74); "Nothing you type is stored or sent anywhere."; then the coin: 1 + letterSum % 10 → Siddhi Śakti kp 1–10, circle to turn, back = name + Appreciation Phrase, tap → her presence | G4-0813 · 11:457-459; cross G7-0260 | coin built (`PlayGamesWords.swift:19`); DISTANCE not | reuse coin model; new DISTANCE figure; two doors (game E57) |
| B25 | The erosion | build 40 ms/char, hold 3 s, erode 10 s weighted to long words; fallen .8 s / 1.2 s; 36 pt; "hold to witness" 2.5 s gold breath; haptic 50 ms per char ≤1 per 200 ms; 68 Hz + 136.1 · 204.15 · 272.2 build → hold → strip to 68 → silence | G5-0592 · 14:385-393 | not built | new |
| B26 | The witness chamber | his witness pages as sealed envelope lights at her ring's height; hold 1.8 s opens, reseals on leaving; Sakshi unlocks show first line only (full → Feed); "Who is saying that?" once after 7 s still | G7-0555, G6-0760, G7-0963 · 21:53, 16:320, 22:571 | page built per Śakti (`HerWitnessPage.swift:64-214`); no chamber | reuse opened view; new chamber |
| B27 | The Sanctuary mirror | front camera mirrored, brightness .8, 1 px silver #C8CCD8 ring fills 60 s; "find your eyes" at 0 s / "stay" at 30 s; "What did you see?" (word released); "you were here", letter-spacing .2em → .04em; no-camera path dark 60 s | G4-0746 (G22), G2-0896 · 11:296, 05:3078 | web only | new (AVCaptureSession, never stored) |
| B28 | The breath field + safe-place lights | 4-4-6 × 3; circle r 46→110; nine Learning titles verbatim as lights; course text never copied; "84 hearts" refused | G2-0896, G5-0722, G5-0832, G5-0854, G5-0857, G5-0929, G5-1008, G5-1060, G5-1061, G5-1092 · 05:3035-3039, 12:1107-1477 | web only | new |
| B29 | The Body as Scripture | one-line figure, 7 points; 9 regions; region colour screen; 8 qualities + his one word = verse; Book of the Body ≤108; Body Map three inks, past faint under today | G4-0764 (cross), G2-0897 (cross), G5-0216 (cross) · 11:314, 05:3041-3043 | web only; `SomaticRegion` built | reuse SomaticRegion; new |
| B30 | The small door (Child Space) | hold 2800 ms, words → 55%, door warms #C47820→#F8D870, opens after 1.4 s; "This door is small." / "Welcome." / "Welcome back. You remembered how."; one of 20 questions a day, his answer kept; letter from the child; promise with starters; play with no goal 110 + 220 Hz | G2-0898 (cross), G4-0758 (cross), G5-0204 (cross) · 05:3045-3052, 11:308 | web only | new space shared with game E88 |
| B31 | The road beneath | PATH: faint in full, walked draws in, runs off the edge; S-curves, dashoffset 1.6 s, live ring r 22; nine practice stations, titles verbatim, body only if authored; hold → tide 18% over 2.6 s, release falls over 8 s; grace line verbatim | G4-0798, G5-0263, G5-0312, G5-1113, G5-1155, G5-1167, G5-1177, G5-1202, G5-1095 · 11:416, 12:635, 12:908 | not built | new |
| B32 | Long sit — In Shadow | in_shadow.mp3 780 s; 146.8 Hz presence .15; θ 3–3.5 → δ 2.5 at 540–725 s; gain ≤.040; drone end .008; tremolo .12/.11; seed verbatim; depth field (55 particles, 18-burst, thread = sine at beat); silence → dot + carrier; longest silence 50 bpm pulse | G4-0451, G4-0343, G4-0582, G4-0274, G4-0478, G4-0585, G4-0572 · 09:711, 09:199, 10:271, 08:1200, 09:695, 10:282 | not built (song not bundled) | reuse the Bindu Field dance renderer (the 33); new sit host |
| B33 | Long sit — Kingdom | kingdom.mp3 835 s; scored 110 Hz / 5.5 θ; 55 s non-fading drone; "Sovereign"; seed "The throne at the center of every kingdom is empty." | G4-0219, G4-0452 · 08:975-978, 09:712 | not built | as B32 |
| B34 | The storm floor — Thunderclouds | play.mp3; hue 258 s12–28, strike 268 s70–95, ground 40, no rainbow; no ground 0–47.5; flash-void 138–155; 123.5 Hz, presence .68, beat schedule; dropout 140.0–141.5; gains ×1.15 / ×1.25 / ×.8; seed + fruit verbatim; haptics four patterns; Karishma 1−EB | G4-0388, G4-0394, G4-0396, G4-0397, G4-0456, G4-0390 · 09:432-488, 09:637, 09:716 | not built | as B32 |
| B35 | The descent film | one frame per ring crossed; RingGlyph 96 gold; "the way opened · {date}"; 4.5 s/frame, tap advances; ring 1 "the ground", ring 2 "home"; dates for every ring from Ring Crossed rows | G7-0541, G2-0153 · 21:40, 04:246 | built (`DescentFilmView.swift`, 221 lines) with date bug (cross G7-0542) | **move** here; fix dates; Settings/book become doors |
| B36 | Eyelids on the inhale | opens after ≈12 s still; eyeOpen += dt/28 only while still and inhaling; lids #08070B, 18% edge; blink every 18–40 s | G5-0070 · 12:322, 13:355 | not built | new (BreathClock phase) |
| B37 | The Still Point | five stages ≈1.3 s; type 18→25→29→33→41 pt; haptics .25→.15→none; framing removed until the ember breathes; "Surface" always | G5-0116, G5-0357 · 12:410, 13:479-480, 13:123 | not built | new |
| B38 | Map and no map | the whole shaft drawn faint over 3 s, erased over 6 s, the ember left; no words | G5-0313, G5-1131 · 12:909, 12:1516 | not built | new |
| B39 | The darkness at the core | 4 pt black core in the ember; ember light 1.0→1.15; subtractive silence (B14) here | G3-0493 (C-1313) · 07:870-873 | not built | new |
| B40 | Ten Mahāvidyās (held) | ten stations in the gates grammar, each named, never drawn — designed, built only on his yes (Q-B1) | G5-0307, G5-1108, G5-1119 · 12:899, 12:1493, 12:1504 | not built | new (held) |
| B41 | Beneath as a place | `Place.beneath`; `BeneathModel {stratum, chamber, kpContext?, lowDoorOpened, lastStratum, furthestStratum}`; ledger Gesture Source "Beneath" | G6-0916, G7-0591, G7-0592 · 17:781, 21:121, 21:142 | not built | new |
| B42 | Hold to read | his texts are read by holding; cadence ×0.82–1.34; the ember in 4 brightness tiers by time away; haptic per word .3/.4, skipped under 90 ms; heart .5/.3 | G5-0111 · 12:404, 13:478-479 | not built | new (shared with the Well) |

## B3 · Parity ledger

The ledger is written as `waves/upgrade/ledger/beneath-and-relationship.csv`, with ids `BNR-Bxx` and one row per checkable element (B01–B42). The Relationship rows follow as `BNR-Rxx`.

## B4 · Data contract

- **Airtable reads (no new fields):**
  - **Mandala** — her five DescentWords fields, the library rows, Appreciation Phrase, Siddhi strings `fldx9jXyTVWxp19o1`, Mental State.
  - **The Map** — URL `fld5wkzZkM30kmeyU`; the seven classical chakra colours for the arches.
  - **Walks** `tblJ2sg5ubhN5CH5M` — Walk rows with Status Live only: Name, Sort Order, Figure Kind, Hue, Threshold Invitation, Arrival 1–3, Teaching 1–3, Depth 1–3, Question, Reflection, Vow You, Vow I, Exit Line, Root Hz, Beat Hz; field ids per 16:294: `fld0ylQw1PesCTmvc, fldEQucrCE8Hww0Ra, fldYCk2bQfmIjbm8E, fld3dK8qeSp3tw82V, fldTaHbAaMKZu1Sb4, fldlE7ReL5V1NeFns, fldKa1nVEpcdk5klI`. Never the Entry rows.
  - **Identity** `tbluLyZj9ilH2RhIg` — Declaration `fldry3UX62Eedqb9F`, Values, Mantras (low-state door).
  - **Codex** — his entries (low-state door, sentence-split 12–240 chars).
  - **Gaia** `tbll9fXzLSa44XqUi` — Type = Witness Perspective: Linked Chakra, first line of Witness Body, Unlock Trigger.
  - **Learning** — titles only: L-1021, 1022, 1056, 1062, 1067, 1203–1207, plus the road's topics (no L-id; by title).
- **App Activity writes** (the single ledger; Source App `Mandala`; Gesture Source **`Beneath`**, a new option by typecast):
  - `Walk Completed` (existing option) — with **Link to Mirror → Walks** and the vow (Vow I as carved) in Notes.
  - `Vow Arrived` (new) — Link to Mirror.
  - `Gate Released` (new) — Link to The Map = the gate's chakra; **no Notes, ever.**
  - `Body Read` (new) — Detail = region · quality; Notes = his word.
  - `Small Door Answered` (new) — Detail = question number; Notes = his answer.
  - `Promise Made` (new) — Notes = his promise.
  - `Long Sit` (new) — Detail = song path; Duration (sec).
  - `Played` (existing) — the Shadow Translator coin; Link to Mandala = the gift kp; no words.
  - **Nothing is written** for the low-state door, the water's leaves, the Translator's typed line, the mirror's word or a laid-down card.
- **Local stores** (caches rebuilt from the ledger, so practice data is never lost): `beneath.at` (last and furthest stratum, per day; UserDefaults); `BookOfTheBody` (≤108 verses); `ChildSpaceStore` (the shared game E88 store); vow marks; gate progress (the last gate passed, no words).
- **Bundled assets:**
  - Fonts: Lora, DM Sans, Newsreader (OFL).
  - Songs (from `waves/register/audio-on-github.md`): `bindu/in_shadow.mp3` (18,284 KB), `bindu/kingdom.mp3` (12,314 KB), `bindu/play.mp3` (4,654 KB). Fetch on first open from aistrangegame.com/<path> and keep cached; or bundle (weight is no gate).
  - Score JSONs for in_shadow, kingdom and thunderclouds (Bindu Field scores).

## B5 · Doors

| from / to | door | thread |
|---|---|---|
| any world → Beneath | two-finger hold 1250 ms (B01) | spine (gesture) |
| menu constellation → Beneath | hold Beneath's point | spine |
| Her Home (kp) → Beneath | dark tile under her room → her shaft → the floor of her → the surface | kp |
| Beneath → Her Home | "rise back into her room" from the floor of her | kp |
| Beneath (coin) → Her Presence kp 1–10 | tap the coin's back | kp |
| Beneath (witness light) → Her Presence | hold a sealed page, then "to her" | kp |
| Today → Beneath | the low-state word | day |
| Beneath ↔ the Well | a dark tile on the Well's page; from the surface, a door up to the Well (the Well is its own world; letters live there) | spine |
| Memory (Archive book middle page "go down") → Beneath | lands at the descent film | spine |
| Settings "Remember the descent" → Beneath | lands at the descent film | spine |
| A Strange Game (words) ↔ Beneath | the same Shadow Translator and Child Space, two doors (game E57, E88) | spine |
| the 33, room 9 Shadow → Beneath | "the long sit" (In Shadow) | chakra |
| the 33, room 28 Innocence ↔ Beneath | the small door | chakra |
| the 33 (walked gate) → Beneath | Sakshi's unlock appears in the witness chamber | chakra |
| Beneath → Bindu Feed | the full Witness Perspective; the walk's prose stays in Lalita Family | outside |
| Beneath → web | the outside door at the floor of her (Map URL, enclosure/vertebra pages) | outside |
| Beneath → Home | the point; the bottom's Shepard fall never lands, it is not a door | spine |
| Beneath → previous world | rise / left edge returns exactly where he was | spine |

## B6 · To Bindu Feed (from the Beneath slice)

- Voice II's five acts of Gaia's text (G3-0237; 06:1794-1801). The heartbeat mechanism stays here.
- The Atlantis fragment *"Mastery of energy… The Father built everything."* (G5-0592; 14:385-393).
- The Sonar Ears lens readings at 33 scored songs (G4-0276; 08:1181).
- Learning story topics: Ego Death L-1349 (G5-0872), Stephen Levine (G5-1136), Dark Night of the Soul (G5-1148), Aghora (G5-1207), the Bardo's narrative (G5-1113), the Jungian Shadow Work passage (G5-1200), the Kali fable (G5-1119), the Sri Vidya fable (G5-0995), the Advaita Vedanta story (G5-0896), the Kashmir Shaivism story (G5-1146).
- Sakshi's full Witness Bodies (G6-0760; 16:320).
- Sid's 70th artifacts and the person-page builds (G6-0699; 16:222).
- The Archive as a book (G7-0536; 21:36), which is also Memory's.
- The Walks' arrival and teaching prose stays in its home app (16:294, 16:346). Beneath walks it through A2's form (see settled S-B4).

## B7 · Conflicts — settled and open

**Settled from evidence:**

- **S-B1 · Where is Beneath?** Foundation:16 puts the Well, letters, witness and the Shadow Translator "under the ground". The fifteen worlds list the Well and Beneath separately. So the Well stays its own world (its own slice), and Beneath holds witness, the Translator, the Mirror, the descent and the low door, with doors both ways.
- **S-B2 · "Sound on gates only"** (01:769-770). This is lifted by ruling 10 ("one sound at a time" etc. lifted). Beneath has a continuous bed. Design's quieter instinct survives as "noise decreasing" (B12).
- **S-B3 · The descent gating** (`DescentReach.shallow`, `HerDeepening`, the withheld fifth, no way out at the threshold). Lifted (G7-1033, ruling 16). All five stations are offered from the first visit; the way out is always there.
- **S-B4 · The Mirror walk's prose: story or form?** Register 16 (16:294, 16:346) files the walk's arrival and teaching prose as story belonging to Lalita Family / Feed, with a Memory echo. The Foundation (:16) and padakarshini (11:578) place **A2 under the floor**, and ruling 17 requires text "revealed through each room's form". The A2 walk *is* such a form, one beat at a time, never a page. **Ruling: Beneath walks Live walks through A2's form, read-only, no person ever. Memory keeps the sky echo; the prose is not copied into the app.**
- **S-B5 · Low-state citation.** `RiteOpenings.swift:24` cites C-1120. The law is C-1002 (and C-1057). Fix the comment (G6-0942, G3-0537).
- **S-B6 · Generated voices in Sanctuary, Child Space, Body as Scripture and the gatekeeper.** Refused (no generated voice). The mechanisms are kept, and his own word is the answer. This agrees with `worlds/game.md` §7.7.
- **S-B7 · "84 hearts".** Refused (simulated presence floor, G2-0932).
- **S-B8 · Child Space 20 vs 12 questions.** The 20 in the source file, verbatim (agrees with game §7.20).
- **S-B9 · Gate tones.** The Release sketch's own bells, 440 + 40·k, are used. Sanctuary's Solfeggio 396–963 conflicts with "one tuning (Design's ring roots)" and is dropped. The gates are not rings, so the ring tuning is not touched.
- **S-B10 · Kingdom carrier.** 146.8 (kingdom.md) vs 110 / 5.5 (the score file, 09:712). The score drives the renderer, so it is 110 / 5.5. The "Peak 19.5" error is fixed in the listening pass.
- **S-B11 · Mauna, Praveśa, the Bindu → Lalitā bloom, the deep zoom.** These belong to Home and Modes (G7-0207: "belongs in its own world"; ruling 9). Beneath does not duplicate them: its bottom is the Still Point and the Shepard fall, not the Bindu.
- **S-B12 · walk--growing time gates.** Offered, never imposed ("let it grow" is his choice), honouring the lifted app limits (ruling 16).
- **S-B13 · Body as Scripture verses.** The FALLBACKS verses were written by the Chakra Game build, not by him or Design. Refused; his word is the verse.

**Open — for Ashrey:**

- **Q-B1 · The Ten Mahāvidyās.** Ten presences from outside the 102: should they stand Beneath as a named ten-station descent (names only, never drawn)? Designed as B40, held for your word.

## B8 · Coverage (Beneath slice)

See §C at the end of this file, which covers both slices by script.

---

# PART TWO · THE RELATIONSHIP FIELD

## R1 · The world

### R1.1 What it is

**Design's header, verbatim:** *"The outer Saṅgha given its own world. The people you love are her wearing human faces. The work of recognition is the work of love."* (03:813). Its five-dimension line: *"Relationship (radial) — Shaktis cluster around the people in your life. Ram is Ātmā's frequency. Ashrey is Nāma. Gaia is Ahaṅkāra. The work of recognition is inseparable from the work of love."* (03:101-109). The Saṅgha form: *"The field is all you. There are no strangers in it."* (03:684-692).

**His words:**

- *"talk about what's going on in our heads and actually map them out to different individuals … and then understand what the relationship is like"* (C-1107, 07:245-248).
- *"We've designed a game in which we have to play with each other. Because, yeah, not by ourselves."* (C-1285, 07:765-768).
- *"close your eyes and you feel your inner connection to the Divine … when you open your eyes … connected to"* the other's energy (C-1155, 07:355-358).
- *"being is as important as doing"* (C-1273, 07:705-708).

**Rulings:** 10 (built in full), 11 (*"built from Design + the three existing connections (Gaia·Ahaṅkāra kp31, Ashrey·Nāma kp40, Ram·Ātmā kp42), no new Airtable fields"*). The old "DO NOT BUILD" (FB-07), "dead stays dead" (BV2-P6), the padakarshini "left behind (held)" and the code's `TheModes.swift:6` "Saṅgha is ruled out" are all superseded.

**What it is, as built.** One radial space. **Her yantra is at the centre**: the home ring-2 lotus, whose petals are the sixteen Karṣiṇīs, kp 29–44. **The three connections are petals of that same ring**: Gaia at Ahaṅkārā (kp 31), Ashrey at Nāma (kp 40), Ram at Ātmā (kp 42), with **Bīja (kp 41) as the bridge** between the last two.

Around the yantra stand **the souls he has received** into the field. Each is a coloured light, joined by dashed threads to the petals (seats) she enters through them as. **He himself is not a node: Ashrey is the pattern**, drawn as the web between all the lights.

Six instruments open from the Field, as Design made them: ① the Field, ② the Person Page, ③ the Śakti's Carriers, ④ the Encounter Log, ⑤ the Field Web, ⑥ Adding a Beloved. Three more grow from the corpus:

- **the Ring of Vantages**, the archetypes with their declarations;
- **the shared beat**, a duo session;
- **the rose window of who gathered**, his leaving.

### R1.2 Arriving

- **The crossing:** through the point, blooming from the touch in the Field's colour (moonlit `#8E7AB5`) over the Design ground (radial `#060306 → #010103`). Then **tiered arrival** (G5-0473), set here:
  - 0.0 s: the yantra (lotus petals at radii 88 / 70 / 14 in cluster colours at .30, ring r 92 at .10, bindu r 6 plus a cream r 2).
  - 0.8 s: the three connection petals brighten.
  - 1.6 s: the souls appear on r 200, evenly from the top.
  - 2.4 s: the threads draw, dashed (2 4), .5 wide, in each soul's hue at .40, to the carried petals at r 80, with a blurred r 6 highlight.
  - 3.2 s: the words.
- **The words, verbatim:** eyebrow *"THE RELATIONSHIP FIELD"* / *"she wears their faces · they carry her in"*. Then *"{n in words} souls in your field. / each one a carrier of her."* Then *"TAP A NAME · ENTER THEIR PAGE · HOLD TO ADD A SOUL"*.
- **The configuration line**, once a visit, verbatim (Identity configuration "Family"): *"Three of us. One field. The work happens here, between us."* (G6-0733).
- **DustMotes:** 10.
- **Geometry:** the Design artboard is 390 × 844 with the centre at (195, 432). The canvas pans and pinches from .55× to 1.6× (set here) for the rings of nearness.

### R1.3 Being there — the Field (①)

- **Who is in it.** The three connections (seeded from `ShaktiBootstrap` / Settings FIELD CONNECTIONS, his editable names and his notes), plus every soul he receives through the ritual (⑥). Nothing auto-populates: *"Not a contacts list — a sacred recognition."* He may pick a name from his own Relationships table in the ritual's first step (existing fields only; Authors excluded).
- **Rings of nearness** (G6-0727), echoing bhūpura → bindu, by the Type of Influence of a picked person:
  - r 200: Family and the three connections.
  - r 260: Family Friend / Guide / Mentor.
  - r 320: Friend.
  - r 370: Staff / Business Partner, at the gate.
  - A soul typed by hand sits at r 200.
  - Order on a ring follows Influence Magnitude where he has set it, used for order only and never shown.
- **Each light lives on its own clock** (G5-0474, G5-0646):
  - Shimmer 9.0 s with a phase from a hash of the name. Where the person is Sid, 9 s *"faster, more urgent"*; Arch, 15 s *"slower, more patient"*.
  - A heartbeat glyph pulse of 2.8 s.
  - **All lights share one 22 s pulse** (soulSync): brightness 1 → 1.04 with a warm 50 pt glow peaking at 88% of the cycle (19.36 s), *"so they flash together."*
  - The pulse is anchored to the wall clock (`Date mod 22000`) so two devices flash together (G5-0211).
- **Brightness is nearness** (G5-0170, G6-0729). A soul's opacity is 22 / 44 / 76 / 100% at 0 / 1 / 3 / 7 of: encounters with them, plus recognitions of a Śakti they carry. **The thresholds are never shown.** Portrait Status, where he has set it, adds one tier.
- **Procession lights** (G4-0258). With two or more souls, a new pair every 5 s (at most 8): a light travels between two souls along a quadratic bending 35% toward the centre, in ~30 s.
- **When two come close** (G4-0261, G4-0018, G5-0595). Dragging one soul toward another:
  - A resonance flash blooms at their midpoint within maxR·.08–.12 (white radial r maxR·.06, alpha .2).
  - **Two detuned sines, 132 Hz and 140 Hz, glide to unison at 136.1 Hz** over 8 s (set here), gain .04 each, hold 4 s, fade 3 s: *"Convergence moment = Om."*
  - Released, the soul springs back to its place in .6 s (rubber band `limit + (x−limit)·.35`).
- **Ashrey is the pattern** (G4-0020, G4-0260). His light has no position. It is the centroid of all visible souls, drawing gradient threads to each at .12. Midpoint nodes (2 pt) appear on threads where both lights are past 30%. Its hue cycles 12°/s. His seat, Nāma kp 40, keeps its petal.
- **The membrane and the one blend** (G4-0259, G5-0696). With six or more souls, all pairs join with lines at .06 × boost (boost 1.6 at each 22 s peak, else 1). **Only at that peak, and only then, all their colours blend into one**: the membrane takes the OKLab mean of every hue. This is the one place in the app where every person's colour blends.
- **Lead Time as a soft approach** (G6-0736). For a picked person with a Timeline row, their light brightens one tier during the Lead Time days before the day (3, 7, or 0 = the morning of). On the day, Today's first door carries their name. There is never a notification count.
- **Passed, rendered as Notice** (G6-0732, G5-0449). A soul whose person has passed (Passed, set by hand) stays, rendered quiet: a hollow 1.5 pt ring, no Act. Their day opens as a Notice day, a held silence.
- **"and the field turns to you"** (G5-0085). Holding the bindu 1.1 s turns every light's gaze line toward the centre (atan2) over 1.2 s, with the line.
- **Place me** (G5-0684). While holding, a small cream mark for him appears at the centre. He drags it among the souls, and it returns when released.
- **The person filter** (G5-0682). Choosing a soul dims everything not theirs to opacity .12 with grayscale .5 over 350 ms. **This works in the Mandala and in Memory too**: her seats light for the person's carried Śaktis.
- **Gestures:** tap a name → their Person Page (②); hold empty field 750 ms (12 ms tick) → Adding a Beloved (⑥); tap a petal → the Śakti's Carriers (③); pinch out past .55 → the Ring of Vantages appears around the whole field; two-finger hold → Beneath (spine).

### R1.4 The Person Page (②)

The page is a vertical corridor, one beat per screen (the B05 grammar). Tempo is the person tempo, 350 ms.

1. **Who they are** (REL-2).
   - Ground linear `{hue}18 → #060104 50% → #050103`; *"‹ Field"* in the hue; a 56 pt hue orb with a glow of 32 pt and 6 pt spread.
   - Name 46 italic. Role 10 pt, tracked .28em. The role comes from his Identity Role (`fldfLTztU1P2qaqC7`: Husband / Father / Son / Brother / Friend …). For the three connections no role is shown.
   - His note, 17 italic: the fieldNote for the three, the ritual note for others.
   - **Long hold on the role** reveals that Role's Declaration from Identity, verbatim (G6-0734). For example, Brother: *"Twins across time, building the miracle together. Same essence, two embodiments."*
2. **"SHE ENTERS THROUGH THEM AS"** (REL-2). One row per carried Śakti: a 10 pt cluster dot, the name 19 italic, the quality 13 italic at .50. The first row carries a *"PRIMARY"* pill. A tap crosses to her presence (kp).
3. **The inner connection** (C-1155). *Hold with eyes closed*: the screen goes to black and holds for as long as he holds, minimum 8 s (set here). On release, their orb blooms from the point.
4. **STANCE** (G4-0796, G5-0026). Three marks: **you**, **them** (their hue) and **the Śakti they carry, drawn as a ring, never as a face**. Gaze lines rotate by atan2.
   - Five positions: all · against · merged · apart · beside.
   - He drags "you". On release, by distance to them: under 34 pt *"too close to see it"*; over 140 pt *"too far to help"*; otherwise *"near enough to stand beside"*.
   - **It always ends on beside.** It resets on the next step and is never stored.
5. **ATTUNE — two waves kept two** (G4-0812).
   - Two lines with the same speed (wavelength 240 pt, drift 9 s). Only the phase differs, starting at `ph` 1.
   - He drags his line. In step when the phase is under .04 of the wavelength: both lines deepen (stroke 1.5 → 2.5, opacity .6 → 1).
   - **A fixed vertical gap of 28 pt (set here) never closes.**
   - The words: *"IN STEP BUT STILL TWO"* · *"Stay two people."*
   - **The sound follows the phase:** `f₁ = 136.1 − 4.1·ph`, `f₂ = 136.1 + 3.9·ph`. At ph 1 that is 132 / 140 Hz, and at step it is 136.1 — the field's Om — while the figure stays two.
6. **LADDER** (G4-0815, G5-0027).
   - Two rails down the left edge, one each. A rung for every day with an encounter between them (from ④); every seventh rung is a double rung. A missed week is drawn as a longer gap.
   - When there is none today, two dots drift toward each other over 7 s.
   - *"Nothing here keeps score between you. A missed week is just a longer rung."*
7. **Two chairs** (G4-0707, G4-0790, G4-0868).
   - His chair and theirs lean ±3°. *"Neither — I'm on the floor between them"* is a third place. A tap swaps chairs. The chosen seat's ellipse warms .5.
   - **Each voice's words in its own colour** (his ink, their hue); the chairs never pick.
   - *"Listen to both. Notice what the noticing does."*
   - He supplies the words; any authored debate content goes to the Feed.
8. **The reach** (G5-0230, G5-0231, G6-0578, G6-0596, G5-0594).
   - **Six equal pills:** Message · Call · Email · Something sent · Showing up · Silent acknowledgment, every one *at the same weight*. One done becomes an italic whisper (*"reached, this morning"*) and **a strike-through that stays**. Missing is absent: nothing marks a day without a reach.
   - **The Euphoria Pulse:**
     1. Rub the palms 15–20 s; the mic hears the rub.
     2. Palms apart *"six inches"*.
     3. A hand to the chest: *"I reach toward someone I love who is not here"*.
     4. Palms together at the chest: *"I am held by what I just sent."*
   - **Send love into the field** (*"Just a moment of it. Just an emission."*): a held emission outward from the point toward every soul. The lights flare once by .15 in sequence around the ring over 2.2 s (set here).
   - **The vibrating heart:** 80 pt, scale 1.0 → 1.06 → 1.0 over 10 s (0.1 Hz). Gold glow .15. Labelled *"feel"* (11 pt, tracking 4). A touch scales it to 1.12; haptic 100 ms at each peak.
9. **Their song** (G4-0458, G6-0749, G4-0222, G4-0223, G4-0278, G4-0344, G4-0614).
   - Where a person is the song's Family row, holding their orb plays their song with **only its verb** shown (*"The verb is their essential nature, activated as seed."*).
   - Shweta: `bindu/purity.mp3` (Where'd You Go + Thunderclouds; carrier B2 123.5 Hz; the "Two Groundings" seam of 4.9 s held by the carrier alone at .004).
   - Rey (Ashrey): `bindu/levelup.mp3` (Levels + Beautiful Now; B2 123.5 Hz; the designed 2.69 Hz "between").
   - Standalone songs where he assigns them: `bindu/glow.mp3`, `bindu/play.mp3`. `miss` and `lift` are not on GitHub.
   - **The readings (purity's and levelup's personal narratives) are never shown** (privacy floor, G4-0614).
10. **Last together — occasion, not interval** (G5-0375).
    - *"Last together — {occasion}, {month}"*, never "N months ago".
    - *"most alive — {Śakti short name}"*: the Śakti most often linked in their encounters, as a name, never a number.
    - Design's stats grid (encounters · in field · last met · most alive) loses its counts: the no-counts floor applies to his life.

### R1.5 The Śakti's Carriers (③)

- **Reached from:** any petal in the Field; her presence or room (*"who carries her"*); and the Memory Portrait (*"‹ Portrait"*).
- Ground linear `{cluster}0F`. Eyebrow *"WHO CARRIES HER INTO YOUR LIFE"*. Name 38; bīja 24 italic in the cluster colour with a 16 pt glow; quality 16 italic.
- Line: *"no carriers yet"* / *"one soul carries her"* / *"{n} souls carry her"*.
- Empty state (dashed card): *"no one yet carries her into your life. / watch · she may arrive through someone soon."*
- Rows: an 18 pt hue orb, name 20 italic, note, the first word of the role. A tap opens the Person Page.

### R1.6 The Encounter Log (④)

- Header *"THE ENCOUNTER LOG"* / *"when she crossed between you"*.
- **Rows:** a 10 pt hue node; name 18 italic plus the date (9 pt; "Today, 10:14 AM" style — a date, never an interval); Śakti chips (5 pt dot + short name, 12 italic, in the cluster colour); his context, 13.5 italic at .58, **in his own ink colour** (authorship by colour, G5-0478).
- **How an encounter is made:**
  - **(a) From a Recognition** (G6-0731). After *"and she felt you back"*, a hollow ring appears at 1.5 s for 6 s. A 750 ms hold (12 ms tick) shows the souls as dots around her; a tap on one offers the moment to them. One App Activity row is written, *Share With*, with Link to Mandala and **Shared With** (`fldgrIfuL6i4M9gZv`) where the person is a Relationships record.
  - **(b) From the Log or a Person Page**, by *"she arose"*: choose Śaktis (petals), then optionally speak or type the context.
    - **Speaking:** the listening rings — a 15 pt ember core, rings breathing 3.4 / 4.3 / 5.6 s, transcript ≈90 ms a word (+260 ms at punctuation), on-device recognition only.
    - **Placement by grammar:** four sentence cards, the suggested one brighter and never pre-selected; untouched, they lower after 9 s.
- **Design's sample rows** (*"morning chai…"*, *"Mama, look! ME!"*) **are never shipped**. They are invented and go to the Feed list.
- **"she will arrive in the yantra each time you meet"** (REL-6 promise, made true). On a day with an encounter, the carried Śaktis' seats in **the Mandala** wear a thin ring in that person's hue until midnight. Her presence shows the person's name beside the Field Connection line.

### R1.7 The Field Web (⑤)

- Header *"THE FIELD WEB"* / *"the threads between them"*. Souls sit on r 168. The centre circles are r 70 (.12) and r 42 (.10), with the bindu r 8 + r 3. Node halo blur r 20 at .18, plus r 9 hue, plus cream r 3. Labels 13 italic.
- **Threads in tiers** (settles the empty web):
  1. **Shared Śakti** — a quadratic bending 35% toward the centre, stroke = the first shared Śakti's cluster colour, .7 wide at .40.
  2. **Shared ring** (āvaraṇa) — .4 wide at .25.
  3. **Through the bindu** — a .3 hairline via the centre, for every other pair.
- Words: *"{n} shared currents. / where one carries her, another may too."* The count is of tier-1 threads only. With none, only the second line shows. *"TAP A THREAD · SEE WHICH SHAKTI RUNS THROUGH"*.
- **Couples and families** (G6-0728). Rows in Family Links (filled by his hand; 0 today) draw a doubled thread. An anniversary with two Relationships draws a married pair.
- **The heart-room dynamics** (G4-0024, G4-0262). Where a soul's carried Śakti is in the heart cluster, it attracts: at high energy (the 22 s peak) all lines meet in a unified field at the presence-weighted centroid, and light bridges form between close pairs.
- **Two become a third** (G5-0453). When two people are dragged together, they slide to the midpoint and merge in 500 ms; the shared Śakti blooms .6 → 1 between them.
- **Infinity gateway** (G5-0604). When two Person Pages have both been opened in one visit, the centre pulses once.
- **The element view** (G4-0797). A tap on the bindu re-seats every soul on a wheel (r 130) by the **element of the Śakti they carry** — ruling 4: Ahaṅ fire, Nāma air, Ātma light, Amṛta water, plus the RING2 element column for the others. Spin snaps in 72° detents; glyphs counter-rotate. **No feeding or restraining arrows** (no relation data; nothing invented).

### R1.8 Adding a Beloved — the Ritual (⑥)

- **Ground and frame:** linear `#0A0610 → #060104 60% → #040103`; *"‹ Field"*; four progress dots (the current one gold, 6 pt, with glow).
- **The four steps:**
  1. **Naming.** Eyebrow *"A SOUL ARRIVES IN YOUR FIELD"*. *"By what name / do you know them?"* (26 italic), with a blinking cursor (1.1 s, two steps) and *"THE NAME YOU CALL THEM"*. He types, **or picks from his Relationships** (Name `fldoLPA7XKnLH9xX4` / Nickname `fldKpMVSmA1IGltfX`; Authors excluded). Picking links the local soul to that record id; no Airtable field is added.
  2. **The Śaktis.** Eyebrow *"HOW DOES SHE ENTER THROUGH THEM"*. *"What does she become / when she comes through them?"*
     - A 240 pt lotus of the sixteen (radii 100 / 70 / 18). Chosen petals sit at .95 with a 10 pt drop-shadow; the others at .18.
     - Line *"two chosen · {names}"*, and *"TAP PETALS · TWO OR THREE IS ENOUGH"*.
     - A pinch opens **the whole yantra** to choose any of the 102.
     - Selection is stored **by kp** (position is identity): kp = 29 + index for the 16.
  3. **The note.** Eyebrow *"WHO THEY ARE TO YOU"*. *"In one breath: / who is she, to you?"* A card holds his line. It is sent by holding (G31: 2300 ms up / 620 ms drain, armed only when there are words).
  4. **Arriving.** Eyebrow *"RECEIVED"*. A 36 pt orb in their hue (hue from the name) with a glow of 36 pt and 10 pt spread; the name 42 italic; the note; a hairline; then *"she is now in your field. / she will arrive in the yantra / each time you meet."*
- **Hue from a name** (G5-0374): `n = (n·31 + charCode) >>> 0`; `hue = round((n·137.508) % 360)`. Dot on night `oklch(.75 .13 H)`; accent text `oklch(.50 .11 H)`. Two people show as two dots overlapping 7 px. *"No photographs."*
- **The three connections keep Design's hues:** Gaia `#D4A017`, Ashrey `#4A7A5A`, Ram `#7A5A9A`. Where a picked person is an archetype's person, the family palette applies: Arch `#7A2F14`, Sid `#1B3A5C`, Ash `#26421A`, shared `#4A4238` (G5-0509, G5-0586).

### R1.9 The Ring of Vantages (beyond Design's six)

- Reached by pinching out past .55. Ten faces stand on a ring around the whole field (r = 1.2 × the field radius). Each has its one line, verbatim (Talk, 06:1884-1895):
  - Gaia *"The asking always precedes the answer."*
  - Sid *"The goal is already accomplished. The work is holding it."*
  - Arch *"Teach before you sell. The invitation never closes."*
  - Sakshi *"What is seen completely, completes itself."*
  - Karishma *"It was ready before you were."*
  - Ashrey *"The architect who discovers he is the architecture."*
  - Neev *"What consciousness stands on."*
  - Shweta *"What consciousness flows through."*
  - Bindu *"Always moving. With love."*
  - Lalita *"Knows the game. Plays anyway."*
- **The dialogue wheel:** Ask · Tell · Wonder · Stay quiet.
  - **Ask** shows that face's Identity Declaration, verbatim (G6-0711–0719). For example, Sakshi: *"I am that which sees. Not the seer, not the seen — the seeing itself."* Higher Self: *"I am the silence that holds your speaking. I am the gap your thoughts cross."*
  - **Tell** opens the Encounter capture, addressed to that face.
  - **Wonder** shows nothing but the face's light breathing for one 22 s cycle.
  - **Stay quiet** dims the ring to .3.
- **How faces are drawn:** as geometry, never a body. Sakshi is the witness mandorla (*"cannot be made to blink"*); Lalita is her hypotrochoid (R0 152, k ≈ 18/7, 900 points). The others are hue points until he maps a figure to them.
- **Seats on the threads:** each face sits at its vertebra (Bindu 1 · Neev 2 · Shweta 3 · Arch 6 · Sid 11 · Sakshi 18 · Karishma 28 · Ashrey 31 · Lalita 33 · **Gaia 32**, per ruling 2). A long hold crosses to that chakra's room; 32's words stay sealed.
- **The Trinity faces** (`TrinityOfGuidance.swift`, five cases) extend to every named archetype (ruling 6).

### R1.10 Saṅgha, the shared beat, the rose window

- **Saṅgha outer = this world.** The Modes world's Saṅgha keeps the *inner* layer (the 102 as named orbitals: *"One hundred and two living forces. / This is your assembly."*). Its *outer* layer crosses here (*"The people you love / are her wearing human faces."*), and the person view's *"THIS IS HOW SHE ENTERS THROUGH HIM"* is the Person Page. `TheModes.swift:6` is reversed.
- **The shared beat** (G4-0574). A duo session over SharePlay: one device plays the carrier in the left ear, the other carrier + beat in the right. *"The beat exists only between them, in the shared field."* Both breathe on the wall clock (8 s, `Date mod 8000`). HRV-responsive gain is later; it needs HealthKit.
- **The rose window of who gathered** (G5-0408). On leaving, if anyone was met today, their dots (at most ten) circle an ember centre at ≤1 turn/min, with *"gather again"* · *"to the rite"*.

### R1.11 Leaving

- The point (home) is always present.
- The left edge returns exactly where he was.
- The rose window, if anyone was met today.
- The Field's Om holds at .004 for ~3 s into the next world (duet seam).
- From a Person Page: *"‹ Field"*. From the Carriers: *"‹ Portrait"* when he came from Memory.

### R1.12 Visual language and sound

- **Grounds:** Design's Phase VII grounds are the floor and win: the Field radial `#060306 → #010103`, the Person `{hue}18 → #060104 → #050103`, the Ritual `#0A0610 → #040103`.
- **The lalita chassis enters for type, tempo and person colour** (G5-0487, G5-0527):
  - **Type:** Instrument Sans for UI and labels (caps 12/500, tracking .18em); names in the house Cormorant italic, as Design drew them. Newsreader is *"ONLY under the floor"*: it never appears here, only in Beneath.
  - **Ink:** `#ECE7DD`; ink-2 `#B6B0C2`; muted `#8D879D`; moonlit `#8E7AB5`; walked gold `#F9E3A7`; absent `#838173` (Notice).
  - **Tempo:** night 600 ms, person 350, capture 150.
- **Law 25** (G5-0338): a person is one identity, seen whole — one record (colour, name) read live in every world.
- **Sound:**
  - The bed is the Om at its floor (136.1 Hz, gain .004), *"the home frequency"*.
  - The meeting glide is 132 / 140 → 136.1 (R1.3).
  - ATTUNE's phase-coupled pair (R1.4).
  - Their song on hold.
  - No other drone.

## R2 · Every element, placed

| # | element | what it does (mechanism + numbers) | source | status today (code) | reuse / move / new |
|---|---|---|---|---|---|
| R01 | The Field (①) | yantra petals 88/70/14 at .30, ring r92 .10, bindu r6 + r2; souls on r200 from top; 16 pt hue node, glow 12/3; names 14 italic (label −36 in upper half); threads dashed 2 4, .5, hue .40 to petals at r80 + r6 blur; tiered arrival 0/.8/1.6/2.4/3.2 s; words verbatim; DustMotes 10; pan/pinch .55–1.6× | G1-0763, G1-0761, G5-0444, G5-0473, G7-0593, G7-0594 · 03:834-836, 03:825-828 | not built | **new** `RelationshipFieldView` (Canvas → Metal later) |
| R02 | The three connections | kp31 Gaia "She anchors here." · kp40 Ashrey "She weaves through here." · kp42 Ram "Holds her frequency." + fieldNotes verbatim; Bīja kp41 the bridge, default focus; Design hues #D4A017/#4A7A5A/#7A5A9A; no role shown | G1-0535, G1-0561, G2-0010, G6-0792, G7-0559, G7-0635, G7-1017, G1-0534 · 02:1103-1114, 02:1354, 17:192, 21:56 | partial — `ShaktiBootstrap.swift:59-60, 205-206, 239-240`; Settings `:236-254`; Mandala `fldsk2ATEtTVB87eb` | **reuse** as the first three souls (migration) |
| R03 | Souls received (store) | `Beloved {id, name, relationshipsRecordId?, hue, carried:[kp], note, receivedAt, source: connection/ritual}`; local cache rebuilt from `Soul Received` ledger rows; nothing auto-populates; Authors excluded | G7-0594, G6-0641, G6-0779, G6-0654 · 21:141, 16:112, 16:345 | not built | new `BelovedStore` |
| R04 | Rings of nearness | r200 Family/connections · r260 Family Friend/Guide/Mentor · r320 Friend · r370 Staff/Partner; Influence Magnitude orders only | G6-0727, G6-0656, G6-0657, G6-0658, G6-0659, G5-0426 · 16:272, 16:142-151 | not built | new |
| R05 | Colour from a name | `n=(n·31+c)>>>0; hue=round(n·137.508 % 360)`; night dot oklch(.75 .13 H); text oklch(.50 .11 H); two dots overlap 7 px; Design hues for three; family palette Arch #7A2F14 · Sid #1B3A5C · Ash #26421A · shared #4A4238 | G5-0374, G5-0509, G5-0586 · 13:197-199, 13:729-731, 14:334-341 | not built | new `OKLCH.swift`, `personHue(name)` |
| R06 | Own clocks + shared 22 s pulse | shimmer 9.0 s (Sid 9, Arch 15), name-hash phase; glyph 2.8 s; soulSync 22 s: 1→1.04 + warm 50 pt glow at 88% (19.36 s); wall-clock anchored | G5-0646, G5-0474, G5-0211 · 14:726, 13:537-538, 12:546 | not built | new |
| R07 | Procession lights | pair every 5 s, max 8, quadratic 35% to centre, ~30 s traversal; ≥2 souls | G4-0258, G4-0169 · 08:1164, 08:821-826 | not built | new |
| R08 | Meeting: resonance + 132/140 → 136.1 | drag one soul to another; flash at midpoint within maxR·.08–.12 (r maxR·.06, α .2); sines 132 & 140 glide to 136.1 over 8 s, gain .04 each, hold 4 s, fade 3 s; spring back .6 s, rubber band ·.35 | G4-0261, G4-0018, G5-0595 · 08:1167, 08:144-148, 14:406 | not built | new synth voice in `RingAudioService` (reuse `glide` 410-416) |
| R09 | Ashrey is the pattern | no node; centroid of visible souls; gradient threads .12; midpoint nodes 2 pt where both > 30%; hue cycles 12°/s; Nāma kp40 petal kept | G4-0020, G4-0260, G2-0537 · 08:152, 08:1166, 05:314 | not built (dancer exists in web dances) | new |
| R10 | Membrane + the one blend | ≥6 souls: all-pairs .06 × boost (1.6 at 22 s peak); only at the peak, colour = OKLab mean of all hues | G4-0259, G5-0696 · 08:1165, 14:981-984 | not built | new |
| R11 | Brightness is nearness | opacity 22/44/76/100% at 0/1/3/7 (encounters + recognitions of a carried Śakti), never shown; Portrait Status + one tier | G5-0170, G6-0729 · 12:482, 16:274 | not built | new |
| R12 | Lead Time approach | brighten one tier during Lead Time days (3/7/0); Today's first door names them on the day; no count | G6-0736 · 16:284 | not built | new (Timeline read) |
| R13 | Passed as Notice | hollow 1.5 pt ring, absent #838173; Notice day = held silence | G6-0732, G5-0449 · 16:277, 13:487 | not built | new |
| R14 | The field turns / Place me | hold bindu 1.1 s → gaze lines to centre over 1.2 s, "and the field turns to you"; cream mark draggable, returns on release | G5-0085, G5-0684 · 12:361, 14:916 | not built | new |
| R15 | Opening words | header lines + "she wears their faces · they carry her in" + "{n} souls in your field. / each one a carrier of her." + "TAP A NAME · ENTER THEIR PAGE · HOLD TO ADD A SOUL" + "Three of us. One field. The work happens here, between us." | G1-0759, G6-0733 · 03:813, 16:278 | not built | new (verbatim) |
| R16 | Person Page (②) | bg {hue}18→#060104 50%→#050103; ‹ Field; 56 pt orb glow 32/6; name 46 italic; role 10 pt .28em; note 17 italic; beats 1–10 as a corridor, tempo 350 ms | G1-0764, G5-0229, G5-0228 · 03:838-839, 12:567-568 | not built | new (B05 corridor reused) |
| R17 | Role + declaration | role from Identity Role `fldfLTztU1P2qaqC7`; long hold → Role Declaration verbatim (Identity) | G6-0734, G6-0720 · 16:279, 16:231-233 | not built | new (Identity read) |
| R18 | She enters through them as | rows: 10 pt cluster dot, name 19 italic, quality 13 italic .50, "PRIMARY" pill on first; tap → her presence | G1-0764 · 03:838-839 | not built | new |
| R19 | The inner connection | hold eyes-closed: black ≥8 s while held; release → their orb blooms from the point | G3-0390 (C-1155) · 07:355-358 | not built | new |
| R20 | STANCE | you / them / her ring (never a face); five positions; drag "you": <34 "too close to see it", >140 "too far to help", else "near enough to stand beside"; ends on beside; never stored | G4-0796, G5-0026, G5-0532 · 11:414, 11:620, 12:150 | not built | new |
| R21 | ATTUNE | wavelength 240, drift 9 s, ph 1→0; in step <.04 → strokes 1.5→2.5, .6→1; fixed 28 pt gap; "IN STEP BUT STILL TWO" / "Stay two people."; f₁ = 136.1−4.1·ph, f₂ = 136.1+3.9·ph | G4-0812 · 11:453-456 | not built | new |
| R22 | LADDER | two rails; rung per encounter day; every 7th double; missed week = longer gap; waiting dots drift 7 s; grace line verbatim | G4-0815, G5-0027 · 11:461-464, 12:151 | not built | new |
| R23 | Two chairs | chairs ±3°; floor between; tap swaps; seat warms .5; words by colour; never picks; closing line verbatim | G4-0707, G4-0790, G4-0868, G5-0478 · 11:399, 11:623, 13:545 | not built | new |
| R24 | The reach | six equal pills; whisper "reached, this morning" + strike that stays; Euphoria Pulse (rub 15–20 s by mic; 6 in; chest; "I am held by what I just sent."); Send love: flare +.15 around the ring over 2.2 s; heart 80 pt 1→1.06 over 10 s, glow .15, "feel", touch 1.12, haptic 100 ms | G5-0230, G5-0231, G6-0578, G6-0596, G5-0594, G3-0460 · 12:569-570, 15:1391, 15:1432, 14:399-405 | not built | new (mic) |
| R25 | Their song | hold the orb plays their Family song with only the verb; purity.mp3 (B2 123.5, 4.9 s seam at .004); levelup.mp3 (B2 123.5, 2.69 "between"); glow.mp3, play.mp3 if assigned; readings never shown | G4-0458, G6-0749, G4-0222, G4-0223, G4-0278, G4-0344, G4-0599, G4-0580, G4-0614, G6-0698 · 09:718, 16:300, 08:986-995, 10:447 | not built | new (Bindu Field song player) |
| R26 | Last together / most alive | "Last together — {occasion}, {month}"; "most alive — {Śakti}"; no encounter counts | G5-0375, G1-0764 · 13:204 | not built | new |
| R27 | Śakti's Carriers (③) | bg {cluster}0F; "WHO CARRIES HER INTO YOUR LIFE"; name 38; bīja 24 italic glow 16; quality 16; count line three forms; empty card verbatim; rows 18 pt orb, 20 italic; from petal, her presence, Portrait | G1-0765 · 03:841-842 | not built | new |
| R28 | Encounter Log (④) + capture + offering | header verbatim; rows 10 pt node, 18 italic + 9 pt date, chips 5 pt + 12 italic, context 13.5 italic .58 in his ink; from a Recognition: ring at 1.5 s for 6 s, hold 750 ms, tap soul → Share With row + Shared With; from "she arose": petals + listening rings (15 pt, 3.4/4.3/5.6 s, 90 ms/word +260) + 4 sentence cards lower at 9 s; Design samples never shipped | G1-0766, G6-0731, G5-0390, G5-0225, G1-0778 · 03:844-853, 16:276, 13:270-271, 13:268-269, 03:983 | not built | new; on-device speech |
| R29 | She arrives in the yantra | encounter day → carried seats in the Mandala wear a ring in the person's hue until midnight; her presence shows the name | G1-0768 (promise), G1-0669 · 03:858-863 | not built | new (Mandala reads today's encounters) |
| R30 | Field Web (⑤) | souls r168; centre r70 .12 / r42 .10 / bindu r8+r3; halo r20 .18 + r9 + r3; threads tiered (shared Śakti .7@.40 cluster colour, 35% bend · shared ring .4@.25 · bindu hairline .3); words verbatim; Family Links double thread; heart-cluster attractor + unification at peak + bridges; two become a third (500 ms, .6→1); infinity pulse; element view r130, 72° detents, counter-rotating, no arrows | G1-0767, G6-0728, G4-0024, G4-0262, G5-0453, G5-0604, G4-0797, G1-0534 · 03:855-856, 16:273, 08:166-170, 08:1168, 13:493, 14:476, 11:415 | not built | new |
| R31 | Person filter (cross-world) | choose a soul: others .12 opacity, grayscale .5, 350 ms; in the Mandala and Memory her seats light for their carried Śaktis | G5-0682 · 14:909, 14:983 | not built | new (spine service) |
| R32 | Adding a Beloved (⑥) | four steps verbatim; cursor 1.1 s; pick from Relationships (Name/Nickname; Authors excluded); 240 pt lotus 100/70/18, chosen .95 + 10 pt shadow, others .18; pinch → all 102; kp = 29 + index; note sent by G31 hold 2300/620; arriving 36 pt orb glow 36/10, name 42 italic, closing lines verbatim | G1-0768, G6-0726 · 03:858-863, 16:271 | not built | new |
| R33 | Ring of Vantages | pinch < .55; ten faces at r = 1.2× field; lines verbatim; Ask (Identity Declaration) / Tell (capture) / Wonder (one 22 s breath) / Stay quiet (.3); Sakshi mandorla, Lalita hypotrochoid R0 152 k≈18/7 900 pts; vertebra seats (Gaia 32); hold → that room | G3-0249, G7-0408, G7-0456, G6-0711–G6-0719, G6-0720, G6-0725, G3-0295, G5-0062, G5-0669, G6-0832, G6-0895, G6-0933 · 06:1884-1895, 16:230-233, 16:270, 06:2192-2212, 13:507-512, 14:89, 17:570 | Trinity 5 faces built (`TrinityOfGuidance.swift:25-51`) | reuse Trinity lights; extend to all named; new ring |
| R34 | Saṅgha outer = the Field | Modes' Saṅgha outer layer crosses here; inner stays in Modes; reverse `TheModes.swift:6` | G1-0634, G1-0737, G7-0494, G7-0596, G1-0624, G2-0340 · 03:684-692, 21:17, 21:133 | "Saṅgha is ruled out" | **fix** + door |
| R35 | The shared beat (duo) | SharePlay; device A left carrier, device B carrier + beat right; beat only between them; both breathe 8 s on the wall clock | G4-0574 · 10:245, 10:487-488 | not built | new (GroupActivities) |
| R36 | Rose window (leaving) | up to ten dots of today's met souls, ≤1 turn/min, ember centre; "gather again" · "to the rite" | G5-0408 · 13:348 | not built | new |
| R37 | Tokens, type, tempo | Design grounds win; Instrument Sans UI caps 12/500 .18em; Cormorant italic names; ink #ECE7DD / #B6B0C2 / #8D879D, moonlit #8E7AB5, walked gold #F9E3A7, absent #838173; tempo 600/350/150; no Newsreader here | G5-0487, G5-0527, G5-0229, G5-0338 · 13:590-601, 13:781, 13:62-63 | not built | new tokens (bundle Instrument Sans) |
| R38 | Sound bed | Om 136.1 at .004; meeting glide; ATTUNE pair; song on hold; seam .004 for ~3 s on leaving | G4-0581, G5-0595 · 10:268, 10:463 | Om built | reuse `SoundConductor` (`.field` voice) |
| R39 | Outside doors | a person's or archetype's page/gateway URL (Builds) as an "outside the app" door at the end of their Person Page, where the Build has a URL | G6-0699 · 16:222 | not built | new (Builds read: Title, Type, URL) |
| R40 | Model, ledger, migration, tests | `Place.relationshipField`; ledger Gesture Source "Relationship Field"; migrate the three FIELD CONNECTIONS (names + notes) as souls keyed by kp; tests: migration, privacy, kp keying, no counts on screen, ledgered once | G6-0915, G6-0934, G6-0950, G7-0931, G7-0595 · 17:780, 17:840, 17:904, 22:522, 21:171 | not built | new |
| R41 | Gratitude returns as their light (held) | when a resurfacing gratitude line names a person (Link to Relationships `fldQkIAPvnmjvZojw`), their light glows once that day; verbatim; no date or count — needs his yes (Q-R1) | G6-0751, G6-0772 · 16:305, 16:338 | not built | new (held) |
| R42 | Field Connection card → door | her presence's "Field Connection — {name}" card (kp31/40/42 and any carried seat) becomes a door to that soul's Person Page | G1-0669, G7-0559 · 03:275-277, `ShaktiDetailView.swift:675-700` | built as a static card | reuse + door |

## R3 · Parity ledger

See `ledger/beneath-and-relationship.csv`, rows `BNR-R01` to `BNR-R42`.

## R4 · Data contract

- **Airtable reads (existing fields only — ruling 11):**
  - **Mandala:** Field Connection `fldsk2ATEtTVB87eb` (seed only; the local edit wins), Quality, Bīja, cluster.
  - **Relationships** `tblgqMklMFrwjfX0g`, read only for souls he picks, never listed wholesale:
    - Name `fldoLPA7XKnLH9xX4`, Nickname `fldKpMVSmA1IGltfX`, Type of Influence `fldmbczhiHHFyF7Hn` (exclude Author), Identity Role `fldfLTztU1P2qaqC7`.
    - Portrait Status `fldnCIbOixKuQaMMa`, Passed `fldtbQ2aclA1ynHMU`, Daily `flddgec1pPR0EoJqp`, Influence Magnitude.
    - Dates → Special Days `tblReC2mERNIxyA4K`; Timeline `tblzLBmY0z6lRQzkm` (Lead Time `flduFKfW3KfqFFB9n`, Day Nature).
    - Family Links `tblpjOgHPPd8WUfzm` ("the app reads, never writes").
  - **Identity** `tbluLyZj9ilH2RhIg`: Declaration `fldry3UX62Eedqb9F` for archetypes, roles and configurations.
  - **Builds**: Title, Type, URL, for the outside doors.
- **App Activity writes** (Source App `Mandala`; Gesture Source **`Relationship Field`**, a new option by typecast):
  - `Soul Received` (new): Detail = name; Notes = his note; Link to Mandala = carried kps; Shared With = the Relationships record if picked.
  - `Share With` (existing option, never yet written): the offering after a Recognition and every "she arose" encounter. Link to Mandala = Śaktis; Shared With where known, else the name in Detail; Notes = his context.
  - `Reach` (existing option): Detail = which of the six ways, or "love sent", or "euphoria pulse".
  - `Shared Beat` (new): duo session, Duration.
  - **Nothing is written** for STANCE, ATTUNE, two chairs, the inner connection, Place me or the Field turning.
- **Local:** `BelovedStore` (Application Support, private, rebuilt from `Soul Received` rows). The three seeds migrate from Settings' `fieldName` / `fieldNote` by kp.
- **Bundled / fetched assets:**
  - Songs: `bindu/purity.mp3` (7,977 KB), `bindu/levelup.mp3` (9,857 KB), `bindu/glow.mp3` (4,023 KB), `bindu/play.mp3` (4,654 KB).
  - Font: Instrument Sans.
- **Privacy:** private device only (the settled replacement for "left behind (held)", G5-0329). Nothing from this world is mirrored to any site. The site's "behind the wall" law applies if it ever is (G5-0556, G3-0185).

## R5 · Doors

| from / to | door | thread |
|---|---|---|
| menu constellation → Field | the Field's point | spine |
| search (a person's name) → Person Page | search | spine |
| Her Presence (Field Connection card, any carried seat) → Person Page / Carriers | tap the card / "who carries her" | kp |
| Her Home (her room) → Carriers | "who carries her" | kp |
| Field petal → Carriers → Her Presence | tap petal; tap her name | kp |
| Person Page "she enters through them as" → Her Presence | tap a row | kp |
| Recognition (after "and she felt you back") → Encounter | the hollow ring, held 750 ms | kp |
| Memory Portrait petal → Carriers ("‹ Portrait") | REL-3 | kp |
| Mandala (the person filter) ↔ Field | choosing a person lights their seats in the Mandala | kp |
| Modes, Saṅgha (outer) → Field | Saṅgha's outer layer | spine |
| Today (Lead Time / the day) → Person Page | their name on the first door | day |
| Time (a person's Act or Notice day) → Person Page | tap the mark on the year ring (Time world) | day |
| Ring of Vantages face → the 33 room at its vertebra | hold the face | chakra |
| Field → Beneath | two-finger hold | spine |
| Field → Today ("to the rite") | the rose window | day |
| Person Page → web | the outside door (Builds URL) | outside |
| Field → Home / previous world | point / left edge | spine |

## R6 · To Bindu Feed (from the Relationship slice)

- **Design's encounter contexts** (*"morning chai. he was reading. I was watching."* etc.) and Design's FIELD/BELOVED people with their roles and notes: invented, never shipped (G1-0766, G1-0760, G1-0738).
- **The purity and levelup personal readings:** Shweta's "white substrate" and Rey's monk-and-Chief karmic narrative (G4-0222, G4-0223, G4-0591, G4-0614).
- **The Feed's own per-track story links** (G4-0608).
- **His relational Codex stories:** C-1004 generational healing with his father and son (G3-0330); C-1214 Cleo and his mother on the road (G3-0423); C-1309 changing how others see the one (G3-0490); C-1298's name meanings (G3-0482).
- **Narrative sources:** the Trinity's locked baselines the-call-read / the-leela-read / the-one-speaks (G3-0295); the eleven voices as the Feed's voices (G5-0062); Talk's lines as dialogue (G7-0456, partly).
- **Lemuria / Atlantis convergence words** (G5-0593); Family Constellations / Ancestral Trauma (Hellinger G5-1209, Wolynn G5-1130, G5-0532 stories); two-chairs debate content (G4-0790).
- **Archetype leitmotifs as told stories** (G4-0368, only the stories); Sid's 70th artifacts (G6-0699).

## R7 · Conflicts — settled and open

**Settled from evidence:**

- **S-R1 · Build or not.** FB-07 "DO NOT BUILD", BV2-P6 "dead stays dead", padakarshini/rupakarshini "left behind (held)" and `TheModes.swift:6` are all superseded by rulings 10 and 11 (G2-0085, G2-0340, G5-0329, G7-0494). Built in full; private device only.
- **S-R2 · Design's people vs real people.** Design's two tables (FIELD: Ram/Ashrey/Gaia/Ma/Papa/Nilima; BELOVED: … Mother/Self) disagree with each other and invent roles ("son", "daughter", "life partner") and encounters. Floor HO1-12: *"No invented relationships, no fake practitioners."* The Field ships **the three connections with his own names and notes, and no roles**, plus the souls he receives. Design's tables remain the layout reference only.
- **S-R3 · Ruling 11 vs register 16's new fields** (Relationships.Archetype, .Shakti, .Chakra, .Song; G6-0654, G6-0661, G6-0725, G6-0726, G6-0749). No new fields. Person ↔ Śakti lives in the local store and in ledger rows (`Soul Received` Link to Mandala). Person ↔ archetype is used only in the Ring of Vantages, by the archetype names themselves. Person ↔ song is his choice on the Person Page, stored locally.
- **S-R4 · Reading his Relationships table.** Reading existing fields adds none (ruling 11 holds). It is used only when he picks a name in the ritual, so nothing auto-populates (Design: "not a contacts list"). Authors are excluded (G6-0779).
- **S-R5 · The empty Field Web.** With the three distinct connections, no pair shares a Śakti (Design's own data also drew zero threads). Settled: tiered threads (shared Śakti → shared ring → through the bindu); the count reads tier 1 only.
- **S-R6 · Design ring-2 indices.** Design's index comments are inconsistent (G7-0595, G1-0738). The build stores kp only: kp = 29 + index for the sixteen, and the three connections are taken by kp directly (31 / 40 / 42).
- **S-R7 · Bīja kp41, "bridge".** The RING2 field column marks Bīja "bridge", the default focus. Ruling 11 lists three connections. Kept as a seat, not a fourth soul: the Ashrey ↔ Ram thread passes through kp 41.
- **S-R8 · Gaia at vertebra 10 or 32.** The v3 vantages put her at 10. Ruling 2 and ASG:127 put her at 32 (the Ego Reveal). Settled at **32, sealed**, for the vertebra thread. Her seat thread stays kp 31 (G5-0670).
- **S-R9 · "Higher Self (Ram, his own)".** The code ties the Higher Self face to the name at kp 42 (G6-0933). Settled without inventing a role: kp 42 shows his name and his note only. The Higher Self face in the Ring of Vantages carries its Identity Declaration, and they are not merged.
- **S-R10 · Counts.** The Person Page's "encounters" stat and "present · 12 years" / "N months ago" are dropped (no counts; occasion, not interval). "{n} souls" and "{n} shared currents" count the field, not him, and are written in words.
- **S-R11 · Simulated presence.** "84 hearts" (Hub, Sanctuary, Field) is refused (G2-0890, G2-0932, G2-0902).
- **S-R12 · Heart-hue palette.** The Anahata dance re-hues people (G4-0024). Here a person keeps their own hue; Mandala/Map colours win for Śaktis.
- **S-R13 · Walks never cross people** (G6-0773). The Mirror walk lives in Beneath with no person. The Field never shows a walk.
- **S-R14 · Element wheel relations.** Sheng/ke arrows have no data for these elements. Wheel layout only (nothing invented).
- **S-R15 · Lalita Family's relational fields are empty** (G6-0768, G6-0769). The Field reads what exists and fills nothing. Neev's and his own missing birthday rows are his to add by hand.

**Open — for Ashrey:**

- **Q-R1 · Gratitude naming a person.** May a resurfacing gratitude line that names someone (Link to Relationships ⚡) make that person's light glow once that day? It widens the one-column Gratitude ruling (C6). Designed as R41, held for your word.

---

# §C · Coverage — every id in both slices

The table below was generated from the slice files and checked by script. Each id is marked as one of: placed (row), merged into (id), to Bindu Feed, rejected (floor or ruling), or not this world (which world).

| id | slice | title | marked | where / why |
|---|---|---|---|---|
| G1-0007 | beneath | The library — ShaktiDetailView folded beneath the room | placed | B20 |
| G1-0087 | beneath | Library sheet UI and rows | placed | B20 |
| G1-0323 | beneath | Standing decisions: Turrell adaptation register, ~60 s mechanisms, reference matter becomes floor of the descent | placed | B20 (standing decision; 'sound on gates only' lifted, S-B2) |
| G1-0453 | beneath | 'The floor of her' — reference rows at the bottom of the fall; 'rise back into her room' | placed | B20, B11 |
| G1-0454 | beneath | RiteLibrary bottom sheet — orphaned (exported, never mounted) | placed | B20 (RiteLibrary orphan retired) |
| G1-0534 | relationship | RING2 iconography grammar — 16 Karṣiṇīs with phonetic, element, silhouette, attribute, surface, motion, bīja, field | placed | R02, R30 (element column); silhouette column rejected (floor: no figure of a Śakti) |
| G1-0535 | relationship | Relationship Field anchors in Living Axis: Gaia (kp31), Ashrey (kp40), Ram (kp42), bridge (kp41) | placed | R02 |
| G1-0561 | relationship | fieldConnection in shakti-data: Gaia → Ahaṅkārā (3), Ashrey → Nāma (12), Ram → Ātma (14) with notes | placed | R02 |
| G1-0567 | relationship | Living Rite governing idea: 'Time is the medium'; single practitioner (Gaia / Ashrey / Ram) | not this world | spine (governing idea; single practitioner) |
| G1-0609 | relationship | Layer navigation routes (Memory, Relationship, Temporal instruments) | placed | R16, R27, R32 (navigation routes; §R5) |
| G1-0624 | relationship | Tensions 5–7: Ring 4/6 colours; Saṅgha meaning; Bindu breath | placed | R34 (Saṅgha meaning settled); ring colours → rings |
| G1-0634 | relationship | Mode Saṅgha — Assembly: 102 as named orbitals; loved ones as nodes with dashed threads | placed | R34 |
| G1-0635 | relationship | Layer instrument counts: Memory 7, Temporal 6 + contract, Relationship 6 | placed | R01 (six instruments) |
| G1-0638 | relationship | Five dimensions: Depth, Time, Memory, Relationship, Practice | placed | R01 (§R1.1 radial dimension) |
| G1-0669 | relationship | v1 ShaktiDetail (Ātmākarṣiṇī): Quality, Somatic Signature, Bīja tap-to-hear, Esoteric Tattva, Field Connection card, Recognition Log | placed | R42 |
| G1-0737 | relationship | Saṅgha: 'The field is all you. There are no strangers in it.' — inner 102, outer loved ones as carriers | placed | R34 |
| G1-0738 | relationship | Saṅgha BELOVED list: Ram, Ashrey, Gaia, Mother, Self with carried Śaktis, colours and lines | rejected | floor HO1-12 (Design's BELOVED people are sample data; S-R2); layout kept in R01 |
| G1-0759 | relationship | Relationship Field header: 'The outer Saṅgha given its own world … The work of recognition is the work of love.' | placed | R15 |
| G1-0760 | relationship | FIELD data: Ram, Ashrey, Gaia, Ma, Papa, Nilima — carried Śaktis, hues, roles, lines (synthetic encounters) | rejected | floor HO1-12 (Design's FIELD people, roles, synthetic encounters; S-R2) |
| G1-0761 | relationship | Relationship instruments ① Field and ② Person Page subtitles | placed | R01, R16 |
| G1-0762 | relationship | Relationship instruments ③ Carriers, ④ Encounter Log, ⑤ Field Web, ⑥ Adding a Beloved subtitles | placed | R27, R28, R30, R32 |
| G1-0763 | relationship | REL-1 Relationship Field screen — beloved as luminous nodes around your yantra, dashed threads to carried petals; hold to add | placed | R01 |
| G1-0764 | relationship | REL-2 Person Page — 'SHE ENTERS THROUGH THEM AS'; hue orb, role, note; stats grid | placed | R16, R18, R26 (encounters stat dropped, S-R10) |
| G1-0765 | relationship | REL-3 Shakti's Carriers — who carries her into your life (reverse lookup; '‹ Portrait') | placed | R27 |
| G1-0766 | relationship | REL-4 Encounter Log — 'when she crossed between you' (sample entries verbatim) | placed | R28 (structure); sample contexts to Bindu Feed |
| G1-0767 | relationship | REL-5 Field Web — threads between people sharing a carried Śakti (draws zero threads with shipped data) | placed | R30 (tiered threads, S-R5) |
| G1-0768 | relationship | REL-6 Adding a Beloved — The Ritual (naming, selecting Śaktis, note, arriving): 'she will arrive in the yantra each time you meet' | placed | R32 |
| G1-0778 | relationship | Recognition is the spine feeding every layer (Catch → Smṛti → Portrait → Thresholds → Atlas/Wheel/Spiral → Pūjā → Encounter Log) | placed | R28 |
| G2-0010 | relationship | DS-09 the 16 with cluster, location, bīja + field markers | placed | R02 |
| G2-0014 | beneath | DS-13 animation timing table | not this world | visual (timing reference table) |
| G2-0021 | beneath | DS-20 Silence (16 names as stars) | not this world | modes (Mauna / Silence screen; S-B11) |
| G2-0038 | beneath | CB0-14 Silence phase 6 | not this world | modes (Silence phase; S-B11) |
| G2-0045 | relationship | HO1-03 five dimensions | merged into | R01 |
| G2-0054 | relationship | HO1-12 no invented relationships | placed | R03 (floor applied, S-R2) |
| G2-0072 | beneath | HO2-07 R9 Praveśa fall (chosen) + Spanda alt | not this world | rings (Ring 9 Praveśa; S-B11) |
| G2-0085 | relationship | FB-07 Relationship Field DO NOT BUILD (old) | rejected | superseded by rulings 10/11 (S-R1) |
| G2-0101 | beneath | FB-23 Mauna expansion captions | not this world | modes (Mauna captions) |
| G2-0127 | beneath | DA1-13 Bindu breath as language (slower deeper) | placed | B07 (ember breath slower the deeper) |
| G2-0137 | beneath | RFB-07 R9 end in silence | not this world | rings (Ring 9 ends in silence) |
| G2-0153 | beneath | MBB-15 stretch: widget, film, export, drone, Silence | placed | B35 (descent film); Silence part → modes |
| G2-0180 | beneath | FH-12 Living Mandala semantic zoom + Bindu→Lalitā descent | not this world | mandala (semantic zoom, Bindu→Lalitā) |
| G2-0187 | beneath | FH-21 definition of done: opens to her | not this world | spine (definition of done) |
| G2-0208 | beneath | RBB-15 auto-descent: recommend a chosen tap | not this world | mandala (auto-descent) |
| G2-0211 | beneath | RBB-18 one continuous space to the Bindu | not this world | mandala (one continuous space to the Bindu) |
| G2-0218 | beneath | XMB-02 descent four constants | placed | B07 (four constants) |
| G2-0247 | beneath | CRD-08 Ring 8 triad + Ring 9 phrase | not this world | rings (Ring 8 triad, Ring 9 phrase) |
| G2-0266 | beneath | CCH-20 Ring 9 built last by hand | not this world | rings (Ring 9 by hand) |
| G2-0304 | beneath | SH-01/02 descent corrected: three depth layers passed through | placed | B07 (three depth layers passed through) |
| G2-0316 | beneath | AR-05 Mauna in code 20 May→11 Jul | not this world | modes (Mauna history) |
| G2-0335 | beneath | BV2-R11 Mauna reborn as dwelling 62 s | not this world | modes / her-home (Silence Held dwelling) |
| G2-0340 | relationship | BV2-P6 'dead stays dead' list (partly reopened) | rejected | superseded by rulings 10/11 (S-R1) |
| G2-0375 | beneath | WV-09 Wave 2 One building list | placed | B23 (Gates of Release); other items → climb, rings, mandala |
| G2-0384 | beneath | RD-07 gap cause 3: port losses | not this world | visual / mandala (port losses) |
| G2-0390 | beneath | RD-14 restorable list (Veil, ring mechanisms, modes, temporal, memory) | not this world | mandala / rings / modes / time / memory (restorable list) |
| G2-0403 | beneath | F10 Bindu→Lalitā finale red bloom | not this world | mandala (F10 red bloom) |
| G2-0421 | beneath | F28 Ring 9 Praveśa start (Direction B) | not this world | rings (F28 Praveśa) |
| G2-0422 | beneath | F29 Ring 9 Spanda full bloom (Direction A) = G17 centre bloom | not this world | rings / home (F29 centre bloom) |
| G2-0467 | beneath | C33 Mauna/Silence | not this world | modes (Mauna conflict; S-B11) |
| G2-0468 | beneath | C34 Ring 9 personal connection placement | not this world | rings (Ring 9 personal connection) |
| G2-0470 | beneath | C36 auto-descent at deep zoom | not this world | mandala (auto-descent conflict) |
| G2-0495 | relationship | Practice v3: LivingDot eight movements | not this world | the-33 (LivingDot practice) |
| G2-0537 | relationship | Seven dancers: bindu, gaia, sid, arch, karishma, sakshi, ashrey | merged into | R09 (Ashrey's web); dancers → the-33 |
| G2-0590 | beneath | Room 01 depth: Lalitā, three sub-bindus, Yoni Mudra, no tree | not this world | the-33 / rings (room 01 depth) |
| G2-0837 | relationship | Room 32 depth: Bhagamalini 3rd Kama Kala — thread link | not this world | the-33 (room 32, sealed) |
| G2-0890 | relationship | B.5.1 Hub: simulated '84 hearts breathing' | rejected | floor: simulated presence must not ship |
| G2-0896 | relationship | B.5.4 Sanctuary (Mirror, Gates, Field views) | placed | B27, B28 (Sanctuary); '84 hearts' rejected (floor) |
| G2-0902 | relationship | B.5.9 The Field (simulated presence, Hourly Convergence) | rejected | floor: simulated presence; Hourly Convergence → time |
| G2-0932 | relationship | E Simulated presence must not ship | placed | R03 (floor applied, S-R11) |
| G3-0147 | relationship | Mind rooms archetypes (content doc) | not this world | the-33 (Mind archetypes) |
| G3-0181 | relationship | T-ONE The One: Higher-Self naming ceremony | not this world | memory (higher-self naming ceremony) |
| G3-0185 | relationship | Practice Book colophon family cipher (behind the wall) | placed | R4 privacy (floor applied) |
| G3-0237 | beneath+relationship | MAP-VOICE A Strange Voice (Voice II) | placed | B04 (heartbeat mechanism); five-act text to Bindu Feed (B6) |
| G3-0249 | relationship | Sketch 2 Talk: ring of ten vantages | placed | R33 |
| G3-0295 | relationship | Trinity of Guidance: three axes, five faces | placed | R33; locked baselines to Bindu Feed |
| G3-0314 | relationship | Lakota research (Mitakuye Oyasin kin-cosmos) | rejected | nothing invented — register holds no Lakota content to place |
| G3-0330 | relationship | C-1004 Heal generational trauma (context) | to Bindu Feed | C-1004 generational healing |
| G3-0368 | relationship | C-1107 The path already exists; depth over breadth | placed | R01 (§R1.1 his words) |
| G3-0376 | beneath | C-1120 The void between low and high is creative | placed | B18 (C-1120 creative void) |
| G3-0390 | relationship | C-1155 Eyes-closed inner connection, then open to the other | placed | R19 |
| G3-0423 | relationship | C-1214 Companions on the Road: Cleo, mother; anger → love | to Bindu Feed | C-1214 Cleo and mother (Passed/Notice mechanism R13) |
| G3-0460 | relationship | C-1273 Being as important as doing (context) | placed | R24 (being as important as doing) |
| G3-0472 | relationship | C-1285 Clues in plain sight; game played with others | placed | R01 (§R1.1 his words) |
| G3-0482 | relationship | C-1298 Calm-space law; never pull him away; 'we don't know'; AI starts, human hands off | not this world | spine (calm-space law); name meanings to Bindu Feed |
| G3-0490 | relationship | C-1309 Change how others see the one (context) | to Bindu Feed | C-1309 |
| G3-0493 | beneath | C-1313 Darkness held at the core; empty centre | placed | B39 (C-1313 darkness at the core) |
| G4-0018 | relationship | Dancer interactions: resonance flash, Gaia impact rings, Sid orbit trail, drop re-lights ghosts | placed | R08 |
| G4-0020 | relationship | Ashrey has no independent position — he IS the pattern (lesson #19) | placed | R09 |
| G4-0024 | relationship | VX Anahata ensemble variant: heart palette, Arch attractor, progressive unification, light bridges | placed | R30 (hues not adopted, S-R12) |
| G4-0041 | beneath | Shape Expression origin: Ashrey's Maya panel 'Pointe' animation; 'I and U' (#25) | not this world | the-33 (Pointe / Maya panel) |
| G4-0051 | relationship | 'I Love You' line at the emotional peak; cross variant 'already across' | not this world | the-33 ('I Love You' line) |
| G4-0116 | beneath | Gap categories: sustain mode (drones), decay-envelope (bowls), adaptive bloom (quiet), chant (#37-#40) | not this world | the-33 / her-home (dance gap categories) |
| G4-0165 | beneath | OL-1 pink noise floor (7-coefficient, LP 4 kHz, gain 0.015) | placed | B12 (pink noise) |
| G4-0169 | relationship | cross visual upgrade Tier 2 (reach-history thread, procession lights, resonance zones, chant haze, configuration membrane) | placed | R07 |
| G4-0219 | beneath | Kingdom (Arsov, Meditate, 13:55): absent root 146.8, 55 s non-fading drone, one word Sovereign | placed | B33 (Kingdom long sit) |
| G4-0222 | relationship | levelup (Family · Rey, Levels + Beautiful Now, 7:32): B2 123.5, 12 phases, designed 2.69 Hz 'between' | placed | R25; karmic narrative to Bindu Feed |
| G4-0223 | relationship | purity (Family · Shweta, Where'd You Go + Thunderclouds, 8:30): Two Groundings, 4.9 s seam | placed | R25 |
| G4-0224 | beneath | The 2.69 Hz constellation: Kingdom → Sound of Silence → Golden → Aatma → Maya | not this world | the-33 (2.69 path through room dances; Beneath keeps 2.69 in B13) |
| G4-0228 | beneath | 'only You, playing' source and lineage (maya-sleep.html) | not this world | the-33 (room 30 'only You, playing') |
| G4-0236 | beneath | Geometry cycle for Maya (30) and Lalita (33): dot → line → circle → ∞ → ♥ → swell → dot | not this world | the-33 (Maya/Lalita geometry cycle) |
| G4-0240 | relationship | The Word's Star: same word, same place forever; alpha .06+.10·bloom+.30·shweta | not this world | memory (the Word's Star) |
| G4-0241 | relationship | Lalita's constellation acknowledgment 'You have been one of the dancers.' | not this world | the-33 |
| G4-0256 | relationship | Shweta / Glassine clarity wash at PEAK_T on Recognition lines | not this world | her-home (Shweta clarity wash) |
| G4-0258 | relationship | Procession lights travelling between people (Relationship Field) | placed | R07 |
| G4-0259 | relationship | Configuration membrane: all pairs joined when 6+ present (Relationship Field) | placed | R10 |
| G4-0260 | relationship | Ashrey web + midpoint nodes; Vishuddha vibrating-string web (Relationship Field) | placed | R09 |
| G4-0261 | relationship | Resonance flash / zones / surface tension when two come close (two people meeting) | placed | R08 |
| G4-0262 | relationship | Arch attractor + progressive unification + light bridges in Anahata and the Relationship Field | placed | R30 |
| G4-0269 | beneath | Carrier never fades to zero; dance end leaves carrier into the next world | placed | B11 (carrier held into next world) |
| G4-0274 | beneath | Silence honoured: dot only + carrier alone in a song's opening silence | placed | B32 (silence honoured) |
| G4-0276 | beneath | Sonar Ears at 33 scored songs (hidden lenses unlock) | to Bindu Feed | lens readings (B6); unlock → memory |
| G4-0278 | relationship | Family verbs: each person node carries a verb-seed and Score (Relationship Field) | placed | R25 |
| G4-0343 | beneath | Meditate rows: in shadow (Arsov 2017), kingdom (Arsov 2018) | placed | B32, B33 (Meditate rows) |
| G4-0344 | relationship | Family rows: Shweta = purity, Rey = levelup — 'The verb is their essential nature, activated as seed.' | placed | R25 |
| G4-0367 | relationship | cross ensemble hues and leitmotifs (Sakshi unmade gesture, Karishma silence-bloom, Sid columns, Shweta clarity, Neev bookends) | not this world | the-33 (cross ensemble hues) |
| G4-0368 | relationship | Archetype leitmotifs across songs (unmade gesture / silence-bloom-undertow-dry floor / columns-deep-static veins / earth gradient-tidal pull-arriving ground) | not this world | the-33 (leitmotifs); stories to Bindu Feed |
| G4-0382 | relationship | Shape vocabulary with meaning (infinity = what doesn't end; heart = patient love; circle = the only breath; none = unshaped peak; spiral = return) | not this world | the-33 (shape vocabulary) |
| G4-0388 | beneath | thunderclouds.score.json identity: weather-v1, 'nothing lands', NO RAINBOW, verb a phenomenon | placed | B34 |
| G4-0390 | beneath | Karishma measure: silence OR groundlessness (1-E or 1-EB per room) | placed | B34 (Karishma 1−EB) |
| G4-0394 | beneath | thunderclouds binaural: 123.5 B2 absent fifth of E, 'THE CARRIER IS THE RAIN'; beat schedule with null void; carrier_dropout 140.0-141.5 | placed | B34 |
| G4-0395 | beneath | Subtractive designed event (carrier dropout) at Room 32 Ego Reveal / Maya / deep zoom | placed | B14 |
| G4-0396 | beneath | thunderclouds loop: seed by Ashrey 'What are you afraid of that will never pass?' — 'Do not clarify this seed.'; fruit; strike-window weaves | placed | B34 |
| G4-0397 | beneath | thunderclouds Return (tension rises: 'The storm leaves and the charge stays.'), tiers incl. flash-void, haptics, constellation 0.05 | placed | B34 |
| G4-0451 | beneath | Room 9 Shadow ← In Shadow (780 s film score, D3 146.8 deeply absent 0.15, 2.5 δ, Sakshi-led) | placed | B32 |
| G4-0452 | beneath | Kingdom as the deep-zoom bed: 'The throne at the center of every kingdom is empty.' | placed | B33 (+ home deep-zoom bed) |
| G4-0456 | beneath+relationship | Thunderclouds as a teaching of non-reaction (fear practice; floor drops and holds) | placed | B34; Shweta's door R25 |
| G4-0457 | beneath | Journey (59-min set) as long ambient bed under the held yantra — do not dance it | not this world | mandala (Journey set; no mp3) |
| G4-0458 | relationship | Family songs as people's doors in the Relationship Field (purity, levelup, miss, lift, glow, play) | placed | R25 |
| G4-0473 | relationship | The Word's Star as Memory's night sky / Relationship Field / Well (repeats brighten) | not this world | memory (Word's Star night sky) |
| G4-0478 | beneath | Silence heartbeat: longest silence gets a visible and felt 50 bpm pulse | placed | B32 (50 bpm silence pulse) |
| G4-0480 | relationship | Three storage pools (essence who / memory what / being how) as the Mandala's memory-read pattern | not this world | memory (three storage pools) |
| G4-0572 | beneath | H2 subtle-body sound fields: koshas as concentric shells, nadis (ida/pingala = L/R, beat = sushumna), bija sessions | placed | B32 (nāḍī panning); kosha library not adopted as text (nothing invented) |
| G4-0574 | relationship | H4 threshold sessions: bardo/dying, grief ('waves plus long troughs'), trauma titration, sleep, duo sessions, Oracle-generated, HRV | placed | R35 |
| G4-0580 | relationship | S4 categories Energy/Music/Meditate/Family with verb meaning per category; filter bar | placed | R25 (Family category) |
| G4-0581 | relationship | Duet seam: 'The carrier holds through the seam at minimal gain (0.004) — not zero.'; 'The seam is a phase' (crossing beat 7.0, gain 0.006); duet = one card, one mp3, one verb | placed | R38, B11 |
| G4-0582 | beneath | Film rule: 'The film leads. The binaural completes.' (max 0.036-0.040); In Shadow design inversion (delta 2.5 at awakening 540-725 s, shadow theta 3-3.5); drone ending 0.008; tremolo 0.12/0.11 | placed | B32 (film rule) |
| G4-0585 | beneath | S6 Canvas depth field viz: background darkens with brainwave depth; carrier thread = sine at beat rate; 55 particles on smoothEnergy; central bloom; 18-particle burst on phase transitions; descending depth dot | placed | B32 (depth field) |
| G4-0588 | beneath | 2.69 Hz 'the fingerprint awakening leaves' (S7) — now 8 appearances incl. Wake Me Up at A4 440.1 Hz; 'The 2.69 Hz void phase is valid binaural architecture.' (S8) | placed | B13 (2.69 Hz at the bottom) |
| G4-0591 | relationship | avīci = 'without waves'; Rey/levelup family arc personal/story (S8) | to Bindu Feed | levelup family arc |
| G4-0599 | relationship | Catalog rows: others (before 136/2.5, purity 136/5.5, in shadow, kingdom, levelup 123.5/2.69, cross Threshold 110/4.5, Runs 3-4) | placed | R25 (catalog rows) |
| G4-0608 | relationship | Bindu Feed story links per track (45 rows → tbl7vzODMMJUgeX0b), e.g. press 'The Drums Were the Ground', 'The Soldier's Room'; still 'You Can't Find the Center Because You Are It'; dissolve 'The Veil That Noticed'; cohere 'Two Tones Leaning Into One' | to Bindu Feed | Feed story links |
| G4-0610 | beneath | Planetary (Cousto) carrier set from the 'Akash library': 136.1 OM/Earth-year, 194.18 Earth-day, 221.23 Venus, 256 C, 80 Hz chest, 60 Hz deepest | merged into | B12 (136.1 Om); other planetary carriers → home / time |
| G4-0614 | relationship | Privacy: purity (Shweta 'the white substrate') and levelup (Rey/Chief/monk, 'Ash-Rey') readings are personal story-tier | placed | R25 (privacy floor applied) |
| G4-0620 | relationship | Mirror times as cue for the Relationship Field's two-sided view | not this world | the-33 (mirror times; only abide authored) |
| G4-0676 | beneath | Form A2 Mirror walk: a walk under the floor (G14 door; three teachings at depths 0.32/0.60/0.85; vow carved ~2 s; one star warmer) | placed | B21 |
| G4-0678 | beneath | Form A4 Gates of release (arches down one line; set down G33 or keep G26; '· passed ·'; a laid-down word stored nowhere; gifts on the return) | placed | B23 |
| G4-0700 | beneath | Sub-template/move: walk--gates (A4 as a walk); walk--growing (2 h · 8 h · 24 h · 72 h) | placed | B21 (walk--growing), B23 (walk--gates) |
| G4-0707 | relationship | Sub-template/move: twochairs | placed | R23 |
| G4-0738 | beneath | Gesture G14 The Descent | placed | B01 |
| G4-0746 | beneath | Gesture G22 Front camera | placed | B27 |
| G4-0750 | beneath | Gesture G26 Set down or keep | placed | B23 |
| G4-0757 | beneath | Gesture G33 Hold to lay down | placed | B23 |
| G4-0776 | beneath | Corridor engine (BASE_CSS + CORRIDOR_JS): layers, step/piece arrival, --from direction, hit-test contract, nearest-centre activation, 80 ms throttle, idle when hidden, keyboard, ASGjump, remembers quietly | placed | B05 ('i / N' count dropped) |
| G4-0778 | beneath | Contrast law: --acp = oklab mix(accent 50%, #191919) (not oklch — hue rotates up to 14.6°, 'turned a lavender into a rose'); worst case 5.39:1; --actext flips per ground; 'chrome over a figure ground: solid ink, never alpha' (.66 measured 3.87:1; solid clears 8:1); descent ink brightens | placed | B10 |
| G4-0790 | relationship | Exemplar twochairs.html (432 or 440 Hz): chairs lean ±3°; 'Neither — I'm on the floor between them'; tap to swap chairs; 'Listen to both. Notice what the noticing does.' | placed | R23; debates to Bindu Feed |
| G4-0795 | relationship | Variant fieldguide--conversation: HORIZON at 10%; each 'try saying' line copies itself ('copied' 2.2 s); 'Instead of' band | not this world | sister app Bindu Learning (fieldguide content) |
| G4-0796 | relationship | Variant fieldguide--for-someone-else STANCE: you / them / the third; positions all/against/merged/apart/beside; drag 'you': <34 'too close to see it', >140 'too far to help', else 'near enough to stand beside'; ends on beside; never stored | placed | R20 |
| G4-0797 | relationship | Variant map--grid (Five Elements wheel): sheng arcs + ke dashed star; live phase lights only outgoing arrows; glyphs counter-rotate; 72° detents; traveller 14 s | placed | R30 (wheel; arrows rejected, S-R14) |
| G4-0798 | beneath | Variant map--path (Bardo Thödol): road faint in full, walked part draws in, end runs off the edge; five stations on S-curves (dashoffset 1.6 s, live ring r 22) | placed | B31 |
| G4-0807 | beneath | Variant practice--stillness WATER: surface settles ripples → still (data-calm 0 → 1; ripple opacity 1 − calm·.85; speed 4 + calm·14 s); type a thought → it rides a leaf 13 s off the page, never kept; ambient leaves every 11 s; 'You are the one on the bank.' | placed | B16 |
| G4-0812 | relationship | Variant teaching--relationship ATTUNE: two waves same speed, only phase differs (data-ph 1 → 0); drag yours; in step <.04 wavelength → both deepen; 'IN STEP BUT STILL TWO'; 'Stay two people.' | placed | R21 |
| G4-0813 | beneath | Variant teaching--skill DISTANCE: '{t}' → 'I'm having the thought that {t}' → 'I notice I'm having the thought that {t}'; gap widens, type shrinks; never stored | placed | B24 |
| G4-0814 | beneath | Variant twochairs--mind-and-machine MIRROR: mark on chair answered by its reflection .7 s later; 'a reflection cannot choose differently'; 'Look at the reflection. Then ask who is asking.' | not this world | the-33 (MIRROR figure for rooms 32/17) |
| G4-0815 | relationship | Variant walk--relationships LADDER: two rails, a rung per shared day, every 7th a double rung; waiting = two dots drifting toward each other (7 s); 'Nothing here keeps score between you. A missed week is just a longer rung.' | placed | R22 |
| G4-0868 | relationship | Relationship: twochairs authorship by colour; chairs never pick | placed | R23 |
| G5-0010 | beneath | Corridor engine (one piece per screen, nearest-centre activation, remembers) | placed | B05 |
| G5-0026 | relationship | STANCE: five positions (all · against · merged · apart · beside) | placed | R20 |
| G5-0027 | relationship | LADDER: rung per day, double rung every seventh | placed | R22 |
| G5-0062 | relationship | Eleven voice figures / a room per voice | merged into | R33 (Sakshi, Lalita figures); voices to Bindu Feed |
| G5-0070 | beneath | Eyelids that open only on the inhale | placed | B36 |
| G5-0085 | relationship | Persons tier ('and the field turns to you') | placed | R14 |
| G5-0111 | beneath | Hold to read (G1) | placed | B42 |
| G5-0113 | beneath | The Descent (paper lifts, dark wells up) | placed | B01 |
| G5-0114 | beneath | A dark room shown on the paper page | placed | B02 |
| G5-0116 | beneath | The Still Point (G10) | placed | B37 |
| G5-0135 | beneath | The chime ladder (Pythagorean on 256) | placed | B13 |
| G5-0140 | beneath | The wandering point (presence, not target) | placed | B09 |
| G5-0170 | relationship | Readiness sensed; crossing chosen | placed | R11 |
| G5-0207 | beneath | Laying something down (gates of release) | placed | B23 |
| G5-0211 | relationship | Breathing on the wall clock | placed | R06 |
| G5-0225 | relationship | Placement by grammar (the Capture) | placed | R28 |
| G5-0228 | relationship | See before you reach | placed | R16 |
| G5-0229 | relationship | Tempo per room | placed | R16, R37 |
| G5-0230 | relationship | Missing is absent; every way of acting at the same weight | placed | R24 |
| G5-0231 | relationship | The strike that stays | placed | R24 |
| G5-0232 | relationship | The ceremony grammar (a ceremony from three facts) | not this world | time (ceremony grammar) |
| G5-0263 | beneath | Figure family PATH (road of stations) | placed | B31 |
| G5-0267 | beneath | Figure family WATER (calm) | placed | B16 |
| G5-0279 | beneath | Five scene vocabularies for 21–33 | not this world | the-33 (scene vocabularies 21–33) |
| G5-0295 | beneath | 'Not Repair — Birth' (Shadow → Armin) | not this world | the-33 (Shadow → Armin passage) |
| G5-0307 | beneath | The Ten Mahāvidyās as a sister set | placed | B40 (held, Q-B1) |
| G5-0312 | beneath | Beneath's practices (Bardo, Phowa, Maranasati, Chöd, Dzogchen, Mahamudra, Vipassana, Tonglen, fire kasina) | placed | B31 |
| G5-0313 | beneath | Anatta, held against every map | placed | B38 |
| G5-0314 | relationship | Ho'oponopono and Gratitude for the Well | not this world | well (Ho'oponopono, Gratitude) |
| G5-0328 | relationship | Designed but unbuilt (app's own exports) | merged into | R01, R30 (Relationship Field threads); rest → time, modes, rings, mandala, her-home, climb |
| G5-0329 | relationship | The Relationship Field was 'left behind (held)' in the skills | placed | R4 (settled S-R1: private device only) |
| G5-0338 | relationship | Law 25: a presence is one identity, seen whole | placed | R37 (law 25) |
| G5-0357 | beneath | S7 Guide shape | merged into | B37 (with B02, B42) |
| G5-0374 | relationship | A hue from a name | placed | R05 |
| G5-0375 | relationship | Occasion, not interval | placed | R26 |
| G5-0390 | relationship | Listening rings and the kept object | placed | R28 |
| G5-0408 | relationship | The rose window of who gathered | placed | R36 |
| G5-0411 | beneath | A vow arrived, or still living | placed | B22 |
| G5-0416 | beneath | The Shepard fall | placed | B15 |
| G5-0426 | relationship | Company by distance | merged into | R04 |
| G5-0431 | beneath | The arch in three states | placed | B23 |
| G5-0444 | relationship | People threaded into a figure | placed | R01 |
| G5-0449 | relationship | Day card (notice = hollow dot) | placed | R13 |
| G5-0453 | relationship | Two become a third | placed | R30 |
| G5-0462 | relationship | Ten ceremonies of a day | not this world | time (ten ceremonies of a day) |
| G5-0473 | relationship | Tiered roster / tiered arrival | placed | R01 |
| G5-0474 | relationship | Each voice on its own clock | placed | R06 |
| G5-0478 | relationship | Earthed self disc; authorship by colour | placed | R23, R28 |
| G5-0487 | relationship | Token family Lalita (lalita chassis) | placed | R37 |
| G5-0493 | beneath | Token family Learning (learning chassis) | placed | B10 (tokens, §B1.7) |
| G5-0496 | beneath | Token family Blink (blink chassis: fifteen temperatures) | placed | B06 |
| G5-0509 | relationship | Family archetype palette (arch, sid, ash, shared, akas, waz) | placed | R05 |
| G5-0526 | beneath | Visual language for Beneath: blink (temperatures warming toward the point) + learning dark | placed | B06 (§B1.7) |
| G5-0527 | relationship | Visual language for The Relationship Field: lalita night / paper (a Person) | placed | R37 |
| G5-0532 | relationship | Family Constellations / Ancestral trauma as the Relationship Field's shape | merged into | R20 (stance vocabulary); stories to Bindu Feed |
| G5-0556 | relationship | The wall: publish what was learned; keep what it was learned from | placed | R4 privacy (floor applied) |
| G5-0578 | relationship | A Strange Story layers = archetypes | not this world | the-33 (A Strange Story layers) |
| G5-0586 | relationship | Person colours, temperatures and tints | placed | R05 |
| G5-0592 | beneath | Atlantis build–hold–erode (a dissolution mechanic) | placed | B25; Atlantis text to Bindu Feed |
| G5-0593 | relationship | Two-stream convergence (Humanity) with three feels | to Bindu Feed | convergence words; mechanism → the-33 room 29 |
| G5-0594 | relationship | Vibrating heart at 0.1 Hz | placed | R24 |
| G5-0595 | relationship | Two tones converging to Om (132 + 140 → 136.1 Hz) | placed | R08 |
| G5-0604 | relationship | Infinity gateway (two surfaces as a figure-eight) | placed | R30 |
| G5-0613 | beneath | Gate 2 guidance line ('dark room · full screen · unhurried') | placed | B03 |
| G5-0641 | beneath | Cursor/touch presence in dark worlds | placed | B08 |
| G5-0645 | beneath | Gaia card aurora (seven-colour sweep) | not this world | the-33 (room 32 surface, sealed) |
| G5-0646 | relationship | Two lights: independent shimmer, synchronised pulse | placed | R06 |
| G5-0662 | beneath | Dark/Light split world | not this world | the-33 (Shadow → Armin threshold) |
| G5-0669 | relationship | Vantages: people at vertebrae | placed | R33 |
| G5-0670 | relationship | Gaia's vertebra: vantage 10 vs reveal 32 | placed | R33 (settled S-R8) |
| G5-0681 | beneath | Horizontal scroll for the fall ('the movement IS meaning') | not this world | the-33 (the fall's horizontal scroll) |
| G5-0682 | relationship | Person filter dimming | placed | R31 |
| G5-0684 | relationship | Constellation map with 'Place me' | placed | R14 |
| G5-0690 | beneath | Om pattern: always playing; the crescendo is noise decreasing | placed | B12 |
| G5-0692 | beneath | Async Mirror: 8 stations, K/W/A written out | not this world | climb (Panel 9 Mirror stations) |
| G5-0696 | relationship | One place where all colours blend (three-colour convergence) | placed | R10 |
| G5-0722 | beneath | Topic: Bonus: Safe Place (with background, no music) (L-1204) | placed | B28 |
| G5-0727 | beneath | Topic: 6.6 Mindful Exercise: Leaves on a Stream (L-1067) | placed | B16 |
| G5-0791 | relationship | Topic: 10.1 Creating Connection (L-1080) | not this world | sister app Bindu Learning (L-1080) |
| G5-0832 | beneath | Topic: Bonus: Safe Place Exercise (L-1206) | placed | B28 |
| G5-0854 | beneath | Topic: 6.1 Simple Mindfulness (L-1062) | placed | B28 |
| G5-0857 | beneath | Topic: Bonus: Stream Of Light Exercise (L-1207) | placed | B28 |
| G5-0872 | beneath | Topic: Ego Death (L-1349) | to Bindu Feed | Ego Death (story; ruling 2 seal) |
| G5-0896 | beneath | Topic: Advait Vedanta (L-1381) | to Bindu Feed | Advaita story; its ground is B38 |
| G5-0929 | beneath | Topic: Bonus: Safe Place Exercise Without Music (L-1205) | placed | B28 |
| G5-0972 | beneath | Topic: The Brain Dump: An Emotion Coping Activity (L-1088) | not this world | well (Brain Dump, inner practice) |
| G5-0995 | beneath | Topic: Sri Vidya - The Goddess Tradition (L-1454) | to Bindu Feed | Sri Vidya fable; lineage → mandala |
| G5-1008 | beneath | Topic: 3.3 Safe Place Exercise Introduction (L-1021) | placed | B28 |
| G5-1010 | beneath | Topic: 3.4 Drawing Safety (L-1023) | not this world | well (Drawing Safety) |
| G5-1048 | relationship | Topic: Karva Chauth (L-1369) | not this world | time (Karva Chauth) |
| G5-1060 | beneath | Topic: Bonus: Safe place (with background and music) (L-1203) | placed | B28 |
| G5-1061 | beneath | Topic: 3.3 Safe Place Exercise (L-1022) | placed | B28 |
| G5-1092 | beneath | Topic: Happy Place Meditation: Relax and Fall Asleep Faster (L-1056) | placed | B28 |
| G5-1095 | beneath | Topic: Dzogchen - The Great Perfection (L-1403) | placed | B31 |
| G5-1108 | beneath | Topic: The Ten Mahavidyas | placed | B40 (held) |
| G5-1113 | beneath | Topic: The Bardo Thodol - Tibetan Book of the Dead | placed | B31; narrative to Bindu Feed |
| G5-1119 | beneath | Topic: Kali - The Dark Mother | merged into | B40 (Kali); fable to Bindu Feed |
| G5-1124 | relationship | Topic: Hawaiian Ho'oponopono - Cleaning the Lineage | not this world | well (Ho'oponopono lineage) |
| G5-1130 | relationship | Topic: Mark Wolynn - Ancestral Trauma & Epigenetics | to Bindu Feed | Mark Wolynn |
| G5-1131 | beneath | Topic: Anatta - The Doctrine of No-Self | placed | B38 |
| G5-1136 | beneath | Topic: Stephen Levine - Conscious Dying | to Bindu Feed | Stephen Levine |
| G5-1146 | beneath | Topic: Kashmir Shaivism - Abhinavagupta | to Bindu Feed | Kashmir Shaivism story; recognition lines stay in mandala |
| G5-1148 | beneath | Topic: The Dark Night of the Soul - St. John of the Cross | to Bindu Feed | Dark Night of the Soul |
| G5-1155 | beneath | Topic: Mahamudra - The Great Seal | placed | B31 |
| G5-1156 | relationship | Topic: Tonglen - The Compassion Practice | not this world | modes (Tonglen) |
| G5-1167 | beneath | Topic: Phowa - Conscious Dying Practice | placed | B31 |
| G5-1177 | beneath | Topic: Maranasati - Death Awareness Meditation | placed | B31 |
| G5-1200 | beneath | Topic: Jungian Shadow Work | merged into | B24 (shadow work); passage to Bindu Feed |
| G5-1202 | beneath | Topic: Tibetan Chod - Cutting Through | placed | B31 |
| G5-1207 | beneath | Topic: Aghora - Tantric Cremation Ground Practice | to Bindu Feed | Aghora |
| G5-1209 | relationship | Topic: Bert Hellinger - Family Constellations | to Bindu Feed | Bert Hellinger |
| G6-0480 | beneath | Map · Threshold Architecture (field family) | not this world | the-33 (Threshold Architecture) |
| G6-0482 | beneath | Map · URL (field family) | placed | B20 (outside door, Map URL) |
| G6-0570 | beneath | Map gift #14 · The Shadow corridor, whole | not this world | the-33 (room 9 Shadow corridor) |
| G6-0578 | relationship | Map gift #22 · The Euphoria Pulse | placed | R24 |
| G6-0585 | beneath | Map gift #32 · Three threshold passages, named | not this world | the-33 (three threshold passages) |
| G6-0596 | relationship | Map gift #43 · Send love into the field | placed | R24 |
| G6-0625 | relationship | ASG table · Gaia | placed | R33, B26 (Gaia table data) |
| G6-0626 | relationship | ASG table · Identity | placed | R17, R33 (Identity table data) |
| G6-0641 | relationship | ASG table · Relationships | placed | R03, R32 (Relationships table) |
| G6-0642 | relationship | ASG table · Special Days | placed | R12 (Special Days read) |
| G6-0646 | relationship | ASG table · Timeline | placed | R12 (Timeline read) |
| G6-0649 | relationship | ASG table · The Feed | not this world | bindu-feed (The Feed table) |
| G6-0652 | relationship | ASG table · Family Links | placed | R30 (Family Links) |
| G6-0654 | relationship | No person table links to a Śakti or chakra | placed | R03 (settled S-R3) |
| G6-0656 | relationship | Relationships · counts and fill | placed | R04 |
| G6-0657 | relationship | Relationships · Influence Magnitude ranking (only ranking that exists) | placed | R04 |
| G6-0658 | relationship | Relationships · Identity Role (how he stands toward each person) | placed | R17 |
| G6-0659 | relationship | Relationships · Family (19), Self, Staff, Partners, Guides | placed | R04 |
| G6-0660 | relationship | Relationships · Codex and Gratitude density (weighting) | rejected | floor: nothing scores him (no glow weighting by link density) |
| G6-0661 | relationship | Person ↔ archetype mapping exists only by name | placed | R33 (settled S-R3) |
| G6-0662 | relationship | Special Days · shape | not this world | time (Special Days shape) |
| G6-0663 | relationship | Timeline · shape and emptiness | not this world | time (Timeline shape) |
| G6-0698 | relationship | Builds · Bindu Songs (chakra, family) and Axis Songs | placed | R25 |
| G6-0699 | beneath+relationship | Builds · Person and family builds | placed | R39 (outside doors); artifacts to Bindu Feed |
| G6-0700 | relationship | Builds · Planned Play pages naming Mandala-adjacent spaces | not this world | game (planned play pages) |
| G6-0711 | relationship | Identity Archetype declaration · Karishma | placed | R33 |
| G6-0712 | relationship | Identity Archetype declaration · Sid | placed | R33 |
| G6-0713 | relationship | Identity Archetype declaration · Bindu | placed | R33 |
| G6-0714 | relationship | Identity Archetype declaration · Lalita | placed | R33 |
| G6-0715 | relationship | Identity Archetype declaration · Arch | placed | R33 |
| G6-0716 | relationship | Identity Archetype declaration · Gaia | placed | R33 |
| G6-0717 | relationship | Identity Archetype declaration · Sakshi | placed | R33 |
| G6-0718 | relationship | Identity Archetype declaration · Ashrey | placed | R33 |
| G6-0719 | relationship | Identity Archetype declaration · Higher Self | placed | R33 |
| G6-0720 | relationship | Identity · Voices, Configurations, Roles | placed | R17, R33 |
| G6-0722 | beneath+relationship | Learning · yantra and relationship topics | merged into | B28, B31 (Learning titles); relationship topics → R6 / not copied |
| G6-0725 | relationship | ASG gift #1 · The inner ring of six (+ Neev, Shweta) | placed | R33 (no new field, S-R3) |
| G6-0726 | relationship | ASG gift #2 · Each person carries a Śakti | placed | R32 (local store, S-R3) |
| G6-0727 | relationship | ASG gift #3 · Rings of nearness from Type of Influence | placed | R04 |
| G6-0728 | relationship | ASG gift #4 · Couples and children as constellations | placed | R30 |
| G6-0729 | relationship | ASG gift #5 · Portrait depth as brightness | placed | R11 |
| G6-0730 | relationship | ASG gift #6 · The daily-room people | not this world | today-rite (daily-room people) |
| G6-0731 | relationship | ASG gift #7 · 'Shared with' as offering | placed | R28 |
| G6-0732 | relationship | ASG gift #8 · Passed, rendered as Notice | placed | R13 |
| G6-0733 | relationship | ASG gift #9 · The Family configuration line | placed | R15 |
| G6-0734 | relationship | ASG gift #10 · Roles as the way he stands toward each person | placed | R17 |
| G6-0735 | relationship | ASG gift #11 · The year ring | not this world | time (year ring) |
| G6-0736 | relationship | ASG gift #12 · Lead Time as a soft approach | placed | R12 |
| G6-0746 | beneath | ASG gift #22 · The Builds as a map of everything made | not this world | memory (made layer) |
| G6-0749 | relationship | ASG gift #25 · Family songs | placed | R25 |
| G6-0750 | beneath | ASG gift #26 · Enclosures 1–9 and Vertebrae 1–33 on the web | placed | B20 (outside door) |
| G6-0751 | relationship | ASG gift #27 · Gratitude for a person returns as that person's light | placed | R41 (held, Q-R1) |
| G6-0760 | beneath | ASG gift #36 · Witness Perspectives with Unlock Trigger | placed | B26 (first line); full bodies to Bindu Feed |
| G6-0762 | beneath | ASG gift #38 · L-1537 (102 Shaktis research) and L-1533 (16 Karṣiṇīs) | not this world | her-home (L-1537 / L-1533) |
| G6-0768 | relationship | ASG C2 · Lalita Family's relational fields designed but empty | placed | R03 (settled S-R15) |
| G6-0769 | relationship | ASG C3 · Neev and Ashrey have no birthday row | placed | R12 (settled S-R15) |
| G6-0772 | relationship | ASG C6 · Gratitude ruling scopes one column | merged into | R41 |
| G6-0773 | relationship | ASG C7 · Walks and the Mandala | placed | B21 (settled S-R13, no person) |
| G6-0778 | relationship | ASG C12 · Gaia Archetype Position labels inconsistent | not this world | data (label cosmetics) |
| G6-0779 | relationship | ASG C13 · Relationships mixes 34 Authors with people | placed | R03 (settled S-R4) |
| G6-0791 | relationship | Code core · ShaktiFactsCache.swift (211) · live Score per Śakti | not this world | her-home (ShaktiFactsCache) |
| G6-0792 | relationship | Code core · ShaktiBootstrap.swift (303) · offline seed of the 16 Karṣiṇīs | placed | R02 |
| G6-0814 | beneath | Code core · RingAudioService.swift (838) · the field's voices | placed | B12, B15 (RingAudioService reuse) |
| G6-0827 | relationship | Code core · RiteDay.swift (344) · three doors, grace, Sakshi close | not this world | today-rite (RiteDay) |
| G6-0829 | beneath | Code core · TreeOfLife.swift (229) · ring grammar | placed | B12 (Om floor formula reuse) |
| G6-0832 | relationship | Code core · TrinityOfGuidance.swift (186) · five faces | placed | R33 |
| G6-0873 | relationship | Code gift #5 · Kīrtan / bhajan heart register with call-and-response | not this world | modes (kīrtan heart register) |
| G6-0875 | beneath | Code gift #7 · Vāk 12-voice chord + Ring 8 triad unite + Shepard fall-through | placed | B15 |
| G6-0882 | relationship | Code gift #14 · Grace including the sister apps | not this world | today-rite (grace across sister apps) |
| G6-0893 | beneath | Code gift #25 · Tree of Life ring grammar | merged into | B15 (reuse); ring grammar → rings |
| G6-0895 | relationship | Code gift #27 · Trinity of Guidance faces | placed | R33 |
| G6-0899 | relationship | Code gift #31 · Related Śaktis → the sister door | not this world | her-home (sister door) |
| G6-0915 | relationship | Code missing · No Relationship Field | placed | R40 |
| G6-0916 | beneath | Code missing · No Beneath model | placed | B41 |
| G6-0933 | relationship | Code C-7 · Ruling 6: Sid, Arch, Karishma, Ashrey absent | placed | R33 (settled S-R9) |
| G6-0934 | relationship | Code C-8 · Ruling 10 Relationship Field vs register | placed | R40 (settled S-R1) |
| G6-0950 | relationship | Code C-19 · Ledger semantics for new rooms | placed | R40, B41 (ledger Gesture Sources) |
| G6-0968 | beneath | Homes file · TheBuilding.swift (657) | placed | B07 (Glissando reuse); TheGates / Praveśa → climb / rings |
| G6-0990 | beneath | Homes file · DissolveRoom.swift (608) | not this world | her-home (kp 102 DissolveRoom) |
| G6-1067 | beneath | Homes upgrade C6 · Descent: restore station objects and the Rite's chambers | placed | B19 |
| G7-0087 | beneath | MaunaView visual composition | not this world | home (MaunaView; S-B11) |
| G7-0088 | beneath | Mauna lines (his) | not this world | home (Mauna lines); 'Who is saying that?' reused in B26 |
| G7-0089 | beneath | Mauna leaving and fall to Lalita | not this world | home |
| G7-0091 | beneath | StillnessAtTheCentre rules | not this world | home |
| G7-0207 | beneath | Move off the Mandala: Mauna, Pointy, Pravesa | not this world | home (moved off the Mandala; S-B11) |
| G7-0320 | beneath | TheDescent five stations | placed | B19 |
| G7-0408 | relationship | Designed piece: Sketchbook: Talk | placed | R33 |
| G7-0456 | relationship | Talk ring of ten vantages | placed | R33; dialogue partly to Bindu Feed |
| G7-0494 | relationship | Sangha 'ruled out' in code | placed | R34 |
| G7-0534 | beneath | The River (Correspondence) | not this world | well (the River) |
| G7-0535 | beneath | Light sent back and higher-self name | not this world | well (light sent back, higher-self name) |
| G7-0536 | beneath | Archive as a book | to Bindu Feed | Archive as a book (also memory); its 'go down' door lands at B35 |
| G7-0541 | beneath | Descent film | placed | B35 |
| G7-0544 | beneath | The Well: letters to all 102 | not this world | well (letters to all 102) |
| G7-0545 | beneath | Well is a list page off the hamburger | not this world | well (list page defect) |
| G7-0555 | beneath | HerWitnessPage: One-Page Answer and Witness Page | placed | B26 |
| G7-0559 | relationship | Field Connections: only relationship data | placed | R02, R42 |
| G7-0591 | beneath | Beneath not built as a world | placed | B41 |
| G7-0592 | beneath | Beneath as one underground space | placed | B41 (the world itself) |
| G7-0593 | relationship | Relationship Field not built (seed only) | placed | R01 |
| G7-0594 | relationship | Relationship Field in full | placed | R01–R32 |
| G7-0595 | relationship | Relationship data: Design's two people tables disagree; ring-2 local indices | placed | R40 (settled S-R6) |
| G7-0596 | relationship | Sangha restored inner and outer | placed | R34 |
| G7-0635 | relationship | Snapshot baseline: settings.geom | placed | R02, R40 |
| G7-0694 | beneath | HomeDescentTests | placed | B19 |
| G7-0931 | relationship | New test: Relationship Field built in full | placed | R40 |
| G7-0961 | beneath | Test gift: TheGates two-way exchange | not this world | climb (TheGates exchange) |
| G7-0963 | beneath | Test gift: 'Who is saying that?' | placed | B26 |
| G7-0966 | beneath | Test gift: Pravesha endless fall | not this world | home (Praveśa deep zoom) |
| G7-0970 | beneath | Test gift: Falling mantra RingBija | not this world | mandala (falling RingBija) |
| G7-0982 | beneath | Test gift: Descent beneath her room | placed | B19 |
| G7-0994 | beneath | Test gift: TrinityOfGuidance faces | merged into | R33 (Trinity faces extended); seats → her-home / climb |
| G7-1001 | relationship | Test gift: GraceChannel across sister apps | not this world | today-rite / memory (GraceChannel) |
| G7-1013 | relationship | Test gift: Somatic body map | not this world | her-presence (somatic body map; reused in B29) |
| G7-1017 | relationship | Test gift: Settings' remembered words | placed | R02 |
| G7-1033 | beneath | Gating surviving in mechanisms | placed | B19 (gating lifted) |

**Script result** (`scratchpad/bnr/build.py`, run 13 Oct 2026):
```
slice rows: beneath 177, relationship 218, unique ids 391 (4 ids in both slices)
mapped 391; missing 0; extra 0; invalid category 0; element refs not in ledger 0; ledger elements absent from §2 tables 0
by category: merged into 14, not this world 95, placed 257, rejected 8, to Bindu Feed 17
ledger rows written: 84 (B 42, R 42)
CHECK PASS
```
