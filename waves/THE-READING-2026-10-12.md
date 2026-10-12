# Bindu Mandala — The Reading
*12 October 2026 · before the Fix + Upgrade walk · everything read, nothing collapsed*

## 0 · What was read

- **The repo, every branch.** GitHub `aistrangegame/bindu-mandala` (main `4724383`, 9 remote branches) plus the Mac's local branches, including 4 never merged: `practitioner-notes` (the margin), and the checkpoints `ring-4-cosmic`, `ring-5-giving` and `ring-9-bindu`.
- **The repo's own record:**
  - `ARRIVAL.md`, `BUILD-CHARTER.md`, `RULINGS-QUEUE.md`, `PROGRESS.md`, `iOS/FIDELITY.md`
  - `DECISIONS.md` in full (3,492 lines)
  - all 15 `Claude Chat/` docs (audits, master brief, the 44-idea expansion, Build Brief v2 + errata, Homes package)
  - `Claude Briefs/`, and `Claude Design Round 2/`
- **The code.** About 39.4k lines of Swift/Metal and about 29.6k lines of tests (813 test functions), read for architecture, data, sound, flags, every encoded law, and dead code.
- **The Design corpus.** The uploaded zip (162 files), compared element by element against what Code renders. This covers the Homes, Mandala, Rite, Recognition, Field, Well, Portrait, Veil/Legend, Ring Worlds, Eight Modes, Temporal and Memory Layers, Codex grammar, and Design's own Audit, Audit II and Refinement Brief.
- **Live Airtable.**
  - All 33 tables in the ASG base.
  - Full schema and fill-rate of the Mandala table (102 Śaktis · 9 Āvaraṇas · 15 Nityās · 0 event rows).
  - App Activity (86 Mandala events).
  - The Map's parallel Śakti/āvaraṇa fields.
- **The whole Codex.** All 352 entries (Oct 2024 to Sept 2026); 114 raw memos read in full.
- **Every skill, every file, by family:**
  - form engines (rupakarshini, padakarshini, shabdakarshini)
  - Bindu siblings (Feed, Field, Being, Learning, Chakras, Money, Lalita Family)
  - the ASG world (a-strange-game, aistrangegame, atlas-emergence, the-field, the-mirror, tree-of-life, chakra-maps, chakra-practices, bindu-dances, emergence-stories, book-of-makers, dome-home)
  - the work world (all arc-*, wazoodle-*, akas-*, fabric and brand stories, supabsorb, dad-birthday)
  - art (canvas-design, algorithmic-art)
- **Set aside as tooling, not content:** docx, pdf, pptx, xlsx, mcp-builder, skill-creator, web-artifacts-builder, browser and computer-use, google-workspace, docs, import-memory, deep-research, prompt-blueprint, the spark persona and recipe.

---

## 1 · What Mandala actually is today

The `bindu-mandala-app` skill is months stale. The repo is the truth.

**Built and shipped Sept 21–23 under an autonomous charter**, with Ashrey taken out of every device check:
- 102 Homes, one per Śakti: SceneKit plus a Metal light pass. Eight rooms are hand-authored (kp 1, 2, 3, 4, 6, 27, 28, 102); the rest come from ring archetypes.
- The rite of entering, in three touch-paced beats.
- The nine-band climb, as one shaft.
- The Gate (Laghimā / Garimā).
- The descent into her mark: five stations.
- Room sound: a carrier per Śakti, with the fifth granted through relationship.
- The return memory, which compresses and gives a head start.
- The held way out (2.2 s).
- The felt register: legibility, 44 pt targets, Dynamic Type, VoiceOver for all 102 seats.
- The library fold.
- The Mandala's light: one source at the Bindu, gem-refracted bands, a stillness veil, Tratak, and the crossing bīja.

`ARRIVAL.md` leaves one ruling to Ashrey: the VoiceOver line "Embodiment: Embodied, level 4 of 4."

**Unmerged and local-only:**
- **`practitioner-notes` — "the margin".** His own request: a note-to-the-instrument in Settings. Text only, saved locally, synced to the ledger as `Note Left`. Schema V3. Audited for data loss: four loss paths found and fixed, about 3,000 lines in all. The checkpoint is marked "in progress and unverified."
- **`ring-4-cosmic`, `ring-5-giving`, `ring-9-bindu`.** Earlier checkpoints. Ring 9 was salvaged into main. The ring 4 and 5 checkpoints carry alternative `CosmicRoom`/`GivingRoom` files that main implements differently. They are probably superseded; verify before deleting.

**Live base.** It is clean where it matters: R17 holds, with zero event rows in the Mandala table and everything in App Activity. The real gaps are:
- Function is empty on all 16 Karṣiṇīs.
- Bīja is filled for 36 of 102.
- There is no Phonetic field. Phonetic and somatic prose exist only for the 16 bundled Ring-2 Śaktis.
- The Recognition Count mirror has drifted from the ledger: 51 versus 59 recognitions.
- Spellings: Vaśinī, Stambhinī, Jṛmbhiṇī, Mṛtyupraśamanī, Sarvāśāparipūraka.
- Legacy event choices and fields still sit in the schema.
- Lunar Day is defined two ways (0–29 versus 1–30).
- The Khadgamala field description says 1–108.
- The Codex's "Bindu Mandala" source value has never been used.
- The ring fields (gem, dhātu, clock, Avarana Beeja, body region) are verified live but **never read by the app**; they are typed into Swift.

**What actually reaches him:**
- He uses the Rite and Recognition steadily.
- Silences are timed.
- The Mandala's ring crossings happened only in July. Rings 1, 2 and 8 have never been crossed in the Mandala camera.
- The rooms became reachable only on Sept 22.

---

## 2 · Why Design and Code look different

The gap Ashrey can see has five causes.

1. **His own July rulings.** Ruling 1 replaced the nine worlds with one semantic zoom; Ruling 2 made the instrument open, with no gated veil. One commit (`3244f54`) deleted about 6,000 lines: the nine Ring Worlds, the Veil, the Silence screen, and the held yantra. Design's first audit had praised exactly these: the Veil as navigation, the ring worlds, and the time-breathing yantra.

2. **The "binding condition" — Code's own invention, not Design's and not his.**
   - It was ruled on 09-21 on a single test room (Garimā): "every attribute is an action on the room's own material, never a free-standing lit solid."
   - It was then extended, phase by phase, to all light: worlds, rooms, descent, climb.
   - Design's language is light standing in the air: glows, additive lines, emissive bodies, translucent membranes, caustics, a dispersion prism, a chatoyant band, nine coloured lamps.
   - Under the rule nearly all of it became grooves cut into dark stone.
   - Alongside it:
     - HDR and bloom are off (`wantsHDR = false`).
     - Every one of the 102 rooms is the same four-surface box, while Design shaped each room like her seat: square, petal, triangle, circle.
     - The climb has one light and one accent colour, where Design had nine rigs.
   - Brightness: Design's measured room ranges run roughly 80–255 on a 0–255 scale. Code's room means are about 11–65.

3. **Port losses — numbers matched, light lost.**
   - A CSS stroke multiplier of ×1.7 never applied, plus stacked 0.9 and 0.7 dimmers. Sacred geometry is 2–8× fainter on every screen: Rite about 2.6×, Recognition about 1.9×, Field chips 2–4×, Threshold about 8×.
   - `lrBackdrop`'s two or three light layers collapsed into one radial gradient.
   - **Dust motes on fire and water days, and in the Portrait, are probably invisible.** The opacity envelope animates 0→0 and is never sampled.
   - Staged arrivals collapsed into a single fade.
   - The six recognition "natures" (flare, pool, disperse, bloom, settle, radiate) flattened into one scale-breath.
   - The yantra on the Mandala lost its gates, both lotus rings, its inner circles and its shimmer; the triangle star is stretched to the Bhūpura.
   - The Mandala's indigo night sky became crimson-black.
   - Lalitā's red bloom is gone.
   - The Living Rite threshold ("enter her ring") was never ported; an older, 8× fainter view remains.

4. **The charter's restraint clause.** "When in doubt, choose the more restrained option." What it cost:
   - Dropped: the returning line, the beat pips, the climb's rail, Design's Mudrā line, and gem hues ("the gem bends; it never colours").
   - Refused: her form at seat zoom.
   - The veil was made unable to lift with familiarity.
   - Never built: the 102 Śakti lights on the climb, the corridor of neighbour doors, the letter object in the room, the after-effect, the floor traces, and the room's own words. These are composed in code but displayed nowhere.
   - The climb is silent.
   - Six `RingAudioService` voices sit dead.
   - Of the 44 expansion ideas, about 15 were built.

5. **The checks proved numbers, not pictures.** About 30 tests read the source off disk and pin exact strings, sets and file names. The snapshot baselines are geometry text, not images. Nothing ever compared Code's frame to Design's frame, and no human eyes were on a device.

*The Design handoff Code received is byte-identical to the uploaded one; Code did not miss a newer package. The upload does add studies Code never saw: Rooms in 3D (true transmission, a red/green/blue triple exposure), the older Rite of Entering (saturated "Turrell-grade" light, the yantra beyond the far wall, a four-kind after-effect), the Nine Worlds, and the Concept Boards. The Concept Board carries Design's own warning: "I built one perspective box for all of them… That is decoration."*

---

## 3 · First-principles pass on every rule

His ruling (12 Oct) is that a rule survives only if its first principle survives the question "what does this protect, and what ceiling does it put on the app?" Precedent alone is not a reason. The 11 Oct skill rulings point the same way: every law is a move, not a wall; emergence, never reduction.

| Rule | What it really protects | What it costs | Verdict |
|---|---|---|---|
| **Charter tiebreaker** "choose the more restrained option" | Avoiding loud mistakes in an unattended build | The whole Design gap | **Lift.** Replace with: *when in doubt, build the fuller version; Design's experience is the floor, never the ceiling.* |
| **Binding condition** (no free-standing light; five verbs only; every lit thing is a mark in stone) | Aniconism — no figure of her | Nearly all of Design's atmosphere | **Reshape to its first principle:** no *figural* depiction of a Śakti. Light, glow, gems, membranes, additive lines, emissive forms, transmission and caustics are not figures. They return. |
| **Aniconic** (no figure of her) | The Śrī Vidyā way: her form is implied by what the room does | Only a figure is lost | **Keeps** in its true form. Words naming a body part are not images: Design's Mudrā line can return. Her iconography read as text on Detail is knowledge, not a depiction, so the "law breach" the code-map found is not one under first principles. |
| **Never measure** (as encoded: no digit, no drawn ramp, no "you have been here", no rail, no met marks, gem never colours, veil never learns) | His Codex: energy recedes under scoring and telling (C-1195, C-1284, C-1286); the instrument must never grade him or make him behind | Every surface that says *place* was read as *progress* | **Reshape to its first principle** (also rupakarshini law 15 and padakarshini law 11, ruled 11 Oct): **numbers and marks may describe her, the structure, the day and the place; nothing grades him, ranks him, or puts him behind; he may ask to see his own record.** The rail, the met marks, "you have stood here before", gem hues, a veil that knows familiarity, and the Portrait's warmth all return. Streaks or debts aimed at him stay out because the first principle says so, not because a regex does. |
| **Two Recognition lines verbatim** | His sealed gift: "she was felt here" / "and she felt you back" | Nothing | **Keeps.** Confirmed earlier as never in scope. |
| **Position is identity** (khaḍgamālā 1–102) | Data truth; it fixed real Design wiring bugs | Nothing on the experience | **Keeps.** |
| **R17: App Activity is the single ledger** | One record across all apps | Nothing on the experience | **Keeps.** |
| **His practice data is sacred** | Recognitions, letters, crossings, dwell, notes | Nothing | **Keeps.** This is his history, not a restriction. |
| **One door into a room** (only from her Detail footer); climb only from the Field; no corridor; no room list | Avoiding a "trapdoor" | Splits Design's "one building, no cuts" into disconnected screens | **Lift.** The climb holds her 102 lights; you fly into her light; neighbour doors; the room reachable from the Mandala seat, the Rite, the Field and the climb. |
| **Threshold has no cancel**; rite never skippable | The ceremony's integrity | A small cost | **Keep as designed.** The experience as designed is the floor, and Design gave the threshold no cancel. Compression on return already shortens it. |
| **The 2.2 s held way out** | A stray finger can't end a stay | Possible friction | **Keep, extend.** It is Design's number. Add Escape / left-edge as an equal way out per padakarshini law 14 ("leaving is one gesture everywhere, never punished"), since a hold *is* that gesture. |
| **Descent gated until 62 s of dwell** | "A stranger waits" | Depth withheld from the first visit | **Reshape** (padakarshini law 5, "staying opens things; nothing new is locked"): the way down is always offered; dwelling makes it deeper. |
| **The fifth withheld until relationship** | A gift that arrives through being with her | None that matters; it is Design's own mechanism | **Keeps.** It is a grace, not a lock. |
| **Composition lock** (1 pt geometry tolerance against pre-Phase-4 baselines) | Nothing moves by accident | Blocks every visual upgrade | **Retire as a gate; re-baseline after the upgrade.** Replace it with what was missing: a **visual fidelity check against Design's own frames**, plus Ashrey's eyes. |
| **LawsTests pinned sets** (about 30 source-reading checks) | The laws above | Every lift trips a pinned set | **Retool** to test the surviving first principles only: never grades him, lines verbatim, position identity, single ledger, data never lost. Delete the rest. |
| **"Choose quiet when legible" light caps** (light-pass clamp 0.86, wash ×0.09, growth spent on walls not light, veil −45%) | Washed-out frames | Dim rooms that pass every test | **Lift.** Turn on HDR and bloom. Fix washouts with *better* light, not *less*. |
| **Sound restraint** (climb silent, ring voices dead, no descent glissando, Mandala sound opt-in and off by default) | "Nothing invented beyond Design" | An instrument that is mostly silent outside rooms | **Lift.** Wire the ring voices into the climb and the Mandala, sound the descent, and build the continuous field the master brief asked for. rupakarshini law 10: existing sounds keep their pitch; new sound may take 136.1 / 110 Hz. |
| **"Nothing remembered on her screen"** (no @AppStorage on Detail) | No measuring | Small | **Lift.** |
| **Embodiment "level 4 of 4"** (ARRIVAL's one ruling) | — | — | Under the reshaped law it is *him asking to see her state*. It stays, unless he prefers it gone. |

---

## 4 · What comes home from Design

These are Mandala's own designs, so they are a homecoming, not borrowings.

### The Homes
- **Light in the air:** glows, additive seams, emissive cores, motes with hot centres.
- **Design's per-band physics:**
  - Pelvis: seven expanding red rings on cold blue.
  - Navel: a 2,600-point curl flow.
  - Heart: RGB caustics and a diamond prism.
  - Throat: a 72-rib colonnade with light shafts.
  - Forehead: nine translucent ruby bodies lit from within.
  - Crown: a luminous pearl fog.
  - Above-crown: a chatoyant travelling band.
  - Totality: nine gem lamps orbiting.
- **Seat-shaped room shells** — square, petal, triangle, circle — instead of one box.
- **Rooms in 3D's techniques:** cloth displacement (Laghimā), true transmission (Sarva-Yoni), and the red/green/blue triple exposure merging to white (Trikhaṇḍā).
- **The climb as Design's Axis:**
  - All 102 Śaktis as breathing points of light at their altitude.
  - "She was expecting you" core lights.
  - Today's Śakti carrying a crown light.
  - **Fly into her light** to enter her room.
  - The rail of nine (place, not progress).
  - The weather sentences.
  - Drag to turn.
- **Inside the room:** her name and quality, the near→deep words, the Well letter as a folded object, floor traces, "you have stood here before" once, neighbour doors along the corridor, and the after-effect (exposure lift; "her siddhi is still on the instrument"). The older Rite adds the yantra beyond the far wall at the second adaptation, and lighter/heavier/sharper/wider for 180 s after leaving.

### The Mandala, Rite and the rest
- **The full Śrī Yantra:** gates, two lotus rings, circles, triangles at 0.585, an 8 s shimmer, the Bindu breathing ×1.28, the indigo night ground.
- **Five time states:** new-moon desaturation, the Bindu at 1.6×.
- **Nine per-ring breath rates:** 3 / 8 / 9 / 11 / 13 / 15 / 18 s, and 4 s at the Bindu.
- **`lrBackdrop` layer for layer.**
- **The ×1.7 strokes**, with the dimmers removed.
- **The Rite's staged arrival** (nine beats), the air-lean composition, and her hue in the "I feel her" pill.
- **Recognition's six natures:** fire rises, air drifts sideways, ether blooms once and holds.
- **Lalitā's red bloom**, then the words emerging from the light.
- **The Living Rite threshold:** "enter her ring", with the ring's atmosphere.
- **The menu and sheets** lit by the day.
- **Restorable rather than new** — previously ruled out, now open under the first-principles pass:
  - **The Veil / Legend** (status as light: here · open · ground · ahead · veiled).
  - **The Ring Worlds' mechanisms**, reborn *inside* the semantic zoom or the Homes rather than as nine separate screens. This honours Ruling 1's reason (one continuous space) while restoring what it cost: Ring 3 scatters at touch and gathers in stillness; Ring 6's light follows the finger and names whisper; Ring 7's twelve-voice chord; Ring 8's three tones gliding into one.
  - **Ring 9 Praveśa:** the endless fall with the Shepard tone, and **G17's centre bloom** (the yantra drawn outward from the point while held).
  - **The Eight Modes:** Mauna (tap the centre for silence — the unbuilt `.silence` gesture's true home), Darśana (hold the phone still), Sādhana, Smṛti, Svapna, Pūjā.
  - **The Temporal Layer:** the five clocks round the point (hour, tithi, nakṣatra, season, sun), the three sandhyās, the Great Wheel. Guard: a real ephemeris, because a wrong tithi is a false statement.
  - **The Memory Layer's instruments** and the Codex gesture grammar ("there is no menu").

---

## 5 · What the ecosystem brings

**The form engines.**
- rupakarshini and padakarshini were distilled *largely from Mandala's own 19 Design prototypes*. That is where the climb, readiness, the veil, the bells, breath-by-depth, rooms-by-rule and the room test came from, and why so much of section 4 reads like their laws.
- Directly new for Mandala:
  - the ceremony grammar (§D) — the six element answers are Mandala's own
  - Gates of Release (A4) — the nine āvaraṇas walked inward, setting down each Mental State and receiving each Siddhi on the way out
  - Letter (A3) — a sealed letter, opening on her day
  - Wager (A12) — "watch for Smṛti today… did she appear?"; this *is* "catching her in the act"
  - Still Point (A9) — the floor of the descent
  - Scored performance (A13) — the home for a continuous ring-drone garland
  - the Veil (B3)
  - "return / the road remembers" (B4) — the returning line, with guards
  - the seven forms of time
  - G17, G2 and G44 for the zoom camera
- shabdakarshini's Lalita test: Lalitā arrives through mystery and play, and leaves at explanation. For an app with Lalitā at the centre, this is literal.
- Two sister skills, Rūpākarṣiṇī and Śabdākarṣiṇī, are named for Ring-2 seats.

**Bindu Feed.**
- The Waves method itself.
- **LightBody / TouchSense:** posture- and pressure-sensed scenes, "force absorbed, never punished".
- **The Portrait with no number:** a day glyph, a month letter answered "it lands · say more · leave my own word", and a year ring. Its year ring was partly *born from the Living Mandala's ring*.
- **SpeechCapture** for spoken notes.
- **The raw Codex write** from inside the app, with Status left unset.
- **The single Breath clock and one BinduParticle** across every screen.
- **Age / patina:** old Well letters yellowing by real time.
- **The Archive as a book**, with the middle page as a door into the descent.
- **"Seal it forward."**

**Other Bindu-tier apps.**
- **Being:** the Month Mirror and MonthSitting grammar; the witness line.
- **Chakras:**
  - the **grace channel** — App Activity read back once, room-matched, then rest ("three nights ago you finished a door in the Gita; it was standing in this room")
  - the offering that leaves
  - the Walk Canon bake for offline content
- **Learning:** the Codex link gesture.
- **Lalita Family:** "Remember the One", never printed.

**Bindu Field (the next app).**
- The **absent-fifth carrier law**: "the carrier is what she reaches for and does not say." This is related to and mirrored by Mandala's "her fifth": Field gives the withheld fifth as ground from the first beat; Mandala grants it after dwelling. Both can live: ground underneath, completion above.
- The **Score system's three layers**: universal substrate / per-item Score JSON in Airtable / vocabulary module. This maps exactly onto Homes: room engine / per-Śakti Score on her row, tunable live with no rebuild / her mechanism.
- The **Performer archetype-presence model**, driven by dwell instead of song time.
- The 12-step protocol's "Step 0: THE WORD" (her name and Khaḍgamālā line).
- The personal offering, "CLAUDE'S OFFERING", once per room.
- **Cautions:**
  - Field's rule is "no Hz assigned to a Śakti; no solfeggio-to-deity". The 528 Hz descent contour sits against it. Reading this as aesthetic generation rather than a correspondence claim is the honest line.
  - Field's "2.69 Hz pattern" is likely an artefact of its FFT bin width (exactly 2.69 Hz at n_fft 16384). It should not be imported as a discovered signature.

**The ASG world.**
- **A Strange Game:**
  - the Trinity of Guidance — Gaia at Ahaṅkārākarṣiṇī, Bindu→Lalitā on the climb, Sakshi on the descent, the Higher Self (Ram) at Ātmākarṣiṇī
  - Knowledge–Will–Action as how a Home closes
  - the three pools: essence / memory / being
  - Leela drops: rare, never foreshadowing, ending in a real action
  - two bells as the Rite's open and close
  - "build the Sri Yantra" as a play verb
  - its own law: "Storage may count; the screen may not."
- Existing bridges, already present:
  - the Identity record "Shree Yantra" maps 11 life games onto the 9 āvaraṇas and the Bindu
  - the Leela-on-the-33 board carries Śakti names on its body squares
  - the v3 site already has a Mandala world with 9 enclosure pages behind an allow-list
- **the-field:**
  - three trees: Soul ↑ stillness; Maya →• dissolving inward through the 9 āvaraṇas; Bindu •→ radiating outward. "Same Shree Yantra, opposite directions" — that *is* the climb and the descent.
  - archetypes as vantages, not people, giving an inner Saṅgha that never touches the dropped Relationship layer
  - motion as glyph
  - ten body chakras with touchable surfaces matching Mandala's altitude zones
  - "Blink. Breathe. Press."
- **tree-of-life / dad-birthday — a direct ancestor:**
  - nine panels = nine āvaraṇas with Śaktis
  - verbs per ring: Press / Follow / Build / Open / Speak / Still / Receive / Hold / Dissolve
  - breath per ring, with the guide's voice removing itself by Panel 7
  - light building 5%→100% across the nine
  - the persistent unexplained Bindu dot
  - the Om at 136.1 Hz "always playing — the crescendo is noise decreasing"
  - Panel 9's eight inverse-action dissolutions
  - "the naming IS the veil" at the Bindu
  - "Now go play."

**The work world.** Methods, not content:
- **The W-anchor:** each room is a permanent slot keyed to her; its form, words and sound are swappable occupants.
- **The seed** (fabric-stories): one locked three-word sentence, material + one verb, no two Śaktis sharing a verb — a ledger that makes sameness visible across 102.
- **The angle test, the rule of three and the cluster-native test** for her words.
- **Canon / render split**, with one canonical home per fact: a neutral library, voice per surface.
- **The Content Conscience's "metaphor-literalization" check:** felt language may evoke; it may not assert a mechanism or a count.
- **The Gaia frame:** data as what was needed, never a verdict.
- **"Positions are a photograph; movements are the film";** "the nine are distances, not types."
- **Seed→Perspective:** the same line at entry and exit, read as specification, then as revelation.
- **Karishma position** as the one master variable setting depth.
- **"Identity lives in the edges."**
- **Proven CSS precedents:** `.wz-descent` (strata 10/14/18 px) and `.wz-silence`.
- **The label principle:** "words prepare the body for what it is about to feel."
- **"Process before app":** display builds succeed, process builds fail unless the lived practice is written first. This applies to the Rite.

---

## 6 · The chakra question

**For folding the chakras into Mandala:**
- **C-1353 (2026-06-16)** is his only Codex definition of the app: *Feed = stories (read), Mandala = energies (appreciate), Field = sounds (dance).*
- **C-1337:** every energy in the yantra is a force of everyday interaction; map each one as an experience.
- **C-1343–1345 (May 17):** The Map table was formally re-aligned to the yantra, so every one of the 33 already has an address among the 102. Energy chakras are in āvaraṇas 1–3 with shared mudras; Shadow is the corridor; body chakras are in 4–6, one named Śakti each; Armin is Tripura Mālinī, the threshold to 7–8; mind chakras are in 7–8; the Bindu is āvaraṇa 9.
- The Bindu Chakras app was designed (floor locked July) and never built.
- The Tree of Life panels *are* the nine āvaraṇas.
- Practice evidence:
  - energy chakras need stillness, body chakras need movement (C-1311)
  - breath triads (C-1342)
  - Manipura opens through bhakti (C-1230)
  - the Maya chakra dissolves under awareness (C-1305)
  - energy activates through the body and mind, not by going at it directly (C-1327)

**The tension to hold — two canons that may be two lenses:**
- **A. One chakra per āvaraṇa, vertical.** This is the Mandala table's own Subtle Body Chakra: 1 Mūlādhāra … 6 Ājñā, 7 Sahasrāra, 8 Bindu-Visarga, 9 beyond. tree-of-life and chakra-practices agree. The climb's body heights follow it.
- **B. The 33-chakra map's addresses in the yantra.** This is The Map / C-1344–45, his most recent canonical ruling, distributed by section.
- They may not conflict. A is the body's vertical axis; B is where each of the 33 lives in the yantra's geometry. Ruling needed: does Mandala carry both, A as the climb and B as the constellation and depth layer?
- Smaller conflicts to reconcile against the 102 rows:
  - Soles sits at āvaraṇa 4 in The Map, but the feet are band 1 in the climb.
  - The skills' partial and divergent Śakti lists (Panel 6's inner ten, Panel 7 missing Aruṇā, a siddhi set without Sarvakāma).
  - Gaia appears as Śabdākarṣiṇī in one tree file but as Ahaṅkārākarṣiṇī in Mandala.

**Overlap with Field.**
- Field already has a 33-chakra Map tab with danced/available/locked states.
- His own split (C-1353) suggests the answer: Field holds the chakras' *sound and dance*; Mandala holds their *energy and Śakti*.
- One app per verb, no sixth Bindu app.
- Pending: his Claude Design chakra set and games.

**Cautions from his own words:** focusing on the energy makes it recede (C-1195), and kundalini "is true because believed", with awareness as an equal path (C-1305). So the chakras should arrive as places and practices, not as a ladder or a dashboard.

---

## 7 · Codex concepts for Mandala

*Selected from the full harvest.*

- **Two-way practice (C-1337).** Each Śakti gets an everyday sensory doorway: heat, cold, water, earth, breath, an arm moving. Engagement completes her — "she felt you back, and is complete."
- **The mudrā as stored code (C-1237).** The first visit is the long process. After that, *his* hand holding her mudrā calls her back — his hand, never hers, so it stays aniconic.
- **Tratak (C-1222).** White light moving behind the red dot. Already built (Phase 5): his own experience, made into the app.
- **"Overwhelming by design" (C-1289).** Open on all 102 at once, then let go and choose. This affirms the semantic zoom.
- **The one-page answer (C-1279).** A one-line essence or the full Home, his choice.
- **Pointy (C-1306).** One particle at every point at once: line → circle → ∞ → heart.
- **The Sacred Pause (C-1160)** and "Stop. Breathe. Remember." (C-1303) as Rite openings.
- **"Who are you talking to?" (C-1305)** as the threshold into silence. The colourless Maya band dissolves when looked at.
- **What is above creation cannot be attained by action (C-1307).** The Bindu is reached by being shown, never by doing.
- **"I already did" (C-1281).** The Totality close.
- **The empty summit (C-1260)** and "you can't find the centre because you are it" (C-1197). The descent ends where it began.
- **The Correspondence (C-1346).** Letters to a moment, an age, or the future, sealed in time and revealed word by word. This is the Well's upgrade.
- **The hidden witness page (C-1280).** Sealed in each Home; it opens after an ask; he writes beside it.
- **Random gift notifications (C-1353).** Mandala's arrives as an energy gift at an unscheduled time.
- **Atman / Brahman (C-1134).** The Portrait as his pattern; the Mandala as the whole.
- **Sound around its gaps (C-1297)** and the missing fundamental the ear completes (C-1350). She is felt, not heard.
- **Kundalini lived (C-1166/68/69/70).** Root fear passing in waves, the heart rising, restlessness allowed as part of the arc.
- **Body chakras as gestures (C-1311):** blink, shake, listen, sound, and the "last memories" anchoring ritual.
- **Light descends; it cannot be measured, only witnessed (C-1286).** The design law for the light.

---

## 8 · Fix inventory

The reconciliation pass, before new scope.

**Merge**
- The margin (`practitioner-notes`) after verification: Schema V3, `Note Left`.
- Decide on the `ring-4/5` checkpoints (likely superseded).

**Code defects**
- Motes invisible on fire and water days and in the Portrait (envelope never sampled; positive delays).
- `hasBeenFelt` is server-only, so felt seats don't light offline.
- Silences count as "felt" in the Field and Portrait.
- `didSettle` jumps to the Portrait from any screen, including a room.
- The offline queue drops recognitions after 3 failures.
- The Detail always reports gesture source `.mandala`.
- The letter editor has no `scenePhase` save, so words are lost on a background kill (the margin audit found this).
- `ENERGY_POS` is read inconsistently.
- Field connections are hard-coded and never written back.
- The ring data (gem, dhātu, clock, bīja, body region) is typed into Swift, not read from Airtable.
- The `logVerification` dump runs on every sync.
- The spike `.metal` file ships in Release.
- The Siddhi↔Mātṛkā expected failure.
- The kp 43 tautology.
- Texture seams and the hard horizon.
- The `ARRIVAL.md` note about a red test is stale: it was fixed at HEAD.

**Data**
- Function for the 16 Karṣiṇīs.
- Bīja for the 66 without one.
- A phonetic field and somatic prose for the 86.
- Re-derive Recognition Count and Last Felt from the ledger.
- Spellings.
- Retire the legacy Row Type choices, Type field and event fields.
- Unify the Lunar Day definition.
- Fix the Khadgamala description.
- Set the Codex Source App on the app's writes.

**Skills**
- `bindu-mandala-app` is stale on nearly everything (write contract, Threshold, unlock model, Homes status, key files, R17, the site export, the margin, branches).
- `asg-airtable`'s Mandala map is staler still.
- Rewrite both after the walk.

---

## 9 · Paradoxes held, not resolved

- **Measure.** "Storage may count; the screen may not" and "numbers describe them", against the joy he found building streaks "to create consciousness" (C-1068, C-1103). The first principle — never grade him, never make him behind — holds both.
- **Telling dims it, yet he builds to share** (C-1195 against C-1350, C-1351).
- **Energy activates only when not pursued,** yet the instrument offers practices (C-1327).
- **Stillness and movement:** energy chakras want stillness, body chakras want motion.
- **Ascent and descent:** the climb rises, witnessing brings consciousness down, the summit is empty.
- **Bindu as start and as centre:** ASG's Bindu is not-yet-knowing and Lalitā is arrival; in the Śrī Yantra the Bindu *is* Lalitā. Tree Panel 9 keeps the Bindu nameless ("the naming is the veil").
- **One clock and many tempos:** "breath slows toward the centre" (one clock) against "every place moves as what it is" and the nine metabolisms.
- **Restore Design faithfully, or go beyond it.** Design is the floor; emergence is the direction.
- **Uniqueness by discovery** (Field, fabric seeds) **or by grammar** (the Homes engine). Both: the grammar sets the floor, and per-Śakti discovery is the endless refinement.
- **Public and private.** The v3 site already publishes the Mandala's traditional strings behind an allow-list, while seed syllables and recognition stay in the app. This was settled by action, and the skill is stale on it.

---

## 10 · What is genuinely his to rule

1. **The chakras.** Fold the 33 into Mandala (energy/Śakti) with Field keeping the sound and dance? Carry both canons, A as the climb and B as the constellation? Bring the Claude Design chakra set and the games.
2. **The surviving first principles.** Recognition lines verbatim, position identity, single ledger, practice data sacred, no figure of her. Is any of these one he'd also lift?
3. **The Embodiment line** (ARRIVAL), now a small one under the reshaped law.

Everything else in sections 3–8 is a call that belongs to the build, made in the expansive direction.

---

## 11 · The machinery that must be retooled before the upgrade can move

- **LawsTests and LawsDrawnMeasureTests:** about 30 source-reading checks pinning exact strings, sets and paths.
- **The composition lock**, 1 pt geometry.
- **The binding-condition type system:** five private verbs, `SurfaceCoordinate`, no mesh nouns.
- **The `TheWayInTests` door-placement regexes.**
- **`RiteOfEnteringTests`' refusal of returning vocabulary.**
- **The `Destination` enum pinned by equality.**
- **The asset catalogue pinned** to AppIcon and AccentColor.

Each of these exists to enforce a rule this reading lifts or reshapes. They get rewritten to test the surviving first principles, plus the check that was always missing: **does it look like Design, and better?**
