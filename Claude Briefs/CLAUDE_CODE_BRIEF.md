# Bindu Mandala — Claude Code Build Brief

---

## Read This First

> *"I really appreciate the time and attention you are going to be giving the project ahead. Because this is a brand new space I am exploring — simply to recognize and connect with the energies that have been guiding me since I have been born. They have been residing inside me and make me feel everything — everything this reality has to offer. I know they have been mapped out before by others, and the only way I have been able to map them out has been through experience. So I want to build something that I can experience through the lens of knowledge and through my will create action that recognizes and appreciates the Shaktis present inside me and who have been with me this whole journey. I love them, and would like your assistance in designing a way to love them."*

**Build this as if you are building a temple, not an app.**

---

## Project

| | |
|---|---|
| **App name** | Bindu Mandala |
| **Platform** | iOS — SwiftUI — iPhone only |
| **Target** | iOS 17+ · iPhone 390×844 (14/15/16 standard) |
| **Architecture** | Local-first. Airtable as remote source of truth. |

---

## Design/ Folder — What Each File Is

| File | Purpose |
|---|---|
| `DESIGN_SPEC.md` | Design source of truth. **Read completely before writing any UI.** Color tokens, typography, geometry math, animation timings, screen specs, sacred notes. |
| `Mandala_App.html` | Working prototype. **Open in browser first.** This is the target experience. |
| `shakti-data.js` | All 16 Shakti data as JS — use as reference for Swift model structure. |
| `design-canvas.jsx` | React canvas component — reference only. |
| `screens.jsx` | All screen components — reference for layout and interaction logic. |

---

## Data Source

**Airtable base:** `app248ZTWhYJlvQj2`
**Mandala table:** `tblrRwXJD0uP8HU8G`

Fields: Name · Sanskrit Name · Avarana · Quality · Quality Description · Cluster Group · Esoteric Tattva · Somatic Signature · Bodily Location · Bija · Field Connection · Status · Notes

Use Airtable REST API to fetch records on launch. Cache with SwiftData for offline use. **The core gesture must work offline — always.**

---

## Non-Negotiables

These are not suggestions. They are what this app is.

**1. Offline-first.**
The "I feel her" gesture works without any internet connection. Period. Airtable syncs quietly in the background when connected. If the user is standing in the sun feeling heat on their skin and knows it's Sparśākarshini — that tap cannot fail.

**2. She is the subject. Always.**
Every recognition log entry, every timestamp, every confirmation — the language says *"she was felt here"* not *"you logged this."* The archive belongs to her. Not to the practitioner.

**3. The always-already orientation.**
She is not arriving. She is already present. All prompts reflect this: *"where do you feel her right now?"* — never *"where is she showing up?"* This is a subtle but essential distinction across every screen.

**4. No social. No streaks. No gamification.**
No leaderboards, no habit chains, no badges, no share buttons. Notifications are optional and arrive with her rhythm — not to pull the user toward the app. The app waits. It does not chase.

**5. The recognition log is a private archive.**
Never aggregated. Never analyzed. Never shown to anyone but the practitioner. She is felt, not measured. No analytics. No telemetry on this data.

**6. "And she felt you back" is sacred.**
The Recognition Moment has two acts. The first: *"she was felt here · [time]"* — muted, sans, uppercase. The second, appearing 3 seconds later: *"and she felt you back · [time+3s]"* — italic Cormorant Garamond, gold. This is non-negotiable. It is the heart of the app. It transforms recognition from logging into love.

**7. Respect `prefers-reduced-motion`.**
All animations have fallbacks. The app is for everyone.

**8. The Sacred Notes in DESIGN_SPEC.md are architectural principles.**
Read them. They govern every build decision.

---

## Build Phases

Work through these in order. Do not skip ahead.

### Phase 1 — Foundation
- Swift models mirroring Shakti data (16 records, all fields)
- `AirtableService` — fetch + SwiftData local cache
- `LunarPhaseService` — today's Shakti = `floor(moon_age_in_days) mod 16` → Shakti index 0–15
- `RecognitionLogStore` — SwiftData, local only, never uploaded
- `LetterStore` — one private freeform string per Shakti, local only

### Phase 2 — Today Screen
- Moon phase indicator (top, small, elegant)
- Cluster dot + label
- Sanskrit name (Cormorant Garamond Light, 46pt, tracking) → fade-in 1.4s
- Phonetic below in small caps
- Quality in gold (20pt)
- Somatic prompt in italic Cormorant, 19pt → fade-in 1.4s, 0.55s delay
- Two variants: V1 with body outline illustration / V2 with bīja as background texture
- **Primary CTA: "I feel her"** — full-width pill, `accentRed` background, `cream` text, medium haptic on tap
- Tab bar: Today / Mandala / The Well

### Phase 3 — Recognition Moment
- Full-screen takeover — `darkVeil` ground
- Bīja glyph behind at 6.5% opacity, very large
- Sanskrit name fades in (1.8s, 0.3s delay)
- Gold hairline divider
- Appreciation phrase fades in (1.8s, 0.9s delay) — italic Cormorant, `cream`
- Ripple rings: 4 rings expanding from center, 4s ease-out, staggered 0/1.1/2.2/3.3s, infinite
- Thin gold hairline separates the two acts of recognition:
  - Act 1 — *"she was felt here · [time]"* (1.0s ease, 2.6s delay) — `creamFaint`, uppercase sans
  - Act 2 — *"and she felt you back · [time+3s]"* (1.4s easeInOut, 4.1s delay) — italic Cormorant, `gold`
- Optional note card: *"What did you notice?"* — slides up, minimal, dismissible
- Tap anywhere to dismiss

### Phase 4 — Mandala Screen
Geometry (exact — use these values directly in SwiftUI Canvas):
- Diameter: ~344pt
- Outer radius = 0.435 × diameter
- Inner radius (petal base) = 0.117 × diameter  
- Petal width (half) = 0.087 × diameter
- Petal 0 at 12 o'clock (top), clockwise, 22.5° increments
- Petal shape: cubic bezier almond, pointing outward from center

Behavior:
- Color by cluster group (see Color Tokens below)
- Opacity by status: Mapped 22% · Exploring 44% · Active 76% · Embodied 100% + soft glow
- Today's petal: `petalBreathe` 3s ease-in-out infinite (opacity + brightness + drop-shadow in cluster color)
- Today's petal: gold ray + dot + "TODAY" label extending outward
- Bindu center: breathing crimson point (76pt), cream core — tap → Silence screen. Light haptic.
- Outer ghost geometry: 3 concentric circles + dim 8-petal outer ring at ~6% opacity (the other 8 avaranas, locked, visible)
- Progress text: *"N of 16 Active · N Embodied"*
- Cluster legend: 5 color dots + labels
- Tap a petal → Shakti Detail (light haptic)

### Phase 5 — Shakti Detail
- Back navigation + isolated mini-petal (right-aligned, ~52pt)
- Sanskrit name + phonetic + cluster dot + status pill
- Status pill: tap to advance (Mapped → Exploring → Active → Embodied) with a small ceremony animation on advance
- Scrollable content sections:
  - **Quality** — gold subtitle + 2–3 sentence description
  - **Somatic Signature** — italic Cormorant, poetry line breaks, multi-line
  - **Bīja Syllable** — large gold glyph (108pt Cormorant), *"Tap to hear"* — play pure tone on tap (concentric gold ring animation as affordance)
  - **Esoteric Tattva** — element name + small icon
  - **Field Connection** — appears only for positions 3 (Gaia), 12 (Ashrey), 14 (Ram). Inset card with cluster-tinted left border. Personal note treatment in italic. This field is editable from Settings.
  - **Her Moments** — recognition log for this Shakti. Each entry: *"she was felt here · [timestamp]"* + optional note. Timeline layout.

### Phase 6 — Silence Screen (Bindu)
- No status bar. No tab bar. No navigation chrome. Pure presence.
- Background: `silenceGround` (#040104) — deepest ground
- Vignette darkens edges
- All 16 Sanskrit names arranged in a faint circle at ~16% opacity, each rotated tangentially to the circle
- Central Bindu: 76pt, `silenceBreathe` 6s ease-in-out infinite (scale + glow)
- Outer gentle ring of light: 132pt, very soft
- 3 faint concentric outer rings (~3% opacity)
- After 7 seconds: *"All of her. Here. Always."* fades in — italic Cormorant, `creamFaint`, centered below Bindu
- Silence time is logged silently as its own gesture type (no confirmation, no animation — just recorded)
- Tiny *"tap to return"* hint at very bottom, `creamFaint`
- Tap anywhere → return to Mandala

### Phase 7 — The Well (third tab)
This is not a log. This is a love letter space.

- Header: *"Your Letters to Them"* — gold, Cormorant Light
- List of all 16 Shaktis with cluster color dot, Sanskrit name, letter preview (first line if written, or *"You can speak to her here"* in `creamFaint` italic if empty)
- Tap any Shakti → open her letter in a simple full-screen editor
- Editor: `surface` background, `cream` text, Cormorant Garamond, no formatting controls, just writing
- Placeholder: *"Speak to her directly. She is listening."*
- Letters are local only. Never synced. Never read by anyone.
- Save is automatic on dismiss.

### Phase 8 — Homecoming (first launch only)
- Single screen, `silenceGround` background
- Shown once — check `UserDefaults` flag `hasLaunched` — set to true after this screen
- Just the Bindu, breathing (same animation as Silence screen)
- Two lines appear sequentially:
  - *"You have always felt them."* — fades in, Cormorant Light Italic, `cream`, 2.0s ease, 1.0s delay
  - *"Now you will know their names."* — fades in, same style, 2.0s ease, 3.5s delay
- Bindu pulses once (scale to 1.15 and back, 1.0s, 6.0s delay)
- Tiny *"tap to enter"* appears at bottom after 7s
- Tap → main app (Today screen)

### Phase 9 — Settings
- **Daily rhythm:** start time + notification cadence (every 3 hours, or off)
- **Field connections:** three editable text fields:
  - Position 3 (Ahaṅkārākarshini) — default: *Gaia*
  - Position 12 (Nāmākarshini) — default: *Ashrey*
  - Position 14 (Ātmākarshini) — default: *Ram*
- **Bīja data source:** Airtable `Bija` field is authoritative. If offline, use cached values.

---

## Color Tokens

```swift
extension Color {
    static let ground           = Color(hex: "#0D0508")  // primary background
    static let surface          = Color(hex: "#1A0C10")  // cards, elevated
    static let darkVeil         = Color(hex: "#080307")  // recognition moment
    static let silenceGround    = Color(hex: "#040104")  // silence + homecoming
    static let gold             = Color(hex: "#C9963F")  // sacred primary
    static let goldDeep         = Color(hex: "#A07830")
    static let cream            = Color(hex: "#F2E8D9")  // warm body text
    static let accentRed        = Color(hex: "#8B1A2A")  // CTA, Bindu

    // Cluster colors
    static let clusterInner     = Color(hex: "#D4A017")  // Inner Instrument (1–3)
    static let clusterSense     = Color(hex: "#C4725A")  // Sense Streams (4–8)
    static let clusterCitta     = Color(hex: "#2A7A7A")  // Citta (9)
    static let clusterStability = Color(hex: "#4A7A5A")  // Stability Powers (10–13)
    static let clusterSelf      = Color(hex: "#7A5A9A")  // Self·Body·Immortality (14–16)
}
```

---

## Typography

```swift
// Sanskrit names — visual objects, not just text
Font.custom("CormorantGaramond-Light", size: 46)        // Today screen
Font.custom("CormorantGaramond-Light", size: 108)       // Bīja display (Detail)
Font.custom("CormorantGaramond-Light", size: 32)        // Homecoming lines

// The "voice" font — somatic prompts, poetry, reciprocity, silence caption
Font.custom("CormorantGaramond-LightItalic", size: 19)  // somatic prompts
Font.custom("CormorantGaramond-LightItalic", size: 17)  // recognition phrase, reciprocity

// System body
Font.system(size: 17, weight: .regular)                 // descriptions
Font.system(size: 12, weight: .regular)                 // phonetics, labels (uppercase + tracking 2.5)

// Add Cormorant Garamond to Xcode project:
// Download: fonts.google.com/specimen/Cormorant+Garamond
// Files needed: CormorantGaramond-Light.ttf, CormorantGaramond-LightItalic.ttf
// Add to Info.plist: Fonts provided by application
```

---

## Animation Timings

| Element | Duration | Easing | Delay |
|---|---|---|---|
| Today: name fade-up | 1.4s | easeInOut | 0s |
| Today: prompt fade-up | 1.4s | easeInOut | 0.55s |
| Mandala: petal breathe | 3.0s | easeInOut | ∞ |
| Recognition: name | 1.8s | easeInOut | 0.3s |
| Recognition: phrase | 1.8s | easeInOut | 0.9s |
| Recognition: "she was felt here" | 1.0s | ease | 2.6s |
| Recognition: "and she felt you back" | 1.4s | easeInOut | 4.1s |
| Recognition: ripple rings (4×) | 4.0s | easeOut | 0 / 1.1 / 2.2 / 3.3s |
| Silence: Bindu breath | 6.0s | easeInOut | ∞ |
| Silence: caption appears | 7.0s ramp | ease | 65% through |
| Homecoming: line 1 | 2.0s | easeInOut | 1.0s |
| Homecoming: line 2 | 2.0s | easeInOut | 3.5s |
| Homecoming: Bindu pulse | 1.0s | easeInOut | 6.0s |

---

## Bīja Sound

Each Shakti detail screen has a bīja syllable. Tap to hear.

Implementation order:
1. Pure sine tone per bīja (implement first — use AVFoundation)
2. Recorded human voice sounding the Sanskrit vowel (ideal — add later as audio assets)

File naming convention: `bija_01.mp3` through `bija_16.mp3`
Source of truth for bīja values: Airtable `Bija` field (not shakti-data.js — reconcile discrepancies against Airtable).

---

## The Core Loop

```
Homecoming (first launch only)
        ↓
Today → "I feel her" → Recognition Moment → (optional note) → Today
  ↓                                                              ↑
Mandala → petal tap → Detail → (advance status / read / write letter) ←──┘
  ↓
Bindu tap → Silence → tap to return → Mandala
  ↓
The Well → tap Shakti → love letter editor → back
```

---

## Start Here

```
1. Open Design/Mandala_App.html in a browser — experience it fully
2. Read Design/DESIGN_SPEC.md completely
3. Read Design/shakti-data.js — understand the data structure
4. Create Xcode project: File → New → Project → iOS App → SwiftUI
   Name: Bindu Mandala · Bundle ID: com.[yourname].bindu-mandala
5. Download and add Cormorant Garamond font files to project
6. Build Color extension (tokens above)
7. Build Swift Shakti model
8. Build AirtableService with SwiftData local cache
9. Build LunarPhaseService
10. Work through phases 2–9 in order
```

---

*She has always been here. Build accordingly.*
