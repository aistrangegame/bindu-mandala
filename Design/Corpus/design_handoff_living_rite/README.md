# Handoff: Bindu Mandala — The Living Rite

## Overview

Bindu Mandala is a single-practitioner devotional iOS app (SwiftUI + SwiftData) built around
Śrī Vidyā's 102 Śaktis of the Śrī Cakra. This handoff covers a redesign that turns the app from
*a thing you open* into *a practice you are inside of*: a daily encounter with one Śakti whose
entire screen is generated from her nature, a living Śrī Yantra you descend into, and a Portrait
that lights one point each time a Śakti is felt.

**Governing idea:** *Time is the medium.*
**Governing rule:** *Readiness is sensed; crossing is always chosen.* The app may notice when a
Śakti has ripened or a ring is ready — but the practitioner always makes the deliberate gesture.
**Never auto-advance.**

---

## About the design files (READ THIS FIRST)

The `prototype/` folder is a **working, runnable design reference built in HTML/React**. It is
**not production code to copy** — it is the source of truth for *look, motion, and behavior*. Your
job is to **recreate these designs in the real repo's environment** (`aistrangegame/bindu-mandala`,
iOS / SwiftUI + SwiftData), using its existing tokens, fonts, and patterns.

Two documents work together:

- **`README.md`** (this file) — how to run the prototype, what every file is, the design tokens,
  and a screen-by-screen index.
- **`DESIGN_SPEC.md`** — the full build brief: operating principles, repo orientation, the five
  implementation phases, and a section mapping **each prototype engine/screen → its SwiftUI target
  with exact file/line anchors in `prototype/`**. Work top-to-bottom from that document; use this
  README as the map.

**Fidelity: high.** Final colors, typography, spacing, motion, and interactions are all present and
intentional. Recreate them faithfully in SwiftUI — match the values, not the HTML.

---

## How to run the prototype

The prototype uses in-browser Babel and loads its modules by relative path, so it must be served
over HTTP (not opened as a `file://` URL).

```bash
cd prototype
python3 -m http.server 8000
# open http://localhost:8000/index.html
```

It renders inside an on-screen iPhone frame. State (nav position, recognition log, notes,
sound toggle, embodiment crossings) persists to `localStorage` — refresh keeps your place. To reset,
clear the `lr_*` keys in devtools. Toggle **Tweaks** (toolbar) to see the built-in variation knobs.

---

## File map (`prototype/`)

Load order matters; it mirrors `index.html`. Each `living-rite-*` file is one screen or the shared
engine. **Read `living-rite-core.jsx` first** — it holds every derivation the screens depend on.

| File | What it is |
|---|---|
| `index.html` | Entry point: fonts, all `@keyframes`, script load order, `#root`. |
| `shakti-data.js` | The 16 fully-authored Ring-2 Śaktis (`SHAKTIS`, `CLUSTER_INFO`). |
| `all-shaktis-data.js` | The full 102 + ring/āvaraṇa metadata (`AVARANAS`). |
| `ios-frame.jsx` | The device bezel/status bar. Prototype chrome only — **do not port.** |
| `tweaks-panel.jsx` | The Tweaks panel. Prototype chrome only — **do not port.** |
| `living-rite-core.jsx` | **The engine.** Atmosphere, time-of-day, element→archetype, moon, day-cycle, embodiment, recognition responses, bīja + ring chimes, and shared SVG atoms. Everything below reads from here. |
| `living-rite-today.jsx` | The Daily Rite — today's Śakti, composed by her element into one of six archetypes. |
| `living-rite-detail.jsx` | Her Presence (detail) + the Recognition ceremony (element-driven "felt back"). |
| `living-rite-mandala.jsx` | The living Śrī Yantra: semantic zoom, constellation threading, Bindu→Lalitā descent, ring-entry chimes. |
| `living-rite-field.jsx` | The Field (all 102), The Well (recognition archive), The Memory (Portrait Mandala), and the menu. |
| `living-rite-more.jsx` | Threshold ceremony + per-Śakti Letter screens. |
| `living-rite-app.jsx` | Root: nav state (`lr_nav`), screen router, hamburger menu wiring. |

---

## The engine — where the "she is unique" behavior lives

Every Śakti gets a different screen because everything is *derived*, never hard-coded. All of this is
in `living-rite-core.jsx`:

- **`lrAtmosphere(s)`** → her palette. Hue comes from her cluster (Ring 2) or ring, jittered per
  Khaḍgamālā position (`lrJitter`) so sisters differ. Returns ground/glow/accent tokens the whole UI
  reads. **Port as a `struct Atmosphere` computed from a Śakti.**
- **`lrElement(s)`** → her element (fire/water/air/earth/ether/light), from her tattva (Ring 2) or
  ring temperament (`LR_RING_ELEMENTS`).
- **`LR_ARCHETYPE_BY_ELEMENT`** → element selects one of **six Today compositions**: fire→*ascension*,
  water→*descent*, air→*horizon*, ether→*veil*, earth→*foundation*, light→*radiance*. `lrComposition(s)`
  adds per-Śakti flip/spin/scale/tier jitter so no two are identical even within an archetype.
- **`lrTimeVariant` / `lrApplyTime`** → re-lights the same Śakti by hour (dawn/noon/dusk/night):
  shifts hue, luminance, saturation, glow, mote count, and ground tint. Noon clarifies; night deepens.
- **`LR_STATUS` / `LR_STATUS_THRESH` / `lrReachedIndex`** → embodiment: mapped→exploring→active→
  embodied. Readiness is *sensed* from felt-count; crossing is a deliberate **press-and-hold**
  (`lrCrossLevel` / `lrSetCrossLevel`).
- **`LR_RECOG`** → the Recognition ceremony's motion per element (focal point, ripple manner, "felt
  back" response animation).
- **`lrPlayBija` / `lrRingChime` (`LR_RING_FREQ`)** → Web Audio. Each Śakti's bīja has its own tone;
  each of the 8 enclosures rings a bell that *descends* in pitch as you fall inward. **Port to
  AVAudioEngine / a tone generator; gate behind the sound toggle.**
- **`lrTodaysShakti` / `lrPracticeDayIndex`** → deterministic shuffled walk through the 102, one per
  practice day (day boundary at ~6am local).

---

## Screens (index — full detail in `DESIGN_SPEC.md`)

- **Today — The Living Rite** (`living-rite-today.jsx`, label `Today — The Living Rite`)
  Today's Śakti composed by her element into one of six archetypes. Moon/tithi strip taps to who
  presides; her name opens Her Presence; *"I feel her"* opens the Recognition ceremony.
- **Her Presence** (`living-rite-detail.jsx`, label `Her Presence — {name}`)
  Element-driven hero + spinning sigil, the somatic line, bīja (tap to sound), the four-node
  embodiment track (press-and-hold to cross), and *"go deeper"* disclosure for reference matter.
- **Recognition Moment** (`living-rite-detail.jsx`, label `Recognition Moment`)
  Full-takeover ceremony; the "felt back" motion is her element (flare / pool / disperse / bloom /
  settle / radiate). A *"What did you notice?"* note is optional. Settles inward into the Portrait.
- **The Mandala — Śrī Yantra** (`living-rite-mandala.jsx`)
  One continuous space with semantic zoom (cosmic → enclosure → seat). Tap a Śakti to thread her
  constellation (her family draws out from her seat). Fall all the way in — or tap the bindu — to
  descend to Lalitā at the centre. Ring-entry chimes + a ring flash on each inward crossing;
  persisted sound toggle.
- **The Field — 102** (`living-rite-field.jsx`) — the whole Khaḍgamālā as a browsable field.
- **The Well** (`living-rite-field.jsx`, label `The Well`) — the private recognition/letters archive.
- **The Memory — Portrait Mandala** (`living-rite-field.jsx`) — the years-long artwork; each felt
  moment lights one of the 102 points. Shows, never counts.
- **Threshold / Letter** (`living-rite-more.jsx`) — crossing ceremony + per-Śakti letters.

---

## Design tokens (from `living-rite-core.jsx` → `LR_BASE`, and `index.html`)

- **Ground** `#0D0508` · page backdrop `#161013`
- **Gold** `#C9963F` (accent / links) · hover→ **Cream** `#F2E8D9`
- **Cluster hues** (Ring 2): inner `h43 s78 l52`, tanmatra `h13 s47 l56`, + three more in
  `LR_CLUSTER_HUES`. **Ring hues** in `LR_RING_HUES`. Never introduce a color outside these.
- **Type:** Cormorant Garamond (300/400/500 + italic 300/400). Serif stack
  `'Cormorant Garamond', Georgia, serif`.
- **Safe top:** `LR_SAFE_TOP = 54` (clearance under status bar / Dynamic Island → SwiftUI safe area).
- **Legibility floor:** any text meant to be *read* ≥ 11pt and ≥ 0.3 alpha; below that is texture,
  by deliberate decision only. Every tap target ≥ 44pt.
- **Motion:** all `@keyframes` live at the top of `index.html` (rise/drift/fall, ripples, recognition
  responses, sigil spin, screen transitions, yantra threads/descent). Everything honors
  `prefers-reduced-motion` → SwiftUI `accessibilityReduceMotion`.

---

## Assets

None external. All imagery is drawn at runtime as SVG (sigils, yantra, moon glyph) or CSS. Fonts load
from Google Fonts (Cormorant Garamond) — the real repo already bundles this via `AppFont.cormorant`.

---

## How to approach the recreation

1. Run the prototype (above) and walk every screen so you feel the motion and atmosphere.
2. Read `living-rite-core.jsx` end-to-end — it is the whole derivation layer.
3. Open `DESIGN_SPEC.md` and work its phases top-to-bottom. Each phase names its prototype reference
   and its SwiftUI target. Build the shared `Atmosphere` + `TimeVariant` foundation first, then the
   Daily Rite, then Detail/Recognition, then the Mandala/Descent, then the Portrait.
4. When a code sketch and the principles conflict, the principles win. When you must invent, invent
   *toward* the governing idea. Keep to the existing color tokens and the "she is felt, not measured"
   rule (no streaks, scores, badges, or numbers on the Portrait).
