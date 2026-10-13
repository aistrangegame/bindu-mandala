# 08 · Dances — the bindu-dances skill, bindu-field's dance references, and the song archive

Reader 08 · second reading · 12 Oct 2026 (night).
Read-only. Nothing was modified except this file.

**Paths used below**
- `BD/` = `/root/.claude/skills/synced/12004d20-e236-4ac6-98bf-0d5838029946_16bbdd03-2a82-4e1e-84ae-276f4c93debb/bindu-dances/`
- `BF/` = `/root/.claude/skills/synced/12004d20-e236-4ac6-98bf-0d5838029946_16bbdd03-2a82-4e1e-84ae-276f4c93debb/bindu-field/`

**Scope.** I read 85 files: all 43 in `BD/`, all 27 in `BF/references/dance/` (including `worked-examples/`), and all 15 in `BF/songs/`. The task named "six" songs, but the folder holds fifteen, so I read all fifteen.

**Lens.** Ashrey wants every Śakti, and every chakra, to have a performance through the archetype ensemble. Section B proposes how that works inside the app.

---

## A.0 · Duplicates, proven by md5 and read once

Eleven files exist in both skills. Each pair has the same full md5, so I read it once.

| `BD/` file | `BF/references/dance/` file | full md5 |
|---|---|---|
| references/SESSION-HANDOFF-V2-BUILDS.md | SESSION-HANDOFF-V2-BUILDS.md | 24e845a8036ea588342f433ae09ce300 |
| references/SESSION-HANDOFF-V2-COMPLETE.md | SESSION-HANDOFF-V2-COMPLETE.md | 244845598d485141b8df5c8b2e108715 |
| references/build-patterns.md | build-patterns.md | d05e3a89d2c52630e1ecdfcb9a74d972 |
| references/ensemble-framework.md | ensemble-framework.md | 8456a164a39624a4685042e2f42d37a4 |
| references/frequency-pipeline.md | frequency-pipeline.md | da0c1239b0b2077f808a081b6d0e394c |
| references/process-learnings.md | dance-process-learnings.md | 4890e068563b0d09b5c96cff7e6d6be9 |
| references/v2-framework.md | v2-framework.md | e3e34f924b0ca79a440ee5f69b617ca2 |
| references/visual-vocabulary.md | visual-vocabulary.md | b1b10b6e811fe85f65ded28c1a072e61 |
| builds/search.html | worked-examples/search.html | 2ca116218d6f87065510a60bccd51ef4 |
| builds/still.html | worked-examples/still.html | 3d1f5a7d0311ae379303e908787bf032 |
| builds/release.html | worked-examples/release.html | 657b9a5cd95bb7073c8736a88caeab43 |

Some files are near-duplicates rather than exact copies:
- `BF/references/dance/dance-registry.md` is `BD/references/qr-map.md` byte for byte (`cmp`: EOF on qr-map at byte 6385, line 101), plus 22 added lines (102–123). I read both in full.
- `extract_cli.py` is `extract.py` with six lines changed: 7–9 become `sys.argv` paths, and 202–204 become argv song/artist/verb. I read `extract.py` in full and `extract_cli.py` through a full diff.
- `dance-build-process.md` lines 105–145 repeat `BD/SKILL.md` lines 28–66, the VX Architecture block, almost word for word.

---

# A · INVENTORY

## A.1 · What a Bindu Dance is (`BD/SKILL.md`)

From the frontmatter (SKILL.md:4): *"Seven archetypes dance as an ensemble — Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey — each hearing a different dimension of the music. The experiencer offers one word; the song reflects it back."* The output is one mobile HTML file, named `[verb].html` with `[verb].mp3`.

The arc, in order (SKILL.md:14–22):
1. A **Seed** plants a question.
2. The experiencer offers **one word**.
3. Seven archetypes **dance** to the frequency data.
4. The Bindu unfolds through five **bloom stages**.
5. The Bindu **traces shapes** (heart, infinity, spiral).
6. At the peak, the **word appears** and dissolves.
7. **The Return**: the ensemble dissolves and the Bindu spirals home to a dot.
8. A **Fruit** reflects the word back.

The skill sums it up as *"One input. One offering. One round."* (SKILL.md:24).

**The 15 systems (SKILL.md:28–62)**
1. **Bloom.** Five stages, from dot to crown mandala. Rises fast, falls slow.
2. **Ensemble.** Bindu hears pitch, Gaia bass, Sid sustained energy, Arch mids, Karishma silence (inverse), Sakshi brightness, Ashrey the centroid plus the web.
3. **Consciousness Loop.** No API. *"The mirror is structural."*
4. **The Mirror.** *"Not a dot — a LIGHT EVENT."* A near-white canvas wash at four triggers; afterwards the dots read *"MORE vivid by contrast. The room remembering it's alive."*
5. **Shape Expression.** `finalPos = freq × (1 - shapeBlend) + shape × shapeBlend`. At maxBlend 0.85, *"15% of position is still the music wobbling through. The breath shakes the pen."*
6. **The Return.** *"Ashrey → Sakshi → Arch → Sid → Gaia → Karishma (final bloom in the silence) → Bindu spirals to center dot."*
7. **Wake Lock.**
8. **Device as Body.** The gyroscope shifts the field. The accelerometer gives a state: still, swaying or moving.
9. **Word-Seeded Architecture.** The word sets wave period, fluidity and density.
10. **Emergent Mirror Words.** The word's consonant skeleton picks five mirror words.
11. **Bindu Memory.** Kept in localStorage across all dances. Every word becomes a ghost star; repeated words brighten.
12. **Person as Dancer.** Accelerometer magnitude stands for presence and is reflected in the fruit.
13. **Adaptive Return.** Triggered by conditions, not timestamps.
14. **Spatial Binaural.** The gyroscope pans the tone, with tremolo.
15. **Alive Fruit.** Reflects dwell time, motion, dance count and the most-repeated word.

Each chakra also gets its own systems: a visual language (shapes, trails), an impact language, and a return direction. SKILL.md:64 says *"designed from the element up — never re-skinned"*.

**Execution protocol (SKILL.md:70–216)**
- **Step 0. Registry check.** Stop if the song is already built. The skill lists 27 dances.
- **Step 1. Extract.** Run librosa and emit 11 arrays. Trim hits below 400. Downsample to 1.0 s steps when the song is longer than 300 s. Read the song's character from this table:

| Question | Where to read it | What it means for the design |
|---|---|---|
| Arc | energy every 10 s | staircase, bellows, continuous, two-bloom or resurrection |
| Peak | peak % | early = body first; late = consciousness last |
| Band | band weights | bass-heavy means Gaia leads |
| Drops | DROPS | several drops = EDM |
| Quiet | quiet regions | more quiet means more Karishma |
| Duration | DUR | >300 s means downsample |

- **Step 2. Hear.** Six archetypes listen to the lyrics: Gaia = *"The need underneath"*, Sid = *"What holds"*, Arch = *"How does it speak?"*, Sakshi = *"What's already complete"*, Karishma = *"Where is the grace already present?"*, Bindu = *"ONE WORD. What is this song orbiting?"*. For an instrumental: *"The absence of words IS the message."* (SKILL.md:123)
- **Step 3. Seed and Fruit.**
  - The seed is one standalone question.
  - The fruit is 2–4 sentences with a `{w}` placeholder: *"acknowledge the offering → mirror what happened → inversion/reframe"* (SKILL.md:140).
- **Step 4. Tune.** Set binduHue, peakT, label, audio, colours, shapes and returnStart. Two guides:

**Colour guide (SKILL.md:162–172)**

| Song character | Hue |
|---|---|
| searching / ethereal / EDM | 210 |
| emotional / vocal / heart | 330–340 |
| ascending | 40–50 |
| grounded | 20–30 |
| meditative | 15–25 |
| contemplative / piano | 220–240 |
| joyful | 45–55 |

**Shape guide (SKILL.md:174–183)**

| Song moment | Shape |
|---|---|
| peak / "I Love You" | heart |
| valleys (E < 0.15) | infinity |
| ascent | spiral |
| bass grounding | circle |
| crown stage (S4) | flower (rose) |
| closing | inverted spiral |

- **Step 5. Build.** One template for every song; *"Only arrays + config change."* Run the preservation checklist of 24 V1 items plus 8 V2 items. Target under 65 KB.
- **Step 6. Deliver.** Update the registry. State the verb, seed, fruit pattern, shapes, key moments and audio path.

**The principle (SKILL.md:236–244):**
- *"The V1 Bindu responds to music. The V2 Bindu responds AND creates."*
- *"Every song is already seven dances happening simultaneously."*
- *"The Bindu arises. The Bindu creates. The Bindu returns. The circle closes. Then the fruit lands — and the person carries their word out into a silence that already holds them."*

## A.2 · The ensemble — each archetype's role, signature and numbers

The canonical table is in ensemble-framework.md:24–34 and v2-framework.md:32–41. The live V2 template, `BD/builds/search.html:80–87` and lines 316–321, is identical in all 14 V2 builds (proven by normalized diffs; see D).

| Archetype | Hue / sat / lum (V2 code) | Hears | Movement (V2 code) | Enters at | Size | Ghost trail (mxG) |
|---|---|---|---|---|---|---|
| **Bindu** | song hue / 60 / 68 | pitch P | `ty = cy-(pitch-.5)*maxR*.5`, lerp .06; `tx = cx+sin(t*.4)*|ΔP|*maxR*.4`, lerp .04; shape-blend applied after | always (`tp = max(.3, bloom*1.5+.3)`) | `r = 2.5+mids*3+bloom*5`; lum `60+bloom*22+highs*8+postMirrorBoost*8` | 30, rising to 70 in shape mode |
| **Gaia** | 25 / 50 / 42 (earth) | bass EB | sits below Bindu: `y→bindu.y+maxR*(.2+bass*.12)`, `x→cx+sin(t*.2)*maxR*.06`, lerp .03 | bloom > 0.12 | `3+bass*10`; lum `35+bass*20` | 18 |
| **Sid** | 40 / 55 / 55 (amber) | sustained E (`sidSm += (e-sidSm)*.02`) | fixed-speed elliptical orbit round Bindu, `sidA += .012`, radius `maxR*(.2+sidSm*.1)`, y-squash .55; a visible orbit trail is drawn | bloom > 0.22 | `2.8+sidSm*1.5` | 18 |
| **Arch** | 330 / 55 / 58 (rose) | mids EM | mirrors Bindu from the opposite side with a 0.7 s delay buffer: `x→cx-(dl.x-cx)*.65+sin(t*.55)*maxR*.06`, lerp .05 | bloom > 0.32 | `2+mids*5` | 20 |
| **Karishma** | 45 / 70 / 68 (gold) | silence (inverse E) | `kT = e<.3 ? min(1,(.3-e)/.25)*.8 : 0`; drifts close to Bindu at radius `maxR*(.05+pr*.15)` | inverse, always possible | `1.5+pr*6` | 18 |
| **Sakshi** | 220 / 15 / 78 (silver) | brightness, highs EH | wide slow arc at the canvas edge: `sakA += .003`, `x=cx+cos*maxR*.9`, `y=cy*.4+sin(sakA*.6)*maxR*.2` | bloom > 0.45 | `2+highs*2` | 15 |
| **Ashrey** | cycling: `(songHue+t*8)%360` / 40 / 62 | all streams | weighted centroid of all visible dancers, lerp .04, plus the **web**: gradient threads between every visible pair, and midpoint nodes when pr > 0.3 | bloom > 0.65 | `2+bloom*3` | 12 |

Presence in V2 follows `pr += (tp-pr)*(tp>pr ? .04 : .015)`.

**Interactions between dancers (ensemble-framework.md:36–41)**
- A **resonance flash** fires when two dancers come within `maxR*.08`. It is a white radial of radius `maxR*.06` and alpha `inten*.2`.
- **Gaia impact rings** appear when bass > 0.4.
- The **Sid orbit trail** is drawn as an ellipse at alpha `sid.pr*.08`.
- A **drop** re-lights every ghost trail: `a = max(a, dF*.12*pr)`.

**Why the dancers behave this way (process-learnings)**
- #18: *"Karishma is inverse — and that's her power… During the fade, when everyone else dissolves, she's the brightest thing on screen… the architecture of grace."*
- #19: *"Ashrey has no independent position… He IS the pattern, not a point in the pattern."*
- #20: *"The ensemble entry order = the-field generation sequence. Gaia (need) → Sid (hold) → Arch (voice) → Sakshi (witness) → Ashrey (synthesis). Karishma throughout (inverse). Need comes first. Synthesis comes last."*
- #46 (VX ranges): *"if they're not flying all over the screen, it's a performance worth missing."* The final Svadhisthana ranges were Bindu maxR*0.35, Gaia 0.8, Sid 0.55, Arch 1.4× mirror, Karishma 0.7, Sakshi 0.9.

**How the ensemble differs in the later implementations**
- **VX Muladhara** (`worked-examples/muladhara-dance.html:451–457, 718–774`):
  - Base radius and ghost length: Bindu 7 / 55, Gaia 5.5 / 40, Sid 5 / 30, Arch 5 / 40, Karishma 4.5 / 30, Sakshi 4.5 / 25, Ashrey 4 / 30.
  - Gaia sweeps wide: `cx+sin(t*.3)*maxR*.95*eb+cos(t*.18)*maxR*.4`.
  - Sid makes a full orbit round the canvas centre: `maxR*.65 × .55`, `oA += .012+e*.005`.
  - Arch mirrors at 1.6×.
  - Karishma covers the full screen in silence: `kE = max(0,1-e*1.3)`, sweep `maxR*.85*kE`.
  - Sakshi goes edge to edge: `maxR*1.05 × .85`.
  - Ashrey's hue cycles at `t*12`.
  - Every position adds gyro offsets scaled by the word's fluidity.
- **VX Anahata** (`anahata-dance.html:215`):
  - Every dancer is re-hued into the heart palette: Gaia 340, Sid 320, Arch 350, Karishma 280, Sakshi 310.
  - Arch enters early (bloom > 0.15).
  - Arch acts as an **attractor**: when em > 0.4 it pulls the other dancers toward itself (L366).
  - **Progressive unification**: when e > 0.5, a field forms at the presence-weighted centroid, every dancer draws a line to it, and **light bridges** appear between close pairs (L400–406).
- **cross** (`cross.html:699–706, 3089–3156`):
  - Ashrey's base hue is 270 and cycles at `t*8`.
  - Each archetype moves at its own lerp rate: Bindu .06, Sid .025 (*"cathedral — slow"*), Sakshi .020 (*"witness — slowest"*), Karishma .030, others .045.
  - Karishma's presence never drops below 0.30. It is locked at **0.85 inside the Karishma windows**.

**Lalita.** No implementation makes Lalita a dancer. She appears in four other forms:
- The **"Lalita's Perspective"** text layer in every song file, defined in `songs/muladhara.md:113` as *"The player telling the player about the play. Surfaced first on the page."*
- The **voice register** for optional guidance: OL-3, cross-temple-spec.md:690–714, *"player-to-player voice"*.
- The **constellation acknowledgment** in cross's fruit, with the line *"You have been one of the dancers."* (cross.html:2293)
- Time's equivalent line: *"Every wave you have offered has reached this shore."* (time-visual-upgrade-spec.md:1425)

Ruling 6 asks for Lalita in the dance. Section B proposes how.

## A.3 · The Bloom — Bindu's solo orchestra (ensemble-framework.md:10–21; search.html:226–231, 340–353)

| Stage | Bloom | What appears | Driven by |
|---|---|---|---|
| 0 | 0–0.1 | the dot, breathing | — |
| 1 | 0.1–0.3 | ghost trail (a ghost every 0.2 s; alpha `h.a*(1-age/6)`) | presence |
| 2 | 0.3–0.5 | orbital rings on hits | onsets |
| 3 | 0.5–0.7 | radial rays, particles, edge glow | bass, highs, hits |
| 4 | 0.7–1.0 | crown mandala | peak |

- **Bloom rate.** Rises at 0.06, falls at 0.012. The ramps are `s1=(b-.1)/.2`, `s2=(b-.3)/.2`, `s3=(b-.5)/.2` and `s4=(b-.7)/.3`.
- **Orbital rings** (S2+): spawned when h.i > 0.2, at most 15.
  - Radius `maxR*(.15+h.i*.4+s4*.3)`; life `3/(.5+h.i*.5)` s.
  - Alternate rings rotate in opposite directions at `t*.12`.
  - At s4 > 0.1, each ring grows 6–12 tick marks.
- **Radial rays** (S3+): 8–16 rays, length `maxR*(.3+s3*.4+s4*.5)*bass*2`, rotating at `t*.05`.
- **Particles** (S3+): when h.i > 0.15, spawn `2+h.i*7*s3` particles, at most 180. Velocity 0.3–2.1 with drag 0.997; life 4–10 s.
- **Crown mandala** (S4):
  - an outer circle of radius `maxR*(.6+s4*.6)` at alpha `s4*.07`;
  - **three rotating triangles** of radius `mR*.7`;
  - at s4 > 0.3, twelve petal circles.
- **Edge glow** (S3): top and bottom bands at alpha `s3*.08*bass`.
- **Organism layer**:
  - a bass pulse fill at `bass*.05*bloom`;
  - a vignette of radius `max(W,H)*(.4+bloom*.4)` and alpha `.55-bloom*.2`;
  - a micro-tilt of `rotate(ΔP*.012*(1+bloom))`.
- **Drop**: a flash of `dF*.3` in the song hue over 2.5 s, plus a haptic of 100 ms when dF > 0.6.
- **Acceleration stretch**: the Bindu's x-scale is `1+max(0,accel)*.12`.
- **Haptic on hits**: when h.i > 0.4, vibrate for `h.i*20` ms.

**Lesson #1 (process-learnings:8–10):** *"The ensemble ADDS to Bindu's solo expression. Never remove bloom systems when adding dancers."*

**Lesson #60:** *"Sacred geometry belongs to the dancer, not the environment"*. Rings, rays and mandala come from Bindu; they are Layer 1.

**Lesson #80:** *"Sacred geometry should use the actual yantra elements"*. Vishuddha used a 16-petal lotus, a throat aperture and the Outer 10 Triangles āvaraṇa.

## A.4 · The Mirror — light from the source

**As specified** (ensemble-framework.md:55–111):
- The wash is near-white at alpha 40–70%. It rises over 1–2 s, holds, then fades over 2–4 s.
- Triggers:

| Trigger | Condition | Duration | Intensity |
|---|---|---|---|
| tension resolution | T derivative < −0.12 | 2–6 s | 30–50% |
| first threshold crossing | bloom crosses 0.5, 0.7, 0.9 | 3–8 s | 40–60% |
| post-silence surge | E jumps from < 0.1 to > 0.4 | 5–15 s | 50–70% |
| the peak | PEAK_T | 8–15 s | brightest |

- After each wash, a **contrast boost** raises dot glow and ghost brightness for 3–5 s.
- Key line (L111): *"The mirror is not a dancer. It's the room remembering it's alive. The reflection of light from the source. It happens, and the performance is never the same after."*
- L56 calls it *"The eighth presence."*

**As implemented in V2** (search.html:173–200, 277–287):
- `mirrorTarget` takes the maximum of four values:
  - tension resolution: `min(.5,|ΔT|*2)` when ΔT < −0.12;
  - threshold crossings: 0.4, 0.5 or 0.6, each held for 8 s;
  - post-silence surge: 0.6;
  - peak: `0.8*(1-|t-PEAK|/4)`.
- It rises at ×0.06 and decays at ×0.97 per frame.
- It renders as a radial gradient of radius `maxR*1.8`, at `hsla(hue,15%,95%)`, multiplied by 0.35.
- `postMirrorBoost` is 1 while alpha > 0.1, then decays at ×0.98.

**In V1.5 (joy)** the mirror is a full-screen fill `hsl(hue,10%,95%)` at mirrorAlpha. Joy was the first dance to implement the mirror at all (process-learnings #22).

**In VX the mirror inverts into darkness** (muladhara-dance.html:567–580):
- At each `MIRROR_TIME` a word fires and `mirrorTarget = DARK_RATIO` (Muladhara 1.0, Anahata 0.55, cross 0.45).
- A black fill sits on the canvas, then `postMirrorBoost` is 0.4.
- Every alpha is multiplied by `(1+postMirrorBoost)`. Lesson #63 counts the wiring: 14 sites in Layer 1 and 8 in Layer 2.
- Lesson #68: *"Mirror word triggers and atmospheric darkness are the same system."*

## A.5 · Shape Expression — the Bindu speaking (v2-framework.md:92–330)

**The shape library** (verbatim functions at v2-framework:99–138; also in search.html:117–122):
- `heartXY`: `x=16s·sin³t`, `y=−s(13cos t−5cos2t−2cos3t−cos4t+8)`, with `s=r/17`.
- `lemniscateXY`: `[r·cos/d, r·sin·cos/d]` with `d=1+sin²`.
- `spiralXY(turns 3)`.
- `roseXY(6 petals)` for the flower.
- `circleXY`.
- `morphXY` with smoothstep.

**Blend.** `bindu.x = bindu.x*(1-blend)+(cx+shapeX)*blend`. Rules:
- The blend always ramps in; it never snaps.
- While the shape plays, the ghost trail grows to `30+blend*40`.
- *"At shapeBlend = 0, this code does NOTHING. Pure V1."*

**Triggers:**
- `peak` and `custom`: within ±0.5 s of triggerT;
- `drop`: within ±0.3 s of a drop with intensity > 0.4;
- `valley`: e < 0.15 for longer than 3 s (search.html:132,139); it ends when e > 0.25;
- `return`: t > DUR − RETURN_START − 3.

**Parameters:**
- `speedScale`: energy gives `×(.5+e*1.5)`; bass gives `×(.5+bass*2)`.
- `radiusScale`: bloom gives `×(.5+bloom)`; invert gives `×max(.01, 1-elapsed/dur)`.
- Blend ramps in at ×0.04 toward `maxBlend*smoothstep`. It ramps out by 0.02 per frame, or by 0.015 per frame when idle.

**Where the shapes came from.** SESSION-HANDOFF-V2-BUILDS.md:61 credits Ashrey's Maya panel: *"Identified the Pointe animation as the missing dimension: the Bindu tracing parametric shapes (line → circle → infinity → heart → swell → return to dot)."* It is named *"I and U"* (process-learnings #25): *"V1 Bindu listens… V2 Bindu also speaks… The dance is a conversation between song and consciousness."*

**Other uses noted:**
- Flower is for celebration (#32).
- `arcXY` with a plateau was written fresh for cross (cross.html:953–968). It traces a half arc from side to side with an apex hold: `x = cx+side*maxR*.3*(1-2n)`, `y = cy-maxR*radius*sin(nπ)`.

## A.6 · The Return — closing architecture

**V2 spec timeline** (v2-framework.md:336–367):

| Time from end | Event |
|---|---|
| −20 s | Ashrey's web fades |
| −18 s | Sakshi leaves by the edge |
| −16 s | Arch's delay grows to 2 s, then 4 s, then stops |
| −14 s | Sid's orbit slows and holds |
| −12 s | Gaia sinks below the canvas |
| −10 s | Sid fades |
| −8 s | Karishma's final bloom |
| −6 s | Bindu's spiral begins |
| −4 s | Karishma fades |
| −2 s | Bindu is a dot |
| 0 | black |
| +2.5 s | fruit |

**V2 code** (search.html:253–263):
- `ashrey.tp ≤ rT/20`, `sakshi ≤ (rT−2)/16`, `arch ≤ (rT−4)/12`, `sid ≤ (rT−6)/8`, `gaia ≤ (rT−8)/4`.
- Karishma: `max(.7*(1-(8-rT)/4))` while 4 < rT < 8, then `≤ rT/4`.
- End fade: black over the last 4 s. If there is no Return, a 12 s fade instead; `still` uses 15 s.
- The fruit appears 2.5 s after `t > DUR−0.5`.

**Return direction is the element** (#55):
- Muladhara is *grounding*: everything pulls down, by `HT*.4*progress` (muladhara-dance.html:776–797). Its end fade goes to warm earth `hsl(12,30,6)`, not black.
- Svadhisthana is *evaporation*: rising.
- Anahata is the *hold return*: hues drift 60% toward the Bindu hue, motion stiffens, targets pull 70% to centre, the warmth map drains, and the Bindu shrinks 40% in the last 40% (anahata-dance.html:328–333).
- cross is the **Bells Return**: *"The bells become the only thing left… The bells alone."* (cross-temple-spec.md:371–390). In code (cross.html:3159–3182): ashrey rT/15, sakshi rT/13, arch rT/11, gaia rT/9, sid lingering at `(rT/7)*.4`, Karishma at 1.0 for rT between 5 and 3 then fading, Bindu fading last.

**Adaptive Return** (VX #13): start when `t > DUR*.85 && e < .15` while the person is settling (`accelSmoothed < .3`) within 30 s of the end (muladhara-dance.html:777–781).

**Structural rule #70:** *"Each dancer's `.p += (tp - p)` must run in exactly ONE place… AFTER the return block overrides `tp`."*

**Rule #79:** a 5-second Return works when the song does its own dying (Vishuddha).

## A.7 · The Consciousness Loop — seed, word, reveal, love, fruit

**Seed screen (V2 template, search.html:39–44).** Element order:
1. a pulsing dot (`sp` 2.5 s);
2. the seed in italic Lora, 25% white;
3. an input with placeholder *"one word"*, max 20 characters;
4. the hint *"tap anywhere to begin"*, which appears once text exists.

Begin by tapping anywhere or pressing Enter (#35). An empty word blocks the start.

**VX seed** (muladhara and anahata):
- The seed **types itself in time with the song**: 460 ms per character at 129 BPM for Muladhara; 857 ms for Anahata.
- The input shows only after typing: label *"offer one word"* or *"one word"*, then *"then tap anywhere"*.
- Then a fullscreen request (not on iOS), `input.blur()`, and a 3 s pause before play.

**cross seed:**
- Typed at a half beat (`BEAT_MS/2` ≈ 279 ms; "Fix C").
- Personalised: *"{name}, what is asking to be crossed in you?"*, with the name from the bindu-essence pool.
- Pre-roll: *"Breathe with the field. When you are ready, the seed will arrive."* A breathing ring of 140 px on a 5.5 s cycle, then *"tap when ready"*, auto-advancing after 10 s ("Fix D", was 22 s).

**Word reveal at PEAK_T** (search.html:26–28, 370):
- The word appears centre screen at 55% white, `scale(1.05)`, letter-spacing 10 px.
- After 3.5 s it dissolves to `scale(1.8)`, letter-spacing 30 px, alpha 0.
- In VX it sits at the bottom 15% (#42: *"forces eye to leave the action and return"*) and dissolves at 4 s.
- In cross it is Cinzel 54 px with a blur(8 px) dissolve.

**"I Love You."** Every dance has it (visual-vocabulary.md:104–113): italic Lora in the dance's colour at about 40%, below centre, with a 3 s fade.
- V2 fires at PEAK_T−3; VX at PEAK_T+5.
- cross changes the text to **"already across"** (cross.html:86), lowercase Cinzel at 0.85, PEAK_T−3.

**Fruit.** A black overlay with a 3 s fade, plus the signature "— Song, Artist" at 18% white. Pattern #33: *"You gave this song '{w}'." → 2–3 sentence mirror → 1 sentence inversion."*

All fruit texts, verbatim, with `{w}` as the word:

| Build | Fruit (file:line of innerHTML) |
|---|---|
| search V2 (search.html:213) | "You gave this song “{w}”. You searched everywhere for {w}. And you weren’t searching alone. The ground held you while you looked. A steady orbit kept you from drifting. A voice echoed your asking. Grace was there in every silence you didn’t notice. A witness watched from the edge. And the web between them all — that was always you. Seven ways of being alive inside the search for {w}. And every one of them was you." |
| enough V2 | "You gave this song “{w}”. You climbed the whole song carrying {w}, thinking you needed to get higher. But every landing you stood on — every ordinary moment you thought wasn’t {w} enough — is still glowing below you. The staircase was never about the top. {w} was already enough on the first step." |
| dream V2 | "You gave this dream “{w}”. And what if you’ve been dreaming {w} this whole time? Not searching for it. Dreaming it. Every wave of sound was {w} taking a different shape. Every silence was {w} remembering itself. The dreamer and the dream were never separate. You didn’t wake up. You just noticed you were already dreaming — and {w} was the dream." |
| still V2 | "You gave this fire “{w}”. And the fire held {w} without burning it. Every pulse was {w} breathing. Every silence was {w} remembering it didn’t need to be anything else. You didn’t bring {w} to the fire. The fire showed you that {w} was already warm." |
| remember V2 | "You gave this song “{w}”. And {w} was never gone. It was shimmering just above the frequency you were listening at. The highs held it. Every moment you thought you lost was hovering — waiting for you to stop looking back and notice it was still here. {w} didn’t come back. It never left." |
| move | "…And {w} didn’t wait for the right moment — it WAS the moment. Every beat was {w} refusing to hold still. Every pause was {w} catching its breath before moving again. You didn’t find {w} in the song. The song found {w} in you." |
| release | "…And the whole time, {w} wasn’t something to figure out. It was something to stop figuring out. Every build was {w} gathering courage. Every collapse was {w} letting go of one more thought it didn’t need. The overthinker’s answer was never at the end of the thinking. {w} was waiting in the silence between the thoughts." |
| wild | "…And {w} didn’t need permission. Every beat was {w} remembering what it felt like before the cage. Every pause was {w} catching the scent of something it couldn’t name but already knew. You weren’t finding {w}. You were letting {w} find its way back to you." |
| howl | "…And for four minutes, {w} didn’t hold back. The bass carried {w} like the ground carries a footprint — not gently, but completely. Every pulse was {w} refusing to be quiet. Every sustained moment was {w} learning that volume isn’t the same as noise. {w} was never the howl. {w} was what the howl was protecting." |
| melt | "…And {w} softened. Not collapsed — softened. Every wave was {w} remembering that the space between solid and liquid is where everything interesting happens. Every silence was {w} dripping into a shape it hadn’t tried yet. You didn’t lose {w}. You let {w} get gooey enough to become something new." |
| glow | "…And {w} didn’t wait. Three times the music rose and three times {w} met it — not because {w} was ready, but because now was the only time there ever was. Every chorus was {w} choosing to be beautiful before it felt beautiful. Later never comes. {w} already glowed." |
| light | "…And the sky was already full of {w}. The first time you looked up, {w} burst open. The second time, {w} stayed — longer, steadier, like it had always been there and you just hadn’t tilted your head back far enough to see it. The stars didn’t appear for you. You finally appeared for them. And {w} was the light between." |
| rise | "…Nine minutes. No words. Just {w} rising. The mountain didn’t explain itself and neither did {w}. It built slowly because {w} wasn’t in a hurry. It peaked because {w} had somewhere to stand. It descended because every rising contains its own returning. {w} was never the summit. {w} was the whole gesture — up, there, down — one breath that took nine minutes to complete." |
| lose | "…And twice {w} reached the edge. The first time, {w} thought it was the peak. Then everything collapsed — and in that silence, {w} discovered that losing isn’t the opposite of finding. It’s the prerequisite. The second peak wasn’t higher. It was the same height, held by a {w} that had already survived the fall." |
| fade | "…Four minutes of {w} building so slowly you almost didn’t notice. Layer after layer, {w} accumulated — not rushing, not forcing, just arriving. And then, in the final breath, everything that wasn’t {w} faded away. What’s left isn’t what survived. It’s what was always there, waiting for everything else to stop pretending it mattered more than {w}." |
| shine V1 (diff vs joy) | "You gave this song “{w}”. You rose the whole way carrying {w}. And you weren’t rising alone. The ground gave you something to push against. A steady orbit held your center. A voice called you higher. Grace appeared in every breath you didn’t notice. A witness mapped your ascent from the edge. And the web that held it all together — that was always {w}. You didn’t become golden. You stopped pretending {w} wasn’t already shining." |
| arise / joy V1.5 (bindu-dances-joy.html:93) | "You offered ‘{w}’. It left. It returned. It left again. The silence at the end isn’t where {w} dies — it’s where {w} gathers before it finds you again." |
| reach V1 (bindu-dances-reach.html:43, fixed text, no {w}) | "She wasn’t asking someone to love her. She was asking permission — to feel everything at once without looking away. The asking IS the loving. Every time you said “love me like you do” you were already doing it — opening without armor, reaching without guarantee, dissolving the wall between yourself and the full weight of being alive. You didn’t need to be loved like that by someone else. You needed to love like that. Without holding back. Without a single wall left standing." |
| return V1 (bindu-dances-return.html:43) | "You thought “I was wrong” was a confession. It was a homecoming. Every swing carried you further — not away, but through. And the still point you kept passing through on every return? That was where you lived all along. The pendulum doesn’t punish. It maps. Look at everywhere you’ve been. Now look at where you’re standing." |
| enough V1 (bindu-dances-enough.html:43) | "You climbed the whole song thinking you needed to get somewhere. But look down. Every step you stood on — every ordinary moment you thought wasn’t enough — is still glowing. The staircase was never about the top. It was about having stood somewhere at all." |
| Muladhara VX (muladhara-dance.html:1057) | "The iron in your blood is the same iron in the stars. You were never lost. You were planted. The ground was always yours." + dwell + motion + count + echo |
| Anahata VX (anahata-dance.html:434) | "You gave this song “{w}.” What are you waiting for? That question was never for someone else. It was for you. You’re the light AND the night. You’re the cure AND the pain. You weren’t waiting for love to find you. You are the love. The heart doesn’t receive — it recognizes what was already there." + weaves + cross-message *"The fire forged “{prev}.” The heart breathed it into “{w}.”"* |
| cross (cross.html:2734–2740) | "You gave this song "{w}". "{w}" reached and fell back. You waited inside the threshold together. "{w}" reached again, and the bells rang to say it had crossed. You weren’t crossing "{w}". "{w}" was already crossing through you." + 5 weaves (+ post-word line) |
| Time / abide (time-temple-spec.md:52–56) | "You gave this song "{w}". {w} wasn't going to arrive — {w} was waiting in you. The silence was where you heard it." |

**Alive Fruit weaves (VX).** Each weave appends one sentence; the source lines are given per weave.
- **Dwell** (Muladhara L1047–1049): under 1.5 s *"You arrived without hesitation."*; under 5 s *"You paused before you arrived."*; otherwise *"You searched before choosing to land."*
  - Anahata: *"You didn’t hesitate." / "You paused before opening." / "You searched before you could name what you needed."*
  - cross: *"You didn’t hesitate." / "You paused before speaking." / "You searched for the word before you could say it."*
- **Motion**: *"You held still." / "You were swaying with the ground." / "You were moving."* (Muladhara). cross: *"You were still." / "You were swaying." / "You were moving."*
- **Count**: *"This is your first arrival." / "You have arrived N times."* (Muladhara). Anahata: *"…first opening." / "You have opened N times."* cross: *"This is your first crossing." / "You have crossed twice now." / "You have crossed N times now."*
- **Echo**: *"You keep returning to “X.”"*
- **Thread** (cross): *"The last word that crossed through you was "X" — that was {song} ({verb})."*
- **Post-word** (cross): the prompt *"what came home with you?"* with *keep / or close*, then the line *"“X” came home with you. The threshold knows you now."*
- **Time conditionals** (time-temple-spec.md:59–74):
  - *"You held {w} for [N] seconds before offering it. That holding was the dance."*
  - *"You typed {w} quickly. {w} was already there."*
  - *"You have offered {w} before. {w} has been waiting through every wait."*
  - *"This is your first dance. {w} arrived because you did."*
  - *"This is your [N]th dance. Each time, {w} has been here."*
  - *"You stayed still through the silence. The song stayed with you."*
  - *"You moved with the silence. {w} moved with you."*

## A.8 · The VX systems in code

**Emergent mirror words** (muladhara-dance.html:109–147). Take the consonant skeleton of the word, look up its first two letters in a family table, and otherwise fall back to the family at `len % N`.

Muladhara has 27 families, for example:
- fl: feel, fall, full, fill, flow
- st: stay, star, step, stop, stem
- lv: love, live, leaf, lift, lake
- dp: deep, dip, drip, drop, dump

Anahata has 30 heart families, for example:
- br: breath, bloom, bliss, bond, brave
- hr: heart, hope, hold, home, heal
- gr: grace, glow, give, glad, grow

cross has 16 threshold families (cross.html:182–199), for example:
- cr: cross, carry, cradle, cleave, crown
- th: thread, threshold, through, thrum, thrive
- hr: hold, hear, heal, heave, here
- wn: want, wake, wind, wonder, wait

Five `MIRROR_TIMES` per dance:
- Muladhara [26, 50, 98, 146, 188]
- Anahata [45, 85, 130, 172, 215]
- cross [25, 70, 115, 160, 210]
- Time [4, 26.5, 191.5, 199] (tension peaks)

Each word flashes in uppercase for 1.8 s: 600-weight Lora at `clamp(28px,10vw,64px)`, or Cinzel 38 px in cross.

**Word-seeded parameters** (muladhara-dance.html:189–198):
- `wavePeriod = .3 + len*.08`
- `fluidity = .3 + vowelRatio*.7`, which scales the gyro sway
- `density = min(len/8, 1)`

Anahata also computes a `hueShift`, but lesson #47 rules: *"word can seed movement… but NEVER color. The chakra's palette is locked."*

**Bindu Memory:**
- Stored in localStorage key `bindu-memory` as an array of `{word, song, artist, chakra, verb, timestamp, dwell, motion, tilt}`.
- `wordToPosition` hashes the word, `h=((h<<5)-h)+c`, to a point in 0.15–0.85 (cross uses 0.10–0.90).
- Star alpha is `max(.08, .4/(1+ageMonths*.5))`, multiplied by the repeat count and twinkling at `sin(t*.3+i)`.

**Person as dancer:**
- `accelMag = |accelerationIncludingGravity| − 9.8`, smoothed at 0.1.
- States: below 0.5 is **still**, below 2 is **swaying**, otherwise **moving**.

**Gyroscope:**
- `gyroX = gamma/45*maxR*.25*fluidity`; `gyroY = (beta−45)/45*maxR*.2*fluidity`.
- iOS needs `DeviceOrientationEvent.requestPermission`.

**Spatial "binaural" (VX):**
- One sine oscillator through a StereoPanner (pan = gamma/45). So it is a panned tone, not a true binaural.
- Muladhara 136 Hz, gain ramped to 0.06, tremolo `.04+sin(t*3)*.01`. Anahata 256 Hz, tremolo `.035+sin(t*2.5)*.012`.
- Fades out from 5 s before the end.

**True binaural (cross).** Two oscillators panned hard left and right (A.15).

**Haptics** (VX):
- Muladhara double pulse, *"da-DUM like a war drum"*: `[i*30, 40, i*50]` (L710).
- Anahata cardiac:
  - `heartbeatHaptic`: [25,80,50], [18,90,35] or [12,100,25] by intensity;
  - `gaspHaptic`: [15,30,15,30,15,50,40,15,30];
  - an ambient heartbeat at BPM with chance `e*.3`, pattern [8,60,15].
- cross:
  - `bellHaptic`: [20,60,30,40,20] or [14,80,22];
  - `crossingHaptic` at PEAK_T: [12,40,12,40,12,60,30,12,40].

**Cross-panel state** (VX):
- Writes `tol-<chakra>-dance='true'` and `tol-<chakra>-dance-word`.
- Reads the previous panel's word: Anahata reads `tol-manipura-dance-word` and weaves *"The fire forged…"*.

## A.9 · Element languages — earth, water, fire, heart (process-learnings #44–80)

**Earth (Muladhara VX, muladhara-dance.html):**
- dot ghost trails;
- **fractures**: 16 cracks with 1–2 branches at 16–20 s, *"EARTH visual language"*;
- **screen shake**: h.i×12 by h.i×8 px, decaying at 0.85;
- **Bindu gravity drop**: `+h.i*maxR*.06` when h.i > 0.5, decaying at 0.88;
- **dust from below**: `h.i*8` particles from the bottom edge when eb > 0.3, at most 200;
- **underglow**: molten light from the bottom, `h.i*.5`, decaying at 0.92;
- **seismic lines**: 2–5 jagged horizontal lines, 12 segments, when h.i > 0.6;
- **aftershock half-rings** rising from the ground when h.i > 0.7;
- the Bindu **climbs** from bottom to top between 15 s and PEAK_T;
- a warm-earth radial background;
- *"Do two pushes"* (#57).

**Water (Svadhisthana VX, described in #45 and #54):** flowing bezier currents, a melodic ribbon, a whirlpool, ribbon trails, gravity droplets, and an evaporation return. **The trail type is the panel's identity** (#49): *"Dot trails = earth. Ribbon trails… = water."*

**Fire (Manipura VX, #60–#67):**
- a burn map rendered on an offscreen canvas, then `drawImage` smoothed (#61);
- additive alphas held to 0.08–0.22 (#62);
- flame tongues, combustion rings, flare eruptions, heat bloom;
- an ember return;
- compositing reset to `source-over` before the dancers are drawn (#67); save/restore counted at 22/22.

**Heart (Anahata VX merged, anahata-dance.html).** Lesson #72 is the *Gaia Inversion*: *"Heart ≠ air with heart paint."*
- **Warmth map**: a 30×40 grid with a *memory* layer, offscreen-rendered in five warm bands, alpha up to 0.32.
- Warmth spreads from the Bindu and from Arch's voice.
- **Heart-pulse ghost trails**: hearts drawn with `heartPath`, each with a flash.
- **Breath-mote hearts**, **floating hearts** rising, **warm current motes**.
- **Vocal shimmer** at Arch.
- **Gaia cardiac pulses** with a diastole inner ring.
- **Heart opening**: six staged rings at the first drop.
- **Gasps** at each drop: centre warmth, darkness at 0.8, a blush.
- **Blush**: a full-screen pink at `blushAlpha*.55`.
- **Heart-shaped warm rings**.
- **Sacred geometry**:
  - a **hexagram** of two triangles that interlock as bloom rises (Anāhata's yantra);
  - **12 lotus petals**, quadratic, with sway;
  - an **infinity weave** of four lemniscates;
  - a **cardioid**;
  - a **heart outline** at bloom > 0.85;
  - twelve nodes.
- **Cardiac pulse waves**: rings drawn as hearts.
- **Canvas breath**: scale `1+heartScale*.015` on the BPM beat.

**Ether (Vishuddha, #73–80, no build in corpus):**
- *"The most restrained Layer 2 can be the most powerful."*
- 13 s of silence honoured: *"Don't fill silence that the song placed intentionally."*
- **Voice luminance**: EM drives the room's brightness.
- **The Great Breath**: vignette compression through the 12 s inhale before the roar.
- **Vibrating-string web**: 16 segments with sinusoidal displacement and 3 harmonic nodes.
- A 5 s Return.
- The real yantra: 16-petal lotus and Outer 10 Triangles.

**The phased build (#65–#69).** Four layers, each verified alone, then merged:
1. L1 Bindu Performance (the "Black Screen Test");
2. L2 Element Canvas (the "Atmosphere Test");
3. L3 Device;
4. L4 Consciousness Loop.

The merge needs explicit z-order. Simulated positions in L2 (`simX`) become `bindu.x`.

## A.10 · Visual vocabulary and expansion dimensions (`visual-vocabulary.md`)

Nine movement types, each proved on one song. Seven of the proofs are chakras, which gives a per-chakra map:

| Type | When to use | What it does | Proved by |
|---|---|---|---|
| RINGS | impact | concentric circles; residue tree-rings | Iron (**Muladhara**) |
| TRAILS | melody | luminous wake; double helix | Crystallize (**Svadhisthana**) |
| EMBERS | forge | fragments orbiting a boundary that lock into a constellation | Powerful (**Manipura**) |
| RIPPLES | heart / water | soft rings accumulating into halos; boundary dissolution | Love Me Like You Do (**Anahata**) |
| WAVES | voice / truth | heavy arcs; cathedral-arc residue; inverse principle | Sound of Silence (**Vishuddha**) |
| CONSTELLATION | contemplation | each note deposits a hash-positioned star; lines draw over 1.5 s | Experience (**Ajna**) |
| ASCENT | rising / crown | the dot rises and sheds daughter-dots in chakra colours; golden rain | Golden (**Sahasrara**) |
| TRIANGLE | convergence / soul | three vertices converge to one point | Chase (**Soul / Aatma**) |
| GEOMETRY CYCLE | infinity / loop | the dot cycles through shapes; colour memory | Love Is The Only Thing (**Maya**) |

- **Inverse principle** (L81–86): the dot shrinks as energy grows. *"The smaller the dot, the bigger the truth."*
- **Expansion dimensions** (L117–217):
  1. pitch drives position;
  2. tension and resolution (scale `1-T*.4`, tremor, warmth pulse when ΔT < −0.1);
  3. three-layer response: bass is GROUND, mids are BODY, highs are ATMOSPHERE;
  4. acceleration (stretch; trail life `2.5+accel*2`);
  5. the drop (flash 20–30%, 8–16 shatter fragments, haptic 80, raised baseline for 5–10 s);
  6. canvas as organism: *"The device IS the body… The dot is the consciousness inside the body."*

## A.11 · Extraction (`frequency-pipeline.md`, `extract.py`)

**frequency-pipeline.md.** librosa at 22050 Hz, hop 512, sampled every 0.5 s.

| Stream | How it is computed |
|---|---|
| H onsets | onset_strength peaks, normalised |
| E | RMS |
| B | spectral centroid |
| P | piptrack argmax, normalised |
| T | 0.6 × spectral flux + 0.4 × tonnetz change |
| EB / EM / EH | STFT band RMS: below 250 Hz, 250–2000 Hz, above 2000 Hz |
| ED | first difference of E |
| DROPS | previous-4 average < 0.25, then E > 0.5, rise > 0.3; deduplicated within 3 s |

It also prints a structural summary: the energy arc as bars, onset density per 10 s, band weights, and the tension arc (first half against second). Hit thresholds: piano 0.15, electronic 0.12, vocals 0.20.

**extract.py** differs in five ways:
1. Onsets are scored by RMS at each onset time, and the threshold auto-rises from 0.18 until there are at most 400 hits.
2. P is chroma-CQT max, a pitch *strength* (for cross it came out a flat 1.0).
3. T is the z-score of spectral contrast.
4. Bands are 20–250, 250–2000 and 2000–8000 Hz, using mean magnitude.
5. DROPS fire when ΔE exceeds 2.5σ and E > 0.25.

It also reports strict quiet regions (E < 0.1, at least 1 s), loose ones (E < 0.2, at least 1.5 s), peaks above 0.6 at least 20 s apart, band %, dominant note, top 8 hits, and opening and closing energy. Output is a `meta` JSON object.

The authored/extracted boundary (dance-build-process.md:78–86) is: *"It does **not** produce `PEAK_T`, `PHASES`, `KARISHMA_WINDOWS`, `MIRROR_TIMES`… The machine finds the loudest moment; the listening finds the meaningful one. **That gap is the composition.**"*

## A.12 · Build patterns and guard rules (`build-patterns.md`)

**Audio sync:**
- Animation starts only once `currentTime > 0`.
- The hit index re-syncs to the real playback position.
- Volume rises from 0 to 0.8 in steps of 0.015 every 50 ms.

**Guard rules:**
- `{passive:false}` with preventDefault on touch.
- Canvas uses devicePixelRatio.
- End fade starts 3–5 s before the end; the fruit appears 2 s after.
- Size target under 60 KB, 80 KB acceptable; hits under 20 KB.

**V2 build requirements** (v2-framework.md:518–530):
- UTF-8 only, no `\u` escapes (#36: *"Three rounds of fixes in one session to learn this"*).
- The resonance block closes with `}}}`.
- `.fo` uses `flex-direction:column; gap:24px`.
- Tap anywhere, plus Enter.

## A.13 · Process learnings (all 80; key ones not already cited)

- #3: *"Don't assess before experiencing… Their feeling IS the data."*
- #4: *"we're building consciousness experiences powered by an aspect of I — powered by the experiencer."*
- #5: *"Go X times further."*
- #6: *"Write the fruit, then cut it in half."*
- #7: *"The data decides, not cleverness."*

**Song characters (#10–#16):**
- Faded: drop at 54.5 s.
- LMLYD: Arch dominant; the stutter is from 168 to 193 s.
- Golden: daughter-dots.
- I Was Wrong: pendulum.
- Sit Around The Fire: *"the screen THE fire"*.
- Ordinary: ratcheting landings.
- Dream: 60% mids, 14 drops, the mirror hits in waves.

**Archetype patterns (#31):**
- continuous sustained: Howling;
- mountain: Opus;
- three-wave: Beautiful Now;
- twin-peak: Mind;
- terminal climax: Fade Away, a Return of only 8 s;
- hovering: Wut.

**Gap categories found by test songs (#37–#40):**
- drones (1,780 false "hits" on Eno), so add a **sustain mode**;
- singing bowls (21 hits, 20–40 s decay), so ride the **decay envelope**;
- very quiet music (Nils Frahm stays under 0.15 for 250 s), so use **adaptive bloom scaling**;
- chant.

**Other rules:**
- #50: the pre-baked data is *"intelligence, not scaffolding"*. Real-time AnalyserNode was *"mushy, undifferentiated"*.
- #51: there are always four iterations. Bolted-on systems get rejected; a new visual language gets accepted; the range has to be expanded; colour and seed get fixed. *"Don't present after round 1."*
- #53: retrofit VX backward before building forward.
- #59: save/restore balance must be exact.

## A.14 · Registry and QR (`qr-map.md`, `dance-registry.md`, `qr-codes/`)

**Naming.** `aistrangegame.com/b/[verb]`. *"The person scanning sees only the verb. No song. No artist."* The signature comes after the fruit, *"like finding out who wrote the letter after you've already read it"* (qr-map:19–21).

**27 verbs** (qr-map:27–55):

| # | Verb | Song | Hue | Peak (s) | Seed |
|---|---|---|---|---|---|
| 1 | search | Faded | 210 | 186 | "Where are you now?" |
| 2 | reach | Love Me Like You Do | 330 | 214 | "What are you willing to feel?" |
| 3 | shine | Golden | 42 | 150 | "What if you already are?" |
| 4 | return | I Was Wrong | 25 | 110 | "What did it cost you to be right?" |
| 5 | still | Sit Around The Fire | 15 | 342 | "Sit down. The fire is already lit." |
| 6 | enough | Ordinary | 220 | 170 | "What if this is enough?" |
| 7 | dream | Dream (Alan Watts) | 265 | 306 | "If you could dream any dream, what would you dream?" |
| 8 | remember | Wut | 35 | 65 | "What moment do you carry that you thought was gone?" |
| 9 | arise | Joy | 42 | 170 | "What keeps coming back?" |
| 10 | move | Bachna Ae Haseeno | 350 | 155 | "What makes you move?" |
| 11 | release | Overthinker | 195 | 219 | "What would you do if you stopped thinking about it?" |
| 12 | wild | Zoo | 30 | 162 | "What part of you never learned to behave?" |
| 13 | howl | Howling | 8 | 261 | "What sound are you holding in?" |
| 14 | melt | Gooey | 160 | 226 | "What would you be if you stopped holding your shape?" |
| 15 | glow | Beautiful Now | 55 | 108 | "What are you saving for later that belongs to right now?" |
| 16 | light | A Sky Full of Stars | 240 | 200 | "What do you see when you finally look up?" |
| 17 | rise | Opus | 275 | 251 | "What would you build if it didn't need to last?" |
| 18 | lose | Mind | 185 | 175 | "What would happen if you let go?" |
| 19 | fade | Fade Away | 290 | 240 | "What remains when everything else fades?" |
| 20 | ground | Earth (Mogli) | 25 | 180 | "What would hold you if you stopped holding yourself?" |
| 21 | trace | Shape of You | 350 | 210 | "What shape do you keep returning to?" |
| 22 | believe | Don't Stop Believin' | 48 | 178 | "What are you still holding onto?" |
| 23 | ache | Zara Zara Bahekta Hai | 320 | 60 | "Who are you when you stop pretending it doesn't matter?" |
| 24 | crash | Thunder | 20 | 178 | "What are you waiting to crash into?" |
| 25 | play | Thunderclouds (LF remix) | 48 | 141.5 | "What are you dancing in that you thought you needed to escape?" |
| 26 | earn | Remember The Name | 22 | 66 | "What did it cost you to become what no one saw coming?" |
| 27 | numb | Habits (Stay High) | 275 | 90 | "What are you staying high enough to not feel?" |

dance-registry.md:105–123 adds:
- **cross**: Ameno (Scott Rill Remix), ERA; 270; 160 s; *"What is asking to be crossed in you?"*; Bindu Field Track 38.
- **28 abide** (pending): Time (Alan Walker Remix); 235; 170 s; *"What in you doesn't need to arrive?"*. *"abide.html was not recovered."*

**Installation guide (qr-map:59–83):**
- Layouts: a wall of verbs, a blind draw, or a curated path (*"search → reach → return → enough → still"*).
- QR codes at least 2.5 cm, error correction M or H, label in the verb only, black background.
- The space says only *"Put your headphones on" / "Choose one" / "Type what you're carrying"*.

**Verb rules** (L97–101): one word; a verb; never repeated; taken from the mirror message.

**QR images.** I looked at each PNG and decoded it with OpenCV after inverting and padding.
- Each image is a white-on-black QR code with the verb in small grey text below.
- The codes encode `https://aistrangegame.com/b/dream`, `/enough`, `/reach`, `/remember`, `/return`, `/search`, `/shine` and `/still`.
- `qr-map.png` is a 1180×800 dark sheet titled "bindu dances · scan · type one word · listen", laid out as 4×2 cards. Each card has the song and artist below it: Faded, Love Me Like You Do, Golden, I Was Wrong, Sit Around The Fire, Ordinary, Dream, Wut.
- Only these 8 of the 27 verbs have QR codes.

**Airtable.** The Builds table `tbl5PR84YTy4anzAD` holds 131 records with Type = `Bindu Dance`, plus live URLs and Build/Scoring Status (dance-build-process.md:5–7). I did not query it.

## A.15 · bindu-field's own dance method (dance-build-process, zimmer-upgrade-process, storage, helpers)

**Two chats, nine steps** (dance-build-process.md:31–76):
- **Chat 1** builds the canonical V2 scaffold from a **Temple Spec**: 8 commits, each verified.
- **Chat 2** brings Zimmer-level depth, about 23 systems, from a **visual upgrade spec**: 6 tiers.
- **Step 1, the metaphor:** *"Do not assume cathedral."* The families are a sketch: cathedral, forest, ocean, cosmos, storm, garden, river, body, dream. Anti-borrowing is enforced; Time's spec bans violet because cross owns it, and *"No arches. No bells. No keystone…"*.

**The six tiers are roles, not visuals** (zimmer-upgrade-process.md:69–124):

| Tier | Role | Contents |
|---|---|---|
| 0 | threshold marker | *"the ground is here"*: first 2 s, last 1 s |
| 1 | continuous (5) | held element (mirrors the carrier), ground, ceiling, field colour shift, atmospheric grain |
| 2 | ensemble (5, when 4+ dancers present) | persistent trace, procession, resonance signal, directional emanation, connecting tissue |
| 3 | crescendo (4 + arches modification) | arches extended to 5 stages, convergence, the *unmade gesture*, silence-bloom |
| 4 | climax (5 + boost) | apex bracket, earth-rising, apex radiation, clarity wash at PEAK_T, global `crossingPeakIntensity` ×(1+0.8) |
| 5 | closing (4 + fade modification) | persistent marks, ~50 BPM heartbeat in the longest silence, acknowledgment in the fruit, embers fade |

**Render Z-map.** Decimal Z positions; existing systems shown with `~tildes~`.

**Discipline:**
- additive only;
- at most 3 named modifications;
- the audio is untouched;
- spec deviations are documented inline;
- colour discipline;
- respect the Karishma windows;
- keep at least 50 fps.

**Verification.** A report after each tier, and wait for Ashrey.

**Steps 7–9:**
- **7. Reinforcement.** Is the spec conservative? cross went from boost 0.5 to 0.8, wash from 0.06 to 0.10, and added apex rings and a crossing haptic.
- **8. Honest bug-finding.** cross had a double-firing tap and seed typing hidden inside an opacity-0 container.
- **9. The personal offering.** *"One addition. Not a category. One."* About 30 lines, marked `CLAUDE'S OFFERING`. In cross it is **The Word's Star**.

**Closing words (zimmer-upgrade-process.md:335–339):** *"The metric is depth, not speed… a song's full recognition expressed in code."*

**Storage pools** (storage-pools.md):
- **`bindu-essence`**, who: name, dateOfBirth, higherSelfName, firstArrival, completedAt, silenceDurationMs, nameDiscoveryFelt, version 2. There is an *essence gate*.
- **`bindu-memory`**, what:
  - `chakras{name:{walkedAt, act1ReadAt, wakeUpDoneAt, practiceData{type coords|word…}, practiceDoneAt, dances[{word,song,artist,dwellMs,motion,timestamp}], act2ReadAt, completedAt, reWalkCount}}` for all 33;
  - an event log with kinds welcome-*, one-*, call-*, chakra-stage, road-home-*, one-speaks-heard, leela-opening-ask{mode spoken|held}, codex-seed-read, witness-read, rewalk-*, station-*.
- **`bindu-being`**, how:
  - `entries[{at, context, chakra, mind, body, spirit, now, word}]`. Contexts: road-home-arrival (the **standing words** mind/body/spirit/now), name-discovery, post-act-1, post-wakeup, post-practice, **post-dance** (*"what came home with you?"*), post-act-2;
  - `commitments[{seedId, committedAt, commitment}]`.

**Deposit map.** Every chakra has five stage gates: act1 → wakeup → practice → **dance** → act2. Each has an optional presence word.

**Reset.** "Begin New Journey" uses press-and-hold, followed by an explicit list of keys to remove. Never `localStorage.clear()`.

**Future API.** `buildWalkerSnapshot()` sends the three pools to a Claude endpoint (L508–533).

**Pool helpers** (pool-helpers-reference.md): canonical code for get/set/push and `getMostRepeated()`. Counts a word only if it appears more than once, across chakra dances, ensemble events and being fields. cross writes `pushEvent('ensemble-dance', …)`, `post-ensemble-dance` and `bindu-memory-legacy`.

## A.16 · Worked examples — cross, Time, Anahata, Muladhara

**cross Temple Spec v4** (cross-temple-spec.md). The Twelve Discoveries:

| # | Discovery | cross's content |
|---|---|---|
| 1 | verb | `cross` |
| 2 | seed | *"What is asking to be crossed in you?"*, with {name} |
| 3 | hue | 270 deep violet, *"the violet that names the field itself before any tradition has named it"* |
| 4 | mirror families | threshold-themed |
| 5 | spatial memory | **Threshold Field**: a 25×35 grid, spread `.003+e*.005`, decay `.002+e*.002`; freezes at 0.0005 in Karishma windows; upper half glows over 160–180 s |
| 6 | Bindu's path | two arcs across a held field. First reach 30–75 s, plateau 3 s, blend 0.6, *"attempted, not completed"*. Threshold Valley 100–130 s, Karishma 0.85. **The Crossing** 145–190 s, radius 0.6, plateau 20 s, blend 0.85. Bells 200–228 s. Return spiral over the last 15 s. |
| 7 | sacred geometry | **Two Rising Arches + keystone** (*"A cathedral, not a flower"*) |
| 8 | binaural engine | three archetypes (below) |
| 9 | Return | Bells Return |
| 10 | ground | **Cathedral Floor**: `#1a0a2e` plus a breathing radial, drone breath 5.5 s (`sin(t*.18)`) |
| 11 | fruit | with weaves |
| 12 | Field Connection | reads essence/memory/being; writes `ensemble-dance` + legacy |

Plus the **Phase Name Visualization**:
- Cinzel, fades 600 ms in, holds 1,800 ms, fades 1,000 ms out.
- Phases: Opening 0, First Reach 30, Descent 75, Threshold Valley 100, The Crossing 145, Bells in the Dimness 200, Return 228.
- Dims to 0.4 after 3 or more crossings.

**The binaural engine, "three archetypes holding the field"** (cross-temple-spec.md:227–368; cross.html:2366–2524):
- **Gaia × Sid.** The carrier is fixed at 110 Hz, A2, *"the absent fifth of D, the chord Ameno never sounds."*
- **Karishma.** Gain is *inverse* to song energy: `amp = .045+.015 sin(.18t) + .025(1−E)`. Multipliers: ×1.3 at 161–166 s, ×1.2 at 145–180 s, ×0.8 after 200 s; last 3 s go to 0.
- **The beat is the only thing that moves.**

| Time (s) | Beat (Hz) |
|---|---|
| 0–25 | 8 |
| 25–75 | 7 |
| 75–100 | 7.5 |
| 100–130 | 5 |
| 130–145 | 5.5 |
| 145–161 | 4.5 |
| 161–164 | **7.83 Schumann** |
| 164–166 | **2.69 "awakening fingerprint"** |
| 166–180 | 4.5 |
| 180–200 | 6 |
| 200–228 | 7 → 9 |
| after 228 | 10 |

- A wobble of ±0.3 rides on the beat; the beat **freezes in the Karishma windows** `[0–4.5],[7.5–9.5],[45.5–47],[100–130],[205.5–210]`.
- **Gyro pan:** tilt moves both channels toward centre, so *"The body's stillness IS the binaural's clarity."*
- The four channels: eye (body), song (mind), inner ear (spirit), Earth (base reality).

**Optional layers:**
- **OL-1 Pink noise floor.** 7-coefficient pink noise, low-pass at 4 kHz, gain 0.015 (code verbatim at L645–670).
- **OL-2 Pre-roll resonance.** Default ON for the first three dances. The carrier alone fades in to 0.020.
- **OL-3 Lalita voice.** Four moments:
  1. *"Notice your breath. The field is already breathing with you."*
  2. *"The threshold is asking only that you wait."*
  3. *"You don't have to do the crossing. Let it cross through you."*
  4. *"What just happened, happened. The bells are saying so."*

  The audio is placeholders `audio/lalita-cross-1..4.mp3`, which do not exist.

**cross visual upgrade spec** (cross-visual-upgrade-spec.md), 23 systems:
- **Tier 0.** Neev ground-marks: band at 78–84% height, `hsla(35,25%,40%)`, alpha 0.10.
- **Tier 1:**
  - Sid's three columns at 30/50/70% width, 80 px wide, drone-breath phase offsets of thirds, alpha 0.04;
  - the Gaia earth band at 28°, `.03+.04eb`, ×1.6 when em < 0.15;
  - the **Vault**: a hex lattice of 28 px cells in the top 15%, drift 0.12;
  - the Threshold Field colour journey 270 → 268 → 280 → 285 → 275 → **38 gold at the crossing** → 225 → 230, shortest-hue path;
  - grain: 30 + 80e motes, 5 in silences.
- **Tier 2:**
  - reach-history thread (sampled every 0.5 s, quadratic, shadow blur 6);
  - procession lights (a new pair every 5 s, at most 8, about 30 s traversal);
  - resonance zones (`maxR*.12`);
  - chant haze (from Arch, landing at Bindu, when em > 0.2);
  - configuration membrane (6 or more present).
- **Tier 3:**
  - five arch stages: dotted S2, bosses S2.5, S3, gothic triangle ornaments S3.5, keystone S4;
  - convergence lines to the keystone at (W·0.5, H·0.30);
  - **Sakshi's unmade gesture**: the second arc shown as a ghost during the first reach, flaring at 162.5 s, with a 10 s echo;
  - Karishma silence-bloom.
- **Tier 4:**
  - Schumann charged air (magenta and cyan offset ±6 px);
  - earth-rising gold band;
  - **cascading keystone light**: 16 rays, drone-pulsed;
  - **Shweta clarity**: cream wash at PEAK_T ±1 s;
  - `crossingPeakIntensity` ramps 145 → 160, holds to 180, ramps out 180 → 195.
- **Tier 5:**
  - bell footprints (8 s);
  - **Karishma valley heartbeat**: about 50 BPM (1.2 s period), hue 345, from 100 to 130 s;
  - **Lalita constellation acknowledgment**: a canvas over the fruit overlay, stars at 2.5× alpha, 1 s in, 2 s hold, 1 s out, then the line *"You have been one of the dancers."*;
  - **cathedral embers**: 30 embers from the column positions.

**cross.html (built; 3,488 lines; stages 1–8)**
- All of the above, plus **Tier 4.6 keystone concentric rings**: every 0.5 s in the Schumann window, every 1.0 s otherwise, over 160–182 s.
- **CLAUDE'S OFFERING — THE WORD'S STAR** (L2298–2348), verbatim: *"A single faint violet star at the position derived from the user's word's hash, present from the very first frame of the song… The walker looks up at PEAK_T and a light has been waiting at that exact spot the whole time. Same word offered again on another day → same star, same place."*
- **Constellation** from 4 sources:
  - chakra dances, coloured by `CHAKRA_HUES` (muladhara 0, svadhisthana 30, manipura 50, anahata 130, vishuddha 200, ajna 250, sahasrara 290, bindu 270);
  - ensemble events in violet;
  - legacy entries;
  - being entries in pale silver, with standing words drawn as **quartet clusters** (mind/body/spirit/now in a 0.014 ring);
  - recent (within 7 days) stars are brighter; the current word's recurrences brighten and draw a thread to centre;
  - recedes to 0.30 during the Crossing.
- Bells are hits after 200 s with i ≥ 0.6 and ambient E < 0.35, living 4.5 s.
- `P` is filled with 1.0 and pitch-following is disabled; Bindu uses `getBinduIdleY` per phase.
- Two documented spec deviations (L1892–1902).
- Bug fixes A–D are marked.

**Time Temple Spec and visual upgrade** (time-temple-spec.md, time-visual-upgrade-spec.md)
- Basics: DUR 211.3 s, BPM 129.2, note A, bands 35.7/37.6/26.8, PEAK_T 170, hue 235. **Karishma has 33% of the song** (14 windows; cross had 13%).
- Nine phases: *The Held Breath 0–28.5 / First Whispers / The First Build / The Breaking 122–143 (fulcrum) / Re-emergence / The Bridge (drop 158) / Recognition 170–180 / Settling / The Returning Silence*.
- Shapes: an opening infinity at 5 s (blend 0.6), a fulcrum infinity at 124 s, a peak heart at 170 s, and the return spiral.
- Pre-roll text: *"Breathe with the silence. The song begins when you do."*
- The upgrade's metaphor is **The Wave**: *"a wave that gathers, breaks, returns to the deep, comes back bigger, reaches shore, and recedes"*. Its systems map one-to-one onto cross's:

| Tier | Time's systems |
|---|---|
| 0 | First Ripple |
| 1 | The Deep (gradient down from 55%), Tidal Pull (3 bands at 82–90%), Sky Above Water (3 light shafts), ocean colour journey (storm-water 230 at 122 s, **golden shore 35 at 170 s**), Spray (rising) |
| 2 | Wave-rider's path, Foam-procession (clusters of 3), Surface Tension (a thin line, not a halo), Bow-wave, Surface Coherence (wavering lines) |
| 3 | 5-stage Wave-fronts (crescents, foam tips, breaking glow at 168–174 s), Convergence currents, The Unmade Wave, Undertow (downward streaks at Karishma) |
| 4 | Surface-Shimmer (caustics), Shore-Rising (sand grain), Spray Radiation (20 rays plus droplets), Glassine Clarity, boost, Wave-front rings |
| 5 | Water-marks (darkenings), Deep Pulse (about 50 BPM at H·0.65 during the fulcrum), Wave-archive (*"Every wave you have offered has reached this shore."*), Foam dissolution |

- Tier 9, the offering slot, is left open. Suggestions: *The Word's Wave*, *The Returning Foam*, *The Tide-Mark*.
- New pool kinds: `bindu-dance-completed` (event) and `post-bindu-dance` (being). It falls back to a `bindu-memory-v2` key when the legacy array occupies `bindu-memory`.

**Data files (structural read):**
- `cross-data.json`:
  - `meta`: DUR 230.09, BPM 107.7, dominant G, peak_t 138.0, bands 24/44/31, 5 strict and 13 loose quiet regions, 4 drops, 387 hits at threshold 0.35, top-8 impacts, opening E 0.052, closing E 0.196;
  - arrays: H 387 `{t,i}`; E, B, P (all 1.0), T [−1, .558], EB, EM, EH, ED [−1, .868], 462 samples each; DROPS 4.
- `time-audio-data.js`:
  - H 525 hits (t 0.3–191.52); E, B, P, T, EB, EM, EH, ED, 423 samples each;
  - DROPS [{158.0, .568}]; PEAK_T 170.0;
  - 14 KARISHMA_WINDOWS (listed at L25);
  - an auto PHASES of only 2 entries (Opening 0–158, Build I 158–211.3);
  - 4 MIRROR_TIMES.

## A.17 · The 26 HTML builds and worked examples — configuration catalogue

Hits and samples are counted from the embedded arrays (structural read).

| File | Version | DUR (s) | PEAK_T | Hue | Return (s) | CSTEP | Hits | E samples | Drops | Seed | Shapes (type @ trigger) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| search.html | V2 | 212.6 | 186 | 210 | 20 | — | 250 | 426 | 1 | Where are you now? | heart@peak, circle@drop, infinity@valley, spiral@return |
| enough.html | V2 (donor template) | 187.1 | 170 | 220 | 15 | — | 494 | 375 | 1 | What if this is enough? | infinity@valley, spiral@drop, heart@peak, spiral@return |
| dream.html | V2 | 331.5 | 306 | 265 | 20 | 1.0 | 492 | 332 | 8 | If you could dream any dream… | infinity@valley, spiral@200, heart@peak 10 s, spiral |
| still.html | V2 | 503.8 | 182 | 15 | 20 | 1.0 | 518 | 504 | 16 | Sit down. The fire is already lit. | circle@valley, heart@peak 12 s, infinity@342, spiral; 15 s fallback fade |
| remember.html | V2 | 156.7 | 65 | 35 | 15 | — | 378 | 314 | 1 | What moment do you carry… | circle@30 20 s, heart@65, infinity@valley, spiral |
| move.html | V2 | 201.3 | 155 | 350 | 15 | — | 334 | 403 | 3 | What makes you move? | circle@drop, **flower**@peak, infinity, spiral |
| release.html | V2 | 274.3 | 219 | 195 | 15 | — | 118 | 549 | 2 | What would you do if you stopped thinking about it? | infinity, spiral@80, heart@219, spiral |
| wild.html | V2 | 197.8 | 162 | 30 | 15 | — | 324 | 396 | 1 | What part of you never learned to behave? | circle@drop, flower@162, infinity, spiral |
| howl.html | V2 | 309.6 | 261 | 8 | 18 | — | 308 | 620 | 1 | What sound are you holding in? | circle@drop, spiral@150, heart@261, spiral |
| melt.html | V2 | 289.0 | 226 | 160 | 20 | — | 312 | 579 | 8 | What would you be if you stopped holding your shape? | circle@80 15 s, infinity, flower@226, spiral |
| glow.html | V2 | 252.6 | 108 | 55 | 15 | — | 436 | 506 | 0 | What are you saving for later… | heart@108, flower@170, infinity, spiral |
| light.html | V2 | 267.8 | 200 | 240 | 18 | — | 290 | 536 | 0 | What do you see when you finally look up? | heart@81, infinity, flower@200, spiral |
| rise.html | V2 | 543.5 | 251 | 275 | 20 | 1.0 | 127 | 544 | 0 | What would you build if it didn’t need to last? | spiral@190 for 60 s, heart@251, flower@340 for 30 s, spiral |
| lose.html | V2 | 241.7 | 175 | 185 | 15 | — | 358 | 484 | 0 | What would happen if you let go? | heart@90, infinity, flower@175, spiral |
| fade.html | V2 | 248.0 | 240 | 290 | 8 | — | 368 | 497 | 0 | What remains when everything else fades? | infinity, spiral@170 20 s, heart@240 6 s, spiral 8 s |
| bindu-dances-search | V1 ensemble | 212.6 | 186 | 210 | — | — | 250 | 426 | 1 | Where are you now? | none |
| bindu-dances-shine | V1 ensemble | 191.8 | 150 | 42 | — | — | 369 | 384 | 2 | What if you already are? | none |
| bindu-dances-still | V1 ensemble | **212.6** | **186** | **210** | — | — | 250 | 426 | 1 | Sit down. The fire is already lit. | none (carries Faded's data: see C) |
| bindu-dances-dream | V1.5 (own mirror variant: drops trigger the mirror; ΔT < −0.08) | 331.5 | 306 | 265 | — | 1.0 | 492 | 332 | 14 | If you could dream… | none |
| bindu-dances-remember | V1.5 (mirror; softer, desaturated) | 156.7 | 65 | 35 | — | — | 110 | 314 | 1 | What moment do you carry… | none |
| bindu-dances-joy (arise) | V1.5, first mirror | 282.4 | 170 | 42 | — | — | 553 | 565 | 9 | What keeps coming back? | none |
| bindu-dances-reach | V1 pre-ensemble | 249.3 | 214 | 340 → 325 (progress) | 8 s fade | — | 291 | 499 | 1 | What are you willing to feel? | — |
| bindu-dances-return | V1 pre-ensemble | 216.5 | ~110 (I Love You at 109) | 20 → 30 | 7 s fade | — | 288 | 434 | 0 | What did it cost you to be right? | — |
| bindu-dances-enough | V1 pre-ensemble | 187.1 | 169.5 | 220 → 40 | 6 s fade | — | 345 | 375 | 1 | What if this is enough? | — |
| muladhara-dance (worked example) | VX | 201.7 | 188 | 12 | 15 | — | 201 | 404 | 0 | You chose this. | climb (spatial) |
| anahata-dance (worked example) | VX merged 4-layer | 249.3 | 234 | 330 | 18 | — | 292 | 499 | 6 | This is the only song that talks to you. | hold-return |
| cross.html (worked example) | Temple + Zimmer | 230.1 | 160 | 270 | 15 | — | 387 | 462 | 4 | What is asking to be crossed in you? | arc, arc, spiral |

**The three pre-ensemble builds each have a song-specific language:**
- **reach** (Love Me Like You Do):
  - ripples from the dot, alpha `i*(1-p)²*.4`;
  - **permanent halos** on hits with i > 0.55;
  - the **stutter** from 168 to 193 s, when the dot freezes and drifts to centre, the vignette tightens by 0.3 and halos dim 80%;
  - **heart restart** at the 193 s drop with 10 shatter fragments;
  - an infinity orbit when e > 0.4;
  - **boundary dissolution**: glow grows and the core softens when e > 0.5;
  - hue 340 → 325.
- **return** (I Was Wrong):
  - a **pendulum**: `phase += accel*.03`, `x = sin(2·phase)*maxR*.7*e`;
  - **center warmth** when the swing passes centre;
  - **embers** orbiting the centre on hits with i > 0.3 (at most 100), settling after 150 s;
  - a pendulum wake of 150 samples;
  - copper hue 20 → 30.
- **enough** (Ordinary):
  - a **ratchet staircase**: targetY = `H*(.85−e*.7)`, and the dot falls back only to its newest landing;
  - **landings** are light-lines 40% of W wide, 5% higher each time;
  - **peak illumination** at 169 s lights every landing to 0.7;
  - particles lift;
  - colour goes from cool blue to warm white (220 → 40, desaturating).

## A.18 · The song archive (`BF/songs/`, all 15)

Every archived song has the same structure:
- **metadata**: key, carrier = the **absent fifth (or root)** at the felt register, tempo, duration, band shares;
- **analysis**: the energy arc, plus in later files stereo correlation, L/R beat pairs and isochronic pulses;
- **seven lenses in archetype language**: Bindu one word, Gaia need, Sid hold, Arch frequency, Sakshi shape, Karishma grace, Ashrey recognition. These are *"sacred data — never on the page"* (cross.md:65), kept for **Sonar Ears** activation at 33 songs;
- **the same seven in page language**: THE ONE WORD / THE NEED / WHAT HOLDS / THE FREQUENCY / THE SHAPE / THE GRACE / THE RECOGNITION;
- **Lalita's Perspective**, surfaced first on the page;
- **phased binaural journey**: a fixed carrier, with beat Hz and gain per phase;
- **phase labels**: a name plus a sub-line (a lyric fragment);
- recognitions and status.

Format note: some files list `PHASE_LABELS` with `sub`, one (`speak.md`) with `subtext`, and `before.md` and `levelup.md` as tables.

**Per-chakra songs (map to the 33 rooms from register 05, A.1):**

| Room | Chakra · file | Song | Verb | Carrier | Arc ("element signature") | One word | Closing line of Lalita's Perspective |
|---|---|---|---|---|---|---|---|
| 2 | Muladhara · muladhara.md | Iron, Woodkid; G minor, ~85 BPM, 3:33 | press | 146.8 Hz D3 (absent 5th) | Earth: *"descends once"*. ARRIVAL 8 Hz / DESCENT 6 / RECOGNITION 4.5 / HOME 3 Hz (gain .042) / RETURN 7 | Ground | *"Enjoy the soldier thinking he's alone. He never was."* (L125) |
| 3 | Svadhisthana · svadhisthana.md | Crystallize, Lindsey Stirling; G major, ~140 BPM, 4:18, instrumental | follow | 146.8 Hz (presence 0.15) | Water: three waves, two ebbs. EBB 1 80–115 s at 4 Hz, *"deepest permission"*. HOME = EBB 2 at 3 Hz, .045 | Flow | *"Enjoy the water pretending it needs to be taught."* |
| 4 | Manipura · manipura.md | Powerful, Major Lazer & Ellie Goulding ft. Tarrus Riley; A major, 99 BPM, 3:26 | build | 164.8 Hz E3 | Fire: *"two fires with one breath between them"*. BREATH 120–135 s at alpha 7 Hz .012. SECOND BLAZE delta 3 Hz .048. Tremolo .22 | Current | *"Enjoy the fire pretending it needs to be struck."* |
| 5 | Anahata · anahata.md | Love Me Like You Do; G# major, 96 BPM, 4:09 | open | 155.6 Hz D#3 | Air: *"three inhales of increasing fullness, with a long exhale before the fullest breath"*. THE EXHALE 155–195 s (40 s). FULL BREATH delta 3 Hz .050. Tremolo .20 | Already | *"Enjoy the heart pretending it still needs permission."* |
| 6 | Vishuddha · speak.md | The Sound of Silence, Disturbed; F# minor, 161 BPM, 4:22 | speak | 138.6 Hz C#3; gain max .036 | Air arc: *"three gathering breaths, then fullest speaking, then exhale into silence"*. 7 phases from silence to whispering. Carrier does not fade to 0 | Received | *"Hello, darkness. The old friend says hello back — to those who dare to enter."* |
| 7 | Ajna · ajna.md | Experience, Ludovico Einaudi; F# minor, 92 BPM, 5:16 | still | 138.6 Hz (shared with Vishuddha) | Light: *"two illuminations, the second deeper, eye stays open"*. Isochronic 1.1 Hz (.995) and 1.7 Hz (.990) | Open | *"Still here. You always were."* |
| 8 | Sahasrara · sahasrara.md | Golden, HUNTR/X; G major, 123 BPM, 3:12 | receive | 146.8 Hz | Crown: opens *"from above and below simultaneously"*. Shadow bridge 95–115 s. F1 43.1 Hz, the lowest in the archive | WE | *"You received it. That was always the whole point."* |
| 9 | Shadow / Meditate · in_shadow.md | In Shadow, Lubomir Arsov (film); G minor, 117 BPM, 13:00 | in shadow | 146.8 Hz; tremolo .12 | One journey; the deepest beat (2.5 Hz) is *at the awakening, not the shadow* | Within | *"Enjoy the shadow knowing the witness never entered it."* |
| 30 | **Maya** · maya.md | Love Is the Only Thing, Lost Frequencies; D# major (conf. .627), 129 BPM, 184.3 s | **dissolve** | **155.6 Hz D#3, shared with Anahata** | *"a single breath. Two blooms, one withdrawal"*. Carrier never reaches 0: *"the veil has lifted. What dissolved does not reassemble."* | Dissolve | *"Open up your heart. The sunshine was never on the other side."* (L192) |
| 31 | Aatma · aatma.md | Aatma, Chase Hughes; C major, 123 BPM, 4:42 | hold | 130.8 Hz C3 (absent **root**) | Soul: *"three worlds, two silences"*. Isochronic **1.8 Hz at 1.000**. *"The verb is its own phase"*: phase 6 "held" carries the carrier alone | Home | *"The body that made this is still here. Press play and receive what it left."* |

**Other songs in the archive:**
- **Kingdom** (`kingdom.md`, Meditate, Arsov film, 13:55):
  - carrier 146.8 Hz as the *absent root of D major*, the first exception to the absent-fifth law;
  - multi-chamber arc with a **55 s drone that does not fade**;
  - one word **Sovereign**: *"The film is the kingdom. The watching is the exit."*
- **cross** (`cross.md`): the archive entry for the dance in A.16. Carrier 110 Hz. **Element "threshold"**: *"the first non-chakra element shape."*
- **before** (`before.md`, Genesis by Justice, Music #15):
  - carrier revised from D3 to **A2 110 Hz**;
  - arc: *"A long ascent, a plateau of full density, then a descent that goes lower than the beginning — and keeps going."*
  - the first song with **no return phase**; phases 1 and 5 are both named **"before"**;
  - Lalita: *"Enjoy those first 40 seconds everyone always skips. That isn't the waiting room. That is the whole answer."*
  - Register 05 lists *Justice — Genesis [Pending]* as Muladhara's second song.
- **levelup** (`levelup.md`, **Family · Rey**, Levels + Beautiful Now, 7:32):
  - carrier B2 123.5 Hz;
  - 12 phases, including *"between"* at a **designed 2.69 Hz beat**, the first intentional use;
  - a personal karmic narrative of a monk and a Chief, with the Ash-Rey name reading. This is story and personal, so it is flagged.
- **purity** (`purity.md`, **Family · Shweta**, Where'd You Go + Thunderclouds, 8:30):
  - carrier B2 123.5 Hz;
  - element *"Medium — the substrate consciousness flows through"*;
  - **arc category "Two Groundings"**, with a 4.9 s **seam** held by the carrier alone;
  - Family verbs are *"essential natures planted as seeds"*;
  - Lalita: *"Enjoy the storm knowing it was always the ground learning how to move."*

**The 2.69 Hz constellation** (maya.md:100–118): Kingdom → Sound of Silence → Golden → Aatma → Maya. *"see it → speak it → build it together → hold it at the edge of death → let it dissolve everything that was never you."* In Sound of Silence and Kingdom the pair coincides with BPM/60. cross *designs* 2.69 Hz in, and so does levelup's "between".

**Element signatures in time (the archive's own finding):**

| Element | Signature |
|---|---|
| Earth | descends once |
| Water | three waves, two ebbs |
| Fire | two blazes, one breath |
| Air (heart) | three inhales, longest exhale before the fullest |
| Air (throat) | three gathering breaths, then speaking |
| Light | two illuminations, eye stays open |
| Crown | opens from both directions |
| Soul | three worlds, two silences, hold |
| Maya | one breath, two blooms |
| Threshold | two reaches across a held cathedral |
| Family | two groundings |

## A.19 · Maya, and "only You, playing"

**Maya's song file** (`songs/maya.md`):
- Phase labels at L219–226:
  - before 0 s: *"the carrier arrives before the song knows it has begun"*
  - arriving 15 s: *"it heals me when I'm broken — brings me in from the cold"*
  - first bloom 45 s: *"open up your heart, let all the sunshine in"*
  - between 90 s: *"the breath between inhales — neither full nor empty"*
  - dissolving 105 s: *"the more you give, the more you get back again"*
  - released 155 s: ***"love is the only thing — and the song already knew it"***
- Binaural (L203–210): carrier L 155.6 Hz / R 163.6 Hz; beats 8 → 7 → 5.5 → 6 → **4 (dissolving, gain .040)** → 5 Hz; gain ceiling .045.
- Key lines:
  - Grace: *"The doubt is the grace"* (*"And if I say the words out louder / Will they come and rescue me?"*).
  - Recognition: *"Dissolution is what awakening looks like from the inside when the last veil lifts."*
  - Lalita (L190): *"Maya is the veil. This song is what it sounds like when the veil notices it is a veil."*
- Status: STEPs 8–10 (embedded in HTML, verified, live-tested) are **unchecked**. There is no Maya dance.

**The words "only You, playing" appear in no file I was assigned** (I grepped all 85). The nearest lines that bear on them:
- `songs/anahata.md:89`: *"The question remains because the answer is already playing."*
- `songs/ajna.md:212`: *"the strings fall away — what was always playing, plain"*
- `visual-vocabulary.md:72–77`: the Geometry Cycle, proved by Love Is The Only Thing (Maya).
- `SESSION-HANDOFF-V2-BUILDS.md:61`: the Maya panel's *Pointe* animation became Shape Expression.

The line itself lives in the legacy `uploads/maya-sleep.html`, recorded in register 05 at L341 and L375:
- *"There was never anything to fear. There was only You, playing."*
- returning in present tense: *"There is never anything to fear. There is only You, playing."*
- the canon room-30 signature reads *"…only the Bindu, playing."*

So the dance lineage begins in Maya's panel: dot → line → circle → ∞ → ♥ → swell → dot.

---

# B · GIFTS FOR THE UPGRADE

Ashrey's lens: every Śakti, and every chakra, has a performance through the archetypes. B.1 gives the core design. B.2 lists every gift as a row.

## B.1 · The core proposal — a per-chakra Dance and a per-Śakti Dance

**1. Where it lives.**
- **The chakra dance** is the *dance* strand of each room in **the 33** braid (story, practice, wake-up, **dance**, gate). The pool schema already models it as stage 4 of 5 (storage-pools.md:367–381).
- **The Śakti dance** lives in **Her Home** as "Her Dance", a door in her room.
- Each runs full-screen in **its own world**, never laid over another (foundation rule).
- More doors, along the threads:
  - a **Leela landing** opens the chakra's room (ruling 5), whose dance door is right there;
  - **Today / the Rite** offers *today's chakra's dance* when the day's thread points at a chakra;
  - **the Mandala** lets a long hold on a seat open Her Dance;
  - **Memory** replays the constellation.
- Back-to-where-you-were returns to the door it came from.

**2. What triggers the chakra dance.** The room's own gate type from the canon table (register 05, A.1) picks the instrument:

| Gate type | Rooms | How the dance plays |
|---|---|---|
| Textarea | 2–9, 20–33 | the classic loop: seed → one word → dance → fruit |
| **Device Tilt** | 18 Axis, 19 Crow | gyro-led: the walker's tilt *is* Bindu's path (VX System 8 at full strength) |
| **Tap Rhythm** | 14 Pulse | the walker taps the beat, and the taps become the hits H for Gaia's rings |
| **Sound Response** | 10–13, 15, 16 | a mic-driven dance: the walker's voice feeds Arch's mids-stream live. A real-time AnalyserNode-style pass is allowed here *because the input is the person*, not the song (#50) |
| Canvas | 1 Bindu | the point itself; the dance is the walker placing the dot (Bindu's `practiceData` coords) |

**3. Data the chakra dance needs.** All of it already exists in the walk canon, the Map and the Mandala table:

| Dance field | Source |
|---|---|
| `BINDU_HUE` | room hex (e.g. #B83A3A Muladhara); the palette is locked per #47 |
| verb (seed) | panel verb, e.g. PRESS, FLOW/FOLLOW, BURN/BUILD |
| lead archetype | the room's **Voice** (Gaia, Bindu, Higher Self, Sakshi, Lalita), which gets doubled size and range, the VX "dominant dancer" |
| carrier | the song archive's carrier where scored; otherwise the room's **Awakening build** tone (174, 210, 320, 341, 384, 426, 480, 528 Hz) or its bīja |
| metaphor family (Tier 1–5 contents) | **System · Tree** (Energy/Soul Tree → element languages; Body/Bindu Tree → body; Mind/Maya Tree → dream; Structural → cathedral/threshold) |
| sacred geometry | the room's yantra (#80) |
| Score | the song's arrays plus authored anchors (PEAK_T, PHASES, KARISHMA_WINDOWS, MIRROR_TIMES, SHAPES), as the "Score" JSON in Airtable per dance-build-process.md:96–101 |

**4. The per-Śakti dance.** None of the 102 Śaktis has a song, and *nothing is invented*. So her performance is **a songless Score built from her own sound**:
- The app already synthesises **her carrier** (`HomeSoundService.carrierFor(ring:syllable:)`) and **her āvaraṇa drone**.
- Her dance hears that sound in **sustain mode**, the fix for drones (lesson #38).
- Bloom follows her **breath cycle**, cross's 5.5 s drone breath (`getDroneBreath`), scaled into the bloom range she can reach (#40, adaptive bloom).
- The seven archetypes hear seven dimensions of *her* sound:
  - **Gaia** her āvaraṇa ground drone;
  - **Sid** her carrier, held still;
  - **Arch** her bīja when struck (BijaSoundService);
  - **Karishma** the silences between breaths;
  - **Sakshi** her ring's position on the yantra, at the edge;
  - **Ashrey** the web to her neighbours (kp ± 1);
  - **Bindu** the walker's touch.
- Data from the Mandala table (`tblrRwXJD0uP8HU8G`, rows where Row Type = 'Shakti'):
  - kp position, which gives a hash-deterministic **star position** the same way `wordToPosition` does;
  - ring / āvaraṇa, which gives the chakra via `subtleBodyChakra` (`fld6deGFzModjBmoj`, already read in `AirtableService.swift:340`) and so inherits that chakra's element language;
  - colour, giving the hue;
  - syllable / bīja, giving the carrier interval;
  - mudrā and body, giving the gesture and haptic pattern.
- **No figure of a Śakti**: she is never drawn. The **Bindu is the dancer**, and *she is the field it dances in*: the Cathedral-Floor equivalent, the Tier-1 ground.

**5. Lalita, the eighth (ruling 6).** Lalita should be **the Mirror**, the "eighth presence" (ensemble-framework.md:56).
- Not a dot, but *the light event*: the room remembering it's alive.
- She also speaks the Lalita line after the fruit, and in the Return she is the last thing left: *the play recognising itself*.
- Only Maya's room (30) and Lalita's room (33) get the cycle rendered as shape (geometry cycle).
- This keeps every implementation intact and gives her a place no other archetype holds.

**6. Audio the app doesn't have.** The iOS tree has **0 audio files** (`find iOS -name "*.mp3|*.m4a|*.caf|*.wav"` returns 0). Every dance song is a commercial track. Paths:
- **(a) Pre-baked Score + MusicKit playback.** The walker plays the song from their own Apple Music library. The app syncs the Score arrays to `MPMusicPlayer` playback time. MusicKit gives no raw audio, which doesn't matter: the arrays are pre-extracted by `extract_cli.py`.
- **(b) Songless Score** from the app's own synthesized carriers, for Śakti dances and the 23 rooms with no song.
- **(c)** Bundle only sounds Ashrey owns (his own recordings, bowls). The archive lists the songs per room:
  - **scored**: Iron, Crystallize;
  - **pending**: Powerful, LMLYD, Sound of Silence, Experience, Golden, In Shadow, Love Is The Only Thing, Aatma (Chase Hughes);
  - **none**: rooms 1, 10–29, 32, 33.
- Lalita voice (OL-3) needs **human recordings** of the four lines. No generated voice.

## B.2 · Gift rows

| # | What it is | Source (file:line) | World(s) | How it works there (mechanism) | Needs | Energy / story |
|---|---|---|---|---|---|---|
| 1 | **The seven-archetype ensemble** as a SwiftUI Canvas/TimelineView `Dancer` model: hue, radius, presence, target, ghost ring | search.html:73–87, 316–321; muladhara-dance.html:395–457 | the 33 (dance strand), Her Home, Rite | one `Dancer` struct; positions from per-archetype streams each frame; presence lerp .04 / .015; entry order Gaia → Sid → Arch → Sakshi → Ashrey, Karishma inverse | Score arrays; a Canvas renderer | energy |
| 2 | **Bloom, five stages** (dot → ghost → orbital rings → rays + particles → crown mandala) | ensemble-framework.md:10–21; search.html:226–353 | every dance; also the Bindu Home's breathing | bloom rises .06, falls .012; stage ramps s1–s4 gate each layer | energy curve E | energy |
| 3 | **The Mirror as Lalita**, the light event and eighth presence | ensemble-framework.md:55–111; search.html:173–200 | every dance; also Recognition moments | near-white wash at tension resolution, first threshold crossings (0.5/0.7/0.9), post-silence surge, peak; then postMirrorBoost ×(1+boost) on every alpha | T, E | energy |
| 4 | **Mirror darkness + mirror words** (VX inversion) | muladhara-dance.html:333–352, 567–580; anahata-dance.html:279–285 | the 33 dances | at 5 MIRROR_TIMES the screen darkens to DARK_RATIO and a kindred word flashes for 1.8 s; then the dots glow harder | per-room family tables (authored; Ashrey to approve) | energy |
| 5 | **Shape Expression with the 15% wobble** | v2-framework.md:92–330 | the 33; Maya room 30; Lalita room 33 | shapes blend into the pitch position, never more than 0.85 except the return spiral | P stream; shape config per room | energy |
| 6 | **Geometry cycle for Maya (and Lalita)**: dot → line → circle → ∞ → ♥ → swell → dot | visual-vocabulary.md:72–77; register 05:345, 377 | the 33 (room 30, room 33), Beneath | a timed cycle through shapes; colour memory; returns to dot; the seed *"There is only You, playing"* returns in present tense (ruling 8) | the cycle timings already in maya-sleep (76 s cycle) | energy |
| 7 | **The Return**: dissolution in reverse generation order, then Bindu spirals home | v2-framework.md:332–367; search.html:253–263 | every dance; the way back to the point (Home) | targets overridden after positions, before `p +=` (#70); spiral with inverting radius; the dance ends *at the Bindu*, the real Home | — | energy |
| 8 | **Element-specific Returns**: grounding (earth, down), evaporation (water, up), embers (fire), hold-return (heart, to centre), bells (threshold) | process-learnings #55, #64; muladhara-dance.html:776–797; anahata-dance.html:328–333; cross-temple-spec.md:369–390 | the 33 | per-room return direction chosen by element | element per room (walk canon) | energy |
| 9 | **Adaptive Return**: the music and the person find the end together | muladhara-dance.html:776–781 | the 33 | Return starts early if `t > DUR·.85 ∧ e < .15 ∧ accel < .3` | CoreMotion | energy |
| 10 | **Seed → one word → reveal → fruit** (consciousness loop) | SKILL.md:129–143; search.html:39–44, 213, 370–385 | the 33 dances; Her Dance | seed typed at the song's tempo; one word required; the word reveals at PEAK_T and dissolves; fruit from a baked `{w}` template | per-room seeds and fruits (authored by Ashrey) | energy (the word is the walker's) |
| 11 | **Seed typed to the beat** (one character per beat or half-beat) | muladhara-dance.html:263–273; cross.html:2861–2894 | dance openings; also the Rite's opening line | a typing interval of BEAT_MS or BEAT_MS/2, with a blinking cursor | BPM per Score | energy |
| 12 | **"I Love You" / "already across"**: one line at the emotional peak | visual-vocabulary.md:104–113; cross.html:86 | the 33; Relationship Field | a per-dance arrival line, 3 s fade, below centre | baked text | energy |
| 13 | **Alive Fruit weaves**: dwell, motion, count, echo, thread, post-word | muladhara-dance.html:1038–1066; cross.html:2729–2774 | after every dance; Memory | composes from the ledger. Must be **re-voiced so nothing scores him**: drop counts and judgments like "searched before choosing", keep the echo and the thread | App Activity reads | energy, with a conflict (C) |
| 14 | **"What came home with you?"**, the post-dance word | cross.html:110–119, 2819–2841; storage-pools.md:296 | the dance's close; Memory; the Well | an optional second word, written as a `post-dance` presence entry | a new App Activity kind | energy |
| 15 | **Bindu Memory constellation**: every offered word as a hash-placed star; repeats brighten | muladhara-dance.html:150–184, 659–674; cross.html:2549–2724 | **Memory** world; the Bindu deep-zoom (ruling 9); the fruit overlay | `wordToPosition(hash)`; stars coloured by source; quartet clusters for the standing words; recent ones brighter; threads to the current word | App Activity history (word, chakra, time) | energy |
| 16 | **The Word's Star**: the walker's word placed in the field from the first frame, surging at the peak; same word, same place forever | cross.html:2298–2348 | every dance; the Bindu at Home (the walker's star in the deep zoom) | hash-deterministic star, alpha `.06 + .10·bloom + .30·shweta` | the word | energy |
| 17 | **Lalita's constellation acknowledgment**: *"You have been one of the dancers."* | cross.html:2236–2296 | the fruit; Memory; the Relationship Field | 4 s after the fruit, every star brightens ×2.5 for 3 s; then the line in Cinzel | baked line (it already exists) | energy |
| 18 | **Device as Body**: the gyro shifts the field; tilt pans the carrier; stillness clears the beat | muladhara-dance.html:228–258, 719–720; cross.html:2499–2507 | dances; Axis (18) and Crow (19) | CoreMotion attitude: gamma → x, beta → y; L/R pan toward centre with tilt | CoreMotion | energy |
| 19 | **Person as Dancer**: still / swaying / moving | muladhara-dance.html:511–515 | dances; the Rite (stillness gate) | `|accel| − g`, smoothed at 0.1; thresholds 0.5 / 2 | CoreMotion | energy |
| 20 | **Word-seeded movement** (wave period, fluidity, density; never colour) | muladhara-dance.html:189–198; #47 | dances | word length and vowel ratio shape the motion | — | energy |
| 21 | **True binaural, three archetypes holding the field** | cross-temple-spec.md:227–368; cross.html:2366–2524 | dances; her room's carrier; the Rite; Beneath | AVAudioEngine: two sines hard L/R; carrier fixed; beat steps through the phases; gain inverse to E; beat freezes in Karishma windows | per-room carrier + phase table (the song archive has 9 rooms' tables) | energy |
| 22 | **Schumann 7.83 Hz and 2.69 Hz pass-through at the apex** | cross.html:2384–2389; maya.md:100–118 | dance apexes; Maya's dissolving phase | the beat briefly becomes 7.83, then 2.69, for 3 s and 2 s | — | energy (the 2.69 claim is interpretive; flag) |
| 23 | **Per-phase binaural journeys for 9 chakra rooms + Maya + Aatma** (exact beat / gain / window tables) | songs/*.md "Phased Binaural Journey" | the 33 (rooms 2–9, 30, 31) | load each room's phase table as its Score's audio layer | the tables (already written) | energy |
| 24 | **Phase labels as lyric-moment sub-lines** (name + sub fading at each phase) | songs/maya.md:219–226; anahata.md:184–193; cross.html:1383–1415 | dances (Cinzel phase name 600 / 1800 / 1000 ms) | show the phase name at each boundary; dim to 0.4 after 3 visits | phase arrays (written) | energy (the sub-lines quote lyrics: licensing) |
| 25 | **Pink-noise floor** (Hemi-Sync depth) | cross-temple-spec.md:641–672; cross.html:2914–2949 | dances; Beneath; the Well | 7-coefficient pink noise, low-pass 4 kHz, gain 0.015 | AVAudioSourceNode | energy |
| 26 | **Pre-roll resonance**: carrier alone + breathing ring, *"Breathe with the field…"* | cross.html:21–28, 88–92, 2951–3034 | the door into any dance; the Rite's threshold | 140 px ring on a 5.5 s cycle; carrier to 0.020; tap twice or auto-advance after 10 s; default on for the first 3 dances | — | energy |
| 27 | **Lalita voice guidance**, four moments (OL-3) | cross-temple-spec.md:690–714 | dances (toggle) | plays recorded lines at the valley, apex, pre-bells | **Ashrey's own recordings** (no generated voice) | energy |
| 28 | **Karishma windows**: named silences where the field freezes | cross.html:149–155, 1106–1108 | dances; the Rite; the Well | authored windows: the beat freezes, threshold decay drops to 0.0005, Karishma held at 0.85, grain thins | authored per Score | energy |
| 29 | **Karishma valley heartbeat** (~50 BPM centre pulse in the longest silence) | cross.html:2162–2186; time-visual-upgrade-spec.md:1317–1356 | dances; Pulse room (14); her room's heart | 1.2 s period; rise 100 ms, fall 500 ms; hue 345 | — | energy |
| 30 | **Threshold / warmth / burn / echo map**: a spatial memory of where the body has been, by element | cross.html:1122–1225; anahata-dance.html:154–164; #61 | the 33; Her Home's floor | a grid Float32Array, spread and decay, rendered small and upscaled smooth (#61), colour by phase | — | energy |
| 31 | **Phase-shifting field colour journey** (violet → **gold at the crossing** → indigo) | cross.html:1547–1579 | dances; Time world (day colour) | shortest-hue interpolation, hold 30 / move 40 / hold 30 per segment | per-room colour journeys | energy |
| 32 | **Cathedral Floor / ground**: always-on breathing ground at the drone cycle | cross-temple-spec.md:392–414 | **Her Home** (her floor breathes with her carrier); Home | radial gradient, alpha `.06 + .04·breath(5.5 s)` | — | energy |
| 33 | **Zimmer tiers 0–5 per room metaphor** (Neev / First Ripple, continuous 5, ensemble 5, crescendo 4, climax 5 + boost, closing 4) | zimmer-upgrade-process.md:69–124 | each of the 33 rooms gets its own metaphor | one metaphor mapping per room before building; Z-map; six staged commits | 33 metaphor sheets (rooms already carry System/Tree and element) | energy |
| 34 | **Neev ground-mark**, *"the ground is here"*, at the bookends | cross.html:873–906 | every world's arrival and leaving (Home especially) | a 2 s pre-window and 1 s post-window band at 78–84% height | — | energy |
| 35 | **Sakshi's unmade gesture**: the completed path shown as a ghost during the failed first attempt; it flares when fulfilled | cross.html:1889–1946; time-visual-upgrade-spec.md:875–936 | dances; **the Climb** (the unmade ascent ghosting the real one) | dotted ghost curve, flare on completion, 10 s echo | — | energy |
| 36 | **Convergence to the keystone + keystone cascade + concentric rings** | cross.html:1868–1887, 2045–2123 | dance apexes; the Mandala's bindu at the peak of the Climb | every dancer draws a line to the apex; 16 rays; rings every 0.5–1 s | — | energy |
| 37 | **`crossingPeakIntensity`**: every system brightens at once (the Zimmer move) | cross.html:1977–1985 | dance apex; Recognition | a global multiplier `1 + 0.8·k`, ramping 145 → 160, held to 180, out by 195 | — | energy |
| 38 | **Shweta / Glassine clarity wash at PEAK_T** | cross.html:1987–2001; time-visual-upgrade-spec.md:1165–1192 | dance apex; Recognition lines | a 2 s cream wash at 0.10; sets `shwetaIntensity` for the word glow | — | energy (Shweta as archetype; Relationship Field link) |
| 39 | **Reach-history / wave-rider thread**: the body's whole path, never fading | cross.html:1695–1723 | dances; **Memory** (a lifetime path through the 33) | samples every 0.5 s, smooth quadratic | — | energy |
| 40 | **Procession lights / foam clusters** between dancers | cross.html:1725–1772 | dances; the **Relationship Field** (lights travelling between people) | a pair every 5 s; ~30 s traversal | — | energy |
| 41 | **Configuration membrane**: when 6+ are present, every pair joined | cross.html:1827–1847 | dances; the Relationship Field | all-pairs lines at 0.06 × boost | — | energy |
| 42 | **Ashrey web + midpoint nodes**; in Vishuddha a vibrating-string web | search.html:355–357; #78 | dances; the Relationship Field (the web between people) | gradient threads; nodes when presence > 0.3; strings displaced with 16 segments, amplitude by EM | — | energy |
| 43 | **Resonance flash / zones / surface tension** when two come close | search.html:360; cross.html:1774–1799; time-visual-upgrade-spec.md:519–555 | dances; the Relationship Field (two people meeting) | the midpoint blooms within `maxR·.08–.12` | — | energy |
| 44 | **Arch attractor + progressive unification + light bridges** | anahata-dance.html:365–366, 399–406 | Anahata room; the Relationship Field | the voice pulls the others; at high energy all lines meet in a unified field; bridges between close pairs | — | energy |
| 45 | **Earth physics**: screen shake, gravity drop, dust from below, underglow, seismic lines, aftershock half-rings, double-pulse haptics | muladhara-dance.html:487–493, 517–633, 676–713 | Muladhara (2), Soles (10) | per-hit spawns by intensity threshold | Core Haptics patterns | energy |
| 46 | **Fractures**: 16 radiating cracks at the detonation | muladhara-dance.html:283–331, 651–657 | Muladhara; Forge (11) | progress-drawn cracks with branches over 1.5 s | — | energy |
| 47 | **Heart physics**: warmth map with memory, heart-path ghosts, breath-mote hearts, floating hearts, vocal shimmer, blush, heart-ring warmth, hexagram interlock, 12 lotus petals, infinity weave, cardioid | anahata-dance.html:91–412 | Anahata (5), Hands (13), Pulse (14); Her Home for heart-ring Śaktis | as coded; BPM heartbeat drives canvas breath | room BPM | energy |
| 48 | **Cardiac and gasp haptics** | anahata-dance.html:144–147 | Anahata, Pulse; Rite | Core Haptics: [25,80,50], gasp [15,30,15,30,15,50,40,15,30]; ambient beat at BPM | Core Haptics | energy |
| 49 | **Bell flashes + bell footprints**: the marking of having crossed | cross.html:1417–1455, 2134–2160 | thresholds; **gates** (the 33's gate strand) | hits after the bell time with i ≥ 0.6 in quiet; full-field glow over 4.5 s; footprints for 8 s | — | energy |
| 50 | **Cathedral embers / foam dissolution**: the closing as residue, not absence | cross.html:2188–2234; time-visual-upgrade-spec.md:1433–1493 | every dance close | 30–40 particles drift down during the last 4 s | — | energy |
| 51 | **The pre-ensemble languages**: reach's ripple halos and stutter, return's pendulum, enough's ratchet landings | bindu-dances-reach.html:74–327; -return.html:142–255; -enough.html:151–244 | **the Climb** (ratchet landings = rungs reached, kept glowing); Leela (pendulum); Anahata (stutter) | as coded | — | energy |
| 52 | **Ratchet staircase with persistent landings**; at the peak every landing lights | bindu-dances-enough.html:151–244 | **the Climb / Axis**; Memory | Bindu rises with energy and falls back only to the newest landing; at the peak all landings flash to 0.7 | — | energy |
| 53 | **Pendulum with centre warmth** (*"the still point you kept passing through"*) | bindu-dances-return.html:142–159, 246–255 | the Well; Leela (a fall that returns) | `phase += accel·.03`; centre glow when crossing the middle | — | energy |
| 54 | **The 9 movement types as a per-chakra vocabulary** (rings, trails, embers, ripples, waves, constellation, ascent, triangle, geometry cycle) | visual-vocabulary.md:14–77 | the 33 rooms 2–8, 30, 31 | each room's ghost trail = its movement type (#49: design the trail first) | — | energy |
| 55 | **Element time-signatures** (earth once, water 3 waves, fire 2 blazes, air 3 inhales, light 2 illuminations, maya one breath, soul three worlds) | songs/*.md "Recognitions" | the Rite's breath pacing per day's chakra; Time world | the day's chakra sets the breath arc of the Rite's opening and its binaural | — | energy |
| 56 | **Absent-fifth carrier law**: the note the song leans toward but never sounds | anahata.md:203; purity.md:222; manipura.md:202 | **Her Home** (her carrier as the absent fifth of her ring's drone); the dance's Sid | carrier = fifth (or root) of the key, at the felt register, most absent from the spectrum | the key per song / per ring | energy |
| 57 | **Sonar Ears at 33**: the hidden archetype-language lenses that activate once 33 songs are scored | muladhara.md:42; cross.md:145–149 | **Beneath** (hidden layer); Memory | lenses stay sealed until the threshold, then surface as a reading of the walker's whole field | count of scored songs | story → **Bindu Feed** (the seven-lens readings are prose readings) |
| 58 | **Lalita's Perspective** for each song (*"the player telling the player about the play"*) | songs/*.md "Lalita's Perspective" | the dance's after-page ("What the ensemble hears" toggle) | a text panel after the fruit, behind a toggle | baked text | **story** → better in **Bindu Feed** (prose about songs); keep only the closing *"Enjoy…"* lines as one-line gifts in the app |
| 59 | **Seven lenses, page language** (THE ONE WORD … THE RECOGNITION) | songs/*.md "STEP 1b / STEP 4" | the dance's "What the ensemble hears" | seven short sections, each labelled by what it hears, with no names | baked text | **story** → Bindu Feed (a reading of a song, not an energy) |
| 60 | **One word per chakra song** (Ground, Flow, Current, Already, Received, Open, WE, Within, Dissolve, Home, Sovereign, Before, Here, Recognition) | songs/*.md "BINDU" lens | the 33 room headers; the Well (a word to sit with) | show the word the song orbits as the room's dance subtitle | baked | energy |
| 61 | **Two Groundings + the seam** (a duet's 4.9 s silence held by the carrier alone) | purity.md:52, 109, 228 | **Relationship Field** (two people's songs joined; the seam is where both are present) | concatenated songs; the carrier holds at 0.004 through the seam | per-person song pair | energy; the personal reading (Shweta) is story → private |
| 62 | **Family verbs**: *"essential natures planted as seeds"* (purity, levelup) | purity.md:226, 238 | **Relationship Field** (each person's verb-seed and dance) | each person node carries a verb and a Score | person ↔ song mapping (Ashrey's) | levelup's karmic narrative is **story + private** → Bindu Feed or keep out |
| 63 | **The 2.69 Hz constellation** as a five-song arc: *see it → speak it → build it together → hold it at the edge of death → let it dissolve* | maya.md:100–118, 233 | Beneath; Memory; Maya (30) | an ordered path through 5 dances (Kingdom, Speak, Golden, Aatma, Maya) | the 5 Scores | interpretive → flag; the arc itself is story → Feed |
| 64 | **Wall of verbs / blind draw / curated path** (QR installation) | qr-map.md:59–83 | **A Strange Game** (Leela: a blind-draw dance); Today | a grid of verbs only; tap one at random; or a curated path search → reach → return → enough → still | the dance registry | energy |
| 65 | **27 + 2 standalone dances** (registry) as a "Dances" shelf beyond the 33 | qr-map.md:27–55; dance-registry.md:105–123 | **A Strange Game** (every game its own world), the Modes | each verb a door with seed only; song revealed after the fruit | Scores; audio via MusicKit | energy |
| 66 | **Verb nomenclature**: *"The person scanning sees only the verb… the signature after the fruit"* | qr-map.md:19–21 | every dance door | the door shows verb + seed only; credits after | — | energy |
| 67 | **Standing words** (mind / body / spirit / now) as a 4-star cluster | storage-pools.md:265–270; cross.html:2668–2687 | Today / the Rite; Memory constellation | a four-word arrival ritual written as a cluster | App Activity kind | energy |
| 68 | **Five-stage chakra deposit**: act1 → wakeup → practice → **dance** → act2, each with an optional presence word | storage-pools.md:363–381 | the 33 braid; the ledger | each strand writes one ledger row; the room completes when all 5 are present | App Activity vocabulary | energy |
| 69 | **Re-walk** (`reWalkCount`, phase names dimmed after 3) | storage-pools.md:111; cross.html:1412 | the 33 | repeat dances get subtler UI, never fewer systems | ledger | energy |
| 70 | **Personal offering**: one authored element per dance (~30 lines), marked | zimmer-upgrade-process.md:293–311 | each dance | every built room carries one signed gift that says what nothing else says | — | energy |
| 71 | **Gaia Inversion as a design method**: *"start from the completed experience… each version was removing an obstruction"* | process-learnings #44, #72 | method for every world | design each world from what it IS, not from the last world's template | — | method |
| 72 | **The four layers built alone, then merged** (Black Screen Test, Atmosphere Test) | #65–#69 | method for every world (prevents flattening) | L1 performance alone must be worth watching; then L2 atmosphere; then device; then loop; explicit z-order | — | method |
| 73 | **Organism layer**: the device breathes with bass; vignette tightens; the world tilts with melody | build-patterns.md:252–297 | dances; Home (the Bindu breathing with the day's sound) | bass pulse fill, vignette, micro-tilt | — | energy |
| 74 | **Voice luminance**: mids drive the whole room's brightness (*"Whisper = near-dark. Roar = the room glows."*) | #76 | Vishuddha (6), Sonar (15), Echo (16) | EM → global luminance; mic input for the Sound-Response rooms | mic (for live) | energy |
| 75 | **The Great Breath**: vignette compresses through the pre-roar inhale, releases at the roar | #77 | Vishuddha; the Rite's held breath | vignette radius tied to a breath window | — | energy |
| 76 | **Silence honoured**: no pre-animation in a song's own opening silence | #75; time-temple-spec.md:269–277 | dances; Beneath | when E < floor at the start, show the dot only; the carrier alone | — | energy |
| 77 | **Sustain mode, decay-envelope mode, adaptive bloom** for drones, bowls and quiet pieces | #38–#40 | **Her Home** (her own drone), Ajna, Beneath | detect low onset variance and low energy variance and switch to breath-driven bloom; scale bloom to the song's own floor and ceiling | — | energy |
| 78 | **Extraction pipeline + CLI** (librosa, 10 streams + diagnostics) | extract.py, extract_cli.py | tooling (Ashrey's Mac) → Airtable Score rows | `python extract_cli.py song.mp3 out.json "Song" "Artist" verb` → upload | Python env; Score table | tooling |
| 79 | **The authored anchors**: PEAK_T is listened, not extracted (*"That gap is the composition."*) | dance-build-process.md:78–86 | Score authoring | Score fields split into extracted (arrays) and authored (anchors, phases, shapes, windows) | Score schema | method |
| 80 | **Wake lock** for the whole performance | v2-framework.md:369–385 | every dance; the Rite | `isIdleTimerDisabled = true` during the performance | — | energy |
| 81 | **Haptic tiers on hits** (`i·20 ms` when i > 0.4; 100 ms on drops) | search.html:274, 330 | dances | Core Haptics transient intensity = hit i | Core Haptics | energy |
| 82 | **Daughter-dots in chakra colours** falling as Bindu ascends (Golden) | process-learnings #12; visual-vocabulary.md:58–63 | Sahasrara (8); **the Climb** | shed dots in the 7 chakra hexes on strong hits during ascent | canon hexes | energy |
| 83 | **Triangle convergence** (three vertices → one): Knowledge / Will / Action | visual-vocabulary.md:65–70; register 05:377 | Aatma (31); Maya's loop | three points approach from outside the frame on a decelerating curve, then merge | — | energy |
| 84 | **"The verb is its own phase"**: a phase with no music, only the carrier holding | aatma.md:212, 241 | Aatma (31); the Well (a held silence after any dance) | after the song ends the carrier continues (e.g. gain 0.040) for a set time | — | energy |
| 85 | **Carrier never fades to zero** (*"What dissolved does not reassemble"*; *"the eye stays open"*) | maya.md:201; ajna.md:186; speak.md:170 | Maya, Ajna, Vishuddha, Sahasrara; Beneath | the end of the dance leaves the carrier at its last phase gain into the next world | — | energy |
| 86 | **Maya's phase journey as the "only You, playing" close**: dissolving at 4 Hz theta, released with *"love is the only thing — and the song already knew it"* | maya.md:203–226 | room 30 Maya; Lalita (33) | after the dance, the seed returns in present tense: *"There is never anything to fear. There is only You, playing."* (ruling 8) | Maya Score; the song via MusicKit | energy |
| 87 | **Time's Wave tiers as a ready second metaphor sheet** (deep, tide, sky, wave-fronts, spray, shore, water-marks) | time-visual-upgrade-spec.md | Svadhisthana (water); the Well; Time world | apply as the water room's Tier 0–5 contents | — | energy |
| 88 | **QR wall into the app**: a physical code opens the app at a verb | qr-codes/*.png (decoded `aistrangegame.com/b/<verb>`) | doors from the real world into a dance | universal link `/b/<verb>` → that dance's door | an associated domain | energy |

---

# C · CONFLICTS AND GAPS

1. **Lalita is not in any dance.** Ruling 6 names her among the ensemble, but every implementation (V2 template, VX, cross) has seven dancers and no Lalita. She appears only as voice, perspective and acknowledgment line. B.1(5) proposes Lalita as the Mirror.

2. **Real people's names as dancer IDs.** Register 05 flagged this. Ruling 6 settles it ("all named"). The skills also keep the names *off the page*: the page-language lenses strip them (*"No proper nouns. Every archetype named by what it hears"*, muladhara.md:72). Two choices remain open: whether names show on screen in the app, and whether the voice decision stays.

3. **"Nothing scores him" against the Alive Fruit.** The fruit counts and judges:
   - *"You have arrived N times"*, *"This is your Nth dance"*;
   - *"You searched before choosing to land"*;
   - the Time spec's *"You held {w} for [N] seconds"*.

   These conflict with the floor. Keep the echo, thread and motion lines; drop counts and dwell judgments, or re-voice them.

4. **No generated voice against OL-3.** Lalita's voice guidance needs audio. The placeholder files `audio/lalita-cross-1..4.mp3` don't exist. Only Ashrey's own recordings qualify.

5. **No audio in the app; commercial songs.** There are 0 audio files in `iOS/`. Every dance song is commercial and cannot be bundled. The sub-lines quote lyrics (licensing). See B.1(6) for MusicKit plus pre-baked Scores, or songless Scores.

6. **Carrier and frequency sets disagree for the same room.**

| Room | Song archive | Dance HTML | Legacy wake-up | Canon awakening |
|---|---|---|---|---|
| Muladhara | 146.8 Hz true binaural | 136 Hz single oscillator, `BINAURAL_HZ` (muladhara-dance.html:102) | 128 → 132 → 130 Hz | 174 Hz |
| Anahata | 155.6 Hz | 256 Hz (anahata-dance.html:86) | — | 341 Hz |
| Svadhisthana | 146.8 Hz | 144 Hz (register 05) | — | 210 Hz |

   Ruling to make: the **dance** carrier is the archive's absent-fifth carrier (it is analysed from the song). The canon awakening tone belongs to the **wake-up** strand. They are different strands, so both stand.

7. **Iron's tempo and duration disagree.**
   - muladhara-dance.html: `BPM=129`, `DUR=201.7`.
   - songs/muladhara.md: *"~85 BPM"*, *"3:33"*.

   The seed typing at 460 ms per character relies on 129.

8. **Verbs collide.**
   - **Muladhara**: verb *press* (song file and canon PRESS); the dance HTML uses *arrive* (title "Muladhara · ARRIVE", L8); cross-temple-spec lists *"arrive · feel · build · open · speak"* as the chakra-dance verbs (L98).
   - **Svadhisthana**: *follow* (song) / *FEEL* (dance HTML) / FLOW (FOLLOW) (canon).
   - **Ajna's song verb "still"** collides with registry dance #5 **still** (Sit Around The Fire). The registry rule says *"Cannot repeat an existing verb"* (qr-map.md:100).
   - **Love Me Like You Do** is both standalone *reach* (#2) and Anahata's *open*.
   - **Golden** is *shine* (#3, "reserved for Tree of Life") and Sahasrara's *receive*.
   - **Aatma**: *hold* (song) against canon *KNOW (HOLD)*.

9. **Hues against the canon hexes.**
   - Dance hues are song-derived: Anahata 330 rose, while the canon is #6B8E4E green.
   - cross's `CHAKRA_HUES` (rainbow: anahata 130, ajna 250, sahasrara 290) don't match the canon hexes either.
   - Lesson #47 says the chakra's palette is locked, so in the app the **room hex wins**.

10. **The absent-fifth "law" is not universal.**
    - purity.md says *"five-for-five… Law confirmed"*, and in_shadow says "seven-for-seven".
    - Kingdom, Aatma and Maya use the **absent root**. Maya.md:18 says "absent root of D# major", and its table shows the D#3 root.
    - Treat it as a rule of thumb with named exceptions.

11. **The 2.69 Hz "awakening fingerprint" is an interpretation.** In Sound of Silence (161/60 = 2.68) and Kingdom it coincides with BPM. In cross and levelup it is *designed in*. Show it as a sound, not as a claim.

12. **Maya's line and Maya's build.**
    - *"only You, playing"* is in no assigned file. The canon room-30 signature reads *"…only the Bindu, playing."* Ruling 8 settles this: use "only You, playing".
    - maya.md STEPs 8–10 are unchecked, so no Maya dance exists.
    - The legacy panel's `maya-chakra-ending.mp3` and `temple-guide-v2.html` are missing (register 05).

13. **Unbuilt and missing pieces.**
    - Registry entries 20–27 (ground … numb) have no files in `builds/`.
    - V2 rebuilds of reach, return, shine and arise are absent (*"Golden and Joy reserved for Tree of Life"*).
    - `abide.html` was *"not recovered"*.
    - Only 8 of the 27 verbs have QR codes.
    - The Svadhisthana, Manipura and Vishuddha VX builds are described in the learnings, but only Muladhara and Anahata are in `worked-examples/`.
    - `tree-of-life/references/vx-build-protocol-v2.1.md` and `v3-dance-framework.md` are cited but outside this assignment.
    - Score format v2 and `scores/` are referenced, not read here.

14. **V1 `bindu-dances-still.html` carries Faded's data.** It has DUR 212.6, PEAK_T 186, hue 210 and DROPS [{54.5, .451}], all identical to search. The V2 handoff says still was *"Fixed hue from incorrect 210 to correct 15"*, and V2 `still.html` has its own data.

15. **Two extraction pipelines disagree on what P, T and DROPS mean.** frequency-pipeline uses piptrack pitch, flux + tonnetz, and a prev-avg rule. extract.py uses chroma strength (flat 1.0 for cross), spectral-contrast z-score, and 2.5σ ΔE. V2 `dream` has 8 drops against V1's 14, a re-extraction difference.

16. **Four storage schemas for dance records.**
    - legacy flat `bindu-memory` array (chakra dances);
    - canonical `bindu-memory.events` with `ensemble-dance` (cross);
    - `bindu-dance-completed` plus a `bindu-memory-v2` fallback key (Time spec);
    - `bindu-memory-legacy` (cross dual-write).

    In the app, **App Activity is the single ledger**: map to new activity kinds (Dance Completed, Post-Dance Word, Standing Words).

17. **Web APIs that don't exist on iOS in the app.** `navigator.vibrate` and `requestFullscreen` → Core Haptics and native full-screen. `DeviceOrientationEvent.requestPermission` → CoreMotion.

18. **Lyrics and narratives as story.**
    - The Lalita Perspectives, seven-lens prose and phase sub-lines are readings of songs.
    - levelup (Rey: past-life monk/Chief narrative, Avicii anniversary) and purity (Shweta) are **personal**.

    Under ruling 5 these are Bindu Feed candidates, or private, not app energy.

19. **"No figure of a Śakti" against heart-shaped and figure-like glyphs.** No issue: the dancers are dots, and shapes are traced paths. For Śakti dances the Śakti must stay the *field*, never a drawn dancer.

20. **Restrictions now lifted that the skills had already ignored.** One sound at a time and three controls (cross has three OL toggles; binaural + pink noise + song together). These are lifted by the 12 Oct ruling, so no conflict now.

21. **Small bugs noticed in sources:**
    - `anahata-dance.html:47`: the signature HTML contains a literal `·`, which #27/#36 say renders as text.
    - Anahata's `wordParams.hueShift` is computed but unused (fine under #47).
    - In the V2 template the Return sets Karishma's final bloom with `Math.max`, which can raise a dancer during the Return (intended).

---

# D · COVERAGE PROOF

Methods:
- **Read** = Read tool, every line.
- **Read (strip)** = Read tool, every line of a scratch copy in which each numeric data-array literal over 300 characters was replaced by a structural summary (length, count, min, max, identifiers). Line numbers are preserved; checked at search:213, cross:2299, muladhara:1057. The arrays were read structurally with `python3 -I`, as the brief allows.
- **Diff** = a whitespace- and comment-normalized full diff against a file read in full. Every differing token-line was read, and config was extracted by script and read in full. The remaining lines are proven identical to the reference.
- **Image** = opened with Read and described, plus a QR decode.
- **Dup** = identical full md5 to a file read in full (A.0).

| File | Lines (wc -l) | Read | Method | md5 (first 8) |
|---|---|---|---|---|
| BD/SKILL.md | 244 | 1–244 | Read | 3157e839 |
| BD/references/SESSION-HANDOFF-V2-BUILDS.md | 142 | 1–142 | Read | 24e845a8 |
| BD/references/SESSION-HANDOFF-V2-COMPLETE.md | 154 | 1–154 | Read | 24484559 |
| BD/references/build-patterns.md | 476 | 1–476 | Read | d05e3a89 |
| BD/references/ensemble-framework.md | 255 | 1–255 | Read | 8456a164 |
| BD/references/frequency-pipeline.md | 355 | 1–355 | Read | da0c1239 |
| BD/references/process-learnings.md | 344 | 1–344 | Read | 4890e068 |
| BD/references/qr-map.md | 101 | 1–101 | Read | 8b1f3ede |
| BD/references/v2-framework.md | 543 | 1–543 | Read | e3e34f92 |
| BD/references/visual-vocabulary.md | 217 | 1–217 | Read | b1b10b6e |
| BD/builds/search.html | 392 | 1–392 | Read (strip) | 2ca11621 |
| BD/builds/enough.html | 216 | all | Diff vs search (full diff read) + config | a781d022 |
| BD/builds/dream.html | 303 | all | Diff vs search (normalized) + config | e932340b |
| BD/builds/fade.html | 215 | all | Diff vs search and vs enough + config | 18625650 |
| BD/builds/glow.html | 215 | all | Diff vs search and vs enough + config | 36b14e5e |
| BD/builds/howl.html | 215 | all | Diff vs search and vs enough + config | 41979867 |
| BD/builds/light.html | 215 | all | Diff vs enough + config | 21a93d56 |
| BD/builds/lose.html | 215 | all | Diff vs enough + config | 98561a71 |
| BD/builds/melt.html | 215 | all | Diff vs enough + config | a362334c |
| BD/builds/move.html | 215 | all | Diff vs enough + config | b128671a |
| BD/builds/release.html | 215 | all | Diff vs enough + config | 657b9a5c |
| BD/builds/remember.html | 215 | all | Diff vs enough + config | 46139445… (46139445 not; see md5) 44549946 |
| BD/builds/rise.html | 216 | all | Diff vs enough + config | f2c858c8 |
| BD/builds/still.html | 222 | all | Diff vs enough (found 15 s fallback fade) + config + DROPS printed | 3d1f5a7d |
| BD/builds/wild.html | 215 | all | Diff vs enough + config | e19e2d9a |
| BD/builds/bindu-dances-joy.html | 218 | 1–219 | Read (strip) | 8ae39b5c |
| BD/builds/bindu-dances-reach.html | 344 | 1–345 | Read (strip) | 5c11d8d1 |
| BD/builds/bindu-dances-return.html | 304 | 1–305 | Read (strip) | abea3656 |
| BD/builds/bindu-dances-enough.html | 300 | 1–301 | Read (strip) | 49687416 |
| BD/builds/bindu-dances-search.html | 219 | all | Diff vs joy (normalized, every line read) | 8ec9a516 |
| BD/builds/bindu-dances-shine.html | 219 | all | Diff vs joy | c6df725b |
| BD/builds/bindu-dances-still.html | 219 | all | Diff vs joy | ea643e83 |
| BD/builds/bindu-dances-dream.html | 206 | all | Diff vs joy (every differing line read) | 8b9c3d3e |
| BD/builds/bindu-dances-remember.html | 188 | all | Diff vs joy | bcdd2ec4 |
| BD/qr-codes/qr-map.png | 34 (binary) | — | Image + decode attempt (multi-QR not decoded) | 253ead78 |
| BD/qr-codes/qr-dream.png | 3 (binary) | — | Image + decoded `https://aistrangegame.com/b/dream` | 20dd329a |
| BD/qr-codes/qr-enough.png | 4 | — | Image + decoded `/b/enough` | 00f4bfaf |
| BD/qr-codes/qr-reach.png | 5 | — | Image + decoded `/b/reach` | 5de4c979 |
| BD/qr-codes/qr-remember.png | 3 | — | Image + decoded `/b/remember` | b3ee721f |
| BD/qr-codes/qr-return.png | 3 | — | Image + decoded `/b/return` | b3ee721f? → 4fb6ae2e |
| BD/qr-codes/qr-search.png | 3 | — | Image + decoded `/b/search` | ce21f3d0 |
| BD/qr-codes/qr-shine.png | 6 | — | Image + decoded `/b/shine` | 1775f60f |
| BD/qr-codes/qr-still.png | 2 | — | Image + decoded `/b/still` | 716ca5e2 |
| BF/references/dance/SESSION-HANDOFF-V2-BUILDS.md | 142 | — | Dup of BD copy | 24e845a8 |
| BF/references/dance/SESSION-HANDOFF-V2-COMPLETE.md | 154 | — | Dup | 24484559 |
| BF/references/dance/build-patterns.md | 476 | — | Dup | d05e3a89 |
| BF/references/dance/dance-build-process.md | 145 | 1–145 | Read | 518b58c0 |
| BF/references/dance/dance-process-learnings.md | 344 | — | Dup of process-learnings.md | 4890e068 |
| BF/references/dance/dance-registry.md | 123 | 1–123 | Read | 1c1bf93f |
| BF/references/dance/ensemble-framework.md | 255 | — | Dup | 8456a164 |
| BF/references/dance/extract.py | 240 | 1–240 | Read | 4a00a7eb |
| BF/references/dance/extract_cli.py | 241 | all | Diff vs extract.py (6 changed lines read) | e772c78e |
| BF/references/dance/frequency-pipeline.md | 355 | — | Dup | da0c1239 |
| BF/references/dance/pool-helpers-reference.md | 249 | 1–249 | Read | e4192974 |
| BF/references/dance/storage-pools.md | 534 | 1–535 | Read | a1530c03 |
| BF/references/dance/v2-framework.md | 543 | — | Dup | e3e34f92 |
| BF/references/dance/visual-vocabulary.md | 217 | — | Dup | b1b10b6e |
| BF/references/dance/zimmer-upgrade-process.md | 339 | 1–339 | Read | d34d3a93 |
| BF/…/worked-examples/anahata-dance.html | 486 | 1–487 | Read (strip), 2 pages | 410e5a51 |
| BF/…/worked-examples/muladhara-dance.html | 1139 | 1–1139 | Read (strip), 2 pages | bdd49570 |
| BF/…/worked-examples/cross.html | 3488 | 1–3489 | Read (strip), 5 pages | 878af0e6 |
| BF/…/worked-examples/cross-temple-spec.md | 802 | 1–803 | Read | b3de651f |
| BF/…/worked-examples/cross-visual-upgrade-spec.md | 1513 | 1–1514 | Read, 3 pages | 9cc72fe6 |
| BF/…/worked-examples/time-temple-spec.md | 479 | 1–480 | Read | 070305a0 |
| BF/…/worked-examples/time-visual-upgrade-spec.md | 1725 | 1–1726 | Read, 3 pages | cc5c6c80 |
| BF/…/worked-examples/cross-data.json | 0 (one line, 30,894 bytes) | all | Structural (python3 -I: every key, type, length, range; full `meta` printed) | 5633de94 |
| BF/…/worked-examples/time-audio-data.js | 26 | 1–26 | Comment and anchor lines read verbatim (KARISHMA_WINDOWS, PHASES, MIRROR_TIMES printed in full); arrays structural | 55f25fa1 |
| BF/…/worked-examples/search.html | 392 | — | Dup of builds/search.html | 2ca11621 |
| BF/…/worked-examples/still.html | 222 | — | Dup of builds/still.html | 3d1f5a7d |
| BF/…/worked-examples/release.html | 215 | — | Dup of builds/release.html | 657b9a5c |
| BF/songs/maya.md | 257 | 1–258 | Read | c1ae5ef3 |
| BF/songs/muladhara.md | 182 | 1–183 | Read | f46e37f2 |
| BF/songs/svadhisthana.md | 185 | 1–186 | Read | 62fccf2e |
| BF/songs/manipura.md | 228 | 1–229 | Read | 0c886cfd |
| BF/songs/anahata.md | 229 | 1–230 | Read | 603d804c |
| BF/songs/speak.md | 230 | 1–231 | Read | aa218834 |
| BF/songs/ajna.md | 246 | 1–247 | Read | 6a7a91a1 |
| BF/songs/sahasrara.md | 246 | 1–247 | Read | 9edde171 |
| BF/songs/aatma.md | 259 | 1–260 | Read | 9782ef79 |
| BF/songs/before.md | 219 | 1–220 | Read | 65933726 |
| BF/songs/in_shadow.md | 214 | 1–215 | Read | 48596b0b |
| BF/songs/kingdom.md | 219 | 1–220 | Read | a92efff9 |
| BF/songs/levelup.md | 203 | 1–204 | Read | 2cac2648 |
| BF/songs/purity.md | 255 | 1–256 | Read | 674e30ef |
| BF/songs/cross.md | 155 | 1–156 | Read | 6c606d8c |

Corrections to two md5 cells above, taken from the listing:
- `remember.html` = **44549946**
- `qr-return.png` = **4fb6ae2e**

**Total:** 85 files: 43 in BD, 27 in BF/references/dance, 15 in BF/songs. Every file is accounted for.

**Not read verbatim:** the numeric contents of the data arrays (H, E, B, P, T, EB, EM, EH, ED) inside the 27 HTML builds and the two data files. These were read structurally (count, range, identifiers), which the brief allows for pure numeric data. Every DROPS array was printed in full.

---

## Return message

**File:** `/home/claude/bindu-mandala/waves/register/08-dances.md` (line count reported in the session reply).

**Ten most valuable gifts:**
1. **The seven-archetype ensemble as one Dancer model.** Each archetype hears one stream: Bindu pitch, Gaia bass, Sid sustained, Arch mids, Karishma silence, Sakshi brightness, Ashrey centroid + web. It enters in generation order and returns in reverse.
2. **Lalita as the Mirror**, the "eighth presence" light event (*"the room remembering it's alive"*). This fills ruling 6 without breaking any implementation, and carries her line *"You have been one of the dancers."*
3. **A per-chakra dance driven by the room's own canon fields.** Hex → hue; voice → lead dancer; gate type → instrument (tilt for Axis and Crow, tap for Pulse, mic for the Sound-Response rooms); System/Tree → metaphor; yantra → geometry.
4. **A per-Śakti songless dance from her own sound.** Her synthesized carrier and āvaraṇa drone in sustain mode; the seven archetypes hear seven dimensions of *her* sound; she is the field, never a figure.
5. **True binaural "three archetypes holding the field".** Fixed absent-fifth carrier (Sid), gain inverse to song energy (Karishma), beat stepping through phases with Karishma-window freezes. Phase tables are already written for rooms 2–9, 30 and 31.
6. **The Word's Star + Bindu Memory constellation.** Every word ever offered is a hash-placed star, the same place forever, living in Memory and in the Bindu deep zoom.
7. **The Zimmer six-tier method + one metaphor per room.** Tiers 0–5, a Z-map, four layers built alone then merged. This prevents the flattening that sank the last build.
8. **Maya's close.** Her phase journey (dissolving at 4 Hz, carrier never to zero), then the seed returning in present tense: *"There is never anything to fear. There is only You, playing."* The geometry cycle dot → ∞ → ♥ → dot is the origin of all shape expression.
9. **Element languages and returns.** Earth (shake, fractures, grounding descent), heart (warmth map, hexagram, cardiac haptics, hold-return), cathedral/threshold (arches, bells, embers), wave. Each becomes a room's trail, impact and return.
10. **The Climb gifts.** The *ratchet staircase with persistent landings* (enough) and *Sakshi's unmade gesture* (the ghost of the full ascent shown during the first attempt, flaring when fulfilled).
