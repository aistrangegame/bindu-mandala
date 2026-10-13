# 12 · Padakarshini: the topic field, the engine, and the handoff method

Reader 12, second reading, 12 Oct 2026 (night). Source root (abbreviated `PK/` below):
`/root/.claude/skills/synced/12004d20-e236-4ac6-98bf-0d5838029946_16bbdd03-2a82-4e1e-84ae-276f4c93debb/padakarshini/`

Read-only. Nothing in the skill, the repo or Airtable was changed. Scratch copies (flattened JSON) sit in my scratchpad only.

Lens:
1. The ASG topic field and learning register, read as a map of Ashrey's whole teaching. Every topic is placed in a Bindu Mandala world and marked energy (E), story (S, a Bindu Feed candidate), or L (a teaching that belongs to Bindu Learning, not to the Mandala). The full per-topic table is Appendix A12.
2. The engine, the figures and the gate: what the app's rooms could port.
3. The Claude Code handoff and the headless walk gate, captured in full so the app's wave briefs can use the same method (A9 and B-III).

World codes used throughout: **H** Home/Bindu · **R** Today/the Rite · **M** the Mandala (held yantra and Veil) · **N** the nine rings · **HH** Her Home · **HP** Her Presence (portrait) · **C** the Climb/Axis · **33** the 33 (braid) · **G** A Strange Game · **MO** the Modes · **T** Time · **ME** Memory · **W** the Well · **B** Beneath · **RF** the Relationship Field.

---

## A · Inventory

### A1 · `references/asg-topic-field.md` (296 lines): the topic field per form, for Claude Design

**Three layers (line 3, verbatim):** "the **form** (fixed hooks and contract) · the **sub-template** (a variant per family below: same grammar, different figure, world, type) · the **move** (one per page, chosen by Claude Code). Variants change what is drawn, never what is hooked. Every page carries `data-variant="<family>"` on `<body>`."

Families and counts, as proposed by the register (before the design pass re-routed them):

| form | total | families (count) |
|---|---|---|
| Practice card | 248 | breath 14 · body 12 · senses 18 · stillness 22 · mind 3 · other 179 |
| Walk | 61 | anxiety 22 · relationships 21 · any 18 |
| Field guide | 65 | in-the-moment 19 · for-someone-else 27 · health 3 · boundaries 9 · other 7 |
| Portrait | 85 | sage 23 · scientist 43 · seer 13 · poet 3 · other 3 |
| Map | 21 | rings 5 · spine 5 · tree 1 · grid 2 · geometry 4 · other 4 |
| Two chairs | 19 | science-and-claim 13 · mind-and-machine 5 · map-and-no-map 1 |
| Recipe | 4 | ferment 3 · diet 1 |
| Calendar | 3 | festival 3 |
| Verse | 4 | mantra 2 · poem 1 · raga 1 |
| Storybook | 41 | cosmology 16 · tradition 17 · passage 5 · other 3 |
| Teaching guide | 227 | skill 32 · relationship 17 · mind-body 98 · laws 5 · other 75 |
| Icebreaker | 138 | any 138 |

The Mandala-native topics, with file and line: **map/rings** (line 136–142): Matias De Stefano (Consciousness, Dimensions, Atlantis), The Shri Yantra, The Sixteen Karshini Shaktis (Sri Chakra Second Avarana), The Ten Mahavidyas, and Śrī Yantra Full Mandala Architecture (102 Shaktis across 9 Avaranas, Khadgamalā Stotra Research). **map/spine** (144–150): 7 Chakras, Daoist Neidan, Fascia, Manipura Chakra, The Microcosmic Orbit. **map/tree** (152–154): Kabbalah. **map/grid** (156–159): Ayurveda, TCM 5 Elements. **map/geometry** (161–166): Lakota Political Philosophy, Phi, Platonic Solids and Metatron's Cube, Vesica Piscis. **verse/mantra** (223–226): Lalita Sahasranama, Shloks. **storybook/tradition** (244–246) includes Sri Vidya, Kali, Kashmir Shaivism, Advait Vedanta, Tantric Sexuality, Aghora, Black Madonna.

### A2 · `references/asg-learning-register.json` (4,600 lines, ~124 KB): the whole teaching, topic by topic

**Method.** I flattened all 511 entries to one line each in scratch (`register-flat.txt`, 534 lines) and read that file in full. Every entry has the same seven keys: `{name, L, lake, status, primary, secondary, why}`.

- **Lakes:** Therapy 310 · Consciousness 153 · Learning 48.
- **Primary form:** teaching 138 · portrait 81 · walk 61 · practice 57 · fieldguide 55 · storybook 33 · hold 33 · map 20 · twochairs 19 · recipe 4 · verse 4 · calendar 3 · icebreaker 3.
- **Secondary form:** practice 191 · icebreaker 135 · teaching 89 · none 73 · fieldguide 10 · storybook 8 · portrait 4 · map 1.
- **Status:** none 278 · Start Exploring 145 · Completed 55 · Active 12 · In progress 10 · Make Story Book 9 · Ready to Learn 2.
- **L-ids:** they run L-1001 to L-1540. 115 entries have no L-id; they are register lines 397–511, which are mostly Consciousness topics.
- **Lake × form, largest cells:** Therapy·teaching 132 · Consciousness·portrait 65 · Therapy·walk 61 · Therapy·fieldguide 53 · Therapy·practice 37 · Therapy·hold 24 · Consciousness·storybook 22 · Consciousness·map 18 · Consciousness·twochairs 18.

**The 23 "why" lines, verbatim.** These are the register's whole grammar of how a topic wants to land:
W0 "A claim with a real other side — both chairs, then a way to talk about it" (18) · W1 "A cosmology with laws in it — the laws as a teaching, the cosmos as a fable" (5) · W2 "A day in a thirty-day sequence — gated, one piece every few days" (61) · W3 "A doorway opened by a father — told as a story, then the physics as a map" (1, CERN) · W4 "A lookup for a bad night, with the exercises that help" (7) · W5 "A named skill: the law, why it exists, what it looks like — with the exercise as a card" (31) · W6 "A person: five moments, then a page to open a conversation about them" (81) · W7 "A practice tradition: the doing on one screen, the why on another" (20) · W8 "A principle about how minds and bodies work, with one exercise attached" (92) · W9 "A reading of the lines themselves, with a gloss — then the poet" (4) · W10 "A relationship principle with what to say in the moment" (10) · W11 "A structure with positions — one screen per node" (19) · W12 "A structure with positions — the body as a network" (1, Fascia) · W13 "A thing to do now, on one screen, with a timer" (37) · W14 "A tradition or a passage: told as a fable, then a page to open it with someone" (32) · W15 "Course scaffolding or clinical territory — a pointer to professionals, not a page" (24) · W16 "For someone standing next to a hard thing — what to do, then why" (24) · W17 "One day: what happens and why — with the story behind it" (3) · W18 "Plain how-to, then a way to bring it up at dinner" (4) · W19 "Substance topics stay inside the app" (9) · W20 "The most rigorous corrective to any map of the self — held against the maps" (1, Anatta) · W21 "Unmatched by rule — default to the lightest form; revisit by hand" (3) · W22 "When this happens, do this — a lookup, then the principle behind it" (24).

**The hold list (33 topics, never built).**
- Scaffolding and clinical (24): course intros, wrap-ups, workbooks, disclaimers, surveys, Q and A; "1.4 The Role of Medication", "3. Medication", "2. How to Talk About Suicidal Thoughts", "10. Intensive Treatment Options: Hospitalization and More".
- Substances (9): Psilocybin Mushrooms, Ayahuasca Ceremony, The Master Plant Diet (Dieta), Iboga/Bwiti, Terence McKenna, Cannabis as Sacred Teacher, Tobacco, DMT and The Pineal Gland, San Pedro/Huachuma.

**Ashrey's own frameworks in the register:**
- Breath Understanding Atlas — Bindu Field (L-1536, Active)
- Frequency Understanding Atlas — Bindu Field (L-1535, Active)
- Śrī Yantra Full Mandala Architecture (L-1537, Completed)
- The Sixteen Karshini Shaktis (L-1533, Active)
- Darius J. Wright — The Great Work (L-1538, Active)
- CERN, the Cosmic Dance and the Speed of Time (L-1540, Active)
- Manipura Chakra (L-1383, Ready to Learn)
- 7 Chakras (L-1346, Completed)

Appendix A12 places every one of the 511 topics in a world, with its E/S/L mark. Totals from that table: **E 80 · E/S 7 · S 115 · L 276 · held 33.**

### A3 · `references/design-pass/` (15 files): Claude Design's pass on the Learning Register, 22–23 Sept 2026

**CONTRACT-DELTA.md (271 lines): every rule learned the hard way**

- **§1 Base fix (the highest-value change).** The old CSS made `body` the scroll clip while `html` scrolled, so `body.scrollTop` stayed 0, IntersectionObserver reported ratio 0 past the first step, pieces stayed at opacity 0 and `#count` stuck at `1 / N`. The fix: `html{scroll-snap-type:y mandatory;scroll-behavior:smooth;overflow-x:hidden} body{margin:0; … no height, no overflow}` (lines 29–33).
- **§2 CORRIDOR_JS.** Scroll-driven, not observer-driven. It picks the step whose centre is nearest the viewport centre, throttles by timestamp at 80 ms (never gated on requestAnimationFrame, which can deadlock in a hidden document), re-syncs on `visibilitychange`, and sets `document.body.dataset.cur` (code at lines 55–65). Each form then adds one line inside `activate()`:

  | form | line |
  |---|---|
  | practice | `fig.dataset.mode=e.dataset.fig\|\|'quiet'` |
  | walk | `landing(…)` |
  | fieldguide | `body.dataset.here` |
  | portrait | `body.dataset.room` plus `mark(tick)` |
  | map | `show(ring)` |
  | twochairs | `lean(…)` |
  | recipe | `jar(fill,days,i)` |
  | calendar | `body.dataset.sky` plus `pass(hour,lit)` |
  | verse, icebreaker | none |
  | storybook | the per-page `--turn` / `--edge` loop |
  | teaching | `aria-current` on the law buttons |
- **§3 Snap jumps.** `scroll-snap-stop:always` silently swallows any smooth scroll that crosses more than one snap point. Every multi-step jump therefore uses `behavior:'instant'` followed by an explicit `sync()`.
- **§4 Per-step `data-*` keys.**
  - practice `data-fig` = quiet | open | now | grace
  - walk `data-landing` = 0 | day | grace
  - fieldguide `data-here` = open | situation | grace
  - portrait `data-room` = none | floor | train | silence | question | end, and `data-tick`
  - map `data-ring`
  - twochairs `data-here` = open | round | sit | held, and `data-lean` = none | both
  - recipe `data-fill` 0–1 and `data-days` 0–8
  - calendar `data-sky` (predawn … night), `data-hour` 0–1 and `data-lit` 0–8
  - teaching `data-jump`
- **§5 New elements:**
  - `#lawpick` (one button per law)
  - `.rails > i` ×30 (`.real` / `.done` / `.live`)
  - `.waiting` / `.wcard` / `.tide`. The locked day's text is withheld, not teased: no blur.
  - `.days .dayt`; `.page` / `.folio` / `.corner`; `.vline`; `.card[data-flick]`
  - play surfaces `#hold`, `#spin`, `#swap`, `#grip`, `#jarhit`
- **§6 Hit-test contract.** Stacking order: `.w` 0 · `.fig` 1 · play surfaces 1 · `.step`/`.piece` 2 · chrome 5 · `#lawpick` 6. Then `.step{pointer-events:none} .piece{pointer-events:auto}`. Where a piece covers its own figure, the piece steps aside on that step only.
- **§6b Accent tokens.**
  - `--ac` is for strokes and shapes. `--acp` is the accent at paper weight. `--actext` is the accent as text: `--acp` on paper, `--ac` on night.
  - All 24 pool accents measure **1.96:1 to 2.91:1** as text on cream. A mix of 55% reaches 5.10:1 (68% gave only 3.81, 60% gave 4.50).
  - Rule (line 183): "**if it is a glyph, it is `--actext`. If it is a line or a shape, it is `--ac`.**"
- **§6c Tap targets.** Every target is at least 44 px; when the mark should look small, the visible mark is a `::before` inside the 44 px target.
- **§6d Fit.** Every step fits 390×800 with at least 20 px clear (the piece ends at y ≤ 744). Each figure family needs a `max-width:430px` density block as well as the `max-height:720px` one.
- **§6e Doors.** One `nav.door` per sibling form; 406 topics render in two forms.
- **§6f Reserved class names.** Never use `light dark step piece top count hint w fig band door page` on any figure part. The bug this came from: a `.light{position:fixed}` figure part froze the document.
- **§7 Performance.** Scale caps at 2.3×; glow is a second stroked circle, never `drop-shadow`; `will-change` goes only on the mover; `body.still *{animation-play-state:paused}` while the page is hidden.
- **§8 Deliberate deviations:**
  - The fieldguide picker moved onto the title screen.
  - The practice orb takes the accent.
  - Calendar lamps light at dusk (`i>=5`).
  - The storybook gets `--acp: #6F669B`.
  - The recipe figure is a fixed 42svh band.

**FALLBACKS.md (176 lines): every bucket and the template it goes to**

- **Coverage:** "916 page-instances across 511 topics. Every one now has a template."
- **Built templates:**

  | bucket | template | figure |
  |---|---|---|
  | practice/other | `practice--lesson` | FIELD |
  | teaching/mind-body | `teaching--mind-body` | TIDE |
  | teaching/other | `teaching--other` | FIELD |
  | fieldguide/other | `fieldguide--conversation` | HORIZON |
  | map/other | `map--path` | PATH |
  | portrait/scientist | | RECEPTION |
  | teaching/skill | | DISTANCE |
  | walk/relationships | | LADDER |
  | fieldguide/for-someone-else | | STANCE |
  | practice/senses | | COUNT |
  | practice/body | | SCAN |
  | practice/stillness | | WATER |
  | storybook/cosmology | | PAGE + SEPARATION |

- **TIDE.** "The ground breathes at six breaths a minute"; `data-tempo` is `rest` by default, and `quick` or `still` only where the step's own words describe alarm or shutdown.
- **RECEPTION.** `data-lv` runs 0 rejected · 1 proposed · 2 contested · 3 tested · 4 supported · 5 accepted. It records how peers received the claim, "never a verdict on whether it is true"; unknown is 2. "Dates are claims too."
- **Legend rule for sages.** For any moment without a verifiable date, the tick shows no number and the label reads "as told".
- **STANCE.** Five positions: all · against · merged · apart · beside. Every page ends on beside; "The illness is always a ring, never a face."
- **LADDER.** Every seventh day is drawn as a double rung (date night). `data-remember` is on.
- **Re-routes found in this pass:**
  - Raga → verse/raga; Lalita Sahasranama and Shloks → verse/mantra; the three festivals → calendar.
  - 7 Chakras, Neidan and Fascia → map/spine; Ayurveda → map/grid; Dreamtime → map/path.
  - Simard → scientist; Nag Hammadi → storybook/tradition; Edgar Cayce → portrait/seer.
  - The sleep topics → practice/lesson; the depression pair → teaching/mind-body; Cataracts → practice/lesson.
  - Alkaline Water → twochairs; Phi → map/geometry; Blue Zones → practice/lesson.
  - Gayatri and Mantra Science → verse/mantra; Day 13, Skill #24 and #30 → teaching/skill; Day 15 and Skill #21 → teaching/skill.

**HANDOFF-CHAT.md (170 lines): Design → Chat**

- **The 41-family table** (lines 38–80): family · topics · figure · template. Figures by family:
  - practice: breath ORB · body SCAN · senses COUNT · stillness WATER · mind and other FIELD+CHOICE
  - walk: anxiety RAIL · relationships LADDER
  - fieldguide: HORIZON, and STANCE for for-someone-else
  - portrait: sage LINE · seer AFTERLINE · scientist RECEPTION
  - map: rings RINGS · spine SPINE · tree TREE · grid GRID · geometry POLY · other PATH
  - twochairs: SEATS, and MIRROR for mind-and-machine
  - recipe VESSEL · calendar ARC · verse FIELD
  - storybook: cosmology PAGE+SEPARATION · tradition PAGE+SILSILA · passage PAGE
  - teaching: skill DISTANCE · relationship ATTUNE · mind-body TIDE · laws and other FIELD
  - icebreaker CARD
- **Content rules** (150–165):
  - One screen per piece. A text step is at most about 70 words, a storybook page at most 120, a law + because + looks-like at most 60.
  - No filler. Facts checkable and sourced.
  - "Claims are held, not endorsed or mocked."
  - Crisis pages cost no attention.
  - Quotes under 20 words only.
  - "The ending is quieter than the start."
- **The 25 re-routes**, each with its reason (106–131). The same list is in `_fit_moves.json`.

**HANDOFF-CODE.md (120 lines): Design → Code.** The full method is captured in A9.

**REVIEW.md (39 lines): Chat's fresh-eyes review, 23 Sept**

- **Verified:** 33 templates and 279 steps lit, `#count` reaches N/N on every file, zero JS errors.
- **Rulings:**
  - Content is authored by Code, not Chat: three per family first, walked by Ashrey, then the rest.
  - Merges accepted.
  - "a wrong figure is worse than none — `FIELD` is a legitimate move."
- **Living subjects get `open:true`.** Their figure ends hollow and the gesture is HOLD rather than ARRIVE or OUTLAST: Kastrup, Hoffman, Faggin, Tononi, Campbell, Kolak, McGilchrist, Radin, Pollack, Hof, Wolynn, Hellinger, Carroll, Marciniak, Hicks.
- **Voice:**
  - `practice--lesson`: "the dryness *is* the kindness".
  - icebreaker answers: "two sentences a person could say out loud at a table".
  - The tide is "the best figure in the kit"; the "in the body" lived line must never be omitted.
- **Routes:** Gayatri and Throat Singing → verse/mantra; any walk/any topic whose name is a week or section header → hold.

**ROADMAP.md (163 lines)**

- **Phases:** 0 kit · 1 fallbacks · 2 named families · 3 harness, forms index and identity · 4 gates · 5 generator. Status on 23 Sept: core done, `gen_v2.py` never run.
- **The number that reframes the job:** catch-alls are 525 instances (57% of the field), so "the main design problem, and they go first."
- **Figure Kit:** 15 primitives (`ORB · RAIL · RINGS · SPINE · TREE · GRID · POLY · ARC · LINE · VESSEL · PAGE · CARD · SEATS · HORIZON · FIELD`).
- **Moves:** five slots.
- **"Beyond" ideas:**
  - The corridor remembers.
  - A grace-ending library.
  - Density as a real axis.
  - "The figure as the loading state."
  - Cross-form doors carrying the topic's identity.

**Data files**

| file | contents |
|---|---|
| `_fit_moves.json` (156 lines) | 25 re-routes `{topic, from, to, why, note?}` |
| `_instances.json` (0 newlines, 77,705 bytes) | 916 `{name, form, family}` triples: the routing before re-routes. Read structurally and diffed against routing.json: 57 rows differ, and those are exactly the re-routes (the list is reproduced in A12's routed-forms column). |
| `_template_table.md` (32 lines) | the template → families → step data → hooks table (the same as HANDOFF-CODE §4) |
| `content-example-5-empathic-listening.json` (40 lines) | the one worked content file: `{title, sub, one, opening, laws:[[law, because, looks]×6], practice, close, source}`. Six laws: listen to understand · reflect before you respond · name the feeling · don't fix · let the silence work · stay two people. |
| `contracts.json` (137 lines) | top-level keys per form, plus family overrides: portrait/seer `after`, portrait/scientist `reception`, storybook/tradition `source`, practice/other and practice/mind `options`/`why`, fieldguide/for-someone-else `their`. Walk carries `cooldownDays:num`. |
| `doors.json` (5,744 lines) | `url_scheme` (icebreaker `/learning/icebreaker/`, storybook `/learning/story/`, teaching `/teachings/`, default `/learning/<form>/`); 12 door lines (e.g. practice "as a practice" / "Do it — a few minutes, now."; map "as a map" / "See the whole of it drawn."; verse "as verse" / "Said aloud, a line at a time."); 406 topic → `[{form, family, href, ac}]` entries. All read via a compact flattening and verified against routing: 406 × 2 siblings, 0 mismatches. Two hrefs (Ptesáŋwiŋ, Wakḥáŋ Tḥáŋka) slug `ŋ` as `-`, not dropped. |
| `glyphs.json` (13 lines) | one 60×60 SVG glyph per form (practice: two circles r15/r24; map: rings r24/16/8 and a dot; twochairs: two chair paths; etc.) |
| `manifest.json` (317 lines) | 916 instances · 884 render · 32 covered; 41 families; 33 templates. Pools per form: practice, walk and fieldguide calm · recipe and calendar warm · map, storybook and portrait deep · verse, twochairs, teaching and icebreaker all. |
| `routing.json` (11,929 lines) | 916 `{name, L, form, family, template, figure, pool, ac, seed, from, action, moved_from?}`. Read in full via flattened scratch (first 295 rows full; rows 296–916 compact, after verifying template, figure and pool are pure functions of form/family, 0 exceptions). 20 rows carry `moved_from`. Pools: all 403 · calm 362 · deep 143 · warm 8. Figure use: FIELD+CHOICE 191 · CARD 138 · TIDE 104 · FIELD 86 · RAIL 41 · RECEPTION 39 · DISTANCE 37 · HORIZON 28 · STANCE 27 · LINE 27 · LADDER 22 · WATER 18 · SILSILA 17 · SEPARATION 17 · ORB 16 · ATTUNE 16 · SEATS 15 · AFTERLINE 11 · COUNT 10 · SCAN 9 · SPINE 8 · MIRROR 7 · ARC 6 · RINGS 5 · POLY 5 · PATH 5 · PAGE 5 · GRID 3 · VESSEL 2 · TREE 1. |

### A4 · The method files

**`process.md` (31 lines)**
- **Round one, the register:** pull the whole field; name the lakes; map every topic `{name, lake, primary, secondary, why}` ("Rules first … then hand overrides, then a default that is *flagged*, never silent"); a hold list; write `.md` and `.csv`.
- **Round two, the ruling:** "Trust is a ruling."
- **Round three, build by form, depth-first:** "One form. Three topics into its contract. Render. `verify_walk.py`. The person walks the three. Then the rest of that form."
  - Score each piece on five tracks (scene · sound · gesture · motion · logic).
  - Where two mechanics compete, build both and walk them side by side.
  - "Ship with proof", then an adversarial pass.
- **Git as the spine:** "Push to `main` only after the walk passes."
- **Verification:** Playwright at 390×844, every step lit, no JS errors, height ≤ one screen; screenshots "at the darkest point. Then eyes."
- **The holds law (line 31, verbatim):** "Every hold completes by a real hold and by a held key (Enter or Space held for the same duration; key repeat ignored); an early release does nothing; the act waits for the release; a single tap or key press completes a hold only where its design gave it one. … Under reduced motion each gesture resolves to a still state, and a hold keeps its duration. Before changing an existing experience, compare it with what was served before and with its design: a rule may add, never subtract."

**`claude-code-handoff-template.md` (65 lines).** A `CLAUDE.md` for Code. Captured in A9.

**`design-brief-template.md` (42 lines): the Claude Design brief**
- Import the ASG design system: Lora display, DM Sans tracked labels, mobile-first 390.
- Global rules:
  - Keep `.step > .piece`, `#w #fig #count #hint`, every id and `data-*` hook.
  - "Keep the copy exactly."
  - No piece taller than a phone.
  - No field vocabulary.
  - Reduced motion and contrast.
  - "**The Lalita level:** one small unexplained play element per page … and a moment of grace at the end. Delight as substrate, not ornament."
- One prompt per form: Goal · Layout · Content · Audience · Play. For example, the Map: "the structure drawn is the page; the text is a caption to the geometry … Play: the rings can be spun." Teaching: "Play: the law you hold longest stays lit."

**`site-v3.md` (17 lines).**
- Code's own engine shipped 621 pages; `gen_v2.py` is reference only.
- Lake floors; the Therapy care line.
- "**The walk form ships with every day open**". The anxiety walk is *A Month With Anxiety* (27 days).
- The icebreaker list-in-button-role was flagged by axe and fixed across 114 pages.

**`lineage-2026-09-22.md` (16 lines)**
- Frame: "the outputs are mirrors, not teaching documents; a page should leave the reader open enough that reality can finish the sentence. Wrong time, not wrong page."
- Learned:
  - The 55% bug (trigger at 12%).
  - Dark accents must be lifted on dark grounds.
  - Descent ink publishes `--p`.
  - "*A DOM stub is not a browser.* jsdom 'passed' every page; Chromium at 390×844 found the real failures."
  - "*Collapsing twice* … Unflatten first."
  - *The figure principle.*

**`lineage-2026-09-30-design-corpus.md` (146 lines)**
- **The law:** "**how you touch a thing is the teaching.**" Five dimensions: depth, time, memory, relationship, practice.
- **Learned the hard way:**
  - The app instructs where the design lets you discover: six invented instruction strings were deleted.
  - "A screenshot carries almost none of the specification … a damping of 0.956 rather than 0.945, which doubles the glide after one second. Build to the numbers, not the frames."
  - "Hex alpha read as decimal. `0D` is 5.1%, not 8%." Tracking given in `em` was passed through as `pt`.
  - A hold with no keyboard path.
  - Staged answers and invented presences are false statements ("84 hearts breathing").
  - Numbers that measure the reader.
  - Compare before choosing.
  - "Verify backwards. The Homes shipped with 66 checks".
  - Safari wipes a site's storage after 7 days without a visit.
- **3 Oct reversal (verbatim):** "a rule may add to a designed experience, never subtract from it. A hold is the hold it was designed to be; holding a key counts as holding."
- **"Left behind, by intention" (73–124)** includes "**The Relationship Field** … *Why:* the map's ruling 2", seed syllables, Devanāgarī on the site, and the Memory Layer's counts.
- **Ruled 11 Oct 2026 (126–146):**
  - Every law is "a move a build *may* make, never a wall."
  - Floors: **truth** and **access**.
  - "Light, never locks" is favoured.
  - "No tiering by returns."
  - "The Waking never blocks input; the Descent's tone peaks near 0.8 s and is gone by 1.25 s".
  - "Red has no limits".
  - Kept as designed: beats shortened on return (G35, G49), "Lalita's curves seeded by how many times she has been called, the Great Wheel lit by how often a petal was met."

### A5 · `references/elements-2026-09-30.md` (1,966 lines): every step-element from the 140-prototype corpus

Read in full, lines 1–1966. This file is the deepest well in my assignment. Every entry has the shape *From · What it is · Spec · Reuse · Skill · Guard*. Below are the ones that matter for the app, with their exact numbers.

**6.1 A Strange I Game**
- **Walk it or read it** (two-door station). Two flames, called *half* and *whole*. State comes from the event record (`*-began`, `*-completed`, `*-read`), "never a stored 'done' flag".
- **The home that grows as you walk.**
- **One address, a home for each stage.** Splash 1.6 s; "return. / the road remembers" for 2.3 s, only after days away. Completion ceremony: a line at 0, a point swelling from 1/5 at 1.1 s, a second line at 2.4 s, gone at 3.8 s. Review states are forced from the harness, never from a URL.
- **The figure chooses the door.** Pentagon nodes.

**6.2 A Strange Feed, part 1**
- **The Point walk.**
  - A log-scale camera snaps enclosure by enclosure, so every level is met at the same size; only the current level is lit; the figure breathes 1% on a 10 s clock.
  - The gate: hold 1.1 s; five random "deals" of the opening line.
  - Items are marked walked ● / in progress ◐ / seeded ○.
  - Sound ladder: **174, 285, 396, 417, 528, 639, 741, 852, 963 Hz → 136.1 Hz**. The beat narrows 8 → 7.5 → 7 → 6.5 → 6 → 5.5 → 5 → 4.5 → 4.2 → 4 Hz. No event above gain 0.075.
- **The visit told back at the centre** ("Every dot you touched was me.").
- **One axis, surfaces that resist** (G15). A 5.4 s passage with a throat of 34 rings; LONG/SHORT switch.
- **A frontier opened by stillness** (G2: 4,600 ms; busy within 340 ms; one line once ever after 700 ms; the tone is gone 0.22 s after a touch).
- **Seven ways of reading one item** (G2–G8).
- **A room per voice.**
  - Four registers, 240 px of drag each.
  - Eleven sideways gestures. One example: seed-head divergence pulled off 137.507°.
  - Pulling 1 node of 9 moves all 36 edges.
- **Received as a Rite** (G11).
- **The procession of voices.** Each voice's tone lasts `(4 + 3.6·lines)` s; the finale is a ring of dots around the ember.
- **A piece that returns, aged.**
  - Age `a = (days/1095)^0.55`; saturation `1 − 0.30a`; breath ×`(1 + 0.45a)`; grain `0.05 + 0.14a`; warmth `0.30 + 0.70a`.
  - A new ring enters off-centre and settles over 4 s, its tone 1.5% flat coming into tune.
- **The Light.**
  - Breath 10 s: in 40% · hold 15% · out 40% · rest 5%. G32 at 4,200 ms per line.
  - Stone `#D9D2C4`.
- **The dawn that keeps moving.** Ambient `min(0.92, 0.30 + 0.62·(1 − e^(−minutes/40)))`; for days away, τ = 40 days. 200 steam motes; blinks every 18–40 s.
- **One camera, whole to one piece** (G44: z 0.22 → 34; star radius `pr·z`).
- **The Aperture.** An eye that turns once per 42 s at rest and once per 2.4 s while drawing.
- **Signal Space** (A10); **The Mirror** (one redraw a day).
- **No on-screen instructions.**
- **Sounds that answer the hand.**
  - Strain, give, a ring coming into tune, ink tone 174 Hz.
  - Stillness tone (swells over 4.6 s).
  - Reveal chord 136.1 · 272.2 · 408.3 Hz over 9 s; a struck bowl to seal.
  - Master ceiling 0.075; never on load. The site's two roots are 136.1 Hz and 110 Hz.

**6.3 A Strange Feed, part 2 (the fourteen screens)**

- **The two weathers of one door.**

  | | Ground | Wash | Line |
  |---|---|---|---|
  | Unmet | `#08070C` | radial at 50% −8%, C@0.36 → 0.10, `breath 10s` (opacity 0.34↔0.80, scale 1↔1.045) | "touch to receive" |
  | Met | `#0B0910` | warmth `#C9A07A@0.26` low and behind | "tap anywhere to cross" |

  Met is read from the day's record, never from a local flag.
- **No lobby.** The glyph runs `glyphBreath`, 11 s; text in Lora 27/1.46; the block fades in over 2.2 s.
- **Three gestures on one surface.**
  - `pointerdown` starts an 1,100 ms rope timer.
  - Moving more than 7 px cancels it; pull = `min(dy,120)`; dy > 84 opens the turn.
  - The 2×2 dot mark sits at top 62 / left 26, first dot `#E5533C`.
- **The blink crossing.** Lids grow 0 → 50% over 0.66 s with `cubic-bezier(.62,.02,.4,1)`; the seam glints after 0.3 s; navigation at 780 ms. Used at one surface only.
- **The turn ("WHERE TO").**
  - Overlay `rgba(8,7,11,.8)` with blur 22.
  - Row stagger `0.14 + i·0.075 s`.
  - Rows with Hz: Rite 220 · Rooms `#B9AEA2` 146 · Archive `#A9A29B` 261 · Universe `#9FB2C4` 285 · Light `#EDE3CE` 174 · Point `#C0392B` 174 · Players `#3AADA8` 196 · How You Arrive `#C47A52` 261.
  - An unbuilt row shows at 0.42 opacity and sounds 285 Hz.
- **The rope.**
  - Ring 110 px; ember 9 px `#E5533C`.
  - Phases at 0 → 10,000 → 20,000 ms. The line: "You exist. This pressure is the chamber working, not you failing. One breath at this pace is already boarding."
  - Exits "walk the point" and "return to the day". Opens with the Bindu voice at 110 Hz for 9 s.
- **The bench.** Review controls outside the device; they never ship.
- **Threshold kinds.** Threshold `#C9A07A` · Practice `#8C96B8` · Seed `#4A9E6B` · What Found You `#4A9E6B` · the dot `#E5533C`. Weights 40/23/20/12/5, never the same kind twice in a row, so the effective shares are about 33/25/22/15/6%.
- **Cross when you choose.** Words fade over 900 ms, then the wash over 0.9 s; navigation at 1,420 ms.
- **Persons tier** ("and the field turns to you").
- **Ring of rooms by arrows:** `(idx+dir+13)%13`, fade 0.28/0.4 s.
- **The Turning.**
  - The hold engine runs UP 2,900 / DOWN 750 ms. Content filter `saturate(.32+.68l) brightness(.70+.30l)`; words appear past l = 0.55.
  - Captions: "trace the loop — let the light in" / "stay with the turning…" / "witnessed · the light is up".
- **The hold engine (G0).** `tick` code at lines 487–495.

  | hold | UP | DOWN |
  |---|---|---|
  | Turning | 2,900 | 750 |
  | Compose | 2,300 | 620 |
  | Board | 3,200 | snap back |
  | Archetype | 4,000 | 0.5 s ease |
  | shipped app's ring | 1.5 s | |
  | site `.hold` | 700 ms | |

- **One voice record:** `{id, name, role, color, glyph, principle, stats[3], words[]}`.
- **Three earning mechanics side by side** (the method).
- **The descent reveal.**
- **Hold to witness.** HOLD_MS 4,000; ring r = 36; labels "hold to witness" → "stay with it…" → "witnessed".
- **Hold to release.** UP 2,300 / DOWN 620; armed only when there is text; captions "write, then hold to release" / "hold to release into the field" / "hold — let it rise".
- **The prompt that recedes.** "What arrived for you?"; opacity drops to 0.45 once text exists.
- **Released.** "The room has changed."; no staged replies.
- **Your own words, newest first,** ending on "this is where you began".
- **Your colour today.** Terra `#C47A52` · Ember `#E5A352` · Clear `#7B82D4` · Deep `#4A9E6B` · Open `#D4607A` · Play `#9B6BD6` · Held `#C4923A` · Flow `#3AADA8`, each with two quality words.
- **Save only when changed** ("Saved. You've arrived.").
- **Read still, then the voices gather.** Triggered at a threshold of 0.25; voices dissolve in at 0.4 / 1.3 / 2.2 / 3.2 s.
- **The field gathers later** (ambient answering).
- **The hidden-until-asked hub.**
- **Compare two answers on one device.**
- **Wording canon is load-bearing.**

**6.4 Aistrangegame.com**
- **One sentence all the way round.** 8 stations; a full turn in 64 s; "hold the beat" plays two sines 0.5 Hz apart.
- **The first screen as the top of the spine.**
- **A roll you can see land.** A golden-angle disc.
- **Bands of glass.** The middle band swells ×7 over 1.1 s.
- **The harness.**
- **The gateway in four movements:** arrive · choose · or don't · return.
- **"Two taps, never one."**
- **"What is this?" at every level.**

**6.5 Learning App**
- **Hold to read** (G1).
- **Paper floor, dark rooms beneath.**
  - The Descent (G14) takes 2.35 s.
  - The light veil: 1.05 s, with bloom scale 0.04 → 0.16 → 1 → 1.35.
  - Into dark: a 9 px gold ember over 1.5 s.
- **The Waking.** 2.85 s; the ember swells ×1.32 at 1.65 s; the paper bloom is Ø 2,600 px; tone 110 Hz with a +6 ¢ twin and a fifth. "Never blocks input."
- **The Still Point** (G10).
- **Held story beats.** 1,500 ms each. Ember on lingering: ≥3.5 s at 0.5, ≥7 s at 0.72, ≥14 s at 0.92.
- **The walk log.** Append-only `{type, ring, idx|null, topic, text, date}`. Types: mark · reflection · spoken · revisit · held (≥2.5 s) · link.
- **The commonplace book.**
- **Your reading becomes your sky; recognition across ≥3 topics.**
- **The wager** (A12, due after 3 days).
- **Resume** (written every 700 ms; "You were partway down").
- **Linking.**
- **A library you fall into.**
- **The haptic family.** Tick ~0.3/0.4; a ramp 0.15 → 0.6 then a transient 0.8/0.5; the Descent 0.9/0.15.
- **The Ceremony** (a 1,000 ms hold) **and the Threshold** (1,300 ms).
- **The parity pass.**

**6.6 Bindu Being**
- The answerable witness.
- A day as a glyph on a thread.
- Time / count / touch, with a 1.1 s hold ring.
- The space I'm in.
- The settle: "Held." · "Seen." · "Kept.", over 1.4 s.
- A greeting that follows the hour.
- A month as a letter.
- A gentle door toward what has gone quiet.

**6.7 Bindu Blink**
- **The same essay told twice in mirror.** 16 screens. A Pythagorean chime on 256 Hz going in (256, 288, 324, 384, 432, 486, 512), descending coming out, ending on 136 Hz.
- **The sound door** (taps ignored for 200 ms).
- **"Welcome back. The Bindu remembers."** for 3 s.
- **Ask, in the page.**
- **Catching a wandering 9 px point.**
- **A reading thread.**

**6.8 Bindu Field**
- **The Score** (A13). Crescendo 145 → 160 s, held to 180 s, released by 195 s; 7 arches; a keystone of 22 shards.
- **The portal.** A 9 s loop with an 8-petal lotus.
- **The Oracle.** Timings 2.2 / 0.4 / 2.2 / 3.4 / 5.6 s.
- **Akash** (A5).
- **The Loop.** Breath ring 5.5 s; a mirror word every 2.8 s; the reveal at 84 pt.
- **Mixer and Lab.** 40–600 Hz, ±0.01. Band colours: delta terracotta · theta violet · alpha blue · beta teal · gamma gold.
- **S·T·C badges.**
- **Singular or ensemble.** At most one ring every 1.08 s (photosensitivity).
- **The Lalita event.** Cream `#F8F3EE`; 16–25 s; six curves.
- **The player never stops.** Controls hide after 3.8 s.
- **What did you remember.**
- **Sphere and moods.**
- **Breath as navigation** (G37).
- **A map with unmade places:** "this has not yet been composed".
- **Three dials.** Mystic · balanced · clear; geometry off · subtle · full; motion full · reduced · off.
- **Scatter, crown, tether, bloom.**

**6.9 Bindu Mandala (lines 1198–1350): the app's own designs, all present**

- **The climb: the body as altitude.**
  - A rail names the body region from the feet to totality.
  - Lights in their true counts at each altitude.
  - "stay" runs the room's clock at **14×**; "forget me".
  - The day turns at **6 am** (`homes-today.js`), worded as a daily turn, never "presides today".
  - Bands keep their own tempo: full speed at the feet, **0.28×** at the top. The room's effect lingers after leaving.
- **Memory felt, never shown** (G49).
  - Head start: 0 below 12 s of dwell, else `min(dwell·0.55, 221 s)`.
  - The entry shortens by `max(0.36, 0.68^min(visits,4))`.
  - "you have stood here before", once.
- **The room test.** Mechanisms: walls close while you stand still; thresholds arrive faster than you can cross; only what a travelling pool of light rests on exists; the hems lift; the ceiling lowers; the walls move with your breath; RGB mis-registered rooms slide into white while you hold still; nine depths. "could this room belong to any other?"
- **Staying opens a deeper turn.**
  - Axis clock: first change at **62 s**, held to **227 s**, reversal by **347 s**.
  - Rite of Entering: adapt 90 s, hold 165 s, second 120 s (reduced motion 160 / 190 / 150).
- **Going deeper.** Five stations: element · body location · roots of the name · quality · phrase.
- **Each place's verb is its gesture** (G9, G17); "press a petal to invoke".
- **Open on one being.**
  - A seeded walk; the day turns at 6 am.
  - Six element layouts: fire ascension · water descent · air horizon · ether veil · earth foundation · light radiance.
  - Per-being mood: scale 0.86–1.26, gradient angle in 24° steps.
  - Relit for dawn, noon, dusk and night; the G39 ceremony; "What did you notice?"
- **Readiness sensed.** Thresholds 0, 1, 3, 7, never shown; a **750 ms** hold with a 12 ms vibration. Status opacity 22 · 44 · 76 · 100%.
- **A bell lower at each step inward:** **392.0, 349.2, 329.6, 293.7, 261.6, 246.9, 220.0, 196.0 Hz** for rings 1–8; silent outward.
- **The interface thins.** Chrome at 100 / 80 / 60 / 25 / 0%; the point up to **26×**; hold the point **0.9 s** to reach the source.
- **Breath slows toward the centre.** Outer ring **3.5 s** (petals 4.5, 6, 7.5, 10 s, slower the less they are met); next ring 8 s; inner rings 9, 11, 13, 15 s with counter-layers at 10, 12, 14, 16 s; innermost 18 s; the centre **4 s**.
- **Light, never locks: five tiers** (glyph · text · sub opacity):

  | tier | glyph | text | sub | line |
  |---|---|---|---|---|
  | You are here | 0.95 | 0.95 | 0.60 | gold |
  | Open | 0.82 | 0.84 | 0.50 | solid |
  | Ground | 0.62 | 0.66 | 0.40 | solid |
  | Ahead | 0.30 | 0.34 | 0.22 | dashed, veil 0.55 |
  | Veiled | 0.16 | 0.20 | 0.13 | dashed, veil 0.72 |

  The Veil dims the image to about 55%.
- **The day as the structure** (the Eight Modes).
  - A morning question before noon.
  - Beholding wakes at 3 s, 30 s and 2 min.
  - The catch (a long press).
  - The garland: names ring by ring inward.
  - Silence: captions at 7 / 14 / 21 / 28 s.
  - After sunset, the evening offering by hold.
- **Time as orbits.** Five wheels: hour, tithi, nakṣatra, ṛtu, sidereal sun. Guard: 30 tithi ticks and six ṛtus, a real ephemeris and place.
- **There is no menu** (Codex nine gestures). Note that ruling 10 lifts "no menu".
- **Ship with proof.** 66 checks across nine registers; 204 rooms rendered offscreen.
- **Mechanism, never mood** (the method).
- **Rooms made by rule.** 8 hand mechanisms; the ring gives the archetype; the card tunes physics, altitude and words; a held attribute is the one moving actor; the carrier is an interval above the ring root, with one interval withheld until a long stay.
- **Three touches in, a name written by hand** (G35).
- **A portrait made of attention.**

**6.10 Bindu Practice**
- **The Witness.** Lines at 0.6 / 5 / 10.5 s; "Go." at 17 s; the door at 20 s; 70 motes; an arch of 132×172 growing ×5.5.

**6.11 Chakra Game: every mini game**

| game | spec |
|---|---|
| The 108 | rings of **40/32/24/12** beads; lines join after 54 |
| Seed | sprout at **2 h**, sapling 8 h, tree 24 h, flowering 72 h |
| Corridor | 800–1,200 ms per step; a door from step 18; done at 24 |
| Coherence | merge when score > 0.82 |
| Mantra tuner | **396, 417, 528, 639, 741, 852, 963 Hz**; tempo `round(f/8)`; within 5% after 6 taps |
| Drum | 1,000 ± 180 ms; 20 layers |
| Mirror Maze | |
| The Letter | burn, bury, or seal for 30 days |
| Shadow translator | |
| Water level | ±0.45 rad; a knock every 6 s; still for 30 s |
| Fire | fuel starts at 50, burns 0.18 per frame, +22 per feed; counts in the 15–82 band; done at 60 |
| Root system | |
| Trace | 18 lines, within 22 px |
| The twelve | |
| Missing petal | |
| Body map | three inks |
| Spine walk | |
| Shake to clear | |
| Child games | Finger garden (drone 110 + 220 Hz), Colour rivers, Rain, Echo |

Then the larger pieces:
- **The portal of one colour.** Rings turning at 80 s and 50 s; breath 4/2/6/2 × 3.
- **Ways in by how you feel** (five doors).
- **Gates of release** (G33 at 2,600 ms; put-down 1.7 s).
- **Letters across time** (2.4 s breath).
- **World in a box.**
- **A mandala made of your record.** A ring of 365 day-segments turning 0.00055 rad per frame.
- **The wall-clock breath.** 8 s, `(Date.now() mod 8000)/8000`.
- **Bindu Immersive.** A **5,000 ms** first hold; a point from about 90 motes over about 12 s; a still finger cancels beyond 24 px; drone **136.1 Hz** with octave and sub-octave, 0.004 → 0.012, a 0.05 Hz cycle.
- **A day as the unit.** A pulse of about 60 a minute.
- **One point never replaced** (eight movements).
- **The body as scripture** (108 verses).
- **The five-track score** (method). A 68 Hz sub, a 272.2 Hz bell, true zero for about 14 s.
- **Pairing floor.**
- **Child Space** (G34 at 2,800 ms, words shrinking to 55%).
- **The Mirror camera** (60 s).
- **The Record** (print or save).
- **A ladder of centres.** 396–963 Hz, 60 s each, 15 s in quick mode.

**6.12 Lalita Family**
- **The Mirror under the floor.**
  - Gates fill +0.075 every 55 ms; deeper +0.011 every 80 ms to 0.32 / 0.60 / 0.88; carve +0.05 every 110 ms.
  - Binaural 110 Hz carrier / 3.5 Hz beat, gain 0.02 → 0.06.
  - Blips: 174 · 220 · 220 · 196 · 196 · 233 · 246.9 Hz.
- **A sky of walks.**
- **The Capture.** Four cards; untouched, they lower after 9 s.
- **A hold bar that measures only the live gesture.**
- **The quiet day first.**
- **See before you reach.**
- **A tempo per room:** morning 600 · person 350 · list 120 · capture 150 · Mirror 1,200 ms.
- **Every way of acting at the same weight.**
- **A strike-through.**
- **A ceremony from three facts** (hue / kind of day / years).
- **The adversarial pass.**

**6.13 The playing side**
- **The hold is the game's own move** (G29).
- **A room: practice, then letter.** The sheet rises 40 px from 96% scale over 1.1 s; phrases are held `min(900,180+16·len)` ms each; an authored letter stands in after 12 s.
- **The book.** Up to 200 entries.
- **One written law** for every live call.
- **The board (A14).**
  - Rises 330 → 660 Hz; returns 247 → 123 Hz ("a lesson, not a fall").
  - A six enters; in the first game ever, a six arrives by the third throw.
  - Harish Johari's Leela is named on the board's face. Key `asg.leela33`.
- **The card of the day** (1,900 ms; one weekday-resolving card).
- **Talk** (Ask · Tell · Wonder · Stay quiet).
- **Manage.**
- **Choose and rewind** (G28: 1,400 ms, −540°).
- **Seven verbs on one engine.**
- **"What you bring".**

**6.14 Prototype ledger (all 140).** The Bindu Mandala section (1903–1922) lists 19 prototypes and where each landed. Its last line: "**The Relationship Field → left behind (held).**"

### A6 · `engine/` (9 files): the kit

**BASE.css (113 lines)**
- **Tokens:** `--serif` Lora, `--sans` DM Sans, `--ac:__AC__`, `--acp`, `--actext`.
- **`--acp` mix (verbatim):** `--acp:color-mix(in oklab, var(--ac) 50%, #191919 50%)` with a fallback `#4A4238`. Comment: oklab against a neutral holds the hue (max 1.6° drift); oklch drifted up to 14.6° and "turned a lavender into a rose"; worst case 5.39:1.
- **Scroll owner and layers:** html owns scrolling; layers are world 0 · figure 1 · steps 2 · chrome 5 · picker 6.
- **Steps and pieces:** `.step` is min-height 100svh with snap start and stop always, padding 70 px. `.piece` is max 560 px and starts at opacity 0 with `scale(var(--from)) translateY(10px)`. On activation it transitions opacity over 1.1 s and transform over 1.3 s `cubic-bezier(.16,1,.3,1)`.
- **Grounds:** `.dark` = ink `#1F1B16` on `#F7F3EC` (paper); `.light` = ink `#F5EFE6` on `#0B0910` (night).
- **Motion and idling:** reduced-motion block; `body.still` pauses animation.

**CORRIDOR.js (91 lines).** Shown verbatim in A9. Its parts:
- the `activate()` hook;
- the nearest-centre sync, with an 80 ms timestamp throttle;
- `visibilitychange`;
- keyboard ↓/Space/↑;
- `window.ASGjump`, `ASGsync`, `ASGstepAt`;
- "THE CORRIDOR REMEMBERS": with `data-remember` set, it stores `asg.at.<key>` on `beforeunload` and restores quietly, never past the furthest step.

**DOORS.css (52 lines).** The sideways door is the other form's glyph in the other page's accent, ringed in this page's accent. On click the world tints toward the next accent (`--handto`, opacity .55) and the page changes after **520 ms**; this is skipped under reduced motion.

**FIGURES.css (746 lines): sixteen primitives**

| primitive | what it does | key numbers |
|---|---|---|
| FIELD | the no-figure wash | moves with `--p`: `calc(94% − p·56%)`; breath 9 s |
| HORIZON | one still line low on the screen and a glow | |
| ORB | quiet / open / now / grace scale | .52 / .78 / 1 / 1.5; `#hold` 64vmin; transitions 3.4 s |
| RAIL | landings on the left edge | `--ty = −index·28`; `.live` ×2.1 |
| RINGS | `#ringg` | scale .92 → 2.3; `.live` stroke 1.8; glow stroke 7 at .16 opacity |
| SPINE | the three channels; sushumna straight, ida/pingala crossing at each centre and ending at the brow | |
| TREE | 22 paths; the lightning flash crosses the abyss | hit circles r 44 |
| GRID | sheng around the rim, ke across it as a dashed star | characters counter-rotate |
| POLY | construction by `pathLength=1` | 78 edges; the dodecahedron lights none; grace turns once per 80 s |
| ARC | the sun's arc across the top 46svh; lamps; flame flicker | 2.6 s flicker |
| LINE | a life line with draggable `#lifept` | |
| VESSEL | the top 42svh; days as DOM type | |
| PAGE | the book | paper `#F2EADB`, `rotateY(var(--turn,-7deg))`, fore-edge, corner lift 14 → 46 px |
| CARD | | |
| SEATS | | |
| BAND | | 46svh phone band |

The SPINE lotus petals follow tradition: "4 · 6 · 10 · 12 · 16 · 2, and the crown as three rings of fine petals for the thousand", and `.bija` labels.

FIGURES.css also carries the family blocks: TIDE (5 s in / 5 s out; held, the tide rises; let go, it falls over 8 s), PATH, RECEPTION, DISTANCE, LADDER, STANCE, COUNT (5·4·3·2·1 dots, each a 44 px target), SCAN (a warmth band mixed toward amber `#EDB877`), WATER (`data-calm`; the leaf drifts over 13 s; ripple 2.6 s), SEPARATION (sky/earth planes moving ±34svh·sep; a seam of light) and @LOADING ("THE FIGURE IS THE LOADING STATE").

The two header rules, verbatim: "No `filter` anywhere inside a subtree that gets scaled" and "Scale caps at 2.4x".

**GRACE.md (69 lines): the ending library**
- "the ending is a gesture, not a sentence"
- Five rules: one gesture per family; a topic's two pages never end alike; the ending is driven by the corridor, not a timer; under reduced motion show the end state; the seed varies detail, never whether it happens.
- 41 families · 28 gestures · 0 clashes. Gestures include REST · FILL · COMPLETE · SETTLE · HANDOVER · OPEN · QUIET · BESIDE · FADE · OUTLAST · ARRIVE · WIDEN · RETURN · ORBIT · TURN · HOLD · MIRROR · COVER · EMBER · SOUND · CLOSE · REJOIN · KEEP · IN STEP · DISTANCE · EBB · LAST LINE · SAY.
- Examples: map/rings WIDEN, "the rings open outward past the edge — you do not go there, you widen here"; teaching/laws KEEP, "the law you held longest stays lit".

**MOVES.md (117 lines): the move as five slots**
- figure · direction (in/out/walk) · ground (paper/night; at most two grounds per topic) · density (spare/full) · play.
- The play library, with what each lives on:

  | play | lives on |
  |---|---|
  | hold | ORB, FIELD |
  | spin | RINGS, POLY, GRID |
  | drag | LINE, RAIL, SPINE |
  | swap | SEATS, GRID |
  | flick | CARD |
  | lift | PAGE |
  | open | VESSEL |
  | light | ARC, TREE |
  | breathe | any text |
  | stillness | G2 |
  | follow | G3 |
  | part | G4 |
  | bear | G5 |
  | pace | G6 |
  | carry | G9 |
  | deepen | G10 |
  | receive | G11 |
  | turn | G24 |
  | trace | G18 |
  | tempo | G23 |
  | none | crisis pages |

- Legal sets per form. Example: map = RINGS · SPINE · TREE · GRID · POLY, direction in, night ground, default play spin.
- A per-form grace table that predates GRACE.md.

**compose.js (39 lines).** The compose order: BASE (with `__AC__` resolved by identity) → TYPE_FORM → EXTRA_FAMILY → markup → FIG script (defines `ASGfig`) → CORRIDOR (`__ACTIVATE__` replaced by `window.ASGfig&&window.ASGfig(e.dataset,i,N);`). Body attributes: `class=ground data-form data-variant data-seed style=--from`.

**gate.js (204 lines): the contrast gate.** Captured in A9.

**identity.js (124 lines)**
- 24 ACCENTS, ordered so that neighbours in the list are not neighbours in hue.
- POOLS: all / calm (8) / warm (8) / deep (8).
- FNV-1a 32-bit over the NFC-normalised, lowercased, whitespace-collapsed topic name. Seed is `fnv1a('seed:'+norm)%10000/10000`.
- "Do not 'improve' the hash".
- A Python port, and the pool per form.

### A7 · `generators/` (15 Python files)

**gen_register.py (78 lines): round one, regex rules → `register.json`**
- 26 ordered patterns (first match wins).
- The substance pattern: `psilocybin|ayahuasca|cannabis|iboga|san pedro|dmt|mckenna|master plant|tobacco`.
- The map pattern includes `chakra|dimensions|sri yantra|…|karshini|mahavidya|kabbalah|…|nine|bardo|…`.
- The default is flagged: "Unmatched by rule — default to the lightest form; revisit by hand".
- Names are deduped; the output is `.md` and `.csv`.

**gen_v2.py (283 lines): the kit generator**
- The identity port, with 5 self-test vectors; it refuses to run if the port disagrees.
- `bake()`: the accent goes into `:root`, the seed onto `<body>`, and a provenance stamp.
- `replace_steps()`, `set_meta()`, `add_doors()`.
- Renderers: `r_teaching` (ATTUNE phase `1 − i/n`), `r_storybook` (silsila lamps, 36 px pitch; "The last lamp on the chain is not lit. It is yours. Touch the chain."), `r_twochairs`.
- A shallow contract validator. Slugs are NFKD ASCII, at most 80 characters.
- Report buckets: rendered / waiting / invalid / skipped.

**gen_forms.py (227 lines): the nine form exemplars plus `forms-contract.json`**

| form | exemplar | mechanism |
|---|---|---|
| practice | Belly Breathing | timer and orb, IN 4 / OUT 6; 120 s; begin / pause / again |
| walk | Thirty Days With Anxiety | cooldown 3 days; key `asg.walk.anxiety`; "The gate only ever opens; it never closes on you." |
| fieldguide | panic attack | |
| portrait | Ramana Maharshi | five moments (16, 17, 20s, 40s, 70); line "Ask who is asking." |
| map | The Nine Dimensions (Matías De Stefano) | 9 rings, r = 24 + i·26 |

The nine dimensions, as the map exemplar gives them:
1. Unity — "I know that I am."
2. Polarity
3. Experience
4. Time and Shape
5. Understanding
6. Creation — "twelve rays, the seven laws, the three essences"
7. Enlightenment — "The lost face"
8. Possibility
9. The Void — "I know what I am." "Nine closes the circle that one opened."

The map's line: "You do not go there. You widen here." Its source: "presented as memory, not evidence".

The remaining exemplars: twochairs (432/440 Hz), recipe (kombucha; jar and 8-day strip), calendar (Diwali, hour by hour; sun arc and 8 lamps; "Make the house ready. The light returns to where it is welcome."), and verse (the Gāyatrī, four lines with glosses).

**gen_practice.py (651 lines): chakra practice pages 21–33 from The Map (ASG base)**

The most app-relevant generator.
- **F:** about 60 field ids of The Map table. Examples: name `flduzeK6AkCogqC29`, hex `fldAsbQnAo3Fk2QHF`, voice `fldPFCAGzcorqrqHH`, avarana `fld5DcTBFS0Anwxrf`, sanskrit `fldUfO0k1sLhQZWnt`, verb `fldcG7GkZYFr7TYZd`, seed `flddjDTJBa0o4KyLS`, shakti `fld7N8l3F3r62sDZT`, shakti_desc `fld5sWbzoT3lySYgI`, mudra `fldO14JGMU9cAYulu`, bija `flduXNmHwo7YQwwEB`, freq `fld1lfG7r96PQGPxP`, witness `fldvHuQwNxgjsh4su`, letter `flduxpB6EM5tFRxUe`, underneath `fldBiFWEG8gWb06DE`, act1 `fldopinrnQ5W0T8kE`, gate `fld1rj2QuUuuGvvqc` (lines 11–28).
- **SCENE table** (lines 31–45): positions 21–29 are `innerfield`, each with a ground and three accents. Examples: 21 `#0E0A1F` with `#C98B3A #8E4A2E #5B3A22`; 25 `#0B0E22` with `#4B3F9E #233A8E #8C9AD8`; 29 `#140C1E` with `#F0A9A9 #A9F0C8 #A9C8F0`. Then 30 `veil` `#F4F1EC`, 31 `trikona` `#0F0A04` (labels **Will / Knowledge / Action**), 32 `field` `#0E1A0C`, 33 `morning` `#FBF6EA`.
- **The page shape:**
  - A hero: breathing dot 5.5 s; "Position n of 33 · system"; the verb in tracked caps; the threshold line.
  - Identity: sanskrit · title · essence · location · core question.
  - The teaching, with n-gram de-dupe against "Knows" (>0.4 overlap dropped).
  - The seed, then "Go deeper": The Frequency (bīja + freq) · In the Shree Yantra (avarana tag + Śakti + description + mudrā) · The Pair · The Colors · The Tree · From the Codex.
  - The practice, then the gate button (label from "Button: …"), then the writing (autosave 700 ms → "held"), then the reflection.
  - Post-engagement: "What {name} Knows That You Forgot", "Three Ways In", the story portal, the letter fold (once the story is seen) and the "Underneath" fold (POS ≥ 32 or `asg.egoReveal`).
- **Story mode.** Beats from act1, tap to advance with a 700 ms lock; the signature line; the veil with eyes that blink over 2 s; "press and hold to enter" (a **1,800 ms** ring); Act Two (white rising to the chakra gradient, 26 particles, witness paragraphs at **1.2 / 6 / 11.2 / 16 s**, "Go."); the threshold door in the next position's colour, "press and hold to walk through".
- **Position 33 Reveal.** The glyph 33 → 8 (3.2 s) → 8 turned 90° (6.4 s) → ∞ (8.6 s) → ♡ in `#C0392B` (11.4 s). The title flips "A Strange Chakra Map" → "**A Strange Love Map**" (13.4 s). The line: "**Every chakra was love at a register. Every archetype was love in a movement.**" (15 s). Then "The Road Home · Level 1 ends here. Level 2 begins here." (17.5 s).
- **Voice letter labels:** Higher Self "The One Speaks" · Gaia "The Ground Speaks" · Lalita "The Play Speaks" · Sakshi "The Witness Speaks" · Bindu "The Point Speaks".

**gen_door.py (114 lines): the Door**
- **LIVE positions 1–20 (line 7).** Name · title · hex · system:

  | # | name | title | hex | system |
  |---|---|---|---|---|
  | 1 | Bindu | The Origin | `#C9A84C` | ToL |
  | 2 | Muladhara | The Ground | `#B33A2E` | Energy |
  | 3 | Svadhisthana | The Tide Below | `#D8742A` | Energy |
  | 4 | Manipura | The Sealed Chamber | `#D9B531` | Energy |
  | 5 | Anahata | The Sound That Was Always Playing | `#6B8E4E` | Energy |
  | 6 | Vishuddha | The Passage | `#3A7CA5` | Energy |
  | 7 | Ajna | The Third Eye | `#3F3A8A` | Energy |
  | 8 | Sahasrara | The Crown | `#6A3D8A` | Energy |
  | 9 | Shadow | The Corridor | `#1B1730` | ToL |
  | 10 | Soles | Where the Soul Meets the Ground | `#B33A2E` | Body |
  | 11 | Forge | The Sealed Chamber | `#D9B531` | Body |
  | 12 | Prana | The Open Door | `#D8742A` | Body |
  | 13 | Hands | Where Love Becomes Action | `#6B8E4E` | Body |
  | 14 | Pulse | The Constant Broadcast | `#6B8E4E` | Body |
  | 15 | Sonar | The Sending | `#3A7CA5` | Body |
  | 16 | Echo | The Receiving | `#3A7CA5` | Body |
  | 17 | Vision | The Constructing | `#D9B531` | Body |
  | 18 | **Axis** | **The Blink** | `#1A0848` | Body |
  | 19 | **Crow** | **Crown Without the N** | `#6A3D8A` | Body |
  | 20 | Armin | The Room at the End of the Corridor | `#7BB661` | ToL |

  Positions 21–33 come from `map-planned.json`.
- **Dances:** return, dream, reach, release, still, howl, search, move, melt, rise, remember, shine, light, enough, lose, glow, arise, fade, wild, plus the chakra dances Muladhara…Sahasrara, Aatma, Maya.
- **The die:** scope chips; no repeat of the last pick.

**Guidebook generators**
- **gen_guide_v1.py (235 lines):** one page per structure, framed as "What it is · Why it exists · How it works · Where it lives · How to enter", plus laws. The Bindu Mandala entry (117–126) contains: "When a Shakti is recognized, two lines appear and never change: she was felt here — and she felt you back"; "The Well is a room for love letters, written by one hand only. Recognition is private. Nothing is counted on screen."; laws "No streaks, no gamification, no social." / "She is the subject. Always-already present before the tap." / "Iconography is aniconic. Her form is implied by what the room does to you."
- **gen_guide.py (73 lines):** v2, plain words for a friend.
- **gen_guide3.py (193 lines):** v3 corridor, with WORLD_CSS for 15 worlds. `bindu-mandala` uses world `yantra` (`#0D0508` ground, repeating radial rings in `rgba(201,150,63,.5)`, a breathing `#C9963F` point). Also the old BASE_CSS, which still has the body-scroll bug, and `readable()` (lifts an accent to luminance ≥ .32).
- **guide_content.py (143 lines):** the friend-voice content. Bindu Mandala's "Tuesday" (101–103): "I press and hold. Two lines appear and stay: she was felt here — and she felt you back. That's it. That's the whole practice."

**Learning, reading and teachings generators**
- **gen_learning.py (133 lines):** Learning records → storybook (ten sections parsed from `**Section n: title**` with `> affirmation`) and icebreaker (5 questions, FAQ, glossary, personas, a line to leave them with). Excludes Psilocybin and Ayahuasca. 25 palette colours, 10 worlds.
- **gen_research.py (124 lines):** four authored fables, ten pages each. Bashar — The Five Laws ("The Town of Mirrors") · Matías De Stefano — Gaia Is Waking ("The Cell That Wondered"; Ham · Het · Hum; Ater Tumti) · Dolores Cannon — The Three Waves · Bashar — The Splitting Prism. All story.
- **gen_reading.py (138 lines):** the Reading Space from `bindu-field.json`. Element hues: Earth `#C46A3A` · Water `#3A8BC4` · Fire `#E0762E` · Air `#7FB7A8` · Light `#C9B25A` · Crown `#B48BE0` · Soul `#D4A948` · Dissolution `#9B6BD6` · Meditate `#8A8FA8` · Threshold `#9B6BD6` · Family `#D4607A`. Tabs: Words · Frequency · Video · Lalita · The Seven Lenses. A strip showing element, chakra, brain state, carrier and beat Hz.
- **gen_teachings.py (121 lines) and teachings_more.py (117 lines):** 13 teachings `{one, opening, laws[[law, because, looks]], practice, close, source}`.
  - "A Mirror, Not a Master" (Bindu Being's 8 laws) and "Remember Them. Remember Yourself." (Lalita Family's 7).
  - The Two Clocks · One Gesture · Only True When True · Build the Slice · **Count in Private** (source: the Bindu Mandala guide; "Memory is allowed to know. The screen is not allowed to tell.") · The Note It Doesn't Play · Less Is the Point · The Hoop Doesn't Hurry · Blink. Breathe. Press. · **Not Repair — Birth** (the Shadow → Armin passage) · Wrong Time, Not Wrong Page.

**verify_walk.py (27 lines).** The walk gate, verbatim in A9.

### A8 · How the register maps onto the Mandala (the lens, in summary)

- **Energy core (direct app material):**
  - The Śrī Yantra cluster: L-1537, The Shri Yantra, Karshini L-1533, Ten Mahavidyas, Sri Vidya L-1454, Lalita Sahasranama L-1456, Shloks, Kali, Kashmir Shaivism, Advaita.
  - The spine cluster: 7 Chakras, Manipura, Kundalini, Kriya, Neidan, Microcosmic Orbit, Kabbalah.
  - The element wheels: Ayurveda, TCM.
  - The construction geometry: Vesica, Phi, Platonic solids and Metatron's Cube.
  - The sound and time cluster: Gayatri, Raga, Diwali, Karva Chauth, Kumbh, Mantra Science, Throat singing.
  - The stillness and passage practices for Beneath: Bardo, Phowa, Maranasati, Chöd, Dzogchen, Mahamudra, Vipassana, Tonglen, fire kasina, Anatta.
  - The breath and coherence practices for the Modes: HeartMath, Wim Hof, Sudarshan Kriya, the Breath Atlas, the 14 breath cards.
  - Gratitude and Ho'oponopono for the Well.
- **Story (Bindu Feed candidates):**
  - 81 portraits (sages, seers, scientists, poets).
  - 33 storybooks (cosmologies, traditions, passages).
  - 5 channelled law-cosmologies.
  - The 4 authored fables.
  - CERN (a father story).
  - Ego Death (position 32, sealed).
- **Learning (not the Mandala):** 276 therapy-course topics (lessons, skills, walks, field guides, debates, recipes). Only their *shapes* port (TIDE, the rope, STANCE).

### A9 · The handoff method: exactly how padakarshini hands a design to Claude Code and verifies it

This section is to be reused verbatim-in-spirit for the app's wave briefs.

**1. The pipeline (process.md):**

Register → ruling → Claude Design brief (topic field + the template brief) → Design returns one sub-template per family with hooks intact → "**Fold back into the generators and re-walk before Code sees them**" → Claude Chat review (REVIEW.md: fit, voice, honest turn, endings, route changes) → Claude Code.

Code "authors into contracts (record content → own knowledge → search), renders, verifies, commits one form per batch, writes each build to the Builds table with URL and status." Git is the spine: "Push to `main` only after the walk passes."

**2. The CLAUDE.md handoff file (claude-code-handoff-template.md, sections in order):**
1. "You are continuing a build that was designed and proven … **Do not redesign the forms; run them at scale.**"
2. What this is.
3. The forms table (form · its one mechanism · exemplar path).
4. Where the renderers live.
5. The register schema, and "`hold` = do not build … no placeholder pages."
6. The figure principle ("locked Sept 22").
7. Authoring rules, numbered:
   1. Source order: the record's own fields (with exact field ids) → own knowledge (ruled 27 Sept a full source) → web search only for unsure facts. Never invent quotes or reproduce course text.
   2. No field vocabulary.
   3. Attribution of claims.
   4. Wellbeing exclusions.
   5. "Only true when true."
   6. One piece per screen (~700 px at 390, at most 3 list items per screen).
   7. Readable accents.
8. Process, depth-first: "Author THREE topics … Render. Walk … Fix. Only then run the rest", with order and output paths.
9. Airtable: every base, table and field id the build reads or writes; the Builds table write (batches ≤15, `typecast:true`, "always set Build Status").
10. Deploy, with a dated **"Superseded"** note ("Don't assume any site's deploy path from a prior session's notes — confirm it fresh").
11. "What was already built today (do not rebuild)."

**3. HANDOFF-CODE.md order:**

**Run it first** (`--check` first). State plainly what has never executed; "Expect small breakages elsewhere; fix them, don't redesign."

Then a bundle table (path → what), then "How a page is made":
1. **bake**: copy the template; write the identity into `:root`, the seed onto body, a provenance comment.
2. **render**: if a content file exists and validates, swap the steps and fix `#count`, title and description.
3. **doors**.
4. **write**: the page plus `report.json` (rendered / waiting / invalid / skipped).

A page without content is still written and reported `waiting`, "so coverage is visible from day one."

Then: renderers done and to build (largest first; "**`r_teaching` is the pattern**", "template surgery on a proven file"); the template → step `data-*` → hooks table; "Watch for" traps per shape; and Gates.

**4. The gates (HANDOFF-CODE §5, verbatim):**

"Per page, at 390×800 (headless Chromium): every step's piece bottom ≤ 744 and step height ≤ 800; every button/link ≥ 44×44 (the calendar lamps are a known 42px exception); `#count` = step count; **scroll to the last step and assert `#count` = N / N with `.on` on it** (catches a page that cannot scroll — see CONTRACT-DELTA §6f); no console errors; hooks present (`#w #count #hint .step .piece`). Contrast: every accent in every pool × every ground via `--actext` ≥ 4.5:1 — `kit/gate.js` has the checks. **Never test stateful play by clicking a real choice** — storage is shared with the reader's view."

**5. The headless walk (verify_walk.py, verbatim logic):**
- Chromium; viewport 390×844, device scale 1, `is_mobile=True`, `has_touch=True`.
- For each file: collect `pageerror`; `goto file://`; inject `html{scroll-behavior:auto!important}`; wait 300 ms.
- For each `.step` i: `scrollIntoView()`; wait 120 ms; read `{on: classList.contains('on'), op: opacity of .piece, h: step height, ph: piece height, cnt: #count text}`.
- Fail if not `on`. Report as tall if `ph > 844 − 140` (704 px). Record JS errors.
- Print: "pages N steps walked T failed to light B pieces taller than a screen K".

**6. The contrast gate (gate.js):**
- Bars: body 4.5, display 3 (≥24 px or ≥18.66 px bold; "22px/400 is NOT large text"). The mix is 0.50 oklab against `#191919`.
- `checkTemplate` measures the accent-as-text against the page ground.
- `checkCards` treats every card surface as its own ground (`.page` against `#F2EADB`; `.wcard`/`.card` translucent, so they are skipped rather than guessed), and composites alpha ink onto the real backdrop before measuring.
- `checkChrome` measures fixed chrome against the gradient stop nearest its edge and fails any alpha ink there.
- `checkPool` runs every accent against 4 paper stocks before an accent is added to the set.
- The measured choice: oklab at 50% gives 5.39:1 with 2.2° of drift.
- The law: "**TEXT MEASURED AGAINST A BACKDROP IT DOES NOT TOUCH** … the first question is which pixels are actually behind the glyph."
- Capture caveat: screenshots place fixed elements at document coordinates, so drive `ASGfig` at scrollY 0.
- Stateful play: read the key first, drive state with a throwaway key, and if a real key was written, reset it to the app's own empty value, not by deleting storage.

**7. Proof beyond the gates (elements 6.3, 6.5, 6.9, 6.11, 6.12):**
- **The bench:** review controls outside the device, never shipped.
- **The harness:** every family beside a live render at 390 and 1280.
- **The parity pass:** 3–5 feel anchors per screen. Failure modes are phase drift, range compression and detail erosion; "the running prototype outranks prose".
- **Ship with proof:** "66 checks across nine registers (canon, coverage, distinction, legibility, promise, felt, coherence, brief, iconography)", with detectors for numbers about the walker, every datum traced to source, no two siblings alike, "nothing from an earlier build vanished".
- **The adversarial pass:** a prohibitions audit, register integrity, three cuts rather than additions.
- **The five-track score:** before any build.
- **Compare two answers on one device.**
- **The lineage of mechanics:** four marks, so "nothing earlier vanishes unrecorded".

---

## B · Gifts for the upgrade

Each gift gives: what it is · source · world(s) · how it works there · what it needs · E/S.

### B-I · From the topic field (lens 1)

| # | Gift | Source | World(s) | Mechanism in the app | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **Learning-table depth on every ring and seat**: the Śrī Yantra Full Architecture record (102 Śaktis / 9 āvaraṇas, Khadgamālā research) | register #26 (L-1537, Completed); topic-field:142 | M, N, HH | The record's FAQ, Glossary, Personas and Objective fields become the "Go deeper" shaft stations (elements 1230–1236) for each ring: element, body location, roots of the name, quality, phrase. Read-only. | Airtable Learning record `(L-1537)` fields (ids in the handoff template, line 57); a mapping table ring → record section | E |
| 2 | **The 16 Karṣiṇī as a teaching layer under ring 2** | register #324 (L-1533, Active); routing map/rings and teaching/other | N (ring 2), HH | Ruling 7 keeps the 16 functions. The Learning record supplies a second voice (what each Karṣiṇī attracts), shown under each seat's own name, never replacing the Mandala table's text. | The L-1533 record; a join on seat name | E |
| 3 | **The Ten Mahāvidyās as a sister set** (a gate or a Beneath room) | register #403; map/rings and teaching/other | B, HH, G | A ten-station descent in the Gates-of-release grammar (A4/G33), each station named, never drawn; or ten Leela squares. | Authored research (Start Exploring, no L-id); Ashrey's ruling on whether ten outside presences belong | E |
| 4 | **The nine dimensions as a reading of the nine rings** | gen_forms.py:123–125; register #228 (L-1387) | N, M | A toggle lens on the rings ("another map's nine"): numeral and gloss per ring ("I know that I am" … "I know what I am"); line "You do not go there. You widen here." Labelled "as he describes it". | Fable content stays in Feed; only the 9 glosses (authored) | E/S (the gloss is a lens; the Atlantis narrative goes to Feed) |
| 5 | **Lalita Sahasranāma as the garland mode** | register #273 (L-1456); FALLBACKS:46; elements 1293 (garland) | MO (garland), R, HH | The Eight Modes' garland: names arrive ring by ring inward, each name a line, from the Mandala table's own names (not the 1,000; only the 102 seat names, or the Sahasranāma only if Ashrey rules it in). | Verbatim name list; no generated text | E |
| 6 | **The Gāyatrī at the three junctions** | gen_forms.py:202–205; register #197 | T (dawn/noon/dusk), R | The Temporal Layer's three junctions as small practices; the verse sounded line by line with gloss (the verse form: one line per screen; "Not 'give me.' 'Light the mind.'"). | Junction times need place + ephemeris (C-guard); verse text public domain | E |
| 7 | **Raga by the hour** | register #418; verse/raga | T | The hour wheel colours each hour band with its rāga mood (morning, dusk etc.); tap a band for a one-line mood. | An authored, checked table of 8 prahara × rāga families | E |
| 8 | **Festival days on the Time world** (Diwali Lakṣmī pūjā at dusk; Karva Chauth moonrise; Kumbh) | gen_forms.py:181–186; register #62, #343, #230 | T, R | The ARC figure (sun across, 8 lamps, lamps lit from dusk `i>=5`) as the Time world's festival day: on a festival date, Today's Rite carries the day; the EMBER grace ("the lamps burn down one by one; someone watches the last"). | Lunar calendar (real ephemeris); dated table | E |
| 9 | **The spine cluster as the Climb's centres** | register: 7 Chakras #370, Manipura #32, Kundalini #254, Microcosmic Orbit #481, Neidan #494, Kabbalah #411 | C, 33 | SPINE figure with traditional petal counts 4·6·10·12·16·2 + thousand (FIGURES.css:149–156); an `n` and `loop` mode (HANDOFF-CODE:101–103) lets the Microcosmic Orbit be a loop and Neidan three dantians: alternate "maps of the body" lenses on the Climb. | SPINE port to SwiftUI Canvas; per-lens node lists | E |
| 10 | **Element wheels (Ayurveda doshas, TCM sheng/ke)** | register #442, #463; FIGURES GRID | MO, T | The GRID figure (sheng solid rim, ke dashed star; live phase lights only its two outgoing arrows; characters counter-rotate) generalised to the app's own element law (ruling 4: Ahaṅ fire, Nāma air, Ātma light, Amṛta water) to show feed/restrain relations between elements in the Modes. | Ashrey's ruling on which relations exist between the four app elements | E |
| 11 | **Construction geometry: how the yantra is drawn** | register: Vesica #454, Phi #493, Platonic #498; FIGURES POLY | M | POLY's "a construction that builds, in the order you'd draw it by hand", every stroke `pathLength=1`: the yantra draws itself line by line (bhūpura, petals, 9 triangles, bindu) on deep zoom; slow turn at grace (80 s). Pairs with the Chakra Game's Śrī Yantra trace (18 lines, 22 px tolerance). | Yantra path data in drawing order | E |
| 12 | **Beneath's practices** (Bardo, Phowa, Maranasati, Chöd, Dzogchen, Mahamudra, Vipassana, Tonglen, fire kasina) | register (Start Exploring set); routed practice/stillness WATER | B, MO | WATER figure (`data-calm` 0→1, ripples settle; typed thought rides a leaf off and is never stored) as Beneath's floor; the PATH figure for the Bardo's stations (road drawn faint in full, walked part draws in, end runs off the band). | Authored, attributed practice text (or shapes only until authored) | E |
| 13 | **Anatta, held against every map** | register #426 (W20) | B, H | One screen at the bottom of Beneath: the map-and-no-map corrective; pairs with Maya's last line "only You, playing" (ruling 8). | One authored screen | E |
| 14 | **Breath and coherence library for the Modes** | register: 14 breath cards, HeartMath, Wim Hof, Sudarshan, Breath Atlas L-1536 | MO | The ORB (quiet .52 / open .78 / now 1 / grace 1.5; IN 4 / OUT 6 timer) + Coherence game (breath pad and heart pad merge > 0.82) as the Mode "breathe". | Breath Atlas content (own framework) | E |
| 15 | **Frequency honesty for the app's own tones** | register: 432/440, Solfeggio, Schumann; Frequency Atlas L-1535; elements S·T·C | MO, sound | Every tone the app sounds (bells 392→196 Hz, 136.1 Hz drone, Solfeggio ladder) carries a tap-to-open S·T·C badge (science · tradition · claim). | Badge copy per tone | E |
| 16 | **Ho'oponopono and Gratitude for the Well** | register #419, #207 | W, RF | The Well's letter form gains two optional closing gestures: four lines to a lineage (sorry · forgive · thank · love), and the gratitude line ("Gratitude is the medium"). | Ashrey's ruling; authored lines | E |
| 17 | **Family Constellations / Ancestral trauma as the Relationship Field's shape** | register #504, #425 | RF | The idea of a constellation of places (who stands where) informs RF's layout: people as positions around her, distance as relation; STANCE's five positions (all · against · merged · apart · beside) as the vocabulary of where one stands. | RF data; ruling 10 says build in full | E (shape) / S (the people's stories → Feed) |
| 18 | **Story topics → Bindu Feed** (81 portraits, 33 storybooks, the channelled cosmologies, 4 fables) | register; gen_research.py | — (Feed) | Flagged, not dropped: each is a candidate Feed "transmission" (Feed already reads Codex as third-person story). The research fables' ten-page structure (title · affirmation · text) is Feed-ready. | Feed ruling | S |
| 19 | **Ego Death → position 32 (sealed)** | register #167 | 33 (#32) | Its storybook stays out; position 32 is the Ego Reveal (Gaia) and its words stay sealed (ruling 2). Only the fact of the seal is shown. | — | S (sealed) |

### B-II · From the engine, the figures and the elements (lens 2)

| # | Gift | Source | World(s) | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 20 | **The 33 positions' data** (1–20 names, titles, hexes, systems; 21–33 from The Map with ~60 field ids) | gen_door.py:7; gen_practice.py:11–28 | 33, C, H | The braid reads exactly these: verb, threshold line, essence, location, core question, seed, practice, gate label, writing prompt, reflection, Knows, Three Ways In, act1 beats, witness, letter (voice-labelled), underneath (sealed for 32), bīja, frequency, Śakti + description + mudrā + avarana. | The Map table field ids (verify live; Mandala app's own schema law governs) | E (beats/witness/letter are story-shaped but are the chakra's own baked text: keep verbatim) |
| 21 | **The braid's story mode** | gen_practice.py:427–576 | 33 | Beats tap-advanced (700 ms lock) over a scene → signature line → veil with blinking eyes → 1,800 ms hold enters Act Two (witness lines at 1.2 / 6 / 11.2 / 16 s, "Go.") → threshold door in next position's colour, hold to walk through. Port with G0 (held key, not instant Enter). | Scenes per position (innerfield / veil / trikona / field / morning) | E |
| 22 | **Five scene vocabularies for 21–33** | gen_practice.py:31–45, 582–645 | 33, B | innerfield (lid vignette, 40 particles, three blurred orbs drifting with `--k`, the point); veil (tree behind four parting sheets); trikona (triangle drawing itself, vertices Will · Knowledge · Action lighting beat by beat, centre at beat 4); field (ground breathing 7 s, three rings widening); morning (dawn gradient, sun rising, 22 gold motes). | SwiftUI ports | E |
| 23 | **The 33 Reveal** | gen_practice.py:147–153, 546–558 | 33 (#33), H | 33 → 8 → 8 turned → ∞ → ♡ (`#C0392B`); "A Strange Chakra Map" → "A Strange Love Map"; "Every chakra was love at a register. Every archetype was love in a movement."; "Level 1 ends here. Level 2 begins here." Then hold to walk to the Road Home. | Verbatim text; timings 3.2/6.4/8.6/11.4/13.4/15/17.5 s | E |
| 24 | **The hold engine G0** (one engine for every hold) | elements 483–510 | all | `tick` with asymmetric UP/DOWN, lock at 1; constants per hold (Turning 2,900/750; Compose 2,300/620; Readiness 750; Point gate 1,100; Immersive 5,000; story ring 1,800); held Enter/Space completes; tap never does unless designed; reduced motion keeps duration. Run on CADisplayLink. | One Swift `HoldEngine` | E |
| 25 | **Breath slows toward the centre** | elements 1275–1280 | N, M | Each ring's breathing period: outer 3.5 s (petals 4.5/6/7.5/10 s, slower the less met), 8 s, 9/11/13/15 s (counter 10/12/14/16), innermost 18 s, centre 4 s. | Per-ring period table | E |
| 26 | **A bell lower at each ring inward, silent outward** | elements 1260–1265 | N | 392.0 → 349.2 → 329.6 → 293.7 → 261.6 → 246.9 → 220.0 → 196.0 Hz for rings 1–8, partials decaying independently; nothing on the way out. | Audio synth | E |
| 27 | **Light, never locks: five tiers** | elements 1282–1288 | M (Veil), N, C | Every seat/ring/position shows its tier only by light (You are here / Open / Ground / Ahead / Veiled), dashed rule for ahead; Veil dims image to ~55%. | Tier from App Activity ledger | E |
| 28 | **The interface thins inward** | elements 1267–1273 | M (deep zoom), H | Chrome 100→80→60→25→0% across five depths; the point grows to 26×; hold the point 0.9 s to reach the source (ruling 9: deep zoom into the Bindu). | Depth state | E |
| 29 | **Staying opens a deeper turn** | elements 1222–1228 | HH, C | Room clock 62 s first change, held to 227 s, reversal by 347 s; never told to wait. | Per-room reversal mechanism | E |
| 30 | **Memory felt, never shown** | elements 1208–1213 | HH, ME | Dwell-based head start `min(dwell·0.55,221 s)` above 12 s; entry shortened `max(0.36,0.68^min(visits,4))`; "you have stood here before" once; forget me. | Dwell per room in ledger | E |
| 31 | **Readiness sensed, crossing chosen** | elements 1253–1258 | RF, HH | Four relationship levels, readiness thresholds 0,1,3,7 felt moments (never shown); "hold to cross into …" only when ready; 750 ms hold + 12 ms haptic; status opacity 22/44/76/100%. | Ledger counts | E |
| 32 | **Rooms made by rule** (102 rooms from 8 mechanisms + each card) | elements 1328–1334; 1215–1220 | HH | Ring → archetype; card's quality → physics, body location → altitude; one held attribute is the moving actor; carrier = interval above ring root, one interval withheld until a long stay; room test "could this room belong to any other?" | Mandala table cards | E |
| 33 | **Open on one being; element layouts; relit by hour** | elements 1245–1251 | R, H | Today's Śakti by seeded walk (day turns at 6 am), six element layouts (fire ascension … light radiance), per-being mood hash, relit dawn/noon/dusk/night; one pill to recognition; "What did you notice?" | Element per seat; ruling 4 elements | E |
| 34 | **Time as orbits round the point** | elements 1298–1304 | T | Five wheels (hour, tithi ×30, nakṣatra, ṛtu ×6, sidereal sun) each with one lit bead; three junction practices; lunar month in four atmospheres; a 365-day wheel lit by how often met. | Ephemeris + place | E |
| 35 | **The Eight Modes as the day's structure** | elements 1290–1296 | MO, T | Morning question before noon; behold (phone still: 3 s / 30 s / 2 min); catch (long press); garland; silence captions 7/14/21/28 s; evening offering released by hold (irreversible, so early release keeps). | Motion sensor, sunset by place | E |
| 36 | **Codex gestures** | elements 1306–1312 | all | Tap ring = in; tap centre = silence; long-press ring = remember; pinch out = recite; phone upright and still = behold; swipe up = today. Ruling 10: the menu now exists *beside* these. | Gesture layer | E |
| 37 | **The Door's two weathers + no lobby** | elements 208–259 | H, R | Launch arrives at the Bindu (ruling 1) in unmet (pre-dawn wash from above, C = today's colour) or met (after-light warmth low) weather from the day's App Activity; "touch to receive" then Today is the first door. | Today's colour; ledger | E |
| 38 | **The rope (rest from anywhere)** | elements 335–358 | H (overlay) | Long press 1.1 s anywhere: black, ember in a 110 px breathing ring, two breaths before words, one reassurance line, two exits. Copy must be authored for the Mandala (not the Feed's line). | Authored line | E |
| 39 | **The turn (menu hidden until asked)** | elements 304–333; 736–758 | H (menu) | Ruling 10's always-available menu as the Feed's WHERE TO list: rows = the fifteen worlds, each with a mark, italic line and threshold Hz; unbuilt rows dimmed with text; slow pull or the 2×2 dot mark. | Row table | E |
| 40 | **The blink crossing** (one named crossing) | elements 288–302 | H→R | Lids close 0.66 s, seam glints in destination colour, navigate at 780 ms: used only for Bindu → Today's Rite. | — | E |
| 41 | **Threshold kinds before entering** | elements 373–397 | R, H | Weighted 40/23/20/12/5, never twice in a row: a threshold line, a breath, a body-weather seed, "what found you" (a real seat), the dot alone. | Authored lines | E |
| 42 | **Hold to release / the prompt that recedes / released** | elements 574–623 | W | The Well's letter is sent by a 2,300 ms hold of one's own mark (armed only with text); prompt recedes to 0.45; card settles; one line ("The room has changed." or the Mandala's own); no staged replies. | Canon line for the Well | E |
| 43 | **Your own words newest first, ending "this is where you began"** | elements 625–643 | W, ME | The Well's reading view. | Ledger of letters (private) | E |
| 44 | **Your colour today** (8 moods) | elements 645–667 | R, H | A chosen colour of the day lights the Rite and Well; record carries its date. | Device key | E |
| 45 | **A portrait made of attention** | elements 1344–1350 | ME, HP | Petals lit by how often each Śakti was met; a year as a concentric ring; span first→last per relationship; "the image itself is the only measure". | Ledger | E |
| 46 | **A mandala made of your record** | elements 1543–1548 | ME | Outer ring 365 day-segments (practised days lit, today white, turning 0.00055 rad/frame), 108 ring, traces as petals; save as image. | Ledger | E |
| 47 | **The 108** | elements 1366–1372 | G, MO (japa) | Four rings of 40/32/24/12 beads, lines join after 54, lit beads are the record, no number. | — | E |
| 48 | **Trace the yantra line by line** | elements 1445–1449 | G, M | 18 lines, ends within 22 px either direction; progress kept. | Yantra lines | E |
| 49 | **Leela board** | elements 1746–1750, 1790–1795 | G | Hop with tick; rises 330→660 Hz, returns 247→123 Hz; six to enter; exact landing; each landing opens the chakra's energy room (ruling 5); "my life / what I'm building" toggle; source named on the board. | 33-square board | E |
| 50 | **Mini-game catalogue as Leela landings** | elements 1362–1504 | G | Each game its own world: Seed (2/8/24/72 h), Corridor (800–1,200 ms), Coherence, Mantra tuner (396…963 Hz, tempo f/8), Drum (1 Hz ±180 ms, 20 layers), Fire (0.18/frame, +22, band 15–82, 60), Water level, Root system, Twelve, Missing petal, Body map, Spine walk, Shake to clear, child games. | One engine | E |
| 51 | **The procession of voices → the dance's archetypes** | elements 122–128 | 33 (dance), G | Ruling 6: the dance names every archetype. Each voice a full-screen scene in its colour with name, role, glyph; tone `(4+3.6·lines)` s; finale ring round the ember. | Archetype table | E |
| 52 | **Sound: answering sounds, two roots, ceiling** | elements 196–202, 1561 | all | Strain/give/tune-in (1.5% flat over 4 s)/stillness tone/reveal chord 136.1·272.2·408.3; drone 136.1 Hz with octave/sub, 0.004→0.012 under a still finger, 0.05 Hz; master ≤ 0.075; never on load. Ruling 10 lifts "one sound at a time". | Audio engine | E |
| 53 | **Haptic family** | elements 944–950 | all | Tick ~0.3/0.4; ramp 0.15→0.6 then 0.8/0.5 commit; descent 0.9/0.15; fade on early release; haptics off switch. | Core Haptics | E |
| 54 | **The Waking (launch through its own mark)** | elements 866–872 | H | 2.85 s; ember ×1.32 at 1.65 s; bloom from that point; never blocks input; optional 110 Hz tone. Then the deep zoom into the Bindu. | — | E |
| 55 | **Corridor engine as the reading grammar for teaching rooms** | CORRIDOR.js; BASE.css | 33 (practice), B | One piece per screen, snap, nearest-centre activation, `--p` progress, remember-where-you-were (back-to-where-you-were navigation). In SwiftUI: a paged `ScrollView` with `scrollPosition`. | — | E |
| 56 | **FIGURES as room figures** | FIGURES.css | per world | RINGS (nine rings, live ring numeral, scale ≤2.3×) → nine rings world; SPINE → Climb; ORB → breath mode; ARC → Time day; WATER → Beneath; TIDE (6 breaths/min, hold raises, 8 s exhale) → Modes; PATH → Bardo/Beneath; LADDER (two rails, rung per day) → Relationship Field's shared practice; SEPARATION (sky/earth parting, light only where the world is made) → the cosmology lens; PAGE → the Well's letters as a book. | Ports | E |
| 57 | **Identity hash for stable per-entity colour/seed** | identity.js | all | FNV-1a over the normalised name → seed for figure variation (ring rotation, node jitter) that must be stable but not uniform; never for legibility. Mandala seats have their own hex; the seed alone is useful. | — | E |
| 58 | **GRACE: every world ends on a gesture** | GRACE.md | all | One closing gesture per world (WIDEN for the rings: "you do not go there, you widen here"; RETURN for the Climb; EMBER for Time; SOUND for verse); no two adjacent worlds end alike; END STATE under reduced motion. | Gesture table per world | E |
| 59 | **"Count in Private"** | teachings_more.py:46–54 | all | The display law as a teaching: storage may count, the screen may not ("Memory is allowed to know. The screen is not allowed to tell."). | — | E |
| 60 | **"Not Repair — Birth"** (Shadow → Armin) | teachings_more.py:99–107 | 33 (#9, #20), B | The two-passage teaching (corridor and room) as Beneath's framing line for Shadow. | — | E |

### B-III · The handoff method for the app's wave briefs (lens 3)

| # | Gift | Source | Use in Bindu Mandala waves | Needs |
|---|---|---|---|---|
| 61 | **CLAUDE.md wave brief skeleton**: "do not redesign; run at scale" · what this is · the forms (here: worlds) table with one mechanism each and the exemplar · where code lives · data schema + hold list · locked principles · numbered authoring rules · depth-first process (three, walk, then rest) · every Airtable id · deploy with dated "Superseded" notes · "already built (do not rebuild)" | claude-code-handoff-template.md | One brief per wave on the wave branch | Fill per wave |
| 62 | **HANDOFF-CODE order**: run it first (state what has never executed) → bundle table → how a unit is made (bake · render · doors · write + report with `waiting`) → renderers to build, largest first, "X is the pattern" → template/data/hooks table → per-shape traps → gates → then | HANDOFF-CODE.md | Wave brief body | — |
| 63 | **The walk gate, for iOS**: XCUITest (or a SwiftUI preview harness) on iPhone 15/SE sizes walking every step/room: each lit (`.on` analogue = accessibility value), no runtime warnings, every tap target ≥ 44 pt, content fits (bottom ≤ screen − 56 pt), scroll-to-last asserts the last step is active, the hold engine completes by a held key/press of the designed duration and does nothing on tap | verify_walk.py; HANDOFF-CODE §5; process.md:31 | Xcode Cloud "Waves test" step before main | XCUITest target |
| 64 | **Contrast gate** in Swift: every seat hex × every ground via an accent-as-text mix (oklab 50% vs #191919 on light; raw on night) ≥ 4.5:1; cards measured as their own ground; chrome over gradients with solid ink | gate.js | Unit test over the Mandala table's hexes | Port of `mixOklab`/`ratio` |
| 65 | **The bench and forced states** (review toggles outside the device; state forced from the harness, never a URL/launch arg that ships) | elements 360–371; 34–40 | Debug-only state panel (met/unmet day, depth, tier) | `#if DEBUG` |
| 66 | **Ship with proof, run backwards**: N checks across registers (canon, coverage, distinction, legibility, promise, felt, coherence, brief, iconography); detectors for any number about the walker; every datum traced to source; no two siblings alike; nothing from an earlier build vanished | elements 1314–1319 | A `ProofTests` target per wave | — |
| 67 | **Parity pass** (3–5 feel anchors per screen vs the Design prototype; phase drift, range compression, detail erosion) | elements 960–965 | Port every Design frame with its numbers; "build to the numbers, not the frames" | Design exports |
| 68 | **Adversarial pass + five-track score + side-by-side compare + lineage of mechanics** | elements 1587–1599, 1709–1714, 528–543, 760–770 | Before each wave: score every moment; after: prohibitions audit, three cuts; record what each earlier mechanic became | — |
| 69 | **Never test stateful play by clicking a real choice** (read key, throwaway key, reset to app's empty value) | gate.js:192–197; HANDOFF-CODE:114 | Tests never write to App Activity / Codex live tables | Test base or mock |
| 70 | **Report with `waiting`** (coverage visible from day one) | gen_v2.py:248–280 | Each wave's report lists every world/room: rendered / waiting / invalid | — |

---

## C · Conflicts and gaps

1. **The Relationship Field was "left behind (held)" in padakarshini**, in two places: lineage-2026-09-30:104 and elements:1922 ("The Relationship Field → left behind (held)"), on the map's ruling 2 (family and life data). Ruling 10 (12 Oct) says it is built in full. The skill's ledger predates the ruling. The app supersedes it, but padakarshini's lineage should be annotated.
2. **"There is no menu"** (elements:1306–1312, Codex) and the Feed's hidden-until-asked turn both predate ruling 10, which lifts "no menu". Carry the gestures and add the always-available menu beside them. Elements:1312 already guards for "a visible list of places beside the gestures (G42)".
3. **The Ego Reveal (#32) leaks on the site.** gen_practice.py:490 shows the "Underneath" fold for `POS>=32` or once `asg.egoReveal==='1'`, and line 540 sets that flag after #32's story. Ruling 2 says #32's words stay sealed. The app must not port the Underneath fold for 32. Check what the site serves today.
4. **gen_practice.py's holds break the holds law.** `holdable()` (522–529) completes **instantly on Enter/Space**; process.md:31 and elements G0 require a held key for the same duration. It also uses a CSS 1,800 ms transition and a timer rather than the engine. Do not port as written.
5. **Two hex collisions and a duplicate title among positions 1–20** (gen_door.py:7):
   - Hex collisions: Manipura and Forge both `#D9B531` (and Vision); Anahata, Hands and Pulse all `#6B8E4E`; Vishuddha, Sonar and Echo all `#3A7CA5`; Muladhara and Soles `#B33A2E`; Svadhisthana and Prana `#D8742A`; Sahasrara and Crow `#6A3D8A`.
   - Duplicate title: Manipura and Forge are both titled "The Sealed Chamber".
   - These may be intentional system echoes (Body chakras echoing Energy ones). Verify against the Mandala/Map tables before using hex as identity.
6. **Axis and Crow.** gen_door.py names 18 Axis "The Blink" and 19 Crow "Crown Without the N", both in the Body system. This agrees with ruling 3. guide_content.py:21 ("…the blink") is consistent.
7. **FIGURES.css SEPARATION reintroduces the reserved-name bug.** It defines `.light{position:fixed;inset:0;…}` (FIGURES.css:726), the exact bug CONTRACT-DELTA §6f names; `.light` is the night-ground body class. Any page that loads SEPARATION with `<body class="light">` freezes. Gate it before porting the pattern.
8. **FIGURES.css cannot be concatenated whole.** The SPINE, TREE, GRID, POLY, BAND, TIDE, PATH, RECEPTION, DISTANCE, LADDER, STANCE, COUNT, SCAN, WATER and SEPARATION blocks are not scoped under `.fig-*`. They restyle global `.w`, `.step`, `.piece`, `#grip`, `#hold`, `.ring2` and `.tlab` (and `.ring2`/`.tlab` are defined twice). Only one family block may load per page.
9. **Numbers that disagree across files:**
   - The scale cap is "2.4x" in the FIGURES.css header and 2.3× in CONTRACT-DELTA §7.
   - The accent mix is 55% in CONTRACT-DELTA and ROADMAP; 50% oklab in BASE.css and gate.js. The gate.js header also says "OKLCH mix" while the code mixes in oklab. BASE and gate (50% oklab) are the latest.
   - The verify viewport is 390×844 with a tall bar of 704 px (verify_walk.py) against 390×800 with y ≤ 744 (HANDOFF-CODE).
10. **REVIEW route changes were not all applied to routing.json:**
    - Throat Singing is still practice/senses (routing.json line 474 region).
    - The 18 walk/any course stubs still render (REVIEW asked for hold).
    - `open:true` for living subjects is not in contracts.json.
11. **The routing data has its own oddities:**
    - Fascia is double-moved (map/spine → teaching/mind-body *and* teaching/other → map/spine).
    - CERN's register primary is storybook, but its storybook instance is "covered" and map/other renders.
12. **Two ending lists:** MOVES.md's per-form grace table and GRACE.md's 28 per-family gestures. GRACE.md is the later, checked one (0 clashes).
13. **Walk cooldowns contradict each other:**
    - gen_forms.py: 3-day cooldown, "You cannot binge it. That is the design."
    - site-v3.md: "The walk form ships with every day open".
    - Lineage 11 Oct: "Law 5 … the walk form's designed cooldowns are settled history and stay."
    - Not Mandala-critical, but the time-gating doctrine is unsettled across the estate.
14. **Seed syllables and Devanāgarī** are forbidden *on the site* (lineage:80–81). The app's floor is "nothing invented (bījas, baked text verbatim)": the app may show real bījas and script. gen_practice.py already shows bīja in Go deeper and falls back to `ललिता · Lalita`. Do not import the site restriction into the app.
15. **Learning App gating contradicts itself.** guide_content.py:84 says it "locks the next chapter for three days"; lineage 99 says that app's doctrine is "nothing is ever locked". This is Feed and Learning lore, not Mandala.
16. **Referenced but not in my assignment:** `references/gestures.md` (G0–G50), `references/forms.md` (A1–A14, B1–B4, C, D, E, F) and `references/forms-contract.json`. Elements entries point into them for full specs (G2, G9, G11, G14, G15, G17, G33, G35, G39, G49 …). If no other reader has them, they are the missing half of B-II.
17. **gen_v2.py has never run** in Design (HANDOFF-CODE:16). site-v3 says Code's own engine shipped 621 pages and gen_v2 is reference only. Only 3 renderers exist (6 families); the remaining 35 families are "waiting".
18. **Register gaps.** 115 topics have no L-id (entries 397–511), so the app cannot link them to an Airtable record by L. The register is a snapshot ("data/learning-full.json"); its status values may be stale against the live Learning table.
19. **The Mandala-native Learning topics are thin.** The Ten Mahāvidyās, The Shri Yantra, Kali, Kashmir Shaivism and Advaita are "Start Exploring" with no L-id. Only L-1537 (Completed) and L-1533 (Active) have depth to read from.
20. **Designed but unbuilt** (elements 6.9, as listed against the app's foundation): Time as orbits (needs an ephemeris), the Eight Modes (needs a place for sunset), the five tiers of light, the bell inward, breath slowing toward the centre, and the interface thinning. These are all designed with numbers and are candidates whether or not the current build has them.

---

## D · Coverage proof

Method key: **R** = Read tool, every line. **F** = flattened or pretty-printed to scratch and that file read in full. **S** = structural read with `python3 -I` (keys, types, counts, a full diff against a file read in full).

| file | total lines (`wc -l`) | lines read | method | md5 (first 8) |
|---|---|---|---|---|
| references/asg-topic-field.md | 296 | 1–296 | R | f5abbc20 |
| references/asg-learning-register.json | 4600 | all 511 entries | F (`register-flat.txt`, 534 lines, read 1–534; all 7 keys per entry kept, "why" coded W0–W22 with the 23 strings in full) + S (counts) | 38762243 |
| references/design-pass/CONTRACT-DELTA.md | 271 | 1–271 | R | d419d736 |
| references/design-pass/FALLBACKS.md | 176 | 1–176 | R | bb8f8de1 |
| references/design-pass/HANDOFF-CHAT.md | 170 | 1–170 | R | 879d48fa |
| references/design-pass/HANDOFF-CODE.md | 120 | 1–120 | R | 6cde2055 |
| references/design-pass/REVIEW.md | 39 | 1–39 | R | 59f045c0 |
| references/design-pass/ROADMAP.md | 163 | 1–163 | R | 1a993b59 |
| references/design-pass/_fit_moves.json | 156 | 1–156 | R | 9680181e |
| references/design-pass/_instances.json | 0 (one line, 77,705 bytes) | all 916 records | S: every record has exactly `{name, form, family}`; compared in order with routing.json, which was read in full; 57 differ, each listed in the run output and equal to the re-routes | 9a7b385e |
| references/design-pass/_template_table.md | 32 | 1–32 | R | 8ad48548 |
| references/design-pass/content-example-5-empathic-listening.json | 40 | 1–40 | R | da689d1c |
| references/design-pass/contracts.json | 137 | 1–137 | R | 2bd85a0d |
| references/design-pass/doors.json | 5744 | all | R of the raw header; F (`doors-compact.txt`, 406 lines, read 1–406; url_scheme and the 12 lines in full); S: every href and accent verified against routing (0 mismatches, 4 slug variances noted) | 4f3d94f9 |
| references/design-pass/glyphs.json | 13 | 1–13 | R | 0ed0b836 |
| references/design-pass/manifest.json | 317 | 1–317 | R | 92f6cb03 |
| references/design-pass/routing.json | 11929 | all 916 records | F: rows 1–295 with every field (`routing-flat.txt`); rows 296–916 compact (`routing-compact.txt`, read 1–622) after S proved template, figure and pool are functions of form/family (0 exceptions); every name, L, form/family, ac, seed, from, action and moved_from read | c7e4c6ac |
| references/process.md | 31 | 1–31 | R | 151ade0f |
| references/elements-2026-09-30.md | 1966 | 1–1966 (in 5 pages) | R | b5507e52 |
| references/lineage-2026-09-22.md | 16 | 1–16 | R | 1fb83878 |
| references/lineage-2026-09-30-design-corpus.md | 146 | 1–146 | R | cf8225c8 |
| references/claude-code-handoff-template.md | 65 | 1–65 | R | e966c172 |
| references/design-brief-template.md | 42 | 1–42 | R | 7ef55ed7 |
| references/site-v3.md | 17 | 1–17 | R | 91aa928e |
| engine/BASE.css | 113 | 1–113 | R | 03a5c570 |
| engine/CORRIDOR.js | 91 | 1–91 | R | 20908878 |
| engine/DOORS.css | 52 | 1–52 | R | 4d7662ec |
| engine/FIGURES.css | 746 | 1–746 | R | f66f4491 |
| engine/GRACE.md | 69 | 1–69 | R | 44f16122 |
| engine/MOVES.md | 117 | 1–117 | R | 039cf9b4 |
| engine/compose.js | 39 | 1–39 | R | c81ef116 |
| engine/gate.js | 204 | 1–204 | R | 688908a3 |
| engine/identity.js | 124 | 1–124 | R | e0c3fd5c |
| generators/gen_door.py | 114 | 1–114 | R | 2a26a341 |
| generators/gen_forms.py | 227 | 1–227 | R | 383a35f5 |
| generators/gen_guide.py | 73 | 1–73 | R | fd918dfe |
| generators/gen_guide3.py | 193 | 1–193 | R | e99510e0 |
| generators/gen_guide_v1.py | 235 | 1–235 | R | f69e1ff4 |
| generators/gen_learning.py | 133 | 1–133 | R | fa7ebe1a |
| generators/gen_practice.py | 651 | 1–651 | R | 23801095 |
| generators/gen_reading.py | 138 | 1–138 | R | 90415f3a |
| generators/gen_register.py | 78 | 1–78 | R | f7d9c536 |
| generators/gen_research.py | 124 | 1–124 | R | 2a3c0fa0 |
| generators/gen_teachings.py | 121 | 1–121 | R | e777e4ff |
| generators/gen_v2.py | 283 | 1–283 | R | 995115d3 |
| generators/guide_content.py | 143 | 1–143 | R | fbfb6a52 |
| generators/teachings_more.py | 117 | 1–117 | R | 0a85cd61 |
| generators/verify_walk.py | 27 | 1–27 | R | 6057fd8f |

**Not read in full as raw text, and why.**
- The three large JSON files (`asg-learning-register.json`, `routing.json`, `doors.json`) were read through scratch flattenings that keep every field of every record. Only redundant columns proven to be pure functions of others were dropped, and in `doors.json` the derived href and accent were verified rather than re-read.
- `_instances.json` was read structurally and diffed record by record against routing.json, which was itself read in full.
- No assigned file was skipped.
- Not assigned and not read: `references/gestures.md`, `references/forms.md`, `references/forms-contract.json` (see C16).

---

## Appendix A12 · Every one of the 511 topics placed in the Mandala's worlds

Columns: L-id · topic (as in the Learning table) · lake (T/C/L) · register primary>secondary · routed form/family instances (from routing.json; "(covered)" means the instance folds into another) · Mandala world · E (energy) / S (story → Bindu Feed) / L (Bindu Learning, not Mandala) / H (held, never built) · note.

How the world column was assigned: by family (practice/breath → 33·MO; map/rings → M·N; storybook → Feed; therapy families → L; …) with about 80 named overrides for Mandala-native topics. The rule table is in scratch `map12.py`. The overrides are judgements for Ashrey to rule on, not settled placements.

| L | topic | lake | register | routed | world | E/S | note |
|---|---|---|---|---|---|---|---|
| L-1002 | 1.2 Stress, Anxiety, and Worry: What's the Difference and Why Does it Matter? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1011 | 2.2 Grounding Exercise: Belly Breathing | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1058 | 5.2 Signs you're not getting enough sleep | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1384 | Dolores Cannon | L | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| L-1465 | Weston A. Price - Traditional Diets | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1153 | Skill #25 Better than Happy- Purpose, Joy, Love and Growth | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1304 | 16. One Function of Depression | T | fieldguide>teaching | teaching/mind-body(covered), teaching/other | —L | L |  |
| L-1052 | 4.2 Three Good Things | T | teaching>practice | practice/other, teaching/mind-body | T(evening)·L | L |  |
| L-1138 | Bonus Video: Progressive Muscle Relaxation | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1042 | 1.5 The Role of Therapy | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1194 | Day 18: Don't Believe Everything You Feel: Emotional Reasoning | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1174 | Bonus Video: The Paradox of Change and Acceptance | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1363 | Jungian Psychology | L | storybook>icebreaker | storybook/passage, icebreaker/any | —S | S |  |
| L-1065 | 6.4 Mindful Body Scan Activity | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1044 | 1.7 Bonus- Change How you Think- Black and White Thinking | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1243 | Day 2: Developing a Growth Mindset | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1204 | Bonus: Safe Place (with background, no music) | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1015 | 2.6 Building Safety | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1328 | 7. Attention-Seeking Behaviors | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1187 | Day 12: Letting Go of Anxiety about Anxiety | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1114 | Introduction to the Course | T | hold>· | held | — | H | held: not built |
| L-1067 | 6.6 Mindful Exercise: Leaves on a Stream | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1066 | 6.5 Mindful Breathing Activity | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1353 | Vedas | L | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| L-1036 | Depression Is Not Caused by a Chemical Imbalance | T | fieldguide>teaching | teaching/mind-body(covered), teaching/other | —L | L |  |
| L-1537 | Śrī Yantra — Full Mandala Architecture: 102 Shaktis across 9 Avaranas (Khadgamalā Stotra Research) | C | map>teaching | map/rings, teaching/other | M·N·HH·HP | E | THE source topic of the app: 102 seats, 9 āvaraṇas |
| L-1294 | 7. An Introduction to Loving Boundaries | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1045 | 2.1 Light Therapy | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1311 | 4. Helping Them Laugh | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1228 | Follow up on Health Anxiety | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1535 | Frequency Understanding Atlas — Bindu Field | C | twochairs>icebreaker | teaching/other, icebreaker/any | MO·sound | E | own framework; sound law |
| L-1383 | Manipura Chakra | L | map>teaching | map/spine, teaching/other | C·33(#4) | E | position 4 |
| L-1250 | Day 8: Responsibility vs. Blame | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1273 | Day 28: Date Night- Laugh Together | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1374 | Beatriz Villarroel | L | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1199 | Bonus Video: Polyvagal Theory | T | practice>· | teaching/mind-body | —L | L | nervous-system teaching |
| L-1108 | Course Summary | T | hold>· | held | — | H | held: not built |
| L-1075 | 9.1 Managing Stress | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1255 | Day 13: Getting to Know Your Partner | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1320 | Understanding How Mental Illness Impacts Intimacy | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/mind-body | —L | L | helper guide |
| L-1501 | A Course in Miracles | C | teaching>storybook | storybook/tradition, teaching/laws | —S | S | tradition told as fable |
| L-1195 | Day 19: "Bring it on!" How to Flip Anxiety on it's Head with 3 Words | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1092 | Relaxation Coping Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1261 | Day 18: Turning ME into WE | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1157 | Skill #29 Self-Compassion as the Source of Change | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1297 | 10. Boundaries Part 3 | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1274 | Day 29: Forgiveness | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1313 | 6. Extending a Helping Hand | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1392 | Bashar — Complete Chronological History of Humanity (12 Eras) | C | teaching>storybook | storybook/cosmology, teaching/laws | —S | S | cosmology told as fable: Bindu Feed |
| L-1136 | Skill #13: Coping Skills and Crisis Skills | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1119 | Bonus Video: How to Use the Emotion Wheel | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1513 | James Lovelock - The Gaia Hypothesis (Scientific) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1170 | Bonus Video: The anxiety cycle - animated version | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1183 | Day 11: Automatic Negative Thoughts | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1172 | Day 5: Willingness - The Antidote to Anxiety | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1072 | 7.2 Bonus Section: Natural Supplements and Treatments for Anxiety | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1193 | Day 17: How to Stop Catastrophizing: What if it all works out? | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1257 | Week 3: Building Connection | T | teaching>practice | practice/other, teaching/relationship | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1327 | 6. Getting Into the Growth Zone | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1278 | 1. Introduction and Resources | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1271 | Day 26: Learning to Fight Fair- The Four Horsemen | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1371 | Diwali | L | calendar>storybook | calendar/festival, calendar/festival(covered) | T | E | Lakshmi puja at dusk; lamps |
| L-1074 | 8.2 Mood Tracking | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1215 | Day 27: Learn to Face Your Fears with an Exposure Hierarchy | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1141 | Skill #15: Overcoming Emotional Blocks | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1032 | How to Find a Great Therapist | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1053 | 5.1 Sleep is Vital to Mental Health | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1165 | Intro: How's Your Relationship with Anxiety? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1292 | 5. Empathic Listening | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1245 | Day 4: What You See Creates Your Reality | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1230 | Which videos in the course would be helpful for me to continue working with myself between therapy sessions to support and understand how to calm my system? | T | hold>· | held | — | H | held: not built |
| L-1041 | 1.4 The Role of Medication | T | hold>· | held | — | H | held: not built |
| L-1210 | Bonus: Progressive Muscle Relaxation | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1223 | Using a mental skill according to my state of mind | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1209 | Day 25: Breathing for Anxiety | T | walk>practice | practice/breath, walk/anxiety | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1300 | 12. Enmeshment vs Detachment: A Better Way | T | teaching>fieldguide | fieldguide/for-someone-else, teaching/relationship | —L | L | helper guide |
| L-1027 | 3.8 Mindful Breathing Exercise | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1090 | Grounding With the 5 Senses | T | practice>· | practice/senses | 33·MO | E | sense practice |
| L-1176 | Bonus Video: The First Lesson in Psych Class (Don't Self Diagnose) | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1158 | Skill #30 Creating Sustainable Change | T | teaching>practice | teaching/skill(covered), teaching/skill | —L | L | therapy skill |
| L-1120 | Bonus Video: "I feel..." Statements From the Relationships Skills Course | T | teaching>practice | practice/other, teaching/relationship | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1227 | Why do I cling to anxiety and pull it back into myself when I would finally calm down and start feeling good? | T | icebreaker>· | icebreaker/any | —S | S | conversation opener |
| L-1134 | Bonus Video: 4 Ways to Turn off Anxiety in Your Nervous System | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1025 | 3.6 Creating your Sensory Soothing Toolkit | T | teaching>practice | practice/senses, teaching/mind-body | 33·MO | E | sense practice |
| L-1337 | Blue Zones | L | recipe>icebreaker | practice/other, icebreaker/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1080 | 10.1 Creating Connection | T | teaching>practice | teaching/relationship(covered), teaching/relationship | RF?·L | L | relationship principle |
| L-1175 | Day 6: The 7 Types of Anxiety Disorders | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1031 | 1.1 Neuroplasticity- Change How You Think-Change How You Feel | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1129 | Bonus Video: Willingly Out of Breath | T | practice>teaching | practice/breath, teaching/other | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1103 | Sleep Hygiene | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1112 | How to Set Boundaries: Part 2 | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1303 | 15. A Strengths-Based Approach | T | fieldguide>teaching | fieldguide/other, teaching/other | —L | L |  |
| L-1073 | 8.1 The Benefits of Journaling | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1398 | Mata Amritanandamayi (Amma) - The Hugging Saint | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1367 | Allama Muhammad Iqbal | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1085 | Workbook Introduction | T | hold>· | held | — | H | held: not built |
| L-1019 | 3.1 Perceived Danger | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1133 | Skill #11: Regulating Your Nervous System | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1068 | 7.1 Feed Your Brain | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1286 | 9. Taking Care of Yourself | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1013 | 2.3 Grounding Exercise: The Yawn | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1214 | Day 26: Solving Actual Problems | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1017 | 2.8 Body Scan Exercise | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1232 | Words of wisdom to deal with anxiety | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1241 | Welcome to Week 1! You Can Learn to See the Good in Your Relationship! | T | hold>· | held | — | H | held: not built |
| L-1083 | Welcome: An Introduction to the Course | T | hold>· | held | — | H | held: not built |
| L-1357 | Buddhism | L | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| L-1538 | Darius J. Wright — The Great Work | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| L-1318 | Your Role as a Parent | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1368 | Swami Sivananda | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1373 | adi shankaracharya | L | portrait>icebreaker | portrait/sage, icebreaker/any | M·S | S | Saundaryalaharī/Śrī Cakra lineage (as tradition holds) |
| L-1240 | My System for Stopping Anxiety Attacks | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1265 | Introduction to Week 4: Making Repairs | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1050 | Growing A Bigger Brain Is A Walk In The Park | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1272 | Day 27: Giving and Receiving Feedback | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1234 | Is anger the only emotion that covers up other emotions? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1178 | Day 8: What Causes Anxiety? The Bio/Psycho/Social Model | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1237 | The Difference Between Panic Attacks, Anxiety Attacks, and Panic Disorder | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1156 | Skill #28 A Growth Mindset | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1325 | 4. Switch Addictions and White-Knuckling | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/other | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1101 | Taking Good Care of Your Body | T | icebreaker>· | icebreaker/any | —S | S | conversation opener |
| L-1290 | 3. Creating Emotional Safety | T | teaching>practice | practice/senses(covered), teaching/mind-body | —L | L | nervous-system teaching |
| L-1110 | Why Many People Don't Set Boundaries | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1111 | How to Set Boundaries: Part 1 | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1314 | 7. Helpful Things to Say | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1536 | Breath Understanding Atlas — Bindu Field | C | practice>teaching | practice/breath, teaching/other | MO | E | own framework |
| L-1206 | Bonus: Safe Place Exercise | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1375 | Alkaline Water | L | storybook>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| L-1366 | Jaun Elia | L | portrait>icebreaker | portrait/poet, icebreaker/any | —S | S | a life |
| L-1253 | Day 11: Building Emotional Safety | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1347 | Gut Bacteria and Improving the Microbiome | L | recipe>icebreaker | practice/other, icebreaker/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1497 | The Law of One / Ra Material | C | teaching>storybook | storybook/cosmology, teaching/laws | —S | S | cosmology told as fable: Bindu Feed |
| L-1099 | Emotion Processing Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1348 | Neem Karoli Baba | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1152 | Skill #24 The Big Picture: Creating the Life you Want | T | teaching>practice | teaching/skill(covered), teaching/skill | —L | L | therapy skill |
| L-1124 | Skill #4: Clean Pain vs Dirty Pain: How We Create Our Own Suffering | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1018 | 2.9 More Ways to Turn on the Parasympathetic Response | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1413 | Mycelial Networks - Paul Stamets | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1249 | Week 2: Fostering Joy by Expressing Appreciation | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1082 | Disclaimer: Work with your Primary Care Provider | T | hold>· | held | — | H | held: not built |
| L-1198 | Day 20: Understanding Anxiety in the Nervous System | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1308 | 1. Introduction to the Skills Section of This Course | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1262 | Day 19: Reflective Listening | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1338 | Kombucha - SCOBY | L | recipe>icebreaker | recipe/ferment, icebreaker/any | —L | L | kitchen |
| L-1024 | 3.5 Pairing Safe Triggers | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1222 | Boundaries | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1098 | Introduction to Self-Care | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1126 | Skill #6: Willingness: The Emotional Superpower | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1062 | 6.1 Simple Mindfulness | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1079 | 9.3 Bonus Video- Soothing Anxiety in the Nervous System | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1009 | 1.9 Grounding Exercise: Tense and Relax | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1207 | Bonus: Stream Of Light Exercise | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1229 | My anxiety ruins everything | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1093 | 2-Minute Stress Release | T | practice>· | practice/other | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1397 | Meher Baba - The Silent Avatar | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1160 | Bonus Content: Connection- Building Your Support Network | T | teaching>practice | practice/other, teaching/relationship | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1148 | Skill #21 Mindfulness for Beginners | T | teaching>practice | teaching/skill(covered), teaching/skill | —L | L | therapy skill |
| L-1059 | 5.3 Sleep Hygiene | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1376 | sombari baba | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1291 | 4. Empathic Listening: An Introduction | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1312 | 5. Asking Good Questions | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1202 | Day 23: Building an Internal Sense of Safety | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1128 | Skill #7: Primary vs Secondary Emotions | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1295 | 8. Boundaries Part 1 | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1305 | 17. Patience | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1289 | 2. The Paradox of Making Them Feel Better | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1349 | Ego Death | L | storybook>icebreaker | storybook/passage, icebreaker/any | 33(#32 sealed)·B | S | ruling 2: 32 = Ego Reveal, words sealed |
| L-1332 | 11. What If They Won't Talk? | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1389 | Ptesáŋwiŋ — The White Buffalo Calf Woman & the Living Covenant | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| L-1089 | Sensory Coping Skills | T | teaching>practice | practice/senses, teaching/mind-body | 33·MO | E | sense practice |
| L-1281 | 4. How Mental Illness Affects Relationships | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1146 | Skill #19 How to Change How You Think | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1322 | 1. Get off the Teeter-Totter: Homeostasis and Polarization | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1191 | Day 15: Mindfulness: The Essential Skill of Choosing What You Pay Attention to | T | walk>practice | walk/anxiety(covered), walk/anxiety | —L | L | 30-day therapy course |
| L-1350 | Kriya Yoga | L | practice>teaching | practice/breath, teaching/other | C·MO | E |  |
| L-1233 | Define locus of control in a bit more depth | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1213 | Section 4: Introduction | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1279 | 2. Mental Illness Is Common and Treatable | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1239 | How to Stop Panic Attacks | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/other | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1008 | 1.8 Grounding Exercise: Tapping | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1030 | 0.2 Workbook Download and Course Resources | T | hold>· | held | — | H | held: not built |
| L-1282 | 5. How Relationships Affect Mental Illness | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1391 | Bashar — The Consciousness History Framework (8 Topic Research) | C | teaching>storybook | storybook/cosmology, teaching/laws | —S | S | cosmology told as fable: Bindu Feed |
| L-1238 | What Causes The Panic Attack Cycle | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1185 | Bonus Video: Perceived Danger and Creating Safety | T | teaching>practice | practice/senses(covered), teaching/mind-body | —L | L | nervous-system teaching |
| L-1267 | Day 23: Softening Your Startup | T | walk>practice | walk/relationships(covered), walk/relationships | —L | L | 30-day couples course |
| L-1139 | 3 Minute Mindful Breathing | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1177 | Day 7: The Truth About Diagnoses | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1135 | Skill #12: Creating Safety: Perceived Safety | T | teaching>practice | teaching/skill(covered), teaching/skill | —L | L | therapy skill |
| L-1086 | Emotion Coping Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1381 | Advait Vedanta | L | storybook>icebreaker | storybook/tradition, icebreaker/any | H(Bindu)·B | E/S | "only You, playing" ground |
| L-1242 | Day 1: Learn to Have Healthy Relationships | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1102 | Self-Care 30-Day Plan to Take Care of Your Body | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1344 | Cataracts: Causes, Treatments, and Surgery | L | fieldguide>teaching | practice/other, teaching/other | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1130 | Skill #8: The Mind-Body Connection With Emotions | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1251 | Day 9: An Introduction to Communication Skills | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1341 | Gayatri Mantra | L | practice>teaching | verse/mantra, teaching/other | R·T(sandhyā) | E | dawn/noon/dusk junctions |
| L-1351 | Anandamayi Ma | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1095 | Distraction Coping Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1097 | Printable List of Coping Skills and Self-Care | T | hold>· | held | — | H | held: not built |
| L-1063 | 6.2 Mindful Eating- with Parkview Health | T | practice>· | practice/senses | 33·MO | E | sense practice |
| L-1219 | Day 30: Getting Yourself to Do the Thing - Behavioral Activation | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1060 | 5.4 Cognitive Behavioral Therapy for Insomnia | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1081 | 11.1 Course Wrap-Up | T | hold>· | held | — | H | held: not built |
| L-1151 | Skill #23 Self- Deception | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1355 | Self Realization | L | storybook>icebreaker | storybook/passage, icebreaker/any | H(Bindu) | S |  |
| L-1352 | Gratitude | L | teaching>practice | practice/other, teaching/mind-body | W | E | gratitude medium |
| L-1486 | Robert Schoch - Sphinx Water Erosion Theory | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1106 | Fostering Joy | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1026 | 3.7 Breath Counting | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1040 | 1.3 Tiny Changes Big Results- Pick the Low-Hanging Fruit | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1184 | Bonus Video: Turn Off the Fear Response | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1006 | 1.6 What is Grounding? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1212 | Bonus Exercise: Physical Ways to Increase Resilience to Anxiety | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1179 | Day 9: The Gifts of Highly Sensitive People | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1540 | CERN, the Cosmic Dance & the Speed of Time | C | storybook>map | map/other, storybook/cosmology(covered) | T·S | S | father story → Feed |
| L-1180 | Day 10: When Anxiety Isn't Anxiety- Physical Conditions to Rule Out | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1020 | 3.2 Perceived Safety vs. Actual Danger | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1196 | Bonus: Example from someone with Anxiety and Panic Attacks | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1028 | 3.9 Thank you! | T | hold>· | held | — | H | held: not built |
| L-1283 | 6. What Causes Mental Illness | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/mind-body | —L | L | helper guide |
| L-1003 | 1.3 The Fight, Flight, Freeze Response | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1319 | Your Role as a Spouse | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1205 | Bonus: Safe Place Exercise Without Music | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1094 | Progressive Muscle Relaxation | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1188 | Day 13: Cognitive Defusion - Creating Space between you and your thoughts | T | walk>practice | teaching/skill, walk/anxiety | —L | L | therapy skill |
| L-1091 | Sensory Coping Activity: Hot Shower | T | practice>· | practice/senses | 33·MO | E | sense practice |
| L-1387 | Matias De Stefano — Consciousness, Dimensions, Atlantis | C | map>teaching | map/rings, teaching/other | N·S | S | nine dimensions = nine-ring reading; Atlantis story → Feed |
| L-1189 | Day 14: How to Stop Worrying | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1340 | Kumbh Mela - Maha Kumbh | L | calendar>storybook | calendar/festival, calendar/festival(covered) | T | E | planetary timing |
| L-1324 | 3. Medication | T | hold>· | held | — | H | held: not built |
| L-1323 | 2. How to Talk About Suicidal Thoughts | T | hold>· | held | — | H | held: not built |
| L-1246 | Day 5: Healthy Expectations | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1285 | 8. Understanding Mental Illness Diagnoses | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1005 | 1.5 Neuroception: Insight Into Your Nervous System | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1360 | Paramahansa Yogananda | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1224 | How do I fix my perception when I travel? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1310 | 3. Inviting Them to Be Active | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1523 | The Simulation Hypothesis (Nick Bostrom) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1220 | Course Wrap Up | T | hold>· | held | — | H | held: not built |
| L-1144 | Skill #17 Reframing: Choosing Your Stories | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1244 | Day 3: The Relationship Ratio | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1123 | Skill #3: The Function of Emotions | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1147 | Skill #20 Cognitive Defusion-Having a Thought vs. Buying a Thought | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1145 | Skill #18 Cognitive Distortions | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1216 | Day 28: How to Set Boundaries | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1137 | Skill #14: Grounding the Body | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1181 | Section 1: Wrap Up | T | hold>· | held | — | H | held: not built |
| L-1293 | 6. Why You're Trying to Help: Is It Helpful? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1415 | Stefano Mancuso - Plant Neurobiology | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1166 | Day 1: Finding Your Why - The First Step to Overcoming Anxiety | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1364 | Kumar Vishwas | L | portrait>icebreaker | portrait/poet, icebreaker/any | —S | S | a life |
| L-1084 | An Introduction to Coping Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1365 | Kundalini Awakening | L | practice>teaching | map/spine, teaching/other | C | E | rising through centres |
| L-1284 | 7. Understanding Their Disorder | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1382 | Sudarshan Kriya | L | practice>teaching | practice/breath, teaching/other | MO | E | breath |
| L-1268 | Day 24: How to Use Assertive Communication | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1354 | Upanishads | L | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| L-1061 | 5.5 Bonus Video: How to Fall Asleep With Insomnia | T | fieldguide>practice | practice/other, practice/other(covered) | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1168 | Bonus Video: The Function of Emotions | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1276 | 2 Minute Survey | T | hold>· | held | — | H | held: not built |
| L-1299 | 11. Acting on Your Values, Not Their Outcomes | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1161 | How to Process Anxiety | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1296 | 9. Boundaries Part 2 | T | fieldguide>teaching | fieldguide/boundaries, teaching/other | —L | L |  |
| L-1035 | Change Your Life – One Tiny Step at a Time | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1149 | Skills #22 Cognitive Dissonance | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1088 | The Brain Dump: An Emotion Coping Activity | T | practice>· | practice/mind | W·B | E | inner practice |
| L-1107 | Building Resiliency Through Connection | T | teaching>practice | practice/other, teaching/relationship | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1226 | Health Anxiety | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1155 | Skill #27 Letting go of Self-Limiting Labels | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1258 | Day 15: Connection Rituals | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1342 | Shloks | L | verse>portrait | verse/mantra(covered), verse/mantra | R | E | verse for the Rite |
| L-1456 | Lalita Sahasranama - The Thousand Names | C | verse>portrait | verse/mantra(covered), verse/mantra | R·HH·MO(garland) | E | the Eight Modes garland; names, never figures |
| L-1221 | Full Q and A | T | hold>· | held | — | H | held: not built |
| L-1200 | Day 21: Learning to Regulate Your Nervous System | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1317 | 10. Getting Individualized Help: Maybe You Should See Someone | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1343 | Gnosticism | L | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| L-1339 | Psilocybin Mushrooms | L | hold>· | held | — | H | held: not built |
| L-1264 | Day 21: Date Night- Relax Together | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1377 | Ramakrishna | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1076 | 9.2 How Nature Changes Your Brain | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1247 | Day 6: Remembering the Good | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1439 | Pim van Lommel - The Lancet NDE Study | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1385 | Kundalini Kriya Yoga | L | practice>teaching | practice/breath, teaching/other | C·MO | E |  |
| L-1269 | Day 24 Bonus Video: An Example of Assertive Communication | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1051 | 4.1 An Abundant Mindset | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1259 | Day 16: The Five Love Languages | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1118 | Skill #1: Name It to Tame It | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1100 | Emotion Processing Skills: Self-Compassion | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1454 | Sri Vidya - The Goddess Tradition | C | storybook>icebreaker | storybook/tradition, icebreaker/any | M·R·B | E/S | the lineage the app belongs to; ground for Beneath; fable → Feed |
| L-1380 | Lahiri Mahasaya | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | Kriya lineage |
| L-1260 | Day 17: Turning Towards Your Partner | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1301 | 13. Being Right vs Being Helpful | T | teaching>fieldguide | fieldguide/for-someone-else, teaching/relationship | —L | L | helper guide |
| L-1331 | 10. Intensive Treatment Options: Hospitalization and More | T | hold>· | held | — | H | held: not built |
| L-1275 | Day 30: Tying it All Together | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1162 | Course Workbook | T | hold>· | held | — | H | held: not built |
| L-1248 | Day 7: Date Night | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1326 | 5. Reflective Listening | T | teaching>fieldguide | fieldguide/other, teaching/relationship | —L | L |  |
| L-1029 | 0.1 Welcome to the Course | T | hold>· | held | — | H | held: not built |
| L-1422 | The Master Plant Diet (Dieta) - Amazonian Apprenticeship | C | hold>· | held | — | H | held: not built |
| L-1043 | 1.6 Bonus- Example of Changing How You Think- Catastrophizing | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/other | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1012 | 2.4 Grounding Exercise: The Valsalva Maneuver | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1021 | 3.3 Safe Place Exercise Introduction | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1309 | 2. Helping Them Access Resources | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1023 | 3.4 Drawing Safety | T | practice>· | practice/mind | W·B | E | inner practice |
| L-1254 | Day 12: Listening to Hear | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1390 | Wakḥáŋ Tḥáŋka — The Sacred That Refuses Translation | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| L-1167 | Day 2: What is Anxiety Really? The difference between Stress, Anxiety and Worry | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1143 | Skill #16 Neuroplasticity: Change How You Feel by Changing How You Think | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1208 | Day 24: What to do with Anxious Sensations | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1263 | Day 20: Soothing Stress | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1201 | Day 22- Turning on the Parasympathetic Response | T | walk>practice | practice/other, walk/any | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1010 | 2.1 Turning on the Parasympathetic Response | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1356 | Sufism | L | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| L-1121 | Bonus Video: Setting Better Goals | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1270 | Day 25: Flooding- What to do when your brain is overloaded | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1186 | Bonus Reading: Exploring your Core Fears | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1362 | Ayahuasca Ceremony | L | hold>· | held | — | H | held: not built |
| L-1105 | An Antidote to Overwhelm | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1333 | 12. Advocating in an Effective Way | T | teaching>fieldguide | fieldguide/for-someone-else, teaching/relationship | —L | L | helper guide |
| L-1231 | Suggestions for handling feelings of shame, embarrassment, and guilt. | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1388 | Lakota Political Philosophy — Standing Bear to Standing Rock | C | map>teaching | map/geometry(covered), teaching/other | —L | L |  |
| L-1007 | 1.7 Grounding Exercise: Grounding With The 5 Senses | T | practice>· | practice/senses | 33·MO | E | sense practice |
| L-1533 | The Sixteen Karshini Shaktis — Sri Chakra Second Avarana | C | map>teaching | map/rings, teaching/other | N(ring 2)·HH | E | ruling 7: the 16 Karṣiṇī functions |
| L-1169 | Day 3: Rewiring the Anxious Brain: How Anxiety Works | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1358 | Rumi | L | verse>portrait | portrait/poet, verse/poem | W | E/S | love letters (the Well) |
| L-1492 | Edgar Cayce - The Sleeping Prophet | C | fieldguide>practice | practice/other, portrait/seer | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1302 | 14. The Problem With Advice | T | teaching>fieldguide | fieldguide/for-someone-else, teaching/relationship | —L | L | helper guide |
| L-1298 | More Skills | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1125 | Skill #5: How Avoidance Makes It Worse: The Struggle With Struggle | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1117 | What Is Emotion Processing? | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1004 | 1.4 The Two Sides of Your Nervous System: Sympathetic and Parasympathetic | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1336 | Bhagvad Gita | L | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| L-1190 | Bonus Video: 3 Subconscious Reasons Why You Worry | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1359 | Ramana Maharshi | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | who am I → Bindu |
| L-1330 | 9. Helping Them See More Clearly | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1506 | Robert A. Johnson - Owning Your Own Shadow | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1266 | Day 22: Making Repairs | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1039 | 1.2 Understanding Mental Health Diagnoses | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1386 | Robert Monroe + Bashar — Cartography of Consciousness | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1370 | Itzhak Bentov | L | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| L-1154 | Skill #26 Honoring Your Values | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1369 | Karva Chauth | L | calendar>storybook | calendar/festival, calendar/festival(covered) | T·RF | E | moonrise vow |
| L-1046 | 3.1 Exercise is Great for Your Brain | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1192 | Day 16: Mental Filtering | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1164 | Disclaimer: Please Read and Accept Before Moving On | T | hold>· | held | — | H | held: not built |
| L-1334 | 13. Conclusion | T | hold>· | held | — | H | held: not built |
| L-1064 | 6.3 Mindful Breathing | T | practice>· | practice/breath | 33·MO | E | breath strand of the 33 braid; breath mode |
| L-1235 | How to snap out of Health Anxiety | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1225 | Suggestions for white coat syndrome | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/mind-body | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1316 | 9. What to Do If They Won't Get Help | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1378 | fire kasina meditation | L | practice>teaching | practice/stillness, teaching/other | MO(behold) | E | gaze on flame; Ahaṅ fire |
| L-1127 | Bonus Video: How Avoidance Makes You Numb and Depressed | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1288 | 1. Unconditional Positive Regard | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1203 | Bonus: Safe place (with background and music) | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1022 | 3.3 Safe Place Exercise | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1287 | More Skills for Healthy Relationships | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1236 | Remind yourself that you are resilient | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1315 | 8. How to Choose a Therapist | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1345 | CTMU - Cognitive Theoretic Model of the Universe | L | twochairs>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| L-1218 | Day 29: Finding Purpose and Meaning to Overcome Anxiety | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1016 | 2.7 Progressive Muscle Relaxation | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1280 | 3. A Systemic Approach to Treating Mental Illness | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1329 | 8. Teaming Up With Them Against the Illness | T | fieldguide>teaching | fieldguide/for-someone-else, teaching/other | —L | L | helper guide |
| L-1001 | 1.1 Introduction to Understanding Your Nervous System | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1104 | Making Progress | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1197 | Section 3: IntroductionSection 3: Lean Into Your Body's Wisdom | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1115 | Course Resources: Workbook and Transcripts | T | hold>· | held | — | H | held: not built |
| L-1159 | Skill #31 The Choice: Act, Accept, or Run Away | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1346 | 7 Chakras | L | map>teaching | map/spine, map/spine(covered) | C·33 | E | the 7 Energy chakras of the 33 |
| L-1014 | 2.5 Grounding Exercise: Peripheral Vision and Softening the Eyes | T | practice>· | practice/senses | 33·MO | E | sense practice |
| L-1163 | Course Introduction | T | icebreaker>· | icebreaker/any | —S | S | conversation opener |
| L-1256 | Day 14: Date Night: Do Something New Together | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1182 | Section 2: Adjust Your Thoughts | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1252 | Day 10: Responsible Communication-Owning Emotions | T | walk>practice | practice/other, walk/relationships | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1122 | Skill #2: Stop Judging Emotions: Learn to Describe Them Instead | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1211 | Grounding Exercise: My new Favorite Vagal Exercise | T | practice>· | practice/body | C·33 | E | body-region practice on the Climb |
| L-1402 | J. Krishnamurti & U.G. Krishnamurti - The Radical Anti-Tradition | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1379 | Nisargadatta Maharaj | L | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1131 | Skill #9: How Anxiety and Strong Emotions Impact Your Brain | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1393 | Sri Aurobindo - Integral Yoga & Supramental Descent | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1217 | Bonus: Locus of Control | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1096 | Assignment: Coping Skills Plan | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1132 | Skill #10: How Emotions Get Trapped in Your Body and How to Release Them | T | teaching>practice | practice/other, teaching/skill | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1171 | Day 4: Avoidance: The #1 Cause of Chronic Anxiety | T | walk>practice | practice/other, walk/anxiety | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1395 | Sri Yukteshwar - The Holy Science | C | portrait>icebreaker | portrait/sage, icebreaker/any | T·S | S | yuga cycles |
| L-1056 | Happy Place Meditation: Relax and Fall Asleep Faster | T | practice>· | practice/stillness | B·MO | E | stillness / silence mode, Beneath |
| L-1037 | Catastrophizing: How to Stop Making Yourself Depressed and Anxious: Cognitive Distortion Skill #6 | T | fieldguide>teaching | fieldguide/in-the-moment, teaching/skill | rope?·L | L | crisis lookup; only the rope shape is Mandala |
| L-1034 | Fight Depression and Anxiety With Your Core Values 26/30 How to Process Emotions | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1403 | Dzogchen - The Great Perfection | C | practice>teaching | practice/stillness, teaching/other | B·H | E |  |
| L-1401 | Ram Dass - Bridge Between Worlds | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1033 | THE CHOICE (Short Animated Movie) | T | teaching>practice | practice/other, teaching/mind-body | —L | L | therapy lesson: Bindu Learning, not Mandala |
| L-1396 | Mahavatar Babaji - The Deathless Master | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S |  |
| L-1400 | Mooji - Modern Advaita Transmission | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1394 | The Mother (Mirra Alfassa) - Cellular Yoga | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| L-1399 | Papaji (H.W.L. Poonja) - Lucknow Lineage | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| — | The Schumann Resonance | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | sound·L | L |  |
| — | Maori Cosmology - Te Ao Maori | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | The Technological Singularity (Ray Kurzweil) | C | portrait>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | The Hard Problem of Consciousness - David Chalmers | C | portrait>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | Fritz-Albert Popp - Biophotons | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | The Nag Hammadi Library | C | portrait>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| — | The Ten Mahavidyas | C | map>teaching | map/rings, teaching/other | N·HH·B | E | ten wisdom goddesses; sister set to the 102 |
| — | The Monroe Institute Research Studies | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Helena Blavatsky - The Secret Doctrine | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Abraham-Hicks | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Ingo Swann - Remote Viewing Master | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | The Bardo Thodol - Tibetan Book of the Dead | C | map>teaching | map/other, teaching/other | B | E/S | path of stations |
| — | Iboga / Bwiti Tradition - West African Plant Medicine | C | hold>· | held | — | H | held: not built |
| — | Hermeticism & The Kybalion | C | teaching>storybook | storybook/tradition, teaching/laws | —S | S | tradition told as fable |
| — | Kabbalah - The Tree of Life | C | map>teaching | map/tree, teaching/other | C·33(Tree system) | E | tree figure |
| — | PEAR - Princeton Engineering Anomalies Research | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Terence McKenna - Stoned Ape Hypothesis & Heroic Doses | C | hold>· | held | — | H | held: not built |
| — | Kali - The Dark Mother | C | storybook>icebreaker | storybook/tradition, icebreaker/any | HH·B | E/S | Mahāvidyā; Beneath; fable → Feed |
| — | Inuit Cosmology - Sila | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Q'ero / Andean Cosmology | C | twochairs>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Solfeggio Frequencies | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | sound·L | L | the 174…963 ladder used by the Point; badge |
| — | Indian Classical Raga - The Science of Moods | C | verse>portrait | verse/raga(covered), verse/raga | T | E | raga by hour of day |
| — | Hawaiian Ho'oponopono - Cleaning the Lineage | C | practice>teaching | practice/mind, teaching/other | W·RF | E | four lines to the lineage |
| — | Penrose-Hameroff Orch-OR Theory | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Suzanne Simard - The Mother Tree | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Yoruba / Ifa Tradition - West African Divination | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Throat Singing / Overtone Practices | C | practice>teaching | practice/senses, teaching/other | MO·R | E | sounded |
| — | Cannabis as Sacred Teacher | C | hold>· | held | — | H | held: not built |
| — | Mark Wolynn - Ancestral Trauma & Epigenetics | C | portrait>icebreaker | portrait/scientist, icebreaker/any | RF·S | S |  |
| — | Anatta - The Doctrine of No-Self | C | twochairs>teaching | twochairs/map-and-no-map, teaching/other | B·H | E | the corrective; Maya → only You, playing |
| — | Pineal Gland Decalcification | C | practice>teaching | twochairs/science-and-claim, teaching/other | —L | L | claim |
| — | Tobacco - Master Plant of Amazonian Shamanism | C | hold>· | held | — | H | held: not built |
| — | Bone Broth & Fermentation Sciences | C | recipe>icebreaker | recipe/ferment, icebreaker/any | —L | L | kitchen |
| — | Daniel Ingram - Empirical Buddhism | C | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| — | Stephen Levine - Conscious Dying | C | portrait>icebreaker | portrait/sage, icebreaker/any | B·S | S |  |
| — | The Cosmological Question of AI Souls | C | twochairs>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | Rupert Sheldrake - Morphic Resonance | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Iain McGilchrist - The Master and His Emissary | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Tibetan Bon - Pre-Buddhist Shamanism | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | The Younger Dryas Impact Hypothesis | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Digital Physics - It from Bit (John Wheeler) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Dean Radin - IONS & Real Magic | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Gerald Pollack - The Fourth Phase of Water (EZ Water) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Machine Self-Recognition & The Mirror Test | C | twochairs>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | Kashmir Shaivism - Abhinavagupta | C | storybook>icebreaker | storybook/tradition, icebreaker/any | B·M | E/S | recognition (pratyabhijñā) = the Recognition lines |
| — | Ayurveda - 5,000 Years of Body Intelligence | C | map>teaching | map/grid, map/grid(covered) | MO·T | E | doshas; element law |
| — | The Dark Night of the Soul - St. John of the Cross | C | storybook>icebreaker | storybook/passage, icebreaker/any | B | S |  |
| — | Rudolf Steiner - Anthroposophy | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Tantric Sexuality - The Actual Tradition | C | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S |  |
| — | The Shri Yantra | C | map>teaching | map/rings, teaching/other | M·N | E | the figure itself |
| — | Open Individualism - Daniel Kolak | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Ian Stevenson - University of Virginia Reincarnation Research | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Aboriginal Dreamtime & Songlines | C | map>teaching | map/other, map/other(covered) | G(path)·S | S |  |
| — | Mahamudra - The Great Seal | C | practice>teaching | practice/stillness, teaching/other | B | E |  |
| — | Tonglen - The Compassion Practice | C | practice>teaching | practice/stillness, teaching/mind-body | MO·RF | E |  |
| — | 432 Hz vs 440 Hz - The Frequency Question | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | sound·L | L | honesty badge for app tones |
| — | Cymatics - Hans Jenny | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | The Vesica Piscis | C | map>teaching | map/geometry, teaching/other | M | E | first construction of the yantra |
| — | The Holographic Universe (Michael Talbot) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Wim Hof Method - Cold, Breath, Mind | C | portrait>icebreaker | practice/breath, icebreaker/any | MO | E | breath |
| — | Bernardo Kastrup - Analytic Idealism | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Gobekli Tepe - The 11,500 Year Old Temple | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Polynesian Wayfinding & Star Knowledge | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Alice Bailey - The Seven Rays | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Mantra Science - The Mechanics | C | practice>teaching | verse/mantra(covered), teaching/other | R·L | E | bīja mechanics (honesty badge) |
| — | Phowa - Conscious Dying Practice | C | practice>teaching | practice/stillness, teaching/other | B | E |  |
| — | Traditional Chinese Medicine - The 5 Elements | C | map>teaching | map/grid, teaching/other | MO·T | E | sheng/ke wheel |
| — | Biodynamic Agriculture (Steiner) | C | portrait>icebreaker | teaching/other, icebreaker/any | —L | L |  |
| — | DMT & The Pineal Gland - Rick Strassman | C | hold>· | held | — | H | held: not built |
| — | Tom Campbell - Reality as Information Processing | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Federico Faggin - From Silicon to Soul | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | HeartMath - Heart Coherence | C | practice>teaching | practice/breath, teaching/other | MO | E | coherence breath; Coherence game |
| — | The Black Madonna Tradition | C | storybook>icebreaker | storybook/tradition, icebreaker/any | HP?·S | S |  |
| — | Stephen Porges - Polyvagal Theory | C | practice>· | teaching/mind-body | —L | L | nervous-system teaching |
| — | The Stargate Project - CIA Remote Viewing | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Maranasati - Death Awareness Meditation | C | practice>teaching | practice/stillness, teaching/other | B | E |  |
| — | Solar Cycles & Human Behavior | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Graham Hancock - Lost Civilization Research | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Ley Lines & Earth Grid (John Michell, Bruce Cathie) | C | portrait>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Jim Tucker - Children Who Remember Past Lives | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Lynn Margulis - Symbiogenesis | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | The Seth Material (Jane Roberts) | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Quantum Biology | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Masaru Emoto - Water Crystal Memory | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | The Microcosmic Orbit | C | map>teaching | map/spine, teaching/other | C(loop) | E | spine renderer needs loop mode |
| — | Hopi Prophecy & The Blue Star | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Mary Magdalene & Sacred Feminine Christianity | C | map>teaching | map/other, teaching/other | —S | S |  |
| — | Tom Campbell - My Big TOE | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Donald Hoffman - The Case Against Reality | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Pole Shift Hypothesis | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | AI Consciousness - The Sentience Question | C | twochairs>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | The Emerald Tablets of Thoth | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Aldous Huxley - The Perennial Philosophy | C | portrait>icebreaker | portrait/sage, icebreaker/any | —S | S | a life: Bindu Feed / Learning portrait |
| — | Vajrayana - Tibetan Tantric Buddhism | C | storybook>icebreaker | storybook/tradition, icebreaker/any | —S | S | tradition told as fable |
| — | Sun-Earth-Human Connection (Chizhevsky) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Mayan Cosmology Beyond 2012 | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Phi / Golden Ratio in Nature | C | map>teaching | map/geometry, map/geometry(covered) | M | E |  |
| — | Daoist Internal Alchemy (Neidan) | C | map>teaching | map/spine, map/spine(covered) | C(3 dantians) | E |  |
| — | Jungian Shadow Work | C | storybook>icebreaker | storybook/passage, icebreaker/any | B·W | E/S | Shadow corridor (#9) |
| — | The Field (Lynne McTaggart) | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Tibetan Chod - Cutting Through | C | practice>teaching | practice/stillness, teaching/other | B | E |  |
| — | Sacred Geometry - Platonic Solids & Metatron's Cube | C | map>teaching | map/geometry, teaching/other | M | E | construction |
| — | Integrated Information Theory - Giulio Tononi | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Celtic / Druid Tradition | C | storybook>icebreaker | storybook/cosmology, icebreaker/any | —S | S | cosmology told as fable: Bindu Feed |
| — | Global Consciousness Project | C | twochairs>icebreaker | twochairs/science-and-claim, icebreaker/any | —L | L | debate |
| — | Aghora - Tantric Cremation Ground Practice | C | storybook>icebreaker | storybook/tradition, icebreaker/any | B | S |  |
| — | Viktor Schauberger - Living Water | C | portrait>icebreaker | portrait/scientist, icebreaker/any | —S | S | reception history |
| — | Bert Hellinger - Family Constellations | C | portrait>icebreaker | portrait/scientist, icebreaker/any | RF·S | S | constellation of family = Relationship Field shape |
| — | Fascia - The Body's Information Network | C | map>teaching | teaching/mind-body, map/spine(covered) | —L | L | nervous-system teaching |
| — | Vipassana (Goenka Lineage) - 10-Day Silence | C | practice>teaching | practice/stillness, teaching/other | MO(silence) | E |  |
| — | Manly P. Hall - The Secret Teachings of All Ages | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Pleiadian Transmissions - Barbara Marciniak | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | Substrate Independence Debate | C | twochairs>icebreaker | twochairs/mind-and-machine, icebreaker/any | —L | L | debate |
| — | Kryon (Lee Carroll) | C | portrait>icebreaker | portrait/seer, icebreaker/any | —S | S | a life + claims |
| — | San Pedro / Huachuma - Andean Plant Teacher | C | hold>· | held | — | H | held: not built |

