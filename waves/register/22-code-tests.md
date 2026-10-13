# 22 · The code's own tests — unit tests, UI tests, CI and the snapshot baselines

*Reader 22 of the second reading · 12 October 2026 (night) · repo HEAD `8555b4d` (2026-10-12 22:39 −0400) · read-only.*

**Scope as found on disk.** The brief named `iOS/Bindu Mandala/Bindu MandalaTests/`. That path does not exist. The test targets are siblings of the app folder:
`iOS/Bindu MandalaTests/` (87 .swift, 33,145 lines), `iOS/Bindu MandalaUITests/` (10 .swift, 3,839 lines), `iOS/ci_scripts/` (2 shell scripts, 127 lines) and `iOS/SnapshotBaselines/` (30 `.geom` text files, 858 lines; **there are no images in it**). In total that is 97 Swift files and 36,984 lines (37,111 with the two CI scripts). Every file was read in full, line 1 to the end. The proof is in §D.

**Why this register matters for the upgrade.** These ~37k lines are the most exact record of what was built and why. Almost every test quotes its reason: a Codex law (C-numbers), a Design file (`homes-verify.js`, `homes-worlds.js`, `LR_RECOG`, `Mandala App v2.html`), a device audit or one of his rulings. The suite holds three kinds of thing at once:
1. **Rules he has now lifted.** These tests have to be rewritten or retired, or the upgrade will fail its own CI.
2. **Floors that stay.** These tests are the safety net and must survive every rebuild.
3. **Design's craft, held as numbers.** These are the single biggest gift in the folder. Hundreds of Design's numbers are pinned here, port-verified: timings, Hz, opacities, keyframes, room mechanisms, the nine worlds and the 26 attribute forms. Together they make a ready-made **parity seed**.

Legend used throughout:
- **LIFTED**: encodes a restriction Ashrey lifted on 12 Oct (no-menu or three controls, one sound, one breath clock, measuring words, returning words, images or the binding condition, gating or locks, and the foundation's longer list: the composition lock, gem never colours, a veil that cannot learn, two-state seats, play keeps no store, the Mudrā body-word ban, iconography and the Codex Portrait off screens, a room only behind the rite, Design's numbers as a ceiling).
- **FLOOR**: encodes a floor that stays (practice data never lost or duplicated, position is identity, App Activity as the one ledger, the two Recognition lines verbatim, no generated voice, nothing invented, privacy, no figure of a Śakti, nothing scores him or makes absence a debt, accessibility). It also covers his 12 Oct rulings: Leela ≥3 days apart then 30%, dissolutions once a day, Homecoming each launch, Rām japa at kp 42, gratitude gently.
- **CRAFT**: Design's numbers or mechanisms, ported and pinned. Keep them as parity seeds. They are neither lifted nor floors.
- **HARNESS**: infrastructure that other tests stand on.

---

## A · Inventory

### A.0 The harness everything stands on

| piece | where | what it does | keep? |
|---|---|---|---|
| `SourceTree` | `Bindu MandalaTests/SourceTree.swift:11–35` | Finds the repo root via `#filePath`, or via a bundled `SourceTree` resource on Xcode Cloud ("Bundle the source tree" build phase, secrets excluded). The layout it expects is `iOS/Bindu Mandala`, `iOS/Bindu MandalaTests`, `DECISIONS.md` and **`Claude Design Round 2/homes`**. **Design's own files are therefore readable from tests in CI.** That is the hinge for parity checks. | HARNESS, keep |
| `SwiftLexer`, `SourceLiteral`, `CallSite`, `SourceFile`, `Rx`, `LawSource` | `LawsTests.swift:80–540` | A real Swift lexer that separates comments, raw strings and interpolations from masked code. Call sites are found by callee. `LawSource.production` holds every shipping file. `walkerFacingCallees` = Text, accessibilityLabel/Value/Hint/InputLabels, navigationTitle, Button, Label, TextField, SecureField, Toggle, Picker, SharePreview, alert, confirmationDialog, help. | HARNESS, keep (the source-scanning engine for any new law) |
| `NeverMeasure` | `LawsTests.swift:543–727` | Design's 9 MEASURING regexes from `homes-verify.js` (`\d+ of \d+`, `\d+%`, `visits: n`, streak, progress, `level \d`, score, `day \d+`, `\d+ times|visits`), plus `practiceSymbols` (serverRecognitionCount, recognitionCount, visitCount, dwell, streak, score, timesFelt, feltCount, momentCount, crossingCount, silenceCount, durationSec, RecognitionLogStore, HomeMemory(Store)…), `structuralCounts`, `isIdentity` ("kp of 102") and `countExpressions`. | Split. The **practice-symbol** half (nothing scores him) is the FLOOR. The **word/digit** half is LIFTED. |
| `RecognitionLines` | `LawsTests.swift:728–769` | `feltHere = "she was felt here"` (:730), `feltBack = "and she felt you back"` (:731); shape regexes, near-miss fragments, the pinned uppercase treatment in RecognitionMomentView. | FLOOR |
| `PositionIsIdentity` | `LawsTests.swift:770–855` | Forbidden name-keyed shapes (`by_name`, `[String: Shakti]`, `shakti(named:)`, `index(forName:)`, `Predicate .name ==`), pinned exceptions (MarginNote.noteId, ActivityLedger.moments(shaktiName:) narrowing only). | FLOOR |
| `Aniconic` | `LawsTests.swift:856–900` | figuralVocabulary (face, eye, hand…, goddess, deity, portrait, photo, avatar, person, woman, man); drawingCallees Image/UIImage/NSImage/AsyncImage; pinned literals `{"chevron.right"}`; catalogue `{AppIcon, AccentColor}`; iconographicFields `[iconography, codexPortrait]` never on screen; ≥150 geometric primitives. | Split. "No figure of a Śakti" is the FLOOR. The catalogue/literal pins and iconographic-fields-off-screen are LIFTED. |
| `LedgerIsTheRecord` | `LawsTests.swift:901–1126` | The vocabulary of App Activity types: Shakti Recognized, Ring Crossed, Silence Held, Letter Written, Full Circle, First Dwelling, Note Left, State Set Down, Siddhi Received, Played, Letter Sealed, Letter Opened, Portrait Drawn, Wager Resolved, Witness Written, Garland Recited, Day Offered, Leela Drop, Light Entered, Chakra Practiced, Light Sent Back, Name Kept. The only HTTP topology allowed is POST→App Activity, POST→Codex and record-addressed PATCH→Mandala (fields Last Felt, Recognition Count, Status, Letter). | FLOOR |
| `TypeScanner` + `TypeSite` | `LegibilityTests.swift:48–356` | Walks the SwiftUI modifier chain after `Text(…)` to read size and effective alpha. `fadedTokens` creamMid .65, creamFaint .35, goldFaint .12, accentSoft .62, accentFaint .24, glow .12. | HARNESS (a11y) |
| `SwiftProperties` | `TheWayInTests.swift` (bottom) | Reads stored properties with their attributes/type. | HARNESS |
| `HomesCorpus` | `HomesCorpus.swift` (141) | The 102-row fixture: 16 real Ring-2 rows plus 86 *synthetic* rows built from a 68-word tattva vocabulary and 14 locations, with honest `provenance`. `resolvedRooms()` → 102. | HARNESS. Note it in C: the real 102 live only in Airtable. |
| `RingOneFingerprint`, `OuterRingFingerprint` | 212 / 338 | Ports of `homes-verify.js` `fingerprint(chamber,t)` and `divergence(a,b)`: 5×5 probes, sample times `[0,24,62,140,227,287,347]`, threshold **0.1** ("Design's tenth"), `refusesDilution`. `OuterRingCapture` renders 320×640 offscreen and asserts luminance (must run on main). | CRAFT/HARNESS. The sister-divergence engine. |
| UI `press(_:until:attempts:eachTimeout:)` | `BinduMandalaUITests.swift` | Retries taps lost to the digitizer-cancel flake (3 attempts). | HARNESS |
| UI `Reach` | `AccessibilityReachTests.swift` | Base args `[SKIP_SUMMONS, SKIP_HOMECOMING, SYNC_OFF, ENERGY_POS=29, EPHEMERAL_STORE]`, `largestType` AX3XL, `spokenField`. | HARNESS |
| UI `ScreenReader`/geometry snapshot | `FeltRegisterSnapshots.swift` | Turns the accessibility tree into `.geom` lines (type\|label\|ordinal\|x\|y\|w\|h). Digits become `#`, clock meridiem `~`, moon phase folded. Values rounded to ¼ pt, tolerance 1 pt. | HARNESS. Reuse it for the automated walk (§B.2). |
| `SpikeMetrics`, `SpikeBench`, `MandalaDrawCensus` | spike suites | Frame sampler, CPU/footprint/host load, a driven clock (`Clock(offset:)`, no waiting) and a deterministic primitive census. | HARNESS (performance) |

**Launch arguments the tests use** (the builder needs these to drive any world): `SKIP_SUMMONS`, `SKIP_HOMECOMING`, `SYNC_OFF`, `ENERGY_POS=<kp>` (the **last** one wins, `EphemeralStoreTests.swift:124`), `EPHEMERAL_STORE` (DEBUG-only and in-memory, never touches the disk; `EphemeralStoreTests.swift:31–82`), `START_TAB=rite|mandala|102|well|memory`, `OPEN_DETAIL=<kp>`, `OPEN_SILENCE`, `OPEN_FILM`, `OPEN_LETTER=<kp>`, `OPEN_CLIMB`, `AUTO_RECOGNIZE`, `RECOGNIZE_AUTOCLOSE`, `REDUCE_MOTION`, `MANDALA_LIGHT=off` (exact match only), `BINDU_RECORD_BASELINE=1`, `SPIKE_BENCH=1`, `SPIKE_ROOM=…`, `SPIKE_T=…`, `SPIKE_REDUCE_MOTION`. **No argument exists to open a world by name.** A `OPEN_WORLD=<id>` family is the first thing the automated walk needs (§B.2).

### A.1 CI scripts

- **`ci_scripts/ci_post_clone.sh`** (93). Fixes the Metal toolchain (export the bundle, then `-importComponent`). If `AIRTABLE_PAT` is set it writes it into `Config.local.xcconfig` (the value never echoes). If it is unset the build runs **local-first** on the 16 bootstrap Karṣiṇīs. It never fails the build. → **FLOOR (privacy: secrets stay out of logs).** Note: any CI-run test therefore sees only 16 of 102 rows unless the PAT is present. Every parity test must work on the bundled bakes (`ChakraConstellation.json`, `GameStructure.json`) plus the fixtures.
- **`ci_scripts/ci_pre_xcodebuild.sh`** (34). `CI_BUILD_NUMBER` → `CURRENT_PROJECT_VERSION` via sed. Neutral.

### A.2 SnapshotBaselines (30 `.geom` files, no images)

Three device classes: `phone` (402 w), `promax` (440 w) and `se` (375 w). Each has ten screens: `detail` (29 lines), `field` (23), `mandala-descent` (18), `mandala` (7), `memory` (4), `recognition` (19), `rite` (11), `settings` (98), `well-letter` (7), `well` (70). Each line is `kind|label|ordinal|x|y|w|h`, with digits shown as `#` and times as `~`. They are a **frozen record of the Wave-6-era screens' words and positions**:
- **mandala**: "Śrī Yantra", "the whole instrument · pinch to fall in", and the zoom column ♪̸ + − ⤢ at x 339.5, 47 pt.
- **mandala-descent**: "NINTH ĀVARAṆA · THE BINDU", "the point that contains all points", "Śarīra", "ॐ SOUND THE SOURCE", "enter her presence", "↑ return to the field", and "There is nothing else here. The whole yantra breathes outward from this point — and every energy you have met is Her, turned for a moment toward you."
- **detail**: SENSE STREAMS, SOMATIC SIGNATURE, BĪJA · TAP TO HEAR, EMBODIMENT, ACTIVE, felt into being, HER MOMENTS, "She has not been felt here yet.", go deeper.
- **field**: "The Field", "NINE RINGS · ONE HUNDRED AND TWO", the 16 Ring-2 rows.
- **memory**: THE PORTRAIT MANDALA / your face in the instrument / she is felt, not measured.
- **recognition**: SECOND ĀVARAṆA · INNER INSTRUMENT; Kāmākarṣiṇī; "You are extraordinary for bringing me this desire."; "Where does wanting itself live in your body right now?"; "SHE WAS FELT HERE · #:# ~"; "and she felt you back · #:#:#"; "What did you notice?"; TAP ANYWHERE TO CLOSE; the giant bīja glyph aṁ at 382×393; "# of # · bīja aṁ".
- **settings**: the sheet opened *over the Well*, so its title reads "Your Letters to Them". DAILY RHYTHM / "Let her arrive" switch / "She arrives # ~"; **"Once a day, never twice. If the rite is already done, she lets the evening pass in stillness."** FIELD CONNECTIONS (three editable names: "She anchors here.", "She weaves through here.", "Holds her frequency."), with the note "These names appear on each Śakti's Detail screen and may be edited freely. They are personal to this practitioner." There is a BĪJA explainer. THE WAY BEHIND / "Remember the descent" / "Each ring you have crossed, opening one by one." HOMECOMING / "Re-enter the Homecoming" / **"She will greet you again, as on the first day."**
- **well**: "SPEAK TO HER DIRECTLY. SHE IS LISTENING.", "You can speak to her here", "not yet written to".
- **well-letter**: the editor, "Speak to her directly. She is listening."

→ **LIFTED as a gate.** Charter II Wave 1 retired the composition lock (`FeltRegisterSnapshots.swift:525–530`: "a visual-fidelity check against Design's frames replaces the lock"). That check was never built. They stay useful as **a word inventory** and as the geometry format for parity (§B.3).

### A.3 UI tests (10 files, 3,839 lines)

1. **`BinduMandalaUITests.swift`** (97). Launches with SKIP_SUMMONS, SKIP_HOMECOMING, START_TAB=rite, ENERGY_POS=29, SYNC_OFF. `testTodayOpensDetail` (:24): "know her ›" opens the Detail showing the phonetic KAH · MAH · KAR · SHI · NEE. `testFeelHerOpensRecognition` (:38): "felt here" appears. Holds the `press(until:)` helper. *World:* Today → Her Presence → Recognition. **FLOOR** (Recognition) and a route seed. Rewrite it so Today is reached as the first door from the Bindu.
2. **`SpikeColdLaunchTests.swift`** (74). Gated by SPIKE_BENCH. Five cold launches with START_TAB=mandala; prints SPIKE_LAUNCH JSON (mean/best/worst). *World:* launch. Neutral. Retarget to "launch arrives at the Bindu" (ruling 1).
3. **`HitAreaTests.swift`** (218). FIDELITY rule 4, ≥44×44, measured on the running app for the audit's §H4 eight: "↑ return to the field" (OPEN_SILENCE), "the threshold ›" (START_TAB=102; skips without an āvaraṇa row), film close (OPEN_FILM), celestial strip (skips without a Nityā), "know her ›", the rename field (Settings, Daily Rhythm), and "hold this image" (Portrait long press 1.4 s; it documents the `allowsHitTesting(false)` bug). **FLOOR (a11y).** Keep the floor and rewrite the routes per world.
4. **`MandalaLightReachTests.swift`** (402). Under the lit Mandala (`MANDALA_LIGHT=off` is the control):
   - the spoken field has ≥17 elements, says "of the one hundred and two", has no numeral, no "times", and targets ≥43.5 pt (:116);
   - nothing measures: [times, streak, progress, complete, %, visits, sessions, total] (:152);
   - **the hamburger is still on the glass** (:176), the topmost unlabelled corner control, with marks ♪ ♪̸ + − ⤢ × ‹ excluded;
   - **the hamburger opens the menu under the light** (:211), with three outcomes;
   - the sound toggle still governs the crossing (:237);
   - the light is on in the shipping launch, by a pixel diff >0.01 over a 10–90 %×20–85 % crop with channel >8 (:268);
   - nothing can be counted even by a voice (:315).

   *World:* the Mandala. **Mixed.** The menu-reach part becomes the seed of the "menu always one touch away" test. The no-number sweep is LIFTED (keep only "nothing scores him"). The pixel-diff technique is a parity seed.
5. **`TheMarginUITests.swift`** (426). The Margin is Settings' first section, "THE MARGIN". Doors "Leave a note" and "What you have left". The composer's id is `marginComposer` with placeholder "Say what you see. It will be read."; the empty state is "Nothing left here yet.".
   - Doors are hittable without scrolling (:45); targets ≥44 (:56).
   - He leaves a note and finds it whole again (:81); an abandoned composer writes nothing (:115).
   - No digit in the margin (:138).
   - An interruption mid-sentence keeps the draft (:193): saves on `.inactive`, 2 s autosave debounce.
   - **The sheet is the same length however much he wrote** (:232).
   - The still path walks the whole margin (:276); wiping a note and leaving deletes it (:303).
   - The header holds at AX3XL: <34 % of the glass, back <90 pt tall (:350).

   Screenshots are attached `keepAlways`. *World:* the Margin (everywhere). **FLOOR** (draft survives, privacy, a11y) **plus LIFTED** (the no-digit and same-length rules are measuring bans).
6. **`TheWayInUITests.swift`** (430). The best existing walk.
   - **`testFromAColdLaunchAWalkerReachesARoomAndComesOutWhereHeStarted`** (:134): cold launch (EPHEMERAL_STORE) → Today → "know her ›" → "be with her" → threshold ("touch to…", and no way out at the threshold) → cross by taps (8 attempts, 3.5 s waits) → the room → hold-out crossing 2.2 s (+1.4 slack) → **back on her Detail with the door and the phonetic**, which is back-to-where-you-were → a second, compressed crossing.
   - Letting go at 0.35 stays in the room (:177). Reduced motion leaves with one touch on "touch to withdraw" (:217).
   - The Field's "Rise through" opens the Climb on Sarvāśāparipūraka (āvaraṇa 2), and holding out lands back on the Field (:249).
   - The Axis hint "drag to rise" disappears after rising (:283); OPEN_CLIMB opens the Climb directly (:327).
   - The diff of labels that arrived carries no digits and none of `wordsThatMeasure` (:349, list :424–430: streak, progress, score, total, complete(d), "first time", "welcome back", "once more", again, "so far", "as usual", second…tenth, times, visit, "your stay", "you have been"), with a place-ordinal exemption.

   **KEEP and generalise** (route plus back-to-where-you-were). The word list is **LIFTED** (measuring/returning words).
7. **`AccessibilityReachTests.swift`** (493), three classes.
   - `AccessibilityReachTests`: every seat speaks her name, with ≥16 seats, "of the one hundred and two", no numeral, 43.5 pt (:88). The 16 are findable by name, e.g. the exact line "Spar Shah kar shi nee. She who attracts Touch. Second enclosure, thirty-third of the one hundred and two." (:159). The field is spoken in garland order 29…44, with an Xcode Cloud frame-order note dated 12 Oct (:168). Activating kp 33 opens "enter her presence" (:211).
   - `DynamicTypeReachTests`: at AX3XL nothing runs off the SE across seven screens (Mandala, her presence OPEN_DETAIL=33 "Embodiment", Rite, Field, Well "Your Letters", Portrait, Bindu OPEN_SILENCE "THE BINDU"); no string is cut (large < small × 0.92 fails); type grows ×1.4; every control ≥43.5 (:261–:440).
   - `VoiceOverCeremonyExitTests`: AUTO_RECOGNIZE → "and she felt you back" → the "Close this moment" button (:481).

   **FLOOR (a11y and Recognition lines).**
8. **`FeltRegisterSnapshots.swift`** (624). The geometry snapshot engine. The roster is 10 screens (mandala; mandala-descent OPEN_SILENCE after 3.0 s; detail OPEN_DETAIL=33; rite after 2.4 s; field ENERGY_POS=1; well; well-letter OPEN_LETTER=29; memory; settings via the hamburger; recognition AUTO_RECOGNIZE last, after 4.5 s). Film and homecoming were removed. Recording uses BINDU_RECORD_BASELINE=1 or a `.record` marker. Device class is promax ≥420, phone ≥390, else se. **The lock was retired as a gate in Wave 1** (:525). Only arrivals and "remembers a recognition" still fail, and drift is attached as "composition-drift". Its comment: "Nobody is going to look at these screens before they ship, so 'it still looks the same' has to be a number." **LIFTED (lock).** Keep the engine for the walk.
9. **`FeltRegisterClassifications.swift`** (562). `ClassifiedShift` (screen, keyContains, maxDelta, settles, device, reason): the appeared list, the folded list, and per-device shifts (detail go deeper 36.0 se / 35.58 promax / 11.58 phone; settings margin 247.5). **LIFTED.** Retire with the lock.
10. **`TheLibraryFoldUITests.swift`** (513). The shelf value is folded/unfolded. **Felt and unfelt compositions are identical** (:163, "Law 2 drawn measure"). Every folded element comes back through the door its entry names (:329). Both shelves hold at AX3XL on SE (:370). `TheFoldVocabularyTests` (:438–:507) holds the vocabulary shape. **Mixed.** "Nothing becomes unreachable" is KEEP: generalise it to "every world reachable". The rest goes with the lock.

### A.4 Unit tests by world (87 files, 33,145 lines)

#### Laws and floors (cross-world)

- **`LawsTests.swift`** (2,443): five laws (BUILD-CHARTER §3), the corpus floors (≥60 production files, ≥800 literals, ≥180 interpolations, ≥150 walker calls, ≥200k code characters) and these tests:
  - `testTheNinePatternsAreTheHarnessOwn` (:1205);
  - `testNoWalkerFacingViewMeasuresOutLoud` (:1316, LIFTED words);
  - `testNoPracticeValueIsBoundIntoAViewString` (:1340, FLOOR);
  - `testOnlyTheMandalaItselfIsEverCounted` (:1387);
  - `testTheOnlyDigitShapeIsASeatInTheGarland` (:1417, LIFTED digits; keep identity digits allowed);
  - `testBothRecognitionLinesAreVerbatimAtEverySite` (:1453, ≥5 sites, ≥2 files), `testNothingNearlySaysTheRecognitionLines` (:1483) and `testTheCeremonyStillSpeaksBothLines` (:1540), all FLOOR;
  - `testNoNameKeyedShaktiLookupExists` (:1570), `…ClosureFindsAShaktiByName` (:1600) and `testEveryPerShaktiKeyIsAPosition` (:1641), all FLOOR;
  - `testTheAssetCatalogueHoldsNoFigure` (:1741), `testNoDrawingPrimitiveIsHandedAFigure` (:1787), `testHerIconographicProseNeverReachesARenderPath` (:1830) and `testTheRenderPathIsMadeOfShapes` (:1867): LIFTED except "no figure";
  - `testTheOnlyPostsInTheTreeGoToTheLedgerAndTheCodex` (:1915), `testTheMandalaTableReceivesOnlyRecordAddressedPatches` (:1943), `testTheLedgersVocabularyLivesOnlyInTheLedger` (:1976) and `testNoMandalaWriteCarriesAnEventField` (:2022), all FLOOR.

  `LawsDrawnMeasureTests` (:2110): count identifiers never reach Views/Mandala, Memory, Spike or Theme, and no arithmetic is done on counts (the old radius ramp `4+min(n,6)*0.4`, commit 4cbc66c). That is FLOOR (nothing scores him) as written, but the foundation lifted "two-state seats", which this enforces. See C. `LawsTheMarginTests` (:2238): the margin can't say how many, Settings never reads a note, one navigationDestination, no digits, no motion, the composer doesn't let go mid-write, discard-if-emptied, restore before reconcile, writes only what he typed. Data safety is FLOOR; no-count is LIFTED.
- **`LegibilityTests.swift`** (626). FIDELITY rule 4, ≥11 pt and ≥0.5 α, on every Text in Views/. Exemptions are pinned: decorative (`TheHundredTwoView` ›, the Recognition ghost bīja at 300 pt and accentFaint); unresolved (the Detail status pill); computed size (DailyRite veil name ≥40 pt at α .24, RiteBlock name ≥27, threshold 46/42/37, PlayInk ≥12, the dissolutions' lines at 19/20/26). Nothing under 11 pt anywhere. **The two ghost hints sit exactly at 11 pt and 0.5 α:** HomecomingView "tap to enter" and RecognitionMomentView "Tap anywhere to close". The alpha token table is complete. Corpus floors: ≥25 views and ≥120 sites. **FLOOR (a11y).** Views/Rooms are excluded from the pins.
- **`DynamicTypeTests.swift`** (313). No raw `.system(size:)` or `.custom(size:)` without `relativeTo:` outside Theme/Fonts.swift. The pinned exceptions (`fixedByDesign`) are the canvas labels at 11.5, the mark glyphs at 20/22, the ghost bīja `300 * scale`, the Rite name `min(nameSize(cap:120)*1.7,150)` and Devanāgarī beat two. The three tokens scale. The size→style map runs 11→caption2, 12→caption, 13→footnote, 15→subheadline, 17→body, 20→title3, 23→title2, 30→title, ≥44→largeTitle. Sizes hold their identity at the default size, including half points. At AX3XL, 11.5 grows >1.5×, 17 >1.5× and 60 >1.1×, with the smallest growing most. No Text sits in a fixed `.frame(height:)`, and `lineLimit(1)` needs `minimumScaleFactor`. **FLOOR (a11y).**
- **`HitAreaIdiomTests.swift`** (325). Six controls are found by their words, each with `.frame(minHeight:44)` and `.contentShape`; plus the celestial strip, the rename field and the Portrait artwork's `contentShape` (without it the long-press export was unreachable). There is a nine-entry **compensation ledger** ("nothing moved"), and the floor must come after `.background`. The 44 pt floor is **FLOOR**. The compensation ledger serves the lock and is **LIFTED**.
- **`DeviceSlipTests.swift`** (206). The zoom column's `controlWash` is a RadialGradient of ≥3 stops, rim α 0 at location 1.0, centre ≥.6, monotone (a seat's glow under the controls). The quality paragraph and the Settings title are set in Cormorant. Motes run on a `TimelineView(.animation(paused: reduceMotion))` with no `repeatForever`, and are mid-flight on the first frame. Every `repeatForever` in Views/ lives beside a reduce-motion gate. DECISIONS.md must still say "staged first paint" (G5 is BLOCKED on hardware). **FLOOR (a11y) and craft.**
- **`EphemeralStoreTests.swift`** (160). EPHEMERAL_STORE is DEBUG-only, read once, in-memory, and never preserves, removes, moves or trashes files. **PinnedEnergyTests:** the Field honours `AppRuntime.pinnedEnergyPosition`, the last ENERGY_POS wins, and the field snapshot pins a kp outside 29–44. **HARNESS and FLOOR (law 8: a debug argument may never stand between him and his practice).**

#### Data, ledger and persistence (FLOOR, all of it)

- **`ActivityLedgerTests.swift`** (970). App Activity `tblJlBeiHnqGpYrL7` (:59), `Source App = "Mandala"`. Fields: Notes, Link to Mandala, Felt At, Gesture Source, Duration (sec), Source App, Activity Type, Activity Name, Detail, Activity Date, Lunar Day, Moon Phase, Descent Ring.
  - The ledger's own words: "<name> — first recognition" / "Felt here for the first time · <phase>"; "— felt again" / "Felt here again · <phase>"; **"Ninth Āvaraṇa — crossed" / "Fell inward to the Bindu · Waning Crescent"** (:127); "— silence held" / "Dwelt past the first adaptation · <phase>"; "A note left in the instrument" / "Left in the instrument · <phase>".
  - Āvaraṇa record ids: ring 9 recqdC3D38TWFkf1M, ring 1 rec0XhDKfxW8UVyaB, ring 2 recspOpR95DVcOEvn, ring 3 recp4X5tuGdLuHCVw.
  - Enclosure forms: Bhūpura · 16-Petal Lotus · 8-Petal Lotus · 14 Triangles · 10 Outer Triangles · 10 Inner Triangles · Vāk Ring · Mūla Trikoṇa · Bindu.
  - Behaviour: dedup ±60 s; restore oldest first; twin folding (the 09-07 backfill of 38 milestone rows); unplaceable rows are never coerced to "now"; crossings rebuild DescentState; note dedup on [Activity Type, Felt At, Notes] (fixes a bug where narrowing left the type nil and duplicated rows); notes are never dated "now".
- **`RecognitionDedupTests.swift`** (212). A ±60 s window, ISO8601 Z at second precision. Formula: `AND({Source App}='Mandala', {Activity Type}='Shakti Recognized', IS_AFTER({Felt At}, …), IS_BEFORE(…))`, addressed by field name with no `fld` ids. readFields are [Link to Mandala, Felt At]. Server milliseconds are normalised. A row matches on the same link and the same second. `patchAlreadyLanded` and `wasFirst`.
- **`RecognitionMigratorTests.swift`** (57). Legacy Ring-2 position 5 → kp 33; an invalid row is left at 0 ("refuses to invent").
- **`PendingQueuePolicyTests.swift`** (168). Never drop (`maxFailures nil`); with no token, hold; merge enqueues during a drain; keep the newest body per key; stamp UUIDs on legacy items; unreadable input yields empty, not a crash.
- **`SchemaMigrationTests.swift`** (172). A clean reopen keeps everything with no `.corrupt-` file. A V2 store on disk reaches V3 with every row intact. The fixture includes HomeMemory visits 7, accumulatedDwell 412, longestDwell 190, deepestAdaptation 2. **HomeMemory is phone-only (R17) and unrecoverable if lost.** The latest schema is 3.0.0: 3 schemas, 2 stages, V3 = V2 + MarginNote. **"Add a version; never mutate a shipped one."** Every new world's model (Relationship Field and others) must arrive as V4+.
- **`LetterMigrationTests.swift`** (308). V1 per-ring letters 1–16 move to kp 29–44 (n+28) byte-identically: empty, trailing newline, and a 69th-character trailing space all survive. updatedAt is kept and provenance rides along. A second reopen is idempotent. A kill inside the stage recovers from the `LetterMigrationStash` sidecar. An empty hold never clobbers. Quarantine keys sit above 102 with no collisions. `LetterStore` never writes on read.
- **`LetterDraftTests.swift`** (67). `isDirty` is the single save gate. Opening is not an edit; whitespace is an edit; markSaved moves the baseline.
- **`MarginTests.swift`** (284). MarginNoteStore covers blank-writes-nothing, one row per note, the queue forever, the sweep skipping the open composer, SYNC_OFF intact, discard only if emptied and not ledgered, and a per-note flight interlock against double POSTs. MarginDate spoken forms are words only ("August the twenty-first") across a whole year.
- **`SilenceDwellTests.swift`** (82). A local `.silence` entry at kp and ring, with no note, never `.felt`; each dwell is its own entry.
- **`DescentMirrorTests.swift`** (46). A crossing counts only on a new deepest; restore never regresses below the floor of 2.
- **`HomeDwellingTests.swift`** (416). Silence is claimed once per visit at ≥62 s; first dwelling at 227 s. Full Circle comes at 102. Milestones are written once ever, across reinstalls (`ledgeredMilestones` plus ledger reconcile). For present/absent/unknown, unknown means write nothing and remember nothing. Dwelling is invisible (no SwiftUI or @Published).
- **`HomeMemoryTests.swift`** (368). `homes-memory.js`: compression 1 → .68 → .4624 → floor, never 0. headStart 0 under 12 s, else ×0.55, capped at 221. **grantsFifth**: ring 9 immediately; a long stay 287→.5, 347→1; a relationship of dwell 180→0, 330→.5, 480→1. dwellCap 4000. Marks at 62/227/347 s. HomeMemory lives in V2, not V1. CRAFT/FLOOR. The withheld fifth is a gating flavour (see C).
- **`WaveSixMemoryTests.swift`** (463).
  - CorrespondenceStore recipients age/pastSelf/laterSelf/memory/her, with voiceFile and `.purnima` seals.
  - BinduMemory `higherSelfName` ("Ram" → "Rāma"), history never overwritten, restore never replaces local.
  - CodexNoteStore (typed/spoken) and PlayTraceStore. River letters return from the ledger ("A letter to himself at nine — sent back"; "Sealed forward · opens on the full moon · …"; "Sent back to a moment").
  - **`BreathClock.breath == 8`** (:233, **LIFTED**: one breath clock). ShaktiScore tolerant decode (light hue/glow, tempo breath_s, sound carrier_hz/fifth; an absent fifth falls to the ground ratio 0.75).
  - CodexWrite `tblDF4OCMcRoxkQjU` (:301), Source App "Bindu Mandala"; Status is never written. RingFactsCache Srishti→Sṛṣṭi; ShaktiFactsCache maps sisters by position.
  - **GraceChannel reads sister apps**: a "Chapter Completed" row from Learning becomes "Three nights ago, you finished a door in your reading. It was standing in this room." (:353).
  - **HerDeepening** opens one layer per return: "what she does", "what her ring gives", "how she is known", "her enclosure" (:371, **LIFTED: gating**).
  - MonthReading: "A quiet month. Quiet is not empty." (:421). ArchiveBook. PlayLayers warmth. HeartRegister drone [0.5,1,1.5,2] (:455).
- **`SeatLightingTests.swift`** (45): seat colour is always `Atmosphere.derive`; the 86 never take the `.inner` cluster colour; distinct per kp. FLOOR (position).
- **`KhadgamalaMapTests.swift`** (45): ring boundaries kp 1–28 / 29–44 / 45–52 / 53–66 / 67–76 / 77–86 / 87–98 / 99–101 / 102. FLOOR.

#### Home (the Bindu) and Today / the Rite

- **`DailyEnergyServiceTests.swift`** (88). The practice day turns at **06:00**. A deterministic shuffled cycle covers all **102 once per cycle**, reshuffling each cycle; there is a 16-row pre-sync pool. *Thread: the day.* CRAFT/FLOOR.
- **`DayLightTests.swift`** (316). Wave 1 Slice B, Design's light measured against The Reading §2.3:
  - stroke lift ×1.7 (cap 1.0); Rite sigil opacity .977 (= .62 + .85×.42), ≥2.6× the first port; presence/recognition gain ≥1.88; field chips 1.0 (from opacity 2.4) with gains ≥3.7 closed / ≥2.0 open; rooms .5 (≥2.3); threshold .7 (≥5.5× the old .045).
  - SigilGeometry strokes by ring geometry: square 7 (4 gold T-gates), lotus16 17/1, lotus8 9/1, tri14 16/2, tri10o 12/2, tri10i 12/2, tri8 8/0, trikona 3/1, bindu 2/1 plus the bindu dot. Petals run from .42c to .88c.
  - **Nine arrival beats** at [.10, .25, .40, .55, .70, .80, .90, 1.05, 1.25] s; duration 1.3, rise 10; sigil .2 + 2.4 = settled 2.6.
  - Fire puts the prompt above the name, but the name still arrives first. Air leans (`align: 'lean'`, cap 66).
  - Sigil placement: bottom at y = h+40−310, size 620; side ±220; centre veil 620×.9×.95; centerBig 560; bottomBig 760.
  - `lrBackdrop` layers: fire 3 (2 lights), water/air/earth/light 2 (1 light), ether 3 (2 lights). Fire's updraft at y 1.04 and crown at −.10; air's light at x .18/.82; earth's ellipse 1.40×.48; light's stops [0, .26, .62]. The Field's crown is an ellipse 130 %×40 % at −.05.
  - Time tint: dawn .12, noon .07, dusk .14, night .16. The "I feel her" pill is red (139,26,42)×.66 + her hue×.34.
  - **Nine metabolisms**: ring 1 holds; rings 2–9 breathe at **[3, 8, 9, 11, 13, 15, 18, 4] s**.
  - Threshold name 46 (≤15 characters) / 42 / 37 ("Trailokya Mohana Cakra"). The sigil period is 140 + (hue mod 60) s (hue 30 → 170 s, hue 359 → 199 s), and it turns 180° in 70 s at hue 0.

  CRAFT (parity seed, and it **asserts Design's numbers as floors**, which is correct now that "Design's numbers as a ceiling" is lifted).
- **`RiteCompositionTests.swift`** (73). Element → archetype: fire ascension, water descent, air horizon, ether veil, earth foundation, light radiance. sigilScale .86–1.26, nameTier 0–3, spin ±1. RiteContent hides the empty fields of the 86 and falls back to the first line of poetry. Nothing invented: FLOOR.
- **`RiteDayTests.swift`** (196).
  - `RiteDay.doors(hour)` gives **exactly three** doors, always including `.oneSecond`, plus `.closeTheDay` at 21h.
  - The pulse lives in rings 4–8 at a 1.0 s beat. The floor is "Blink." "Breathe." "Press." at [4,4,4], then **"That was a full day of walking. Everything else today is extra."** (:46).
  - **GraceChannel**: her own room first, then a sister's ("…It was standing in this enclosure."); silent when nothing fits; once, then rests; never of today; "Last night", "Three days ago", "A week ago", **"A moon ago"** (:122).
  - **SakshiClose**: "walked one second", "Aruṇā, Vimalā, Kaulinī and others" (never a tally past three), "seventh enclosure", "Sarvajñā waited.", ending **"It trusts you."** (:145). An empty day reads **"Nothing was asked of you today."** (:150), with no missed/streak/behind/again/only.
  - **HomecomingScore**: breath 4; the yantra draws outward from the point inside one breath; the blink closes at .42; the light condenses before the first line; 90 motes.

  FLOOR (absence never a debt; Homecoming) and CRAFT. "Three doors, never five" is a restriction in the spirit of "three controls" and should be widened (see C).
- **`ShaktiBijaTests.swift`** (41). Type-1 syllable kept whole; Type-2 cut before " — " ("Kaṃ — governs K-row…" → "Kaṃ"). FLOOR (bījas verbatim).
- **`CoherenceTests.swift`** (158). Wave 6.1:
  - **three quiet controls on the Mandala** (:17, LIFTED);
  - the WayIn ring [constellation, road, modes, field, climb, whole], spoken "Show the thirty-three chakras" and "Leave the road", with ≥44 pt spacing;
  - modes offered at their hour: dawn [svapna, sandhyā], dusk [pūjā, sandhyā], none by day or night;
  - **Rām japa at `.seat(42)`, handoff `.stillness`** (:90–95, FLOOR ruling);
  - **one breath** (:99, LIFTED);
  - **GratitudeGrace**: reads `tblEFiuFIijKe9ba6`/`fld85STU49AtREkfe` only, fetch only, no other table named; speaks about one day in three; words that match her room come first; verbatim, no digits, never repeats, cut at a sentence (FLOOR ruling "gratitude gently" and privacy).
- **`EnergyGiftTests.swift`** (67). Wave 5's random gift notification: at most one a day inside his window, never in the past, deterministic per install salt; an inverted window becomes one hour. *World:* Today/Time. Keep.

#### The Mandala (held yantra and Veil)

- **`MandalaCameraTests.swift`** (100). Fitted scale min(w,h)/box×.94; zoom-at keeps the anchor; flyTarget scale 3 with the seat at .36h; **descentTarget scale 5.4 with the bindu at .44h** (ruling 9: deep zoom stays); tiers at <1.15 and <2.3. CRAFT.
- **`MandalaWorldTests.swift`** (92). Ring 9 at (0,0); ring 1 on the square perimeter; family = ring minus self, and in Ring 2 by cluster. FLOOR (position).
- **`MandalaYantraTests.swift`** (324). Wave 1 Slice A from `living-rite-mandala.jsx`, `Mandala App v2.html` and `home-mandala.jsx`:
  - geometry: 3 bhūpura squares, 1 gate path, 5 circles, both lotuses, 9 triangles (5 down, 4 up). Triangle proportion .585R inside .60R; lotus16 to .90R; lotus8 .615–.70R.
  - alphas: squares [.5, .4, .3] at width 1.1, gate .45, lotus16 .34, lotus8 .36, triangles .5 at width 1.
  - triangle rings [4,5,6,7,8,4,5,6,7]; MandalaBreath ring 1 nil, then 3/8/9/11/13/15/18/4 s as a raised cosine.
  - reduce motion holds phase at .5 (the light is kept); shimmer .82↔1 over 8 s; bindu swell ×1.28 over 4 s; seat swell ×1.22.
  - new moon: saturation .30, bindu 1.60.
  - `ringTarget` lands exactly in its ring on SE, phone and Pro Max.
  - **MandalaVeil lights** here/ground/open/ahead/veiled; standing on ring 2 the row reads [ground, here, open, ahead×4, veiled]. Names and lines stay ≥.5 α. **The Veil and the breath can't name felt, deepest, crossings, ledger, visits or streak** (LIFTED: "a veil that cannot learn"). The felt halo is warmer but still hers.

  CRAFT, parity seed.
- **`MandalaLightTests.swift`** (525). Phase 5 (ideas 27/30/31):
  - one source (Atmosphere ring-9 gold, h46); reach is monotone and ring 1 keeps >.3.
  - the gem is behaviour only (diffuse → scatter/refraction), and **no gemstone name may appear in MandalaLight.swift** (LIFTED: "gem never colours").
  - refraction never takes her past halfway to the source; hues mix the short way (341→46 meets at 13.5°); all 102 seats keep distinct colours (FLOOR).
  - `hasBeenFelt` is a Bool on the model (LIFTED: two-state seats). The veil follows the āvaraṇa table and clears only from nearness and stillness, closing again on movement; **forbidden identifiers** countByKp…visits (LIFTED). The deepest veil still keeps words legible.
  - reduce motion gets the settled veil. **Tratak**: onset >10 s, monotone, and reduce motion gets 0 or 1, never earlier.
  - **RingBija, the falling mantra**: the syllables come from `HomeWorlds.ringCharacter`; ring 8 is three syllables; root 528 × 0.917^(ring−1) Hz; ring 1 lasts 1.2 s and lower tones sustain longer; the interval comes from the vowel (ai 5/4, au 5/3, ī 3/2); it is **sounded, never written** (no view reads `RingBija.`, LIFTED-ish).
  - the light is on by default; MANDALA_LIGHT=off is the exact-match escape; there is one light construction site; the seat radius is felt/unfelt, not a ramp.
- **`MandalaVoiceTests.swift`** (383). The VoiceOver seam for all 102. Every seat is named, with no diacritics, Devanāgarī, combining marks or digits. The 86 speak a romanised name ("Sparshakarshini"); the 16 speak a de-dotted phonetic (**"Spar Shah kar shi nee"**, :193); a blank name becomes "Seventy-seventh seat". Labels read "…Second enclosure… twenty-ninth of the one hundred and two"; Lalitā's hint is **"Opens the source."** (:238). There are 102 unique ordinal words. Labels are composed in `rebuild()`, not per frame. Finger and voice reach the same `activate(seat)`. **FLOOR (a11y).** The measure-scan half is LIFTED.
- **`AtmosphereTests.swift`** (72). Deterministic. The Ring-2 inner hue {43,78,52} jitters by (29,14) = −6.034; ring 5 is s 62, l 55. Noon +13 l, night −9 l. Glow α .36 (noon ×.8), clamped .12–.5. CRAFT.
- **`ElementTests.swift`** (55). Ring table: 1 earth, 3 air, 4 water, 5 fire, 6 ether, 7 air, 8 fire, 9 light; rings 2 and 0 default to ether. Ring 2 parses tattva (Air/Fire/Water/Earth/Ether, unknown → ether). **There is no "light" branch: see C (ruling 4, "Ātma light").**
- **`TimeVariantModulationTests.swift`** (27). Dawn dh 8, noon lAdd 13, dusk sMul 1.16, night −9, new moon −16. Absolute: dawn petalSat 1, noon 6 motes, dusk triOpacity .55, night petal ×.55, new moon bindu 1.60 and lotusInnerOp .15. CRAFT.
- **`ShaktiStatusTests.swift`** (27). mapped → exploring → active → embodied (terminal), with monotone opacity up to embodied 1.0. *Tension with "nothing scores him": see C.*
- **Spike suites (DEBUG-only):**
  - `SpikeBaselineBenchTests` (112): gated G5 baseline over the scenes control/tier0/tier2 bloom/descent at t=0 and t=347.
  - `SpikeCensusTests` (376): tier-0 census is yantra 12, bindu glow 1, seat dots 102, glows 26 (one per felt seat), halos 1, enclosures 21. Bloom family is 13 threads with 2 halos, cascading over 1.2 s. Baseline re-taken lit on 2026-09-23: tier0 277.1/284, bloom 93.6/99, descent 89.8/284. **The light costs a constant +14 strokes** (ratio <1.25).
  - `GarimaCanvasSpikeTests` (471) and `SpikeGarimaSceneKitTests` (615): see Her Home.

  HARNESS (performance).

#### Her Home — the 102 rooms (and the Gate, the Rite of entering, the way in)

- **`HomesHarnessTests.swift`** (1,126). A runnable slice of Design's `homes-verify.js` (66 checks over 9 registers: canon, coverage, distinction, legibility, promise, felt, coherence, brief, iconography; "The Homes - Verification V3.html").
  - Measuring is ported verbatim. The ledger corpus is >5,000 strings across a synodic month.
  - RiteContent fallbacks: "Where do you feel her, right now?" and "Of the second āvaraṇa — the sixteen petals".
  - Compression 1 → .68 → .4624 → floor; headStart ×0.55; the fifth is withheld outside ring 9.
  - Ring counts [28,16,8,14,10,10,12,3,1]; the kp 99 Kāmeśvarī name collision is kept apart by position.
  - Authored rooms are keyed by kp {1,2,3,4,6,27,28,102}. Design's by-name ghost spellings missed 4 of the 8.
  - Language uniqueness. The logic fingerprint has 19 components over 8 motion samples, with divergence >.1.
  - It ends with an honest **absent-by-design list**: geometric divergence, premise-reversal geometry, world conditions, legibility (a 4×4 luminance grid of all 102), visual coverage, canon 6, iconography 7. → CRAFT; the measuring part is LIFTED.
- **`HomesWaveOneTests.swift`** (298).
  - SeatShape per ring (1 square, 2 petal16, 3 petal8, 4/6/8 triangle pointing away, 5/7 inward, 9 circle) and RoomShell panels.
  - **BandAir counts** from `homes-worlds.js`: r1 sun + 90 motes; r2 7 expanding rings, 120 motes; r3 2,600 churn points; r4 3 caustic spectra + prism; r5 72 ribs, 24 shafts; r6 9 lanterns; r7 5 veils, 150 motes; r8 a travelling band; r9 9 gem lamps, 220 motes.
  - RoomExposure HDR; HerLight core and halo.
  - **RoomWords** Garimā near "the ceiling is coming down" / deep "the weight was holding you all along" (:228–229), place "Feet · the first āvaraṇa".
  - HomeAfterEffect per ring [sharper, wider, lighter, wider, sharper, heavier, wider, lighter, wider], lingering 180 s, **"her siddhi is still on the instrument"** (:272).

  CRAFT.
- **`HomeGrammarTests.swift`** (706). A port of `homes-grammar.js`: 53 physics rules in pinned order (50 of Design's, plus Priyatā swell, Saubhāgya brighten, Cāpa compress); breathe fall-through under 25 % (Design's audit found 78 of 102 fell through).
  - Ring 1 splits into siddhi 1–10, mātṛkā 11–18 and mudrā 19–28. Archetypes: r2 crossed, r3 bodiless, r4 cosmic, r5 giving, r6 revealing, r7 sounding, r8 sourcing, r9 authored.
  - 18 body zones with altitudes: soles .94, belly .66, solar .6, waist .68, diaphragm .56, heart .46, throat .34, eyes .26, forehead .2, crown .1, spine .5, plus head, ears, tongue, nose, temples, sacrum.
  - Labels: "the giving and the given are one" (:470); "· aṃ" / "the room is her sound"; sourcing "will, before there is anything to will" / "the act, before there is a deed" / "form was already will and act" / "at the source"; "body and mind were one point" (:505).

  CRAFT.
- **`HomeAttributeTests.swift`** (415). `homes-attribute.js`. **26 FORMS**: noose, goad, cup, arrows, bow, mirror, lotus, flame, rosary, trident, vajra, skullcup (renamed shell), plough, sceptre, garland, seed, gem, grain, lamp, chain, herb, ground, radiance, seal (renamed foldingCapsules), palm (renamed linedDisc), line. 27 kin aliases. All 102 resolve with no fallback.
  - **15 tint overrides**: kp 1 #f2ecd8, 4 #b8263c, 7 #ff7a3c, 13 #ffb45c, 15 #6a5f78, 17 #d8d2c4, 18 #ffd76a, 29 #ff6a7c, 45 #ffb0c4, 62 #ff8ab0, 91 #ff7a5c, 92 #ffd76a, 99 #fff6e2, 100 #ff4a5c, 101 #ffd76a.
  - Mount y = (0.5−alt)×6.4−0.4, z −4.6, scale 0.9 → deep scale 3.5 at z −1.2, opacity .45.
  - Aniconic figural words are checked over the forms. FLOOR ("no figure") and CRAFT.
- **`HomeDescentTests.swift`** (477). `homes-descent.js`: STATION_Z [−16, −34, −52, −70, −88]; 46 rims at depth −8−i×2.2 with radius 5.4×.985^i; light .05 + near×.34.
  - DescentWords take five fields (tattva, bodilyLocation, etymology, quality, appreciationPhrase); an empty field is never invented.
  - **The descent holds no solid** (Design hung a torus knot, 13 boxes, an icosahedron and 3 tori there). This is the binding condition, **LIFTED**, as long as it stays non-figural.
  - **DescentReach.shallow**: 3 stations until the first adaptation, then 5 (:327–339). This is gating-lite and **LIFTED**.
  - A glissando falls a minor third per station; prompts are only "touch to go deeper" / "touch to go on".
- **`HomeSoundTests.swift`** (501). `homes-sound.js`:
  - **roots per ring [55, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47] Hz**; the varṇa table of 49; **JUST 12** [1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8].
  - techniques: r1 drone, r2 breath, r3 breathy, r4–5 stepped [1, 9/8, 5/4, 3/2] at 5.2/3.4 s, r6 breathy, **r7 sourceless witness** (partials 2, 3, 5 at .42/.26/.14), **r8 triad** (1, 1.26, 1.5, glide 3.4, period 14), **r9 Shepard** (5 voices, gain .22, LFO .22).
  - carrier = root × JUST[idx%12] × 2 (Aṃ → 110; ka → 137.5); strike [1, 1.5, 2]; the fifth (gain .05) is withheld in rings 1–8.
  - filter 220→1720, air .006→.018, the Tau table; initial carrier **136.1**, fifth 204.15, air 460.

  CRAFT (synthesised tone, not a generated voice; see C).
- **`HomeVoiceTests.swift`** (227). The HomeVoice instrument opens once and closes once. A silent stay decides the same as a sounding one. `respectsSilentSwitch = true`. CRAFT/FLOOR (a11y for hearing).
- **`HomeWorldsTests.swift`** (441). **The nine worlds' character table** (`RING_CHARACTER`):
  - r1 Tripurā · Śṛṣṭi · "Prakaṭa — manifest" · veil 0 · "Jāgrat — waking" · tempo 1.00 · AGITATE · Aim
  - r2 Tripureśī · "Gupta — secret" · .12 · "Svapna — dreaming" · .82 · LIQUEFY · Klīm
  - r3 Tripurasundarī · "Guptatara — more secret" · .24 · "Suṣupti — deep sleep" · .62 · DRAW · Sauḥ
  - r4 Tripuravāsinī · Sthiti · "Sampradāya — lineage" · .36 · "Turīya begins" · .72 · OPEN · Hrīm
  - r5 Tripuraśrī · "Kulottīrṇa — beyond clan" · .48 · "Turīya deepening" · .66 · VOICE · Hsraim
  - r6 Tripuramālinī · "Nigarbha — in the womb" · .60 · "Turīyātīta begins" · .50 · STILL · Hsklhrīm
  - r7 Tripurasiddhā · Saṃhāra · "Rahasya — secret" · .72 · "Pure witness" · .44 · WITNESS · Hsauḥ
  - r8 Tripurāmbā · "Atirahasya — most secret" · .86 · "Source-consciousness" · .36 · SEED · "Aim Klīm Sauḥ"
  - r9 Mahātripurasundarī · "Parāparāraharasya" · 1.00 · "Pure being" · .28 · ARRIVE · Hrīm

  **WORLDS**:
  - 1 Trailokyamohana · Topaz · Rasa · day–night · Feet · fog #1d1206 · .0125
  - 2 Sarvāśāparipūraka · Sapphire · Rakta · "the hour" · Pelvis · #0a1330 · .017
  - 3 Sarvasaṅkṣobhaṇa · Coral · Māṃsa · "the day" · Navel · #2a0c06 · .021
  - 4 Sarvasaubhāgyadāyaka · Diamond · Medas · lunar fortnight · Heart · #0b1219 · .014
  - 5 Sarvārthasādhaka · Emerald · Asthi · lunar month · Throat · #06180e · .018
  - 6 Sarvarakṣākara · Ruby · Majjā · season · Forehead · #1a0409 · .022
  - 7 Sarvarogahara · Pearl · Śukra · solar half-year · Crown · #d8d2c4 · .034
  - 8 Sarvasiddhiprada · Cat's eye · Ojas · year · Above crown · #0f0b04 · .015
  - 9 Sarvānandamaya · All gems · Tejas · kāla–akāla · Totality · #141008 · .009

  The veil thickens fog ×(1 + veil×.55). Live base overrides apply (LiveFacts). Ring-2 cluster hues: 29–31 inner, 32–36 tanmātra, 37 citta, 38–41 stability, 42–44 self/body. Jitter ±7°. Diffusion: Topaz .20, Sapphire .30, Coral .45, Diamond .15, Emerald .25, Ruby .55, Pearl .95, Cat's eye .10, All gems .70. **Ring 7 is sourceless.** CRAFT (the nine rings, whole).
- **`RoomSceneTests.swift`** (751). The render spine. One curve for grammar altitude and attribute mount; the eye sits at the "behind the eyes" altitude. The binding condition is rewritten as **"no figural depiction of a Śakti"** (Charter II §4.5). Five SurfaceVerbs: impression, furrow, crack, swell, compaction. **Her layer has ≥2 lights and 0 solids** (residual binding: LIFTED candidate). One room per world: (4, soles) (30, pelvis) (46, navel) (57, heart) (71, throat) (77, forehead) (93, crown) (99, crown) (102, heart). The light rig is per ring, and ring 7 has no key light. The mark's light travels with the mark.
- **`RoomCaptureTests.swift`** (350). `default.metallib` holds `roomLightPass`. Five rooms (4, 57, 77, 93, 99) are rendered at 62 and 347 s, with **luminance bounds mean .01–.9, spread >.02**. The shader clamp of .86 was lifted in Wave 1 (HDR bloom). A still pose costs <4 ms. **These bounds are far below Design's 80–255; see C.**
- **Ring by ring** (all CRAFT, with sister divergence >0.1, legible at 62 and 347 s, reduce motion settled, and "no solid in her layer"):
  - `CrossingRoomTests.swift` (975), **Ring 2**: physics by tattva (Fire 29, 34, 41 flare; Air 30, 33 lift; Space 31, 32, 40 open; Water 35, 39 well; Earth 36, 38, 44 settle; none 37, 42, 43 draw). The halves part and then become one. ≥15 reversal voices: kp 44 "body and mind were one point", 37 "the drawing and the drawn are one", 33 "the touch and the air were one". Saturation guard <25 % of pixels >.96 (Design's Laghimā stacking defect).
  - `SiddhiRoomTests.swift` (465), **Ring 1 kp 1–10**: 1 Aṇimā ContractRoom (walls close in stillness); 2 Mahimā EndlessRoom (24 frames in procession, r = 6 + i×.52); 3 Laghimā ReleaseRoom; 4 Garimā PressRoom; 6 Vaśitva KnownRoom; the rest SiddhiRoom echoes (`displace(kind, t−0.6−i×0.5)`).
  - `MatrkaRoomTests.swift` (326), **kp 11–18**: letters 5/8/11/14 speak one at a time, `pow(max(0, sin(π·turn)), 8)×5`.
  - `MudraRoomTests.swift` (762), **kp 19–28**: a mirror-symmetric seal vault; kp 27 MembraneRoom "no door · you were always inside" (:11); kp 28 TripleRoom "three rooms · one seal, only in stillness" (:12). **The body-word ban** (hand, finger, palm, womb…) is LIFTED. One `XCTExpectFailure` remains (Siddhi–Mātṛkā .392 vs .422).
  - `BodilessRoomTests.swift` (460), **Ring 3**: 8 effects around an absence; "the effect was the only body".
  - `CosmicRoomTests.swift` (653), **Ring 4**: a coil of 14 shells around the heart, with a lag of t − i×.42.
  - `GivingRoomTests.swift` (754), **Ring 5**: 12 gifts cross to a landing; "the giving and the given are one". Design's gift *sprites* were replaced by marks (binding: LIFTED candidate).
  - `RevealingRoomTests.swift` (594), **Ring 6**: 10 truths and a veil; **"it was never hidden · you were the veil"** (:122); Design's defect "a veil must obscure something that is still there".
  - `SoundingRoomTests.swift` (575), **Ring 7**: mode 2 + (pos%8), standing-wave silences; every mark glows (sourceless).
  - `SourcingRoomTests.swift` (509), **Ring 8**: Icchā 99 / Kriyā 100 ("Lightning-Action" dart) / Jñāna 101 at the corners, a rotating triangle and a still bindu.
  - `GateRoomTests.swift` (758): **"the Gate" = Laghimā kp 3 and Garimā kp 4.** "the weight was never above you. It is what you are standing on, and it has been holding you the whole time." "as the walls go, the opening they were hanging from takes the whole room." Gate divergence >.5 (Design: "differ by 100% of their geometry and 116 of luminance"). The shipped data had drifted from the base on 61 of 102 names, hence position keys.
  - `DissolveRoomTests.swift` (462), **kp 102**: **99 marks** = 3 squares×8 + 2 circles×12 + 16 + 8 petals + 9 triangles×3, plus the source. The yantra turns +.0075 against the triangles at −.014. The source travels z −8.4 → 0 and opens (1 + b×2.8) while dimming: "a light you are inside is not a light you see". "the room stops being a room".
  - Fixtures `RingOneFingerprint.swift` (212) and `OuterRingFingerprint.swift` (338).
- **`WholeInstrumentTests.swift`** (316). All 102 resolve by position with ring counts [28,16,8,14,10,10,12,3,1]. Nobody falls to `.seat`, `GrammarReversal` or `ArchetypeReversal`. **Design's eight authored rooms are pinned to their kp**: 1 Contract, 2 Endless, 3 Release, 4 Press, 6 Known, 27 Membrane, 28 Triple, 102 Dissolve. Sister divergence is measured with a both-silent skip (the finding: release vs press looked .037 apart under padding). Every room is legible. CRAFT and FLOOR (every seat has its own room).
- **`RiteOfEnteringTests.swift`** (974).
  - Compression scales the writing (1, .68, .46, floor .36); three beats always (phrase, written, roots); touch-paced, never timed.
  - Stations [0, .3, .62, .88, 1]; crossing 2.2 s × (1−.88); the strike's carrier, fifth and octave rise.
  - Her name is written in three strokes (hold .72); roots part and rejoin (.52/.58) with gloss α .6. Prompts are "touch to go on" / "touch to enter" (α ≥.5, against Design's .44).
  - Head start at the threshold. **RiteWords**, e.g. "Thank you for the weight that holds me here." (:49), Devanāgarī गरिमा, roots Guru + imā; compound suffixes ākarṣiṇī, karṣiṇī, mayī, pradā, kāriṇī, sundarī, mālinī, eśvarī, iṇī, inī.
  - **`testTheRiteNeverSaysHeHasBeenHereBefore`** (:644: welcome, return, back, again, before, "have been here", visit, remember, already, "last time", "once more") is **LIFTED (returning-word ban)**.
  - It adopts the walker's reduce motion. CRAFT/LIFTED.
- **`TheWayInTests.swift`** (1,003).
  - All 102 can be entered (:62). The Gate goes through the same door (:112).
  - **`testTheOnlyRoomInTheShellIsTheOneBehindTheRite`** (:142, "a room may not be reached without the rite") is **LIFTED** ("a room only behind the rite").
  - Every door passes the one threshold, `HerRoomDoor` (:171), with doors in ShaktiDetailView, LivingMandalaView, DailyRiteView, TheHundredTwoView and WorldClimbView. The corridor walks to neighbours (:204). **The edge is an equal way out** (:226; TheEdgeWayOut travel > edge width ≥16).
  - The door asks only whether she has a room (:246). The way out lasts 2.2 s; reduce motion steps out with a tap.
  - The stay is filed exactly once (:753). The Climb is reachable and opens at the ring he stands in (:502, :519). The way out can't say a number (:317, LIFTED).
  - `StillRoomRedrawTests`: a still room is posed once per move.

  **The reachability core is a KEEP and the seed of the walk.**
- **`GateLookTests.swift`** (199). Captures Laghimā and Garimā at four moments to PNG. The near-half luminance ratio must stay <3.5 (a wash guard: Garimā .081 → .343 was a wash). "Visibly changed" means >20 % of a 48×48 grid moved. CRAFT; a template for "a room visibly changes".
- **`GarimaCanvasSpikeTests.swift`** (471) and **`SpikeGarimaSceneKitTests.swift`** (615). Renderer spike variants B (Canvas + TimelineView) and A (SceneKit + SwiftUI Metal light pass). Both pin canon: kp 4, ring 1, earth; hue 35 − 6.384 = 28.616; topaz .20; tint #B8263C; 33 bed heights keyed to kp. **Physics**: Pṛthvī settles, Vāyu lifts, Mahat widens, Aṇu shrinks. The press is followed by a **reversal ("you are carried up by the thing that was crushing you")**. Legibility: hi >90, lo <70, range >70, mean 8–175, delta >9. The SceneKit census is one shadow-casting light, ≥8 nodes, >15,000 triangles and >400 points. **Finding: `drawHierarchy` cannot see a CAMetalLayer**, so SceneKit rooms must be photographed with `xcrun simctl io … screenshot` or `SCNView.snapshot()`. Any parity or screenshot of SceneKit worlds must go around SwiftUI. HARNESS/CRAFT.

#### Her Presence (portrait, Detail, Recognition)

- **`RecognitionNatureTests.swift`** (306). Six natures, one per element:
  - **Keyframes** (rest scale, rest light, drift, rise, peak scale, peak light): flare [1, .32, 0, −16, 1.06, .58]; pool [1, .40, 0, 0, 1.07, .58]; disperse [1, .30, 20, 0, 1.04, .52]; bloom [.9, .30, 0, 0, 1.16, .60]; settle [1, .34, 0, 0, 1.015, .46]; radiate [1, .40, 0, 0, 1.05, .72].
  - **`LR_RECOG`** rows (fy, focal, respDur, rippleDur, rippleN, motes): flare [.60, .96, 5.5, 4.6, 4, 12]; pool [.50, .62, 6.5, 6.4, 4, 10]; disperse [.44, .40, 6.0, 4.0, 5, 14]; bloom [.45, .45, 4.8, 5.6, 3, 10]; settle [.54, .92, 7.5, 7.6, 2, 6]; radiate [.44, .44, 3.8, 3.6, 5, 12].
  - Ripple ends: pool 34×34, flare 30×30 rising 120, disperse 52×20. Haptics: settle heavy, flare rigid.
  - **Timeline**: name .3, phrase 1.1, act 1 2.6, act 2 4.3, note 5.4, collapse .62; "and she felt you back" lands in stillness. After-glow 1–3 s on a k² curve.
  - The record is written before any light moves (FLOOR). The Recognition files can't reach counts (FLOOR). No Image(): **the ceremony is light, not a figure** (FLOOR/craft).
- **`TheLibraryFoldTests.swift`** (336). The Detail library: HerMomentsList is built only behind the "her moments" shelf. The six reference sections (iconography, lineage, cosmic function, tattva, bodily seat, etymology) sit behind "go deeper". Both shelves are `@State` `Bool = false`; the screen writes nothing about him. Body order: hero, codexPortrait, somatic, bija, appreciationPhrase, embodiment, fieldConnection, herMomentsFold, goDeeper. The shelf row takes four things. a11y value "unfolded"/"folded". **Mixed**: a11y and "writes nothing about him" are FLOOR; the drawn-measure fold is LIFTED. The foundation audit names this 13-section text page as the thing to replace with Her Home and Her Presence as worlds.
- **`SomaticRegionTests.swift`** (72). From the base field `fld6P1u43B0eqKU5e`, read 2026-10-12:
  - "Heart / hands" → heart, hands (kp 100); "Mūlādhāra / soles of feet" → root, soles (kp 82); "Third eye / direct-seeing point" → brow (kp 77); "Throat (luminous)" → throat (kp 91); "Bridge of nose" → senses (kp 36); "Back-body, spine" → spine (kp 38).
  - "Belly / yoni / point-of-manifestation" → belly, root (kp 101); "Wherever healing is needed" → field (kp 81); "Bindu point at crown / single point of attention" → crown (kp 1).
  - Sensory doorways by tattva: Air → breath, Fire → heat, Water → water, Earth → earth, Ether → space. The doorway line is her own first somatic line, otherwise nothing. FLOOR (nothing invented) and a **gift (the body map)**.
- **`LivingMandalaTests.swift`** (179). Wave 5's Portrait as a Living Mandala:
  - n-fold mirror folds per ring [28, 16, 8, 14, 10, 10, 12, 3, 1]; the ring is read from where a stroke begins; strokes thinned to ≤256 points with their ends kept.
  - **The year as beads**, one per practised day at its own day-angle (2π·doy/365 − π/2). C-1348: "gaps and spaces aren't meant to be filled but fully inhabited".
  - Strokes are practice data: persisted, ledgered once, recovered after a kill. Unreadable files are set aside. StillnessSensor reaches 1 after 10 s still.

  FLOOR and gift.

#### The Climb (Axis) and the one building

- **`OneBuildingTests.swift`** (449).
  - The Garland is a circle (1↔102). ClimbLights: 102 positions, seats per ring [28,16,8,14,10,10,12,3,1]. **C-1284: every light breathes the same, met or not** (FLOOR, nothing scores him).
  - Ring 3 scatters at touch; ring 8 gathers kp 99–101; ring 6 whispers ("made of knowing", :100).
  - **TheGates**: inward is an offering, outward receives a siddhi (C-1230, "something to get, not something to give up", :194). Ledger rows "State Set Down" and "Siddhi Received".
  - **Mauna** is a Silence Held at kp 102 after 7 s (C-1355; MaunaDepth follows steadiness, not the clock). "Who is saying that?" (C-1305, :302).
  - **CentreArrival takes one breath**: entered ring ≥8, point near the middle (C-1307). The 12 Oct gentle tap at the point opens silence. The point opens only after he rests in the recognition (:350).
  - **Pointy** (C-1306): 102 particles go line → circle → ∞ → heart (:366). **CentreBloom** draws trikoṇa → triangles → lotus8 → lotus16 → bhūpura → names, scale .05 → 1, hold to open (:393). **Pravesha**: an endless fall that never reaches a bottom (:415).
  - **RingFieldVoice** crossfades ≤2; the point is silent; Vāk chord of 12; sourceless root **136.1** (:434).

  CRAFT, FLOOR and gifts.
- **`WorldClimbTests.swift`** (1,037). **Reads Design's files from disk** (`homes-worlds.js`, "The Homes - The Axis.html"; XCTSkip if absent):
  - ring clocks: day = t×0.05; bpm = t×1.05; r3 uTime; r4 fortnight sin(t×0.0398); r5 moon .0199; r6 season .0066; r7 half-year .0033; r8 year = t×0.062; r9 rotation t×0.008 with breath .9 + .16·sin(t×.13).
  - Axis: settle `climb += (target − climb) × (reduced ? 0.035 : 0.06)`; rise `target + dt × 3.4`; nearReach `WORLD_SPACING × 1.15`; veil (1 + veil × .55); entering fog ×(1 + swallow × 1.6).
  - the tempo never touches the adaptation clock; eye continuity <.25 units per .25 s; the key moves only with the bands (the Feet sun 14°); ring 7 has no key light; every presence is light; the ground morphs across 8 targets.
  - **The summit is empty** (C-1260): "I am what I am becoming." / "I already did." (:788–789).
  - stone emission requires relief (binding, LIFTED candidate); the rise is closed-form; reduced motion steps one station.

  CRAFT, and **the model for Design-parity tests**.
- **`WorldClimbCaptureTests.swift`** (315). An offscreen SceneKit capture of each band at 62 and 347 s, with a 64×64 Rec.709 luminance grid: mean .01–.9, spread >.02. Also the darkest moment of each world's own clock, the Crown as sourceless, and a Float-ulp bug in absolute time. HARNESS for parity.

#### The 33 (the braid)

- **`ChakraConstellationTests.swift`** (238). The 33 bake: roads 1…33. Shadow is a threshold [3,4], Armin [6,7]. Road 1 is the Bindu and road 33 Lalitā, both at kp 102. Sections (C-1344/45): energy 7 in rings 1–3, body 10 in 4–6, mind 9 in ring 7, summit in 8–9. Body seats {53, 65, 66, 69, 70, 71, 77, 80, 82, 84}. **The Ego Reveal's Sanskrit is nil** (the 12 Oct bake). The road begins and ends at the point and spirals home (camera scale within bounds, centre at .42h, a longer dwell at Shadow, travel 2–4 s). FLOOR (ruling 2) and CRAFT.
- **`ChakraRoomTests.swift`** (337). Columns: Core Question, Signature Phrase, Practice Prompt, Three Ways In, Practice Gate Type, Gate Text, Story Thread, Leela Story, Act 1/2 Voice, Bindu Reflection, Witness Perspective, Voice, Writing Prompt, Mirror Frequency Instruction.
  - Verbatim: road 9 "please come back home." (:57), road 20 "Nothing needed repair. Only arrival." (:58), road 2 "Am I safe here?", road 33 "Who is playing?" (:60).
  - Gates by type: road 10 Sound Response, "I feel the ground", "Stand up."; road 14 Tap Rhythm; road 30 Maya has no button.
  - Sounded bījas: road 2 LAM, 10 LAM, 7 OM, 15 HAM.
  - Home doors: road 10 → seat 53; road 1 → 102; road 21 → 87.
  - Games at addresses: road 9 corridor and shadowScrolls; 14 pulse and coherence; 18 spineWalk; 20 tatTvamAsi; 29 mandalaCompletion and twelve; road 5 ramJapa.
  - Movements: euphoriaPulse [13, 14] (C-1311), hamHetHum [6, 15, 16] (C-1342: HAM receive, HET hold, HUM transmit), roarAndSilence [6, 15], fearInWaves [2] (C-1166), restlessness [19], heartHome [5], lastMemories [17], feelingThrough [10]. The body chakras' climb heights run from Soles (0) to Crow at the Sahasrāra band.
  - Ledger "Chakra Practiced" links to both The Map and Mandala.

  CRAFT and gifts. Story columns are flagged (see B rows).

#### A Strange Game (Leela and every game)

- **`PlayTests.swift`** (578), four classes.
  - **Address table, read off the Mandala table on 2026-10-12.** **36 games** (16 from Wave 4, 20 from Wave 6). Seats: pulse and coherence kp 70 Sarva-Maṅgalakāriṇī; spineWalk 84 Sarvānandamayī; echo 80 Sarvajñānamayī; fingerGarden 69; rain 71; drum 53 (The Map: Soles); rootSystem 4 Garimā; waterLevel 15 Vārāhī; fire 65 (Forge); shakeToClear 82 (Crow); door 94 Kaulinī (Innocence); yantraTrace 102; seed 26; colourRivers 20; bhakti 24; mirrorMaze 30; stillAjna 51; bodyMap 77 (Vision); letter 88 (Intention); flash 91 (Intuition); join 92 (Invention); **shadowTranslator 101 (The Map: Ego Reveal)**; leela 102; **ramJapa 42 Ātmākarṣiṇī** (:51).
  - Unseated games: corridor and shadowScrolls at the threshold 3→4; tatTvamAsi at 6→7 (Armin); mandalaCompletion and twelve in ring 7; turn ring 8; worldInABox ring 9; sandhyā ring 2; greatWheel ring 1; rosary across the whole garland; bījaTones ring 1. Every one of the 102 has a play door (her game, or her bead in the rosary).
  - **Physics, C-1357, "never tell him he is doing something wrong"**: force is absorbed, the corridor at the body's pace takes nothing back, pulse catches a steady heart (.82 s), the spine light can't be rushed, echo climbs to the fifth, rain counts only long breaths, the drum on the beat, roots from stillness, water held level, fire tended in its band, shaking clears, the door opens to a light hold, the yantra traced as 27 edges with the mūla trikoṇa first, the rosary of 102 beads.
  - **Awakening tones** ring 1 174, ring 4 341, ring 8 528 Hz, the Bindu's tone silence, *not* the solfeggio ladder 396/417/639/741/852/963. Coherence: an 8 s breath against heart beats.
  - **Ledger**: one "Played" row, Gesture Source Play, link to her row or her ring ("Kaulinī — played", "Fifth Āvaraṇa — played", "The Shadow crossing — played").
  - **Screen**: no number about him; **no red as failure** (the one red is Lalitā's point in PlayFieldView); **no verdict words** (well done, congrats, perfect, win/lost/fail, wrong, try again, game over, complete, best, record, score, streak…); **play keeps no store of its own** (:559, LIFTED); drawn from light alone (FLOOR, no figure).
- **`PlayWholeTests.swift`** (444). The physics of all games:
  - SeedGrowth stages seed / sprout 3 h / sapling 12 h / tree 30 h / bloom 80 h; TwelveCircle as a circle of fifths 272.2–544.4 Hz; BodyListening open/alive/held over 10 centres.
  - ShadowTranslator: burden → one of the ten Siddhis. MazeFall 7 lenses. ThreeWords Tat Tvam Asi. ScrollUnroll's 12 lines end **"You are a bigger container now."** (:160).
  - WorldBox keeps objects, never totals, and gifts are never a debt. **Leela: six to be born; arrows and snakes 5→8, 12→18, 15→6; an exact landing; the board holds at 32; "the road ends at the point it began"** (:199).
  - JapaMala 108 beads, one per whole breath; Ārati only sunwise at an even pace; Sandhyā "What you carried today\nyou may set down here." (:305); GreatWheel comes to rest with today at the point; SeasonLight per Ṛtu.
  - The garden store never removes anything. 36 lights on the field ≥46 pt apart. Ring mechanisms: earthCity, lotus, lineage, overflow, collapse.
- **`GameStructureTests.swift`** (309). `Data/GameStructure.json`:
  - nine panels in ring order, verbs = `TreeOfLife.verbs`; five faces each with one line; ≥6 Leela drops, none measuring. **Sealed: Ego Reveal and Lalita are never drawn** (:43–46, FLOOR ruling 2).
  - Tree of Life: rings 1–5 answer to a press that lengthens inward, 6–8 to stillness (hold >600 s at ring 7), 9 to nothing. Guide words thin to 0 by ring 7. The breath arc labels are in/hold/out (36 s at ring 1), then in/see, then none. Luminance .05 → .90 → 1.
  - **Om 136.1 Hz** with partials 272.2 and 68.05, as a floor and never a crescendo. **Panel 9 undoes the eight dissolutions, names nothing, "Now go play."** (:108).
  - **LeelaDrops**: never in the first days, never twice a day, never inside `minimumGapDays`, otherwise by chance; the same drop never twice in a row (:115–155; FLOOR ruling). The Leela row grades nothing; "Light Entered".
  - **TrinityOfGuidance faces**: room kp 31 → Gaia, kp 42 → Higher Self, climb 1 → Bindu, climb 9 → Lalitā, descent 7 → Sākṣī. **Each speaks once a day.**
  - ActivationCycle: the gesture recedes to presence by ring 7; jitter .85–1.15; fullness .6 → 1.
  - **ThreePools**: being refreshes daily and is a state, not a tally; Played → memory; Letter Sealed and Leela Drop → the Well; Shakti Recognized → the Portrait.
  - **SoundArbiter: one bed at full voice** (:247, LIFTED); on the Climb the ring voices stand in front (§4.6); the heart register he chose stands in front; the Om under the bed. **TheBells** open once a day at 272.2 and close at 136.1.

#### The Modes

- **`ModesAndRitesTests.swift`** (345). See A.4 Today for RiteOpening. Also:
  - ModesDoor: every mode at every hour (no lock); dawn puts svapna first, dusk pūjā first.
  - **Darśana**: arriving → holding → entered by stillness only; movement loosens it.
  - **Sādhana**: the garland recited 1 → 102 in **28 minutes**, ring by ring inward.
  - **Smṛti**: every seat felt is lit once ("felt a thousand times is still one light"); a day with several seats is one constellation.
  - **Svapna**: "The night was still." (:136). **Pūjā**: "The day is received." / "Tomorrow opens again." with a gather → rise → gone curve.
  - ModeGeometry places all 102 distinctly. **RiteOpening**: "Stop. Breathe. Remember." (C-1303, :172), the Sacred Pause of three breaths (C-1160), Śṛṣṭi/Saṃhāra, once in each half of the day, the dusk rite "offered" not "set down" (C-1230), the year of 102 as fading light.
  - **RiteStation**: Arrival, Summons, Meeting, Being-with, Offering, Carry; Carry is nil if she has no line (nothing invented).
  - **LowStateDoor** gives only his own words, never asks "?" (C-1002/C-1120).
  - **RitesPractice**: witness pages are kept whole and never overwritten. Ledger rows "Witness Written", "Garland Recited" ("Recited inward to the third enclosure…" / "The whole garland…", linked to kp 102), "Day Offered", with no durations.

  FLOOR (data, nothing invented, no prompts) and gifts.

#### Time

- **`EphemerisTests.swift`** (198). The real sky against published values:
  - USNO phases 2026: new 09-11 03:27, full 09-26 16:49, new 10-10 15:50, Q1 10-18 16:12, full 10-26 04:12, Q3 11-01 20:28, full 11-24 14:53 UT. TheSkyLive agrees. Shubh Panchang and Vedic Marga: Pūrṇimā ends 04:11 UT on 26 Oct; Aśvinī → Bharaṇī at 12:11 UT. USNO rise/set for Bensalem PA (40.1046, −74.9516): 07:07 / 12:46 / 18:25 EDT on 12 Oct.
  - Tolerance .25°; tithi, nakṣatra, Lahiri ayanāṁśa 24.23°; ṛtu Śarad (tropical Sun ≈199°); Dakṣiṇāyana; the Sun in Kanyā until Tulā saṅkrānti on 17 Oct; sandhyās prātaḥ/madhyāhna/sāyam; TemporalPlace home (the NY zone) else the zone meridian (Kolkata 82.5).
  - LunarPhaseService agrees with Panchanga. The **TemporalReading "five clocks"** read tithiWords "Kṛṣṇa Pratipadā", nakshatraWords "Aśvinī", ṛtu Hemanta on 26 Oct, hourFraction, and sunWords "…Dakṣiṇāyana".

  FLOOR ("A wrong tithi is a false statement") and the Time world, whole.
- **`LunarPhaseServiceTests.swift`** (63). Illumination 0/1; tithi 1–15 mirrored; time-of-day buckets (3 night, 7 dawn, 12 noon, 18 dusk, 22 night); the new-moon override below .03.

#### Memory, the Well and Beneath

- **`TheRiverTests.swift`** (242). Wave 5, the Well as a river:
  - `CorrespondenceStore.seal(body:to:opening:)` with **no peek**; it opens on her day on the real moon. Pūrṇimā starts at elongation 168° (tithi 15) before the full moon of 26 Oct; Amāvasyā is tithi 30; tithiReturns is one lunar month later; herDay is the next day DailyEnergyService gives her kp.
  - **Send-back letters to a past moment** are readable at once, and a future moment clamps to now. The draft survives a relaunch. **Old pages yellow by real time** (patina).
  - **The Wager** (C-1195, energy recedes when watched): nothing is placed and nothing asks; he may notice her at any hour, once a day; old watches are answered.
  - Ledger rows: "A letter to Kāmākarṣiṇī — sealed" (his words in Notes), "A letter to a Śakti — sent back", "Letter Opened", "Portrait Drawn" (linked to the āvaraṇa), "Wager Resolved" ("She appeared…" / "Watched for…").

  FLOOR (letters private, ledger once) and gifts.
- **`WaveSixMemoryTests.swift`**: see Data above (river letters, BinduMemory, MonthReading, ArchiveBook, PlayLayers, HeartRegister).
- **`LivingMandalaTests.swift`**: see Her Presence (the Portrait, the year ring).
- **`HomeDescentTests.swift`**: the descent *beneath* her room (Beneath).

---

## B · Gifts for the upgrade, and what the test suite must become

The assignment asks two things of this section: what to do with the tests, and what in them is a gift. B.1–B.4 answer the first and B.5 lists the gifts.

### B.1 The rule ledger: every restriction and every floor, and the tests that hold it

**LIFTED: these tests must be retired or rewritten with the build, or the upgrade fails its own CI.**

| lifted rule | tests that encode it | what to do |
|---|---|---|
| "No menu", three quiet controls, the six-way ring, "nothing listed" | `CoherenceTests.swift:17` (exactly 2 `controlButton(` plus the Veil peek; overlay switches banned); `:34` (the WayIn ring of six); `RiteDayTests.swift:21` ("three doors, never five"); `HitAreaIdiomTests.swift:220` (the compensation ledger that keeps the glass from growing) | **Retire** `:17` and the compensation ledger. **Rewrite** the WayIn ring as the seed of the World Registry (its spoken labels, "Show the thirty-three chakras" and "Leave the road", are good). **Widen** RiteDay's doors (keep `.oneSecond` always offered, which is a floor of kindness). **Keep and generalise** `MandalaLightReachTests.swift:176/:211` (the hamburger reachable and opening the menu) into "the full index is one touch away on every world". |
| One sound at a time | `GameStructureTests.swift:247` (≤1 bed at full voice); `:278` (on the Climb, ring voices replace the room); `OneBuildingTests.swift:434` (crossfade ≤2) | **Rewrite** as a mixing law: beds may layer; a struck bīja ducks the bed (keep `bedUnderAccent`); the Om stays a floor and never a crescendo (keep `TreeOfLife.omFloor` ≤ .05 at depth 9); assert a summed-loudness ceiling instead of a count. |
| One 8 s breath clock | `CoherenceTests.swift:99` (`RiteOpening.breathSeconds == BreathClock.breath == CentreArrival.oneBreath`); `WaveSixMemoryTests.swift:233` (`BreathClock.breath == 8`, FieldBreath snapped to whole beats, Score tempo snapped) | **Retire.** Keep Design's **nine metabolisms** (`DayLightTests` and `MandalaYantraTests`: ring 1 holds, rings 2–9 at 3/8/9/11/13/15/18/4 s), the Homecoming's 4 s breath, the Rite's own pause and the Coherence game's 8 s breath, each as its own clock. |
| Measuring-word lists (numbers, ordinals, "again", "level", "progress") | `LawsTests.swift:1316`, `:1417`; `NeverMeasure` word half; `HomesHarnessTests` Measuring; `MandalaLightReachTests.swift:152`, `:315`; `TheWayInUITests.swift:349` (list `:424`); `TheMarginUITests.swift:138`, `:232`; `LawsTheMarginTests` `:2273`, `:2327`; `MandalaVoiceTests.swift:147`; `RiteOfEnteringTests.swift:608`; `TheWayInTests.swift:317`, `:540`; `CoherenceTests.swift:44`; the digit checks in `ModesAndRitesTests`, `RiteDayTests`, `TheRiverTests`, `MarginDateTests`; `PlayTests.swift:488` (digits and game measures); `TheLibraryFoldUITests.swift:163` and `TheLibraryFoldTests` (drawn measure); `ChakraConstellation` and `MandalaVeil` spoken-row digit checks | **Replace all of them with one narrow FLOOR:** *no quantity of his practice is shown, spoken or drawn* (`practiceSymbols`, `countIdentifiers`, no monotone function of a count reaching a view: `LawsTests.swift:1340`, `LawsDrawnMeasureTests:2123/:2150`). Numbers, ordinals, dates, timers, seat numbers, Design's figures and "again" become allowed. **Keep the verdict ban** (`PlayTests.swift:542`: well done, wrong, try again, fail, score, streak…) and **no red as failure** (`:520`), because those grade him. **Keep** the voice-quality half of `MandalaVoice` (identity said in words reads better to VoiceOver). That is accessibility craft, not a ban. |
| Returning-word ban | `RiteOfEnteringTests.swift:644` (welcome, return, back, again, before, "have been here", visit, remember, already, "last time", "once more"); `TheWayInUITests.swift:424` ("welcome back", "once more", "again", "you have been") | **Retire.** Homecoming already says "She will greet you again, as on the first day." (Settings baseline). |
| No images, the one-chevron pin, the five-verb binding condition, no solids in her layer | `LawsTests.swift:1741` (catalogue = AppIcon and AccentColor only); `:1787` (`pinnedDrawnLiterals {"chevron.right"}`); `:1867` (render path made of shapes); `RecognitionNatureTests.swift:299`; `PlayTests.swift:573`; `solidsInHerLayer == 0` in `HomeDescentTests.swift:203`, `RoomSceneTests`, `CrossingRoomTests`, `SiddhiRoomTests`, `MatrkaRoomTests`, `MudraRoomTests`, `BodilessRoomTests.swift:441`, `CosmicRoomTests.swift:576`, `GivingRoomTests`, `RevealingRoomTests`, `SoundingRoomTests`, `SourcingRoomTests`, `GateRoomTests.swift:126`, `DissolveRoomTests`, `RiteOfEnteringTests.swift:267/:822`; `WorldClimbTests` ("stone emission requires relief"); the five SurfaceVerbs | **Rewrite** to the floor only: **no figure of a Śakti**. That means figural vocabulary over asset names, node names and form names (`Aniconic.figuralVocabulary`, `HomeAttributeTests.swift:304`), plus a reviewed allow-list of image assets (textures, Design's renders, chakra art if he approves). Design's solids can return: the descent's torus knot, 13 boxes, icosahedron and three tori; the Giving ring's gift sprites; Rooms in 3D's cloth, RGB triple exposure and far-wall yantra. The aniconic check must then read node *kinds*, not count solids. |
| Mudrā body-word ban | `MudraRoomTests.swift` (hand, finger, thumb, palm, fist, knuckle, wrist, grip, clasp, limb, torso, womb, flesh not allowed in labels or forms) | **Retire.** Keep "no figure". |
| Iconography and the Codex Portrait off screens | `LawsTests.swift:1830` (`iconographicFields [iconography, codexPortrait]` never reach a render path) | **Retire.** The Detail already keeps an `iconographySection` behind "go deeper" (`TheLibraryFoldTests.swift:102`). Iconography *prose* is not a figure. |
| Gem never colours | `MandalaLightTests.swift:71` (no gemstone name in MandalaLight.swift; "topaz is not a hue the walker's light is allowed to come from") | **Retire.** The gem may colour. Keep `HomeWorlds` diffusion as behaviour. |
| A veil that cannot learn | `MandalaLightTests.swift:188` and `MandalaYantraTests.swift:277` (forbidden: felt, deepest, crossings, ActivityLedger, HomeMemory, visits, streak…) | **Rewrite.** The veil may know where he has been. The narrow floor stays: it may never become a completion meter (no fraction or percentage of rings shown, no monotone-with-count brightness). |
| Two-state seats | `MandalaLightTests.swift:143/:158/:506`; `LawsDrawnMeasureTests.swift:2123/:2150`; `SpikeCensusTests` (one glow per felt seat) | **Rewrite with care** (see C-9). Seats may carry several states (felt, written to, dwelt in, sealed letter waiting) but none may scale with a count. C-1284 "every light breathes the same, met or not" (`OneBuildingTests`) is his and stays. |
| Play keeps no store | `PlayTests.swift:559` | **Retire.** PlayGardenStore and PlayTraceStore already exist (`PlayWholeTests.swift:352`, `WaveSixMemoryTests`). Fold play stores into the "practice store contract" (B.2-10). |
| A room only behind the rite | `TheWayInTests.swift:142` ("a room may not be reached without the rite"); `:171` (every door passes the one threshold) | **Rewrite** so that every door to a room still goes through *one door type* (`HerRoomDoor`, which keeps the stay filed once and the memory read once), but the Rite of entering is offered, compressible and skippable. Keep `:62` (all 102 enterable), `:246` (the door asks only whether she has a room), `:226` (the edge is an equal way out) and `:753` (the stay filed exactly once). |
| A new day always opening on the Rite | the UI tests' default `START_TAB=rite`; `BinduMandalaUITests.swift` setUp; `RiteOpening.opens` (once per half day) | **Rewrite** to ruling 1: launch arrives at the Bindu and Today is the first door. Keep RiteOpening's dawn and dusk openings as an *offer* at the door. |
| Design's numbers as a ceiling | upper luminance bounds (`mean < .9`, `GarimaCanvasSpike mean < 175`); the withheld fifth (`HomeSoundTests`/`HomeMemoryTests.swift:89–122`, fifth withheld in rings 1–8 until a long stay or relationship) | Keep the blow-out guards. **Raise the floors to Design's** (see B.4). Treat the withheld fifth as gating: make it an *offer*. |
| Gating and locks | `HomeDescentTests.swift:327–339` (`DescentReach.shallow`: 3 stations until 62 s); `WaveSixMemoryTests.swift:371` (HerDeepening: one layer per return); `HomeMemoryTests.swift:89–122` (fifth); `TheWayInUITests` (no way out at the threshold); `ChakraConstellation` crossings | **Rewrite.** Deepening is *offered* and never withheld. Every layer has a direct door as well as the slow one. **Keep his own rulings** (Leela gap, dissolutions once a day). They are not "gating" in the lifted sense. |
| The composition lock | `FeltRegisterSnapshots.swift:449` (already demoted, `:525`); `FeltRegisterClassifications.swift` (all); `TheLibraryFoldUITests.swift:438–:507` (`TheFoldVocabularyTests`); `TheLibraryFoldTests.swift:226` ("nothing that stays out moves"); `HitAreaIdiomTests.swift:220`; `TheMarginUITests.swift:232`; the 30 `.geom` baselines | **Retire as gates.** **Reuse the engine** (ScreenReader, the `.geom` format, displacement metric, `EPHEMERAL_STORE`, `ENERGY_POS` pinning) for the automated walk and geometry parity (B.3, B.4). |

**FLOORS: keep these tests, and strengthen where marked.**

| floor | tests that hold it | strengthen |
|---|---|---|
| Practice data never lost or duplicated | `ActivityLedgerTests`, `RecognitionDedupTests`, `RecognitionMigratorTests`, `PendingQueuePolicyTests`, `SchemaMigrationTests`, `LetterMigrationTests`, `LetterDraftTests`, `MarginTests`, `LawsTheMarginTests` (data half), `SilenceDwellTests`, `DescentMirrorTests`, `HomeDwellingTests`, `HomeMemoryTests` (store), `WaveSixMemoryTests` (stores), `TheRiverTests` (kept), `LivingMandalaTests` (strokes), `ModesAndRitesTests` (witness), `PlayWholeTests.swift:352`, `EphemeralStoreTests`, `TheMarginUITests` (:115, :193, :303), `RecognitionNatureTests` ("written before any light moves") | Every new world's model arrives as **schema V4+**, never by mutating V3 (`SchemaMigrationTests.swift:145`). Add one shared **PracticeStoreContract** test that every store must pass: write before motion, survive a kill, never overwrite, ledger once, restore idempotent. |
| Position is identity | `LawsTests.swift:1570–1641`, `KhadgamalaMapTests`, `SeatLightingTests`, `MandalaWorldTests`, `MandalaLightTests.swift:122` (102 distinct colours), `WholeInstrumentTests`, `HomesHarnessTests` (kp 99 name collision), `GateRoomTests` (61 of 102 names drifted, so position is the key), `PlayTests.swift:23–64`, `ChakraConstellationTests` | Extend to every world's deep link: world routes take kp 1–102 or chakra 1–33, never names. |
| App Activity is the single ledger | `LawsTests.swift:1915–2022`, `ActivityLedgerTests`, `PlayTests.swift:412`, `ModesAndRitesTests.swift:288`, `TheRiverTests.swift:202`, `ChakraRoomTests` ("Chakra Practiced"), `OneBuildingTests` (State Set Down, Siddhi Received, Silence Held), `HomeDwellingTests`, `GameStructureTests.swift:157`, `WaveSixMemoryTests` (Codex) | Every new world event type is added to `LedgerIsTheRecord.eventVocabulary` and nowhere else. |
| The two Recognition lines verbatim | `LawsTests.swift:1453/:1483/:1540`, `BinduMandalaUITests.swift:38`, `AccessibilityReachTests.swift:481`, `RecognitionNatureTests` timeline | Keep unchanged. |
| No generated voice | **No test exists.** `HomeSound` synthesises tones, not voice. `MandalaVoice` only feeds VoiceOver labels. `CorrespondenceStore` keeps *his* voice files. | **Add**: no `AVSpeechSynthesizer`/TTS API anywhere in production. |
| Nothing invented (bījas, baked words verbatim) | `ShaktiBijaTests`, `RiteCompositionTests.swift:41`, `HomeDescentTests` (empty is never invented), `ModesAndRitesTests.swift:211` (Carry nil), `SomaticRegionTests.swift:64`, `RecognitionMigratorTests.swift:34`, `HomesCorpus` provenance, `EphemerisTests` (published values), `ChakraRoomTests` verbatim, `GameStructureTests` bake, `PlayTests` seats read off the table | Add a verbatim check for every bake against its Airtable export date. |
| His journals and letters private | `CoherenceTests.swift:106` (GratitudeGrace names one table and one field, fetch only); `ci_post_clone.sh` (PAT never echoed); `ModesAndRitesTests` LowStateDoor (his words only, never a prompt) | **Add**: `AirtableService` may read only an allow-list of tables. Emotions, SJ, Anger, Health and the rest stay unread unless he opens one. |
| No figure of a Śakti | `Aniconic` figural vocabulary (`LawsTests.swift:856`), `HomeAttributeTests.swift:304`, `RoomSceneTests` (no figural node), `RecognitionNatureTests.swift:299`, `PlayTests.swift:573` | Rewrite as above (B.1, images row). |
| Nothing scores him; absence is never a debt | `LawsTests.swift:1340`, `LawsDrawnMeasureTests`, `OneBuildingTests` C-1284, `RiteDayTests.swift:148` ("Nothing was asked of you today."), `PlayTests.swift:520/:542`, `TheRiverTests.swift:150` (Wager), `ModesAndRitesTests.swift:104` (Smṛti: one light), `RiteDayTests.swift:116` (grace never of today), `GameStructureTests.swift:232` (ThreePools: state, not tally), `TheLibraryFoldTests.swift:152` (her screen writes nothing about him) | Keep. This is the narrowed replacement for the measuring ban. |
| Accessibility | `LegibilityTests`, `DynamicTypeTests`, `HitAreaIdiomTests` (44 pt half), `HitAreaTests`, `AccessibilityReachTests`, `MandalaVoiceTests`, `DeviceSlipTests` (reduce motion), every room's reduce-motion test, `TheMarginUITests.swift:350`, `TheLibraryFoldUITests.swift:370` | Run the a11y floors **per world** inside the automated walk (B.3), not per screen file. |
| Ruling: Leela drops ≥3 days apart, then 30 % | `GameStructureTests.swift:115–146` (asserts `≥ minimumGapDays` and "only by chance") | **Pin the constants**: `minimumGapDays == 3`, drop probability `== 0.30`. Neither number is asserted today. |
| Ruling: dissolutions once a day | **No test.** `TreeOfLife.dissolutions` is tested only for content (`GameStructureTests.swift:104`). | **Add.** |
| Ruling: Homecoming each launch | **No test.** Every UI test passes `SKIP_HOMECOMING`. `RiteDayTests` covers HomecomingScore only. | **Add** a UI test: three cold launches, three Homecomings. |
| Ruling: Rām japa at kp 42 | `CoherenceTests.swift:90`, `PlayTests.swift:51/:80`, `ChakraRoomTests` (road 5) | Keep. |
| Ruling: gratitude gently | `CoherenceTests.swift:106–157` | Keep. |
| Ruling 2: Ego Reveal sealed | `GameStructureTests.swift:43–46` (never a Leela drop); `ChakraConstellationTests` (Sanskrit nil) | **Add**: chakra 32's words are never in the accessibility tree on any route. `shadowTranslator` sits at "The Map: Ego Reveal" (kp 101, `PlayTests.swift:48`), so check its words. |
| Ruling 9: deep zoom into the Bindu | `MandalaCameraTests` (`descentTarget` 5.4), `OneBuildingTests.swift:415` (Pravesha never reaches a bottom) | Keep. |

### B.2 New tests the fifteen-world foundation needs

1. **World Registry is whole.** There is one `World` enum with exactly the fifteen: Home, Today/Rite, Mandala (+Veil), the nine rings, Her Home, Her Presence, Climb (Axis), the 33, A Strange Game (+ every game as a sub-world), Modes, Time, Memory, the Well, Beneath, the Relationship Field. Each has an accessibility sentinel `world.<id>`, a title, its threads (kp, chakra, day) and an `OPEN_WORLD=<id>` launch argument. Assert count, names and that each sentinel is unique.
2. **Reachability matrix: every world by every route.** A model-level `WorldGraph` test covering each world × each route:
   - routes: the point (home), the menu (full index), the thread doors (kp 1–102 → Her Home and Her Presence; chakra 1–33 → its room; the day → Today/Time), search, the Veil, the gestures (vertical drag climbs, tilt Mandala↔Climb, left edge out, the Codex gestures, the die), back, and crossings through the point;
   - assertions: a route exists; it is at most N touches; it never passes through a lock.

   This generalises `TheWayInTests.swift:62/:171/:502` (all 102 enterable; every door through one threshold; Climb reachable) and `PlayTests.swift:99` (every one of the 102 has a play door).
3. **UI reachability.** For each world, from a cold launch: menu → world → sentinel hittable → back → Bindu. Then the same via search, and via the thread doors where they exist. Uses `press(until:)`.
4. **Nothing laid over another world.** At every walk step exactly **one** `world.*` sentinel is in the hit-testable tree. No `.sheet`, `.fullScreenCover` or `.overlay` presents one world's root view over another's (source scan in the `LawsTests` style). Evidence it is needed: the committed `settings.geom` reads "Your Letters to Them", because the Settings sheet was captured over the Well (§A.2).
5. **Back-to-where-you-were.** A navigation-history model test (A → B → C, back → B → A, across crossings through the point, across background and relaunch). UI: generalise `TheWayInUITests.swift:134` (room → back on her Detail with the door and phonetic) and `:249` (Climb → back on the Field) to every world pair.
6. **The point everywhere.** On every world a `point.home` element is present, hittable at ≥44 pt and in the same screen place (± tolerance). Tapping it returns to the Bindu (or crosses through it). This needs a reduce-motion variant and a VoiceOver label. Note that at Home itself the gentle tap opens silence (`OneBuildingTests`, 12 Oct), which is a different behaviour that needs its own rule (C-25).
7. **Launch arrives at the Bindu, and Today is the first door** (ruling 1). A cold launch with no `START_TAB` → `world.home`; the first door in reading order is Today. Combine with the Homecoming-each-launch test.
8. **Ruling tests**:
   - dissolutions once per practice day (06:00 boundary, `DailyEnergyServiceTests`);
   - Leela constants pinned (3 days, 30 %);
   - chakra 32's words never rendered;
   - **Axis = chakra 18, Crow = chakra 19**;
   - **elements Ahaṅ fire, Nāma air, Ātma light, Amṛta water**, checked through `Element`, `RecognitionNature` and the room physics (C-7);
   - Maya's last line exactly "only You, playing";
   - the 16 Karṣiṇī Functions present for kp 29–44 (`HerWitnessPage.page(function:)`);
   - the dance names every archetype (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey, Lalita…);
   - deep zoom kept.
9. **The Relationship Field is built in full.** Model and migration tests (V4) that carry the existing FIELD CONNECTIONS names forward from Settings ("She anchors here.", "She weaves through here.", "Holds her frequency."), keyed by position, private, ledgered once.
10. **PracticeStoreContract** (B.1, floors): one parametrised suite run over every store.
11. **Sound mixing law** (replaces one-bed; see B.1).
12. **Search.** Every Śakti is found by Sanskrit, romanised or phonetic name (reuse `MandalaVoice.romanised`, which folds diacritics including decomposed forms, `MandalaVoiceTests.swift:378`), and so is every chakra, game and world. The result opens by position.
13. **Design parity** (B.4).
14. **Performance per world.** Reuse `SpikeMetrics`/`SpikeCensus` per world, and add cold launch → Bindu first frame (re-aim `SpikeColdLaunchTests`).
15. **No generated voice; Airtable read allow-list** (B.1, floors).

### B.3 Turning the UI tests into the "automated walk"

The pieces already exist and only need composing:

- **The driver.** `TheWayInUITests.swift:134` already does a real walk: cold launch → door → threshold → room → hold out → back where he started → second, compressed crossing. Its patterns are proven against the digitizer-cancel flake: `press(until:)`, "sentinel only on the destination", `withdraw`-labelled exits, and drag-to-rise at 0.66 → 0.18.
- **The state.** `EPHEMERAL_STORE` (an empty, DEBUG-only, in-memory store that never touches disk), `ENERGY_POS` (last one wins), `SKIP_*`, `AUTO_RECOGNIZE`, `REDUCE_MOTION`. Add `OPEN_WORLD=<id>`, `WALK_SEED=<n>` and a **`FIXTURE_STORE=full`** that seeds all 102 rows and all 33 chakras from bundled read-only copies. Today `SYNC_OFF` seeds only the sixteen, so 86 of 102 rooms and every game seat outside Ring 2 are unreachable from a UI test (C-4).
- **The script.** A walk is a list of steps `(route, from world, to world, expectations)`, generated from the `WorldGraph` (B.2-2) plus the *Neev walk* he did on 12 Oct as a hand-written canonical route: launch → Bindu → Today → Rite → her Presence → her Home (with and without the rite) → out by the edge → Mandala → Veil → ring 4 → a seat → Climb → the 33 → a chakra room → its game → Lalitā's field → Leela → Modes → Time → Memory → Well (seal a letter) → Beneath → Relationship Field → point → Bindu.
- **The checks at every step**:
  - the destination sentinel is present and only one world is hittable (B.2-4);
  - the point is present (B.2-6);
  - every control is ≥44 pt (`HitAreaTests` logic);
  - no string is clipped at AX3XL (`DynamicTypeReachTests` logic);
  - the spoken labels are named and say no measure of him (`MandalaVoice` and `AccessibilityReach` logic);
  - back returns to the previous world.
- **The record.** At every step: a screenshot (attach `keepAlways` as FIDELITY rule 7 already does), plus a `.geom` geometry dump with the `FeltRegisterSnapshots` ScreenReader. SceneKit and Metal worlds must be photographed with `xcrun simctl io booted screenshot` or `SCNView.snapshot()`, because `drawHierarchy` cannot see a `CAMetalLayer` (finding in `SpikeGarimaSceneKitTests.swift`, `test4RoomStatesForCapture`). Use the `.holding` marker-file handshake that test invented.
- **The matrix.** Run on 3 device classes (se 375, phone 402, promax 440, the classes `FeltRegisterSnapshots` already defines), plus AX3XL, plus reduce motion. Run nightly on Xcode Cloud. `SourceTree` already bundles the repo, so the walk can also read Design's frames.
- **The output.** A walk report: an HTML artifact with one row per step (Design frame | app screenshot | geometry diff | a11y verdicts). It becomes the evidence Ashrey reviews instead of a manual walk, and it replaces "Nobody is going to look at these screens before they ship" (`FeltRegisterSnapshots`).

### B.4 Turning snapshot baselines into Design-frame parity checks

The lock was retired with the explicit promise that "a visual-fidelity check against Design's frames replaces the lock" (`FeltRegisterSnapshots.swift:525–530`). That check was never built, and the foundation names its absence as root cause 4. Parity can be built in three layers, each from parts that already exist:

1. **Numbers parity, read from Design's own files.** `WorldClimbTests` already reads `homes-worlds.js` and "The Homes - The Axis.html" off disk and asserts the Swift constants *are* the JS expressions (`:54–:125`). `SourceTree` bundles `Claude Design Round 2/homes` into CI. Extend that pattern to every export. Today `DayLightTests`, `MandalaYantraTests`, `RecognitionNatureTests`, `HomeSoundTests`, `HomeAttributeTests`, `HomeDescentTests`, `HomeMemoryTests` and `HomeGrammarTests` **retype** Design's numbers into the test, so a Design revision cannot be caught. Switch them to parse the source literal: `LR_RECOG`, `lrResp…`, `LrSigil`, `lrBackdrop`, `syShimmer`/`syBinduBreath`, `RING_CHARACTER`, `FORMS`, `STATION_Z`, the `homes-sound.js` tables and the arrival beats. Drift is then caught in both directions.
2. **Geometry parity.** Run each Design frame (the 40 frames from the first reading) headless at the three widths and walk the DOM, printing `role|text|x|y|w|h`. That is **the same `.geom` format** the baselines use. Compare it with the app's accessibility geometry using `FeltRegisterSnapshots`' normaliser (digits → `#`, time → `~`) and displacement metric (min anchor travel, ¼ pt rounding). Allowed differences are recorded with reasons, the way `FeltRegisterClassifications` did. That file's `ClassifiedShift` type is the right shape for a *parity* exemption ledger once it is retargeted from "unchanged since main" to "matches Design".
3. **Light parity.** Render Design's frame (WebGL `gl.readPixels`, which is how Design verified the rooms: "Garimā at 13→204 with a real shadow band", `GarimaCanvasSpikeTests.swift:155`) and the app's screenshot. Compare a 64×64 Rec.709 luminance grid (the helpers exist in `WorldClimbCaptureTests`, `GateLookTests` and `SpikeGarimaSceneKitTests`) by region mean, min/max and histogram. Assert the app sits *within Design's band*, not merely "not black, not blown out". The current bounds (mean .01–.9, spread >.02) admit the audited 11–65/255 rooms against Design's 80–255 (C-3). Add Design's own invariants as per-room tests: "always visibly changed" (`GateLookTests`: >20 % of the grid moved between adaptations), "the near half does not run away with the light" (ratio <3.5), and sister divergence >0.1 (`OuterRingFingerprint`).

Timing parity follows the same path: Design's keyframe tables (nine arrival beats, the Recognition timeline, the Homecoming score) are read from the Design file and compared with the Swift constants. A screen-recording diff on the walk can follow later.

### B.5 Gifts: every element in the tests that could enrich the app

*Energy* means a living mechanism for the app. *Story* means narrative material; per ruling 5 it is valuable but may belong in **Bindu Feed**, so it is flagged, not dropped.

| # | what it is | source (file:line) | world(s) | how it would work there | what it needs | energy / story |
|---|---|---|---|---|---|---|
| 1 | **The nine worlds' character table**: yoginī, phase, veil, mental state, tempo, verb (AGITATE … ARRIVE), ring bīja | `HomeWorldsTests.swift:27` (`testRingCharacterExactValues`) | the nine rings; Climb | Each ring-world takes its tempo, fog density, verb-physics and bīja from this one table. The Veil reads `veil` (0 → 1). | Already in `HomeWorlds.swift` | energy |
| 2 | **The nine WORLDS**: gem, dhātu, clock (day–night → kāla–akāla), body region, fog colour and density | `HomeWorldsTests.swift:98` | nine rings, Time, Climb | Each ring has its own clock speed (r1 day … r8 year), its own fog colour (#1d1206 … #141008) and its own gem diffusion. | exists | energy |
| 3 | **Ring clocks and Axis physics read from Design** (`t×0.05`, `t×1.05`, fortnight `sin(t×0.0398)`, moon .0199, season .0066, half-year .0033, year `t×0.062`, yantra `t×0.008` with breath `.9+.16·sin(t×.13)`; climb settle .06 / .035 reduced, rise 3.4, fog ×(1+swallow×1.6)) | `WorldClimbTests.swift:54–:125`, `:979` | Climb (Axis); Time | The Climb's motion law, with a template for reading every Design constant from source. | Design files bundled (already) | energy |
| 4 | **The empty summit**: "I am what I am becoming." / "I already did." (C-1260) | `WorldClimbTests.swift:774–789` | Climb summit; Home | At the top of the Axis nothing is shown except his line. | exists | energy (his words) |
| 5 | **ClimbLights: 102 presences, all breathing alike, met or not** (C-1284); ring 3 scatters at touch, ring 8 gathers 99–101, ring 6 whispers ("made of knowing") | `OneBuildingTests.swift:82`, `:100` | Climb; Mandala | The seats as lights on the terraces, with per-ring touch mechanisms. | exists | energy |
| 6 | **TheGates**: the inward gate is an offering (State Set Down "…offered"), the outward gate receives a siddhi (C-1230) | `OneBuildingTests.swift:199` | Climb membranes; Beneath | Each gate is a two-way exchange that only ever gains. | exists | energy |
| 7 | **Mauna and CentreArrival**: a silence held at kp 102 after 7 s; depth follows steadiness, not a clock (C-1355); arriving takes one breath (C-1307); the point opens only after he rests in the recognition | `OneBuildingTests.swift:243`, `:265`, `:309`, `:350` | Home (Bindu); Modes (Mauna) | The Bindu world's stillness gate. | exists | energy |
| 8 | **"Who is saying that?"** (C-1305) | `OneBuildingTests.swift:302` | Beneath; Home | A witness line that appears on stillness. | exists | energy |
| 9 | **Pointy**: 102 particles go line → circle → ∞ → heart (C-1306) | `OneBuildingTests.swift:366` | Home; the 33 (the story told by a moving point) | The moving point that tells the 33's braid. | exists | energy |
| 10 | **CentreBloom**: the yantra draws outward from the point (trikoṇa → triangles → lotus8 → lotus16 → bhūpura → names, scale .05 → 1, hold to open) | `OneBuildingTests.swift:393` | Home → Mandala crossing | The crossing through the point unfolds the yantra. | exists | energy |
| 11 | **Pravesha**: an endless fall that never reaches a bottom, at Shepard speed | `OneBuildingTests.swift:415` | Home; deep zoom (ruling 9) | Deep zoom into the Bindu. | exists | energy |
| 12 | **RingFieldVoice**: every place has a voice, the Vāk chord of 12, a sourceless root 136.1, the point silent | `OneBuildingTests.swift:434` | all ring worlds | Ambient voices per world (no longer one at a time). | exists | energy |
| 13 | **The full sound table**: roots [55 … 123.47] Hz, varṇa 49, JUST 12, techniques per ring (drone, breath, stepped, *witness* partials 2/3/5, *triad* 1/1.26/1.5, *Shepard* 5 voices), carrier from the bīja syllable | `HomeSoundTests.swift:21`, `:34`, `:90`, `:293`, `:365`, `:418` | Her Home; the rings; Climb | Every room and world sounds its own ring technique, tuned by her bīja. | exists | energy |
| 14 | **The Om 136.1 Hz floor** (partials 272.2, 68.05); **TheBells** open at 272.2 and close at 136.1, once a day | `GameStructureTests.swift:95`, `:302` | Home; Today | The day opens with a bell and closes with one; the Om is under everything. | exists | energy |
| 15 | **The falling mantra**: RingBija syllables sounded on the descent at 528 × 0.917^(ring−1) Hz, the interval from the vowel | `MandalaLightTests.swift:333–:418` | Mandala deep zoom; Beneath | A crossing inward sounds each enclosure's bīja. | exists | energy |
| 16 | **Awakening tones** 174 (ring 1) … 341 (ring 4) … 528 (ring 8); the Bindu is silence | `PlayTests.swift:381` | A Strange Game (bījaTones); rings | A tuning game per ring. | exists | energy |
| 17 | **One light from the Bindu, nine refractions**: gem diffusion bends it, never past halfway; Tratak earned by stillness (>10 s) | `MandalaLightTests.swift:31`, `:85`, `:300` | Mandala; Veil | The held yantra lit from its centre; a steady gaze brings Tratak. | exists (now the gem may colour too) | energy |
| 18 | **MandalaYantra at Design's true weights**: .585R triangles, lotus radii, alphas, the nine breaths 3/8/9/11/13/15/18/4 s, shimmer .82↔1 over 8 s, bindu ×1.28 over 4 s, new moon desaturating to .30 with bindu 1.6 | `MandalaYantraTests.swift:22–:206` | Mandala; Time (new moon) | The held yantra breathes ring by ring and changes with the moon. | exists | energy |
| 19 | **The Veil's five lights**: here, ground, open, ahead, veiled, read from where he stands | `MandalaYantraTests.swift:239–:270` | Veil (the index) | The Veil as a light map of the nine; it may now also learn (lifted). | exists | energy |
| 20 | **DayLight**: the Rite's sigil per ring geometry, the nine arrival beats, `lrBackdrop` per element, hour tints, the "I feel her" pill carrying a third of her hue | `DayLightTests.swift:17–:315` | Today / the Rite; Her Presence | The Rite composes by element (ascension, descent, horizon, veil, foundation, radiance) with Design's light. | exists | energy |
| 21 | **Recognition's six natures** (flare, pool, disperse, bloom, settle, radiate) with keyframes, ripples, motes, haptics and the five-beat timeline | `RecognitionNatureTests.swift:77–:216` | Her Presence; Recognition everywhere | Each element answers the recognition in its own way; "and she felt you back" lands in stillness. | exists | energy |
| 22 | **102 rooms by position**: Design's 8 authored rooms (kp 1, 2, 3, 4, 6, 27, 28, 102) and 94 grammar rooms, each with its own mechanism and sister divergence >0.1 | `WholeInstrumentTests.swift:88–:200` | Her Home ×102 | Every seat opens her own mechanism room. | Exists. The light needs raising to Design's band (C-3). | energy |
| 23 | **Ring archetype rooms**: Crossing (r2 halves become one), Bodiless (r3 effects around an absence), Cosmic (r4 a coil of 14 shells), Giving (r5 12 gifts to a landing), Revealing (r6 truths under a veil), Sounding (r7 standing waves), Sourcing (r8 Icchā/Kriyā/Jñāna corners), Dissolve (kp 102: 99 marks and a source) | the ring suites (A.4) | Her Home; nine rings | Each ring world's rooms share an archetype and differ by her physics. | exists | energy |
| 24 | **The room reversal lines**: "the weight was holding you all along", "the giving and the given are one", "it was never hidden · you were the veil", "body and mind were one point", "no door · you were always inside", "three rooms · one seal, only in stillness", "a light you are inside is not a light you see" | `HomesWaveOneTests.swift:229`, `HomeGrammarTests.swift:470/:505`, `RevealingRoomTests.swift:122`, `MudraRoomTests.swift:11–12`, `DissolveRoomTests` | Her Home | Each room's deep line arrives at the second adaptation. | exists | energy (short and experiential; not narrative) |
| 25 | **HomeAfterEffect**: her siddhi lingers on the instrument for 180 s after the room (sharper, wider, lighter, heavier…), "her siddhi is still on the instrument" | `HomesWaveOneTests.swift:272` | every world after Her Home | Leaving a room changes the whole instrument briefly. | exists | energy |
| 26 | **26 attribute forms and 15 tints** acting in her room (noose, goad, cup, arrows, bow, mirror, lotus, flame, rosary, trident, vajra, shell…) | `HomeAttributeTests.swift:24`, `:102` | Her Home | Her āyudha acts as an object in the room. It is not a figure. | exists | energy |
| 27 | **The descent beneath her room**: 5 stations, 46 rims, roots from etymology, a glissando of minor thirds, DescentWords from her five fields; Design's solids may return | `HomeDescentTests.swift:95`, `:232`, `:362` | Beneath | Going under her room through her own words. | exists (lift "no solid") | energy |
| 28 | **The Rite of entering**: her name in three strokes, roots that part and rejoin, appreciation phrase, Devanāgarī, compression over returns | `RiteOfEnteringTests.swift:369`, `:411`, `:544` | Her Home threshold | The threshold rite, now optional. | exists | energy |
| 29 | **HomeMemory**: compression 1 → .68 → .4624, head start ×0.55, the fifth granted by a long stay or relationship | `HomeMemoryTests.swift:17–:122` | Her Home; Memory | Rooms remember him gently. Make the fifth an offer, not a lock. | exists | energy |
| 30 | **The Gate rooms** Laghimā / Garimā: "the weight was never above you. It is what you are standing on…" | `GateRoomTests.swift` | Her Home (Ring 1); the foundation's base Gates | The pair of opposite rooms at the base of the Meru. | exists | energy |
| 31 | **GateLook / Design legibility register** ("always visibly changed", near-half wash guard) | `GateLookTests.swift:53` | all rooms (as a test) | A per-room parity test. | exists | tool |
| 32 | **The 33 bake**: Core Question, Signature Phrase, Practice Prompt, Three Ways In, Practice Gate (Sound Response, Tap Rhythm, "I feel the ground", "Stand up."), Bindu Reflection, Witness Perspective, Writing Prompt, Mirror Frequency | `ChakraRoomTests.swift:57–:128` | the 33 (practice, wake-up, gate) | Each chakra room has its practice, its gate and its doorway to its Śakti seat. | `Data/ChakraConstellation.json` | energy (practice columns) |
| 33 | **The 33's story columns**: Story Thread, Leela Story, Act 1/2 Voice, the Shadow reveal "home / come / please / back", "please come back home." | `ChakraRoomTests.swift` | the 33 (story told by a moving point) | The braid's story, told by the moving point. | bake | **story → Bindu Feed candidate**: narrative arcs per chakra, voiced acts |
| 34 | **ChakraMovement by road**: euphoriaPulse [13, 14], hamHetHum [6, 15, 16] (HAM receive, HET hold, HUM transmit), roarAndSilence, fearInWaves [2], restlessness [19], heartHome [5], lastMemories [17], feelingThrough [10] | `ChakraRoomTests.swift:202` | the 33 (dance, wake-up) | Body movements as the chakra's energy; feeds the dance. | exists | energy |
| 35 | **The road of 33**: begins and ends at the point, out to the Bhūpura, spiralling home, a longer dwell at Shadow; sections energy / body / mind / summit | `ChakraConstellationTests.swift:59`, `:72`, `:199` | the 33; Mandala | The 33 placed on the terraces (canon B). | exists | energy |
| 36 | **36 games addressed to seats** (PlayAddressBook; every one of the 102 has a play door, her bead in the rosary otherwise) | `PlayTests.swift:23–:118` | A Strange Game; Her Home | Each Leela landing opens the chakra's energy; each game is its own world. | exists | energy |
| 37 | **C-1357 game physics**: force absorbed, never corrected; hurry takes nothing back; the drum on the beat; roots from stillness; the door opens to a light hold | `PlayTests.swift:160–:403` | A Strange Game | Every game is felt physics, never a verdict. | exists | energy |
| 38 | **Leela board**: six to be born; arrows and snakes 5→8, 12→18, 15→6; an exact landing; "the road ends at the point it began" | `PlayWholeTests.swift:199` | A Strange Game (Leela) | Board movement. Each landing opens the chakra room (ruling 5). | exists | energy (the board); drop *texts* are story-adjacent |
| 39 | **Seed growth in real time** (sprout 3 h … bloom 80 h), the Twelve as a circle of fifths 272.2–544.4 Hz, JapaMala 108 beads one per breath, Ārati sunwise, GreatWheel with today at the point | `PlayWholeTests.swift:26`, `:47`, `:254`, `:272`, `:322` | A Strange Game; Time | Games that live in real time. | exists | energy |
| 40 | **ScrollUnroll** of 12 lines ending "You are a bigger container now." | `PlayWholeTests.swift:159` | A Strange Game | A reading game. | exists | **story-leaning → Bindu Feed candidate** (a 12-line text) |
| 41 | **Tree of Life**: rings 1–5 answer to a press, 6–8 to stillness, 9 to nothing; guide words thin to 0; luminance .05 → 1; Panel 9 undoes the eight dissolutions and names nothing: "Now go play." | `GameStructureTests.swift:51–:111` | A Strange Game; Home (Panel 9); Lalitā's field | The nine-panel climb into play; dissolutions once a day (ruling). | `Data/GameStructure.json` | energy |
| 42 | **TrinityOfGuidance faces**: Gaia at kp 31, Higher Self at kp 42, Bindu at climb 1, Lalitā at climb 9, Sākṣī at descent 7, each once a day | `GameStructureTests.swift:175–:198` | Her Home; Climb; Beneath | Guide faces appear at their places. They feed the dance's archetypes (ruling 6). | exists | energy (one line each) |
| 43 | **ThreePools**: being (refreshes daily), memory, essence; which surface each ledger type feeds (Played → memory; Letter Sealed and Leela Drop → Well; Shakti Recognized → Portrait) | `GameStructureTests.swift:232` | Memory; Well; Her Presence | Routes every act to the world that remembers it. | exists | energy |
| 44 | **The Modes**: Darśana (stillness-deepened), Sādhana (the garland in 28 min, ring by ring inward), Smṛti (each felt seat one light; days as constellations), Svapna ("The night was still."), Pūjā ("The day is received." / "Tomorrow opens again."), Mauna | `ModesAndRitesTests.swift:41–:149` | the Modes | Each mode is its own world, offered at its hour (dawn svapna, dusk pūjā) and open at any hour. | exists | energy |
| 45 | **RiteOpening and RiteStation**: "Stop. Breathe. Remember." (C-1303), the Sacred Pause of three breaths, Śṛṣṭi/Saṃhāra, the six stations Arrival → Carry | `ModesAndRitesTests.swift:171`, `:211` | Today / the Rite | The structure of the Rite. | exists | energy |
| 46 | **LowStateDoor**: in a low state only his own words come back, never a prompt (C-1002/C-1120) | `ModesAndRitesTests.swift:231` | Today; Memory | A door for hard days. | his writings (private) | energy |
| 47 | **Witness pages, Garland Recited, Day Offered** | `ModesAndRitesTests.swift:268–:329` | Her Presence; Modes; Memory | Writing beside her page; reciting; offering the day. | exists | energy |
| 48 | **RiteDay floor**: "Blink. Breathe. Press." → "That was a full day of walking. Everything else today is extra." | `RiteDayTests.swift:42` | Today | The one-second day. | exists | energy |
| 49 | **GraceChannel**: a past moment returned in words, her room first ("Three nights ago, you kept a silence with …"; "A moon ago"), including **sister apps** ("you finished a door in your reading") | `RiteDayTests.swift:57–:128`; `WaveSixMemoryTests.swift:353` | Her Home; Memory; Relationship Field | Cross-app memory spoken once, then rests. | App Activity rows from other apps | energy |
| 50 | **SakshiClose**: the day witnessed without counting; "Nothing was asked of you today." / "It trusts you." | `RiteDayTests.swift:132–:154` | Today (close); Memory | The evening close. | exists | energy |
| 51 | **HomecomingScore**: the yantra draws outward from the point inside one 4 s breath, a blink, 90 motes | `RiteDayTests.swift:158–:195` | Home (each launch, ruling) | The launch arrival into the Bindu. | exists | energy |
| 52 | **Gratitude, gently**: one column of his own words, room-matched, about one day in three, never repeated | `CoherenceTests.swift:106–:157` | Her Home; Today | His gratitude returns where it fits. | Gratitude table (read only) | energy |
| 53 | **The River**: letters sealed to a real-moon day (Pūrṇimā at 168°, Amāvasyā, her day, tithi returns), no peek; letters sent back to a past moment; pages yellow with real time; recipients age / pastSelf / laterSelf / memory / her; voice letters | `TheRiverTests.swift:33–:141`; `WaveSixMemoryTests.swift:122` | the Well; Time; Memory | The Well as a river of letters through time. | exists | energy (his writing is private) |
| 54 | **The Wager**: she might appear today; he may notice her in passing, once a day, and nothing is placed (C-1195) | `TheRiverTests.swift:150` | Her Presence; Today | A gentle "noticed her" door. | exists | energy |
| 55 | **Panchāṅga engine verified against USNO**: tithi, nakṣatra, Lahiri ayanāṁśa, ṛtu, ayana, sun rāśi, sandhyās, sunrise/noon/sunset at home, the **five clocks** | `EphemerisTests.swift:45–:197` | Time; Today; the Well (moon openings) | The Time world reads the real sky. | exists | energy |
| 56 | **Practice day at 06:00**, all 102 once per shuffled cycle | `DailyEnergyServiceTests.swift:22`, `:64` | Today; Time | Today's Śakti. | exists | energy |
| 57 | **EnergyGift**: one random gift a day inside his window, deterministic per day | `EnergyGiftTests.swift:19` | Today | A surprise notification of a Śakti. | exists | energy |
| 58 | **The Living Mandala Portrait**: n-fold mirror per ring (28, 16, 8, 14, 10, 10, 12, 3, 1), a year ring of beads at each practised day's own angle (C-1348), strokes as practice data, a StillnessSensor | `LivingMandalaTests.swift:20–:178` | Her Presence (portrait); Memory; Time (year ring) | He draws in her symmetry; the year accretes with gaps kept. | exists | energy |
| 59 | **MonthReading**: a glyph per day walked, embers for sealed letters, "A quiet month. Quiet is not empty." | `WaveSixMemoryTests.swift:392–:421` | Memory; Time | The month witnessed. | exists | energy |
| 60 | **HerDeepening layers**: "what she does", "what her ring gives", "how she is known", "her enclosure" | `WaveSixMemoryTests.swift:371` | Her Presence | Layers of her, now offered freely (gating lifted). | exists | energy |
| 61 | **Somatic body map**: 18+ regions with anchors; her `bodilyLocation` lights the place; sensory doorways by tattva (breath, heat, water, earth, space) | `SomaticRegionTests.swift:13–:70`; `HomeGrammarTests` zone altitudes | Her Presence; the 33 (body chakras); Relationship Field | A body map where each Śakti lands. | exists | energy |
| 62 | **The ledger's own vocabulary**: "Fell inward to the Bindu", "Dwelt past the first adaptation", "Left in the instrument", "The whole garland", "She appeared" | `ActivityLedgerTests.swift:127`; `ModesAndRitesTests.swift:305`; `TheRiverTests.swift:227` | Memory (sky of the record) | The record read back as a sky of acts in his words. | App Activity | energy |
| 63 | **MandalaVoice**: every seat said in words ("Second enclosure… thirty-third of the one hundred and two"), and **romanisation that folds every diacritic** (also usable for search) | `MandalaVoiceTests.swift:223`, `:369`, `:378` | all worlds (a11y); search | VoiceOver everywhere; diacritic-insensitive search. | exists | tool |
| 64 | **The Margin**: leave a note from anywhere; never lost; ledgered once ("A note left in the instrument") | `MarginTests.swift`; `TheMarginUITests.swift` | everywhere (a feedback channel to Claude/build) | A note button available in every world. | exists | tool |
| 65 | **Settings' remembered words**: "Once a day, never twice…"; THE WAY BEHIND "Each ring you have crossed, opening one by one."; HOMECOMING "She will greet you again, as on the first day."; FIELD CONNECTIONS names | `SnapshotBaselines/*/settings.geom` | Relationship Field; Climb; Home | Seeds for the Relationship Field and for "the way behind" as a world feature. | exists | energy |
| 66 | **G5 performance census and the renderer spikes** (Canvas vs SceneKit: one shadow-casting light, >15k triangles, still path <4 ms) | `SpikeCensusTests.swift`; `SpikeGarimaSceneKitTests.swift`; `GarimaCanvasSpikeTests.swift` | all 3D worlds | Budgets and a proven SceneKit room template ("Metal/SceneKit engines exist", foundation root cause 5). | exists | tool |
| 67 | **Design's three registers as a room test** (canon / distinction / legibility) | `GarimaCanvasSpikeTests.swift:11–:210` | Her Home; every world | The template for each world's "room test" in the loom. | exists | tool |

---

## C · Conflicts and gaps

1. **Path in the brief.** `iOS/Bindu Mandala/Bindu MandalaTests/` does not exist. The targets are `iOS/Bindu MandalaTests/` and `iOS/Bindu MandalaUITests/`, siblings of the app folder.
2. **The lock was retired and its replacement never built.** `FeltRegisterSnapshots.swift:525–530` promises "a visual-fidelity check against Design's frames replaces the lock". Nothing in the suite compares to a Design frame except `WorldClimbTests`' constant reads. This is the foundation's root cause 4 ("Tests checked laws, not experience — no parity pass against the Claude Design exports"), made concrete. See B.4.
3. **The light bounds are far below Design.** Captures assert mean luminance .01–.9 and spread >.02 (`WorldClimbCaptureTests`, `RoomCaptureTests`, the ring suites, `OuterRingCapture`). The foundation audit measured Homes light at ~11–65/255 against Design's 80–255. The tests pass rooms Design would reject. Only `GarimaCanvasSpikeTests` uses Design-like numbers (hi >90/255, range >70).
4. **UI tests can see 16 of 102.** `SYNC_OFF` seeds only the Ring-2 Karṣiṇīs (`EphemeralStoreTests.swift:85–99`), and CI without `AIRTABLE_PAT` is local-first (`ci_post_clone.sh`). `HomesCorpus` builds 86 *synthetic* rows. `HitAreaTests` skips the threshold row (no āvaraṇa row) and the celestial strip (no Nityā). An automated walk over 15 worlds needs a bundled, read-only snapshot of the Mandala and Map tables (or a CI PAT), which `HomesCorpus` currently avoids under "nothing invented". Resolution: a *verbatim export*, dated, is not invention.
5. **"The Gate" means four things.** (a) Laghimā/Garimā rooms (`GateRoomTests`, `GateLookTests`, `TheWayInTests.swift:112`); (b) the foundation's "Gates (base, life size)" where today's Śakti meets him; (c) `TheGates` inward/outward offering at the membranes (`OneBuildingTests.swift:199`); (d) the chakra "Practice Gate Type" (`ChakraRoomTests.swift:97`). Name them apart before building.
6. **Ruling 3 (Axis 18, Crow 19) is not pinned.** Road 18 hosts `spineWalk` (Axis-like) and road 19 is `restlessness` (`ChakraRoomTests`). Crow appears as The Map's name for kp 82 (`PlayTests.swift:34`) and "Crow at the Sahasrāra band" in the climb. No test states chakra 18 = Axis or 19 = Crow.
7. **Ruling 4 (elements) conflicts with the tests' tattva physics.** The Ring-2 order is Kāma 29, Buddhi 30, **Ahaṅkāra 31**, Śabda 32, Sparśa 33, Rūpa 34, Rasa 35, Gandha 36, Citta 37, Dhairya 38, Smṛti 39, **Nāma 40**, Bīja 41, **Ātma 42**, **Amṛta 43**, Śarīra 44 (consistent with `AccessibilityReachTests` "thirty-third" for Sparśa, `DynamicTypeTests` "Ahaṅkārākarṣiṇī, kp 31" and `PlayTests` "Ātmākarṣiṇī" at 42). `CrossingRoomTests` (physics by the base's tattva) gives: **31 Space (ruling: fire)**, **40 Space (ruling: air)**, **42 no element (ruling: light)**, **43 no element (ruling: water)**. `ElementTests.swift:21` has no "light" branch at all (unknown → ether). The ruling therefore needs a data change (Airtable tattva) or a kp override in `Element`. Then `CrossingRoomTests`' physics table, `RecognitionNature` (light → radiate, water → pool, fire → flare, air → disperse), the Rite archetype and the sound carrier must all be re-pinned. Minor: `SilenceDwellTests.swift:50` names its position-5 fixture "Nāmākarṣiṇī", but position 5 is Sparśa (cosmetic, in the fixture only).
8. **Several of his rulings have no test**: dissolutions once a day; Homecoming each launch (every UI test passes `SKIP_HOMECOMING`); Maya's last line "only You, playing"; the dance drawing every archetype; the 16 Karṣiṇī Functions; the Relationship Field; launch at the Bindu with Today first. The Leela test checks the *shape* (`≥ minimumGapDays`, "only by chance") but **pins neither 3 nor 30 %**. It also forbids drops in the first days after install (`firstSeenDay`), which is stricter than the ruling as written. Confirm with him.
9. **"Two-state seats" and "a veil that cannot learn" (lifted) against "nothing scores him" (floor).** `MandalaLightTests`, `MandalaYantraTests`, `LawsDrawnMeasureTests` and `SpikeCensus` enforce both at once. The rewrite must allow more seat states and a veil that remembers, while still forbidding any monotone-with-count display.
10. **`ShaktiStatus` is an advance-only ladder** (mapped → exploring → active → embodied) with rising opacity (`ShaktiStatusTests.swift:7–20`). That is a progress meter, and it sits uneasily with C-1284's "every light breathes the same, met or not" (`OneBuildingTests`). The two tests disagree in spirit. Ask whether Status is shown at all.
11. **Gating that survives in mechanisms**: `DescentReach.shallow` (3 of 5 stations until 62 s), `HerDeepening` (one layer per return), the fifth withheld in rings 1–8 (`HomeMemory`/`HomeSound`), and no way out at the threshold (`TheWayInUITests`). All are lifted under "gating/locks"; keep them as offered deepening.
12. **"Three doors, never five"** (`RiteDayTests.swift:21`) is a count restriction in the spirit of "three controls". Lift it.
13. **Story material inside the tests' data** (ruling 5): ChakraRoom story columns (Story Thread, Leela Story, Act 1/2 Voice, the Shadow's "home/come/please/back"), Leela drop leads/actions, GameStructure panel declarations and seeds, and the ScrollUnroll lines. Flag them for Bindu Feed. Keep the practice, gate and movement columns here.
14. **An open defect is carried as an expected failure**: `MudraRoomTests`, Siddhi–Mātṛkā family separation .392 vs .422 under `XCTExpectFailure`, "deferred to Phase 3.10".
15. **"No generated voice" has no test.** Synthesised tones (carriers, Shepard, Om) are not voice, but nothing forbids TTS.
16. **The settings baseline shows a sheet laid over the Well** ("Your Letters to Them" as the sheet title). This is direct evidence of a world laid over another in the shipped build.
17. **Pinned exceptions will churn.** `DynamicTypeTests.fixedByDesign`, `LegibilityExemptions`, `HitArea.eight` and the `LawsTests` pins name current files and strings, and fail on stale pins by design. The fifteen-world rebuild moves every one of those files. Keep the *rules* and expect to re-pin.
18. **Design's numbers are retyped, not read**, in most CRAFT suites (B.4-1). A Design revision will not fail them. Only `WorldClimbTests` reads the source.
19. **SceneKit capture caveat.** `drawHierarchy`/`ImageRenderer` return black for `CAMetalLayer` (`WorldClimbCaptureTests`, `SpikeGarimaSceneKitTests`). Any screenshot-based walk or parity check of 3D worlds must use `simctl io` or `SCNView.snapshot()`.
20. **The foundation's own navigation paragraph says "no hamburger, no ✶ ring"**, while the later ruling says "a full index always one touch away (the hamburger grown into the whole Meru)". `MandalaLightReachTests.swift:176/:211` assert the hamburger exists and opens, which is aligned with the later ruling. Keep them.
21. **The point's double meaning.** `OneBuildingTests` (12 Oct) makes a gentle tap at the point open silence. The foundation makes "the point" the way home from every world. At Home, a tap = silence; elsewhere, a tap = home. Needs an explicit rule and test (B.2-6).
22. **HomesHarness's own "absent-by-design" list** (geometric divergence, premise-reversal geometry, world conditions, the 4×4 legibility grid over all 102, visual coverage, canon 6, iconography 7) records which Design verification checks were never ported. Several are now partly covered by ring suites, but there is no single port of `homes-verify.js`'s 66 checks.
23. **The spike suites write screenshots outside the repo** to a path computed from a worktree name (`…/scratchpad/garima-shots/…`). Harmless, but the walk needs a fixed artifact path.
24. **Legibility exemption for the Rite's veil name at α .24** (accentFaint), recorded as a watermark and a door. If Design's frame draws it brighter, parity should win over the exemption.

---

## D · Coverage proof

Every assigned file appears below. Method: the Read tool, line 1 to the end (long files paged with offset/limit). The 30 `.geom` baseline files are plain text and were read in full with `cat -n` because they are geometry, not images: **the SnapshotBaselines folder contains no images**, so there was nothing to open as a picture. `PlayTests.swift` and `GameStructureTests.swift` were read twice in full (again after a context compaction). The md5 values were computed with `md5sum` on 2026-10-12 at HEAD `8555b4d`.

Totals: 87 unit-test Swift files 33,145 lines; 10 UI-test Swift files 3,839 lines (97 Swift files, **36,984 lines**); 2 CI scripts 127 lines; 30 baseline files 858 lines. **129 files, 37,969 lines, all read in full.**

| # | file (under iOS/) | total lines (wc -l) | lines read | method | md5 (first 8) |
|---|---|---|---|---|---|
| 1 | `Bindu MandalaTests/ActivityLedgerTests.swift` | 970 | 1–970 | Read tool, full | 3c33fd0d |
| 2 | `Bindu MandalaTests/AtmosphereTests.swift` | 72 | 1–72 | Read tool, full | 3bcaadd3 |
| 3 | `Bindu MandalaTests/BodilessRoomTests.swift` | 460 | 1–460 | Read tool, full | d5883ffe |
| 4 | `Bindu MandalaTests/ChakraConstellationTests.swift` | 238 | 1–238 | Read tool, full | 2fc4e7fa |
| 5 | `Bindu MandalaTests/ChakraRoomTests.swift` | 337 | 1–337 | Read tool, full | 23fef933 |
| 6 | `Bindu MandalaTests/CoherenceTests.swift` | 158 | 1–158 | Read tool, full | 20f385cc |
| 7 | `Bindu MandalaTests/CosmicRoomTests.swift` | 653 | 1–653 | Read tool, full | 29debf1e |
| 8 | `Bindu MandalaTests/CrossingRoomTests.swift` | 975 | 1–975 | Read tool, full | 9e337023 |
| 9 | `Bindu MandalaTests/DailyEnergyServiceTests.swift` | 88 | 1–88 | Read tool, full | 74e1a671 |
| 10 | `Bindu MandalaTests/DayLightTests.swift` | 316 | 1–316 | Read tool, full | ad08316e |
| 11 | `Bindu MandalaTests/DescentMirrorTests.swift` | 46 | 1–46 | Read tool, full | fd43981b |
| 12 | `Bindu MandalaTests/DeviceSlipTests.swift` | 206 | 1–206 | Read tool, full | 0588e58c |
| 13 | `Bindu MandalaTests/DissolveRoomTests.swift` | 462 | 1–462 | Read tool, full | 19e8e5bf |
| 14 | `Bindu MandalaTests/DynamicTypeTests.swift` | 313 | 1–313 | Read tool, full | 94370e61 |
| 15 | `Bindu MandalaTests/ElementTests.swift` | 55 | 1–55 | Read tool, full | ab91f1c9 |
| 16 | `Bindu MandalaTests/EnergyGiftTests.swift` | 67 | 1–67 | Read tool, full | ef83b8f5 |
| 17 | `Bindu MandalaTests/EphemeralStoreTests.swift` | 160 | 1–160 | Read tool, full | a292a980 |
| 18 | `Bindu MandalaTests/EphemerisTests.swift` | 198 | 1–198 | Read tool, full | 620bb0ef |
| 19 | `Bindu MandalaTests/GameStructureTests.swift` | 309 | 1–309 | Read tool, full | 3da1c5a5 |
| 20 | `Bindu MandalaTests/GarimaCanvasSpikeTests.swift` | 471 | 1–471 | Read tool, full | b0232e3a |
| 21 | `Bindu MandalaTests/GateLookTests.swift` | 199 | 1–199 | Read tool, full | 22819722 |
| 22 | `Bindu MandalaTests/GateRoomTests.swift` | 758 | 1–758 | Read tool, full | a7655ed4 |
| 23 | `Bindu MandalaTests/GivingRoomTests.swift` | 754 | 1–754 | Read tool, full | b266d3ec |
| 24 | `Bindu MandalaTests/HitAreaIdiomTests.swift` | 325 | 1–325 | Read tool, full | 3db3e42b |
| 25 | `Bindu MandalaTests/HomeAttributeTests.swift` | 415 | 1–415 | Read tool, full | 5f30fd67 |
| 26 | `Bindu MandalaTests/HomeDescentTests.swift` | 477 | 1–477 | Read tool, full | 91705131 |
| 27 | `Bindu MandalaTests/HomeDwellingTests.swift` | 416 | 1–416 | Read tool, full | a22e93ba |
| 28 | `Bindu MandalaTests/HomeGrammarTests.swift` | 706 | 1–706 | Read tool, full | 3e65cf8c |
| 29 | `Bindu MandalaTests/HomeMemoryTests.swift` | 368 | 1–368 | Read tool, full | 10fbb6f6 |
| 30 | `Bindu MandalaTests/HomeSoundTests.swift` | 501 | 1–501 | Read tool, full | 74468b64 |
| 31 | `Bindu MandalaTests/HomeVoiceTests.swift` | 227 | 1–227 | Read tool, full | 991a2f59 |
| 32 | `Bindu MandalaTests/HomeWorldsTests.swift` | 441 | 1–441 | Read tool, full | f29059c6 |
| 33 | `Bindu MandalaTests/HomesCorpus.swift` | 141 | 1–141 | Read tool, full | cb7a15ae |
| 34 | `Bindu MandalaTests/HomesHarnessTests.swift` | 1126 | 1–1126 | Read tool, full | 5a0fbc06 |
| 35 | `Bindu MandalaTests/HomesWaveOneTests.swift` | 298 | 1–298 | Read tool, full | 0faabb21 |
| 36 | `Bindu MandalaTests/KhadgamalaMapTests.swift` | 45 | 1–45 | Read tool, full | 0535faca |
| 37 | `Bindu MandalaTests/LawsTests.swift` | 2443 | 1–2443 | Read tool, full | ad440aec |
| 38 | `Bindu MandalaTests/LegibilityTests.swift` | 626 | 1–626 | Read tool, full | dd66add2 |
| 39 | `Bindu MandalaTests/LetterDraftTests.swift` | 67 | 1–67 | Read tool, full | 1b06ef71 |
| 40 | `Bindu MandalaTests/LetterMigrationTests.swift` | 308 | 1–308 | Read tool, full | aff8fbef |
| 41 | `Bindu MandalaTests/LivingMandalaTests.swift` | 179 | 1–179 | Read tool, full | 61e12bfc |
| 42 | `Bindu MandalaTests/LunarPhaseServiceTests.swift` | 63 | 1–63 | Read tool, full | 70327db4 |
| 43 | `Bindu MandalaTests/MandalaCameraTests.swift` | 100 | 1–100 | Read tool, full | 3f4b6d29 |
| 44 | `Bindu MandalaTests/MandalaLightTests.swift` | 525 | 1–525 | Read tool, full | a12abc0a |
| 45 | `Bindu MandalaTests/MandalaVoiceTests.swift` | 383 | 1–383 | Read tool, full | 4e8f9ff5 |
| 46 | `Bindu MandalaTests/MandalaWorldTests.swift` | 92 | 1–92 | Read tool, full | 38e90d2e |
| 47 | `Bindu MandalaTests/MandalaYantraTests.swift` | 324 | 1–324 | Read tool, full | c456dacf |
| 48 | `Bindu MandalaTests/MarginTests.swift` | 284 | 1–284 | Read tool, full | bba4aef6 |
| 49 | `Bindu MandalaTests/MatrkaRoomTests.swift` | 326 | 1–326 | Read tool, full | 16273be1 |
| 50 | `Bindu MandalaTests/ModesAndRitesTests.swift` | 345 | 1–345 | Read tool, full | bbbc21ae |
| 51 | `Bindu MandalaTests/MudraRoomTests.swift` | 762 | 1–762 | Read tool, full | 3103a4f8 |
| 52 | `Bindu MandalaTests/OneBuildingTests.swift` | 449 | 1–449 | Read tool, full | b292d248 |
| 53 | `Bindu MandalaTests/OuterRingFingerprint.swift` | 338 | 1–338 | Read tool, full | eb1fec72 |
| 54 | `Bindu MandalaTests/PendingQueuePolicyTests.swift` | 168 | 1–168 | Read tool, full | a1068b61 |
| 55 | `Bindu MandalaTests/PlayTests.swift` | 578 | 1–578 | Read tool, full | 29947f4e |
| 56 | `Bindu MandalaTests/PlayWholeTests.swift` | 444 | 1–444 | Read tool, full | e070d434 |
| 57 | `Bindu MandalaTests/RecognitionDedupTests.swift` | 212 | 1–212 | Read tool, full | 842d14ee |
| 58 | `Bindu MandalaTests/RecognitionMigratorTests.swift` | 57 | 1–57 | Read tool, full | 8197bc15 |
| 59 | `Bindu MandalaTests/RecognitionNatureTests.swift` | 306 | 1–306 | Read tool, full | f93281c9 |
| 60 | `Bindu MandalaTests/RevealingRoomTests.swift` | 594 | 1–594 | Read tool, full | db5135eb |
| 61 | `Bindu MandalaTests/RingOneFingerprint.swift` | 212 | 1–212 | Read tool, full | eb7aefa3 |
| 62 | `Bindu MandalaTests/RiteCompositionTests.swift` | 73 | 1–73 | Read tool, full | 658c7ebc |
| 63 | `Bindu MandalaTests/RiteDayTests.swift` | 196 | 1–196 | Read tool, full | da4c6b41 |
| 64 | `Bindu MandalaTests/RiteOfEnteringTests.swift` | 974 | 1–974 | Read tool, full | 4294d654 |
| 65 | `Bindu MandalaTests/RoomCaptureTests.swift` | 350 | 1–350 | Read tool, full | 22f5d8a2 |
| 66 | `Bindu MandalaTests/RoomSceneTests.swift` | 751 | 1–751 | Read tool, full | fe743b6e |
| 67 | `Bindu MandalaTests/SchemaMigrationTests.swift` | 172 | 1–172 | Read tool, full | 8d4f25f8 |
| 68 | `Bindu MandalaTests/SeatLightingTests.swift` | 45 | 1–45 | Read tool, full | ba04d497 |
| 69 | `Bindu MandalaTests/ShaktiBijaTests.swift` | 41 | 1–41 | Read tool, full | db070926 |
| 70 | `Bindu MandalaTests/ShaktiStatusTests.swift` | 27 | 1–27 | Read tool, full | 749e3864 |
| 71 | `Bindu MandalaTests/SiddhiRoomTests.swift` | 465 | 1–465 | Read tool, full | 728660a8 |
| 72 | `Bindu MandalaTests/SilenceDwellTests.swift` | 82 | 1–82 | Read tool, full | 5929edd5 |
| 73 | `Bindu MandalaTests/SomaticRegionTests.swift` | 72 | 1–72 | Read tool, full | 1fcfce64 |
| 74 | `Bindu MandalaTests/SoundingRoomTests.swift` | 575 | 1–575 | Read tool, full | f917ff9a |
| 75 | `Bindu MandalaTests/SourceTree.swift` | 35 | 1–35 | Read tool, full | dbd46b8b |
| 76 | `Bindu MandalaTests/SourcingRoomTests.swift` | 509 | 1–509 | Read tool, full | 1aa9baef |
| 77 | `Bindu MandalaTests/SpikeBaselineBenchTests.swift` | 112 | 1–112 | Read tool, full | f3c30c33 |
| 78 | `Bindu MandalaTests/SpikeCensusTests.swift` | 376 | 1–376 | Read tool, full | bb47c968 |
| 79 | `Bindu MandalaTests/SpikeGarimaSceneKitTests.swift` | 615 | 1–615 | Read tool, full | eb09ab13 |
| 80 | `Bindu MandalaTests/TheLibraryFoldTests.swift` | 336 | 1–336 | Read tool, full | 624cf721 |
| 81 | `Bindu MandalaTests/TheRiverTests.swift` | 242 | 1–242 | Read tool, full | 6a7fa4d1 |
| 82 | `Bindu MandalaTests/TheWayInTests.swift` | 1003 | 1–1003 | Read tool, full | 1a36a5b1 |
| 83 | `Bindu MandalaTests/TimeVariantModulationTests.swift` | 27 | 1–27 | Read tool, full | 7b876c8f |
| 84 | `Bindu MandalaTests/WaveSixMemoryTests.swift` | 463 | 1–463 | Read tool, full | e36f9c38 |
| 85 | `Bindu MandalaTests/WholeInstrumentTests.swift` | 316 | 1–316 | Read tool, full | cfa8c2b0 |
| 86 | `Bindu MandalaTests/WorldClimbCaptureTests.swift` | 315 | 1–315 | Read tool, full | 7ddc4343 |
| 87 | `Bindu MandalaTests/WorldClimbTests.swift` | 1037 | 1–1037 | Read tool, full | 69f273da |
| 88 | `Bindu MandalaUITests/AccessibilityReachTests.swift` | 493 | 1–493 | Read tool, full | f377ea6e |
| 89 | `Bindu MandalaUITests/BinduMandalaUITests.swift` | 97 | 1–97 | Read tool, full | 250d0410 |
| 90 | `Bindu MandalaUITests/FeltRegisterClassifications.swift` | 562 | 1–562 | Read tool, full | 9e4d9bb6 |
| 91 | `Bindu MandalaUITests/FeltRegisterSnapshots.swift` | 624 | 1–624 | Read tool, full | 169f9ebb |
| 92 | `Bindu MandalaUITests/HitAreaTests.swift` | 218 | 1–218 | Read tool, full | 22eec81d |
| 93 | `Bindu MandalaUITests/MandalaLightReachTests.swift` | 402 | 1–402 | Read tool, full | 77f66777 |
| 94 | `Bindu MandalaUITests/SpikeColdLaunchTests.swift` | 74 | 1–74 | Read tool, full | 785d638f |
| 95 | `Bindu MandalaUITests/TheLibraryFoldUITests.swift` | 513 | 1–513 | Read tool, full | 8b70c4a3 |
| 96 | `Bindu MandalaUITests/TheMarginUITests.swift` | 426 | 1–426 | Read tool, full | c3280f7f |
| 97 | `Bindu MandalaUITests/TheWayInUITests.swift` | 430 | 1–430 | Read tool, full | f4e01309 |
| 98 | `ci_scripts/ci_post_clone.sh` | 93 | 1–93 | Read tool, full | 4cfc6b16 |
| 99 | `ci_scripts/ci_pre_xcodebuild.sh` | 34 | 1–34 | Read tool, full | b2206fe4 |
| 100 | `SnapshotBaselines/phone/detail.geom` | 29 | 1–29 | cat -n, full (text geometry, no images) | 8fbafc43 |
| 101 | `SnapshotBaselines/phone/field.geom` | 23 | 1–23 | cat -n, full (text geometry, no images) | 932cec1b |
| 102 | `SnapshotBaselines/phone/mandala-descent.geom` | 18 | 1–18 | cat -n, full (text geometry, no images) | 4f622fdf |
| 103 | `SnapshotBaselines/phone/mandala.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | 12439f8b |
| 104 | `SnapshotBaselines/phone/memory.geom` | 4 | 1–4 | cat -n, full (text geometry, no images) | 39f72661 |
| 105 | `SnapshotBaselines/phone/recognition.geom` | 19 | 1–19 | cat -n, full (text geometry, no images) | 2bda0403 |
| 106 | `SnapshotBaselines/phone/rite.geom` | 11 | 1–11 | cat -n, full (text geometry, no images) | 626f9ef8 |
| 107 | `SnapshotBaselines/phone/settings.geom` | 98 | 1–98 | cat -n, full (text geometry, no images) | 973d1401 |
| 108 | `SnapshotBaselines/phone/well-letter.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | eb276b32 |
| 109 | `SnapshotBaselines/phone/well.geom` | 70 | 1–70 | cat -n, full (text geometry, no images) | 0d8d93c8 |
| 110 | `SnapshotBaselines/promax/detail.geom` | 29 | 1–29 | cat -n, full (text geometry, no images) | eb3f23c3 |
| 111 | `SnapshotBaselines/promax/field.geom` | 23 | 1–23 | cat -n, full (text geometry, no images) | 2d65e749 |
| 112 | `SnapshotBaselines/promax/mandala-descent.geom` | 18 | 1–18 | cat -n, full (text geometry, no images) | df5fa84b |
| 113 | `SnapshotBaselines/promax/mandala.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | 627d2d4e |
| 114 | `SnapshotBaselines/promax/memory.geom` | 4 | 1–4 | cat -n, full (text geometry, no images) | 2d4344f9 |
| 115 | `SnapshotBaselines/promax/recognition.geom` | 19 | 1–19 | cat -n, full (text geometry, no images) | 0c71fc58 |
| 116 | `SnapshotBaselines/promax/rite.geom` | 11 | 1–11 | cat -n, full (text geometry, no images) | f1e34ea8 |
| 117 | `SnapshotBaselines/promax/settings.geom` | 98 | 1–98 | cat -n, full (text geometry, no images) | 544c4736 |
| 118 | `SnapshotBaselines/promax/well-letter.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | a7c22466 |
| 119 | `SnapshotBaselines/promax/well.geom` | 70 | 1–70 | cat -n, full (text geometry, no images) | 82ce44d8 |
| 120 | `SnapshotBaselines/se/detail.geom` | 29 | 1–29 | cat -n, full (text geometry, no images) | 8e9f1011 |
| 121 | `SnapshotBaselines/se/field.geom` | 23 | 1–23 | cat -n, full (text geometry, no images) | ceaf86a3 |
| 122 | `SnapshotBaselines/se/mandala-descent.geom` | 18 | 1–18 | cat -n, full (text geometry, no images) | 9b1b96be |
| 123 | `SnapshotBaselines/se/mandala.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | b0405824 |
| 124 | `SnapshotBaselines/se/memory.geom` | 4 | 1–4 | cat -n, full (text geometry, no images) | 78152260 |
| 125 | `SnapshotBaselines/se/recognition.geom` | 19 | 1–19 | cat -n, full (text geometry, no images) | 31508996 |
| 126 | `SnapshotBaselines/se/rite.geom` | 11 | 1–11 | cat -n, full (text geometry, no images) | ee6028da |
| 127 | `SnapshotBaselines/se/settings.geom` | 98 | 1–98 | cat -n, full (text geometry, no images) | 5f9d5480 |
| 128 | `SnapshotBaselines/se/well-letter.geom` | 7 | 1–7 | cat -n, full (text geometry, no images) | 45078769 |
| 129 | `SnapshotBaselines/se/well.geom` | 70 | 1–70 | cat -n, full (text geometry, no images) | 8debd175 |

---

## Return message

**File:** `/home/claude/bindu-mandala/waves/register/22-code-tests.md`. All 129 assigned files (97 Swift test files, 2 CI scripts, 30 `.geom` baselines; 37,969 lines) were read in full. The baselines folder holds no images.

**Ten most valuable gifts**
1. **The nine worlds, whole**: the RING_CHARACTER and WORLDS tables (yoginī, phase, veil, mental state, tempo, verb, bīja, gem, dhātu, clock, body region, fog) (`HomeWorldsTests.swift:27/:98`), plus each ring's clock and the Axis physics read straight from Design's JS (`WorldClimbTests.swift:54–125`).
2. **A ready-made Design-parity method**: tests that read `Claude Design Round 2/homes/*` from disk, bundled into CI by `SourceTree`. Extend it to every export, and add `.geom` geometry and luminance-grid comparison against the 40 frames (B.4).
3. **102 rooms by position**: Design's 8 authored rooms and 94 grammar rooms, with eight ring archetypes, reversal lines and sister divergence >0.1 (`WholeInstrumentTests`, the ring suites). The kp-102 Dissolve room is the yantra in stone: 99 marks and the source.
4. **The complete sound table**: ring roots 55–123.47 Hz, JUST 12, the witness, triad and Shepard techniques, the Om 136.1 floor, the bells 272.2/136.1, the falling RingBija mantra 528×0.917ⁿ and the awakening tones 174–528.
5. **Recognition's six natures**, as keyframes, LR_RECOG rows and a five-beat timeline in which "and she felt you back" lands in stillness (`RecognitionNatureTests`).
6. **The real-sky Time engine**: tithi, nakṣatra, ṛtu, sandhyās and the five clocks, verified against USNO (`EphemerisTests`). It is what opens the River's letters on the real moon.
7. **The automated-walk seed**: `TheWayInUITests` cold launch → room → back to where he was, plus `TheWayInTests`' "all 102 enterable through one door". Generalise both into a 15-world × every-route matrix with one world hittable at a time and the point everywhere (B.2, B.3).
8. **The one building's centre**: Pointy (line → circle → ∞ → heart), CentreBloom (the yantra drawn outward from the point), Pravesha (an endless fall), Mauna, "Who is saying that?", and the empty summit "I am what I am becoming." / "I already did." (`OneBuildingTests`, `WorldClimbTests`).
9. **A Strange Game, addressed**: 36 games seated at named Śaktis, C-1357 physics (force absorbed, nothing taken back), the Leela board, the Tree of Life ("Now go play."), the Trinity faces and ThreePools (`PlayTests`, `PlayWholeTests`, `GameStructureTests`).
10. **The Modes, the River and the day's kindness**: Darśana, Sādhana (28 min), Smṛti, Svapna and Pūjā; sealed and sent-back letters with patina; the Wager; GraceChannel across sister apps; SakshiClose ("Nothing was asked of you today."); the HomecomingScore.

**Key conflicts:**
- His element ruling (Ahaṅ fire, Nāma air, Ātma light, Amṛta water) contradicts the tattva physics now pinned for kp 31/40/42/43, and `Element` has no "light".
- Dissolutions once a day, Homecoming each launch, Axis 18/Crow 19 and Maya's line have no tests, and the Leela constants are unpinned.
- About twenty test families encode lifted rules (listed in B.1).
- The promised Design-frame check that was meant to replace the composition lock was never built.
