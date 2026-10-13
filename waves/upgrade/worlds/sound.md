# The Sound System — one sound for all fifteen worlds

*World design, stage 2 of the upgrade map · 13 Oct 2026 · slice `waves/upgrade/index/by-world/sound.jsonl` (470 rows, every row read) · ledger `waves/upgrade/ledger/sound.csv`*

Sound is not a world you walk into. It runs under all fifteen worlds and joins them. Each world has its own voice. One tuning holds them together. The Om at 136.1 Hz sounds under everything. This file designs that system so a builder can build it from here. Every pitch, gain, timing and haptic is given below, with the index ids and register lines it comes from.

---

## 1 · The world

### 1.1 In his words and Design's

- **Design (homes-sound.js, the Homes handoff)**: *"Her bīja is the carrier; her āvaraṇa's drone is the ground. Climbing crossfades the ground; entering brings her carrier up; her adaptation opens the filter. The fifth is withheld until the ninth world, or until a very long stay."* (01-homes.md:632). *"The absolute pitch is a design choice and nothing more; what is canonical is the ORDER"* (01:634). *"The interval is hers, the register is ours, and a drone must sit low enough to be felt rather than heard"* (01:636). *"Silence about what we do not know, rather than a plausible number"* (01:636).
- **His Codex.**
  - **C-1350** is where *"one source at a time"* comes from. He said it about a playback bug in Bindu Field: *"whatever else is playing should stop … make sure there's not like a duplication of what's playing"*. He also asked for binaural *"playing in the inverse of the song itself … when the song is silent, then you can hear the binaural more"*, a *"missing basic engine"*, a full player, and a visible menu (07-codex.md:980-983, 1322, 1370).
  - **C-1297**: *"you listen to the gaps in the sound, that's where you feel the — I don't know what that is"* (07:810-813).
  - **C-1169**: kīrtan *"brings like a sense of calmness to the nervous system"*, and *"there was not a thought … that I would like to experience that moment again … because I'm already there"* (07:395-398).
  - **C-1222**: the red dot with white light moving behind it; *"the japa, where you're reciting Ram, Ram, Ram"* (07:535-538).
  - **C-1311**: the subtle seven ask for stillness, while the eyes and the heart ask for movement (*"shake it fast enough … your heart generates a euphoria pulse"*) (07:860-863).
- **His rulings that shape this world.**
  - Ruling 10 lifts "one sound at a time" and "no controls".
  - Ruling 12: the songs are his own recordings on GitHub.
  - Ruling 14: Vision sounds OM.
  - Settled 12 Oct: one tuning (Design's ring roots); each room keeps its fixed tone, and a song's drone plays only during its dance; bījas may sit in the yantra.
  - Floors: no generated voice, nothing invented, nothing scores him, accessibility.
- **BC-09 (Charter II)**: *"sound is everywhere; existing pitches keep character; new sound may take 136.1 Hz and 110 Hz; begins on first touch; silent switch honoured"* (04:593).

### 1.2 The shape of it: seven buses, one conductor

`SoundConductor` stays the one owner of every engine (S01). Its arbiter currently zeroes every bed except the front one. It becomes a **mixer**: layers add together and nothing is muted. Every world declares a **SoundScene**, which lists the buses it uses and the gain of each.

| bus | what plays on it | gain range | engine (reuse / new) |
|---|---|---|---|
| FLOOR | Om 68.05 / 136.1 / 272.2 + pink noise | Om 0.004 → 0.030 by depth (swell to 0.20); noise 0.015 | TreeOfLife Om (reuse) · PinkNoise (new) |
| WORLD | the world's bed voice (§1.5) | master-to-bed 0.028; ring grounds ×0.16 | WorldVoice (new) on HomeSoundService voicings (reuse) |
| HER / ROOM | ring ground + her carrier + air + withheld fifth · or the 33 room's fixed tone | carrier amount × 0.1; air 0.006–0.018; room tone 0.012 | HomeSoundService (reuse) · AwakeningVoice (new) |
| BINAURAL | true L/R carrier + beat | 0.003–0.050 | BinauralEngine (port from Bindu Field) |
| SONG | his mp3 under a Score | 0.8 (fade 0 → 0.8 over 3 s) | AVAudioPlayerNode + ScorePlayer (new) |
| ACCENT | bells, strikes, chimes, bījas, Vāk, triad, answers to the hand, game palette | ≤ 0.075 per voice | BijaSoundService, RingAudioService, PlaySound (reuse, retuned) |
| HAPTIC lane | Core Haptics, same clock | — | HapticLibrary (new; Haptics.swift routes in) |

The rules of the mix:

- **Ducking.** An accent ducks WORLD and HER/ROOM to 0.6 (τ 0.12 s, released over 0.9 s). The Om is never ducked below its floor.
- **One song source.** Only one SONG source plays at a time. Starting a song or Score stops any other with a 2 s fade, and starting the same source twice stops the first (S02, his C-1350).
- **One audio session.** The conductor owns the session. It is `.ambient` by default, so the silent switch is honoured. It switches to `.playback` only while he has pressed play on a song, and to `.playAndRecord` only while a listening gate is open (S03).
- **Gain ceilings.** Synthesised events stay at or below 0.075. Binaural stays between 0.003 and 0.050. A limiter sits at −1 dBFS (S04). *"Everything … should get quieter, not louder, as it goes deeper"* (04:355). The Om is the exception: it is what remains.

### 1.3 Second by second: the first touch, a crossing, leaving

- **Launch.** Silence. The Bindu sits at the centre. Nothing sounds on load.
- **First touch, anywhere (t = 0).** The engine wakes and the Om fades in from 0 to its floor (0.004 at Home) over 2.4 s (τ 1.2 s). *"The person doesn't hear it turn on — they notice it when the noise between them and the sound decreases."* (S05)
- **A finger held still on Home (t = 0 → 5 s).** The Om rises from 0.004 to 0.012 over one breath, cycling at 0.05 Hz. If recognition comes, the true zero arrives at about 14 s (S17).
- **Opening the menu.** The constellation of world-points appears. As the finger passes a point, that world hums its threshold tone at 0.010, so the ear learns the map (S09).
- **Crossing into a world through the point (t = 0 → 2.9 s).**
  - The bloom opens in the colour of the world entered.
  - The world's threshold tone sounds once: sine f plus a partial at f × 2.002 (gain 0.22), peaking at 0.032 at 0.42 of its 1.8 s.
  - The departing world's bed crossfades out over 2.6 s, equal-power, and is stopped at 2.9 s.
  - The arriving bed rises to 0.028 over 2.4 s.
  - If he leaves a room, its carrier (or fixed tone) holds at 0.004 for 3.0 s, *"the seam is a phase, not a gap"*. Then it decays (τ 1.4 s) into the Bindu's Om, which never stopped (S07, S22).
- **Inside the world.** That world's voice plays, plus whatever his hand asks for (S73). Everything breathes on one 12.5 s world breath at 0.08 Hz, which sweeps each bed's lowpass (S08).
- **Leaving.** Every bus of the world fades over 2 s. A dance's song stops at the world's edge. Its carrier only rides the seam.
- **The sound glyph (bottom-left, every world).**
  - A tap turns sound off (τ 0.5 s) or on (τ 1.2 s).
  - A 600 ms hold opens the Sound sheet: master volume, one slider per layer, binaural mode, and haptics (S06).

### 1.4 The one tuning

**The spine is Design's ring roots:** R1 55.00 · R2 61.74 · R3 69.30 · R4 73.42 · R5 82.41 · R6 92.50 · R7 98.00 · R8 110.00 · R9 123.47 Hz. The just intervals are JUST = [1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8]. These live in one Swift file, `Tuning.swift`, and every engine reads it (S10).

**Derived by stated rule:**

| what | rule | values |
|---|---|---|
| ring ground | f = root(r), Design technique per ring (S28) | 55 … 123.47 |
| her carrier | root(ring) × JUST[varṇa(stem(syl)) mod 12] × 2; no syllable → root (S11) | e.g. Aṃ@R1 110.00 · ka@R1 137.50 |
| withheld fifth | carrier × 1.5, granted by ring 9 / long stay / long dwell (S12) | gain 0.05 |
| rite strike | [1, 2, 4] × carrier until grantsFifth ≥ 0.5; then Design's [1, 1.5, 2] (S12) | — |
| enclosure bell | bell(r) = root(10 − r) × 4, falling inward (S26) | 493.88 · 440.00 · 392.00 · 370.00 · 329.64 · 293.68 · 277.20 · 246.96 · 220.00 |
| falling mantra | bell(r) × vowel interval (a 1, i 3/2, ai 5/4, au 5/3); duration 1.2 × bell(1)/bell(r) s (S27) | ring 1 1.2 s … ring 9 2.69 s |
| Vāk ladder (ring 7) | 196 × [1, 9/8, 5/4, 4/3, 5/3, 15/8, 2, 9/4, 5/2, 8/3, 10/3, 15/4], fifth withheld (S35) | 196.00 · 220.50 · 245.00 · 261.33 · 326.67 · 367.50 · 392.00 · 441.00 · 490.00 · 522.67 · 653.33 · 735.00 |
| ring 8 triad | 220 × [1, 1.26, 1.5] → unite at 110 (S37) | 220.0 · 277.2 · 330.0 |
| Shepard fall | fMin = root(9)/4, K = 7 (S38) | 30.87 Hz |
| Climb beat | 8 → 7.5 → 7 → 6.5 → 6 → 5.5 → 5 → 4.5 → 4.2 Hz across rings, then 4 at the summit (S40) | carrier root(r) × 2 |
| wake-up binaural carrier | room's fixed tone ÷ 2 (S50) | 87 · 105 · 160 · 170.5 · 192 · 213 · 240 · 264 |

**Named exceptions** (each is sourced, and each pitch keeps its character per BC-09):

- the Om stack 68.05 / 136.1 / 272.2 (+ 408.3 in the summit chord);
- the 33 rooms' fixed tones (§1.7);
- day bells 272.2 open / 136.1 close;
- the planetary breath carriers 194.18 · 221.23 · 256 · 80 · 60;
- each song's Score carrier, **only during its dance**;
- Heart Register Sa C–F (default C♯ 138.59, which is ring 3's root × 2);
- the game palette (8 of its 12 pitches already sit in the table);
- the Mirror blips.

**Retired** (S15): the hash pentatonic; RITE_BIJA_HZ; VAK_FREQS 220–659.25; the R8 minor triad 261.63/311.13/392; LR_RING_FREQ 392→196; ringChime/RingBija at 528 × 0.917^(r−1); RingAudioService's second root set; solfeggio 396–963; the VX2 map tones; the Pythagorean chime ladder on 256; pseudo-binaural.

### 1.5 Each world's voice

Every bed below is a sum of partials with a lowpass at Q 0.65. The 0.08 Hz LFO sweeps the cutoff at a depth of cutoff × 0.25. Each partial gets ±2 cents of random detune. Beds crossfade over 2.6 s.

| # | world | bed (WORLD bus) | other buses in its scene | threshold tone |
|---|---|---|---|---|
| 1 | **Home (the Bindu)** | none: the Om is its voice | FLOOR (Om, S17 silence learning to sound) · BINAURAL at the deepest zoom (2.69 Hz on 136.1, S60) | 136.1 |
| 2 | **Today / the Rite** | today's Śakti's ring ground at root, 0.16 | HER (carrier, strikes S12) · ACCENT (bells 272.2/136.1, bowl 220, ink 174) · BINAURAL arc 8 → 6 → 4.5 → 4.0 → 7.5 → 10 on her carrier · optional pre-roll | her carrier |
| 3 | **The Mandala** | ground of the enclosure the glass is in, 0.16 − 0.0125·(r−1) | ACCENT (nine bells S26, falling mantra S27) · FLOOR rises by depth | root(r) × 2 (110 at arrival) |
| 4 | **The nine rings** | ring r's Design voicing at root r (S28), 0.16 | ACCENT (each world's mechanism S29–S38) · HAPTIC (ring 7 breath S36) | root(r) × 2 |
| 5 | **Her Home** | (none: HER carries it) | HER = the full HomeSoundService graph (S41) · ACCENT seat worlds (S44), the hand ring (S46) · BINAURAL optional on her carrier · inverse gain (S42) | her carrier |
| 6 | **Her Presence** | (none) | HER: her carrier held at amount 0.3 + air · ACCENT glyph tap (S13) | her carrier |
| 7 | **The Climb** | nine grounds crossfading by climb fraction (S40) | BINAURAL narrowing beat · ACCENT summit chord 136.1·272.2·408.3 + bowl + 8.5 s tail | root(r) × 2 |
| 8 | **The 33** | the constellation: "stately bell" 146.8 × [1, 2, 3, 5] at .36/.18/.10/.05, LP 920 (WORLD_ESSENCE road; 146.8 = R4 × 2) | inside a room: ROOM = its fixed tone (§1.7) · BINAURAL wake-up arcs (S50) · SONG + Score in the dance strand (S56) · HAPTIC pulse rooms 9–32 (S53) | 146.8 / room tone |
| 9 | **A Strange Game** | 196 × [1, 1.25, 1.5] sine/tri/sine, LP 900, LFO 260·.12 (WORLD_ESSENCE holi; 196 = R7 × 2) | ACCENT the game palette (S72) | 196 (game entry keeps 272.2) |
| 10 | **The Modes** | 138.6 triangle + sine [1, .5] at .42/.22, LP 440 | each mode's own: Heart Register (S70), breath carriers (S20), the beat offered alone (S19), subtle-body sessions (S77) | 138.6 |
| 11 | **Time** | the day: 194.18 sine (Earth-day) · the year view: 136.1 · the night: 60 Hz + 1.5 Hz beat | ACCENT morning bell 272.2 / evening bell 136.1 | 194.18 |
| 12 | **Memory** | 98.0 sine .55, LP 360, LFO 90·.04 (WORLD_ESSENCE sid; = R7) | ACCENT the hand ring settling true (S46) | 196 |
| 13 | **The Well** | pink noise 0.015 (S58) under the Om | BINAURAL the Mirror's held tone 110/3.5 Hz (S74) · Schumann once (S61) | 110 at 0.016 |
| 14 | **Beneath** | Kingdom's Score as the descent's bed (S65) | ACCENT the Shepard fall (S38) · BINAURAL 2.69 thread door (S60) · pink noise | 123.47 |
| 15 | **The Relationship Field** | 272.2 × [1, 1.005, 1.5, 2] at .28/.28/.15/.09 (1.36 Hz beat), LP 1100 | ACCENT convergence 132 + 140 → 136.1 (S18) · SONG family songs on star hold (S68) | 272.2 |
| — | **the spine** (menu, crossings) | — | each world-point hums its threshold at 0.010 as the finger passes; crossings per §1.3 | — |

### 1.6 The rings and the yantra, heard

- **The Mandala.** The glass falls inward. In each enclosure the bed becomes that ring's ground, a little quieter each ring, while the Om rises.
- **Each inward crossing** (outward is silent):
  - The **bell** of that enclosure rings. It is Design's 1.7 s bell, at bell(r), which steps down from 493.88 to 220.
  - The **ring's bīja** follows 180 ms later at the bell's pitch × its vowel interval.
  - The syllable may surface at its enclosure for its duration.
  - **Ring Crossed** is written once per new depth.
- **In each ring's world** the ground is that ring's own technique on its own root, and the world's mechanism sounds on top (S29–S38):
  - **Ring 7** is the Vāk Chamber. It holds the Airtable twelve, voiced on a ladder that withholds the fifth. Healing is felt at 7 of 12, and no counter is shown.
  - **Ring 8**: three tones glide into one at 110.
  - **Ring 9**: the Shepard fall, which never lands.
- **The Climb** crossfades the nine grounds and narrows the beat from 8 to 4 Hz. At the summit the Om's chord sounds.
- **Her Home** keeps the full sound of Design's room:
  - The ground crossfades with the climb, and entering brings her carrier up.
  - The adaptation opens the lowpass from 220 to 1720 Hz, and the air thickens.
  - Each beat of the rite lands as one struck tone. These strikes no longer give away the fifth before it is granted.
  - When he is quiet, her tone swells (S42).

### 1.7 The 33 rooms: one fixed tone each

Each room keeps **one fixed tone**. Practice, gate and wake-up all sit on it. The dance is the only exception: its song brings its own carrier, and only for the length of the dance.

| room | fixed tone | source of the choice |
|---|---|---|
| 1 Bindu | Om 136.1 (no awakening tone) | 06:104 "Om 136.1 Hz optional at Act 0" |
| 2 Muladhara | 174 · earth drum | canon awakening P1 |
| 3 Svadhisthana | 210 · wooden bell | P2 |
| 4 Manipura | 320 · struck gong | P3 |
| 5 Anahata | 341 · crystal bowl | P4 |
| 6 Vishuddha | 384 · singing bowl | P5 |
| 7 Ajna | 426 · shimmer, 1.5 Hz twin | P6 |
| 8 Sahasrara | 480 · distant bell | P7 |
| 9 Shadow | none (the word he offers); deepest binaural 2.5 Hz δ on 136.1; the pulse begins | 05:1024-1030; 06:112 |
| 10 Soles | 174 (LAM, mirror of Muladhara) | Map Mirror Frequency |
| 11 Forge | 320 (RAM) | Mirror Frequency |
| 12 Prana | 210 (VAM) | Mirror Frequency |
| 13 Hands | 341 (YAM) | Mirror Frequency |
| 14 Pulse | 341 (YAM) + heartbeat 68 / 52 Hz | Mirror Frequency; B.4.1 |
| 15 Sonar | 384 (HAM, sending) | Mirror Frequency |
| 16 Echo | 384 (HAM, receiving), very soft, then silence | Mirror Frequency |
| 17 Vision | 426 (OM; ruling 14) | Mirror Frequency |
| 18 Axis | 426 (OM) | Mirror Frequency |
| 19 Crow | silence (Sahasrara's mirror) | Mirror Frequency |
| 20 Armin | D2 73.42 drone, 55 s, .008–.014, never resolves | 06:123 |
| 21–29 mind rooms (walked Innocence first … Integration last) | 110 Hz + its fifth breathing every 10 s | BC-09 "110 Hz (the rooms about the reader)" |
| 30 Maya | silence: the Om was always playing | P9 |
| 31 Aatma | 528 · Trinity, detune −2/0/+2 | P8 |
| 32 Ego Reveal | sealed; the pulse stops; no tone | ruling 2 |
| 33 Lalitā | no seed: the Om at its highest (.20, "Go Play") | 05:2679-2685; P9 staging |

### 1.8 The Score player

This is one engine that plays everything time-coded: a room's dance, Kingdom in Beneath, cross at the threshold, a family song in the Relationship Field, and her own songless dance (S45, S62).

- **One clock.** It runs from the SONG player's sample time, or a free clock when there is no song.
- **What it drives on that clock:**
  - **sound**: song gain, beat schedule, gain law, pink noise, pre-roll, Lalitā's recorded lines;
  - **light**: bloom tiers 0–4 and DARK_RATIO;
  - **motion**: seven named dancers reading pitch, bass, sustained energy, mids, silence (inverse), brightness, and centroid + web;
  - **words**: the seed typed at BPM, mirror words, phase labels, the word at peak_t, "I Love You" at peak_t + 5;
  - **haptics**: hit tiers, drops, element grammar;
  - **return**, and the **memory writes**.
- **Where Scores come from.** They are read from Airtable as Score JSON and cached. Only Scores with status Drafted or higher play. *"Edit the JSON in Airtable, and the next fetch performs differently. No rebuild."*
- **The controls he asked for.** Inside the dance: play/pause, scrub, binaural on/off, full screen. The song never follows him into another world.

### 1.9 His recordings

- **Bundled.** All 40 unique mp3s on aistrangegame/aistrangegame.com are bundled (58 paths, 233.5 MB; file weight is not a criterion). An Xcode Cloud `ci_post_clone.sh` fetches them and verifies each sha prefix, so a missing file fails the build.
- **Streaming is only a fallback.** If a file is absent from the bundle it streams from aistrangegame.com/<path> into a cache, then plays from the cache next time (S64).
- **Not on GitHub yet.** These have no door until he adds them: miss, lift, abide, wake, the Run-4 tracks, return, lalita-cross-1…4.

### 1.10 Haptics

There is one Core Haptics library on the conductor's clock. It is warm, never sharp (S78).

- **Gestures:** tick, word, heart, the continuous hold ramp (0.15 → 0.6), completion, descent, kindle, and the still point that withdraws to nothing.
- **Panels:** gate 80, continue 40, pivot 50 ms.
- **The Scores' set:** crossing footsteps, bell, mirror, strike, fulcrum 50 bpm, charge 46 bpm, thunder roll, hit tiers, and the peak at every Recognition.
- **Element grammars** for the 33's body rooms (S71).
- **The 60 bpm pulse** from Shadow to the Reveal (S53).
- **Ring 7's breath** (S36).

### 1.11 Accessibility

Nothing in the app needs hearing (S80):

- Every meaningful sound has a light or haptic twin.
- With Mono Audio, or on the speaker, binaural becomes an isochronic pulse on the same carrier.
- VoiceOver names every control and every tone in English.
- The limiter, the binaural ceiling and a minimum 12 ms attack keep it hearing-safe.
- Every listening or motion gate has a tap fallback.
- Haptics can be switched off without losing a step.
- Reduce Motion never silences sound.

---

## 2 · Every element, placed

| # | element | what it does (mechanism + numbers) | source (index ids · register) | status today (code) | reuse / move / new |
|---|---|---|---|---|---|
| S01 | The conductor becomes a mixer | SoundConductor keeps its role as the one owner of every engine, but its arbiter sums layers instead of zeroing them. Seven buses: FLOOR (Om + pink noise), WORLD (the world's bed voice), HER/ROOM (ground + carrier + air, or the room's fixed tone), BINAURAL (true L/R pair), SONG (mp3 under a Score), ACCENT (bells, strikes, chimes, bījas, answers to the hand), and the HAPTIC lane on the same clock. Each world declares a SoundScene: which buses it uses and their gains. An accent ducks WORLD and HER/ROOM to 0.6 (τ 0.12 s, back over 0.9 s); it never silences the Om. Priority table (heart 4 · play 3 · room 2 · field 1) is kept only to order ducking, never to mute. | G6-0813 G6-0869 G6-0928 G6-0943 G7-0294 G4-0295 G2-0453 G2-0387 G6-0920 G1-0014 G2-0221 G2-0360 G1-0276 · 17-code-core.md:400,728,785,827,864; 04:592-593,630,738; 08-dances.md:1305 | **wrong** · Services/SoundConductor.swift:3-123 (gains: every non-front bed = 0); HomeSoundService.swift:762-776; RingFieldVoice.swift:85-96; PlayInstruments.swift:183-186 | reuse SoundConductor; replace SoundArbiter.gains with per-scene bus gains (new) |
| S02 | Playback-collision rule (his C-1350, kept as playback law) | Only one SONG/Score source plays at a time anywhere in the app: starting a song or Score stops any other with a 2 s fade; starting the same source twice stops the first. Every tone gets a session id; a superseded session is killed at once (no orphan voices); media source is created once per track. Layering of beds, floor, binaural and accents is free (ruling 10). | G3-0515 G3-0529 G4-0577 · 07-codex.md:980-983,1309-1312,1322,1370; 10-field-data-catalog.md:258,467 | **partial** · SoundConductor.claim(.play) (one claim) — collision handled only for play | reuse claim(); extend to SONG bus with session ids (new) |
| S03 | One audio-session owner | The conductor owns AVAudioSession. Default category .ambient + .mixWithOthers (honours the silent switch, BC-09). While a song or Score plays because he pressed play, category .playback (his explicit act). While a mic gate is open, .playAndRecord with .defaultToSpeaker, .allowBluetoothA2DP; restored to the previous category on close. Interruptions and route changes pause every bus with a 0.5 s fade and resume on .shouldResume; headphone unplug pauses SONG and mutes BINAURAL. | G6-0947 G7-0293 · 17-code-core.md:890; 20-code-play-rooms.md:164-171 | **wrong** · BijaSoundService.swift:307-309 (.playback); SpeechCapture.swift:86,196; RingAudioService.swift:48-59 (.ambient); HeartRegister.swift:182; PlayInstruments (.ambient↔.playback) | move every setCategory into SoundConductor (move) |
| S04 | Gain staging and ceilings | Master 0–1 (default 0.8) → limiter at −1 dBFS. Synthesised events never exceed 0.075 per voice; binaural lives in 0.003–0.050 (ARRIVAL 0.005–0.010, HOME 0.030–0.056, film/meditate HOME ≤ 0.040; 0.10 is too loud on headphones); song bus 0.8 with a 3 s fade-in (0 → 0.8, +0.015 per 50 ms); Om floor 0.004 → 0.030 by depth. Everything gets quieter, not louder, as it goes deeper — except the Om, which is what remains. | G4-0566 G2-0229 G4-0113 · 10-field-data-catalog.md:217,256,460; 04:355; 08-dances.md:588-605 | **not-built** · — | new (conductor gain table) |
| S05 | Sound begins on first touch | Nothing sounds at launch. The first touch anywhere starts the engine and the Om floor fades in from 0 over 2.4 s (τ 1.2 s) — 'the person doesn't hear it turn on; they notice it when the noise between them and the sound decreases'. The 'Headphones, if you have them' door (one line, 1.2 s) appears before the first binaural of a session; taps are ignored for 200 ms after it appears. | G2-0361 G5-0690 G5-0137 · 04:593; 14-aistrangegame.md:958-961,1109; 12-padakarshini-field.md:435; 13-rupakarshini.md:423 | **partial** · HeartRegisterView.swift:5 ('sound only on first touch'); elsewhere engines start on view appear | new (conductor wake on first touch) |
| S06 | Mute and volume (restriction lifted) | A sound glyph in every world at Design's RingSoundToggle place (bottom 50, left 22: 18 px circle, 4 px dot; 'silent' label 8 px .22 opacity .22em when off) with a 44 pt hit area, and the same glyph in the constellation menu. Tap: master on/off (stop τ 0.5 s, wake τ 1.2 s, Design). Long-press 600 ms: the Sound sheet — Master volume; layer sliders Om floor · World voice · Her / room · Binaural · Songs · Bells and answers; Binaural mode Auto (headphones only) / Always / Off; Haptics on/off. Per-world overrides remembered. One key family sound.* replaces lr_sound (read live, not once); default ON (BC-09 governs over Design's default-off chimes). | G1-0511 G1-0701 G7-0195 G7-0015 G7-0505 G2-0322 G7-0144 G6-0817 · 02-rite-axis-field.md:847-849; 03:479-480; 19-code-mandala-today.md:57,485,654,695; 21-code-layers.md:21,162; 04:520; 17-code-core.md:451 | **partial** · LivingMandalaView.swift:38,662 (lr_sound default true); ChakraRoomView.swift:73 (read once); SadhanaView.swift:30; HomeVoice.swift:50-52 ('no in-app volume') | new SoundSettings + glyph; migrate lr_sound (move) |
| S07 | Leaving: 2 s release and the seam | When a world leaves view its buses fade over 2 s. Crossing through the point: the departing room's carrier (or fixed tone) holds at 0.004 for 3.0 s — 'the seam is a phase, not a gap' — then decays (τ 1.4 s) into the Bindu's Om, which never stops. A dance's song stops at the world edge; its carrier holds at its last phase gain only through the seam (Maya: 'what dissolved does not reassemble'). | G5-0610 G4-0466 G4-0581 G4-0269 · 14-aistrangegame.md:500-503,1112; 09-field-scores.md:649; 10-field-data-catalog.md:268,295,463; 08-dances.md:1209 | **not-built** · — | new (conductor exit) |
| S08 | One world breath at 0.08 Hz | A shared 12.5 s clock (0.08 Hz) drives every world voice's lowpass cutoff (depth cutoff × 0.25) and the imperceptible world-content breath; Reduce Motion stops the visual breath only, never the sound LFO. | G5-0638 · 14-aistrangegame.md:688,1033; 13-rupakarshini.md:92-94 | **not-built** · BreathClock exists for the Rite (10 s); no 0.08 Hz publisher | new (BreathClock.world) |
| S09 | Threshold tones: one pitch per world | Crossing into a world sounds its threshold tone once: sine f + f×2.002 at 0.22, envelope peak 0.032 at 0.42·dur, dur 1.8 s. f = the world's pitch from S22. In the constellation menu, a finger passing a world-point hums it at 0.010 — the ear learns the map. | G5-0466 · 13-rupakarshini.md:528-529,933 | **not-built** · — | new |
| S10 | The Tuning table — one tuning | Spine: Design's ring roots R1 55.00 · R2 61.74 · R3 69.30 · R4 73.42 · R5 82.41 · R6 92.50 · R7 98.00 · R8 110.00 · R9 123.47 Hz ('what is canonical is the ORDER') and JUST [1,16/15,9/8,6/5,5/4,4/3,45/32,3/2,8/5,5/3,16/9,15/8]. Every pitch in the app is either derived from these by a stated rule (ground, carrier, strike, bells, RingBija, Vāk ladder, triad, Shepard) or is a named, sourced exception (Om 136.1 stack; the 33 rooms' fixed tones; day bells; planetary breath carriers; song carriers inside dances; Heart Register Sa; game palette; Mirror blips). Retired (invented or colliding): hash pentatonic, RITE_BIJA_HZ, VAK_FREQS 220–659.25, R8 minor triad 261.63/311.13/392, LR_RING_FREQ 392–196, ringChime/RingBija 528×0.917^(r−1), RingAudioService field roots (73.42+110, 130.81, 116.5, 207.65, steps 146.84/164.82), solfeggio 396–963, VX2 map tones, Pythagorean chime ladder, pseudo-binaural single sine. One Swift file, Tuning.swift; every engine reads it. | G1-0277 G2-0350 G2-0472 G6-0939 G3-0318 G7-0485 G2-0864 G4-0489 G4-0286 G5-0075 G6-0872 G5-0417 G4-0494 G4-0630 G4-0290 G4-0447 · 01-homes.md:634; 04:568,757; 17-code-core.md:731,855; 06-chakra-skills.md:2589-2594; 20-code-play-rooms.md:726; 05:2900; 09-field-scores.md:750,774-786; 10:527-533,572-574; 13-rupakarshini.md:381-382 | **wrong** · HomeSoundService.swift:82 (roots) vs RingFieldVoice.swift:70-76, RingAudioService.swift:79-437 (second tuning) | new Tuning.swift; retune RingAudioService/RingFieldVoice/RingBija/BijaSoundService (reuse engines) |
| S11 | Her carrier from her syllable (Design's law, verbatim) | carrier = root(ring) × JUST[varṇa(stem(syl)) mod 12] × 2; stem strips final ṃ/ṁ and ḥ; compound bīja → first letter; no syllable → carrier = root ('silence about what we do not know'). 42 Śaktis have a syllable (11–18, 29–44, 87–94, 99–102); 60 sound at bare root. The mod-12 wrap (Ṭaṃ below Kaṃ, Paṃ to root) is kept: 'the interval is hers, the register is ours' — intervals, not alphabetical order. The per-Śakti carrier is never stored as a Śakti Hz (no Score may assign a Hz to a Śakti); it is computed. Ring 2 kp 43 'aṃ' duplicates kp 29 → same pitch, kept (data check, not sound). | G1-0278 G1-0279 G1-0285 G2-0276 G6-0871 G6-0816 G2-0264 G7-0968 G7-0695 G4-0633 G2-0216 G1-0536 · 01-homes.md:636-637,660; 04:342,414,431; 17-code-core.md:439,730; 22-code-tests.md:261-267,576; 10:459,542,646; 02:1118-1121 | **built** · HomeSoundService.swift:79-220 (carrierFor 143-151); HomeSoundTests.swift:21,34,90 | reuse |
| S12 | The withheld fifth, kept true | The fifth above her carrier (carrier × 1.5, gain (ring 9 ? 1 : b) × 0.05) arrives only with grantsFifth = ring 9 → 1, else max(clamp((chamberT − 227)/120), clamp((dwell − 180)/300)). Fix: the rite's struck tones are [1, 2, 4] × carrier while grantsFifth < 0.5, and Design's [1, 1.5, 2] once it is ≥ 0.5 and always in ring 9 — beat 2 no longer sounds the withheld fifth on every entry. Strike: sine 0 → 0.05 in 20 ms, exp decay to 0.0001 by 3.4 s, stop 3.6 s, unfiltered. Ring ground voicings keep their own Design partials (R2's 1.5f, R8's triad) — the law concerns her carrier only. | G1-0284 G1-0283 G1-0282 G6-1071 G6-1032 G7-0317 · 01-homes.md:655-659,683; 18-code-homes.md:106,149; 20-code-play-rooms.md:338 | **wrong** · HomeSoundService.swift:161-191 (strike [1,1.5,2] at every beat); RiteOfEntering.swift (strikeFrequency) | reuse; change strike ratio selection (small) |
| S13 | Her bīja tap sounds her carrier (hash retired) | Every 'sound her' tap — Her Presence glyph (84 px, gold, weight 300, shadow 40 → 70 px; three 90 px rings at 0/.5/1 s over 3.6 s; caption 'tap to sound her' → 'sounding'), the Mandala card, Lalitā's 'sound the source', the Activation close, a chakra wake-up 'sound LAM' button, Sadhana recitation — plays her carrier with Design's lrPlayBija envelope (gain .0001 → .26 at .35 s → .0001 at 3.6 s; lowpass 1200 → 600; vibrato 5.2 Hz) and partials ×1, ×2 (.38), ×4 (.2); the ×1.5 partial joins only when grantsFifth ≥ 0.5. 'And she felt you back' pairs with the richer tone (×3 partial .12 added). For a chakra room the 'bīja' button sounds the room's fixed tone (S48). Śaktis without syllable sound their root; the glyph is not shown. | G1-0478 G1-0492 G6-0927 G6-0819 G7-0337 G7-0359 G2-0222 G7-0510 G1-0594 · 02-rite-axis-field.md:602-609,701-705,1622-1631; 17-code-core.md:467,820; 20-code-play-rooms.md:396-397,437; 04:348; 21-code-layers.md:21 | **wrong** · BijaSoundService.swift:108-159 (FNV hash onto pentatonic 130.81…293.66) | reuse BijaSoundService envelope; replace pitch source with HomeCarrier |
| S14 | His recorded bījas (when he records them) | The path stays: Audio/Bija/bija_001…102.m4a (his own voice, 102 recordings, BV2-7 'Ashrey's alone'). If a file exists for her kp it is played instead of the synthesized carrier tone, pitch untouched; if not, the carrier tone plays. Never a generated voice; no TTS API anywhere (S81 test). | G2-0042 G6-0937 G2-0341 G2-0364 G4-0631 · 04:98,551,596; 17-code-core.md:851; 10-field-data-catalog.md:537 | **wrong** · BijaSoundService.swift:44-65 (prefers bija_%02d — no files; dead path) | reuse; rename to bija_%03d, keep fallback |
| S15 | Retired pitch sets (named, with what replaces each) | RITE_BIJA_HZ (Aim 136.1, Klīm 144, Sauḥ 126.2, Hrīm 152.7, Hsraim 160.4, Hsklhrīm 118.6, Hsauḥ 172.1) → her ring ground + carrier (S24). Solfeggio 396–963 (Climb ladder, Tone Ceremony, Hub SoundView, Sanctuary Gates, Colour Rivers, Echo, Mantra Tuner) → ring roots or room tones (S40, S72). VX2 map tones (Muladhara 256, Svadhisthana 288; Crow+Soles chord 480 → 256) → room fixed tones (S48). Pythagorean chime ladder on 256 → ring bells (S26). Each retired set keeps its mechanism; only its pitches move. | G1-0431 G5-0135 G5-0221 G3-0233 G2-0891 G2-0896 G2-0899 · 02:140-154; 12-padakarshini-field.md:434,556; 13-rupakarshini.md:421-423,503,945; 06:1754-1770; 05:3013-3014,3035-3039,3054-3059 | **n/a** · Views/Play/PlayPhysics.swift:506-532 (awakening table keyed by ring) | retune (reuse mechanisms) |
| S16 | The Om at 136.1 Hz under everything | Sines 68.05 (0.15) · 136.1 (1.0) · 272.2 (0.30) summed into one master; LFO 0.05 Hz ±0.008 on master gain (τ setTarget between phases). Floor gain = omFloor(depth) = 0.004 + 0.026·depth/9 (rim imperceptible, source a presence); holds 4 s between places; never stopped by stopAll; only master mute silences it. Swell at the Bindu deep zoom and in room 30/P9 follows P9 staging .01 → .06 → .10 → .15 → stations .08–.13 → recognition .14 → closing .16 → will .18 → Go Play .20 → .06. A gate 'Place and hold' raises it to .05 over ~10 s, decaying over ~14 s. | G2-0482 G6-0870 G7-0969 G7-0230 G7-0421 G7-0437 G2-0926 G2-0918 · 05-chakra-corpus.md:26-28,3209-3218,3250-3257; 17-code-core.md:729; 22-code-tests.md:577; 20-code-play-rooms.md:50,529-554,598 | **built** · TreeOfLife.swift:159-169 (omHz, omPartials, omFloor); RingAudioService.swift:348-377; PlayModels.swift:130 | reuse; expose swell to deep zoom (small) |
| S17 | Silence learning to sound (Home under a still finger) | On Home, a finger held still anywhere raises the Om from 0.004 to 0.012 over one breath (≈5 s) with the 0.05 Hz cycle; true zero ≈14 s at recognition. Room 01's practice is the same contact: 'one point, meeting one point — is Bindu's frequency'. The Room 1 gate (hold one breath, 5 s × pace) ends with haptic 30 ms and breathe(.006). | G5-0213 G2-0588 G2-0484 · 12-padakarshini-field.md:547; 13-rupakarshini.md:413-414,898; 05-chakra-corpus.md:35-37,469-475 | **not-built** · — | new (Om.breathe(target)) |
| S18 | Two tones converging to Om | When two lights meet (Relationship Field, Recognition), two detuned sines 132 Hz and 140 Hz glide exponentially to 136.1 Hz over 6 s at 0.020 each; unison = the Om. 'The parents finding unison.' | G5-0595 · 14-aistrangegame.md:406,1089 | **not-built** · — | new |
| S19 | The beat offered alone | One labelled control in the Modes ('the beat, alone'): 136.1 Hz left / 136.6 Hz right, gain 0 → 0.085 over 1.4 s, off over 0.9 s; headphones; silent until pressed; beside it the waveform you are hearing, drawn live from the output tap. | G5-0415 G5-0414 · 13-rupakarshini.md:374,1022 | **not-built** · — | new |
| S20 | Planetary tones (Cousto) for the day, the year, the night | Named exceptions, verbatim values: 136.1 Earth-year (the Om); 194.18 Earth-day (the day thread in Time; morning breath); 221.23 Venus (expansion breath); 256 'the mathematician's C' (counted exhale); 80 Hz chest; 60 Hz deepest (night protocol, 1.5 Hz beat). Each carries its 'honest frame' (SCIENCE vs TRADITION) as an S·T·C badge. | G4-0610 G5-0007 G5-0736 · 10-field-data-catalog.md:427-435,512; 12-padakarshini-field.md:60-68,1121 | **not-built** · Airtable Frequency rows 101-111 (Bindu Field) | new (read rows) |
| S21 | Honesty badges S·T·C on named tones | Every named tone (awakening 174–528, planetary, 2.69, Schumann 7.83, Om 136.1) carries a tap-to-open badge: inline-flex 2×5 px, radius 4, border .5 px, mono 7 px .16em (rendered letter ≥ 11 px), badgeIn .25 s; S rgba(72,190,170,.10/.32/.88) · T rgba(208,162,62,…) · C rgba(195,82,68,.10/.30/.82). Copy source: the Learning topics Solfeggio, 432 vs 440, Schumann, and his Frequency Understanding Atlas (L-1535). | G5-0148 G4-0878 G5-1102 G5-1122 G5-1157 · 12-padakarshini-field.md:448,911,1487,1507,1542; 13-rupakarshini.md:202-203,971; 11-padakarshini-forms.md:668 | **not-built** · — | new |
| S22 | Fifteen world voices and their crossfades | Each world declares a bed: fundamental, partial ratios + gains, lowpass (Q .65), filter LFO from S08, ±2 cent random detune per partial; crossfade 2.6 s equal-power, outgoing voice stopped at 2.9 s; master to bed 0.028 over 2.4 s. Table in §1.5. Pitches from the Tuning table; timbres from WORLD_ESSENCE. | G5-0636 G5-0637 G2-0233 G1-0580 G2-0153 G2-0186 · 14-aistrangegame.md:661-686,1032; 13-rupakarshini.md:96-97; 04:246,290,364; 02:1477 | **not-built** · conductor knows four beds (field/room/play/heart) | new SoundScene per world |
| S23 | Home (the Bindu): the Om alone | Home has no bed: the floor Om is its voice (S16), plus S17 under a still finger. Threshold tone 136.1. Deep zoom into the Bindu: Om swells by depth to 0.14; at the last layer the binaural beat glides to 2.69 Hz on a 136.1 carrier at 0.006 (S60). | G4-0576 G4-0317 · 10-field-data-catalog.md:250-256; 09-field-scores.md:126 | **partial** · TreeOfLife Om floor built; deep-zoom swell not wired | reuse + new swell |
| S24 | Today / the Rite | Bed: today's Śakti's ring ground (her ring's Design technique at root, 0.16) under her carrier (amount × 0.1). Each rite beat lands as one struck tone (S12). Opening bell 272.2 Hz 5.5 s at .2 with one rigid haptic, once per practice day; closing bell 136.1 Hz 7 s at .22 with a double soft haptic (built). Sealing: the bowl at 220 Hz — partials ×1, 2.004, 2.98, 4.02 at 1/(2.2i+1), 0 → .075 in 90 ms → .0001 at 11 s; the bed ducks to .006 over 1.2 s and returns to .030 by 9 s. Writing the Recognition: ink tone 174 Hz through a 600 Hz lowpass, 0 → .014 over 2.4 s while typing. Text arrives on the exhale of one 10 s breath (in 40% · hold 15% · out 40% · rest 5%). Binaural arc on her carrier: arrive 8 α @.006 → descend 6 θ → hold 4.5 → Recognition 4.0 → surface 7.5 → 10. Optional pre-roll (S59). 'The Bell, Three Breaths': a bell sounds only when he taps it; three breaths; back to where he was. | G7-0132 G6-0874 G5-0413 G5-0066 G4-0462 G4-0616 G6-0764 G3-0291 · 19-code-mandala-today.md:441-444,798; 17-code-core.md:733; 13-rupakarshini.md:352,370-371,918; 12-padakarshini-field.md:320; 09-field-scores.md:644; 10:461; 16-airtable-asg.md:324; 06:2176-2182 | **partial** · Today/TheBells.swift (built); BijaSoundService.swift:258-302 (two bowls); RiteOfEntering.swift (strike) | reuse bells/bowls; new ink, bowl-220 duck, beat arc |
| S25 | The Mandala: the enclosure's own voice | While the glass falls inward the WORLD bed is the ground technique of the enclosure it is in (root r), at 0.16 − 0.0125·(r−1) (quieter deeper) while the Om rises by depth. Ring 7's chord and ring 8's unite move OUT of LivingMandalaView into their ring worlds (S35, S37); on the Mandala the crossing only rings the bell and speaks the ring bīja (S26, S27). Every inward crossing writes Ring Crossed (once per new depth). | G7-0098 G7-0213 G7-0024 G2-0180 · 19-code-mandala-today.md:80-86,338-344,720-738,795; 04:283 | **partial** · Mandala/MandalaFieldVoice.swift:39,46-49; LivingMandalaView.swift:671-696 | move ring-world sound to ring worlds; reuse crossing hook |
| S26 | Nine bells, one per enclosure, falling inward | Inward crossing only (outward silent; 55 ms throttle; gold ring flash syRingFlash 1.5 s, width 2.5/scale). bell(r) = root(10 − r) × 4 — the fall sounds the Climb's roots in reverse, two octaves up: R1 493.88 · R2 440.00 · R3 392.00 · R4 370.00 · R5 329.64 · R6 293.68 · R7 277.20 · R8 246.96 · R9 220.00 Hz — nine bells for nine āvaraṇas, descending inward ('deeper rings ring lower and rounder'); five of Design's eight pitches survive exactly (392, 329.6, 293.7, 246.9, 220). Design's bell kept verbatim: 1.7 s; .0001 → .085 in 12 ms; lowpass 2400 → 700 over 80%; partials (×1, 1, 1.7 s) (×2, .30, 1.19 s) (×2.76, .16, .85 s) (×.5, .22, 1.53 s). | G1-0479 G1-0512 G5-0171 G2-0473 G2-0190 G7-0198 G2-0181 · 02-rite-axis-field.md:611-617,851; 12-padakarshini-field.md:483,926; 13-rupakarshini.md:377-378,895; 04:284,301,758; 19:655 | **partial** · LivingMandalaView.swift:680-683 (ring bīja or chime); RingAudioService.swift:191-196 (528×0.917^(r−1)) | reuse crossing hook; new bell table + Design bell voice |
| S27 | The falling mantra (RingBija), retuned and allowed to be seen | Each inward crossing also speaks the enclosure's bīja (HomeWorlds.ringCharacter), 180 ms after its bell, at bell(r) × the vowel's interval (a 1 · i 3/2 · ai 5/4 · au 5/3), gain 0.6 × bell; duration 1.2 × bell(1)/bell(r) s (ring 1 1.2 s → ring 9 2.69 s); ring 8 sounds its three syllables. Bījas may sit in the yantra (settled): the syllable may surface for its duration at its enclosure (opacity .55 → 0), so 'sounded, never written' is lifted — the test changes. | G6-0821 G6-0876 G7-0970 G7-0683 G5-0325 · 17-code-core.md:478,735; 22-code-tests.md:208-215,578; 12-padakarshini-field.md:1010; 13-rupakarshini.md:389-390 | **built** · Services/RingBija.swift:16-141 (root 528×0.917^(r−1)); MandalaLightTests.swift:333-418 | reuse; retune to bell(r); update test |
| S28 | Nine ring grounds (Design's techniques, one tuning) | f = root(r). 1 drone: sine f + sine f×1.0035 (0.8, slow beat) + triangle 2f (0.16) · 2 breath: sine f + 1.5f (0.3), 0.14 Hz LFO on amplitude depth 0.55 · 3, 6 breathy: sine f (0.7) + saw 1.002f (0.1) + saw 2.01f (0.05), bandpass 4f Q 1.6 · 4, 5 stepped: f × [1, 9/8, 5/4, 3/2] every 5.2 s (ring 4) / 3.4 s (ring 5) + sine f/2 (0.4) · 7 sourceless: sines 2f (0.42), 3f (0.26), 5f (0.14) — no fundamental · 8 triad: f (0.7), 1.26f (0.6), 1.5f (0.6), every 14 s upper two glide (tc 3.4 s) to f and back · 9 Shepard: five sines f·2^(k−1), gain 0.22 ± 0.22 by 0.021 Hz LFO, detuned k×3 cents. On phone speaker an extra 4f partial at 0.5 × fundamental gain so the ground is heard, not only felt. Ground crossfade setGround: i0 (1−k)·0.16, i1 k·0.16 (τ 0.9 s). | G1-0025 G1-0280 G2-0073 G6-0814 G6-0815 G7-0967 G1-0330 G2-0063 G2-0375 G2-0385 G2-0340 · 01-homes.md:87,128,639-648,796-805; 04:124,139,550,612,627; 17-code-core.md:410,434; 22-code-tests.md:575 | **partial** · HomeSoundService.swift:104-115,253-361 (Design numbers); RingAudioService.swift:79-307 & RingFieldVoice.swift:19-96 (other tuning, six voices dead per RD-08) | reuse HomeSoundService voicings as the single ground engine; RingFieldVoice reads it |
| S29 | Ring 1 · Bhūpura Earth-City world sound | Ground = ring 1 drone at 55 Hz (Design technique; the 'drone ~73 Hz plus a fifth' of HO2-02 is retuned and loses its fifth); no breath. Tap a light → her carrier struck; tap a family in the legend → its band illumines with the three-bell cluster of that band (bell(1) × [1, 5/4, 3/2] at .03); tap a gate → all 28 alight with the ring-1 bell then the Om swell +.02 for 4 s. | G2-0067 · 04-briefs-audits-frames.md:133 | **not-built** · — | new world sound on S28 |
| S30 | Ring 2 · the Inhabited Lotus | Press-and-hold a petal: she rises; the other petals' voices mute to ×0.18; her carrier rises over the home breath (root 61.74 + 1.5f, LFO 0.14 Hz); on release 'she remains' 2.6 s — her carrier holds 2.6 s then decays τ 1.4 s. The Heart Register (S70) is offered here first (Sa = his choice). | G2-0076 · 04-briefs-audits-frames.md:142 | **not-built** · HerDeepeningSection.swift:153 (Heart Register ring 2 only) | new world sound on S28 |
| S31 | Ring 3 · the Smoke Lotus | Eight bodiless plumes over the breathy ground (69.30 Hz). Reaching scatters them and thins the voice (bandpass Q 1.6 → 0.8, gain ×0.5); stillness gathers them (8 s breath; gain back over 8 s). Tap a plume → her quality and a w3Note (sine f + 2f, 1.6 s, .09) at her carrier; tap the seed 'hsauṁ' → all eight sound at the ring's carrier (hsauṁ → h → ratio 1 → 138.6 Hz) spread ±3 cents, 'the longing-tone'. 'The more you reach for her, the more she thins.' ⇄ 'Be still — and the bodiless longing gathers.' | G2-0068 G2-0412 G1-0716 · 04-briefs-audits-frames.md:134,676; 03-mandala-worlds-layers.md:564-566 | **not-built** · — | new world sound on S28 |
| S32 | Ring 4 · the Lineage | Fourteen stations on a garland; the transmission light travels with the stepped note (73.42 × [1, 9/8, 5/4, 3/2] every 5.2 s), one step per station; tap the centre to resend; tap a station → 'the Nth of fourteen — received, and passed on' and her carrier; full garland in 9 s. | G2-0069 · 04-briefs-audits-frames.md:135 | **not-built** · — | new world sound on S28 |
| S33 | Ring 5 · the Overflow | Ten triangles in a boundary circle over the stepped ground (82.41 × steps every 3.4 s). Touch → light spills past and a swell (w3Sustain at her carrier, .05, vibrato 5, LFO .25 Hz) rises over 2 s; centre → all overflow, the boundary dissolves, the swell reaches .075 at 11 s. | G2-0070 · 04-briefs-audits-frames.md:136 | **not-built** · — | new world sound on S28 |
| S34 | Ring 6 · the Concealed | Ten hidden triangles; a light follows the touch; the breathy ground (92.50 Hz) is near-subliminal (gain ×0.35). Near a triangle her name surfaces and her carrier whispers (.02, 1.2 s) then conceals ('she will not stay'); 13 s cycle. | G2-0071 · 04-briefs-audits-frames.md:137 | **not-built** · — | new world sound on S28 |
| S35 | Ring 7 · the Vāk Chamber — twelve voices, fifth withheld | The Airtable twelve (kp 87–98: eight Vāsinīs + four Weapons) on r140 at 30° steps (fixes the 45° overlap), nodes 44 px, bīja 18 px italic (where she has one), name 10.5 px; centre chord disc 60 px; bg #0E0703 → #0A0502 → #060301, radial rgba(212,160,23,.16), triangles stroke #E8C97A .12. Voices = the hexatonic ladder on ring 7's root with the fifth withheld: 196 × [1, 9/8, 5/4, 4/3, 5/3, 15/8, 2, 9/4, 5/2, 8/3, 10/3, 15/4] = 196.00 · 220.50 · 245.00 · 261.33 · 326.67 · 367.50 · 392.00 · 441.00 · 490.00 · 522.67 · 653.33 · 735.00 Hz in kp order. Tap → strikeOne: playBija(f, 2.6 s, .11) (sine f + 2f; 0 → vol .15 s → ×.85 at .7 dur → 0), clears 2400 ms; centre → chord: each (f, 3.2 s, .05) staggered i×55 ms, clears 3400 ms. Healed felt at ≥ 7 of 12 — no counter shown (drop '{n} of 12 voices sounded'); healed line 'The word that healed what the mind could not reach.' / 'she who removes all disease'. Under it the sourceless ground (196 · 294 · 490 Hz). | G1-0617 G1-0705 G1-0706 G2-0077 G2-0136 G2-0419 G2-0447 G2-0099 G6-0875 · 03-mandala-worlds-layers.md:50,503-525; 04:143,170,222,683,732; 17-code-core.md:734 | **partial** · RingAudioService.swift:383-403 (Vāk 12 at 220…659.25, 55 ms stagger) | reuse chord engine; retune; move into Ring 7 world |
| S36 | Ring 7 resonance: the screen resonates | In the Ring 7 world a continuous haptic (intensity .12, sharpness .1) swells on each 15 s breath cycle with the tone pulse; a barely audible ring bīja tone at .006; tapping a Vāk-devatā plays her voice with a long, slow attack (.6 s instead of .15 s). | G1-0648 · 03-mandala-worlds-layers.md:149 | **not-built** · — | new (HapticLibrary.breath) |
| S37 | Ring 8 · Mūla Trikoṇa: three tones become one | Triad on ring 8's root, two octaves up: Icchā 220.0 (apex, #C45050) · Jñāna 277.2 (bottom-left, #9A8FC4) · Kriyā 330.0 (bottom-right, #5A9A8B), gain .33, master .06. Tap a vertex → all three glide (τ .55 s) to that vertex's pitch; hold still 6 s or press the centre → all glide (τ 3.4 s) to 110 Hz, 'the three were never three' (name 76 pt), then dissolve into the Om as ring 9 opens. Maya's 76 s loop split (Knowledge · Will · Action) uses the same three pitches. | G1-0702 G2-0078 G2-0395 G2-0549 · 03-mandala-worlds-layers.md:482-485; 04:144,649; 05-chakra-corpus.md:374-378 | **partial** · RingAudioService.swift:226-271 (261.63/311.13/392 → 130.81); RingFieldVoice 231-279 | reuse TriadVoice; retune; move into Ring 8 world |
| S38 | Ring 9 · Praveśa: the Shepard fall (and Spanda) | Press and hold to fall: K = 7 octave-stacked sines from fMin = 30.87 Hz (ring 9's root B2 / 4) gliding down forever: f = fMin·2^(phase·7); phase descends .05 + .10·intensity per s; amplitude exp(−((phase − .5)/.26)²)·.42; master .07·intensity; intensity = .25 + .75·clamp((speed − .6)/2.4). Hold past the falling → stillness → the Om alone; 'You did not arrive. You were the arriving.' Spanda (Direction A) kept as a second visit: sine 146.83 + 220 (.5) + sub 73.42 (.6), master .06 × bloom — already in the tuning. | G1-0723 G2-0072 G5-0416 G2-0218 · 03-mandala-worlds-layers.md:604-606; 04:138,344; 13-rupakarshini.md:379-380,896 | **partial** · RingAudioService.swift:420-437 (Shepard 7 voices from 32.7 Hz); RingFieldVoice fallThrough 3.2 s | reuse ShepardVoice; retune fMin; Spanda new |
| S39 | Gates of Release: the threshold tone | When a ring completes and the next rises: the held yantra dims; the ground shifts one interval (setGround from root(r) to root(r+1), τ 0.9 s); one haptic (completion .8/.5); the crossing date is recorded. | G2-0151 · 04-briefs-audits-frames.md:244 | **not-built** · — | new on S28 |
| S40 | The Climb: nine drones and the narrowing beat | Nine ground voices crossfade with the climb fraction (setGround i0, i1, k every 0.1 s); entering a light brings her carrier up and 'her world's air thickens and swallows the surroundings' (setRoom(0.25, 0, ring)). A binaural pair on the current root ×2 narrows as he rises: 8 → 7.5 → 7 → 6.5 → 6 → 5.5 → 5 → 4.5 → 4.2 Hz across rings 1–9, → 4 Hz at the summit; no event above .075. Summit: the reveal chord 136.1 · 272.2 · 408.3 Hz over 9 s, a struck bowl to seal, an 8.5 s stone-room tail (convolution). The 102 lights stay alike; Schumann 7.83 passes through once at the apex (designed:true, badge). | G1-0093 G2-0283 G5-0057 G7-0347 · 01-homes.md:250; 04:438; 12-padakarshini-field.md:305,330; 13-rupakarshini.md:372-373,944; 20-code-play-rooms.md:414-415; 16-airtable-asg.md:298 | **partial** · WorldClimbView.swift:124 (RingFieldVoice + HomeSoundService grounds every 0.1 s) | reuse grounds; new beat ladder, reveal chord, tail |
| S41 | Her Home: the room's sound graph | HomeSoundService unchanged in its Design numbers: master 0 → wake 0.5 (τ 1.2 s), stop τ 0.5; lowpass 220 Hz Q 0.7; setCarrier gain amount × 0.1 (amount = swallow); setRoom: lowpass 220 + 1500a (τ 1.4) 'her adaptation opens the filter', fifth (S12), air: 4 s looped white noise × 0.5 → bandpass 380 + 700a Q 0.6 → gain 0.006 + 0.012a (bypasses lowpass). beginEnter: chamber scale 0.02, STATION [0, .30, .62, .88, 1], strike at each beat, rite overlay fades in 700 ms. Ground fifth ×0.75 at 0.035 (the Field's absent-fifth) kept. Glissando on descent: sine + 0.22 octave, rising over the first 1/8, 0.05. Ruling: the room is whole with sound off; the 'no volume' clause is lifted (S06). | G1-0281 G1-0077 G6-0816 G6-0817 G6-0820 G7-0696 · 01-homes.md:222-223,651-654; 17-code-core.md:439,451,474; 22-code-tests.md:268 | **built** · HomeSoundService.swift:79-1176; HomeVoice.swift:19-277; GlissandoVoice.swift | reuse |
| S42 | The inverse gain law: she sounds more when you are quiet | Wherever something else plays (a song, the Leela, the Rite chant, his humming), her room tone or the binaural follows base + 0.025·(1 − E), E = live RMS of the other source via an installTap (10 Hz poll). 'They share the field; they do not compete.' 'Listen to the gaps' (C-1297) is this law heard. | G4-0463 G4-0300 G3-0481 · 09-field-scores.md:18,645; 10:460,647; 07-codex.md:810-813 | **not-built** · Bindu Field DSPWireService (sister app, built) | port DSPWireService RMS tap (move from Field) |
| S43 | Her syllable sets the visual rhythm | Pulse rate, particle rhythm and light-breath in her room lock to her carrier: period = 1 / (carrier / 2^n) folded into 0.8–1.6 s (n chosen so it falls in range); the same value drives the haptic breath in her room. | G1-0046 · 01-homes.md:147 | **not-built** · — | new (shared clock from HomeCarrier) |
| S44 | Seat sound-worlds: the Mātṛkā letters and the standing wave | Ring 1 Mātṛkā seats (kp 11–18): n = 5, 8, 11, 14 slats; as a slat turns to 'the point of being spoken' (emissive peak) a letter-tick at her carrier × (1 + i/n) at .01 sounds — the letters were never separate from the voice. Ring 7 seats (kp 87–98): standing-wave wall with mode n = 2 + (kp mod 8); the room hum is her carrier with AM at n × 0.25 Hz; at the n node sprites ('where the syllable is silent') the AM dips to 0. | G1-0132 G1-0139 · 01-homes.md:454,468 | **not-built** · — | new on S41 |
| S45 | Her songless dance (sustain mode) | No Śakti has a song; nothing invented. A songless Score from her own sound: Gaia = āvaraṇa ground; Sid = her carrier held; Arch = her bīja when struck; Karishma = the silences between breaths; Sakshi = ring position at the edge; Ashrey = web to kp ± 1; Bindu = his touch. Bloom follows a 5.5 s breath. Data: Mandala row (kp, ring, subtleBodyChakra fld6deGFzModjBmoj, colour, syllable, mudrā). Bindu is the dancer; she is the field (no figure). | G4-0232 · 08-dances.md:1086-1104 | **not-built** · AirtableService.swift:340 (subtleBodyChakra read) | new Score type 'songless' in the Score player (S62) |
| S46 | A ring drawn by hand, settling true | Each return to a Śakti draws a hand ring that enters off-centre and settles over 4 s; its tone enters 1.5% flat (hz × .985 → hz over 4 s), gain 0 → .036 at 3.2 s → .020 at 6 s → 0 at 9 s, with the fifth hz × 1.5 at .14 only if grantsFifth; returns step [2, 3, 4, 4.5, 6, 8] × root. | G5-0065 · 12-padakarshini-field.md:318; 13-rupakarshini.md:212-215,987 | **not-built** · — | new |
| S47 | Her Presence (the portrait): her carrier, held | Under the portrait her carrier is held at amount .3 (gain .03) over the air layer; the glyph tap (S13); no figure, no voice of hers except his recordings (S14, S80). | G4-0482 G4-0167 G4-0499 · 09-field-scores.md:723,793; 08-dances.md:805-811,1151,1229 | **partial** · Her Presence view exists; glyph tap hash-pitched | reuse S41/S13 |
| S48 | The 33 rooms: one fixed tone each | Each room keeps one fixed tone; every strand except the dance sits on it (practice drone .012, gate arrival, wake-up binaural carrier = tone ÷ 2). 1 Bindu: Om 136.1 (no awakening) · 2 Muladhara 174 · 3 Svadhisthana 210 · 4 Manipura 320 · 5 Anahata 341 · 6 Vishuddha 384 · 7 Ajna 426 · 8 Sahasrara 480 · 9 Shadow: no tone — the word he offers; deepest binaural 2.5 Hz δ on 136.1; the pulse begins · 10–19 body rooms take their Map Mirror Frequency: Soles 174 (LAM) · Forge 320 (RAM) · Prana 210 (VAM) · Hands 341 (YAM) · Pulse 341 (YAM) + heartbeat 68/52 · Sonar 384 (HAM, sending) · Echo 384 (HAM, very soft, then silence) · Vision 426 (OM) · Axis 426 (OM) · Crow: silence (Sahasrara mirror) · 20 Armin: D2 73.42 Hz drone 55 s at .008–.014, never resolves · 21–29 mind rooms: 110 Hz + its fifth breathing every 10 s (BC-09 'rooms about the reader') · 30 Maya: silence — the Om was always playing · 31 Aatma 528 (Trinity, detune −2/0/+2) · 32 Ego Reveal: sealed; the pulse stops; no tone · 33 Lalitā: no seed — the Om at its highest (.20, 'Go Play'). The room entry plays the room tone's threshold (S09) instead of the 110 Hz vāk tone. Body/mind tone choices are derived (Mirror Frequency field; BC-09), not invented. | G2-0597 G2-0605 G2-0613 G2-0621 G2-0629 G2-0637 G2-0645 G2-0653 G2-0662 G2-0670 G2-0678 G2-0686 G2-0694 G2-0702 G2-0710 G2-0718 G2-0726 G2-0734 G2-0742 G2-0750 G2-0758 G2-0766 G2-0774 G2-0782 G2-0790 G2-0798 G2-0806 G2-0814 G2-0823 G2-0831 G2-0842 G2-0929 G3-0038 G3-0039 G3-0040 G3-0041 G3-0042 G3-0043 G3-0044 G3-0045 G3-0046 G3-0055 G3-0057 G3-0067 G3-0068 G6-0492 G6-0564 G6-0605 G6-0539 G6-0774 G6-0775 G7-0481 G7-0358 G7-0971 · 05-chakra-corpus.md:469-2685,3365; 06-chakra-skills.md:104-134; 15-airtable-map.md:108-109,441-444,1371,1405; 16-airtable-asg.md:340-341; 20-code-play-rooms.md:440,722; 22-code-tests.md:579 | **wrong** · ChakraRoomView.swift:608-616 (110 Hz entry); PlayPhysics.swift:506-532 (AwakeningTones keyed by ring 1–8) | re-key AwakeningTones by room (reuse); bake tones into ChakraConstellation.json (new) |
| S49 | The gate-arrival sound (C-AWAKE, verbatim) | On a completed hold gate (4000 ms; P7 3000; P8 1500; Room 2 3500 heavy · 3 3200 · 4 2800 · 5 2600 · 6 2400 · 7 2000 · 8 1800 · 31 1500): haptic 80, then the room's tone synthesized — gain 0 → .25 attack (scaled ×0.3 into the app's ceiling), sustain, exponential decay; integer harmonics (Muladhara [1,.5,.25]; Svadhisthana [1,.6,.3,.15]; Aatma [1,.5,.35,.25,.15] detune [−2,0,+2]); sub at f/2 gain .3; 50 ms band-pass noise transient at f (Q 5); 80 ms delay at .15. Timbres: 174 'earth drum, the ground announces you' · 210 'wooden bell' dcy 2.8 · 320 'struck gong, inharmonic' atk .005 · 341 'crystal bowl, love lingers' dcy 3.5 · 384 'singing bowl, voice frequency' · 426 'shimmer, detuned twin 1.5 Hz' · 480 'bell from three rooms away' dcy 4.0 · 528 'three tones at once'. Gate fades 1.5 s. WakeupMoment tone length max(8, 90 × pace × .2) s. | G3-0210 G2-0515 G2-0529 G2-0852 G3-0191 G7-0444 · 06-chakra-skills.md:1214-1236,1424-1441; 05-chakra-corpus.md:200-206,274-279,2807-2809; 20-code-play-rooms.md:601 | **partial** · shell-moments.jsx 101-128 (web corpus); app: none | new AwakeningVoice (port from web) |
| S50 | The wake-up binaural, on the room's tone | Each wake-up panel keeps its authored beat arc and gain shape, with the carrier moved to the room tone ÷ 2 (one tone per room): P1 Muladhara 87 Hz: beat 0 → 4 Hz over 4 s (descent) → 2 Hz over 8 s (shift); gain 0 → .12 over 3 s, +.02 per Śakti tapped up to .2, .25 → .10 over 42 s, fade 6 s · P2 105: 6 → 4 · P3 160: 8 → 12 with wobble · P4 170.5: 6 → 5 → 4, breath swells on exhale · P5 192: 6 → 7 → 8 · P6 213: 4 → 2 · P7 240: 1 Hz then silence, gains .08 → .06 · P8 264: 0.5 Hz, .04 → .06 · Shadow: 2.5 Hz δ on 136.1. Panel gains are scaled ×0.2 into the binaural range (.25 → .05). Axis triptych (P10): 4.5 θ → 40 γ → 10 α across its three songs. | G2-0521 G2-0533 G3-0192 G3-0193 G3-0194 G3-0195 G3-0196 G3-0197 G3-0198 G3-0199 G3-0082 G3-0209 · 05-chakra-corpus.md:235,297-303; 06-chakra-skills.md:244-249,1238-1351,1407-1420 | **not-built** · — (Bindu Field BinauralEngine built in the sister app) | new on S57 |
| S51 | Room 30 · P9: the Om ceremony and the ending song | In Maya the binaural is replaced by the Om (S16 at P9 staging). 'Think of the fear…' (1 s); Om crescendo from 5 s; 'Who are you speaking to?' tap dissolves (haptic 80, Om swells to .15). Phase 7: at 10 s the Om falls to 0 and tree-of-life/maya-chakra-ending.mp3 fades in to .7 (loop 75.86 s) under the 76 s cycle dot → line → circle → ∞ → ♥ → contract → travel → triad split (S37 pitches) → merge. Seed: 'There is never anything to fear. There is only You, playing.' (ruling 8). | G3-0207 G2-0546 G2-0543 · 06-chakra-skills.md:1397-1401; 05-chakra-corpus.md:338-359 | **not-built** · TreeOfLife.swift Panel 9 dissolutions (visual) | new on S16 + S62 |
| S52 | Maya's transparency: every seed he carried, once | In room 30, 'every bīja the walker has carried — LAM through the crown's silence — sounds at once here and resolves into the quiet behind them': read the ledger (Chakra Practiced rooms 2–8 → their room tones; Shakti Recognized / Light Entered → their carriers), sound them as one chord at .006 each (cap .075 total), fade to silence over 9 s; only the Om remains. | G6-0571 G2-0823 · 15-airtable-map.md:1379; 05-chakra-corpus.md:2431-2437 | **not-built** · ActivityLedger.swift (types exist) | new |
| S53 | The pulse: 60 bpm from Shadow to the Reveal | From room 9 to room 32 a warm 60 bpm haptic at the bottom of the glass (Core Haptics transient intensity .35, sharpness .15) and, if 'tone' is chosen, a 58 Hz sine at .028 depth on a 1 Hz LFO with a glow arc. Never explained, never in a tutorial. At room 32 it stops: 'I never left. I changed my voice.' | G2-0657 G2-0856 G2-0912 G3-0123 G3-0260 · 05-chakra-corpus.md:982-983,2826-2831,3158-3162; 06-chakra-skills.md:534-536,1932-1936 | **not-built** · shell-ground.jsx 69-96 (web) | new (HapticLibrary.pulse) |
| S54 | Gates that listen and feel (mic and motion) | Mic FFT (AVAudioEngine input tap, fft 256, smoothing .8): Soles/Forge humming bins 2–12 avg > 40 · Prana breath bins 1–40 > 20 · Hands friction 1–30 > 25 · Sonar speech 3–15 > 35 for ≥ 3 frames · Echo 12-bar visualiser, presence 2:00 · P5 voice level += vol × .012 when vol > .05, complete ≥ .92. Motion: Crow shake > 7 m/s² then still < 1.8 · P3 shake windows 500 ms (gentle > 5, rhythmic > 9, violent > 25) · P6 rotation < 4°/s. Every listening gate has a tap fallback (+.14 per tap) and a 20 s safety. C-1311: the subtle seven ask stillness; eyes and heart ask movement (blink for Axis, shake for the euphoria pulse). | G3-0047 G3-0190 G7-0439 G7-0490 G3-0491 · 06-chakra-skills.md:113,1202-1209,1272-1324; 20-code-play-rooms.md:599,742; 07-codex.md:860-863 | **not-built** · no mic input anywhere in Play/Rooms/Chakra | new MicGate (conductor-owned .playAndRecord) |
| S55 | Armin: the drone that never resolves | Room 20 (Armin): a D2 73.42 Hz drone held 55 s at .008 → .014, never resolving (absent root of D major); the textarea gate 340 px. | G3-0057 · 06-chakra-skills.md:123 | **not-built** · — | new on S48 |
| S56 | The dance strand: his song under its Score | Offer one word → seven named dancers (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey's web; Lalitā and others by ruling 6) moved by the song's arrays; seed typed at BPM (Svadhisthana 857 ms/char at 70 BPM; Muladhara 460 ms at 129); mirror words at MIRROR_TIMES; the word revealed at PEAK_T in the bottom 15% (letter-spacing dissolve 3.5–4 s), 'I Love You' at PEAK_T + 5 in the bottom 10%; DARK_RATIO P1 1.0 … P9 0.0; return by element. Songs: tree-of-life/<chakra>.mp3 for rooms 2–8, 30, 31; bindu/in_shadow.mp3 for 9; Axis triptych needs Where'd You Go / Thunderclouds (bindu/play.mp3) / Fade Away (bindu/fade.mp3). The song's carrier (absent fifth from its Score: R2 146.8 · R3 146.8 · R4 164.8 · R5 155.6 · R6 138.6 · R7 138.6 · R8 146.8 · R9 146.8 · R30 155.6 · R31 130.8) plays only during the dance. Fruit lines verbatim; count lines ('You have arrived N times') dropped — nothing counts him. | G2-0534 G2-0535 G2-0536 G2-0539 G3-0217 G3-0218 G3-0219 G3-0220 G3-0221 G3-0222 G3-0223 G3-0224 G3-0226 G3-0227 G4-0209 G4-0210 G4-0211 G4-0212 G4-0213 G4-0214 G4-0215 G4-0216 G4-0217 G4-0218 G4-0341 G6-0748 G6-0697 G6-0698 G6-0696 G3-0094 G3-0101 G3-0108 G3-0088 G3-0313 G2-0501 G2-0512 G2-0525 G7-0446 G6-0767 G4-0226 G4-0245 G4-0586 G4-0578 G4-0461 G6-0376 G6-0377 G6-0378 G6-0379 G6-0380 G6-0381 G6-0382 G6-0383 G6-0384 G6-0385 G6-0386 G6-0387 G6-0388 G6-0389 G6-0390 G6-0391 G6-0392 G6-0393 G6-0394 G6-0395 G6-0396 G6-0397 G6-0398 G6-0399 G6-0400 G6-0401 G6-0402 G6-0403 G6-0404 G6-0405 G6-0406 G6-0407 G6-0408 G6-0529 G6-0530 G6-0531 G6-0532 G6-0533 G6-0534 G6-0535 G6-0536 G6-0537 G6-0538 G6-0687 G6-0688 G6-0689 G6-0690 G6-0691 G6-0692 G6-0693 G6-0694 G6-0695 · 05-chakra-corpus.md:120-324; 06-chakra-skills.md:301-430,1539-1679,2457,2471; 08-dances.md:959-1025,1147,1430; 09-field-scores.md:183-197,643,710; 10:260,285-288; 15-airtable-map.md:272-304,426-444,1405; 16-airtable-asg.md:206-220,299,327; 20:604 | **not-built** · — (web dances live; app has none) | new on S62 (Score player) + S64 (bundle) |
| S57 | The binaural engine (true L/R) | Port Bindu Field's BinauralEngine (L/R sines with exponential glide, hard pan). Laws: 'The carrier doesn't move. Bindu point. Dimensionless. Still. Beat moves (brainwave story). Gain moves (presence).' Carrier = the absent sub-harmonic (Sid holds); modulation is Karishma (fills gaps); fixed:true wins over any DSP re-derivation (the Field's 10 s override is not ported). Beat schedule [{until, hz, state}] with smoothstep interpolation, wobble ±0.3, Karishma freeze windows, carrier_dropout (both oscillators → 0 over .35 s and back), gain law base + 0.025(1 − E) with phase multipliers, gyro tilt → pan 0.011. Pseudo-binaural (one sine through a panner) is retired. Mono Audio → isochronic fallback (S82). The 'missing basic' he asked for (C-1350) is this carrier: the song's absent fundamental inserted, louder in the song's silences. | G4-0164 G4-0299 G4-0328 G4-0576 G3-0319 G4-0089 G4-0372 G4-0384 G4-0394 G4-0582 G4-0495 G4-0561 G4-0590 G4-0611 G4-0317 G3-0508 · 08-dances.md:452-455,778-800,1145; 09-field-scores.md:17,126,163,293-312,387-408,468-472,787; 10-field-data-catalog.md:136-181,250-256,271,291,298,436-439; 06:2595; 07-codex.md:945-948 | **not-built** · Bindu Field: BinauralEngine, BinauralListener, BinduDSP, AudioSessionCoordinator (DO NOT MODIFY there) | move (port) from Bindu Field |
| S58 | Pink-noise floor (OL-1) | 7-coefficient pink noise, lowpass 4 kHz, gain 0.015 — the 'Hemi-Sync ground hum' under Scores, the Well and Beneath; default on inside Scores. | G4-0165 · 08-dances.md:803,1149; 10-field-data-catalog.md:466 | **not-built** · cross.html:2914-2949 (web) | new AVAudioSourceNode |
| S59 | Pre-roll resonance (OL-2) | Before a dance or Rite Score: the carrier alone fades in to 0.020; a 140 px ring breathes on a 5.5 s cycle; 'Breathe with the silence. The song begins when you do.'; tap twice or auto-advance after 10 s. Default on for the first three dances of a room, then offered. | G4-0166 G4-0333 · 08-dances.md:804,1150; 09-field-scores.md:168-169 | **not-built** · cross.html:21-28,88-92,2951-3034 (web) | new |
| S60 | 2.69 Hz — placed, never claimed | Three designed placements, each flagged designed:true and badged C (claim): (1) the last layer of the Bindu deep zoom — the beat glides to 2.69 Hz on 136.1 at .006 for as long as he stays; (2) wherever an authored Score places it (cross 164–166 s; levelup 'between'); (3) the 2.69 thread, a door in Beneath: the five dances in order Kingdom → Sound of Silence → Golden → Aatma → Maya ('see it → speak it → build it together → hold it at the edge of death → let it dissolve'). Discovered 2.69s in songs are left to the songs. | G4-0588 G4-0244 G4-0222 · 10-field-data-catalog.md:289,296-297,464; 08-dances.md:986-989,1146,1186 | **not-built** · — | new on S57 |
| S61 | Schumann 7.83 Hz pass-through | Once, designed:true: at the Climb apex (S40) and inside the Well's held silence — the beat becomes 7.83 Hz for 3 s, then returns. Badge T/C. | G4-0244 · 08-dances.md:1146; 09-field-scores.md:647 | **not-built** · — | new on S57 |
| S62 | The Score player (time-coded sound · light · motion · words · haptics) | One clock — the SONG bus player's sample time (or a free clock for songless Scores) — drives every track: sound (song gain, binaural beat_schedule, gain law, pink noise, pre-roll), light (Canvas bloom tiers 0–4, DARK_RATIO), motion (ensemble GEN_ORDER bindu·gaia·sid·arch·karishma·sakshi·ashrey; ENS_READS pitch·bass·sustained·mids·silence(inverse)·brightness·centroid+web), words (seed at BPM, mirror words, phase labels, word reveal at peak_t, 'I Love You' at peak_t + 5), haptics (hits i·20 ms when i > .4, 100 ms on drops, element grammar), return (reverse GEN, Karishma final bloom, spiral to the centre dot), memory writes. Swift ScoreV2 Codable mirrors score-format v2.0's 24 sections; validator rules score-format:700-731; unknown vocabulary_module → Layer 1. Feature arrays sampled at 0.5 s through an SC() interpolator. Animation starts only once currentTime > 0; hit index re-syncs to the real playback position. Fetch Score JSON from Airtable (Bindu Field table) with cache + modified-time; plays only Score Status ≥ Drafted; 'edit the JSON in Airtable, and the next fetch performs differently. No rebuild.' The pre-baked arrays are 'intelligence, not scaffolding' — live FFT only in mic rooms. The player he asked for (C-1350): play/pause, scrub, binaural on/off and full screen inside the dance; no mini-player carrying a song across worlds — a song's drone plays only during its dance (S07 seam instead). | G4-0564 G3-0527 G4-0304 G4-0560 G4-0340 G4-0208 G4-0297 G4-0117 G4-0113 G4-0570 G4-0361 G5-0435 G6-0645 G6-0647 · 09-field-scores.md:15,50,177-179,580,624-625,789; 10-field-data-catalog.md:123-134,200-205,240-246,536; 08-dances.md:588-605,638-639,945-957; 13-rupakarshini.md:431-432; 16-airtable-asg.md:122-126 | **not-built** · Bindu Field: Score.forTrack hardcoded (only track 27); Mandala: HomeSoundService Score overrides 212-220 (partial) | new ScorePlayer; reuse HomeSoundService override hook |
| S63 | The scoring tools stay offline | analyze_tone.py (Krumhansl-Schmuckler key; absent-fifth candidates 60–250 Hz scored 0.4·absence + 0.6·sweet; default carrier 136.0), temporal_analysis.py (bass coverage STRONG > 80% / MODERATE > 50 / SPARSE > 20 / ABSENT; STABLE if std < 30 Hz), deep_analysis.py (binaural-pair detection, stereo width, isochronic pulses; corr > .95 safe to add binaural), extract.py / extract_cli.py (H, E, B, P, T, EB/EM/EH, ED, DROPS at 0.5 s), the 10-step deep-dive protocol and the instrumental protocol ('What's Absent'). Run on any recording he adds (temple recording, bell, his bīja) to produce its Score; never on device. | G4-0556 G4-0557 G4-0558 G4-0109 G4-0110 G4-0565 G4-0568 G4-0584 G3-0513 · 10-field-data-catalog.md:99-119,207-228,279-281,517; 08-dances.md:560-584,1202; 07-codex.md:970-973 | **n/a** · scripts/*.py in bindu-field skill | reuse offline (no app code) |
| S64 | His recordings: bundled, verified, streamed only as fallback | All 40 unique mp3s on aistrangegame/aistrangegame.com (58 paths; b/ duplicates bindu/; 233.5 MB) are bundled under Audio/Songs/<path> (file weight is never a criterion). An Xcode Cloud ci_post_clone.sh fetches each from aistrangegame.com/<path> and verifies its sha prefix before the build; a missing file fails the build loudly. At runtime a file absent from the bundle streams from aistrangegame.com/<path> into Application Support/AudioCache and plays from there next time. Not on GitHub (no door until he adds them): miss, lift, abide, wake, Run-4 tracks, return, lalita-cross-1…4. | G4-0234 G4-0497 G4-0634 G2-0928 G4-0346 · 08-dances.md:1112-1119,1231-1232; 09-field-scores.md:202,790; 10:543; 05-chakra-corpus.md:3348-3355; audio-on-github.md | **not-built** · iOS tree has 0 audio files | new (bundle + ci script + cache) |
| S65 | Kingdom: the bed of Beneath | bindu/kingdom.mp3 (13:55 film score, carrier 146.8 D3 as absent root — the authored kingdom.md over the batch's 110) under its Score is the descent of Beneath: the 55 s non-fading drone, beat 5.5 θ, 'The throne at the center of every kingdom is empty.' The film leads; the binaural completes (HOME ≤ .040). One word: Sovereign. | G4-0219 · 08-dances.md:975-978 | **not-built** · — | new on S62 + S64 |
| S66 | cross: the threshold song | bindu/cross.mp3 (Ameno remix) with the only fully authored Score: carrier 110 A2 (absent fifth of D), 12-step beat schedule (8 → 7 → 7.5 → 5 → 5.5 → 4.5 → 7.83 → 2.69 → 4.5 → 6 → 7→9 → 10), gain ×1.3 at 161–166 s, ×1.2 at 145–180, ×0.8 at 200–230, final 3 s ramp; haptics crossing_peak, bell, mirror. Element 'threshold' — the first non-chakra element: the Score of the Gates of Release crossing into ring 9 and of the Veil's lifting, offered as a door. | G4-0220 G4-0375 · 08-dances.md:979; 09-field-scores.md:293-343 | **not-built** · — | new on S62 + S64 |
| S67 | before: Muladhara's second song | bindu/before.mp3 (Genesis, Justice): carrier A2 110; 'A long ascent, a plateau of full density, then a descent that goes lower than the beginning — and keeps going.' No return phase. Offered in room 2 as the second dance after Iron. | G4-0221 · 08-dances.md:980-985 | **not-built** · — | new on S62 + S64 |
| S68 | Songs of the people in the Relationship Field | Holding a person's star plays their song under its Score: Shweta — bindu/purity.mp3 (Two Groundings, B2 123.5, the 4.9 s seam held by the carrier alone at 0.004); Rey — bindu/levelup.mp3 (B2 123.5, 12 phases incl. 'between' at 2.69 Hz); also bindu/glow.mp3, bindu/play.mp3. Ruling 11: no new Airtable fields — the link is by Bindu Field Track Type = family and the person's name, read only. The personal readings are private and stay out. | G4-0223 G6-0749 · 08-dances.md:990-995,1185; 16-airtable-asg.md:300; 10-field-data-catalog.md:268,295 | **not-built** · — | new on S62 + S64 |
| S69 | The Relationship Field's voice | Bed: a beating pair on the Om's octave — 272.2 × [1, 1.005, 1.5, 2] at .28, .28, .15, .09 (a 1.36 Hz beat), lowpass 1100, LFO 240·.06. The three existing connections (Gaia·Ahaṅkāra kp31, Ashrey·Nāma kp40, Ram·Ātmā kp42): touching a connection sounds her carrier and the person's pair; their meeting is S18's convergence to 136.1. | G5-0595 · 14-aistrangegame.md:661-677 | **not-built** · — | new |
| S70 | The Heart Register (kīrtan / bhajan) reachable from every heart room | Built: drone on his own Sa (C–F, 130.81–174.61; default C♯ 138.59 = ring 3 root × 2), drone ratios 0.5/1/1.5/2 at .55/.70/.45/.25, six harmonics 1/n^0.8, reeds ±3 cents; four sargam phrases; note = breath/8 × 0.9; one breath of silence for his answer; bellows on BreathClock; 'Nothing is claimed for any tone'. Now reachable from any heart room, the menu and the Modes, not only ring 2; adds a japa mode — 'Ram, Ram, Ram' — where the drone holds and the call is his voice alone (C-1222). Kirtan calms (C-1169): no replay mechanic, nothing asks him to come back to it. | G6-0818 G6-0873 G7-0540 G3-0398 G3-0426 · 17-code-core.md:457,732; 21-code-layers.md:39,145; 07-codex.md:395-398,535-538,1237-1238,1268,1314,1360 | **built** · HeartRegister.swift:15-214; HeartRegisterView.swift:5; HerDeepeningSection.swift:153 | reuse; open the doors (small) |
| S71 | Body-element haptic and sound grammars in the 33 | EARTH 'da-DUM war drum' [i·30, 40, i·50]; FIRE crackle [15,5,15,5,20,5,15], backdraft [40,10,40,10,40,10,40,10,60]; HEART 'thub-THUB' [25,80,50] / [18,90,35] / [12,100,25], gasp [15,30,15,30,15,50,40,15,30], ambient [8,60,15]; THROAT sustained [15,40,12,50,10,60,8], below .3 'the whisper doesn't vibrate the body', roar at 247 s, silenceHaptic [4]. 'Gyroscope pans the tone — frequency exists in SPACE' (gyroX = (γ/45) × maxR × .25 × fluidity). | G3-0231 G2-0539 · 06-chakra-skills.md:1732-1741; 05-chakra-corpus.md:317-324 | **not-built** · — | new in HapticLibrary |
| S72 | A Strange Game's palette | Kept verbatim (Design of the play engine; 8 of its 12 pitches already sit in the Tuning table): bell(f) = f 2.6 s at .18 + f × 2.76 1.6 s at .05 + f × .5 3 s at .05; step 196 Hz triangle .16 s (560 ms per square in the Leela); rise 330 → 660 and 495 → 990 over 1.4 s; settle 247 → 123 over 2 s; breathIn 174 Hz 3.8 s; breathOut 261 → 196 over 4.6 s; rattle band-pass noise 1.9 kHz; bell pitches letter ready 880 · born 523 · arrive 392 · throw 660 · card 740 · pause end 523; haptics 8 on press, 12 at full, [10,40,10] on throw. PlaySound (built): struck tone 12 ms attack, decay exp(−3.2t/dur); thump 95 → 42 Hz .45 s; heartbeat lub 68 Hz, dub 52 Hz at +.14 s; drone f + .45·1.5f + .25·2f looped 10 s; entering a game from the field plays 272.2 Hz. Mantra Tuner: target bpm = tone / 8 from the room tones (S48), tuned within 5% after 6 taps (solfeggio retired). The Drum: 1000 ms ± 180, roots reach depth 20. Pulse: 8 taps → BPM. Child games keep their mechanics on the Tuning table (Finger Garden 110/220 — already in it). | G3-0240 G5-0240 G7-0293 G7-0280 G3-0239 G3-0242 G2-0869 G2-0870 G2-0885 G5-0190 · 06-chakra-skills.md:1824-1861; 12-padakarshini-field.md:523,579; 13-rupakarshini.md:494,966; 20-code-play-rooms.md:124-125,164-171; 05-chakra-corpus.md:2921-2986 | **built** · Views/Play/PlayInstruments.swift:163-328; PlayFieldView.swift:221-243; PlayPhysics.swift:506-532 | reuse; claim moves to SONG/ACCENT buses (S01) |
| S73 | Sounds that answer the hand | Law 11: every held gesture has its answering sound, ceiling .075, never on load: travel, trail, strain (bandpass Q 7, centre 300 + 1500f), give (0.5 s noise at 1.6 kHz), rush, gate (hz·3 → hz·1.5 over .9 s), carry (×1, 1.5, 2 struck .30 s apart), thin (174 + 261 → 348), ungrip (174 → 232 over 1.2 s), stillness tone swelling over 4.6 s. Timbres from the eleven voices (zeroth · ground · growth · hold · chant · gap · grace · witness · relations · play · self — waveform, partials, attack, release, pan, ornament: chant triangle [1,2] vibrato 4.6 Hz; grace shimmer sine at hz·6; play glide ×1.02; ceiling .55 relative), each pitched from the world's tone. | G5-0074 G5-0412 · 12-padakarshini-field.md:327-331,953; 13-rupakarshini.md:57,365-369 | **not-built** · — | new AnswerVoices on ACCENT bus |
| S74 | The Well: the Mirror's held tone and the verb's own phase | Bed: pink noise (S58) + the Om. The Mirror: binaural 110 Hz carrier / 3.5 Hz beat, gain .02 → .06 only while holding (.9 s ramp); blips arrival 174 · tunnel 220 · look 220 · glass 196 · inversion 196 · carve 233 · carved 246.9; exit 261.6 then 329.6 .7 s later. After any song in the Well ends, its carrier holds alone at .040 for its 'held' phase (Aatma: 'the verb is its own phase'). Schumann once inside the held silence (S61). | G5-0223 G4-0268 · 12-padakarshini-field.md:561-562; 13-rupakarshini.md:375-376,998; 08-dances.md:1208 | **not-built** · — | new |
| S75 | Beneath: the fall and the empty throne | Beneath = S38's Shepard fall as the gesture, S65's Kingdom Score as the bed, S60's 2.69 thread as its door, pink noise under. Four constants never reset (Bindu anchor, one pulse, sound as glissando, depth-trail): the Shepard is the glissando. | G2-0218 · 04-briefs-audits-frames.md:344 | **not-built** · — | new composition of S38/S60/S65 |
| S76 | Element arcs as gain and beat envelopes per ring | Each ring's element shapes its 3-minute dwell envelope (gain and beat): Ahaṅ fire → two blazes, one breath between; Nāma air → three inhales, long exhale before the fullest; Ātma light → twice, eye stays open; Amṛta water → three waves, two ebbs; earth → single descent; soul → twice through two silences; Maya → one breath (ruling 4 elements). | G4-0587 · 10-field-data-catalog.md:462,503 | **not-built** · — | new (envelope table) |
| S77 | Subtle-body sound fields | Ida/pingala/sushumna as the binaural itself: hard-left = ida (lunar), hard-right = pingala (solar), the beat = sushumna. Koshas as five concentric shells mapped onto enclosures (each shell a lowpass step). Bīja sessions only with his recorded voice. | G4-0572 · 10-field-data-catalog.md:243,485 | **not-built** · — | new (Modes door) |
| S78 | The haptics library (Core Haptics) | One HapticLibrary on the conductor's clock, warm never sharp (sharpness ≤ .3 unless named). Gesture set: tick .3/.4; word .3/.4; heart .5/.3; hold continuous .15 → .6 at sharpness .3 (G0 hold engine: commit on threshold, act on release, drain 620–750 ms on early release, no buzz on early release); completion .8/.5; Descent .9/.15 at 55%; kindle .6/.2; Still Point .25 → .15 → none (withdrawal at the deepest place). Panels: gate 80 ms, continue 40, pivot 50; D19 press start 12 ms, complete 20-40-30, none on tap-to-advance. Score set: crossing_peak [12,40,12,40,12,60,30,12,40]; bell [20,30,40,30,20] × hit; mirror [8]; the_strike [8,20,8,400]; fulcrum [30] at 50 bpm; charge [25] at 46 bpm; thunder roll [30,40,50,40,30]; hit tiers i·20 ms when i > .4, 100 ms on drops; a peak haptic at every Recognition. Element grammars (S71); the pulse (S53); ring 7 breath (S36). Web ms arrays convert to CHHapticEvent transients/continuous segments; respects system haptics and the Sound sheet switch. | G5-0124 G3-0268 G4-0375 · 12-padakarshini-field.md:419,954; 13-rupakarshini.md:501-502,855-856,1023; 06-chakra-skills.md:2009; 09-field-scores.md:334-343 | **partial** · Theme/Haptics.swift (3 UIImpactFeedbackGenerator calls); ActivationCycle, TheBells, RiteDayLayer, TheEightDissolutions, MandalaThresholdMoment, RecognitionLight use it | new HapticLibrary; Haptics.swift calls route into it (move) |
| S79 | Lalitā's voice: recorded, never generated | Four timed moments in a Score (−1 s, valley, apex, pre-close; volume .55): 'Notice your breath. The field is already breathing with you.' / 'The threshold is asking only that you wait.' / 'You don't have to do the crossing. Let it cross through you.' / 'What just happened, happened. The bells are saying so.' They play only from his recordings (lalita-cross-1…4 — not yet on GitHub); until then the moments are silent. The Oracle's generated text is not ported. | G4-0167 G4-0482 G4-0499 · 08-dances.md:805-811,1151,1229; 09-field-scores.md:723,793 | **not-built** · — | new slot in Score player (OL-3 off until recorded) |
| S80 | Accessibility of sound | Nothing depends on hearing: every meaningful sound has a light or haptic twin (bell ↔ ring flash; strike ↔ beat light; Recognition ↔ peak haptic). Mono Audio on (UIAccessibility.isMonoAudioEnabled) or speaker route → binaural becomes an isochronic pulse on the same carrier (AM at the beat Hz, depth .5). VoiceOver: the sound glyph is 'Sound, on/off' with hint 'double-tap and hold for sound settings'; sliders adjustable by swipe; Sanskrit tones carry English labels ('Bīja syllable Kaṃ — double-tap to hear'). Hearing-safe: limiter −1 dBFS, binaural ≤ .050, no event above .075, no sudden onset (≥ 12 ms attack). Every mic or motion gate has a tap fallback. Haptics can be switched off without losing any step. Reduce Motion never silences sound. | G1-0594 · 02-rite-axis-field.md:1622-1631 | **not-built** · MandalaVoice feeds VoiceOver labels (no sound a11y) | new |
| S81 | Sound floors as tests | New tests: the mixing law (beds sum; Om never zero while master on; one SONG source); no generated voice (no AVSpeechSynthesizer or TTS API in production); the Tuning table (every frequency the app emits is in Tuning.allowed or derived); the retired sets never appear; Score Status gate; S80's ceilings. STEP 10 see-and-feel on Neev: 'body feels different with it on vs. off during HOME phase? If not — raise HOME gain by 0.010'. | G7-0933 G7-0937 G7-0920 G4-0567 · 22-code-tests.md:485,524,528,643,650; 10-field-data-catalog.md:221 | **not-built** · OneBuildingTests one-bed law (to replace) | new tests |

81 elements placed.

---

## 3 · Parity ledger

The ledger is written to `waves/upgrade/ledger/sound.csv`. It has 176 rows, with columns `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by`. There is one row per element in §2. Each table is also expanded so every number can be checked one by one: the nine roots, the nine ring voicings, the nine bells, the twelve Vāk voices, the thirty-three room tones, the fifteen world voices and the eight wake-up arcs. Frames: F02 (Ring 8 triad), F19 (Ring 3 Smoke Lotus), F26 (Ring 7 twelve voices at 30°, with the lower-left sound toggle and Ring 2's invocation behind). Everything else is checked by measure-sound, measure-timing or unit-test against the numbers given, and on his walk on Neev.

---

## 4 · Data contract

**Airtable (read only; no new fields; ruling 11):**

| base · table | field (id) | used for |
|---|---|---|
| ASG · Mandala `tblrRwXJD0uP8HU8G` | Row Type = Shakti; kp; ring; Bīja / syllable; subtleBodyChakra `fld6deGFzModjBmoj`; colour; mudrā | her carrier (S11), songless dance (S45), Vāk names (S35) |
| ASG · Mandala | per-Śakti Score `fldz1vCCMpXiw8s1n` | songless Score overrides (S45, S62) |
| ASG · Bindu Field `tblv3WvMZ90Sfhun6` (base `app248ZTWhYJlvQj2`, view `viwFst2hAYxv3ifQZ`) | Score JSON `fldxIm6qUXLcdrRuR` · Score Status `fldOSMHwD7IxshwO7` · Audio URL `fldUIY8v9p49QyF0B` · Audio Data URL `fldUlWDvSkeHpx80x` · Carrier Hz `fld4oIQGckv2c9DvO` · Beat Hz `fld7oCYy1eIWdhE04` · Seed Phrase `fldyFZy2hzFXTM52K` · Phase Labels `fldQq0ONvyoD5NuhS` · Verb `fldrYExLmEjx4wxVt` · Track Type `flds07pkQlTwXLTWw` · Element `fldC5nZ1vH1nclfhe` · Frequency Reading `fldjQfTIklHtOa8a4` · Mirror Words · Inhale/Hold/Exhale Sec · Special Cue | Score player (S62), breath carriers (S20), family songs (S68) |
| ASG · The Map | Mirror Frequency `fldNkcMhpaeuVQC22` · Mirror Frequency Instruction `fld1lfG7r96PQGPxP` · Linked Builds `fldirMF5BPX0R2aHi` | body-room tones (S48), wake-up instrument (S54) |
| ASG · The Builds `tbl5PR84YTy4anzAD` | Type · Chakra · Song Title · Carrier Hz · Phase Arc Name · Voice · Stage | room ↔ dance song join (S56), awakening timbre names (S49) |
| App Activity `tblJlBeiHnqGpYrL7` | read: Chakra Practiced, Shakti Recognized, Light Entered | Maya's chord of every seed he carried (S52) |

**Baked into the bundle** (`Data/ChakraConstellation.json`, regenerated by the bake): for each of the 33 rooms, its fixed tone, timbre spec (HARM/ATK/DCY), wake-up beat arc, gate hold ms, dance song path and Score track id.

**Bundled assets** (ruling 12; `waves/register/audio-on-github.md`):

| use | path(s) |
|---|---|
| rooms 2–8, 30, 31 dances | tree-of-life/muladhara · svadhisthana · manipura · anahata · vishuddha · ajna · sahasrara · maya · aatma .mp3 |
| room 30 ending loop | tree-of-life/maya-chakra-ending.mp3 |
| room 9 (Shadow) | bindu/in_shadow.mp3 |
| room 18 Axis triptych (partial) | bindu/play.mp3 (Thunderclouds) · bindu/fade.mp3 (Fade Away) — Where'd You Go not on GitHub |
| Beneath | bindu/kingdom.mp3 |
| threshold / Gates of Release | bindu/cross.mp3 |
| room 2 second dance | bindu/before.mp3 |
| Relationship Field | bindu/purity.mp3 · bindu/levelup.mp3 · bindu/glow.mp3 · bindu/play.mp3 |
| the rest (Bindu dances for the Game and Modes worlds) | b/ ≡ bindu/ arise, bindu-dances-reach, dream, enough, fade, glow, howl, light, lose, melt, move, release, remember, rise, search, stay, still, wild; bindu/ ache, believe, crash, earn, ground, numb, trace |
| his bīja recordings (when made) | Audio/Bija/bija_001…102.m4a |

**Local stores:**
- `UserDefaults sound.*`: master on (default true; migrated from `lr_sound`), master volume 0.8, layer gains, binaural mode, haptics on, and per-world overrides.
- `Application Support/Scores/<trackId>.json` with its modified time.
- `Application Support/AudioCache/<path>`.

**App Activity written** (ledger `tblJlBeiHnqGpYrL7`, Source App "Mandala"):
- Ring Crossed, already written at each new depth. The bell is its sound.
- Chakra Practiced at a completed wake-up gate.
- Played when a game ends.
- Silence Held.
- **Danced**: a new type, born by typecast as other Wave 4 types were. It is written at a dance's fruit with Detail `song · verb · word` and Duration (sec), and Notes holds motion (still / swaying / moving). It is never counted back to him.

---

## 5 · Doors

Sound does not open doors of its own. It travels with every door:

- **The point (Home).** From any world, touching the point runs the crossing in §1.3. The departing carrier rides the seam into the Om.
- **The menu** (a constellation of world-points). Each point hums its threshold tone as the finger passes. The sound glyph lives here as well as in each world.
- **Her position (kp 1–102).** Her carrier follows her into every world:
  - Her Home (the full graph);
  - Her Presence (held carrier, glyph tap);
  - the Mandala card (glyph tap);
  - the Climb (her light's air);
  - the Rite (strikes);
  - Ring 7 (the Vāk voice of kp 87–98);
  - the Relationship Field (kp 31, 40, 42 meetings).
- **The chakra (1–33).** The room's fixed tone follows into its practice, gate, wake-up and the Map card. The dance strand opens the song.
  - The 2.69 thread (Beneath) walks five rooms' dances in order.
  - The Mantra Tuner (Game) asks for the room tone's pulse.
- **The day.** The morning bell (272.2) opens the practice day. The evening bell (136.1) closes it. Time's day voice is 194.18, the year view 136.1, the night 60 Hz / 1.5 Hz.
- **Gestures.** Every held gesture has its answering sound and haptic. Inward is the bell; outward is silent.
- **Back to where you were.** The SoundScene of the world you return to is restored with its gains, and the song resumes at its paused position only if you return within the same visit.
- **Search.** Results for a tone (e.g. "174", "Om", "bell") open the S·T·C badge and the world where it sounds.

---

## 6 · To Bindu Feed

Story material from this slice. It is flagged, not used in the Mandala.

| item | source | why story |
|---|---|---|
| C-1180, Ram Dass "A Miracle": re-feeling the 26 Jun 2024 argument, release in waves | G3-0405 · 07-codex.md:430-433 | a personal narrative of one evening. The mechanism (a song as a door, releasing in waves) already lives in the dance strand. |
| The Turning: 10 story beats (3b "The third planet. The third world. The third time. Trinity."; beat 7 personal address) with a held Om | G5-0597 · 14-aistrangegame.md:414-417 | a told story. Only the held Om at 136.1 (S16) is kept here. |
| levelup's karmic narrative (the monk and a Chief, the Ash-Rey name reading) | G4-0222 · 08-dances.md:986-989 | story and private. Here only the song, its carrier and its 2.69 "between" are kept. |
| purity's personal reading of Shweta | G4-0223 · purity.md | private. Only the song, carrier and seam are kept. |
| the dance fruits' narrative lines ("The iron in your blood is the same iron in the stars…", "You were never chasing anything. It was chasing you.") | G3-0218 … G3-0227 | they stay as verbatim fruit inside the Score (Design's lines count as authored). The longer song readings (seven lenses, Lalita's Perspective) are "sacred data — never on the page" and belong to Bindu Feed / the Field. |
| C-1347: listening as witness, reading backward to the need | G3-0513 · 07:970-973 | a method for scoring (kept with the offline tools, S63), not a moment in the app. |

---

## 7 · Conflicts settled and open

**Settled from the evidence and the rulings:**

1. **One bed at a time vs layering.**
   - Evidence: C-1350 was a Bindu Field playback-collision report (07:1322, 1370). Ruling 10 lifts the restriction. The Field's own Scores already layer song, binaural and pink noise.
   - Ruling: the conductor sums buses, and only SONG sources are exclusive (S01, S02).
2. **Two tunings for one ring** (HomeCarrier roots vs RingAudioService/RingFieldVoice roots, C-11).
   - Ruling: Design's roots everywhere (settled 12 Oct). RingFieldVoice reads HomeSoundService's voicings (S10, S28).
3. **Ring bells: 8 vs 9, and descending vs the ascending roots** (C39; G1-0479 "inverted").
   - Ruling: nine bells, bell(r) = root(10 − r) × 4.
   - Evidence it is the least-invented reconciliation: it is derived from Design's own root table; it keeps Design's descending-inward meaning, Design's bell envelope and partials, and five of Design's eight pitches exactly (392, 329.6, 293.7, 246.9, 220). It fits the one tuning, and it gives the ninth enclosure its bell (220).
4. **Bīja tap pitch from a hash** (lrPlayBija, BijaSoundService FNV).
   - The pitch was invented, so it is retired. The tap sounds her carrier (Design's carrier law). Design's envelope is kept (S13).
5. **RITE_BIJA_HZ** (Aim 136.1, Klīm 144 …).
   - These are frequencies with no derivation, and they clash with the roots. The Rite sounds today's Śakti's ring ground and carrier instead (S24).
6. **Beat 2 sounds the withheld fifth on every entry** (G1-0283).
   - Ruling: strikes are [1, 2, 4] until the fifth is granted, then Design's [1, 1.5, 2]. Design states the law in prose more strongly than the strike table shows.
7. **The Vāk Chamber: 8 vs 12, Design's names vs Airtable's, an invented scale 220–659.25** (C13).
   - Ruling: the Airtable twelve (kp 87–98) at 30°, on ring 7's root with the fifth withheld. The counter is dropped and the threshold of 7 is felt.
8. **Ring 8 minor triad (ring worlds) vs 1 : 1.26 : 1.5 (homes).**
   - Ruling: the homes voicing on R8 × 2 (tested in HomeSoundTests), uniting at 110.
9. **Awakening tones keyed to rings** (PlayPhysics AwakeningTones) **and ASG gift #23** (ring crossings sound the panel tones; C9).
   - Rejected for rings: the panels belong to tree chakras, not āvaraṇas, and mapping them would be invented. Ring crossings sound the bells.
   - The awakening tones are the 33 rooms' fixed tones, re-keyed by room (S48).
10. **Four or five frequency systems per room** (awakening, VX2 256/288, solfeggio, panel carriers 128/144/160…, song carriers).
    - Ruling: each room keeps one fixed tone (the awakening tone).
    - The wake-up binaural carrier is that tone ÷ 2, with the authored beat arcs.
    - The song's carrier plays only in the dance.
    - VX2 and solfeggio are retired (S48, S50, S15).
11. **Body and mind rooms with no tone** (G2-0929).
    - Body rooms take their Map Mirror Frequency (the field is filled for 10–19).
    - Mind rooms take 110 Hz (BC-09 "the rooms about the reader").
    - Armin keeps its authored D2 drone. Both are derived, not invented.
12. **Sound default off (Design chimes) vs on (code).**
    - Ruling: on. BC-09 governs ("sound is everywhere … begins on first touch"), and his mute is one tap away.
    - `lr_sound` becomes `sound.master.on` and is read live.
13. **"No in-app volume, no sound toggle" (HomeVoice)** is lifted by ruling 10. The Sound sheet is added (S06).
14. **The Field's DSP re-derives the carrier at 10 s vs Score fixed:true.**
    - Ruling: fixed:true. *"The carrier doesn't move."* The override is not ported (S57).
15. **Pseudo-binaural (one sine panned by the gyroscope).**
    - Retired. The binaural is true L/R. The gyroscope only tilts the pan by 0.011 (S57).
16. **Drone endings vs "a song's drone plays only during its dance."**
    - Ruling: the carrier may ride the 3 s seam at 0.004 and then decays into the Om. It never stays on in the next world (S07).
17. **"Sound on gates only" / "the descent is silent"** (older briefs) are superseded by BC-09 and RD-11 ("sound the descent"). The Shepard fall sounds it (S38).
18. **The Mirror's counter, dance count lines, the "84 hearts" simulation, the Oracle's generated text.**
    - Dropped. Nothing counts him, and there is no generated voice or simulated presence.
19. **The 2.69 Hz claim.** It is placed only where designed (the deep zoom, authored Scores, the five-dance thread), and badged as a claim (S60).
20. **Seed syllables "never written" (RingBija test, the rupakarshini guard)** are superseded by "bījas may sit in the yantra". The falling syllable may surface (S27).
21. **Carrier mod-12 wrap** (G1-0279). Kept as Design wrote it: the interval is hers. The order of the alphabet is not a pitch order. It is not a defect.
22. **Aatma's carrier: 98.0 (batch) or 130.8 (authored).**
    - Ruling: 130.8 C3. The batch draft overwrote the authored value; the authored song file, its Recognition Statement and process-learnings S7 #84 all say "the absent ROOT of C major" (10-field-data-catalog.md:527-533).
    - The same rule (the authored song file over the batch draft) settles two more:
      - **Maya**: 155.6 D#3 (maya.md:203-210, L 155.6 / R 163.6, "in dialogue" with Anahata), not the batch's 116.5.
      - **Kingdom**: 146.8 D3 as the absent root (kingdom.md; learnings #47; its Recognition Statement "the home note"), not 110.
23. **Silent switch.** It is honoured (`.ambient`). While he has pressed play on a song, `.playback` is used, because that is his act (S03).

**Open, for Ashrey:**

1. **Which recording is Aatma's song?** `tree-of-life/aatma.mp3` has the same sha (eade0428) as `b/arise.mp3` (Joy). The Score and the Builds table say "Aatma — Chase Hughes".


---

## 8 · Coverage

Script check (`python3 -I` over `by-world/sound.jsonl`): slice ids 470 · unique 470 · placed 466 · merged 1 · to Bindu Feed 2 · rejected 1 · not this world 0 · **missing 0**

| id | title | disposition |
|---|---|---|
| G1-0014 | Existing shipped files that must not be rebuilt | placed §2 S01 |
| G1-0025 | Sound per ring — extend RingAudioService | placed §2 S28 |
| G1-0046 | Bīja → visual rhythm locked to syllable — not built | placed §2 S43 |
| G1-0077 | beginEnter: chamber at scale 0.02, STATION [0, .30, .62, .88, 1], struck tone | placed §2 S41 |
| G1-0093 | Sound wiring per frame: ground crossfade, carrier, room, withheld fifth | placed §2 S40 |
| G1-0132 | ARCH-R1-MATRKA (pos 11–18): ring of letters, one at a time comes to the point of being spoken | placed §2 S44 |
| G1-0139 | ARCH-R7 sounding (87–98): standing-wave wall with mode number n = 2 + (pos mod 8) | placed §2 S44 |
| G1-0276 | Sound philosophy: bīja carrier over āvaraṇa drone; fifth withheld | placed §2 S01 |
| G1-0277 | Ring roots (one tuning): 55.00 · 61.74 · 69.30 · 73.42 · 82.41 · 92.50 · 98.00 · 110.00 · 123.47 Hz | placed §2 S10 |
| G1-0278 | Carrier from her syllable: VARNA index, JUST ratios, ×2 octave | placed §2 S11 |
| G1-0279 | Carrier mod-12 wrap makes alphabet non-monotone; aṃ/aḥ unreachable | placed §2 S11 |
| G1-0280 | Ground technique per ring (nine drones, voicings exact) | placed §2 S28 |
| G1-0281 | Audio graph levels: master, lowpass 220 Hz, carrier, withheld fifth, air noise | placed §2 S41 |
| G1-0282 | Rite struck tone per beat: carrier × [1, 1.5, 2], decay 3.4 s | placed §2 S12 |
| G1-0283 | Beat-2 strike sounds the withheld fifth on every entry | placed §2 S12 |
| G1-0284 | grantsFifth: ninth world, a very long stay, or a long relationship | placed §2 S12 |
| G1-0285 | Which Śaktis have a syllable (42); 60 sound at bare root; ring bījas never used for pitch | placed §2 S11 |
| G1-0330 | Coverage audit: 8 brief items missing then built (hues, doors, clusters, library, Well letter, veil, tempo/verb/Form, per-ring sound) | placed §2 S28 |
| G1-0431 | Rite sound: gates only, opt-in; RITE_BIJA_HZ ring bīja frequencies; fifth opens with b | placed §2 S15 |
| G1-0478 | lrPlayBija — pentatonic hash tone (not gated by sound toggle) | placed §2 S13 |
| G1-0479 | lrRingChime — deeper rings ring lower ('falling inward descends in pitch') | placed §2 S26 |
| G1-0492 | Bīja glyph 84px — 'tap to sound her' with pulse and three rings | placed §2 S13 |
| G1-0511 | Mandala control column ♪ + − ⤢; ring chimes persist lr_sound default off | placed §2 S06 |
| G1-0512 | Ring-entry chimes: zoom-driven inward only, gold ring flash | placed §2 S26 |
| G1-0536 | RING2 bījas shift by one from pos 10 vs shakti-data; Bījakarṣiṇī spelling | placed §2 S11 |
| G1-0580 | Stretch: continuous ring drone; WidgetKit today's Śakti; descent as remembered film; exportable high-res Portrait; timed Silence dwell (.silence) | placed §2 S22 |
| G1-0594 | Sound map: four distinct voices (Rite room drone, bīja tap, ring chimes, Lalitā ॐ) — gating differs | placed §2 S13, S80 |
| G1-0617 | World Ring 7 — Vāk: 12 syllable nodes; centre chord; healed at ≥7 of 12 sounded | placed §2 S35 |
| G1-0648 | Codex Ring 7: the screen resonates — haptic on every breath, barely-audible bīja tone | placed §2 S36 |
| G1-0701 | ReturnGesture arc (swipe down to return home) and RingSoundToggle ('silent') | placed §2 S06 |
| G1-0702 | Ring-world audio engine: playBija (sine f + 2f), home voice C3 + fifth with 0.18 Hz breath, Ring 8 minor triad glides | placed §2 S37 |
| G1-0705 | RingSevenWorld — Vāk Sound Chamber: 12 nodes on r140, VAK_FREQS 220 → 659.25 Hz | placed §2 S35 |
| G1-0706 | Ring 7 mechanics: strikeOne 2400ms, chord staggered 55ms 3400ms, 'healed' at ≥7 of 12; '{n} of 12 voices sounded' | placed §2 S35 |
| G1-0716 | Ring-Worlds III header: 'Rings 3, 4, 5, 6 — each finding its own verb'; shared chrome and audio (w3Note, w3Sustain) | placed §2 S31 |
| G1-0723 | Shepard tone for Praveśa: 7 voices from 32.7 Hz gliding down forever | placed §2 S38 |
| G2-0042 | CB0-18 bīja sound files | placed §2 S14 |
| G2-0063 | HO1-21 deferred items | placed §2 S28 |
| G2-0067 | HO2-02 R1 Bhūpura Earth-City world | placed §2 S29 |
| G2-0068 | HO2-03 R3 Anaṅga Smoke Lotus world | placed §2 S31 |
| G2-0069 | HO2-04 R4 Sampradāya Lineage world | placed §2 S32 |
| G2-0070 | HO2-05 R5 Kulottīrṇa Overflow world | placed §2 S33 |
| G2-0071 | HO2-06 R6 Nigarbha Concealed world | placed §2 S34 |
| G2-0072 | HO2-07 R9 Praveśa fall (chosen) + Spanda alt | placed §2 S38 |
| G2-0073 | HO2-08 ring sound table | placed §2 S28 |
| G2-0076 | HO2-11 R2 Inhabited Lotus | placed §2 S30 |
| G2-0077 | HO2-12 Ring 7 Vāk Chamber 12 voices | placed §2 S35 |
| G2-0078 | HO2-13 Ring 8 Mūla Trikoṇa glide | placed §2 S37 |
| G2-0099 | FB-21 Phase 5 ring worlds (R2/R3/R7 Hz/R8) | placed §2 S35 |
| G2-0136 | RFB-06 Vāk Chamber 12 voices overlap | placed §2 S35 |
| G2-0151 | MBB-13 threshold ceremony (Gates of Release) | placed §2 S39 |
| G2-0153 | MBB-15 stretch: widget, film, export, drone, Silence | placed §2 S22 |
| G2-0180 | FH-12 Living Mandala semantic zoom + Bindu→Lalitā descent | placed §2 S25 |
| G2-0181 | FH-13 Field/Well/Portrait + audio engines | placed §2 S26 |
| G2-0186 | FH-19 reaching further (drone, widget, film) | placed §2 S22 |
| G2-0190 | R2R-04 prototype engines list | placed §2 S26 |
| G2-0216 | XMB-00 master-brief errata | placed §2 S11 |
| G2-0218 | XMB-02 descent four constants | placed §2 S38, S75 |
| G2-0221 | XMB-05 continuous sonic environment | placed §2 S01 |
| G2-0222 | XMB-06 Recognition deepened (linger ripple, richer bīja) | placed §2 S13 |
| G2-0229 | XMB-13 one taxonomy (element) four bodies; quieter deeper | placed §2 S04 |
| G2-0233 | EXP-26–38 Mandala ideas | placed §2 S22 |
| G2-0264 | CCH-18 Homes sound per ring + carrier | placed §2 S11 |
| G2-0276 | THR-08 bīja carrier derived not invented | placed §2 S11 |
| G2-0283 | THR-15 the Axis (climb) mechanics | placed §2 S40 |
| G2-0322 | AR-12 misc observed defects | placed §2 S06 |
| G2-0340 | BV2-P6 'dead stays dead' list (partly reopened) | placed §2 S28 |
| G2-0341 | BV2-7 Ashrey's alone: letters, marginalia, bīja recordings | placed §2 S14 |
| G2-0350 | ERR-09 carrier ruling: ring roots Hz | placed §2 S10 |
| G2-0360 | BC-08 every place moves as what it is | placed §2 S01 |
| G2-0361 | BC-09 sound everywhere; 136.1 Hz & 110 Hz | placed §2 S05 |
| G2-0364 | BC-12 her voice authored; Well his alone | placed §2 S14 |
| G2-0375 | WV-09 Wave 2 One building list | placed §2 S28 |
| G2-0385 | RD-08 gap cause 4: restraint drops | placed §2 S28 |
| G2-0387 | RD-11 first-principles table (lift caps, sound, doors) | placed §2 S01 |
| G2-0395 | F02 Ring 8 Mūla Trikoṇa three vertex states | placed §2 S37 |
| G2-0412 | F19 Ring 3 Smoke Lotus gathered | placed §2 S31 |
| G2-0419 | F26 Ring 7 Vāk chamber twelve voices at 30° | placed §2 S35 |
| G2-0447 | C13 Ring 7/8 composition | placed §2 S35 |
| G2-0453 | C19 sound policy | placed §2 S01 |
| G2-0472 | C38 carrier roots source | placed §2 S10 |
| G2-0473 | C39 bell/chime counts 8 vs 9 | placed §2 S26 |
| G2-0482 | SilenceEngine OM stack 68.05/136.1/272.2 Hz | placed §2 S16 |
| G2-0484 | Room 1 GATE: press and hold one breath | placed §2 S17 |
| G2-0501 | Where the Points Lead: Field / Wakeup / Dance | placed §2 S56 |
| G2-0512 | Where the Roots Lead (Wakeup/Dance Iron/Field Song 2) | placed §2 S56 |
| G2-0515 | Muladhara wake-up gate: hold 4000 ms, 174 Hz awakening | placed §2 S49 |
| G2-0521 | Muladhara binaural 128 Hz → 132 → 130 | placed §2 S50 |
| G2-0525 | Svadhisthana Three Ways In, seed, Where the Currents Lead | placed §2 S56 |
| G2-0529 | Svadhisthana wake-up gate 4000 ms, 210 Hz | placed §2 S49 |
| G2-0533 | Svadhisthana Release + binaural 144 Hz | placed §2 S50 |
| G2-0534 | Svadhisthana dance 'FEEL': start overlay typed seed 70 BPM | placed §2 S56 |
| G2-0535 | Dance song analysis arrays (Crystallize 258.8 s) | placed §2 S56 |
| G2-0536 | Dance config (PEAK_T, hue, binaural gyro) | placed §2 S56 |
| G2-0539 | Dance events: ripples, haptic waves, word at 151 s, 'I Love You' 156 s | placed §2 S56, S71 |
| G2-0543 | Room 30 Maya legacy Panel 9 gate + Om drone | placed §2 S51 |
| G2-0546 | Maya Phase 4–5 Fear Doorway + 'Who are you speaking to?' | placed §2 S51 |
| G2-0549 | Maya Phase 7 Infinite Loop (76 s, triad split) | placed §2 S37 |
| G2-0588 | Room 01 frequency practice: one point of contact | placed §2 S17 |
| G2-0597 | Room 02 Muladhara: wake-up bija + frequency practice | placed §2 S48 |
| G2-0605 | Room 03 Svadhisthana: wake-up bija + frequency practice | placed §2 S48 |
| G2-0613 | Room 04 Manipura: wake-up bija + frequency practice | placed §2 S48 |
| G2-0621 | Room 05 Anahata: wake-up bija + frequency practice | placed §2 S48 |
| G2-0629 | Room 06 Vishuddha: wake-up bija + frequency practice | placed §2 S48 |
| G2-0637 | Room 07 Ajna: wake-up bija + frequency practice | placed §2 S48 |
| G2-0645 | Room 08 Sahasrara: wake-up bija + frequency practice | placed §2 S48 |
| G2-0653 | Room 09 Shadow: wake-up bija + frequency practice | placed §2 S48 |
| G2-0657 | The Pulse: 60 bpm haptic begins at Shadow (58 Hz osc) | placed §2 S53 |
| G2-0662 | Room 10 Soles: wake-up bija + frequency practice | placed §2 S48 |
| G2-0670 | Room 11 Forge: wake-up bija + frequency practice | placed §2 S48 |
| G2-0678 | Room 12 Prana: wake-up bija + frequency practice | placed §2 S48 |
| G2-0686 | Room 13 Hands: wake-up bija + frequency practice | placed §2 S48 |
| G2-0694 | Room 14 Pulse: wake-up bija + frequency practice | placed §2 S48 |
| G2-0702 | Room 15 Sonar: wake-up bija + frequency practice | placed §2 S48 |
| G2-0710 | Room 16 Echo: wake-up bija + frequency practice | placed §2 S48 |
| G2-0718 | Room 17 Vision: wake-up bija + frequency practice | placed §2 S48 |
| G2-0726 | Room 18 Axis: wake-up bija + frequency practice | placed §2 S48 |
| G2-0734 | Room 19 Crow: wake-up bija + frequency practice | placed §2 S48 |
| G2-0742 | Room 20 Armin: wake-up bija + frequency practice | placed §2 S48 |
| G2-0750 | Room 21 Inception: wake-up bija + frequency practice | placed §2 S48 |
| G2-0758 | Room 22 Intention: wake-up bija + frequency practice | placed §2 S48 |
| G2-0766 | Room 23 Inspiration: wake-up bija + frequency practice | placed §2 S48 |
| G2-0774 | Room 24 Insight: wake-up bija + frequency practice | placed §2 S48 |
| G2-0782 | Room 25 Intuition: wake-up bija + frequency practice | placed §2 S48 |
| G2-0790 | Room 26 Invention: wake-up bija + frequency practice | placed §2 S48 |
| G2-0798 | Room 27 Incarnation: wake-up bija + frequency practice | placed §2 S48 |
| G2-0806 | Room 28 Innocence: wake-up bija + frequency practice | placed §2 S48 |
| G2-0814 | Room 29 Integration: wake-up bija + frequency practice | placed §2 S48 |
| G2-0823 | Room 30 Maya: wake-up bija + frequency practice | placed §2 S48, S52 |
| G2-0831 | Room 31 Aatma: wake-up bija + frequency practice | placed §2 S48 |
| G2-0842 | Room 33 Lalita: wake-up bija + frequency practice | placed §2 S48 |
| G2-0852 | B.1.11 WakeupMoment tone (Day 19 Muladhara 174 Hz) | placed §2 S49 |
| G2-0856 | B.1.15 ThePulse 58 Hz + glow arc | placed §2 S53 |
| G2-0864 | CHAKRAS_7 solfeggio vs canon awakening Hz | placed §2 S10 |
| G2-0869 | B.3.5 Mantra Tuner (bpm = freq/8) | placed §2 S72 |
| G2-0870 | B.3.6 The Drum (1000 ms ± 180) | placed §2 S72 |
| G2-0885 | B.4.1 Pulse (8 taps → BPM, heartbeat 68/52 Hz) | placed §2 S72 |
| G2-0891 | B.5.1 Hub SoundView + CeremonyView | placed §2 S15 |
| G2-0896 | B.5.4 Sanctuary (Mirror, Gates, Field views) | placed §2 S15 |
| G2-0899 | B.5.7 Child Games (Finger Garden, Colour Rivers, Rain, Echo, Box) | placed §2 S15 |
| G2-0912 | C.2 Shell Ground: weather by storyPos; pulse room 9→32 not wired | placed §2 S53 |
| G2-0918 | C.3 Bindu Experience Score (planned, not built) | placed §2 S16 |
| G2-0926 | C.4 engines in one line | placed §2 S16 |
| G2-0928 | Corpus missing assets (GAP list) | placed §2 S64 |
| G2-0929 | E Awakening Hz ladder only rooms 2–8, 30, 31 | placed §2 S48 |
| G3-0038 | Chakra 1 practice/sound/gate | placed §2 S48 |
| G3-0039 | Chakra 2 practice/sound/gate | placed §2 S48 |
| G3-0040 | Chakra 3 practice/sound/gate | placed §2 S48 |
| G3-0041 | Chakra 4 practice/sound/gate | placed §2 S48 |
| G3-0042 | Chakra 5 practice/sound/gate | placed §2 S48 |
| G3-0043 | Chakra 6 practice/sound/gate | placed §2 S48 |
| G3-0044 | Chakra 7 practice/sound/gate | placed §2 S48 |
| G3-0045 | Chakra 8 practice/sound/gate | placed §2 S48 |
| G3-0046 | Chakra 9 practice/gate (corridor) | placed §2 S48 |
| G3-0047 | Chakra 10 Soles gate | placed §2 S54 |
| G3-0055 | Chakra 18 Axis gate and Panel 10 | placed §2 S48 |
| G3-0057 | Chakra 20 Armin gate and drone | placed §2 S48, S55 |
| G3-0067 | Chakra 30 Maya practice/gate | placed §2 S48 |
| G3-0068 | Chakra 31 Aatma practice/gate | placed §2 S48 |
| G3-0082 | Atlas 02 Muladhara binaural arc | placed §2 S50 |
| G3-0088 | Atlas 03 Svadhisthana | placed §2 S56 |
| G3-0094 | Manipura build log (Powerful audio analysis) | placed §2 S56 |
| G3-0101 | Anahata build log (LMLYD) | placed §2 S56 |
| G3-0108 | Vishuddha build log (Sound of Silence) | placed §2 S56 |
| G3-0123 | BCA room 09 Shadow: 60 bpm haptic pulse rooms 9-32 | placed §2 S53 |
| G3-0190 | Body gate sound-response thresholds | placed §2 S54 |
| G3-0191 | TOL-T shared Tree-of-Life panel template | placed §2 S49 |
| G3-0192 | P1 Muladhara panel mechanics and sound | placed §2 S50 |
| G3-0193 | P2 Svadhisthana panel mechanics | placed §2 S50 |
| G3-0194 | P3 Manipura panel shake mechanics | placed §2 S50 |
| G3-0195 | P4 Anahata panel mechanics and checker | placed §2 S50 |
| G3-0196 | P5 Vishuddha panel mic mechanics | placed §2 S50 |
| G3-0197 | P6 Ajna panel stillness mechanics | placed §2 S50 |
| G3-0198 | P7 Sahasrara panel mechanics | placed §2 S50 |
| G3-0199 | P8 Aatma panel mechanics (triangle, Temple breaths) | placed §2 S50 |
| G3-0207 | P9 OM sound design and gain staging | placed §2 S51 |
| G3-0209 | P10 Axis Infinity Heart triptych (design only) | placed §2 S50 |
| G3-0210 | C-AWAKE awakening sounds (synth, 8 chakras) | placed §2 S49 |
| G3-0217 | D-SHELL VX dance shell | placed §2 S56 |
| G3-0218 | D-MUL Muladhara dance Iron | placed §2 S56 |
| G3-0219 | D-SVA Svadhisthana dance Crystallize | placed §2 S56 |
| G3-0220 | D-MAN Manipura dance Powerful (fuel exhaustion order) | placed §2 S56 |
| G3-0221 | D-ANA Anahata dance Love Me Like You Do | placed §2 S56 |
| G3-0222 | D-VIS Vishuddha dance Sound of Silence | placed §2 S56 |
| G3-0223 | D-AJN Ajna dance Experience (first-pass) | placed §2 S56 |
| G3-0224 | D-SAH Sahasrara dance Golden (first-pass) motion | placed §2 S56 |
| G3-0226 | D-AAT Aatma dance Chase (first-pass) | placed §2 S56 |
| G3-0227 | D-MAY Maya dance Love Is The Only Thing (first-pass) | placed §2 S56 |
| G3-0231 | L3 Device Performance: haptic grammars | placed §2 S71 |
| G3-0233 | MAP-VX2 master map (33 points, 5 acts) | placed §2 S15 |
| G3-0239 | G-ENGINE ASG Play Engine home and hold() | placed §2 S72 |
| G3-0240 | G-ENGINE sound palette and haptics | placed §2 S72 |
| G3-0242 | Leela engine version: full play script | placed §2 S72 |
| G3-0260 | BCA-PULSE unvoiced pulse 9-32 | placed §2 S53 |
| G3-0268 | M-HAPTIC haptic spec D19 | placed §2 S78 |
| G3-0291 | Two bells: morning receives the baton, evening passes it | placed §2 S24 |
| G3-0313 | Extraction data JSON (audio features) for Anahata and Manipura | placed §2 S56 |
| G3-0318 | Three (four) frequency systems collide | placed §2 S10 |
| G3-0319 | Dance 'binaural' is not binaural | placed §2 S57 |
| G3-0398 | C-1169 No chasing peaks, no replay desire; kirtan calms; naming reduces [KEY] | placed §2 S70 |
| G3-0405 | C-1180 Music as door; re-feel then release in waves | to Bindu Feed (§6); mechanism lives in S56 |
| G3-0426 | C-1222 ORIGIN: red dot, white light moving behind it, Sri Yantra tratak; japa Ram [KEY] | placed §2 S70 |
| G3-0481 | C-1297 Sound law: listen to the gaps; wordless; Bawara | placed §2 S42 |
| G3-0491 | C-1311 Body chakras: Axis blink, Euphoria Pulse, Echo, Roar [KEY] | placed §2 S54 |
| G3-0508 | C-1342 Echo/Sonar/Vishuddha breath vocabulary; 'missing basic' (AI-written) | placed §2 S57 |
| G3-0513 | C-1347 Listen as the witness; read backward to the need | placed §2 S63 |
| G3-0515 | C-1350 Playback: one source at a time, mini-player, binaural under songs (Bindu Field) [KEY] | placed §2 S02 |
| G3-0527 | C-1350 ask: a visible bottom menu, full player, mini-player, full screen | placed §2 S62 |
| G3-0529 | MISREAD FLAG C-1350: 'one source at a time' is his, but a playback rule; missing basic = inserted tone | placed §2 S02 |
| G4-0089 | VX 'spatial binaural' = single panned sine with tremolo (not true binaural) | placed §2 S57 |
| G4-0109 | frequency-pipeline.md extraction streams (librosa 22050 Hz, hop 512, 0.5 s) | placed §2 S63 |
| G4-0110 | extract.py / extract_cli.py differences and meta output | placed §2 S63 |
| G4-0113 | Audio sync and guard rules (build-patterns) | placed §2 S04, S62 |
| G4-0117 | Lesson #50: pre-baked data is intelligence, not scaffolding; real-time AnalyserNode 'mushy' | placed §2 S62 |
| G4-0164 | Binaural engine 'three archetypes holding the field' (Gaia×Sid carrier 110 Hz, Karishma inverse gain, moving beat) | placed §2 S57 |
| G4-0165 | OL-1 pink noise floor (7-coefficient, LP 4 kHz, gain 0.015) | placed §2 S58 |
| G4-0166 | OL-2 pre-roll resonance: carrier alone to 0.020, default on for first three dances | placed §2 S59 |
| G4-0167 | OL-3 Lalita voice: four lines (placeholder mp3s missing) | placed §2 S47, S79 |
| G4-0208 | Song archive file structure (metadata, analysis, seven lenses ×2, Lalita's Perspective, phased binaural, phase labels) | placed §2 S62 |
| G4-0209 | Room 2 Muladhara chakra song: Iron, Woodkid (verb press) | placed §2 S56 |
| G4-0210 | Room 3 Svadhisthana chakra song: Crystallize, Lindsey Stirling (verb follow) | placed §2 S56 |
| G4-0211 | Room 4 Manipura chakra song: Powerful, Major Lazer & Ellie Goulding ft. Tarrus Riley (verb build) | placed §2 S56 |
| G4-0212 | Room 5 Anahata chakra song: Love Me Like You Do (verb open) | placed §2 S56 |
| G4-0213 | Room 6 Vishuddha chakra song: The Sound of Silence, Disturbed (verb speak) | placed §2 S56 |
| G4-0214 | Room 7 Ajna chakra song: Experience, Ludovico Einaudi (verb still) | placed §2 S56 |
| G4-0215 | Room 8 Sahasrara chakra song: Golden, HUNTR/X (verb receive) | placed §2 S56 |
| G4-0216 | Room 9 Shadow / Meditate chakra song: In Shadow, Lubomir Arsov (film) (verb in shadow) | placed §2 S56 |
| G4-0217 | Room 30 Maya chakra song: Love Is the Only Thing, Lost Frequencies (verb dissolve) | placed §2 S56 |
| G4-0218 | Room 31 Aatma chakra song: Aatma, Chase Hughes (verb hold) | placed §2 S56 |
| G4-0219 | Kingdom (Arsov, Meditate, 13:55): absent root 146.8, 55 s non-fading drone, one word Sovereign | placed §2 S65 |
| G4-0220 | cross archive entry: element 'threshold', first non-chakra element | placed §2 S66 |
| G4-0221 | before (Genesis, Justice, Music #15): A2 110 Hz, no return phase, Lalita 'first 40 seconds' | placed §2 S67 |
| G4-0222 | levelup (Family · Rey, Levels + Beautiful Now, 7:32): B2 123.5, 12 phases, designed 2.69 Hz 'between' | placed §2 S60 |
| G4-0223 | purity (Family · Shweta, Where'd You Go + Thunderclouds, 8:30): Two Groundings, 4.9 s seam | placed §2 S68 |
| G4-0226 | Maya phase labels (verbatim) and binaural journey | placed §2 S56 |
| G4-0232 | Per-Śakti songless dance from her own sound (sustain mode, 5.5 s breath bloom, seven archetypes hear her) | placed §2 S45 |
| G4-0234 | Audio paths for dances (MusicKit / songless / own recordings) | placed §2 S64 |
| G4-0244 | Schumann 7.83 Hz and 2.69 Hz pass-through at dance apexes / Maya's dissolving phase | placed §2 S60, S61 |
| G4-0245 | Per-phase binaural journeys for 9 chakra rooms + Maya + Aatma (tables already written) | placed §2 S56 |
| G4-0268 | 'The verb is its own phase': carrier alone holds after the song (Aatma; the Well) | placed §2 S74 |
| G4-0269 | Carrier never fades to zero; dance end leaves carrier into the next world | placed §2 S07 |
| G4-0286 | Carrier/frequency sets disagree per room (archive vs dance HTML vs legacy wake-up vs canon awakening) | placed §2 S10 |
| G4-0290 | Absent-fifth 'law' not universal (Kingdom, Aatma, Maya use absent root) | placed §2 S10 |
| G4-0295 | Lifted restrictions already ignored by skills (one sound at a time, three controls) | placed §2 S01 |
| G4-0297 | Bindu Field app identity and catalog (com.bindufield.Bindu-Field; ASG app248ZTWhYJlvQj2 / tblv3WvMZ90Sfhun6 / viwFst2hAYxv3ifQZ) | placed §2 S62 |
| G4-0299 | Settled audio engines (BinauralEngine, BinauralListener, BinduDSP, AudioSessionCoordinator; background audio) — DO NOT MODIFY | placed §2 S57 |
| G4-0300 | DSPWireService 10 Hz polling, inverse RMS → engine gain, userBeatHz override, carrier derives from song at 10 s | placed §2 S42 |
| G4-0304 | Only Score in Bindu Field app is Score.cross (Track 27, 268 s); forTrack returns nil for 21 of 22 | placed §2 S62 |
| G4-0317 | Bindu Field principles (verbatim) | placed §2 S23, S57 |
| G4-0328 | Binaural contract: carrier derivation {absent_fifth, absent_root, present_root, imposed}, confidence {confirmed, review, unresolved}, designed flags, inverse gain, Karishma freeze, gyro_tilt_to_pan 0.011 | placed §2 S57 |
| G4-0333 | optional_layers: pink noise; pre-roll text 'Breathe with the silence. The song begins when you do.'; voice (OL-3) | placed §2 S59 |
| G4-0340 | Appendix B: Step 0 THE WORD, karishma_measure (silence \| groundlessness), subtractive designed events | placed §2 S62 |
| G4-0341 | Energy spine 9/9 complete (Muladhara press Iron … Maya dissolve Love Is the Only Thing); audio <chakra>.mp3 | placed §2 S56 |
| G4-0346 | Wake Me Up analysis: D major 0.882; carrier D3 146.8 absent root; 2.69 found twice; isochronic 1.3/1.7/1.9/2.8/3.1 Hz | placed §2 S64 |
| G4-0361 | Content-registry open questions (carrier law resolved; designed vs discovered 2.69; silence footprint; peak_t not reproducible; analyze_tone diagnostic) | placed §2 S62 |
| G4-0372 | cross binaural: carrier 110 A2 absent_fifth of D (detected G, confidence review); 12-step beat schedule; gain multipliers; Karishma freeze | placed §2 S57 |
| G4-0375 | cross haptics, voice triggers (unrecorded), field connection writes, constellation visibility | placed §2 S66, S78 |
| G4-0384 | abide binaural: 110 A2 absent fifth confirmed, presence 0.32, 13-step beat (7.83 inside fulcrum, 4.0 delta border at Recognition), no 2.69 | placed §2 S57 |
| G4-0394 | thunderclouds binaural: 123.5 B2 absent fifth of E, 'THE CARRIER IS THE RAIN'; beat schedule with null void; carrier_dropout 140.0-141.5 | placed §2 S57 |
| G4-0447 | Carrier vocabulary in use, beat placeholders, Bindu hues used | placed §2 S10 |
| G4-0461 | Absent-fifth carrier per room from the Scores (R2 146.8 · R3 146.8 · R4 164.8 · R5 155.6 · R6 138.6 · R7 138.6 · R8 146.8 · R9 146.8 · R30 116.5 · R31 98.0) | placed §2 S56 |
| G4-0462 | Beat schedules as state arcs for the Rite/Climb/Well (arrive 8 α → descend 6 θ → hold 4.5 → Recognition 4.0 → surface 7.5→10) | placed §2 S24 |
| G4-0463 | Inverse gain law: her room's tone swells in silence ('They share the field; they do not compete.') | placed §2 S42 |
| G4-0466 | Drone endings across crossings: worlds join by sound through the point | placed §2 S07 |
| G4-0482 | Voice triggers OL-3 in Her Home with recorded human voice only | placed §2 S47, S79 |
| G4-0489 | Two sound systems per room: canon Awakening tone (174/341/528 solfeggio) vs song absent-fifth carrier | placed §2 S10 |
| G4-0494 | Carrier corrections vs catalog (hold 136→98, speak 192→138.6, still 110→138.6, receive 240→146.8, dissolve 108→116.5, kingdom 136→110, inshadow 136→146.8) and DSP 10 s override vs fixed:true | placed §2 S10 |
| G4-0495 | Wake Me Up carrier conflict (song-registry D3 146.8 absent root vs wake.score A2 110 absent fifth) | placed §2 S57 |
| G4-0497 | Audio not hosted for many Scores; no -data.json hosted | placed §2 S64 |
| G4-0499 | Voice: Lalita files unrecorded; Oracle uses Claude Haiku (generated text) — check against floors | placed §2 S47, S79 |
| G4-0556 | analyze_tone.py: Krumhansl-Schmuckler key, absent-fifth candidate scoring (0.4·absence + 0.6·sweet), beat heuristic, default carrier 136.0 | placed §2 S63 |
| G4-0557 | temporal_analysis.py: bass-coverage verdict STRONG/MODERATE/SPARSE/ABSENT; STABLE vs MOVING carrier | placed §2 S63 |
| G4-0558 | deep_analysis.py: binaural-pair detection, stereo width per band, isochronic pulse detection | placed §2 S63 |
| G4-0560 | assemble.py…assemble5.py common skeleton (bindu-score/v2.0): GEN_ORDER, ENS_READS role→stream map, bloom, gain law, loop, return, optional layers, field_connection | placed §2 S62 |
| G4-0561 | Per-song carriers and flags verbatim from assemble scripts (search C#3 138.6 … inshadow D3 146.8) | placed §2 S57 |
| G4-0564 | BATCH-SCORING-STATE: 45 drafts + 3 authored written to Score JSON (all Drafted); runs; not done; blocker 'iOS app does not consume Score JSON yet' | placed §2 S62 |
| G4-0565 | Deep-dive 10-step scoring protocol (carrier decision, stereo check, seven lenses, page language, Lalita, binaural by element, phase labels, embed, verify, see-and-feel) | placed §2 S63 |
| G4-0566 | Gain ranges: ARRIVAL 0.005-0.010, HOME 0.030-0.056, Meditate/Film HOME ≤0.040; '0.10 is too loud with headphones. 0.003-0.050 is the phased range.' | placed §2 S04 |
| G4-0567 | STEP 10 see-and-feel test: raise HOME gain by 0.010 if body doesn't feel difference on/off | placed §2 S81 |
| G4-0568 | Instrumental protocol: materials incl. 'What's Absent'; per-genre lens handles; energy-arc→archetype map; thinness test | placed §2 S63 |
| G4-0570 | next-horizons ground statement and can/cannot list | placed §2 S62 |
| G4-0572 | H2 subtle-body sound fields: koshas as concentric shells, nadis (ida/pingala = L/R, beat = sushumna), bija sessions | placed §2 S77 |
| G4-0576 | Engine architecture laws (S1): 'Static tone interferes.' 'Real-time bass tracking warbles.' 'Pre-computed carrier + real-time modulation is the architecture…' 'The carrier is the absent sub-harmonic.' 'The carrier doesn't move. Bindu point. Dimensionless. Still. Beat moves (brainwave story). Gain moves (presence).' | placed §2 S23, S57 |
| G4-0577 | Technical laws (S1): session IDs vs races, setValueAtTime before ramp, media source once, smoothstep phase interpolation, viz 15 fps / audio 60 fps | placed §2 S02 |
| G4-0578 | S2 per-element journeys: 'Each element's journey comes FROM its reading.' | placed §2 S56 |
| G4-0581 | Duet seam: 'The carrier holds through the seam at minimal gain (0.004) — not zero.'; 'The seam is a phase' (crossing beat 7.0, gain 0.006); duet = one card, one mp3, one verb | placed §2 S07 |
| G4-0582 | Film rule: 'The film leads. The binaural completes.' (max 0.036-0.040); In Shadow design inversion (delta 2.5 at awakening 540-725 s, shadow theta 3-3.5); drone ending 0.008; tremolo 0.12/0.11 | placed §2 S57 |
| G4-0584 | S6 rules: carrier disqualified if dominant peak; read track list first for verbs; Genesis no return phase | placed §2 S63 |
| G4-0586 | S7: per-element arcs verbatim (Light twice, Crown above and below, Soul descends twice, Maya single breath); 'The verb is its own phase (Aatma)'; Anahata and Maya share D#3 155.6 'in dialogue' | placed §2 S56 |
| G4-0587 | Element arc shapes as gain/beat envelopes per ring (ruling 4 elements) | placed §2 S76 |
| G4-0588 | 2.69 Hz 'the fingerprint awakening leaves' (S7) — now 8 appearances incl. Wake Me Up at A4 440.1 Hz; 'The 2.69 Hz void phase is valid binaural architecture.' (S8) | placed §2 S60 |
| G4-0590 | Isochronic table: Aatma 1.8 Hz @1.000, Experience 1.1 @.995 & 1.7 @.990, Maya 4.3 @.985, Golden 6.1 @.769, Sound of Silence 1.5 @.694; Wake Me Up 5 pulses | placed §2 S57 |
| G4-0610 | Planetary (Cousto) carrier set from the 'Akash library': 136.1 OM/Earth-year, 194.18 Earth-day, 221.23 Venus, 256 C, 80 Hz chest, 60 Hz deepest | placed §2 S20 |
| G4-0611 | Song facts from Frequency field (Experience isochronic; Golden F1 43 Hz & 6.1 Hz; Aatma A1 53.8/F1 43.1, carrier C3 130.8; Kingdom 6.7 Hz alpha pulse, 146.8 D3 absent root; purity 4.9 s silence; levelup B2 123.5) | placed §2 S57 |
| G4-0615 | Absent-fifth carrier per Śakti / per ring derived from ring's chakra carrier (no songs) — fixed L carrier, R carrier+beat | merged into G6-0871 (S11) — her carrier from her syllable is the carrier; no Hz stored per Śakti |
| G4-0616 | Beat schedule as phased arc JSON per rite/mode (e.g. Rite arrival alpha 8 @0.006, home theta 4 @0.040, close delta 2.5 at minimum hold) | placed §2 S24 |
| G4-0630 | Carrier disagreements prose vs number: before 136 vs 110; purity 136 vs 123.5; hold/Aatma 98 vs 130.8 (batch overwrote authored); Kingdom 110 vs 146.8; Ajna delta (prose) vs alpha 8.5 (state) | placed §2 S10 |
| G4-0631 | No generated voice vs Horizon voice questions (Monroe, bija); ol3 off | placed §2 S14 |
| G4-0633 | No Śakti-level sound exists anywhere; resonance_link.shaktis empty in all 46 Scores | placed §2 S11 |
| G4-0634 | Audio hosting/copyright gate: 11 Run-4 tracks, cross, return unhosted | placed §2 S64 |
| G4-0878 | A5 S·T·C honesty badge legend undefined here; app's Hz-carrying awakenings (174/210/320/341/384/426/480/528) lack it | placed §2 S21 |
| G5-0007 | Ashrey's own frameworks in the learning register | placed §2 S20 |
| G5-0057 | The ladder and the reveal chord | placed §2 S40 |
| G5-0065 | A ring drawn by hand, settling true | placed §2 S46 |
| G5-0066 | One breath conducts everything (the Light) | placed §2 S24 |
| G5-0074 | Sounds that answer the hand | placed §2 S73 |
| G5-0075 | Two roots of sound: 136.1 Hz and 110 Hz | placed §2 S10 |
| G5-0124 | Haptic family (token family: Haptics) | placed §2 S78 |
| G5-0135 | The chime ladder (Pythagorean on 256) | placed §2 S15 |
| G5-0137 | The sound door (taps ignored 200 ms) | placed §2 S05 |
| G5-0148 | Honesty badges S·T·C | placed §2 S21 |
| G5-0171 | A bell lower at each step inward, silent outward | placed §2 S26 |
| G5-0190 | Mantra tuner | placed §2 S72 |
| G5-0213 | Silence learning to sound (drone under a still finger) | placed §2 S17 |
| G5-0221 | A tone ceremony up the spine (ladder of centres) | placed §2 S15 |
| G5-0223 | The Mirror's held tone | placed §2 S74 |
| G5-0240 | Sounds tied to the hand (game pieces) | placed §2 S72 |
| G5-0325 | Seed syllables and Devanāgarī: site restriction vs app floor | placed §2 S27 |
| G5-0412 | Each voice its own timbre | placed §2 S73 |
| G5-0413 | The bowl and the ink tone | placed §2 S24 |
| G5-0414 | The waveform you are hearing | placed §2 S19 |
| G5-0415 | The beat offered alone | placed §2 S19 |
| G5-0416 | The Shepard fall | placed §2 S38 |
| G5-0417 | One technique per level of sound | placed §2 S10 |
| G5-0435 | Music in three bands | placed §2 S62 |
| G5-0466 | Destination threshold tones (one pitch per place) | placed §2 S09 |
| G5-0595 | Two tones converging to Om (132 + 140 → 136.1 Hz) | placed §2 S18, S69 |
| G5-0597 | The Turning (Story beats, held Om) | to Bindu Feed (§6); held Om kept in S16 |
| G5-0610 | Sounds stop when you leave (2 s ramp) | placed §2 S07 |
| G5-0636 | WORLD_ESSENCE: per-world colour and voice table | placed §2 S22 |
| G5-0637 | Per-world ambient voice with 2.6 s crossfades | placed §2 S22 |
| G5-0638 | One breath for image and sound: 0.08 Hz world breath | placed §2 S08 |
| G5-0690 | Om pattern: always playing; the crescendo is noise decreasing | placed §2 S05 |
| G5-0736 | Topic: Frequency Understanding Atlas — Bindu Field (L-1535) | placed §2 S20 |
| G5-1102 | Topic: The Schumann Resonance | placed §2 S21 |
| G5-1122 | Topic: Solfeggio Frequencies | placed §2 S21 |
| G5-1157 | Topic: 432 Hz vs 440 Hz - The Frequency Question | placed §2 S21 |
| G6-0376 | Map · Linked Builds · 1 Bindu | placed §2 S56 |
| G6-0377 | Map · Linked Builds · 2 Muladhara | placed §2 S56 |
| G6-0378 | Map · Linked Builds · 3 Svadhisthana | placed §2 S56 |
| G6-0379 | Map · Linked Builds · 4 Manipura | placed §2 S56 |
| G6-0380 | Map · Linked Builds · 5 Anahata | placed §2 S56 |
| G6-0381 | Map · Linked Builds · 6 Vishuddha | placed §2 S56 |
| G6-0382 | Map · Linked Builds · 7 Ajna | placed §2 S56 |
| G6-0383 | Map · Linked Builds · 8 Sahasrara | placed §2 S56 |
| G6-0384 | Map · Linked Builds · 9 Shadow | placed §2 S56 |
| G6-0385 | Map · Linked Builds · 10 Soles | placed §2 S56 |
| G6-0386 | Map · Linked Builds · 11 Forge | placed §2 S56 |
| G6-0387 | Map · Linked Builds · 12 Prana | placed §2 S56 |
| G6-0388 | Map · Linked Builds · 13 Hands | placed §2 S56 |
| G6-0389 | Map · Linked Builds · 14 Pulse | placed §2 S56 |
| G6-0390 | Map · Linked Builds · 15 Sonar | placed §2 S56 |
| G6-0391 | Map · Linked Builds · 16 Echo | placed §2 S56 |
| G6-0392 | Map · Linked Builds · 17 Vision | placed §2 S56 |
| G6-0393 | Map · Linked Builds · 18 Axis | placed §2 S56 |
| G6-0394 | Map · Linked Builds · 19 Crow | placed §2 S56 |
| G6-0395 | Map · Linked Builds · 20 Armin | placed §2 S56 |
| G6-0396 | Map · Linked Builds · 21 Inception | placed §2 S56 |
| G6-0397 | Map · Linked Builds · 22 Intention | placed §2 S56 |
| G6-0398 | Map · Linked Builds · 23 Inspiration | placed §2 S56 |
| G6-0399 | Map · Linked Builds · 24 Insight | placed §2 S56 |
| G6-0400 | Map · Linked Builds · 25 Intuition | placed §2 S56 |
| G6-0401 | Map · Linked Builds · 26 Invention | placed §2 S56 |
| G6-0402 | Map · Linked Builds · 27 Incarnation | placed §2 S56 |
| G6-0403 | Map · Linked Builds · 28 Innocence | placed §2 S56 |
| G6-0404 | Map · Linked Builds · 29 Integration | placed §2 S56 |
| G6-0405 | Map · Linked Builds · 30 Maya | placed §2 S56 |
| G6-0406 | Map · Linked Builds · 31 Aatma | placed §2 S56 |
| G6-0407 | Map · Linked Builds · 32 Ego Reveal | placed §2 S56 |
| G6-0408 | Map · Linked Builds · 33 Lalita | placed §2 S56 |
| G6-0492 | Map · Mirror Frequency filled on 10 body rooms | placed §2 S48 |
| G6-0529 | Tree of Life panel P1 PRESS | placed §2 S56 |
| G6-0530 | Tree of Life panel P2 FOLLOW | placed §2 S56 |
| G6-0531 | Tree of Life panel P3 BUILD | placed §2 S56 |
| G6-0532 | Tree of Life panel P4 OPEN | placed §2 S56 |
| G6-0533 | Tree of Life panel P5 SPEAK | placed §2 S56 |
| G6-0534 | Tree of Life panel P6 STILL | placed §2 S56 |
| G6-0535 | Tree of Life panel P7 RECEIVE | placed §2 S56 |
| G6-0536 | Tree of Life panel P8 HOLD | placed §2 S56 |
| G6-0537 | Tree of Life panel P9 DISSOLVE | placed §2 S56 |
| G6-0538 | Tree of Life panel P10 ACCESS ('Axis Triptych') | placed §2 S56 |
| G6-0539 | Linked Builds patterns | placed §2 S48 |
| G6-0564 | Map gift #7 · Mirror Frequency as the wake-up instrument per body room | placed §2 S48 |
| G6-0571 | Map gift #15 · Maya's transparency, as sound and glass | placed §2 S52 |
| G6-0605 | Map gift #31 · Awakening tones and songs per room | placed §2 S48 |
| G6-0645 | ASG table · The Builds | placed §2 S62 |
| G6-0647 | ASG table · Bindu Field | placed §2 S62 |
| G6-0687 | Awakening Sound P1 Press | placed §2 S56 |
| G6-0688 | Awakening Sound P2 Follow | placed §2 S56 |
| G6-0689 | Awakening Sound P3 Build | placed §2 S56 |
| G6-0690 | Awakening Sound P4 Open | placed §2 S56 |
| G6-0691 | Awakening Sound P5 Speak | placed §2 S56 |
| G6-0692 | Awakening Sound P6 Still | placed §2 S56 |
| G6-0693 | Awakening Sound P7 Receive | placed §2 S56 |
| G6-0694 | Awakening Sound P8 Hold | placed §2 S56 |
| G6-0695 | Awakening Sound P9 Dissolve | placed §2 S56 |
| G6-0696 | Builds · Muladhara Iron carrier and Panel 10 | placed §2 S56 |
| G6-0697 | Builds · Bindu Dances (Live + Planned) | placed §2 S56 |
| G6-0698 | Builds · Bindu Songs (chakra, family) and Axis Songs | placed §2 S56 |
| G6-0747 | ASG gift #23 · Nine Awakening Sounds as ring tones | rejected — ruling: one tuning + C9 (panel tones belong to the 33 rooms, not āvaraṇas); ring crossings sound S26 |
| G6-0748 | ASG gift #24 · Dances already built per chakra | placed §2 S56 |
| G6-0749 | ASG gift #25 · Family songs | placed §2 S68 |
| G6-0764 | ASG gift #40 · The Bell, Three Breaths | placed §2 S24 |
| G6-0767 | ASG gift #43 · Mirror Words (Bindu Field) | placed §2 S56 |
| G6-0774 | ASG C8 · Builds' Chakra links point to The Map only | placed §2 S48 |
| G6-0775 | ASG C9 · Awakening Sound → ring mapping undefined | placed §2 S48 |
| G6-0813 | Code core · SoundConductor.swift (271) · one conductor | placed §2 S01 |
| G6-0814 | Code core · RingAudioService.swift (838) · the field's voices | placed §2 S28 |
| G6-0815 | Code core · RingFieldVoice.swift (306) | placed §2 S28 |
| G6-0816 | Code core · HomeSoundService.swift (1177) · her carrier | placed §2 S11, S41 |
| G6-0817 | Code core · HomeVoice.swift (278) | placed §2 S06, S41 |
| G6-0818 | Code core · HeartRegister.swift (275) · kīrtan / bhajan register | placed §2 S70 |
| G6-0819 | Code core · BijaSoundService.swift (318) · bīja tones and bells | placed §2 S13 |
| G6-0820 | Code core · GlissandoVoice.swift (94) | placed §2 S41 |
| G6-0821 | Code core · RingBija.swift (141) · the fall speaks the mantra | placed §2 S27 |
| G6-0869 | Code gift #1 · SoundConductor + five engines as a mixer | placed §2 S01 |
| G6-0870 | Code gift #2 · The Om at 136.1 Hz as the floor of every world | placed §2 S16 |
| G6-0871 | Code gift #3 · Per-Śakti carrier from the varṇamālā | placed §2 S11 |
| G6-0872 | Code gift #4 · Nine ring voices with distinct techniques | placed §2 S10 |
| G6-0873 | Code gift #5 · Kīrtan / bhajan heart register with call-and-response | placed §2 S70 |
| G6-0874 | Code gift #6 · The two bells (singing bowl) | placed §2 S24 |
| G6-0875 | Code gift #7 · Vāk 12-voice chord + Ring 8 triad unite + Shepard fall-through | placed §2 S35 |
| G6-0876 | Code gift #8 · The descent mantra (RingBija) | placed §2 S27 |
| G6-0920 | Code missing · Per-world sound scenes | placed §2 S01 |
| G6-0927 | Code C-5b · playBija hash tone labelled as her bīja | placed §2 S13 |
| G6-0928 | Code C-6a · Restriction still enforced: one sound at a time | placed §2 S01 |
| G6-0937 | Code C-10b · bija_%02d voice files absent | placed §2 S14 |
| G6-0939 | Code C-11 · Two tunings for one ring | placed §2 S10 |
| G6-0943 | Code C-12d · SoundConductor applies C-1350 to the Mandala | placed §2 S01 |
| G6-0947 | Code C-16 · Mixed audio-session policies | placed §2 S03 |
| G6-1032 | Homes parity · Withheld fifth / per-ring sound / carrier from syllable | placed §2 S12 |
| G6-1071 | Homes upgrade C10 · Sound per room: verify the withheld fifth | placed §2 S12 |
| G7-0015 | Mandala sound default on vs Design off | placed §2 S06 |
| G7-0024 | Inward crossings register flash, bija, ledger | placed §2 S25 |
| G7-0098 | MandalaFieldVoice ring sounds | placed §2 S25 |
| G7-0132 | The Bells | placed §2 S24 |
| G7-0144 | Chakra room soundOn read once | placed §2 S06 |
| G7-0195 | Ring worlds: per-world sound toggle and return arc | placed §2 S06 |
| G7-0198 | Ring-entry chime per ring | placed §2 S26 |
| G7-0213 | Move off the Mandala: Ring-world sound (ring 7 chord, ring 8 unite) | placed §2 S25 |
| G7-0230 | The point's pitch 136.1 Hz | placed §2 S16 |
| G7-0280 | Entering a game from the field | placed §2 S72 |
| G7-0293 | PlaySound engine | placed §2 S03, S72 |
| G7-0294 | One sound claim at a time in play | placed §2 S01 |
| G7-0317 | Rite strike pitch from HomeCarrier | placed §2 S12 |
| G7-0337 | Activation cycle recession and close | placed §2 S13 |
| G7-0347 | Climb rail, summit, body chakras, sound | placed §2 S40 |
| G7-0358 | Chakra room entry tone | placed §2 S48 |
| G7-0359 | Chakra wake-up bija button | placed §2 S13 |
| G7-0421 | Designed piece: SilenceEngine | placed §2 S16 |
| G7-0437 | Gift: SilenceEngine | placed §2 S16 |
| G7-0439 | Gift: Typed gate: Sound Response | placed §2 S54 |
| G7-0444 | Gift: Awakening ladder and panel wake-ups | placed §2 S49 |
| G7-0446 | Gift: Dance strand | placed §2 S56 |
| G7-0481 | Awakening tones keyed to rings, not rooms | placed §2 S48 |
| G7-0485 | Three frequency systems | placed §2 S10 |
| G7-0490 | No mic input anywhere in Play/Rooms/Chakra | placed §2 S54 |
| G7-0505 | Sadhana sound default true vs off | placed §2 S06 |
| G7-0510 | Sadhana recitation mostly silent | placed §2 S13 |
| G7-0540 | Heart Register ring 2 only | placed §2 S70 |
| G7-0683 | MandalaLightTests | placed §2 S27 |
| G7-0695 | HomeSoundTests | placed §2 S11 |
| G7-0696 | HomeVoiceTests | placed §2 S41 |
| G7-0920 | Missing floor test: No generated voice | placed §2 S81 |
| G7-0933 | New test: Sound mixing law | placed §2 S81 |
| G7-0937 | New test: No generated voice; Airtable read allow-list | placed §2 S81 |
| G7-0967 | Test gift: RingFieldVoice every place has a voice | placed §2 S28 |
| G7-0968 | Test gift: The full sound table | placed §2 S11 |
| G7-0969 | Test gift: Om 136.1 floor and the Bells | placed §2 S16 |
| G7-0970 | Test gift: Falling mantra RingBija | placed §2 S27 |
| G7-0971 | Test gift: Awakening tones | placed §2 S48 |
