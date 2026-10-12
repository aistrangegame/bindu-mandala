# Wave 1 · Slice B — The day's light

*Decisions for the Rite, the backdrops, the strokes, the thresholds and the Field's light. Built under Charter II: Design is the floor.*

## What came home

**1. Sacred geometry at true brightness.** The Reading's measured losses were two pieces of arithmetic.
- `LrSigil` draws every stroke at `opacity={o * 1.7}`. The port kept the `o`s and dropped the ×1.7.
- The port then laid a 0.9 over the whole sigil, and the Rite added a 0.7 on top of that.

`RiteSigil` now applies `strokeLift = 1.7` to every stroke, with nothing dimming the sigil from inside. Each surface sets its own layer opacity from Design's number, held in `DayLight`:

| Surface | Before | Now |
|---|---|---|
| Rite | 0.7 × 0.9 | 0.977 (`0.62 + 0.85 × 0.42`) |
| Presence / Recognition | 0.55 × 0.9 | 0.55 |
| Field chip | 0.5 / 0.9 × 0.9 | 1.0 (Design's `opacity={2.4}` clamps to full) |
| Field room | 0.4 × 0.9 | 0.5 |
| Threshold | gold at 0.045 | 0.7 |

Recognition's ≈1.9× loss lived inside `RiteSigil`, so it is fixed without touching `Views/Recognition/`.

**2. `LrSigil`'s geometry, path for path.** The port's geometry was simplified; it now matches the JSX:
- the Bhūpura's four gold T-gates are back;
- the lotus petals are `lrPetalPath`'s quadratic petals, not ellipses;
- the triangle rings alternate up and down, unrotated, as `lrTriRingPaths` lays them;
- polygons, not circles, as Design drew them.

**3. `lrBackdrop` layer for layer.** `Theme/LightField.swift` holds CSS's own vocabulary (`ellipse W% H% at X Y`, `circle at`, `linear-gradient(angle)`), so each ground is a line-for-line port. The port's single round `RadialGradient` per element is replaced by Design's layers:
- fire: a low wide updraft, plus a crown of her faint colour;
- water: a pool below the floor;
- air: a tall lamp off to one side of a 120° ground, on the composition's flip side;
- ether: two concentric lights;
- earth: a 140%-wide low band;
- light: a hot core of her colour inside a glow halo.

The same vocabulary lights the Field and Well crown, Her Presence's crown, the menu veil, the sheets and the Memory.

**4. The day's tint.** `lrApplyTime` mixes each hour's tint into the ground, and lifts the bright accent and glow caps:
- dawn #3a1c22 at 12%;
- noon #242838 at 7%;
- dusk #331306 at 14%;
- night #060716 at 16%;
- the new moon (an invention, as the modulation already was): deepest, at 18%;
- under an hour, the caps rise to 80/90 and the glow to 72.

`Atmosphere` gains `timeKey` (a non-model struct, so this is additive). It is nil for the timeless ring atmospheres.

**5. The Rite's nine beats.** Design's arrival, as `ArrivalBeat`:
- strip 0.10 s, kicker 0.25, name 0.40, phon 0.55, know 0.70, rule 0.80, quality 0.90, prompt 1.05, foot 1.25;
- each beat runs 1.3 s with CSS `ease`, rising 10 pt;
- the sigil comes up beneath over 2.4 s, starting at 0.2 s, and the veil name rises with it;
- a beat belongs to the block, not to its place in the stack. In fire's ascension the prompt sits above her name, but her name still arrives first.

**6. Air leans.** The air plan is now `align: .lean` with the lean name cap of 66:
- the stack sits 30 pt in from one edge, 94% wide;
- the sigil stands off the other edge at 40% of the height;
- the 43% horizon line is drawn (it was declared and never rendered).

`RiteSigilPlacement` positions the sigil as `TdSigil` does: the unscaled box is set against its edge, and the scale is applied about its centre. The port anchored the scaled box instead, which moved every sigil whose scale was not 1. Line weights scale with the sigil, as CSS `transform: scale` does.

**7. Her hue in "I feel her".** `linear-gradient(135deg, red, color-mix(red 66%, accent 34%))`. No two days' pills are the same red.

**8. The Living Rite threshold, "enter her ring".** The older Mandala App doorway (gold at 4.5%) is replaced by Design's `AvaranaThreshold`:
- the ring's own `lrBackdrop`, its geometry at 0.7, 12 motes and depth;
- "‹ the field" and the seat count across the top;
- the staged naming: form, name in its glow, subtitle in the ring's accent, hairline, Personal Connection, gratitude in gold, mental state · chakra;
- a pill of the ring's light at the foot.

"Enter her ring" returns to the Field with that ring open and scrolled into view. The edge swipe still goes back.

**9. The Field lit as Design's Field.**
- The crown is an ellipse 130% × 40%; the port drew a circle.
- Chips are at full light; they turn only while their ring is open.
- The open ring's geometry is 360 pt at 46%, at 0.5.
- The ring's deep ground falls to clear.

**10. The menu and the sheets lit by the day.**
- The menu veil is today's glow over her deep ground; the room you are in is written in her bright accent.
- The Nityā sheet and Settings wear the sheet light, and the Nityā's tithi line, hairline and framing sentence are in the day's accent.
- The hamburger lines are at Design's 0.75. They were 0.45.

**11. The Memory** wears Design's pool of the day's glow over its deep ground. The motes take the day's element and colour. The hour's ambient stays above.

## Beyond Design

- **Light stands in the air.**
  - The backdrop's lights and the sigil are composited additively (`.plusLighter`) over the ground.
  - Every sigil stroke carries a soft blurred halo of itself (a `drawLayer` with a blur, at 0.75), so the lines read as light, not ink.
- **Every place breathes as what it is.**
  - Each ring breathes at its own rate (`FieldBreath`: the Bhūpura holds; then 3 · 8 · 9 · 11 · 13 · 15 · 18 s, and 4 s at the Bindu). This drives the Field chips' pools, the open room's geometry (around 0.5), and the "I feel her" glow.
  - The backdrop's lights widen and narrow slowly, at her element's response tempo (`LR_RECOG.respDur` × 2).
- **One clock that reduce motion stills.** The sigil's turn moved from a `repeatForever` animation to a `TimelineView` clock, paused live by reduce motion (the same idiom as the motes). The drawing is `Equatable`, so the clock turns it without redrawing it.
- **Nothing he could read is lost.** The threshold keeps the older doorway's geometric shape, presiding form and yoginī as a quiet line at the foot of the reading. Design left them out.

## Calls made

- **Where the menu and sheets get the day.** They read `DayLight.atmosphere(_:)`, which honours `AppRuntime.pinnedEnergyPosition` first. The Well read the calendar directly; it now answers to the pin, like every other screen.
- **The threshold has a way back.** Design's Living Rite threshold has "‹ the field". The Reading's "no cancel" ruling concerns the Rite of Entering (Rooms), which is untouched.
- **The position line stays at 0.55, not Design's 0.44.** Legibility's 0.5 floor is a surviving principle of reading, not restraint.
- **DepthOverlay is unchanged.** `EllipticalGradient`'s 0.82 already reaches Design's 78% × 82%.
- **The arrival begins 60 ms after she is on the glass, on the rite itself.** It used to begin on the outer container, so a store that resolved late showed her already arrived.

## Tests

- **Added `DayLightTests`.** These are look checks in numbers:
  - the ×1.7 and its clamp;
  - each surface's gain over the first port (Rite ≥ 2.6×, Presence ≥ 1.88×, chips ≥ 3.7× closed and ≥ 2× open, room ≥ 2.3×, threshold ≥ 5.5× on opacity alone);
  - stroke counts and gold strokes per ring, the petal reach and the Bindu dot;
  - the nine beats and their timings;
  - beat-by-block;
  - air's lean;
  - `TdSigil` placement and the scale-about-centre rule;
  - per-element backdrop layer counts and positions;
  - CSS gradient geometry;
  - the hour's tint;
  - the pill's third of her hue;
  - the nine breath rates;
  - the threshold's name taper and fallback light;
  - the sigil's clock.
- **`LegibilityTests`.** Pinned the threshold's tapered enclosure-name size (`computedSize`). It is arithmetic like the Rite's two names, never under 37 pt, at full cream.
- No test enforced the lifted dimmers by value, so none needed rewriting. `RiteCompositionTests`, `HitAreaIdiomTests` (the celestial strip, "know her ›", the Field's threshold ledger), `DynamicTypeTests` (the veil name's pinned font call), `PinnedEnergyTests` (`todayPos`) and `DeviceSlipTests` all still hold as written.

## Note for the merge

- **Slice C:** `RiteSigil` now carries the ×1.7 and no 0.9. Recognition's `.opacity(0.55)` is already Design's number, so Recognition should not compensate a second time.
- **Composition lock:** the Rite now settles at 2.6 s (it was 1.2 s). The air plan's geometry has moved, and so have the threshold, the menu type size (32 pt) and the hamburger lines. This wave retires the lock as a gate; the baselines need re-recording after the merge.
