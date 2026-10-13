# THE REGISTER · 17 — The code core (Services · Models · Data · Theme · the app root)

*Reader 17 of the second reading · written 2026-10-12 · CODE reader. Every assigned file was read in full with the Read tool, line 1 to EOF (§D). Nothing in the repo was modified except this file. Register items in `01–07` were found by grep (lookup only). Where I checked a call site in `Views/` or `Homes/` (not my assignment), I mark it **[lookup]**: it is a grep result, not a reading.*

**Where the code lives.** The task named `iOS/Bindu Mandala/Bindu Mandala/`. That folder does not exist. The source root is **`/home/claude/bindu-mandala/iOS/Bindu Mandala/`**, and FIDELITY.md is at `/home/claude/bindu-mandala/iOS/FIDELITY.md`. There is no `CLAUDE.md` and no `README*` at the repo root (`ls` checked). All paths below are relative to the source root.

**Keys used below.**
- **Worlds:** W1 Home/the Bindu · W2 Today/the Rite · W3 the Mandala (+Veil) · W4 the nine rings · W5 Her Home · W6 Her Presence · W7 the Climb (Axis) · W8 the 33 · W9 A Strange Game · W10 the Modes · W11 Time · W12 Memory · W13 the Well · W14 Beneath · W15 the Relationship Field. *All* means every world (a spine service).
- **Threads:** kp (her position 1–102) · ch (chakra road 1–33) · day.
- **Register IDs:** `01` H-* · `02` R-*/L-*/X-* · `03` A0.*/CX-*/VL-* · `04` DS-*/FB-*/MBB-*/WV-*/RD-* · `05`/`06` chakra tables · `07` C-numbers and §C.3 flags.

---

# A · Inventory: a map of every file

Each entry gives: **lines** · **what it does** · **worlds** · **register items** · **data** (Airtable field ids, App Activity types, local stores) · **rules hard-coded in it** · **defects or dead code**.

## A0 · The app root and FIDELITY

### `BinduMandalaApp.swift` · 206
- **Does.** `AppRuntime` launch flags (73 lines). `@main` builds the container through `PersistenceRecovery` (84) and installs `GiftRouter` before launch finishes (87). `WindowGroup { AppRoot().herSiddhiLingers().preferredColorScheme(.dark) }` (92–96).
  - `AppRoot` puts `RootView()` in a ZStack and lays `HomecomingView` over it on **every** launch (110–127). The first launch gets the whole Origin; later launches get one breath.
  - Scene phase: `.active` flushes the ledger queues, reschedules the summons and the gift, and flushes `PracticeLedger` (138–144). `.background` stops `RingAudioService`, `HomeSoundService` and the `SoundConductor` Om (148–151).
  - Notification permission waits until the Homecoming is gone (171–192). A 300 s re-sync loop runs while active (193–204).
- **Flags.** `SYNC_OFF` / `BINDU_SYNC_OFF=1` (16–18) · `SKIP_SUMMONS` (22) · `EPHEMERAL_STORE` (DEBUG, 33–39) · `REDUCE_MOTION` (DEBUG, 51–57) · `ENERGY_POS=n`, last one wins, **not** DEBUG-gated (68–72) · `FORCE_/SKIP_HOMECOMING` (112–113).
- **Worlds.** W1 (Homecoming), all.
- **Register.** `04` FB-16 (launch into the Mandala), MBB-09/10 (Rite as the launch destination). C-1325 (the Origin).
- **Hard-coded rule.** Launch goes to `RootView`. Per the **[lookup]** of `Views/Root/RootView.swift:9–32`, `RootView` restores the last of five destinations (`mandala, rite, well, the102, memory`) for the same day. This is **not** "launch arrives at the Bindu" (ruling 1). See C-1.
- **Defect.** `pinnedEnergyPosition` (68–72) is honoured in release builds. It is harmless, but it is a test hook in shipped code.

### `iOS/FIDELITY.md` · 132
- **Does.** The design-fidelity checklist and the Tier 0–3 record.
- **Sources of truth (6–11).** Design (look and motion only) is `Claude Design Round 2/prototype/living-rite-*.jsx` + `index.html` + `shakti-data.js`. Names and content come from **Airtable for all 102**. `all-shaktis-data.js` is archived ("never read it as data").
- **Eight-point screen checklist (13–45).** Atmosphere layers · composition · reduce-motion gating every loop · legibility (≥11 pt, ≥0.5 cream α, ≥44 pt targets) · tokens not literals · graceful degradation (only phonetic, bīja and cluster are Ring-2-only; never print "INNER INSTRUMENT") · device verification on 17 Pro Max + SE · an adversarial panel for zoom work.
- **The spine (63–99)** has no surface, so every spine change needs an owner: DailyEnergyService, DailySummons, LunarPhaseService, RecognitionMigrator, DescentState (mirror-once), ActivityLedger, AirtableService, SilenceDwell, PersistenceRecovery, HomeSoundService. "Every number in `homes-sound.js` lives in `HomeCarrier` and nowhere else" (92) and `HomeSoundTests` asserts them.
- **Stretch dispositions (101–132).** Ring-drone superseded by the Homes carrier · WidgetKit parked · MandalaLight built (gem = behaviour, never colour; veil inputs only ring, nearness and stillness; legibility floor; Tratak 20 s) · idea 32 ruled out · `.silence` "reborn as the dwelling".
- **Defects.**
  - 127–132 still says the silence writer has "zero call sites until 3.6 lands". It is now wired by `HomeDwelling` (§A3).
  - 109 says MandalaLight is "behind `MandalaLight.enabled`". The flag defaults **on** (`MandalaLight.swift:366–373`), so this is accurate but reads as if it were off.

## A1 · Data

### `Data/AirtableService.swift` · 2419 — the one network writer and reader
- **Constants.** Base `app248ZTWhYJlvQj2`, Mandala table `tblrRwXJD0uP8HU8G` (43–44). Avaraṇa record ids → ring, rings 1–9: `rec0XhDKfxW8UVyaB … recqdC3D38TWFkf1M` (50–60). PAT comes from Info.plist `AIRTABLE_PAT` (70–75).
- **`sync` (123–169), in order:**
  1. `flushPending`
  2. `restoreNotesFromLedger` (before anything that can throw)
  3. fetch Shakti / Avarana / Nitya rows by `{fldw33m8YqrINlvrN}` row type
  4. reconcile all three
  5. ledgered-letter and milestone dedup
  6. restore recognitions and descent if local is empty
  7. `restoreRiverFromLedger`
- **Shakti field ids (270–296):**

  | Field | Id | Field | Id |
  |---|---|---|---|
  | sanskritName | fldJOatnYrw9l6tff | devanagari | fldDhcJ1BJQCM5llO |
  | quality | fldnwcu7zv7uV1ta2 | qualityDescription | fldTwrtI5CyUnJV2F |
  | clusterGroup | fld1HO6HwMH8fSwS3 | esotericTattva | fldxylgY985SwqdJE |
  | somaticSignature | fld6CylZqbIZQIUOp | bodilyLocation | fld6P1u43B0eqKU5e |
  | bija | fldnOqkWcvjQNxpWl | fieldConnection | fldsk2ATEtTVB87eb |
  | status | fldDiihcxC54WKPhT | khadgamalaPosition | fldI0aV1sfOeNybHI |
  | iconography | fldXJEBCQxLdHWGuP | codexPortrait | fldlcmg7wtfIxgcZu (polymorphic) |
  | etymology | fldXypzqrhVILCqgh | appreciationPhrase | fldBqEDpBonMc2s1K |
  | function | fldzT3dAhsAK75rKN | family | fldYAlclWH7CfJhOg |
  | lastFelt | fldWT0dGqdUQrdRGT | recognitionCount | flddp0tLpf8iuxyt4 |
  | letter | fldgASyV031Hr4sHp | **Score JSON** | fldz1vCCMpXiw8s1n |
  | **phonetic** | fldadDCi4OJYEaAFX | **seedVerb** | fldVgkRZmbc7STB7S |
  | **related** | fldQNnFoom72Nr6vh | **relatedFrom** | fldtAau1NIP4QDZrk |

- **Avaraṇa field ids (327–343):**

  | Field | Id | Field | Id |
  |---|---|---|---|
  | gem | fldWlbdPNpmqPvfMj | dhātu | fldVjcApdGFVrIfq1 |
  | timeCycle | fldZLBoLGegod2xfy | beeja | fldixnYtJ30lZEDJM |
  | bodyRegion | fld6Ucmi8YqeAbOXU | **siddhi** | fldx9jXyTVWxp19o1 |
  | **mudra** | fld1C14f4MsVIrA9F | **phase** | fldKWGAI16XjdqoI3 |
  | **notes** | fld1HR38cQAtEicFc | subtitle | fldXTUBJTDlkKEzEV |
  | presidingForm | fldgHVP1LqoVJsYu8 | mentalState | fld8p7FtKqEKvSy7P |
  | subtleBodyChakra | fld6deGFzModjBmoj | geometricShape | fldNqYFRn8x4F9jR0 |
  | personalConnection | fldlcmg7wtfIxgcZu | yogini | fldcqAvdN3wcP8BhT |

  Nityā `tithiPosition` is `fldVWZLCy5YFJMkCp` (357).
- **`reconcileShaktis` (365–489).**
  - Identity is kp. A ring-2 row from before Phase 1 is adopted by its per-ring index (377–381).
  - `somaticSignature` goes into **`somaticPoetry`**. The bootstrap prompt `somatic` is never overwritten (410–416).
  - **fieldConnection is seeded only when local is empty**, because it is practitioner-owned (420–427).
  - Status only ever advances (441–447). The server letter is seeded only when no local draft exists (454–457). A live phonetic is preferred (463–465).
  - **Related Śaktis are resolved to kp from record links in both directions** → `ShaktiFactsCache` (467–487).
- **Restores.**
  - Recognitions from `Shakti Recognized` + `Silence Held` (518–557).
  - Descent from `Ring Crossed` (575–597).
  - Her Moments, the newest 5, paged at most 5 pages (710–761).
- **Writes.**
  - `RecognitionSource` = Today · Mandala · Field · Room · Silence · Well · Play (770–778). There is **no Chakra, Climb, Rite-station or Game-specific source**.
  - Recognition write, four round-trips: dedup GET → read count → POST ledger row → PATCH Last Felt + Count (894–944). **Full Circle** is checked only on a first recognition (963–978).
  - `advanceStatus` is a manual, advance-only PATCH of Status (1069–1104).
  - Crossings fire only on a new deepest ring (1151–1229). Letters: PATCH `Letter` + a once-per-Śakti `Letter Written` (1248–1363).
  - `logActivity` is the one writer (1385–1403). `recordSilence` (1415). Milestones, with the remember/write decision table (1433–1517). Map-keyed dedup for the two thresholds (1605–1614).
  - Margin notes have their own queue of record, plus the `notesInFlight` interlock (1709–1762). The notes restore merges by identity (1811–1843).
  - `PendingQueuePolicy.maxFailures = nil`: **never drop** (2047–2050). `RecognitionDedup` ±60 s, second precision (2157–2222).
  - Grace read (2232). **Gratitude read: his journal, one column** (2254–2270). Codex create (2286–2368). River restore (2380–2418).
- **Worlds.** All (spine).
- **Register.** `04` FB-03..FB-06, FB-22, FB-24, FB-27 · `01` H-ARCH §1 (position is identity, option 3) · `02` L-19 (Her Moments), L-21 (Well) · `07` C-1325, C-1346, C-1126.
- **Rules.** Practice data is never lost (2041–2046). No count ever shown (956, 1467). The local store is the read-time truth (14–17). Typecast creates new select options (1624–1626).
- **Defects.**
  - Stale comments: 1414 ("Zero call sites until Phase 3.6") and 1699–1707 (the activity queue "dropped an item after three failed flushes (until Wave 0)"). The rationale is now moot.
  - `RecognitionSource` lacks a chakra or climb source, so the `Chakra Practiced` builder writes `Gesture Source = Mandala` (see ActivityLedger 461).

### `Data/ActivityLedger.swift` · 1371 — the vocabulary (pure)
- **App Activity table** `tblJlBeiHnqGpYrL7`, Source App "Mandala" (31–34).
- **Field names and ids (38–73):**

  | Field | Id |
  |---|---|
  | Activity Name | fldqAZ3xmkQwHaJQm |
  | Source App | fldHPuwmYPa3Ry91q (Learning · Mandala · Field · Feed · Being · Chakras · Mirror) |
  | Activity Type | fldXNRBZy6QvIP8yz |
  | Activity Date | fldMcikl2kbVRFv4G |
  | Detail | fldFWURRpDmzcSAvl |
  | Notes | fldVyj4hkzxcrIBoJ |
  | Link to Mandala | fldzsEMInQmNIxTNu |
  | Felt At | fldWAR0B4pNxjTwEJ |
  | Lunar Day | fldJc7iCzxZOSdO4D |
  | Moon Phase | fldMpjvAsT64v85bh |
  | Gesture Source | fldP3wq8QTgxeTDuC (sel ids at 62–63) |
  | Descent Ring | fldi7SOuep57UoXzi |
  | Duration (sec) | fldrIOx1id7Esm2fd |
  | **Link to The Map** | fldkF65ySNGGkeugH → `tblwpmyKOeMxEEHd7` |

- **Activity Types (79–166) — the whole ledger vocabulary:**
  Shakti Recognized · Letter Written · Ring Crossed · Silence Held · Full Circle · First Dwelling · Note Left · State Set Down · Siddhi Received · Played · Letter Sealed · Letter Opened · Portrait Drawn · Wager Resolved · Witness Written · Garland Recited · Day Offered · Leela Drop · Light Entered · Chakra Practiced · Light Sent Back · Name Kept.
- **Builders, with their composed words:**
  - recognition: "— first recognition" / "— felt again" (276–292)
  - crossing: "Fell inward to the {form}" (296–306)
  - letterWritten (317)
  - silence (324)
  - stateSetDown: "offered" (C-1230) (352–366)
  - siddhiReceived (370)
  - mauna (kp 102) (390)
  - played: default site "Lalitā's field" (416–433)
  - **chakraPracticed** (446–469)
  - noteLeft: constant name, because the harness runs MEASURING patterns over composed strings (488–523)
  - letterSealed: recipients her, age (spelled out), memory, past self, later self (532–562)
  - letterOpened (566)
  - portraitDrawn (583)
  - wagerResolved: "noticed in passing" (597–611)
  - leelaDrop (620)
  - **lightEntered**, Knowledge · Will · Action (638–652)
  - lightSentBack (659)
  - nameKept (677)
- **Pure mappers.** River restore (736–873), notes restore (916–989), `wasFirst` (995), `fields(for:)` payload (1015–1041), formulas (1057–1117), legacy shadowing (1243–1294).
- **Milestones** are never shown (194–207, 191–193). "Deepest Ring Reached" is dropped as a duplicate (171–178).
- **Worlds.** All. It is the Memory pool (see ThreePools).
- **Register.** `04` FB-06 · `07` C-1230, C-1195, C-1126, C-1325, C-1280 · `02` L-21.
- **Rules.** Notes are his words only, never composed (24–25). No count in any name or detail (ActivityLedgerRites 6–8).

### `Data/ActivityLedgerRites.swift` · 69
- `witnessWritten` (C-1280, 14–27) · `garlandRecited`: "The whole garland, offered back" / "Recited inward to the {n} enclosure", linked to the point's row (32–52) · `dayOffered` / Pūjā (56–68).
- **Worlds.** W10 Modes, W2.

### `Data/BinduSchema.swift` · 356
- `BinduSchemaV1` (6 models, the nested V1 `ShaktiLetter` keyed 1–16). `V2` adds `HomeMemory` and keys letters by kp. `V3` adds `MarginNote` (32–117). `BinduSchema.latest` (122–129).
- The migration plan's `lettersOntoKhadgamalaKey` stage is custom, with a **fsync'd sidecar** (172–240). `quarantineKey` = 1000+ zig-zag (246–248). `LetterMigrationStash` (267–356).
- **Law.** "Never mutate a shipped version's model list" (106–108). The note on Ruling 2 says the descent is memory-only, not a gate (21–23).
- **Worlds.** All. Of note: **there is no SwiftData model for chakras, games, modes, rites, river, Portrait, wagers or the Relationship Field.** All of those live in `PracticeVault` JSON files.

### `Data/CodexWrite.swift` · 129
- Codex `tblDF4OCMcRoxkQjU`. Title `fldxmZqObGiIoHHll` · Date `fldth1fgVdc2HgIyn` · RAW `fld459YeVBZBgB8zh` · Source App `fldaii08WVwJQA5qP` = "Bindu Mandala" (`selhkTEAbJE3DUuce`) · **Status `fldisxPP9sNKMyiYb` is never written** (17–36).
- Title clip is 80 chars with the fallback "A word from the Mandala" (47–55). Dedup is by day + normalised body (71–101). `PendingCodexNote`; `CodexNote` carries `origin` + `voiceFile` (104–129).
- **Worlds.** W12, W13, W11 (the month). Writes one table outside the ledger ("his note, not an event").

### `Data/PersistenceRecovery.swift` · 123
- Order: ephemeral (DEBUG) → primary with the plan → preserve aside as `.corrupt-<stamp>`, keeping the two newest → fresh → in-memory → `fatalError` (31–79, 84–122).
- **Worlds.** All.

### `Data/RingFactsCache.swift` · 72
- UserDefaults `ringFacts.v1`: gem, dhātu, timeCycle, beeja, bodyRegion, **siddhi, mudra, phase, notes** (19–37).
- `phaseWords` → Sṛṣṭi / Sthiti / Saṃhāra (40–48). Rule: "Words naming a hand are language, never an image" (31).
- **Worlds.** W4 (each ring's own material), W3 (the Veil reads `notes`), W8 (thresholds name the phase).

### `Data/ShaktiFactsCache.swift` · 211
- UserDefaults `shaktiFacts.v1`: scoreJSON, phonetic, seedVerb, related[kp] (17–76).
- **`sister(of:)`** is the third neighbour door: the first related seat. Namesake pairs 19↔53 … 23↔62, and 55 → 21 (55–69).
- **`ShaktiScore`** (93–211), decoded tolerantly:
  - light {hue 0–360 or hex, glow 0–1}
  - tempo {breath 2–60 s "read through the one breath clock", rate 0.25–4}
  - sound {carrier_hz 20–2000, fifth withheld / granted / ground, ground 0–1}
- **Worlds.** W5 (her room tuned live from Airtable), W6, W15 (related seats form a relationship graph).

### `Data/ShaktiBootstrap.swift` · 303
- The offline seed of **only the 16 Karṣiṇīs** (11–274). Each has name, shortName, phonetic, quality, qualityDescription, somatic prompt, somaticPoetry, bīja, bodilyLocation, tattva, recognitionPhrase ("You are extraordinary for bringing me this …"), cluster and status.
- `seedIfNeeded` assigns ring 2 and kp = position + 28 (278–288). `seedDescentIfNeeded`: current 2, deepest 2, "Ring 2 is the lived home" (290–302).
- **Field connections:** pos 3 (kp 31) **Gaia** (59–60) · pos 12 (kp 40) **Ashrey** (205–206) · pos 14 (kp 42) **Ram** (239–240). Each has a fieldNote in his voice. **This is the only Relationship Field data in the app.**
- **Worlds.** W2, W5, W6, W15.
- **Register.** `04` DS-09 (the 16 with bījas), DS-07 (status opacity).
- **Defects (detail in C-3, C-5).**
  - Tattva for kp 31/40/42/43 = Space / Space / "Pure Being (Sat)" / "Nectar (Amṛta)" (53, 201, 235, 253). This contradicts ruling 4.
  - **The bīja series is shifted:** 9 `lṁ` (should be ḷṁ), 10 `eṁ` (skips ḹṁ), 14 `aṃ`, 16 **`kaṁ`** (151–267). `kaṁ` is not one of the sixteen vowels (C-5).
  - Seeded statuses (embodied, active …) hand a fresh install a progress state.

### `Data/GameStructure.json` · 211 (md5 6e37a350)
- Baked 2026-10-12 from Identity `tbluLyZj9ilH2RhIg` and Map `tblwpmyKOeMxEEHd7` (1–7).
- **panels 1–9** (8–81): verb · declaration · seed · identityRecord · mapRecord.

  | Ring | Verb | Seed |
  |---|---|---|
  | 1 | Press | "The earth that holds you was chosen by you." |
  | 2 | Follow | "Every desire was drawing you toward yourself." |
  | 3 | Build | "The fire that agitated you was building your form." |
  | 4 | Open | "The love that arrived for others was always your own heart opening." |
  | 5 | Speak | "What you finally said out loud was what you always knew." |
  | 6 | Still | "You stopped looking and the seeing arrived on its own." |
  | 7 | Receive | "The disease that was removed was the belief that you were less than what you are." |
  | 8 | Hold | "Will. Knowledge. Action. You already know. You have always known." |
  | 9 | Dissolve | **"There was never anything to fear. There was only the Bindu, playing."** (77) — ruling 8 conflict (C-4) |

- **axis** (82–86): verb "Access", "I access the spine that holds all the chakras. The line is what was singing all along." **Not decoded by `GameStructure.File`, so it is dead data.**
- **faces** (87–118): gaia, bindu, lalita, sakshi, higherSelf, one line each, e.g. Gaia: "I receive. I hold. I orchestrate the conditions before the question is asked. Solutions appear before problems are named."
- **practices** (119–144): Sacred Pause · Sri Yantra Tratak · Morning Intention · Evening Reflection.
- **leelaDrops** (145–210): eight drops — shadow (sakshi), forge (bindu), intention / inspiration / incarnation / integration (gaia), maya (lalita), aatma (higherSelf). Each has a lead and a real-world action.
- **Worlds.** W7, W9, W3, W10.

### `Data/ChakraConstellation.json` · 1642 (md5 70211e07)
- Baked 2026-10-12 from the Map + Mandala tables, C-1343..1345. **33 records, 44 keys each** (identical key set, checked by script).
- **Keys:** road, recordId, name, subtitle, sanskrit, kind, system, stage, sectionNumber, avaranaField, avarana, kp[], address, crossing, shaktiName, mudra, colorHex, primaryColor, verb, activation, bija, essence, bodyLocation, joinedBy, coreQuestion, signaturePhrase, heroThreshold, practicePrompt, threeWaysIn, gateType, gateText, storyThread, leelaStory, act1Voice, act2Voice, binduReflection, witnessPerspective, writingPrompt, writingReflection, mirrorFrequencyInstruction, mirrorFrequency, subtleMirror, voice, codexReferences.
- **The 33, in Road order:**

  | Road | Name | Seat / ring | Gate type | Voice |
  |---|---|---|---|---|
  | 1 | Bindu | kp 102, centre | Canvas | Bindu |
  | 2 | Mūlādhāra | kp 1–10, ring 1 | Textarea | Gaia |
  | 3 | Svādhiṣṭhāna | kp 11–18 | Textarea | Gaia |
  | 4 | Maṇipūra | kp 19–28 | Textarea | Bindu |
  | 5 | Anāhata | kp 29–44, ring 2 | Textarea | Higher Self |
  | 6 | Viśuddha | kp 45–48, ring 3 | Textarea | Bindu |
  | 7 | Ājñā | kp 49–52 | Textarea | Sakshi |
  | 8 | Sahasrāra | kp [], ring 2, Tripureśī | Textarea | Lalita |
  | 9 | Shadow | threshold [3,4] | Textarea (press-and-hold) | Sakshi |
  | 10 | Soles | kp 53 | Sound Response | Bindu |
  | 11 | Forge | 65 | Sound Response | Bindu |
  | 12 | Prāṇa | 71 | Sound Response | Bindu |
  | 13 | Hands | 69 | Sound Response | Bindu |
  | 14 | Pulse | 70 | **Tap Rhythm** | Bindu |
  | 15 | Sonar | 66 | Sound Response | Sakshi |
  | 16 | Echo | 80 | Sound Response | Sakshi |
  | 17 | Vision | 77 | Textarea | Sakshi |
  | **18** | **Axis** | **84** | **Device Tilt** | Higher Self |
  | **19** | **Crow** | **82** | **Device Tilt** | Sakshi |
  | 20 | Armin | threshold [6,7] | Textarea | Higher Self |
  | 21–28 | Inception 87 · Intention 88 · Inspiration 89 · Insight 90 · Intuition 91 · Invention 92 · Incarnation 93 · Innocence 94 | seats | Textarea | Gaia |
  | 29 | Integration | kp [], ring 7, Tripura Siddhāmbā | Textarea | Gaia |
  | 30 | Maya | kp 99 | Textarea | Lalita |
  | 31 | Aatma | kp 100 | Textarea | Higher Self |
  | **32** | **Ego Reveal** | **kp 101**, sanskrit **null** | Textarea | **Gaia** |
  | 33 | Lalita | kp 102, centre | Textarea | Lalita |

- **Energy material (keep in this app):** bīja · mudra · bodyLocation · coreQuestion · signaturePhrase · heroThreshold · practicePrompt · threeWaysIn (①②③) · gateText ("Button: …" last line) · mirrorFrequencyInstruction (all 33) · mirrorFrequency (10 body chakras) · writingPrompt / Reflection · subtleMirror (the twin pairs) · colorHex.
- **Story material (candidate for Bindu Feed, ruling 5):** storyThread · leelaStory · act1Voice · act2Voice · binduReflection · witnessPerspective. For example, Lalita's leelaStory "I built it as Ashrey…" (1629) and Integration's "Hi. It is me…" (1437).
- **Verbatim keys.**
  - Shadow signature "please come back home." (471). The reveal order "home / come / please / back" is in act2Voice (480).
  - Armin "Tat Tvam Asi" (976, 1014).
  - Sahasrāra gate "Stop doing. Just stop." (427).
  - Crow "CROWN without the N." (952).
- **Worlds.** W8 (the 33), W7 (body chakras on the Climb), W3 (constellation), W9 (Leela).
- **Register.** `05` rows (e.g. 05:407), `06` table 06:77–91, G-BODY 06:1185, `04` WV-02 · `07` C-1311, C-1330, C-1343..5.
- **Conflicts.** Maya signaturePhrase "…only the Bindu, playing." (1478) and binduReflection "There was only — playing. Someone, playing." (1488) — ruling 8 (C-4). Room 32's full reveal text is baked and readable (1576–1590) — ruling 2 (C-2). Sonar's story uses "Measurement" (765, 767).

## A2 · Models

### `Models/Avarana.swift` · 86
- `@Model` keyed on ringNumber: sanskritName, subtitle, presidingForm, mentalState, subtleBodyChakra, geometricShape, personalConnection, yogini (7–25).
- Fixed geometry, verbatim (34–60):
  - forms: Bhūpura · 16-Petal Lotus · 8-Petal Lotus · 14 Triangles · 10 Outer Triangles · 10 Inner Triangles · **Vāk Ring** · Mūla Trikoṇa · Bindu
  - counts 28/16/8/14/10/10/12/3/1, plus formDescriptions
  - **appreciations**, e.g. ring 9 "Thank you for being the place I have always already arrived."
- "All rings are accessible from day one" (6).
- **Worlds.** W4, W3.
- **Register.** `02` L-18 (Avaraṇa threshold), `03` VL-02.

### `Models/ChakraConstellation.swift` · 244
- `Chakra33` struct mirrors the JSON (25–122). Kinds: bindu, energy, shadow, body, armin, mind, summit. Addresses: centre, ring, seat, threshold. `mapRecordId` = recordId.
- `thresholdsCrossed(from:to:)` works inward only (154–163). `thresholdRadius` (166–169; uses `MandalaWorld` from Views). `canonicalPoint(kp:)` gives seat geometry before sync (180–193).
- `spokenLabel/spokenPlace` give VoiceOver words with no numbers (217–243). "Places, not a ladder… Nothing here knows what he has done" (20–22).
- **Worlds.** W8, W3, W7.
- **Register.** `04` WV-02.

### `Models/ChakraMovement.swift` · 179
- Eight **held practices, his own Codex lines verbatim** (17–108):

  | Practice | Codex | Room (road) |
  |---|---|---|
  | euphoriaPulse | C-1311 | 13, 14 |
  | roarAndSilence | C-1311 | 6, 15 |
  | lastMemories | C-1311 | 17 |
  | hamHetHum | C-1342 | 6, 15, 16 |
  | fearInWaves | C-1166/1168/1180 | 2 |
  | feelingThrough | C-1145/1177 | 10 |
  | restlessness | C-1170 | 19 |
  | heartHome "Hṛdayam." | C-1174 | 5 |

- Ham·Het·Hum breaths are 4-4-4: Echo receives, Viśuddha holds, Sonar transmits (120–124, 149–156). The full room map is `byRoad` (130–141). **No movement is mapped to Axis 18, Forge 11, Prāṇa 12, Ājñā 7, or the mind and summit rooms.**
- The held clock: `pulseCharge` 2.4 g·s, `shakeFloor` 0.35 g, `charge()` ebbs at 0.25/s (162–172) · `roarHold` 1.2 s · `fearWaves` 3 (175–178).
- **Worlds.** W8, W7.
- **Register.** `07` C-1311, C-1342, C-1301 (07:1300–1301) · `06` G-BODY.

### `Models/ChakraTeaching.swift` · 343
- Pure readers of the Map cells: `paragraphs` · `threeWays` (①②③ + intro) · `door` · `gate` ("Button:" line) · `gateTakesWords` (Textarea / Canvas) · `soundedSyllable` (A–Z, 2–4 letters only, so poetic bījas are never sounded) (19–152).
- `tatTvamAsi` is read from Armin's cell (159–168). `revealOrder` is read from Shadow's act2Voice (175–190). Threshold moment 9.2 s, or 5.0 s under reduce motion (195–196).
- `HomeDoor` is seat or ring (212–226). `games(c)` (235–254). **`Station`: atma (road 31) and gaiaReveal (road 32), kicker "the Gaia reveal"** (262–285).
- **`ClimbChakras`:** Soles at band 0 → Crow at band 6 (Sahasrāra's band), evenly up the spine. `pointsPerBand` 640, smoothstep presence, reach 0.75 (298–343).
- **Worlds.** W8, W7, W9.
- **Register.** `07` C-1330 (nine-stage order) · `04` WV-02.

### `Models/Cluster.swift` · 41
- Ring-2 clusters inner / tanmatra / citta / stability / selfBody with labels and colours. `forPosition` 1–16 defaults to `.inner` (3–41).
- **Worlds.** W6, W3.
- **Register.** `04` DS-04.

### `Models/DescentState.swift` · 78
- One row: currentRing, deepestReached, crossings[], enteredCurrentAt. `enter(ring:)` returns true only on a new deepest ring (48–61). `restore` keeps a floor of 2 (70–77). "Memory, not a gate" (7–12).
- **Worlds.** W3, W12.
- **Register.** `04` MBB-12.

### `Models/HomeMemory.swift` · 200
- `@Model` per kp: visits, accumulatedDwell, longestDwell, lastDwell, lastVisit, deepestAdaptation (30–74).
- Marks: **62 / 227 / 347 s**; dwellCap 4000; compressionFloor 0.36 (78–100).
- Functions (111–154):
  - `compression` = max(.36, 0.68^min(v,4))
  - `headStart` = dwell × 0.55 when ≥ 12 s, capped at 221
  - `grantsFifth`: ring 9 always 1; otherwise the max of the second-adaptation ramp and the bond ramp (180 + 300 s)
- **Never shown, never synced** (14–23).
- **Worlds.** W5.
- **Register.** `01` H-MEMORY, H-CLOCK · `02` R-05 (Zero Gap).

### `Models/KhadgamalaMap.swift` · 62
- Spans 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102. `ringStartOffset`, `perRingIndex`. The comment names ring 7 "**Vāk Chamber**" (15) where Avarana.swift says "Vāk Ring".
- **Worlds.** All.
- **Register.** `01` H-ARCH §2 · `04` FB-17.

### `Models/LetterDraft.swift` · 27
- `isDirty` compares the text against the saved body, so viewing never writes.
- **Worlds.** W13.

### `Models/LivingMandala.swift` · 111
- **Portrait geometry.** Ring radii base [158,123,95,78,65,52,40,26,0] / 172 (20–21). **Strokes are mirrored n-fold by the ring's seat count** (28,16,8,14,10,10,12,3,1) (24–28). `ring(atUnitRadius:)`, `copies`, `thinned` (spacing .008, cap 256) (32–75).
- **The year ring:** one bead per practised day at that day's own angle. Missed days are space, never slots (C-1348) (82–102).
- **Worlds.** W12, W11.
- **Register.** `02` L-23 (Portrait) · `07` C-1348.

### `Models/MarginNote.swift` · 79
- `@Model` note: noteId, body, createdAt, updatedAt, ledgeredAt. "The local row is the record, and it is also the queue" (15–24).
- **Worlds.** Settings / Memory.
- **Defect.** Stale "three-strike UserDefaults queue" wording (21–24).

### `Models/MonthReading.swift` · 187
- The **Month Mirror** (Bindu Being) + the **Portrait glyphs** (Bindu Feed). `Act` kinds: felt, silence, letter, light, note, codex, drawing, played (22–33). `DayGlyph` (ring, met[], sealed) (38–44). Arc, turning day, letter, deeper, witness (46–137).
- Composed lines include "This month you met …", "This month asked nothing of you. The yantra stood open the whole time." (140–160) and "Just noticing." (163–176).
- Uses `SakshiClose` (Services/RiteDay) and `DailyEnergyService`.
- **Worlds.** W12, W11.
- **Register.** `07` C-1346 family.
- **Note.** These are composed sentences built from his record. They are "words only from his own record" (13–16), but the joining words are authored here.

### `Models/NityaDevi.swift` · 38
- `@Model`, tithi 1–15. `tithiNames` Pratipadā … Pūrṇimā (25–29). `bija` stays empty until the table exposes it.
- **Worlds.** W11, W2.
- **Register.** `02` L-05, L-20 · `04` FB-25.

### `Models/RecognitionEntry.swift` · 66
- `@Model`: timestamp, kp, ring, legacy shaktiPosition, note, gestureRaw. Gestures are **only** `.felt` and `.silence` (62–65).
- **Worlds.** W6, W12.
- **Register.** `04` MBB-06.

### `Models/Shakti.swift` · 163
- `@Model` of the 102, with the fields listed in A1. `hasBeenFelt` is a Bool. **The count is reduced to a state at the store** so no drawing surface gets a number (66–76; `LawsDrawnMeasureTests` covers Views/Mandala, Memory, Spike, Theme). `bijaSyllable` cuts at " — " (158–162). Field connection "positions 3 / 12 / 14" (33–35).
- **Worlds.** All.

### `Models/ShaktiLetter.swift` · 50
- `@Model` keyed by kp. `letterKey` falls back to position + 28.
- **Worlds.** W13.
- **Register.** `02` L-21/22.

### `Models/ShaktiStatus.swift` · 35
- mapped 0.22 / exploring 0.44 / active 0.76 / embodied 1.0 opacity; `advanced()`.
- **Worlds.** W6.
- **Register.** `04` DS-07, DS-08, FB-22.
- **Tension.** A four-step ladder drawn as opacity is a progress display. See C-9.

### `Models/SomaticRegion.swift` · 130
- **His body as twelve regions of light, never a figure**: crown, brow, senses, throat, heart, hands, solar, belly, root, soles, spine, field. Regex vocabulary (36–52), anchors in unit space (72–87).
- **`SensoryDoorway`** (C-1337): heat, water, earth, breath, space, read from her tattva (94–116). **There is no "light" doorway.**
- **Worlds.** W6, W5, W7.
- **Register.** `07` C-1337.

## A3 · Services

### Sound (one conductor, five engines)

#### `Services/SoundConductor.swift` · 271
- **C-1350 "one sound at a time"** (3–31).
  - Voices: om (the floor) · field / room / play / heart (beds) · bija / bell / voice (accents) (34–61).
  - Priority: heart 4 · play 3 · room 2 (1 while climbing) · field 1 (2 while climbing) (72–80).
  - **`SoundArbiter.gains`: the front bed = 1 and every other bed = 0.** An accent ducks the bed to 0.3 and silences the Om. The Om sits at 0.15 under a bed (85–123).
  - The Om floor is `TreeOfLife.omFloor(depth)`. Between places it holds for 4 s (250–270).
- **Worlds.** All.
- **Register.** `07` C-1350 and **07 §C.3 flag 07:1322**: "a playback-collision rule, not a ban on layering. He wants binaural beats layered under songs and an inverse layer."
- **Rule now lifted.** "One bed at a time" (21–25, 105). Ruling 10 lifts it. C-6.

#### `Services/RingAudioService.swift` · 838
The field's voices on one `AVAudioEngine`. Session `.ambient`, so the silent switch is honoured (48–68).

| Voice | Sound | Lines |
|---|---|---|
| Ring 1 ground drone | 73.42 + 110, LFO 0.07 | 79–107 |
| Ring 2 home breath | 130.81 + 196 | 111–137 |
| Rings 3/6 sustained | 116.5 / 207.65 with vibrato | 144–170 |
| Rings 4/5 stepped notes | via `BijaSoundService.playVakBija` | 175–185 |
| `ringChime` | 528 × 0.917^(r−1) | 191–196 |
| `ringBija` | — | 207–222 |
| Ring 8 triad | Icchā · Jñāna · Kriyā 261.63 / 311.13 / 392 → bindu 130.81 | 226–271 |
| Ring 7 sourceless | 136.1 partials 2, 3, 5 | 279–307 |
| The point | 136.1 + 204.15 | 313–338 |
| **The Om** | `TreeOfLife.omHz`, not stopped by `stopAll` | 348–377 |
| Vāk | 12 freqs 220…659.25, chord at 55 ms stagger | 383–403 |
| `glide` | glissando | 410–416 |
| Shepard | 7 voices from 32.7 Hz | 420–437 |

Voice classes: `ContinuousVoice`, `TriadVoice`, `ShepardVoice` (462–838).
- **Worlds.** W3, W7, W4, W1 (the point), W14 (the Shepard fall).
- **Register.** `01` H-ARCH §2 ("Extend per ring") · `02` L-10.
- **Defect.** The header "Today the only live caller is `ringChime`" (6–11) is stale. `RingFieldVoice` drives every voice.

#### `Services/RingFieldVoice.swift` · 306
- The ring→voice table (19–29). `want(climbFraction:)` follows `WorldClimb.weights` (Homes). `want(enteredRing:)` (54–66). Stepped roots for rings 4 and 5 (70–81).
- "**Wave 6 · one sound at a time**" `conductorGain` (85–96). `sound()` arbitrates the shared 3/6 slot (105–182). `hush/resume` for Mauna (196–208). `bloom` (G17) (214–226). `chord`, `unite`, `fall`, `fallThrough` 3.2 s (231–279).
- **Worlds.** W3, W7, W4, W1.

#### `Services/HomeSoundService.swift` · 1177 — her carrier (Design's `homes-sound.js`, every number)
- **Techniques per ring:** 1 drone · 2 breath · 3/6 breathy · 4/5 stepped · 7 sourceless · 8 triad · 9 Shepard (104–115).
- **Roots** [55, 61.74, 69.30, 73.42, 82.41, 92.50, 98, 110, 123.47] (82). These are a **different tuning from RingAudioService's ring voices** (C-11).
- **The 49-syllable varṇamālā** (85–90) · 12 just intervals (93–96) · `carrierFor` = root × just[idx % 12] × 2 (143–151) · strike ratios 1 / 1.5 / 2 (161–167).
- **The withheld fifth** at 0.05, ring 9 always granted (183–191). **The ground fifth** ×0.75 at 0.035 from the first beat (Field's absent-fifth law) (193–210). Score overrides (212–220).
- The Tau table (235–251). Initial frequencies 136.1 / 204.15 / 460. Steps [1, 9/8, 5/4, 3/2] with periods 5.2 / 3.4. Triad 14 s, glide 3.4. Shepard 5 voices. Strike envelope. Eight strike voices (253–361).
- Render path (366–704). Lifecycle, session, interruption and route-change pause (730–996). Gestures `setGround`, `setCarrier`, `setRoom`, `strike` (1128–1176).
- "**Wave 6 · one sound at a time**" `conductorGain` (762–776).
- **Worlds.** W5, W7.
- **Register.** `01` H-SOUND, H-ARCH §5 · FIDELITY 86–99.
- **Defect.** "The descent is silent here… Phase 3.9" (727–729). The descent now glides through `RingAudioService.glide` (HomeVoice 238–243). Accurate for this service, misleading as a header.

#### `Services/HomeVoice.swift` · 278
- The conductor between one stay and `HomeSoundService` (72–256). "A room is whole with the sound off" (19–30). The room honours the silent switch (41–48, 101).
- **"There is no in-app volume, no sound toggle and no mute button in the rooms layer"** (50–52). Ruling 10 lifts this: controls may be added. C-6.
- 1 s cadence. `standing` → settling + `grantsFifth`. `descends` → `Glissando`. `forRoom` reads the Score (260–277).
- **Worlds.** W5.

#### `Services/HeartRegister.swift` · 275
- **The kīrtan / bhajan register** (C-1169, C-1222, C-1297).
  - Sa choices C–F (130.81–174.61), default C♯ (34–48).
  - Drone ratios 0.5 / 1 / 1.5 / 2 with gains 0.55 / 0.7 / 0.45 / 0.25. Six harmonics 1/n^0.8, reeds ±3 cents (50–57).
  - Four sargam phrases (60–65). Note length = breath/8 × 0.9. **The answer silence is one breath** (69–70). The bellows breathe on BreathClock (122–125).
  - `.ambient` session (182). Adopted as the front bed (214).
- Entirely synthesised: "Nothing is claimed for any tone" (15–20).
- **Worlds.** W10 / W6 (the heart room), W12 (where the view lives **[lookup]** `Views/Memory/HeartRegisterView.swift`).
- **Register.** `07` C-1169, 07:1314.

#### `Services/BijaSoundService.swift` · 318
- A recorded `bija_%02d` file by kp is preferred (25–65). **No such file exists in the bundle** (`find` found none), so the path is dead today.
- Fallbacks: whole-tone sine at 174 Hz × 2^(2(p−1)/12) (34–39). `playBija` hashes the syllable (FNV) onto a pentatonic 130.81…293.66 and plays a drone of fundamental + fifth 0.6 + octave 0.4 (108–159).
- Vāk single and chord (161–256). **The two bells:** singing-bowl partials 1 / 2.76 / 5.4 / 8.93 with decays 0.9 / 1.6 / 2.6 / 4.0, waver 1.3 Hz, 5.5 s (258–302). Session `.playback`, which ignores the silent switch (307–309). Every call → `SoundConductor.strike`.
- **Worlds.** W2, W5, W6, W4.
- **Register.** `02` L-10, R-08.

#### `Services/GlissandoVoice.swift` · 94
- An exponential glide: sine + 0.22 octave, rising over the first 1/8, gain 0.05. It detaches itself after sounding.
- **Worlds.** W5 (descent).

#### `Services/RingBija.swift` · 141
- Idea 31: "the fall speaks the mantra". Syllables come from `HomeWorlds.ringCharacter` (Homes). Root 528 × 0.917^(r−1). Vowel intervals: ai 5/4, au 5/3, i 3/2. Duration 1.2 × root₁/root. Ring 8 sounds three notes (57–141).
- "Sounded, never stacked": **no view may read it** (16–24, `MandalaLightTests`).
- **Worlds.** W3, W4.

### Time and the day

#### `Services/Ephemeris.swift` · 431
- **The real sky.** Meeus ch. 25 Sun (low accuracy) + ch. 47 Moon (60 terms + A1, L′−F, A2) + Lahiri ayanāṃśa (3–27, 29–197). Obliquity, declination, equation of time.
- **`TemporalPlace.home` = Bensalem 40.1046, −74.9516.** Away from home, longitude follows the time zone (199–220).
- **`Panchanga`:**
  - tithi 1–30, Śukla / Kṛṣṇa, names (228–246)
  - `nextStart(ofTithi:)` by Newton on the elongation (250–263)
  - **nakṣatra 27 names** (267–282) · **rāśi 12** (286–294) · **ayana** (298–305) · **ṛtu, six seasons in Sanskrit and English** (309–338)
  - sunrise / noon / sunset by the NOAA method (342–381)
  - **sandhyās** prātaḥ / madhyāhna / sāyaṃ at ±24 min (386–430)
- **Worlds.** **W11 Time** (whole), W2, W13 (letter openings).
- **Register.** `02` L-05 · `04` FB-11, FB-25.

#### `Services/LunarPhaseService.swift` · 139
- A façade over the Ephemeris. Phase labels (41–72). `headerLabel` "Waning Crescent · 23rd Night" (75–79). Illumination (88–91). `currentDay` = true tithi (96–98).
- **`currentTithi` is not the Nityā** — the Nityā mirrors back in the waning fortnight (106–116).
- `currentTimeVariant`: newmoon, night <5 or ≥21, dawn <10, noon <15, dusk (130–138).
- **Worlds.** W11, W2, W3.
- **Register.** FIDELITY 71–72 · `04` FB-10, FB-11.

#### `Services/DailyEnergyService.swift` · 99
- Day boundary at **6 am**. Epoch 2020-01-01. A deterministic Fisher–Yates permutation per 102-day cycle (SplitMix64, seed = cycle ^ 0xD1B54A32D192ED03). A `count` parameter allows the 16-only pool before sync (11–99).
- **Worlds.** W2 (who presides), W11, W13 (her day), W1.
- **Register.** `01` H-TODAY · `02` L-04.

#### `Services/DailySummons.swift` · 158
- One alert a day (no sound, no badge) over a 14-day window. Default 6 am, with a one-time migration from 18:00. Today's slot is skipped if the Rite is done (4–157). Fallback strings "She is waiting." / "She greets you this morning." (37–38).
- **Tapping the summons routes nowhere.** Only gifts route (see EnergyGift).
- **Worlds.** W2, W11.
- **Register.** `04` MBB-08 · `04` DS-23.

#### `Services/EnergyGift.swift` · 202
- **The random gift (C-1353).** At most one a day, inside a window (default 10–20 h), seeded by day + a per-install salt. Her Appreciation Phrase or Function, passed along to the next seat if hers is empty (19–141).
- `GiftRouter` holds the kp and posts `bindu.gift.open` to land on her. A foreground banner shows for gifts only (147–201).
- **Worlds.** W6 / W5 (landing), W11.
- **Register.** `07` C-1353, 07:1327.

#### `Services/RiteDay.swift` · 344
- **Three doors** (herRoom, oneSound, oneSecond, closeTheDay) by period morning / midday / evening. **"Three doors, never five"** (19–62).
- The one-second floor: "Blink. Breathe. Press." with breath 4-4-4 and press 1.8 s. **"That was a full day of walking. Everything else today is extra."** (64–77).
- The pulse lives in rings 4–8. Heartbeat 0.75 / 0.4, gap 0.16, period 1.0 (79–89).
- **GraceChannel** (101–265): restDays 3, reach 30, one room-matched line, sorted hers before sister.
  - Verbs: "you knew %@ as she passed", "you kept a silence with %@", "you wrote to %@", "you stayed with %@ until her room changed" (190–198).
  - **Sister-app verbs:** Story Met, Ash Replied, Walk Completed, Veil Lifted, Chapter Completed, Topic Opened (203–213).
  - `when()` in words: "Last night", "Three nights ago", "A moon ago" (229–244).
- **SakshiClose** (271–344): "Today you … ." / "Nothing was asked of you today. The yantra stood open the whole time." / "{name} waited. She knows how to wait." / "It trusts you." Lists end in "and others" past three (287–330).
- **Worlds.** W2, W12 (grace), W15 (the sister apps through the ledger).
- **Register.** `07` C-1002 · `04` (Chakras Experience Brief v2 §§4–10 as cited).
- **Rule now lifted.** "Three doors, never five" (42–51). Ruling 10 lifts "three controls". C-6.

#### `Services/RiteOpenings.swift` · 264
- `RiteHooks` → `TheBells` (Views) (33–38).
- `RiteOpening` kinds: dawn 4–9 · day · dusk 17–21 · night (40–60).
  - **"Stop. Breathe. Remember."** (C-1303, 63).
  - **The Sacred Pause** (C-1160): "Let what has passed fall away." / "Land here, now." / "Let the answer open through the body." (66–70). Breath = `BreathClock.breath`.
  - Dawn call **"Open the eyes before the world opens them for you."** Dusk call **"What you carried today may be offered here."** (80–86). Śṛṣṭi / Saṃhāra (89–95).
  - **The liturgical year of 102 days:** `yearPlace`, `yearLight` = 1 − 0.45 × place (97–109).
  - `HourWay`: dawn → Svapna + Sandhyā, dusk → Pūjā + Sandhyā (127–171).
- **RiteStation**: Arrival → Summons → Meeting → Being-with → Offering → Carry. Offering = her Appreciation Phrase, Carry = her somatic line (174–208).
- **LowStateDoor**: "I am low" → "your own words". Empty state "When you have written, your words will wait here for you." Lines are 12–240 chars, rotated by day (210–263).
- **Worlds.** W2, W10, W11.
- **Register.** `07` C-1303, C-1160, C-1002.
- **Flag.** 07 §C.3 (07:1330) says C-1120 is mis-cited here (24); cite C-1002 / C-1057.

#### `Services/TreeOfLife.swift` · 229
- Verbs Press…Dissolve (35–41).
- **RingAnswer:** press 0.8 / 1.0 / 1.2 / 1.4 / 1.6 s for rings 1–5, stillness 4 / 6 / 8 s for rings 6–8, **none at 9** ("The source is not reached by doing (C-1307)") (45–87).
- `guideWords` thins from 1 to 0 by ring 7 (94–104). **Breath arc** per ring (in / hold / out; release; forge; give; clear; see; wordless at 7; none at 8–9) (121–135).
- **Progressive luminance** 5 / 10 / 18 / 28 / 40 / 55 / 75 / 90 / 100 % (141–144). Yoginī legibility gradient (151–154).
- **The Om** at 136.1 with partials 272.2 @ 0.30 and 68.05 @ 0.15; floor = 0.004 + 0.026·d/9 (159–169).
- **Panel 9's eight dissolutions, verbatim** (205–214). Recognition "Everything you placed in this space is already moving toward you." Closing triangle "You have always had the Knowledge. / You have always been the Will. / Now You Become the Action." **"Now go play."** (C-1163) (218–223). `theBinduIsNamed = false` (228).
- **Worlds.** W3, W7, W4, W14 (Panel 9 / the Mirror).
- **Register.** `06` tree-of-life · `07` C-1307 and **07 §C.3 flag 07:1324** ("a held gesture is not an action that attains"). C-12.

### The 33, the game and the guides

#### `Services/GameStructure.swift` · 96
- Decodes panels, faces, practices and leelaDrops (16–96). **It does not decode `axis`**, so the axis declaration is dead (C-10).
- **Worlds.** W7, W9, W3.

#### `Services/LeelaDrops.swift` · 204
- **Rare, unannounced drops (C-1330):** never within 3 days, chance 0.3, one draw per practice day, never repeating the last (24–79). Each one marks `ThreePools`.
- `LeelaDropPresenter` overlays after a 9 s settle (85–120). `LeelaDropView`: the lead, then the action 4.5 s later, then "carry it" / "hold in silence" (128–204). This is a **View living in Services**.
- **Worlds.** W9, W1 (it overlays the shell).
- **Register.** `07` C-1330, 07:1328.

#### `Services/TrinityOfGuidance.swift` · 186
- Five faces with lights: gaia (0.62, 0.74, 0.42) · bindu (0.86, 0.26, 0.22) · lalita (0.96, 0.62, 0.58) · sakshi (0.70, 0.80, 0.95) · higherSelf (0.98, 0.82, 0.46) (25–51).
- Seats: **Gaia kp 31 · Higher Self "(Ram, his own)" kp 42** · Bindu on the Climb at ring ≤ 1 · Lalitā at ring ≥ 9 · Sakshi on the descent at ring 7 (9–16, 63–86).
- Once per practice day (96–115). `TrinityVoiceLayer` stands 7.5 s (123–186) — a **View in Services**.
- **Worlds.** W5, W7, W3, W15.
- **Register.** `07` voice architecture.
- **Gap.** Ruling 6 names Sid, Arch, Karishma and Ashrey too. C-7.

#### `Services/ThreePools.swift` · 127
- essence / memory / being (24–39). Surfaces: Well for letters, notes, wagers and Leela; Portrait for everything else (43–62). `BeingMark`s (bell, face, leela, light) are refreshed daily (66–126).
- **Worlds.** W12, W13, W2.

#### `Services/PlayTraceStore.swift` · 105 · `Services/PlayGardenStore.swift` · 88
- PlayTrace (game, position, ring, at) → `PlayLayers`: beads, roots, body, seed, wheel. **wheelOrder = 16 games:** corridor, pulse, spineWalk, echo, fingerGarden, rain, drum, rootSystem, waterLevel, fire, shakeToClear, door, yantraTrace, rosary, bijaTones, coherence (PlayTrace 47–105). Warmth = .25 + .75·e^(−d/21).
- PlayGarden: traces, **seeds that grow in real time**, `worldVisitedAt` ("gifts arrive while he is away") (PlayGarden 3–88).
- **Worlds.** W9, W12 (the Portrait's play layers).
- **Defect.** Two local stores record the same act. Both are written by **[lookup]** `Views/Play/PlayGameHost.swift`.

### Memory, the Well and practice data

#### `Services/CorrespondenceStore.swift` · 376
- **The river (C-1346).**
  - `RiverLetter` back / forward. Openings: Pūrṇimā / Amāvasyā / this tithi returns / her next day (real moon + DailyEnergyService) (18–113).
  - **Sealed, no peek** (67–81). **Patina** = 1 − e^(−days/240) (83–88).
  - `RiverDraft` (118–126). **`RiverRecipient`**: her, age (spelled), memory, past self, later self, each with allowed directions (131–169).
- **`LightSentBack`** (C-1126/1101/1253) (174–184).
- Store: seal, sendBack, sendLight, open (refuses a sealed letter), merge restores, ledger stamps. File "correspondence".
- **Worlds.** W13, W12, W11.
- **Register.** `07` C-1346, C-1126, 07:1293.

#### `Services/PortraitStrokeStore.swift` · 157
- Strokes and sessions. A session killed mid-way is closed at its last stroke. `dominantRing`. File "portrait-strokes".
- **Worlds.** W12.

#### `Services/WagerStore.swift` · 124
- The Wave 5 wager was reworked into Wave 6 `notice()` "she appeared, noticed in passing" (C-1195) (77–109). Evening hour 17.
- **Worlds.** W6.
- **Flag.** 07 §C.3 (07:1323): C-1195 is about his kundalini and body-honouring, not about watching a Śakti.

#### `Services/RitesPractice.swift` · 158
- WitnessWriting (C-1280), GarlandRecital (reached ring, whole), DayOffering. File "rites". `takeUnledgered`.
- **Worlds.** W10, W2.

#### `Services/BinduMemory.swift` · 79
- **The name his higher self gave (C-1325).** History is kept and never overwritten. File "bindu-memory". Restored only when empty.
- **Worlds.** W1 (the Bindu), W12.
- **Register.** `07` C-1325, 07:1281.

#### `Services/CodexNoteStore.swift` · 54
- keep / leave → `writeCodexNote`. File "codex-notes".
- **Worlds.** W12, W13.

#### `Services/SpeechCapture.swift` · 224
- `AVAudioRecorder` m4a → `Practice/voice/`. **On-device SFSpeech** turns it into words, which he may correct. Never deleted. `VoicePlayback` strikes `.voice`.
- **Worlds.** W13, W12.
- **Rule.** "His voice… nothing is ever generated" (16–17).

#### `Services/PracticeVault.swift` · 67
- `Application Support/Practice/*.json`, atomic writes. An unreadable file is copied aside. Nothing is ever deleted. The rationale is to avoid parallel schema V4 collisions (10–28).
- **Worlds.** All.

#### `Services/PracticeLedger.swift` · 98
- Sweeps strokes, river seals / openings / lights, names kept, wagers and rites into `logActivity`. Each item is stamped before the await.
- **Worlds.** W12, W13.

#### `Services/MarginNoteStore.swift` · 112
- No count API (LawsTests). Discard only when the field is empty and the note was never ledgered.

#### `Services/RecognitionLogStore.swift` · 92 (+ `LetterStore`) · `Services/RecognitionMigrator.swift` · 55
- Reads never write. Legacy shaktiPosition + 28 → ring 2.

#### `Services/HomeDwelling.swift` · 225
- Wires the R11 silence at **62 s** and First Dwelling at **227 s**, both on the chamber clock. Wakes rather than polls. Invisible (79–225).
- **Worlds.** W5.

#### `Services/HomeMemoryStore.swift` · 136
- `HomeMemoryStore` façade; `HomeVisit.claimSilence`.
- **Defect.** "Zero call sites" (18, 98) is stale: **[lookup]** `Views/Rooms/HerRoomDoor.swift` uses it, and `HomeDwelling` uses `HomeVisit`.

#### `Services/SilenceDwell.swift` · 38 · `Services/MaunaSilence.swift` · 46
- Local `.silence` first, then a `Silence Held` row.
- Mauna happens at kp 102 when held ≥ `Mauna.recordedAfter` (Homes/TheBuilding **[lookup]**).
- **Defect.** "Zero call sites until Phase 3.6" (SilenceDwell 13–14) is stale.

#### `Services/GratitudeGrace.swift` · 119
- His ruling of 12 Oct, §4.4: reads **one column** of the Gratitude journal `tblEFiuFIijKe9ba6` / `fld85STU49AtREkfe` ("What are you grateful for today? ⚡"). Read-only. Speaks on 1 day in 3, only when grace is silent, room-matched by her words. Max 220 chars. Never repeated.
- **Worlds.** W2.
- **Privacy floor.** Journals are private: this is his explicit carve-out and it never leaves the phone.

## A4 · Theme

### `Theme/Atmosphere.swift` · 160
- The per-Śakti palette (`lrAtmosphere`). Jitter is ±7° of hue (range 14), rotation range 44. Time modulation (58–74). The cluster hue applies **only on ring 2** (79–84).
- Ring hues 1–9: 35/58/54 · cluster · 341/45/58 · 353/55/48 · 18/62/55 · 194/42/46 · 322/38/50 · 2/68/50 · 46/72/66 (106–119).
- Ground #0D0508 / deep #070205. Time tints: dawn #3a1c22 · noon #242838 · dusk #331306 · newmoon · night #060716 (129–159).
- **Worlds.** All.
- **Register.** `01` H-LIGHT (verbatim port) · `02` L-02, L-03.

### `Theme/AtmosphereBackground.swift` · 73
- Element backdrops that breathe: fire 11, water 13, air 12, ether 9.6, earth 15, light 7.6 s (51–61).
- **Worlds.** W2, W6, W5.
- **Register.** `02` L-09.

### `Theme/BreathClock.swift` · 88
- **"One breath, one point, across every screen."** breath 8 s, beat 1 s, one epoch. Every rhythm is a multiple of the beat. A Score's tempo is snapped to the beat (1–54).
- **`BinduPoint`**: the one point, never explained (56–88).
- **Worlds.** All. W1 (the point).
- **Rule now lifted.** "One breath clock" (ruling 10). C-6.

### `Theme/Color+Tokens.swift` · 52
- ground #0D0508 · surface #1A0C10 · darkVeil #080307 · silenceGround #040104 · gold #C9963F · goldDeep #A07830 · goldWarm #CF9443 · cream #F2E8D9 · accentRed #8B1A2A · five cluster colours.
- **Register.** `04` DS-03/04.

### `Theme/DayLight.swift` · 156
- Intensity 0.85. Sigil opacities: rite 0.62 + 0.85 × 0.42, field chip 1.0, room 0.5, threshold 0.7, presence 0.55 (16–29). `todayPosition` with the pin (33–35). `feelHerEnd` (49–57).
- **FieldBreath**: ring 2 3 s · 3 8 · 4 9 · 5 11 · 6 13 · 7 15 · 8 18 · 9 4 · ring 1 holds (62–86).
- **ArrivalBeat** — nine beats at 0.10 … 1.25 s. **StagedArrival** 1.3 s, rise 10, sigil 0.2 / 2.4 (93–156).
- **Worlds.** W2, W3, W4.
- **Register.** `02` L-08, L-12 · `03` V2 nine metabolisms.

### `Theme/DepthOverlay.swift` · 71
- Vignette 0.55, grain 0.11, deterministic LCG.
- **Register.** `02` L-08 (LrDepth).

### `Theme/Element.swift` · 48
- `forRing`: 1 earth · 3 air · 4 water · 5 fire · 6 ether · 7 air · 8 fire · 9 light · ring 2 → `parse(tattva:)` (12–24).
- **`parse` has no "light" branch**, and anything unmatched falls to `.ether` (28–36).
- **Worlds.** All.
- **Register.** `01` H-ARCH §2.
- **Conflict.** Ruling 4. C-3.

### `Theme/Fonts.swift` · 169
- Cormorant Garamond Light / LightItalic. Dynamic Type through a size → text-style table (65–78). Labels through `UIFontMetrics`, normalised (107–130). Canvas labels are deliberately not scaled (39–52).
- **Register.** `04` DS-05.

### `Theme/HSL.swift` · 44 · `Haptics.swift` · 7 (light / medium / soft only) · `Layout.swift` · 12 (`Hit.min` 44) · `SeatLighting.swift` · 11

### `Theme/LightField.swift` · 253
- The CSS gradient vocabulary: ellipse, circle, linear, fill, shade (40–122).
- `Backdrop.layers` per element, line for line (146–203). crown · presenceCrown · **veil (the menu veil)** · sheet · memory (205–252).
- **Worlds.** All.
- **Register.** `02` L-09, L-24 (menu veil).

### `Theme/MandalaLight.swift` · 417
- **One source, nine refractions.** Source = ring-9 hue. falloff 1.35, refractionLimit 0.45. The veil takes at most 0.45 from a mark and 0.25 from text, with a 0.5 floor. stillnessSpan 4 s, nearnessShare 0.55 (80–137).
- `reach` (142–150). Gem scatter from `HomeGem.behaviour` (Homes) (157–166). `seatColor(own:felt:)` takes a Bool (196–202). `feltWarmth` (213–220). Band width and glow spread (233–237).
- Veil = f(ring, nearness, stillness) (246–303). **Tratak** onset 20 s, full 45 s (305–339). `enabled` unless `MANDALA_LIGHT=off` (366–373). `MandalaLightField` (384–417).
- **Worlds.** W3 (+the Veil), W4.
- **Register.** `01` H-ARCH §4.1 (Gem) · FIDELITY 109–126.

---

# B · Gifts for the upgrade

## B1 · What the code already gives, row by row

*Format: what it is · source · world(s) · how it works there · what it needs · energy or story.*

1. **SoundConductor + the five engines** · SoundConductor.swift; RingAudioService; HomeSoundService; HeartRegister; BijaSoundService · All · Keep the arbiter as the *mixer*, not the gate. Each world declares its beds with gains, and the layers sum instead of zeroing (ruling 10; 07:1322: layering wanted, collision forbidden). Keep the "starting the same source twice stops the first" rule. · Needs: change `SoundArbiter.gains` (98–113) to allow N beds with per-world gains, plus a per-world sound panel (volume per layer, mute) now that controls are allowed. · Energy.
2. **The Om at 136.1 Hz as the floor of every world** · TreeOfLife.swift:159–169; RingAudioService 348–377 · W1, all · The Home point hums the Om. Depth raises its floor. Panel 9 swells it. · Already built. Expose the swell to the Bindu deep zoom (ruling 9). · Energy.
3. **The per-Śakti carrier from the varṇamālā** · HomeSoundService.swift:79–220 · W5, W6 · Her bīja's index in the 49-syllable series gives a just interval above her ring root. The withheld fifth arrives with dwelling. The ground fifth sounds from the first beat. A live Score overrides it. · Already built. Needs a Score per kp in Airtable (`fldz1vCCMpXiw8s1n`). · Energy.
4. **Nine ring voices with distinct techniques** · RingAudioService; RingFieldVoice 19–29 · W4, W3, W7 · Each ring world sounds its own voicing: drone, breath, breathy, stepped, sourceless witness, triad collapse, Shepard fall. · Unify the two tunings (C-11). · Energy.
5. **Kīrtan / bhajan heart register with call-and-response** · HeartRegister.swift · W10 (a mode), W5 (Anāhata / heart rooms), W15 · Drone on his own Sa. The call, then one breath of silence for his answer. · Make it reachable from any heart room and the menu. · Energy.
6. **The two bells (singing bowl)** · BijaSoundService.swift:258–302 · W2 (opening and closing bells), W10 Pūjā · They mark the edges of the Rite. · Already built. · Energy.
7. **Vāk 12-voice chord + Ring 8 triad unite + Shepard fall-through** · RingAudioService 226–437; RingFieldVoice 231–279 · W4 rings 7/8/9, W14 (the fall under the Bindu) · Ring 7 strikes its chord. A ring 8 hold makes three tones glide into one. The fall to the Bindu is a Shepard swell. · Built. · Energy.
8. **The descent mantra (RingBija)** · RingBija.swift · W3, W4 · Each inward crossing sounds its ring bīja. Ring 8 sounds three syllables. · Built. Consider letting the syllables be *seen* now that the measuring fear is reconsidered (16–24). · Energy.
9. **The real sky: Ephemeris + Panchanga** · Ephemeris.swift · **W11 Time** · A Time world drawn from true tithi, pakṣa, nakṣatra (27), sun rāśi, ayana, ṛtu (6, Sanskrit + English) and the three sandhyās for Bensalem, with sunrise, noon and sunset. · The engine exists. **The Time world itself is missing.** · Energy.
10. **The 102-day liturgical year** · RiteOpenings.swift:97–109; DailyEnergyService · W11, W2 · The day's place in the year of 102 (Śṛṣṭi-bright → dissolving), felt as light. · Built as a number; needs a surface in Time. · Energy.
11. **Dawn and dusk as two rites + HourWays** · RiteOpenings 40–171 · W2, W10, W11 · Dawn: Śṛṣṭi call + Svapna. Dusk: Saṃhāra offering + Pūjā. Both offer Sandhyā. · Built. · Energy.
12. **Six Rite stations** · RiteOpenings 176–208 · W2 · Arrival → Summons → Meeting → Being-with → Offering → Carry, as six places in Today's own space. · Built as data. · Energy.
13. **Three doors + the one-second floor + the pulse** · RiteDay.swift:19–89 · W2 · "Blink. Breathe. Press." 4-4-4 with a 1.8 s press. The heartbeat haptic plays in rings 4–8. · Lift "never five" (ruling 10). · Energy.
14. **Grace, including the sister apps** · RiteDay.swift:101–265; GratitudeGrace · W2, W12, W15 · One room-matched past moment, told in words ("Last night, you knew Kāmeśī as she passed. It was standing in this room."). It also reads Feed and Learning rows. · Built. The sister rows are a seed for the Relationship Field across apps. · Energy (memory).
15. **Sakshi close + MonthReading** · RiteDay 271–344; MonthReading.swift · W2, W11, W12 · The day closes on one witnessing sentence. The month is read as glyphs, arcs and a turning. · Built. · Mixed: the month letter is close to story; keep it as witness. ⟶ flag for Feed.
16. **Low-state door** · RiteOpenings 216–263 · W2, W13 · "I am low" → his own lines back (notes, letters, witness pages), rotated by day. · Built. · Energy (his words).
17. **The river, light sent back, recipients, patina** · CorrespondenceStore.swift · W13, W12, W11 · Letters forward to the full moon, the dark moon, a returning tithi or her day, sealed with no peek. Letters back to moments. Letters to an age, a memory, past and later selves. Paper yellows in real time. · Built. · Words: his (energy of correspondence). Not Feed.
18. **His own voice kept + on-device transcription** · SpeechCapture.swift · W13, W12, W1 · Every "own word" may be spoken. The voice is kept forever. · Built. · Energy.
19. **Name kept in Bindu memory** · BinduMemory.swift · W1 Home · The name his higher self gave sits at the point and is used only as he chooses (Book's first page, letter addressee). · Built. Put it in Home. · Energy.
20. **HomeMemory + HomeDwelling + HomeVoice** · Models/HomeMemory; Services/HomeDwelling, HomeVoice · W5 Her Home · Ceremony compression, head start from dwell, adaptations at 62/227/347 s, the silent R11 row, First Dwelling, the fifth granted by relationship. · Built. · Energy.
21. **The Portrait as a living mandala** · LivingMandala.swift; PortraitStrokeStore; PlayLayers · W12 Memory · Strokes are mirrored n-fold by ring seat count. The year rim keeps lived gaps. The play layers (beads, roots, body, seed, wheel) warm and cool by real time. · Built. · Energy.
22. **The 33 rooms with five gate mechanics** · ChakraConstellation.json; ChakraTeaching · W8 the 33 · Canvas (place the point), Textarea, Sound Response (mic), Tap Rhythm (pulse), Device Tilt (Axis blink, Crow shake). Plus mirror-frequency hums, three ways in, mudras, subtle-mirror twin doors. · Data is present. **Sound Response, Tap Rhythm and Device Tilt gates need implementation checks** (Views not read here). · Energy (practice). The story fields go to Feed.
23. **Held movement practices from his Codex** · ChakraMovement.swift · W8, W7 · Euphoria pulse by shake integral (2.4 g·s), roar → silence, last memories, Ham·Het·Hum 4-4-4 across Echo, Viśuddha and Sonar, fear in three waves, feeling-through, restlessness, Hṛdayam. · Built. Extend to Axis 18 (blink), Forge, Prāṇa. · Energy.
24. **Body chakras on the Climb at their heights** · ChakraTeaching.swift:298–343 · W7 · Soles at band 0 to Crow at band 6, presence by smoothstep. · Built. · Energy.
25. **Tree of Life ring grammar** · TreeOfLife.swift · W3, W4, W7, W14 · Press lengths rings 1–5, stillness rings 6–8, guide words thinning, the breath arc per ring, progressive luminance, Yoginī legibility, eight dissolutions, "Now go play." · Built. · Energy.
26. **Leela drops** · LeelaDrops.swift; GameStructure.json · W9 · Rare unannounced drops that end in a real-world action, answered "carry it" / "hold in silence". · Built. · Game (keep).
27. **Trinity of Guidance faces** · TrinityOfGuidance.swift · W5, W7, W3, W15 · Each face speaks its one line, once a day, at its seat, in its own light. · Extend to every named archetype (ruling 6). · Energy.
28. **Three pools** · ThreePools.swift · W12, W13 · Routes each act to the Portrait or the Well; a "being" note of today's arrival. · Built. · Structure.
29. **One ledger, never-drop queues, restore paths** · AirtableService; ActivityLedger; PracticeLedger · All · Every new world's act becomes a ledger type, and the existing patterns handle offline work. · Add types per world (e.g. Time, Relationship, Beneath). · Structure.
30. **Live Score per Śakti** · ShaktiFactsCache.swift:93–211 · W5, W6 · Light hue and glow, breath, carrier and fifth mode, tuned in Airtable without a rebuild. · Built. · Energy.
31. **Related Śaktis → the sister door** · ShaktiFactsCache 55–69; AirtableService 467–487 · W5, W15 · Doors between namesakes across rings. · Built. · Energy (relationship).
32. **Ring facts live** · RingFactsCache.swift · W4 · Gem, dhātu, time cycle, bīja, body region, Siddhi, mudrā, phase and notes per ring. · Built. · Energy.
33. **The Avaraṇa appreciations and forms** · Avarana.swift:34–85 · W4, W3 · Gratitude at each threshold. · Built. · Energy.
34. **Atmosphere, LightField, DayLight, DepthOverlay** · Theme · All · The per-Śakti palette, element backdrops that breathe, staged nine-beat arrival, the menu veil gradient (`Backdrop.veil`). · Built. · Energy (look).
35. **MandalaLight: one source, the veil, Tratak** · MandalaLight.swift · W3 Mandala + the Veil · The Bindu lights every seat through its ring's gem. The veil clears with nearness and stillness. Tratak at 20–45 s untouched. · Built. · Energy.
36. **SomaticRegion body map + sensory doorways** · SomaticRegion.swift · W6, W5 · Her place on his body as light, and an everyday doorway (heat, water, earth, breath, space). · Add `light` (C-3). · Energy.
37. **Random gift + morning summons** · EnergyGift; DailySummons · W2, W5, W11 · A gift lands on her. The summons names the day's energy. · Route the summons tap too (to the Bindu → Today). · Energy.
38. **Seeds that grow in real time / world visited** · PlayGardenStore.swift · W9 · A planted seed grows while he is away; gifts accrue in the world. · Built. Merge with PlayTrace. · Game.
39. **Wager → notice** · WagerStore.swift · W6 · "She appeared", noticed in passing. · Re-ground per 07:1323. · Energy.
40. **Rites: witness pages, garland recital, Pūjā** · RitesPractice.swift; ActivityLedgerRites · W10 Modes · The Khaḍgamālā recited inward ring by ring; the evening offering. · Built. · Energy.
41. **Codex write of his own word** · CodexWrite; CodexNoteStore · W12, W13 · "Leave my own word" becomes a Codex row. · Built. · Energy.
42. **Mauna at the point** · MaunaSilence.swift; RingFieldVoice.hush · W1 Home · A held silence at the centre hushes the field and records Silence Held at kp 102. · Built. · Energy.

## B2 · What is missing for the fifteen-world foundation (code-level)

- **No world model.** Nothing enumerates the fifteen worlds. The navigation enum lives in Views (`RootView.Destination` = 5 cases **[lookup]**). Needed:
  - a pure `World` enum (15 cases) with the three threads (kp, ch, day) as parameters
  - a `Place` value = (world, kp?, ch?, day?, sub-place)
  - and that `Place` used everywhere `Destination`, `GuidePlace`, `HomeDoor` and `RecognitionSource` are used now.
- **No Home / point as root.** Launch goes to `RootView` + Homecoming. Ruling 1 needs Home = the Bindu, with Today as the first door. `BinduPoint` (BreathClock 59–88), `BinduMemory`, Mauna, the Om floor and the point voice (RingAudioService 313) are ready to compose it.
- **No back stack or crossings model.** `DescentState` records ring depth only. Needed: a `Journey` history (back-to-where-you-were) and a crossing record (world → point → world) that can feed a ledger type such as "World Crossed".
- **No menu model.** `Backdrop.veil` exists as a look. There is no menu content, search index or door registry. Needed: an always-available menu listing the 15 worlds and their doors, plus a search over kp names, chakra names, modes, games and his own words.
- **No Relationship Field.** There are only `fieldName` / `fieldNote` on kp 31 / 40 / 42 (Gaia / Ashrey / Ram) and a related-Śakti graph. The register's `04` FB-07 "DO NOT BUILD" is superseded by ruling 10. Needed: a model of people ↔ Śaktis ↔ archetypes, an Airtable source, ledger types, and a world.
- **No Beneath model.** Pieces exist (the Shepard fall, Panel 9 dissolutions, Tratak, deep zoom geometry in Views), but no Beneath place or data.
- **No Time world.** The Ephemeris is complete; there is no world surface or state.
- **Modes and games are defined in Views** (`TheModes.Mode`, `PlayGame`, `PlayAddress`, `Mauna`, `Glissando`, `MandalaWorld` are referenced from Services / Models but live in Views / Homes). For "every game its own world" they should move to a pure catalogue in Models.
- **Ledger vocabulary gaps.** No Gesture Source for Chakra / Climb / Time / Relationship. No type for world crossings, Time acts or Relationship acts.
- **Per-world sound scenes.** The conductor knows four beds. Each of the 15 worlds needs a declared soundscape with user controls (now allowed).
- **Per-world breath.** One clock is a ruling now lifted. Allow per-world tempo while keeping the shared epoch for coherence.

---

# C · Conflicts and gaps

**C-1 · Ruling 1 (launch at the Bindu; Today first door).**
`BinduMandalaApp.swift:120–127` lays `HomecomingView` over `RootView()`. **[lookup]** `RootView.swift:9–32, 17` restores the last destination of `mandala | rite | well | the102 | memory` for the day. There is no Bindu / Home destination. This conflicts with ruling 1 and supersedes `04` FB-16 and MBB-09/10.

**C-2 · Ruling 2 (chakra 32 = Ego Reveal (Gaia); its words stay sealed).**
- *Agrees:* `ChakraConstellation.json:1546–1593` (road 32, kp 101, voice Gaia) and `ChakraTeaching.swift:262–285` (gaiaReveal = road 32).
- *Conflicts:* the full reveal text (leelaStory "It's me…", act1Voice "It was me.", binduReflection, witnessPerspective) is baked in the bundle at `ChakraConstellation.json:1576–1590`. **[lookup]** `Views/Chakra/ChakraRoomView.swift:215–226, 491` renders act1, bindu, witness, storyThread and leelaStory for any chakra with no sealing check. `Views/Mandala/ChakraRoad.swift:104` dwells at the Gaia reveal "long enough for the Map's own story".
- Only `LeelaDrops.swift:19` refuses sealed rows.
- **The sealing is not enforced in code.**
- Also: Lalita's record (`1627`) says the Reveal is "held in the build itself", and Integration's leelaStory foreshadows it (1437).

**C-3 · Ruling 4 (Ahaṅ fire, Nāma air, Ātma light, Amṛta water).**
- `ShaktiBootstrap.swift` tattva: kp 31 "Space (Ākāśa)" (53), kp 40 "Space (Ākāśa)" (201), kp 42 "Pure Being (Sat)" (235), kp 43 "Nectar (Amṛta)" (253).
- `Element.parse` (`Element.swift:28–36`) maps all four to **ether**. It has **no `light` branch at all**, so Ātma can never be light.
- `SensoryDoorway.forTattva` (`SomaticRegion.swift:108–116`) has no light doorway, and returns nil for "Pure Being".
- Sync overwrites tattva from Airtable (`AirtableService.swift:419`), so the live result depends on the Airtable text, which this reader did not see.
- `01` H-ARCH §2 claimed `parse` "matches the brief's element table". It does not match the ruling.
- **Fix:** an explicit kp → element table for ring 2 (ruling-sourced), and a `.light` case in `parse` and `SensoryDoorway`.

**C-4 · Ruling 8 (Maya's last line "only You, playing").**
- `GameStructure.json:77` (ring 9 seed) and `ChakraConstellation.json:1478` (Maya signaturePhrase) say "…only the Bindu, playing."
- `ChakraConstellation.json:1488` says "There was only — playing. Someone, playing."
- The register already noted the canon / prototype split (`05`:341, 375, 3385; `06`:88, 671–672, 1358, 1381).
- Both bakes must be re-baked or overridden.

**C-5 · Floor "nothing invented (bījas)".**
- `ShaktiBootstrap.swift` seeds a **shifted** vowel series: 9 `lṁ` (151; ḷṁ), 10 `eṁ` (167; ḹṁ skipped), 11 `aiṁ`, 12 `oṁ`, 13 `auṁ`, 14 `aṃ` (233), 15 `aḥ`, 16 **`kaṁ`** (267).
- The sixteen vowels are a ā i ī u ū ṛ ṝ ḷ ḹ e ai o au aṃ aḥ.
- `04` DS-09 shows the same series came from Design (`shakti-data.js`). It shows before the first sync and whenever sync is off. Airtable overwrites it (`AirtableService.swift:417`).
- Separately, `BijaSoundService.playBija` (108–121) makes a "bīja tone" from an FNV hash. It is a tone, not a voice, so the "no generated voice" floor holds, but it is labelled as her bīja.
- The bundled `bija_%02d` recordings are absent (dead path, 44–65).

**C-6 · Ruling 10 (restrictions lifted) — every place the code still enforces them.**

| Restriction | Where |
|---|---|
| One sound at a time | `SoundConductor.swift:3–31, 98–113` (`gains`: every non-front bed = 0) · `HomeSoundService.swift:762–776` · `RingFieldVoice.swift:85–96` · `SpeechCapture.swift:203` |
| One breath clock | `BreathClock.swift:3–17, 44–53` (Score tempos snapped to the beat) · `ShaktiFactsCache.swift:103` · `RiteOpenings.swift:72–75` · `HeartRegister.swift:68–70, 122` |
| Three controls / few doors | `RiteDay.swift:42–51` "Three doors, never five" · `HomeVoice.swift:50–52` "no in-app volume, no sound toggle and no mute button" |
| No menu | Not in Services / Models (**[lookup]** `Homes/Render/WorldClimb.swift:24` "no menus where movement will do"). The register's `07` §C.3 (07:1329): "no menu" is in none of the 352 Codex records; C-1350 asked for a visible menu. |
| Measuring-word bans (floors, not lifted) | `ActivityLedger.swift:488–501` (harness MEASURING patterns) · `Shakti.swift:66–76` · `MarginNoteStore.swift:14–20` · `MonthReading.swift:17–20` · `HomeMemory.swift:14–18` · `RingBija.swift:16–24` (bīja syllables may never be written) |

The "nothing scores him" floor stays. The **RingBija "never written"** rule and the **Tree of Life ring-9 "nothing asked"** rule (`TreeOfLife.swift:50, 85`) rest on Codex readings that `07` §C.3 flags as misreads (C-1307 at 07:1324). Re-examine both.

**C-7 · Ruling 6 (the dance draws on every archetype, all named).**
- `GuideFace` has five cases (`TrinityOfGuidance.swift:25–26`). `GameStructure.json` faces has five (87–118). Chakra voices use the same five.
- **Sid, Arch, Karishma and Ashrey are absent from the code and the bakes.**
- "Higher Self (Ram, his own)" (`TrinityOfGuidance.swift:15`) and `fieldName "Ram"` at kp 42 (`ShaktiBootstrap.swift:239`) tie the Higher Self face to a named person. This identity needs his word.

**C-8 · Ruling 10 (Relationship Field in full) vs the register.**
`04` FB-07 "DO NOT BUILD. Out of scope entirely." and FB-15 "relationships dropped" are superseded. The code holds only three field connections (`ShaktiBootstrap.swift:59, 205, 239`; `AirtableService.swift:420–427`). Nothing else exists (B2).

**C-9 · Floor "nothing scores him" vs status.**
- `ShaktiStatus.swift:18–25` draws mapped / exploring / active / embodied as opacity 0.22 → 1.0.
- `ShaktiBootstrap` seeds embodied / active statuses on a fresh install. `AirtableService.advanceStatus` (1069–1104) is a manual ladder.
- `04` DS-07/08 and FB-22 designed it, and the progress line was later superseded (DS-17).
- Whether a four-step "Embodied" ladder is a score is a ruling to ask.

**C-10 · Dead data and dead paths.**
- `GameStructure.json:82–86` (`axis` / "Access") is never decoded: `GameStructure.File` has no `axis`.
- `bija_%02d` voice files are absent (`BijaSoundService.swift:44–65`).
- `PlayGardenStore` and `PlayTraceStore` both record each game (two files, one act).
- `MandalaLight.enabled` `off` path is kept for tests only (`MandalaLight.swift:343–373`).

**C-11 · Two tunings for one ring.**
- Ring roots in `HomeCarrier.roots` (`HomeSoundService.swift:82`): ring 1 = 55, ring 4 = 73.42, …
- Field voices in `RingAudioService` / `RingFieldVoice`: ring 1 = 73.42 + 110, ring 2 = 130.81, ring 3 = 116.5, ring 6 = 207.65; stepped roots 146.84 / 164.82 (`RingFieldVoice.swift:70–76`).
- Once layering is allowed (C-6), these will sound together and disagree. Choose one root table.

**C-12 · Codex misreads baked into Services (from `07` §C.3).**
- `WagerStore.swift:77–89` reads C-1195 as watching a Śakti; 07:1323 says it is his kundalini and body-honouring.
- `TreeOfLife.swift:50` reads C-1307 as "not reached by doing"; 07:1324 says it is a Sakshi reveal line and does not forbid gestures.
- `RiteOpenings.swift:24` cites C-1120; 07:1330 says it should be C-1002 / C-1057.
- `SoundConductor.swift:5` applies C-1350 to the Mandala; 07:1322 says it is a Bindu Field playback-collision bug and that layering is wanted.

**C-13 · Spellings and names, code vs register.**
- Ring 7: "Vāk Ring" (`Avarana.swift:36`) vs "Vāk Chamber" (`KhadgamalaMap.swift:15`, `BijaSoundService.swift:161`).
- "10 Outer Triangles" (`Avarana.swift:36`) vs the Map's "Outer 10 Triangles" (JSON avaranaField).
- Chakra names are unaccented in the JSON (Muladhara, Svadhisthana, Aatma, Lalita) and accented in Swift comments (Mūlādhāra, Ātmā, Lalitā).
- `GameStructure.json` face "Lalita" vs code text "Lalitā".
- Ego Reveal `sanskrit` is null (1551).
- `04`'s Map name "Sarvakāmāvalī" and the 61 differing names (`01` H-ARCH §1): the code takes Airtable names with position as identity (option 3). No conflict in code, but every name shown is whatever Airtable holds.

**C-14 · Stale comments (code works, words lie).**

| File:line | Says | Now |
|---|---|---|
| `SilenceDwell.swift:13–14` | zero call sites | wired by HomeDwelling |
| `HomeMemoryStore.swift:18, 98` | zero call sites | HerRoomDoor, HomeDwelling |
| `AirtableService.swift:1414` | zero call sites until 3.6 | wired |
| `AirtableService.swift:1699–1707` | three-strike queue | `maxFailures = nil` |
| `MarginNote.swift:21–24` | three-strike queue | same |
| `RingAudioService.swift:6–11` | only `ringChime` | `RingFieldVoice` drives all |
| `HomeSoundService.swift:727–729` | descent silent | glissando exists via RingAudioService |
| `FIDELITY.md:127–132` | silence writer has no call sites | wired |

**C-15 · Views living in Services.**
`LeelaDropPresenter` / `LeelaDropView` (`LeelaDrops.swift:84–204`) and `TrinityVoiceLayer` (`TrinityOfGuidance.swift:123–186`) are SwiftUI views in Services. Move them when worlds get their own spaces.

**C-16 · Mixed audio-session policies.**
- `.playback`, which ignores the silent switch: `BijaSoundService.swift:307–309` and `VoicePlayback` (`SpeechCapture.swift:196`).
- `.ambient`: `RingAudioService.swift:48–59`, the room when `respectsSilentSwitch` (`HomeVoice.swift:101`), `HeartRegister.swift:182`.
- `.playAndRecord`: `SpeechCapture.swift:86`.
- Each restores the session differently. With layering allowed this needs one session owner, likely the conductor.

**C-17 · Story material in an energies app (ruling 5) — flag for Bindu Feed, don't drop.**
- `ChakraConstellation.json` storyThread / leelaStory / act1Voice / act2Voice / binduReflection / witnessPerspective, all 33.
- `MonthReading.letter` (`MonthReading.swift:140–160`) composes a narrative of his month.
- Leela drops stay: they are a game element (ruling 5).

**C-18 · Privacy floor.**
`GratitudeGrace` (`AirtableService.swift:2254–2270`; `GratitudeGrace.swift:5–15`) reads his Gratitude journal. It is permitted by his 12 Oct ruling (gameplan §4.4), read-only, one column, never written or synced elsewhere. Keep it, and keep it to that one column.

**C-19 · Ledger semantics for new rooms.**
`chakraPracticed` writes `Gesture Source = Mandala` (`ActivityLedger.swift:461`), and `lightEntered` writes Room. There is no source value for the 33, the Climb, Time or the Relationship Field. Typecast will create new options when needed (`ActivityLedger.swift:43`), so this is cheap to fix.

---

# D · Coverage proof

`wc -l` and md5 (first 8) computed at read time. Method R = Read tool, every line in order. Long files were paged with offset/limit; the ranges are contiguous.

| File | Lines | Read (ranges) | Method | md5 |
|---|---|---|---|---|
| BinduMandalaApp.swift | 206 | 1–206 | R | b9c40a83 |
| ../FIDELITY.md | 132 | 1–132 | R | 26ec9427 |
| Data/ActivityLedger.swift | 1371 | 1–700, 700–1371 | R | 84ba4d9a |
| Data/ActivityLedgerRites.swift | 69 | 1–69 | R | 36798711 |
| Data/AirtableService.swift | 2419 | 1–700, 700–1599, 1600–2419 | R | 6cf430f4 |
| Data/BinduSchema.swift | 356 | 1–356 | R | 9b572613 |
| Data/CodexWrite.swift | 129 | 1–129 | R | bfbf2bb2 |
| Data/PersistenceRecovery.swift | 123 | 1–123 | R | 8d5cc307 |
| Data/RingFactsCache.swift | 72 | 1–72 | R | 946e98cc |
| Data/ShaktiBootstrap.swift | 303 | 1–303 | R | 628600af |
| Data/ShaktiFactsCache.swift | 211 | 1–211 | R | 69bc7f8b |
| Data/GameStructure.json | 211 | 1–211 | R | 6e37a350 |
| Data/ChakraConstellation.json | 1642 | 1–300, 300–529, 530–789, 790–1039, 1040–1339, 1340–1489, 1490–1643 | R (in full; plus a structural `python3 -I` key/row check) | 70211e07 |
| Models/Avarana.swift | 86 | 1–86 | R | ed6f27d9 |
| Models/ChakraConstellation.swift | 244 | 1–244 | R | 9aedadde |
| Models/ChakraMovement.swift | 179 | 1–179 | R | d39bc5f4 |
| Models/ChakraTeaching.swift | 343 | 1–343 | R | 33435ac0 |
| Models/Cluster.swift | 41 | 1–41 | R | 06d9b2cc |
| Models/DescentState.swift | 78 | 1–78 | R | 95923f40 |
| Models/HomeMemory.swift | 200 | 1–200 | R | f67af339 |
| Models/KhadgamalaMap.swift | 62 | 1–62 | R | 6534b905 |
| Models/LetterDraft.swift | 27 | 1–27 | R | 6dbb3acf |
| Models/LivingMandala.swift | 111 | 1–111 | R | 9953dccc |
| Models/MarginNote.swift | 79 | 1–79 | R | 945d4528 |
| Models/MonthReading.swift | 187 | 1–187 | R | 745ccfab |
| Models/NityaDevi.swift | 38 | 1–38 | R | 9188eac8 |
| Models/RecognitionEntry.swift | 66 | 1–66 | R | 4c451793 |
| Models/Shakti.swift | 163 | 1–163 | R | 8b7a8f8c |
| Models/ShaktiLetter.swift | 50 | 1–50 | R | 4bfaa501 |
| Models/ShaktiStatus.swift | 35 | 1–35 | R | a252b90f |
| Models/SomaticRegion.swift | 130 | 1–130 | R | 744b59a9 |
| Services/BijaSoundService.swift | 318 | 1–318 | R | aa551806 |
| Services/BinduMemory.swift | 79 | 1–79 | R | 0ea66f79 |
| Services/CodexNoteStore.swift | 54 | 1–54 | R | dac54690 |
| Services/CorrespondenceStore.swift | 376 | 1–376 | R | af2fc179 |
| Services/DailyEnergyService.swift | 99 | 1–99 | R | 9d734fb9 |
| Services/DailySummons.swift | 158 | 1–158 | R | cff6e19e |
| Services/EnergyGift.swift | 202 | 1–202 | R | 1fbc8e7a |
| Services/Ephemeris.swift | 431 | 1–431 | R | 8a1eeaac |
| Services/GameStructure.swift | 96 | 1–96 | R | 5bf7c743 |
| Services/GlissandoVoice.swift | 94 | 1–94 | R | a24167af |
| Services/GratitudeGrace.swift | 119 | 1–119 | R | 71f98ed2 |
| Services/HeartRegister.swift | 275 | 1–275 | R | 6254fd51 |
| Services/HomeDwelling.swift | 225 | 1–225 | R | 600a8884 |
| Services/HomeMemoryStore.swift | 136 | 1–136 | R | 5380fe75 |
| Services/HomeSoundService.swift | 1177 | 1–600, 600–1177 | R | d281a41a |
| Services/HomeVoice.swift | 278 | 1–278 | R | a718b90f |
| Services/LeelaDrops.swift | 204 | 1–204 | R | 4e4138ce |
| Services/LunarPhaseService.swift | 139 | 1–139 | R | 68a66b19 |
| Services/MarginNoteStore.swift | 112 | 1–112 | R | b23118e2 |
| Services/MaunaSilence.swift | 46 | 1–46 | R | 08cefa2b |
| Services/PlayGardenStore.swift | 88 | 1–88 | R | ca3800da |
| Services/PlayTraceStore.swift | 105 | 1–105 | R | 0e338d17 |
| Services/PortraitStrokeStore.swift | 157 | 1–157 | R | 8908c1ce |
| Services/PracticeLedger.swift | 98 | 1–98 | R | f4a4da12 |
| Services/PracticeVault.swift | 67 | 1–67 | R | c0d67809 |
| Services/RecognitionLogStore.swift | 92 | 1–92 | R | 1edeb917 |
| Services/RecognitionMigrator.swift | 55 | 1–55 | R | 0a2df6a7 |
| Services/RingAudioService.swift | 838 | 1–450, 450–838 | R | a7082089 |
| Services/RingBija.swift | 141 | 1–141 | R | 7f578500 |
| Services/RingFieldVoice.swift | 306 | 1–306 | R | fca67982 |
| Services/RiteDay.swift | 344 | 1–344 | R | ab260fb2 |
| Services/RiteOpenings.swift | 264 | 1–264 | R | da78e9e2 |
| Services/RitesPractice.swift | 158 | 1–158 | R | d6d00b25 |
| Services/SilenceDwell.swift | 38 | 1–38 | R | fa063466 |
| Services/SoundConductor.swift | 271 | 1–271 | R | 4cb42bce |
| Services/SpeechCapture.swift | 224 | 1–224 | R | e952af6b |
| Services/ThreePools.swift | 127 | 1–127 | R | 4e1b19db |
| Services/TreeOfLife.swift | 229 | 1–229 | R | 9124253e |
| Services/TrinityOfGuidance.swift | 186 | 1–186 | R | f5e3f3be |
| Services/WagerStore.swift | 124 | 1–124 | R | d9f383c5 |
| Theme/Atmosphere.swift | 160 | 1–160 | R | 9bf7adfc |
| Theme/AtmosphereBackground.swift | 73 | 1–73 | R | 1d9e20c9 |
| Theme/BreathClock.swift | 88 | 1–88 | R | 4f8f3bed |
| Theme/Color+Tokens.swift | 52 | 1–52 | R | 9cba9686 |
| Theme/DayLight.swift | 156 | 1–156 | R | aac644f3 |
| Theme/DepthOverlay.swift | 71 | 1–71 | R | dd1cb367 |
| Theme/Element.swift | 48 | 1–48 | R | 648eb103 |
| Theme/Fonts.swift | 169 | 1–169 | R | 3d5d491d |
| Theme/HSL.swift | 44 | 1–44 | R | 0d65612c |
| Theme/Haptics.swift | 7 | 1–7 | R | d8386748 |
| Theme/Layout.swift | 12 | 1–12 | R | f69d90b5 |
| Theme/LightField.swift | 253 | 1–253 | R | 332c59e1 |
| Theme/MandalaLight.swift | 417 | 1–417 | R | 846e696d |
| Theme/SeatLighting.swift | 11 | 1–11 | R | dd89a7fc |
| CLAUDE.md / README (repo root) | — | — | not present (`ls`) | — |

**Total read:** 84 Swift files + 2 JSON files + FIDELITY.md = **19,454 lines** (19,322 in the assignment + 132 in FIDELITY). Nothing was skipped.

**Not read, outside this assignment, used only as grep lookups and marked [lookup]:** `Views/Root/RootView.swift`, `Views/Chakra/ChakraRoomView.swift`, `ChakraRoomDoor.swift`, `Views/Mandala/ChakraRoad.swift`, `Views/Rooms/HerRoomDoor.swift`, `Views/Play/PlayGameHost.swift`, `Homes/TheBuilding.swift`, `Homes/Render/WorldClimb.swift`. The `Homes/` folder (12 files + Render) is referenced by these Services (`HomeWorlds`, `HomeGem`, `HomeGrammar`, `HomeDescent`, `Mauna`, `WorldClimb`) and should be in another reader's assignment.
