# U0 · Ground — wave brief

Branch: `upgrade`. U0 is the ground every later wave stands on. Most of it is invisible to Ashrey: the data is made true, chakra 32 is sealed, his rulings are enforced, the tests stop enforcing restrictions he lifted, and the proof system exists. **No world is redesigned in U0** — the spine, Home and the worlds come in U1/U2 onward.

## Read first (in full)

- `waves/register/READER-BRIEF-2.md` — the foundation, fifteen worlds, rulings 1–10, floors.
- `waves/upgrade/INDEX-BRIEF.md` — rulings 11–17 and the settled points.
- `waves/upgrade/UPGRADE-MAP.md` — the whole map and the answers of 13 Oct.
- Your part's sections listed below in `waves/upgrade/worlds/data.md` and `waves/upgrade/worlds/verification.md`.

## The build environment — read this twice

There is **no Swift compiler here** (Linux container). The code is compiled and tested on Ashrey's Mac afterwards. So:
- Write Swift that compiles first time: match the existing code's style, imports and types exactly; read every type you call before calling it; no invented APIs; iOS 17+ SwiftUI; Swift 5.9+.
- The Xcode project uses **file-system synchronized groups**: a new `.swift` file placed under `iOS/Bindu Mandala/`, `iOS/Bindu MandalaTests/` or `iOS/Bindu MandalaUITests/` is in its target automatically. Resources under `iOS/Bindu Mandala/` are bundled automatically. To keep a file **out** of the app target, add its path (relative to `iOS/Bindu Mandala/`) to `membershipExceptions` in `iOS/Bindu Mandala.xcodeproj/project.pbxproj` (the set `D3E4F5A6B7C8D9E0F1A2B3C4`).
- Keep a running list of every file you touch and every assumption about an API you could not verify, in your part's report, so the Mac build can be fixed fast.
- Never touch: `Config.local.xcconfig`, secrets, git config, practice-data stores' schemas (SwiftData V3 stays V3), the Recognition lines.

## Floors (every part)

Practice data never lost or duplicated · position (kp) is identity · App Activity the single ledger · "she was felt here" / "and she felt you back" verbatim · no generated voice · nothing invented (baked text verbatim) · letters and journals private · no figure of a Śakti · nothing scores him · accessibility.

---

## Part B · Data, seal and rulings (builder B)

1. **Design corpus into the repo.** Copy `/home/claude/design-upload/extracted/` (every file and folder, byte for byte) to `Design/Corpus/` at the repo root, and `/home/claude/chakra-upload/extracted/` to `Design/Chakra/`. Write `Design/frames.json`: F01–F40 from `verification.md` §1.4 (id, world, what it is, source path inside `Design/Corpus/`, crop rect, L min/p5/mean/p95/max, hue, chroma, comparison notes, duplicateOf). Write `Design/README.md` (what is here, where it came from, that it is read by tests, never edited).
2. **Re-bake `Data/ChakraConstellation.json`** from `waves/upgrade/snapshot/raw-after-2026-10-13/map.json` (and the Mandala export there) with `waves/wave-3/bake_chakra_constellation.py`, updated per `data.md` §2 B01 and §4.4: Map names govern (C13); add the energy fields the rooms now carry (Teaching Text, Post-Engagement Teaching, Shakti Function, Tree Caption, Dyad Description, Colour Dyad, Panel Verb, Panel Seed Message, Mind Triad, Story Portal Headline, Gaia Voice, Shakti Practice, Body Location, Shakti Name, Shakti Mudra) — ruling 17: everything shown word for word; **room 32: carry only its public identity cells** (name, verb, colour, subtitle, Śakti, mudrā, book position, record id) — every other field of room 32 is omitted from the bake entirely; `bakedOn` = 2026-10-13. Then a script check that every baked string equals its export cell byte for byte. Keep every existing key the app reads (grep the Swift for each key before renaming anything; renames are not allowed in U0 — add new keys only).
3. **Re-bake `Data/GameStructure.json`** with `waves/wave-6/bake_game_structure.py` adapted to read the raw-after exports instead of the live API (Identity is in `raw-after-2026-10-13/identity.json`). Maya's ring-9 seed now reads "…There was only You, playing." (ruling 8). Verify every line is a substring of its export cell.
4. **Seal chakra 32** in the app on every route: `Views/Chakra/ChakraRoomView.swift` (room 32 shows only its identity and a held, quiet threshold — "held for its own walk" — no text body), the Road's station for 32, the constellation, the Shadow Translator door into it, accessibility labels. Grep the whole app for any other place room 32's text could render.
5. **Ruling 15:** remove the named after-effect line "her siddhi is still on the instrument" from `Homes/HomeAfterEffect.swift` (keep the felt after-effect itself).
6. **C05–C07 (data.md §2 rows 20–22):** `Data/ShaktiBootstrap.swift` bīja series = the Airtable series for kp 29–44 (aṁ āṁ iṁ īṁ uṁ ūṁ ṛṁ ṝṁ ḷṁ ḹṁ eṁ aiṁ oṁ auṁ "aṁ — anusvāra" "aḥ — visarga"); Ring 8 labels follow the base (kp 100 Vajreśī Kriyā, kp 101 Bhagamālinī Jñāna) wherever the app roster swaps them; no kp 1–102 name/quality taken from Design's `all-shaktis-data.js`.
7. **C12 elements (ruling 4):** `Theme/Element.swift` gains a `.light` case for ring 2 use (ring 9 stays light); an explicit kp → element table for kp 29–44: 29 earth, 30 water, 31 fire, 32 air, 33 ether, 34 fire, 35 water, 36 earth, 37 ether, 38 earth, 39 water, 40 air, 41 fire, 42 light, 43 water, 44 earth. Every `switch` over `Element` handles `.light` (grep all of them). Recognition natures: light → radiate.
8. **C14:** every room-born ledger event (Chakra Practiced and any room event) sets Link to The Map with the room's Map `recordId` (data.md §2 row 29; `Data/ActivityLedger.swift`).
9. **Spike shader out of Release:** add `Views/Spike/GarimaSceneKitRoom.metal` to `membershipExceptions` (check the exact relative path first).
10. **Remove app-added limits (ruling 16)** only where they are simple constants: grace's rest, the twice-daily opening, the once-a-day closing stations. Keep his own: dissolutions once a day; Leela drops ≥ 3 days apart then 30 %. Remove Leela's "never in the first days" rule.

## Part C · Tests and the proof system (builder C)

1. **Retire or rewrite every lifted-rule test** listed in `verification.md` §2.2 (90 references — follow each row's action exactly). **Keep every floor test** in §2.3 (97). Where a kept suite has a lifted clause, delete only that clause.
2. **Element tests** per ruling 4 (light branch; kp 31 fire, 40 air, 42 light, 43 water) and **Leela**: pin `minimumGapDays = 3` and `p = 0.30`, retire the "first days" clause.
3. **Ruling tests (V34):** chakra 32's body text absent from the bake and from every view model / a11y label; Maya's line "only You, playing" in both bakes; Axis 18 / Crow 19 in the bake; the "her siddhi is still on the instrument" string absent from the app; the two Recognition lines verbatim; no TTS API used anywhere (scan sources for AVSpeechSynthesizer).
4. **The snapshot source:** launch argument `SNAPSHOT=2026-10-13` makes the app read `Bindu MandalaTests/Snapshot/2026-10-13/*.json` (copy them into the app bundle under `Snapshot/` for DEBUG only, or load from the test bundle via an environment path) instead of Airtable, and every ledger write goes to an in-memory mock — never a live POST/PATCH. Read `Services/AirtableService.swift` and the stores fully before wiring this; keep the existing `SYNC_OFF` path working.
5. **Launch arguments for the walk:** `OPEN_WORLD=<id>`, `WALK_OUT=<absolute host path>`, `WALK_TRACE=1`. Define `enum WorldID: String, CaseIterable` with the fifteen worlds + `home` (home, today, mandala, rings, herHome, herPresence, climb, the33, game, modes, time, memory, well, beneath, relationship) in `Services/WorldID.swift` — U1 builds the router on it. For U0, `OPEN_WORLD` maps to the closest existing screen (document the mapping).
6. **The walk driver (XCUITest):** `Bindu MandalaUITests/TheWalk.swift` — cold launch with `SNAPSHOT` + `SKIP_HOMECOMING`, visit every existing top-level destination by its current route, write a PNG screenshot and an accessibility-tree dump per step to `WALK_OUT/<wave>/<run>/NNN-<step>.png|.txt`, and append a line per step to `walk.jsonl`. Build it so U1/U2 only add steps.
7. **Parity helpers (unit test target):** `DesignCorpus` (finds files under `Design/Corpus/` — add `Design/` as a folder reference to the test target's bundle, or read via `#filePath`-relative paths as existing tests do — read how `HomeWorldsTests`/`WorldClimbTests` load Design files and use the same mechanism); a missing Design file is a FAIL, never `XCTSkip`. `Luminance` (mean/p5/p95 of a rendered `UIImage` on a 64×64 grid). `FramesManifest` test: `Design/frames.json` has F01–F40 and every source file exists.
8. Everything you add must fail on a planted defect first (note in your report how you checked each new test can fail).

## Done when

- Part B and C reports list every file touched and every unverified API assumption.
- The branch builds and the test plan runs on the Mac (done by the session, not you).
