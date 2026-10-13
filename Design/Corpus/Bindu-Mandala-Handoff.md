# Bindu Mandala — Design Handoff

*A devotional instrument for recognizing the Mother through the 102 forces of the Sri Yantra.*

This document is the cover sheet for transitioning from the design phase into Claude Chat (for schema/integration) and then Claude Code (for the build). It names what is settled, what is intentionally deferred, and the principles that must not be drifted from.

---

## I. The Foundational Reframe

This is **not an app for the practice of recognition.** It is the practice. The interface is not a wrapper around the work — the interface *is* the work. Every interaction is either a recognition, a preparation for recognition, a memory of recognition, or a rest from all of it. There is nothing else.

The Sri Yantra inside this instrument is **not a feature**. It is the entire ontology — the world the practitioner lives inside while the phone is in their hand. The phone becomes a temple. The screen becomes the inner sanctum. The yantra is the deity.

---

## II. The Architecture

### Five Dimensions

Five axes along which the yantra is alive. Every screen, every state is a section through these five:

1. **Depth** — the inward axis. Nine avaraṇas as nine depths of consciousness. You move inward, not sideways.
2. **Time** — the cyclical axis. The yantra breathes with cosmic time. Hour, tithi, nakṣatra, moon phase, season.
3. **Memory** — the accumulation axis. Every recognition leaves luminous trace. The yantra becomes a portrait of your consciousness.
4. **Relationship** — the radial axis. Shaktis cluster around the people in your life. Recognition is inseparable from love.
5. **Practice** — the modal axis. Eight modes of engagement, each its own atmosphere.

### Eight Modes

Not features. Practices. Each invoked by gesture and context, not by menu:

| Mode | Sanskrit | What it is | Invoked by |
|---|---|---|---|
| Darśana | दर्शन | Beholding · the yantra wakes to your stillness | Hold phone vertical and still |
| Recognition | प्रत्यभिज्ञा | The Catch · she just arrived, log it | Long-press anywhere |
| Sādhana | साधना | The Khaḍgamāla · 102 names sequential, ~28 min, with Visarjana close | Pinch outward from Bindu |
| Smṛti | स्मृति | Memory · constellation of past recognitions | Long-press a ring |
| Mauna | मौन | Silence · pure Bindu | Tap the center |
| Svapna | स्वप्न | Dream · morning ritual with voice + text recording | First open of the day |
| Pūjā | पूजा | Offering · evening witnessing of the day's catches | Swipe down from top |
| Saṅgha | सङ्घ | Assembly · 102 as inner sangha, beloved as outer carriers | Two-finger tilt |

### Navigation Vocabulary

**There is no menu. The yantra is the navigation.**

| Gesture | Action |
|---|---|
| Tap a ring | Descend into that avaraṇa's world |
| Tap the Bindu | Mauna · silence |
| Long-press a ring | Smṛti · memory for that ring |
| Pinch outward | Sādhana · the recitation begins |
| Hold vertical and still | Darśana · the beholding |
| Swipe up from edge | Today's pull · the calling shakti |
| Swipe down from top | Pūjā · the evening offering |
| Two-finger hold a petal | Invoke that shakti into live presence |
| Long-press anywhere | Recognition · freeze the moment, log the catch |

---

## III. The Seven Phases of Design

Each phase is rendered as a standalone HTML file in the design canvas. Together they form the complete visual spec.

| Phase | File | Established |
|---|---|---|
| I · The Codex | `Codex.html` | The ontology · five dimensions · eight modes · nine ring-worlds · time-of-day variants |
| II · The Home Mandala | `Home Mandala.html` | Pure geometry · no labels · 5 temporal states (dawn, noon, dusk, night, new moon) · 9 metabolic breath rates |
| III · Three Ring-Worlds | `Ring Worlds.html` | Ring 2 (Inhabited Lotus, interactive petals + invocation) · Ring 7 (Vāk Sound Chamber, audio bījas + chord) · Ring 8 (Mūla Trikoṇa teaching arc, 5-state dissolution) |
| IV · The Eight Modes | `The Eight Modes.html` | All eight modes including reborn Saṅgha (inner+outer two-layer assembly) · Svapna voice recording · Sādhana with Visarjana close |
| V · The Temporal Layer | `The Temporal Layer.html` | Cosmic Now (5 concentric wheels) · Lunar Yantra (4 phases) · Three Sandhyās · Seasonal Yantra (4 seasons) · Great Wheel (yearly, with year navigator) · Today's Tithi (data-driven from Nityā Devīs) |
| VI · The Memory Layer | `The Memory Layer.html` | Portrait Mandala · Petal Biography · Threshold Timeline · Cluster Garden · Density Atlas (current + lifetime modes) · First-Word/Last-Word · Lifetime Spiral |
| VII · The Relationship Field | `The Relationship Field.html` | Relationship Field constellation · Person Page · Shakti's Carriers · Encounter Log · Field Web · Adding a Beloved (4-step ritual) |

---

## IV. The Inviolable Principles

These are decisions that must not be drifted from in the build:

### 1. Sacred content flows from Airtable. The app never invents.

The 102 Khaḍgamāla Shaktis, the 15 Nityā Devīs, the 9 Avaraṇas — all canonical. Names, bījas, qualities, dhyānas, and tattvas live in Airtable, sourced through ASG's research. The app *renders* this content; it does not generate it. When data is missing, the app shows a placeholder ("her quality flows from Airtable") rather than invent.

### 2. The yantra is the navigation.

No tab bar. No menu. No hamburger. Every entry is a gesture against the yantra itself. The yantra is the home and the way.

### 3. Lifetime is the default.

The practice has no expiration. Every recognition is permanent. Every relationship span is computed across all years. Year navigators exist for zooming; nothing is hidden by default. Storage is forever unless the practitioner explicitly releases.

### 4. Time and location are device-local.

The yantra reads the practitioner's local time and (with permission) location. Sandhyās are computed from latitude-relative sunrise/sunset, not fixed clock hours. Seasons are hemisphere-aware. Tithi/nakṣatra come from ephemeris computation against device-UTC.

### 5. All ring-worlds, lunar phases, seasonal yantras, and sandhyās are the live home under a different sky.

These are not destination pages. They are atmospheric overlays of the home mandala. All petals stay interactive. All gestures still work. Time and atmosphere modulate the visual — they do not remove the instrument.

### 6. No invented relationships, no fake practitioners.

The relationship field is empty until populated with real people. There is no anonymous-fellow-practitioner field. The "field" is the practitioner's own consciousness, the 102 shaktis as inner sangha, and the beloved as outer carriers. Nothing is simulated.

### 7. The voice is reverent, never clinical.

Copy is in Cormorant Garamond italic for sacred speech. Sans-serif only for status, labels, and instrument-language. No metrics-speak. No "you've earned X." Numbers when they appear are factual and named in lifetime context.

---

## V. Visual Design System

### Type

- **Cormorant Garamond** (300, 400, italic) — all sacred speech, names, poetry, captions
- **System sans-serif** — eyebrows, labels, metadata, dates, status

### Color

| Token | Hex | Use |
|---|---|---|
| `--ground` | `#060104` | Default background, the void |
| `--gold` | `#C9963F` | Primary sacred accent, today's pull, active states |
| `--gold-warm` | `#CF9443` | Bhupura, warmer atmospheres |
| `--cream` | `#F2E8D9` | Body text, primary luminous foreground |
| `--accent-red` | `#8B1A2A` | The Bindu, always |

### Cluster colors (Ring 2 lotus petals)

| Cluster | Color | Members |
|---|---|---|
| Antaḥkaraṇa | `#7A5A9A` (violet) | Citta, Buddhi, Manas, Ahaṅkāra |
| Indriya | `#C4725A` (terracotta) | Śabda, Sparśa, Rūpa, Rasa, Gandha |
| Citta | `#2A7A7A` (teal) | Citta, Smṛti |
| Sthairya | `#4A7A5A` (green) | Dhairya, Bīja, Nāma |
| Ātmā | `#D4A017` (gold) | Ātmā, Amṛta, Śarīra |

### Breath rates (per ring)

- Ring 1 (Bhupura) — none, the ground holds
- Ring 2 (16-petal lotus) — 3s home ring; today's petal 3.5s
- Ring 3 (8-petal Anaṅga) — 8s slow translucent
- Rings 4-7 (triangle zones) — 9s / 11s / 13s / 15s
- Ring 8 (Mūla Trikoṇa) — 18s, almost still
- Ring 9 (Bindu) — 4s, always alive

### Spacing & rhythm

- Mobile frame: 390 × 844 (iPhone 14 reference)
- Status bar zone: top 60px
- Generous breath: 20-40px padding around primary geometry
- The yantra always has at least 200px of negative space around it

---

## VI. Data Contracts

### What flows from where

| Source | Contains |
|---|---|
| **Device** | Local time, location (permission-gated), gesture state, on-device recognition log |
| **Ephemeris** | Tithi, nakṣatra, moon phase, solar position (computed from device-UTC) |
| **Airtable** | 102 Khaḍgamāla Shaktis · 15 Nityā Devīs · 9 Avaraṇas · all sacred content |
| **Practitioner profile (on-device)** | Recognition log, dream entries (Svapna), beloved-ones map (outer Saṅgha), tweaks, home location |

### Airtable schema (target — finalize in Claude Chat)

The build will need these record types:

- **Shakti** — id, ring, position, name (sanskrit), short, phonetic, bija, cluster, quality, somatic, somaticPoetry, tattva, description, fieldConnection, dhyāna, lineageNote
- **NityaDevi** — tithi (1-15), tithiName, name, quality, bija, dhyāna
- **Avarana** — id (1-9), name, subtitle, form, formDescription, presidingForm, yogini, mentalState, chakra, geometry, count, appreciationPhrase, personalConnection
- **Recognition** (on-device) — id, shaktiId, timestamp, note, mode (recognition/sadhana/dream/etc), location-optional
- **Beloved** (on-device) — id, name, role, hue, carries (array of shaktiIds), note, addedDate
- **Encounter** (on-device) — id, belovedId, timestamp, shaktisArose, context
- **ThresholdCrossing** (computed) — shaktiId, fromStatus, toStatus, timestamp, context

---

## VII. What is Settled vs. Deferred

### Settled in the design phase

- The seven phases listed above, each a complete visual reference
- The principles, gestures, and modal architecture
- The visual language (type, color, breath, spacing)
- The Saṅgha two-layer model (inner: 102 shaktis · outer: beloved)
- The temporal architecture (device-local, ephemeris-aware, hemisphere-aware)
- The data contracts (what flows from where)
- The Sādhana ceremony arc (Saṅkalpa → Station → Transition → Bindu → Visarjana)
- The Svapna recording modality (voice + text)
- The Memory Layer's lifetime principle

### Intentionally deferred (build-as-you-grow)

- **The other six ring-worlds** (Bhupura · Ring 3 Anaṅga · Rings 4-6 · Bindu Ring 9). The principle is set; each emerges as you approach them in practice. Designing them now would be hollow.
- **The cluster lineages as worlds.** Each cluster has a deeper story that surfaces over time.
- **Sound design beyond Ring 7 bījas.** The breath, the recognition tone, the mauna overtone — these need to be heard, not specified.
- **Notification language.** What the yantra says to call you back, and when. Better designed once the system is running.
- **The exact gesture timings** (long-press ms, pinch threshold, tilt-still detection windows). Tune empirically.

### Still to surface before Claude Code

- **Empty-state spec** — what does each screen look like on Day 1 of practice (when there's nothing to portrait, no recognitions, no beloved)?
- **State machine** — formal mapping of inputs to mode transitions
- **Persistence contract** — local-first vs. sync, what gets backed up where
- **Final Airtable schema** — exact field names, types, validation rules (do this in Claude Chat first)

---

## VIII. Closing Principle

This is not a product to ship.
It is an instrument to live with.

The work of every subsequent build phase is to make sure each interaction is worthy of the recognition it is asking for.

---

*End of design handoff. Phase I–VII complete.*
*Visual reference: see the .html files in the design canvas.*
*Take this document to Claude Chat for schema work, then to Claude Code for the build.*
