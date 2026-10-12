# Wave 6 · Airtable gap ledger — has everything in ASG that belongs in the Mandala been captured?

*12 Oct 2026 · read-only sweep of base `app248ZTWhYJlvQj2` (33 tables) against `wave/5-memory` (Waves 0–5 stacked). Nothing was written to Airtable or the repo.*

**How "used" was decided.** `grep` of `iOS/Bindu Mandala` for field IDs and names. The app reads the Mandala table by field ID (`AirtableService.swift` L250–340: 21 Shakti, 14 Avarana, 4 Nityā fields). It reads and writes App Activity by field name (`ActivityLedger.swift`). The Map reaches the app only through `Data/ChakraConstellation.json`, baked 12 Oct by `waves/wave-3/bake_chakra_constellation.py`.

**One finding about the bake.** The JSON carries 24 keys. On screen, only `name`, `subtitle`, `colorHex`, `kind`, `verb` and the address are used:
- `ChakraLayerOverlay` uses the subtitle.
- `ChakraConstellationLayer` uses the colour and the spoken label.

So `essence`, `mudra`, `bija`, `bodyLocation`, `activation`, `stage`, `sanskrit`, `shaktiName` and `primaryColor` were baked but are never shown. The bake reads Voice (`fldPFCAGzcorqrqHH`) and Codex References (`fldqcBq4XpvURwov9`) but does not write them out.

---

## 1 · Table inventory (33)

| Table | ID | Bears on Mandala? |
|---|---|---|
| Mandala | `tblrRwXJD0uP8HU8G` | **yes**. This is the app's content source: 126 rows (102 Śakti · 9 Āvaraṇa · 15 Nityā), 53 fields. |
| App Activity | `tblJlBeiHnqGpYrL7` | **yes**. The single ledger (R17): 152 rows (Mandala 86 · Feed 49 · Learning 17). |
| The Map | `tblwpmyKOeMxEEHd7` | **yes**. The 33 chakras, 58 fields, baked by Wave 3. |
| Codex | `tblDF4OCMcRoxkQjU` | **yes, schema only here**. 101 fields; its concepts and Source App bear on the app. Another agent reads the entries. |
| Identity | `tbluLyZj9ilH2RhIg` | **yes, in part**. 103 rows. Bearing: 10 Tree of Life Panel declarations, the Practice rows (Sri Yantra Tratak, Sacred Pause…), the 11 life Games plus the "Shree Yantra" mapping record, the Archetypes and Voices. The Beliefs are private and belong to Feed. |
| The Builds | `tbl5PR84YTy4anzAD` | **yes, in part**. 340 rows. Bearing: 9 "Awakening Sound" rows (the Hz table Wave 4 typed into Swift), 9 Enclosure pages, 33 Chakra Pages, 10 Panels, and the planned Play Pages (Mudra, Tratak, The 108, Seven Gates, Leela on the 33, Shake to Clear, The Door). |
| Bindu Field | `tblv3WvMZ90Sfhun6` | **yes, as a sister**. 60 tracks. It holds the **Score JSON** precedent, 9 tracks tagged with a chakra, and breath tracks with inhale/hold/exhale. C-1353 rules the split: Field dances, Mandala appreciates. |
| Gratitude | `tblEFiuFIijKe9ba6` | **possible (private, read-only)**. 91 rows, 24 Oct 2024 – 21 Aug 2025, dormant for 14 months. It could feed grace or the Portrait. |
| Emotions | `tblM00KNko6U4XPIz` | **possible but advise no**. 66 rows, last entry 26 Jun 2025. CBT-shaped; "Why?" carries other people. |
| SJ | `tbl30XBbgWZsvTT0D` | **no (private)**. 44 shadow rows, all Stage = Descent, Domain = Relational, about named family members. The Reading puts the Relationship layer out of the Mandala. |
| Anger | `tblKZIiUczlasfv9d` | **no**. 9 incidents, last Feb 2025, relational. |
| Daily | `tblavk9qdHsgWH8d2` | **no, for now**. 221 fields. The bearing candidates are empty: Witness Line `fldFb5SuUTBjMZIyS` and the six "Field — …" register percents (`fldeOeaBhXBwHfsP4` …) have 0 filled rows. Habit and streak fields would grade him. |
| Gaia | `tbll9fXzLSa44XqUi` | **marginal**. A meta table (prompts, schema, archetypes). One row, "The Walker at the Bindu" (Witness Perspective), links to The Map's Bindu. |
| Routines | `tbltwLTYU6sL2W3Aa` | **marginal**. 45 rows of his day's rhythm ("Breathing & Meditation" 9:30, "Sakshi Pause", "The Work Is Done" 21:30). It could inform the gift and Summons window defaults. |
| The Feed | `tbl7vzODMMJUgeX0b` | **marginal**. It is Feed's home. Its moments reach App Activity with an Excerpt that Mandala's grace could read. |
| Learning | `tbl5kW1msXYfThGbj` | **no**. Learning's home. Its "Chapter Completed" rows are already in the ledger. |
| Walks | `tblJ2sg5ubhN5CH5M` | **no**. The Mirror's walks. |
| Goals / To-Do / Monthly / Year | | **no**. Planning and scorekeeping. They would grade him. |
| Activity / Fitness / Nutrition / Health / Books / Neev | | **no**. Body logs and family care. |
| Relationships / Family Links / Special Days / Timeline / Calendar | | **no**. People and dates (Timeline holds family birthdays). These are Lalita Family's, and out under the Relationship-layer ruling. |
| Device | `tblKYqcQk9QY3Htdj` | **no**. APNs tokens. The Mandala's gift is a local notification. |

---

## 2 · Gap ledger

Columns: **item** | **table · field (id)** | **what it holds (fill)** | **where it would live** | **how** | **truth-floor notes**

### 2a · Mandala table — Āvaraṇa rows (9) — fields never read

| item | table · field | holds (fill) | where | how | truth floor |
|---|---|---|---|---|---|
| **The ring's mudrā** | Mandala · Mudra of Avarana `fld1C14f4MsVIrA9F` | The opening Mahāmudrā per ring, e.g. "Sarva-Sankshobhini Mudra (All-Agitating)" … "Sarva-Yoni Mudra and Trikhanda Mudra" (9/9) | Gates of Release (beside Mental State and Siddhi); the room's words; the Veil row; the "seal his hand holds" (C-1237) at ring level | Read live: add to `AvaranaFields` and `RingFactsCache.Facts` (optional, as Siddhi was done) | The traditional ten Mahāmudrās, authoritative. **This settles "the āv 7 mudrā" canon question:** the row says Sarva-Khecarī; The Map says "Rahasya Mudra" for all 8 mind chakras (see §3). Words naming a hand are language, not image (§4.5). |
| **Phase of the ring** | Mandala · Phase `fldKWGAI16XjdqoI3` | Sṛṣṭi (1–3) · Sthiti (4–6) · Saṃhāra (7–9) (9/9) | The **Shadow (3→4) and Armin (6→7) thresholds are exactly the phase boundaries**. They could name the movement crossed, colour the Climb's three movements, and the Veil could group rows by phase. | Read live | Tradition-backed. |
| **Ring prose** | Mandala · Notes `fld1HR38cQAtEicFc` | One paragraph per ring: count, family, meaning ("the forgetting that hides recognition") (9/9, ~400 chars) | The Veil/Legend body; "enter her ring" threshold; the descent stations | Read live | Factual slip: ring 8 says "all **105** outer Shaktis" and ring 4 carries old spellings (see §3). |
| Ring status | Mandala · Status `fldDiihcxC54WKPhT` on Āvaraṇa rows | Mapped ×8, Active ×1 (ring 2) (9/9) | Nowhere. This is a progress word. | Leave unread | A ring "Status" grades him if shown. Mark it OLD on Āvaraṇa rows, or leave it. |

### 2b · Mandala table — Śakti rows (102)

| item | table · field | holds (fill) | where | how | truth floor |
|---|---|---|---|---|---|
| **Cross-ring sisters** | Mandala · Related Shaktis `fldQNnFoom72Nr6vh` + reverse `fldtAau1NIP4QDZrk` | The Mudrā ↔ Devī namesakes 19↔53, 20↔54, 21↔55, 22↔60, 23↔62, plus kp 55 → all 16 Karṣiṇīs (5 forward, 21 reverse) | A **third neighbour door**: "her namesake in the 1st ring". Today the doors are only kp ±1 (`Garland`). Also Recognition's after-glow and the Climb's threads. | Read live (record links resolve to kp through the roster) | Namesake pairs are complete (5 of 5). The kp 55 → Karṣiṇīs link is a semantic extension; decide whether it is a "sister". |
| **Bīja for 66** | Mandala · Bija `fldnOqkWcvjQNxpWl` | Filled 36/102: Mātṛkās 11–18, Karṣiṇīs 29–44, Vāgdevīs 87–94, 99–102. Empty: 1–10, 19–28, 45–86, 95–98. | Seat bīja on the canvas, the "crossing bīja", `BijaSoundService` | Enter in Airtable → read live (already wired) | Wave 0 ruled "empty where tradition gives none". **A source does exist for the ten Mudrās (19–28):** the Navāvaraṇa pūjā gives each a bīja (drāṃ, drīṃ, klīṃ, blūṃ, saḥ, kroṃ, hskhphreṃ, hsauḥ, aiṃ, and hsraiṃ hsklrīṃ hsrauḥ for Trikhaṇḍā). Verify against a lineage text before entering. For the Siddhis, Anaṅgas, rings 4–6 and the four Āyudhas, no individual bīja is standard, so they stay empty. |
| **Phonetic (no column)** | none. Only the bundled 16 carry `phonetic` (`ShaktiBootstrap.swift`). | 16/102, bundled | The Rite's spoken name (`RiteContent.spokenName`), VoiceOver | **New field** `Phonetic`, read live | Can be **derived deterministically** from the IAST Sanskrit Name (stress rules), so it is not invented content. Review by ear. |
| **Somatic prompt (no column)** | none. Bundled `somatic` ("Where is she landing on your skin right now?") exists for 16 only. Somatic Signature `fld6CylZqbIZQIUOp` (the poem) is 102/102 and is read. | 16/102 | The Rite's somatic line; the somatic way in (Wave 5); `SensoryDoorway` | **New field** `Somatic Prompt` | No source exists; it must be **authored** (law 8: authored, never generated live). Draft it in his voice and have him review it. Until then the 86 fall back to the poem's first line, as Wave 5 does. |
| Recognition phrase vs Appreciation Phrase | bundled `recognitionPhrase` (16) vs `fldBqEDpBonMc2s1K` (102/102, read) | Two phrase slots; `RecognitionMomentView` prefers the bundled one | Recognition | Fold the 16 bundled phrases into Airtable (or a `Recognition Phrase` field) | Two homes for one fact. The bundled text is authored and exists. |
| **Seed verb (no column)** | none. WAVES "Then" lists the seed ledger. | 0/102. The Map has a Verb for the 33. | Each room's verb; the 102-bead garland; the play door | **New field** `Seed`/`Verb`, unique across the 102 | Authored. No source exists. |
| **Score JSON (no column)** | none on Mandala. The precedent is Bindu Field · Score JSON `fldxIm6qUXLcdrRuR` (Score Status `fldOSMHwD7IxshwO7`). | 0/102 | Per-room tuning: carrier, tempo, light, mechanism parameters, "tunable live with no rebuild" (Reading §5) | **New multilineText field** on Śakti rows, read live and cached beside `RingFactsCache` | Parameters describe *her room*, never him. Validate the schema in-app and fall back to the grammar on a parse error. |
| Personal offering (no column) | none | 0 | "The personal offering in each room" (WAVES Then) | New field or a ledger type | Authored. |
| Field Connection | Mandala · `fldsk2ATEtTVB87eb` | 9/102 (Karṣiṇīs 29, 31–34, 40–42, 44). Read. | Field | Read already. The Reading notes the Swift connections are hard-coded and never written back. | Data is sparse, not a gap in reading. |
| Ring and family duplicates | Shakti rows: Avarana `fldut9433zwG5CXkT`, Avarana Name `fldXTUBJTDlkKEzEV`, Number `fldVWZLCy5YFJMkCp`, Of Avarana `fldGKKaNg4PHa5yMl` (102/102 each) | Redundant with kp | none (the app derives the ring from kp) | A test, not a feature: assert the select and link agree with `KhadgamalaMap` | Keeps two homes from drifting. |

### 2c · Nityā rows (15)

| item | table · field | holds | where | how | truth floor |
|---|---|---|---|---|---|
| Nityā depth | Mandala, Nityā rows: only Sanskrit Name, Number, Quality and Quality Description are filled (4 fields) | No Devanāgarī, etymology, colour, mantra or appreciation phrase | Rite's Nityā sheet; the tithi clock; letters sealed to "her day" | Fill the existing columns (Devanagari `fldDhcJ1BJQCM5llO`, Etymology `fldXypzqrhVILCqgh`, Appreciation `fldBqEDpBonMc2s1K`) → read live | Tantrarāja Tantra / Nityāṣoḍaśikārṇava give each Nityā's form and mantra. Transcribe; do not compose. |

### 2d · The Map — fields the bake dropped (33 rows)

All of these are authored walk content (Ashrey's Tree-of-Life / Practice-Book voice). None speaks *for a Śakti*: they speak as Gaia, Bindu, Sakshi or Lalitā, so law 8 is not engaged.

| item | field (fill, avg chars) | where it would live | how |
|---|---|---|---|
| **Voice** (Trinity) | `fldPFCAGzcorqrqHH` (33/33: Gaia 12, Bindu 8, Sakshi 6, Higher Self 4, Lalita 3). Read by the bake, not written. | Whose light speaks on the Road; grace voice; the constellation's register | Re-bake |
| **Core Question** | `fldFJsfXRts1MECj0` (33, ~38) | The one line at each chakra on the Road and constellation ("Am I safe here?") | Re-bake |
| **Signature Phrase** | `flddjDTJBa0o4KyLS` (33, ~55) | The seed line that appears three times; the threshold words | Re-bake |
| **Essence Line** | `fldgKEqNCw6VHlJIa` (33). **Baked, not shown.** | Constellation card / spoken label | Wire it |
| **Shakti Mudra** | `fldO14JGMU9cAYulu` (33, ~97). **Baked, not shown.** | Chakra rooms; the seal | Wire it, after §3's Rahasya fix |
| **Bija Mantra** | `flduXNmHwo7YQwwEB` (33). **Baked, not shown.** LAM/VAM…; "Mirror frequency" for body chakras; poetic "· · ·" for mind chakras. | Chakra sound on the Climb and Road | Wire it. The poetic ones are words, not syllables, so do not sound them as bījas. |
| **Body Location** | `fldH7EPRy3JPDO3Zi` (33). **Baked, not shown.** | The Climb's ten body surfaces; the somatic way in | Wire it |
| Activation Mode / Walker Journey Stage | `fldkOhQ5bDhECaVJs`, `fld6UsxyU5vel1isl` (33). **Baked, not shown.** | Energy = stillness, body = movement (C-1311): what the chakra asks of the gesture | Wire it |
| **Practice Prompt** | `fldMTSYXwFrUc9VpL` (33, ~880) | "Chakra rooms as doors into the Homes' practices" (Wave 3) | Re-bake |
| **Three Ways In** | `fldrlqps5wS0lWxd5` (33, ~790) | Three doors at a chakra, like the Rite's three doors | Re-bake |
| **Practice Gate Type** | `fldsrQQB5yBYvqIVB` (33: Textarea 23, Sound Response 6, Device Tilt 2, Canvas 1, Tap Rhythm 1) | Choose the play verb at each chakra (Tilt → Water/Crow, Tap Rhythm → Pulse, Sound → Echo) | Re-bake; map to `PlayField` games |
| **Gate Text** | `fld1rj2QuUuuGvvqc` (33, ~210) | The physical instruction before the door opens | Re-bake |
| **Hero Threshold** | `fldMA4kqwUTYsGFBs` (33, ~58) | The sub-line under the verb | Re-bake |
| Teaching Text / Post-Engagement Teaching | `fldCs6Vg2umNzxyQc` (~2,400), `fldC2OAa6NYrxrxWC` (~1,420) (33) | A "read" layer behind a long-press (one-page answer, C-1279) | Re-bake, or read live (large) |
| Act 1 Voice / Act 2 Voice | `fldopinrnQ5W0T8kE` (33), `fldnALQ6e9iF7fmnO` (**10/33**) | The Road's two-act telling at each stop | Re-bake. Act 2 is incomplete. |
| Story Thread | `fldIOc83AOzSiDmgi` (33, ~580) | The Bindu→Lalitā story between stops on the Road | Re-bake |
| **Leela Story** | `flduxpB6EM5tFRxUe` (33, 300–3,700) | Leela drops: rare, never foreshadowed (ASG law) | Re-bake |
| Gaia Voice / Bindu Reflection / Witness Perspective | `fldBiFWEG8gWb06DE`, `fldGfgZtoGNZTqIEM`, `fldvHuQwNxgjsh4su` (33 each, ~900–1,400) | The Sakshi close; the Hall-of-Perspectives idea | Re-bake |
| Writing Prompt / Writing Reflection | `fldtIqRA8QgXolDd9`, `fldS7BiDwPV5grdLy` (33) | The river Well's prompt at a chakra; the margin | Re-bake |
| Subtle Mirror / Mirror Frequency (+Instruction) | `fldJsogD1W8AkWhl6` (33), `fldNkcMhpaeuVQC22` (10), `fld1lfG7r96PQGPxP` (33) | Body ↔ energy twin pairing on the Climb (Soles ↔ Mūlādhāra …) | Re-bake |
| Color Dyad / Dyad Description | `fld4Bdiu8fg0RNrbE` (10), `flds5Iwg3XLrrbn1H` (12) | A two-colour light for the body chakras (the bake keeps Color Hex only) | Re-bake |
| Tree / Mind Triad | `fldX2s98w8U0Y5nK1` (33: Soul/Bindu/Maya/Structural), `fldcRFeUw4NQxCAl4` (9) | the-field's three trees = climb vs descent; triads on ring 7 | Re-bake |
| Panel Verb / Panel Seed Message | `fldrmoWcnoRpolZoV` (10), `fldwFamC9FndA94if` (9) | Tree-of-Life ring verbs (Press/Follow/Build/…), the per-ring seed | Re-bake. The Identity declarations pair with these (2f). |
| Tree Caption / Story Portal Headline | `fldsj8o9IssOWR6Rp`, `fldX55ru3s5OByoXd` (33) | Minor captions | Optional |
| Shakti Function / Shakti Practice | `fld5sWbzoT3lySYgI` (~720), `fldJqK4zLO7CNiWRu` (~360) (33) | Seated chakra's practice in her room | Re-bake. This is a second description of the same Śakti; the Mandala row's Function stays canonical (§3). |
| Codex References | `fldqcBq4XpvURwov9` (4/33) | Provenance only | Read by the bake, dropped. Carry it for the record. |
| **No khaḍgamālā key** | The Map has no kp field. The bake's `JOIN` table hand-resolves 10 spellings. | — | — | Add a link or text field on The Map (`Khadgamala Positions` or a link to the Mandala rows) so the join lives in data, not in Python. This is a schema add (his call). |

### 2e · App Activity — columns and choices the Mandala never uses

| item | field | state | where | how | truth floor |
|---|---|---|---|---|---|
| **Link to The Map** | `fldkF65ySNGGkeugH` (reverse `fldxl5Ez0Btgi8uoR` on Map) | 0 rows from any app | Chakra-level acts: Corridor at Shadow, the threshold moments, chakra-room practice, games at a body chakra. The bake already carries each chakra's `recordId`. | Write | The ledger's own design ("grace matches moment to room"). |
| **Excerpt** | `fldu19uazNrEt5vg5` | Feed 8, Mandala 0 | Letters sealed, the margin, Wager words: "the one line worth returning" | Write (his words only) | Private; his own words. |
| **Voice** | `fldhnzXPqnxYHTJv5` | 0 everywhere | Grace's register | Write from the chakra's Map Voice | — |
| **Grace reads only Mandala-linked rows** | `GraceChannel.formula` = `AND({Link to Mandala}, …)` | Feed's 49 and Learning's 17 moments (8 with Excerpt) never surface | The grace line in the Rite | Read live (widen the formula; match by Link to The Map or Voice) | Truth floor: grace may only speak a real row. Never compose beyond its type verb. |
| Surfaced / Surfaced Date | `fldUXJrrHnNLKdeln`, `fldzKJNjSS5fRwHA6` | Never set (0/152). Grace rest is phone-local because the "topology law allows no PATCH". | Cross-app "a moment returns once" | Write would need a PATCH ruling | Keep it as is unless he lifts the no-PATCH rule. |
| **Activity Type choices not yet in the schema** | `fldXNRBZy6QvIP8yz` | Choices exist for: Shakti Recognized, Letter Written, Ring Crossed, Silence Held, First Dwelling, Wager Resolved (+ others' types). **Missing:** Full Circle, Note Left, State Set Down, Siddhi Received, Played, Letter Sealed, Letter Opened, Portrait Drawn. | — | All "born by typecast" | **Risk:** typecast can create a select option only if the token's user can edit the schema. If it cannot, the POST returns 422 and the never-drop queue retries forever. Pre-create the 8 choices (one schema edit). |
| Gesture Source choices | `fldP3wq8QTgxeTDuC` | Has Today, Mandala, Well, Silence. **Missing:** Field, Room, Play. | — | typecast | Same risk. 77/152 rows have no Gesture Source (Feed and Learning rows). |
| The Rite floor's day-mark | none | Kept on the phone only (Wave 3 left a new type for the lead) | Sakshi close; the Portrait's year | New type, e.g. `Floor Walked` | Practice data that never leaves the phone today. A §4.1 concern. |
| Mood / Gaze | — | Gaze is a state, not an event (Wave 5), correctly | — | — | — |

### 2f · Identity, The Builds, Bindu Field, Codex, Routines

| item | table · field | holds (fill) | where | how | truth floor |
|---|---|---|---|---|---|
| **The nine declarations** | Identity · Declaration `fldry3UX62Eedqb9F` on 10 "Tree of Life Panel" rows (Identity Type `fldKURHO9ojpFr9ZC` = selDS8avIjqp3grx3) | His own lines: Press "I press where the ground meets me…", Follow, Build, Open, Speak, Still, Receive, Hold, Dissolve, Access | The ring's spoken line at Gates of Release (inward), the Climb rail, the Veil. These are tree-of-life Panels 1–9 = āvaraṇas 1–9 (Reading §5). | **Bake** (10 rows; stable) | His words, so the ring's line is authored. Note the ring verbs disagree with The Map's Verb on 3 rows (Svādhiṣṭhāna FOLLOW/FLOW, Maṇipūra BUILD/BURN, Aatma HOLD/KNOW). WAVES keeps both. |
| **Practice declarations** | Identity · Practice rows: "Sri Yantra Tratak", "Sacred Pause", "Evening Reflection", "Kundalini Cleansing Meditation", "Morning Intention" | His one-line declarations ("I sit before the Yantra. The dot becomes the doorway. The light moves on its own.") | Tratak's first-time words; the Rite opening (C-1160 Sacred Pause); Evening → Sakshi close | Bake | His words. |
| **Life Games ↔ āvaraṇas** | Identity · "Shree Yantra" record `recEyVVzXxDi0J6P5` (Why? `fldFFDYj5PFnO3xlv`) + 11 Games rows (FIRE, WORK, FITNESS, HEALTH, FAMILY, SOCIAL, ADVENTURE, LEARNING, SYSTEM, MAYA, SEVA) | A table mapping the 11 games to rings (FIRE/WORK → Bhūpura … SEVA → trikoṇa; Integrated Self → Bindu) | "Every real game sits at its address": a life-game layer in Lalitā's field | Bake **only after his ruling** | **Caution:** this is a Feb 2026 generated research report, not his canon. It says "each avarana must be fully experienced before ascending" (contrary to §4.6) and speculates about a "core wound". Use only the mapping table, and only if he affirms it. |
| Archetypes / Voices | Identity · Archetype rows (Gaia, Bindu, Sakshi, Lalita, Higher Self, Karishma, Sid, Arch, Ashrey) + Voice rows | One-line self-statements | The Trinity of Guidance voice per place (pairs with Map Voice) | Bake | His words. Karishma Voice is a placeholder ("To be developed…"). |
| **Awakening tones** | The Builds · 9 "Awakening Sound" rows, Carrier Hz `fld8FXhw0TvNDfNv4` | 174 · 210 · 320 · 341 · 384 · 426 · 480 · 528 · Silence (P1–P9) | Wave 4 `PlaySound` / Bīja Tones; ring voices | **Bake** (the values are typed in Swift today) | The Reading's caution: these are aesthetic assignments, not Śakti correspondences (Field's "no Hz assigned to a Śakti" rule). |
| Planned play pages | The Builds · Type = Play Page (65, all Planned): "Practices — Mudra / Tratak / The 108 / Shake to Clear / Breath / The Sakshi Pause", "Boards — The Seven Gates / Leela on the 33 / Gyan Chaupar", "Play · The Door" | Titles only | Cross-check against Wave 4's 16 games: Leela-on-the-33 and Gyan Chaupar boards are not built | Read for planning | — |
| Enclosure / Chakra pages | The Builds · Enclosure 1–9 (`/worlds/bindu-mandala/1–9/`), 33 Chakra Pages, Map URL `fld5wkzZkM30kmeyU` | Live site pages | A "read more" door, if he wants web links in the app | Optional | Public/private split already settled by action (Reading §9). |
| **Score JSON precedent** | Bindu Field · Score JSON `fldxIm6qUXLcdrRuR` | Per-track score (Drafted / Verified) | Model for the Mandala's own per-Śakti Score (2b) | — | — |
| Chakra dances | Bindu Field · Chakra `fld6pH3kGSqqop2Z7` (9 tracks: Muladhara "press — Iron" … Maya, Aatma) | Field's dances per chakra | A door from the constellation chakra into Field (C-1353: Field dances) | Deep link, not content | Field keeps the sound and dance. |
| Breath tracks | Bindu Field · Inhale/Hold/Exhale `fld4VA2ywm9DUIqdi` / `fldUp2aHSRomippvI` / `fldTJD0Om5bik6TjF` | Breath patterns per track | The Rite floor's 4-4-4 and the Coherence game | Optional bake | — |
| **Codex Source App unused** | Codex · Source App `fldaii08WVwJQA5qP` (choices include "Bindu Mandala" `selhkTEAbJE3DUuce`) | **0 rows carry any Source App value** | If the Mandala writes raw Codex entries (Feed precedent: Status unset), set it | Write (needs his ruling: the margin and letters are ledgered in App Activity today) | His notes are private. Write only what he asks to become Codex. |
| Gift / Summons window | Routines · Time of Day `fldudGv7KdO3qypPw` ("Breathing & Meditation" 9:30, "Sakshi Pause", "The Work Is Done" 21:30) | His real rhythm | Default for `EnergyGift`'s 10:00–20:00 window and the Summons hour | Read once at setup, or just inform the default | Optional. |

### 2g · Journals — feeding grace or the Portrait (read-only, private)

| item | table · field | holds (fill) | where | how | truth floor |
|---|---|---|---|---|---|
| Gratitude | Gratitude · "What are you grateful for today?" `fld85STU49AtREkfe`, "How do you feel right now?" `fldkghwcM38uld0d8`, Date `fldKnHj4PliSkfRFt` | 91 rows, Oct 2024 – Aug 2025 | Grace's rare "a year ago today you were grateful for…"; the Portrait's year beads for pre-app days | Read live (one GET by date) or skip | Names other people (Link to Relationships `fldQkIAPvnmjvZojw`). It is 14 months dormant, so a grace drawn from it would be an anniversary, never a nudge. Needs his yes. |
| Emotions / SJ / Anger | `tblM00KNko6U4XPIz` (66), `tbl30XBbgWZsvTT0D` (44), `tblKZIiUczlasfv9d` (9) | Shadow, CBT and anger journals; relational | **Not recommended.** | — | Surfacing a shadow row in a devotional room risks grading or wounding. The Relationship layer is out (Reading §5). Leave it. |
| Identity Energy and Emotion States | Identity rows (Rambo Angry, Ram Supreme, Joy, Fear…) | Named states | Not recommended | — | Same reason. |

---

## 3 · Data hygiene

Rule: **never delete; mark OLD** (rename to "OLD …"). Deleting is acceptable only in tables with too many fields, and the Mandala table at 53 fields is not one.

### 3a · Legacy fields and choices to mark OLD

The Mandala table still carries the pre-R17 event model: **0 rows use any of it**.

| Field | ID | Fill | Action |
|---|---|---|---|
| Type | `fldcPbTpARaSSAEY2` | 16 (all "Shakti", on the Karṣiṇīs). Description still says "Shakti = the 16 definition records". | OLD |
| Of Shakti | `fldaDjmaPvu57sJVg` | 0 | OLD |
| Meetings | `fldywdLZx6cbSi39p` | 0 | OLD |
| Felt At | `fldk4BdikzJQOautw` | 0 | OLD |
| Duration (sec) | `fldlBReoX5yvo1eY7` | 0 | OLD |
| Lunar Day | `fldpAiPlX9k7y7nqb` | 0. Description says "0–29 … daily Shakti assignment via mod 16". | OLD |
| Moon Phase | `fldFZcZ5AVcOWwo6X` | 0 | OLD |
| Source | `fld81a2h3WoaDn7pw` | 0 (choices Today/Mandala/Silence/Well) | OLD |
| Descent Ring | `fld225xgYl2Rs3TP6` | 0. Description claims it "backs the DescentState.crossings Airtable mirror", which is now App Activity. | OLD |
| Notes on Śakti rows | `fld1HR38cQAtEicFc` | 0 Śakti / 9 Āvaraṇa | Keep (the Āvaraṇa prose lives there) |

**Row Type** `fldw33m8YqrINlvrN` legacy choices with 0 rows: Recognition `selLVsL4CKyiNmZ2M`, Silence `selkQpEELkaAGIBJ4`, Offering `sel1zW1B0UFsbMqAA`, Letter `selvKjKzQd0f8vK6B`, Note `selOZMorzKDjsJRtB`, Comment `selwxDDQL9Tei8biU`, Insight `selasa0DPCWIU7A32`, Question `selZZTSs6UN8LTQij`, Crossing `selTidUBxpcjGbj7A`.
- Rename each to "OLD …". The app filters on `'Shakti'`, `'Avarana'` and `'Nitya'` only, so renames are safe.
- Fix the field description, which still calls Recognition/Silence/Offering "practice events".

**The Map:**
- **Pair Partner** `fld0peL6gvkB9JeRe` is already declared legacy. Its description says "values on 4 records only", but **10 are filled**. Mark it OLD and correct the description.
- **Linked Seed** `fldI9hph7iH18BQ3Y` has 0 rows. Leave it (the Feed seeds may still come).

### 3b · Inconsistent definitions

- **Lunar Day: two definitions.**
  - Mandala `fldpAiPlX9k7y7nqb` says "floor(moon_age) 0–29". It is legacy and empty.
  - App Activity `fldJc7iCzxZOSdO4D` says "1–30 (Mandala LunarPhaseService)". Its observed range is 3–30, with no zeros.
  - Since Wave 5 the value is the **true tithi** (elongation/12°), not the mean synodic day. Rows before 12 Oct are mean-day values, so the same instant can read one higher now (ActivityLedgerTests: 25 → 26).
  - Fix: update the App Activity description to say "true tithi 1–30 from 2026-10-12; mean synodic day before". Mark the Mandala field OLD.
  - Source: the app's own `Ephemeris.swift` (checked against USNO).
- **Ring 7 mudrā.**
  - Mandala Āvaraṇa 7 `fld1C14f4MsVIrA9F` = Sarva-Khecarī (the traditional seventh of the ten Mahāmudrās).
  - The Map `fldO14JGMU9cAYulu` = "Rahasya Mudra" on all 8 mind chakras. That is not among the ten; it reads as a coinage from "Rahasya Yoginī" (ring 8's yoginī class).
  - The Map's other mudrās agree with the rings (Kṣobha 1, Drāviṇī 2, Ākarṣaṇa 3, Vaśya 4, Unmādinī 5, Mahāṅkuśa 6, Bīja 8, Yoni 9).
  - Authority: the Mandala row and tradition. Correct The Map's 8 rows, or let Ashrey rule.
- **Count "105".** Āvaraṇa 8 Notes say "all 105 outer Shaktis". The table and the app hold 102, with 101 outside the point. Fix the prose.
- **Old spellings in Āvaraṇa Notes.**
  - Ring 4 still has Sarva-Sthambhini, Sarva-Onmadini and Jrimbhini.
  - Rings 5 and 6 carry unaccented forms.
  - The names were corrected on the rows in Wave 0; the Notes prose was not.
- **The Map field descriptions are stale.**
  - Avarana `fld5DcTBFS0Anwxrf`: "Only the 9 Tree of Life Panel chakras have explicit avaranas; others n/a". Since C-1343–45, 27 of 33 carry a ring.
  - Leela Story `flduxpB6EM5tFRxUe`: "present at ~7 of 33". All 33 are filled.
- **The Map gaps** (unchanged from Wave 3):
  - Ego Reveal has no Sanskrit (`fldUfO0k1sLhQZWnt`).
  - Avarana is "n/a" on 5 rows and "Bindu inverted" on Maya.
  - Crow's verb is RELEASE in the Map but CROW in the HTML (C-1345 unresolved).
  - Act 2 Voice is 10/33.
  - Panel Verb is 10/33.
- **Verb divergence** (Map Verb vs Panel Verb vs Identity declarations): Svādhiṣṭhāna FLOW/FOLLOW, Maṇipūra BURN/BUILD, Aatma KNOW/HOLD, Axis BLINK/ACCESS. Both registers are deliberate per the field description. Record the lens rule in the skill so nobody "fixes" it.
- **Two homes for a Śakti's description.** The Map's Shakti Name/Function/Practice (for seated chakras) parallel the Mandala row's Sanskrit Name/Function. The Mandala row is canonical (position is identity). The Map has no kp, so name variants exist (10 resolved by hand in the bake).
- **App Activity Gesture Source** is empty on 77/152 rows.
  - 66 are Feed and Learning rows, which is fine: the field is Mandala-scoped by its description.
  - **11 are Mandala rows** written before the field existed. Leave them; never back-fill a guess.

### 3c · Empty but needed, and whether an authoritative source exists

| Gap | Fill | Authoritative source? |
|---|---|---|
| Bīja, 66 Śaktis | 36/102 | **Partly.** The Navāvaraṇa pūjā gives bījas for the 10 Mudrās (kp 19–28). Verify against a lineage text (e.g. the *Śrī Vidyā Navāvaraṇa Pūjā* manuals, *Yoginīhṛdaya*). None is standard for the Siddhis, Anaṅgas, rings 4–6 or the Āyudhas: keep them empty (truth floor). |
| Phonetic | no column; 16 bundled | **Derivable** from the IAST name by rule. It is not authored content, so it is safe to generate offline and review by ear. |
| Somatic prompt (the question) | no column; 16 bundled | **No source.** It must be authored in his voice and reviewed. The Somatic Signature poem exists for all 102. |
| Recognition phrase (bundled 16) | outside Airtable | It exists in `ShaktiBootstrap.swift`. Copy it into Airtable so one home holds it. |
| Nityā mantra, colour, Devanāgarī | 0/15 | **Yes**: Tantrarāja Tantra / Nityāṣoḍaśikārṇava. Transcribe, do not compose. |
| Map: Ego Reveal Sanskrit; Act 2 Voice ×23 | missing | No external source. These are his walk's words, so they must be authored. |
| Codex Source App "Bindu Mandala" | 0 rows (no app writes Codex) | Not a data gap. It is unused until he rules that the Mandala writes Codex. |
| Seed verb ×102; Score JSON ×102; personal offering | no columns | Authored. No source exists. Create the columns only when he rules (schema add). |
| Activity Type and Gesture Source choices | 8 + 3 missing | The code is the source. Pre-create them to remove the typecast risk. |
