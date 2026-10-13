# U0 · Part B report — data, seal and rulings (builder B)

Branch `upgrade`, 13 Oct 2026. Four commits (not pushed):

| Commit | What |
|---|---|
| `6994945` | Design corpus and the forty frames into the repo |
| `ca00818` | Re-bake ChakraConstellation and GameStructure from the 13 Oct export |
| `58c603a` | Seal chakra 32 on every route (ruling 2) |
| `18c5336` | Rulings and data fixes: ruling 15, C05–C07, C12, C14, the spike shader, ruling 16 |

No Swift compiler was available here. Every Swift change was made after reading the types and call sites it touches. Nothing under `waves/upgrade/snapshot/raw-*` was committed. `Config.local.xcconfig`, secrets, the SwiftData schema and the Recognition lines were not touched. No file under `iOS/Bindu MandalaTests` or `iOS/Bindu MandalaUITests` was edited.

## 1 · Design corpus (item 1)

- `Design/Corpus/` is a byte-for-byte copy of `/home/claude/design-upload/extracted/` (162 files).
- `Design/Chakra/` is a byte-for-byte copy of `/home/claude/chakra-upload/extracted/` (69 files).
- `diff -r` against both sources is clean. `.gitignore` drops nothing in them, and a secret scan found nothing. `Design/Chakra/CLAUDE.md` is part of Design's export and is kept as is; the README says so.
- **F40 deviation.** The measured F40 (320×304, mean 218.7) is not the upload's `.thumbnail`, which is 640×631 with a mean of 1.3. It is the repo's `Claude Designs/.thumbnail`: re-measured, it gives exactly 1.4 / 16.6 / 218.7 / 238.9 / 239.9. I copied it byte for byte to `Design/Frames/F40-claude-designs-thumbnail.webp`, and frames.json points there.
- `Design/frames.json` is an object `{title, measuredOn, spec, method, rules, frames:[…40]}`. Each frame has:
  - id, world, what
  - `source` (repo-relative path) and `corpusPath`
  - `crop` (`[x0,y0,x1,y1]`, or null for the whole image)
  - `luminance` {min, p5, mean, p95, max}, hue, chromaPercent
  - comparison
  - `duplicateOf`: set only when the md5 is identical — F06→F05, F16/F17→F15, F20→F19
  - `comparedAs`: also covers F12→F11, F30/F31→F32 and F35→F34, which are near-duplicates, not identical
  - md5
- **Luminance cross-check.** I re-measured all 40 crops on a 64×64 grid with Rec.709 luminance. F01–F39 agree with verification.md §1.4 to within 0.5. Hue and chroma were taken from the table and not re-measured.
- `Design/README.md` says what the folder holds, where it came from, that tests read it, and that it is never edited.
- `Design/manifest.sha256` hashes every file (232 lines). `cd Design && sha256sum -c manifest.sha256` passes.

## 2 · ChakraConstellation.json re-bake (item 2)

- **Script:** `waves/wave-3/bake_chakra_constellation.py`, updated.
- **Command:**
  ```
  python3 -I waves/wave-3/bake_chakra_constellation.py waves/upgrade/snapshot/raw-after-2026-10-13/map.json "iOS/Bindu Mandala/Data/ChakraConstellation.json" waves/upgrade/snapshot/raw-after-2026-10-13/bindu-field.json --baked-on 2026-10-13
  ```
- **Script compatibility check.** Before changing it, I ran the old script on the raw-after export and diffed the result against the shipped bake. The only difference was Maya's Signature Phrase (C08), so the export format matches.
- **All 44 existing keys are kept and none is renamed.** New keys use the Map's own field names (C13): teachingText, postEngagementTeaching, shaktiFunction, tree, treeCaption, dyadDescription, colorDyad, mindTriad, storyPortalHeadline, panelVerb, panelSeedMessage, gaiaVoice, shaktiPractice, thresholdArchitecture, url, buildStatus, linkedBuilds (record ids), plus `binduFieldRecordId`.
  - `binduFieldRecordId` is filled for roads 2–9, 30 and 31, using the D12 join. The bake asserts each id's Track ID and Verb against the Bindu Field export.
  - Body Location, Shakti Name and Shakti Mudra were already in the bake as `bodyLocation`, `shaktiName` and `mudra`.
  - Gaia Voice and Shakti Practice are now included, per ruling 17. data.md B06 had called them "never baked"; the brief and the UPGRADE-MAP settled points supersede that.
  - I also added data.md B01's extras (Tree, Threshold Architecture, URL, Build Status, Linked Builds).
- **Room 32 is sealed.** Its entry holds exactly: road, recordId, name, subtitle, verb, colorHex, primaryColor, shaktiName, mudra, plus the bake's structural join (kind summit, avarana 8, kp [101], address seat, crossing null) and `sealed: true`. The structural keys are there because `Chakra33` requires `kind`, `kp` and `address`. Room 32's `joinedBy` is dropped because it quoted its Shakti Function.
- **Bake checks:** roads 1…33, kp within 1…102, and "CANON INCOMPLETE" if any room lacks recordId, name, verb or colorHex.
- **Result:** 33 rooms × 62 keys (room 32 has 15). 535,136 B, md5 `e359be9b`, bakedOn 2026-10-13.
- **Verification:** `waves/wave-3/verify_chakra_constellation.py BAKE MAP SCHEMA` (new, and independent of the bake). It maps each key to its Map field name and resolves the id through schema.json.
  - **PASS:** 1,736 Map cells compared, 1,428 of them strings, all byte-equal to the export cells. None of the export cells had outer whitespace, so the bake's `.strip()` changes nothing.
  - Room 32 has exactly its allowed key set, and none of its sealed cells, or lines of them 24 characters or longer, appear anywhere in the bake.
  - **Born red:** a trailing space planted in Maya's phrase plus a gateText planted on 32 → FAIL (3 failures). The previous (unsealed) bake → FAIL with 8+ "LEAK of sealed field" lines.

## 3 · GameStructure.json re-bake (item 3)

- `waves/wave-6/bake_game_structure.py` now takes `--export DIR`, which reads `identity.json` and `map.json` instead of the API, and `--baked-on`.
- `verify()` now checks every line, including the axis block and the face and practice names. Panels, faces, practices and axis must equal the whole cell; Leela drop lead and action must be substrings of the Leela Story.
- Maya's ring-9 seed is now "There was never anything to fear. There was only You, playing." (ruling 8). bakedOn is 2026-10-13.
- **PASS:** "verified: every line is verbatim (71 lines checked)" against raw-after.
- **Born red:** against raw-before it fails with `not verbatim: [('panel seed', 9)]`.
- "Bindu, playing" now appears nowhere under `iOS/`.

## 4 · Chakra 32 sealed (item 4)

- `Models/ChakraConstellation.swift`:
  - adds `sealedRoad = 32` and `sealedLine = "held for its own walk"`
  - `Chakra33` gains the new optional keys, `sealed: Bool?`, `isSealed` (the flag or road 32) and `sealedIdentity`, which rebuilds the chakra through the memberwise init with only its public cells
  - `decode` reduces every sealed room to `sealedIdentity`, so no route can read its words even from an older bake
  - `spokenLabel` appends the sealed line for a sealed room
- `Views/Chakra/ChakraRoomView.swift`: a sealed room shows name, subtitle, verb, a held mark (`SealedThresholdMark`) and "held for its own walk". It has no story, practice, wake-up, gate, doors or ledger write. Its a11y element combines those words only.
- `Views/Chakra/ChakraRoomDoor.swift`: new `SealedThresholdMark`, a closed ring with a point breathing on a 12 s breath, still under Reduce Motion, hidden from a11y.
- `Views/Mandala/ChakraLayerOverlay.swift`: the Road's station for 32 shows the sealed line instead of its Core Question and story thread. The hint reads "Opens its held threshold. The road waits."
- `Views/Mandala/ChakraConstellationLayer.swift`: `Entry.sealed` added, and the constellation door hint for 32 reads "Opens its held threshold."
- `Models/ChakraTeaching.swift`: `homeDoor` and `games` return nothing for a sealed room, which closes the Shadow Translator door (game at kp 101, offered through room 32). The Shadow Translator stays in A Strange Game. No other route leads from a game into room 32.
- **Whole-app scan:** none of room 32's 107 non-public text lines (24 characters or longer, from the export) appears in any file under `iOS/`. Other readers of `ChakraConstellation.all` (PlayGamesPattern essence, Leela board, MandalaThresholdMoment, ClimbBodyChakras) only get nil for 32 now. The Leela board already holds square 32.

## 5–10 · Rulings and data fixes

- **Ruling 15:**
  - `Homes/HomeAfterEffect.swift`: `line`, `lineHolds` and `lineShows` removed; the comments are updated.
  - `Views/Rooms/HerSiddhiLingers.swift`: the text overlay and its state are removed. The felt after-effect (lift, the four kinds, 180 s) is unchanged.
  - `Views/Rooms/RiteOfEnteringView.swift`: comment only.
  - "still on the instrument" now appears nowhere in the app source.
- **C07:** `Data/ShaktiBootstrap.swift` bīja for kp 37–44 is now ḷṁ ḹṁ eṁ aiṁ oṁ auṁ "aṁ — anusvāra" "aḥ — visarga". The kp 41 name is now "Bījākarṣiṇī". A script check confirms all 16 bījas and names byte-equal the Mandala export. `bijaSyllable` already cuts at " — ".
- **C05 and C06 needed no code change.**
  - No app source takes a kp 1–102 name or quality from `all-shaktis-data.js`. A grep for the Ring 4 names miscopied into Ring 1 finds nothing in the app.
  - Ring 8 in the app already follows the base: SourcingRoom maps 0 icchā, 1 kriyā, 2 jñāna, and HomesCorpus orders Icchā, Kriyā, Jñāna. The 801–803 roster swap exists only in Design's data file.
  - `RingAudioService.r8Frequencies` keeps Design's tuning order "Icchā · Jñāna · Kriyā". It is a list of frequencies, not labels, and its `.vertex` path has no caller.
- **C12:**
  - `Theme/Element.swift`: `.light` already existed (ring 9), and every `switch` over `Element` already handles it (grep checked: ActivationCycle, RiteComposition, DustMotes, GarimaSceneKitRoom, RecognitionLight, RecognitionNature with light → radiate, AtmosphereBackground, LightField).
  - Added `ring2ByKp` (29 earth, 30 water, 31 fire, 32 air, 33 ether, 34 fire, 35 water, 36 earth, 37 ether, 38 earth, 39 water, 40 air, 41 fire, 42 light, 43 water, 44 earth) and `forRing2(kp:)`.
  - `Shakti.element` reads the kp table first, then the old tattva parse and ring table.
- **C14:** Chakra Practiced already set `Link to The Map`. The other room-born event is a game opened through a room's door. That path now passes `fromRoom: mapRecordId`:
  - `Views/Chakra/ChakraRoomView.swift`: `ChakraRoomExitView.mapRecordId`
  - `Views/Play/PlayGame.swift`: `PlayField.host(_:atPosition:fromRoom:onClose:)`
  - `Views/Play/PlayGameHost.swift`: `mapRecordId` plus an init parameter defaulting to nil, so its `Played` row carries `linkToMap`.
  - Leela drops are not room-born and were left unchanged.
- **Spike shader:**
  - `iOS/Bindu Mandala.xcodeproj/project.pbxproj`: `Views/Spike/GarimaSceneKitRoom.metal` added to `membershipExceptions` (set `D3E4F5A6B7C8D9E0F1A2B3C4`). The path was checked.
  - Header comments updated in the `.metal` and `GarimaSceneKitRoom.swift`.
- **Ruling 16:**
  - `Services/RiteDay.swift`: `GraceChannel.restDays` changed from 3 to 0. Grace still never repeats a moment.
  - `Services/RiteOpenings.swift`: new `RiteOpening.oncePerHalfDay = false`, so `opens` returns true. New `RiteStation.oncePerDay = false`.
  - `Views/Today/DailyRiteView.swift`: the opening comes once per arrival. A new `@State openingGiven` stops `finishOpening → beginArrival` from looping. The closing stations come whenever she is felt.
  - `Services/LeelaDrops.swift`: "never in the first days" removed. ≥ 3 days apart (`minimumGapDays = 3`) and `chance = 0.3` are kept, and the `shouldDrop` signature is unchanged. The dissolutions' once-a-day rule was not touched.

## Every file touched

**Added**
- `Design/Corpus/**` (162 files)
- `Design/Chakra/**` (69 files)
- `Design/Frames/F40-claude-designs-thumbnail.webp`
- `Design/frames.json`, `Design/README.md`, `Design/manifest.sha256`
- `waves/wave-3/verify_chakra_constellation.py`
- `waves/upgrade/briefs/U0-B-report.md` (this file)

**Modified (scripts and bakes)**
- `waves/wave-3/bake_chakra_constellation.py`
- `waves/wave-6/bake_game_structure.py`
- `iOS/Bindu Mandala/Data/ChakraConstellation.json`
- `iOS/Bindu Mandala/Data/GameStructure.json`

**Modified (Swift and project), under `iOS/Bindu Mandala/`**
- `Models/ChakraConstellation.swift`, `Models/ChakraTeaching.swift`
- `Views/Chakra/ChakraRoomView.swift`, `Views/Chakra/ChakraRoomDoor.swift`
- `Views/Mandala/ChakraLayerOverlay.swift`, `Views/Mandala/ChakraConstellationLayer.swift`
- `Homes/HomeAfterEffect.swift`, `Views/Rooms/HerSiddhiLingers.swift`, `Views/Rooms/RiteOfEnteringView.swift`
- `Data/ShaktiBootstrap.swift`, `Theme/Element.swift`
- `Views/Play/PlayGame.swift`, `Views/Play/PlayGameHost.swift`
- `Services/RiteDay.swift`, `Services/RiteOpenings.swift`, `Services/LeelaDrops.swift`, `Views/Today/DailyRiteView.swift`
- `Views/Spike/GarimaSceneKitRoom.metal`, `Views/Spike/GarimaSceneKitRoom.swift` (comments only)
- `iOS/Bindu Mandala.xcodeproj/project.pbxproj`

## Swift API assumptions I could not verify (check first on the Mac)

1. **`Chakra33` memberwise init in `sealedIdentity`.** The synthesized `Codable` conformance should not suppress the memberwise init. The call passes every `let` in declaration order and skips the defaulted `var`s except the last one, `sealed:`. Swift allows that.
2. **`ChakraRoomExitView(exit:mapRecordId:onDone:)`** relies on the memberwise init. The struct has a `private @Environment` property, which makes the memberwise init fileprivate. The only call site is in the same file.
3. **Optional `let`s missing from room 32's JSON** (subtitle, sanskrit and so on) should decode through the synthesized `decodeIfPresent`.
4. **`SealedThresholdMark`** uses the existing `GraphicsContext.glow` and `.core` extensions from `Views/Play/PlayInstruments.swift`. It declares `let` inside `TimelineView`'s ViewBuilder closure and does multi-statement work in the `Canvas` closure, the same pattern as `ChakraRoomField`.
5. **`ChakraLayerOverlay.roadWords`** has a new `if c.isSealed { … } else if let q = … { … }` inside a ViewBuilder `VStack`.
6. **Removing the `.metal` from the target also removes it from Debug.** At runtime `ShaderLibrary.garimaLightPass` will find no function. It still compiles, because it is dynamic member lookup, but the spike's light pass renders nothing, which may affect SpikeGarimaSceneKitTests. If that matters, the alternative is to restore the membership and set `EXCLUDED_SOURCE_FILE_NAMES[config=Release] = GarimaSceneKitRoom.metal` in the app target's Release build settings. I did not do this: the brief asked for `membershipExceptions`, and I have not verified that this setting works with synchronized groups.
7. **Possible compiler warning, not an error:** "will never be executed" after `guard oncePerHalfDay else { return true }`.

## Tests Part B breaks (builder C was messaged with this list)

- **Compile errors:** `HomesWaveOneTests.swift:248, 272, 295–296` use the removed `HomeAfterEffect.line`, `lineHolds` and `lineShows`.
- **Will fail:**
  - `ChakraRoomTests` on road 32: testEveryRoomCarriesTheMapsTeaching, testEveryRoomHasThreeWaysIn, testTheGateNamesItsOwnButton. The station test still passes.
  - `ElementTests.swift:32–35`: kp 33 now gives ether, kp 34 gives fire.
  - `GameStructureTests.swift:117`, the "first days" clause.
  - `ModesAndRitesTests.swift:187`, the twice-a-day opening.
- **Possible merge point:** builder C's worktree also edits app files (RootView, LivingMandalaView, PlayFieldView, TheHundredTwoView). None of those overlap with mine, but `project.pbxproj` may.

## Not done / left as found

- C11 (Airtable choices) and C16 (bootstrap statuses and tattvas) were not in Part B's list. The bootstrap still seeds Design statuses and tattvas.
- `bake_chakra_constellation.py` was updated in place rather than moved to `tools/`, as the brief directs.
- No Swift build or test run was possible here.
