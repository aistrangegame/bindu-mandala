# The Mandala and the Nine Rings — the upgrade map, two worlds

Stage 2 of the upgrade (13 Oct 2026). Worlds: **THE MANDALA** (the held yantra and the Veil) and **THE NINE RINGS** (each ring its own world). Slices read in full: `waves/upgrade/index/by-world/mandala.jsonl` (353 rows) and `rings.jsonl` (514 rows), 791 distinct ids (76 shared). Foundation, rulings 1–17 and floors from `waves/register/READER-BRIEF-2.md` and `waves/upgrade/INDEX-BRIEF.md`.

How to read: §1 is the experience, second by second, with every number. §2 places every element (rows M00–M51, MX01–MX15 for what leaves the Mandala, R0-01–R0-18 for what all nine rings share, R1-… to R9-… for each ring). §3 is the parity ledger (also `waves/upgrade/ledger/mandala-and-rings.csv`). Register refs read `NN:lines` = `waves/register/NN-*.md`. Code paths are under `iOS/Bindu Mandala/`. "RESTORE" means bring back from `git show 3244f54^:<path>`, where the commit that folded the worlds into one glass deleted them (VeilView 679 lines, SriYantraMandalaView 483, RingWorldView 260, RingOne…RingEightWorldView 350–672 each, RingNineDescentView 451).

---

## 1 · The worlds

### 1A · THE MANDALA — the held yantra and the Veil

**In his words.** "When you are looking for the center, you may not be able to find it. Because you are indeed the center of the center … if you step outside one dimension, you look back from an eagle eye view, you realize that you are in the center itself. You cannot find it because you are it." (C-1197). "It's important to rise to the surface, see the islands that exist around, and actually travel to those islands" (C-1090). His origin: "I had put like a red dot right in the center. And I noticed … the formation of like this like white light moving behind the red dot. No particular pattern … that is intelligence, that is consciousness" (C-1222). The map is "designed to be overwhelming, so you kind of like learn to let go … where do I want to go?" (C-1289, read as a choice, not a law to overwhelm). The Mandala app is "a collection of all the energies … one energy to appreciate" (C-1353), and the practice is two-way: "build a practice to allow them to experience you" (C-1337).

**In Design's words.** "The Sri Yantra is not a feature inside the app. It is the world the app lives inside. It has presence, mood, time, depth, memory, and relationship. It is not the same yantra at dawn and dusk" (Codex §I). "Nine rings. Nine metabolisms. The ground does not breathe — it holds. The center never stopped calling. Everything between is alive." The Veil: "Resting: the yantra is a held image. Bindu breathes; Ring 2 petals live. A faint peek at the bottom whispers there is more below. Swipe up (or tap the handle) → a veil of dark ground rises over the yantra, which dims behind it but is never hidden." "Light, never locks — a padlock is the most secular thing we could put on a sacred object."

**What the world is.** One image you look at, and one sheet you draw over it. The yantra is *held*: "the instrument · look, do not operate". Its life is breath, light, time and the moon, and the Tratak that comes when he is still. Everything you *do* here is done with three gestures, each a door: touch the point (Home), draw up the Veil (the nine rings), or pinch to fall in (the living field of the 102, ending at the point). Nothing else is on this glass.

**What it is not any more (the clearing).** Today `LivingMandalaView` hosts seven worlds on one glass. Every one of these leaves (rows MX01–MX15):

| Drawn on the Mandala today | Code | Goes to |
|---|---|---|
| The 33 constellation, its 44 pt chakra buttons over Śakti seats | ChakraConstellationLayer, MandalaCanvasLayer:74-76 | **the 33** (its own canvas) |
| The Road (camera path, words, full-screen roadCatcher) | ChakraRoad, ChakraLayerOverlay:131-284 | **the 33** ("a story told by a moving point") |
| Shadow and Armin thresholds, "Tat · Tvam · Asi" | MandalaThresholdMoment | **the 33**, played when crossing between chakra spaces |
| Chakra rooms | ChakraRoomView | **the 33** |
| Gates of Release | GatesOfReleaseLayer | **each ring world**: offer on arrival, receive on leaving (R0-04) |
| Tree of Life panels, breath arc, collective breath, luminance | TreeOfLifeRingLayer | **each ring world** (R0-06, R0-07, R0-08) |
| Ring 7 chord, ring 8 unite on the glass | MandalaFieldVoice | **Ring 7 and Ring 8 worlds** (R7-04, R8-03) |
| Mauna, Pointy, Praveśa | TheCentre, StillnessAtTheCentre | **Home** and **Beneath**; Praveśa is also **Ring 9** (R9-03) |
| Lalitā source | LalitaSourceView | **Home**, as the arrival when the fall reaches the point |
| The Eight Dissolutions | TheEightDissolutions | **A Strange Game** (doorway into Leela) |
| Modes door | ModesDoorView via ways | **the Modes** |
| Climb door | ChakraRingClimb via ways | **the Climb** |
| The ways-in ring (six ways on a quarter arc) | WaysIn | retired → **the spine's menu and doors** |
| Significance card | SignificanceCard | her name blooms at her seat (M34); the rest is **Her Presence** |
| Second hamburger stacked above the ways mark | RootView:73-77 | one spine menu point |

**Arriving.** From Home the crossing is the yantra breathing out of the point (M49): from the touch, the Śrī Yantra draws outward — trikoṇa (fading in from .06 to .95 of the bloom), the nine triangles (.24→.82), the 8-lotus (.42→.62), the 16-lotus (.54→.85), the bhūpura (.66→.52), at scale .05 + .95·ease(p); the eyebrow last; the held image settles in 1.6 s. From the menu, a door, or back, he returns to exactly the state he left (M44): Veil offset, fall depth, focus.

**Being there — the held yantra, second by second.** 0 s: on ground #060104 with a .06 gold ambient and six motes rising (16–30 s each), the yantra sits at ×0.82, top 116 (M01, F37). Eyebrow (10 px gold, .26em): where he stands — "2nd Avaraṇa · Sarvāśā-Paripūraka" until he has entered another ring (M02). Caption at y 690, Cormorant 13 italic at .30: "the instrument · look, do not operate" (M03). At the foot only the Veil's top 108 shows: a 40×4 handle, a chevron breathing every 3.2 s, "THE NINE AVARAṆAS" (M14).

From the first second each ring metabolises at its own pace (M05). The bhūpura does not move. The sixteen petals breathe a 3 s wave, staggered 0.18 s petal to petal, with today's petal at 3.5 s, brightening 1 → 1.55 with a 6 → 14 px shadow, and a ray (r149 → 155) and dot (r2.5 at r160) pointing to it without a word (M06). The eight petals breathe 8 s. The up triangles breathe 9/11/13/15 s and the down triangles 10/12/14/16/18 s. The root triangle is almost still (18 s). The bindu beats like a slow heart: 4 s, ×1.20. Each petal's opacity is his relationship with her, from the ledger: .22 / .44 / .76 / 1.0 + glow. That is light, never a number (M07). The whole is lit from the bindu outward (M11): one source, each ring's gem bending it (topaz .20 … pearl .95, all gems .70). A veil over the far rings thins as he comes near and as he is still.

The hour relights it (M08): dawn strokes #E8C97A; noon cream with a vivid crimson bindu; dusk amber; night silver-blue (#9AB4C9 at .6) with a gold bindu r5; new moon mauve (#6A4A5A), petals drained to .30, the bindu ×1.6 ("when the moon is hidden, the Bindu rises"). A 6 px TemporalMark dot travels left → right with the day (M09). On the day's first arrival the moon's two lines rise once under the eyebrow: "when the moon is hidden, / the Bindu rises." or "the petals open / from the inside out." or "every petal in bloom. / all 16, all at once." or "the petals fold inward. / she returns to seed." (fade-up 1.4 s, stay 2.6 s, recede 1.6 s; M10).

If he is still (no touch, phone at rest), at 20 s a white light begins to move behind the red point, without pattern, and it is full at 45 s. This is his Tratak, his origin (M12). A touch dissolves it over .6 s.

Touch the point: the crossing to Home blooms from the touch. Hold it 0.9 s: the crossing goes straight to the source, Lalitā (M13). Hold two fingers 1.2 s: the yantra draws itself again in its construction order, stroke by stroke, each āvaraṇa lit while the rest hush to .35, then turns once in 80 s (M48).

**The Veil.** Drag the handle (or the peek). The sheet follows the finger, clamped 0…612. Let go: under 6 px of travel it is a tap and toggles; otherwise it snaps open if it is past 42% of its travel (offset < 257.04), else closed. It moves in .52 s on cubic-bezier(.22,1,.36,1), never animating under the finger. The yantra dims live with it to 0.5 + 0.5 × offset/612. It is never hidden, and its red bindu glow widens as the sheet rises (F39) (M16). The sheet (M15): 720 high, radius 22, gradient rgba(8,2,6,.995) → (11,3,7,.985) → (13,4,9,.92), a .5 px gold hairline at .22, "The Nine Avaraṇas" (Cormorant 22) and "DESCEND" (8.5 px gold). The caption fades .4 s.

Inside, the column reads downward as the geometry does, outer ground to inner point (M17). There are eight threshold rows. Each row has a RingGlyph (36), the name (Cormorant 20), "form · state" (13 italic), the meta "{form} · {count} forces" (9 px, a fixed canon count: 28, 16, 8, 14, 10, 10, 12, 3), and a Roman numeral (19). The row where he stands is washed gold and carries the ring's Notes paragraph. Light, never locks (M18): *You are here* .95, *Open* .85, *Ground* (outward of him) .60 in warm #CF9443, *Ahead* .30 dashed, *Veiled* .18 dashed, names never under .55. Every row opens. The Bindu is not a row. It is a footer (M19): a hairline from 14% to 86% gold .45, a warm crimson radial 180×130, a 26 px point pulsing 4.5 s, the name in Cormorant 24, "THE BINDU · IX".

Touch a row: the sheet closes and the crossing blooms from the touch, in that ring's colour, into **that ring's world** (M20). All nine are wired; no camera fall and no stack of five systems at once. Pinch apart on the open sheet and the rows regroup as the nine Doorways, arched chambers lit from within or veiled (M51). Pinch together to return.

**Going deeper — the fall.** Pinch or double-tap the held image. The held drawing cross-fades (.6 s, the bindu fixed) into the living field, and the ground opens into the indigo night sky (M22, M28, F08). Scale is clamped .32–5.5; fit is min(w,h)/760 × .94; flights take 720 ms ease-out; one finger pans; two pinch about the midpoint; travel over 6 px cancels a tap; a double-tap on empty space falls ×1.7 in .42 s; the moved / animating / armed guards hold. The tiers (M23): under 1.15 "the whole instrument · pinch to fall in"; under 2.3 "the nine enclosures", with ring labels "{Ordinal} · {form}"; beyond, "tap an energy · fall to the center for the source". The full yantra (M24) is Design's exact SY geometry at R 320 with gates and gate lights, both lotus rings, four circles, nine triangles at .585R, an 8 s shimmer, the bindu ×1.28, and strokes ×1.7 with no dimmers. 150 stars (seed 20260711) turn behind it (M27).

The 102 sit at their seats (M25): ring 1 on the square, the others on circles r 268 … 52, the point at the centre, 44 pt each. His own seat is the lit star. A felt seat is warmer, one size, never scaled by a count. Each breathes on her own rhythm, (3.4 + (kp mod 7)·0.7) s, and flares every 8 + kp mod 13 s (M26). Names come at tier 1 and the bīja at tier 2 (M31). Touch a seat (M32): the camera flies her to (w/2, .36h) at scale 3 in .72 s. Threads draw to her family over .7 s (Ring 2: her cluster; other rings: her ring) while everyone else dims to .28 (M33). Her name blooms under her seat, line by line, each line fading up 1.4 s (M34). Name at .3 s, phonetic, then the bīja at .9 s (touch it and she sounds, 3.6 s). Quality at 1.5 s, "threaded to N sisters". At 2.4 s two quiet doors: "enter her presence" and "be with her". Touch her seat again and he crosses into Her Presence.

Falling inward across an enclosure (M30, M35, M36), the entered ring flashes (.85 by .27 s, gone by 1.5 s). A bell rings, lower at each step inward: 493.88, 440, 392, 370, 329.64, 293.68, 277.2, 246.96 Hz. It is 1.7 s long, with a 12 ms attack, a lowpass closing 2400 → 700, and partials ×1, ×2, ×2.76, ×.5. With the light on, the ring's bīja is spoken in tone instead, and the syllable rises faint at the ring's label for 1.6 s. Going outward is silent. Each new depth writes *Ring Crossed* once. Only the ring he is in is lit, an annulus .62–1.34 of its radius (M41). The chrome thins as he goes, 100 / 80 / 60 / 25 / 0 %, and sinks after 3.8 s untouched (M38). The point warms from gold #C9A84C to ember #C0392B (M39).

**Leaving.** Pinch out past the fit and the field folds back into the held image. The fall's end is the point (M40). Past scale 4.3, with the bindu within 64 px of centre, the bindu swells, crimson filling outward as he keeps pinching. At the clamp, one more pinch is his choice: the camera eases .95 s to 5.4 with the bindu at .44h, *Ring Crossed* (9) is written, and Home's arrival (Lalitā's red bloom) takes over. It is never automatic. Other ways out: the point (Home), a Veil row (a ring world), a seat (Her Presence or Her Home), and the menu (anywhere). Back returns him to exactly here.

**Visual language and sound** (M50). Mandala chassis: ink #F2E8D9, gold #C9963F, warm #CF9443, gold-bright #D4A017, crimson #8B1A2A, veil #080307, silence #040104. The held image is on #060104 and the fall on indigo night. Cormorant Garamond Light carries names and voice, with system small caps. The held image is silent ("no sound, no words"). In the fall, ♪ (default off, lr_sound) gives bells and bījas. The + − ⤢ column is at right 16, bottom 26, in 46 px circles (M37). The deep bed under the fall (kingdom.mp3) waits on question Q2.

### 1B · THE NINE RINGS — each ring its own world

**In Design's words.** "Each avaraṇa is not a sub-page. It is its own world — with its own geometry, light, breath rate, sound, and gravity. A practitioner who has entered Ring 4 knows it by feel." Each world is "a complete small meditation", "each finding its own verb". **In his.** "Map these out as experiences for each energy within this Sri Yantra Mandala and how you can connect with it … build a practice to allow them to experience you" (C-1337). The rings read as "widening circles of compassion" (C-1205), and light and dark are one (C-1119).

**The shape every ring world shares** (R0-01 … R0-18). Each world is entered through the point, the crossing blooming in the ring's own token colour (R0-02).

1. **The threshold names itself** (R0-03). Over the world's ground a sigil of 620 turns at 42% height and .7 opacity (odd rings clockwise, even counter-clockwise), with 12 motes. The lines then rise in order:
   - .20 s: kicker "{Ordinal} Āvaraṇa · {form}"
   - .35 s: the name
   - .50 s: subtitle
   - .70 s: hairline
   - .80 s: his Personal Connection paragraph, word for word ("You have already been here …"; Ring 2 "You are here now."; Ring 9 "You have always been here.")
   - .95 s: the appreciation phrase in gold
   - 1.05 s: mental state · chakra
   - 1.15 s: shape · presiding form · yoginī
   - 1.25 s: "enter her ring"

   The first-ever visit to a ring takes the slower v2 ceremony (~7.8 s). Nothing is locked.
2. **The gate** (R0-04): "hold to offer it". A 2.6 s hold on a 76 pt ring offers the ring's mental state (*State Set Down*), and the mudrā is named as words (Ring 7: Khecharī).
3. **The presiding form** appears once, then recedes after 2.6 s over 1.6 s (R0-05).
4. **The verb and the declaration** (R0-06). The verb is AGITATE … ARRIVE. The declaration is the GameStructure panel line ("The earth that holds you was chosen by you." … "There was never anything to fear. There was only the Bindu, playing."), held for at least 8 s, plus the breath arc and the guide words, which thin toward ring 7.
5. **The world itself.** Its mechanism, its words and its sound are in R1–R9 below. FaintRingMemory squares sit at its edges (R0-09). Above are the return arc and the nine-tick rail; lower-left is the sound toggle (R0-10). Light deepens ring by ring, 5 → 100 % (R0-08).
6. **Its breath** (R0-07). Touch the empty ground and the whole ring answers: a ripple of 1.8 s (20 → 320 px) and a shimmer of 1.4 s. Hold 2.6 s and every mark glows together for three beats.
7. **Going deeper — its weather** (R0-13). Pinch apart and he stands alone inside the ring's 3D weather band, with the weather sentence and then, beat by beat (3 s each), the ring's facts: its name and epithet, the presiding form, Yoginī, mental state, the goddess's body here, gem · dhātu · clock · bīja · Siddhi · mudrā. Further stillness opens the Learning stations. A two-finger tap on the threshold turns the lens to "another map's nine" (R0-16).
8. **Leaving.** Swipe down (the return arc) to go back where he came from; the gate then gives him the ring's Siddhi (*Siddhi Received*). Touch a mark to go to Her Home. The edges lead to the neighbouring rings (fade .28 s / .4 s). The point leads to Home (R0-14).

**The nine at a glance** (light = token hue; root = the one tuning; Design frames as parity references):

| Ring | World | Verb (signature) | Marks | Light | Breath | Root · technique | Clock | Frames |
|---|---|---|---|---|---|---|---|---|
| 1 | the Earth-City (Trailokyamohana) | meet · illumine · ignite (AGITATE) | 28 on 3 squares | #CE9546, still | none | 55.00 · drone | day–night | F30–F33 |
| 2 | the Inhabited Lotus (Sarvāśāparipūraka) | press to invoke (LIQUEFY) | 16 petals | cluster hues | 3 s (today 3.5) | 61.74 · breath | the hour | F34, F35, F01 |
| 3 | the Smoke Lotus (Sarvasaṅkṣobhaṇa) | stillness gathers (DRAW) | 8 plumes | #C46482 | 8 s | 69.30 · breathy | the day | F19–F21 |
| 4 | the Lineage (Sarvasaubhāgyadāyaka) | the teaching travels (OPEN) | 14 stations | #BE3747 | 9 s | 73.42 · stepped 5.2 s | lunar fortnight | F15–F17, F22, F23 |
| 5 | the Overflow (Sarvārthasādhaka) | overflow (VOICE) | 10 triangles | #D37045 | 11 s | 82.41 · stepped 3.4 s | lunar month | F24 |
| 6 | the Concealed (Sarvarakṣākara) | nearness reveals (STILL) | 10 triangles | #4490A7 | 13 s | 92.50 · breathy | season | F25 |
| 7 | the Vāk Chamber (Sarvarogahara) | sound to heal (WITNESS) | 12 voices | #B04F8C | 15 s + tone pulse | 98.00 · sourceless | solar half-year | F26 |
| 8 | the Mūla Trikoṇa (Sarvasiddhiprada) | collapse, dissolve (SEED) | 3 vertices | #D62F29 / cream | 18 s | 110.00 · triad | year | F27, F02 |
| 9 | the Bindu, Praveśa (Sarvānandamaya) | hold to fall (ARRIVE) | the point | #E7CA6A | 4 s | 123.47 · Shepard | kāla–akāla | F28 (F29 → M49) |

**Ring 1 · the Earth-City** (R1-01 … R1-05, F30–F33). Warm umber-black (#0C0703 → #060301), an amber ambient at .11, 9 motes. "The three families ARE the three nested squares": 10 Siddhis on the outer square (half 150), 8 Mātṛkās on the middle (110), 10 Mudrās on the inner (72). Four T-gates on the outer square have embers breathing 5.5 s, and a far bindu sits at the centre. 28 lights are spread round the perimeters. **Meet** a light (44 pt, nearest-light): it swells to r5.4 with an expanding ring (2.6 s) and her name (40) with family · english and her line (19 italic; e.g. "the rooting tongue — speech that digs into the earth of meaning"). **Illumine** a family: the band lifts to .92 and the others fall to .10. The lived line rises (Siddhi "You have known these as work …"; Mātṛkā "… The world was spoken before it was seen."; Mudrā "… Matter became sacred in the moving."), then the family question: "which of the 10 Siddhis is latent in me right now?" **Ignite** a gate: all 28 alight, "Thank you for the world I have walked through without knowing it was you." · "THE WHOLE GROUND, ALIGHT". Touch the ground to **release**. Sound: a drone on 55 Hz with its fifth (82.41) fades in over 2.2 s with a .07 Hz LFO ("the world turning, almost still"), and a crawling haptic for earth. The ground does not breathe.

**Ring 2 · the Inhabited Lotus** (R2-01 … R2-07, F34, F35, F01). The home ring, "wide, generous, with room between everything". A full-screen lotus (oR 172, iR 96, hw 32) in cluster colours (inner #D4A017, tanmātra #C4725A, citta #2A7A7A, stability #4A7A5A, self #7A5A9A) under status light, breathing in a 3 s wave. Today's halo (blur 11, .42), a memory of the inner triangles at .08, a bindu breathing 9 ↔ 12 over 4.5 s. **Press and hold a petal**: she rises and the others mute to ×0.18. Over her come name (.3 s), bīja (.9 s), quality (1.5 s) and "release · she remains" (2.4 s). Let go and she remains 2600 ms. The lotus **follows the sun**: openFactor .78 dawn, 1.0 noon, .85 dusk, .45 night. Hold off the petals and **Tripureśī** — the ring itself — glows whole: "The heart draws. The crown reveals who was drawing." Going deeper, the sixteen Karṣiṇī Functions circulate petal to petal. Sound: home breath on 61.74 Hz; the home voice 123.48 + 185.22 Hz breathing at .18 Hz, .045 → .075 while pressing.

**Ring 3 · the Smoke Lotus** (R3-01 … R3-03, F19–F21). Eight blurred plumes (116/30/52, blur 5.5) and a seed "hsauṁ". Reaching scatters: for 800 ms after movement the plumes drift 24 px, swell 1.18 and fade to .18 — "The more you reach for her, the more she thins." Stillness gathers (.66, brightness 1.05): "Be still — and the bodiless longing gathers." Touch a plume and she names herself in italics, then dissolves back. Touch the seed and all eight unify for 2600 ms: "Eight forms, one longing. The desire that arrives without a body." Sound: longing at 138.60 Hz with a 6 Hz vibrato.

**Ring 4 · the Lineage** (R4-01 … R4-03, F15, F22, F23). Fourteen triangles on r150 joined by a garland bowing inward (control at 84%). A light travels one station every 340 ms, starting 900 ms after arrival; the garland fills; touch the centre to send it again. Touch a station: name, gloss ("the stirring" … "the perfecting") and "THE {ordinal} OF FOURTEEN · RECEIVED, AND PASSED ON". Full: "The garland is unbroken — every name still passed, hand to hand." Sound: stepped on 73.42 Hz, the lineage tone rising 146.84 × 2^(i/24).

**Ring 5 · the Overflow** (R5-01 … R5-03, F24). Ten triangles inside a kula circle r142. Touch one and her rays (r106 → 212) spill past the circle. Touch the centre and all ten flood while the boundary dissolves to dashes: "The accomplishment overflows the one who sought it." · "THE BOUNDARY CANNOT HOLD HER". Sound: 164.82 Hz for a touch; for the flood, four notes ×[1, 16/15, 9/8, 6/5] staggered 90 ms.

**Ring 6 · the Concealed** (R6-01 … R6-03, F25). Darkness. A light of 193 px follows the finger (.18 s lag) and reveals only the triangles within 92 px (opacity (1 − d/92)·.85); the orbit is widened to 120. Touch what it reaches and her name whispers in and out over 3.2 s: "she will not stay". "What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near." Sound: within at 185 Hz, rising as the light nears her (.05·(1 − d/92)).

**Ring 7 · the Vāk Chamber** (R7-01 … R7-07, F26). "The world where language and life have not yet separated." Twelve voices, 44 px, at 30° on r140, carry the **Airtable names**: Vasinī Aṃ · Kāmeśī Kaṃ · Modinī Caṃ · Vimalā Ṭaṃ · Aruṇā Taṃ · Jayinī Paṃ · Sarveśī Yaṃ · Kaulinī Śaṃ · Bāṇinī · Cāpinī · Pāśinī · Aṅkuśinī (the four Weapons carry no bīja and strike). They are tuned on root 98 by their syllable: 196, 245, 326.67, 220.5, 294, 196, 261.33, 326.67 Hz; the Weapons at 98, struck. Each sounds sourceless, partials 2f/3f/5f with no fundamental, and coincident pairs part in stereo. Touch one: 2.6 s, with three rings widening from *that* node. Touch the centre: all twelve, 55 ms apart, with four cream rings. When seven distinct voices have sounded, the word arrives — "The word that healed what the mind could not reach." · "she who removes all disease" — and no counter is ever drawn. The mudrā is **Khecharī**, named at the gate. The screen resonates: a haptic on each 15 s breath and under the chord. Hold off the nodes and Tripura Siddhāmbā (the ring) glows whole. Hold a Vāsinī 1.2 s for the door to her mind chakra in the 33 (Vasinī → Inception … Kaulinī → Innocence).

**Ring 8 · the Mūla Trikoṇa** (R8-01 … R8-03, F27, F02). Cream on black, three points: Icchā (#C45050, Kāmeśvarī 99) at the apex, Jñāna (#9A8FC4, Bhagamālinī 101) bottom-left, Kriyā (#5A9A8B, Vajreśī 100) bottom-right. "The root triangle. / Will, knowledge, action — / one undivided power." Touch a vertex: the other two collapse into it (dashed lines, .22) and her power's name stands 76 px. Touch again: a bindu swells at the centroid (r7 → 52 in 1.4 s) — "The three were never three." · "Will, knowing, doing — three motions of the same hand. The hand was always whole." Touch again to begin again. Sound: 220 / 277.2 / 330 Hz glide (.55 s) into the chosen vertex, then all to 110 Hz.

**Ring 9 · the Bindu — the fall into the point** (R9-01 … R9-05, F28). "There is nothing else. The whole screen is the point." Deep indigo-violet; one red point with a white core. "Press and hold — / fall inward." Seven gold yantras, each carrying sixteen of the 102 names, emerge from the point and engulf the screen (scale .03·2^(6.4d)) in a slow spiral, forever. Holding quickens the fall; stillness alone lets it drift on; the Shepard tone falls without end (7 octaves from 30.87 Hz). "There is no bottom." · "only further in". After 6.5 s of held fall, recognition rises and is full at 8.7 s: "You did not arrive. / You were the arriving." · "Thank you for being the place I have always already arrived." Then the words go (4 s), the tone goes (6 s), the yantras stop: "and then nothing. The silence after is the point." A touch: he is Home — the same point, nothing moves.

**Sound of the nine** (R0-11). One tuning: the ring roots 55.00 · 61.74 · 69.30 · 73.42 · 82.41 · 92.50 · 98.00 · 110.00 · 123.47 Hz, with one technique per ring and event voices at root × 2 keeping Design's intervals. Everything is gesture-started, quiet (gain .05–.07) and stoppable at the lower-left toggle. No sound is invented for a Śakti: only her bīja's interval on her ring's root.


## 2 · Every element, placed

Status today: built / partial / not / wrong (with code refs). Action: REUSE (as is), MOVE (into this world from where it sits), RESTORE (from git 3244f54^), FIX / RETUNE / CHANGE (built but differs), NEW. Index ids are the slice rows this element carries; register refs give the lines to open.

### 2A · THE MANDALA

| # | Element | What it does (mechanism + numbers) | Source (index ids · register) | Status today · code | Reuse / move / new |
|---|---|---|---|---|---|
| M00 | The law of the world (his words, Design's words) | Not a feature inside the app but 'the world the app lives inside' (Design Codex §I). The centre cannot be found by searching: 'you are the center of the center' (C-1197). Eagle-eye: rise and see the islands (C-1090); dreams within dreams (C-1181). The overwhelm resolves at once into 'where do I want to go?' (C-1289 read with its misread flag). Energies one is surrounded by (C-1124); one yantra, three ways (appreciate · climb · play, BC-04). Reconciled: the yantra is held (look, do not operate) AND gestures, Veil, menu and doors all lead on (ruling 10). | G1-0771 G1-0772 G1-0774 G1-0621 G3-0413 G3-0362 G3-0406 G3-0476 G3-0528 G3-0378 G2-0357 · 03:885-887, 909-914, 974; 07:215-218, 295-298, 435-438, 470-473, 785-788, 1321; 04:588 | n/a · `—` | Words govern §1; not a ledger row |
| M01 | The held yantra (SriYantraMandala v2, label-less) | Drawn at 344 and held at ×0.82 in a 600 box, top 116, on a 390×844 stage. Ring 1: outer square half 161, inner 149, gate half-width 11, stroke #CF9443 at .22, no motion. Ring 2: 16 petals petalPath(oR 147, iR 116, hw 28), petal 0 at 12 o'clock, clockwise 22.5°, fill = cluster colour × status opacity. Ring 3: 8 petals (114, 91, 34). Rings 4–7: triangle pairs R4 87/79 stroke .70, R5 70/62 .65, R6 54/46 .60, R7 40/33 .55. Ring 8: one down triangle R 24 ('almost imperceptible'). Bindu 22 px radial #8B1A2A → cream core ×.42. No labels on the held image ('you will learn to see her without a label'); no words but eyebrow and caption. | G1-0674 G1-0693 G1-0654 G2-0091 G2-0012 G2-0011 G5-0419 G7-0197 G2-0430 G2-0382 G2-0315 G2-0098 · 03:176-187, 324-339, 450; 04:162-163, 62-63, 694; 13:387-390 | not (deleted 3244f54) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/SriYantraMandalaView.swift (483 lines)` | RESTORE from git as Views/Mandala/HeldYantra.swift; drop R2/R3 labels; draw with MandalaLight (M11) |
| M02 | Eyebrow: where he stands | 10 px gold small caps, .26em, centred above the yantra. Names the ring where he stands (DescentState.currentRing, default 2): '2nd Avaraṇa · Sarvāśā-Paripūraka'. Changes only when he has entered another ring world. | G1-0684 · 03:392 | partial (code header 'Sri Yantra' on the zoom field) · `Views/Mandala/LivingMandalaView.swift:260-282` | NEW in HeldYantra; read DescentState |
| M03 | Caption 'the instrument · look, do not operate' | Cormorant 13 italic rgba(242,232,217,.30) at top 690; fades out over .4 s when the Veil opens and back when it closes. | G1-0684 G1-0621 · 03:392, 56 | not · `—` | NEW |
| M04 | Ground, ambient and motes of the held image | Ground #060104; ambient wash rgba(201,150,63,.06); 6 dust motes rising (moteRise 16–30 s), counts per hour from TimeVariant (dawn 8, noon 6, dusk 9, night 12, new moon 3). Fonts: Cormorant Garamond 300 + system small caps 9–11 px .2–.32em. | G1-0602 G1-0684 G7-0031 · 03:8, 392; 19:96 | partial · `Views/Mandala/MandalaCanvasLayer.swift:184-213 (motes)` | REUSE motes; NEW ground on held image |
| M05 | Nine metabolisms (breath slows toward the centre) | Ring 1 holds (no breath). Ring 2 petals 3 s (today's 3.5 s), staggered i×0.18 s so the lotus undulates. Ring 3 8 s, delays i×0.6 s. Up triangles 9/11/13/15 s (peaks 1.25/1.20/1.18/1.15), down triangles 10/12/14/16/18 s. Ring 8 18 s ('almost still'). Bindu 4 s, scale 1→1.20 ('a slow heart'). Ring-2 status breaths: embodied 4.5 s, active 6 s, exploring 7.5 s, mapped 10 s. Periods are Design's own, unsnapped: BreathClock must stop rounding to eighths of 8 s (one epoch, many tempos). | G1-0655 G1-0660 G2-0058 G5-0173 G7-0044 G1-0673 G2-0449 G5-0485 G1-0777 G1-0620 · 03:188-203, 233, 303-322; 04:119, 734; 12:485; 13:867; 19:144-150 | partial (MandalaBreath built; BreathClock snaps home to 3 s) · `Views/Mandala/MandalaBreath.swift; Theme/BreathClock.swift` | REUSE MandalaBreath on the held yantra; FIX BreathClock.period (no snapping) |
| M06 | Today's petal glows warmer, a ray points | Today's Ring-2 petal: brightness 1→1.55 and drop-shadow 6→14 px over 3.5 s; a blurred glow copy .45→.78, scale 1.06. TodayIndicator: a ray r149→155 and a dot r2.5 at r160, no text ('the active petal already speaks'). DS-12's 'TODAY' label is not drawn. | G1-0655 G1-0674 G2-0013 G1-0651 · 03:154-163, 188-203, 324-339; 04:64 | not (held image deleted) · `—` | RESTORE with M01 |
| M07 | Status as light on the 16 petals (never a count) | Each Ring-2 petal's opacity is its relationship with him, read from App Activity: mapped .22 · exploring .44 · active .76 · embodied 1.0 + soft glow. Shown only as light; no numbers, labels or progress line anywhere (the v1/v2 '5 of 16 Active' line is dead). | G2-0008 G1-0673 · 04:59; 03:303-322 | partial · `Theme/SeatLighting.swift` | REUSE tier from ledger; draw on held petals |
| M08 | The yantra relit by the hour and the moon (TimeVariant) | Five states from LunarPhaseService.currentTimeVariant (new moon; night <5 or ≥21; dawn <10; noon <15; dusk): Dawn stroke #E8C97A, bindu #E8C97A r3; Noon #F2E8D9, 4 triangles .95, bindu #8B1A2A r3; Dusk #C9963F; Night #9AB4C9 stroke .5 op .6, gold r5 .5 + cream r2; New moon #6A4A5A .4, crimson r7 .85 + cream r3, petals desaturate to .30, bindu ×1.6. Full table (bg, ambient, petalSat, petalBrightness, petalOpacityMul, lotusInnerOp, triStroke/Op/Width, bhūpura, binduScale 1/1/1.05/1.1/1.6, motes 8/6/9/12/3) is TimeVariant.swift verbatim. 'The home you return to at dawn is not the home you find at dusk.' | G1-0651 G2-0088 G2-0117 G7-0046 G7-0047 G7-0687 G6-0823 · 03:154-163; 04:159, 198; 19:156-160; 22:219; 17:497 | built (TimeVariant) on the zoom field only · `Views/Mandala/TimeVariant.swift:5-179; Services/LunarPhaseService.swift:130-138` | REUSE; apply to the held yantra |
| M09 | TemporalMark — one 6 px dot for the hour | A single 6 px dot in variant.markColor at .6, no text. Its x travels with the day: dawn at the left edge of the yantra's box, noon centre, night right (positions declared in Design, never used). | G2-0090 · 04:161; 03:64-65 | partial (dot built, always centred) · `Views/Mandala/LivingMandalaView.swift:260-282` | MOVE to the held image; NEW x by hour |
| M10 | The lunar yantra (four lunar atmospheres) | Same yantra in the moon's state: new 'Amāvasyā · the dark moon' — 'when the moon is hidden, / the Bindu rises.' (bg rgba(139,26,42,.18), intensity .25, bindu 90 px breathing 6 s, motes 4); waxing 'Śukla Pakṣa · the moon waxes' — 'the petals open / from the inside out.' (.75, bindu 28, motes 8); full 'Pūrṇimā · the full moon' — 'every petal in bloom. / all 16, all at once.' (1.35, bindu 22, motes 14); waning 'Kṛṣṇa Pakṣa · the moon wanes' — 'the petals fold inward. / she returns to seed.' (.55 silver, bindu 38, motes 8). The phase's two lines rise once on the day's first arrival under the eyebrow (fade-up 1.4 s, stay 2.6 s, recede 1.6 s). | G1-0753 · 03:771-778 | not · `—` | NEW (lunar gains multiply the hour's TimeVariant) |
| M11 | One light from the Bindu, nine refractions (MandalaLight) | Source = ring-9 hue (h46 gold); falloff 1.35; refraction never past halfway (limit .45); each ring's gem bends the light by diffusion (topaz .20, sapphire .30, coral .45, diamond .15, emerald .25, ruby .55, pearl .95, cat's eye .10, all gems .70). Veil over far rings clears with nearness and stillness (mark ≤ .45, text ≤ .25, floor .5; stillnessSpan 4 s, nearnessShare .55). 'Lit from the Bindu' — Exp #27, 'the most consequential single visual change'. | G6-0860 G6-0903 G7-0972 G7-0683 G2-0233 G2-0378 · 17:713, 762; 22:208-215, 580; 04:364, 620 | built (zoom field) · `Theme/MandalaLight.swift:80-417` | REUSE on held yantra and fall |
| M12 | Tratak — white light behind the red point | His origin (C-1222): a red dot at the centre, a white light moving behind it, 'no particular pattern'. After stillness (no touch, device still) the light begins at 20 s and is full at 45 s, drifting behind the bindu; any touch dissolves it over .6 s. Two clocks run: stillSeconds (1 Hz, stops at tratakFull) and the hour (re-read every 60 s). Reduce motion: on/off only. | G7-0040 G3-0426 G7-0016 · 19:110, 58-60; 07:535-538; 17:713 | built (zoom field) · `Views/Mandala/MandalaCanvasLayer.swift:648-671; LivingMandalaView.swift:175-199` | REUSE; MOVE onto the held image (rest state is where gazing happens) |
| M13 | The point on the held yantra | The bindu is the spine's point here: tap → crossing to Home (the Bindu) blooming from the touch in Home's colour. Hold 0.9 s → 'reach the source': the crossing goes straight to Lalitā (Home's arrival). Hit target 44 pt round the 22 px point. No Mauna on this glass (Mauna lives in Home). | G5-0172 G7-0085 · 12:484; 13:175-176; 19:268-272 | partial (64 pt point opens Mauna) · `Views/Mandala/TheCentre.swift:68-132` | MOVE Mauna/bloom out; NEW point = spine point |
| M14 | The peek: the Veil always present | The sheet is always in the view, its top 108 visible (closed translateY 612). Handle 40×4 rgba(242,232,217,.30); chevron breathing peekHint 3.2 s; 'THE NINE AVARAṆAS' 8.5 px gold .5 .26em. Design Audit I: 'thematically exact … the closed handle breathes a chevron'. | G1-0685 G7-0049 G2-0118 · 03:393-395; 19:168, 667; 04:199 | wrong (peek is a separate button; sheet absent when closed) · `Views/Mandala/MandalaVeil.swift:158-194` | FIX: sheet always mounted at offset 612 |
| M15 | The Veil sheet | Height 720; gradient rgba(8,2,6,.995) → rgba(11,3,7,.985) → rgba(13,4,9,.92); top border .5 px gold .22; radius 22; shadows. Open header 'The Nine Avaraṇas' Cormorant 22 + 'DESCEND' 8.5 px gold. Ground carries a gold wash at the row where he stands (code). Chosen from four Legend placements ('the gesture is the point'). | G1-0685 G7-0054 G7-0050 G7-0060 G2-0431 G1-0695 G4-0876 · 03:393-395, 456-458; 19:169-173, 666, 673-674; 04:695; 11:665 | partial (height min(h×.8, 660)) · `Views/Mandala/LivingMandalaView.swift:451; MandalaVeil.swift:212-301` | FIX height 720 |
| M16 | Drawing the Veil (gesture G42) | Pointer on the handle (touchAction none). The sheet follows the finger, clamped 0…612 (÷ stage scale). Release: movement < 6 px = tap → toggles (open if offset ≥ 306 else close). Otherwise snap open if offset < 257.04 (612 × 0.42), else close. Transform .52 s cubic-bezier(.22,1,.36,1), none while dragging; reduce motion easeOut .2 s. The held yantra's opacity tracks the sheet live: 0.5 + 0.5 × offset/612 (→ 0.5 open), .5 s; never hidden. Backdrop tap or swipe down closes. Column opacity 0→1 .4 s. As the sheet rises the bindu's red glow widens (F39). Esc / back hotspot top 44 left 0 180×56. | G1-0686 G1-0605 G7-0055 G7-0056 G7-0057 G7-0058 G7-0059 G7-0023 G4-0766 G1-0683 G4-0691 G4-0704 G1-0682 G2-0432 G7-0171 G5-0353 · 03:30-32, 380-389, 396-397; 19:75-79, 668-672; 11:131, 316; 04:696; 13:118 | partial (curve built; no drag, no snap, fixed .45 black dim) · `Views/Mandala/LivingMandalaView.swift:439-511; MandalaVeil.swift:186-250` | FIX: drag tracking, 42% snap, proportional dim; REUSE curve |
| M17 | The nine threshold rows (I–VIII) | Column read top→bottom = outer ground → inner Bindu ('Descent, not a menu'). Row padding 15/16, radius 13, gap 16; RingGlyph 36; Sanskrit name Cormorant 20; subtitle 13 italic ('form · state'); meta 9 px '{form} · {count} forces' (a fixed canonical count, not about him: 28/16/8/14/10/10/12/3); Roman numeral 19 px; where he stands: linear rgba(201,150,63,.10)→.03 wash + border .26 and the ring's Notes paragraph (RingFactsCache.notes). Bottom border dashed for ahead/veiled, solid otherwise. | G1-0687 G7-0051 G7-0052 G1-0694 · 03:399-409, 452-454; 19:174, 675, 677 | built (meta count missing) · `Views/Mandala/MandalaVeil.swift:304-429` | REUSE; ADD meta '{form} · {count} forces' |
| M18 | Five lights, never locks | Status is luminosity, read from where he stands (DescentState), never progress and never a padlock: You are here glyph .95 · name .96 · sub .62 · #C9963F wash + glow; Open .85/.88/.54 gold glow; Ground (rings outward of here) .60/.66/.42 #CF9443; Ahead .30/.36/.24 dashed; Veiled .18/.22/.15 dashed. Names never below alpha .55 (contrast ≥ 3:1, code's floor). VoiceOver: 'ahead, not yet walked'. Every row opens (ruling 16). A tier change is a small ceremony (the glyph brightens over 1.4 s), never a toast. | G1-0691 G5-0174 G7-0048 G7-0974 G1-0683 G2-0197 G6-0800 · 03:385-389, 399-409, 425-433; 12:486-496; 19:163-167, 676; 22:582; 17:321 | built (position-read) · `Views/Mandala/MandalaVeil.swift:37-127; Models/DescentState.swift` | REUSE |
| M19 | The Bindu footer (IX) | 'A more present hairline — you have reached the center of the column': gradient line 14%–86% gold .45; radial warmth 180×130 rgba(139,26,42,.20); 26 px point #8B1A2A → rgba(139,26,42,.65) at 55% + 10 px cream core glow 12 px .6, veilBinduPulse 4.5 s; name Cormorant 24 gold; subtitle 14 italic .6; 'THE BINDU · IX' 8.5 px gold .55 .26em. Tap → Ring 9 world. | G1-0688 G7-0053 · 03:411-412; 19:175 | built · `Views/Mandala/MandalaVeil.swift` | REUSE; ROUTE to Ring 9 world |
| M20 | Rows open the ring worlds (the missing join) | Tap a row → the Veil closes (.52 s) and the crossing to that ring's world blooms from the touch through the point in the ring's colour (R0-01). All nine wired (Design wired only Ring II; code fell the camera instead). One crossing triggers one thing: no flash, threshold, gate, bīja and chord all at once. | G1-0689 G1-0775 G7-0061 G7-0083 · 03:414-416, 977; 19:608-616, 678, 766, 801 | wrong (camera fallTo) · `Views/Mandala/LivingMandalaView.swift:499-511` | REPLACE fallTo with router.cross(to: .ring(n)) |
| M21 | RingGlyph — nine sigils from primitives | stroke max(.7, size/34): 1 square half .36·size; 2 circle r .16 + 16 ticks .22→.42; 3 circle + 8 ticks; 4 interlocked star (up+down triangle r .40); 5 up triangle + half-size up at .6; 6 down triangle + half-size down at .6; 7 Vāk circle r .34 + 12 dots; 8 single down triangle r .40; 9 circle r .40 (stroke .7sw .5) + dot r .16. Shared by Veil rows and every ring world's top rail. | G1-0692 G7-0063 · 03:435-448; 19:346-348, 679 | partial (4–7 share crossed triangles) · `Views/Mandala/RingGlyph.swift:20` | FIX glyphs 4–7 |
| M22 | The fall — going deeper (semantic zoom, ruling 9) | Pinch or double-tap the held yantra and he falls in: the held drawing cross-fades (.6 s, bindu fixed) into the living field and the ground opens to the indigo night (M28). Camera {scale, tx, ty} clamped .32–5.5; fit = min(w,h)/760 × .94; animateTo 720 ms ease-out cubic; one-finger pan; two-finger pinch about the midpoint; travel > 6 px cancels a tap; double-tap empty space ×1.7 over .42 s; Guards moved / animating / armed preserved. Pinch out below fit → the living field folds back into the held image. 'If this is overwhelming, where do I want to go?' | G1-0498 G1-0502 G7-0017 G7-0043 G1-0589 G7-0680 G5-0071 G3-0362 G3-0406 G3-0476 G2-0180 G2-0211 G1-0574 · 02:762-805, 1458-1469, 1588; 19:62-66, 135-142, 646; 04:283, 327; 22:196 | built (as the whole Mandala) · `Views/Mandala/MandalaCamera.swift; LivingMandalaView.swift:232-258, 521-550` | REUSE; NEW held↔living cross-fade |
| M23 | Semantic tiers and their hints | scale < 1.15 cosmic, < 2.3 named, else significance. Header 'Śrī Yantra' 25 px weight 300 .1em (code 24); hint 9.5 px .42 (code 11.5, keep ≥ 11 for legibility): tier 0 'the whole instrument · pinch to fall in', tier 1 'the nine enclosures', tier 2 'tap an energy · fall to the center for the source'. Tier ≥ 1: ring labels '{Ordinal} · {form}' gold .6 above the circles. | G1-0503 G1-0504 G7-0022 G2-0402 · 02:807-816; 19:74, 648; 04:661 | built · `Views/Mandala/LivingMandalaView.swift:260-282` | REUSE |
| M24 | The full yantra of the fall (SriYantraGeometry SY_R 320) | 3 bhūpura squares 1.0/.94/.88 R (op .5/.4/.3, width 1.1); 4 T-gates half .11R depth .05R (.45) with gate lights; circles .90/.80/.70/.615 R; 16 petals .80–.90 (.34); 8 petals .615–.70 turned 22.5° (.36); holding circle .60 (.4); nine triangles at .585R (SY_DOWN/SY_UP tables, .5); bindu r .10R radial red .6→0 breathing ×1.28 (syBinduBreath 5.5 s); shimmer 8 s .82↔1; each line drawn three times with light on (×5, ×2.2 additive). Strokes ×1.7 with no 0.9/0.7 dimmers (the port loss). Draw order without the 33: sky, stars, motes, enclosures, today's ring, flash, yantra, bindu glow, family threads, seats, names, Tratak. | G1-0499 G7-0041 G7-0682 G7-0973 G7-0035 G7-0036 G2-0389 G2-0384 G2-0374 G7-0029 · 02:765-787; 19:93-94, 102-103, 117-126, 644; 04:611, 626, 632; 22:198-207, 581 | built · `Views/Mandala/SriYantraGeometry.swift; MandalaCanvasLayer.swift:66-79, 343-442` | REUSE; REMOVE ChakraConstellationDrawing from draw order |
| M25 | The 102 seats | SY_RING_R 306/268/224/178/145/116/88/52/0; ring 1 on the square's perimeter at t=(idx+.5)/n; rings 2–8 evenly from −90°; ring 9 the centre. Dot radius focus 7, today 6, family 5.5, felt 4.4 (one felt size — 'whether, never how often'), else 3; lit opacity 1 + glow, unlit .5. His own position (kp) is the lit star; walked seats carry felt warmth (Bool). Hit ≥ 44 pt (Design's 26 raised to the floor); nearest seat within 34 pt. Seat colour always Atmosphere.derive, 102 distinct. | G1-0500 G1-0505 G7-0037 G7-0042 G7-0038 G7-0681 G7-1031 G7-0651 G4-0859 · 02:789-791, 818-822; 19:104-109, 114, 128-133, 645, 651; 22:123, 197, 644; 11:589 | built · `Views/Mandala/MandalaWorld.swift:20-69; MandalaCanvasLayer.swift:480-632` | REUSE |
| M26 | Each energy breathes on her own rhythm | In the fall (not on the held image, which breathes by ring): each seat's breath (3.4 + (kp mod 7)×0.7) s, delay −(kp mod 11)×0.6 s; flare (8 + kp mod 13) s phase-offset; today pulses 2.6 s with a 22 px ring. 'each energy breathes and flares on her own rhythm — the field is alive.' | G1-0506 G7-0039 · 02:823-824; 19:650 | partial (code breathes per ring) · `Views/Mandala/MandalaBreath.swift:124-129` | CHANGE seat breath to Design's per-kp periods inside the fall |
| M27 | Starfield | 150 stars, LCG seed 20260711; radius 120–740; size .5–2.3; opacity .12–.62; every 5th gold; 40% twinkle (5 + d) s. | G1-0501 G7-0030 · 02:793; 19:95, 115, 649 | wrong (120 stars, seed 20240517, .5–1.9, .1–.5) · `Views/Mandala/MandalaCanvasLayer.swift:147-175, 680-700` | FIX to Design; re-pin MandalaDrawCensus |
| M28 | The indigo night sky of the fall | MandalaSky: radial from sky.center → mid (60%) → edge, centred at .44h; two faint washes of far air; the hour's ambient; the day's glow radial(80% 55% at 50% 44%). Governs over the crimson-black that was a port loss (C10). touch-action none. | G1-0514 G7-0045 G2-0444 G2-0401 · 02:857; 19:152-154, 657; 04:660, 729 | built · `Views/Mandala/MandalaSky.swift` | REUSE |
| M29 | Motes by the hour (fall) | Motes follow variant.motes; envelope rises to 8%, eases to .5 by 92%, gone at 100%. | G7-0031 · 19:96 | built · `Views/Mandala/MandalaCanvasLayer.swift:184-213` | REUSE |
| M30 | Enclosures, today's ring, the ring flash | Light off: hairlines gold .06; light on: gem bands. Today's ring: dashed circle (accent .5, width 2/sc) pulsing .42 ± .16 sin(1.1t). On an inward crossing the entered ring flashes: to .85 by .27 s, gone at 1.5 s (width 2.5/sc). | G7-0032 G7-0033 G7-0034 G1-0507 G1-0512 · 19:97-101; 02:825-827, 851 | built · `Views/Mandala/MandalaCanvasLayer.swift:243-327` | REUSE |
| M31 | Names and bījas by tier | Short name at tier 1, full name at tier 2 or in her family; serif 9 px counter-scaled 1/min(max(sc,1),2.4). Tier 2 adds 'bīja {syllable}' italic 7.5 px accentBright .85 at +24 (bījas may sit in the yantra — the corpus guard 'no seed syllable near the figure' is superseded in this app). | G1-0507 G5-0325 · 02:825-827; 12:1010; 13:389-390 | built · `Views/Mandala/MandalaCanvasLayer.swift:496-632` | REUSE |
| M32 | Fly to her seat; second touch crosses to her presence | Touch a seat: ignored if moved; else flyTo scale 3.0 with her seat at (w/2, .36h), ease-out .72 s. Touch her again → crossing to Her Presence (through the point, in her colour). A seat in ring 9 opens nothing here: the centre is reached by the fall (M40). | G1-0508 G7-0018 G7-0169 G6-1048 · 02:829-833; 19:67-68, 561, 646; 18:125 | built · `Views/Mandala/LivingMandalaView.swift:554-613` | REUSE; ROUTE second touch via router to Her Presence |
| M33 | Threaded to her family | Lines from her seat to each family member (Ring 2: her cluster; other rings: the whole ring minus herself); accentBright 1 px non-scaling; draw .7 s staggered .05 + i×.035 s (code .8 s after .15 s). Non-family dim to .28 and stop taking touches. | G1-0509 G7-0200 G5-0440 · 02:835; 19:652; 13:451, 903 | built · `Views/Mandala/MandalaCanvasLayer.swift:446-476, 537` | REUSE |
| M34 | Her name blooms at her seat (no card) | Replaces the Significance card (ruling 17: revealed through form, never a page; the card clipped her text). Under her seat, line by line, fade-up 1.4 s each: name Cormorant 34 at .3 s; phonetic; bīja 26 italic gold at .9 s — touch the bīja to sound her (lrPlayBija, 3.6 s drone, the tuned carrier); quality 16 italic at 1.5 s; 'threaded to {N} sisters · {cluster \| ring}' italic 13; at 2.4 s two quiet doors 'enter her presence' (Her Presence) and 'be with her' (Her Home). Everything longer lives in Her Presence. No figure of a Śakti, ever. | G1-0510 G7-0095 G1-0682 G7-0168 G7-0170 G5-0443 · 02:837-845; 03:380-383; 19:321-324, 560-562, 653; 13:475 | partial (SignificanceCard) · `Views/Mandala/SignificanceCard.swift` | REPLACE card with in-field bloom; REUSE copy sources |
| M35 | The bell inward, silent outward | reachLocal = (min(w,h)/2)/scale; entered = deepest r in 1…8 with SY_RING_R[r] > reachLocal. On an inward increase: ring flash and a bell; outward silent; throttle 55 ms. Bell 1.7 s; .0001→.085 in 12 ms; lowpass 2400→700 over 80%; partials ×1 (1), ×2.0 (.3, .7 dur), ×2.76 (.16, .5 dur), ×.5 (.22, .9 dur). Pitch in the one tuning, still falling inward: bell(r) = root(10−r) × 4 → 493.88, 440.00, 392.00, 370.00, 329.64, 293.68, 277.20, 246.96 Hz for rings 1–8 (Design's 392…196 retuned). Ring 9 has no bell (the point is silent). Each new inward depth writes Ring Crossed once (DescentState.enter). | G1-0512 G5-0171 G7-0198 G2-0473 G7-0024 · 02:851; 12:483, 926; 13:377-378, 895; 19:80, 84-86, 655; 04:758 | partial (chime 528×0.917^(r−1) when light off) · `Services/RingAudioService.swift:191-196; Views/Mandala/LivingMandalaView.swift:671-696` | RETUNE bell table; REUSE crossing detection + ledger |
| M36 | The fall speaks the mantra (RingBija) | With the light on, each inward crossing sounds the entered ring's bīja instead of the bell (Aim, Klīm, Sauḥ, Hrīm, Hsraim, Hsklhrīm, Hsauḥ, then Aim Klīm Sauḥ as three notes). Now also seen: the syllable rises faint (Cormorant italic 14, gold .5) at the ring's label for 1.6 s and fades. Pitch from the one tuning: carrier = root(r) × JUST[varṇa index of the bīja's first letter mod 12] × 2 (compound bīja → its first letter's place); vowel intervals kept for the second note (ai 5/4, au 5/3, i 3/2); duration 1.2 s × root₁/root. | G6-0821 G6-0876 G7-0970 · 17:478, 735; 22:578; 04:364 | built (sounded, never written) · `Services/RingBija.swift:16-141` | RETUNE to ring roots; ALLOW the syllable to be seen; update MandalaLightTests |
| M37 | Sound and zoom controls of the fall | Right 16, bottom 26 (46 px circles, 10 apart): ♪ ring sound (persists lr_sound, default off as Design; off shows '⁄'); + (×1.4), − (÷1.4), ⤢ the whole (fit). VoiceOver actions Fall in / Rise out / The whole yantra. Controls sit above the canvas z-order (the old z-order defect). Not shown on the held image. | G1-0511 G7-0020 G7-0021 G7-0015 G7-0628 G2-0327 · 02:847-849; 19:57, 70-73, 647, 654; 22:52-61; 04:525 | partial (two discs; no + − ⤢; sound default on) · `Views/Mandala/LivingMandalaView.swift:310-331` | NEW + − ⤢ column; SET default off |
| M38 | The interface thins with depth | Chrome opacity by depth 100 / 80 / 60 / 25 / 0 % as the fall deepens; after 3.8 s without touch the chrome sinks (0.6 s ease-out); any touch brings it back for 3.8 s. At 0% a faint 'surface' remains for VoiceOver and Esc. | G5-0153 G5-0172 · 12:451, 484, 928; 13:52, 272, 1020 | not · `—` | NEW |
| M39 | Colour warms with depth | The point's colour mixes gold #C9A84C at the surface → ember #C0392B at the centre by depth (color-mix gold (100 − depth·100)%). | G5-0397 · 13:52, 308, 870 | not · `—` | NEW |
| M40 | The point becomes the world (deep zoom to Home) | Ruling 9. Armed when scale < 2.8. At scale > 4.3 with the bindu within 64 px of the screen centre the bindu begins to swell, crimson filling outward as he keeps pinching; at the clamp (5.5) a further pinch is his choice and the crossing to Home plays: camera eases in .95 s to scale 5.4 with the bindu at .44h, Ring Crossed (9) is written, and Home's arrival (Lalitā's red bloom, owned by Home) takes over. Never automatic: the continued pinch is the chosen act (reconciles Design's auto-descent with 'never auto-advance'). Optional bed while falling: bindu/kingdom.mp3 ('the throne at the center of every kingdom is empty'), only when ♪ is on. | G1-0513 G5-0528 G7-0019 G7-0199 G2-0208 G2-0470 G4-0452 G5-0427 · 02:853-855; 13:892; 19:69, 656, 765; 04:324, 755; 09:712 | partial (descent built on tap; auto removed) · `Views/Mandala/LivingMandalaView.swift:615-629` | CHANGE trigger to continued pinch past 5.5 near centre; HAND OFF to Home |
| M41 | The annulus of attention | Inside the fall only the ring you are in is lit: lit band bandR·0.62…1.34, alpha .62 + .16·breath; centre wash rgba(hue, .10 + .05·breath) fading at 42%. The crossing flare is M30's flash (Design's 1.5 s is the floor; rupakarshini's 3.4 s ring-out R = 6 + easeOutCubic(q)·max(W,H)·0.62 at alpha .30(1−q)² follows it on the light-on path). | G5-0400 · 13:322-324, 886 | not · `—` | NEW |
| M42 | Ring-target framing (log-scale camera) | When the camera is sent to a ring (VoiceOver 'fall to', or a door from the menu landing inside the fall), it frames the enclosure at a constant share of the screen: enclosure radii [1.38, .93, .77, .62, .50, .39, .29, .20, .125, .06], R = min(W,H)·0.335, scale = exp(lerp(ln(R/BAND[i]), ln(R/BAND[j]), f−i)), breath scale·(1 + .010·breath) over 10 s. Also the yantra-walk: walked inward at constant size, only your ring lit. | G5-0056 G4-0703 · 12:302; 13:320-321, 885; 11:134-176 | partial (ringTarget halfway rule) · `MandalaCamera.ringTarget` | EXTEND ringTarget with log framing |
| M43 | Accessibility of the Mandala | One accessibility element per on-screen seat and enclosure in garland order; every target 44 pt; spoken labels IAST-romanised with no numerals ('Spar Shah kar shi nee. She who attracts Touch. Second enclosure, thirty-third of the one hundred and two.'); Lalitā hint 'Opens the source.'; Dynamic Type AX3XL without cuts; held yantra speaks 'The Śrī Yantra, held. Swipe up for the nine avaraṇas.' | G7-0096 G7-0097 G7-0643 G7-0646 G7-0684 G7-0671 G7-0685 · 19:326-336; 22:70-79, 98-103, 157, 216-217 | built (fall) · `Views/Mandala/MandalaAccessibilityLayer.swift; MandalaVoice.swift` | REUSE; ADD held-image and Veil labels |
| M44 | The world keeps its state | The Mandala world keeps camera, focus, Veil offset, tier and stillness alive while he is elsewhere; a menu visit or a crossing never rebuilds it. Back returns him to exactly where he was (spine). The 14-layer ZStack is cut to: sky · canvas · accessibility · gesture catcher · held image · header · controls · bloom · Veil. | G7-0009 G7-0014 G7-0084 · 19:43, 57, 539, 585-602 | wrong (menu visit rebuilds) · `Root/RootView.swift:69` | FIX: world state owned by router, not view lifetime |
| M45 | Launch arguments | Keep OPEN_SILENCE (→ Home now), OPEN_DETAIL=, OPEN_RING=; add OPEN_VEIL (sheet open), OPEN_FALL=<scale>, OPEN_HELD for the UI walk. | G7-0025 · 19:81 | built · `Views/Mandala/LivingMandalaView.swift:734-752` | EXTEND |
| M46 | The gift of one energy at an unknown hour | C-1353: a daily notification at a random time carrying one energy to appreciate (the Mandala's verb). Opening it lands in the fall, already flown to her seat with her name blooming (M34). Read with C-1337: the practice is two-way. | G3-0517 G3-0534 · 07:990-993, 1327 | not · `—` | NEW door (local notification, random time) |
| M47 | Person filter (door from the Relationship Field) | Arriving from a person in the Relationship Field, the fall opens with everything not theirs dimmed: opacity .12, grayscale .5, no touch, 350 ms; their seat(s) (Gaia kp 31, Ashrey kp 40, Ram kp 42 — ruling 11) and threads lit. | G5-0682 · 14:909, 983, 1092 | not · `—` | NEW |
| M48 | The yantra draws itself (construction, a second visit) | Hold two fingers on the held image 1.2 s: the yantra re-draws in its construction order — bhūpura, circles, petals, then the nine interlocking triangles (four up, five down) stroke by stroke (pathLength = 1 dashoffset, delays .018·i), each āvaraṇa's edges lit while the rest hush to .35; at the end it turns once in 80 s. The construction lenses Vesica Piscis, Phi and Metatron (Learning topics) sit as its readings in Beneath. | G4-0799 G5-0257 G5-1159 G5-1198 G5-1203 · 11:417-421, 590; 12:624, 907; 12:1544, 1583, 1588 | not · `—` | NEW |
| M49 | Arrival from Home: the yantra blooms out of the point | Crossing Home → Mandala: from the touch the yantra draws outward from the point (CentreBloom, Spanda's layers): scale .05 + .95·ease(p); trikoṇa fades in .06→.95, nine triangles .24→.82, 8-lotus .42→.62, 16-lotus .54→.85, bhūpura .66→.52, then the eyebrow; held image settles in 1.6 s. 'She breathes, and the worlds appear.' | G7-0965 G4-0618 G1-0724 G2-0422 · 22:573; 10:477, 651; 03:608-612; 04:686 | built (TheCentre bloom, as a hold) · `Views/Mandala/TheCentre.swift:143-168; Homes/TheBuilding.swift (CentreBloom)` | MOVE bloom to the Home→Mandala crossing |
| M50 | Visual language of the Mandala (mandala chassis) | Ground #0D0508 (house) with the held image on #060104 and the fall on indigo night; surface #1A0C10; veil #080307; silence #040104; ink #F2E8D9 (16.62:1); ink-2 #968D85; gold #C9963F; gold deep #A07830; gold bright #D4A017; warm #CF9443; crimson #8B1A2A / lit #A4343E; clusters #D4A017 · #C4725A · #2A7A7A · #4A7A5A · #7A5A9A; status .22/.44/.76/1; nine metabolisms; motes 16–30 s; names fade 1.4–1.8 s ease (.25,.1,.25,1). Cormorant Garamond Light (names 44–48, voice italic 18–20), system small caps. Mandala/Map colours win. | G5-0515 G5-0484 G1-0602 · 13:566-577, 769, 785-803, 866; 03:8 | partial (Color+Tokens.swift) · `Theme/Color+Tokens.swift` | COMPLETE chassis + OKLab mix helper |
| M51 | The Doorways — the Veil's wide face | Pinch apart on the open Veil: the nine rows regroup into the 3×3 Doorways — arched chambers (aspect .74, radius 40 40 8 8), where he stands and open ones lit from within (radial rgba(201,150,63,.14)→rgba(26,12,16,.6), inset gold), ahead ones dark behind a veil (rgba(10,4,8,.7) + scrim, blur .5 px); eyebrow 'The Nine Chambers', 'Lit doorways open · veiled ones wait' (every door opens — ruling 16). Pinch together returns the column. (The Descent column is the Veil; the Spine is the Climb's.) | G1-0690 G1-0694 G1-0696 · 03:417-423, 452-454, 460-462 | not · `—` | NEW |
| MX01 | Moved out: the 33 constellation | ChakraConstellationLayer (centre/Lalitā rings, presiding dashed breath, thread through seats, coronas, Shadow band of 14 stars, Armin garland of 33 beads, breath 11/6/15/8 s) and the 44 pt chakra buttons over Śakti seats leave the Mandala's canvas → THE 33 world (its own canvas). Nothing of the 33 is drawn on the held image or in the fall. | G7-0068 G7-0069 G7-0201 G7-0175 · 19:190-203, 604, 624-627, 726 | wrong (drawn into the canvas) · `Views/Mandala/ChakraConstellationLayer.swift; MandalaCanvasLayer.swift:74-76` | MOVE to the-33 |
| MX02 | Moved out: the Road | ChakraRoad camera path, Road words and the full-screen roadCatcher → THE 33 world ('a story told by a moving point', its own canvas). Its header rule 'never a second screen' is void. | G7-0071 G7-0075 G7-0202 G7-0176 · 19:215, 233, 605, 628, 727 | wrong · `Views/Mandala/ChakraRoad.swift; ChakraLayerOverlay.swift:131-284` | MOVE to the-33 |
| MX03 | Moved out: thresholds and 'Tat · Tvam · Asi' | The Shadow (3→4) and Armin (6→7) threshold moments, with 'Tat · Tvam · Asi' at centre −40, leave → THE 33 world, played when crossing between chakra spaces there; no Mandala pinch or Veil row queues them any more. | G7-0074 G7-0079 G7-0203 · 19:232, 606, 612, 622, 728, 774 | wrong · `Views/Mandala/MandalaThresholdMoment.swift; ChakraLayerOverlay.swift:99-109, 281-283` | MOVE to the-33 |
| MX04 | Moved out: chakra rooms | ChakraRoomView leaves the Mandala's covers → THE 33 world, with a back to the 33. | G7-0204 G7-0177 · 19:569, 720-738 | wrong · `ChakraRoomView via ChakraLayerOverlay:101-103` | MOVE to the-33 |
| MX05 | Moved out: Gates of Release | GatesOfReleaseLayer leaves the glass → each RING WORLD's arrival (offer) and leaving (receive) (R0-04). | G7-0205 · 19:730 | wrong · `Views/Mandala/GatesOfReleaseLayer.swift` | MOVE to rings |
| MX06 | Moved out: Tree of Life panels, breath arc, collective breath, luminance | TreeOfLifeRingLayer leaves the glass → each RING WORLD's arrival and dwelling (R0-06, R0-07, R0-08). | G7-0206 · 19:731 | wrong · `Views/Mandala/TreeOfLifeRingLayer.swift` | MOVE to rings |
| MX07 | Moved out: ring-world sound on the glass | MandalaFieldVoice's ring-7 chord on crossing 6→7 and ring-8 unite after 6 s stillness → RING 7 and RING 8 worlds' own recipes (R7-04, R8-03). The fall keeps only bell / bīja (M35, M36). | G7-0213 · 19:738 | wrong · `Views/Mandala/MandalaFieldVoice.swift:39-49` | MOVE to rings |
| MX08 | Moved out: Mauna, Pointy, Praveśa | TheCentre's Mauna (tap the point, or stillness at ring ≥ 7), StillnessAtTheCentre's Pointy and Praveśa → HOME (the Bindu) and BENEATH; Praveśa's fall is also RING 9's world (R9-03). | G7-0207 G7-0178 · 19:570, 732 | wrong · `Views/Mandala/TheCentre.swift; StillnessAtTheCentre.swift` | MOVE to home/beneath; R9 |
| MX09 | Moved out: Lalitā source | LalitaSourceView (zIndex 40) → HOME's arrival when the fall reaches the point (M40) or the point is held (M13). | G7-0208 G7-0179 · 19:571, 733 | wrong · `Views/Mandala/LalitaSourceView.swift` | MOVE to home |
| MX10 | Moved out: the Eight Dissolutions | TheEightDissolutions → A STRANGE GAME (the doorway into Leela; his limit 'once a day' stays). | G7-0209 · 19:734 | wrong · `Views/Mandala/TheEightDissolutions.swift` | MOVE to game |
| MX11 | Moved out: the Modes door | ModesDoorView via the ways ring → THE MODES world (reached by menu and its own doors). | G7-0210 G7-0173 · 19:565, 735 | wrong · `ModesDoorView` | MOVE to modes |
| MX12 | Moved out: the Climb door | ChakraRingClimb via the ways ring → THE CLIMB world; a Veil-or-menu door may open it at the ring where he stands (max(1, currentRing)). | G7-0211 G7-0174 G7-0027 · 19:90, 566, 736 | wrong · `Views/Mandala/LivingMandalaView.swift:211-214` | MOVE to climb |
| MX13 | Moved out: the ways-in ring | WaysIn (six ways sprung on a quarter arc r 150 from the mark, .35 dim, hanging like a dropdown) → retired; the SPINE's always-available menu and doors replace it. Its spoken labels are reused for the World Registry. 'At most three quiet controls' is lifted (ruling 10). | G7-0212 G7-0064 G7-0066 G7-0172 G7-0678 · 19:181-188, 564, 630-636, 737; 22:185-191 | wrong · `Views/Mandala/WaysIn.swift; LivingMandalaView.swift:340-366` | DELETE ring; REUSE labels in spine |
| MX14 | Cleared: the foot-of-glass pile-up | Gate words (bottom 112), threshold words (132), breath arc (170), Road words (92), peek (30) and centre 'Tat · Tvam · Asi' no longer stack: with MX01–MX07 gone the foot holds only the Veil peek. | G7-0082 · 19:266, 617-622 | wrong · `Views/Mandala/LivingMandalaView.swift:141-145` | REMOVE |
| MX15 | Cleared: one glass hosting seven worlds; two menus | LivingMandalaView no longer hosts Mandala + rings + 33 + Modes + Climb + Game + Home; RootView's second hamburger (top 16) above the ways mark is gone — one spine menu point. | G7-0026 G7-0067 · 19:82, 634, 720-738 | wrong · `Root/RootView.swift:73-77; Views/Mandala/LivingMandalaView.swift` | SPLIT views; ONE menu |

### 2B · THE NINE RINGS

| # | Element | What it does (mechanism + numbers) | Source (index ids · register) | Status today · code | Reuse / move / new |
|---|---|---|---|---|---|
| R0-01 | Each ring its own world | 'Each avaraṇa is not a sub-page. It is its own world — with its own geometry, light, breath rate, sound, and gravity. A practitioner who has entered Ring 4 knows it by feel.' (Design Codex). Nine worlds, nine verbs, each 'a complete small meditation', shown empty before any name is set inside. Crossing in through the point, blooming from the touch in the ring's colour (R0-02). The July ruling that folded them into zoom/Field rows is superseded by the foundation (12 Oct). C-1337: every energy an experience, a two-way practice; C-1205: the rings are widening circles of compassion; C-1119: light and dark the same. Each ring world meets the seven criteria: the interface is the teaching; an atmosphere riding tokens + one ring hue; its own breath (R1 holds); felt sub-structure without labels; sound behind a lower-left toggle, gesture-started; reverent copy; a still frame + an interactive frame. | G1-0641 G1-0776 G1-0698 G1-0773 G1-0322 G2-0438 G2-0196 G2-0302 G2-0053 G2-0209 G2-0063 G2-0119 G2-0066 G2-0375 G2-0390 G2-0164 G2-0411 G7-0013 G3-0505 G3-0418 G3-0375 G1-0050 G5-0562 · 03:140, 469-474, 920, 978; 04:114, 124, 132, 200, 262, 312, 325, 480-481, 611-612, 633, 723; 07:280-283, 495-498, 930-933; 01:149, 322; 19:56, 681; 14:203 | not (deleted 3244f54; LivingMandalaView says 'the nine ring-worlds are gone') · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingWorldView.swift (260) + Ring{One…Eight}WorldView, RingNineDescentView` | RESTORE from git into Views/Rings/; one RingWorldHost; remove header claim |
| R0-02 | Ring light: tokens and the colour rule | Ring hues (Mandala chassis, governing): 1 hsl(35 58% 54%) #CE9546 · 2 = cluster hue · 3 hsl(341 45% 58%) #C46482 · 4 hsl(353 55% 48%) #BE3747 · 5 hsl(18 62% 55%) #D37045 · 6 hsl(194 42% 46%) #4490A7 · 7 hsl(322 38% 50%) #B04F8C · 8 hsl(2 68% 50%) #D62F29 · 9 hsl(46 72% 66%) #E7CA6A. Per-world wash = mix(oklab, #0D0508 80%, ring 20%); deep = mix(#070205 88%, ring 12%). Gem diffusion bends light, never colours it (R0-13). Design's May ring-world palettes (R4 green #6FA37E, R5 gold #D4A017, R6 violet #9A86C4, R7 gold #E8C97A) give way to these where they differ — frame parity for F15–F25 is composition, mechanism and timing; hue by token. | G5-0516 G5-0484 G1-0042 G1-0462 G2-0238 G2-0448 G2-0087 G1-0111 G1-0624 · 13:566-577, 758-770, 866; 01:128, 321-336; 02:380-405; 04:158, 375, 733; 03:60-62 | partial (Atmosphere hues built) · `Theme/Atmosphere.swift; Theme/Color+Tokens.swift` | REUSE; ADD wash/deep mixes |
| R0-03 | Arriving: the threshold names itself | On entering a ring world, its threshold arrives line by line over the world's ground (staged, Living Rite timings): LrSigil 620 at 42% height, opacity .7, spinning (odd rings clockwise, even counter-clockwise; 140 + (hue mod 60) s per turn); motes 12. .20 s kicker '{Ordinal} Āvaraṇa · {form}' · .35 name (34 gold) · .50 subtitle italic 22 · .70 hairline · .80 his Personal Connection paragraph (italic 18.5, lh 1.62), word for word ('You have already been here.' / Ring 2 'You are here now.' / Ring 9 'You have always been here.') · .95 the appreciation phrase (gold italic 18) · 1.05 mental state · chakra · 1.15 shape · presiding form · yoginī (values without labels) · 1.25 'enter her ring' (h56, accent gradient, #0D0508 text 20). First-ever visit to a ring plays the slower v2 ceremony instead (t-lines at .3/1.1/1.8/2.4/3.0/3.6/4.2 s, Personal Connection at 5.6 s, the button at 6.4 s, ~7.8 s; 'The territory names itself. Then it says: you have already been here.'). Nothing is locked: the button is always the open style. Fix: the threshold opens THIS ring (openRing bug), one first-kp table (not two). | G1-0519 G1-0676 G7-0546 G7-0062 G2-0097 G1-0563 G1-0063 G1-0035 G1-0672 G1-0475 G1-0520 G7-0547 G1-0625 G2-0437 G1-0554 G1-0578 G2-0150 G2-0195 G2-0095 G5-0442 G6-0854 G6-0901 G1-0059 G1-0060 G1-0061 · 02:568-576, 909-935, 1289, 1360-1391, 1475; 03:291-301, 344-349, 63; 01:100, 149, 165-187; 04:166, 168, 243, 311, 722; 21:48; 13:467-468; 17:683, 760 | built (AvaranaThresholdView, Living Rite timings) · `Views/Common/AvaranaThresholdView.swift; Views/Common/TheHundredTwoView.swift:214` | REUSE as the ring world's arrival; ADD v2 first-visit timing; FIX openRing + one table |
| R0-04 | Gates of Release — offer on the way in, receive on the way out | At arrival, after the threshold: the gate offers the ring's mental state — 'hold to offer it' — a 76 pt hold ring (bottom 112) filled over 2.6 s; the state's words rise and the ring's mudrā is named as words (Ring 7: Khecharī); App Activity 'State Set Down' (offered, C-1230). Leaving outward (swipe down / outer door): the gate gives the ring's Siddhi — received, 'Siddhi Received' written. Each gate a two-way exchange that only ever gains. The gate stands for TheGates.offeredSeconds then recedes. (The Seven Gates descent becomes these nine gates.) | G7-0080 G2-0151 G7-0961 G6-0968 G2-0905 G3-0395 G7-0196 G7-1027 · 19:246-252, 730, 793; 04:244; 22:569, 640; 18:28; 05:3085-3088; 07:380-383 | built (on the Mandala glass) · `Views/Mandala/GatesOfReleaseLayer.swift:56-185; Homes/TheBuilding.swift (TheGates)` | MOVE into the ring world (arrival/leaving) |
| R0-05 | The presiding form named once | On arrival the presiding form appears once (italic 30, accentBright), then recedes after 2600 ms over 1.6 s: Tripurā, Tripureśī, Tripurasundarī, Tripuravāsinī, Tripuraśrī, Tripuramālinī, Tripurasiddhā, Tripurāmbā, Mahātripurasundarī. | G1-0545 G2-0219 · 02:1198-1199; 04:345 | partial (TreeOfLife names it 2.8 s) · `Views/Mandala/TreeOfLifeRingLayer.swift:66-71` | MOVE; SET 2.6 s + 1.6 s fade |
| R0-06 | The ring's declaration, verb and breath (Tree of Life grammar) | Then the ring's verb appears once (AGITATE, LIQUEFY, DRAW, OPEN, VOICE, STILL, WITNESS, SEED, ARRIVE) and its GameStructure panel declaration rises for max(8 s, one breath), fading over 2.4 s (top 150): 1 Press 'The earth that holds you was chosen by you.' · 2 Follow 'Every desire was drawing you toward yourself.' · 3 Build 'The fire that agitated you was building your form.' · 4 Open 'The love that arrived for others was always your own heart opening.' · 5 Speak 'What you finally said out loud was what you always knew.' · 6 Still 'You stopped looking and the seeing arrived on its own.' · 7 Receive 'The disease that was removed was the belief that you were less than what you are.' · 8 Hold 'Will. Knowledge. Action. You already know. You have always known.' · 9 Dissolve 'There was never anything to fear. There was only the Bindu, playing.' Guide words thin 1 → 0 by ring 7; a breath arc per ring (in / hold / out; release; forge; give; clear; see; wordless at 7; none at 8–9) at bottom 170; RingAnswer press .8/1.0/1.2/1.4/1.6 s rings 1–5, stillness 4/6/8 s rings 6–8, and at ring 9 the hold of Praveśa (C-1307 misread corrected: a held gesture is not 'action that attains'). The Om floor 136.1 Hz (partials 272.2 @ .30, 68.05 @ .15) at 0.004 + 0.026·d/9. Trinity faces speak once a day where seated: Sakshi at ring 7, Lalitā at ring 9. | G7-0081 G6-0829 G6-0893 G6-0793 G6-0830 G6-0941 G1-0599 G6-0832 G6-0895 · 19:254-266, 731, 794; 17:203, 548, 560, 570, 752, 754, 862; 02:1654-1661; 07:1324 | built (on the Mandala glass) · `Views/Mandala/TreeOfLifeRingLayer.swift; Services/TreeOfLife.swift; Services/TrinityOfGuidance.swift; Data/GameStructure.json` | MOVE into ring worlds; FIX TreeOfLife.swift:50 (ring 9 answer = Praveśa hold) |
| R0-07 | The ring's own breath (touch the empty field; hold for the collective) | Touch empty ground: the whole ring answers — a ripple 1.8 s (20 → 320 px) and every mark shimmers 1.4 s. Hold off any mark 2.6 s: the collective breath — every mark in the ring glows together for three beats on the ring's period, as its mudrā verb, privately (C-1274). | G1-0544 G2-0219 · 02:1195-1201; 04:345 | partial (collective breath on glass from ring 6) · `Views/Mandala/TreeOfLifeRingLayer.swift` | NEW ripple; MOVE collective breath |
| R0-08 | Light deepens ring by ring; legibility by Yoginī | Progressive luminance warm white round the centre: 5/10/18/28/40/55/75/90/100 % for rings 1–9. Yoginī legibility gradient (Prakaṭa obvious → Parāpararahasya barely): chrome and labels full at ring 1, none at ring 9 (Zero Gap), always ≥ 3:1 where text exists. RingWorld veil (0 → 1 by Yoginī) and tempo (1.00 .82 .62 .72 .66 .50 .44 .36 .28) condition each world. Sigil opacity per DayLight: threshold .7. | G2-0227 G1-0018 G2-0253 G6-0854 · 04:353, 403; 01:48-58; 17:548, 683 | built (TreeOfLife luminance; HomeWorlds) · `Services/TreeOfLife.swift:141-154; Homes/HomeWorlds.swift; Theme/DayLight.swift` | REUSE per world |
| R0-09 | The ghost of where you came from | FaintRingMemory: at each ring world's edges two squares ±180 (opacity ×1.2) and ±168, gold stroke .4 — the outer ground remembered; a far bindu at the centre. | G1-0700 · 03:478 | not · `—` | NEW (from ring-worlds.jsx) |
| R0-10 | Chrome of a ring world | Top: ReturnGesture arc 80×14 at top 56 (M8,11 Q40,3 72,11, stroke rgba(201,150,63,.32), width .7) — swipe down returns to where he came from (Veil row, menu, door). Under it a rail of nine 1 px ticks, his ring's tick lit (named by a sentence, never a number) and the RingGlyph. Lower-left sound toggle (bottom 50, left 22): 18 px circle, 4 px dot, the ring's sound word ('ground', 'home', 'longing', 'lineage', 'overflow', 'within', 'syllables', 'three', 'tone') or 'silent' (8 px .22 .22em). The spine's point and menu stay present. | G1-0701 G1-0608 G7-0195 G5-0403 · 03:35, 479-480; 19:695; 13:336, 939 | not · `—` | NEW |
| R0-11 | Ring sound: one tuning, one technique per ring | Ring roots (the one tuning, Design's): 55.00 · 61.74 · 69.30 · 73.42 · 82.41 · 92.50 · 98.00 · 110.00 · 123.47 Hz. Ground technique per ring (gesture-started, quiet, stoppable, gain .05–.07): 1 drone sine f + sine 1.0035f (.8) + triangle 2f (.16) · 2 breath sine f + 1.5f (.3), .14 Hz LFO on amplitude depth .55 · 3, 6 breathy sine f (.7) + saw 1.002f (.1) + saw 2.01f (.05), bandpass 4f Q 1.6 · 4, 5 stepped f×[1, 9/8, 5/4, 3/2] every 5.2 s (4) / 3.4 s (5) + sine f/2 (.4) · 7 sourceless sines 2f (.42), 3f (.26), 5f (.14), no fundamental · 8 triad f (.7), 1.26f (.6), 1.5f (.6), upper two glide to f every 14 s (tc 3.4 s) · 9 Shepard (R9-05). Each world's event voices sit at root × 2 with Design's intervals. 'The pitch is ours, the interval is the entity's.' No Hz is ever assigned to a Śakti except through her bīja's interval on her ring's root. One engine (AVAudioEngine) unifies RingAudioService and HomeSoundService roots (C-11). | G1-0025 G1-0277 G1-0280 G2-0073 G5-0417 G6-0814 G6-0815 G6-0872 G6-0939 G7-0967 G7-0968 G7-0098 G1-0702 G2-0340 G1-0330 G4-0336 G6-0819 · 01:87, 128, 634, 639-648, 796-805; 03:482-485; 04:139, 550; 13:381-382, 894; 17:410, 434, 467, 731, 855; 19:338-344; 22:575-576; 09:172, 612, 702 | partial (two tunings in code) · `Services/RingAudioService.swift; Services/RingFieldVoice.swift; Services/HomeSoundService.swift:82` | UNIFY on HomeCarrier.roots; REUSE voices |
| R0-12 | Each world runs on its real clock | World clocks from the device's real date (Ephemeris): 1 day–night · 2 the hour · 3 the day · 4 lunar fortnight · 5 lunar month · 6 season · 7 solar half-year · 8 year · 9 kāla–akāla (still). Multiplied by the ring's tempo — the world's clock only, never her adaptation clock. 'The day–night cycle turns in seconds' was the prototype; here the hour is the hour. | G1-0051 G1-0110 G1-0326 G6-0961 G7-0949 G7-0950 G7-0951 G7-0952 G7-0953 G7-0954 G7-0955 G7-0956 G7-0957 G7-0697 · 01:58, 150, 316, 781; 18:21; 22:269-291, 564-565 | partial (HomeWorlds worldClock; symbolic in prototype) · `Homes/HomeWorlds.swift:325-328; Services/LunarPhaseService.swift` | REUSE; FEED real phases |
| R0-13 | Going deeper: stand in the ring's weather | From inside a ring world, pinch apart (or 'the weather' door at the foot) and the flat world gives way to its 3D weather, the same band the Climb passes through, here alone and still: 1 low raking topaz sun over 11 standing stones · 2 blood-warm ring waves through cold sapphire (systole^6) · 3 the 2,600-point coral churn · 4 three caustic spectra over glossy floor + diamond prism · 5 72-rib bone colonnade, 24 shafts · 6 nine marrow-lit translucent bodies · 7 sourceless milk fog, zero directional light, 150 motes · 8 one travelling cat's-eye band · 9 nine orbiting gem lamps round a yantra, 220 motes. Fog colour/density per WORLDS (1 #1d1206 .0125 … 9 #141008 .009) × (1 + veil·.55). The weather sentence rises once, verbatim ('low light raking a vast floor, swinging horizon to horizon' … 'every gem at once, which is the same as no weather at all'). Then, held still, the ring's facts arrive one beat at a time (3 s each): its full name and epithet ('Trailokya Mohana — Enchanter of the Three Worlds'), presiding form, Yoginī, mental state, the goddess's body at this ring ('her feet', 'her Svadhisthana chakra', 'her navel region'), gem · dhātu · clock · bīja · Siddhi · mudrā. Further stillness opens the Learning record's stations (L-1537: element, body location, roots of the name, quality, phrase), read-only. | G1-0098 G1-0099 G1-0100 G1-0101 G1-0102 G1-0103 G1-0104 G1-0105 G1-0106 G1-0107 G1-0108 G1-0109 G5-0441 G2-0284 G1-0320 G1-0310 G1-0017 G2-0252 G6-0590 G6-0510 G6-0511 G6-0512 G6-0513 G6-0514 G6-0515 G6-0516 G6-0517 G6-0518 G6-0519 G6-0790 G6-0900 G6-0795 G5-0305 G2-0230 G2-0237 G2-0217 G1-0041 G1-0537 G1-0062 G5-0328 G6-0003 G6-0010 G6-0017 G6-0024 G6-0031 G6-0038 G6-0045 G6-0052 G6-0059 G6-0067 G6-0075 G6-0083 G6-0091 G6-0099 G6-0107 G6-0115 G6-0123 G6-0131 G6-0139 G6-0147 G6-0155 G6-0162 G6-0169 G6-0176 G6-0183 G6-0190 G6-0197 G6-0204 G6-0211 G6-0218 G6-0225 G6-0232 G6-0239 · 01:46, 116-127, 270-316, 726, 742; 13:454-456, 893; 04:343, 361, 374, 402, 439; 15:344-359, 1421; 17:178, 272, 759; 12:897 | partial (WorldBands/RoomAir built for the Climb; facts in RingFactsCache) · `Homes/Render/WorldBands.swift; Homes/Render/RoomAir.swift (BandAir); Data/RingFactsCache.swift` | REUSE bands as a standalone scene per ring; BAKE Shakti Function facts |
| R0-14 | Doors inside a ring world | Touch a mark (her seat) → crossing to Her Home (her room), from where he stands, no full-screen swap. Arrows / edge swipes step to the neighbouring ring world (G43: fade out .28 s, swap, fade in .4 s; input ignored while fading). Within a ring: Ring 1 doors within her family, Ring 2 within her cluster, then ±1. Swipe down → back to where he came from. The point → Home. | G4-0767 G6-1066 · 11:317; 18:144 | not · `—` | NEW via router |
| R0-15 | Every energy reachable | Shared enum Hit { min = 44 }; nearest-mark resolution; no overlaps; no dead renders; reduce-motion aware (static frame + same words); rAF-style continuous motion via TimelineView. Done-when per ring (reused from MBB-05): R9 ends in silence; twelve Vāk legible; every R1 light hit first try; R6 names reliably; R3 plume visibly glows. | G1-0575 G2-0132 G2-0182 G2-0143 G2-0075 · 02:1472; 04:141, 218, 236, 285 | not · `—` | NEW Hit enum; UI tests |
| R0-16 | Another map's nine (a lens) | On the threshold, a two-finger tap turns the lens: each ring also carries the Nine Dimensions as he describes them — numeral and gloss, labelled 'as he describes it' (1 Unity 'I know that I am.' … 6 Creation 'twelve rays, the seven laws, the three essences' · 7 Enlightenment 'The lost face' … 9 The Void 'I know what I am.'; 'Nine closes the circle that one opened.'). The nine-rings corridor exemplar gives its line: 'You do not go there. You widen here.' (scale ramp .92 → 2.3, live ring stroke 1.8, glow 7 at .16). | G5-0276 G4-0787 G5-0253 · 12:620, 712-725, 900, 957; 11:387-392, 588 | not · `—` | NEW |
| R0-17 | Elements of the rings (ruling 4) | 1 earth · 2 per Śakti tattva with ruling 4 (Ahaṅ fire, Nāma air, Ātma light, Amṛta water; Citta ether) · 3 air · 4 water · 5 fire · 6 ether · 7 air · 8 fire · 9 light. Element.parse gains a 'light' branch. The element shapes the ground voice's gain/beat envelope over a dwell (earth one descent; fire two blazes; air three inhales; light twice, eye open; water three waves) with its one-line caption ('Two fires with one breath between them' …). | G1-0463 G6-0856 G4-0587 G4-0625 · 02:407-440; 17:694; 10:462, 503 | wrong (Ahaṅ/Nāma/Ātmā/Amṛta → ether; no light) · `Theme/Element.swift:12-36` | FIX per ruling 4; NEW envelopes |
| R0-18 | Awakening tones at the door (pending his word) | The nine Awakening Sounds (174 Hz percussive sub-bass drum · 210 warm wooden bell · 320 metallic gong · 341 crystal bowl 3.5 s · 384 singing bowl · 426 shimmer with 1.5 Hz twin · 480 distant bell · 528 three detuned voices · P9 silence) as the strike that opens each ring world, ring n ↔ panel Pn as PlayTests already maps. Held behind his ruling (question 1, §7): they carry their own Hz outside the one tuning. | G6-0687 G6-0688 G6-0689 G6-0690 G6-0691 G6-0692 G6-0693 G6-0694 G6-0695 G6-0747 G6-0775 G7-0971 · 16:206-214, 298, 341; 22:579 | built (as a tuning game) · `Bindu MandalaTests/PlayTests.swift:381` | HOLD for ruling |
| R1-01 | Ring 1 · the Earth-City — world | Trailokyamohana · Bhūpura · 28 forces in three families on three nested squares ('The three families ARE the three nested squares'). Verb: meet · illumine · ignite · release (signature AGITATE). Ground: bg #0C0703 → #080402 → #060301, ambient rgba(207,148,67,.11), DustMotes 9, ReturnArc rgba(207,148,67,.34); identity 'Trailokyamohana · the Earth-City' + '28 FORCES · THE OUTER GROUND'. Light: warm amber, still; the ground does not breathe. Weather: raked topaz floor. | G1-0611 G1-0642 G1-0711 G2-0067 G7-0186 G2-0423 G2-0424 G2-0425 · 03:44, 143, 549-550; 04:133, 687-689; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingOneWorldView.swift (672)` | RESTORE |
| R1-02 | Ring 1 · geometry and lights | Centre (195,348). Squares half 150 (Siddhi, outer, 10), 110 (Mātṛkā, middle, 8), 72 (Mudrā, inner, 10), stroke .8; opacity .24 idle / .52 focused / .07 others / .5 all lit. Inner circles r46, r32; far bindu r3.4 accentRed (9 s). Four T-gates on the outer square (stem 18 + lintel ±15), embers r2.4 breathing 5.5 s. 28 lights at (i+.5)/n round each perimeter from top-left clockwise: idle .52 r2.8; family .92 r3.6; non-family .10; all lit .96 r3.4; met 1.0 r5.4 + expanding ring 2.6 s (scale 1→4.2, .8→0) + cream core. Hit 44 pt with nearest-light resolution (Design 13 and the old 26 both below the floor). | G1-0712 G2-0133 G1-0710 · 03:546, 550; 04:219 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingOneWorldView.swift` | RESTORE; FIX hit |
| R1-03 | Ring 1 · words | Default: 'The ground you have walked, before you knew it was hers.' Meet a light: her name 40 + '{Family} · {english}' + her one line 19 italic (the 28 R1_QUALITY lines, e.g. 'the rooting tongue — speech that digs into the earth of meaning'; where the app roster and the cards differ the Airtable card's name and the Map's gloss win — 'Laghima (weightless)', 'Varahi (obstinacy as ground-holding)'). Illumine a family (legend at bottom 82): label 34 + english + the lived line 16.5 italic — Siddhi 'Ten powers of accomplishment. You have known these as work …', Mātṛkā 'Eight mothers — language itself. … The world was spoken before it was seen.', Mudrā 'Ten seals — the gestures of the body. … Matter became sacred in the moving.' Ignite a gate: all 28 alight + 'Thank you for the world I have walked through without knowing it was you.' + 'THE WHOLE GROUND, ALIGHT'. Hint 'tap a light to meet her · a gate to let the world in'. | G1-0713 G1-0714 G1-0715 G6-0520 G2-0243 G2-0426 G1-0054 G6-0509 · 03:551-561; 15:342, 359-367; 04:385, 690; 01:144, 156 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingOneWorldView.swift` | RESTORE; JOIN Map glosses |
| R1-04 | Ring 1 · the family question | When a family is illumined, its question rises once (italic 18): Siddhi 'which of the 10 Siddhis is latent in me right now?' · Mātṛkā 'Which of the 8 Matrikas is visiting you right now' · Mudrā 'Which of the 10 Mudra Shaktis is your body forming right now'. Touch the one that feels present: her light meets and her gloss opens. | G6-0589 · 15:1420 | not · `—` | NEW (bake Shakti Function) |
| R1-05 | Ring 1 · sound and touch | Ground drone (technique 1) on root 55 Hz; the world's drone shape (root + fifth: 55 + 82.41 Hz, gain .4 inside, master fades 0 → .05 over 2.2 s, LFO .07 Hz depth .018 'the world turning, almost still') starts with the first touch; toggle 'ground' / 'silent'. A crawling haptic for earth (C-1170) under a met light. | G2-0227 · 03:558-561; 04:353 | partial (field voice 73.42 + 110) · `Services/RingAudioService.swift:79-107` | RETUNE to root 55 |
| R2-01 | Ring 2 · the Inhabited Lotus — world | Sarvāśāparipūraka · the Sixteen · the home ring ('wide, generous, with room between everything'). Verb: press to invoke (LIQUEFY). Ground #0A0608 → #060104 → #050103, radial gold .10, DustMotes 10, FaintRingMemory .05; identity at top 92 'Sarvāśā-Paripūraka · the Sixteen'. Lotus centre (195,430), oR 172, iR 96, hw 32; names r138 italic 10 → 12 pt (legibility). Inner memory: 4 triangle pairs r80/65/50/36 at .08 (.04 while invoking). Today's halo blur 11 px .42. Bindu r10 accentRed breathing r 9;12;9 over 4.5 s. Petals breathe 3 s in a wave (today 3.5 s), status light .22/.44/.76/1. | G1-0703 G1-0612 G1-0643 G2-0076 G7-0187 G2-0427 G2-0428 G2-0394 · 03:45, 144, 469-474, 487-492; 04:142, 648, 691-692; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingTwoWorldView.swift (499)` | RESTORE |
| R2-02 | Ring 2 · invoke her | Press and hold a petal: she rises, the others mute to ×0.18, the home voice swells .045 → .075; over her: name 34 (.3 s), bīja 26 italic gold (.9 s), quality 16 italic (1.5 s), 'release · she remains' (2.4 s), each fading up 1.4 s. Release: she remains 2600 ms, then settles. Idle hint 'press a petal to invoke her presence'. Tap (not hold) her name → Her Home. | G2-0099 · 03:487-492; 04:170 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingTwoWorldView.swift` | RESTORE |
| R2-03 | Ring 2 · the lotus follows the sun | Device local time sets openFactor: dawn .78 ('Dawn · the petals open', bg #0F0810 → #080406, op .85) · noon 1.0 ('Noon · the lotus is full') · dusk .85 ('Dusk · the petals fold', #0C0508 → #06010A, .82) · night .45 ('Night · the lotus rests', #020108 → #010104, .40, bindu .95). oR = 172·openFactor, hw = 32·(.7 + .3·openFactor), transitions 1 s. 'Within a ring-world, time has texture.' | G1-0704 G7-0346 · 03:494-501; 20:407-413 | partial (Climb's ring 2 follows the sun) · `Views/Rooms/WorldClimbView.swift` | RESTORE in the world |
| R2-04 | Ring 2 · cluster light and bījas | Cluster colours (DS-04, confirmed by F01/F34): inner instrument #D4A017 (29–31), tanmātra #C4725A (32–36), citta #2A7A7A (37), stability #4A7A5A (38–41), self·body·immortality #7A5A9A (42–44); petal 0 at 12 o'clock clockwise. Bījas from the cards: 29 aṃ … 37 ḷṃ, 38 ḹṃ, 39 eṃ, 40 aiṃ, 41 oṃ, 42 auṃ, 43 aṃ, 44 aḥ (DS-09's set is superseded). | G2-0005 G2-0445 G2-0057 G6-0799 G2-0244 G2-0446 G2-0010 G2-0011 · 04:56, 61-62, 118, 386, 730-731; 17:316 | built (Cluster.swift) · `Models/Cluster.swift` | REUSE |
| R2-05 | Ring 2 · Tripureśī, the whole ring | Tripureśī has no seat: she is the ring. Hold off the petals 2.6 s (R0-07): all sixteen glow together for three beats and one line rises: 'The heart draws. The crown reveals who was drawing.' | G6-0591 · 15:1422 | not · `—` | NEW |
| R2-06 | Ring 2 · the sixteen functions circulating | Going deeper in Ring 2 (second visit): one sentence travels round the sixteen petals hop by hop (map--circulation), each petal saying what it draws — the 16 Karṣiṇī Functions (ruling 7, drafted by Claude) with the Learning record L-1533 as a second voice under each name, never replacing the Mandala table's text. | G4-0861 G5-0306 G4-0706 G5-1029 · 11:134-176, 598; 12:898, 1414 | not · `—` | NEW |
| R2-07 | Ring 2 · sound | Ground: home breath (technique 2) on root 61.74 Hz. Home voice at root×2 = 123.48 Hz + fifth 185.22 Hz, LFO .18 Hz depth .02 ('slow breath'), master .045 (tc .6), → .075 while pressing; toggle 'home'. | G1-0702 · 03:482-485 | partial (130.81 + 196) · `Services/RingAudioService.swift:111-137` | RETUNE |
| R3-01 | Ring 3 · the Smoke Lotus — world | Sarvasaṅkṣobhaṇa · the Anaṅgas · 'EIGHT FORMS · ONE BODILESS LONGING' (verb DRAW). Ground #160A0C → #0A0406 → #060103, overlay ring-3 wash at .13; centre (195,392). Eight plumes w3Petal(116, 30, 52), gradient light .9 → ring hue .5 → crimson 0, blur 5.5 (10 while moving) — 'soft plumes, no crisp edges'; r3-smoke 8 s, delays i×.7. Seed 54 px 'hsauṁ' Cormorant 22 italic. DustMotes 7. 'You feel her without quite seeing her.' | G1-0717 G1-0613 G1-0644 G2-0068 G7-0188 G2-0412 G2-0413 · 03:46, 145, 564-573; 04:134, 676-677; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingThreeWorldView.swift (449)` | RESTORE; FIX port regressions |
| R3-02 | Ring 3 · stillness gathers, reaching scatters | Finger movement marks 'moving' for 800 ms: plumes drift 24 px, scale 1.18, opacity .18, brightness .78 — 'The more you reach for her, the more she thins.' Still: opacity .66, brightness 1.05 — 'Be still — and the bodiless longing gathers.' Glow ladder active 1.0 / unified .9 / gathered .55 / scattered .30, blend screen (port regressions: brightness .15 vs 1.5, missing motes, gradient end 92 vs 116, fixed). Touch a plume: she names herself in italics (name 36 + quality) and dissolves back (active 1.06/1/1.5, others .22; sustain .06 → .03 after 1400 ms). Touch the seed: all eight unify 2600 ms (.92/1.35) — 'Eight forms, one longing. The desire that arrives without a body.' Stillness here governs arrival only (allowed). | G2-0134 G2-0414 G2-0456 · 03:568-573; 04:220, 678, 741 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingThreeWorldView.swift` | RESTORE + FIX |
| R3-03 | Ring 3 · sound | Ground breathy (technique 3) on root 69.30. 'longing' sustain at root×2 = 138.60 Hz, vol .045, vibrato 6 Hz (Design 116.5); the seed sounds all eight together (synthesised, no voice). Toggle 'longing'. | 03:573 | partial (116.5 Hz field voice) · `Services/RingAudioService.swift:144-170` | RETUNE |
| R4-01 | Ring 4 · the Lineage — world | Sarvasaubhāgyadāyaka · the Sampradāya · 'FOURTEEN · THE TEACHING TRAVELS THE LINE' (verb OPEN). Ground: deep mix of ring 4 (Design's green yields to the token); 14 alternating triangles on r150 round (195,396); garland of quadratic curves, control at 84% radius ('bow inward'); a travelling light r17 + cream core r4.2. Atmosphere 'cooler, sharper, more angular … geometry as direct revelation'; breath 9 s. | G1-0718 G1-0614 G1-0645 G2-0069 G7-0189 G2-0408 G2-0409 G2-0410 · 03:47, 146, 575-581; 04:135, 672-674; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingFourWorldView.swift (387)` | RESTORE |
| R4-02 | Ring 4 · the teaching travels | transmit(): one station per 340 ms; after fourteen the garland is fully lit; it starts by itself 900 ms after arrival (the world's weather, not his path advancing). Touch the centre to send it again; touch a station to read it: name 34 + gloss + 'THE {ordinal} OF FOURTEEN · RECEIVED, AND PASSED ON' (her place in the garland, in words). Glosses: the stirring, the scattering, the drawing, the gladdening, the enchanting, the stilling, the opening, the mastering, the colouring, the maddening, the accomplishing, the fulfilling, made of mantra, the perfecting. Full: 'The garland is unbroken — every name still passed, hand to hand.' Default: 'The teaching travels the line — teacher to student, across the generations.' | G2-0415 G2-0416 · 03:575-581; 04:679-680 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingFourWorldView.swift` | RESTORE |
| R4-03 | Ring 4 · sound | Ground stepped (technique 4) on root 73.42, a step every 5.2 s. 'lineage' tone rising with the light: root×2 = 146.84 Hz × 2^(i/24), i = 0…13. | 03:581 | partial (stepped via playVakBija) · `Services/RingFieldVoice.swift:70-81` | RETUNE |
| R5-01 | Ring 5 · the Overflow — world | Sarvārthasādhaka · the Kulottīrṇas · 'TEN · OVERFLOWING WHAT CONTAINS THEM' (verb VOICE). Kula circle r142; ten up-triangles r13 on r116; rays r106 → r212 width 6, gradient cream → ring hue, r5-ray .28 → .85 over 2.6 s. Breath 11 s steady ('less catching, more witnessing the work being done'). | G1-0719 G1-0615 G1-0646 G2-0070 G7-0190 · 03:48, 147, 583-587; 04:136; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingFiveWorldView.swift (350)` | RESTORE |
| R5-02 | Ring 5 · overflow and flood | Touch one triangle: her rays spill past the circle (name 34 + gloss: grants attainment, grants abundance, makes beloved, the auspicious one, grants every desire, the liberator, conqueror of death, remover of obstacles, beauty in all limbs, grantor of grace). Touch the centre: all ten flood, the boundary dissolves to dashes (2 8 at .12) — 'The accomplishment overflows the one who sought it.' + 'THE BOUNDARY CANNOT HOLD HER'. Default 'Ten forces the circle was meant to hold — and cannot.' Hint 'touch one to overflow · the center to transcend the kula'. | G2-0417 · 03:583-587; 04:681 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingFiveWorldView.swift` | RESTORE |
| R5-03 | Ring 5 · sound | Ground stepped (technique 5) on root 82.41, step every 3.4 s. Touch: root×2 = 164.82 Hz for 1.8 s; flood: four notes 164.82 × [1, 16/15, 9/8, 6/5] staggered 90 ms (Design's semitone cluster in the one tuning). Toggle 'overflow'. | 03:587 | partial · `Services/RingFieldVoice.swift:70-81` | RETUNE |
| R6-01 | Ring 6 · the Concealed — world | Sarvarakṣākara · the Nigarbhas · 'TEN · CONCEALED, TOO INTERIOR TO BE SPOKEN' (verb STILL). Ground near-black with the ring's deep mix; ten alternating triangles r11 on an orbit widened from 96 to 120 (repair). 'The most introspective of the rings — narrow, deep, the geometry feels held.' Breath 13 s. | G1-0720 G1-0616 G1-0647 G2-0071 G7-0191 G2-0135 · 03:49, 148, 589-594; 04:137, 221; 19:683-693 | not (deleted) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingSixWorldView.swift (344)` | RESTORE; widen orbit |
| R6-02 | Ring 6 · the light that reveals only what is near (G9) | A light (radial 193 px, i.e. 2.1×92) follows the finger with .18 s lag. Each mark's opacity = max(0, 1 − d/92) × .85; touch names her only when the light has reached her (any reach > .3, 44 pt — the repair of three stacked precision tests): her name whispers in — blur-in, hold to 72%, blur-out over 3.2 s — 'she will not stay'. Glosses: made of knowing, made of power, sovereign splendour, giver of knowledge, remover of disease, the support of all, remover of sorrow, made of bliss, the protectress, giver of the fruit. Default 'What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near.' Hint 'move the light · touch what it reaches · she will not stay'. A heart glow .38 → .7 over 6 s. | G4-0733 G2-0418 G7-0342 · 03:589-594, 546; 11:283; 04:682; 20:407-413 | partial (Climb ring 6 whispers) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingSixWorldView.swift; Views/Rooms/WorldClimbView.swift` | RESTORE + RELAX gate |
| R6-03 | Ring 6 · sound | Ground breathy on root 92.50. 'within' sustain at root×2 = 185.00 Hz, gain .05·(1 − d/92) as the light nears a mark, else .004. Toggle 'within'. | 03:594 | partial (207.65 Hz) · `Services/RingAudioService.swift:144-170` | RETUNE |
| R7-01 | Ring 7 · the Vāk Chamber — world | Sarvarogahara · 'sound that heals' (verb WITNESS; 'the world where language and life have not yet separated'). Ground #0E0703 → #0A0502 → #060301 with the ring-7 wash (wine) at .16; strokes gold-bright #E8C97A at .12; four triangle pairs; dashed circles r50 and r62; identity 'Sarvarogahara · the Vāk Chamber'. Twelve nodes 44 px at 30° steps on r140, clockwise from 12; bīja 18 px italic, name 12 pt; centre chord disc 60 px. Breath 15 s with a tone pulse. Mudrā Khecharī (named at the gate). Legibility: the twelve at 30° never overlap (the 45° defect). | G1-0705 G1-0617 G1-0648 G2-0077 G2-0136 G7-0192 G2-0419 G1-0623 · 03:50, 149, 503-520, 59; 04:143, 222, 683; 19:683-693 | partial (only the chord on crossing) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingSevenWorldView.swift (385)` | RESTORE; RENAME voices; RETUNE |
| R7-02 | Ring 7 · the twelve voices carry the Airtable names | Clockwise from 12 o'clock (the Mandala table, kp 87–98; twelve makes the khaḍgamālā 102): 87 Vasinī — Aṃ · 88 Kāmeśī — Kaṃ · 89 Modinī — Caṃ · 90 Vimalā — Ṭaṃ · 91 Aruṇā — Taṃ · 92 Jayinī — Paṃ · 93 Sarveśī — Yaṃ · 94 Kaulinī — Śaṃ · 95 Bāṇinī · 96 Cāpinī · 97 Pāśinī · 98 Aṅkuśinī (the four Weapons carry no bīja: their node shows the name alone and they strike rather than sound). Design's set (Vāśinī … Vāṅmayī, Onmādinī, Mantreśī, Śaktimayī with aṁ…aḥ) is replaced. Kāmeśī (88) is never confused with Kāmeśvarī (99). | G2-0246 G2-0447 G1-0049 G2-0213 · 04:334, 390, 732; 01:147, 660 | wrong (Design names, 220…659.25 Hz) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingSevenWorldView.swift:36-48` | REPLACE table from Airtable (kp 87–98) |
| R7-03 | Ring 7 · tuning of the twelve (one tuning) | Ring 7 root 98.00 Hz; carrier = root × JUST[varṇa index mod 12] × 2 (Homes rule): Vasinī Aṃ 196.00 · Kāmeśī Kaṃ 245.00 · Modinī Caṃ 326.67 · Vimalā Ṭaṃ 220.50 · Aruṇā Taṃ 294.00 · Jayinī Paṃ 196.00 · Sarveśī Yaṃ 261.33 · Kaulinī Śaṃ 326.67 · the Weapons at the bare root 98.00, struck [1, 1.5, 2]. Voice technique sourceless (the ring's): partials 2f (.42), 3f (.26), 5f (.14), no fundamental. The two coincident pairs (Vasinī/Jayinī, Modinī/Kaulinī) part in space: pan = .6·sin θ of the node's angle. | G1-0025 · 01:636, 660; 22:262-264 | wrong (invented scale) · `Services/BijaSoundService.swift:161-256` | NEW voice table |
| R7-04 | Ring 7 · strike one, strike all, the word that heals | Touch a node: strikeOne — 2.6 s at gain .11 (attack .15 s, ×.85 at .7 dur), three sound rings r20 around THAT node (the cx bug fixed), delays 0/.3/.6 s, scale .4 → 3.0, .85 → 0 over 1.6 s; caption her name; clears after 2400 ms. Touch the centre: strikeChord — all twelve, staggered i×55 ms, 3.2 s each at .05; four cream rings r30, delays i×.2 s, scale .3 → 4.5 over 2.4 s; 'the full chord — all twelve at once'; clears 3400 ms. Once seven distinct voices have sounded in this visit, the word arrives: 'The word that healed what the mind could not reach.' (17 px .78) + 'she who removes all disease' — the threshold felt, never shown (the '{n} of 12 voices sounded' counter is not drawn). Default 'tap a syllable · tap center for the chord'. | G1-0706 G1-0707 · 03:521-525 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingSevenWorldView.swift` | RESTORE; FIX ring centre; DROP counter |
| R7-05 | Ring 7 · the screen resonates | A soft haptic transient on every 15 s breath peak; a continuous haptic (intensity .3) under the chord; the barely-audible bīja tone of the ring (Hsauḥ carrier) under everything at gain .01 (Codex: 'The screen actually resonates'). | G1-0648 · 03:149 | not · `Theme/Haptics.swift` | NEW (Core Haptics) |
| R7-06 | Ring 7 · Tripura Siddhāmbā, the whole ring; the Sakshi line | Hold off the nodes 2.6 s: all twelve glow together for three beats (Tripura Siddhāmbā, 'Destroyer of Poison', has no seat — she is the ring). Once a day on arrival the Sakshi face speaks its one line in its light (0.70, 0.80, 0.95) for 7.5 s. | G6-0591 · 15:1422; 17:570 | partial (Trinity Sakshi at ring 7 on the glass) · `Services/TrinityOfGuidance.swift` | MOVE |
| R7-07 | Ring 7 · doors to the Mind | Hold a Vāsinī's node 1.2 s: a door opens to her mind chakra in the 33 (Vasinī → Inception, Kāmeśī → Intention, Modinī → Inspiration, Vimalā → Insight, Aruṇā → Intuition, Jayinī → Invention, Sarveśī → Incarnation, Kaulinī → Innocence; the ring itself → Integration), the Mind walked in the Map's own sequence (ruling 13). | G6-0528 G6-0583 · 15:406-424, 1403 | not · `—` | NEW door |
| R8-01 | Ring 8 · the Mūla Trikoṇa — world | Sarvasiddhiprada · 'three points. Three were never three. The simplicity is the teaching.' (verb SEED). Pure cream on black: bg radial #0A0608 → #020001; triangle centre (195,330), R 132: apex Icchā — Will — 'the wanting before want has an object' #C45050; bottom-left Jñāna — Knowledge — 'the knowing before knowledge has content' #9A8FC4; bottom-right Kriyā — Action — 'the doing before doing has direction' #5A9A8B. rw8-triangle opacity .78 → .95 + drop-shadow 10 px rgba(242,232,217,.35) over 18 s ('almost still'). Under each power, her seat from the cards: Icchā · Kāmeśvarī (99, Aim) · Kriyā · Vajreśī (100, Klīm) · Jñāna · Bhagamālinī (101, Sauḥ). Resting words 'The root triangle. / Will, knowledge, action — / one undivided power.' + 'TAP A VERTEX'. | G1-0708 G1-0618 G1-0649 G2-0078 G7-0193 G2-0420 G2-0395 G1-0065 · 03:51, 150, 527-535, 475; 04:144, 649, 684; 01:188 | partial (triad unites on stillness) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingEightWorldView.swift (450)` | RESTORE; ADD seat names |
| R8-02 | Ring 8 · the teaching arc | State machine triangle → (touch a vertex) Icchā \| Jñāna \| Kriyā → (touch) dissolved → (touch) triangle. Collapsed: dashed lines to the chosen vertex, the others .22, her name HUGE 76 px italic in her colour, gloss, hint 'the other two have collapsed in · tap to dissolve' (rw8-collapse .9 s). Dissolved: a bindu at the centroid swells r7 → 52 (.7 → .92) with cream r3 → 20 over 1.4 s; 'The three were never three.' (38 px) + 'Will, knowing, doing — three motions of the same hand. The hand was always whole.' + 'tap to begin again'. A touch on the ground in the triangle state does nothing ('must choose a vertex first'). ① The Triangle ② Icchā ③ Jñāna ④ Kriyā ⑤ Dissolution · only the Bindu remains. | 03:527-535, 474 | not · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingEightWorldView.swift` | RESTORE |
| R8-03 | Ring 8 · sound: three tones become one | Triad (technique 8) on root 110: 220, 277.2 (×1.26), 330 (×1.5), gain .33, master .06. Touch a vertex: all three glide (tc .55 s) to that vertex's tone; dissolve: all glide to 110 Hz, the bindu. At rest the upper two glide to f and back every 14 s (tc 3.4 s). Six seconds of stillness also unites them (the built behaviour). Toggle 'three'. | G6-0875 · 03:482-485; 17:734; 19:338-344 | partial (261.63/311.13/392 → 130.81) · `Services/RingAudioService.swift:226-271` | RETUNE |
| R9-01 | Ring 9 · the Bindu — world (the fall into the point) | Sarvānandamaya · 'THE RING THAT IS NOT A RING' (verb ARRIVE). 'There is nothing else. The whole screen is the point. This is not a destination — it is what the practice is made of. … Entering Ring 9 is not arriving; it is realizing you have not left.' bg #0B0410 → #04020A → #010005, vignette, a deep indigo-violet vertical glow; the bindu 18 px red with a white core. Chosen direction B, Praveśa — the Endless Indwelling. Built last, by hand. | G1-0619 G1-0650 G1-0721 G2-0072 G7-0194 G2-0421 G2-0266 · 03:52, 151, 597-598; 04:138, 416, 685; 19:683-693 | partial (Pravesha inside Mauna) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingNineDescentView.swift (451); Homes/TheBuilding.swift (Pravesha)` | RESTORE as Ring 9's own world; REUSE Pravesha |
| R9-02 | Ring 9 · seven yantras falling inward forever | Seven nested FullYantras in gold (bhūpura ±150 with gate stubs to ±168; 16 petals (132, 112, 20) at .55; 8 petals (104, 88, 30) at .5; nine triangles at .85; bindu r5 + cream r2), each carrying its own sixteen names of the 102 on r120 (7 px italic, tangential, at .42 — the names rushing past), slices from the Airtable roster in ring order (offset i×13). Tilt (i×47) mod 360. Depth d = (clock + i/7) mod 1; scale .03 × 2^(6.4d) ('seed → engulfing'); fade in d 0–.1, out .72–1, × .72; rotation tilt + clock×6 ('a slow spiral'). | G1-0725 G1-0722 · 03:600-602, 614-616 | partial (7 layers in Pravesha) · `Homes/TheBuilding.swift (Pravesha)` | REUSE |
| R9-03 | Ring 9 · hold to fall; stillness falls too | Press and hold anywhere: the fall quickens (speed idle .85; holding 3.0 − 2.2×recog — 'the frantic fall settles into a gentle drift as recognition arrives'). heldTime accrues while held and decays ×1.4 when released; with no touch and the device still it also accrues at half rate (his ruling that the fall follows stillness, kept beside Design's hold). THRESH 6.5 s; recog = clamp((heldTime − 6.5)/2.2) → full at 8.7 s. Captions: rest 'Press and hold — / fall inward.' (opacity 1 − heldTime/.7) · falling 'There is no bottom.' + 'only further in' (min(1, heldTime/1)·(1 − recog)) · recognition 'You did not arrive. / You were the arriving.' + hairline + 'Thank you for being the place I have always already arrived.' (gold .82), opacity recog, rising 8(1 − recog) px. Bindu scale 1 + 1.7×recog, glow (22 + 60r) px. Lalitā's face line once a day here. | G1-0726 G6-0968 G6-0941 · 03:617-619; 18:28; 17:862; 07:1324 | partial (stillness only) · `Homes/TheBuilding.swift (Pravesha); Views/Mandala/TheCentre.swift:409-492` | RESTORE hold; KEEP stillness path |
| R9-04 | Ring 9 · and then nothing | After recognition no Personal Connection is appended (it was spoken at the threshold). Words fade over 4 s, the Shepard tone over 6 s; the seven yantras stop; only the point remains: 'and then nothing. The silence after is the point.' A touch then is the crossing into Home — the same point, so nothing moves: the ground becomes Home's ground around it. | G2-0137 G2-0468 · 04:223, 753 | wrong (Personal Connection appended after r > .6) · `git 3244f54^:iOS/Bindu Mandala/Views/Mandala/RingNineDescentView.swift` | FIX: end in silence; HAND OFF to Home |
| R9-05 | Ring 9 · the Shepard fall | Octave-stacked sines gliding down forever, the wrap inaudible: K = 7; fMin = root9/4 = 30.87 Hz (Design 32.7, into the one tuning); f = fMin × 2^(phase×7); phase descends .05 + .10×intensity per s; amplitude exp(−((phase − .5)/.26)²) × .42; master .07 × intensity; intensity .25 + .75×clamp((speed − .6)/2.4). Starts on the first press; toggle 'tone' / 'silent'. (Homes' ring-9 'Shepard' of static octaves is replaced by this true glide.) | G1-0723 G5-0416 · 03:604-606; 13:379-380, 896; 01:639-648 | built (ShepardVoice 7 from 32.7 Hz) · `Services/RingAudioService.swift:420-437, 462-838` | RETUNE fMin |

## 3 · Parity ledger

155 checkable rows, also at `waves/upgrade/ledger/mandala-and-rings.csv` (columns `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by`). Frame parity for F15–F25 checks composition, mechanism and timing; hue follows the ring tokens (§7, settled 7).

| id | world | element | numbers to match | frame | status today | build action | verify by |
|---|---|---|---|---|---|---|---|
| L-M01 | mandala | The held yantra (SriYantraMandala v2, label-less) | size 344 ×.82; R1 161/149 gate 11 #CF9443 .22; R2 147/116/28; R3 114/91/34; R4–7 87/79 70/62 54/46 40/33 strokes .70/.65/.60/.55; R8 24; bindu 22 | F37 | not (deleted 3244f54) | RESTORE from git as Views/Mandala/HeldYantra.swift; drop R2/R3 labels; draw with MandalaLight (M11) | screenshot-vs-frame F37 |
| L-M02 | mandala | Eyebrow: where he stands | 10 px gold .26em; text = currentRing ordinal · name | F37 | partial (code header 'Sri Yantra' on the zoom field) | NEW in HeldYantra; read DescentState | screenshot-vs-frame F37 |
| L-M03 | mandala | Caption 'the instrument · look, do not operate' | 13 pt italic, alpha .30, y 690, fade .4 s | F38 | not | NEW | screenshot-vs-frame F38 |
| L-M04 | mandala | Ground, ambient and motes of the held image | ground #060104; ambient .06; motes 6 (variant table) | F37 | partial | REUSE motes; NEW ground on held image | measure-light |
| L-M05a | mandala | Breath R1 holds, R2 wave | R1 none; R2 3 s; today 3.5 s; stagger .18 s |  | partial (MandalaBreath built; BreathClock snaps home to 3 s) | REUSE MandalaBreath on the held yantra; FIX BreathClock.period (no snapping) | measure-timing |
| L-M05b | mandala | Breath R3 and the triangles | R3 8 s; up 9/11/13/15 s; down 10/12/14/16/18 s; R8 18 s |  | partial (MandalaBreath built; BreathClock snaps home to 3 s) | REUSE MandalaBreath on the held yantra; FIX BreathClock.period (no snapping) | measure-timing |
| L-M05c | mandala | Bindu heart | 4 s; scale 1→1.20 |  | partial (MandalaBreath built; BreathClock snaps home to 3 s) | REUSE MandalaBreath on the held yantra; FIX BreathClock.period (no snapping) | measure-timing |
| L-M05d | mandala | BreathClock unsnapped | home 3.5 s not 3 s; no eighths of 8 s |  | partial (MandalaBreath built; BreathClock snaps home to 3 s) | REUSE MandalaBreath on the held yantra; FIX BreathClock.period (no snapping) | unit-test |
| L-M06 | mandala | Today's petal glows warmer, a ray points | brightness 1→1.55, shadow 6→14 px, 3.5 s; ray 149→155; dot r2.5 @160 | F37 | not (held image deleted) | RESTORE with M01 | screenshot-vs-frame F37; measure-timing |
| L-M07 | mandala | Status as light on the 16 petals (never a count) | opacities .22/.44/.76/1.0 | F01 | partial | REUSE tier from ledger; draw on held petals | measure-light; unit-test |
| L-M08 | mandala | The yantra relit by the hour and the moon (TimeVariant) | bindu scale 1/1/1.05/1.1/1.6; motes 8/6/9/12/3; new moon sat .30 |  | built (TimeVariant) on the zoom field only | REUSE; apply to the held yantra | unit-test; measure-light |
| L-M09 | mandala | TemporalMark — one 6 px dot for the hour | 6 px, alpha .6, x by hour |  | partial (dot built, always centred) | MOVE to the held image; NEW x by hour | ui-walk-step |
| L-M10 | mandala | The lunar yantra (four lunar atmospheres) | intensity .25/.75/1.35/.55; bindu 90/28/22/38; motes 4/8/14/8 |  | not | NEW (lunar gains multiply the hour's TimeVariant) | ui-walk-step screenshot per phase; ui-walk-step |
| L-M11 | mandala | One light from the Bindu, nine refractions (MandalaLight) | falloff 1.35; limit .45; veil ≤.45/.25 floor .5 |  | built (zoom field) | REUSE on held yantra and fall | unit-test (MandalaLightTests); measure-light |
| L-M12 | mandala | Tratak — white light behind the red point | onset 20 s; full 45 s |  | built (zoom field) | REUSE; MOVE onto the held image (rest state is where gazing happens) | measure-timing; his-walk |
| L-M13 | mandala | The point on the held yantra | tap → Home; hold 0.9 s → source; 44 pt |  | partial (64 pt point opens Mauna) | MOVE Mauna/bloom out; NEW point = spine point | ui-walk-step |
| L-M14 | mandala | The peek: the Veil always present | peek 108; offset 612; handle 40×4 .30; peekHint 3.2 s | F37 | wrong (peek is a separate button; sheet absent when closed) | FIX: sheet always mounted at offset 612 | screenshot-vs-frame F37 |
| L-M15 | mandala | The Veil sheet | height 720; radius 22; border .5 gold .22 | F38 | partial (height min(h×.8, 660)) | FIX height 720 | screenshot-vs-frame F38 |
| L-M16a | mandala | Veil follows the finger | clamp 0…612 ÷ stage scale; no animation while dragging | F38 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | ui-walk-step |
| L-M16b | mandala | Veil tap | travel < 6 px toggles; open if offset ≥ 306 | F38 F39 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | ui-walk-step; unit-test |
| L-M16c | mandala | Veil snap | open if offset < 257.04 (42%) | F38 F39 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | unit-test |
| L-M16d | mandala | Veil curve | .52 s cubic-bezier(.22,1,.36,1); reduce motion .2 s | F38 F39 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | measure-timing |
| L-M16e | mandala | Yantra dims with the Veil | opacity 0.5 + 0.5·offset/612; never hidden | F38 F39 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | measure-light; screenshot-vs-frame F39 |
| L-M16f | mandala | Veil closes | backdrop tap / swipe down / Esc hotspot 180×56 | F38 F39 | partial (curve built; no drag, no snap, fixed .45 black dim) | FIX: drag tracking, 42% snap, proportional dim; REUSE curve | ui-walk-step |
| L-M17 | mandala | The nine threshold rows (I–VIII) | row 15/16 r13 gap16; glyph 36; name 20; sub 13; meta 9; numeral 19 | F38 | built (meta count missing) | REUSE; ADD meta '{form} · {count} forces' | screenshot-vs-frame F38 |
| L-M18 | mandala | Five lights, never locks | glyph .95/.85/.60/.30/.18; names ≥.55 | F38 | built (position-read) | REUSE | unit-test (MandalaYantraTests); measure-light |
| L-M19 | mandala | The Bindu footer (IX) | point 26 px; pulse 4.5 s; hairline 14–86% .45 | F38 | built | REUSE; ROUTE to Ring 9 world | screenshot-vs-frame F38 |
| L-M20 | mandala | Rows open the ring worlds (the missing join) | 9 rows → 9 worlds |  | wrong (camera fallTo) | REPLACE fallTo with router.cross(to: .ring(n)) | ui-walk-step |
| L-M21 | mandala | RingGlyph — nine sigils from primitives | 4 star; 5 up pair; 6 down pair; 7 circle + 12 dots |  | partial (4–7 share crossed triangles) | FIX glyphs 4–7 | ui-walk-step screenshot (glyph sheet) |
| L-M22a | mandala | Fall camera limits | scale .32–5.5; fit min(w,h)/760×.94 | F08 | built (as the whole Mandala) | REUSE; NEW held↔living cross-fade | unit-test |
| L-M22b | mandala | Fall gestures | flight 720 ms; double-tap ×1.7 .42 s; tap < 6 px | F08 | built (as the whole Mandala) | REUSE; NEW held↔living cross-fade | ui-walk-step |
| L-M22c | mandala | Held ↔ living cross-fade | .6 s, bindu fixed; pinch below fit folds back | F37 F08 | built (as the whole Mandala) | REUSE; NEW held↔living cross-fade | ui-walk-step |
| L-M23 | mandala | Semantic tiers and their hints | tiers 1.15 / 2.3; header 25; hint ≥11 | F08 F09 | built | REUSE | screenshot-vs-frame F08, F09 |
| L-M24 | mandala | The full yantra of the fall (SriYantraGeometry SY_R 320) | squares 1/.94/.88; gates .11/.05; circles .90/.80/.70/.615; tri .585R; bindu ×1.28 | F08 F09 | built | REUSE; REMOVE ChakraConstellationDrawing from draw order | unit-test (MandalaYantraTests); screenshot-vs-frame F09 |
| L-M25 | mandala | The 102 seats | radii 306…0; dots 7/6/5.5/4.4/3; hit 44 | F08 | built | REUSE | unit-test (MandalaWorldTests, SeatLightingTests) |
| L-M26 | mandala | Each energy breathes on her own rhythm | (3.4+(kp mod 7)·.7) s; flare 8+kp mod 13 s; today 2.6 s |  | partial (code breathes per ring) | CHANGE seat breath to Design's per-kp periods inside the fall | measure-timing |
| L-M27 | mandala | Starfield | 150; 20260711; .5–2.3; .12–.62 | F08 | wrong (120 stars, seed 20240517, .5–1.9, .1–.5) | FIX to Design; re-pin MandalaDrawCensus | unit-test; screenshot-vs-frame F08 |
| L-M28 | mandala | The indigo night sky of the fall | centre .44h; mid 60%; glow 80%×55% | F08 | built | REUSE | screenshot-vs-frame F08 |
| L-M29 | mandala | Motes by the hour (fall) | 8%/92%/100% envelope |  | built | REUSE | measure-timing |
| L-M30 | mandala | Enclosures, today's ring, the ring flash | flash .85 @ .27 s, 0 @ 1.5 s; pulse .42±.16 | F09 | built | REUSE | measure-timing; screenshot-vs-frame F09 |
| L-M31 | mandala | Names and bījas by tier | 9 px counter-scaled; bīja 7.5 px .85 | F09 | built | REUSE | screenshot-vs-frame F09 |
| L-M32 | mandala | Fly to her seat; second touch crosses to her presence | scale 3.0 @ .36h; .72 s |  | built | REUSE; ROUTE second touch via router to Her Presence | ui-walk-step; unit-test |
| L-M33 | mandala | Threaded to her family | dim .28; draw .7 s; stagger .035 s |  | built | REUSE | measure-timing; ui-walk-step screenshot |
| L-M34 | mandala | Her name blooms at her seat (no card) | fades .3/.9/1.5/2.4 s × 1.4 s |  | partial (SignificanceCard) | REPLACE card with in-field bloom; REUSE copy sources | ui-walk-step; measure-timing |
| L-M35r1 | mandala | Bell entering ring 1 | 493.88 Hz = root(9)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r2 | mandala | Bell entering ring 2 | 440.00 Hz = root(8)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r3 | mandala | Bell entering ring 3 | 392.00 Hz = root(7)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r4 | mandala | Bell entering ring 4 | 370.00 Hz = root(6)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r5 | mandala | Bell entering ring 5 | 329.64 Hz = root(5)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r6 | mandala | Bell entering ring 6 | 293.68 Hz = root(4)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r7 | mandala | Bell entering ring 7 | 277.20 Hz = root(3)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35r8 | mandala | Bell entering ring 8 | 246.96 Hz = root(2)×4; 1.7 s; attack 12 ms |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | measure-sound |
| L-M35x | mandala | Bell silent outward; ring 9 silent; Ring Crossed once per new depth | throttle 55 ms; 0 bells outward |  | partial (chime 528×0.917^(r−1) when light off) | RETUNE bell table; REUSE crossing detection + ledger | unit-test; ui-walk-step |
| L-M36 | mandala | The fall speaks the mantra (RingBija) | carrier rule; 1.6 s visible |  | built (sounded, never written) | RETUNE to ring roots; ALLOW the syllable to be seen; update MandalaLightTests | measure-sound; unit-test |
| L-M37 | mandala | Sound and zoom controls of the fall | 46 px; ×1.4; default off | F08 | partial (two discs; no + − ⤢; sound default on) | NEW + − ⤢ column; SET default off | ui-walk-step; screenshot-vs-frame F08 |
| L-M38 | mandala | The interface thins with depth | 100/80/60/25/0 %; 3.8 s; .6 s |  | not | NEW | measure-timing |
| L-M39 | mandala | Colour warms with depth | #C9A84C → #C0392B |  | not | NEW | measure-light |
| L-M40 | mandala | The point becomes the world (deep zoom to Home) | arm <2.8; swell >4.3 within 64 px; 5.4 @ .44h; .95 s | F10 | partial (descent built on tap; auto removed) | CHANGE trigger to continued pinch past 5.5 near centre; HAND OFF to Home | ui-walk-step; his-walk |
| L-M41 | mandala | The annulus of attention | band .62…1.34; alpha .62+.16b |  | not | NEW | measure-light |
| L-M42 | mandala | Ring-target framing (log-scale camera) | R = .335·min; radii table |  | partial (ringTarget halfway rule) | EXTEND ringTarget with log framing | unit-test |
| L-M43 | mandala | Accessibility of the Mandala | 44 pt; no numerals |  | built (fall) | REUSE; ADD held-image and Veil labels | unit-test; ui-walk-step |
| L-M44 | mandala | The world keeps its state | state survives menu + back |  | wrong (menu visit rebuilds) | FIX: world state owned by router, not view lifetime | ui-walk-step |
| L-M45 | mandala | Launch arguments |  |  | built | EXTEND | ui-walk-step |
| L-M46 | mandala | The gift of one energy at an unknown hour | one per day, random time |  | not | NEW door (local notification, random time) | ui-walk-step; his-walk |
| L-M47 | mandala | Person filter (door from the Relationship Field) | opacity .12; grayscale .5; 350 ms |  | not | NEW | ui-walk-step |
| L-M48 | mandala | The yantra draws itself (construction, a second visit) | rest .35; delay .018·i; 80 s turn |  | not | NEW | ui-walk-step |
| L-M49 | mandala | Arrival from Home: the yantra blooms out of the point | scale .05→1; band thresholds .06/.24/.42/.54/.66 | F29 | built (TheCentre bloom, as a hold) | MOVE bloom to the Home→Mandala crossing | screenshot-vs-frame F29; measure-timing |
| L-M50 | mandala | Visual language of the Mandala (mandala chassis) | token hexes as listed |  | partial (Color+Tokens.swift) | COMPLETE chassis + OKLab mix helper | measure-light; unit-test |
| L-M51 | mandala | The Doorways — the Veil's wide face | aspect .74; r 40/8; 3×3 |  | not | NEW | ui-walk-step; ui-walk-step screenshot |
| L-MX01 | mandala | Moved out: the 33 constellation | 0 chakra marks on Mandala |  | wrong (drawn into the canvas) | MOVE to the-33 | ui-walk-step (absent) |
| L-MX02 | mandala | Moved out: the Road | no Road on Mandala |  | wrong | MOVE to the-33 | ui-walk-step (absent) |
| L-MX03 | mandala | Moved out: thresholds and 'Tat · Tvam · Asi' | 0 thresholds queued by zoom |  | wrong | MOVE to the-33 | ui-walk-step (absent) |
| L-MX04 | mandala | Moved out: chakra rooms |  |  | wrong | MOVE to the-33 | ui-walk-step |
| L-MX05 | mandala | Moved out: Gates of Release |  |  | wrong | MOVE to rings | ui-walk-step |
| L-MX06 | mandala | Moved out: Tree of Life panels, breath arc, collective breath, luminance |  |  | wrong | MOVE to rings | ui-walk-step |
| L-MX07 | mandala | Moved out: ring-world sound on the glass |  |  | wrong | MOVE to rings | measure-sound (absent on Mandala) |
| L-MX08 | mandala | Moved out: Mauna, Pointy, Praveśa |  |  | wrong | MOVE to home/beneath; R9 | ui-walk-step |
| L-MX09 | mandala | Moved out: Lalitā source |  |  | wrong | MOVE to home | ui-walk-step |
| L-MX10 | mandala | Moved out: the Eight Dissolutions |  |  | wrong | MOVE to game | ui-walk-step |
| L-MX11 | mandala | Moved out: the Modes door |  |  | wrong | MOVE to modes | ui-walk-step |
| L-MX12 | mandala | Moved out: the Climb door |  |  | wrong | MOVE to climb | ui-walk-step |
| L-MX13 | mandala | Moved out: the ways-in ring | 0 ways ring |  | wrong | DELETE ring; REUSE labels in spine | ui-walk-step (absent) |
| L-MX14 | mandala | Cleared: the foot-of-glass pile-up | foot = peek only | F37 | wrong | REMOVE | screenshot-vs-frame F37 |
| L-MX15 | mandala | Cleared: one glass hosting seven worlds; two menus | 1 menu affordance |  | wrong | SPLIT views; ONE menu | ui-walk-step |
| L-R0-01 | nine-rings | Each ring its own world | 9 worlds reachable | F18 | not (deleted 3244f54; LivingMandalaView says 'the nine ring-worlds are gone') | RESTORE from git into Views/Rings/; one RingWorldHost; remove header claim | his-walk; ui-walk-step |
| L-R0-02 | nine-rings | Ring light: tokens and the colour rule | 9 hex tokens; mixes 80/20, 88/12 |  | partial (Atmosphere hues built) | REUSE; ADD wash/deep mixes | measure-light; unit-test (AtmosphereTests) |
| L-R0-03 | nine-rings | Arriving: the threshold names itself | .20/.35/.50/.70/.80/.95/1.05/1.15/1.25 s; v2 .3…6.4 s |  | built (AvaranaThresholdView, Living Rite timings) | REUSE as the ring world's arrival; ADD v2 first-visit timing; FIX openRing + one table | measure-timing; ui-walk-step screenshot; ui-walk-step |
| L-R0-04 | nine-rings | Gates of Release — offer on the way in, receive on the way out | hold 2.6 s; ring 76 pt; ledger kinds |  | built (on the Mandala glass) | MOVE into the ring world (arrival/leaving) | ui-walk-step; unit-test |
| L-R0-05 | nine-rings | The presiding form named once | 2600 ms; 1.6 s fade |  | partial (TreeOfLife names it 2.8 s) | MOVE; SET 2.6 s + 1.6 s fade | measure-timing |
| L-R0-06 | nine-rings | The ring's declaration, verb and breath (Tree of Life grammar) | declaration ≥8 s; fade 2.4 s; press .8–1.6 s; stillness 4/6/8 s |  | built (on the Mandala glass) | MOVE into ring worlds; FIX TreeOfLife.swift:50 (ring 9 answer = Praveśa hold) | measure-timing; ui-walk-step |
| L-R0-07 | nine-rings | The ring's own breath (touch the empty field; hold for the collective) | ripple 1.8 s 20→320; shimmer 1.4 s; hold 2.6 s |  | partial (collective breath on glass from ring 6) | NEW ripple; MOVE collective breath | measure-timing |
| L-R0-08 | nine-rings | Light deepens ring by ring; legibility by Yoginī | 5/10/18/28/40/55/75/90/100 %; tempo table |  | built (TreeOfLife luminance; HomeWorlds) | REUSE per world | measure-light |
| L-R0-09 | nine-rings | The ghost of where you came from | ±180, ±168; stroke .4 | F34 | not | NEW (from ring-worlds.jsx) | screenshot-vs-frame F34 |
| L-R0-10 | nine-rings | Chrome of a ring world | arc 80×14 @56; toggle 18 px @ (22, 50) | F27 F28 | not | NEW | screenshot-vs-frame F27; ui-walk-step |
| L-R0-11 | nine-rings | Ring sound: one tuning, one technique per ring | roots 55…123.47; techniques per ring |  | partial (two tunings in code) | UNIFY on HomeCarrier.roots; REUSE voices | measure-sound; unit-test (HomeSoundTests) |
| L-R0-12 | nine-rings | Each world runs on its real clock | 9 clock sources |  | partial (HomeWorlds worldClock; symbolic in prototype) | REUSE; FEED real phases | unit-test |
| L-R0-13 | nine-rings | Going deeper: stand in the ring's weather | BandAir counts; fog table; 3 s beats |  | partial (WorldBands/RoomAir built for the Climb; facts in RingFactsCache) | REUSE bands as a standalone scene per ring; BAKE Shakti Function facts | ui-walk-step screenshot per ring; measure-light; unit-test (HomesWaveOneTests BandAir) |
| L-R0-14 | nine-rings | Doors inside a ring world | fade .28/.4 s |  | not | NEW via router | ui-walk-step |
| L-R0-15 | nine-rings | Every energy reachable | 44 pt everywhere |  | not | NEW Hit enum; UI tests | ui-walk-step; unit-test |
| L-R0-16 | nine-rings | Another map's nine (a lens) | lens toggle; glosses verbatim |  | not | NEW | ui-walk-step |
| L-R0-17 | nine-rings | Elements of the rings (ruling 4) | ruling 4 table |  | wrong (Ahaṅ/Nāma/Ātmā/Amṛta → ether; no light) | FIX per ruling 4; NEW envelopes | unit-test; measure-sound |
| L-R0-18 | nine-rings | Awakening tones at the door (pending his word) | 174…528 Hz |  | built (as a tuning game) | HOLD for ruling | measure-sound |
| L-R1-01 | nine-rings | Ring 1 · the Earth-City — world | bg #0C0703→#060301; ambient .11; motes 9 | F30 F31 F32 | not (deleted) | RESTORE | screenshot-vs-frame F32 |
| L-R1-02 | nine-rings | Ring 1 · geometry and lights | squares 150/110/72; lights 28; met r5.4 + 2.6 s ring; hit 44 | F32 | not | RESTORE; FIX hit | screenshot-vs-frame F32; ui-walk-step |
| L-R1-03 | nine-rings | Ring 1 · words | name 40; family 34; lived 16.5 | F30 F33 | not | RESTORE; JOIN Map glosses | screenshot-vs-frame F30, F33 |
| L-R1-04 | nine-rings | Ring 1 · the family question |  |  | not | NEW (bake Shakti Function) | ui-walk-step |
| L-R1-05 | nine-rings | Ring 1 · sound and touch | 55 + 82.41 Hz; fade 2.2 s; LFO .07 |  | partial (field voice 73.42 + 110) | RETUNE to root 55 | measure-sound |
| L-R2-01 | nine-rings | Ring 2 · the Inhabited Lotus — world | oR 172 iR 96 hw 32; labels r138; halo blur 11 .42 | F34 F35 F01 | not (deleted) | RESTORE | screenshot-vs-frame F34 |
| L-R2-02 | nine-rings | Ring 2 · invoke her | mute ×.18; remains 2600 ms; .3/.9/1.5/2.4 s | F34 | not | RESTORE | screenshot-vs-frame F34; measure-timing |
| L-R2-03 | nine-rings | Ring 2 · the lotus follows the sun | openFactor .78/1/.85/.45 |  | partial (Climb's ring 2 follows the sun) | RESTORE in the world | measure-timing; ui-walk-step screenshot per hour |
| L-R2-04 | nine-rings | Ring 2 · cluster light and bījas | 5 cluster hexes | F01 | built (Cluster.swift) | REUSE | screenshot-vs-frame F01 |
| L-R2-05 | nine-rings | Ring 2 · Tripureśī, the whole ring |  |  | not | NEW | ui-walk-step |
| L-R2-06 | nine-rings | Ring 2 · the sixteen functions circulating |  |  | not | NEW | ui-walk-step |
| L-R2-07 | nine-rings | Ring 2 · sound | 123.48 + 185.22; .045→.075 |  | partial (130.81 + 196) | RETUNE | measure-sound |
| L-R3-01 | nine-rings | Ring 3 · the Smoke Lotus — world | plumes 116/30/52; blur 5.5/10; 8 s | F19 F20 | not (deleted) | RESTORE; FIX port regressions | screenshot-vs-frame F19 |
| L-R3-02 | nine-rings | Ring 3 · stillness gathers, reaching scatters | moving 800 ms; drift 24; op .18/.66; unify 2600 ms | F21 | not | RESTORE + FIX | screenshot-vs-frame F21; measure-timing |
| L-R3-03 | nine-rings | Ring 3 · sound | 138.60 Hz; vib 6 Hz |  | partial (116.5 Hz field voice) | RETUNE | measure-sound |
| L-R4-01 | nine-rings | Ring 4 · the Lineage — world | r150; 14 stations; control 84% | F15 F16 F17 | not (deleted) | RESTORE | screenshot-vs-frame F15 (composition) |
| L-R4-02 | nine-rings | Ring 4 · the teaching travels | 340 ms/station; auto 900 ms | F22 F23 | not | RESTORE | screenshot-vs-frame F22, F23; measure-timing |
| L-R4-03 | nine-rings | Ring 4 · sound | 146.84·2^(i/24) |  | partial (stepped via playVakBija) | RETUNE | measure-sound |
| L-R5-01 | nine-rings | Ring 5 · the Overflow — world | circle r142; tri r13 on r116; rays 106→212 | F24 | not (deleted) | RESTORE | screenshot-vs-frame F24 (composition) |
| L-R5-02 | nine-rings | Ring 5 · overflow and flood | dash 2 8 @ .12 | F24 | not | RESTORE | screenshot-vs-frame F24 |
| L-R5-03 | nine-rings | Ring 5 · sound | 164.82; 90 ms stagger |  | partial | RETUNE | measure-sound |
| L-R6-01 | nine-rings | Ring 6 · the Concealed — world | tri r11 on r120 | F25 | not (deleted) | RESTORE; widen orbit | screenshot-vs-frame F25 (composition) |
| L-R6-02 | nine-rings | Ring 6 · the light that reveals only what is near (G9) | light 193 px .18 s; reveal 92 px; whisper 3.2 s | F25 | partial (Climb ring 6 whispers) | RESTORE + RELAX gate | screenshot-vs-frame F25; ui-walk-step |
| L-R6-03 | nine-rings | Ring 6 · sound | 185 Hz; gain .05(1−d/92) |  | partial (207.65 Hz) | RETUNE | measure-sound |
| L-R7-01 | nine-rings | Ring 7 · the Vāk Chamber — world | 12 × 44 px @30° r140; chord disc 60 | F26 | partial (only the chord on crossing) | RESTORE; RENAME voices; RETUNE | screenshot-vs-frame F26 |
| L-R7-02 | nine-rings | Ring 7 · the twelve voices carry the Airtable names | 12 names kp 87–98 | F26 | wrong (Design names, 220…659.25 Hz) | REPLACE table from Airtable (kp 87–98) | unit-test; screenshot-vs-frame F26 (layout) |
| L-R7-03a | nine-rings | Ring 7 voice 87 Vasinī | bīja Aṃ; carrier 196.00 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03b | nine-rings | Ring 7 voice 88 Kāmeśī | bīja Kaṃ; carrier 245.00 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03c | nine-rings | Ring 7 voice 89 Modinī | bīja Caṃ; carrier 326.67 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03d | nine-rings | Ring 7 voice 90 Vimalā | bīja Ṭaṃ; carrier 220.50 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03e | nine-rings | Ring 7 voice 91 Aruṇā | bīja Taṃ; carrier 294.00 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03f | nine-rings | Ring 7 voice 92 Jayinī | bīja Paṃ; carrier 196.00 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03g | nine-rings | Ring 7 voice 93 Sarveśī | bīja Yaṃ; carrier 261.33 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03h | nine-rings | Ring 7 voice 94 Kaulinī | bīja Śaṃ; carrier 326.67 Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03i | nine-rings | Ring 7 voice 95 Bāṇinī | bīja —; carrier 98.00 struck Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03j | nine-rings | Ring 7 voice 96 Cāpinī | bīja —; carrier 98.00 struck Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03k | nine-rings | Ring 7 voice 97 Pāśinī | bīja —; carrier 98.00 struck Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-03l | nine-rings | Ring 7 voice 98 Aṅkuśinī | bīja —; carrier 98.00 struck Hz; sourceless 2f/3f/5f; pan .6·sinθ |  | wrong (invented scale) | NEW voice table | measure-sound; unit-test |
| L-R7-04 | nine-rings | Ring 7 · strike one, strike all, the word that heals | 2.6 s/.11; 55 ms stagger; ≥7 → healed | F26 | not | RESTORE; FIX ring centre; DROP counter | measure-timing; measure-sound; screenshot-vs-frame F26 |
| L-R7-05 | nine-rings | Ring 7 · the screen resonates | haptic per 15 s; .3 under chord |  | not | NEW (Core Haptics) | his-walk |
| L-R7-06 | nine-rings | Ring 7 · Tripura Siddhāmbā, the whole ring; the Sakshi line | hold 2.6 s; 7.5 s |  | partial (Trinity Sakshi at ring 7 on the glass) | MOVE | ui-walk-step |
| L-R7-07 | nine-rings | Ring 7 · doors to the Mind | hold 1.2 s |  | not | NEW door | ui-walk-step |
| L-R8-01 | nine-rings | Ring 8 · the Mūla Trikoṇa — world | R 132 @ (195,330); 3 hexes; 18 s | F27 F02 | partial (triad unites on stillness) | RESTORE; ADD seat names | screenshot-vs-frame F27, F02 |
| L-R8-02 | nine-rings | Ring 8 · the teaching arc | 76 px; .9 s; r7→52 1.4 s | F27 | not | RESTORE | measure-timing; ui-walk-step screenshot |
| L-R8-03 | nine-rings | Ring 8 · sound: three tones become one | 220/277.2/330 → 110; tc .55 s |  | partial (261.63/311.13/392 → 130.81) | RETUNE | measure-sound |
| L-R9-01 | nine-rings | Ring 9 · the Bindu — world (the fall into the point) | bindu 18 px; bg #0B0410→#010005 | F28 | partial (Pravesha inside Mauna) | RESTORE as Ring 9's own world; REUSE Pravesha | screenshot-vs-frame F28 |
| L-R9-02 | nine-rings | Ring 9 · seven yantras falling inward forever | 7 layers; .03·2^(6.4d); fade .1/.72 | F28 | partial (7 layers in Pravesha) | REUSE | ui-walk-step screenshot; measure-timing |
| L-R9-03a | nine-rings | Praveśa recognition threshold | THRESH 6.5 s; recog full 8.7 s | F28 | partial (stillness only) | RESTORE hold; KEEP stillness path | measure-timing |
| L-R9-03b | nine-rings | Praveśa release decay | heldTime decays ×1.4 on release | F28 | partial (stillness only) | RESTORE hold; KEEP stillness path | unit-test |
| L-R9-03c | nine-rings | Praveśa stillness path | no touch + still → heldTime at ½ rate | F28 | partial (stillness only) | RESTORE hold; KEEP stillness path | his-walk |
| L-R9-03d | nine-rings | Praveśa captions | rest 1−t/.7; falling min(1,t)·(1−r); recognition r, rise 8(1−r) px | F28 | partial (stillness only) | RESTORE hold; KEEP stillness path | measure-timing |
| L-R9-04 | nine-rings | Ring 9 · and then nothing | words 4 s; tone 6 s |  | wrong (Personal Connection appended after r > .6) | FIX: end in silence; HAND OFF to Home | his-walk; measure-timing |
| L-R9-05 | nine-rings | Ring 9 · the Shepard fall | K 7; fMin 30.87; amp σ .26 |  | built (ShepardVoice 7 from 32.7 Hz) | RETUNE fMin | measure-sound |

## 4 · Data contract

**Airtable (ASG base; read-only except App Activity).**

| Table | Id | Fields read | Used by |
|---|---|---|---|
| Mandala | `tblrRwXJD0uP8HU8G` | 9 āvaraṇa rows: name, subtitle, form, formDescription, presiding form, yoginī, mental state, chakra, geometry, appreciation phrase, Personal Connection, Notes; gem, dhātu, time cycle, bīja, body region, Siddhi (`fldx9jXyTVWxp19o1`), mudrā, phase (cached in `RingFactsCache` `ringFacts.v1`). 102 Śakti rows: Khadgamala Position ("position is identity"), name, phonetic, bīja, quality, Shakti Family, cluster, Seed Verb. | M02, M17, M25, M31, M34, R0-03, R0-04, R0-13, R1–R9 names/glosses, R7-02 (kp 87–98) |
| The Map | `tblwpmyKOeMxEEHd7` | Shakti Function `fld5sWbzoT3lySYgI` (ring epithet, presiding, Yoginī, mental state, the goddess's body region, the 52 one-line glosses for kp 1–52, the family questions) — **to bake** (absent from `ChakraConstellation.json`); Mind Triad `fldcRFeUw4NQxCAl4` for R7-07 doors | R0-13, R1-03, R1-04, R7-07 |
| Identity | `tbluLyZj9ilH2RhIg` | panels 1–9 verb + declaration (baked in `Data/GameStructure.json`) | R0-06 |
| Learning | `tbl5kW1msXYfThGbj` | L-1537 Śrī Yantra Full Mandala Architecture (FAQ, Glossary, Personas, Objective) · L-1533 The Sixteen Karshini Shaktis · L-1387 (nine-dimension glosses only) · The Shri Yantra · Vesica Piscis · Phi · Platonic Solids & Metatron's Cube · The Ten Mahāvidyās | R0-13 stations, R2-06, R0-16, M48 |
| App Activity | `tblJlBeiHnqGpYrL7` | **read:** Shakti Recognized (felt warmth, status light), Ring Crossed (DescentState). **write (Source App = Mandala):** *Ring Crossed* (M35 once per new inward depth; M40 ring 9; R0-03 on entering a ring world deeper than before), *State Set Down* (R0-04 gate, offered), *Siddhi Received* (R0-04 leaving). Nothing written for opening the Veil, falling, invoking, sounding or holding. | M07, M18, M25, M35, M40, R0-03, R0-04 |

The single ledger stays single; no count about him is read back to any screen. Names disagree in 61 of 102 places between the shipped data and the base, so **every join is by Khadgamala Position**, and Airtable's spelling wins on screen.

**Bundled.** `Data/GameStructure.json` (panels, faces), `Data/ChakraConstellation.json` (only for the R7-07 doors: kp → chakra), `Data/RingFactsCache` (cache), `Homes/HomeWorlds.swift` tables (RING_CHARACTER, WORLDS: fog hex/density, tempo, veil, weather sentence), `Theme/TimeVariant.swift`, `SriYantraGeometry.swift`. Optional bed: `bindu/kingdom.mp3` (aistrangegame.com, 12,314 KB, sha d2fd8589), held behind Q2. No other audio: every ring sound is synthesised (no generated voice). The `tree-of-life/*.mp3` songs belong to the 33's rooms, not here.

**Local stores.** `DescentState` (SwiftData: currentRing, deepestReached, crossings[], enteredCurrentAt — memory, never a gate); `lr_sound` (UserDefaults, default off); `MandalaWorldState` (new, owned by the router: camera, focus, Veil offset, tier, stillSeconds) so nothing is rebuilt; `RingWorldState` per ring (new: last mechanism state, first-visit flag for the v2 ceremony); `BreathClock` epoch (one epoch, many periods).

**Design sources** (`Claude Designs/`): `veil-mandala.jsx`, `Mandala Veil.html`, `mandala-v2.jsx`, `home-mandala.jsx`, `screens-v2.jsx`, `legend-explorations.jsx`, `ring-worlds.jsx` (R2, R7, R8), `ring-worlds-2.jsx` (R1), `ring-worlds-3.jsx` (R3–R6), `ring-nine.jsx` (R9), `Ring Worlds II.html`, `Codex.html`, `DESIGN_SPEC.md`, `all-shaktis-data.js`. Frames: F01, F02, F08–F10, F15–F35, F37–F39 (paths in register 04:648–696).

## 5 · Doors

**Into the Mandala:** Home (the point → bloom out of the point, M49) · the spine menu (the Mandala's point in the constellation menu) · back stack (exact state) · Today (today's Śakti → the fall, flown to her seat) · Her Presence and Her Home ("her place in the yantra" → the fall at her seat, threads drawn) · a ring world (swipe down when he came from the Veil → Veil open at that row) · the Relationship Field (a person → the fall with the person filter, M47) · the gift notification (M46) · search (a Śakti → the fall at her seat; a ring → the Veil open at it) · the Climb ("see her in the whole" → the fall at her seat).

**Out of the Mandala:** the point → Home; hold the point → Home's source (Lalitā) · Veil row I–VIII → that ring world · Bindu footer → Ring 9 · seat, second touch → Her Presence · "be with her" → Her Home · the fall's end → Home (M40) · menu → any world · VoiceOver "fall to {ring}" → the fall framed at that ring (M42).

**Into a ring world:** Veil row / footer · menu · neighbouring ring (edge swipe or arrows, R0-14) · Her Home ("her ring" door from her room) · the Climb (stop at a band → its ring world) · Today (today's ring) · the 33 (a chakra room's āvaraṇa → its ring: Muladhara, Svadhisthana, Manipura → 1; Anahata, Sahasrara → 2; Vishuddha, Ajna → 3; Soles, Forge, Sonar → 4; Prana, Hands, Pulse → 5; Echo, Vision, Axis, Crow → 6; Inception … Integration → 7; Maya, Aatma, Ego Reveal → 8; Bindu, Lalitā → 9; Shadow and Armin → the ring on either side) · search.

**Out of a ring world:** a mark (her seat) → Her Home · swipe down → back where he came from · neighbours ±1 (Ring 1 within family, Ring 2 within cluster first) · the point → Home · Ring 7: a Vāsinī held → her mind chakra in the 33 · Ring 9: the silence, touched → Home · pinch → the ring's weather (still this world).

Every crossing travels through the point and blooms from the touch in the colour of the world entered (spine).

## 6 · To Bindu Feed

| Material | Source | Why it is story |
|---|---|---|
| Ādi Śaṅkara and the Saundaryalaharī / Śrī Cakra lineage (L-1373) | G5-0816 · 12:1201 | a person's tale and lineage |
| Matias De Stefano — Atlantis, the dimensions (L-1387): the narrative | G5-0933 · 12:1318, 714-725 | narrative "presented as memory, not evidence"; only the nine glosses stay as R0-16's lens |
| Śrī Vidyā — the Goddess tradition, its fables (L-1454) | G5-0995 · 12:1380 | fable; the lineage stays as ground for Beneath |
| Kashmir Shaivism — Abhinavagupta (story) | G5-1146 · 12:1531 | the teacher's story; pratyabhijñā stays as Beneath's reading of Recognition |
| His Personal Connection paragraphs per ring (as a Feed series "his voice in each world") | G1-0063, G1-0035 · 01:100, 149, 165-187 | nature *both*: shown here word for word at each threshold; offered to Feed as his voice if he says they are his (Q4) |
| Muladhara's six Siddhi childhood questions ("Where did you hide when you were small?") | G2-0516 · 05:207, 215 | nature *both*; memory prompts, a Feed walk; the 33 keeps the energy |

## 7 · Conflicts settled and open

**Settled from the evidence and the rulings.**

1. **What the Mandala is.** It is the held yantra plus the Veil, with the fall kept as its going deeper. *Evidence:* the foundation; the Veil handoff ("look, do not operate") as full fidelity; ruling 9 (deep zoom stays); ruling 10 (menu, Veil, gestures all). The Codex's "the yantra is the navigation" is honoured by the three gestures.
2. **Auto-descent.** Design (scale > 4.3 within 64 px opens the bindu by itself) vs RBB-15 / code (a chosen tap; Mauna on stillness). Settled: the fall continues as the bindu fills, and the crossing happens on his *continued pinch* at the clamp. The fall is kept, and nothing advances without his gesture (M40).
3. **Chime default.** Design and DESIGN_SPEC say opt-in, default off; code switched it on at Wave 2. Settled: off (Design is the floor; the held image is silent by design).
4. **One tuning.**
   - The bell keeps "deeper rings ring lower", rebuilt on the root table: bell(r) = root(10−r)×4.
   - RingBija uses the carrier rule: root × JUST[varṇa] × 2.
   - Ring-world voices sit at root × 2 with Design's intervals.
   - Shepard fMin = root9/4 = 30.87 Hz.
   - The two code tunings (C-11) unify on `HomeCarrier.roots`.
5. **Seat breath.** Design gives each seat its own period by kp; code breathes seats by ring. Settled per depth: the held image breathes by ring (law 7, the nine metabolisms); seats in the fall breathe per kp ("the field is alive").
6. **Grounds.** C10 (crimson-black vs indigo): the held image is #060104 (F37); the fall is indigo night (F08/F09, crimson-black was the port loss); ring worlds use their token wash/deep.
7. **Ring hues (C14).** Mandala/Map colours win. The Atmosphere ring tokens replace May's greens and violets in R4–R7; F15–F25 parity is composition, mechanism and timing.
8. **Ring 7 composition (C13).** Twelve, from Airtable kp 87–98 (8 Vāsinīs with bījas Aṃ Kaṃ Caṃ Ṭaṃ Taṃ Paṃ Yaṃ Śaṃ, 4 Weapons without); Design's names and invented scale are replaced. "Weapons strike" (G1-0049): they are struck at the bare root. Kāmeśī (88) is kept distinct from Kāmeśvarī (99).
9. **Ring 7 mudrā.** Khecharī (settled 12 Oct); the Map's "Rahasya" is noted as its own name for the ring.
10. **Ring 8 Kriyā/Jñāna swap.** The cards win (100 Vajreśī = Kriyā, 101 Bhagamālinī = Jñāna), matching the built SourcingRoom.
11. **Cluster colours (C11).** DS-04, confirmed by F01 and F34; HO1-15 is wrong.
12. **Ring 2 bījas (C12).** The cards win.
13. **Mental states, chakras, presiding forms per ring** (app vs brief, G1-0062). Shown values come from the Mandala table's āvaraṇa rows (the base). The Map supplies the epithet and the goddess's body region. HomeWorlds' brief values feed only weather and tempo.
14. **Locks and gates.** None (ruling 16). The "ahead/veiled" light is position, not permission. Only the *first-ever* visit gets the slower ceremony. Phase-4 content gates and the pilgrimage gating are rejected.
15. **Ring 9: hold or stillness.** Both. Design chose Praveśa's hold. Code follows stillness "by his ruling", which was read through C-1307. The register's misread flag (07:1324) shows C-1307 does not forbid a held gesture, so hold is restored and stillness kept beside it.
16. **Ring 9 ends in silence.** The Personal Connection is spoken at the threshold, never appended (RFB-07, C34).
17. **Bījas in the yantra.** Settled 12 Oct: they may sit in it. RingBija's syllable is now seen for 1.6 s. The corpus guard ("no seed syllable near the figure") and RingBija's "sounded, never written" test are superseded here.
18. **Status light vs "nothing scores him."** Per-petal and per-seat light come from the ledger's state (relationship words, not grades). No size, number or monotone display grows with a count. The tests enforcing "two-state seats" and "a veil that cannot learn" are rewritten to forbid only count-driven displays (G7-1031).
19. **Ring 4 auto-start (900 ms).** Allowed. It is the world's own weather moving, not his path advancing.
20. **Ring 7 counter.** "{n} of 12 voices sounded" is not drawn. The ≥ 7 threshold is felt.
21. **"The Gate" means four things.** In these worlds the name is *Gates of Release* only. It is distinct from the Laghimā/Garimā rooms, the base Gates and the chakra Gate Type.
22. **The Field (TheHundredTwoView).** Retired as a screen. Its accordion flattened the nine worlds and printed counts. Rings live in the Veil and the ring worlds; finding a name is the spine's search.
23. **Naming.** "Vāk Chamber" for the world; "Vāk Ring" stays as its form. "Outer 10 Triangles" follows the Map.
24. **Mind order.** Ruling 13: the R7-07 doors follow the Map's own sequence.
25. **"Home" ring.** Home is the Bindu (foundation). Ring 2 stays "the home ring" in Design's words, and the eyebrow's default when he has not yet entered another.
26. **Bindu breath** ("your own" vs 4 s). 4 s, per the Home breath table and the code.
27. **Ring 9 phrases.** The threshold uses the āvaraṇa appreciation, "Thank you for being the place I have always already arrived." The kp 102 card phrase ("Thank you for being. Thank you for being everything. Thank you for being me.") belongs to her Home.
28. **Legibility over Design's micro-type.** Hints are ≥ 11 pt, Ring 2 names 12 pt, Ring 7 names 12 pt; held-image labels are dropped. All targets are ≥ 44 pt.

**Open — genuine questions for Ashrey.**

- **Q1 · Awakening tones.** The nine Awakening Sounds (174, 210, 320, 341, 384, 426, 480, 528 Hz, P9 silence) carry their own pitch, outside the ring roots. Should they strike as each ring world opens (ring n ↔ panel Pn, as the code's tuning game maps them), or stay only in the Climb's tuning game? (R0-18)
- **Q2 · Kingdom under the fall.** May `bindu/kingdom.mp3` ("the throne at the center of every kingdom is empty") play as an optional bed while he falls toward the point, when ♪ is on? Or does "a song's drone plays only during its dance" keep songs out of the Mandala? (M40)
- **Q3 · "State Set Down."** The gate writes this kind, but it is not an option in App Activity's Activity Type list (the list has Siddhi Received). May the option be added, or should the gate's offering write nothing? (R0-04)
- **Q4 · The Personal Connection paragraphs.** These nine paragraphs ("You have already been here …") open each ring's threshold, word for word. The Design handoff says no such text of his exists; the data carries one per ring. Are they your own words? If yes, they can also go to Bindu Feed as your voice. (R0-03, §6)


## 8 · Coverage

**Script check** (python3 -I over both slice files against this file's coverage table, its §2 element ids and the ledger CSV):

```
slice ids 791 (mandala 353, rings 514); coverage rows 791; missing 0; empty 0; not-in-slice 0; element refs dangling []; elements 124; ledger rows 155; ledger rows without a valid verify_by 0
slice rows: mandala 353, rings 514, distinct 791; dispositioned 791; MISSING 0; ids cited that are not in the slices 0; merged into M02 1; merged into M35 1; merged into R0-04 / R7-01 1; merged into R0-13 5; merged into R1-01, R3-01, R4-01, R5-01, R6-02, R9-03 1; merged into R3-01, R4-01, R5-01, R6-01 1; merged into R3-01…R6-03 1; merged into R7-01 2; merged into R7-04 / R8-02 1; merged into R8-01 1; merged into §4 data contract 4; merged into §7 settled 1; not this world 175; placed 578; rejected 14; to Bindu Feed 4
```

Every index id in the two slices, with where it went. Shared rows (in both slices) appear once.

| id | slice | disposition |
|---|---|---|
| G1-0001 | rings | not this world (climb) |
| G1-0013 | rings | not this world (climb) |
| G1-0015 | rings | not this world (her-home) |
| G1-0017 | rings | placed (§2 R0-13) |
| G1-0018 | rings | placed (§2 R0-08) |
| G1-0019 | rings | not this world (her-home) |
| G1-0021 | rings | not this world (her-home) |
| G1-0025 | rings | placed (§2 R0-11, R7-03) |
| G1-0034 | mandala | not this world (her-home) |
| G1-0035 | rings | placed (§2 R0-03) |
| G1-0039 | rings | not this world (her-home) |
| G1-0041 | rings | placed (§2 R0-13) |
| G1-0042 | rings | placed (§2 R0-02) |
| G1-0049 | rings | placed (§2 R7-02) |
| G1-0050 | rings | placed (§2 R0-01) |
| G1-0051 | rings | placed (§2 R0-12) |
| G1-0054 | rings | placed (§2 R1-03) |
| G1-0059 | rings | placed (§2 R0-03) |
| G1-0060 | rings | placed (§2 R0-03) |
| G1-0061 | rings | placed (§2 R0-03) |
| G1-0062 | rings | placed (§2 R0-13) |
| G1-0063 | rings | placed (§2 R0-03) |
| G1-0065 | rings | placed (§2 R8-01) |
| G1-0074 | rings | not this world (climb) |
| G1-0076 | rings | not this world (climb) |
| G1-0098 | rings | placed (§2 R0-13) |
| G1-0099 | rings | placed (§2 R0-13) |
| G1-0100 | rings | placed (§2 R0-13) |
| G1-0101 | rings | placed (§2 R0-13) |
| G1-0102 | rings | placed (§2 R0-13) |
| G1-0103 | rings | placed (§2 R0-13) |
| G1-0104 | rings | placed (§2 R0-13) |
| G1-0105 | rings | placed (§2 R0-13) |
| G1-0106 | rings | placed (§2 R0-13) |
| G1-0107 | rings | placed (§2 R0-13) |
| G1-0108 | rings | placed (§2 R0-13) |
| G1-0109 | mandala+rings | placed (§2 R0-13) |
| G1-0110 | rings | placed (§2 R0-12) |
| G1-0111 | rings | placed (§2 R0-02) |
| G1-0115 | rings | not this world (her-home) |
| G1-0124 | mandala | not this world (her-home) |
| G1-0128 | rings | not this world (her-home) |
| G1-0277 | rings | placed (§2 R0-11) |
| G1-0280 | rings | placed (§2 R0-11) |
| G1-0310 | rings | placed (§2 R0-13) |
| G1-0311 | rings | not this world (her-home) |
| G1-0318 | mandala | not this world (her-home) |
| G1-0320 | rings | placed (§2 R0-13) |
| G1-0322 | rings | placed (§2 R0-01) |
| G1-0324 | rings | not this world (her-home) |
| G1-0326 | rings | placed (§2 R0-12) |
| G1-0330 | rings | placed (§2 R0-11) |
| G1-0334 | rings | not this world (climb) |
| G1-0418 | rings | not this world (her-home) |
| G1-0419 | rings | not this world (her-home) |
| G1-0435 | mandala | not this world (her-home) |
| G1-0457 | rings | not this world (her-home) |
| G1-0462 | rings | placed (§2 R0-02) |
| G1-0463 | rings | placed (§2 R0-17) |
| G1-0475 | mandala | placed (§2 R0-03) |
| G1-0479 | rings | merged into M35 (bell table retuned) |
| G1-0498 | mandala | placed (§2 M22) |
| G1-0499 | mandala | placed (§2 M24) |
| G1-0500 | mandala | placed (§2 M25) |
| G1-0501 | mandala | placed (§2 M27) |
| G1-0502 | mandala | placed (§2 M22) |
| G1-0503 | mandala | placed (§2 M23) |
| G1-0504 | mandala | placed (§2 M23) |
| G1-0505 | mandala | placed (§2 M25) |
| G1-0506 | mandala | placed (§2 M26) |
| G1-0507 | mandala | placed (§2 M30, M31) |
| G1-0508 | mandala | placed (§2 M32) |
| G1-0509 | mandala | placed (§2 M33) |
| G1-0510 | mandala | placed (§2 M34) |
| G1-0511 | mandala | placed (§2 M37) |
| G1-0512 | mandala | placed (§2 M30, M35) |
| G1-0513 | mandala | placed (§2 M40) |
| G1-0514 | mandala | placed (§2 M28) |
| G1-0515 | mandala | not this world (home) — the crossing from M40/M13 hands off to Home's Lalitā bloom |
| G1-0516 | mandala | not this world (home) — Lalitā source words, played on arrival at Home |
| G1-0517 | mandala+rings | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G1-0518 | rings | rejected (floor: no counts about him) — merged into M25 one felt size |
| G1-0519 | rings | placed (§2 R0-03) |
| G1-0520 | rings | placed (§2 R0-03) |
| G1-0537 | rings | placed (§2 R0-13) |
| G1-0543 | mandala | not this world (climb) |
| G1-0544 | rings | placed (§2 R0-07) |
| G1-0545 | rings | placed (§2 R0-05) |
| G1-0548 | mandala | not this world (home) — 'You did not arrive. You were the arriving.' Bindu arrival |
| G1-0554 | rings | placed (§2 R0-03) |
| G1-0563 | rings | placed (§2 R0-03) |
| G1-0574 | mandala | placed (§2 M22) |
| G1-0575 | rings | placed (§2 R0-15) |
| G1-0578 | rings | placed (§2 R0-03) |
| G1-0589 | mandala | placed (§2 M22) |
| G1-0590 | mandala | not this world (home) — two Bindu arrivals; both live in Home |
| G1-0592 | mandala | not this world (her-home) |
| G1-0593 | rings | not this world (her-home) |
| G1-0599 | rings | placed (§2 R0-06) |
| G1-0602 | mandala | placed (§2 M04, M50) |
| G1-0605 | mandala | placed (§2 M16) |
| G1-0608 | rings | placed (§2 R0-10) |
| G1-0611 | rings | placed (§2 R1-01) |
| G1-0612 | rings | placed (§2 R2-01) |
| G1-0613 | rings | placed (§2 R3-01) |
| G1-0614 | rings | placed (§2 R4-01) |
| G1-0615 | rings | placed (§2 R5-01) |
| G1-0616 | rings | placed (§2 R6-01) |
| G1-0617 | rings | placed (§2 R7-01) |
| G1-0618 | rings | placed (§2 R8-01) |
| G1-0619 | rings | placed (§2 R9-01) |
| G1-0620 | rings | placed (§2 M05) |
| G1-0621 | mandala | placed (§2 M00, M03) |
| G1-0623 | rings | placed (§2 R7-01) |
| G1-0624 | rings | placed (§2 R0-02) |
| G1-0625 | rings | placed (§2 R0-03) |
| G1-0626 | rings | merged into M02 (eyebrow names where he stands; Home is the Bindu) |
| G1-0641 | rings | placed (§2 R0-01) |
| G1-0642 | rings | placed (§2 R1-01) |
| G1-0643 | rings | placed (§2 R2-01) |
| G1-0644 | rings | placed (§2 R3-01) |
| G1-0645 | rings | placed (§2 R4-01) |
| G1-0646 | rings | placed (§2 R5-01) |
| G1-0647 | rings | placed (§2 R6-01) |
| G1-0648 | rings | placed (§2 R7-01, R7-05) |
| G1-0649 | rings | placed (§2 R8-01) |
| G1-0650 | rings | placed (§2 R9-01) |
| G1-0651 | mandala | placed (§2 M06, M08) |
| G1-0654 | mandala | placed (§2 M01) |
| G1-0655 | mandala | placed (§2 M05, M06) |
| G1-0660 | rings | placed (§2 M05) |
| G1-0665 | mandala | rejected (superseded v1 lotus with TODAY label; v2 held yantra M01 governs) |
| G1-0668 | mandala | rejected (floor: '{active} of {total} Active' counts about him) |
| G1-0672 | mandala+rings | placed (§2 R0-03) |
| G1-0673 | mandala+rings | placed (§2 M05, M07) |
| G1-0674 | mandala | placed (§2 M01, M06) |
| G1-0675 | mandala | rejected (floor: progress count; 'Ring 3 Open · Rings 4–9 Ahead' gating, ruling 16) |
| G1-0676 | rings | placed (§2 R0-03) |
| G1-0678 | rings | not this world (today-rite) |
| G1-0682 | mandala | placed (§2 M16, M34) |
| G1-0683 | mandala+rings | placed (§2 M16, M18) |
| G1-0684 | mandala | placed (§2 M02, M03, M04) |
| G1-0685 | mandala | placed (§2 M14, M15) |
| G1-0686 | mandala | placed (§2 M16) |
| G1-0687 | mandala+rings | placed (§2 M17) |
| G1-0688 | mandala | placed (§2 M19) |
| G1-0689 | mandala+rings | placed (§2 M20) |
| G1-0690 | mandala | placed (§2 M51) |
| G1-0691 | mandala+rings | placed (§2 M18) |
| G1-0692 | mandala+rings | placed (§2 M21) |
| G1-0693 | mandala | placed (§2 M01) |
| G1-0694 | mandala | placed (§2 M17, M51) |
| G1-0695 | mandala | placed (§2 M15) |
| G1-0696 | mandala+rings | placed (§2 M51) |
| G1-0697 | mandala | not this world (climb) |
| G1-0698 | rings | placed (§2 R0-01) |
| G1-0699 | rings | merged into R7-04 / R8-02 (ring-world CSS timings) |
| G1-0700 | rings | placed (§2 R0-09) |
| G1-0701 | rings | placed (§2 R0-10) |
| G1-0702 | rings | placed (§2 R0-11, R2-07) |
| G1-0703 | rings | placed (§2 R2-01) |
| G1-0704 | rings | placed (§2 R2-03) |
| G1-0705 | rings | placed (§2 R7-01) |
| G1-0706 | rings | placed (§2 R7-04) |
| G1-0707 | rings | placed (§2 R7-04) |
| G1-0708 | rings | placed (§2 R8-01) |
| G1-0709 | rings | merged into R1-01, R3-01, R4-01, R5-01, R6-02, R9-03 (instruction lines) |
| G1-0710 | rings | placed (§2 R1-02) |
| G1-0711 | rings | placed (§2 R1-01) |
| G1-0712 | rings | placed (§2 R1-02) |
| G1-0713 | rings | placed (§2 R1-03) |
| G1-0714 | rings | placed (§2 R1-03) |
| G1-0715 | rings | placed (§2 R1-03) |
| G1-0716 | rings | merged into R3-01…R6-03 (Ring-Worlds III shared chrome/audio) |
| G1-0717 | rings | placed (§2 R3-01) |
| G1-0718 | rings | placed (§2 R4-01) |
| G1-0719 | rings | placed (§2 R5-01) |
| G1-0720 | rings | placed (§2 R6-01) |
| G1-0721 | rings | placed (§2 R9-01) |
| G1-0722 | mandala+rings | placed (§2 R9-02) |
| G1-0723 | rings | placed (§2 R9-05) |
| G1-0724 | rings | placed (§2 M49) |
| G1-0725 | rings | placed (§2 R9-02) |
| G1-0726 | rings | placed (§2 R9-03) |
| G1-0753 | mandala | placed (§2 M10) |
| G1-0771 | mandala | placed (§2 M00) |
| G1-0772 | mandala | placed (§2 M00) |
| G1-0773 | rings | placed (§2 R0-01) |
| G1-0774 | mandala | placed (§2 M00) |
| G1-0775 | mandala+rings | placed (§2 M20) |
| G1-0776 | rings | placed (§2 R0-01) |
| G1-0777 | rings | placed (§2 M05) |
| G2-0005 | rings | placed (§2 R2-04) |
| G2-0008 | mandala | placed (§2 M07) |
| G2-0010 | rings | placed (§2 R2-04) |
| G2-0011 | mandala+rings | placed (§2 M01, R2-04) |
| G2-0012 | mandala | placed (§2 M01) |
| G2-0013 | mandala | placed (§2 M06) |
| G2-0018 | mandala | rejected (floor: '5 of 16 Active' count) |
| G2-0036 | mandala | rejected (floor: progress text; superseded) |
| G2-0045 | rings | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G2-0053 | mandala+rings | placed (§2 R0-01) |
| G2-0057 | rings | placed (§2 R2-04) |
| G2-0058 | mandala+rings | placed (§2 M05) |
| G2-0063 | rings | placed (§2 R0-01) |
| G2-0066 | rings | placed (§2 R0-01) |
| G2-0067 | rings | placed (§2 R1-01) |
| G2-0068 | rings | placed (§2 R3-01) |
| G2-0069 | rings | placed (§2 R4-01) |
| G2-0070 | rings | placed (§2 R5-01) |
| G2-0071 | rings | placed (§2 R6-01) |
| G2-0072 | rings | placed (§2 R9-01) |
| G2-0073 | rings | placed (§2 R0-11) |
| G2-0075 | rings | placed (§2 R0-15) |
| G2-0076 | rings | placed (§2 R2-01) |
| G2-0077 | rings | placed (§2 R7-01) |
| G2-0078 | rings | placed (§2 R8-01) |
| G2-0083 | rings | merged into §4 data contract (Avaraṇa records) |
| G2-0087 | mandala+rings | placed (§2 R0-02) |
| G2-0088 | mandala | placed (§2 M08) |
| G2-0090 | mandala | placed (§2 M09) |
| G2-0091 | mandala | placed (§2 M01) |
| G2-0092 | mandala | rejected (legibility floor: 7.5/6.5 pt labels at .30) — held image is label-less |
| G2-0095 | rings | placed (§2 R0-03) |
| G2-0097 | rings | placed (§2 R0-03) |
| G2-0098 | mandala | placed (§2 M01) |
| G2-0099 | rings | placed (§2 R2-02) |
| G2-0107 | mandala | rejected (historical defect, view deleted) |
| G2-0111 | mandala | rejected (moot, LotusMandalaView deleted) |
| G2-0117 | mandala | placed (§2 M08) |
| G2-0118 | mandala | placed (§2 M14) |
| G2-0119 | rings | placed (§2 R0-01) |
| G2-0132 | rings | placed (§2 R0-15) |
| G2-0133 | rings | placed (§2 R1-02) |
| G2-0134 | rings | placed (§2 R3-02) |
| G2-0135 | rings | placed (§2 R6-01) |
| G2-0136 | rings | placed (§2 R7-01) |
| G2-0137 | rings | placed (§2 R9-04) |
| G2-0143 | rings | placed (§2 R0-15) |
| G2-0150 | rings | placed (§2 R0-03) |
| G2-0151 | rings | placed (§2 R0-04) |
| G2-0164 | rings | placed (§2 R0-01) |
| G2-0180 | mandala | placed (§2 M22) |
| G2-0182 | rings | placed (§2 R0-15) |
| G2-0195 | rings | placed (§2 R0-03) |
| G2-0196 | mandala+rings | placed (§2 R0-01) |
| G2-0197 | mandala | placed (§2 M18) |
| G2-0208 | mandala | placed (§2 M40) |
| G2-0209 | rings | placed (§2 R0-01) |
| G2-0211 | mandala | placed (§2 M22) |
| G2-0213 | rings | placed (§2 R7-02) |
| G2-0217 | rings | placed (§2 R0-13) |
| G2-0219 | rings | placed (§2 R0-05, R0-07) |
| G2-0227 | rings | placed (§2 R0-08, R1-05) |
| G2-0230 | rings | placed (§2 R0-13) |
| G2-0233 | mandala | placed (§2 M11) |
| G2-0237 | rings | placed (§2 R0-13) |
| G2-0238 | rings | placed (§2 R0-02) |
| G2-0243 | rings | placed (§2 R1-03) |
| G2-0244 | rings | placed (§2 R2-04) |
| G2-0245 | rings | merged into R3-01, R4-01, R5-01, R6-01 (rosters kp 45–86 from cards) |
| G2-0246 | rings | placed (§2 R7-02) |
| G2-0247 | rings | merged into R8-01 (triad 99–101) and R9-03 (ring 9 phrase noted §7) |
| G2-0252 | rings | placed (§2 R0-13) |
| G2-0253 | rings | placed (§2 R0-08) |
| G2-0257 | rings | not this world (her-home) |
| G2-0266 | rings | placed (§2 R9-01) |
| G2-0275 | rings | not this world (her-home) |
| G2-0277 | rings | not this world (her-home) |
| G2-0284 | rings | placed (§2 R0-13) |
| G2-0302 | rings | placed (§2 R0-01) |
| G2-0315 | mandala+rings | placed (§2 M01) |
| G2-0327 | mandala | placed (§2 M37) |
| G2-0340 | rings | placed (§2 R0-11) |
| G2-0357 | mandala | placed (§2 M00) |
| G2-0368 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0372 | rings | not this world (memory / well / modes) — landings list |
| G2-0374 | mandala | placed (§2 M24) |
| G2-0375 | mandala+rings | placed (§2 R0-01) |
| G2-0377 | rings | merged into R7-01 (Ring 7 mudrā Khecharī, settled) |
| G2-0378 | mandala | placed (§2 M11) |
| G2-0382 | mandala | placed (§2 M01) |
| G2-0384 | mandala | placed (§2 M24) |
| G2-0389 | mandala | placed (§2 M24) |
| G2-0390 | mandala+rings | placed (§2 R0-01) |
| G2-0394 | mandala+rings | placed (§2 R2-01) |
| G2-0395 | rings | placed (§2 R8-01) |
| G2-0401 | mandala | placed (§2 M28) |
| G2-0402 | mandala | placed (§2 M23) |
| G2-0403 | mandala | not this world (home) — F10 Lalitā bloom is Home's frame; M40 hands off to it |
| G2-0404 | rings | not this world (climb) |
| G2-0408 | rings | placed (§2 R4-01) |
| G2-0409 | rings | placed (§2 R4-01) |
| G2-0410 | rings | placed (§2 R4-01) |
| G2-0411 | rings | placed (§2 R0-01) |
| G2-0412 | rings | placed (§2 R3-01) |
| G2-0413 | rings | placed (§2 R3-01) |
| G2-0414 | rings | placed (§2 R3-02) |
| G2-0415 | rings | placed (§2 R4-02) |
| G2-0416 | rings | placed (§2 R4-02) |
| G2-0417 | rings | placed (§2 R5-02) |
| G2-0418 | rings | placed (§2 R6-02) |
| G2-0419 | rings | placed (§2 R7-01) |
| G2-0420 | rings | placed (§2 R8-01) |
| G2-0421 | rings | placed (§2 R9-01) |
| G2-0422 | rings | placed (§2 M49) |
| G2-0423 | rings | placed (§2 R1-01) |
| G2-0424 | rings | placed (§2 R1-01) |
| G2-0425 | rings | placed (§2 R1-01) |
| G2-0426 | rings | placed (§2 R1-03) |
| G2-0427 | rings | placed (§2 R2-01) |
| G2-0428 | rings | placed (§2 R2-01) |
| G2-0429 | mandala | rejected (F36 is a 'before' frame, not a target; counts and tab bar dead) |
| G2-0430 | mandala | placed (§2 M01) |
| G2-0431 | mandala | placed (§2 M15) |
| G2-0432 | mandala | placed (§2 M16) |
| G2-0437 | rings | placed (§2 R0-03) |
| G2-0438 | mandala+rings | placed (§2 R0-01) |
| G2-0444 | mandala | placed (§2 M28) |
| G2-0445 | rings | placed (§2 R2-04) |
| G2-0446 | rings | placed (§2 R2-04) |
| G2-0447 | rings | placed (§2 R7-02) |
| G2-0448 | rings | placed (§2 R0-02) |
| G2-0449 | mandala | placed (§2 M05) |
| G2-0456 | rings | placed (§2 R3-02) |
| G2-0468 | rings | placed (§2 R9-04) |
| G2-0470 | mandala | placed (§2 M40) |
| G2-0473 | mandala | placed (§2 M35) |
| G2-0516 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0549 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0590 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0599 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0607 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0615 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0623 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0631 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0639 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0647 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0655 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0664 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0672 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0680 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0688 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0696 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0704 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0712 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0720 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0728 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0736 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0744 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0752 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0760 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0768 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0776 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0784 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0792 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0800 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0808 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0816 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0825 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0833 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0837 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0844 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G2-0877 | mandala | not this world (game) |
| G2-0905 | rings | placed (§2 R0-04) |
| G3-0161 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G3-0233 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G3-0362 | mandala | placed (§2 M00, M22) |
| G3-0375 | rings | placed (§2 R0-01) |
| G3-0378 | mandala | placed (§2 M00) |
| G3-0395 | rings | placed (§2 R0-04) |
| G3-0406 | mandala | placed (§2 M00, M22) |
| G3-0413 | mandala | placed (§2 M00) |
| G3-0418 | mandala+rings | placed (§2 R0-01) |
| G3-0426 | mandala | placed (§2 M12) |
| G3-0476 | mandala | placed (§2 M00, M22) |
| G3-0505 | mandala+rings | placed (§2 R0-01) |
| G3-0510 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G3-0517 | mandala | placed (§2 M46) |
| G3-0528 | mandala | placed (§2 M00) |
| G3-0534 | mandala | placed (§2 M46) |
| G4-0030 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G4-0035 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G4-0254 | mandala | not this world (climb) |
| G4-0306 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G4-0336 | rings | placed (§2 R0-11) |
| G4-0452 | mandala | placed (§2 M40) |
| G4-0457 | mandala | rejected (ruling 12: journey set not among his GitHub recordings) |
| G4-0469 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G4-0470 | mandala | not this world (memory) — constellation recedes at a dance's apex |
| G4-0572 | rings | not this world (beneath) — koshas as concentric shells |
| G4-0583 | mandala | not this world (home) — header dot at beat Hz; seat pips belong to the 33's dances |
| G4-0587 | rings | placed (§2 R0-17) |
| G4-0615 | rings | rejected (one tuning: Design's ring roots; chakra-key carriers stay in the 33's dances) |
| G4-0618 | mandala | placed (§2 M49) |
| G4-0625 | rings | placed (§2 R0-17) |
| G4-0627 | rings | not this world (her-home) |
| G4-0691 | mandala | placed (§2 M16) |
| G4-0703 | mandala | placed (§2 M42) |
| G4-0704 | mandala | placed (§2 M16) |
| G4-0706 | mandala | placed (§2 R2-06) |
| G4-0733 | rings | placed (§2 R6-02) |
| G4-0766 | mandala | placed (§2 M16) |
| G4-0767 | rings | placed (§2 R0-14) |
| G4-0769 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G4-0782 | mandala | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G4-0787 | mandala+rings | placed (§2 R0-16) |
| G4-0799 | mandala | placed (§2 M48) |
| G4-0801 | mandala | not this world (climb) |
| G4-0859 | mandala | placed (§2 M25) |
| G4-0860 | mandala | not this world (game) |
| G4-0861 | mandala | placed (§2 R2-06) |
| G4-0876 | mandala | placed (§2 M15) |
| G5-0003 | mandala+rings | merged into §4 data contract (Learning topics) |
| G5-0007 | mandala+rings | merged into §4 data contract (Learning records L-1533/1537) |
| G5-0056 | mandala+rings | placed (§2 M42) |
| G5-0071 | mandala | placed (§2 M22) |
| G5-0153 | mandala | placed (§2 M38) |
| G5-0171 | mandala+rings | placed (§2 M35) |
| G5-0172 | mandala | placed (§2 M13, M38) |
| G5-0173 | mandala+rings | placed (§2 M05) |
| G5-0174 | mandala+rings | placed (§2 M18) |
| G5-0198 | mandala | not this world (game) |
| G5-0253 | rings | placed (§2 R0-16) |
| G5-0257 | mandala | placed (§2 M48) |
| G5-0276 | mandala+rings | placed (§2 R0-16) |
| G5-0305 | mandala+rings | placed (§2 R0-13) |
| G5-0306 | rings | placed (§2 R2-06) |
| G5-0325 | mandala | placed (§2 M31) |
| G5-0328 | mandala+rings | placed (§2 R0-13) |
| G5-0353 | mandala | placed (§2 M16) |
| G5-0397 | mandala | placed (§2 M39) |
| G5-0399 | mandala | not this world (climb) |
| G5-0400 | mandala | placed (§2 M41) |
| G5-0401 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G5-0403 | rings | placed (§2 R0-10) |
| G5-0416 | rings | placed (§2 R9-05) |
| G5-0417 | rings | placed (§2 R0-11) |
| G5-0419 | mandala | placed (§2 M01) |
| G5-0427 | mandala | placed (§2 M40) |
| G5-0440 | mandala+rings | placed (§2 M33) |
| G5-0441 | rings | placed (§2 R0-13) |
| G5-0442 | rings | placed (§2 R0-03) |
| G5-0443 | mandala | placed (§2 M34) |
| G5-0450 | rings | not this world (game) |
| G5-0482 | mandala | merged into §7 settled (61-name roster: Airtable cards win) |
| G5-0484 | mandala+rings | placed (§2 M50, R0-02) |
| G5-0485 | mandala | placed (§2 M05) |
| G5-0515 | mandala | placed (§2 M50) |
| G5-0516 | rings | placed (§2 R0-02) |
| G5-0528 | mandala | placed (§2 M40) |
| G5-0562 | rings | placed (§2 R0-01) |
| G5-0651 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G5-0660 | mandala | not this world (her-presence) — cinematic viewer gesture engine |
| G5-0682 | mandala | placed (§2 M47) |
| G5-0731 | mandala+rings | merged into R0-13 (L-1537 stations) |
| G5-0816 | mandala | to Bindu Feed (Ādi Śaṅkara, Saundaryalaharī lineage story) |
| G5-0933 | rings | to Bindu Feed (Atlantis narrative) — the nine-dimension glosses stay as R0-16's lens |
| G5-0995 | mandala | to Bindu Feed (Śrī Vidyā fable) — lineage ground also for Beneath |
| G5-1029 | rings | placed (§2 R2-06) |
| G5-1108 | rings | merged into R0-13 (Learning: Ten Mahāvidyās as a station reading) |
| G5-1146 | mandala | to Bindu Feed (Abhinavagupta story) — pratyabhijñā as Beneath's reading |
| G5-1151 | mandala+rings | merged into R0-13 (Learning: The Shri Yantra) |
| G5-1159 | mandala | placed (§2 M48) |
| G5-1198 | mandala | placed (§2 M48) |
| G5-1203 | mandala | placed (§2 M48) |
| G6-0003 | rings | placed (§2 R0-13) |
| G6-0010 | rings | placed (§2 R0-13) |
| G6-0017 | rings | placed (§2 R0-13) |
| G6-0024 | rings | placed (§2 R0-13) |
| G6-0031 | rings | placed (§2 R0-13) |
| G6-0038 | rings | placed (§2 R0-13) |
| G6-0045 | rings | placed (§2 R0-13) |
| G6-0052 | rings | placed (§2 R0-13) |
| G6-0059 | rings | placed (§2 R0-13) |
| G6-0067 | rings | placed (§2 R0-13) |
| G6-0075 | rings | placed (§2 R0-13) |
| G6-0083 | rings | placed (§2 R0-13) |
| G6-0091 | rings | placed (§2 R0-13) |
| G6-0099 | rings | placed (§2 R0-13) |
| G6-0107 | rings | placed (§2 R0-13) |
| G6-0115 | rings | placed (§2 R0-13) |
| G6-0123 | rings | placed (§2 R0-13) |
| G6-0131 | rings | placed (§2 R0-13) |
| G6-0139 | rings | placed (§2 R0-13) |
| G6-0147 | rings | placed (§2 R0-13) |
| G6-0155 | rings | placed (§2 R0-13) |
| G6-0162 | rings | placed (§2 R0-13) |
| G6-0169 | rings | placed (§2 R0-13) |
| G6-0176 | rings | placed (§2 R0-13) |
| G6-0183 | rings | placed (§2 R0-13) |
| G6-0190 | rings | placed (§2 R0-13) |
| G6-0197 | rings | placed (§2 R0-13) |
| G6-0204 | rings | placed (§2 R0-13) |
| G6-0211 | rings | placed (§2 R0-13) |
| G6-0218 | rings | placed (§2 R0-13) |
| G6-0225 | rings | placed (§2 R0-13) |
| G6-0232 | rings | placed (§2 R0-13) |
| G6-0239 | rings | placed (§2 R0-13) |
| G6-0310 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0312 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0314 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0316 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0318 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0320 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0322 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0324 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0326 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0328 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0330 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0332 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0334 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0336 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0338 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0340 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0342 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0344 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0346 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0348 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0350 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0352 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0354 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0356 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0358 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0360 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0362 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0364 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0366 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0368 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0370 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0372 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0374 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0434 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0435 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0436 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0437 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0438 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0439 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0440 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0441 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0442 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0489 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0509 | rings | placed (§2 R1-03) |
| G6-0510 | mandala+rings | placed (§2 R0-13) |
| G6-0511 | mandala+rings | placed (§2 R0-13) |
| G6-0512 | mandala+rings | placed (§2 R0-13) |
| G6-0513 | mandala+rings | placed (§2 R0-13) |
| G6-0514 | mandala+rings | placed (§2 R0-13) |
| G6-0515 | mandala+rings | placed (§2 R0-13) |
| G6-0516 | mandala+rings | placed (§2 R0-13) |
| G6-0517 | mandala+rings | placed (§2 R0-13) |
| G6-0518 | mandala+rings | placed (§2 R0-13) |
| G6-0519 | mandala+rings | placed (§2 R0-13) |
| G6-0520 | rings | placed (§2 R1-03) |
| G6-0528 | rings | placed (§2 R7-07) |
| G6-0569 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0581 | rings | not this world (climb) |
| G6-0583 | rings | placed (§2 R7-07) |
| G6-0589 | rings | placed (§2 R1-04) |
| G6-0590 | mandala+rings | placed (§2 R0-13) |
| G6-0591 | rings | placed (§2 R2-05, R7-06) |
| G6-0611 | rings | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0618 | rings | merged into R0-04 / R7-01 (āvaraṇa-7 mudrā = Khecharī, settled) |
| G6-0648 | mandala+rings | merged into §4 data contract (Mandala table) |
| G6-0687 | rings | placed (§2 R0-18) |
| G6-0688 | rings | placed (§2 R0-18) |
| G6-0689 | rings | placed (§2 R0-18) |
| G6-0690 | rings | placed (§2 R0-18) |
| G6-0691 | rings | placed (§2 R0-18) |
| G6-0692 | rings | placed (§2 R0-18) |
| G6-0693 | rings | placed (§2 R0-18) |
| G6-0694 | rings | placed (§2 R0-18) |
| G6-0695 | rings | placed (§2 R0-18) |
| G6-0726 | rings | not this world (relationship) — each person carries a Śakti (ruling 11) |
| G6-0747 | rings | placed (§2 R0-18) |
| G6-0775 | rings | placed (§2 R0-18) |
| G6-0790 | mandala+rings | placed (§2 R0-13) |
| G6-0793 | mandala | placed (§2 R0-06) |
| G6-0794 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0795 | mandala+rings | placed (§2 R0-13) |
| G6-0796 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G6-0799 | mandala | placed (§2 R2-04) |
| G6-0800 | mandala | placed (§2 M18) |
| G6-0802 | rings | merged into R0-13 (KhadgamalaMap spans 1–28 … 102) |
| G6-0814 | mandala+rings | placed (§2 R0-11) |
| G6-0815 | mandala+rings | placed (§2 R0-11) |
| G6-0819 | rings | placed (§2 R0-11) |
| G6-0821 | mandala+rings | placed (§2 M36) |
| G6-0823 | mandala | placed (§2 M08) |
| G6-0829 | mandala+rings | placed (§2 R0-06) |
| G6-0830 | mandala | placed (§2 R0-06) |
| G6-0832 | mandala | placed (§2 R0-06) |
| G6-0854 | mandala+rings | placed (§2 R0-03, R0-08) |
| G6-0856 | rings | placed (§2 R0-17) |
| G6-0860 | mandala+rings | placed (§2 M11) |
| G6-0872 | mandala+rings | placed (§2 R0-11) |
| G6-0875 | rings | placed (§2 R8-03) |
| G6-0876 | mandala+rings | placed (§2 M36) |
| G6-0893 | mandala+rings | placed (§2 R0-06) |
| G6-0895 | mandala | placed (§2 R0-06) |
| G6-0900 | rings | placed (§2 R0-13) |
| G6-0901 | mandala+rings | placed (§2 R0-03) |
| G6-0903 | mandala | placed (§2 M11) |
| G6-0939 | rings | placed (§2 R0-11) |
| G6-0941 | mandala+rings | placed (§2 R0-06, R9-03) |
| G6-0944 | rings | merged into R7-01 (world named 'the Vāk Chamber'; form stays 'Vāk Ring') |
| G6-0945 | rings | merged into R0-13 (Map wording 'Outer 10 Triangles' in facts) |
| G6-0961 | rings | placed (§2 R0-12) |
| G6-0968 | rings | placed (§2 R0-04, R9-03) |
| G6-1035 | rings | not this world (climb) |
| G6-1048 | mandala | placed (§2 M32) |
| G6-1049 | mandala | not this world (today-rite) |
| G6-1050 | mandala | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G6-1051 | mandala | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G6-1052 | mandala | not this world (her-presence) |
| G6-1053 | mandala | not this world (her-home) |
| G6-1054 | mandala | not this world (climb) |
| G6-1066 | rings | placed (§2 R0-14) |
| G7-0009 | mandala | placed (§2 M44) |
| G7-0013 | mandala+rings | placed (§2 R0-01) |
| G7-0014 | mandala | placed (§2 M44) |
| G7-0015 | mandala | placed (§2 M37) |
| G7-0016 | mandala | placed (§2 M12) |
| G7-0017 | mandala | placed (§2 M22) |
| G7-0018 | mandala | placed (§2 M32) |
| G7-0019 | mandala | placed (§2 M40) |
| G7-0020 | mandala | placed (§2 M37) |
| G7-0021 | mandala | placed (§2 M37) |
| G7-0022 | mandala | placed (§2 M23) |
| G7-0023 | mandala | placed (§2 M16) |
| G7-0024 | mandala+rings | placed (§2 M35) |
| G7-0025 | mandala | placed (§2 M45) |
| G7-0026 | mandala+rings | placed (§2 MX15) |
| G7-0027 | mandala | placed (§2 MX12) |
| G7-0029 | mandala | placed (§2 M24) |
| G7-0030 | mandala | placed (§2 M27) |
| G7-0031 | mandala | placed (§2 M04, M29) |
| G7-0032 | mandala | placed (§2 M30) |
| G7-0033 | mandala | placed (§2 M30) |
| G7-0034 | mandala+rings | placed (§2 M30) |
| G7-0035 | mandala | placed (§2 M24) |
| G7-0036 | mandala | placed (§2 M24) |
| G7-0037 | mandala | placed (§2 M25) |
| G7-0038 | mandala | placed (§2 M25) |
| G7-0039 | mandala | placed (§2 M26) |
| G7-0040 | mandala | placed (§2 M12) |
| G7-0041 | mandala | placed (§2 M24) |
| G7-0042 | mandala | placed (§2 M25) |
| G7-0043 | mandala | placed (§2 M22) |
| G7-0044 | mandala+rings | placed (§2 M05) |
| G7-0045 | mandala | placed (§2 M28) |
| G7-0046 | mandala | placed (§2 M08) |
| G7-0047 | mandala | placed (§2 M08) |
| G7-0048 | mandala | placed (§2 M18) |
| G7-0049 | mandala | placed (§2 M14) |
| G7-0050 | mandala | placed (§2 M15) |
| G7-0051 | mandala+rings | placed (§2 M17) |
| G7-0052 | mandala | placed (§2 M17) |
| G7-0053 | mandala | placed (§2 M19) |
| G7-0054 | mandala | placed (§2 M15) |
| G7-0055 | mandala | placed (§2 M16) |
| G7-0056 | mandala | placed (§2 M16) |
| G7-0057 | mandala | placed (§2 M16) |
| G7-0058 | mandala | placed (§2 M16) |
| G7-0059 | mandala | placed (§2 M16) |
| G7-0060 | mandala | placed (§2 M15) |
| G7-0061 | mandala+rings | placed (§2 M20) |
| G7-0062 | rings | placed (§2 R0-03) |
| G7-0063 | mandala+rings | placed (§2 M21) |
| G7-0064 | mandala | placed (§2 MX13) |
| G7-0065 | mandala | rejected (ruling 10 lifts 'three quiet controls') |
| G7-0066 | mandala | placed (§2 MX13) |
| G7-0067 | mandala | placed (§2 MX15) |
| G7-0068 | mandala | placed (§2 MX01) |
| G7-0069 | mandala | placed (§2 MX01) |
| G7-0071 | mandala | placed (§2 MX02) |
| G7-0074 | mandala | placed (§2 MX03) |
| G7-0075 | mandala | placed (§2 MX02) |
| G7-0079 | mandala | placed (§2 MX03) |
| G7-0080 | rings | placed (§2 R0-04) |
| G7-0081 | rings | placed (§2 R0-06) |
| G7-0082 | mandala | placed (§2 MX14) |
| G7-0083 | mandala+rings | placed (§2 M20) |
| G7-0084 | mandala | placed (§2 M44) |
| G7-0085 | mandala | placed (§2 M13) |
| G7-0095 | mandala | placed (§2 M34) |
| G7-0096 | mandala | placed (§2 M43) |
| G7-0097 | mandala | placed (§2 M43) |
| G7-0098 | rings | placed (§2 R0-11) |
| G7-0168 | mandala | placed (§2 M34) |
| G7-0169 | mandala | placed (§2 M32) |
| G7-0170 | mandala | placed (§2 M34) |
| G7-0171 | mandala | placed (§2 M16) |
| G7-0172 | mandala | placed (§2 MX13) |
| G7-0173 | mandala | placed (§2 MX11) |
| G7-0174 | mandala | placed (§2 MX12) |
| G7-0175 | mandala | placed (§2 MX01) |
| G7-0176 | mandala | placed (§2 MX02) |
| G7-0177 | mandala | placed (§2 MX04) |
| G7-0178 | mandala | placed (§2 MX08) |
| G7-0179 | mandala | placed (§2 MX09) |
| G7-0186 | rings | placed (§2 R1-01) |
| G7-0187 | rings | placed (§2 R2-01) |
| G7-0188 | rings | placed (§2 R3-01) |
| G7-0189 | rings | placed (§2 R4-01) |
| G7-0190 | rings | placed (§2 R5-01) |
| G7-0191 | rings | placed (§2 R6-01) |
| G7-0192 | rings | placed (§2 R7-01) |
| G7-0193 | rings | placed (§2 R8-01) |
| G7-0194 | rings | placed (§2 R9-01) |
| G7-0195 | rings | placed (§2 R0-10) |
| G7-0196 | rings | placed (§2 R0-04) |
| G7-0197 | mandala | placed (§2 M01) |
| G7-0198 | mandala+rings | placed (§2 M35) |
| G7-0199 | mandala | placed (§2 M40) |
| G7-0200 | mandala | placed (§2 M33) |
| G7-0201 | mandala | placed (§2 MX01) |
| G7-0202 | mandala | placed (§2 MX02) |
| G7-0203 | mandala | placed (§2 MX03) |
| G7-0204 | mandala | placed (§2 MX04) |
| G7-0205 | mandala+rings | placed (§2 MX05) |
| G7-0206 | mandala+rings | placed (§2 MX06) |
| G7-0207 | mandala | placed (§2 MX08) |
| G7-0208 | mandala | placed (§2 MX09) |
| G7-0209 | mandala | placed (§2 MX10) |
| G7-0210 | mandala | placed (§2 MX11) |
| G7-0211 | mandala | placed (§2 MX12) |
| G7-0212 | mandala | placed (§2 MX13) |
| G7-0213 | mandala+rings | placed (§2 MX07) |
| G7-0341 | rings | not this world (climb) |
| G7-0342 | rings | placed (§2 R6-02) |
| G7-0343 | rings | not this world (climb) |
| G7-0344 | rings | not this world (climb) |
| G7-0345 | rings | not this world (climb) |
| G7-0346 | rings | placed (§2 R2-03) |
| G7-0546 | rings | placed (§2 R0-03) |
| G7-0547 | rings | placed (§2 R0-03) |
| G7-0548 | rings | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G7-0549 | rings | rejected (floor: seats.count printed) — Field retired, see G1-0517 |
| G7-0628 | mandala | placed (§2 M37) |
| G7-0629 | mandala | not this world (home) — mandala-descent.geom baseline moves with Lalitā |
| G7-0631 | rings | not this world (spine) — the Field list is retired as a screen; its rows live in the Veil, the ring worlds and search |
| G7-0643 | mandala | placed (§2 M43) |
| G7-0646 | mandala | placed (§2 M43) |
| G7-0651 | mandala | placed (§2 M25) |
| G7-0671 | mandala | placed (§2 M43) |
| G7-0678 | mandala | placed (§2 MX13) |
| G7-0680 | mandala | placed (§2 M22) |
| G7-0681 | mandala | placed (§2 M25) |
| G7-0682 | mandala | placed (§2 M24) |
| G7-0683 | mandala | placed (§2 M11) |
| G7-0684 | mandala | placed (§2 M43) |
| G7-0685 | mandala | placed (§2 M43) |
| G7-0687 | mandala | placed (§2 M08) |
| G7-0691 | rings | not this world (her-home) |
| G7-0697 | rings | placed (§2 R0-12) |
| G7-0700 | rings | not this world (her-home) |
| G7-0701 | rings | not this world (her-home) |
| G7-0702 | rings | not this world (her-home) |
| G7-0703 | rings | not this world (her-home) |
| G7-0704 | rings | not this world (her-home) |
| G7-0705 | rings | not this world (her-home) |
| G7-0706 | rings | not this world (her-home) |
| G7-0707 | rings | not this world (her-home) |
| G7-0708 | rings | not this world (her-home) |
| G7-0709 | rings | not this world (her-home) |
| G7-0710 | rings | not this world (her-home) |
| G7-0711 | rings | not this world (her-home) |
| G7-0949 | rings | placed (§2 R0-12) |
| G7-0950 | rings | placed (§2 R0-12) |
| G7-0951 | rings | placed (§2 R0-12) |
| G7-0952 | rings | placed (§2 R0-12) |
| G7-0953 | rings | placed (§2 R0-12) |
| G7-0954 | rings | placed (§2 R0-12) |
| G7-0955 | rings | placed (§2 R0-12) |
| G7-0956 | rings | placed (§2 R0-12) |
| G7-0957 | rings | placed (§2 R0-12) |
| G7-0960 | mandala | not this world (climb) |
| G7-0961 | rings | placed (§2 R0-04) |
| G7-0965 | mandala | placed (§2 M49) |
| G7-0967 | rings | placed (§2 R0-11) |
| G7-0968 | rings | placed (§2 R0-11) |
| G7-0970 | mandala | placed (§2 M36) |
| G7-0971 | rings | placed (§2 R0-18) |
| G7-0972 | mandala | placed (§2 M11) |
| G7-0973 | mandala | placed (§2 M24) |
| G7-0974 | mandala | placed (§2 M18) |
| G7-0978 | rings | not this world (her-home) |
| G7-0988 | mandala | not this world (the-33) — thread door from the ring worlds (R0-14, R7-07) |
| G7-1027 | rings | placed (§2 R0-04) |
| G7-1031 | mandala | placed (§2 M25) |
