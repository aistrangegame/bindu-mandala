# The Data Ground Truth — Bindu Mandala, upgrade map (stage 2)

*World: the cross-cutting data. Written 13 Oct 2026 from the slice `waves/upgrade/index/by-world/data.jsonl` (995 rows, every row read), the register sections those rows cite (15 A.0 and C; 16 A.0–A.2, A.9, B, C; 17 A1), `waves/accounting/THE-ACCOUNTING-2026-10-12.md`, the two bake scripts, and a **live read-only check of the base on 13 Oct** (the full schema of Mandala and App Activity with descriptions; Śakti rows kp 19–48, 58, 59, 62, 99–102; the nine Āvaraṇa rows). Nothing in Airtable, the repo or any skill was changed. Ledger: `waves/upgrade/ledger/data.csv`.*

## 1 · The world

### What it is

The data world is not a place he walks. It is the ground every world stands on: the Airtable rows the app reads, the one ledger it writes, the bundles it carries, the files it keeps on the phone, and the laws that keep all of it true. His words for it are the floors he set and has not lifted: **practice data never lost; position is identity; App Activity is the single ledger; nothing invented — bījas and baked text verbatim; his journals and letters private; nothing scores him** (READER-BRIEF-2; FOUNDATION, 12 Oct). Design said it the same way: *"Sacred content flows from Airtable. The app never invents"* (04 HO1-07) and *"Every field is real, from the Airtable base… this is the data"* (04 CRD-01). The base itself says it in the description of `Khadgamala Position`: *"position is identity, names may be corrected."*

### How data moves, second by second

1. **Launch.** The bootstrap task (`Root/RootView.swift:111-124`) opens the SwiftData store (schema 3.0.0), seeds what is missing (today the 16 Karṣiṇīs; upgraded, all 126 rows from the dated export — B04), migrates, primes the summons and gift providers, then calls `AirtableService.sync`.
2. **Sync** (`Data/AirtableService.swift:123-169`): flush every pending queue first (never drops; `maxFailures = nil`) → restore margin notes from the ledger → fetch Mandala rows by `Row Type` (Śakti, Āvaraṇa, Nityā) → reconcile by kp (status only advances; a local letter draft is never overwritten; field connections seeded only when local is empty) → dedup ledgered letters and milestones → restore recognitions and descent if the phone is empty → restore the river. Refresh every 300 s; errors are silent; the local store is the read-time truth.
3. **Reading a world.** Every world reads by key: a Śakti by **kp 1–102**, a chakra room by **road 1–33** (Map Book Position) and its Map record id, the day by `DailyEnergyService` (06:00 boundary, SplitMix64 over 102). Room text comes from bundles (`ChakraConstellation.json`, `GameStructure.json`, the card bundle) baked verbatim from Airtable on a named date; tuning comes live (`Score JSON`, Bindu Field Scores).
4. **A gesture.** The local record is written **before any light moves** (two-phase write). Then one App Activity row is queued: Activity Type, Gesture Source, Link to Mandala (her row) and/or Link to The Map (the room), Felt At to the second (UTC), Lunar Day as the true tithi, Moon Phase, Duration where held. Dedup ±60 s. Only four fields of her own row are ever patched: Last Felt, Recognition Count, Status (advance-only), Letter.
5. **His words.** Notes go to App Activity `Notes` (his words only) or to Codex (`CodexWrite`, Source App "Bindu Mandala"). Letters live on her row's `Letter` field, private.
6. **Memory.** Every memory surface reads local ∪ ledger, so a new phone shows the same sky (L05).

### Visual language and sound

None of its own. It carries every world's tokens (Mandala/Map colours win) and one tuning (Design's ring roots, each room's fixed tone), plus his 44 recordings (A06).

### Building without opening another file

§2 is every element with its mechanism, numbers and code; §4 has every field id, choice, bake command, the snapshot spec, the vocabulary and the stores; the CSV is the checklist.

## 2 · Every element, placed

Codes: **D** Airtable ground · **C** corrections before building · **B** bakes · **S** snapshot · **L** local stores · **P** privacy · **R** topic register · **K** keys · **A** Scores and audio · **H** source hygiene. Status today: built / partial / not-built / wrong / n/a.

| # | Code | Element | What it does (mechanism + numbers) | Source (index ids · register refs) | Status today · code | Reuse / move / new |
|---|---|---|---|---|---|---|
| 1 | D01 | Base and table allow-list | One base app248ZTWhYJlvQj2. AirtableService may touch only: Mandala tblrRwXJD0uP8HU8G (read + record PATCH), The Map tblwpmyKOeMxEEHd7 (bake read), App Activity tblJlBeiHnqGpYrL7 (read + POST), Codex tblDF4OCMcRoxkQjU (POST), Gratitude tblEFiuFIijKe9ba6 (one column fld85STU49AtREkfe), Bindu Field tblv3WvMZ90Sfhun6 (read, room Scores), The Builds tbl5PR84YTy4anzAD (read, "made here"), Identity tbluLyZj9ilH2RhIg (bake only). Every other table id is refused by a test. HTTP topology: POST->App Activity, POST->Codex, record-addressed PATCH->Mandala (Last Felt, Recognition Count, Status, Letter) only. iOS 17+, local-first; 5-min refresh; silent errors; no third-party SDK. | G6-0784, G5-0554, G7-0881, G7-0882, G7-0883, G7-0937, G6-0724, G6-0655, G4-0297, G2-0026, G2-0105 · 16-airtable-asg.md:13-68,257-260; 17-code-core.md:43-110; 22-code-tests.md:33,487; 14-aistrangegame.md:150-152 | partial · `Data/AirtableService.swift:43-75; LawsTests.swift:901-1126; CoherenceTests.swift:106` | reuse + extend: add Bindu Field and Builds reads; AllowListTests (new) |
| 2 | D02 | Mandala table — Śakti rows (102) read contract | 57 fields; Śakti rows read by field id (full table §4.1): Sanskrit Name, Khadgamala Position, Devanagari, Quality, Quality Description, Cluster Group, Esoteric Tattva, Somatic Signature, Bodily Location, Bija, Field Connection, Status, Iconography, Personal Connection/Codex Portrait, Etymology, Appreciation Phrase, Function, Shakti Family, Last Felt, Recognition Count, Letter, Score JSON, Phonetic, Seed Verb, Related Shaktis (both directions), Of Avarana. Every one of the 102 carries Quality/Function/Etymology/Iconography live (Ruling 7 closed); Somatic prose and Phonetic still thin outside ring 2 — an empty field shows nothing, never an invented line; Design fallbacks ("Where do you feel her, right now?", "Of the {n} āvaraṇa — …") count as authored. Bootstrap task primes gift providers from quality / appreciation phrase / Function. | G2-0081, G2-0082, G2-0060, G2-0061, G1-0758, G2-0242, G2-0214, G2-0049, G1-0030, G2-0295, G2-0303, G2-0337, G2-0074, G2-0141, G2-0202, G2-0458, G2-0380, G1-0565, G1-0595, G1-0052, G1-0421, G1-0560, G1-0680, G2-0223, G1-0472, G7-0007 · 17-code-core.md:53-70; 04-briefs-audits-frames.md:152-176,318,384,482,622,743; 02-rite-axis-field.md:507-519,1337-1408; live schema 13 Oct | built · `Data/AirtableService.swift:270-296,365-489; Root/RootView.swift:111-124` | reuse; read Function/Iconography/Somatic live for all 102 |
| 3 | D03 | Mandala table — Āvaraṇa rows (9) read contract | Row Type Avarana sel85dIY4D0v5GA9s; record ids ring 1 rec0XhDKfxW8UVyaB, 2 recspOpR95DVcOEvn, 3 recp4X5tuGdLuHCVw, 4 reck0o3CUIpc1Fc3p, 5 recXWmYtaMBafQTg0, 6 recAoU8p9NZHlqVBA, 7 recpHi1ydFrb3bLH6, 8 rec3sxt1ZQ3T036sZ, 9 recqdC3D38TWFkf1M. Fields: Avarana Name (app "subtitle"), Number, Gem, Dhatu, Time Cycle, Avarana Beeja, Goddess Body Region, Siddhi, Mudra of Avarana, Phase, Notes, Presiding Form, Mental State, Subtle Body Chakra, Geometric Shape, Yogini, Personal Connection. Read live into ringFacts.v1, never typed in Swift. Counts 28·16·8·14·10·10·12·3·1 (Ring 7 = 8 Vāsinīs + 4 Weapons = 12, Vāk Ring/Chamber one name). Design ring-world constants (fog, veil, tempo) are bundled verbatim; the base wins every name/state. | G1-0059, G1-0060, G1-0061, G1-0062, G2-0230, G2-0237, G1-0041, G2-0217, G1-0537, G1-0563, G1-0035, G2-0268, G1-0099, G2-0083, G6-0944, G6-0945, G1-0623, G2-0447, G2-0246 · 17-code-core.md:71-84; 01-homes.md:116-127,165-176,273-285; 02-rite-axis-field.md:1123-1137,1360-1391; 04-briefs-audits-frames.md:154,343,361,374,390,732 | partial · `Data/RingFactsCache.swift:19-48; Models/Avarana.swift:36` | reuse cache; move ring data out of Swift literals |
| 4 | D04 | Mandala table — Nityā rows (15) read contract | Row Type Nitya sel8SjwYfUrQT3ToS; tithi = Number fldVWZLCy5YFJMkCp 1–15 (16 = Lalitā = ring 9). Quality, Bija, dhyāna read live ("DO NOT INVENT THESE FIELDS"). Tithi names Pratipadā…Pūrṇimā and the 27 nakṣatras are ephemeris constants. | G1-0066, G1-0566, G7-0129, G1-0750 · 01-homes.md:189; 02-rite-axis-field.md:1412-1432; 03-mandala-worlds-layers.md:748; 19-code-mandala-today.md:433 | partial · `Models/NityaDevi.swift; Today/NityaDetailView.swift` | reuse; add Quality/Bija reads (new) |
| 5 | D05 | Mandala writes — record PATCH on her row | Only four fields are ever written on a Śakti row: Last Felt, Recognition Count (from use only), Status (Mapped→Exploring 1st, Active 3rd, Embodied 7th; advance-only), Letter (autosave 5 s, offline queue). Two-phase recognition: local RecognitionEntry at ceremony appear, Airtable at close; "I feel her" works with no network; local record written before any light moves. No count shown. | G2-0100, G2-0102, G2-0314, G2-0027, G2-0324, G7-0134 · 04-briefs-audits-frames.md:83,171,173,511,522; 17-code-core.md:95-103; 19-code-mandala-today.md:450 | built · `Data/AirtableService.swift:894-944,1069-1104,1248-1363` | reuse |
| 6 | D06 | App Activity — the single ledger (28 fields) | tblJlBeiHnqGpYrL7, Source App = Mandala (selQFXyea7YUZo4jN). Field ids §4.1. Felt At UTC to the second; Lunar Day = true tithi 1–30 from 12 Oct; dedup ±60 s on [Source App, Activity Type, Felt At]; queue never drops (maxFailures nil); restore oldest first, twins folded; Mandala-table event rows stay at zero; HomeMemory phone-only; "Deepest Ring Reached" dropped as duplicate. 160 rows today (Mandala 89: Recognized 60, Silence 18, Ring Crossed 6, Letter 3, Siddhi 1, First Dwelling 1). Client Write Id to be set on every POST. | G2-0347, G2-0348, G2-0199, G2-0203, G2-0215, G6-0650, G7-0658, G7-0659, G2-0313, G2-0343, G2-0323, G2-0381, G2-0440, G2-0084, G7-0661, G7-0024 · 16-airtable-asg.md:132,247-251; 17-code-core.md:111-157; 22-code-tests.md:132-139; 04-briefs-audits-frames.md:315,319,336,509-566; live schema 13 Oct | built · `Data/ActivityLedger.swift:31-73; Data/AirtableService.swift:1385-1403,2047-2050,2157-2222` | reuse; add Client Write Id; Link to The Map on room events |
| 7 | D07 | App Activity vocabulary for every world | One list, LedgerIsTheRecord.eventVocabulary, is the only place a type may be added. 22 kept + Share With (already an Airtable choice, never written) + 8 new (§4.3): Gate Opened, Wake-Up Sounded, Dance Completed, Word Offered, Reveal Received, Leela Landed, Breath Completed, Threshold Crossed. Each row: Activity Type + Gesture Source + Link to Mandala (kp) and/or Link to The Map (chakra) + Felt At + Lunar Day + Moon Phase; Notes only his words; no counts in any name or detail. Corpus pool kinds (welcome-*, chakra-stage, leela-*, bindu-dance-completed, gaia-reveal-received, field Ceremony Sealed) map onto these. | G7-0616, G3-0287, G4-0292, G4-0176, G4-0334, G3-0154, G2-0371, G7-0285, G7-0307, G7-0142, G7-0337, G5-0118, G2-0914, G7-0089, G7-0322, G7-0854, G7-0855, G7-0856, G7-0857, G7-0858, G7-0859, G7-0860, G7-0861, G7-0862, G7-0863, G4-0387 · 17-code-core.md:132-157; 06-chakra-skills.md:721,2125-2137; 08-dances.md:876,1287-1293; 09-field-scores.md:170,426-430; 20-code-play-rooms.md:137-139,271-273,357,396; 12-padakarshini-field.md:412-414 | partial · `Data/ActivityLedger.swift:79-166; Data/ActivityLedgerRites.swift` | reuse 22 + 9 builders |
| 8 | D08 | The Map — 58 fields, the 33 chakras | tblwpmyKOeMxEEHd7, 33 records. The bundle carries 37 fields; 21 absent (~175,000 ch of energy: Teaching Text 79k, Post-Engagement Teaching 47k, Shakti Function 24k, Tree Caption 7k, Dyad Description 4k, Story Portal Headline, Panel Verb, Panel Seed, Color Dyad, Mind Triad, Tree, Threshold Architecture, Linked Builds, URL, Build Status). Never baked: Gaia Voice and Shakti Practice (author substrate), room 32 beyond its public cells (sealed). Sanskrit empty only on 32. URL: web practice pages exist for squares 1–20 only. Build Status: 10 body rooms + Armin In Progress, 22 Live. Linked Seed and Gaia link empty. The Map is the canonical chakra store (C-1343/1344, AI-written records). | G6-0644, G5-0277, G3-0003, G3-0509, G3-0510, G6-0490, G6-0493, G6-0482, G6-0481, G6-0484, G6-0483, G3-0004, G2-0479, G2-0592, G6-0623, G4-0152 · 15-airtable-map.md:21-115; 16-airtable-asg.md:120; 12-padakarshini-field.md:732; 06-chakra-skills.md:138; 07-codex.md:950-958 | partial · `Data/ChakraConstellation.json (44 keys)` | re-bake with 15 energy fields (B01) |
| 9 | D09 | The 33 identity rows (walk-canon v1.0 = Map) | Per room: name, subtitle, Devanāgarī, verb, Color Hex, voice, system, tree, activation, gate type, bīja wake-up, awakening tone (P1 174, P2 210, P3 320, P4 341, P5 384, P6 426, P7 480, P8 528 Hz, P9 silence), Map record id (room 1 recKAQWX7yUIB3ktW … 33 rec3O90Mtasuh5qI7). Map, walk-canon and bundle byte-equal; the Map wins every variant (verbs FLOW/BURN/KNOW; hexes; Shakti lists; ToL list Bindu 1 · Shadow 9 · Armin 20 · Maya 30 · Aatma 31 · Ego Reveal 32 · Lalita 33). Two Kāmeśvarīs kept distinct (88 vs 99). Voice letter labels and Trinity of Guidance faces read from one voice record. | G2-0551, G2-0552, G2-0553, G2-0554, G2-0555, G2-0556, G2-0557, G2-0558, G2-0559, G2-0560, G2-0561, G2-0562, G2-0563, G2-0564, G2-0565, G2-0566, G2-0567, G2-0568, G2-0569, G2-0570, G2-0571, G2-0572, G2-0573, G2-0574, G2-0575, G2-0576, G2-0577, G2-0578, G2-0579, G2-0580, G2-0581, G2-0582, G2-0583, G2-0584, G2-0933, G3-0317, G5-0283, G5-0284, G5-0285, G3-0243, G6-0621, G5-0286, G5-0089, G5-0566, G5-0579, G5-0581, G5-0582, G5-0621, G5-0624, G5-0618, G5-0654, G5-0667, G5-0668, G3-0320, G6-0620 · 05-chakra-corpus.md:389-428,3387; 15-airtable-map.md:23,1467,1537-1546; 06-chakra-skills.md:1860,2588,2607; 12-padakarshini-field.md:743-772,986-989; 14-aistrangegame.md:223-314,540-594,756-863 | built · `Data/ChakraConstellation.json` | reuse; re-verify after re-bake |
| 10 | D10 | Codex — write only (his note, not an event) | Title fldxmZqObGiIoHHll (clip 80 ch, fallback "A word from the Mandala"), Date fldth1fgVdc2HgIyn, RAW fld459YeVBZBgB8zh, Source App fldaii08WVwJQA5qP = "Bindu Mandala" selhkTEAbJE3DUuce; Status never written; dedup by day + normalised body. Never read at runtime (raw memos private); 352 records read once for design; AI-written records C-1338…C-1355 are records, not his voice. One-button voice capture → Codex is the gift (C-1099, C-1206). | G3-0326, G3-0338, G3-0364, G3-0419, G3-0525, G3-0539, G3-0540, G3-0526, G3-0506, G6-0632 · 17-code-core.md:169-172; 07-codex.md:1-15,95-98,225-228,500-503,935-958,1032-1179,1335-1352,1386 | built · `Data/CodexWrite.swift:17-129` | reuse |
| 11 | D11 | Gratitude — one column, gently | Reads only fld85STU49AtREkfe; speaks on about one eligible day in 3; line capped at 220 ch; room-matched to today's Śakti; never counted. | G6-0634 · 16-airtable-asg.md:94,259,305 | built · `Services/GratitudeGrace.swift:27-74` | reuse |
| 12 | D12 | Bindu Field catalog (sister) — room songs and Scores | 60 rows; read Score JSON (46 filled, all Drafted), Score Status [Unscored·Drafted·Verified], Audio URL, Audio Data URL (0 filled), Carrier Hz, Beat Hz, Seed Phrase, Element, Chakra, Phase Labels, breath counts. Room↔Track: 2=Track 23 recNK3tCuTLE5Rz6P, 3=24 recegUJduJtuhYiOQ, 4=25 recRIm8zafWgFqaWK, 5=26 rec4qQlcaQn4UbQbC, 6=27 recBOIwQ8lA5kXq0K, 7=28 rec3TqcK3UNBbqIxz, 8=29 reco0eTHN2z04pMkC, 31=30 recY83LPPQAA6B2Ns, 30=31 recqdWGGUFiux2KVe, 9=35 recuAkqFs86MWSevH. Only Drafted+ plays; no Score assigns Hz to a Śakti; resonance_link stays false until he decides. | G4-0309, G4-0310, G4-0596, G4-0597, G4-0598, G4-0599, G4-0600, G4-0347, G4-0348, G4-0343, G4-0346, G4-0611, G4-0590, G4-0580, G4-0449, G4-0336, G4-0635 · 09-field-scores.md:74-109,172,206-221,594-612,702; 10-field-data-catalog.md:267-394,436-439,550 | not-built · `none` | new reader; join ids baked in B01 |
| 13 | D13 | The Builds — "made here" (read-only) | 340 rows; Chakra→The Map on 108; read Title, Type (20 kinds), Chakra, URL, Voice, Build Status; 131 Bindu Dance rows; 9 Awakening Sound rows. Links point to the Map only, never to Śaktis. | G6-0645, G6-0686, G6-0774 · 16-airtable-asg.md:122,196-200,340; 08-dances.md:697 | not-built · `none` | new read-only reader |
| 14 | D14 | ASG journal and catalogue tables — never read | Daily, Monthly, Year, Activity, Goals, To-Do, Emotions, Anger, SJ, Health, Neev, Nutrition, Books, Calendar, Fitness, Gaia, Identity (bake only): schema and counts only. Daily Witness Line ("Generated") and Field-% (computed) conflict with floors and are never read; Walks belongs to Lalita Family (no person link, ever). | G6-0625, G6-0626, G6-0627, G6-0628, G6-0629, G6-0630, G6-0631, G6-0635, G6-0636, G6-0638, G6-0639, G6-0640, G6-0643, G6-0685 · 16-airtable-asg.md:76-118,192-194,253-255 | built · `allow-list (D01)` | reuse floor; test refuses ids |
| 15 | D15 | Relationship data — the three connections only (ruling 11) | Field Connection on kp 31 (Gaia·Ahaṅkāra), kp 40 (Ashrey·Nāma), kp 42 (Ram·Ātmā), notes in his voice; seeded only when local is empty. Design's other people and second carried Śaktis are Design lines shown as authored, with no Airtable backing and no synthetic encounter counts; Design indices are ring-2 local 0–15 → kp = 29 + i. No new Airtable fields; Relationships/Timeline/Special Days stay unread (person table has no Śakti link). | G1-0561, G1-0738, G1-0760, G6-0654, G6-0661, G7-0595, G6-0641, G6-0656, G6-0768, G6-0776, G6-0777, G6-0778 · 02-rite-axis-field.md:1354; 03-mandala-worlds-layers.md:687,814-823; 16-airtable-asg.md:70,112,140-152,333-344; 21-code-layers.md:171 | partial · `Data/ShaktiBootstrap.swift:59-60,205-206,239-240` | reuse; map Design indices to kp |
| 16 | C01 | Etymology old spellings kp 58, 59, 62 | kp 58 recD8hZhpyOoXWS68 "Sarva + Sthambhinī …" → Stambhinī; kp 59 recXaybSBwdlsBIT7 "…Counterpart to Sthambhinī." → Stambhinī; kp 62 recF2oZhbPZ8QOdsS "Sarva + Onmādinī (the intoxicator)…" → Unmādinī. | live read 13 Oct (no slice row) · THE-ACCOUNTING-2026-10-12.md:19; live read 13 Oct | wrong · `Airtable fldXypzqrhVILCqgh` | Airtable cell edit ×3 |
| 17 | C02 | Function old spelling kp 59 | kp 59 Function "Counterpart to Sthambhinī — Her expansion balances Sthambhinī's stillness." → Stambhinī ×2. | live read 13 Oct (no slice row) · THE-ACCOUNTING-2026-10-12.md:19; live read 13 Oct | wrong · `Airtable fldzT3dAhsAK75rKN` | Airtable cell edit |
| 18 | C03 | Ring 5's Mudra of Avarana | recXWmYtaMBafQTg0 "Sarva-Onmadini Mudra (All-Intoxicating)" → "Sarva-Unmādinī Mudrā (All-Intoxicating)" (matches kp 23). The other eight take the same IAST names (ring 7 = Khecarī, settled). | live read 13 Oct (no slice row) · THE-ACCOUNTING-2026-10-12.md:19; live read 13 Oct | wrong · `Airtable fld1C14f4MsVIrA9F` | Airtable cell edit ×9 |
| 19 | C04 | Avarana Names unaccented | Avarana Name fldXTUBJTDlkKEzEV is ASCII on 9 Āvaraṇa rows and 102 Śakti rows ("Sarvasaparipuraka", "Sarvasaubhagyadayaka"…) while Sanskrit Name carries IAST; the app shows it as the ring subtitle. Set each to its Āvaraṇa's Sanskrit Name minus " Chakra". | live read 13 Oct (no slice row) · THE-ACCOUNTING-2026-10-12.md:19; live read 13 Oct | wrong · `Airtable fldXTUBJTDlkKEzEV` | Airtable batch edit ×111 |
| 20 | C05 | Ring 1 Mudrā names copied from Ring 4 — in Design/app data only | Airtable is right (kp 19 Sarva-Saṅkṣobhiṇī … 27 Sarva-Yoni, 28 Sarva-Trikhaṇḍā, verified 13 Oct). The copy lives in Design all-shaktis-data.js (19–28 = Ring 4's first ten) and every bundle built from it (Axis roster, R1_QUALITY 19–28, H-table appName, Ring 2 empty there). No bundled name, quality or room key for kp 1–102 comes from that file; names come from the Mandala row by kp. 61-name drift resolved by option 3 (position is identity). | G1-0564, G1-0425, G1-0246, G1-0012, G2-0249, G1-0064, G2-0213, G2-0243, G1-0068, G2-0328, G2-0290, G2-0459, G2-0307, G1-0013, G1-0334, G1-0036, G2-0189, G1-0714, G5-0482, G2-0245 · 01-homes.md:7,23-24,102,164,188,201,482-509,813-814; 02-rite-axis-field.md:88,1406; 03-mandala-worlds-layers.md:557; 04-briefs-audits-frames.md:299-300,334,385-387,398,452-458,492,531,744; 13-rupakarshini.md:557 | wrong · `Design all-shaktis-data.js; GateRoomTests (61 drifted)` | bake names from Mandala by kp; test |
| 21 | C06 | Kriyā/Jñāna swap in Ring 8 | Airtable: kp 99 Kāmeśvarī Aim Icchā; kp 100 Vajreśī Klim Kriyā ("Where will becomes deed"); kp 101 Bhagamālinī Sauh Jñāna ("Where knowing becomes seen-form"). The app roster (801–803) swaps Kriyā/Jñāna. Every app/bundle label follows the base. | G1-0065, G2-0247 · 01-homes.md:188; 04-briefs-audits-frames.md:391; live read 13 Oct | wrong · `app roster 801–803` | fix labels; test |
| 22 | C07 | The 16 Karṣiṇī bīja series shifted by "kaṁ" | Airtable: 29 aṁ 30 āṁ 31 iṁ 32 īṁ 33 uṁ 34 ūṁ 35 ṛṁ 36 ṝṁ 37 ḷṁ 38 ḹṁ 39 eṁ 40 aiṁ 41 oṁ 42 auṁ 43 "aṁ — anusvāra" 44 "aḥ — visarga". ShaktiBootstrap (from Design shakti-data.js) seeds 37 lṁ, 38 eṁ (ḹṁ skipped), … 44 kaṁ — not one of the sixteen vowels — shown before first sync and whenever sync is off. Fix to the Airtable series; footer syllable-only. | G6-0926, G1-0536, G2-0446, G2-0244, G2-0010, G1-0285, G2-0042, G7-0677, G7-0510, G2-0338 · 17-code-core.md:200,816; 02-rite-axis-field.md:1118-1121; 01-homes.md:660; 04-briefs-audits-frames.md:61,98,386,548,731; 22-code-tests.md:184; 21-code-layers.md:21; live read 13 Oct | wrong · `Data/ShaktiBootstrap.swift:151-267` | fix bootstrap; BijaSeriesTests (new) |
| 23 | C08 | Maya's line → "only You, playing" (ruling 8) | Map Maya recMyqKSqwRnimgvy: Signature Phrase flddjDTJBa0o4KyLS and Panel Seed Message fldwFamC9FndA94if "There was never anything to fear. There was only the Bindu, playing." → "…There was only You, playing." Then re-bake GameStructure.json:77 (ring 9 seed) and ChakraConstellation.json:1478. Bindu Reflection ("…Someone, playing.", :1488) is story → Feed. | G6-0619, G6-0925 · 15-airtable-map.md:1532-1535; 17-code-core.md:217,268,810 | wrong · `Data/GameStructure.json:77; Data/ChakraConstellation.json:1478` | Airtable 2 cells → re-bake B01 + B02 |
| 24 | C09 | Seed Verb description | fldVgkRZmbc7STB7S reads "Written by Ashrey; empty until he writes it." His Wave 6 decision 10: "drafted by Claude, approved by you, marked draft until accepted". New description says so; the 102 drafts (waves/wave-6/seed-verbs-draft.md) stay out of the cells until accepted. | live read 13 Oct (no slice row) · live schema 13 Oct; WAVE-6-GAMEPLAN.md:176 | wrong · `Airtable description` | description edit |
| 25 | C10 | Karṣiṇī Function note — "drafted by Claude" (ruling 7) | Function on kp 29–44 is text Claude composed, shown as hers. Ruling 7: they stay. Field description gains "kp 29–44: drafted by Claude (12 Oct 2026), kept by Ashrey's ruling 7." No cell change. | live read 13 Oct (no slice row) · THE-ACCOUNTING-2026-10-12.md:19 | wrong · `Airtable description` | description edit |
| 26 | C11 | App Activity choices missing | Live Activity Type has 22 choices; 13 kinds the app writes are not pre-created (Full Circle, Note Left, State Set Down, Letter Opened, Portrait Drawn, Witness Written, Garland Recited, Day Offered, Leela Drop, Light Entered, Chakra Practiced, Light Sent Back, Name Kept) and rely on typecast. Pre-create those 13 + 8 new kinds (21). Gesture Source has Today·Mandala·Well·Silence·Play; the app already sends Room and Field — pre-create Room, Field, Climb, Chakra, Presence, Beneath, Bindu, Relationship. Never delete a choice. | live read 13 Oct (no slice row) · 16-airtable-asg.md:132,249,337; THE-ACCOUNTING:19; 17-code-core.md:96,106; live schema 13 Oct | partial · `AirtableService typecast 1624-1626` | schema choice add |
| 27 | C12 | Elements per ruling 4, with a light case | Ruling 4: kp 31 fire, 40 air, 42 light, 43 water. Live tattva: 29 Pṛthivī, 30 Ap, 31 Tejas, 32 Vāyu, 33 Ākāśa; 34–44 the cross-mapped organ (Śrotra … Manas) → a parse gives ether. Element = kp table: 29 earth 30 water 31 fire 32 air 33 ether (base) · 34 fire 35 water 36 earth 37 ether 38 earth 39 water 41 fire 44 earth (Design RING2 grammar) · 40 air 42 light 43 water (ruling). Element.swift gains .light for ring 2; ring 9 stays light. Tattva text untouched. Re-pin CrossingRoomTests, RecognitionNature (light → radiate, water → pool, fire → flare, air → disperse), Rite archetype, sound carrier. | G1-0463, G1-0464, G1-0588, G7-0686, G7-1029, G1-0534 · 02-rite-axis-field.md:407-440,1096-1121,1580; 22-code-tests.md:218,642; live read 13 Oct | wrong · `Theme/Element.swift; ElementTests.swift:21` | kp table in code (new) |
| 28 | C13 | Map field-name swaps | Eleven Map fields carry a different walk-canon key (Act 1 Voice=story_thread, Bindu Reflection=after_story, Act 2 Voice=interlude, Story Thread=leela_story, Leela Story=gate_text, Gate Text=gate_interaction, Post-Engagement Teaching=bindu_reflection, Three Ways In=go_deeper, Hero Threshold=seed_message, Story Portal Headline=threshold_hint, Shakti Practice=app_build_note). The Map's names govern; no rename. Each description gains "walk-canon key: …"; bake_walk_canon.py and all quotes use the Map names. | G6-0610 · 15-airtable-map.md:24-29,1447-1465 | wrong · `bake_walk_canon.py keys` | description edit ×11; bake key rename |
| 29 | C14 | Map's empty App Activity link | The Map App Activity fldxl5Ez0Btgi8uoR (inverse of Link to The Map fldkF65ySNGGkeugH) is empty on all 33 and Link to The Map is 0/160, though ActivityLedger writes it on Chakra Practiced: no room-born event has reached Airtable yet. Every room-born event sets Link to The Map by the room's Map record id; one live read after his first walk proves the inverse fills. | G6-0485 · 15-airtable-map.md:114,1548-1551; 16-airtable-asg.md:250,337 | wrong · `Data/ActivityLedger.swift:446-469` | write link; verify |
| 30 | C15 | Map content flags and code exclusions | Innocence "arrives … from Armin" vs Road; Axis Leela Story/portal describe the spine-line; Crow 2nd person; Vision mirror → Manipura (ruling 14); Shadow Act 2 is a stage direction — excluded from voice layers in code; old skills' "32 = Axis Recognized" text is contamination, never used. | G3-0153 · 15-airtable-map.md:1472-1516; 06-chakra-skills.md:709-720 | partial · `Views/Chakra/ChakraRoomView.swift` | code exclusion; Airtable his call |
| 31 | C16 | Bootstrap seeds no progress, no wrong tattva | ShaktiBootstrap seeds statuses (embodied, active …) and tattvas Space/Space/Pure Being/Nectar for kp 31/40/42/43. Seed Mapped with no history, tattva = the base cell; TODAY_INDEX/PROGRESS never ported. | G1-0481, G1-0562 · 17-code-core.md:199-201; 02-rite-axis-field.md:632,1357 | wrong · `Data/ShaktiBootstrap.swift` | fix seed |
| 32 | C17 | OLD, never deleted | Mandala OLD fields (OLD Type, Of Shakti, Meetings, Felt At, Duration, Lunar Day, Moon Phase, Source, Descent Ring) and Map OLD Pair Partner stay, marked OLD; nothing reads them. US/UK spelling drift between card files: the Airtable cell is the verbatim source. | G6-0486, G1-0053 · live schema 13 Oct; 15-airtable-map.md:82,1491; 01-homes.md:155 | built · `none read` | reuse; test no OLD id in Swift |
| 33 | C18 | Sahasrāra / Integration bake joins with empty kp | Room 8 joins ring 2 (Tripureśī) and room 29 ring 7 (Tripura Siddhāmbā) with kp [] — so ring 2's Sandhyā shows as Sahasrāra's game door. Keep the ring join; the game door of a kp-less room is the ring's point. | G7-0482 · 20-code-play-rooms.md:723; bake_chakra_constellation.py JOIN 8, 29 | wrong · `Data/ChakraConstellation.json` | door rule |
| 34 | C19 | Sister-table defects the Mandala must not inherit | Bindu Field: polluted selects; breath counts wrong (rest 4/2/12 vs 4:7:8; expand 5/5/5 vs 8:4:8; balance 5/0/5 vs 5:5:5:5; open 4/2/6 vs 4:0:8); ember-data = still-ajna (md5 d8895b4a); P constant 1.0 in 46/49; BPM artefacts 172.3/152; Aatma 98 vs 130.8, Kingdom 110 vs 146.8; still-ajna stem ≠ id; V1 bindu-dances-still carries Faded's data. The Mandala reads only Score JSON with Status ≥ Drafted and its own room tone; never P or BPM; breath reads the technique spec. | G4-0629, G4-0601, G4-0508, G4-0494, G4-0630, G4-0496, G4-0503, G4-0504, G4-0506, G4-0204 · 10-field-data-catalog.md:19,35-37,527-547; 09-field-scores.md:774-802; 08-dances.md:912,1283 | wrong · `Bindu Field base` | read guard; fixes belong to Bindu Field |
| 35 | B01 | ChakraConstellation.json — regenerate | waves/wave-3/bake_chakra_constellation.py MAP.json OUT.json joins The Map to kp through its JOIN table (one line per room quoting the Map text it rests on). Today 33 × 44 keys, 327,662 B, md5 70211e07, bakedOn 2026-10-12. Upgrade: + Teaching Text, Post-Engagement Teaching, Shakti Function, Tree, Tree Caption, Dyad Description, Color Dyad, Mind Triad, Story Portal Headline, Panel Verb, Panel Seed Message, Threshold Architecture, URL, Build Status, Linked Builds + Bindu Field record id per room (59 keys); room 32 content and substrate never; assert roads 1..33, kp 1..102, refuse to bake on an empty required field ("CANON INCOMPLETE"). | G7-0492, G6-0494, G2-0924, G3-0265 · 17-code-core.md:225-268; 15-airtable-map.md:23; 05-chakra-corpus.md:3236-3239; 06-chakra-skills.md:1971-1976; 20-code-play-rooms.md:802 | partial · `bake_chakra_constellation.py; Data/ChakraConstellation.json` | move script to repo tools/; extend |
| 36 | B02 | GameStructure.json — regenerate | waves/wave-6/bake_game_structure.py OUT.json [--verify]: every line verbatim from Identity (Name flddQh6Ci7lpY1Ist, Declaration fldry3UX62Eedqb9F) and the Map (Leela Story, Panel Seed, Panel Verb), filed by record + field id; --verify proves each line a substring of its live row. 211 lines, md5 6e37a350: panels 1–9, axis block (verb "Access", never decoded), faces ×5, practices ×4, leelaDrops ×8. Upgrade: ring 9 seed after C08; axis block decoded or dropped; --verify in CI. | G6-0936 · 17-code-core.md:203-223,850 | partial · `bake_game_structure.py; Data/GameStructure.json` | reuse; CI --verify (new) |
| 37 | B03 | Her card bundle (generated, never hand-typed) | From the Mandala export by kp 1–102 (name, Devanāgarī, quality, tattva, location, etymology roots, phrase, family, cluster) plus Design constants carried verbatim: CROSSED 34–44, R1_FAMILY (≤10 siddhi, ≤18 mātṛkā, else mudrā), R2_CLUSTER (29–31 · 32–36 · 37 · 38–41 · 42–44), ATTR_TINT 15 tints, RING_START {1:1,2:29,3:45,4:53,5:67,6:77,7:87,8:99,9:102}, KIN 52→26, riteRoots morphemes, bodyAltitude (feet .94 … crown .10), RITE_WORLDS alt/hue/sat/wallHue, SY_RING_R 306·268·224·178·145·116·88·52·0, LR palette and cluster hues, lrNameSize 60/56/48/42/37. Function/Somatic/Iconography come live (D02). | G1-0016, G2-0251, G1-0022, G1-0054, G1-0055, G7-0571, G1-0056, G1-0461, G1-0275, G1-0082, G7-0316, G1-0058, G1-0418, G1-0500, G1-0559, G1-0462, G1-0533 · 01-homes.md:30-44,153-161,228,627; 02-rite-axis-field.md:35-47,363-405,789-791,1091-1094,1326-1335; 21-code-layers.md:70; 20-code-play-rooms.md:337 | partial · `Homes/*; Views/Rooms/RiteOfEntering.swift; GarimaSceneKitRoom.swift:414-418` | new generator + bundle |
| 38 | B04 | Offline seed of all 126 rows | Today SYNC_OFF/first launch seeds only the 16 Karṣiṇīs and CI without a PAT sees 16 of 102 (HomesCorpus adds 86 synthetic rows). Seed all 102 + 9 + 15 from the dated export so first launch, offline launch and tests show the whole yantra; Airtable overwrites on sync; nothing the export lacks is filled. | G7-1026, G7-0619, G7-0626 · 17-code-core.md:192-201; 22-code-tests.md:36,47,639 | partial · `Data/ShaktiBootstrap.swift:278-302; ci_scripts/ci_post_clone.sh` | replace seed source with S01 |
| 39 | B05 | Verbatim check of every bake against its export date | Every string in ChakraConstellation.json, GameStructure.json, the card bundle and the seed equals its cell in the export named by bakedOn; bīja Type-1 kept whole, Type-2 cut before " — "; empty never filled; the unverified spike fixture line ("Thank you for the weight that holds me here.") is checked before any lift. | G7-0870, G7-0871, G7-0872, G7-0873, G7-0874, G7-0875, G7-0876, G7-0877, G7-0878, G7-0879, G7-0880, G7-0719, G7-0568 · 22-code-tests.md:184,337-340,486; 21-code-layers.md:69 | partial · `ShaktiBijaTests, SomaticRegionTests, ChakraRoomTests, GameStructureTests` | reuse + extend |
| 40 | B06 | Walk canon laws carried by the bake | author_substrate_never_surfaced_verbatim (Gaia Voice, Shakti Practice), quarantined_fields (OLD Pair Partner), dance_inherits_bindu_song, reveal_held_in_build. Not ported: Design shell tweaks and Tweaks panel, debug API window.__bindu, canon-adapter "Day 19" greeting (a count about him), window.claude.complete calls (no generated voice), chakra-data.js 7-chakra quiz data. | G2-0915, G2-0858, G2-0489, G2-0862, G2-0847 · 05-chakra-corpus.md:10,56,59,2749,2836-2872,3176-3185 | built · `bake ROOM_FIELDS` | reuse |
| 41 | S01 | Dated read-only test snapshot of Mandala + Map | tools/snapshot.py (new; GET only; PAT from env, never printed) writes iOS/Bindu MandalaTests/Snapshot/2026-10-13/: mandala.json (126 rows; Letter, Last Felt, Recognition Count emptied, Status = Mapped), map.json (33 rows; room 32 beyond public cells, Gaia Voice, Shakti Practice as length stubs), bindu-field.json (60 rows, 9 fields), manifest.json (taken-at UTC, ids, counts 126/33/60, sha256 per file, corrections applied yes/no). Taken before the C-edits (their before-image) and again after (the test truth). Launch arg SNAPSHOT=2026-10-13 → SnapshotSource replaces live reads; writes go to an in-memory MockLedger, never a live POST/PATCH. Read-only evidence law: never delete or reinstall on the phone. | G5-0303, G2-0309, G2-0373 · 22-code-tests.md:47,535,639; 12-padakarshini-field.md:857,875,975; 04-briefs-audits-frames.md:499,610 | not-built · `none (UI tests see 16 rows)` | new |
| 42 | L01 | SwiftData schema — V3 now, any new model V4+ | V1 (6 models, letters 1–16) → V2 (+HomeMemory, letters by kp, fsync'd sidecar, quarantine keys 1000+) → V3 (+MarginNote); latest 3.0.0. Models: Shakti, Avarana, NityaDevi, RecognitionEntry (kp + ring; legacy ring-2 position 5 → kp 33; invalid left at 0), ShaktiLetter (kp; V1 n → n+28 byte-identical), DescentState (new deepest only, floor 2), HomeMemory (phone-only; silence ≥62 s, first dwelling 227 s, Full Circle at 102), MarginNote. "Add a version; never mutate a shipped one." Lifetime storage; corrupt store set aside (two newest), never deleted. | G6-0787, G7-0662, G7-0663, G7-0665, G7-0666, G7-0667, G7-0668, G1-0576, G2-0144, G7-0660, G1-0600, G2-0051, G2-0332, G2-0064, G2-0379, G1-0531 · 17-code-core.md:163-177; 22-code-tests.md:138-146; 04-briefs-audits-frames.md:112,125,237,535-536,621; 02-rite-axis-field.md:1035-1065,1473,1663-1673 | built · `Data/BinduSchema.swift:21-356; Data/PersistenceRecovery.swift` | reuse; prefer PracticeVault for new worlds |
| 43 | L02 | PracticeVault files (one JSON per store) | Atomic JSON files: rites, correspondence (river), codex-notes, play-garden, wagers, play-traces, bindu-memory, portrait-strokes. New: essence, leela-walk (board persists on leaving), gate-offerings (word/coords per room, replayed at Maya's mirror), dance-state (danced, spatial-memory grid, word-star log), relationship-field (view state only). One shared PracticeStoreContract suite: write before motion, survive a kill, never overwrite, ledger once, restore idempotent. | G7-0231, G4-0486, G7-0932, G7-0823, G7-0824, G7-0825, G7-0826, G7-0827, G7-0828, G7-0829, G7-0830, G7-0831, G7-0832, G7-0833, G7-0834, G7-0835, G7-0836, G7-0837, G7-0838, G7-0839, G7-0840, G7-0841, G7-0842, G7-0843 · 17-code-core.md:167; 09-field-scores.md:740-742; 20-code-play-rooms.md:52-54,271-273; 22-code-tests.md:477-481,523 | partial · `Services/PracticeVault.swift; Services/*Store.swift` | reuse + 5 new files |
| 44 | L03 | UserDefaults — caches and conveniences only | ringFacts.v1 (Āvaraṇa cache), shaktiFacts.v1 (Score JSON, phonetic, seedVerb, related kp), daily_summons_hour/enabled, last_destination(_day), lr_sound (default off). Rebuildable; nothing practice-bearing. | live read 13 Oct (no slice row) · 17-code-core.md:178-190 | built · `Data/RingFactsCache.swift; Data/ShaktiFactsCache.swift` | reuse |
| 45 | L04 | The three pools mapped onto the ledger | bindu-essence (who: name, dateOfBirth, higherSelfName; editable any time — C-1325) → the essence file (L02) on Home. bindu-memory (what was walked: per chakra walkedAt, act1ReadAt, wakeUpDoneAt, practiceData, dances[], completedAt, reWalkCount; events[]) → App Activity rows (D07), never a parallel log. bindu-being (mind/body/spirit/now/word) → Word Offered / State Set Down rows. Laws: write-mostly, never clear(), never synthesize, every entry carries at; "Begin a new journey" never erases the ledger; ?ash master key and "You touched N of 33" not ported; site storage (Safari wipes after 7 days) and the tol-*/asg.* keys are never the record; "forget me" not ported (practice data never lost). | G3-0286, G3-0288, G3-0290, G3-0273, G3-0274, G3-0289, G4-0157, G5-0567, G5-0339, G5-0050, G2-0908, G2-0550, G3-0208, G5-0553, G5-0552, G3-0499, G3-0309 · 06-chakra-skills.md:2017-2172,2348-2352; 08-dances.md:737-745; 14-aistrangegame.md:146-148,236-242,1227; 13-rupakarshini.md:63-64,994; 05-chakra-corpus.md:379-383,3119-3125; 07-codex.md:900-903; 12-padakarshini-field.md:278 | partial · `Services/ThreePools.swift; Services/BinduMemory.swift` | reuse ThreePools; new essence file |
| 46 | L05 | Memory reads merge local + ledger | Smṛti, Svapna, Pūjā, Portrait read only the phone's RecognitionEntry, so a new phone shows an empty sky. Every memory surface reads local ∪ App Activity (oldest first, ±60 s twins folded); Portrait year ring spans every year present. | G7-0512, G7-0528, G7-0590 · 21-code-layers.md:22,30,113,159 | wrong · `Views/Modes/SmritiView.swift; Views/Memory/PortraitMandalaView.swift:277` | fix |
| 47 | P01 | Privacy floors | Single user; no analytics, telemetry or third-party SDK; recognition log never aggregated or analysed; letters and journals private — never in snapshots, logs, tests or bundles; PAT only from xcconfig, never echoed (today also in Info.plist — move); Shared With read only behind sign-in; the site never reads Mandala recognitions; numbers describe her, the structure, the place and the day, never him; synthetic histories (PRACTITIONER_HISTORY, encounter counts, LIFETIME_YEARS, Great Wheel) never ship. | G2-0031, G2-0093, G2-0024, G2-0365, G1-0779, G1-0740, G2-0322 · 04-briefs-audits-frames.md:75,87,164,520,597; 03-mandala-worlds-layers.md:697,993; 14-aistrangegame.md:150-152 | partial · `ci_post_clone.sh; AirtableService` | reuse; NoSyntheticData + secret-scan tests (new) |
| 48 | R01 | Topic register — 511 placed | 511 topics (lakes Therapy 310 · Consciousness 153 · Learning 48): E 80 into Mandala worlds (modes 41, the-33 29, beneath 19, climb 17, time 7, mandala 5, today-rite 5, her-home 4, rings 4, well 4, relationship 3, home 2, her-presence 1, sound 1; some in two worlds) · E/S 7 (beneath 6, mandala 2, well 2, her-home 1, home 1, today-rite 1) · S 115 (→ Bindu Feed 111; 4 also named in a world) · L 276 (Bindu Learning; 5 carry a shape note) · H 33 (held, never built). Placements are reader 12's judgement (rule table + ~80 overrides) for him to rule on. This slice holds L 271 + H 33 (listed in §8). Ashrey's own frameworks (L-1533 Karṣiṇīs, L-1537 102 Śaktis, L-1535/1536 atlases) are E. | G5-0008, G5-0004, G5-0002, G5-0003, G5-0005, G5-0007, G5-0297, G5-0327, G6-0633, G5-0273 · 12-padakarshini-field.md:23-70,690-694,793-809,1014-1015,1087; 16-airtable-asg.md:92,241-245; ALL.jsonl tally 13 Oct | n/a · `none` | place as listed |
| 49 | R02 | L topics → Bindu Learning | 271 L rows here: therapy course sections, helper guides, debates, kitchen, nervous-system teachings. Only shapes port (TIDE; the rope for in-the-moment lookups; STANCE); content stays in Learning. | 271 topic rows (§8) · 12-padakarshini-field.md:1091-1600 | n/a · `none` | not this world |
| 50 | R03 | H topics — held, never built | 33: 24 scaffolding/clinical (intros, wrap-ups, workbooks, disclaimers, surveys, Q&A, medication, suicidal thoughts, hospitalisation) + 9 substances. "hold = do not build … no placeholder pages." | G5-0006 + 33 topic rows (§8) · 12-padakarshini-field.md:56-58,826 | n/a · `none` | floor: never built |
| 51 | R04 | Learning and site engine data — reference; two crossings | forms contracts (26 forms), routing 916 instances, 41 families, 15 figure primitives, doors.json, gen_* exemplars, guide lines, site register fields, 47 printed addresses, levels, deploy. Two cross into the app: the wording canon (one strings table: "she was felt here" / "and she felt you back", "The room has changed.", "There was only You, playing.", Design-authored fallbacks) and universal links aistrangegame.com/b/<verb> (8 QR printed: dream, enough, reach, remember, return, search, shine, still) → the dance door. | G4-0721, G4-0722, G4-0877, G5-0012, G5-0021, G5-0022, G5-0028, G5-0029, G5-0034, G5-0036, G5-0038, G5-0039, G5-0044, G5-0102, G5-0247, G5-0275, G5-0288, G5-0289, G5-0290, G5-0322, G5-0323, G5-0505, G5-0533, G5-0540, G5-0541, G5-0543, G5-0544, G5-0548, G5-0558, G5-0560, G5-0561, G5-0575, G5-0576, G5-0664, G5-0665, G5-0673, G5-0677, G5-0699, G5-0703, G5-0705, G4-0151, G7-0225, G5-0636 · 11-padakarshini-forms.md:213-224,641-648,666; 12-padakarshini-field.md:93-278,377-414,590,706-787,997-1003; 13-rupakarshini.md:542-557,700-712,1030; 14-aistrangegame.md:17-301,661-1239; 08-dances.md:691-695; 19-code-mandala-today.md:767-771 | n/a · `none` | strings table (new); universal-link routes (new) |
| 52 | K01 | The 102 keyed by Khadgamala Position | Mandala Khadgamala Position fldI0aV1sfOeNybHI (1–102); KhadgamalaMap spans 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102; findCard: position first, name never guessed, a cross-ring name match is a collision. Authored rooms by kp: 1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve. Memory, letters, dwell by kp (namesakes 19↔53 … 23↔62 distinct). Names: Airtable spelling with diacritics; JSON chakra names unaccented, code text accented. Every deep link takes kp or road, never a name. | G1-0031, G1-0057, G2-0095, G2-0212, G7-0672, G7-0613, G7-0844, G7-0845, G7-0846, G7-0847, G7-0848, G7-0849, G7-0850, G7-0851, G7-0852, G7-0853, G1-0126, G1-0295, G1-0333, G1-0413, G6-0946 · 01-homes.md:94-95,160,381-383,687,811,1017-1042; 22-code-tests.md:31,158,482; 17-code-core.md:869 | built · `Models/KhadgamalaMap.swift; LawsTests.swift:770-855,1570-1641` | reuse; extend to every route |
| 53 | K02 | The 33 keyed by Book Position (road) | Map Book Position fldEvXGbqdHOGZlDz = bundle road; Number fldNLzuQG1YbMVDLe in-system only; Map record id = Link-to-The-Map key; the kp join exists only in the bake's JOIN table. Axis 18, Crow 19; Maya 30, Aatma 31; 32 sealed; Mind walked in the Map's own sequence (ruling 13). | live read 13 Oct (no slice row) · 15-airtable-map.md:110,1472-1483; 17-code-core.md:228-257 | built · `Data/ChakraConstellation.json (road, recordId, kp[])` | reuse |
| 54 | K03 | Legacy fallbacks removed (position + 28, shaktis.last) | Recognition khadgamalaPositionOrFallback = position + 28 (:499-501); Shakti.playPosition (PlayGame :398); Field countByKp (:289,:424) and seats.count printed (:352); Portrait kp − 28 (:340); lalitaShakti → shaktis.last (:516; key kp 102); first-kp table duplicated (:214); Detail always .mandala source. All read kp; absence shows nothing. | G7-0028, G7-0136, G7-0236, G7-0549, G7-0525, G7-0547, G2-0206, G2-0391 · 19-code-mandala-today.md:91,453,775-776; 20-code-play-rooms.md:65; 21-code-layers.md:30,48-49,164; 04-briefs-audits-frames.md:322,634 | wrong · `files named in what` | fix |
| 55 | K04 | The day key (thread 3) | DailyEnergyService exact port: 06:00 local boundary, epoch 2020-01-01 00:00 UTC (1577836800), SplitMix64 Fisher–Yates over 102, cycle seed XOR 0xD1B54A32D192ED03, each 102-day cycle visits every Śakti once; ENERGY_POS honoured in DEBUG only; the Living Rite shuffle is a stand-in, never ported. Shipped files extended, never replaced. | G1-0297, G1-0468, G7-0099, G7-0657, G1-0014 · 01-homes.md:26-28,691-697; 02-rite-axis-field.md:477-480; 19-code-mandala-today.md:353; 22-code-tests.md:128 | built · `Services/DailyEnergyService.swift; Today/DailyRiteView.swift:49-66` | reuse |
| 56 | A01 | Score format v2 (room tuning as data) | 24 sections, 9 required (identity, config, anchors, phases, silence_windows, binaural, consciousness_loop, return, field_connection); Score JSON ~12–18 KB (ceiling 100,000), cached per record with modified time, re-fetched on room entry, played when Status ≥ Drafted; authored/extracted boundary ("That gap is the composition": cross extraction peak 138.0, ships 160); pre-baked arrays, not live FFT; no Hz to a Śakti. Mandala's own Score JSON fldz1vCCMpXiw8s1n (light hue/glow, tempo breath 2–60 s, sound carrier 20–2000 Hz) decoded tolerantly; parse error → grammar stands. | G4-0318, G4-0320, G4-0321, G4-0328, G4-0337, G4-0339, G4-0311, G4-0111, G4-0117 · 09-field-scores.md:108,130-177,612,625; 08-dances.md:586,638-639; 17-code-core.md:186-189 | partial · `Data/ShaktiFactsCache.swift:93-211` | reuse ShaktiScore; new ScoreV2 Codable |
| 57 | A02 | The nine chakra Scores + In Shadow | press (Iron 202 s, carrier 146.8, hue 12) · follow (Crystallize 259 s, 146.8, 210) · build (Powerful 206 s, 164.8, 25) · open (LMLYD 249 s, 155.6, 330) · speak (Sound of Silence 262 s, 138.6, 185) · still-ajna (Experience 316 s, 138.6, 50) · receive (Golden 192 s, 146.8, 280) · hold (Aatma 282 s, 98.0, 265) · dissolve (Love Is the Only Thing 184 s, 116.5, 290) · In Shadow for room 9 (780 s, 146.8, δ 2.5). mp3 tree-of-life/<chakra>.mp3 (aatma.mp3 = b/arise.mp3, anahata.mp3 = b/bindu-dances-reach.mp3 by sha). All batch drafts; peaks need listening; the room keeps its fixed tone, the song's drone only during its dance. | G4-0402, G4-0403, G4-0404, G4-0405, G4-0406, G4-0407, G4-0408, G4-0409, G4-0410, G4-0411, G4-0490, G4-0231, G4-0287, G2-0535, G3-0313, G4-0201, G4-0202 · 09-field-scores.md:519-612; 10-field-data-catalog.md:375-384; 05-chakra-corpus.md:309-312; 06-chakra-skills.md:2457,2471; 08-dances.md:889-921,1074-1084,1243-1247; audio-on-github.md | partial · `BF/scores/*.score.json` | bundle mp3 + stream + Score per room |
| 58 | A03 | Standalone dance Scores (the /b/ verbs, meditate) | 35 drafts + 3 authored (cross, abide, thunderclouds) + 24 web builds (V1/V1.5/V2: DUR, PEAK_T, hue, Return, hits, drops, seed, shapes). Playable only where the mp3 is on GitHub: search, still/ember, dream, rise, light, howl, release, ground, numb, enough, remember, move, wild, melt, glow, lose, fade, trace, believe, ache, crash, play, cross, before, purity, levelup, kingdom, in_shadow, earn, stay, arise, reach. Not hosted (listed, not played): abide, journey, miss, brave, unfold, wake, want, crave, confront, cherish, lift, ascend, return, shine. | G4-0412, G4-0413, G4-0414, G4-0415, G4-0416, G4-0417, G4-0418, G4-0419, G4-0420, G4-0421, G4-0422, G4-0423, G4-0424, G4-0425, G4-0426, G4-0427, G4-0428, G4-0429, G4-0430, G4-0431, G4-0432, G4-0433, G4-0434, G4-0435, G4-0436, G4-0437, G4-0438, G4-0439, G4-0440, G4-0441, G4-0442, G4-0443, G4-0444, G4-0445, G4-0446, G4-0178, G4-0179, G4-0180, G4-0181, G4-0182, G4-0183, G4-0184, G4-0185, G4-0186, G4-0187, G4-0188, G4-0189, G4-0190, G4-0191, G4-0192, G4-0193, G4-0194, G4-0195, G4-0196, G4-0197, G4-0198, G4-0199, G4-0200, G4-0203, G4-0342, G4-0401, G4-0400, G4-0447, G4-0448, G4-0493, G4-0497, G4-0501, G4-0636, G4-0362, G4-0363, G4-0365, G4-0366, G4-0376, G4-0378, G4-0389, G4-0177, G4-0507, G4-0502, G4-0115, G4-0208, G4-0291, G4-0492, G4-0361, G4-0304, G4-0564, G4-0607 · 08-dances.md:615-630,889-957,1274-1293; 09-field-scores.md:198-253,265-513,576-592,751-801; 10-field-data-catalog.md:200-205,419,551 | partial · `BD/builds/*.html; BF/scores/*` | bundle hosted ones (weight no gate) |
| 59 | A04 | Audio-feature streams (-data.json) | 49 files, 48 uniform: meta (20 keys) + H (hits {t,i}, cap ~400) + E, B, P, T, EB, EM, EH, ED at 0.5 s frames (n = ceil(DUR/0.5)) + DROPS; read through SC() linear interpolation synced to playback time; bundled beside each mp3 (none hosted today). P dead in 46: never read. ember re-extracted from bindu/still.mp3. Silence structures (unfold 241 s, hold 3–30 & 187–217 s) are Karishma-window candidates. | G4-0505, G4-0509, G4-0510, G4-0511, G4-0512, G4-0513, G4-0514, G4-0515, G4-0516, G4-0517, G4-0518, G4-0519, G4-0520, G4-0521, G4-0522, G4-0523, G4-0524, G4-0525, G4-0526, G4-0527, G4-0528, G4-0529, G4-0530, G4-0531, G4-0532, G4-0533, G4-0534, G4-0535, G4-0536, G4-0537, G4-0538, G4-0539, G4-0540, G4-0541, G4-0542, G4-0543, G4-0544, G4-0545, G4-0546, G4-0547, G4-0548, G4-0549, G4-0550, G4-0551, G4-0552, G4-0553, G4-0554, G4-0555 · 10-field-data-catalog.md:13-95,509 | not-built · `BF/scores/*-data.json` | bundle; new StreamReader |
| 60 | A05 | Offline scoring tools (never in the app) | extract.py / extract_cli.py (librosa 22050 Hz, hop 512, 0.5 s; DROPS ΔE > 2.5σ and E > 0.25 — the one pipeline for app Scores), frequency-pipeline (reference), analyze_tone.py (Krumhansl–Schmuckler; absent-fifth score 0.4·absence + 0.6·sweet; default 136.0), temporal_analysis.py, deep_analysis.py, batch assemble*.py, make_report.py; 12-step and 10-step protocols; dance Steps 0–6; one canonical copy of 11 duplicated dance files. | G4-0006, G4-0109, G4-0110, G4-0112, G4-0312, G4-0314, G4-0556, G4-0557, G4-0558, G4-0559, G4-0560, G4-0561, G4-0563, G4-0565, G4-0570, G4-0584, G4-0592, G4-0595, G4-0001, G4-0150, G4-0234, G4-0360 · 08-dances.md:16-121,560-584,689,1112-1119,1202,1285; 09-field-scores.md:109-118,239-245; 10-field-data-catalog.md:99-309 | n/a · `skills/bindu-field/scripts` | reference only |
| 61 | A06 | Bundled audio from GitHub (his recordings) | 44 unique mp3s (b/ duplicates bindu/ for 18): tree-of-life/{muladhara, svadhisthana, manipura, anahata, vishuddha, ajna, sahasrara, aatma, maya, maya-chakra-ending}.mp3 for the rooms; bindu/*.mp3 for dances and meditate. Copied into the bundle by a build script with a sha manifest; no MusicKit; no generated voice; bīja recordings bija_%02d across 102 only when he records them. Corpus asset gaps (tree images, temple-guide, pages writing tol-word-4/5/7) stay gaps. | G2-0928 · audio-on-github.md; 05-chakra-corpus.md:3348-3355; 04-briefs-audits-frames.md:98 | not-built · `iOS tree has 0 audio files` | new copy script + sha manifest |
| 62 | H01 | Which source is current | Repo copies win over the Design upload (DU still carries Final Handoff, old method, unquarantined all-shaktis-data.js); two DESIGN_SPEC.md cited by path (md5 1c04f75d75 vs fbb07a6432); "missing" Claude Code Brief.md exists; Living Rite prototype load order documented; Views at iOS/Bindu Mandala/Views/; tests at iOS/Bindu MandalaTests/ (87) and UITests (10), HEAD 8555b4d; chakra skills corpus 200 files. | G2-0172, G2-0301, G1-0458, G2-0210, G2-0461, G2-0462, G2-0474, G7-0227, G7-0607, G7-1024, G3-0001 · 04-briefs-audits-frames.md:275,326,479,744-759; 02-rite-axis-field.md:311-313; 19-code-mandala-today.md:4-5; 21-code-layers.md:3-5; 22-code-tests.md:5-6; 06-chakra-skills.md:1-15 | n/a · `n/a` | reference |

**62 elements placed.**

## 3 · Parity ledger

Written as `waves/upgrade/ledger/data.csv` — 105 rows: one per element above (`DATA-<code>`), one per App Activity type (`DATA-V01…V31`), one per Gesture Source choice to pre-create (`DATA-G01…G08`), one per snapshot file (`DATA-S01-1…4`). This world has no Design frame; its proofs are unit tests over the dated snapshot, the walk over every key, and his walk for the two that need a live read (C14, C15).

## 4 · Data contract

### 4.1 Airtable — every table and field the upgraded app reads or writes

Base `app248ZTWhYJlvQj2`. **R** = read, **W** = written by the app, **B** = read only by a bake script.

**Mandala `tblrRwXJD0uP8HU8G`** (57 fields, 126 rows: 9 Āvaraṇa, 102 Śakti, 15 Nityā). Row Type `fldw33m8YqrINlvrN` [Avarana `sel85dIY4D0v5GA9s` · Shakti `sellqnIWMTxcQxJto` · Nitya `sel8SjwYfUrQT3ToS` · Recognition · Silence · Offering · Letter · Note · Comment · Insight · Question · Crossing — event kinds stay at zero rows forever].

| Field | id | Rows | R/W | Used for |
|---|---|---|---|---|
| Sanskrit Name | fldJOatnYrw9l6tff | all | R | her name (names may be corrected; kp is identity) |
| Khadgamala Position | fldI0aV1sfOeNybHI | Śakti | R | **the 102 key** |
| Devanagari | fldDhcJ1BJQCM5llO | Śakti | R | the unseen hand |
| Quality / Quality Description | fldnwcu7zv7uV1ta2 / fldTwrtI5CyUnJV2F | Śakti | R | room's soul |
| Cluster Group | fld1HO6HwMH8fSwS3 | ring 2 | R | corridor of five |
| Esoteric Tattva | fldxylgY985SwqdJE | Śakti | R | room physics (element via C12 table) |
| Somatic Signature | fld6CylZqbIZQIUOp | Śakti | R | somaticPoetry |
| Bodily Location | fld6P1u43B0eqKU5e | Śakti | R | altitude, somatic region |
| Bija | fldnOqkWcvjQNxpWl | 42 + mudrās | R | tuning (syllable cut before " — ") |
| Field Connection | fldsk2ATEtTVB87eb | kp 31/40/42 | R | Relationship Field |
| Status | fldDiihcxC54WKPhT | Śakti | R/W | advance-only (Mapped·Exploring·Active·Embodied) |
| Iconography | fldXJEBCQxLdHWGuP | Śakti | R | attribute, colour (never a figure) |
| Personal Connection / Codex Portrait | fldlcmg7wtfIxgcZu | Āvaraṇa + Śakti | R | portrait, ring marginalia |
| Etymology | fldXypzqrhVILCqgh | Śakti | R | threshold roots |
| Appreciation Phrase | fldBqEDpBonMc2s1K | Śakti | R | inscription |
| Function | fldzT3dAhsAK75rKN | Śakti | R | mechanism |
| Shakti Family | fldYAlclWH7CfJhOg | Śakti | R | lineage register |
| Last Felt | fldWT0dGqdUQrdRGT | Śakti | W | instant "last felt" |
| Recognition Count | flddp0tLpf8iuxyt4 | Śakti | W | readiness only, never shown |
| Letter | fldgASyV031Hr4sHp | Śakti | R/W | the Well (private) |
| Score JSON | fldz1vCCMpXiw8s1n | Śakti | R | live room tuning |
| Phonetic | fldadDCi4OJYEaAFX | Śakti | R | spoken name, VoiceOver |
| Seed Verb | fldVgkRZmbc7STB7S | Śakti | R | seed ledger (after he accepts) |
| Related Shaktis / From field | fldQNnFoom72Nr6vh / fldtAau1NIP4QDZrk | Śakti | R | sister door |
| Of Avarana / Shaktis Within | fldGKKaNg4PHa5yMl / fldgc4qpoRuiRWZeS | all | R (test) | must agree with KhadgamalaMap |
| Avarana (1st…9th) / Avarana Name / Number | fldut9433zwG5CXkT / fldXTUBJTDlkKEzEV / fldVWZLCy5YFJMkCp | all | R | ring (test) · subtitle · Nityā tithi |
| Gem · Dhatu · Time Cycle · Avarana Beeja · Goddess Body Region | fldWlbdPNpmqPvfMj · fldVjcApdGFVrIfq1 · fldZLBoLGegod2xfy · fldixnYtJ30lZEDJM · fld6Ucmi8YqeAbOXU | Āvaraṇa | R | ring world |
| Siddhi · Mudra of Avarana · Phase · Notes | fldx9jXyTVWxp19o1 · fld1C14f4MsVIrA9F · fldKWGAI16XjdqoI3 · fld1HR38cQAtEicFc | Āvaraṇa | R | after-effect, gesture, Sṛṣṭi/Sthiti/Saṃhāra, the Veil |
| Presiding Form · Yogini · Mental State · Subtle Body Chakra · Geometric Shape | fldgHVP1LqoVJsYu8 · fldcqAvdN3wcP8BhT · fld8p7FtKqEKvSy7P · fld6deGFzModjBmoj · fldNqYFRn8x4F9jR0 | Āvaraṇa | R | ring identity |
| App Activity / The Feed | fldlFzDqGWJ7kpR5B / fldFvmoomlj53BiiM | — | — | inverse links, not read |
| OLD Type, OLD Of Shakti, OLD Meetings, OLD Felt At, OLD Duration (sec), OLD Lunar Day, OLD Moon Phase, OLD Source, OLD Descent Ring | fldcPbTpARaSSAEY2, fldaDjmaPvu57sJVg, fldywdLZx6cbSi39p, fldk4BdikzJQOautw, fldlBReoX5yvo1eY7, fldpAiPlX9k7y7nqb, fldFZcZ5AVcOWwo6X, fld81a2h3WoaDn7pw, fld225xgYl2Rs3TP6 | — | never | marked OLD 12 Oct; kept |

**The Map `tblwpmyKOeMxEEHd7`** (58 fields, 33 rows) — all read by the bake (B), none live. Field ids are in register 15 A.0 (`15-airtable-map.md:55-114`); the bake carries: Name, System, Number, Avarana, Primary Color, Color Hex, Verb, Activation Mode, Shakti Name, Shakti Mudra, Body Location, **Book Position fldEvXGbqdHOGZlDz (the 33 key)**, Walker Journey Stage, Chakra Subtitle, Sanskrit, Bija Mantra, Essence Line, Codex References, Voice, Core Question, Signature Phrase, Hero Threshold, Practice Prompt, Three Ways In, Practice Gate Type, Gate Text, Story Thread, Leela Story, Act 1 Voice, Act 2 Voice, Bindu Reflection, Witness Perspective, Writing Prompt, Writing Reflection, Mirror Frequency Instruction, Mirror Frequency, Subtle Mirror; **added by the upgrade**: Teaching Text fldCs6Vg2umNzxyQc, Post-Engagement Teaching fldC2OAa6NYrxrxWC, Shakti Function fld5sWbzoT3lySYgI, Tree fldX2s98w8U0Y5nK1, Tree Caption fldsj8o9IssOWR6Rp, Dyad Description flds5Iwg3XLrrbn1H, Color Dyad fld4Bdiu8fg0RNrbE, Mind Triad fldcRFeUw4NQxCAl4, Story Portal Headline fldX55ru3s5OByoXd, Panel Verb fldrmoWcnoRpolZoV, Panel Seed Message fldwFamC9FndA94if, Threshold Architecture fldiRvv7W56wAdrNa, URL fld5wkzZkM30kmeyU, Build Status fldXv59Zwjq4dmS6g, Linked Builds fldirMF5BPX0R2aHi. **Never baked:** Gaia Voice fldBiFWEG8gWb06DE and Shakti Practice fldJqK4zLO7CNiWRu (author substrate), OLD Pair Partner fld0peL6gvkB9JeRe, Linked Seed fldI9hph7iH18BQ3Y (empty), Gaia fldbWfVg1YvCUTQNq, App Activity fldxl5Ez0Btgi8uoR (inverse), and every field of room 32 beyond name/verb/colour/subtitle/Śakti/mudrā (sealed).

**App Activity `tblJlBeiHnqGpYrL7`** (28 fields) — W (POST) and R (restore, grace, memory). Ids in D06. Source App = Mandala `selQFXyea7YUZo4jN`. Activity Type `fldXNRBZy6QvIP8yz` live choices (22): Chapter Completed, Ceremony Sealed, Wager Resolved, Shakti Recognized, Letter Written, Ash Replied, Story Resonated, Story Met, Walk Completed, Veil Lifted, Silence Held, Ring Crossed, Reach, Return, Been Here, Share With, Note, First Dwelling, Siddhi Received, Called, Letter Sealed, Played. Gesture Source `fldP3wq8QTgxeTDuC` live: Today, Mandala, Well, Silence, Play. Voice `fldhnzXPqnxYHTJv5`: Gaia, Bindu, Sakshi, Higher Self, Lalita.

**Codex `tblDF4OCMcRoxkQjU`** — W only: Title fldxmZqObGiIoHHll, Date fldth1fgVdc2HgIyn, RAW fld459YeVBZBgB8zh, Source App fldaii08WVwJQA5qP = Bindu Mandala `selhkTEAbJE3DUuce`.

**Gratitude `tblEFiuFIijKe9ba6`** — R one column fld85STU49AtREkfe.

**Bindu Field `tblv3WvMZ90Sfhun6`** — R (new): Track ID fldimw5ZGOBg0j738, Verb fldrYExLmEjx4wxVt, Song Title fldSgcALwlkQPWDz4, Artist fldizqVJeRT2s10NG, Track Type flds07pkQlTwXLTWw, Element fldC5nZ1vH1nclfhe, Brainwave State fldFD9rYNEP69UEqp, Chakra fld6pH3kGSqqop2Z7, Audio URL fldUIY8v9p49QyF0B, Carrier Hz fld4oIQGckv2c9DvO, Beat Hz fld7oCYy1eIWdhE04, Seed Phrase fldyFZy2hzFXTM52K, Phase Labels fldQq0ONvyoD5NuhS, Score JSON fldxIm6qUXLcdrRuR, Audio Data URL fldUlWDvSkeHpx80x, Score Status fldOSMHwD7IxshwO7, Inhale/Hold/Exhale fld4VA2ywm9DUIqdi/fldUp2aHSRomippvI/fldTJD0Om5bik6TjF, Breath intention fldx1jepMrdMGYoIJ.

**The Builds `tbl5PR84YTy4anzAD`** — R (new, read-only): Title, Type, Chakra→Map, URL, Voice, Build Status (names; ids resolved at build from the schema).

**Identity `tbluLyZj9ilH2RhIg`** — B only (GameStructure: Name flddQh6Ci7lpY1Ist, Declaration fldry3UX62Eedqb9F).

### 4.2 The corrections the base needs before building (in this order)

Rule for every step: **never delete; mark OLD.** A cell edit keeps its old text in the dated snapshot (S01, taken *before* the edits) and a dated line in the field description. Each is one Airtable action for him to approve; the build reads only after they land.

| # | Where | Today (verified 13 Oct) | Becomes |
|---|---|---|---|
| C01 | Mandala Etymology kp 58 `recD8hZhpyOoXWS68` | "Sarva + Sthambhinī (paralyzer / stabilizer)…" | Stambhinī |
| C01 | Etymology kp 59 `recXaybSBwdlsBIT7` | "…Counterpart to Sthambhinī." | Stambhinī |
| C01 | Etymology kp 62 `recF2oZhbPZ8QOdsS` | "Sarva + Onmādinī (the intoxicator)…" | Unmādinī |
| C02 | Function kp 59 | "Counterpart to Sthambhinī — Her expansion balances Sthambhinī's stillness." | Stambhinī ×2 |
| C03 | Mudra of Avarana, ring 5 `recXWmYtaMBafQTg0` | "Sarva-Onmadini Mudra (All-Intoxicating)" | "Sarva-Unmādinī Mudrā (All-Intoxicating)"; the other eight take IAST (Sarva-Saṅkṣobhiṇī, Vidrāviṇī, Ākarṣiṇī, Vaśaṅkarī, Mahāṅkuśā, Khecarī, Bīja, Yoni and Trikhaṇḍā) |
| C04 | Avarana Name ×9 Āvaraṇa + ×102 Śakti | ASCII ("Sarvasaparipuraka", "Sarvarthasadhaka"…) | the Sanskrit Name minus " Chakra" (Trailokyamohana · Sarvāśāparipūraka · Sarvasaṅkṣobhaṇa · Sarvasaubhāgyadāyaka · Sarvārthasādhaka · Sarvarakṣākara · Sarvarogahara · Sarvasiddhiprada · Sarvānandamaya) |
| C05 | Ring 1 Mudrā names | Airtable right (kp 19 Sarva-Saṅkṣobhiṇī … 27 Sarva-Yoni, 28 Sarva-Trikhaṇḍā); Design `all-shaktis-data.js` and its bundles copy Ring 4's first ten | no bundle takes a kp 1–102 name/quality from that file |
| C06 | Ring 8 | Airtable right (100 Vajreśī Klim **Kriyā**, 101 Bhagamālinī Sauh **Jñāna**); app roster 801–803 swaps | app labels follow the base |
| C07 | 16 Karṣiṇī bījas | Airtable right (aṁ āṁ iṁ īṁ uṁ ūṁ ṛṁ ṝṁ ḷṁ ḹṁ eṁ aiṁ oṁ auṁ aṁ aḥ); `ShaktiBootstrap` seeds lṁ, eṁ (ḹṁ skipped)… and **kaṁ** at 44 | bootstrap = Airtable series |
| C08 | The Map, Maya `recMyqKSqwRnimgvy`: Signature Phrase, Panel Seed Message | "There was only the Bindu, playing." | "There was only You, playing." → re-bake B01 + B02 |
| C09 | Seed Verb description | "Written by Ashrey; empty until he writes it." | "…Drafted by Claude from her name, etymology and Function, approved by Ashrey; live only once he accepts it." |
| C10 | Function description | no provenance | "kp 29–44: drafted by Claude (12 Oct 2026), kept by Ashrey's ruling 7." |
| C11 | App Activity choices | 13 app kinds not pre-created; Gesture Source lacks Room/Field the app already sends | add 21 Activity Types + 8 Gesture Sources |
| C12 | Elements (ruling 4 + light) | tattva parse: kp 34–44 organs → ether; no light branch | kp table in code; Airtable untouched |
| C13 | Map field-name swaps (11) | canon keys ≠ Map names | Map names govern; 11 descriptions gain "walk-canon key: …" |
| C14 | Map App Activity link | 0/33 (and Link to The Map 0/160) | every room-born event links its Map record |

### 4.3 App Activity vocabulary for every world

One list (`LedgerIsTheRecord.eventVocabulary`). **in AT** = choice exists in Airtable today.

| Type | World(s) | Gesture Source | Links / fields | Written when | Code | in AT |
|---|---|---|---|---|---|---|
| Shakti Recognized | Today, Mandala, Her Presence, Her Home, the 102 field | Today · Mandala · Presence · Room · Field | Link to Mandala (kp) | "I feel her" (first / again) | built | yes |
| Ring Crossed | the nine rings, the Climb, Mandala | Mandala · Climb | Descent Ring 1–9, Link to Mandala (Āvaraṇa row) | a new deepest ring only | built | yes |
| Silence Held | Her Home, Home (Mauna, kp 102), Beneath | Silence · Bindu · Beneath | Duration (sec), kp | ≥ 62 s once per visit | built | yes |
| Letter Written / Letter Sealed / Letter Opened | the Well, Memory | Well | kp (Letter text stays on her row) | once per Śakti / seal / opening | built | yes / yes / no |
| Note Left | Her Home margin, the Well | Room · Well | Notes = his words | each note | built | no |
| Full Circle | Memory | — | — | once ever, at the 102nd first recognition (never shown) | built | no |
| First Dwelling | Her Home | Room | kp | 227 s, once ever per seat | built | yes |
| Siddhi Received / Light Entered / Light Sent Back | Her Home | Room | kp | leaving; activation cycle; return | built | yes / no / no |
| State Set Down / Day Offered | Today/the Rite, the Modes | Today | Notes optional | offered; Pūjā | built | no |
| Witness Written / Garland Recited | the Modes, Beneath, the rings | Beneath · Mandala | kp or Āvaraṇa | witness page; the whole garland | built | no |
| Portrait Drawn | Her Presence, Memory | Presence | kp | a stroke set kept | built | no |
| Played / Wager Resolved / Leela Drop | A Strange Game | Play | place, seconds; kp or Āvaraṇa | each game; a wager; a drop (≥3 days apart then 30 %) | built | yes / yes / no |
| Chakra Practiced | the 33, the Climb | Chakra | **Link to The Map** | each practice per visit | built | no |
| Name Kept | Home (essence) | Bindu | — | his name/higher-self name kept | built | no |
| Share With | the Relationship Field | Relationship | Link to Mandala + **Shared With → Relationships** | he offers a recognition to a person (nothing sent outside) | new builder | yes |
| **Gate Opened** | the 33 | Chakra | Link to The Map; Notes = the word if typed | the room's gate instrument completes (Canvas, Textarea, Sound Response, Tap Rhythm, Device Tilt) | new | no |
| **Wake-Up Sounded** | the 33 | Chakra | Link to The Map | the bīja wake-up held to its end | new | no |
| **Dance Completed** | the 33, A Strange Game (dances) | Chakra · Play | Link to The Map (room) + Link to Bindu Field (track); Duration | a dance reaches its return | new | no |
| **Word Offered** | the 33 (practice word / post-dance word, replayed at Maya's mirror) | Chakra | Link to The Map; Notes = his word | the offering is given | new | no |
| **Reveal Received** | room 32 (Ego Reveal, sealed) | Chakra | Link to The Map (32); no text ever | the sealed reveal completes; opens the Gaia layer | new | no |
| **Leela Landed** | A Strange Game (Leela on the 33) | Play | Link to The Map (square) | every landing (the board persists in L02 leela-walk) | new | no |
| **Breath Completed** | the Modes (breath) | Today · Beneath | Duration; Link to Bindu Field (breath row) | a breath session ends | new | no |
| **Threshold Crossed** | the Climb, the 33 (Shadow 3→4, Armin 6→7) | Climb | Link to The Map (Shadow `recAjCRcI5Bt6pJ6V` / Armin `recXcyfAS07fvurEc`) | the membrane is pushed through | new | no |

Not written by the Mandala (other apps' kinds, kept): Chapter Completed, Ceremony Sealed (Field), Ash Replied, Story Resonated, Story Met, Walk Completed, Veil Lifted (Feed), Reach, Return, Been Here, Note, Called. "You have stood here before" and floor traces are **reads** of this ledger, not events.

### 4.4 Bundled bakes and how they are regenerated

| Bundle | Today | Script | Inputs | Regenerate |
|---|---|---|---|---|
| `Data/ChakraConstellation.json` | 1,642 lines · 327,662 B · md5 70211e07 · 33 × 44 keys · bakedOn 2026-10-12 | `waves/wave-3/bake_chakra_constellation.py MAP.json OUT.json` | full Map export (all fields, 33 rows) | after C08/C13: export → bake (59 keys, adds 15 energy fields + Bindu Field record id per room, drops room-32 content and substrate) → byte-compare every key to the export → commit with `bakedOn` = export date |
| `Data/GameStructure.json` | 211 lines · md5 6e37a350 | `waves/wave-6/bake_game_structure.py OUT.json [--verify]` | Identity + Map (record + field id per line) | after C08: re-bake; CI runs `--verify` with a read token (GET only) so every line is proved a substring of its live row; axis block decoded or dropped |
| Card bundle (new) | — (homes-cards.js was hand-condensed) | `tools/bake_cards.py` (new) | Mandala export by kp + Design constant tables (B03) | generated, never hand-typed |
| Offline seed (new) | 16 Karṣiṇīs in Swift | `tools/bake_seed.py` (new) from S01 | Mandala export | 126 rows, replaces `ShaktiBootstrap` literals |
| Scores + streams (new) | none | copy script | Bindu Field Score JSON + `BF/scores/*-data.json` + GitHub mp3 (sha) | per hosted song |

### 4.5 The dated read-only test snapshot (S01)

- **Script** `tools/snapshot.py` (new): GET only; PAT from the environment, never printed; refuses any table outside D01's list.
- **Path** `iOS/Bindu MandalaTests/Snapshot/2026-10-13/` — taken **before** the C-edits so it is also their before-image; a second snapshot is taken after the edits and becomes the test truth.
- **Files** `mandala.json` (126 rows, non-OLD fields; Letter, Last Felt, Recognition Count emptied and Status = Mapped — his practice never leaves the phone into a fixture), `map.json` (33 rows; room 32 beyond its public identity cells, Gaia Voice and Shakti Practice replaced by `{"len": n}` stubs), `bindu-field.json` (60 rows: Track ID, Verb, Chakra, Element, Carrier Hz, Beat Hz, Audio URL, Score JSON, Score Status), `manifest.json` (taken-at UTC, base and table ids, counts 126/33/60, sha256 per file, corrections applied yes/no).
- **Use**: launch argument `SNAPSHOT=2026-10-13` → `SnapshotSource` replaces `AirtableService` reads; all writes go to an in-memory `MockLedger` (never a live POST or PATCH, G5-0303). The automated walk visits every kp 1–102, every road 1–33, every world door from the spine, and asserts every visible string equals its snapshot cell.

### 4.6 Local stores

| Store | Kind | Holds | Never |
|---|---|---|---|
| SwiftData 3.0.0 (`BinduSchema`) | Shakti, Avarana, NityaDevi, RecognitionEntry (kp + ring), ShaktiLetter (kp), DescentState, HomeMemory (phone-only), MarginNote | the practice record of the phone | mutated in place; a new model is V4+ |
| PracticeVault JSON | rites · correspondence · codex-notes · play-garden · wagers · play-traces · bindu-memory · portrait-strokes; **new** essence · leela-walk · gate-offerings · dance-state · relationship-field | each world's own state | cleared by "begin again" |
| UserDefaults | ringFacts.v1, shaktiFacts.v1, daily_summons_hour/enabled, last_destination(_day), lr_sound | caches and conveniences | practice data |
| Bundle | ChakraConstellation.json, GameStructure.json, cards, seed, Scores, -data.json, 44 mp3 | baked verbatim, dated | edited by hand |

### 4.7 Privacy

Letters and journals private; snapshots strip Letter and his counts; the app reads 8 tables only and refuses Daily, Emotions, Anger, SJ, Health, Neev, Goals, To-Do, Calendar, Nutrition, Books, Fitness, Monthly, Year, Activity, Gaia; Shared With only behind sign-in; the PAT never echoed; no telemetry; synthetic histories never ship; the site never reads Mandala recognitions.

### 4.8 Where the 33 and the 102 are keyed

- **The 102**: Mandala `Khadgamala Position` fldI0aV1sfOeNybHI; in code `KhadgamalaMap` spans 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102; RecognitionEntry, ShaktiLetter, HomeMemory, MarginNote, dwell and memory all keyed by kp; deep links take kp.
- **The 33**: The Map `Book Position` fldEvXGbqdHOGZlDz = bundle `road` (Road order; Mind section in the Map's own sequence, ruling 13); `Number` fldNLzuQG1YbMVDLe is in-system numbering only; each room's Map record id is the Link-to-The-Map key; the kp join lives only in the bake's JOIN table (the Map has no kp field).
- **The day**: `DailyEnergyService` (06:00, epoch 2020-01-01, SplitMix64 over 102); the lunar day is the true tithi.

## 5 · Doors

The data world has no doors of its own. It opens every door of the spine: the **point** (Home) reads essence and the ledger; the **menu** and **search** read the 102 names (by kp, collisions kept distinct: Kāmeśī kp 88 ≠ Kāmeśvarī kp 99; namesakes 19↔53 … 23↔62) and the 33 names (by road); **thread 1** (her position) = kp; **thread 2** (the chakra) = road + Map record id + the JOIN kp list; **thread 3** (the day) = DailyEnergyService; **back-to-where-you-were** = `last_destination`; universal links `aistrangegame.com/b/<verb>` open a dance door (needs the associated domain). Every crossing writes nothing; only gestures write.

## 6 · To Bindu Feed

- The thirteen teachings (A Mirror, Not a Master … Wrong Time, Not Wrong Page) — G5-0293, `12-padakarshini-field.md:785-787`.
- The Map's story fields (Story Thread, Leela Story, Act 1/Act 2 Voice, Bindu Reflection incl. Maya's "…Someone, playing.", Witness Perspective) are Feed candidates by ruling 5; the bake still carries them verbatim so the Feed and the 33's story-by-the-moving-point can read one source — `15-airtable-map.md:45`, `17-code-core.md:260`.
- The 111 S topics of the learning register (portraits, storybooks, cosmologies) — placed by R01.
- Gaia Voice (substrate) as source for the Feed's Gaia — `15-airtable-map.md:1518-1524`.
- Walks' arrival/teaching prose, Gaia Witness Bodies, Learning storybooks, Relationship Analyses — `16-airtable-asg.md:346`.
- Not to the Feed: G5-0037 (Empathic Listening content file) belongs to Bindu Learning.

## 7 · Conflicts settled and open

**Settled from evidence**

1. *Ring 1 Mudrā names, the Ring 8 swap and the bīja shift are not Airtable errors.* The live base (13 Oct) has kp 19–28 as the ten Mudrās, 100 = Kriyā, 101 = Jñāna, and the sixteen vowels in order; each error lives in Design data (`all-shaktis-data.js`, `shakti-data.js`) and the app bundles built from it. Fix the bundles, not the base (C05–C07).
2. *Elements.* The base tattva for kp 34–44 is the cross-mapped organ (it is her card's counterpoint, kept verbatim), so a parse cannot give an element. Element is a kp table: the base names the element for 29–33, ruling 4 for 31/40/42/43, Design's RING2 grammar for the rest (it matches the classical tanmātra element). Kp 31 is already fire in the base; the "ether" came from the bootstrap (C12, C16).
3. *Map names vs canon keys.* The Map's names govern (register 15 C1); the base is not renamed — descriptions carry the canon key (C13).
4. *Seed Verb.* His Wave 6 decision 10 ("drafted by Claude, approved by you") outranks the description written before it (C09).
5. *Maya's line.* Ruling 8 changes the Signature Phrase and Panel Seed (the line Maya's room and ring 9 show); the Bindu Reflection is story and goes to the Feed unchanged (C08).
6. *App Activity under-use.* Link to The Map 0/160 and the empty Map inverse are the same fact: no room-born event has reached Airtable; fix by writing the link on every room event (C14).
7. *Ring 7 = 12* (8 Vāsinīs + 4 Weapons; 28·16·8·14·10·10·12·3·1 = 102) and *ring 7 mudrā Khecarī* (settled); the Map's "Rahasya" is kept as its own naming.
8. *Local-only memory vs "practice data never lost".* Floor wins: memory reads merge the ledger (L05); "forget me" (rupakarshini law 26) is not ported — practice data is never cleared.
9. *Carriers.* The Mandala keeps one tuning (Design's ring roots) and each room's fixed tone; Bindu Field carriers (Aatma 98 vs 130.8, Kingdom 110 vs 146.8) play only inside a dance and are Bindu Field's to rule.
10. *Unhosted songs* are listed, never played; nothing licensed is bundled that is not in his GitHub repo (ruling 12).
11. *tree-of-life/aatma.mp3 is byte-identical to b/arise.mp3* (sha eade0428) and *anahata.mp3 to b/bindu-dances-reach.mp3* (sha 84df242a): the Aatma room song and the "joy (arise)" dance are one recording; the hold Score (282.35 s) and the arise build (282.4 s) agree — no conflict, one file bundled once.

**Open — one word each from Ashrey**

1. Maya's Bindu Reflection closes "There was only — / playing. Someone, playing." Does ruling 8 also change that line (it is Feed material, not shown in the Mandala)?
2. Kp 32 Śabda and 33 Sparśa: the base says Vāyu (air) and Ākāśa (ether); the classical pairing (and Design) is sound→ether, touch→air. Keep the base, or swap the two tattva cells?
3. Personal Connection / Codex Portrait on the nine Āvaraṇa rows is a synthesis from his Codex (Session A, 27 May). May it appear on the ring walls as marginalia "in his voice", or only as a portrait line?
4. The four Map content flags: Innocence "arrives … from Armin" (Road walks Inception first), the older Axis spine-line in Axis's Leela Story and portal line, Crow's second person, and the E Chakras / Lalita Game with no Map record.
5. Widening Gratitude to `Link to Relationships ⚡` (a person's light) — yes or no.

## 8 · Coverage

Every index id in `by-world/data.jsonl`, in slice order.

- G1-0012 — placed (§2 #20 C05)
- G1-0013 — placed (§2 #20 C05)
- G1-0014 — placed (§2 #55 K04)
- G1-0016 — placed (§2 #37 B03)
- G1-0022 — placed (§2 #37 B03)
- G1-0030 — placed (§2 #2 D02)
- G1-0031 — placed (§2 #52 K01)
- G1-0035 — placed (§2 #3 D03)
- G1-0036 — placed (§2 #20 C05)
- G1-0041 — placed (§2 #3 D03)
- G1-0052 — placed (§2 #2 D02)
- G1-0053 — placed (§2 #32 C17)
- G1-0054 — placed (§2 #37 B03)
- G1-0055 — placed (§2 #37 B03)
- G1-0056 — placed (§2 #37 B03)
- G1-0057 — placed (§2 #52 K01)
- G1-0058 — placed (§2 #37 B03)
- G1-0059 — placed (§2 #3 D03)
- G1-0060 — placed (§2 #3 D03)
- G1-0061 — placed (§2 #3 D03)
- G1-0062 — placed (§2 #3 D03)
- G1-0064 — placed (§2 #20 C05)
- G1-0065 — placed (§2 #21 C06)
- G1-0066 — placed (§2 #4 D04)
- G1-0068 — placed (§2 #20 C05)
- G1-0082 — placed (§2 #37 B03)
- G1-0099 — placed (§2 #3 D03)
- G1-0126 — placed (§2 #52 K01)
- G1-0246 — placed (§2 #20 C05)
- G1-0275 — placed (§2 #37 B03)
- G1-0285 — placed (§2 #22 C07)
- G1-0295 — placed (§2 #52 K01)
- G1-0297 — placed (§2 #55 K04)
- G1-0333 — placed (§2 #52 K01)
- G1-0334 — placed (§2 #20 C05)
- G1-0413 — placed (§2 #52 K01)
- G1-0418 — placed (§2 #37 B03)
- G1-0421 — placed (§2 #2 D02)
- G1-0425 — placed (§2 #20 C05)
- G1-0458 — placed (§2 #62 H01)
- G1-0461 — placed (§2 #37 B03)
- G1-0462 — placed (§2 #37 B03)
- G1-0463 — placed (§2 #27 C12)
- G1-0464 — placed (§2 #27 C12)
- G1-0468 — placed (§2 #55 K04)
- G1-0472 — placed (§2 #2 D02)
- G1-0481 — placed (§2 #31 C16)
- G1-0500 — placed (§2 #37 B03)
- G1-0531 — placed (§2 #42 L01)
- G1-0533 — placed (§2 #37 B03)
- G1-0534 — placed (§2 #27 C12)
- G1-0536 — placed (§2 #22 C07)
- G1-0537 — placed (§2 #3 D03)
- G1-0559 — placed (§2 #37 B03)
- G1-0560 — placed (§2 #2 D02)
- G1-0561 — placed (§2 #15 D15)
- G1-0562 — placed (§2 #31 C16)
- G1-0563 — placed (§2 #3 D03)
- G1-0564 — placed (§2 #20 C05)
- G1-0565 — placed (§2 #2 D02)
- G1-0566 — placed (§2 #4 D04)
- G1-0576 — placed (§2 #42 L01)
- G1-0588 — placed (§2 #27 C12)
- G1-0595 — placed (§2 #2 D02)
- G1-0600 — placed (§2 #42 L01)
- G1-0623 — placed (§2 #3 D03)
- G1-0680 — placed (§2 #2 D02)
- G1-0714 — placed (§2 #20 C05)
- G1-0738 — placed (§2 #15 D15)
- G1-0740 — placed (§2 #47 P01)
- G1-0750 — placed (§2 #4 D04)
- G1-0758 — placed (§2 #2 D02)
- G1-0760 — placed (§2 #15 D15)
- G1-0779 — placed (§2 #47 P01)
- G2-0010 — placed (§2 #22 C07)
- G2-0024 — placed (§2 #47 P01)
- G2-0026 — placed (§2 #1 D01)
- G2-0027 — placed (§2 #5 D05)
- G2-0031 — placed (§2 #47 P01)
- G2-0042 — placed (§2 #22 C07)
- G2-0049 — placed (§2 #2 D02)
- G2-0051 — placed (§2 #42 L01)
- G2-0060 — placed (§2 #2 D02)
- G2-0061 — placed (§2 #2 D02)
- G2-0064 — placed (§2 #42 L01)
- G2-0074 — placed (§2 #2 D02)
- G2-0081 — placed (§2 #2 D02)
- G2-0082 — placed (§2 #2 D02)
- G2-0083 — placed (§2 #3 D03)
- G2-0084 — placed (§2 #6 D06)
- G2-0093 — placed (§2 #47 P01)
- G2-0095 — placed (§2 #52 K01)
- G2-0100 — placed (§2 #5 D05)
- G2-0102 — placed (§2 #5 D05)
- G2-0105 — placed (§2 #1 D01)
- G2-0141 — placed (§2 #2 D02)
- G2-0144 — placed (§2 #42 L01)
- G2-0172 — placed (§2 #62 H01)
- G2-0189 — placed (§2 #20 C05)
- G2-0199 — placed (§2 #6 D06)
- G2-0202 — placed (§2 #2 D02)
- G2-0203 — placed (§2 #6 D06)
- G2-0206 — placed (§2 #54 K03)
- G2-0210 — placed (§2 #62 H01)
- G2-0212 — placed (§2 #52 K01)
- G2-0213 — placed (§2 #20 C05)
- G2-0214 — placed (§2 #2 D02)
- G2-0215 — placed (§2 #6 D06)
- G2-0217 — placed (§2 #3 D03)
- G2-0223 — placed (§2 #2 D02)
- G2-0230 — placed (§2 #3 D03)
- G2-0237 — placed (§2 #3 D03)
- G2-0242 — placed (§2 #2 D02)
- G2-0243 — placed (§2 #20 C05)
- G2-0244 — placed (§2 #22 C07)
- G2-0245 — placed (§2 #20 C05)
- G2-0246 — placed (§2 #3 D03)
- G2-0247 — placed (§2 #21 C06)
- G2-0249 — placed (§2 #20 C05)
- G2-0251 — placed (§2 #37 B03)
- G2-0268 — placed (§2 #3 D03)
- G2-0290 — placed (§2 #20 C05)
- G2-0295 — placed (§2 #2 D02)
- G2-0301 — placed (§2 #62 H01)
- G2-0303 — placed (§2 #2 D02)
- G2-0307 — placed (§2 #20 C05)
- G2-0309 — placed (§2 #41 S01)
- G2-0313 — placed (§2 #6 D06)
- G2-0314 — placed (§2 #5 D05)
- G2-0322 — placed (§2 #47 P01)
- G2-0323 — placed (§2 #6 D06)
- G2-0324 — placed (§2 #5 D05)
- G2-0328 — placed (§2 #20 C05)
- G2-0332 — placed (§2 #42 L01)
- G2-0337 — placed (§2 #2 D02)
- G2-0338 — placed (§2 #22 C07)
- G2-0343 — placed (§2 #6 D06)
- G2-0347 — placed (§2 #6 D06)
- G2-0348 — placed (§2 #6 D06)
- G2-0365 — placed (§2 #47 P01)
- G2-0371 — placed (§2 #7 D07)
- G2-0373 — placed (§2 #41 S01)
- G2-0379 — placed (§2 #42 L01)
- G2-0380 — placed (§2 #2 D02)
- G2-0381 — placed (§2 #6 D06)
- G2-0391 — placed (§2 #54 K03)
- G2-0440 — placed (§2 #6 D06)
- G2-0446 — placed (§2 #22 C07)
- G2-0447 — placed (§2 #3 D03)
- G2-0458 — placed (§2 #2 D02)
- G2-0459 — placed (§2 #20 C05)
- G2-0461 — placed (§2 #62 H01)
- G2-0462 — placed (§2 #62 H01)
- G2-0474 — placed (§2 #62 H01)
- G2-0479 — placed (§2 #8 D08)
- G2-0489 — placed (§2 #40 B06)
- G2-0535 — placed (§2 #57 A02)
- G2-0550 — placed (§2 #45 L04)
- G2-0551 — placed (§2 #9 D09)
- G2-0552 — placed (§2 #9 D09)
- G2-0553 — placed (§2 #9 D09)
- G2-0554 — placed (§2 #9 D09)
- G2-0555 — placed (§2 #9 D09)
- G2-0556 — placed (§2 #9 D09)
- G2-0557 — placed (§2 #9 D09)
- G2-0558 — placed (§2 #9 D09)
- G2-0559 — placed (§2 #9 D09)
- G2-0560 — placed (§2 #9 D09)
- G2-0561 — placed (§2 #9 D09)
- G2-0562 — placed (§2 #9 D09)
- G2-0563 — placed (§2 #9 D09)
- G2-0564 — placed (§2 #9 D09)
- G2-0565 — placed (§2 #9 D09)
- G2-0566 — placed (§2 #9 D09)
- G2-0567 — placed (§2 #9 D09)
- G2-0568 — placed (§2 #9 D09)
- G2-0569 — placed (§2 #9 D09)
- G2-0570 — placed (§2 #9 D09)
- G2-0571 — placed (§2 #9 D09)
- G2-0572 — placed (§2 #9 D09)
- G2-0573 — placed (§2 #9 D09)
- G2-0574 — placed (§2 #9 D09)
- G2-0575 — placed (§2 #9 D09)
- G2-0576 — placed (§2 #9 D09)
- G2-0577 — placed (§2 #9 D09)
- G2-0578 — placed (§2 #9 D09)
- G2-0579 — placed (§2 #9 D09)
- G2-0580 — placed (§2 #9 D09)
- G2-0581 — placed (§2 #9 D09)
- G2-0582 — placed (§2 #9 D09)
- G2-0583 — placed (§2 #9 D09)
- G2-0584 — placed (§2 #9 D09)
- G2-0592 — placed (§2 #8 D08)
- G2-0847 — placed (§2 #40 B06)
- G2-0858 — placed (§2 #40 B06)
- G2-0862 — placed (§2 #40 B06)
- G2-0908 — placed (§2 #45 L04)
- G2-0914 — placed (§2 #7 D07)
- G2-0915 — placed (§2 #40 B06)
- G2-0924 — placed (§2 #35 B01)
- G2-0928 — placed (§2 #61 A06)
- G2-0933 — placed (§2 #9 D09)
- G3-0001 — placed (§2 #62 H01)
- G3-0003 — placed (§2 #8 D08)
- G3-0004 — placed (§2 #8 D08)
- G3-0153 — placed (§2 #30 C15)
- G3-0154 — placed (§2 #7 D07)
- G3-0208 — placed (§2 #45 L04)
- G3-0243 — placed (§2 #9 D09)
- G3-0265 — placed (§2 #35 B01)
- G3-0273 — placed (§2 #45 L04)
- G3-0274 — placed (§2 #45 L04)
- G3-0286 — placed (§2 #45 L04)
- G3-0287 — placed (§2 #7 D07)
- G3-0288 — placed (§2 #45 L04)
- G3-0289 — placed (§2 #45 L04)
- G3-0290 — placed (§2 #45 L04)
- G3-0309 — placed (§2 #45 L04)
- G3-0313 — placed (§2 #57 A02)
- G3-0317 — placed (§2 #9 D09)
- G3-0320 — placed (§2 #9 D09)
- G3-0326 — placed (§2 #10 D10)
- G3-0338 — placed (§2 #10 D10)
- G3-0364 — placed (§2 #10 D10)
- G3-0419 — placed (§2 #10 D10)
- G3-0499 — placed (§2 #45 L04)
- G3-0506 — placed (§2 #10 D10)
- G3-0509 — placed (§2 #8 D08)
- G3-0510 — placed (§2 #8 D08)
- G3-0525 — placed (§2 #10 D10)
- G3-0526 — placed (§2 #10 D10)
- G3-0539 — placed (§2 #10 D10)
- G3-0540 — placed (§2 #10 D10)
- G4-0001 — placed (§2 #60 A05)
- G4-0006 — placed (§2 #60 A05)
- G4-0109 — placed (§2 #60 A05)
- G4-0110 — placed (§2 #60 A05)
- G4-0111 — placed (§2 #56 A01)
- G4-0112 — placed (§2 #60 A05)
- G4-0115 — placed (§2 #58 A03)
- G4-0117 — placed (§2 #56 A01)
- G4-0150 — placed (§2 #60 A05)
- G4-0151 — placed (§2 #51 R04)
- G4-0152 — placed (§2 #8 D08)
- G4-0157 — placed (§2 #45 L04)
- G4-0176 — placed (§2 #7 D07)
- G4-0177 — placed (§2 #58 A03)
- G4-0178 — placed (§2 #58 A03)
- G4-0179 — placed (§2 #58 A03)
- G4-0180 — placed (§2 #58 A03)
- G4-0181 — placed (§2 #58 A03)
- G4-0182 — placed (§2 #58 A03)
- G4-0183 — placed (§2 #58 A03)
- G4-0184 — placed (§2 #58 A03)
- G4-0185 — placed (§2 #58 A03)
- G4-0186 — placed (§2 #58 A03)
- G4-0187 — placed (§2 #58 A03)
- G4-0188 — placed (§2 #58 A03)
- G4-0189 — placed (§2 #58 A03)
- G4-0190 — placed (§2 #58 A03)
- G4-0191 — placed (§2 #58 A03)
- G4-0192 — placed (§2 #58 A03)
- G4-0193 — placed (§2 #58 A03)
- G4-0194 — placed (§2 #58 A03)
- G4-0195 — placed (§2 #58 A03)
- G4-0196 — placed (§2 #58 A03)
- G4-0197 — placed (§2 #58 A03)
- G4-0198 — placed (§2 #58 A03)
- G4-0199 — placed (§2 #58 A03)
- G4-0200 — placed (§2 #58 A03)
- G4-0201 — placed (§2 #57 A02)
- G4-0202 — placed (§2 #57 A02)
- G4-0203 — placed (§2 #58 A03)
- G4-0204 — placed (§2 #34 C19)
- G4-0208 — placed (§2 #58 A03)
- G4-0231 — placed (§2 #57 A02)
- G4-0234 — placed (§2 #60 A05)
- G4-0287 — placed (§2 #57 A02)
- G4-0291 — placed (§2 #58 A03)
- G4-0292 — placed (§2 #7 D07)
- G4-0297 — placed (§2 #1 D01)
- G4-0304 — placed (§2 #58 A03)
- G4-0309 — placed (§2 #12 D12)
- G4-0310 — placed (§2 #12 D12)
- G4-0311 — placed (§2 #56 A01)
- G4-0312 — placed (§2 #60 A05)
- G4-0314 — placed (§2 #60 A05)
- G4-0318 — placed (§2 #56 A01)
- G4-0320 — placed (§2 #56 A01)
- G4-0321 — placed (§2 #56 A01)
- G4-0328 — placed (§2 #56 A01)
- G4-0334 — placed (§2 #7 D07)
- G4-0336 — placed (§2 #12 D12)
- G4-0337 — placed (§2 #56 A01)
- G4-0339 — placed (§2 #56 A01)
- G4-0342 — placed (§2 #58 A03)
- G4-0343 — placed (§2 #12 D12)
- G4-0346 — placed (§2 #12 D12)
- G4-0347 — placed (§2 #12 D12)
- G4-0348 — placed (§2 #12 D12)
- G4-0360 — placed (§2 #60 A05)
- G4-0361 — placed (§2 #58 A03)
- G4-0362 — placed (§2 #58 A03)
- G4-0363 — placed (§2 #58 A03)
- G4-0365 — placed (§2 #58 A03)
- G4-0366 — placed (§2 #58 A03)
- G4-0376 — placed (§2 #58 A03)
- G4-0378 — placed (§2 #58 A03)
- G4-0387 — placed (§2 #7 D07)
- G4-0389 — placed (§2 #58 A03)
- G4-0400 — placed (§2 #58 A03)
- G4-0401 — placed (§2 #58 A03)
- G4-0402 — placed (§2 #57 A02)
- G4-0403 — placed (§2 #57 A02)
- G4-0404 — placed (§2 #57 A02)
- G4-0405 — placed (§2 #57 A02)
- G4-0406 — placed (§2 #57 A02)
- G4-0407 — placed (§2 #57 A02)
- G4-0408 — placed (§2 #57 A02)
- G4-0409 — placed (§2 #57 A02)
- G4-0410 — placed (§2 #57 A02)
- G4-0411 — placed (§2 #57 A02)
- G4-0412 — placed (§2 #58 A03)
- G4-0413 — placed (§2 #58 A03)
- G4-0414 — placed (§2 #58 A03)
- G4-0415 — placed (§2 #58 A03)
- G4-0416 — placed (§2 #58 A03)
- G4-0417 — placed (§2 #58 A03)
- G4-0418 — placed (§2 #58 A03)
- G4-0419 — placed (§2 #58 A03)
- G4-0420 — placed (§2 #58 A03)
- G4-0421 — placed (§2 #58 A03)
- G4-0422 — placed (§2 #58 A03)
- G4-0423 — placed (§2 #58 A03)
- G4-0424 — placed (§2 #58 A03)
- G4-0425 — placed (§2 #58 A03)
- G4-0426 — placed (§2 #58 A03)
- G4-0427 — placed (§2 #58 A03)
- G4-0428 — placed (§2 #58 A03)
- G4-0429 — placed (§2 #58 A03)
- G4-0430 — placed (§2 #58 A03)
- G4-0431 — placed (§2 #58 A03)
- G4-0432 — placed (§2 #58 A03)
- G4-0433 — placed (§2 #58 A03)
- G4-0434 — placed (§2 #58 A03)
- G4-0435 — placed (§2 #58 A03)
- G4-0436 — placed (§2 #58 A03)
- G4-0437 — placed (§2 #58 A03)
- G4-0438 — placed (§2 #58 A03)
- G4-0439 — placed (§2 #58 A03)
- G4-0440 — placed (§2 #58 A03)
- G4-0441 — placed (§2 #58 A03)
- G4-0442 — placed (§2 #58 A03)
- G4-0443 — placed (§2 #58 A03)
- G4-0444 — placed (§2 #58 A03)
- G4-0445 — placed (§2 #58 A03)
- G4-0446 — placed (§2 #58 A03)
- G4-0447 — placed (§2 #58 A03)
- G4-0448 — placed (§2 #58 A03)
- G4-0449 — placed (§2 #12 D12)
- G4-0486 — placed (§2 #43 L02)
- G4-0490 — placed (§2 #57 A02)
- G4-0492 — placed (§2 #58 A03)
- G4-0493 — placed (§2 #58 A03)
- G4-0494 — placed (§2 #34 C19)
- G4-0496 — placed (§2 #34 C19)
- G4-0497 — placed (§2 #58 A03)
- G4-0501 — placed (§2 #58 A03)
- G4-0502 — placed (§2 #58 A03)
- G4-0503 — placed (§2 #34 C19)
- G4-0504 — placed (§2 #34 C19)
- G4-0505 — placed (§2 #59 A04)
- G4-0506 — placed (§2 #34 C19)
- G4-0507 — placed (§2 #58 A03)
- G4-0508 — placed (§2 #34 C19)
- G4-0509 — placed (§2 #59 A04)
- G4-0510 — placed (§2 #59 A04)
- G4-0511 — placed (§2 #59 A04)
- G4-0512 — placed (§2 #59 A04)
- G4-0513 — placed (§2 #59 A04)
- G4-0514 — placed (§2 #59 A04)
- G4-0515 — placed (§2 #59 A04)
- G4-0516 — placed (§2 #59 A04)
- G4-0517 — placed (§2 #59 A04)
- G4-0518 — placed (§2 #59 A04)
- G4-0519 — placed (§2 #59 A04)
- G4-0520 — placed (§2 #59 A04)
- G4-0521 — placed (§2 #59 A04)
- G4-0522 — placed (§2 #59 A04)
- G4-0523 — placed (§2 #59 A04)
- G4-0524 — placed (§2 #59 A04)
- G4-0525 — placed (§2 #59 A04)
- G4-0526 — placed (§2 #59 A04)
- G4-0527 — placed (§2 #59 A04)
- G4-0528 — placed (§2 #59 A04)
- G4-0529 — placed (§2 #59 A04)
- G4-0530 — placed (§2 #59 A04)
- G4-0531 — placed (§2 #59 A04)
- G4-0532 — placed (§2 #59 A04)
- G4-0533 — placed (§2 #59 A04)
- G4-0534 — placed (§2 #59 A04)
- G4-0535 — placed (§2 #59 A04)
- G4-0536 — placed (§2 #59 A04)
- G4-0537 — placed (§2 #59 A04)
- G4-0538 — placed (§2 #59 A04)
- G4-0539 — placed (§2 #59 A04)
- G4-0540 — placed (§2 #59 A04)
- G4-0541 — placed (§2 #59 A04)
- G4-0542 — placed (§2 #59 A04)
- G4-0543 — placed (§2 #59 A04)
- G4-0544 — placed (§2 #59 A04)
- G4-0545 — placed (§2 #59 A04)
- G4-0546 — placed (§2 #59 A04)
- G4-0547 — placed (§2 #59 A04)
- G4-0548 — placed (§2 #59 A04)
- G4-0549 — placed (§2 #59 A04)
- G4-0550 — placed (§2 #59 A04)
- G4-0551 — placed (§2 #59 A04)
- G4-0552 — placed (§2 #59 A04)
- G4-0553 — placed (§2 #59 A04)
- G4-0554 — placed (§2 #59 A04)
- G4-0555 — placed (§2 #59 A04)
- G4-0556 — placed (§2 #60 A05)
- G4-0557 — placed (§2 #60 A05)
- G4-0558 — placed (§2 #60 A05)
- G4-0559 — placed (§2 #60 A05)
- G4-0560 — placed (§2 #60 A05)
- G4-0561 — placed (§2 #60 A05)
- G4-0563 — placed (§2 #60 A05)
- G4-0564 — placed (§2 #58 A03)
- G4-0565 — placed (§2 #60 A05)
- G4-0570 — placed (§2 #60 A05)
- G4-0580 — placed (§2 #12 D12)
- G4-0584 — placed (§2 #60 A05)
- G4-0590 — placed (§2 #12 D12)
- G4-0592 — placed (§2 #60 A05)
- G4-0595 — placed (§2 #60 A05)
- G4-0596 — placed (§2 #12 D12)
- G4-0597 — placed (§2 #12 D12)
- G4-0598 — placed (§2 #12 D12)
- G4-0599 — placed (§2 #12 D12)
- G4-0600 — placed (§2 #12 D12)
- G4-0601 — placed (§2 #34 C19)
- G4-0607 — placed (§2 #58 A03)
- G4-0611 — placed (§2 #12 D12)
- G4-0629 — placed (§2 #34 C19)
- G4-0630 — placed (§2 #34 C19)
- G4-0635 — placed (§2 #12 D12)
- G4-0636 — placed (§2 #58 A03)
- G4-0721 — placed (§2 #51 R04)
- G4-0722 — placed (§2 #51 R04)
- G4-0877 — placed (§2 #51 R04)
- G5-0002 — placed (§2 #48 R01)
- G5-0003 — placed (§2 #48 R01)
- G5-0004 — placed (§2 #48 R01)
- G5-0005 — placed (§2 #48 R01)
- G5-0006 — placed (§2 #50 R03)
- G5-0007 — placed (§2 #48 R01)
- G5-0008 — placed (§2 #48 R01)
- G5-0012 — placed (§2 #51 R04)
- G5-0021 — placed (§2 #51 R04)
- G5-0022 — placed (§2 #51 R04)
- G5-0028 — placed (§2 #51 R04)
- G5-0029 — placed (§2 #51 R04)
- G5-0034 — placed (§2 #51 R04)
- G5-0036 — placed (§2 #51 R04)
- G5-0037 — not this world → Bindu Learning (content file, learning lake)
- G5-0038 — placed (§2 #51 R04)
- G5-0039 — placed (§2 #51 R04)
- G5-0044 — placed (§2 #51 R04)
- G5-0050 — placed (§2 #45 L04)
- G5-0089 — placed (§2 #9 D09)
- G5-0102 — placed (§2 #51 R04)
- G5-0118 — placed (§2 #7 D07)
- G5-0247 — placed (§2 #51 R04)
- G5-0273 — placed (§2 #48 R01)
- G5-0275 — placed (§2 #51 R04)
- G5-0277 — placed (§2 #8 D08)
- G5-0283 — placed (§2 #9 D09)
- G5-0284 — placed (§2 #9 D09)
- G5-0285 — placed (§2 #9 D09)
- G5-0286 — placed (§2 #9 D09)
- G5-0288 — placed (§2 #51 R04)
- G5-0289 — placed (§2 #51 R04)
- G5-0290 — placed (§2 #51 R04)
- G5-0293 — to Bindu Feed (§6: the thirteen teachings)
- G5-0297 — placed (§2 #48 R01)
- G5-0303 — placed (§2 #41 S01)
- G5-0322 — placed (§2 #51 R04)
- G5-0323 — placed (§2 #51 R04)
- G5-0327 — placed (§2 #48 R01)
- G5-0339 — placed (§2 #45 L04)
- G5-0482 — placed (§2 #20 C05)
- G5-0505 — placed (§2 #51 R04)
- G5-0533 — placed (§2 #51 R04)
- G5-0540 — placed (§2 #51 R04)
- G5-0541 — placed (§2 #51 R04)
- G5-0543 — placed (§2 #51 R04)
- G5-0544 — placed (§2 #51 R04)
- G5-0548 — placed (§2 #51 R04)
- G5-0552 — placed (§2 #45 L04)
- G5-0553 — placed (§2 #45 L04)
- G5-0554 — placed (§2 #1 D01)
- G5-0558 — placed (§2 #51 R04)
- G5-0560 — placed (§2 #51 R04)
- G5-0561 — placed (§2 #51 R04)
- G5-0566 — placed (§2 #9 D09)
- G5-0567 — placed (§2 #45 L04)
- G5-0575 — placed (§2 #51 R04)
- G5-0576 — placed (§2 #51 R04)
- G5-0579 — placed (§2 #9 D09)
- G5-0581 — placed (§2 #9 D09)
- G5-0582 — placed (§2 #9 D09)
- G5-0618 — placed (§2 #9 D09)
- G5-0621 — placed (§2 #9 D09)
- G5-0624 — placed (§2 #9 D09)
- G5-0636 — placed (§2 #51 R04)
- G5-0654 — placed (§2 #9 D09)
- G5-0664 — placed (§2 #51 R04)
- G5-0665 — placed (§2 #51 R04)
- G5-0667 — placed (§2 #9 D09)
- G5-0668 — placed (§2 #9 D09)
- G5-0673 — placed (§2 #51 R04)
- G5-0677 — placed (§2 #51 R04)
- G5-0699 — placed (§2 #51 R04)
- G5-0703 — placed (§2 #51 R04)
- G5-0705 — placed (§2 #51 R04)
- G5-0706 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0708 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0711 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0712 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0715 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0716 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0717 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0720 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0721 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0723 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0724 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0725 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0726 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0730 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0732 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0733 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0734 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0735 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0738 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0739 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0741 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0742 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0743 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0744 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0745 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0747 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0748 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0749 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0750 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0751 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0752 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0753 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0755 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0756 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0758 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0759 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0760 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0761 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0762 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0763 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0764 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0765 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0766 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0768 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0769 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0770 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0771 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0772 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0773 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0774 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0775 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0776 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0777 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0779 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0781 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0784 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0785 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0786 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0788 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0790 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0792 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0793 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0795 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0796 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0797 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0798 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0801 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0802 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0803 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0804 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0805 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0807 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0809 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0810 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0811 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0814 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0817 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0818 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0819 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0820 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0821 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0822 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0823 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0824 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0825 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0827 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0828 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0829 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0830 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0833 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0835 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0836 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0838 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0840 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0841 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0842 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0844 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0845 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0846 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0847 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0848 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0849 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0850 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0851 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0852 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0853 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0855 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0858 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0859 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0861 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0862 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0863 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0865 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0866 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0867 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0868 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0869 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0870 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0871 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0873 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0876 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0877 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0878 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0879 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0881 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0882 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0883 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0884 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0886 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0887 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0889 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0890 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0891 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0893 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0894 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0895 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0897 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0898 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0899 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0900 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0901 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0904 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0905 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0907 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0908 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0909 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0910 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0914 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0916 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0917 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0918 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0919 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0920 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0922 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0923 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0924 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0925 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0926 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0927 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0928 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0931 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0934 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0936 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0937 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0938 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0939 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0940 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0942 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0943 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0945 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0946 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0947 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0948 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0949 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0950 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0951 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0952 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0953 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0954 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0956 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0958 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0960 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0962 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0964 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0965 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0966 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0967 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0968 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0969 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0970 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0971 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0973 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0974 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0975 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0976 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0979 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0980 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0981 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0983 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-0984 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0986 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0987 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0990 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0991 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0992 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0993 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0994 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0997 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0998 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-0999 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1000 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1001 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1002 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1003 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1004 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1005 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1006 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1009 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1011 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1013 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1014 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1015 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1016 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1017 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1018 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1020 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1021 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1022 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1023 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1024 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1025 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1026 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1027 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1030 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1032 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1033 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1034 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1035 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1036 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1037 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1039 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1041 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1043 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1044 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1047 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1049 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1050 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1051 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1052 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1054 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1055 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1056 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1058 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1059 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1062 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1063 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1064 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1065 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1066 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1068 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1069 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1070 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1071 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1072 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1073 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1074 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1078 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1079 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1080 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1081 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1085 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1087 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1088 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1089 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1090 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1093 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1094 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1097 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1104 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1105 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1114 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1117 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1118 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1129 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1132 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1133 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1134 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1137 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1141 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1145 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1163 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1169 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1170 — rejected (floor: hold list — never built; §2 #50 R03)
- G5-1175 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1176 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1178 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1180 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1184 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1191 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1192 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1206 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1210 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1214 — placed (§2 #49 R02) → not this world: Bindu Learning
- G5-1216 — rejected (floor: hold list — never built; §2 #50 R03)
- G6-0481 — placed (§2 #8 D08)
- G6-0482 — placed (§2 #8 D08)
- G6-0483 — placed (§2 #8 D08)
- G6-0484 — placed (§2 #8 D08)
- G6-0485 — placed (§2 #29 C14)
- G6-0486 — placed (§2 #32 C17)
- G6-0490 — placed (§2 #8 D08)
- G6-0493 — placed (§2 #8 D08)
- G6-0494 — placed (§2 #35 B01)
- G6-0610 — placed (§2 #28 C13)
- G6-0619 — placed (§2 #23 C08)
- G6-0620 — placed (§2 #9 D09)
- G6-0621 — placed (§2 #9 D09)
- G6-0623 — placed (§2 #8 D08)
- G6-0625 — placed (§2 #14 D14)
- G6-0626 — placed (§2 #14 D14)
- G6-0627 — placed (§2 #14 D14)
- G6-0628 — placed (§2 #14 D14)
- G6-0629 — placed (§2 #14 D14)
- G6-0630 — placed (§2 #14 D14)
- G6-0631 — placed (§2 #14 D14)
- G6-0632 — placed (§2 #10 D10)
- G6-0633 — placed (§2 #48 R01)
- G6-0634 — placed (§2 #11 D11)
- G6-0635 — placed (§2 #14 D14)
- G6-0636 — placed (§2 #14 D14)
- G6-0638 — placed (§2 #14 D14)
- G6-0639 — placed (§2 #14 D14)
- G6-0640 — placed (§2 #14 D14)
- G6-0641 — placed (§2 #15 D15)
- G6-0643 — placed (§2 #14 D14)
- G6-0644 — placed (§2 #8 D08)
- G6-0645 — placed (§2 #13 D13)
- G6-0650 — placed (§2 #6 D06)
- G6-0654 — placed (§2 #15 D15)
- G6-0655 — placed (§2 #1 D01)
- G6-0656 — placed (§2 #15 D15)
- G6-0661 — placed (§2 #15 D15)
- G6-0685 — placed (§2 #14 D14)
- G6-0686 — placed (§2 #13 D13)
- G6-0724 — placed (§2 #1 D01)
- G6-0768 — placed (§2 #15 D15)
- G6-0774 — placed (§2 #13 D13)
- G6-0776 — placed (§2 #15 D15)
- G6-0777 — placed (§2 #15 D15)
- G6-0778 — placed (§2 #15 D15)
- G6-0784 — placed (§2 #1 D01)
- G6-0787 — placed (§2 #42 L01)
- G6-0925 — placed (§2 #23 C08)
- G6-0926 — placed (§2 #22 C07)
- G6-0936 — placed (§2 #36 B02)
- G6-0944 — placed (§2 #3 D03)
- G6-0945 — placed (§2 #3 D03)
- G6-0946 — placed (§2 #52 K01)
- G7-0007 — placed (§2 #2 D02)
- G7-0024 — placed (§2 #6 D06)
- G7-0028 — placed (§2 #54 K03)
- G7-0089 — placed (§2 #7 D07)
- G7-0099 — placed (§2 #55 K04)
- G7-0129 — placed (§2 #4 D04)
- G7-0134 — placed (§2 #5 D05)
- G7-0136 — placed (§2 #54 K03)
- G7-0142 — placed (§2 #7 D07)
- G7-0225 — placed (§2 #51 R04)
- G7-0227 — placed (§2 #62 H01)
- G7-0231 — placed (§2 #43 L02)
- G7-0236 — placed (§2 #54 K03)
- G7-0285 — placed (§2 #7 D07)
- G7-0307 — placed (§2 #7 D07)
- G7-0316 — placed (§2 #37 B03)
- G7-0322 — placed (§2 #7 D07)
- G7-0337 — placed (§2 #7 D07)
- G7-0482 — placed (§2 #33 C18)
- G7-0492 — placed (§2 #35 B01)
- G7-0510 — placed (§2 #22 C07)
- G7-0512 — placed (§2 #46 L05)
- G7-0525 — placed (§2 #54 K03)
- G7-0528 — placed (§2 #46 L05)
- G7-0547 — placed (§2 #54 K03)
- G7-0549 — placed (§2 #54 K03)
- G7-0568 — placed (§2 #39 B05)
- G7-0571 — placed (§2 #37 B03)
- G7-0590 — placed (§2 #46 L05)
- G7-0595 — placed (§2 #15 D15)
- G7-0607 — placed (§2 #62 H01)
- G7-0613 — placed (§2 #52 K01)
- G7-0616 — placed (§2 #7 D07)
- G7-0619 — placed (§2 #38 B04)
- G7-0626 — placed (§2 #38 B04)
- G7-0657 — placed (§2 #55 K04)
- G7-0658 — placed (§2 #6 D06)
- G7-0659 — placed (§2 #6 D06)
- G7-0660 — placed (§2 #42 L01)
- G7-0661 — placed (§2 #6 D06)
- G7-0662 — placed (§2 #42 L01)
- G7-0663 — placed (§2 #42 L01)
- G7-0665 — placed (§2 #42 L01)
- G7-0666 — placed (§2 #42 L01)
- G7-0667 — placed (§2 #42 L01)
- G7-0668 — placed (§2 #42 L01)
- G7-0672 — placed (§2 #52 K01)
- G7-0677 — placed (§2 #22 C07)
- G7-0686 — placed (§2 #27 C12)
- G7-0719 — placed (§2 #39 B05)
- G7-0823 — placed (§2 #43 L02)
- G7-0824 — placed (§2 #43 L02)
- G7-0825 — placed (§2 #43 L02)
- G7-0826 — placed (§2 #43 L02)
- G7-0827 — placed (§2 #43 L02)
- G7-0828 — placed (§2 #43 L02)
- G7-0829 — placed (§2 #43 L02)
- G7-0830 — placed (§2 #43 L02)
- G7-0831 — placed (§2 #43 L02)
- G7-0832 — placed (§2 #43 L02)
- G7-0833 — placed (§2 #43 L02)
- G7-0834 — placed (§2 #43 L02)
- G7-0835 — placed (§2 #43 L02)
- G7-0836 — placed (§2 #43 L02)
- G7-0837 — placed (§2 #43 L02)
- G7-0838 — placed (§2 #43 L02)
- G7-0839 — placed (§2 #43 L02)
- G7-0840 — placed (§2 #43 L02)
- G7-0841 — placed (§2 #43 L02)
- G7-0842 — placed (§2 #43 L02)
- G7-0843 — placed (§2 #43 L02)
- G7-0844 — placed (§2 #52 K01)
- G7-0845 — placed (§2 #52 K01)
- G7-0846 — placed (§2 #52 K01)
- G7-0847 — placed (§2 #52 K01)
- G7-0848 — placed (§2 #52 K01)
- G7-0849 — placed (§2 #52 K01)
- G7-0850 — placed (§2 #52 K01)
- G7-0851 — placed (§2 #52 K01)
- G7-0852 — placed (§2 #52 K01)
- G7-0853 — placed (§2 #52 K01)
- G7-0854 — placed (§2 #7 D07)
- G7-0855 — placed (§2 #7 D07)
- G7-0856 — placed (§2 #7 D07)
- G7-0857 — placed (§2 #7 D07)
- G7-0858 — placed (§2 #7 D07)
- G7-0859 — placed (§2 #7 D07)
- G7-0860 — placed (§2 #7 D07)
- G7-0861 — placed (§2 #7 D07)
- G7-0862 — placed (§2 #7 D07)
- G7-0863 — placed (§2 #7 D07)
- G7-0870 — placed (§2 #39 B05)
- G7-0871 — placed (§2 #39 B05)
- G7-0872 — placed (§2 #39 B05)
- G7-0873 — placed (§2 #39 B05)
- G7-0874 — placed (§2 #39 B05)
- G7-0875 — placed (§2 #39 B05)
- G7-0876 — placed (§2 #39 B05)
- G7-0877 — placed (§2 #39 B05)
- G7-0878 — placed (§2 #39 B05)
- G7-0879 — placed (§2 #39 B05)
- G7-0880 — placed (§2 #39 B05)
- G7-0881 — placed (§2 #1 D01)
- G7-0882 — placed (§2 #1 D01)
- G7-0883 — placed (§2 #1 D01)
- G7-0932 — placed (§2 #43 L02)
- G7-0937 — placed (§2 #1 D01)
- G7-1024 — placed (§2 #62 H01)
- G7-1026 — placed (§2 #38 B04)
- G7-1029 — placed (§2 #27 C12)

**Script check (dw_gen.py, run 13 Oct):**

```
slice rows: 995 · unique ids: 995 · marked: 995 · missing: 0 · unknown ids: 0 · not this world: 1 · placed: 960 · rejected: 33 · to Bindu Feed: 1
```
