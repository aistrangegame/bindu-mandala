# 10 · The Bindu Field instrument — data, scripts, protocols and the Airtable catalog

Reader 10 · second reading · 12 Oct 2026
Lens: what of the Bindu Field instrument (binaural engine, carriers, the absent fifth, field readings, the Consciousness Loop, Map/Oracle/Lab/Loop, the song catalog) can become part of Bindu Mandala's upgrade: sound per Śakti and ring, readings, the Modes, Time and performances.

Skill root (abbreviated `BF/`): `/root/.claude/skills/synced/12004d20-…_16bbdd03-…/bindu-field/`
Airtable: base `app248ZTWhYJlvQj2`, table `tblv3WvMZ90Sfhun6` ("Bindu Field"), 60 records, read-only.

---

## A · Inventory

### A1 · `scores/*-data.json`: 49 audio-feature files (read structurally with `python3 -I`)

**Schema (48 of 49 files, uniform).** Top-level keys: `meta, H, E, B, P, T, EB, EM, EH, ED, DROPS`.
- Frame interval `meta.interval = 0.5` s in every file. All eight streams share one length per file, `n = ceil(DUR/0.5)`.
- `E` = overall energy (RMS), normalised 0..1 (peak frame = 1.0).
- `B` = brightness / spectral-centroid stream, 0..1.
- `P` = a per-frame pitch/presence stream. **In 46 of the fresh files it is constant 1.0.** It is a dead stream, except in brave (0..1, mean 0.961), wild (0..1, mean 0.992) and the archival abide (0..1, mean 0.103). Do not build on P.
- `T` = signed transient/onset-strength derivative, −1..~0.6–1.0, mean ≈ 0.
- `EB / EM / EH` = band energies (bass / mid / high), each 0..1.
- `ED` = energy derivative, signed −1..1, mean ≈ 0.
- `H` = hit list `[{t, i}]`: onset times (s) with intensity ≥ `meta.hit_threshold`. The cap is around 400 hits; threshold range 0.18–0.50.
- `DROPS` = `[{t, i}]`: detected drops (sudden energy rises).
- `meta` (20 keys): `song, artist, verb, DUR, BPM, dominant_note, peak_t, peak_e, band_bass_pct, band_mid_pct, band_high_pct, quiet_regions_strict [{start,end,dur}] (E<0.1, ≥1 s), quiet_regions_loose (E<0.2, ≥1.5 s), drop_count, hit_count, hit_threshold, top8_impacts [{t,i}], opening_e, closing_e, interval`.

**Exception: `abide-data.json`** (the archival "Time" extraction, converted from `time-audio-data.js`). It has no `meta`. Instead it carries `DUR 211.3, BPM 129.2, H[525], E/B/P/T/EB/EM/EH/ED[423], DROPS[1] {t,intensity}` plus **four AUTHORED anchors that extract.py never produces**:
- `PEAK_T = 170.0`
- `KARISHMA_WINDOWS` (14): [0–28.5], [29–30.5], [33–34.5], [36.5–38], [39–40.5], [41–42], [43.5–45.5], [48–49.5], [58.5–60.5], [122–143], [153–154], [156.5–158], [189–196], [196.5–211.3]
- `PHASES`: Opening 0–158 (avg E 0.231); Build I 158–211.3 (avg E 0.362)
- `MIRROR_TIMES`: (4.0, tension 0.503), (26.5, 0.536), (191.5, 1.0), (199.0, 0.666)
- `_note` verbatim: "Converted from time-audio-data.js (the archived extraction). Includes the four AUTHORED anchors — PEAK_T, KARISHMA_WINDOWS, PHASES, MIRROR_TIMES — which extract.py does not produce. See abide.score.json anchors.extraction_instability: a fresh run returns peak 184.5s, not 170.0."
- `abide-data-fresh.json` is the fresh run: peak 184.5, 7 drops, 399 hits.

**Duplicates.** `still-ajna-data.json` is byte-identical to `ember-data.json` (md5 d8895b4a). Both hold Experience/Einaudi with verb "still", so **the "ember" data file does not contain Sit Around The Fire**. `play-data.json` and `thunderclouds-data.json` hold the same song with identical streams; only the verb differs ("play" vs "tbd").

**Empty identity.** 12 files have `song=''` `artist=''` `verb=''`: ascend, brave, cherish, confront, crave, inshadow, journey, kingdom, lift, miss, unfold, wake. Their identity lives only in the assemble scripts and in Airtable.

**Per-file values** (DUR s · BPM · dominant note · peak_t · bass/mid/high % · drops · hits@thr · frames · loose quiet windows):

| file | song — artist | DUR | BPM | note | peak | b/m/h | drops | hits@thr | n | quiet-loose |
|---|---|---|---|---|---|---|---|---|---|---|
| abide-fresh | Time (Alan Walker Remix) — Zimmer/Walker | 211.26 | 129.2 | G | 184.5 | 38/41/21 | 7 | 399@.39 | 424 | 5 |
| ache | Zara Zara Bahekta Hai — RHTDM | 167.28 | 129.2 | B | 37.5 | 32/54/14 | 3 | 347@.18 | 336 | 2 |
| ascend | (An Ending/Eno) | 261.31 | 136.0 | D# | 227.0 | 30/36/34 | 0 | 390@.46 | 524 | 3 |
| believe | Don't Stop Believin' — Journey | 250.94 | 117.5 | B | 123.0 | 22/42/36 | 0 | 399@.49 | 503 | 3 |
| brave | (Heroes/Alesso) | 294.13 | 129.2 | A | 78.0 | 30/37/33 | 7 | 411@.5 | 590 | 9 |
| build | Powerful — Major Lazer & Ellie Goulding | 206.33 | 99.4 | E | 33.5 | 27/45/28 | 5 | 400@.35 | 414 | 4 |
| cherish | (Maan Meri Jaan/King) | 184.98 | 129.2 | F# | 51.5 | 34/38/29 | 1 | 389@.47 | 371 | 0 |
| confront | (m.A.A.d City) | 143.64 | 152.0 | C | 115.5 | 44/34/22 | 10 | 403@.5 | 289 | 2 |
| crash | Thunder — Yellow Claw | 212.93 | 152.0 | A | 91.5 | 35/35/31 | 5 | 478@.5 | 427 | 0 |
| crave | (Crave You) | 236.94 | 69.8 | F# | 219.5 | 32/39/29 | 4 | 492@.5 | 475 | 6 |
| cross | Ameno (Scott Rill Remix) — ERA | 230.09 | 107.7 | G | 138.0 | 24/44/31 | 4 | 387@.35 | 462 | 13 |
| dissolve | Love Is the Only Thing — Lost Frequencies | 184.25 | 129.2 | G | 53.5 | 32/41/27 | 9 | 404@.5 | 370 | 6 |
| dream | Dream — Alan Watts/Superposition | 331.46 | 143.6 | D# | 305.5 | 47/40/14 | 7 | 520@.5 | 664 | 11 |
| ember (=still-ajna) | Experience — Einaudi | 315.56 | 92.3 | C# | 256.5 | 32/40/28 | 10 | 399@.32 | 633 | 6 |
| enough | Ordinary — Alex Warren | 187.06 | 112.3 | E | 170.0 | 34/40/25 | 4 | 395@.36 | 376 | 4 |
| fade | Fade Away — Ash & Paradise | 248.04 | 129.2 | F# | 171.5 | 26/45/29 | 1 | 561@.5 | 498 | 2 |
| follow | Crystallize — Lindsey Stirling | 258.82 | 69.8 | G | 39.5 | 34/41/25 | 9 | 392@.47 | 519 | 3 |
| glow | Beautiful Now — Zedd | 252.59 | 129.2 | B | 108.5 | 24/36/40 | 3 | 387@.4 | 507 | 2 |
| ground | Earth — Mogli | 204.04 | 136.0 | F | 180.5 | 28/50/22 | 5 | 397@.2 | 410 | 9 |
| hold | Aatma — Chase Hughes | 282.35 | 123.0 | G | 170.5 | 45/34/21 | 1 | 421@.5 | 566 | 19 |
| howl | Howling — RY X | 309.57 | 123.0 | F# | 253.0 | 60/29/11 | 7 | 668@.5 | 621 | 0 |
| inshadow | (In Shadow — Arsov) | 780.07 | 172.3 | G | 375.0 | 39/33/28 | 24 | 993@.5 | 1562 | 13 |
| journey | (Lost Frequencies Tomorrowland set) | 3550.01 | 129.2 | F# | 537.0 | 31/40/29 | 76 | 4157@.5 | 7102 | 117 |
| kingdom | (Kingdom — Arsov) | 835.01 | 99.4 | D | 19.5 | 42/37/22 | 26 | 439@.5 | 1672 | 32 |
| lift | (Levels — Avicii) | 198.41 | 123.0 | G# | 28.0 | 20/44/35 | 3 | 399@.34 | 398 | 3 |
| light | A Sky Full of Stars — Coldplay | 267.84 | 123.0 | F# | 80.5 | 28/43/29 | 5 | 425@.5 | 537 | 6 |
| lose | Mind — Skrillex & Diplo | 241.72 | 172.3 | D# | 181.0 | 31/40/29 | 4 | 392@.5 | 485 | 9 |
| melt | Gooey — Glass Animals | 289.04 | 92.3 | D | 225.5 | 32/39/29 | 14 | 397@.49 | 580 | 10 |
| miss | (Where'd You Go) | 312.03 | 89.1 | E | 152.0 | 34/36/31 | 2 | 620@.5 | 626 | 9 |
| move | Bachna Ae Haseeno — Vishal-Shekhar | 201.34 | 129.2 | E | 155.5 | 36/31/33 | 3 | 397@.36 | 404 | 5 |
| numb | Habits (Stay High) — Tove Lo (HS remix) | 263.06 | 123.0 | E | 149.5 | 39/33/28 | 16 | 468@.5 | 528 | 10 |
| open | Love Me Like You Do — Ellie Goulding | 249.27 | 95.7 | A# | 214.5 | 31/40/29 | 6 | 396@.31 | 500 | 6 |
| play / thunderclouds | Thunderclouds (LF Remix) — LSD | 198.51 | 123.0 | E | 141.5 | 32/39/29 | 6 | 387@.45 | 399 | 4 |
| press | Iron — Woodkid | 201.71 | 129.2 | G | 98.0 | 37/36/27 | 0 | 400@.5 | 405 | 0 |
| receive | Golden — HUNTR/X | 191.76 | 123.0 | G | 22.5 | 33/36/31 | 2 | 395@.48 | 385 | 5 |
| release | Overthinker — INZO | 274.26 | 89.1 | G# | 219.0 | 37/34/28 | 13 | 358@.18 | 550 | 16 |
| remember | Wut — BIICLA | 156.73 | 86.1 | C | 73.5 | 33/34/33 | 4 | 375@.18 | 315 | 1 |
| return | I Was Wrong — A R I Z O N A | 216.53 | 117.5 | G# | 54.0 | 31/42/27 | 4 | 390@.33 | 435 | 8 |
| rise | Opus — Eric Prydz | 543.49 | 123.0 | E | 251.0 | 24/50/26 | 14 | 399@.46 | 1088 | 18 |
| search | Faded — Alan Walker | 212.6 | 89.1 | F# | 185.5 | 37/35/28 | 5 | 367@.18 | 427 | 2 |
| speak | The Sound of Silence — Disturbed | 262.41 | 172.3 | F# | 251.5 | 38/36/26 | 3 | 315@.18 | 526 | 11 |
| trace | Shape of You — Ed Sheeran | 233.73 | 129.2 | F# | 85.5 | 26/41/33 | 1 | 592@.5 | 469 | 0 |
| unfold | (Says — Nils Frahm) | 499.18 | 152.0 | C | 367.0 | 32/39/29 | 11 | 675@.5 | 1000 | 8 |
| wake | (Wake Me Up — Avicii) | 272.46 | 123.0 | A | 72.5 | 31/42/27 | 0 | 171@.18 | 546 | 6 |
| want | (APT.) | 173.4 | 152.0 | G# | 69.0 | 31/36/32 | 5 | 519@.5 | 348 | 2 |
| wild | Zoo — Shakira | 197.76 | 129.2 | A | 162.0 | 24/44/32 | 2 | 396@.39 | 397 | 2 |

Every quiet-region, drop and top-8 list was printed in full during the reading (scratch record). Silence structure worth noting:
- unfold opens with 241 s of near-silence (58 strict windows).
- rise has 37 strict windows in its first 113 s.
- hold has its two silences at 3–30 s and 187–217 s, matching the authored "two thresholds".
- numb has a metronomic run of 1.5 s quiet windows at 0–16 s and 112–127 s.
- journey has 117 loose windows; its 605–662 s gap is a set transition.

### A2 · `scripts/` (read in full)

**`analyze_tone.py`** (216 lines). librosa at 22050 Hz mono.
1. `chroma_cqt` mean per pitch class gives the dominant pitch class.
2. Krumhansl–Schmuckler key detection. Profiles verbatim: major `[6.35,2.23,3.48,2.33,4.38,4.09,2.52,5.19,2.39,3.66,2.29,2.88]`, minor `[6.33,2.68,3.52,5.38,2.60,3.53,2.54,4.75,3.98,2.69,3.34,3.17]`. Each roll is correlated and the best gives key, mode and confidence.
3. Spectral centroid.
4. STFT band energy: sub-bass 20–80, bass 80–250, low-mid 250–500 Hz.
5. Candidates for root and fifth come from `note_freq(idx, oct) = 16.3516·2^oct·2^(idx/12)` across octaves 1–5, kept within 60–250 Hz. Per candidate it computes `presence` = local bin energy / max bin energy and `absence = 1−presence`, plus `sweet = clamp(1−|f−140|/100)`. The score is `0.4·absence + 0.6·sweet`.
6. Beat heuristic: tempo <80 or rms_var <0.5 gives 4 Hz theta; tempo <110 gives 6 Hz theta-alpha; otherwise 8 Hz alpha.
7. Output `{key, key_confidence, dominant_pitch, tempo_bpm, spectral_centroid, sub_bass_pct, bass_pct, carrier_hz, beat_hz, beat_label, binaural_left=carrier, binaural_right=carrier+beat}`. Default carrier 136.0.
8. NB: the batch runbook **ignores the prescription** and reads the absent fifth off the candidate table.

**`temporal_analysis.py`** (227 lines). STFT n_fft 2048 (the comment says it "matches our Web Audio analyser.fftSize"), hop 512 (~43 fps).
- Per frame it takes the dominant bin in 50–300 Hz (threshold 0.01), summarised over 5 s windows `{time, bass_hz, note, energy, bass_present_pct}`.
- It also computes bass coverage %, a note histogram and gaps >1 s.
- Verdict: >80 % STRONG; >50 MODERATE (needs fallback); >20 SPARSE ("pre-computed carrier recommended"); otherwise ABSENT. A std below 30 Hz means a STABLE carrier ("a fixed carrier at median would work"); otherwise MOVING.

**`deep_analysis.py`** (209 lines). soundfile chunked reads (memory-efficient).
- Six 20 s L/R windows → FFT n=16384 Hann → top peaks 80–300 Hz per channel.
- **Binaural-pair detection**: L/R peak pairs with 0.3 ≤ Δ ≤ 40 Hz in three bands (20–80, 80–300, 300–800), labelled by brainwave (≤1 delta, ≤4 theta, ≤8 alpha, ≤13 beta-low, ≤30 beta, else gamma).
- **Stereo width per band**: a 45 s window at 35 % of the song, Butterworth bandpass, L/R correlation; width = 1−|corr|. Tags: corr >0.97 MONO, >0.85 near-mono, width >0.25 stereo.
- **Isochronic pulse detection**: 80–300 Hz bandpass → Hilbert envelope → downsample to ~200 Hz → FFT of the envelope 1–40 Hz. Peaks ≥0.18 that are consistent in ≥2 of 3 sections (25/50/70 %).
- Mono files only get the isochronic check.

**`scripts/batch/README.md`** (19 lines): five generators plus validate plus make_report. The method is "STEPS 1/6/7 only — THE WORD (lyrics), the listening pass, the Discoveries and the metaphor are NOT done. Every peak_t is flagged needs_listening."

**`assemble.py` … `assemble5.py`** (255/148/131/139/111 lines). They emit `bindu-score/v2.0`. The common skeleton, verbatim values:
- `GEN_ORDER = ["bindu","gaia","sid","arch","karishma","sakshi","ashrey"]`
- `ENS_READS = {bindu:"pitch", gaia:"bass", sid:"sustained energy", arch:"mids", karishma:"silence (inverse)", sakshi:"brightness", ashrey:"centroid + web"}`. This is the universal role → data stream map.
- `bloom {stages 5, rise_rate 0.06, fall_rate 0.012, thresholds s1 .15 s2 .3 s3 .5 s4 .7, systems ["dot","ghost trail","orbital rings","radial rays + particles","crown mandala"]}` ("rises fast, falls slow")
- Binaural `gain {law:"inverse", formula:"base + 0.025 * (1 - songEnergy)", held_by:"karishma"}`; `spatial {true_binaural, pan:"hard L/R"}`; carrier `held_by:"sid"`, `fixed:true`, `derivation:"absent_fifth"`.
- `consciousness_loop.word_reveal {at:"peak_t", position:"bottom 15%", i_love_you_at:"peak_t - 3"}`; `seed.types_at_bpm: true`.
- `return {dissolution_order: reverse(GEN), karishma_final_bloom:true, bindu_ending:"spiral to center dot"}`.
- `optional_layers {ol1_pink_noise_floor:on, ol2_pre_roll_resonance:on, ol3_voice_guidance:off}`.
- `field_connection.reads_on_load ["essence.name","memory.chakras","memory.events","being.entries","most_repeated_word"]`. `writes_at_fruit` pushes a memory event `{kind: ensemble-dance|chakra-dance, song, artist, verb, word, dwellMs, motion}`. `app_activity {source_app:"Field", activity_type:"Ceremony Sealed", implemented:false}`. Integrity rules: "never localStorage.clear()", "never write pool internals directly", "every entry carries at: Date.now()".
- Phase skeleton: Opening 0→min(30, 0.3·peak); Build→peak; Peak→peak+20; Return→end.
- `resonance_link` must never carry Hz (validator R16 HARD). Run 2 fills `{chakra, subtle_body_chakra, basis:"chakra"}` and leaves `shaktis: []` ("not reaching for a named Shakti").
- Per-run beat mapping: assemble 1 BPM <80→4, <110→6, else 8. assemble2 states delta 2.5 / theta 4 / theta-alpha 6 / alpha 8. assemble3 BPM <110→4 theta, else 8 alpha. assemble5 keeps the authored catalog beat.

Per-song carriers and flags (all verbatim in the scripts):
- search C#3 138.6 (F# maj .685, presence .30)
- still/ember A#2 116.5 (three-way peak conflict 182/342.5/342)
- dream A#2 116.5 (.11)
- rise E3 164.8 (.66, underweighted)
- light C#3 138.6 (peak gap 80.5 vs 200)
- howl C#3 138.6 (.20)
- release D#3 155.6 (.14; HTML, registry and extraction all agree on 219)
- ground A2 110 (D→A = cross)
- numb B2 123.5 (E→B = thunderclouds; peak gap 149.5 vs 90)
- press D3 146.8
- follow D3 146.8 (.15)
- build E3 164.8
- open D#3 155.6
- speak C#3 138.6 ("TRACK 27 SPECIAL: the Swift app has a hardcoded Score.cross reused on this track with constants inherited from a DIFFERENT song (Ameno)")
- still-ajna C#3 138.6
- receive D3 146.8
- hold G2 98.0 ("the app's Aatma vocabulary is 'soul'")
- dissolve A#2 116.5
- return G#2 103.8
- enough A2 110 (.73)
- remember G2 98
- move E3 164.8
- wild A2 110
- melt A2 110
- glow F#2 92.5
- lose A#2 116.5 (key conf .458, lowest)
- fade A2 110 (peak gap 171.5 vs 240)
- trace C#3 138.6
- believe B2 123.5 (.76)
- ache F#2 92.5 (.13, conf .931, highest)
- crash E3 164.8
- play B2 123.5 ("PREFER that authored Score", i.e. thunderclouds)
- lift B2 123.5
- wake A2 110 (.78)
- brave E3 164.8
- ascend D#3 155.6
- unfold G2 98 (BPM 152 is a librosa artefact)
- crave C#3 138.6
- want A#2 116.5
- confront C3 130.8 (.01, "textbook absent-fifth")
- miss B2 123.5
- cherish F#2 92.5
- journey C#3 138.6 ("*** THIS IS A 59-MINUTE CONTINUOUS DJ SET, NOT A SINGLE SONG. ***")
- kingdom A2 110 (beat 5.5 theta authored)
- inshadow D3 146.8 (beat 2.5 delta authored)

**`validate.py`** (104 lines). It checks the 21 rules of score-format §5. Required blocks: identity, config, anchors, phases, silence_windows, binaural, consciousness_loop, return, field_connection. The rules cover:
- id pattern `^[a-z][a-z0-9_]*$`
- times within [0, dur]
- phases ordered with no overlap
- silences with no overlap
- peak_t inside some phase
- return < dur
- the beat_schedule's last `until` is null
- the generation_order is exactly the seven
- derivation is one of `{absent_fifth, absent_root, present_root, imposed}` (imposed needs a reason)
- **R16 HARD: no Hz in resonance_link**
- a footprint is present when there are silences

Warnings: R19 no haptics at peak; R20 unauthored peak without a reason.

**`make_report.py`** (169 lines). It writes BATCH-REPORT.md for Run 1. Secondary peaks come from `find_peaks(E, height .6, distance 40)`, and two or more maxima ≥0.95 count as "NEAR-EQUAL". The "What surprised me" list is verbatim (ground/numb matching precedent; still is the puzzle; release is the cleanest; howl is "never got under the 400-hit cap").

### A3 · `references/batch-scoring/BATCH-SCORING-STATE.md` (47 lines)

- 45 batch drafts plus 3 authored (cross, abide, thunderclouds). They were written to Airtable field `fldxIm6qUXLcdrRuR` (Score JSON), all Status = Drafted.
- Runs: 1 = tracks 0,1,2,4,5,8,10,14,22 (Track 1 renamed still→ember); 2 = 23–31; 3 = 39–52 (`return` 404); cross 38; 4 = 53–63 (audio not hosted); meditate 35, 36.
- Not done: STEP 0 (the Word); listening; Discoveries (spatial_memory/path/geometry/mirror_system/tiers/haptics null); the binaural arc (single placeholder beat; "No 2.69 Hz placed except cross"); fruit, recognition and hues.
- Blocker verbatim: "The iOS app does not consume Score JSON yet. `Score.forTrack(id:)` is hardcoded (only track 27=cross); felt experience today = Carrier + Beat + Element + Seed."

### A4 · `references/deep-dive-protocol.md` (276 lines): the 10-step scoring method

1. **STEP 1**: analyze_tone plus temporal. Decide the carrier (margin <0.15 means STEP 2) and name the arc. Examples verbatim: "Two fires with one breath between them." (Manipura); "Three breaths of increasing fullness, with a long exhale before the fullest." (Anahata); "Single journey — surface world → bass arrival → shadow plateau → awakening → exhale." (In Shadow).
2. **STEP 2**: deep_analysis. Sub-bass corr >0.95 means mono and safe; <0.80 means stereo, lower the gain. If the carrier is a dominant peak in both channels it is present, so reconsider. Isochronic pulses are checked against BPM/60.
3. **STEP 3**: Seven Lenses in archetype language (BINDU one word / GAIA the need / SID what holds / ARCH the frequency that reaches the body / SAKSHI the shape / KARISHMA where grace is / ASHREY what it assembles into). The material, in order of authority: lyrics > energy arc > temporal > title/composer > instrumental voices > prior knowledge (last).
4. **STEP 4**: Page language. The One Word / The Need / What Holds / The Frequency / The Shape / The Grace / The Recognition. No proper nouns.
5. **STEP 5**: Lalita, in four moves.
6. **STEP 6**: Binaural design by element.
   - Arc shapes: "Earth: single descent · Water: three waves with ebbs · Fire: two blazes, one breath between · Air: three inhales, long exhale before fullest · Film/Meditate: narrative arc; film leads, binaural completes".
   - Phase table: Phase · Window · Beat Hz · Brainwave · Gain.
   - Principles verbatim: "Carrier fixed. Never moves." "ARRIVAL gain 0.005–0.010. HOME gain 0.030–0.056. Meditate/Film HOME max 0.040." "Deepest binaural state = song's deepest emotional moment, not necessarily its loudest." Drone endings hold at minimum gain. The family seam holds at minimum gain, never zero.
7. **STEP 7**: Phase labels. One word, lowercase and bodily, plus a sub-text from a real lyric or moment.
8. **STEP 8**: Embed `TONE_SCORES[verb] = [{start,end,beat,carrier,gain}]`, `PHASE_LABELS[verb] = [{start,end,name,subtext}]`, `SONG_MEANINGS[verb] = {title, artist, element, carrier_note, the_play, lenses:{one_word,need,holds,frequency,shape,grace,recognition}}` and the registry.
9. **STEP 9**: Verification, reading back every object.
10. **STEP 10**: See and feel. The test "body feels different with it on vs. off during HOME phase? If not — raise HOME gain by 0.010".

### A5 · `references/instrumental-protocol.md` (118 lines)

Without lyrics, the materials are: title, composer context, energy arc, instrumental voices, key moments, and "What's Absent — the sub-harmonic the music is built on but doesn't sound".
- Per-lens handles by genre: Classical, Electronic/Ambient, Hybrid, Solo Piano ("Arch: the right hand · Sid: the left hand · Karishma: the decay of notes, the pedal tones"), Film Score.
- Energy-arc mapping verbatim: "Rising energy = Arch calling, Gaia revealing · Sustained plateau = Sid holding · Silence/breakdown = Karishma arriving · Resolution/crest = Ashrey synthesizing".
- Test: "If a reading of an instrumental piece feels thinner than a vocal reading — you didn't work the material hard enough."

### A6 · `references/lalita-protocol.md` (135 lines)

- Lalita is "the meta-archetype… the player telling the player about the play".
- The four moves are THE SONG AS IT IS → THE PATTERN → THE PLAY ("The song pretends X. The song is actually Y.") → THE BLESSING (one sentence, then stop). Muladhara example verbatim: "Enjoy the soldier thinking he's alone. He never was."
- Voice: direct, playful, bodily, unhurried, specific. Four to five paragraphs, 45–90 s of reading.
- Failure modes: too much Pattern; a Play that spoils; generic spiritual language; loss of structure; writing without the lenses.
- Three layers verbatim: "The page surfaces Lalita first. Beneath her, a 'What the ensemble hears' toggle reveals the seven lenses — translated into player-language… The archive holds the raw lenses in archetype-language. Three layers. One song."

### A7 · `references/next-horizons.md` (172 lines)

Ground verbatim: "Eight tabs, three-mode Player, Consciousness Loop, 33-chakra Map, DSP binaural engine with inverse RMS modulation, nine element visual vocabularies. Airtable catalog spine." 25 entries are fully read (14 songs and 11 breaths). Sonar Ears activates at 33 scored.

- **H1 Gateway/Monroe/Hemi-Sync**: the Focus levels 1, 3, 10, 12, 15, 21, 22, 23, 24–26, 27, 34/35, 42/49. Proposed mapping verbatim: "Focus 10 … Anahata/Ajna territory. Focus 15 (no time) is Sahasrara. Focus 21 (threshold) is Aatma. Focus 22–27 … land in Maya." Also: "The Consciousness Loop is already Focus 10 induction by another name (settling → focus → offering → dance → revelation → integration)."
- **H2 Astral body sound fields**: koshas (5), sharira (3), nadis (sushumna/ida/pingala, 72,000), bija mantras "LAM, VAM, RAM, YAM, HAM, OM, silence", the Theosophical bodies, the Tibetan rlung/rtsa/thig-le, and the Taoist jing/qi/shen and microcosmic orbit. Proposed: a Kosha session library, nadi sessions, bija sessions, a "subtle-body Map … koshas as concentric shells".
- **H3 Beyond the 33**: sushumna whole-spine arcs, element ceremonies, 40-day/lunar/seasonal arcs, Lab as composer ("compose their own binaural signature, save it, share it"), and a generative field from the Oracle.
- **H4 Threshold sessions**: bardo/dying, grief ("waves plus long troughs"), trauma (titration/pendulation), sleep (WILD/MILD/REM), duo sessions ("one in each ear"), Oracle-generated sessions, biometric HRV.
- Can/cannot list: it cannot play a designed session without music, multi-person, live biometric, voice, dynamic composition, long ceremonial arcs, or "Render song Phase Labels".

### A8 · `references/process-learnings.md` (499 lines): the engine's hard-won laws

**Architecture (S1)**, verbatim:
- "Static tone interferes."
- "Real-time bass tracking warbles."
- "Pre-computed carrier + real-time modulation is the architecture. Librosa finds carrier (once). Analyser provides breath (live). Carrier is Sid (holds). Modulation is Karishma (fills gaps)."
- "The carrier is the absent sub-harmonic."
- "The carrier doesn't move. Bindu point. Dimensionless. Still. Beat moves (brainwave story). Gain moves (presence)."
- Gain: "0.10 is too loud with headphones. 0.003-0.050 is the phased range."

**Technical (S1)**: session IDs against race conditions; `setValueAtTime` before ramp; `createMediaElementSource` once; smoothstep phase interpolation; viz throttled to 15 fps with audio at 60 fps.

**S2 per-element journeys**: Earth descends once; Water three surges / two ebbs; "Each element's journey comes FROM its reading."

**S3 three-layer architecture and translation discipline** (items 31–38):
- Lens colour signatures: one_word→red, need→green, holds→gold, frequency→blue, shape→silver, grace→rose, recognition→gold.
- Two-step progressive disclosure: "the field reading" → Lalita → "what the ensemble hears".

**S4 categories** (39–41):
- Energy (verb = activation instruction), Music (verb = experiential quality), Meditate (verb = title), Family (verb = the person's essential nature as seed; "purity = Shweta"). Filter bar All · Music · Meditate · Energy · Family.
- Duet seam: "The carrier holds through the seam at minimal gain (0.004) — not zero."
- "Two Groundings" arc.
- Absent fifth confirmed 7/7. Kingdom is the root exception.
- Film: "The film leads. The binaural completes." (max 0.036–0.040). In Shadow's design inversion places delta 2.5 at the awakening (540–725 s) and holds the shadow at theta 3–3.5. Drone ending at 0.008. Tremolo rate 0.12 / 0.11.

**S4 UI**:
- Scored cards get a pip; unscored dims to 45 %.
- "No fallback tone for unscored tracks."
- "Header dot pulses at binaural beat Hz… animation-duration… from 1/beat_hz", with a suggested floor of 200 ms.

**S6**:
- Carrier revision rule: if the carrier shows as a dominant peak, it is disqualified.
- Verb rule: read the track list first.
- Genesis has no return phase.
- **Canvas viz**: background darkens with brainwave depth; "Carrier thread is a SINE WAVE oscillating at the binaural beat rate"; 55 particles driven by `smoothEnergy`; central bloom on gain plus energy; burst of 18 particles on phase transitions; a depth-track dot that descends.

**S7**:
- Energy spine complete 9/9.
- Per-element arcs verbatim: "Light illuminates twice with eye staying open. Crown opens from above and below simultaneously. Soul descends twice with carrier holding through both silences. Maya is a single breath".
- "The verb is its own phase (Aatma)": Phase 6 "held" has only the carrier.
- Anahata and Maya share D#3 155.6 ("in dialogue").
- **2.69 Hz pattern** in Kingdom, Sound of Silence, Golden, Aatma, Maya: "the fingerprint awakening leaves".
- **Dancing Bindu**: "multi-harmonic Lissajous orbital path driven directly by smoothEnergy, gain, and beat Hz"; "Beat rings expand from the Bindu position"; "comet trail… 28 positions of fading red"; "pulses at exactly beat_hz"; "bloom follows the Bindu"; tap the header dot to freeze (`toggleBinduStill()`).
- Isochronic table: Aatma 1.8 Hz @1.000, Experience 1.1 @.995 and 1.7 @.990, Maya 4.3 @.985, Golden 6.1 @.769, Sound of Silence 1.5 @.694.

**S8**:
- Duet = one card, one mp3, one verb.
- The seam is a phase ("crossing" beat 7.0, gain 0.006).
- 2.69 Hz now 8 appearances, including Wake Me Up at A4 440.1 Hz.
- "The 2.69 Hz void phase is valid binaural architecture."
- Wake Me Up has 5 isochronic pulses.
- avīci = "without waves".
- The Rey/levelup family arc is **personal/story**.

**S9**:
- Reading stack complete for 14 songs and 11 breaths.
- "Song Phase Labels are inert in the iOS app."
- Breath Phase Labels use paragraph format `HEAD · timing — body` split on `\n\n` and ` — `.
- Reading Space = four tabs, "WORDS / FREQUENCY / VIDEO / LALITA", with the Recognition Statement pinned above.
- The breath seven-lens form (BINDU words: Down, Even, Resonance, Clear, Heat, Release, Empty, Wide, Home, Ocean, Sleep).
- Breath element signatures.
- "Filled is not the same as rendered."

### A9 · `references/reading-examples.md` (99 lines)

The two benchmark seven-lens readings in archetype language:
- **Muladhara/Iron**: G minor, carrier D3 146.8, lyrics quoted in full in the file, bass "A1 (54 Hz)".
- **Svadhisthana/Crystallize**: G major, D3 146.8, presence 0.15, "At 100 seconds, when the violin pulls back".

Five criteria: lenses unique; specific material; the body as subject; Ashrey converges; the reading names what the song doesn't know.

### A10 · `references/site-v3.md` (15 lines)

- Dances live at `/b/<verb>` (27 on the QR map); the Tree dances at `/tree-of-life/<chakra>-dance`.
- The Dances world places each verb at its own hue angle (27 hues).
- **The Readings world `/bindu/read/` stands each reading at its element's chakra**: "Earth → Muladhara · Water → Svadhisthana · Fire → Manipura · Air → Anahata · Light → Ajna · Crown → Sahasrara · Soul → Aatma · Dissolution → Maya · Meditate → Bindu. Vishuddha has no reading yet — there's no Ether track."
- Permanent addresses: 47.

### A11 · Airtable "Bindu Field" table `tblv3WvMZ90Sfhun6` (60 records, read in full; field names inferred from content because the schema tool returns IDs only)

| field id | inferred name | type | filled |
|---|---|---|---|
| fldoA70yegZzQL7BV | Name ("verb — Song") | text | 60 |
| fldimw5ZGOBg0j738 | Track ID | number | 60 |
| fldrYExLmEjx4wxVt | Verb | text | 60 |
| fldSgcALwlkQPWDz4 | Song | text | 60 |
| fldizqVJeRT2s10NG | Artist | text | 49 |
| flds07pkQlTwXLTWw | Category {chakra, music, meditate, family, Active, breath} | select | 60 |
| fldC5nZ1vH1nclfhe | Element {Earth, Water, Fire, Air, Light, Crown, Soul, Dissolution, Meditate, Family, Threshold + lowercase dupes} | select | 48 |
| fldFD9rYNEP69UEqp | Brainwave State {delta, theta, theta-alpha, alpha, beta + element dupes} | select | 59 |
| fld6pH3kGSqqop2Z7 | Chakra {Muladhara…Maya} | select | 9 |
| fld4oIQGckv2c9DvO | Carrier Hz | number(2) | 60 |
| fld7oCYy1eIWdhE04 | Beat Hz | number(2) | 60 |
| fldUIY8v9p49QyF0B | Audio URL | text | 35 |
| flduzjO1YmMdv7x9v | YouTube/video ID | text | 6 |
| fldyFZy2hzFXTM52K | Seed phrase | long text | 59 |
| fld6ex1l6b5LOIJro | Breath technique spec | long text | 11 |
| fldMzPPCfWRwYpss5 | Lalita's Perspective | long text | 44 |
| fldcXUpENSGaoenRK | Field Reading (seven lenses, archetype language) | long text | 44 |
| fldQq0ONvyoD5NuhS | Phase Labels | long text | 34 |
| fldFW1HEDvfC4gOJy | Recognition Statement | long text | 44 |
| fldWtIXuWNoQQaGuN | Lyrical Words (WORDS tab) | long text | 44 |
| fldjQfTIklHtOa8a4 | Frequency (FREQUENCY tab) | long text | 44 |
| fldDgr3aUQJSheIJp | (Video Pulse Reading?) | long text | 0 |
| fldbSnJQo2tJ8ZSt1 / fldNZuKRNfUDrp9QP | two checkboxes (thumbs-up) | checkbox | 6 / 9 (chakra rows) |
| fld4VA2ywm9DUIqdi / fldUp2aHSRomippvI / fldTJD0Om5bik6TjF | Inhale / Hold / Exhale counts | number | 11 |
| fldx1jepMrdMGYoIJ | Breath intention {ground, activate, open, clarify, dissolve, expand, rest, balance} | select | 11 |
| fld0aC2B25S7rODEQ | Safety {open, screened} | select | 11 |
| fldxLxJQw6jOKWQYK | Breath animation mode {hum, ocean, double_pulse, active_phase} | select | 4 |
| fldQ8MM9hCe6rARuZ | (long text) | — | 0 |
| fldM3pOWk5M0bYNbD, fldyc9uYnlya7wB6U | links → tblJlBeiHnqGpYrL7 | links | 0 |
| fldxIm6qUXLcdrRuR | Score JSON | long text | 46 |
| fldUlWDvSkeHpx80x | (single line) | text | 0 |
| fldOSMHwD7IxshwO7 | Score Status {Unscored, Drafted, Verified} | select | 46 (all Drafted) |
| fldbLpx57LJoYXlwu | links → tbl7vzODMMJUgeX0b (story titles: Bindu Feed stories) | links | 45 |

**Catalog rows.** Track · verb · song · category · element · state · carrier · beat:
- **Music and meditate:**
  - 0 search Faded music Meditate theta 138.6/5.5
  - 1 ember Sit Around The Fire meditate delta 116.5/2.5 (audio URL still `/bindu/still.mp3`)
  - 2 dream meditate delta 116.5/2.5
  - 4 rise Opus Air alpha 164.8/10
  - 5 light Light alpha 138.6/10
  - 8 howl Fire delta 138.6/2.5
  - 10 release Water theta 155.6/5.5
  - 14 ground Earth Earth delta 110/2.5
  - 22 numb Water delta 123.5/2.5
- **Chakra spine** (audio at `/tree-of-life/<chakra>.mp3`):
  - 23 press Iron Muladhara Earth delta 146.8/2.5
  - 24 follow Svadhisthana Water theta 146.8/4
  - 25 build Manipura Fire theta 164.8/4.5
  - 26 open Anahata Air theta-alpha 155.6/5.5
  - 27 speak Vishuddha Air alpha 138.6/7
  - 28 still Ajna Light alpha 138.6/8.5
  - 29 receive Sahasrara Crown alpha 146.8/10
  - 30 hold Aatma Soul delta 98/2.5
  - 31 dissolve Maya Dissolution theta 116.5/3.5
- **Others:**
  - 33 before Genesis Meditate delta **136**/2.5 (process-learnings says the carrier was revised to A2 110)
  - 34 purity family Family theta **136**/5.5 (the learnings say B2 123.5)
  - 35 in shadow 146.8/2.5
  - 36 kingdom 110/5.5
  - 37 levelup family 123.5/**2.69** (no category element, no audio)
  - 38 cross music **Threshold** theta 110/4.5
  - 39–52 Run 3 at 4 or 8 Hz
  - 53–63 Run 4 at 4 or 8 Hz, no audio
- **Breath** (101–111): ground/Come Home 80/2.5 4:0:8; balance/Even Breath 136.1/10 5:0:5 (+holds 5:5:5:5 in spec); open/The Hum 136.1/6.5 4:2:6 hum; clarify/Counted Exhale 256/10.5; activate/The Stoke 194.18/18 beta screened active_phase; rest/Long Release 60/1.5 4:7:8 (stored as 4/2/12); dissolve/Empty Pause 136.1/5.5; expand/Thinning Breath 221.23/7.5 5:5:5; cohere/Home Frequency 136.1/10; sound/Ocean Breath 194.18/8.5 ocean; sleep/Night Protocol 60/1.5 double_pulse.

**Seed phrases** (59, verbatim, first-person questions/declarations). Examples:
- "Where are you now?"
- "Sit down. The fire is already lit."
- "You don't remember how you got here."
- "This song has no words. Neither did you, once."
- "Made by a brain that reorganized itself."
- "The throne at the center of every kingdom is empty."
- "What is asking to be crossed in you?"
- Breath seeds: "the earth has always been beneath you", "nothing to seek, nothing to leave", "the sound was already inside you", "the mind that counts is already becoming still", "the fire was waiting to be called", "there is nothing you need to do in this breath", "everything loosens at the end of the breath", "you are larger than you remember", "the breath that needs no adjustment", "the ocean has always been breathing", "this is the body's own signal for rest".

**Phase Labels** (34; read in full). Songs use JS-array format `{t, name, sub}`, 5–12 phases. Examples verbatim:
- press: exile 0 / descent 15 / recognition 60 / home 130 / return 185
- still (Ajna): above 0 / adjusting 50 / first light 110 / held 155 / deepening 200 / seeing 235 / open 280
- hold (Aatma): surface 0 / threshold 65 / first depth 90 / threshold 185 / second depth 215 / held 278
- kingdom: floor 0 / weight 130 / peak 260 / breath 270 / quiet 380 / sudden 510 / drone 730
- levelup: 12 phases incl. "crossing 199 — the silence between — two worlds, one ground"

Breaths use paragraph format `0:00–2:00 | Name — body`.

**Recognition Statements** (44, read in full): one-sentence "complete seeings". Breath recognitions carry citations, e.g. "humming raises nitric oxide 15x and opens the vagal gate [SCIENCE: Weitzberg & Lundberg 2002]" and "[SCIENCE: Balban et al. Cell Reports Medicine 2023]".

**Lalita's Perspective** (44, read in full): four-move texts. The breath Lalitas are a distinct long form with headings "What the session is / The pattern it works with / The play / The blessing". The library framing is verbatim: "The library opened with Come Home… it closes here" and "Goodnight. The body knows the way from here."

**Score JSON** (46): checked structurally against `scores/*.score.json` by python. 12 are EQUAL (in shadow, kingdom, lift, wake, brave, ascend, unfold, crave, want, confront, miss, cherish). The rest differ only by ASCII-fied punctuation (— → -, → → ->) and by `audio_data.meta` trimming (`quiet_regions_strict`/`top8_impacts` dropped, `note` added). journey's Airtable copy has re-picked silence windows plus a `silence_windows_note`. **cross (38) carries the only authored Score** (28,398 chars): metaphor "cathedral", tiers t1–t4, `consciousness_loop.fruit.weaves` with dwell conditions (e.g. "dwell < 1.5s" → "You didn't hesitate."), and an authored return deviation.

**Links to Bindu Feed stories** (`fldbLpx57LJoYXlwu` → tbl7vzODMMJUgeX0b), 45 rows, e.g. press → "The Drums Were the Ground", "The Soldier's Room"; still → "You Can't Find the Center Because You Are It"; dissolve → "The Veil That Noticed"; cohere → "Two Tones Leaning Into One". This is story material already joined to the Feed.

**Lyrical Words** (`fldWtIXu…`, 44, read in full).
- Songs: a "heard from witness consciousness" paragraph on what the words are underneath. Example: press, "What's actually speaking is a body asking to be returned to the earth it forgot it was already standing on."
- Breaths: multi-paragraph practice instructions with the mechanics. Examples: 101 "inhale 1-2-3-4, exhale 1-2-3-4-5-6-7-8"; 105 "seated or lying down, never standing, never near water, never while driving"; 106 "shorten the counts but keep the ratio. Three in, five hold, six out"; 111 "a second short sip of air".

**Frequency** (`fldjQfTI…`, 44, read in full). Per track: why this carrier and why this beat. Facts worth keeping:
- **The breath library's carriers are named planetary (Cousto) tones**, quoted verbatim:
  - "136.1 Hz is the most mathematically rigorous of the planetary tone frequencies. One tropical Earth year… 31,556,926 seconds… Octave-doubling this 32 times yields 136.10 Hz", the "OM tone", tied to "the tambura drone… The Sadja".
  - "194.18 Hz is the Earth Day tone… the sidereal day… octave-doubled".
  - "221.23 Hz… the Venus tone in the Cousto planetary system".
  - "256 Hz… exactly 2⁸… the mathematician's C".
  - 80 Hz "felt vibration… the chest wall"; 60 Hz "the deepest carrier in the Akash library".
- The library is called the "Akash library".
- Every breath Frequency text carries an "honest frame" paragraph separating SCIENCE from TRADITION.
- Song facts quoted from Frequency:
  - Experience isochronic 1.1/1.7 Hz; Golden F1 43 Hz and 6.1 Hz alpha; Aatma "A1 at 53.8 Hz and F1 at 43.1 Hz", "the carrier we add — C3, 130.8 Hz".
  - Kingdom "6.7 Hz alpha pulse… carrier is 146.8 Hz, D3… the absent root of D major".
  - purity "the 4.9 seconds of silence"; levelup "B2, 123.5 Hz… the absent fifth of E in Levels and the absent root of B minor in Beautiful Now".

**Field Reading** (`fldcXUpE…`, 44, read in full). The seven lenses in archetype language (BINDU, GAIA, SID, ARCH, SAKSHI, KARISHMA, ASHREY) per track.
- **The BINDU one-words, by track, are a ready word-set:**
  - Songs: search "here", ember "Already", dream "Waking", rise "Higher", light "Up", howl "Release", release "Current", ground "Rest", numb "Feel", press "Ground", follow "Flow", build "Current", open "Already", speak "RECEIVED", still "OPEN", receive "WE", hold "HOME", dissolve "DISSOLVE", before "Before", purity "Here", in shadow "Within", kingdom "Sovereign", levelup "Recognition", enough "Enough", remember "Still", move "Delight", wild "Instinct", melt "Surrender", glow "Here", lose "release", fade "Presence", trace "Home", believe (the unnamed object/dawn).
  - Breaths: Down, Even, Resonance, Clear, Heat, Release, Empty, Wide, Home, Ocean, Sleep.
- Breath Field Readings name the breath's **SID** as a structural constant: "the ratio", "the square", "the hum itself", "the count", "the recovery pause", "the hold", "the empty hold", "the slowness itself", "the resonance rate", "the throat constriction", "the double inhale". The breath **KARISHMA** sits in a pause or seam: "the bottom of the exhale", "the held-empty wall", "the instant the hum stops", "the lost count", "the pause after the twenty rounds", "the held seven", "the turn".
- Every breath ASHREY opens: "The breath is the structure; the breather activates it."
- **Privacy note:** the purity (34) and levelup (37) readings carry family and past-life material (Shweta as "the white substrate"; the Rey/Chief/monk arc; "Ash-Rey"). It is personal and story-tier and is recorded here only as existing.

---

## B · Gifts for the upgrade

Each row: what · source · world(s) · how it works there (mechanism) · what it needs · energy/story.

### B1 · Sound engine

| # | Gift | Source | World(s) | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **Absent-fifth carrier per Śakti / per ring.** Every seat gets a fixed felt-register carrier (90–165 Hz). | process-learnings S1 #4–5; analyze_tone.py:109–157 | Her Home, Her Presence, nine rings, the Climb | Each seat's room holds one sine carrier L and carrier+beat R (hard pan). The carrier never moves; only the beat and the gain move. The Mandala has no songs, so the carrier is derived from the ring's or chakra's **tonal assignment** rather than from analysis. A natural rule: the ring's chakra key (from the catalog: Muladhara D3 146.8, Svadhisthana D3 146.8, Manipura E3 164.8, Anahata D#3 155.6, Vishuddha C#3 138.6, Ajna C#3 138.6, Sahasrara D3 146.8, Aatma G2 98 (or C3 130.8 per S7), Maya A#2 116.5/D#3 155.6). | A `carrierHz` and `beatHz` per ring/Śakti in a seed table, or a join to Bindu Field by chakra. AVAudioEngine source nodes, two oscillators. | energy |
| 2 | **Inverse gain law.** The binaural grows louder as everything else quiets. | assemble*.py `gain.formula "base + 0.025 * (1 - songEnergy)"`; S1 #6 | every world with sound | Gain = base + 0.025·(1−E), where E is the live RMS of whatever else plays (Leela sound, room drone, the Rite chant). With nothing else playing, it sits at base. Ranges: ARRIVAL 0.005–0.010, HOME 0.030–0.056, meditate max 0.040. Ramps use `setValueAtTime` then linear ramp (smoothstep between phases). | An RMS tap on the mixer bus (installTap) and smoothing. | energy |
| 3 | **Beat schedule as a phased arc** (`[{until, hz, state}]`, last `until` null). | validate.py R9; deep-dive STEP 6 | The Rite (Today), the Climb, Modes | Each ceremony is a time-indexed list of beat Hz and gain. The engine interpolates with smoothstep. For example, Rite arrival is alpha 8 at 0.006, home is theta 4 at 0.040, and the close is delta 2.5 at the minimum-hold value. | A JSON arc per rite or mode; a small scheduler. | energy |
| 4 | **Element arc shapes** as templates for sound per ring element (Earth single descent; Water three waves / two ebbs; Fire two blazes one breath; Air three inhales with the long exhale before the fullest; Light twice with eye open; Crown from above and below; Soul descends twice with carrier through two silences; Maya a single breath). | deep-dive STEP 6; process-learnings #19–21, #81, #120 | nine rings, the 33 (braid), Ahaṅ/Nāma/Ātma/Amṛta elements | The ring's element selects the shape of its gain and beat envelope over a dwell (e.g. 3 min). Ruling 4 elements map: Ahaṅ fire → two blazes; Nāma air → three inhales; Ātma light → twice, eye open; Amṛta water → three waves. | Four or nine envelope definitions; ring→element table (already in foundation). | energy |
| 5 | **Seam/drone holds: never zero.** The carrier holds at 0.004–0.008 through silences, seams and drone endings. | S4 #43, #55; S8 #103 | crossings through the point, transitions between worlds, Beneath | When the user crosses between worlds through the Bindu, the carrier of the old room holds at 0.004 for the crossing (~3 s) and the new carrier fades in. "The seam is a phase, not a gap." This gives sonic continuity for the three threads. | Crossfade logic keyed to navigation. | energy |
| 6 | **2.69 Hz void phase.** The awakening interval used as the designed beat for void/gap/death moments. | S8 #108; S7 #87–90 | Beneath, deep zoom into the Bindu (ruling 9), Maya/Ego-reveal ch.32 seal, the Well | When the user zooms past the last layer into the Bindu, the beat glides to 2.69 Hz at low gain. This is the only place it is designed. | One beat value; a design rule. **Not invented**: it is a documented archive value. | energy |
| 7 | **Isochronic / beat-pulse visual** (dot pulses at beat_hz, with a 200 ms floor). | S4 #59; S7 #94 | Home (the Bindu), Her Presence | The Bindu at Home pulses at the current beat Hz, with a minimum period of 200 ms. Freeze on tap (`toggleBinduStill`) for eyes-closed listening. | CADisplayLink; a phase accumulator. | energy |
| 8 | **Pink-noise floor and pre-roll resonance** (optional layers ol1/ol2 default on; ol3 voice off). | assemble*.py `optional_layers` | all sound worlds; Settings | Ol1 is a pink-noise bed at very low gain under the carrier. Ol2 is a pre-roll: the carrier arrives a few seconds before the room renders ("the carrier arrives before the prophet speaks", speak phase 0). Ol3 stays off, consistent with "no generated voice". | Noise generator node; an arrival-delay setting. | energy |
| 9 | **Session-ID race guard and single-source rule** | S1 #8–10 | engine | Each new tone gets a session ID: kill old ones immediately, fade on pause. Create the media source once. These are portable AVAudioEngine lessons. | Engine code. | energy |
| 10 | **Lab: a free binaural instrument** (carrier/beat dials, save as your signature). | next-horizons H3 "Instrument as pure instrument"; ground "Lab" | the Modes (a "Lab"/tuning mode), the Well | The user sets carrier and beat, hears it, and saves it as "my tone". It could be bound to their own kp position as the day's tone. | Two sliders; storage in App Activity as a Tone event (no scoring). | energy |
| 11 | **Breath sessions with a visual metronome** (11 techniques with ratios, carriers and beats, seeds, phase labels, safety gate). | Airtable rows 101–111; `fld6ex1…` spec | the Modes (Breath mode), Today/the Rite opening, Her Home | The circle animates the ratio (e.g. 4:0:8:0; Box 5:5:5:5; 4-7-8; physiological sigh double-pulse; ujjayi ocean; bhramari hum; Bhastrika `active_phase` behind the **screened** gate). The carrier and beat come from the row (80/2.5, 136.1/10, 60/1.5, 194.18/18 …). Phase labels render in paragraph format. | Read Bindu Field breath rows (base app248…) or copy them into the Mandala base; the breath animation modes hum/ocean/double_pulse/active_phase. | energy |
| 12 | **Element → chakra placement of readings** (Earth→Muladhara … Meditate→Bindu; Vishuddha has no Ether track). | site-v3.md:6 | the 33 (each chakra room), the Bindu (Meditate) | Each chakra room offers "the track that stands here". Meditate pieces (ember, dream, in shadow, kingdom, before) belong to **the Bindu** (centre/Home). | Join table chakra ↔ track IDs (catalog has fld6pH3 for the 9 spine). | energy (sound) |

### B2 · Performances, dances and time

| # | Gift | Source | World(s) | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 13 | **The seven-dancer ensemble mapped to data streams** (bindu=pitch, gaia=bass, sid=sustained energy, arch=mids, karishma=silence-inverse, sakshi=brightness, ashrey=centroid+web), generation order and reverse dissolution. | assemble.py:8–11, 199 | the 33 (dance), A Strange Game, Her Presence performances | For a performance: each archetype is a moving point whose radius/speed follows its stream: gaia←EB, arch←EM, sakshi←B/EH, karishma←1−E, sid←smoothed E, bindu←pitch (P is dead, so derive it), ashrey←web of all. Dancers enter in GEN order and leave in reverse. **This is exactly ruling 6**: "the dance draws on every archetype, all named". Lalita is the meta-dancer (lalita-protocol). | Per-track `-data.json` (0.5 s frames) for 47 songs; a SpriteKit/Canvas performer. | energy |
| 14 | **Bloom: five stages** (rise 0.06, fall 0.012, thresholds .15/.3/.5/.7; dot → ghost trail → orbital rings → radial rays+particles → crown mandala). | assemble*.py bloom | Home (the Bindu blooming), the Mandala (yantra unfolding with energy) | The smoothed energy drives the stage. At s4 the crown mandala appears: **the Śrī Yantra itself can be the stage-5 crown**. Rises fast, falls slow. | One state machine; existing yantra drawing. | energy |
| 15 | **The dancing Bindu**: Lissajous orbit driven by smoothEnergy, gain and beat Hz; beat rings from the dot's position; 28-point comet trail; bloom follows the dot; home bloom at centre. | process-learnings #91–96 | Home, the Climb (point moving up the Axis), deep zoom | Orbit speed ∝ beat Hz (alpha tight and fast, delta wide and slow), amplitude ∝ energy. A ring is emitted every beat. Quiet passages leave it near-stationary. This gives the Bindu "home" world a living point. | Canvas code (ported from builds/bindu-field.html, not in my assignment). | energy |
| 16 | **Canvas depth field**: the background darkens with brainwave depth; the carrier thread is a sine at beat rate; 55 particles on smoothEnergy; an 18-particle burst on phase transitions; a depth dot descending on the right edge. | process-learnings #76 | Beneath, the Well, the Rite | The depth state is felt, not read. Phase transitions of a rite trigger the burst. | Particle system. | energy |
| 17 | **Karishma windows / silence as grace**: quiet regions (strict E<0.1 ≥1 s, loose E<0.2 ≥1.5 s) as authored "grace" moments; silence footprint %. | data files `quiet_regions_*`; abide `KARISHMA_WINDOWS` | performances, the Rite, Recognition | During silence windows the inverse-gain law lifts the carrier, Karishma's final bloom fires, and the two Recognition lines could appear only inside a silence (never on a peak). | Per-track quiet windows (present). | energy |
| 18 | **Mirror times (tension anchors)** `{t, tension}` | abide-data.json MIRROR_TIMES | the Relationship Field, Her Presence | At authored tension moments the mirror system flips (the dance's mirror). This could cue the Relationship Field's two-sided view. Only abide has them authored. | Authored per-track; null elsewhere. | energy |
| 19 | **Phase Labels as Time markers** (`{t, name, sub}`: one word, lowercase and bodily, plus a lyric fragment). | Airtable fldQq0ON (34 rows); deep-dive STEP 7 | Time, the Rite, performances | While a track plays, the current phase word is shown quietly (e.g. "exile → descent → recognition → home → return"). The inventory in Time can show which phases a person lingered in. **Song phase labels are inert in the Field iOS app (S9 #116), so this is unbuilt anywhere in Swift.** | Parse JS-array (song) and paragraph (breath) formats; both exist. | energy (words are from lyrics, verbatim) |
| 20 | **Consciousness Loop as the Rite's skeleton**: settling → focus → offering (seed typed at BPM) → dance → revelation (word reveal at peak_t, "bottom 15%", "i_love_you_at peak_t − 3") → integration/fruit (dwell-based weave). | next-horizons H1; assemble*.py consciousness_loop; Airtable cross Score `fruit.weaves` | Today/the Rite, Recognition | The Rite runs: seed phrase types at the track's BPM → dance → at peak the person's word is revealed at the bottom 15 % → the fruit text chosen by dwell time (cross: "dwell < 1.5s" → "You didn't hesitate."). The write is an App Activity "Ceremony Sealed" (field_connection marks it `implemented:false`, so it is designed but unbuilt). | Seed phrases (59, Airtable), the cross weave table, an App Activity type. **Note: "nothing scores him".** A dwell-based weave is a reflection, not a score, but check it against that floor. | energy |
| 21 | **Monroe Focus-level map ↔ chakras** (Focus 10 Anahata/Ajna, 15 Sahasrara, 21 Aatma, 22–27 Maya). | next-horizons:53 | the Climb (Axis), the 33 | A depth ladder alongside the Axis: each Climb tier carries its Focus number and beat state. | Mapping table. (Flagged as a "question to hold", not a ruling.) | energy |
| 22 | **Koshas as concentric shells; nadis as lines; bija seeds** (LAM VAM RAM YAM HAM OM silence). | next-horizons H2 | Beneath, the nine rings (shells), Her Home | The koshas map naturally onto the yantra's enclosures (5 sheaths ↔ rings). Ida/pingala map to the L/R binaural channels: hard-pan left = ida/lunar, right = pingala/solar, and the beat = sushumna. Bījas only verbatim (ruling: nothing invented). | Bija mapping is traditional, not invented, but confirm against the app's bīja law. | energy |
| 23 | **Long arcs: 40-day, lunar and seasonal ceremonies; element ceremonies; whole-spine sushumna arc.** | next-horizons H3 | Time, the Modes, the Climb | Time holds a 40-day arc. Each day's Rite carrier steps up the spine (Muladhara 146.8 → … → Maya 116.5). Lunar phase selects the beat. | Calendar, day-thread. | energy |
| 24 | **Duo / paired sessions ("one in each ear")** | next-horizons H4 | the Relationship Field (ruling 10) | Two people: one hears the carrier left, the other the carrier+beat right. The beat exists only between them, "in the shared field". A literal sonic image of relationship. | Multi-device sync (SharePlay) — large. | energy |
| 25 | **Biometric/HRV-responsive beat; resonance finder (5→6.5 bpm)** | next-horizons H4; breath 109 cohere phases | the Modes, Today | The Coherent-breath "finder" (0–4 min at 5, 5.5, 6, 6.5 breaths/min) finds the person's number. Optional HealthKit HRV drives gain. | HealthKit; privacy floor. | energy |
| 26 | **Journey/long set as a Time bed** (59-min mix, fixed carrier) | assemble4.py journey flag | Time, Beneath | "best used as a long ambient/journey bed with a fixed carrier". Could be a long-dwell background for Time or the Well. | Audio hosting (not hosted, copyright). | energy |
| 27 | **Header pip / scored-state grammar**: scored = pip plus red tint; unscored dimmed to 45 %; no fallback tone for the unscored. | S4 #57–58 | The 33 grid, the Mandala's 102 seats | Seats with sound assigned show a bindu pip; seats without stay silent. **No generic fallback tone**, which matches "nothing invented". | Flag per seat. | energy |

### B3 · Readings (energy-tier and story-tier)

| # | Gift | Source | World(s) | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 28 | **Three-layer reading UI**: Lalita first → "what the ensemble hears" toggle → seven lenses in page language (One Word, Need, What Holds, Frequency, Shape, Grace, Recognition), each with its colour (red, green, gold, blue, silver, rose, gold). | process-learnings #36–38; lalita-protocol:135 | Her Home (a Śakti's room reading), the 33 rooms | Progressive disclosure with two toggles. The seven lens colours give a ready palette for the archetypes in the dance. | Lens texts per Śakti. For songs they exist (44 rows); for Śaktis they would have to be written, and "nothing invented" means they need authoring by Ashrey/Claude under rule 7-like sanction. | **story → Bindu Feed** (prose readings are story-class under ruling 5; keep only the lens *names and colours* as structure) |
| 29 | **Recognition Statement** (one-sentence complete seeing, pinned above the tabs) | Airtable fldFW1HE; S9 #125 | the 33, Today | One line pinned at the top of a chakra room when its track plays. | 44 rows exist. | story-leaning (flag for Feed); the breath ones are energy/science |
| 30 | **Reading Space four tabs WORDS / FREQUENCY / VIDEO / LALITA** | S9 #118 | the 33 room for a track | A tabbed reading. VIDEO is empty everywhere. | Airtable fields exist. | story → Bindu Feed |
| 31 | **Seed phrases (59) as the day's question** | Airtable fldyFZy2 | Today/the Rite, the Well | Today shows one seed (from the track joined to today's chakra). It types at BPM in the Rite. Breath seeds are lowercase declarations ("you are larger than you remember"). | Verbatim, present. | energy (a single line, an invitation) |
| 32 | **Breath Lalita library** ("The library opened with Come Home… closes here… Goodnight.") | Airtable fldMzPP rows 101–111 | the Modes (Breath), the Rite close at night | The breath library is ordered: Come Home first, Night Protocol last. A night-mode close could end on the sleep session's last line. | Verbatim text. | energy-practice text (keep in app) |
| 33 | **Bindu Feed story links per track** (45 rows → tbl7vzODMMJUgeX0b) | fldbLpx57LJoYXlwu | the Relationship Field, Memory | Flag: these already join songs to Feed stories. The Mandala could show "a story lives here" as a door to Bindu Feed rather than holding the story. | Link only. | story → Bindu Feed (already there) |
| 34 | **Sonar Ears at 33** (231 lenses as a constellation; the 2.69 Hz pattern as a signal thread) | process-learnings #32, #89 | the 33 (the braid), Beneath | The 33-chakra constellation in the Mandala could light up one star per scored track until 33, then the "ear" activates. | Count of scored tracks (46 drafted, ~25 fully read). | energy (structure) |
| 35 | **Arc names as one-line shapes** ("Two fires with one breath between them", "Three breaths of increasing fullness…") | deep-dive STEP 1 | the nine rings (each ring's "shape" caption) | Use as the sonic-shape caption of each element arc in B1 #4. | Verbatim lines. | energy |

### B4 · Data pipeline gifts

| # | Gift | Source | World(s) | Mechanism | Needs | E/S |
|---|---|---|---|---|---|---|
| 36 | **The 10-stream frame data (0.5 s)** for 47 tracks as a ready performance substrate | scores/*-data.json | performances, Her Presence, Time | Bundle the data JSON (20–430 KB each) with the app or fetch it. `E, EB, EM, EH, T, ED, H, DROPS, quiet regions` drive visuals in sync with playback time. File weight is no gate (his ruling). | Audio hosting gate: 13 Run-3 + 9 Run-1 + in shadow/kingdom + 9 chakra spine hosted; Run 4 is not. | energy |
| 37 | **ScoreValidator (21 rules)** as the schema law for any Mandala sound arc | validate.py | engine/QA | Port the rules to a Swift unit test for any `MandalaScore`: ordered phases, final beat until=null, **no Hz in resonance_link** (separating sound from the Śakti identity layer). | Test target. | energy |
| 38 | **resonance_link: chakra ↔ Mandala.Subtle Body Chakra join; `shaktis: []` and `writes_recognition` flags** | assemble2.py:126–127 | the 33 ↔ Śakti seats | Already designed as "Real join Bindu Field.Chakra -> Mandala.Subtle Body Chakra". This is the bridge for sound per Śakti: a Śakti seat → its subtle-body chakra → that chakra's track/carrier. `writes_recognition` lets a Field ceremony write a Recognition to the Mandala. | Populate `shaktis` (empty everywhere). | energy |
| 40 | **Planetary (Cousto) carrier set: 136.1 OM/Earth-year, 194.18 Earth-day, 221.23 Venus, 256 C, 60, 80 Hz**, plus the "Akash library" name | Airtable Frequency rows 101–111; Words 102/103/105/108 | Home (136.1 as the Bindu's own tone: "the tone of return"), the Modes, Time (Earth-year and Earth-day tones for year and day cycles), Beneath (60 Hz floor) | A non-song tone set that already exists with stated derivations. It fits the Mandala, which has no songs. Home = 136.1 Hz "home frequency"; the day thread = 194.18 (Earth day); Time's year view = 136.1 (Earth year); a Venus 221.23 tone for expansion; night = 60 Hz/1.5 Hz. The SCIENCE/TRADITION honesty frame comes with it. | Values verbatim; no derivation work needed. | energy |
| 41 | **BINDU one-word per track / per breath** (here, Already, Waking, Higher, Up, Release, Current, Rest, Feel, Ground, Flow, RECEIVED, OPEN, WE, HOME, DISSOLVE, Before, Within, Sovereign, Enough, Still, Delight, Instinct, Surrender, Presence; Down, Even, Resonance, Clear, Heat, Release, Empty, Wide, Home, Ocean, Sleep) | Airtable Field Reading BINDU lens | Today (one word of the day), the Rite word-reveal, the 33 | A single authored word per sound. Shown at the moment of the peak or the word reveal, or as the room's breath-word. Not invented. | Verbatim lifts. | energy (single word) |
| 42 | **Breath SID/KARISHMA structural pairs** (the constant and the pause) | Field Reading rows 101–111 | the Modes (Breath), the Rite's breath opening | The UI marks the pause that is the grace: e.g. Empty Pause highlights the hold-empty wall; the Stoke highlights the post-round pause; Ocean highlights "the turn". This gives each breath animation one emphasised moment. | Map per technique. | energy |
| 43 | **Safety gate as gift** ("the one door in the library with a gate, and the gate is part of the gift") | Lalita row 105; spec "SCREENED" | the Modes | The Bhastrika-type session shows a contraindication screen before opening, framed as a door, not a warning. | Gate screen; `fld0aC2B` open/screened flag. | energy |
| 44 | **Library ordering as a night/day arc** (Come Home opens, Night Protocol closes; "Goodnight. The body knows the way from here.") | Lalita 101/111 | Time (evening), the Rite close | Time's evening state offers the closing breath. The last line is shown verbatim at the end. | Verbatim. | energy |
| 39 | **Analysis scripts for any new audio Ashrey adds** (e.g. a temple recording, a bell) | analyze_tone / temporal / deep_analysis | the Well (sounds he brings), Her Home | Run on any recording to find its absent fifth and give it a carrier. Stereo check: corr >0.95 means safe to add binaural. | Offline Python (not on device). | energy |

---

## C · Conflicts and gaps

1. **Data-file identity mismatches.**
   - `ember-data.json` is Experience/Einaudi (= still-ajna), not Sit Around The Fire. The Track 1 data is effectively missing; the md5 matches.
   - The `play` and `thunderclouds` data duplicate each other.
   - 12 files have empty song/artist/verb.
2. **Carrier disagreements between Airtable and process-learnings.**
   - before (33) Airtable 136 vs learnings "revised to A2 · 110.0 Hz".
   - purity (34) Airtable 136 vs learnings B2 123.5.
   - hold/Aatma: Airtable and batch say G2 98, but process-learnings S7 #84 says "The Aatma carrier is the absent ROOT of C major (C3 · 130.8 Hz)" and the Recognition Statement says 130.8 Hz. **The batch draft overwrote an authored carrier.**
   - Kingdom: learnings #47 says carrier D3 146.8 (root exception); assemble5 and Airtable say A2 110. The Recognition Statement for kingdom still says "146.8 Hz the home note".
   - Ajna (28): learnings Recognition says "the binaural holds at delta", but the Airtable state is alpha 8.5.
   - These matter if the Mandala inherits carriers by chakra: Aatma (130.8 vs 98) and Kingdom must be ruled.
3. **Element/Category select pollution.** The Element choices include lowercase category names and "Threshold". The Brainwave choices include element names. The Chakra choices include brainwave names. Field 37 levelup has a 2.69 beat and no element.
4. **4-7-8 stored wrong.** Row 106 rest has counts Inhale 4 / Hold 2 / Exhale 12, but the spec says 4:7:8:0. Row 108 expand stored 5/5/5 vs spec 8:4:8. Row 102 balance stored 5/0/5 vs Box 5:5:5:5. Row 103 open stored 4/2/6 vs 4:0:8. **The breath counts in the number fields do not match the technique specs.** A Mandala Breath mode must read the spec, or the counts need fixing (not mine to fix).
5. **Field Score JSON is not consumed** by the Field iOS app (`Score.forTrack` hardcoded to cross). Song Phase Labels are inert. `app_activity "Ceremony Sealed"` is `implemented:false`. Everything in B2 #19–20 is designed but unbuilt in Swift.
6. **"No generated voice" vs Horizon voice questions.** next-horizons repeatedly asks whether to add voice (Monroe, bija). Ol3 voice is off by default. Bija sessions would require *his* sung voice or recordings, not generated voice. It stays consistent if recorded.
7. **"Nothing scores him" vs the Consciousness Loop fruit.** The dwell-based weaves ("You didn't hesitate.") read behaviour back to the person. They are a reflection, not a score, but they sit near the floor. Rule before porting.
8. **"This app is energies, not stories."** Lalita, the Field Readings, Words, Frequency and Recognition are prose about songs. Most of it is story-tier, so flag it for Bindu Feed, which already links 45 tracks to Feed stories. Energy-tier keepers: carriers, beats, arcs, phase words, seeds, breath specs.
9. **Ruling 6 (every archetype named in the dance) vs the Field translation discipline** ("Remove all proper nouns from the-field" on the page). In the Mandala the dance *names* the archetypes. The Field's page rule does not carry over; this is a deliberate difference.
10. **Vishuddha gap.** "Vishuddha has no reading yet — there's no Ether track" (site-v3) vs the catalog: speak/27 is Vishuddha but its element is Air. The site and the catalog disagree on where speak stands.
11. **No Śakti-level sound exists anywhere.** `resonance_link.shaktis` is empty in all 46 Scores. Sound per Śakti must be designed fresh: by ring, by subtle-body chakra (the join exists), or by element. Inventing per-Śakti Hz would breach "nothing invented" unless derived by a stated rule (e.g. the ring's chakra carrier).
12. **Audio hosting/copyright.** The 11 Run-4 commercial tracks, cross and return are unhosted. Any Mandala performance on those songs is gated.
13. **P stream dead** in 46 files. The "bindu = pitch" dancer has no live data and must be re-extracted or derived.
15. **Kingdom's role and Ajna's state disagree within Airtable itself.**
    - Kingdom: the Field Reading and Frequency texts say the carrier is D3 146.8 (absent root). The Carrier Hz field says 110, and so does the Score JSON (A2 absent fifth, "fifth held by the law"). The prose and the number now contradict each other on the same row. The same pattern holds for hold/Aatma (prose 130.8, field 98) and before (prose 110, field 136).
    - Ajna: the Recognition Statement says delta and the isochronic pulse is 1.1/1.7 Hz delta, but the row's state is alpha 8.5.
16. **Breath Lalita and Words are long-form and practice-tier; song Lalitas are story-tier.** They belong in different apps under ruling 5. The breath texts can live in the Mandala's Modes; song readings belong in Bindu Feed.
17. **Private material inside readings.** purity (Shweta) and levelup (Rey, a past-life arc) carry family and personal content. Treat it as private and story-tier. Do not surface it in the Mandala without his word.
18. **Empty fields.** `fldDgr3aUQJSheIJp` (likely Video Pulse Reading), `fldQ8MM9hCe6rARuZ` and `fldUlWDvSkeHpx80x` are empty on all 60 rows. The two link fields to `tblJlBeiHnqGpYrL7` are empty. The Mandala-side join implied by `resonance_link` ("Bindu Field.Chakra -> Mandala.Subtle Body Chakra") exists only as a select-value match, not as a link field.
14. **Peak reliability.** Most batch peaks are flagged needs_listening (still 182/342, light 80.5/200, numb 149.5/90, fade 171.5/240, trace 85.5/210, crash 91.5/178, believe 123/178). Any Mandala event anchored to a peak (word reveal, crown bloom) inherits this uncertainty.

---

## D · Coverage proof

| file | total lines (wc -l) | lines read | method | md5 (8) |
|---|---|---|---|---|
| `scores/abide-data-fresh.json` | 0 (single-line JSON, 29783 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | fb30d154 |
| `scores/abide-data.json` | 0 (single-line JSON, 32694 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 6ff4c56c |
| `scores/ache-data.json` | 0 (single-line JSON, 23591 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | fd6e0570 |
| `scores/ascend-data.json` | 0 (single-line JSON, 33229 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 90db15ac |
| `scores/believe-data.json` | 0 (single-line JSON, 32533 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | fb6cb665 |
| `scores/brave-data.json` | 0 (single-line JSON, 36912 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 336bae5c |
| `scores/build-data.json` | 0 (single-line JSON, 28557 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 1605396d |
| `scores/cherish-data.json` | 0 (single-line JSON, 26004 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 5ef9c09e |
| `scores/confront-data.json` | 0 (single-line JSON, 22937 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 3c864ce5 |
| `scores/crash-data.json` | 0 (single-line JSON, 30659 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | c399dd6e |
| `scores/crave-data.json` | 0 (single-line JSON, 33418 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 1d1f593f |
| `scores/cross-data.json` | 0 (single-line JSON, 30894 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 5633de94 |
| `scores/dissolve-data.json` | 0 (single-line JSON, 26823 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 50da7e1e |
| `scores/dream-data.json` | 0 (single-line JSON, 43210 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 3e09138b |
| `scores/ember-data.json` | 0 (single-line JSON, 39407 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | d8895b4a |
| `scores/enough-data.json` | 0 (single-line JSON, 26659 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | dce9640e |
| `scores/fade-data.json` | 0 (single-line JSON, 35897 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 8ddb5345 |
| `scores/follow-data.json` | 0 (single-line JSON, 33315 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 134333e2 |
| `scores/glow-data.json` | 0 (single-line JSON, 32681 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 5b493930 |
| `scores/ground-data.json` | 0 (single-line JSON, 28466 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 056888f0 |
| `scores/hold-data.json` | 0 (single-line JSON, 37067 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 7c809721 |
| `scores/howl-data.json` | 0 (single-line JSON, 43782 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 8a892ad9 |
| `scores/inshadow-data.json` | 0 (single-line JSON, 95502 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 9d37d475 |
| `scores/journey-data.json` | 0 (single-line JSON, 431731 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 67f3eaea |
| `scores/kingdom-data.json` | 0 (single-line JSON, 89411 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | b3a7aa09 |
| `scores/lift-data.json` | 0 (single-line JSON, 27582 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 45437c3b |
| `scores/light-data.json` | 0 (single-line JSON, 34875 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 415c1f0b |
| `scores/lose-data.json` | 0 (single-line JSON, 31783 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 008c9bb9 |
| `scores/melt-data.json` | 0 (single-line JSON, 36965 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | a9af5e70 |
| `scores/miss-data.json` | 0 (single-line JSON, 43701 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 0906a50d |
| `scores/move-data.json` | 0 (single-line JSON, 28018 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | be85151e |
| `scores/numb-data.json` | 0 (single-line JSON, 36149 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 43ba6896 |
| `scores/open-data.json` | 0 (single-line JSON, 32546 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 72d535b6 |
| `scores/play-data.json` | 0 (single-line JSON, 27641 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 8c2a04fd |
| `scores/press-data.json` | 0 (single-line JSON, 27831 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | d09d3d2d |
| `scores/receive-data.json` | 0 (single-line JSON, 27058 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 4bf2e5a1 |
| `scores/release-data.json` | 0 (single-line JSON, 34895 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | a37ad395 |
| `scores/remember-data.json` | 0 (single-line JSON, 23294 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 96354f94 |
| `scores/return-data.json` | 0 (single-line JSON, 29364 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 236d42a4 |
| `scores/rise-data.json` | 0 (single-line JSON, 61650 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 164ca923 |
| `scores/search-data.json` | 0 (single-line JSON, 28303 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | f76fa851 |
| `scores/speak-data.json` | 0 (single-line JSON, 32045 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 3f7bdaf6 |
| `scores/still-ajna-data.json` | 0 (single-line JSON, 39407 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | d8895b4a |
| `scores/thunderclouds-data.json` | 0 (single-line JSON, 27640 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 7d706e50 |
| `scores/trace-data.json` | 0 (single-line JSON, 34856 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 1fa34204 |
| `scores/unfold-data.json` | 0 (single-line JSON, 64228 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | cd089117 |
| `scores/wake-data.json` | 0 (single-line JSON, 29821 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 619643d0 |
| `scores/want-data.json` | 0 (single-line JSON, 27696 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 9b0eb8b3 |
| `scores/wild-data.json` | 0 (single-line JSON, 27413 bytes) | whole file | structural `python3 -I`: every key, type, length, numeric range/mean; every string and every quiet/drop/top8 list printed in full | 8d0080ea |
| `scripts/analyze_tone.py` | 216 | 1–216 | Read tool, full | 1f9bfd59 |
| `scripts/deep_analysis.py` | 209 | 1–209 | Read tool, full | 6e1ce821 |
| `scripts/temporal_analysis.py` | 227 | 1–227 | Read tool, full | 43aaea6a |
| `scripts/batch/README.md` | 19 | 1–19 | Read tool, full | 1dea6254 |
| `scripts/batch/assemble.py` | 255 | 1–255 | Read tool, full | 12b2fed9 |
| `scripts/batch/assemble2.py` | 148 | 1–148 | Read tool, full | ec5dd791 |
| `scripts/batch/assemble3.py` | 131 | 1–131 | Read tool, full | dc68ff9e |
| `scripts/batch/assemble4.py` | 139 | 1–139 | Read tool, full | 76c126c6 |
| `scripts/batch/assemble5.py` | 111 | 1–111 | Read tool, full | 7e1f24d2 |
| `scripts/batch/make_report.py` | 169 | 1–169 | Read tool, full | dfc57bd4 |
| `scripts/batch/validate.py` | 104 | 1–104 | Read tool, full | 3dfa4086 |
| `references/batch-scoring/BATCH-SCORING-STATE.md` | 47 | 1–47 | Read tool, full | 7ccb2329 |
| `references/deep-dive-protocol.md` | 276 | 1–276 | Read tool, full | 27fd4e51 |
| `references/instrumental-protocol.md` | 118 | 1–118 | Read tool, full | 51ea1aa9 |
| `references/lalita-protocol.md` | 135 | 1–135 | Read tool, full | 286dcedb |
| `references/next-horizons.md` | 172 | 1–172 | Read tool, full | 30aad97f |
| `references/process-learnings.md` | 499 | 1–499 | Read tool, full | 25147031 |
| `references/reading-examples.md` | 99 | 1–99 | Read tool, full | 4152b77f |
| `references/site-v3.md` | 15 | 1–15 | Read tool, full | 207173c3 |
| Airtable `tblv3WvMZ90Sfhun6` schema | — | all 38 fields | `get_table_schema` (IDs/types/choices) | — |
| Airtable `tblv3WvMZ90Sfhun6` records (60/60, one page, totalRecordCount 60) → scratch `bf.json` (900,595 chars) | — | all records | `list_records_for_table` pageSize 100; short fields printed per record by python | 8bf53e35 |
| ↳ Phase Labels (scratch phase.txt) | 337 | 1–337 | Read, full | 9808be9a |
| ↳ Recognition Statement (recog.txt) | 132 | 1–132 | Read, full | ec6143f5 |
| ↳ Lalita's Perspective (lalita.txt) | 574 | 1–574 | Read, full (2 pages) | 21cbb6a3 |
| ↳ Lyrical Words (words.txt) | 272 | 1–272 | Read, full (2 pages) | 15d7e87f |
| ↳ Frequency (frequency.txt) | 206 | 1–206 | Read, full (2 pages) | 1a0a4d28 |
| ↳ Field Reading (fieldreading.txt) | 994 | 1–994 | Read, full (3 pages) | 0cf72304 |
| ↳ Seed phrase, breath spec, links (fldyFZy2, fld6ex1, fldbLpx5) | — | all rows | printed in full by python | — |
| ↳ Score JSON `fldxIm6qUXLcdrRuR` (46 rows, 423K chars) | — | all 46 parsed | **structural**: parsed as JSON and deep-diffed against `scores/*.score.json` (12 EQUAL; the rest differ by ASCII punctuation and audio_data.meta trimming; journey has re-picked silence windows; cross 38 is the authored score with no local track-id match). Not read line by line; the `*.score.json` files are outside this assignment | — |

Notes on coverage: the `*-data.json` files are single-line JSON (wc −l = 0), so they were read structurally as the brief allows. Everything else assigned was read line 1 to the end with the Read tool. Nothing was modified outside this file. Airtable access was read-only.

---

## Return message

File: `waves/register/10-field-data-catalog.md`. The ten most valuable gifts:

1. **An absent-fifth carrier per ring or Śakti.** A fixed carrier with a moving beat and gain, derived from the ring's chakra (B1 #1, #38). The resonance_link join already exists.
2. **The inverse gain law** `base + 0.025·(1−E)` and the gain ranges (0.003–0.050; HOME ≤0.040 for meditate) (B1 #2).
3. **The planetary tone set from the breath library.** 136.1 OM/Earth-year as Home, 194.18 Earth-day for the day thread, 221.23 Venus, 60 and 80 Hz floors. Usable without songs (B4 #40).
4. **The seven-dancer ensemble mapped to data streams.** Bindu=pitch, Gaia=bass, Sid=sustained, Arch=mids, Karishma=silence-inverse, Sakshi=brightness, Ashrey=web. Generation order, then reverse dissolution. This is ruling 6 ready-made (B2 #13).
5. **The dancing Bindu.** A Lissajous orbit on energy and beat Hz, beat rings, a 28-point comet trail, and a pulse at beat Hz with a 200 ms floor (B2 #15, B1 #7).
6. **The five-stage bloom ending in a crown mandala.** The yantra itself can be stage 5 (B2 #14).
7. **The Consciousness Loop as the Rite's skeleton.** The seed types at BPM, the word is revealed at the peak, the fruit is chosen by dwell. The App Activity "Ceremony Sealed" write is designed but unbuilt (B2 #20).
8. **Eleven complete breath sessions for the Modes.** Ratios, carriers and beats, phase labels, a safety gate, animation modes, and seed lines (B1 #11, B4 #42–44).
9. **Element arc shapes as envelopes for the four elements and the nine rings.** Earth descends once; Water three waves; Fire two blazes with a breath; Air three inhales; Light twice; Soul twice through silences; Maya one breath (B1 #4).
10. **Seams and drones that never go to zero, and the 2.69 Hz void phase.** These give sonic continuity for crossings through the point and a designed beat for the deep zoom into the Bindu and Beneath (B1 #5, #6).

Flagged for Bindu Feed: the song Lalitas, Field Readings, Words and Recognitions. 45 rows already link to Feed stories. Flagged private: the purity and levelup material. Key conflicts:
- `ember-data.json` is Experience, not Sit Around The Fire.
- The Aatma, Kingdom and Genesis carriers differ between the prose and the numbers.
- The breath count fields do not match the specs.
- No Śakti-level sound exists anywhere yet.

