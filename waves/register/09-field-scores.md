# 09 · Field Scores — the Score format and every Score in `bindu-field`

Reader 09 · second reading · 12 Oct 2026
Skill root: `/root/.claude/skills/synced/12004d20-…/bindu-field/` (abbreviated `BF/` below)
Assignment: every `scores/*.score.json` (48 files: 3 authored + 45 batch drafts), `references/score-format-v2.md`, `references/song-registry.md`, `references/content-registry.md`, `SKILL.md`. I also read `scores/README.md` (60 lines) because it is the index to the scores folder. The `*-data.json` files were **not** read (another reader has them).

Lens: a Score is a time-coded, multi-track experience design (sound, light, motion, words, binaural carriers, haptics, memory writes). Bindu Mandala wants performances and interactions per Śakti and per chakra. This file lists everything the Scores hold and proposes how the format and particular Scores could run inside the app's worlds.

---

## A · Inventory

### A.1 `SKILL.md` (context: the Bindu Field app the Scores were made for)

- **App:** `com.bindufield.Bindu-Field`, iOS 17+, SwiftUI + AVAudioEngine + a C++ DSP kernel behind an ObjC++ bridge. The catalog is Airtable ASG base `app248ZTWhYJlvQj2`, table `tblv3WvMZ90Sfhun6`, view `viwFst2hAYxv3ifQZ` (SKILL.md:21-26, 228-230).
- **8 tabs** (SKILL.md:32-41): MAP (a 33-chakra Tree of Life, the front door) · FIELD (22 orbs coloured by element, tap to play) · ORACLE (a 4-state listening void) · SPACE (chakra breath protocols) · LAB (carrier, beat and presets) · ARCHIVE (sessions plus Integration Chamber notes) · RITUAL (chained chakra sessions) · LETTER (voice recordings over binaural).
- **Audio engines, settled ("DO NOT MODIFY")** (SKILL.md:63-71): `BinauralEngine` (L/R sine with exponential glide), `BinauralListener` (music plus DSP tap), `BinduDSP` (RMS, spectral centroid, flux, onset), `AudioSessionCoordinator`, and `UIBackgroundModes=[audio]`.
- **DSPWireService** polls at 10 Hz. Inverse RMS sets engine gain. It also handles `userBeatHz` override and `currentCarrierHz` (SKILL.md:76). The principle "carrier derives from the song at 10s (DSP override)" is at SKILL.md:525.
- **Player** (SKILL.md:88-108) has three modes: FIELD, CONTROL and READING.
  - FIELD: Verb at 62pt Lora italic light in the element colour; Recognition Statement at 13pt and opacity 0.12; a 2pt "flowing" scrubber; a BINAURAL pill; swipe down to close.
  - CONTROL: a 56pt play circle, a PRESENCE slider, a BEAT Hz slider, a CARRIER display. It auto-hides after 4s.
  - READING: four tabs, WORDS · FREQUENCY · VIDEO · LALITA.
- **Element vocabularies** (SKILL.md:117-128):
  - earth: amber ground, seismic cracks, dust
  - water: interference ripples, flow lines
  - fire: embers, solar rings, triangle
  - airGlyph: Gothic arches
  - ether: standing sine bands, vocal mirror pair
  - constellation (Light/Ajna): star field and connection lines
  - crown: 12-petal lotus, ascending particles
  - soul (Aatma): dual triangles, near-total stillness, **14s breath**
  - dissolution (Maya): **64 veil particles forming and dissolving on a 9s cycle**
  - ambient (Meditate/Family): a minimal breathing void
  - Special case: Track 27 routes to `.ether` (SKILL.md:130).
- **Performer state machine** (SKILL.md:135-157). It tracks `elapsed`, `currentPhase` (silence/intro/build/peak/descent/outro), `crescendoModulator` 0→1, `energy`, and `beatPulse` (spike on onset, 6/s decay). `archetypePresence` sets each archetype:

  | Archetype | Presence rule |
  |---|---|
  | Bindu | always 1.0 |
  | Gaia | ramps in over 4s |
  | Sid | drone pulse, 5.5s cycle |
  | Arch | energy × 1.5 |
  | Karishma | inverse energy |
  | Sakshi | steady 0.6 |
  | Ashrey | grows with crescendo |
  | Shweta | fires only at t=160–162s |
  | Neev | t<4s and the last 2s |
  | Lalita | arrives after t=204s |

  The only Score in the app is `Score.cross` (Track 27, 268s). `Score.forTrack(id:)` returns nil for 21 of 22 tracks, which gives ambient mode.
- **Cathedral tiers** (Air/Ether only) (SKILL.md:160-165):
  - T1: floor radials, Sid columns, vault, grain, Gaia ground
  - T2 (energy > 0.1): Arch chant arc, Sakshi witness
  - T3 (crescendo > 0): rising arches, convergence
  - T4 (crescendo > 0.25): keystone cascade, Earth rising, **Shweta crystallization (22 shards)**
- **Map** (SKILL.md:171-186). Nine composed dances: Sahasrara, Ajna, Vishuddha, Anahata, Manipura, Svadhisthana, Muladhara, Maya, Aatma. The other 24 nodes are locked, drawn as 2.5pt dim dots. Node states:
  - `danced`: orbit rings
  - `available`: breathing glow
  - `locked`: dim cream dot
  - `current`: maximum intensity

  Tapping a node opens a sheet with the name in 28pt Lora italic, the Sanskrit, the essence and a CTA.
- **Oracle** (SKILL.md:192-202): idle → typing → waiting → response. Idle shows fog on a 14s cycle and the label at 2.2s. The response shows the Verb at 72pt at 0.4s, the track at 2.2s, the "why" at 3.4s and the CTAs at 5.6s. It uses the Claude Haiku API (SKILL.md:82).
- **Consciousness Loop** (SKILL.md:208-224): `preRoll → seed → offering → dance → reveal → fruit → lalita → done`.
  - preRoll: breath ring on a 5.5s smoothstep
  - seed: 28pt serif italic
  - offering: one word, no input chrome, 38pt in the element hue
  - dance: a mirror word flashes every 2.8s at 56–68pt
  - reveal: the offered word at 84pt with a two-shadow glow
  - fruit: three paragraphs from `lyricalWordsReading`
  - lalita: a closing line from `lalitasPerspective`

  The music keeps playing under the Loop.
- **Airtable field IDs** (SKILL.md:236-261):

  | Field | ID |
  |---|---|
  | Name | fldoA70yegZzQL7BV |
  | Track ID | fldimw5ZGOBg0j738 |
  | Verb | fldrYExLmEjx4wxVt |
  | Song Title | fldSgcALwlkQPWDz4 |
  | Artist | fldizqVJeRT2s10NG |
  | Track Type | flds07pkQlTwXLTWw |
  | Element | fldC5nZ1vH1nclfhe |
  | Brainwave State | fldFD9rYNEP69UEqp |
  | **Chakra** | **fld6pH3kGSqqop2Z7** |
  | Audio URL | fldUIY8v9p49QyF0B |
  | YouTube ID | flduzjO1YmMdv7x9v |
  | Carrier Hz | fld4oIQGckv2c9DvO |
  | Beat Hz | fld7oCYy1eIWdhE04 |
  | Seed Phrase | fldyFZy2hzFXTM52K |
  | Recognition Statement | fldFW1HEDvfC4gOJy |
  | Lyrical Words Reading | fldWtIXuWNoQQaGuN |
  | Frequency Reading | fldjQfTIklHtOa8a4 |
  | Video Pulse Reading | fldDgr3aUQJSheIJp |
  | Summary | fld6ex1l6b5LOIJro |
  | Lalita's Perspective | fldMzPPCfWRwYpss5 |
  | Field Reading | fldcXUpENSGaoenRK |
  | Phase Labels | fldQq0ONvyoD5NuhS |
  | Step 9 Verified | fldbSnJQo2tJ8ZSt1 |
  | Analysis Complete | fldNZuKRNfUDrp9QP |
  | **Score JSON** | **fldxIm6qUXLcdrRuR** |
  | **Audio Data URL** | **fldUlWDvSkeHpx80x** |
  | **Score Status** | **fldOSMHwD7IxshwO7** (Unscored · Drafted · Verified) |

  Score JSON, Audio Data URL and Score Status are listed at SKILL.md:234 and 385-389.
- **Content state and corrections** (SKILL.md:263-289): 14 songs scored, 11 breath sessions, cross is Track 38 `recmLDCDcmA5r4CJt` (element **Threshold**). "27 dances exist… The app knows about roughly one" (SKILL.md:287).
- **Three-layer architecture** (SKILL.md:331-339) and the **authored/extracted boundary**: "Cross's extraction reports peak energy at 138.0s. Cross ships PEAK_T = 160" (SKILL.md:346-348).
- **12-step protocol** (SKILL.md:396-401): `0 THE WORD → 1 EXTRACT → 2 LISTEN → 3 DISCOVER → 4 METAPHOR → 5 COMPOSE → 6 VALIDATE → 7 WRITE → 8 BUILD → 9 REINFORCE → 10 DEBUG → 11 OFFER → 12 REGISTER`. Steps 1, 6 and 7 are scripts.
- **Breath Field Reading**, seven lenses adapted to breath (SKILL.md:428-436):
  - BINDU: the one word the breath orbits
  - GAIA: the need
  - SID: the ratio, retention or carrier
  - ARCH: the mechanism
  - SAKSHI: the temporal shape
  - KARISHMA: the grace in the pause
  - ASHREY: "the experiencer activates the field"
- **Phase Labels parser** (SKILL.md:440-453): a plain string, blank-line paragraphs, `HEAD — body` with an em-dash. Breath rows only. Song phase labels are inert.
- **2.69 Hz consciousness-awakening pattern** (SKILL.md:480-485). It appears in five songs: Kingdom · Sound of Silence · Golden · Aatma · Maya. The arc it traces: *"See what you're inside → speak what was given in silence → build the field together → hold at the edge of death → let it dissolve."*
- **Design language** (SKILL.md:491-506):
  - Void `#020208`
  - TEXT `rgba(245,226,214,1.0)`; MUTED 0.55; SUBTLE 0.28; FAINT 0.12
  - Lora italic 300 for emotional text; -apple-system uppercase with tracking 1.5–2.2 for labels; DM Mono light for numbers
  - Two-shadow glow: `.shadow(c.opacity(0.28), r 24).shadow(c.opacity(0.10), r 50)`
  - Sheets: `rgba(5,5,16,0.97)`
- **Principles** (SKILL.md:523-532), verbatim: *"The binaural is the ground the music was standing on without sounding it."* · *"Drone endings — binaural doesn't fade to zero when music ends."* · *"The Map remembers where you've been — danced chakras gain orbit rings."* · *"The Oracle is already listening before you open it."* · *"Sound → Ground → Recognition → Home."*

### A.2 `references/score-format-v2.md` (the Score contract)

- **Why v2** (lines 10-31): v1 hardcoded the cathedral. v2 changes ten things:
  1. `metaphor` plus six functional tiers
  2. tiers 0 and 5 added
  3. three layers declared
  4. the Twelve Discoveries become the spine
  5. `carrier.derivation`
  6. the authored/extracted boundary
  7. `bloom`, `spatial_memory` and `return`
  8. `personal_offering`
  9. `field_connection`
  10. `resonance_link`, described as the "Honest chakra-level bridge to the Mandala app" (line 31)
- **Three layers** (35-68):
  1. Universal substrate, in code: Dancer class, 7 instances, bloom S1–S4, onset, mirror, wake lock, `SC()`, pools, fruit overlay, word reveal, fade-to-black.
  2. The Score, in Airtable: the Twelve Discoveries as data.
  3. Vocabulary module, per song, in code, around 23 tier systems.

  Rule at line 66: identical every song → Layer 1; differs but expressible as values → Layer 2; only expressible as drawing code → Layer 3.
- **24 sections** (72-106). Nine are required (108): identity, config, anchors, phases, silence_windows, binaural, consciousness_loop, return, field_connection.
- **Section contracts** (112-672):
  - `identity`: `category` is chakra or ensemble.
  - `reading`: prose lives in Airtable.
  - `metaphor`: name, vocabulary_module, one_line, elements, palette with `forbidden`. Line 177: *"Let the song tell you."*
  - `config`: bindu_hue, dark_ratio, peak_t, return_start, bpm, hit_threshold, hit_count, frame_interval.
  - `anchors`: peak_t with value, extracted, authored and reason.
  - `phases`: 3–12. Phase names fade in Cinzel over 3.4s (227).
  - `silence_windows` and `silence_footprint_pct` (Karishma's domain).
  - `bloom`: 5 stages, rise 0.06, fall 0.012, thresholds .15/.3/.5/.7, systems dot · ghost trail · orbital rings · radial rays + particles · crown mandala. *"Rises fast, falls slow."*
  - `ensemble`: the 7 dancers with hue, base_r, orbit_r, max_ghost and the stream each reads. Roles are universal; hues are a discovery (279).
  - `spatial_memory`: a canvas grid of 25×35. `karishma_decay` 0.0005 is the freeze, *"nothing fades while the body is held in stillness"* (297). Known maps: Threshold Field, warmth, fracture, echo, burn.
  - `path`, with the **blend law** `finalPos = freqPos × (1 − blend) + shapePos × blend`. *"The breath shakes the pen. Only the Return may reach 1.0."* (314-320)
  - `geometry`: a `why` is required.
  - `shape_choreography`: arc · heart · infinity · spiral · circle · flower. Triggers are seconds, `peak`, `return`, `phase:n` or `silence:n`.
  - `mirror_system`: 16 consonant-skeleton families × 5 words. *"The mirror is a light event, not a dot"* (374).
  - `binaural`: carrier with derivation in {absent_fifth, absent_root, present_root, imposed} and confidence in {confirmed, review, unresolved}; beat_schedule; `designed:true` for placed frequencies; inverse gain `base + 0.025*(1-songEnergy)` with phase multipliers; Karishma freeze; spatial pan hard L/R; `gyro_tilt_to_pan` 0.011.
  - `consciousness_loop`: seed with `{name}` variant, typed at bpm; word_reveal at peak_t, bottom 15%, `i_love_you_at` peak_t−3; fruit core plus conditional weaves.
  - `return`: reverse generation order, Karishma's final bloom, Bindu spiral to the centre dot. `adaptive:true` means *"music and person find the ending together"* (477).
  - `tiers` t0–t5 (479-539): each entry is a *name pointing into the vocabulary module*. global_boost 0.8 is the reinforced value.
  - `haptics`: Core Haptics on iOS. A missing peak haptic is "a smell".
  - `voice_triggers`: OL-3.
  - `optional_layers`: pink noise; pre-roll text *"Breathe with the silence. The song begins when you do."*; voice.
  - `field_connection`: pools essence/memory/being plus `app_activity` {source_app Field, activity_type Ceremony Sealed} bridging to `tblJlBeiHnqGpYrL7`.
  - `cross_dance`: leitmotifs and constellation_visibility.
  - **`resonance_link`** (617-637): the join `Bindu Field.Chakra → Mandala.Subtle Body Chakra`. Line 633: *"The 102 Shaktis carry bija syllables, not Hz values. No Score may assign a Hz to a Shakti."* `writes_recognition:true` would log `Shakti Recognized`; it is "provisioned, never yet fired". Line 637: *"Do not fill this to be thorough."*
  - `personal_offering`: one addition, about 30 lines, marked in code.
  - `audio_data_ref`: 10 streams, H E B P T EB EM EH ED DROPS, framed at 0.5s and read through `SC()`.
- **Boundary** (677-696): extract.py produces the streams. PEAK_T, PHASES, KARISHMA_WINDOWS and MIRROR_TIMES are "a listening act".
- **Validator, 20 rules** (700-731). Rule 16: `resonance_link` must contain no Hz, "Hard failure". Advisory rules: boost < 0.7, no peak haptic, and peak not authored.
- **Storage** (752-765): Score JSON multilineText (~12–18 KB, ceiling 100,000 chars), Audio Data URL, Score Status, and a `Metaphor` singleLineText. The Score is live-tunable: *"edit the JSON in Airtable, and the next fetch performs differently. No rebuild."*
- **Appendix A** (800-821): rule 20 nuance, and the `review_before_build` array.
- **Appendix B** (826-863): Step 0 THE WORD, `karishma_measure` (silence | groundlessness), and **subtractive designed events** (`binaural.carrier_dropout`). Verbatim: *"The extraction does not tell you what a song **is**. It tells you what a song **does**. The Word tells you what the doing **means**."* (842-843)

### A.3 `references/song-registry.md`

- **Energy spine, 9/9 complete** (14-24):

  | # | Chakra | Verb | Song (Artist) |
  |---|---|---|---|
  | 1 | Muladhara | press | Iron (Woodkid) |
  | 2 | Svadhisthana | follow | Crystallize (Lindsey Stirling) |
  | 3 | Manipura | build | Powerful (Major Lazer & Ellie Goulding ft. Tarrus Riley) |
  | 4 | Anahata | open | Love Me Like You Do (Ellie Goulding) |
  | 5 | Vishuddha | speak | The Sound of Silence (Disturbed) |
  | 6 | Ajna | still | Experience (Einaudi) |
  | 7 | Sahasrara | receive | Golden (HUNTR/X) |
  | 8 | Aatma | hold | Aatma (Chase Hughes) |
  | 9 | Maya | dissolve | Love Is the Only Thing (Lost Frequencies) |

  Audio files are `<chakra>.mp3`.
- **24 standalone music slots**, all "TBD" (28-54). The verbs are search, still, dream, lose, rise, light, glow, melt, howl, wild, release, move, remember, enough, ground, trace, believe, ache, crash, fade, play, earn, numb, stay. Separately, `before` = Genesis (Justice) is complete.
- **Meditate** (71-74): `in shadow` (In Shadow — A Modern Odyssey, Lubomir Arsov 2017) and `kingdom` (Lubomir Arsov 2018).
- **Family** (80-85): *"The verb is their essential nature, activated as seed."* Shweta = `purity` (Where'd You Go + Thunderclouds). Rey = `levelup` (Levels + Beautiful Now).
- **Sonar Ears threshold** (89-93): 33 complete songs × 7 lenses = **231 lens readings**. Pattern recognition across them activates the **Sonar Ears Chakra**, *"the ear that hears the meta-song beneath the songs."*
- **Wake Me Up** (113-126): D major 0.882. Carrier is **D3 146.8 Hz, the absent root**. 2.69 Hz is found twice (bass 109 Hz and A4 440). Isochronic pulses at 1.3/1.7/1.9/2.8/3.1 Hz.

### A.4 `references/content-registry.md`

- Record IDs for the 9 spine rows, Tracks 23–31 (27-35):

  | Track | Chakra | Record ID |
  |---|---|---|
  | 23 | Muladhara | `recNK3tCuTLE5Rz6P` |
  | 24 | Svadhisthana | `recegUJduJtuhYiOQ` |
  | 25 | Manipura | `recRIm8zafWgFqaWK` |
  | 26 | Anahata | `rec4qQlcaQn4UbQbC` |
  | 27 | Vishuddha | `recBOIwQ8lA5kXq0K` |
  | 28 | Ajna | `rec3TqcK3UNBbqIxz` |
  | 29 | Sahasrara | `reco0eTHN2z04pMkC` |
  | 30 | Aatma | `recY83LPPQAA6B2Ns` |
  | 31 | Maya | `recqdWGGUFiux2KVe` |

  All have reading fields filled except Video Pulse. Phase labels are inert.
- Other rows: Genesis `recfTj5FG9d0dihAw`; In Shadow 35 `recuAkqFs86MWSevH`; Kingdom 36 `recj43pRhrGo644pM`; purity 34 `recDgRNNWN4NidJuv`; levelup `recYqGHG4sYRJDOSP`.
- **11 breath sessions** (75-87):

  | # | Verb | Name | Technique | Record ID |
  |---|---|---|---|---|
  | 101 | ground | Come Home | Diaphragmatic 4:8 | `rec7sR8aqptY7uQpe` |
  | 102 | balance | The Even Breath | Box 5:5:5:5 | `rechUbF8gHsuu51PS` |
  | 103 | open | The Hum | Bhramari | `recsi52JcIgBbDRZA` |
  | 104 | clarify | The Counted Exhale | Susokukan | `recyhgZSwsPVEZA0R` |
  | 105 | activate | The Stoke | Bhastrika, SCREENED | `recKE2cq3dwPTkYoS` |
  | 106 | rest | The Long Release | 4-7-8 | `recMeuavySskl60n6` |
  | 107 | dissolve | The Empty Pause | Bahya kumbhaka | `recAfXRujKb2C3NAS` |
  | 108 | expand | The Thinning Breath | 8:4:8 | `reca2ZsfcgKobscb6` |
  | 109 | cohere | Home Frequency | ~6 bpm | `recLSSOozJbHKm702` |
  | 110 | sound | The Ocean Breath | Ujjayi | `recA1b1fTg6cL1ijB` |
  | 111 | sleep | The Night Protocol | Cyclic sighing | `recYKA8lnBVzPkvPF` |

  **BINDU one-words** (87): *Down · Even · Resonance · Clear · Heat · Release · Empty · Wide · Home · Ocean · Sleep*.
- **Design-side unbuilt** (106-110):
  - **Mixer**: sets Left Hz and Right Hz directly, beat = |L−R|.
  - Lab redesign.
  - Archive breath-vs-chakra typing bug.
  - Four breath fields hardcoded in Swift: hue, oneLine, carrierTiers, beatTiers.
- **Nine "seed-only" tracks with web dances** (143-153). The seeds are verbatim in A.10.
- **Open questions** (159-187): carrier law resolved; designed vs discovered 2.69 open; silence footprint open; peak_t extraction not reproducible; analyze_tone is a diagnostic.
- **Scores authored** (193-205): cross (transcribed backward, Track 38), abide (composed forward), thunderclouds (composed from the Word, seed authored by Ashrey; *"The double reading … is the composition and must not be 'clarified.'"*).

### A.5 `scores/README.md`

- Three authored Scores, three directions: cross was transcribed backward, abide composed forward, thunderclouds composed from the Word.
- Carrier-law table.
- Peak instability on Time: 162.0 · 169.5/170.0 · 177.5 · 184.5.
- **Innovations to carry forward** (README:54-60): `karishma_measure`, subtractive designed events, *"The unshaped peak … `mode: none`. No shape at the moment the song is about not steering."*, and 2.69 held back.

### A.6 `cross.score.json` — Ameno (Scott Rill Remix), ERA · 230.09s · ensemble · metaphor **cathedral**

Authored score, transcribed from the shipped `cross.html` (3488 lines, 2026-05-09) (cross:21).

**Identity, reading and metaphor**
- Element **threshold** (cross:28). Recognition statement: *"A song that pretends to be a club track while actually being a delivery vehicle for the sacred. The form is contemporary; the function is ancient."* (cross:25)
- Arc: *"two reaches across a held cathedral, with bells"* (cross:27).
- Metaphor `cathedral-v1`, *"A held sacred architecture the body crosses under."* (cross:35-37). Elements: cathedral floor, sid columns, vault ceiling, rising arches, keystone, bells, embers, procession lights, chant haze, atmospheric grain.
- Palette: primary hue 260–285, accent 35–50. Forbidden: turquoise, ocean blue, foam white. *"Violet 270 is cross's register and cross's alone."* (cross:50-64)

**Config and anchors**
- bindu_hue 270, dark 0.45, **peak_t 160** (extracted 138.0), return_start 15, bpm 107.7, beat_ms 557.1, hits 387 at 0.35, 462 frames (cross:68-80).
- Anchor reason: *"The machine found the loudest moment; the listening found the meaningful one."* (cross:87)

**Timeline**
- Phases (cross:95-138): Opening 0–30 · First Reach 30–75 · Descent 75–100 · Threshold Valley 100–145 · The Crossing 145–200 · Bells in the Dimness 200–228 · Return 228–230.09.
- Silences (cross:139-165): 0–4.5 · 7.5–9.5 (held breath) · 45.5–47 · **100–130 threshold valley** · 205.5–210 (*"the silence that lets the bells be heard"*). Footprint 18.5% (the spec's 13% is not reproducible) (cross:166-167).

**Ensemble and memory**
- Ensemble hues (cross:197-254): Bindu 270 (r7, ghost 60) · Gaia 25 · Sid 40 · Arch 330 · Karishma 45 · Sakshi 220 · Ashrey dynamic. These are inherited from muladhara.
- The anahata palette differs: gaia 340, sid 320, arch 350, karishma 280, sakshi 310 (cross:256).
- Leitmotifs (cross:257-263):
  - Sakshi: *"the unmade gesture"*
  - Karishma: *"silence-bloom"*
  - Sid: columns, lingers longest
  - **Shweta: "clarity crystallization at peak_t"**
  - **Neev: "threshold bookends — ground-marks at the first 2s and last 1s"**
- Spatial memory **Threshold Field** (cross:265-283): grid 25×35, return_decay 0.0015, hue 270 sat 35. *"footsteps in snow the drone is dissolving"*. Why not the other maps: *"Crossing leaves footprints, not heat."*

**Path and geometry**
- Path and shapes (cross:284-412): rest → arc (30s, dur 45, plateau 3, blend 0.6, r 0.5, side −1) → drift (Karishma 0.85) → arc (145s, plateau 20, blend 0.85, r 0.6, side +1) → rest → spiral (return, 15s, ramp 3, blend 1.0, r 0.4, inverting).
- Geometry **Two Rising Arches** (cross:337-384): appears at S3. Left (0,0.8)→(0.35,0.3), right (1,0.8)→(0.65,0.3). Stroke hsl(270,30,60). Alpha `0.10+0.05*sin(t*0.18)`. Apex 160–180. *"Not petals. Cross is a cathedral, not a flower."*

**Mirror words**
- Times 25/70/115/160/210, 1.8s per word (cross:413-428).
- **16 threshold-kindred families**, verbatim (cross:430-543): cr cross carry cradle cleave crown · br bridge bear bring breath beyond · th thread threshold through thrum thrive · pr pass pray prayer presence promise · rs rise rest resolve return reveal · st step stand stay stir still · tr trust trace transit transform traverse · cl climb claim close clear call · gr ground grasp give grace grow · hr hold hear heal heave here · lv love leave lift live lend · rn run reach return rinse ripen · sh show shed shift share shine · fl flow fall fold free find · wn want wake wind wonder wait · mn mind mend meet move mean.
- Triggers: tension through zero → darkness 0.4; surge after silence → 0.6. Post-mirror boost 0.4.

**Binaural**
- Carrier **110 Hz A2**, absent_fifth of D, detected G, held by Sid, confidence review (cross:558-567).
- Beat schedule (cross:569-648):

  | Until (s) | Hz | State | Note |
  |---|---|---|---|
  | 25 | 8 | alpha | |
  | 75 | 7 | | |
  | 100 | 7.5 | | |
  | 130 | 5 | deep theta, the held wait | |
  | 145 | 5.5 | | |
  | 161 | 4.5 | | |
  | 164 | **7.83** | Schumann | designed |
  | 166 | **2.69** | awakening | designed |
  | 180 | 4.5 | | |
  | 200 | 6 | | |
  | 228 | 7→9 | ramp | |
  | end | 10 | | |

- Gain multipliers: ×1.3 at 161–166, ×1.2 at 145–180, ×0.8 at 200–230. Final ramp 3s. Karishma freezes the beat in silences and in the valley (cross:650-690).

**Consciousness Loop**
- Seed *"What is asking to be crossed in you?"*, 557 ms per character (cross:699-704). Why: *"The walker is not asked what they want to cross — they are asked what is asking of them to be crossed."*
- Fruit core, verbatim (cross:712): *"You gave this song "{word}". "{word}" reached and fell back. You waited inside the threshold together. "{word}" reached again, and the bells rang to say it had crossed. / You weren't crossing "{word}". "{word}" was already crossing through you."*
- 11 weaves (cross:714-758):
  - dwell <1.5s *"You didn't hesitate."* / 1.5–5s *"You paused before speaking."* / >5s *"You searched for the word before you could say it."*
  - motion still / swaying / moving
  - crossings 0 / 1 / n
  - echo word *"You keep returning to "{echo}."*
  - prior dance *"The last word that crossed through you was "{prev_word}" — that was {prev_song} ({prev_verb})."*

**Return and tiers**
- **Bells Return** (cross:769-815). Fades: ashrey at 15s, sakshi 13, arch 11, gaia 9, sid 7 (×0.4, lingering), karishma blooms 5→3 at 1.0 then fades, bindu fades from 2 and spirals to the centre dot.
- Tier functions (cross:816-988):
  - t0: `drawNeevGround`
  - t1: SidColumns, GaiaGradient, VaultCeiling, `getThresholdHSL` violet→gold→indigo, grain
  - t2: ReachHistory, ProcessionLights, ResonanceZones, ChantHaze, ConfigurationMembrane
  - t3: RisingArches 3→5, ConvergenceLines, UnmadeGesture (10s echo), KarishmaSilenceBloom
  - t4 145–195: SchumannCharge (chromatic aberration, 161–166), EarthRising, KeystoneCascade (16 rays), ShwetaClarity (alpha 0.10, 2s), KeystoneRings, boost `1+intensity*0.8`
  - t5: BellFootprints (8s), ValleyHeartbeat (100–130 at 50 bpm), **`fireLalitaConstellation` with the line "You have been one of the dancers"** (cross:978), Embers drifting down

**Haptics, voice and memory writes**
- Haptics (cross:990-1031): crossing_peak `[12,40,12,40,12,60,30,12,40]` *"footsteps crossing the threshold"* · bell `[20,30,40,30,20]` scaled by hit (after 200s, hit ≥0.6, ambient E ≤0.35, life 4.5s) · mirror `[8]`.
- Voice triggers `lalita-cross-1..4.mp3` at −1/110/165/215, volume 0.55. Not recorded (cross:1033-1063).
- Field connection (cross:1078-1134):
  - memory pushEvent `ensemble-dance` {song, artist, verb, word, dwellMs, motion}
  - being pushBeingEntry `{second_word}`
  - keys `cross-last-word`, `cross-last-at`
  - `app_activity` Field / Ceremony Sealed, implemented false
  - integrity rules
- Constellation visibility 0.30 at climax, 0.55 at return (cross:1148-1151). resonance_link is empty on purpose (cross:1154-1161).

**Personal offering and audio**
- **The Word's Star** (cross:1162-1177): the user's word placed at a hash-deterministic `wordToPosition()`. Alpha 0.06 + 0.10·bloom + 0.30·shweta, present from the first frame. *"Same word offered again on another day gives the same star in the same place."*
- Meta (cross:1196-1243): bands 24/44/31; drops at 170.0, 187.5, 218.0, 220.5, all after the apex (*"The crossing is a sustain, not an impact."*); top impacts 53.8, 146.82, 74.16, 135.81.

### A.7 `abide.score.json` — Time (Alan Walker Remix), Hans Zimmer & Alan Walker · 211.3s · ensemble · metaphor **wave**

Composed forward. abide.html was never built (abide:23).

**Identity, reading and metaphor**
- Verb rationale: *"abiding in reveal-space… The 21-second held silence at 122–143s is a test of abiding, not endurance."* (abide:24)
- Recognition: *"A wave that returns to the deep and comes back larger — not because it pushed harder, but because it returned."* (abide:27). Seed: *"What in you doesn't need to arrive?"* (abide:28)
- Metaphor `wave-v1` with 17 elements (abide:41-59): the deep, tidal pull, sky above water, wave-fronts, surface tension, foam-procession, bow-wave, surface coherence, undertow, spray, shore-rising, surface-shimmer, glassine clarity, water-marks, deep pulse, wave-archive, foam dissolution.
- Palette: primary 220–235, secondary 180–200, gold 35–45 **only in 168–180**. Forbidden: violet, pure white, gold outside the peak (abide:60-83).

**Config and anchors**
- bindu_hue 235 (indigo, *"the hue of dusk and recognition"*). Derived colours: label hsl(235,28%,78%), sub (235,24,68), dot (235,75,65), glow (235,65,55), love (235,35,88).
- peak 170.0, bpm 129.2, hits 525 at 0.12, 423 frames (abide:87-116).
- Peak instability recorded: archived 170.0 vs fresh 184.5, with maxima at 162.0/.953, 162.5/.997, 170/1.0, 177.5/.988, 184.5/.96 (abide:118-161). Peak position 80.5% (abide:163-164).

**Timeline**
- **9 phases** (abide:171-226): The Held Breath 0–28.5 · First Whispers 28.5–60 · The First Build 60–120 · **The Breaking 122–143** · Re-emergence 143–158 · The Bridge 158–170 · Recognition 170–180 · Settling 180–196 · The Returning Silence 196–211.3.
- **14 silences**, 40.8% footprint. Karishma may dominate (abide:227-302). The fulcrum: *"THE FULCRUM — 21 seconds. The wave returned to the deep. Where the song teaches abiding."* (abide:276)
- Two-bloom architecture, first at 110, second at 170. *"Bloom must be allowed to FALL through the fulcrum."* (abide:321-327)

**Ensemble**
- Hues (abide:339-389): Bindu 235 · Gaia 200 · Sid 222 · Arch 190 · **Karishma 40 (the only warm one)** · Sakshi 210.
- Leitmotifs (abide:393-399): Karishma *"undertow"*; Sakshi *"the unmade wave"* (dotted 60–120, flare 168–174, 12s echo); Sid *"the deep"*; Gaia *"tidal pull"*; Neev *"first ripple"*.
- Spatial memory **Ocean Field**: *"Water does not hold a mark; it holds a movement."* (abide:401-414)

**Path and geometry**
- Path (abide:415-493):
  - infinity at 5s (dur 23, blend 0.6, r 0.18, `speed_scale none`)
  - infinity at 124s (dur 19, blend 0.7, r 0.22): *"refusing to be moved by the silence"*
  - **heart at 170s** (dur 10, blend 0.85, r 0.32, speed 1.6): *"patient love"*
  - spiral return (r 0.35, inverted)
  - Six phases are free. *"The two infinities … trace what doesn't end, in the two places where the song has stopped."* (abide:495)
- Geometry **Five-Stage Wave-Fronts**, breaking window 168–174 (abide:496-512).

**Mirror words**
- Times 4.0/26.5/**191.5**/199.0. 191.5 is the highest tension in the whole song and falls in near-silence (abide:551-569).
- 16 **abiding-kindred** families (abide:572-685): bd abide bide abode bedded bound · wt wait want weight without watch · st stay still stand steady stone · hl hold held whole heal hollow · rm remain remember room rhythm roam · rt rest root return rooted righted · dp deep depth deepen dip drop · gt gather gate guard gift grant · br breathe bear break bring brim · sw swell sway swim sweep swallow · fl flow fall full fill float · tr trust true tide tread trace · wv wave weave waver woven weather · ls listen last loosen lessen linger · cm come calm climb claim become · nr near nearer nurture narrow endure.

**Binaural**
- Carrier 110 A2, absent fifth of D, **confirmed**. Presence 0.32; D2 root 0.64. Sub-harmonic table at 73.4/110/146.8/220 (abide:702-743).
- Beat schedule, 13 steps (abide:745-829):

  | Until (s) | Hz | Note |
  |---|---|---|
  | 28.5 | 8 | |
  | 60 | 7.5 | |
  | 110 | 7 | |
  | 122 | 6 | |
  | 130 | 4.5 | |
  | 134 | **7.83** | Schumann inside the fulcrum, designed |
  | 143 | 4.5 | |
  | 158 | 5 | |
  | 170 | 4.5 | |
  | 180 | **4.0** | delta border at Recognition |
  | 196 | 6 | |
  | 208 | 7.5→10 | ramp |
  | end | 10 | |

- Composition notes (abide:832-835): *"The binaural's deepest state belongs at the awakening peak"*; *"Time's teaching is the return to the deep, so Earth belongs in the held silence"*; no 2.69.
- Gain ×1.3 in the fulcrum, ×1.2 at 168–180, ×0.8 at 196–211.3 (abide:842-868).

**Consciousness Loop**
- Seed typed at 464 ms per character. Pre-roll is required (abide:886-894).
- Fruit (abide:902): *"You gave this song "{word}". / {word} wasn't going to arrive — {word} was waiting in you. / The silence was where you heard it."*
- Weaves include *"You held {word} for {n} seconds before offering it. That holding was the dance."* and *"You stayed still through the silence. The song stayed with you."* Motion is sampled only in the **fulcrum** 122–143 (abide:903-944).

**Return, tiers and haptics**
- **The Returning Deep**: strict reverse order ashrey, sakshi, arch, sid, gaia, karishma, bindu (abide:948-965).
- Tiers with z-values (abide:966-1144):
  - t0 first ripple
  - t1 the deep (z1.5), tidal pull, sky (3 shafts), ocean colours, spray grain (8 particles in silence)
  - t2 wave-rider's path, foam-procession (holds state in silence), surface tension (thin lines), bow-wave (asymmetric), surface coherence
  - t3 wave-fronts, curved convergence currents, unmade wave, undertow
  - t4 167–180: surface-shimmer (caustics, 167–173), shore-rising gold, spray radiation (20 rays + 30 droplets), glassine clarity 0.10, wave-front rings, boost 0.8. *"EIGHT systems peak simultaneously at 170–175s. The person cannot take it all in. That is correct."*
  - t5 water-marks (after 180, 10s), deep pulse (122–143 at 50 bpm), wave-archive, foam dissolution
- Haptics: fulcrum_pulse `[30]` at 50 bpm *"the deep's own heartbeat, felt not seen"*; wave_crash; mirror. No peak haptic (gap) (abide:1146-1180).

**Memory writes and personal offering**
- Optional layers: pink noise gain 0.015, *"Hemi-Sync ground hum"* (abide:1185-1188).
- New event kind `bindu-dance-completed` and being context `post-bindu-dance` (abide:1208-1245).
- Personal offering is open. Candidates: The Word's Wave, The Returning Foam, The Tide-Mark (abide:1280-1301).
- `review_before_build` has 9 items (abide:1342-1352).

### A.8 `thunderclouds.score.json` — Thunderclouds (Lost Frequencies Remix), LSD (Labrinth, Sia, Diplo) · 198.51s · ensemble · metaphor **weather**

Composed from the Word.

**Identity, reading and metaphor**
- The verb is a phenomenon, not an action (thunderclouds:24). Rationale: *"Clouds that are all thunder and lightning with no rain — yet still produce rainbows when you let the fear pass."* (thunderclouds:25). Deliberately unlinked from purity (Track 34) and `play` (#25) (thunderclouds:26).
- Recognition: *"A storm that is all discharge and no fall. The thunder is real, the lightning is real, and nothing lands."* (thunderclouds:30). Arc: *"no ground for forty-seven seconds, then a ground, then the ground vanishing at the brightest instant — and nothing falls"* (thunderclouds:33).
- Metaphor `weather-v1`, *"Charge that builds, discharges completely, and leaves the ground dry."* (thunderclouds:41-61). Elements: the charged field, cloud-body, the dry floor, pressure gradient, static veins, the strike, the flash-void, afterimage, rolling front, charge accumulation, the open door, residual charge.
- Palette: hue 258 at saturation 12–28; strike 268 at 70–95; ground 40. **"NO RAINBOW ANYWHERE IN THE DANCE"** (thunderclouds:59).

**Config, anchors and Karishma**
- peak 141.5 (extraction and listening agree), return_start 11, bpm 123, hits 387 at 0.45, E minor 0.825, opening E 0.067 vs closing 0.007 (thunderclouds:63-92).
- **karishma_ruling** (thunderclouds:102-110): Karishma reads bass absence (EB<0.10 for ≥1s), giving 11 windows and 63.5s = 32.0%. *"ruled by Ashrey"*.

**Timeline**
- **9 phases** (thunderclouds:112-122): No Ground 0–47.5 · The Floor 47.5–60 · Weather 60–110 · The Lull 110–120 · The Gathering 120–140 (68 hits) · **The Strike 140–141.5** · Nothing Fell 141.5–155 · Dancing In It 155–187.5 · The Charge Left 187.5–198.51.
- Bloom is driven from EH, not E, during the strike (thunderclouds:149-153).

**Ensemble and memory**
- Hues (thunderclouds:159-165): Bindu 258 · **Gaia 40** (absent for the first 47s; *"she arrives"*) · Sid 250 · Arch 285 (*"the two voices"*) · Karishma 55, reading `1-EB` · Sakshi 200.
- Leitmotifs (thunderclouds:174-181): *"the dry floor … It is never wet."*, static veins, the unmade strike.
- **Charge Field** accumulates rather than decays. At 141.5 it drops to 0.05 in one frame, then rebuilds (thunderclouds:184-195).

**Path and geometry**
- Path (thunderclouds:197-206):
  - No Ground: drifts high in the frame
  - Lull: circle at 110 (blend 0.55)
  - **Strike: mode `none`**, *"a hand on the wheel at the one moment the song is about not steering"*
  - Nothing Fell: heart at 141.5 (ramp 0.5, blend 0.80)
  - spiral at return (11s)
- Geometry **Branching Static**, *"a reaching that mostly does not arrive"* (thunderclouds:211-220).

**Mirror words**
- Times 14/47/84.5/140.5/191. The 140.5 mirror is a darkening that reveals the word (thunderclouds:229-265).
- 16 noun→verb families (thunderclouds:241-258): th thunder threat throw thrash thaw · st storm static strike stir stay · cl cloud clench clear climb calm · lt lightning light lighten lift let · ch charge chance change choose chase · gr ground grip grow grant greet · rn rain reach remain return run · fl flash flood flow fall free · pr pressure press pass promise prove · br break brace breathe brighten bear · wn wind want wait wonder widen · sk sky shake seek settle soften · dr drought dry draw drift dare · bl blaze blow blur bloom believe · ht heat hurt hold hear heal · ps pause push part pour pass.

**Binaural**
- Carrier **123.5 B2**, absent fifth of E, presence 0.68. *"THE CARRIER IS THE RAIN"* (thunderclouds:270-289).
- Beat schedule (thunderclouds:291-304): 8.5 · 8 · 7 · 6.5 · 7.5 · 5.5 · **null (carrier void)** · 4.0 delta at Nothing Fell · 4.5 · 5.5 · 6.5→9 · 10.
- **carrier_dropout** 140.0–141.5 (thunderclouds:305-313): both oscillators ramp to zero over 0.35s, stay silent to 141.15, then ramp back by 141.5. *"First subtractive designed event in the constellation."*
- Gain ×1.15 at 0–47.5, ×1.25 at 141.5–155, ×0.8 after 191.

**Consciousness Loop**
- Seed by Ashrey: *"What are you afraid of that will never pass?"*. *"Do not 'clarify' this seed."* (thunderclouds:342-351)
- Fruit (thunderclouds:360): *""{word}" was thunder. "{word}" was lightning. / Nothing fell. / The question asked what you're afraid of that will never pass. / It meant: never come to pass. / You were standing under it the whole time."*
- Weaves include *"The floor went out at the brightest moment and you didn't move."* Motion is sampled only during the 1.5s strike (thunderclouds:362-373).

**Return, tiers and haptics**
- Return: tension **rises** (+0.36, +0.53, +0.67). *"The storm leaves and the charge stays."* (thunderclouds:386)
- Tiers (thunderclouds:389-441):
  - t1: static veins, the dry floor (present from frame one), cloud-body
  - t2: rolling front; *"potential difference"*, where brightness scales with the distance between figures
  - t3: branching static, seeking branches, unmade strike, dry floor brightening
  - t4 138–155: **the flash-void**, where the canvas goes near-white and everything else drops to near-zero alpha (*"the single hardest thing in this build"*); the floor holding; discharge flare (20 filaments); afterimage at alpha 0.12 for 2.5s; boost **0.9**
  - t5: persistent marks **"scorch-none" deliberately empty**; dry-floor pulse at **46 bpm** in the *opening*; residual charge
- Haptics (thunderclouds:443-452): the_strike `[8,20,8,400]` *"the crack, then nothing falling"* · charge_pulse `[25]` at 46 bpm in 0–47.5 · thunder_roll `[30,40,50,40,30]` after 141.5 · mirror `[8]`.
- Constellation visibility drops to **0.05** during the strike (thunderclouds:487-488).

### A.9 The batch-draft template (common to all 45 drafts)

Every draft has the same shape. The line numbers below are from `rise.score.json`; the others match within a few lines.

- `composed_by "Claude (batch draft, Cowork)"`, dated 2026-08-31. Only steps 1, 6 and 7 are done (rise:19-22).
- `recognition_statement`, `arc_shape` and `metaphor.name` are **null**. Note: *"Never defaulted to cathedral."*
- Anchors: peak_t is `needs_listening:true` unless lifted from a shipped HTML. Each draft carries `registry_authored_peak` and `near_equal_maxima`.
- Phases are a placeholder skeleton: Opening 0–30 (or about 11% of the peak) · Build → peak · Peak = peak+20 · Return.
- Silences are `quiet_regions_loose` (E<0.2, ≥1.5s), copied as-is.
- Bloom uses universal defaults.
- Ensemble roles are filled but **hues are null** (*"Do not invent."*).
- spatial_memory, path, geometry, shape_choreography, mirror_system, tiers, haptics, voice_triggers, cross_dance and personal_offering are all **null**.
- Carrier is absent_fifth, read off analyze_tone's KEY (Krumhansl-Schmuckler), with the prescription ignored.
- Beat is a **single placeholder**. Its value comes from the BPM heuristic or the catalog Brainwave State; for kingdom and inshadow it is the authored catalog beat. No 2.69 is placed.
- The return list is `ashrey, sakshi, karishma, arch, sid, gaia, bindu`, Karishma's final bloom, and a spiral to the dot.
- field_connection pushes `ensemble-dance` for music and meditate, and **`chakra-dance` with a `chakra` field** for the nine chakra drafts.
- resonance_link is filled for the nine chakra drafts (basis `chakra`, shaktis []). It is empty for all others.
- `audio_data.meta` holds bands, hits, drop_count, opening_e and closing_e. Some drafts also carry `quiet_regions_strict` and `top8_impacts`.
- Groups:
  - **Run 1**: the nine web-dance migrations — search, ember, dream, rise, light, howl, release, ground, numb.
  - **Run 2**: the nine chakra drafts.
  - **Uncatalogued batch**: Tracks 39–52, new rows — return, enough, remember, move, wild, melt, glow, lose, fade, trace, believe, ache, crash, play.
  - **Incorporation**: Tracks 53–63, new rows, seeds authored at the time — lift, wake, brave, ascend, unfold, crave, want, confront, miss, cherish, journey.
  - **Meditate**: kingdom, inshadow.

### A.10 Every Score at a glance

Key: Pk = peak_t used · Ex = extracted loudest · Reg = registry-authored web-dance peak · Sil = silence footprint % · Car = carrier Hz (absent fifth of the key) · Pres = carrier presence (lower = more absent) · Beat = placeholder beat Hz/state · Host = mp3 hosted at aistrangegame.com/bindu/ per the Score.

| Score | Song — Artist | Dur s | Track · rec | Cat · Chakra · Element | Hue | Pk / Ex / Reg | BPM | Sil | Car · key (conf) · Pres | Beat | Host | Seed (verbatim) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **cross** | Ameno (Scott Rill Remix) — ERA | 230 | 38 · recmLDCDcmA5r4CJt (catalog; score ids null) | ensemble · — · threshold | 270 | 160 / 138 | 107.7 | 18.5 | 110 A2 · D · — | 12-step | ✗ | What is asking to be crossed in you? |
| **abide** | Time (Alan Walker Remix) — Zimmer, Walker | 211 | — | ensemble · — · wave | 235 | 170 / unstable | 129.2 | 40.8 | 110 A2 · D maj (.815) · .32 | 13-step | ✗ | What in you doesn't need to arrive? |
| **thunderclouds** | Thunderclouds (LF Remix) — LSD | 199 | — | ensemble · — · weather | 258 | 141.5 / 141.5 | 123 | 32.0 (groundless) | 123.5 B2 · E min (.825) · .68 | 12-step + dropout | ✗ | What are you afraid of that will never pass? |
| press | Iron — Woodkid | 202 | 23 · recNK3tCuTLE5Rz6P | chakra · **Muladhara** · Earth | 12 (dark 1.0) | 188 / 98 (shipped) | 129.2 | 0.0 | 146.8 · G min (.778) · .27 | 2.5 δ | — | You don't remember how you got here. |
| follow | Crystallize — Lindsey Stirling | 259 | 24 · recegUJduJtuhYiOQ | chakra · **Svadhisthana** · Water | 210 | 39.5 / 39.5 | 69.8 | 3.1 | 146.8 · G maj (.758) · .15 | 4 θ | — | This song has no words. Neither did you, once. |
| build | Powerful — Major Lazer & Ellie Goulding | 206 | 25 · recRIm8zafWgFqaWK | chakra · **Manipura** · Fire | 25 | 33.5 / 33.5 | 99.4 | 7.3 | 164.8 · A maj (.732) · .26 | 4 θ | — | You think this song is about another person. |
| open | Love Me Like You Do — Ellie Goulding | 249 | 26 · rec4qQlcaQn4UbQbC | chakra · **Anahata** · Air | 330 (dark .55) | 234 / 214.5 (shipped) | 95.7 | 14.0 | 155.6 · G# maj (.71) · .34 | 6 θα | — | This is the only song that talks to you. |
| speak | The Sound of Silence — Disturbed | 262 | 27 · recBOIwQ8lA5kXq0K | chakra · **Vishuddha** · Air | 185 | 251.5 / 251.5 | 172.3 | 15.6 | 138.6 · F# min (.862) · .60 (was 192) | 8 α | — | Everything you're about to hear, you already know. |
| still-ajna | Experience — Ludovico Einaudi | 316 | 28 · rec3TqcK3UNBbqIxz | chakra · **Ajna** · Light | 50 | 256.5 / 256.5 | 92.3 | 18.9 | 138.6 · F# min (.819) · .32 (was 110) | 8 α | — | This song has no words. It doesn't need them. |
| receive | Golden — HUNTR/X | 192 | 29 · reco0eTHN2z04pMkC | chakra · **Sahasrara** · Crown | 280 | 22.5 / 22.5 | 123 | 17.7 | 146.8 · G maj (.693) · .19 (was 240) | 8 α | — | You've been hiding. |
| hold | Aatma — Chase Hughes | 282 | 30 · recY83LPPQAA6B2Ns | chakra · **Aatma** · Soul | 265 | 170.5 / 170.5 | 123 | 25.5 | 98.0 · C maj (.839) · .40 (was 136) | 2.5 δ | — | Made by a brain that reorganized itself. |
| dissolve | Love Is the Only Thing — Lost Frequencies | 184 | 31 · recqdWGGUFiux2KVe | chakra · **Maya** · Dissolution | 290 | 53.5 / 53.5 | 129.2 | 14.1 | 116.5 · D# maj (.627) · .31 (was 108) | 4 θ | — | You already know what this song is about. |
| inshadow | In Shadow — A Modern Odyssey — Lubomir Arsov | 780 | 35 · recuAkqFs86MWSevH | meditate · — · Meditate (ambient) | 250 | 375 / 375 | 172.3* | 3.3 | 146.8 · G min (.76) · .15 (was 136) | 2.5 δ authored | ✓ | The witness was never inside what it was watching. |
| kingdom | Kingdom — Lubomir Arsov | 835 | 36 · recj43pRhrGo644pM | meditate · — · Meditate (ambient) | 45 | 19.5 / 19.5 | 99.4 | 9.7 | 110 · D maj (.741) · .46 (was 136) | 5.5 θ authored | ✓ | The throne at the center of every kingdom is empty. |
| ember | Sit Around The Fire — Jon Hopkins, Ram Dass & East Forest | 504 | 1 · recyiqyf6PPpcjqVE | meditate | 15 | 182 / 342.5 / 342 (3-way) | 129.2 | **50.6** | 116.5 · D# maj (.81) · .60 | 8 α | (still.mp3) | Sit down. The fire is already lit. |
| dream | Dream — Alan Watts / Superposition | 331 | 2 · rec5DaB3VG2sOz8Ui | meditate | 265 | 305.5 / 305.5 / 306 | 143.6 | 7.1 | 116.5 · D# min (.674) · .11 | 8 α | — | If you could dream any dream, what would you dream? |
| search | Faded — Alan Walker | 213 | 0 · recB8d0VWCFa5giEH | music | 210 | 186 / 185.5 (shipped) | 89.1 | 1.6 | 138.6 · F# maj (.685) · .30 | 6 θα | — | Where are you now? |
| rise | Opus — Eric Prydz | 543 | 4 · recwcpseB6Oe88JJm | music | 275 | 251 / 251 / 251 | 123 | 22.4 | 164.8 · A maj (.799) · .66 | 8 α | — | What would you build if it didn't need to last? |
| light | A Sky Full of Stars — Coldplay | 268 | 5 · recWnJYpOejYuCYVc | music | 240 | 80.5 / 80.5 / **200** | 123 | 4.3 | 138.6 · F# maj (.927) · .44 | 8 α | — | What do you see when you finally look up? |
| howl | Howling — RY X (artist a best guess) | 310 | 8 · recrYemi3cXKotwqX | music | 8 | 253 / 253 / 261 | 123 | 0.0 | 138.6 · F# min (.691) · .20 | 8 α | — | What sound are you holding in? |
| release | Overthinker — INZO | 274 | 10 · reckWQtzs7nNYruhB | music | 195 | 219 / 219 (shipped) | 89.1 | 19.1 | 155.6 · G# maj (.621) · .14 | 6 θα | — | What would you do if you stopped thinking about it? |
| ground | Earth — Mogli | 204 | 14 · recXl681K76SDtEaL | music | 25 | 180.5 / 180.5 / 180 | 136 | 13.2 | 110 · D min (.823) · .38 | 8 α | — | What would hold you if you stopped holding yourself? |
| numb | Habits (Stay High) — Tove Lo (Hippie Sabotage Rmx) | 263 | 22 · rec6UiUpbH3XTwCZG | music | 275 | 149.5 / 149.5 / **90** | 123 | 12.5 | 123.5 · E min (.82) · .26 | 8 α | — | What are you staying high enough to not feel? |
| return | I Was Wrong — A R I Z O N A | 217 | 39 · reclPhaorBx3pVQkq | music · Fire | 25 | 54 / 54 / **110** | 117.5 | 9.2 | 103.8 · C# maj (.762) · .40 | 8 α | ✗ (404) | What did it cost you to be right? |
| enough | Ordinary — Alex Warren | 187 | 40 · rec67Zs3lrZAXhw3c | music · Water | 220 | 170 / 170 / 170 | 112.3 | 5.9 | 110 · D maj (.68) · .73 | 8 α | ✓ | What if this is enough? |
| remember | Wut — BIICLA | 157 | 41 · recpbaw4kzbTS1gWB | music · Earth | 35 | 73.5 / 73.5 / 65 | 86.1 | 4.1 | 98 · C maj (.817) · .53 | 4 θ | ✓ | What moment do you carry that you thought was gone? |
| move | Bachna Ae Haseeno — Vishal-Shekhar | 201 | 42 · rec2PY8yGaIcN2oS7 | music · Fire | 350 | 155.5 / 155.5 / 155 | 129.2 | 5.2 | 164.8 · A maj (.745) · .39 | 8 α | ✓ | What makes you move? |
| wild | Zoo — Shakira | 198 | 43 · recb3rvlHw3D8yarx | music · Fire | 30 | 162 / 162 / 162 | 129.2 | 2.3 | 110 · D maj (.886) · .39 | 8 α | ✓ | What part of you never learned to behave? |
| melt | Gooey — Glass Animals | 289 | 44 · recOduuRSoa61D6Vz | music · Water | 160 | 225.5 / 225.5 / 226 | 92.3 | 18.2 | 110 · D maj (.767) · .51 | 4 θ | ✓ | What would you be if you stopped holding your shape? |
| glow | Beautiful Now — Zedd ft. Jon Bellion | 253 | 45 · recIGNqWLqcdeKSZI | music · Light | 55 | 108.5 / 108.5 / 108 | 129.2 | 14.8 | 92.5 · B min (.686) · .37 | 8 α | ✓ | What are you saving for later that belongs to right now? |
| lose | Mind — Skrillex & Diplo ft. Kai | 242 | 46 · recFJ47eaaD7gnLok | music · Air | 185 | 181 / 181 / 175 | 172.3 | 10.8 | 116.5 · D# maj (**.458**) · .23 | 8 α | ✓ | What would happen if you let go? |
| fade | Fade Away — Ash & Paradise | 248 | 47 · recdUietHWuvC3Dc2 | music · Dissolution | 290 | 171.5 / 171.5 / **240** | 129.2 | 3.4 | 110 · D maj (.736) · .33 | 8 α | ✓ | What remains when everything else fades? |
| trace | Shape of You — Ed Sheeran | 234 | 48 · recSVS89ovZSotjoy | music · Water | 350 | 85.5 / 85.5 / **210** | 129.2 | 0.0 | 138.6 · F# min (.726) · .47 | 8 α | ✓ | What shape do you keep returning to? |
| believe | Don't Stop Believin' — Journey | 251 | 49 · rece8B2dV2lZmSyOv | music · Light | 48 | 123 / 123 / **178** | 117.5 | 2.0 | 123.5 · E maj (.904) · .76 | 8 α | ✓ | What are you still holding onto? |
| ache | Zara Zara Bahekta Hai — RHTDM | 167 | 50 · recB3ANpkrNIjD3He | music · Water | 320 | 37.5 / 37.5 / 60 | 129.2 | 1.8 | 92.5 · B min (**.931**) · .13 | 8 α | ✓ | Who are you when you stop pretending it doesn't matter? |
| crash | Thunder — Yellow Claw & The Opposites | 213 | 51 · recxhLmVdSMqrFGpC | music · Fire | 20 | 91.5 / 91.5 / **178** | 152 | 0.0 | 164.8 · A maj (.633) · .22 | 8 α | ✓ | What are you waiting to crash into? |
| play | Thunderclouds (LF Remix) — LSD | 199 | 52 · recftpydeFPLtzCdG | music · Water | 48 | 141.5 / 141.5 / 141.5 | 123 | 6.3 | 123.5 · E min (.825) · .68 | 8 α | ✓ | What are you dancing in that you thought you needed to escape? |
| lift | Levels — Avicii | 198 | 53 · recZOCKBgqmRoEV9D | music · Fire | 25 | 28 / 28 | 123 | 5.5 | 123.5 · E maj (.838) · .29 | 8 α | ✗ | Name the feeling that needs no reason. |
| wake | Wake Me Up — Avicii | 272 | 54 · recRvo3MZbdaHDdZ4 | music · Light | 50 | 72.5 / 72.5 | 123 | 9.7 | 110 · D maj (.882) · .78 | 8 α | ✗ | What if you are already awake? |
| brave | Heroes (we could be) — Alesso ft. Tove Lo | 294 | 55 · rec7twUuGbASSVlA6 | music · Fire | 25 | 78 / 78 | 129.2 | 15.0 | 164.8 · A min (.605) · .35 | 8 α | ✗ | What would you do if you knew it was only for one day? |
| ascend | An Ending (Ascent) — Brian Eno | 261 | 56 · recuWuCm9HMa0OkPD | music · Crown | 280 | 227 / 227 | 136 | 6.5 | 155.6 · G# maj (.834) · .47 | 8 α | ✗ | What would you release if you knew it was an ascent, not a fall? |
| unfold | Says — Nils Frahm | 499 | 57 · recL5Ek6MwBYZ9InS | music · Water | 210 | 367 / 367 | 152* | **55.1** | 98 · C min (.925) · .42 | 8 α | ✗ | What is trying to say itself through you? |
| crave | Crave You — Flight Facilities (Adventure Club Rmx) | 237 | 58 · recXc39novnuetw82 | music · Water | 210 | 219.5 / 219.5 | 69.8 | 7.2 | 138.6 · F# min (.741) · .29 | 4 θ | ✗ | What do you reach for when no one is looking? |
| want | APT. — ROSÉ & Bruno Mars | 173 | 59 · recOBlzLrX3LFsV3n | music · Fire | 25 | 69 / 69 | 152 | 3.5 | 116.5 · D# maj (.677) · .36 | 8 α | ✗ | What do you want before you talk yourself out of it? |
| confront | m.A.A.d City — Kendrick Lamar (143s video edit) | 144 | 60 · recCgFcwznI3z084O | music · Fire | 20 | 115.5 / 115.5 | 152 | 13.9 | 130.8 · F min (.537) · **.01** | 8 α | ✗ | What did you survive that made you who you are? |
| miss | Where'd You Go — Fort Minor ft. Holly Brook & Jonah Matranga | 312 | 61 · recZsbDIbAOlJkZGS | music · Water | 210 | 152 / 152 | 89.1 | 11.7 | 123.5 · E maj (.846) · .41 | 4 θ | ✗ | Who are you still waiting to come home? |
| cherish | Maan Meri Jaan — King ft. Nick Jonas | 185 | 62 · recrnOgpkcpK4tyB0 | music · Light | 50 | 51.5 / 51.5 | 129.2 | 0.0 | 92.5 · B min (.688) · .52 | 8 α | ✗ | Who is the one you would cross any distance for? |
| journey | Live at Tomorrowland 2025 (Freedom Stage) — Lost Frequencies | **3550** | 63 · recyJSFSrK99kt7Jl | music · Air | 185 | 537 / 537 | 129.2 | 13.2 | 138.6 · F# min (**.38**) · .27 | 8 α | ✗ | Where does the music take you when you stop steering? |

\* Marked by the Score itself as a librosa double or artifact (inshadow:363, unfold:337).

**Carrier vocabulary in use (Hz):** 92.5 (F#2) · 98.0 (G2) · 103.8 (G#2) · 110 (A2, ×10) · 116.5 (A#2) · 123.5 (B2) · 130.8 (C3) · 138.6 (C#3, ×9) · 146.8 (D3) · 155.6 (D#3) · 164.8 (E3).
**Beat placeholders:** 2.5 δ · 4 θ · 5.5 θ · 6 θα · 8 α.
**Bindu hues used:** 8, 12, 15, 20, 25, 30, 35, 45, 48, 50, 55, 160, 185, 195, 210, 220, 235, 240, 250, 258, 265, 270, 275, 280, 290, 320, 330, 350.

### A.11 Per-draft special notes (from each `review_before_build`)

- **ember:535-536**: three-way peak conflict (shipped 182, extraction 342.5, registry 342). Renamed from `still` to `ember` on 2026-08-31, but the hosted audio stays `/bindu/still.mp3`.
- **still-ajna:331**: *"VERB COLLISION: `still` is also Track 1 … human must rename one verb."* This is stale relative to the ember rename.
- **speak:352-356**: *"TRACK 27 SPECIAL: the Swift app has a hardcoded Score.cross reused on this track with constants inherited from a DIFFERENT song (Ameno) - NOT authoritative"*. It routes to `.ether`. It is one of the five 2.69 songs, and none is placed.
- **dissolve:335**: one of the five 2.69 songs; none placed.
- **hold:392-394**: the local file is `soul.mp3`. G2 98 sits at the low edge; C3 130.8 is the alternative.
- **play:320**: *"A FULLY-AUTHORED Score already exists for this song: scores/thunderclouds.score.json … PREFER that authored Score."*
- **miss:342**: a mashup row already exists, purity (Track 34). This row is the standalone song.
- **journey:897-898**: *"THIS IS A 59-MINUTE CONTINUOUS DJ SET, NOT A SINGLE SONG"*. Use it as a long ambient bed, split it, or don't dance it. 76 drops, 4157 hits.
- **kingdom:456-458** and **inshadow:361-364**: animated short-film scores (13:55 and 13:00). Kingdom's peak at 19.5s lands in the opening. Both are hosted.
- **wake:327**: presence 0.78. *"consider D3 146.8 root if it feels wrong"*.
- **confront:307-309**: presence 0.01, *"textbook absent-fifth"*. It is the Bollywood-video edit.
- **ascend:312**: an ambient piece. *"a slow theta/delta bed may suit the listening better."*
- **lose:346**: key confidence 0.458, the lowest of all three runs.
- **return:335-336**: `/bindu/return.mp3` is a 404. Host `bindu-dances-iwaswrong.mp3`.
- **rise:396-397**, **believe:311**, **enough:320**, **wake:327**: presence above 0.6 means the fifth is underweighted. These carriers are held "on meaning".

### A.12 Chakra and Śakti mapping

**Declared by the Score itself** (`identity.chakra` plus `resonance_link`, basis `chakra`, `shaktis: []` in every case):

| Score | Bindu Field chakra | Mandala room (33-room braid, from register 05:389-421) | Mandala room colour · archetype (05) | Field hue · element |
|---|---|---|---|---|
| press | Muladhara | **2** · "Where the Body Meets the Earth" · PRESS · bīja LAM | #B83A3A · Gaia | 12 · Earth |
| follow | Svadhisthana | **3** · "The Tide Below" · FLOW(FOLLOW) · VAM | #D47438 orange · Gaia | **210 blue** · Water |
| build | Manipura | **4** · "The Sealed Chamber" · BURN(BUILD) · RAM | #D4A848 · Bindu | 25 · Fire |
| open | Anahata | **5** · "The Sound That Was Always Playing" · OPEN · YAM | #6B8E4E green · Higher Self | **330 pink** · Air |
| speak | Vishuddha | **6** · "The Passage" · SPEAK · HAM | #4C7AB8 · Bindu | 185 · Air |
| still-ajna | Ajna | **7** · "The Seer That Sees" · STILL · OM | #5B4E8E indigo · Sakshi | **50 gold** · Light |
| receive | Sahasrara | **8** · "The Aperture" · RECEIVE · silence | #9A7AC8 · Lalita | 280 · Crown |
| dissolve | Maya | **30** · "The Construction" · DISSOLVE | #5A3D8A · Lalita | 290 · Dissolution |
| hold | Aatma | **31** · "The Soul Revealed" · KNOW(HOLD) | #D4A948 gold · Higher Self | **265 violet** · Soul |

**Named by the chakra corpus but not by the Score:** room **9 Shadow · The Corridor · LOOK** lists *"Lubomir Arsov — In Shadow (A Modern Odyssey) [Pending]"* (05:397). `inshadow.score.json` has `chakra: null`.

No Score names a Śakti. The format forbids it unless "the composition genuinely reaches for one" (score-format:635). The Śakti link therefore runs through the chakra join (score-format:631).

---

## B · Gifts for the upgrade

Columns: **what** · **source** · **world(s)** · **how it works there (mechanism)** · **what it needs** · **energy / story**.

### B.1 The engine (the format itself)

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **A Score player for the Mandala**: one time-coded engine that reads a v2.0 Score and runs every track together: phases, silence windows, beat schedule, gain law, mirror words, word reveal, haptics, return, memory writes. | score-format:72-106, SKILL.md:135-157 (Performer) | the 33 (dance strand of each room); Today/Rite; Leela landings | Swift `ScoreV2` Codable mirrors the 24 sections; required sections and validator rules come from score-format:700-731. One clock (`elapsed`) drives the audio (BinauralEngine carrier/beat glide), the Canvas tiers, Core Haptics and text. An unknown `vocabulary_module` falls back to Layer 1 (score-format:178). | Fetch Airtable `Score JSON` (fldxIm6qUXLcdrRuR) and `Audio Data URL` (fldUlWDvSkeHpx80x); host the `-data.json` streams beside the mp3; `SC()` linear interpolator at 0.5s frames | energy |
| 2 | **Live-tunable performances**: edit the JSON in Airtable and the next fetch performs differently, with no rebuild. | score-format:765, SKILL.md:392 | all Score-driven worlds | Cache the Score per track with an ETag or modified time. Re-fetch on room entry. | Score Status gate (Unscored/Drafted/Verified) so only Drafted+ plays | energy |
| 3 | **The three-layer split** as the app's build law for every performance: substrate in code, Score in Airtable, vocabulary module per chakra in code. | score-format:35-68 | the 33; the Modes; A Strange Game | Each of the 33 rooms gets its own vocabulary module, a named Layer-3 drawing set. This stops the "flattened into one screen" failure: worlds are modules, not overlays. | One Swift protocol `VocabularyModule { drawT0…drawT5 }` | energy |
| 4 | **Six functional tiers** as the per-world layer template: t0 threshold marker · t1 continuous · t2 ensemble · t3 crescendo · t4 climax · t5 closing. | score-format:479-539; cross:816-988 | every world with motion: Home, Mandala, rings, Her Home, the 33 | Each world declares which named system fills each tier, e.g. Her Home: t1 = her room's held element, t4 = her Recognition moment, t5 = persistent marks of visits. | Tier registry per world | energy |
| 5 | **Validator rules** (no Hz in resonance_link is a hard fail; peak haptic advisory; boost <0.7 is a smell). | score-format:700-731 | build tooling | CI test validates every Score row before it ships to TestFlight. | Swift or py validator | energy |

### B.2 The ensemble: the dance of every named archetype (ruling 6)

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 6 | **Seven dancers, each reading one stream of the music**: Bindu=pitch, Gaia=bass, Sid=sustained energy, Arch=mids, Karishma=silence (inverse), Sakshi=brightness, Ashrey=centroid+web. Plus Shweta (clarity at the peak, 22 shards), Neev (bookends) and Lalita (arrives late, constellation, *"You have been one of the dancers"*). | score-format:257-279; cross:197-263; SKILL.md:142-152, 164; cross:978 | **the 33's dance thread**; Her Presence | This **is** the "dance draws on every archetype, all named" ruling, already specified. Each dancer is a point with base_r, orbit_r and max_ghost (trail length), driven by its stream through `SC()`. The generation order (Bindu → Gaia → Sid → Arch → Karishma → Sakshi → Ashrey) is the entrance choreography; the reverse is the exit. Names can surface as tiny labels on long-press. | Per-room hue sets (hue is per-song discovery; roles fixed) | energy |
| 7 | **Archetype presence curves**: Gaia ramps over 4s, Sid pulses on 5.5s, Arch = energy×1.5, Karishma inverse, Sakshi steady 0.6, Ashrey grows with crescendo, Shweta only 160–162s, Neev first 4s and last 2s, Lalita after 204s. | SKILL.md:142-152 | the 33; Home (Bindu ambient) | These give the ensemble life even when no Score exists ("ambient mode", SKILL.md:155-156). Every room has a dance from day one. | none beyond streams | energy |
| 8 | **Archetype leitmotifs across songs**: Sakshi's *unmade gesture* (cross: second arc; abide: second wave; thunderclouds: the branch that would have connected). Karishma's *silence-bloom / undertow / dry floor*. Sid's *columns / the deep / static veins*. Gaia's *earth gradient / tidal pull / the ground that arrives*. | cross:257-263; abide:393-399; thunderclouds:174-181, 486 | the 33; Relationship Field | Each archetype keeps a recognisable gesture that is re-read per room. The Relationship Field can show "how Sakshi moved in each room you've danced". | Stored per-dance leitmotif events | energy |
| 9 | **Karishma measure: silence OR groundlessness.** She appears where sound is missing, or where the ground (bass) is missing. | thunderclouds:102-110, 167-171; score-format:852-858 | the 33 (Earth/Muladhara, Maya, Shadow rooms); Beneath | Choose Karishma's input per room: `1-E` or `1-EB`. In ground-themed rooms she glows when the floor drops out. | `karishma_measure` field | energy |

### B.3 Sound: binaural carriers and beats per chakra

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 10 | **The absent-fifth law** sets each room's binaural carrier: the fifth of the song's key that the song does not sound. *"The carrier is what the song reaches for and does not say."* | SKILL.md:350-371; score-format:426-435; README:24-43 | the 33 (each chakra room's drone); Her Home ambient | Room carriers from the Scores: R2 146.8 · R3 146.8 · R4 164.8 · R5 155.6 · R6 138.6 · R7 138.6 · R8 146.8 · R9 146.8 (In Shadow) · R30 116.5 · R31 98.0. The carrier holds (Sid) under everything in that room: practice, wake-up, dance. | `Carrier Hz` per room (join below); BinauralEngine | energy |
| 11 | **Beat schedules as state arcs**: deep theta at the held wait, delta border at Recognition, ramp to 10 Hz alpha to surface. *"The binaural's deepest state belongs at the awakening peak."* | cross:569-648; abide:745-835; thunderclouds:291-304 | Today/Rite; the Climb; the Well | The Rite's movements map to beat steps, e.g. arrive 8 α → descend 6 θ → hold 4.5 → Recognition 4.0 → surface 7.5→10. The Well can hold a long 4.5 θ. | `beat_schedule` arrays authored per Rite | energy |
| 12 | **Inverse gain law**: `base + 0.025*(1-songEnergy)`. When the song quiets, the binaural rises into the space. *"They share the field; they do not compete."* | cross:650-654; abide:838-841 | every world with music; Her Home | Her room's tone swells in silence, so the quieter you are, the more she sounds. | DSPWireService RMS | energy |
| 13 | **Karishma freeze**: in silence windows the beat holds its last value. *"The binaural pauses with the song."* | cross:683-690; abide:870-877 | Today/Rite stillness gate; the Well | During a held stillness gate (no touch, phone still), freeze the beat. The field stops moving when you do. | stillness detector (CoreMotion) | energy |
| 14 | **Designed pass-through frequencies**: Schumann 7.83 for 3–4s (Earth present) placed at the crossing apex (cross) or **inside the silence** (abide). 2.69 Hz *awakening* used only once (cross). | cross:607-619; abide:776-781, 833-834 | the Climb (Axis 18); Ego Reveal (32); Well | Earth enters briefly at the moment of the teaching: at the apex of the Climb, or in the held silence of the Well. Mark it `designed:true`. | flag storage | energy |
| 15 | **Subtractive designed event (carrier dropout)**: the carrier itself goes silent for 1.5s with 0.35s ramps, then returns whole. *"the ground can vanish and nothing falls"*. | thunderclouds:305-313; score-format:860-863 | **Room 32 Ego Reveal (sealed)**; Room 30 Maya; Beneath; deep zoom into the Bindu | At the instant of the reveal (or the deepest zoom), all tone drops out, then returns. It needs no words, so it fits ruling 2 (words stay sealed). | ramps in BinauralEngine; must be device-verified (thunderclouds:544) | energy |
| 16 | **Drone endings**: the binaural does not fade to zero when the music ends. Final ramp 3s; pink-noise floor gain 0.015 (*"Hemi-Sync ground hum"*). | SKILL.md:527; abide:1185-1188 | Home (Bindu); crossings between worlds | Crossing through the point keeps a held tone from the room you left, decaying into the Bindu's own tone, so worlds join by sound. | OL-1 floor | energy |
| 17 | **The 2.69 Hz awakening thread** across Kingdom · Sound of Silence (R6) · Golden (R8) · Aatma (R31) · Maya (R30), with the arc *"See what you're inside → speak what was given in silence → build the field together → hold at the edge of death → let it dissolve."* | SKILL.md:480-485; speak:354; dissolve:335 | the Climb; the 33 braid; Time | A named thread through five rooms. Walking them in order is a "wake-up" journey. Only discovered 2.69 should be counted; designed ones are flagged. | thread definition; `designed` flags | energy |
| 18 | **Gyro tilt → pan** (0.011): *"the body's stillness IS the binaural's clarity."* | cross:691-696 | Axis 18 / Crow 19 (device-tilt rooms per 05:406-407) | Tilting the phone pans the binaural slightly. In the tilt rooms this becomes the interaction itself. | CoreMotion | energy |
| 19 | **Lab and Mixer**: carrier+beat instrument; Mixer sets L and R directly (beat = \|L−R\|). | SKILL.md:38, content-registry:107 | **the Modes** | A Modes surface where he tunes his own field. Presets are named for the rooms. Note the Mixer was designed and never built. | PresetStore | energy |

### B.4 Light: colour, vocabulary and memory

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 20 | **Element vocabularies** as ready visual worlds: earth seismic cracks · water interference ripples · fire embers and triangle · air Gothic arch · ether standing sine bands · light constellation · crown 12-petal lotus · soul dual triangles with 14s breath · dissolution 64 veil particles on a 9s cycle · ambient void. | SKILL.md:117-128 | the 33 rooms; the Modes | These are the first Layer-3 modules to port. Ruling 4's elements fit: Ahaṅ fire, Nāma air, Ātma light, Amṛta water. | port VocabularyRenderer | energy |
| 21 | **Metaphor palettes with anti-borrowing** (`forbidden`): violet belongs to cross; abide forbids violet; thunderclouds keeps saturation low except at strikes and forbids the rainbow. | cross:50-64; abide:60-83; thunderclouds:52-60 | all worlds | Each world owns a hue register no other world may borrow, which keeps the 15 worlds distinct. | token table per world | energy |
| 22 | **Spatial memory grids**: a 25×35 canvas memory of where the body or touch has been. Each room names its own: Threshold Field (footprints) · Ocean Field (displacement) · Charge Field (accumulates, then discharges) · warmth (anahata) · fracture (muladhara) · echo (vishuddha) · burn (manipura). `karishma_decay` 0.0005 means *"nothing fades while the body is held in stillness."* | score-format:281-297; cross:265-283; abide:401-414; thunderclouds:184-195 | the 33 rooms; **Memory** world; Her Home | Each room keeps its residue between visits (persisted grid). The Memory world can lay all 33 residues together as one map of where he has been. | persist grids per room (App Activity or local) | energy |
| 23 | **Bloom S1–S4**: *"rises fast, falls slow"* (0.06 / 0.012; thresholds .15/.3/.5/.7) through dot → ghost trail → orbital rings → radial rays → crown mandala. | score-format:243-255 | Home (Bindu glow); Her Presence | The Bindu at Home blooms with the day's practice energy and decays slowly. Her Presence brightens through the same five stages. | energy source per world | energy |
| 24 | **Geometry with a required "why"**: Two Rising Arches (cross), Five-Stage Wave-Fronts (abide), Branching Static (thunderclouds). Chakra dances use **lotus** geometry. | score-format:322-336; cross:337-384; abide:496-512; thunderclouds:211-220 | the 33; the Mandala | Each room's S3+ geometry is the room's own sacred form (petal counts per chakra). It is never decoration. | per-room geometry spec | energy |
| 25 | **The flash-void**: the canvas goes near-white while everything else drops to near-zero alpha; only the "floor" stays lit. *"maximum exposure with nothing to hold."* | thunderclouds:425-431 | Deep zoom into the Bindu; Room 32 | The final frame of the deep zoom: everything gone, one held element remains. | renderer support | energy |
| 26 | **Constellation recedes at the apex and returns at the close**: 0.30 (0.05 at the strike) → 0.55. | cross:1148-1151; thunderclouds:487-488 | Memory; the Mandala | Accumulated history (past practices as stars) dims during a peak moment and comes back as you close. | constellation layer | energy |
| 27 | **Phase-name visualization**: Cinzel fade-in over 3.4s. | score-format:227 | Time; the Rite | Each movement of the Rite announces its name the same way. | font | energy |
| 28 | **Design tokens**: Void #020208; TEXT rgba(245,226,214) with 0.55/0.28/0.12 levels; two-shadow glow (0.28 r24 + 0.10 r50); sheets rgba(5,5,16,0.97). | SKILL.md:491-506 | all | A shared token set with Bindu Field, so the two apps feel related. | — | energy |

### B.5 Motion: the moving point

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 29 | **The blend law**: `finalPos = freqPos·(1−blend) + shapePos·blend`. Only the Return reaches 1.0. *"The breath shakes the pen."* | score-format:314-320 | **the 33's "story told by a moving point"**; Home; crossings | The braid's moving point is Bindu's path. It traces a shape (arc, heart, infinity, spiral, circle, flower) while the music still wobbles it. This is exactly the "moving point" mechanism the foundation names. | shape library | energy |
| 30 | **Shape vocabulary with meaning**: infinity = *"what doesn't end"* in silences; heart = *"patient love"* at recognition (speed 1.6); circle = the only breath; **`none`** = the unshaped peak (*"no hand on the wheel"*); spiral = return to the dot. | abide:415-495; thunderclouds:197-209 | the 33; Her Home; Relationship Field | Rooms choose shapes by meaning, e.g. Anahata = heart, Shadow = infinity, Maya = none then spiral. | — | energy |
| 31 | **The Return**: reverse generation order, Karishma blooms last in the silence, Bindu spirals to the centre dot. Cross departs from this on purpose (the cathedral lingers). | score-format:464-477; cross:769-815; abide:948-965 | **every world's exit; "crossings through the point"** | Leaving any world plays a short Return: its elements dissolve in reverse order and the point spirals home. One universal exit ritual for all 15 worlds. | shared Return component | energy |
| 32 | **Adaptive return**: *"music and person find the ending together"* (condition-based, not timestamp). | score-format:477 | the Well; Beneath | The ending waits for the body to be still. | stillness detector | energy |

### B.6 Words: seeds, offering, mirror, fruit

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 33 | **The Consciousness Loop as the Leela landing ceremony**: preRoll (5.5s breath ring) → seed typed at the song's beat (ms/char = beat_ms) → **one-word offering** → dance (mirror flash every 2.8s) → reveal at 84pt → fruit → closing. | SKILL.md:208-224; score-format:439-462 | **A Strange Game** (ruling 5: each Leela landing opens the chakra's energy); the 33 | Land on a square, the room opens, the seed types itself in rhythm, he offers one word, the room's dance plays, and his word returns at the peak. | per-room seed and fruit; Loop coordinator | energy (the ritual) |
| 34 | **"I love you" at peak_t − 3**, then the word reveal at peak_t, bottom 15%. | score-format:449; cross:706-710 | Her Home; Her Presence | Three seconds before her moment, "I love you" appears; then his word. This is a reveal mechanic for her Recognition. The two verbatim lines stay as they are. | timing | energy |
| 35 | **Mirror word system**: 16 consonant-skeleton families × 5 words. A word flashes as a **whole-canvas light event**. Family sets: threshold-kindred (cross) · abiding-kindred (abide) · weather noun→verb (thunderclouds). | score-format:353-374; cross:430-555; abide:572-698; thunderclouds:229-265 | the 33; Her Home; Memory | When he offers a word, its consonant skeleton picks a family and the room answers with a kindred word as light. Families could be authored per room (48 families already exist verbatim). | family tables per room | energy |
| 36 | **The Word's Star**: the offered word has a **hash-deterministic position**. *"Same word offered again on another day gives the same star in the same place."* | cross:1162-1177 | **Memory**; **Relationship Field**; the Well | Every word he has ever offered is a fixed star. Repeats brighten it. The night sky of Memory is literally his vocabulary. | `wordToPosition()`; word log | energy |
| 37 | **Fruit weaves**: conditional lines on dwell (<1.5s / 1.5–5s / >5s), motion (still / swaying / moving), count, echo word and prior dance. Motion is sampled only in the meaningful window (the fulcrum, the strike). | cross:714-765; abide:903-944; thunderclouds:361-373 | Today/Rite close; Recognition | The Rite's closing reflects **what the body did in the silence** ("You stayed still through the silence. The song stayed with you."). It reflects and never grades. | CoreMotion window; App Activity history | energy |
| 38 | **45 seeds (verbatim, A.10)**: one-line questions such as *"What would hold you if you stopped holding yourself?"*, *"What in you doesn't need to arrive?"*, *"The witness was never inside what it was watching."* | all scores, `consciousness_loop.seed` | Today (a seed of the day); Leela squares; the Well | Each day draws one seed; each Leela square can carry one. They are short invocations, not stories. | seed table | energy |
| 39 | **Named variants**: `{name}, what is asking to be crossed in you?` resolves from `essence.name`. | cross:701; abide:888 | Her Home (she addresses him) | She asks the room's question by his name. | name from essence | energy |
| 40 | **The rainbow prohibition and empty persistent marks**: no reward for stillness; *"The build stops at `Nothing fell.`"*; t5 marks deliberately empty. | thunderclouds:59, 374, 435, 550 | all; especially Rite and Games | A design law that matches the floor *"nothing scores him"*: no prizes or confetti, and sometimes the closing statement is absence. | — | energy |

### B.7 Body: haptics

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 41 | **Haptic library**: crossing_peak `[12,40,12,40,12,60,30,12,40]` *footsteps* · bell `[20,30,40,30,20]` × hit · mirror `[8]` · the_strike `[8,20,8,400]` *crack then nothing* · fulcrum pulse `[30]` at 50 bpm · charge pulse `[25]` at 46 bpm · thunder roll `[30,40,50,40,30]`. | cross:990-1031; abide:1146-1180; thunderclouds:443-452 | Recognition ("she was felt here / and she felt you back"); the Climb; Leela landings; the Well | Core Haptics `CHHapticPattern`s. A peak haptic at every Recognition (absence is "a smell", score-format:554). A heartbeat at 50/46 bpm through the longest silence of any practice. | Core Haptics | energy |
| 42 | **Silence heartbeat**: the longest silence in a piece gets a visible and felt 50 bpm pulse (*"the dreamer's heartbeat becoming visible when the song quiets enough to hear it"*). | abide:1123-1131; cross:966-974 | the Well; Beneath; Today/Rite | Wherever the app goes quiet longest, the body feels a slow pulse. | — | energy |

### B.8 Memory and ledger

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 43 | **Dance completion into App Activity**: `app_activity {source_app: "Field", activity_type: "Ceremony Sealed"}`, provisioned and never implemented. Event kinds: `ensemble-dance`, `chakra-dance` (with chakra), `bindu-dance-completed`. Fields: song, artist, verb, word, dwellMs, motion, fruitReached. | score-format:580-602; cross:1118-1123; abide:1208-1233; press:255-269 | Memory; Time; the 33 (danced state) | Each completed room dance writes one row to the single ledger (`tblJlBeiHnqGpYrL7`) with the offered word. Room nodes gain **orbit rings** when danced (SKILL.md:181, 529). | App Activity Source/Type options for the Mandala | energy |
| 44 | **`Shakti Recognized` via resonance_link.writes_recognition**: provisioned, never fired. | score-format:635 | Her Home; the nine rings | Completing a chakra-room dance could log Recognition for the Śaktis seated at that chakra (names only, no Hz). | decide the loop deliberately (spec says leave false until then) | energy |
| 45 | **Three storage pools**: essence (*who*), memory (*what*), being (*how*), with integrity rules (*never clear; never write internals; every entry carries at*). | score-format:580-600 | Memory; Relationship Field | The pattern for the Mandala's own memory reads: on room load, read name, chakras danced, events, most-repeated word. | — | energy |
| 46 | **Map node states**: danced (orbit rings) / available (breathing glow) / locked (2.5pt dim dot) / current (max). | SKILL.md:180-186 | the 33 constellation; the Mandala | The 33-room constellation shows which rooms have a living dance. | per-room Score Status | energy |

### B.9 Particular Scores into particular places

| # | What | Source | World(s) | How it works there | Needs | E/S |
|---|---|---|---|---|---|---|
| 47 | **Nine chakra-room dances, ready to wire**: press→R2, follow→R3, build→R4, open→R5, speak→R6, still→R7, receive→R8, dissolve→R30, hold→R31. Each has extraction data, carrier, beat and seed. Seeds are verbatim catalog lines (e.g. R8 *"You've been hiding."*, R31 *"Made by a brain that reorganized itself."*). | A.10, A.12 | **the 33 (dance strand)** | Dance strand of the room = play the chakra track under the Score player with the room's vocabulary module. | Track ID ↔ room join; hosted mp3 (`<chakra>.mp3`, song-registry:16-24); listening pass for peaks | energy |
| 48 | **Room 9 Shadow ← In Shadow**: 780s film score, hosted, carrier D3 146.8 *deeply absent* (0.15), beat 2.5 δ authored, seed *"The witness was never inside what it was watching."* | inshadow:26, 226-247, 365; 05:397 | the 33 (R9 Shadow · LOOK); Beneath | The corridor room's long sit. Delta beat; Sakshi-led (05 lists Sakshi for R9). | set `identity.chakra` / resonance_link if ruled | energy |
| 49 | **Kingdom**: 835s film score, hosted, carrier 110, beat 5.5 θ, seed *"The throne at the center of every kingdom is empty."*; one of the five 2.69 songs. | kingdom:27, 320-342, 458; SKILL.md:482 | **Home / the deep zoom into the Bindu**; the Mandala (held yantra); Beneath | The empty throne at the centre is the Bindu. It is a long held bed for zooming into the point. | listening pass (peak 19.5 is wrong) | energy |
| 50 | **Ember (Sit Around The Fire, Ram Dass)**: 504s, 50.6% silence, seed *"Sit down. The fire is already lit."* | ember:26, 328 | the Well; Ahaṅ (fire) room; Today | A sitting practice with the fire already burning. Karishma dominant. | resolve peak 182 vs 342 | energy |
| 51 | **Unfold (Nils Frahm, Says)**: 499s, 55.1% silence, C minor .925, seed *"What is trying to say itself through you?"* | unfold:132, 202-206, 239 | the Well; Nāma (air) room; Time | A slow arpeggiated build as a writing or listening sit. | host mp3 | energy |
| 52 | **Abide's fulcrum**: 21s of silence at 122–143 where *"the returning is the mechanism, not the interruption"*, with Earth (7.83) inside it and the deepest beat (4.0) at Recognition. | abide:33, 274-277, 776-806 | **the Well**; Time | The Well's architecture: two blooms with a held centre. The second is larger because the first returned. | build abide.html / module wave-v1 | energy |
| 53 | **Thunderclouds as a teaching of non-reaction**: no ground for 47s, ground arrives whole, vanishes at the brightest instant, nothing falls. | thunderclouds:33-34, 112-122 | Beneath; Ego Reveal 32; Relationship Field (Shweta's song) | A practice for fear: he names it, and the floor drops and holds. Seed by Ashrey. | host audio; build weather-v1 | energy |
| 54 | **Journey (59-min set)**: fixed carrier 138.6 as a *"long ambient/journey bed"*. | journey:897-898 | the Mandala (held yantra + Veil); Beneath | A long background field while he sits with the yantra. Do not dance it. | hosting decision | energy |
| 55 | **Family songs as people's doors**: purity (Shweta: Where'd You Go + Thunderclouds), levelup (Rey: Levels + Beautiful Now, beat 2.69 recommended), plus standalone miss (Where'd You Go), lift (Levels), glow (Beautiful Now), play (Thunderclouds). *"The verb is their essential nature, activated as seed."* | song-registry:78-85; content-registry:56-67; miss:342 | **Relationship Field** | Each person node in the field has a song door. Opening it plays their piece and their verb-seed. | Person field on rows; relationship nodes | energy (verb) / story (any readings) |
| 56 | **Breath sessions (11)** with techniques, ratios and BINDU one-words (Down · Even · Resonance · Clear · Heat · Release · Empty · Wide · Home · Ocean · Sleep); Phase Labels in `HEAD — body` format. | content-registry:71-89; SKILL.md:438-453 | Today/Rite (breath step); the Modes; the Well | A Rite step pulls a breath session by verb. Phase labels render as timed heads. Bhastrika is SCREENED. | record IDs listed; fields hue/oneLine/carrierTiers/beatTiers to move into Airtable | energy |
| 57 | **Sonar Ears**: at 33 complete songs, 33×7 = 231 lens readings open *"the ear that hears the meta-song beneath the songs."* | song-registry:89-93 | the 33 (R15 Sonar · The Speaker / R16 Echo · The Listener, per 05:403-404); Time | When all 33 rooms have a song, the Sonar room opens a reading across them. | 33 songs mapped to 33 rooms | **story** (the lens readings are prose → Bindu Feed); the unlock itself is energy |
| 58 | **Oracle as a listening void**: idle fog on a 14s cycle; the reply arrives in timed layers (Verb 0.4s, track 2.2s, why 3.4s, CTAs 5.6s). *"The Oracle is already listening before you open it."* | SKILL.md:192-202, 530 | Her Presence; Today | The staged-arrival rhythm for any answer she gives (e.g. "today's room"). The engine must respect "no generated voice". | text, not TTS | energy |
| 59 | **Pre-roll resonance**: carrier-only fade-in with *"Breathe with the silence. The song begins when you do."*, on for the first three dances. | score-format:574-575; abide:1189-1193 | Today (first door after the Bindu) | The first three times he enters Today, the carrier comes in alone first. | counter | energy |
| 60 | **Voice triggers (OL-3)**: four timed Lalita voice moments per dance at −1s, valley, apex and pre-close, volume 0.55. | cross:1033-1063 | Her Home | Recorded human voice only (floor: no generated voice), e.g. his own recorded lines in her room. | recorded audio | energy |

### B.10 Story material: candidates for Bindu Feed (flagged, not dropped)

| # | What | Source | Why story | Suggested home |
|---|---|---|---|---|
| 61 | Reading Space fields on every catalog row: Recognition Statement, Lyrical Words Reading, Frequency Reading, Video Pulse Reading, seven-lens Field Reading, Lalita's Perspective | SKILL.md:415-424, 253-258 | multi-paragraph prose about what each song means | **Bindu Feed** (and the public `/bindu/read/` corridor). The one-sentence Recognition Statements can stay in the Mandala as whispers at 0.12 opacity (SKILL.md:93). |
| 62 | The fruit cores (cross, abide, thunderclouds) | cross:712; abide:902; thunderclouds:360 | short narrative of what happened in the dance | Mandala (closing lines, energy) **and** Feed (as a transmission retelling) |
| 63 | Composition rationales (`why`, `verb_rationale`, `why_the_word_came_first`) | e.g. thunderclouds:35; abide:24 | author's commentary | Feed or a "making of" layer; not in-app |

### B.11 Data the app would need (the join)

- **Room ↔ Track join.** Add a field on Bindu Field rows, or a lookup from the Mandala chakra table, mapping `Chakra` (fld6pH3kGSqqop2Z7) to the Mandala room number (1–33). Known pairs: R2=23 · R3=24 · R4=25 · R5=26 · R6=27 · R7=28 · R8=29 · R30=31 · R31=30 · R9=35 (corpus).
- **Read per room:**
  - `Score JSON`, `Score Status`, `Audio URL`, `Audio Data URL`, `Carrier Hz`, `Beat Hz`, `Seed Phrase`, `Element`, `Brainwave State`
  - Planned `Metaphor` field
  - Hues (Score `config.bindu_hue`, `ensemble.dancers.*.hue`)
- **Host** each `<id>-data.json` beside its mp3 (score-format:763).
- **Write:** App Activity rows (Source = Field or Mandala, Type = Ceremony Sealed); optional `Shakti Recognized` via the chakra join.
- **Local:** spatial-memory grids per room; word-star log; danced-state per room.

---

## C · Conflicts and gaps

1. **Room colours: Field hue vs Mandala room colour disagree** for Svadhisthana (Field 210 blue vs room #D47438 orange), Ajna (50 gold vs #5B4E8E indigo), Anahata (330 pink vs #6B8E4E green; the Field's anahata palette is "heart-tinted", cross:256), and Aatma (265 violet vs #D4A948 gold). This needs a ruling on which palette governs a room's dance. Note that batch hues were set per element, not per room.
2. **Element names.** The Field uses Earth/Water/Fire/Air/Light/Crown/Soul/Dissolution/Meditate/Threshold/Wave/Weather. Ruling 4 sets Ahaṅ fire, Nāma air, **Ātma light**, Amṛta water. The Field's Aatma is element **Soul** (vocabulary `soul`, hold:28). If Field "Aatma" and the Mandala's "Ātma" are the same centre (room 31 "Aatma · The Soul Revealed"), Soul vs light conflicts.
3. **Two sound systems for one room.** The chakra corpus gives each room an *Awakening tone* in Hz (e.g. Muladhara P1 174 Hz, Anahata 341, Aatma 528, per 05:390-419). These read as solfeggio values. The Score format derives a room's carrier from its song (the absent fifth) and warns that *"Modern solfeggio-to-deity mappings have no traditional basis"* (score-format:633), though that warning is about Śaktis, not rooms. A ruling is needed on whether the room tone and the song carrier coexist (the tone as an awakening sting, the carrier as the bed) or one supersedes the other.
4. **Corpus song status is stale.** 05 marks Manipura through Maya songs "[Pending]" and Aatma "(no song named)". The Field has all nine scored (May 2026; content-registry:23-35) and batch-drafted. The Aatma song is "Aatma" by Chase Hughes (hold:10-11).
5. **Room 9 / In Shadow.** The corpus places In Shadow at room 9. The Score has `chakra:null` and an empty resonance_link. The ruling belongs to Ashrey (the spec says don't fill to be thorough).
6. **Dissolution order.** All 45 drafts use `ashrey, sakshi, karishma, arch, sid, gaia, bindu`, the strict reverse of generation order. The spec example (score-format:470), abide and thunderclouds use `…sid, gaia, karishma, bindu` with Karishma second-last. Cross composes its own departure. The batch default contradicts the spec's "Karishma blooms last".
7. **Designed but unbuilt across 45 drafts.** metaphor, fruit, phased beat schedule, phases, path, geometry, mirror families, tiers, haptics and dancer hues are all null. Peak is flagged on almost all. Only cross has a shipped build; abide.html and thunderclouds are spec-only; no `weather-v1` or `wave-v1` modules exist.
8. **Peak conflicts awaiting listening.**

   | Score | Values in conflict |
   |---|---|
   | ember | shipped 182 / extracted 342.5 / registry 342 |
   | press | shipped 188 / extracted 98 |
   | open | shipped 234 / extracted 214.5 |
   | numb | registry 90 / extracted 149.5 |
   | light | registry 200 / extracted 80.5 |
   | trace | registry 210 / extracted 85.5 |
   | crash | registry 178 / extracted 91.5 |
   | believe | registry 178 / extracted 123 |
   | fade | registry 240 / extracted 171.5 |
   | return | registry 110 / extracted 54 |
   | ache | registry 60 / extracted 37.5 |
   | remember | registry 65 / extracted 73.5 |
   | howl | registry 261 / extracted 253 |

   Kingdom 19.5 and receive 22.5 are almost certainly not reveals.
9. **Carrier changes vs the catalog and the app.** Drafts corrected the catalog carriers:

   | Score | Catalog was | Corrected to |
   |---|---|---|
   | hold | 136 | 98 |
   | speak | 192 | 138.6 |
   | still | 110 | 138.6 |
   | receive | 240 | 146.8 |
   | dissolve | 108 | 116.5 |
   | kingdom | 136 | 110 |
   | inshadow | 136 | 146.8 |

   The app's DSP **overrides the carrier at 10s** (SKILL.md:249, 525), which contradicts `fixed:true` in every Score. Which wins?
10. **Wake Me Up carrier.** song-registry:122 gives D3 146.8 *absent root*; wake.score.json:191-202 gives A2 110 *absent fifth* (presence 0.78).
11. **Verb collision `still`.** Track 1 was renamed `ember` (ember:536), but still-ajna:331 still asks for a rename. The file stem `still-ajna` ≠ `identity.id` `still`, which breaks score-format rule 3's filename-stem convention (score-format:133).
12. **Track 27 hardcoded `Score.cross`** in Swift with Ameno constants (speak:352; SKILL.md:153). Meanwhile cross is catalogued as Track 38 and has no audio URL.
13. **Audio not hosted.** cross, abide, thunderclouds, journey, miss, brave, unfold, wake, want, crave, confront, cherish, lift and ascend are not hosted; return is a 404. These are third-party commercial tracks, and hosting them is a pending decision (journey:895). No `-data.json` is hosted anywhere (`hosted_at` null except four mp3s on meditate/new rows).
14. **App Activity bridge `implemented:false`** in every Score; `writes_recognition` is never fired. The ledger floor (App Activity is the single ledger) is unmet for dances.
15. **Song Phase Labels are inert.** `Track` has no `phaseLabels` (SKILL.md:268, content-registry:101).
16. **Voice.** Lalita voice files are not recorded (cross:1063). The floor *no generated voice* means OL-3 must be human-recorded. The Oracle uses the Claude Haiku API (SKILL.md:82), so generated text in-app must be checked against the floors.
17. **"Nothing scores him."** Fruit weaves that count ("You have crossed {n} times", "This is your {n}th dance") and dwell commentary ("You didn't hesitate") should be checked against the floor. They reflect rather than rank, but the line needs a ruling.
18. **Same audio, three readings.** Thunderclouds audio appears as `thunderclouds` (authored), `play` (Track 52 draft) and half of `purity` (Track 34). README and play:320 prefer the authored Score; the catalog has no thunderclouds row.
19. **Silence footprint discrepancies.** cross is 13% (spec) vs 18.5% (computed); abide is 33% vs 40.8%. The 2.5× claim is overstated (abide:300).
20. **Journey doesn't fit the model.** It is a 59-min DJ set with key confidence 0.38 (journey:897).
21. **song-registry.md is stale.** It still lists 24 "TBD" music slots, while the Scores now name songs for search, dream, rise, light, howl, release, ground, numb, trace, believe, ache, crash, fade, play, enough, remember, move, wild, melt, glow and lose. `earn` and `stay` remain unassigned; still→ember moved.
22. **score-format-v2 header is stale.** It says *"no Score has yet been authored against it"* (lines 6, 796). §7 lists a `Metaphor` field that SKILL.md's field list lacks.
23. **thunderclouds:288 `law_implication` is stale.** It says *"abide uses A's PRESENT root"*, but abide was corrected to absent_fifth (abide:715-716).
24. **registry_number collision.** The spec example gives cross `registry_number 28`; abide carries `registry_number 28` (abide:7); cross's own file has null.
25. **BPM artifacts** (172.3 on speak, lose and inshadow; 152 on unfold and confront) feed `types_at_bpm` seed typing speeds. These need correction before the Loop uses them.
26. **Breath model fields** hue, oneLine, carrierTiers and beatTiers are hardcoded in Swift (content-registry:110). The Archive mis-types breath sessions as chakra (109).
27. **Story vs energy (ruling 5).** The Reading Space prose layers are story (B.10). Only seeds, recognition one-liners and fruit lines belong in the Mandala.

---

## D · Coverage proof

All files were read with the Read tool, line 1 to EOF. Line numbers above cite the Read view. `wc -l` counts newline characters, so the last line without a trailing newline shows as wc+1 in Read. No assigned file was skipped or partly read. No `*-data.json` was opened (outside the assignment).

| File | wc -l | Lines read | Method | md5 (8) |
|---|---|---|---|---|
| SKILL.md | 532 | 1–533 (all) | Read | 5e6a1a3e |
| references/score-format-v2.md | 863 | 1–864 (all) | Read | 2e1f1ac8 |
| references/song-registry.md | 126 | 1–127 (all) | Read | 04dbd171 |
| references/content-registry.md | 204 | 1–205 (all) | Read | 0f7c6327 |
| scores/README.md (extra) | 60 | 1–61 (all) | Read | — |
| scores/abide.score.json | 1352 | 1–1353 | Read | 17865d7c |
| scores/ache.score.json | 341 | 1–342 | Read | 1f3dd8fb |
| scores/ascend.score.json | 346 | 1–347 | Read | 5232f7bb |
| scores/believe.score.json | 347 | 1–348 | Read | a74f96f9 |
| scores/brave.score.json | 376 | 1–377 | Read | c551ac8f |
| scores/build.score.json | 356 | 1–357 | Read | 9dd6bce3 |
| scores/cherish.score.json | 330 | 1–331 | Read | a2bcc8d7 |
| scores/confront.score.json | 343 | 1–344 | Read | 41382858 |
| scores/crash.score.json | 335 | 1–336 | Read | ee541c74 |
| scores/crave.score.json | 360 | 1–361 | Read | 816d37f1 |
| scores/cross.score.json | 1244 | 1–1245 | Read | 2f84c28f |
| scores/dissolve.score.json | 369 | 1–370 | Read | c8d8aee8 |
| scores/dream.score.json | 466 | 1–467 | Read | d18e77dc |
| scores/ember.score.json | 771 | 1–772 | Read | 4b5c4cea |
| scores/enough.score.json | 355 | 1–356 | Read | e3474cae |
| scores/fade.score.json | 346 | 1–347 | Read | 17e06ec8 |
| scores/follow.score.json | 351 | 1–352 | Read | a6164af7 |
| scores/glow.score.json | 340 | 1–341 | Read | 74cfa2e7 |
| scores/ground.score.json | 434 | 1–435 | Read | bae00c06 |
| scores/hold.score.json | 428 | 1–429 | Read | 5314ed82 |
| scores/howl.score.json | 386 | 1–387 | Read | 512c85fd |
| scores/inshadow.score.json | 399 | 1–400 | Read | 74b96524 |
| scores/journey.score.json | 932 | 1–933 | Read | cd2b6e9a |
| scores/kingdom.score.json | 493 | 1–494 | Read | 092550be |
| scores/lift.score.json | 345 | 1–346 | Read | dd039122 |
| scores/light.score.json | 410 | 1–411 | Read | 82b4f43c |
| scores/lose.score.json | 381 | 1–382 | Read | f4807530 |
| scores/melt.score.json | 386 | 1–387 | Read | 9b9c30d2 |
| scores/miss.score.json | 376 | 1–377 | Read | 52dfd4fc |
| scores/move.score.json | 355 | 1–356 | Read | 62b906df |
| scores/numb.score.json | 510 | 1–511 | Read | 33b7d758 |
| scores/open.score.json | 365 | 1–366 | Read | d38fb336 |
| scores/play.score.json | 356 | 1–357 | Read | 71d8fcf8 |
| scores/press.score.json | 334 | 1–335 | Read | 7f99a175 |
| scores/receive.score.json | 363 | 1–364 | Read | 9da474a0 |
| scores/release.score.json | 499 | 1–500 | Read | 97b9ed24 |
| scores/remember.score.json | 339 | 1–340 | Read | 5571fb45 |
| scores/return.score.json | 371 | 1–372 | Read | 550c6af3 |
| scores/rise.score.json | 652 | 1–653 | Read | ba7272a2 |
| scores/search.score.json | 383 | 1–384 | Read | e17541fc |
| scores/speak.score.json | 390 | 1–391 | Read | eaeb0294 |
| scores/still-ajna.score.json | 366 | 1–367 | Read | a7ef6710 |
| scores/thunderclouds.score.json | 553 | 1–554 | Read (the source is hand-formatted with long lines up to 776 chars; Read displayed them whole; a pretty-printed copy was also made in scratch) | 4c28df97 |
| scores/trace.score.json | 336 | 1–337 | Read | 0fe8a6e0 |
| scores/unfold.score.json | 372 | 1–373 | Read | 68cf1b9e |
| scores/wake.score.json | 361 | 1–362 | Read | 8c97a67a |
| scores/want.score.json | 340 | 1–341 | Read | 2b187f84 |
| scores/wild.score.json | 340 | 1–341 | Read | 1c7ee55c |

That is 48 score files (3 authored + 45 batch drafts) plus 4 assigned references/SKILL and 1 extra (README). A `python3 -I` pass over all 48 Scores was used only to cross-check the values in the A.10 table against what was read; it was not a substitute for reading. For the room mapping in A.12, register `05-chakra-corpus.md` lines 389-421 were consulted by grep (it is not part of this assignment).
