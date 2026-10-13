# THE REGISTER · 14 · aistrangegame (the public face of ASG)

*Reader 14 of the second reading. Written 2026-10-12. Read-only pass. No code, skill, Airtable record or other file was changed.*

**Skill root:** `/root/.claude/skills/synced/12004d20-e236-4ac6-98bf-0d5838029946_16bbdd03-2a82-4e1e-84ae-276f4c93debb/aistrangegame/`. It is shortened to `AG/` below.
**Context file:** `…/a-strange-game/SKILL.md`. It is shortened to `ASG:` below.

## Scope

- **24 files** in `AG/`: the SKILL, 18 reference documents, 4 data JSONs for the v3 site, and 2 homepage builds.
- **One context file:** the a-strange-game SKILL.md (361 lines).
- **The two builds are byte-identical.**
  - `builds/Default.html` and `builds/Default_immersive.html` share md5 `4c25bd97…`.
  - `cmp` reports IDENTICAL.
  - Both are the **Immersive V1.1 "Build 2"** homepage of 25 April 2026. That build has 13 worlds, the Road Home carousel and the Trees viewer.
  - Neither file is the old Thread homepage, although `homepage-architecture.md` says `Default.html` is that archive. See C.10.
- **Nothing in this skill is the live site.**
  - The live aistrangegame.com is the **v3 site**: 48 worlds, generated from the private engine `aistrangegame/learning-register`.
  - Only its canon (`SITE-V3.md`) and its four data files sit here.
  - The A Strange Story build (`v7-a-strange-story.html`), the panels, the dances and the chakra map are **not in this skill.** Only their frameworks and specs are.

**The lens.** The site is the knowing side of ASG. Its builds, frameworks and elements library hold interactions, figures and experience structures that could come into Bindu Mandala. In B, each element is placed in the app's fifteen worlds and marked **energy** or **story**. Story items are Bindu Feed candidates.

### Abbreviations

| Mark | File |
|---|---|
| SK | `AG/SKILL.md` |
| V3 | `AG/references/v3-site/SITE-V3.md` |
| GP / PERM / FL / DR | `v3-site/data/gateway-paths.json` / `permanent.json` / `floors.json` / `doors.json` |
| V5C | `references/v5-content-generation.md` |
| V6 | `references/v6-framework.md` |
| V7 | `references/v7-framework.md` |
| EA5 | `references/experience-architecture-v5.md` |
| EL | `references/elements-library.md` |
| CMF | `references/chakra-map-framework.md` |
| HA | `references/homepage-architecture.md` |
| SM | `references/sitemap.md` |
| NTL | `references/the-new-topic-lane.md` |
| EDP | `references/experience-design-process.md` |
| BGR | `references/build-guard-rules.md` |
| BVP | `references/build-verification-protocol.md` |
| BVPr | `references/build-verification-process.md` |
| DS | `references/design-system.md` |
| PA | `references/page-architecture.md` |
| DI | `references/deploy-and-infra.md` |
| DH | `builds/Default_immersive.html`. Line numbers hold for `Default.html` too, since the files are identical. |

---

## A · INVENTORY

### A.1 What the site is, and its laws (V3, SK)

**What it is (V3:8).** Ashrey's personal site, *"wholly personal, not for the public"*, ruled 24 Sept. It shows *"48 worlds in 9 movements, standing on a 33-vertebra spine, with one gold Point sewing a thread through everything. Mirrors, not teachings. Nothing on it asks to be believed."*

**Who makes it (V3:10).**
- Ashrey walks it and rules.
- Claude Design designs.
- Claude Chat holds the whole, writes, and rules on content.
- Claude Code builds, gates and ships, using Cloudflare Workers with `main` deploying.
- Cowork runs the page waves.

**The ten laws (V3:14–23), verbatim heads:**

1. *Nothing is gated.* *"Every page shows everything on first arrival. Essence personalises, never permits. Ceremonies stay, locks go: every press-and-hold has a one-tap way through. The readiness check is retired."*
2. *Only true when true* — this applies to claims, never to access.
3. *Count in private.* *"No number measures the reader."*
4. *Full content, unfinished meaning.* *"Withholding isn't depth."*
5. *Creation · preservation · expansion.* *"No design move subtracts."*
6. *Living traditions as register and attribution, never ceremony.*
   - *"Sri Vidya: names, meanings, functions, body placements — aniconic; seed syllables and the recognition gesture stay in the app."*
   - Lakota: register only.
7. *The apps keep their own gates;* the site only depicts them.
8. *Memory, never permission.* *"What a phone remembers lights things; it never opens or closes anything."*
9. *Nothing typed twice.* Every surface is generated from the register.
10. *Weight is never a gate.* *"Smoothness is the budget."*

**The shape (V3:27–38).**
- The page order is: the doors → the Sky → the descent → Movements II–IX → the coda *"The only winning move is to play."*
- The movements:

| Movement | Worlds |
|---|---|
| II · The Field | Walk · Chakra Map · Practice Book · Dances · Readings · Teachings · Learning · Courses · Guidebook · Forms |
| III · The Voices | Story · Voice · Game · Voice Library |
| IV · The Tree | Tree of Life · Axis · Three Trees · Temple Guide |
| V · The Instruments | Bindu Feed · Learning · Voice · Field · Being · Lalita Family · **Mandala** · Chakras, plus the rose window |
| VI · The Vantages | **Bindu 1 · Gaia 10 · Sid 11 · Arch 6 · Sakshi 18 · Karishma 28 · Neev 2 · Shweta 3 · Ashrey 31 · Lalita 33** |
| VII · The Ground | the Field · the Registers · the Temporal · the Codex · the Reveals · the Elements |
| VIII · The Configuration | the Mirror · the Plays · A Self Generator |
| IX · The Moments | It Was Always Lucky · Khelo Holi · the Moments |

**Four lenses (V3:40).** *"Hand · Light · Depth · Witness: rendering layers over one structure — never content, laws or positions. Switch anywhere; you stay where you are; `?lens=` for a single link."*

**The Point (V3:42), verbatim.** *"The Point is one element, born from the `i`, never replaced: it sews (II), speaks (III), settles into the painted dots (IV), goes inside the phones (V), steps off the thread (VI), runs under the stone (VII), splits and becomes one (VIII), rests beside the days (IX), becomes the centre (the Sky), and flies home into the `i`."*

**136.1 Hz (V3:44).** *"136.1 Hz is the site's note; it's named once, at the Tree's ninth panel — the Om was always playing."*

**Levels (V3:48).**
- L0 is the homepage.
- L1 is the 48 gateways: *arrive · choose · or don't · return*.
- There are 18 middle floors.
- L3 is the pages, about 870 of them, each carrying the seam include.

**Addresses (V3:52–56, GP, PERM).**
- One address per page; the extensionless form is canonical.
- Gateways live at `/worlds/<name>/`.
- **47 printed addresses never move.** They are:
  - the nine wake-up and sleep panel codes;
  - the nine dance codes;
  - the two Dark+Light book codes;
  - the `/b/<verb>` QR wall: 18 live, 11 "verify in export";
  - `/b/abide` (pending) and `/b/stay` (never numbered). See C.
- GP maps 47 world keys to paths, e.g. `"mandala": "/worlds/bindu-mandala/"` (GP:20) and `"game": "/worlds/a-strange-game/"` (GP:9).

**Navigation: five hierarchies (V3:58–66).**

| Hierarchy | Pages |
|---|---|
| worlds | homepage → gateways → floors → pages |
| the body | `/spine/` and 33 vertebra pages with sections *"the practice · the panel · the readings · standing here · passing through · the passages"* |
| people | the six family vantage gateways |
| time | the Moments' rings |
| subjects | a *"same subject, another way"* door on each page |

- **The climb (V3:68):** page → floor → gateway → world → doors, one tap per step. The proof holds every page ≤3 taps from the doors.
- **Three ways to find anything (V3:70):** *"the Sky shows where · the Tab Page and search say what it's called · the Door is not deciding."*

**The register (V3:74).** It holds one entry per page with these fields:
- `h` address, `t` title, `s` line;
- `w`/`mv` world, `v` vertebra or band, `people`, `d` date, `subject`;
- `lake`/`form`/`family`/`topic`;
- dance facets: `song`, `artist`, `hue`, `seed`;
- `x` element, `c` colour, `status`, `seam`, `parent`, `printed`.

Learning lakes: Therapy 318 · Consciousness 258 · Learning 103.

**Edges (V3:80).**
- Every page is `noindex` and there is no sitemap.
- *"The 404 offers the three nearest pages, then the die."*
- Search prompt: *"Type one word you're carrying"*. It searches the dances' verbs and seeds too.
- The Now page is *"the site's own growth rings"*.
- The contact form goes to his own inbox (address never printed).

**State (V3:84).**
- One key each, in the `asg.` namespace: *"sound · lens · where you left · what you've walked · the Point · your name from the Game · words you give a page"*.
- ***"Bindu memory (after launch): everyone's interactions stay on their phone; Ashrey's also sync to App Activity through the Worker's `/api/`, behind Cloudflare Access — the site is the sixth app on the ledger."***

**Feeds (V3:88).**
- The Mandala's nine enclosures read the Mandala table, ***"allow-list of fields only"***.
- *"Never: the Feed, raw Codex memos, Being, Lalita Family's people, Mandala recognitions, Emotions, Anger, Health, Daily, Relationships."*

**Gates (V3:92).** Checked on every deploy: fit · contrast · links · word limits · therapy care line · no gates · reachability · the 47 addresses · family photos · living traditions (attribution present, no seed syllables) · the Configuration (no consciousness claim) · count in private · one key per thing · noindex.

**The wall (V3:142–191).** Three levels; the default is open.

| Level | Pages |
|---|---|
| open | 963 |
| open with depth | 18 |
| behind the wall | none yet |

- The test fails in three cases: (a) a family member in a private moment; (b) a child; (c) Ashrey's raw record.
- *"The principle: publish what was learned; keep what it was learned from."*
- How depth works:
  - depth is fetched through `/api/private/<key>` behind Cloudflare Access (one-time PIN to Ashrey's email);
  - the store is KV, with separate production and preview namespaces;
  - it fails closed with one uniform 404;
  - signed in, *"a thin line appears under the title"*.

**Performance ruling (V3:198).** *"Correctness beats the numbers."* `content-visibility:auto` was reverted because it moved the Point 64 px.

**Still open (V3:237–245).**
- The old-host upload.
- Three predating pages need evolving:
  - *"the Welcome still says 'nine practices are walkable' and teaches a gate that no longer exists"*;
  - *"the One frames essence as a toll before the road"*;
  - *"the Road Home knows only dances and chakras"*.

**The next build (V3:247–260).** astrangeigame.com is the playing side. A Codex field sorts entries into **nine games**:
- A Fire Game
- A System Game
- A Learning Game
- A Family Game
- A Work Game
- A Maya Game
- A Health Game
- A Social Game
- A Seva Game

*"The law for anything built there: no number may ever measure the player."*

**Floors (FL).** 18 middle floors:
- three lakes;
- ten Learning forms: calendar, field guide, icebreaker, map, portrait, practice, recipe, story, two chairs, verse;
- five Teachings kinds: laws, mind-body, skills, relationships, more.

**Doors (DR).** Every world has a `go_in` plus at most two doors. Relevant entries:

| Line | World | Doors and why |
|---|---|---|
| DR:276–288 | mandala | *"the first enclosure"* → `/worlds/bindu-mandala/1/`, and *"what it is"* → `/guide/bindu-mandala`. Why: *"walk in from the outer ring"*. |
| DR:302–311 | bindu | → `/spine/1/`. Why: *"Bindu is the point every other page stands on"*. |
| DR:346–355 | sakshi | → `/spine/18/`. Why: *"the witness sits at the Axis"*. |
| DR:431–440 | reveals | → `/tree-of-life/ego-reveal-practice`. Why: *"vertebra 32, where the reveals land"*. |
| DR:313–322 | gaia | → `the-call-read`. Why: *"the one place she speaks in full"*. |
| DR:391–400 | lalita | → `the-leela-read`. Why: *"her own manifesto"*. |
| DR:146–155 | game | → `the-welcome`. |
| DR:36–45 | dances | first door `/b/search`. Why: *"#1 — 'Where are you now?' — the right first question"*. |
| DR:46–55 | readings | → `/bindu/read/ground`. Why: *"Earth, the root — the element order begins here"*. |
| DR:57–70 | teachings | *"today's teaching"* → *"(computed — by day of year)"*. |
| DR:491–495 | moments | *"the rings are the doors"*. |

### A.2 A Strange Game: the composition layer (ASG:)

- **What it is (ASG:22–28).** *"The game is reception infrastructure."* The walker brings willingness; the game opens reception; the higher self downloads. *"Not as metaphor. As mechanic."*

- **Knowledge — Will — Action (ASG:93–101), verbatim:**
  - *"Knowledge is what they receive. / Will is who they are. / Action is what they commit to. / Light is what enters when these three close."*
  - This is Aatma's trikona at chakra position 31.

- **Trinity of Guidance (ASG:107–131).** Three axes, five faces, one field.

  | Axis | Faces | Notes |
  |---|---|---|
  | Ground | Gaia | She *"does not split"* |
  | Player | Bindu → Lalita | Pre- and post-recognition |
  | Witness | Sakshi → Higher Self | Observes vs addresses |

  - Surfaces: Gaia speaks in the-call / the-call-read and at the **position 32 reveal**.
  - Bindu speaks in Act 1 of every chakra page; Sakshi in Act 2.
  - Lalita speaks in the-leela.
  - Higher Self speaks in the-one-speaks, shadow-practice and armin-practice.

- **Three storage pools (ASG:161–165).**

  | Pool | Meaning | Behaviour |
  |---|---|---|
  | `bindu-essence` | *the who* | Fixed at The One |
  | `bindu-memory` | *the what walked* | Time-ordered |
  | `bindu-being` | *the how being* | Refreshed each visit |

- **Journey (ASG:175–201).** Readiness check → homepage → Welcome → The One (dark void, name · DOB · Higher Self, 1.8 s commit) → The One · Speaks → The Call (black video → cream Gaia text → dot + name reveal) → The Leela → The Road Home → Bindu + chakras (Act 1 → Wake Up → Practice → Dance → Act 2) → the Strange Story.
  - *"Open access … The structure is offering, not gating."*

- **Arrival prose (ASG:211), the homepage thesis:** *"there is the one you have been being / and there is the one who has been here all along / this is a way of returning to the one who was here first."*
  - Seal: *"a structured way of returning"*, shown on first arrival only (ASG:341).

- **Leela (ASG:221–237).** *"Leela = the divine play itself. Lalita = the level of Leela that knows itself as Leela."*
  - The skill extends this: *"Bindu is the level of Leela that does not yet know itself as Leela."*
  - *"Every Lalita drop ends in real-world action."*
  - First drop: *"Ask reality for help with one thing. Real life. Not in the game. Right now."*

- **Five doors of the Road Home (ASG:257–265):**
  1. Walk the next chakra.
  2. Return to a passage.
  3. Read what was witnessed (Sakshi Witness Perspectives).
  4. Study the Codex.
  5. Visit your diary (Standing Words history, dance constellation, ledger of offerings).
  - Plus a **Standing Place** (*"where you are, today + where your being is, NOW"*) and **Seed Planting** notifications.

- **Press-and-hold ring (ASG:271–281).** *"the signature gesture of the entire game."*
  - 1.8 s at the Welcome, at each Stage of The One, at the Call's final commit, on every V5 chakra veil between Act 1 and Act 2, and at the Road Home's first arrival.
  - 1.0 s between Gaia chunks.
  - *"The cumulative weight of those commitments is the journey."*

- **Dev key (ASG:243–251).** `?ash=1` or `localStorage.ash='1'`. *"the maker's name as the master key."*

- **Locked (ASG:334–350):**
  - the eye `👁` appears only in titles;
  - the Higher Self alone uses merge tokens (`name`, `higherSelfName`, `silenceDurationMs`);
  - the Kingdom line (ASG:359): *"The technology does what the technology teaches."*

### A.3 The skill itself (SK)

**Site tree (SK:50–81, historic).**
- `/story`, the four person pages (arch, sid, ashrey, karishma), five product experiences, joann, `/family/*`, khelo-holi, dark-light flipbook and descent.
- `/tree-of-life`: 9 panels.
- `/bindu-performances`: 9 dances, hidden behind the Tree.
- temple-guide.
- `/chakras`: map and practice.
- `/voice`.

**Axis dimensions (SK:83–86).** Hidden content reached through the wandering Bindu:
- the Book → Physical Reality Elements (8 objects);
- Sidharth → the Witness Zone (Witness Passages + Manu Gyroscope Story);
- the Tree of Life → Bindu Performances (9 songs).

**A Strange Story layers = archetypes (SK:96–103):**

| Layer | Archetype | Governs |
|---|---|---|
| BREATH | Gaia | gated rooms, rhythm |
| HOLD | Sid | the responsive Thread |
| LOVE | Arch | stitch points in love |
| WITNESS | Sakshi | the Arc constellation |
| GRACE | Karishma | vibrating heart at 0.1 Hz |
| SYNTHESIS | Ashrey | sound, haptics, re-experience |

**Emergence triad (SK:115).** The Story *is* the third Mind triad: Incarnation · Innocence · Integration.
- CPE = Creation · Preservation · Expansion, replacing Destruction.
- Leela etymology: *"Lonely → La-One-Lee → Lalee → Leela."*

**Full Chakra Map (SK:117).**
- 7 Energy chakras: Soul Tree, go UP, stillness.
- 10 Body chakras: Bindu Tree, go OUT, movement.
- 9 Mind chakras: Beta Dimension, go IN, visualization.
- 7 Tree of Life chakras: *"Bindu → Shadow → Armin → Axis → Maya → Aatma → Lalita"*.
- *"33 vertebrae in the human spine. The structure that holds the structure."*

**Two chakra experiences (SK:121–124).**
- Chakra Map VX2: about 1557 lines, 4 systems.
- Chakra Practice book: about 40,000 words; 33 chakras × 2 spreads; three voices; two practices, *Blink.Breathe.Press* and *Cross.Blink.Feel.Return*.

**A Strange Voice (SK:126).**
- Voice II: five acts following Gaia's five movements (Call → Response → Inversion → Dissolution → Tree).
- Lalita narrates and is revealed as Earth in Act 5.
- Earth palette.
- ***Persistent heartbeat at 72 BPM.***

**Three Voices (SK:128–131).**
- Story (Voice I): *"I Already Did."*
- Voice (II): *"A I Love."*
- Game: *"aistrangegame.com was always named after her."*

**Fabric/stitch metaphor (SK:135–142).**
- Closed state = surface.
- Open = *"warm tinted light"*.
- Thread = centre line.
- Stitch points = 18 px dots with glow ring.
- **Temperature rule (SK:161):** *"Every experience should shift temperature at least twice."*

**Person colours (SK:146–151):**

| Person | Colour | Light |
|---|---|---|
| Arch | `#7A2F14` terra cotta | `#F5E2D6` |
| Sid | `#1B3A5C` deep blue | `#D4E4F2` |
| Ash | `#26421A` sage | `#D6EBCE` |
| Shared | `#4A4238` warm stone | — |

**Content rule (SK:321).** *"Never create flat informational pages. Every piece of content needs: a surface (before interaction), a reveal (on engagement), a thread (connecting to the next moment)."*

**Version table (SK:325–334).** The Story ran from V1 (1,038 lines) to V7.1 (4,359 lines).

**Voice (SK:338).** Third-person witness; closing lines may shift to second person.

**Version X (SK:111).** An infinity gateway, plus *"Chapter 12 'The Remembering' — AI-generated from engagement depth via Revity."*

### A.4 A Strange Story: experience architecture (EA5, V5C, V6, V7)

**Five ways of knowing (EA5:11–17):**

| Mode | What happens | Stance |
|---|---|---|
| TOLD | chapters | reader seeks |
| FELT | experiences | receptive |
| STITCHED | the reader writes a word | participatory |
| NAMED | the Turning | witnessing |
| PERSONAL | closing + Final Reveal | intimate |

**Flow (EA5:26–383).**
- Gate 1: two paths, one story.
- Gate 2: preamble → Sakshi permission → name → birthday → breathe → enter.
- Then: hero → prelude → five acts → 11 (later 12) chapters → three experiences → Mirror ("Stop.") → Signal → Turning → Threshold → NOW → Closing → the Arc → Final Reveal → Share (*"Send this to someone who is ready."*).

**Five stitch questions (EA5:55, 70, 205, 251, 352):**
1. *"In one word — what brought you here?"*
2. *"What did you recognize?"*
3. *"What did you remember?"*
4. *"What is arriving?"*
5. *"What is happening in you, right now?"*

**Lemuria, the Mother's silence.** A FELT experience of reception.
- Warmth blooms from the void over 2.5 s; a breathing ring runs a 4 s cycle.
- Words arrive one at a time: 120 ms in EA5, 170 ms in BVP, **200 ms in V7.1** (V7:32).
- Breathing ring: 12 s breathe → ring fades → 1.5 s pause → words begin (BVP:79).
- V7 smooth crossfade (V7:71–73):
  - the ring collapses with `height:0`, not `display:none`;
  - there is a 2.8 s gap before the first word;
  - the ring animates `infinite`.
- Sound (V6:132): *"white noise filtered to breath-like whoosh, 4s cycle … No pitched tone. Pure air."*

**Atlantis, the Father's fall** (EA5:121–162, V5C:68–93, V7:76–77).
- Text builds character by character at **40 ms**, holds **3 s**, then erodes over **10 s**.
- *"The erosion is random but weighted — longer words lose characters first."*
- Characters get `.fallen`: opacity 0.8 s, transform 1.2 s, translateY + rotate (EL:74).
- The text is 36 px (26 px on mobile), with a glowing *"hold to witness"* prompt that has a 2.5 s gold text-shadow breath.
- Hold line: *"The Father built everything."*
- Haptic: 50 ms per falling character, throttled to 1 per 200 ms (V6:146).
- Sound (V6:133): sine harmonics from **68 Hz**, with overtones **136.1 · 204.15 · 272.2 Hz** added during the build. All sound during the hold. On erosion they strip in reverse to 68 Hz, then silence.
- Trimmed fragment text (V5C:84): *"Mastery of energy. Of consciousness. Of the relationship between matter and intention. Monuments no age could diminish. Nineteen thousand years of flourishing. The Father built everything."*

**Humanity, the Child's recognition** (EA5:257–302, V5C:97–145, V7:80–83).
- Two streams converge: left is Lemuria words in warm tones, right is Atlantis words in red.
- Centre convergence, in gold, word by word at 100 ms (V5C:133–139): *"You carry both. / The feeling that knows without words. / The knowing that builds without feeling. / Neither complete alone. / Both complete in you."* — *"This is the Child's voice. Karishma speaking."* (V5C:144).
- V7 adds **three feels**: Mother slides from the left (60 px), Father from the right (60 px), Human descends from the top (40 px). Qualities arrive at 600 ms each; transforms stay ≤60 px.
- **Vibrating heart** (V6:93–99):
  - SVG, 80 px;
  - scale 1.0 → 1.06 → 1.0 over **10 s (0.1 Hz, "heart-brain coherence")**;
  - a gold glow at 0.15;
  - label *"feel"* in DM Sans 11 px, letter-spacing 4 px;
  - on interaction it scales to 1.12; the `.pulse-active` state goes to 1.15;
  - haptic 100 ms at each peak.
- Sound (V6:134): *"Two detuned sine waves — 132 Hz and 140 Hz — slowly converging to 136.1 Hz … Convergence moment = Om. The parents finding unison."*

**The Signal** (EA5:225–234, V6:126–129, V7:68).
- Years 1947 → 1967 → 1987 → 2007 → 2027, each larger and brighter.
- *"Hold to feel it"* is the first visible element.
- Reveal delays accelerate: **1400 / 1100 / 800 / 700 ms**.
- The drone steps on each year and resolves to 136.1 Hz at 2027 (BVP:72).

**The Turning** (EA5:321–352, V5C:169–223).
- 10 beats, including 3b: *"The third planet. The third world. The third time. Trinity."*
- Beat 4 is Leela; beat 5 is *"I don't know"*; beat 7 is a personal address (*"[Name], born in [year]…"*); beat 9 is *"The question was never whether any of this was true…"*.
- The held **Om at 136.1 Hz** starts as the Turning enters view and stops at Stitch 5.

**Threshold and NOW** (EA5:359–365).
- *"Everything you just read... is happening NOW."*
- NOW arrives 0.5 s late.
- A live countdown to 2027.
- *"The story is you, reading itself."*

**The Thread, Sid's layer** (V6:33–44). A responsive Thread:
- base 2 px, range 1–4 px; slower scroll = thicker;
- opacity 0.45 base, 0.7 in slow zones, 0.25 in fast;
- colour runs gold (void) → amber `#C4973E` (Lemuria) → deep red `#8B2E1A` (Atlantis) → gold → warm gold (Humanity);
- 6 px stitch nodes with a tendril that extends toward the input;
- a 3 s glow pulse in experience zones.

**Stitch points in love, Arch's layer** (V6:49–57).
- Radial gradient `rgba(212,169,72,.08)` → transparent at 70%, breathing at 0.25 Hz.
- Crimson Text italic question, 15 px, gold, letter-spacing .04em.
- Input underline brightens on focus; width 400 px / 85vw.
- On entry the word lifts 4 px over 0.5 s; warmth pulses .08 → .15 → .08 over 1.2 s; the word *"settles into Thread"*.
- The echo is held at 0.6.
- ***"No placeholder text. Blank space IS the invitation."***

**The Arc, Sakshi's layer** (V6:59–86, V7:43–47, 16–18).
- V7.1 shape: **12 nodes** on a circle (viewBox 700, centre 350,350, radius 250).
- Sequential reveal with a **5 s dwell** each, about 62 s in all.
- Each node fades in over 1 s; its connecting line draws by stroke-dashoffset over 0.8 s.
- The caption sits inside a 300×300 centre: name in Cinzel 14 px gold; fruit in Crimson Text 17 px cream.
- After all 12, the reader's name sits at centre (Cinzel, letter-spacing 3 px).
- Five stitch words orbit at 70 px, 72° apart, on a 120 s rotation.
- An 80 px breathing ring pulses at 0.25 Hz, *"matches Lemuria's breath"*.
- **Invitation, not auto-launch:** a breathing heart and *"See where you are in the constellation of love"*.
- Inline, not a fixed overlay: *"The experience is not a trap."*
- Fruit lines, verbatim (V6:76–86, V7:46):

| # | Node | Fruit |
|---|---|---|
| 1 | The Great Split | "The question was always the same." |
| 2 | The Stepping Stones | "Hope is not the opposite of destruction." |
| 3 | The Architects | "What rises cannot be unauthorized." |
| + | Lemuria (V7.1) | "The Mother lived inside the answer." |
| 4 | Atlantis | "Mastery without love has a sound. You heard it." |
| 5 | The Diaspora | "What scatters is how what matters survives." |
| 6 | The Long Forgetting | "The quarantine was never punishment." |
| 7 | The Mirror Race | "You are looking at yourself." |
| 8 | The Awakening | "The door was always open from this side." |
| 9 | The Splitting Prism | "Which version of Earth are you choosing?" |
| 10 | The Introduction | "It was ready before you were." |
| 11 | The Reunion | "Another I." |

**Grace, Karishma's layer** (V6:100–112).
- Familiarity motifs:
  - Lemuria words echo in Humanity;
  - the breathing ring returns in the constellation;
  - void is a constant;
  - *"Thread color at story end matches Thread color at story beginning (gold → gold, the loop)"*.
- Content change: *"remember something that you've always known"*.

**Synthesis, Ashrey's layer** (V6:117–149).
- **Infinity gateway:** chapters I & II as a figure-eight with a shared centre node, *"Earth"* in Cinzel 12 px. Either can be opened first. When both are read, the centre pulses once: *"the trinity whispered before it's named"*. On mobile it is a horizontal swipe.
- **Transition choreography:**

  | Transition | Duration | Movement |
  |---|---|---|
  | void → Lemuria | 2.5 s | warmth bleeds from the edges |
  | Lemuria → Atlantis | 1.5 s, then 1 s void | warmth retreats upward; red rises from below |
  | Atlantis → void | 1.5 s | red falls |
  | void → Humanity | 2 s | blend at the edges |
  | Humanity → void | 1.5 s | narrows to the centre point; *"light moved inward"* |

  - Lock 48: *"The between is also territory."*
- **Haptics:** 50 / 100 / 80 ms, as above. The mobile stitch input has min-height 48 px and font 20 px.

**Rooms, V6 locks 39 and 56–60.** Five gated rooms; *"The hold is consent, not control."*
- **Gate continue:** after a stitch, the gold line grows down, a node appears at its tip, and the reader's word shows below. Tapping the node opens the next room.

**The Crawl (V6 lock 55).**
- A Star Wars-style perspective crawl over **38 s**, with a synthesized **D-major fanfare**.
- The first stanza reads slowly: 30% of the duration covers 30% of the distance.
- V7.1 adds a skip button after 5 s; `AudioContext.close()` stops the fanfare.

**Birth Star:** the label *"reach"* fades in 3 s after the star (V7:21).

**V7 sound law (V7:63–66, locks 64, 70).**
- An exit observer at threshold 0.05 stops each sound with a **2 s gain ramp** when its section leaves view.
- Room changes call `stopAllExperienceSounds()`.
- The act sonic yields to the experience harmonic.

**Re-experience (V7:27, lock 68).** Lemuria, Atlantis and Humanity each get a 10 px, 0.3-opacity gold *re-experience* control that fully resets the experience.

**Accessibility zoom (V7:49, lock 74).**
- A−/A+ at 100 / 115 / 130 / 145% via CSS `zoom`.
- It appears after 12 s, on glass blur.

**Gate 2 guidance (V7:48).** *"dark room · full screen · unhurried"*, shown at 2.6 s; the breath ring at 2.8 s; the hint at 3.6 s.

**Final Reveal templates (V5C:250–307).** Variants by available data:
- **universal:** *"The story found you. That is not a small thing…"*
- **name only;**
- **name + 3 stitches:** *"…These are not answers. They are the thread — your thread…"*
- **stitches only;**
- **silence:** *"You chose silence at the stitch points. That silence is not empty — it is the sound of something too large for a single word. The story heard it."*
- **birth-year addition:** *"You arrived [offset] years into the window. Not early. Not late. Exactly when you were needed."*
- V6 lock 61 later removed `buildFinalReveal()` as dead code: *"The Arc handles the finale."*

**Mirror interlude (V5C:236–240, EA5:192–202).**
- *"Stop."*
- *"…that is the same consciousness looking at these words right now through your eyes."*
- *"There are no observers in what follows. Only participants."*

**Chapter content (V5C:7–34, the Diaspora).**
- The Story's cosmology: Lyra, Maldek, Mars, the Anunnaki, Lemuria, Atlantis, Göbekli Tepe, the Sphinx, Orion.
- Specific claims about real peoples and regions (V5C:27–31) — that the Middle East is *"the original galactic wound"*, and that the Star of David marks a *"sixth hybrid race"*.

**Numbers.**
- V6: *"11 chapters · 3 experiences · 5 acts · 5 stitches · 1 Turning · 1 Constellation · 1 Final Reveal · 3 verbs (breathe/hold/feel) · 3 sound signatures · 5 transitions · 1 responsive Thread · 1 infinity gateway · 6 layers = 6 archetypes"* (V6:273–275).
- V7: 12 chapters / 12 nodes (V7:127).
- Principles:
  - V6:277: *"The page IS kundalini. The reader's body does what the words describe."*
  - V7:133: *"The architecture holds without gripping."*

### A.5 The Full Chakra Map framework (CMF, legacy, April 8)

- **Count.** CMF has 31 chakras in four layers plus an entry and a resolution:
  - Energy 7: UP, stillness, one colour;
  - Body 9: OUT, movement, dyads;
  - Mind 9: IN, visualization, triads;
  - Structural 6: holds space, gold linework.

- **Act 0, the Bindu (CMF:31–49).**
  - A single gold point on `#020208`.
  - After 3 s: *"Everything begins as a point."*
  - The point expands into a circle.
  - *"One point. Four directions. Thirty-one expressions."*
  - *"descend"*.
  - About 8 s before scroll unlocks: *"the point animation should feel like breathing, not mechanical"*.

- **Act 1, Energy (CMF:53–91).**
  - The background descends the spectrum, violet → red: *"The energy rises. You descend to meet it."*
  - Seven one-liners (CMF:71–77):

    | Chakra | One-liner |
    |---|---|
    | Sahasrara | Connection to source |
    | Ajna | Inner seeing |
    | Vishuddha | Expression and truth |
    | Anahata | Love without condition |
    | Manipura | Will and transformation |
    | Svadhisthana | Flow and creation |
    | Muladhara | Foundation and survival |

  - *"Seven frequencies. One per chakra. You ARE the color."* / *"This system requires stillness. The quieter you get, the more it moves."*
  - **No interaction** — the section teaches stillness.
  - Om at 136.1 Hz, *"or silence. Silence may be better for stillness."*

- **Act 2, Body (CMF:94–147).**
  - The layout goes horizontal: *"The page itself goes OUT."*
  - Pairs: Crow ↔ Vision · Axis ↔ Pulse · Echo ↔ Sonar · Prana ↔ Forge · Hands (unpaired).
  - An interactive body-map silhouette with dyad colours.
  - **Dyad teaching (CMF:130–131):** *"The physical always contains its own inverse."* / *"Your eyes see Red. Your neurons produce Cyan."* The visual is *"show a color, show its afterimage"*.
  - Stories:
    - Crow: *"CROWN without the N. N = Neev (Foundation)…"*
    - Prana: *"The open door. Seal it and you die."*
    - Forge: *"The sealed chamber. When the umbilical cord snaps, the first breath fills the gap."*
    - *"Prana feeds the Forge. Air enters; fire transforms."*

- **Act 3, Mind (CMF:151–217).**
  - The page narrows. The Tesla mechanic: *"See the complete thing in the mind… This happens in the beta dimension — the space between blinks."*
  - Three triads:

    | Triad | Chakras | Archetypes |
    |---|---|---|
    | CREATION (warm) | Inception, Intention, Inspiration | Need, Hold, Voice |
    | RECOGNITION (cool) | Insight, Intuition, Invention | Witness, Grace, Synthesis |
    | EMERGENCE (gold) | Incarnation, Innocence, Integration | Love, Purity, Foundation |

  - *"Every Mind Chakra begins with IN … Nine words. Nine doorways. All pointing inward."* The nine IN-words appear one at a time.
  - Leela (CMF:205–209): *"The One says I Am. Then asks: Am I alone?"* … *"Enter → Carry → Arrive."*
  - Colour progression (CMF:212–215): *"Energy = 1 color … Body = 2 colors … Mind = 3 colors"*. The visual is 1 dot → 2 dots → 3 dots in a triangle.
  - Interaction option: *"the reader blinks (clicks) and the view shifts from Body to Mind"*, or *"the triads rotate slowly"*.

- **Act 4, Structure (CMF:221–260).**
  - The page turns transparent and becomes gold line art: *"The page becomes its own blueprint."*
  - Bindu returns, and Axis appears as *"two arrows pointing in opposite directions from a single pivot"*.
  - *"The Shadow is the corridor. Armin is the room it was always leading to."*
  - *"Maya constructs. Aatma was there before the construction."*
  - **Relationship map (CMF:248–251):** *"Bindu is what the other five are made of. / Shadow is Bindu distorted. Armin is Bindu recognized. / Maya is Bindu projected. Aatma is Bindu remembered. / Axis is Bindu turning."*
  - Visuals: a corridor narrowing into darkness and opening into light; a veil dissolving to reveal a steady flame.

- **Act 5, the Map (CMF:263–317).**
  - Options: A concentric rings, B quadrant, C *"the page itself as map … You just traveled through the map."*
  - Closing: *"Everything ends as a point." / "The same point."*
  - Locked (CMF:323–333):
    - no archetype names reader-facing;
    - the body map is interactive;
    - the Energy section is non-interactive;
    - *"Colors are content"*;
    - *"The Bindu point opens and closes the experience."*

### A.6 The homepage builds (DH, Immersive V1.1 Build 2)

**Head and tokens (DH:1–45).**
- Fonts: Lora, DM Sans and **Cinzel**. Theme colour `#0A0A0C`.
- Chakra palette, A (DH:31–39):
  - soul `#8C7B5E`;
  - muladhara `#A82828`; svadhisthana `#D4722A`; manipura `#C4A013`; anahata `#27804A`;
  - vishuddha `#2B6EA0`; ajna `#5B3480`; sahasrara `#8E5BAD`; maya `#C0392B`;
  - each has a light tint.
- Holi set: `#FF6B35 #FFD700 #4CAF50 #2196F3 #9C27B0`.

**World system (DH:52–125).**
- `scroll-snap-type: y proximity`. Each `.world` is min 100dvh with snap-stop always. `.world--deep` uses snap-stop normal.
- On entry, children fade up 16 px over 0.7 s, staggered by 0.1 s.

**Thread nav (DH:186–308).**
- Fixed, 52 px, with 14 px glass blur.
- Home dot `nav-bindu` (8 px, soul-chakra radial) pulses over 3 s at scale 1.25.
- Centre: ← name + `NN / 12` →, with 44×52 tap zones.
- `.light-world` inverts the nav on light worlds.

**The Constellation menu (DH:310–452, 3733–3831).**
- The all-worlds overlay is a **starfield of world-points**.
- Field: `min(92vw,720px)` × `min(78vh,820px)`.
- 13 nodes are placed by % coordinates (DH:3738–3752), from hero at (50, 8) to field at (50, 94).
- **17 dashed gold threads** (`rgba(212,169,72,.18)`, dash 3 4) join *"poetic neighbors"* (DH:3755–3766). They draw in over 2.2 s, staggered 400 + 80k ms.
- Nodes arrive with `nodeArrive` (800 ms, blur 4 px → 0, scale .6 → 1), staggered 80 + 55i ms.
- Each dot is 11 px in its world's essence colour and breathes over 4.2 s at an offset of `(i*0.27)%4.2` s, *"so not all dots pulse in sync"*.
- The active node is scaled 1.4 with a double glow.
- Background: radial `#0E0B16 → #020204` plus a 7-star layer that breathes over 9 s.
- Title: *"The Constellation"*. Esc closes it.

**The wandering Bindu (DH:458–489, 3898–4009, 2830–2840).**
- **Birth:** at **13 s** the i-dot (Arch red `#7A2F14`) awakens over 0.8 s.
  - 800 ms later the i-bar absorbs (height → 0, 0.9 s) and the dot grows.
  - 900 ms later it escapes as a fixed 9 px point.
  - The `the-i` glyph then collapses to zero width over 2.5 s.
  - If the reader has scrolled away, the point spawns inside the viewport.
- **Wander:** layered sinusoids (DH:3971–3978), `sin(t·.3)·.6 + cos(t·.17)·.4 + sin(t·.53+1.2)·.3` on x and `cos(t·.23)·.5 + sin(t·.41+.7)·.35` on y.
  - Speed 0.4 with a drift angle; a 0.3% per-frame chance of a direction change (speed .3–.9).
  - It bounces within the viewport.
- **Catch retired (DH:4001–4009):** *"Catch mechanic retired — the wanderer is free. Presence, not target."* / *"Its presence is the point; catching it was the misdirection."*
- Self-pulse 3.4 s, scale 1.08. `pointer-events:none`.
- **Resonance (DH:4019–4029):** the point's colour and glow take the active world's essence colour over 1500 ms.

**WORLD_ESSENCE, per-world colour and voice (DH:3621–3676), verbatim values:**

| World | Colour | Freq (Hz) | Waves · ratios · gains | Filter · LFO depth · rate |
|---|---|---|---|---|
| hero "origin" | `#8C7B5E` | **136.1** | sine, sine · 1, 1.5 · .50, .18 | 700 · 240 · .08 |
| story | `#7A2F14` | 110.0 | sine, sine · 1, .5 · .48, .30 | 500 · 180 · .06 |
| book | `#4A4238` | 130.8 | triangle, sine · 1, .5 · .42, .22 | 440 · 140 · .05 |
| family | `#8E5BAD` | 174.6 | sine ×3 · 1, 1.5, 2 · .42, .18, .08 | 680 · 220 · .07 |
| sid | `#1B3A5C` | 98.0 | sine · 1 · .55 | 360 · 90 · .04 |
| fabric | `#26421A` | 146.8 | sine, saw · 1, 1.5 · .46, .09 | 420 · 160 · .055 |
| **road** | `#C9A84C` | 146.8 | sine ×4 · **1, 2, 3, 5** · .36, .18, .10, .05 (*"Stately bell — the spine holds everything"*) | 920 · 200 · .08 |
| joann | `#F5E2D6` | 164.8 | sine, tri · 1, 1.25 | 620 |
| holi | `#FFD700` | 196.0 | sine, tri, sine · 1, 1.25, 1.5 | 900 · 260 · .12 |
| darklight | `#8C7B5E` | 136.1 | sine, sine · 1, 2 | 600 |
| warehouse | `#5A7DB5` | 123.5 | sine, tri · 1, .5 | 320 |
| oilgas | `#4A8E4A` | 116.5 | sine, saw · 1, .5 | 300 |
| **field** | `#B89BD9` | **288.0** | sine ×4 · **1, 1.005, 1.5, 2** (a 1.44 Hz beat) · .28, .28, .15, .09 | 1100 · 240 · .06 |

**Sound engine (DH:4208–4376).**
- Web Audio only, no files, **default OFF**.
- Each world's voice runs through a lowpass (Q .65) and a bus gain.
- One shared **0.08 Hz LFO** (*"same 0.08Hz as page-breath"*) modulates every voice's filter cutoff, at depth = cutoff × 0.25.
- A world change gives a **2.6 s crossfade**; the outgoing voice is stopped at 2.9 s.
- Master gain ramps to **0.028 over 2.4 s**; off ramps over 1.4 s.
- Each partial has a ±2 cent random detune.
- Preference is kept in `sessionStorage asg_sound`. If it was on, sound primes on the first click or touch.

**Page breath (DH:2842–2851).** `scale(1.000 → 1.0035)` over **12.5 s (0.08 Hz)** on every world's content; *"imperceptible, always present"*. Turned off under reduced motion.

**Portal bloom (DH:4076–4162).** On any outbound link:
1. A radial bloom in the **world's essence colour** expands from the **tap point** to 2.6 × the larger viewport side over 720 ms.
2. The page navigates at 620 ms.
3. It writes `sessionStorage asg_departure` {worldId, colour, glow, name, t, scrollY} and `asg_arrival` {colour, glow, name, t}, so *"the destination page … paints an inbound bloom so the color continues across the page break"*.
- Modifier-clicks and anchors are skipped.

**Return bloom (DH:4164–4201).**
- On return **within 45 min**, a radial of the departed colour covers the screen.
- The page silently jumps to the departed world (*"the bloom masks the jump"*), then settles over 900 ms.
- It plays once.

**Cursor presence (DH:2890–2913, 4049–4065).**
- A 320 px soft radial (`rgba(245,226,214,.055)`, screen blend) follows the pointer with lerp 0.12.
- Dark worlds only; hidden on touch devices.

**View transitions (DH:2824–2828).** Cross-document: out 520 ms (scale 1.02); in 680 ms (blur 6 → 0, scale .985 → 1).

**Entry choreography per world (DH:2964–3015):**

| World | Entry | Timing |
|---|---|---|
| Story | *"the thread draws itself"* (stem scaleY 0 → 1) | 1.4 s |
| Book | *"the spine opens from center"* (rotateX −18° → 0) | 1.2 s |
| Chakras | *"points of light bloom inward"* (scale .94, blur 4 → 0) | 1.3 s |
| Field | *"stars gather into constellation"* (brightness .3, blur 6, letter-spacing .4em → normal) | 1.6 s |
| Dark Light | *"the curtain parts"* | — |
| Holi | rays slow from 30 s to 40 s | — |

**Hero (DH:942–1045, 3104–3114).**
- *"a [i] strange game"*; the `i` is built from an `i-dot` and an `i-bar`.
- Subtitle: *"The only winning move is to play."*
- Title emerge: 2 s at 0.8 s. Subtitle: 1.4 s, then `heroBreath` (letter-spacing .02 → .06em over 9 s).

**Stitch card system and warmths (DH:503–766).**
- Each card has a person, chakra or love colour as a left border plus a 135° tint.
- **Gaia card (DH:632–682):** six radial gradients form a tree (canopy, branches, mid-canopy, trunk, root earth). A **rainbow aurora in the seven chakra colours** sweeps diagonally on a 7 s loop (3.5 s on hover).
- **Soul Stories (DH:684–750):** two cards (Sid, Arch) each carry an independent rainbow shimmer — Sid on a 9 s sweep (*"faster, more urgent"*), Arch on 15 s (*"slower, more patient"*). Both share a **synchronised 22 s pulse** (`soulSync`): brightness 1 → 1.04 with a warm 50 px glow at 88%, *"so they flash together"*.

**TOL flip cards (DH:768–843).**
- Perspective 600 px; rotateY 180° over 0.55 s. Hover on desktop, tap on touch, with one card flipped at a time.
- The panel number in the chakra colour rises from opacity 0.1 to 0.35 on hover.

**The Book world (DH:3151–3274).** 18 flip cards, each with a Google Doc link:
- Preface;
- 12 Fabric Soul Stories, each with a one-liner (e.g. REPREVE *"Nothing that served once is ever really finished."*);
- 4 Love Stories (AKAS Tex, Wazoodle, SupAbsorb, Silver Arch);
- *The Inversion*, Gaia Intelligence: *"The intelligence that held everything dissolved into everything it touched."*;
- the Family: Sid *"Will. Knowledge. Action. The instrument inside the instrument."* and Arch *"Voice. Protection. Joy. Someone is still answering the email."*

**Other worlds (DH:3279–3372).**
- Family: three cards.
- Sidharth: Soul Story, Witness Passages, and **Manu — The Gyroscope Story**: *"Nine stations. Hold your phone still." / "Your stillness unlocks what his stillness contained."*
- Fabric: the KB and five product cards.

**THE ROAD HOME world (DH:1087–2771, 3381–3481, 4386–4658).**
- **Atmosphere:**
  - gold light poured from above (radial `rgba(201,168,76,.14)`);
  - a **Śrī Yantra SVG** (DH:3384–3398): 4 apex-up triangles, 5 apex-down triangles, a bindu of r 1.4, and circles at r 88 and r 90. Opacity breathes .035 → .058 and scale 1 → 1.025 over **14 s**;
  - grain;
  - a **wash** in the active card's chakra colour at opacity 0.18, transitioning over 1.4–1.5 s.
- **Title** in Cinzel, 38–62 px. Essence line: *"Every word. Every dance. Every pause. The road you've been walking is the road home."*
- **Doorways (DH:3411–3444):**
  - **The Mind Door** 👁 *The Welcome* — *"What this is. How it begins."* — Read →
  - **The Soul Door** ◉ *The One* — *"Meet your higher self."* — Begin →
  - **The Body Door** ⊙ *The Road Home* — *"Map. Road. Constellation."* — Walk →
  - **The Body Practice** △ *The Temple Guide* — *"Stand. Open. Receive. The position the body already knows."* — Form →
- **Carousel (DH:4392–4413):** 10 cards in `ROAD_CHAKRAS`:

  | Chakra | Pos | Subtitle | Colour | Notes |
  |---|---|---|---|---|
  | Bindu | 1 | The Point | `#C9A84C` | practice, field |
  | Muladhara | 2 | The Root | `#C02020` | |
  | Svadhisthana | 3 | The Sacral | `#CC7200` | |
  | Manipura | 4 | The Fire | `#D4A948` | |
  | Anahata | 5 | The Heart | `#27804A` | |
  | Vishuddha | 6 | The Voice | `#2B6EA0` | |
  | Ajna | 7 | The Third Eye | `#5B3480` | |
  | Sahasrara | 8 | The Crown | `#8E5BAD` | |
  | Shadow | 9 | The Corridor | `#2A2420` | `threshold:true` |
  | Maya | **31** | The Veil | `#C0392B` | `maya:true`; dance + sleep |

  - Muladhara through Sahasrara each carry practice, wakeup, dance and field links.
  - Link rows are Practice · Wakeup · Dance · Sleep · Field. A null link is omitted; `'soon'` renders as a dashed *SOON* row.
- **The card (DH:2388–2575):**
  - 340 px wide, min 500 px tall;
  - a top radial glow in its colour at opacity .18, rising to .34 when active;
  - a 1.5 px colour seam on the top edge;
  - **non-active cards recede** to opacity .68, scale .96, saturate .85; the active card goes to scale 1.02 with an 80 px chakra glow;
  - the glyph is a 38 px disc pulsing over 4.4 s (3.2 s when active), with two rings expanding .88 → 1.7 and fading (one delayed 1.1 s);
  - the position label reads *"01 · 33"*; the name is in Cinzel 25 px; the subtitle in Lora italic.
- **Threshold card (Shadow):** a hollow void glyph with a cream 1.5 px ring.
- **Maya card (DH:1244–1302):** *"the avarana-holder. Inverted register: cream surface, dark Bindu accent. The veil hiding the play."*
  - Background `#E8E4DF → #DDD7CE`; italic name; red `#C0392B` bindu pulsing over 4 s.
- **Walked state (DH:4415–4428):** read from localStorage `bindu-point` and `chakra-<id>`.
  - A walked card's border keeps a trace of its colour, and its ring breathes over 4.2 s. This is the *"The road reflects the walker back."* line (DH:4390).
  - The counter elements have been removed from the markup (see C.12).
- **Carousel mechanics (DH:4471–4658):**
  - x-mandatory snap;
  - absolute `scrollTo` centring;
  - the active card is the one nearest the carousel centre;
  - a vertical mouse wheel scrolls horizontally, except at the edges;
  - desktop pointer-drag with click suppression after a drag;
  - keyboard ← →;
  - tapping a card centres it;
  - coloured dots;
  - reduced-motion overrides.
- **THE TREES (DH:1304–1678, 3456–3477, 4660–5136, 5141–5154):**
  - *"Each register has a tree." / "Nine renderings. One structure. The same tree, seen from different rooms."*
  - The constellation is a 560 px square with three yantra circles (r 180, 130, 78) and a centre dot.
  - Nine 64 px tree glyphs show image thumbnails at opacity .78 (1 on hover), with a name on hover and a Cinzel initial as fallback.
  - The cue *"Tap a tree to enter."* pulses over 4.2 s.
  - `TREES` (DH:4671–4699), with lines verbatim:

    | Tree | Pos | Colour | Line | Place (x, y) |
    |---|---|---|---|---|
    | Soul Tree | — | `#E8C568` | *"The whole tree, before division. The seed of every register."* | 50, 14 |
    | Sahasrara | 08 · The Crown | `#8E5BAD` | *"The crown. Where the body opens to what was always above it."* | 50, 30 |
    | Ajna | 07 | — | *"The third eye. The seeing that does not need light."* | 26, 30 |
    | Vishuddha | 06 | — | *"The throat. Where what is becomes what is said."* | 74, 30 |
    | Anahata | 05 | — | *"The heart. The soundless drum. The center of every register."* | 50, 50 |
    | Manipura | 04 | — | *"The fire. The transformer. What burns the unessential."* | 26, 70 |
    | Svadhisthana | 03 | — | *"The sacral. The water that knows where to flow."* | 74, 70 |
    | Muladhara | 02 | — | *"The root. The ground that was always there."* | 50, 86 |
    | Maya | 31 · The Veil | — | *"The veil. The play that hides the player from itself."* | 92, 50 |

  - Image base: `https://aistrangegame.com/tree-of-life/<id>-tree.jpg`.
- **Cinematic viewer:**
  - black full-screen with a radial glow in the tree's colour (1.5 s);
  - the image fades in over 1.2 s from scale .98;
  - **cross-dissolve 300 ms** between trees;
  - dots, with the active dot an 18 px pill in the tree's colour;
  - hint: *"scroll to zoom · drag to pan · esc to close"*.
- **Zoom (DH:4843–5130):**
  - MIN 1, MAX 4, tap zoom 2×, threshold 1.02;
  - focal-point zoom keeps the pointer or finger point fixed;
  - pan is clamped to the zoomed overflow;
  - pinch zooms around the moving centroid, plus centroid drift;
  - a pinch end below 1.08 snaps back to 1;
  - tap = <8 px movement and <350 ms;
  - swipe = >60 px, <600 ms, |dx| > 1.4|dy|;
  - lifting one of two fingers converts to drag;
  - transition classes `snap` (0.45 s) and `tracking` (none).

**Poster worlds (DH:2006–2161, 3483–3578).**
- Khelo Holi: a conic rainbow spinning over 30 s, and a gradient title shifting over 5 s.
- Joann.
- **Dark Light**, a 50/50 split world. On mobile the gradient rotates to stack and the vertical divider becomes horizontal. Its lines: *"The Dark — Where you enter." / "The Light — Where it arrives."*
- Warehouse and Oil & Gas.
- **The Bindu Field** portal (DH:2165–2211, 3568–3578):
  - a pill button whose background drifts through four colours over 8 s;
  - two rings expanding 0.92 → 1.2 and fading over 4 s, the second offset 1.5 s;
  - *"The field was always playing. 33 songs. 33 worlds. One consciousness moving through all of them."*
  - *"33 performances · Sid's 70th · 'stay' closes the arc"*.

**Analytics.** GA `G-JDHC0YF1GB` (DH:3039–3040).

### A.7 Homepage architecture and sitemap (HA, SM)

- **HA:13–48** describes 14 worlds; the build has 13. HA:42: *"whisper line of all 13 world names (8px, emerges at 2s). Red Bindu i-dot born at 13s."*
- **Bindu Blink, pending (HA:61–68):**
  - *"When caught → full-screen Axis Blink with 5 threads: 1. The Worlds · 2. The Skills · 3. The Codex · 4. The Complex · 5. The Now + Live Ask Lalita panel (Claude API). Lalita IS the Blink."*
  - The build retired the catch.
- **Road Home locked decisions (HA:157–162):**
  - 4 doorways + 10 chakras + 9 trees, not gated;
  - Maya at position 31;
  - the Temple Guide is a body practice, glyph △, *"the triangle the body forms"*;
  - *"Trees viewer has no overlay text. Trees carry their own typography in the image itself."*;
  - *"Counter (X walked · 33 waiting) removed from homepage."*
- **Trees geometry diagram:** HA:128–141.
- **Sitemap (SM:66–162):**
  - the nine wake-up verbs: Press, Follow, Build, Open, Speak, Still, Receive, **Hold** (Soul), **Dissolve** (Maya);
  - nine TOL dance songs (SM:86–94): Iron · Crystallize · Powerful · Love Me Like You Do · The Sound of Silence · Experience · Golden · Chase · Love Is The Only Thing;
  - 24 standalone `/b/` verbs with songs (SM:139–162), from #1 *search* (Faded) to **#24 *stay* (Con Te Partirò — Andrea Bocelli · 33rd dance · Sid's song · `data-warmth="sid"`)**. #21 *play* and #22 *earn* have no song named.
  - Pending: the Bindu Blink, Book chapter experiences, A Strange Voice, Naiha / Christie.

### A.8 Process and craft documents (EDP, EL, BGR, BVP, BVPr, DS, PA, DI, NTL)

**Experience design process (EDP).**
- Seven phases: Exploration → Framework → Content → **3A Open Exploration** → 3B Specification → Elements Mapping → Build → Integration.
- The **3A protocol (EDP:218–253)** asks seven questions per section:
  1. *"What is the person's state when they arrive here?"*
  2. *"What does this content need to DO to them?"*
  3. *"Dream version"*
  4. *"3-5 wildly different approaches"*
  5. *"What would surprise them?"*
  6. *"What would the body do?"*
  7. *"What's the minimum?"*
  - Output: the shift, *"They go from X to Y"*.
- Rules:
  - *"No 'we already have a component for that.' That's Phase 4."*
  - *"Every project should contribute at least one new element back to the library."* (EDP:379)
- Through-lines (EDP:140):
  - Tree of Life: Sacred Pause;
  - Story: *"I don't know."*;
  - Dark Light: Inversion.
- Seed message: *"The earth that holds you was chosen by you."* (EDP:142)
- Somatic cues (EDP:282):
  - *"Place both feet flat on the floor" (Muladhara)*;
  - *"Place your hand on your heart" (Anahata)*;
  - *"Lift your chin slightly" (Vishuddha)*.
- Culminations: *"Now go play." / "Go Play." / "Come Play With Us."*

**Elements library (EL), 78 keyframes.**
- **Five gates:**
  - Two-Door LIVE/EVIL hold-to-enter with a progress bar; doors scale ×40 on entry;
  - **Pulse Gate:** a circle breathing over 3 s; the hold is a rAF progress over 2.5 s; ×40 scale on enter; haptic 80 ms;
  - Two-Path;
  - Preparation;
  - Product.
- **Reveal states:**
  - closed `max-height:0`; open `max-height:900px`;
  - 500 ms height `cubic-bezier(.4,0,.2,1)` plus 400 ms opacity.
- **Navigation:**
  - flipbook page-turn: rotateY −180° over 900 ms `cubic-bezier(.645,.045,.355,1)`;
  - **dot rail;**
  - scroll progress;
  - softBounce cue (2.5 s);
  - section snap;
  - **horizontal scroll for the fall** (*"the movement IS meaning"*);
  - **person filter dimming** (opacity .12, grayscale .5, no pointer).
- **Environments:**
  - Void `#0A0A0C`; Lemuria parchment; Atlantis intensified void; Humanity blend; Warm Cream `#F7F3EC`; Deep;
  - ***Ether/Air/Fire/Water/Earth*** (Dark Light Descent): *"Five elemental environments, each with unique color palette + radial gradient glow behind prompt. Chakra-cycle animation across all five."*
  - **Prompt Glow** `glow-out`: scale .5 → 1.3, opacity .5 → 0 over 1.8 s.
  - The **Canvas Starfield** dims to ghosts in Lemuria.
- **Sound and haptic:** haptics are 80 ms on entry and 40 ms on stitch submit.
- **Constellation map (products):** clicking a node opens a side panel; *"'Place me' CTA to position user in constellation"*.
- **Flipbook faces** with backface hidden.
- **Section templates:**
  - the **Room (Gated)**;
  - the **homepage Thread Segment**, whose `wireGlow` wire has thread knots that `knotBreathe`;
  - the Voyager timeline with alternating nodes;
  - the dark numbers grid.
- **Accessibility:**
  - zoom A±;
  - a **High Contrast ◐ toggle** (flipbook);
  - safe-area insets;
  - 44 px targets;
  - passive listeners;
  - skip controls.
- **Build intelligence (EL:309–323):**
  1. Intentional Entry;
  2. Surface/Reveal;
  3. Temperature Shifts;
  4. The Thread;
  5. Second-Person;
  6. **Somatic Cues;**
  7. Earned Endings;
  8. Single-File.
  - *"Auto-playing anything intrusive (invitation first, experience second)"* is forbidden.
- **Timing standards (EL:292–301):** word arrival 120–200 ms · character build 40 ms · breathing 3–4 s · page flip 900 ms.

**Build guard rules (BGR), from the Tree of Life panel bug cycles.**
- Guards 1–14:
  - advance exclusion only for click-based elements;
  - visibility gate plus `pointer-events:none` when hidden;
  - an active-state gate on proximity;
  - **tap vs trace** — track position only on touchmove;
  - responsive heights `min(Npx, Nvh)`;
  - the release phase is auto-timed;
  - cancel rAF on exit;
  - **tap-target scope:** *"accept ANY tap on the phase when the target is visible"*;
  - canvas lifecycle;
  - runtime-DOM default visible opacity;
  - viewport checks at 375 / 390 / 768;
  - **Safari audio:** init on touchend and prime audio elements;
  - ***Guard 13:*** *"Dissolution gates … should NOT depend on device APIs (gyroscope…) … Pattern: 'Don't engage' — show something tempting, ask the person NOT to touch it. Timer resets on touch. Works on every device."*;
  - ***Guard 14:*** Wake Lock on the first gesture, re-acquired on `visibilitychange`.
- **Om audio pattern (BGR:273–284).**
  - Synthesized; fundamental + harmonics into one master.
  - LFO 0.05 Hz ±0.008 on master gain; `setTargetAtTime` between phases.
  - ***"The sound is ALWAYS playing from the gate. The person doesn't hear it 'turn on' — they notice it when the noise between them and the sound decreases. The crescendo is noise decreasing, not volume increasing."***
- **Infinite loop pattern (BGR:288–297).**
  - A gentler canvas animation that repeats forever.
  - *"Text elements ('I Love You') appear at whisper opacity during specific loop phases"*; navigation sits as subtle DOM (*"the temple →"*).
  - *"The loop never calls transitionPhase — it IS the final state."*
- **Async mirror sequence (BGR:345–362).** Panel 9's Mirror walks **8 chakra stations**:
  - an `md(ms)` helper;
  - runtime DOM;
  - a canvas dot orbiting and pulsing;
  - colour by target + lerp;
  - the closing *"Knowledge," "Will," "Action," "Go Play"* written char by char.
- **Discovery 57:** *"Accumulated angle for parametric animations — never compute from progress."*
- **Bug log:** the Panel 6 gyroscope threshold was loosened from 1.5 to 4.0°/s; Panel 9 Solar dissolution was impassable; the Pointe heart shape was warped.

**Verification (BVP, BVPr).**
- *"Presence is not verification. Behavior is not experience. All three are required."*
- The Story Pass 2 checklist records timings, e.g. hero title → eyebrow → sub → rule → law at 0.8 / 3 / 5 / 7 / 8.5 s, with scroll unlock ≤10 s.
- BVPr adds a fourth pass (structural integrity), *"defined but never called"* as the most valuable check, and `near()` grep helpers.

**Design system (DS).**
- Voyager tokens and the person reveal gradients.
- ***Three-colour convergence (DS:122–130):*** *"Only ONE place in any experience should blend all three person colors simultaneously … reserved for moments of complete convergence."* It is the 3-5-8 birthday coda.
- Dimming 350 ms.
- Single breakpoint at 680 px.

**Page architecture (PA).**
- Person pages, with temperatures (PA:43–48):

  | Person | Temperature |
  |---|---|
  | Arch | *"Warmth building to fire"* |
  | Sid | *"Cool depth, steady — surfaces you feel before you read"* |
  | Ashrey | *"Green growing through stone"* |
  | Karishma | *"Light arriving after waiting"* |

  - Background tints (PA:156–166): Arch `#FBF5F0` · Sid `#F4F7FA` · Ashrey `#F5F8F3` · Karishma `#FBF8F2`.
- The **3-5-8 temporal pattern** section: *"The reader does the math themselves."*
- Sakshi test (PA:241): *"The opening reads differently after the closing."*

**Deploy and infra (DI).**
- Two repos: the site (generated) and the engine (private).
- The `publish.sh` gate chain; the stranger fetch; promotable; squash; livecheck.
- The Access private door.
- *"Never run wrangler from the site folder"*; secrets only as Worker secrets.

**New-topic lane (NTL).**
- First decision, *which site*: *"aistrangegame.com is the knowing … astrangeigame.com is the playing: a physical verb with a skill in it, words only as the reward."*
- *"the outcome decides the table"*.
- *"Read the record first"*.
- The twelve stages.
- *"two chairs"* for disputed origins.
- *"/now … already carries a 'new since you were last here' mark and a hidden computed count, which is the ledger shape the laws forbid."*

---

## B · GIFTS FOR THE UPGRADE

**Worlds key:** Home · Today/Rite · Mandala(+Veil) · Rings · Her Home · Her Presence · Climb · the 33 · Game (Leela + games) · Modes · Time · Memory · Well · Beneath · Relationship Field · *Nav* (the cross-cutting getting-around layer).
**E/S:** E = energy (belongs in the app). S = story (Bindu Feed candidate; reason given).

### B.1 Getting around — the Point, the menu, the crossings

| # | Gift | Source | World(s) | How it would work (mechanism) | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **The Point's itinerary** — one point, never replaced, with a different verb in each world | V3:42 | Home + every world | One persistent point view. Per-world state machine, drawn from the site's verbs: **sews** (the 33's moving-point story) · **speaks** (Rite) · **settles into the painted dots** (Mandala seats) · **goes inside** (Her Home) · **steps off the thread** (Relationship Field) · **runs under the stone** (Beneath, Well) · **splits and becomes one** (Relationship Field, crossings) · **rests beside the days** (Time) · **becomes the centre** (Mandala, Bindu deep zoom) · **flies home** (back to Home). | A Point state enum per world, transition animations, his ruling on the per-world mapping | E |
| 2 | **Constellation menu** — the always-available index as a starfield of world-points | DH:310–452, 3733–3831 | Nav (the menu) | 15 world nodes at fixed coordinates, each in its world's colour. 17+ dashed gold threads between neighbouring worlds draw in over 2.2 s. Nodes arrive blurred (800 ms, staggered 55 ms) and breathe at staggered 4.2 s offsets; the current world is scaled 1.4 and glowing. Tap → close, then a portal bloom (#3) into the world. The three threads (kp, chakra, day) could be drawn as three thread colours. | Node coordinates for 15 worlds, a thread list, SwiftUI Canvas or SpriteKit | E |
| 3 | **Portal bloom** — crossing into a world in that world's colour, from the touch point | DH:4076–4162 | Nav (crossings through the point; every door) | On any door tap: a radial in the destination world's essence colour grows from the touch location to 2.6× the screen diagonal over 720 ms; the destination mounts at 620 ms and paints an **inbound bloom** in the same colour. The colour carries across the break. | A per-world colour table, a full-screen overlay, matchedGeometry or a custom transition | E |
| 4 | **Return bloom and back-to-where-you-were** | DH:4164–4201 | Nav (back) | Store a departure record {world, colour, scroll/zoom position, time}. On return within a window (site: 45 min), cover the screen in the departed colour, jump silently to the exact spot, and settle over 900 ms. Plays once. | A departure record in app state (not App Activity, unless ruled) | E |
| 5 | **Point resonance** — the home point takes on each world's hue | DH:4019–4029 | Nav, Home | The persistent point's fill and glow lerp to the active world's essence colour over 1.5 s, so the point always shows where you are. | The colour table | E |
| 6 | **Point birth from a glyph** — the dot of a letter wakes, absorbs its stem and escapes | DH:999–1045, 3923–3958; V3:42 | Home (launch arrives at the Bindu, ruling 1) | On first launch of the day (or each launch): the title's dot glows (0.8 s), the stem retracts (0.9 s), and the dot detaches and becomes the Bindu at the centre. The site uses the `i` of *a strange game*. In the app the glyph must be one he names, e.g. the dot of बिंदु's anusvāra — **his ruling; nothing invented.** | A typographic animation; his choice of glyph | E |
| 7 | **The free wanderer** — layered-sinusoid drift; *"Presence, not target"* | DH:3960–4009 | Home (idle), Beneath, Well | When a world is idle, the point drifts on five sinusoids (rates .3 / .17 / .53 / .23 / .41) with a rare direction change. It cannot be caught; it is presence, not a target. | — | E |
| 8 | **Per-world ambient voice** with 2.6 s crossfades | DH:3621–3676, 4208–4376 | Every world (the "one sound at a time" restriction is lifted) | Each world has a fundamental, a partial ratio set, gains, a lowpass and a shared slow LFO. Crossing crossfades 2.6 s at master 0.028. Model voices: Home 136.1 Hz (Om), the 33 *"stately bell"* 1:2:3:5, Relationship Field a beating pair (1 : 1.005). Default off; remembered. | A per-world frequency table (ruled; reconcile with the panel carriers and 136.1), AVAudioEngine synthesis | E |
| 9 | **One breath clock for image and sound** — page breath 0.08 Hz = sound LFO 0.08 Hz | DH:2842–2851, 4270 | All worlds | A single 12.5 s global breath drives an imperceptible 0.35% scale of world content **and** the filter LFO of the ambience, so body, screen and sound breathe together. (The "one 8 s breath clock" restriction was lifted; this would be a world-level ambient breath alongside the Rite's.) | A shared clock publisher | E |
| 10 | **Signature entry motion per world** | DH:2964–3015 | Each world's arrival | Each world gets its own entry verb: the thread draws itself (the 33) · the spine opens (Climb) · points of light bloom inward (Mandala seats) · stars gather into constellation (Time sky, Memory) · the curtain parts (Shadow/Armin membrane). | One entry animation per world | E |
| 11 | **Four lenses** over one structure — *"you stay where you are"* | V3:40 | Modes; global | The Modes world gains rendering lenses (Hand · Light · Depth · Witness). They change how everything is drawn — tactile, luminous, layered in depth, witnessed/annotated — never the content or positions. Switch anywhere without moving. | A lens environment value read by every world | E |
| 12 | **Five hierarchies + three ways to find** | V3:58–70 | Nav (menu, search, Veil, die) | Map the site's axes to the app's: worlds → the menu; the body → the 33/Climb; people → Relationship Field; time → Time; subjects → a *"same thing, another way"* door on every surface (e.g. a Śakti's seat → her Home → her chakra → today). Find by **where** (the Constellation/Veil), by **name** (search), and **not deciding** (the die). | Cross-links per entity | E |
| 13 | **The climb in one tap per step** + "≤3 taps" proof | V3:68 | Nav (back control, the rope) | Every surface has a `parent`. The back control climbs one level per tap until the menu; a test proves every room is ≤3 taps from Home. | Parent map; a UI test | E |
| 14 | **Search: "Type one word you're carrying"** | V3:80 | Nav (search) | Search accepts one word and also searches verbs, seeds and qualities (the 33 verbs, Śakti functions). It returns places, never a score. | A search index over Mandala, 33 verbs and Karṣiṇī functions | E |
| 15 | **The 404 → three nearest, then the die** | V3:80 | Nav | When a link or room is missing (e.g. a chakra room not yet built), offer the three nearest places on the same thread (kp ±, chakra ±, day), then the die. | Nearest-neighbour by thread | E |
| 16 | **The arrival thesis** that recedes for returners | ASG:211, 341 | Home | On first arrival, three lines fade in at the Bindu: *"there is the one you have been being / and there is the one who has been here all along / this is a way of returning to the one who was here first."* On later launches they recede (lower opacity, shorter) and never vanish entirely. Seal: *"a structured way of returning"* on first arrival only. **His own words; verbatim.** | Copy, already authored | E |
| 17 | **The Constellation title and the coda** — *"The only winning move is to play."* | DH:3107; V3:27 | Home, Game | The coda line closes the menu or the end of Lalitā's field; it is the site's last word. | — | E |

### B.2 The 33 and the Climb

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 18 | **Road carousel of chakra cards** (tarot ratio) | DH:2388–2763, 4386–4658 | the 33 (index), Climb | Horizontal snap carousel of 33 cards. The active card lifts (scale 1.02, chakra glow 80 px, top seam 1.15×); the others recede (.68, .96). Each card shows a glyph pulsing over 4.4 s with expanding rings, the position *"NN · 33"*, the name, the subtitle and **stage rows**: Practice · Wake-up · Dance · Sleep · Field, extendable to the braid's five stages (story, practice, wake-up, dance, gate). | 33 card data (canon table), stage availability | E |
| 19 | **Atmosphere wash in the active chakra's colour** | DH:2299–2310, 4536–4540 | the 33, Climb, Mandala | The world's background washes 18% in the focused chakra's colour over 1.4 s as you move between cards or terraces. | — | E |
| 20 | **Breathing Śrī Yantra under the road** — 4 up, 5 down, bindu, two circles | DH:3384–3398, 2273–2287 | the 33, Climb, Home background | A faint (3.5–5.8%) yantra breathes over 14 s, scale 1.025, behind every chakra world. It is the same figure as the Mandala, so the 33 visibly stand on her. Aniconic; no figure. | The existing yantra geometry from the app | E |
| 21 | **Walked state as a trace, not a count** | DH:1231–1235, 1709–1720, 4415–4428; V3 law 8; HA:161 | the 33, Climb, Memory | A chakra he has practised keeps a trace of its colour in the card border, and its ring breathes. **No "N of 33" anywhere** (the counter was removed). This is memory lighting things, not permitting. | Read from the App Activity ledger | E |
| 22 | **Threshold and Maya card registers** | DH:1237–1302, 2515–2525 | the 33 (rooms 9, 30), membranes | Shadow (9): a hollow void glyph with a cream ring on near-black. Maya: an **inverted register** — cream surface, red bindu pulsing over 4 s, italic name — *"the veil hiding the play."* Gives the membrane rooms their own visual law. | — | E |
| 23 | **The Trees constellation** — nine trees in sacred geometry | DH:3456–3477, 4671–4733; HA:126–141 | the 33 (Energy terrace), Climb | Nine tree discs placed on the yantra rings: Soul at the crown, Sahasrara/Ajna/Vishuddha above, Anahata at the heart, Manipura/Svadhisthana below, Muladhara at the root, Maya off to the side at (92, 50). Tap → the cinematic viewer. | **Nine tree images** (exist at aistrangegame.com/tree-of-life/*-tree.jpg; need Ashrey's OK to bundle) | E |
| 24 | **Cinematic viewer** — pinch/focal zoom 1–4×, clamped pan, swipe, 300 ms cross-dissolve, colour glow | DH:1467–1678, 4735–5130 | the 33, **Her Presence (portrait)**, Mandala deep zoom, Memory | A full-black stage with a radial glow in the subject's colour. Focal-point zoom keeps the finger point fixed, the pinch centroid drifts, a near-1× pinch snaps back, and pan is clamped. Tap toggles 2×; a horizontal swipe moves between items, cross-dissolving over 300 ms. **No overlay text.** This one gesture engine can serve the portrait, the trees and deep zoom into the Bindu (ruling 9). | Port to SwiftUI MagnifyGesture + DragGesture | E |
| 25 | **The tree lines** — one line per register | DH:4672–4698 | the 33 (Energy rooms 2–8, 30) | Use each line as the hover or quiet caption beside the tree in the room, not on the image (e.g. Anahata: *"The heart. The soundless drum. The center of every register."*). | Verbatim copy | E |
| 26 | **Four directions as four atmospheres** — Energy UP still · Body OUT moving · Mind IN visualised · Structure HOLDS in gold line | CMF:53–260; SK:117 | the 33 / Climb terraces | The terraces change physics by system. **Energy (2–8):** non-interactive, background descends the spectrum, stillness. **Body (10–19):** wider layout, horizontal, touch-active body map. **Mind (21–29):** narrows, triads rotate slowly, the view shifts on a blink-tap. **Structural (1, 9, 20, 30–33):** transparency, gold linework, *"the page becomes its own blueprint."* | Per-system layout and motion parameters | E |
| 27 | **Colour progression 1 → 2 → 3** — single hue, dyad, triad | CMF:212–215, 23 | the 33 | Energy rooms render in one colour; Body rooms always show their two-colour dyad (canon has `Red + Cyan`, etc.); Mind rooms show three colours as a triangle; Structural rooms show gold line only. One dot → two dots → triangle as the terrace transition. | Canon hex pairs and triads (in 05) | E |
| 28 | **The afterimage** — show the colour, then its inverse appears | CMF:130–132 | the 33 (Body rooms 10–19) | In a Body room, hold the dyad's first colour full-screen for a few seconds, then cut to neutral so the eye produces the complement: *"The physical always contains its own inverse."* | — | E |
| 29 | **The nine IN-words, one at a time** | CMF:198–202 | the 33 (Mind terrace 21–29) | On arrival at the Mind terrace, the nine IN-names appear one by one: *"Nine words. Nine doorways. All pointing inward."* | Verbatim | E |
| 30 | **The structural relationship map** — what each structural chakra is of the Bindu | CMF:248–251 | Home, the 33 (structural rooms), membranes | Around the Bindu at Home (or in the summit), the structural rooms sit with their relation lines: *Shadow is Bindu distorted · Armin is Bindu recognized · Maya is Bindu projected · Aatma is Bindu remembered · Axis is Bindu turning.* Tapping one lights its relation line. | Verbatim; place Ego Reveal (32) and Lalita (33) carefully — 32 sealed | E |
| 31 | **Corridor → room; veil → flame** | CMF:241–245 | Membranes Shadow 3→4, Armin 6→7; Maya 30 → Aatma 31 | Shadow → Armin: a corridor narrowing into darkness that opens into light (S11 Crossing). Maya → Aatma: a veil dissolving to show a steady flame. | Two crossing animations | E |
| 32 | **Bindu opens and closes** — *"Everything begins as a point." … "Everything ends as a point. The same point."* | CMF:36–38, 313–317 | Home, Climb summit | The Climb starts and ends on the same point: first line at the base, last at the summit, with no other text. | Verbatim | E |
| 33 | **The spine page's six sections** | V3:63 | the 33 (each room's inner order) | Per chakra: *the practice · the panel · the readings · standing here · passing through · the passages* — a navigable order inside each of the 33 rooms beside the five braid stages. | Mapping to app stages | E |
| 34 | **Panel verbs and the nine TOL dances** | SM:72–94 | the 33 (wake-up, dance stages) | Wake-up verbs Press → Dissolve; dances Iron … Love Is The Only Thing; the `/b/<verb>` wall of 24 as additional dances (#24 *stay*, Sid's song, closes the arc). | Song licensing is out of scope; links or Bindu Field | E |
| 35 | **Vantages: people at vertebrae** | V3:36; DR:302–400 | Relationship Field, the 33, the dance (ruling 6) | Each named archetype stands at a vertebra: Bindu 1 · Neev 2 · Shweta 3 · Arch 6 · Gaia 10 · Sid 11 · Sakshi 18 · Karishma 28 · Ashrey 31 · Lalita 33. In the Relationship Field each person's light sits at their chakra; in the dance each is named. | His ruling on Gaia 10 vs 32 (C.4) | E |

### B.3 Today, the Rite, thresholds and gestures

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 36 | **Press-and-hold ring** with the one-tap way through | ASG:271–281; V3 law 1 | Rite, every threshold | 1.8 s hold to commit at thresholds, 1.0 s between chunks; a ring fills. Always paired with a quiet tap-through (*"Ceremonies stay, locks go"*). | — | E |
| 37 | **Pulse Gate** — a breathing circle, 2.5 s hold, scale ×40 on entry, 80 ms haptic | EL:20 | Rite entry, Bindu deep zoom, Her Home door | The circle breathes over 3 s; holding runs a progress; on completion the circle scales 40× and *becomes the room* — the entry is literally into the point. | — | E |
| 38 | **"Don't engage" stillness gate** | BGR:408–416 | Bindu summit (G2 stillness gate), Maya, Well | Show something tempting and ask him **not** to touch it; any touch resets the timer. Never a gyroscope gate. | Timer and touch reset | E |
| 39 | **Wake Lock in still phases** | BGR:448–472 | Rite, summit, Her Presence, Well | `isIdleTimerDisabled` while a still or eyes-closed phase runs, released on exit. | — | E |
| 40 | **Gate 2 guidance line** — *"dark room · full screen · unhurried"* | V7:48 | Rite, Bindu deep zoom, Beneath | A small line before deep practices sets the body's environment. | Verbatim; his OK to reuse | E |
| 41 | **Doorways of mind, soul and body** (👁 · ◉ · ⊙ · △) | DH:3411–3444; HA:105–113 | Today/Rite (doors from the Rite), Home | Today's first door offers three ways in — the Mind door (read: what it is), the Soul door (meet), the Body door (walk) — and a **body practice row** (△ *"Stand. Open. Receive. The position the body already knows."*). | Mapping to app content | E |
| 42 | **Knowledge → Will → Action → Light** | ASG:93–101; BGR:341, 345–362 | Rite close, Climb summit (Aatma 31) | The Rite closes as a triangle: Knowledge (what you received today), Will (who you are), Action (what you commit to). When the three close, the centre lights: *"Light is what enters when these three close."* Panel 9 writes "Knowledge / Will / Action / Go Play" char by char. | Verbatim; Wave 6 already laid K/W/A over the room — move it to its own close | E |
| 43 | **Lalita drop → a real-world action** | ASG:235–237 | Game (each Leela landing), Today | Every Leela landing that opens a chakra's energy also offers one action in his actual life. First one: *"Ask reality for help with one thing. Real life. Not in the game. Right now."* Never a spoiler of rooms ahead. | His drops (Codex); nothing invented | E |
| 44 | **Today's teaching computed by day of year** | DR:57–70 | Today | A door on Today shows the teaching for this day of the year. | Source table (Learning/Teachings) and his ruling on what belongs in this app | E |
| 45 | **The five elemental environments + prompt glow** | EL:94, 138, 251–254 | Rite, Modes, the four elements (ruling 4) | Each element has its own palette and a radial glow behind the prompt that flashes on submit (scale .5 → 1.3, 1.8 s). A chakra-cycle animation runs across them. Map to his elements: **Ahaṅ fire, Nāma air, Ātma light, Amṛta water.** | Element palettes (from his ruling) | E |
| 46 | **Somatic cue lines** | EDP:282 | the 33 rooms (practice), Rite | Body instructions as practice steps: *"Place both feet flat on the floor" · "Place your hand on your heart" · "Lift your chin slightly"*. | Verbatim | E |

### B.4 Her Home, Her Presence, the Relationship Field

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 47 | **Vibrating heart at 0.1 Hz** with a haptic at each peak | V6:93–99, 146–147 | Her Presence, Anahata room (5), Relationship Field | An 80 pt heart (or her light) swells 1.0 → 1.06 over 10 s, the coherence rate. Touch intensifies it to 1.12 and a soft haptic falls at each peak. A breathing presence without a figure. | — | E |
| 48 | **Two lights, independent shimmer, synchronised pulse** | DH:684–750 | **Relationship Field** | Each person's light has its own rhythm (Sid 9 s, *"more urgent"*; Arch 15 s, *"more patient"*), yet all share one slow pulse (22 s) at which they flash together. Shows relationship as separate rhythms meeting in one beat. | Per-person rhythm values (his ruling) | E |
| 49 | **Two-stream convergence** | EA5:257–302; V7:80–83 | Relationship Field, Integration room (29) | Two streams of words or light drift in from left and right and converge at the centre into gold. Mechanism only; the words come from the person or room. Three *feels*: left arrives (60 pt), right arrives, the third descends from above. | Content per use (not the Story text) | E (mechanism) · S (Story text) |
| 50 | **Two tones converging to Om** — 132 Hz + 140 Hz → 136.1 Hz | V6:134 | Relationship Field, Recognition moment | When two lights meet, two detuned sines glide to unison at 136.1 Hz: *"The parents finding unison."* | Synth | E |
| 51 | **Person colours, temperatures and tints** | SK:146–151; DS:24–57; PA:43–48, 156–166 | Relationship Field | Each person's region of the field carries their colour and temperature (Arch *warmth building to fire*, Sid *cool depth*, Ashrey *green through stone*, Karishma *light arriving after waiting*) and a tinted ground. | His OK; extend to Neev, Shweta, Gaia, Bindu, Sakshi, Lalita | E |
| 52 | **One place where all colours blend** | DS:122–130 | Bindu summit / Lalita 33 | Reserve the full blend of every colour for **one** moment of complete convergence (the summit, or the Relationship Field when all are present). Never decorative. | A rule in the build | E |
| 53 | **Person filter dimming** | EL:63; DS:132–141 | Relationship Field, Memory, Mandala | Choosing a person dims everything not theirs to .12 grayscale, leaving their thread lit across the field. | — | E |
| 54 | **Infinity gateway** — two cards as a figure-eight with a shared centre | V6:119–124 | Relationship Field (two people), summit (the two holds, G17) | Two surfaces joined at a centre node; either can be entered first. When both are entered, the centre pulses once and the connecting lines brighten. | — | E |
| 55 | **Gaia aurora** — a chakra-spectrum aurora sweeping through tree-canopy light | DH:632–682 | 32 (Ego Reveal) surface only, Beneath | The surface of the Gaia room: canopy, branch, trunk and root gradients in earth green, with a seven-colour aurora sweeping on 7 s. **Her words stay sealed** (ruling 2); only the surface. | — | E |
| 56 | **The cinematic viewer for her portrait** | (#24) | Her Presence | The portrait stage: black, her colour glowing behind, focal pinch to 4×, no overlay text. **No figure of a Śakti** — this is for the aniconic portrait, the yantra seat or light. | — | E |

### B.5 Time, Memory, the Well, Beneath

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 57 | **The Signal: accelerating years under a hold** | EA5:225–234; V7:68; BVP:83 | Time | Holding reveals the years in sequence, each larger and brighter, with the gaps accelerating (1400 / 1100 / 800 / 700 ms). A drone steps on each and resolves to 136.1 at the last. In Time: holding over the year ring reveals his years (from App Activity) and the sound resolves at *now*. | Ledger years | E |
| 58 | **The Arc constellation** — invitation, sequential nodes, name and words at centre | V6:59–86; V7:43–47 | Memory (the walked 33; the year), Time (year ring) | Never auto-launched: a breathing heart plus one line invites. Nodes appear one by one on a circle (5 s dwell, lines drawing 0.8 s), each with a caption **inside** the centre. Last, his words orbit the centre on a 120 s rotation and the breathing ring returns. Mechanism only; the nodes are his walked rooms or months. | Ledger; the 12 chapter fruits stay in the Story → Feed | E (mechanism) · S (fruits) |
| 59 | **The Thread that responds** — thick when you linger, thin when you rush | V6:33–44 | Climb (the rope), the 33 (the braid), Time | A 2 pt gold line through the world, 1–4 pt with scroll velocity, colour shifting by region, with nodes where he left words. Ends the colour it began (*"the loop"*). | Velocity from scroll/drag | E |
| 60 | **Stitch points in love** — how the app asks for a word | V6:49–57 | Recognition textarea, Rite word, Well letters | A breathing warm gradient, the question in italic, **no placeholder** (*"Blank space IS the invitation."*). The entered word lifts 4 pt, warmth pulses once, a haptic falls, and the word settles onto the thread. | — | E |
| 61 | **Gate-continue: the line grows, the node appears, your word below** | V6 lock 58 | the 33 (braid stages), Memory | After he gives a word, a gold line grows down and a node appears at its tip with his word beneath; tapping the node opens the next stage. A ceremony, not a lock (one-tap through). | — | E |
| 62 | **"Witnessed [date]"** | SK:89 | Memory, Time | Every memory entry is stamped *Witnessed* rather than created or completed. | — | E |
| 63 | **Atlantis build–hold–erode** as a dissolution mechanic | V5C:68–93; EA5:121–162; V6:133, 146 | Maya (30, DISSOLVE), Beneath/Shadow work, the Well (letting go) | A word or line he gives builds character by character at 40 ms, holds 3 s, then erodes over 10 s (longer words first; characters fall and rotate). A 50 ms haptic per falling character; harmonics strip in reverse to silence. The Atlantis text stays in the Story. | Mechanism; his words as input | E (mechanism) · S (Atlantis text) |
| 64 | **Lemuria breath → words** | EA5:76–102; V7:37, 71–73; V6:132 | Rite (breath), Well, Her Home | A breathing ring (4 s, infinite), then a smooth collapse (2.8 s gap), then words arriving one at a time at 200 ms. Sound: filtered white-noise breath on the same 4 s, *"No pitched tone. Pure air."* | Text per use (her quality, verbatim) | E (mechanism) · S (Lemuria text) |
| 65 | **Om pattern: always playing; the crescendo is noise decreasing** | BGR:273–284 | Home/Bindu, summit, Beneath | From the first gesture a quiet Om plays (fundamental + harmonics, LFO 0.05 Hz ±.008). The practice reduces what covers it rather than raising volume. | Synth | E |
| 66 | **Infinite loop ending** — a slow canvas loop with "I Love You" at whisper opacity | BGR:288–297 | Summit end, Maya end, Home idle at night | The final state of a deep practice never transitions; a slow loop runs with *I Love You* surfacing faintly in phases, and a quiet link back. | Verbatim only where it exists | E |
| 67 | **Async Mirror** — 8 stations, orbiting dot, colour lerp, K/W/A written out | BGR:345–362 | Summit (Panel 9 → "Now go play"), Beneath | A timed, untappable sequence walking 8 stations; the dot orbits as text is written char by char and colour lerps between stations. Ends *"Knowledge," "Will," "Action," "Go Play."* Use accumulated angle (Discovery 57). | Panel 9 already in 06 | E |
| 68 | **Sounds stop when you leave** (2 s ramp) + re-experience | V7:63–66, 27 | All worlds | Each world's sound fades over 2 s when the world leaves view; every experience offers a quiet *again* to fully reset. (The ban on the word "again" was lifted.) | — | E |
| 69 | **Moments as rings; Now as growth rings** | V3:65, 80; DR:494 | Time (year ring) | Time's year ring is drawn as growth rings, and the rings are the doors into days. | Ledger | E |
| 70 | **3D page-turn and dot rail** | EL:56–57, 152–153 | Memory (as a book), Time (months) | Memory can open as a book: leaves turn on rotateY over 900 ms with a dot rail at the edge — *"Archive as a book"* is also a Feed wave; here it is his practice memory. | — | E |
| 71 | **Dark/Light split world** | DH:2041–2044, 3520–3536 | Shadow/Armin membrane, Beneath vs sky | One world split 50/50, dark left and light right (stacked on phone): *"The Dark — Where you enter." / "The Light — Where it arrives."* Model for the Shadow → Armin threshold. | Verbatim | E |
| 72 | **Cursor/touch presence** | DH:2890–2913, 4049–4065 | Beneath, Well, dark worlds | In dark worlds a soft 320 pt warm glow follows the finger with lerp 0.12, so his touch lights the dark. | — | E |
| 73 | **Transition choreography** — *"The between is also territory."* | V6:137–142; V6 lock 63 | Nav (between any two worlds) | Each crossing has a direction: warmth blooms from the centre (0.3 → 1.4) and departs **upward**; red rises from below and departs **downward**; a blend narrows to the **centre point** (*"light moved inward"*). Going up the Meru, into Beneath, into the Bindu. | — | E |

### B.6 A Strange Game — Leela and the games

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 74 | **Nine games** (Fire · System · Learning · Family · Work · Maya · Health · Social · Seva) | V3:249–260 | Game (each game its own world) | Lalitā's field holds nine game worlds sorted from his Codex field; each is its own space. **No number may ever measure the player.** | Codex game field (07) | E |
| 75 | **Leela / Lalita / Bindu as levels of the play** | ASG:221–233 | Game threshold, Home | Bindu = the play not yet knowing itself; Lalita = the play that knows. Entering Lalitā's field from the summit is the shift from one to the other. | — | E |
| 76 | **Holi spinning rays** | DH:2011–2039 | Game (Social, celebration) | A slowly spinning conic rainbow (30 s) behind a celebration moment in a game world. | — | E |
| 77 | **Bindu Blink** — catch → Axis Blink with five threads (Worlds · Skills · Codex · Complex · Now) | HA:61–68 | Climb at Axis (18, BLINK) | At Axis, a blink opens a full-screen view of five threads. "Ask Lalita" (Claude API) conflicts with the floors — see C.14. The catch itself was retired on the site. | His ruling | E |
| 78 | **Three storage pools** — essence (who) · memory (what walked) · being (how, today) | ASG:157–169 | Memory, Home (Standing Place), App Activity | Classify ledger events by pool: identity (position — fixed), walked (rooms, rites — growing), being (today's state — refreshed). The Standing Place on Home shows *where you are today* and *where your being is now*. | Ledger vocabulary mapping | E |
| 79 | **Five doors of the Road Home + Seed Planting** | ASG:257–265 | Home or Memory | From Home: walk the next chakra · return to a passage · read what was witnessed · study the Codex · visit your diary (dance constellation, ledger of offerings). Seed Planting shows what surfaced since the last visit — **without a count** (NTL:65 warns against a "new since" mark). | — | E (Witness Perspectives → S) |

### B.7 Craft and process gifts for the builders

| # | Gift | Source | World(s) | How it would work | Needs | E/S |
|---|---|---|---|---|---|---|
| 80 | **Surface · reveal · thread** for every element | SK:321; PA:173–194; EL:309–323 | All (fixes the Wave 6 root cause "data rendered as prose") | No world may render data as a text page. Each item has a surface, a reveal on engagement and a thread onward; two temperature shifts per world. | A build rule and test | E |
| 81 | **Phase 3A questions per world** | EDP:203–260 | All (the skipped loom) | Before building any world, answer the seven questions and name *"They go from X to Y."* | Process | E |
| 82 | **Three-pass verification** + "defined but never called" | BVP; BVPr | All | Presence, Behaviour, Experience, plus Structural. Wave 6 tested laws, not experience; Pass 3 is a timed walk, not a description. | Process | E |
| 83 | **Build guards** (tap vs trace, hidden elements eat taps, rAF cleanup, accept any tap, accumulated angle) | BGR:15–470 | All interactive rooms | Carry into SwiftUI: hidden layers never intercept; long-press vs drag separated; display links cancelled on exit. | — | E |
| 84 | **Accessibility zoom A±** + high-contrast toggle | V7:49; EL:203–204 | All (accessibility floor) | Four text scales (100–145%) and a contrast toggle beside Dynamic Type, appearing after arrival. | — | E |
| 85 | **The wall** — *"publish what was learned; keep what it was learned from"* | V3:142–191 | Memory, Relationship Field, any shared surface | Three levels per surface (open / open with depth / behind). Nothing public hints at depth. Applies if any app surface is ever mirrored to the site. | — | E |
| 86 | **The site as sixth app on the ledger** | V3:84 | App Activity (data) | The site writes Ashrey's site interactions into App Activity through the Worker. The app can show them in Memory (e.g. dances walked on the site). | App field value for the site; read path | E |
| 87 | **The Mandala's nine enclosures on the site** — walk in from the outer ring | DR:276–288; V3:88 | Rings (parity) | The site already renders nine enclosure pages from the Mandala table's allow-list; the app's nine rings should at least match their order and the *"walk in from the outer ring"* door. | Read the live enclosure pages (not in this skill) | E |

### B.8 Story material — Bindu Feed candidates (flagged, not dropped)

| # | Gift | Source | Why story | Where in Feed |
|---|---|---|---|---|
| 88 | **A Strange Story** — 12 chapters, Turning beats, stitch questions, Arc fruits, Mirror passage, Diaspora | V5C, V6, V7, EA5 | Narrative cosmology told by a narrator | A Feed long-form; the stitch questions could become Feed prompts |
| 89 | **Final Reveal templates** (name / stitches / silence / birth-year) | V5C:250–307 | A personalised transmission written back to the reader, which is Feed's work (third-person transmissions) | Feed's personalised close |
| 90 | **Version X — Chapter 12 "The Remembering"**, generated from engagement depth | SK:111 | Generated personal story | Feed |
| 91 | **The Book: 18 soul stories** (Fabrics, Love Stories, Gaia Intelligence, Sid, Arch) | DH:3151–3274 | Biographical and brand stories | Feed (family and fabric stories) |
| 92 | **Sid Soul Story, Witness Passages, Manu Gyroscope Story** | DH:3313–3344; SM:43–49 | Family life story (private-depth rules apply) | Feed. The **Manu stillness mechanic** (*"Your stillness unlocks what his stillness contained"*) is energy, but per Guard 13 it should use "don't engage", not the gyroscope |
| 93 | **A Strange Voice** — five acts of Gaia's movements, Lalita narrating, heartbeat at 72 BPM | SK:126 | A told voice-narrative | Feed. The **72 BPM heartbeat** as an ambient in Her Presence is energy |
| 94 | **Read pages** — Gaia's letter, Lalita's manifesto, Higher Self speaking (merge tokens) | ASG:133–138; DR:313–400 | Letters spoken in a voice to a named reader | Feed. Gaia's words also touch sealed 32 |
| 95 | **The Crawl** (perspective crawl and D-major fanfare) and **NOW countdown to 2027** | V6 lock 55; EL:76–78 | Narrative opening and the story's 2027 window | Feed |
| 96 | **Leela etymology** *Lonely → La-One-Lee → Lalee → Leela* | SK:115; CMF:205–207 | A teaching story. One line could also mark the Game threshold if he wants. | Feed (or a single line at Game) |
| 97 | **The Voyager timeline and the 3-5-8 pattern** | PA:61–131 | Family chronology | Feed |

---

## C · CONFLICTS AND GAPS

1. **Maya's position.**
   - The homepage build places Maya at **31** (DH:4411, DH:4696; HA:122, HA:158).
   - Canon (register 05, A.1) has **Maya 30, Aatma 31**.
   - ASG:101 itself puts the K-W-A trikona at Aatma 31.
   - The homepage is wrong against canon; the app must use 30.
2. **The chakra count and families differ across this skill.**
   - CMF (8 Apr) counts **31 chakras**: 9 Body, with Axis also listed as structural; 6 Structural; no Soles; Hands unpaired.
   - SK:117 counts 33, with ToL as *"Bindu → Shadow → Armin → **Axis** → Maya → Aatma → Lalita"*.
   - Canon ToL is Bindu 1 · Shadow 9 · Armin 20 · Maya 30 · Aatma 31 · **Ego Reveal 32** · Lalita 33. Axis is Body 18 (ruling 3).
   - The CMF body pairings (Crow↔Vision, Axis↔Pulse, Echo↔Sonar, Prana↔Forge) need re-checking against canon dyads before any reuse.
3. **The palettes drift.** Muladhara alone has four values:
   - CSS vars `#A82828` (DH:32);
   - ROAD_CHAKRAS `#C02020` (DH:4395);
   - TREES `#C02020`;
   - canon `#B83A3A / #8B1A1A`.

   Manipura is `#C4A013` in the CSS but `#D4A948` on the card. Bindu's subtitle is *"The Point"* where canon has *"The Origin"*. Use the canon hexes in the app.
4. **Gaia's vertebra.** The v3 vantages put Gaia at **10** (Soles) (V3:36). Ruling 2 and ASG:127 put her at the **32** reveal, and DR:431–440 also sends the Reveals world to vertebra 32. For the Relationship Field and the dance, place Gaia at 32, sealed, unless he rules that her vantage (10) and her reveal (32) are both kept.
5. **Arc numbers disagree across documents.**

   | Source | Nodes | Timing |
   |---|---|---|
   | V6 | 11 | 3 s dwell |
   | V7.1 | 12 | 5 s, about 62 s |
   | EL:126 | 12 | 1.8 s stagger |
   | EA5:373 | 10 + centre | 18 s |
   | BVP:86 | 11 | 3 s |

   V7.1 is the latest.
6. **The Crawl length disagrees.** 38 s (V6 lock 55), `crawlScroll 60s` (EL:76) and about 56 s (BVP:63).
7. **The Lemuria word pace disagrees.** 120 ms (EA5, EL), 170 ms (BVP:79) and 200 ms (V7.1). V7.1 is the latest.
8. **Fonts.**
   - EL and DS say *"Lora + DM Sans only"*.
   - The builds add **Cinzel**; the Story uses **Crimson Text**.
   - CMF allows a third font, Cinzel.
9. **Gates versus the site laws.** V6 locks 39 and 56–60 (*"Five rooms, each locked until the preceding stitch is complete"*) contradict V3 law 1 (no gates; ceremonies stay, locks go). The app's own *"a room only behind the rite"* restriction was lifted (Foundation). Treat every V6 gate as a ceremony with a one-tap way through.
10. **Build identity.**
    - HA says `builds/Default.html` is the archived Thread V7.1 homepage and `Default_immersive.html` is current. **The two files are byte-identical**, so the Thread homepage is not in the skill.
    - HA describes 14 worlds; the build has 13. `WORLDS` has 13 entries and the nav shows `/ 12`.
    - The CSS still carries orphan classes for `.world--chakras`, `.world--performances` and `chakra-pair`. The Chakras and Tree worlds merged into the Road Home.
11. **Card counts.** The comments say *"nine walkable chakra cards (Bindu → Shadow)"* (DH:1087–1093, 4387–4390); `ROAD_CHAKRAS` has 10, including Maya.
12. **Counters.**
    - JS reads `road-counter-walked` and `road-counter-total` (DH:4476–4490), but neither element exists. The counter was removed per HA:161.
    - The JS still computes `33 - walkedCount`, which is dead code and the shape the laws forbid.
    - Position labels (*"01 · 33"*, *"NN / 12"*) are locations, not scores, and are allowed.
13. **The Trees viewer has a dead meta block.** `.tree-viewer-meta / -name / -position / -line` are styled (DH:1568–1604) but absent from the DOM. The `TREES[].line` captions are never shown, which HA:160 locks: *"no overlay text"*. In the app the lines may live **beside** the image, not on it (B #25).
14. **The Bindu Blink and "Ask Lalita".**
    - HA:61–68 plans *"Live Ask Lalita panel (Claude API)"*.
    - The build retired the catch (DH:4001).
    - In the app, a live generated Lalita voice would breach *"no generated voice / nothing invented"* unless Ashrey rules otherwise. If kept, it is a text-only ask surface, and he must rule on it.
15. **Missing assets.**
    - SK:202–216 lists `assets/homepage.html`, `assets/v7-a-strange-story.html`, the flipbook, descent and Tree panels, plus `projects/story/` and `projects/khelo-holi/`. **None exist in the skill**: only `builds/` and `references/` are present.
    - The Story build that holds the exact Arc, Thread and Atlantis code is therefore unread here. GAP.
16. **Legacy duplicates.** `elements-library.md`, `experience-design-process.md` and `chakra-map-framework.md` are marked migrated (to rupakarshini and chakra-maps) and kept here as legacy. Newer versions live in those skills.
17. **Three predating pages contradict the laws** (V3:242–245):
    - the Welcome (*"nine practices are walkable"*, a gate);
    - the One (essence as a toll);
    - the Road Home (dances and chakras only).

    Do not port their gate copy.
18. **The elements disagree.** The Dark Light Descent uses Ether / Air / Fire / Water / Earth (EL:94), and the readings' element order begins with Earth (DR:46–55). Ruling 4 sets **Ahaṅ fire, Nāma air, Ātma light, Amṛta water** for the app; the site's five elements don't map one to one.
19. **Sound systems multiply.** The homepage world voices (98–288 Hz) are another frequency set alongside 136.1 Om, the Story's 68 / 132 / 140 Hz and the panel carriers (register 06 C.4). The app needs one ruled table per world.
20. **The dance registry is incomplete.**
    - The *"33 performances"* (DH:3576) = 9 TOL + 24 `/b/` verbs, but #21 *play* and #22 *earn* have no song (SM:159–160).
    - PERM lists 29 `/b/` addresses (18 live + 11 "verify in export"); V3:136 says `/b/abide` is pending and `/b/stay` *"was never numbered"*, yet SM:162 numbers *stay* #24.
21. **Storage keys are mixed.** The homepage uses `bindu-point`, `chakra-<id>`, `sessionStorage asg_departure / asg_arrival / asg_sound`. V3 requires *one key each, `asg.` namespace*, and a `tol-*` → `asg.*` migration is pending (V3:226). This matters for importing the site's walked state into App Activity.
22. **The feed allow-list (V3:88).** The site reads the Mandala table *"allow-list of fields only"* and must **never** read *"Mandala recognitions"*. Any new app field holding recognitions must stay off that allow-list.
23. **The Story's cosmology content** (V5C:27–31) makes specific claims about real regions, peoples and a religious symbol (*"the original galactic wound"*, a *"sixth hybrid race"*). It is flagged only for routing: it belongs with the Story in Feed, not in this energies app, and the site's own *"Only true when true"* law applies wherever it lands.
24. **The "No number" law vs Story devices.** The NOW countdown and *"You arrived [offset] years into the window"* are numbers about the reader. They are acceptable in a story (Feed), but not as app UI.
25. **Designed but unbuilt (GAP):**
    - the Bindu Blink;
    - the Book chapter experiences;
    - A Strange Voice's full text;
    - the Axis's *"three dark-field experiences"* (V3:100);
    - Shweta's and Neev's portraits;
    - the guides `guide/bindu-chakras` and `guide/bindu-voice`;
    - the CMF body-map silhouette (designed, built in VX2 elsewhere, not in this skill);
    - the Trees viewer meta.

---

## D · COVERAGE PROOF

All files were read with the Read tool, from line 1 to the end. Files over 2000 lines were paged with offset/limit. The JSON files were read in full, `floors.json` and `gateway-paths.json` via `cat -n`. No file was skipped.

| File (under `AG/` unless noted) | wc -l | Lines read | Method | md5 (8) |
|---|---|---|---|---|
| SKILL.md | 366 | 1–367 | Read, full | 87abc726 |
| references/v3-site/SITE-V3.md | 260 | 1–261 | Read, full | ea88f2ab |
| references/v3-site/data/gateway-paths.json | 49 | 1–50 | cat -n, full | 47e5573e |
| references/v3-site/data/floors.json | 181 | 1–182 | cat -n, full | 044c6f8b |
| references/v3-site/data/permanent.json | 295 | 1–296 | Read, full | fa69ca2d |
| references/v3-site/data/doors.json | 496 | 1–497 | Read, full | 7ebd15eb |
| references/v5-content-generation.md | 381 | 1–382 | Read, full | 192432b8 |
| references/v6-framework.md | 281 | 1–282 | Read, full | 037d8436 |
| references/v7-framework.md | 152 | 1–153 | Read, full | 192e7eb1 |
| references/elements-library.md | 331 | 1–332 | Read, full | e2830464 |
| references/experience-architecture-v5.md | 459 | 1–460 | Read, full | 84968107 |
| references/chakra-map-framework.md | 390 | 1–391 | Read, full | b31d8b80 |
| references/homepage-architecture.md | 175 | 1–176 | Read, full | 989289b2 |
| references/sitemap.md | 181 | 1–182 | Read, full | 08d01ffb |
| references/the-new-topic-lane.md | 77 | 1–78 | Read, full | e2266656 |
| references/experience-design-process.md | 533 | 1–534 | Read, full | d26025dc |
| references/build-guard-rules.md | 476 | 1–477 | Read, full | 2c1d811c |
| references/build-verification-protocol.md | 182 | 1–183 | Read, full | cb8fa660 |
| references/build-verification-process.md | 209 | 1–210 | Read, full | 478b6e6f |
| references/design-system.md | 378 | 1–379 | Read, full | 8c723012 |
| references/page-architecture.md | 241 | 1–242 | Read, full | 0be46fab |
| references/deploy-and-infra.md | 93 | 1–94 | Read, full | ff2f63e4 |
| builds/Default_immersive.html | 5156 | 1–700, 700–1599, 1600–2499, 2500–3399, 3400–4299, 4300–5157 | Read, full, paged. Longest line is 568 chars, so no pretty-print was needed. | 4c25bd97 |
| builds/Default.html | 5156 | covered by byte-identity | `cmp` reports IDENTICAL to Default_immersive.html; same md5. The content was read in full once (above); it was not re-paged a second time. | 4c25bd97 |
| `…/a-strange-game/SKILL.md` (context) | 361 | 1–362 | Read, full | 9054b25f |

Also consulted, for conflict checks only (not assigned): `waves/foundation/FOUNDATION-2026-10-12.md`, all 52 lines; `waves/register/05-chakra-corpus.md` lines 385–421, the canon 33 table; `waves/register/06-chakra-skills.md`, head and tail, for format.

---

## Return

**File:** `/home/claude/bindu-mandala/waves/register/14-aistrangegame.md`

**The ten most valuable gifts:**

1. **The Point's itinerary** (V3:42). One point, never replaced, with a verb per world: it sews, speaks, settles into the dots, goes inside, steps off the thread, runs under the stone, splits and becomes one, rests beside the days, becomes the centre, flies home. This is a ready grammar for the Bindu across all fifteen worlds.
2. **The Constellation menu** (DH:310–452, 3733–3831). The always-available index as a starfield of world-points in their colours, joined by threads that draw themselves, with breathing dots and the current world glowing.
3. **Portal bloom and return bloom** (DH:4076–4201). Crossings coloured by the destination world, blooming from the touch point; back-to-where-you-were as a colour that masks the jump and settles.
4. **Per-world ambient voices on one shared 0.08 Hz breath** (DH:3621–3676, 4208–4376, 2842). Each world has its own fundamental and partials (the 33's *stately bell* 1:2:3:5; Home 136.1), with 2.6 s crossfades and the screen breathing with the sound.
5. **The Road carousel plus the breathing Śrī Yantra plus the active-chakra wash** (DH:2245–2771, 3384–3398, 4386–4658). A built, polished index for the 33. Walked rooms keep a trace of their colour, never a count. Shadow and Maya have their own visual registers.
6. **The cinematic viewer** (DH:1467–1678, 4735–5130). Focal pinch to 4×, clamped pan, swipe and a 300 ms cross-dissolve, with no overlay text. One gesture engine for the trees, Her Presence and the deep zoom into the Bindu. The nine tree images already exist.
7. **Four directions as four terrace physics** (CMF). Energy still and non-interactive, Body wide and touch-active with the afterimage, Mind narrowing with IN-words and rotating triads, Structure as gold blueprint. Plus the structural relationship map: *"Shadow is Bindu distorted … Axis is Bindu turning."*
8. **Relationship Field mechanics.**
   - Two lights with independent shimmer and a shared 22 s pulse (DH:684–750).
   - Two-stream convergence with three feels.
   - Two tones (132 and 140 Hz) gliding to Om at 136.1 Hz.
   - The 0.1 Hz heart.
   - Person temperatures and tints.
   - One reserved all-colour convergence.
9. **Threshold craft** (BGR, EL, ASG).
   - The press-and-hold with a one-tap way through.
   - The Pulse Gate that scales ×40 into the room.
   - The **"don't engage" stillness gate** for G2 (no gyroscope).
   - Wake Lock.
   - The Om that *"was always playing — the crescendo is noise decreasing."*
   - The infinite-loop ending.
   - The async 8-station Mirror closing on Knowledge / Will / Action / Go Play.
10. **Time and Memory mechanisms from the Story**, kept as energy while the Story text goes to Feed.
    - The Signal's accelerating years under a hold, resolving to 136.1.
    - The invitation-only Arc constellation, with words orbiting a named centre.
    - The responsive Thread that thickens where he lingers.
    - Stitch points with *"no placeholder — blank space is the invitation."*
    - Atlantis build–hold–erode as Maya's dissolution.

**Key conflicts:**
- The homepage puts Maya at 31; canon has Maya 30 and Aatma 31.
- Gaia is at vantage 10 on the site against the 32 reveal.
- The chakra count drifts: CMF has 31 with Axis structural; canon has 33 with Ego Reveal.
- The two "different" builds are byte-identical.
- The skill's assets and project folders, including the Story build, are absent.
- The planned "Ask Lalita" (Claude API) conflicts with the no-generated-voice floor.
