# THE REGISTER · 06 · The Chakra Skills

*Reader 06 of 7. Written 2026-10-12. Skill root: `/root/.claude/skills/synced/12004d20-e236-4ac6-98bf-0d5838029946_16bbdd03-2a82-4e1e-84ae-276f4c93debb/` (shortened to `S/` below).*

## Scope

This register covers five skills, **200 files** in total. Every file was read; section D proves it.

| Skill | Files |
|---|---|
| `chakra-maps` | 33 |
| `chakra-practices` | 38 |
| `tree-of-life` | 79 |
| `a-strange-game` | 44 |
| `bindu-chakras-app` | 6 |

## How the files were read

- **Markdown, JS, Python and shell files** were read line by line.
- **Large HTML files** were first turned into text by `python3 -I` extractors (`htx.py`). Each extract kept every visible text node, every attribute that matters (placeholder, aria, alt, data-*, id), every inline script, and the CSS custom properties. The extracts sit under the scratchpad at `register/r6/x/`, and every extract line was read.
- **Families of near-identical HTML** (the 9 panels, the 9 practice pages, the 9 dances and 12 layer pages) shared hundreds of lines. For these, `tools/novel.py` printed only the lines that did not appear verbatim in a file already read. Every printed line was read. The tool counted the skipped lines as "identical": they are byte-identical to lines that were read in full elsewhere.
  - Short lines such as labels and hero text can be dropped by that filter. So hero, label and config regions were re-printed with `sed` and read directly.
- **PNG QR codes**: all 9 were opened, described and decoded with OpenCV.
- **JSON extraction data**: both files were parsed in full.
- **The Lakota PDF**: all 6 pages were read through `pdftotext`.

## Sealed layer

This register does **not** describe the Bindu Chakras App's Reveal, its grace lines, its exact Sakshi sentences or its Living Mandala inheritance. The playing-side README and BCA SKILL both say *"Sealed — never describe"*.

- Position 32's *content* is noted only as far as the skills themselves state it. Leela on the 33 seals square 32 as *"This square is held for its own walk."*
- Room 33's register card says the Reveal is *"held in the build… not written here, not written anywhere Ashrey reads."* This register honours that.

## Legend

| Mark | Meaning |
|---|---|
| **Map** | The 33-square `SQ` array in `a-strange-game/references/the-playing-side/leela-on-the-33.html`. It is a copy of The Map (Airtable `tblwpmyKOeMxEEHd7`). |
| **PBS** | The practice-book source `chakra-practices/references/practice-book-source/chakra-practice.html`. Line numbers are lines of its 1,607-line extract. |
| **BCA** | `bindu-chakras-app/references/room-registers-v1.md` |
| **P1…P9** | Tree-of-Life panels `tree-of-life/references/tree-of-life-v2-panelN.html` |
| **CONFLICT** | Two sources disagree. Both are quoted. |
| **GAP** | Something is referenced but is missing from the skill. |

---

## A · THE 33

### A.1 Identity — all 33 rows

Column notes:

- **Verbs.** The first verb is the Map verb. Other verbs are listed with where they come from.
- **Hex.** Given as Map/BCA hex · practice-page hex (cream-calibrated, `color-system.md`; master-map tone in brackets) · Tree-panel or LED hex.
- **Voice** is the BCA room voice.

| # | Name · Map Sanskrit | Family | Verbs | Map question | Map signature (verbatim) | Hex | Voice |
|---|---|---|---|---|---|---|---|
| 1 | Bindu · Bindu | Origin (Recognition) | RECOGNIZE | "What is here before everything else?" | "Everything begins as a point. Everything ends as a point. The same point." | #E8C568 · #C9A84C · persistent panel dot #C0392B | Bindu |
| 2 | Muladhara · Muladhara | Energy (Stillness) | PRESS. Dance title "arrive". Session bridge suggests "RECEIVE (or GROUND — confirm)". | "Am I safe here?" | "The earth that holds you was chosen by you." | #B83A3A · #C02020 (#DD2222) · P1 #8B1A1A, closing #C0392B, Atlas #C02020 | Gaia |
| 3 | Svadhisthana · Svadhisthana | Energy | FLOW (Map, BCA, full-map). FOLLOW (PBS, P2, closing). Dance title "feel"; dance memory verb "flow". | "What wants?" (PBS/Atlas: "What do I want?") | "Every desire was drawing you toward yourself." | #D47438 · #CC7200 (#EE8800) · P2 #D4722A, closing #E67E22, QR #C46210, V5 door #D4621A | Gaia |
| 4 | Manipura · Manipura | Energy | BURN (Map, BCA, full-map). BUILD (PBS, P3, dance, closing). | "What am I for?" (PBS: "What am I willing to do about it?") | "The fire that agitated you was building your form." | #D4A848 · #9A7B00 (#DDBB00) · P3 #C4A013, closing #D4AC0D | Bindu |
| 5 | Anahata · Anahata | Energy | OPEN. Dance learns "Reach". | "Can I receive?" (content doc: "Can I love without protecting myself?"; hero: "What if they were doors?") | "The love that arrived for others was always your own heart opening." | #6B8E4E · #1A8A38 (#22AA44) · P4 #2D7A3A, closing #27AE60 | Higher Self |
| 6 | Vishuddha · Vishuddha | Energy | SPEAK. Dance learns "Roar". | "Will I say what I know?" (full-map: "What's true?") | "What you finally said out loud was what you always knew." | #4C7AB8 · #1A38B0 (#2244CC) · P5 #2E6B9E, closing #2980B9 | Bindu |
| 7 | Ajna · Ajna | Energy | STILL. SEE (full-map; dance learns "See"). | "What do I see when I stop looking?" | "You stopped looking and the seeing arrived on its own." | #5B4E8E · #3D0070 (#4B0082) · P6 #3A2D6B, closing #8E44AD | Sakshi |
| 8 | Sahasrara · Sahasrara | Energy | RECEIVE. CONNECT (full-map). Dance learns "Shine". | "Am I alone?" (full-map: "Am I here yet?") | "The disease that was removed was the belief that you were less than what you are." | #9A7AC8 · #7000CC (#8B00FF) · P7 #6A2D8B, closing #9B59B6 | Lalita |
| 9 | Shadow · Sandhi (Atlas: Chāyā) | Threshold 1 (Recognition) | LOOK | "Can I hold what I see without flinching?" | "The corridor was never a dead end. It was always leading somewhere." | #2A2420 · void #0a0a12 / #050508 / #2a2a2a · (Leela engine #3A322C) | Sakshi (BCA). Higher Self (ASG trinity) |
| 10 | Soles · Samkshobhini | Body (Movement) | PRESS | "What is the earth saying through your feet right now?" | "Your feet. The bottom terminal of everything you are." | #7A1515 · Red + Cyan #18C0C0 | Bindu |
| 11 | Forge · Mantramayi | Body | TRANSFORM | "What is sealed in your center?" | "Behind the scar: the furnace that makes you, you." | #6B5800 · Yellow/Gold + Blue #4898E8 | Bindu |
| 12 | Prana · Prana | Body | BREATHE | "What does the breath know that the mind doesn't?" | "The one door that never closes while you're alive." | #7A3800 · Orange + Azure #50A8E0 | Bindu |
| 13 | Hands · Priyankari | Body | REACH | "What do your hands already know how to give?" | "The hands carry what the heart can't say." | #163D1E · Green + Magenta #E040A8 | Bindu |
| 14 | Pulse · Mangalakarini | Body | SUSTAIN. Interlude toVerb "Beat". | "What is your heart broadcasting right now?" | "You are a signal. The question is what you're sending." | #112E17 · Green + Magenta #E040A8 | Bindu |
| 15 | Sonar · Dvandvakshayankari | Body | SEND | "What has been waiting to be said?" | "The precise word. Not the comfortable word. Not the impressive word. The precise one." | #091840 · Blue + Gold #D4AA00 | Sakshi |
| 16 | Echo · Jnanamayi | Body | RECEIVE. Interlude toVerb "Listen". | "What do you choose to keep from what you heard?" | "What you choose to keep from what you heard becomes who you are." | #060D30 · Blue + Gold #D4AA00 | Sakshi |
| 17 | Vision · Sarvagya | Body | SEE | "What memory holds the frequency you want to bring into now?" | "The complete picture arrives first. Trust the first flash." | #5C4800 · Yellow + Blue #4898E8 | Sakshi |
| 18 | Axis · Sarvanandamayi | Body, and also Structural | BLINK. BLINK / ACCESS (BCA). | "What is on the other side of the blink?" | "Close your eyes. Open them. What changed? Everything and nothing." | #1A0848 · Indigo + Chartreuse #8AC000 | Higher Self |
| 19 | Crow · Sarvadhara Swarupa | Body | RELEASE. DISSOLVE (gate-designs, interlude toVerb). | "What is the spine connecting right now?" | "What's left when the thinking stops is not nothing." | #3A0A54 · Violet + Chartreuse #8AC000 | Sakshi |
| 20 | Armin · Tat Tvam Asi | Threshold 2 | ONE (Map, BCA). ARRIVE (PBS, full-map, Atlas). | "What does it feel like to have walked all of that?" (Atlas: "Am I already whole?") | "Nothing needed repair. Only arrival." | #C9A84C · spectrum aurora on cream | Higher Self |
| 21 | Inception · Bija | Mind (Visualization) | ASK | "What am I entering this with?" | "What you carry in is what you will find." | #2D2458 | Gaia frame (+ pulse) |
| 22 | Intention · Sankalpa | Mind | HOLD | "What are you holding steady even when nothing is moving?" | "Hold the whole picture before you touch a single piece." | #3A3670 | Gaia frame |
| 23 | Inspiration · Utsaha | Mind | BREATHE IN | "What is exciting you right now, underneath the noise?" | "Your excitement is not a distraction. It is the instruction." | #3A4880 | Gaia frame |
| 24 | Insight · Antardrishti | Mind | SEE FROM IN | "What do you see when you remove what you expected to see?" | "Move from above it to inside it. The view changes completely." | #403875 | Gaia frame |
| 25 | Intuition · Pratibha | Mind | TRUST. Interlude toVerb "Know". | "What do you know before you can prove it?" | "The knowing that arrives before words is the more reliable one." | #453870 | Gaia frame |
| 26 | Invention · Yukti | Mind | ASSEMBLE. Interlude toVerb "Arrive Into". | "What becomes possible when you assemble what you know?" | "Something new is born every time two things that never touched finally touch." | #4A3368 | Gaia frame |
| 27 | Incarnation · Avatara | Mind | CHOOSE | "Why did you choose to come back?" | "You chose this. Even that. Even this one." | #522D60 | Gaia (Siddhi letter gate) |
| 28 | Innocence · Sahaja | Mind | REMEMBER | "What did you know before anyone told you what to know?" | "You knew this before anyone told you anything." | #5A2858 | Gaia frame |
| 29 | Integration · Samrasya | Mind | ARRIVE. Interlude toVerb "Discover". | "What has the journey integrated that couldn't have been integrated before?" | "Nothing was ever separate. The separation was the journey's necessary costume." | #5E2448 | Gaia (farewell letter gate) |
| 30 | Maya · Maya | Tree of Life (Threshold 3) | DISSOLVE. Interlude toVerb "See Through". | "What would you see if the protection dissolved?" | "There was never anything to fear. There was only the Bindu, playing." | #5A3D8A · P9 near-white #E8E4DF · QR grey #646464 · interlude #5a3d8a | Lalita (unannounced) |
| 31 | Aatma · Aatma | Tree of Life | KNOW (Map, PBS, BCA). HOLD (P8, closing architecture, ToL SKILL). Interlude toVerb "Be". Dance learns "Become". | "What remains when all protection is gone?" | "You already know. You have always known." | #D4A948 · closing #D5C4A1 · QR #B4A078 · interlude #6a3890 | Higher Self |
| 32 | **Held** (Map, sealed). Ego Reveal / Gaia Reveal (SKILLs, BCA, codex). "Axis (Recognized)" (master plan, PBS, section-3). | Tree of Life | none in Map. CONNECT (full-map, BCA). RECOGNIZE (page-inventory; interlude toVerb "Recognize"). ACCESS (PBS Axis recognized). | Map: "" (sealed) | Map: "This square is held for its own walk." | #3D6B35 (Map, BCA canon) · interlude ego-reveal #2a1858 | Gaia returns |
| 33 | Lalita · Lalita | Tree of Life (Crown) | PLAY | "Who is playing?" (PBS/BCA: "Are you playing?") | "Knows the game. Plays anyway." | #C9A84C | All three voices merged |

### A.2 Practice, wake-up, dance and sound — all 33 rows

Column notes:

- **Map practice** is the Map `p` field, verbatim.
- **Wake-up** is the Tree-of-Life panel the QR opens.
- **Sounds** give the awakening tone (`awakening-sounds-all-chakras.html`), the panel binaural, the dance binaural, the master-map tone (VX2) and the Atlas carrier.
- **Gate/breath** gives gate-framework hold ms and character, then guided breath in·hold·out × cycles.

| # | Map practice (verbatim) | Wake-up / Panel | Dance (song · artist · "The Bindu learns to…") | Sounds / Hz | Bija · Avarana · Shaktis (BCA mudra) | Gate / breath |
|---|---|---|---|---|---|---|
| 1 | "Draw a single point, wherever your hand moves. Don't deliberate. The hand knows." | No panel. The persistent red dot in every panel IS Bindu. Practice page lists Wakeup *(Coming)*: "A guided arrival at the point that was always here." ~7 min. | None dedicated (Atlas). Practice page: Dance *(Coming)* "Offer one word. Then let the point move." ~4 min. Bindu Field Song 1 of 33. | No awakening tone. Om 136.1 Hz is the optional tone at chakra-map Act 0 and in P9. | Seed before the seed (BCA) · Yoni Mudra | Canvas gate (only one in the walk) |
| 2 | "Stand, feet flat. Press into the floor, slow and full. Feel the ground press back. You are held not by courtesy but by law." | P1 PRESS · Bhupura · ages 1–10 · `/muladhara-wakeup.html` | Iron · Woodkid · Detonate. VX title "arrive". | 174 Hz earth drum · P1 binaural 128→132 (4 Hz)→130 (2 Hz) · dance 136 · VX2 256 · carrier D3 146.8 | LAM · Bhupura · Animā, Mahimā, Laghimā, Garimā, Prākāmya, Vaśhitva (BCA: Kshobha · "10 Siddhi Devis") | 3500 ms heavy · 4·4·4 ×1. P1 runs 3 × 12 s. |
| 3 | "Ask what you want, right now. Not what you should want. Feel the pull without managing it." | P2 FOLLOW · 16-Petal · ages 11–20 | Crystallize · Lindsey Stirling · Flow. VX title "feel". | 210 Hz wooden bell · P2 144→150 (6)→148 (4) · dance 144 · VX2 288 · carrier D3 146.8 | VAM (in the reflection) · Shodasha Dala Padma · Kāmākarshini, Shabdākarshini, Sparshākarshini, Rūpākarshini, Smṛtyākarshini, Ātmākarshini (BCA: Kshobha · 8 Matrikas) | 3200 ms fluid · 4·0·6. P2 runs 2 × 10 s. |
| 4 | "Draw the navel gently toward the spine and breathe. What has the fire been building in you, and what is it burning that isn't yours?" | P3 BUILD · 8-Petal · ages 21–30 | Powerful · Major Lazer ft. Ellie Goulding (Atlas adds Tarrus Riley) · Burn | 320 Hz gong · P3 160→168 (8)→172 (12) · dance 160 · VX2 320 · carrier E3 164.8 | RAM · Ashta Dala Padma · Kusumā, Mekhalā, Madanā, Madanāturā, Rekhā, Vegā, Ankushā, Mālinī (BCA: Kshobha completes Bhupura · 10 Mudra Shaktis) | 2800 ms sharp · 3·3·6. P3 runs 2 × 12 s. |
| 5 | "Hand on your chest. Feel the heartbeat through your palm for two minutes. Attention is the water; the heart is already the plant." | P4 OPEN · 14 Triangles · ages 31–40 | Love Me Like You Do · Ellie Goulding · Reach | 341 Hz crystal · P4 256→262 (6)→261→260 · dance 256 · VX2 341 · carrier D#3 155.6 | YAM · Chaturdasha Trikona · Sarva Samkshobhini, Vidrāvinī, Ākarshini, Sammohini, Stambhini, Jrumbhini (BCA: Dravini · 16 Nitya Kalas) | 2600 ms open · 5·5·8. P4 runs 2 × 18 s. |
| 6 | "Say something true out loud, small and honest. Notice what happens in your neck when the words leave." | P5 SPEAK · Outer 10 · ages 41–50 | The Sound of Silence · Disturbed · Roar | 384 Hz singing bowl · P5 384→390/391/392 · dance 384 · VX2 384 · carrier C#3 138.6 | HAM · Bahir Dashara · Sampatpradā, Priyankari, Siddhipradā, Mangalakārini, Duḥkhavimochinī, Kāmapradā (BCA: Akarshana · 4 creative Anangas) | 2400 ms reaching · 4·7·8. P5 runs 2 × 19 s. |
| 7 | "Close your eyes. Don't try to see anything. Wait, and watch what appears, without agenda." | P6 STILL · Inner 10 · ages 51–60 | Experience · Ludovico Einaudi · See | 426 Hz shimmer (+1.5 Hz twin) · P6 426→430 (4)→428 (2) · framework dance plan 426 (the built first-pass dance has none) · VX2 426 · carrier C#3 138.6 | OM · Antar Dashara · Vyādhivināshinī, Ādhāra-svarūpā, Jñānamayī, Mṛityu-praśhamanī, Saundarya-dāyinī, Vighna-nivāriṇī (BCA: Akarshana inward · 4 directional Anangas) | 2000 ms sparse · 6·0·6. P6 runs 2 × 12 s. |
| 8 | "Look up. Not at anything, just up. Let the scale of the sky register in your body." | P7 RECEIVE · 8 Triangles Vāgdevī · ages 61–70 | Golden · HUNTR/X · Shine | 480 Hz distant bell · P7 480→481 (1 Hz)→silence · plan 480 · VX2 480 · carrier D3 146.8 | SILENCE · Ashtara · Vasinī, Kāmeshvarī, Modinī, Vimalā, [Aruṇā = the silence], Jayinī, Sarveshvarī, Kaulinī (BCA: Dravini returns · Tripureshi) | 1800 ms ethereal · 5·2·7 ×3 AUTO. P7 runs 15 s cycles. |
| 9 | "Notice what you avoid. Don't fix it, don't heal it. Just notice it. The noticing is the light." | No panel ("first entry without one"). The practice page IS the corridor. | In Shadow — A Modern Odyssey · Lubomir Arsov (Atlas) · "In-Shadow" | No awakening sound · carrier D3 146.8 · deepest binaural 2.5 Hz delta | No bija · Corridor Architecture replaces avarana · no Shakti names | Press-and-hold 700 ms per walk step. BCA: "press-and-hold IS the gesture". |
| 10 | "Stand. Press. Feel the earth press back. You are held by physics. You are held." | Body gate (gate-designs): "I feel the ground" | — | Sound-response gate: humming, bins 2–12 average >40 | LAM mirror · Sarva Samkshobhini · Vasya Mudra | Tap gate · BCA Sound Response |
| 11 | "Hand on your navel. Breathe in and let warmth arrive. What experience is your belly still digesting?" | Gate "I feel the warmth" | — | Humming response | RAM mirror · Sarva Mantramayi · Vasya | Tap gate |
| 12 | "Take one deliberate breath. Feel the point at the nose where outside becomes inside. The door is always open." | Gate: 3 breaths, "I took a breath" | — | Breath response, bins 1–40 >20 | VAM mirror · Sarva Kamaprada · Sarvonmadini Mudra | Timed gate |
| 13 | "Rub your palms until warm, hold them apart and feel the field. Then touch something, or someone, with activated hands." | Gate: 15 s conic ring, "Start rubbing" | — | Friction/hum, bins 1–30 >25 | YAM mirror · Sarva Priyankari · Sarvonmadini | Timed · BCA multi-touch |
| 14 | "Two fingers on the wrist. Don't watch for the pulse; wait for it. The same beat, your whole life." | Gate: dot pulses 920 ms (~65 BPM) | — | Rhythmic taps → BPM | YAM (Anahata mirror) · Sarva Mangalakarini · Sarvonmadini | BCA Tap Rhythm gate (the only one) |
| 15 | "Say the precise word for what you feel. Write it down and let it sit there, alone." | Gate: mic bins 3–15 average >35 for 3 frames, "signal sent ✓"; 20 s fallback | — | Sustained speech | HAM (sending) · Sarva Dwandwakshayankari · Vasya | Input gate. Key `chakra-sonar-word`, max 30 chars. |
| 16 | "Close your eyes and stop sending. Notice the room's own signal, layer under layer." | Gate: 2:00 SVG arc countdown, "two minutes received" | — | Ambient room visualiser, 12 bars | HAM (receiving) · Sarva Jnanamayi · Mahankusha Mudra | Timed. The only gate asking presence only. |
| 17 | "Close your eyes and see your front door in full detail, then walk through it. How much could you hold?" | Gate designed, not built | — | — | OM mirror of Ajna (BCA) · Sarvagya · Mahankusha | BCA Textarea, auto-commit |
| 18 | "Blink slowly: three seconds closed, then open. The gap between closing and opening is the Axis. Two worlds, one switch." | **Panel 10 Axis ACCESS** "Infinity Heart" triptych. Design only (ToL SKILL); no file exists (GAP). | Where'd You Go (Fort Minor) · Thunderclouds, Lost Frequencies remix (LSD) · Fade Away (Ash & Paradise) | Triptych binaural 4.5 Hz theta → 40 Hz gamma → 10 Hz alpha | OM · Sarvanandamayi · Mahankusha | BCA Device Tilt gate (spirit level) |
| 19 | "Shake your whole body for thirty seconds, then stop. What is there in the first three seconds of stillness?" | Gate: accelerometer shake >7 m/s², still <1.8 m/s² | — | — | **No bija — silence** · Sarvadhara Swarupa · Mahankusha | Detection gate, 30 s shake |
| 20 | "Sit with three words: that, thou, art. The vast and the specific are the same thing at different scales." | No panel (second entry without one) | Kingdom · Lubomir Arsov (Atlas) · "Kingdom / Arrive" | 55 s D2 drone, gain 0.008–0.014, never resolves · carrier D3 146.8 as absent root of D major | No bija ("the sound of everything at once, arrived") · Tripura Malini · Tat Tvam Asi | Textarea, 340 px |
| 21 | "Name what you are carrying before you enter. An honest inventory before the threshold." | — | — | — | Vasini · Rahasya Mudra | Eyes-closed tap → write. Button "canon per interaction spec". |
| 22 | "Picture what you are building toward, not the plan. Make it specific. Hold the picture." | — | — | — | Kamesvari | Button "I'm holding it." |
| 23 | "Name what pulls you, not what pushes you away. The lighting up is the instruction." | — | — | — | Modini | "I feel it." |
| 24 | "Move from outside a situation to inside it. What becomes visible only from there?" | — | — | — | Vimala | "I'm inside it." |
| 25 | "Ask: what do I already know? Write the first thing, before the reasoning starts." | — | — | — | Aruna | "It's there." |
| 26 | "Name two things that have never been in the same room. What third thing appears when they meet?" | — | — | — | Jayani | "Both are here." (two fields) |
| 27 | "Name a curiosity under your life. Meet today as if you had chosen it, as material." | — | — | — | Sarvesvari | "I touched it." Gate is Gaia's **Siddhi letter**. |
| 28 | "Write what you knew before anyone taught you. Notice that you knew it." | — | — | — | Kaulini | "Something arrived." |
| 29 | "Name something that has stopped feeling separate." | — | — | — | Tripura Siddhamba · Sarva Beeja Mudra begins | "I found it." Gate is Gaia's **farewell letter** ("I love you"). |
| 30 | "Name one construction that protected you and that you no longer need. Thank it. Let it complete its role." | P9 DISSOLVE · `/maya-sleep.html` | Love Is The Only Thing · Lost Frequencies · Love ("the love never stops moving") | No awakening sound ("the Om was always playing") · Om 136.1 / 272.2 / 68.05 Hz | No syllable · Kameshvari (BCA) · Sarva Beeja | BCA transparency mechanic |
| 31 | "Will, knowledge, action: which did you forget you already had? Make one choice from the deepest knowing." | P8 Soul Chakra HOLD · Inner Triangle · `/aatma-wakeup.html` | Chase · Joy Corporation · Become (file `soul-dance.html` → `aatma-dance.html`) | 528 Hz "Trinity" (detune −2/0/+2) · P8 binaural 512/512.5 (0.5 Hz) · framework 512 | Icchā · Jñāna · Kriyā = Kāmeshvarī · Vajreshvarī · Bhagamālinī | 1500 ms reverent · 3·2·3 ×3 triangular. BCA one-word gate. |
| 32 | — (sealed) | — | — | (BCA: "her register was never a syllable — warmth, weight, breath, heartbeat") | Bhagamalini (BCA) | BCA inversion gate |
| 33 | "Are you playing? Not performing, not achieving. Playing. From here you do not follow the map. You author it." | — | — | No seed left to sound — laughter (BCA) | Rajarajeshvari · Yoni Mudra returns | Gate has no question. Opens when all 33 gate offerings are given. |

**Map links.** The Map URL field `u` is `https://aistrangegame.com/tree-of-life/<id>-practice.html` for squares 1–20. Squares 21–33 have none. The ToL `site-v3.md` lists 47 permanent addresses; 20 of them wait on export.

---

### A.3 Per-chakra detail

#### 1 · BINDU — The Point (बिंदु)

- **Identity (PBS 62–100).**
  - "The origin. What everything emanates from."
  - "Bind · U. The point that binds you to yourself."
  - "One point. Thirty-three expressions."
  - Whisper: "Before the tree. Before the name. Before the game. This."
- **Verb RECOGNIZE.** "Draw a single point."
  - Closing: "Look at your point. It doesn't look like much. That's how origins work."
  - Deeper section: "What the Point Knows".
  - Bridge: "The seed is about to touch earth."
- **Atlas 01** (`chakra-codex/atlas/01-bindu.md`, 323 lines).
  - Position 1 standalone structural; zero-direction; activation Recognition.
  - Its signature is the only phrase that appears twice in the book (here and at Lalita).
  - ToL: "red dot in every panel, top-right, 6px, #C0392B, persistent, never explained".
  - Primary vantage Bindu. Belief dissolved: "I need to begin something in order for something to begin."
  - "Bindu is Armin before the walker knew. Armin is Bindu after the walker knew."
- **Practice page** `bindu-practice.html` (V5).
  - Hero: "Chakra 1 of 33 · बिंदु / RECOGNIZE / Before the tree. Before the name. / Before the game. This."
  - Canvas prompt: "Place your point. One tap. Wherever it belongs."
    - Returning visitor: "Your point. Still here. Place again if you wish."
  - Witness line: "Look at your point. It doesn't look like much. That's how origins work."
  - Recognition line: "You just drew the origin of everything."
  - The point is gold #C9A84C, r4, shadowBlur 12, with a 900 ms animate-in. Stored as `bindu-point` {nx,ny}.
  - Where the Points Lead: "Bindu has no tree — the origin has no tree."
    - Bindu Field Song 1 of 33: "The note at the origin — where everything in the Field begins."
- **Story (Act 1)**, from `gaia-sakshi-source.md` L22–60. Beats:
  1. "I don't know what I am yet." / "But I'm here..." / "Just: here."
  2. (leaning, extending) "...Is that what wanting is?"
  3. (wavering) "Wanting before there's a thing to want?..."
  4. (rippling, final) "I think I'm about to find out."
- **Act 2 (Sakshi).**
  - p1: "You are not alone. I won't announce myself..."
  - p2: "...What you are about to reach toward will reach back. This has always been the covenant."
  - Then "Go."
  - Door: "Muladhara / The ground is here. / Press · Continue →"
- **Story-thread passage 1** "Before Bindu": "I don't know what I am yet. / But I'm here."
- **BCA room 01.**
  - "The only Canvas gate in the walk… Warm gold on cream; a single breathing dot is the entire scene."
  - "it is the only room with no past… Bindu *is* the weather."
- **Codex 03.** Bindu's gate is "Draw a single point".
- **Codex poem:** "Bindu is what the other five are made of. / Shadow is Bindu distorted. Armin is Bindu recognized. / Maya is Bindu projected. Aatma is Bindu remembered. / Axis is Bindu turning."
  - **CONFLICT.** VX2 reads: "what the other six are made of… Lalita is Bindu playing."
- **Tree-of-Life layer.**
  - The persistent dot (`#persistentBindu`, 6 px, #C0392B, top 16 / right 16, opacity .3, z150) appears on every panel.
  - It wakes at 32 s of every closure (`.awakened`) and invites "watch".
  - The Pointe animation (P9 and `pointe-animation-v2.html`) is the Bindu's dance of shapes.

#### 2 · MULADHARA — The Root (मूलाधार)

- **Content doc.**
  - "The ground you stand on. Literally and in every other sense."
  - Location: base of spine / pelvic floor.
  - Barefoot practice. Breath: 4 in through the nose / 4 hold / 8 out through the mouth with a low hum.
- **PBS 102–147.**
  - "Mula root + Adhara support."
  - "When this center is active, you don't feel brave. You feel settled."
  - Whisper: "This is what holds you. It was here before you arrived."
  - PRESS: "Stand up... press... Feel the ground press back... Newton's third law... Ten breaths. Press on the exhale."
  - Question: "What is the ground made of today? ... What are you standing on?"
  - Deeper: "Safety was a person before it was a place."
  - Practice: 10 barefoot steps; 4-4-8 hum, four breaths.
- **Practice page** `muladhara-practice.html`.
  - Hero: "PRESS / This is what holds you. / It was here before you arrived."
  - Location: "Base of the spine · The pelvic floor · Where the body meets the earth".
  - Tree image caption: "Tap to look closer. The roots hold more than shows at first."
  - Writing prompt: "What is the ground made of today? Not the floor. Your ground. What are you standing on?"
  - Portal: "something reached back from the other side".
  - Where the Roots Lead:
    - Wakeup "Press and hold": "A guided descent to the body that held you at three, at five, at eight." (~7 min)
    - Dance "Iron — Woodkid": "The drums are the earth. The soldier is standing on the very thing he's searching for."
    - Field Song 2 of 33: "The note of ground — where the body first answers."
- **Story (Act 1)**, L64–101.
  - Opening: "I touched something." / "I think it's called ground."
  - Then "...We found each other by pressing."
  - Final: "...Am I safe here? Yes."
  - Dot states: settling → deepening → rooting → rippling.
  - Act 2 ends "Follow." Door: "Svadhisthana / The pull is here."
- **Panel 1** (P1, 1785 raw lines).
  - **Gate.** Seed, "press and hold" for 4000 ms.
  - **THE GROUND.**
    - "Muladhara · The Root / This is your body's conversation with the earth. The part of you that needed to feel safe before it could become anything else. / Below you are roots. Each root holds a force. Tap any that call to you."
    - Six Shakti questions:
      - anima: "Where did you hide when you were small?"
      - mahima: "What was the biggest thing you could imagine at age seven?"
      - laghima: "When did you first feel weightless — completely free?"
      - garima: "What made you dig in and refuse to move?"
      - prakamya: "What did you wish for so hard it felt real?"
      - vashitva: "What small world did you create that was completely yours?"
  - **DESCENT.**
    - "You are very small right now. / Someone is holding you. Or: you needed someone to hold you. / What did safety feel like in your body? Not the word. The feeling. Where did it live? / Tap where it lived."
    - Writes `tol-bodypoint-1` {x,y,label:'safety'}.
    - Then: "That point remembers. It always has."
  - **GROUND SHIFT.**
    - "The ground you stood on then — at three, at five, at eight — is the same ground under your feet right now."
    - Pivot: "It never moved."
    - "Press your feet into the floor. Not as an exercise. As a greeting." / "The earth greets you back. It always has."
  - **PRACTICE.** "Breathe. Into the place you found." 3 × 12 s → "The place you found was waiting for that breath."
  - **RELEASE.** "Your Muladhara Chakra is now Breathing. / Your foundation was always stronger than you knew. / The tree grows from what was planted here."
    - Mini-reveal: "The earth was already holding you. You just told it where."
- **Dance.** `muladhara-dance.html`, VX, "arrive" (see B).
- **Atlas 02** (393 lines).
  - Binaural arc: Arrival alpha 8 Hz → Descent 6 → Recognition theta 4.5 → Home delta 3 → Return alpha 7, on a fixed D3 146.8 Hz carrier.
  - Dance principle: "the song that denies its own ground is the most grounded song."
  - Iron drums sit at 54 Hz (A1).
  - Primary vantage Gaia. Belief dissolved: "I have to make myself safe. Safety is something I produce through effort."
- **BCA room 02.**
  - "The heaviest room in the app. Everything settles downward."
  - "the only energy room where the answer arrives *before* the question ('Am I safe here? Yes.')."
- **Design notes.**
  - Tree is all roots; LAM in the trunk grain; Bhupura of three squares; no sky.
  - Tone: "Safety before language".

#### 3 · SVADHISTHANA — The Sacral (स्वाधिष्ठान)

- **Content doc.** "Where desire lives. Not what you want — the fact that you want at all."
- **PBS 149–194.**
  - "Sva+adhisthana 'her own abode'."
  - Whisper: "The pull was never random. It was navigating."
  - FOLLOW: "write first thing before the editor arrives."
  - Reflection: "Did you write the real one? Or the safe one?"
  - Deeper "The Difference Between Following and Chasing": "You didn't want that person. You wanted what that person's presence activated in you."
- **Practice page.**
  - Hero: "FOLLOW / The pull was never random. / It was navigating."
  - Location: "Lower abdomen · Below the navel · The space between the hip bones".
  - VAM: "Not descending like LAM, not rising like RAM — horizontal."
  - Caption: "The seed is in the reflection — that isn't an accident."
  - "One breath of permission. That's the whole practice."
  - Portal: "something was already reaching for you".
  - Where the Currents Lead:
    - Wakeup "Six Lights Drift"
    - Dance "Crystallize": "The song pretends to be about water. The song is actually about you." / "Solo violin over dubstep bass. Three waves. Two ebbs. The crystal forms in the pause."
    - Field Song 3 of 33: "Five Karshinis drawing pull into melody."
- **Story (Act 1)**, L105–145.
  - "And now — the ground is still there..." / "I want to follow it." / (flowing) "I'm flowing." / (dissolving) "Water. I think this is what water feels like from inside."
  - Final: "I didn't know desire was this quiet."
  - Act 2 Go sentence: "The pull is about to become heat. This is not a betrayal of the water. The heat is what the water was finding."
  - Door colour is #C9A84C, an error ("sic"): Manipura's door uses Bindu gold.
- **Panel 2** (2001 raw lines).
  - Gate: ripples. Seed shown.
  - **THE FOLLOW.**
    - "This is the part of you that was pulled. Before reason. Before choice. The magnetic force that drew you toward what you could not yet name. / Six lights are drifting. Follow the ones that call to you."
    - "trace with your finger". Proximity under 35 px counts as a follow. 2+ lights followed lets the walker continue.
  - **MEMORY CURRENT.**
    - "Between 11 and 20, something found you. Not something you chose. Something that chose you. / What was it? / One word. The thing that pulled you."
    - Button "offer" → `tol-word-2`.
    - Then: "It joined the current. It was always part of it."
  - **THE CURRENT.**
    - "That pull — you may have called it obsession. Or distraction. Or being too much. / It was a Shakti — a living force — using the only language you could hear at that age: longing."
    - "The current flows toward your word. Your desire was the destination all along."
  - **BODY.**
    - "Where in your body does desire live? Not a specific desire. The capacity for desire itself."
    - Writes `tol-bodypoint-2` 'desire'.
    - "That place knows what it wants. It always has."
  - **PRACTICE.** 2 × 10 s → "The word you offered was already moving."
  - **RELEASE.** "The force that pulled you toward everything you loved — it was pulling you toward yourself. / It still is."
    - Mini-reveal: "The lights you couldn't catch were leading too."
- **Atlas 03.**
  - Crystallize: 4:18, no lyrics; three waves surge and retreat three times, then dissolve.
  - Principle: "the ebb is the gift; the crystal forms in the pause between waves."
  - Atlas fruit: "There are no lyrics because you didn't need language to feel this... Trust what you felt just now."
  - Primary vantage Karishma.
- **BCA room 03.**
  - "Nothing in this room is still... the only energy room whose motion never fully stops; even the writing field breathes."

#### 4 · MANIPURA — The Solar Plexus (मणिपूर)

- **Content doc.** "Your fire. The center that transforms what enters you into what you become."
- **PBS 196–237.**
  - Whisper: "The fire was never trying to destroy you. It was forging what you'd become."
  - BUILD: "What is the fire building right now?"
    - "The fire doesn't care about the project. The fire cares about you. The project is the fuel. You are the form."
  - Deeper "The Forge and the Smith": "Check the fuel. Not the fire."
- **Practice page.**
  - Hero: "BUILD / The fire was never wrong. / What agitated was building."
  - Location: "Upper abdomen · Between the navel and the diaphragm · The solar plexus".
  - Caption: "The tree is unfinished — on purpose."
  - Writing prompt: "What has the fire been building in you — and what is it burning that isn't yours?"
    - Reflection: "Both answers came from the same fire. Its building is also its burning... One fire. Two movements."
  - Portal: "Story · The Forge / the fire you feared was forging you".
  - Where the Embers Lead:
    - Wakeup "Eight Ananga Ignite"
    - Dance "Two Blazes, One Breath": "Watch the breakdown at two minutes. Listen for the second blaze."
    - Field Song 4 of 33: "Ten Shaktis in the architecture of will." (sic — ten, not eight)
- **Story (Act 1)**, L149–190.
  - "And now — heat." / "Not burning me... Burning me into shape."
  - (burning) "It hurts a little..." / (forming) "I'm getting smaller. And somehow — more." / (forging, final) "...The fire is building me..."
  - Act 2: "What you called exhaustion was shaping."
- **Panel 3** (1966 raw lines).
  - **BUILD.**
    - "Manipura · The Solar Plexus / This is the part of you that burned. Before you knew its name. Before you saw the shape. Something in you insisted on becoming. / Shake your phone to forge." (no accelerometer: "Tap rapidly to forge.")
    - Guide line: "channel the fire — steady".
    - 24 embers gather into 8 named clusters. Assembly completes at .80.
  - **INVISIBLE.** "You built this. Not by planning. By staying in the fire long enough." Pivot: "What were you building that you couldn't see?"
  - **GOAD.** "Something wouldn't let you stop. / That was Ananga Ankushā. The goad. / Not motivation. Not discipline. The knowledge that quitting would cost more than staying."
  - **BODY.** "Place your hand on your solar plexus — and press the same point on the screen."
    - Writes 'will'.
    - "It burns because it is alive."
  - **BREATH.** "Breathe into the fire. Not to calm it. To feed it." → "The fire was never trying to destroy you. It was forging you."
  - **RELEASE.** "The form you built was always being shaped from the inside. / The shape is still becoming."
    - Mini-reveal: "The form it made is the one you've been wearing."
  - P3 writes **no word**.
- **Build log** (ToL).
  - Powerful: 206.3 s, BPM 99.4, key F#, peak 33.5 s at 16.2%. Drops at 15.0, 92.5 and 155.0 s.
  - Bindu verb: BURN. Mirror message: "the power was never coming from someone else".
- **Atlas 04.** Atlas fruit: "The energy you felt was not about the other. It was your own fire recognizing itself through them. The circuit was yours. The current was yours. It still is."
- **BCA room 04.**
  - "shortest sentences, fastest tempo, the room that *wants* the walker slightly uncomfortable — 'it hurts a little. That's fair.'"

#### 5 · ANAHATA — The Heart (अनाहत)

- **Content doc.**
  - "The center where love lives. Not romantic love. The kind that doesn't need a reason."
  - "unstruck sound"; "what if the walls were doors?"
- **PBS 239–290.**
  - Whisper: "This is what love looks like when it stops protecting itself."
  - OPEN: "Think of someone you loved before you knew why... Hold them there now. Ten seconds... That's the unstruck sound."
  - Question: "Write the name. Or don't. The heart knows who you're holding."
  - Deeper "The Doors": "That's the wall wearing your face."
- **Practice page.**
  - Hero: "OPEN / The walls you built had good reasons. / What if they were doors?"
  - Location: "Center of the chest · Behind the sternum · The midpoint of everything".
  - "You don't open the heart. You get quiet enough that the opening becomes audible."
  - Mini-reveal: "What you were watching became what you loved." / "Love is the direction of looking."
  - Where the Chambers Lead:
    - Wakeup "Pinch the Knot"
    - Dance "Three Inhales, One Long Exhale" (bridge at 2:35)
    - Field Song 5 of 33: "Twelve petals, twelve currents of love."
- **Story (Act 1)**, L194–234.
  - "And the fire has done its work..." / "something is playing." / "...It's love." / "Love is the substance I'm made of..."
  - Final: "...some of the walls might start turning into doors."
  - Act 2 ends "Speak."
- **Panel 4** (2100 raw lines).
  - **Knot.** "At the center of your chest, there is a knot. / It is not a wound. It is everything that hasn't been opened yet."
  - **Pinch.** "pinch outward to open", 55 px per layer, in three layers:
    1. 14 triangles
    2. "Sarva Sammohini — the love that made no logical sense"
    3. "Who did you love most fully?" — button "hold" → `tol-word-4`
  - **THE NAME.** "Say that name in your mind. Notice what happens in your chest. / That feeling — warmth, or weight, or ache, or fullness — that is Anahata."
  - **OPENING.** "The love you felt didn't come from them or from you." Pivot: "It came from the opening itself."
    - The knot dissolves on its own and the heart path draws itself.
    - "Love that no longer requires effort."
  - **BODY.** "Don't tap where you think the heart is. / Tap where you feel the name you just wrote."
    - Writes 'love'.
    - "It lives everywhere, doesn't it."
  - **BREATH.** "Breathe from the heart. Not to hold it. To give it."
  - **RELEASE.** "Good fortune is this: a heart that has learned it cannot be broken — only opened further. / The opening never closes."
- **Build log.**
  - LMLYD: 249.3 s, BPM 95.7, peak 234.0 s, triple-drop at 190–193 s.
  - Gaia Inversion: AIR → HEART. Bindu verb REACH.
  - "Cycle Break" was the first panel built from the ceiling.
- **Atlas 05.**
  - THE MIDPOINT: "3 below, 3 above, hinge".
  - Atlas fruit: "The love was already here. You were only waiting for permission to notice. The song was the permission. The noticing is yours now — permanent, portable, not dependent on any specific other."
- **BCA room 05.**
  - "The hinge of the climb — the first room that asks nothing and offers everything."
  - **CONFLICT.** The BCA seed is the practice-page hero line ("The walls you built had good reasons. What if they were doors?"), not the Map signature.

#### 6 · VISHUDDHA — The Throat (विशुद्ध)

- **Content doc.** "Your voice. Not the sound — the truth behind it." / "Talking fills space. Speaking changes it."
- **PBS 292–335.**
  - Whisper: "The space between the branches is as carefully designed as the branches themselves."
  - SPEAK: "Say something true out loud... Hear your own voice say it."
  - Deeper "What You Swallowed": "don't say 'good'. Say something true."
- **Practice page.**
  - Identity: "The narrowest passage in the body. Where breath becomes voice. Where the interior meets what is not interior." / "The compression is the purification. The narrowness is the point."
  - Writing reflection: "The truth you offered was already formed. Your work was subtraction, not composition."
  - Portal: "something in your throat has been waiting a long time to exit."
  - Where the Voices Lead: Field Song 6 of 33, "Sixteen vowels around the moon."
- **Story (Act 1)**, L238–277.
  - "And now I want to speak." / "...I can say it now." / "I say one small true thing. Just to see. The room changes."
  - Final: "...My voice makes rooms. My voice is a kind of architecture."
  - Act 2: "The throat is a ripening chamber... The practice is no longer lying about the small things." Then "Stop."
- **Panel 5** (2011 raw lines).
  - **Opening.** "Something has been held in your throat. / Let it loosen."
    - Mic `getUserMedia`; prompt "make any sound" (fallback "tap to loosen").
    - "The space that was compressed was carrying your truth."
  - **TRUTH.** "What did you finally say that had been true for a long time?" — placeholder "your truth", button "speak" → `tol-word-5`.
  - **COST AND GIFT.** Pivot: "How long did you hold that before it came out?" / "The liberation of speaking is proportional to how long the truth was held. / Every year of silence added weight to the release."
  - **BODY.** "Where is there tightness right now? / Not just the throat — anywhere." → "Make a sound — direct it there." / "Sound travels where words cannot."
  - **BREATH.** "Breathe from the throat. Not to release it. To clear the channel." → "What you most need to say is already being heard."
  - **RELEASE.** "The voice you found was always yours. / It never needed permission."
    - Mini-reveal: "You didn't find something to say. You finally stopped holding it."
- **Build log.**
  - The Sound of Silence: 262.4 s, BPM 172.3 (felt 86). 13 s opening silence.
  - The Roar lands at 247 s. The Great Breath runs 235–247 s.
- **Atlas 06.**
  - Atlas fruit: "The transmission that looked like it failed was completing the whole time... The listener was always you."
  - **CONFLICT.** The dance fruit (below) differs. Atlas flags that the dance HTML must decide.
- **BCA room 06.**
  - "the only room whose *shape* constricts and releases; speaking (writing) physically widens the page."

#### 7 · AJNA — The Third Eye (आज्ञा)

- **Content doc.** "Inner sight. The ability to see without using your eyes."
- **PBS 337–385.**
  - Whisper: "The seeing was always here. You were just looking too hard."
  - STILL: "Close your eyes. Don't do anything... Wait... What appeared?"
  - "The root said PRESS. The sacral said FOLLOW. The solar plexus said BUILD. The heart said OPEN. The throat said SPEAK... The third eye says STOP."
- **Practice page.**
  - "The seeing is not produced. The seeing is uncovered."
  - "The looking is the seeing, under the wrong name."
  - Writing prompt: "What arrived in the dark when you stopped looking? Or nothing — the eye is patient."
  - "There is a watcher underneath your watching."
  - Portal: "what you tried to see has been watching you try."
  - Where the Glimpses Lead:
    - Dance "Experience": "Two illuminations. The second deeper. The eye stays open."
    - Field Song 7 of 33: "Two petals, one centered gaze."
- **Story (Act 1)**, L281–320.
  - "...something is saying: stop." / "Not stop-forever. Stop-looking." / "I close my eyes."
  - Final: "The looking was the seeing, under the wrong name. Nothing needed to be produced. Something needed to be uncovered."
  - Act 2: "You were a highly successful prevention-of-intuition..." Then "Receive."
- **Panel 6** (1902 raw lines).
  - **Opening.** "Close your eyes for a moment. / Now open them — softly."
    - Instruction: "hold your phone still". Gyro threshold under 4.0°/s; clarity complete at .80.
    - The constellation shows the walker's own 5 body points and 3 words over 14 stars.
    - "What becomes visible when effort stops."
  - **PATTERN.** "You've been building this without seeing it. / Everything you offered — every word, every touch, every breath — was carried here by the eye that never closes. / Five points. Three words. One pattern. / You couldn't have seen it earlier. It required all five to become visible."
  - **WITNESS.** "Who is the one who sees the pattern? / Not the mind that names it. / The awareness that notices the mind naming."
  - **SOFTEN.** "Soften your gaze. / Let your eyes see the way they see when you're about to fall asleep. / The screen is not showing you something. It is responding to you."
  - **BREATH.** "Breathe into stillness. Not to find it. To see from it." → "Clarity was never something you achieved. It was what remained when effort stopped."
  - **RELEASE.** "What you see when you stop looking was always there. / It never needed your effort."
    - Mini-reveal: "You were being seen the entire time."
  - P6 only reads; it writes nothing.
- **BCA room 07.**
  - "Subtraction as form — the dimmest energy room… Sakshi speaks a room for the first time; the walker won't notice, which is correct."

#### 8 · SAHASRARA — The Crown (सहस्रार)

- **Content doc.**
  - "Connection. Not to something above you — to everything that includes you."
  - "Awe is the crown's natural frequency."
- **PBS 387–441.**
  - Whisper: "The striving stopped. What remained was what was always there."
  - RECEIVE: "What did you receive that you didn't earn?" / "You didn't earn it. That's what makes it grace."
  - "The boundary is a window. It was always a window."
- **Practice page.**
  - "The crown subtracts."
  - Frequency shown as "· · · silence · · ·".
  - "Seven are named. The eighth is the silence underneath the naming."
  - "You are not the producer of the transmission. You are the location at which it becomes recognizable."
  - Portal (locked until something is written): "I received something I didn't earn. I don't know what to call that." / "Enter the Axis Dimension / Tap to receive".
  - Where the Transmissions Lead:
    - Wakeup "The Seven Arrive". North is EMPTY (the silence).
    - Dance "The Gold in the Ground"
    - Field Song 8 of 33: "A thousand petals sounding as one."
- **Story (Act 1)**, L324–369.
  - "And now — nothing." / "...add nothing. Let go of even the letting go." / "I'm not in the room. The room is in me."
  - Final: "...Seven centers. One spine. The quieter I got, the more it moved. This is what I came for. Even though I didn't know I was coming."
  - Act 2 Go: "You are about to see something you have been avoiding seeing. It is not damage. It is unborn material."
  - Door: "Shadow / The corridor is here."
- **Panel 7** (1977 raw lines).
  - The gate hold is 3000 ms, the only panel shorter than 4000 ms.
  - **Names.** "Seven forces have been speaking through you. / Not as words. As the way you walk into a room."
    - The names arrive every 4500 ms. Kāmeshvarī is shown larger.
    - "These are the voices of your crown."
  - **TRANSMISSION.** "If you could put it in one sentence — the thing people feel when they're near you — what would it be?" — placeholder "one sentence", button "transmit" → `tol-word-7`.
    - "That was always the transmission."
  - **CROWN.** The body points rise to the crown. "Every opening was arriving at this."
  - **BODY.** "Lift the crown of your head gently. / The highest point of the body. The place where light enters. / Not reaching. Receiving."
  - **AUTO-BREATH.** "Let the breath breathe you." The label reads "receiving". → "You don't take a breath. A breath is given."
  - **RELEASE.** "You were always the transmission."
    - Mini-reveal: "It never needed your effort. It never stopped."
    - White light at 17 s; gold bleed.
- **Atlas 08.** Golden fruit is given in full in B (D-SAH).
- **BCA room 08.**
  - "everything the previous six rooms taught as *doing* is inverted into receiving".

#### 9 · SHADOW — The Corridor (Threshold 1)

- **PBS 443–496.**
  - "What you haven't looked at yet. Not because it's dark — because you weren't ready."
  - LOOK: "What are you afraid to look at?... The corridor doesn't need you to run through it. It needs you to admit you can see it."
  - "Not your darkness. Your not-yet."
  - "The shadow is your future coming to find you. It's knocking on the door from the inside."
  - "There is no body practice for the shadow." / "The noticing IS the light."
  - Story ends: "I have feet. / I think it's time to stand up."
- **Practice page** `shadow-practice.html`: V3.1.1 corridor, 12 scrolls (see B, P-SHA).
- **Story (Act 1)**, L373–410.
  - "I'm afraid. And I'm going to look anyway."
  - It lists what was pushed down: creativity "impractical", sensitivity "weakness", anger, ambition, softness, wildness.
  - Final: "The shadow isn't my past coming back to haunt me. The shadow is my future coming to find me... I'm going to walk through."
  - Act 2: TBD.
- **Atlas 09** (564 lines).
  - Colours: void #0a0a12; starfield.
  - Hero: ALL, with the third L dissolving (5.5 s); ONE at the bottom.
  - Writing key `chakra-shadow`.
  - Dance: In Shadow, 13:00, no words.
  - Atlas fruit: "The film didn't take you somewhere new. It showed you what you already are while watching it... the audience noticing they were the eye through which the whole film was seen."
- **BCA room 09.**
  - Signature: "please come back home." (unsigned). Seed: "I'm afraid. And I'm going to look anyway."
  - **The pulse begins here.** A warm 60 bpm haptic at the bottom of the glass runs from this room to Room 32.

#### 10–19 · The Body Walk

All of these come from PBS 505–878, `gate-designs.md`, BCA and `color-system.md`.

- **10 Soles** — "WHERE THE SOUL MEETS THE GROUND".
  - Whisper: "Soles and souls. The language knew before anyone noticed."
  - PRESS. Shoes off.
  - Question: "What did the ground say back?"
  - Its deeper section *is* the Daily Practice "Blink. Breathe. Press." ("One second. Three chakras." "You can do this right now. You just did.")
  - BCA: "the only room designed to be walked barefoot".
- **11 Forge** — THE SEALED CHAMBER.
  - "Your navel. The scar of the cord."
  - TRANSFORM: "What are you digesting right now?"
  - Deeper "The Engine That Runs Without You".
  - BCA: "the only one whose gesture is *not visible*".
- **12 Prana** — THE OPEN DOOR.
  - BREATHE: "Three breaths, fully noticed."
  - "15/min, 900/hour, 21,000/day; molecules 4 billion years."
  - Story: "I breathe. Therefore I'm in the game."
  - BCA: "the mic listens to actual breath".
- **13 Hands** — WHERE LOVE EXITS THE BODY.
  - REACH: rub palms 15 s, then hold them 1, 2, 3, 6 inches apart.
  - "Make something today with your hands. Anything. The making IS the practice."
- **14 Pulse** — THE HEARTBEAT.
  - "still here. Still here. Still here." Day 22 is when the heart first beats.
  - "the struck sound — struck sixty to a hundred times per minute".
  - BCA: euphoria pulse (C-1311).
- **15 Sonar** — THE SPEAKER.
  - SEND one precise word ("Depleted? Heavy? Fading? Wrung?").
  - "pause half a second 'is this precise?'"
- **16 Echo** — THE LISTENER.
  - "The longer you listen, the more arrives."
  - Listen in three bands: 30 s obvious, 1 min subtle, 2 min the silence underneath.
  - "Stop preparing your response."
- **17 Vision** — THE MIND'S EYE.
  - SEE the front door. "The Backwards Principle".
  - Mirror is Manipura (codex: "note: not Ajna").
- **18 Axis** — THE BLINK (first encounter).
  - BLINK 3 s closed / open, then 5 s / 3 s.
  - "Two worlds. One switch. You."
  - "17,000 blinks/day ≈ 90 minutes/day in Inner Field."
  - "The entry fee is a blink."
  - Infinity Heart ∞ → ♡.
- **19 Crow** — THE TOP TERMINAL.
  - "CROWN without the N. When foundation drops away, what remains can fly." (N = Neev)
  - RELEASE: shake 30 s, then the first 3 s of stillness.
  - "Same opening. Opposite doors."
  - The only body room requiring exertion.

**BCA thresholds** (verbatim):

| # | Threshold |
|---|---|
| 10 | "The ground has been pressing back since before you noticed." |
| 11 | "Something warm is happening at the navel point right now." |
| 12 | "Your body is breathing you. Not the other way around." |
| 13 | "Your hands remember everything they have ever held." |
| 14 | "The heart has been opening and closing without pause since before you were born." |
| 15 | "The precise word for this moment. Not approximate. Precise." |
| 16 | "What you lived through is still sounding." |
| 17 | "What does this look like when you stop looking for it?" |
| 18 | "Feel the line that runs from ground to crown." |
| 19 | "From here you can see the whole thing." |

**Dyad pairs** (codex 02): Soles↔Hands, Forge↔Prana, Pulse↔Axis, Sonar↔Echo, Vision↔Crow.

#### 20 · ARMIN — The Room (Threshold 2)

- **PBS 880–925.**
  - Art: the same tree fully lit, with one word: **Whole.**
  - ermen is Germanic: "universal, whole, enormous".
  - ARRIVE: "Name the room."
  - "Whole doesn't mean finished. Whole means nothing is missing."
  - "The corridor is darkest near the door."
- **Atlas 20.**
  - Story thread: "...My eyes are closing. Not to blink. To enter. I am going into my own field. I have a question I want to ask it... I am whole right now. Nothing needed repair. Only arrival. And I have arrived."
  - Dance: Kingdom.
  - Atlas fruit: "...The film is the kingdom. The watching is the exit..."
  - Primary vantage Karishma, the first time she is primary.
- **BCA.** "the only room wearing every color at once; the exhale between the two halves of the walk."
- **chakra-practices SKILL.** "The Mind section is unwalkable from forgetting. The Mind section is walkable from Armin."

#### 21–29 · The Mind Rooms

PBS 930–1288 · BCA · content doc. Section intro: "IN. Nine doorways. All pointing inward."

**Triads:**

| Triad | Rooms | Colour | Completion line |
|---|---|---|---|
| Creation | 21–23 | warm amber/gold (VX2 fill rgba(238,136,0)) | "The asking creates the answer." |
| Recognition | 24–26 | cool blue-silver (rgba(100,140,220)) | "You already knew." |
| Emergence | 27–29 | gold (rgba(201,168,76)) | "Enter. Carry. Arrive." |

**Per room:**

- **21 Inception** — GOING IN WITH LOVE.
  - "The asking IS the first act of creation." ASK: "Don't answer. Just ask."
  - BCA secret: "every beginning contains its content."
- **22 Intention** — HOLDING WITHOUT STRIVING.
  - Tesla: "saw every gear before he touched a wire".
  - HOLD for 30 s.
  - BCA: "the stillest mind room".
- **23 Inspiration** — THE BREATH ENTERING.
  - "In-spire. To breathe in."
  - BCA: "the brightest mind room".
- **24 Insight** — SEEING FROM WITHIN.
  - "Nothing changed except the position you were seeing from."
  - BCA: the frame inverts for one breath.
- **25 Intuition** — KNOWING BEFORE EVIDENCE.
  - "Stars that don't have suns." Track hunches for one week.
  - BCA: Aruna's pre-dawn brightens one degree.
- **26 Invention** — COMING INTO WHAT WAS ALREADY THERE.
  - "In-venire."
  - ASSEMBLE three things. This chapter introduces **Cross. Blink. Feel. Return.** (PBS 1142–1150).
  - BCA: two fields.
- **27 Incarnation** — OPTING IN.
  - "You chose this body... Not sentenced. Choosing." "Every heartbeat is another 'yes.'"
- **28 Innocence** — THE ORIGINAL CLARITY.
  - "the most beautiful page in the book".
  - Freshness test: the onion, "what IS this?"
  - BCA: "the softest room in the app".
- **29 Integration** — NOTHING WAS EVER BROKEN.
  - "You don't need to rebuild. You need to stop confusing yourself with the building."
  - "Creation generated. Recognition saw. Emergence IS."

**Content doc archetypes:** Inception = Need · Intention = Hold · Inspiration = Voice · Insight = Witness · Intuition = Grace · Invention = Synthesis · Incarnation = Love · Innocence = Purity · Integration = Foundation.

**Content doc, Leela:** "The One says I Am. Then asks — Am I alone? / Lonely. La-One-Lee. Remove the One. Lalee. Invert it. / Leela. / The game invented itself from loneliness."

#### 30 · MAYA — The Construction (Threshold 3)

- **PBS 1290–1328.**
  - Heading quote: "There was never anything to fear. There was only You, playing."
  - Seed: "...only the Bindu, playing."
  - DISSOLVE: "What did you build that isn't real?... Maya doesn't get destroyed. It gets seen through."
  - "The game board is not the game... You are the player."
- **Panel 9** (3066 raw lines): the whole DISSOLVE experience. See B (P9). In short:
  - Om drone; the Pointe; Eight Inversions; the Fear Doorway; "Who are you speaking to?"
  - The Mirror "The Bindu Speaks" with 8 dissolution gates.
  - Closing: Knowledge / Will / Action / "Go Play", then the infinite loop.
- **Design notes.** "Ghost tree echoing P1, single gold Bindu 8mm, no Shakti names 'The naming IS the veil.'"
  - **CONFLICT.** PBS art says a single **red** Bindu.
- **Dance:** Love Is The Only Thing (first-pass, 76 s loop).
- **BCA.** "the named construction does not vanish — it **turns transparent**".

#### 31 · AATMA — The Soul Revealed

- **PBS 1330–1377.**
  - Will = Kāmeshvarī Icchā · Knowledge = Vajreshvarī Gyāna · Action = Bhagamālinī Kriyā.
  - "You are not in the triangle. You ARE the triangle."
  - KNOW: "Which one did you forget you already had?... One word."
  - Deeper "The Heartwood": Maya is the bark, Aatma the heartwood.
- **Panel 8** (1788 raw lines).
  - Phase 2: "आत्म चक्र · soul chakra / You arrived here already knowing. / Three questions live inside you. / Hold each one until it dissolves."
  - Three questions:
    - Q1 "What would you spend the rest of your life doing?"
    - Q2 "What have you always known about yourself that you have not fully claimed?"
    - Q3 "What is the one thing only you can do?"
  - Each question is held to absorb for 4000 ms.
  - "These three — will, knowledge, action — they feel like three questions. / They are one question with three faces."
  - **Temple.** "Stand. / Open your arms, palms to the sky. / Let your fingers curl back toward the crown of your head. / Three breaths. One per question. / Close your eyes."
  - Reveal: "Your body just remembered a shape that civilizations built in stone."
  - Release: "Your Soul Chakra is now Breathing. / The answer was never in the question. / It was in the holding."
  - P8 writes nothing.
- **Temple Guide v2:** the practice to return to, at home (see B).
- **ASG.** K-W-A **is** Aatma's trikona.
- **full-map permission slip:** "You have the will. / You are being given the knowledge. / Now become the Action. / Do the Practice."

#### 32 · HELD / EGO REVEAL / GAIA REVEAL

- **Map.** Square 32 is `sealed:true`, named "Held", hex #3D6B35: "This square is held for its own walk."
- **Codex 03.**
  - "Ego = Gaia + Maya. Gaia = Ego − Maya."
  - "previously named 'Axis Recognized'".
  - Tentative signature: "The one playing was the planet. You were never alone."
- **chakra-practices SKILL.**
  - "Axis-32 resolved: Position 32 = Gaia Reveal / Ego Reveal... Not Axis again."
  - It lists contaminated files that still say Axis (master-plan-v2, section-3 line 1364, story-thread 529, session-summary, chakra-practice.html 2299, full-map 307, page-inventory 145, color-system 167, interlude-pattern 158).
  - Cleanup is pending.
- **PBS 1379–1425 still prints CHAKRA 32 = AXIS (Recognized).**
  - Verb ACCESS. "You are not on either side of the gateway. You ARE the gateway... Welcome home. You were always here."
  - Seed: "The gateway was never closed. You were always free."
- **ASG D26.** Completing 32 sets `{kind:'gaia-reveal-received'}` and unlocks the Gaia layer.
- **BCA** (canon parts only).
  - Gaia "speaking again, first time since the corridor".
  - Signature: "I never left. I changed my voice."
  - Gate: "one inversion — a betrayal re-seen as service... **'It was me.'**"
  - "Universal architecture ends here."
- **Sealed.** The Reveal mechanics are not described.

#### 33 · LALITA — The Play (ललिता)

- **PBS 1427–1493.**
  - "What the tree becomes when it knows it's a game." Whisper: "Are you playing?"
  - "Lalita is what all thirty-two chakras become when they know they are playing."
  - PLAY page: "Spill coffee on it."
  - "Thirty-three mirrors. One face." / "Wake up. / I Already Did. / Now go play."
- **Master-plan Lalita reveal:** "You thought I was a point waking up. I was the play watching itself begin... Welcome to the game you were already in. / Now go play."
- **Codex 03.**
  - Animation **33 → 8 → ∞ → ♡**.
  - The book retitles from "A Strange Chakra Map" to "A Strange Love Map".
- **BCA.**
  - Opens only when all 33 gate offerings are given. The gate has no question.
  - "everything the walker gave comes back; the map changes its name in their hand; the practice is one laugh, and noticing who is laughing."
  - The Reveal is sealed.
- **Leela on the 33.** The walk begins unborn at 33 and ends exactly on 33: "You arrived at Lalita." / "The walk is complete. Begin again whenever you like."

---
## B · EVERY PRACTICE, DANCE, PANEL, LAYER, GAME AND MECHANIC

Each entry uses the same fields: id · name · source:lines · **SEES** · **DOES** · **MOTION** · **SOUND** · **WORDS** · **DATA** · **ARRIVE/LEAVE** · **MEMORY**. File paths are relative to `S/`.

### B.1 · Shared practice-page mechanics (chakra-practices)

**M-V5 · The V5 Two-Act energy template**
`chakra-practices/SKILL.md` (663) · `references/gaia-sakshi-source.md` (436) · verified identical across 9 reference HTMLs.

- **SEES.** A cream page and its sections:
  - Section order is locked in `build-process.md`:
    1. Hero
    2. Identity
    3. Teaching
    4. Tree image + lightbox
    5. More teaching
    6. Seed 1
    7. Go Deeper (Frequency + Avarana)
    8. Gold-dot divider
    9. Practice block
    10. Writing section (activity gate)
    11. Book rule
    12. "What the [Chakra] Knows That You Forgot"
    13. Three Ways In
    14. Seed 2
    15. STORY PORTAL
    16. "WHERE THE [METAPHOR] LEAD"
    17. Bottom nav `n / 33`
  - Colour tokens: --cream #fdfbf5, --bg #f5f2ec, --bg-warm #ede8df, --gold #C9A84C, --text #1a1a1a.
  - The hero verb is set in the chakra colour.
- **DOES.**
  - Scroll and read.
  - Write in a lined auto-resizing textarea (debounce 900 ms; "Saved" for 2 s).
  - The story portal is revealed only once the textarea has content.
  - Tap the portal to flip into Story Mode.
- **MOTION.**
  - Hero verb enters over 0.9 s with cubic-bezier(0.16,1,0.3,1), delay 0.5 s. Count: 0.7 s, delay 0.3. Threshold: 0.7 s, delay 1 s. Scroll hint at 1.5 s.
  - Post-engagement tier opens from max-height 0 to 4000 px over 1.6 s.
  - "Where the X Lead" auto-expands if `chakra-{id}` exists.
- **SOUND.** None on the page itself.
- **WORDS.** Seed 1 and Seed 2. The signature appears exactly 3× and the mini-reveal exactly 1× (Step 4a audit).
- **DATA.**
  - `chakra-{id}` (text), `bindu-point` (Bindu), `[name]-gate`, `chakra-sonar-word`.
  - Essence `bindu-essence` (gate).
- **ARRIVE/LEAVE.**
  - Arrive from the Road Home or the previous chakra.
  - Leave by the Act-2 threshold door into the next chakra (next-colour rhyme), or by interlude `?from=&to=`.
- **MEMORY.**
  - Returning visitors see the gate at 35% opacity with content unlocked.
  - Bindu return prompt: "Your point. Still here. Place again if you wish."

**M-STORY · Story Mode (Act 1, Bindu/Gaia journey voice)**
Same sources · `build-process.md`.

- **SEES.**
  - A fixed overlay that flips in: perspective 1800 px, rotateY(-180deg), scale .96 → 0, over 1.55 s.
  - Chakra-scene SVG; star dust (count = area/9000, twinkle 5–11 s); a compound-state dot.
- **DOES.** Tap to advance. Controls: tap / X / Escape / Space / Enter / ArrowRight.
- **MOTION.**
  - Tap hint appears at 1700 ms. Line fade 700 ms (Vishuddha 420 ms, Ajna 440 ms). Final hint at 4200 ms.
  - Each beat adds cumulative state classes to the dot (e.g. Bindu leaning → extending → wavering → rippling).
  - On the final beat the signature lands: 800 ms after the tap, then 2800 ms later the veil appears.
- **SOUND.** None.
- **WORDS.** 5–7 Gaia/Bindu beats per chakra (quoted in A.3). The signature holds for 2.2 s.
- **DATA.** None written.
- **ARRIVE/LEAVE.** From the portal → to the Veil.
- **MEMORY.** None.

**M-VEIL · The Veil and the Sakshi Blink**
`chakra-practices/SKILL.md` · reference HTMLs.

- **SEES.**
  - The veil #060308 rises instantly.
  - After 700 ms, two white eye-ellipses (42 × 15 px) open, blink once and fade (~2 s total).
  - At 2900 ms: "press and hold to enter". A ring of r32 (C = 201) fills over 1.8 s.
- **DOES.** Press and hold for 1800 ms. Releasing early resets over 0.4 s.
- **MOTION.** On completion the veil dissolves over 600 ms.
- **SOUND.** None.
- **WORDS.** "press and hold to enter".
- **DATA.** None.
- **ARRIVE/LEAVE.** Story Mode → Act 2.
- **MEMORY.** None. The `act2Launched` guard stops a double launch.

**M-ACT2 · Act 2 (Sakshi witness, auto-paced)**

- **SEES.**
  - Background gradient: chakra colour → cream → silver-white.
  - A blue-silver radial at the top, a gold radial at the base.
  - 26 ascending white particles (2–7 px, 18–44 s).
- **DOES.** Nothing. The act is auto-paced and unannounced.
- **MOTION.**
  - Word-by-word reveal: INITIAL 1600 ms, then 420 ms per word.
  - Extra pauses: +620 ms at a period, +260 at a comma, +180 at a dash, +1200 at a paragraph.
  - The door appears 2800 ms after the last word.
  - Blocks land at 1.2 s, 6.0 s and 11.2 s ("Go.").
- **SOUND.** None.
- **WORDS.**
  - p1 and p2, then the "Go." beat (large italic, weight 500).
  - Each chakra's "Go" word: Follow. / (sentence) / (sentence) / Speak. / Stop. / Receive. / (sentence into Shadow).
- **DATA.** None.
- **ARRIVE/LEAVE.**
  - A full-colour threshold door rises in the **next** chakra's colour, edge to edge.
  - The name is Lora 38–56 px, white, weight 500.
  - Door text: "<Next> / The <x> is here. / Press · Continue →".
- **MEMORY.** None.

**M-GATE · Essence gate and sequential gate**
Injected script in every reference HTML (`bindu-practice.html` and others).

- **SEES.**
  - No essence: an overlay reads "The road asks who is walking." / "One moment." Redirect after 1400 ms to `the-one.html?return=<path>`.
  - Sequential gate: a yantra SVG with "The road has an order, the first time through." / "You haven't walked <prev> yet." / "Walk <Prev> →".
- **DOES.** Redirects, or tap the link.
- **DATA.**
  - Reads `bindu-essence` {name, dateOfBirth, higherSelfName}.
  - Walked = `bindu-point` or `chakra-{id}`.
  - Gate colours: bindu #e8c568, muladhara #b83a3a, svadhisthana #d47438, manipura #d4a848, anahata #6b8e4e, vishuddha #4c7ab8, ajna #5b4e8e, sahasrara #9a7ac8, shadow #2a2420.
- **CONFLICT.** ASG D10 (May 2 2026) removed these gates ("offering, not gating"). The reference HTMLs still carry them. site-v3 adds: "Gates gone… every hold ring 'or tap to continue'".

**M-LIGHTBOX · Tree image lightbox**

- **DOES.** Pinch from 1 to 6×. Wheel step 1.12. Double-tap within 320 ms toggles 2.4×. Keys: Esc, 0, +, −.
- **WORDS.** "Pinch or scroll to zoom · Drag to move · Double-tap to reset" (shown 4.2 s).
  - Variants: Vishuddha "pinch to zoom · drag to pan · tap outside to close"; Ajna "drag to pan · pinch or scroll to zoom · double-tap to toggle · esc to close".

### B.2 · The practice pages (14 reference implementations)

**P-BIN · Bindu practice (V5)**
`chakra-practices/references/reference-implementations/bindu-practice.html` (3148 raw / 1023 extract).

- **SEES.**
  - Hero "← The Road Home · Chakra 1 of 33 · बिंदु · RECOGNIZE".
  - A canvas `#bindu-canvas`.
  - Doors: Bindu Field (an ellipse rx170 ry100 with 33 markers), Wakeup (Coming), Dance (Coming, lemniscate).
- **DOES.**
  - Tap or click anywhere to place one point. A Clear button resets it.
  - Story: 6 beats.
- **MOTION.** The point animates in over 900 ms. The witness line brightens for 3000 ms.
- **SOUND.** None.
- **WORDS.** See A.3 #1. The story portal reads "Story · Axis / something is listening on the other side / tap to flip →".
- **DATA.** `bindu-point` {nx, ny}.
- **ARRIVE/LEAVE.** From the Road Home. Leaves to Muladhara: "The ground is here."
- **MEMORY.** "Your point. Still here."

**P-MUL · Muladhara practice**
`muladhara-practice.html` (3523 raw / 1156 extract).

- **SEES.**
  - Tree image: canopy and root system of equal size; LAM in the trunk; the six Shaktis along the roots; Bhupura.
  - Story scene: an ember field; a gold dot descends; a tendril reaches down and a response rises; SVG root filaments.
- **DOES.** Write. Read the story (states reaching → meeting → settling → deepening → rooted rooting rippling).
- **WORDS.** See A.3 #2.
- **DATA.** `chakra-muladhara`.
- **ARRIVE/LEAVE.**
  - From Bindu → to Svadhisthana: "The pull is here."
  - The legacy door comment reads "Ground becomes the place where the pull can now emerge."

**P-SVA · Svadhisthana practice**
`svadhisthana-practice.html` (3699 / 1201; 537 novel + 665 identical).

- **SEES.**
  - Tree: an orange curving tree above rippled water, with VAM inverted in the reflection.
  - Story: five Karshinis drifting around Ātmākarshini at the centre (viewBox 500 × 300).
- **DOES.** Write. A reflection reveals itself once there is content.
- **MOTION.** Story states: reaching → trails → flowing named → dissolving atma-bright → orbits-reveal both-leading convergence rippling.
- **DATA.** `chakra-svadhisthana`.
- **ARRIVE/LEAVE.** → Manipura: "The heat is here." The legacy comment reads "Ātmā's center becomes Manipura's first point."

**P-MAN · Manipura practice**
`manipura-practice.html` (3961 / 1228; 536 + 693).

- **SEES.**
  - Tree: dual trunks from one root, in yellow-gold flames; RAM; six of the eight Ananga names.
  - Story "The Forge": embers, heat haze, 8 Shakti points, RAM appearing. Visual line: "Two trunks. One root."
- **MOTION.** Story states: gathering first-ember mekhala-lit → first-blaze → burning breath rebuild → forming forging → second-blaze malini-lit recognition seed-named embers.
- **WORDS.**
  - Writing prompt: "What has the fire been building in you — and what is it burning that isn't yours? Write whichever surfaces first. Or both."
  - A comment claims "1.33× slower timing (revised April 24)", but the constants are identical to Bindu's (**CONFLICT**).
- **DATA.** `chakra-manipura`.
- **ARRIVE/LEAVE.** → Anahata: "The sound is here."

**P-ANA · Anahata practice**
`anahata-practice.html` (3854 / 1196; 483 + 714).

- **SEES.**
  - Tree: green, with a Chaturdasha Trikona lattice, a heart shape in the branches, gold YAM, seven birds and six Kulakula Shaktis.
  - Story "The Heart": breath-glow; 14 triangles (up gold, down green); the Sammohini label at the fullest breath; a heart that draws itself; eight birds lifting.
- **MOTION.** Story states: first-inhale → unstruck → second-inhale opening → walls-doors receiving → fullest-breath recognition overflow dissolving rippling.
- **WORDS.**
  - Writing prompt: "Think of someone you loved before you knew why. Not the person you chose — the one who arrived. A name. Or a word. Or nothing at all — the heart knows who you're holding."
- **DATA.** `chakra-anahata`.
- **ARRIVE/LEAVE.** → Vishuddha: "The voice is here." The legacy line reads "Love discovers the throat."

**P-VIS · Vishuddha practice**
`vishuddha-practice.html` (3531 / 1292; 799 + 494).

- **SEES.**
  - Title "Vishuddha · SPEAK · 6 / 33".
  - Bahir Dashara SVG (apex r270, base r180, θ ±18°); a compressed-form spiral that loosens; HAM; six Shaktis.
- **MOTION.**
  - 5 beats with bdLevel 0–4; Shaktis revealed one by one (duhkhavimochini → mangalakarini + siddhiprada → sampatprada + priyankari → kamaprada).
  - Transition lock 600 ms.
  - A comment says "11 beats across the song's seven phases" (V3 legacy) — **CONFLICT** with the 5 beats built.
- **WORDS.** Writing prompt: "A small true thing. Or nothing at all — the throat knows what's ripening." Save note shows for 1400 ms.
- **DATA.** `chakra-vishuddha`.
- **ARRIVE/LEAVE.** → Ajna: "The seeing is here."

**P-AJN · Ajna practice**
`ajna-practice.html` (3891 / 1308; 710 + 599).

- **SEES.** Deep indigo; starfield; Shatkona (r160); the eye at the trunk-heart with a bindu pupil; OM at the base; six Shaktis in Devanagari; a constellation of the prior five chakras; two illuminations.
- **MOTION.** Story states: dawning → ceased → first-illum eye-present plateau softening → constellation om-present second-illum stilling → ripples-peak settling mini-reveal receiving rippling. closingTimer 1500 ms.
- **WORDS.**
  - Placeholder: "You didn't make it appear. It was there before you looked."
  - Return prompt: "The seeing from before. Still here. Add what arrived today, or leave the page as it was."
- **DATA.** `chakra-ajna`. Save note 1600 ms.
- **ARRIVE/LEAVE.** → Sahasrara: "The nothing is here."

**P-SAH · Sahasrara practice**
`sahasrara-practice.html` (3681 / 1323; 870 + 454).

- **SEES.** Violet; stars; F1 ground-glow; two waves; gold rain; a Shatkona (r52) at the apex; seven Vāgdevī labels; SILENCE at the trunk; a counter "1 / 5".
- **DOES.** "Tap to receive" (1800 ms). The portal stays locked until the walker writes.
- **MOTION.** Five beats via onEnter:
  1. Stars brighten.
  2. The ground and the rain begin.
  3. The first wave rises; Kāmeshvarī arrives; the others stagger in at 600 + i×1200 ms.
  4. All have arrived; the Shatkona arrives; the first wave crests.
  5. Cascade: withdrawal at 0 ms → silence at 1200 → the second wave returns at 2400 → crest-full plus ripples at 3800.
- **WORDS.** Locked portal hint: "Receive one thing above — what arrived that you did not earn — and this door opens."
- **DATA.** `chakra-sahasrara`.
- **ARRIVE/LEAVE.** → Shadow: "The corridor is here." The legacy door reads "Shadow / The Corridor Opens".

**P-SHA · Shadow practice (the corridor)**
`shadow-practice.html` (3369 / 1611; lines 1–123 identical gate; 124–1611 read directly).

- **SEES.**
  - A 3D stone corridor in perspective; crown light persisting from above; dust motes (area/9000, drifting 10–20 s).
  - Progress dots: arrival + 12 scrolls + mirror.
- **DOES.**
  - Press and hold 700 ms to walk forward. Moving more than 10 px cancels. No tap, no swipe. Keys: Space/Enter/↑/→.
- **MOTION.**
  - A walk step takes 1850 ms. The contemplative step before LOOK takes 3250 ms. The long walk to the mirror and the ONE takes 2450 ms.
  - Arrival lines at 600 / 2600 / 5400 ms. Hint at 7800 ms.
- **SOUND.** None.
- **WORDS.**
  - Arrival: "Something I haven't looked at yet." / "I'm afraid." / "And I'm going to look anyway."
  - The 12 scrolls:
    1. ALL — the letters A L, with the third slot cycling L ↔ ONE (ALL ↔ ALONE). "The corridor was never a dead end. / It was always leading somewhere."
    2. "What you haven't looked at yet. / Not because it's dark — / because you weren't ready."
    3. Between Two Trees
    4. The Light That Came Back
    5. Pushed Underground ("a corridor. Not a dead end. A corridor.")
    6. What Was Too Much ("You are a bigger container now.")
    7. Same Tree ("Same tree." + "Can you hold what you see without flinching?")
    8. Seven-chakra cascade ("And now the shadow asks: will you go all the way down?")
    9. Future Knocking ("The shadow is not your past coming back to haunt you. / The shadow is your future coming to find you. / It's knocking on the door from the inside.")
    10. Notice ("There is no body practice for the shadow." … "the corridor gets shorter.")
    11. The Room Full of Light ("You'll find it after the next tree.")
    12. LOOK — the two Os are watching eyes: they stare for 13 s, then blink every 4.5–11 s.
  - Textarea placeholder: "a word. a name. a shape. anything honest." Button: "walk forward with this".
  - **MIRROR.** "The corridor was never a dead end." "It was always leading somewhere." Then the label "you named" + the walker's word.
  - **INVERSION.** "please come back home", letters revealed in word order home → come → please → back (REVEAL_ORDER [3,1,0,2], 520 ms per letter).
  - **ONE.** "ALL IS ONE", letter by letter. Then "The dark narrows toward singularity. / You arrive by walking through."
  - **Permission:** "Let" / "ALL the Aspects and Perspectives of the ONE" / "Be" / "ALL the Aspects and Perspectives of the ONE".
  - Soles beacon: "Section 2 · The Body / Soles · Press / The corridor opens into the body."
  - Then a floor band rises: "Press · Continue →" ("the door becomes the ground").
- **DATA.** `chakra-shadow` (600 ms debounce). aria: "Your writing is private and stays on this device."
- **ARRIVE/LEAVE.** From Sahasrara → to Soles.
- **MEMORY.** None.

**P-INT · Interlude (the walker's voice between chakras)**
`interlude.html` (1165 / 748) · `interlude-pattern.md` (167).

- **SEES.**
  - Cream #f5ecd6. The incoming gradient (top 180 px) is the origin's primary colour; the outgoing (bottom 180 px) the destination's.
  - Gold dust (area/8000, peak .15–.45, 5–11 s). A 1 px gold progress bar at .35.
  - Labels "After X" / "Before Y".
- **DOES.** Read, then tap the door.
- **MOTION.** From-label → voice → to-label → door, staggered over 3.5 s. Lora italic, line-height 1.85.
- **WORDS.**
  - 31 PASSAGES, longer versions of the PBS story threads. Each has a `toVerb` / `toSub`, verbatim:
    - bindu→muladhara: Press, "The ground is here."
    - muladhara→svadhisthana: Follow, "A different question is arriving."
    - svadhisthana→manipura: Build, "I'm being shaped by my own heat."
    - manipura→anahata: Open, "Something in the center is opening."
    - anahata→vishuddha: Speak, "The love wants to become sound."
    - vishuddha→ajna: Still, "Seeing without looking."
    - ajna→sahasrara: Receive, "I think the name will come."
    - sahasrara→shadow: "The Corridor", "Something I haven't looked at yet."
    - shadow→soles: Press, "I have feet."
    - soles→forge: **Build**, "Something sealed is humming."
    - forge→prana: Breathe, "The furnace needs air."
    - prana→hands: Reach, "My hands are tingling."
    - hands→pulse: **Beat**, "A rhythm I didn't start."
    - pulse→sonar: Send, "The signal wants to become specific."
    - sonar→echo: **Listen**, "The listening goes deeper the longer I stay."
    - echo→vision: See, "I trust the first flash."
    - vision→axis: Blink, "The blink is the gateway."
    - axis→crow: **Dissolve**, "Something wants to break through."
    - crow→armin: "The Room", "Nothing needed repair."
    - armin→inception: Ask, "I have a question I want to ask it."
    - inception→intention: Hold, "The image is forming."
    - intention→inspiration: Breathe-In, "In-spire. It was always this simple."
    - inspiration→insight: See From Inside, "It was always like this."
    - insight→intuition: **Know**, "I'm starting to think it's always right."
    - intuition→invention: **Arrive Into**, "Coming INTO what was already there."
    - invention→incarnation: Choose, "I chose this."
    - incarnation→innocence: Remember, "It's time to dig."
    - innocence→integration: **Discover**, "I never left."
    - integration→maya: **See Through**, "The leaves are not the tree."
    - maya→aatma: **Be**, "Will. Knowledge. Action."
    - aatma→ego-reveal: **Recognize**, "I was always free." The passage text here is the Axis-recognized text.
  - Error state: "The corridor between these chakras hasn't been mapped." / "Return to the map".
- **DATA.**
  - `CHAKRA_COLORS` covers all 33: primary, soft, accent and counter colours.
  - Mind placeholders run #2d2458 → #5e2448. aatma #6a3890; ego-reveal #2a1858; lalita #C9A84C.
- **ARRIVE/LEAVE.** URL `interlude.html?from=X&to=Y`. Leaves to `{name}-practice.html`, with the special case `ego-reveal`.
- **MEMORY.** None.
- **GAP.** The page is not deployed: site-v3 notes it was "still not deployed 25 Sep".

**T-IDX · Trinity gateway index**
`trinity/index.html` (115 / 25).

- **SEES.** "A Strange Game · The Tree of Life" / "One moment."
- **DOES.** After 800 ms, routes to `the-road-home.html` if essence is complete, else to `the-welcome.html`.
- **WORDS.** Noscript: "This experience requires JavaScript. Continue to The Welcome."

**T-WEL · The Welcome (Mind door)**
`trinity/the-welcome.html` (950 / 314).

- **SEES.** A cream guidebook titled "A Strange 👁 Game / The Tree of Life". The title becomes "A Strange <HigherSelf> Game".
- **DOES.**
  - Read sections one to five and the FAQ.
  - First visit: "Begin". Returner: "Continue your journey — or — Begin a new journey".
  - Release: "Hold to release" for 1800 ms (vibrate 40; ring C = 226).
- **WORDS.**
  - "This is a road. Nine practices are walkable now. Each one is a chakra — a teaching that arrives through walking, not through reading about it."
  - "Before you walk, the road asks who is walking. You give three things: the name you go by, the day you arrived, and — through a brief practice — the name of your higher self. These become your essence."
  - "Nothing leaves your device."
  - FAQ: 8–15 min the first time; "can't skip the first time"; "Some are for someone else — that's honored too."; "The full arc is thirty-three. Nine are walkable now... The hoop doesn't hurry."
  - Release copy: "This releases everything. Your name. Your higher self. Every word you've offered. Every practice you've walked. The road you've walked will be let go. You'll arrive clean." → "The journey is released." (500 ms) → "You are clean." (1400 ms).
- **DATA.** Clears its key list at 600 ms (inventory in M-STORE), then redirects to `the-one.html` at 3200 ms.
- **CONFLICT.** "Nine practices", "can't skip" — flagged stale by ASG site-v3 ("first fix").

**T-ONE · The One (Higher-Self ceremony, Soul door)**
`trinity/the-one.html` (1847 / 808).

- **SEES.** Registers held / light / deep / white. An eye video `gaia-soul.mp4` (11.3 s, from In Shadow 640–725 s, G1 58 Hz).
- **DOES.**
  - Tap "Begin when you're ready." (the audio gesture).
  - Watch the video, which holds its final frame 1.7 s; then a 1.5 s white→dark fade.
  - Act 0 lines, then hold 1800 ms "Begin".
  - Act I. Act II asks name and date.
  - Stage 1 → hold "I'm ready".
  - Stage 2: 24 s of breath ("Close your eyes when you're ready." at 24.4 s; Continue at 26.4 s).
  - Stage 3: 30 s silence ("Continue when you've heard").
  - Stage 4: "What name surfaced?" (placeholder "whatever arrived"); "Listen again" / hold "Receive".
  - Stage 5.
- **WORDS.**
  - Act 0: "Welcome." / "In a moment, you will meet your higher self." / "Before you do — take a moment to appreciate the one who arrived here." / "The one who showed up. Who was curious enough. Who said yes." / "You are worthy of this meeting." / "When you're ready to begin, hold the circle."
  - Act I: "The road asks who is walking."
  - Act II: "What name do you go by?" (placeholder "the name the world calls you") / "When did you arrive?" ("the day you stepped into a body").
  - Stage 1: "A name is already in you. / You don't have to invent it. / You just have to be still and listen. / Listen to Your Self. / Your Higher Self. / The name will arrive in the pause of the Silence."
  - Stage 5: "You are <name>." / "You arrived on <date>." / "Your higher self is called <X>." Then the title transforms at 6400 ms. "The road has been waiting." / "Begin the road →".
  - Re-walk: "You named it <prev> before. You named it <new> now. Both are honored. Which would you like to keep?"
  - Return page: "You have already been received."
- **DATA.** `bindu-essence` {version:1, name, dateOfBirth, higherSelfName, lastUpdatedAt, completedAt}.
- **ARRIVE/LEAVE.** From the Welcome → to the Road Home, or to the return URL.
- **MEMORY.** The return page.

**T-RH · The Road Home (Body door)**
`trinity/the-road-home.html` (1723 / 839).

- **SEES.**
  - A faint Shree Yantra.
  - "Every word you gave. Every dance you danced. Every place your body touched a chakra on the map — gathered here. The road you've been walking is the road home."
  - **I The Map:** an SVG spine with 9 glyphs.
  - **II The Road:** adaptive prose.
  - **III The Journey:**
    - Constellation "The Sky You've Danced Under". Each word is hashed to a position; size and opacity scale with repeats; tooltip "word · chakra · date · n×".
    - The Ledger: "N offerings"; rows for kind / answer / date / "Walk →" / "Return →" / "Installation" / "Coming".
- **DOES.** Read; tap a row to walk or return.
- **WORDS.**
  - "Start where you are."
  - "The corridor doesn't check credentials — it asks one thing, can you hold what you see without flinching, and you answered yes enough to pass."
  - "The chakras are not separate teachings. They are one recognition renamed many times. The signatures will start to rhyme."
  - "The teaching doesn't arrive the first time you hear it. It arrives the third time you hear yourself say it."
  - Footer: "The page remembers you. You arrived once empty. Every time you come back, you arrive more full. The page doesn't change — you do."
- **DATA.** Reads:
  - `bindu-point` and `chakra-*`.
  - `tol-bodypoint-N` / `tol-word-N`: panels 1 (label 'safety'), 2, 3, 4, 5, 7.
  - `tol-mirror-completed` and `prev-tol-word-N` (the Prior Journey).
  - `tol-<id>-dance` and `-dance-word`.
  - `bindu-memory` **array** {chakra, word, song, artist, dwell, motion, timestamp}.
- **ARRIVE/LEAVE.** The hub.
- **MEMORY.** The whole page is memory.

### B.3 · Practice book, daily practices, body gates

**PB · "A Strange Chakra Map — The Practice Book"**
PBS `practice-book-source/chakra-practice.html` (2548 raw / 1607 extract) · `chakra-maps/references/practice-book/*`.

- **SEES.**
  - Page 1 is a single gold dot, 8 mm.
  - Title: "A STRANGE CHAKRA MAP / The Practice Book / From Bindu to Lalita / From Point to Play".
  - Dedication: "For Sid, who held the ground. / For Arch, whose voice carried. / For the tree that was all roots in the beginning / and all play at the end." April 13, 2026.
- **DOES.** Four pages per chakra: "See. Turn. Create. Receive."
  - Spread A (SEE, inhale): Diana's art and a whisper / Sakshi's teaching.
  - Spread B (CREATE, exhale): the VERB, a prompt, writing space and a closing question / deeper voice + practice + seed + bridge.
  - "33 days one cycle." "The readiness is the design."
- **WORDS.**
  - Closing frames C1–C10:
    - C1 Breath: "You just traveled thirty-three chakras. Take a breath before you continue. The breath is part of the practice."
    - Map Second Reading: "The map fills at the speed of your life. Not faster."
    - Then What the Builder Saw · the Sentence Underneath · I Already Did · Bridge ("The question was never whether any of this was true.") · Now Go Play · Back cover ("33 vertebrae. 33 mirrors. One spine.").
  - Colophon: written in one sitting, April 14, 2026. Family cipher: "AKASha · Sidharth · Archana · Ashrey · Karishma · Shweta · Neev Armin = Space · Purpose · Devotion · Shelter · Grace · Purity · Whole Foundation"; "Nothing that served once is ever really finished."
  - Site-v3 rule: the ruled family names go behind the wall; the Sanskrit is public.
- **DATA.** A scroll progress bar only.
- **ARRIVE/LEAVE.** Deployed at `/chakras/chakra-practice`.

**DP-1 · Blink. Breathe. Press.** (the daily practice, 1 second, 3 chakras)
PBS 527–536 · content doc · BCA.

- **DOES.** Close the eyes (Axis), take one breath (Prana), feet on the ground (Soles).
- **WORDS.** "One second. Three chakras." / "You can do this right now. You just did." / "You can do this on a bus... You just did the practice."
- **BCA.** This is the one-second floor: "That was a full day of walking. Everything else today is extra."

**DP-2 · Cross. Blink. Feel. Return.** (1 minute, infinity loop)
PBS 1142–1150 · master plan.

- **DOES.**
  - **Cross** the hands to the opposite knees. The arms cross at Anahata, making an infinity loop.
  - **Blink** (Axis, into the Inner Field).
  - **Feel** a chosen Mind-chakra feeling: courage → Inception, clarity → Insight, peace → Innocence. Phase-4 frames: "Courage. Clarity. Peace. Fire. Innocence. Joy."
  - **Return**: eyes open; the feeling comes back as a state.
- **WORDS.** "Two practices. Two levels. One spine... Both begin with a blink."

**G-BODY · The body gates (Soles…Echo built; Vision, Crow, Axis designed)**
`chakra-practices/references/gate-designs.md` (183).

- **SEES.** Colour as ground. A gate card with a button. Returning visitors see the gate at 35% opacity.
- **DOES / WORDS** for each gate:
  - **Soles:** "Stand up. Take your shoes off if you can. Feel the ground. Press. When you feel the earth press back — tap." Button "I feel the ground" (.gate-pulse 1.5 s loop) → "✓ The ground answered".
  - **Forge:** "Place your hand on your belly. Over the navel. Breathe into your hand. Feel the warmth build. When the Forge responds — tap." → "✓ The furnace answered".
  - **Prana:** "Three breaths. Fully. Feel the air enter through the nose, descend, fill the belly. Feel each exhale return it, changed." Three dots and "I took a breath" → "✓ The door is open".
  - **Hands:** "Rub your palms together for fifteen seconds. Build heat. Then hold them apart and feel what's between them." A 15 s ring → "✓ The hands are alive".
  - **Pulse:** "Press two fingers to the inside of your wrist, or the side of your neck. Be still. Wait for the beat to surface. When you feel it — tap." The dot pulses every 920 ms → "✓ The beat was always there".
  - **Sonar:** "Find the precise word for how you're feeling right now. Not 'tired' — depleted, heavy, fading, wrung? Say it out loud." Mic → "✓ The signal went out".
  - **Echo:** "Two minutes. Nothing to do. Listen to the room you're in. What sounds are already here?" → "✓ What was always here arrived".
  - **Not built:**
    - Vision SEE.
    - Crow **18** DISSOLVE: "try NOT to see".
    - Axis **19** BLINK: "gate IS the blink".
    - **CONFLICT** with Axis = 18, Crow = 19 everywhere else.
- **SOUND** (chakra-practices SKILL sound responses):
  - Soles and Forge: humming, slice(2,12) average >40.
  - Prana: breath, slice(1,40) >20.
  - Hands: slice(1,30) >25.
  - Pulse: tap BPM.
  - Sonar: slice(3,15) >35 for 3+ frames.
  - Echo: 12-bar visualiser.
  - Crow: shake >7 m/s², still <1.8 m/s².
- **DATA.** `[name]-gate`.

### B.4 · Tree of Life panels (the wake-ups)

**TOL-T · Shared panel template**
Verified across P1–P9 by novel-line diff.

- **SEES.**
  - The persistent Bindu dot.
  - Zoom A−/A+ at bottom-left, 44 px, font 0.85–1.45.
  - Tap cue "tap to continue": a pulsing dot. The first cue waits 900 ms; after that, words × 220 ms (min 1800).
  - A next-colour bleed div.
- **DOES.**
  - **Gate.** "headphones on" (1.2 s) → seed → "press and hold" (2.5 s). Hold for 4000 ms (P7: 3000; P8: 1500).
  - completeGate: haptic 80, `soundAwakening()`, gate fades over 1.5 s.
  - **Continue holds.** 2000 ms; "breathe" holds 2500 ms. Haptic 40. Passive listeners. touchend+click with a 300 ms lock.
  - **Phase steps.** data-step types: interaction / after-body / after-breath / pivot (auto 3.5 s + haptic 50) / breath.
- **MOTION.**
  - Phase transitions fade over 1.2 s.
  - **Release phase timing:** activation 0.5 s; steps at 1.5 s + i×2.5 s; divider 9 s; seed 12 s; miniReveal 15 s; luminance 18 s; dim 21 s; bleed 24 s; Bindu `.awakened` 32 s; binduInvite "watch" at 35 s.
- **SOUND.** Per-panel binaural (StereoPanner, or a merger fallback). The awakening synth uses FREQ, HARM, ATK, SUS, DCY + sub-bass + a noise transient + an 80 ms delay.
- **DATA.** `tol-bodypoint-N` {x, y (normalised), label}; `tol-word-N`.
- **ARRIVE/LEAVE.**
  - Arrive by a QR on the cloth (`/<chakra>-wakeup.html`; printed path `/tree-of-life/…`).
  - Leave by "watch" → `aistrangegame.com/<chakra>-dance.html`.
- **MEMORY.** Cross-panel keys. P6 reads all of them; P9 reads all plus the `prev-*` keys.
- Also: Wake Lock. "The voice systematically removes itself" — the exhale labels go out, release, forge, give, clear, see, then silence.

**P1 · Muladhara · PRESS**
`tree-of-life-v2-panel1.html` (1785 / 852 all read).

- **SEES.** Root network with 6 Shakti nodes; each lights two root paths. A body silhouette. A descent overlay from 0 to .6.
- **DOES.** Tap Shaktis → hold "go deeper" → tap the body where safety lived → hold "the ground shift" → hold "breathe" → 3 breaths.
- **MOTION.** A pulse-screen at the ground shift.
- **SOUND.**
  - Binaural L/R at 128 Hz. Phase 2 gain 0 → .12 over 3 s; +.02 per Shakti, up to .2.
  - Phase 3: R 128 → 132 over 4 s (4 Hz theta).
  - Phase 4: R → 130 over 8 s (2 Hz delta).
  - Phase 5 gain .25 → .10 over 42 s. Fade over 6 s.
  - Awakening tone: 174 Hz, HARM [1,.5,.25], sub-bass 87 Hz, noise transient at 174 Hz Q5.
- **WORDS.** A.3 #2.
- **DATA.** `tol-bodypoint-1` 'safety'.
- **ARRIVE/LEAVE.** Orange bleed → P2.

**P2 · Svadhisthana · FOLLOW**
`panel2` (2001 / 1069; 589 + 481).

- **SEES.** Six drifting lights, each with its own motion:
  - kama: erratic
  - shabda: rhythmic
  - sparsha: an edge ellipse
  - rupa: slow, high in the centre
  - smritya: circles back
  - atma: near the centre, trail 'bright'
  - The finger trail is rgba(232,148,58,.15), max 60 points.
  - 40 particles flow to the word.
- **DOES.** Trace with a finger (touchmove only; proximity under 35 px; haptic 25). Offer one word. Tap the body. Breathe.
- **SOUND.** 144 Hz; R → 150 (6 Hz) → 148 (4 Hz). Awakening tone 210 Hz.
- **DATA.** `tol-word-2`; `tol-bodypoint-2` 'desire'.
- **ARRIVE/LEAVE.** Yellow bleed.
- **Note.** The only panel that leaves a visible trail.

**P3 · Manipura · BUILD**
`panel3` (1966 / 1088; 517 + 572).

- **SEES.**
  - 24 embers form 8 clusters. Cluster positions: Kusumā (.30,.18), Mekhalā (.72,.12), Madanā (.18,.42), Madanāturā (.82,.38), Rekhā (.35,.65), Vegā (.68,.60), Ankushā (.50,.82), Mālinī (.48,.35).
  - Heat rays.
- **DOES.**
  - Shake, read in 500 ms windows: gentle >5, rhythmic >9, violent >25 m/s². Or tap ≥5 times in 2 s.
  - Rhythmic shaking adds +.006 to assembly (capped at .85); violent shaking subtracts .012 (scatter).
  - Complete at .80.
  - DeviceMotion permission is requested at the gate (iOS).
- **SOUND.** 160 Hz; R 168 (8 Hz alpha) → 172 (12 Hz beta) with a wobble. Awakening tone 320 Hz, inharmonic.
- **DATA.** `tol-bodypoint-3` 'will'. No word.
- **ARRIVE/LEAVE.** Green bleed.

**P4 · Anahata · OPEN**
`panel4` (2100 / 1021; 442 + 580).

- **SEES.** A knot (rings + 14 triangles at r90). The heart path draws itself. Green warmth.
- **DOES.**
  - Pinch outward 55 px per layer (fallback: tap).
  - Write a name. Tap where you feel the name. Breathe.
- **MOTION.** autoKnot: at 3 s the rings fade and scale to 2.5 over 4 s; the heart draws; by 11 s it is complete and filled.
- **SOUND.** 256 Hz; R 262 (6) → 261 (5) → 260 (4). The breath swells on the EXHALE. Awakening tone 341 Hz.
- **DATA.** `tol-word-4`; `tol-bodypoint-4` 'love'.
- **ARRIVE/LEAVE.** Blue bleed.
- **Checker.** `verify-tree-of-life-v2-panel4.sh` (300 lines) runs a 4-pass check on exactly these strings and IDs.

**P5 · Vishuddha · SPEAK**
`panel5` (2011 / 1167; 575 + 593).

- **SEES.** 35 lines, tight at 18 px, that spread to .44H. Leaves. Voice waves.
- **DOES.**
  - Make a sound into the mic (fft 256; smoothing .8; level += vol × .012 when vol >.05). Fallback: tap, +.14 each.
  - Complete at ≥.92 with a 5-leaf burst.
  - Write the truth.
  - Make a sound toward the tight place: waves when vol >.08 every 300 ms, max 12, 8 s timeout.
- **SOUND.** 384 Hz; R 390 (6) → 391 (7) → 392 (8). Awakening tone 384 Hz.
- **DATA.** `tol-word-5`; `tol-bodypoint-5` 'voice'.
- **ARRIVE/LEAVE.** Indigo bleed.

**P6 · Ajna · STILL**
`panel6` (1902 / 1200; 658 + 543).

- **SEES.**
  - 14 seeded stars (RNG 73) and the journey points: body points 1–5 joined by dashed lines; words 2/4/5 visible once clarity >.6.
  - Blur 18 × (1 − clarity) px. A warmth overlay.
- **DOES.**
  - Hold the phone still: rotation under 4°/s averaged over 300 ms. Clarity +.25/s while still, −.12/s otherwise, floor .1. Complete at .80.
  - Fallback "touch and hold". A 20 s safety timeout.
- **SOUND.** 426 Hz; R 430 (4 Hz) → 428 (2 Hz). Awakening tone 426 Hz + a 1.5 Hz twin.
- **DATA.** Reads only.
- **ARRIVE/LEAVE.** Violet bleed.

**P7 · Sahasrara · RECEIVE**
`panel7` (1977 / 1170; 575 + 596).

- **SEES.** Names arriving. A crown sentence in gold.
- **MOTION.**
  - Over 6 s the body points rise to the crown. Their colours: rgba Muladhara 139,69,69 · Svadhisthana 196,120,50 · Manipura 196,160,19 · Anahata 45,122,58 · Vishuddha 46,107,158.
  - Then a gold convergence and a shimmer orbit.
  - White light at 17 s.
- **DOES.** Receive; write one sentence; lift the crown.
- **SOUND.** 480 Hz; R 481 (1 Hz) at gain .08, then .06, then dissolving. Awakening tone 480 Hz.
- **DATA.** `tol-word-7`.
- **ARRIVE/LEAVE.** Gold bleed #D4A948.

**P8 · Soul Chakra (Aatma) · HOLD**
`panel8` (1788 / 965; 539 + 427).

- **SEES.**
  - A persistent inverted triangle. Vertices: Kāmeshvarī "इच्छा · will", Vajreshvarī "ज्ञान · knowledge", Bhagamālinī "क्रिया · action".
  - A ghost bleed.
- **DOES.**
  - Hold each question for 4000 ms to absorb it: the text fades to .15 while a gold glow grows to 120 px.
  - Edges draw at 0.5 / 1.5 / 2.5 s.
  - Then the Temple: three breaths of 8 s; the triangle pulses. At 25 s, haptic 80 and "open eyes".
- **SOUND.** Binaural 512 / 512.5 Hz (0.5 Hz beat), gains .04 → .06; triangle swell to .08. Awakening tone 528 Hz [1,.5,.35,.25,.15], detune [−2,0,2].
- **DATA.** Writes nothing. Reads bodypoints and words 2/4/5/7.
- **ARRIVE/LEAVE.** Ghost bleed → P9.

**P9 · Maya Chakra · DISSOLVE**
`panel9` (3066 raw / 2234 extract with 762 style lines stripped; 1944 novel + 291 identical).

- **SEES.**
  - Header comment: "The interface dissolves itself. / One dot. All shapes. Om drone 136.1 Hz. / 'Who are you speaking to?' — tap to dissolve. / 'Now go play.' / The love never stops moving."
  - The gate seed is "There was never anything to fear. There was only You, playing."
  - **Phase 2 · POINTE.** An automatic canvas, timeline in seconds: LINE 2, CIRCLE 4.5, LEMNISCATE 9, EYES 14, BLINK 18, FADE 19, MORPH 20.5, HEART_FULL 25, SWELL 27, FILL 30, SLOW 33, RETURN 40, END 43.
    - Heart: x = 16 sin³t, y = 13 cos t − 5 cos 2t − 2 cos 3t − cos 4t.
    - Eyes: black ellipses with gold iris rgba(222,185,100).
  - **Phase 3 · Eight Inversions.** "Awareness retreats when thoughts emerge." Cycle 7.5 s (Bindu 0–1.8 s, text 2.3–6 s). The eight panel mini-reveals in order:
    1. "The earth was already holding you. / You just told it where."
    2. "The lights you couldn't catch / were leading too."
    3. "The form it made / is the one you've been wearing."
    4. "What you were watching / became what you loved."
    5. "You didn't find something to say. / You finally stopped holding it."
    6. "You were being seen / the entire time."
    7. "It never needed your effort. / It never stopped."
    8. "Your body just remembered a shape / that civilizations built in stone."
  - **Phase 4 · Fear Doorway.** At 1 s: "Think of the fear that most often stops you." Then 15 s of nothing. At 18 s: "Just ask it one question." 27 s → P5.
  - **Phase 5 · The Question.** "Who are you speaking to?" with a "tap" hint at 7 s. A tap dissolves it over 2 s, and the Bindu returns.
  - **Phase 6 · The Mirror, "The Bindu Speaks".**
    - Black. A white dot orbits at 18% height and lerps toward each chakra colour. Colours: root #C0392B, sacral #E67E22, solar #D4AC0D, heart #27AE60, throat #2E86C1, third #6C3483, crown #A569BD, soul #D5C4A1.
    - writeChars at 22 cps (closing at 14 / 12 cps).
    - The 8 STATIONS use the labels: "muladhara · root" / "svadhisthana · flow" / "manipura · fire" / "anahata · heart" / "vishuddha · voice" / "ajna · sight" / "sahasrara · crown" / "soul".
    - Station texts are verbatim in the scratch notes. Examples:
      - Station 4: "You were asked to name someone whose love changed you." / "...Love was never given or received. It was recognized."
      - Station 8: "...The shape was the Temple. The Temple was always you."
    - Answers show as then/now.
  - **Phase 7 · Infinite Bindu Loop.** Seed in the present tense: "There is never anything to fear. There is only You, playing."
    - CYCLE 76 s: DOT 0–3, LINE 5.5, CIRCLE 13, LEMN 23, MORPH 31, HEART 37, CONTRACT 43, TRAVEL 46, TRI_SPLIT 48–51, TRI_HOLD → 58, MERGE 61, TRAVEL_BACK 64, REST → 76.
    - During the hold, labels appear: Knowledge / vajreshvarī at 1.5 s (apex top), Will / kāmeshvarī at 3 s (bottom-left), Action / bhagamālinī at 4.5 s (bottom-right).
    - Links: "the temple →" (`temple-guide-v2.html`, at p >.8) and "the dance →" (`https://aistrangegame.com/maya-dance.html`, at p >.9).
    - Repeats forever.
- **DOES.** The **DISSOLUTION GATES** are inverse actions: "No skip. No timeout bypass."
  - S1 PRESS → RELEASE: "Touch where you placed it. Then release."
  - S2 FOLLOW → LET GO: "Let the word go." The word drifts for 8 s; touching it resets with "still following".
  - S3 BUILD → DON'T ENGAGE: "Don't engage." 8 tempting particles; the walker must go 6 s without tapping; a tap brings "still building".
  - S4 OPEN → CLOSE: "Let the recognition fold back into you." Pinch in (letter-spacing .5em → 0) or tap three times.
  - S5 SPEAK → SILENCE: "Now let the silence hold it." 10 s of nothing → "The silence already held it."
  - S6 STILL → CLOSE EYES: "Close your eyes." + "your third eye doesn't need these ones". 8 s without touch, 3 haptics, then "What did you see?"
  - S7 RECEIVE → OFFER: "Now offer it back." Swipe up >60 px or hold 3 s.
  - S8 HOLD → RELEASE: "Release what you held." Press and hold 3 s → "now let go".
  - Then **Recognition:** "Everything you placed in this space is already moving toward you." (7 s). On a repeat visit: "You've seen it before. The words changed. What they called to you didn't."
  - **Closing:** "What never changes is what was never given." / "You have always had the Knowledge." (#A569BD) / "You have always been the Will." / "Now You Become the Action." (the dot turns white → red) / "Go Play" in red for 6 s.
- **SOUND.** The OM replaces the binaural:
  - 136.1 Hz sine (gain 1) + 272.2 Hz (.3, "warmth") + 68.05 Hz (.15, "depth"); LFO .05 Hz.
  - Master gain steps .01 → .06 → .10 → .15 → stations .08–.13 → recognition .14 → closing .16 → will .18 → **Go Play .20** (the highest) → .06.
  - In Phase 7, at 10 s, the Om goes to 0. The song `maya-chakra-ending.mp3` fades in to .7 (75.86 s).
  - No awakening sound.
- **DATA.** `savePrevAnswers` writes `prev-tol-word-N` and `tol-mirror-completed=true`.
  - **CONFLICT.** The file's own comment says "Panel 9 writes nothing — the dissolution writes nothing."
- **ARRIVE/LEAVE.** QR `/maya-sleep.html`. There is no exit; the loop continues forever.
- **MEMORY.** The Mirror compares then and now; the recognition line differs on repeat visits.

**P10 · Axis · ACCESS — Infinity Heart triptych** (design only; **GAP**, no file)
`tree-of-life/SKILL.md`.

- **SEES.**
  - Dark Field hsl(240,5%,3%); phosphene trails; a neural emergence tree.
  - Blink impacts reveal a Tree of Light. Lemniscate drift.
  - Trails: Blue 3 s → Gold 2 s → White 5 s.
- **SOUND.** Three songs:
  - Left Eye: "Where'd You Go" — Fort Minor, Searching (MISS), E, 89 BPM.
  - Right Eye: "Thunderclouds (Lost Frequencies Remix)" — LSD, Churning (THROUGH), B, 123 BPM.
  - Heart: "Fade Away" — Ash & Paradise, Dissolving (HOME), B, 129 BPM.
  - Binaural 4.5 Hz theta → 40 Hz gamma → 10 Hz alpha.
- **DATA.** A localStorage chain: Left writes → Right reads and writes → Heart reads both (ghost stars).
- **WORDS.** "Fade Away has NO FRUIT." It leaves the walker in the dark with "What is it that I really want?"

### B.5 · Tree-of-Life components

**C-AWAKE · Awakening Sounds**
`awakening-sounds-all-chakras.html` (447 / 357).

- **SEES / DOES.** "tap each to hear the gate arrival sound". Four coloured ripples.
- **SOUND.** "synthesized — no audio files needed".
  - Gain 0 → .25 at the attack, then the sustain, then an exponential decay.
  - Harmonics at integer multiples. A sub-bass root at freq/2 (gain .3). A 50 ms band-pass noise transient. An 80 ms delay at .15.

| Chakra | Hz | Character (verbatim) |
|---|---|---|
| Muladhara | 174 | "Deep, heavy, percussive. Earth drum. The ground announces you." |
| Svadhisthana | 210 | "Warm, rounded, like a wooden bell. Water ripple in sound." |
| Manipura | 320 | "Bright, metallic, like a struck gong. Fire crackle in the overtones." (atk .005) |
| Anahata | 341 | "Pure, open, like a crystal bowl. The warmest sound. Heart coherence." / "love lingers" (dcy 3.5) |
| Vishuddha | 384 | "Clear, ringing, like a struck singing bowl. Voice frequency." |
| Ajna | 426 | "Ethereal, shimmering, like two tones beating against each other." / "the eye opens slowly" |
| Sahasrara | 480 | "High, dissolving, like a bell heard from far away. Almost not there." (dcy 4.0) |
| Soul | 528 | "Sacred, complex. Three tones at once — the triangle in sound." |

**C-CLOSE · Closing Architecture (all 8 panels)**
`closing-architecture-all-panels.html` (555 / 376).

- **MOTION.** From closureTime 0, after a 1.5 s Bindu wait: activation 0 → divider 3 s → release 4.5 → mini-reveal 8 → seed 11 → luminance 13 → bleed 17 → "tap to continue" 19.
  - The Bindu sits at cy × .85.
  - This prototype is faster than the built panels (9 / 12 / 15 / 18 / 21 / 24 / 32 / 35 s).
- **WORDS.** The table is verbatim in the notes. Release lines that differ from the built panels:
  - P2: "What you desire is desire recognizing itself in you."
  - P3: "The fire was never against you. It was forging you."
  - P4: "Love was never given or received. It was recognized."
  - P5: "The truth was never new. It was what you always knew but hadn't given sound to yet."
  - P6: "The eye that never closes carried everything to this moment."
  - P7: "What descends does not need to be reached for. Only received."
  - P8: "The Temple was always you."
  - Luminance: .05 / .10 / .18 / .28 / .40 / .55 / .75 / .90. P8's next colour is #E8E4DF.

**C-GATE · Gate Framework (all 8)**
`gate-framework-all-chakras.html` (724 / 589).

- **SEES.** The Bindu traces an L-system tree (TRACE 7 s / traceSpeed, smoothstep); roots.
- **MOTION.**
  - COLOR FILL over 2.2 s breathes: up to 60%, down to 40%, then commits to 100%. "Bindu persists THROUGH the wash — the constant."
  - REVEAL: the colour fades over 2.5 s to reveal the panel PNG (imagePath is empty — **GAP**). Seed at 1.5 s; hold area at 2.5 s.
- **DOES.** Hold for holdDuration → "<name> — ENTERED".
- **Hold durations** shorten as the body rises: 3500 / 3200 / 2800 / 2600 / 2400 / 2000 / 1800 / 1500 ms.
- **Per-chakra config** (fields as named in the `CHAKRAS` object; trace duration = 7 s / traceSpeed):

| Chakra | holdDuration | glowHeight | traceSpeed | trunkWidth | branchSpread | rootDepth | generations | branchDensity | traceCharacter |
|---|---|---|---|---|---|---|---|---|---|
| Muladhara | 3500 | .85 | .75 | 10 | .3 | 1.2 | 6 | .5 | heavy |
| Svadhisthana | 3200 | .75 | .85 | 7 | .45 | .8 | 6 | .6 | fluid |
| Manipura | 2800 | .6 | 1.1 | 6 | .35 | .6 | 7 | .7 | sharp |
| Anahata | 2600 | .5 | 1.0 | 7 | .55 | .7 | 6 | .8 | open |
| Vishuddha | 2400 | .4 | 1.15 | 6 | .4 | .5 | 6 | .6 | reaching |
| Ajna | 2000 | .3 | 1.2 | 5 | .35 | .4 | 5 | .4 | sparse |
| Sahasrara | 1800 | .2 | 1.3 | 4 | .5 | .3 | 5 | .3 | ethereal |
| Soul | 1500 | .5 | 1.2 | 6 | .45 | .7 | 6 | .5 | reverent |

- Each chakra's seed is its Map signature (Soul: "Will. Knowledge. Action. You already know. You have always known."). Muladhara bgStart #E8E4DF → bgEnd #D4A89A.
- **CONFLICT.** holding_trace is 3 s; its comment says 7 s.

**C-BREATH · Guided Breaths (all 8)**
`guided-breaths-all-chakras.html` (580 / 479).

- **SEES.** A circle scales from .3 to 1.0. Labels "breathe in" (haptic 30) / "hold" (20) / "release" (30). A count "n / N". The Bindu stays at the centre.
- **Patterns:**
  - 4·4·4 "grounding, equal"
  - 4·0·6 "longer release"
  - 3·3·6 "fire, sharp inhale"
  - 5·5·8 opening
  - 4·7·8 "throat clearing"
  - 6·0·6 "even, witnessing"
  - 5·2·7 ×3 "Auto-breath — system breathes you. No labels. No timing shown." (surrendered)
  - Soul 3·2·3 ×3: "3 breaths × 8s — triangle pulses"
- **CONFLICT.** The panels' own breath cycles are longer and repeat 2–3× (A.2).

**C-POINTE · Pointe Animation v2**
`pointe-animation-v2.html` (869 / 755).

- **SEES.** BG #E8E4DF; Bindu #C0392B; eye background #000 ("jet black — the void itself"); iris #D4A948. "No pupil. The Pointe is the red dot."
- **MOTION.** APPEAR 0 · LINE 2 · CIRCLE 4.5 · LEMNISCATE 9 · EYES 14 · BLINK 18 · FADE 19 · MORPH 20.5 · HEART_FAST 25 · FILL 28 · SLOW 31 · RETURN 39 · SETTLE 42 · OSCILLATE 44. The oscillation cycle is 5.5 s.
- **WORDS.**
  - "You watched a dot / become a line." / "The line became a circle." / "The circle became / infinite." / "The infinite / opened its eyes." / "The eyes closed / and love remained." / "What was moving / through all of it?"
  - Then "Who are you speaking to?" → a tap → "Now go play." (fades in over 3 s). At 16 s the Bindu stays at .55.
  - Double-tap restarts (testing).
- **CONFLICT.** P9 replaced these six texts with the eight inversions, and replaced "Now go play." with the Mirror. Its morph is parametric, not a lemniscate dragged down.
- Codex: the Pointe = C-1306, "one particle moving because it loves"; "Pointy — reality's version of Clippy".

**C-TEMPLE · The Temple (guide v2)**
`temple-guide-v2.html` (532 / 108 text lines; 253 style lines stripped).

- **SEES.** An SVG body in the Temple position: arms out, hands at the waist, palms up, fingers curving toward the crown.
  - Left hand WILL Kāmeshvarī; right hand ACTION Bhagamālinī; crown KNOWLEDGE Vajreshvarī; the heart Bindu at the centroid.
  - An antenna beam rises to a higher-self gold dot.
- **WORDS.**
  - Page 1 "the temple": "Nine panels. One body position." / "Your body is the triangle." / "The higher self does not need to be called. It needs to be received." / "We are entering the era of Satya Yuga — the age of truth." / "The Temple is the technology for this era. Not built from silicon. Built from your own body — the oldest technology there is."
  - Page 2 "the practice": "No room. No phone. No panel. Your kitchen. Your backyard."
    - The three breath questions in first person:
      - "What would I spend the rest of my life doing?" (Will)
      - "What have I always known about myself that I have not fully claimed?" (Knowledge)
      - "What is the one thing only I can do?" (Action)
    - "Don't answer. Hold. Breathe. Release." / "The design was waiting for the era. The era is here." / "There is never anything to fear." / "There is only You, playing."
- **ARRIVE/LEAVE.** From the P9 loop ("the temple →").

**C-TREEGATE · Tree Gate Prototype**
`tree-gate-prototype.html` (870 / 748).

- **States:** idle → holding (3 s, with a progress bar) → blinking (the Bindu blinks twice, 0.25 s on / 0.2 s off, then becomes the seed) → growing (8 s) → alive.
- **SEES.**
  - An 8-ripple burst.
  - An L-system of 7 generations: trunk #4A2A1A / #6B3D2A; leaves #2D5A27 / #4A8B3F / #6BAF5B; roots #5A3A2A grow in the first 40%.
  - 60 dust particles. A breathing canopy.
- **WORDS.** "The earth that holds you / was chosen by you." / "press and hold".

### B.6 · The Bindu Dances

**D-SHELL · The VX dance shell** (Muladhara through Vishuddha)
`v3-dance-framework.md` (299) · `vx-build-protocol-v2.1.md` (447) · 5 VX HTMLs.

- **SEES.**
  - Hero "<chakra> · <song> · <artist>" / chakra / verb / "offer one word" / "then tap anywhere".
  - Seven dancers (bindu, gaia, sid, arch, karishma, sakshi, ashrey web). Bloom stages S1–S4 (bloom 0–4: dot → ghost trail → orbital rings → radial rays → crown mandala).
  - Mirror darkness: DARK_RATIO P1 1.0 "Full blackout. Earth doesn't spare you." · P2 .85 "Water obscures." · P3 .70 "Smoke." · P4 .55 "Twilight." · P5 .40 "Passing cloud." · P6 .25 · P7 .12 · P8 .05 · P9 0.0 "Mirrors become BRIGHTER. Love = more light."
- **DOES.**
  - Read the seed typed at the BPM. A word is REQUIRED.
  - Tap anywhere. The page goes fullscreen; gyro and accelerometer start.
  - Motion is read as still / swaying / moving (accelSmoothed <.5 / <2).
- **MOTION.**
  - The word seeds the movement: wavePeriod .3 + len × .08; fluidity .3 + vowelRatio × .7.
  - "Color is sacred — word can seed movement but NEVER the hue."
  - Five mirror words at MIRROR_TIMES, built from consonant-skeleton families (e.g. FLOW → FEEL/FALL/FULL/FILL/FLOW), each shown 1.8 s.
  - The word is revealed at PEAK_T in the bottom 15% (letter-spacing dissolve 3.5–4 s). "I Love You" at PEAK_T + 5 in the bottom 10%.
  - Adaptive return.
- **SOUND.**
  - Song volume goes 0 → 3 s → ramps +.01 per 50 ms to .8; `waitForAudio`.
  - "Binaural" is ONE sine through a StereoPanner panned by gamma/45, with tremolo. This is **not** true binaural (**CONFLICT** with the framework's "binaural").
- **DATA.**
  - Writes `tol-<chakra>-dance='true'` and `tol-<chakra>-dance-word`.
  - Appends to `bindu-memory` as an **array** {word, song, artist, chakra, verb, timestamp, dwell, motion, tilt}.
  - Reads `tol-<chakra>-word` and the previous chakra's dance word.
- **WORDS.** The **ALIVE FRUIT** = fruit + dwell line + motion line + count line + echo ("You keep returning to 'X.'") + cross-dance message + signature (chakra · song · artist).
- **MEMORY.** Bindu Memory constellation dots at hashed positions; count of dances; most repeated word.

**D-MUL · Muladhara · ARRIVE — "Iron", Woodkid**
`muladhara-dance.html` (1139 / 1076 all).

- **Constants.** DUR 201.7; PEAK 188; HUE 12; RETURN_START 15; DARK 1.0; 136 Hz; BPM 129 (seed 460 ms per char); 201 hits at .20. MIRROR_TIMES [26,50,98,146,188].
- **MOTION.**
  - Fracture at the detonation, 16.32 s (16 cracks).
  - The Bindu CLIMBS from bottom to top.
  - Screen shake, gravity drop, dust, underglow, seismic lines, aftershock half-rings. Double-pulse "da-DUM war drum" haptics.
  - GROUNDING return.
- **WORDS.**
  - Seed "You chose this."
  - Fruit: "The iron in your blood is the same iron in the stars. You were never lost. You were planted. The ground was always yours."
  - Dwell: "You arrived without hesitation." / "You paused before you arrived." / "You searched before choosing to land."
  - Motion: "You held still." / "You were swaying with the ground." / "You were moving."
  - Count: "This is your first arrival." / "You have arrived N times."
  - V3 mirror words: BODY → BLOOD → IRON → STAR → HOME.

**D-SVA · Svadhisthana · FEEL — "Crystallize", Lindsey Stirling**
`svadhisthana-dance.html` (1081 / 1006).

- **Constants.** DUR 258.8; PEAK 151; **HUE 220 (blue)**; DARK .85; 144 Hz; BPM 70 (857 ms); drop 185.5. MIRROR [33,76,119,151,210].
- **MOTION.**
  - The Bindu ORBITS on three tides (0–70, 70–130 breathing, 130–180 peak, 180–185 silence, 185–190 drop).
  - Ribbon trails, currents, droplets, a whirlpool, wave haptics. EVAPORATION return.
- **WORDS.**
  - Seed "You knew before you had the word for it."
  - Fruit: "There are no lyrics because you didn't need language to feel. Before your first word, you already knew joy, fear, warmth, cold. The violin is your body remembering what it knew before your mind took over." … "Trust what you felt just now. It was more accurate than anything you could say about it."
  - Count: "This is your first dance."
- **CONFLICT.** The title verb is FEEL; the memory verb is 'flow'. The session handoffs list P2 as "Paro — Nej".

**D-MAN · Manipura · BUILD — "Powerful", Major Lazer ft. Ellie Goulding**
`manipura-dance.html` (882 / 836).

- **Constants.** "MERGED (4 Layers)". DUR 206.3; PEAK 33.5; HUE 35; DARK .70; 160 Hz; drops 15.0 / 92.5 / 155.0. MIRROR [25,65,93,130,185].
- **MOTION.**
  - BURN MAP 25 × 35 (heat and fuel). First ignition at drop 1. 3 BACKDRAFTS.
  - Combustion trail IGNITE → BURN → ASH. Flare eruptions. FIRE RETURN.
  - Fuel exhaustion order: Ashrey → Sakshi → Arch → Sid → Gaia → Karishma → Bindu (the last coal).
- **WORDS.**
  - Seed "What are you willing to burn?"
  - Fruit: "You gave this fire 'W.' It burned through everything that wasn't that. What's left is what couldn't be destroyed — and it's still warm."
  - Cross: "The water held '<svad word>.' The fire transformed it into 'W.'"

**D-ANA · Anahata · OPEN — "Love Me Like You Do", Ellie Goulding**
`anahata-dance.html` (486 / 440).

- **Constants.** DUR 249.3; PEAK 234; HUE 330; DARK .55; 256 Hz; drops 21.0 / 33.5 / 41.5 / 191.5 / 192.0 / 193.0 (gasps). MIRROR [45,85,130,172,215].
- **MOTION.**
  - WARMTH MAP 30 × 40 with memory. Heart opening at drop 1. Three gasps.
  - Pulse-heart trails. Hexagram, 12 lotus petals, infinity weave + cardioid. HOLD RETURN.
- **SOUND.** "thub-THUB" haptics [25,80,50].
- **WORDS.**
  - Seed "This is the only song that talks to you."
  - Fruit: "You gave this song 'W.' What are you waiting for? That question was never for someone else. It was for you. You're the light AND the night. You're the cure AND the pain. You weren't waiting for love to find you. You are the love. The heart doesn't receive — it recognizes what was already there."
  - Count: "This is your first opening." / "You have opened N times."
  - Cross: "The fire forged 'X.' The heart breathed it into 'W.'"

**D-VIS · Vishuddha · SPEAK — "The Sound of Silence", Disturbed**
`vishuddha-dance.html` (279 / 244).

- **Constants.** PEAK 251.5; HUE 200; BPM 172.3; DUR 262.4; DARK .40; RETURN_START 5; 384 Hz. MIRROR [40,85,130,175,220]. Drops 109.5 / 247.0.
- **MOTION.** ECHO MAP. Great breath 235–247 s. ROAR haptic at 247 s. Aperture, 16-petal lotus, Outer 10 triangles, vibrating strings. "I Love You" at 256.5 s.
- **WORDS.**
  - Seed "Everything you're about to hear, you already know."
  - Fruit: "You gave this song 'W.' You held it through the whisper, the roar, and the silence that came after. The truth was never hidden from you. You were just too loud to hear it."
  - Count: "This is your first voice." / "You have spoken N times."
  - Cross: "The heart breathed 'X.' The throat released it into 'W.'"

**D-AJN · Ajna — "Experience", Ludovico Einaudi** (FIRST-PASS: no word, no binaural, no storage)
`ajna-dance.html` (288 / 257).

- **SEES / MOTION.**
  - DUR 315.6. The Bindu is perfectly still until 28 s.
  - Piano onsets deposit stars. Lines are coloured by journey chakra in REVERSE (Vishuddha → Muladhara).
  - LOVE_T 256. A tear falls at 270. Fade at 300.
- **WORDS.**
  - "This song has no words. It doesn't need them."
  - Fruit: "The piano gave you five minutes with nothing to think about and everything to feel... Experience. Not analyze. Not judge. Just experience. What did you see?"

**D-SAH · Sahasrara — "Golden", HUNTR/X** (first-pass)
`sahasrara-dance.html` (307 / 276).

- **MOTION.** DUR 198.8. CROWN_OPEN 19.09. Blooms. Daughter-dots in 7 colours. Golden rain at 193. LOVE_T 197 (99.1%). No fade to black.
- **WORDS.**
  - "You've been hiding."
  - Fruit: "'I was a ghost.' You know exactly what that means. You've been performing a version of yourself that isn't you — playing both sides, dimming yourself, calling yourself a problem. 'I'm done hidin', now I'm shinin' like I'm born to be.' This isn't aspiration. This is recognition. You were always golden. The only thing that was ever wrong was that you believed you had to earn something you were born with. Shine isn't something you achieve. It's what's left when you stop hiding."

**D-AAT · Aatma (Soul) — "Chase", Joy Corporation** (first-pass)
`aatma-dance.html` (279 / 248).

- **MOTION.** DUR 282.4. SOUL_OPEN 17.09. Three vertices start 2.5 × maxR outside the frame and converge. QUIET 190–215. MERGE / LOVE at 270 ("Three become one"). Amber. The breath slows from 1.5 to 0.2.
- **WORDS.**
  - Seed: "What you're about to hear was created by a brain that reorganized itself..."
  - Fruit ends: "You've been chasing something your whole life. You were never chasing anything. It was chasing you."
  - Chase Hughes is never named.

**D-MAY · Maya — "Love Is The Only Thing", Lost Frequencies** (first-pass)
`maya-dance.html` (318 / 286).

- **MOTION.** CYCLE 76 s loop with 10 stages. Each stage is a panel colour:
  - DOT 0–3 red
  - LINE orange
  - CIRCLE gold
  - INFINITY 13–25 green
  - HEART 25–37 green ("I Love You")
  - CONTRACT blue
  - TRAVEL indigo
  - SPLIT 50–58 gold (3 dots)
  - MERGE soul amber
  - REST white
- **WORDS.**
  - "You already know what this song is about."
  - Fruit: "'The more you give, the more you get back again.' … A mirror. And the only thing that was moving in the mirror was love... Open up your heart. Let all the sunshine in. That's not a metaphor. It's an instruction."
- **CONFLICT.** These stage timings differ from the P9 loop.

**D-FIRSTPASS · First-pass seeds and fruits, superseded for 1–4**
`session-handoff-bindu-dances-complete.md`.

| Dance | First-pass seed | First-pass fruit |
|---|---|---|
| Iron | "You don't remember how you got here." | "This song is about you. Not a soldier — you... 'A million mile from home.'" |
| Crystallize | "This song has no words. Neither did you, once." | — |
| Powerful | "You think this song is about another person." | "It's so powerful, I can feel it... You were drained because you were blocking it." |
| LMLYD | — | "...You're the light, you're the night, you're the colour of my blood. Read that again..." |
| Sound of Silence | — | "People talking without speaking..." |

- **Bindu readings:** Incarnation → Sensation → Contact → Recognition → Truth → Vision → Radiance → Return → Love.
- **Sentence underneath:** "Arrive. Feel. Contact. Ask. Speak. See. Shine. Be. Love." ("Six are spoken. Three are held in silence.")

### B.7 · The layer pages (VX 4-layer build: 12 files)

Each merged dance is assembled from four standalone test pages (`vx-build-protocol-v2.1.md`: 74 checks).

**L1 · Bindu Performance** — `manipura-layer1` (648 / 624), `anahata-layer1` (873 / 849), `vishuddha-layer1` (449 / 426).

- **SEES.** The ensemble only, "just dots on black". Hero "<chakra> · layer 1 / bindu performance · tap to begin".
- **Manipura (fire):**
  - Combustion trails. Orbital rings, 12 rays, flame tongues, crown mandala + solar corona.
  - Return: "dancers freeze, hues shift to ember, the fire goes out ... Bindu (last coal)".
- **Anahata (heart):**
  - Pulse ghost trails, "each ghost position beats ONCE".
  - HEXAGRAM (Shiva up / Shakti down). 12 LOTUS PETALS. INFINITY WEAVE (4 lemniscates) + CARDIOID + a large heart at bloom >.85: "No other panel has this shape".
  - Arch is DOMINANT (59.4% mids), with vocal resonance arcs and an ARCH ATTRACTOR.
  - PROGRESSIVE UNIFICATION: "Q1: 7 distinct → Q2: edges soften → Q3: colors bleed → Q4: ONE body".
  - HOLD RETURN.
- **Vishuddha (throat):**
  - Resonance-ring trails. APERTURE + pressure waves. 16-PETAL LOTUS. OUTER 10 TRIANGLES (5 up, 5 down). A central bindu, "the silence at the center of expression".
  - "Whisper → Roar vertical journey". ECHO RETURN.

**L2 · Element Canvas** — `manipura-layer2` (468 / 444), `anahata-layer2` (529 / 505), `vishuddha-layer2` (239 / 221).

- **SEES.** Atmosphere only, with a simulated Bindu and Arch. Hero "layer 2 · atmosphere test".
- **Fire:**
  - BURN MAP 25 × 35. Oxygen starvation. First ignition "replaces fracture detonation".
  - Backdrafts, flash-burn, combustion rings, flare eruptions ("solar ejections"), heat bloom, spark fountain, firebrand scatter.
  - Fuel drains in the last 18 s.
- **Heart:**
  - WARMTH MAP 30 × 40: "No fuel system. Warmth accumulates where love has been ... thermal inertia. Memory of warmth." ("loved places glow different")
  - BREATHING GRADIENT, "the room HAS a heartbeat". DARK .55: "(twilight) The heart knows both."
  - HEART OPENING at 21.0 s: "NOT explosive. The heart opens."
  - THREE GASPS. BLUSH, "The room blushes". Motes: "Dust in warm light. Breath made visible."
  - Return: "NOT black exhaustion. The heart at rest. Still alive. Just quiet."
- **Throat:**
  - ECHO MAP: "Cool blue-white palette — ether, not warmth"; "places spoken into remember".
  - THE GREAT BREATH at 235–247 s. Voice luminance. Silence grain: "individual motes of silence".

**L3 · Device Performance** — `manipura-layer3` (240 / 220), `anahata-layer3` (253 / 233), `vishuddha-layer3` (209 / 194).

- **SEES.** A sensor test panel: "activate sensors"; gyroscope α β γ; still / swaying / moving; "binaural <Hz>Hz: active". Song at volume .3.
- **Haptic grammars:**
  - EARTH: "da-DUM war drum".
  - FIRE: "Staccato crackle — snap-crackle of wood splitting" [15,5,15,5,20,5,15]. Backdraft [40,10,40,10,40,10,40,10,60].
  - HEART: "thub-THUB short-LONG like systole-diastole" [25,80,50] / [18,90,35] / [12,100,25]. Gasp [15,30,15,30,15,50,40,15,30]. Ambient [8,60,15].
  - THROAT: "Sound = sustained vibration, not sharp impacts" [15,40,12,50,10,60,8]. Below .3: "The whisper doesn't vibrate the body." Roar at 247 s. silenceHaptic [4]: "The silence noticing itself."
- **Binaural notes.** "Gyroscope pans the tone — frequency exists in SPACE". 384 Hz: "Highest frequency yet. Clear, thin, precise — the throat's frequency."
- **Outputs.** gyroX = (γ/45) × maxR × .25 × fluidity.

**L4 · Consciousness Loop** — `manipura-layer4` (429 / 365), `anahata-layer4` (329 / 283), `vishuddha-layer4` (395 / 337).

- **DOES.** "The experiencer's journey: seed → word → mirror → reveal → fruit". Anahata's version: "Seed → Word → Dance → Reveal → Fruit".
- **SEES.** A debug overlay: t, word, motion, wp, dances, prevWord, panelWord.
- **Notes.**
  - Manipura comment: "SEED TYPING (99 BPM ≈ 605ms, but using 857ms for readability)".
  - "5 mirror moments: pre-peak, mid-plateau, drop 2 zone, quiet interlude, late winding."
  - Vishuddha L4 calls `saveToBinduMemory`. The Manipura and Anahata L4 pages write only the cross-panel keys.

### B.8 · The master map pages

**MAP-VX2 · Chakra Map VX2 (the 33-point master map, 5 acts)**
`chakra-maps/assets/chakra-map-vx2.html` (1603 / 928).

- **SEES.**
  - Backgrounds: void #0D0B14 / energy #100818 / body #081214 / mind #0A0816 / structure #0A0A0E / map #08060E; gold #C9A84C.
  - Chakra tones: crown #8B00FF … root #DD2222.
  - Act 0: a gold Bindu → "What do you need right now?" → seven doors "Stability · Flow · Power · Love · Truth · Clarity · Connection" → "Or start from the ground and go up ↑ / Or explore the full map ↓".
- **DOES.**
  - Tap a door → after 800 ms, scroll to and open that chakra.
  - Open three-layer cards, one open at a time (close 300 ms, open 400 ms).
  - Body pairs: Crow + Soles → circuit line + a chord (480 Hz, then 256 after 100 ms). Prana + Forge → a breath path (dashed 3,5, 6 s). Hands + Soles → pair glow. Tap Axis → blink flash. Tap Echo → the page goes quiet for 1.5 s.
  - Mind triads fill (completion phrase holds 4 s).
  - Axis Flip ◑/◐ toggles light mode.
  - Font scales 1 / 1.1 / 1.2 / 1.32.
- **MOTION.** hbPulse .833 s (72 BPM), inWv 4.5 s, Leela spin 60 s, riseG 6 s, pairPulse 1.2 s ×3, axBlink .25 s, page breathing.
- **SOUND.** playTone on each card: sine, gain 0 → .12 in .15 s, then exponential decay to .001 at 2.5 s.
  - **data-tone:** Sahasrara 480 · Ajna 426 · Vishuddha 384 · Anahata 341 · Manipura 320 · **Svadhisthana 288 · Muladhara 256**.
- **WORDS.**
  - L3: "The Bindu learns to X". The Act 4 Tree has seven nodes: LALITA "The Play", Bindu "The Seed", Shadow "The Roots — What's Underground", Armin "The Roots — Where They Lead", Axis "The Trunk", Maya "The Canopy — The Outer Form", Aatma "The Heartwood — What Was There First". **No Ego Reveal.**
  - Visits: "You touched N of 33. The rest are waiting." / "You touched every point. The map touched you back."
  - Return egg: "You came back to the point." / "The same point."
  - THE PLAYGROUND: "From Muladhara to Lalita. From ground to play. Now flip it. A Play Ground... Soles. Souls. Bind. U. Crown − N = Crow. Lonely → Leela. It's That Simple."
- **DATA.** `chakra-map-visits`. At 32 visits: `complete-32`.
- **ARRIVE/LEAVE.** Link-outs only at the map close.
- **MEMORY.** Entry memory: "You came back." / "Last time you touched N of 33..."

**MAP-VX1 · Chakra Map VX (V1, 31 chakras)**
`chakra-maps/assets/chakra-map-vx.html` (1046 / 569).

- **WORDS.** "Everything begins as a point. / One point. Four directions. Thirty-one expressions. / The energy rises. You descend to meet it. / descend".
- **Counts.** 9 body points (no Soles). Structure 6. Map 7 / 9 / 9 / 6 = 31. Visits "of 31". Zoom 1 / 1.08 / 1.16 / 1.24.
- **Structure card:** "The Axis triptych leaves you in the dark with one question: What is it that I really want?"

**MAP-STORY · Per-chakra Story Map (Muladhara "The Ground")**
`chakra-maps/references/per-chakra/muladhara/README.md` (31).

- A 5.5 × 8.5 book in 7 layers: Surface → Line → Ground → Root → Bedrock → Seed → Return.
- Naming page: "What you just felt has been called Muladhara for thousands of years."
- Soles surfaced through a BPM anomaly (161.5 misattributed to Muladhara → Gaia Inverted).

**MAP-VOICE · A Strange Voice (Voice II, five acts)**
`chakra-maps/references/voice-ii-framework.md` (366).

- Call → Response → Inversion → Dissolution → Tree.
- Act 0 bg hsl(25,15%,5%): "Before you had a name, I had a name for you." A heartbeat at 72 BPM, 0.5% brightness.
- Act 3: "Those weren't metaphors. They were instructions." / "You are the insides of Planet Earth."
- Act 4 breath 4 / 4 / 4: "That was me. Breathing through you."
- Act 5: "Put your feet on the ground... Talk to me. I've been here the whole time." No closing Bindu; the heartbeat doesn't stop.

### B.9 · A Strange Game: the playing side

**G-LEELA33 · Leela on the 33** (single-file prototype)
`a-strange-game/references/the-playing-side/leela-on-the-33.html` (346 / 250) · `18-leela-on-the-33.md` (20).

- **SEES.**
  - A pale stone ground #E3E9EA. 33 rounded squares in boustrophedon, three columns (COLX 60/180/300, ROWH 58, BASEY 650), each in its Map colour.
  - Gold arrows. Violet dotted snakes. A peacock token #0F7C7A. An SVG die.
- **DOES.**
  - Write an intention: "What are you bringing to the board?"
  - Choose "My life" / "What I'm building".
  - "Enter the board". Throw the die (crypto random).
- **MOTION.** The die "rolls" for 480 ms. The token hops 170 ms per square. A 300 ms pause before an arrow or snake moves it.
- **SOUND.** None.
- **WORDS.** Section C gives the verbatim board rules and the square sheet.
- **DATA.**
  - `asg.leela33` {intent, mode, pos, born, path, done}.
  - Optional `window.claude.use("sample")`, quick tier.
- **ARRIVE/LEAVE.** "Begin again with a new question" clears the state.
- **MEMORY.** The path; the closing reading names the whole walk.

**G-ENGINE · ASG Play Engine v0.1** ("The playing side": Leela engine + The Draw + The Sakshi Pause + the book)
`a-strange-game-play.html` (666 / 540) · `19-play-engine-v0.md` (27).

- **SEES.**
  - Peacock cloth #0F4A50 with a woven texture. A marigold dot #F2B632. Ivory paper #F4EBDA. Gloock + Newsreader.
  - Home: a wandering dot (5200 + 900 ms tweens); "The playing side"; the seed "I'm holding it for you, because you held it for me."; three doors (a die, a card, a circle); footer "Your book" · "nothing here keeps score".
- **DOES.** `hold()`:
  - Die 2200 ms; Draw 1900 ms; Pause 4000 ms.
  - Releasing early eases back at −.04 per frame. There is no fail state.
- **SOUND** (Web Audio, starting on the first touch):
  - bell(f): f for 2.6 s at .18 + f × 2.76 for 1.6 s at .05 + f × .5 for 3 s at .05
  - step: 196 Hz triangle, .16 s
  - rise: 330 → 660 and 495 → 990 over 1.4 s
  - settle: 247 → 123 over 2 s
  - breathIn: 174 Hz, 3.8 s
  - breathOut: 261 → 196 over 4.6 s
  - rattle: band-pass noise at 1900 Hz
  - **Bell pitches:** letter ready 880 · born 523 · arrive 392 · throw 660 · card 740 · pause end 523.
  - Haptics: 8 on press, 12 at full, [10,40,10] on a throw.
- **WORDS.**
  - Room buttons: "I did it" / "Let it be".
  - Letter: "The letter is being written." → "A letter for you. Open it, or keep it for later." / "Keep it unread for now" / "Keep in the book" → "Kept".
- **DATA.** Store prefix `asg.play.`: book (≤200), sound, leela, leela.played, draw, comp.<Name>, season.legends, sealed.
- **Leela (engine version):**
  - Intro: "What are you carrying into this game?" (placeholder "a question, a wish, a wall, a wondering") / "Carry it in" / "For life, or for something you're building. The board reads either."
  - Idle: "You wait unborn at 33, where the game also ends." / "Press and hold the die. Let go when it's ready."
  - Hold: "Breathe in." / "Let go when the ring closes." → "Let go." Early release: "No hurry." / "Hold again when you're ready."
  - A non-six while unborn: "A breath at the threshold." / "Breathe once. Throw again when you're ready. A six brings you in." The token brightens +.15.
  - **First-ever game rig:** a six arrives within three throws.
  - Born: "A six. You are born." / "The token comes down to the first square." / "A six throws again."
  - Overshoot: "Not yet. The board waits for an exact landing on 33."
  - Each step makes a step sound (560 ms per square).
  - Arrow: "An arrow lifts you." (rise, 1600 ms). Snake: "A snake carries you back to a lesson." (settle, 2300 ms).
  - Arrival lights the path tiles one by one (#F2B632) with bell 392. Closing letter rule: "No score, no verdict, nothing about how well they played. End by giving the intention back to them." Fallback: "Your walk: … The game ends where it began. What you carried in was held the whole way." / "What will you carry out?" / "Rest here".
  - Square 32's room title is "Held".
  - Book: "Walked: 'intent'".
  - SQ hexes differ slightly from the single-file version (Shadow #3A322C; Hands #1E5A2B; Pulse #1B4524; Sonar #1B2B5E; Echo #172150; Vision #6B5712; Axis #2C1A6E; Crow #4A1A66; Mind squares lighter).
  - Bindu practice here: "Touch the screen once, wherever your hand moves."
- **The Draw:**
  - "Chance places a card in your hand. What you do with it is yours."
  - Hold the deck 1900 ms (rattle). The card lifts −26 px over 600 ms and flips over 1300 ms. Bell 740.
  - One card per day: "Today's card." / "Carry a line from your day into it?" / "Ask the card" / "Keep the card" / "Let it go and draw again".
  - 24 cards: A six to be born · The exit square · The quiet hour · Feed before you build · Offer the work · The dry season clause · The earth is witness · Three knowing breaths · One hum · The day's planet · Pardon at night · A gate in the year · Board night · Gaia asks · Sid holds · Arch speaks · Sakshi sees · Karishma arrives · Bindu moves · Lalita plays · Recognition · Trust · Devotion · Surrender.
  - Planets by weekday: Sun "the Self…", Moon "family and home", Mars "courage and the body's work", Mercury "messages", Jupiter "teaching and generosity", Venus "beauty and affection", Saturn "endings, tidying, boundaries".
- **The Sakshi Pause:**
  - Hold the orb 4000 ms = inhale (r 46 → 110, breathIn, "In."). Release = exhale over 5200 ms ("Out."). Three beads.
  - "Again, when you're ready." / "One breath is a whole practice. Stop here."
  - Close: "No agenda" / "The float that needs no clock." Keep: "{n} breaths, no agenda."
- **Book:** "Your book" / "What you chose to keep. It stays on this phone." / "Nothing kept yet. Whatever you keep from a game will be here."
- **LAWS string:** "never score, grade, rate, rank, judge or predict; no urgency; offer never command; no claims of certainty; no exclamation marks, no emoji; crisis care line".
- `letter()` has a 12 s fallback and is ≤80 words + one open question.

**G-SKETCH · The Sketchbook ("Ten ways to play")**
`a-strange-game-sketchbook.html` (678 / 556) · `20-sketchbook.md` (27).

Intro: "A wide net. Each sketch is a different verb and a different world. Play them all; keep what comes alive."

1. **Choose** (Story, after *Life is Strange*, #3B2A55).
   - A moment becomes a scene + 3 choices + consequences. Claude writes ≤40 words, "carrying both a gift and a cost, never a verdict".
   - "a butterfly lands: this was noted". Hold the spiral 1400 ms to rewind. "Live this one".
2. **Talk** (Role-play, after *Mass Effect*, #1D2F5E). A ring of TEN vantages, each with its line:
   - Gaia "The asking always precedes the answer."
   - Sid "The goal is already accomplished. The work is holding it."
   - Arch "Teach before you sell. The invitation never closes."
   - Sakshi "What is seen completely, completes itself."
   - Karishma "It was ready before you were."
   - Ashrey "The architect who discovers he is the architecture."
   - Neev "What consciousness stands on."
   - Shweta "What consciousness flows through."
   - Bindu "Always moving. With love."
   - Lalita "Knows the game. Plays anyway."
   - Dialogue wheel: Ask · Tell · Wonder · Stay quiet.
3. **Manage** (#1F4D2B). Sign five of 12 practices. A simulated week (58% play chance). Commentary: "a rest day ... the bench is part of the game". Legends at ≥12 appearances. "You are the manager. You are never rated."
4. **Join** (after *Florence* · Invention, #6E4A1E). Drag two tiles together; Claude names the third.
5. **Turn** (after *Monument Valley*, #7A2E1E). Three rings of 12 marks. Align them → bells 392 / 490 / 588. "The point appears."
6. **Trace** (Bindu, #22205A). Follow a dashed inward spiral (r = 320 − 16.5t over 3 turns). Reaching within 26 px of the centre after 40 points → bell 523, "The point." + "Everything begins as a point. Everything ends as a point. The same point."
7. **Still** (#0E5566). Tilt (or drag) a drop into the centre; a ring fills over 7 s → "Held." / "Stillness was the whole game."
8. **Beat** (Pulse, #5E1B2B). A 60 bpm heartbeat at 98 Hz. Taps within 130 ms glow gold. After 8 near taps, a second drum at 147 Hz: "The music answers." / "A second drum has joined you." / "Nobody is counting."
9. **Release** (Seven Gates, #123A4A).
   - Cards: a certainty / a self-picture / a story / a protection / an effort / a borrowed desire / the grip itself.
   - Drag down = set down; drag up = keep ("That's allowed.").
   - Then GIFTS rise: steadiness, in your feet; warmth, in your belly; a breath that needs nothing; an open hand; a true word, in your throat; clear sight, behind the eyes; space, above the head. Bells at 440 + 40k.
10. **Seal** (after *Kind Words*, #6A5A3E). A letter that opens tomorrow / in a week / in a season. A wax seal.

**Playtest:** Fun — Turn, Trace, Beat. Okay — Still, Join. Not a game — Choose, Talk, Manage, Seal, Release.
**Rule:** "every game on astrangeigame.com is a physical verb with a skill in it, instant feedback, a clear arrival; words only as the reward".

### B.10 · Bindu Chakras App mechanics

`bindu-chakras-app/SKILL.md` (53) · `references/*` · `scripts/bake_walk_canon.py` (230).

**BCA-BRAID · The braid**

- Five threads: story · practice · wake-up · dance · gate. Sequential within a thread, free between threads.
- One convergence: Lalita opens when all 33 gate offerings are given.
- **Six moments per room:** Arrival → Story → Practice → Wake up → Dance → Gate.
  - The wake-up ends on one word ("Built." / "Opened." / …).
  - Dances inherit the chakra's Bindu Song.
  - Awakening sounds are synthesized (174 Hz → Silence).

**BCA-FLOOR · The one-second floor**

- Blink. Breathe. Press. is a complete day: "That was a full day of walking. Everything else today is extra."
- **Doors.** Three doors, never five.
  - Morning doors are directions (e.g. "Return to the corridor" / "Open the heart" / "One second").
  - Midday doors are sizes ("One sound (90 seconds)" / "One second" / "one full room").
- **Ground greeting:** "Day N. The road is quiet where you left it."

**BCA-PULSE · The pulse**

- From Shadow (9) to Ego Reveal (32): the story is unvoiced, with a warm ~60 bpm haptic at the bottom of the glass.
- "never explained, never in a tutorial, never acknowledged".
- At 32: "I never left. I changed my voice."

**BCA-GATE · Gates**

- Gates unseal when every other thread has passed: "The gate is warm".
- An offering leaves: the text lifts → becomes an ember → departs. "The room keeps what you gave it. You walk lighter."
- Sealed gates are shown as a shape.
- Gates 27, 29, 32 and 33 are Gaia's letters: the Siddhi letter; farewell "I love you"; "It's me" / "It was me"; "Now we play".
- Position 9 has no mudra; press-and-hold IS the gesture.

**BCA-WEATHER · Weather and grace**

- The ground wears the story thread's weather.
- Corridor re-entry: three slow-dark breaths, no title. The exit "dark thins at one edge".
- **Grace:** a quiet co-reader from App Activity, once and then rest, never tappable. Example: "Three nights ago you finished a door in the Gita. It was standing in this room."
- **The day closes on one Sakshi sentence.** Example from the brief: "You walked one second at a kettle, one sound in a parking lot, and opened the heart at night. The corridor waited. It trusts you."

**BCA-VOICE · Voices**

- Experience Brief: Gaia through room 8; unvoiced + pulse for 9–31; her voice returns at 32; merged at 33.
- **CONFLICT.** Room Registers give Manipura Bindu, Anahata Higher Self, Ajna Sakshi and Sahasrara Lalita.

**BCA-FAMILIES · Gesture families**

- STILLNESS 2–8, MOVEMENT 10–19, VISUALIZATION 21–29, RECOGNITION 1, 9, 20, 30–33.
- Hold durations shorten as the walk ascends.
- Design laws:
  1. Fresh-build each room
  2. Weather
  3. Pulse
  4. Anti-pattern canon (no streaks, badges, dots, progress bars, congratulations)
  5. Voices never announce themselves
  6. Next-colour rhyme
  7. ◆ may deepen, never flatten

**BCA-CANON · Walk Canon bake**

- `bake_walk_canon.py` reads The Map and The Builds through the Airtable API using `urllib` (its docstring says `requests`).
- Groups: identity / arrival / story / practice / wakeup / gate / depth / author_substrate, plus an `activation` field `fldkOhQ5bDhECaVJs` that is not in the Delta Map.
- It requires all 33 rooms, positions 1..33, and the fields name, verb, color_hex, voice, activation, threshold_hint, core_question, story_thread, signature_phrase, teaching, practice, gate_type and gate_text. Otherwise: "CANON INCOMPLETE — refusing to bake".
- Laws block: author_substrate never surfaced verbatim; quarantined fields (`fld0peL6gvkB9JeRe`); dance inherits Bindu Song; Reveal held in build.

**BCA-GIFT · Gift pairing** (Chakra Game pieces → rooms)

| Piece | Room |
|---|---|
| Correspondence | grace / Incarnation |
| Seed | gate offerings |
| Shadow Translator | Room 32 gate |
| Corridor | Room 9 |
| The 108 | floor ethic |
| Coherence | Room 14 |
| Drum | root pair |
| Shake to Clear | Room 19 |
| Spine Walk | Room 18 |
| Water Level | Room 3 |
| The Fire | Rooms 4 / 11 |
| Root System | Rooms 2 / 10 |
| Sri Yantra | Room 1 / Aatma |
| Mirror Maze | throat pair |
| Body Map | body arrivals |
| Child Space | Room 28 |
| Sanctuary | Room 29 / post-32 |
| Living Mandala | sealed |

- The Chakra Game registry (`registry.js`) lists 18 games in six categories. Its `CHAKRAS_7` uses Solfeggio frequencies: root 396 / sacral 417 / solar 528 / heart 639 / throat 741 / third eye 852 / crown 963 Hz.

### B.11 · Cross-cutting mechanics (one line each, with source)

| Mechanic | What it is | Source |
|---|---|---|
| M-DOT | The persistent Bindu: 6 px #C0392B, top-right, opacity .3, z150, "never explained". It wakes at 32 s of each closure. | ToL SKILL; P1–P9 |
| M-HOLD | Press-and-hold is "the signature gesture of the entire game". 1.8 s commit; 1.0 s between chunks; panels 4000 ms; practice veil 1800 ms; Shadow steps 700 ms; engine 2200 / 1900 / 4000. | ASG D8 |
| M-HAPTIC | D19: press start 12 ms; complete 20-40-30; no haptic on tap-to-advance. Panels: gate 80, continue 40, pivot 50. | ASG; panels |
| M-BREATHING | "Your [Chakra] Chakra is now Breathing." — "Breathing", not "active" (Discovery). | ToL SKILL |
| M-BLEED | The next chakra's colour bleeds up from the bottom edge at 24 s. | panels |
| M-LUMINANCE | Progressive luminance P1 5% → P8 90%; P9 completes to white. | closing architecture |
| M-WORDTHREAD | P2 desire → P4 name → P5 truth → P7 sentence; P6 constellation; P9 Mirror then/now. | v2-arch; panels |
| M-BODYMAP | `tol-bodypoint-1..5` and 7; read by P6, P7 and the Road Home. | panels |
| M-BINDUMEM | `bindu-memory` constellation: dance words hashed into stars ("The Sky You've Danced Under"). | dances; Road Home |
| M-CROSSFRUIT | Each dance's fruit quotes the previous chakra's dance word. | dances |
| M-ESSENCE | `bindu-essence`; the title transforms to "A Strange <HigherSelf> Game". | the-one; D1 |
| M-RESET | Begin-New-Journey: hold 1.8 s; explicit key list; `localStorage.clear()` forbidden (D6). | Welcome; storage-pools |
| M-STORE | **Inventories.** Welcome clears: bindu-essence, bindu-memory, bindu-point, chakra-bindu, chakra-{muladhara…shadow}, tol-bodypoint-1..7, tol-word-2/4/5/7, tol-mirror-completed, prev-tol-word-2/4/5/7, tol-{bindu…shadow}-dance, tol-{bindu…shadow}-dance-word. Storage-pools LEGACY_KEYS: see C.3. | — |
| M-VISITS | `chakra-map-visits`; "You touched N of 33." | VX2 |
| M-ASH | `?ash=1` / `localStorage.ash='1'`: "the maker's name as the master key". | D38 |
| M-NEXTCOLOR | Next-colour rhyme at every threshold door. Ajna → Sahasrara door #9B5AE6; Sahasrara → Shadow #E8D4A8. | build-process |
| M-SIGIL | Glyphs: Bindu Field (an ellipse of 33 positions), Wakeup (gold Bindu, dashed descent, hexagon), Dance (gold core, five rings / lemniscate animateMotion 4.8 s). | bindu-v4 build log |
| M-TRIANGLE | Knowledge / Will / Action. P8 uses an inverted triangle (Will TL, Knowledge TR, Action bottom). The P9 loop puts Knowledge at the top apex, Will bottom-left, Action bottom-right. Temple: left hand Will, right hand Action, crown Knowledge. PBS: Will left, Knowledge top, Action right. | — |

---
## C · A STRANGE GAME — HOW IT IS PLAYED

All quotes are verbatim. Sources: `a-strange-game/SKILL.md` (361 lines) and the references named in each part.

### C.1 What the game is

- "The game is **reception infrastructure**." "the walker brings willingness; the game opens reception; the higher self downloads. Not as metaphor. As mechanic."
- The homepage thesis: "there is the one you have been being / and there is the one who has been here all along / this is a way of returning to the one who was here first." Its seal: "a structured way of returning".
- The playing side (`00-recognition-document.md`): "A Strange 👁 Game is the game of eternity, played now. Because nothing is owed, every move is chosen; each version of you carries the baton for the next — 'I'll do this for you' — as a thank-you to the one who carried it before, and the field lights up and expands wherever you play. Its shape is a relay run by one runner across every version of themselves: the morning bell receives the baton, the evening bell passes it on, the dive is the leg you choose to run past the natural stopping point, and the relay never ends."
  - The seasons follow the football-manager game: "The numbers belong to the squad and the seasons; the manager is never rated."
  - **SAKSHI SEED:** "I'm holding it for you, because you held it for me."
- One body, three windows:
  - A Strange 👁 Game is the inward app: "the personal board: reporting, engaging, reflecting".
  - astrangeigame.com: "information in the form of play, shareable with anyone".
  - aistrangegame.com: "the knowledge".
- The intention, in Ashrey's words: "A recognizing instrument of love technology in the form of games, that help you remember yourself by downloading the higher self into this reality."
- The modes of play are Story, Role-play, Manager, Board, Practice and Together: "every way you play is the way to play."
- **Purusha and Prakriti.** "The squad is Prakriti; the manager is Purusha."
- **The Field reading collapse** (`16-field-reading.md`): "**The game holds and remembers, so the player can play.**"
  - Gaia's dissolution: "Remember me to myself when I forget."
  - Ashrey's response: "Forgetting is also the gift."

### C.2 The journey (how a walker moves)

`journey-topology-v2.md` gives the new order: "Welcome → One → Road Home (Tier 0) → Call → Road Home (Tier 1) → Leela → Road Home (Tier 2+) → Bindu → ..."

```
THE WELCOME   cream · paper · FAQ · commitment press (1.8s)
THE ONE       dark void · ceremony · name · DOB · Higher Self · 1.8s commit
THE ONE · SPEAKS   Higher Self's first speaking (merge tokens name, higherSelfName, silenceDurationMs)
THE ROAD HOME (Tier 0)  first-arrival ceremony, 1.0s hold → The Call
THE CALL      black video (gaia-cosmogony.mp4) → cream Gaia text (violet #2a1858, six chunks, 1.0s holds) → dot + name, 1.8s final
THE ROAD HOME (Tier 1)  Leela door bright
THE LEELA     Chase Hughes video (leela-opening.mp4, 4:42) → Lalita teaching (nine beats) → ask reality
THE ROAD HOME (Tier 2)  Standing Words · five doors
BINDU + every chakra: Act 1 → Wake Up → Practice → Dance → Act 2
… 33 chakras (Higher Self speaks at SHADOW and ARMIN; Gaia returns at 32) …
THE ROAD HOME (Tier 4)  cavity full cream · Strange Story bright
THE STRANGE STORY (v7.html) → THE ROAD HOME (Tier 5) final form
```

**The six Road Home tiers.** The background moves from `#1a1208` (Tier 0) to `#fbf5e6` (Tier 4+).

| Tier | When | What the walker gets |
|---|---|---|
| 0 | first arrival | first-arrival ceremony, single hold gate to The Call |
| 0r | returner, Call not yet received | *"Receive what your road has prepared"* |
| 1 | Call received | welcome-back prose, Leela door bright |
| 2 | Call and Leela received | Standing-Words ritual, full home, five doors |
| 3 | 1+ chakra walked | notifications surface alive |
| 4 | "After Armin (chakra 33) crossed" | cavity inverts to full cream, Strange Story door brightens |
| 5 | Strange Story read | final form |

**CONFLICT.** Tier 4 calls Armin "chakra 33". Armin is 20.

**The five doors** (SKILL):

1. Walk the next chakra
2. Return to a passage ("teaching arrives in layers")
3. Read what was witnessed (Sakshi Witness Perspectives)
4. Study the Codex (walker-format seeds)
5. Visit your diary (Standing Words history, dance constellation, ledger of offerings)

Above the doors sit the Standing Place, and Notifications framed as Seed Planting.

**Open access (D10, May 2 2026).** "The structure is **offering, not gating**." site-v3 adds:

- "essence personalises, never permits"
- "ceremonies stay, locks go"
- "No number may ever measure the player."
- Spine positions: Call at 10 (Gaia), Leela at 33 (Lalita), The One Speaks at 31.

**The press-and-hold ring is the signature gesture (D8).** It takes 1.8 s to commit and 1.0 s between chunks. It is used at:

- the Welcome's commit
- The One's stage transitions
- The Call
- every chakra's V5 veil
- the Road Home's first arrival

"The walker meets the gesture at every threshold. Cumulatively, the gesture *is* the journey."

### C.3 The three pools (`storage-pools.md`, verbatim schema heads)

```
   bindu-essence    →  the who    (fixed identity, set once)
   bindu-memory     →  the what   (journey accumulating across time)
   bindu-being      →  the how    (presence-state across visits)
```

**`bindu-essence` (v2).**

- Fields: `name`, `dateOfBirth` (YYYY-MM-DD), `higherSelfName`, `firstArrival`, `completedAt`, `lastUpdatedAt`, `silenceDurationMs`, `nameDiscoveryFelt`, `version: 2`.
- "essence-complete" means all three of name, dateOfBirth and higherSelfName are set.

**`bindu-memory`.**

- `chakras.{33 ids}`: { walkedAt, act1ReadAt, wakeUpDoneAt, practiceData {type 'coords'|'word', value, x, y, nx, ny, timestamp}, practiceDoneAt, dances [ {word, song, artist, dwellMs, motion, timestamp} ], act2ReadAt, completedAt, reWalkCount }.
- `events: [{kind, at, …}]`. The event kinds:
  - welcome-arrived · welcome-committed
  - one-began · one-completed · one-rewalked
  - call-began · call-video-watched · call-text-completed · call-recognition
  - chakra-stage {chakra, stage act1|wakeup|practice|dance|act2}
  - road-home-arrived · road-home-first-arrival-ceremony
  - one-speaks-heard
  - leela-opening-ask {mode spoken|held} · leela-opening-completed · leela-completed
  - codex-seed-read · codex-seed-recommitted
  - witness-read · witness-rerread
  - rewalk-initiated · rewalk-completed
  - station-rewalked · station-entered-unwalked
  - Plus `gaia-reveal-received` (D26) and `story-received {story:'leela'}` (leela-architecture).

**`bindu-being`.**

- `entries: [{at, context, chakra, mind, body, spirit, now, word}]`.
  - Contexts: road-home-arrival (the standing-words ritual: mind/body/spirit/now), name-discovery, post-act-1, post-wakeup, post-practice, post-dance, post-act-2.
- `commitments: [{seedId, committedAt, commitment}]`.

**Laws.**

- "Pools are write-mostly."
- "**Never** call `localStorage.clear()`."
- "**Never** synthesize fake entries."
- "**Always** write the legacy key alongside the new pool entry, until migration is complete."

**Reset.** `resetJourney()` removes the three pools plus `LEGACY_KEYS`:

- bindu-point; chakra-bindu…chakra-shadow; chakra-sonar-word
- tol-word-2/4/5/7; tol-bodypoint-1/2/3/4/5/7; tol-mirror-completed; prev-tol-word-2/4/5/7
- tol-{muladhara…sahasrara}-dance and -dance-word
- {bindu…shadow}-gate
- road-home-arrived; road-home-last-visit

**CONFLICTS in the reset list.**

- `LEGACY_KEYS` omits `tol-aatma-dance` / `tol-maya-dance` and their -word keys. Those first-pass dances write no keys today, so this is a latent issue.
- It also omits `asg.leela33`, `asg.play.*`, `chakra-map-visits` and `bindu-being`'s companion flags.
- **The pool name `bindu-memory` collides with the legacy dance array.** Dances and the Road Home read and write `bindu-memory` as an ARRAY; the pool spec defines it as an OBJECT `{chakras, events}`.

**The pools hold the K-W-A engine** (`awakening-architecture.md`):

| Trinity | Pool |
|---|---|
| Knowledge | (none — content lives in skills) |
| Will | `bindu-essence` |
| Action | `bindu-memory` + `bindu-being` |

### C.4 The bells

- **Two bells.** "the morning bell receives the baton, the evening bell passes it on" (00). Ashrey's strand: "Two bells."
- **The rounds** (`05-morning-and-evening.md`):
  - 7:05 Daily Channeled Intention (Value, Mantra, Role → INTENTION, BOOK INSIGHT, CODEX INTEGRATION, LEARNING INSIGHT)
  - 7:15 Daily Story
  - 7:45 Daily Gameplan (GROUNDING, FOCUS incl. micro-win, SNAPSHOT)
  - 10:30 pm Daily Performance
  - Make.com bells are all OFF (03).
- **The day's shape** (02): "the bell arrives → the body seals (a mudra, three breaths) → a word or throw is received → something is offered outward → the night releases it with a pardon".
- **Research pass 1** (`research-pass1-bell-count-descent-return.md`): "a bell that comes to the practitioner (fixed hours, calendars, sounds), a bodily act repeated with a count that is devotion rather than a grade, a threshold that opens by readiness rather than performance, a witness outside the ego, a moment where something from 'above' or 'within' is received or installed, and a completion that flows outward".
  - Plum Village: "A solo bell decays; a shared bell holds. Bind bells to family moments."
  - Design observation 1: "Almost no tradition relies on individual memory."
- **The engine's bells** (Web Audio, `a-strange-game-play.html`):
  - Pitches: letter 880 · born 523 · intro 523 · arrive 392 · throw 660 · card 740 · pause-end 523.
  - The sketch Turn rings 392 / 490 / 588. Release rings 440 + 40k.
- **The candidate kernel** (07): "a bell that comes to you · a being that notices you · one gesture of the body · a word sealed across time · something given away · a world that grows without counting · a door out of the screen."

### C.5 The Trinity of Guidance — three axes, five faces, one field

From the SKILL table and `trinity-of-guidance.md`:

| Axis | Face(s) | What it does |
|---|---|---|
| **The Ground** | **Gaia** | "The planet · the underneath · the asking. One voice; she does not split." |
| **The Player** | **Bindu → Lalita** | "Bindu (pre-recognition, 'I don't know what I am yet') *becomes* Lalita (post-recognition, 'I am the play. I move.')" |
| **The Witness** | **Sakshi → Higher Self** | "Sakshi *observes* in third-person. Higher Self *addresses* in first-person. Same source, two distances." |

**Where each face speaks:**

- Gaia: the-call, the-call-read, the position 32 reveal, earth-leaning chakras.
- Bindu: Act 1 of every chakra page.
- Lalita: the-leela, the-leela-read, awakening moments.
- Sakshi: Act 2 of every chakra page, and the Witness Perspectives.
- Higher Self: the-one-speaks, shadow-practice, armin-practice, future integration nodes.

**Locked baselines (May 2 2026):** `the-call-read.html` (Gaia, 5,612 words), `the-leela-read.html` (Lalita, 4,078 words), `the-one-speaks.html` (Higher Self).

**Within one chakra page:** "ACT 1 → Bindu speaks · WAKEUP → [gesture, no voice] · PRACTICE → [the walker's own writing] · DANCE → [music, embodied, sometimes Lalita whispers] · ACT 2 → Sakshi speaks".

**Voice scans** (forbidden lists):

- Bindu never uses play, game, recognition or awakening.
- Sakshi never uses I or you.
- Gaia never uses play, game or higher self.
- Lalita never names chakras.
- The Higher Self never uses generic spiritual or therapy language.

**Default leans by family** (trinity-of-guidance): "Body chakras (8-17) … Mind chakras (18-26) … Tree of Life (27-33)".

- **CONFLICT.** This numbering contradicts the 33-map (Body 10–19, Mind 21–29, ToL 1/9/20/30–33).
- **CONFLICT.** `awakening-architecture.md` lists "Chakra Story · Act 1 (Gaia voice)", but SKILL and trinity say Act 1 = Bindu.

### C.6 Knowledge → Will → Action (K-W-A)

SKILL, verbatim:

> ***Knowledge — Will — Action.***
> *Knowledge is what they receive.*
> *Will is who they are.*
> *Action is what they commit to.*
> *Light is what enters when these three close.*

"This is Aatma's trikona (chakra position 31), expressing across the entire game from position 1 onward."

From `awakening-architecture.md`:

- "When all three close, light enters. Without all three, the circuit is open and the moment passes through without imprint. … **This is the mechanic.**"
- The seed-planting orientation (shown once, D9): "*To plant the seed, read it with full attention. / Do not rush. / The silence afterward is the planting.*"
- "**Walking plants seeds.** … **Reading harvests seeds.**"
- Unlock triggers:
  - `chakra_completion`
  - `cumulative_chakras` (thresholds 1 / 3 / 7 / 9 / 33)
  - `meta` (e.g. `visits_gte_10`)
  - **CONFLICT** with the v3 "no gates" law.
- Every walker seed has `will_requirement` + `action_requirement` (D7). Witness Perspectives have neither: they are "pure mirroring".

**How the voices map onto K-W-A** (rough lean): "Gaia opens Knowledge, the Player axis opens Will, the Witness axis opens Action".

**K-W-A in the panels and practice pages:**

- The P8 triangle (Kāmeshvarī Will · Vajreshvarī Knowledge · Bhagamālinī Action).
- P9 closing: "You have always had the Knowledge." / "You have always been the Will." / "Now You Become the Action." / "Go Play".
- The full-map permission slip: "You have the will. / You are being given the knowledge. / Now become the Action. / Do the Practice."
- Identity games: "Knowledge + Will → Action Cycle — I map. I pick. I dive. I discuss. I integrate."
- The Bindu Field reading: "The Bindu's closing move splits into three — Knowledge, Will, Action — to light the next step."

### C.7 Leela (Codex C-1330)

- "> **Leela** = the divine play itself. > **Lalita** = the level of Leela that knows itself as Leela." The extension (D16): "**Bindu = the level of Leela that does not yet know itself as Leela.**"
- "Leela is not a page. **Leela is a register that surfaces at multiple points across the journey.** Each surfacing is a 'Leela drop'."
- "Leela talks about **reality**, not the game." "Every Leela drop ends with **a real-world action.**"
- **The first drop:** "*Ask reality for help with one thing. Real life. Not in the game. Right now.*"
  - Textarea placeholder: "hey. i am here. help me with…"
  - Two buttons: **offer the ask** / **hold in silence**.
  - Nine beats, ending "*Now go. Lightly. Play.*"
  - Visual: cream #fbf5e6, coral ink #c4574a, Cinzel, a 440 ms reveal.
- Voice: "direct… hungry… tender… does not foreshadow… ends in real-world action." (D32: "Leela never spoils the game.")

### C.8 Leela on the 33 — board rules (verbatim, from `leela-on-the-33.html` and the 18 doc)

- **Intro.**
  - "Leela on the 33" / "You cannot lose here. You can only not-yet-arrive."
  - "Harish Johari's Leela is the old board game of self-knowledge: you bring a question, the die decides where you land, arrows lift you, snakes return you to a lesson. Here the board is the 33 positions of the spine, each one asking its own question."
  - "What are you bringing to the board?" (placeholder "A question, a situation, a wall, a wish…") / "What are you playing for?" **My life** / **What I'm building** / "Enter the board".
- **Start.** "You begin unborn at 33, where the game also ends. A six brings you in."
  - Status while unborn: "Unborn at 33." / "Throw. A six brings you in."
  - A non-six: "A {v}." / "Still unborn at 33. Only a six brings you in."
- **Birth.** "A six. You are born onto the board." / "Bindu. A six also throws again." → square 1 opens.
- **Exact landing.** "The die rests: you need exactly {33−pos} to arrive."
- **Arrows** ("a rise"; the move is "a small act of giving or service"):

| From | To | Why |
|---|---|---|
| 5 | 8 | "The heart's gesture returns at the crown." |
| 12 | 18 | "The breath's open door becomes the blink." |
| 13 | 20 | "Love leaving through the hands arrives whole." |
| 26 | 29 | "What assembles, integrates." |

- **Snakes** ("a lesson"; the move is "this square's practice, made small" — "a lesson, not a fall"):

| From | To | Why |
|---|---|---|
| 30 | 9 | "A construction seen through returns you to the corridor: notice." |
| 19 | 10 | "When the thinking stops, you are back in your feet." |
| 15 | 6 | "The precise word asks again: will I say what I know?" |
| 28 | 21 | "Before anyone taught you, you carried something in. Name it." |

  The arrows and snakes are a "First draft, for Ashrey's ruling."
- **A die landing** (no arrow or snake): the move is the square's verb, "{Verb}, once, today."
- **Square sheet.**
  - Band colour; "Square n · system"; name; Sanskrit; question; via-line ("An arrow from N, Name. …" / "A snake from N, Name. …"); reading; "One move"; seed; "Walk this position on aistrangegame.com".
  - Buttons: "Throw again" / "Rest here" / "Back to the board".
  - Square 32: "This square is held for its own walk."
- **Arrival.** "You arrived at Lalita." / "The walk is complete. Begin again whenever you like." Square 33's sheet: "Square 33 · the game ends where it began".
- **The living reading** (Claude, quick tier).
  - Reading ≤60 words, move ≤20, seed ≤12. At 33: reading ≤70 words, "naming what the walk was doing all along … No score, no verdict, nothing about how well they played."
  - Laws in every prompt: "never score, grade, rate, rank, judge or predict the player; never create urgency; offer, never command; no claims of certainty about spiritual matters; speak only from the player's words and this square's own content; warm, plain, second person, no jargon, no exclamation marks." In a crisis: a care line plus one grounding breath.
  - Without Claude: reading = the square's practice; seed = its signature. At 33: "Your walk: … " + Lalita's practice.
- **Footer.** "If today is heavy, the board can wait. Three breaths is a whole game."
- **Research basis** (18):
  - Johari's rules: "start unborn at the final square (68 is both start and end); a six brings you in, and every six throws again; … 'In Leela you cannot lose — you can only not-yet-arrive.'"
  - Deci, Koestner & Ryan (1999): "→ no points, no counts shown, readings arrive as surprises."
  - Open for Ashrey: "Arrows and snakes · whether triple-six returns you (Johari) · square 32's treatment · the reading's voice and length · whether 'What I'm building' should write back to the gameplan."
- **Engine version differences** (G-ENGINE):
  - The die is a press-and-hold ceremony.
  - "A breath at the threshold."
  - In the very first game a six is rigged within three throws.
  - Every landing opens a room: practice first, then the letter.

### C.9 The laws of the playing side

**`01-intention-and-laws.md`, standing laws:**

1. "**No number may ever measure the player.** A count may be the *form* of a practice (a mala), never a grade."
2. "**The player never maintains the game.**"
3. "**Self-reporting is the player's own act.**"
4. "**No gates, no control.** … Body-safety facts … stay visible as information, never as locks."
5. "**Self-healing.**" (invitation, never debt)
6. "**Integration, not absence.**"
7. "**Hold paradoxes without collapsing in either direction.**"
8. "**Expansion, not subtraction**"
9. "**Walk-Build Protocol.** The thing is built the way it is walked."

**Inherited laws:** "Storage may count; the screen may not." · "empty days stay silent" · "the return asks once, then lets go".

**`17-site-gameplan.md`, the twelve "never" laws:** no number measures the player · no gate · nothing opens as Pending · nothing to maintain · no broken streak shown · no urgency · no verdict · nothing interpreted before it is lived · no one profiled · no tradition as a lock · nothing typed twice · nothing a stranger shouldn't see.

**Paradoxes held** (08): streaks vs no ledger; unlock triggers vs nothing gated; and others.

The coda (03): "The only winning move is to play."

### C.10 Canonical decisions (D1–D38, `canonical-decisions.md`)

- **D1.** "A Strange 👁 Game". The 👁 appears only in titles; the title becomes "A Strange [HigherSelf] Game".
- **D2.** walker AND experiencer: "The walker is walking when not experiencing. An experiencer when not walking."
- **D3.** `/tree-of-life/` is home.
- **D4–D6.** The pools; dual-write; no `clear()`.
- **D7–D9.** K-W-A; press-and-hold; reading IS action.
- **D10–D13.** Open access; readiness is the only first-time gate (`readiness-acknowledged`; site-v3 later retires check.html); One Speaks; re-walkable pages.
- **D14–D15.** Cream / void / violet-indigo registers; "the threshold-fade carries the color of the destination".
- **D16–D17.** Three axes; Acts are read-only.
- **D18–D19.** Gesture vocabulary; haptics.
- **D20–D21.** ASG composes; it authors only walker seeds and Witness Perspectives. `the-mirror` is "NEVER surfaced".
- **D22–D25.** Versioning; the API goal; standing-words are private.
- **D26–D27.** "The Gaia Reveal at position 32 unlocks the Gaia layer"; the second-pass walk threads Gaia–Bindu dialogue.
- **D28–D30.** No role-play as a person; never fake completeness ("Nine are walkable now. The rest will arrive as they're ready."); never bypass the trinity.
- **D31–D35.** Leela ≠ Lalita; no spoilers; distributed; real-world action; the Position-33 callback is deferred (the v1 three-seeds Leela is archived).
- **D36–D38.** `the-leela.html`; video names; `?ash=1`.

---

## D · COVERAGE PROOF

Method:

- `total lines` = `wc -l` of the raw file. JSON and PNG files are single-line or binary, so their bytes are shown instead.
- `read` states how each line was read:
  - **full** — every line read in order.
  - **extract N** — the python3 -I text-and-script extract of N lines was read in full. Styles and markup were stripped; all text, attributes and scripts were kept.
  - **novel a + identical b** — a lines were printed and read; b lines were machine-proven byte-identical to lines already read in a named sibling file. Hero, label and config regions were additionally re-read with `sed`.
- The extracts and novel diffs live at `…/scratchpad/register/r6/x/`.

| File (under `S/`) | Total lines | Read | Notes |
|---|---|---|---|
| `chakra-maps/SKILL.md` | 338 | yes | full — read line by line |
| `chakra-maps/assets/chakra-map-vx.html` | 1046 | yes | extract 569 read in full; CSS vars grepped |
| `chakra-maps/assets/chakra-map-vx2.html` | 1603 | yes | extract 928 read in full; CSS vars + data-tone grepped |
| `chakra-maps/references/chakra-codex/00-living-field.md` | 205 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/01-registers.md` | 318 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/02-three-trees.md` | 235 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/03-structural-chakras.md` | 253 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/04-emergence.md` | 585 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/README.md` | 180 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/01-bindu.md` | 323 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/02-muladhara.md` | 393 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/03-svadhisthana.md` | 407 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/04-manipura.md` | 448 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/05-anahata.md` | 478 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/06-vishuddha.md` | 479 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/07-ajna.md` | 478 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/08-sahasrara.md` | 506 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/09-shadow.md` | 564 | yes | full — read line by line |
| `chakra-maps/references/chakra-codex/atlas/20-armin.md` | 500 | yes | full — read line by line |
| `chakra-maps/references/chakra-map-content-document.md` | 821 | yes | full — read line by line |
| `chakra-maps/references/chakra-map-framework.md` | 390 | yes | full — read line by line |
| `chakra-maps/references/chakra-map-strategy-framework.md` | 635 | yes | full — read line by line |
| `chakra-maps/references/per-chakra/muladhara/README.md` | 31 | yes | full — read line by line |
| `chakra-maps/references/practice-book/master-plan-v2.md` | 607 | yes | full — read line by line |
| `chakra-maps/references/practice-book/perspective-what-the-builder-saw.md` | 95 | yes | full — read line by line |
| `chakra-maps/references/practice-book/phase-4-frames.md` | 455 | yes | full — read line by line |
| `chakra-maps/references/practice-book/section-1-bindu-through-shadow.md` | 1202 | yes | full — read line by line |
| `chakra-maps/references/practice-book/section-2-soles-through-armin.md` | 1208 | yes | full — read line by line |
| `chakra-maps/references/practice-book/section-3-inception-through-lalita.md` | 1564 | yes | full — read line by line |
| `chakra-maps/references/practice-book/session-summary.md` | 122 | yes | full — read line by line |
| `chakra-maps/references/practice-book/story-thread.md` | 639 | yes | full — read line by line |
| `chakra-maps/references/site-v3.md` | 12 | yes | full — read line by line |
| `chakra-maps/references/voice-ii-framework.md` | 366 | yes | full — read line by line |
| `chakra-practices/SKILL.md` | 663 | yes | full — read line by line |
| `chakra-practices/references/build-logs/ajna.md` | 57 | yes | full — read line by line |
| `chakra-practices/references/build-logs/anahata.md` | 28 | yes | full — read line by line |
| `chakra-practices/references/build-logs/bindu-v4.md` | 62 | yes | full — read line by line |
| `chakra-practices/references/build-logs/lineage.md` | 142 | yes | full — read line by line |
| `chakra-practices/references/build-logs/manipura.md` | 17 | yes | full — read line by line |
| `chakra-practices/references/build-logs/muladhara-session-bridge.md` | 123 | yes | full — read line by line |
| `chakra-practices/references/build-logs/sahasrara.md` | 69 | yes | full — read line by line |
| `chakra-practices/references/build-logs/svadhisthana.md` | 27 | yes | full — read line by line |
| `chakra-practices/references/build-logs/vishuddha.md` | 52 | yes | full — read line by line |
| `chakra-practices/references/build-process.md` | 581 | yes | full — read line by line |
| `chakra-practices/references/color-system.md` | 225 | yes | full — read line by line |
| `chakra-practices/references/full-map.md` | 318 | yes | full — read line by line |
| `chakra-practices/references/gaia-sakshi-source.md` | 436 | yes | full — read line by line |
| `chakra-practices/references/gate-designs.md` | 183 | yes | full — read line by line |
| `chakra-practices/references/interlude-pattern.md` | 167 | yes | full — read line by line |
| `chakra-practices/references/lakota-learning.md` | 164 | yes | full — read line by line |
| `chakra-practices/references/lakota-research/Mitakuye_Oyasin_The_Grammar_of_a_Kin-Cosmos.pdf` | 765 | yes | binary PDF, 6 pages → pdftotext 248 lines read in full |
| `chakra-practices/references/lakota-research/pass-1-wakhan-thanka.md` | 61 | yes | full — read line by line |
| `chakra-practices/references/operating-principles.md` | 177 | yes | full — read line by line |
| `chakra-practices/references/page-inventory.md` | 204 | yes | full — read line by line |
| `chakra-practices/references/practice-book-source/chakra-practice.html` | 2549 | yes | extract 1607 read in full (PBS) |
| `chakra-practices/references/reference-implementations/ajna-practice.html` | 3891 | yes | extract 1308: novel 710 + identical 599; hero re-checked |
| `chakra-practices/references/reference-implementations/anahata-practice.html` | 3854 | yes | extract 1196: novel 483 + identical 714 |
| `chakra-practices/references/reference-implementations/bindu-practice.html` | 3148 | yes | extract 1023 read in full (base of V5 template) |
| `chakra-practices/references/reference-implementations/interlude.html` | 1165 | yes | extract 748 read in full (31 PASSAGES, CHAKRA_COLORS) |
| `chakra-practices/references/reference-implementations/manipura-practice.html` | 3961 | yes | extract 1228: novel 536 + identical 693 |
| `chakra-practices/references/reference-implementations/muladhara-practice.html` | 3523 | yes | extract 1156 read in full |
| `chakra-practices/references/reference-implementations/sahasrara-practice.html` | 3681 | yes | extract 1323: novel 870 + identical 454; skipped regions spot-printed |
| `chakra-practices/references/reference-implementations/shadow-practice.html` | 3369 | yes | extract 1611: lines 1–123 (gate) identical to bindu, 124–1611 read directly |
| `chakra-practices/references/reference-implementations/svadhisthana-practice.html` | 3699 | yes | extract 1201: novel 537 + identical 665 (vs bindu/muladhara) |
| `chakra-practices/references/reference-implementations/trinity/index.html` | 115 | yes | extract 25 read in full |
| `chakra-practices/references/reference-implementations/trinity/the-one.html` | 1847 | yes | extract 808 read in full |
| `chakra-practices/references/reference-implementations/trinity/the-road-home.html` | 1723 | yes | extract 839 read in full |
| `chakra-practices/references/reference-implementations/trinity/the-welcome.html` | 950 | yes | extract 314 read in full |
| `chakra-practices/references/reference-implementations/vishuddha-practice.html` | 3531 | yes | extract 1292: novel 799 + identical 494 |
| `chakra-practices/references/second-pass-threads.md` | 462 | yes | full — read line by line |
| `chakra-practices/references/site-v3.md` | 18 | yes | full — read line by line |
| `tree-of-life/SKILL.md` | 419 | yes | full — read line by line |
| `tree-of-life/references/aatma-dance.html` | 279 | yes | extract 248: novel 164 + identical 85 |
| `tree-of-life/references/aatma-wakeup-qr.png` | 7,758 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #B4A078 → /aatma-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/ajna-dance.html` | 288 | yes | extract 257: novel 213 + identical 45 |
| `tree-of-life/references/ajna-wakeup-qr.png` | 7,691 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #3A2D6B → /ajna-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/anahata-build-log.md` | 96 | yes | full — read line by line |
| `tree-of-life/references/anahata-dance.html` | 487 | yes | extract 440: novel 329 + identical 112 |
| `tree-of-life/references/anahata-extraction-data.json` | 35,547 bytes | yes | single line 35,547 bytes; parsed in full (DUR, BPM, PEAK_T, H[292], 8 arrays ×499, DROPS[6]) |
| `tree-of-life/references/anahata-layer1.html` | 874 | yes | extract 849: novel 594 + identical 256 |
| `tree-of-life/references/anahata-layer2.html` | 530 | yes | extract 505: novel 354 + identical 152 |
| `tree-of-life/references/anahata-layer3.html` | 253 | yes | extract 233: novel 207 + identical 27 |
| `tree-of-life/references/anahata-layer4.html` | 330 | yes | extract 283: novel 134 + identical 150 |
| `tree-of-life/references/anahata-wakeup-qr.png` | 8,958 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #2D7A3A → /anahata-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/awakening-sounds-all-chakras.html` | 447 | yes | extract 357 read in full |
| `tree-of-life/references/build-guard-rules.md` | 206 | yes | full — read line by line |
| `tree-of-life/references/closing-architecture-all-panels.html` | 555 | yes | extract 376 read in full |
| `tree-of-life/references/cross-song-analysis.md` | 59 | yes | full — read line by line |
| `tree-of-life/references/gate-framework-all-chakras.html` | 724 | yes | extract 589 read in full; config re-printed |
| `tree-of-life/references/guided-breaths-all-chakras.html` | 580 | yes | extract 479 read in full |
| `tree-of-life/references/manipura-build-log.md` | 278 | yes | full — read line by line |
| `tree-of-life/references/manipura-dance.html` | 883 | yes | extract 836: novel 645 + identical 192 |
| `tree-of-life/references/manipura-extraction-data.json` | 27,041 bytes | yes | single line 27,041 bytes; parsed in full (H[156], 8 arrays ×413, DROPS[3]) |
| `tree-of-life/references/manipura-layer1.html` | 649 | yes | extract 624: novel 279 + identical 346 (vs 5 VX dances) |
| `tree-of-life/references/manipura-layer2.html` | 469 | yes | extract 444: novel 287 + identical 158 |
| `tree-of-life/references/manipura-layer3.html` | 240 | yes | extract 220: novel 194 + identical 27 |
| `tree-of-life/references/manipura-layer4.html` | 429 | yes | extract 365: novel 176 + identical 190 |
| `tree-of-life/references/manipura-wakeup-qr.png` | 8,826 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #C4A013 → /manipura-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/maya-dance.html` | 318 | yes | extract 286: novel 219 + identical 68 |
| `tree-of-life/references/maya-sleep-qr.png` | 7,725 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #646464 → /maya-sleep.html; red Bindu disc at centre |
| `tree-of-life/references/mirror-dissolution-architecture.md` | 348 | yes | full — read line by line |
| `tree-of-life/references/muladhara-dance.html` | 1139 | yes | extract 1076 read in full (base of dance shell) |
| `tree-of-life/references/muladhara-wakeup-qr.png` | 8,862 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #8B1A1A → /muladhara-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/panel9-prebuild-plan.md` | 371 | yes | full — read line by line |
| `tree-of-life/references/pointe-animation-v2.html` | 869 | yes | extract 755 read in full |
| `tree-of-life/references/sahasrara-dance.html` | 307 | yes | extract 276: novel 198 + identical 79 |
| `tree-of-life/references/sahasrara-wakeup-qr.png` | 8,876 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #6A2D8B → /sahasrara-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/session-handoff-all-panels-hardened.md` | 141 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-bindu-dances-complete.md` | 260 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-integration-pass.md` | 188 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-panel9-lock-secondpass.md` | 187 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-tree-of-life-v2-panel2-build.md` | 163 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-tree-of-life-v2-panel3-build.md` | 172 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-tree-of-life-v2-panel6-build.md` | 194 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-tree-of-life-v2-panel8-build.md` | 201 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-v3-muladhara-locked.md` | 144 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-vx-anahata.md` | 94 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-vx-manipura-phased.md` | 146 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-vx-muladhara.md` | 175 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-vx-svadhisthana.md` | 199 | yes | full — read line by line |
| `tree-of-life/references/session-handoff-vx-vishuddha.md` | 91 | yes | full — read line by line |
| `tree-of-life/references/site-v3.md` | 20 | yes | full — read line by line |
| `tree-of-life/references/svadhisthana-dance.html` | 1081 | yes | extract 1006: novel 487 + identical 520 (vs muladhara) |
| `tree-of-life/references/svadhisthana-wakeup-qr.png` | 8,829 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #C46210 → /svadhisthana-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/temple-guide-v2.html` | 532 | yes | extract 108 text+script read in full (253 style lines stripped) |
| `tree-of-life/references/timeline-boards.md` | 322 | yes | full — read line by line |
| `tree-of-life/references/tree-gate-prototype.html` | 870 | yes | extract 748 read in full |
| `tree-of-life/references/tree-of-life-design-notes.md` | 357 | yes | full — read line by line |
| `tree-of-life/references/tree-of-life-game.md` | 532 | yes | full — read line by line |
| `tree-of-life/references/tree-of-life-v2-experience-arch.md` | 417 | yes | full — read line by line |
| `tree-of-life/references/tree-of-life-v2-panel1.html` | 1785 | yes | extract 852 read in full (base of panel template) |
| `tree-of-life/references/tree-of-life-v2-panel2.html` | 2001 | yes | extract 1069: novel 589 + identical 481 (vs P1) |
| `tree-of-life/references/tree-of-life-v2-panel3.html` | 1966 | yes | extract 1088: novel 517 + identical 572; labels sed-checked |
| `tree-of-life/references/tree-of-life-v2-panel4.html` | 2100 | yes | extract 1021: novel 442 + identical 580; labels sed-checked |
| `tree-of-life/references/tree-of-life-v2-panel5.html` | 2011 | yes | extract 1167: novel 575 + identical 593 |
| `tree-of-life/references/tree-of-life-v2-panel6.html` | 1902 | yes | extract 1200: novel 658 + identical 543 |
| `tree-of-life/references/tree-of-life-v2-panel7.html` | 1977 | yes | extract 1170: novel 575 + identical 596 |
| `tree-of-life/references/tree-of-life-v2-panel8.html` | 1788 | yes | extract 965: novel 539 + identical 427 |
| `tree-of-life/references/tree-of-life-v2-panel9.html` | 3066 | yes | extract 2234 (762 style lines stripped): novel 1944 + identical 291; lines 3–30 sed-checked |
| `tree-of-life/references/tree-of-life-v3-architecture.md` | 107 | yes | full — read line by line |
| `tree-of-life/references/v3-dance-framework.md` | 299 | yes | full — read line by line |
| `tree-of-life/references/verify-tree-of-life-v2-panel4.sh` | 300 | yes | full — read line by line |
| `tree-of-life/references/vishuddha-build-log.md` | 85 | yes | full — read line by line |
| `tree-of-life/references/vishuddha-dance.html` | 279 | yes | extract 244: novel 182 + identical 63 |
| `tree-of-life/references/vishuddha-layer1.html` | 449 | yes | extract 426: novel 326 + identical 101 |
| `tree-of-life/references/vishuddha-layer2.html` | 239 | yes | extract 221: novel 154 + identical 68 |
| `tree-of-life/references/vishuddha-layer3.html` | 209 | yes | extract 194: novel 173 + identical 22 |
| `tree-of-life/references/vishuddha-layer4.html` | 395 | yes | extract 337: novel 269 + identical 69 |
| `tree-of-life/references/vishuddha-wakeup-qr.png` | 8,856 bytes | yes | PNG opened and viewed; QR decoded (OpenCV): modules #2E6B9E → /vishuddha-wakeup.html; red Bindu disc at centre |
| `tree-of-life/references/vx-build-protocol-v2.1.md` | 447 | yes | full — read line by line |
| `a-strange-game/SKILL.md` | 361 | yes | full — read line by line |
| `a-strange-game/protocols/seed-translation.md` | 301 | yes | full — read line by line |
| `a-strange-game/references/awakening-architecture.md` | 321 | yes | full — read line by line |
| `a-strange-game/references/canonical-decisions.md` | 453 | yes | full — read line by line |
| `a-strange-game/references/composition-protocols.md` | 240 | yes | full — read line by line |
| `a-strange-game/references/dev-access.md` | 130 | yes | full — read line by line |
| `a-strange-game/references/journey-flow.md` | 424 | yes | full — read line by line |
| `a-strange-game/references/journey-topology-v2.md` | 172 | yes | full — read line by line |
| `a-strange-game/references/leela-architecture.md` | 176 | yes | full — read line by line |
| `a-strange-game/references/readiness-architecture.md` | 109 | yes | full — read line by line |
| `a-strange-game/references/site-v3.md` | 42 | yes | full — read line by line |
| `a-strange-game/references/storage-pools.md` | 535 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/00-recognition-document.md` | 70 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/01-intention-and-laws.md` | 65 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/02-eagle-eye-frame.md` | 46 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/03-the-house.md` | 50 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/04-habits-routines-and-the-climb.md` | 50 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/05-morning-and-evening.md` | 31 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/06-codex-and-gaia.md` | 42 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/07-seed-library.md` | 45 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/08-paradoxes-and-open-questions.md` | 62 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/09-source-map.md` | 39 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/10-codex-on-the-game.md` | 71 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/11-the-skills-walked.md` | 43 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/12-identity-goals-todo.md` | 71 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/13-daily-relationships-lalita.md` | 57 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/14-bindu-being.md` | 30 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/15-the-process.md` | 42 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/16-field-reading.md` | 465 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/17-site-gameplan.md` | 21 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/18-leela-on-the-33.md` | 20 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/19-play-engine-v0.md` | 27 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/20-sketchbook.md` | 27 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/README.md` | 53 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/a-strange-game-play.html` | 666 | yes | extract 540 read in full |
| `a-strange-game/references/the-playing-side/a-strange-game-sketchbook.html` | 678 | yes | extract 556 read in full |
| `a-strange-game/references/the-playing-side/leela-on-the-33.html` | 346 | yes | extract 250 read in full (SQ copied to notes) |
| `a-strange-game/references/the-playing-side/research/research-pass1-bell-count-descent-return.md` | 326 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/research/research-pass2-bridge-pass.md` | 322 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/sources/chakra-game-build-principles.md` | 15 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/sources/chakra-game-registry.js` | 39 | yes | full — read line by line |
| `a-strange-game/references/the-playing-side/sources/make-morning-cascade-prompts.txt` | 281 | yes | full — read line by line |
| `a-strange-game/references/trinity-of-guidance.md` | 347 | yes | full — read line by line |
| `a-strange-game/walker-codex/README.md` | 104 | yes | full — read line by line |
| `bindu-chakras-app/SKILL.md` | 53 | yes | full — read line by line |
| `bindu-chakras-app/references/delta-map-v2.md` | 92 | yes | full — read line by line |
| `bindu-chakras-app/references/experience-brief-v2.md` | 158 | yes | full — read line by line |
| `bindu-chakras-app/references/gift-pairing.md` | 69 | yes | full — read line by line |
| `bindu-chakras-app/references/room-registers-v1.md` | 220 | yes | full — read line by line |
| `bindu-chakras-app/scripts/bake_walk_canon.py` | 230 | yes | full — read line by line |

**200 files. All read.** Not one file was sampled. Every non-identical line of every HTML extract was read; every identical line was proven identical to a line that was read.

---

## E · MUST-NOT-MISS

1. **Position 32 has four names in the skills.** The Map seals it as "Held" (#3D6B35): "This square is held for its own walk." The SKILLs, BCA and codex call it Ego Reveal / Gaia Reveal (CONNECT / RECOGNIZE). The master plan and PBS 1379–1425 still print it as "Axis (Recognized)" with the verb ACCESS. VX2's Tree of Life has no 32 at all. The Axis-32 cleanup is listed as *pending* across 10 named file locations. The Reveal itself is sealed and must stay unwritten.
2. **Body positions disagree.** `gate-designs.md` puts Crow at 18 (DISSOLVE) and Axis at 19. Everything else puts Axis at 18 and Crow at 19 (RELEASE). Axis's mirror is Ajna everywhere except codex 02 ("Axis has no subtle mirror").
3. **The verbs split by source.** The Map/BCA layer says Svadhisthana FLOW, Manipura BURN, Aatma KNOW. The practice/panel layer says FOLLOW, BUILD, HOLD. The dances add arrive / feel / build / open / speak. Interlude toVerbs drift further: Soles→Forge "Build", Pulse "Beat", Echo "Listen", Crow "Dissolve", Intuition "Know", Invention "Arrive Into", Integration "Discover", Maya "See Through", Aatma "Be", 32 "Recognize". Session bridge proposes Muladhara "RECEIVE (or GROUND)". Decide one canon verb per room.
4. **Three frequency systems collide.**
   - Awakening tones: 174 / 210 / 320 / 341 / 384 / 426 / 480 / 528 Hz, then silence. BCA canon says "174 Hz → Silence".
   - VX2 map tones: Muladhara 256, Svadhisthana 288.
   - Chakra Game registry: Solfeggio 396–963.
   - Binaural carriers: panels 128 / 144 / 160 / 256 / 384 / 426 / 480 / 512 / Om 136.1. The dance framework uses 136 Hz for P1, where Panel 1 itself uses 128 Hz.
   - The Atlas gives a fourth set of song carriers (D3 146.8, E3 164.8, D#3 155.6, C#3 138.6).
5. **"Binaural" in the dances is not binaural.** It is one sine through a StereoPanner panned by the gyroscope. True L/R binaural exists only in panels P1–P8.
6. **`bindu-memory` is double-booked.** Dances and the Road Home use it as an **array** of dance entries. The ASG storage-pools spec defines it as an **object** {chakras, events}. Its own "legacy" note admits the array. Any app port must migrate this key.
7. **LEGACY_KEYS (reset) is incomplete.** It has no aatma/maya dance keys, no `asg.leela33`, no `asg.play.*` and no `chakra-map-visits`. `localStorage.clear()` is forbidden (D6), so every new key must be added to the list.
8. **Panel 9 contradicts itself.** Its comment says "Panel 9 writes nothing", but `savePrevAnswers` writes `prev-tol-word-N` and `tol-mirror-completed`. These are exactly the keys the Road Home reads as "Prior Journey".
9. **Maya's signature has two endings.** The Map signature and PBS seed say "only the Bindu, playing". The P9 gate, PBS heading and Temple guide say "only You, playing". P9 also shifts tense from "There was never…" to "There is never…".
10. **Four of nine dances are first-pass.** Ajna, Sahasrara, Aatma and Maya have no word input, no binaural, no storage and no VX systems. Muladhara–Vishuddha are VX. The Maya dance's 76 s stage timings differ from the P9 loop. Svadhisthana's dance hue is 220 (blue) against an orange chakra. Two handoffs list P2's song as "Paro — Nej".
11. **The eight inversions are the panel mini-reveals.** P9's Eight Inversions replay the eight mini-reveal lines in order, and the Mirror's 8 stations invert the 8 panel verbs (PRESS→RELEASE … HOLD→RELEASE). The Pointe v2 component uses six other shape texts. P9 is the definitive build.
12. **The guided-breath table and the panels disagree on breath timing.** guided-breaths: 4·4·4×1 … 5·2·7×3 auto, Soul 3·2·3×3. The panels run 2–3 cycles of longer breaths. The closing-architecture prototype uses faster timings than the built panels (3 / 4.5 / 8 / 11 / 13 / 17 s vs 9 / 12 / 15 / 18 / 21 / 24 s).
13. **Gates versus no gates.** The reference HTMLs still enforce the essence and sequential gates, and the Welcome says "Nine practices are walkable now" / "can't skip". ASG D10 (May 2) and site-v3 removed all locks ("offering, not gating"; "ceremonies stay, locks go"). The K-W-A unlock triggers and dev-access guards also contradict this.
14. **The "No number may ever measure the player" law is absolute on screen.** It covers streaks, badges, dots, progress bars and congratulations. Leela on the 33 shows no counts. The VX2 map's "You touched N of 33" and the dance fruit "You have arrived N times" would break the newer law in the app.
15. **The voice architecture conflicts in several places.** ASG: Act 1 = Bindu, Act 2 = Sakshi. awakening-architecture: Act 1 = Gaia. The BCA Experience Brief: Gaia through room 8, then unvoiced. BCA Room Registers: per-room voices (Manipura Bindu, Anahata Higher Self, Ajna Sakshi, Sahasrara Lalita). The trinity's family numbering (Body 8–17, Mind 18–26, ToL 27–33) and topology's "Armin (chakra 33)" are wrong against the 33-map.
16. **Five shared triangles carry K-W-A.** P8, the P9 loop, the Temple and PBS each place Will / Knowledge / Action differently on the triangle (see M-TRIANGLE). Kāmeshvarī is always Will, Vajreshvarī always Knowledge, Bhagamālinī always Action.
17. **Shakti lists disagree.** P2's Karshinis (Kāma, Shabda, Sparsha, Rūpa, Smṛti, Ātma) differ from the design notes (Buddhi, Ahankāra instead of Rūpa, Smṛti). Sahasrara names 7 Vāgdevīs, with Aruṇā absent as "the silence". BCA lists Aruna separately at Intuition 25. The Manipura page says "Ten Shaktis" for the eight Anangas. BCA gives Muladhara "10 Siddhi Devis" against 6 in the panel.
18. **Several promised pieces are missing.**
    - **GAP.** The Axis Panel 10 triptych, Bindu's wake-up and dance, Vision / Crow / Axis gates and all Body/Mind/summit practice pages do not exist as files. The app is "the first rendering of positions 10–33".
    - **GAP.** The codex README lists parts 06–09 that are absent. The interlude page is not deployed. Gate-framework `imagePath` is empty.
19. **The Leela on the 33 board is a first draft awaiting Ashrey's ruling.** Arrows 5→8, 12→18, 13→20, 26→29; snakes 30→9, 19→10, 15→6, 28→21. Three-six return, square 32's treatment and the reading voice are open. In the engine version, a six is rigged to arrive within the first game's three throws.
20. **The persistent red Bindu (#C0392B, 6 px, top-right, .3) is the one constant across every panel** and every dance centre. Its "I Love You" in each chakra's colour is how affection is grown "by repetition, never by reward" (Field reading). It is never explained. Keep it.
21. **The QR codes encode root paths** (`/muladhara-wakeup.html`). The printed cloth panels use `/tree-of-life/…`. site-v3 rules: "The panel wins." Aatma's audio file is `soul.mp3`. `soul-dance.html` is to be renamed to `aatma-dance.html`.
22. **Sealed content must never be written into walker-readable documents.** That covers the Bindu Chakras App's Reveal, grace lines, exact Sakshi sentences and the Living Mandala. Lalita's room content is "held in the build". Author-substrate fields are never surfaced verbatim. The Lalita Pass is Ashrey's alone.

*End of register 06.*
