# The verification system — how every wave is proven before merge

*Cross-cutting world of the Bindu Mandala upgrade map (stage 2). Slice: `waves/upgrade/index/by-world/verification.jsonl`, 719 rows, every one placed (section 8). Ledger: `waves/upgrade/ledger/verification.csv`. Written 13 Oct 2026.*

## 1 · The world

### 1.1 What it is, in his words and Design's

The verification system is not a screen of the app. It is the space every wave passes through before it reaches `main`, TestFlight and Neev. It exists because the last build failed here: Waves 1–5 were "verified only by unit tests of Design's numbers and source-reading law tests; never compared with a Design frame; never walked until all of 0–6 shipped together" (`waves/foundation/HANDOFF-2026-10-12.md`). The Reading's central demand was **"check pictures, not numbers, and his eyes between waves"**, and Foundation root cause 4 is "Tests checked laws, not experience — no parity pass against the Claude Design exports".

His four instructions for it (Handoff, "How verification must work from now on"):
1. **A parity ledger**: every design export and frame → its place in the app → a side-by-side render (simulator screenshot beside the Design frame) → his sign-off.
2. **A UI walk test** that reaches every address by every route.
3. **Compile and run on the Mac** before anything ships; small batches; **his walk on Neev** before the next.
4. **Light, sound and motion measured against Design** (brightness ranges, timings), not just counts.

And the ruling of 12 Oct, 20:58: *abundance, not restriction*. Every restriction is lifted **and its tests are rewritten or removed with the build**; the floors stay. A test suite that still enforces "no menu" or "one sound at a time" would fail the upgrade on its own CI, so retiring those tests is part of this world.

Design's words for the same thing (`Claude Design Round 2/homes/Bindu Mandala - the method.md` §8, `The Homes - Verification V3.html`): "Verify what the eye can't reach — and verify backwards." "Not does it load. This runs BACKWARDS from what has been claimed … built to FAIL loudly." "66 checks in nine registers, all 102 Śaktis exercised, 204 rooms rendered. It is built to fail and has, eight times." "The verifier needed verifying." "A screenshot carries almost none of the specification … Build to the numbers, not the frames." And the code's own confession (`FeltRegisterSnapshots.swift`): "Nobody is going to look at these screens before they ship, so it still looks the same has to be a number." The answer now is both: the numbers *and* the pictures, and then his eyes.

Floors this world enforces on every other world: practice data never lost or duplicated; position is identity; App Activity the single ledger; the two Recognition lines verbatim ("she was felt here" / "and she felt you back"); no generated voice; nothing invented; his journals and letters private; no figure of a Śakti; nothing scores him (C-1284 "every light breathes the same, met or not"); accessibility. His own rulings it pins: launch at the Bindu with Today first; Homecoming each launch; chakra 32 sealed; Axis 18, Crow 19; elements Ahaṅ fire, Nāma air, Ātma light, Amṛta water; Maya's last line "only You, playing"; deep zoom kept; dissolutions once a day; Leela ≥3 days apart then 30 %; Rām japa at kp 42; gratitude gently; the 16 Karṣiṇī Functions; the dance names every archetype; the Relationship Field built in full.

### 1.2 The experience of a wave being proven (second by second where it matters)

**Arriving.** A wave begins as a branch `wave/Ux-<name>` with its brief (V49): the Recognition line of each world it touches, the seven open-exploration questions answered ("they go from X to Y"), a five-track score (scene, sound, gesture, motion, logic) with timings, and the list of ledger rows it must turn green. The branch's first commit adds the wave's *red* tests: every new check lands failing against a planted defect (V30) and against the current build.

**Being there — the run, in order.** One Xcode test plan, `Waves`, runs five layers. Each writes verdicts into the ledger, never a bare pass count.

1. **Floors and rulings** (unit, seconds): the kept floor tests (2.3), the ruling tests (V34), the narrow measuring floor (V33), the PracticeStoreContract (V35), the Airtable allow-list and no-TTS scans (V38, V09). A floor failure halts the wave; nothing else does.
2. **Numbers parity** (unit, seconds): Swift constants against Design's literals parsed off disk (V06) — `LR_RECOG`, `LrSigil`, `lrBackdrop`, `syShimmer`, `syBinduBreath`, `RING_CHARACTER`, `FORMS`, `STATION_Z`, `JUST`/`TECHNIQUE`, `EXPECT`. A Design file missing from the bundle is a **FAIL**, not an `XCTSkip` that reads as green.
3. **Light, sound, timing measurements** (unit + offscreen, ~1–3 min): luminance grids of rooms and worlds against Design's bands (V05), offline audio renders with FFT against the Hz tables (V08), keyframe tables and the trace (V07). The Homes V3 port runs here over all 102 at two adaptations (V29, 204 renders).
4. **The automated walk** (XCUITest, ~20–40 min per device class): cold launch → the Bindu → every world by every route (V11–V20), with the padakarshini gate inside every stepped form (V21–V25), screenshots and `.geom` at every step.
5. **Frame parity** (post-process of the walk record, ~1 min): each frame F01–F40 beside the app at the same state — geometry anchors, luminance band, dominant hue, words verbatim (V03–V05) — and the 3–5 feel anchors of each frameless world (V57).

The output is `walk.html`: one row per step — Design frame crop | app screenshot | geometry diff | luminance verdict | a11y verdicts — published as an artifact and committed under `waves/upgrade/ledger/shots/<wave>/`.

**Going deeper — the Mac and Neev.** The run happens on his MacBook in Xcode (V46: click tier, the Bindu Mandala window only, Product → Test with the `Waves` plan; screenshots written by the simulator to `~/BinduWalk/<wave>/<run>` on the host through `SIMULATOR_HOST_HOME`, staged into the session and committed). Then TestFlight, then **his walk on Neev** (iPhone 16 Plus, A18): depth first — three rooms or units of the wave walked, then the rest (V47). He reads the final walk report, not the dossier. His words become the `his-walk` verdicts and DECISIONS.md entries.

**Leaving.** A wave merges to `main` only when: every floor is green; every ledger row the wave touches carries PASS / EXEMPT-with-reason / WAITING-declared (never silent); the walk report is published; and he has walked it. The honest report (V48) goes with the merge: declared / built / surfaced / left behind; rendered / waiting / invalid / skipped; what never executed; expected failures; stale comments fixed.

### 1.3 Visual language and sound of the proof itself

`walk.html` and the ledger pages use the app's own tokens so a frame and its app capture sit on the same ground: ground `#0D0508`, gold `#C9963F`, cream `#F2E8D9`, Cormorant Garamond for names, tracked sans for labels; verdicts as words (PASS / FAIL / EXEMPT / WAITING), never as scores of him. The proof makes no sound; sound is *measured* (V08) and *felt* (V10 on Neev).

### 1.4 The forty frames as parity references — measured 13 Oct 2026

The frames are not phone screenshots: they are Design's desktop canvas captures (JPEG inside `.png` names; 924×540 Axis/Mandala captures, 1400×900 and 1440×842 canvases with a lightbox phone, 460×900 Veil phones). Measuring the whole image measures the canvas (e.g. `ring1-overview` whole-image mean 77.5 vs its phone 12.6). So every frame gets a **crop rect** of its phone, and all numbers below are inside that crop: 64×64 grid, Rec.709 luminance 0–255, dominant hue (chroma-weighted circular mean over pixels with V > .12, S > .25), chroma share. Crop rects are provisional until the first parity run overlays them for one look (V03). Duplicates were md5-checked and are compared once.

Comparison rules for every frame (V04, V05): **geometry** — 3–6 anchors per frame (figure centre, figure radius ÷ width, title baseline ÷ height, text block top, count of marks) within 3 %, or the Design HTML's own DOM `.geom` at 375/402/440 within 2 %; **light** — app mean in [0.8, 1.6] × frame mean (Design is the floor), p95 ≥ frame p95 − 10 %, max ≥ frame max − 15, blown share ≤ frame + 1 %; **hue** — within 15° of the frame (or the Atmosphere hue where "Mandala/Map colours win"); **words** — every in-phone Design line present verbatim in the accessibility tree, except canvas chrome (state captions "1/2", "2/3") and anything that would show a quantity of his practice.

| frame | world | what it is | source file (crop x0,y0,x1,y1) | L min / p5 / mean / p95 / max | hue | chroma % | how it is compared |
|---|---|---|---|---|---|---|---|
| F01 | rings | Ring 2 lotus close-up, Sparsa today | uploads/Screenshot 2026-05-27 at 6.58.14 PM.png (whole) | 2 / 4 / 36.0 / 136 / 235 | 27 | 23.4 | petal count 16; today petal halo; cluster colour order gold/amber/rose-copper/terracotta/teal/sage/violet clockwise from 12; Nama and Bija petals darkest (mapped status) |
| F02 | rings | Ring 8 Mula Trikona three vertex states | uploads/Screenshot 2026-05-27 at 6.58.45 PM.png (whole) | 2 / 3 / 24.9 / 191 / 238 | 337 | 2.5 | three vertices Iccha red ~#C45050 / Jnana lavender / Kriya sea-green; tapped vertex glows; name ~60 px Cormorant italic; gloss lines verbatim |
| F03 | time | Temporal Layer, The Cosmic Now | uploads/Screenshot 2026-05-27 at 7.59.20 PM.png (whole) | 0 / 1 / 6.9 / 31 / 109 | 18 | 0.9 | five concentric wheels; five gold bodies; header and THIS MOMENT block verbatim forms; ring labels must NOT collide (Design defect, do not copy) |
| F04 | climb | Axis seat state, THE SEAT | screenshots/01-axis-states.png [278, 0, 646, 540] | 17 / 18 / 21.9 / 26 / 65 | 30 | 0.3 | one coral point at centre; right-edge rail of gold dots; label THE SEAT beside lit dot |
| F05 | climb | Axis ring state, THE RING | screenshots/02-axis-states.png [278, 0, 646, 540] | 17 / 18 / 22.0 / 26 / 95 | 30 | 0.6 | as F04, point brighter, rail THE RING |
| F06 | climb | duplicate of F05 | screenshots/03-axis-states.png [278, 0, 646, 540] | 17 / 18 / 22.0 / 26 / 95 | 30 | 0.6 | byte-identical to F05 (md5 f101eaf2): compared once as F05 |
| F07 | her-home | Rooms in 3D, Anima (black WebGL capture) | screenshots/3d-01-anima.png (whole) | 0 / 0 / 0.0 / 0 / 9 | None | 0.0 | NOT a look reference (mean 0.0): Anima parity uses Design readPixels range 128-240 (G1-0408), measured in the app by screen capture |
| F08 | mandala | Living Mandala, cosmic tier on indigo | screenshots/01-mandala-chime.png [261, 0, 663, 540] | 0 / 3 / 21.1 / 49 / 179 | 220 | 29.9 | indigo ground hue ~220 (measured 220); full yantra; title + sub verbatim; menu control top-right |
| F09 | mandala | Living Mandala, mid tier | screenshots/02-mandala-chime.png [261, 0, 663, 540] | 0 / 3 / 21.6 / 50 / 179 | 223 | 26.3 | bhupura band fills width; 16-loop petal ring; red glow; indigo ground hue ~223 |
| F10 | home | Bindu to Lalita finale, red bloom | screenshots/chime-flash.png [261, 0, 663, 540] | 1 / 10 / 29.5 / 106 / 223 | 356 | 86.4 | crimson bloom hue ~356 with 86% chroma pixels; gold-white glow; Lalita name ~70 px; caption lines verbatim |
| F11 | climb | Axis Ring 2 tier, 16 seats | screenshots/01-ring.png [278, 0, 646, 540] | 19 / 21 / 27.6 / 35 / 179 | 9 | 99.0 | 16 seat dots in circle, cluster colours; today seat larger and white-labelled; labels ON their dots (Design offset defect not copied) |
| F12 | climb | F11 + harness overlay | screenshots/02-ring.png [278, 0, 646, 540] | 19 / 21 / 27.6 / 35 / 179 | 9 | 99.0 | same pixels as F11 apart from debug overlay: compared once as F11 |
| F13 | climb | Axis seat tier entering a room | screenshots/01-seat.png [278, 0, 646, 540] | 23 / 27 / 30.9 / 37 / 72 | 28 | 100.0 | umber wash, darker vertical shaft, single coral point, rail THE SEAT |
| F14 | her-presence | Recognition at the seat: the two lines + FELT | screenshots/02-seat.png [278, 0, 646, 540] | 4 / 5 / 6.5 / 13 / 154 | 24 | 2.2 | 'she was felt here' ~15 px cream sans above 'and she felt you back' ~24 px gold italic Cormorant, light between, rail FELT; lines verbatim |
| F15 | rings | Ring 4 Lineage resting | scratch/01-r3-gather.png [552, 118, 848, 758] | 5 / 6 / 15.0 / 31 / 78 | 133 | 2.2 | 14-station garland of triangles joined by inward-bowing arcs; green radial ground hue ~133; resting line verbatim |
| F16 | rings | duplicate of F15 | scratch/02-r3-gather.png [552, 118, 848, 758] | 5 / 6 / 15.0 / 31 / 78 | 133 | 2.2 | md5 75ec3436 = F15 |
| F17 | rings | duplicate of F15 | scratch/03-r3-gather.png [552, 118, 848, 758] | 5 / 6 / 15.0 / 31 / 78 | 133 | 2.2 | md5 75ec3436 = F15 |
| F18 | rings | six worlds dropdown | scratch/01-r3-states.png [552, 118, 848, 758] | 5 / 6 / 15.0 / 31 / 78 | 132 | 2.1 | inventory only (canvas chrome): the six Handoff II worlds must each exist in the app |
| F19 | rings | Ring 3 Smoke Lotus gathered | scratch/02-r3-states.png [552, 118, 848, 758] | 2 / 2 / 12.6 / 57 / 88 | 7 | 13.2 | eight blurred rose-copper plumes in a ring (hue ~7); centre hsaum; the Ring Worlds II Ring 3 comparison target (MBB-05) |
| F20 | rings | duplicate of F19 | scratch/03-r3-states.png [552, 118, 848, 758] | 2 / 2 / 12.6 / 57 / 88 | 7 | 13.2 | md5 853f2ebf = F19 |
| F21 | rings | Ring 3 one plume touched | scratch/r3-live.png [552, 118, 848, 758] | 2 / 2 / 10.9 / 36 / 163 | 4 | 12.7 | touched plume bright cream-gold (max 163 vs gathered 88); others dim |
| F22 | rings | Ring 4 transmission in flight | scratch/r3-r4-v2.png [552, 118, 848, 758] | 5 / 6 / 13.4 / 25 / 123 | 133 | 1.8 | one comet light travelling; arcs not yet drawn; max 123 |
| F23 | rings | Ring 4 transmission partway | scratch/r4-live.png [552, 118, 848, 758] | 5 / 6 / 13.4 / 25 / 93 | 134 | 1.9 | arcs drawn clockwise to the receiving station, which glows |
| F24 | rings | Ring 5 Overflow, all ten flooding | scratch/r5-flood.png [552, 118, 848, 758] | 3 / 9 / 23.0 / 41 / 75 | 40 | 31.3 | ten outlined gold triangles; long rays spill past, no boundary circle; amber hue ~40, chroma 31% |
| F25 | rings | Ring 6 Concealed, the light reaching one | scratch/r6-one.png [552, 118, 848, 758] | 2 / 3 / 5.5 / 14 / 68 | 254 | 0.9 | near-black (mean 5.5); a moving glow reveals only near marks; hue from Atmosphere teal 194, not Design violet (Mandala/Map colours win) |
| F26 | rings | Ring 7 Vak chamber, twelve voices at 30 deg | scratch/r7-twelve.png [597, 119, 885, 700] | 3 / 3 / 13.6 / 33 / 106 | 34 | 10.8 | 12 circles evenly at 30 deg with bija + name; centre chord; voices from Airtable Ring 7 (not Design name set); the n-of-12 counter is not carried (floor) |
| F27 | rings | Ring 8 Mula Trikona resting | scratch/r8-check.png [597, 119, 885, 700] | 1 / 2 / 8.5 / 28 / 106 | 0 | 1.9 | Iccha apex red, Jnana bottom-left violet, Kriya bottom-right teal; centre red point; line verbatim |
| F28 | rings | Ring 9 Pravesa start | scratch/r9-descent.png [552, 118, 848, 758] | 1 / 1 / 3.9 / 10 / 54 | 347 | 0.4 | indigo-violet vertical glow, small red point white core (mean 3.9, max 54); hold to fall inward |
| F29 | home | Ring 9 Spanda full bloom = G17 centre bloom | scratch/r9-full.png [552, 118, 848, 758] | 0 / 1 / 7.2 / 33 / 123 | 360 | 6.8 | 16 petal loops + nested red triangles + white Bindu, drawn outward from the point while held; two lines verbatim |
| F30 | rings | Ring 1 Earth-City v1 | scratch/ring1-overview.png [62, 152, 445, 894] | 4 / 7 / 12.6 / 27 / 121 | 33 | 3.8 | superseded by F32 for composition; lines verbatim |
| F31 | rings | Ring 1 v2 iteration | scratch/ring1-v2.png [62, 152, 445, 894] | 4 / 7 / 12.6 / 27 / 121 | 33 | 4.0 | iteration of F30: compared via F32 |
| F32 | rings | Ring 1 v3 latest composition (target) | scratch/ring1-v3.png [62, 152, 445, 894] | 4 / 7 / 12.6 / 29 / 121 | 33 | 4.3 | three nested gold squares with T-gates; 28 gold lights; tiny crimson Bindu; text block clear of the bottom edge |
| F33 | rings | Ring 1 Matrka focus + family legend | scratch/ring1-focus.png [552, 118, 848, 758] | 3 / 6 / 10.9 / 19 / 72 | 34 | 1.7 | family band lit (8 lights); legend Siddhi / Matrka / Mudra |
| F34 | rings | Ring 2 Inhabited Lotus + invocation | scratch/ring2-fix.png [500, 152, 881, 838] | 2 / 3 / 13.6 / 45 / 166 | 22 | 5.4 | long-press today petal: others to ~18%, name + bija + gloss verbatim |
| F35 | rings | mislabelled ring8-fix shows Ring 2 | scratch/ring8-fix.png [500, 152, 881, 838] | 2 / 3 / 13.9 / 47 / 166 | 22 | 5.8 | later pass of F34: stronger halo; compared as F34 alternate |
| F36 | mandala | May-era shipped Mandala with tab bar (NOT a target) | scratch/current-mandala.png [68, 42, 457, 826] | 6 / 7 / 15.1 / 46 / 148 | 25 | 13.7 | negative reference: no progress line (5 of 16 Active), no tab bar laid over the Mandala |
| F37 | mandala | the Veil closed (held yantra) | scratch/veil-rest.png (whole) | 1 / 1 / 6.2 / 20 / 113 | 24 | 3.7 | full held yantra; bottom handle THE NINE AVARANAS; ground near-black (mean 6.2) |
| F38 | mandala | the Veil sheet rising | scratch/veil-open.png (whole) | 1 / 1 / 7.3 / 31 / 112 | 15 | 5.8 | sheet title + DESCEND; yantra dims behind; caption verbatim |
| F39 | mandala | the Veil descending | scratch/veil-descent.png (whole) | 1 / 1 / 6.9 / 26 / 111 | 13 | 5.3 | larger diffuse red Bindu glow, motes |
| F40 | climb | Homes Axis desktop thumbnail (climb chrome) | .thumbnail (whole) | 1 / 16 / 218.7 / 239 / 240 | None | 0.0 | word inventory only (desktop canvas, 320x304): rail of nine body regions, weather sentence, SHE PRESIDES TODAY, control vocabulary; hint must not overlap ENTER HER |

### 1.5 Tests by wave

No upgrade wave order has been fixed yet, so this world proposes one for proof (U0–U10, below). Every test set is keyed to its world: if the master plan orders the worlds differently, each set travels with its world. U0 builds the proof itself and must finish before any world wave merges. Ledger rows carry the wave in `build_action`.

| wave | worlds and scope |
|---|---|
| U0 | **Ground: the verification system itself** - Design corpus + 40 frames into the repo; frames manifest; retire/rewrite every lifted test; keep every floor; World Registry; OPEN_WORLD / FIXTURE_STORE / WALK_OUT / WALK_TRACE; walk driver skeleton; parity engine (geometry, light, numbers, timing, sound); PracticeStoreContract; Airtable allow-list; no-TTS; ruling tests; honest report template; Mac simulator run proven once end to end |
| U1 | **The spine and Home (the Bindu)** - launch at the Bindu, Homecoming each launch, the point everywhere, menu one touch away, search, back-to-where-you-were, nothing laid over, crossings through the point, deep zoom (F10, F29) |
| U2 | **Today/the Rite and Her Presence** - Today first door, Rite day doors widened, Recognition six natures, the two lines (F14), timing of arrival beats and Recognition timeline |
| U3 | **The Mandala, the Veil and the nine rings** - F01, F02, F08, F09, F15-F39 parity; nine metabolisms; ring mechanisms; ring sound techniques |
| U4 | **Her Home and Beneath** - 102 rooms: Homes V3 66-check port complete, room light at Design bands (80-255 class), descent, sister divergence, P10 gate |
| U5 | **The Climb** - F04, F05, F11, F13, F40; WorldClimb numbers read from Design; 102 lights; rail |
| U6 | **The 33** - chakra rooms by form not page, chakra 32 sealed on every route, Axis 18 / Crow 19, Score validator, voice scans |
| U7 | **A Strange Game** - every game its own world, Leela constants, dissolutions once a day, verdict ban, play stores in the contract |
| U8 | **The Modes and Time** - F03 (without its label collision), ephemeris floor, modes at their hours |
| U9 | **Memory and the Well** - Portrait/Living Mandala strokes, river letters, PracticeStoreContract on every store |
| U10 | **The Relationship Field** - V4 migration, Field Connections carried forward, three connections kp 31/40/42 |

| wave | retire / rewrite / change | keep (floors and harness) | new tests and parity checks |
|---|---|---|---|
| **U0** Ground: the verification system itself | all 90 lifted-rule tests (2.2); word/digit half (lifted) (RETIRE (lifted)); catalogue and iconographic-field pins (lifted) (RETIRE (lifted)); HomesCorpus 102-row fixture (REWRITE: replace 86 synthetic rows with the dated verbatim Airtable export (FIXTURE_STORE)); UI Reach base args (REWRITE base args: drop START_TAB, add OPEN_WORLD/FIXTURE_STORE); Launch arguments inventory; no OPEN_WORLD (EXTEND: OPEN_WORLD=<id>, WALK_SEED, FIXTURE_STORE=full, WALK_OUT, WALK_TRACE); TheMarginUITests data safety (KEEP data floors (:115 :193 :303 :350); retire :138 :232); AccessibilityReachTests (KEEP floor; drop the no-numeral clause); FeltRegisterSnapshots engine (KEEP engine; lock stays retired); FeltRegisterClassifications (RETIRE as gate; ClassifiedShift reused as the parity exemption ledger); LawsDrawnMeasureTests (KEEP floor (no arithmetic on counts reaching a view); rewrite two-state part); LawsTheMarginTests (KEEP data half; retire no-count half); HitAreaIdiomTests 44 pt floor (KEEP 44 pt half; retire :220); WaveSixMemoryTests (KEEP stores; retire :233 breath; rewrite :371 deepening); CoherenceTests (RETIRE :17 :44 :99; REWRITE :34 into the World Registry; KEEP :90-95 :106-157); MandalaLightTests (RETIRE :71; REWRITE :143 :158 :188 :506; KEEP 102 distinct colours); MandalaVoiceTests (KEEP floor; retire :147 measure-scan half); ElementTests (REWRITE per ruling 4: light branch; kp 31 fire, 40 air, 42 light, 43 water); Spike suites (performance) (KEEP perf; rewrite one-glow-per-felt-seat census); mandala.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); mandala-descent.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); detail.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); field.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); memory.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); recognition.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); rite.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); settings.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); well.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); well-letter.geom (RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before)); Composition lock retired; its replacement never  (REPLACE with Design-frame parity (V-PAR)) | all 97 floor tests (2.3); Swift lexer and LawSource; practice-symbol half (floor); RecognitionLines harness; no figure of a Sakti (floor); LedgerIsTheRecord vocabulary; TypeScanner legibility harness; SwiftProperties harness; ) retry helper; ScreenReader .geom snapshot engine; Spike performance harness; CI post-clone script; CI pre-xcodebuild script; LawsTests corpus floors and tests; LegibilityTests; DynamicTypeTests; DeviceSlipTests; EphemeralStoreTests and PinnedEnergyTests; ActivityLedgerTests; RecognitionDedupTests; RecognitionMigratorTests; PendingQueuePolicyTests; SchemaMigrationTests; LetterMigrationTests; LetterDraftTests; MarginTests; SilenceDwellTests; DescentMirrorTests; HomeDwellingTests; SeatLightingTests; KhadgamalaMapTests; DailyEnergyServiceTests; RiteCompositionTests; ShaktiBijaTests; MandalaWorldTests | V01 The proof ledger (parity ledger); V02 Design corpus and frames inside the repo; V03 Frames manifest F01-F40; V04 Geometry parity (layout); V05 Light parity (luminance); V06 Numbers parity read from Design files; V07 Timing parity; V08 Sound measurement; V09 Bundled audio is his recordings, byte for byte; V11 World Registry is whole; V18 The walk driver, state and script; V20 Walk record, matrix and report; V21 Padakarshini gate: every step lit; V22 Padakarshini gate: fits the screen; V23 Padakarshini gate: last step reached; V24 Padakarshini gate: 44 pt targets, small marks inside; V25 Padakarshini gate: holds need a real held press or key; V27 Contrast gate; V30 Verify the verifier: every check born red; V33 The narrow measuring floor; V34 Ruling tests; V35 Data floors kept (PracticeStoreContract); V38 Privacy: Airtable read allow-list; V40 Canon chip (review builds only); V41 Bake equals Airtable, to the byte; V44 Accessibility floors run per world inside the walk; V45 Performance per world; V46 Simulator run on his Mac, screenshots into the ledger; V47 His walk on Neev; V48 Honest reports; V49 Wave brief and the loom; V50 The bench (DEBUG only); V51 Defects proved fixed by a test; V57 Look references beyond the forty frames; feel anchors |
| **U1** The spine and Home (the Bindu) | SpikeColdLaunchTests (RETARGET: cold launch to the Bindu first frame); HitAreaTests (KEEP floor; rewrite routes per world); TheWayInUITests walk (KEEP and generalise: route + back-to-where-you-were; retire :349 :424 and no-way-out); TheLibraryFoldUITests (KEEP 'nothing becomes unreachable' generalised to every world; retire the rest); TheWayInTests reachability core (KEEP :62 :226 :246 :502 :519 :753; REWRITE :142 :171; retire :317 :540); OneBuildingTests (KEEP C-1284, :415; rewrite :434 to mixing law) | PositionIsIdentity harness; MandalaLightReachTests spoken field and menu rea; MandalaCameraTests; Settings baseline shows a sheet over the Well | V12 Reachability matrix: every world by every route; V13 UI reachability from a cold launch; V14 Nothing laid over another world; V15 Back to exactly where you were; V16 The point everywhere; V17 Launch arrives at the Bindu; Homecoming each launch; V19 Checks at every walk step; V26 Padakarshini laws as checks; V37 Search; frames F10, F29; design-corpus laws 1-19 as walk expectations (VER-P-01..19) |
| **U2** Today/the Rite and Her Presence | BinduMandalaUITests (REWRITE route: Today reached as first door from the Bindu; keep Recognition floor); DayLightTests (KEEP; READ Design source (LrSigil, lrBackdrop, arrival beats in living-rite-core.jsx)); RiteDayTests (WIDEN doors (keep .oneSecond); keep absence floor; retire digit checks); RecognitionNatureTests (KEEP; READ LR_RECOG from living-rite-core.jsx; rewrite :299); TheLibraryFoldTests (KEEP a11y + writes-nothing; retire drawn-measure and :226) | SomaticRegionTests | frames F14 |
| **U3** The Mandala, the Veil and the nine rings | MandalaYantraTests (KEEP; READ syShimmer/syBinduBreath from living-rite-mandala.jsx; rewrite :277); ShaktiStatusTests (REWRITE: status may change a seat form, never a monotone-with-count brightness ladder); HomeWorldsTests (KEEP; READ RING_CHARACTER/WORLDS from homes-worlds.js) | AtmosphereTests; TimeVariantModulationTests | V32 Ring acceptance (Done-when); frames F01, F02, F08, F09, F15, F18, F19, F21, F22, F23, F24, F25, F26, F27, F28, F30, F32, F33, F34, F35, F36, F37, F38, F39 |
| **U4** Her Home and Beneath | HomeMemoryTests (KEEP compression/headStart/marks; REWRITE fifth gating to an offer); HomesHarnessTests (KEEP; COMPLETE the 66-check port; retire Measuring register); HomesWaveOneTests (KEEP; drop the 'her siddhi is still on the instrument' line (ruling 15)); HomeGrammarTests (KEEP; READ homes-grammar.js); HomeAttributeTests (KEEP; READ FORMS from homes-attribute.js); HomeDescentTests (KEEP words + glissando; READ STATION_Z; retire :203 solids; rewrite :327-339 shallow); HomeSoundTests (KEEP; READ homes-sound.js tables; fifth becomes an offer); RoomSceneTests (KEEP render spine; retire solids + five SurfaceVerbs); RoomCaptureTests (RAISE luminance floors to Design bands; keep blow-out guard); RiteOfEnteringTests (KEEP; retire :267 :608 :644 :822; READ rite-threshold.jsx numbers); CrossingRoomTests (Ring 2) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); SiddhiRoomTests (Ring 1 kp 1-10) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); MatrkaRoomTests (kp 11-18) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); MudraRoomTests (kp 19-28) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); BodilessRoomTests (Ring 3) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); CosmicRoomTests (Ring 4) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); GivingRoomTests (Ring 5) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); RevealingRoomTests (Ring 6) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); SoundingRoomTests (Ring 7) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); SourcingRoomTests (Ring 8) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); GateRoomTests (Laghima kp 3 and Garima kp 4 ('th (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause); DissolveRoomTests (kp 102) (KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause) | Ring fingerprints (sister divergence engine); HomeVoiceTests; WholeInstrumentTests; GateLookTests; Garima spike suites (renderer variants) | V29 Homes Verification V3: 66 checks in nine registers; V31 The room test and the P10 gate; frames F07; Homes V3 checks 1-66 (VER-V3-01..66) |
| **U5** The Climb | WorldClimbTests (reads Design from disk) (KEEP (the model); retire stone-emission-requires-relief; XCTSkip on missing Design file becomes FAIL in the Waves plan); WorldClimbCaptureTests (RAISE bounds to Design bands) | - | frames F04, F05, F11, F13, F40 |
| **U6** The 33 | ChakraConstellationTests (KEEP; retire spoken digit check; rewrite gated crossings; ADD chakra 32 absent from a11y tree); ChakraRoomTests (KEEP verbatim; ADD sealing of road 32 (renders today: defect G7-0477)) | - | V10 Home-felt sound check on Neev; V39 Voice scans of shown text; V42 Score validator (21 rules); V43 Anahata panel checker |
| **U7** A Strange Game | PlayTests (KEEP :520 :542 :23-64; retire :488 :559; rewrite :573); GameStructureTests (KEEP; rewrite :247 :278; PIN minimumGapDays=3 and p=0.30; RETIRE the 'never in the first days' clause (ruling 16)) | PlayWholeTests | - |
| **U8** The Modes and Time | ModesAndRitesTests (KEEP floors; retire digit checks) | EnergyGiftTests; EphemerisTests; LunarPhaseServiceTests | frames F03 |
| **U9** Memory and the Well | TheRiverTests (KEEP floor; retire digit checks) | LivingMandalaTests | - |
| **U10** The Relationship Field | - | - | V36 Relationship Field built in full (test) |

## 2 · Every element, placed

### 2.1 The elements of the verification system

| # | element | what it does (mechanism + numbers) | source (index ids) | status today (code) | reuse / move / new | wave |
|---|---|---|---|---|---|---|
| V01 | The proof ledger (parity ledger) | One CSV per world in waves/upgrade/ledger/ (columns id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by) plus this file's cross-cutting rows. A wave merges only when every row it touches carries a verdict: PASS (with artefact path), FAIL, EXEMPT (with reason, ClassifiedShift-shaped), or WAITING (never silently absent). Generated report per wave: rendered / waiting / invalid / skipped buckets. | G2-0366, G5-0179, G5-0304, G5-0274, G2-0269, G5-0359, G5-0395, G5-0480 | not-built (none (FeltRegisterClassifications.swift has the exemption shape)) | new | U0 |
| V02 | Design corpus and frames inside the repo | Copy every file of /home/claude/design-upload/extracted missing from the repo (28 items: Rooms in 3D + homes-3d-rooms.js/-2.js, rite-*.jsx x6, Living Rite/Axis/Field HTML, Concept Boards, Nine Worlds, Mandala Legend, legend-explorations.jsx, briefs/audits, design_handoff_living_rite/, handoff/, screenshots/ (13 frames), scratch/ (25 frames), uploads/) into 'Claude Design Upload/' and extend SourceTree's expected roots so Xcode Cloud and the Mac read them. Without this, 37 of 40 frames and every rite-*.jsx number are invisible to CI. | G7-0608, G2-0434, G5-0341, G2-0386, G2-0235 | partial (Bindu MandalaTests/SourceTree.swift:11-35 (expects Claude Design Round 2/homes only)) | reuse+extend | U0 |
| V03 | Frames manifest F01-F40 | frames.json committed beside the frames: per frame its source path, md5, crop rect of the phone inside the canvas capture, scale (phone px / 390 pt), world, state to reach in the app (OPEN_WORLD + seed), and the measured bands (64x64 Rec.709 luminance min/p5/mean/p95/max, dominant hue, chroma share, blown share). Values measured 13 Oct are in section 1.4; crop rects are provisional until the first parity run draws them over the frame for one look. | G2-0394, G2-0395, G2-0396, G2-0397, G2-0398, G2-0399, G2-0400, G2-0401, G2-0402, G2-0403, G2-0404, G2-0405, G2-0406, G2-0407, G2-0408, G2-0409, G2-0410, G2-0411, G2-0412, G2-0413, G2-0414, G2-0415, G2-0416, G2-0417, G2-0418, G2-0419, G2-0420, G2-0421, G2-0422, G2-0423, G2-0424, G2-0425, G2-0426, G2-0427, G2-0428, G2-0429, G2-0430, G2-0431, G2-0432, G2-0433 | not-built (none) | new | U0 |
| V04 | Geometry parity (layout) | Design HTML run headless at 375/402/440 wide; DOM walked to role/text/x/y/w/h (.geom format of FeltRegisterSnapshots); the app's accessibility tree dumped the same way at the same state; normaliser digits->#, time->~, 1/4 pt rounding; pass when every Design anchor has an app element of the same text within 2% of width and 2% of height, after scaling. For frames without runnable HTML, 3-6 hand-placed anchors per frame in frames.json (figure centre, figure radius / width, title baseline y / height, text block top) are compared within 3%. Allowed differences recorded as ClassifiedShift(reason) retargeted to 'matches Design'. | G7-0946, G7-0935, G7-0623, G7-0638, G7-0816, G7-0817, G7-0818, G7-0819, G7-0820, G7-0821, G7-0822, G7-0648, G5-0107 | not-built (Bindu MandalaUITests/FeltRegisterSnapshots.swift:449,525 (engine)) | reuse+new | U0 |
| V05 | Light parity (luminance) | App screenshot (XCUIScreen, which sees Metal) cropped to the safe area, resized to 64x64, Rec.709 L = .2126R+.7152G+.0722B. Pass when: app mean within frame mean x[0.8, 1.6] (Design is the floor: brighter allowed, dimmer not); app p95 >= frame p95 - 10%; app max >= frame max - 15; blown share (L>=250) <= frame blown share + 1%; dominant hue within 15 deg of frame hue (or of the Atmosphere hue where Mandala/Map colours win). Rooms: compare against Design readPixels ranges (Anima 128-240, Mahima 46->255, Vasitva 13->197, Mahatripurasundari 24->221, Laghima 73->255, Garima 13->204, Sarva-Yoni 82->255, Trikhanda 42->255; rings 3-9 archetypes Ananga 38-84, cosmic 47-129, giving 31-182, revealing 27-209, sounding 78-198, sourcing 73-204, bindu 43-157). Current bounds mean .01-.9 / spread >.02 admit the audited 11-65 rooms: they go. | G7-0947, G2-0279, G1-0408, G7-1025, G7-0809, G1-0338, G2-0287, G7-0715, G7-1020, G7-1037, G7-0723, G7-0699 | wrong (WorldClimbCaptureTests, RoomCaptureTests, GateLookTests.swift:53 (helpers exist; bounds too low)) | reuse+rewrite | U0 |
| V06 | Numbers parity read from Design files | Tests parse Design's literals off disk (via SourceTree) and assert the Swift constants equal them, both directions: LR_RECOG, lrResp, LrSigil, lrBackdrop (living-rite-core.jsx); syShimmer, syBinduBreath (living-rite-mandala.jsx); RING_CHARACTER, WORLDS, WORLD_SPACING (homes-worlds.js); FORMS (homes-attribute.js); STATION_Z (homes-descent.js); JUST, TECHNIQUE, roots (homes-sound.js); compression/headStart/marks (homes-memory.js); grammar rules (homes-grammar.js); EXPECT (Verification V3.html). Pattern: WorldClimbTests.swift:54-125. A missing Design file is a FAIL in the Waves plan, never an XCTSkip pass. Port values exactly: hex alpha 0D = 5.1%, em tracking x size, damping 0.956 not 0.945. | G7-0945, G7-1036, G7-0722, G5-0048, G2-0188, G2-0170, G6-0783, G2-0204 | partial (WorldClimbTests.swift:54-125 reads Design; 8 suites retype) | reuse+rewrite | U0 |
| V07 | Timing parity | Keyframe tables read from Design and compared to Swift constants (exact); on screen, a DEBUG event trace (WALK_TRACE=1 writes JSON lines {beat, t=CACurrentMediaTime}) read by the walk: nine arrival beats [.10,.25,.40,.55,.70,.80,.90,1.05,1.25] s, dur 1.3, rise 10, sigil .2+2.4=2.6 s; Recognition name .3 / phrase 1.1 / act 1 2.6 / act 2 4.3 / note 5.4 s, collapse .62; Homecoming breath 4 s, blink closes .42; crossing 2.2 s x (1-.88); hold-out 2.2 s; adaptation marks 62/227/347 s; metabolisms ring 1 holds, rings 2-9 3/8/9/11/13/15/18/4 s; Mauna 7 s; stillness 10 s; Tratak onset >10 s. Tolerance: model exact (driven Clock(offset:)); trace +-1 frame (16.7 ms) on Neev-class hardware, +-50 ms on the simulator. | G7-0948, G5-0418, G5-0693, G5-0686 | partial (DayLightTests, RecognitionNatureTests, RiteDayTests (retyped numbers); Spike Clock(offset:)) | reuse+new | U0 |
| V08 | Sound measurement | Offline render of the sound graph (AVAudioEngine manual rendering, 48 kHz stereo, 10 s windows), FFT 65,536 points (0.73 Hz bins, parabolic peak +-0.2 Hz): ring roots 55, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47 Hz; carrier = root x JUST[idx%12] x 2 (Am->110, ka->137.5); initial carrier 136.1, fifth 204.15 (gain .05), air 460; Om 136.1 with partials 272.2 and 68.05, floor <=.05 at depth 9 never a crescendo; awakening 174 / 341 / 528 Hz (never solfeggio 396/417/639/741/852/963); Vak chord of 12; binaural beat = /L-R/ carrier difference per phase; RMS dBFS for gains (ARRIVAL .005-.010, HOME .030-.056). Mixing law replaces one-bed: beds may layer, summed peak <= -1 dBFS, a struck bija ducks the bed (bedUnderAccent) by >= 6 dB within 50 ms, Om stays under the bed. Each room keeps its fixed tone; a song's drone only during its dance. | G7-0933, G7-0695, G6-1071, G4-0113, G4-0577, G4-0565, G7-0696 | partial (HomeSoundTests (constants only); no rendered-audio test exists) | new | U0 |
| V09 | Bundled audio is his recordings, byte for byte | Every bundled mp3 (44 unique from aistrangegame/aistrangegame.com, tree-of-life/<chakra>.mp3 for the nine chakra rooms) matches the sha prefix in waves/register/audio-on-github.md; no AVSpeechSynthesizer or any TTS symbol in production (source scan); his own voice files only from CorrespondenceStore. | G7-0920, G7-0937 | not-built (none) | new | U0 |
| V10 | Home-felt sound check on Neev | STEP 10 see-and-feel: during a HOME phase he toggles the binaural on/off; if the body does not feel the difference, HOME gain +0.010. Recorded in the ledger as his-walk verdict with the gain value. | G4-0567 | not-built (none) | new | U6 |
| V11 | World Registry is whole | One World enum, exactly the fifteen (Home, Today/Rite, Mandala+Veil, nine rings (9 sub-worlds), Her Home, Her Presence, Climb, the 33, A Strange Game (+ each game as sub-world), Modes, Time, Memory, the Well, Beneath, the Relationship Field). Each: sentinel accessibilityIdentifier 'world.<id>', title, threads (kp 1-102 / chakra 1-33 / day), OPEN_WORLD=<id>. Assert count 15, unique sentinels, every case routable. Seeded from CoherenceTests:34's WayIn ring and its spoken labels ('Show the thirty-three chakras', 'Leave the road'). | G7-0923, G7-0734 | not-built (CoherenceTests.swift:34 (six-way ring)) | rewrite | U0 |
| V12 | Reachability matrix: every world by every route | WorldGraph model test: 15 worlds (+ sub-worlds) x routes {point, menu (full index), kp door 1-102 -> Her Home and Her Presence, chakra door 1-33 -> its room, day -> Today/Time, search, Veil, gestures (vertical drag climbs, tilt Mandala<->Climb, left edge out, Codex gestures, the die), back, crossing through the point}. Assert a route exists, <= 3 touches from Home (the climb in one tap per step), never through a lock (his own gates excepted: dissolutions once a day, Leela >=3 days then 30%). Generalises TheWayInTests:62/:171/:502 and PlayTests:99. | G7-0924, G5-0546, G7-0714, G7-0649 | partial (TheWayInTests.swift:62-753; PlayTests.swift:99) | reuse+new | U1 |
| V13 | UI reachability from a cold launch | For each world: cold launch -> menu -> world -> sentinel hittable -> back -> Bindu; then via search and via thread doors. press(until:) (3 attempts) against the digitizer-cancel flake; 'sentinel only on destination'. | G7-0925, G7-0621, G7-0645 | partial (TheWayInUITests.swift:134-327) | reuse+new | U1 |
| V14 | Nothing laid over another world | At every walk step exactly one 'world.*' sentinel is hit-testable. Source scan (LawsTests lexer): no .sheet / .fullScreenCover / .overlay / .popover presents a World root over another World root. Born red: the committed settings.geom ('Your Letters to Them' over the Well) and F36's tab bar are the planted failing cases. | G7-0926, G7-0639 | not-built (SnapshotBaselines/*/settings.geom (evidence)) | new | U1 |
| V15 | Back to exactly where you were | History model test A->B->C, back->B->A, across crossings through the point, background and relaunch (state restored: world, kp/chakra, scroll/zoom tier). UI: TheWayInUITests:134 (room -> back on her Detail with door + phonetic) and :249 (Climb -> back on the Field) generalised to every world pair in the walk script. | G7-0927 | partial (TheWayInUITests.swift:134, :249) | reuse+new | U1 |
| V16 | The point everywhere | On every world 'point.home' present, hittable >= 44 x 44 pt, same screen place +-4 pt across worlds; tap returns to the Bindu through a crossing that blooms from the touch in the colour of the world entered; reduce-motion variant; VoiceOver label. At Home the gentle tap opens silence (OneBuildingTests, 12 Oct) - its own rule. | G7-0928 | not-built (none) | new | U1 |
| V17 | Launch arrives at the Bindu; Homecoming each launch | Cold launch with no START_TAB -> world.home; the first door in reading order is Today (ruling 1). Three cold launches -> three Homecomings (his ruling; no UI test today because every test passes SKIP_HOMECOMING). Dawn/dusk RiteOpening becomes an offer at the door. Cold launch to the Bindu's first frame timed (re-aimed SpikeColdLaunchTests: mean/best/worst of 5). | G7-0929, G7-0922, G7-0641, G7-0806, G7-0807, G7-0808, G2-0147 | wrong (BinduMandalaUITests setUp START_TAB=rite; SpikeColdLaunchTests START_TAB=mandala) | rewrite | U1 |
| V18 | The walk driver, state and script | Driver: TheWayInUITests patterns (press(until:), withdraw-labelled exits, drag-to-rise 0.66->0.18). State: EPHEMERAL_STORE, ENERGY_POS, SKIP_*, AUTO_RECOGNIZE, REDUCE_MOTION + new OPEN_WORLD=<id>, WALK_SEED=<n>, FIXTURE_STORE=full (all 102 rows + 33 chakras from a dated, read-only, verbatim Airtable export; today SYNC_OFF seeds 16 so 86 rooms are unreachable), WALK_OUT=<host dir>, WALK_TRACE=1. Script: steps (route, from, to, expectations) generated from WorldGraph + the canonical Neev walk of 12 Oct: launch -> Bindu -> Today -> Rite -> her Presence -> her Home (with and without the rite) -> out by the edge -> Mandala -> Veil -> ring 4 -> a seat -> Climb -> the 33 -> a chakra room -> its game -> Lalita's field -> Leela -> Modes -> Time -> Memory -> Well (seal a letter) -> Beneath -> Relationship Field -> point -> Bindu. | G7-0938, G7-0939, G7-0940, G7-0622, G7-0625, G7-1026, G7-0619, G5-0045 | partial (TheWayInUITests, AccessibilityReachTests base args, EphemeralStoreTests:85-99) | reuse+new | U0 |
| V19 | Checks at every walk step | Destination sentinel present and only one world hittable; the point present; every control >= 44 pt; no string clipped at AX3XL (large < small x .92 fails); spoken labels named and say no quantity of his practice; text >= 11 pt and >= 0.5 alpha; back returns to the previous world; no runtime warning in the log. | G7-0941 | not-built (logic in HitAreaTests, DynamicTypeReachTests, MandalaVoice) | reuse+new | U1 |
| V20 | Walk record, matrix and report | Every step: XCUIScreen screenshot (keepAlways) + .geom dump + trace slice, written to WALK_OUT (host path via SIMULATOR_HOST_HOME, not a worktree-derived scratch path). Matrix: se 375 / phone 402 / promax 440, x {default, AX3XL, reduce motion}. Output: walk.html, one row per step: Design frame crop / app screenshot / geometry diff / luminance verdict / a11y verdicts. | G7-0942, G7-0943, G7-0944, G7-1040 | not-built (Spike suites write to a worktree-derived path) | new | U0 |
| V21 | Padakarshini gate: every step lit | For every stepped form (a beat per screen, a hold, the moving point, stillness): walk each step; each reports accessibilityValue 'lit' when active; zero unlit steps; zero runtime errors. iOS port of verify_walk.py (Chromium 390x844, scrollIntoView, 120 ms wait, read on/op/h). | G5-0296, G4-0660, G5-0301, G5-0001, G5-0555 | not-built (none (web gate only: verify_walk.py)) | new | U0 |
| V22 | Padakarshini gate: fits the screen | Every step's content bottom <= screen height - 56 pt and step height <= one screen (web: piece bottom <= 744 at 390x800, tall bar 704 at 390x844 - the stricter 704/844 rule wins); no piece taller than ~700 px at 390 wide; text budgets per screen: a beat <= ~70 words, storybook page <= 120, law + because + looks-like <= 60, lists split to three. | G5-0017, G4-0640, G5-0030, G5-0321 | not-built (none) | new | U0 |
| V23 | Padakarshini gate: last step reached | Scroll/advance to the last step and assert the last step is active (N/N reached internally - never shown to him); multi-step jumps go instant then re-sync (scroll-snap-stop lesson); one owner of scrolling (the body-scroll-clip bug that froze #count at 1/N). | G5-0009, G5-0011, G4-0875 | not-built (no SwiftUI corridor exists (paging ScrollView + scrollPosition)) | new | U0 |
| V24 | Padakarshini gate: 44 pt targets, small marks inside | Every tappable seat, petal, bead, node >= 44 x 44 pt; a small visible mark sits inside the 44 pt target (size the target, not the mark); hidden and decorative layers never intercept touches (fixed z-order per world); tap vs trace separated; display links cancelled on exit. | G5-0016, G4-0779, G5-0014, G5-0687, G2-0132, G2-0142, G1-0575 | partial (Hit.min = 44 enum; HitAreaIdiomTests) | reuse | U0 |
| V25 | Padakarshini gate: holds need a real held press or key | Every hold completes only by a real hold of its designed duration, by touch or by a held key (Enter/Space; key repeat ignored); early release drains, never fails, the act waits for the release; a single tap completes a hold only where Design gave it one; reduce motion keeps the duration. UI: press(forDuration: d) completes, press(forDuration: .5d) and tap() do not. Engine test with driven clock: keyDown t0, repeats ignored, keyUp t0+d -> complete; keyUp t0+.5d -> drain, no act. Do not port gen_practice.py holdable() or rk.js (complete instantly on Enter/Space). | G5-0042, G5-0318, G4-0641, G4-0642, G4-0723 | not-built (HoldEngine has no key adapter) | new | U0 |
| V26 | Padakarshini laws as checks | Laws 3-19 of the design corpus become walk expectations where checkable: crossings while the hand keeps asking (3); stillness is an input, a touch pauses never resets (4); staying opens, nothing new locked, deeper turn at ~1 min (5); ceremony closes with a warmer light not a checkmark (6); walk or read as equals - a Read plainly switch turns G1-G8, G10, G11 to text (7); one gesture one register (8); one hint once then silence (9); words at reader's or breath's pace (10); the page knows the day, never counts the reader (11); memory felt and can be let go - forget me always offered (12); nothing staged (13); leaving one gesture everywhere: back, left edge (14); readiness sensed, crossing chosen (15); every place moves as what it is (16); score, test the room, ship with proof (17); going down is one hold that resists then gives (18); play it / read it doors (19). | G4-0639, G4-0643, G4-0644, G4-0645, G4-0646, G4-0647, G4-0648, G4-0649, G4-0650, G4-0651, G4-0652, G4-0653, G4-0654, G4-0655, G4-0656, G4-0657, G4-0658, G4-0659, G5-0047, G5-0587 | not-built (none) | new | U1 |
| V27 | Contrast gate | gate.js ported to a Swift unit test: every seat hex x every ground, accent-as-text via 50% oklab mix (BASE/gate latest; 55% superseded) >= 4.5:1 body, >= 3:1 display (>= 24 pt or >= 18.66 pt bold); cards against their own ground; chrome over gradients with solid ink measured against the pixels actually behind the glyph; every label measured on each world's deepest surface (the brand-home dark-on-dark lesson). | G5-0302, G5-0510 | not-built (none) | new | U0 |
| V28 | Web-only defects not carried | The .light position:fixed freeze, FIGURES.css global restyles, the harness double-loaded dc.js and reserved class names are web defects; the native port carries their lesson as V24 (z-order) and V23 (one scroll owner), nothing else. | G5-0019, G5-0319, G5-0320, G5-0511, G5-0020 | n/a (n/a) | reject (web only) | U0 |
| V29 | Homes Verification V3: 66 checks in nine registers | Native port of homes-verify.js / Verification V3: canon (6), coverage (5), distinction (4), legibility (5), promise (10), felt (7), coherence (9), brief (14), iconography (6) = 66, all 102 Saktis at two adaptations (t=20 near / t=300 deep) = 204 renders; fingerprint t=30; luminance from a 4x4 grid (16 samples) - native: 64x64 grid. Each check listed as its own ledger row (VER-V3-01..66) with its disposition. EXPECT = [28,16,8,14,10,10,12,3,1]. Footer reports the real register count (nine, not the hard-coded 6). | G1-0011, G1-0340, G2-0267, G2-0289, G1-0407, G6-1047, G7-0690, G2-0296, G1-0413, G1-0341, G1-0342, G1-0343, G1-0344, G1-0345, G1-0346, G1-0347, G1-0348, G1-0349, G1-0350, G1-0351, G1-0352, G1-0353, G1-0354, G1-0355, G1-0356, G1-0357, G1-0358, G1-0359, G1-0360, G1-0361, G1-0362, G1-0363, G1-0364, G1-0365, G1-0366, G1-0367, G1-0368, G1-0369, G1-0370, G1-0371, G1-0372, G1-0373, G1-0374, G1-0375, G1-0376, G1-0377, G1-0378, G1-0379, G1-0380, G1-0381, G1-0382, G1-0383, G1-0384, G1-0385, G1-0386, G1-0387, G1-0388, G1-0389, G1-0390, G1-0391, G1-0392, G1-0393, G1-0394, G1-0395, G1-0396, G1-0397, G1-0398, G1-0399, G1-0400, G1-0401, G1-0402, G1-0403, G1-0404, G1-0405, G1-0406 | partial (HomesHarnessTests.swift (runnable slice; geometric divergence, legibility grid, visual coverage, canon 6, iconography 7 absent)) | reuse+port | U4 |
| V30 | Verify the verifier: every check born red | Each new check lands with a planted defect that makes it fail (darken a room 50% -> light parity FAIL; lay Settings over the Well -> nothing-laid-over FAIL; remove the descent -> check 41 FAIL; 15 living attributes sampled by rotation not position). Design's harness was wrong twice (false positive; inert-attribute call) and failed eight times. | G1-0329, G1-0332, G2-0274, G1-0409, G2-0465, G1-0330, G2-0271 | not-built (none) | new | U0 |
| V31 | The room test and the P10 gate | 'Could this room belong to any other Sakti?' Laghima (kp 3) vs Garima (kp 4): different near words, geometry divergence >= 0.5 (Design measured 100%), mean light differs >= 12 (Design 116); adjacent sisters diverge > 0.1; same mechanism differs by world (> 0.02). A stranger tells them apart without a name (his walk). | G1-0045, G2-0240, G5-0163, G1-0331, G2-0273, G7-1019, G1-0244, G1-0245 | built (GateRoomTests.swift; GarimaCanvasSpikeTests.swift:11-210) | reuse | U4 |
| V32 | Ring acceptance (Done-when) | R9 ends in silence; twelve Vak legible at even 30 deg; every R1 light hit first try (>= 44 pt); R6 names reliably; R3 plume visibly glows (F21 max 163 vs gathered 88); compared side by side with Ring Worlds II -> Ring 3 (F19). Seven HO2-01 criteria per ring world (still + interactive frame each). | G2-0143, G2-0066 | partial (ring suites) | reuse | U3 |
| V33 | The narrow measuring floor | Replaces every measuring-word list: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150). Numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' are allowed. Verdict ban (PlayTests:542) and no red as failure (:520) stay. Seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none scales with a count; C-1284 every light breathes the same. | G7-0610, G7-0611, G7-0651, G1-0339, G4-0872, G7-1031, G7-0688 | wrong (LawsTests.swift:543-727, :1316, :1417) | rewrite | U0 |
| V34 | Ruling tests | Dissolutions once per practice day (06:00 boundary); Leela minimumGapDays == 3 and p == 0.30; chakra 32's words never in the accessibility tree on any route (today ChakraRoomView renders them and the bake carries them); Axis = chakra 18, Crow = chakra 19; elements Ahan fire (kp 31), Nama air (40), Atma light (42), Amrta water (43) through Element, RecognitionNature (fire flare, air disperse, light radiate, water pool), room physics and carrier; Maya's last line exactly 'only You, playing'; the 16 Karsini Functions present for kp 29-44; the dance names every archetype (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey, Lalita...); deep zoom (descentTarget 5.4); Ram japa at kp 42; gratitude gently; today 2026-10-12 = day 2477 = kp 82. | G7-0930, G7-1030, G7-1028, G7-1029, G7-0921, G7-0910, G6-0923, G7-0224, G7-0477, G2-0477, G2-0478, G2-0893, G1-0412, G2-0895, G5-0481 | wrong (ChakraRoomView.swift:215-226,491; ChakraConstellation.json:1576-1590; ElementTests.swift:21) | new+fix | U0 |
| V35 | Data floors kept (PracticeStoreContract) | Every store passes one parametrised suite: write before motion, survive a kill, never overwrite, ledger once, restore idempotent; every new world model arrives as schema V4+ ('Add a version; never mutate a shipped one'). Tests never write live App Activity / Codex rows: drive state with a throwaway key, reset to the app's own empty value. | G7-0932, G5-0303, G2-0309 | partial (ActivityLedgerTests ... SchemaMigrationTests:145) | reuse+new | U0 |
| V36 | Relationship Field built in full (test) | V4 model + migration carrying FIELD CONNECTIONS names forward ('She anchors here.', 'She weaves through here.', 'Holds her frequency.') keyed by position, private, ledgered once; the three connections Gaia-Ahankara kp 31, Ashrey-Nama kp 40, Ram-Atma kp 42; no new Airtable fields. | G7-0931 | not-built (Settings FIELD CONNECTIONS (settings.geom)) | new | U10 |
| V37 | Search | Every Sakti found by Sanskrit, romanised or phonetic name (MandalaVoice.romanised folds diacritics incl. decomposed forms), every chakra, game and world; the result opens by position (kp / chakra), never by name. | G7-0934, G7-1015 | not-built (MandalaVoiceTests.swift:223,369,378 (folding exists)) | reuse+new | U1 |
| V38 | Privacy: Airtable read allow-list | AirtableService may read only an allow-list (Mandala, The Map, App Activity, Codex, Gratitude fld85STU49AtREkfe, Relationships for the three connections); Emotions, SJ, Anger, Health, Daily and the rest stay unread unless he opens one; PAT never echoed. | G7-0937, G7-0881, G7-0882, G7-0883, G6-0724 | partial (GratitudeGrace.swift:5-74; ci_post_clone.sh) | new | U0 |
| V39 | Voice scans of shown text | Lint per voice: Bindu never says play, game, recognition, awakening; Sakshi never I or you; Gaia never play, game, higher self; Lalita never names chakras; Higher Self no generic spiritual/therapy language; plus project-jargon scan of every label (P\d, avarana, tattva, mechanism, archetype, grammar, undefined, NaN) and placeholder scan (>= 8 chars, no dangling dot). | G3-0296 | not-built (none) | new | U6 |
| V40 | Canon chip (review builds only) | Composed glue lines carry a dotted 'non-canon' chip (mono 9-10 px) in DEBUG/review builds so every line not from Airtable/Design is visible in screenshots; never in Release. | G5-0386 | not-built (none) | new | U0 |
| V41 | Bake equals Airtable, to the byte | Re-runnable verifier: every field the bundle carries equals the live cell after trimming (walk-canon v1.0, ChakraConstellation.json baked 2026-10-12: 0 drift); canon completeness refuses to bake (all 33 rooms, 13 required fields); the Map's names govern the crossed names; App Activity baseline 160 rows (Mandala 89, Feed 54, Learning 17) for ledger-write verification per world; Link to The Map 0/160 and Walks.App Activity 0 investigated. | G6-0494, G6-0624, G3-0265, G6-0610, G6-0485, G6-0723, G6-0771, G6-0781, G3-0541, G7-0870 | built (Data/ChakraConstellation.json; Data/ActivityLedger.swift) | reuse | U0 |
| V42 | Score validator (21 rules) | validate.py ported as a Swift test over every MandalaScore: required blocks; id ^[a-z][a-z0-9_]*$; times in [0,dur]; phases ordered, no overlap; silences no overlap; peak inside a phase; return < dur; beat_schedule last until null; generation_order the seven; derivation in {absent_fifth, absent_root, present_root, imposed+reason}; R16 HARD no Hz in resonance_link; footprint with silences; warnings R19/R20. Peaks marked needs_listening stay flagged until he listens. | G4-0338, G4-0562, G4-0493, G4-0636, G4-0504 | not-built (scripts/batch/validate.py (104 lines)) | port | U6 |
| V43 | Anahata panel checker | verify-tree-of-life-v2-panel4.sh's 4-pass check ported: autoKnot timings (rings fade + scale 2.5 over 4 s from 3 s; complete by 11 s), 256 Hz with R 262->261->260, awakening 341 Hz, breath swells on exhale, the panel's strings and ids. | G3-0195 | not-built (verify-tree-of-life-v2-panel4.sh (300 lines)) | port | U6 |
| V44 | Accessibility floors run per world inside the walk | Legibility >= 11 pt and >= 0.5 alpha (FIDELITY rule 4; the governing floor over 0.3 and 0.28); Dynamic Type AX3XL, no clip; 44 pt; VoiceOver: every seat named in words, 102 unique ordinals, the canvas Mandala speaks; reduce motion = longer and quantized, never disabled (rooms quantize a in 4 steps, b in 3); pinned exemptions re-pinned per world, and where a Design frame draws a label brighter, parity wins over the exemption (Rite veil name .24). | G1-0597, G7-0900, G7-0901, G7-0902, G7-0903, G7-0904, G7-0905, G7-0906, G7-0907, G7-0908, G7-0909, G2-0597, G2-0106, G2-0126, G2-0442, G2-0320, G2-0140, G7-0096, G7-0097, G7-1041, G7-1035, G2-0310, G1-0410, G6-1070, G2-0333, G2-0339 | partial (LegibilityTests, DynamicTypeTests, HitAreaTests, AccessibilityReachTests, MandalaVoiceTests) | reuse | U0 |
| V45 | Performance per world | SpikeMetrics (phys_footprint, CPU s, CADisplayLink FrameSampler) and census per world; budgets from the spike: still pose < 4 ms, one shadow-casting light, > 15k triangles allowed, light cost ratio < 1.25; cold launch to the Bindu first frame; >= 50 fps (Zimmer floor). Correctness beats the numbers. Simulator numbers are relative only; Neev numbers decide. | G7-0936, G7-0562, G7-0563, G7-0564, G7-0565, G7-0566, G7-0624, G7-0689, G7-1018, G7-0567, G7-0569, G7-0573, G7-0716, G5-0557 | partial (Views/Spike/*.swift (DEBUG)) | reuse | U0 |
| V46 | Simulator run on his Mac, screenshots into the ledger | Xcode on the MacBook (click tier: menus and buttons, Bindu Mandala window only; leave project.pbxproj and .local-branches.bundle uncommitted changes alone): scheme 'Bindu Mandala', test plan 'Waves' (unit + parity + walk), Product > Test. The walk writes to ~/BinduWalk/<wave>/<run> on the host (SIMULATOR_HOST_HOME); that folder is connected to the session, staged into the container, committed to waves/upgrade/ledger/shots/<wave>/ with walk.html, and the ledger rows updated with artefact paths. Xcode Cloud runs the same plan when hours exist (25 h spent this month). Capture the phone as it is before any dev build; never delete or reinstall the app on Neev. | G2-0326, G2-0311, G2-0309, G7-0626, G7-0627, G2-0373 | not-built (ci_scripts/ci_post_clone.sh, ci_pre_xcodebuild.sh) | new | U0 |
| V47 | His walk on Neev | Neev = iPhone 16 Plus (A18). Each wave: the walk report first (one row per step with the Design frame beside the app), then TestFlight, then he walks the wave's worlds; depth first - three rooms/units walked, then the rest. His words go into the ledger's his-walk verdicts and DECISIONS.md. Never advance a wave alone; experience before assessing; four iterations before showing; report after each tier and wait. | G2-0079, G2-0342, G4-0114, G4-0118, G4-0155, G5-0031, G5-0033, G5-0034, G5-0090, G5-0101, G2-0131, G4-0282, G2-0193, G2-0292, G4-0661 | partial (TestFlight 0.1.0 (60)) | reuse | U0 |
| V48 | Honest reports | Every wave report: declared / built / surfaced / left behind; rendered / waiting / invalid / skipped; what never executed, stated plainly; expected failures listed (MudraRoomTests .392 vs .422); stale comments that lie fixed (SilenceDwell.swift:13-14, HomeMemoryStore.swift:18,98, AirtableService.swift:1414, :1699-1707, MarginNote.swift:21-24, RingAudioService.swift:6-11, HomeSoundService.swift:727-729, FIDELITY.md:109, :127-132); presence is not verification, behaviour is not experience - all three passes; 'filled is not rendered'; adversarial pass (prohibitions audit, three cuts); the Sakshi test (the opening reads differently after the closing). | G5-0233, G5-0695, G6-0863, G6-0864, G6-0951, G6-0952, G6-0953, G6-0954, G6-0955, G6-0956, G6-0957, G6-0958, G7-1034, G4-0592, G5-0698, G2-0353, G2-0356, G2-0293, G1-0335, G2-0299, G4-0097 | not-built (none) | new | U0 |
| V49 | Wave brief and the loom | Each wave opens with a brief on its branch (CLAUDE.md skeleton: what is proven, forms/worlds table, register, figure principle, authoring rules, depth-first process, Airtable ids, what was already built). Each world before code: Recognition line first, the seven open-exploration questions ('They go from X to Y'), a five-track score (scene, sound, gesture, motion, logic) with timings - Foundation root cause 3. | G5-0299, G5-0300, G5-0298, G5-0041, G5-0333, G5-0672, G5-0217, G2-0366 | not-built (none) | new | U0 |
| V50 | The bench (DEBUG only) | Review controls outside the device: #if DEBUG state panel (met/unmet day, depth, tier, hour, ground), the screen's Recognition line shown; forced states only by launch arguments in the walk scheme, never by a shipped URL or argument honoured in Release; Rite Tweaks (dilation 1x/3x/12x) is dev-only and shows measurements, so never shipped. Existing args: OPEN_SILENCE, OPEN_DETAIL=, OPEN_RING=. | G5-0082, G1-0456, G7-0025, G7-0657, G5-0574 | partial (Mandala/LivingMandalaView.swift:734-752) | reuse | U0 |
| V51 | Defects proved fixed by a test | Each known defect gets a red test first: name collisions resolve by position (Kamesvari R7/R8, kp 99); Ring 8 triangle larger than its room; Ring 6 veil extinguishes instead of obscures; RD-15 list (motes, hasBeenFelt server-only, silences counted as felt, didSettle jump, queue drops, Detail .mandala, letter editor scenePhase save, ENERGY_POS, hard-coded field connections, ring data typed in Swift, logVerification every sync, spike .metal in Release, kp43 tautology, texture seams); GarimaSceneKitRoom.metal compiled into Release (exclude via membershipExceptions); TemporalMark ignores x/sym; tithiNum 12 for Trayodasi; Veil dims .5 vs .55; MandalaLight off path kept for tests only; anahata literal dot; seed growth timings disagree (2/8/24/72 h vs 3/12/30/80 h); Tree of Life panel bugs (gyro 1.5->4.0 deg/s, impassable Panel 9, warped heart). | G1-0333, G2-0391, G7-0572, G1-0780, G4-0296, G7-0276, G5-0694, G6-0938 | wrong (see each row) | fix+test | U0 |
| V52 | Lifted-rule tests: retire or rewrite | Every test that encodes a lifted restriction is retired or rewritten in U0 or the upgrade fails its own CI: no menu / three controls / six-way ring; one sound at a time; one 8 s breath clock; measuring-word lists; returning-word ban; no images / one chevron / five verbs / no solids; Mudra body words; iconography off screen; gem never colours; a veil that cannot learn; two-state seats; play keeps no store; a room only behind the rite; a day always opening on the Rite; Design's numbers as a ceiling; gating and locks; the composition lock. One ledger row per test (VER-L-*). | G7-0733, G7-0734, G7-0735, G7-0736, G7-0737, G7-0738, G7-0739, G7-0740, G7-0741, G7-0742, G7-0743, G7-0744, G7-0745, G7-0746, G7-0747, G7-0748, G7-0749, G7-0750, G7-0751, G7-0752, G7-0753, G7-0754, G7-0755, G7-0756, G7-0757, G7-0758, G7-0759, G7-0760, G7-0761, G7-0762, G7-0763, G7-0764, G7-0765, G7-0766, G7-0767, G7-0768, G7-0769, G7-0770, G7-0771, G7-0772, G7-0773, G7-0774, G7-0775, G7-0776, G7-0777, G7-0778, G7-0779, G7-0780, G7-0781, G7-0782, G7-0783, G7-0784, G7-0785, G7-0786, G7-0787, G7-0788, G7-0789, G7-0790, G7-0791, G7-0792, G7-0793, G7-0794, G7-0795, G7-0796, G7-0797, G7-0798, G7-0799, G7-0800, G7-0801, G7-0802, G7-0803, G7-0804, G7-0805, G7-0806, G7-0807, G7-0808, G7-0809, G7-0810, G7-0811, G7-0812, G7-0813, G7-0814, G7-0815, G7-0816, G7-0817, G7-0818, G7-0819, G7-0820, G7-0821, G7-0822, G7-0615, G2-0393, G2-0129, G2-0387 | built (wrongly) (see each row) | retire/rewrite | U0 |
| V53 | Floor tests kept | Practice data never lost or duplicated; position is identity; App Activity the single ledger; the two Recognition lines verbatim; nothing invented; journals and letters private; no figure of a Sakti; nothing scores him / absence never a debt; accessibility; his rulings (Leela, Ram japa kp 42, gratitude gently, Ego Reveal sealed, deep zoom). One ledger row per test (VER-F-*). | G7-0823, G7-0824, G7-0825, G7-0826, G7-0827, G7-0828, G7-0829, G7-0830, G7-0831, G7-0832, G7-0833, G7-0834, G7-0835, G7-0836, G7-0837, G7-0838, G7-0839, G7-0840, G7-0841, G7-0842, G7-0843, G7-0844, G7-0845, G7-0846, G7-0847, G7-0848, G7-0849, G7-0850, G7-0851, G7-0852, G7-0853, G7-0854, G7-0855, G7-0856, G7-0857, G7-0858, G7-0859, G7-0860, G7-0861, G7-0862, G7-0863, G7-0864, G7-0865, G7-0866, G7-0867, G7-0868, G7-0869, G7-0870, G7-0871, G7-0872, G7-0873, G7-0874, G7-0875, G7-0876, G7-0877, G7-0878, G7-0879, G7-0880, G7-0881, G7-0882, G7-0883, G7-0884, G7-0885, G7-0886, G7-0887, G7-0888, G7-0889, G7-0890, G7-0891, G7-0892, G7-0893, G7-0894, G7-0895, G7-0896, G7-0897, G7-0898, G7-0899, G7-0900, G7-0901, G7-0902, G7-0903, G7-0904, G7-0905, G7-0906, G7-0907, G7-0908, G7-0909, G7-0910, G7-0911, G7-0912, G7-0913, G7-0914, G7-0915, G7-0916, G7-0917, G7-0918, G7-0919, G2-0265 | built (see each row) | keep (+strengthen) | U0 |
| V54 | Existing suites: disposition one by one | Every existing suite and harness file (iOS/Bindu MandalaTests 87 files, 33,145 lines; Bindu MandalaUITests 10 files, 3,839 lines; SnapshotBaselines 30 .geom) classified: KEEP harness / KEEP floor / KEEP + READ Design / REWRITE / RETIRE. Three kinds in ~37k lines: lifted rules, floors, Design's craft as numbers. One ledger row per suite (VER-S-*). | G7-0609, G7-0610, G7-0611, G7-0612, G7-0613, G7-0614, G7-0615, G7-0616, G7-0617, G7-0618, G7-0619, G7-0620, G7-0621, G7-0622, G7-0623, G7-0624, G7-0625, G7-0626, G7-0627, G7-0628, G7-0629, G7-0630, G7-0631, G7-0632, G7-0633, G7-0634, G7-0635, G7-0636, G7-0637, G7-0638, G7-0639, G7-0640, G7-0641, G7-0642, G7-0643, G7-0644, G7-0645, G7-0646, G7-0647, G7-0648, G7-0649, G7-0650, G7-0651, G7-0652, G7-0653, G7-0654, G7-0655, G7-0656, G7-0657, G7-0658, G7-0659, G7-0660, G7-0661, G7-0662, G7-0663, G7-0664, G7-0665, G7-0666, G7-0667, G7-0668, G7-0669, G7-0670, G7-0671, G7-0672, G7-0673, G7-0674, G7-0675, G7-0676, G7-0677, G7-0678, G7-0679, G7-0680, G7-0681, G7-0682, G7-0683, G7-0684, G7-0685, G7-0686, G7-0687, G7-0688, G7-0689, G7-0690, G7-0691, G7-0692, G7-0693, G7-0694, G7-0695, G7-0696, G7-0697, G7-0698, G7-0699, G7-0700, G7-0701, G7-0702, G7-0703, G7-0704, G7-0705, G7-0706, G7-0707, G7-0708, G7-0709, G7-0710, G7-0711, G7-0712, G7-0713, G7-0714, G7-0715, G7-0716, G7-0717, G7-0718, G7-0719, G7-0720, G7-0721, G7-0722, G7-0723, G7-0724, G7-0725, G7-0726, G7-0727, G7-0728, G7-0729, G7-0730, G7-0731, G7-0732, G7-1024, G7-1042, G6-0959, G6-1078, G6-0783 | built (iOS/Bindu MandalaTests, iOS/Bindu MandalaUITests) | per row | U0 |
| V55 | Prototype chrome and canvas tooling (not ported) | ios-frame.jsx (402x874, island 126x37, 9:41), tweaks-panel.jsx, design-canvas.jsx (bg #f0eee9, 120 px grid), doc-page.js: review tooling, 'do not port'. Their only use here: knowing a frame's canvas chrome so the crop excludes it. | G1-0558, G1-0769, G1-0770, G5-0512 | n/a (n/a) | reject (tooling) | U0 |
| V56 | Historical sequences (superseded) | PR-1..PR-10+, MBB-16, RFB-08 repair order and the BV2 phases are history; Charter II waves and this plan supersede them. Kept only as the record of what each earlier mechanic became. | G1-0581, G2-0154, G2-0138, G2-0317, G2-0351 | n/a (n/a) | reject (history) | U0 |
| V57 | Look references beyond the forty frames; feel anchors | Every world without a frame (six-archetype Today, Her Presence, Recognition natures, the Field, the Well, the Portrait, the Living Rite threshold, room interiors) takes its reference from Design's runnable HTML rendered headless at 402 wide at named states (the prototype parity list: Today; Her Presence; Recognition's six felt-back motions; Mandala; Field; Well; Memory; Threshold/Letter) and from the chakra-corpus screenshots (Bindu room walked; covenant-pool overlay BUG not copied). Each reference carries 3-5 feel anchors (a timing, a light, a motion, a sound, a gesture); four of five is a FAIL ('the missing one is usually the soul'); the running prototype outranks prose. | G2-0927, G2-0191, G5-0126, G2-0935 | not-built (none) | new | U0 |

### 2.2 Every existing test that encodes a lifted rule: retire or rewrite (all in U0)

| ledger id | test (file:line) | lifted rule | action |
|---|---|---|---|
| VER-L-0733 | CoherenceTests.swift:17 | No menu / three quiet controls / six-way ring / nothing listed | Retire |
| VER-L-0734 | CoherenceTests.swift:34 | No menu / three quiet controls / six-way ring / nothing listed | Rewrite as the seed of the World Registry (keep spoken labels 'Show the thirty-three chakras', 'Leave the road') |
| VER-L-0735 | RiteDayTests.swift:21 | No menu / three quiet controls / six-way ring / nothing listed | Widen; keep .oneSecond always offered (a floor of kindness) |
| VER-L-0736 | HitAreaIdiomTests.swift:220 | No menu / three quiet controls / six-way ring / nothing listed | Retire |
| VER-L-0737 | GameStructureTests.swift:247 | One sound at a time | Rewrite as a mixing law: beds may layer; struck bija ducks the bed (keep bedUnderAccent); Om stays a floor never a crescendo (keep TreeOfLife.omFloor <= .05 at depth 9); assert summed-loudness ceiling instead of a count |
| VER-L-0738 | GameStructureTests.swift:278 | One sound at a time | Rewrite as mixing law |
| VER-L-0739 | OneBuildingTests.swift:434 | One sound at a time | Rewrite as mixing law |
| VER-L-0740 | CoherenceTests.swift:99 | One 8 s breath clock | Retire; keep nine metabolisms (ring 1 holds, 2-9 at 3/8/9/11/13/15/18/4 s), Homecoming 4 s, Rite's own pause, Coherence 8 s, each its own clock |
| VER-L-0741 | WaveSixMemoryTests.swift:233 | One 8 s breath clock | Retire |
| VER-L-0742 | LawsTests.swift:1316 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0743 | LawsTests.swift:1417 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0744 | LawsTests.swift NeverMeasure | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0745 | HomesHarnessTests.swift | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0746 | MandalaLightReachTests.swift:152 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0747 | MandalaLightReachTests.swift:315 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0748 | TheWayInUITests.swift:349 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0749 | TheMarginUITests.swift:138 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0750 | TheMarginUITests.swift:232 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0751 | LawsTheMarginTests:2273 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0752 | LawsTheMarginTests:2327 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0753 | MandalaVoiceTests.swift:147 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0754 | RiteOfEnteringTests.swift:608 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0755 | TheWayInTests.swift:317 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0756 | TheWayInTests.swift:540 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0757 | CoherenceTests.swift:44 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0758 | ModesAndRitesTests.swift | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0759 | RiteDayTests.swift | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0760 | TheRiverTests.swift | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0761 | MarginDateTests | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0762 | PlayTests.swift:488 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0763 | TheLibraryFoldUITests.swift:163 | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0764 | TheLibraryFoldTests.swift | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0765 | ChakraConstellation spoken-row checks | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0766 | MandalaVeil spoken-row checks | Measuring-word lists (numbers, ordinals, again, level, progress) | Replace with one narrow FLOOR: no quantity of his practice is shown, spoken or drawn (practiceSymbols, countIdentifiers, no monotone function of a count reaching a view: LawsTests:1340, LawsDrawnMeasureTests:2123/:2150); numbers, ordinals, dates, timers, seat numbers, Design's figures and 'again' become allowed; keep verdict ban (PlayTests:542) and no red as failure (:520) |
| VER-L-0767 | RiteOfEnteringTests.swift:644 | Returning-word ban | Retire (Homecoming already says 'She will greet you again, as on the first day.') |
| VER-L-0768 | TheWayInUITests.swift:424 | Returning-word ban | Retire |
| VER-L-0769 | LawsTests.swift:1741 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0770 | LawsTests.swift:1787 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0771 | LawsTests.swift:1867 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0772 | RecognitionNatureTests.swift:299 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0773 | PlayTests.swift:573 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0774 | HomeDescentTests.swift:203 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0775 | RoomSceneTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0776 | CrossingRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0777 | SiddhiRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0778 | MatrkaRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0779 | MudraRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0780 | BodilessRoomTests.swift:441 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0781 | CosmicRoomTests.swift:576 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0782 | GivingRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0783 | RevealingRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0784 | SoundingRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0785 | SourcingRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0786 | GateRoomTests.swift:126 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0787 | DissolveRoomTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0788 | RiteOfEnteringTests.swift:267 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0789 | RiteOfEnteringTests.swift:822 | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0790 | WorldClimbTests.swift | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0791 | RoomSceneTests five SurfaceVerbs | No images, one-chevron pin, five-verb binding condition, no solids in her layer | Rewrite to the floor only: no figure of a Sakti (figural vocabulary over asset, node and form names; reviewed allow-list of image assets); aniconic check reads node kinds, not solid counts |
| VER-L-0792 | MudraRoomTests.swift | Mudra body-word ban | Retire; keep 'no figure' |
| VER-L-0793 | LawsTests.swift:1830 | Iconography and the Codex Portrait off screens | Retire; iconography prose is not a figure (Detail keeps iconographySection behind 'go deeper', TheLibraryFoldTests:102) |
| VER-L-0794 | MandalaLightTests.swift:71 | Gem never colours | Retire; the gem may colour; keep HomeWorlds diffusion as behaviour |
| VER-L-0795 | MandalaLightTests.swift:188 | A veil that cannot learn | Rewrite: veil may know where he has been; narrow floor: never a completion meter (no fraction/percentage of rings, no monotone-with-count brightness) |
| VER-L-0796 | MandalaYantraTests.swift:277 | A veil that cannot learn | Rewrite as above |
| VER-L-0797 | MandalaLightTests.swift:143 | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0798 | MandalaLightTests.swift:158 | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0799 | MandalaLightTests.swift:506 | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0800 | LawsDrawnMeasureTests.swift:2123 | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0801 | LawsDrawnMeasureTests.swift:2150 | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0802 | SpikeCensusTests | Two-state seats | Rewrite with care: seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count; C-1284 'every light breathes the same, met or not' stays |
| VER-L-0803 | PlayTests.swift:559 | Play keeps no store | Retire; PlayGardenStore and PlayTraceStore exist; fold into PracticeStoreContract |
| VER-L-0804 | TheWayInTests.swift:142 | A room only behind the rite | Rewrite: every door through one door type (HerRoomDoor) but the Rite of entering offered, compressible and skippable |
| VER-L-0805 | TheWayInTests.swift:171 | A room only behind the rite | Rewrite; keep :62, :246, :226, :753 |
| VER-L-0806 | UI tests default START_TAB=rite | A new day always opening on the Rite | Rewrite to ruling 1: launch at the Bindu, Today first door |
| VER-L-0807 | BinduMandalaUITests.swift setUp | A new day always opening on the Rite | Rewrite to ruling 1 |
| VER-L-0808 | RiteOpening.opens | A new day always opening on the Rite | Keep dawn and dusk openings as an offer at the door |
| VER-L-0809 | upper luminance bounds (mean < .9; GarimaCanvasSpike mean < 175) | Design's numbers as a ceiling | Keep blow-out guards; raise floors to Design's |
| VER-L-0810 | HomeSoundTests / HomeMemoryTests.swift:89-122 | Design's numbers as a ceiling | Treat as gating: make it an offer |
| VER-L-0811 | HomeDescentTests.swift:327-339 | Gating and locks | Rewrite: deepening offered, never withheld; every layer has a direct door as well as the slow one; his own rulings (Leela gap, dissolutions once a day) stay |
| VER-L-0812 | WaveSixMemoryTests.swift:371 | Gating and locks | Rewrite: deepening offered, never withheld; every layer has a direct door as well as the slow one; his own rulings (Leela gap, dissolutions once a day) stay |
| VER-L-0813 | HomeMemoryTests.swift:89-122 | Gating and locks | Rewrite: deepening offered, never withheld; every layer has a direct door as well as the slow one; his own rulings (Leela gap, dissolutions once a day) stay |
| VER-L-0814 | TheWayInUITests | Gating and locks | Rewrite: deepening offered, never withheld; every layer has a direct door as well as the slow one; his own rulings (Leela gap, dissolutions once a day) stay |
| VER-L-0815 | ChakraConstellation crossings | Gating and locks | Rewrite: deepening offered, never withheld; every layer has a direct door as well as the slow one; his own rulings (Leela gap, dissolutions once a day) stay |
| VER-L-0816 | FeltRegisterSnapshots.swift:449 | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0817 | FeltRegisterClassifications.swift | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0818 | TheLibraryFoldUITests.swift:438-507 | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0819 | TheLibraryFoldTests.swift:226 | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0820 | HitAreaIdiomTests.swift:220 | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0821 | TheMarginUITests.swift:232 | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |
| VER-L-0822 | SnapshotBaselines 30 .geom | The composition lock | Retire as gates; reuse the engine (ScreenReader, .geom format, displacement metric, EPHEMERAL_STORE, ENERGY_POS pinning) for the automated walk and geometry parity |

Also retired with these: `NeverMeasure` word/digit half (G7-0611), the Aniconic catalogue and iconographic-field pins (G7-0615), the RD-17 retool list (G2-0393: LawsTests, composition lock, binding-condition types, TheWayInTests regexes, RiteOfEnteringTests returning vocabulary, Destination enum, pinned asset catalogue), the stale UX-AUDIT (G2-0129), and the light caps clamp .86 / wash x0.09 / veil -45% (G2-0387).

### 2.3 Every floor test kept (all in U0, strengthened where marked)

| ledger id | test | floor held | strengthen |
|---|---|---|---|
| VER-FL-0823 | ActivityLedgerTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0824 | RecognitionDedupTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0825 | RecognitionMigratorTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0826 | PendingQueuePolicyTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0827 | SchemaMigrationTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0828 | LetterMigrationTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0829 | LetterDraftTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0830 | MarginTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0831 | LawsTheMarginTests (data half) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0832 | SilenceDwellTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0833 | DescentMirrorTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0834 | HomeDwellingTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0835 | HomeMemoryTests (store) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0836 | WaveSixMemoryTests (stores) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0837 | TheRiverTests (kept) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0838 | LivingMandalaTests (strokes) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0839 | ModesAndRitesTests (witness) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0840 | PlayWholeTests.swift:352 | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0841 | EphemeralStoreTests | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0842 | TheMarginUITests (:115, :193, :303) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0843 | RecognitionNatureTests (written before any light moves) | Practice data never lost or duplicated | Every new world's model arrives as schema V4+ (SchemaMigrationTests:145); add a shared PracticeStoreContract test: write before motion, survive a kill, never overwrite, ledger once, restore idempotent |
| VER-FL-0844 | LawsTests.swift:1570-1641 | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0845 | KhadgamalaMapTests | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0846 | SeatLightingTests | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0847 | MandalaWorldTests | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0848 | MandalaLightTests.swift:122 (102 distinct colours) | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0849 | WholeInstrumentTests | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0850 | HomesHarnessTests (kp 99 name collision) | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0851 | GateRoomTests (61 of 102 names drifted) | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0852 | PlayTests.swift:23-64 | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0853 | ChakraConstellationTests | Position is identity | Extend to every world's deep link: routes take kp 1-102 or chakra 1-33, never names |
| VER-FL-0854 | LawsTests.swift:1915-2022 | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0855 | ActivityLedgerTests | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0856 | PlayTests.swift:412 | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0857 | ModesAndRitesTests.swift:288 | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0858 | TheRiverTests.swift:202 | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0859 | ChakraRoomTests (Chakra Practiced) | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0860 | OneBuildingTests (State Set Down, Siddhi Received, Silence Held) | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0861 | HomeDwellingTests | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0862 | GameStructureTests.swift:157 | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0863 | WaveSixMemoryTests (Codex) | App Activity is the single ledger | Every new world event type added to LedgerIsTheRecord.eventVocabulary and nowhere else |
| VER-FL-0864 | LawsTests.swift:1453 | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0865 | LawsTests.swift:1483 | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0866 | LawsTests.swift:1540 | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0867 | BinduMandalaUITests.swift:38 | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0868 | AccessibilityReachTests.swift:481 | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0869 | RecognitionNatureTests timeline | The two Recognition lines verbatim | Keep unchanged |
| VER-FL-0870 | ShaktiBijaTests | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0871 | RiteCompositionTests.swift:41 | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0872 | HomeDescentTests (empty never invented) | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0873 | ModesAndRitesTests.swift:211 (Carry nil) | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0874 | SomaticRegionTests.swift:64 | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0875 | RecognitionMigratorTests.swift:34 | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0876 | HomesCorpus provenance | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0877 | EphemerisTests (published values) | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0878 | ChakraRoomTests verbatim | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0879 | GameStructureTests bake | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0880 | PlayTests seats read off the table | Nothing invented (bijas, baked words verbatim) | Add a verbatim check for every bake against its Airtable export date |
| VER-FL-0881 | CoherenceTests.swift:106 (GratitudeGrace one table one field fetch only) | His journals and letters private | Add: AirtableService may read only an allow-list of tables; Emotions, SJ, Anger, Health and the rest unread unless he opens one |
| VER-FL-0882 | ci_post_clone.sh (PAT never echoed) | His journals and letters private | Add: AirtableService may read only an allow-list of tables; Emotions, SJ, Anger, Health and the rest unread unless he opens one |
| VER-FL-0883 | ModesAndRitesTests LowStateDoor | His journals and letters private | Add: AirtableService may read only an allow-list of tables; Emotions, SJ, Anger, Health and the rest unread unless he opens one |
| VER-FL-0884 | LawsTests.swift:856 Aniconic figural vocabulary | No figure of a Sakti | Rewrite as the images row: figure-only floor |
| VER-FL-0885 | HomeAttributeTests.swift:304 | No figure of a Sakti | Rewrite as the images row: figure-only floor |
| VER-FL-0886 | RoomSceneTests (no figural node) | No figure of a Sakti | Rewrite as the images row: figure-only floor |
| VER-FL-0887 | RecognitionNatureTests.swift:299 | No figure of a Sakti | Rewrite as the images row: figure-only floor |
| VER-FL-0888 | PlayTests.swift:573 | No figure of a Sakti | Rewrite as the images row: figure-only floor |
| VER-FL-0889 | LawsTests.swift:1340 | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0890 | LawsDrawnMeasureTests | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0891 | OneBuildingTests C-1284 | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0892 | RiteDayTests.swift:148 ('Nothing was asked of you today.') | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0893 | PlayTests.swift:520 | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0894 | PlayTests.swift:542 | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0895 | TheRiverTests.swift:150 (Wager) | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0896 | ModesAndRitesTests.swift:104 (Smrti one light) | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0897 | RiteDayTests.swift:116 (grace never of today) | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0898 | GameStructureTests.swift:232 (ThreePools state not tally) | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0899 | TheLibraryFoldTests.swift:152 | Nothing scores him; absence never a debt | Keep; the narrowed replacement for the measuring ban |
| VER-FL-0900 | LegibilityTests | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0901 | DynamicTypeTests | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0902 | HitAreaIdiomTests (44 pt half) | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0903 | HitAreaTests | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0904 | AccessibilityReachTests | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0905 | MandalaVoiceTests | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0906 | DeviceSlipTests (reduce motion) | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0907 | every room's reduce-motion test | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0908 | TheMarginUITests.swift:350 | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0909 | TheLibraryFoldUITests.swift:370 | Accessibility | Run the a11y floors per world inside the automated walk, not per screen file |
| VER-FL-0910 | GameStructureTests.swift:115-146 | Ruling: Leela drops >= 3 days apart then 30% | Pin constants minimumGapDays == 3 and drop probability == 0.30 (neither asserted today); test also forbids drops in the first days after install (firstSeenDay) - stricter than the ruling; confirm with him |
| VER-FL-0911 | CoherenceTests.swift:90 | Ruling: Ram japa at kp 42 | Keep |
| VER-FL-0912 | PlayTests.swift:51 | Ruling: Ram japa at kp 42 | Keep |
| VER-FL-0913 | PlayTests.swift:80 | Ruling: Ram japa at kp 42 | Keep |
| VER-FL-0914 | ChakraRoomTests (road 5) | Ruling: Ram japa at kp 42 | Keep |
| VER-FL-0915 | CoherenceTests.swift:106-157 | Ruling: gratitude gently | Keep |
| VER-FL-0916 | GameStructureTests.swift:43-46 (never a Leela drop) | Ruling 2: Ego Reveal sealed | Add: chakra 32's words never in the accessibility tree on any route; shadowTranslator sits at 'The Map: Ego Reveal' (kp 101, PlayTests:48) - check its words |
| VER-FL-0917 | ChakraConstellationTests (Sanskrit nil) | Ruling 2: Ego Reveal sealed | Add: chakra 32's words never in the accessibility tree on any route; shadowTranslator sits at 'The Map: Ego Reveal' (kp 101, PlayTests:48) - check its words |
| VER-FL-0918 | MandalaCameraTests (descentTarget 5.4) | Ruling 9: deep zoom into the Bindu | Keep |
| VER-FL-0919 | OneBuildingTests.swift:415 (Pravesha never reaches a bottom) | Ruling 9: deep zoom into the Bindu | Keep |

### 2.4 Every existing suite and harness: disposition

| ledger id | suite / harness | kind today | disposition | wave |
|---|---|---|---|---|
| VER-S-0609 | Test harness: Swift lexer and LawSource | verification | KEEP harness | U0 |
| VER-S-0610 | NeverMeasure: practice-symbol half (floor) | floor | KEEP floor | U0 |
| VER-S-0611 | NeverMeasure: word/digit half (lifted) | defect | RETIRE (lifted) | U0 |
| VER-S-0612 | RecognitionLines harness | floor | KEEP floor | U0 |
| VER-S-0613 | PositionIsIdentity harness | floor | KEEP floor; extend to every world route (kp/chakra, never names) | U1 |
| VER-S-0614 | Aniconic: no figure of a Sakti (floor) | floor | KEEP floor; read node kinds not solid counts | U0 |
| VER-S-0615 | Aniconic: catalogue and iconographic-field pins (lifted) | defect | RETIRE (lifted) | U0 |
| VER-S-0616 | LedgerIsTheRecord vocabulary | floor | KEEP floor; every new world event type added here only | U0 |
| VER-S-0617 | TypeScanner legibility harness | verification | KEEP harness (a11y) | U0 |
| VER-S-0618 | SwiftProperties harness | verification | KEEP harness | U0 |
| VER-S-0619 | HomesCorpus 102-row fixture | verification | REWRITE: replace 86 synthetic rows with the dated verbatim Airtable export (FIXTURE_STORE) | U0 |
| VER-S-0620 | Ring fingerprints (sister divergence engine) | verification | KEEP: sister-divergence engine for every room | U4 |
| VER-S-0621 | UI press(until:) retry helper | verification | KEEP walk helper | U0 |
| VER-S-0622 | UI Reach base args | verification | REWRITE base args: drop START_TAB, add OPEN_WORLD/FIXTURE_STORE | U0 |
| VER-S-0623 | ScreenReader .geom snapshot engine | verification | KEEP engine for walk + geometry parity | U0 |
| VER-S-0624 | Spike performance harness | verification | KEEP harness: performance per world | U0 |
| VER-S-0625 | Launch arguments inventory; no OPEN_WORLD | verification | EXTEND: OPEN_WORLD=<id>, WALK_SEED, FIXTURE_STORE=full, WALK_OUT, WALK_TRACE | U0 |
| VER-S-0626 | CI post-clone script | floor | KEEP floor (secrets out of logs) | U0 |
| VER-S-0627 | CI pre-xcodebuild script | verification | KEEP | U0 |
| VER-S-0640 | UI: BinduMandalaUITests | floor | REWRITE route: Today reached as first door from the Bindu; keep Recognition floor | U2 |
| VER-S-0641 | UI: SpikeColdLaunchTests | verification | RETARGET: cold launch to the Bindu first frame | U1 |
| VER-S-0642 | UI: HitAreaTests | floor | KEEP floor; rewrite routes per world | U1 |
| VER-S-0643 | UI: MandalaLightReachTests spoken field and menu reach | floor | KEEP spoken field; generalise menu reach to every world; pixel-diff seeds light parity | U1 |
| VER-S-0644 | UI: TheMarginUITests data safety | floor | KEEP data floors (:115 :193 :303 :350); retire :138 :232 | U0 |
| VER-S-0645 | UI: TheWayInUITests walk | verification | KEEP and generalise: route + back-to-where-you-were; retire :349 :424 and no-way-out | U1 |
| VER-S-0646 | UI: AccessibilityReachTests | floor | KEEP floor; drop the no-numeral clause | U0 |
| VER-S-0647 | UI: FeltRegisterSnapshots engine | verification | KEEP engine; lock stays retired | U0 |
| VER-S-0648 | UI: FeltRegisterClassifications | defect | RETIRE as gate; ClassifiedShift reused as the parity exemption ledger | U0 |
| VER-S-0649 | UI: TheLibraryFoldUITests | verification | KEEP 'nothing becomes unreachable' generalised to every world; retire the rest | U1 |
| VER-S-0650 | LawsTests corpus floors and tests | verification | KEEP corpus floors (re-pin as the corpus grows) | U0 |
| VER-S-0651 | LawsDrawnMeasureTests | floor | KEEP floor (no arithmetic on counts reaching a view); rewrite two-state part | U0 |
| VER-S-0652 | LawsTheMarginTests | floor | KEEP data half; retire no-count half | U0 |
| VER-S-0653 | LegibilityTests | floor | KEEP floor (>=11 pt, >=0.5 alpha); re-pin exemptions per world | U0 |
| VER-S-0654 | DynamicTypeTests | floor | KEEP floor | U0 |
| VER-S-0655 | HitAreaIdiomTests 44 pt floor | floor | KEEP 44 pt half; retire :220 | U0 |
| VER-S-0656 | DeviceSlipTests | floor | KEEP floor | U0 |
| VER-S-0657 | EphemeralStoreTests and PinnedEnergyTests | floor | KEEP floor | U0 |
| VER-S-0658 | ActivityLedgerTests | floor | KEEP floor | U0 |
| VER-S-0659 | RecognitionDedupTests | floor | KEEP floor | U0 |
| VER-S-0660 | RecognitionMigratorTests | floor | KEEP floor | U0 |
| VER-S-0661 | PendingQueuePolicyTests | floor | KEEP floor | U0 |
| VER-S-0662 | SchemaMigrationTests | floor | KEEP floor; every new model arrives V4+ | U0 |
| VER-S-0663 | LetterMigrationTests | floor | KEEP floor | U0 |
| VER-S-0664 | LetterDraftTests | floor | KEEP floor | U0 |
| VER-S-0665 | MarginTests | floor | KEEP floor | U0 |
| VER-S-0666 | SilenceDwellTests | floor | KEEP floor | U0 |
| VER-S-0667 | DescentMirrorTests | floor | KEEP floor | U0 |
| VER-S-0668 | HomeDwellingTests | floor | KEEP floor | U0 |
| VER-S-0669 | HomeMemoryTests | verification | KEEP compression/headStart/marks; REWRITE fifth gating to an offer | U4 |
| VER-S-0670 | WaveSixMemoryTests | verification | KEEP stores; retire :233 breath; rewrite :371 deepening | U0 |
| VER-S-0671 | SeatLightingTests | floor | KEEP floor | U0 |
| VER-S-0672 | KhadgamalaMapTests | floor | KEEP floor | U0 |
| VER-S-0673 | DailyEnergyServiceTests | floor | KEEP floor; add vector 2026-10-12 -> day 2477 -> kp 82 | U0 |
| VER-S-0674 | DayLightTests | verification | KEEP; READ Design source (LrSigil, lrBackdrop, arrival beats in living-rite-core.jsx) | U2 |
| VER-S-0675 | RiteCompositionTests | floor | KEEP floor | U0 |
| VER-S-0676 | RiteDayTests | verification | WIDEN doors (keep .oneSecond); keep absence floor; retire digit checks | U2 |
| VER-S-0677 | ShaktiBijaTests | floor | KEEP floor | U0 |
| VER-S-0678 | CoherenceTests | verification | RETIRE :17 :44 :99; REWRITE :34 into the World Registry; KEEP :90-95 :106-157 | U0 |
| VER-S-0679 | EnergyGiftTests | verification | KEEP | U8 |
| VER-S-0680 | MandalaCameraTests | verification | KEEP (ruling 9) | U1 |
| VER-S-0681 | MandalaWorldTests | floor | KEEP floor | U0 |
| VER-S-0682 | MandalaYantraTests | verification | KEEP; READ syShimmer/syBinduBreath from living-rite-mandala.jsx; rewrite :277 | U3 |
| VER-S-0683 | MandalaLightTests | verification | RETIRE :71; REWRITE :143 :158 :188 :506; KEEP 102 distinct colours | U0 |
| VER-S-0684 | MandalaVoiceTests | floor | KEEP floor; retire :147 measure-scan half | U0 |
| VER-S-0685 | AtmosphereTests | verification | KEEP | U3 |
| VER-S-0686 | ElementTests | verification | REWRITE per ruling 4: light branch; kp 31 fire, 40 air, 42 light, 43 water | U0 |
| VER-S-0687 | TimeVariantModulationTests | verification | KEEP | U3 |
| VER-S-0688 | ShaktiStatusTests | verification | REWRITE: status may change a seat form, never a monotone-with-count brightness ladder | U3 |
| VER-S-0689 | Spike suites (performance) | verification | KEEP perf; rewrite one-glow-per-felt-seat census | U0 |
| VER-S-0690 | HomesHarnessTests | verification | KEEP; COMPLETE the 66-check port; retire Measuring register | U4 |
| VER-S-0691 | HomesWaveOneTests | verification | KEEP; drop the 'her siddhi is still on the instrument' line (ruling 15) | U4 |
| VER-S-0692 | HomeGrammarTests | verification | KEEP; READ homes-grammar.js | U4 |
| VER-S-0693 | HomeAttributeTests | verification | KEEP; READ FORMS from homes-attribute.js | U4 |
| VER-S-0694 | HomeDescentTests | verification | KEEP words + glissando; READ STATION_Z; retire :203 solids; rewrite :327-339 shallow | U4 |
| VER-S-0695 | HomeSoundTests | verification | KEEP; READ homes-sound.js tables; fifth becomes an offer | U4 |
| VER-S-0696 | HomeVoiceTests | floor | KEEP floor | U4 |
| VER-S-0697 | HomeWorldsTests | verification | KEEP; READ RING_CHARACTER/WORLDS from homes-worlds.js | U3 |
| VER-S-0698 | RoomSceneTests | verification | KEEP render spine; retire solids + five SurfaceVerbs | U4 |
| VER-S-0699 | RoomCaptureTests | verification | RAISE luminance floors to Design bands; keep blow-out guard | U4 |
| VER-S-0712 | WholeInstrumentTests | floor | KEEP floor (every seat its own room) | U4 |
| VER-S-0713 | RiteOfEnteringTests | verification | KEEP; retire :267 :608 :644 :822; READ rite-threshold.jsx numbers | U4 |
| VER-S-0714 | TheWayInTests reachability core | verification | KEEP :62 :226 :246 :502 :519 :753; REWRITE :142 :171; retire :317 :540 | U1 |
| VER-S-0715 | GateLookTests | verification | KEEP; generalise to every room | U4 |
| VER-S-0716 | Garima spike suites (renderer variants) | verification | KEEP as room-test template | U4 |
| VER-S-0717 | RecognitionNatureTests | verification | KEEP; READ LR_RECOG from living-rite-core.jsx; rewrite :299 | U2 |
| VER-S-0718 | TheLibraryFoldTests | verification | KEEP a11y + writes-nothing; retire drawn-measure and :226 | U2 |
| VER-S-0719 | SomaticRegionTests | floor | KEEP floor | U2 |
| VER-S-0720 | LivingMandalaTests | floor | KEEP floor | U9 |
| VER-S-0721 | OneBuildingTests | verification | KEEP C-1284, :415; rewrite :434 to mixing law | U1 |
| VER-S-0722 | WorldClimbTests (reads Design from disk) | verification | KEEP (the model); retire stone-emission-requires-relief; XCTSkip on missing Design file becomes FAIL in the Waves plan | U5 |
| VER-S-0723 | WorldClimbCaptureTests | verification | RAISE bounds to Design bands | U5 |
| VER-S-0724 | ChakraConstellationTests | verification | KEEP; retire spoken digit check; rewrite gated crossings; ADD chakra 32 absent from a11y tree | U6 |
| VER-S-0725 | ChakraRoomTests | verification | KEEP verbatim; ADD sealing of road 32 (renders today: defect G7-0477) | U6 |
| VER-S-0726 | PlayTests | verification | KEEP :520 :542 :23-64; retire :488 :559; rewrite :573 | U7 |
| VER-S-0727 | PlayWholeTests | verification | KEEP; settle SeedGrowth timings from code before porting (G7-0276) | U7 |
| VER-S-0728 | GameStructureTests | verification | KEEP; rewrite :247 :278; PIN minimumGapDays=3 and p=0.30; RETIRE the 'never in the first days' clause (ruling 16) | U7 |
| VER-S-0729 | ModesAndRitesTests | floor | KEEP floors; retire digit checks | U8 |
| VER-S-0730 | EphemerisTests | floor | KEEP floor | U8 |
| VER-S-0731 | LunarPhaseServiceTests | verification | KEEP | U8 |
| VER-S-0732 | TheRiverTests | floor | KEEP floor; retire digit checks | U9 |
| VER-S-0700 | CrossingRoomTests (Ring 2) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0701 | SiddhiRoomTests (Ring 1 kp 1-10) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0702 | MatrkaRoomTests (kp 11-18) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0703 | MudraRoomTests (kp 19-28) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0704 | BodilessRoomTests (Ring 3) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0705 | CosmicRoomTests (Ring 4) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0706 | GivingRoomTests (Ring 5) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0707 | RevealingRoomTests (Ring 6) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0708 | SoundingRoomTests (Ring 7) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0709 | SourcingRoomTests (Ring 8) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0710 | GateRoomTests (Laghima kp 3 and Garima kp 4 ('the Gate')) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0711 | DissolveRoomTests (kp 102) | verification | KEEP divergence + legibility + reduce-motion; RAISE light to Design bands; retire no-solid clause | U4 |
| VER-S-0628 | Snapshot baseline: mandala.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0629 | Snapshot baseline: mandala-descent.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0630 | Snapshot baseline: detail.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0631 | Snapshot baseline: field.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0632 | Snapshot baseline: memory.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0633 | Snapshot baseline: recognition.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0634 | Snapshot baseline: rite.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0635 | Snapshot baseline: settings.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0636 | Snapshot baseline: well.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0637 | Snapshot baseline: well-letter.geom | data | RETIRE as gate; KEEP as the word inventory of the Wave-6 screens (a before) | U0 |
| VER-S-0638 | Composition lock retired; its replacement never built | defect | REPLACE with Design-frame parity (V-PAR) | U0 |
| VER-S-0639 | Settings baseline shows a sheet over the Well | defect | KEEP as the planted failing case for nothing-laid-over | U1 |

## 3 · Parity ledger

Written as `waves/upgrade/ledger/verification.csv` (columns `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by`; `build_action` begins with its wave). Row families:

| prefix | rows | what |
|---|---|---|
| `VER-F01…F40` | 40 | the frames: world, what must match, measured band and crop, how compared |
| `VER-V01…V57` | 54 | the system's own elements (V52–V54 expand into the families below) |
| `VER-V3-01…66` | 66 | Homes Verification V3, one row per check, with its port disposition |
| `VER-P-01…19` | 19 | design-corpus laws 1–19 as walk expectations |
| `VER-L-*` | 90 | every existing test that encodes a lifted rule (retire / rewrite) |
| `VER-FL-*` | 97 | every floor test kept |
| `VER-S-*` | 124 | every existing suite, harness and baseline with its disposition |
| **total** | **490** | |

Other worlds' ledgers point their `verify_by` at these mechanisms (screenshot-vs-frame Fxx, measure-light, measure-sound, measure-timing, ui-walk-step, unit-test, his-walk); this ledger owns the mechanisms and the test inventory.

## 4 · Data contract

**Airtable (read only by tests through the bundled export; tests never write live tables).**
- Mandala table (102 rows; fields the floors read: position kp, Name, Bīja, tattva, bodily location `fld6P1u43B0eqKU5e`, Status, Last Felt, Recognition Count, Letter — the only PATCH topology allowed: record-addressed PATCH → Mandala on those four fields).
- The Map (33 rows; 58 fields; Build Status `fldXv59Zwjq4dmS6g` is web-only meta; activation `fldkOhQ5bDhECaVJs`; quarantined `fld0peL6gvkB9JeRe` never surfaced; App Activity inverse link `fldxl5Ez0Btgi8uoR`).
- App Activity `tblJlBeiHnqGpYrL7` — the single ledger. Baseline for per-world write verification (12 Oct): 160 rows; Mandala 89 (Shakti Recognized 60, Silence Held 18, Ring Crossed 6, Letter Written 3, Siddhi Received 1, First Dwelling 1), Feed 54, Learning 17. Fields: Notes, Link to Mandala, Felt At, Gesture Source, Duration (sec), Source App, Activity Type, Activity Name, Detail, Activity Date, Lunar Day, Moon Phase, Descent Ring, Link to The Map (`fldkF65ySNGGkeugH`, 0/160 today). Ring record ids: ring 9 `recqdC3D38TWFkf1M`, ring 1 `rec0XhDKfxW8UVyaB`, ring 2 `recspOpR95DVcOEvn`, ring 3 `recp4X5tuGdLuHCVw`. Dedup window ±60 s.
- Codex `tblDF4OCMcRoxkQjU` (Source App 'Bindu Mandala', Status never written).
- Gratitude `tblEFiuFIijKe9ba6` / `fld85STU49AtREkfe` — the one journal-adjacent read allowed (fetch only, about one day in three, verbatim).
- Allow-list (V38): Mandala, The Map, App Activity, Codex, Gratitude (one field), Relationships (only the three connections kp 31/40/42, ruling 11). Emotions, SJ, Anger, Health, Daily, Routines, Identity, Special Days, Timeline, Walks, Family Links, Builds: never read.

**Bundled for tests.**
- `FIXTURE_STORE=full`: a dated, read-only, verbatim export of all 102 Mandala rows and the 33 Map rows (with its export date in the file name; "a dated verbatim export is not invention") — replaces SYNC_OFF's 16 rows and HomesCorpus's 86 synthetic rows for the walk.
- `Data/ChakraConstellation.json` (baked 2026-10-12), `Data/GameStructure.json` — checked byte-equal to Airtable on every re-bake (V41).
- The Design corpus and the 40 frames under `Claude Design Upload/` (V02) plus `frames.json` (V03).
- Audio: 44 unique mp3s from `aistrangegame/aistrangegame.com` (`b/`, `bindu/`, `tree-of-life/<chakra>.mp3` for the nine chakra rooms) checked against the sha prefixes in `waves/register/audio-on-github.md` (V09).

**Local stores the PracticeStoreContract covers.** HomeMemory (phone-only, V2: visits, accumulatedDwell, longestDwell, deepestAdaptation), MarginNote (V3), LetterStore and LetterMigrationStash, CorrespondenceStore (river letters, seals, his voice files), BinduMemory, CodexNoteStore, PlayTraceStore, PlayGardenStore, Living Mandala strokes, RitesPractice witness pages, the PendingQueue (maxFailures nil), DescentState; every new world's model (Relationship Field first) as schema V4+.

**App Activity types the floor vocabulary holds** (LedgerIsTheRecord.eventVocabulary — every new world adds its types here and nowhere else): Shakti Recognized, Ring Crossed, Silence Held, Letter Written, Full Circle, First Dwelling, Note Left, State Set Down, Siddhi Received, Played, Letter Sealed, Letter Opened, Portrait Drawn, Wager Resolved, Witness Written, Garland Recited, Day Offered, Leela Drop, Light Entered, Chakra Practiced, Light Sent Back, Name Kept. Defined but never written today: Ceremony Sealed, Story Resonated, Reach, Return, Been Here, Share With, Note.

**Launch arguments (DEBUG walk scheme only; never honoured in Release).** Existing: SKIP_SUMMONS, SKIP_HOMECOMING (not used by the Homecoming test), SYNC_OFF, ENERGY_POS=<kp> (last wins), EPHEMERAL_STORE, START_TAB (retired as default), OPEN_DETAIL=<kp>, OPEN_SILENCE, OPEN_FILM, OPEN_LETTER=<kp>, OPEN_CLIMB, OPEN_RING=, AUTO_RECOGNIZE, RECOGNIZE_AUTOCLOSE, REDUCE_MOTION, MANDALA_LIGHT=off, BINDU_RECORD_BASELINE=1, SPIKE_BENCH=1, SPIKE_ROOM=, SPIKE_T=, SPIKE_REDUCE_MOTION. New: `OPEN_WORLD=<id>` (one per World case), `WALK_SEED=<n>`, `FIXTURE_STORE=full`, `WALK_OUT=<host dir>`, `WALK_TRACE=1`.

## 5 · Doors

This world has no door in the app. Its doors are into every world, for the walk:
- **In by address:** `OPEN_WORLD=<id>` for each of the fifteen (and each ring, game and room as sub-world), with the threads as parameters: kp 1–102 (Her Home, Her Presence), chakra 1–33 (its room), day (Today, Time). Position, never name.
- **In by route (what the walk exercises):** the point (home), the menu (the full index, one touch away everywhere), thread doors, search, the Veil, gestures (vertical drag climbs, tilt Mandala↔Climb, left edge out, Codex gestures, the die), back, crossings through the point.
- **Out:** back to exactly where he was; the point to the Bindu; the left edge; nothing laid over another world.
- **To Neev:** TestFlight after the walk report; his walk closes the wave.
- **Back into the build:** every FAIL and every word of his becomes a ledger row on the next wave's branch.

## 6 · To Bindu Feed

Story material found in this slice: **G5-0617** — the story numbers and principles of A Strange Game V6/V7 ("11 chapters · 3 experiences · 5 acts · 5 stitches · 1 Turning · 1 Constellation · 1 Final Reveal · 3 verbs (breathe/hold/feel) · 3 sound signatures · 5 transitions · 1 responsive Thread · 1 infinity gateway · 6 layers = 6 archetypes"; V7: 12 chapters / 12 nodes; "The page IS kundalini. The reader's body does what the words describe."; "The architecture holds without gripping.") — sources `14-aistrangegame.md:531-536`. Nothing else in the slice is story; the slice is mechanism.

## 7 · Conflicts settled and open

**Settled from evidence and the rulings**
1. *Harness size 46 vs 66, registers 6/7/9* (G1-0409, G2-0465): 66 checks in nine registers is the latest (Verification V3 EXPECT and its 66 check rows); "46 checks, 0 failing" is an earlier pass; the V3 page's "6" is a hard-coded label. The port reports nine.
2. *Legibility floor 0.28 / 0.3 / 0.5 alpha* (G2-0442): FIDELITY rule 4 (≥11 pt, ≥0.5 cream alpha) governs; where a Design frame draws a label brighter than a pinned exemption (the Rite veil name at .24), parity wins over the exemption (G7-1041).
3. *Fit gate 390×800 / y ≤ 744 vs 390×844 / tall at 704* (G5-0017, G5-0321): native rule is screen − 56 pt and ≤ one screen; the web rule that is stricter in a given case wins in review.
4. *Accent mix 55 % vs 50 % oklab* (G5-0321): BASE.css and gate.js are latest → 50 % oklab.
5. *Measuring regexes* (G1-0339, G7-0611): lifted (ruling 10); replaced by the narrow floor "no quantity of his practice is shown, spoken or drawn"; verdict words and red-as-failure stay banned.
6. *Ring 7 "2 OF 12 VOICES SOUNDED" and the canvas "n/2" captions* (F26, F21–F24): the canvas captions are Design's chrome, not app copy; the in-phone voice counter counts his touches in the moment, so it falls under the floor and is not carried. The twelve voices themselves come from Airtable Ring 7, not Design's name set.
7. *Ring 6 hue: Design violet vs Atmosphere teal 194°* (F25): "Mandala/Map colours win" → hue checked against 194°; luminance and geometry from the frame.
8. *Status ladder mapped → exploring → active → embodied with monotone opacity* (G7-0688): Status follows Recognition Count, so a brightness ladder is a count drawn; the opacity assertion is retired; seats may change form by state but no brightness scales with a count (C-1284).
9. *Leela "never in the first days"* (GameStructureTests): ruling 16 lifts it; only his own constants are pinned (≥3 days, then 30 %).
10. *The after-effect line "her siddhi is still on the instrument"* (V3 check 43, HomesWaveOneTests:272): ruling 15 drops the named line; the check becomes "the light state lingers 180 s and is never named".
11. *The withheld fifth and the second adaptation* (V3 checks 24–25): lifted gating → offered, never withheld; the fifth is still Design's sound when offered.
12. *Element by tattva vs ruling 4* (G7-1029): ruling 4 wins; Element gains a light branch and kp overrides 31 fire, 40 air, 42 light, 43 water; CrossingRoom physics, RecognitionNature, Rite archetype and carrier re-pinned.
13. *Chakra 32 numbering (room 33 card in the corpus)* (G2-0477): ruling 2 and the bake agree on road 32 (kp 101, Gaia); the test seals road 32 on every route, including ChakraRoomView, the Road's 16 s dwell and the Shadow Translator door.
14. *SceneKit/Metal capture black* (G7-1037, F07): unit-test captures of Metal worlds use `SCNView.snapshot()`; the walk uses XCUIScreen screenshots, which see the composited display; `drawHierarchy`/ImageRenderer are not used for Metal.
15. *Design numbers as ceiling* (G7-0809): upper bounds become blow-out guards only (blown share); lower bounds rise to Design's bands.
16. *Web-only defects* (.light freeze, FIGURES.css scoping, dc.js double load): not carried; only their lessons (one scroll owner, fixed z-order).
17. *Simulator numbers* (SpikeMetrics): relative only; Neev decides performance.
18. *Seed-growth timings* (G7-0276: 2/8/24/72 h vs 3/12/30/80 h): two readers disagree about the same code; the code as it stands is read once in U7 and pinned as the truth, since neither number is his ruling.

**Open — genuine questions for Ashrey**
1. **Xcode Cloud hours.** The month's 25 h are spent. The plan runs the `Waves` plan on his MacBook through Xcode at click tier and needs one connected folder (`~/BinduWalk`) for screenshots to reach the ledger. Is connecting that folder for the walk runs all right?
2. **Image allow-list.** The aniconic floor becomes "no figure of a Śakti" with a reviewed allow-list of image assets (textures, Design's renders, chakra art). Which images, if any, should be on it beyond textures and Design's own renders?

## 8 · Coverage

Every index id of the slice, with its disposition. Check run on 13 Oct over `verification.jsonl` (script in section 8.1):

| index id | title | disposition |
|---|---|---|
| G1-0011 | 66-check verification harness, nine registers, 204 rooms rendered | placed (section 2 row V29) |
| G1-0045 | Test for every home: could this room belong to any other Śakti? (Laghimā lifts / Garimā pr | placed (section 2 row V31) |
| G1-0244 | Physics distribution across the 102 (41 of 51 motions used; 3 fall to breathe) | placed (section 2 row V31) |
| G1-0245 | Attribute forms distribution across the 102 (26 of 26) | placed (section 2 row V31) |
| G1-0329 | Verifier wrongly called 15 living attributes inert (sampled position not rotation) | placed (section 2 row V30) |
| G1-0330 | Coverage audit: 8 brief items missing then built (hues, doors, clusters, library, Well let | placed (section 2 row V30) |
| G1-0331 | P10 sample gate result: Laghimā vs Garimā differ by 100% geometry and 116 luminance | placed (section 2 row V31) |
| G1-0332 | V3 six defects (descent dropped, white motes, dark Laghimā, Ring 4 no wall, Mātṛkās flat,  | placed (section 2 row V30) |
| G1-0333 | Grammar pass four defects (name collisions, silent fallthrough, Ring 8 triangle, Ring 6 un | placed (section 2 row V51) |
| G1-0335 | The method §0–§11 (Design's working rules) | placed (section 2 row V48) |
| G1-0338 | Harness primitives: six registers, offscreen 240×200 stage, 16 readPixels luminance sample | placed (section 2 row V05) |
| G1-0339 | MEASURING regex list (forbidden walker-facing patterns) | rejected (ruling 10: measuring-word lists lifted) - replaced by the narrow floor, section 2 row V33 |
| G1-0340 | Verification V3 page: 66 checks, 9 registers, 204 renders; sampling at t=20/30/300 | placed (section 2 row V29) |
| G1-0341 | V3 check 1 (canon): all 102 cards exist, one per khaḍgamālā position | placed (section 2 row V29) |
| G1-0342 | V3 check 2 (canon): every card carries quality, tattva, location, roots and phrase | placed (section 2 row V29) |
| G1-0343 | V3 check 3 (canon): every card carries her Devanāgarī (U+0900–097F) — *"the writing hand m | placed (section 2 row V29) |
| G1-0344 | V3 check 4 (canon): ring spans match KhadgamalaMap.swift {1:1, 2:29, 3:45, 4:53, 5:67, 6:7 | placed (section 2 row V29) |
| G1-0345 | V3 check 5 (canon): no invented bīja frequency — the carrier derives from her syllable: ca | placed (section 2 row V29) |
| G1-0346 | V3 check 6 (canon): the roster totals 102 at 28·16·8·14·10·10·12·3·1 | placed (section 2 row V29) |
| G1-0347 | V3 check 7 (coverage): every one of the 102 resolves to a built room (isBuilt) | placed (section 2 row V29) |
| G1-0348 | V3 check 8 (coverage): every Śakti resolves to a card of HER OWN ring — *"names collide ac | placed (section 2 row V29) |
| G1-0349 | V3 check 9 (coverage): the known collisions resolve by position, not by name (passes with  | placed (section 2 row V29) |
| G1-0350 | V3 check 10 (coverage): every chamber exposes update() and a label | placed (section 2 row V29) |
| G1-0351 | V3 check 11 (coverage): no Śakti falls through to the shared seat (label ≠ "her seat, from | placed (section 2 row V29) |
| G1-0352 | V3 check 12 (distinction): no two Śaktis in one ring speak the same near words — *"could t | placed (section 2 row V29) |
| G1-0353 | V3 check 13 (distinction): every room reverses its premise at the second adaptation (near  | placed (section 2 row V29) |
| G1-0354 | V3 check 14 (distinction): adjacent sisters diverge geometrically by more than a tenth (di | placed (section 2 row V29) |
| G1-0355 | V3 check 15 (distinction): her world conditions her room — the same mechanism differs by ā | placed (section 2 row V29) |
| G1-0356 | V3 check 16 (legibility): no room renders black at the first adaptation (max luminance ≥ 2 | placed (section 2 row V29) |
| G1-0357 | V3 check 17 (legibility): no room blows out to white (min ≤ 232) | placed (section 2 row V29) |
| G1-0358 | V3 check 18 (legibility): every room has internal contrast — light falls somewhere (spread | placed (section 2 row V29) |
| G1-0359 | V3 check 19 (legibility): the second adaptation is still legible (deep max ≥ 24) | placed (section 2 row V29) |
| G1-0360 | V3 check 20 (legibility): the light visibly changes between the two adaptations (/Δmean/ ≥ | placed (section 2 row V29) |
| G1-0361 | V3 check 21 (promise): time is elapsed, never device-tied (fingerprint(40) twice identical | placed (section 2 row V29) |
| G1-0362 | V3 check 22 (promise): the head start comes from dwell, not from visit count (6 visits × 0 | placed (section 2 row V29) |
| G1-0363 | V3 check 23 (promise): the ceremony compresses on return but is never skipped (first = 1;  | placed (section 2 row V29) |
| G1-0364 | V3 check 24 (promise): the second adaptation is reachable only through relationship (cold  | placed (section 2 row V29) |
| G1-0365 | V3 check 25 (promise): the fifth is withheld outside the ninth world (ring 3 at t=30 → 0;  | placed (section 2 row V29) |
| G1-0366 | V3 check 26 (promise): today matches DailyEnergyService: a true permutation per cycle (102 | placed (section 2 row V29) |
| G1-0367 | V3 check 27 (promise): the practice day turns at 6am local | placed (section 2 row V29) |
| G1-0368 | V3 check 28 (promise): today resolves to a real Śakti of the right ring (detail "day N · p | placed (section 2 row V29) |
| G1-0369 | V3 check 29 (promise): the body altitude of every card lies inside the body (0 < alt < 1) | placed (section 2 row V29) |
| G1-0370 | V3 check 30 (promise): Ring 2's crossing is real: the presented and answering halves diffe | placed (section 2 row V29) |
| G1-0371 | V3 check 31 (felt): no room label measures the walker — *"the instrument may know everythi | placed (section 2 row V29) |
| G1-0372 | V3 check 32 (felt): no card phrase or quality measures the walker | placed (section 2 row V29) |
| G1-0373 | V3 check 33 (felt): every label speaks plainly — no project jargon leaks into the room (`P | placed (section 2 row V29) |
| G1-0374 | V3 check 34 (felt): no label is empty, truncated or a placeholder (≥ 8 chars, no leading/t | placed (section 2 row V29) |
| G1-0375 | V3 check 35 (felt): the nine worlds are a continuous climb — no gaps between bands — *"no  | placed (section 2 row V29) |
| G1-0376 | V3 check 36 (felt): each world's weather is named, and no two alike (≥ 12 chars, 9 unique) | placed (section 2 row V29) |
| G1-0377 | V3 check 37 (felt): every world names its gem, dhātu, clock and body-region | placed (section 2 row V29) |
| G1-0378 | V3 check 38 (coherence): the Axis is the instrument — it holds every layer (climb, the rit | placed (section 2 row V29) |
| G1-0379 | V3 check 39 (coherence): no module reference is stale (no module referenced at two `?v=` v | placed (section 2 row V29) |
| G1-0380 | V3 check 40 (coherence): no debug hook of mine survives in any deliverable (`window.__prob | placed (section 2 row V29) |
| G1-0381 | V3 check 41 (coherence): the descent survives the fold into the Axis (if the Rite has a de | placed (section 2 row V29) |
| G1-0382 | V3 check 42 (coherence): reduced motion is honoured, not ignored (`prefers-reduced-motion` | placed (section 2 row V29) |
| G1-0383 | V3 check 43 (coherence): the after-effect still lingers on the whole instrument — *"her si | placed (section 2 row V29) |
| G1-0384 | V3 check 44 (coherence): every claim of a named file in the thread resolves (soft — report | placed (section 2 row V29) |
| G1-0385 | V3 check 45 (coherence): the method file states its rules (≥ 2000 chars; mentions mechanis | placed (section 2 row V29) |
| G1-0386 | V3 check 46 (coherence): nothing in the walker-facing copy measures her (all literal textC | placed (section 2 row V29) |
| G1-0387 | V3 check 47 (brief): the Śakti cards are treated as the base where the app has drifted — p | placed (section 2 row V29) |
| G1-0388 | V3 check 48 (brief): the ring hues are the repo's own Atmosphere tokens {35, 43, 341, 353, | placed (section 2 row V29) |
| G1-0389 | V3 check 49 (brief): every world names its presiding Form, Yoginī class, state and verb | placed (section 2 row V29) |
| G1-0390 | V3 check 50 (brief): secrecy deepens inward — the veil rises monotonically, 0 → 1 — *"Prak | placed (section 2 row V29) |
| G1-0391 | V3 check 51 (brief): the mental state slows the world as it deepens (ring 1 tempo 1, ring  | placed (section 2 row V29) |
| G1-0392 | V3 check 52 (brief): the doors are walkable from inside — the homes are one building (walk | placed (section 2 row V29) |
| G1-0393 | V3 check 53 (brief): ring 2's clusters and ring 1's families share corridors | placed (section 2 row V29) |
| G1-0394 | V3 check 54 (brief): the library is kept and folded, not deleted | placed (section 2 row V29) |
| G1-0395 | V3 check 55 (brief): her Well letter rests in the room as a folded object | placed (section 2 row V29) |
| G1-0396 | V3 check 56 (brief): the Well letter is never invented (letterFor reads localStorage; no " | placed (section 2 row V29) |
| G1-0397 | V3 check 57 (brief): each ring keeps its own sound technique (TECHNIQUE, shepard, triad) — | placed (section 2 row V29) |
| G1-0398 | V3 check 58 (brief): the design tokens are the repo's (#0D0508, #C9963F, #F2E8D9, Cormoran | placed (section 2 row V29) |
| G1-0399 | V3 check 59 (brief): the physics vocabulary reads the cards, not a dozen words (≥ 40 patte | placed (section 2 row V29) |
| G1-0400 | V3 check 60 (brief): the P10 gate: Laghimā and Garimā are unmistakable (different near wor | placed (section 2 row V29) |
| G1-0401 | V3 check 61 (iconography): every one of the 102 is given her attribute — *"her held object | placed (section 2 row V29) |
| G1-0402 | V3 check 62 (iconography): her attribute actually mounts in her room (a node named `attrib | placed (section 2 row V29) |
| G1-0403 | V3 check 63 (iconography): the attributes are many shapes, not one repeated (≥ 25 named, ≥ | placed (section 2 row V29) |
| G1-0404 | V3 check 64 (iconography): her attribute moves — it performs rather than sits (snapshot of | placed (section 2 row V29) |
| G1-0405 | V3 check 65 (iconography): the attribute is tinted by her card's colour word where it give | placed (section 2 row V29) |
| G1-0406 | V3 check 66 (iconography): past the second adaptation the attribute stops being an object  | placed (section 2 row V29) |
| G1-0407 | Handoff §8 tests to port to Swift (found real defects); verify the verifier | placed (section 2 row V29) |
| G1-0408 | Recorded GPU luminance results per archetype and study room | placed (section 2 row V05) |
| G1-0409 | Count drift across documents (authored 7/8/9; checks 46/66; registers 6/7/9) | placed (section 2 row V30) |
| G1-0410 | Reduced motion in older studies = off / frozen — contradicts 'longer and quantized'; Axis  | placed (section 2 row V44) |
| G1-0412 | Today's presiding position for 2026-10-12 computed: 82 Sarvādhārasvarūpā (day 2477) | placed (section 2 row V34) |
| G1-0413 | Builder must-nots summary (D list) — position is identity everywhere; build order; harness | placed (section 2 row V29) |
| G1-0456 | Rite Tweaks panel (prototype chrome: dilation 1×/3×/12×, phase, stillness, specimen) | placed (section 2 row V50) |
| G1-0558 | ios-frame.jsx and tweaks-panel.jsx — prototype chrome, do not port | rejected (prototype tooling, do not port) - recorded in section 2 row V55 |
| G1-0575 | Phase 1 Repairs: shared Hit.min = 44; Ring 9 trailing field, Ring 8 twelve-voice overlap,  | placed (section 2 row V24) |
| G1-0581 | PR sequence PR-1 … PR-10+ | rejected (history, superseded by Charter II waves) - recorded in section 2 row V56 |
| G1-0597 | Legibility and touch floor violations to fix, not copy (26px hits, 9px/7.5px names, 8px ga | placed (section 2 row V44) |
| G1-0769 | design-canvas.jsx tooling (ignores title/background props) — not app design | rejected (prototype tooling, do not port) - recorded in section 2 row V55 |
| G1-0770 | doc-page.js — paged-document scaffold unused by this family | rejected (prototype tooling, do not port) - recorded in section 2 row V55 |
| G1-0780 | Small code defects: TemporalMark ignores x/sym; quick-recog-panel no CSS; Veil dims .5 vs  | placed (section 2 row V51) |
| G2-0066 | HO2-01 ring-world standard (7 criteria) | placed (section 2 row V32) |
| G2-0079 | FB-01 phase gating with Ash | placed (section 2 row V47) |
| G2-0106 | UXA-01 legibility hard fails | placed (section 2 row V44) |
| G2-0126 | DA1-12 Call 5 legibility label-or-texture | placed (section 2 row V44) |
| G2-0129 | DA1-15 retire stale UX-AUDIT | placed (section 2 row V52) |
| G2-0131 | RFB-01 five calls are decisions not bugs | placed (section 2 row V47) |
| G2-0132 | RFB-02 ≥44pt hit areas for energies | placed (section 2 row V24) |
| G2-0138 | RFB-08 suggested repair order | rejected (history, superseded by Charter II waves) - recorded in section 2 row V56 |
| G2-0140 | MBB-02 six principles + floor | placed (section 2 row V44) |
| G2-0142 | MBB-04 Hit.min = 44 class fix | placed (section 2 row V24) |
| G2-0143 | MBB-05 ring repair Done-when criteria | placed (section 2 row V32) |
| G2-0147 | MBB-09 Done when: one tap from today's Śakti | placed (section 2 row V17) |
| G2-0154 | MBB-16 PR sequence | rejected (history, superseded by Charter II waves) - recorded in section 2 row V56 |
| G2-0170 | FH-02 reference prototype as design truth | placed (section 2 row V06) |
| G2-0188 | R2R-01 prototype is source of truth for look/motion/behaviour | placed (section 2 row V06) |
| G2-0191 | R2R-05 prototype screen parity list | placed (section 2 row V57) |
| G2-0193 | R2R-07 port approach order | placed (section 2 row V47) |
| G2-0204 | RBB-11 engine foundation (Atmosphere.derive, newmoon) | placed (section 2 row V06) |
| G2-0235 | HDP-01/02 Chat→Design→Code loop | placed (section 2 row V02) |
| G2-0240 | HDP-07 room test: could it belong to another Śakti? | placed (section 2 row V31) |
| G2-0265 | CCH-19 Homes invariants 1–7 | placed (section 2 row V53) |
| G2-0267 | CCH-21 Homes verification contract 66 checks | placed (section 2 row V29) |
| G2-0269 | THR-01 Homes thread parity list | placed (section 2 row V01) |
| G2-0271 | THR-03 coverage audit seven restored asks | placed (section 2 row V30) |
| G2-0273 | THR-05 the Gate: Laghimā vs Garimā | placed (section 2 row V31) |
| G2-0274 | THR-06 V1/V2/V3 six defects found | placed (section 2 row V30) |
| G2-0279 | THR-11 GPU luminance parity ranges | placed (section 2 row V05) |
| G2-0287 | THR-19 WebGL capture black → readPixels | placed (section 2 row V05) |
| G2-0289 | RMF-03 Verification V3 66 checks 204 rooms | placed (section 2 row V29) |
| G2-0292 | MTH-02 never show first attempt | placed (section 2 row V47) |
| G2-0293 | MTH-03/04 plain plan; fix the rule | placed (section 2 row V48) |
| G2-0296 | MTH-08 verify what the eye can't reach | placed (section 2 row V29) |
| G2-0299 | MTH-11/12 register decisions; shape of new space | placed (section 2 row V48) |
| G2-0309 | AB-01 evidence-preservation law | placed (section 2 row V35) |
| G2-0310 | AB-03 audit ask list A–H | placed (section 2 row V44) |
| G2-0311 | DAB-01 capture phone before dev build | placed (section 2 row V46) |
| G2-0317 | AR-06 Rulings 1–8 drift check | rejected (history, superseded by Charter II waves) - recorded in section 2 row V56 |
| G2-0320 | AR-09/10 a11y sub-threshold sites, touch, VoiceOver | placed (section 2 row V44) |
| G2-0326 | ARD-04 parity device Neev | placed (section 2 row V46) |
| G2-0333 | BV2-L7/L8/L9 verify, FIDELITY, read Design docs | placed (section 2 row V44) |
| G2-0339 | BV2-P0–P6 phases | placed (section 2 row V44) |
| G2-0342 | BV2-9/PSH-01/CR-01 session protocol & laws | placed (section 2 row V47) |
| G2-0351 | CN-04 branch order phase-2a letters gate | rejected (history, superseded by Charter II waves) - recorded in section 2 row V56 |
| G2-0353 | BC-00 five causes of Design–build gap | placed (section 2 row V48) |
| G2-0356 | BC-03 tiebreaker: build the fuller version | placed (section 2 row V48) |
| G2-0366 | BC-14 waves workflow + look check vs Design frames | placed (section 2 row V01) |
| G2-0373 | WV-07 Wave 0 Ground | placed (section 2 row V46) |
| G2-0386 | RD-09/RD-10 checks proved numbers; studies Code never saw | placed (section 2 row V02) |
| G2-0387 | RD-11 first-principles table (lift caps, sound, doors) | placed (section 2 row V52) |
| G2-0391 | RD-15 fix inventory code defects | placed (section 2 row V51) |
| G2-0393 | RD-17 retool test list | placed (section 2 row V52) |
| G2-0394 | F01 Ring 2 lotus close-up, Sparśa today | placed (section 2 row V03) |
| G2-0395 | F02 Ring 8 Mūla Trikoṇa three vertex states | placed (section 2 row V03) |
| G2-0396 | F03 Temporal Layer 'The Cosmic Now' | placed (section 2 row V03) |
| G2-0397 | F04 Axis seat state 'THE SEAT' | placed (section 2 row V03) |
| G2-0398 | F05 Axis ring state 'THE RING' | placed (section 2 row V03) |
| G2-0399 | F06 duplicate of F05 | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0400 | F07 Rooms in 3D Aṇimā (black WebGL capture) | placed (section 2 row V03) |
| G2-0401 | F08 Living Mandala cosmic tier on indigo | placed (section 2 row V03) |
| G2-0402 | F09 Living Mandala mid tier | placed (section 2 row V03) |
| G2-0403 | F10 Bindu→Lalitā finale red bloom | placed (section 2 row V03) |
| G2-0404 | F11 Axis Ring 2 tier 16 seats | placed (section 2 row V03) |
| G2-0405 | F12 Axis Ring 2 + harness overlay | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0406 | F13 Axis seat tier entering a room | placed (section 2 row V03) |
| G2-0407 | F14 Recognition at the seat: two lines + FELT | placed (section 2 row V03) |
| G2-0408 | F15 Ring Worlds II canvas: Ring 4 Lineage resting | placed (section 2 row V03) |
| G2-0409 | F16 duplicate of F15 | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0410 | F17 duplicate of F15 | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0411 | F18 six worlds dropdown | placed (section 2 row V03) |
| G2-0412 | F19 Ring 3 Smoke Lotus gathered | placed (section 2 row V03) |
| G2-0413 | F20 duplicate of F19 | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0414 | F21 Ring 3 one plume touched (active glow) | placed (section 2 row V03) |
| G2-0415 | F22 Ring 4 transmission in flight | placed (section 2 row V03) |
| G2-0416 | F23 Ring 4 transmission partway | placed (section 2 row V03) |
| G2-0417 | F24 Ring 5 Overflow all ten flooding | placed (section 2 row V03) |
| G2-0418 | F25 Ring 6 Concealed light reaching one | placed (section 2 row V03) |
| G2-0419 | F26 Ring 7 Vāk chamber twelve voices at 30° | placed (section 2 row V03) |
| G2-0420 | F27 Ring 8 Mūla Trikoṇa resting | placed (section 2 row V03) |
| G2-0421 | F28 Ring 9 Praveśa start (Direction B) | placed (section 2 row V03) |
| G2-0422 | F29 Ring 9 Spanda full bloom (Direction A) = G17 centre bloom | placed (section 2 row V03) |
| G2-0423 | F30 Ring 1 Earth-City three frames (v1) | placed (section 2 row V03) |
| G2-0424 | F31 Ring 1 v2 iteration | merged into its original frame (duplicate) - row V03 / ledger VER-F |
| G2-0425 | F32 Ring 1 v3 latest composition | placed (section 2 row V03) |
| G2-0426 | F33 Ring 1 Mātṛkā focus + family legend | placed (section 2 row V03) |
| G2-0427 | F34 Ring 2 Inhabited Lotus default + invocation | placed (section 2 row V03) |
| G2-0428 | F35 mislabelled ring8-fix shows Ring 2 | placed (section 2 row V03) |
| G2-0429 | F36 May-era shipped Mandala with tab bar (NOT a target) | placed (section 2 row V03) |
| G2-0430 | F37 the Veil closed (held yantra) | placed (section 2 row V03) |
| G2-0431 | F38 the Veil sheet rising | placed (section 2 row V03) |
| G2-0432 | F39 Veil descending | placed (section 2 row V03) |
| G2-0433 | F40 Homes Axis desktop thumbnail (climb chrome) | placed (section 2 row V03) |
| G2-0434 | Frame gaps: no reference frames for several worlds | placed (section 2 row V02) |
| G2-0442 | C8 legibility floor | placed (section 2 row V44) |
| G2-0465 | C31 harness size 46 vs 66 | placed (section 2 row V30) |
| G2-0477 | Sealed layer: Reveal never described | placed (section 2 row V34) |
| G2-0478 | Living Mandala gift is sealed territory (builder-only) | placed (section 2 row V34) |
| G2-0893 | B.5.2 Living Mandala (SEALED, builder-only) | placed (section 2 row V34) |
| G2-0895 | B.5.3 Pairing Floor (gift → room map) | placed (section 2 row V34) |
| G2-0927 | Corpus screenshots (uploads + screenshots) | placed (section 2 row V57) |
| G2-0935 | E Walk-build order locked | placed (section 2 row V57) |
| G3-0195 | P4 Anahata panel mechanics and checker | placed (section 2 row V43) |
| G3-0265 | BCA-CANON bake_walk_canon.py | placed (section 2 row V41) |
| G3-0296 | Voice scans (forbidden word lists) | placed (section 2 row V39) |
| G3-0540 | Codex coverage measures | not this world: data (Codex coverage measures) |
| G3-0541 | Codex word census (verification of claimed laws) | placed (section 2 row V41) |
| G4-0006 | Dance execution protocol Steps 0-6 (registry check, extract, hear, seed+fruit, tune, build | not this world: the-33 (dance execution protocol; authoring pipeline for Scores) |
| G4-0046 | Return structural rules #70 and #79 | not this world: the-33 (dance Return structural rules) |
| G4-0097 | Phased build method: four layers verified alone, then merged (Black Screen Test, Atmospher | placed (section 2 row V48) |
| G4-0113 | Audio sync and guard rules (build-patterns) | placed (section 2 row V08) |
| G4-0114 | Process learnings #3-#7 (experience before assessing, go X times further, cut fruit in hal | placed (section 2 row V47) |
| G4-0118 | Lessons #51, #53, #59: four iterations, retrofit backward, exact save/restore | placed (section 2 row V47) |
| G4-0153 | bindu-field two-chat build: Temple Spec (8 commits) then Zimmer visual upgrade (~23 system | not this world: the-33 (bindu-field two-chat build per room) |
| G4-0155 | Zimmer discipline rules | placed (section 2 row V47) |
| G4-0156 | Steps 7-9: reinforcement, honest bug-finding, personal offering (one addition, ~30 lines,  | not this world: the-33 (Steps 7-9: reinforcement, offering per room; its honest bug-finding is merged into V48) |
| G4-0282 | Gaia Inversion as design method: start from the completed experience | placed (section 2 row V47) |
| G4-0293 | Web APIs absent on iOS (navigator.vibrate, requestFullscreen, DeviceOrientationEvent.reque | not this world: spine (gestures: web APIs mapped to Core Haptics / CoreMotion) |
| G4-0296 | Small source bugs: anahata literal '·' in signature; unused hueShift; Return Math.max rais | placed (section 2 row V51) |
| G4-0312 | 12-step Score protocol (0 THE WORD → 12 REGISTER); steps 1, 6, 7 are scripts | not this world: the-33 (12-step Score protocol; its VALIDATE step is V42) |
| G4-0338 | Validator 20 rules (rule 16 resonance_link no Hz = hard failure; advisories boost<0.7, no  | placed (section 2 row V42) |
| G4-0493 | Peak conflicts awaiting listening (ember, press, open, numb, light, trace, crash, believe, | placed (section 2 row V42) |
| G4-0504 | BPM artifacts (172.3 speak/lose/inshadow; 152 unfold/confront) feed seed typing speeds | placed (section 2 row V42) |
| G4-0562 | validate.py: 21 rules of score-format §5 (id pattern, times, ordering, final until null, g | placed (section 2 row V42) |
| G4-0563 | make_report.py: secondary peaks (find_peaks height .6 distance 40), NEAR-EQUAL maxima ≥0.9 | not this world: the-33 / data (batch report script for Scores) |
| G4-0565 | Deep-dive 10-step scoring protocol (carrier decision, stereo check, seven lenses, page lan | placed (section 2 row V08) |
| G4-0567 | STEP 10 see-and-feel test: raise HOME gain by 0.010 if body doesn't feel difference on/off | placed (section 2 row V10) |
| G4-0577 | Technical laws (S1): session IDs vs races, setValueAtTime before ramp, media source once,  | placed (section 2 row V08) |
| G4-0592 | S9: reading stack complete 14 songs + 11 breaths; breath phase label paragraph format; Rea | placed (section 2 row V48) |
| G4-0636 | Peak reliability: any Mandala event anchored to a batch peak inherits needs_listening unce | placed (section 2 row V42) |
| G4-0639 | How laws are read (ruling 11 Oct): two floors — truth and access; 'the experience as desig | placed (section 2 row V26) |
| G4-0640 | Core laws: one piece per screen (≤~700 px at 390 wide), only true when true, plain languag | placed (section 2 row V22) |
| G4-0641 | Design-corpus law 1 | placed (section 2 row V25) |
| G4-0642 | Design-corpus law 2 | placed (section 2 row V25) |
| G4-0643 | Design-corpus law 3 | placed (section 2 row V26) |
| G4-0644 | Design-corpus law 4 | placed (section 2 row V26) |
| G4-0645 | Design-corpus law 5 | placed (section 2 row V26) |
| G4-0646 | Design-corpus law 6 | placed (section 2 row V26) |
| G4-0647 | Design-corpus law 7 | placed (section 2 row V26) |
| G4-0648 | Design-corpus law 8 | placed (section 2 row V26) |
| G4-0649 | Design-corpus law 9 | placed (section 2 row V26) |
| G4-0650 | Design-corpus law 10 | placed (section 2 row V26) |
| G4-0651 | Design-corpus law 11 | placed (section 2 row V26) |
| G4-0652 | Design-corpus law 12 | placed (section 2 row V26) |
| G4-0653 | Design-corpus law 13 | placed (section 2 row V26) |
| G4-0654 | Design-corpus law 14 | placed (section 2 row V26) |
| G4-0655 | Design-corpus law 15 | placed (section 2 row V26) |
| G4-0656 | Design-corpus law 16 | placed (section 2 row V26) |
| G4-0657 | Design-corpus law 17 | placed (section 2 row V26) |
| G4-0658 | Design-corpus law 18 | placed (section 2 row V26) |
| G4-0659 | Design-corpus law 19 | placed (section 2 row V26) |
| G4-0660 | Gate: walk every step in a real mobile browser (verify_walk.py, Playwright 390×844); zero  | placed (section 2 row V21) |
| G4-0661 | Process: register → ruling → one form, three topics, walk → Design → re-walk → Code → Git  | placed (section 2 row V47) |
| G4-0723 | Gesture usage rules: data-gesture='G#'; tap test <9 px & ≤700 ms; hold cancel >9 px (Door  | placed (section 2 row V25) |
| G4-0779 | GATE 6c: 44 px targets ('size the target, not the mark'); reduced motion: animations off,  | placed (section 2 row V24) |
| G4-0872 | Counting the reader in exemplars (day d of fourteen, n of 15, Day 1 of 30, read on <date>, | placed (section 2 row V33) |
| G4-0875 | SwiftUI corridor gap: paging ScrollView, scrollPosition binding for ASGjump, hit-test laye | placed (section 2 row V23) |
| G5-0001 | Topic field: three layers form · sub-template · move | placed (section 2 row V21) |
| G5-0009 | Web base fix: html owns scroll (body scroll clip bug) | placed (section 2 row V23) |
| G5-0011 | Snap jumps: instant + explicit sync | placed (section 2 row V23) |
| G5-0014 | Hit-test contract (stacking order) | placed (section 2 row V24) |
| G5-0016 | Tap targets ≥44 px with a small visible mark inside | placed (section 2 row V24) |
| G5-0017 | Fit: every step fits 390×800 with 20 px clear | placed (section 2 row V22) |
| G5-0019 | Reserved class names (the .light freeze bug) | rejected (web-only defect) - recorded in section 2 row V28 |
| G5-0020 | Performance rules for figures | rejected (web-only defect) - recorded in section 2 row V28 |
| G5-0030 | Content rules (HANDOFF-CHAT) | placed (section 2 row V22) |
| G5-0031 | REVIEW verdicts and rulings (23 Sept) | placed (section 2 row V47) |
| G5-0033 | REVIEW voice notes | placed (section 2 row V47) |
| G5-0034 | ROADMAP phases and the catch-all number | placed (section 2 row V47) |
| G5-0041 | process.md: register → ruling → depth-first build | placed (section 2 row V49) |
| G5-0042 | The holds law (a hold is the hold it was designed to be) | placed (section 2 row V25) |
| G5-0043 | Claude Design brief template (the Lalita level) | not this world: visual (Design brief template; the Lalita level) |
| G5-0045 | Lineage 22 Sept: mirrors not teachings; jsdom is not a browser | placed (section 2 row V18) |
| G5-0047 | No on-screen instructions (invented instruction strings deleted) | placed (section 2 row V26) |
| G5-0048 | Build to the numbers, not the frames | placed (section 2 row V06) |
| G5-0082 | The bench: review controls outside the device | placed (section 2 row V50) |
| G5-0090 | Three earning mechanics side by side (method) | placed (section 2 row V47) |
| G5-0101 | Compare two answers on one device | placed (section 2 row V47) |
| G5-0107 | The harness (every family beside a live render) | placed (section 2 row V04) |
| G5-0126 | The parity pass (feel anchors) | placed (section 2 row V57) |
| G5-0163 | The room test: mechanism, never mood | placed (section 2 row V31) |
| G5-0179 | Ship with proof, run backwards | placed (section 2 row V01) |
| G5-0217 | Score before build: the five-track score | placed (section 2 row V49) |
| G5-0233 | The adversarial pass | placed (section 2 row V48) |
| G5-0271 | compose.js order | not this world: visual (web compose.js order) |
| G5-0274 | gen_v2.py and the 'waiting' report | placed (section 2 row V01) |
| G5-0296 | verify_walk.py: the headless walk gate | placed (section 2 row V21) |
| G5-0298 | The pipeline: register → ruling → Design → fold back → Chat review → Code | placed (section 2 row V49) |
| G5-0299 | CLAUDE.md wave brief skeleton (handoff template) | placed (section 2 row V49) |
| G5-0300 | HANDOFF-CODE order | placed (section 2 row V49) |
| G5-0301 | The gates (HANDOFF-CODE §5) | placed (section 2 row V21) |
| G5-0302 | Contrast gate (gate.js) → Swift unit test | placed (section 2 row V27) |
| G5-0303 | Never test stateful play by clicking a real choice | placed (section 2 row V35) |
| G5-0304 | The lineage of mechanics | placed (section 2 row V01) |
| G5-0318 | Holds that complete instantly on Enter/Space (gen_practice holdable, rk.js) | placed (section 2 row V25) |
| G5-0319 | FIGURES.css SEPARATION reintroduces the .light freeze bug | rejected (web-only defect) - recorded in section 2 row V28 |
| G5-0320 | FIGURES.css cannot be concatenated whole | rejected (web-only defect) - recorded in section 2 row V28 |
| G5-0321 | Numbers that disagree across padakarshini files | placed (section 2 row V22) |
| G5-0324 | Walk cooldowns contradict each other (time-gating doctrine) | not this world: game (walk cooldown doctrine; ruling 16 governs the app) |
| G5-0326 | Referenced but unread: gestures.md, forms.md, forms-contract.json | not this world: spine (gestures.md / forms.md unread by reader 12) |
| G5-0333 | The loom (brief first, recognition before anything) | placed (section 2 row V49) |
| G5-0335 | Universal laws (house) | not this world: visual (house universal laws) |
| G5-0341 | S12–S17 have no proof build yet | placed (section 2 row V02) |
| G5-0359 | S9 Proof shape | placed (section 2 row V01) |
| G5-0386 | Canon chip (non-canon lines visible in review) | placed (section 2 row V40) |
| G5-0395 | Design system by its absences | placed (section 2 row V01) |
| G5-0418 | Figures are pure functions of time and data (law 12) | placed (section 2 row V07) |
| G5-0480 | Review canvas | placed (section 2 row V01) |
| G5-0481 | Not carried from the corpus (§7) | placed (section 2 row V34) |
| G5-0510 | Brand-home stale rk.css: illegible deep-band labels | placed (section 2 row V27) |
| G5-0511 | Harness double-loads dc.js | rejected (web-only defect) - recorded in section 2 row V28 |
| G5-0512 | Evidence PNGs (asg-guide, wazoodle brand home) | rejected (prototype tooling, do not port) - recorded in section 2 row V55 |
| G5-0546 | The climb in one tap per step (≤3 taps proof) | placed (section 2 row V12) |
| G5-0555 | Site deploy gates | placed (section 2 row V21) |
| G5-0557 | Performance ruling: correctness beats the numbers | placed (section 2 row V45) |
| G5-0574 | Dev key ?ash=1 (maker's name as master key) | placed (section 2 row V50) |
| G5-0587 | Surface · reveal · thread for every element | placed (section 2 row V26) |
| G5-0617 | Story numbers and principles | not this world: bindu-feed (story numbers of A Strange Game V6/V7) |
| G5-0672 | Phase 3A open-exploration questions | placed (section 2 row V49) |
| G5-0673 | EDP rules, through-lines, seed message and culminations | not this world: data (EDP through-lines, seed message, culminations) |
| G5-0686 | Build intelligence and timing standards | placed (section 2 row V07) |
| G5-0687 | Build guards (tap vs trace, hidden layers, rAF cleanup) | placed (section 2 row V24) |
| G5-0693 | Accumulated angle for parametric animations (Discovery 57) | placed (section 2 row V07) |
| G5-0694 | Tree of Life panel bug log | placed (section 2 row V51) |
| G5-0695 | Three-pass verification + structural pass | placed (section 2 row V48) |
| G5-0698 | Sakshi test | placed (section 2 row V48) |
| G5-0700 | New-topic lane (NTL) | not this world: data (new-topic lane for the websites) |
| G6-0481 | Map · Build Status (field family) | not this world: data (Map Build Status of web practice pages) |
| G6-0485 | Map · App Activity inverse link empty | placed (section 2 row V41) |
| G6-0494 | Map ↔ canon ↔ app agree to the byte | placed (section 2 row V41) |
| G6-0610 | Map C1 · Crossed names canon ↔ Map | placed (section 2 row V41) |
| G6-0624 | Map coverage method | placed (section 2 row V41) |
| G6-0723 | App Activity · usage counts (160 rows) | placed (section 2 row V41) |
| G6-0724 | What the app reads today (five tables) | placed (section 2 row V38) |
| G6-0771 | ASG C5 · App Activity under-uses its own design | placed (section 2 row V41) |
| G6-0781 | ASG coverage / privacy method | placed (section 2 row V41) |
| G6-0783 | Code core · FIDELITY.md (132) · design-fidelity checklist | placed (section 2 row V06) |
| G6-0863 | Code core · FIDELITY stale: silence writer 'zero call sites' | placed (section 2 row V48) |
| G6-0864 | Code core · FIDELITY reads MandalaLight as off | placed (section 2 row V48) |
| G6-0923 | Code C-2 · Chakra 32 sealing not enforced in code | placed (section 2 row V34) |
| G6-0938 | Code C-10c · MandalaLight off path kept for tests only | placed (section 2 row V51) |
| G6-0951 | Code C-14 stale comment · SilenceDwell.swift:13–14 | placed (section 2 row V48) |
| G6-0952 | Code C-14 stale comment · HomeMemoryStore.swift:18, 98 | placed (section 2 row V48) |
| G6-0953 | Code C-14 stale comment · AirtableService.swift:1414 | placed (section 2 row V48) |
| G6-0954 | Code C-14 stale comment · AirtableService.swift:1699–1707 | placed (section 2 row V48) |
| G6-0955 | Code C-14 stale comment · MarginNote.swift:21–24 | placed (section 2 row V48) |
| G6-0956 | Code C-14 stale comment · RingAudioService.swift:6–11 | placed (section 2 row V48) |
| G6-0957 | Code C-14 stale comment · HomeSoundService.swift:727–729 | placed (section 2 row V48) |
| G6-0958 | Code C-14 stale comment · FIDELITY.md:127–132 | placed (section 2 row V48) |
| G6-0959 | Code core coverage | placed (section 2 row V54) |
| G6-1047 | Homes parity · Design-harness tests ported (own-ring resolution, no twin words, reversal,  | placed (section 2 row V29) |
| G6-1070 | Homes upgrade C9 · Reduce motion: quantized adaptation | placed (section 2 row V44) |
| G6-1071 | Homes upgrade C10 · Sound per room: verify the withheld fifth | placed (section 2 row V08) |
| G6-1078 | Homes coverage | placed (section 2 row V54) |
| G7-0025 | Mandala launch arguments | placed (section 2 row V50) |
| G7-0096 | MandalaAccessibilityLayer | placed (section 2 row V44) |
| G7-0097 | MandalaVoice spoken labels | placed (section 2 row V44) |
| G7-0224 | Road 32 Gaia station shows story; verify sealing | placed (section 2 row V34) |
| G7-0276 | Seed growth timings conflict | placed (section 2 row V51) |
| G7-0477 | Ruling 2 violated: room 32 words rendered | placed (section 2 row V34) |
| G7-0562 | Spike: SpikeBench | placed (section 2 row V45) |
| G7-0563 | Spike: SpikeField | placed (section 2 row V45) |
| G7-0564 | Spike: SpikeMandalaHarness | placed (section 2 row V45) |
| G7-0565 | Spike: SpikeMetrics | placed (section 2 row V45) |
| G7-0566 | Spike: MandalaDrawCensus | placed (section 2 row V45) |
| G7-0567 | Spike: GarimaCanvasRoom (renderer B) | placed (section 2 row V45) |
| G7-0569 | Spike: GarimaSceneKitRoom (renderer A) | placed (section 2 row V45) |
| G7-0572 | Spike .metal ships in Release | placed (section 2 row V51) |
| G7-0573 | Spike verdict: Design room portable both ways | placed (section 2 row V45) |
| G7-0608 | Test harness: SourceTree | placed (section 2 row V02) |
| G7-0609 | Test harness: Swift lexer and LawSource | placed (section 2 row V54) |
| G7-0610 | NeverMeasure: practice-symbol half (floor) | placed (section 2 row V33) |
| G7-0611 | NeverMeasure: word/digit half (lifted) | placed (section 2 row V33) |
| G7-0612 | RecognitionLines harness | placed (section 2 row V54) |
| G7-0613 | PositionIsIdentity harness | placed (section 2 row V54) |
| G7-0614 | Aniconic: no figure of a Sakti (floor) | placed (section 2 row V54) |
| G7-0615 | Aniconic: catalogue and iconographic-field pins (lifted) | placed (section 2 row V52) |
| G7-0616 | LedgerIsTheRecord vocabulary | placed (section 2 row V54) |
| G7-0617 | TypeScanner legibility harness | placed (section 2 row V54) |
| G7-0618 | SwiftProperties harness | placed (section 2 row V54) |
| G7-0619 | HomesCorpus 102-row fixture | placed (section 2 row V18) |
| G7-0620 | Ring fingerprints (sister divergence engine) | placed (section 2 row V54) |
| G7-0621 | UI press(until:) retry helper | placed (section 2 row V13) |
| G7-0622 | UI Reach base args | placed (section 2 row V18) |
| G7-0623 | ScreenReader .geom snapshot engine | placed (section 2 row V04) |
| G7-0624 | Spike performance harness | placed (section 2 row V45) |
| G7-0625 | Launch arguments inventory; no OPEN_WORLD | placed (section 2 row V18) |
| G7-0626 | CI post-clone script | placed (section 2 row V46) |
| G7-0627 | CI pre-xcodebuild script | placed (section 2 row V46) |
| G7-0628 | Snapshot baseline: mandala.geom | placed (section 2 row V54) |
| G7-0629 | Snapshot baseline: mandala-descent.geom | placed (section 2 row V54) |
| G7-0630 | Snapshot baseline: detail.geom | placed (section 2 row V54) |
| G7-0631 | Snapshot baseline: field.geom | placed (section 2 row V54) |
| G7-0632 | Snapshot baseline: memory.geom | placed (section 2 row V54) |
| G7-0633 | Snapshot baseline: recognition.geom | placed (section 2 row V54) |
| G7-0634 | Snapshot baseline: rite.geom | placed (section 2 row V54) |
| G7-0635 | Snapshot baseline: settings.geom | placed (section 2 row V54) |
| G7-0636 | Snapshot baseline: well.geom | placed (section 2 row V54) |
| G7-0637 | Snapshot baseline: well-letter.geom | placed (section 2 row V54) |
| G7-0638 | Composition lock retired; its replacement never built | placed (section 2 row V04) |
| G7-0639 | Settings baseline shows a sheet over the Well | placed (section 2 row V14) |
| G7-0640 | UI: BinduMandalaUITests | placed (section 2 row V54) |
| G7-0641 | UI: SpikeColdLaunchTests | placed (section 2 row V17) |
| G7-0642 | UI: HitAreaTests | placed (section 2 row V54) |
| G7-0643 | UI: MandalaLightReachTests spoken field and menu reach | placed (section 2 row V54) |
| G7-0644 | UI: TheMarginUITests data safety | placed (section 2 row V54) |
| G7-0645 | UI: TheWayInUITests walk | placed (section 2 row V13) |
| G7-0646 | UI: AccessibilityReachTests | placed (section 2 row V54) |
| G7-0647 | UI: FeltRegisterSnapshots engine | placed (section 2 row V54) |
| G7-0648 | UI: FeltRegisterClassifications | placed (section 2 row V04) |
| G7-0649 | UI: TheLibraryFoldUITests | placed (section 2 row V12) |
| G7-0650 | LawsTests corpus floors and tests | placed (section 2 row V54) |
| G7-0651 | LawsDrawnMeasureTests | placed (section 2 row V33) |
| G7-0652 | LawsTheMarginTests | placed (section 2 row V54) |
| G7-0653 | LegibilityTests | placed (section 2 row V54) |
| G7-0654 | DynamicTypeTests | placed (section 2 row V54) |
| G7-0655 | HitAreaIdiomTests 44 pt floor | placed (section 2 row V54) |
| G7-0656 | DeviceSlipTests | placed (section 2 row V54) |
| G7-0657 | EphemeralStoreTests and PinnedEnergyTests | placed (section 2 row V50) |
| G7-0658 | ActivityLedgerTests | placed (section 2 row V54) |
| G7-0659 | RecognitionDedupTests | placed (section 2 row V54) |
| G7-0660 | RecognitionMigratorTests | placed (section 2 row V54) |
| G7-0661 | PendingQueuePolicyTests | placed (section 2 row V54) |
| G7-0662 | SchemaMigrationTests | placed (section 2 row V54) |
| G7-0663 | LetterMigrationTests | placed (section 2 row V54) |
| G7-0664 | LetterDraftTests | placed (section 2 row V54) |
| G7-0665 | MarginTests | placed (section 2 row V54) |
| G7-0666 | SilenceDwellTests | placed (section 2 row V54) |
| G7-0667 | DescentMirrorTests | placed (section 2 row V54) |
| G7-0668 | HomeDwellingTests | placed (section 2 row V54) |
| G7-0669 | HomeMemoryTests | placed (section 2 row V54) |
| G7-0670 | WaveSixMemoryTests | placed (section 2 row V54) |
| G7-0671 | SeatLightingTests | placed (section 2 row V54) |
| G7-0672 | KhadgamalaMapTests | placed (section 2 row V54) |
| G7-0673 | DailyEnergyServiceTests | placed (section 2 row V54) |
| G7-0674 | DayLightTests | placed (section 2 row V54) |
| G7-0675 | RiteCompositionTests | placed (section 2 row V54) |
| G7-0676 | RiteDayTests | placed (section 2 row V54) |
| G7-0677 | ShaktiBijaTests | placed (section 2 row V54) |
| G7-0678 | CoherenceTests | placed (section 2 row V54) |
| G7-0679 | EnergyGiftTests | placed (section 2 row V54) |
| G7-0680 | MandalaCameraTests | placed (section 2 row V54) |
| G7-0681 | MandalaWorldTests | placed (section 2 row V54) |
| G7-0682 | MandalaYantraTests | placed (section 2 row V54) |
| G7-0683 | MandalaLightTests | placed (section 2 row V54) |
| G7-0684 | MandalaVoiceTests | placed (section 2 row V54) |
| G7-0685 | AtmosphereTests | placed (section 2 row V54) |
| G7-0686 | ElementTests | placed (section 2 row V54) |
| G7-0687 | TimeVariantModulationTests | placed (section 2 row V54) |
| G7-0688 | ShaktiStatusTests | placed (section 2 row V33) |
| G7-0689 | Spike suites (performance) | placed (section 2 row V45) |
| G7-0690 | HomesHarnessTests | placed (section 2 row V29) |
| G7-0691 | HomesWaveOneTests | placed (section 2 row V54) |
| G7-0692 | HomeGrammarTests | placed (section 2 row V54) |
| G7-0693 | HomeAttributeTests | placed (section 2 row V54) |
| G7-0694 | HomeDescentTests | placed (section 2 row V54) |
| G7-0695 | HomeSoundTests | placed (section 2 row V08) |
| G7-0696 | HomeVoiceTests | placed (section 2 row V08) |
| G7-0697 | HomeWorldsTests | placed (section 2 row V54) |
| G7-0698 | RoomSceneTests | placed (section 2 row V54) |
| G7-0699 | RoomCaptureTests | placed (section 2 row V05) |
| G7-0700 | CrossingRoomTests (Ring 2) | placed (section 2 row V54) |
| G7-0701 | SiddhiRoomTests (Ring 1 kp 1-10) | placed (section 2 row V54) |
| G7-0702 | MatrkaRoomTests (kp 11-18) | placed (section 2 row V54) |
| G7-0703 | MudraRoomTests (kp 19-28) | placed (section 2 row V54) |
| G7-0704 | BodilessRoomTests (Ring 3) | placed (section 2 row V54) |
| G7-0705 | CosmicRoomTests (Ring 4) | placed (section 2 row V54) |
| G7-0706 | GivingRoomTests (Ring 5) | placed (section 2 row V54) |
| G7-0707 | RevealingRoomTests (Ring 6) | placed (section 2 row V54) |
| G7-0708 | SoundingRoomTests (Ring 7) | placed (section 2 row V54) |
| G7-0709 | SourcingRoomTests (Ring 8) | placed (section 2 row V54) |
| G7-0710 | GateRoomTests (Laghima kp 3 and Garima kp 4 ('the Gate')) | placed (section 2 row V54) |
| G7-0711 | DissolveRoomTests (kp 102) | placed (section 2 row V54) |
| G7-0712 | WholeInstrumentTests | placed (section 2 row V54) |
| G7-0713 | RiteOfEnteringTests | placed (section 2 row V54) |
| G7-0714 | TheWayInTests reachability core | placed (section 2 row V12) |
| G7-0715 | GateLookTests | placed (section 2 row V05) |
| G7-0716 | Garima spike suites (renderer variants) | placed (section 2 row V45) |
| G7-0717 | RecognitionNatureTests | placed (section 2 row V54) |
| G7-0718 | TheLibraryFoldTests | placed (section 2 row V54) |
| G7-0719 | SomaticRegionTests | placed (section 2 row V54) |
| G7-0720 | LivingMandalaTests | placed (section 2 row V54) |
| G7-0721 | OneBuildingTests | placed (section 2 row V54) |
| G7-0722 | WorldClimbTests (reads Design from disk) | placed (section 2 row V06) |
| G7-0723 | WorldClimbCaptureTests | placed (section 2 row V05) |
| G7-0724 | ChakraConstellationTests | placed (section 2 row V54) |
| G7-0725 | ChakraRoomTests | placed (section 2 row V54) |
| G7-0726 | PlayTests | placed (section 2 row V54) |
| G7-0727 | PlayWholeTests | placed (section 2 row V54) |
| G7-0728 | GameStructureTests | placed (section 2 row V54) |
| G7-0729 | ModesAndRitesTests | placed (section 2 row V54) |
| G7-0730 | EphemerisTests | placed (section 2 row V54) |
| G7-0731 | LunarPhaseServiceTests | placed (section 2 row V54) |
| G7-0732 | TheRiverTests | placed (section 2 row V54) |
| G7-0733 | Lifted-rule test: CoherenceTests.swift:17 | placed (section 2 row V52) |
| G7-0734 | Lifted-rule test: CoherenceTests.swift:34 | placed (section 2 row V11) |
| G7-0735 | Lifted-rule test: RiteDayTests.swift:21 | placed (section 2 row V52) |
| G7-0736 | Lifted-rule test: HitAreaIdiomTests.swift:220 | placed (section 2 row V52) |
| G7-0737 | Lifted-rule test: GameStructureTests.swift:247 | placed (section 2 row V52) |
| G7-0738 | Lifted-rule test: GameStructureTests.swift:278 | placed (section 2 row V52) |
| G7-0739 | Lifted-rule test: OneBuildingTests.swift:434 | placed (section 2 row V52) |
| G7-0740 | Lifted-rule test: CoherenceTests.swift:99 | placed (section 2 row V52) |
| G7-0741 | Lifted-rule test: WaveSixMemoryTests.swift:233 | placed (section 2 row V52) |
| G7-0742 | Lifted-rule test: LawsTests.swift:1316 | placed (section 2 row V52) |
| G7-0743 | Lifted-rule test: LawsTests.swift:1417 | placed (section 2 row V52) |
| G7-0744 | Lifted-rule test: LawsTests.swift NeverMeasure | placed (section 2 row V52) |
| G7-0745 | Lifted-rule test: HomesHarnessTests.swift | placed (section 2 row V52) |
| G7-0746 | Lifted-rule test: MandalaLightReachTests.swift:152 | placed (section 2 row V52) |
| G7-0747 | Lifted-rule test: MandalaLightReachTests.swift:315 | placed (section 2 row V52) |
| G7-0748 | Lifted-rule test: TheWayInUITests.swift:349 | placed (section 2 row V52) |
| G7-0749 | Lifted-rule test: TheMarginUITests.swift:138 | placed (section 2 row V52) |
| G7-0750 | Lifted-rule test: TheMarginUITests.swift:232 | placed (section 2 row V52) |
| G7-0751 | Lifted-rule test: LawsTheMarginTests:2273 | placed (section 2 row V52) |
| G7-0752 | Lifted-rule test: LawsTheMarginTests:2327 | placed (section 2 row V52) |
| G7-0753 | Lifted-rule test: MandalaVoiceTests.swift:147 | placed (section 2 row V52) |
| G7-0754 | Lifted-rule test: RiteOfEnteringTests.swift:608 | placed (section 2 row V52) |
| G7-0755 | Lifted-rule test: TheWayInTests.swift:317 | placed (section 2 row V52) |
| G7-0756 | Lifted-rule test: TheWayInTests.swift:540 | placed (section 2 row V52) |
| G7-0757 | Lifted-rule test: CoherenceTests.swift:44 | placed (section 2 row V52) |
| G7-0758 | Lifted-rule test: ModesAndRitesTests.swift | placed (section 2 row V52) |
| G7-0759 | Lifted-rule test: RiteDayTests.swift | placed (section 2 row V52) |
| G7-0760 | Lifted-rule test: TheRiverTests.swift | placed (section 2 row V52) |
| G7-0761 | Lifted-rule test: MarginDateTests | placed (section 2 row V52) |
| G7-0762 | Lifted-rule test: PlayTests.swift:488 | placed (section 2 row V52) |
| G7-0763 | Lifted-rule test: TheLibraryFoldUITests.swift:163 | placed (section 2 row V52) |
| G7-0764 | Lifted-rule test: TheLibraryFoldTests.swift | placed (section 2 row V52) |
| G7-0765 | Lifted-rule test: ChakraConstellation spoken-row checks | placed (section 2 row V52) |
| G7-0766 | Lifted-rule test: MandalaVeil spoken-row checks | placed (section 2 row V52) |
| G7-0767 | Lifted-rule test: RiteOfEnteringTests.swift:644 | placed (section 2 row V52) |
| G7-0768 | Lifted-rule test: TheWayInUITests.swift:424 | placed (section 2 row V52) |
| G7-0769 | Lifted-rule test: LawsTests.swift:1741 | placed (section 2 row V52) |
| G7-0770 | Lifted-rule test: LawsTests.swift:1787 | placed (section 2 row V52) |
| G7-0771 | Lifted-rule test: LawsTests.swift:1867 | placed (section 2 row V52) |
| G7-0772 | Lifted-rule test: RecognitionNatureTests.swift:299 | placed (section 2 row V52) |
| G7-0773 | Lifted-rule test: PlayTests.swift:573 | placed (section 2 row V52) |
| G7-0774 | Lifted-rule test: HomeDescentTests.swift:203 | placed (section 2 row V52) |
| G7-0775 | Lifted-rule test: RoomSceneTests.swift | placed (section 2 row V52) |
| G7-0776 | Lifted-rule test: CrossingRoomTests.swift | placed (section 2 row V52) |
| G7-0777 | Lifted-rule test: SiddhiRoomTests.swift | placed (section 2 row V52) |
| G7-0778 | Lifted-rule test: MatrkaRoomTests.swift | placed (section 2 row V52) |
| G7-0779 | Lifted-rule test: MudraRoomTests.swift | placed (section 2 row V52) |
| G7-0780 | Lifted-rule test: BodilessRoomTests.swift:441 | placed (section 2 row V52) |
| G7-0781 | Lifted-rule test: CosmicRoomTests.swift:576 | placed (section 2 row V52) |
| G7-0782 | Lifted-rule test: GivingRoomTests.swift | placed (section 2 row V52) |
| G7-0783 | Lifted-rule test: RevealingRoomTests.swift | placed (section 2 row V52) |
| G7-0784 | Lifted-rule test: SoundingRoomTests.swift | placed (section 2 row V52) |
| G7-0785 | Lifted-rule test: SourcingRoomTests.swift | placed (section 2 row V52) |
| G7-0786 | Lifted-rule test: GateRoomTests.swift:126 | placed (section 2 row V52) |
| G7-0787 | Lifted-rule test: DissolveRoomTests.swift | placed (section 2 row V52) |
| G7-0788 | Lifted-rule test: RiteOfEnteringTests.swift:267 | placed (section 2 row V52) |
| G7-0789 | Lifted-rule test: RiteOfEnteringTests.swift:822 | placed (section 2 row V52) |
| G7-0790 | Lifted-rule test: WorldClimbTests.swift | placed (section 2 row V52) |
| G7-0791 | Lifted-rule test: RoomSceneTests five SurfaceVerbs | placed (section 2 row V52) |
| G7-0792 | Lifted-rule test: MudraRoomTests.swift | placed (section 2 row V52) |
| G7-0793 | Lifted-rule test: LawsTests.swift:1830 | placed (section 2 row V52) |
| G7-0794 | Lifted-rule test: MandalaLightTests.swift:71 | placed (section 2 row V52) |
| G7-0795 | Lifted-rule test: MandalaLightTests.swift:188 | placed (section 2 row V52) |
| G7-0796 | Lifted-rule test: MandalaYantraTests.swift:277 | placed (section 2 row V52) |
| G7-0797 | Lifted-rule test: MandalaLightTests.swift:143 | placed (section 2 row V52) |
| G7-0798 | Lifted-rule test: MandalaLightTests.swift:158 | placed (section 2 row V52) |
| G7-0799 | Lifted-rule test: MandalaLightTests.swift:506 | placed (section 2 row V52) |
| G7-0800 | Lifted-rule test: LawsDrawnMeasureTests.swift:2123 | placed (section 2 row V52) |
| G7-0801 | Lifted-rule test: LawsDrawnMeasureTests.swift:2150 | placed (section 2 row V52) |
| G7-0802 | Lifted-rule test: SpikeCensusTests | placed (section 2 row V52) |
| G7-0803 | Lifted-rule test: PlayTests.swift:559 | placed (section 2 row V52) |
| G7-0804 | Lifted-rule test: TheWayInTests.swift:142 | placed (section 2 row V52) |
| G7-0805 | Lifted-rule test: TheWayInTests.swift:171 | placed (section 2 row V52) |
| G7-0806 | Lifted-rule test: UI tests default START_TAB=rite | placed (section 2 row V17) |
| G7-0807 | Lifted-rule test: BinduMandalaUITests.swift setUp | placed (section 2 row V17) |
| G7-0808 | Lifted-rule test: RiteOpening.opens | placed (section 2 row V17) |
| G7-0809 | Lifted-rule test: upper luminance bounds (mean < .9; GarimaCanvasSpike mean < 175) | placed (section 2 row V05) |
| G7-0810 | Lifted-rule test: HomeSoundTests / HomeMemoryTests.swift:89-122 | placed (section 2 row V52) |
| G7-0811 | Lifted-rule test: HomeDescentTests.swift:327-339 | placed (section 2 row V52) |
| G7-0812 | Lifted-rule test: WaveSixMemoryTests.swift:371 | placed (section 2 row V52) |
| G7-0813 | Lifted-rule test: HomeMemoryTests.swift:89-122 | placed (section 2 row V52) |
| G7-0814 | Lifted-rule test: TheWayInUITests | placed (section 2 row V52) |
| G7-0815 | Lifted-rule test: ChakraConstellation crossings | placed (section 2 row V52) |
| G7-0816 | Lifted-rule test: FeltRegisterSnapshots.swift:449 | placed (section 2 row V04) |
| G7-0817 | Lifted-rule test: FeltRegisterClassifications.swift | placed (section 2 row V04) |
| G7-0818 | Lifted-rule test: TheLibraryFoldUITests.swift:438-507 | placed (section 2 row V04) |
| G7-0819 | Lifted-rule test: TheLibraryFoldTests.swift:226 | placed (section 2 row V04) |
| G7-0820 | Lifted-rule test: HitAreaIdiomTests.swift:220 | placed (section 2 row V04) |
| G7-0821 | Lifted-rule test: TheMarginUITests.swift:232 | placed (section 2 row V04) |
| G7-0822 | Lifted-rule test: SnapshotBaselines 30 .geom | placed (section 2 row V04) |
| G7-0823 | Floor test: ActivityLedgerTests | placed (section 2 row V53) |
| G7-0824 | Floor test: RecognitionDedupTests | placed (section 2 row V53) |
| G7-0825 | Floor test: RecognitionMigratorTests | placed (section 2 row V53) |
| G7-0826 | Floor test: PendingQueuePolicyTests | placed (section 2 row V53) |
| G7-0827 | Floor test: SchemaMigrationTests | placed (section 2 row V53) |
| G7-0828 | Floor test: LetterMigrationTests | placed (section 2 row V53) |
| G7-0829 | Floor test: LetterDraftTests | placed (section 2 row V53) |
| G7-0830 | Floor test: MarginTests | placed (section 2 row V53) |
| G7-0831 | Floor test: LawsTheMarginTests (data half) | placed (section 2 row V53) |
| G7-0832 | Floor test: SilenceDwellTests | placed (section 2 row V53) |
| G7-0833 | Floor test: DescentMirrorTests | placed (section 2 row V53) |
| G7-0834 | Floor test: HomeDwellingTests | placed (section 2 row V53) |
| G7-0835 | Floor test: HomeMemoryTests (store) | placed (section 2 row V53) |
| G7-0836 | Floor test: WaveSixMemoryTests (stores) | placed (section 2 row V53) |
| G7-0837 | Floor test: TheRiverTests (kept) | placed (section 2 row V53) |
| G7-0838 | Floor test: LivingMandalaTests (strokes) | placed (section 2 row V53) |
| G7-0839 | Floor test: ModesAndRitesTests (witness) | placed (section 2 row V53) |
| G7-0840 | Floor test: PlayWholeTests.swift:352 | placed (section 2 row V53) |
| G7-0841 | Floor test: EphemeralStoreTests | placed (section 2 row V53) |
| G7-0842 | Floor test: TheMarginUITests (:115, :193, :303) | placed (section 2 row V53) |
| G7-0843 | Floor test: RecognitionNatureTests (written before any light moves) | placed (section 2 row V53) |
| G7-0844 | Floor test: LawsTests.swift:1570-1641 | placed (section 2 row V53) |
| G7-0845 | Floor test: KhadgamalaMapTests | placed (section 2 row V53) |
| G7-0846 | Floor test: SeatLightingTests | placed (section 2 row V53) |
| G7-0847 | Floor test: MandalaWorldTests | placed (section 2 row V53) |
| G7-0848 | Floor test: MandalaLightTests.swift:122 (102 distinct colours) | placed (section 2 row V53) |
| G7-0849 | Floor test: WholeInstrumentTests | placed (section 2 row V53) |
| G7-0850 | Floor test: HomesHarnessTests (kp 99 name collision) | placed (section 2 row V53) |
| G7-0851 | Floor test: GateRoomTests (61 of 102 names drifted) | placed (section 2 row V53) |
| G7-0852 | Floor test: PlayTests.swift:23-64 | placed (section 2 row V53) |
| G7-0853 | Floor test: ChakraConstellationTests | placed (section 2 row V53) |
| G7-0854 | Floor test: LawsTests.swift:1915-2022 | placed (section 2 row V53) |
| G7-0855 | Floor test: ActivityLedgerTests | placed (section 2 row V53) |
| G7-0856 | Floor test: PlayTests.swift:412 | placed (section 2 row V53) |
| G7-0857 | Floor test: ModesAndRitesTests.swift:288 | placed (section 2 row V53) |
| G7-0858 | Floor test: TheRiverTests.swift:202 | placed (section 2 row V53) |
| G7-0859 | Floor test: ChakraRoomTests (Chakra Practiced) | placed (section 2 row V53) |
| G7-0860 | Floor test: OneBuildingTests (State Set Down, Siddhi Received, Silence Held) | placed (section 2 row V53) |
| G7-0861 | Floor test: HomeDwellingTests | placed (section 2 row V53) |
| G7-0862 | Floor test: GameStructureTests.swift:157 | placed (section 2 row V53) |
| G7-0863 | Floor test: WaveSixMemoryTests (Codex) | placed (section 2 row V53) |
| G7-0864 | Floor test: LawsTests.swift:1453 | placed (section 2 row V53) |
| G7-0865 | Floor test: LawsTests.swift:1483 | placed (section 2 row V53) |
| G7-0866 | Floor test: LawsTests.swift:1540 | placed (section 2 row V53) |
| G7-0867 | Floor test: BinduMandalaUITests.swift:38 | placed (section 2 row V53) |
| G7-0868 | Floor test: AccessibilityReachTests.swift:481 | placed (section 2 row V53) |
| G7-0869 | Floor test: RecognitionNatureTests timeline | placed (section 2 row V53) |
| G7-0870 | Floor test: ShaktiBijaTests | placed (section 2 row V41) |
| G7-0871 | Floor test: RiteCompositionTests.swift:41 | placed (section 2 row V53) |
| G7-0872 | Floor test: HomeDescentTests (empty never invented) | placed (section 2 row V53) |
| G7-0873 | Floor test: ModesAndRitesTests.swift:211 (Carry nil) | placed (section 2 row V53) |
| G7-0874 | Floor test: SomaticRegionTests.swift:64 | placed (section 2 row V53) |
| G7-0875 | Floor test: RecognitionMigratorTests.swift:34 | placed (section 2 row V53) |
| G7-0876 | Floor test: HomesCorpus provenance | placed (section 2 row V53) |
| G7-0877 | Floor test: EphemerisTests (published values) | placed (section 2 row V53) |
| G7-0878 | Floor test: ChakraRoomTests verbatim | placed (section 2 row V53) |
| G7-0879 | Floor test: GameStructureTests bake | placed (section 2 row V53) |
| G7-0880 | Floor test: PlayTests seats read off the table | placed (section 2 row V53) |
| G7-0881 | Floor test: CoherenceTests.swift:106 (GratitudeGrace one table one field fetch only) | placed (section 2 row V38) |
| G7-0882 | Floor test: ci_post_clone.sh (PAT never echoed) | placed (section 2 row V38) |
| G7-0883 | Floor test: ModesAndRitesTests LowStateDoor | placed (section 2 row V38) |
| G7-0884 | Floor test: LawsTests.swift:856 Aniconic figural vocabulary | placed (section 2 row V53) |
| G7-0885 | Floor test: HomeAttributeTests.swift:304 | placed (section 2 row V53) |
| G7-0886 | Floor test: RoomSceneTests (no figural node) | placed (section 2 row V53) |
| G7-0887 | Floor test: RecognitionNatureTests.swift:299 | placed (section 2 row V53) |
| G7-0888 | Floor test: PlayTests.swift:573 | placed (section 2 row V53) |
| G7-0889 | Floor test: LawsTests.swift:1340 | placed (section 2 row V53) |
| G7-0890 | Floor test: LawsDrawnMeasureTests | placed (section 2 row V53) |
| G7-0891 | Floor test: OneBuildingTests C-1284 | placed (section 2 row V53) |
| G7-0892 | Floor test: RiteDayTests.swift:148 ('Nothing was asked of you today.') | placed (section 2 row V53) |
| G7-0893 | Floor test: PlayTests.swift:520 | placed (section 2 row V53) |
| G7-0894 | Floor test: PlayTests.swift:542 | placed (section 2 row V53) |
| G7-0895 | Floor test: TheRiverTests.swift:150 (Wager) | placed (section 2 row V53) |
| G7-0896 | Floor test: ModesAndRitesTests.swift:104 (Smrti one light) | placed (section 2 row V53) |
| G7-0897 | Floor test: RiteDayTests.swift:116 (grace never of today) | placed (section 2 row V53) |
| G7-0898 | Floor test: GameStructureTests.swift:232 (ThreePools state not tally) | placed (section 2 row V53) |
| G7-0899 | Floor test: TheLibraryFoldTests.swift:152 | placed (section 2 row V53) |
| G7-0900 | Floor test: LegibilityTests | placed (section 2 row V44) |
| G7-0901 | Floor test: DynamicTypeTests | placed (section 2 row V44) |
| G7-0902 | Floor test: HitAreaIdiomTests (44 pt half) | placed (section 2 row V44) |
| G7-0903 | Floor test: HitAreaTests | placed (section 2 row V44) |
| G7-0904 | Floor test: AccessibilityReachTests | placed (section 2 row V44) |
| G7-0905 | Floor test: MandalaVoiceTests | placed (section 2 row V44) |
| G7-0906 | Floor test: DeviceSlipTests (reduce motion) | placed (section 2 row V44) |
| G7-0907 | Floor test: every room's reduce-motion test | placed (section 2 row V44) |
| G7-0908 | Floor test: TheMarginUITests.swift:350 | placed (section 2 row V44) |
| G7-0909 | Floor test: TheLibraryFoldUITests.swift:370 | placed (section 2 row V44) |
| G7-0910 | Floor test: GameStructureTests.swift:115-146 | placed (section 2 row V34) |
| G7-0911 | Floor test: CoherenceTests.swift:90 | placed (section 2 row V53) |
| G7-0912 | Floor test: PlayTests.swift:51 | placed (section 2 row V53) |
| G7-0913 | Floor test: PlayTests.swift:80 | placed (section 2 row V53) |
| G7-0914 | Floor test: ChakraRoomTests (road 5) | placed (section 2 row V53) |
| G7-0915 | Floor test: CoherenceTests.swift:106-157 | placed (section 2 row V53) |
| G7-0916 | Floor test: GameStructureTests.swift:43-46 (never a Leela drop) | placed (section 2 row V53) |
| G7-0917 | Floor test: ChakraConstellationTests (Sanskrit nil) | placed (section 2 row V53) |
| G7-0918 | Floor test: MandalaCameraTests (descentTarget 5.4) | placed (section 2 row V53) |
| G7-0919 | Floor test: OneBuildingTests.swift:415 (Pravesha never reaches a bottom) | placed (section 2 row V53) |
| G7-0920 | Missing floor test: No generated voice | placed (section 2 row V09) |
| G7-0921 | Missing floor test: Ruling: dissolutions once a day | placed (section 2 row V34) |
| G7-0922 | Missing floor test: Ruling: Homecoming each launch | placed (section 2 row V17) |
| G7-0923 | New test: World Registry is whole | placed (section 2 row V11) |
| G7-0924 | New test: Reachability matrix: every world by every route | placed (section 2 row V12) |
| G7-0925 | New test: UI reachability | placed (section 2 row V13) |
| G7-0926 | New test: Nothing laid over another world | placed (section 2 row V14) |
| G7-0927 | New test: Back-to-where-you-were | placed (section 2 row V15) |
| G7-0928 | New test: The point everywhere | placed (section 2 row V16) |
| G7-0929 | New test: Launch arrives at the Bindu, Today first door | placed (section 2 row V17) |
| G7-0930 | New test: Ruling tests | placed (section 2 row V34) |
| G7-0931 | New test: Relationship Field built in full | placed (section 2 row V36) |
| G7-0932 | New test: PracticeStoreContract | placed (section 2 row V35) |
| G7-0933 | New test: Sound mixing law | placed (section 2 row V08) |
| G7-0934 | New test: Search | placed (section 2 row V37) |
| G7-0935 | New test: Design parity | placed (section 2 row V04) |
| G7-0936 | New test: Performance per world | placed (section 2 row V45) |
| G7-0937 | New test: No generated voice; Airtable read allow-list | placed (section 2 row V09) |
| G7-0938 | Walk driver | placed (section 2 row V18) |
| G7-0939 | Walk state | placed (section 2 row V18) |
| G7-0940 | Walk script | placed (section 2 row V18) |
| G7-0941 | Walk checks at every step | placed (section 2 row V19) |
| G7-0942 | Walk record | placed (section 2 row V20) |
| G7-0943 | Walk matrix | placed (section 2 row V20) |
| G7-0944 | Walk output | placed (section 2 row V20) |
| G7-0945 | Numbers parity read from Design's own files | placed (section 2 row V06) |
| G7-0946 | Geometry parity | placed (section 2 row V04) |
| G7-0947 | Light parity | placed (section 2 row V05) |
| G7-0948 | Timing parity | placed (section 2 row V07) |
| G7-1015 | Test gift: MandalaVoice for search | placed (section 2 row V37) |
| G7-1018 | Test gift: G5 performance census and renderer spikes | placed (section 2 row V45) |
| G7-1019 | Test gift: Design's three registers as a room test | placed (section 2 row V31) |
| G7-1020 | Test gift: GateLook legibility register as per-room test | placed (section 2 row V05) |
| G7-1024 | Test targets path | placed (section 2 row V54) |
| G7-1025 | Light bounds far below Design | placed (section 2 row V05) |
| G7-1026 | UI tests can see 16 of 102 | placed (section 2 row V18) |
| G7-1028 | Ruling 3 (Axis 18, Crow 19) not pinned in tests | placed (section 2 row V34) |
| G7-1029 | Ruling 4 elements conflict with tattva physics | placed (section 2 row V34) |
| G7-1030 | Rulings with no test | placed (section 2 row V34) |
| G7-1031 | Two-state seats and veil-cannot-learn vs nothing scores him | placed (section 2 row V33) |
| G7-1034 | Open defect carried as expected failure | placed (section 2 row V48) |
| G7-1035 | Pinned exceptions will churn | placed (section 2 row V44) |
| G7-1036 | Design's numbers retyped, not read | placed (section 2 row V06) |
| G7-1037 | SceneKit capture caveat | placed (section 2 row V05) |
| G7-1040 | Spike screenshots outside repo | placed (section 2 row V20) |
| G7-1041 | Rite veil name alpha .24 legibility exemption | placed (section 2 row V44) |
| G7-1042 | Test suite three kinds: lifted, floors, craft | placed (section 2 row V54) |

### 8.1 The check (script and result)

```
python3 -I check.py waves/upgrade/worlds/verification.md waves/upgrade/index/by-world/verification.jsonl
slice ids: 719 | in section 8: 719 | missing: 0 | unplaced: 0 | not in slice: 0
  merged into its original frame 6
  not this world       17
  placed               681
  rejected             15
```

The script parses every `| G?-#### | … | disposition |` row of this section, compares the set with the 719 ids of the slice, and fails on any id missing, any disposition reading MISSING, or any id not in the slice.
