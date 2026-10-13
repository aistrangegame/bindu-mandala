# U1 · Part D report: Gesture and Score (builder D)

Branch `u1-d`, cut from `upgrade` at `f22eb7e` (the U1 brief). Not pushed.

**There is no Swift compiler here, so none of this has been compiled or run.** I read every type before calling it. The engines' arithmetic was checked in Python against the real data. The hold engine was ported and run frame by frame. The validator was ported and run over all 46 Score JSON rows in the snapshot. The Mac build and the test run are the session's job.

## Commits

| hash | what |
|---|---|
| `bd4416c` | The hold engine, the haptics library and the Score player, with `U1DTests` |
| (this file) | Report |

## Files

All new. Nothing outside `Instruments/` was touched: no hooks, no pbxproj edit (the synchronized groups pick the folder up).

| file | what |
|---|---|
| `iOS/Bindu Mandala/Instruments/HoldEngine.swift` | `HoldLadder` (every duration as a named constant), `HoldSource`, `HoldEvent`, `HoldEngine` (G0; pure, the time is passed in) |
| `iOS/Bindu Mandala/Instruments/HoldGesture.swift` | `HoldDriver` (gives the engine its frames and its feel), `HoldModifier` / `OwnedHold`, `View.hold(for:drain:named:onCommit:onComplete:)` and a `driver:` variant for a view that draws the light |
| `iOS/Bindu Mandala/Instruments/HapticLibrary.swift` | `HapticEvent`, `HapticPattern` (sound.md S78 / S53 / S71 / S36 as data), `HapticLibrary` (Core Haptics, UIKit fallback) |
| `iOS/Bindu Mandala/Instruments/ScoreJSON.swift` | `ScoreJSON`: any JSON value. The validator reads this tree, the way validate.py reads dicts |
| `iOS/Bindu Mandala/Instruments/ScoreV2.swift` | `ScoreV2: Codable`: every section of Score Format v2.0, plus `ScoreBeatHz` and `ScoreTrigger` |
| `iOS/Bindu Mandala/Instruments/ScoreValidator.swift` | `ScoreValidator` (21 rules), `ScoreFinding`, `ScoreValidation`, `ScoreRefusal`, `LoadedScore`, `ScoreLoader` (validate, then decode or refuse) |
| `iOS/Bindu Mandala/Instruments/ScoreTimeline.swift` | `ScoreTimeline`: the cues and the continuous laws on one clock. Also `ScoreCue`, `ScoreLane`, `ScoreLedgerWrite`, `ScoreAudioData` (the `-data.json` streams and `SC()`) |
| `iOS/Bindu Mandala/Instruments/ScorePlayer.swift` | `ScoreClockSource`, `FreeScoreClock`, `ScorePlayer`, `ScoreStatus`, `ScoreCatalogRow`, `ScoreCatalog` (reads the Bindu Field row) |
| `iOS/Bindu MandalaTests/U1DTests.swift` | 27 tests |
| `waves/upgrade/briefs/U1-D-report.md` | this report |

## What each engine does, and what it reuses

### HoldEngine (item 1)

`tick`, `press`, `release` and `cancel` follow G0 exactly, from the-33 §2 row 31 and register `11-padakarshini-forms.md:235-270`:
- `dt = min(64 ms, t − last)`.
- Progress rises over UP and drains over DOWN.
- At full the engine **commits** (the visual threshold). It **completes** only on the release that follows.
- An early release drains (DOWN 620–750 ms). Pressing again rises from where the light is.
- A key repeat is ignored. A release from a source that is not the one holding is ignored.
- `cancel` (movement > 9 pt) drains and never acts, even after the commit.
- `performByVoice()` is the accessibility action. It commits and completes at once, following `TheWayOut`'s own law: "A voice performs an action; it never holds one".

**`HoldLadder`**
- **The brief's five:** readiness 750, gate 1100, story 1800, send 2300 (drain 620), covenant 5000.
- **Drain:** 750 by default, in a band of 620–750.
- **The room-gate ladder:** 3500 · 3200 · 2800 · 2600 · 2400 · 2000 · 1800 · 1500, by Road number (2–8 and 31). Road 1 is the covenant. Body and Mind rooms return nil, because their gates are instruments.
- **The rest of the-33 row 32:** veil 1800, wake-up opening 5000, forms-of-time ring 1100, withdraw 2200, story beat 1500, carve 2200, lay down 2600, die 2200, shadow corridor step 700.
- **Geometry:** cancel 9 / 7 (the Door) / 24 (still touch); tap < 9 pt and ≤ 700 ms.
- **The ramp:** 0.15 → 0.6 at sharpness 0.3.

**`HoldDriver` and `.hold(…)`**
- Frames come from a `@MainActor` task loop at 16 ms. It runs only while the engine is held or draining, so there is no render loop at rest (the RoomView reduce-motion law).
- The touch is a `DragGesture(minimumDistance: 0)` with the 9 pt cancel.
- Hardware keys come through `.focusable()` and `.onKeyPress(keys: [.return, .space], phases: [.down, .repeat, .up])`, with repeats ignored.
- Accessibility: the label names the act, the `.isButton` trait is set, the value is "N percent" while held, and `.accessibilityAction` performs the act.
- Haptics:
  - a tick at the press;
  - the continuous ramp, steered by `hapticIntensityControl`;
  - one latch (completion .8/.5) at the commit;
  - nothing on an early release.
- Reduce Motion does not change the duration.

**Wraps or replaces:** nothing in U1. The existing `onLongPressGesture` holds (1.4 s chakra, 2.2 s way out, 2.8 s Door) are left alone; U2 onward move them onto `.hold`.

### HapticLibrary (item 2)

**The S78 library as pure data (`HapticPattern`):**
- **Gestures:** tick and word .3/.4, heart .5/.3, completion .8/.5, recognition (the peak at every Recognition, felt as completion), kindle .6/.2, Descent .9/.15 at 55 % of the passage, Still Point .25 → .15 → none.
- **Panels:** gate 80, continue 40 and pivot 50 ms. Also press start 12 and press complete 20-40-30.
- **The Scores' set:** crossing (footsteps `[12,40,12,40,12,60,30,12,40]`), bell, mirror, strike, thunder roll, charge at 46 bpm, hit `i·20 ms` when i > .4, drop 100 ms.
- **Pulses:**
  - **heartbeat:** 60 bpm, transient .35/.15 (S53, from Shadow to the Reveal);
  - **the long-silence heart:** 50 bpm, [30];
  - **Ring 7's breath:** .12/.1 on a 15 s period.
- **The element grammars (S71):** earth, fire crackle and backdraft, heart thub ×3, gasp, ambient, throat, silence.

`HapticPattern.vibration(_:ms:)` turns a web vibrate array into events: a pulse under 30 ms becomes a transient, a longer one a continuous segment.

**`HapticLibrary` (`@MainActor`):**
- Plays a pattern with `play`, runs looping pulses with `startPulse` / `stopPulse` (`CHHapticAdvancedPatternPlayer`, `loopEnd = period`), and drives the hold's ramp.
- Falls back to `UIImpactFeedbackGenerator` (soft below .7, medium above) when the hardware has no Core Haptics.
- Is silent in the unit-test host and when the switch `instruments.haptics.enabled` is off. That switch is a UserDefaults convenience the Sound sheet will own.

**Wraps or replaces:** `Theme/Haptics.swift` (three `UIImpactFeedbackGenerator` calls) is left as it is. Per S78 its callers "route into" the library, and that rewiring is U2's.

### ScorePlayer (item 3)

**Parse → validate → refuse or play.** `ScoreLoader.load` works in three steps:
1. It parses the document into `ScoreJSON`.
2. It runs the validator over that tree.
3. It throws `ScoreRefusal` (with every failed rule) on any failure, then decodes the typed `ScoreV2`. A decode error after the rules have passed is also a refusal, filed under R2 "wrong shape".

Warnings never refuse.

**The 21 rules:**

| group | rules |
|---|---|
| Structural | R1 schema · R2 the nine required · R3 id pattern |
| Temporal | R4 every time inside [0, dur + 0.05]: phases, silences, peak, both anchor peaks, mirror times, beat untils; a missing duration fails · R5 phases ordered, no overlap · R6 silences ordered, no overlap · R7 peak inside a phase · R8 return before the end · R9 beats ordered, final `until` null |
| Semantic | R10 max_blend in [0,1], 1.0 only for the Return's spiral (path and shape_choreography) · R11 exactly the seven dancers · R12 two-letter families with words · R13 derivation one of four · R14 imposed needs a reason · R16 HARD: no Hz in resonance_link (a key naming hz, hertz or freq, or a string like "528 Hz") · R17 footprint with silences |
| Advisory | R15 unknown vocabulary module → Layer 1 · R18 global boost < 0.7 · R19 no haptic at peak_t · R20 peak not authored with no reason (Appendix A) · R21 `needs_listening` (V42) |

**`ScoreTimeline`: a validated Score laid on one clock.**

Cues, each on one lane:

| lane | cues |
|---|---|
| words | phases; his word at `word_reveal.at`; "I Love You" at the Score's own offset (`"peak_t - 3"`); `ended` |
| light | silences begin and end; mirror words; Tier 0 windows (`[[0,2],["end-1","end"]]`, else first 2 s and last 1 s); the Tier 4 climax window |
| sound | the beat steps and ramps; voice cues for his recordings (OL-3 only) |
| haptics | the Score's patterns by `fires_at` (peak_t, mirror-word, bell-hit with the song's data, seconds); the song's own hits and drops when `-data.json` is given |
| motion | shapes (`trigger_at`: seconds, peak, return, `phase:<name or index>`, `silence:<index>`, ± offsets); the Return with its dissolution order |
| ledger | one write at the Return |

Laws, read at any `t`:

| law | how |
|---|---|
| beat | ramps interpolated; Karishma's freeze: inside a silence the beat holds its value at the silence's start |
| binaural gain | `.045 + .015 sin(.18 t) + .025 (1 − E)`, × the Score's phase multiplier (first window that holds `t`, in Score order), × the final ramp, clamped to the 0.003–0.050 bus band |
| song gain | 0.8, faded in over 3 s |
| Tier 4 global boost | `1 + factor ×` (ramp in, hold, ramp out) |
| others | `isReturning`, `isThreshold`, the seed's seconds per character (the Score's own, else 60 / bpm) |

**Words:** `fruitWeaves` drops every weave that counts him (conditions on `prior_…`, count or times, or text with `{n}`). sound.md S56 says "nothing counts him".

**`ScorePlayer` (`@MainActor`):**
- **The one clock:** the song's sample time through `ScoreClockSource` (Part B's SONG bus conforms in U2), or `FreeScoreClock`.
- **Ticking:** a task loop runs at about 30 Hz while playing. "Animation starts only once currentTime > 0" when a song drives it.
- **Firing:** `advance(to:)` fires each cue the clock passes exactly once, in order. A reading earlier than the last is a seek: it re-syncs and fires nothing.
- **Controls:** `play`, `pause`, `seek`, `stop`. `stop` is for leaving: the song never follows him out.
- **Delivery:** haptic cues go to `HapticLibrary`, and every cue goes to `onCue`.

**`ScoreCatalog`:**
- Reads a Bindu Field API page, keyed by field id (as the snapshot is) or by field name.
- A select can arrive as its name or as `{id,name}`.
- Only Drafted or Verified rows with a Score play.

**Wraps or replaces:**
- `HomeSoundService`'s "Score overrides 212-220" hook (S62's "reuse HomeSoundService override hook") is left untouched. U4 joins her songless Score to it.
- No audio is played here. The song, the binaural and the pink noise belong to Part B's buses, and they read this player's laws.

## Decisions made from the evidence

1. **Story hold = 1800 ms**, as the brief names it, and as Design's chakra shell has it (`canon-adapter.js` `hold_ms: 1800` and `HOLD_DURATION = 1800` in the practice pages). The corridor's story *beat* of 1500 (the-33 row 32) is kept separately as `HoldLadder.storyBeat`.
2. **The default drain is 750 ms.** This is the gentle end of G0's 620–750 band ("never a jolt back to zero"). Compose's 620 is `sendDrain`.
3. **The latch fires at the commit.** G0 says "one latch at completion", and S78 says "commit on threshold". The latch marks the light reaching full. The act itself waits for the release.
4. **A cancel never acts, even after the commit.** G0 says the act waits for a clean lift.
5. **The ledger write is semantic, `ScoreLedgerWrite.Event.danceCompleted`, at the Return.** data.md §4.3 says "a dance reaches its return". `LawsTests.testTheLedgersVocabularyLivesOnlyInTheLedger` allows the ledger's words only in `ActivityLedger.swift`, so U7 adds `Dance Completed` there and maps this event to it. The Score's own `app_activity` (`Field` / `Ceremony Sealed`, the web build's vocabulary) is carried as data, never written.
6. **When a Score leaves the Return open (40 of 46), it starts 20 s before the end.** The Return's caps are written over rT = 20 (the-33 row 67).
7. **Voice cues need OL-3**, which is off in every Score. They name his recordings only; there is no generated voice.
8. **The format says "24 sections" but lists 25.** All 25 are mirrored.
9. **The "21st rule" is V42's `needs_listening` flag**, alongside validate.py's 20 and Appendix A's refinement of R20. It warns and never refuses.

## API assumptions not verified by compiling

1. **SwiftUI on iOS 17:**
   - `.onKeyPress(keys:phases:action:)` with `KeyPress.phase` compared by `==` to `.down` / `.repeat` / `.up`;
   - `.focusable()`;
   - `.accessibilityAction { }`;
   - `let _ = …` statements inside a `ViewModifier` body (result-builder declarations).
2. **`@MainActor struct …: ViewModifier`** and `@MainActor func` in a `View` extension, the same pattern as `MandalaFieldVoice`.
3. **Core Haptics:**
   - `CHHapticEngine.capabilitiesForHardware().supportsHaptics`;
   - `makeAdvancedPlayer(with:)`, `loopEnabled` and `loopEnd`;
   - `sendParameters([CHHapticDynamicParameter(parameterID: .hapticIntensityControl, …)], atTime: CHHapticTimeImmediate)`;
   - `resetHandler = { [weak e] in try? e?.start() }` capturing only the engine.
4. **`Task.sleep(for: Duration)` and `Duration.seconds(Double)` / `.milliseconds(Int)`** (iOS 16+).
5. **`JSONDecoder` decoding `ScoreJSON`:** `Bool` is tried before `Double`, so `true` never becomes 1, and a number never decodes as `Bool` on Darwin. Top-level fragments are allowed.
6. **Matching `case .named(let s) where …:`** against a `ScoreTrigger?`: an enum-case pattern matches through the optional.
7. **A synthesized memberwise init** for `HoldModifier`, which has a `@State private var touching` with a default value. It is only called inside the same file.
8. **In the tests:**
   - a local class conforming to `ScoreClockSource` inside a `@MainActor` test;
   - `XCTAssertEqual(try …)` inside the throwing autoclosure;
   - `Rx.groups` from `LawsTests.swift`;
   - `DesignCorpus.text("Design/Chakra/…")`.

## How each test can fail (V30)

Each suite carries a planted defect where one was cheap, so it is proven red on every run:

| test | what it checks | how it fails / the planted defect |
|---|---|---|
| `testTheLadderIsTheSourcesOwn` | covenant = Design `BREATH = () => 5000 * pace()`; story = `hold_ms: 1800` and `HOLD_DURATION = 1800`; the brief's five; the room ladder 3500 → 1500 by road, falling; drain inside 620–750 | a missing Design file throws; a changed constant or reordered ladder fails |
| `testAHoldCommitsOnlyAtFullAndActsOnlyOnRelease` | the commit is never before the duration; the act happens at the release, once; released a frame short does not complete | an engine that acts on commit, or commits early, fails |
| `testAnEarlyReleaseDrainsAndNeverActs` | no commit or act; the light never rises after the release; drains in progress × DOWN ± 20 ms; a second press does not jolt | — |
| `testATapDoesNothing` | a 100 ms tap and twenty 4 Hz taps never complete | **planted:** a 50 ms engine *does* complete on a tap, so the check can see it |
| `testAHeldKeyCountsAndItsRepeatsAreIgnored` | a held key completes; repeats return nothing; key up at d/2 drains; repeats alone are not a hold; a key up does not end a finger's hold | — |
| `testACancelNeverActs` · `testAStalledFrameCannotCompleteAHold` · `testAVoicePerformsTheActAtOnce` · `testTheDriverActsOnlyOnTheEnginesWord` · `testTheHoldRampIsG0s` | cancel after commit drains with no act; a 5 s stall advances 64 ms only; the voice action commits and completes once; the driver's early release calls neither act | — |
| `testTheLibraryIsWarm` | every pattern ≤ .3 sharpness unless S78 names it; intensities in 0…1 | **planted:** a .9-sharp pattern is caught |
| `testTheGestureSetIsS78s` · `testTheHeartsBeatAtTheirBpm` · `testAVibrateArrayBecomesEvents` | S78/S53 numbers; 60 / 50 / 46 bpm; ms arrays → events | a changed number fails |
| `testTheScoresArraysAreTheLibrarys` | cross's own `crossing_peak` / `bell` / `mirror_flash` arrays from the **snapshot** equal the library's patterns | — |
| `testEverySnapshotScoreLoads` | all 46 Score JSON cells (counted independently with `JSONSerialization`) load, with 46 distinct ids; the catalog reader finds 46 playable Drafted rows | a rule that wrongly refuses a real Score fails here |
| `testTheWarningsAreTheBatchsOwn` | cross warns only R15; 45 drafts warn R19; 43 warn R21 (release and search were listened to); no R20 | these are the Python port's exact results |
| `testABrokenScoreIsRefused` | cross broken one rule at a time: R1, R2 ×2, R3, R4 ×2, R5, R6, R7, R8, R9 ×2, R10 ×2, R11, R12, R13, R14, R16 ×2 (key and "528 Hz" string), R17 — each refused under its own rule; an imposed carrier with a reason passes; "{" is refused | every hard rule has its planted defect |
| `testCrossDecodesIntoTheTypedMirror` | PEAK 160 vs extracted 138.0 (§4), carrier 110 absent_fifth, the 7 → 9 ramp, 16 families, 4 voice triggers, OL-3 off, Return 15 s | — |
| `testCrossCuesFallWhereTheScoreSaysInOrder` | phases, mirrors, the word at 160, "I Love You" at 157, crossing at 160, mirror flashes, no bell without hits, climax 145/195, Tier 0 at 0 and end−1, shapes 30/145/Return, 12 beats, Return at 215.09, one ledger write there with the track id, end at 230.09; OL-3 on adds the four voice cues at the Score's times | — |
| `testTheBeatFollowsTheScheduleAndFreezesInSilence` | 8.0; the designed 7.83 and 2.69; the ramp mid-point 8.0; 10 at the end; frozen inside 205.5–210 | **planted:** the unfrozen value differs, so the check can see a freeze |
| `testTheGainLaws` | multipliers 1.3 / 1.2 / 0.8 / 1; gain always 0 or inside 0.003–0.050; at the sway's trough E=1 → .030 and E=0 → .050; final ramp → 0; song gain 0 / .4 / .8 / 0; boost 1 / 1.4 / 1.8 / 1.4 | — |
| `testThePlayerFiresEachCueOnceInOrder` | stepping 0.25 s fires exactly `timeline.cues`; a seek fires nothing and lands in "The Crossing"; the batch draft `move` plays (1 beat, Return at dur − 20, seed at 60 / 129.2) | **planted:** a doubled cue is seen |
| `testTheOneClock` | the free clock runs, pauses and seeks; with a song, time 0 does not move the player and 42 is the player's time | — |
| `testTheFruitNeverCountsHim` | cross carries a `{n}` weave (the defect in the data), and it is dropped; the motion weaves stay | — |
| `testTheSongsFrameData` | `SC()` interpolation; lenient H / DROPS parse; hits at .3 not felt; bells by cross's criteria (after 200 s, ≥ .6) | — |
| `testOnlyADraftedScorePlays` | Unscored never plays; a select object or a name both read | — |

**Checked here in Python:**
- The extended validator (all 21 rules) over the 46 snapshot Scores: 0 failures. Warnings: cross R15; release and search R19; the other 43 R19 + R21. `validate.py` itself also passes all 46.
- The hold engine ported and driven:
  - 1.1 s commits at 1.104 and acts at the release;
  - released at exactly 1.1 it completes;
  - released at 1.08 it drains;
  - a 100 ms tap drains;
  - a 50 ms engine completes on a tap (the planted defect);
  - the half release drains in 0.384 s against a predicted 0.382.

## Left for later waves

- **U2:**
  - Put `.hold` on every hold in the app, retiring `onLongPressGesture` fires.
  - Route `Theme/Haptics.swift` callers into `HapticLibrary`.
  - Add a Sound sheet switch for haptics.
  - Make Part B's SONG bus conform to `ScoreClockSource`.
- **U7 (The 33):**
  - The vocabulary modules (Layer 3); `knownVocabularyModules` is empty, so cross, kingdom and inshadow run Layer 1 with an R15 warning.
  - The dancers, bloom and mirror drawing.
  - The `Dance Completed` ledger type in `ActivityLedger.swift`, mapped from `ScoreLedgerWrite`.
  - Fetching `-data.json` beside the mp3 (the parser is ready).
- **Thunderclouds' `carrier_dropout`:** its shape is not fixed by any Score in the snapshot, so it is carried as `ScoreJSON` and not yet cued.
- **A note on G0:** a second press rises from where the light is, so a hand that is down most of the time (very fast tapping, about 50 % duty) can fill a hold. That is the source's law, and the test uses an ordinary 4 Hz tap.
