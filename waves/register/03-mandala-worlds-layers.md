# THE REGISTER · 03 — The Mandala Family, the Worlds and the Layers

Reader 3 of 7 · compiled 2026-10-12 · source: `/home/claude/design-upload/extracted/` (cross-checked against repo `Claude Designs/`).
Every assigned file was read completely, line 1 to EOF, with the Read tool (no file needed pretty-printing — none has a line over 400 chars). Coverage proof is Part C.

**How to use this register.** Part A0 gives the map of how the pieces connect and the two master tables (the nine worlds, the eight modes) that a builder needs first. A1–A15 then go file by file, entry by entry (id · source lines · SEES · DOES · MOTION · SOUND · WORDS · DATA · ARRIVE/LEAVE · MEMORY). Part B quotes the design's own stated intentions verbatim. Part C is the coverage proof. Part D lists what must not be missed.

**Shared visual constants** (used everywhere unless an entry says otherwise): ground #060104 · gold #C9963F · cream #F2E8D9 · bindu crimson (COLORS.accentRed) #8B1A2A · ancient-ground amber #CF9443 · Cormorant Garamond 300 (italic for voice) + -apple-system for small caps eyebrows (9–11px, letter-spacing .2–.32em, uppercase) · 390×844 phone artboards · gold dust motes rising (`moteRise`, 16–30s) · HomeIndicator 134×5 · StatusBar "9:41". Petal path for every lotus: `M 0,-iR C hw,(-1.85·iR) (.95·hw),(-.85·oR) 0,-oR C … Z`. Ring-2 petals are coloured by CLUSTER_INFO[cluster].color and dimmed by STATUS_OPACITY[status] (mapped / exploring / active / embodied) from `shakti-data.js` (not in my assignment; read by another reader).

---

## A0. THE CONNECTION MAP (how the pieces fit)

### A0.1 Chronology of the design (as the files themselves state it)
| Stage | File(s) | What it is | Status relative to later stages |
|---|---|---|---|
| v1 | Mandala App.html + screens.jsx | Tabbed app: Today / Mandala / The Well; Ring 2 only; labelled petals, "TODAY", "I feel her" | Superseded; archived in v2 canvas |
| v2 "Nine Rings" | Mandala App v2.html + mandala-v2.jsx + screens-v2.jsx | All nine rings drawn with unlock ladder (ancient/home/unlocked/locked/deep_ghost); Avaraṇa Threshold; Quick Catch; RingIndicator; expanded detail; Silence with two orbitals | Superseded as Home by Phase II, but SriYantraMandala lives on as the **held yantra** in Legend and Veil |
| Phase I | Codex.html | The ontology: 5 dimensions, 8 modes, 9-gesture grammar, 9 ring-worlds, home as living state, 8-phase path | The governing document |
| Phase II | Home Mandala.html + home-mandala.jsx | Pure label-less Home in five temporal states | "v2 was a diagram. v3 is the yantra itself." |
| Phase III | Ring Worlds.html + ring-worlds.jsx | Rings 2, 7, 8 realised (Codex said build these three first) | |
| Phase III·b/c | Ring Worlds II.html + ring-worlds-2.jsx (R1), ring-worlds-3.jsx (R3–6), ring-nine.jsx (R9) | The six deferred rings, each "finding its own verb" | Completes all nine |
| Phase IV | The Eight Modes.html + modes.jsx | Each mode as its own atmosphere | |
| Phase V | The Temporal Layer.html + temporal.jsx | 6 temporal instruments + Data & Time Contracts | |
| Phase VI | The Memory Layer.html + memory.jsx | 7 memory instruments | |
| Phase VII | The Relationship Field.html + relationship.jsx | 6 relationship instruments | Phase VIII (Initiation) is NOT in these files |
| Navigation rethink | Mandala Legend.html + legend-explorations.jsx → Mandala Veil.html + veil-mandala.jsx | "The yantra stays a beautiful, non-interactive presence"; navigation moves to a Legend; four placements explored; **the Veil chosen and specified at full fidelity as a "design handoff to Claude Code"** | Partly reverses Codex §IV (see A0.4) |

### A0.2 The navigation graph (all routes found in code or stated in words)
- **Home (held yantra)** — Phase II PureMandala (no labels) or Veil's HeldYantra (SriYantraMandala ×.82 with eyebrow "2nd Avaraṇa · Sarvāśā-Paripūraka" and caption "the instrument · look, do not operate").
  - **Swipe up / tap handle → the Veil** (sheet 720 high, peek 108; tap = movement < 6px; snap open if dragged above 42% of travel; yantra dims to 0.5). Swipe down or tap the dimmed yantra → closes.
  - **Inside the Veil → The Nine Avaraṇas** column: rows I–VIII + Bindu footer IX. Tap a row → Destination overlay: Ring II (if open) → **RingTwoWorld** (the inhabited lotus); every other ring → **AvaranaThresholdScreen** (doorway if open, ceremony if locked; button "Enter this Avaraṇa"). Back = Esc or the "‹ Mandala" hotspot.
  - Codex grammar from Home: tap a ring → that ring-world; tap bindu → Mauna; long-press a ring → Smṛti; pinch out → Sādhana; hold vertical still → Darśana; swipe up from edge → today's pull; swipe down from top → Pūjā (evening only); two-finger hold → invoke a Shakti; long-press anywhere → Recognition (catch).
  - Time opens modes automatically: first open of the day → Svapna; dawn/noon/dusk → the three Sandhyās ("the app opens to these by default"); after sunset → Pūjā; ambient → Saṅgha.
- **Inside a ring-world:** ReturnGesture/ReturnArc at top 56 = "swipe down to return to home"; lower-left sound toggle; each world has its own verb (A0.3).
- **Memory:** Portrait Mandala → tap petal → Petal Biography ("‹ Portrait"); Shakti's Carriers also backs to "‹ Portrait" (bridge Memory ↔ Relationship); Density Atlas "tap any day · see its catches" / "tap any month · zoom in"; Lifetime Spiral "tap a ring · enter that year"; Smṛti "tap any star · open her log".
- **Relationship:** Field → tap name → Person Page ("‹ Field"); hold → Add a Beloved ritual (4 steps); Field Web "tap a thread · see which shakti runs through"; Saṅgha mode (outer) → person detail.
- **Temporal:** Great Wheel "swipe ← → · navigate years", "tap any day · open its catches".
- **v1/v2 (superseded):** TabBar Today/Mandala/The Well; "‹ Mandala" back buttons; "Tap a petal to enter · Bindu for silence"; "Tap to enter · Hold to catch · Bindu for silence".

### A0.3 THE NINE WORLDS — master table (Codex intention vs. what was built)
| Ring | Name | Codex atmosphere / geometry / breath / count | Built world (file · component) | Built light & colour | Built mechanism (the verb) | Sound (exact) | Key words |
|---|---|---|---|---|---|---|---|
| 1 | Bhūpura · Trailokyamohana — "the Earth-City" | warm amber, still · square with T-gates · none · 28 | ring-worlds-2.jsx · RingOneWorld | bg #0C0703→#060301; ambient rgba(207,148,67,.11) low; families Siddhi #D9A93C / Mātṛkā #CF9443 / Mudrā #B07F36 | 3 nested squares = 3 families (10 outer / 8 middle / 10 inner) of 28 lights; tap light = meet; tap family = illumine; tap a gate = all 28 alight; tap ground = release | drone 73.42 Hz + 110 Hz (gain .4), fade-in 2.2s to .05, LFO .07 Hz | "The ground you have walked, before you knew it was hers." / "Thank you for the world I have walked through without knowing it was you." |
| 2 | Sarvāśā-Paripūraka · Sixteen-Petal Lotus — **Home** | warm cream & cluster colours · 16-petal full screen · 3s wave · 16 Karṣiṇīs | ring-worlds.jsx · RingTwoWorld (+ RingTwoLotusByTime) | bg #0A0608→#050103; cluster colours; today halo | press-and-hold a petal = invoke (others mute to 18%); release → she remains 2.6s; lotus opens/closes with the sun (openFactor .78/1/.85/.45) | home voice 130.81 Hz (C3) + 196 Hz, LFO .18 Hz, gain .045 → .075 while pressing | "press a petal to invoke her presence" / "release · she remains" |
| 3 | Sarvasaṅkṣobhaṇa · 8 Anaṅgas — "the Smoke Lotus" | translucent, smoke-like · 8 wide petals · 8s pulse · 8 | ring-worlds-3.jsx · RingThreeWorld | rose #C4725A plumes, gradient #E0937A→#8B1A2A, blur 5.5 | **stillness gathers / reaching scatters** (pointer motion = 800ms "moving"); touch plume; seed "hsauṁ" unifies all 8 for 2.6s | sustain 116.5 Hz, vibrato 6 | "The more you reach for her, the more she thins." / "Be still — and the bodiless longing gathers." |
| 4 | Sarvasaubhāgyadāyaka · 14 Sampradāya | cool blue-violet, crystalline · 14 triangles · 9s · 14 | ring-worlds-3.jsx · RingFourWorld | **green #6FA37E** (differs from Codex #9AB4C9) | transmission travels the garland station by station every 340ms (auto at 900ms); tap centre to send; tap station to read | rising notes from 174.6 Hz | "The garland is unbroken — every name still passed, hand to hand." |
| 5 | Sarvārthasādhaka · 10 Kulottīrṇa | luminous green-gold · 10 outer tri · 11s · 10 | ring-worlds-3.jsx · RingFiveWorld | gold #D4A017 | tap one → rays overflow the kula circle; centre → all ten flood, boundary dissolves to dashed | 261.6 Hz; flood = 4-note cluster 90ms apart | "The accomplishment overflows the one who sought it." |
| 6 | Sarvarakṣākara · 10 Nigarbha | rose-violet, deep · 10 inner tri · 13s · 10 | ring-worlds-3.jsx · RingSixWorld | violet #9A86C4 (Codex #C99AB4) | a light follows the finger; only triangles within 92px are visible/tappable; whisper fades in 3.2s | sustain 207.65 Hz whose gain rises with nearness | "What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near." |
| 7 | Sarvarogahara · Vāk | resonant gold, sonic · 8 tri + tone rings · 15s + tone pulse · **8** | ring-worlds.jsx · RingSevenWorld | bg #0E0703; gold #E8C97A; rgba(212,160,23,.16) | 12 syllable nodes (orbit r140) tap to sound; centre = chord of all 12 staggered 55ms; **healed at ≥7 of 12 sounded** | 12 bījas 220→659.25 Hz, sine + octave | "The word that healed what the mind could not reach." / "she who removes all disease" |
| 8 | Sarvasiddhiprada · Mūla Trikoṇa | pure cream against black · three points · 18s almost still · 3 | ring-worlds.jsx · RingEightWorld | cream triangle; Icchā #C45050, Jñāna #9A8FC4, Kriyā #5A9A8B | tap a vertex → the other two collapse into it; tap → dissolves to a swollen Bindu (r7→52, 1.4s); tap → begin again | minor triad 261.63/311.13/392 → one vertex → all to 130.81 Hz | "The three were never three." / "Will, knowing, doing — three motions of the same hand. The hand was always whole." |
| 9 | Sarvānandamaya · the Bindu · Lalitā | everything & nothing · a single point · your own (Home breath table: 4s) · 1 | ring-nine.jsx · **RingNineDescent (Praveśa, CHOSEN)**; RingNineSpanda (explored) | bg #0B0410→#010005; 7 nested gold yantras spiralling inward | press and hold to fall inward forever; hold ≥6.5s → recognition fades in over 2.2s (full at 8.7s); release decays ×1.4 | Shepard tone (7 octaves from 32.7 Hz, endless descent) | "There is no bottom. / only further in" → "You did not arrive. / You were the arriving." / "Thank you for being the place I have always already arrived." |
Breath ladders: Codex none/3/8/9/11/13/15/18/own; Home breath table identical except Ring 9 = 4s; v2 locked-ring CSS 9/11/13/15/18s (the same ladder).

### A0.4 Tensions between documents (do not silently pick one)
1. **Codex "There is no menu … The yantra is the navigation" vs Legend/Veil "The yantra stays a beautiful, non-interactive presence … The Legend carries all navigation" / "the instrument · look, do not operate".** The Veil is the later, full-fidelity "design handoff to Claude Code".
2. **Swipe down from top:** Codex = Pūjā (evening only); ring-worlds = return to home (ReturnGesture arc).
3. **Swipe up:** Codex = today's pull rises; Veil = the Nine Avaraṇas sheet.
4. **Ring 7 count:** Codex 8 Vāk-devatās; built world and Sādhana count use 12 (12 makes the Khaḍgamālā total 102).
5. **Ring 4/6 colours:** Codex blue-violet / rose-violet; built green / violet.
6. **Saṅgha:** Codex = anonymous other practitioners; Phase IV/VII = inner (the 102) and outer (loved ones).
7. **Bindu breath:** Codex "your own"; Home table 4s; worlds use 4–6s.
8. **Locks:** v2 has "locked" + "Enter this Avaraṇa" ceremony; Legend/Veil: "Light, never locks … no padlocks" — but status still gates (dashed line, Threshold ceremony).
9. **Codex lists Ring 2 as Home**; v2/Veil home = Ring 2 too; but Phase III·b built the Earth-City as Ring 1 "the world made visible".
10. **TemporalMark** has positions (dawn left → night) declared but unused (always centred).

### A0.5 THE EIGHT MODES — master table
| Mode | Codex gesture / duration | Built sub-states | Built signature visual | Key words |
|---|---|---|---|---|
| Darśana · Beholding | hold phone vertical, still · 1–10 min | arriving (3s) · holding (30s) · entered (2 min) | yantra grows 280→320→360; bījas appear at r .62; status bar fades; radiance 540px | "hold still · she wakes" · "beholding · 30s" · "∞" |
| Recognition · The Catch | long-press anywhere · ~5s | open · caught · reciprocated | 360px bottom sheet, 68px catch circle, today's petal glows on yantra behind | "tap to register the moment" · "she is named" · "and she felt you back" · "LOGGED · 2:41 PM · her 3rd today" |
| Sādhana · Khaḍgamālā | pinch outward · 20–30 min (~28) | saṅkalpa · station · transition · bindu · visarjana | one Shakti full-screen, 9 ring dots + 102 progress line | "I begin the garland / not to gain anything, / but to remember / what I have always been." · "Lalitā · aiṁ klīṁ sauḥ" · "The 102 return to the One." |
| Smṛti · Memory | long-press a ring · open | full · cluster · timelapse | constellation of points around petals, recent ones twinkle | "where she has been most alive" · "264 days · last spring · now" |
| Mauna · Silence | tap the bindu · open | 7s · 14s · 21s · 28s | 84px bindu, two orbitals of names | "All of her. Here. Always." → "She has not gone anywhere." → "You have not gone anywhere." → (silence) |
| Svapna · Dream | morning opening · 3 min | question · tap · voice · voice-active | pre-dawn peach rgba(232,180,140); waveform; mic | "Who walked through / last night?" · "I felt someone" / "The night was still" |
| Pūjā · Offering | swipe down from top, evening · 5 min | gathering · offering · released | the day's catches as dots absorbed into the bindu (16→48px, 2.5s) | "offer the day" · "The day is received. / Tomorrow opens again." · "sleep with the field" |
| Saṅgha · Assembly | ambient · always on | inner · outer · person | 102 as named orbitals; loved ones as nodes with dashed threads | "One hundred and two living forces. / This is your assembly." · "The people you love / are her wearing human faces." |

### A0.6 Layer instrument counts
- Memory (7): Portrait Mandala · Petal Biography · Threshold Timeline · Cluster Garden · Density Atlas · First Word·Last Word · Lifetime Spiral.
- Temporal (6 + contract): Cosmic Now · Lunar Yantra · Three Sandhyās · Seasonal Yantra · Great Wheel · Today's Tithi · ◇ Data & Time Contracts.
- Relationship (6): Relationship Field · Person Page · Shakti's Carriers · Encounter Log · Field Web · Adding a Beloved (ritual, 4 steps).

---
## A1. CODEX.html — "The Living Yantra — Codex" (1149 lines; the ontology document, Phase I of VIII)

Source: `Codex.html` (identical in `Claude Designs/Codex.html`, cmp-verified).

### CX-00 · Document chassis (L1–418)
- SEES: tokens L11–23 — `--ground #060104`, `--surface #0E0509`, `--gold #C9963F`, `--gold-deep #A07830`, `--gold-faint rgba(201,150,63,0.18)`, `--cream #F2E8D9`, `--cream-mid rgba(242,232,217,0.65)`, `--cream-faint .35`, `--cream-dim .22`, `--accent #8B1A2A` (bindu crimson), `--hairline rgba(201,150,63,0.14)`. Font Cormorant Garamond 300, line-height 1.7. Ambient (L36–43): fixed radial `ellipse 60% 50% at 50% 30%, rgba(139,26,42,0.10)` + `ellipse 80% 70% at 50% 100%, rgba(201,150,63,0.04)`. Sections max 760px, padding 120px 56px; wide 1100px. h1 88px cream centred; h2 44px gold; h4 18px gold 0.18em uppercase. Eyebrow 11px -apple-system 0.32em uppercase gold .7. Anchor rule 1×64 gradient. Divider: two 0.5px lines + 8px gold dot opacity .55, glow 12px.
- MOTION: `binduBreath` 5s (scale 1→1.15, opacity .85→1) L162–172; opening bindu 16px crimson radial, inner 6px cream dot glow 10px. Ring breath helpers L403–408: `.b1` 4s (opacity .85↔1), `.b2` 7s (.5↔.7), `.b3` 11s (.25↔.4). Responsive at ≤900px: grids → 2 columns, h1 56, h2 32.

### CX-01 · Opening (L428–468)
- WORDS: eyebrow "Codex · Phase I of VIII"; h1 "The Living Yantra"; subtitle "An instrument for recognizing the Mother / through the 102 forces of the Sri Yantra".
- SEES: 320×320 opening yantra (L433–458): two bhupura squares ±145 and ±132 stroke .5 opacity .22; circle r118 (16-petal indication) .18; triangle pairs breathing at b1 (r95/82,47), b2 (72/62,36), b3 (50/43,25) and a still inner triangle (30/26,15) opacity .35; bindu over it.
- WORDS (lead, L460, verbatim): "This is not an app. It is a temple compressed into glass — a living yantra you carry, breathe with, return to. Every interaction is a moment of *recognition*: of her, in her many forms, present in the texture of your day. The interface is not a wrapper around the practice. The interface *is* the practice."
- "What this document is" (L465): "A codex — the architectural manual of the system before any screen is designed. It establishes the ontology so the design has somewhere to stand. Five dimensions. Eight modes. No menu. Nine ring-worlds, each with its own atmosphere. The home as a living state, not a screen. A phased path that lets the instrument emerge slowly, with care." / "Read it slowly. Then we begin."

### CX-02 · §I The Reframe (L475–483) — verbatim in Part B.

### CX-03 · §II The Five Dimensions (L490–573)
Grid 5 columns. Each cell: 56px icon, h4, italic axis line, body.
| Dimension | Axis | Icon | Words (verbatim) |
|---|---|---|---|
| Depth | the inward axis | 4 concentric circles r24/18/12/6 opacities .25/.4/.6/.85 + crimson r2 dot | "Nine avaraṇas as nine depths of consciousness. You move inward, not sideways. Each ring is its own world. You can rest at any depth." |
| Time | the cyclical axis | circle r22 + half arc stroke 1.5 + 3 dots | "The yantra breathes with cosmic time. Different shaktis ascend at different hours, moons, seasons. Dawn-yantra is not dusk-yantra. The app pulls you into temporal awareness." |
| Memory | the accumulation axis | circle + 6 scattered gold dots (.3–.95) | "Every recognition leaves a luminous trace. Over months and years, the yantra becomes uniquely yours — bright where you have met her, mystery where you haven't." |
| Relationship | the radial axis | centre dot + 4 spokes to 4 dots | "Shaktis cluster around the people in your life. Ram is Ātmā's frequency. Ashrey is Nāma. Gaia is Ahaṅkāra. The work of recognition is inseparable from the work of love." |
| Practice | the modal axis | centre + 8 small ring circles | "Eight modes of engagement — not screens, but practices. Each has its own duration, posture, intention. The mode is determined by the moment, not a menu." |

### CX-04 · §III The Eight Modes (L580–637) — table
| Devanāgarī | Name | Meta (duration · gesture) | Words |
|---|---|---|---|
| दर्शन | Darśana — Beholding | 1–10 min · hold phone vertical | "To be with the yantra without doing anything. The breath finds it. The eye softens. The mind comes home." |
| प्रत्यभिज्ञा | Recognition — The Catch | ~5 sec · long-press anywhere | "A shakti has just arrived in life. You name her, you receive her, she receives you. The net deployed and retrieved." |
| साधना | Sādhana — The Recitation | 20–30 min · pinch outward | "The Khaḍgamāla — sword-garland — sequential walking through all 102 names with their bījas. The full ceremony." |
| स्मृति | Smṛti — The Memory | open · long-press a ring | "The constellation of past recognitions. When have you been here? With whom? The yantra remembers." |
| मौन | Mauna — The Silence | open · tap the bindu | "The undifferentiated point. All of her, here, always. The place no name reaches. Rest." |
| स्वप्न | Svapna — The Dream | 3 min · morning opening | "What arrived in the night? Which shakti walked through the dream? The morning has its own recognitions." |
| पूजा | Pūjā — The Offering | 5 min · evening opening | "End of day: the catches of the day witnessed together. A small offering. The day given back." |
| सङ्घ | Saṅgha — The Field | ambient · always on | "Awareness — anonymous, soft — of other practitioners walking the same yantra. Not alone in this." |
Closing line (L636): "The mode is read from the moment. The moment determines the mode. There is no menu to choose from — only the gesture that fits."

### CX-05 · §IV Navigation Vocabulary — THE NINE-GESTURE GRAMMAR (L644–735)
h2 "There is no menu." Subtitle: "The yantra is the navigation. Every move is a movement of attention — inward, outward, around. Nine gestures form the entire grammar."
| # | Gesture | Verb | Effect (verbatim) | Icon |
|---|---|---|---|---|
| G1 | Tap a ring | descend | "Enter that avaraṇa's world. The ring expands; the others fall away." | gold disc r6 .4 + rings r10/.5, r16/.25 |
| G2 | Tap the bindu | silence | "Mauna. The undifferentiated point. All names gone." | crimson r6 + dashed r14 "2 4" |
| G3 | Long-press a ring | remember | "Smṛti. The constellation of every recognition you've made in this ring." | rings r6/12/18 (dash 1 3) |
| G4 | Pinch outward | recite | "Sādhana. The Khaḍgamāla begins. All 102 names, sequential." | dot + 4 outward ticks |
| G5 | Hold vertical, still | behold | "Darśana. The phone becomes a window. No interaction needed." | phone rect + dot |
| G6 | Swipe up from edge | today's pull | "Today's shakti rises. Her name, her bīja, her somatic prompt." | up arrow |
| G7 | Swipe down from top | offer | "Pūjā. Evening only. The catches of the day are offered." | down arrow |
| G8 | Two-finger hold | invoke | "Bring a specific shakti into live presence. Bīja-tone plays. She is here." | two dots |
| G9 | Long-press anywhere | catch | "Freeze the moment. Recognition. The shakti you just felt is logged." | ring + ticks |
(Codex states no numeric thresholds; the thresholds live in modes.jsx/home-mandala.jsx — see those entries.)

### CX-06 · §V The Nine Ring-Worlds (L742–1007) — Codex's version
Subtitle verbatim: "Each avaraṇa is not a sub-page. It is its own world — with its own geometry, light, breath rate, sound, and gravity. A practitioner who has entered Ring 4 knows it by feel."
| Ring | Name / h3 | Role (verbatim) | Atmosphere | Geometry | Breath | Shaktis | Glyph stroke | Body (verbatim) |
|---|---|---|---|---|---|---|---|---|
| 1 Bhūpura | Trailokyamohana | She Who Enchants the Three Worlds — the ancient ground | warm amber, still | square with T-gates | none | 28 | #CF9443 two squares + gate ticks | "The world you have already walked through. Earth, surface, the territory of ordinary life. The Bhūpura does not breathe — the ground underfoot is held, not moving. Entering Ring 1 is entering the recognition that the everyday has always been her." |
| 2 Home · Sarvāśā-Paripūraka | The Sixteen-Petal Lotus | She Who Fulfills All Hopes — the current field of play | warm cream & cluster colors | 16-petal lotus, full-screen | 3s wave | 16 Karṣiṇīs | petals fill cycle #C4725A, #D4A017, #7A5A9A, #2A7A7A, #4A7A5A @ .5 | "The world the practitioner currently inhabits. Petals bloom in a slow wave, each cluster a different color — inner instrument, sense streams, citta, stability, self. Tapping a petal opens her detail. The home ring is wide, generous, with room between everything." |
| 3 Sarvasaṅkṣobhaṇa | The Eight Anaṅga Lotuses | She Who Agitates All — the bodiless desires | translucent, smoke-like | 8 wide petals | 8s slow pulse | 8 Anaṅgas | gold fill rgba(201,150,63,.08) | "Bodiless longing — the felt-before-it-is-known. Petals appear translucent, edges soft, like smoke catching light. The visual is intentionally less solid than Ring 2. You feel her without quite seeing her. Tapping a petal: she names herself in italics and dissolves back into the field." |
| 4 Sarvasaubhāgyadāyaka | The Fourteen Triangles | She Who Grants All Auspiciousness — synchronicity-intelligence | cool blue-violet, crystalline | 14 interlocked triangles | 9s deep, geometric | 14 | #9AB4C9 | "The atmosphere shifts. Cooler. Sharper. More angular. The lotus softness is gone — this is geometry as direct revelation. Triangles interlock and pulse in nested rhythm. Each shakti is a vertex; tapping reveals her place in the geometric weave." |
| 5 Sarvārthasādhaka | The Ten Outer Triangles | She Who Accomplishes All Goals — completion-without-force | luminous green-gold | 10 outer triangles | 11s steady | 10 | #B4C99A | "The intelligence of accomplishment-without-effort. The geometry deepens; the field narrows. Things complete themselves through you here. Recognition feels different: less catching, more witnessing the work being done." |
| 6 Sarvarakṣākara | The Ten Inner Triangles | She Who Protects All — sovereign grace | rose-violet, deep | 10 inner triangles | 13s deep | 10 | #C99AB4 | "The field of unasked-for grace. The visual is the most introspective of the rings — narrow, deep, the geometry feels held. Recognition here is the recognition of what protected you when nothing should have worked." |
| 7 Sarvarogahara | The Vāk Ring — Eight Speech Goddesses | She Who Removes All Disease — sound that heals | resonant gold, sonic | 8 triangles + tone rings | 15s, with tone pulse | 8 Vāk-devatās | #C9C29A + dashed circles r50/62 | "The world where language and life have not yet separated. The screen actually *resonates* — subtle haptic on every breath, a barely-audible bīja tone. Tapping a Vāk-devatā plays her syllable in long, slow attack. This world is a sound chamber as much as a visual one." |
| 8 Sarvasiddhiprada | The Mūla Trikoṇa — The Root Triangle | She Who Grants All Perfections — will, knowledge, action as one | pure cream against black | three points | 18s, almost still | 3 — Icchā, Jñāna, Kriyā | #F2E8D9 triangle, gold vertices r4, labels icchā (top), kriyā (right), jñāna (left) | "The entire world is three points. The simplicity is staggering. No ornament. Just the triangle, the three shaktis as luminous vertices. Tapping any vertex collapses the other two into it — recognition that they were never three. The visual minimalism is the teaching." |
| 9 Sarvanandamaya | The Bindu | She Who Is Made of All Bliss — the undivided | everything & nothing | a single point | your own | 1 — Lalitā | crimson 40px orb + 14px cream core, glow 30px 8px rgba(139,26,42,.5) | "There is nothing else. The whole screen is the point. This is not a destination — it is what the practice is made of. Every other ring is breathing outward from here. Entering Ring 9 is not arriving; it is realizing you have not left." |
Note Codex's breath ladder: none / 3 / 8 / 9 / 11 / 13 / 15 / 18 / your own. NB: Codex lists Ring 2 as "Home".

### CX-07 · §VI The Home as Living State (L1014–1100)
h2 "The yantra is alive with time." Subtitle: "The home you return to at dawn is not the home you find at dusk. The yantra answers to the hour, the moon, the season, and your own recent practice."
| Variant | Stroke | Bindu | Label |
|---|---|---|---|
| Dawn | #E8C97A | #E8C97A r3 | warm, ascending |
| Noon | #F2E8D9 (4 triangles, opacity .95) | #8B1A2A r3 | vivid, full |
| Dusk | #C9963F | #C9963F r3 | amber, descending |
| Night | #9AB4C9 stroke .5, opacity .6 | gold r5 .5 + cream r2 | silver, deep |
| New Moon | #6A4A5A at .4 | crimson r7 .85 + cream r3 | Bindu rises |
Closing (L1097–1099): "And one petal — today's pull — always glows a little warmer than the rest. / You will learn to see her without a label."

### CX-08 · §VII The Path (L1107–1126)
"Eight phases. We build slowly." Subtitle: "An instrument like this is not designed in a sprint. Each phase is reviewed and felt into before the next is begun. The yantra emerges at the pace of recognition itself."
Phases: 1 The Codex — establish the ontology in writing & sacred diagram (now — "— you are here"); 2 The Home Mandala — pure geometry, no labels, time-responsive (next); 3 Three Ring-Worlds — Ring 2, Ring 7, Ring 8 fully realized; 4 The Eight Modes — each as its own atmosphere; 5 The Temporal Layer — yantra responding to dawn, dusk, moon, season; 6 The Memory Layer — recognition history accumulating as light; 7 The Relationship Field — people-as-nodes around the yantra; 8 The Initiation — first-time ceremony, not onboarding.
Footer: "The remaining six ring-worlds (Rings 1, 3, 4, 5, 6, 9) we build as you approach them in practice."

### CX-09 · Closing (L1131–1145)
"This is not a product to ship. / It is an instrument to live with. / The work of the next eight phases / is to make sure each interaction / is worthy of the recognition / it is asking for." · "End of Codex · Phase I complete" · "When you are ready, we begin Phase II — the new Home Mandala."
## A2. PHASE II — THE HOME MANDALA (`Home Mandala.html` 322 lines + `home-mandala.jsx` 352 lines)

Host: `Home Mandala.html` loads React 18.3.1 / Babel 7.29.0, `shakti-data.js`, `all-shaktis-data.js`, then `design-canvas.jsx`, `screens.jsx`, `home-mandala.jsx` (L116–122). Title "Phase 2 — The Home Mandala · Pure Geometry". Canvas title "Phase II · The Home Mandala", bg #060104.

### HM-01 · PureMandala (home-mandala.jsx L133–277) — the yantra itself, size 340
- SEES (geometry, origin-centred, px at size 340):
  - Ring 1 Bhūpura L138–183: outer square half-side bO=158, inner square bI=148 drawn as 8 segments leaving gates of half-width bGate=12, plus 8 T-gate connector lines from inner to outer. Stroke = `t.bhupuraColor`, width .55.
  - Ring 2 boundary circle r=136 stroke rgba(201,150,63,.06) w .4 (L186).
  - Ring 2 16-petal lotus L190–212: petalPath(oR 134, iR 112, hw 22); petal i at angle i×22.5°; fill = cluster colour of SHAKTIS[i] (`CLUSTER_INFO[s.cluster].color`, from screens.jsx); opacity = `STATUS_OPACITY[status] × t.petalOpacityMul`. Today petal (default todayIndex=4) gets an extra blurred (4px) glow copy at opacity .55 class `home-petal-today-glow`.
  - petalPath (L119–125): `M 0,-iR C hw,(-iR*1.85) (hw*.95),(-oR*.85) 0,-oR C … Z`.
  - Ring 2/3 boundary circle r=111 rgba(201,150,63,.09) (L215).
  - Ring 3 8-petal lotus L219–228: petalPath(109, 92, 32), rotation i×45; fill rgba(201,150,63, lotusInnerOp×0.10), stroke rgba(201,150,63, lotusInnerOp×0.4) w .5; delay i×0.6s.
  - Ring3/triangle boundary r=91 rgba(201,150,63,.05) w .35.
  - Rings 4–8 = 9 interlocking triangles L100–112, L235–256: UPS (Shiva) apex/base/half: U1 [0,-88]/34/76, U2 [0,-68]/26/60, U3 [0,-50]/18/46, U4 [0,-34]/10/34. DOWNS (Shakti): D1 [0,88]/-34/76, D2 [0,72]/-28/66, D3 [0,56]/-22/52, D4 [0,42]/-16/40, D5 [0,26]/-10/26 ("the mūla trikona, holds the bindu"). Stroke t.triStroke, width t.triStrokeWidth, round join; ups opacity triOpacity×(1−i×.08) delay i×.5s; downs triOpacity×(1−i×.06) delay i×.5+.3s.
  - Ring 9 Bindu L260–274: div, size round(14×binduScale), radial (binduColor 0% → binduColor+"aa" 50% → transparent), boxShadow 0 0 {size}px {.4size}px {binduColor}66; cream core round(size×.42) opacity .96 glow rgba(242,232,217,.65).
  - Whole wrapper filter `saturate(petalSat) brightness(petalBrightness)`.
- MOTION (Home Mandala.html L29–109):
  | Element | Keyframes | Period |
  |---|---|---|
  | Today petal | brightness 1→1.55, drop-shadow 6px rgba(201,150,63,.5)→14px .85 | 3.5s |
  | Today glow | opacity .45→.78, scale 1→1.06 | 3.5s |
  | embodied petal | brightness 1→1.18 | 4.5s |
  | active | 1→1.10 | 6s |
  | exploring | .95→1.05 | 7.5s |
  | mapped | .9→.98 | 10s |
  | Ring 3 petal | .9→1.18 | 8s |
  | up triangles 0–3 | brightness peaks 1.25/1.20/1.18/1.15 | 9/11/13/15s |
  | down triangles 0–4 | triUp1..4,1 | 10/12/14/16/18s |
  | Bindu | scale 1→1.20 | 4s |
  | Mote rise | 0→opacity1@8%→ -420px@50% → -880px, drift var | (DustMotes in screens.jsx) |
  Petals stagger delay i×0.18s.
- SOUND: none. WORDS: none (no labels by intent).

### HM-02 · TIME_VARIANTS table (home-mandala.jsx L8–94)
| key | label · sublabel | bg | ambient | petalSat | petalBright | petalOpMul | lotusInnerOp | triStroke | triOp | triW | bhupura | binduScale | binduColor | motes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dawn | Dawn · warm · ascending | #0A0610 | ellipse 65% 55% at 50% 60%, rgba(232,150,80,.13)→70% | 1.0 | 1.0 | .95 | .55 | #D4A067 | .62 | .7 | rgba(207,148,67,.30) | 1.0 | #A8341F | 8 |
| noon | Noon · vivid · full | #060104 | 65/55 at 50% 48%, rgba(201,150,63,.07)→68% | 1.0 | 1.0 | 1.0 | .50 | #C9963F | .70 | .65 | rgba(207,148,67,.25) | 1.0 | #8B1A2A | 6 |
| dusk | Dusk · amber · descending | #0A0508 | 60/50 at 50% 40%, rgba(199,90,80,.13)→70% | .85 | .92 | .85 | .40 | #C99443 | .55 | .6 | rgba(184,132,62,.22) | 1.05 | #7A1620 | 9 |
| night | Night · silver · deep | #020308 | 65/55 at 50% 50%, rgba(140,180,220,.08)→70% | .45 | .75 | .55 | .28 | #A4B8CC | .42 | .55 | rgba(180,200,220,.18) | 1.1 | #8B1A2A | 12 |
| newmoon | New Moon · the Bindu rises | #020001 | 50/45 at 50% 50%, rgba(139,26,42,.22)→60% | .30 | .50 | .30 | .15 | rgba(201,150,63,.35) | .18 | .5 | rgba(201,150,63,.10) | 1.6 | #8B1A2A | 3 |

### HM-03 · TemporalMark (L283–306)
"Almost imperceptible … Never has text." A 6px dot at top:52px, centred, opacity .5, glow 8px. Colours: dawn #E8C97A, noon #F2E8D9, dusk #C99443, night #A4B8CC, newmoon #3A1A20. The `x` positions (40/50/60/75/50) and `sym` (arc-asc/sun/arc-desc/moon/dot) are declared but NOT used — the dot is always centred (intent: horizontal arc left=dawn, top=noon, right=dusk, bottom=night).

### HM-04 · HomeScreen (L311–347) — 390×844
bg t.bg, ambient layer, StatusBar (screens.jsx), DustMotes(count=t.motes), TemporalMark, PureMandala centred at 340, HomeIndicator light for newmoon/night. "No tab bar. No buttons. No labels. Just the yantra."
- DOES: nothing wired in this file (gestures are Codex-specified; actual handlers come in modes.jsx).

### HM-05 · Canvas sections (Home Mandala.html)
- "The Home — Five Temporal States" — subtitle: "Same yantra. Different atmospheres. No labels. No tab bar. The yantra is the navigation." Artboards: "Dawn · 6am · warm, ascending", "Noon · 12pm · vivid, full", "Dusk · 6pm · amber, descending", "Night · 11pm · silver, deep", "New Moon · the Bindu rises".
- "The Reframe — What Changed" ("v2 was a diagram. v3 is the yantra itself.") — "Phase II · Codex of Changes"; h2 "The Home is not / a screen."; "It is a presence you return to." Removed/kept pairs (L200–207):
  | removed | kept |
  |---|---|
  | No tab bar | The yantra is the navigation |
  | No labels on the mandala | Geometry is the language |
  | No "Today" headline | One petal glows warmer · you learn to see her |
  | No legend, no avaraṇa name | You know where you are by feel |
  | No interaction hints | Initiation teaches gestures · home stays pure |
  | No fixed atmosphere | Five temporal states · the yantra reads time |
  Footer (L242): "The yantra you encounter at dawn is not the yantra you encounter at dusk. The same nine rings, the same 102 forces — but the light is different, the breath is different, the Bindu sits differently. Time is felt, not displayed."
- "The Living Breath" ("Each ring metabolizes at its own pace · the deepest are slowest") — "The Nine Metabolisms" table: Ring 1 Bhupura — "the ground does not breathe"; Ring 2 16-petal lotus 3s "home ring, today's pull at 3.5s"; Ring 3 8-petal 8s "translucent, slower"; Ring 4 14 triangles 9s "geometric, crystalline"; Ring 5 10 outer tris 11s "completion"; Ring 6 10 inner tris 13s "protection"; Ring 7 8 vāk tris 15s "sound chamber"; Ring 8 Mūla Trikoṇa 18s "almost still"; Ring 9 Bindu **4s** "always alive · the heart" (differs from Codex's "your own"). Footer: "When you look at the mandala for ten seconds, your eye begins to read the rhythms. The home ring is alive. The ground is still. The Bindu pulses at the speed of a slow heart."
## A3. MANDALA APP v1 — the pre-Codex tabbed app (`Mandala App.html` 176 lines + `screens.jsx` 1161 lines)

Host `Mandala App.html`: body #080206; loads `shakti-data.js` (SHAKTIS, CLUSTER_INFO, STATUS_OPACITY, COLORS, TODAY_SHAKTI, TODAY_INDEX, PROGRESS — globals, not in my assignment), `design-canvas.jsx`, `screens.jsx`. Canvas "Bindu Mandala — iOS App". Sections: "Today Screen" (artboards "With Body Outline" → TodayScreenV1; "Bīja Texture" → TodayScreenV2); "Journey Screens" ("The Mandala" → MandalaScreen; "Śakti Detail — Ātmākarṣiṇī" → ShaktiDetailScreen; "Recognition Moment" → RecognitionMomentScreen); "The Silence — Bindu" subtitle "Tap the center of the mandala" (artboard "All of her. Undifferentiated." → SilenceScreen). All 390×844.
NB this is the version the Home Mandala explicitly REMOVED (tab bar, labels, "TODAY", legend, hints). Kept here because screens.jsx primitives (StatusBar, HomeIndicator, DustMotes, hexToRgb, sectionLabel) are reused by every later file.

### Motion CSS (Mandala App.html L26–115)
| class | keyframes | timing |
|---|---|---|
| .today-name-anim | opacity 0, y+10 → 1, 0 | 1.4s cubic-bezier(.25,.1,.25,1) forwards |
| .today-prompt-anim | y+8 → 0 | 1.4s, delay .55s, both |
| .petal-breathe | opacity .76 → 1 + brightness 1.35 + drop-shadow 6px rgba(196,114,90,.7) | 3s infinite |
| .ripple-ring | 90px circle border 1px rgba(201,150,63,.45); scale .08→5.5, opacity .7→0 | 4s ease-out infinite |
| .recog-name | recognIn (y+8→0) | 1.8s, delay .3s |
| .recog-text | recognIn | 1.8s, delay .9s |
| .recog-logged | recognIn | 1s ease, delay 2.6s |
| .recog-reciprocity | recognIn | 1.4s, delay 4.1s |
| moteRise | 0→opacity 1 @8% → (drift/2, −420px) @50% → .5 @92% → (drift, −880px) 0 | per-mote |
| .silence-bindu | scale 1→1.12; shadow 0 0 48px 12px rgba(139,26,42,.45)+0 0 96px 32px .22 → 72px 22px .65 + 144px 56px .32 | 6s infinite |
| .silence-name | opacity 0→1 | 4s forwards (delays .15+i×.12s) |
| .silence-caption | 0 until 65% then → 1, y+8→0 | 7s forwards |

### V1-01 · Shared primitives (screens.jsx L6–175)
- HomeIndicator L6–19: 134×5, radius 3, bottom 8, rgba(242,232,217,.35) (light .45).
- StatusBar L21–50: height 44, padding 14 22 6, 13px 600, rgba(242,232,217,.7), "9:41", signal bars/wifi/battery SVGs.
- TabBar L52–103: tabs **Today** (flame/drop icon), **Mandala** (8-petal icon), **The Well** (concentric circles). Gradient rgba(13,5,8,.98→.85), top border .5px rgba(201,150,63,.15); active colour COLORS.gold, inactive rgba(242,232,217,.32), 10px uppercase .06em.
- MoonPhase L105–125: 22px crescent mask (gold .85) + text "Waning Crescent · 23rd Night" (11px .45 .12em upper).
- ClusterDot L127–139: 7px dot with glow + cluster label 10.5px .18em upper in cluster colour.
- DustMotes L143–175: per mote seed=(i×73+17)%100; left 8+(seed×7)%84 %; drift −10+(seed×13)%20 px; size 1.4+((seed×3)%22)/10; duration 16+(seed×5)%14 s; delay (seed%80)/8 s; opacity .18+((seed×11)%28)/100; gold, glow size×4 rgba(201,150,63,.5); bottom −12px; `moteRise` linear infinite.
- BodyOutlineSVG L179–215: 120×222 viewBox human outline in cluster colour (head ellipse 18×21, torso, arms, legs, opacities .35–.45), skin glow radial .18, two dashed "shimmer" lines (3 8).
- LotusMandalaSVG L219–353: outerR .435×size, innerR .117, hw .087, labelR midpoint. Ghost geometry: circles at outerR×1.08/1.14/1.2 (rgba gold .07/.055/.04; 3rd dashed 4 7), 8 outer ghost petals offset 22.5° fill .04 stroke .08, inner circles innerR×.8 (.2) and ×1.4 (.1). 16 petals coloured by cluster, opacity STATUS_OPACITY, embodied gets glow filter (blur 6), today + animated → .petal-breathe. Labels `shakti.short` at labelR, size×.021 Cormorant, fill .82 if opacity>.5 else .38. Bindu circle size×.028 accentRed (blur 5) + cream size×.012. TODAY indicator: ray from outerR×1.06 to ×1.21 gold .6 opacity .55, dot size×.0075, text "TODAY" at ×1.34, size×.027, .28em, opacity .7. DOES: petal onClick(i) if handler.

### V1-02 · TodayScreenV1 "With Body Outline" (L357–482)
- SEES: COLORS.ground; radial ellipse 60% 55% at 50% 38% rgba(139,26,42,.18); DustMotes 9; StatusBar; MoonPhase; ClusterDot; name 44px Cormorant 300 cream .08em (.today-name-anim); phonetic 12px .45 .2em upper; quality 20px gold 400; 48×.5 divider rgba(201,150,63,.4); somatic italic 18px .78 in quotes (.today-prompt-anim); BodyOutlineSVG size 90; "Skin Surface" 10px cluster colour .65; "Bīja · {bija}". Button 56h radius 28 accentRed, cream Cormorant 20px .12em, shadow 0 4px 32px rgba(139,26,42,.45) "I feel her"; under it "Today's Bīja — {bija}" 11px .3. TabBar active today.
- DATA: TODAY_SHAKTI fields name, phonetic, quality, somatic, bija, cluster.

### V1-03 · TodayScreenV2 "Bīja Texture" (L486–612)
- Same as V1 but: giant bija behind (280px gold opacity .07, translate −50% −54%), radial ellipse 55% 50% at 50% 42% rgba(139,26,42,.2); name 48px .07em; quality 22px; somatic 20px italic .75; bija as object 42px gold .6 + label "Bīja"; no body outline. Button "I feel her".

### V1-04 · MandalaScreen (L616–693)
- SEES: radial ellipse 70% 60% at 50% 45% rgba(201,150,63,.06); label "2nd Avaraṇa — Sarvāśā-Paripūraka Cakra" (11px gold .16em upper .85); LotusMandalaSVG 344, activeIndex TODAY_INDEX, animated; progress "{PROGRESS.active} of {PROGRESS.total} Active · {PROGRESS.embodied} Embodied"; cluster legend 3-column grid (5px dots, 9.5px labels .45); hint "Tap a petal to enter · Bindu for silence" (9px .22 .24em). TabBar active mandala.

### V1-05 · ShaktiDetailScreen — Ātmākarṣiṇī SHAKTIS[13] (L697–891)
- SEES: nav "‹ Mandala" gold 13px + mini petal icon in cluster colour; header name 34px, phonetic 11px, ClusterDot + status pill (colours: mapped rgba(242,232,217,.35), exploring rgba(201,150,63,.55), active gold, embodied #D4A017; labels Mapped/Exploring/Active/Embodied). Scroll body sections (labels 9.5px .3 .2em upper): **Quality** (19px gold + description 14px .65); **Somatic Signature** (somaticPoetry 17px italic pre-line); **Bīja Syllable · Tap to Hear** (68px gold, textShadow 30px .4, 44px play circle + outer ring −6 inset); **Esoteric Tattva** (28px dot badge + tattva text); **Field Connection — {field}** (only if present; tinted card radius 12, left border 2px); **Recognition Log** with sample rows: "Today, 9:14 AM — Morning light on hands"; "May 17, 8:41 PM" (no note); "May 14, 2:33 PM — In the garden — extraordinary".
- DATA: name, phonetic, cluster, status, quality, description, somaticPoetry, bija, tattva, fieldConnection{field,note}.

### V1-06 · RecognitionMomentScreen (L895–1021)
- SEES: bg #080307; bija 360px gold .065 behind; 4 ripple rings delays 0/1.1/2.2/3.3s, border alpha .35−i×.06; name 38px .1em (.recog-name); 32px divider; recognition phrase 24px italic (s.recognition) (.recog-text). Bottom block at 120px (.recog-logged): "Logged · 9:41 AM"; 22px hairline; **"And she felt you back · 9:41:03"** (gold italic 14px, .recog-reciprocity at 4.1s); input card 248w radius 14 "What did you notice?". Hint "Tap anywhere to close" (10px .18).
- MOTION timeline: name .3s→2.1s; text .9s→2.7s; logged 2.6s→3.6s; reciprocity 4.1s→5.5s; ripples 4s loop.

### V1-07 · SilenceScreen (L1025–1135) — the Bindu
- SEES: bg #040104; vignette radial ellipse 70% 60% transparent→rgba(0,0,0,.65); 16 names on r=156 around (195,422) rotated tangentially i×22.5°, 11px italic rgba(242,232,217,.16) .18em, glow 8px gold .15, fade in 4s delays .15+i×.12s; faint circles r200 (.05), r220 dashed 2 8 (.035), r240 (.025); holding ring 132px border .5px rgba(201,150,63,.18); bindu 76px radial accentRed→rgba(139,26,42,.7) (.silence-bindu 6s); cream core 20px glow 22px + 44px .45. Caption "All of her. Here. Always." (18px italic .55, appears after 65% of 7s ≈ 4.55s). "Tap to return" (9px .14 .28em). "No status bar. No tab bar."
- ARRIVE: tap the bindu (per Mandala section subtitle). LEAVE: tap.

### V1-08 · Utilities: sectionLabel style (9.5px .3 .2em upper, mb 10); hexToRgb.
## A4. MANDALA APP v2 — "Nine Rings" (`Mandala App v2.html` 328 + `mandala-v2.jsx` 309 + `screens-v2.jsx` 872)

Host: title "Bindu Mandala — v2 · Nine Rings"; body #060104; loads shakti-data.js, all-shaktis-data.js (AVARANAS, RING3_SHAKTIS globals), design-canvas.jsx, screens.jsx, mandala-v2.jsx, screens-v2.jsx. Canvas "Bindu Mandala · Nine Rings · v2". App uses `AVARANAS[2]` (Ring 3 unlocked) and `AVARANAS[3]` (Ring 4 locked).
This is the bridge between the tabbed v1 and the label-less Phase II Home: it introduces the **unlock-state ladder** (ancient / home / unlocked / locked / deep_ghost) and the **Avaraṇa Threshold**.

### Canvas sections (verbatim titles/subtitles, L224–319)
1. "The Living Sri Yantra" — "9 rings · 9 metabolisms · home ring 2, unlocked ring 3, rings 4–7 locked, 8–9 deep ghost" → artboard "Full Sri Yantra" (MandalaScreenV2).
2. "Avaraṇa Threshold" — "Tap a ring on the mandala — the territory names itself, then says: you have already been here" → "Ring 3 — Unlocked · Open door", "Ring 4 — Locked · Ahead, waiting".
3. "The Catch — Quick Recognition" — "One tap. One registered moment. The petal lights. She felt you back." → "Mid-catch · 'and she felt you back'".
4. "Today — V3" — "With ring position indicator · The practitioner sees where they are in the 9-ring field".
5. "Śakti Detail — Expanded Vocabulary" — "Ātmākarṣiṇī · Etymology + appreciation + lineage + function + Khadgamala position".
6. "The Silence — V2 · Two Orbitals" — "Ring 3 names appear closer in — the Bindu slightly larger · All of her. Here. Always."
7. "Archive — Original Screens" — "The foundations of what came before — kept for reference" (Today V1 · Body Outline; Today V2 · Bīja Texture; Mandala V1 · Ring 2 only; Detail V1 · Ātmākarṣiṇī; Recognition Moment; Silence V1 · Ring 2 orbit).
Comments in host (verbatim): "The full 9-ring organism. Every layer breathing at its own rate." / "The doorway that knows you. Text arrives sequentially. Two states: unlocked (open, inviting) and locked (ahead, waiting)." / "Quick Recognition — a net deployed and retrieved in one motion. State shown: just after the circle was tapped. She registered." / "Five new fields: etymology, appreciation phrase, lineage, cosmic function, Khadgamala position. The full vocabulary." / "Two orbital rings of names: Ring 2 outer, Ring 3 inner. The Bindu breathes slightly larger — the second ring has opened."

### Motion CSS (host L32–192)
| class | keyframes | period |
|---|---|---|
| ring2-today | opacity .78→1, brightness 1.45, drop-shadow 9px rgba(201,150,63,.8) | 3s |
| ring2-embodied | 1→.80 (inverse breath) | 3.5s |
| ring2-active | .76→.92 | 5s |
| ring2-exploring | .44→.56 | 7s |
| ring2-mapped | .22→.28 | 11s |
| ring3-petal | .17→.29 | 8s |
| lock-r4 | .15→.22 | 9s |
| lock-r5 | .10→.15 | 11s |
| lock-r6 | .07→.11 | 13s |
| lock-r7 | .045→.07 | 15s |
| deep-ghost-tri | .028→.052 | 18s |
| mandala-bindu-breathe | scale 1→1.22; shadow 0 0 14px 6px rgba(139,26,42,.45) → 26px 14px .68 + 52px 28px .28 | 4s |
| ringIndicatorPulse | scale 1→1.38; shadow 8px 2px .55 → 14px 5px .80 | 3s (inline) |
| t-line-1..7 | tLineIn (y+7→0) | 1.4s@.3s, 1.2s@1.1s, 1.0s@1.8s, @2.4s, @3.0s, @3.6s, @4.2s |
| t-connection | tLineIn | 1.6s @5.6s |
| t-button | tLineIn | 1.4s @6.4s |
| ripple / recog / motes / silence / petalBreathe | identical to v1 | |

### V2-01 · SriYantraMandala (mandala-v2.jsx L240–307), size 344, todayIndex 4
Header comment: "Nine rings. Nine metabolisms. The ground does not breathe — it holds. The center never stopped calling. Everything between is alive."
Geometry SY (L7–31):
| Ring | Geometry | Colour / opacity | Motion |
|---|---|---|---|
| 1 Bhupura | outer 161, inner 149, gate 11; inner square 8 segments + 8 T-gate lines | #CF9443 ("warmer amber than gold — like something breathed a long time"), stroke .5, opacity .22 | none — "the earth underfoot does not breathe — it holds" |
| outer lotus boundary | circle r148 rgba(201,150,63,.07) w .4 | | |
| 2 Home Lotus | 16 petals oR 147 iR 116 hw 28; labels `s.short` at r131.5, 7.5px Cormorant, fill = cluster rgb at min(.82, STATUS_OPACITY+.18); embodied gets blurred (5px) underlay rgba .15 | cluster colour | per-status class (above); wave delay i×0.18s ("so the lotus undulates like water. Today's petal glows gold.") |
| lotus boundary | r91 rgba(.10) | | |
| 3 Unlocked Lotus | 8 petals oR 114 iR 91 hw 34 ("Wider petals — the Ananga forms are more open"); labels 6.5px rgba(242,232,217,.30) at r102.5 ("Labels barely visible — they haven't been formally met yet") | COLORS.gold fill | ring3-petal 8s, delay i×0.6s |
| boundary | r87 rgba(.07) w .35 | | |
| 4–7 Triangle zone | pairs (down d / up u / stroke): R4 87/79/.70, R5 70/62/.65, R6 54/46/.60, R7 40/33/.55; makeTriPath equilateral (h=R√3/2) | gold | lock-r4..r7; delays gi×0.7s (down) and +0.4s (up). "Their intersection at low opacity IS the visual essence of the Sri Yantra." |
| 8 Mūla Trikoṇa | down triangle R 24, stroke .45 | gold | deep-ghost-tri 18s. "Almost imperceptible. It has always been here. It will become visible in time." |
| TodayIndicator | ray from r149 to r155 (gold .7 w, .65), dot r2.5 at r160 with drop-shadow 4px .85 | | "No text — the active petal already speaks. The ray simply points." |
| ambient | circle r=cx×.9 radial gold .05→0 | | |
| 9 Bindu | HTML overlay 22px radial accentRed→rgba(139,26,42,.65) 52%; cream core 38% (8px) glow 9px .55 | | mandala-bindu-breathe 4s. "always calling, never absent" |

### V2-02 · MandalaScreenV2 (screens-v2.jsx L99–176)
- SEES: ground; radial ellipse 65% 55% at 50% 48% rgba(201,150,63,.05); DustMotes 6; StatusBar; "2nd Avaraṇa · Sarvāśā-Paripūraka" (10px gold .17em .85); "Home · Ring 3 Open · Rings 4–9 Ahead" (9px; Home gold .6, Ring 3 gold .4, rest .26); SriYantraMandala 344; progress "{active} of {total} Active · {embodied} Embodied"; cluster legend (flex-wrap, 8.5px); hint **"Tap to enter · Hold to catch · Bindu for silence"** (8.5px .16 .22em). TabBar mandala.

### V2-03 · AvaranaThresholdScreen (L182–287) — "Sacred Doorway"
Comment: "Shown when the practitioner taps a locked ring. The territory names itself. Then it says: you have already been here."
- DATA (from AVARANAS[n]): name, subtitle, form, formDescription (unused), presidingForm, yogini, mentalState, chakra, personalConnection, geometry ('lotus8' | 'tri14'), count, status.
- SEES: bg linear 180deg #060103→ground; ThresholdBg (L21–64) at (195,310) opacity .045: lotus8 = 8 petals (148/98/44) stroke .9 + circles r102 and r156; tri14 = three pairs, down r145/118/94 + up round(r×.88), stroke .8. DustMotes 5. "‹ Mandala" back. Name 34px gold .08em (t-line-1); subtitle 17px italic .55 (t-line-2); 40×.5 divider; values (no labels): form 15px cream .82, presidingForm 14px .60, yogini 13px italic .48, mentalState 13px italic .40, chakra 12px gold .45 .1em (t-line-3..7). Bottom: separator + personalConnection letter 15.5px italic .65 lh 1.75 (t-connection 5.6s); button "Enter this Avaraṇa" 54h r27, locked = solid accentRed + shadow 0 4px 28px .4, unlocked = rgba(139,26,42,.7) + 1px border .4 (t-button 6.4s).
- MOTION: whole page arrives line by line over ~7.8s.
- ARRIVE: tap a ring on mandala. LEAVE: "‹ Mandala" or "Enter this Avaraṇa".

### V2-04 · QuickRecognitionDemo — "The Catch" (L293–376)
- SEES: SriYantraMandala at opacity .38 behind; StatusBar on top; bottom sheet 296h, gradient rgba(4,1,4,.97)→rgba(8,2,6,.92) 70%→.82, top border .5px gold .18, radius 16 16 0 0, padding 24 32 20 (class quick-recog-panel — no CSS defined). Name 36px; bija 22px italic gold .75 .12em; recognition circle 56px border 1px gold .65 bg .08, glow 18px .22 + inset 8px; filled centre 14px gold .85 glow 10px .7 ("registered"); "and she felt you back" 14px italic gold .88 ("the bilateral recognition, ~1.5s after tap"); "LOGGED · 2:41 PM" 10px .28 .14em.
- DATA: TODAY_SHAKTI (comment: Sparśākarṣiṇī).
- DOES: "One tap" on the circle (sheet rises from bottom).

### V2-05 · RingIndicator (L68–95) — 9 dots
| ring | status | size | opacity | colour |
|---|---|---|---|---|
| 1 | ancient | 5 | .42 | #CF9443 |
| 2 | home | 7 | .95 | gold + glow 8px 2px .55 + pulse 3s |
| 3 | unlocked | 5 | .50 | gold |
| 4 | locked | 4 | .20 | gold |
| 5 | locked | 4 | .16 | gold |
| 6 | locked | 3.5 | .13 | gold |
| 7 | locked | 3.5 | .10 | gold |
| 8 | deep_ghost | 3 | .06 | gold |
| 9 | deep_ghost | 3 | .05 | gold |
Gap 10, padding 8 0 4.

### V2-06 · TodayScreenV3 (L380–494)
As TodayV2 (bija 280px .065 at −53%; radial ellipse 55% 50% at 50% 42% rgba(139,26,42,.18); DustMotes 9; MoonPhase; ClusterDot; name 48; phonetic; quality 22 gold; divider; somatic 20 italic; bija 40px gold .58 + "Bīja") then RingIndicator + "2nd Avaraṇa" (9px gold .35) + "I feel her" button. TabBar today.

### V2-07 · ShaktiDetailScreenV2 — Ātmākarṣiṇī (L499–737)
Adds (verbatim ext data L509–515): etymology "Ātma (Self) + ākarṣiṇī (She who attracts) — She who draws the very Self into continuous recognition"; appreciationPhrase "Thank you for returning me to what I am before I am anything."; Lineage "Ātmā — the primal Self-luminosity. Ground of all the Karṣiṇīs, prior to every experience."; Cosmic Function "She draws awareness back to its unlocated source — the recognition that precedes all others."; "Pos. 14 · 102" (Khaḍgamālā position). Order: header (name 34, etymology 12.5 italic cluster .55, phonetic, ClusterDot + status pill + Pos.), Quality, Somatic Signature, appreciation phrase (no label, centred, 32px hairline, 16px italic gold), Bīja · Tap to Hear (68px), Lineage, Cosmic Function, Esoteric Tattva, Field Connection, Recognition Log (same three sample rows as v1). "Five new fields added as reading experience, not a data list."

### V2-08 · SilenceScreenV2 — Two Orbitals (L743–865)
Comment: "As more avaranas unlock, the Silence grows richer."
- Ring 2 names r156, 11px .16, delays .12+i×.12s; Ring 3 Ananga names r108, 10px .11 .14em, rotation i×45, delays .30+i×.18s, glow 6px .10. Circles r196 (.05), r218 dashed 2 8 (.04), r240 (.03), r90 (.04). Holding ring 134px; bindu **78px** (v1 76) — "slightly larger (second ring has unlocked)"; core 21px. Vignette to .70. Caption "All of her. Here. Always." at cy+224 (.52). "Tap to return" (.13).
- MECHANISM: Silence richness grows with unlock count (one orbital per opened ring; bindu grows).
## A5. THE VEIL · THE DESCENT (`Mandala Veil.html` 138 + `veil-mandala.jsx` 322) — "FULL-FIDELITY INTERACTION — design handoff to Claude Code"

Host: title "Bindu Mandala — The Veil · The Descent"; body #000 flex-centred; #stage 390×844, radius 30, shadow 0 40px 120px rgba(0,0,0,.6), scaled `min((innerW−24)/390, (innerH−24)/844)` capped 1.25 (fitStage on resize). Loads screens.jsx, mandala-v2.jsx, screens-v2.jsx, ring-worlds.jsx, legend-explorations.jsx, veil-mandala.jsx (order matters). Renders `<VeilMandala/>`. Honors `prefers-reduced-motion` (all animations 0.001ms, 1 iteration).
CSS adds (L73–101): rw2-today (brightness 1→1.45, drop-shadow 4px .45→14px .85, 3.5s), rw2-today-halo (opacity .35→.65, scale 1→1.08, 3.5s), rw2-embodied 4.5s (1→1.18), rw2-active 6s (1→1.10), rw2-exploring 8s (.95→1.04), rw2-mapped 11s (.92→.99); rw2-invoc-name/bija/quality/hint fade-up 1.4s at .3/.9/1.5/2.4s; veilBinduPulse 4.5s (scale 1→1.16, shadow 14px 5px .5 → 26px 12px .7 + 44px 22px .30); peek-chevron peekHint 3.2s (opacity .45→.9, y +2→−2); dest-enter destIn 0.5s cubic-bezier(.22,1,.36,1) (y+10→0).

### Design's stated intention (veil-mandala.jsx L1–25, verbatim)
"THE GESTURE — Resting: the yantra is a held image. Bindu breathes; Ring 2 petals live. A faint peek at the bottom whispers "there is more below." Swipe up (or tap the handle) → a veil of dark ground rises over the yantra, which dims behind it (to ~0.55) but is never hidden. Swipe back down, or tap the dimmed yantra, to dismiss.
THE DESCENT (inside the veil) — Nine Avaraṇas as a column read top→bottom = outer ground → inner Bindu. Rings I–VIII are rows; Ring IX (the Bindu) is a distinct footer, not a row.
LUMINOSITY SYSTEM (status is light, never locks — no labels, no padlocks) — home fully lit + faint gold wash behind the row + glyph glow; unlocked glyph & name glow gold, solid threshold-line; ancient warm but dimmer (the ground beneath you), solid line; locked veiled (~0.34), DASHED threshold-line = not yet crossed; deep_ghost barely there (~0.20), dashed line.
ROUTING ON TAP — open ring (home/unlocked/ancient) → Ring World (Ring II = the inhabited lotus); locked / deep_ghost ring → Threshold ceremony."

### VL-01 · VeilMandala (L173–320) — the resting/held screen + the sheet
- SEES (resting): 390×844 #060104; ambient radial ellipse 64% 46% at 50% 42% rgba(201,150,63,.06); DustMotes 6; StatusBar; "2nd Avaraṇa · Sarvāśā-Paripūraka" (10px gold .17em .8); `HeldYantra scale .82` (from legend-explorations.jsx) centred in a 600px box at top 116; caption at top 690 **"the instrument · look, do not operate"** (Cormorant 13 italic rgba(242,232,217,.30)) — fades out (0.4s) when open.
- Sheet: height 720, PEEK 108 → CLOSED translateY = 612; gradient to top rgba(8,2,6,.995)→rgba(11,3,7,.985) 70%→rgba(13,4,9,.92); top border .5px gold .22; radius 22 22 0 0; shadow 0 −20px 60px rgba(0,0,0,.7), 0 −1px 30px rgba(201,150,63,.10). Handle 40×4 r3 rgba(242,232,217,.30).
  - Peek state: chevron (22×9 path, gold stroke 1 .55, peekHint 3.2s) + "THE NINE AVARAṆAS" 8.5px gold .5 .26em.
  - Open state: "The Nine Avaraṇas" (Cormorant 22 300 cream) + right "DESCEND" (8.5px gold .5 .16em).
- DOES (exact thresholds): pointer down/move/up on handle only (touchAction none). Drag clamps offset 0…612 (screen px divided by stage scale). Release: if max movement < **6px** → tap = toggle (open if currently ≥ 306 else close). Else snap open if offset < **SNAP = 612×0.42 = 257.04**, otherwise close. `open` flag = offset < 306. Transition `transform 0.52s cubic-bezier(.22,1,.36,1)` (none while dragging). Yantra opacity `dim = 0.5 + 0.5×(offset/612)` → 1.0 closed, **0.5** fully open (comment says ~0.55), opacity transition .5s. When open a full-screen backdrop catcher (z5) closes on tap. Column content opacity 0→1 (.4s) and pointer-events only when open.
- ARRIVE/LEAVE: tap a row → `route = ring` → Destination overlay (z60). Esc key or invisible back hotspot (top 44, left 0, 180×56, over existing "‹ Mandala"/return arc) → route null.

### VL-02 · ThresholdRow (L46–97) — rings I–VIII
- SEES: row padding 15 16, radius 13, gap 16. Home: background linear 90deg rgba(201,150,63,.10)→.03 + border .5px gold .26. Others: bottom border — dashed .5px rgba(242,232,217,.11) (locked/deep_ghost) or solid .5px rgba(201,150,63,.11). Glyph `RingGlyph` (ring-worlds.jsx) size 36 in L.accent at L.glyph opacity; lit rings get drop-shadow 7px rgba(201,150,63,.45). Name Cormorant 20 300 cream opacity L.name; subtitle 13 italic L.sub; meta 9px uppercase .11em at L.sub×.72 "{form} · {count} forces|point". Right: Roman numeral (I…VIII) Cormorant 19 in accent.
- LUM table (L34–40):
| status | glyph | name | sub | accent | dashed | wash | glow |
|---|---|---|---|---|---|---|---|
| home | .95 | .96 | .62 | #C9963F | no | yes | yes |
| unlocked | .85 | .88 | .54 | #C9963F | no | no | yes |
| ancient | .60 | .66 | .42 | #CF9443 | no | no | no |
| locked | .30 | .36 | .24 | rgba(242,232,217,.42) | yes | no | no |
| deep_ghost | .18 | .22 | .15 | rgba(242,232,217,.30) | yes | no | no |
- DATA: AVARANAS (ring, status, name, subtitle, form, count) filtered ring ≤ 8, sorted ascending.

### VL-03 · BinduFooter — Ring IX (L101–140)
"A more present hairline — you have reached the center of the column": gradient line 14%–86% gold .45; radial warmth 180×130 rgba(139,26,42,.20); veil-bindu 26px radial #8B1A2A→rgba(139,26,42,.65) 55% with 10px cream core glow 12px .6, pulse 4.5s; name Cormorant 24 gold; subtitle 14 italic .6; "THE BINDU · IX" 8.5px gold .55 .26em.

### VL-04 · Destination (L144–169)
- Routing: `AVARANAS[ring−1]`; if open status AND ring === 2 → `RingTwoWorld todayIndex=TODAY_INDEX` (ring-worlds.jsx) ("the inhabited lotus"); every other ring (open or locked) → `AvaranaThresholdScreen` ("doorway (open) / ceremony (locked)"). Enters with .dest-enter 0.5s. Esc → back.
- NB: the routing comment says open → Ring World, but only Ring II has a world wired here; Rings 1/3 open still go to the Threshold.
## A6. THE LEGEND · FOUR DOORWAYS (`Mandala Legend.html` 163 + `legend-explorations.jsx` 453)
(Upload-only — not present in repo `Claude Designs/`.)

Host title "Bindu Mandala — The Legend · Four Doorways"; canvas "Bindu Mandala · The Legend · Four Doorways"; loads design-canvas, screens, mandala-v2, legend-explorations. CSS = v2 yantra animations (ring2-*, ring3-petal, lock-r4..7, deep-ghost-tri, mandala-bindu-breathe, ringIndicatorPulse, moteRise).

### LG-00 · Design Note "The Design Question" (host L90–129) — verbatim in Part B
Sections: "The Legend — Reasoning" ("The principle before the pixels — push back on the thinking, not just the layout"); "Four Placements" ("Each answers 'where does the Legend live?' — inline column · pull-up veil · chamber grid · descent spine"). Artboards: "1 · The Descent — inline column you read downward"; "2 · The Veil — sheet drawn up over the yantra hero"; "3 · The Doorways — nine chambers, lit & veiled"; "4 · The Spine — the suṣumnā, nine nodes of descent". Design note card 460×844, gradient #0D0508→#080306, border gold .18.

### LG-01 · TIER table (status as light) L13–19
| status | tag | glyph | text | sub | accent | rule | open | veil |
|---|---|---|---|---|---|---|---|---|
| home | You are here | .95 | .95 | .60 | #C9963F | solid | ✓ | 0 |
| unlocked | Open | .82 | .84 | .50 | #C9963F | solid | ✓ | 0 |
| ancient | Ground | .62 | .66 | .40 | #CF9443 | solid | ✓ | 0 |
| locked | Ahead | .30 | .34 | .22 | rgba(242,232,217,.40) | dashed | ✗ | .55 |
| deep_ghost | Veiled | .16 | .20 | .13 | rgba(242,232,217,.28) | dashed | ✗ | .72 |
(Veil's LUM table in veil-mandala.jsx is a slightly retuned copy, no tags.)

### LG-02 · RingGlyph (L36–113) — the nine sigils ("Only primitives: squares, triangles, radial petal-ticks, dots.")
stroke width max(.7, size/34), round joins.
| ring | glyph |
|---|---|
| 1 Bhupura | square half-side .36·size |
| 2 | circle r .16 + 16 radial ticks .22→.42 |
| 3 | circle r .16 + 8 radial ticks |
| 4 | interlocked star (up + down triangle r .40) |
| 5 | up triangle + half-size up triangle at .6 opacity |
| 6 | down triangle + half-size down at .6 |
| 7 Vāk | circle r .34 + 12 dots on it (r = sw×.9) |
| 8 Mūla Trikoṇa | single down triangle r .40 |
| 9 Bindu | circle r .40 stroke .7sw opacity .5 + filled dot r .16 |
Reused by the Veil rows, and (as `RingGlyph`) in ring-worlds.

### LG-03 · HeldYantra (L118–127) — "A quiet, scaled yantra — the held image": SriYantraMandala 344 inside a box round(344×scale), scaled from top-left, opacity `dim`. Used in Veil (.82), Descent (.40), Veil variant (.74 dim .55), Doorways (.30), Spine (.46 dim .28).

### LG-04 · Variation 1 — The Descent (L154–227)
"Yantra as crest. Below: nine thresholds as a single column you read downward — the same inward movement as the geometry. A scroll, not a menu."
SEES: radial ellipse 60% 30% at 50% 14% gold .06; DustMotes 5; eyebrow "The Nine Avaraṇas"; HeldYantra .40; "Descend, one ring at a time" (13 italic .42); 9 rows (padding 13 14, radius 12; home bg rgba(201,150,63,.06) + border .22; others bottom-rule dashed rgba(242,232,217,.10) / solid gold .10); RingGlyph 34; name 19; subtitle 12.5 italic; "{form} · {count} forces|point" 9px; right Roman 17 + tag 7.5px. TabBar mandala (still present in explorations). Rows clickable only if open (cursor only — no handler).

### LG-05 · Variation 2 — The Veil (L235–303)
"Yantra is the full hero. A sheet of thresholds is drawn up from below like lifting a veil. Shown mid-rise: the gesture is the point."
SEES: bg #070205; eyebrow "2nd Avaraṇa · Sarvāśā-Paripūraka"; HeldYantra .74 at dim .55 (top 78); sheet height 540, gradient rgba(8,2,6,.99)→rgba(10,3,7,.97) 78%→rgba(12,4,8,.80), border gold .20, radius 20 20 0 0, shadow 0 −18px 50px .6 + 0 −1px 24px gold .10; handle 38×4; "Nine Thresholds" (21) + "DRAW UP TO DESCEND"; rows glyph 30, name 17, form 9px; home shows "HERE" else Roman. → became veil-mandala.jsx (the chosen one).

### LG-06 · Variation 3 — The Doorways (L311–380)
"Each avarana is a literal portal — an arched chamber. Nine doorways in a 3×3 grid: open ones lit from within, ones ahead dark behind a veil."
Doorway: aspect .74, radius 40 40 8 8; lit = radial ellipse 90% 70% at 50% 80% rgba(201,150,63,.14)→rgba(26,12,16,.6) 70%, border .5px {rule} gold .40, inset shadow 0 −18px 30px gold .10 + 0 0 18px .06; unlit = rgba(10,4,8,.7), border rgba(242,232,217,.12), scrim rgba(6,1,4,veil) + backdrop blur .5px. Glyph 30 + Roman 15 + form 7.5px + tag 6.5px. Screen: eyebrow "The Nine Chambers", HeldYantra .30, "Lit doorways open · veiled ones wait", 3-col grid gap 10.

### LG-07 · Variation 4 — The Spine (L389–448)
"The descent made literal: a vertical thread (the suṣumnā) with nine nodes. Bright above where you've reached, faint below where you haven't. Tap a node to enter. The thread shows exactly how deep you are."
Thread at left 38, 1px gradient gold .55 → .45 @30% → rgba(242,232,217,.10) @48% → .04. Nodes: home 11px (glow 10px 2px .7 + ringIndicatorPulse 3s), open 8, else 5; deep_ghost hollow ring; opacity open .95 else .5. Each row height 100/9 %; glyph 26; name 16.5; "{form} · {Roman}"; tag. Eyebrow "The Descent"; HeldYantra .46 dim .28 at top 52 right −36; radial ellipse 50% 60% at 22% 50%.
## A7. PHASE III — THREE RING-WORLDS (`Ring Worlds.html` 190 + `ring-worlds.jsx` 974)

Host: title "Phase 3 — Three Ring-Worlds"; canvas "Phase III · Three Ring-Worlds"; loads design-canvas, screens, home-mandala, ring-worlds. Header comment (jsx L1–5): "Three worlds, three atmospheres, three vocabularies. Ring 2 — the inhabited lotus (the home ring, deeply known) · Ring 7 — the sound chamber (Vāk · where speech is sound is healing) · Ring 8 — the root triangle (three becoming one becoming none)".
Canvas sections (verbatim):
- "Ring 2 · The Inhabited Lotus" — "Sarvāśā-Paripūraka · the 16 Karṣiṇīs · PRESS A PETAL to invoke her presence · home-breath tone (lower-left)"; artboards "Default · interactive · press a petal to invoke", "Invocation · long-press today's petal".
- "Ring 2 · The Lotus Follows the Sun" — "Within a ring-world, time has texture · petals open and fold with the day"; "Dawn · the petals open", "Noon · the lotus is full", "Dusk · the petals fold", "Night · the lotus rests".
- "Ring 7 · The Vāk Sound Chamber" — "Sarvarogahara · twelve speech-goddesses · TAP A SYLLABLE TO HEAR HER · tap center for the chord · sound enough and the word that heals arrives"; "Sound Chamber · interactive · tap a syllable", "One sounding · Modinī's tone visible", "The Chord · all twelve together".
- "Ring 8 · The Mūla Trikoṇa · The Teaching Arc" — "Sarvasiddhiprada · three becoming one becoming none · INTERACTIVE: tap a vertex, then tap to dissolve · three tones collapse into one (sound, lower-left)"; "① The Triangle · three vertices", "② Icchā · the other two collapsed in", "③ Jñāna · only the knowing remains", "④ Kriyā · only the doing remains", "⑤ Dissolution · only the Bindu remains".
Host CSS: rw2-today 3.5s / rw2-today-halo 3.5s / rw2-embodied 4.5s / rw2-active 6s / rw2-exploring 8s / rw2-mapped 11s (same as Veil); rw2-invoc-name/bija/quality/hint fade-ups 1.4s at .3/.9/1.5/2.4s; **rw7-sound-ring** scale .4→3.0, opacity .85→0, 1.6s ease-out infinite; **rw7-chord-ring** scale .3→4.5, .7→0, 2.4s; **rw8-triangle** opacity .78→.95 + drop-shadow 10px rgba(242,232,217,.35), 18s; **rw8-collapse** opacity 0→1 .9s.

### Shared atmospherics (jsx L19–47)
- FaintRingMemory: "The ghost of where you came from — outer rings as faint memory at edges." Two squares ±180 (opacity×1.2) and ±168 gold stroke .4.
- ReturnGesture: "Subtle arc at top suggesting 'swipe down to return to home'" — 80×14 SVG at top 56, quadratic arc M8,11 Q40,3 72,11, stroke rgba(201,150,63,.32) (light variant rgba(242,232,217,.25)), w .7. (**The return gesture = swipe down from top inside a ring-world.** Note conflict with Codex G7 "Swipe down from top = offer (Pūjā, evening only)".)
- RingSoundToggle (L428–443): lower-left (bottom 50, left 22) 18px circle border .5px {color}+b3/4d, fill {color}1f when on, 4px dot; label shows `label` when on else "silent" (8px .22 .22em upper). Stops propagation.

### Audio engine (L341–425) — Web Audio, created lazily on first interaction
- `playBija(freq, dur=2.4, vol=.13)`: sine at f + sine at 2f; gain 0 → vol in .15s → vol×.85 at .7dur → 0 at dur; 2nd harmonic 0 → vol×.25 at .2s → 0 at .9dur.
- Home voice `rwHomeStart`: sine 130.81 Hz (C3 — "home") + sine 196.00 Hz ("a fifth") at gain .45; LFO 0.18 Hz depth .02 on master ("slow breath"); master → .045 (time constant .6). `rwHomeGain(v)` (tc .25). Stop: → 0 (tc .4), oscillators stopped after 1000ms.
- Ring 8 triad `r8Start`: R8_FREQS = 261.63 / 311.13 / 392.00 (Icchā · Jñāna · Kriyā, "a minor triad"), each gain .33, master → .06 (tc .5). `r8Set(target)`: 'triad' → each to own freq; index → all three glide to that vertex's freq; 'bindu' → all glide to 130.81 (C3). Glide time constant .55s. Stop as home.

### RW2-01 · RingTwoWorld — The Inhabited Lotus (L55–249)
- SEES: 390×844, bg linear 180deg #0A0608 → #060104 60% → #050103; radial ellipse 75% 60% gold .10; DustMotes 10; FaintRingMemory .05; StatusBar; ReturnGesture; identity at top 92 "Sarvāśā-Paripūraka · the Sixteen" (Cormorant 13 italic gold .5 .18em). Lotus centre (195, 430), petal oR 172, iR 96, hw 32; labels at r138, 10px italic (today cream; others rgba(242,232,217,.55), muted .10 ×.5). Inner memory: 4 triangle pairs r80/65/50/36 gold .4 at opacity .08 (.04 while invoked). Today halo: petal blur 11px opacity .42 (rw2-today-halo). Embodied glow blur 6px .25. Petal class today → rw2-today else rw2-{status}, delay i×0.16s. Bindu circle r10 accentRed, SVG `<animate r 9;12;9 4.5s>`, opacity .85 (.4 invoked); cream r4 drop-shadow 6px .7 (.95 / .5 invoked).
- DOES: pointerdown on a petal → invoke (setInvoked i; if sound on, home gain → .075). Other petals muted to ×0.18 opacity. pointerup/leave → home gain .045 and after **2600ms** invocation clears ("release · she remains, then settles"). Mode 'invocation' = static, today's petal invoked. Sound toggle label "home", colour #C9963F.
- WORDS: invocation overlay bottom (padding 0 36 140): name 34px cream .08em (.3s), bija 26px italic gold .12em (.9s), quality 16px italic .62 (1.5s), "release · she remains" (9px .18 .28em, 2.4s). Idle hint (bottom 58): "press a petal to invoke her presence" (8.5px .20 .26em).
- DATA: SHAKTIS (name, short, bija, quality, cluster, status), CLUSTER_INFO, STATUS_OPACITY.
- NB: Codex G8 "Two-finger hold — invoke" is realised here as a single press-and-hold on a petal.

### RW2-02 · RingTwoLotusByTime — "The Lotus Follows the Sun" (L253–331)
centre (195,420), base oR 200 iR 110 hw 40; petal oR = 200×openFactor, hw = 40×(.7+.3×openFactor), opacity STATUS_OPACITY×opMul (transition 1s). Label at top 92 (13 italic gold .55).
| phase | label | bg gradient | openFactor | opMul | bindu op |
|---|---|---|---|---|---|
| opening | Dawn · the petals open | #0F0810→#080406 | .78 | .85 | .85 |
| open | Noon · the lotus is full | #0A0608→#060104 | 1.0 | 1.0 | .85 |
| closing | Dusk · the petals fold | #0C0508→#06010A | .85 | .82 | .85 |
| closed | Night · the lotus rests | #020108→#010104 | .45 | .40 | .95 (core .98) |

### RW7-01 · RingSevenWorld — The Vāk Sound Chamber (L462–661)
Comment: "Eight speech-goddesses arranged as a sonic field. Tap a Vāk to hear her bīja. Tap center for the full chord. The visual itself resonates with the sound." — **but the implementation has TWELVE** (VAK_FREQS), and the canvas says "twelve speech-goddesses"; Codex said 8.
- VAK_FREQS ("a mystical mode (mixolydian-ish), warm and grounded. Vāśinī starts low; ascending around the circle"):
| # | name | bīja | Hz |
|---|---|---|---|
| 0 | Vāśinī | aṁ | 220.00 |
| 1 | Kāmeśvarī | āṁ | 246.94 |
| 2 | Modinī | iṁ | 261.63 |
| 3 | Vimalā | īṁ | 293.66 |
| 4 | Aruṇā | uṁ | 329.63 |
| 5 | Jayinī | ūṁ | 349.23 |
| 6 | Sarveśvarī | eṁ | 392.00 |
| 7 | Kaulinī | aiṁ | 440.00 |
| 8 | Vāṅmayī | oṁ | 493.88 |
| 9 | Onmādinī | auṁ | 523.25 |
| 10 | Mantreśī | aṃ | 587.33 |
| 11 | Śaktimayī | aḥ | 659.25 |
- SEES: bg linear #0E0703 → #0A0502 → #060301; radial ellipse 70% 55% at 50% 48% rgba(212,160,23,.16) → rgba(139,90,40,.06) 45%; DustMotes 8; identity "Sarvarogahara · the Vāk Chamber" (13 italic rgba(212,160,80,.6)). Background 4 triangle pairs r80/65/52/40 stroke #E8C97A .5 at opacity .12. Centre (195,408), orbit r140, 12 nodes every 30° from top: 44px circle border 1px rgba(232,201,122,.45) (.95 active), bg radial .06 (active .32→.05), active shadow 0 0 24px 6px .55 + inset 12px .3, bija 18px italic (active cream), name 10.5px italic (.55 / active #E8C97A); transitions .5s. Centre chord disc 60px (idle radial .18→.04, border .18, shadow 12px 2px .12; chord radial rgba(242,232,217,.85)→rgba(232,201,122,.4), border .6, shadow 40px 14px .45), 6px cream dot.
- DOES: tap node → strikeOne: active=i, add to sounded set, playBija(f, 2.6s, .11), clears after **2400ms**. Tap centre → strikeChord: all 12 marked sounded, each playBija(f, 3.2s, .05) staggered **i×55ms**, chord state clears after **3400ms**.
- MOTION: 3 sound rings r20 at the active node (bug: cx always centre, only cy follows the node) delays 0/.3/.6s, opacity .7 (.5 chord); chord: 4 cream rings r30 delays i×.2s (rw7-chord-ring).
- MECHANISM — "healed": when sounded.size ≥ **7** of 12.
- WORDS (caption bottom 70): chord → "the full chord — all twelve at once"; active → that Vāk's name; healed → **"The word that healed what the mind could not reach."** (17px, .78); default → "tap a syllable · tap center for the chord". Sub-line: healed → "she who removes all disease" else "{n} of 12 voices sounded".
- Props: initialActive, chord, initialHealed.

### RW8-01 · RingEightWorld — The Mūla Trikoṇa / The Teaching Arc (L679–967)
Comment: "Three points. Three were never three. The simplicity is the teaching. Tap a vertex → the other two collapse into it. Tap the realized quality → it dissolves into the Bindu. Begin again."
- MULA_VERTICES: Icchā — Will — "the wanting before want has an object" — #C45050; Jñāna — Knowledge — "the knowing before knowledge has content" — #9A8FC4; Kriyā — Action — "the doing before doing has direction" — #5A9A8B.
- SEES: bg radial ellipse 80% 70% at 50% 40% #0A0608 → #020001; DustMotes 4; ReturnGesture light; identity "Sarvasiddhiprada · the Mūla Trikoṇa" (13 italic rgba(242,232,217,.35)). Triangle centre (195,330), R 132: apex Icchā (195,198), bottom-left Jñāna, bottom-right Kriyā. Triangle state: cream stroke 1 opacity .85 (rw8-triangle 18s). Vertex: hit circle r20, glow r12 (24 chosen) blur 8 .20, dot r5 (7), cream core r2 (3). Labels: name 24px italic in vertex colour + glow 14px, English 10px .40 .20em; placed −36 above apex / +30 below base vertices (±10 x).
- STATE MACHINE: triangle →(tap vertex i)→ icchaa | jnaana | kriyaa →(tap anywhere)→ dissolved →(tap)→ triangle. Tapping background in triangle state does nothing ("must choose a vertex first").
- Collapsed: ghost triangle cream .5 at .10; dashed lines (2 5, w .5, .55) from the other two vertices to the chosen one in its colour; other vertices fade to .22; rw8-collapse .9s. Lower text (top 470): HUGE name 76px italic vertex colour, glow 40px; English 11px .45 .32em; prose 19px italic .66 (max 300); hint "the other two have collapsed in · tap to dissolve" (9px .22 .30em).
- Dissolved: vertices hidden; Bindu at centroid grows r7 → **52** (opacity .7 → .92, drop-shadow 8px .4 → 44px .8), cream r3 → 20 (shadow 24px .95); transition 1.4s. Words: "The three were never three." (38px italic cream); 40px gold hairline; "Will, knowing, doing — three motions of the same hand. The hand was always whole." (18px italic .50); "tap to begin again".
- Triangle state words (top 540): "The root triangle. / Will, knowledge, action — / one undivided power." (21 italic .72); hairline; "tap a vertex".
- SOUND: toggle label "three"; triad → one vertex frequency → Bindu C3 130.81 (glide .55s).
## A8. PHASE III·b — RING-WORLDS II (`Ring Worlds II.html` 222 + `ring-worlds-2.jsx` 538 [Ring 1]; Rings 3/4/5/6 in ring-worlds-3.jsx; Ring 9 in ring-nine.jsx)

Host: title "Phase 3b — Ring-Worlds II"; canvas "Phase III·b — Ring-Worlds II"; loads design-canvas, screens, ring-worlds-2, ring-nine, ring-worlds-3 (does NOT load ring-worlds.jsx).
Canvas sections (verbatim):
- "Ring 1 · The Earth-City" — "Trailokyamohana · the outer ground · 28 forces in three families — the three nested squares · TAP A LIGHT, A FAMILY, OR A GATE · ground drone (lower-left)". Artboards: "The Earth-City · interactive · tap a light, a family, a gate"; "A family illumined · the eight Mothers (language)" (initialFamily matrka); "Meeting her · Vārāhī, the rooting tongue" (initialMet 15); "The world made visible · all 28 alight" (initialAllLit).
- "Ring 3 · The Smoke Lotus" — "Sarvasaṅkṣobhaṇa · the eight Anaṅgas · bodyless desire · TOUCH A PLUME (it never hardens) · the seed for all eight · longing-tone (lower-left)". "The Smoke Lotus · interactive · touch a plume, or the seed"; "One longing felt · Anaṅgamadanā" (initialActive 2).
- "Ring 4 · The Lineage" — "Sarvasaubhāgyadāyaka · the fourteen Sampradāya Śaktis · the teaching travels teacher → student · TOUCH A STATION · the center to send the teaching · lineage-tone". "The Lineage · interactive · a transmission travels the line"; "One station · received, and passed on" (initialActive 6).
- "Ring 5 · The Overflow" — "Sarvārthasādhaka · the ten Kulottīrṇa Śaktis · overflowing what contains them · TOUCH ONE TO OVERFLOW · the center to transcend the kula · overflow-tone". "The Overflow · interactive · the boundary cannot hold her"; "Transcending the kula · all ten overflow" (initialFlood).
- "Ring 6 · The Concealed" — "Sarvarakṣākara · the ten Nigarbha Śaktis · too interior to be spoken · MOVE THE LIGHT (it reveals only what is near) · touch what it reaches · she will not stay". "The Concealed · interactive · move the light through the dark"; "The light reaches one · she whispers, then conceals" (revealAt 7).
- "Ring 9 · The Bindu — Praveśa, the Endless Indwelling" — "Sarvānandamaya · the point that contains all points · CHOSEN DIRECTION: B · press and hold to fall inward — hold past the falling for the recognition · Shepard tone (lower-left)". Artboards: "B · Praveśa — the Endless Indwelling · hold to fall inward"; "B · the recognition — held past the falling, the seeker dissolves" (mode recognition); "A · Spanda — the World-Breath (the other direction we explored)"; "A · Spanda — the fullness" (frozen 1).
Host CSS: rw1-far-bindu (opacity .35→.62, r 3→4, 9s); rw1-gate-ember (.42→.78, 5.5s); rw1-met-ring (scale 1→4.2, .8→0, 2.6s ease-out inf); rw1-rise (y+10→0, 1.1s cubic-bezier(.25,.1,.25,1)); rw1-drone-on (scale 1→1.5, 3.2s); r3-smoke (.82→1, 8s); r3-seed (.8→1, 8s); r5-ray (.28→.85, 2.6s); r6-whisper (0% opacity 0 blur 3px y+4 → 16% 1 blur 0 → 72% 1 → 100% 0 blur 2px; 3.2s forwards); r6-heart (.38→.7, 6s).

### RW1-01 · RingOneWorld — The Earth-City (ring-worlds-2.jsx L165–535)
Header (verbatim L4–10): "RING 1 — Bhūpura · the Earth-City (the outer ground, the world made visible). The three families ARE the three nested squares: · 10 Siddhi on the outer line — the powers · accomplishment · work · 8 Mātṛkā on the middle line — the mothers · language · family · 10 Mudrā on the inner line — the seals · gesture · body. The ground does not breathe. It holds. A low Mūlādhāra drone, four gates where the world enters, and 28 lights you have walked among without knowing."
- SEES: bg linear #0C0703 → #080402 55% → #060301; ambient radial ellipse 78% 62% at 50% 62% rgba(207,148,67,.11) → rgba(139,90,40,.05) 46%; DustMotes 9; ReturnArc (stroke rgba(207,148,67,.34)); identity top 90: "Trailokyamohana · the Earth-City" (14 italic rgba(217,169,60,.62) .20em) + "28 FORCES · THE OUTER GROUND" (10px .30 .30em). Centre (195,348). Three squares half 150 (siddhi), 110 (mātṛkā), 72 (mudrā), stroke .8 in family colour; opacity 0.24 idle / focused .52 / others .07 / allLit .5 (1s). Inner path circles r46, r32 at .12 (.06 all lit); far bindu r3.4 accentRed (rw1-far-bindu 9s). Four T-gates on outer square: stem 18px outward + lintel ±15 perpendicular, siddhi colour w .9, opacity .4 (lit .7), ember r2.4 (rw1-gate-ember 5.5s). 28 lights evenly on perimeters (squarePoints: (i+.5)/n × perimeter, starting top-left going clockwise): idle op .52 r2.8 glow 4; family-focused .92 r3.6 glow 8 / non-family .10 r2 no glow; allLit .96 r3.4 glow 9; met 1.0 r5.4 glow 13 + expanding ring (rw1-met-ring 2.6s) + cream core r×.42. Hit radius 13.
- FAMILIES (R1_FAMILIES):
| key | label | english | colour | lived (verbatim) |
|---|---|---|---|---|
| siddhi | Siddhi | the ten powers · accomplishment | #D9A93C | "Ten powers of accomplishment. You have known these as work — the thing that got done, the will that held through the night. Every accomplishment was already hers." |
| matrka | Mātṛkā | the eight mothers · language | #CF9443 | "Eight mothers — language itself. You have known these as family, as the mother-tongue, as every name spoken in love. The world was spoken before it was seen." |
| mudra | Mudrā | the ten seals · gesture | #B07F36 | "Ten seals — the gestures of the body. You have known these as the body — the reach, the grip, the hand that shaped a whole life. Matter became sacred in the moving." |
- R1_QUALITY (pos → line, verbatim; "concise, canonical meanings (not invented; the traditional senses of the aṇimādi siddhis, the eight mātṛkās, the mudrā-śaktis)"): 1 "the power to grow infinitely small — to enter the atom of a moment"; 2 "weightlessness — to be unburdened by what you carry"; 3 "the power to grow vast — to contain more than your form"; 4 "sovereignty — to preside over what is yours"; 5 "mastery — the world arranging itself around your steadiness"; 6 "irresistible will — a wanting that meets no wall"; 7 "fruition — the right to enjoy what has ripened"; 8 "the wish answered before it is spoken"; 9 "reach — to arrive anywhere without moving"; 10 "the garland of all desires, each one already granted"; 11 "the first sound — she who speaks the world into vowels"; 12 "the great voice — speech as sovereign power"; 13 "the ever-young syllable — speech before it was taught"; 14 "the sustaining word — language that holds the world together"; 15 "the rooting tongue — speech that digs into the earth of meaning"; 16 "the radiant utterance — language that rules from the height"; 17 "the fierce syllable — the word that ends what must end"; 18 "the abundant word — speech that pours itself into form"; 19 "the seal that stirs — the gesture that wakes the still"; 20 "the seal that scatters — the gesture that disperses what clings"; 21 "the seal that draws — the gesture of attraction itself"; 22 "the seal that gladdens — the gesture that floods with delight"; 23 "the seal that enchants — the gesture that suspends the mind"; 24 "the seal that arrests — the gesture that holds time still"; 25 "the seal that opens — the great yawn of space"; 26 "the seal that masters — the gesture that brings all under one will"; 27 "the seal that colours — the gesture that tints the world with feeling"; 28 "the seal that maddens — the gesture of divine intoxication".
- DOES: tap a light → meet (starts drone if off, family focus = hers). Tap family label (bottom 82, gap 22; 6px dot + 14px italic) → toggle family focus. Tap any gate → ignite (all 28 lit). Tap background → release all. Sound toggle (bottom 50 left 22): "ground"/"silent", dot pulses rw1-drone-on when on.
- WORDS (lower block top 512): met → name 40px cream + "{Family} · {second half of english}" 9.5px family colour .30em + quality 19 italic .66; family → label 34px in colour + english + lived 16.5 italic .60; all lit → **"Thank you for the world I have walked through without knowing it was you."** (24 italic .78) + "THE WHOLE GROUND, ALIGHT"; default → **"The ground you have walked, before you knew it was hers."** (20 italic .52). Hint (bottom 56): "tap a light to meet her · a gate to let the world in".
- SOUND: drone 73.42 Hz (~low D) + 110 Hz (fifth, gain .4), fade-in 0→.05 over 2.2s, LFO .07 Hz depth .018 ("the world turning, almost still"); stop ramps to 0 in 1.4s. Starts automatically on first interaction.
- DATA: RING1_SHAKTIS (id, pos 1–28, name), AVARANAS.
## A9. RING-WORLDS III — Rings 3, 4, 5, 6 (`ring-worlds-3.jsx` 642; hosted by Ring Worlds II.html)

Header (verbatim L1–6): "Rings 3, 4, 5, 6 — each finding its own verb. 3 · Anaṅga — the Smoke Lotus (bodyless desire; reach and it dissolves) · 4 · Sampradāya — the Lineage (the teaching travels teacher → student) · 5 · Kulottīrṇa — the Overflow (light transcends the boundary that holds it) · 6 · Nigarbha — the Concealed (revealed only by nearness, then hidden again)". Data globals: RING3_SHAKTIS, RING4_SHAKTIS, RING5_SHAKTIS, RING6_SHAKTIS.
Shared chrome: R3ReturnArc (same arc, colour per ring); RingId (top 90: title 14 italic in colour .20em + sub 10px .30 .30em uppercase); SoundDot3 (bottom 50 left 22, 18px, label/“silent”, dot pulses rw1-drone-on when on). All four use HomeIndicator light, hint line at bottom 56 (8.5px .20 .26em), lower text block starting ~540–566.
Audio (L35–76): `w3Note(freq, dur 1.6, vol .09)` — sine f + 2f (gain .25), attack .08s → 0 at dur; harmonic attack .12s → 0 at .85dur. `w3SustainStart(freq, vol .05, vibrato 5)` — sine with LFO .25 Hz × vibrato Hz on frequency, gain → vol (tc .4). `w3SustainGain(v)` tc .2; stop tc .3, oscillators stopped at 800ms.

### RW3-01 · RingThreeWorld — Anaṅga · The Smoke Lotus (L111–254)
- SEES: bg radial ellipse 72% 62% at 50% 46% #160A0C → #0A0406 55% → #060103; overlay radial 60% 50% at 50% 44% rgba(196,114,90,.13) → rgba(139,26,42,.05) 50%; DustMotes 7; arc rgba(196,114,90,.34); RingId "Sarvasaṅkṣobhaṇa · the Anaṅgas" / "EIGHT FORMS · ONE BODILESS LONGING" (rgba(196,114,90,.62)). Centre (195,392). 8 plumes = w3Petal(oR 116, iR 30, hw 52) filled radial gradient #E0937A .9 → rose #C4725A .5 @55% → #8B1A2A 0, blurred (feGaussianBlur 5.5; 10 when moving) — "soft plumes, no crisp edges"; rotation i×45, r3-smoke 8s delay i×.7s. Faint guide ring r34 rgba(196,114,90,.10). Seed at centre 54px: "hsauṁ" Cormorant 22 italic, rgba(224,147,122,.92) still / .42 moving / cream unified, glow 16px rgba(196,114,90,.6), r3-seed 8s; unified bg radial rgba(224,147,122,.4).
- MECHANISM ("bodyless: they thin and scatter when reached for, gather only in stillness"): any pointer move sets `moving` for **800ms**. While moving (and nothing active/unified) each plume drifts 24px outward, scale 1.18, opacity .18, brightness .78, blur 10. Still: drift 0, scale 1, opacity .66, brightness 1.05. Active plume: scale 1.06, opacity 1, brightness 1.5; others .22. Unified: all .92, brightness 1.35. Transitions opacity 1.1s, transform 1.3s cubic-bezier(.22,.61,.36,1).
- DOES: tap plume → active i (sustain → .06, back to .03 after 1400ms). Tap seed → unify (sustain .075; after **2600ms** returns, .03). Tap background → release.
- WORDS (top 540): active → name 36px + quality 17 italic .62; unified → "Eight forms, one longing. The desire that arrives without a body."; moving → "The more you reach for her, the more she thins."; still → "Be still — and the bodiless longing gathers." Hint: "be still to let her gather · touch a plume · the seed for all eight".
- SOUND: "longing" sustain 116.5 Hz, vol .045, vibrato 6 Hz depth (LFO .25 Hz); auto-starts on first touch.

### RW4-01 · RingFourWorld — Sampradāya · The Lineage (L264–393)
- R4_GLOSS: the stirring, the scattering, the drawing, the gladdening, the enchanting, the stilling, the opening, the mastering, the colouring, the maddening, the accomplishing, the fulfilling, made of mantra, the perfecting.
- SEES: bg radial ellipse 70% 60% at 50% 47% #07120C → #050B07 → #040603; overlay rgba(111,163,126,.10); DustMotes 6; green #6FA37E; RingId "Sarvasaubhāgyadāyaka · the Sampradāya" / "FOURTEEN · THE TEACHING TRAVELS THE LINE". 14 stations on circle r150 around (195,396), alternating up/down triangles (r8.5, stroke .9) + dot r2 (3 lit). Garland: quadratic curves between neighbours, control point at 84% radius ("bow inward (garland droop)"); passed strokes 1.1 @ .55 vs .5 @ .14 (.5s). Travelling light: r17 blur glow .28 + cream r4.2 drop-shadow 9px .85. Source at centre: hit r22, ring r6 .4, dot r2.6 .85.
- MECHANISM transmit(): lit=0; every **340ms** advance one station; after 14 → fullyLit, travelling light gone after 600ms. **Auto-starts 900ms after mount** (autoStart, unless initialActive). Station opacity: selected/lit 1, passed .72, unpassed .3.
- DOES: tap centre → transmit (turns sound on). Tap station → select (name card). Tap background → deselect.
- WORDS (top 566): selected → name 34 + gloss 17 italic green .85 + "THE {ordinal} OF FOURTEEN · RECEIVED, AND PASSED ON"; fullyLit → "The garland is unbroken — every name still passed, hand to hand."; default → "The teaching travels the line — teacher to student, across the generations." Hint "touch a station · the center to send the teaching".
- SOUND "lineage": first note 174.6 Hz (1.4s, .05); each step 174.6 × 2^((i/12)/2) (1.2s, .045) — a slowly rising line.

### RW5-01 · RingFiveWorld — Kulottīrṇa · The Overflow (L407–523)
- R5_GLOSS: grants attainment, grants abundance, makes beloved, the auspicious one, grants every desire, the liberator, conqueror of death, remover of obstacles, beauty in all limbs, grantor of grace.
- SEES: bg radial 72% 64% at 50% 44% #0E0A04 → #080502 → #050301; overlay idle rgba(212,160,23,.10) / flood ellipse 95% 80% rgba(212,160,23,.22) → rgba(242,232,217,.06) 45% (1.2s); gold #D4A017; RingId "Sarvārthasādhaka · the Kulottīrṇas" / "TEN · OVERFLOWING WHAT CONTAINS THEM". Kula boundary circle r142 stroke .9 @ .4 (flood: .4 dashed 2 8 @ .12). 10 up-triangles (r13, stroke .9) on r116 rotated outward; on → cream .95 + blurred gold fill r15 .18; idle .5 (.22 when another active). Centre dot r3 .7. Overflow rays: line from r106 to r212 (boundR+70), width 6, gradient cream .5 → gold 0, r5-ray 2.6s.
- DOES: tap triangle → active (C4 261.6 Hz, 1.8s, .05); tap centre (48px) → flood all (4 notes 261.6×2^(k/12), k 0–3, staggered 90ms, 2.4s, .04); tap background → release.
- WORDS (top 560): active → name 34 + gloss 17 italic gold .85; flood → "The accomplishment overflows the one who sought it." + "THE BOUNDARY CANNOT HOLD HER"; default → "Ten forces the circle was meant to hold — and cannot." Hint "touch one to overflow · the center to transcend the kula".

### RW6-01 · RingSixWorld — Nigarbha · The Concealed (L533–640)
- R6_GLOSS: made of knowing, made of power, sovereign splendour, giver of knowledge, remover of disease, the support of all, remover of sorrow, made of bliss, the protectress, giver of the fruit.
- SEES: bg radial 60% 55% at 50% 46% #0A0710 → #050309 → #020104; cursor crosshair; DustMotes 4; violet #9A86C4; RingId "Sarvarakṣākara · the Nigarbhas" / "TEN · CONCEALED, TOO INTERIOR TO BE SPOKEN". 10 alternating triangles r11 on circle r96. The light: 193px (REVEAL×2.1) radial rgba(154,134,196,.16) → .05 @40% follows pointer (.18s ease). Protected centre r3.4 violet .5 (r6-heart 6s).
- MECHANISM: REVEAL radius **92px**. Each triangle opacity = max(0, 1 − dist/92) × .85; >.3 adds blurred fill. Tap a triangle only works if within 92px of the light ("can't name what the light hasn't reached"); whisper shows then fades after **3200ms** (r6-whisper 3.2s: blur-in, hold to 72%, blur-out).
- WORDS (top 552): whisper → name 32 + gloss 16 italic violet .85; default → "What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near." Hint "move the light · touch what it reaches · she will not stay".
- SOUND "within": sustain 207.65 Hz vol .02 vibrato 3; starts on pointer enter; gain = .05×(1−d/92) when nearest node within 92px else .004.
## A10. RING 9 — THE BINDU (`ring-nine.jsx` 582; hosted by Ring Worlds II.html)

Header (verbatim L1–11): "Lalitā Mahātripurasundarī. The point that contains all points. The ring that is not a ring. Two directions toward the monumental: A · SPANDA — the World-Breath. Hold, and the whole Śrī Yantra blooms outward from the single point; release, and the cosmos dissolves back into it. Creation and dissolution in one held breath. A tone swells with the bloom. B · PRAVEŚA — the Endless Indwelling. You fall into the point and never reach a bottom: self-similar yantras emerge from the center forever, each carrying its own bindu. Hold to descend faster."
**Chosen direction: B (Praveśa)** — per the host canvas ("CHOSEN DIRECTION: B"); A kept as "the other direction we explored".

### Geometry
R9_UPS/R9_DOWNS = identical to home-mandala UPS/DOWNS (apex/base/half: U 88/34/76, 68/26/60, 50/18/46, 34/10/34; D 88/−34/76, 72/−28/66, 56/−22/52, 42/−16/40, 26/−10/26). R9_NAMES (16): Kāma, Buddhi, Ahaṅ, Śabda, Sparśa, Rūpa, Rasa, Gandha, Citta, Dhairya, Smṛti, Nāma, Bīja, Ātma, Amṛta, Śarīra.
`FullYantra` (L46–91): bhūpura square ±150 + 4 gate stubs to ±168 (stroke 1, .6); 16-petal lotus r9Petal(132,112,20) stroke .7 @.55; 8-petal (104,88,30) @.5; nine triangles stroke .8 @.85; optional names at r120 (7px italic cream, nameOp) rotated tangentially; optional bindu r5 accentRed .9 + cream r2.

### Audio
- r9 tone (Spanda): sine 146.83 Hz (low D) + 220 Hz fifth (gain .5) + sub 73.42 Hz (gain .6); master gain tracked `0.06 × eased bloom` (tc .08). Stop tc .3, 900ms.
- **Shepard tone** (Praveśa) L135–177: "octave-stacked sines gliding down forever … a bell-shaped amplitude over that range makes the wrap-around inaudible, so the fall never bottoms out." K=7 voices, fMin 32.7 Hz (low C), f = 32.7 × 2^(phase×7); phase descends at rate 0.05 + 0.10×intensity per second; amplitude per voice exp(−((phase−.5)/.26)²)×.42; master .07×intensity (tc .15). Intensity (in Praveśa) = .25 + .75×clamp((speed−.6)/2.4).

### R9-A · RingNineSpanda — the World-Breath (L197–381) [explored, not chosen]
- SEES: bg radial ellipse 70% 60% at 50% 49% #0A0309 → #050007 → #020003; DustMotes 5; identity "Sarvānandamaya · the Bindu" (14 italic gold .55) / "THE POINT THAT CONTAINS ALL POINTS". Root group at (195,412), scale s = .05 + .95×ease(p) (ease = p²(3−2p)). Layers fade in by band (r9band(p, lo, w=.18)) to max opacity: trikoṇa lo .06 → .95 (fill rgba(139,26,42,.10), stroke #E8C97A .9); nine triangles (4 up + first 4 down, stroke #D4A017 .8) lo .24 → .82; 8-lotus lo .42 → .62 (fill gold .04); 16-lotus lo .54 → .85; bhūpura lo .66 → .52 (gates to ±170); names (R9_NAMES r121 7.5px .75) lo .80 → 1.0. Bindu div 26px, glow 14+40e px (spread half) alpha .4+.4e, scale .8+.5e; cream core 8px.
- MOTION: rAF loop; idle auto-breath PERIOD **12s**, target = (0.5−0.5cos(2πt/12))×**0.62**; holding → target 1; p eases toward target at 6%/frame. `frozen` prop renders a fixed p.
- DOES: press-and-hold anywhere → bloom to full (starts tone); release → falls back to idle breath.
- WORDS: rest caption (fades out p .18–.43) "Press and hold — / breathe the world open."; full caption (fades in p .7–.9) "She breathes, and the worlds appear." + "release · and they return to her".

### R9-B · RingNineDescent — Praveśa, the Endless Indwelling (L387–555) [CHOSEN]
- SEES: bg radial ellipse 60% 55% at 50% 49% #0B0410 → #04020A → #010005; DustMotes 4; identity "Sarvānandamaya · the Bindu" / "THE RING THAT IS NOT A RING". N=7 nested FullYantras (gold #C9963F, names on, nameOp .42), each with its own 16-name slice of the 102 (r9NamePool collects `short` from RING1, SHAKTIS, RING3, RING7, RING4, RING5, RING6 — falls back to R9_NAMES; slice offset i×13) and tilt (i×47)%360. Vignette radial transparent to 42% → rgba(1,0,5,.55). Bindu 18px radial accentRed → rgba(139,26,42,.6) 55%, glow 22px 6px .55, cream core 6px.
- MOTION (rAF): each layer depth d = (clock + i/7) mod 1; scale = 0.03 × 2^(6.4d) ("seed → engulfing"); opacity: fade in over d 0–.1, full, fade out d .72–1; ×.72; rotation = tilt + clock×6 ("a slow spiral"). clock += dt × speed × .08. Speed eases (4.5%/frame) to: idle **0.85**; holding **3.0 − 2.2×recog** ("the frantic fall settles into a gentle drift as recognition arrives").
- MECHANISM — exact thresholds: heldTime accumulates while held, decays at 1.4× when released. **THRESH = 6.5s**; recog = clamp((heldTime − 6.5)/2.2) → full recognition at **8.7s** of continuous hold. Rest caption opacity = 1 − heldTime/0.7; descent caption = min(1, heldTime/1.0) × (1−recog); recognition opacity = recog, translateY 8(1−recog). Bindu scale 1+1.7×recog, glow (22+60r)px (6+22r)px alpha .55+.3r. mode 'recognition' starts heldTime at 9 and holds permanently.
- WORDS (verbatim): rest "Press and hold — / fall inward."; descent "There is no bottom." + "only further in"; recognition **"You did not arrive. / You were the arriving."** + hairline + **"Thank you for being the place I have always already arrived."** (gold .82).
- SOUND: Shepard tone starts on first press; SoundDot "tone"/"silent".
## A11. PHASE IV — THE EIGHT MODES (`The Eight Modes.html` 288 + `modes.jsx` 1675)

Host: title "Phase 4 — The Eight Modes of Engagement"; canvas "Phase IV · The Eight Modes of Engagement"; loads shakti-data, all-shaktis-data, design-canvas, screens, modes. modes.jsx header: "Each mode is its own atmosphere. Not a feature, a practice."
Host CSS keyframes: darsanaRadiance (scale 1→1.15, opacity .6→1); darsanaBijaIn (0 → .65 at 30–70% → 0); recogPetalGlow (opacity .6→.9, scale 1→1.18, offset translateY −94px); sadhanaBinduBreath (scale 1→1.15); smritiTwinkle (.5→1, 1.4s); maunaNameIn (0→1, 5s forwards); maunaBinduBreath (scale 1→1.10; shadow 48px 12px .45 → 72px 22px .62; 6s); maunaCaptionIn (0 until 60%, then →1, y+8→0; 7s forwards); svapnaMarkPulse (.45→.85, scale 1→1.3); pujaCatchPulse (.65→.95 + drop-shadow 4px currentColor; 3.5s); sanghaNameBreathe (.55→.95); sanghaNodeBreathe (scale 1→1.18); svapnaWaveform (scaleY .4→1.2); svapnaMicPulse (shadow 28px 8px rgba(232,180,140,.35) → 44px 14px .55).

### MiniYantra (L15–53) — embedded yantra for all mode screens
oR .42·size, iR .34, hw .07; bhupura square ±oR×1.15 gold .4 at .18×intensity; 16 petals cluster-coloured at STATUS_OPACITY×.7×intensity (today .95); 4 nested triangles (iR×.85 down, .65 up, .45 down, .30 up) gold .4 at .45×intensity; bindu r .022·size accentRed .9 + cream r .009.

### Mode table (canvas section titles/subtitles verbatim)
| # | Mode | Section title | Subtitle | Sub-states (artboard labels) |
|---|---|---|---|---|
| 1 | Darśana | ① Darśana · Beholding | Hold the phone vertical and still · the yantra wakes to your stillness · three depths | "3 seconds in · arriving" / "30 seconds in · bījas appear" / "2 minutes in · pure radiance" |
| 2 | Recognition | ② Recognition · The Catch (refined) | Long-press anywhere · she is named · she felt you back · the mandala remembers | "① Open · waiting for the tap" / "② Caught · she is named" / "③ Reciprocated · her petal glows on the mandala" |
| 3 | Sādhana | ③ Sādhana · The Khaḍgamāla | The 102-name garland · ~28 minutes · ring by ring, inward, to the Bindu · four states | "① Saṅkalpa · setting intention" / "② Station · the current shakti (Ring 2, pos 5)" / "③ Transition · descending from Ring 2 to Ring 3" / "④ Bindu · the culmination" / "⑤ Visarjana · the release & return" |
| 4 | Smṛti | ④ Smṛti · The Constellation of Memory | Every recognition ever made, visible as light · your spiritual fingerprint emerging | "The Full Constellation · all-time" / "One Shakti's Cluster · Sparśākarṣiṇī" / "Time-lapse · 264 days, watching herself emerge" |
| 5 | Mauna | ⑤ Mauna · The Silence (refined) | Pure Bindu · names as orbital stars · captions deepening with time | "7 seconds · All of her, here, always" / "14 seconds · She has not gone anywhere" / "21 seconds · You have not gone anywhere" / "28 seconds · silence" |
| 6 | Svapna | ⑥ Svapna · The Dream | First open of the day · who walked through last night · the deep night is recognized | "① The Question · who walked through" / "② Marking · two shaktis felt in the dream" / "③ Voice · tap to speak" / "④ Recording · 00:42 with transcription" |
| 7 | Pūjā | ⑦ Pūjā · The Evening Offering | After sunset · today's catches witnessed together · offered · released into the Bindu | "① Gathering · the day's catches" / "② Offering · five recognitions, named" / "③ Released · the day received" |
| 8 | Saṅgha | ⑧ Saṅgha · The Assembly | The field is all you · two layers: the 102 as inner sangha · loved ones as outer carriers of her | "Inner Sangha · the 102 as your assembly" / "Outer Sangha · loved ones as carriers" / "Person Detail · how she enters through Ram" |

### M1 · DarsanaScreen (L61–162) — "The yantra wakes to your stillness. Time stretches. Three depths: arriving (3s of stillness) · holding (30s) · entered (2 min)"
| depth | trigger | bg | yantra | intensity | motes | status bar | label opacity | sub-label |
|---|---|---|---|---|---|---|---|---|
| arriving | 3s still | radial 90% 80% #0A0608 → #060104 60% → #030103 | 280 | .85 | 6 | .5 | .55 | "hold still · she wakes" |
| holding | 30s | radial 80% 65% #0D0608 → #030103 70% → #010001 | 320 | 1.0 | 10 | .15 | .25 | "beholding · 30s" |
| entered | 2 min | radial 60% 50% #0F0708 → #020001 70% → #000 | 360 | 1.2 | 14 | 0 | 0 | "∞" |
Bījas (holding+): each Shakti's bīja at r = yantra×.62 around (195,422), 13px italic gold .55, glow 8px, darsanaBijaIn 4s infinite, delay i×.35s. Entered: 540px radiance radial rgba(201,150,63,.18) → rgba(139,26,42,.06) 35%, darsanaRadiance 6s. Label "darśana" 14px italic lowercase .32em gold .7; label transition 2s. Gesture (Codex G5): hold phone vertical & still — no touch.

### M2 · RecognitionScreen (L170–279) — "Now shows the today's-petal pulsing on the visible-behind mandala. Three states: open (waiting for tap) · caught (filled) · reciprocated (she felt you)."
- Mandala behind (MiniYantra 340, todayIdx 4) opacity open .5 / caught .3 / reciprocated .42, intensity 1.4 when reciprocated (1.5s). Reciprocated adds 60px glow at today's petal (−94px) recogPetalGlow 3s.
- Sheet 360h, gradient rgba(4,1,4,.98) → rgba(8,2,6,.94) 65% → .82, top border gold .18, radius 20 20 0 0, padding 32. Name 38px; bīja 22 italic gold .78; catch circle 68px (border .55 open / .75; fill .04 / .12; glow 24px .32 + inset 10px) with 18px gold centre once caught (1.2s). Caption: open "tap to register the moment" / caught "she is named" / reciprocated "and she felt you back" (gold). Footer reciprocated: "LOGGED · 2:41 PM · her 3rd today".
- Gesture (Codex G9): long-press anywhere opens; tap the circle to register.

### M3 · SadhanaScreen (L287–602) — Khaḍgamālā
- Progress counting ring sizes (L299–308): R1 28, R2 16, R3 8, R4 14, R5 10, R6 10, **R7 12**, R8 posInRing, R9 → 102 (28+16+8+14+10+10+12+3+1 = 102). progress% = recited/102. bg radial 80% 70% rgba(20,8,16,.96) → rgba(6,1,4,1); DustMotes 8.
- Saṅkalpa: "SAṄKALPA" eyebrow; **"I begin the garland / not to gain anything, / but to remember / what I have always been."** (30 italic); "One hundred and two names will arrive in sequence. ~28 minutes. Sit upright. Breath low."; button "Begin" (accentRed, r32, shadow 28px .4).
- Station: ring name (AVARANAS[ring−1].name) at top 64; name 46px; bīja 26 italic gold (fallback "hsauṁ"); quality 17 italic (fallback "She of the field"); 9 ring dots (active 8px glow, past .55, future .15); 240×1 progress line; "{n} of 102 · Ring {r}".
- Transition: "DESCENDING"; "You leave the Sixteen-Petal Lotus."; "You enter"; "Sarvasaṅkṣobhaṇa" (36 italic gold glow 18px); "The eight bodiless desires — / where longing arrives without a body."; "tap to continue".
- Bindu: radial rgba(139,26,42,.25); 100px bindu glow 70px 20px .45 + 28px cream core, sadhanaBinduBreath 5s; "Lalitā"; "aiṁ klīṁ sauḥ"; "One hundred and two have been said. / What remains is what was always there."
- Visarjana: "VISARJANA · THE RELEASE"; MiniYantra 140 intensity 1.4 breathing 5s; "What I have received, / I release."; "The garland is offered back / to the one who wove it. / The 102 return to the One."; "tap to close · she remains".
- DATA: SHAKTIS, RING3_SHAKTIS, RING8_SHAKTIS, AVARANAS. Gesture (Codex G4): pinch outward.

### M4 · SmritiScreen (L611–800) — "Every recognition ever made, as light on the yantra."
- genConstellation: per Ring-2 Shakti count embodied 28–45, active 12–19, exploring 4–7, mapped 0–1; points around petal angle at r 150–180 ±7 jitter, angle ±.06 rad; size 1–2.8; opacity .4–.9; 6% "recent" twinkle (1.4s, drop-shadow 4px). bg radial #050309 → #010103. MiniYantra 380 at .25 (.15 cluster) intensity .4.
- Titles: eyebrow "SMṚTI · THE MEMORY"; full "where she has been most alive"; cluster "Sparśākarṣiṇī · 23 catches"; timelapse "264 days · last spring · now".
- Full: "{N} recognitions · 218 days · 12 of 16 known" + filter tabs All time (active, gold underline) / This year / Month / Week. Cluster: other stars .04, hers ×2.3; "last caught — today, 9:14 AM / "morning light on hands"" + "TAP ANY STAR · OPEN HER LOG". Timelapse: 240px scrubber at 72% with 9px gold knob, "DAY 191 OF 264 · WATCHING HERSELF EMERGE".
- Gesture (Codex G3): long-press a ring.

### M5 · MaunaScreen (L808–922) — "Captions arrive at 7s, 14s, 21s, 28s — successively deeper"
- bg #020001 + vignette to rgba(0,0,0,.85); Ring 2 names r158 (11px .14, +.04 at d28; delays .18+i×.20s, 5s fade), Ring 3 names r110 (10px .10; delays .4+i×.22s); orbits r200, r92 at .04; bindu 84px, core 22px, maunaBinduBreath 6s; caption at cy+230 (18 italic, .7; 0 at d28), maunaCaptionIn 7s.
- Captions: d7 "All of her. Here. Always." · d14 "She has not gone anywhere." · d21 "You have not gone anywhere." · d28 "" (silence). Depth indicator "7 seconds in" / "14 seconds in" / "21 seconds in" / "∞".
- Gesture (Codex G2): tap the bindu.

### M6 · SvapnaScreen (L930–1172) — "Morning. Who walked through last night?"
- bg linear #1A1018 → #0A0A18 → #050810; pre-dawn radial top rgba(232,180,140,.20); DustMotes 12; accent peach rgba(232,180,140,…).
- question: "SVAPNA · BEFORE THE DAY"; **"Who walked through / last night?"** (34 italic); buttons "I felt someone" (filled .10, border .5) and "The night was still" (border .25).
- tap: "Svapna" / "Tap who walked through"; MiniYantra 320 at .55; two marked petal glows (30px, svapnaMarkPulse 3s, second delayed 1.5s) — Ātmā and Smṛti; note card "“There was a long room. / Someone called my name from inside it.”"; "2 MARKED · HOLD TO ADD A NOTE".
- voice / voice-active: "SVAPNA · RECORDING" / "tell the dream while it is still here"; 42-bar waveform (3px bars; active heights 12 + |sin(.7i)·cos(.3i)|×80, svapnaWaveform .8–1.52s); mic 76px (active radial .4 + pulse 2.2s); "tap to speak" / "00:42 · recording"; "OR WRITE" text card (placeholder "a few words about what arrived"; active transcription "“There was a long room. Someone called my name from inside it — the voice was familiar but I could not place it...”").
- Trigger (Codex): morning opening, 3 min.

### M7 · PujaScreen (L1180–1359) — "At day's end. The day's catches witnessed. Offered. Released."
- todayCatches: idx 4 7:14 AM "morning light on hands"; idx 1 9:42 AM "an idea I didn't make"; idx 4 11:30 AM ""; idx 9 2:08 PM "gratitude for the door opening"; idx 13 8:55 PM "returning to myself".
- bg linear #0A0508 → #060104 → #030103; sunset glow rgba(199,90,80,.12); eyebrow "PŪJĀ · THE OFFERING" rgba(199,143,90,.7); titles "today's catches" / "five recognitions, this day" / "received". MiniYantra 300 at .5 (.25 released, 2s). Catches as dots (r9 blur + r3, cluster colour, puja-catch 3.5s, delays i×.4s) at r 120/128. Bindu 16px → 48px when released (2.5s, glow 40px 12px .45; core 5 → 16) — "absorbs the catches".
- offering: list rows (dot, time, name) + button "offer the day" (rgba(199,143,90,.15), border .4). released: **"The day is received. / Tomorrow opens again."** + "SLEEP WITH THE FIELD".
- Gesture (Codex G7): swipe down from top, evening only.

### M8 · SanghaScreen (L1384–1668) — "The field is all you. There are no strangers in it. Two layers: INNER — the 102 shaktis as your living community. OUTER — the people you love as carriers of specific shaktis. You are not alone — you are in the company of one hundred and two living forces, and the loved ones who carry them into your life." (NB: Codex's Saṅgha was "other practitioners" — this phase reframes it.)
- BELOVED: Ram carries [13 Ātmā, 0 Buddhi] #7A5A9A "who returns me to myself"; Ashrey [12 Nāma, 11 Bīja] #4A7A5A "who names what is forming"; Gaia [1 Ahaṅ] #D4A017 "who anchors the I-sense"; Mother [10 Dhairya, 9 Citta] #C4725A "the steadying continuous one"; Self [13 Ātmā, 14 Amṛta, 15 Śarīra] #8C7BAA "the witness already here". (Code comments' index→name mapping as given.)
- bg radial #060306 → #010103; eyebrow "SAṄGHA · THE ASSEMBLY" rgba(180,160,200,.6); sub "the inner sangha · 102 forces" / "the outer sangha · loved ones" / "how she enters through him".
- inner: MiniYantra 340 at .65 intensity 1.2; Ring 2 names r192 (10px, alpha .42+status×.35, cluster glow, breathe 5–7s); Ring 3 names r122 (9px gold .55); "One hundred and two living forces. / This is your assembly." + "YOU WALK WITH HER · SHE WALKS WITH YOU".
- outer: MiniYantra 300 at .42; 5 people evenly on r192 (16px hue node, breathe 4s), dashed (2 4) .5 lines to their shaktis at r116; "The people you love / are her wearing human faces." + "TAP A NAME · SEE WHICH SHAKTIS SHE CARRIES".
- person (Ram): his shaktis glow 32px at r130 on yantra; banner name 36 italic, note, "CARRIES", names in gold, "THIS IS HOW SHE ENTERS THROUGH HIM".
- Trigger (Codex): ambient · always on.
## A12. PHASE VI — THE MEMORY LAYER (`The Memory Layer.html` 157 + `memory.jsx` 1139) — SEVEN INSTRUMENTS

Host: title "Phase 6 — The Memory Layer"; canvas "Phase VI · The Memory Layer"; loads shakti-data, all-shaktis-data, design-canvas, screens, memory. CSS: portrait petal breaths — embodied 4.5s (1→1.18), active 6s (1→1.10), exploring 8s (.95→1.04), mapped 11s (.92→.99). NB canvas order puts ⑦ before ⑥.
memory.jsx header (verbatim): "Every recognition leaves a luminous trace. Over time, the yantra becomes a portrait of your consciousness. The instrument starts to mirror you."
DATA model `PRACTITIONER_HISTORY` (L17–30) — "Synthetic practitioner — recognition history per petal. Real version reads from on-device log + Airtable shakti map." Per Ring-2 Shakti: seedMul embodied 1.0 / active .55 / exploring .22 / mapped .04; total = floor(180×seedMul + rand 0–24); firstDayAgo 120–300; lastDayAgo rand < 3 (embodied) / 7 (active) / 30; peakMonth random; **intensity = min(1, total/80)**; plus idx, name, short, status, cluster, colour.

| # | Instrument | Section subtitle (verbatim) | Artboard |
|---|---|---|---|
| ① | The Portrait Mandala | The home yantra, lit by your memory · each petal's brightness is your relationship density with her | "Your Spiritual Fingerprint · 264 days, 1,418 recognitions" |
| ② | The Petal Biography | Tap a petal · open her full story with you · first catch · last catch · the moments she was here | "Sparśākarṣiṇī · biography (Active)" (idx 4); "Ātmākarṣiṇī · biography (Embodied)" (idx 13) |
| ③ | The Threshold Timeline | Moments of crossing · when she moved from mapped → exploring → active → embodied · each crossing a sacred event | "Your Six Crossings · this year" |
| ④ | The Cluster Garden | Five gardens · one per cluster · how thoroughly each lineage has bloomed in you | "The Five Lineages · bloom-meters per cluster" |
| ⑤ | The Density Atlas | Two views · trailing year (day-precision) · lifetime (year-precision) · the practice has no expiration | "Trailing Year · 9 months × 31 days · day precision"; "Lifetime · 5 years × 12 months · the whole arc" |
| ⑥ | First Word · Last Word | The span of each relationship · the day she first arrived · the day she was last present | "Sixteen Relationships · each as a span of time" |
| ⑦ | The Lifetime Spiral (Phase 6.1) | Every year of practice as a concentric ring of the same yantra · the practice has no expiration | "Five years inside the same yantra" |

### MEM-1 · PortraitMandalaScreen (L39–160) — "The home yantra, but lit by YOUR memory … Some blazing. Some still dark. This is the spiritual fingerprint. Your face in the instrument."
- SEES: bg radial #060306 → #020001; DustMotes 9; eyebrow "THE PORTRAIT MANDALA" + "your face in the instrument". Centre (195,432), petal oR 180 iR 110 hw 34. Faint triangles r90↓ 70↑ 50↓ 32↑ at .20. Each petal: blur halo opacity .10 + intensity×.45, blur 4+4×intensity px; main opacity .18 + intensity×.78 with portrait-petal-{status} breath, delay i×.16s; recognition count `total` at r148 (11px italic; cream if intensity > .4 else .30). Bindu r12 accentRed .85 + cream r4.
- WORDS: "1,418 recognitions across 264 days. / Five embodied. Three nearly so." + "TAP ANY PETAL · OPEN HER BIOGRAPHY".
- ARRIVE: (Codex: long-press a ring → Smṛti). LEAVE → biography.

### MEM-2 · PetalBiographyScreen (L168–322) — "First catch · last catch · total · peak month · longest gap · notes archive."
- SEES: bg linear rgba(cluster,.08) → #060104 50% → #050103; "‹ Portrait" back; eyebrow "HER BIOGRAPHY WITH YOU"; name 36; phonetic; 10px cluster dot + cluster label + status pill in cluster colour. Stat grid 2-col: total catches (28px numeral) · first met "Year 2 · 2024" · most recent "today"/"{n}d ago" · peak month "{Mon} Y4" · longest gap "41 days · in Y3" · days walked "1,621 lifetime". Notes "MOMENTS SHE WAS HERE": Today, 9:14 AM "morning light on hands"; Yesterday, 6:48 PM "in the kitchen — the warmth of the cup"; May 22, 11:30 PM (none); May 19, 2:14 PM "her, in the way the air moved across my arm"; May 17, 8:41 PM (none); May 14, 2:33 PM "in the garden — extraordinary".

### MEM-3 · ThresholdTimelineScreen (L352–458) — "Each crossing is a sacred event, rendered with the date and the act that crossed her over."
THRESHOLDS (verbatim):
| date | shakti | colour | from → to | note |
|---|---|---|---|---|
| Feb 14 | Ātmākarṣiṇī | #7A5A9A | exploring → active | sat with her at dawn for the first time. she stayed. |
| Mar 03 | Sparśākarṣiṇī | #C4725A | mapped → exploring | felt her in the way the cup warmed my palms. |
| Mar 28 | Cittākarṣiṇī | #2A7A7A | active → embodied | three weeks of catching her daily. she is now a habit of mind. |
| Apr 14 | Sparśākarṣiṇī | #C4725A | exploring → active | 17 catches in 10 days. she has become weather, not event. |
| May 02 | Dhairyākarṣiṇī | #4A7A5A | mapped → exploring | noticed her standing under criticism without flinching. |
| May 19 | Ātmākarṣiṇī | #7A5A9A | active → embodied | she does not leave anymore. |
SEES: eyebrow "THE THRESHOLD TIMELINE" / "moments of crossing"; spine line .5px gold .18 at left 38; nodes 12px radial in colour + glow 10px + 4px cream core; name 18 italic; from (opacity .55) → to in colour 9px; note 14 italic .62.

### MEM-4 · ClusterGardenScreen (L466–596)
Per cluster card (CLUSTER_INFO): gradient {colour}10 → transparent, border {colour}28, radius 10; 64px mini-fragment with one tiny petal per Shakti (opacity .25 + intensity×.7) + bindu; label 17 italic; "{n} shaktis · {total} catches"; 2px bloom meter width = avg intensity; % numeral 22 italic in colour. Header "THE CLUSTER GARDEN" / "how each lineage has bloomed in you". Footer: "each cluster is a lineage in you. / some have bloomed. others are still seed."

### MEM-5 · DensityAtlasScreen (L604–811) — "Recognition density per day over the past year, rendered as a calendar heat-map of golden light."
- current: rows Sep…May (9 months) × 31 cells 16px tall, gap 2; value = clamp(.35 + seasonal sin + weekly sin + noise). lifetime: rows 2022–2026 × 12 months (cells 24px, gap 4; header Jan…Dec 8px; current year label gold italic); yearBase .25 + y×.12.
- Cell colour: v < .1 → rgba(201,150,63,.04) else rgba(201,150,63, .10 + .85v); glow 4px if v > .65. Toggle "trailing year" | "lifetime" (gold underline active). Legend quiet → dense (5 swatches 12×8).
- WORDS: current "the shape of your practice" / "your rhythm has texture. / read it like a season." / "TAP ANY DAY · SEE ITS CATCHES"; lifetime "the shape of all your years" / "five years walked. / the rhythm has deepened." / "TAP ANY MONTH · ZOOM IN".

### MEM-6 · FirstLastScreen (L819–952)
Rows for Shaktis with total > 0, sorted oldest first; name `short` 11px italic right-aligned (84px); 16px track rgba(242,232,217,.025); span line 1px colour .6 from start% = (max−first)/max to end% = (max−last)/max; start dot 6px .85 glow 4; end dot 1.0 + glow 8 if last < 7 days else .45; total 12 italic. Axis "FIRST MET … TODAY". Header "FIRST WORD · LAST WORD" / "the span of each relationship". Footer "some relationships are old. / some are weeks old. all of them are yours."

### MEM-7 · LifetimeSpiralScreen (L981–1130) — "Year 1 innermost (the beginning). Each subsequent year outward."
- LIFETIME_YEARS: 5 years 2022–2026; recogs 240 + 280y + rand; embodied min(16, 1.2y + rand 2); intensity .35 + .15y; crossings; labels "first year" / "year n" / "this year".
- SEES: bg radial #060306 → #020001; DustMotes 9; bindu r18 accentRed .7 (drop-shadow 18px .7) + cream r6 ("the seed, present from year 0"); rings r = 30 + 24·yi stroke rgba(201,150,63, .10 + .18·intensity); 16 radial marks per ring (±7px, cluster colour, width 1.5, opacity .20 + .65·intensity); year labels at −108° (current year gold). Stats grid: years walked · recognitions · embodied (28px numerals).
- WORDS: "THE LIFETIME SPIRAL" / "every year of practice, layered"; "five years inside the same yantra. / each ring a season of being with her." / "TAP A RING · ENTER THAT YEAR".
## A13. PHASE V — THE TEMPORAL LAYER (`The Temporal Layer.html` 269 + `temporal.jsx` 1068) — SIX INSTRUMENTS + DATA CONTRACT

Host: title "Phase 5 — The Temporal Layer"; canvas "Phase V · The Temporal Layer"; CSS lunarBinduBreath (scale 1→1.18). temporal.jsx header: "The yantra is alive in time. Hour, tithi, nakshatra, moon, season, year. Six instruments: Cosmic Now · Lunar Yantra · Sandhya · Seasonal · Great Wheel · Tithi."
`YantraGlyph` (L16–58) = MiniYantra with tones: warm (tri #C9963F, petals ×1.0), cool (#A4B8CC ×.5), silver (#D4DCE6 ×.35), ember (#C25640 ×.85), bloom (#E8C97A ×1.15).
Constants: NAKSHATRAS (27): Aśvinī, Bharaṇī, Kṛttikā, Rohiṇī, Mṛgaśīrṣā, Ārdrā, Punarvasu, Puṣya, Āśleṣā, Maghā, Pūrva Phalgunī, Uttara Phalgunī, Hasta, Citrā, Svātī, Viśākhā, Anurādhā, Jyeṣṭhā, Mūla, Pūrvāṣāḍhā, Uttarāṣāḍhā, Śravaṇa, Dhaniṣṭhā, Śatabhiṣā, Pūrva Bhādrapadā, Uttara Bhādrapadā, Revatī. TITHIS (15): Pratipada … Caturdaśī, Pūrṇimā.

| # | Instrument | Section subtitle (verbatim) | Artboards |
|---|---|---|---|
| ① | The Cosmic Now | Five concentric wheels · hour · tithi · nakṣatra · season · solar · the practitioner sees, at a glance, where they are inside time itself | "The Cosmic Now · 6:42 PM · Trayodaśī · Anurādhā · Śarad" |
| ② | The Lunar Yantra | The instrument across one lunar cycle · Amāvasyā → Śukla → Pūrṇimā → Kṛṣṇa · the same yantra in four atmospheres | "① Amāvasyā · dark moon · the Bindu rises"; "② Śukla Pakṣa · the moon waxes"; "③ Pūrṇimā · full moon · the yantra is most alive"; "④ Kṛṣṇa Pakṣa · the moon wanes" |
| ③ | The Three Sandhyās · The Twilight Junctions | Sacred hinge moments · the app opens to these by default at dawn, noon, and dusk · each its own micro-practice | "Prātaḥ · the morning junction · Brāhmī"; "Madhyāhna · the noon junction · Vaiṣṇavī"; "Sāyam · the evening junction · Rudrāṇī" |
| ④ | The Seasonal Yantra | The instrument across the four seasons of practice · she breathes differently in each one | Vasanta · spring · the petals begin again; Grīṣma · summer · she is in full sun; Śarad · autumn · she becomes clear; Hemanta · winter · she goes quiet |
| ⑤ | The Great Wheel | 365 days · radially arranged · recognition density as luminosity · navigate years to see your whole arc | "Year 5 · 2026 · this year (1,418 recognitions)"; "Year 3 · 2024 · 814 recognitions"; "Year 1 · 2022 · the beginning (268 recognitions)" |
| ⑥ | Today's Tithi · Her Nitya Form | Each lunar day has a presiding goddess from the canonical 15 Nityā Devīs · names sourced from tradition · qualities flow from Airtable | "Trayodaśī · Sarvamaṅgalā · the 13th Nitya"; "Pratipadā · Kāmeśvarī · the 1st Nitya"; "Pūrṇimā · Citrā · the 15th Nitya" |
| ◇ | Data & Time Contracts | Decisions that bind the visual layer to the live world · these flow into the codex | "Architecture · what comes from where" |

### TMP-1 · CosmicNowScreen (L80–238) — "A dashboard of your temporal location. Five concentric wheels turning at different rates"
Sample now: timeOfDay "Sandhya · evening twilight", timeAngle 280 (~6:30pm, 270 = sunset), tithi Trayodaśī, tithiNum 12 (NB: Trayodaśī is the 13th — inconsistency), nakshatra Anurādhā #16, moon Waxing Gibbous .78, season Śarad, seasonAngle 245, solar Vṛścika · Scorpio, Śukla.
| wheel | r | ticks | value | angle | dot |
|---|---|---|---|---|---|
| hour | 158 | 24 | 6:42 PM | 280 | #C9963F |
| tithi | 130 | 15 | Trayodaśī | 12×24 = 288 | #E8C97A |
| nakṣatra | 102 | 27 | Anurādhā | 16×360/27 | #D4A067 |
| season | 74 | 6 | Śarad | 245 | #D4A017 |
| sūrya | 48 | 12 | Vṛścika | 210 | #C45050 |
Rings stroke rgba(201,150,63,.25) .5; ticks ±2 .22 .3; radial line to dot (.4, .18); dot r4.5 drop-shadow 6px + cream r1.5. Centre (195,422) bindu r14 `<animate r 13;16;13 5s>` drop-shadow 18px + cream r5. "pure geometry, no embedded text". Legend grid (bottom 220): dot · label (10px upper) · value (15 italic). Bottom: "THIS MOMENT" (rgba(212,160,103,.7)); "Sandhyā · the evening junction. / Anurādhā watches the moon waxing."; "ŚUKLA PAKṢA · DAY 13 · MOON 78% FULL". Header "THE COSMIC NOW" / "where you are, inside time". bg radial #0A0608 → #020001; DustMotes 8.

### TMP-2 · LunarYantraScreen (L247–413) — "New (Bindu rises) → Waxing (rings build) → Full (entire mandala blooms) → Waning (releasing back to seed)."
| phase | label | poetry | meta | bg | yantra intensity / tone | bindu | moon glyph | motes |
|---|---|---|---|---|---|---|---|---|
| new | Amāvasyā · the dark moon | when the moon is hidden, / the Bindu rises. | sit with the seed | radial 60% 50% rgba(139,26,42,.18) → #010001 70% | .25 / cool | 90px overlay (radial accentRed, glow 64px 20px .45, cream core 24px, lunarBinduBreath 6s) | 6px crimson dot | 4 |
| waxing | Śukla Pakṣa · the moon waxes | the petals open / from the inside out. | the bright half · ring 3 brightening | radial 70% 55% rgba(232,201,122,.10) → #050308 | .75 / warm | 28 | right half lit | 8 |
| full | Pūrṇimā · the full moon | every petal in bloom. / all 16, all at once. | the yantra is most alive | radial 80% 65% rgba(242,232,217,.10) → rgba(201,150,63,.06) 35% → #060306 | 1.35 / bloom | 22 | full disc .55 glow 14px | 14 |
| waning | Kṛṣṇa Pakṣa · the moon wanes | the petals fold inward. / she returns to seed. | the dark half · the integration | radial 65% 55% rgba(140,160,200,.06) → #030308 | .55 / silver | 38 | left half rgba(140,160,200,.5) | 8 |
Yantra 300 (−20px). Phase strip "new / waxing / full / waning" (current gold "· x ·").

### TMP-3 · SandhyaScreen (L422–568) — "Three twilight junctions. Each is a sacred hinge moment … Each is its own micro-practice, opened by the time-of-day."
| which | label | time | sky gradient | glow | Shakti | note | invitation | practice | tone |
|---|---|---|---|---|---|---|---|---|---|
| pratah | Prātaḥ Sandhyā · the morning junction | 5:42 AM | #0F0610 → #200818 25% → #481020 55% → #88381F 85% → #C66832 | 100% 60% at 50% 100% rgba(232,180,140,.45) | Brāhmī | she who breathes the first breath of the world | Open the eyes / before the world opens them for you. | three breaths · facing east | warm |
| madhyahna | Madhyāhna Sandhyā · the noon junction | 12:14 PM | #FFE4A0 → #FFCB6A 30% → #E8A040 70% → #B66828 | 100% 80% at 50% 30% rgba(255,230,168,.55) | Vaiṣṇavī | she who pervades the high light without shadow | The sun has nothing to hide. / Neither do you. | one minute · still upright | noon (bloom) |
| sayam | Sāyam Sandhyā · the evening junction | 6:42 PM | #060104 → #1A081C 30% → #501020 60% → #8A2828 82% → #C44030 | 100% 70% at 50% 100% rgba(196,64,48,.50) | Rudrāṇī | she who closes the day, who holds the threshold | What you carried today / you may set down here. | three breaths · facing west | ember |
Layout: "SANDHYĀ · THE JUNCTION", label, time; Shakti name 56px italic (cream glow 28px; noon brown rgba(80,40,15,.92)); note 16 italic; YantraGlyph 160 at top 400 (.5; noon .35); invitation 22 italic; button "begin sandhyā"; practice line. Noon screen is the ONLY light-ground screen (dark-brown text rgba(40–80,…)). HomeIndicator light except noon.

### TMP-4 · SeasonalYantraScreen (L576–686)
| season | label | sub | bg | glow | poetry | tone | intensity | motes |
|---|---|---|---|---|---|---|---|---|
| vasanta | Vasanta · spring | when the petals begin again | #0A0F08 → #060A06 | rgba(180,201,122,.10) | after the long silence, / the field begins to remember itself. | bloom | .95 | 8 |
| grishma | Grīṣma · summer | when she is in full sun | #1A0908 → #0A0306 | ellipse 80% 70% at 50% 40% rgba(232,150,80,.18) | the heat is her presence. / the brightness is her presence. | warm | 1.3 | 14 |
| sharad | Śarad · autumn | when she becomes clear | #08060A → #050308 | rgba(212,160,103,.14) | the sky is cool. the air is exact. / she shows herself without ornament. | warm | 1.0 | 8 |
| hemanta | Hemanta · winter | when she goes quiet | #050810 → #020308 | rgba(140,160,200,.10) | she is in the seed now. / you keep her warm inside you. | cool | .65 | 4 |
YantraGlyph 320 todayIdx 4; header "THE SEASONAL YANTRA"; season strip.

### TMP-5 · GreatWheelScreen (L696–913) — "365 days arranged radially. Each day's recognition density as luminosity. Moon phase as small dots on the outer ring. Seasonal sectors lightly shaded."
- yearMul Y1 .30, Y2 .55, Y3 .80, Y4 1.0, Y5 1.15; totals Y1 268, Y2 542, Y3 814, Y4 1,102, Y5 1,418. Centre (195,432). Season sectors to r165: Vasanta 0–90° rgba(180,201,122,.04), Grīṣma 90–180 rgba(232,150,80,.05), Śarad 180–270 rgba(212,160,103,.04), Hemanta 270–360 rgba(140,160,200,.04); labels at r195. Daily rays r56 → 56+90v, width .7, colour v>.7 #E8C97A / >.45 #C9963F / >.2 gold .5 / else .15, opacity .4+.6v. 13 moon dots r168 r1.5. Centre ring r38 + bindu r9 + cream r3. Today (day 264) ring r5 gold + line.
- Year navigator 2022–2026 dots (current 7px glow). Titles "THE GREAT WHEEL" / "your year, all at once" or "year n · yyyy". Bottom (current): "264 days walked. / 1,418 recognitions. / 3 quiet weeks in Hemanta." + "TAP ANY DAY · OPEN ITS CATCHES"; past: "{n} recognitions. / year {k} of your practice." + **"SWIPE ← → · NAVIGATE YEARS"**.

### TMP-6 · TithiTodayScreen (L922–1061) — "Names canonical (sourced from Śrīvidyā tradition · stored in shakti-data). Quality + bīja + dhyāna fields flow from Airtable. No invented content."
- DATA: NITYA_DEVIS (tithi, tithiName, name, quality?) from shakti-data.js. illum = (tithi − .5)/14.5; moon 80px with clip rect from x = 6 + (1−illum)×68.
- WORDS: "TODAY'S TITHI · HER NITYA FORM"; tithiName 38 italic; "TITHI {n} OF 15 · BRIGHT FORTNIGHT"; "SHE WEARS TODAY THE FORM OF"; Nitya name 46 italic gold glow 26px; "{n} OF THE FIFTEEN NITYĀ DEVĪS"; quality (19 italic) or placeholder pill "HER QUALITY FLOWS FROM AIRTABLE" + "quality · bīja · dhyāna / render here when the database is connected".

### TMP-◇ · Data & Time Contracts — "The Living Architecture" / "What flows from where." (verbatim)
- **Device**: local time — for every screen, every breath · location (with permission) — for sun-relative sandhyās, hemisphere-aware seasons · fallback: home location set during initiation.
- **Ephemeris**: tithi · nakṣatra · moon phase · solar position · same on the whole earth at the same moment · computed from device-UTC + astronomical tables.
- **Airtable**: 102 Khaḍgamāla Shaktis — name, bīja, quality, somatic, lineage · 15 Nityā Devīs — quality, bīja, dhyāna for each tithi · 9 Avaraṇas — form, presiding goddess, chakra, geometry · *all sacred content. no invention. the app renders only.*
- **Practitioner**: recognition log — every catch, time-stamped, on-device · dream entries (Svapna) — voice + text · beloved-ones map (outer Saṅgha) · tweaks, preferences, the home location.
- Footer: "Every ring-world, lunar phase, seasonal yantra, and sandhyā *is the live home under a different sky.* All petals stay interactive. All gestures still work. Time and atmosphere modulate the visual — they do not remove the instrument."
## A14. PHASE VII — THE RELATIONSHIP FIELD (`The Relationship Field.html` 132 + `relationship.jsx` 994) — SIX INSTRUMENTS

Host: title "Phase 7 — The Relationship Field"; canvas "Phase VII · The Relationship Field"; CSS cursorBlink (.85↔0). Header (verbatim): "The outer Saṅgha given its own world. The people you love are her wearing human faces. The work of recognition is the work of love."
DATA `FIELD` ("In production this flows from on-device profile data"):
| name | carries (Ring-2 idx) | hue | role | note | meta | encounters | peakShakti | last |
|---|---|---|---|---|---|---|---|---|
| Ram | 13, 0 | #7A5A9A | beloved · life partner | who returns me to myself | present · 12 years | 1284 | 13 | today, 10:14 AM |
| Ashrey | 12, 11 | #4A7A5A | son | who names what is forming | present · 6 years | 718 | 12 | today, 8:32 AM |
| Gaia | 1 | #D4A017 | daughter | who anchors the I-sense | present · 4 years | 612 | 1 | today, 8:32 AM |
| Ma | 10, 9 | #C4725A | mother | the steadying continuous one | lifelong | 1042 | 10 | 2 days ago |
| Papa | 3, 6 | #C45040 | father | who taught the discipline of seeing | lifelong | 681 | 6 | 5 days ago |
| Nilima | 14, 7 | #8C7BAA | sister | who remembers what I forget | lifelong | 412 | 14 | 11 days ago |
(Note: modes.jsx BELOVED had Mother/Self; here Ma/Papa/Nilima and no Self.)

| # | Instrument | Section subtitle (verbatim) | Artboards |
|---|---|---|---|
| ① | The Relationship Field | Your yantra at center · beloved arranged around it as luminous nodes · each connected to the shaktis they carry | "Six souls in your field · the constellation" |
| ② | The Person Page | Tap a beloved · their shaktis named · encounters logged · how she enters through them | "Ram · life partner · carries Ātmā + Buddhi"; "Ashrey · son · carries Nāma + Bīja"; "Gaia · daughter · carries Ahaṅ" |
| ③ | The Shakti's Carriers | Reverse lookup · tap any shakti · see which people in your life carry her | "Ātmākarṣiṇī · carried by Ram, Self"; "Nāmākarṣiṇī · carried by Ashrey" |
| ④ | The Encounter Log | When you were with whom · which shaktis arose · the crossing of love and recognition | "Recent encounters · today and back" |
| ⑤ | The Field Web | The whole constellation with cross-threads · where one carries her, another may too | "Shared currents · the web between souls" |
| ⑥ | Adding a Beloved · The Ritual | Not a contacts list · a sacred recognition · four steps to bring a soul into the field | "① Naming · by what name"; "② Shaktis · how she enters through them"; "③ Note · who is she to you"; "④ Arriving · she enters the field" |

### REL-1 · RelationshipFieldScreen (L63–199)
- SEES: bg radial #060306 → #010103; DustMotes 10; eyebrow "THE RELATIONSHIP FIELD" / "she wears their faces · they carry her in". Centre (195,432): small home yantra petals (88/70/14) cluster colours at .30, ring r92 .10, bindu r6 + cream r2. People on r200 evenly (from top); 16px hue node glow 12px 3px; names 14 italic (label above when node in upper half: marginTop −36). Dashed (2 4) .5 hue threads at .40 to carried petal positions at r80 + blurred r6 highlight.
- WORDS: "six souls in your field. / each one a carrier of her." + "TAP A NAME · ENTER THEIR PAGE · HOLD TO ADD A SOUL" (gesture: hold = add).

### REL-2 · PersonPageScreen (L207–347)
bg linear {hue}18 → #060104 50% → #050103; "‹ Field" in hue; 56px hue orb glow 32px 6px; name 46 italic; role 10px .28em; note 17 italic. "SHE ENTERS THROUGH THEM AS": rows (10px cluster dot, name 19 italic, quality 13 italic .50; first gets "PRIMARY" pill). Stats 2×2: encounters · in field (meta) · last met · most alive (SHAKTIS[peak].short).

### REL-3 · ShaktiCarriersScreen (L354–476)
bg linear {cluster}0F → …; "‹ Portrait" (connects to Memory Portrait); "WHO CARRIES HER INTO YOUR LIFE"; name 38; bīja 24 italic in cluster colour glow 16px; quality 16 italic. Count line: "no carriers yet" / "one soul carries her" / "{n} souls carry her". Empty state (dashed card): "no one yet carries her into your life. / watch · she may arrive through someone soon." Rows: 18px hue orb, name 20 italic, note, role first word.

### REL-4 · EncounterLogScreen (L499–605) — ENCOUNTERS (verbatim)
| date | person | shaktis | context |
|---|---|---|---|
| Today, 10:14 AM | Ram | 13, 0 | morning chai. he was reading. I was watching. |
| Today, 8:32 AM | Ashrey | 12 | he named the tree outside · Sapodilla, he said. |
| Today, 8:32 AM | Gaia | 1 | she said: "Mama, look! ME!" |
| Yesterday, 7pm | Ram | 13, 9 | dinner. silence between sentences. |
| 2 days ago | Ma | 10, 9 | phone call · she asked how I was sleeping. |
| 3 days ago | Ashrey | 12, 11 | bedtime story · he finished my sentence. |
Header "THE ENCOUNTER LOG" / "when she crossed between you". Rows: 10px hue node, name 18 italic + date 9px, shakti chips (5px dot + short 12 italic in cluster colour), context 13.5 italic .58.

### REL-5 · FieldWebScreen (L613–752)
People on r168; for every pair sharing a carried Shakti a quadratic thread bending 35% toward centre, stroke = cluster colour of first shared Shakti, .7 @ .40. Nodes: blur halo r20 .18 + r9 hue + cream r3. Centre: circles r70 (.12), r42 (.10), bindu r8 + r3. Labels 13 italic (above −28 / below +22). WORDS: "{n} shared currents. / where one carries her, another may too." + "TAP A THREAD · SEE WHICH SHAKTI RUNS THROUGH". Header "THE FIELD WEB" / "the threads between them". **With the shipped FIELD data no two people share a carried index (Ram 13,0 · Ashrey 12,11 · Gaia 1 · Ma 10,9 · Papa 3,6 · Nilima 14,7), so the screen as written draws zero threads and reads "0 shared currents."** (The Encounter Log does pair Ram with 9, but carries[] does not.)

### REL-6 · AddBelovedScreen — The Ritual (L760–986): "Not a 'contacts list' — a sacred recognition: 'this person carries her in.'"
bg linear #0A0610 → #060104 60% → #040103; "‹ Field"; 4 progress dots (current gold 6px glow). Eyebrow per state: naming "A SOUL ARRIVES IN YOUR FIELD" / selecting "HOW DOES SHE ENTER THROUGH THEM" / note "WHO THEY ARE TO YOU" / arriving "RECEIVED".
1. naming: "By what name / do you know them?" (26 italic); input "Nilima" + blinking cursor (1.1s steps 2); "THE NAME YOU CALL THEM".
2. selecting-shaktis: "What does she become / when she comes through them?"; 240px lotus (100/70/18) with idx 14 & 7 selected (.95 + drop-shadow 10px) others .18; "two chosen · Amṛtākarṣiṇī · Rūpākarṣiṇī"; "TAP PETALS · TWO OR THREE IS ENOUGH".
3. note: "In one breath: / who is she, to you?"; card "who remembers what I forget".
4. arriving: 36px orb #8C7BAA glow 36px 10px; "Nilima" 42 italic; note; hairline; **"she is now in your field. / she will arrive in the yantra / each time you meet."**
## A15. TOOLING (not app experiences — recorded so nobody mistakes them for design)

### TL-1 · design-canvas.jsx (966 lines) — the presentation canvas every Phase file is hosted in
- "Figma-ish design canvas wrapper. Warm gray grid bg + Sections + Artboards + PostIt notes. Artboards are reorderable (grip-drag), deletable, labels/titles are inline-editable, and any artboard can be opened in a fullscreen focus overlay (←/→/Esc). State persists to a .design-canvas.state.json sidecar via the host bridge."
- Canvas chrome: bg #f0eee9, 120px grid rgba(0,0,0,.06), accent #c96442; section title 28px 600, subtitle 16px; artboard label 15px 500; card radius 2 shadow 0 1px 3px .08 + 0 4px 16px .06; focus overlay rgba(24,20,16,.6) blur 14px with ←/→ within section, ↑/↓ across sections, dots, section dropdown; per-artboard menu "Download PNG" (3× via foreignObject) / "Download HTML" / two-click "Delete". Pan/zoom: trackpad pinch/ctrl-wheel zoom (exp(−dy·.01)), notched wheel step exp(±.18), two-finger scroll pan, middle-drag/background drag pan; scale 0.1–8; viewport persisted in localStorage `dc-viewport:{path}`; postMessage `__dc_zoom`/`__dc_present`/`__dc_set_zoom`/`__dc_probe`.
- **IMPORTANT finding:** `DesignCanvas({ children, minScale, maxScale, style })` ignores the `background` and `title` props every host passes (e.g. `background="#060104" title="Phase II · The Home Mandala"`). Those canvas titles never render; the canvas is always warm-gray. Home Mandala.html's comment "header lives in DesignCanvas title" is therefore false in practice. The phase names survive only in source.
- DCPostIt exists (#fef4a8, Comic Sans) but no assigned host uses it.
- Used by: Home Mandala, Mandala App, Mandala App v2, Mandala Legend, Ring Worlds, Ring Worlds II, The Eight Modes, The Temporal Layer, The Memory Layer, The Relationship Field. (Not by Codex.html or Mandala Veil.html — Veil uses its own scaled #stage.)

### TL-2 · doc-page.js (325 lines) — "omelette starter scaffold"
`<doc-page>` custom element: paged-document shell for printable HTML (sizes letter/a4/legal, orientation, width/height, margin default 0.75in; header/footer slots repeated in print via thead/tfoot spacers; injects `@page{size;margin:0}`, break hygiene, text-wrap balance/pretty, `meta[name=omelette-owns-print]`; desk bg #ece8dd, sheet #fff). **Not used by any file in my assignment**; within the upload only `Bindu Mandala - Audit II.html` loads it. No app content.

---

## B. THE DESIGN'S STATED INTENTIONS (verbatim)

### B1. Codex.html — the opening and the reframe (L460, L465, L477–482)
> "This is not an app. It is a temple compressed into glass — a living yantra you carry, breathe with, return to. Every interaction is a moment of recognition: of her, in her many forms, present in the texture of your day. The interface is not a wrapper around the practice. The interface is the practice."

> "A codex — the architectural manual of the system before any screen is designed. It establishes the ontology so the design has somewhere to stand. Five dimensions. Eight modes. No menu. Nine ring-worlds, each with its own atmosphere. The home as a living state, not a screen. A phased path that lets the instrument emerge slowly, with care."

> **§ I · The Reframe — "The yantra is the ontology."** "A content app has tabs because its world is flat — items arranged in categories, each a peer to the next. A consciousness instrument cannot be flat. The structure of awareness is not peer; it is centered. Everything radiates from a center. So this app radiates from the yantra."
> "The Sri Yantra is not a feature inside the app. It is the world the app lives inside. It has presence, mood, time, depth, memory, and relationship. It is not the same yantra at dawn and dusk. It is not the same yantra after a hundred recognitions and zero. It is alive."
> "Which means the architecture is not a list of screens. The architecture is the set of dimensions through which you relate to the yantra. There are five of them."

### B2. Codex.html — the navigation philosophy (§ III close, § IV)
> "The mode is read from the moment. The moment determines the mode. There is no menu to choose from — only the gesture that fits."
> **"There is no menu."** "The yantra is the navigation. Every move is a movement of attention — inward, outward, around. Nine gestures form the entire grammar."
> Tap a ring — descend — "Enter that avaraṇa's world. The ring expands; the others fall away." · Tap the bindu — silence — "Mauna. The undifferentiated point. All names gone." · Long-press a ring — remember — "Smṛti. The constellation of every recognition you've made in this ring." · Pinch outward — recite — "Sādhana. The Khaḍgamāla begins. All 102 names, sequential." · Hold vertical, still — behold — "Darśana. The phone becomes a window. No interaction needed." · Swipe up from edge — today's pull — "Today's shakti rises. Her name, her bīja, her somatic prompt." · Swipe down from top — offer — "Pūjā. Evening only. The catches of the day are offered." · Two-finger hold — invoke — "Bring a specific shakti into live presence. Bīja-tone plays. She is here." · Long-press anywhere — catch — "Freeze the moment. Recognition. The shakti you just felt is logged."

### B3. Codex.html — the nine worlds (§ V)
> "Nine worlds, nine atmospheres." "Each avaraṇa is not a sub-page. It is its own world — with its own geometry, light, breath rate, sound, and gravity. A practitioner who has entered Ring 4 knows it by feel."
(Each ring's role and body text is quoted verbatim in A1 · CX-06.) Ring 9: "There is nothing else. The whole screen is the point. This is not a destination — it is what the practice is made of. Every other ring is breathing outward from here. Entering Ring 9 is not arriving; it is realizing you have not left."

### B4. Codex.html — home, path, closing
> "The yantra is alive with time." "The home you return to at dawn is not the home you find at dusk. The yantra answers to the hour, the moon, the season, and your own recent practice." · "And one petal — today's pull — always glows a little warmer than the rest. You will learn to see her without a label."
> "Eight phases. We build slowly." "An instrument like this is not designed in a sprint. Each phase is reviewed and felt into before the next is begun. The yantra emerges at the pace of recognition itself." · "The remaining six ring-worlds (Rings 1, 3, 4, 5, 6, 9) we build as you approach them in practice."
> "This is not a product to ship. It is an instrument to live with. The work of the next eight phases is to make sure each interaction is worthy of the recognition it is asking for."

### B5. Home Mandala.html — "The Reframe — What Changed" ("v2 was a diagram. v3 is the yantra itself.")
> "The Home is not a screen. It is a presence you return to." Removed → kept: No tab bar → The yantra is the navigation · No labels on the mandala → Geometry is the language · No "Today" headline → One petal glows warmer · you learn to see her · No legend, no avaraṇa name → You know where you are by feel · No interaction hints → Initiation teaches gestures · home stays pure · No fixed atmosphere → Five temporal states · the yantra reads time.
> "The yantra you encounter at dawn is not the yantra you encounter at dusk. The same nine rings, the same 102 forces — but the light is different, the breath is different, the Bindu sits differently. Time is felt, not displayed."
> "When you look at the mandala for ten seconds, your eye begins to read the rhythms. The home ring is alive. The ground is still. The Bindu pulses at the speed of a slow heart."
> home-mandala.jsx: "No labels. No tabs. No buttons. Just the yantra breathing in its current temporal state." · TemporalMark: "Almost imperceptible. Just enough that the practitioner who looks for it knows what time the yantra is reading. Never has text."

### B6. Mandala Legend.html — "The Design Question" (L104–125)
> "How does a Legend feel sacred, not functional?" "The yantra stays a beautiful, non-interactive presence. Navigation into the nine Avaraṇas happens through a Legend — each entry a doorway, not a list item."
> 1 · **Descent, not a menu** — "The yantra is read outside-in: world-square → lotuses → triangles → Bindu. The Legend echoes that — Ring I at the top, descending to the Bindu. Rings you haven't reached are deeper in, not "disabled.""
> 2 · **Light, never locks** — "A padlock is the most secular thing we could put on a sacred object. Status is luminosity: home is fully lit, open rings glow, the ground is warm, rings ahead are veiled behind a scrim with a dashed, uncrossed threshold-line."
> 3 · **The yantra goes quiet** — "In every option the yantra becomes a held image. Only the Bindu and the Ring 2 petals keep a breath of life — your two intuitive affordances. The Legend carries all navigation."
> "Four placements to react to — they are not mutually exclusive. The list, the veil, the chambers, and the spine each answer "where does it live?" differently. Mix freely."

### B7. veil-mandala.jsx — the chosen placement (quoted in full in A5 · "Design's stated intention")
> "Resting: the yantra is a held image. Bindu breathes; Ring 2 petals live. A faint peek at the bottom whispers "there is more below." … status is light, never locks — no labels, no padlocks … open ring → Ring World … locked / deep_ghost ring → Threshold ceremony."

### B8. Ring-world headers
> ring-worlds.jsx: "Three worlds, three atmospheres, three vocabularies." · ring-worlds-2.jsx: "The rings that were deferred, each finding its own experiential form." "The ground does not breathe. It holds. A low Mūlādhāra drone, four gates where the world enters, and 28 lights you have walked among without knowing." · ring-worlds-3.jsx: "Rings 3, 4, 5, 6 — each finding its own verb." · ring-nine.jsx: "The point that contains all points. The ring that is not a ring. Two directions toward the monumental."
> mandala-v2.jsx: "Nine rings. Nine metabolisms. The ground does not breathe — it holds. The center never stopped calling. Everything between is alive."

### B9. Layer headers
> modes.jsx: "Each mode is its own atmosphere. Not a feature, a practice." · Saṅgha: "The field is all you. There are no strangers in it … You are not alone — you are in the company of one hundred and two living forces, and the loved ones who carry them into your life."
> memory.jsx: "Every recognition leaves a luminous trace. Over time, the yantra becomes a portrait of your consciousness. The instrument starts to mirror you." Portrait: "This is the spiritual fingerprint. Your face in the instrument."
> temporal.jsx: "The yantra is alive in time. Hour, tithi, nakshatra, moon, season, year." Tithi: "Names canonical (sourced from Śrīvidyā tradition · stored in shakti-data). Quality + bīja + dhyāna fields flow from Airtable. No invented content."
> The Temporal Layer.html — contract footer: "Every ring-world, lunar phase, seasonal yantra, and sandhyā is the live home under a different sky. All petals stay interactive. All gestures still work. Time and atmosphere modulate the visual — they do not remove the instrument." Airtable line: "all sacred content. no invention. the app renders only."
> relationship.jsx: "The outer Saṅgha given its own world. The people you love are her wearing human faces. The work of recognition is the work of love." Add a Beloved: "Not a 'contacts list' — a sacred recognition: 'this person carries her in.'"

---

## C. COVERAGE PROOF

Method: `wc -l` for totals; each file opened with the Read tool from line 1 to its last line (files over ~560 lines read in consecutive non-overlapping ranges whose ends are listed). No file had a line > 400 chars, so no scratch pretty-printing was needed. `cmp` shows every file that exists in repo `Claude Designs/` is byte-identical to the upload; `Mandala Legend.html`, `legend-explorations.jsx` and `doc-page.js` exist only in the upload. No other copies of these names exist in sub-folders of the upload (only unrelated `design_handoff_living_rite/prototype/living-rite-mandala.jsx` and `handoff/homes-memory.js`).

| File | Total lines (wc -l) | Lines read | Read ranges | Repo `Claude Designs/` copy | Notes |
|---|---|---|---|---|---|
| Codex.html | 1149 | 1149 | 1–1149 | identical | ontology doc, no JS |
| Home Mandala.html | 322 | 322 | 1–322 | identical | |
| home-mandala.jsx | 352 | 352 | 1–352 | identical | top level (no search needed) |
| Mandala App.html | 176 | 176 | 1–176 | identical | |
| Mandala App v2.html | 328 | 328 | 1–328 | identical | |
| screens.jsx | 1161 | 1161 | 1–1161 | identical | |
| screens-v2.jsx | 872 | 872 | 1–872 | identical | |
| mandala-v2.jsx | 309 | 309 | 1–309 | identical | |
| Mandala Veil.html | 138 | 138 | 1–138 | identical | |
| veil-mandala.jsx | 322 | 322 | 1–322 | identical | |
| Mandala Legend.html | 163 | 163 | 1–163 | **absent** | upload only |
| legend-explorations.jsx | 453 | 453 | 1–453 | **absent** | upload only |
| Ring Worlds.html | 190 | 190 | 1–190 | identical | |
| Ring Worlds II.html | 222 | 222 | 1–222 | identical | |
| ring-worlds.jsx | 974 | 974 | 1–974 | identical | |
| ring-worlds-2.jsx | 538 | 538 | 1–538 | identical | Ring 1 only |
| ring-worlds-3.jsx | 642 | 642 | 1–642 | identical | Rings 3–6 |
| ring-nine.jsx | 582 | 582 | 1–582 | identical | Ring 9 |
| The Eight Modes.html | 288 | 288 | 1–288 | identical | |
| modes.jsx | 1675 | 1675 | 1–560, 561–1120, 1121–1675 | identical | |
| The Memory Layer.html | 157 | 157 | 1–157 | identical | |
| memory.jsx | 1139 | 1139 | 1–580, 581–1139 | identical | |
| The Temporal Layer.html | 269 | 269 | 1–269 | identical | |
| temporal.jsx | 1068 | 1068 | 1–540, 541–1068 | identical | |
| The Relationship Field.html | 132 | 132 | 1–132 | identical | |
| relationship.jsx | 994 | 994 | 1–500, 501–994 | identical | |
| design-canvas.jsx | 966 | 966 | 1–500, 501–966 | identical | tooling |
| doc-page.js | 325 | 325 | 1–325 | **absent** | tooling, unused by assigned files |
| **TOTAL (28 files)** | **15,906** | **15,906** | | 25 identical · 3 upload-only | |

Not in my assignment but referenced as globals (read by other readers): `shakti-data.js` (SHAKTIS, CLUSTER_INFO, STATUS_OPACITY, COLORS, TODAY_SHAKTI, TODAY_INDEX, PROGRESS, NITYA_DEVIS), `all-shaktis-data.js` (AVARANAS, RING1/3/4/5/6/7/8_SHAKTIS).

---

## D. MUST NOT MISS (how the pieces connect)

1. **There are two competing navigation philosophies and the later one is the handoff.** Codex: "There is no menu. The yantra is the navigation" (nine gestures on the yantra). Legend → Veil: "The yantra stays a beautiful, non-interactive presence … The Legend carries all navigation" — and veil-mandala.jsx is labelled "FULL-FIDELITY INTERACTION — design handoff to Claude Code". A build must reconcile them (e.g. Veil for descent + Codex gestures for modes), not drop one silently.
2. **The Veil's numbers are exact and buildable:** sheet 720, peek 108, closed offset 612, tap < 6px, snap-open threshold 42% (offset < 257), "open" flag < 306, transition .52s cubic-bezier(.22,1,.36,1), yantra dim 1.0 → 0.5, backdrop tap closes, Esc/back hotspot returns.
3. **Status is light, never locks:** the LUM/TIER tables (home .95 + gold wash, unlocked .85, ancient .60 amber #CF9443, locked .30 dashed, deep_ghost .18 dashed) are the whole status language; Roman numerals I–IX are the only ornament; Ring IX is a footer, not a row.
4. **Routing from the Veil:** only Ring II (open) goes into a world (RingTwoWorld); everything else (even open Rings 1/3) goes to AvaranaThresholdScreen. Rings 1, 3–9 worlds exist (Phase III·b) but are not yet wired into the Veil — that wiring is the missing join.
5. **Each world has its own verb, not its own screen:** R1 meet/illumine/ignite, R2 press-to-invoke, R3 stillness gathers, R4 transmission travels, R5 overflow, R6 nearness reveals, R7 sound to heal (≥7 of 12), R8 collapse then dissolve, R9 hold to fall (recognition at 6.5–8.7s). Every world has a lower-left sound toggle with an exact Web-Audio recipe.
6. **Ring 9 direction B (Praveśa) was chosen**; Spanda is kept as "the other direction we explored".
7. **The breath ladder is one system across files:** none/3/8/9/11/13/15/18 (+ Bindu 4s), reused by Codex, Home table, v2 lock CSS and Home triangle animations (9–18s). Ring 2 per-status breaths: today 3–3.5s, embodied 3.5–4.5s, active 5–6s, exploring 7–8s, mapped 10–11s.
8. **The Home has five temporal states with an exact token table** (dawn/noon/dusk/night/newmoon: bg, ambient, saturation, brightness, petal opacity, triangle stroke, bindu colour & scale up to 1.6×, mote count). New Moon = "the Bindu rises". Today's petal glows warmer with no label.
9. **Time opens modes and layers:** first open → Svapna; dawn/noon/dusk → Sandhyās "by default"; after sunset → Pūjā; lunar phase changes the whole yantra (Amāvasyā bindu 90px). The contract: "is the live home under a different sky … they do not remove the instrument."
10. **Recognition is the spine that feeds every layer:** the Catch (long-press, "and she felt you back" ~1.5s later, logged) → Smṛti constellation → Portrait Mandala intensity (min(1, total/80)) → Threshold crossings (mapped → exploring → active → embodied) → Density Atlas / Great Wheel / Lifetime Spiral → Pūjā offers the day's catches into the Bindu → Encounter Log links catches to people.
11. **The Data & Time Contract is the governance line:** Device (time, location, fallback home location from initiation) · Ephemeris (tithi, nakṣatra, moon, sun from UTC) · Airtable (102 Shaktis, 15 Nityā Devīs, 9 Avaraṇas — "no invention. the app renders only.") · Practitioner (recognition log on-device, Svapna voice+text, beloved map, preferences).
12. **The Khaḍgamālā count is 102 only with Ring 7 = 12** (28+16+8+14+10+10+12+3+1); Codex's "8 Vāk-devatās" contradicts this; the built Ring 7 world has 12 named syllables with frequencies.
13. **Saṅgha changed meaning:** Codex "other practitioners walking the same yantra"; Phase IV/VII "inner sangha = the 102; outer = loved ones who carry her". The Relationship Field is "the outer Saṅgha given its own world".
14. **People data differs between files:** modes BELOVED = Ram, Ashrey, Gaia, Mother, Self; relationship FIELD = Ram, Ashrey, Gaia, Ma, Papa, Nilima. Carried-Shakti indices refer to Ring-2 positions (e.g. Ram 13 Ātmā + 0 Buddhi; Ashrey 12 Nāma + 11 Bīja; Gaia 1 Ahaṅ).
15. **Memory ↔ Relationship are joined:** Shakti's Carriers backs to "‹ Portrait"; Saṅgha person detail mirrors Person Page; Encounter Log stores shaktis per encounter.
16. **Return gesture inside a world = swipe down (the arc at top 56)** — collides with Codex's Pūjā swipe-down; decide which wins (or scope Pūjā to Home + evening).
17. **Silence grows with progress:** v2 adds an orbital per unlocked ring and enlarges the bindu (76 → 78px); Mauna (Phase IV) has two orbitals, an 84px bindu and timed captions at 7/14/21/28s.
18. **v2's Avaraṇa Threshold is the ceremony the Veil routes to:** text arrives line by line over ~7.8s (name .3s … personal letter 5.6s, button 6.4s) and ends "Enter this Avaraṇa"; it reads AVARANAS fields name, subtitle, form, presidingForm, yogini, mentalState, chakra, personalConnection, geometry.
19. **design-canvas ignores `title`/`background`:** the phase titles in host files never render; don't treat canvas chrome (warm grey grid, Download PNG/HTML, Delete) as app design. doc-page.js is unused by this family.
20. **Synthetic data is marked as such:** PRACTITIONER_HISTORY, genConstellation, Density grids, LIFETIME_YEARS, Great Wheel densities use Math.random — "Real version reads from on-device log + Airtable shakti map." Numbers like 1,418 / 264 days / 218 days / 12 of 16 known are placeholders.
21. **Small code defects worth knowing:** Ring 7 sound-rings only follow the node's y (cx fixed); Cosmic Now tithiNum 12 for Trayodaśī (13th); TemporalMark ignores its x/sym; quick-recog-panel class has no CSS; Veil dims to .5 though its comment says ~.55.
22. **Phase VIII (The Initiation — "first-time ceremony, not onboarding") is named in the Codex but absent from this family;** Home relies on it: "Initiation teaches gestures · home stays pure", and the contract's fallback home location is "set during initiation".
