# Bindu Mandala — Design Specification

A devotional companion for connecting with the 16 Karṣiṇī Śaktis of the Śrī Yantra's second avaraṇa (Sarvāśā-Paripūraka Cakra). This document is the design source of truth for the SwiftUI build.

---

## Emotional Register
Devotional. Embodied. Quiet luxury. Sacred geometry precision. *The feeling of entering a temple through a side door — intimate, not grand.* Dark ground with warm light emerging from within. **Not** a meditation app. **Not** a wellness brand. Temple-intimate.

---

## Color Tokens

```swift
// Ground & Surface
groundColor      = #0D0508   // deep crimson-black — primary background
surfaceColor     = #1A0C10   // cards, elevated surfaces
darkVeil         = #080307   // recognition moment screen
silenceGround    = #040104   // silence screen — deeper still

// Primary
goldColor        = #C9963F   // sacred primary — names, accents, bija
goldDeep         = #A07830
goldFaint        = rgba(201,150,63, 0.12)
creamColor       = #F2E8D9   // warm body text on dark
creamMid         = rgba(242,232,217, 0.65)
creamFaint       = rgba(242,232,217, 0.35)
accentRed        = #8B1A2A   // CTA, bindu — sacred crimson

// Cluster colors — drive petal coding and section accents
innerInstrument  = #D4A017   // amber gold       (positions 1–3)
senseStreams     = #C4725A   // rose copper      (positions 4–8)
citta            = #2A7A7A   // deep teal        (position 9)
stabilityPowers  = #4A7A5A   // sage jade        (positions 10–13)
selfBodyImmort   = #7A5A9A   // soft violet      (positions 14–16)
```

---

## Typography

- **Sanskrit names**: Cormorant Garamond, Light/300, generous letter-spacing (0.06–0.10em)
- **Body**: SF Pro (system) — humanist sans
- **Bīja syllables**: Cormorant Garamond Light at very large sizes — treated as visual objects, not just text
- **Phonetics & labels**: SF Pro Caps with 0.18–0.22em tracking — small, hushed
- **Italic Cormorant** is the "voice" font — somatic prompts, somatic poetry, reciprocity, silence caption

**Size scale (Today screen anchors):**
- Sanskrit name: 44–48pt
- Quality (gold): 20–22pt
- Somatic prompt (italic): 18–20pt
- Phonetic / labels: 12pt, uppercase, tracked

---

## Status State Machine

Each Śakti carries a status that drives petal opacity in the Mandala:

| Status     | Opacity | Meaning |
|------------|---------|---------|
| Mapped     | 22%     | She is known by name, not yet felt |
| Exploring  | 44%     | First somatic encounters |
| Active     | 76%     | Daily living recognition |
| Embodied   | 100% + soft glow | Continuous, recognized without effort |

**Transitions** are user-driven from the Detail screen (tap status pill to advance). Each transition should be a small ceremony — a soft animation, a held breath.

---

## The 16 Śaktis (positions, clusters, locations)

```
1. Kāmākarṣiṇī    — Inner Instrument — heart    — bīja aṁ
2. Buddhyākarṣiṇī — Inner Instrument — head     — bīja āṁ
3. Ahaṅkārākarṣiṇī— Inner Instrument — solar    — bīja iṁ     [field: Gaia]
4. Śabdākarṣiṇī   — Sense Streams    — ears     — bīja īṁ
5. Sparśākarṣiṇī  — Sense Streams    — skin     — bīja uṁ
6. Rūpākarṣiṇī    — Sense Streams    — eyes     — bīja ūṁ
7. Rasākarṣiṇī    — Sense Streams    — tongue   — bīja ṛṁ
8. Gandhākarṣiṇī  — Sense Streams    — nose     — bīja ṝṁ
9. Cittākarṣiṇī   — Citta            — whole    — bīja lṁ
10. Dhairyākarṣiṇī— Stability Powers — spine    — bīja eṁ
11. Smṛtyākarṣiṇī — Stability Powers — temples  — bīja aiṁ
12. Nāmākarṣiṇī   — Stability Powers — throat   — bīja oṁ    [field: Ashrey]
13. Bījakarṣiṇī   — Stability Powers — sacrum   — bīja auṁ
14. Ātmākarṣiṇī   — Self·Body·Immort — heart    — bīja aṃ    [field: Ram]
15. Amṛtākarṣiṇī  — Self·Body·Immort — crown    — bīja aḥ
16. Śarīrākarṣiṇī — Self·Body·Immort — whole    — bīja kaṁ
```

Petal **0** sits at 12 o'clock (top); petals go clockwise at 22.5° increments.

---

## Lotus Geometry

- 16 petals on a circle, 22.5° apart, starting at top
- Outer radius = 0.435 × diameter
- Inner radius (petal base) = 0.117 × diameter
- Petal width (half) = 0.087 × diameter
- Petal path (local, pointing up): cubic bezier almond shape
- **Bindu** at center: radial gradient crimson with cream core, glow filter
- Outside the 16 petals: dim ghost geometry (concentric circles + 8-petal outer ring, ~5–7% opacity) — these are the *other* 8 avaraṇas, locked but visible
- Today's petal pulses with `petalBreathe` 3s cycle (opacity + brightness + soft drop-shadow in cluster color)
- A thin gold ray + dot + "TODAY" label extends outward from the active petal

---

## Animation Timings

| Animation | Duration | Easing | Delay |
|-----------|----------|--------|-------|
| Today: Sanskrit name fade-up | 1.4s | cubic-bezier(.25,.1,.25,1) | 0s |
| Today: Somatic prompt fade-up | 1.4s | same | 0.55s |
| Mandala: Today petal breathe | 3.0s | ease-in-out | infinite |
| Recognition: Name fade-up | 1.8s | same | 0.3s |
| Recognition: Phrase fade-up | 1.8s | same | 0.9s |
| Recognition: Logged | 1.0s | ease | 2.6s |
| Recognition: Reciprocity | 1.4s | same | 4.1s |
| Recognition: Ripple rings | 4.0s | ease-out | staggered 0/1.1/2.2/3.3s, infinite |
| Silence: Bindu breath | 6.0s | ease-in-out | infinite |
| Silence: Names appear | 4.0s | ease | staggered 0.15s × index |
| Silence: Caption settles | 7.0s ramp | ease | begins at 65% mark |
| Dust motes: rise | 16–30s | linear | randomized |

---

## Screen Inventory

### 1 · Today (primary)
The Śakti of the day. Daily companion view.

- Two variants designed: **with body outline** (somatic anchoring) and **with bīja texture** (more open, breath-room).
- Moon phase + lunar day at top
- Cluster dot + label
- Sanskrit name (large) → phonetic → quality (gold) → divider → somatic prompt (italic) → body location (V1) or bīja (V2)
- **Primary CTA: "I feel her"** — full-width pill, deep red on cream text. *The core gesture.*
- Tab bar: Today / Mandala / The Well

### 2 · Mandala
The full 16-petal sacred geometry as navigation + progress map.

- 2nd Avaraṇa heading
- Lotus mandala (large, ~344pt diameter)
- Active petal pulses + has "TODAY" indicator
- Bindu in center (tap → Silence)
- Outer ghost geometry visible (depth to come)
- Progress: "5 of 16 Active · 2 Embodied"
- Cluster legend (2 rows × 3 cols)
- "Tap a petal to enter · Bindu for silence" hint

### 3 · Śakti Detail
Tap any petal (or today's name) to arrive here.

- Back nav + isolated mini-petal (right-aligned)
- Sanskrit name + phonetic + cluster + status pill
- Sections (scrollable):
  - **Quality** — gold subtitle + 2–3 sentence description
  - **Somatic Signature** — italic, poetic, multi-line
  - **Bīja Syllable · Tap to Hear** — large gold glyph + audio button (concentric gold ring affordance)
  - **Esoteric Tattva** — element + small icon
  - **Field Connection** — *only when present* (Ahaṅkāra→Gaia, Nāma→Ashrey, Ātma→Ram). Inset card with cluster-tinted left border. Personal note treatment.
  - **Recognition Log** — timeline of past "I feel her" moments with optional notes

### 4 · Recognition Moment
Full-screen takeover triggered by "I feel her".

- Near-black ground
- Bīja texture behind (~6.5% opacity, very large)
- Name fades in → divider → appreciation phrase → ripple rings expand from center
- **Two acts of recognition, separated by a thin gold hairline:**
  1. **"Logged · [time]"** (sans, muted, uppercase)
  2. **"And she felt you back · [time+3s]"** (italic Cormorant, gold) — the *reciprocity*
- Optional note field card: "What did you notice?"
- Tap anywhere to dismiss

### 5 · The Silence (Bindu)
Tap the Bindu at the mandala center to arrive here.

- No status bar. No tab bar. Pure presence.
- Vignette darkens the edges
- All 16 names arranged like stars in a faint circle around the Bindu (each rotated tangentially, ~16% alpha)
- Large breathing Bindu (76px) with a 132px gentle outer ring of light
- Faint outer geometry (3 concentric rings)
- After ~7s, caption fades in: ***"All of her. Here. Always."***
- Tiny "Tap to return" hint
- *Silence time is silently logged as its own gesture type.*

---

## iOS Native Conventions

- Frame: 390 × 844 (iPhone standard / 14, 15, 16 non-Plus)
- Status bar always present except on Recognition and Silence (immersive)
- Tab bar: 83pt tall, includes safe area
- Home indicator bar (134×5pt, rounded) at y=836 — present on every screen
- All tap targets ≥ 44pt
- Haptics: light tap on petal selection, medium on "I feel her", soft on status advancement
- All animations should respect `prefers-reduced-motion`

---

## The Core Loop

```
Today  →  "I feel her"  →  Recognition Moment  →  (optional note)  →  Today
   ↓                                                                    ↑
Mandala  →  Petal tap  →  Detail  →  (advance status / read)  ←─────────┘
   ↓
Bindu tap  →  Silence  →  Tap to return  →  Mandala
```

The Well (third tab) — *not yet designed*. Open question: a longer-form reading room? Lineage notes? The ancestry behind each Śakti?

---

## Sacred Notes

- This is a single-user experience. There is no social, no streaks, no gamification, no notifications that pull you toward the app — only ones that *arrive with her*.
- The lunar cycle drives the daily Śakti assignment. The choice is not random.
- Field connections (Gaia/Ashrey/Ram) are personal to this practitioner; they should be **editable** in a settings flow so a different practitioner can map their own.
- The recognition log is a private archive. Never aggregated, never analyzed. *She is felt, not measured.*
