# Bindu Mandala — Fidelity & Process

The design-fidelity remediation (Tiers 0–3) restored the atmospheric/ceremonial layer
that the first rebuild thinned. This doc exists so it does not silently drift again.

Source of truth for design: `Claude Design Round 2/prototype/living-rite-*.jsx` +
`index.html` (keyframes) + `all-shaktis-data.js` / `shakti-data.js`. Palette and type
(`#0D0508` / `#C9963F` / `#F2E8D9` / `#8B1A2A`, Cormorant-Light) already match.

## Screen-by-screen fidelity checklist

Run this for **any** screen before calling it done — the first rebuild passed tests
but skipped the per-screen side-by-side, which is how the atmosphere got dropped.

1. **Atmosphere layers present** — the screen reads the day's / her `Atmosphere`
   (`AtmosphereBackground` or an equivalent gradient), and — where the prototype has
   them — a crowning `RiteSigil`, element-varied `DustMotesView`, and `DepthOverlay`.
   Not flat `Color.ground`.
2. **Composition matches the prototype** — hero/centre-stack scale, alignment (air
   lean), and staged arrivals; element-expressive focal/motion where the prototype
   varies by element.
3. **Motion + reduce-motion** — every repeating animation and `TimelineView(.animation)`
   is gated by `@Environment(\.accessibilityReduceMotion)` (paused clock or `guard`).
   The one-shot fades may stay; the loops may not.
4. **Legibility** — meaningful text ≥ ~11pt and ≥ ~0.5 cream alpha (decorative
   watermarks/ghost glyphs are exempt). Interactive controls ≥ 44×44pt (add
   `.frame(minHeight:44).contentShape(Rectangle())` or vertical padding to inline links).
5. **Tokens, not literals** — grounds/accents/text come from `Color+Tokens`, `TimeVariant`,
   or the `Atmosphere`. No bespoke `Color(red:…)` for meaningful UI.
6. **Graceful degradation (the 86)** — guard empties: the 86 non-Ring-2 Śaktis lack
   phonetic (all), bīja (most), and a real cluster (all default `.inner`). Omit rows;
   never print an empty label or the false "INNER INSTRUMENT".
7. **Verify on device** — screenshot on **iPhone 17 Pro Max** *and* a small sim
   (SE 3rd gen), driving the actual flow, compared to the prototype. Tests alone do not
   catch atmosphere/motion/timbre regressions.
8. **Adversarial verify for zoom/animation-gated work** — where a change can't be
   screenshotted (deep-zoom labels, settle choreography), run a small multi-agent
   fidelity+regression panel over the diff against the prototype before merging.

## Services / Data spine — audit owner

These have **no on-screen surface**, so they get skipped by a visual pass. Any change
touching them must be reviewed against the prototype/rulings by whoever owns the change
(the "spine owner" for that PR), not left to the screen review:

- `Services/DailyEnergyService` — the single "today" source (all-102 shuffled 6am pick).
- `Services/DailySummons` — the 6am named greeting.
- `Services/LunarPhaseService` — epoch/synodic constants vs `lrMoon`; note `currentTithi`
  is the *astronomical* tithi, NOT the mirrored Nityā position (see its doc comment).
- `Data/RecognitionMigrator` — lossless backfill.
- `Models/DescentState` — mirror-once (`enter → true` only on a new deepest crossing,
  Ruling 8) + restore-if-empty (never regress below floor 2).
- `Data/AirtableService` — sync + `restore*IfLocalEmpty` + pending queues.
- `Data/PersistenceRecovery` — no-launch-crash guarantees.

## Design §4 stretches — disposition

Stated explicitly so they read as **decisions, not defects**:

- **Ring-drone** (a sustained tone under the Mandala) — **not built.** Optional ambience.
- **WidgetKit home-screen widget** — **not built.** Optional; no widget target exists.
- **`.silence` recognition gesture** — the `RecognitionEntry.Gesture.silence` case is
  **defined but never written** (both record sites use `.felt`; the Bindu/Silence dwell
  was never wired to record it). A dormant hook, harmless — leave it until/unless a
  silence-dwell recognition is designed, then wire `store.record(gesture: .silence)`.
