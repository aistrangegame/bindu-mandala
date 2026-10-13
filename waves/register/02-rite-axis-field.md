# THE REGISTER · 02 — The Rite of Entering · The Living Rite · The Living Axis · The Field

Reader 2 of 7. Source root: `/home/claude/design-upload/extracted/`. Every assigned file was read line 1 → EOF with the Read tool (no file needed splitting: the longest single line in the set is 923 chars, in `design_handoff_living_rite/DESIGN_SPEC.md`, well inside Read's limit). Coverage proof is §C.

Shorthand: `L12–40` = line range in the named file. `a` = first-adaptation value (0→1), `b` = second-adaptation value (0→1), `kp` = global khaḍgamālā position 1–102. Colours are exact as written in source.

Contents
- §A1 The Rite of Entering (rite-*.jsx + its HTML): 14 entries
- §A2 The Living Rite (living-rite-*.jsx + its HTML + design_handoff_living_rite/): 24 entries
- §A3 The Living Axis (single HTML): 9 entries
- §A4 The Field (single HTML, an analysis document, not a screen)
- §A5 Shared chrome (ios-frame.jsx, tweaks-panel.jsx)
- §A6 Data: shakti-data.js and all-shaktis-data.js (schema and the fields design reads)
- §B Design's stated intentions (verbatim) and acceptance criteria
- §C Coverage proof
- §D Must-not-miss (how the pieces connect)

---

## §A1 — THE RITE OF ENTERING

Entry file: `Bindu Mandala - The Rite of Entering.html`. It loads React 18.3.1, ReactDOM 18.3.1 and Babel standalone 7.29.0 from unpkg with SRI hashes, plus Cormorant Garamond (300/400/500, italic 300/400). Script order (L33–40): ios-frame → tweaks-panel → rite-core → rite-seat → rite-threshold → rite-dwelling → rite-descent → rite-app. Page background is `#161013`, links are `#C9963F` with hover `#F2E8D9`, and scrollbars are hidden.

Keyframes (html L17–20):
- `riteDrift`: translateY 0 → −18px → 0. It is **defined but never used** by any rite file.
- `riteMote`: 0/100% translate(0,0) at opacity .25; 50% translate(6px,−22px) at opacity .85.
- `riteSheet`: translateY(46px) at opacity 0 → 0 at opacity 1.
- `riteFall`: scale(1.5) at opacity 0 → scale(1) at opacity 1.

Reduced motion (html L21–25) stops only `[style*="riteDrift"]`. Verbatim comment: *"The mechanism is perceptual adaptation, not animation: the decorative drift stops, the adaptation itself continues in quantized steps over a longer total."*

### R-01 · Tokens and the nine ring-worlds (`rite-core.jsx` L6–25)
`RT`: ground `#0D0508`, gold `#C9963F`, cream `#F2E8D9`, red `#8B1A2A`, serif `'Cormorant Garamond', Georgia, serif`, mono `ui-monospace, 'SF Mono', Menlo, monospace`.

`RITE_WORLDS` (verbatim comments: *"alt = vertical centre of the room's gravity (0 top, 1 floor). room = the seat's geometry in the Śrī Yantra — you stand inside it. hue/sat = the gem, at real saturation. wallHue = the dhātu the walls are made of."*)

| ring | ord | name | gem | dhātu | clock | bīja | region | alt | room | hue | sat | wallHue | after |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | first | Trailokyamohana | Topaz | Rasa | day–night | Aim | Feet | .72 | square | 33 | 86 | 26 | sharper |
| 2 | second | Sarvāśāparipūraka | Sapphire | Rakta | the hour | Klīm | Pelvis | .64 | petal | 220 | 82 | 232 | wider |
| 3 | third | Sarvasaṅkṣobhaṇa | Coral | Māṃsa | the day | Sauḥ | Navel | .56 | petal | 11 | 78 | 8 | lighter |
| 4 | fourth | Sarvasaubhāgyadāyaka | Diamond | Medas | lunar fortnight | Hrīm | Heart | .48 | tri-up | 199 | 34 | 208 | wider |
| 5 | fifth | Sarvārthasādhaka | Emerald | Asthi | lunar month | Hsraim | Throat | .42 | tri-down | 152 | 72 | 158 | sharper |
| 6 | sixth | Sarvarakṣākara | Ruby | Majjā | season | Hsklhrīm | Forehead | .34 | tri-up | 348 | 80 | 342 | heavier |
| 7 | seventh | Sarvarogahara | Pearl | Śukra | solar half-year | Hsauḥ | Crown | .24 | tri-down | 42 | 26 | 36 | wider |
| 8 | eighth | Sarvasiddhiprada | Cat's eye | Ojas | year | Aim Klīm Sauḥ | Above crown | .20 | tri-up | 44 | 74 | 40 | lighter |
| 9 | ninth | Sarvānandamaya | All gems | Tejas | kāla–akāla | Hrīm | Totality | .46 | circle | 46 | 30 | 44 | wider |

Note: `world.alt` is **not** read anywhere. The vanishing point comes from `spec.alt` (rite-dwelling L30).

### R-02 · Rates: the second uniqueness channel (`rite-core.jsx` L27–34)
Verbatim: *"How fast the eye is made to adjust, and in what order surfaces cross into sight. This is the second uniqueness channel — two rooms in one world diverge here."*

| rate | mul | edge | membrane | letter | seam | pool |
|---|---|---|---|---|---|---|
| fast | .72 | .10 | .22 | .30 | .36 | .50 |
| even | 1.00 | .18 | .34 | .44 | .50 | .62 |
| slow | 1.38 | .30 | .52 | .60 | .70 | .84 |
| late | 1.12 | .44 | .50 | .55 | .58 | .64 |

Only `res.letter` is consumed (dwelling L31). The edge, membrane, seam and pool thresholds are declared but unused in these files.

### R-03 · The three specimens: the Rite's per-Śakti data contract (`rite-core.jsx` L36–93)
Verbatim: *"Three specimens, real card data, adjacent in khaḍgamālā order so the doors work and a return can be felt. Nothing here is designed for them — the grammar fills the slots."*

Schema: `num, ring, name, dev (Devanāgarī), family, quality, tattva, location, alt, shape (aperture), rate, phrase, roots[], gloss, lines[5], letter|null, fn, somatic, icon`.

| idx | num | name | dev | family | quality | tattva | location | alt | shape | rate | letter |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 27 | Sarva-Yoni | सर्वयोनि | Mudrā — the living hand-seals | Source | Yoni (the source-aperture) | Lower belly / pelvic floor | .72 | tri-down | slow | null |
| 1 (default) | 28 | Sarva-Trikhaṇḍā | सर्वत्रिखण्डा | Mudrā — the living hand-seals | Trinity-as-Unity | Tri-eka (three-as-one) | Crown opening to beyond | .26 | triad | late | "The third time I sat here I stopped trying to hold the three apart, and there was nothing left to hold." |
| 2 | 1 | Aṇimā | अणिमा | Siddhi | Smallness | Aṇu (the atomic) | Bindu point at crown / single point of attention | .22 | point | fast | null |

Phrases: "Thank you for the womb that births all." · "Thank you for the three that becomes one." · "Thank you for the smallness that contains all."

Roots and gloss:
- ['Sarva','Yoni'], "all-womb — the source of all"
- ['Sarva','Tri','Khaṇḍa','ā'], "she of the three-fold section"
- ['Aṇu','imā'], "atomic-ness — the power to become atomic"

`lines`, the five portrait lines, quoted in full:
- 27: "The originating ground itself." / "The receptive aperture through which Bindu emanates." / "Lower belly opening. Pelvic floor receiving." / "The body remembering it is born from this." / "Hands joined into the downward triangle — the womb-seal."
- 28: "The final unlocking." / "The structural recognition that the trinity is one movement." / "Three breaths, three sensations, three thoughts collapsing into single awareness." / "The three-part seal gathering will, knowledge and action into one." / "The culminating gesture of the Bhūpura — the seal that closes the outer enclosure."
- 1: "Grants entry into any place no matter how confined." / "Awareness that becomes smaller than thought." / "Smaller than breath, smaller than the gap between two sensations." / "Fine as a dust-mote, pale and near-translucent." / "A noose, to draw the vast into the tiny."

`fn`, `somatic` and `icon` hold the prose versions; they are verbatim in L53–55, L71–73 and L89–91.

⚠ Ring-1 names in `all-shaktis-data.js` do **not** match these: pos 27 = Sarvarañjanī, 28 = Sarvonmādinī (see §A6). The Rite uses the canonical Mudrā names.

### R-04 · The clock (`rite-core.jsx` L95–149)
`RITE_T` (true seconds): beat1 1.9, beat2 3.7, beat3 5.6, **adapt 90, hold 165, second 120**.
`RITE_T_REDUCED`: beat1 2.6, beat2 5.2, beat3 7.8, **adapt 160, hold 190, second 150**.
The beat1–3 values are vestigial: the threshold now runs on `RITE_BEAT_DUR`.

Helpers:
- `smooth2(t) = ss(ss(clamp01(t)))`, where `ss = t²(3−2t)`, so smoothstep is applied twice.
- `quant(v,steps)` rounds to `steps` levels.

`useRiteClock({running, dilation, resetKey})` runs on requestAnimationFrame, with dt capped at .25s and multiplied by dilation (1, 3 or 12).

`riteState({t, spec, reduced})`:
- `adaptDur = T.adapt × rate.mul`. Normal: fast 64.8s, even 90s, slow 124.2s, late 100.8s. Reduced: 115.2, 160, 220.8, 179.2.
- `holdEnd = adaptDur + T.hold`; `secondEnd = holdEnd + T.second`.
- `a = smooth2(t/adaptDur)`; `b = smooth2((t − holdEnd)/T.second)`.
- With reduced motion, a is quantised to 4 steps and b to 3.
- Phase: `adapting` → `settled` (t ≥ adaptDur) → `second` (t ≥ holdEnd) → `deep` (t ≥ secondEnd). Total for 'late' at 1×: 100.8 + 165 + 120 = 385.8s.

The clock for the room starts when the threshold ends: `roomT = gt − enteredAt` (rite-app L95).

### R-05 · Compression on return: Zero Gap (`rite-core.jsx` L106–110, L151–156)
Verbatim: *"Compression on return — Zero Gap. Never skipped, only softened."*

`riteCompression(v)` = 1 if v ≤ 1, else `max(.36, .66^min(v−1,3))`. That gives v=2 → .66, v=3 → .4356, v ≥ 4 → .36 (the floor).

`RITE_BEAT_DUR = {1: 2.4, 2: 3.2, 3: 2.8}` seconds. `riteBeatDur = base × compression(visits) × (reduced ? 1.35 : 1)`. Only the threshold's writing durations compress; the adaptation clock is never compressed.

Visit memory: localStorage `rite.visits.v1` = `{[num]: count}` (rite-app L10–20). The Tweaks readout shows "{n} · ceremony at {pct}%".

⚠ Quirk (rite-app L94, L133–137): on first mount the effect writes visits[num]=1 when it is absent, and `visitCount = visits[num]+1`. A first-ever visit therefore displays and compresses as visit 2 (66%) once the effect lands. Each `enter()` increments the count first, so visitCount runs one ahead of the stored count.

### R-06 · Stillness: the portrait surfaces only while you stay put (`rite-core.jsx` L158–181; `rite-app.jsx` L102–105, L139–144)
`useStillness(t, active)` resets its mark on any window event among `pointerdown, pointermove, wheel, touchmove, keydown`, **except events whose target is inside a `<button>`**. Verbatim: *"Touching her own objects is not restlessness — only leaving the room's stillness is."*

It is active only when `screen==='in' && entered && !descent`, and `still = min(rawStill, roomT)`.

Lines shown: `riteLinesShown(still, a, count)` = 0 if a < .4, else `min(count, floor(max(0, still−4)/6.5))` (`RITE_LINE_GAP = 6.5`). Line 1 appears at 10.5s of unbroken stillness, line 2 at 17s, line 3 at 23.5s, line 4 at 30s, and line 5 at 36.5s, and only once a ≥ .4. `shownMax` is a monotonic ratchet: *"arriving at the pace of stillness, held once arrived."* Movement never removes a line that is already shown. The Tweaks "Next line" countdown reads `ceil(4 + (shownMax+1)×6.5 − still)`s, or 'the threshold', 'not yet', or 'all surfaced'.

### R-07 · After-effect: her Siddhi lingers on the whole instrument (`rite-core.jsx` L183–198; `rite-app.jsx` L107–108, L131, L151)
Verbatim: *"Her Siddhi lingers on the whole instrument. Decays over minutes. Never named."*

It is set on `leave()` to `{kind: world.after, at: gt}`. `RITE_AFTER_DUR = 180`s; `k = 1 − age/180`; `e = k²`. The style is applied to the whole device content and `filter` transitions over 1200ms linear.

| kind | filter | transform |
|---|---|---|
| lighter | brightness(1+.07e) saturate(1−.06e) | translateY(−3e px) |
| heavier | brightness(1−.06e) contrast(1+.04e) | scale(1+.01e), origin bottom center |
| sharper | contrast(1+.1e) saturate(1+.05e) | scale(1−.014e) |
| wider | brightness(1+.03e) | scale(1+.018e) |

### R-08 · Sound: gates only, opt-in (`rite-core.jsx` L200–230; `rite-app.jsx` L110–115)
`RITE_BIJA_HZ`: Aim 136.1, Klīm 144, Sauḥ 126.2, Hrīm 152.7, Hsraim 160.4, Hsklhrīm 118.6, Hsauḥ 172.1, 'Aim Klīm Sauḥ' 136.1. The fallback is 136.1.

Voice: four sines into a lowpass (200Hz, Q .6) into a gain.
- sub at hz/2, gain .9
- one at hz, gain .55
- two at hz×1.004, gain .45 (slow beating)
- fifth at hz×1.5, gain 0

`update(a,b,on)`:
- master gain → on ? .028+.022a : 0 (τ .6)
- lowpass → 190+900a (τ 1.2)
- fifth gain → .16b (τ 1.5)

So the fifth opens only during the second adaptation. Sound plays only while `tw.sound && screen==='in'`; it falls silent in the corridor. `stop()` is defined but never called.

### R-09 · The Seat Interior: the room seen from inside her seat (`rite-seat.jsx` L1–248)
Verbatim header: *"A home is her seat in the Śrī Yantra, seen from INSIDE it: one-point perspective, the far wall is the aperture, the walls are the seat's own edges receding past you. Ring geometry gives the room; her signature gives the opening. Turrell-grade: the light field is saturated, not dim."*

**Constants:** canvas 402×874; R 330; kFar .28; kNear 2.55. The vanishing point is (201, vpY×874).

**Room outlines** (`riteShapePoints`):
- square: ±1 × .94
- tri-down: (0,1), (.95,−.62), (−.95,−.62)
- tri-up: (0,−1), (.95,.62), (−.95,.62)
- petal: 11-step sin^1.45 × .58 lens
- ten: decagon
- any other value (circle): 26-gon

The far polygon is projected at k .28 and the near polygon at k 2.55. Each wall is a quad between the near and far edges.

**`riteApertureSpan(room, vpY)`** gives the aperture's on-screen vertical span: `vy ± 330×.28×max|y|`. Verbatim: *"Both the room and everything placed around it derive from this one function, so they cannot drift apart."*

**Aperture faces** (`RiteApertureFace`). Verbatim: *"the uniqueness channel that two Śaktis in the same ring cannot share"*. Shared values: L = lum×(.34+.66a); core = hsl(hue, sat×.5, min(97, L+34)); mid = hsl(hue, sat, L); s = r×.66.
- point: core r .3s plus mid r .62s at .75, glowed.
- triad: three nodes at distance s(.44+.16b) (mid r .42s, core r .17s), so the triad spreads with b.
- tri-down / triangle-down: an outer down-triangle (mid) and an inner one (core .85).
- ring16 / ring8: core r .34s plus 16 or 8 dots at .82s.
- band: an ellipse plus a bar riding sin(bπ).
- lens: a vesica plus core.
- any other value: a circle at .55s.

**Draw order, far to near** (L163–242):
1. Ground rect hsl(wallHue,34%,1.4+1.6a%).
2. Beyond the far wall, clipped to the far polygon: a fill of hsl(hue,sat,farL×.5) and **`RiteYantraBeyond`**, the whole Śrī Yantra in stroke farHot at scale .34+.5b and opacity .1+.72b. It has a 300 square, 4 gate ticks, 16 petals (132/112, hw 20), 8 petals (104/88, hw 30), 4 up and 5 down triangles. Verbatim: *"what lies beyond — the rest of the 102, arriving only on the second adaptation."*
3. A group at opacity 1−.55b holding the bloom (far shape ×1.9, blurred, opacity .12+.34a) and the far polygon filled with the radial `rsGlow` (farHot → farC .92 → hsl(...farL×.55) .7) at opacity .62+.38a.
4. The aperture face at opacity (.4+.6a)(1−.7b). As b rises, the signature fades and the yantra beyond takes over.
5. Wall quads with per-wall linear gradients. f = floor-ness of the wall midpoint, 0..1: the floor catches light and the ceiling stays dark. Stops: hsl(wallHue, 30+24f, 4+(10+30f)a) → (22+18f, 2.4+(5+14f)a) → (16%, 1+3a).
6. Structural edge lines far→near in hsl(hue, sat, min(88, farL+18)), width 1.1, opacity .3+.5a.
7. The far outline in farHot at opacity .24+.6a.
8. **The shaft**: the near polygon filled with radial `rsShaft` centred at the VP, r = 1.5R. Stops: hsl(hue,sat,min(82,farL+10)) at op .62a → farL at .28a (30%) → 0 (74%). Verbatim: *"the light as a volume you are standing in."*
9. The dhātu grain: fractalNoise .72, 3 octaves, seed 7, desaturated, overlay at .05+.09a.
10. The eye's falloff vignette: from 45% to an edge opacity of .9−.28a.

**Light values:** `farL = 20 + 62a`. That is lightness 20% at entry and 82% fully adapted; the aperture is "a real light field". farC = hsl(hue,sat,farL); farHot = hsl(hue, sat×.42, min(98, farL+26)).

**Blur:** soft stdDev 2.2+5(1−a); far 3+16(1−a). The image sharpens as the eye adapts.

### R-10 · The Threshold: three self-paced beats (`rite-threshold.jsx` L1–118; `rite-app.jsx` L99–100, L117–120, L160–163)
Verbatim: *"the three beats of entering. Self-paced: each beat writes itself, then waits for you. Never skipped, quietly compressed on return."*

**Sees:** the room is already rendered behind at a = 0. Verbatim: *"No black card. You are already standing in her room — the ceremony happens in front of the architecture, and her light is lit before you arrive."*
- Overlay: a radial gradient (closest-side) at 50% / spec.alt×100%, from hsla(hue,sat,40%,.1) → rgba(4,1,3,.5) at 62% → .82.
- Text sits on a soft dark halo (radius 200, rgba(4,1,3,.8) → 0) with padding 26/34. Layer zIndex 6.

Beats:
- **Beat 1, phrase:** 24px serif, line-height 1.5, tracking .04em, cream, opacity `c01(p/.34)×.94`.
- **Beat 2, name** (`RiteWriting`): the Devanāgarī `dev` at 36px, cream .92, *"an unseen hand writes her name, stroke by stroke"*. A horizontal mask reveals it in 3 segments; within each segment the reveal eases over the first 72% and then holds, with a 7% soft edge. With reduced motion there is no mask, just a 500ms opacity fade once p > .02. Below it sits the Latin name at 15px, tracking .24em, uppercase, colour hsl(hue,52%,72%), opacity c01((p−.55)/.45)×.62.
- **Beat 3, etymology** (`RiteEtymology`): roots at 26px with gap `(1−join)×split×28` px. split = c01(p/.58) and join = c01((p−.52)/.48), so the roots break apart and rejoin. Each root fades in by index (`c01(split×n − i)×.8`). The last root is italic when there are more than 2 roots. The gloss is italic 16.5px, max-width 270, opacity c01((p−.6)/.4)×.5. With reduced motion, gap is 14 → 0 at p>.5 (600ms linear) and the gloss shows at p>.6.

**Progress indicator:** at bottom 92, three bars (gap 9). The current bar is 16×4; the others are 4×4 (radius 2). Done or current bars are hsl(hue,50%,76%) and later bars rgba(242,232,217,.2). Opacity is .85 for current and .4 otherwise, with a 500ms transition.

**Hint:** at bottom 62, 10.5px, tracking .28em, uppercase, cream at opacity .4 once progress ≥ .99 (fade 1100ms linear). Text: **"touch to go on"** on beats 1–2 and **"touch to enter"** on beat 3.

**Do:** tap anywhere to advance. This works at any progress, not only when the hint shows: the tap is not gated on `ready`. A tap after beat 3 sets beat 4 and `enteredAt = gt`, which starts the room clock.

**Timing per beat:** `progress = (gt − beatT)/beatDur`, where beatDur is 2.4/3.2/2.8s × compression × 1.35 when reduced.

### R-11 · The Room: dwelling (`rite-dwelling.jsx` L28–160)
Verbatim: *"Text is residue here: the architecture carries the recognition."*

**Layout:** derived from the aperture span. TOP_BAND 52 is reserved for the status bar and the leave control; BOTTOM_BAND 150 for the letter, "go deeper" and the indicator; ID_H 60.
- If the free space below ≥ the free space above, the portrait band goes below the aperture. The name block goes above (`idTop = max(52, span.top−16−60)`) when there is ≥ 76px of room, otherwise just below the aperture (+14), with the band 20px under it.
- Otherwise everything is mirrored: the band bottom is pinned at `874 − (span.top−20)`.

**Room-entered overlay:** fades in over 1800ms linear once entered. It contains:
- **Her name cut into the wall above the light:** `dev` at 30px, cream .62, text-shadow 0 0 26px hsla(hue,60%,40%,.5). Below it, `quality` at 11.5px, tracking .3em, uppercase, colour hsl(hue,48%,74%) .72.
- **The portrait:** a band (left/right 44) with the five `lines` at 19px, line-height 1.45, cream .9 when shown. Unshown lines are at 0 and 9px lower. The transition is opacity 2600ms linear plus transform 2600ms ease-out. A dark halo (rgba(4,1,3,.82) radial, inset −26/−30) appears once any line shows.
- **The letter**, only when `spec.letter` exists (Śakti 28): a button at right 22, bottom 100, 48×44, opacity `cross(a, res.letter, .2)×.95`, so it fades in as a crosses the rate's letter threshold. It is drawn as a 34-wide slip, 13px tall closed and 26px open (900ms ease-out), fill hsla(hue,34%,86%,.16), top border hsla(hue,44%,90%,.42). Tap toggles. Open: a text box at left/right 26, bottom 150, italic 16px, line-height 1.55, cream .86, on rgba(4,1,3,.72), radius 4. Verbatim comment: *"her letter, resting where it was left"*.
- **The doors:** left and right edge buttons at top 40%, height 130, width 44, with a 2px vertical glow line (linear transparent → hsla(hue,70%,72%, .22+.5a) → transparent, blur .6px). aria "neighbour". Verbatim: *"the doors — her two neighbours, lit along the seat's own edges"*.
- **"go deeper":** centred at bottom 40, 150×46, 11.5px, tracking .26em, uppercase, cream .72, over a 58×1 hairline hsla(hue,50%,84%,.5). Its opacity is `cross(a, .28, .3)×.8`, so it does not exist before a ≈ .28 and is full by a ≈ .58. It opens the Descent (R-12), **not** the Library.
- **Leave:** at top 52, left 6, 46×46; a 15px chevron (left and bottom borders rotated 45°) at cream .42. aria "leave".

**Motes** (`RiteMotes`): 9 deterministic motes at x 16+(i×37 mod 68)%, y 12+(i×53 mod 74)%, size 1+(i mod 3)×.7, duration 20+(i mod 5)×7 s, delay i×1.7s, colour hsl(hue,60%,86%) with glow. Verbatim: *"they only become visible once the eye has adjusted."* They are absent when a < .2; group opacity is (a−.2)×.9. With reduced motion they are static.

Room base background: `#040103`.

### R-12 · The Descent: "go deeper" is a fall, not a sheet (`rite-descent.jsx` L1–314)
Verbatim: *"'go deeper' is not a sheet. You fall inward through her, and each field of her card becomes a chamber rendered as motion, not a paragraph. Self-paced: a touch carries you one chamber further in."*

**Stations** (`riteStations`):

| # | key | label (verbatim) | text |
|---|---|---|---|
| 1 | function | what she does | spec.fn |
| 2 | somatic | where she is felt | spec.somatic |
| 3 | icon | how she appears | spec.icon |
| 4 | tattva | the principle | `${tattva} — ${quality}` |
| 5 | root | her name, opened | `${roots.join(' · ')} — ${gloss}` |

**Chambers** (each a 330×330 SVG):
1. **ChFunction:** 7 copies of the room shape expand from r 18 to 156 (phase speed .16/s), stroke hsl(hue,sat,72−22ph), with her aperture face at r30 in the centre. *"her seat's form multiplying outward"*.
2. **ChSomatic:** 15 horizontal "registers" from y −150 in 21.4 steps. Lines near her altitude (y = −150+alt×300) widen (26+62near), brighten and thicken. A breathing ellipse sits at her altitude with br = .5+.5·sin(.55t). *"the body as registers, breathing at her altitude"*.
3. **ChIcon:** varies by aperture.
   - point: 4 circles converge from 140 to 14; *"the noose: it draws the vast into the tiny"*.
   - triad: three seals converge from 112 to 20 on cy2=(sin .5t+1)/2; *"gathering will, knowledge and action into one"*.
   - tri-down: two triangles join (offset 74→2); *"the womb-seal: hands joining into the downward triangle"*.
   - any other aperture: the face at r110.
4. **ChTattva:** the room shape at r118 rotates 5°/s, r78 has fill .1, and r44 counter-rotates 3°/s. *"one form, turning, saying nothing else"*.
5. **ChRoot:** the roots orbit at radius 118→0 on cyc=(sin .32t+1)/2, with size 23→15 and opacity .35+(1−cyc).55. The `dev` name at 40px fades in at cyc×.95. *"the roots drawn inward until they are one word again"*.

**Fall mechanics:** `target` increments by 1 per tap, capped at 5. `dz` eases toward target by .055 per frame (.028 when reduced). A chamber renders when its rel = i−dz lies in (−1.1, 2.2), at scale `2.5^(−rel)` and opacity `rel ≥ 0 ? 1−.62rel : 1+1.5rel`.

**Shaft background:** 8 room-shape outlines at r = 14×2.9^(ph×2.1), phase speed .09/s, opacity min(6ph,1)(1−ph)×.16. Background radial-gradient(120% 90% at 50% 46%, hsl(wallHue,34%,5%), `#030102` 74%). Entry animation `riteFall` 700ms cubic-bezier(.16,1,.3,1). zIndex 14.

**Chamber caption:** fades in as you arrive, with near = 1−|i−dz|/.42. It sits at bottom 148: the label in mono 10.5px, tracking .24em, uppercase, hsl(hue,44%,78%) .8; then the text in serif 19px, line-height 1.5, cream .94.

**Depth indicator:** at left 20, one 2px bar per station. The current bar is 22 tall and the others 8; reached bars are hsl(hue,50%,76%).

**Hint:** "touch to go further in" at bottom 62, 10.5px, opacity .34.

**"The floor of her":** shown after the 5th tap. Overlay rgba(3,1,2,.9), padding 84/30/60, riteFall 900ms ease-out. Title "the floor of her". Rows: Āvaraṇa (`${ord} — ${name}`), Her seat (the bhūpura / a lotus petal / the bindu / a triangle), Bodily location, Bīja (world), Śakti family, Gem · dhātu (`${gem} on ${dhatu}`), Clock. Button **"rise back into her room"** (13/26 padding, border hsla(hue,44%,72%,.4)) closes it.

**Rise control:** at top 50, left 6, 46×46, an up-pointing chevron (top and left borders rotated 45°), aria "rise". It closes the fall at any depth.

### R-13 · The Library (orphaned) (`rite-dwelling.jsx` L162–206)
`RiteLibrary` is a bottom sheet: a 92px tap-to-close strip, radius 26, background hsla(hue,22%,9%,.98) → rgba(6,2,4,.995), title "the library" in gold. Rows: Function, Somatic signature, Iconography, Esoteric tattva, Bodily location, Etymology, Bīja, Śakti family, Āvaraṇa, Her seat (incl. gem on dhātu), World (clock · region). It uses the `riteSheet` 620ms animation.
**It is exported but never mounted.** rite-app wires `onLibrary` to `setDescent(true)`. It was superseded by R-12.

### R-14 · The Corridor, Doors, Leaving and Re-entering (`rite-app.jsx` L22–54, L117–131, L146–175)
**App state:** idx (default **1** = Śakti 28), screen 'in' | 'corridor', beat 1–4, beatT, enteredAt, descent, letterOpen, visits, after, shownMax, scale. The device scale is `min(1, (innerHeight−48)/874)`.

**Corridor** (after leaving):
- Background radial(130% 90% at 50% 50%, hsl(hue,30%,6%), `#050205` 74%).
- Two door glows at top 34%, 180 tall and 60 wide; an inner 44-wide radial hsla(hue,70%,62%,.3) blurred 9px.
- A centre button, **"enter"** (11.5px, tracking .24em, cream .42), above a 46×1 hairline.
- "enter" re-enters the same Śakti; the doors go to her neighbours.

**Navigation:**
- `enter(i)`: increments visits[num], persists them, resets to beat 1, unenters, closes the descent and letter, and sets shownMax 0. Every entry always runs the threshold again, compressed.
- `door(dir)`: `(idx+dir+3) mod 3` over specimens [27, 28, 1]. The ring wraps: 28 → 1 → 27.
- Doors work from **inside the room** (R-11) and from the corridor.
- `leave()`: sets the after-effect, screen 'corridor', and closes the descent.

There is no other navigation: no menu, no tabs, no exit to a mandala.

**Tweaks panel "The Rite"** (prototype chrome):
- Time: Dilation (1× — true / 3× / 12× — sketch); Phase; First adaptation %; Second adaptation %.
- Stillness: Held s; Next line.
- Her: Specimen; Her seat (room · gem); Aperture; Rate; Visits · ceremony %.
- **World (previews P1–P9):** a Ring select labelled "ring k · gem on dhātu"; Clock; Altitude.
- After-effect: Lingering.
- Access: Reduced motion (defaults to the OS `prefers-reduced-motion`); Sound (default off).
- Jump buttons: "Settled — the eye has adjusted", "The second adaptation", "The descent", "Re-enter this room", "Forget every return".

⚠ The **world** comes from the Tweak (default ring 1), **not** from `spec.ring`. Room geometry, wall hue, gem hue and sat come from the world; aperture, altitude, rate and lines come from the Śakti. That is how a Śakti can be previewed in any of the nine rooms.

---

## §A2 — THE LIVING RITE (the handoff prototype)

Entry: `Bindu Mandala - The Living Rite.html`, which is byte-identical to `design_handoff_living_rite/prototype/index.html` (see §C).

**Load order:** shakti-data.js and all-shaktis-data.js as plain scripts. An inline script then lifts `SHAKTIS` and `CLUSTER_INFO` onto window (L113–118). After that come ios-frame, tweaks-panel, living-rite-core, more, mandala, today, detail, field and app as Babel.

Textarea placeholder style: rgba(242,232,217,.4), italic.

**Keyframes** (html L19–103):
- lrRise: translateY(24) at op 0 → 12% op .6 → 88% op .35 → translateY(−110) at op 0.
- lrDrift: translate (0,0) → (34,−14) → (0,0).
- lrFall: −16 → 70 with op 0 → .5 → .25 → 0.
- lrStill: opacity .18 ↔ .42.
- lrTwinkle: opacity .12/scale .8 ↔ .55/1.15.
- lrRipple: scale 1 → 34 with op .5 → 0.
- lrRippleRise: translateY 0 → −120 and scale 1 → 30, op .55 → 0.
- lrRippleWide: scaleX 52 / scaleY 20.
- Recognition responses:
  - lrRespFlare: translateY −16, scale 1.06, op .32 → .58.
  - lrRespPool: scale 1.07, op .4 → .58.
  - lrRespDisperse: translateX 20, scale 1.04, op .3 → .52.
  - lrRespBloom: .9 → 1.16, op .3 → .6.
  - lrRespSettle: 1.015, op .34 → .46.
  - lrRespRadiate: 1.05, op .4 → .72.
- lrBijaPulse: text-shadow 40px gold .3 → 90px .8 at 30% → back, scale 1.05.
- lrBijaRing: scale .7 → 3.4, op .55 → 0.
- lrCollapse: scale 1.5 at op 0 → 30% op .6 → scale .14 at op 0.
- syTwinkle: .15 ↔ .7.
- syPulse: scale 1.35.
- syRing: .7 → 2.4, op .6 → 0.
- syCardUp: translateY 30 → 0.
- syBreath: scale 1.22.
- syFlare: 0 → 6% op .55 → 22% op 0 at scale 3, held.
- syShimmer: .82 ↔ 1.
- syBinduBreath: scale 1.28, op .75 → 1.
- syThread: dashoffset 1 → 0, op 0 → .5.
- syDescendBloom: scale .05 → 1 (34% op 1, end op .55).
- syPresenceIn: scale .2 → 1.
- syEmerge: translateY 16 → 0.
- syOrbit: 360°.
- syRingFlash: 0 → 18% op .85 → 0.
- lrVeilIn: fade.
- lrSpinCW / lrSpinCCW: ±360° around translate(−50%,−50%).
- lrPillBreath: box-shadow 0 ↔ 16px gold .3.
- lrSheetUp: translateY 40 → 0.
- Screen transitions:
  - lrScreenIn: op 0 at scale 1.015 → 1.
  - lrScreenRise: translateY 22, scale .99.
  - lrScreenBloom: scale 1.06.
  - lrScreenSettle: scale .965.

**Reduced motion:** `* { animation: none !important; }`. This is global, so JS-driven motion (camera, settle, hold) still runs.

### L-01 · The 102 assembled (`living-rite-core.jsx` L4–25)
`LR_ALL` walks rings 1→9 over `window.SHAKTIS_BY_RING` and assigns `kp` sequentially:

| ring | kp range | count |
|---|---|---|
| 1 | 1–28 | 28 |
| 2 | 29–44 | 16 |
| 3 | 45–52 | 8 |
| 4 | 53–66 | 14 |
| 5 | 67–76 | 10 |
| 6 | 77–86 | 10 |
| 7 | 87–98 | 12 |
| 8 | 99–101 | 3 |
| 9 | 102 | 1 |

Each entry gets `{...s, ring, kp}`. `LR_AVARANA_BY_RING` is keyed by ring. `LR_ORDINALS` = ['', 'First' … 'Ninth'].

### L-02 · Palette, atmosphere and element (`living-rite-core.jsx` L27–73, L180–227)
`LR_BASE`: ground `#0D0508`, gold `#C9963F`, cream `#F2E8D9`, red `#8B1A2A`.

`LR_CLUSTER_HUES` (ring 2 only):

| cluster | h | s | l | hex |
|---|---|---|---|---|
| inner | 43 | 78 | 52 | #D4A017 |
| tanmatra | 13 | 47 | 56 | #C4725A |
| citta | 180 | 49 | 32 | #2A7A7A |
| stability | 140 | 24 | 38 | #4A7A5A |
| self | 270 | 26 | 48 | #7A5A9A |

`LR_RING_HUES`:

| ring | h | s | l | name |
|---|---|---|---|---|
| 1 | 35 | 58 | 54 | bhūpura amber |
| 3 | 341 | 45 | 58 | anaṅga rose |
| 4 | 353 | 55 | 48 | auspicious crimson |
| 5 | 18 | 62 | 55 | accomplishment coral |
| 6 | 194 | 42 | 46 | protection teal-blue |
| 7 | 322 | 38 | 50 | vāk wine |
| 8 | 2 | 68 | 50 | mūla red |
| 9 | 46 | 72 | 66 | bindu white-gold |

There is no entry for ring 2. A ring-2 Śakti without a cluster would crash; all 16 have one.

`LR_RING_ELEMENTS`: 1 earth, 3 air, 4 water, 5 fire, 6 ether, 7 air, 8 fire, 9 light.

`lrElement(s)`: for ring 2 the element comes from the lowercased `tattva`, tested in this order:
- fire / agni → fire
- air / vāyu / vayu → air
- water / jala / apas → water
- earth / pṛthvī / prithvi → earth
- ether / ākāśa / space / akasha → ether
- anything else → **ether**

All other rings use `LR_RING_ELEMENTS`.

Resolved elements for the 16 Karṣiṇīs (from shakti-data tattvas):

| pos | kp | name | tattva | element | archetype |
|---|---|---|---|---|---|
| 1 | 29 | Kāmākarṣiṇī | Fire (Agni) | fire | ascension |
| 2 | 30 | Buddhyākarṣiṇī | Air (Vāyu) | air | horizon |
| 3 | 31 | Ahaṅkārākarṣiṇī | Space (Ākāśa) | ether | veil |
| 4 | 32 | Śabdākarṣiṇī | Space (Ākāśa) | ether | veil |
| 5 | 33 | Sparśākarṣiṇī | Air (Vāyu) | air | horizon |
| 6 | 34 | Rūpākarṣiṇī | Fire (Agni) | fire | ascension |
| 7 | 35 | Rasākarṣiṇī | Water (Jala) | water | descent |
| 8 | 36 | Gandhākarṣiṇī | Earth (Pṛthivī) | earth | foundation |
| 9 | 37 | Cittākarṣiṇī | Pure Consciousness (Cit) | ether (default) | veil |
| 10 | 38 | Dhairyākarṣiṇī | Earth (Pṛthivī) | earth | foundation |
| 11 | 39 | Smṛtyākarṣiṇī | Water (Jala) | water | descent |
| 12 | 40 | Nāmākarṣiṇī | Space (Ākāśa) | ether | veil |
| 13 | 41 | Bījakarṣiṇī | Fire (Agni) | fire | ascension |
| 14 | 42 | Ātmākarṣiṇī | Pure Being (Sat) | ether (default) | veil |
| 15 | 43 | Amṛtākarṣiṇī | Nectar (Amṛta) | ether (default) | veil |
| 16 | 44 | Śarīrākarṣiṇī | Earth (Pṛthivī) | earth | foundation |

Other rings: 1 earth/foundation · 3 air/horizon · 4 water/descent · 5 fire/ascension · 6 ether/veil · 7 air/horizon · 8 fire/ascension · 9 light/radiance.

**`lrAtmosphere(s)`:**
- Base hue: the cluster hue for ring 2, otherwise the ring hue.
- `h += lrJitter(kp, 14)`, where `lrJitter(kp, range) = ((kp×2654435761 mod 1000)/1000 − .5)×range`, giving ±7°.
- Derived stops:
  - accent `hsl(h s l)`
  - accentBright (l+18 capped at 78, s+10 capped at 88)
  - accentSoft (alpha .62)
  - accentFaint (alpha .24)
  - ground `color-mix(in oklab, #0D0508 80%, accent 20%)`
  - groundDeep `color-mix(in oklab, #070205 88%, accent 12%)`
  - glow (l+6 capped at 70, alpha .36)
  - geometry = the āvaraṇa's `geometry` (default lotus16)
  - avarana
  - rotation = round(lrJitter(kp,44)), ±22°

**`lrApplyTime(atmo, tv)`:**
- h += dh; s = clamp(s×sMul, 6..90); l = clamp(l+lAdd, 8..82).
- accentBright caps rise to 80 / 90.
- ground and groundDeep are mixed again with `tv.tint` at `tintA`.
- glow alpha = clamp(.36×glowMul, .12..5); glow l caps at 72.
- It also sets `timeKey`.

### L-03 · Time of day (`living-rite-core.jsx` L160–178)
Verbatim: *"The practitioner meets her at 6am, but returns through the day; the light should move."*

| key | label | dh | lAdd | sMul | glowMul | tint | tintA | moteMul | auto hours |
|---|---|---|---|---|---|---|---|---|---|
| dawn | Dawn | +8 | +6 | 1.02 | 1.15 | #3a1c22 | .12 | 1.0 | 5–9 |
| noon | Noon | −5 | +13 | .88 | .8 | #242838 | .07 | .7 | 9–16 |
| dusk | Dusk | +3 | +2 | 1.16 | 1.25 | #331306 | .14 | 1.15 | 16–20 |
| night | Night | −7 | −9 | 1.06 | 1.05 | #060716 | .16 | 1.3 | else |

⚠ **`moteMul` is never read.** README §engine and DESIGN_SPEC §2.2 both claim mote density shifts with the hour. Also: `lrApplyTime(…, null)` returns the atmosphere un-relit. The Mandala's focus card and the Avaraṇa Threshold are therefore **not** time-relit.

### L-04 · Day cycle: today's Śakti (`living-rite-core.jsx` L229–262)
- `lrPracticeDayIndex(date)`: shift −6h, take the local midnight of that date, then `floor((localMidnight − Date.UTC(2020,0,1))/86400000)`. The day boundary is ~06:00 local.
- `lrSeededShuffle(102, cycle)`: a Fisher–Yates shuffle with a splitmix-style RNG; seed `(cycle ^ 0xD192ED03)>>>0`, increment 0x9E3779B9, mixers 0x45D9F3B.
- `lrTodaysShakti(dayOffset)`: `cycle = floor(day/102)`, `slot = day mod 102`, kp = shuffle[slot]. Each 102-day cycle visits every Śakti exactly once, in a new order.
- The DESIGN_SPEC §2.3 says to keep the **native** lunar-day assignment; this shuffle is "only a stand-in".

### L-05 · Moon and Nityā (`living-rite-core.jsx` L264–283, L572–583)
Synodic month 29.530588853 days; reference new moon `Date.UTC(2000,0,6,18,14)`.
- `tithiDay = min(30, floor(frac×30)+1)`; waxing when ≤15; `isFull` when frac ∈ [.47, .53].
- `pos = waxing ? tithiDay : 15−(tithiDay−15)`, with a minimum of 1, so the waning half mirrors the Nityā sequence.
- Label: `(waxing ? 'Śukla ' : 'Kṛṣṇa ') + nitya.tithiName`.
- `nityaName`: 'Lalitā Mahātripurasundarī' if isFull, else the Nityā's name.

⚠ Because the waning half mirrors through `pos`, the **tithi label** mirrors too: Kṛṣṇa pratipadā (tithiDay 16) displays as "Kṛṣṇa Caturdaśī". tithiDay 30 clamps to pos 1. Verify the intended tradition. The mirrored Nityā order may be intended; the mirrored tithi name probably is not.

`lrMoonName(ts)` (used by Her Moments):

| frac range | name |
|---|---|
| < .03 or > .97 | new moon |
| < .22 | waxing crescent |
| < .28 | first quarter |
| < .47 | waxing gibbous |
| < .53 | full moon |
| < .72 | waning gibbous |
| < .78 | last quarter |
| else | waning crescent |

`LrMoonGlyph({frac,size})`: an outline circle at rgba(242,232,217,.30) w .8 plus a lit path rgba(242,232,217,.82). The terminator rx = |ill−.5|×2×r, with ill = (1−cos 2πf)/2.

### L-06 · Text helpers (`living-rite-core.jsx` L285–310)
`lrNameSize(name, max=60)` by name length L:

| L | size |
|---|---|
| ≤ 9 | max |
| ≤ 12 | min(max, 56) |
| ≤ 15 | min(max, 48) |
| ≤ 18 | min(max, 42) |
| longer | min(max, 37) |

`lrQuality(s)` = s.quality, else `Of the ${ordinal lowercase} āvaraṇa — ${av.subtitle lowercase}`. Rings 1, 4, 5, 6 and 7 have no quality, so they always read e.g. "Of the first āvaraṇa — she who enchants all three worlds".

`lrPrompt(s)` = s.somatic, else the first line of s.somaticPoetry, else **"Where do you feel her, right now?"** Every non-ring-2 Śakti gets that line.

### L-07 · Composition engine: element → structure (`living-rite-core.jsx` L312–339; `living-rite-today.jsx` L8–36, L96–121)
Verbatim: *"Element → structural archetype, so different days are structurally different, not merely recolored."*

`LR_ARCHETYPE_BY_ELEMENT` (verbatim comments):
- fire → ascension: "she rises — bīja column up, name low-center, updraft"
- water → descent: "she settles — name high, prompt pools low, cool floor"
- air → horizon: "she drifts — asymmetric, name leans, sigil offset"
- ether → veil: "she pervades — name is the vast backdrop, prompt afloat"
- earth → foundation: "she grounds — wide low sigil base, centered + stable"
- light → radiance: "she is the point — name inside a dominant living sigil"

`lrComposition(s)`: m = (kp×2654435761)>>>0.
- flip = m&1
- spin = (m&2) ? 1 : −1
- sigilScale = .86 + ((m>>3)&7)/7×.4, range .86–1.26
- nameTier = (m>>6)&3
- gradAngle = ((m>>8)&15)×24

⚠ `gradAngle` is computed but **never used**.

`TD_PLANS`:

| element | block order | align | sigil | sigilScale | extra |
|---|---|---|---|---|---|
| fire | kicker, prompt, rule, quality, name, phon, know | center | bottom | 1.0 | — |
| water | kicker, name, phon, know, rule, quality, prompt | center | bottomWide | 1.15 | — |
| air | kicker, name, phon, know, rule, quality, prompt | lean | side | 1.0 | horizonLine |
| ether | kicker, nameSmall, rule, quality, prompt, know | center | center | .9 | veilName |
| earth | kicker, name, phon, know, rule, quality, prompt | center | bottomBig | 1.3 | — |
| light | kicker, name, phon, rule, quality, prompt, know | center | centerBig | 1.15 | nameCap 52 |

Sigil wrap (TdSigil), with effective scale s = plan.sigilScale × comp.sigilScale:

| placement | position | transform | size |
|---|---|---|---|
| bottom | left 50%, bottom −40 | translateX(−50%) scale(s) | 620 |
| bottomWide | bottom −140 | — | 620 |
| bottomBig | bottom −220 | — | 760 |
| side | top 40%, right or left −220 (opposite the lean) | translateY(−50%) | 620 |
| centerBig | left 50%, top 46% | translate(−50%,−50%) | 560 |
| center (default) | left 50%, top 46% | scale ×.95 | 620 |

The sigil always spins in direction comp.spin. Opacity is `arrived ? .62 + intensity×.42 : 0`, transitioning 2.4s ease, .2s delay. The air plan also draws a **horizon line** at top 43%, 1px, linear transparent → accentSoft 28–72% → transparent.

Note: the README's descriptions ("bīja column climbs" for fire, etc.) are aspirational. The code arranges blocks; it renders no bīja column.

### L-08 · Sigil, Depth and Motes atoms (`living-rite-core.jsx` L374–519)
**`LrSigil({atmo,size=760,opacity,spin,spinDir})`:** stroke-only paths at opacity ×1.7, stroke = accent, gold accents. Geometry by āvaraṇa `geometry`:
- square: 3 squares at .94/.80/.66 (op .30/.24/.18) plus 4 gold T-gates on the middle square (gate width .12c, depth .10c).
- lotus16 / lotus8: petals from .42c to .88c (half-width 360/n/2.6°) plus a gold 48-gon at .42c.
- tri14 / tri10o / tri10i: a ring of n (14 or 10) alternating triangles at ringR .66c (.52c for tri10i), triangle r .14c, plus gold 64-gons at ringR ±.22c.
- tri8: 8 alternating triangles at .5c, r .16c.
- trikona: 3 down-triangles at .72/.5/.3 (the last gold).
- bindu: 72-gons at .62 and .44 (gold) plus a centre dot r 5.

Rotation = atmo.rotation. Spin is `lrSpinCW` or `lrSpinCCW`, with duration `140 + (hue mod 60)` s, linear infinite.

**`LrDepth`:** zIndex 5. A vignette radial(78% 82% at 50% 46%, transparent 52% → rgba(4,1,3,.55)) plus inline SVG fractalNoise grain (baseFrequency .9, 2 octaves) at opacity .22, overlay.

**`LrMotes({atmo,count=14,animate})`:**
- Animation per element: fire lrRise, air lrDrift, water lrFall, earth lrStill, ether/light lrTwinkle.
- Seeds: seed=(i×733+97) mod 1000/1000, seed2=(i×397+211) mod 1000/1000.
- size 1.5+2.2·seed; left 4+92·seed %; top 6+88·seed2 %.
- Every 3rd mote is gold, the rest accentBright. Opacity .20+.35·seed2.
- Duration 9+14·seed s, delay −20·seed2 s.

**Shared atoms:** `LR_SERIF`; `LR_SAFE_TOP = 54`. `LrLabel` is ui-sans-serif, default 12px, tracking .22em, uppercase, default colour rgba(242,232,217,.55). `LrHairline` defaults to 48×1 rgba(201,150,63,.45). `LrClusterDot` defaults to 9px with glow.

### L-09 · Element backdrops (`living-rite-core.jsx` L353–372)
Inputs: g = glow, gd = groundDeep, gr = ground, af = accentFaint, as = accentSoft.

| element | backdrop |
|---|---|
| fire | radial(95% 62% at 50% 104%, g, transparent 62%) + radial(120% 40% at 50% −10%, af, transparent 60%) + linear(#080203 → gd) |
| water | radial(130% 52% at 50% 106%, as, transparent 68%) + linear(gr → gd) |
| air | radial(78% 96% at (flip ? 82 : 18)% 40%, g, transparent 60%) + linear(120deg, gr → gd) |
| ether | circle at 50% 44% g → transparent 58% + circle af → 42% + linear(gr → gd) |
| earth | radial(140% 48% at 50% 96%, g, transparent 66%) + linear(gr → gd) |
| light | circle at 50% 42%: as → g 26% → transparent 62% + linear(gd → #060305) |
| default | radial(120% 70% at 50% 30%, g → 70%) + linear(gr → gd) |

### L-10 · Sound: bīja and ring chimes (`living-rite-core.jsx` L75–158)
**`lrPlayBija(bija)`** returns 3.6 (seconds).
- The syllable is the bija string before " — ". Its djb-style hash (h=h×31+code) indexes the pentatonic scale `[130.81, 146.83, 174.61, 196.0, 220.0, 261.63, 293.66]`.
- Master gain .0001 → .26 at +.35s → .0001 at +3.6s (exponential).
- Lowpass 1200 → 600 over 3.2s.
- Vibrato LFO 5.2Hz, depth base×.006.
- Partials: base ×1, 1.5× at .38, 2× at .2. Sines stop at +3.7s.
- ⚠ **Not gated** by any sound toggle. It plays whenever a bīja is tapped (Detail, Mandala card, Lalitā "sound the source"). DESIGN_SPEC §2.7 only gates the chimes; README says *"gate behind the sound toggle"* for both.

**`lrRingChime(ring)`:**
- `LR_RING_FREQ`: 1 392.0, 2 349.2, 3 329.6, 4 293.7, 5 261.6, 6 246.9, 7 220.0, 8 196.0. Ring 9 is absent, so it falls back to 262.
- Duration 1.7s. Attack 12ms to .085, exponential decay.
- Lowpass 2400 → 700 over 1.36s.
- Bell partials (multiplier, gain, decay): ×1 (1, 1.7s); ×2 (.3, 1.19s); ×2.76 (.16, .85s); ×.5 (.22, 1.53s).

Verbatim: *"Deeper rings ring lower and rounder — falling inward descends in pitch."*

### L-11 · Embodiment, the return loop (`living-rite-core.jsx` L548–570; `living-rite-more.jsx` L5–84)
Verbatim: *"She deepens as she is felt: mapped → exploring → active → embodied. Readiness is sensed from the count of felt-moments; crossing is chosen (press-and-hold)."*

- `LR_STATUS` = Mapped, Exploring, Active, Embodied.
- `LR_STATUS_THRESH = [0, 1, 3, 7]`: the felt count needed to be **ready** for each level. Ready for Exploring at 1 felt, Active at 3, Embodied at 7.
- Level is stored at localStorage `lr_cross_<kp>`.

**EmbodimentPill** (shown in Detail):
- A four-node track (gap 7). Connectors are 18×1, in accent once reached, else rgba(242,232,217,.14). The current node is 9px accentBright with a 10px glow; past nodes are 6px accent; future nodes are 6px with a 1px rgba(242,232,217,.22) outline.
- Pill: radius 999, padding 6/16, 10.5px, tracking .18em, uppercase. Border and text take pillColor by level: [rgba(242,232,217,.4), accentSoft, accent, accentBright]. The label is the **current** level's name.
- **Ready** (`reached > level` and not at max): the pill breathes (`lrPillBreath` 2.2s) and shows the italic 13px line **"hold to cross into {next}"**.
- **Hold:** mouse or touch down starts a 30ms interval. A fill bar (accent at .22) grows to 100% over **750ms**. On completion: level +1 is persisted, `navigator.vibrate(12)` fires, and the fill resets. Releasing or leaving early cancels it. Only **one level per hold**.
- **Not ready:** "felt into being", or "she lives in you" at Embodied.
- ⚠ The `status` field in shakti-data.js (e.g. 'embodied') is **ignored**; everyone starts at Mapped.

### L-12 · Today: The Living Rite (`living-rite-today.jsx` L123–213)
Verbatim header: *"Each Śakti generates her own arrival. Her element selects a composition PLAN (block order, alignment, sigil placement, whether her name becomes the backdrop); her ring the geometry; her cluster/ring the hue; a per-kp mood the lean, scale and spin. All plans render through one centered, clip-proof engine — so days differ structurally, never overflow. Her name is a door."*

**Arrival:** `arrived` resets on kp change and goes true after 60ms. `fade(delay)` animates opacity and translateY(10 → 0) over 1.3s ease.

| element | fade delay (s) |
|---|---|
| celestial strip | .1 |
| kicker | .25 |
| name | .4 |
| phonetic | .55 |
| "know her ›" | .7 |
| rule | .8 |
| quality | .9 |
| prompt | 1.05 |
| foot | 1.25 |
| sigil opacity | 2.4s transition, .2s delay |

**Layers:**
1. Backdrop `lrBackdrop` (with `_flipLeft = comp.flip`).
2. TdSigil.
3. **Veil name** (ether only): a full-screen button. Her name at min(lrNameSize(name,120)×1.7, 150) px, weight 300, line-height .94, colour accentFaint, opacity = sigil opacity, balanced wrap. The whole screen is the door to Her Presence. The centre stack then has pointer-events none except its own blocks.
4. LrMotes, 16, animated when the motion tweak is on.
5. LrDepth.
6. **Celestial strip:** a full-width button with padding-top 54. It holds the moon glyph (18) and the label **"{Śukla|Kṛṣṇa} {tithiName} · {nityaName}"** (11.5px, rgba(242,232,217,.62)) followed by "›" in accentBright .7. Tapping it opens the **NityaSheet** (L-20).
7. Centre stack: always vertically centred. Max-width 360, or 94% for the lean plan. Padding 0 28 (0 30 for lean). Text aligns left or right for lean depending on flip: `left = !comp.flip`.

**Blocks** (TdBlock):
- **kicker:** a cluster dot (8) when there is a cluster, plus a LrLabel 11.5px, tracking .3em, accentBright: **"{Ordinal} Āvaraṇa · {cluster label}"**; marginBottom 22.
- **name:** a button (door → Detail) at 300 weight, size `lrNameSize(name, baseCap) + [0, 2, −2, 3][nameTier]`. baseCap is 52 for light, 66 for lean (air), and 58 otherwise. Line-height 1.06, tracking .05em, text-shadow 0 0 55px glow. aria "{phonetic|name} — open her presence". `data-comment-anchor="today-name"`.
- **nameSmall** (ether): 27px.
- **phon:** 12.5px, tracking .26em, rgba(242,232,217,.5), marginTop 12. Omitted when there is no phonetic, which is every non-ring-2 Śakti.
- **know:** italic 15px, accentBright .92: **"know her ›"**, a door to Detail.
- **rule:** a 54px hairline in color-mix(accent 62%, transparent), margin 24.
- **quality:** 25px, line-height 1.3, accentBright, max-width 330.
- **prompt:** italic 20px, line-height 1.55, rgba(242,232,217,.82), max-width 310, marginTop 20, wrapped in curly quotes "…".

**Foot:**
- **"I feel her"**: full width, height 60, radius 30. Gradient 135° from red to color-mix(red 66%, accent 34%). box-shadow 0 4px 48px glow plus 0 4px 30px rgba(139,26,42,.5). 23px, tracking .14em, cream. `data-comment-anchor="feel-her-cta"`.
- Below it, a LrLabel 11px rgba(242,232,217,.44): **"{kp} of 102 · bīja {bija}"**.

**Leaves to:** Detail (name, "know her", or the veil); Recognition ("I feel her"); NityaSheet (strip); Menu (hamburger, from the app).

### L-13 · Her Presence: Detail (`living-rite-detail.jsx` L4–174)
Verbatim header: *"The detail inherits the day's atmosphere; scale is reverence."* Atmosphere is the focused Śakti's, **time-relit** (app L54).

**Fixed atmosphere:**
- lrBackdrop.
- A top glow radial(130% 55% at 50% −5%, glow).
- LrSigil 600 at top −160, opacity .55, spinning direction −1.
- LrMotes 10.
- LrDepth.

**Nav row** (padding-top 54, 22px sides):
- Left: **"‹ {backLabel}"** in gold italic 17 (chevron 24px). backLabel is 'today', 'the field', 'the well' or 'the mandala', according to `nav.from`.
- Right: **"{kp} · 102"** at 11px, opacity .45.

**Scroll body** (padding 10/28/30). Sections are separated by 1px rgba(201,150,63,.14) top borders, padding 26:
1. **Hero:**
   - Kicker **"{Ordinal} Āvaraṇa · {av.form}"**, 11.5px, tracking .3em.
   - h1 name at lrNameSize(name,50), weight 300, line-height 1.1, tracking .05em, glow shadow 50px.
   - Phonetic at 12.5px, opacity .48.
   - Hairline 54.
   - Quality at 24px accentBright.
   - Cluster dot plus cluster label (ring 2 only).
2. **Portrait — "the soul, leading":** `description` or `av.personalConnection`, italic 20, line-height 1.6, gold.
3. **Somatic signature:** label, then `somaticPoetry` italic 20, line-height 1.65, pre-line. Ring 2 only. The one-line `somatic` prompt is **not** shown on Detail.
4. **"Bīja · tap to hear":** BijaGlyph.
   - The syllable at 84px, weight 300, gold. Text shadow is 0 0 40px glow at rest and 0 0 70px accent while sounding.
   - Tapping calls lrPlayBija (3.6s): `lrBijaPulse` 1.4s plus three `lrBijaRing` 90px rings (3.6s, delays 0/.5/1s) while sounding.
   - Caption "tap to sound her" → "sounding" (10px, tracking .22em).
   - aria "Bīja syllable {x} — tap to hear".
5. **Appreciation:** hairline 36, then `"{recognition | av.appreciationPhrase}"`, italic 19, gold, centred.
6. **Embodiment:** label plus EmbodimentPill (L-11).
7. **Her moments:** label plus HerMoments (L-19).
8. **"go deeper":** a full-width disclosure (min-height 48). Italic 17, gold .85, tracking .08em, followed by a 1px line. It toggles to "less". Open rows (DeepRow: label 10.5px .42, value 17.5px .78):
   - Tattva
   - Bodily seat (`location`)
   - Her ring (`{av.name} — {av.subtitle}`)
   - Form (`av.formDescription`)
   - Mental state
   - Chakra

**Footer:** **"I feel her"**, height 58, radius 29, gradient red → color-mix(red 70%, accent 30%), 22px, tracking .14em, shadow 0 4px 40px glow.

**Hamburger** hidden. **Leaves:** back to `nav.from`; Recognition.

### L-14 · Recognition Moment (`living-rite-detail.jsx` L219–368; `living-rite-core.jsx` L341–351)
Verbatim: *"Focal point, ripple manner, and the sigil/bīja 'response' animation vary by element so the ceremony itself takes on her nature."*

`LR_RECOG`:

| element | fx | fy | focal (bg) | resp | respDur | fill | ripple | rippleDur | rippleN | motes |
|---|---|---|---|---|---|---|---|---|---|---|
| fire | 50% | 60% | 50% 96% | lrRespFlare | 5.5 | infinite | lrRippleRise | 4.6 | 4 | 12 |
| water | 50% | 50% | 50% 62% | lrRespPool | 6.5 | infinite | lrRipple | 6.4 | 4 | 10 |
| air | 50% | 44% | 50% 40% | lrRespDisperse | 6.0 | infinite | lrRippleWide | 4.0 | 5 | 14 |
| ether | 50% | 45% | 50% 45% | lrRespBloom | 4.8 | 1 forwards | lrRipple | 5.6 | 3 | 10 |
| earth | 50% | 54% | 50% 92% | lrRespSettle | 7.5 | infinite | lrRipple | 7.6 | 2 | 6 |
| light | 50% | 44% | 50% 44% | lrRespRadiate | 3.8 | infinite | lrRipple | 3.6 | 5 | 12 |

**Sees:**
- Background radial(105% 72% at focal, glow → transparent 74%) + linear(groundDeep → #050203).
- LrSigil 480 at (fx,fy), opacity .55, spinning, animated with `resp` from stage 1.
- The bīja syllable at **320px**, accentFaint, opacity .5, animated with `resp` at respDur×1.3 from stage 2. aria-hidden.
- LrMotes (R.motes, always animated).
- rippleN 10px rings in accentSoft at (fx,fy), staggered by i×dur/n.

**Staged arrival** (timers from mount; each reveal is 1.4s opacity and transform):

| ms | stage | reveal |
|---|---|---|
| 300 | 1 | name: lrNameSize(name,46), weight 300, tracking .08em |
| 1100 | 2 | hairline 36 (margin 28) + `phrase` (recognition or appreciationPhrase), italic 24, line-height 1.55, max-width 320 |
| 2600 | 3 | **"she was felt here · {h:mm AM/PM}"** (12px, .6) |
| 4300 | 4 | act-2 timestamp captured; hairline 22 + **"and she felt you back · {h:mm:ss}"**, italic 17 gold. The seconds are what make the reciprocity a distinct moment. |
| 5400 | 5 | note box (288 wide, background rgba(242,232,217,.045), .5px border .14, radius 14, padding 13/16) with a textarea, placeholder **"What did you notice?"**, italic 15, rows 1 → 3 past 40 chars. Then **"tap outside to close"** (10.5px, .38). |

**Do:**
- Tapping anywhere closes once stage ≥ 1 (from 300ms). The note box stops propagation, so typing never dismisses.
- Each keystroke writes the note into that moment (`updateMomentNote(momentTs, text)`).

**Close:** `closing` is set. Content goes to opacity 0 and scale .84 (.55s / .62s cubic-bezier(.5,0,.75,0)); the footer to scale .9. A 300px radial (accentBright → glow 35% → transparent 68%) at 50%/46% plays **`lrCollapse` .62s**. After 620ms, `onClose` runs. Verbatim: *"the ceremony gathers into the point, handing off to the Portrait"*.

**Arrive from:** "I feel her" on Today or Detail. `feelHer()` appends `{kp, ts, note:''}` to `lr_moments` **before** the ceremony starts.

**Leave to:** the Memory with `settle: kp`. Hamburger hidden.

### L-15 · The Mandala: the Śrī Yantra universe (`living-rite-mandala.jsx` L1–478)
Verbatim header: *"A single continuous space you fall through: zoom out to the whole instrument; zoom in until each of the 102 energies names herself and reveals her significance. Pan · pinch · wheel · double-tap. Tap any energy to fly into her — camera glides in, her meaning blooms, her bīja can be sounded, and 'her presence' opens the full detail. Built on the real 102 seated in their true enclosures, floating in a starfield."*

**Geometry** (`SriYantraGeometry`, SY_R 320, local box 760, centre 380):
- 3 bhūpura squares at 1.0/.94/.88 R (width 1.1, opacity .5/.4/.3).
- 4 T-gates (gate width .11R, depth .05R, opacity .45).
- Circles at .90/.80/.70/.615 R (opacity .30/.28/.26/.24).
- 16 petals between .80 and .90 (half-width 360/16/2.4°, opacity .34).
- 8 petals between .615 and .70, offset 22.5° (opacity .36).
- A circle at .60.
- **9 triangles** scaled to .585R:

| set | triangle | top / bottom y | apex y | half-width |
|---|---|---|---|---|
| SY_DOWN (5) | 1 | −.30 | 1.00 | .98 |
| | 2 | −.48 | .80 | .80 |
| | 3 | −.64 | .58 | .62 |
| | 4 | −.79 | .36 | .45 |
| | 5 | −.91 | .16 | .29 |
| SY_UP (4) | 1 | .33 | −.99 | .92 |
| | 2 | .51 | −.77 | .75 |
| | 3 | .67 | −.55 | .57 |
| | 4 | .81 | −.31 | .41 |

- The bindu: circle r .10R with radial red .6 → 0, `syBinduBreath` 5.5s.
- The whole group shimmers (`syShimmer` 8s).

**Seats:**
- `SY_RING_R`: 1 306 · 2 268 · 3 224 · 4 178 · 5 145 · 6 116 · 7 88 · 8 52 · 9 0.
- Ring 1 sits on the **square perimeter** (H=306), each seat at t=(idx+.5)/n. Rings 2–8 are evenly spaced on circles starting at −90°. Ring 9 is the centre.

**Starfield:** 150 stars from LCG seed **20260711**. Radius 120–740, size .5–2.3, opacity .12–.62. Every 5th star is gold. 40% twinkle (`syTwinkle` 5+d s).

**Camera:**
- View {scale, tx, ty}, clamped to scale .32–5.5.
- `fit`: scale = clamp(min(w,h)/760×.94), centred; about .497 on 402 wide. It clears focus.
- `animateTo`: 720ms ease-out cubic, with `animating` set.
- `zoomAt` zooms around a point.
- **Wheel** ×1.12 per notch.
- **Mouse drag** pans (pointer, non-touch).
- **One-finger** touch pans; **two-finger pinch** zooms around the midpoint.
- `moved` is set past 4px of travel and suppresses taps.
- **Double-tap** on empty space (< 300ms, not on a `button[title]`) and **double-click** zoom ×1.7.
- Buttons: **+** ×1.4, **−** ÷1.4, **⤢** fit.

**Semantic tiers:** scale < 1.15 → tier 0 (cosmic); < 2.3 → tier 1 (named); else tier 2 (significance).

**Header** (top 44, centred, non-interactive):
- "Śrī Yantra", 25px, weight 300, tracking .1em.
- Below it, a hint at 9.5px, .42, by tier:
  - tier 0: **"the whole instrument · pinch to fall in"**
  - tier 1: **"the nine enclosures"**
  - tier 2: **"tap an energy · fall to the center for the source"**

**Tier ≥ 1:** each ring's label "{Ordinal} · {av.form}" is placed above its circle (ring 9 at +18), ui-sans 9/min(sc,2) px, gold .6.

**Seat buttons:**
- Hit size max(26, dotR×2.8). ⚠ The minimum is 26, below the 44pt floor.
- Dot radius: focus 7, today 6, family 5.5, felt 4+min(n,6)×.4, else 3.
- Colour: cream when today or focus; focus accentBright for family; own accentBright when felt; own accent otherwise.
- "lit" (felt, today, focus or family) gives opacity 1 and a glow of 16 (focus), 12 (today) or 6+n px. Unlit dots are at .5.
- Breath: `syBreath` (3.4+(kp mod 7)×.7)s with delay −(kp mod 11)×.6s. Today pulses with `syPulse` 2.6s plus a 22px `syRing`.
- Flare: `syFlare` (8+(kp mod 13))s with a phase offset. Verbatim: *"each energy breathes and flares on her own rhythm — the field is alive"*.
- Names show when tier ≥ 1, in family, or focused: the **short** name at tier 1 and the full name at tier 2 or in family. Serif 9px, counter-scaled by 1/min(max(sc,1),2.4).
- Tier 2 adds an italic 7.5px line "bīja {syllable}" in accentBright .85.
- Today's ring gets a dashed circle in accent, opacity .5, width 2/sc.

**Tap a seat:**
- Ignored if `moved`.
- Ring 9 → `openDescent()`.
- Tapping the already-focused seat → `onOpenShakti` (Detail, from 'mandala').
- Otherwise → **flyToSeat**: scale 3.0, the seat placed at (w/2, h×.36), and the seat focused.

**Constellation threading:** when focused, lines run from her seat to each **family** member. Ring 2 family = same cluster; any other ring = the whole ring, minus herself. Lines are accentBright, 1px, non-scaling, drawn with `syThread` .7s staggered .05+i×.035s. Non-family seats dim to **.28** and become non-interactive.

**Significance card** (when focused): at left/right 12, bottom 14, entering with `syCardUp` .5s.
- Background radial glow + linear(160deg rgba(20,10,14,.92) → rgba(8,4,7,.95)), border accentSoft, radius 20, padding 18/20/16, blur 10, shadow.
- Kicker **"{Ordinal} Āvaraṇa · {cluster label | av.form}"**.
- **×** closes: clears focus and fits.
- Name at lrNameSize(name,32); phonetic; quality at 18px accentBright.
- **"threaded to {N} sister(s) · {cluster label | ring name}"**, italic 13.
- Bīja button: the syllable at 42px gold with caption **"sound her"**, which plays lrPlayBija.
- Significance text: `description | av.personalConnection | av.subtitle`, italic 14, max-height 84, clipped.
- **"enter her presence"**: height 46, radius 23, red gradient → Detail.

**Control column** (right 16; bottom 26, or top 84 when a card is open), 46px circles:
- **♪** toggles ring chimes. It persists in `lr_sound` ('1'/'0') and defaults **off**. Off shows a slash overlay "⁄".
- **+**, **−**, **⤢**.

**Ring-entry chimes:** reachLocal = (min(w,h)/2)/scale. `entered` = the deepest r in 1..8 with SY_RING_R[r] > reachLocal, i.e. the ring's circle has grown past half the screen. When `entered` increases (inward only), the gold ring flashes (`syRingFlash` 1.5s, width 2.5/sc). If sound is on, `lrRingChime(entered)` plays, throttled to 55ms. Outward crossings are silent. Verbatim: *"Zoom-driven (falling in); silent on the way out."*

**Auto-descent:** when not animating, the view re-arms if scale < 2.8. If armed **and scale > 4.3 and the bindu is within 64px of screen centre**, `openDescent()` fires: the camera animates to scale 5.4 with the bindu at (w/2, h×.44), then `setDescent(true)`. Verbatim: *"fall far enough into the center and the bindu opens on its own."*

⚠ Tension: this auto-advance conflicts with the governing rule **"Never auto-advance."** The DESIGN_SPEC explicitly endorses it ("Tap the bindu, *or* keep zooming past a threshold"), justifying the deep zoom itself as the chosen gesture.

Background: radial(80% 55% at 50% 44%, dayAtmo.glow) + radial(circle at 50% 44%, #0a0611, #050308 60%, #030105). `touch-action: none`. Hamburger shown.

### L-16 · Lalitā Source: the Bindu opens (`living-rite-mandala.jsx` L109–162)
Verbatim: *"Not a card: an arrival. The field recedes, the red point blooms to fill, and She — the ground from which all 102 emerge — settles into presence. The 102 gather as a faint returning field around Her."*

**Sees** (zIndex 40):
- Background radial(90% 70% at 50% 42%, #2a0a12, #12060b 55%, #060205).
- A 1400px red bloom (`#8B1A2A` → rgba(139,26,42,.35) 22% → transparent 60%) at 50%/42%, `syDescendBloom` 1.6s.
- The **returning field**: the 102 seats at ×.82 in a 620 box, 2.4px gold dots at .22, orbiting (`syOrbit` **160s**), emerging over 2.4s from .4s.
- **Her presence**: a 172px radial (cream → gold 34% → rgba(139,26,42,.5) 62% → transparent 78%), `syPresenceIn` 1.6s, then `syBinduBreath` 6.5s.

**Words** rise with `syEmerge` 1.1s cubic-bezier(.2,.85,.3,1), bottom-aligned, padding 0/30/30:

| delay (s) | content |
|---|---|
| 1.5 | "Ninth Āvaraṇa · The Bindu" (10.5px, gold, tracking .34em) |
| 1.7 | "the point that contains all points" (italic 15, .62) |
| 1.95 | **`s.short` = "Lalitā"** at **68px**, weight 300, glow 60px gold |
| 2.15 | "Mahātripurasundarī" (22px, tracking .14em) |
| 2.4 | hairline 48 |
| 2.55 | quality (20px gold): "She who is made of all bliss — the undivided ground from which all 102 Shaktis emerge and to which they return" |
| 2.8 | "There is nothing else here. The whole yantra breathes outward from this point — and every energy you have met is Her, turned for a moment toward you." (italic 16, .72) |
| 3.0 | **ॐ** (30px gold) with caption "sound the source". It plays lrPlayBija('ॐ — Oṁ') and glows for 1400ms. |
| 3.15 | **"enter her presence"** (54 tall, red → red60/gold40 gradient, shadow 0 6 44 rgba(139,26,42,.6)) → Detail of kp 102, from 'mandala' |
| 3.3 | **"↑ return to the field"** (italic 15, .55) → `ascend`: descent off, disarm, fit. Fit drops the scale below 2.8, which re-arms. |

Verbatim (DESIGN_SPEC): *"Words rise in a slow stagger (remembering, not loading)."*

### L-17 · The Field (102), the nine rings as a descent (`living-rite-field.jsx` L4–134)
**Sees:**
- Background linear(dayAtmo.ground → groundDeep) plus a top glow.
- Header **"The Field"** (32px, weight 300) and **"nine rings · one hundred and two"**, with a bottom border.
- A scrolling accordion of the nine rings. **One open at a time**, defaulting to **today's ring**.

**Ring row** (FieldRing):
- When open: background linear(90deg accentFaint → transparent 72%).
- A 48px sigil chip: radial accentFaint plus LrSigil 48 at opacity 2.4 (×1.7 stroke), spinning only when open, glowing when open.
- `av.name` at 21px (accentBright when open).
- A 7px glowing dot if the ring holds today's Śakti.
- `av.subtitle`, italic 14.5.
- The count, and a "›" rotating 90° when open (.3s).
- Ring atmosphere = `lrAtmosphere(first Śakti of ring)`, which is not time-relit.

**Open ring:**
- Background linear(groundDeep → transparent) plus a spinning LrSigil 360 at .5 behind.
- Caption row: `av.form` (10px, tracking .24em) and `av.mentalState` (italic 14), plus **"the threshold ›"** (italic 14, accentBright) → the Avaraṇa Threshold.
- Rows (radius 10, padding 11/12): a 7px dot in her own accent (felt → opacity 1 with glow, else .4), name at 19px, and on the right **"today"** (italic 13.5) or the felt **count** (10.5px). Today's row gets a faint gradient.

**Do:** tap a ring to toggle it; tap a Śakti → Detail (from 'field'); tap "the threshold ›".

DESIGN_SPEC calls the Field "the whole khaḍgamālā as a quiet grid/field". The code is an accordion list.

### L-18 · Avaraṇa Threshold: "you have already been here" (`living-rite-more.jsx` L160–217)
**Sees:**
- lrBackdrop(ring atmosphere from its first Śakti).
- LrSigil 620 at 42%, opacity .7, spinning with ring parity (odd CW, even CCW).
- LrMotes 12, always animated; LrDepth.

**Top row:**
- **"‹ the field"** in gold italic 17.
- **"{av.count} śaktis"**.

**Body**, staggered fade (1.3s each, translateY 10, first after 60ms):

| delay (s) | content |
|---|---|
| .2 | **"{Ordinal} Āvaraṇa · {av.form}"** |
| .35 | h1 `av.name` (lrNameSize(name,46), weight 300, glow 50px) |
| .5 | `av.subtitle`, italic 22 accentBright |
| .7 | hairline 48 |
| .8 | `av.personalConnection`, italic 18.5, line-height 1.62, left-aligned |
| .95 | `"{av.appreciationPhrase}"`, gold italic 18 |
| 1.05 | `mentalState` · `chakra` |

**Foot:** **"enter her ring"**, full width, height 56, radius 28. Gradient 135° accent → accentBright; text `#0D0508` at 20px.

**Leave:** "enter her ring" → `go('field', {openRing: ring})`; "‹ the field" → `go('field')`. Hamburger hidden.

⚠ **BUG:** the app never passes `nav.openRing` to `<FieldScreen>` (app L104–108), so "enter her ring" reopens **today's** ring, not this one.

### L-19 · Her Moments (`living-rite-more.jsx` L86–118)
- Empty state: **"She has not been felt here yet."** (italic 17, .5).
- Otherwise a newest-first list. Each row has a 6px accent dot with glow and **"she was felt here · {today|yesterday|Mon D}, {h:mm AM}"** (12px, .6), followed by **"· {moon-phase name}"** (italic 13, .45). The note, if present, follows in italic 15 at .68. Rows are divided by 1px rgba(201,150,63,.08).

### L-20 · Nityā Sheet: who presides over today (`living-rite-more.jsx` L120–158)
**Sees:**
- A backdrop rgba(4,1,3,.55) (`lrVeilIn` .3s); tapping it closes.
- A bottom sheet with radius 26, top border gold .2, padding 14/32/40, max-height 78%, scrollable, `lrSheetUp` .42s cubic-bezier(.2,.9,.3,1). Background radial(120% 60% at 50% 0%, glow) + linear(ground → groundDeep).
- A grabber 40×4.
- The moon glyph (26) plus the tithi label (11px, accentBright, tracking .26em).
- The Nityā name at lrNameSize(name,40), weight 300.
- Hairline 40.
- Italic 20 accentBright line:
  - On a full moon: **"Pūrṇimā — the full moon belongs to Lalitā, seated in the Bindu, from whom the whole yantra breathes."**
  - Otherwise: **"She presides over {tithiName} — one of the fifteen Nityā Devīs who turn the lunar fortnight."**
- Body (16.5px, .7): **"The Nityā is the mood of the day itself — the goddess of this moon-phase, presiding above whichever of the 102 arrives to be felt. She frames the encounter without competing with it."**
- A **"close"** button (italic 16).

Opened from the Today strip. zIndex 45.

### L-21 · The Well: letters (`living-rite-field.jsx` L136–182)
**Sees:**
- Background linear(ground → groundDeep).
- Header in **gold**: "The Well" (32px), then **"speak to her directly · she is listening"**, then italic 14.5 **"The sixteen Karṣiṇīs of your home ring receive letters."**
- **Ring 2 only**: 16 rows, each with a cluster dot in her accent, name 22px, and the first line of her letter (or **"You can speak to her here"** at .36), plus "›".

**Leads to:** the Letter editor (`go('letter',{kp})`).

⚠ README and DESIGN_SPEC call the Well the "recognition archive" or "notes/letters". In code it holds **letters only**; recognition notes live in Her Moments on Detail.

### L-22 · Letter editor (`living-rite-more.jsx` L219–254)
**Sees:**
- Background linear(groundDeep → #0a0508) plus a top glow.
- Header row: **"‹ the well"** (gold italic 17); a cluster dot plus the name at 18px; a spacer.
- A full-height textarea, **autoFocus**, placeholder **"Speak to her directly. She is listening."**, 20px, line-height 1.6, caret gold, padding 22/26/30.

**Memory:** autosaves every keystroke to localStorage `lr_letter_<kp>`; it also saves on back.

**Leave:** "‹ the well". Hamburger hidden. Atmosphere is the Śakti's, time-relit.

### L-23 · The Memory: Portrait Mandala (`living-rite-field.jsx` L184–289)
**Sees:**
- Background radial(100% 60% at 50% 45%, glow) + linear(groundDeep → #050203).
- Header **"The Memory"** (32px) and **"your face in the instrument"**.
- A 330px SVG:
  - faint ring circles (rgba(242,232,217,.05), .5px) at `ringR` = 1 152 · 2 118 · 3 92 · 4 76 · 5 63 · 6 50 · 7 38 · 8 25 · 9 0;
  - three gold triangles (r 78/58/40, alternating orientation, gold .14);
  - all 102 seats on circles (ring 1 is on a circle here, not a square);
  - the bindu: r10 red radial plus a 3.5 cream core.
- Footer italic 16: **"she is felt, not measured"**.

**Per-seat lighting:** n = felt count; intensity = min(1, n/7).
- Felt: a halo r 4+6i at opacity .12+.16i, plus a dot r 2.2+2i at .7+.3i, in her accentBright.
- Unfelt: r 1.5 at rgba(242,232,217,.14).
- **No numbers.**

**Settle** (arriving from Recognition with `settle: kp`), over **3400ms** (30ms ticks):
- Phase 0–.34: her gold point flies from the bindu to her seat (ease-out cubic), trailing a gold line that fades out. The head is r 4.6 → 3.4 with a 14px aura.
- .34–1: a halo blooms at the seat (r 6 → 36, opacity .8 → 0).
- The rest of the field and the header fade in over phase 0–.45.

Verbatim: *"One continuous motion: her point flies out of the bindu (0–0.34), then a halo blooms at her seat (0.34–1)."*

⚠ No recency warmth or cooling is implemented. DESIGN_SPEC Phase 5 asks for "warmer/brighter when felt recently, cooling with neglect".

**Do:** nothing is tappable. **Leave:** the hamburger only. Arrived via Recognition close, or Menu → The Memory.

### L-24 · App root: router, menu, persistence (`living-rite-app.jsx` L1–201; `living-rite-field.jsx` L291–338)
**Screens** (`nav.screen`): today · detail{kp,from} · recognition{kp,momentTs,from} · field · threshold{ring} · well · letter{kp} · memory{settle} · mandala.

**Entrance animation:** keyed on `screen:kp:ring`, .55s cubic-bezier(.2,.8,.3,1).

| screen | animation |
|---|---|
| detail | lrScreenRise |
| recognition | lrScreenBloom |
| memory | lrScreenSettle |
| threshold | lrScreenRise |
| all others | lrScreenIn |

Verbatim: *"detail rises from her name, recognition blooms from center, memory settles in, the rest cross-fade up."*

**Hamburger:** top 52, right 14, 44×44, three 19×1 bars rgba(201,150,63,.75), zIndex 30. **Shown** on today, mandala, field, well and memory. **Hidden** on recognition, detail, threshold, letter, and while the menu is open.

**Menu veil** (zIndex 40, `lrVeilIn` .45s):
- Background radial(80% 55% at 50% 42%, glow) over groundDeep.
- Centred italic 36px items with padding 10/40: **The Rite** (today), **The Mandala**, **The Field**, **The Well**, **The Memory**. The current item is in accentBright.
- A disabled **"Settings"** (20px, .35) that does nothing.
- Tapping the backdrop closes the menu.

**Navigation helper:** `go(screen, extra)` closes the menu and the Nityā sheet and replaces `nav`. There is **no history stack**: Detail's back goes to `nav.from`.

`feelHer(s)`:
1. Append a moment `{kp, ts, note:''}`.
2. `go('recognition', {kp, momentTs: ts, from: nav.screen==='detail' ? nav.from : nav.screen})`.

The `from` value is carried but unused after recognition, which always goes to the Memory.

**Persisted state** (localStorage):

| key | holds |
|---|---|
| `lr_nav` | last screen; a refresh lands you there, including mid-recognition, which replays the ceremony |
| `lr_moments` | array of `{kp, ts, note}` |
| `lr_cross_<kp>` | embodiment level |
| `lr_letter_<kp>` | letter text |
| `lr_sound` | chime toggle |

**Derived state:**
- `todayShakti = lrTodaysShakti(dayOffset)`
- `tv = lrTimeVariant(timeOfDay)`
- `dayAtmo = lrApplyTime(lrAtmosphere(today), tv)`
- `moon = lrMoon(dayOffset)`
- `focusShakti = nav.kp ? LR_ALL[kp] : today`
- `focusAtmo` = focusShakti's atmosphere, time-relit
- `countByKp` from moments

**Debug hooks:** `window.__lrSetDay` and `window.__lrSetTime`.

**Tweaks** (EDITMODE defaults):

| key | default | control |
|---|---|---|
| dayOffset | 0 | slider "Preview day +N", 0–30 |
| timeOfDay | 'auto' | select auto/dawn/noon/dusk/night |
| motion | true | toggle "Motion" |
| atmosphereIntensity | .85 | slider "Intensity", .3–1 step .05 |

Device root background = dayAtmo.groundDeep.

---

## §A3 — THE LIVING AXIS (`Bindu Mandala - The Living Axis.html`, single file, 423 lines)

Caption: **"Bindu Mandala · The Living Axis — concept"**.

**Own device frame** (not ios-frame): 390×844, radius 52, bezel shadow rings #17110e/#241a13, screen inset 11 with radius 42, notch 120×30.

**Tokens** (L11–16):

| token | value |
|---|---|
| --ground | #0D0508 |
| --ground-deep | #070205 |
| --veil | #080307 |
| --silence | #040104 |
| --gold | #C9963F |
| --gold-bright | #E8C97A |
| --cream | #F2E8D9 |
| --accent-red | #8B1A2A |
| fonts | Cormorant Garamond + JetBrains Mono |

Reduced motion stops all animation.

### X-01 · Atmosphere engine port (L48–70)
The code comments it as "ported from Atmosphere.swift". This is evidence that a native `Atmosphere.swift` exists. It uses the same jitter and stops as lrAtmosphere, with RGB mixing for the grounds.

`CLUSTER_HUE` uses the key **`selfBody`** where data uses `self`. `RING_HUE` adds ring 2 = [43,78,52].

### X-02 · RING2 iconography grammar (L72–93)
16 rows: name, phon, quality, cluster, element, silhouette, attribute, surface, motion, bīja, field. kp = 29+i.

| pos | name | phon | quality | cluster | element | sil | attr | surface | motion | bīja | field |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Kāmākarṣiṇī | kaa-maa | Desire | inner | fire | open | lotus | radiant | pull | Aṃ | |
| 2 | Buddhyākarṣiṇī | buddh-yaa | Intellect | inner | air | crowned | mirror | luminous | drift | Āṃ | |
| 3 | Ahaṅkārākarṣiṇī | a-hang-kaa | The I-maker | inner | **fire** | enthroned | sceptre | golden | still | Iṃ | Gaia |
| 4 | Śabdākarṣiṇī | shab-daa | Sound | tanmatra | ether | dissolving | rosary | translucent | drift | Īṃ | |
| 5 | Sparśākarṣiṇī | spar-shaa | Touch | tanmatra | air | open | noose | pale | drift | Uṃ | |
| 6 | Rūpākarṣiṇī | roo-paa | Form · sight | tanmatra | fire | crowned | mirror | radiant | still | Ūṃ | |
| 7 | Rasākarṣiṇī | ra-saa | Taste | tanmatra | water | dissolving | lotus | translucent | drift | Ṛṃ | |
| 8 | Gandhākarṣiṇī | gan-dhaa | Scent | tanmatra | earth | rooted | lotus | deep | still | Ṝṃ | |
| 9 | Cittākarṣiṇī | chit-taa | Mind-stuff | citta | ether | dissolving | rosary | translucent | drift | Ḷṃ | |
| 10 | Dhairyākarṣiṇī | dhai-ryaa | Fortitude | stability | earth | rooted | sceptre | deep | still | **Ḹṃ** | |
| 11 | Smṛtyākarṣiṇī | smrit-yaa | Memory | stability | water | enthroned | rosary | pale | drift | **Eṃ** | |
| 12 | Nāmākarṣiṇī | naa-maa | Name | stability | **air** | crowned | blade | luminous | still | **Aiṃ** | Ashrey |
| 13 | Bījākarṣiṇī | bee-jaa | Seed | stability | fire | enthroned | lotus | golden | pull | **Oṃ** | bridge |
| 14 | Ātmākarṣiṇī | aat-maa | Self | selfBody | **light** | crowned | mirror | luminous | still | **Auṃ** | Ram |
| 15 | Amṛtākarṣiṇī | am-ri-taa | Nectar | selfBody | **water** | open | lotus | translucent | drift | **Aṃ** | |
| 16 | Śarīrākarṣiṇī | sha-ree-raa | Body | selfBody | earth | rooted | sceptre | deep | still | **Aḥ** | |

⚠ The bold cells **diverge from shakti-data.js**:
- **Elements:** the Living Rite derives Ahaṅ = ether, Nāma = ether, Ātma = ether, Amṛta = ether.
- **Bījas:** shakti-data gives eṁ, aiṁ, oṁ, auṁ, aṃ, aḥ, kaṁ for pos 10–16; the Axis shifts by one from pos 10.
- **Spelling:** shakti-data has "Bījakarṣiṇī" without the macron on ā.

**RINGS signature table** (L95–106): ring · name · Subtle-Body chakra · element · VERB · presiding form.

| ring | name | chakra | element | verb | presiding form |
|---|---|---|---|---|---|
| 1 | Trailokyamohana | Mūlādhāra | earth | AGITATE | Tripurā |
| 2 | Sarvāśāparipūraka | Svādhiṣṭhāna | · | LIQUEFY | Tripureśī |
| 3 | Sarvasaṅkṣobhaṇa | Maṇipūra | air | DRAW | Tripurasundarī |
| 4 | Sarvasaubhāgya | Anāhata | water | OPEN | Tripuravāsinī |
| 5 | Sarvārthasādhaka | Viśuddha | fire | VOICE | Tripuraśrī |
| 6 | Sarvarakṣākara | Ājñā | ether | STILL | Tripuramālinī |
| 7 | Sarvarogahara | Sahasrāra | air | WITNESS | Tripurasiddhā |
| 8 | Sarvasiddhiprada | Bindu-Visarga | fire | SEED | Tripurāmbā |
| 9 | Sarvānandamaya | Beyond | light | ARRIVE | Mahātripurasundarī |

⚠ The chakra column differs from AVARANAS from ring 7 down (AVARANAS: 7 Bindu, 8 Sahasrāra, 9 Brahmarandhra), and differs from the RITE_WORLDS regions.

### X-03 · Body: the grammar-built figure (L108–165)
**surfaceStyle:**

| surface | fill | opacity | glow | blur |
|---|---|---|---|---|
| radiant | accentBright | .95 | 22 | 0 |
| golden | hsl(h, s+6 max 85, l+12 max 72) | .92 | 16 | 0 |
| luminous | accent | .85 | 14 | .3 |
| pale | hsl(h, s−24 min 8, l+22 max 80) | .8 | 8 | .4 |
| translucent | accentSoft | .55 | 10 | 1.1 |
| deep | hsl(h, s, l−16 min 20) | .9 | 6 | 0 |

**Attributes** (drawn at +30,+6): lotus (3 petals), mirror (circle r8 + handle), noose (ellipse 8×6), sceptre (staff + orb), rosary (9 beads r9), blade (triangle).

**Silhouettes:** enthroned (trapezoid + head), open (head + spread wings), crowned (crown triangle + head + trapezoid), rooted (head + down-triangle), dissolving (head + 4 fading offset trapezoids), dancing (offset head/body/limb).

**Motion:** drift → `axDrift` 7s (translateY −8, rotate 2°); pull → `axPull` 4.5s (scale .94); still → `axStill` 9s (scale 1.015).

The body sits in a viewBox −60 −70 120 140 with a radial-gradient fill and drop-shadow glow.

### X-04 · The watching point: Bindu on every level (L167–183)
- A 26px radial point: cream .9i → hsl(46,72,66,.8i) 22% → hsl(2,68,50,.5i) 46% → transparent 72%.
- Blur .6/scale; glow 18i; animation `axBreath` 4s.
- Scale transitions over 1.1s cubic-bezier(.4,0,.2,1).

| level | scale | intensity |
|---|---|---|
| cosmos | 1 | .55 |
| ring | 1 | .55 |
| seat | .7 | .55 |
| felt | 1.4 | 1 |
| bindu | **26** (fills the screen) | 1 |

**Press-and-hold:** active **only at ring and seat**. Pointer-down starts a 20ms interval adding 1/45, so it completes in **900ms**. A progress ring (r40, gold, .5) draws around the point. Completion → `alt = 'bindu'`. Release or leave cancels.

⚠ `axBreath` keyframes include `translate(−50%,−50%)`, which offsets the Bindu's inner div and the Arrival background. This is a visual glitch.

### X-05 · Depth gauge and chrome recession (L208–219, L252–259)
**Gauge:** LEVELS cosmos · ring · seat · felt · bindu, labelled COSMOS / THE RING / THE SEAT / FELT / BINDU (mono 8px). Right 16, vertically centred. The current dot is 7px gold with glow, reached dots gold, the rest .18. Only the current level is labelled.

**Chrome density** (Zero-Gap): `{cosmos 1, ring .8, seat .6, felt .25, bindu 0}`. The gauge fades with `.15+.85×chrome`; TopCap, BottomHint and BackArc fade with chrome.

**Background:** bindu `--silence`, felt `--veil`, otherwise radial(120% 90% at 50% 42%, atmo.ground → groundDeep 68% → --ground-deep), transitioning over 1.2s.

**Motes:** 6 at bindu, else 14 random (2px, accentBright, `axFloat` 6–14s).

**Level transition:** opacity 0 → 1 over 1s; scale **1.12 → 1** over 1.2s cubic-bezier(.2,.7,.2,1), re-run on every alt or focus change. Each move reads as falling **into** the next level.

### X-06 · Levels walked (L225–309, L331–377)
**COSMOS:**
- `Yantra` at .16 opacity: two squares, 16+8 dots, 4+3 triangles, centre point.
- The 16 Karṣiṇīs as 44px buttons on a circle, R 118, centred at 41%. Dots are 6px, or 9 once felt.
- TopCap: eyebrow "the whole instrument", title "Śrī Yantra" (34px), sub "102 presences · nine āvaraṇas".
- BottomHint: **"Touch a light to fall inward · hold Bindu to reach the source"**. ⚠ The hold is **disabled** at cosmos (`onHold` is null), so this hint promises an action that does not work.
- Tap a light → focus it, go to **ring**.

**RING** (always ring 2):
- `RingSpace`: the 16 seats as 52px buttons at R 120, centred at 46%. Dot sizes: focus 18, felt 13, else 11. Labels show the name without "ākarṣiṇī" (italic 11).
- **Tapping the empty field** pulses the ring: a ripple (`axRipple` 1.8s, 20 → 320px) and all dots shimmer (`axShimmer` 1.4s).
- **Arrival beat:** the presiding form **"Tripureśī"** (italic 30px, accentBright) shows on arrival and recedes after **2600ms** (1.6s fade). Verbatim comment: *"presiding form named once, then recedes"*.
- TopCap (small): eyebrow "2nd āvaraṇa · Svādhiṣṭhāna", sub **"LIQUEFY · she who fills all longing"**.
- BackArc "‹" (44px circle, top 44, left 20) → cosmos.
- BottomHint: **"Touch a seat to meet her · touch the empty field for the ring's own breath · hold Bindu to fall"**.

**SEAT:**
- BackArc → ring.
- Kicker: cluster dot plus **"{cluster label} · {element}"** (mono 9). Cluster labels: Inner Instrument / Sense Streams / Citta / Stability / Self · Body · Immortality.
- `Body` at size 230.
- Name at 46px (weight 300); "{phon}  ·  {field}" (mono 10); quality (italic 21 accentBright); 40px hairline.
- **"She is the drawing-in of *{quality lowercased}* — already running in you before the app was opened."** (13.5px).
- Button **"I feel her"**, or **"felt her again"** once felt: 280×58, radius 30, gradient accent-red → hsl(348,60,30).

**FELT** (recognition):
- `--veil` background.
- Three rings **converge inward** (`axConverge` 3.4s, staggered .9s, 320 → 24px).
- "she was felt here · {HH:MM}" (15px, .7).
- At **2400ms**: **"and she felt you back · {HH:MM}"** (italic 27, gold).
- At **4100ms**: **"her point is lit · touch to return"** (mono 9.5). Tapping then marks the Śakti felt (an in-memory Set, **not persisted**) and returns to the seat.

**BINDU** (Arrival):
- `--silence` background, breathing radial rgba(232,201,122,.16).
- After **2600ms**, fading in over 2.4s: **"Lalitā Mahātripurasundarī"** (24px, gold-bright) and **"You did not arrive.<br/>You were the arriving."** (italic 19).
- Tapping after it shows → cosmos.

**Navigation model:** a strict vertical axis: cosmos ↔ ring ↔ seat ↔ felt, plus a hold to the bindu.
- `rise()`: bindu → cosmos, felt → seat, seat → ring, ring → cosmos.
- `descend()` is defined but **unused**.
- Default focus = **Bījākarṣiṇī (the "bridge")**.

### X-07 · Keyframes (L407–418)

| name | animation |
|---|---|
| axBreath | opacity .72 ↔ 1, scale 1.08, with translate(−50%,−50%) |
| axDot | opacity .68 ↔ 1, scale 1.14 |
| axFloat | (6px, −12px) |
| axDrift | — (see X-03) |
| axPull | — (see X-03) |
| axStill | — (see X-03) |
| axRipple | 20 → 320px, op .7 → 0 |
| axShimmer | scale 1.5 + brightness 1.5 at 40% |
| axConverge | 320 → 24px, op 0 → .6 at 30% → 0 |

### X-08 · What the Axis adds that the Living Rite lacks
- A **continuous vertical axis**: depth is a gauge, and chrome recedes as you descend (Zero-Gap).
- A **persistent Bindu** visible on every level, used as the press-and-hold door to the source.
- **Grammar-built bodies** (silhouette, attribute, surface, motion) in place of sigils.
- A **ring breath**: tapping the empty field pulses the whole ring.
- A **presiding-form arrival beat**.
- **Converging** recognition rings (inward), against the Living Rite's element-specific outward ripples.
- A **different Bindu arrival line**: "You did not arrive. You were the arriving." The Living Rite's Lalitā line is "There is nothing else here…".

### X-09 · Data read
Only the hard-coded RING2 and RINGS tables. No shakti-data or all-shaktis is loaded.

---

## §A4 — THE FIELD (`Bindu Mandala - The Field.html`): analysis document, not an app screen

This is a static, scrolling, editorial page. The "Field" here means the field of analysis. It is **not** the Living Rite's Field screen.

**Typography and colour:**
- --measure 720, ambient gold and red radial gradients, kicker 10.5px.
- Masthead h1 clamp(48px, 10vw, 84px), weight 300.
- SWOT 2×2 grid, single column below 560px.
- Quadrant colours: S `--green #5A9A8B`, W `--rose #C4725A`, O `--gold`, T `--violet #9A86C4`.
- Coherence pull quote with a red left border.
- Three direction cards (I/II/III) and an approval box.

**Verbatim content (key lines):**
- Kicker: "The Field · Analysis & Where This Goes"
- H1: "What it is. / What it could become."
- Sub: "A SWOT, a coherence read, and three monumental directions — presented for your approval, before I write the brief."
- §i "The field, squared": "An honest read of where the app stands — grounded in the live source, not the spec."
  - **Strengths** ("what almost nothing else has"):
    - Conceptual integrity: "The interface *is* the teaching — the Veil is an āvaraṇa, the descent is a descent. Metaphor and mechanism are the same word."
    - A living object: "The mandala breathes with the hour and the moon. It has weather. You return to something changed."
    - Tone held at scale: "…never once becomes a wellness app. No streaks, no badges."
    - The Portrait: "Your attention drawn as the yantra".
    - The voice.
  - **Weaknesses** ("all problems of abundance"):
    - No spine: "The daily rite that was the whole point is buried; the app reads as a museum you browse, not a practice you keep."
    - Discoverability: "Two hidden doors, no signpost. Half the app can go unfound."
    - Density without hierarchy: "the detail screen reads like a wiki entry; the soul sits seventh."
    - The floor: "Legibility and touch targets cross from *quiet* into *unusable* in places."
    - Uneven bar.
  - **Opportunities** ("the unrealized power"): Time as the medium; The authentic path ("Śrī Vidyā already *is* a structured ascent through the āvaraṇas"); The years-long artwork; The devotional calendar ("Each Śakti has her day. The lunar wheel could make the app a living observance."); Singularity ("The moat is depth, not features.").
  - **Threats:** Feature creep ("Every new room is a tax on the whole."); The museum deepening; Retention; Bespoke scope; Drift ("Decisions made by accumulation, not intention").
- §ii "The one thing I'd stake it on": **"This is a relationship that deepens over time — but it presents as a place to browse."** Then: "…make **time the medium** — to stop being an app you open, and become a practice you are inside of."
- §iii "Three monumental directions" ("Not three features — three faces of one idea. The path, the artifact, the pulse."):
  - **I · The Descent**, "the path — a pilgrimage, not a museum". "You don't unlock Ring 4 by tapping; you arrive at it because you have *sat with* Rings 1–3. The Veil stops being a menu and becomes a threshold you are permitted to cross." Resolves: the daily-spine vs. museum problem.
  - **II · The Portrait Becomes the Home**, "the artifact — a years-long living artwork". "Your own Śrī Yantra, beginning nearly dark, filling in petal by petal, triangle by triangle… warmer where you've been recently, dim where you have not yet walked." Resolves: retention & the "why return".
  - **III · The Daily Rite, Re-Centred**, "the pulse". "today's Śakti, drawn from where you are in the Descent; one breath with her somatic line; a single gesture of recognition that lights one more point of the Portrait. Thirty seconds. Repeatable. The engine." Resolves: the spine, discoverability, and the status ceremony.
- Approval: "Where do you want to take this play?" Options:
  - ◇ The fixes: "Rings 1/3/6/8/9 + the five audit calls. Always in."
  - I Descent
  - II Portrait as home
  - III Daily Rite
  - Recommendation: **"all three, in that order — but III first in code, because the heartbeat is small, and the path and the portrait are only meaningful once there's a daily pulse to fill them."**

Its place in the chain: it is the decision document that precedes the Final Handoff (DESIGN_SPEC). Directions I, II and III become Phases 4, 5 and 3.

---

## §A5 — SHARED CHROME (prototype-only; README: "do not port")

### C-01 · `ios-frame.jsx` (350 lines)
- An "omelette starter" scaffold that exports IOSDevice, IOSStatusBar, IOSNavBar, IOSGlassPill, IOSList, IOSListRow and IOSKeyboard.
- **IOSDevice:** 402×874, radius 48. Background #000 when dark, #F2F2F7 otherwise. Shadow 0 40px 80px rgba(0,0,0,.18).
- Dynamic island 126×37 at top 11, radius 24, zIndex 50.
- Status bar: absolute, time **'9:41'** (17px, weight 590), signal/wifi/battery SVGs, padding 21/24/19, gap 154.
- Content wrapper is `flex:1; overflow:auto`. A NavBar renders only when `title` is given; neither app passes a title.
- Home indicator 139×5 at bottom, zIndex 60, white .7 on dark.
- IOSKeyboard (QWERTY glass) and IOSList are unused by these prototypes.
- The `LR_SAFE_TOP = 54` and the rite's TOP_BAND 52 clear this status bar and island.

### C-02 · `tweaks-panel.jsx` (542 lines)
- A host-protocol shell: listens for `__activate_edit_mode` / `__deactivate_edit_mode`; posts `__edit_mode_available`, `__edit_mode_set_keys` and `__edit_mode_dismissed`.
- `useTweaks(defaults)` also dispatches a window `tweakchange` event.
- Panel: fixed bottom-right, 280 wide, glass, draggable, clamped to the viewport. It is **hidden until the host activates edit mode**.
- Controls: TweakSection, Row, Slider, Toggle, Radio (segmented; falls back to Select past ~16/~10 chars), Select, Text, Number (scrub), Color (chips/palettes), Button.
- It drives the Rite's Dilation, World and Jump controls and the Living Rite's day, time, intensity and motion.

---

## §A6 — DATA: schema and every per-Śakti field the design reads

### D-01 · `shakti-data.js` (310 lines): the 16 Ring-2 Karṣiṇīs
**Globals:** COLORS, STATUS_OPACITY, CLUSTER_INFO, STATUS_ORDER, SHAKTIS, TODAY_INDEX, TODAY_SHAKTI, PROGRESS.

**`COLORS`:** ground #0D0508, surface #1A0C10, gold #C9963F, goldDeep #A07830, goldFaint rgba(201,150,63,.12), cream #F2E8D9, creamMid .65, creamFaint .35, accentRed #8B1A2A. Clusters: inner #D4A017, tanmatra #C4725A, citta #2A7A7A, stability #4A7A5A, self #7A5A9A. *(Unused by these prototypes.)*

**`STATUS_OPACITY`:** mapped .22, exploring .44, active .76, embodied 1.0. *(Unused.)*

**`CLUSTER_INFO`:** {label, color}: Inner Instrument · Sense Streams · Citta · **Stability Powers** · Self · Body · Immortality. *(Used by the Living Rite for cluster labels.)*

**Clusters by position:** inner 1–3 · tanmatra 4–8 · citta 9 · stability 10–13 · self 14–16.

**SHAKTIS record schema** (`id, pos, short, name, phonetic, quality, bija, cluster, location, status, somatic, description, somaticPoetry, tattva, recognition, fieldConnection?{field, note}`):

| field | read by design? | where |
|---|---|---|
| name | yes | everywhere |
| short | yes | Mandala tier-1 labels |
| phonetic | yes | Today, Detail, Mandala card |
| quality | yes (`lrQuality`) | Today, Detail, card |
| bija | yes | Today foot, Detail BijaGlyph, card, tier-2 label, Recognition 320px glyph; split on " — " |
| cluster | yes | hue seed, family, kicker, dots |
| tattva | yes | element → archetype, recognition response; "Tattva" deep row |
| somatic | yes | Today prompt (`lrPrompt`) |
| somaticPoetry | yes | Detail "Somatic signature"; prompt fallback (first line) |
| description | yes | Detail portrait; Mandala card significance |
| recognition | yes | Recognition phrase; Detail appreciation |
| location | yes | Detail "Bodily seat" (values: heart, head, solar, ears, skin, eyes, tongue, nose, whole, spine, temples, throat, sacrum, crown) |
| status | **no** | ignored (embodiment comes from `lr_cross_*`) |
| fieldConnection | **no** in the Living Rite | Axis carries its own `field` column. Gaia → Ahaṅkārā (3), Ashrey → Nāma (12), Ram → Ātma (14). Notes verbatim in L87–90, L229–232, L264–267. |
| id, pos | no | kp is derived instead |

`TODAY_INDEX = 4` (Sparśākarṣiṇī) and `PROGRESS` are **unused**. They are legacy from a status-display era that the "felt, not measured" rule forbids.

### D-02 · `all-shaktis-data.js` (332 lines): nine āvaraṇas, the other 86, Nityās
**AVARANAS record schema:** `id, ring, status, name, subtitle, form, formDescription, count, presidingForm, yogini, mentalState, chakra, geometry, appreciationPhrase, personalConnection`.

| ring | status | name | subtitle | form | count | presidingForm | yogini | mentalState | chakra | geometry |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | ancient | Trailokyamohana | She Who Enchants All Three Worlds | Bhupura | 28 | Tripurā | Prakaṭa | Jāgrat — waking consciousness | Mūlādhāra | square |
| 2 | home | Sarvāśā-Paripūraka | She Who Fulfills All Hopes | 16-Petal Lotus | 16 | Tripureśī | Gupta | Svapna — the dream state | Svādhiṣṭhāna | lotus16 |
| 3 | unlocked | Sarvasaṅkṣobhaṇa | She Who Agitates All | 8-Petal Lotus | 8 | Tripura Sundarī | Guptatarā | Suṣupti — the deep sleep awareness | Maṇipūra | lotus8 |
| 4 | locked | Sarvasaubhāgyadāyaka | She Who Grants All Auspiciousness | 14 Triangles | 14 | Tripura Vāsinī | Sampradāya | Turīya — the fourth state | Anāhata | tri14 |
| 5 | locked | Sarvārthasādhaka | She Who Accomplishes All Goals | 10 Outer Triangles | 10 | Tripura Śrī | Kulotīrṇā | Turīyātīta — beyond the fourth | Viśuddha | tri10o |
| 6 | locked | Sarvarakṣākara | She Who Protects All | 10 Inner Triangles | 10 | Tripura Mālinī | Nigarbhā | Śāmbhavī — pure Śiva-awareness | Ājñā | tri10i |
| 7 | locked | Sarvarogahara | She Who Removes All Disease | Vāk Ring | 12 | Tripura Siddha | Rahasya | Unmanā — beyond mind | Bindu | tri8 |
| 8 | deep_ghost | Sarvasiddhiprada | She Who Grants All Perfections | Mūla Trikoṇa | 3 | Mahā Tripura Sundarī | Atirahasya | Manonmanī — the summit of mind dissolving | Sahasrāra | trikona |
| 9 | deep_ghost | Sarvanandamaya | She Who Is Made of All Bliss | Bindu | 1 | Lalitā Mahā Tripura Sundarī | Parāparahasya | Samādhi — the undivided | Brahmarandhra | bindu |

**Āvaraṇa fields read by design:**

| field | where |
|---|---|
| name | Field rows, threshold, Detail "Her ring", Mandala family label |
| subtitle | Field, threshold, `lrQuality` fallback |
| form | kickers, Mandala ring labels, Field caption |
| formDescription | Detail "Form" |
| count | threshold "{count} śaktis" |
| mentalState | Field caption, threshold, Detail |
| chakra | threshold, Detail |
| geometry | sigil |
| appreciationPhrase | Recognition and Detail fallback; threshold |
| personalConnection | Detail portrait fallback; Mandala card; threshold body |

Not read: `status` (ancient/home/unlocked/locked/deep_ghost), `presidingForm`, `yogini`, `id`. The `status` values imply a gating model that the Living Rite does not enforce. The Descent (Phase 4) would.

All nine `appreciationPhrase` and `personalConnection` texts are verbatim at L19–20, 34–35, 49–50, 64–65, 79–80, 94–95, 109–110, 124–125 and 139–140. Each personalConnection opens "You have already been here." Ring 2 opens "You are here now." Ring 9 opens "You have always been here."

**Ring lists** (record schema `id, ring, pos, name, short, [bija], [quality]`):

| ring | contents | fields |
|---|---|---|
| R3 | 8 Anaṅgas, ids 301–308 | name, short, bija ('hsauṁ' for all eight), quality |
| R4 | 14, 401–414 | name, short |
| R5 | 10, 501–510 | name, short |
| R6 | 10, 601–610 | name, short |
| R7 | 12, 701–712 | name, short |
| R8 | 3: Kāmeśvarī (Icchā-Śakti), Vajreśvarī (Jñāna-Śakti), Bhagamālinī (Kriyā-Śakti) | short holds the śakti type; quality |
| R9 | Mahātripurasundarī, short **'Lalitā'** | quality "She who is made of all bliss — the undivided ground from which all 102 Shaktis emerge and to which they return" |
| R1 | 28, 101–128: 10 Siddhi (Animā…Sarvakāmāvalī), 8 Mātṛkā (Brāhmī…Mahālakṣmī), 10 Mudrā at pos 19–28 | name, short |

⚠ **DATA ERROR:** the ten Ring-1 Mudrā names (pos 19–28) are an exact copy of Ring 4's first ten names (Sarvasaṅkṣobhiṇī … Sarvonmādinī). The canonical Mudrās include Sarva-Yoni (27) and Sarva-Trikhaṇḍā (28), as the Rite's specimens show. ⚠ R7 lists 12 names under geometry `tri8`, and its chakra 'Bindu' conflicts with the other two tables.

Consequence: rings 1 and 3–9 carry **no** somatic, description, somaticPoetry, tattva, recognition or phonetic data. Every screen falls back to āvaraṇa-level text and the default prompt. Only ring 3 has a bīja, and ring 3 has quality.

`SHAKTIS_BY_RING` maps 1–9 (ring 2 → SHAKTIS when it is defined).

**`NITYA_DEVIS`** (15): `{tithi, tithiName, name, quality:null, bija:null, dhyana:null}`.

| tithi | tithiName | name |
|---|---|---|
| 1 | Pratipadā | Kāmeśvarī |
| 2 | Dvitīyā | Bhagamālinī |
| 3 | Tṛtīyā | Nityaklinnā |
| 4 | Caturthī | Bheruṇḍā |
| 5 | Pañcamī | Vahnivāsinī |
| 6 | Ṣaṣṭhī | Mahāvajreśvarī |
| 7 | Saptamī | Śivadūtī |
| 8 | Aṣṭamī | Tvaritā |
| 9 | Navamī | Kulasundarī |
| 10 | Daśamī | Nityā |
| 11 | Ekādaśī | Nīlapatākā |
| 12 | Dvādaśī | Vijayā |
| 13 | Trayodaśī | Sarvamaṅgalā |
| 14 | Caturdaśī | Jvālāmālinī |
| 15 | Pūrṇimā | Citrā |

Verbatim rule: **"Qualities + dhyānas flow from Airtable — DO NOT INVENT THESE FIELDS. The schema below is the rendering contract; Airtable fills the descriptive text."** Only `tithiName` and `name` are rendered.

---

## §B — DESIGN'S STATED INTENTIONS (verbatim) AND ACCEPTANCE CRITERIA

### B-1 Governing statements (design_handoff_living_rite/README.md L5–14; DESIGN_SPEC.md L5–7)
- "…turns the app from *a thing you open* into *a practice you are inside of*: a daily encounter with one Śakti whose entire screen is generated from her nature, a living Śrī Yantra you descend into, and a Portrait that lights one point each time a Śakti is felt."
- **"Governing idea: *Time is the medium.*"**
- **"Governing rule: *Readiness is sensed; crossing is always chosen.* The app may notice when a Śakti has ripened or a ring is ready — but the practitioner always makes the deliberate gesture. Never auto-advance."**
- "Practitioner: Single — this is Ash's own instrument, built around his field (Gaia / Ashrey / Ram). Not a multi-user product. Design every decision for *one* person's years-long practice."
- "This document supersedes `Bindu Mandala - Claude Code Brief.md`, `Bindu-Mandala-Handoff.md`, and `Bindu-Mandala-Handoff-II.md`. Where they conflict, this wins."
- The prototype "is **not production code to copy** — it is the source of truth for *look, motion, and behavior*… **Fidelity: high.** … Recreate them faithfully in SwiftUI — match the values, not the HTML."
- "When a code sketch and the principles conflict, the principles win. When you must invent, invent *toward* the governing idea."

### B-2 Operating principles: "the bar" (DESIGN_SPEC §1)
1. "**The interface *is* the teaching.** An interaction embodies what a thing *is*; it is never a screen of information *about* it. The Veil is an āvaraṇa. The descent is a descent. If a feature explains rather than enacts, redesign it."
2. "**Atmosphere, not page.** Dark ground, warm light from within, dust motes, generous negative space, one quiet identity line. Ride the existing tokens (`Color.ground`, `.gold`, `.cream`, `.accentRed`, the five cluster colors). **Never introduce a new color.**"
3. "**She is felt, not measured.** No streaks, no scores, no badges, no progress bars, no nags. Counts may exist *only* to sense readiness — never displayed as achievement. The recognition log is a private archive: never synced, never analyzed."
4. "**Readiness is sensed; crossing is chosen.** Applies identically to status advancement and to descent crossings."
5. "**The floor.** Every tap target **≥ 44pt**. Any text meant to be *read* **≥ 11pt and ≥ 0.3 alpha**. Below that is *texture* — a deliberate decision, never an accident of scale."
6. "**Respect the breath.** Honor `prefers-reduced-motion` / `accessibilityReduceMotion` everywhere. Persist state so a refresh/relaunch never loses the practitioner's place."

- "The single most important idea to carry over: *nothing in this app is a static screen.* Every surface is **generated from the Śakti herself** — her ring, cluster, tattva/element, and the hour of day."
- "**Do not hand-pick colors per screen.**" "Port as a `struct Atmosphere` computed from a Śakti" with a static `derive(from: Shakti, at: TimeVariant)`: "pure, deterministic, testable".

### B-3 Port targets named (DESIGN_SPEC §2)

| section | prototype piece | native target |
|---|---|---|
| §2.1 | atmosphere | `Theme/Atmosphere.swift` (new), plus a `backgroundGradient(for:)` switch on element |
| §2.2 | time variants | the existing `TimeVariant.swift`, extended; "thread it through *every* atmosphere consumer" |
| §2.3 | day cycle | "keep the native" lunar-day assignment; "Match the native moon math to this if they diverge." |
| §2.4 | six archetypes | `Views/Today/DailyRiteView.swift`, "six SwiftUI layout branches off `atmosphere.element`, sharing one content model". "Use the size scale from `DESIGN_SPEC.md` (name 44–48, quality 20–22, somatic 18–20)." ⚠ That scale is in the *other* `DESIGN_SPEC.md` at the top level (the 16-Karṣiṇī design spec, not in this assignment). The prototype's own sizes are larger: name cap 52–66, quality 25, prompt 20. |
| §2.5 | Detail | `ShaktiDetailView.swift`: "store the crossed level on the Śakti (or a small `EmbodimentState`), sense readiness from `RecognitionEntry` count, cross by a held gesture with a soft haptic and a held beat". "Lead with the soul; hide the encyclopedia." |
| §2.6 | recognition | `RecognitionMomentView`: "writes a `RecognitionEntry(gesture: .felt)` at the **global 1–102 position**…, local-only, never synced." Sequence: name + phrase, then "She was felt here · [time]", then a held beat, then "and she felt you back · [time]", then the optional "What did you notice?" note ("Tapping it must not dismiss"), then the collapse inward into the Portrait. |
| §2.7 | Mandala | `SriYantraMandalaView.swift`: "SpriteKit or a `Canvas`/`TimelineView` with a matched-geometry camera". "Preserve the **guards** (`moved`, `animating`, re-arm) — they are what make the gestures feel solid on device." Chimes are "**Opt-in**… default **off** for a fresh visitor so no one is surprised." |
| §2.8 | Field, Well, Portrait | `TheHundredTwoView`, archive, `PortraitMandalaView`. "Audio note: `lrPlayBija` (a 3.6s meditative drone…) and `lrRingChime` (a 1.7s bell) are distinct voices — keep them distinct in the native mix." |

### B-4 Acceptance criteria ("Done when", DESIGN_SPEC §3)
- **Phase 1, Repairs:** "Introduce a shared `enum Hit { static let min: CGFloat = 44 }`… Ring 9 trailing field, Ring 8 twelve-voice overlap, Ring 1 touch+scale, Ring 6 precision gate, Ring 3 dead glow/motes." **Done when:** "all nine worlds hold the same bar — every energy ≥44pt, no overlaps, no dead renders, no stray content."
- **Phase 2, Recognition 102-aware:** migrate `RecognitionEntry.shaktiPosition` (per-ring 1–16) to `khadgamalaPosition` (1–102) plus a denormalized `ringNumber`. **Lossless** SwiftData migration via the Ring-2 offset. **Done when:** "any recognition maps to exactly one of the 102 and no pre-existing entry is lost."
- **Phase 3, Daily Rite:** `DailyRiteView.swift` plus `Services/DailySummons.swift` ("**one** tender local notification/day at a chosen hour (*'She is waiting.'*), no count/streak/badge, silenceable forever"). Design calls: "make the Rite the launch spine (Mandala one gesture away); the deliberate status-crossing; detail hierarchy with 'go deeper'; a one-time first-run breath on the hamburger; a legibility pass." **Done when:** "opening the app lands on (or one tap from) today's Śakti + gesture; 'I feel her' logs and lights a point; at most one gentle summons/day."
- **Phase 4, Descent:** `DescentState` (currentRing, deepestReached, crossings[], enteredCurrentAt). "the **next** ring a breathing, named-but-closed threshold crossed by a **deliberate gesture** (press-and-hold / worded invitation), never a plain button. **Content gates the path** — a ring opens only once its Śaktis have authored `somatic` + `recognitionPhrase` (`contentReady(ring:)`); until then, *'not yet — she is still becoming words.'* Today's Śakti follows the descent." The Bindu → Lalitā descent is the finale. **Done when:** "the Veil shows where you are, the next ring is crossed by a deliberate act only when its content is ready, reached rings stay open, and crossing *feels* like a threshold."
- **Phase 5, Portrait:** "Each of the 102 points begins near-dark and brightens with felt-count; warmer/brighter when felt recently, cooling with neglect (reuse `TimeVariant` warmth). Reachable in one gesture from the Rite… **No numbers, ever**." **Done when:** "every felt-moment lights its correct point among the 102 and, over months, the Portrait becomes a true mirror of where attention has lived — with not a single number on screen."
- **§4 Stretch** (mark as stretch in commits): a continuous ring drone; a home-screen widget for today's Śakti (WidgetKit); "the descent as a remembered film". Also from prior briefs: an exportable high-res Portrait (no branding or numbers) and a timed Silence dwell logged as `.silence`.
- **§5 PR sequence:**
  1. PR-1 touch constant + two one-line fixes
  2. PR-2 Ring 1/6/3
  3. PR-3 recognition migration
  4. PR-4 Atmosphere + TimeVariant
  5. PR-5 Daily Rite
  6. PR-6 Detail
  7. PR-7 DescentState + Veil ladder + threshold + chimes
  8. PR-8 living Mandala
  9. PR-9 Portrait
  10. PR-10+ stretch
- **§6 Definition of done:** "It is a practice you are inside of: it opens to *her*, rendered in her own element and re-lit by the hour; it asks once, gently, each day; recognition responds in her nature and lights a point that never goes out; the way inward has an order, a sound, and a destination — the Bindu, where Lalitā waits — that you cross by choice; and over months a portrait of your own attention assembles itself, with not a number anywhere, because *she is felt, not measured.*" "When in doubt: **readiness is sensed; crossing is always chosen.** Build toward the practice someone keeps for years."

### B-5 README-specific
- "How to run": `cd prototype; python3 -m http.server 8000`; "must be served over HTTP (not opened as a `file://` URL)". "To reset, clear the `lr_*` keys."
- Tokens: "Ground `#0D0508` · page backdrop `#161013`; Gold `#C9963F` · hover→ Cream `#F2E8D9`… Never introduce a color outside these." "Type: Cormorant Garamond (300/400/500 + italic 300/400)". Real repo: `AppFont.cormorant`.
- "Assets: None external. All imagery is drawn at runtime as SVG… or CSS."
- Approach: (1) run and walk every screen; (2) read core end-to-end; (3) build Atmosphere + TimeVariant first, then Daily Rite, Detail/Recognition, Mandala/Descent, Portrait; (4) "Keep to the existing color tokens and the 'she is felt, not measured' rule (no streaks, scores, badges, or numbers on the Portrait)."

### B-6 Rite of Entering intentions (code comments, verbatim)
- "The Turrell mechanism lives here: one normalized value `a` advances so slowly that nothing appears to happen, and every surface in the room reads from it." (rite-core L2–3)
- "the building's grammar, walked: entering (self-paced), dwelling, the descent, the doors, leaving. The specimen only fills slots." (rite-app L1–2)
- "Sound (gates only, opt-in)" (rite-core L200)
- "the library, folded behind the room" (dwelling L134). Superseded by: "'go deeper' is not a sheet."
- "the floor of her — the facts, once the fall is done" (descent L256)
- "World (previews P1–P9)": the nine rooms are previews P1–P9.

---

## §C — COVERAGE PROOF

All files were read with the Read tool from line 1 to EOF. Line counts are from `wc -l` (newline count). Where the file ends with a newline, Read shows one extra empty line N+1, which was also reached. No file required pretty-printing; the longest line in the set is 923 characters (`design_handoff_living_rite/DESIGN_SPEC.md` L149).

| file | total lines (wc -l) | lines read | notes |
|---|---|---|---|
| Bindu Mandala - The Rite of Entering.html | 42 | 1–42 (+43 EOF) | full |
| rite-core.jsx | 238 | 1–238 (+239) | full |
| rite-threshold.jsx | 118 | 1–118 (+119) | full |
| rite-seat.jsx | 248 | 1–248 (+249) | full |
| rite-dwelling.jsx | 210 | 1–210 (+211) | full |
| rite-descent.jsx | 314 | 1–314 (+315) | full |
| rite-app.jsx | 220 | 1–220 (+221) | full |
| Bindu Mandala - The Living Rite.html | 132 | 1–132 (+133) | full; byte-identical to prototype/index.html |
| living-rite-core.jsx | 614 | 1–614 (+615) | full; identical to prototype copy |
| living-rite-today.jsx | 215 | 1–215 (+216) | full; identical |
| living-rite-mandala.jsx | 480 | 1–480 (+481) | full; identical. 3 lines >400 chars (L157, 394, 464), read whole |
| living-rite-field.jsx | 340 | 1–340 (+341) | full; identical |
| living-rite-detail.jsx | 370 | 1–370 (+371) | full; identical |
| living-rite-more.jsx | 256 | 1–256 (+257) | full; identical |
| living-rite-app.jsx | 201 | 1–201 (+202) | full; identical |
| design_handoff_living_rite/README.md | 163 | 1–164 (no trailing newline; 164 content lines) | full |
| design_handoff_living_rite/DESIGN_SPEC.md | 187 | 1–187 | full. **Byte-identical to top-level `Bindu Mandala - Final Handoff.md`** (cmp equal, 21728 B). **Differs** from top-level `DESIGN_SPEC.md` (9999 B, 223 lines: the older 16-Karṣiṇī design spec, outside this assignment; only its first 5 lines were looked at, to identify it). |
| design_handoff_living_rite/prototype/index.html | 132 | via the identical top-level file | `cmp` identical, read once |
| …/prototype/living-rite-{app,core,detail,field,mandala,more,today}.jsx | 201/614/370/340/480/256/215 | via the identical top-level files | all 7 `cmp` identical, read once |
| …/prototype/ios-frame.jsx, tweaks-panel.jsx, shakti-data.js, all-shaktis-data.js | 350/542/310/332 | via the identical top-level files | all 4 `cmp` identical, read once |
| Bindu Mandala - The Living Axis.html | 423 | 1–423 (+424) | full |
| Bindu Mandala - The Field.html | 218 | 1–218 (+219) | full; 4 lines >400 chars, read whole |
| ios-frame.jsx | 350 | 1–350 (+351) | full |
| tweaks-panel.jsx | 542 | 1–542 (+543) | full |
| shakti-data.js | 310 | 1–310 (+311) | full; schema + design-used fields recorded (§A6) |
| all-shaktis-data.js | 332 | 1–332 (+333) | full; 3 lines >400 chars (L20, 50, 65), read whole |

**Totals:**
- Unique files read: 23. Combined wc -l = 6,173 (the top-level 21-file sum from `wc`) + 163 + 187 = **6,523 lines**.
- Duplicates verified by `cmp`: 12 prototype files plus DESIGN_SPEC ↔ Final Handoff.

---

## §D — MUST NOT MISS (how the pieces connect)

1. **There are three generations of the same instrument.** They connect by idea, not by code. They share no modules: different engines, different data, different navigation.
   - The **Rite of Entering** is one Śakti's room, built over minutes: perceptual adaptation, a threshold, stillness, a descent.
   - The **Living Axis** is a concept for one continuous vertical axis.
   - The **Living Rite** is the handed-off app model. It is the only one the Final Handoff names as "source of truth".

2. **Living Rite navigation is a flat router, not a stack.** `nav = {screen, kp?, from?, ring?, settle?, momentTs?}` is persisted in `lr_nav`.
   - The hamburger menu offers five rooms: **The Rite (Today) · The Mandala · The Field · The Well · The Memory**. "Settings" is dead.
   - Detail returns to `from`.
   - Recognition **always** exits to the Memory, whatever its origin.
   - The Memory has no exit except the hamburger.

3. **Every way into Her Presence (Detail):**
   - Today, via the name, "know her ›", or the full-screen veil name on ether days.
   - Field, by tapping a row.
   - Mandala, via the card's "enter her presence" or a second tap on the focused seat.
   - Lalitā, via "enter her presence", which opens kp 102.

   Ways into Recognition: "I feel her" on Today or Detail (and "I feel her" / "felt her again" on the Axis seat).

4. **The recognition → Portrait handoff is one continuous gesture.**
   - The moment `{kp, ts, note}` is written **before** the ceremony.
   - On close, `lrCollapse` gathers into the point.
   - The Memory then opens with `settle: kp`: her gold point flies out of the bindu to her seat (0–.34), a halo blooms (.34–1), and the field fades in.
   - Port it as one transition.

5. **Living Rite Threshold → Field is broken in the prototype.** "enter her ring" sends `openRing`, but `FieldScreen` is never passed it, so today's ring opens instead. Native must honour the intent: enter → that ring open.

6. **One atmosphere drives every surface.**
   - Inputs: ring or cluster hue, ±7° kp jitter, element (from tattva for ring 2, from the ring table otherwise), āvaraṇa geometry for the sigil, and the time-of-day relight.
   - **Not relit by time:** the Mandala focus card, the Threshold, and the Field ring chips (they pass null or no tv).
   - **Defined but unused:** `moteMul` and `gradAngle`.

7. **Element decides structure, not just colour.** Six TD_PLANS reorder the same blocks: fire puts the name last; ether makes the name the backdrop and the whole screen the door; air leans and adds a horizon. The same element drives the Recognition response (LR_RECOG) and the mote physics. With the current data, 6 of the 16 ring-2 Śaktis resolve to ether: 3 by fallback (Cit, Sat, Amṛta) and 3 from Ākāśa. The Axis assigns different elements to Ahaṅ, Nāma, Ātma and Amṛta. A ruling is needed on which table is canonical.

8. **The Mandala is a semantic-zoom camera with guards.**
   - Tiers at scale 1.15 and 2.3.
   - Fly-to-seat at scale 3 with the seat at 36% height.
   - Family threading (cluster for ring 2, ring otherwise; others dim to .28).
   - Inward-only ring chimes and flashes.
   - **Auto-descent** at scale > 4.3 within 64px of centre, re-armed below 2.8.
   - The `moved`, `animating` and `armed` guards are the ones to preserve.
   - Auto-descent is the one place the prototype advances without an explicit tap, against "Never auto-advance". The spec accepts it as a chosen deep zoom; flag it for Ashrey.

9. **The Bindu has two designed arrivals, with different words.**
   - Living Rite Lalitā: a red bloom, "Lalitā" at 68px, "There is nothing else here…", ॐ "sound the source", "enter her presence", "↑ return to the field".
   - Axis: a press-and-hold of the persistent Bindu (900ms, ring or seat levels only), scale ×26, "You did not arrive. You were the arriving."
   - The handoff's Phase 4 makes the descent a pilgrimage whose finale is Lalitā.

10. **Readiness and crossing in practice:**
    - Embodiment: felt counts [0,1,3,7] make the next level *available*. A **750ms press-and-hold** crosses one level and gives a 12ms haptic.
    - Phase 4 rings: a press-and-hold or a worded invitation, gated by `contentReady(ring)`, with the copy "not yet — she is still becoming words."
    - The Axis Bindu: a 900ms hold.
    - The Rite threshold: a tap per beat, self-paced, never auto-advanced.

11. **The Rite's clock is the Turrell mechanism.**
    - One value `a`, smoothstep², over 90s × the rate multiplier (fast .72 / even 1 / slow 1.38 / late 1.12).
    - A hold of 165s, then the second adaptation `b` over 120s, which reveals the whole Śrī Yantra **beyond the far wall** while her signature fades.
    - Reduced motion lengthens the times (adapt 160, hold 190, second 150) and quantises a and b to 4 and 3 steps. It does **not** remove the adaptation.

12. **Rite stillness gating:** the portrait lines appear only after a ≥ .4 **and** 10.5s, 17s, 23.5s, 30s and 36.5s of unbroken stillness. Touching the room's own buttons does not break stillness. Lines never retract.

13. **Rite memory and return:**
    - `rite.visits.v1` compresses the threshold's writing (×.66, ×.4356, floor .36). The ceremony is never skipped.
    - Leaving leaves a 180s after-effect (lighter, heavier, sharper or wider, set by the ring) on the whole instrument.
    - Doors (left and right edges, in the room and the corridor) walk khaḍgamālā neighbours.
    - There is a visit-count off-by-one quirk (R-05).

14. **The Rite "go deeper" is a fall through five chambers:** what she does · where she is felt · how she appears · the principle · her name, opened. Then "the floor of her" (the facts) and "rise back into her room". The older `RiteLibrary` sheet is orphaned code. The Living Rite's "go deeper" is a simple disclosure on Detail. The two coexist as designs for different depths.

15. **Room = world, aperture = Śakti.**
    - The ring-world supplies room geometry (square / petal / tri-up / tri-down / circle), the dhātu wall hue, the gem hue and sat, the clock, bīja, region and after-effect.
    - The Śakti supplies the aperture signature (point / triad / tri-down / ring16 / ring8 / band / lens), altitude, rate, lines, letter and phrase.
    - This two-channel uniqueness is the Rite's core design contract.

16. **Sound map (four distinct voices):**

    | voice | parameters | trigger | gating |
    |---|---|---|---|
    | Rite room drone | 4 sines from the ring bīja Hz; fifth opens with b | in the room | opt-in |
    | Living Rite bīja | pentatonic, hash-pitched, 3.6s | tap | **ungated** |
    | Ring chimes | 392 → 196 Hz descending inward, 1.7s bell | inward ring crossing | opt-in via `lr_sound`, default off |
    | Lalitā ॐ | uses lrPlayBija | "sound the source" | **ungated** |

    DESIGN_SPEC: keep the bīja and the chime distinct in the native mix.

17. **Data gaps shape every screen.**
    - Only ring 2 (16) has authored somatic, description, poetry, tattva, recognition and phonetic.
    - The other 86 fall back to āvaraṇa text and "Where do you feel her, right now?".
    - Ring-1 Mudrā names in all-shaktis are corrupted (a copy of Ring 4).
    - The Axis bījas from pos 10 onward and its ring-chakra table disagree with the data files.
    - The Nityā quality and dhyāna fields must come from Airtable ("DO NOT INVENT").

18. **The day model:**
    - Today = a deterministic shuffle of the 102 per 102-day cycle, with the day turning at ~06:00. The spec says keep the native lunar assignment and make Today "follow the descent".
    - The moon strip names the tithi and Nityā, and turns to Lalitā on a full moon.
    - ⚠ Waning-half tithi labels are mirrored (Kṛṣṇa pratipadā shows as "Caturdaśī"). Verify.

19. **Legibility and touch floor violations in the prototype** that native must fix rather than copy:
    - Mandala seat hit areas from 26px; seat names 9px and bīja lines 7.5px, counter-scaled.
    - Axis gauge labels 8px; Lalitā "sound the source" caption 8px.
    - Rite progress bars and hints at 10.5px with opacity .34–.4.

    The rule is ≥ 44pt targets and ≥ 11pt / .3 alpha for anything meant to be read.

20. **The Well ≠ the recognition archive.** In code the Well is **letters to the 16 Karṣiṇīs** (`lr_letter_<kp>`, autosaved, opened from the Well only). Recognition notes live per moment in **Her Moments** on Detail, with a moon-phase stamp. The README and spec wording blur the two.

21. **The Axis contributes patterns the Living Rite lacks.** These are candidates to merge into the native Descent:
    - the depth gauge, with chrome receding by depth (1 / .8 / .6 / .25 / 0);
    - the persistent watching Bindu;
    - grammar bodies (silhouette, attribute, surface, motion);
    - the ring-breath tap on empty field;
    - the presiding-form arrival beat (named once, recedes after 2.6s);
    - recognition rings that converge inward;
    - the per-ring VERBs (AGITATE, LIQUEFY, DRAW, OPEN, VOICE, STILL, WITNESS, SEED, ARRIVE).

22. **The Field (analysis doc) is the decision record** behind the handoff. It names Descent (I), Portrait as Home (II) and Daily Rite (III), with **"III first in code"**. The Final Handoff turns these into Phases 3, 4 and 5, after the Phase 1 repairs and the Phase 2 recognition migration (1–102 `khadgamalaPosition`, lossless). The migration is the prerequisite for the Portrait.

23. **Persistence keys:**
    - `rite.visits.v1`
    - `lr_nav`
    - `lr_moments` (`{kp, ts, note}`)
    - `lr_cross_<kp>`
    - `lr_letter_<kp>`
    - `lr_sound`

    The native equivalents: RecognitionEntry (global position, local-only, never synced), EmbodimentState or the crossed level on the Śakti, DescentState, and a persisted sound toggle that defaults off.
