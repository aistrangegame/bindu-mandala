# Wave 1 · Slice C — Recognition

*The ceremony after "I feel her". Owns `iOS/Bindu Mandala/Views/Recognition/`.*

## What came home

**The six natures.** `RecognitionNature` (new, pure) maps her element one to one:
fire → flare, water → pool, air → disperse, ether → bloom, earth → settle,
light → radiate. Every number is Design's own: the `lrResp…` keyframes
(rest/peak drift, rise, scale, light) and the `LR_RECOG` rows (geometry focal
`fy`, ground focal, cycle, ripple manner/count/duration, motes).

- The port's single scale-breath is gone. Her ring's geometry and her bīja now
  move by the nature's pose: fire rises 16 pt, air drifts 20 pt sideways, ether
  opens once to 1.16 and holds, earth stirs 1.5%, light brightens to 0.72.
- **Tempo fix.** The port ran each autoreversing leg for the whole Design cycle,
  so every nature breathed at half speed. A leg is now half the cycle (the bloom's
  one leg is the whole opening). The bīja moves 1.3× slower than the geometry,
  as Design has it, and starts with the phrase rather than the name.
- **Ground focal fix.** The port lit the background at the geometry's focal. Design
  lights fire and earth from the floor (96%, 92%) and water at 62%; restored.
- Ripples travel in their manner: rings, rings that rise 120 pt (fire), rings that
  spread 52 × 20 (air).

**Light standing in the air (beyond Design, in its language).** `RecognitionLight`:
- `RecognitionBackdrop` — the ceremony gradient plus each nature's second light
  from `lrBackdrop`, layer for layer.
- `RecognitionNatureLight` — each nature's own standing light, additive
  (`.plusLighter`): fire a tongue of light from the floor through her point; water
  a lens of light pooling below with surface rings; air four streams drifting
  opposite ways; ether a disc and two rims that bloom once and hold; earth a
  horizon band and line; light sixteen rays, long and short. An emissive core sits
  at her point in every nature. The sigil's strokes carry a glow (shadow in her
  soft accent).
- The light stands at 0.7 until Act 2 and lifts to full as she feels him back.

**Staged arrival, as Design times it** (`living-rite-detail.jsx`, which supersedes
the older spec): name 0.3 s, phrase 1.1, Act 1 2.6, Act 2 4.3, note and the way out
5.4, each over 1.4 s with Design's small rise (8 / 4 pt). The close hint now
arrives with the note, as in Design.

**Act 2 is felt.** At "and she felt you back": the nature's one-time answer in light
(`RecognitionAnswer` — the flare leaps, a ring spreads over the pool, a breath
crosses the glass, the bloom's rim opens, light comes to rest on the ground, the
rays reach), a haptic in her manner (`RecognitionNature.pulse`: rigid spark, soft
drop, light breath, soft opening, heavy weight, medium strike), and her bīja through
`BijaSoundService.playBija` — her existing pitch, sounded exactly as every other bīja
tap in the app is (the app's `.playback` session; nothing new about the silent switch).

**The after-glow.** On close: practice data first (`commitClose` — the note onto his
local moment, then `AirtableService.recordRecognition` with `source`), then the
collapse into her point (0.62 s, `lrCollapse`), then 1.8 s of residue: an ember at the
point, one gold halo leaving it (the Portrait's settle), the glass slightly lifted —
all decaying on Design's after-effect curve (`k²`, `riteAfterStyle`). Then
`isPresented = false` and `didSettle` with `src.rawValue`. Never named, never a number.

**Reduce motion.** Each nature is its still light (held halfway; the bloom open). No
ripples, no answer motion, no rises. The words still arrive, by fading. The after-glow
is a still ember that fades over 1.0 s. Haptic and tone are unchanged.

## Decisions

1. **The sigil's light follows Design literally** (0.55 × the nature's opacity
   envelope). That is dimmer in alpha than the port's flat 0.55; the brightness the
   Reading measured as lost was the strokes (Slice B's ×1.7 in `RiteSigil`), and the
   nature light, core and stroke glow added here more than return it.
2. **The bīja blooms once too.** Design loops `lrRespBloom` on the bīja (a jump back
   every cycle). "Ether blooms once and holds" is the nature's own sentence, so the
   bīja holds with the geometry.
3. **The haptic is per nature**, not a single medium tap — the moment should be felt in
   her manner. Implemented locally (`RecognitionHaptic`) so `Theme/Haptics.swift`
   (Slice B's folder) is untouched.
4. **Sound is her bīja, not an element tone.** No element-tone service exists; the bīja
   drone is hers by position and keeps its pitch (rupakarshini law 10).
5. **The close now takes 2.4 s before the hand-off** (0.62 collapse + 1.8 residue;
   1.0 s under reduce motion). The record is never at stake: the recognition is written
   in `stage()` before any light moves, and his note and the ledger write are committed
   at the first touch of the close.
6. Act 2 moved from 4.1 s to Design's 4.3 s; the note from 5.1 to 5.4.

## Tests

- **New `RecognitionNatureTests`:** element → nature (one to one, all six reachable);
  no two natures move alike (the flattening cannot return); each moves its own way;
  Design's keyframes and `LR_RECOG` rows pinned; ripple ends; the tempo is the cycle,
  not twice it; poses clamp and never go dark; every nature is felt; the timeline's
  order and held beats; the after-glow's `k²` curve and brevity; and the surviving
  principles in source — the recognition is written before any animation, the note
  and ledger write before the ceremony gathers, `source` and `src.rawValue` intact,
  no Recognition file can reach a practice count, no image in the ceremony.
- **Kept, passing unchanged:** `LawsTests.testTheCeremonyStillSpeaksBothLines`,
  `testBothRecognitionLinesAreVerbatimAtEverySite`, the pinned `uppercased` treatment,
  the ghost-hint floor (`Tap anywhere to close` 11 pt / 0.50), the bīja's decorative
  and fixed-size pins, the reduce-motion gate over every `repeatForever`.
- No existing test enforced the single scale-breath directly, so none was rewritten.
  `FeltRegisterClassifications` still names the old 4.1 / 5.1 staging in a reason
  string; the composition lock is retired this wave and that file was left alone.
