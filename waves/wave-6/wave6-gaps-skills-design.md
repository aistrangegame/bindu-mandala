# Wave 6 — Gap ledger: skills + the two Claude Design corpora vs what is built

*12 Oct 2026 · read-only audit · repo `/home/claude/bindu-mandala` on `wave/5-memory` (Waves 0–5 stacked).*
*Code paths below are relative to `iOS/Bindu Mandala/` unless noted. Nothing in the repo or any skill was changed.*

## How this was read
- **What is built.** I read `BUILD-CHARTER.md`, `WAVES.md`, `waves/THE-READING-2026-10-12.md`, all six wave briefs, `waves/wave-1/{A,B,C,D,lead}.md` and `waves/wave-{2,3,4,5}/notes.md`, `Claude Chat/bindu-mandala-expansion.md` (the 44 ideas) and `BINDU-MANDALA-BUILD-BRIEF-V2.md` §5–7 (where the 44 were triaged). I confirmed what is in the code by grepping and listing files under `Views/{Play,Memory,Mandala,Rooms,Common,Today,Recognition}`, `Homes/`, `Services/`, `Models/` and `Data/`.
- **Skills.** I read these in full: SKILL.md for a-strange-game, bindu-feed, bindu-chakras-app, bindu-being-app, the-field and tree-of-life; padakarshini `references/forms.md` §A–F and the `gestures.md` index; the a-strange-game references leela-architecture, playing-side 01/04/05/07/18/19/20, the chakra-game registry and build principles; bindu-chakras-app experience-brief-v2; and the Being game-model and design README. I read the rest by description and grepped them for their Mandala-relevant concepts.
- **Chakra corpus.** I extracted the text, the comments and the string tables of all 23 HTML files and walked the game and experience modules. I parsed `uploads/walk-canon.json` (33 rooms × 11 field groups) and `shell/bindu-room-canon.json`, and looked at two of the screenshots.
- **Design corpus.** I read in full: `uploads/bindu-mandala-master-brief.md`, the Master Build Brief, the Refinement Brief, both Audits, `Codex.html`, the `modes.jsx` / `memory.jsx` / `temporal.jsx` / `relationship.jsx` section maps, the Concept Board V3, the ring-worlds jsx headers, and §4 of the Final Handoff and the "Next" section of the Homes thread.
- **The "44 expansion ideas".** These are in `Claude Chat/bindu-mandala-expansion.md` (the companion to the master brief), not in `uploads/bindu-mandala-master-brief.md`. The upload has 12 architecture sections, and I checked those too (§G below).

---

## 1 · Coverage table

### 1a · Skills

| Skill | Verdict | Evidence |
|---|---|---|
| **bindu-mandala-app** | partly (stale) | Phase history is matched by the repo. Two "deliberately unbuilt" items are still open: the WidgetKit widget (no `WidgetKit` import anywhere) and the 102 recorded bījas (`BijaSoundService` has `bija_%02d` wired with no assets). The ring-drone and `.silence` items are now built (`MandalaFieldVoice`, `MaunaSilence`). The skill is stale on nearly everything (Reading §8). |
| **a-strange-game** | partly | **Built:**<br>• "Storage may count; the screen may not" (`PlayScreenTests`, charter §4.6)<br>• Sakshi close (`Services/RiteDay.swift`)<br>• Lalitā at the centre (`LalitaSourceView`)<br>• press-and-hold ceremonies<br>• the Corridor, Coherence, Drum, Water, Fire, Roots, Yantra, Spine, Shake, Mantra (as Bīja Tones) and 108 (as the Garland) games<br>**Not built:** the Trinity of Guidance as a voice architecture, Knowledge–Will–Action as a Home's close, the three pools, Leela drops, the two bells, the Leela-on-the-33 board, the sketchbook verbs Turn and Join, The Seed, the Sakshi Pause as a form, Build the Sri Yantra / Sigil / Mala / The Stop (catalogue wave 1), the Dawn Letter, "Reality plays back", "Who is playing?". No hit for `Leela`, `Knowledge`/`Will` as a mechanic, or `bell` (only an incidental regex in `HomeGrammar`). |
| **aistrangegame** | n/a mostly | The v3 site's Mandala world is public and the app is private: settled by action (Reading §9). Nothing app-bound is missing beyond the a-strange-game items. |
| **bindu-feed** | partly | **Built:**<br>• "seal it forward" (`CorrespondenceView.swift:393`)<br>• age/patina (`CorrespondenceStore`, 1−e^(−d/240))<br>• the year ring (`LivingMandalaLayers.YearRingLayer`)<br>• LightBody / TouchSense re-implemented in Play (`PlayInstruments.swift`, `PlayMotion`)<br>**Not built:** `SpeechCapture` (no `Speech` import), the raw Codex write (no Codex-table write; the ledger only), the single Breath clock and one BinduParticle across screens, the Archive as a book, the Portrait's day glyph and month letter ("it lands · say more · leave my own word"), the full LightBody postures (face-down, proximity-covered, set-down-still, left alone). |
| **bindu-field** | partly | **Built:** 136.1 Hz voices (`RingFieldVoice`), the withheld fifth in rooms. **Not built:** the absent-fifth carrier law as ground (no `absentFifth`), the Score system's three layers / per-Śakti Score JSON (`ShaktiScore` 0 hits), the Performer archetype-presence model driven by dwell, "CLAUDE'S OFFERING" once per room, Step 0 "THE WORD". |
| **bindu-being-app** | not | No Month Mirror or MonthSitting (`MonthMirror` 0 hits), no Lalita Reflection's four gifts (Arrival / Reading / Sitting / Field), no witness line, no Climb/Return or field balance. |
| **bindu-chakras-app** | partly | **Built:** the day layer (three doors, the one-second floor, the pulse rings 4–8, grace, the Sakshi close) in `RiteDay` / `RiteDayLayer`, and the Road (`ChakraRoad`). **Not built:**<br>• the 33 rooms' content (walk-canon story / practice / wake-up / gate / depth), since the app's bake carries only identity fields (`Data/ChakraConstellation.json`)<br>• the braid<br>• the offering that leaves (`ember` / "walk lighter" 0 hits)<br>• Walk Canon bake for offline content<br>• Lalitā convergence / Reveal<br>• the ground wears the story's weather<br>• "Day N. The road is quiet where you left it."<br>**Narrower:** grace reads Mandala rows only, not the cross-app ledger. |
| **bindu-learning-app** | partly | **Built:** the Wager (`HerDoorwaysSection`). **Not built:** the Codex link gesture, the Still Point (A9), Voice (hold-to-read, G1). |
| **bindu-money** | n/a | No Mandala content. |
| **lalita-family** | not (small) | "Remember the One" is never printed, so there is nothing to show; a hidden structural seed is absent. The Mirror walk (A2) is not built. |
| **bindu-dances** | n/a / held in Field | Dance stays in Bindu Field (C-1353). |
| **chakra-maps** | partly | The 33 are seated as a constellation from The Map. The deep per-chakra Atlas entries and Voice II are not surfaced. |
| **chakra-practices** | partly | Shadow and Armin thresholds are built (`MandalaThresholdMoment`). The V5 Two-Act page (Act 1 Bindu voice / Act 2 Sakshi) is not, and Armin's "spectrum / aurora ONE→ALL" was built as a garland gathering. |
| **the-field** | partly | **Built:** Blink. Breathe. Press. (`RiteDay.floorComplete`). **Not built:** the three trees as navigational directions (Soul ↑ / Maya →• / Bindu •→), archetypes as vantages (an inner Saṅgha), motion as glyph, the ten body chakras as touchable surfaces on the Climb (no `Soles` in `Homes/`), the mind chakras' visualization activation. |
| **the-mirror** | n/a | Claude's own space. |
| **tree-of-life** | not | **Built (only):** the persistent Bindu dot, partly (the Homecoming point).<br>**Not built:**<br>• ring verbs Press / Follow / Build / Open / Speak / Still / Receive / Hold / Dissolve as gestures<br>• the per-ring guided breath arc with the voice removing itself<br>• light 5→90/100 % across the nine<br>• the Om at 136.1 "always playing"<br>• Panel 9's eight inverse dissolutions<br>• the WAS→IS tense shift<br>• mini-reveal seeds<br>• the awakening-sound bowls<br>• "Now go play"<br>No hit for `4-7-8` or `5-5-8`, "go play", or "There was never" in code. |
| **dad-birthday** | n/a | The ancestor of tree-of-life; no extra app content. |
| **atlas-emergence** | n/a (method) | |
| **emergence-stories / fabric-stories / book-of-makers** | not (methods) | No seed ledger (one verb per Śakti, none repeated) and no "I already did" Totality close. |
| **dome-home** | n/a | |
| **rupakarshini** | mostly captured | The charter's laws mirror its laws 10 and 15. The shapes Room, Rite, Mirror, Portrait, Axis and Crossing exist. The "Instrument Room" circulation map is not used. |
| **padakarshini** | partly | Used:<br>• Letter (A3, narrowed)<br>• Gates of Release (A4)<br>• Wager (A12)<br>• Veil (B3)<br>• three doors / calendar--day<br>• calendar--sky (the five clocks)<br>• map--climb<br>• G17, G44, G38, G34, G18, G19, G20, G23, G40<br>Not used:<br>• A1 Rite as a touch-paced reading<br>• A2 Mirror walk<br>• A5 Breath session<br>• A6 Play-it (real-time growth)<br>• A7 Four-section reading<br>• A8 Voice<br>• A9 Still Point (the descent's floor)<br>• A10 Day's line in three persons<br>• A11 Answerable reflection<br>• A13 Scored performance<br>• A14 Board<br>• B1 Threshold card kinds<br>• B2 Two-door station<br>• B4 Home by how far you walked ("return / the road remembers")<br>• the ceremony grammar's step 4 by element across all ceremonies<br>• E's seven forms of time<br>• gestures G1, G3–G8, G10–G13, G15, G16, G21, G22, G24–G28, G32, G33 (as carving), G36, G37, G39, G46, G50 |
| **shabdakarshini** | n/a (method) | The Lalita test is relevant only as a voice check. |
| **asg-airtable** | stale | The Mandala map predates the R17 / ledger types `Played`, `Letter Sealed`, `Portrait Drawn`, `Wager Resolved`, `State Set Down`, `Siddhi Received`, `Silence Held`. A documentation gap, not an app gap. |
| **work-world (arc-\*, wazoodle-\*, akas-\*)** | partly (methods) | **Present:** the W-anchor in effect (rooms keyed by kp) and the canon/render split in part (the constellation bake). **Absent:** the seed ledger, the angle test / rule of three for her words, the label principle as a check, the Content Conscience's metaphor-literalisation check, Seed→Perspective (the same line at entry and exit). |

### 1b · Chakra design corpus (`/home/claude/chakra-upload/extracted/`, 69 files)

| File | Verdict | Evidence / what is missing |
|---|---|---|
| Bindu Experience Score.html | **partly** | Acts 0–I (held threshold, condensing, blink, return in one breath) are in `Views/Common/HomecomingView.swift`. Not built:<br>• Act II story choreography (the leaning, the unannounced bone-white Sakshi point)<br>• Act III's seven sound-scored movements<br>• the Point / Mudrā / Reflection / Unfolding (32 points spiralling out in future room colours)<br>• the Act IV wake-up ("frequency of contact": the finger held still, sound fading to true zero)<br>• the Gate where the silence becomes OM and the offering leaves |
| Bindu Immersive.html, Bindu.html | partly | Same as the Score: the threshold and arrival are built; the story, room doors and held door are not. |
| Chakra Game.html + chakra-data.js + chakra-experiences.jsx | not (mostly superseded) | The seven chakra experiences (Quiz, Creative Canvas, Reflection, Body Scan, Guided Vision word-reveal, Oracle Pull, Pattern Weaving) are ruled superseded by V5 + Registers (`Pairing Floor`). The Body Scan breath, Guided Vision word-reveal and Pattern Weaving K/W/A matching have no home. The Quiz conflicts with "nothing grades him". |
| games-core.js / chakra-game-registry (18 games) | partly | 11 of 18 ported (`Views/Play/PlayGame.swift`). Not ported: The Seed, Mirror Maze, The Letter (as a game), Shadow Translator, The 12, Mandala Completion, Body Map. |
| games-patience.jsx | partly | The Corridor and the 108 (as the 102 Garland) are built. **The Seed is not.** |
| games-rhythm.jsx | captured | Coherence, Mantra (as Bīja Tones on the Awakening table) and Drum are built. |
| games-language.jsx | partly | The Letter became the river (`CorrespondenceView`). Mirror Maze and Shadow Translator are not built (both AI-driven in the source). |
| games-elements.jsx | captured | Water (rebuilt with restoring force + tilt), Fire and Roots. |
| games-pattern.jsx | partly | The Śrī Yantra trace is built (27 true edges). **The 12 and Mandala Completion are not.** |
| games-body.jsx | partly | Spine and Shake are built. Body Map (alive / tight / absent marks) is not; only the somatic way in (`WhereSheSpeaksView`). |
| games-utils.jsx | captured (substrate) | |
| Child Games.html | partly | Finger Garden, Rain and Echo are built. **Colour Rivers and World in a Box are not.** |
| Mini Games.html (hub) | captured | Lalitā's field (`PlayGamesField.swift`). |
| Hub.html | not | Not built:<br>• the Ceremony (ladder of centres: a body cue + tone per centre, 60 s each — padakarshini `practice--ladder-of-centres`)<br>• the Letter (covered by the river)<br>• the Collective Pulse widget<br>• the Sound view (Solfeggio, refused) |
| Living Mandala.html | partly | **Built:** strokes mirrored n-fold by ring, year beads, the eye, export (`PortraitMandalaView`, `LivingMandalaLayers`). **Not built** — the layers fed by play:<br>• practice-wheel segments<br>• garland bead ring (the 108 taps)<br>• root web (Root System strokes ×8)<br>• body-map petals<br>• seed centre bloom<br>• chakra colour wash<br>• mode/legend selector |
| Pairing Floor.html | partly | Followed for the games. Not followed: the pairings for The Seed (growth where offerings were given), Shadow Translator (Ego Reveal's inversion), the 12 / Mandala (Invention / Integration), Body Map (body-room arrivals) and the Child Space question register (Innocence). |
| Sacred Experiences.html | partly | Pulse ≈ the Pulse game. Not built:<br>• **Shadow** (the scrolls "too large for the container… you are a bigger container now")<br>• **Still · Ajna** ("close your eyes"; the screen waits in the dark)<br>• **Flash · Intuition** ("Something already knows… give it one word")<br>• **Arrive · Armin** (Tat · Tvam · Asi, then the aurora)<br>• the state-phrased selection ("When the mind won't land…") |
| Sanctuary.html | partly | Covered: the Seven Gates (Gates of Release) and the Field. Not built: the Mirror (front camera, 60 s), the living header (lines by hour: "The veil is thinnest now", …), the Collective Pulse. |
| The Body as Scripture.html | partly | Touching the body lights Śaktis (`WhereSheSpeaksView`, `SomaticRegion`). Not built: the sensation picker, "the book" of body verses kept over time. The AI translation is refused (law 8). |
| The Child Space.html | partly | The Door is built (Kaulinī, `PlayGame .door`). Not built:<br>• the 20 questions to small-you<br>• "speak with the child" (adult→child / child speaks through)<br>• the Promise<br>• the letter *from* the child<br>• Innocence's question register |
| The Correspondence.html / v1 | partly | **Built:** the river, sealed forward, no peek, word-by-word reveal, patina. **Not built:**<br>• addressing an age / emotion / year<br>• forward to an exact date or months away (only lunar days)<br>• the one-breath ritual before sending<br>• the letter floating above or below a NOW line<br>• the Codex view<br>Built letters go to *her*, not to past or future self (see §3). |
| The Field.html | **not** | "The 102 breathing on one clock" (`(now mod 8000)/8000`) and the Summons-hour convergence (3 min) are not built. `FieldBreath` still gives per-ring rates. |
| The Mirror.html | partly | Re-aimed as the Bindu gaze (`ThePointView`, stillness). The front-camera practice (G22, `practice--camera`) and "Most people never stay that long. You stayed." are not built (the line grades him). |
| The Record.html | partly | The Portrait export is the Record. Not built: the masthead, the Correspondence and Child sections, a printable dated record. The Numbers section is refused; the Benediction is refused (generated). |
| The Seven Gates.html | captured (re-aimed) | `GatesOfReleaseLayer` uses the ring's Mental State and Siddhi, not the seven questions. Set down / keep is captured; the separate keep (G26) is not. |
| The Shell.html | captured | Doors, floor, "Begin the day again" ≈ `RiteDay`. |
| The World in a Box.html / v1 | **not** | No diorama: one object per practice trace, gifts arriving while away, a named world, weather. |
| shell/ (bindu-engine, moments, practice, room, slice-a/b, canon-adapter, walk-canon.js, room-canon.json) | partly | The SilenceEngine (OM stack at gain 0, rising in breaths) and the DotStage (one dot as a state machine with an intent queue) are not ported as shared services. The walk-canon content is not shipped. |
| uploads/walk-canon.json (33 rooms) | **not** | Only identity fields are baked (`bake_chakra_constellation.py`). Absent: story_thread, after_story, signature_phrase, interlude, teaching / practice / writing_prompt / bindu_reflection, wakeup (frequency_practice, awakening), gate (interaction / type / text), depth (subtle_mirror, leela_story, witness_perspective), gaia_voice. |
| uploads/muladhara-wakeup, svadhisthana-wakeup | not | Not built:<br>• Siddhis as roots ("tap any that call to you")<br>• Karṣiṇīs as drifting lights ("follow the ones that call… trace the current")<br>• "go deeper" safety question |
| uploads/maya-sleep.html | not | Not built: "Who are you speaking to?" fear question, the K/W/A triad (Vajreśī / Kāmeśvarī / Bhagamālinī), "There was / is never anything to fear". |
| uploads/\*-practice.html, bindu-practice(4).html | not | The V5 practice pages (teaching, writing, story thread, practice options). |
| uploads/svadhisthana-dance | n/a (Field) | |
| uploads/bindu-chakras-app.skill, skill-extracted/ | = bindu-chakras-app row | |
| screenshots/, uploads/\*.png | context only | Home spine (seven orbs), story void. |
| CLAUDE.md (chakra build principles) | captured as law | Charter §3 law 2. |

### 1c · Mandala design corpus (`/home/claude/design-upload/extracted/`)

| File | Verdict | Evidence / gap |
|---|---|---|
| The Eight Modes.html / modes.jsx | partly | **Built:** Mauna (`TheCentre` / `MaunaSilence`), Recognition. **Partly built:** Darśana (gaze in `ThePointView`, but not "hold vertical" with three depths at 3 s / 30 s / 2 min). **Not built:**<br>• **Sādhana** (the 102-name Khaḍgamālā, ~28 min: saṅkalpa · station · ring transition · Visarjana "The garland is offered back")<br>• **Smṛti** (every recognition as light; cluster zoom; time-lapse of the year)<br>• **Svapna** (first open: "who walked through last night" — voice record, tap who walked through)<br>• **Pūjā** (after sunset: the day's catches gathered, offered, released — "The day is received. Tomorrow opens again.")<br>Saṅgha is ruled dead. No hit for `Sadhana`, `Svapna`, `Puja` or `Darsana` in code. |
| Codex.html | partly | **Built:** five dimensions in part (Depth, Time, Memory), tap Bindu → silence, nine ring breaths. **Not built** (no `MagnificationGesture` mode, no two-finger, no edge-swipe in Mandala):<br>• Codex gestures: long-press ring → Smṛti; pinch outward → Sādhana (pinch is zoom); hold vertical → Darśana; swipe up from edge → today's pull; swipe down from top → Pūjā (evening); **two-finger hold → invoke** (her bīja, "she is here"); **long-press anywhere → catch**<br>• Ring 8 "tap a vertex collapses the other two"<br>• Ring 3 "she names herself in italics and dissolves"<br>• "The Initiation — first-time ceremony" (≈ Homecoming) |
| The Memory Layer.html / memory.jsx | partly | The Portrait Mandala is built; DescentFilm (`Views/Memory/DescentFilmView.swift`) ≈ the threshold film. Not built:<br>• Petal Biography (first / last / peak month)<br>• Threshold Timeline (status crossings)<br>• Cluster Garden (five clusters)<br>• Density Atlas<br>• First Word · Last Word<br>• Lifetime Spiral |
| The Temporal Layer.html / temporal.jsx | partly | **Built:** Cosmic Now (`ThePointView` + `Ephemeris`), the Lunar Yantra time states (`TimeVariant`), Tithi Today (`NityaDetailView`). **Not built:**<br>• **Sandhyās as micro-practices** (Prātaḥ "Open the eyes…", Madhyāhna, Sāyam "What you carried today you may set down here" — only junction tinting exists)<br>• the **Seasonal Yantra** across Vasanta…Hemanta for the whole Mandala<br>• the **Great Wheel** (the year as one circle) |
| The Relationship Field.html / relationship.jsx | not, ruled dead | Brief V2 §6. Only the Settings "Field Connections" names remain (ring-2 positions 3 / 12 / 14). |
| Master Build Brief.html | mostly captured | Rite as launch, status crossing (`ShaktiDetailView.crossingPill`), detail hierarchy, DescentState, Portrait. Its "content gates the path / next ring closed" was lifted (§3). |
| Refinement Brief.html | captured / obsolete | The ring-world fixes target worlds removed in July and since reborn inside the zoom. |
| Design Audit.html, Audit II.html | captured | Living Rite, scale, the tap-name door. The **hamburger first-run breath** is unverified (not grepped as a feature). |
| uploads/bindu-mandala-master-brief.md (12 sections) | partly | See §G below. |
| `Claude Chat/bindu-mandala-expansion.md` (the 44) | partly | See §2 G1–G44. |
| The Homes – Concept Board (V3, SVG) | captured as mechanisms | Authored rooms: `PressRoom`, `ReleaseRoom`, `MembraneRoom`, `TripleRoom`, `DissolveRoom`, `KnownRoom`, … |
| The Homes – Rooms in 3D | **not** | True transmission, the RGB triple exposure merging to white rendered as light, cloth displacement: wave-1 D "Not done here". The Homes thread says to retire it (§3). |
| The Homes – The Nine Worlds | captured | `RoomAir` per-band physics, the Climb. |
| The Rite of Entering (older) | partly | Captured: the after-effect kinds (`HomeAfterEffect`). Not built: **the yantra beyond the far wall at the second adaptation** (0 hits for `farWall` / `yantraBeyond`). |
| Ring Worlds / II / ring-worlds-\*.jsx / ring-nine.jsx | partly | **Built:** Ring 3 scatter / gather, Ring 6 follow, Ring 7 twelve chord, Ring 8 three tones, Ring 9 Spanda + Praveśa (`TheBuilding.swift`, `MandalaFieldVoice`, `TheCentre`). **Not built:**<br>• **Ring 1 Earth-City** (three families on three squares, four T-gates that flood the world, the family legend lighting a band)<br>• **Ring 2** lotus following the sun (opening / open / closing / closed by hour), press a petal to invoke<br>• **Ring 4 Sampradāya** (the teaching travelling teacher→student)<br>• **Ring 5 Kulottīrṇa** (light overflowing its boundary)<br>• **Ring 8** vertex-collapse → dissolve into the Bindu |
| Home Mandala / Mandala App (v2) / screens / mandala-v2 | captured | Wave 1 A. |
| Mandala Legend / Veil / legend-explorations / veil-mandala | captured (reshaped) | `MandalaVeil`. The ladder is lifted (§3). |
| Living Rite / Living Axis / Field / design_handoff_living_rite / living-rite-\*.jsx | captured | Wave 1 B and C, Wave 2. |
| The Homes – Axis / Verification V3 / thread.md / method.md / Claude Code Handoff – Homes / homes-\*.js / all-shaktis-data / shakti-data | captured | The Homes engine. The "near" state is 61 of 102 names reconciled (Homes thread "Next" #2); it should be verified against the rows. |
| Final Handoff.md §4 | partly | Ring drone ✔, descent film ✔, exportable Portrait ✔, Silence gesture ✔. **WidgetKit widget ✘.** |
| Bindu-Mandala-Handoff(-II).md, Claude Code Brief.md, DESIGN_SPEC.md, github.md, doc-page.js, ios-frame, tweaks-panel, design-canvas, scratch/, screenshots/ | captured / tooling | |
| uploads/homes-design-package, shakti-cards | captured | Homes grammar. |

---

## 2 · Gap ledger

Priorities: **core** = core to the gamified-energies app · **enrich** = enriching · **later** = later or needs Ashrey's content.

### A · The Eight Modes, the Codex grammar and the Temporal and Memory instruments

| # | Item | Source | What it is | Where it would live | Priority |
|---|---|---|---|---|---|
| A1 | **Sādhana — the Khaḍgamālā** | modes.jsx Mode 3; Codex §III–IV (pinch outward); expansion #40 | The 102 names in sequence, ring by ring inward, ~28 min. A saṅkalpa, stations, ring transitions ("You leave the Sixteen-Petal Lotus"), the Bindu arrival, then Visarjana ("The garland is offered back · The 102 return to the One"). Each seat sounds as it passes, along one continuous camera path. | `Views/Mandala/Sadhana.swift` on `MandalaCamera` (reuse `ChakraRoad`'s path engine), ledger type `Garland Recited` | core |
| A2 | **Smṛti — the constellation of memory** | modes.jsx Mode 4; Codex (long-press a ring); expansion #35 | Every recognition as a star on the yantra. Energies met on the same day thread into constellations. Zoom a cluster; a time-lapse of the year emerging. No counts ("23 catches" in Design → drawn, not printed). | `Views/Memory/SmritiView.swift`; long-press a ring in `LivingMandalaView` | core |
| A3 | **Svapna — the dream** | modes.jsx Mode 6; Brief V2 parked-alive | First open of the day: "who walked through last night?" Speak or type the dream (needs SpeechCapture, F1), then tap the Śaktis who walked through. A dream → Codex mirror. | `Views/Today/SvapnaView.swift`; ledger `Dream Kept` | enrich |
| A4 | **Pūjā — the evening offering** | modes.jsx Mode 7; Codex (swipe down from top, evening only) | After sunset the day's catches gather, are offered and are released: "The day is received. Tomorrow opens again." This is ASG's closing bell (see B5). | `Views/Today/PujaView.swift`; ledger `Day Offered` | core |
| A5 | **Darśana proper** | modes.jsx Mode 1; Codex (hold vertical) | Hold the phone *vertical* and still. Three depths: arriving 3 s, holding 30 s, entered 2 min. Time stretches; the yantra wakes to stillness. | Extend `ThePointView`'s gaze, or a mode in `LivingMandalaView` | enrich |
| A6 | **Two-finger hold → invoke** | Codex §IV | Brings a specific Śakti into live presence; her bīja sounds: "she is here". | `LivingMandalaView` gesture layer | enrich |
| A7 | **Long-press anywhere → catch** (G39) | Codex §IV; padakarshini G39 | Freezes the moment as a recognition from anywhere, without opening Today. | Root gesture → `RecognitionMomentView` | enrich |
| A8 | **Swipe up from the edge → today's pull** | Codex §IV | Today's Śakti rises from any Mandala depth. | `LivingMandalaView` | enrich |
| A9 | **Sandhyās as micro-practices** | temporal.jsx Instrument 3 | Prātaḥ "Open the eyes before the world opens them for you" · Madhyāhna "The sun has nothing to hide" · Sāyam "What you carried today you may set down here". Each is a small practice opened by the hour. Today there is junction tinting only. | `RiteDay` doors at sandhyā times + `ThePointView` | enrich |
| A10 | **Seasonal Yantra / seasons of the rings** | temporal.jsx Instrument 4; expansion #44 | The whole Mandala tilts with the real ṛtu (Vasanta…Hemanta): Śṛṣṭi-bright at the year's turn, Saṃhāra-cooled at its close. | `TimeVariant` + `Ephemeris.ritu` | enrich |
| A11 | **Great Wheel** | temporal.jsx Instrument 5 | His year of practice as one circle: practised days as light, moon phases on the rim, season sectors. Days without practice are absent, never dark slots. | `Views/Memory/GreatWheel.swift` (an alternative face of the Portrait) | later |
| A12 | **Memory instruments ×6** | memory.jsx 2–7 | Petal Biography (her story with him: first meeting, last meeting, the month she came most — no totals, no "longest gap"), Threshold Timeline (dated status crossings), Cluster Garden, Density Atlas, First Word · Last Word, Lifetime Spiral (each year a ring). Allowed under charter §4.6 as "he may ask to see his own record". | `Views/Memory/` behind "my record" | later |
| A13 | **Ring-world mechanisms not reborn** | ring-worlds-2/3.jsx; ring-worlds.jsx | Ring 1 Earth-City: three families on three squares, four T-gates flooding the world, a family legend lighting a band. Ring 2: the lotus following the sun (opens and closes by hour); press a petal to invoke. Ring 4: Lineage — light travels teacher→student. Ring 5: Overflow — light exceeds its container. Ring 8: tap a vertex → the other two collapse into it → dissolve into the Bindu. | `Homes/TheBuilding.swift` mechanisms + `MandalaFieldVoice` | core |

### B · A Strange Game

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| B1 | **Trinity of Guidance as voice architecture** | a-strange-game SKILL; trinity-of-guidance.md; Codex.html relationship axis | Three axes and five faces: Gaia (ground) · Bindu→Lalitā (player) · Sakshi→Higher Self (witness). Placement in the Mandala: Gaia at Ahaṅkārākarṣiṇī, Bindu→Lalitā on the climb, Sakshi on the descent, the Higher Self (Ram) at Ātmākarṣiṇī.<br>• Today: only Sakshi's close, and the editable "Field Connections" names (ring-2 positions 3, 12, 14).<br>• Authored lines per face, chosen per moment, never generated. | `HomeWords` / `RiteDay` voice tags; Detail | core |
| B2 | **Knowledge–Will–Action as how a Home closes** | a-strange-game SKILL; master brief §4; maya-sleep K/W/A triad | Every room's close passes through Knowledge (her nature), Will (his gesture) and Action (one thing carried out). "Light is what enters when these three close." | `TheStay` close / the activation cycle (G-ms4) | core |
| B3 | **Three pools: essence / memory / being** | storage-pools.md | Who is walking (fixed), what was walked (the ledger), how he is arriving today (refreshed each visit). The Mandala has the ledger only; no "being today" state is read in. | `PracticeVault` + a daily state; Rite reads it | enrich |
| B4 | **Leela drops** | leela-architecture.md; seed library | Rare, unannounced; Lalitā speaks about *reality*, never the game ahead; each drop ends in a real-world action ("Ask reality for help with one thing"). The ask or a held silence is recorded. | A rare Rite door / Lalitā source; ledger `Leela Ask` | core |
| B5 | **Two bells** (open / close) | playing-side 01 (Junction 1), 05 | The day's opening bell and closing bell as the Rite's open and close. Bells come to him; skipping is a move ("Intentionally Skipped"). | `DailySummons` (morning) + Pūjā (A4) evening; a struck bowl | core |
| B6 | **Leela on the 33 (Board, A14)** | playing-side 18; sketchbook; padakarshini A14 | The die as a held ceremony; born at a six; arrows rise (an act of giving), snakes return (a lesson); every landing opens a room (question, practice first, line); "My life / What I'm building"; a care line. | `Views/Play/` new game over `ChakraConstellation` | enrich |
| B7 | **"Build the Sri Yantra" as a play verb** | catalogue wave 1; Reading §5 | Assembling the yantra enclosure by enclosure, beyond tracing 27 edges (petals, circles, gates, bhūpura). | Extend `PlayGamesYantra.swift` | enrich |
| B8 | **Sketchbook verbs Ashrey found fun: Turn, Join** | playing-side 20 | **Turn:** three rings rotated until their marks meet; the point appears (G24). **Join:** drag two things together; a third is named (from authored rows, not AI). | `Views/Play/` | enrich |
| B9 | **The Sakshi Pause** | playing-side 19; Routines | Hold = inhale, let go = exhale; three beads; "One breath is a whole practice. Stop here." | A door in `RiteDay` / Play | enrich |
| B10 | **Catalogue wave-1 games: Mala, The Stop, Sigil Forge, Imprint** | playing-side 20 | The Stop (Stop. Breathe. Remember., C-1303); Mala is covered by the Garland; Sigil Forge (draw her sigil); Imprint (IET body points). | Play | later |
| B11 | **The Dawn Letter** | seed library | The morning's word is a letter he sealed last night; the evening writes tomorrow's. | River + the bells | enrich |
| B12 | **"Reality plays back"** | seed library | His ask, sealed to reality; later the close offers possible echoes from his own ledger, and he decides whether it answered. | Wager extension | later |
| B13 | **World as the whole ledger / "every practice leaves an object, never a total"** | seed library; World in a Box | See C4. | — | — |
| B14 | **"Who is playing?"** opening; the unborn start | Leela on the 33 | A first question of the board. | B6 | later |

### C · Chakra-corpus games and experiences not ported (compare the 16 in `Views/Play/`)

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| C1 | **The Seed** | games-patience.jsx GSeed; Pairing Floor (the offering-that-leaves gains its return); padakarshini A6 / walk--growing | Plant it; it grows by *real time* (seed → sprout 2 h → sapling 8 h → tree 24 h → bloom 72 h). The Pairing Floor puts it where offerings were given: quiet growth, never counts. | Play game + a layer in her room / the Portrait | core |
| C2 | **Mandala Completion** | games-pattern GMandala | One petal missing (a dashed ghost); complete it with your stroke. Pairs with Invention / Integration. Could become "complete her enclosure" inside the Portrait. | Play / Portrait | enrich |
| C3 | **The 12 (find the order by feeling)** | games-pattern GSigns | Arrange the twelve signs by the feeling of neighbours. A Mandala analogue: the 12 Vāk voices of Ring 7, or the nakṣatra wheel. | Play | later |
| C4 | **The World in a Box** | The World in a Box.html (v1, v2); Child Games G | A diorama that grows one object per practice trace (garden plants, cloud from rain, drum from echo, fireflies per 36 beads, the seed's tree, letters, gates). Gifts arrive while he is away (pebble, feather, acorn, key…); a named world with weather. "Every practice leaves an object, never a total" — the answer to Lalitā's field as a living world. | `Views/Play/PlayFieldView.swift` → a world mode | core |
| C5 | **Colour Rivers** | Child Games D | Drag colours and watch them blend; a finger-play (G47) with her ring hues. | Play | enrich |
| C6 | **Body Map (alive / tight / absent)** | games-body GBodyMap; Pairing Floor (arrival gesture for the body rooms) | Mark where he feels energy, holding or nothing; the sessions feed the Living Mandala's body petals. | `WhereSheSpeaksView` mode + Portrait layer | enrich |
| C7 | **Shadow Translator → Ego Reveal inversion** | games-language; Pairing Floor | Name the burden, find the gift. The source is AI; rebuild as a two-field inversion using her rows (Mental State → Siddhi) or authored lines. | Play / Gates | enrich |
| C8 | **Mirror Maze** | games-language | One word through seven lenses. The source is AI; rebuild with the walk canon's per-room verbs, or let his word return through the nine rings' qualities (authored). | Play | later |
| C9 | **Sacred Experiences — Shadow scrolls** | Sacred Experiences B | "The creativity that was called impractical… Not destroyed. Compressed… You are a bigger container now." The Shadow corridor's words. | `MandalaThresholdMoment` / Corridor ending | enrich |
| C10 | **Still · Ajna** | Sacred Experiences C | "What do I see when I stop looking? The screen will wait. Close your eyes." The screen goes dark and waits. | Ring 6 / Ājñā door | enrich |
| C11 | **Flash · Intuition** | Sacred Experiences C | "Something already knows. Don't word it yet… Give it one word." | Mind-chakra door | later |
| C12 | **Arrive · Armin — Tat Tvam Asi** | Sacred Experiences C | Tat · Tvam · Asi arriving word by word, then an aurora. Chakra-practices' Armin is the spectrum / aurora ONE→ALL. | `MandalaThresholdMoment` 6→7 | core |
| C13 | **State-phrased doors** ("When the mind won't land…") | Sacred Experiences; Pairing Floor (midday sizes); padakarshini fieldguide--when | Doors named by his state, not the content. | `RiteDay` doors | enrich |
| C14 | **Hub Ceremony — ladder of centres** | Hub C; padakarshini practice--ladder-of-centres | One body cue + one tone per centre climbing ("Place both feet on the ground…"), 60 s each (15 s quick). Tones from the Awakening table, not solfeggio. | Climb practice / Play | enrich |
| C15 | **Front-camera Mirror (60 s with your own eyes)** | The Mirror.html; Sanctuary C; G22 | 60 s with his own eyes in a circular crop. Drop "Most people never stay… You stayed" (it grades). | Bindu gaze sibling | later |
| C16 | **Child Space (beyond the Door)** | The Child Space.html | Twenty questions to small-you, adult→child / child-speaks-through writing, a Promise, a letter *from* the child (he writes it, no AI). The question register for Innocence (Kaulinī). | After the Door game | enrich |
| C17 | **Living Mandala's play-fed layers** | Living Mandala.html | A practice-wheel segment per day, the 102-bead ring lit by Garland beads, a root web (Root System strokes reflected ×8), body-map petals, a seed centre bloom, a chakra colour wash, a layer legend. | `LivingMandalaLayers.swift` | core |
| C18 | **The Record as a document** | The Record.html | A dated, printable record: masthead, the mandala, the river letters, the child. No Numbers, no benediction. | `PortraitMandalaView` export → PDF | later |
| C19 | **Living header / time-of-day lines** | Sanctuary B | "The veil is thinnest now", "Something in you is rising", "The deepest things move in the dark"… by hour. | Rite / Mandala header | enrich |
| C20 | **The Field: one wall-clock breath + the Summons-hour convergence** | The Field.html; WAVES.md game reading; padakarshini calendar move | All 102 breathe on `(now mod 8000)/8000`; his chosen Summons hour becomes a 3-minute convergence. The "Someone in this field…" strangers are refused (fabricated). | `TheHundredTwoView` / `DailySummons` | core |

### D · The 33 rooms — the Bindu Chakras App inside the Mandala

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| D1 | **Walk Canon content for the 33** | walk-canon.json; bindu-chakras-app `bake_walk_canon.py`; delta-map-v2 | Ship the rooms' story, practice, wake-up, gate and depth fields (offline-complete). Today `ChakraConstellation.json` carries identity only. | `Data/WalkCanon.json` + a model | core |
| D2 | **A chakra is a door** (constellation lights are untouchable) | WAVES.md Wave 3 "Chakra rooms as doors into the Homes' practices" | A touch on a chakra light opens its room / card / practice, or its Śakti's Home. `ChakraConstellationLayer` draws and speaks but catches nothing. | `ChakraConstellationLayer` + a chakra sheet | core |
| D3 | **The six moments of a room** | experience-brief-v2 §6 | Arrival → Story → Practice → Wake-up → (Dance in Field) → Gate, per chakra. | `Views/Chakra/ChakraRoom.swift` | core |
| D4 | **The offering that leaves** | chakras brief §9; Experience Score §08 | Words held one breath, then they lift → ember → leave the glass: "The room keeps what you gave it. You walk lighter." The OM rises to full exactly once, then decays. The record keeps it; the view releases it. | Gate step of D3; also usable at the close of a Home | core |
| D5 | **The braid + Lalitā convergence / the Reveal** | chakras brief §2, §9 | Threads sequential within, free between. A gate unseals when all other threads have passed ("The gate is warm"). Lalitā opens when the 33 offerings are given. **The Reveal is a sealed layer — never describe it to Ashrey.** | `RiteDay` + D3 | core (Ashrey's ruling on whether the braid lives here or in Field) |
| D6 | **Ground wears the story's weather; "Day N. The road is quiet where you left it."** | chakras brief §3 | The opening field's ground follows the story-thread position; the corridor darkens the app. | `RiteDay` / Rite ground | enrich |
| D7 | **Body chakras as touchable surfaces on the Climb** | the-field (touchable locations); WAVES.md Wave 3; Charter §2 | Soles, Forge, Prāṇa, Hands, Pulse, Sonar, Echo, Vision, Axis, Crow at their heights: touch to feel or play. Not on the Climb (no hits in `Homes/`). | `WorldClimbScene` presences | core |
| D8 | **Wake-up mechanics with Śaktis** | muladhara-wakeup, svadhisthana-wakeup | Siddhis as roots ("tap any that call to you"); Karṣiṇīs as drifting lights to follow ("trace the current"). | Ring 1 / ring 2 Climb mechanisms | enrich |
| D9 | **Maya: "Who are you speaking to?"** | maya-sleep.html; Reading §7 (C-1305) | The fear question as the threshold into silence; the colourless Maya band dissolves when looked at; "There was never anything to fear" → "is never". | Ring 8 / Mauna entry | enrich |
| D10 | **Grace across all apps** | chakras brief §8 | Grace reads Feed, Learning, Field and Being moments, not only Mandala-linked rows (`RiteDay` filters by Mandala link). | `RiteDay.graceFormula` | enrich |
| D11 | **Gaia's silence keyed to the story; the corridor's unvoiced text** | chakras brief §7 | The pulse is built; the story voice is not. | D3 | later |

### E · tree-of-life / the-field

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| E1 | **Ring verbs as gestures** | tree-of-life panels | Press / Follow / Build / Open / Speak / Still / Receive / Hold / Dissolve, one per āvaraṇa: the ring's own gesture in Homes and on the Climb (cf. master brief's six families). | `HomeAttribute` / Climb | core |
| E2 | **Breath per ring; the guide's voice removes itself** | tree-of-life "Breath Arc" | P1 3×4-4-4 "in / hold / out" … P6 6-6 "in / see" … P7 7-8 with no labels. The labels disappear by Panel 7. | Room arrival / Climb crossing; `practice--breath` | core |
| E3 | **Light 5 % → 100 % across the nine** | tree-of-life Progressive Luminance | Room exposure ascending P1 5 → P8 90, the Bindu full. | `RoomLightRig` exposure per world | enrich |
| E4 | **Om 136.1 Hz "always playing"** | tree-of-life P9; Experience Score sound law | An OM stack at gain ≈0 from the first touch, rising only in breaths, heard fully once ("the crescendo is noise decreasing"). There are 136.1 voices but no ever-present stack. | `RingFieldVoice` voice 0 | core |
| E5 | **Panel 9's eight inverse dissolutions** | tree-of-life P9; panel9-prebuild-plan | Undo each ring's verb in reverse on the way to the Bindu; "the dissolution writes nothing"; only the Bindu dot survives. | Praveśa (`TheCentre`) | enrich |
| E6 | **Mini-reveal seeds** | tree-of-life Closing Architecture | Gaia reads the panel backward at the close ("The earth was already holding you. You just told it where."). | `HomeWords` deep stage | enrich |
| E7 | **Awakening bowls per ring** | tree-of-life (174 … 528, P9 silence) | Struck-bowl characters: earth drum, wooden bell, gong, crystal (3.5 s), singing bowl, shimmer twin, distant bell, trinity. Play's Bīja Tones use the pitches; the timbres are not modelled. | `PlaySound` / room arrival | enrich |
| E8 | **"Now go play."** | tree-of-life; Feed centre | The last line at the Bindu / Lalitā, handing to Lalitā's field. | `LalitaSourceView` | core (one line) |
| E9 | **"The naming IS the veil" at the Bindu** | tree P9 | The Bindu stays nameless; this conflicts with labelled seat 102 (§3). | — | ruling |
| E10 | **Three trees as directions** | the-field Domain 5 | Soul ↑ stillness (the Climb), Maya →• dissolving inward (the Mandala fall), Bindu •→ radiating outward (body chakras, movement). Name and feel all three; the outward (•→) direction has no form today. | Climb / zoom / Play | enrich |
| E11 | **Archetypes as vantages (inner Saṅgha)** | the-field | Nine vantages on one movement; a Śakti met through Gaia's / Sakshi's / Karishma's eyes. | Detail / room words | later |
| E12 | **Motion as glyph; activation by register** | the-field; chakras brief locked #11 | Energy chakras by stillness (2–8), body by movement (10–19), mind by visualization (21–29), recognition rooms unique. | D3 / Play | enrich |

### F · Bindu Feed, Being, Learning, Field

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| F1 | **SpeechCapture** | bindu-feed Waves | Shared speech-to-text for every "own word" (letters, margin, Wager seal, Svapna). | `Services/SpeechCapture.swift` | enrich |
| F2 | **Raw Codex write** (Status unset, Source App "Bindu Mandala") | bindu-feed Wave 3; Reading §1 (source value never used) | "Leave my own word" writes a Codex row. | `AirtableService` | enrich |
| F3 | **Single Breath clock + one BinduParticle on every screen** | bindu-feed shared kit; master brief §8 (the watching point) | One point, never explained, on Today / the Well / Silence / Recognition. The Recognition ripple converges into it; it fills the frame only at ring 9. It dreams when idle (#41). Never a crisp measurable circle. | `Theme/BinduPoint.swift` mounted in `RootView` | core |
| F4 | **Archive as a book** | bindu-feed final Wave | Letters, notes and recognitions as a flip-book, oldest first, yellowing by age; the exact middle page is a door into the descent. | `Views/Memory/` | enrich |
| F5 | **Portrait day glyph** | bindu-feed Wave 5 | Per day: coloured by the dominant ring, a dot per Śakti met, an ember per thing sealed. | `LivingMandalaLayers` | enrich |
| F6 | **Portrait month letter** ("it lands · say more · leave my own word") | bindu-feed Wave 5; Being Month Mirror; padakarshini A11 | A month read as one letter built only from what is true (template, not AI), answerable; "leave my own word" writes to the Codex (F2). | Portrait | enrich |
| F7 | **Being's Month Mirror + MonthSitting** | bindu-being design README | The month gathered as a field → what moved → the turning → the earned line → a place to answer. "The Sitting" is a two-way witness. | `Views/Memory/MonthMirror.swift` | enrich |
| F8 | **Being's witness line / Lalita Reflection's four gifts** | bindu-being lalita-modes.jsx | One day witnessed four ways: Arrival, Reading (shows its roots), Sitting, Field. | Sakshi close extension | later |
| F9 | **Full LightBody postures** | bindu-feed Wave 4 | Face-down, set down still, proximity-covered, lifted, held upright, left alone — gating Mandala scenes (e.g. a face-down phone = Mauna). | `PlayMotion` → shared | enrich |
| F10 | **Absent-fifth carrier as ground** | bindu-field Score Format | "The carrier is what she reaches for and does not say": the absent fifth as ground from the first beat in the field drone; Mandala's granted fifth stays above it. | `HomeVoice` / `RingFieldVoice` | enrich |
| F11 | **Per-Śakti Score JSON (three layers)** | bindu-field (Universal Substrate / Score / Vocabulary) | Room engine / her Score on her row, tunable live with no rebuild / her mechanism. | `AirtableService` + `HomeGrammar` | later (the "endless refinement" row) |
| F12 | **Performer archetype presence by dwell** | bindu-field Performer.swift | Presences ramp with his dwell in a room (Gaia from 0 over 4 s, Karishma strongest in silence…). | `TheStay` | later |
| F13 | **CLAUDE'S OFFERING once per room** | bindu-field protocol step 11 | One unasked addition per room, marked in code. | Homes | later |
| F14 | **Learning: Codex link gesture; Still Point (A9); Voice (A8)** | bindu-learning-app; padakarshini A8 / A9 | **Still Point:** each hold takes words away until only the ember remains — the floor of the descent. **Voice:** her Codex Portrait read by hand. | `TheDescent` floor; Detail | enrich (the Still Point is core to the descent) |

### G · Master-brief architecture sections (uploads/bindu-mandala-master-brief.md)

| # | Item | Status | What is missing | Priority |
|---|---|---|---|---|
| G-ms2 | Descent's four constants | partly | **Built:** the Bindu anchor, glissando (`GlissandoVoice`), the drone. **Not verified:** the depth-trail (passed rings recede but stay) and three-layer parallax. | enrich |
| G-ms3 | **Ring-interior arrival beat** | not | On settling inside a ring, its Presiding Form is named once, then recedes (Tripura … Mahātripurasundarī). | core |
| G-ms3b | **Collective ring gesture** | not (`collective` 0 hits) | Hold anywhere in the ring that is not a seat → all its Śaktis breathe together once (the ring's Mudrā verb at ring scale). Legibility graded by Yoginī class; it deepens after he has met every Śakti in the ring (tracked privately). | core |
| G-ms4 | **Activation cycle** (Knowledge→Will→Action→Reciprocal, ~2–3 min) | not | Six element gesture families: fire held pulse · water slow pour · air breath-timed · earth press-still · ether absence · light precise tap. Per-kp jitter; **recedes toward no gesture by rings 7–9**; the reciprocal response is fuller with patience. | core |
| G-ms6 | **Recognition ripple responds to approach** | not | Lingering before "I feel her" → a fuller, slower bloom; a rushed tap → smaller. Private physics, never shown. Her bīja answers richer. | enrich |
| G-ms7 | **Iconography grammar** (non-figural layers) | not | **Silhouettes are refused (§4.5).** The attribute glyph (pāśa, aṅkuśa, mirror, lotus…), colour treatment beyond hue and motion quality from her Iconography text are allowed and unbuilt (`iconograph` appears only in the Detail text). | enrich |
| G-ms8 | Watching point on every screen | not | = F3. | core |
| G-ms9 | Three VFX moments | partly | Recognition and Praveśa are rich; the activation climax does not exist. | — |
| G-ms10a | **Zero-Gap chrome recession** | not | Labels dense at ring 1, none by ring 9. | enrich |
| G-ms10b | **Crawling haptic** (C-1170) | not | A travelling pulse series for earth / ring-1 holds. | enrich |
| G-ms10c | Never scarcity-framed summons | captured | `EnergyGift` copy. | — |

### G · The 44 expansion ideas — status (`Claude Chat/bindu-mandala-expansion.md`)

| # | Idea | Status | Evidence / gap |
|---|---|---|---|
| 1 | A place, not a page | built | Homes |
| 2 | Lit through her gem | built | `RoomAir`, HDR |
| 3 | Built from her dhātu | built (grammar) | `RoomMaterial` |
| 4 | Her clock is real | built | `WorldBands` clocks |
| 5 | Inscription over the door | built | `RiteOfEntering` (appreciation phrase) |
| 6 | Name written stroke by stroke | built | `RiteOfEntering.swift:54` |
| 7 | Etymology breaks and remakes | built | descent station |
| 8 | Tuned to her bīja | partly | Carrier at the just interval; motes and light are not locked to her seed rate |
| 9 | Gravity leans by body | built (attribute) | `HomeAttribute` |
| 10 | Home remembers without counting | built | `HomeMemory` adaptation |
| **11** | **Your letter lives in her room as an object** | **not** | wave-1 D "Not done"; no letter in `Homes/`, `Views/Rooms` |
| **12** | **Her portrait arrives at the pace of stillness** | **not** | Codex Portrait only on Detail (`ShaktiDetailView:851`) |
| 13 | Homes connect (corridor) | built | `NeighbourDoorsView` |
| 14 | Siddhi after-effect | built | `HerSiddhiLingers` |
| **15** | **Personal Connection marginalia on the walls** | **not in rooms** | Shown on `AvaranaThresholdView`; not written on room walls; Ashrey's nine texts pending |
| **16** | **Rite as six stations** | **not** | Arrival / Summons / Meeting / Being-with / Offering / Carry |
| **17** | **Dawn vs dusk rites (Śṛṣṭi / Saṃhāra)** | partly | Time tinting only; no two ceremonies |
| 18 | Co-presided by the Nityā | built | `NityaDevi`, Rite |
| **19** | **102-day liturgical year** | **not** | 0 hits |
| **20** | **The Rite finds your tempo** | **not** | |
| **21** | **A rite that can't be rushed (labels recede with stillness)** | partly | Staged arrival; no stillness-gated recession |
| **22** | **Sometimes she doesn't dance** (ether absence at the Meeting) | **not** | |
| **23** | **It ends outward** (her somatic line as a thing to notice today) | partly | The Wager covers the shape; the Rite close does not |
| **24** | **Same-day return continues, never repeats** | **not** | |
| **25** | **Śarad Navarātri — nine nights, nine āvaraṇas** | **not** | 0 hits for `Navar` |
| **26** | **Breathes as one body** | **not** | Per-ring breaths by design; no shared respiration (= C20) |
| 27 | Lit from the Bindu | built | `MandalaLight.reach` |
| 28 | Made of light | built | Wave 1 A |
| **29** | **The ascent as its own passage** | **not** | DECISIONS 2871 parked |
| 30 | Veiled by secrecy (Yoginī mist) | built | Phase 5 |
| 31 | The fall speaks the mantra | built | Crossing bīja |
| 32 | Seat carries her form | refused (figural) | DECISIONS 3130. The non-figural glyph tier is still open (G-ms7) |
| **33** | **Diurnal** (at night only returned seats lit) | **not** | Conflicts with no-debt? Reads as *his* lights, not a deficit (§3) |
| **34** | **The moon's ring** (15 Nityās as a lunar orbit round the yantra) | **not** | 0 hits |
| **35** | **Portrait as night sky; same-day constellations** | **not** | = A2 |
| 36 | Each ring is a weather (dwelling) | built | `RoomAir` motes and weather |
| **37** | **Sound has altitude** (binaural vertical) | **not** | No spatial / binaural engine in Mandala |
| 38 | Tratak mode | built | `MandalaCanvasLayer` |
| **39** | **Body as the other map** (touch the throat → ring 5) | partly | `WhereSheSpeaksView` lights Śaktis; it does not navigate rings / the Climb |
| **40** | **Walk the mālā** (all 102 as one recitation) | partly | Garland game (beads); no spatial recitation (= A1) |
| **41** | **The watching point dreams** | **not** | = F3 |
| **42** | **A lamp for the nightstand** | **not** | Idle yantra mode, moon's ring turning |
| 43 | Siddhi as instrument-state | built | `HomeAfterEffect` |
| 44 | Seasons of the rings | **not** | = A10 |

**Unbuilt or partly built: 11, 12, 15, 16, 17, 19–26, 29, 33–35, 37, 39–42, 44, plus 8 partly** — about 24 ideas.

### H · Codex concepts (Reading §7) not built

| # | Item | Source | What it is | Where | Priority |
|---|---|---|---|---|---|
| H1 | **The one-page answer** (C-1279) | Reading §7 | A one-line essence or the full Home, his choice. | Detail top | enrich |
| H2 | **Pointy** (C-1306) | Reading §7 | One particle at every point: line → circle → ∞ → heart. | Homecoming / F3 | enrich |
| H3 | **Sacred Pause / Stop. Breathe. Remember.** as Rite openings | C-1160, C-1303 | The Rite's opening breath (ceremony grammar step 1). | Rite | enrich |
| H4 | **"I already did"** — the Totality close | C-1281 | The last line at kp 102 / Praveśa. | `DissolveRoom` / `TheCentre` | enrich |
| H5 | **Hidden witness page** | C-1280 | Sealed in each Home; it opens after he asks; he writes beside it. | Room | later |
| H6 | **Kundalini lived** | C-1166–70 | Root fear passing in waves, restlessness allowed as part of the arc. | Ring 1 / 2 room physics | later |
| H7 | **"Last memories" anchoring ritual; listen / sound gestures** | C-1311 | Body-chakra gestures beyond blink and shake. | Play (mic G21) | later |
| H8 | **Mudrā as stored code — his hand** | C-1237 | Built as a 2.4 s hold; not a hand-shape (multi-touch pattern) that calls her. | `HerDoorwaysSection` | enrich |

### I · padakarshini forms and gestures not used

| # | Item | Source | Use in the Mandala | Priority |
|---|---|---|---|---|
| I1 | **A9 Still Point** | padakarshini A9 | The floor of the descent (Reading §5) | core |
| I2 | **A13 Scored performance** | padakarshini A13 | A continuous ring-drone garland played from a Score (Reading §5) | enrich |
| I3 | **A5 Breath session** | padakarshini A5 | Breath by intention; ring breaths (E2) | enrich |
| I4 | **A14 Board** | padakarshini A14 | = B6 | enrich |
| I5 | **A1 Rite as touch-paced reading** (G11) | padakarshini A1 | Her Codex Portrait received paragraph by paragraph (= idea 12) | enrich |
| I6 | **A10 Day's line in three persons** | padakarshini A10 | To him / back to him from his seals / about the world | later |
| I7 | **A11 Answerable reflection** | padakarshini A11 | = F6 | enrich |
| I8 | **B1 Threshold card weights** | padakarshini B1 | 40 / 23 / 20 / 12 / 5 before entering a room | enrich |
| I9 | **B2 Two-door station** (walk it or read it) | padakarshini B2 | WAVES says Lalitā's field is "walk it or read it, as equals"; the read half does not exist | core |
| I10 | **B4 "return / the road remembers"** | padakarshini B4 | The returning line on the Homecoming after days away (Reading §5) | enrich |
| I11 | **E seven forms of time** | padakarshini E | For any held practice (Sādhana, Pūjā) | enrich |
| I12 | **Ceremony grammar** steps 6–8 everywhere | padakarshini D | Whisper + one warmer light; sealing bowl; return to the same breath phase | enrich |
| I13 | **Gestures G24 / G25 / G26 / G27 / G28 / G32 / G36 / G21 / G22 / G46 / G50** | padakarshini gestures.md | G24 turn rings, G25 join, G26 keep, G27 wax seal, G28 rewind spiral, G32 carve a vow, G36 ask and the exhale answers, G21 mic, G22 camera, G46 speak, G50 sweep | per item |

### J · Homes / rendering

| # | Item | Source | Priority |
|---|---|---|---|
| J1 | **Floor traces** (where he stood glows) | Design Axis; wave-1 D "Not done" | enrich |
| J2 | **Yantra beyond the far wall at the second adaptation** | The Rite of Entering (older) | enrich |
| J3 | **Rooms in 3D: true transmission (Sarva-Yoni), RGB triple exposure merging to white (Trikhaṇḍā), cloth displacement (Laghimā)** | Rooms in 3D | enrich |
| J4 | **"You have stood here before" once, inside the room** | Design Axis; Reading §4. Today only the rail tick on the climb (`TheBuilding.swift:304`) | enrich |
| J5 | **Personal Connection marginalia on the walls** | expansion #15 (needs Ashrey's nine texts) | later |

### K · Other

| # | Item | Source | Priority |
|---|---|---|---|
| K1 | **WidgetKit widget for today's Śakti** | Final Handoff §4; mandala-app skill | enrich |
| K2 | **102 bīja voice recordings** (`bija_%02d`) | Brief V2 §7 — his alone | later |
| K3 | **Seed ledger** (one verb per Śakti, no repeats) | fabric-stories; WAVES "Then" | later |
| K4 | **Restore river letters from the ledger after a reinstall** | wave-5 notes §8 | core (data safety) |
| K5 | **Floor walk not on the ledger** (local day-mark only) | wave-3 notes | core (law 4.1: practice data) |
| K6 | **Spike census replica** `Views/Spike/MandalaDrawCensus.swift` | wave-1 lead | hygiene |

---

## 3 · Conflicts and paradoxes

1. **Letters to whom.**
   - The Correspondence corpus, padakarshini A3 and C-1346 write to *past or future self* (an age, a year, a moment, a feeling, a date).
   - The build writes to *her* (the Śakti) and forward only to lunar days. A3's guard also wants "a forward letter opens at local midnight of its civil date" — the build uses tithi starts instead.
   - Both can live: add the self-addressed directions alongside.
2. **The Veil and the descent.**
   - The Master Build Brief and Final Handoff rule "readiness is sensed; crossing is chosen; content gates the path; next ring closed".
   - Charter II and Wave 1 A lifted this to "nothing is gated; light by where you stand". `DescentState.deepestReached` is still kept but "nothing gates on it".
   - Settled by the charter. The Design briefs now disagree with the build.
3. **Rooms in 3D: retire or bring home.**
   - The Homes thread ("Next" #3) says retire Rooms in 3D, The Rite of Entering and The Nine Worlds as superseded studies.
   - The Reading §4 brings their techniques home: the after-effect and Nine Worlds are already in; transmission, triple exposure and the far-wall yantra are not.
4. **Portrait cooling.**
   - The Master Build Brief §VII says points "cool toward dim as time passes without her".
   - The never-a-debt law (§4.6) forbids an absence becoming a debt. The build has the year ring with no empty slots and no cooling.
   - Keep it as is. Dimming would read as falling behind.
5. **Diurnal (idea 33): "at night only the seats you've returned to are lit".**
   - This is light *about his practice* shown as darkness elsewhere.
   - It passes only if the unlit seats read as night sky rather than absence. Ruling-adjacent.
6. **Smṛti / memory instruments show counts.**
   - Design's mode strings include "her 3rd today" and "23 catches"; memory.jsx includes "total" and "longest gap".
   - Under §4.6 counts may be *drawn* on request. "Longest gap" is a debt and stays out.
7. **The Field's strangers vs truth.**
   - The chakra corpus Field ("Someone in this field lost someone…") and the Hub/Sanctuary Collective Pulse invent other people.
   - padakarshini's truth floor forbids invented counts. Rebuild the convergence as the 102 + his own hour, as WAVES already says.
8. **Generated voices in the corpus.**
   - Mirror Maze, Shadow Translator, Body-as-Scripture translation, the World-in-a-Box story, the Record benediction, the Child's reply, the 7:05 intentions and Leela's living reading are all live AI.
   - Charter law 8 and A3's guard forbid this. Each needs an authored-row or his-own-word substitute (noted per row in §2).
9. **Solfeggio vs the Awakening table.**
   - Hub's `SolfeggioEngine` and `CHAKRAS_7` (396–963 Hz) against Field's "no Hz to a Śakti" and the Play build's Awakening table (174…528).
   - Also the Reading's caution about the 528 Hz descent contour. The build chose correctly; the corpus disagrees.
10. **Chakra Game's 7-chakra frame vs the 33.**
    - `chakra-data.js` and `CHAKRAS_7` are the classic 7 with a Quiz that grades.
    - The Pairing Floor marks them superseded by the 33 Registers. Do not port the quiz.
11. **Karṣiṇīs: Svādhiṣṭhāna or Anāhata.**
    - tree-of-life P2, svadhisthana-wakeup and the Mandala table's Subtle Body Chakra put ring 2 (the 16 Karṣiṇīs) at Svādhiṣṭhāna (canon A).
    - The Map / C-1344 and the built constellation put Anāhata on the 16 Karṣiṇīs (canon B), with Svādhiṣṭhāna = the eight Mātṛkās.
    - Held as two lenses in the build. A walker meeting "follow the six Karṣiṇī lights" in a Svādhiṣṭhāna wake-up would see the conflict.
12. **Armin's form.**
    - chakra-practices: spectrum / aurora ONE→ALL, the inverse of Shadow.
    - Sacred Experiences: Tat Tvam Asi.
    - Built: "a garland gathers and parts". C12 would reconcile them.
13. **The Bindu: named or nameless.**
    - tree-of-life P9 says "the naming IS the veil" and the Bindu stays nameless.
    - The build names seat 102 Mahātripurasundarī; the Experience Score's Bindu is pre-name.
    - Paradox held (Reading §9). The centre could withhold her name until Praveśa ends.
14. **Breath: one clock vs many tempos.**
    - Feed's single Breath clock, The Field's wall-clock breath and expansion #26 call for one body.
    - Wave 1's nine per-ring breath rates, the Field chips and `FieldBreath` give many.
    - Both can hold: one carrier breath with the nine metabolisms as overtones. Today only the many exist.
15. **Gesture density.**
    - The master brief §10 says gestures recede toward none by rings 7–9.
    - Play puts physical games at kp 80 (Echo), 84 (Spine) and 94 (Door) in the deep triangles.
    - Not fatal, since play is invited, not required. Worth knowing for G-ms4.
16. **Crow's verb.**
    - The Map says RELEASE; the HTML says CROW; tree-of-life Axis uses BLINK (walk-canon Axis = BLINK, Crow = RELEASE).
    - The bake carries RELEASE (wave-3 notes). Still unresolved per C-1345.
17. **Rite at launch.**
    - The Final Handoff and Master Build Brief make the Daily Rite the launch spine.
    - Wave 3 makes the Homecoming the launch and hands into today's Recognition (not the Rite screen).
    - The covenant skips her encounter screen (name → somatic → "I feel her") on the way in.
18. **Status crossing vs §4.6.**
    - The status pill shows "level n of 4" (ARRIVAL ruling) and advances by recognition count.
    - The Reading lets it stand as "her state"; it is still a ladder keyed to his counts. Ruling noted, not resolved.
19. **Saṅgha / Relationship.**
    - Ruled dead in Brief V2.
    - The Codex's Relationship axis and the-field's archetypes-as-vantages bring an *inner* Saṅgha back without people (E11). The live residue is Settings "Field Connections" (Gaia, Ashrey, Ram), keyed by ring-2 local position (`SettingsView.swift:340`) — a pre-102 key, against position-is-identity.
