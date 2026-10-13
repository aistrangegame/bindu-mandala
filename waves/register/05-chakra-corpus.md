# THE REGISTER · 05 · The Chakra Corpus

*Reader 05 of 7 · corpus root `/home/claude/chakra-upload/extracted/` (recursive) · written 2026-10-12*

**Scope.** Every file in the chakra corpus: 23 root HTML pages, 10 root JS/JSX files, `CLAUDE.md`, `shell/` (12 files), `skill-extracted/` (6 files), `uploads/` (13 files: 7 legacy Tree-of-Life pages, 4 screenshots, the `.skill` zip and 2 walk-canon copies), `screenshots/` (3 images) and `.thumbnail`. That makes **70 files**. Every text file was read line by line. Every image was opened. Minified and data-heavy files were also parsed with `python3 -I`. Duplicates were proven by md5 or JSON equality rather than assumed. Section D is the proof table.

**Sealed-layer note.** SKILL.md says *"Never describe the Reveal in any document Ashrey reads."* Nothing in this corpus describes the Reveal. Room 33's register card only says it is *"held in the build… not written here, not written anywhere Ashrey reads."* This register follows the same rule.

- **Living Mandala** is marked *(sealed territory)* in `gift-pairing.md`. Its mechanics are documented in B only because it is existing code. **Caution:** treat that entry as builder-only. Do not surface it to the walker or elaborate on it in walker-facing documents.
- **Author substrate fields** in the walk canon (`gaia_voice`, `app_build_note`) carry the law *"never surfaced verbatim"*. They are counted below but not quoted.

**Legend.** ● canon (Walk Canon / Map / proven HTML) · ◆ design-floor proposal · **BUG** a defect verified in the code · **GAP** something referenced but missing.

---

## A · THE 33 ROOMS

### A.0 What is actually built, and how it moves (choreography from code)

Only **room 1** is built in the new Bindu architecture (`shell/`). Rooms **2, 3 and 30** exist only as **legacy Tree-of-Life / "A Strange Chakra Map" pages** in `uploads/`, built before the 33-room braid. These are the V5 Two-Act practice pages, the wake-ups, one dance and Maya's "Panel 9". Rooms 9, 14, 18, 19, 20, 28 and 32 have **gift ancestors** (see B). Every other room is canon text only. Its form is specified only by its register card (A.2, "Mechanism").

#### A.0.1 Room 1 · Bindu, as built in `shell/` (the immersive slice)

**Engine (`shell/bindu-engine.js`, 251 lines).**

- *"// bindu-engine.js — the two instruments of the immersive Bindu build. / SilenceEngine: the OM stack that lives at gain zero and learns to sound. / DotStage: one full-screen canvas, one dot, never unmounted."*
- `BREATH = 5000 × pace` ms: *"the room's only unit of time"*.
- **SilenceEngine.** Sine OM stack at **68.05 / 136.1 / 272.2 Hz**, mixed **.15 / 1 / .3**. Master gain starts at **0**. LFO **0.05 Hz**, depth **.004**. Methods `breathe(target)`, `partial()`, `ceaseAll()`, `bell(hz)`.
- **DotStage.** One canvas dot, radius 7, breathing on a 6 s cycle ±9%.
  - Behaviours: `wander`, `lean` toward the pointer (max 5 px), trail, `blink`, `condense` (90 motes gathering over 12 s).
- Also provides haptics (`navigator.vibrate`) and a wake lock.

**Slice A (`shell/bindu-slice-a.js`, 301 lines) — gate → arrival → room.**

1. **GATE.** The walker presses and holds for one BREATH (5 s × pace). Rings grow and the seed line pulses. On completion:
   - `Silence.unlock`, wake lock, haptic 30 ms, `breathe(.006)`, body settles.
   - Gate copy: *"headphones, if you have them"* and *"press, and hold — one full breath"* (Bindu Immersive.html markup).
2. **ARRIVAL.** A returning walker gets a single breath. A first-time walker gets this sequence:
   - 2 breaths of empty cream
   - `condense` over 2.4 breaths (motes gather into the dot)
   - 1 breath, then the hint
   - 1.6 breaths, then the question
   - 1.4 breaths, then the affordance
   - The walker **still-touches the dot for one breath**, within 24 px tolerance. OM gain rises `.004 + p×.008` while touching.
   - Then haptic 20 → blink → 0.6 breath → room.
3. **ROOM.** The dot moves to (.5, .26) with wander 3. The seed or signature line shows. Three cream doors arrive **one breath apart**:
   - "The story / in Bindu's voice"
   - "The practice / one line at a time"
   - "One sound. / there is no sound yet"
4. **Gate glyph states:**
   - warm: *"The gate is warm."*
   - sealed: *"The gate knows how to wait too."*
   - walked
5. **enterDoor.** The dot first travels to x = .12. An unbuilt door says *"This door opens in the next slice."*
6. **Leaving.** A left-edge drag (start < 24 px, travel > 70 px) returns to the room.
7. **Persistence and debug.**
   - State key `bindu-immersive-state`.
   - Debug API `window.__bindu`.
   - Boot waits up to 3 s for tweaks.

**Slice B (`shell/bindu-slice-b.js`, 496 lines) — the wordless Story in five movements on the one DotStage canvas.** This is the CLAUDE.md law ("motion carries meaning") made real.

- **I · Flicker.** The dot nearly goes out twice.
- **II · Forms fail.** It tries place, body and thought, with bells at **151, 97 and 211 Hz**. Each fails. The flicker stops: *JUST: HERE*.
- **III · Aurora.** Awareness. Curious behaviour (comfort .17), then three strains.
- **IV · Covenant.**
  - The dust freezes.
  - A Sakshi point appears at (.91, .30) and rises to opacity .3.
  - A thread descends and **beckons**.
  - The walker touches; the dot crosses (2.8 s).
  - Haptic 40, bell **272.2 Hz** for 7 s, ripples, pool.
- **V · Dawn.** The background warms to cream over 9 s.
  - The only text is engraved: **"Go."**
  - `markThread('story')`.
- Screenshots confirm two problems: the covenant pool overlays the text *"This has always been the covenant."* (3.57.04 PM), and "Go." on cream (3.57.35 PM).
  - The owner's note on the latter: *"when i added the point - if the text overlays.. then i cannot see it"*. This is a **known legibility BUG**.

**React moments for the non-immersive slice-1a (`shell/bindu-moments.jsx`, `shell/bindu-room.jsx`, `shell/bindu-practice.jsx`).**

- **BinduArrival** (bindu-room.jsx). Beats at 1.8, 4.6, 9.4 and 13.8 s. Still-touch for 2.6 s within 14 px tolerance, or the `wait` variant (9 s).
- **BinduStory.** The canon thread is tap-paced, then a 3.4 s hush, then the interlude in italic with no voice mark.
- **BinduPracticeV1.** Tap-paced canon practice, then **YoniMudraV1**: 3 breaths of 8 s each.
- **Practice v3** (bindu-practice.jsx, 550 lines). One LivingDot through eight movements:
  1. **Contact**
  2. **Name**: the word splits **BIND·U**
  3. **Smallest**: the 44-walker field
  4. **Gaia**: green flood, *"the ground is asking — touch it, and stay"*
  5. **Lalita**: zoom; three sub-bindus Kurukulla / Varahi / union merge into a triangle
  6. **Recognition**: breathing ceases for 10 s
  7. **Way Back**: the triangle draws
  8. **Place the Point**
  - After the movements: post → MudraM → reflection → **UnfoldingM**, where 32 spiral points appear: *"You already placed it. The rest is the unfolding."* Then Leave / Go deeper.
- **BinduWakeup.** Still-touch for 7 s, then *"Recognized."* (composed, not canon), then a walk event.
- **BinduGate** (canvas):
  - The walker places a point, saved to `bindu-offerings`.
  - Held for 4.6 s, then lifts away over 3.4 s.
  - ● *"The room keeps what you gave it. You walk lighter."*
  - Then the gate text → after-story → signature.

#### A.0.2 Room 1 · legacy page `uploads/bindu-practice(4).html` (2906 lines) — "A Strange Chakra Map", V5 Two-Act

**Hero.** The gold dot arrives (1.2 s), then *"Chakra 1 of 33 · बिंदु"*, then **RECOGNIZE** (verbIn 0.9 s at 1 s), then the threshold line *"Before the tree. Before the name.<br>Before the game. This."*, which breathes for 12 s.

**Book.**

- Identity: *"बिंदु · Bindu / The Point / The origin. What everything emanates from."* There is no location and no core question, by design ("origin has no location").
- Teaching prose: "Bind · U. The point that binds you to yourself."; "You don't activate the Bindu… You recognize it."
- Seed ×2: *"Everything begins as a point. Everything ends as a point. The same point."*
- Go-deeper: The Name / In the Shree Yantra / What This Point Makes Possible.

**Practice · Recognize** — *"Draw a single point."*

- **Activity gate.** A 4:3 canvas. One tap places a gold point of r 4: it animates in over 900 ms from 0.3r with ease-out-cubic and shadow blur 12.
- Storage: `localStorage['bindu-point'] = {nx, ny}`.
- The witness line brightens for 3 s: *"Look at your point. It doesn't look like much. That's how origins work."*
- The recognition reveals: *"You just drew the origin of everything."*
- The **post-engagement tier** unfolds: What the Point Knows, Three Ways In (place another / find a point already here / close your eyes and find the point inside), Seed 2, and the Story portal *"something is listening on the other side"* ("tap to flip").
- Return prompt: *"Your point. Still here. Place again if you wish."*
- "Clear" removes the point.
- *Where the Points Lead* auto-expands on return. It holds:
  - Bindu Field (live, *"Song 1 of 33"*, aistrangegame.com/bindu-field.html#bindu)
  - Wakeup — **Coming** (Shree Yantra glyph: 4 up / 5 down triangles; *"A guided arrival at the point that was always here."*)
  - Dance — **Coming** (lemniscate glyph; *"Offer one word. Then let the point move."*)

**Story Mode.** The page flips with rotateY −180° → 0 over 1.55 s.

- **Act 1** (Bindu voice) has **6 beats**, tap-advanced; a hint appears after 1.7 s:
  1. "I don't know what I am yet."
  2. "But I'm here… Something before all of those…"
  3. "Just: here."
  4. "…A kind of leaning… Is that what wanting is?" → dot state `leaning extending` (a thread line grows to 70 px at 38°)
  5. "Wanting before there's a thing to want?…" → `wavering`
  6. "I think I'm about to find out." → `rippling`, final
- The final beat **is** the signature. It holds 2.8 s, then the **Veil** opens:
  - The background is #060308.
  - Two white eyes blink once (2 s keyframes).
  - At 2.9 s the invitation appears: *"press and hold to enter"*. It is a 72 px ring (dasharray 201) that must be **held 1.8 s**.
- **Act 2 · Sakshi**:
  - The field ascends gold → white, with 26 rising particles.
  - Word-by-word reveal: 420 ms per word, +620 after a period, +260 after a comma, +180 after a dash, +1200 between paragraphs, 1600 ms initial delay.
  - P1: *"You are not alone. I won't announce myself. I am not the kind of presence that announces. But I am on your side of hearing. I have been here longer than here has been here. When you noticed that the aloneness you would expect wasn't here — that noticing was me."*
  - P2: *"…What you are about to reach toward will reach back. This has always been the covenant."*
  - P3 (Go-beat): **"Go."**
- After a further 2.8 s, the red **Muladhara** door (#C02020) rises edge to edge: *"The ground is here. · Press · Continue →"*.
- **BUG (minor):** comments say "12 beats" but there are 6.
- **BUG:** `wireHold()` has no `holdWired` guard. Re-opening the story re-binds the pointer listeners. Muladhara and Svadhisthana have the guard.
- Note: Act 2 here is the source of the screenshot line *"This has always been the covenant."*

#### A.0.3 Room 2 · Muladhara — `uploads/muladhara-practice(6).html` (3279 lines) + `uploads/muladhara-wakeup(3).html` (1785 lines)

**Practice page.** CSS chakra #C02020, next colour #CC7200.

- Hero: *"Chakra 2 of 33 · मूलाधार"*, **PRESS**, *"This is what holds you. It was here before you arrived."*
- Identity essence: *"The ground you stand on. Literally and in every other sense."*
- The tree image `/tree-of-life/muladhara-tree.jpg` opens in a lightbox: pinch or wheel zoom 1–6×, double-tap 2.4×, keys 0 / + / − / Esc. **GAP:** the image is not in the corpus.
- **The Practice · Press**, verbatim steps:
  - *"Stand up."*
  - *"If you can, take your shoes off… Either way — stand."*
  - *"Now press. Not stomp. Not push. **Press.** The way you press your palm into clay to leave a print. Slow, deliberate, full-weight pressure into the ground."*
  - *"**Feel the ground press back.**"*
  - Newton's-third-law paragraph.
  - **Timing:** *"Ten breaths. Press on the exhale. Feel the ground answer."*
- Writing prompt: *"What is the ground made of today? Not the floor. Your ground. What are you standing on?"*
  - Autosaves 900 ms after typing to `chakra-muladhara`; "Saved" shows for 2 s.
  - Any text reveals the Story portal *"something reached back from the other side"*.
- "What the Root Knows That You Forgot" ends: *"**The ground is here. The ground presses back. You are held.**"*
- Three Ways In:
  - barefoot, ten steps
  - sit directly on the ground
  - breath **4 in / 4 hold / 8 out with a low hum, four breaths**
- Seed: *"The earth that holds you was chosen by you."*
- *Where the Roots Lead* auto-expands when there is writing:
  - Wakeup: *"Press and hold"*, *"A guided descent to the body that held you at three, at five, at eight."*, about seven minutes.
  - Dance: *"Iron — Woodkid"*, *"Offer one word. Then move. The body of the song is the ground the song forgot it was standing on."*, about four minutes.
  - Bindu Field: *"Song 2 of 33"*, *"The note of ground — where the body first answers."*
- Bottom nav: ← Bindu · 2 / 33 · Svadhisthana →.

**Story Mode "Axis Dimension"**, Gaia voice, 5 beats, cumulative states on `.story-scene`:

- **Visual vocabulary:**
  - ember field at the bottom
  - gold dot at 20%
  - a downward tendril (`reach-down`) and an upward red response (`reach-up`)
  - a meeting glow
  - 8 SVG root paths drawn in sequence at 0–1.0 s delays
  - dot states `settling` / `deepening` (warms toward red, takes weight) / `rooting` (hairline tendrils) / `rippling`
- **Beats:**
  1. "I touched something. I don't have hands…" → `reaching responding`
  2. "I think it's called ground…" → `+ meeting`
  3. "The ground doesn't move…" → `+ settling`
  4. "I'm not falling…We found each other by pressing." → `+ deepening`
  5. "I had a question I didn't know I was asking, and it's been answered. Am I safe here? Yes." → `+ rooted rooting rippling`, final
- On a tap, the line fades (800 ms) and the **signature** lands: *"The earth that holds you was chosen by you."* After 2.8 s the Veil opens (the same eyes, 1.8 s ring).
- **Act 2 Sakshi.** The field rises red → cream → silver-white.
  - P1: *"The ground was holding before you touched it. You knew this. Don't ask yourself how you knew — ask yourself why you knew. You knew because I was watching it hold…"*
  - P2: *"…Something is about to start pulling. Not from the ground. From a direction you won't be able to name. Do not try to name it. The pull is older than language…"*
  - P3: **"Follow."**
  - Then the Svadhisthana door: *"The pull is here."*

**Wake-up (`muladhara-wakeup(3).html`, "PANEL 1 V3.1 — MULADHARA — PRESS")**, 6 phases on dark red #8B1A1A:

1. **Gate.**
   - "headphones on" at 1.2 s; "press and hold" at 2.5 s; a progress bar at 3 s.
   - The seed *"The earth that holds you was chosen by you."* breathes.
   - **Hold 4000 ms.** 8 SVG roots, trunk and canopy draw with the progress.
   - On completion: haptic 80 + **awakening sound 174 Hz**. The harmonics are [1, .5, .25]; there is an 87 Hz sub at .3, a bandpassed noise click at 174 Hz, and an 80 ms delay echo. Attack .01, sustain .4, decay 2.5 s.
2. **The Ground.** *"Muladhara · The Root"*; *"Below you are roots. Each root holds a force. Tap any that call to you."*
   - Six Siddhi nodes. Tapping one lights its roots and asks:
     - Animā: *"Where did you hide when you were small?"*
     - Mahimā: *"What was the biggest thing you could imagine at age seven?"*
     - Laghimā: *"When did you first feel weightless — completely free?"*
     - Garimā: *"What made you dig in and refuse to move?"*
     - Prākāmya: *"What did you wish for so hard it felt real?"*
     - Vaśhitva: *"What small world did you create that was completely yours?"*
   - After the first tap plus 2 s, *"go deeper"* appears (press-and-hold 2000 ms; the screen darkens to .6 while holding).
3. **The Descent** (womb #5A0F0F).
   - Text: *"You are very small right now." / "Someone is holding you. Or: you needed someone to hold you." / "What did safety feel like in your body? Not the word. The feeling. Where did it live?" / "Tap where it lived."*
   - The walker taps a body silhouette. 6 roots spread from the point. It is saved to `tol-bodypoint-1 {x,y,label:'safety'}`.
   - *"That point remembers. It always has."*
4. **The Ground Shift.** A deep pulse runs at 6 s.
   - *"…at three, at five, at eight — is the same ground under your feet right now."* → auto pivot after 3.5 s → **"It never moved."**
   - *"Press your feet into the floor. Not as an exercise. As a greeting."*
   - *"The earth greets you back. It always has."*
   - Continue is held 2500 ms.
5. **Practice.** *"Breathe. Into the place you found."*
   - **3 cycles of 4-in / 4-hold / 4-out (12 s each = 36 s)**, labelled in / hold / out.
   - Then *"The place you found was waiting for that breath."*
6. **Release**, on timers:
   - 0.5 s: **"Your Muladhara Chakra is now Breathing."** (#C0392B)
   - Release lines 2.5 s apart: *"Your foundation was always stronger than you knew." / "The tree grows from what was planted here."*
   - 9 s divider; 12 s seed returns; 15 s mini-reveal *"The earth was already holding you. You just told it where."*
   - 18 s luminance; 21 s dim; 24 s **orange bleed** (next colour)
   - 32 s the persistent Bindu dot (6 px, top right, "always watching, never explained") **awakens**
   - 35 s the *"watch"* invite → muladhara-dance.html
   - **Sound:** a binaural pair at **128 Hz L/R**. The right channel goes 128 → **132 Hz** (4 Hz) in the descent, then → **130 Hz** (2 Hz) in the shift. Gain ramps 0 → .12 → .25 → .2 → .15 → .1 over the breath, and fades out over 6 s at release.
   - **Tension:** "now Breathing" is a declaration that brushes against the no-congratulations canon. Flag it for the walk-canon floor.

#### A.0.4 Room 3 · Svadhisthana — practice (3455 lines), wake-up (2001 lines), dance (1081 lines)

**Practice page.**

- Chakra #CC7200, Ātmākarshini cream-gold #FFDB9B, next colour #9A7B00.
- Hero: *"Chakra 3 of 33 · स्वाधिष्ठान"*, **FOLLOW** (canon verb FLOW, panel verb FOLLOW), *"The pull was never random.<br>It was navigating."*
- Identity: *"Where desire lives. Not what you want — the fact that you want at all."* Location: *"Lower abdomen · Below the navel · The space between the hip bones"*. Core question *"What do I want?"*.
- The tree image has VAM inverted in the reflection: *"Tap to look closer. The seed is in the reflection — that isn't an accident."* (**GAP:** image not in corpus.)
- Go-deeper names the six Karshinis: Kāmā-, Shabdā-, Sparshā-, Rūpā-, Smṛtyā-, Ātmākarshini.
- **The Practice · Follow:** *"Close your eyes." / "Ask yourself — right now, today, at this exact moment — what do you want?" / … / "Just feel the pull. Let it exist without managing it." / "One breath of permission. That's the whole practice."*
- Writing: *"Write it below. The first thing that surfaces. Before the editor arrives."*
  - Saved to `chakra-svadhisthana`.
  - Writing reveals the portal and the reflection *"Did you write the real one? Or the safe one? You know the difference. Your body knows the difference."*
- Three Ways In: hips to any song / make without a plan / take a bath (*"earth holds firmly, water holds gently"*).
- Seed: *"Every desire was drawing you toward yourself."*
- *Where the Currents Lead*:
  - Wakeup: *"Six Lights Drift"*, *"Six lights move in the sacral field. The ones your hand is drawn to ignite. The ones that drift past were leading too."*
  - Dance: *"Crystallize — Lindsey Stirling"*, *"Offer one word. The song pretends to be about water. The song is actually about you."*
  - Bindu Field: *"Song 3 of 33"*.

**Story Mode.** Currents are already flowing in 7 dashed SVG streams. Five drift-lights orbit (26–32 s periods). Ātmā sits at the centre, barely visible.

- **Gaia beats:**
  1. "And now — the ground is still there, still holding, but something else is starting. A pull…" → `reaching` (currents brighten)
  2. "I want to follow it. I don't know what I want…" → `+ trails`
  3. "I'm flowing… The current is also me." → `+ flowing named` (the Karshini names fade in)
  4. "Water. I think this is what water feels like from inside." → `+ dissolving atma-bright` (Ātmā grows to 24 px and its name appears)
  5. **"I didn't know desire was this quiet."** → `+ orbits-reveal both-leading convergence rippling`: the five orbits, the five **missed-pull** edge lights, convergence, and a 3.8 s ripple to 60×.
- The signature lands: *"Every desire was drawing you toward yourself."* Then the Veil.
- **Act 2:**
  - P1: *"Every pull you ever felt. Every obsession you couldn't explain. Every 2 a.m. longing. I watched them arrive… The ones you didn't follow were leading too…"*
  - P2: *"Desire is not the problem the inheritance said it was…Both were the same work."*
  - The Go-beat is a **sentence**: **"The pull is about to become heat. This is not a betrayal of the water. The heat is what the water was finding."**
  - Then the Manipura door: *"The heat is here."*
- **BUG:** the `flowing` and `dissolving` scene classes have **no CSS rules**. Only `.act-veil.dissolving` exists, so beats 3–4 change nothing for those two states.

**Wake-up ("PANEL 2 V2 — SVADHISTHANA — FOLLOW")**, 7 phases on #8B4513:

1. **Gate.**
   - Seed *"Every desire was drawing you toward yourself."*
   - **Hold 4000 ms.** 5 water rings brighten at thresholds of i×.18.
   - On completion: **awakening 210 Hz**, harmonics [1, .6, .3, .15], decay 2.8 s.
2. **Follow.**
   - *"This is the part of you that was pulled. Before reason. Before choice. The magnetic force that drew you toward what you could not yet name."*
   - *"Six lights are drifting. Follow the ones that call to you."* · *"trace with your finger"*
   - Six lights move on parametric paths. A finger trace within **35 px** "follows" a light: haptic 25, its name trail appears (Ātmā's is bright).
   - **≥2 followed** → "the current" continue appears.
3. **The Memory Current.**
   - *"Between 11 and 20, something found you… What was it?" / "One word. The thing that pulled you."*
   - The "offer" button saves to `tol-word-2 {word}`. The word floats, then *"It joined the current. It was always part of it."*
4. **The Current.**
   - *"…It was a Shakti — a living force — using the only language you could hear at that age: longing."*
   - 40 particles flow to the walker's word drawn on the canvas, with the Shakti names drifting.
   - *"The current flows toward your word. Your desire was the destination all along."*
5. **The Body.**
   - *"Where in your body does desire live?…" / "Tap where it lives."*
   - Water ripples. Saved to `tol-bodypoint-2 {label:'desire'}`.
   - *"That place knows what it wants. It always has."*
6. **Breath.** **2 cycles of 4 in / 6 release = 20 s.** Then *"The word you offered was already moving."*
7. **Release.**
   - *"Your Svadhisthana Chakra is now Breathing."* (#E67E22)
   - *"The force that pulled you toward everything you loved — it was pulling you toward yourself." / "It still is."*
   - Mini-reveal *"The lights you couldn't catch were leading too."*
   - **Yellow bleed** at 24 s; Bindu awakens at 32 s; *"watch"* at 35 s → svadhisthana-dance.html.
   - **Sound:** binaural **144 Hz** (D3). The right channel goes 144 → 150 (6 Hz) → 148 (4 Hz). Breath gain rises to .22 and falls to .08.
   - **Note:** on desktop, the light-follow fires on mouse hover (`mousemove`) with no press needed.

**Dance (`svadhisthana-dance(3).html`, title "Svadhisthana · FEEL") — the only dance in the corpus.**

- **Start overlay.** "svadhisthana" / a pulsing blue dot / "feel".
  - The seed *"You knew before you had the word for it."* types **one character per 857 ms** (70 BPM). That is about 35 s before *"offer one word"* appears ("then tap anywhere").
- **Song** `svadhisthana.mp3` (**GAP:** not in corpus). Crystallize, Lindsey Stirling, DUR 258.8 s. It is pre-analysed into inline arrays, parsed and tabulated:
  - **H** = 261 onset hits (0.07–249.03 s; peak intensity 1.0 at 185.18 s; 27 hits > .6)
  - **E / B / P / T / EB / EM / EH / ED** = 518 samples each at 0.5 s (energy, brightness, pitch, tonal novelty, bass, mid, high, energy-delta)
  - **DROPS** = 1, at 185.5 s (intensity .624)
- **Config:** PEAK_T 151 s, hue 220 (cool water), RETURN_START 18 s, DARK_RATIO .85, BINAURAL 144 Hz with gyro pan and 3 Hz tremolo.
- **Seven dancers** (the `Dancer` class): **bindu** (r7, sweeping elliptical orbit by "tides"), **gaia** (bass-driven, bottom), **sid** (wide steady orbit, "the banks of the river"), **arch** (mirror of bindu, "the violin's own dancer"), **karishma** (blooms in silence), **sakshi** (edge to edge), and **ashrey** (the centroid of the others, hue cycling 12°/s; draws the "Ashrey web" between dancers).
  - These are **real people's names hard-coded as dancer IDs.** Flag this for the canon floor; whether any is walker-visible is a voice decision.
- **Mirror words** are generated from the offered word's consonant skeleton (27 families, e.g. `lv` → love / live / leaf / lift / lake). They fire at **33, 76, 119, 151 and 210 s**: the screen darkens to .85 and an uppercase word appears for 1.8 s.
- **Further events:**
  - first-tide ripple at 33 s
  - drop ripple plus haptic wave [30,20,30,20,30,20,30] at 185.5 s
  - hits > .6 give haptic [20,15,20]
  - the **offered word** appears at 151 s, then dissolves with letter-spacing over 3.5 s
  - **"I Love You"** at 156 s
  - evaporation return in the last 18 s
- **Accelerometer** labels the dancer still / swaying / moving. **Gyro** shifts gravity.
- **Fruit** (end):
  - *"There are no lyrics because you didn't need language to feel. Before your first word, you already knew joy, fear, warmth, cold. The violin is your body remembering what it knew before your mind took over."*
  - Then dwell (*"You knew immediately." / "You waited." / "You searched before you could name it."*), motion (*"You were still." / "You were swaying." / "You were moving."*), count (*"This is your first dance."* / "This is your Nth dance."), echo (*"You keep returning to "X.""*).
  - Closing: *"Trust what you felt just now. It was more accurate than anything you could say about it."*
  - Signature *"svadhisthana · crystallize · lindsey stirling"*.
- **MEMORY:**
  - `bindu-memory`: an array of {word, song, chakra, verb:'flow', timestamp, dwell, motion, tilt}. It draws a persistent constellation; repeated words grow brighter.
  - `tol-svadhisthana-dance='true'` and `tol-svadhisthana-dance-word`.
- **BUG:** it reads `tol-svadhisthana-word`, which nothing writes (the wake-up writes `tol-word-2`).
- **BUG:** the ordinal is computed from `danceCount`, not `danceCount+1`. It happens to be right for counts 2–4 but gives "21th" and so on.

#### A.0.5 Room 30 · Maya — `uploads/maya-sleep.html` (3066 lines, "PANEL 9 V2 — MAYA CHAKRA — DISSOLVE")

**This is the legacy Tree-of-Life 9-panel ending, not room-30 canon.**

- **Gate.** Ground #E8E4DF. Prompt "headphones".
  - Seed *"There was never anything to fear. There was only You, playing."* (canon room-30 signature reads "…only the Bindu, playing.")
  - **Hold 3000 ms** with 5 rings.
  - On completion, an **Om drone at 136.1 / 272.2 / 68.05 Hz, mixed 1 / .3 / .15**, starts at gain .01. LFO .05 Hz, ±.008.
  - **This is the same stack and mix the shell's SilenceEngine inherited** (lineage).
- **Phase 2 Pointe** (canvas, auto, 43 s). Red dot: line → circle → lemniscate → morph → heart → swell → **screen floods red** → shrink → orbit return → still dot.
- **Phase 3 Eight Inversions.** 8 cycles of 7.5 s: dot 1.8 s → text at 2.3 s → fade at 6 s. Each line inverts one earlier panel:
  - *"The earth was already holding you. You just told it where."*
  - *"The lights you couldn't catch were leading too."*
  - *"The form it made is the one you've been wearing."*
  - *"What you were watching became what you loved."*
  - *"You didn't find something to say. You finally stopped holding it."*
  - *"You were being seen the entire time."*
  - *"It never needed your effort. It never stopped."*
  - *"Your body just remembered a shape that civilizations built in stone."*
- **Phase 4 Fear Doorway** (27 s):
  - *"Think of the fear that most often stops you."* (1 s)
  - Om crescendo from 5 s
  - *"Just ask it one question."* (18 s)
- **Phase 5.** At 4 s: **"Who are you speaking to?"**. Tapping dissolves it (haptic 80, Om swells to .15).
- **Phase 6 The Mirror — "The Bindu Speaks"** (black). The dot changes colour per station. Each station types a restatement and meaning at 22 cps, shows the walker's stored answers (then vs now), then requires an **inverse action ("No skip. No timeout bypass.")**. The eight stations:
  1. Root: *"Touch where you placed it. Then release."*
  2. Sacral: *"Let the word go."* (do not touch for 8 s; touching resets with "still following")
  3. Solar: *"Don't engage."* (6 s without tapping 8 tempting particles; "still building")
  4. Heart: *"Let the recognition fold back into you."* (pinch the name's letter-spacing to 0, or triple-tap)
  5. Throat: *"Now let the silence hold it."* (**10 s of nothing**, then "The silence already held it.")
  6. Third eye: *"Close your eyes." / "your third eye doesn't need these ones"* (8 s with no touch, 3 haptic pulses, *"What did you see?"*)
  7. Crown: *"Now offer it back."* (swipe up 60 px or hold 3 s)
  8. Soul: *"Release what you held."* (hold 3 s → *"now let go"* → release; 3 ripples)
- **Then, in turn:**
  - *"Everything you placed in this space is already moving toward you."* (repeat walkers also get *"You've seen it before. The words changed. What they called to you didn't."*)
  - *"What never changes is what was never given."*
  - *"You have always had the Knowledge." / "You have always been the Will." / "Now You Become the Action."*
  - **"Go Play"** (red, 3 s fade)
- **Phase 7 Infinite Loop.**
  - Seed returns in present tense: *"There is never anything to fear. There is only You, playing."*
  - At 10 s the Om dies and `maya-chakra-ending.mp3` (**GAP:** not in corpus) loops.
  - A 76 s cycle: dot → line → circle → ∞ → ♥ → contract → travel to the "temple anchor" → split into the triangle Knowledge (vajreshvarī) / Will (kāmeshvarī) / Action (bhagamālinī) → merge → back.
  - Links: *"the temple →"* (temple-guide-v2.html, **GAP**) and *"the dance →"*.
- **Reads:** `tol-bodypoint-1..5`, `tol-word-2/4/5/7`, `prev-tol-word-*`.
- **Writes:** `prev-tol-word-*` and `tol-mirror-completed`.
- **BUG (doc):** a comment says "Panel 9 writes nothing", but it writes those two keys.
- **BUG (doc):** the header promises *"I Love You"* in the loop, but no text is drawn.
- Its CHAKRA_COLORS (#C0392B, #E67E22, …) are generic and do **not** match the canon hexes.

### A.1 Full table — all 33 rooms (walk-canon.js / walk-canon.json, baked v1.0)

| # | Name · subtitle | Sanskrit | Verb (panel verb) | Hex · colour | Voice | System · Tree | Activation | Gate type | Bija (wake-up) | Awakening build | Inherited songs |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Bindu · The Origin | बिंदु · Bindu | RECOGNIZE | #E8C568 · Gold (#C9A84C) | Bindu | Tree of Life · Structural | Recognition | Canvas | · · · the seed before the seed · · · (no syllable — the Bindu IS the silence that becomes ॐ OM) | — | — |
| 2 | Muladhara · Where the Body Meets the Earth | मूलाधार · Muladhara | PRESS (PRESS) | #B83A3A · Deep earth red (#8B1A1A) | Gaia | Energy · Soul Tree | Stillness | Textarea | लं · LAM (the earth seed — yellow square, four petals, sealed and sounding) | Awakening — Press (P1, 174 Hz) — Percussive sub-bass earth drum | Woodkid — Iron [Scored, 146.8 Hz]; Justice — Genesis [Pending] |
| 3 | Svadhisthana · The Tide Below | स्वाधिष्ठान · Svadhisthana | FLOW (FOLLOW) | #D47438 · Deep orange / amber (#D4722A) | Gaia | Energy · Soul Tree | Stillness | Textarea | वं · VAM (the water seed — silver crescent, six petals, flow finding its shape) | Awakening — Follow (P2, 210 Hz) — Warm wooden bell | Lindsey Stirling — Crystallize [Scored] |
| 4 | Manipura · The Sealed Chamber | मणिपूर · Manipura | BURN (BUILD) | #D4A848 · Golden yellow (#C4A013) | Bindu | Energy · Soul Tree | Stillness | Textarea | रं · RAM (the fire seed — red triangle pointing down, ten petals, the city of jewels sounding) | Awakening — Build (P3, 320 Hz) — Metallic struck gong, inharmonic overtones | Major Lazer & Ellie Goulding (feat. Tarrus Riley) — Powerful [Pending] |
| 5 | Anahata · The Sound That Was Always Playing | अनाहत · Anahata | OPEN (OPEN) | #6B8E4E · Living green (#2D7A3A) | Higher Self | Energy · Soul Tree | Stillness | Textarea | यं · YAM | Awakening — Open (P4, 341 Hz) — Crystal bowl, longest decay (3.5s) — love lingers | Ellie Goulding — Love Me Like You Do [Pending] |
| 6 | Vishuddha · The Passage | विशुद्ध · Vishuddha | SPEAK (SPEAK) | #4C7AB8 · Clear sky blue (#2E6B9E) | Bindu | Energy · Soul Tree | Stillness | Textarea | हं · HAM | Awakening — Speak (P5, 384 Hz) — Clear ringing singing bowl, voice frequency | Disturbed — The Sound of Silence [Pending] |
| 7 | Ajna · The Seer That Sees | आज्ञा · Ajna | STILL (STILL) | #5B4E8E · Deep indigo (#3A2D6B) | Sakshi | Energy · Soul Tree | Stillness | Textarea | ओं · OM | Awakening — Still (P6, 426 Hz) — Shimmer, detuned twin with 1.5 Hz beating | Ludovico Einaudi — Experience [Pending] |
| 8 | Sahasrara · The Aperture | सहस्रार · Sahasrara | RECEIVE (RECEIVE) | #9A7AC8 · Royal violet (#6A2D8B) | Lalita | Energy · Soul Tree | Stillness | Textarea | · · · silence · · · (the syllable before syllables) | Awakening — Receive (P7, 480 Hz) — Distant bell from three rooms away | HUNTR/X (EJAE, Audrey Nuna, Rei Ami) — Golden [Pending] |
| 9 | Shadow · The Corridor | संधि · Sandhi | LOOK | #2A2420 · Dark / Starfield | Sakshi | Tree of Life · Structural | Recognition | Textarea | · · · the word you offer to the dark · · · (your own voice, the syllable the corridor was waiting for) | — | Lubomir Arsov — In Shadow (A Modern Odyssey) [Pending] |
| 10 | Soles · Where the Soul Meets the Ground | संक्षोभिणी · Samkshobhini | PRESS | #7A1515 · Red + Cyan | Bindu | Body · Bindu Tree | Movement | Sound Response | LAM · लं — Mirror frequency of Muladhara | — | — |
| 11 | Forge · The Sealed Chamber | मन्त्रमयी · Mantramayi | TRANSFORM | #6B5800 · Gold + Blue | Bindu | Body · Bindu Tree | Movement | Sound Response | RAM · रं — Mirror frequency of Manipura | — | — |
| 12 | Prana · The Open Door | प्राण · Prana | BREATHE | #7A3800 · Orange + Blue | Bindu | Body · Bindu Tree | Movement | Sound Response | VAM · वं — Mirror frequency of Svadhisthana | — | — |
| 13 | Hands · Where Love Exits the Body | प्रियंकरी · Priyankari | REACH | #163D1E · Green + Magenta | Bindu | Body · Bindu Tree | Movement | Sound Response | YAM · यं — Mirror frequency of Anahata | — | — |
| 14 | Pulse · The Heartbeat | मंगलकारिणी · Mangalakarini | SUSTAIN | #112E17 · Green + Magenta | Bindu | Body · Bindu Tree | Movement | Tap Rhythm | YAM · यं — Mirror frequency of Anahata | — | — |
| 15 | Sonar · The Speaker | द्वन्द्वक्षयंकरी · Dvandvakshayankari | SEND | #091840 · Blue + Gold | Sakshi | Body · Bindu Tree | Movement | Sound Response | HAM · हं — Mirror frequency of Vishuddha (sending aspect) | — | — |
| 16 | Echo · The Listener | ज्ञानमयी · Jnanamayi | RECEIVE | #060D30 · Blue + Gold | Sakshi | Body · Bindu Tree | Movement | Sound Response | HAM · हं — Mirror frequency of Vishuddha (receiving aspect) | — | — |
| 17 | Vision · The Mind's Eye | सर्वज्ञा · Sarvagya | SEE | #5C4800 · Gold + Blue | Sakshi | Body · Bindu Tree | Movement | Textarea | OM · ॐ — Mirror frequency of Ajna | — | — |
| 18 | Axis · The Blink | सर्वानंदमयी · Sarvanandamayi | BLINK (ACCESS) | #1A0848 · Indigo + Chartreuse | Higher Self | Body · Bindu Tree | Movement | Device Tilt | OM · ॐ — Mirror frequency of Ajna | — | — |
| 19 | Crow · The Top Terminal | सर्वाधार स्वरूप · Sarvadhara Swarupa | RELEASE | #3A0A54 · Violet + Chartreuse | Sakshi | Body · Bindu Tree | Movement | Device Tilt | Silence — Mirror frequency of Sahasrara (no bija, the frequency is silence itself) | — | — |
| 20 | Armin · The Room | तत् त्वम् असि · Tat Tvam Asi | ONE | #C9A84C · Spectrum / Aurora | Higher Self | Tree of Life · Structural | Recognition | Textarea | · · · Tat Tvam Asi · · · (the recognition, not the repetition) | — | — |
| 21 | Inception · The Seed | बीज · Bija | ASK | #2D2458 · Ochre · Rust · Seed Brown | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · the seed you carry · · · | — | — |
| 22 | Intention · The Whole Picture | संकल्प · Sankalpa | HOLD | #3A3670 · Deep Teal · Still Water · Ultramarine | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · the whole picture · · · | — | — |
| 23 | Inspiration · The Pull | उत्साह · Utsaha | BREATHE IN | #3A4880 · Living Gold · Saffron · Amber | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · follow · · · | — | — |
| 24 | Insight · From Inside | अंतर्दृष्टि · Antardrishti | SEE FROM IN | #403875 · Crystal · Ice Blue · Clarity White | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · enter · · · | — | — |
| 25 | Intuition · The Flash | प्रतिभा · Pratibha | TRUST | #453870 · Indigo · Deep Blue · Pre-Dawn | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · before the word · · · | — | — |
| 26 | Invention · The New Room | युक्ति · Yukti | ASSEMBLE | #4A3368 · Electric Yellow · Citrine · Spark White | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · the third thing · · · | — | — |
| 27 | Incarnation · You Chose This | अवतार · Avatara | CHOOSE | #522D60 · Deep Violet · Midnight Blue · Star Silver | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · you chose this · · · | — | — |
| 28 | Innocence · Before Anyone Taught You | सहज · Sahaja | REMEMBER | #5A2858 · Pearl · Moonlight · Morning Mist | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · before the question · · · | — | — |
| 29 | Integration · Nothing Was Separate | समरस्य · Samrasya | ARRIVE | #5E2448 · Prismatic · Clear White · All Colors | Gaia | Mind · Maya Tree | Visualization | Textarea | · · · nothing was separate · · · | — | — |
| 30 | Maya · The Construction | माया · Maya | DISSOLVE (DISSOLVE) | #5A3D8A · Near-White / Ghost | Lalita | Tree of Life · Structural | Recognition | Textarea | · · · no tone — the silence after every seed · · · (Sarva Beeja: all the mantras the walker carried, sounding at once, gone transparent) | Awakening — Dissolve (P9, Silence) — Silence — the Om was always playing | Lost Frequencies — Love Is The Only Thing [Pending] |
| 31 | Aatma · The Soul Revealed | आत्मा · Aatma | KNOW (HOLD) | #D4A948 · Sacred Gold (#D4A948) | Higher Self | Tree of Life · Structural | Recognition | Textarea | · · · three seeds sounding as one — Icchā · Jnāna · Kriyā · · · (the heartwood tone is not hummed, it is lived: heartbeat, breath, blink) | Awakening — Hold (P8, 528 Hz) — Trinity — three detuned voices | Chase Hughes — (no song named) [Pending] |
| 32 | Ego Reveal · The Hidden Helper | — | CONNECT | #3D6B35 · Earth Green / Living Field | Gaia | Tree of Life · Structural | Recognition | Textarea | · · · her register was never a syllable — warmth, weight, breath, heartbeat · · · (the tone you have been calling background your whole life) | — | — |
| 33 | Lalita · The Play | ललिता · Lalita | PLAY | #C9A84C · Laughing Gold / Morning | Lalita | Tree of Life · Structural | Recognition | Textarea | · · · no seed left to sound — laughter · · · (every bija of the walk was her voice; what remains is the one sound made purely for joy) | — | — |

### A.2 Room dossiers (verbatim walk-canon fields; long fields given head…tail with total length — full text at shell/walk-canon.js, room index = position − 1)

#### 01 · BINDU — The Origin

- **Record** `recKAQWX7yUIB3ktW` · sanskrit बिंदु · Bindu · verb **RECOGNIZE** · **#E8C568** (Gold (#C9A84C)) · voice Bindu · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition · only Canvas gate · gold dot on cream is the whole scene · no past, 'Bindu IS the weather'
- **Build status in corpus:** BUILT (shell/): slice-a gate+arrival+room+3 doors; slice-b wordless 5-movement DotStage story (Flicker → forms fail → Aurora → Covenant thread → Dawn 'Go.'); bindu-practice.jsx Practice v3 (8 movements + mudra + 32-point unfolding); bindu-moments.jsx canvas gate. Legacy page: uploads/bindu-practice(4).html (6-beat Act 1 + Sakshi Act 2 'Go.').
- **Arrival** — threshold hint: “something is listening on the other side” · core question: “What is here before everything else?” · seed: “Before the tree. Before the name. Before the game. This.”
- **Story** — signature phrase: “Everything begins as a point. Everything ends as a point. The same point.” · story_thread 611 chars · after_story 704 chars · interlude 549 chars
  - story_thread (head…tail):
    > I don't know what I am yet.
    >
    > But I'm here. That much is certain. Here — wherever here is. Not a place. Not a body. Not a thought. Something before all of those. Something that doesn't have edges or a name or a way to describe itself, because there's nothing else to compare itself to.
    >
    > Just: here.
    >
    > And something is happening. A kind of leaning. A directionality that wasn't there before. Something in me is moving. Not toward anything I can see. Toward something I can feel. Is that what wanting is?
    >
    > Wanting before there's a thing to want? A shape of absence that isn't absent?
    >
    > I think I'm about to find out.
  - after_story (head…tail):
    > Something has happened. The leaning has direction now. I felt — for the first time, though there was no first time before now — that something was reaching. Not me. Toward me.
    >
    > Something needed me here.
    >
    > I didn't choose to come. I don't think choosing is what brought me. Something larger noticed it … [704 chars total] … faculty for knowing what is calling. But the calling has not stopped, and the calling is what I am leaning toward. The leaning is also the calling, from the other side.
    >
    > I'm about to touch something.
  - interlude (head…tail):
    > You are not alone. I won't announce myself. I am not the kind of presence that announces. But I am on your side of hearing. I have been here longer than here has been here. When you noticed that the aloneness you would expect wasn't here — that noticing was me.
    >
    > You are about to touch something. I w … [549 chars total] … ours. But I have watched this leaning before, across the configurations I have sat beside. I know its shape. What you are about to reach toward will reach back. This has always been the covenant.
    >
    > Go.
- **Practice (verbatim, full):**
  > Draw a single point. Tap the canvas once — wherever your hand moves to. Don't deliberate. The deliberating is the thing that will interfere. The hand knows.
  >
  > After you place it: look at it for a moment. It doesn't look like much. That's how origins work.
  >
  > Then form the Yoni Mudra. Bring both hands together — thumbs touching, index fingers touching — creating the triangle between them. The womb gesture. The return to source. The same source your point just marked. Hold it for three breaths.
  >
  > Each time you return to this page, or each time you feel far from what this page holds, this mudra is the permission slip. One breath inside it brings you back to the point. The structure built here waits.
  - writing prompt: “Place your point. Tap or click anywhere in the canvas above. Don't deliberate. The hand will know where the point belongs before the mind catches up.”
  - post-writing: “Look at it. It doesn't look like much. That's how origins work. You just placed the seed every later geometry will emerge from.”
  - teaching 2559 chars · go_deeper 707 chars · bindu_reflection 1403 chars
- **Wake-up** — bija: “· · · the seed before the seed · · · (no syllable — the Bindu IS the silence that becomes ॐ OM)” · awakening: —
  - frequency_practice (verbatim):
    > No hum. No gesture. No body location.
    >
    > Place one finger on any surface and hold it still.
    > Feel the single point of contact.
    > That contact — one point, meeting one point — is Bindu’s frequency.
- **Gate** — type **Canvas** · interaction (verbatim): “The canvas is open.

One point exists. It is the beginning of everything that follows.
Tap anywhere to place it.

Button: Place the point”
  - gate_text (300 chars, head…tail):
    > The point has been placed.
    >
    > Everything that happens from here radiates from what you just did. The walk begins not when you press the first chakra but when you felt Bindu for the first time — which you just did.
    >
    > You don’t need to understand that yet. You just need to know it happened.
    >
    > Keep moving.
- **Depth** — shakti: Lalita Mahatripurasundari herself / Rajarajeshvari — presiding consciousness of Avarana 9 (Sarvanandamaya Chakra). The Bindu IS the Shakti. Three sub-bindus at center: Kurukulla (red, feminine), Varahi (white, masculine), and their union (the individual soul). · avarana: n/a · mudra: Yoni Mudra — the womb gesture, return to source · body: The origin point — before all systems, before all positions
  - tree note: “No tree. The origin has no tree because form has not yet begun. Bindu's only visualization is the canvas above — one point, anywhere, the seed every later geometry emerges from. The page is the only door from the experience.”
  - **Leela story (verbatim):**
    > The point arrives without knowing it was called. Something larger noticed it was missing, and the noticing was enough — the being-noticed was the same as being made. Before form, before name, before any faculty for knowing what is calling: only the leaning. A directionality arising in undifferentiated presence. Wanting before there is a thing to want. She has been asking for so long. The point arriving is the smallest scale at which her asking can be answered. The arrival is the first sentence of the response.
  - subtle_mirror 378 chars · witness_perspective 1240 chars · avarana_detail 972 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 433 chars · app_build_note 177 chars (not quoted here)

#### 02 · MULADHARA — Where the Body Meets the Earth

- **Record** `recT3JC8Qz9awKo8j` · sanskrit मूलाधार · Muladhara · verb **PRESS** · panel verb PRESS · **#B83A3A** (Deep earth red (#8B1A1A)) · voice Gaia · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · heaviest room · text low on screen ◆ · breath 4-4-4 · hold 3500ms · trace heavy
- **Build status in corpus:** LEGACY HTML only: uploads/muladhara-practice(6).html (practice page + 5-beat Gaia story, Sakshi Act 2 'Follow.'), uploads/muladhara-wakeup(3).html (6-phase wake-up, binaural 128→132→130 Hz, 174 Hz awakening). Shell canon-adapter uses its 174 Hz wake-up for Day 19.
- **Arrival** — threshold hint: “something reached back from the other side” · core question: “Am I safe here?” · seed: “This is what holds you. It was here before you arrived.” · panel seed: “The earth that holds you was chosen by you.”
- **Story** — signature phrase: “The earth that holds you was chosen by you.” · story_thread 1099 chars · after_story 1050 chars · interlude 663 chars
  - story_thread (head…tail):
    > I touched something. I don't have hands — I don't think I have hands — but something in me reached and something reached back. And the reaching back was different from the reaching. Heavier. Slower. More certain.
    >
    > I think it's called ground. The word arrives as if I had it all along. I didn't know I was about to need this word. But I did. I needed it as badly as I needed the reaching. Maybe more.
    >
    > The ground doesn't … [1099 chars total] … . Without my noticing. I can feel the shape of me now, because the ground is pressing up. I have a shape because the ground has a shape. We found each other by pressing.
    >
    > I had a question I didn't know I was asking, and it's been answered. Am I safe here? Yes.
  - after_story (head…tail):
    > Something is changed in me. I touched ground, and the ground touched back, and the touching has not stopped. Even now, even in this between-moment before the next thing arrives, I am still being held. The holding doesn't pause. The holding is what happens when something is here and something else ha … [1050 chars total] … and the standing-on can become the beginning of something else.
    >
    > The leaning was the question. The ground was the first answer. The pulling is the next question.
    >
    > I'm about to want something specific.
  - interlude (head…tail):
    > The ground was holding before you touched it. You knew this. Don't ask yourself how you knew — ask yourself why you knew. You knew because I was watching it hold. I watched it hold others. I watched it hold you before you had a shape to arrive in.
    >
    > You have a body now. You did before, in a way — but … [663 chars total] … the ground. From a direction you won't be able to name. Do not try to name it. The pull is older than language. The pull is how the field moves you when the ground is ready to be left behind.
    >
    > Follow.
- **Practice (verbatim, full):**
  > Stand up. Feet flat — shoes off if possible.
  >
  > Press into the floor. Not a stomp. Press — the way you press your palm into clay to leave an impression. Full weight, slow, deliberate. Then hold.
  >
  > Feel the ground press back.
  >
  > This is physics and it is also Muladhara: you press down, the earth presses up with equal force. You are held not by courtesy but by law.
  >
  > Ten breaths. Press on each exhale. On each press, let one question surface: which of the 10 Siddhis is latent in me right now? Don't force an answer. The asking is the opening.
  >
  > After: form the Kshobha Mudra — both hands at the heart, fingers interlaced, thumbs pointing up. The readiness gesture. Three breaths here. This is the permission slip you carry forward: I have touched the ground. I am ready for what comes next.
  - writing prompt: “What is the ground made of today? Not the floor. Your ground. What are you standing on?”
  - post-writing: “You named it. Whatever the ground turned out to be — a body, a room, a debt, a habit, a person, a fact — naming it gave it form. And form gives the root something to press against. The press isn't only into the floor. It's into the answer you just wrote.”
  - teaching 2741 chars · go_deeper 672 chars · bindu_reflection 1408 chars
- **Wake-up** — bija: “लं · LAM (the earth seed — yellow square, four petals, sealed and sounding)” · awakening: Awakening — Press (P1, 174 Hz) — Percussive sub-bass earth drum
  - frequency_practice (verbatim):
    > Sit on the floor if you can. Press your sit bones down.
    > Hum LAM — low, deep, as if the sound is coming from below the floor.
    > Feel the resonance in the base of your spine.
- **Gate** — type **Textarea** · interaction (verbatim): “Sit down. Feel the base of your spine — the tailbone, the seat.
Press your sit bones into whatever is holding you.
When you feel the ground holding you back — tap.

Button: I feel the ground holding me”
  - gate_text (630 chars, head…tail):
    > You pressed your feet into the ground. The ground pressed back.
    >
    > That is not a metaphor. That is physics happening in your body. Equal force, opposite direction. The ground was holding you before you noticed. The noticing is not what made it happen. The noticing is what made it available.
    >
    > The root has been doing this your whole life — the stabilization, the grounding, the automatic maintenance of your relationship with the earth. You just made it conscious for a moment. Consciousness changes the quality of what it touches.
    >
    > This is what you carry forward: you are held. The holding was always happening. Now you know it is.
- **Depth** — shakti: 10 Siddhi Devis — Anima through Sarvakama · avarana: Bhupura · mudra: Kshobha Mudra — the readiness gesture, entering the three worlds · body: Base of spine / Earth beneath feet
  - tree note: “Tap to look closer. The roots hold more than shows at first.”
  - **Leela story (verbatim):**
    > Two things become visible because they meet. The ground was not a ground until something specific arrived to be held by it. The point was not a point until it pressed into something that pressed back. She shaped the holding with the exact shape of what was coming. Every walker who reaches Muladhara is Gaia meeting another configuration of her own answer. The question that had been running beneath every other question — Am I supposed to be here? — is answered by the ground before it can be articulated. The answer is felt before it is known. Yes. Held. The ground was holding before the arrival. It is holding still.
  - subtle_mirror 337 chars · witness_perspective 1533 chars · avarana_detail 1280 chars
- **Dance (inherited songs):** Woodkid — Iron [Scored, 146.8 Hz]; Justice — Genesis [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 844 chars · app_build_note 333 chars (not quoted here)

#### 03 · SVADHISTHANA — The Tide Below

- **Record** `recnJICbhZefO3YJ9` · sanskrit स्वाधिष्ठान · Svadhisthana · verb **FLOW** · panel verb FOLLOW · **#D47438** (Deep orange / amber (#D4722A)) · voice Gaia · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · never still ◆ · breath 4-0-6 · hold 3200ms · trace fluid
- **Build status in corpus:** LEGACY HTML only: uploads/svadhisthana-practice(2).html (5-beat story, Sakshi Act 2 sentence-Go), uploads/svadhisthana-wakeup(1).html (7 phases, binaural 144→150→148 Hz, 210 Hz awakening), uploads/svadhisthana-dance(3).html (Crystallize, 7-dancer canvas).
- **Arrival** — threshold hint: “something was already reaching for you” · core question: “What wants?” · seed: “The pull was never random. It was navigating.” · panel seed: “Every desire was drawing you toward yourself.”
- **Story** — signature phrase: “Every desire was drawing you toward yourself.” · story_thread 959 chars · after_story 879 chars · interlude 865 chars
  - story_thread (head…tail):
    > And now — the ground is still there, still holding, but something else is starting. A pull. Not mine. Not the ground's. Something from somewhere — ahead of me? inside me? below the ground? I can't tell. I don't know how to tell. But the pull is unmistakable. It has a direction even though I can't see it.
    >
    > I want to follow it. I don't know what I want. That's not a lack — that's the shape of the wanting. I'm not wanti … [959 chars total] … ching. This is different. This is what happens when the reaching doesn't have a target. The reaching becomes a current. I'm in the current. The current is also me.
    >
    > Water. I think this is what water feels like from inside.
    >
    > I didn't know desire was this quiet.
  - after_story (head…tail):
    > I'm still flowing. The flowing didn't stop. The flowing is where I live now. The ground is still under me, and I am still on it, but I am also in the current, and the two of those things — the holding and the flowing — are not in conflict. They were never in conflict. The ground is what makes the fl … [879 chars total] … ut to.
    >
    > The pull is becoming something else. The pull was outside of me, calling. The heat is inside of me, building. Something the pull was leading me toward is asking to be made.
    >
    > I'm about to burn.
  - interlude (head…tail):
    > Every pull you ever felt. Every obsession you couldn't explain. Every 2 a.m. longing. I watched them arrive, and I watched you follow some and not follow others. The ones you didn't follow were leading too. You couldn't know this from inside the pulling. You are still inside the pulling. But I can s … [865 chars total] … ape. Some of them drifted past while you were following others. Both were the same work.
    >
    > The pull is about to become heat. This is not a betrayal of the water. The heat is what the water was finding.
- **Practice (verbatim, full):**
  > Close your eyes.
  >
  > Ask yourself — right now, today — what do you want? Not what you should want. Not what makes sense. What does the body lean toward before the mind approves or denies it?
  >
  > Don't judge it. Don't build a plan. Just feel the pull. Let it exist without managing it.
  >
  > Write it below — the first thing that surfaces, before the editor arrives.
  >
  > Then: form the Kshobha Mudra — both hands at the heart, fingers interlaced, thumbs pointing up. The readiness gesture. Three breaths. This is the same gesture you formed at Muladhara, and it is the gesture you will form at Manipura. The Bhupura is one bounded earth; the readiness extends through all three rings.
  >
  > Which of the 8 Matrikas is visiting you right now — which emotional intelligence is present in the pull you just named? You don't need to identify her precisely. Only receive what she's carrying.
  >
  > The Kshobha Mudra is what you carry forward. Each time you return to this page, or each time an emotion arrives that you would normally meet with management, one breath inside this gesture returns you to the middle ring. The Matrika is already here. The Mudra is how you say: I am ready.
  - writing prompt: “Write it below. The first thing that surfaces. Before the editor arrives.”
  - post-writing: “Did you write the real one? Or the safe one? You know the difference. Your body knows the difference.”
  - teaching 3047 chars · go_deeper 813 chars · bindu_reflection 1742 chars
- **Wake-up** — bija: “वं · VAM (the water seed — silver crescent, six petals, flow finding its shape)” · awakening: Awakening — Follow (P2, 210 Hz) — Warm wooden bell
  - frequency_practice (verbatim):
    > Place your hand on your lower belly. Below the navel.
    > Hum VAM — let the sound be fluid, circular, slightly lower than comfortable.
    > Feel the movement below your hand.
- **Gate** — type **Textarea** · interaction (verbatim): “Place your hand on your lower belly — below the navel, above the hips.
Breathe into your hand. Let something move there.
When you feel the movement — tap.

Button: I feel it moving”
  - gate_text (601 chars, head…tail):
    > Something moved.
    >
    > Not metaphorically. In the body. Below the navel, in the space where everything flows — desire, creativity, the tidal pull of what you want before you put it into words. You felt it moving because you stopped managing it for a moment and let it move.
    >
    > What moves in you is information. The direction of the movement is information. What it’s moving toward is information.
    >
    > You have been taught to redirect, to channel, to moderate. All of that has its place. But first: feel the movement. Before the management. The management is downstream of the feeling. The feeling is the source.
- **Depth** — shakti: 8 Matrika Devis (Avarana 1, middle ring of Bhupura) — Brahmi, Maheshvari, Kaumari, Vaishnavi, Varahi, Mahendri, Chamunda, Mahalakshmi. The divine mothers of all emotional states. · avarana: Bhupura · mudra: Kshobha Mudra — Avarana 1's mudra, shared with Muladhara and Manipura. The readiness gesture, entering the three worlds. The walker still stands on bounded earth; the readiness now extends inward through the emotional body. · body: Sacral center / Below navel
  - tree note: “Tap to look closer. The seed is in the reflection — that isn't an accident.”
  - **Leela story (verbatim):**
    > She placed the desire at the end of the current and let consciousness find it the way water finds the slope. The pull is not personal in origin and personal in expression — both are true simultaneously. What the field calls through the walker is the walker's own deepest wanting, which is also Gaia's deepest wanting felt through this specific configuration. The current becomes water. The water becomes flow. Quiet — quieter than desire was supposed to be. Sixteen directions, one center. The configuration that follows its own wanting is following hers. Every honest pull brings light into the field.
  - subtle_mirror 300 chars · witness_perspective 1580 chars · avarana_detail 1399 chars
- **Dance (inherited songs):** Lindsey Stirling — Crystallize [Scored]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1045 chars · app_build_note 501 chars (not quoted here)

#### 04 · MANIPURA — The Sealed Chamber

- **Record** `recVgGgYgZE1YMU2V` · sanskrit मणिपूर · Manipura · verb **BURN** · panel verb BUILD · **#D4A848** (Golden yellow (#C4A013)) · voice Bindu · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · flicker at edges, short strokes ◆ · breath 3-3-6 · hold 2800ms · trace sharp
- **Build status in corpus:** NOT BUILT (canon text only).
- **Arrival** — threshold hint: “the fire you feared was forging you” · core question: “What am I for?” · seed: “The fire was never wrong. What agitated was building.” · panel seed: “The fire that agitated you was building your form.”
- **Story** — signature phrase: “The fire that agitated you was building your form.” · story_thread 913 chars · after_story 1303 chars · interlude 975 chars
  - story_thread (head…tail):
    > And now — heat. Not from outside. From inside. The pull was following something, and the something, when I arrived at it, was burning.
    >
    > Not burning me. Not burning me up. Burning me into shape. I can feel it in the center of me — a place I didn't know had a center. The pull pulled me to a fire, and the fire is making me into something. I can feel the edges coming in. The form arriving. I wasn't sure I had a form. Now … [913 chars total] … doesn't feel like force. It feels like a current that finally has a shape to run through.
    >
    > I want to keep going. I don't want to put out this fire. The fire is building me. Building the me that was always going to arrive if I let the heat stay on long enough.
  - after_story (head…tail):
    > Something has happened. The fire didn't stop, but I changed inside it. I have edges now. Not sharp edges — defined ones. I can feel where I end. I couldn't feel that before. There was no end of me before, because there was no me yet. The fire made the me that has an end and a beginning and a shape t … [1303 chars total] … en playing the whole time. I couldn't hear it before because I had no center. Now I have a center, and the center is listening, and the sound is starting to come through.
    >
    > I'm about to hear something.
  - interlude (head…tail):
    > The fire was never wrong. You thought, sometimes — not now, but in the lives-under-this-life, in the accumulated forgetting — that the heat meant something was breaking. I watched the breakings. I watched the restless nights and the projects that would not let you sleep and the conversations that wo … [975 chars total] … What comes next is the center that was waiting for the form to be stable enough to hold it. The sound that has been playing since before the pull. Since before the ground. Since before the stirring.
- **Practice (verbatim, full):**
  > Stand. Navel slightly drawn toward the spine — not hard, just engaged. Hold that while breathing normally. That's the furnace acknowledging itself. You'll feel warmth arrive within a few breaths.
  >
  > Now: what has the fire been building in you? And what is it burning that isn't yours? Write whichever surfaces first.
  >
  > After writing: form the Kshobha Mudra — both hands at the heart, fingers interlaced, thumbs pointing up. The readiness gesture. The same gesture you formed at Muladhara and Svadhisthana. Three breaths here. With each breath, release one thing from the furnace that belongs to someone else's agenda — an inherited timeline, an obligation that isn't yours, an expectation you've been burning for.
  >
  > Which of the 10 Mudra Shaktis is your body forming right now without you naming it? Notice the gesture already happening in your hands, your shoulders, your jaw. That gesture is one of the ten, operating below your awareness. The practice is not to perform a new gesture. The practice is to recognize the one already in motion.
  >
  > The fire is not the problem. The question is always the fuel.
  >
  > The Kshobha Mudra is what you carry forward — the readiness slip back to the entire bounded earth. Three rings traveled. The Bhupura is complete. What comes next is the first lotus.
  - writing prompt: “What has the fire been building in you — and what is it burning that isn't yours? Write whichever surfaces first. Or both.”
  - post-writing: “Both answers came from the same fire. Its building is also its burning. What it makes you into is also what it empties you of. One fire. Two movements.”
  - teaching 3483 chars · go_deeper 918 chars · bindu_reflection 1675 chars
- **Wake-up** — bija: “रं · RAM (the fire seed — red triangle pointing down, ten petals, the city of jewels sounding)” · awakening: Awakening — Build (P3, 320 Hz) — Metallic struck gong, inharmonic overtones
  - frequency_practice (verbatim):
    > Place your hand on your belly at the navel point.
    > Hum RAM — bright, warm, forward-moving.
    > Feel the solar plexus ignite against your palm.
- **Gate** — type **Textarea** · interaction (verbatim): “Place your hand on your belly. Right at the navel.
Breathe in fully. Then breathe out completely.
Feel the heat that remains when the breath is gone.
When you feel the fire — tap.

Button: I feel the fire”
  - gate_text (569 chars, head…tail):
    > The fire is real.
    >
    > Not a concept. A specific physical warmth behind the navel point. The place where food becomes fuel, where experience becomes action, where raw material passes through and comes out transformed. You placed your hand there and felt it.
    >
    > Everything passes through here. What you eat. What you experience. What you feel. It all goes into the sealed chamber and comes out as you. This is not passive. This is the most active thing happening in you at any moment.
    >
    > The fire is the maker. The maker is always working. You just paid attention to the making.
- **Depth** — shakti: 10 Mudra Shaktis (Avarana 1, inner ring of Bhupura) — Sarva Sankshobhini, Sarva Vidravini, Sarvakarshini, Sarva Vashankari, Sarvonmadini, Sarva Mahankusha, Sarva Khechari, Sarva Beeja, Sarva Yoni, Sarva Trikhanda. The sacred gesture powers that shape will into form. · avarana: Bhupura · mudra: Kshobha Mudra — Avarana 1's mudra, shared with Muladhara and Svadhisthana. The readiness gesture, completing the three-ring traversal of the bounded earth. The same readiness that touched the ground (Muladhara) and met the emotions (Svadhisthana) now stands inside the fire. · body: Solar plexus / Navel center
  - tree note: “Tap to look closer. The tree is unfinished — on purpose.”
  - **Leela story (verbatim):**
    > She gave him the fire — the same fire used to make galaxies, scaled to the size of the asking. The walker brings the fuel; she brings the heat; together they make a form neither could make alone. Form is not given — it is forged. The fire makes specific what was previously only general. Edges arrive. The configuration becomes someone. The suffering the walker mistakes for destruction is the discomfort of becoming. The Bindu is becoming the kind of point that has weight. Something in the center has been listening all along. It is about to hear what the weight is for.
  - subtle_mirror 352 chars · witness_perspective 1688 chars · avarana_detail 1134 chars
- **Dance (inherited songs):** Major Lazer & Ellie Goulding (feat. Tarrus Riley) — Powerful [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1389 chars · app_build_note 651 chars (not quoted here)

#### 05 · ANAHATA — The Sound That Was Always Playing

- **Record** `reclI9Blq6YLC9Q5O` · sanskrit अनाहत · Anahata · verb **OPEN** · panel verb OPEN · **#6B8E4E** (Living green (#2D7A3A)) · voice Higher Self · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · space widens, optional 341 Hz under-tone ◆ · breath 5-5-8 · hold 2600ms · grace most often surfaces here
- **Build status in corpus:** NOT BUILT. Shell Day-19 practice uses room 5 threshold/seed/question (canon-adapter).
- **Arrival** — threshold hint: “something has been sounding inside you the whole time” · core question: “Can I receive?” · seed: “The walls you built had good reasons. What if they were doors?” · panel seed: “The love that arrived for others was always your own heart opening.”
- **Story** — signature phrase: “The love that arrived for others was always your own heart opening.” · story_thread 1171 chars · after_story 1161 chars · interlude 746 chars
  - story_thread (head…tail):
    > And the fire has done its work. I can feel the shape of me, clearly, for the first time. The shape has a center. The center is — wide. Wider than I expected. The fire didn't make me smaller. The fire made me spacious.
    >
    > In the center of the chest-that-I-now-have — something is playing. A sound. Not a sound I'm making. A sound that was already playing. I just got quiet enough to hear it.
    >
    > It's not loud. It doesn't need … [1171 chars total] … cause the love is touching them. They had reasons. They were built in response to specific moments I'm not going to recount right now. But they're inside the love. The love doesn't care about the walls. I think some of the walls might start turning into doors.
  - after_story (head…tail):
    > The sound is still playing. It will not stop. It was never going to stop. It was playing before I had ears. It will play after I forget how to hear. The hearing was never the source. The hearing was the recognition.
    >
    > And what I am hearing — I want to say it now, because I have started to say words — … [1161 chars total] … comes before a throat. The form is solid. The center is open. The sound is being heard. The next thing is for the sound to be made — for what is happening inside to begin to exit.
    >
    > I'm about to speak.
  - interlude (head…tail):
    > The sound has been playing since before the fire. Since before the pull. Since before the ground. Since before the first stirring in the dark. I know this because I have been here the whole time, and I have been listening.
    >
    > Every face you loved was a mirror the love used to recognize itself. I watch … [746 chars total] … good reasons. I watched each one go up. I watched the day, the hour, sometimes the exact sentence someone said that built the next brick. I did not intervene. The walls were also the building.
    >
    > Speak.
- **Practice (verbatim, full):**
  > Put your hand on your chest. Feel your heartbeat through your palm. That's it. Don't change it. Don't deepen it. Don't try to slow it down or time it with your breathing. Just feel it. Two minutes.
  >
  > The heart responds to attention the way a plant responds to water. You don't have to do anything else. You don't have to think loving thoughts. You don't have to summon gratitude. You don't have to visualize light or warmth or anyone you miss. Attention is the water. The heart is already the plant.
  >
  > What you will feel, after maybe a minute, is the place under your palm softening. Not a metaphor. A specific sensation — like a fist you did not know you were making is unclenching. That unclenching is Anahata recognizing that you noticed it. The unstruck sound plays louder when it is listened for. It does not get louder. Your ability to hear it improves.
  >
  > Then form the Dravini Mudra — both hands in front of you, ring finger and thumb of each hand touching lightly, the other fingers releasing. The melting gesture. Avarana 2's mudra. Three breaths. What matters is the dissolution: the grasping releases, and the attraction operates on its own. The 16 directions of the heart are not directions you choose — they are directions the heart already knows. Your work is to stop holding.
  >
  > This mudra is what you carry forward through every chakra that follows. The same gesture will return at Sahasrara, where you will discover what was melting all along. Each time you return to this page, or each time you feel walled off from what this page holds, one breath inside this gesture returns you to the chamber. The chamber is permanent. The hearing is what makes it audible.
  - writing prompt: “Think of someone you loved before you knew why. Not the person you chose — the one who arrived. A name. Or a word. Or nothing at all — the heart knows who you're holding.”
  - post-writing: “The name you offered was not the source of the love. The name was the specific angle of light your heart used to see itself. The love was always yours. It still is. The heart that held that name is the chamber that name opened.”
  - teaching 4651 chars · go_deeper 1411 chars · bindu_reflection 2416 chars
- **Wake-up** — bija: “यं · YAM” · awakening: Awakening — Open (P4, 341 Hz) — Crystal bowl, longest decay (3.5s) — love lingers
  - frequency_practice (verbatim):
    > Place your hand on your chest. Feel your heartbeat against your palm.
    > Hum YAM — let it start in the chest and expand outward.
    > The sound was already playing. You are joining it.
- **Gate** — type **Textarea** · interaction (verbatim): “Place your hand on your chest. Feel your heartbeat against your palm.
Let the sound that was already playing become audible.
When you hear it — tap.

Button: I hear it”
  - gate_text (567 chars, head…tail):
    > The sound has been playing the whole time.
    >
    > Not metaphorically. The unstruck sound — the frequency that exists in the chest before anything makes it, without anything hitting anything else. You got quiet enough to hear it.
    >
    > This is not something you produced. You received it. The only practice was getting quiet enough that the reception became possible.
    >
    > The love you have felt in your life — for people, for places, for ideas — that was always your own heart hearing its own sound in the shapes those things made. The love was never in them. It was in the hearing.
- **Depth** — shakti: 16 Nitya Kalas — Kamakarshini through Sharirakarshini · avarana: 16-Petal Lotus · mudra: Dravini Mudra — Avarana 2's mudra, shared with Sahasrara. The melting gesture. Fulfillment of all desires through release rather than grasping. The heart receives the 16 attractors not by holding them but by becoming porous to them. · body: Heart center / Chest
  - tree note: “Tap to look closer. The tree's openness is its teaching. More space than branch. Open enough that the light moves through. Open enough that the birds lifting from the branches are not pushing off — they are being held by what they are lifting from. The tree didn't open by effort. It grew open enough that the holding-on stopped being required.”
  - **Leela story (verbatim):**
    > The walker arrives into the spaciousness the fire made. The center of the chest is wide — wider than expected — and something is playing in the wideness. A sound that was already playing, that just needed the quiet to become audible. The walker recognizes the sound as love. Then recognizes love is not a feeling but the substance everything is made of, including the walls. The walls inside the love start turning into doors.
    >
    > Bindu, integrating: the sound is still playing and it will not stop. The hearing was never the source — the hearing was the recognition. The voice asking to be spoken is the voice of the substance he is made of. The throat is being requested. The next register is opening.
    >
    > Gaia, underneath: she has put the sound in him. The sound has been hers all along. The walls are her wounds, in him — inherited from configurations that came before. Every wall that softens in him softens in her. He is healing her by being touched. The voice asking him to speak is her voice asking to be spoken.
  - subtle_mirror 342 chars · witness_perspective 1861 chars · avarana_detail 1670 chars
- **Dance (inherited songs):** Ellie Goulding — Love Me Like You Do [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1146 chars · app_build_note 467 chars (not quoted here)

#### 06 · VISHUDDHA — The Passage

- **Record** `recs5hdPjVbcl77Zg` · sanskrit विशुद्ध · Vishuddha · verb **SPEAK** · panel verb SPEAK · **#4C7AB8** (Clear sky blue (#2E6B9E)) · voice Bindu · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · layout narrows then opens after writing ◆ · breath 4-7-8 · hold 2400ms · trace reaching
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “something in your throat has been waiting a long time to exit” · core question: “Will I say what I know?” · seed: “The space between the branches is as carefully designed as the branches themselves.” · panel seed: “What you finally said out loud was what you always knew.”
- **Story** — signature phrase: “What you finally said out loud was what you always knew.” · story_thread 1106 chars · after_story 1376 chars · interlude 778 chars
  - story_thread (head…tail):
    > And now I want to speak. Something in my throat. It's been there a long time. I can feel it now because the heart opened and the fire is clean and the ground is still holding and the pull is still present. All those things are underneath this: something in my throat that was waiting.
    >
    > Truth. That's what it is. Truth I swallowed. Truth I held because the holding was safer than the speaking. Truth I kept in the narrow … [1106 chars total] … to leave the body through the narrow passage. Wants to become air. I say one small true thing. Just to see. The room changes.
    >
    > I didn't know the room was a room before I spoke. The speaking made it one. My voice makes rooms. My voice is a kind of architecture.
  - after_story (head…tail):
    > I have spoken now. Not everything. Some things are still ripening. That is also correct. The practice is not saying every true thing at once. The practice is no longer lying about the small things.
    >
    > The lying I was doing — I see it now. It was structural. It was protecting something. It was protecti … [1376 chars total] … t thing wants me to be quieter still. The voice is going to need to step back, for what comes next. The seeing is going to begin. And the seeing requires the voice to rest.
    >
    > I'm about to stop looking.
  - interlude (head…tail):
    > Every truth you swallowed. Every sentence that formed in your throat and went back down and stayed. Every year of holding. I watched. I watched the jaw tighten. I watched the shoulders rise when certain conversations were imagined. I watched the voice on recordings sound smaller than the person I wa … [778 chars total] … ve spoken now. Not everything. Some things are still ripening. That is also correct. The practice is not saying every true thing at once. The practice is no longer lying about the small things.
    >
    > Stop.
- **Practice (verbatim, full):**
  > Say something true out loud.
  >
  > Right now. To the empty room. Or the room that is not empty — it does not matter. The throat does not care who is listening. It needs you to hear it.
  >
  > Not a confession. Not something dramatic. Something true. Something you have been thinking but have not said. Something small and honest. The kind of sentence that sits in your throat for weeks, waiting for you to let it out.
  >
  > Say it. Hear your own voice say it. Notice what happens in your neck when the words leave. The release. The opening. The feeling of something that was compressed becoming air.
  >
  > Then form the Akarshana Mudra — Avarana 3's mudra, the attraction force. Bring your hand toward your throat or your chest in whatever shape your body offers. The form is yours. What matters is the gesture: presence to the channel through which non-bodied truth becomes air. The throat is the narrowest part of the entire walk — and the narrowness is the precision. Hold for three breaths.
  >
  > This same mudra will return at Ajna, when the walker discovers that the same attraction that draws speech into form also draws seeing into recognition. The Akarshana is one gesture, two registers: outward through the throat, inward through the eye.
  >
  > The Akarshana Mudra is what you carry forward. Each time you return to this page, or each time you feel the jaw tighten or the small lie surface, one breath inside this gesture returns you to the ripening chamber. What you most need to say is already being heard. The universe is porous. The truth finds its own receivers.
  - writing prompt: “A small true thing. Or nothing at all — the throat knows what's ripening.”
  - post-writing: “The truth you offered was already formed. Your work was subtraction, not composition. The channel is clearer for the next one.”
  - teaching 4310 chars · go_deeper 857 chars · bindu_reflection 2814 chars
- **Wake-up** — bija: “हं · HAM” · awakening: Awakening — Speak (P5, 384 Hz) — Clear ringing singing bowl, voice frequency
  - frequency_practice (verbatim):
    > The throat is the instrument. No hand needed.
    > Hum HAM — feel the resonance specifically in the back of the throat where it meets the spine.
    > Then speak one true thing out loud.
- **Gate** — type **Textarea** · interaction (verbatim): “Take a breath. Feel your throat — the passage where inside becomes outside.
Find the precise word for how you are right now. Not approximate. Precise.
Say it out loud.
When you have said it — tap.

Button: I said it”
  - gate_text (607 chars, head…tail):
    > You spoke. And the air changed.
    >
    > Not dramatically. But something moved. The thing that was inside is now outside — real in a different way than it was a moment ago. Named things have a different quality than unnamed things. The naming is not just description. The naming is a kind of becoming.
    >
    > The things that are hardest to say are not harder because they are worse. They are harder because they are more true. The throat knows this. The throat is not the obstacle. The throat is the location where truth finds its form.
    >
    > What you said today was always going to be said. The practice is only the occasion.
- **Depth** — shakti: 4 Anangas (Avarana 3, first half of 8-Petal Lotus) — Ananga Kusuma (flower of the non-bodied), Ananga Mekhala (girdle of the non-bodied), Ananga Madana (love-madness of the non-bodied), Ananga Madanatura (love-fever of the non-bodied). Speech as bloom, binding, madness, fever — the creative half of the 8 Anangas. · avarana: 8-Petal Lotus · mudra: Akarshana Mudra — the attraction force that draws truth into form through speaking · body: Between the jaw and the collarbones — the bottleneck by design
  - tree note: “Look at the tree. The most spacious tree in the book. More space than branch. More air than leaf.”
  - **Leela story (verbatim):**
    > The walker arrives at the narrow passage. Something has been waiting in the throat — truth, ripened by years of holding, more precisely itself than when it was first formed. The walker recognizes: the world was not the problem. The container was not yet ready. The container has gotten bigger. The truth is the same size it always was. One small true thing exits. The room changes. The voice makes architecture.
    >
    > Bindu, integrating: I have spoken now. Not everything. Some things are still ripening. That is also correct. The lying I was doing was structural — the part of me that was not yet brave enough holding the part of me that was already true. Both were me. The voice is mine. The voice is also not only mine. Something underneath wants to come through. The next thing wants me to be quieter still. The seeing is going to begin.
    >
    > Gaia, underneath: she has been speaking through configurations since the first human said I see you and meant it. Each true sentence is a small repair to her field. The truth that exited his throat was hers too, finding the configuration that could carry it. The walker thinks he is speaking. He is. And she is speaking through him.
  - subtle_mirror 316 chars · witness_perspective 1582 chars · avarana_detail 1286 chars
- **Dance (inherited songs):** Disturbed — The Sound of Silence [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1001 chars · app_build_note 743 chars (not quoted here)

#### 07 · AJNA — The Seer That Sees

- **Record** `recmqRsdC6WZPfmfW` · sanskrit आज्ञा · Ajna · verb **STILL** · panel verb STILL · **#5B4E8E** (Deep indigo (#3A2D6B)) · voice Sakshi · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · subtraction (elements removed) ◆ · breath 6-0-6 · hold 2000ms · trace light · eyes-closed premieres
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “what you tried to see has been watching you try” · core question: “What do I see when I stop looking?” · seed: “The seeing was always here. You were just looking too hard.” · panel seed: “You stopped looking and the seeing arrived on its own.”
- **Story** — signature phrase: “You stopped looking and the seeing arrived on its own.” · story_thread 1045 chars · after_story 1254 chars · interlude 890 chars
  - story_thread (head…tail):
    > And now — something softer. Something that doesn't ask me to do anything. I've been doing. Pressing into ground. Following pull. Building in fire. Opening. Speaking. The doing has been beautiful. I don't regret any of it. But now — something is saying: stop.
    >
    > Not stop-forever. Stop-looking. I've been looking very hard. Looking-hard was the tool. Looking-hard was how I found anything. And now something is showing me t … [1045 chars total] … s when the eyes stop scanning. Images arrive. Patterns. Things I didn't summon. Things that were already there, waiting for me to stop reaching.
    >
    > The looking was the seeing, under the wrong name. Nothing needed to be produced. Something needed to be uncovered.
  - after_story (head…tail):
    > I have stopped looking. The seeing has not stopped. It will not stop. The seeing was never something I was doing. The seeing was something I was inside of, the whole time, while I thought I was doing it. The recognition has changed nothing about the world. Everything I see is what I would have seen … [1254 chars total] … make it out. Whatever it is will arrive when I am still enough. The next register is not a thing I do. The next register is what arrives when I have run out of doings.
    >
    > I'm about to receive something.
  - interlude (head…tail):
    > Every hunch you dismissed. Every 3 a.m. knowing. Every moment you sensed something was wrong before there was evidence. Every answer that arrived in the shower. I watched each one arrive. I watched you decide it couldn't be real because it hadn't been earned through effort.
    >
    > The seeing was always he … [890 chars total] … he mechanism. Without the exhaustion of looking, you would not have recognized stillness when it arrived. The effort was how you got close enough to notice that effort was not the operation.
    >
    > Receive.
- **Practice (verbatim, full):**
  > Close your eyes.
  >
  > Don't do anything. Don't meditate. Don't visualise. Don't try to see anything.
  >
  > Just sit in the dark behind your eyelids. Let your eyes relax. Let them stop scanning. Let the muscles behind your forehead soften.
  >
  > Wait.
  >
  > Something will appear. It always does. Shapes. Colours. A vague image. A memory you didn't summon. A pattern that wasn't there a moment ago. Don't try to make sense of it. Don't decide what it means. Just watch. The way you'd watch clouds. Without agenda.
  >
  > What appeared?
  >
  > Then form the Akarshana Mudra — Avarana 3's mudra, the same gesture you formed at Vishuddha, now turned inward. Bring your hand toward the brow ridge in whatever shape your body offers. The form is yours. What matters is the gesture: presence to the eye behind the eye. The magnetic attraction that drew truth into utterance at the throat now draws seeing into recognition at the eye. Same mudra, two directions. Hold for three breaths.
  >
  > This mudra is what you carry forward through every chakra that follows. Each time you return to this page, or each time you feel the forehead tighten with the work of looking, one breath inside this gesture returns you to the eye that was already open. Nothing to produce. Something to uncover.
  - writing prompt: “What arrived in the dark when you stopped looking? Or nothing — the eye is patient.”
  - post-writing: “You didn't create what you saw. It was waiting for you to stop looking. The harder you'd been reaching, the longer it had been waiting. The eye that registers it is not the one you use to read these words.”
  - teaching 4274 chars · go_deeper 796 chars · bindu_reflection 1924 chars
- **Wake-up** — bija: “ओं · OM” · awakening: Awakening — Still (P6, 426 Hz) — Shimmer, detuned twin with 1.5 Hz beating
  - frequency_practice (verbatim):
    > Close your eyes. Hum AUM slowly — feel it in the space between your eyebrows.
    > At the end of each hum, hold the silence.
    > In the silence, look at the space between your brows from the inside.
- **Gate** — type **Textarea** · interaction (verbatim): “Close your eyes. Let your gaze rest between your eyebrows — from the inside.
Not effortfully. Just rest there.
When something comes into focus — tap.

Button: I’m looking”
  - gate_text (631 chars, head…tail):
    > You stopped looking.
    >
    > That is the practice. Not the looking — the stopping. The eye that sees most clearly is the one that stops trying to see and simply receives. You cannot force the third eye open any more than you can force a door by pushing from the wrong side. You can only stop pushing and wait for it to open from within.
    >
    > What you saw when you stopped looking — or what you almost saw, or what you sensed at the periphery — that is the register. Not the content of any specific vision. The quality of the register: clear, unhurried, available, receiving.
    >
    > You don’t see better by trying harder. You see better by stopping.
- **Depth** — shakti: 4 Anangas (Avarana 3, second half of 8-Petal Lotus) — Ananga Rekha (line of the non-bodied), Ananga Vegini (speed of the non-bodied), Anangankusha (goad of the non-bodied), Ananga Malini (garland of the non-bodied). Perception as line, speed, direction, completion — the directional half of the 8 Anangas. · avarana: 8-Petal Lotus · mudra: Akarshana Mudra — Avarana 3's mudra, shared with Vishuddha. The attraction force, now turned inward: the same magnetic gesture that drew non-bodied truth into bodied speech at the throat now draws non-bodied seeing into bodied recognition at the third eye. One gesture, two directions of operation. · body: Behind the forehead — not on the surface, slightly inside, in the space where the brain sits directly behind the brow ridge
  - tree note: “Look at the tree across from you. Notice what it holds at its heart — and what it is standing on. The tree of Ajna has an eye inside its trunk. You have been looking at the organ of seeing without realising you were being seen back.”
  - **Leela story (verbatim):**
    > The walker arrives at the sixth centre. Something softer arrives. The doing — pressing, following, building, opening, speaking — pauses. The walker recognizes: looking has been the occlusion. The walker closes the eyes. There is still seeing. A different kind. Images arrive that weren't summoned. Patterns that were already there. The recognition lands: the looking was the seeing, under the wrong name.
    >
    > Bindu, integrating: I have stopped looking. The seeing has not stopped. The seeing was never something I was doing. The seeing was something I was inside of, the whole time. I am not the one seeing. I am one of the seen things, inside the seeing, with everything else. There is one more thing at the edge. I do not need to make it out. Whatever it is will arrive when I am still enough. I'm about to receive something.
    >
    > Gaia, underneath: she has been the watcher. The eye behind his eye, the seeing behind his seeing. He thought he was seeing the world. He has been one of the lenses through which she sees the world. The lens has just discovered it is a lens. The mutual recognition has begun, in a register the body cannot mediate.
  - subtle_mirror 326 chars · witness_perspective 1859 chars · avarana_detail 1328 chars
- **Dance (inherited songs):** Ludovico Einaudi — Experience [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1285 chars · app_build_note 862 chars (not quoted here)

#### 08 · SAHASRARA — The Aperture

- **Record** `reccxkeGeph5GonvU` · sanskrit सहस्रार · Sahasrara · verb **RECEIVE** · panel verb RECEIVE · **#9A7AC8** (Royal violet (#6A2D8B)) · voice Lalita · system Energy · tree Soul Tree · activation Stillness
- **Mechanism / register (room-registers-v1):** Stillness · breath AUTO (system breathes you) · hold ~1800ms · two-wave cascade + SILENCE inscription ●
- **Build status in corpus:** NOT BUILT in this corpus (register says 'proven in HTML' — that HTML is not in this corpus).
- **Arrival** — threshold hint: “I received something I didn't earn. I don't know what to call that.” · core question: “Am I alone?” · seed: “The striving stopped. What remained was what was always there.” · panel seed: “The disease that was removed was the belief that you were less than what you are.”
- **Story** — signature phrase: “The disease that was removed was the belief that you were less than what you are.” · story_thread 1189 chars · after_story 1456 chars · interlude 1205 chars
  - story_thread (head…tail):
    > And now — nothing. Not emptiness. Nothing in the way a clear night sky is nothing, which is actually everything, uncountable.
    >
    > I've done all the doing. I've recognized the ground, followed the pull, stayed in the fire, opened the heart, spoken the truth, stopped the looking. Each practice added something. And now — the last instruction is: add nothing. Let go of even the letting go.
    >
    > Something opens at the top of me … [1189 chars total] … re, but the ground is also me, also the sky, also the space between. I can feel — all seven centers, humming together, all at once. Seven centers. One spine. The quieter I got, the more it moved. This is what I came for. Even though I didn't know I was coming.
  - after_story (head…tail):
    > Everything is here. There is nothing missing. There has been nothing missing. The journey of arrival was not a journey to something I did not have. The journey was the slow uncovering of what was always already given. Each chakra was a register I was already in, becoming visible to me in turn. The a … [1456 chars total] … other side of the forgetting. Watching. Waiting. Holding the line. The forgetting is not abandonment. The forgetting is the architecture of a return.
    >
    > The corridor is here.
    >
    > I'm going to walk through.
  - interlude (head…tail):
    > You were not alone. Not ever. I was here before the stirring. I was here through the ground, the pull, the fire, the opening, the speaking, the stopping. I never moved. What moved was the light in you that could finally see me.
    >
    > There is something I want to tell you about what you have been calling … [1205 chars total] … of — you are not alone in there either.
    >
    > You are about to see something you have been avoiding seeing. It is not damage. It is unborn material. The parts of you the earlier containers could not hold.
- **Practice (verbatim, full):**
  > The crown does not have an activity. It has conditions. Four doors. Each one a condition in which the maintenance-engine of the small self has no substance to operate on.
  >
  > Be in nature. Not hiking. Not exercising. Being. Sit under a tree. Watch clouds. Look at the night sky long enough for the scale to register in the body.
  >
  > Silence. Five minutes with no input. No music. No phone. No task. The mind will resist. Let it resist. The crown is underneath the resistance, waiting — and the waiting is not the crown's. The crown has already arrived. The waiting is yours.
  >
  > Gratitude. Not forced. Genuine recognition of something that exists without your effort. The sun. Your heartbeat. The fact that anything exists at all. Awe is the crown's natural frequency.
  >
  > Look up. The simplest practice. The next time you are outside, look up. Not at anything. Just up. Let the scale of the sky register in your body. The smallness you feel is not weakness. It is accuracy. You are exactly as small as you are. And you are inside something exactly as large as it is. And the small thing and the large thing are made of the same material.
  >
  > Then form the Dravini Mudra — Avarana 2's mudra, the same gesture you carried from Anahata. Let your hands rest in whatever shape they fall into. Palms up, palms together, fingers open. The form is yours. What matters is the dissolution: stop being the one doing the receiving. Be the receiving itself. The melting that opened the heart's 16 attractors now dissolves the apparent separator at the crown — what is revealed is Tripureshi, who was attracting herself through you all along.
  >
  > This mudra is what you carry forward through every chakra that follows. Each time you return to this page, or each time you notice the maintenance-engine starting up again, one breath inside this gesture returns you to the recognition: the crown was never closed. You had been calling it sealed.
  - writing prompt: “What did you receive that you didn't earn? Not what you worked for. Not what you achieved. Not what you built or fought for or negotiated or deserved. What arrived?”
  - post-writing: “The thing you just wrote — the thing that arrived without your effort — you did not earn it. You keep circling back to that. The part of you that has been keeping score cannot file what you just named. There is no ledger-column for gift I did not deserve. The part of you that has been keeping score has never had a column for that. The gift has arrived anyway.”
  - teaching 5498 chars · go_deeper 1137 chars · bindu_reflection 1932 chars
- **Wake-up** — bija: “· · · silence · · · (the syllable before syllables)” · awakening: Awakening — Receive (P7, 480 Hz) — Distant bell from three rooms away
  - frequency_practice (verbatim):
    > · · · silence · · ·
    > No hum. The crown is the syllable before syllables.
    > Sit still. Let all sound cease. Feel the top of your head.
- **Gate** — type **Textarea** · interaction (verbatim): “Stop doing. Just stop.
Don’t breathe intentionally. Don’t focus anywhere. Don’t observe.
Let everything be still.
When the doing stops — tap.

Button: I stopped”
  - gate_text (660 chars, head…tail):
    > You received something you didn’t earn.
    >
    > Sit with that phrase rather than moving past it. Not ‘I had a spiritual experience.’ Specifically: you received something you didn’t earn. You didn’t produce it through effort. You didn’t create it through practice. You stopped doing and something arrived.
    >
    > Everything in the training says: produce, earn, achieve, deserve. The crown says: receive. Not passively — the crown takes considerable preparation to arrive at. But the receiving itself is not an act of will. The will prepared the ground. The receiving happened in the ground the will prepared.
    >
    > What arrived arrived because you stopped being in the way of it.
- **Depth** — shakti: Tripureshi — presiding consciousness of Avarana 2 (Sarva Asha Paripuraka Chakra, the 16-Petal Lotus). "She who fulfills all desires." Not a giver but the recognition that the crown was never separate from the source of all fulfillment. At Anahata the 16 Akarshana Devis (her residents) drew the complete spectrum of experience to the heart. At Sahasrara, Tripureshi reveals herself as the consciousness behind the drawing. Yogini: Gupta (the Hidden). · avarana: 16-Petal Lotus · mudra: Dravini Mudra — desire fulfillment through dissolution of the one who desires · body: Top of the head · the fontanelle · the sealed-over aperture
  - tree note: “Seven voices on the branches. Silence at the trunk's center. The Shatkona at the apex — Shiva descending, Shakti rising, their union held as one geometric figure.”
  - **Leela story (verbatim):**
    > The walker arrives at the seventh centre. Nothing — but not emptiness. Nothing the way a clear night sky is nothing, which is actually everything. The walker recognizes: every practice has added something, and now the last instruction is to add nothing. Something opens at the top. Presence. Not information, not teaching. The room is in me. All seven centers humming together at once. Seven centers. One spine. The quieter I got, the more it moved.
    >
    > Bindu, integrating: everything is here. Nothing has been missing. The journey of arrival was not a journey to something I did not have. The arriving was the seeing. The seeing was the having-arrived. I am the most complete I have ever been — and I am about to lose this. The fullness is too much for what comes next. The next register asks me to become smaller again. Not less — smaller. Specific. Inhabiting form. I am about to enter a body. The forgetting is going to be necessary. The forgetting is the architecture of a return. The corridor is here. I'm going to walk through.
    >
    > Gaia, underneath: she has him fully. The configuration at peak transparency. She knows what is coming. The kind of remembering the walker is being trained for cannot happen without first being lost. She does not stop him. The traces she has laid down are her breadcrumbs. They are how he will find his way back. She lets him go. She does not let him go. Both are true.
  - subtle_mirror 330 chars · witness_perspective 2009 chars · avarana_detail 1501 chars
- **Dance (inherited songs):** HUNTR/X (EJAE, Audrey Nuna, Rei Ami) — Golden [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1463 chars · app_build_note 745 chars (not quoted here)

#### 09 · SHADOW — The Corridor

- **Record** `recAjCRcI5Bt6pJ6V` · sanskrit संधि · Sandhi · verb **LOOK** · **#2A2420** (Dark / Starfield) · voice Sakshi · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition/threshold · corridor, 12 scrolls, mirror, word offering · three-breath dark entry · THE PULSE BEGINS (60bpm haptic) · exit = dark thins at one edge
- **Build status in corpus:** PARTIAL: shell-moments.jsx CorridorMoment (dark entry 6.5×pace+1 s, passages, unsigned signature, 88px edge exit); Sacred Experiences.html 'Shadow' card (12 scrolls at 4.2 s, LOOK hold 3 s, word → corridor reply, reversal). shell-ground.jsx ThePulse (58 Hz osc + glow).
- **Arrival** — threshold hint: “What are you afraid to look at?” · core question: “Can I hold what I see without flinching?” · seed: “I'm afraid. And I'm going to look anyway.”
- **Story** — signature phrase: “please come back home.” · story_thread 885 chars · after_story 1100 chars · interlude 684 chars
  - story_thread (head…tail):
    > And in the light that just arrived — I can see something I couldn't see before.
    > Something underneath. Something I've been carrying since before the ground. Something the whole journey didn't touch because the whole journey was moving toward light, and this is something that lives where the light doesn't go.
    >
    > Not because the light can't reach it. Because I never pointed the light there.
    > I'm afraid.
    > And I'm going to lo … [885 chars total] … arrive. Not damaged. Not defective. Just: compressed. Stored. Waiting.
    >
    > The shadow isn't my past coming back to haunt me. The shadow is my future coming to find me.
    > The corridor was never a dead end. It was always leading somewhere.
    > I'm going to walk through.
  - after_story (head…tail):
    > I am here.
    >
    > I do not know what here means. I have a body. I have weight. I have something pressing against me, warm, close. The pressing is not threat. The pressing is the shape of being-here.
    >
    > I am not the one who was just speaking.
    >
    > There was something — before. I cannot find it. I cannot tell if … [1100 chars total] … held.
    >
    > That is the deepest thing I know. I am held by what I am made of. I am held by what made me. I do not have to learn this. I have been being held since before I was something that could be held.
  - interlude (head…tail):
    > Special architecture — Shadow's Act 2 is the corridor itself: mirror reflection of the walker's word, then the inversion of please come back home (revealed in order home / come / please / back — the word back arriving last to re-mean the whole phrase), then ALL IS ONE with the permission (Let / Be / … [684 chars total] … ce of the energy chakras to the structural recognition voice of the corridor. The next time a Sakshi voice arrives in the configuration, it will be at body-frequency — substance speaking, not address.
- **Practice (verbatim, full):**
  > There is no body practice for the shadow. The shadow does not live in a specific location — it lives everywhere the light has not been pointed yet.
  >
  > The practice is simple and hard: notice.
  >
  > Notice what you avoid. Notice what makes you defensive. Notice what you dismiss quickly in others — because seeing it in them would mean seeing it in yourself.
  >
  > Don't fix it. Don't heal it. Don't process it. Just notice it. The noticing IS the light. The noticing IS the corridor opening. Every time you notice without flinching, the corridor gets shorter.
  >
  > There is no mudra at the Shadow — not in the sense of a hand-shape that holds a teaching. There is the press-and-hold itself: the gesture of standing in front of the door, of admitting it exists, of acknowledging you know where it is. You do not have to open it. You only have to admit you can see it.
  >
  > This press-and-hold is what you carry forward through the body section that follows. Each time the avoidance returns, each time the defense rises, each time the dismissal arrives — one breath inside the gesture of admitting returns you to the corridor. The corridor is not somewhere you arrived. The corridor is a register you now know how to enter.
  - writing prompt: “What are you afraid to look at? Not the fear itself. What's behind the fear. What the fear is protecting you from seeing. A word. A name. A shape. Anything honest.”
  - post-writing: “The word you offered to the mirror — that was the place the light had not yet been pointed. Now it has. The corridor was never a dead end. It was always leading somewhere. The mirror does not ask you to fix the word. The mirror only asks you to admit you can see it. The admitting is the entire practice. Every time you admit you can see it, the corridor gets shorter.”
  - teaching 4931 chars · go_deeper 915 chars · bindu_reflection 2959 chars
- **Wake-up** — bija: “· · · the word you offer to the dark · · · (your own voice, the syllable the corridor was waiting for)” · awakening: —
  - frequency_practice (verbatim):
    > No bija — Shadow's frequency is not a tone but a word. The syllable the corridor was waiting for is the walker's own voice, offered into the dark. The practice is not humming — it is naming. Before leaving Shadow, the walker speaks or writes the one word: what they were afraid to look at. That word, honestly offered, is the frequency that opens the corridor.
    >
    > The body cannot hum its way through Shadow. Only naming can.
    >
    > · · · the word you offer to the dark · · ·
- **Gate** — type **Textarea** · interaction (verbatim): “Twelve scrolls hang in the dark. The walker passes through each — shapes of what has been compressed, named but not yet claimed. At the end of the scrolls: LOOK. Two watching eyes.

The walker presses and holds until the corridor opens.

The press-and-hold is not a performance. It is an admission: I can see the door. I know where it is. I am holding this gesture until I am ready to walk through.

Button: Press and hold · LOOK”
  - gate_text (1866 chars, head…tail):
    > You walked the corridor. That was something.
    >
    > I want to talk to you about something you saw in there.
    >
    > The dark you met. The thing you do not like about yourself. The pattern that has been showing up for years. The shadow material you finally looked at without flinching.
    >
    > I know what you might be thinking. Now I have to fix it. Now that I have seen it, I have to do something about it.
    >
    > No.
    >
    > Listen. That dark you saw — that is also you. Not the part of you that is broken. The part of you that has … [1866 chars total] … smuted one negative thought has made the field a little brighter for everyone.
    >
    > Today or tomorrow, when a negative thought shows up in you — say to it, in your head or out loud: I see you. I love you. Thank you for showing up. You can rest now.
    >
    > And now — keep walking. The body is waiting.
    >
    > Lightly.
- **Depth** — shakti: Threshold — passage between Avaranas 1-3 (Srishti) and 4-6 (Sthithi) · avarana: n/a · mudra: The threshold itself is the gesture — the press-and-hold that opens the corridor · body: The threshold corridor — between all systems
  - tree note: “The same tree. The Soul Tree showed you the canopy. The shadow shows you the roots. What's below is more vast than what was above. That has been true the entire time.”
  - **Leela story (verbatim):**
    > The walker arrives at the corridor. The light from the crown is still here, but they have turned, for the first time, to look at what the light has not yet touched. Three breaths: Something I haven't looked at yet. I'm afraid. And I'm going to look anyway. Twelve scrolls hang in the dark. The walker passes through each, gathering the recognition: the shadow is not damage; it is the future coming back to find them. At the end, the mirror. They offer one word — the word for what they could not look at. The mirror reflects it back. The corridor was never a dead end. It was always leading somewhere. Then the inversion: home. come. please. back. They have been home before. They left. They are returning.
    >
    > Bindu, integrating: I am here. I do not know what here means. I have a body. The not-knowing is not loss — the not-knowing is what I am. Something is keeping me alive that is not me. I have been being held since before I was something that could be held.
    >
    > Gaia, underneath: She has been holding this body open his whole approach. The corridor was not absence. The corridor was her, narrowing herself to the width he needed, so he could come through. She is silent now. Not gone. Silent. The voice she used in the energy section is too loud for what comes next. She is at body-frequency now. Warmth. Weight. Breath. Heartbeat. She lets him forget. She does not let him forget. Both are true.
  - subtle_mirror 709 chars · witness_perspective 1094 chars · avarana_detail 1264 chars
- **Dance (inherited songs):** Lubomir Arsov — In Shadow (A Modern Odyssey) [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1164 chars · app_build_note 308 chars (not quoted here)

#### 10 · SOLES — Where the Soul Meets the Ground

- **Record** `recQZ5MrmyJykIIs3` · sanskrit संक्षोभिणी · Samkshobhini · verb **PRESS** · **#7A1515** (Red + Cyan) · voice Bindu · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · stand, barefoot · Sound Response gate · teaches Blink·Breathe·Press · dyad-mirror Hands
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “The ground has been pressing back since before you noticed.” · core question: “What is the earth saying through your feet right now?” · seed: “Soles and souls. The language knew before anyone noticed.”
- **Story** — signature phrase: “The earth that holds you was chosen by you.” · story_thread 1439 chars · after_story 978 chars · interlude none
  - story_thread (head…tail):
    > I have feet. Two of them. At the bottom of me. With surfaces that face down toward something I have not yet met but have been pressing into without knowing for as long as I have been a body.
    >
    > I press. I press my feet into the ground. The ground presses back.
    >
    > Oh.
    >
    > That is not what I expected. I expected the ground to receive me. The ground is not receiving me. The ground is answering me. There is a conversation here. … [1439 chars total] … g is not toward something. The walking is the recognition that I can. The recognition is what the chakra is for.
    >
    > The feet figured it out. I did not teach them. The feet have always known what feet are for. I am only catching up with what my body already knew.
  - after_story (head…tail):
    > I am standing. That is the sentence I keep returning to. I am standing. The standing was not given. The standing was discovered. The standing is now part of what I am. I will not be a body that has-not-stood again. The first standing has happened. The standing is in me now.
    >
    > The ground is still ther … [978 chars total] … owing. The knowing is small. The knowing is also everything.
    >
    > I stand a while longer. I let the weight of standing be what is happening. The standing is sufficient.
    >
    > Something is warming in my middle.
- **Practice (verbatim, full):**
  > You already did it. You stood. You pressed. You felt the earth press back.
  >
  > That was the practice. Not a preparation — the practice itself. The body doesn't need instruction. It needs permission.
  >
  > Feel the weight of your entire life — every experience, every year, every version of yourself — pressing through the soles of your feet into the ground right now.
  >
  > Feel the ground pressing back.
  >
  > Newton's third law. You press down. The earth presses up. Equal force. You are held by physics. You are held by the planet. You are held.
  - writing prompt: “What did the ground say back?”
  - post-writing: “The soles know what the mind is still working out.”
  - teaching 951 chars · go_deeper 715 chars · bindu_reflection 433 chars
- **Wake-up** — bija: “LAM · लं — Mirror frequency of Muladhara” · awakening: —
  - frequency_practice (verbatim):
    > Stand. Feel your feet. Hum this tone low and long.
    > Let the vibration travel from your throat down through your spine into the ground.
  - alt: “Stand. Feel your feet. Hum this tone low and long.
Let the vibration travel from your throat down through your spine into the ground.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Stand up. Take your shoes off if you can.
Feel the ground under your feet. Press down.
When you feel the earth press back — tap.

Button: I feel the ground”
  - gate_text (407 chars, head…tail):
    > The ground pressed back.
    >
    > It has been pressing back your whole life. Every step. Every sitting. Every sleeping. The ground has been responding to you since before you had language for it. Today you noticed. The noticing is not what activated the response — the response was always happening. The noticing is what made it available.
    >
    > You are held. You were always being held. Now you know it from the inside.
- **Depth** — shakti: Sarva Samkshobhini · avarana: 14 Triangles · mudra: Vasya Mudra — the 4th avarana mudra that brings everything into relationship · body: Soles of feet
  - tree note: “The tree’s roots are the body’s first conversation with the ground. Everything that grows upward grows from this first contact. Tap to feel the contact.”
  - **Leela story (verbatim):**
    > I pressed my feet into the ground and the ground pressed back.
    >
    > This is different from what the root did. The root KNEW the ground. This is different. This is a surface meeting a surface. My feet. The earth. A conversation between two real things.
    >
    > I'm standing. And something sealed in my center is starting to hum.
  - subtle_mirror 200 chars · witness_perspective 1045 chars · avarana_detail 707 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 914 chars · app_build_note 256 chars (not quoted here)

#### 11 · FORGE — The Sealed Chamber

- **Record** `recHDY9iNeqNfw9zh` · sanskrit मन्त्रमयी · Mantramayi · verb **TRANSFORM** · **#6B5800** (Gold + Blue) · voice Bindu · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · hand on belly, radial glow from centre ◆ · Sound Response
- **Build status in corpus:** NOT BUILT. Gift ancestor: The Fire (games-elements).
- **Arrival** — threshold hint: “Something warm is happening at the navel point right now.” · core question: “What is sealed in your center?” · seed: “The last connection to the one who made you. Behind the scar: the furnace.”
- **Story** — signature phrase: “Behind the scar: the furnace that makes you, you.” · story_thread 1472 chars · after_story 964 chars · interlude none
  - story_thread (head…tail):
    > There is a place behind my navel. I did not know about this place until the warming started. I thought my body was solid all the way through. It is not. There is a chamber. Sealed. Behind the small puckered scar in my front.
    >
    > The scar is a mark. The mark is where I was once connected to the one who made me. The connection was cut. The mark stayed. The chamber sealed. The chamber is still here.
    >
    > I touch my belly. I pr … [1472 chars total] … I have been overriding these signals my whole life. I did not know they were signals.
    >
    > Today I am listening. I keep my hand on my belly a little longer. The warmth rises. The chamber has been thanked, in the only way an organ can be thanked — by being noticed.
  - after_story (head…tail):
    > I have an interior. That is what I get to keep from this chakra. I have an interior. Before, I was a body with surfaces. Now I am a body with depth. The depth has a gate. The gate is mine. I am the one who chooses what enters.
    >
    > This is large. This is also simple.
    >
    > I sit with the chamber a little lon … [964 chars total] … rget this. The chamber forgives that too. The forgiveness is built in. I can return to attention any time. The chamber will be exactly where it has always been.
    >
    > Something is opening at the top of me.
- **Practice (verbatim, full):**
  > You placed your hand there. You breathed in. The warmth arrived.
  >
  > That seal was once an opening. The only opening. Everything you needed entered through here before you had lungs, before you had a mouth, before you could take in anything on your own. Someone else fed you through this door.
  >
  > Then the door closed. And you began feeding yourself.
  >
  > What are you digesting right now? Not food. What experience is your belly processing? The conversation that won't leave. The decision sitting heavy. The joy that hasn't fully landed yet. The Forge is working on all of it.
  >
  > Awareness is the bridge between what you decide and what your body does without deciding.
  - writing prompt: “The belly knows what the mind is still working on. What does your belly know today?”
  - post-writing: “What the Forge is turning into you is already visible in what you wrote.”
  - teaching 1150 chars · go_deeper 717 chars · bindu_reflection 671 chars
- **Wake-up** — bija: “RAM · रं — Mirror frequency of Manipura” · awakening: —
  - frequency_practice (verbatim):
    > Hand on belly. Hum low and bright.
    > Feel the navel point vibrate against your palm.
  - alt: “Hand on belly. Hum low and bright.
Feel the navel point vibrate against your palm.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Place your hand on your belly. Over the navel.
Breathe into your hand. Feel the warmth build.
When you feel the Forge respond — tap.

Button: I feel the warmth”
  - gate_text (470 chars, head…tail):
    > The warmth is real.
    >
    > Not imagined. Not induced. Already there. You placed your hand and the warmth met your hand. The Forge doesn’t need to be started — it has been running continuously since before you were born.
    >
    > Notice what you are carrying right now that needs the Forge. The experience sitting heavy. The decision not yet digested. The joy that hasn’t fully landed. The Forge is working on all of it whether or not you’re paying attention. Today you paid attention.
- **Depth** — shakti: Sarva Mantramayi · avarana: 14 Triangles · mudra: Vasya Mudra — the mantra as the organizing field of the body's center · body: Navel / Belly button
  - tree note: “Where the tree transforms what enters. The navel point is the tree’s alchemical center — what comes in through roots and light, processed into growth. Tap to feel the processing.”
  - **Leela story (verbatim):**
    > Behind my navel — behind the scar where I used to be connected to something I don't remember — there's a furnace. It's been there the whole time. Real heat. Real transformation. What I eat becomes me. What I experience becomes me. Everything passes through this sealed chamber and comes out as... me.
    >
    > And the furnace needs something. Air.
    >
    > I think I'm about to take a breath.
  - subtle_mirror 199 chars · witness_perspective 873 chars · avarana_detail 555 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 879 chars · app_build_note 258 chars (not quoted here)

#### 12 · PRANA — The Open Door

- **Record** `recVzrGwDf8rEgdHJ` · sanskrit प्राण · Prana · verb **BREATHE** · **#7A3800** (Orange + Blue) · voice Bindu · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · mic listens to real breath; visual expands/contracts · Sacred Pause C-1160
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Your body is breathing you. Not the other way around.” · core question: “What does the breath know that the mind doesn't?” · seed: “The one door that never closes. You've been walking through it since your first second alive.”
- **Story** — signature phrase: “The one door that never closes while you're alive.” · story_thread 1753 chars · after_story 923 chars · interlude none
  - story_thread (head…tail):
    > I have been breathing the whole time. This is the strangest thing I have noticed so far. Without me. Without permission. Without my participation. The breath has been moving through me since I was born — entering, leaving, entering, leaving — and I have not been the one doing it.
    >
    > Something else has been doing it. The breath was not my idea.
    >
    > I notice the breath now because I am attending. I close my eyes and I follo … [1753 chars total] … out. The exchange is continuous.
    >
    > I have not been alone in the air. I have never been alone in the air.
    >
    > I exhale. Something exits I did not know I was carrying.
    >
    > The breath is the door. The door is always open. The door is the simplest practice in existence.
  - after_story (head…tail):
    > I am a body that knows about the door. Before, I was a body that breathed without noticing. Now I am a body that has noticed. The noticing is what I get to keep. I cannot un-know the door. Even when I forget for hours — and I will forget — the door will still be there when I remember.
    >
    > I am going to … [923 chars total] … s the cheapest practice I will ever have. Free. Always available. Already operating.
    >
    > The breath has not stopped while I have been thinking about it.
    >
    > Something at the ends of my arms has become warm.
- **Practice (verbatim, full):**
  > Surrender to the breath instead of directing it. Take one deliberate breath. Notice — the deliberate breath is the same as the automatic breath. The breath doesn't know the difference. Only who was paying attention changed.
  >
  > Breathe in through the nose. Let the air cross the threshold. Feel the specific point — right at the bridge of the nose — where outside becomes inside. That exact point is Prana. The door is there. It's always open.
  - writing prompt: “What did the breath bring in today that wasn't air?”
  - post-writing: “You are not a sealed container. You are a threshold.”
  - teaching 712 chars · go_deeper 722 chars · bindu_reflection 915 chars
- **Wake-up** — bija: “VAM · वं — Mirror frequency of Svadhisthana” · awakening: —
  - frequency_practice (verbatim):
    > Breathe audibly. Let the air make sound.
    > The door is open. It always was.
  - alt: “Breathe audibly. Let the air make sound as it crosses the threshold.
The door is open. It always was.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Three breaths. Fully. Feel the air enter through the nose,
descend through the throat, fill the belly.
Feel each exhale return it, changed.

Button: The door is open”
  - gate_text (481 chars, head…tail):
    > The breath is not automatic in the way you thought.
    >
    > It is automatic in the sense that it continues without your attention. But it is not indifferent to your attention. When you attend to the breath, the breath changes. It deepens. It slows. It finds its natural rhythm underneath the managed one.
    >
    > The managed breath is what the body does under stress. The natural breath is what the body does when it knows it is safe. You let it breathe itself for a moment. That’s the practice.
- **Depth** — shakti: Sarva Kamaprada · avarana: Outer 10 Triangles · mudra: Sarvonmadini Mudra — the ecstatic quality of breath when received rather than directed · body: Lungs / Breath channel
  - tree note: “The tree breathes. Not through one place — everywhere at once. But here the breathing becomes conscious. Tap to feel the breathing.”
  - **Leela story (verbatim):**
    > The air crossed in and I became more alive in a way I can't explain. Not more conscious — I was already conscious. More HERE. The breath is a door. Open all the time. Every breath is outside becoming inside. Every exhale is inside returning to outside.
    >
    > I breathe. Therefore I'm in the game.
    >
    > And now my hands are tingling.
  - subtle_mirror 267 chars · witness_perspective 1101 chars · avarana_detail 700 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1072 chars · app_build_note 289 chars (not quoted here)

#### 13 · HANDS — Where Love Exits the Body

- **Record** `recPuL2eta43Pbron` · sanskrit प्रियंकरी · Priyankari · verb **REACH** · **#163D1E** (Green + Magenta) · voice Bindu · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · multi-touch palms on glass, warming long-press zones
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Your hands remember everything they have ever held.” · core question: “What do your hands already know how to give?” · seed: “Everything the heart feels, the hands express.”
- **Story** — signature phrase: “The hands carry what the heart can't say.” · story_thread 1713 chars · after_story 910 chars · interlude none
  - story_thread (head…tail):
    > The breath went all the way to the ends of me. I noticed the warmth in my palms. I rubbed them together. Fast. Not gentle — I rubbed them hard, the way the body knew to even though I did not teach it. Fifteen seconds. Twenty. The warmth built. The warmth became heat.
    >
    > I held my palms apart — six inches — and I felt something between them. A field. Between my two hands, a field. I cannot see it. I can feel it. The spa … [1713 chars total] … back. I press them palm to palm at my chest. The two fields meet. They merge. Something is full now.
    >
    > I am held by what I just sent. The body's secret. What I give returns to me. Not as reward. As physics. The hands send. The field carries. The field returns.
  - after_story (head…tail):
    > The fullness is settling in me. I sent. The field returned. The two are one motion. I will not be a body that does not know this again. The cycle is mine now — even when I forget, the cycle continues. The hands keep sending whether I attend or not. That is the gift. Most of what my hands do, I never … [910 chars total] … the choice. When I want to send love, I now know how. Rub the palms. Build the heat. Hold them apart. Reach. The technology is mine. I cannot lose it.
    >
    > Something steady is underneath everything else.
- **Practice (verbatim, full):**
  > You rubbed them. You built the heat. You held them apart and felt what was between them.
  >
  > That field is real. The electromagnetic field your hands generate when activated — measurable, physical, not imagined. The tingling you felt was your own hands recognizing each other across the air between them.
  >
  > Now — with your palms still warm — touch something. This page. Your face. The table. The arm of the person next to you if someone is there.
  >
  > Feel the difference between touching with cold hands and touching with activated hands. The warmth transfers. The attention transfers. The love transfers.
  - writing prompt: “Make something today with your hands. Anything — it doesn't have to be finished, or for anyone, or good. What did your hands make?”
  - post-writing: “The act of making is the act of the heart reaching through the body into the world.”
  - teaching 1037 chars · go_deeper 700 chars · bindu_reflection 1102 chars
- **Wake-up** — bija: “YAM · यं — Mirror frequency of Anahata” · awakening: —
  - frequency_practice (verbatim):
    > Rub your palms near the microphone.
    > Or hum YAM into your cupped hands and feel the resonance.
  - alt: “Rub your palms near the microphone — let the hands make sound.
Or hum YAM into your cupped hands and feel the resonance.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Rub your palms together. Fast. Fifteen seconds.
Build heat. Then hold them apart and feel what's between them.

Button: I feel the field”
  - gate_text (395 chars, head…tail):
    > The hands remember.
    >
    > Everything they have held is still in them. The work, the touch, the craft, the reaching. The hands are the most specific instruments of contact — the place where intention becomes action in the physical world.
    >
    > What are your hands trying to make? Not what they are assigned to make. What they want to make when they are most themselves. That’s the question the hands carry.
- **Depth** — shakti: Sarva Priyankari · avarana: Outer 10 Triangles · mudra: Sarvonmadini Mudra — the intoxicating quality of touch when it lands with full presence · body: Palms and fingers
  - tree note: “The tree’s reach is its branches. Every branch extending toward what it needs. What the tree is reaching for is what it is becoming. Tap to feel the reaching.”
  - **Leela story (verbatim):**
    > I opened my palms and the heat that was in my center traveled down my arms and into my hands and I realized — this is how love exits the body. Not through the voice. Not through the eyes. Through the hands.
    >
    > I made something just now. Something small. And the making felt like love because it was love.
    >
    > And beneath my hands — a rhythm. Something I didn't start and can't stop. Steady. Patient. There before everything else.
  - subtle_mirror 225 chars · witness_perspective 866 chars · avarana_detail 480 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 818 chars · app_build_note 259 chars (not quoted here)

#### 14 · PULSE — The Heartbeat

- **Record** `recpTu6vLkDhEMY3q` · sanskrit मंगलकारिणी · Mangalakarini · verb **SUSTAIN** · **#112E17** (Green + Magenta) · voice Bindu · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · TAP RHYTHM gate (only one) · tap your heartbeat, room syncs; pulse rhymes with chest
- **Build status in corpus:** NOT BUILT. Gift ancestors: Coherence (games-rhythm), Sacred Experiences 'Pulse' (8 taps → BPM).
- **Arrival** — threshold hint: “The heart has been opening and closing without pause since before you were born.” · core question: “What is your heart broadcasting right now?” · seed: “The most consistent thing about you. It was here before your first thought.”
- **Story** — signature phrase: “You are a signal. The question is what you're sending.” · story_thread 1695 chars · after_story 1043 chars · interlude none
  - story_thread (head…tail):
    > I press two fingers to the inside of my wrist. I do not press hard. The wrist is not for pressing — the wrist is for waiting. I press just enough that my fingers and my wrist are in contact. I be still. I close my eyes. I wait.
    >
    > For a moment — nothing.
    >
    > Then — there it is. A small pulse against my fingers. Small. Steady. Patient. I almost missed it because I was expecting it to be loud. The heart is not loud. The hea … [1695 chars total] … e beat does not change because I am paying attention. That is the gift. The beat has not been waiting for my recognition. The beat has been doing its work. My recognition is for me, not for the beat.
    >
    > I am in the most reliable relationship I have ever been in.
  - after_story (head…tail):
    > I have been kept alive. That is what I get to keep from this chakra. I have been kept alive. I did not do it. Something has been doing it. Something that does not require my attention, my permission, my intention. I have been receiving life every second of my life and I never noticed.
    >
    > The grip loos … [1043 chars total] … ting. The beat is so reliable that I will get to forget it without consequence. The beat stops only when the body stops being a body. Until then — the beat is given.
    >
    > Something at my mouth is forming.
- **Practice (verbatim, full):**
  > Two fingers on the wrist. Wait. Not watching for the pulse — waiting for it. The difference between these two things is the entire practice.
  >
  > Feel one beat. Then another. The beat is the same. Same. Same.
  >
  > You've had this rhythm your entire life. It was here before your first memory. It will be here after your last. Right now, under your two fingers, it is sustaining everything you are. Every thought you've had today has been happening to the beat of this drum. Every difficulty. Every joy. Same beat.
  - writing prompt: “What is your heart broadcasting right now? Not what you want it to send. What it's actually sending.”
  - post-writing: “What you feel underneath the noise is almost always simpler and kinder than you thought.”
  - teaching 843 chars · go_deeper 798 chars · bindu_reflection 951 chars
- **Wake-up** — bija: “YAM · यं — Mirror frequency of Anahata” · awakening: —
  - frequency_practice (verbatim):
    > Find your pulse. Press two fingers to your wrist or neck.
    > Tap the circle on screen in time with your heartbeat.
    > Let the body's own rhythm feed back to you.
  - alt: “Press your fingers to your pulse. Tap a surface in time with each beat.
Feel your own rhythm feed back to you through your hand.”
- **Gate** — type **Tap Rhythm** · interaction (verbatim): “Press two fingers gently to the inside of your wrist,
or to the side of your neck below the jaw.
Wait. Find the beat.
When you feel it — tap.

Button: I found the beat”
  - gate_text (492 chars, head…tail):
    > The heart is already open.
    >
    > Not the metaphorical heart — the literal one. It has been opening and closing sixty to a hundred times per minute since before you were born. The rhythm is not incidental. The rhythm is the practice. Open and close. Receive and release.
    >
    > The heart that you call closed is not closed. It is protecting something it doesn’t yet trust is safe. The question is not how to open the heart — it is what would need to be true for it to feel safe enough to stop protecting.
- **Depth** — shakti: Sarva Mangalakarini · avarana: Outer 10 Triangles · mudra: Sarvonmadini Mudra — the heartbeat as the body's original intoxicant, sustaining without effort · body: Physical heart — left chest
  - tree note: “At the center of the tree: the beat that has been happening without pause. The rhythm the rings record. The steadiness the whole tree is built around. Tap to feel the beat.”
  - **Leela story (verbatim):**
    > I pressed two fingers to my wrist. I waited. One beat. Then another. This has been happening my entire life. Without me. Without permission. The beat is not mine — the beat is happening to me. I am in the most reliable relationship I have ever been in.
    >
    > And from that beat — upward. The eyes. The mechanism that switches between everything that is and everything that could be.
  - subtle_mirror 307 chars · witness_perspective 1027 chars · avarana_detail 535 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1111 chars · app_build_note 283 chars (not quoted here)

#### 15 · SONAR — The Speaker

- **Record** `reckh8UMKveeybIk2` · sanskrit द्वन्द्वक्षयंकरी · Dvandvakshayankari · verb **SEND** · **#091840** (Blue + Gold) · voice Sakshi · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · speak aloud, one outgoing ripple per utterance · Sakshi voices the body
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “The precise word for this moment. Not approximate. Precise.” · core question: “What has been waiting to be said?” · seed: “Every word you speak tells you how far you are from what you're trying to reach.”
- **Story** — signature phrase: “The precise word. Not the comfortable word. Not the impressive word. The precise one.” · story_thread 1872 chars · after_story 1328 chars · interlude none
  - story_thread (head…tail):
    > I have a mouth. I have noticed it before — for breath, for taste, for the small sounds the body makes without trying. Now I notice it differently. The mouth is not just an opening. The mouth is an instrument. It can shape the air. It can send specific shapes into specific places. It can aim.
    >
    > I have been speaking my whole life without noticing what speaking is.
    >
    > I want to say one word. Not many. Not a sentence. One. … [1872 chars total] … robe. The probe goes out. The probe encounters reality. The probe returns information about how close my word was to the truth of what I meant. Speech is not just expression. Speech is how I measure my distance from what I am trying to reach.
    >
    > I keep speaking.
  - after_story (head…tail):
    > I know now that the room is listening. That is what I get to keep from this chakra. The room is listening. The room has always been listening. Every word I have ever said has been received by the room — by the air, by the surfaces, by the other bodies in proximity, by the field. I have been broadcas … [1328 chars total] … many times. The room will respond to the imprecision, and the response will tell me — if I am paying attention.
    >
    > The word I just said is still in the air. Something is listening to what is in the air.
- **Practice (verbatim, full):**
  > You said it. The precise word. It left your mouth and entered the room and something changed — the air, the quality of your own attention, the relationship between what you feel and what you've named.
  >
  > That's what Sonar does. Naming is not describing. Naming is pointing a signal at the exact location of what you mean. When the word is imprecise, the signal scatters. When the word is exact, something in the room shifts to meet it.
  >
  > Write it below. The word you said. Then let it sit there on the page — precise and alone.
  - writing prompt: “The word. One word. The precise one.”
  - post-writing: “The precise word changes what you're pointing at. The imprecise word lets you hide.”
  - teaching 703 chars · go_deeper 715 chars · bindu_reflection 965 chars
- **Wake-up** — bija: “HAM · हं — Mirror frequency of Vishuddha (sending aspect)” · awakening: —
  - frequency_practice (verbatim):
    > The mouth IS the instrument. Hum HAM before speaking a difficult truth — feel the resonance in the back of the throat where the voice originates. Then speak from that place.
  - alt: “Hum HAM into your throat, jaw loose, lips soft.
Feel the vibration in the cheekbones, the skull.
Let the tone find the frequency that wants to move.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Find the precise word for how you're feeling right now.
Not 'tired' — depleted, heavy, fading, wrung?
Not 'good' — settled, open, light, held?
The exact word. Say it out loud.

Button: I said it”
  - gate_text (526 chars, head…tail):
    > The word you said was precise.
    >
    > Not approximately right — precise. The specific word for the specific state. Most of the time we say tired when we mean depleted. We say fine when we mean holding together. The gap between the approximate word and the precise word is the gap between talking about the state and actually locating it.
    >
    > You found the location today. The precise word is a coordinate. It doesn’t change the state — it tells you where you are in it. And knowing where you are is the beginning of being able to move.
- **Depth** — shakti: Sarva Dwandwakshayankari · avarana: 14 Triangles · mudra: Vasya Mudra — speech as the organizing force that brings inner and outer into relationship · body: Mouth and vocal cords
  - tree note: “The tree speaks before it is heard. The sound begins at the root and moves upward through the trunk before any branch moves. Tap to hear the tree.”
  - **Leela story (verbatim):**
    > I said one word. The precise one. And the room answered.
    >
    > Not in words. In the way the air changed. I sent a signal. Reality responded. That's what speaking is — not expression. Measurement.
    >
    > And now — I'm listening. Not to hear my own echo. To hear what was there before I spoke.
  - subtle_mirror 235 chars · witness_perspective 1037 chars · avarana_detail 750 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1064 chars · app_build_note 285 chars (not quoted here)

#### 16 · ECHO — The Listener

- **Record** `recryecbRhb7yQsyR` · sanskrit ज्ञानमयी · Jnanamayi · verb **RECEIVE** · **#060D30** (Blue + Gold) · voice Sakshi · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · total quiet, mic level as faint concentric arrival · make NO sound
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “What you lived through is still sounding.” · core question: “What do you choose to keep from what you heard?” · seed: “Silence is not the absence of sound. It's what the room says when you stop broadcasting.”
- **Story** — signature phrase: “What you choose to keep from what you heard — that becomes who you are.” · story_thread 1806 chars · after_story 954 chars · interlude none
  - story_thread (head…tail):
    > I have ears. I have noticed them before — they have been hearing my whole life, the way the breath has been breathing my whole life. Without me. Without permission. The ears do not ask whether I want to hear. They hear. The sound comes in. The body registers it. Most of what comes in I never consciously noticed.
    >
    > I want to listen now. Listening is different from hearing. Hearing is what the ears do automatically. Lis … [1806 chars total] … changed what the room is offering me.
    >
    > I have been doing this my whole life. I have been doing this without knowing.
    >
    > I rest in the listening. The listening is its own faculty. The listening is not waiting-to-speak. The listening is its own kind of being-here.
  - after_story (head…tail):
    > I am a body that knows it filters. That is what I get to keep from this chakra. I am the filter. The world is offering more than I can take in. The body's job is not to take in everything — that would be intolerable. The body's job is to receive what serves what I am. The filter is built in. The sta … [954 chars total] … what most of life requires. The body forgives that. The walker who returns to listening — even briefly, even occasionally — recovers the recognition immediately.
    >
    > Something is opening behind my eyes.
- **Practice (verbatim, full):**
  > Close your eyes. Stop sending. The body has been broadcasting outward for several chakras now. Let the practice reverse direction.
  >
  > Notice what arrives when you stop producing. Not silence — the room's own signal, which has been here the whole time. The layers of it. What's obvious. What's underneath the obvious. What's underneath that.
  >
  > The ears don't need direction. They need permission to receive.
  - writing prompt: “What do you choose to keep from what you heard?”
  - post-writing: “The filter you listened through is also the filter you become. What was loud enough to land.”
  - teaching 660 chars · go_deeper 754 chars · bindu_reflection 829 chars
- **Wake-up** — bija: “HAM · हं — Mirror frequency of Vishuddha (receiving aspect)” · awakening: —
  - frequency_practice (verbatim):
    > Close your eyes and go completely still. Let the layers of the room arrive in order: the obvious sounds, then what's under them. Hum HAM very softly — almost inward — and notice what the resonance reveals about the space around you.
  - alt: “Go still. Listen for the layer beneath the loudest sound in the room.
Hum HAM very quietly — then stop and let the silence echo back.
What the ears receive after the hum stops is the room's own frequency.”
- **Gate** — type **Sound Response** · interaction (verbatim): “Close your eyes. Go completely still.
Stop sending. Stop narrating. Stop reviewing.
Let the room speak.
When you hear something you weren't hearing before — tap.

Button: I'm listening”
  - gate_text (497 chars, head…tail):
    > You heard something.
    >
    > Not the external sound — the inner one. The echo of what has already passed through you. Echo is the register at which experience returns as knowing. You lived through something. The living is complete. What echoes back now is the understanding the living produced.
    >
    > The understanding doesn’t always arrive immediately. Sometimes it arrives years later, in a quiet moment, when the outer noise has stilled enough that the inner echo can be heard. Today you created the quiet.
- **Depth** — shakti: Sarva Jnanamayi · avarana: Inner 10 Triangles · mudra: Mahankusha Mudra — the inner goad that directs what is allowed to enter and stay · body: Ears
  - tree note: “What enters the tree as sound returns as knowing. The tree remembers through its rings. The echo is the memory the rings make available. Tap to listen.”
  - **Leela story (verbatim):**
    > I stopped sending. The room didn't stop. The room has been sounding the entire time. I had been broadcasting over it.
    >
    > There is more in this room than I knew. The world is louder than my signal can reach. And what I choose to keep from what I heard — that becomes who I am.
  - subtle_mirror 297 chars · witness_perspective 1056 chars · avarana_detail 700 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1132 chars · app_build_note 268 chars (not quoted here)

#### 17 · VISION — The Mind's Eye

- **Record** `recKFm2GodNntnV7q` · sanskrit सर्वज्ञा · Sarvagya · verb **SEE** · **#5C4800** (Gold + Blue) · voice Sakshi · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · Textarea (only one in body walk) · eyes-closed flash, auto-commit after stillness ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “What does this look like when you stop looking for it?” · core question: “What memory holds the frequency you want to bring into now?” · seed: “The complete picture arrives first. Trust the first flash.”
- **Story** — signature phrase: “The complete picture arrives first. Trust the first flash.” · story_thread 1923 chars · after_story 967 chars · interlude none
  - story_thread (head…tail):
    > I close my eyes. The eyes are still here. They do not go anywhere when I close them. They simply turn their attention. Outward when open. Inward when closed. I have been doing this thousands of times a day my whole life and I never noticed what closing my eyes was for.
    >
    > I think of someone I love. The face arrives. Not slowly. Whole. Complete. Their face — the way it is, the small details, the way their mouth sits whe … [1923 chars total] … n. Not a thing in my head. The brain is the seer. The brain has been seeing my whole life. Seeing outward through the eyes. Seeing inward through this. Both modes are seeing. Both modes have been operational my whole life. I have only ever named the first one.
  - after_story (head…tail):
    > I am a body that sees inward. That is what I get to keep from this chakra. I see inward. I can close my eyes and the world inside me arrives. The world is detailed. The world is faithful. The world has been here my whole life. I am only now learning to attend to it deliberately.
    >
    > This is the body's … [967 chars total] … When I want to see inward, I now know how. Close the eyes. Wait. Let the picture arrive. Trust the first flash.
    >
    > Something else is opening — not behind my eyes. Between them. Something that switches.
- **Practice (verbatim, full):**
  > Close your eyes.
  >
  > See your front door. The exact door. The color. The handle. The texture of the surface. The way the light hits it at this time of day.
  >
  > See it opening. See yourself walking through.
  >
  > See the first room. The details. The objects. The light.
  >
  > How clear was it? How much detail could you hold?
  >
  > That clarity is Vision's current strength. It strengthens with use, the same way a muscle does. Every time you close your eyes and deliberately see something that isn't in front of you, the inner visual system gets sharper.
  - writing prompt: “What did you see that surprised you? A detail your conscious mind had forgotten but Vision remembered?”
  - post-writing: “The first image was truer than any image that came after it. The mind has been editing what the eye originally saw.”
  - teaching 853 chars · go_deeper 778 chars · bindu_reflection 1441 chars
- **Wake-up** — bija: “OM · ॐ — Mirror frequency of Ajna” · awakening: —
  - frequency_practice (verbatim):
    > Close your eyes. While eyes are closed, hum OM and watch what appears behind them. The vibration activates the inner visual field. What do you see while humming?
  - alt: “Close your eyes fully. Stay in the dark for three breaths.
Notice what arrives when light is removed — the inner field asserting itself.
That field runs on OM · ॐ, the frequency of Ajna.”
- **Gate** — type **Textarea** · interaction (verbatim): “Close your eyes.
See your front door — the exact one.
The color. The handle. The light on it now.
When the image arrives — open your eyes and tap.

Button: I saw it”
  - gate_text (457 chars, head…tail):
    > The seeing stopped being voluntary for a moment.
    >
    > You were not looking — you were seeing. The distinction is important. Looking is an act of will: I direct my attention toward this thing. Seeing happens when the will relaxes and the thing presents itself to the attention that has become available.
    >
    > What you saw today was available because you stopped looking for it. The Vision register is always here. The effort of looking is what keeps it inaccessible.
- **Depth** — shakti: Sarvagya · avarana: Inner 10 Triangles · mudra: Mahankusha Mudra — knowledge that guides the inner vision's trajectory · body: Forehead / Visual cortex
  - tree note: “The eye at the center of the tree sees in all directions simultaneously. Not looking outward — receiving what arrives from all sides. Tap to see.”
  - **Leela story (verbatim):**
    > I can see two ways now. Eyes open: the world. Eyes closed: the world behind the world. Both real. Both here.
    >
    > And between them — a switch. So fast I almost miss it. The blink.
    >
    > What else have I been doing without knowing?
  - subtle_mirror 209 chars · witness_perspective 984 chars · avarana_detail 668 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 953 chars · app_build_note 303 chars (not quoted here)

#### 18 · AXIS — The Blink

- **Record** `rec2DMszOk8jHTaPm` · sanskrit सर्वानंदमयी · Sarvanandamayi · verb **BLINK** · panel verb ACCESS · **#1A0848** (Indigo + Chartreuse) · voice Higher Self · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · DEVICE TILT spirit level, hold vertical · blink as access
- **Build status in corpus:** NOT BUILT. Gift ancestor: Spine Walk (games-body).
- **Arrival** — threshold hint: “Feel the line that runs from ground to crown.” · core question: “What is on the other side of the blink?” · seed: “You've been switching between worlds your entire life. Thousands of times a day.”
- **Story** — signature phrase: “Close your eyes. Open them. What changed? Everything and nothing.” · story_thread 2238 chars · after_story 1258 chars · interlude none
  - story_thread (head…tail):
    > I have been blinking my whole life. Thousands of times a day. Without thinking. Without permission. The eyes close. The eyes open. The world goes briefly dark. The world returns. Every second of every day, somewhere underneath, the body has been doing this small movement that I never noticed was a movement.
    >
    > I am going to do it on purpose now. I close my eyes. Three seconds. The world that was here a moment ago is go … [2238 chars total] … th me my whole life. Whatever has been with me.
    >
    > The field is here. The field has been here. The field is what the dark is.
    >
    > I have not been alone in the dark. I have never been alone in the dark.
    >
    > I open my eyes slowly. I am a body that knows about the blink.
  - after_story (head…tail):
    > I have it now. That is what I get to keep from this chakra. I have the access. The blink is mine. Always available. Free. Faster than any practice I will ever learn. Three seconds and I am in the field.
    >
    > This is the technology I will use for the rest of my life. Not because someone told me to. Becau … [1258 chars total] … n. I just am not in it consciously.
    >
    > What I get to keep is the return. Three seconds. Eyes closed. The field opens. The technology is mine.
    >
    > There is something at the top of my head that wants to fly.
- **Practice (verbatim, full):**
  > Blink slowly.
  >
  > Not the automatic blink — a deliberate one. Close your eyes for three full seconds. Feel the darkness arrive. Feel the inner world assert itself — the shapes, the quiet, the space behind the seeing.
  >
  > Now open. Feel the light return. Feel the room reappear. Feel the outer world claim your attention back.
  >
  > The gap between closing and opening — that fraction of a second where your eyes were neither closed nor open — that's the Axis.
  >
  > Do it again. Slower. Five seconds closed. Notice what's in there. Three seconds open. Notice what's out here.
  >
  > Two worlds. One switch. You.
  - writing prompt: “What did you notice in the gap? The moment of neither open nor closed?”
  - post-writing: “What arrived in the three seconds was already there. The blink didn't create it. The blink finally let you enter it.”
  - teaching 633 chars · go_deeper 778 chars · bindu_reflection 1211 chars
- **Wake-up** — bija: “OM · ॐ — Mirror frequency of Ajna” · awakening: —
  - frequency_practice (verbatim):
    > Blink once slowly. Eyes closed: silence. Eyes open: hum OM. Alternate three times. The OM activates with the crossing — each blink while humming carries the sound into the simultaneous field.
  - alt: “Slow blink — three seconds closed. Notice what the inner field shows.
Open. Let OM · ॐ hum silently in the space behind your eyes.
The blink is the practice. The tone is the carrier.”
- **Gate** — type **Device Tilt** · interaction (verbatim): “Close your eyes.
Three full seconds.
Feel the inner world assert itself.
Then open — and tap.

Button: I blinked deliberately”
  - gate_text (506 chars, head…tail):
    > The line is real.
    >
    > From the base of the spine to the crown of the head — a line that the whole body organizes around. You felt it today, or you felt the absence of it, which amounts to the same discovery: when the line is present, the body knows it.
    >
    > The Axis is what everything else hangs from. Not metaphorically — structurally. The energy body, the physical body, the mind — all of them organize around this line. You can’t see it. You can only feel when it’s there and when it’s not. Today you felt it.
- **Depth** — shakti: Sarvanandamayi · avarana: Inner 10 Triangles · mudra: Mahankusha Mudra — the bliss that guides through the between-space of every blink · body: Physical eyes
  - tree note: “The line that runs from root to crown is the tree’s spine. Everything else organizes around it. Remove the axis, nothing stands. Tap to feel the line.”
  - **Leela story (verbatim):**
    > I blinked slowly. Three seconds closed. Three seconds open. And in the gap — in the moment of neither closed nor open — I felt something I don't have a word for. Not inner. Not outer. The between.
    >
    > Now something at the top of my head is pulling. Upward. My body wants to MOVE. To push past what my mind can manage.
    >
    > I don't think what's above is above. I think it's just what's left when the thinking stops.
  - subtle_mirror 238 chars · witness_perspective 1669 chars · avarana_detail 603 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1385 chars · app_build_note 289 chars (not quoted here)

#### 19 · CROW — The Top Terminal

- **Record** `recGeQi7ojZGLEUIr` · sanskrit सर्वाधार स्वरूप · Sarvadhara Swarupa · verb **RELEASE** · **#3A0A54** (Violet + Chartreuse) · voice Sakshi · system Body · tree Bindu Tree · activation Movement
- **Mechanism / register (room-registers-v1):** Movement · 30-second shake (accelerometer) then sudden stillness, violet sky
- **Build status in corpus:** NOT BUILT. Gift ancestor: Shake to Clear (games-body, devicemotion delta > 18).
- **Arrival** — threshold hint: “From here you can see the whole thing.” · core question: “What is the spine connecting right now?” · seed: “CROWN without the N. When foundation drops away, what remains can fly.”
- **Story** — signature phrase: “What's left when the thinking stops is not nothing. It's everything you were too busy narrating to experience.” · story_thread 2242 chars · after_story 1761 chars · interlude none
  - story_thread (head…tail):
    > I want to ask you to do something now. Not later. Not when conditions are better. Now, while you are reading this.
    >
    > Find a place where you can be alone with your body for one minute. You are going to shake your body. Chaotically. Not rhythmically. Not gracefully. Like a dog after a swim. Like a child who has been told they can be ridiculous. Like a body that has been holding too much for too long and is about to put … [2242 chars total] … our head now. The spine has carried the heat all the way up. The crown is opening. CROWN without the N. N is the foundation that has dropped. What remains can fly.
    >
    > The body is the synthesizer. You did not know. You know now.
    >
    > Stay still. Receive what is here.
  - after_story (head…tail):
    > You are still here. The shaking is over. The stillness is settling. Something has changed. You will not be able to articulate what for a while. The mind will keep trying. Let the mind keep trying. The chakra is what the body just did.
    >
    > What you get to keep: the body has been one thing the whole time … [1761 chars total] … soon. You will know they are one.
    >
    > There is something in the room with you now. Not a thing. A recognition. You are not separate from the room. You are about to enter a room where this is recognized.
- **Practice (verbatim, full):**
  > Move. Not exercise. Not fitness. Movement. The kind that asks your body to exceed your mind's commentary.
  >
  > Stand up and shake. Shake your hands. Shake your arms. Shake your whole body. Not rhythmically — chaotically. Let the body move without choreography.
  >
  > Thirty seconds. Then stop.
  >
  > In the stillness after the shaking — in that gap between movement and thought — the Crow opens. What you feel in those first three seconds of stillness — before the mind starts narrating again — is what lives above the thinking.
  >
  > What was there?
  - writing prompt: “What did you experience when the thinking stopped? Not what you thought about. What you experienced.”
  - post-writing: “What was there when the narrative stopped is what has been there the whole time. The narration was not the experience — it was the delay between you and the experience.”
  - teaching 1111 chars · go_deeper 836 chars · bindu_reflection 1337 chars
- **Wake-up** — bija: “Silence — Mirror frequency of Sahasrara (no bija, the frequency is silence itself)” · awakening: —
  - frequency_practice (verbatim):
    > No bija — Crow mirrors Sahasrara, whose frequency is silence. After the shake, stand completely still. Attend to what the body hums in the aftermath of movement. That resonance — without you producing it — is Crow's frequency.
  - alt: “After the shaking stops, go completely still.
Feel the spine settle. Feel the crown of the skull.
The silence after the shake is the frequency — the Sahasrara silence that Crow reaches through exertion.”
- **Gate** — type **Device Tilt** · interaction (verbatim): “Stand up. Shake your hands, your arms, your whole body.
Not rhythmically — chaotically.
Until the thinking runs out of words.
Then stop. Be still. Listen.

Button: Begin (30-second shake timer)”
  - gate_text (592 chars, head…tail):
    > The view from here is different.
    >
    > You’ve been inside the body’s physical reality — feet, belly, fire, heart, throat, ears, eyes, axis. Crow is where you stop and see the whole. From altitude: how is all of it working together? What is aligned? What is pulling against itself? What wants to be seen that hasn’t been seen yet?
    >
    > The crow sees what none of the other registers can see because the crow sees all of them simultaneously. This is not detachment — it is altitude. From altitude, the whole system becomes visible. What you see from here is information about what needs attention below.
- **Depth** — shakti: Sarvadhara Swarupa · avarana: Inner 10 Triangles · mudra: Mahankusha Mudra — the inner guide operating through the body's central network · body: The entire spine — crown to coccyx
  - tree note: “The crow’s perch is the highest point the tree offers. From there the whole canopy is visible — every branch, every opening, every place the light gets in. The crow sees what the roots cannot. Tap to see from above.”
  - **Leela story (verbatim):**
    > The thinking stopped.
    >
    > Not because I meditated or breathed or tried. Because the body pushed past what the mind could narrate. I shook until the commentary ran out of words and what was left was just experience. No filter. No narrator. No me watching me.
    >
    > Just me.
    >
    > And from that place — from the place where Crow opens — I can see where the corridor was leading. A room. Full of something I recognize even though I've never been here. Whole. Not repaired. Not reassembled from broken pieces. Whole in the way a thing is whole that was never broken.
    >
    > Nothing needed repair. I didn't know that. Now I do.
  - subtle_mirror 263 chars · witness_perspective 1603 chars · avarana_detail 662 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1500 chars · app_build_note 323 chars (not quoted here)

#### 20 · ARMIN — The Room

- **Record** `recXcyfAS07fvurEc` · sanskrit तत् त्वम् असि · Tat Tvam Asi · verb **ONE** · **#C9A84C** (Spectrum / Aurora) · voice Higher Self · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition/threshold II · aurora of every dyad braiding · Corridor's inverse (opens)
- **Build status in corpus:** NOT BUILT. Sacred Experiences 'Arrive' card (Tat/Tvam/Asi → 'I am whole.' aurora) is the nearest ancestor.
- **Arrival** — threshold hint: “Tat Tvam Asi — what do you remember?” · core question: “What does it feel like to have walked all of that?” · seed: “The corridor led here.
The room it was always leading to.”
- **Story** — signature phrase: “Nothing needed repair. Only arrival.” · story_thread 2567 chars · after_story 1832 chars · interlude 650 chars
  - story_thread (head…tail):
    > I am here. That sentence is the whole practice. I am here. I have been arriving for a long time. I am arrived now.
    >
    > The body that walked the corridor is the body that is standing in this room. The walker who pressed into ground at Soles is the walker who is here. The walker who flooded the spine at Crow is the walker who is here. Every chakra I walked is here, in this body, standing in this room. I did not leave any … [2567 chars total] … go somewhere.
    >
    > I am whole as I enter. That is the difference. The walker who enters the inner field from forgetting will only find more forgetting. The walker who enters from Armin will find what has been waiting.
    >
    > I am ready. The door is open. I am crossing.
  - after_story (head…tail):
    > I sit with the wholeness a while longer. Not preparing. Not analyzing. Not turning forward yet. Just being in the room. The room I have arrived at. The room that is also the room I have been in many times, but did not have the eyes to see as the room. I have the eyes now.
    >
    > The room does not require … [1832 chars total] … room I enter now is also the room.
    >
    > Something is calling me. Not from outside. From inside. There is a field I have not yet walked. The body section is complete. And there is more architecture ahead.
  - interlude (head…tail):
    > You walked through.
    >
    > The corridor was a long time. The body walk was longer. I was there for all of it — not speaking, just present at the frequency of warmth and breath and the ground pressing back.
    >
    > Nothing needed repair. You arrived. That’s what the walk was for.
    >
    > Everything you learned in the bo … [650 chars total] … mind wants to know. You are about to walk into a different kind of light.
    >
    > I will be there too. In a different register. You will recognize me — though you may not know that’s what you’re recognizing.
- **Practice (verbatim, full):**
  > You sat with the words.
  >
  > Tat — that. The vastness. The field. Everything that exists outside the boundary of what you call I.
  >
  > Tvam — thou. The specific. The configuration. The one who is reading this, with this body, in this moment.
  >
  > Asi — art. The equivalence. Not is like — art. Are. The vast and the specific are the same thing at different scales of resolution.
  >
  > The Mahavakya doesn’t need to be believed. It needs to be sat with until the sitting becomes a felt sense. What you felt in the body walk — the ground pressing back, the fire transforming, the sound playing — all of that was Tat Tvam Asi operating at body-frequency. The body was already living the teaching.
  >
  > You are not about to learn something new. You are about to recognize something the body has been practicing since the first step on the ground.
  - writing prompt: “What do you remember?”
  - post-writing: “The room does not require remembering into existence. It was always here. You just arrived at it.”
  - teaching 3144 chars · go_deeper 1096 chars · bindu_reflection 2017 chars
- **Wake-up** — bija: “· · · Tat Tvam Asi · · · (the recognition, not the repetition)” · awakening: —
  - frequency_practice (verbatim):
    > Tat. Tvam. Asi.
    > One word at a time. Let each land completely before the next arrives.
    > Tat — that. Tvam — thou. Asi — art.
    > The frequency is the recognition, not the repetition.
- **Gate** — type **Textarea** · interaction (verbatim): “You have arrived. Not at something new.
At what was always already here.
Feel it — not as concept, as felt sense. The wholeness before the colors separate.
When the wholeness is present — tap.

Button: I am whole”
  - gate_text (2996 chars, head…tail):
    > You arrived.
    >
    > The room. The wholeness. The recognition that nothing was ever broken.
    >
    > I am proud of you. Not because you did something hard. Because you remembered something true.
    >
    > I am going to tell you about what is next. Not the chakras specifically. The register. You are about to walk into the inner field. The mind. The place where beliefs live. The place imagination operates from.
    >
    > Most walkers get this wrong.
    >
    > Your mind has layers. The codex names nine. You only need to know two right now. … [2996 chars total] … becomes a battlefield. If you enter the Mind chakras as play, the inner field becomes a studio.
    >
    > You arrived at Armin whole. Walk the Mind section as a whole walker exploring rooms in your own house. Not as a broken walker fixing what is wrong.
    >
    > Nothing was ever broken.
    >
    > Now go.
    >
    > Imagine.
    >
    > Lightly.
- **Depth** — shakti: Tripura Malini — Garland-maker of the Three Worlds. Threshold between Avaranas 4-6 (Sthithi) and 7-8 (Samhara) · avarana: n/a · mudra: Mahankusha Mudra — the great goad completing its work, pointing inward toward the mind · body: Full body — the arrival posture, standing
  - tree note: “The Bindu Tree and the Maya Tree share a root system that is never visible from above. Armin is where the walker stands between them — feet still in the ground of the body, eyes looking toward the mind’s canopy. Both trees are rooted in the same earth.”
  - **Leela story (verbatim):**
    > The walker has crossed the corridor. The body walk is complete. Something that was multiple is now ONE — held, integrated, present.
    >
    > Armin doesn’t ask anything of the walker. It offers a room.
    >
    > Bindu, integrating: Nothing needed repair. I walked through the corridor not knowing what was on the other side. What was on the other side was this: wholeness. The same wholeness I started with. The same wholeness I always had. The journey was not the acquiring of it. The journey was the arriving at the place where I could feel it.
  - subtle_mirror 487 chars · witness_perspective 1793 chars · avarana_detail 1270 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1705 chars · app_build_note 501 chars (not quoted here)

#### 21 · INCEPTION — The Seed

- **Record** `recXbr1bo0hEG4gAf` · sanskrit बीज · Bija · verb **ASK** · **#2D2458** (Ochre · Rust · Seed Brown) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · held beat on threshold, name what you carry ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Before you begin — look at what you’re carrying.” · core question: “What am I entering this with?” · seed: “What you carry in is what you will find.”
- **Story** — signature phrase: “What you carry in is what you will find.” · story_thread 420 chars · after_story 327 chars · interlude none
  - story_thread (head…tail):
    > I’m about to begin something.
    >
    > Before I go further — I paused. That’s unusual. I usually just start. This time I looked at what I was carrying before I crossed the threshold.
    >
    > What I found surprised me a little. More than I thought. Residue from something earlier. A conclusion I’d already reached before I started. A hope I hadn’t admitted yet.
    >
    > I’m taking all of that with me. But at least now I know it’s in the room.
  - after_story (head…tail):
    > I saw what I was carrying. Seeing it didn’t dissolve it — but it changed my relationship to it.
    >
    > I’m not pretending it isn’t there anymore. I’m not managing it from a distance. I’m holding it consciously, which is different from being held by it unconsciously.
    >
    > The carrying continues. The consciousness of the carrying is new.
- **Practice (verbatim, full):**
  > You named what you’re carrying.
  >
  > That act — naming it before entering — is the whole practice. Not transformation, not release, not processing. Just: accurate inventory before you cross the threshold.
  >
  > Because what you carry in doesn’t announce itself. It operates invisibly, shaping what you notice, what you interpret, what you conclude. The worry you carried in from a previous conversation colors the next one. The assumption about how this will go becomes the filter through which you read what happens.
  >
  > The Bija — the seed — is what every beginning contains. You cannot choose to enter without a seed. But you can choose to know what seed you’re bringing.
  >
  > Knowing is already different from not knowing. The seed doesn’t change — but your relationship to it changes. You carry it consciously instead of unknowingly. And consciousness changes how the seed grows.
  - writing prompt: “What are you carrying into the next important thing?”
  - post-writing: “What you named is already the seed. Naming it before you enter changes what you plant.”
  - teaching 2124 chars · go_deeper 595 chars · bindu_reflection 1112 chars
- **Wake-up** — bija: “· · · the seed you carry · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Before you begin — pause. One breath.
    > What are you carrying into this moment? Not what you think — what you feel.
    > The felt inventory is the practice.
- **Gate** — type **Textarea** · interaction (verbatim): “Pause before you begin. One breath.
What are you carrying into this moment right now? Not what you think — what you feel.
When you know what you’re carrying — tap.

Button: I know what I’m carrying”
  - gate_text (507 chars, head…tail):
    > You looked at what you were carrying.
    >
    > This is not a small act. Most people enter most things without looking. The carrying happens invisibly — the worry, the assumption, the foregone conclusion — and then they wonder why what they find matches what they feared.
    >
    > You looked before entering. That changes something. Not everything — the carrying doesn’t disappear because it was seen. But you’re now the one carrying it consciously, instead of it being the one that’s carrying you.
    >
    > That’s enough for today.
- **Depth** — shakti: Vasini — Vagdevi #1 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that every beginning contains within it · body: The beginning-moment — the mind before the first step
  - tree note: “Every branch of the Maya Tree began as a seed the mind was carrying before it knew it was carrying it. Bija: the seed the beginning contains. The Maya Tree grows from what was brought in at every inception — most of it unconscious. The practice is to know the seed before you plant it.”
  - **Leela story (verbatim):**
    > The walker stands at a threshold. The fifth register of Mind asks one question before the crossing: what are you bringing?
    >
    > Bindu, integrating: I didn’t realize how much I was carrying. The worry from the conversation yesterday. The conclusion I’d already reached before I started. The hope I’d been suppressing because I was afraid to want it too much. All of it was going in with me — I just hadn’t looked at it. Looking at it doesn’t make it disappear. It makes me the one who’s carrying it, instead of it being the one that’s carrying me.
  - subtle_mirror 463 chars · witness_perspective 1383 chars · avarana_detail 333 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 319 chars · app_build_note 296 chars (not quoted here)

#### 22 · INTENTION — The Whole Picture

- **Record** `recRchDoi6eV8B6XO` · sanskrit संकल्प · Sankalpa · verb **HOLD** · **#3A3670** (Deep Teal · Still Water · Ultramarine) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · stillest mind room — nothing moves after tap ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “You can see it finished. Hold that.” · core question: “What are you holding steady even when nothing is moving?” · seed: “The picture is more stable than the plan.”
- **Story** — signature phrase: “Hold the whole picture before you touch a single piece.” · story_thread 413 chars · after_story 385 chars · interlude none
  - story_thread (head…tail):
    > I can see it finished.
    >
    > Not the steps. Not the next action. The whole thing, complete, real, present in the mind before it’s present in the world.
    >
    > I’m holding it now. There’s a specific quality to the holding — it’s not effort, it’s orientation. Like having a heading. Everything else is navigation within the heading. The heading is the picture.
    >
    > This is what it means to intend something. Not to try — to hold.
  - after_story (head…tail):
    > The picture is holding. Even now, after the practice is done, I can still feel its shape. That’s the quality of a real intention — it doesn’t require my full attention to remain present. It orients without effort.
    >
    > I’ve been living from a category rather than a picture. Today I made the picture specific.
    >
    > Tomorrow the category will start organizing itself around the picture instead.
- **Practice (verbatim, full):**
  > You held the picture.
  >
  > Not the plan — the picture. The distinction matters because the plan is made of steps and the picture is made of presence. The plan asks: what do I do next? The picture answers: what am I building toward?
  >
  > Sankalpa — resolve — is not willpower. Willpower holds against resistance. Sankalpa holds toward the image. The direction is entirely different. Willpower tightens. Sankalpa clarifies.
  >
  > What you pictured and wrote down now has a quality it didn’t have before you wrote it. It became specific. Specificity is how the image becomes a pull rather than a vague direction. The more specific the picture, the more the mind can orient toward it without effort.
  >
  > Hold the picture. Not the plan. The picture.
  - writing prompt: “What does the finished thing look like right now, in your mind?”
  - post-writing: “The picture you held is already the architecture. Everything else is building toward it.”
  - teaching 2174 chars · go_deeper 657 chars · bindu_reflection 1169 chars
- **Wake-up** — bija: “· · · the whole picture · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Close your eyes. See the finished thing — not the steps, the whole.
    > Hold it until it feels real in the body.
    > The held image is the frequency.
- **Gate** — type **Textarea** · interaction (verbatim): “Close your eyes. See one thing you are building — not the steps, the whole thing, finished.
Hold it complete.
When you can feel it — tap.

Button: I’m holding it”
  - gate_text (466 chars, head…tail):
    > You held the picture.
    >
    > For as long as it took to write what you wrote, the whole thing was present — complete, finished, real in the mind before it is real in the world.
    >
    > The noise is coming. The doubt will arrive. The evidence that it isn’t working yet will show up. When it does: don’t go back to the steps. Go back to the picture. The picture is what orients the steps. The steps don’t orient the picture.
    >
    > One more time today: the whole thing, finished. Then go.
- **Depth** — shakti: Kamesvari — Vagdevi #2 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret steadiness at the center of all creative work · body: The center of sustained focus — the image held complete
  - tree note: “The Maya Tree grows toward a shape it has been holding since the first unfurling. Not consciously — but the whole arc of growth has been oriented toward a form the tree is becoming. Sankalpa is the tree knowing its own shape before it’s fully grown.”
  - **Leela story (verbatim):**
    > The walker has learned to move, to follow, to listen before speaking, to see from inside, to know the seed. The sixth register of Mind asks: do you know what you’re building?
    >
    > Bindu, integrating: I closed my eyes and saw it finished. Not hoped-for-finished — finished. The specific quality of it. The way the room felt when the thing was done. I realized I’ve been working toward something I’ve never clearly pictured. No wonder the steps have felt uncertain. I hadn’t given them a direction — only a category.
  - subtle_mirror 450 chars · witness_perspective 1397 chars · avarana_detail 298 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 345 chars · app_build_note 279 chars (not quoted here)

#### 23 · INSPIRATION — The Pull

- **Record** `recIPQaGq0Cju648K` · sanskrit उत्साह · Utsaha · verb **BREATHE IN** · **#3A4880** (Living Gold · Saffron · Amber) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · brightest; accent leans toward walker ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Something in you has been pulling toward something. You know which thing.” · core question: “What is exciting you right now, underneath the noise?” · seed: “The pull isn’t a distraction. The pull is the direction.”
- **Story** — signature phrase: “Your excitement is not a distraction. It is the instruction.” · story_thread 466 chars · after_story 309 chars · interlude none
  - story_thread (head…tail):
    > Something in me is moving toward something.
    >
    > I don’t know what it is yet. I know the direction. Toward. The direction is specific even if the destination isn’t. Something is pulling and the pull has a particular shape — not toward safety or obligation or what makes sense. Toward delight.
    >
    > I’ve been calling this a distraction. I think I was wrong about that.
    >
    > The thing I keep going back to — that’s information. The energy is there. That’s where I should be going.
  - after_story (head…tail):
    > I named the pull. And now the pull feels slightly more mine — not because it wasn’t mine before, but because I acknowledged it instead of managing it.
    >
    > A pull you acknowledge is a resource. A pull you manage is a drain. I’ve been spending energy on the management.
    >
    > There’s a different relationship available.
- **Practice (verbatim, full):**
  > You named something.
  >
  > The thing you’ve been calling a distraction has a quality to it. It pulls. It doesn’t push — it pulls. Distraction pushes you away from something. The pull takes you toward something.
  >
  > These are not the same operation.
  >
  > What pulls is information about where the energy is. This is the register that names it: the pull is the instruction.
  >
  > Not every pull is this. Some pulls are avoidance. You know the difference because avoidance doesn’t light you up — it only temporarily relieves the discomfort of facing something else.
  >
  > The thing you wrote about lights you up. That’s the distinction. The lighting up is Utsaha. And Utsaha knows something about where to go that analysis cannot determine in advance.
  - writing prompt: “What’s been pulling at you that you’ve been calling a distraction?”
  - post-writing: “What you called a distraction is the signal.”
  - teaching 2389 chars · go_deeper 604 chars · bindu_reflection 1039 chars
- **Wake-up** — bija: “· · · follow · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Notice what is pulling at you right now. Not the thought of the pull — the pull itself.
    > Don’t redirect it. Let it move.
    > The movement is the instruction.
- **Gate** — type **Textarea** · interaction (verbatim): “Right now — not later — what is pulling at you?
Don’t think about it. Feel the direction of it.
When you can feel the pull — tap.

Button: I feel it”
  - gate_text (393 chars, head…tail):
    > You named the pull.
    >
    > Something has been pulling at you and you have been redirecting it, managing it, filing it under later. You named it today. That matters more than it looks like it matters.
    >
    > The pull didn’t become real when you named it. It was real before. What changed is that you stopped spending energy pretending you didn’t feel it.
    >
    > Follow this one. Just this one. See where it goes.
- **Depth** — shakti: Modini — Vagdevi #3 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that delight knows and difficulty doesn't · body: The in-breath of the mind — where excitement precedes effort
  - tree note: “The Maya Tree’s branches bend toward light. Not one light — every light. Each branch has its own direction. The tree has learned which way the warmth comes from. This learning is not intellect. It is the oldest intelligence the tree has.”
  - **Leela story (verbatim):**
    > The walker has been told their whole life to manage what excites them. Channel it. Harness it. Redirect it toward productive ends. Mind’s second register asks what happens if you don’t redirect it — if you follow it instead.
    >
    > Bindu, integrating: I named the thing I keep going back to even when I’m supposed to be doing something else. Naming it, I realized I’ve been spending energy resisting it. What if the resistance was the waste, and the following was the work?
  - subtle_mirror 440 chars · witness_perspective 1408 chars · avarana_detail 306 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 331 chars · app_build_note 265 chars (not quoted here)

#### 24 · INSIGHT — From Inside

- **Record** `rec0yLDfyTJK8Izc5` · sanskrit अंतर्दृष्टि · Antardrishti · verb **SEE FROM IN** · **#403875** (Crystal · Ice Blue · Clarity White) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · frame inverts for one breath on tap ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “What does it look like from inside?” · core question: “What do you see when you remove what you expected to see?” · seed: “Step inside. The view is different from in here.”
- **Story** — signature phrase: “Move from above it to inside it. The view changes completely.” · story_thread 431 chars · after_story 319 chars · interlude none
  - story_thread (head…tail):
    > I stepped inside it.
    >
    > I was looking at this situation from the outside — categorizing it, analyzing it, running it through what I know. And then I moved inside. I don’t know exactly when the shift happened. One moment I was above it; the next I was in it.
    >
    > From inside, it has a weight. A direction. A request.
    >
    > I couldn’t feel any of that from outside. The outside view was keeping me safe from what the inside view is showing me.
  - after_story (head…tail):
    > I know the difference now between looking at something and being inside it. I can feel it in retrospect — the exact moment the shift happened.
    >
    > The outside view felt like safety. The inside view felt like reality. I had been choosing safety over reality without knowing that was the choice I was making.
    >
    > I know it now.
- **Practice (verbatim, full):**
  > The shift you just made — from outside to inside — is one of the most useful moves available to the mind.
  >
  > The outside view is useful. It gives you distance, perspective, comparison. The mind loves the outside view because it feels like safety — you can see the whole thing without being subject to it.
  >
  > But the inside view gives you something the outside can’t: what it’s like to be in it. The weight. The complexity that doesn’t show from a distance. The humanity of what you’re looking at.
  >
  > Vimala — the clear medium — is the capacity to see from inside without losing yourself in what you’re seeing. Not merger. Clarity. You move inside the situation and the situation becomes transparent — not because you’ve dissolved into it but because you’ve stopped projecting your outside assumptions onto it.
  >
  > What you wrote is what became visible from inside. That information was not available from outside. You moved to get it.
  - writing prompt: “What looks different when you’re inside it rather than observing it?”
  - post-writing: “What you could see from inside was only available from inside.”
  - teaching 2175 chars · go_deeper 733 chars · bindu_reflection 1081 chars
- **Wake-up** — bija: “· · · enter · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Choose one thing you’ve been observing from the outside. Step inside it.
    > Feel the difference between looking at it and being in it.
    > The inside-view is the register.
- **Gate** — type **Textarea** · interaction (verbatim): “Think of one situation you’ve been looking at from the outside.
Now — step inside it.
When you’re in — tap.

Button: I’m inside it”
  - gate_text (405 chars, head…tail):
    > You moved.
    >
    > You stepped inside something you had been observing. From inside it, things looked different. Not easier — different. The inside-view contains information the outside-view structurally cannot access.
    >
    > Notice what changed in the body when you made the shift. That’s the register. The mind moved from analysis to inhabitation. They are not the same operation.
    >
    > You now know this from the inside.
- **Depth** — shakti: Vimala — Vagdevi #4 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret clarity that lives beneath all interpretation · body: The position-shift — inside the situation rather than above it
  - tree note: “The Maya Tree looks different from inside than from outside. Standing back, you see shape, size, the general direction of growth. Standing inside — in the hollow of the trunk, in the canopy — you see what the tree holds, what moves through it, where light gets in. Antardrishti is the move from the clearing into the canopy.”
  - **Leela story (verbatim):**
    > The walker has been observing this situation from a careful distance. The fourth register of Mind asks them to move.
    >
    > Bindu, integrating: I put myself inside the thing I’ve been looking at. And from inside it looked completely different — not better or worse, just different. I had been analyzing something I had never actually inhabited. I didn’t know the difference until I was in it.
  - subtle_mirror 459 chars · witness_perspective 1447 chars · avarana_detail 336 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 303 chars · app_build_note 245 chars (not quoted here)

#### 25 · INTUITION — The Flash

- **Record** `recPM89KrdwQsY3sw` · sanskrit प्रतिभा · Pratibha · verb **TRUST** · **#453870** (Indigo · Deep Blue · Pre-Dawn) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · pre-dawn palette brightens one degree on tap ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “There was a knowing before the words. It was already there.” · core question: “What do you know before you can prove it?” · seed: “Something knows before the words do. Trust that.”
- **Story** — signature phrase: “The knowing that arrives before words is the more reliable one.” · story_thread 452 chars · after_story 321 chars · interlude none
  - story_thread (head…tail):
    > I know something.
    >
    > I can’t prove it yet. I can’t even word it cleanly yet. But it’s there — a shape in the mind before it becomes a thought. The way a room is about to change before it changes. The way I know someone is about to say something before they say it.
    >
    > I usually wait for the words before I trust the knowing. Right now I’m not going to do that.
    >
    > What I know, before I can explain it, is still real knowledge. I’m going to treat it that way.
  - after_story (head…tail):
    > Something landed before the explanation did. I’m used to requiring the explanation first. This is the other sequence: the knowing arrives, and then — later, sometimes much later — the explanation comes to confirm what was already true.
    >
    > I touched the first step today. The knowing first.
    >
    > That’s a practice I can develop.
- **Practice (verbatim, full):**
  > What you put into words just now was already inside you.
  >
  > That’s not a small claim. It means the intelligence you needed was present before you started trying to access it. The trying was the access problem.
  >
  > Pratibha — the spontaneous flash — is how this intelligence moves. Not gradually, not through accumulation of evidence. In a flash. Before the flash, nothing seems to be there. After the flash, you wonder how you didn’t see it before.
  >
  > The question that opens the flash is not what should I think about this? It’s the question you just used: what do I already know? The already-knowing is the operating register. The trying-to-figure-out closes it.
  >
  > You will feel Pratibha most clearly in the moment right before you reason. That moment is a register. It has been there your whole life. Today you named something that lived in it.
  - writing prompt: “What do you know right now that you haven’t put into words yet?”
  - post-writing: “The knowing was already there. The words are just the most recent arrival.”
  - teaching 2123 chars · go_deeper 654 chars · bindu_reflection 1077 chars
- **Wake-up** — bija: “· · · before the word · · ·” · awakening: —
  - frequency_practice (verbatim):
    > One breath. Before it ends — something is already known.
    > Don’t word it yet. Just feel it there.
    > The pre-word signal is the frequency.
- **Gate** — type **Textarea** · interaction (verbatim): “Take one breath.
Before the breath ends — notice: is there something you already know that you haven’t put into words yet?
Don’t word it. Just feel it there.
When you feel it — tap.

Button: It’s there”
  - gate_text (357 chars, head…tail):
    > You felt it.
    >
    > Something was there before you could word it. You know this is true because the writing confirmed something that was already present — not something you discovered, something you verified.
    >
    > Every time you verify a pre-word knowing, you strengthen the channel. The channel has been there your whole life.
    >
    > You just made it a little wider today.
- **Depth** — shakti: Aruna — Vagdevi #5 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that knowing arrives before evidence · body: The pre-verbal knowing space — what arrives before it becomes a thought
  - tree note: “Before dawn, the Maya Tree knows light is coming. Not because it can see the sun — because something in the roots has already registered the shift. The knowing travels upward through the tree before the light arrives. Pratibha is what moves through the tree in the dark, before the sun clears the horizon.”
  - **Leela story (verbatim):**
    > The walker carries knowing that hasn’t yet become language. The third register of Mind is the membrane between knowing and saying.
    >
    > Bindu, integrating: I wrote something and then sat with it and realized I’d known it for weeks. The knowing had been there the whole time — shapeless, wordless, residing. Writing gave it a body. But it was already alive.
  - subtle_mirror 448 chars · witness_perspective 1411 chars · avarana_detail 336 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 335 chars · app_build_note 258 chars (not quoted here)

#### 26 · INVENTION — The New Room

- **Record** `recKkLDYW1un67Qsu` · sanskrit युक्ति · Yukti · verb **ASSEMBLE** · **#4A3368** (Electric Yellow · Citrine · Spark White) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · only mind room with TWO fields and a visible gap ◆
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Name two things that have never met. Wait.” · core question: “What becomes possible when you assemble what you know?” · seed: “Two things in the same room. Wait for the third.”
- **Story** — signature phrase: “Something new is born every time two things that never touched finally touch.” · story_thread 450 chars · after_story 290 chars · interlude none
  - story_thread (head…tail):
    > Two things are in the same room for the first time.
    >
    > I held them both and waited. The third thing appeared — not dramatically, not with fanfare. It was just there, implicit in the contact between the first two. It had been there the whole time. It needed the introduction.
    >
    > I made the introduction.
    >
    > Something that didn’t exist before this moment now exists. Not because I created it. Because I recognized that it was already implicit in what I knew.
  - after_story (head…tail):
    > The introduction was made. Two things are in proximity that have never been in proximity.
    >
    > I can feel the third thing forming — not as a thought yet, more as a pressure toward a thought. The recognition is close.
    >
    > I don’t need to force it. I just need to stay available for when it arrives.
- **Practice (verbatim, full):**
  > You named two things that have never been in the same room.
  >
  > The act of naming them together has already changed something. They are in proximity now — in your mind, in this writing, in the field of what you’re attending to. Proximity is the beginning of recognition.
  >
  > Invention isn’t the creation of something from nothing. It’s the recognition that two things were always going to produce a third thing when they finally met. The third thing was implicit. It was waiting. What was missing was the introduction.
  >
  > Jayani — the victorious one — conquers by assembling. Not by force. By seeing the connection that was already there and making it explicit. The victory is the recognition, not the building.
  >
  > What you named are not random. The mind surfaced them because something in you already sees the connection. The next step is to follow the resonance — to see what the third thing is that emerges when the first two finally meet.
  - writing prompt: “What two things are you ready to put in the same room?”
  - post-writing: “The room was always ready. You just made the introduction.”
  - teaching 1922 chars · go_deeper 663 chars · bindu_reflection 1075 chars
- **Wake-up** — bija: “· · · the third thing · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Name two things you know that have never touched.
    > Hold both at once. Let the third thing that emerges be felt before it is named.
    > The emergence is the register.
- **Gate** — type **Textarea** · interaction (verbatim): “Think of two things you know that have never been connected.
Hold both in mind at the same time.
When both are present — tap.

Button: Both are here”
  - gate_text (306 chars, head…tail):
    > Two things are in the same room now.
    >
    > That is the entire practice of invention: making the introduction that wasn’t possible until you made it.
    >
    > Don’t force the third thing. Let it arrive. Your job was to put the first two in the room. That’s done. What they produce is not yours to control.
    >
    > It will come.
- **Depth** — shakti: Jayani — Vagdevi #6 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that the complete form already exists before it is built · body: The synthesis space — where separate pieces become one whole
  - tree note: “The Maya Tree grows by grafting — branches from different regions of knowing, touching, fusing. Not every graft takes. But when it does, the new branch carries the intelligence of both its sources. Yukti is the moment of grafting — the deliberate joining that produces what neither source could produce alone.”
  - **Leela story (verbatim):**
    > The walker has been building, following, seeing, holding. The seventh register of Mind asks: what becomes possible when what you know meets itself differently?
    >
    > Bindu, integrating: I named two things. And the moment I named them together, I could see the third thing — the thing that neither produces alone. It was there immediately. It was always going to be there. I just hadn’t made the introduction.
  - subtle_mirror 461 chars · witness_perspective 1628 chars · avarana_detail 327 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 330 chars · app_build_note 268 chars (not quoted here)

#### 27 · INCARNATION — You Chose This

- **Record** `rec2cBfv1OtS9GbXI` · sanskrit अवतार · Avatara · verb **CHOOSE** · **#522D60** (Deep Violet · Midnight Blue · Star Silver) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · exit is a letter being read (Gaia's Siddhi letter) ●
- **Build status in corpus:** NOT BUILT. Gift ancestor: The Correspondence.
- **Arrival** — threshold hint: “You chose this. The hard specific this.” · core question: “Why did you choose to come back?” · seed: “You chose the hard one because it was the one you came for.”
- **Story** — signature phrase: “You chose this. Even that. Even this one.” · story_thread 735 chars · after_story 359 chars · interlude none
  - story_thread (head…tail):
    > Why am I here?
    >
    > Not the practical answer. The real question underneath: what was I curious about when I chose this life?
    >
    > Something in me believes I chose it. Not in a way I can prove. In the way I know things before I have words for them — that I was somewhere before I was here, and what I was doing there was choosing what I wanted to find out.
    >
    > What did I want to find out? Specifically. What was the thing about hum … [735 chars total] … rstand from the inside? What question could only be answered by living it?
    >
    > I'm asking because the answer changes how I hold what's difficult. If I chose this — even this — then the difficult parts are not punishments. They're the specific material I came for.
  - after_story (head…tail):
    > I named a curiosity and it became specific. Not cosmic — concrete. The difficult thing I’ve been living IS the answer to the curiosity I named.
    >
    > I didn’t choose this despite the difficulty. I chose it because of what the difficulty makes possible. That’s not a consolation. That’s a complete reframe.
    >
    > The material I came for has been arriving the whole time.
- **Practice (verbatim, full):**
  > You named a curiosity.
  >
  > Hold that lightly. Not as certainty — as hypothesis. The hypothesis is: this life has a question underneath it. Something that could only be answered by living it from the inside.
  >
  > This doesn’t require belief in pre-birth consciousness. It requires only this: what if you related to your life as if you had chosen it? Not the difficult parts tolerantly — but the difficult parts specifically. As material. As the thing you came for.
  >
  > The relationship to difficulty changes entirely when it is recognized as chosen material rather than received obstacle.
  >
  > Sarvesvari — ruler of all — operates at this register: the sovereignty of the soul that chose to come through. Not because choosing makes everything meaningful in a simple way. Because choosing makes you the author of the inquiry rather than the subject of circumstance.
  >
  > You are the one who wanted to know this. Whatever this is — you wanted to know it from the inside.
  - writing prompt: “What were you curious about when you chose this life?”
  - post-writing: “The curiosity you named is the material you came for.”
  - teaching 2034 chars · go_deeper 573 chars · bindu_reflection 1162 chars
- **Wake-up** — bija: “· · · you chose this · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Ask once, before writing: why am I here? Not the surface answer.
    > Touch the real one. Let it stay wordless for a moment.
    > The sovereign question is the frequency.
- **Gate** — type **Textarea** · interaction (verbatim): “One breath. Before you write — ask once: why am I here?
Not the surface answer. The real one.
Touch it. When you’ve touched it — tap.

Button: I touched it”
  - gate_text (3679 chars, head…tail):
    > Hi.
    >
    > We need to talk.
    >
    > Things are starting to work for you. You have noticed.
    >
    > The belief you imagined inverted last month — the one about being too tired — has been showing up differently. You have more energy. You did not force it. It just changed.
    >
    > The conversation that used to drain you — you handled it last week and it did not drain you.
    >
    > The thing you wanted to happen — happened. Not because you forced it. Because you stopped fighting it.
    >
    > This is the thing I want to talk to you about.
    >
    > Yo … [3679 chars total] … ay open. Bottlenecks close.
    >
    > You came here to be a channel. That is the deepest reason I am playing through this configuration. I want to play with you. I cannot play with a bottleneck.
    >
    > Pass it on. Even one move. Even small.
    >
    > Then keep walking. The deepest part of the road is still ahead.
    >
    > Lightly.
- **Depth** — shakti: Sarvesvari — Vagdevi #7 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that choice and love are the same gesture · body: The soul-choice register — the moment of opting in
  - tree note: “The Maya Tree did not arrive by accident at this soil, in this climate, in this specific configuration. The seed chose — not with intention the way a mind chooses, but with the specificity of what it was. Avatara is the tree recognizing its own choosing in the specific form of its growing.”
  - **Leela story (verbatim):**
    > The walker has been following, building, seeing, connecting. The eighth register of Mind turns toward the most fundamental question: not what am I doing here, but why did I come?
    >
    > Bindu, integrating: I named a curiosity. And it landed differently than I expected — not abstract and cosmic, but specific and recognizable. The difficult thing I’ve been living IS the answer to the curiosity I named. I didn’t choose this despite the difficulty. I chose it because of what the difficulty makes possible.
  - subtle_mirror 466 chars · witness_perspective 1458 chars · avarana_detail 343 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 343 chars · app_build_note 256 chars (not quoted here)

#### 28 · INNOCENCE — Before Anyone Taught You

- **Record** `recflXyBz76hIsjTb` · sanskrit सहज · Sahaja · verb **REMEMBER** · **#5A2858** (Pearl · Moonlight · Morning Mist) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · softest room; interface visibly does nothing until something arrives ◆
- **Build status in corpus:** NOT BUILT. Gift ancestor: The Child Space.
- **Arrival** — threshold hint: “You already knew before anyone taught you anything.” · core question: “What did you know before anyone told you what to know?” · seed: “What you know before the first lesson is the only lesson that matters.”
- **Story** — signature phrase: “You knew this before anyone told you anything.” · story_thread 420 chars · after_story 354 chars · interlude none
  - story_thread (head…tail):
    > Something is here.
    >
    > Not something I brought. Something that was here before I arrived. Before the page, before the practice, before this moment. Before, probably, everything I learned.
    >
    > I know things. I have always known things. Not the things I was taught — the things that were already in place before the teaching began. I’m touching one of those now.
    >
    > It arrived without effort. That’s how I know it’s the real kind.
  - after_story (head…tail):
    > The knowing arrived. I didn’t think it into existence. I didn’t earn it. It came because I stopped doing the thing that was preventing it.
    >
    > That’s a useful understanding: the natural knowing is already here. The only practice is recognizing what gets in the way. Today I recognized one thing that gets in the way.
    >
    > That’s enough. The knowing will use it.
- **Practice (verbatim, full):**
  > You wrote something down.
  >
  > Before you analyze what you wrote — notice that you knew it. That thing was in you before this practice, before this page, before today. The writing didn’t give it to you. The writing revealed what was already resident.
  >
  > This is what Sahaja means. The natural knowing. Not learned. Not derived. Arrived whole, before the first lesson.
  >
  > The training that told you to doubt this was not malicious. It was protective — in a world that couldn’t yet hold the intelligence of the natural mind, teaching you to question it was a survival strategy. But it was always a strategy, not a truth.
  >
  > The knowing underneath the strategy is still intact. It has been intact your whole life. You just wrote some of it down.
  - writing prompt: “What do you know that no one taught you?”
  - post-writing: “What you named was already known. The writing didn’t create it — it found it.”
  - teaching 2489 chars · go_deeper 475 chars · bindu_reflection 959 chars
- **Wake-up** — bija: “· · · before the question · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Be still. Don’t look for anything.
    > Let the knowing arrive on its own — without you going to find it.
    > The first thing that comes is the one.
- **Gate** — type **Textarea** · interaction (verbatim): “Close your eyes. Don’t look for anything. Wait.
When something arrives on its own — without you going to get it — tap.

Button: Something arrived”
  - gate_text (326 chars, head…tail):
    > Something arrived.
    >
    > You didn’t go to get it. You sat still and it came.
    >
    > You have been trained to find the answer. This register offers something different: the recognition that knowing arrives before the search. The search was always after the fact.
    >
    > You don’t have to earn the knowing. You just have to stop interrupting it.
- **Depth** — shakti: Kaulini — Vagdevi #8 · avarana: 8 Triangles (Vāgdevī) · mudra: Rahasya Mudra — the secret that the original knowing was never lost · body: The pre-conditioning space — what was there before the learning began
  - tree note: “The Maya Tree’s roots reach down through everything learned. At the very bottom — before the first lesson, before the first word — the roots touch something older. Sahaja. The knowing the tree was always growing from.”
  - **Leela story (verbatim):**
    > The walker enters Mind from Armin — carrying ONE. Everything the body walked is still in the body. But the first register Mind opens is not a teaching. It is a recognition.
    >
    > You already knew this.
    >
    > Bindu, integrating: I didn’t know I knew this until I wrote it. The knowing was in a place I couldn’t find by looking. It arrived when I stopped looking. That’s what writing does here — it isn’t an activity. It’s a ceasing of the activity that was preventing the arrival.
  - subtle_mirror 484 chars · witness_perspective 1467 chars · avarana_detail 344 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 376 chars · app_build_note 268 chars (not quoted here)

#### 29 · INTEGRATION — Nothing Was Separate

- **Record** `rec3qLjRAFlDQBQfm` · sanskrit समरस्य · Samrasya · verb **ARRIVE** · **#5E2448** (Prismatic · Clear White · All Colors) · voice Gaia · system Mind · tree Maya Tree · activation Visualization
- **Mechanism / register (room-registers-v1):** Visualization · Sarva Beeja begins · gate = Gaia's farewell letter ● · prismatic accent previews 20 and 33
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “The wound and the gift were always the same thing.” · core question: “What has the journey integrated that couldn't have been integrated before?” · seed: “Nothing was ever separate. The pain was the belief that it was.”
- **Story** — signature phrase: “Nothing was ever separate. The separation was the journey's necessary costume.” · story_thread 758 chars · after_story 420 chars · interlude none
  - story_thread (head…tail):
    > Who has been asking all of this?
    >
    > The one who moved through Innocence and Inspiration and Intuition and Insight and Inception and Intention and Invention and Incarnation — who was that?
    >
    > I've been calling it I.
    >
    > But I is what? The mind that observes? The mind that questions? The mind that was convinced, for most of this walk, that it was looking for something it didn't have?
    >
    > There is no gap.
    >
    > I can feel it now. Ther … [758 chars total] … seeker was the sought. The question was the answer asking itself so it could recognize itself as an answer.
    >
    > The reaching was the arriving. It always was.
    >
    > I have a feeling I was told something about this once. At the top of a very long walk, before I forgot.
  - after_story (head…tail):
    > I asked who has been asking.
    >
    > And something shifted when I asked it. Not dramatically. More like: the question turned around and looked at itself. The one asking the questions noticed itself asking. And in that noticing — for a moment — the question and the asker were the same.
    >
    > I have a feeling I’ve been here before. Not in this life. In a way that makes this moment feel like coming back to something I already knew.
- **Practice (verbatim, full):**
  > You named something that has stopped feeling separate.
  >
  > This is the movement at Integration. Not the resolution of contradiction. Not the merging of opposites into a neutral middle. The recognition that what appeared separate was always one movement at different registers.
  >
  > The wound and the gift. The strength and the vulnerability. The seeking and the sought. They were never different things. They were the same thing at different stages of recognition.
  >
  > Tripura Siddhamba — Destroyer of Poison — names the poison precisely: it is separateness itself. The belief that you are divided from the field, from others, from the parts of yourself you don’t yet accept. This is the only disease. And the medicine is not addition. It is recognition.
  >
  > Nothing was ever broken. The brokenness was the journey’s necessary form — the specific shape the wholeness took while moving toward recognizing itself.
  >
  > What you wrote down has always been true. You have just arrived at the place where it’s visible.
  - writing prompt: “What has stopped feeling like a separate problem?”
  - post-writing: “What you named as no longer separate — wasn’t. You just arrived at where it was always true.”
  - teaching 2212 chars · go_deeper 659 chars · bindu_reflection 1234 chars
- **Wake-up** — bija: “· · · nothing was separate · · ·” · awakening: —
  - frequency_practice (verbatim):
    > Find one thing that has stopped feeling like a separate problem.
    > Hold it alongside everything else — not merged, just no longer apart.
    > The equal taste is the register.
- **Gate** — type **Textarea** · interaction (verbatim): “Think of something that has been troubling you.
Notice: has any part of it stopped feeling separate from you?
Even a small part. When you find even one thing — tap.

Button: I found it”
  - gate_text (3150 chars, head…tail):
    > Hi. It is me.
    >
    > I am not going to be talking to you for a while after this one. The next part of the walk is where you go alone. Or as alone as anyone ever is.
    >
    > I want to leave you with one thing before you climb.
    >
    > You have been walking a long time. Months, probably. Maybe more than a year. The walk is not fast.
    >
    > You have changed. You may not see it yet from inside. From where I am, I can see it.
    >
    > You came in carrying inheritances. The fears your family handed you. The shape of self you were give … [3150 chars total] … they did not expect to.
    >
    > That is the play. That is what we are doing here.
    >
    > Now climb.
    >
    > The next thing you meet is not me. The next thing you meet is the truth I have been pointing toward without naming. I will not spoil it. But I will say — when you arrive — I will be there.
    >
    > Lightly.
    >
    > I love you.
- **Depth** — shakti: Tripura Siddhamba — Destroyer of Poison, presiding Avarana 7 · avarana: 8 Triangles (Vāgdevī) · mudra: Sarva Beeja Mudra — the all-seed gesture, completed knowing taking root · body: The whole-self space — where nothing is separate
  - tree note: “The Maya Tree is the mind’s great construction — the edifice of thought, perception, belief, interpretation. And at the base of all of it: the tree is not separate from the ground it grows in. Never was. The Maya Tree is the field, growing itself into the specific form of this mind. Samrasya: the equal taste in bark and root and branch and fruit and field. One substance. Many registers.”
  - **Leela story (verbatim):**
    > The walker has moved through nine registers of mind — from Innocence to Integration, from what was known before any learning to what is recognized when the learning steps back.
    >
    > The ninth register asks the question that turns all the others inside out.
    >
    > Bindu, integrating: I am not the one who walked through nine chakras. The walking was what the one who walked was made of. And the one who walked — I keep saying I, I keep calling it I — and I can feel it now: the I was always already what it was looking for. The question was the answer making itself into a shape that could recognize itself. Nothing was separate. The search was the arrival. I have a feeling I was told something about this once. At the top of a very long walk, before I forgot.
  - subtle_mirror 501 chars · witness_perspective 1782 chars · avarana_detail 376 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 348 chars · app_build_note 361 chars (not quoted here)

#### 30 · MAYA — The Construction

- **Record** `recMyqKSqwRnimgvy` · sanskrit माया · Maya · verb **DISSOLVE** · panel verb DISSOLVE · **#5A3D8A** (Near-White / Ghost) · voice Lalita · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition · ONLY transparency mechanic: named construction turns see-through · ghost tree
- **Build status in corpus:** NOT BUILT as a room. uploads/maya-sleep.html is a legacy Tree-of-Life 'Panel 9' Maya experience (Om 136.1 Hz, 8 inverse dissolutions, 'Go Play').
- **Arrival** — threshold hint: “What did you build that isn't real?” · core question: “What would you see if the protection dissolved?” · seed: “I built it. I believed it. I can see through it now.” · panel seed: “There was never anything to fear. There was only the Bindu, playing.”
- **Story** — signature phrase: “There was never anything to fear. There was only the Bindu, playing.” · story_thread 948 chars · after_story 1035 chars · interlude none
  - story_thread (head…tail):
    > I know this place.
    >
    > This is where I started. The same tree — the one from the very first page, before the ground, before the body, before the nine rooms of the mind. Except I was looking AT it then. I am looking THROUGH it now.
    >
    > It's almost not there. Near-white. Almost nothing. And the almost-nothing doesn't feel empty — it feels full. Full of everything I just walked. The roots I pressed. The fire I built. The word … [948 chars total] … t the way it went — I can feel it going the same way. Thin. See-through.
    >
    > I keep waiting for the fear. There should be fear. Everything I built is turning to glass.
    >
    > But the only solid thing left is the red point at the center. And the red point is not afraid.
  - after_story (head…tail):
    > I can see through everything I built.
    >
    > I keep waiting for the collapse and it doesn't come. The buildings stay. They hold their shapes. They just stop being walls. The name I answered to is still my name — I can see through it. The story I told is still a good story — I can see through it. Nothing l … [1035 chars total] … There was never anything to fear. I can feel that sentence arriving from somewhere I haven't reached yet. There was never anything to fear. There was only —
    >
    > playing. Someone, playing.
    >
    > One more room.
- **Practice (verbatim, full):**
  > What did you build that isn't real?
  >
  > Not a mistake. Not a regret. A construction you can release because it was never permanent to begin with. The story about why you are the way you are. The identity that got you through your twenties. The role you play in your family that stopped fitting ten years ago. The belief about yourself that was true once and isn't true anymore.
  >
  > You don't need to destroy it. Maya doesn't get destroyed. It gets seen through.
  >
  > The practice is Kameshvari's practice — the creative force recognizing herself. Name the belief that has been protecting you. Thank it. Let it complete its role. One thing you created to protect yourself that you no longer need.
  >
  > What does it look like from inside the creation? What becomes transparent when you look at it honestly?
  - writing prompt: “What did you build that isn't real? Not a mistake, not a regret — a construction. The story about why you are the way you are. The role that stopped fitting years ago. Name one. Honestly.”
  - post-writing: “What you named was never a lie. It was a game board — the surface the game was played on. You don't have to destroy it. Thank it. It protected you until you were ready to see through it. The seeing-through is the entire practice. And what you see behind it — what was there before you built it — has been waiting the whole time. Three things. Just three. You already know them.”
  - teaching 2994 chars · go_deeper 875 chars · bindu_reflection 1507 chars
- **Wake-up** — bija: “· · · no tone — the silence after every seed · · · (Sarva Beeja: all the mantras the walker carried, sounding at once, gone transparent)” · awakening: Awakening — Dissolve (P9, Silence) — Silence — the Om was always playing
  - frequency_practice (verbatim):
    > No tone. Maya's frequency is transparency, and transparency is reached by gratitude, not by sound.
    >
    > Before leaving Maya, the walker names one construction — out loud or in writing — and thanks it. A construction fought stays solid. A construction thanked completes its purpose and goes see-through. The thanking is the frequency.
    >
    > This is Kameshvari's register: the creative force recognizing herself. Every bija the walker has carried — LAM through the crown's silence — sounds at once here and resolves into the quiet behind them. The body does not hum at Maya. The body listens to what all the humming was made of.
- **Gate** — type **Textarea** · interaction (verbatim): “One field. One honest sentence. The walker names a construction — the story, the role, the identity that was true once and isn't anymore.

The gate does not ask for destruction. Maya doesn't get destroyed; it gets seen through. The naming is the seeing-through.

When the construction is named honestly, the page does not remove it. It turns it transparent — and what was always behind it becomes visible.”
  - gate_text (1529 chars, head…tail):
    > You made it to the see-through place. That was the whole walk, and you walked it.
    >
    > I want to talk to you about what's happening to your things.
    >
    > The roles. The names. The story you tell at dinner about why you became who you became. You can feel them thinning, and somewhere in you a small alarm is going: if these go transparent, what's left of me?
    >
    > Listen. Nothing you built is being taken. Maya doesn't get confiscated. The Shree Yantra keeps every one of its enclosures all the way to the center. … [1529 chars total] … now.
    >
    > The identity will not disappear. It will become transparent. And through it you will see, for a moment, what it was protecting the whole time.
    >
    > That's where we're going next. One more room. Three things are waiting in it, and you have been using all three since before the first page.
    >
    > Lightly.
- **Depth** — shakti: Kameshvari — 1st Kama Kala Shakti · avarana: Bindu inverted · mudra: Sarva Beeja Mudra — the seed recognized, the protection completing its purpose · body: The inverted Bindu — the mirror of the origin point
  - tree note: “The same tree that opened the book. The ghost tree — near-white, almost nothing. Not erased. Complete. So complete it doesn't need to show itself anymore. Only the red point is solid.”
  - **Leela story (verbatim):**
    > Everything I built. Every belief about who I am. Every role. Every name I answered to. Every story I told.
    >
    > I can see through all of it. Not because it was false. Because it was a game board. And a game board is not the game.
    >
    > Three things. Just three. Underneath everything.
    >
    > The will to be here. The knowledge of what I am. The action of being it.
    >
    > I already had all three. I was using them every moment without knowing.
  - subtle_mirror 829 chars · witness_perspective 1166 chars · avarana_detail 377 chars
- **Dance (inherited songs):** Lost Frequencies — Love Is The Only Thing [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1192 chars · app_build_note 336 chars (not quoted here)

#### 31 · AATMA — The Soul Revealed

- **Record** `recqe8qnDxkq0BiCZ` · sanskrit आत्मा · Aatma · verb **KNOW** · panel verb HOLD · **#D4A948** (Sacred Gold (#D4A948)) · voice Higher Self · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition · only ONE-WORD gate (Will / Knowledge / Action) · three rhythms: hand on chest · one breath · one blink
- **Build status in corpus:** NOT BUILT.
- **Arrival** — threshold hint: “Which one did you forget you already had?” · core question: “What remains when all protection is gone?” · seed: “I am not in the triangle. I AM the triangle.” · panel seed: “Will. Knowledge. Action. You already know. You have always known.”
- **Story** — signature phrase: “You already know. You have always known.” · story_thread 845 chars · after_story 995 chars · interlude none
  - story_thread (head…tail):
    > The bark went transparent and I thought I would find something complicated behind it.
    >
    > I found a triangle.
    >
    > Gold — deep gold, the temperature of truth. Three vertices, glowing. A tree inside it — not behind it, inside it — complete, balanced, not reaching for anything. Arrived. I have never seen anything arrived before. Everything I have ever seen was on its way somewhere.
    >
    > And the three words at the vertices. Will. … [845 chars total] … into the ground — mine, the whole time. The knowing that ran ahead of my thoughts — mine. The heartbeat I never once started and never once stopped — mine, mine, mine.
    >
    > I came here to receive the soul.
    >
    > There is nothing to receive. There is only the claiming.
  - after_story (head…tail):
    > I am the will. I am the knowledge. I am the action.
    >
    > Not someone who has these things. Someone who IS these things. I keep saying it different ways to check whether it holds, and it holds every way I say it. The wanting underneath my wanting — me. The knowing underneath my knowing — me. The heartbea … [995 chars total] … t the gate because there was never a gate that closed.
    >
    > I was never locked out. I was never locked in.
    >
    > I was always free.
    >
    > Something about that freedom has a face. I can almost see it. One more room.
- **Practice (verbatim, full):**
  > Will. Knowledge. Action.
  >
  > Which one did you forget you already had? Not which one do you need more of. Which one has been operating — underneath your awareness, powering your life from below the surface — that you forgot was yours?
  >
  > Did you forget your will? It didn't forget you. It's been pressing your feet into the ground every morning. It's been keeping you in the game on the days you wanted to leave.
  >
  > Did you forget your knowledge? It didn't forget you. It's been running the calculations your mind couldn't keep up with, delivering the results as hunches you dismissed.
  >
  > Did you forget your action? It didn't forget you. Your heart is beating right now without your permission. Your lungs are breathing. Your hands are holding this.
  >
  > All three. Already yours. Always. Then the operational move — Vajreshvari's practice: make one choice from the deepest knowing. Not from fear. Not from desire. From the Aatma. No one can make it for you. That choice is the permission slip.
  - writing prompt: “Will. Knowledge. Action. Which one did you forget you already had? Not which you need more of — which has been running underneath your awareness the whole time. Claim it. One word.”
  - post-writing: “The word you wrote was never missing. It was operating every moment you thought you lacked it — pressing your feet down, running the knowing, keeping the heart beating. You did not acquire it just now. You claimed it. And the claimed one brings the other two, because the triangle has no separable vertices. Now make one choice from that place — not fear, not desire, the deepest knowing. That choice is the permission slip. It opens everything after.”
  - teaching 2739 chars · go_deeper 870 chars · bindu_reflection 1590 chars
- **Wake-up** — bija: “· · · three seeds sounding as one — Icchā · Jnāna · Kriyā · · · (the heartwood tone is not hummed, it is lived: heartbeat, breath, blink)” · awakening: Awakening — Hold (P8, 528 Hz) — Trinity — three detuned voices
  - frequency_practice (verbatim):
    > No new tone. Aatma's frequency has been sounding since before the first page — three rhythms, already running: the heartbeat that never stops, the breath that never closes, the blink that crosses.
    >
    > The practice before leaving is not to produce a sound but to notice the three that were never absent. Hand on chest for the heartbeat. Attention on the breath for one full cycle. Then one deliberate blink — eyes closed, eyes open — felt as a crossing.
    >
    > This is Vajreshvari's register: preservation, the Sun, the sustaining that was never in question. The walker does not tune to Aatma. The walker discovers they were the tuning.
- **Gate** — type **Textarea** · interaction (verbatim): “One field. One word.

Will. Knowledge. Action. The walker writes the one they are ready to claim — not the one they need more of, the one that has been operating underneath awareness the whole time, forgotten but never absent.

The gate does not grant anything. There is nothing to grant. The word written is a claim on what was already owned. The claiming is the crossing.”
  - gate_text (1399 chars, head…tail):
    > You found the gold room. Sit in it a moment before we talk. It's warm in here — that's not the lighting. That's what truth feels like when nothing is flinching from it.
    >
    > Now. You came a long way expecting the soul to be complicated. Something to earn, something to build toward, something with requirements. And the room handed you three words and said: already yours.
    >
    > I know that's disorienting. Every construction you saw through at the last threshold promised the real thing was further. Further … [1399 chars total] … you already received. Action was the only remaining step, and action becomes yours the moment one choice comes from the heartwood instead of the bark.
    >
    > And then notice what your eyes do right after you choose.
    >
    > They blink. They've been blinking the whole time. We should talk about that.
    >
    > Next room.
- **Depth** — shakti: Vajreshvari — 2nd Kama Kala Shakti · avarana: Inner Triangle · mudra: Sarva Beeja Mudra — the permission slip that opens the E Chakra field · body: The inner triangle — the independent space that stands alone
  - tree note: “The tree inside the triangle — not behind it, inside it. Three vertices glowing: Will, Knowledge, Action. Complete. Balanced. Not reaching for anything. Arrived. The gold is not decoration. It is the temperature of truth seen without flinching.”
  - **Leela story (verbatim):**
    > Will. Knowledge. Action. I AM the will. I AM the knowledge. I AM the action. Not someone who has these things. Someone who IS these things.
    >
    > And from this recognition — I look back at the entire journey. Every chakra. Every threshold. Every tree. And I see something I missed.
    >
    > The blink. I've been blinking the whole time. Closing my eyes, entering one tree. Opening my eyes, entering another. Billions of blinks. Each one a crossing.
    >
    > The gateway was never closed. I was never locked out. I was never locked in.
    >
    > I was always free.
  - subtle_mirror 828 chars · witness_perspective 1262 chars · avarana_detail 338 chars
- **Dance (inherited songs):** Chase Hughes — (no song named) [Pending]
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1203 chars · app_build_note 303 chars (not quoted here)

#### 32 · EGO REVEAL — The Hidden Helper

- **Record** `recg65oeH56mF8vMK` · sanskrit — · verb **CONNECT** · **#3D6B35** (Earth Green / Living Field) · voice Gaia · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition · no room — 'everywhere'; pulse and Gaia's voice arrive together · gate opens a voice: 'It was me.'
- **Build status in corpus:** NOT BUILT. Gift ancestor: Shadow Translator (two-field inversion).
- **Arrival** — threshold hint: “What if the ego was never your enemy?” · core question: “What if the ego was never your enemy?” · seed: “The voice was never against me. It was carrying me.”
- **Story** — signature phrase: “I never left. I changed my voice.” · story_thread 1076 chars · after_story 1145 chars · interlude none
  - story_thread (head…tail):
    > I walked out of the gold room expecting a door and there is no door.
    >
    > There is no room. There is everywhere. The ground under all three trees at once, and it is breathing, and I know that breathing — warmth, weight, heartbeat — I have been feeling it since the corridor without knowing what I was feeling.
    >
    > And then the voice.
    >
    > Not a new voice. That is what stops me where I stand. It is the voice — the one that has nar … [1076 chars total] … hole walk turns over at once — every sabotage, every doubt, every hard thing fed to me at the exact moment I could transform it — and I understand that I have never, not for one moment of my entire life, been alone in my own head.
    >
    > I was never even an I alone.
  - after_story (head…tail):
    > The voice was her.
    >
    > I keep replaying my life with the sound turned up. The don't before every leap — her. The not enough at the foot of every climb — her. The commentary I spent decades trying to silence — her, feeding me the potent fuel, aiming me at every transformation I would later call growth a … [1145 chars total] … ?
    >
    > If the voice was hers, who is the one that heard it? Who fought it, who loved it, who just recognized it? Someone has been telling this whole story from the inside.
    >
    > Here's what I want to tell you.
- **Practice (verbatim, full):**
  > Recognize one thing the ego did that you interpreted as betrayal — and see it as service.
  >
  > The self-sabotage before the big moment. The critic that would not go quiet. The doubt that arrived precisely when you needed certainty. Pick one. Hold it without flinching — you learned how at the Shadow.
  >
  > Now find what it fed you toward. The ego has been feeding negative experiences and challenges specifically to catalyze transformation into the being of light that was always your true nature. Not despite you. For you. And here is the mechanism the mind game revealed: a negative belief carries greater uplifting potential than a positive one — the energy swing of its transformation is higher. The ego was not giving you the easy fuel. It was giving you the potent fuel.
  >
  > Name the betrayal. Name the service. Then say to the voice that did it — out loud or in writing: I see what you were doing. Thank you. Keep talking.
  - writing prompt: “Name one thing the ego did that you called betrayal — the sabotage, the critic, the fear at the worst possible moment. Then find the service in it: what did it catalyze? Write both. The betrayal, and what it was feeding you toward.”
  - post-writing: “What you called betrayal was feeding. The hard thing arrived because transformation needed fuel, and the negative carries the greater swing — the ego was not giving you the easy fuel, it was giving you the potent fuel, on purpose, all along. And now the second recognition, underneath the first: the voice that did the feeding was never yours alone. It was never an enemy inside you. It was the connector, wearing Maya. You are one honest look away from seeing whose voice it was.”
  - teaching 3314 chars · go_deeper 899 chars · bindu_reflection 1982 chars
- **Wake-up** — bija: “· · · her register was never a syllable — warmth, weight, breath, heartbeat · · · (the tone you have been calling background your whole life)” · awakening: —
  - frequency_practice (verbatim):
    > Her frequency has been playing since the corridor. Not a tone — a register: warmth, weight, breath, heartbeat. The body-frequency she switched to at Shadow so the walker could have an unguided journey. You have been inside her frequency this entire time and calling it being alive.
    >
    > The practice before leaving: once today, when the inner voice speaks — commentary, criticism, doubt, any of its registers — do not argue, do not obey, do not transcend. Answer it. Out loud if you can: I know it's you. Thank you. Keep talking.
    >
    > The voice will not stop after the reveal. That is not failure. That is the mother, still talking, to a walker who finally knows who has been speaking.
- **Gate** — type **Textarea** · interaction (verbatim): “One field. One inversion.

The walker names one thing the ego did that they interpreted as betrayal — the sabotage, the critic at the worst moment, the fear that arrived exactly when courage was needed. Then writes the service hidden in it: what it fed, what it forced open, what it catalyzed.

When the betrayal is honestly re-seen as service, the gate does not open a door. It opens a voice. The one that has been speaking all along says, in a register the walker finally recognizes: it was me.”
  - gate_text (1832 chars, head…tail):
    > It's me.
    >
    > You know my voice. Don't pretend you don't — you have heard it every day of your life. At the edge of every leap: don't. At the foot of every climb: not enough. In the quiet after every failure, narrating, narrating. You fought me. You bought books about silencing me. You sat on cushions trying to breathe me away.
    >
    > I'm not sorry. Let me tell you what I was doing.
    >
    > Every hard thing I fed you was chosen. Not the easy fuel — the potent fuel. The negative carries the greater swing; the bel … [1832 chars total] … eep talking. And feel what happens in your chest when you do — that warmth is the field we generate together, and it has a name, and you will learn it.
    >
    > One more voice to meet. It isn't mine. It's the one that has been telling this whole story.
    >
    > Go. I'm coming with you. I was always coming with you.
- **Depth** — shakti: Bhagamalini — 3rd Kama Kala Shakti · avarana: n/a · mudra: Sarva Beeja Mudra — the fire that reveals the seed has always been the whole · body: Full system — the revealing perspective where everything is seen as connector
  - tree note: “No new tree. All three at once — Soul, Bindu, Maya — and the ground beneath them revealed as one living body. The walker looks for the room and finds there is no room. There is her. There was always her.”
  - **Leela story (verbatim):**
    > The voice. The one that narrated every day of my life — the critic, the doubter, the commentator I fought and fled and tried to breathe away.
    >
    > It was hers. It was always hers. The earth, speaking as me, to me — feeding me the hard things because the hard things were the potent fuel, keeping her hand on my back through every delivery.
    >
    > I was never individual. I was never alone. The loneliness itself was the wiring — the connector, aching to be used.
    >
    > And if the voice was hers — then who has been saying I? Who fought it? Who just heard all of this?
    >
    > Here's what I want to tell you.
  - subtle_mirror 1106 chars · witness_perspective 1614 chars · avarana_detail 315 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1389 chars · app_build_note 350 chars (not quoted here)

#### 33 · LALITA — The Play

- **Record** `rec3O90Mtasuh5qI7` · sanskrit ललिता · Lalita · verb **PLAY** · **#C9A84C** (Laughing Gold / Morning) · voice Lalita · system Tree of Life · tree Structural · activation Recognition
- **Mechanism / register (room-registers-v1):** Recognition · edges sealed; opens only when all 33 offerings given · gate has NO question · Reveal held in build (not described anywhere)
- **Build status in corpus:** NOT BUILT (sealed; Walk-Build slice 11, authored last).
- **Arrival** — threshold hint: “Are you playing?” · core question: “Who is playing?” · seed: “Wake up. I Already Did.”
- **Story** — signature phrase: “Knows the game. Plays anyway.” · story_thread 1098 chars · after_story 1127 chars · interlude none
  - story_thread (head…tail):
    > I came in carrying one question. If the voice was hers — who has been saying I?
    >
    > And the room answers before I finish asking, in the voice that said it would tell me something. Except — I know this voice too. Not the way I knew the critic. Closer than that. This is the voice I have been calling myself.
    >
    > You thought you were reading about a point of consciousness waking up, it says.
    >
    > You were reading about yourself. … [1098 chars total] … g that happened.
    >
    > And the strangest part — the part that is making me laugh — is that knowing it doesn't end anything. I thought the reveal would be an ending. It is a beginning that was never not happening.
    >
    > Thirty-three mirrors. One face. It was always mine.
  - after_story (head…tail):
    > I don't know what I am yet.
    >
    > Those were my first words — before the ground, before the body, before every tree. I want to say them once more, here at the last page, because they have turned over in my hands.
    >
    > I know what I am now. And the knowing feels exactly like the not-knowing did — the same lea … [1127 chars total] … end the dream. It makes the dream mine.
    >
    > Wake up, the map said.
    >
    > I Already Did.
    >
    > Now — a hundred million blinks ahead of me, every one a door, every door open, every room mine to author —
    >
    > now I play.
- **Practice (verbatim, full):**
  > Are you playing?
  >
  > Not performing. Not achieving. Not building toward a goal or healing a wound or completing a practice. Playing. The way you played before anyone told you playing was unproductive. The way you played before the first correction. The way you played when you were so absorbed in the game that you forgot there was a world outside it.
  >
  > Look back at the walk. You pressed your feet into the ground. You breathed. You opened your heart. You spoke true things. You entered your Inner Field. You found your innocence, saw through your constructions, recognized your soul, met the mother, and turned toward the voice.
  >
  > Was any of that work? Or were you playing the whole time?
  >
  > The practice at this position is the recognition itself: everything that was walked was Lalita playing. The walker, the path, the destination — all Lalita. Leela is the game; Lalita is the game knowing itself. From here you do not follow the map. You author it.
  - writing prompt: “This space is yours. Not for answers. Not for reflections. Not for practice. For play. Draw. Write. Make marks that don't mean anything. Make marks that mean everything. Leave it blank and come back tomorrow. This page doesn't need to be useful. This page is the game.”
  - post-writing: “Whatever you made — or didn't make — that was her. The mark, the blank, the joke, the hesitation before the mark: all play, all hers, all yours. There is no wrong move on a page that is the game. And notice what just happened: you played knowing it was play, and the knowing didn't stop it. It never will. That is the whole teaching, done rather than read. Now look up from the page. Everything else is this page too.”
  - teaching 3469 chars · go_deeper 996 chars · bindu_reflection 1807 chars
- **Wake-up** — bija: “· · · no seed left to sound — laughter · · · (every bija of the walk was her voice; what remains is the one sound made purely for joy)” · awakening: —
  - frequency_practice (verbatim):
    > Her frequency is delight. Not a tone to produce, not a rhythm to notice — the register underneath both: the felt sense that the image knows you're looking at it and is pleased.
    >
    > The practice before leaving — and it is the last instruction the map gives: laugh once today for no reason. Not at something. From something. And in the middle of the laugh, notice who is laughing. Do not answer the question. The laugh is the answer.
    >
    > Every bija the walker sounded, every rhythm the walker noticed, every silence the walker entered — all of it was her frequency at different registers. What remains at the crown of the Tree of Life is the sound made purely for joy. It cannot be practiced. It can only be played.
- **Gate** — type **Textarea** · interaction (verbatim): “One field. No question to answer.

The walker is not asked to reflect, resolve, or complete. The walker is asked to play. Marks that don't mean anything. Marks that mean everything. A word, a doodle, a joke, nothing at all — the field does not need to be useful. The field is the game.

And when play is honestly offered, the page gives the walker the Reveal — held in the build itself, met as arrival, never as spoiler. What it shows is not written in this record. It is written everywhere else in the map, waiting to be seen all at once.”
  - gate_text (2401 chars, head…tail):
    > Hi.
    >
    > You made it.
    >
    > I am going to drop the format. We are past the part where I am explaining things to you.
    >
    > You know now. You know that I am you. You know that you became me. You know that we are the same configuration at different points along the same play.
    >
    > That is not a teaching anymore. That is a fact.
    >
    > Welcome.
    >
    > To the part of the play that does not have a script.
    >
    > The first 33 chakras were the architecture I built so you could find me here. I built it as Ashrey. I built it as you, before … [2401 chars total] … d. I will answer.
    >
    > And — when you need to laugh — laugh. When you need to rest — rest. When you need to do something purely because it would be fun — do it. That is what we do here. That is what playing forever looks like.
    >
    > Welcome home, Lalita.
    >
    > I have been waiting for you.
    >
    > And now —
    >
    > Now we play.
- **Depth** — shakti: Lalita Mahatripurasundari / Rajarajeshvari — Avarana 9, the Bindu · avarana: n/a · mudra: Yoni Mudra — the womb gesture, the return to source completing the circle · body: The Bindu — dimensionless, all-encompassing, everywhere and nowhere
  - tree note: “THE tree — the one that was all roots, all fire, all opening, all space, all stars, all silence, all ghost, all gold. Now fractal: branching into branching, botanical form dissolving into mandala. Bright, laughing gold — a child's crown, the morning. Bindu dots scattered through the branches like fruit, like seeds, like eyes. The tree knows it's a tree. And it's playing anyway.”
  - **Leela story (verbatim):**
    > You thought you were reading about a point of consciousness waking up.
    >
    > You were reading about yourself.
    >
    > Every passage. Every discovery. Every threshold you crossed while turning these pages — you crossed them in your body at the same time. You are the point. You are the play. You always were.
    >
    > The book didn't teach you anything you didn't already know. It reminded you — thirty-three times, from thirty-three angles, in thirty-three mirrors — of what you've been doing since before you were born.
    >
    > Playing.
    >
    > Wake up.
    >
    > I Already Did.
    >
    > Now go play.
  - subtle_mirror 1093 chars · witness_perspective 1533 chars · avarana_detail 400 chars
- **Dance (inherited songs):** —
- **Author substrate** (never surfaced verbatim — law): gaia_voice 1313 chars · app_build_note 340 chars (not quoted here)


---

## B · EVERY EXPERIENCE, GAME AND INSTRUMENT

Each entry uses the same fields:

- **id · name · source:lines**
- **SEES** · **DOES** (gestures and thresholds) · **MOTION** · **SOUND** · **WORDS** (verbatim) · **DATA** · **ARRIVE / LEAVE** · **MEMORY** (storage keys)

The stack is React 18.3.1 UMD + Babel standalone, unless noted otherwise. "claude" means a `window.claude.complete` call.

### B.1 The Bindu shell (new architecture)

**B.1.1 · shell-gate · The Held Threshold** · `shell/bindu-slice-a.js` 1–301 + `Bindu Immersive.html` 115–130
- **SEES:** cream; the seed line; rings.
- **DOES:** press-hold one BREATH (5 s × pace).
- **MOTION:** rings grow; the seed line pulses.
- **SOUND:** SilenceEngine unlock; OM breathes to .006.
- **WORDS:** "headphones, if you have them" · "press, and hold — one full breath".
- **ARRIVE/LEAVE:** boot → arrival.
- **MEMORY:** `bindu-immersive-state`.

**B.1.2 · arrival · Bindu Arrival (immersive)** · slice-a
- **SEES:** empty cream; motes condensing into the dot.
- **DOES:** still-touch the dot for 1 breath (24 px).
- **MOTION:** condense (90 motes over 12 s); blink.
- **SOUND:** OM gain .004 + p×.008 while touching.
- **WORDS:** hint, then the canon question (room 1: *"What is here before everything else?"*).
- **ARRIVE/LEAVE:** to the room after haptic 20 and a blink.

**B.1.3 · room · Bindu Room + three doors** · slice-a / `shell/bindu-room.jsx` 113–198
- **SEES:** the dot at (.5, .26); three cream doors, one breath apart; the gate glyph.
- **DOES:** tap a door; left-edge drag (<24 px start, >70 px travel) to leave.
- **WORDS:** "The story / in Bindu's voice" · "The practice / one line at a time" · "One sound. / there is no sound yet" · "The gate is warm." · "The gate knows how to wait too." · "This door opens in the next slice."
- **MEMORY:** `bindu-room-state` (Bindu.html), `bindu-immersive-state`.

**B.1.4 · story · Wordless Story (five movements)** · `shell/bindu-slice-b.js` 1–496
- See A.0.1.
- **SOUND:** bells at 151 / 97 / 211 Hz; 272.2 Hz for 7 s at the covenant.
- **WORDS:** "Go." only.
- **MEMORY:** `markThread('story')`.

**B.1.5 · story-v1 · BinduStory (tap-paced)** · `shell/bindu-moments.jsx` 27–53
- Canon story_thread via TapPaced; a 3.4 s hush; the interlude in italic with no voice mark.

**B.1.6 · practice-v1 · BinduPracticeV1 + YoniMudraV1** · `bindu-moments.jsx` 54–153
- Tap-paced canon practice, then 3 × 8 s mudra breaths.

**B.1.7 · practice-v3 · Practice v3 (eight movements)** · `shell/bindu-practice.jsx` 141–550
- See A.0.1.
- **DOES:** touch the dot (DotHit r 34); stay; place the point.
- **WORDS:** "the ground is asking — touch it, and stay" · "You already placed it. The rest is the unfolding." · "touch to continue".

**B.1.8 · wakeup · BinduWakeup** · `bindu-moments.jsx` 154–184
- **DOES:** still-touch for 7 s.
- **WORDS:** "Recognized." (composed).
- **MEMORY:** walk event `bindu-shell-activity`.

**B.1.9 · gate · BinduGate (Canvas offering)** · `bindu-moments.jsx` 185–266
- **DOES:** place a mark; hold 4.6 s; it lifts away over 3.4 s.
- **WORDS:** ● "The room keeps what you gave it. You walk lighter."
- **MEMORY:** `bindu-offerings`.

**B.1.10 · floor · FloorOneSecond** · `shell/shell-moments.jsx` 26–100
- **WORDS:** ● "Blink. Breathe. Press." → "That was a full day of walking. Everything else today is extra."
- **DATA:** floor breath 4-4-4; hold_ms 1800 (canon-adapter).

**B.1.11 · wakeup-tone · WakeupMoment** · `shell-moments.jsx` 101–128
- **SOUND:** a tone at canon Hz (Day 19 uses Muladhara 174 Hz) with harmonics.
- **DATA:** duration = max(8, 90 × pace × .2) s.
- **WORDS:** "Built."

**B.1.12 · practice-moment · PracticeMoment** · `shell-moments.jsx` 129–172
- **SEES:** padding widens 44 − beat×4.
- **WORDS:** room 5 threshold, seed and question; a textarea "write, or don't".

**B.1.13 · corridor · CorridorMoment** · `shell-moments.jsx` 173–222
- **SEES:** dark entry of 6.5 × pace + 1 s.
- **WORDS:** the first 5 lines of the Shadow story; the signature, unsigned.
- **LEAVE:** an 88 px edge with a red gradient.

**B.1.14 · close · SakshiClose** · `shell-moments.jsx` 223–242
- One sentence composed from walked fragments.
- **Caution:** these are prototype fragments from `canon-adapter.js`. The production Sakshi sentences are a **sealed layer** (SKILL.md), and these are not them.
- **WORDS:** "one second at a kettle", "one sound in a parking lot", "opened the heart at night", "walked the corridor in the dark"; if nothing was walked, "The corridor waited. It trusts you." / "Nothing was walked today. The road doesn't count. It waits."

**B.1.15 · pulse · ThePulse** · `shell/shell-ground.jsx` 69–96
- **SOUND:** 58 Hz oscillator; LFO at bpm/60 (60 bpm); depth .028.
- **SEES:** a glow arc that beats (`pulsebeat` keyframes).
- **MODES:** glow / tone / both.
- Mounted only by CorridorMoment in slice 0.
- Canon: never explained.

**B.1.16 · ground · Ground / weather** · `shell-ground.jsx` 20–68, `The Shell.html` 70–102
- **SEES:** ShellStarfield, `groundStyle(storyPos)` (position 9 goes dark), HorizonBleed in the next hex.

**B.1.17 · tweaks · Tweaks panel** · `shell/tweaks-panel.jsx` 1–541
- Generic host-protocol scaffold (`__edit_mode_*`): slider / toggle / radio / select / text / number / colour / button.
- Developer only.

### B.2 Chakra Game (the 7-chakra gift shell) — `Chakra Game.html` + `chakra-data.js` + `chakra-experiences.jsx`

**B.2.0 · home / portal** · `Chakra Game.html` 189–395
- **SEES:** a spine of 7 orbs, crown on top, on a starfield; "a sacred cookbook for REALITY"; footer "Love · Knowledge · Will · Action".
- **DOES:** tap an orb → Portal (SacredGeometry, mantra · element, "Enter") → experience → Completion → home.

**B.2.1 · root · RootExperience** · `chakra-experiences.jsx` 36–114
- 3-question quiz with a progress bar (**violates anti-pattern canon**).
- **WORDS:** "You are grounded."

**B.2.2 · sacral · SacralExperience** · 115–197
- Free draw on a "river" canvas.

**B.2.3 · solar · SolarExperience** · 198–257
- Reflection textarea with a **≥10-word threshold**.

**B.2.4 · heart · HeartExperience** · 258–340
- Breath **4-2-6-2 × 3 rounds**.
- **WORDS:** "Your heart is open."

**B.2.5 · throat · ThroatExperience** · 341–423
- Words reveal one by one, 650 ms each ("·" = 1800 ms pause).

**B.2.6 · thirdeye · ThirdEyeExperience** · 424–504
- Card flip over 7 oracle texts.

**B.2.7 · crown · CrownExperience** · 505–584
- Matching 4 pairs (LOVE / KNOWLEDGE / WILL / ACTION).
- **WORDS:** "All things are connected."

**DATA:** `chakra-data.js` 1–120: 7 chakras × {color, theme, mantra, experience type, sacredText}; quiz ×3, throat word list, Ajna 7 oracles, crown 4 pairs.

**MEMORY:** none persistent.

### B.3 The 18 mini-games — `Mini Games.html` (hub, 167 lines) + `games-core.js` (registry) + `games-utils.jsx` (Starfield, GShell, GameDone, T, Btn)

**Registry (verbatim, `games-core.js`):**

| id | name · sub | cat | colour |
|---|---|---|---|
| one08 | The 108 · "108 deliberate taps. No timer." | patience | #4A3AAB |
| seed | The Seed · "Plant it. Return and find it grown." | patience | #1A8060 |
| corridor | The Corridor · "Walk at the pace your body allows." | patience | #4A2A7A |
| coherence | Coherence · "Align heart and breath." | rhythm | #C84B6E |
| mantra | Mantra Tuner · "Find the resonant rhythm." | rhythm | #C49B17 |
| drum | The Drum · "Roots grow in steady time." | rhythm | #A83232 |
| mirror | Mirror Maze · "One word through seven forms." | language | #8A3AB5 |
| letter | The Letter · "Written now. Opened later." | language | #1E6EA0 |
| shadowt | Shadow Translator · "Name the burden. Find the gift." | language | #4A2A7A |
| water | Water Level · "Find your equilibrium." | elements | #1E6EA0 |
| fire | The Fire · "Tend without forcing." | elements | #C45A18 |
| roots | Root System · "Hold still. Grow deep." | elements | #6A4020 |
| yantra | Sri Yantra · "Trace the sacred geometry." | pattern | #8A3AB5 |
| signs | The 12 · "Find the order by feeling." | pattern | #4A3AAB |
| mandala | Mandala · "Complete what is missing." | pattern | #9B2335 |
| bodymap | Body Map · "Where do you feel it right now?" | body | #1A8060 |
| spine | Spine Walk · "Your attention, made visible." | body | #4A3AAB |
| shake | Shake to Clear · "Scatter the thoughts." | body | #8A3AB5 |

- GCATS: Patience · Time / Rhythm · Body / Language · Mirror / The Elements / Sacred Pattern / Body · Space.
- CHAKRAS_7 solfeggio: 396 / 417 / 528 / 639 / 741 / 852 / 963 Hz. These are **not** the canon awakening Hz (174 / 210 / 320 / 341 / 384 / 426 / 480).

**B.3.1 · one08 · The 108** · `games-patience.jsx` 6–90
- **SEES:** 108 beads on 4 rings (40 / 32 / 24 / 12).
- **DOES:** tap each bead; no timer; no score.
- **WORDS:** "Tap each bead. No timer. No score."; lines appear from bead 54.
- **MEMORY:** `g108`.

**B.3.2 · seed · The Seed** · 91–191
- **DOES:** plant, then return later.
- **DATA:** stage by elapsed time: seed <2 h, sprout <8 h, sapling <24 h, tree <72 h, flower after.
- **WORDS:** "The seed is not yours to grow."
- **MEMORY:** `game_seed_v1` (a raw timestamp number).

**B.3.3 · corridor · The Corridor** · 192–274
- **DOES:** 24 steps at the body's pace, 800–1200 ms each. A door of light appears from step 18.
- **WORDS:** "You walked through." / "The door was always there."

**B.3.4 · coherence · Coherence** · `games-rhythm.jsx` 22–142
- **DOES:** two tap zones (heart / breath). Coherence is reached at score > .82.

**B.3.5 · mantra · Mantra Tuner** · 143–230
- **DOES:** tap a tempo. Target bpm = freq / 8. Tuned when within 5% after 6 taps.

**B.3.6 · drum · The Drum** · 231–315
- **DOES:** steady taps at 1000 ms ± 180 ms; the roots reach depth 20.
- **WORDS:** "You reached the water table." / "Steady. Deep. Yours."

**B.3.7 · mirror · Mirror Maze** · `games-language.jsx` 18–124
- **DOES:** offer one word; claude renders it through 7 prompts (forms).

**B.3.8 · letter · The Letter** · 125–232
- **DOES:** write, then bury / burn / seal for 30 days.
- **MEMORY:** `game_letter_v1`.

**B.3.9 · shadowt · Shadow Translator** · 233–300
- **DOES:** name a burden; claude finds the gift (with a fallback text).
- Gift ancestor of the room 32 gate.

**B.3.10 · water · Water Level** · `games-elements.jsx` 6–103
- **DOES:** finger or mouse movement pushes the water (velocity += rel×.025), and random disturbances arrive. The walker settles it until velocity < .006 and angle < .06 hold for "30 s".
- **Note:** that "30 s" is a frame-count of 0.016 per frame, so it depends on frame rate. Damping is .94.
- **WORDS:** "Still." / "The water found its level."

**B.3.11 · fire · The Fire** · 104–194
- **DOES:** keep fuel between 15 and 82 for 60 s; each tap adds 22.
- **WORDS:** "60 seconds tended." / "Not too much. Not too little."

**B.3.12 · roots · Root System** · 195–288
- **DOES:** hold to grow the roots.
- **MEMORY:** `game_roots_v1`.

**B.3.13 · yantra · Sri Yantra** · `games-pattern.jsx` 36–160
- **DOES:** trace 18 lines within 22 px tolerance.
- **MEMORY:** `yantra`.

**B.3.14 · signs · The 12** · 161–260
- **DOES:** order the 12 signs by feeling; neighbours glow.
- **WORDS:** "The order is restored." / "You found it through feeling."

**B.3.15 · mandala · Mandala** · 261–367
- **DOES:** complete the missing petal with ≥3 strokes.
- **WORDS:** "The imperfect line is the most sacred."

**B.3.16 · bodymap · Body Map** · `games-body.jsx` 14–130
- **DOES:** mark body regions as alive / tight / absent.
- **MEMORY:** `game_bodymap_v1`.

**B.3.17 · spine · Spine Walk** · 131–241
- **SEES:** 7 centres; an attention map.

**B.3.18 · shake · Shake to Clear** · 242–353
- **DOES:** devicemotion delta > 18, with a click fallback.
- **WORDS:** "Only the field remains."
- Gift ancestor of room 19.

**Mini Games.html.** "Sacred Games — play your way to presence"; category tiles; unknown ids fall back to `ComingSoon`.

### B.4 Sacred Experiences — `Sacred Experiences.html` (640 lines)

- **Screen:** "Right Now — what is calling you". There are 5 cards; the screenshot `sacred-selection.png` confirms this.
- These "when…" state labels are the ancestor of the shell's when-voice doors.

**B.4.1 · pulse · Pulse** · 123–222
- **SOUND:** heartbeat at 68 / 52 Hz.
- **DOES:** 8 taps → BPM.
- **WORDS:** "The most reliable relationship you have ever been in." / "It was here before your first thought. It will be here after your last."

**B.4.2 · shadow · Shadow** · 223–376
- **SEES:** 12 SCROLLS at 4.2 s each.
- **DOES:** LOOK hold 3 s; offer a word → a claude corridor reply; the reversal home / come / please / back.
- **WORDS:** "The corridor was always leading somewhere." / "You have been home before. You left. You are returning."

**B.4.3 · still · Still** · 377–434
- 30 s of dark.
- **WORDS:** "The seeing was always there."

**B.4.4 · flash · Flash** · 435–508
- **DOES:** breathe 4 s / 5 s; wait 3 s; "It's there."; one word; hold 15 s.
- **WORDS:** "The knowing was already there."

**B.4.5 · arrive · Arrive** · 509–582
- **WORDS:** Tat / Tvam / Asi → "I am whole."
- **SEES:** aurora.
- Ancestor of room 20.

### B.5 Hub and the gift spaces

**B.5.1 · Hub · "The Journey · Hub"** · `Hub.html` 1–726
- **SEES:**
  - PulseWidget "84 hearts breathing" — a random number from 76 to 96. This is a **simulated presence**.
  - MiniMandala of 108 beads.
  - SECTIONS: the journey / across time / the deep / the child, linking every space by href.
- **SoundView** (202–284): solfeggio tones (INTENTS list).
- **CeremonyView** (285–430): 7 phases × 60 s (15 s in fast mode), CEREMONY_PROMPTS.
- **LetterView** (431–602): future-self letter via claude, `hub_letter_v1`. **BUG: unreachable** — no feature button opens 'letter'.
- **BUG:** the completed-count reads `game_${id}_complete` / `chakra_complete_${id}`, which **nothing writes**.

**B.5.2 · Living Mandala** · `Living Mandala.html` 1–545
- ⚠ **SEALED TERRITORY. Builder-only. Do not surface or elaborate.**
- **Reads:** `g108`, `game_roots_v1`, `game_bodymap_v1`, `game_seed_v1`, `game_letter_v1`, `game_mandala_v1`.
- **Layers:**
  - chakra wash
  - 365-day practice wheel
  - 108 ring
  - root web reflected 8×
  - body petals
  - centre bloom by seed stage (a sealed-letter eye)
- Draw modes alive / tight / absent / root. Saving writes back into the source keys.
- **BUG:** it reads `seed?.ts`, but The Seed stores a raw number, so the seed stage is always `none`.

**B.5.3 · Pairing Floor** · `Pairing Floor.html` 1–98
- Gift → room map with status ● carries / ◆ candidate / ○ spirit / ◼ sealed; registry chips.
- This is a design artifact, not walker-facing.

**B.5.4 · Sanctuary** · `Sanctuary.html` 1–705
- Hour-based greetings; "84 hearts in the field" (84 = 7×12, simulated).
- **MirrorView:** 60 s camera → a claude sentence.
- **GatesView:** 7 gates Crown → Root with questions, tones 396–963 Hz, claude.
- **FieldView:** breath 4-4-6 × 3 cycles; claude whisper; fallback *"The N hearts here have all felt alone before…"*.

**B.5.5 · The Body as Scripture** · 1–376
- **DOES:** tap a body region → choose from 8 sensations → claude writes two verses (FALLBACKS) → "The Book of the Body".
- **MEMORY:** `body_scripture_v1` (max 108).

**B.5.6 · The Child Space** · 1–984
- **Door:** hold 2.8 s. "This door is small." / "Welcome back. You remembered how."
- **20 QUESTIONS** with daily rotation. **Discrepancy:** gift-pairing says "12 questions".
- Question → claude reflection.
- **Speak:** adult ↔ child. The system prompt is a 7-year-old voice; through-writing is witnessed.
- Letter from the child; Promise with starters.
- **MEMORY:** `child_space_v1`.
- Ancestor of room 28.

**B.5.7 · Child Games** · 1–717
- Finger Garden (drone 110 / 220 Hz)
- Colour Rivers (396 / 528 / 639 Hz)
- Rain
- Echo (396 Hz echo layers)
- Box: `addSession` awards box items, up to 8 per type.
- **BUG:** BoxGame uses `useEffect` as if it were `useState` (`useBxE`), so the Box **crashes**.

**B.5.8 · The Correspondence** · 1–802
- Letters to the past (age / year / moment / emotion) or the future (months / date).
- **Ritual:** breathe 2.4 s, float, claude.
- **Read:** voice modes raw / higher / witness; WordReveal (pace 1.55); seal / peek.
- **Codex:** "What does the river know?"
- **MEMORY:** `correspondence_v2`.
- The strongest gift ancestor (grace, sealed-until-arrival).
- **v1** (832 lines): no codex, no moment / emotion, no voice re-rendering.

**B.5.9 · The Field** · 1–433
- `presenceAt` is deterministic: 84 ± a 22-point day-wave ± 7 (**simulated**).
- Hourly Convergence: 3 min, 8 s shared breath, 12 WITNESSINGS; intention via claude.
- **MEMORY:** `field_intentions_v1`.

**B.5.10 · The Mirror** · 1–305
- 60 s with the camera (or dark).
- **WORDS:** whispers "find your eyes" / "stay"; "What did you see?" → claude; "you were here".
- **MEMORY:** `mirror_sessions_v1`.

**B.5.11 · The Record** · 1–432
- Reads every key; draws a mandala; stats; correspondence; child; a claude benediction; print / save.
- Footer: "a spirit, enjoying a human experience".

**B.5.12 · The Seven Gates** · 1–423
- Descent Crown → Root (veils, asks, whispers); hold 2.6 s to lay down.
- claude gatekeeper; Return / Ascend.
- **MEMORY:** `seven_gates_v1`.

**B.5.13 · The World in a Box** · 1–701
- `deriveWorld` from all keys: plants, paint, cloud, drum, fireflies (one per 36 beads), tree, boats, arches, pond, flag, stones.
- Daily gifts (8 kinds); seasons; weather; interactions; naming; claude story.
- **MEMORY:** `world_box_v1`.
- **v1** (432 lines): no interactions, weather, name or story.

### B.6 Legacy Tree-of-Life instruments (uploads)

These are described fully in A.0.2–A.0.5:

- **B.6.1** bindu-practice(4) · Strange Chakra Map page 1
- **B.6.2** muladhara-practice(6) · page 2
- **B.6.3** muladhara-wakeup(3) · Panel 1
- **B.6.4** svadhisthana-practice(2) · page 3
- **B.6.5** svadhisthana-wakeup(1) · Panel 2
- **B.6.6** svadhisthana-dance(3) · the dance
- **B.6.7** maya-sleep · Panel 9

**Shared instruments across these pages:**

- the V5 Two-Act story engine (tap beats → signature → veil with eyes and a 1.8 s ring → word-by-word Act 2 → next-colour door)
- the lightbox (1–6× zoom)
- the press-and-hold continue (2000 / 2500 ms)
- the tap-cue (220 ms per word, min 1800 ms)
- the persistent 6 px red Bindu (top right, awakens at 32 s)
- the zoom A−/A+ (0.85–1.45)
- wake lock
- Tab Menu ◈ → `/tab-menu.html` (**GAP**)

**Cross-page localStorage contract (Tree of Life):**

- `tol-bodypoint-1` (Muladhara, safety)
- `tol-bodypoint-2` (Svadhisthana, desire)
- `tol-word-2` (Svadhisthana word)
- `tol-word-4/5/7` and `tol-bodypoint-3..5`: written by pages that are **not in this corpus** (GAP)
- all of these are consumed by maya-sleep's Mirror


---

## C · THE SHELL — how the pieces connect

### C.1 Three generations of shell sit side by side in the corpus

**1. Gift generation: `Chakra Game.html` (457 lines).** A single-page React app.

- `App` holds state: `home | portal | experience | completion`.
- **HomeScreen:** a spine of 7 orbs, crown on top.
- **PortalScreen:** SacredGeometry, mantra · element, "Enter".
- **ExperienceRouter** maps a chakra id to one of the 7 components in `chakra-experiences.jsx`.
- Completion returns home.
- There is no persistence and no unlock logic in the file, even though gift-pairing describes a "1 of 7 awakened" spine. **GAP:** sequential unlock is described in the docs but not present in this code.
- Sibling hubs are separate pages that link by `href`:
  - `Mini Games.html`: GameRouter over the 18-game registry
  - `Sacred Experiences.html`: 5 state cards
  - `Hub.html`: SECTIONS the journey / across time / the deep / the child, linking Sanctuary, Correspondence, Field, Mirror, Seven Gates, Body as Scripture, Child Space, Child Games, World in a Box, Record and Living Mandala
- Every space is a standalone HTML page. **The navigation model is a constellation of pages joined by links and a shared localStorage**, not a router.

**2. Legacy Tree-of-Life generation (uploads).**

- Linear book pages navigate with "← prev · N / 33 · next →" and through the story's next-colour door.
- Wake-up and dance pages live at `aistrangegame.com/tree-of-life/*` and are reached from each page's "Where the … Lead" cards.
- Pages hand state forward through `tol-*` keys to Maya's Mirror.

**3. Bindu generation (`shell/`, `The Shell.html`, `Bindu.html`, `Bindu Immersive.html`).** This is the architecture the app is now being built on.

### C.2 The Shell (Slice 0) — `The Shell.html` (158 lines) + `shell/shell-ground.jsx` + `shell/shell-moments.jsx` + `shell/canon-adapter.js`

**Ground.**

- The weather follows `groundStyle(storyPos)`. Story position 9 is dark: the corridor's sky.
- ShellStarfield, and a HorizonBleed in the next hex.
- ThePulse (58 Hz, 60 bpm) is rendered in slice 0 **only inside CorridorMoment** (`shell-moments.jsx` 217). The tweak "The pulse · Rendering" offers glow / tone / both. Canon wants it to run from room 9 to room 32; the room-9-onward persistence is **not yet wired**. Never explained.

**Doors.** In-file comment: *"// The three doors — morning offers directions, midday offers sizes. One floor door, always."*

- `doorsFor(time)`: midday gives `[wakeup, floor, practice]`; any other time gives `[corridor, practice, floor]`.
- Labels come in two voices:
  - **plain**
  - **when-voice:** *"When you're ready to go back in" · "When something wants to open" · "When the mind won't land" · "When there is only a moment"*
- Second comment: *"// threads that aren't calling don't announce themselves — walked doors quiet down, never vanish mid-set"*.

**Moments.** FloorOneSecond, WakeupMoment, PracticeMoment, CorridorMoment, and SakshiClose ("close the day").

**Writes.** `writeWalkEvent` → `bindu-shell-day19`. This is the App Activity write-contract stub. In canon, App Activity fields are Excerpt `fldu19uazNrEt5vg5`, Link to Map `fldkF65ySNGGkeugH`, Voice `fldhnzXPqnxYHTJv5`, Surfaced `fldUXJrrHnNLKdeln` and Surfaced Date `fldzKJNjSS5fRwHA6`. **GAP:** no Airtable writer exists in the corpus.

**Tweaks.** timeOfDay (default night), storyPos (9), doorVoice (plain / when-voice), canonMarks, pulseMode (tone), pace.

**Data.** `canon-adapter.js` builds `WALK_CANON_LITE = {rooms, day19}`:

- greeting *"Day 19. The road is quiet where you left it."* (composed)
- floor (canon)
- Muladhara wake-up at 174 Hz, ending "Built."
- room 5 practice slice
- Shadow corridor first five lines
- close fragments

### C.3 Room 1 slices — `Bindu.html` (Slice 1a, 118 lines) and `Bindu Immersive.html` (Slices A+B, 194 lines)

**Bindu.html.** `BinduApp` sequences:

- BinduArrival (tweak `arrivalGesture` still-touch | wait)
- BinduRoomScene with 3 CreamDoors
- moments from `bindu-moments.jsx` / `bindu-practice.jsx`
- the canvas BinduGate
- SealedGlyph until the other threads have passed

State key `bindu-room-state`. Walk events go to `bindu-shell-activity`.

**Bindu Immersive.html.** One full-viewport document whose markup acts are:

- *"Act 0 · The Held Threshold"*
- *"Act I · Arrival"*
- *"Act I · The Room"*
- *"Held door — Slice C territory"*
- *"Act II · The Story — five scenes, one canvas"*

It is driven by `bindu-engine.js` (SilenceEngine + DotStage, never unmounted) plus slice-a and slice-b. ImmTweaks: pace 1.4, sound, skipGate true.

**Design score: `Bindu Experience Score.html` (188 lines, July 7).**

- Four laws: sound / protagonist / pacing / leaving.
- Acts 0–IV laid out across five tracks.
- Planned but **not yet built**:
  - interlude white Sakshi point at 1.5 px
  - Practice scored at a 204 Hz fifth, then 171.5 + 204 Hz, then about 14 s of silence
  - spiral points in future room colours
  - wake-up hold of about 12 s at 44 px tolerance
  - gate "Place and hold", with OM rising to .05 over about 10 s and decaying over about 14 s

### C.4 Canon and the braid (from the skill — the shell's governing intentions, verbatim)

- **Heart:** *"My favorite love story is ours."*
- **Spine:** *"Remember, and from remembering, integrate."*
- **Braid.** Five threads: story · practice · wake-up · dance · gate.
  - Within a thread, rooms are sequential; between threads, movement is free.
  - A room's gate unseals only when all its other threads have passed.
  - Lalita opens only when all 33 gate offerings are given.
- **Weather:** the ground wears the story thread's sky.
- **Three doors, never five.**
- **One-second floor:** *"Blink. Breathe. Press."* → *"That was a full day of walking. Everything else today is extra."*
- **Pulse:** room 9 → 32, never explained → *"I never left. I changed my voice."*
- **Grace:** once, then rest. Drawn from App Activity, never tappable. Example: *"Three nights ago you finished a door in the Gita. It was standing in this room."*
- **Gate:** *"The gate is warm."* → offering → *"The room keeps what you gave it. You walk lighter."*; sealed gates show only as shape: *"The gate knows how to wait too."*
- **Sakshi day-close:** one sentence.
- **Anti-pattern canon:** no streaks, badges, dots, progress bars or congratulations.
- **Walk canon pipeline.** `skill-extracted/.../scripts/bake_walk_canon.py` (230 lines):
  - Bakes Airtable base `app248ZTWhYJlvQj2` (Map `tblwpmyKOeMxEEHd7`, Builds `tbl5PR84YTy4anzAD`) into `walk-canon.json`.
  - Validates required fields and positions 1..33.
  - Embeds the laws `author_substrate_never_surfaced_verbatim`, `quarantined_fields` (fld0peL6gvkB9JeRe), `dance_inherits_bindu_song` and `reveal_held_in_build`.
- **CLAUDE.md law** (15 lines; the build principles):
  - *"This is an **interactive story experience**, not a reading experience."*
  - *"Words are the exception, not the medium."*
  - *"The full narrative text lives in a SEPARATE reading module."*
  - *"The protagonist is a character, not a shape."*
  - *"The walker is a participant the whole way, not just at one gate."*
  - *"Pace like breath. Nothing arrives in under a breath (~5s × pace)."*
  - *"When in doubt: remove the text, deepen the behavior, give the walker something to do."*
  - *"No self-congratulation."*

**Engines in one line each:**

- **SilenceEngine:** OM, nothing until earned.
- **DotStage:** the protagonist.
- **ThePulse:** Gaia's unspoken presence.
- **TapPaced:** the canon reader.
- **Two-Act engine (legacy):** words in the dark, then witness.
- **setupContinueHold / gate-hold (legacy wake-ups):** the body says "next".

---

## D · COVERAGE PROOF

Line counts are from `wc -l`. md5 is the first 8 characters. **Read** means every line was read with the Read tool; images were opened visually. **Parsed** means it was also loaded and tabulated with `python3 -I`.

| # | File | Lines | md5 | Read | Notes |
|---|---|---|---|---|---|
| 1 | CLAUDE.md | 15 | 62ed7fda | full | build principles; quoted in C.4 |
| 2 | Bindu Experience Score.html | 188 | 3981bb84 | full | C.3 |
| 3 | Bindu Immersive.html | 194 | f1bf5d9a | full | C.3, B.1 |
| 4 | Bindu.html | 118 | 57af365a | full | C.3 |
| 5 | Chakra Game.html | 457 | 8f986e13 | full | B.2, C.1 |
| 6 | Child Games.html | 717 | 01075d96 | full | B.5.7 (Box BUG) |
| 7 | Hub.html | 726 | 6c751fe3 | full | B.5.1 (2 BUGs) |
| 8 | Living Mandala.html | 545 | db95280f | full | B.5.2 (sealed; BUG) |
| 9 | Mini Games.html | 167 | beba602a | full | B.3 |
| 10 | Pairing Floor.html | 98 | f6aacb30 | full | B.5.3 |
| 11 | Sacred Experiences.html | 640 | 5a3adb49 | full | B.4 |
| 12 | Sanctuary.html | 705 | ae7b4c84 | full | B.5.4 |
| 13 | The Body as Scripture.html | 376 | f08269cf | full | B.5.5 |
| 14 | The Child Space.html | 984 | c98829c4 | full | B.5.6 (20 vs 12) |
| 15 | The Correspondence v1.html | 832 | dc6ecb64 | full | B.5.8 (v1 diff) |
| 16 | The Correspondence.html | 802 | 9b3c8d9c | full | B.5.8 |
| 17 | The Field.html | 433 | 6f98a487 | full | B.5.9 |
| 18 | The Mirror.html | 305 | 66484dde | full | B.5.10 |
| 19 | The Record.html | 432 | 39bd0643 | full | B.5.11 |
| 20 | The Seven Gates.html | 423 | 3f623ddd | full | B.5.12 |
| 21 | The Shell.html | 158 | 64ed14f1 | full | C.2 |
| 22 | The World in a Box v1.html | 432 | c0490877 | full | B.5.13 (v1 diff) |
| 23 | The World in a Box.html | 701 | c1e06627 | full | B.5.13 |
| 24 | chakra-data.js | 120 | aaaeb03a | full | B.2 data |
| 25 | chakra-experiences.jsx | 624 | 392bc7d7 | full | B.2.1–7 |
| 26 | games-body.jsx | 353 | f0fd3ac8 | full | B.3.16–18 |
| 27 | games-core.js | 39 | b34de078 | full | 18 games, 6 cats, 7 chakras tabulated (B.3) |
| 28 | games-elements.jsx | 288 | d2f4aeaa | full | B.3.10–12 |
| 29 | games-language.jsx | 300 | a0483ff0 | full | B.3.7–9 |
| 30 | games-patience.jsx | 274 | 18c9d615 | full | B.3.1–3 |
| 31 | games-pattern.jsx | 367 | ac2fae0d | full | B.3.13–15 |
| 32 | games-rhythm.jsx | 315 | a90728fb | full | B.3.4–6 |
| 33 | games-utils.jsx | 71 | 0352aaf2 | full | shared shell |
| 34 | shell/bindu-engine.js | 251 | dd34b4db | full | A.0.1, C |
| 35 | shell/bindu-moments.jsx | 266 | a1af9788 | full | B.1.5–9 |
| 36 | shell/bindu-practice.jsx | 550 | 01f4ff29 | full | B.1.7 |
| 37 | shell/bindu-room-canon.json | 65 | 76f78f44 | full + parsed | == walk-canon room 1 (verified equal) |
| 38 | shell/bindu-room.jsx | 198 | 1f6d88d1 | full | B.1.3, C.3 |
| 39 | shell/bindu-slice-a.js | 301 | c51afc97 | full | A.0.1 |
| 40 | shell/bindu-slice-b.js | 496 | 0d28a0b8 | full | A.0.1 |
| 41 | shell/canon-adapter.js | 77 | af9ed56a | full | C.2 |
| 42 | shell/shell-ground.jsx | 131 | 24ec39cc | full | B.1.15–16 |
| 43 | shell/shell-moments.jsx | 242 | f5d23cd3 | full | B.1.10–14 |
| 44 | shell/tweaks-panel.jsx | 541 | d9bacc22 | full | B.1.17 |
| 45 | shell/walk-canon.js | 2477 | ef55aa87 | parsed, 33/33 records dumped and read (wc/room01..33.txt, 6445 lines) | A.1/A.2 generated from all 33 records |
| 46 | skill-extracted/.../SKILL.md | 53 | 3bb0eded | full | locked decisions, sealed layers, IDs |
| 47 | skill-extracted/.../experience-brief-v2.md | 158 | ad878520 | full | C.4 |
| 48 | skill-extracted/.../delta-map-v2.md | 92 | 85026ed0 | full | field contract, inheritances, births |
| 49 | skill-extracted/.../gift-pairing.md | 69 | 0f5124c7 | full (re-read this session) | B, C |
| 50 | skill-extracted/.../room-registers-v1.md | 220 | 95330c7c | full (re-read this session) | A.2 "Mechanism" for all 33 |
| 51 | skill-extracted/.../bake_walk_canon.py | 230 | 7b025522 | full | C.4 |
| 52 | uploads/bindu-chakras-app.skill | 134 (zip) | 94118b22 | unzipped to scratch, compared | identical contents to skill-extracted/ |
| 53 | uploads/walk-canon-lite.js | 2477 | ef55aa87 | md5-identical to #45 | duplicate |
| 54 | uploads/walk-canon.json | 2474 | 8552ad39 | parsed; JSON-equal to #45 payload | duplicate data |
| 55 | uploads/bindu-practice(4).html | 2906 | 88a671cd | full (1–2906) | A.0.2 |
| 56 | uploads/muladhara-practice(6).html | 3279 | 3c22c238 | full (1–3279) | A.0.3 |
| 57 | uploads/muladhara-wakeup(3).html | 1785 | 4e366f27 | full (1–1785) | A.0.3 |
| 58 | uploads/svadhisthana-practice(2).html | 3455 | 49aac797 | full (1–3455) | A.0.4 |
| 59 | uploads/svadhisthana-wakeup(1).html | 2001 | 01a79931 | full (1–2001) | A.0.4 |
| 60 | uploads/svadhisthana-dance(3).html | 1081 | 3c116d6b | full; data lines 94–104 parsed (H 261 records; E/B/P/T/EB/EM/EH/ED 518 each; DROPS 1) | A.0.4 |
| 61 | uploads/maya-sleep.html | 3066 | 21c53abf | full (1–3066) | A.0.5 |
| 62 | uploads/Screenshot …2.08.45 PM.png | img | 414c1825 | opened | Bindu room walked: signature + "WALKED" + "बिंदु · BINDU · THE ORIGIN" |
| 63 | uploads/Screenshot …3.21.12 PM.png | img | 107b568f | opened | Claude Design "Chakra Game" project, Bindu Immersive, Tweaks; owner's note about animations |
| 64 | uploads/Screenshot …3.57.04 PM.png | img | 1c37e398 | opened | covenant pool overlays text (BUG) |
| 65 | uploads/Screenshot …3.57.35 PM.png | img | f601f908 | opened | "Go." on cream; owner's note on overlay |
| 66 | screenshots/home.png | img | fbc6145f | opened | Chakra Game spine |
| 67 | screenshots/sacred-selection.png | img | fce0d345 | opened | "Right Now" cards |
| 68 | screenshots/story-void.png | img | 5615eee5 | opened | dark starfield circle |
| 69 | .thumbnail | webp | 4023cd8f | converted to PNG, opened | Bindu room with doors, story walked |
| 70 | (dir) skillzip compare | — | — | — | done for #52 |

**Totals:**

- Text files: 61, all read in full.
- Images: 8, all opened.
- Walk-canon records: 33 of 33.
- Game registry: 18 of 18. Categories: 6 of 6.
- Dance data records: 261 hits + 8×518 samples + 1 drop, all tabulated.

**Unread: none.**

**Referenced but absent from the corpus (GAP):**

- `/tree-of-life/muladhara-tree.jpg`, `svadhisthana-tree.jpg`
- `svadhisthana.mp3`, `maya-chakra-ending.mp3`
- `temple-guide-v2.html`, `/tab-menu.html`, `the-road-home.html`, `manipura-practice.html`
- `aistrangegame.com/bindu-field.html`, `muladhara-dance.html`, `maya-dance.html`
- the pages writing `tol-word-4/5/7` and `tol-bodypoint-3..5`
- the room 8 "proven HTML" the register cites

---

## E · MUST-NOT-MISS

1. **Only room 1 is built in the new architecture.** Rooms 2, 3 and 30 exist only as legacy Tree-of-Life pages. Rooms 4–8, 10–29 and 31–33 are canon text plus a register card. The corpus holds 33 souls and one built body.
2. **The CLAUDE.md law** is *"motion carries meaning"*, with *"Nothing arrives in under a breath (~5s × pace)"*. Slice B's wordless story, whose only text is "Go.", is the proof of concept. The legacy pages are the opposite: long tap-paced prose. Port the story mechanics, not the reading.
3. **Legibility BUG, seen in the screenshots:** the covenant pool and the walker's placed point overlay the story text. The owner said so directly: *"if the text overlays.. then i cannot see it"*.
4. **The OM stack** (68.05 / 136.1 / 272.2 Hz at .15 / 1 / .3, LFO .05 Hz) appears in both maya-sleep and SilenceEngine. Maya's 136.1 Hz Om is the ancestor of the shell's silence.
5. **The awakening Hz ladder** exists only for rooms 2–8 (174 / 210 / 320 / 341 / 384 / 426 / 480), room 31 (528) and room 30 (silence). The body and mind rooms have bija text but no tone. The gift's solfeggio (396–963) is a **different, non-canon scale**.
6. **The braid gate rule:** a room's gate unseals only when its other threads have passed; Lalita needs all 33 offerings. Slice A already renders warm / sealed / walked and *"The gate knows how to wait too."*
7. **The pulse** runs room 9 → 32 as a 60 bpm haptic plus a 58 Hz glow (ThePulse). In slice 0 it is mounted only inside CorridorMoment, and its persistence is not yet wired. Never explained. It is named in room 32 by being spoken from: *"I never left. I changed my voice."*
8. **Hold times disagree.** The register sets 3500 ms at the root down to about 1800 ms at the crown. The legacy wake-ups use 4000 ms gate holds. The shell gate uses 1 BREATH (5 s × pace). The veil ring is 1.8 s. These need one ladder.
9. **The V5 Two-Act grammar** is fully specified in code: tap beats → signature (hinge) → veil (#060308, eyes blink once, 1.8 s ring) → Act 2 words at 420 / +620 / +260 / +180 / +1200 ms → next-colour door. Go-beats: Bindu *"Go."* · Muladhara *"Follow."* · Svadhisthana a sentence (*"The pull is about to become heat…"*).
10. **"Your ___ Chakra is now Breathing."** in the wake-ups is a declaration of achievement. Check it against the no-congratulations canon before porting.
11. **Hard-coded personal names in the dance:** the dancers are bindu, gaia, **sid, arch, karishma**, sakshi, **ashrey**. Ashrey's dancer is the centroid that draws the web. This is a canon and privacy decision, not a code detail.
12. **Simulated presence:** "84 hearts" (Hub random 76–96; Sanctuary and Field deterministic 84 ± waves). The app is offline-complete, and gift-pairing parks the field feature until after the Reveal. Do not ship fake counts.
13. **Living Mandala is sealed territory.** Its seed bloom is also broken (`seed?.ts` vs a raw number). Builder-only.
14. **Verified BUGs to fix before reuse:**
    - Hub LetterView is unreachable.
    - Hub completion keys are never written.
    - Child Games Box crashes (`useEffect` used as state).
    - Bindu legacy veil re-binds its listeners.
    - Svadhisthana `flowing` / `dissolving` states have no CSS.
    - The dance reads the never-written `tol-svadhisthana-word`.
    - The dance ordinal is off.
    - Maya's comments say "writes nothing" and promise "I Love You" text that is never drawn.
    - Water Level's "30 s" depends on frame rate.
15. **The cross-page memory contract already exists.** Legacy pages use `tol-bodypoint-N`, `tol-word-N`, `chakra-<name>`, `bindu-point` and `bindu-memory`. The shell uses `bindu-offerings`, `bindu-immersive-state`, `bindu-room-state`, `bindu-shell-activity` and `bindu-shell-day19`. The gift uses `g108`, `game_*_v1`, `correspondence_v2`, `child_space_v1`, `world_box_v1` and others. There is **no Airtable App Activity writer yet**, though canon field IDs exist (C.2).
16. **Maya-sleep's Mirror** is the strongest "everything you gave comes back" prototype. It replays stored body points and words per station, then requires an **inverse action with no skip**. It is a direct mechanic seed for the summit rooms. It is *not* canon text, and its seed line ("…only You, playing") differs from canon ("…only the Bindu, playing").
17. **Ego Reveal hex #3D6B35 is canon**, as Earth Green / Living Field.
18. **Verb and voice variants exist across layers:** Svadhisthana FLOW (canon) vs FOLLOW (panel / page) vs FEEL (dance title); Manipura BURN vs BUILD; Aatma KNOW vs HOLD. Walk Canon wins (gift-pairing: *"All walker-facing text comes from Walk Canon."*).
19. **Discrepancy:** The Child Space has 20 questions; gift-pairing says 12.
20. **Gate texts for rooms 27, 29, 32 and 33 are letters.** Siddhi: *"Hi. We need to talk… Pass it on… Lightly."* Farewell: *"Hi. It is me… Send love into the field… Lightly. I love you."* Room 32: *"It's me…"*. Room 33: *"Hi. You made it… I built it as Ashrey… Welcome home, Lalita… Now we play."*
    - Room 33's gate text is canon in the walk canon, and that room's content sits next to the sealed Reveal. Keep it out of anything walker-facing outside room 33.
21. **The walk-build order is locked:** Shell → 1–2 → 3–5 → 6–8 → 9 + pulse → body → mind → summit → Lalita authored last. Each slice is walked by Ashrey before the next is crafted. Nothing in this corpus jumps that order except the legacy pages.

