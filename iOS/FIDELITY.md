# Bindu Mandala — Fidelity & Process

The design-fidelity remediation (Tiers 0–3) restored the atmospheric/ceremonial layer
that the first rebuild thinned. This doc exists so it does not silently drift again.

Source of truth for design (look and motion only): `Claude Design Round 2/prototype/living-rite-*.jsx`
+ `index.html` (keyframes) + `shakti-data.js` (Ring-2 look reference). Palette and type
(`#0D0508` / `#C9963F` / `#F2E8D9` / `#8B1A2A`, Cormorant-Light) already match.
Source of truth for names and content: **Airtable**, for all 102 (Build Brief v2, Law 1). The
prototype is never a data source; `all-shaktis-data.js` is a superseded draft roster, archived at
`prototype/_superseded/` — never read it as data.

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
6. **Graceful degradation (the 86)** — content is complete for all 102: quality, somatic
   poetry, tattva, function, etymology, iconography, appreciation phrase, codex portrait
   (verified live in Airtable, Sept 2026; Brief v2 R14). Only three fields are Ring-2-only
   *by design*: the 86 non-Ring-2 Śaktis lack phonetic (all), bīja (most), and a real
   cluster (all default `.inner`). Guard exactly those three — omit the row; never print an
   empty label or the false "INNER INSTRUMENT" — and never assume blank content for the
   rest. A blank content field on device is sync staleness, not a data gap.
7. **Verify on device** — screenshot on **iPhone 17 Pro Max** *and* a small sim
   (SE 3rd gen), driving the actual flow, compared to the prototype. Tests alone do not
   catch atmosphere/motion/timbre regressions.
8. **Adversarial verify for zoom/animation-gated work** — where a change can't be
   screenshotted (deep-zoom labels, settle choreography), run a small multi-agent
   fidelity+regression panel over the diff against the prototype before merging.

## Fidelity tiers (record)

The remediation shipped in four tiers, each a merged PR on `main` (verified against `git log`):

- **Tier 0 — correctness:** PR #12 (`6cf9dab`) — responsive Rite, reachable Mandala controls,
  keyed bīja, restored Nityā prose.
- **Tier 1 — the soul:** PRs #13–#16 (`e1a600f`, `464f6fa`, `75be342`, `8462462`) —
  atmosphere-lit Detail + depth/mote primitives; the Recognition ceremony's element-response
  layer; the Field's felt dimension + atmosphere-lit Well; shell transitions, same-day restore,
  contextual back-label.
- **Tier 2 — polish:** PRs #17–#20 (`27fe448`, `3890e2f`, `acb14d6`, `da92f92`) — Today's
  atmosphere + celestial strip; Mandala tier labels/gestures + Portrait settle; Avaraṇa data
  model + threshold; Detail finish (dividers, bodily seat, bīja rings).
- **Tier 3 — process:** PR #21 (`06d7697`) — legibility + tap-target sweep, this checklist,
  the stretch dispositions below. (This file was created in that PR.)

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
- `Data/ActivityLedger` — the App Activity vocabulary, payload, formulas and restore
  mappers (pure). Ruling 2026-09-07: every practice event → App Activity; the Mandala
  table receives only the Shakti-row PATCHes. Notes is the practitioner's text, never
  metadata; `Felt At` is the second-precision key every dedup matches on.
- `Data/AirtableService` — sync + the one ledger writer (fail-open create-time dedup) +
  the Shakti-row PATCHes + `restore*IfLocalEmpty` + Her Moments, all reading the ledger +
  pending queues (hold without a token, never drop for want of one).
- `Services/SilenceDwell` — the R11 entry point: local `.silence` entry first, then the
  ledger's `Silence Held`. No call sites until Phase 3.6.
- `Data/PersistenceRecovery` — no-launch-crash guarantees.

## Design §4 stretches — disposition

Stated explicitly so they read as **decisions, not defects**:

- **Ring-drone** (a sustained tone under the Mandala) — **superseded by the Homes' per-Śakti
  carrier** (Build Brief v2 Phase 2.3 / Phase 6: "the ring drone (superseded by the Homes'
  carrier)"). Not built as a drone and not to be; the carrier is its successor.
- **WidgetKit home-screen widget** — **not built; stays parked.** Optional; no widget target exists.
- **`.silence` recognition gesture** — **reborn as the dwelling** (Brief v2 R11), **wired in
  Phase 3.6**: a dwell held past the first adaptation records a `RecognitionEntry` with
  `gesture: .silence` (local + App Activity Silence Held, Gesture Source Silence), once per
  visit, never displayed. The writer exists (`Services/SilenceDwell.record` →
  `AirtableService.recordSilence`; no Shakti-row PATCH) with zero call sites until 3.6
  lands — the `.silence` case is defined, tested, and unwritten by any screen.
