# Wave 1 · Slice A — The Mandala

*12 October 2026 · Build Charter II (Emergence) · owns `iOS/Bindu Mandala/Views/Mandala/` and `Theme/MandalaLight.swift`*

The tiebreaker throughout: **when in doubt, build the fuller version; Design is the floor.**

---

## What came home from Design (restored)

### The full Śrī Yantra — `SriYantraGeometry.swift`
Design's `SriYantraGeometry()` (`living-rite-mandala.jsx`), element for element, at its own weights:

| Element | Design | Was in the port |
|---|---|---|
| Bhūpura, three squares | 1.0 / 0.94 / 0.88 R · 1.1 wide · 0.5 / 0.4 / 0.3 | kept |
| **Four T-gates** | notch 0.11 R either side, 0.05 R deep · 0.45 | **missing** |
| **Four circles** | 0.90 / 0.80 / 0.70 / 0.615 R · 0.8 wide · 0.30 → 0.24 | **missing** |
| **Sixteen-petal lotus** | 0.80 → 0.90 R · `lrPetalPath` · 0.34 | **missing** |
| **Eight-petal lotus** | 0.615 → 0.70 R, turned 22.5° · 0.36 | **missing** |
| Circle holding the star | 0.60 R · 1 wide · 0.4 | **missing** |
| **Nine triangles** | `SY_DOWN`/`SY_UP` at **0.585 R** · 0.5 | stretched to 1.0 R, at 0.34 |
| Bindu glow | 0.10 R, red 0.6 → 0, breathing | a fixed-size red haze |

`MandalaYantra.triangles` keeps its name, type and count (nine) — the spike census reads them — and is now taken of `R × 0.585`. Every path is built once (`static let`) in world space and placed per frame by one affine transform, so a drag costs a matrix multiply per layer.

**Stroke weights.** Design's strokes sat inside its scaled SVG layer, so they grew with the zoom. They do again (`w × scale`), floored at ¾ of the authored width at the widest view and capped at 4 pt at the deepest. No dimmer is stacked on a Design weight: the hour arrives as **one** ratio against noon (below), and noon is exactly Design.

### The indigo night ground — `MandalaSky.swift`
Design's sky (`radial-gradient(circle at 50% 44%, #0a0611, #050308 60%, #030105)`) with the day's glow ellipse (80% × 55% at 50% 44%, gone by 66%), replacing the crimson-black `Color.ground`. The hour's `TIME_VARIANTS.ambient` stands in it. Stars are Design's `SY_STARS` behaviour: every fifth gold, four in ten twinkling 0.15 ↔ 0.7 on their own 5–11 s clocks, growing a little with the zoom. Design's `DustMotes` rise through the glass, as many as the hour carries (3 at the new moon, 12 at night).

### The 8 s shimmer, the Bindu ×1.28, nine breaths — `MandalaBreath.swift`
The table is `Mandala App v2.html`'s keyframes:

| ring | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 (Bindu) |
|---|---|---|---|---|---|---|---|---|---|
| breath | **holds** | 3 s | 8 s | 9 s | 11 s | 13 s | 15 s | 18 s | 4 s |
| lift | — | 28% | 70% | 47% | 50% | 57% | 55% | 86% | 33% |

Lifts are the ratio of each ring's own keyframes (lockR4 0.15 → 0.22 = 47%). The triangles keep their rings' breaths as `mandala-v2.jsx` pairs them — down *i* + up *i* for rings 4–7, the innermost down triangle alone as ring 8, the mūla trikoṇa that holds the point. Over all of it, `syShimmer` (0.82 ↔ 1, 8 s). The Bindu swells ×1.28 on the 4 s breath, its glow 0.75 → 1.

### The five time states — `TimeVariant.swift` (extended, nothing changed)
`home-mandala.jsx`'s `TIME_VARIANTS` existed in Swift but the living canvas never read them. Now: the sky leans with the hour (dawn violet, dusk rose, night blue, new moon near-black); the Bhūpura takes the hour's amber/silver; the triangles take `triStroke`; each element's strength is the hour's ratio against noon (`geometryGain`, `bhupuraGain`, `lotusGain`, `innerLotusGain`); seats take Design's `saturate()` (**new-moon desaturation to 30%**) and a quarter-depth `brightness()`; the Bindu takes `binduColor` and **`binduScale` (1.6× at the new moon)** and glows *brighter* as the rest recedes. Design's `TemporalMark` — one 6 pt point of the hour's light, no text — sits under the header. The hour is re-read every minute while he stays.

### Lalitā's red bloom — `LalitaSourceView.swift`
Design's four movements, in Design's order and pace: the **red bloom** (1400 across, `#8B1A2A` → 0.35 by 22% → gone by 60%, from 0.05 to full in 1.6 s, flaring to 1 and settling at 0.55 — `syDescendBloom`; it was gone); her **presence** with Design's stops (cream 0 · gold 34% · crimson 62% · gone 78%; the port had spread four stops evenly), rising from 0.2 then breathing ×1.28 on 6.5 s; the **returning field** at 0.82 of the seats; and the **words emerging from the light** on Design's 1.5 s → 3.3 s stagger (the port ran them 0.15 → 1.5 s, ahead of the bloom). The ground is Design's ellipse (`#2a0a12 → #12060b 55% → #060205`); the presence button its red→red-gold gradient.

### The Veil / Legend as light — `MandalaVeil.swift`
Restored from `veil-mandala.jsx` and `legend-explorations.jsx`: a peek at the foot of the glass (a breathing chevron and "THE NINE ĀVARAṆAS"), which rises as a veil of dark ground; the yantra dims behind it to about half, never hidden; the nine read outside-in, Ring I at the top, the Bindu as its footer, not a row. Design's five luminosities (here · open · ground · ahead · veiled): glyph light, glow, a gold wash on *here*, solid or dashed threshold lines, Roman numerals.

---

## What went beyond Design

- **Light stands in the air.** With the light on, every yantra line is three strokes — a wide glow, a near glow, the line — the glows additive (`plusLighter`), so crossings brighten as light does. Lines are lit by how much of the Bindu reaches them (`MandalaLight.reach`), so the star burns a little brighter than the square: the yantra lit from its own centre.
- **The felt state as warm light.** A felt seat wears a soft additive halo of `MandalaLight.feltWarmth` — her hue leaned a third toward the source and lifted. Asked of `Set<Int>` membership only.
- **Seats breathe as their enclosure breathes** (`syBreath` ×1.22 on the ring's clock, her position setting only her place in the breath), so the field moves as nine metabolisms rather than 102 random clocks; the Bhūpura's seats hold, as its ground does.
- **Light in the four gates** — a soft lamp in each doorway of the Bhūpura.
- **The enclosure bands, the constellation threads, the crossing flash, today's ring and the stars** all gained an additive glow; the flash took Design's `syRingFlash` envelope.
- **The Bindu rises at night and at the new moon** (`binduGlow`), the inverse of the geometry's fall.
- **One Bindu rhythm.** The Veil's footer point breathes on the Bindu's own 4 s ×1.28 (Design's audit: *"the bindu's breath isn't unified"*).
- **The returning field carries her light** — each of the 102 around Lalitā has a breath of her own hue round its gold point.
- **The sky has depth** — two far washes of air off the yantra's shoulders.

---

## What was lifted, and why

- **The Veil's ladder.** Design's statuses were home / unlocked / ancient / locked / deep ghost — a progress ladder. Under the surviving law (*nothing grades him or puts him behind*) the Veil's light is read **from where he is standing right now**: the ring the camera has fallen into, or today's ring while he is outside the yantra. Ring < here → ground; here; here + 1 → open; rings 8–9 beyond → veiled; the rest → further in. The same screen on the first day and the ten-thousandth; fall inward and the light moves with you. **Nothing is gated**: every row, ahead and veiled included, is a door — the camera falls to that āvaraṇa through the same space (`MandalaCamera.ringTarget`), and arriving is an ordinary crossing. The Bindu footer opens the descent. `MandalaYantraTests.testTheVeilCannotKnowWhatHeHasDone` reads the source to prove no felt state, crossing record, ledger or count can reach it.
- **The veil words keep FIDELITY's floor.** Design's veiled names went to 0.22 α. A name is a word he reads, so it stays ≥ 0.55; the veil is carried by the glyph (0.95 → 0.18, as Design drew it), the wash and the line.
- **The "flag gates a law" note in the canvas header** now says what is true: the phase flag gates the *light* (no `MandalaLightField`, no additive glow); the full yantra is drawn on both paths.
- **Tratak** now settles the shimmer and the nine breaths to their middle as the gaze holds (the field holds still, keeping its light), rather than only stilling the seats.

## What survives, untouched

The semantic-zoom camera and its guards; ring crossings (chimed, recorded once per new depth); Tratak (earned identically under reduce motion); the crossing bīja; the accessibility layer and its garland order (hidden while the Veil is raised, as it is during the descent); 44 pt targets (the peek is 48, every Veil row ≥ 44); the descent entry. Felt-ness is still `Set<Int>`; `feltRadius` / `unfeltRadius` are still the only two seat sizes; no practice count reaches any file here.

**Reduce motion:** the shimmer pauses at its brightest, the nine breaths hold at their middle, the Bindu rests at 1× with its glow lit, stars hold at a mid twinkle, motes stand still, the bloom and presence arrive settled, the Veil fades rather than slides.

## Tests

- **Added `MandalaYantraTests`** — the look held to Design's numbers: every yantra element present; the star inside its 0.60 R circle (true only at 0.585); petals where Design puts them; Design's true weights with noon a factor of exactly one; the triangle→ring breath map; the nine-breath table, its raised-cosine shape, reduce motion keeping the light; the 8 s shimmer and ×1.28 Bindu; seats breathing at their ring's rate and swelling equally; the new moon's 30% saturation and 1.6× Bindu; the hour as one bounded factor; `ringTarget` landing in the asked ring on three phone sizes; exactly one *here* wherever he stands; Veil words above the floor; the Veil unable to read what he has done; the felt halo warmer and still hers.
- **No existing test was rewritten.** `MandalaLightTests` (one guarded `MandalaLightField(` construction, `feltRadius`/`unfeltRadius`, no gemstone name, no count), `LawsDrawnMeasureTests`, `DynamicTypeTests` (the three canvas font pins are kept verbatim), `HitAreaIdiomTests` ("↑ return to the field" keeps its idiom) and `TimeVariantModulationTests` (the absolute palette is byte-unchanged) all still describe this code.

## Notes for the lead

- **`Views/Spike/MandalaDrawCensus.swift` is a hand-written replica of the canvas** and now under-describes it (it still counts the old 3 squares + 9 triangles and no glows/motes). Its tests keep passing because they measure the replica, not the canvas. It sits outside this slice; it should be retired with the composition lock or re-taken.
- `FeltRegisterSnapshots` will see the new peek button and the temporal mark on the Mandala; left untouched per the brief.
