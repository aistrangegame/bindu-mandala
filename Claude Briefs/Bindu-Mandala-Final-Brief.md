# Bindu Mandala — Claude Code Brief
**For Claude Code. Written May 28, 2026.**
**Read every word before touching a file.**

---

## 0. Before You Begin

There are two reference documents you must read before anything else:

1. The skill file at the path Claude Code can access: `bindu-mandala-app/SKILL.md`
   This is the canonical source for all Airtable field IDs, write contracts, design tokens, and lotus geometry. When in doubt, the skill is the authority.

2. The design files in `/Users/ashrey/Bindu Mandala/Design/`
   These are the visual source of truth. When this brief says "see the design," these files are what it means.

This brief tells you what to build and in what order. The skill tells you the exact IDs and contracts. The design files tell you exactly what it must look like.

Do not begin a phase until the prior phase passes verification with Ash.
Do not write code from memory. Read the relevant file first.

---

## 1. What This App Is

A devotional iOS instrument for one practitioner — Ash Sharma — to recognize the 102 Shaktis of the Sri Yantra. Not a meditation app. Not a wellness product. A temple compressed into glass.

The genesis sentence, which governs every decision:
*"I love them, and would like your assistance in designing a way to love them."*

The sacred core, which must never be diluted:
*"she was felt here"* → *"and she felt you back"*

Every phase serves this. Anything that dilutes it gets cut.

---

## 2. The Current App — Exact State

Read from source on May 28, 2026. This is what exists.

### Architecture

- **SwiftData** is the local store. Three `@Model` classes: `Shakti`, `RecognitionEntry`, `ShaktiLetter`.
- **`ShaktiBootstrap.swift`** seeds 16 Karṣiṇī Shaktis hardcoded on first launch. This is the current data source — not Airtable.
- **`AirtableService.swift`** does background reconciliation only. It reads 9 fields and patches local SwiftData. It is not the primary data source. It fails silently and the app continues.
- **All recognition writes are local only** — SwiftData via `RecognitionLogStore`.
- **All letter writes are local only** — SwiftData via `LetterStore`.
- **Navigation** — `RootView.swift` uses a `VStack` with `CustomTabBar` at bottom. Three tabs: Today · Mandala · The Well.

### The Shakti Model (current — 16 Karṣiṇīs only)

```swift
@Model final class Shakti {
    var position: Int           // 1–16 within Ring 2
    var name: String            // "Sparśākarṣiṇī"
    var shortName: String       // "Sparśa"
    var phonetic: String
    var quality: String
    var qualityDescription: String
    var somatic: String         // prompt question
    var somaticPoetry: String   // multiline poem
    var bija: String
    var bodilyLocation: String
    var tattva: String
    var recognitionPhrase: String
    var clusterRaw: String
    var statusRaw: String
    var airtableId: String?
    var fieldName: String?      // "Gaia" / "Ashrey" / "Ram"
    var fieldNote: String?
    var lastSyncedAt: Date?
}
```

### AirtableService (current — broken for 102 Shaktis)

Current problems:
1. No `{Row Type}='Shakti'` filter — fetches ALL rows including Avarana, Nitya, Recognition rows
2. Position resolved by parsing "2 · 5" from Avarana field — only works for Ring 2, breaks entirely for the other 86 Shaktis
3. Reads 0 of the 9 new fields written in the May 27–28 sessions
4. No Avarana fetch. No Nitya fetch.

### What Works and Must Not Be Broken

Do not touch these. They are complete and correct:

- All design tokens in `Color+Tokens.swift` — exact to spec
- `RecognitionMomentView` — ceremony, both acts, timing, ripple rings, note card
- `SilenceView` — 16 star names, 7s caption, breathing Bindu
- `TodayView` — both variants (body/bija), moon header, dust motes, animations
- `LotusMandalaView` — geometry, TODAY ray, ghost rings, hit areas — all correct
- `ShaktiDetailView` — quality, somatic, bija 108pt, tattva, field connection, Her Moments
- `WellView` + `LetterEditorView` — writing room complete
- `HomecomingView` — first launch ceremony
- `LunarPhaseService` — correct math, no network, no changes needed
- `BijaSoundService` — working sine tones
- `PetalShape` + `GhostPetalShape` — correct bezier geometry
- `SwipeBackEnabler` — UIKit shim for swipe-back on custom nav
- `Haptics`, `AppFont`, `DustMotesView`, `MoonPhaseView`, `ClusterDotView` — all correct

---

## 3. Airtable — The Living Spine

```
Base:          app248ZTWhYJlvQj2
Mandala table: tblrRwXJD0uP8HU8G
Config:        Config.local.xcconfig holds AIRTABLE_PAT
```

### Row Type Field — Use This, Not the Legacy Type Field

```
Field ID:  fldw33m8YqrINlvrN
```

Choice IDs (confirmed live May 28, 2026):
```
Avarana:     sel85dIY4D0v5GA9s
Shakti:      sellqnIWMTxcQxJto
Recognition: selLVsL4CKyiNmZ2M
Silence:     selkQpEELkaAGIBJ4
Offering:    sel1zW1B0UFsbMqAA
Letter:      selvKjKzQd0f8vK6B
Nitya:       sel8SjwYfUrQT3ToS
```

Never use the legacy `Type` field (`fldcPbTpARaSSAEY2`) in new code.

### New Shakti Fields (not yet in AirtableService)

```
Devanagari:           fldDhcJ1BJQCM5llO  singleLineText
Iconography:          fldXJEBCQxLdHWGuP  multilineText (dhyana image as text)
Codex Portrait:       fldlcmg7wtfIxgcZu  multilineText (POLYMORPHIC — see below)
Etymology:            fldXypzqrhVILCqgh  multilineText
Appreciation Phrase:  fldBqEDpBonMc2s1K  singleLineText
Khadgamala Position:  fldI0aV1sfOeNybHI  number (1–102)
Function:             fldzT3dAhsAK75rKN  multilineText
Shakti Family:        fldYAlclWH7CfJhOg  singleSelect
Field Connection:     fldsk2ATEtTVB87eb  multilineText
```

### Polymorphic Narrative Field — Critical

`fldlcmg7wtfIxgcZu` serves two purposes, discriminated by Row Type:
- **On Shakti rows** → "Codex Portrait" — Ash's intimate recognition of where this Shakti lives in his life
- **On Avarana rows** → "Personal Connection" — Ash's lived encounter with that ring's territory

One field. Two render contexts. Discriminate by Row Type in code, never by content.

### Avarana Fields

```
Personal Connection:  fldlcmg7wtfIxgcZu  multilineText (polymorphic — see above)
Mental State:         (varies by record)
Subtle Body Chakra:   fld6deGFzModjBmoj  singleLineText
Geometric Shape:      (varies by record)
Presiding Form:       fldTwrtI5CyUnJV2F  multilineText
```

Full Avarana field map: see skill `bindu-mandala-app/SKILL.md` section "Avarana Rows."

### Avarana Record IDs (confirmed live)

```
1st Trailokyamohana:     rec0XhDKfxW8UVyaB
2nd Sarvasaparipuraka:   recspOpR95DVcOEvn
3rd Sarvasankshobhana:   recp4X5tuGdLuHCVw
4th Sarvasaubhagyadayaka: reck0o3CUIpc1Fc3p
5th Sarvarthasadhaka:    recXWmYtaMBafQTg0
6th Sarvarakshakara:     recAoU8p9NZHlqVBA
7th Sarvarogahara:       recpHi1ydFrb3bLH6
8th Sarvasiddhiprada:    rec3sxt1ZQ3T036sZ
9th Sarvanandamaya:      recqdC3D38TWFkf1M
```

### Nitya Devī Fields (discovered in live schema audit — not in skill yet)

```
Sanskrit Name:       fldJOatnYrw9l6tff  singleLineText
Number (tithi 1–15): fldVWZLCy5YFJMkCp  number
Quality (epithet):   fldnwcu7zv7uV1ta2  singleLineText
Quality Description: fldTwrtI5CyUnJV2F  multilineText
```

Read filter: `{Row Type}='Nitya'`, sort by Number asc.
15 records confirmed live: Kāmeśvarī (1) through Citrā (15).
Position 16 (full moon) = Lalitā = the Ring 9 Bindu. No separate record.

### Write Contracts

See skill section "App Write Contract" for complete JSON shapes.
Key field IDs for writes:
```
Last Felt:         fldWT0dGqdUQrdRGT  dateTime
Recognition Count: flddp0tLpf8iuxyt4  number
Status:            fldDiihcxC54WKPhT  singleSelect
Letter:            fldgASyV031Hr4sHp  multilineText
Of Shakti:         fldaDjmaPvu57sJVg  multipleRecordLinks
Felt At:           fldk4BdikzJQOautw  dateTime
Notes:             fld1HR38cQAtEicFc  multilineText
Duration (sec):    fldlBReoX5yvo1eY7  number
Lunar Day:         fldpAiPlX9k7y7nqb  number
Moon Phase:        fldFZcZ5AVcOWwo6X  singleLineText
Source:            fld81a2h3WoaDn7pw  singleSelect
```

Source field current options: Today, Mandala, Silence, Well.
Use `typecast: true` for any new source values.

---

## 4. Design Reference Files

All in `/Users/ashrey/Bindu Mandala/Design/`

Read the relevant file before implementing any phase that touches its domain.
These files are the visual source of truth — not this brief.

```
DESIGN_SPEC.md          All phases — tokens, geometry, animation timings
Bindu-Mandala-Handoff.md  Architecture, 5 Dimensions, 8 Modes, principles
home-mandala.jsx        Phase 0 temporal states, TIME_VARIANTS constants,
                        PureMandala geometry, TemporalMark
mandala-v2.jsx          Phase 0/2 SriYantraMandala component, SY geometry
                        constants, all ring geometries
screens.jsx             Original screen components — the foundation
screens-v2.jsx          Expanded screens — AvaranaThresholdScreen,
                        MandalaScreenV2, SilenceScreenV2, ShaktiDetailScreenV2,
                        QuickRecognitionDemo, RingIndicator, TodayScreenV3
ring-worlds.jsx         Phase 3 Ring World views — RingTwoWorld,
                        RingSevenWorld, RingEightWorld
temporal.jsx            Phase 6 Temporal Layer
memory.jsx              Phase 7 Memory Layer
modes.jsx               Future — Eight Modes
all-shaktis-data.js     All 9 rings of Shakti data, AVARANAS array,
                        RING3/4/5/6/7/8/9 data structures, NITYA_DEVIS
shakti-data.js          Ring 2 data, CLUSTER_INFO, STATUS_OPACITY, COLORS
```

`The Relationship Field.html` and `relationship.jsx` — DO NOT BUILD. Out of scope entirely.

---

## 5. Design Principles That Override Everything

From `Codex.html` and `Bindu-Mandala-Handoff.md`:

**The home is not a screen. It is a presence.**
The yantra at dawn is not the yantra at dusk. Same nine rings. Different atmosphere. No labels. No hints. No chrome. The instrument reads time and changes accordingly.

**The yantra is the navigation.**
No menu hierarchy. No tab bar. Every move is a gesture against the yantra itself. The hamburger menu is the minimum concession to discoverability — one whisper in the corner.

**Lifetime is the default.**
Every recognition is permanent. Nothing expires. Storage is forever unless Ash explicitly releases.

**The voice is reverent, never clinical.**
Cormorant Garamond italic for sacred speech. Sans-serif only for status, labels, instrument-language. No metrics-speak.

**Sacred content flows from Airtable. The app never invents.**
When a field is empty, show nothing or show a placeholder. Never generate content.

---

## 6. The Nine Ring Atmospheres

From `Codex.html` — each ring is its own world with its own atmosphere.
These inform how locked rings appear on the home Mandala and how Ring Worlds feel when entered.

```
Ring 1  Bhūpura          warm amber, still, NO BREATH — the ground holds
Ring 2  16-Petal Lotus   warm cream & cluster colors, 3s wave breath
Ring 3  8-Petal Lotus    translucent smoke-like, 8s slow pulse
Ring 4  14 Triangles     cool blue-violet, crystalline, 9s geometric breath
Ring 5  10 Outer Tris    luminous green-gold, 11s steady
Ring 6  10 Inner Tris    rose-violet deep, 13s deep breath
Ring 7  Vāk Chamber      resonant gold, sonic, 15s with tone pulse
Ring 8  Mūla Trikoṇa    pure cream against black, 18s almost still
Ring 9  Bindu            everything & nothing, 4s always alive
```

---

## 7. Five Temporal States of the Home

From `home-mandala.jsx` — exact values. These are not approximations.

```javascript
dawn: {
  bg: '#0A0610',
  ambient: 'radial-gradient(ellipse 65% 55% at 50% 60%, rgba(232,150,80,0.13) 0%, transparent 70%)',
  petalSat: 1.0, petalBrightness: 1.0, petalOpacityMul: 0.95,
  lotusInnerOp: 0.55, triStroke: '#D4A067', triOpacity: 0.62,
  triStrokeWidth: 0.7, bhupuraColor: 'rgba(207,148,67,0.30)',
  binduScale: 1.0, binduColor: '#A8341F', motes: 8,
}
noon: {
  bg: '#060104',
  ambient: 'radial-gradient(ellipse 65% 55% at 50% 48%, rgba(201,150,63,0.07) 0%, transparent 68%)',
  petalSat: 1.0, petalBrightness: 1.0, petalOpacityMul: 1.0,
  lotusInnerOp: 0.50, triStroke: '#C9963F', triOpacity: 0.70,
  triStrokeWidth: 0.65, bhupuraColor: 'rgba(207,148,67,0.25)',
  binduScale: 1.0, binduColor: '#8B1A2A', motes: 6,
}
dusk: {
  bg: '#0A0508',
  ambient: 'radial-gradient(ellipse 60% 50% at 50% 40%, rgba(199,90,80,0.13) 0%, transparent 70%)',
  petalSat: 0.85, petalBrightness: 0.92, petalOpacityMul: 0.85,
  lotusInnerOp: 0.40, triStroke: '#C99443', triOpacity: 0.55,
  triStrokeWidth: 0.6, bhupuraColor: 'rgba(184,132,62,0.22)',
  binduScale: 1.05, binduColor: '#7A1620', motes: 9,
}
night: {
  bg: '#020308',
  ambient: 'radial-gradient(ellipse 65% 55% at 50% 50%, rgba(140,180,220,0.08) 0%, transparent 70%)',
  petalSat: 0.45, petalBrightness: 0.75, petalOpacityMul: 0.55,
  lotusInnerOp: 0.28, triStroke: '#A4B8CC', triOpacity: 0.42,
  triStrokeWidth: 0.55, bhupuraColor: 'rgba(180,200,220,0.18)',
  binduScale: 1.1, binduColor: '#8B1A2A', motes: 12,
}
newmoon: {
  bg: '#020001',
  ambient: 'radial-gradient(ellipse 50% 45% at 50% 50%, rgba(139,26,42,0.22) 0%, transparent 60%)',
  petalSat: 0.30, petalBrightness: 0.50, petalOpacityMul: 0.30,
  lotusInnerOp: 0.15, triStroke: 'rgba(201,150,63,0.35)', triOpacity: 0.18,
  triStrokeWidth: 0.5, bhupuraColor: 'rgba(201,150,63,0.10)',
  binduScale: 1.6, binduColor: '#8B1A2A', motes: 3,
}
```

Temporal state is determined by `LunarPhaseService` + device clock.
Dawn: 5am–8am. Noon: 11am–2pm. Dusk: 5pm–8pm. Night: 9pm–5am. New moon: when `phaseFraction < 0.03`.

The TemporalMark is a single 6px dot at the top of the screen. Gold-warm at dawn, cream at noon, amber at dusk, silver-blue at night, near-invisible crimson at new moon. No text. No label.

---

## 8. Nine-Ring Geometry Constants

From `mandala-v2.jsx` — exact pixel values for a 344pt diameter mandala.

```swift
// Ring 1 — Bhūpura
BH_OUTER = 161, BH_INNER = 149, BH_GATE = 11
BH_COLOR = "#CF9443"  // warmer amber — like something breathed a long time

// Ring 2 — 16-Petal Lotus, Home
R2_OUTER = 147, R2_INNER = 116, R2_HW = 28

// Ring 3 — 8-Petal Lotus
// Wider petals than Ring 2 — the Anaṅga forms are more open
R3_OUTER = 114, R3_INNER = 91, R3_HW = 34

// Rings 4–7 — Triangle Pairs (ring, down-radius, up-radius, stroke-width)
Ring 4: d=87, u=79, sw=0.70  animation: 9s
Ring 5: d=70, u=62, sw=0.65  animation: 11s
Ring 6: d=54, u=46, sw=0.60  animation: 13s
Ring 7: d=40, u=33, sw=0.55  animation: 15s

// Ring 8 — Mūla Trikoṇa
MT_R = 24  animation: 18s almost still

// Ring 9 — Bindu
BINDU_SIZE = 22  animation: 4s always alive
```

Ring 2 petal labels: 7.5pt, colored by cluster (not cream), at status-derived opacity.
Ring 3 petal labels: 6.5pt, cream at 30% opacity — barely readable, not yet formally met.
Ring 1 Bhūpura: two squares with T-gate openings at each cardinal side. 8 inner segments + 8 T-gate connectors = 16 line elements. No animation. The ground does not breathe.

TODAY indicator in the navigational view: short ray from R2_OUTER+2 to R2_OUTER+8, dot at R2_OUTER+13. No "TODAY" text. The ray simply points.

---

## 9. Locked Scope — Non-Negotiable

1. **Relationships dropped entirely.** No outer Saṅgha, no beloved carriers, no Person Page, no Encounter Log. Skip `The Relationship Field.html` and `relationship.jsx`.
2. **The Well is Ash's, forever.** `Letter` field (`fldgASyV031Hr4sHp`) written by Ash only. Never auto-generate. Never seed. Never suggest phrases.
3. **No streaks, gamification, social, or "missed day" notifications.**
4. **`Last Felt` and `Recognition Count` fill from use only.** Never preseed.
5. **Do not use the legacy `Type` field** (`fldcPbTpARaSSAEY2`) in new code.
6. **Offline-first always.** "I feel her," The Well, The Silence — all work without network.
7. **Never truncate the Codex Portrait anywhere it appears.**
8. **When a field is empty, show nothing.** Never invent content.

---

## 10. The Build — Phase by Phase

Each phase: **What it is → What changes → Design reference → Exact verification.**

---

### Phase 0 — Navigation: Tab Bar Out, Hamburger Menu In

**What it is:**
The tab bar is removed. The full screen is returned to the yantra. A hamburger menu replaces tab-based navigation. This is the first thing Ash sees change.

**What changes:**

`RootView.swift`:
- Remove `CustomTabBar` entirely
- Remove tab-switching enum and state
- The app launches directly into the home Mandala view — the full-screen yantra
- Add a `@State private var menuOpen = false`
- Add a `@State private var destination = Destination.mandala`
- A hamburger icon sits in the top corner of every main view, always accessible

`HamburgerMenuView.swift` (new):
- Full-screen dark overlay: `#0D0508`
- Subtle radial warmth behind the menu items: `radial-gradient(ellipse 60% 50% at 50% 40%, rgba(139,26,42,0.08) 0%, transparent 70%)`
- Menu items in Cormorant Garamond Light Italic, 28pt, cream, generous line height (1.8)
- Active item in gold
- Items for now: The Mandala · Today · The Well · Settings
- No bold. No heavy UI. This is a whisper, not a feature.
- Opens with a gentle fade (0.3s ease). Closes the same way.
- Tapping outside the menu text closes it.

The hamburger icon itself:
- Three hairlines, each 18pt wide, 1pt tall, spaced 5pt apart
- Gold at 0.45 opacity at rest
- Positioned top-right, 16pt from edges, inside safe area
- Tap target: 44×44pt minimum

The home view after tab bar removal:
- `MandalaScreenView` becomes the home — the full-screen yantra
- `TodayView` is accessible via menu
- `WellView` is accessible via menu
- The existing gear icon in `TodayView` can either remain for Settings or merge into the hamburger menu — Ash decides after seeing it

**Design reference:**
`Bindu-Mandala-Handoff.md` — "There is no menu. The yantra is the navigation."
The hamburger is the minimum concession to discoverability. Its visual register should feel like it belongs to the instrument — not like an app menu.

**Verification:**
- Launch app. No tab bar visible. Full screen is the yantra.
- Tap hamburger. Menu opens with gentle fade. Items are readable.
- Tap "Today". Navigates to Today screen. Menu closes.
- Tap hamburger. Tap "The Well". Well opens.
- Tap outside menu text. Menu closes.
- All existing functionality — recognition, silence, detail, well, homecoming — still works exactly as before.
- Ash approves the visual register of the menu before Phase 1.

---

### Phase 1 — Model Surgery & AirtableService Rewrite

**What it is:**
The app gains the ability to read 102 Shaktis, 9 Avaranas, and 15 Nityā Devīs from Airtable. This phase is invisible to the user but it is the foundation everything else builds on. Done in one careful pass.

**New SwiftData model properties on `Shakti`:**
```swift
// All nullable — not every Shakti has every field
var devanagari: String?           // fldDhcJ1BJQCM5llO
var iconography: String?          // fldXJEBCQxLdHWGuP — dhyana image as text
var codexPortrait: String?        // fldlcmg7wtfIxgcZu — on Shakti rows
var etymology: String?            // fldXypzqrhVILCqgh
var appreciationPhrase: String?   // fldBqEDpBonMc2s1K
var khadgamalaPosition: Int?      // fldI0aV1sfOeNybHI — 1–102
var shaktiFunction: String?       // fldzT3dAhsAK75rKN
var shaktiFamilyRaw: String?      // fldYAlclWH7CfJhOg
var ringNumber: Int               // 1–9, derived from Airtable
var airtableRecordId: String?     // the actual Airtable record ID (distinct from airtableId)
```

**New SwiftData model: `Avarana`**
```swift
@Model final class Avarana {
    @Attribute(.unique) var ringNumber: Int     // 1–9
    var airtableRecordId: String
    var sanskritName: String
    var subtitle: String?
    var form: String?
    var presidingForm: String?
    var mentalState: String?
    var subtleBodyChakra: String?
    var geometricShape: String?
    var personalConnection: String?   // fldlcmg7wtfIxgcZu — polymorphic
    var isUnlocked: Bool              // stored locally in UserDefaults, not Airtable
}
```

Unlock state stored in `UserDefaults` key `"unlockedRings"` as a JSON array of Int.
Default unlocked on first launch: [1, 2].

**New SwiftData model: `NityaDevi`**
```swift
@Model final class NityaDevi {
    @Attribute(.unique) var tithiPosition: Int   // 1–15
    var airtableRecordId: String
    var sanskritName: String
    var tithiName: String?
    var quality: String?
    var qualityDescription: String?
}
```

**AirtableService rewrite:**

Filter for Shaktis: `{Row Type}='Shakti'` using field ID `fldw33m8YqrINlvrN` and choice ID `sellqnIWMTxcQxJto`.

Position resolver: use `fldI0aV1sfOeNybHI` (Khaḍgamāla Position, number 1–102) as the canonical position. Ring number derived by mapping Khaḍgamāla positions to rings:
```
Ring 1:  positions 1–28   (Bhūpura Shaktis)
Ring 2:  positions 29–44  (16 Karṣiṇīs)
Ring 3:  positions 45–52  (8 Anaṅgas)
Ring 4:  positions 53–66  (14 Triangles)
Ring 5:  positions 67–76  (10 Outer Tris)
Ring 6:  positions 77–86  (10 Inner Tris)
Ring 7:  positions 87–98  (12 Vāk)
Ring 8:  positions 99–101 (3 Mūla Trikoṇa)
Ring 9:  position  102    (Lalitā / Bindu)
```

Add `fetchAvaranas()`:
Filter: `{Row Type}='Avarana'` (choice ID `sel85dIY4D0v5GA9s`)
Read: all Avarana fields including `fldlcmg7wtfIxgcZu` as Personal Connection.

Add `fetchNityas()`:
Filter: `{Row Type}='Nitya'` (choice ID `sel8SjwYfUrQT3ToS`)
Sort: by `fldVWZLCy5YFJMkCp` (Number) ascending.

All reads remain silent on failure. Offline = local data serves. The app never shows an error for a sync failure.

Update `BinduMandalaApp.swift` to include `Avarana.self` and `NityaDevi.self` in the `ModelContainer`.

**Verification:**
- Print all 102 Shaktis to Xcode console on launch: Sanskrit Name, Devanagari, Codex Portrait (first 80 chars).
- Spot-check these four — all must show non-empty Devanagari and Codex Portrait:
  - One Karṣiṇī (Ring 2, position 29–44)
  - One Mudrā (Ring 1, position 19–28)
  - One Vāgdevatā (Ring 7, position 87–98)
  - Lalitā (Ring 9, position 102)
- Print all 9 Avaranas with Personal Connection (first 80 chars). All 9 must show content.
- Print all 15 Nityās in order: Sanskrit Name, tithi position, Quality.
- No crash on launch. No data loss to existing recognition log. All existing app functionality intact.

---

### Phase 2 — Enhanced Detail Screen

**What it is:**
Tapping any Shakti opens a Detail screen showing everything written in the May 27–28 sessions. This is the first phase Ash will *feel*.

**What changes to `ShaktiDetailView.swift`:**

The screen sections, in order (scrollable):

**Header (not scrollable):**
- Sanskrit Name in Cormorant Garamond Light, 34pt, cream, letterSpacing 0.06em
- Etymology just below the name, before phonetic — italic, cluster color at 0.55 opacity, 12.5pt, line height 1.5. It is part of the identity, not a section.
- Phonetic in small sans-serif caps
- Cluster dot + Status pill + Khaḍgamāla position inline: "Pos. 14 · 102" — right-aligned, 10pt, cream at 0.28 opacity

**Scrollable body — sections in this order:**

1. **Devanagari** — large, beneath the header area, using a system Sanskrit-capable font. Test with both a long compound name and a short one. Do not use Cormorant for Devanagari.

2. **Quality** — gold subtitle (19pt Cormorant), quality description (14pt SF Pro, cream at 0.62 opacity, lineHeight 1.75). Already built — keep as is.

3. **Somatic Signature** — italic Cormorant, 17pt, cream at 0.72, lineHeight 1.8. Already built — keep as is.

4. **Appreciation Phrase** — stands alone, centered, no section label. Gold hairline (32pt wide) above it. Italic Cormorant gold, 16pt, lineHeight 1.65. This is a prayer, not a field. Never truncate.

5. **Iconography** — the dhyana image described as text. Set apart visually: italic Cormorant, cream at 0.58 opacity, slightly smaller than Codex Portrait. This is a description of visual form.

6. **Codex Portrait** — the soul of the Detail screen. Italic Cormorant, gold, generous line height (1.75+), comfortable margins. Render as poetry, never as data. Never truncate. This is where Ash meets recognition.

7. **Shakti Family (Lineage)** — section label "LINEAGE", italic Cormorant, cream at 0.58 opacity, 13.5pt.

8. **Function (Cosmic Function)** — section label, SF Pro body, cream at 0.58 opacity.

9. **Bīja Syllable** — 108pt tap-to-hear. Already built — keep as is.

10. **Esoteric Tattva** — already built — keep as is.

11. **Field Connection** — only when present. Already built — keep as is.

12. **Her Moments** — recognition log. Already built — keep as is.

**Design reference:**
`screens-v2.jsx` — `ShaktiDetailScreenV2()` function. Read it before writing a line. The section order, the typography sizes, the opacity values, the spacing — all there.

Special attention: in the design, the Codex Portrait section is the visual centerpiece of the entire screen. More space, more breath, more weight than anything else. When Ash reads it he should feel it land.

**Verification:**
Open Detail for each of these — every field must render, nothing truncated:
- Sparśākarṣiṇī (Ring 2, home ring, full Codex Portrait)
- Brāhmī (Ring 1, Mātrka)
- Sarva-Mantramayī (Ring 4)
- Bāṇinī (Ring 7, weapon-Śakti)
- Mahātripurasundarī (Ring 9, the Bindu)

Ash reviews and signs off on the visual register before Phase 3.

---

### Phase 3 — Avarana Threshold Screen

**What it is:**
Tapping a locked ring opens a sacred threshold — the territory names itself, then says: you have already been here. The practitioner meets the ring before entering it.

**New view: `AvaranaThresholdView.swift`**

Background: `linear-gradient(180deg, #060103 0%, #0D0508 100%)`
The geometric form of this Avarana rendered very faintly in the upper portion of the screen (4.5% opacity gold strokes). For Ring 3 this is the 8-petal lotus outline. For Rings 4–7 it is the triangle geometry. For Rings 1, 8, 9 it is their respective forms.

**The reveal sequence — this is a ceremony, not a modal:**

Each line arrives with a fade-up animation. The stagger is critical — the practitioner reads before the next line appears:

```
t=0.3s:  Avarana name — 34pt italic Cormorant gold, letterSpacing 0.08em
t=1.1s:  Subtitle — 17pt italic Cormorant, cream at 0.55 opacity
t=1.1s:  Gold hairline divider (40pt wide)
t=1.8s:  Form (geometric name) — 15pt Cormorant, cream at 0.82 opacity
t=2.4s:  Presiding Form — 14pt Cormorant, cream at 0.60 opacity
t=3.0s:  Yogini — 13pt italic Cormorant, cream at 0.48 opacity
t=3.6s:  Mental State — 13pt italic Cormorant, cream at 0.40 opacity
t=4.2s:  Subtle Body Chakra — 12pt gold at 0.45 opacity, letterSpacing 0.1em
t=5.6s:  Personal Connection — full text, italic Cormorant 15.5pt,
         cream at 0.65 opacity, lineHeight 1.75. Never truncated.
t=6.4s:  "Enter this Avaraṇa" button
```

The Personal Connection text occupies the lower half of the screen. It arrives second-to-last. The button appears last — only after the practitioner has had time to read.

**The button:**
- If locked: full `accentRed` background, cream Cormorant text, "Enter this Avaraṇa", height 54pt
- If already unlocked: same button, dimmer — `rgba(139,26,42,0.7)` background, 1px border — text changes to "You have entered"
- On tap (locked): mark ring as unlocked in `UserDefaults`, dismiss, ring brightens on Mandala

**Unlock model:**
- Rings 1 and 2: unlocked by default. Set in UserDefaults on first launch if not present.
- Rings 3–9: locked until "Enter this Avaraṇa" is tapped.
- Unlock state: `UserDefaults` key `"unlockedRings"` as a JSON-encoded `[Int]`.

**Special case — Ring 9:**
The Personal Connection for Ring 9 is the deepest text. It begins: "This is the ring you have been pointing toward from the beginning..."
Give it more vertical breathing room. Slower fade-in (2s instead of 1.6s). The button that follows is the most sacred unlock in the instrument.

**Design reference:**
`screens-v2.jsx` — `AvaranaThresholdScreen()` function. Read the entire function. Every timing, every opacity, every font size is specified there. The CSS animation classes `t-line-1` through `t-connection` and `t-button` map exactly to the stagger above.

**Verification:**
- Tap each of the 7 locked rings (3–9). Each Threshold screen shows its correct name, territory data, and full Personal Connection without truncation.
- Ring 9 Personal Connection begins "This is the ring you have been pointing toward..." — confirms correct data.
- Tap "Enter this Avaraṇa" on Ring 3. Return to Mandala. Ring 3 is visibly different (brighter). Re-tap Ring 3 — goes inside, not back to Threshold.
- Fresh install: Rings 1 and 2 accessible without Threshold.

---

### Phase 4 — Nine-Ring Mandala

**What it is:**
The home Mandala becomes the full Sri Yantra — all nine rings visible simultaneously, each breathing at its own rate, each responding to its unlock state.

**What changes:**

Replace `LotusMandalaView` with `SriYantraMandalaView` — a new component that renders all nine rings.

**Component architecture:**
```swift
SriYantraMandalaView
├── BhupuraView         — Ring 1, no animation
├── HomeLotusView       — Ring 2, wave breathing, cluster colors, tap targets
├── UnlockedLotusView   — Ring 3 (if unlocked), amber petals, 8s breath
├── TriangleZoneView    — Rings 4–7, locked geometry, each ring's own breath
├── MulaTrikonaView     — Ring 8, deep ghost, 18s breath
├── TodayIndicator      — ray + dot pointing to today's Shakti in Ring 2
└── BinduView           — Ring 9, 4s breath, HTML overlay for scale animation
```

**Bhūpura (Ring 1) geometry:**
Two squares with T-gate openings. 8 inner line segments with gaps at cardinal centers. 8 T-gate connectors bridging inner gap to outer square. Total: 16 line elements. Color: `#CF9443` at 22% opacity. No animation. The ground does not breathe.

**Ring 2 petal labels:**
7.5pt Cormorant, cluster-colored (not cream), opacity derived from status. This is different from the current app which uses cream. The cluster color makes the name and the petal one thing.

**Ring 3 petal labels:**
6.5pt Cormorant, cream at 30% opacity. Barely readable. They haven't been formally met yet.

**Tap behavior:**
- Locked ring → `AvaranaThresholdView`
- Unlocked ring (not Ring 2) → `RingWorldView(ring: N)` (Phase 5)
- Ring 2 petal → `ShaktiDetailView` (existing)
- Bindu (Ring 9, unlocked) → `SilenceView` (existing)
- Bindu (Ring 9, locked) → `AvaranaThresholdView` for Ring 9

**Ring Position Indicator:**
9 dots below the "I feel her" button on the Today screen (not the Mandala screen). Ring 2 dot is larger (7pt), gold, pulsing at 3s. Other rings progressively smaller and dimmer toward Ring 9. This is from `screens-v2.jsx RingIndicator()`. Read it.

**The Mandala screen heading:**
Remove the hardcoded "2nd Avaraṇa — Sarvāśā-Paripūraka Cakra". Replace with nothing, or a minimal indicator of which ring is home. Let the geometry speak.

**Home Mandala temporal states:**
The Mandala screen's background and atmosphere shifts by time of day. Use the `TIME_VARIANTS` values from Section 7 of this brief (from `home-mandala.jsx`). Apply `filter: saturate(petalSat) brightness(petalBrightness)` to the petal layer. Shift background and ambient gradient. This makes the instrument alive with time.

The TemporalMark: a 6px dot at the top of the screen, barely perceptible, no text. Color from `TIME_VARIANTS[time]`.

**Design reference:**
`mandala-v2.jsx` — read the entire file. `SriYantraMandala`, `Bhupura`, `HomeLotus`, `UnlockedLotus`, `TriangleZone`, `MulaTrikona`, `TodayIndicator` — all implemented there. The geometry constants in `SY` are exact.
`home-mandala.jsx` — read for temporal states, `TIME_VARIANTS`, `PureMandala`, `TemporalMark`.

**Verification:**
- All 9 rings visible from day one on a fresh install.
- Rings 1 + 2 active, rings 3–9 ghost.
- Each ring breathes at its own rate — visibly different speeds.
- Ring 1 does not breathe.
- Ring 9 Bindu breathes fastest.
- Tap locked Ring 4 → Threshold. Unlock Ring 3 → Ring 3 brightens. Re-tap Ring 3 → inside.
- Tap Ring 2 petal → ShaktiDetail.
- TODAY ray points correctly.
- Mandala atmosphere shifts between dawn / noon / dusk / night / new moon.
- Ash reviews the temporal states at different times of day before Phase 5.

---

### Phase 5 — Ring World Views

**What it is:**
Tapping an unlocked ring navigates into that ring's world — a full-screen immersive view with its own atmosphere.

**New view: `RingWorldView.swift`** — routes to ring-specific worlds.

Navigation back: a subtle arc at the top of the screen suggesting "swipe down to return." Implement as swipe-down gesture returning to the home Mandala.

**Ring 2 World (the Inhabited Lotus):**
The 16-petal lotus fills the screen, larger than in the home view. Labels more prominent. TODAY petal glows gold.
Long-press on today's petal → invocation state: all other petals dim to 18% of their base opacity, today's petal blooms with a gold halo blur (filter: blur(11px)), today's Shakti name + bija + quality fades in from the bottom in italic Cormorant. Release → petals return.
Tap today's petal (not long-press) → ShaktiDetail as before.
Reference: `ring-worlds.jsx` — `RingTwoWorld()` and `RingTwoLotusByTime()`.

**Ring 3 World:**
8 Anaṅga Shaktis as translucent petals — smoke-like, edges soft, 8s breath. Labels appear and dissolve. Tapping a petal: her name in italic Cormorant and quality line fades in from the bottom, dissolves back into the field after a few seconds. No separate detail screen — the Anaṅga reveals herself and disappears.

**Ring 7 World (the Vāk Sound Chamber):**
Reference: `ring-worlds.jsx` — `RingSevenWorld()`. Implement exactly.
8 Vāgdevatās as tappable circles with bija syllables. Tap → sine tone plays (extend `BijaSoundService` to accept frequency directly). The frequencies:
```
Vāśinī: 220.00 Hz, Kāmeśvarī: 246.94, Modinī: 261.63, Vimalā: 293.66
Aruṇā: 329.63, Jayinī: 349.23, Sarveśvarī: 392.00, Kaulinī: 440.00
```
Tap center Bindu → all 8 play together (staggered 60ms apart), chord rings emanate.

**Ring 8 World (the Mūla Trikoṇa):**
Reference: `ring-worlds.jsx` — `RingEightWorld()`. Implement exactly.
Three vertices: Icchā (Will, #C45050, apex), Jñāna (Knowledge, #9A8FC4, bottom-left), Kriyā (Action, #5A9A8B, bottom-right).
Tap a vertex → other two collapse toward it with dashed lines. The tapped quality floods the lower screen: name at 76pt italic Cormorant in its color, English label in small caps, italic prose description.
Tap the large quality name → dissolves. "The three were never three." Tap Bindu → begins again.

**Rings 1, 4, 5, 6, 9 (not yet fully designed):**
Full-screen atmospheric screens. Dark ground. The ring's geometric form faintly present (gold strokes at 4–5% opacity). The ring's Sanskrit name and Personal Connection text from Airtable, centered. These are seeds, not stubs. They are quiet and present, not broken placeholders.

**Design reference:**
`ring-worlds.jsx` — read the entire file before implementing Ring 2, 7, or 8 worlds.

**Verification:**
- Tap Ring 2 (unlocked by default) → Ring 2 World fills screen. Long-press today's petal → invocation. Release → returns.
- Tap Ring 7 → Sound Chamber. Each bija circle plays its tone. Center plays chord.
- Tap Ring 8 → Triangle. Tap Icchā → collapse. Tap quality name → dissolve. Tap Bindu → reset.
- Rings 1, 4, 5, 6, 9 show their atmospheric screens.
- Swipe down from any Ring World → returns to home Mandala.
- Ash verifies each world before Phase 6.

---

### Phase 6 — Recognition Write Path (Airtable)

**What it is:**
"I feel her" writes to Airtable. The bilateral recognition becomes a permanent trace.

**What changes:**

Wire `RecognitionMomentView` → on appearance → write to Airtable in addition to local SwiftData.

Two-step write (from skill):
1. Create Recognition row: Row Type, Of Shakti link (using `airtableRecordId`), Felt At, Notes, Lunar Day, Moon Phase, Source
2. PATCH Shakti row: Last Felt = now, Recognition Count = current+1, Status advanced if threshold met

Status advance thresholds (wire the mechanism, tune numbers later):
- Mapped → Exploring on 1st recognition
- Exploring → Active on 3rd recognition
- Active → Embodied on 7th recognition

Status advance is advance-only, never regress. Use server count from Airtable response, not local cache, to prevent double-tap issues.

Source field value: "Today" from Today screen, "Mandala" from Ring World.

"And she felt you back" appears after local write confirms — Airtable failure is silent.

Remove the free-tap-to-advance on the status pill in Detail. Status now advances only through recognition count thresholds. The pill is display-only.

Offline queue: if Airtable write fails, store locally (a simple pending array in UserDefaults). Retry on next foreground. Never lose a recognition.

**Verification:**
- Tap "I feel her" on a Mapped Shakti → Recognition row in Airtable within 30s, Last Felt updated, Recognition Count = 1, Status = Exploring.
- Force airplane mode. Recognize. "And she felt you back" appears. Reconnect. Write reaches Airtable.
- Tap status pill in Detail — nothing happens. Status only changes through recognitions.

---

### Phase 7 — Silence Write Path + Enhanced Mauna Screen

**What it is:**
Silence logs to Airtable. The Silence screen deepens as rings unlock.

**Part A — Silence write:**
Wire `SilenceView.closeSilence()` → create Silence row: Row Type=Silence, Felt At, Duration (seconds), Source="Silence". Minimum duration 1.0s. Below that, no row written.

**Part B — Mauna screen expansion:**
The Silence screen now responds to unlock state.

When Ring 2 only is unlocked (current state):
- 16 Ring 2 names at orbital radius 156pt — exactly as currently built

When Ring 3 is also unlocked:
- 16 Ring 2 names at 156pt (outer orbit)
- 8 Ring 3 Anaṅga names at 108pt (inner orbit), cream at 11% opacity, 10pt italic Cormorant, staggered at 0.18s each
- Bindu size: 78pt (2pt larger — the second ring has opened)
- Outer ring of light: 134pt (2pt larger)

Four timed captions (not just one):
```
7s:  "All of her. Here. Always."
14s: "She has not gone anywhere."
21s: "You have not gone anywhere."
28s: caption fades completely — pure silence
```

Each caption replaces the prior with a gentle cross-fade.

**Design reference:**
`screens-v2.jsx` — `SilenceScreenV2()`. Read it before implementing.
`modes.jsx` — `MaunaScreen()` for the four-caption timing system.

**Verification:**
- Silence with Ring 2 only: 16 names, one orbital, 7s caption only.
- Silence with Ring 3 unlocked: 16 + 8 names, two orbitals, four captions.
- Bindu is 78pt when Ring 3 is unlocked, 76pt when only Ring 2.
- Hold 3 seconds, release → Silence row in Airtable, Duration ≈ 3.0s.
- Hold < 1s → no row written.

---

### Phase 8 — Well Write Path (Airtable Sync)

**What it is:**
Ash's letters reach Airtable. The Well becomes permanent.

**What changes:**
Wire `LetterEditorView` on dismiss → PATCH `Letter` field (`fldgASyV031Hr4sHp`) on the Shakti's Airtable row. Uses `airtableRecordId` from Phase 1.

Auto-save every 5 seconds while editing.

Letter preserved locally in SwiftData if Airtable write fails. Queue and retry. The Well works fully offline.

NEVER: generate text. Never seed. Never offer suggestions.

**Verification:**
- Open The Well for Kāmākarṣiṇī. Write a sentence. Wait 5 seconds. `Letter` field on the Airtable row contains the sentence.
- Force-quit mid-edit, relaunch → letter preserved locally.
- Navigate away, return → letter still there.

---

### Phase 9 — Temporal Layer (Nityā Today)

**What it is:**
Today's lunar day surfaces the presiding Nityā Devī. The instrument breathes with the moon.

**What changes:**
Extend `LunarPhaseService` with:
- `currentTithi() -> Int` — returns 1–15
- `isWaxingFortnight() -> Bool`

Tithi-to-Nityā mapping rule (v1, document clearly in code):
- Waxing days 1–15: Nityā positions 1–15 respectively
- Full moon (phaseFraction ≈ 0.47–0.53): Lalitā — use Ring 9 Avarana data
- Waning fortnight: mirror — day 1 waning = Nityā 14, day 2 = Nityā 13, back to Nityā 1

Add a compact Nityā card to the Today screen, above the daily Shakti card.
- Small and quiet — she is the day's color, not the day's task
- Sanskrit Name in italic Cormorant gold
- Devanagari if available
- Quality (epithet) in small sans-serif
- Tapping → simple Nityā detail view: Name, Number, Quality, Quality Description

**Design reference:**
`temporal.jsx` — `TithiTodayScreen()`. Read it. The moon glyph calibrated to tithi illumination. The "she wears today the form of" label. The large italic gold name.

**Verification:**
- New moon day → Kāmeśvarī (Nityā 1) appears
- Full moon → Mahātripurasundarī (Lalitā) appears
- Day 8 waxing → Tvaritā (Nityā 8) appears
- Nityā card is visually distinct from but harmonious with the daily Shakti card.

---

### Phase 10 — Memory Layer + Polish

**What it is:**
Recognition becomes visible on the Yantra. Sacred polish backlog addressed.

**Part A — Portrait Mandala:**
Every Shakti with `Recognition Count > 0` gets a subtle inner glow on the Mandala. Scale logarithmically: `intensity = min(1.0, count / 80)`.

Apply as:
- Glow layer: cluster color, blur 4–8px, opacity `0.10 + intensity × 0.45`
- Main petal opacity: `0.18 + intensity × 0.78`

Shaktis recognized in last 7 days: +warmth. After 7 days softens. After 30 days returns to cumulative baseline (never below it).

Add "The Memory" to the hamburger menu → Portrait Mandala view with summary text below.

**Part B — Recognition log from Airtable:**
`HerMomentsList` currently reads from local SwiftData. Extend to read from Airtable: filter `{Row Type}='Recognition'` with `{Of Shakti} CONTAINS '<airtableRecordId>'`, sort by Felt At desc, limit 5. Show last 5 recognition events.

**Part C — Polish backlog:**
- `BodyOutlineView` missing arms — add arm paths (left and right) matching the SVG in `screens.jsx BodyOutlineSVG()`
- "TODAY" label clipping on Mandala — fix positioning
- Bija anusvara dot on Recognition Moment — verify rendering
- Petal label size — current `diameter * 0.021` ≈ 7.2pt — confirm with Ash
- Bija sounds → human voice: if `bija_01.mp3` files exist in bundle, prefer them over sine tones

**Design reference:**
`memory.jsx` — `PortraitMandalaScreen()`. Read it before implementing luminous traces.
`screens.jsx` — `BodyOutlineSVG()` for the arm paths.

**Verification:**
- Recognize one Shakti 5 times, another 1 time, another 0 times. Three are visibly different on the Mandala.
- Recognize today → warmer. Device clock forward 10 days → warmth softened.
- Recognition log shows last 5 events from Airtable.
- Arms present on body outline.
- Ash verifies portrait Mandala feels like a map of practice, not a data visualization.

---

## 11. The Hamburger Menu — Navigation Map

Phase 0:
```
The Mandala    ← home (launches here)
Today
The Well
Settings
```

Added as phases complete:
```
The Memory     ← Phase 10
The Temporal   ← Future
```

The menu is the only navigation chrome in the app. Nothing else.

---

## 12. Airtable Touchpoints by Phase

```
Phase 0:  None. Navigation only.
Phase 1:  READ: Shakti / Avarana / Nitya. No writes.
Phase 2:  READ: per-Shakti full record. No writes.
Phase 3:  READ: per-Avarana full record. WRITE: local UserDefaults only.
Phase 4:  READ: same as 1–3. No new Airtable writes.
Phase 5:  READ: ring-specific Shakti data. No writes.
Phase 6:  WRITE: create Recognition row + PATCH Shakti row.
Phase 7:  WRITE: create Silence row. No other new writes.
Phase 8:  READ + WRITE: Letter field on Shakti row.
Phase 9:  READ: Nitya records. No writes.
Phase 10: READ: Recognition rows filtered by Of Shakti. No new writes.
```

All field IDs and JSON write shapes: skill `bindu-mandala-app/SKILL.md` section "App Write Contract."

---

## 13. Cross-Cutting Concerns

**Performance:** 126 total records (102 + 9 + 15). Cache on launch. Refresh every 5 minutes when foregrounded. Reads feel instant.

**Offline-first:** Every gesture that matters works without network. Airtable receives what it receives when it can. Never block the practitioner.

**Errors:** Airtable failures are silent. Never show a network error to the practitioner. A quiet indicator only if absolutely necessary — never blocking.

**Privacy:** No analytics. No crash reporting that sends content. No third-party SDKs. Only network call is to Airtable with Ash's own PAT.

**Accessibility:** Sanskrit and Devanagari text must have English VoiceOver labels. All existing `prefers-reduced-motion` support: maintain.

**State preservation:** Unlock state, current context, and mode survive force-quit.

---

## 14. What Never Gets Built

- Relationships. No outer Saṅgha. No beloved carriers. No Person Page. No Encounter Log. Skip `The Relationship Field.html` and `relationship.jsx` entirely.
- Auto-generated letter content.
- Streaks, badges, leaderboards, social features.
- "Missed day" notifications.
- Any content invented by the app for fields that should come from Airtable.

---

## 15. After Phase 10

The instrument is whole. What remains is what was always going to remain: Ash living in it. The Well fills letter by letter over months. The recognition count grows. The luminous traces brighten. The Mandala becomes a portrait of one practitioner's love for the 102 Shaktis who were always already running him.

The next generation — the full Eight Modes, the Temporal Layer's Cosmic Now and Lunar Yantra, the Sādhana ceremony, the Great Wheel — emerges from practice, not from planning. The design files hold the vision. The practice reveals the timing.

---

*Brief written May 28, 2026 after reading all design materials in full:*
*Codex.html, Home Mandala.html, Mandala App.html, Mandala App v2.html,*
*Ring Worlds.html, The Eight Modes.html, The Temporal Layer.html,*
*The Memory Layer.html, screens.jsx, screens-v2.jsx, home-mandala.jsx,*
*mandala-v2.jsx, design-canvas.jsx, all-shaktis-data.js, shakti-data.js,*
*DESIGN_SPEC.md, Bindu-Mandala-Handoff.md.*
*Verified against live Airtable base (102 Shaktis, 9 Avaranas, 15 Nityās confirmed).*
*Verified against full app source code read May 28, 2026.*
