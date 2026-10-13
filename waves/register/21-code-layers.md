# THE REGISTER · 21 — Code layers: Memory · Modes · Common · Spike (code reader and parity check)

*Reader 21 of the second reading, 12 Oct 2026. Read-only. Source root on disk: `iOS/Bindu Mandala/Views/` (the app target's synchronized root folder is `iOS/Bindu Mandala/`; the path given in the task, `iOS/Bindu Mandala/Bindu Mandala/Views/`, does not exist — this is the same tree).* Compared against `03-mandala-worlds-layers.md` §A0.5, A11 (eight modes), A12 (memory), A13 (temporal), A14 (relationship), §D; `02-rite-axis-field.md` L-21/L-22/L-23 and §D; and `waves/foundation/FOUNDATION-2026-10-12.md` (the fifteen worlds, "Under the ground").

Every file below was read in full with the Read tool (40 files, 14,038 lines). Line numbers are the file's own.

---

## A · PER-FILE MAP

Columns: **file · lines · purpose · world it serves · register items it realises · data read/written · hard-coded restrictions (now lifted by the 12 Oct ruling unless a floor) · defects**.

### A1 · Views/Modes/ (8 files, 1,246 lines)

| file | lines | purpose | world | register items | data | hard-coded restrictions | defects |
|---|---|---|---|---|---|---|---|
| TheModes.swift | 235 | Pure models + all words for five modes: `TheModes.Mode` (darshana, sadhana, smriti, svapna, puja), `DarshanaDepth`, `Sadhana`, `Smriti`, `Svapna`, `Puja` | the Modes | 03 M1, M3, M4, M6, M7 | `KhadgamalaMap.total`, ring of kp | **":6 Saṅgha is ruled out"**; Mauna not on the door (:23, :56-59); "nothing counts him" (:25-26); Smṛti "A state, never a count" (:17, :160-165); Darśana depth "never shown" (:76-78) | Saṅgha exclusion contradicts ruling 10 (Relationship Field built in full). Sādhana words drift from Design (see B-Modes). |
| ModeField.swift | 128 | `ModeGeometry` (kp → world point; ring 1 on the square perimeter, rings 2–8 on circles, ring 9 origin, :11-26), `ModeYantraBackdrop` (CentreYantra at wake 0.16+0.84w, names hidden, :48-68), `ModeLight` (halo r×3 at .6α + cream core, :71-82), `ModeRestButton` (44 pt, :85-101), `ModeHeading` (lowercase italic title, tracking 4.2, top 60, :105-128) | the Modes | 03 MiniYantra (L15-53) replaced by the real CentreYantra | `MandalaWorld.ringRadius`, `ClimbLights.seatsInRing`, `LivingStrokesLayer.color(forRing:)` | — | Ring-1 seats sit on a square here but on a circle in the Portrait (PortraitMandalaView:451) — two geometries for one seat. |
| ModesDoorView.swift | 124 | The one door: list of five modes, ordered by hour (`ModesDoor.order`: 4–10 → Svapna first; 17–24 → Pūjā first, :116-123); Mauna gloss in gold; "return to the field"; `ModeHost` opens one mode where it lives (the Rite) | the Modes (door lives on the Mandala, `LivingMandalaView.swift:207`, and Play field `PlayFieldView.swift:197`) | 03 §D-9 "time opens modes" (lean only) | `Calendar.hour` | "nothing is locked" (:9) | Hour bands are clock hours, not the sun: Design's Pūjā is "after sunset", Svapna "first open of the day"; `Panchanga.sandhya` exists (ThePointView:122) but is not used. Door is a list on a dark ground (`#040104`) — a menu page, not a world. |
| DarshanaView.swift | 112 | Beholding: StillnessSensor → `DarshanaClock` every 0.1 s; three grounds darken; radiance (gold .22 / red .10, 540 pt, breath on `BreathClock.breath`) only past depth .85; yantra wakes and turns `t·0.4·depth`°; point grows 10→18 pt | Modes | 03 M1 | CoreMotion (no permission) | depth never shown; "beholding · 30s" said as "beholding" (:19-20) | No bījas at holding (Design: each bīja at r = yantra×.62, 13 px gold .55, delay i×.35 s); no yantra size steps 280/320/360; no motes 6/10/14; no chrome fade; no "phone vertical" check. `DarshanaClock` is a plain class in `@State` — works only because TimelineView redraws. |
| SadhanaView.swift | 286 | The Khaḍgamālā: saṅkalpa → recitation (102 names, `perName` = 28 min/102 ≈ 16.5 s, polled every 0.25 s) → visarjana (14 s) → remains; ring crossing "You leave the … / You enter …" for 6 s; bīja per name via `BijaSoundService.playBija(s.bija, seed: kp)`; keeps one `RitesPractice.recite(startedAt:reachedRing:whole:)` | Modes | 03 M3 | `Shakti.name/quality/bija`, `Avarana.sanskritName/subtitle`; writes ledger via `PracticeLedger.flush` | pace "never shown"; ring dots and "{n} of 102 · Ring {r}" dropped; Design's tap-to-continue transitions replaced by a clock | `soundOn` reads `lr_sound` **default true** (:30) — register 02 §D-16/23 says the chime/sound toggle defaults **off**. No Bindu station ("Lalitā" · "aiṁ klīṁ sauḥ"). Words not verbatim (B-Modes). Most of the 86 have no bīja → recitation mostly silent; `playBija("")` behaviour unverified. |
| SmritiView.swift | 98 | Constellation of memory: every felt seat lit (one light, twinkle .82–1), same-day seats threaded gold .16, unfelt seats a .18 breath | Modes | 03 M4 (full view only) | local `RecognitionEntry` (felt only) | "Design's '23 catches' and 'day 191 of 264' are not drawn" (:10) | Reads only the phone's own record (no Airtable history) — a reinstall shows an empty sky. Cluster view, timelapse scrubber, All/Year/Month/Week filters, tap-star → her log: not built. Word drift: Design "where she has been most alive" → code "where she has been alive in you" (:96). |
| SvapnaView.swift | 109 | "Who walked through last night?" answered **by the record**: Śaktis felt on the previous practice day drift as dream-light near their seats, names beside them; dawn gradient indigo → rose | Modes | 03 M6 (reinterpreted) | local `RecognitionEntry` | "Nothing asks him to recall or write" (:8-9) | Design's Svapna is the practitioner telling the dream: "I felt someone" / "The night was still" buttons, tap petals to mark, "HOLD TO ADD A NOTE", voice recording with transcription, "OR WRITE". The code inverts it (record answers) — Design's dream entries (contract: "dream entries (Svapna) — voice + text") are absent. |
| PujaView.swift | 154 | Evening offering: today's felt Śaktis as lights at their seats; 2.4 s hold ring → lights gather to the point (0–40%), rise 160 pt and dissolve (40–100%) over 6 s; "The day is received. / Tomorrow opens again." fades in after 2.5 s; `RitesPractice.offerTheDay` + `RiteHooks.dayClosed()` | Modes | 03 M7 | local `RecognitionEntry`; writes ledger | "five recognitions, this day" not drawn (:9-10) | Offering list (time · name rows) not built; Design's "offer the day" was a button, here a hold; swipe-down-from-top evening gesture not built. |

### A2 · Views/Memory/ (12 files, 3,774 lines)

| file | lines | purpose | world | register items | data | hard-coded restrictions | defects |
|---|---|---|---|---|---|---|---|
| PortraitMandalaView.swift | 815 | The Portrait: 102 points (ring radii 158/123/95/78/65/52/40/26/0 on a 344 base, :449-462), ring-2 lotus petals (oR 134 iR 112 hw 22, :663), four faint triangles 90/70/50/32 (:485-490), year ring, play layers, his strokes, bindu (sealed lid while a letter is sealed); settle flight 3.4 s (fly 0–.34, halo .34–1) when arriving < 60 s after a recognition; long-press 0.9 s → 1500 px export "hold this image"; six doors: draw into her rings · the point · the river · where she speaks · the book · the month | Memory (and the Sky) | 03 MEM-1; 02 L-23 settle | `RecognitionEntry` (felt), `PortraitStrokeStore`, `CorrespondenceStore` letters & lights, `PlayTraceStore`, `Shakti` accents | whisper "she is felt, not measured" (:165); "No app branding, no numbers" in export (:80) | `PortraitStats.intensity = min(1, count/12)` (:414) — **count drives brightness** here while Smṛti refuses counts (TheModes:160-162): the two memory surfaces disagree. Ring-2 local index `kp − 28` hard-coded (:340). `settleIfRecent` takes `store.latest()` of any gesture (:385-387) — a **silence** can fly as if felt (contradicts Wave 0 · B3). Petals are not tappable (Design: "TAP ANY PETAL · OPEN HER BIOGRAPHY"). Year ring is this year only (:277). Reads local store only. |
| LivingMandalaLayers.swift | 154 | `LivingStrokesLayer` (his strokes mirrored n-fold by the ring begun in, colour = ring hue lifted s+10, l≥58), `YearBead`/`YearRingLayer` (bead at its own day-angle, r .977, glow 4.5, core 1.4; gaps kept as space C-1348), `StrokeCaptureLayer` (unit coords), `SealedLid` (eye closed while a letter is sealed) | Memory | Wave 5 Living Mandala | `PortraitStroke` | — | none found |
| LivingPlayLayers.swift | 147 | Play-fed layers as **states** (warmth cools to an ember, never zero): root web (9 roots, brown), practice wheel (a spoke per game, r .30–.37), body petals (7 along the axis), seed bloom (8 green petals), bead ring (102 beads at r .945, held beads lit) | Memory ← A Strange Game | Design's *Living Mandala* layers | `PlayTraceStore.traces`, `PlayLayers.*` | "No count anywhere" (:10) | Root end-point uses `sin(startA)` for y but `startA+0.25·sin(i)` for x (:63-64) — asymmetric, cosmetic. |
| ThePointView.swift | 290 | The Point: Bindu gaze + **five clocks** (hour 24 ticks r158 · tithi 30 ticks r130 · nakṣatra 27 r102 · season 6 r74 · sun 12 r48; unit = side/390), trembling `unsteady·2.4·sin` while he moves; sandhyā junction gold wash; legend rows (hour · sandhyā name, paksha + tithi, nakṣatra, ṛtu · English, rāśi · ayana). `TemporalReading`, `FiveClocks`, `StillnessSensor` (motion < .035 → +dt/6 s; else −1.2·dt; soft haptic at full) | Time (reached only from the Portrait's centre) | 03 TMP-1 Cosmic Now | `Ephemeris`, `Panchanga`, `TemporalPlace` | "none of them is a guess" (:12-14) | Tithi wheel 30 ticks vs Design 15; Design's "THIS MOMENT" line ("Sandhyā · the evening junction. / Anurādhā watches the moon waxing.") and "ŚUKLA PAKṢA · DAY 13 · MOON 78% FULL" not built. Cosmic Now has no world of its own. |
| CorrespondenceView.swift | 689 | The River (Well as river, C-1346): due / sealed downstream / the river / light sent back; `RiverComposer` (forward to her day with `RiverLetter.Opening` e.g. `.purnima`, back to a moment; recipient: her · myself at an age 0–120 · a memory · past self · later self; voice letter; draft autosave 2 s + on background); `LetterRevealView` word by word every 0.24 s after 0.8 s; `RiverCurrent` (7 blue strands .05α); patina tint (0.62,0.46,0.20) | the Well / Beneath | Wave 5–6 River (C-1346, C-1126, C-1325) | `CorrespondenceStore` letters, lights, draft; `SpeechCapture` | "There is no peek" (:512); "Nothing here … answers" (:11) | none found. |
| LightBackViews.swift | 264 | `SendLightBackView` (moment picker, her light picker, words, 2.4 s hold; "It has gone back. It was always going to arrive."); `LightSentBackCard`; `HigherSelfNameView` ("Close your eyes. Ask for the name of your higher self, and let it surface." → keep, history kept) | the Well / Beneath | C-1126, C-1101, C-1325 | `CorrespondenceStore.sendLight`, `BinduMemory.keep` | — | none found. |
| ArchiveBookView.swift | 324 | The Archive as a book: readable letters, margin notes, recognition notes, lights-with-words, Codex notes, oldest first; **the exact middle page is a door "go down ›" into `DescentFilmView`**; frontispiece "the book of {higher-self name}"; last page "the next page is not written yet" → "seal it forward" / "leave my own word in the Codex ›"; patina `1 − e^(−days/240)`; `CodexNoteComposer` (spoken/typed, Source App "Bindu Mandala") | Memory (the Record) | Bindu Feed's final Wave (book) | all stores; writes Codex | — | Story-shaped (a book of his words) — candidate also for **Bindu Feed** (see C). |
| MonthMirrorView.swift | 437 | `MemoryRecord.acts` (felt, silence, letter, light, note, codex, drawing, played); Month Mirror: day glyphs round a circle (ring light, a dot per Śakti met ≤12, ember if sealed), touched rings lit, "What moved through the month" per ring, "The turning", "The month, witnessed", `MonthSittingView` ("does this land?" · it lands · say more · leave my own word → Codex) ; "This is a mirror. / It holds the season up to the light, and asks nothing of you." | Memory | Bindu Being MonthMirror + Bindu Feed day glyphs | all stores; `MonthReading` | month › capped at today (:168) | Month letter/witness sentences are composed by template in `Models/MonthReading.swift:120-163` ("You stopped for …", "you set letters into the river") — from his record, but generated phrasing; check against "nothing invented". |
| WhereSheSpeaksView.swift | 232 | "Where is she speaking?" — body as places of light (axis 0.05–0.86, aura, regions crown…soles + spine + field, each in its nearest ring hue), touch a place → Śaktis whose `bodilyLocation` names it orbit it → chips → `ShaktiDetailView` | Memory / Her Presence (somatic way in) | Wave 5 Body as Scripture | `Shakti.bodilyLocation` via `SomaticRegion` | "never as a figure, and never as hers" (:7-8) | Depends on `bodilyLocation` coverage across the 86 (unverified here). |
| HeartRegisterView.swift | 127 | The Heart Register: his Sa chosen once (`HeartRegister.saChoices`), drone breathing on `BreathClock`, call-and-answer toggle; sound only on first touch | Her Home (ring 2 only) | Wave 6 | `HeartRegister`, `HeartRegisterEngine` | sound never on arrival (:5) | Offered only when ring == 2 (HerDeepeningSection:153). |
| DescentFilmView.swift | 221 | "The descent, remembered": one frame per ring crossed (RingGlyph 96 gold, Sanskrit name, subtitle, "the way opened · {date}"), 4.5 s per frame, tap advances; ring 1 "the ground", ring 2 "home" | Memory (reached from Settings "Remember the descent" and the book's middle) | v1 §9 stretch | `DescentState.crossings`, `Avarana` | — | Assumes crossings start at ring 3 (`ring = 3 + i`, :35-38) — ring 1/2 never carry a date. |
| VoiceWord.swift | 74 | `VoiceWordButton` ("speak it" / "set my voice down" / "listening for your words…" / "the microphone is closed — write it"), `VoicePlayButton` ("hear your voice"/"stop your voice") | shared (Well, Book, Month) | Wave 6 voice door | `SpeechCapture`, `VoicePlayback` | "Nothing else is ever heard here" (:54) — floor: no generated voice | none found. |

### A3 · Views/Common/ (12 files, 4,620 lines)

| file | lines | purpose | world | register items | data | hard-coded restrictions | defects |
|---|---|---|---|---|---|---|---|
| WellView.swift | 517 | The Well: "Your Letters to Them", one private letter per Śakti for **all 102**, ring accordion in order [2,1,3…9] (:28), ring dot = "your words live here"; "the river ›"; `LetterEditorView` (atmosphere-lit, autosave 2 s, on `.inactive`, only when dirty; Airtable PATCH fire-and-forget); `OPEN_LETTER=<kp>` | the Well (Beneath) | 02 L-21/L-22 (extended from 16 to 102) | `ShaktiLetter`, `LetterStore`, `AirtableService.saveLetter` | "Nothing here counts" (:13) | It is a NavigationStack list reached from the hamburger (RootView.swift:62) — a page, not a world under the ground. |
| AvaranaThresholdView.swift | 267 | The threshold of one enclosure: sigil 620·k at .42 height, staged arrival (form kicker .20 s → name .35 → subtitle .50 → hairline .70 → Personal Connection .80 → appreciation .95 → mental state · chakra 1.05 → shape · presiding form · yoginī 1.15 → "enter her ring" 1.25) | the nine rings | 02 L-18, 03 V2-03 | `Avarana` fields | — | First-kp table duplicated with TheHundredTwoView:214. Top bar prints "{n} ŚAKTIS" (fine now). |
| TheHundredTwoView.swift | 592 | The Field: nine rings accordion (today's ring open), RingChip breathing at `FieldBreath.period`, RingRoomGeometry 360 pt at .5, seat rows (felt = warmer dot), DoorwayArch → her room, "rise through them ›" → `WorldClimbView` | the nine rings / the Climb door | 02 L-17 | `RecognitionEntry`, `Shakti.serverRecognitionCount`, `HomeMemory` | Law-2 comments (felt warmer, never counted) | `countByKp` fallback `s.position + 28` (:289, :424) is right only for ring 2 — a row of another ring with no kp is mis-keyed. Prints `seats.count` per ring (:352). |
| ShaktiDetailView.swift | 1145 | Her Presence (Detail): hero (kicker, name 44, Devanāgarī, phonetic, quality, qualityDescription, cluster for the 16), One-Page Answer, Codex Portrait (gold, never truncated), somatic signature, bīja tap-to-hear (84 pt, 3 resonance rings 0.7→3.4 over 3.6 s), appreciation, doorways/seal/wager, witness page, deepening, embodiment track + 0.75 s hold crossing, field connection, folds "her moments" and "go deeper" (iconography, lineage, cosmic function, tattva, bodily seat, etymology); footer "be with her ›", "{verb} with her ›", "I feel her" | Her Presence | 02 L-13, L-19, L-11 | `Shakti` row; `AirtableService.fetchRecognitions`; `advanceStatus` | folds closed on every visit and never remembered (:23-28); level never spoken (:431-435) | **Embodiment readiness is gated by `serverRecognitionCount` thresholds 1/3/7** (:521-532) — a count deciding a crossing (floor: "nothing scores him"); also ignores local felt moments. `HerMomentsList` shows "she was felt here · {time}" — floor line used as a timestamp prefix (verbatim kept). |
| HerDeepeningSection.swift | 189 | Each return (≥ 20 min gap) opens one more layer: what she does · what her ring sets down · what her ring gives · the root of her name · how she is known · her enclosure; her seed verb always shown; "the heart register ›" for ring 2 | Her Presence | Codex C-1354 | UserDefaults `herDeepening.visits.v1`, `RingFactsCache`, `ShaktiFactsCache` | "place, not progress", "nothing is locked" (:11-13) | Layers **are** withheld by visit count (:52-56) — a lock in practice; under the lifted rulings this should be his choice, not a counter. |
| HerDoorwaysSection.swift | 201 | Everyday doorway (tattva → `SensoryDoorway`, her somatic line), the seal (2.4 s hold → her Appreciation/recognition phrase), "SHE MIGHT APPEAR TODAY" (C-1195) → "I noticed her" | Her Presence | C-1337, C-1237, A12/C-1195 | `WagerStore` | "nothing watched for" | none found. |
| HerWitnessPage.swift | 220 | One-Page Answer (C-1279: her line, or "the whole of her home ›"); Witness Page (C-1280): sealed envelope, 1.8 s hold "ask for help" → her Function/description + his perspective beside it, kept every save (`Witness Written`) | Her Presence / Beneath (witness) | C-1279, C-1280 | `RitesPractice.write(witness:)` | page reseals on leaving (:60-61) | none found. |
| HomecomingView.swift | 460 | The Homecoming: first time — 90 seeded motes condense 2–11 s, "You have always felt them." 11.8 s, "Now you will know their names." 14 s, hint 16.5 s; every return — one 4 s breath (blink .35, draw .9, open); covenant = one still finger for 4 s → Recognition of today's Śakti; point tone 136.1/204.15/272.2 Hz, 3.6 s, vol .045; yantra draws outward from the point (`drawProgress` by mean radius) | Home (the Bindu) | Wave 3 Origin, G17 | `SriYantraGeometry.layers`, `DailyEnergyService` | `SKIP_HOMECOMING` for tests | Ruling 1 (launch arrives at the Bindu, Today first door) — Homecoming finishes into RootView; whether that is the Bindu is outside these files. |
| MarginView.swift | 536 | The Margin: composer ("Say what you see. It will be read.", no save button, autosave 2 s, ledger once on leaving, `MarginComposition.openNoteId` interlock), list "What you have left", reader; `MarginDate` (written vs spoken, no numerals spoken) | Settings / Memory (his notes) | — | `MarginNote`, `AirtableService.recordNote` | no edit, no delete (:26-32); no numerals spoken | none found. |
| SettingsView.swift | 434 | Settings: The Margin · Daily Rhythm (summons hour 5–22) · A Gift (window 10–20) · **Field Connections** (kp 31 "Gaia" "She anchors here.", kp 40 "Ashrey" "She weaves through here.", kp 42 "Ram" "Holds her frequency.") · Bīja note · The Way Behind ("Remember the descent") · Homecoming re-enter | Settings (and the seed of the Relationship Field) | — | `Shakti.fieldName` | "Once a day, never twice" (:166) | Field Connections is the **only** relationship data in the app — three hard-coded seats. |
| BottomScrollFade.swift | 20 | 28 pt fade at a scroll's foot | chrome | — | — | — | none. |
| SwipeBackEnabler.swift | 39 | Restores edge-swipe pop when the back button is hidden | navigation | — | — | — | none. |

### A4 · Views/Spike/ (8 files, 4,047 lines) — experimental apparatus

| file | lines | purpose | ships in Release? | notes |
|---|---|---|---|---|
| SpikeBench.swift | 163 | Measures a scene in its own window for 20 s after 1.5 s warm-up; hides other windows; emits `SPIKE_METRIC {json}` | No — `#if DEBUG` (:5) | Simulator numbers only. |
| SpikeField.swift | 140 | Deterministic synthetic 102 (generated names 10–16 chars from syllable tables, kp%4==1 felt = 26 seats, today kp 29, bloom kp 53) | No (:5) | Synthetic. |
| SpikeMandalaHarness.swift | 237 | Scenes: control, tier0 all seats, tier2 bloom (every 4 s), descent (0.95 s easeIn, period 2.5 s); renders the shipped `MandalaCanvasLayer` | No (:5) | `lightOn: MandalaLight.enabled` — measures what ships. |
| SpikeMetrics.swift | 305 | phys_footprint, CPU seconds, host load, process age, injectable `Clock`, CADisplayLink `FrameSampler`, `Report` (stamped "iOS Simulator — relative comparison only; not a device figure") | No (:5) | — |
| MandalaDrawCensus.swift | 229 | A **model** of `MandalaCanvasLayer`'s primitives per frame (120 stars, enclosures ×3 when lit, yantra 3+triangles, seats ≤6 each, names, bījas, bindu) | No (:5) | Pinned by `MandalaDrawCensusTests`. |
| GarimaCanvasRoom.swift | 1327 | Renderer variant B: Garimā (kp 4) room in pure Canvas — descending mass (`11 − k·7.4 + b·5.2`), strata (32 beds, thickness 5–27, value step `(rnd−.42)·90`, clamp 14–232, seven-bed swell), raking light normalize(9,6,4) with analytic shadow plane, ember inverse-square, 72 motes, veil; clocks 62 s / hold 227 s / second 120 s → 347; reduce motion quantised to 0 / 227 / 400; gem diffusion table (topaz .20 … pearl .95, cat's-eye .10); altitude from bodilyLocation words; `GARIMA_ROOM` launch hook | No (:4) | Fixture claims Airtable values incl. appreciation "Thank you for the weight that holds me here." (:1156) — unverified here. |
| GarimaSceneKitRoom.swift | 1511 | Renderer variant A: SceneKit strata as 96×96 morph meshes (base/pressed/risen), mass box 46×4.4×46 with 56×56 relief underside, rim bars, palm-press cone (r 1.15/1.35, h .30) tinted by `ATTR_TINT[4] = 0xB8263C`, raking directional 2600 (shadow map 1024², radius .5+6·diffusion), ember omni 3200, ambient 520, 460 GPU dust points, fog 12–58; `Physics` classifier (settle/lift/widen/shrink/flow/flare/open/brighten) with Design's `displace` formulas; body-altitude zones (feet .94 → crown .10); reduce motion poses once at 360 s and stops the render loop; census of draws; `SPIKE_ROOM=garima-scenekit` | No (:12) | `cluster: ring == 2 ? nil : nil` no-op (:213). Attribute-tint table for 15 positions (:414-418) is Design data worth keeping. |
| **GarimaSceneKitRoom.metal** | 135 | `garimaLightPass` stitchable colour effect: rake wash, gem-sharp shafts `pow(max(0,sin(along·9+phase·2π)),26)`, ember bloom `exp(−d/r)`, ground light by altitude, grain, clamp .86 | **YES — ships in Release** | The file says so itself (:6-9). Confirmed: the target is a `PBXFileSystemSynchronizedRootGroup` whose only exceptions are the xcconfigs, `Fonts/README.md`, `Info.plist` (`project.pbxproj` :33-45) — so the `.metal` compiles into `default.metallib` in every build. Its only caller (`GarimaSceneKitRoom.swift:1252`) is `#if DEBUG`. Dead shader weight in Release; harmless but should be excluded or deleted with the spike. The production pass is `Homes/Render/RoomLightPass.metal` (used by `Homes/Render/RoomView.swift`). |

**Spike verdict.** All eight Spike Swift files are experimental measuring apparatus, wrapped in `#if DEBUG`; none is referenced from shipping code (grep: `GarimaRoomLaunch`, `GarimaSceneKitRoom`, `SpikeBench`, `presentIfRequested` appear only inside `Views/Spike/`). The one leak is the `.metal` file. What the spike *proved* is the gift: a Design room (`chamberPress`) can be ported faithfully either way, the Canvas path is cheap and exact-countable, the SceneKit path gives real shadows/meshes, and a per-pixel light needs a `.metal` in the shipping target (which Phase 3.1 then did).

---

## B · PARITY — Design vs code (built / partly / not / wrong)

### B1 · The Modes (03 A0.5, A11)

| Mode | Verdict | Where (file:line) | What differs from Design |
|---|---|---|---|
| Darśana | **partly** | DarshanaView.swift:21-112; TheModes.swift:69-106 | Built: stillness-gated three depths ("hold still · she wakes" / "beholding" / "∞"), radiance, point brightening, yantra waking. Missing: bījas appearing at holding, yantra growth 280→320→360, motes 6/10/14, status-bar fade, the 30 s label (dropped by the old numbers ban — now lifted). |
| Recognition · the Catch | **not on the mode door**; lives elsewhere | Recognition is `Views/Recognition/RecognitionMomentView.swift` (not in my set); reached from Detail "I feel her" (ShaktiDetailView.swift:227-252), Homecoming covenant (HomecomingView.swift:225-242) | Design's long-press-anywhere catch sheet (360 pt sheet, 68 px circle, "tap to register the moment" / "she is named" / "and she felt you back", "LOGGED · 2:41 PM · her 3rd today") not verified here; not offered as a mode. |
| Sādhana | **partly / wrong words** | SadhanaView.swift; TheModes.swift:110-147 | Built: saṅkalpa, name by name inward with seat lights, ring crossing words, visarjana, remains, bīja per name. Missing: Bindu station ("Lalitā" · "aiṁ klīṁ sauḥ"), transition screen "DESCENDING" with the ring's Sanskrit name 36 pt and its two-line gloss, "tap to continue", ring dots, progress line. **Verbatim drift:** saṅkalpa note Design "One hundred and two names will arrive in sequence. ~28 minutes. Sit upright. Breath low." → code "The names will arrive in sequence, ring by ring inward. Sit upright. Breath low." (TheModes:120); visarjana Design "What I have received, / I release." + "The garland is offered back / to the one who wove it. / The 102 return to the One." → code drops "I release." (TheModes:123-124); remains Design "One hundred and two have been said. / What remains is what was always there." → code "Every name has been said." (:126). |
| Smṛti | **partly** | SmritiView.swift; TheModes.swift:151-179 | Full constellation only. Missing: one Śakti's cluster ("{name} · 23 catches", "last caught — today, 9:14 AM"), time-lapse (scrubber "DAY 191 OF 264 · WATCHING HERSELF EMERGE"), filters, tap any star → her log, long-press-a-ring gesture. Title altered ("where she has been alive in you"). |
| Mauna | **built elsewhere, not openable from the door** | `Views/Mandala/TheCentre.swift:220` (`MaunaView`), `Homes/TheBuilding.swift:552` (`enum Mauna`), `Views/Mandala/StillnessAtTheCentre.swift:68`; door gloss TheModes.swift:59 | Arrives by stillness at the centre or a gentle touch at the point (his 12 Oct decision). Captions 7/14/21/28 s not checked here. |
| Svapna | **wrong (reinterpreted)** | SvapnaView.swift; TheModes.swift:183-201 | Design: he tells the night — "I felt someone" / "The night was still" buttons, marks petals ("2 MARKED · HOLD TO ADD A NOTE"), voice 42-bar waveform + mic + transcription, "OR WRITE". Code: yesterday's recognitions shown as dream-lights; "The night was still." used as empty state. No dream entry is ever recorded. |
| Pūjā | **partly** | PujaView.swift; TheModes.swift:205-235 | Built: gathering, hold-to-offer, gather → rise → dissolve, received lines, "sleep with the field", ledger row. Missing: the offering list (time · name rows), "today's catches" / "five recognitions, this day" titles, the sunset glow `rgba(199,90,80,.12)`, swipe-down evening gesture, the bindu 16→48 px absorbing. |
| Saṅgha | **not built — explicitly excluded** | TheModes.swift:6 "Saṅgha is ruled out" | Inner (102 as named orbitals, "One hundred and two living forces. / This is your assembly.") and outer (loved ones as carriers, "The people you love / are her wearing human faces.") absent. Contradicts ruling 10. |

### B2 · Time (03 A13)

| Instrument | Verdict | Where | Gap |
|---|---|---|---|
| Cosmic Now | **partly** | ThePointView.swift:15-224 (five clocks + legend, from real `Ephemeris`/`Panchanga`) | Lives behind the Portrait's centre (PortraitMandalaView.swift:191-208), not its own world; tithi 30 ticks; "THIS MOMENT" sentence and moon % line missing. |
| Lunar Yantra | **not** (as an instrument) | Only `LunarPhaseService.currentTimeVariant()` tints the Portrait (PortraitMandalaView.swift:37) and Homecoming sky (HomecomingView.swift:52); River letters open on `.purnima` (CorrespondenceView.swift:357) | The four-phase yantra (Amāvasyā bindu 90 px "when the moon is hidden, / the Bindu rises." … Kṛṣṇa "the petals fold inward. / she returns to seed.") not built. |
| Three Sandhyās | **partly** | FiveClocks junction wash (ThePointView.swift:204-209); hour lean of the mode door (ModesDoorView.swift:116-123); a Play game "The Sandhyā" exists (`Views/Play/PlayGame.swift:93`) | Prātaḥ/Madhyāhna/Sāyam micro-practices (Brāhmī / Vaiṣṇavī / Rudrāṇī, invitations, "begin sandhyā", noon light-ground screen) not built; app does not open to them by default. |
| Seasons | **not** | Only the ṛtu word in the Point legend (ThePointView.swift:141) | Seasonal Yantra (Vasanta … Hemanta, tones, intensities, poetry) not built. |
| Great Wheel | **not** (the year-density instrument) | A Play game named "The Great Wheel" exists (`Views/Play/PlayGamesTime.swift:138`); the Portrait's year ring is the nearest relative (LivingMandalaLayers.swift:67-96) | 365 radial days, density rays, moon dots, season sectors, year navigator "SWIPE ← → · NAVIGATE YEARS" absent. |
| Today's tithi | **partly** (outside these files) | Point legend (ThePointView.swift:139); `Views/Today/NityaDetailView.swift`, `Models/NityaDevi.swift` | Tithi-as-world with the moon clip and Nityā name 46 pt not in these files. |

### B3 · Memory (03 A12, 02 L-23)

| Instrument | Verdict | Where | Gap |
|---|---|---|---|
| Portrait as living mandala | **built (richer than Design in layers), partly in mechanism** | PortraitMandalaView.swift; LivingMandalaLayers.swift; LivingPlayLayers.swift | Petals not tappable (biography door missing); Design's per-status petal breaths (4.5/6/8/11 s) not built (the Portrait "does not breathe", :778); counts drive light (min(1,n/12)) — Design min(1,total/80), 02 L-23 min(1,n/7); local data only. |
| Petal Biography | **not** | Nearest: "her moments" fold on Detail (ShaktiDetailView.swift:761-815, 1025-1145) | First met / most recent / peak month / longest gap / days walked / "MOMENTS SHE WAS HERE" not built as her biography. |
| Threshold Timeline | **not** | Crossings exist as data (`advanceStatus`, ShaktiDetailView.swift:534-542); DescentFilm is ring crossings, not her crossings | No timeline of mapped→exploring→active→embodied with dates and the act that crossed her. |
| Cluster Garden | **not** | — | Five lineage gardens with bloom meters absent. |
| Density Atlas | **not** | Year ring beads (LivingMandalaLayers.swift:67-96) and Month glyphs (MonthMirrorView.swift:256-328) are partial relatives | Trailing-year 9×31 heat map and lifetime 5×12 grid absent. |
| First Word · Last Word | **not** | — | Span lines per relationship absent. |
| Lifetime Spiral | **not** | Year ring is current year only (PortraitMandalaView.swift:277) | Concentric year rings absent. |
| The Record | **built** | Export 1500 px "hold this image" (PortraitMandalaView.swift:82-94, 729-776); the Book (ArchiveBookView.swift); the Month Mirror (MonthMirrorView.swift); `MemoryRecord.acts` (MonthMirrorView.swift:6-36) | Story-leaning parts (book, month letter) are candidates for Bindu Feed as well. |

### B4 · The Well, Beneath, the Relationship Field

| World | Verdict | Where | Gap |
|---|---|---|---|
| The Well | **built, beyond Design** (102 not 16; river, lights, names, voice) | WellView.swift; CorrespondenceView.swift; LightBackViews.swift | It is a list page off the hamburger (RootView.swift:62), not a place; the river's current is the only spatial gesture. |
| Beneath ("Under the ground": Well, letters, witness, Shadow Translator, S15 Mirror, G14 descent — FOUNDATION:16) | **not built as a world** | Pieces scattered: Well (WellView), witness (HerWitnessPage.swift), descent film (DescentFilmView.swift), book's middle door "go down ›" (ArchiveBookView.swift:179-205), Shadow Translator as a Play game (`Views/Play/PlayGame.swift`) | No underground space joins them. |
| Relationship Field | **not built** (seed only) | Settings Field Connections: kp 31 Gaia, kp 40 Ashrey, kp 42 Ram (SettingsView.swift:236-254); Detail field-connection card (ShaktiDetailView.swift:675-700) | Field, Person Page, Shakti's Carriers, Encounter Log, Field Web, Add-a-Beloved ritual — all absent; Saṅgha excluded in code (TheModes.swift:6). |

---

## C · WHAT THE UPGRADE MUST BUILD FOR THESE LAYERS AS THEIR OWN WORLDS (gifts)

Each row: *what · source · world · how it works there · needs · energy or story*.

| # | What | Source | World | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **The Modes as eight places**, not a list: each mode a full atmosphere with its own entry gesture (Codex G5 still · G9 long-press · G4 pinch · G3 ring long-press · G2 bindu tap · morning open · G7 swipe down · ambient) *and* a door in the always-available menu | 03 A0.5, A11; ModesDoorView | Modes | Keep the pure models (TheModes.swift) and `ModeGeometry`; replace the list with a ring of eight lights round the point; gestures as extra doors | gesture router; Mauna added to the ring (still "arrives", also openable) | energy |
| 2 | **Saṅgha restored** (inner 102 as named orbitals breathing 5–7 s; outer loved ones as carrier nodes with dashed threads; person detail "THIS IS HOW SHE ENTERS THROUGH HIM") | 03 M8; TheModes:6 | Modes ↔ Relationship Field | Inner reads all 102 names at r192/r122; outer reads the beloved map | beloved store (see 10) | energy |
| 3 | **Darśana completed**: bījas surfacing at holding (r=.62·yantra, delays i×.35 s), yantra growth by depth, motes, chrome fade, "beholding · 30s" restored | 03 M1; DarshanaView | Modes | Add to existing depth stages | bīja strings (ring 2 + those present) | energy |
| 4 | **Sādhana completed and verbatim**: transition station with "DESCENDING", the enclosure's name and Design's gloss, Bindu station "Lalitā · aiṁ klīṁ sauḥ", ring dots + progress line, tap-to-continue *or* paced (his choice), Design's exact saṅkalpa/visarjana/remains lines, ring chime default off | 03 M3; SadhanaView; 02 §D-16 | Modes | Restore lines from modes.jsx L287-602; add two stations to the stage enum | ring glosses from `Avarana` | energy |
| 5 | **Smṛti's three views**: full · one Śakti's cluster with last-caught line · time-lapse scrubber over every day of practice; tap a star → her moments | 03 M4 | Modes ↔ Memory | Moments merged from local + Airtable ledger | ledger read of App Activity | energy |
| 6 | **Svapna as he designed it**: "I felt someone" / "The night was still"; mark petals; voice the dream (waveform, mic, own voice kept, words laid on the page via `VoiceWordButton`); the record's walkers as a second layer | 03 M6; SvapnaView; VoiceWord.swift | Modes | Reuse `SpeechCapture`; new Dream entry → ledger | dream-entry schema in App Activity; private | energy (the dream text is his own; private) |
| 7 | **Pūjā list and absorption**: catches as rows (time · name), bindu 16→48 px absorbing, sunset glow, swipe-down at evening as a door | 03 M7; PujaView | Modes | Extend existing release animation | — | energy |
| 8 | **Time as a world**: Cosmic Now (ThePointView's five clocks, moved out of the Portrait into its own sky, with "THIS MOMENT" sentence), Lunar Yantra (four atmospheres; Amāvasyā bindu 90 px), Sandhyās (three micro-practices opened by default at the junctions, sun-relative via `Panchanga.sandhya`), Seasonal Yantra (four), Great Wheel (365 radial days, swipe years), Tithi world | 03 A13; ThePointView | Time | One "Time" space whose sky is the live yantra under a different sky ("they do not remove the instrument") | device location for sunrise/sunset; ledger history | energy |
| 9 | **Memory's seven instruments as rooms**: Portrait (tappable petals, status breaths), Petal Biography, Threshold Timeline, Cluster Garden, Density Atlas (year + lifetime), First Word · Last Word, Lifetime Spiral — plus the living layers already built (strokes, year beads, play layers, sealed eye) | 03 A12; PortraitMandalaView; Living*Layers | Memory | Read the merged record; numbers allowed again but never as score (show *where*, *when*, *span*) | crossing dates per Śakti in ledger; merged history | energy (Threshold notes are his words — private) |
| 10 | **The Relationship Field in full**: Field (yantra at centre, souls on r200, dashed threads to carried seats), Person Page, Shakti's Carriers (reverse lookup, back to Portrait), Encounter Log (when, who, which Śaktis arose, context), Field Web (pair threads by shared Śakti), Add-a-Beloved four-step ritual ("By what name / do you know them?" → choose petals → "In one breath: / who is she, to you?" → "she is now in your field. / she will arrive in the yantra / each time you meet.") | 03 A14; SettingsView Field Connections | Relationship Field | Beloved store keyed by kp (position is identity), not ring-2 index; migrate Settings' three Field Connections (kp 31/40/42) as the first three souls | new Beloved + Encounter tables (local + ledger rows); his people private | energy (encounter contexts are life-story → also a Bindu Feed candidate) |
| 11 | **Beneath as one underground space**: the Well (letters to all 102), the River (back/forward, sealed, light sent back), the higher-self name, witness pages, the Book's middle door, the descent film, Shadow Translator — reached by going down through the ground | FOUNDATION:16; WellView, CorrespondenceView, LightBackViews, HerWitnessPage, ArchiveBookView, DescentFilmView | Beneath | One descending space with chambers; RiverCurrent becomes the floor's current | — | energy (letters private) |
| 12 | **The Record as gift object**: 1500 px export of the Portrait (all layers), the Book with frontispiece "the book of {name}", the Month Mirror with MonthSitting | PortraitMandalaView:82-94; ArchiveBookView; MonthMirrorView | Memory | Keep; add year and lifetime exports | — | story → the Book and month letter also suit **Bindu Feed** (narrative of his practice) |
| 13 | **Room renderers from the spike**: Physics classifier (eight motions from tattva/quality), body-altitude zones, gem-diffusion table, ATTR_TINT table (15 positions), strata generator, analytic shadow plane, reduce-motion = settled pose | GarimaSceneKitRoom.swift:287-424; GarimaCanvasRoom.swift:247-633 | Her Home | Lift the tables into production `Homes/` (some exist in `Homes/HomeGrammar.swift`) | delete spike after lifting; exclude `.metal` | energy |
| 14 | **Heart Register for every ring's own register**, not only ring 2 | HeartRegisterView; HerDeepeningSection:153 | Her Home | Per-ring Sa/drone tables | ring bīja Hz from register 02 R-08 | energy |
| 15 | **Her deepening by his choice**: all six layers available, newest arriving slowly — not withheld by a visit counter | HerDeepeningSection:52-84 | Her Presence | Replace `open(visits:)` gate with "unfold all" | — | energy |
| 16 | **Embodiment crossing not count-gated**: he chooses the crossing; history merged | ShaktiDetailView:521-532 | Her Presence / Memory | Remove 1/3/7 thresholds or make them suggestions | — | energy |
| 17 | **Where She Speaks** as a body-of-light world (the axis with regions, her lights orbiting) linked from the Climb | WhereSheSpeaksView | the Climb / Her Presence | Already built; give it its own place | `bodilyLocation` for the 86 | energy |
| 18 | **Homecoming kept and joined to Home**: condensation, two lines, covenant → Recognition, 136.1 Hz chord, yantra drawn outward | HomecomingView | Home | Ends at the Bindu (ruling 1) | — | energy |

---

## D · CONFLICTS AND GAPS

1. **Saṅgha "ruled out"** (TheModes.swift:6) vs ruling 10 and 03 M8/A14 — must be reversed.
2. **Spike `.metal` ships in Release** (GarimaSceneKitRoom.metal:6-9; pbxproj :33-45 has no exception) while every Spike `.swift` is DEBUG-only — exclude via `membershipExceptions` or delete with the spike.
3. **Two memory laws at once**: Portrait brightness by count (PortraitMandalaView:414, saturates 12) vs Smṛti "felt once = felt a thousand times" (TheModes:160-162). Design itself used counts (03 MEM-1 min(1,total/80); 02 L-23 min(1,n/7)). With restrictions lifted, pick one rule for both.
4. **Silence can settle as felt** in the Portrait (PortraitMandalaView:384-387 uses `latest()` without a gesture filter).
5. **Local-only memory**: Smṛti, Svapna, Pūjā, Portrait read only `RecognitionEntry` on the phone; Detail's Her Moments merges Airtable. A new phone shows an empty memory — conflicts with "practice data never lost" in experience if not in storage.
6. **Verbatim drift** in Sādhana (three lines) and Smṛti title — the Design words were trimmed to obey the now-lifted number/word bans; floor "baked text verbatim" asks they be restored.
7. **Svapna inverted** (record answers vs he tells) — Design and the Data & Time contract ("dream entries (Svapna) — voice + text") are unbuilt.
8. **Sound default**: Sādhana reads `lr_sound` default **true** (SadhanaView:30); register 02 §D says default off.
9. **Count-gated content**: Embodiment readiness (ShaktiDetailView:521-532) and HerDeepening layers (HerDeepeningSection:52-84) gate by counts — floor "nothing scores him".
10. **Key mis-mapping**: `position + 28` fallback (TheHundredTwoView:289, :424; ShaktiDetailView:809) and `kp − 28` (PortraitMandalaView:340) assume ring 2.
11. **Geometry mismatch**: ring 1 square in Modes (ModeField:18) vs circle in Portrait (PortraitMandalaView:449-462, 500).
12. **DescentFilm** dates only from ring 3 (DescentFilmView:35-38).
13. **Mode door timing** by clock hour, not sun (ModesDoorView:116-123) though `Panchanga.sandhya` exists.
14. **Month letter** is template-composed (Models/MonthReading.swift:120-163) — from his record, but phrased by code; confirm acceptable under "nothing invented".
15. **Spike fixture** text (GarimaCanvasRoom:1137-1158, appreciation phrase) claimed to equal Airtable — verify before any lift into production.
16. **Time and Memory are reached through the Portrait** (the Point door, PortraitMandalaView:211-228): six worlds' worth of material stacked behind one screen — the exact compression the Foundation names (root cause 1).
17. **Relationship data** is three hard-coded seats with default names (SettingsView:242-247) and Design's two people tables disagree (03 §D-14); Design's carried indices are ring-2 local (0–15) and must be mapped to kp 29–44.

---

## E · COVERAGE PROOF

Method: `wc -l` and `md5sum` (first 8); every file opened with the Read tool from line 1 to its end (long files in consecutive ranges). The `.metal` read in full. Register sections compared were read with the Read tool: 03 L60-89, L618-867, L920-996; 02 L950-1009, L1546-1673; FOUNDATION 1-53. `project.pbxproj` L33-45 inspected for target membership.

| file | wc -l | lines read | method | md5 |
|---|---|---|---|---|
| Modes/TheModes.swift | 235 | 1–235 | Read | b4d495a4 |
| Modes/ModeField.swift | 128 | 1–128 | Read | 0fabe8c3 |
| Modes/ModesDoorView.swift | 124 | 1–124 | Read | 1b93e811 |
| Modes/DarshanaView.swift | 112 | 1–112 | Read | 551a5dbe |
| Modes/PujaView.swift | 154 | 1–154 | Read | 06f063fe |
| Modes/SadhanaView.swift | 286 | 1–286 | Read | d1ba4d48 |
| Modes/SmritiView.swift | 98 | 1–98 | Read | 96fcb8ab |
| Modes/SvapnaView.swift | 109 | 1–109 | Read | 345b7e45 |
| Memory/ArchiveBookView.swift | 324 | 1–324 | Read | 38be3c87 |
| Memory/CorrespondenceView.swift | 689 | 1–689 | Read | 85755fbe |
| Memory/DescentFilmView.swift | 221 | 1–221 | Read | b29a1e5b |
| Memory/HeartRegisterView.swift | 127 | 1–127 | Read | 4f69666b |
| Memory/LightBackViews.swift | 264 | 1–264 | Read | fc7f130b |
| Memory/LivingMandalaLayers.swift | 154 | 1–154 | Read | 9b4798e2 |
| Memory/LivingPlayLayers.swift | 147 | 1–147 | Read | 9ab4bd87 |
| Memory/MonthMirrorView.swift | 437 | 1–437 | Read | a9c0be58 |
| Memory/PortraitMandalaView.swift | 815 | 1–815 | Read | 40abe7e2 |
| Memory/ThePointView.swift | 290 | 1–290 | Read | 1d67c946 |
| Memory/VoiceWord.swift | 74 | 1–74 | Read | d184b180 |
| Memory/WhereSheSpeaksView.swift | 232 | 1–232 | Read | e781311b |
| Common/AvaranaThresholdView.swift | 267 | 1–267 | Read | dfdba5c1 |
| Common/BottomScrollFade.swift | 20 | 1–20 | Read | 0efb9d52 |
| Common/HerDeepeningSection.swift | 189 | 1–189 | Read | a5739b26 |
| Common/HerDoorwaysSection.swift | 201 | 1–201 | Read | a9d9cf7d |
| Common/HerWitnessPage.swift | 220 | 1–220 | Read | 51d0fde4 |
| Common/HomecomingView.swift | 460 | 1–460 | Read | 564e79b8 |
| Common/MarginView.swift | 536 | 1–536 | Read | ec6c4244 |
| Common/SettingsView.swift | 434 | 1–434 | Read | 3b4faa88 |
| Common/ShaktiDetailView.swift | 1145 | 1–580, 580–1145 | Read (2 ranges) | e642cab2 |
| Common/SwipeBackEnabler.swift | 39 | 1–39 | Read | ace5a227 |
| Common/TheHundredTwoView.swift | 592 | 1–592 | Read | 970943dd |
| Common/WellView.swift | 517 | 1–517 | Read | 67f12983 |
| Spike/GarimaCanvasRoom.swift | 1327 | 1–450, 450–899, 899–1327 | Read (3 ranges) | 54b41408 |
| Spike/GarimaSceneKitRoom.metal | 135 | 1–135 | Read | 053ced79 |
| Spike/GarimaSceneKitRoom.swift | 1511 | 1–500, 500–1019, 1019–1511 | Read (3 ranges) | cb58aad4 |
| Spike/MandalaDrawCensus.swift | 229 | 1–229 | Read | 6dc60b22 |
| Spike/SpikeBench.swift | 163 | 1–163 | Read | 95888be9 |
| Spike/SpikeField.swift | 140 | 1–140 | Read | 8a1a88c4 |
| Spike/SpikeMandalaHarness.swift | 237 | 1–237 | Read | 36256535 |
| Spike/SpikeMetrics.swift | 305 | 1–305 | Read | d58105dc |
| **Total (40 files)** | **14,038** | all | | |

Nothing was left unread.

---

### Return message

`waves/register/21-code-layers.md` — ten most valuable gifts:
1. The Modes as eight places with their Codex gestures, Mauna joined (C1).
2. Saṅgha restored, inner and outer — reverse TheModes.swift:6 (C2).
3. The Relationship Field in full, seeded from Settings' three Field Connections (kp 31/40/42) and keyed by position (C10).
4. Time as its own world: lift ThePointView's real five clocks out of the Portrait and add Lunar, Sandhyā (sun-relative), Seasons, Great Wheel, Tithi (C8).
5. Memory's seven instruments as rooms on a merged local + ledger record (C9, D5).
6. Beneath as one underground space joining Well, River, light-sent-back, higher-self name, witness pages, descent film, Shadow Translator (C11).
7. Svapna as designed — he tells the dream by voice/text, a new private ledger entry (C6).
8. Sādhana's missing stations and Design's verbatim lines restored; chime default off (C4, D6, D8).
9. The spike's room tables (Physics classifier, altitude zones, gem diffusion, ATTR_TINT, strata) lifted into Homes; exclude the shipping spike `.metal` (C13, D2).
10. The Record as gift: Portrait export, the Book with its middle door, the Month Mirror — the Book/month letter also flagged for Bindu Feed (C12).
