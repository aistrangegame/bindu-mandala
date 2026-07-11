# Bindu Mandala — Final Build Handoff

**For:** Claude Code
**Repo:** `aistrangegame/bindu-mandala` · branch `main` · iOS / SwiftUI + SwiftData
**Practitioner:** Single — this is Ash's own instrument, built around his field (Gaia / Ashrey / Ram). Not a multi-user product. Design every decision for *one* person's years-long practice.
**Governing idea:** *Time is the medium.* Turn the app from a thing you open into a practice you are inside of.
**Governing rule:** *Readiness is sensed; crossing is always chosen.* The app may notice when a Śakti has ripened or a ring is ready — but the practitioner always makes the deliberate gesture. **Never auto-advance.**

> **This document supersedes** `Bindu Mandala - Claude Code Brief.md`, `Bindu-Mandala-Handoff.md`, and `Bindu-Mandala-Handoff-II.md`. Where they conflict, this wins. It folds in their still-valid phase work and adds the one thing they lacked: a **reference prototype** that now demonstrates the Daily Rite, the Detail screen, the recognition ceremony, and the whole living Mandala — as running, inspectable code.

---

## 0 · How to read this brief

There are now **two artifacts** in play:

1. **The native app** — `iOS/Bindu Mandala/` (SwiftUI + SwiftData). What ships. Partly built.
2. **The reference prototype** — `Bindu Mandala - The Living Rite.html` + its `living-rite-*.jsx` modules. A complete, interactive React model of the *intended* experience. **This is the design source of truth for everything in §2.** Open it, tap through it, read its modules — it encodes hundreds of small decisions (composition, timing, easing, atmosphere) that prose can't carry.

Work **§2 → §3 top to bottom**. §2 is the vision made concrete; §3 is the ordered build path. Each task carries **Files**, **Change**, **Why**, and **Done when**. When a code sketch and the principles conflict, the principles win. When you must invent, invent *toward the governing idea.*

---

## 1 · Operating principles (the bar)

Every change is held to these. They break ties.

1. **The interface *is* the teaching.** An interaction embodies what a thing *is*; it is never a screen of information *about* it. The Veil is an āvaraṇa. The descent is a descent. If a feature explains rather than enacts, redesign it.
2. **Atmosphere, not page.** Dark ground, warm light from within, dust motes, generous negative space, one quiet identity line. Ride the existing tokens (`Color.ground`, `.gold`, `.cream`, `.accentRed`, the five cluster colors). **Never introduce a new color.**
3. **She is felt, not measured.** No streaks, no scores, no badges, no progress bars, no nags. Counts may exist *only* to sense readiness — never displayed as achievement. The recognition log is a private archive: never synced, never analyzed.
4. **Readiness is sensed; crossing is chosen.** Applies identically to status advancement and to descent crossings.
5. **The floor.** Every tap target **≥ 44pt**. Any text meant to be *read* **≥ 11pt and ≥ 0.3 alpha**. Below that is *texture* — a deliberate decision, never an accident of scale.
6. **Respect the breath.** Honor `prefers-reduced-motion` / `accessibilityReduceMotion` everywhere. Persist state so a refresh/relaunch never loses the practitioner's place.

---

## 2 · The reference prototype — what to port, and how

The prototype loads eight modules. Read them in this order:

| Module | Owns |
|---|---|
| `living-rite-core.jsx` | **The engines.** Palette derivation, atmosphere, time-of-day, day cycle, moon, composition/archetype, recognition responses, audio, shared atoms. Everything else consumes it. |
| `living-rite-today.jsx` | The Daily Rite surface — the six element archetypes. |
| `living-rite-detail.jsx` | Her Presence (detail) + the embodiment track + the recognition ceremony. |
| `living-rite-mandala.jsx` | The Śrī Yantra — semantic zoom, constellation threading, the Bindu → Lalitā descent, ring-entry chimes. |
| `living-rite-field.jsx` | The Field (102), The Well (archive), The Memory (Portrait), the menu. |
| `living-rite-more.jsx` | Ring thresholds + the letter/note composer. |
| `living-rite-app.jsx` | Root router + nav persistence (`lr_nav`). |
| `ios-frame.jsx`, `tweaks-panel.jsx` | Device chrome + the tweak panel (prototype-only; do not port). |

**The single most important idea to carry over:** *nothing in this app is a static screen.* Every surface is **generated from the Śakti herself** — her ring, cluster, tattva/element, and the hour of day. The same practitioner meeting two different Śaktis, or the same Śakti at dawn vs. night, should get visibly different screens. §2.1–2.4 are how.

### 2.1 — The atmosphere engine  *(port to `Theme/Atmosphere.swift`, new)*

`lrAtmosphere(s)` (core.jsx ~L208) is the heart. For any Śakti it derives a full atmosphere from **one hue seed**:

- **Seed hue:** Ring 2 Śaktis take their cluster hue (`LR_CLUSTER_HUES` — inner/tanmatra/… five families); all other rings take a per-ring hue (`LR_RING_HUES`). A small deterministic jitter (`lrJitter(kp, 14)`) rotates each sister's hue slightly so siblings in one family still differ.
- **Element:** `lrElement(s)` — Ring 2 from her `tattva`; other rings from `LR_RING_ELEMENTS` (`1:earth, 3:air, 4:water, 5:fire, 6:ether, 7:air, 8:fire, 9:light`).
- **Derived stops:** from the seed it computes `glow`, `ground`, `groundDeep`, `accent`, `accentBright`, `accentSoft`, `accentFaint` — a whole coherent palette per Śakti, all still inside the token family.

**Why:** this is what makes 102 energies feel like 102 *presences* without authoring 102 backgrounds. In SwiftUI, model it as a `struct Atmosphere` with a static `derive(from: Shakti, at: TimeVariant)` — pure, deterministic, testable. Everything (Today, Detail, Mandala, Portrait) reads its ground/glow/accent from here. **Do not hand-pick colors per screen.**

`lrBackdrop(atmo)` (core.jsx ~L354) then places the light: each element puts its glow in a different region (fire low, water pooled, air high-asymmetric, ether pervasive, earth grounded, light central). Port as a `backgroundGradient(for:)` switch on element.

### 2.2 — Time-of-day relighting  *(port into `Atmosphere` + a `TimeVariant`)*

`LR_TIME_VARIANTS` + `lrApplyTime(atmo, tv)` (core.jsx ~L164) re-light the *same* Śakti by the hour — **dawn** warms & violets, **noon** clarifies & cools, **dusk** deepens & enriches, **night** pulls dark & saturated. Each variant shifts hue, luminance, saturation, glow, ground tint, and mote density. Auto-selected from `Date` (`dawn 5–9, noon 9–16, dusk 16–20, night else`); overridable.

**Why:** the field is alive with the day. The app you open at 6am and return to at 10pm should feel re-lit, not reloaded. The repo already has `TimeVariant.swift` — extend it to feed `Atmosphere`, and thread it through *every* atmosphere consumer, not just the Mandala.

### 2.3 — The day cycle + moon  *(reconcile with existing lunar assignment)*

- `lrTodaysShakti()` (core.jsx ~L256) is a **deterministic seeded shuffle** of the 102 (`lrSeededShuffle`), walking a new Śakti each practice-day (`lrPracticeDayIndex`, day boundary shifted −6h so the rite belongs to the pre-dawn). The native app already has a lunar-day assignment — **keep the native one**; the prototype's shuffle is only a stand-in. What matters is that Today draws from it and is scoped to rings descended into (see §3 Descent).
- `lrMoon()` (core.jsx ~L269) computes phase fraction + tithi + nityā from the synodic month. The `LrMoonGlyph` atom draws the lit fraction. Match the native moon math to this if they diverge.

### 2.4 — The six Today archetypes  *(port to `Views/Today/DailyRiteView.swift`)*

This is the session's biggest single advance and the clearest "interface *is* the teaching." Her **element selects one of six compositions** (`LR_ARCHETYPE_BY_ELEMENT`, core.jsx ~L317); `lrComposition(s)` then adds deterministic per-Śakti variety (lean direction, sigil spin/scale, name tier, gradient angle) seeded from her `kp`:

| Element | Archetype | The screen *becomes* |
|---|---|---|
| **fire** | ascension | she rises — bīja column climbs, name low-center, updraft motes |
| **water** | descent | she settles — name high, prompt pools low, cool floor |
| **air** | horizon | she drifts — asymmetric, name leans off-axis, offset sigil + horizon line |
| **ether** | veil | she pervades — her name *is* the vast backdrop, prompt afloat, the whole screen is the door |
| **earth** | foundation | she grounds — wide low sigil base, centered and stable |
| **light** | radiance | she is the point — name held *inside* a dominant living sigil |

`living-rite-today.jsx` renders each via a shared block list (`plan.order.map(TdBlock)`) so the *elements* (name, phonetic, quality, hairline, somatic prompt, bīja, sigil) are constant but their **arrangement, alignment, scale, and motion** are archetype-driven. The `TdSigil` component places her ring's geometry differently per archetype (bottom / bottomWide / centerBig …) and spins it slowly.

**Why:** a fire Śakti and a water Śakti should not be the same layout re-skinned — the composition should *enact* her nature. **Port the six archetypes as six SwiftUI layout branches** off `atmosphere.element`, sharing one content model. Use the size scale from `DESIGN_SPEC.md` (name 44–48, quality 20–22, somatic 18–20). The one full-width gesture pill — **"I feel her"** — is constant across all six.

### 2.5 — The Detail screen + embodiment track  *(port to `ShaktiDetailView.swift`)*

`living-rite-detail.jsx` leads with the **soul** — her name, quality, somatic line, her ring's geometry as a slow-spinning hero backdrop (element-lit) — then:

- **The embodiment track** — a four-node progression **Mapped → Exploring → Active → Embodied** (`LR_STATUS`, core.jsx ~L551). Readiness is *sensed* from her felt-count against `LR_STATUS_THRESH = [0,1,3,7]` (`lrReachedIndex`); **crossing is a deliberate press-and-hold**, persisted per-Śakti (`lrCrossLevel`/`lrSetCrossLevel`, keyed by `kp`). This is the governing rule made physical. Native: store the crossed level on the Śakti (or a small `EmbodimentState`), sense readiness from `RecognitionEntry` count, cross by a held gesture with a soft haptic and a held beat.
- **The bīja** — a tappable syllable that *sounds her* (§2.7 audio). Below the fold, so the soul leads.
- **"go deeper"** — a single disclosure that collapses all reference matter (lineage, cosmic function, tattva, iconography, etymology) behind one tap. Lead with the soul; hide the encyclopedia.
- **"I feel her"** — opens the recognition ceremony (§2.6).

### 2.6 — The recognition ceremony  *(port to a takeover / `RecognitionMomentView`)*

Tapping **"I feel her"** is not a toast — it's a full-screen takeover that *responds in her nature* (`LR_RECOG`, core.jsx ~L344). The focal point, ripple manner, and her "response" animation are **element-specific**: fire flares upward, water pools, air disperses, ether blooms once, earth settles slow, light radiates. Sequence:

1. Her name + her `recognitionPhrase`, timestamped — *"She was felt here · [time]."*
2. A held beat, then reciprocity — *"and she felt you back · [time]."*
3. A quiet **"What did you notice?"** note field (optional, never required; persisted per-moment). Tapping it must not dismiss.
4. On close, the moment **collapses inward** (`lrCollapse`) and settles — continuous with the Portrait lighting one more point.

Native: this writes a `RecognitionEntry(gesture: .felt)` at the **global 1–102 position** (see §3 Phase 2), local-only, never synced.

### 2.7 — The living Mandala  *(port to `SriYantraMandalaView.swift` + descent views)*

`living-rite-mandala.jsx` is one continuous space with **semantic zoom** across three depths — **cosmic** (the whole instrument: bhūpura square, gates, all 102 seats breathing), **mid** (a ring resolves, names surface), **seat** (one Śakti, her meaning blooms). Four capabilities to carry:

- **Fly-to-seat.** Tap any seat → the camera flies in, her card blooms. Every gesture is guarded by a shared `moved` flag so a pan/pinch can never misfire as a tap.
- **Constellation threading.** Selecting a Śakti threads animated lines from her seat to her **family** (Ring 2 gathers by cluster; every other ring is its own āvaraṇa family). Family lights in her color and names itself; everyone else dims to ~28% and quiets. The card names the bond ("threaded to N sisters · [family]"). Lines are non-scaling-stroke so they stay crisp at any zoom. This is the layer that turns the scatter into a *map* — answers *who does she belong to?*
- **Bindu → Lalitā descent.** Tap the bindu, *or* keep zooming past a threshold, and the camera completes its fall: the red point **blooms to fill the screen**, a luminous presence breathes, and **Lalitā / Mahātripurasundarī** emerges — *Ninth Āvaraṇa · The Bindu* — with the 102 gathered as a faint returning field turning around Her. Words rise in a slow stagger (remembering, not loading). Exits: *"↑ return to the field"* or *"enter her presence."* A programmatic fly is guarded (`animating`) so it can't be interrupted mid-flight, and auto-descent only fires on a genuine deep zoom near center.
- **Ring-entry chimes.** Crossing each enclosure **inward** rings a soft bell (`lrRingChime`, `LR_RING_FREQ`, core.jsx ~L125) — deeper rings ring lower, so falling in *descends in pitch* — and flashes that ring's circle (`syRingFlash`). Zoom-driven and one-directional (silent on the way out). **Opt-in**, gated by a persisted sound toggle (`lr_sound`), default **off** for a fresh visitor so no one is surprised.

**Why native:** SpriteKit or a `Canvas`/`TimelineView` with a matched-geometry camera can hold the semantic zoom; the constellation is a set of animated `Path` strokes; the descent is a full-screen transition; the chimes are `AVAudioEngine` tone bursts gated by the toggle. Preserve the **guards** (`moved`, `animating`, re-arm) — they are what make the gestures feel solid on device.

### 2.8 — The Field, the Well, the Portrait  *(`TheHundredTwoView`, archive, `PortraitMandalaView`)*

- **The Field — 102** (`living-rite-field.jsx`): the whole khaḍgamālā as a quiet grid/field, each seat lit by its atmosphere; a calm index into any Śakti.
- **The Well**: the private archive of notes/letters (`lr_letter_*`), first-line previews only — a place to return to what was noticed. Local-only.
- **The Memory — Portrait Mandala**: the years-long artifact. Each of the 102 points brightens with felt-count and warms with recency; the image itself is the only measure. **Not a stats screen** — see §3 Phase 5.

**Audio note:** `lrPlayBija` (a 3.6s meditative drone, pitch seeded from the syllable) and `lrRingChime` (a 1.7s bell) are distinct voices — keep them distinct in the native mix.

---

## 3 · The build path (ordered, each phase independently shippable)

> The granular ring-by-ring repair sketches from `Bindu Mandala - Claude Code Brief.md` §3 remain valid and are **not** reproduced here — keep that file open for Phase 1 line-level detail. Below is the spine, updated to point at the prototype.

### PHASE 1 — The repairs (ship first)
Raise all nine ring-worlds to the bar before building new. Introduce a shared `enum Hit { static let min: CGFloat = 44 }` and fix the class of sub-44pt hit areas, not the instances. Then, per the old brief §3.1–3.5: Ring 9 trailing field, Ring 8 twelve-voice overlap, Ring 1 touch+scale, Ring 6 precision gate, Ring 3 dead glow/motes. **Done when** all nine worlds hold the same bar — every energy ≥44pt, no overlaps, no dead renders, no stray content.

### PHASE 2 — Recognition becomes 102-aware (the migration)
`RecognitionEntry.shaktiPosition` stores a per-ring 1–16 index and cannot distinguish rings. Migrate to `khadgamalaPosition` (1–102, globally unique) + denormalized `ringNumber`. **Lossless** one-time SwiftData migration — every archived moment (all currently Ring 2) survives, mapped via the Ring 2 offset. Update all writers ("I feel her", Silence dwell) and readers (Detail log, status-readiness count). **Prereq for the Portrait.** **Done when** any recognition maps to exactly one of the 102 and no pre-existing entry is lost.

### PHASE 3 — The Daily Rite (the heartbeat)  ← *prototype is the reference*
Build `Views/Today/DailyRiteView.swift` directly from §2.1–2.6. The launch destination is *her*: today's Śakti rendered in her element archetype, atmosphere-lit and time-relit, one **"I feel her"** pill, the element-driven recognition ceremony, an optional note. Plus `Services/DailySummons.swift` — **one** tender local notification/day at a chosen hour (*"She is waiting."*), no count/streak/badge, silenceable forever. Woven-in design calls: make the Rite the launch spine (Mandala one gesture away); the deliberate status-crossing (§2.5); detail hierarchy with "go deeper" (§2.5); a one-time first-run breath on the hamburger; a legibility pass. **Done when** opening the app lands on (or one tap from) today's Śakti + gesture; "I feel her" logs and lights a point; at most one gentle summons/day.

### PHASE 4 — The Descent (the path)  ← *prototype Mandala is the reference*
The nine āvaraṇas become a sequential inward pilgrimage (Bhūpura → Bindu). Add `DescentState` (currentRing, deepestReached, crossings[], enteredCurrentAt). Reframe the Veil as a ladder: reached rings revisitable; the **next** ring a breathing, named-but-closed threshold crossed by a **deliberate gesture** (press-and-hold / worded invitation), never a plain button. **Content gates the path** — a ring opens only once its Śaktis have authored `somatic` + `recognitionPhrase` (`contentReady(ring:)`); until then, *"not yet — she is still becoming words."* Today's Śakti follows the descent. Build the threshold ceremony and the ring-entry chimes (§2.7) here. The Bindu → Lalitā descent (§2.7) is the finale of this phase. **Done when** the Veil shows where you are, the next ring is crossed by a deliberate act only when its content is ready, reached rings stay open, and crossing *feels* like a threshold.

### PHASE 5 — The Portrait (the artifact)
Elevate `PortraitMandalaView` to a second home. Each of the 102 points begins near-dark and brightens with felt-count; warmer/brighter when felt recently, cooling with neglect (reuse `TimeVariant` warmth). Reachable in one gesture from the Rite — the recognition moment settles *into* the Portrait, the new point glowing. **No numbers, ever** — the image itself is the only measure. **Done when** every felt-moment lights its correct point among the 102 and, over months, the Portrait becomes a true mirror of where attention has lived — with not a single number on screen.

---

## 4 · Reaching further (honest next moves, optional)

Three genuine opportunities beyond the spine — deepenings, not features. Mark any as stretch in commits so they can be cut cleanly.

- **A continuous ring drone.** The chimes mark *crossings*; a barely-there sustained tone that *is* the current ring's frequency would give the app a sonic *location* even screen-dim — the Descent as a place you can hear you're inside of. (Seeded by the Vāk-chamber bīja sounds; toggle-gated with the chimes.)
- **A home-screen widget for today's Śakti.** Her name, her somatic line, the warmth of the hour — tapping opens straight into the Rite. The field made ambient, present on the home screen rather than behind an icon. (WidgetKit; reuse the Rite content + `Atmosphere` + `TimeVariant`.)
- **The descent as a remembered film.** Because crossings are dated, offer a slow, wordless "the way in so far" — the rings opening one after another with their tones. Not a stats screen; a private retrospective of the pilgrimage.

Further coherent stretches from prior briefs still stand: an exportable high-res Portrait (a devotional object, no branding/numbers), and a true timed Silence dwell logged as a `.silence` gesture.

---

## 5 · Suggested PR sequence

1. **PR-1** — Phase 1.0–1.2 (touch constant + the two one-line ring fixes). *Tiny, instant.*
2. **PR-2** — Phase 1.3–1.5 (Ring 1/6 touch+scale; Ring 3 render). *All nine at bar.*
3. **PR-3** — Phase 2 (recognition migration). *Unblocks the Portrait.*
4. **PR-4** — `Atmosphere` + `TimeVariant` engine (§2.1–2.2) as a shared foundation. *Everything downstream reads it.*
5. **PR-5** — Phase 3 Daily Rite: the six archetypes + ceremony (§2.4–2.6) + DailySummons. *The spine returns.*
6. **PR-6** — Detail: embodiment track + "go deeper" (§2.5) + Phase 3.5 polish calls.
7. **PR-7** — Phase 4: DescentState + Veil ladder + threshold ceremony + chimes.
8. **PR-8** — The living Mandala: semantic zoom + constellation + Bindu→Lalitā descent (§2.7).
9. **PR-9** — Phase 5 Portrait elevated.
10. **PR-10+** — §4 stretch, one at a time.

---

## 6 · Definition of done (the whole)

The app is no longer a beautiful museum you visit. It is a practice you are inside of: it opens to *her*, rendered in her own element and re-lit by the hour; it asks once, gently, each day; recognition responds in her nature and lights a point that never goes out; the way inward has an order, a sound, and a destination — the Bindu, where Lalitā waits — that you cross by choice; and over months a portrait of your own attention assembles itself, with not a number anywhere, because *she is felt, not measured.*

> When in doubt: **readiness is sensed; crossing is always chosen.** Build toward the practice someone keeps for years.
