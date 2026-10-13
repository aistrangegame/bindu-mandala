# U1 · B · Sound — report

Branch `u1-b`, from `upgrade` at f22eb7e. Built from `waves/upgrade/worlds/sound.md` (read in full, §1–§8), the U0 and U1 briefs, the upgrade map, and the existing engines (`SoundConductor`, `HomeSoundService`, `RingAudioService`, `TreeOfLife`, `BreathClock`, `Theme/Haptics`, `BinduMandalaApp.AppRuntime`, `WorldID`). There is no compiler here. Every type used was read before it was called. **Nothing outside `Sound/` and the test file was touched**: no hooks were needed.

## Files

| file | what it is (sound.md) |
|---|---|
| `iOS/Bindu Mandala/Sound/Tuning.swift` | §1.4 / S10: `Tuning` holds the ring roots, JUST, carrier, the withheld fifth and grantsFifth, the strikes ([1,2,4] until granted, then [1,1.5,2]), `bell(r) = root(10−r)×4`, Design's bell voice, the falling mantra, the Vāk ladder, the ring 8 triad, the Shepard fMin, the Climb beats, the wake-up carrier, the named exceptions (Om stack, day bells, planetary, Heart Register Sa, game palette, Mirror blips, convergence, beat alone, Spanda, bowl and ink, song carriers), `isAllowed(hz)`, and the retired sets (comment and data, with what replaces each) |
| `Sound/RoomTones.swift` | §1.7 / S48, S55: the 33 rooms' fixed tones as data. Kinds are om, tone, drone, mind room, silence and sealed (room 32). It also holds the practice gain .012, the mind-room 10 s breath, Armin .008→.014 over 55 s, and the panel→room map |
| `Sound/WorldVoices.swift` | §1.2 / §1.5 / S01, S09, S22: `SoundBus` (the seven layers) and `WorldVoice` for all fifteen worlds (bed, the buses in its scene, threshold). It holds the crossing law (Q .65, 0.08 Hz breath at cutoff×.25, ±2 cents, 2.6 s equal power, stop at 2.9 s, 0.028 over 2.4 s), the threshold envelope (peak .032 at .42 of 1.8 s, menu hum .010), and Time's day, year and night beds |
| `Sound/MixLaw.swift` | §1.2 / S01–S07, S80, as pure law: ceilings (.075 per event, binaural .003–.050, −1 dBFS); the Om floor and swell (never below the floor, never above .20); the duck (WORLD and HER to 0.6, τ .12, back over .9 s; never the Om); `busGains`; song constants; seam and leaving; pink noise; binaural or pulse; `conductorGains` (the summed bridge for `SoundConductor`); `SongSlot` (one song source, session ids); `SoundSessionNeed` |
| `Sound/MixRenderer.swift` | The synthesised buses as render code, with no engine. FLOOR is the Om stack plus Kellet pink noise through a 4 kHz lowpass. WORLD is the bed with equal-power crossfades; ring-ground beds reuse `HomeGround` and `HomeCarrier.ground(forRing:)`, stepping and triad included. HER is a room tone, mind-room fifth or Armin ramp, or her carrier. BINAURAL is true L/R or an isochronic pulse. ACCENT is a 16-voice pool: Design's bell verbatim, falling mantra, threshold, struck tone. Duck, layers, scene mask, master, and a hard ceiling. Commands are posted from the main actor and taken with `NSLock.try()` on the render thread. `render(frames:)` / `render(seconds:)` run offline |
| `Sound/SoundMixer.swift` | The live mixer. `wakeOnFirstTouch`, `enter(world, ring:, herCarrier:)`, `hum`, `setRing`, `setDepth`, `swellOm`, `strike`, `setHer`, `enterRoom`, `setBinaural` / `stopBinaural`, `setPinkNoise`, `toggleMute`, `setMasterVolume`, `setLayer`, `openListening` / `closeListening`, `pressSong` / `stopSong`, `letGo`. Graph: source node → submix ← song mixer ← player; submix → Apple PeakLimiter → main mixer. Interruption, route and Mono Audio handling |
| `Sound/SoundSession.swift` | S03: the one owner of `AVAudioSession`. Ambient by default; playback only while a song is pressed; playAndRecord (`.defaultToSpeaker`, `.allowBluetoothA2DP`) only while listening. Observes interruption, route change and Mono Audio |
| `Sound/SoundSettings.swift` | S06: the `sound.*` keys. Master on (default **on**, migrated once from `lr_sound`), volume 0.8, a gain per layer, binaural mode Auto/Always/Off, haptics on/off |
| `Sound/Recordings.swift` | §1.9 / S64: all 58 paths with bytes, **full sha256** and git-blob prefix (40 unique). Also where each is used: room dances, Maya's ending, Kingdom, cross, before, Lalitā's dance `bindu/play.mp3`, Aatma `tree-of-life/aatma.mp3`, the Axis two, the family songs |
| `Sound/RecordingStore.swift` | S64: resolves the bundle (`Audio/Songs/<path>`), then the cache (`Application Support/AudioCache/<path>`), then a download from `https://aistrangegame.com/<path>`. The download is checked against sha256 before it is written. One download per path at a time |
| `Sound/SoundGlyph.swift` | S06 / S80: the glyph (18 px circle, 4 px dot, "silent" at 8 px .22, 44 pt hit area; tap mutes, a 600 ms hold calls `onHold`; VoiceOver label, value, hint and actions). Also `.soundWakesOnFirstTouch()` (S05) |
| `iOS/Bindu MandalaTests/U1SoundTests.swift` | 33 tests (below) |
| `waves/upgrade/briefs/U1-B-report.md` | this report |

**The recordings' sha256.** The register lists only 8-hex git-blob prefixes. All 58 files were fetched from aistrangegame.com on 13 Oct. I computed sha256 and byte size for each, and every git-blob prefix matched the register. That gives 58 paths and 40 unique byte-sets. U1 bundles no audio, and no CI script was added (the brief says to stream and cache).

## Wrapped, reused, replaced

- **SoundConductor**: kept as the door every existing engine uses. Its "one bed at a time" arbiter is superseded by `MixLaw.conductorGains`, which has the same shape. In U2, `apply()` calls it instead of `SoundArbiter.gains` (one line). Under the new law, beds add together and the Om stays at 1× its floor (the old law dropped it to 15 %).
- **HomeSoundService / HomeCarrier**: reused. Her carrier law comes from `HomeCarrier.carrierFor`, and the ring-ground beds are `HomeGround` voiced by `HomeCarrier.ground(forRing:)`. `Tuning.ringRoots` and `HomeCarrier.roots` hold the same nine numbers, and a test keeps them equal. U2 should point `HomeCarrier.roots` at `Tuning`.
- **TreeOfLife**: `omFloor` and `omHz` are reused.
- **BreathClock**: not touched (Part C extends it). The 0.08 Hz world breath is the renderer's own clock.
- **RingAudioService's Om**: still the live Om until U2. U2 should move the Om to the mixer and stop `RingAudioService.omStart`, so the Om never sounds twice.

**Nothing is wired to a screen in U1.** The mixer, session owner and glyph are all unused until U2. These six engines still call `setCategory` themselves, and U2 moves them to `SoundSession`: `BijaSoundService.swift:307-309`, `SpeechCapture.swift:86,196`, `RingAudioService.swift:48-65,455-457`, `HomeSoundService.swift:889-924`, `HeartRegister.swift:182`, `PlayInstruments`.

## Decisions taken from the evidence (U2 may revisit)

1. **Ceiling against Design's bell.** Design's bell master is .085. S04 caps every synthesised voice at .075, so the bell's master is held at .075; its partials stay Design's. The tests read .085 from Design and assert the clamp.
2. **The Om's 0.05 Hz breath "±0.008"** is applied upward only, as ×(1 + .008·(½ + ½ sin)), so it never takes the Om below its floor.
3. **Ring-ground beds** stand where HomeSoundService stands them today: ground level (.16, or the enclosure's .16 − .0125(r−1)) × wake level .5, through the room's closed 220 Hz lowpass, swept by the world breath. Essence beds stand at .028.
4. **Gains the register does not give.**
   - Holi (A Strange Game): 196 × [1, 1.25, 1.5] has no gains in register 14, so an equal .33 each is used. **Check DH:3621–3676** (the aistrangegame.com source) for the real values.
   - Time's 194.18 / 136.1 / 60 beds have no gain or filter in the register, so each is .55, unfiltered (the one-sine bed in the table, sid, is .55).
5. **WORLD_ESSENCE's own per-world LFOs** (e.g. road 200·.08) are kept as data in `EssenceLFO`. The engine follows sound.md S08 instead: one 0.08 Hz sweep at cutoff × .25 for every bed.
6. **The threshold envelope** is linear up to .032 at .756 s and linear down to 0 at 1.8 s; sound.md gives only the peak and where it falls.
7. **The duck release "over 0.9 s"** is τ = 0.3 s (95 % back by 0.9 s).
8. **Pink noise** uses Paul Kellet's seven coefficients ("7-coefficient pink noise"), lowpass 4 kHz Q .707, gain .015. It rides FLOOR, which is how the Well's `.pinkNoise` bed is played.
9. **The binaural** puts the carrier on the left and carrier + beat on the right. Carrier and beat glide with τ 1 s.
   - **Auto** plays the true pair only on headphones and a pulse on the speaker (S80).
   - **Always** plays the true pair except under Mono Audio.
   - The pulse is AM at the beat, depth .5.
10. **Retired-only pitches.** 587.33, 659.25, 396 and 528 × 0.917² fall within 0.05 Hz of a derived strike or carrier. Their sets are retired, but those numbers stay allowed, so they are not in `retiredOnly`.
11. **One song player.** A new song waits for the old one's 2 s fade before it starts, rather than crossfading two players.

## API assumptions I could not verify without a compiler or device

- The `AVAudioUnitEffect` built from `kAudioUnitType_Effect / kAudioUnitSubType_PeakLimiter / kAudioUnitManufacturer_Apple` uses default parameters. The −1 dBFS ceiling is enforced exactly only on the synthesised buses (a hard clamp in `MixRenderer`). The song is at most 0.8, and the sum of song and synth relies on the Apple limiter (about 0 dBFS). If the Mac build wants −1 dBFS exactly on the sum, set `kLimiterParam_PreGain` through `auAudioUnit.parameterTree`.
- `AVAudioSourceNode` with `AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)` is assumed to deliver two non-interleaved buffers. The renderer also handles a single (mono) buffer.
- `engine.connect(player, to: songMixer, format: file.processingFormat)` is assumed to be allowed while the engine runs (the player is stopped first).
- `player.scheduleFile(_:at:completionHandler:)` is called with a trailing closure. The handler also fires on `stop()`, which is why `songEnded` checks the session id.
- `UIAccessibility.isMonoAudioEnabled` / `monoAudioStatusDidChangeNotification` and `AVAudioSession.Port.bluetoothLE` / `.bluetoothHFP` are used.
- `NSLock.try()` is used on the render thread (it never waits).
- Concurrency: Swift 5 mode, minimal checking.
  - `RecordingStore` is an `actor` with `nonisolated` helpers that read `let` properties (`URL`, `Bundle`).
  - The source-node block captures the non-Sendable `MixRenderer`.
  - The `SoundSession` callbacks are closures formed in `@MainActor` code.
  - At most these produce warnings.
- `HomeBiquad()`'s implicit no-argument init and `HomeGround()`'s default init are used from another file. Both are internal, with default values, and already used that way in `HomeSoundService`.
- `RecordingStore.bundledURL` expects a later wave to bundle the recordings as a folder reference (`Audio/Songs/<dir>/<file>`). Flattened resources would not be found, so playback would fall back to the cache or network.
- The first-touch modifier and the glyph call `SoundMixer.shared` from gesture closures inside `body`, which is main-actor.

## The tests and how each can fail

Every Design number is read through `DesignCorpus`, where a missing file fails the test (it never skips). The offline tests render `MixRenderer` and measure the output. I could not run anything here. For each test below, the planted defect that turns it red is given, and I checked the expected numbers with Python against the same files: regexes, bells, Vāk ladder, mantra durations, retired-pitch collisions.

| test | reads | fails when |
|---|---|---|
| testRingRootsAreDesignsROOTS | `homes-sound.js` ROOTS | any root in `Tuning` is changed; `HomeCarrier.roots` drifts from `Tuning`; Design file missing |
| testJustIntervalsAreDesignsJUST | `homes-sound.js` JUST | a ratio is changed (e.g. 45/32 → 7/5) |
| testCarrierLaw | §1.4 examples | the carrier loses ×2, or the stem/fold is changed |
| testNineEnclosureBells | S26 table | the rule becomes root(r)×4 (ascending) or ×2 |
| testFiveOfDesignsEightRingChimesSurvive | `living-rite-core.jsx` LR_RING_FREQ | the bell table moves; it has fewer or other survivors |
| testBellVoiceIsDesignsLrRingChime | `lrRingChime` body | duration, attack, peak, lowpass or any partial differs from Design; the clamp is removed |
| testDerivedTable | §1.4 table | Vāk base, triad, Shepard, climb beats, mantra rule or Om stack changes; a 3/2 enters the Vāk ladder |
| testStrikesWithholdTheFifth | S12 | beat 2 sounds ×1.5 before the fifth is granted; the grant thresholds change |
| testEveryTablePitchIsInTheOneTuningAndNoRetiredOne | S10, S15, S81 | a table pitch is off the tuning (e.g. a room tone typed 175); a retired pitch is re-admitted |
| testRoomTonesAreTheCanonAwakeningPanels | `Design/Chakra/shell/walk-canon.js` | a room tone differs from its P1–P8 panel; Maya is not silence |
| testRoomTableShape | §1.7 | room 32 gains a tone; the mind rooms are not 110; Armin is not R4; the wake-up carriers ≠ tone ÷ 2 |
| testWorldVoicesMatchTheTable | §1.5 / WORLD_ESSENCE | any bed's fundamental, ratios, gains, lowpass, threshold or scene floor changes |
| testCrossfadeIsEqualPower | S22 | the crossfade is linear (out² + in² ≠ 1), or a constant changes |
| testThresholdTone | S09 | the peak or its time moves |
| testCeilingsAndTheOmFloor | S04, S16 | a ceiling moves; a swell is allowed under the floor or over .20 |
| testBusGainsSumAndDuckButNeverTheOm | S01 | FLOOR is ducked or dropped from a scene; the duck is not .6; a bed zeroes another |
| testConductorBridgeSumsBeds | S01 | the bridge drops back to one bed at a time, or ducks the Om |
| testOneSongAtATime | S02 | the same path pressed twice does not stop; a new song does not stop the old; a stale end clears the slot |
| testOneSessionNeed | S03 | playback becomes the default, or listening does not win |
| testBinauralRendering | S80 | Mono Audio stays stereo, or Auto plays stereo on the speaker |
| testSettingsDefaultOnAndMigrateLrSound | S06 | the default is off; `lr_sound` is not migrated; the mute is not kept |
| testRecordingsCatalogue | the register, §4 | the count ≠ 58/40; a hash is malformed; a `b/` twin differs; a door names a path not on the site |
| testRecordingStoreVerifiesBytes | S64 | verify accepts wrong bytes, or the SHA-256 hex is wrong |
| testRecordingStoreUsesTheCacheFirst | S64 | the cache is skipped, or an unknown path is accepted |
| testOmSoundsAtItsFloor | rendered | the Om's level or partial gains change (it measures 136.1 Hz at .004 and 272.2 Hz at .0012) |
| testAccentDucksTheBedNeverTheOm | rendered | the bed ≠ .028; there is no duck; the Om dips under its floor; the duck never releases |
| testCeilingHolds | rendered | the clamp is removed (the peak goes over 0.891). The test also asserts the unclamped sum went over, so it cannot pass vacuously |
| testOneBellStaysUnderTheEventCeiling | rendered | the bell's master exceeds .075; the bell is silent or at the wrong pitch; it never ends |
| testBinauralIsTrueLeftRight | rendered (4 s windows, exactly two bins apart) | it pans one sine (pseudo-binaural); the beat sits on the wrong ear; the gain leaves .003–.05 |
| testMonoAudioMakesAPulse | rendered | the pulse differs between the ears, or has no AM |
| testBedsCrossfadeAndTheOutgoingStops | rendered | the outgoing bed is cut at once, or never stopped; the crossing is not equal power |
| testMuteSilencesEvenTheOm | rendered | mute leaves the Om sounding |
| testMixerWakesEntersAndSoundsARoom | the mixer offline | sound before the first touch; no threshold on entry; the bed or master level is wrong; room 2 ≠ 174 at .012; room 32 sounds |

The no-TTS floor is already covered app-wide by `RulingTests`, and `Sound/` contains no speech API.

## For the Mac session

- Build, then run `U1SoundTests`. If a render test's tolerance is tight on the simulator, the numbers to look at are the Om amplitude (expected .00402) and the binaural amplitude (expected .0399).
- U2 wiring:
  - Put `soundWakesOnFirstTouch()` on the root.
  - Place `SoundGlyph` in every world.
  - Call `SoundMixer.enter` from the Router's crossing, and `strike(.bell)` then `.fallingMantra` from the Mandala's inward crossing.
  - Swap `SoundArbiter.gains` for `MixLaw.conductorGains`.
  - Move the six `setCategory` sites to `SoundSession`.
- One fact about the recordings, recorded as data rather than reopened: `tree-of-life/aatma.mp3` is filed as Chase Hughes' *Aatma* (his ruling). Its bytes are identical to `b/arise.mp3`, and `tree-of-life/anahata.mp3` is identical to `b/bindu-dances-reach.mp3`.
