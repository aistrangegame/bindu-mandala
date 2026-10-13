# U0 · Part C report: tests and the proof system (builder C)

Branch `upgrade-u0c`, cut from `upgrade` at `ac1d406` (the U0 brief). `upgrade` was merged in twice as Part B landed (`341c032`, `7e48749`), so this branch holds all of Part B. Both merges were clean. Not pushed.

**There is no Swift compiler here, so none of this has been compiled or run.** Every type and call site was read before use. The Mac build and run are the session's job. The pure algorithms (narrow floor, luminance and hue, manifest, snapshot normalisation, the write-diversion scan) were checked in Python against the real files. The section "How each new check was shown able to fail" lists those checks.

## Commits

| hash | what |
|---|---|
| `e502d54` | App hooks: `WorldID`, `OPEN_WORLD`, the `SNAPSHOT` source and the mock ledger |
| `dbb097f` | Lifted-rule tests, part one: narrow measuring floor, aniconic floor, mixing law, retired locks |
| `341c032` | Merge `upgrade` (U0-B so far) |
| `19d687a` | Lifted-rule tests, part two: rooms, descent, play, rites, chakras, UI suites; follows Part B's rulings |
| `365d0a0` | The unit half of the proof system: `DesignCorpus`, `FramesManifest`, `Luminance`, `RulingTests`, `Design/` added to the bundling phase |
| `d852adf` | The walk driver (`TheWalk`), `WalkTrace`, `WorldRegistryTests` |
| `7e48749` | Merge `upgrade` (U0-B report) |
| (this file) | Report |

## New files

| file | target | what |
|---|---|---|
| `iOS/Bindu Mandala/Services/WorldID.swift` | app | `enum WorldID: String, CaseIterable`: home, today, mandala, rings, herHome, herPresence, climb, the33, game, modes, time, memory, well, beneath, relationship. Also `fromLaunchArguments` (`OPEN_WORLD=<id>`, DEBUG only, last one wins), `u0Destination` (the closest existing screen, table below), `opensClimb` / `opensPlayField` / `opensDescent`, `sentinel` (`world.<id>`), `title`, and `reached(by: WayIn)` |
| `iOS/Bindu Mandala/Services/SnapshotSource.swift` | app | `SnapshotSource` reads `SNAPSHOT=<date>` (DEBUG only) and finds the dated folder in `SNAPSHOT_DIR` or in the bundle's `Snapshot/<date>/`. It turns the export's Mandala rows into the API page shape (a select becomes its name, a link becomes its record id). `SnapshotLedger` is the `@MainActor` in-memory mock that holds every write |
| `iOS/Bindu Mandala/Services/WalkTrace.swift` | app | `WALK_TRACE=1` (DEBUG only) writes `{"beat","t"}` JSON lines to `<WALK_OUT>/trace.jsonl` |
| `iOS/Bindu MandalaTests/DesignCorpus.swift` | unit | `DesignCorpus` (a missing file throws, which counts as a FAIL), `FramesManifest` (lenient decoder, accepts either schema), `Luminance` (64×64 Rec.709 min/p5/mean/p95/max, blown share, chroma-weighted hue, the light verdict with Design as the floor) |
| `iOS/Bindu MandalaTests/FramesManifestTests.swift` | unit | F01–F40 complete, every source on disk and md5-equal, the engine reproduces Design's measured means and hues, planted-defect checks |
| `iOS/Bindu MandalaTests/RulingTests.swift` | unit | V34 ruling tests |
| `iOS/Bindu MandalaTests/WorldRegistryTests.swift` | unit | V11 registry, `OPEN_WORLD` parsing, snapshot page shape, every write diverts before the network, trace line shape |
| `iOS/Bindu MandalaUITests/NarrowFloor.swift` | UI | The four floor patterns plus "ordinal + time/visit/turn", for the running app |
| `iOS/Bindu MandalaUITests/TheWalk.swift` | UI | The walk driver |
| `waves/upgrade/briefs/U0-C-report.md` | — | This report |

## App files touched (the hooks Part C needed)

- `BinduMandalaApp.swift`: `AppRuntime.syncDisabled` gains `|| SnapshotSource.isActive`.
- `Data/AirtableService.swift`:
  - `sync(context:)` returns through `syncFromSnapshot` when a snapshot is active. That is a new extension at the end of the file, and it reuses the private `Page`/`ShaktiRow`/`AvaranaRow`/`NityaRow` and `reconcile*`.
  - These write entry points hand their row to `SnapshotLedger` before `syncIsDisabled()`: `recordRecognition`, `advanceStatus` (after the local update), `recordCrossing`, `saveLetter`, `logActivity(_:)`, `recordSilence`, `recordMilestone`, `recordNote`, `writeCodexNote`.
  - Letter and note words are never put in the mock, only the fact that one was written.
  - `PracticeLedger.flush` is left as it was. It still returns on `syncDisabled`, so a snapshot launch stamps nothing as ledgered.
- `Views/Root/RootView.swift`: `initialDestination` honours `OPEN_WORLD` before `START_TAB`, and `onChange(destination)` calls `WalkTrace.mark`.
- `Views/Common/TheHundredTwoView.swift`: `OPEN_WORLD=climb` opens the Climb, the same as `OPEN_CLIMB`.
- `Views/Play/PlayFieldView.swift`: `PlayFieldPresenter` opens Lalitā's field on `OPEN_WORLD=game`.
- `Views/Mandala/LivingMandalaView.swift`: `OPEN_WORLD=beneath` opens the descent, the same as `OPEN_SILENCE`.
- `iOS/Bindu Mandala.xcodeproj/project.pbxproj`: the unit target's "Bundle the source tree" script now also rsyncs `Design/` into `SourceTree/` (V02, so Xcode Cloud can read the corpus). This is the only pbxproj edit. It is in a different place from Part B's `membershipExceptions` edit, and the merge was clean.
- `SYNC_OFF` is untouched and keeps working. `START_TAB` still works too (only `SpikeColdLaunchTests` uses it now, which is U1's retarget).

### `OPEN_WORLD` mapping in U0

| world | screen | how |
|---|---|---|
| home | mandala | the Bindu is `TheCentre` on the Mandala |
| today | rite | |
| mandala | mandala | |
| rings | the102 (the Field) | the nine rings and their thresholds |
| herHome | the102 | her seat's doorway |
| herPresence | rite | |
| climb | the102, then the Climb opens | |
| the33 | mandala | the constellation and the Road |
| game | mandala, then Lalitā's field opens | |
| modes | mandala | the ways-in ring |
| time | rite | moon, tithi, Nityā |
| memory | memory (the Portrait) | |
| well | well | |
| beneath | mandala, then the descent opens | |
| relationship | the102 | Field Connections live in Settings |

## §2.2: every lifted-rule test, with what was done

Line numbers are those in verification.md (taken on the pre-U0 tree).

| ledger | test | done |
|---|---|---|
| L-0733 | CoherenceTests:17 three quiet controls | **Retired** |
| L-0734 | CoherenceTests:34 ways-in ring | **Rewritten** as `testTheWaysInSeedTheWorldRegistry`: every `WayIn` reaches a `WorldID`. The spoken labels "Show the thirty-three chakras" and "Leave the road" are kept |
| L-0735 | RiteDayTests:21 three doors | **Widened**: `testTheOneSecondDoorIsAlwaysOffered`. `.oneSecond` is always offered, no door is offered twice, every door has a title. The "== 3" count, the "close not at 8" clause and the digit clause are gone |
| L-0736, L-0820 | HitAreaIdiomTests:220 compensation ledger | **Retired**. The 44 pt half is kept |
| L-0737 | GameStructureTests:247 one bed | **Rewritten as the mixing law**: `testTheBedsNeverSumPastTheCeiling` (the sum of bed gains is ≤ 1 for every mask, climbing or not, accenting or not) and `testAStruckBijaDucksTheBedAndTheOmStaysUnder` (bedUnderAccent ≤ −6 dB, Om under the bed, Om alone = 1). Om floor ≤ .05 stays in `testTheOmIsTheEarthsOwnPitch…` |
| L-0738 | GameStructureTests:278 climb voices | **Rewritten**: the voice in front is the loudest bed, not the only one |
| L-0739 | OneBuildingTests:434 | **Rewritten**: `testEveryPlaceHasAVoiceAndTheClimbsVoicesSumToOne`. The `count ≤ 2` is gone; the sum = 1 stays |
| L-0740 | CoherenceTests:99 one breath | **Retired** |
| L-0741 | WaveSixMemoryTests:233 one breath clock | **Retired**, replaced by `testEachRingKeepsItsOwnMetabolism` (ring 1 holds; 3/8/9/11/13/15/18/4 s) |
| L-0742 | LawsTests:1316 words | **Replaced with the narrow floor**. `NeverMeasure.measuring` is now four of Design's nine (visit count, streak, score, "N times"). It is still asserted equal to the harness's port (`testTheFloorPatternsAreTheHarnessOwn`) |
| L-0743 | LawsTests:1417 only digit = seat | **Retired**, with `isIdentity`, `digitShapes`, `pinnedNonIdentityDigits` |
| L-0744 | NeverMeasure | Word/digit half retired. The practice-symbol half (`practiceSymbols`, `testNoPracticeValueIsBoundIntoAViewString`) and `testOnlyTheMandalaItselfIsEverCounted` are kept as the floor. The detector test is rewritten to prove the lifted words now pass |
| L-0745 | HomesHarnessTests Measuring | **Narrowed** to the same four, verbatim from `homes-verify.js`. The five lifted patterns are kept in `liftedPatterns`, only so the test can assert they are allowed. Every suite that calls `Measuring.measuresOutLoud` / `NeverMeasure.measuresOutLoud` now runs the narrow floor |
| L-0746 | MandalaLightReachTests:152 | **Rewritten** to `NarrowFloor` |
| L-0747 | MandalaLightReachTests:315 | **Rewritten** to `NarrowFloor` (digits, %, word list lifted). Also its sibling spoken-field numeral clause |
| L-0748 | TheWayInUITests:349 | **Rewritten**: what arrives on the room and axis surfaces is judged by `NarrowFloor`; the digit scan is gone |
| L-0749 | TheMarginUITests:138 | **Rewritten**: `NarrowFloor` plus "N notes" / "(N)" |
| L-0750, L-0821 | TheMarginUITests:232 sheet length | **Retired** (composition lock) |
| L-0751 | LawsTheMarginTests:2273 `.count` ban | **Retired** |
| L-0752 | LawsTheMarginTests:2327 digit | **Retired** |
| L-0753 | MandalaVoiceTests:147 | **Measure-scan half retired**. The practice half stays (`testNoSpokenStringSaysHisPractice`). Numeral clauses at :140 and :299 also retired; ordinal spelling tests kept |
| L-0754 | RiteOfEnteringTests:608 | Runs the narrow floor; its "can fail" string is now a practice string |
| L-0755 | TheWayInTests:317 | Digit clause retired; narrow floor kept |
| L-0756 | TheWayInTests:540 | Unchanged code; it now runs the narrow floor through `NeverMeasure` |
| L-0757 | CoherenceTests:44 | Retired, together with :34's list |
| L-0758 | ModesAndRitesTests | Digit checks at :51, :97, :207, :311–312 retired. :72, :118, :147 became narrow-floor checks |
| L-0759 | RiteDayTests digits | :30, :70, :140 retired; "again" dropped from the empty-day word list. Missed / streak / behind / only stay as the floor |
| L-0760 | TheRiverTests:235–236 | Became narrow-floor checks |
| L-0761 | MarginDateTests (MarginTests:270) | Rewritten as `testEveryDayOfTheYearCanBeSpoken`; the numeral clause is retired |
| L-0762 | PlayTests:488 | Digit clause and `countExpressions` retired. Narrow floor, practice symbols and the game's-own-measure scan are kept |
| L-0763 | TheLibraryFoldUITests:163 | Geometry-unchanged-when-felt half retired. Narrow floor plus "folded, one touch away" kept |
| L-0764 | TheLibraryFoldTests | Narrow floor via the detector; the shelf-row arity pin is retired |
| L-0765 | ChakraConstellation spoken rows | Digit check retired → `testTheSpokenConstellationNamesPlacesAndHoldsTheSealedRoom` (narrow floor, plus room 32 is spoken as held) |
| L-0766 | MandalaVeil spoken rows | See L-0796 |
| L-0767 | RiteOfEnteringTests:644 returning words | **Retired** |
| L-0768 | TheWayInUITests:424 `wordsThatMeasure` | **Retired** |
| L-0769 | LawsTests:1741 catalogue | **Rewritten**: `testNoAssetOrImageFileIsAFigure`. No figural name in the catalogue or in image paths; every image is on `Aniconic.reviewedImageFiles` (the reviewed allow-list, which today holds the app icon only) |
| L-0770 | LawsTests:1787 drawing primitive | **Rewritten**: the figural-vocabulary check is kept; the one-chevron pin and the "nothing loaded from a file" bans are retired |
| L-0771 | LawsTests:1867 render path of shapes | **Rewritten**: `testEveryImageIsASymbolARenderOrANamedNonFigure`, which reads node kinds and names, not counts of primitives |
| L-0772, FL-0887 | RecognitionNatureTests:299 | **Rewritten**: anything drawn may not name a figure |
| L-0773, FL-0888 | PlayTests:573 | **Rewritten**: `testPlayDrawsNoFigure` |
| L-0774 | HomeDescentTests:203 (and :193) | The solid counts are **retired**: `testOpeningTheDescentBuildsInTheBuilding` |
| L-0775, FL-0886 | RoomSceneTests | `solidsInHerLayer` / `figuresInHerLayer` / `solids(in: .her)` assertions retired. The node-name figural check is kept as the floor |
| L-0776…0787 | Crossing, Siddhi, Matrka, Mudra, Bodiless:441, Cosmic:576, Giving, Revealing, Sounding, Sourcing, Gate:126, Dissolve | Every `XCTAssertEqual(scene.solidsInHerLayer, 0, …)` was replaced by a comment line. Divergence, legibility and reduce-motion are untouched. CrossingRoomTests:482's digit clause became the narrow floor |
| L-0788, L-0789 | RiteOfEnteringTests:267, :822 | Solid-count assertions retired |
| L-0790 | WorldClimbTests binding condition | **Rewritten**: `everyPresenceIsLight` and the 102 presences kept; the solid census is retired |
| L-0791 | RoomSceneTests five SurfaceVerbs | The verb tests were already behaviour, not law (Wave 2 rewrite); kept as behaviour. The solid counts in the same suite are retired |
| L-0792 | MudraRoomTests body words | **Retired**. The mirror symmetry, no taper and no centre geometry is kept as "no figure" |
| L-0793 | LawsTests:1830 iconography off screen | **Retired** (`testTheSomaticFieldsAreNeverIconography` keeps its somatic half) |
| L-0794 | MandalaLightTests:71 gem never colours | **Retired** |
| L-0795 | MandalaLightTests:188 | **Rewritten**: `testTheVeilIsNeverACompletionMeter`. Only counts are forbidden; where he has been is allowed |
| L-0796 | MandalaYantraTests:277 | **Rewritten**: `testTheVeilIsNeverACompletionMeter`. No count reaches the Veil, and the spoken rows carry no fraction or percentage of the rings and pass the narrow floor |
| L-0797 | MandalaLightTests:143 | Kept; doc rewritten (felt is one of several states) |
| L-0798 | MandalaLightTests:158 | Renamed `testTheLightKnowsStatesNeverHowOften`; assertions kept |
| L-0799 | MandalaLightTests:506 | `unfeltRadius` pin dropped; the ramp ban kept, plus no count identifier in the canvas |
| L-0800, L-0801 | LawsDrawnMeasureTests:2123/:2150 | Kept as the floor; header rewritten to "several states"; a multi-state line added to the detector's lawful shapes |
| L-0802 | SpikeCensusTests one glow per felt seat | **Rewritten**: glows bounded (≥ 1 when anything is felt, ≤ 4 per seat), not pinned to 26 |
| L-0803 | PlayTests:559 no store | **Retired**; replaced by `testPlayReachesTheLedgerThroughItsOneDoor` |
| L-0804 | TheWayInTests:142 | **Rewritten**: `testEveryRoomIsDrawnByTheOneDoorType` (`RoomView(` only in `RiteOfEnteringView`/`HerRoomDoor`; the rite is compressible, floor 0.36) |
| L-0805 | TheWayInTests:171 | Message rewritten (one door type, rite offered); assertions kept |
| L-0806, L-0807 | UI `START_TAB=rite`, BinduMandalaUITests setUp | Every UI suite now uses `OPEN_WORLD` (mandala→mandala, rite→today, 102→rings, well→well, memory→memory). Today is reached as its world. `SpikeColdLaunchTests` was left alone (U1 retarget) |
| L-0808 | RiteOpening.opens | Dawn and dusk ways are kept as offers (`CoherenceTests.testAModeIsOfferedAtItsHour` unchanged). ModesAndRitesTests:187 is rewritten to `oncePerHalfDay == false`, so the opening is offered on every arrival (Part B, ruling 16) |
| L-0809 | upper luminance bounds | Kept: `mean < .9` and Garima `mean < 175` are blow-out guards. **Raising the floors to Design's bands was not done** (verification.md 2.4 puts it in U4/U5) |
| L-0810, L-0813 | HomeSoundTests / HomeMemoryTests:89-122 withheld fifth | `testFifthIsWithheldUntilGranted` and `testFifthIsNotGrantedEarlyInAnOrdinaryRoom` **retired**; the "granted" tests kept. HomesHarness's matching withholding half was retired too (`testTheNinthWorldGrantsTheFifth`) |
| L-0811 | HomeDescentTests:327-339 | Shallow-first assertions **retired**; "always offered", "reaches a station", "dwell opens it to the floor" kept |
| L-0812 | WaveSixMemoryTests:371 | **Rewritten**: `testHerScreenKnowsAReturnByPositionAndHoldsHerLayers`. The open-by-visits gate is retired; position key, sheet-is-not-a-return and layer titles kept |
| L-0814 | TheWayInUITests gating | Covered by L-0748/L-0768 (no other gating assertion in the file). The route walk is kept for U1 |
| L-0815 | ChakraConstellation crossings | Kept, and added: every threshold is also a Road stop (a direct door) |
| L-0816, L-0817, L-0822 | FeltRegisterSnapshots:449 / Classifications / 30 .geom | Confirmed retired as gate (that was done in Wave 1, and U0 notes it in the test). The .geom files stay as the "before" word inventory; the engine is reused by `TheWalk` |
| L-0818 | TheLibraryFoldUITests:438-507 | `TheFoldVocabularyTests` **retired** |
| L-0819 | TheLibraryFoldTests:226 | **Retired** |

Also retired with these:
- The digit-only clauses in `OneBuildingTests` (:134, :153, :300), `PlayWholeTests` (:21–22), `HomeGrammarTests.testNoLabelCarriesANumber`, `WaveSixMemoryTests` (:131, :203, and the layer titles), `ChakraRoomTests` (:246), `HomeDescentTests` (:385 word list), `AccessibilityReachTests` (:112 → `NarrowFloor`, VER-S-0646).
- `RiteDayTests`: grace's rest is retired (`testGraceSpeaksOnceForEachMomentAndNeedsNoRest`, `restDays == 0`, Part B ruling 16).
- `ModesAndRitesTests`: pins `RiteStation.oncePerDay == false`.

Kept deliberately (they protect a quantity of his practice):
- `HomeDwellingTests:261–263`: a milestone's chamber time.
- `WaveSixMemoryTests:414`: the month is composed from his record.
- `CoherenceTests:138`: its row says KEEP.

## Element and Leela (item 2)

- **`ElementTests`**
  - `testRulingFourElementsByPosition`: kp 31 fire, 40 air, 42 light, 43 water. The tattva is chosen to disagree with the table, so a parse would fail.
  - `testTheSixteenKarshinisFollowTheTable`: `Element.ring2ByKp` equals the brief's table, with `forRing2(kp:)` nil outside 29–44.
  - `testTheLightBranch`: light radiates; ring 9 stays light.
  - The old `kp 33 Fire` / `kp 34 blank → ether` lines were removed.
- **`GameStructureTests`**
  - `testHisLeelaConstantsArePinned`: `minimumGapDays == 3`, `chance == 0.30`, roll .299 drops and .30 does not, two days after the last drop does not.
  - `testALeelaDropMayComeInTheFirstDays`: ruling 16.
  - The long-run rarity test is kept without its first-days line.

## §2.3: floors kept

All 97 are kept. No floor suite was deleted. Clauses removed from kept suites are only the lifted clauses listed above: digit-only bans, the measuring word list, "again", solid counts, gating. Specifics:
- The Recognition lines tests are unchanged (LawsTests :1453/:1483/:1540, BinduMandalaUITests, AccessibilityReachTests:481, RecognitionNature timeline).
- Position-is-identity, the ledger vocabulary and the gratitude floor are unchanged.
- `CoherenceTests` :90–95 and :106–157 are unchanged.
- Rām japa, deep zoom, C-1284, the verdict ban and red-is-never-failure are unchanged.

The "strengthen" column (the shared PracticeStoreContract, the V38 Airtable allow-list, a verbatim check of every bake against its export date) was **not** built in Part C. It is not among items 1–8. Two partial pieces exist:
- `RulingTests` checks Maya's line and room 32's identity against the bakes.
- `WorldRegistryTests` checks the snapshot is the garland 1–102.

## New checks (items 3–7)

- **`RulingTests` (V34).**
  - Room 32: its bake holds only identity keys and `sealed: true`; no other room is sealed.
  - Room 32: none of 16 text properties reach its decoded view model; `ChakraTeaching.gate`/`threeWays`/`tatTvamAsi` are empty; its spoken label ends with "held for its own walk".
  - A planted bake that carries room 32's words still decodes sealed.
  - Axis = 18 and Crow = 19 (raw bake).
  - Ruling 4 reaches `RecognitionNature`: 31 flare, 40 disperse, 42 radiate, 43 pool.
  - Maya's line: road 30's `signaturePhrase` and `panelSeedMessage`, GameStructure panel 9's `seed`, and the bundled `GameStructure.file`.
  - "her siddhi is still on the instrument" appears in no production literal and in neither bake.
  - The two Recognition lines are in `RecognitionMomentView`.
  - No `AVSpeechSynthesizer` / `AVSpeechUtterance` / `AVSpeechSynthesisVoice` / `NSSpeechSynthesizer` / `AVSpeechSynthesisProviderAudioUnit` in production.
- **The snapshot source (item 4)** is wired as described above.
- **Launch arguments (item 5):** `OPEN_WORLD`, `WALK_OUT` (argument or environment), `WALK_TRACE=1`, `SNAPSHOT`, `SNAPSHOT_DIR`. All are DEBUG only.
- **`TheWalk` (item 6)**
  - `testTheWalkByTheMenu`: a cold launch, then the Mandala, Rite, Well, Field, Memory and Settings through the hamburger.
  - `testTheWalkByAddress`: all 15 worlds by `OPEN_WORLD`.
  - It writes `NNN-<step>.png`, `NNN-<step>.txt` (`.geom` lines plus `app.debugDescription`) and `walk.jsonl` under `WALK_OUT/<WALK_WAVE|U0>/<yyyyMMdd-HHmmss-test>/`. If `WALK_OUT` is not set it falls back to `$SIMULATOR_HOST_HOME/BinduWalk`, then the temporary directory. Every screenshot is also a `keepAlways` attachment.
  - Steps are data (`WalkStep`). U1 and U2 append steps.
  - Climb and game carry no sentinel in U0; they are recorded but not judged.
- **Parity helpers (item 7)** are the new files above. A missing Design file is a thrown error, which counts as a FAIL, never an `XCTSkip`.

## How each new check was shown able to fail (item 8)

Each new test carries its planted defect inside the suite, so it is proven red on every run:
- **Narrow floor:** `LawsTests.testTheDetectorCatchesWhatItIsFor`, `HomesHarnessTests.testTheDetectorItselfIsFaithful` and `TheWalk.testTheNarrowFloorCatchesHisPracticeAndOnlyThat` assert both directions: catches "felt 7 times", "visits: 4", streak, score, "your third time"; passes "Day 11", "3 of 9", "62%", "again".
- **Aniconic:** a synthetic `Image("kameshvari-portrait")` / `Image(systemName: "person.fill")` must trip.
- **Room 32:** a planted bake carrying its words must still decode sealed.
- **Named after-effect and TTS:** planted literals and sources must be caught.
- **Manifest:** a planted one-frame manifest with a missing source, an unordered band and a dangling `duplicateOf` must fail each check. A missing file must throw.
- **Luminance:** flat grey = 100; pure red has hue 0 and L = .2126 × 200. A room darkened by half fails ≥ 3 light-verdict clauses; a blown-out room fails.
- **Write diversion:** a body without the diversion must fail `divertsFirst`.
- **`OPEN_WORLD`:** an unknown world must open nothing.

Checked here in Python against the real files (`python3 -I`):
- The narrow-floor strings, both directions.
- The write-diversion scan passes on all 10 `AirtableService` entry points and fails on each when its diversion is removed.
- The snapshot decodes into every field `ShaktiFields`/`AvaranaFields`/`NityaFields` declares, with no type mismatch (102 / 9 / 15 rows).
- The 40 manifest sources exist and their md5s match.
- The luminance mean reproduces all 40 frames within 0.6 under box, bilinear and Lanczos resampling.
- The hue algorithm reproduces every chromatic frame within 1°.
- Room 32's bake keys are the identity set.
- Maya's line is in both bakes.
- Act 2 / Codex / Mirror counts are still 10 / 4 / 10 after the seal.
- No production literal carries a floor word.

**Not shown red here (it needs the Mac):** the UI suites and the walk. They need a simulator. Plant `OPEN_WORLD=nowhere`, or remove `WorldID` from `RootView`, and `testTheWalkByAddress` must report every world as not reached.

## API assumptions not verified by compiling

1. `nonisolated` access to `SnapshotSource.isActive` / `date` (static lets) from `@MainActor` code is fine. `SnapshotLedger` is `@MainActor`, and every caller is in `@MainActor AirtableService` or a `@MainActor` test.
2. The new `extension AirtableService` at the end of `AirtableService.swift` can use the class's `private` nested types and methods (same-file extension), and inherits `@MainActor` from the class.
3. `JSONDecoder` decodes `Page<ShaktiRow>` from the re-serialised `JSONSerialization` data (numbers stay integral for `Int?`). Checked in Python, not in Swift.
4. `CGImage.cropping(to:)` uses top-left pixel coordinates, matching the manifest's crop rects. `UIImage(data:)` decodes the `.webp` F40 (iOS 14+) and the JPEG-in-PNG frames.
5. `Insecure.MD5` from CryptoKit (iOS 13+) is available in the unit target, with `import CryptoKit`.
6. `XCUIElement.swipeDown(velocity:)` (iOS 14+) is used to leave the Settings sheet in `TheWalk`.
7. The UI test runner can create and write `WALK_OUT` on the host, and the simulated app can read `SNAPSHOT_DIR` on the host. This is true for the simulator, not for a device. On Xcode Cloud `SNAPSHOT_DIR` does not exist, so the app logs it and stays on its 16 seeded rows. The walk still runs; addresses outside Ring 2 will look sparse.
8. `FileHandle.seekToEnd()` / `write(contentsOf:)` (iOS 13.4+).
9. `static let addressWalk = TheWalk.worlds.map { … }`. `WalkStep` is a non-Sendable struct used in static lets (Swift 5 language mode assumed, as the rest of the target).
10. `RulingTests` reads `Chakra33` properties `act1Voice`, `act2Voice`, `teachingText`, `panelSeedMessage`, `gaiaVoice` (verified in `Models/ChakraConstellation.swift`), and builds a planted bake with only `road`, `recordId`, `name`, `kind`, `kp`, `address` (the same minimal shape `ChakraRoomTests.testABakeWithoutTheTeachingStillDecodes` already decodes).
11. In the pbxproj shell string, the new rsync lines are written in the same escaping as the existing ones. The script runs with `set -euo pipefail`; a missing `Design/` is guarded by `if [ -d … ]`.
12. A few retirements leave a loop with only `scene.pose(at: t)` and an unused `row`. That gives warnings, not errors.

## Left for later waves / open

- **HomesCorpus 102-row fixture** (VER-S-0619): replace the 86 synthetic rows with the dated export. Not done. It changes the inputs of a dozen divergence suites and needs a run to judge. The snapshot is now readable by tests (`WorldRegistryTests` reads it), so this is a small step in U4.
- **Not built in U0:**
  - PracticeStoreContract (V35)
  - Airtable allow-list (V38)
  - A `Waves` test plan (V46: the session does it on the Mac)
  - Geometry parity engine (V04)
  - Sound measurement (V08)
  - The padakarshini gate (V21–V25)
  - `walk.html` (V20's report page)

  This part laid only the helpers and the walk record they build on.
- **`SpikeColdLaunchTests`** still uses `START_TAB=mandala` (U1 retarget).
- **Part B side-effect:** the `.metal` is excluded from Debug too, so `SpikeGarimaSceneKitTests` may render without its light pass (B's report, point 6).
