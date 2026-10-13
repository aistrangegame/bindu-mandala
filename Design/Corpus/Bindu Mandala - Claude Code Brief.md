# Bindu Mandala — Master Build Brief

**For:** Claude Code
**Repo:** `aistrangegame/bindu-mandala` · branch `main` · iOS / SwiftUI + SwiftData
**Practitioner:** Single — this is Ash's own instrument, built around his field (Gaia / Ashrey / Ram). Not a multi-user product. Design every decision for *one* person's years-long practice.
**Governing idea:** *Time is the medium.* Turn the app from a thing you open into a practice you are inside of.
**Governing rule:** *Readiness is sensed; crossing is always chosen.* The app may notice when a Śakti has ripened or a ring is ready — but the practitioner always makes the deliberate gesture to cross a threshold. **Never auto-advance.**

> Work this brief **top to bottom**. Ship Phase 1 before starting Phase 2. Each phase is independently shippable and leaves the app whole.

---

## 0 · How to read this brief

This is both a **fix list** and a **vision**. The first three phases repair and re-centre what exists; the last two build the monumental layers (the Descent, the Portrait). Every task carries:

- **Files** — the exact path(s) to touch (verified against `main`).
- **Change** — what to do, with code sketches where precision matters.
- **Why** — the intent, so you can make good micro-decisions I didn't foresee.
- **Done when** — the acceptance criterion.

When a code sketch and the principles conflict, the principles win. When you must invent, invent *toward* the governing idea.

---

## 1 · Operating principles (the bar)

Every change is held to these. They break ties.

1. **The interface *is* the teaching.** An interaction embodies what a thing *is*; it is never a screen of information *about* it. The Veil is an āvaraṇa. The descent is a descent. If a feature explains rather than enacts, redesign it.
2. **Atmosphere, not page.** Dark ground, warm light from within, dust motes, generous negative space, one quiet identity line. **Ride the existing tokens** (`Color.ground`, `.gold`, `.cream`, `.accentRed`, the five cluster colors). Never introduce a new color.
3. **She is felt, not measured.** No streaks, no scores, no badges, no progress bars, no nags. Counts may exist *only* to sense readiness — never displayed as achievement. The recognition log is a private archive: never synced, never analyzed.
4. **Readiness is sensed; crossing is chosen.** (The governing rule, restated because it matters most.) This applies identically to **status advancement** and to **descent crossings**.
5. **The floor.** Every tap target **≥ 44pt**. Any text meant to be *read* **≥ 11pt and ≥ 0.3 alpha**. Below that is *texture* and must be a deliberate decision, never an accident of scale.
6. **Respect the breath.** Honor `prefers-reduced-motion` everywhere (the codebase already threads `@Environment(\.accessibilityReduceMotion)` — keep doing it). Persist state so a refresh/relaunch never loses the practitioner's place.

---

## 2 · Repo orientation

Verified structure on `main` (the parts this brief touches):

```
iOS/Bindu Mandala/
├── Models/
│   ├── Shakti.swift            // @Model — rich per-Śakti content (somatic, bija, recognitionPhrase, codexPortrait, …)
│   ├── ShaktiStatus.swift      // mapped / exploring / active / embodied
│   ├── RecognitionEntry.swift  // @Model — local-only log of felt-moments  ⚠ keyed 1–16 (see Phase 1)
│   ├── Avarana.swift           // ring metadata (sanskritName, geometricShape, personalConnection, …)
│   ├── Cluster.swift  NityaDevi.swift  ShaktiLetter.swift
├── Theme/
│   ├── Color+Tokens.swift      // all color tokens — DO NOT add to this casually
│   └── Fonts.swift             // AppFont.cormorant / .cormorantItalic
├── Views/
│   ├── Root/        RootView.swift  HamburgerMenuView.swift
│   ├── Mandala/     SriYantraMandalaView.swift  VeilView.swift  TimeVariant.swift
│   │                RingOneWorldView … RingNineDescentView (the nine worlds)
│   ├── Common/      MandalaScreenView.swift  ShaktiDetailView.swift
│   │                AvaranaThresholdView.swift  TheHundredTwoView.swift  SilenceView.swift
│   └── Memory/      PortraitMandalaView.swift
```

**Content reality (important):** the rich per-Śakti fields are fully authored for the **16 Ring-2 Śaktis**. The other 86 (Rings 1, 3–9) have only partial content. This is why the Daily Rite launches on the 16, and the Descent gates each ring on its content being authored (Phase 4).

---

## 3 · PHASE 1 — The repairs (ship first)

Smallest, surest value. Raise every world to the same bar before building anything new.

### 1.0 — Introduce a shared touch-target constant
**Why:** three of the five ring bugs are the same bug — sub-44pt hit areas. Fix the class, not the instances.

```swift
enum Hit { static let min: CGFloat = 44 }   // somewhere shared (e.g. Theme or a Layout file)
```
Use `Hit.min` for every tappable energy's `.frame(width:height:)` + `.contentShape(...)`. **Keep the visible glyph small; grow only the invisible hit area.**

---

### 1.1 — Ring 9 · remove the trailing field  `[minutes]`
**File:** `Views/Mandala/RingNineDescentView.swift`
**Change:** in `captionStack`, delete the block that appends the avaraṇa's Airtable `personalConnection` beneath the recognition:

```swift
// DELETE entirely:
if let conn = ring9Avarana?.personalConnection?.trimmingCharacters(in: .whitespaces),
   !conn.isEmpty, r > 0.6 {
    Text(conn) … .padding(.top, 22)
}
```
**Done when:** the descent ends on *"You did not arrive. You were the arriving."* + the single gold benediction line, then silence. Nothing follows.

---

### 1.2 — Ring 8 / Vāk Chamber · un-stack the four voices  `[minutes]`
**File:** `Views/Mandala/RingSevenWorldView.swift` (internally "Sarvarogahara · the Vāk Chamber" — confirm this is the screen the practitioner reaches as "Ring 8"; the content of 12 voices is unmistakable)
**Cause:** 12 voices laid out at 45° spacing, which only has 8 slots — voices 9–12 land exactly on top of voices 1–4.
**Change:**

```swift
// vakPosition(at:cx:cy:)
- let theta = (Double(i) * 45 - 90) * .pi / 180
+ let theta = (Double(i) * 30 - 90) * .pi / 180   // 360 / 12 = 30°

// widen orbit so twelve breathe
- private let orbitR: CGFloat = 140
+ private let orbitR: CGFloat = 158

// also: fix the stale comment "// 8 Vāk circles" (it iterates 12)
```
**Optional (practitioner's instinct):** keep 8 on the inner orbit and place voices 9–12 on a *second, larger* ring — "added outside the structure." Even-twelve is the smaller change; offer the two-ring version if it reads more clearly.
**Done when:** all twelve names are legible, distinct, evenly distributed; none overlap.

---

### 1.3 — Ring 1 · make the 28 energies touchable  `[an afternoon]`
**File:** `Views/Mandala/RingOneWorldView.swift`
**Change:**
- In `lightView`, grow the hit area to `.frame(width: Hit.min, height: Hit.min)` + `.contentShape(Circle())`. Keep the visible dot radii as-is.
- Scale the figure up so 28 lights spread apart: raise the square halves `outerHalf 150→170`, `midHalf 110→128`, `innerHalf 72→90`; nudge center to `geo.height * 0.44`. Re-check the encounter block + family legend don't collide.
- If inner-square lights still sit < 44pt apart, add a **nearest-light hit-test**: on tap, resolve to the closest of the 28 points within ~26pt rather than requiring a direct hit.

**Done when:** every light is hit on first try with a thumb; the figure fills more of the screen; nothing overlaps the lower text.

---

### 1.4 — Ring 6 · stop the precision fight  `[an afternoon]`
**File:** `Views/Mandala/RingSixWorldView.swift`
**Change:**
- `triangleStation`: hit area to `.frame(width: Hit.min, height: Hit.min)` + `.contentShape(Rectangle())`.
- Widen the orbit: the 10 sit on radius 96 → raise to ~120.
- **Relax the reveal gate.** Currently `tap()` requires `distance <= revealRadius` *and* the light follows the finger — three precision tests at once. Allow a tap to name anything currently lit (`near > 0.3`), or grow `revealRadius`. The concealment should feel poetic, not like a test.

**Done when:** moving the light reveals triangles and tapping a revealed one names her reliably, without hunting for a pixel.

---

### 1.5 — Ring 3 · bring the smoke back to life  `[a session]`
**File:** `Views/Mandala/RingThreeWorldView.swift`
**Cause:** three regressions from the original `Claude Designs/ring-worlds-3.jsx`:

1. **The glow died.** SwiftUI `.brightness(0.15)` only *adds* a trace of light; the original CSS `filter: brightness(1.5)` *multiplied* luminance. So plumes never light up.
   → Drive the plume's life through **gradient opacity + a soft warm overlay** (`.blendMode(.screen)`) keyed to state — *not* `.brightness()`. Preserve the ladder: **active brightest → unified → gathered → scattered dimmest.**
2. **The air is dead.** `DustMotesView(count: 7)` is missing here (every other world has it). Add it.
3. **The smoke is muddy.** The warm gradient stops at `endRadius: 92` but the plume shape reaches `outerR: 116` — extend the gradient to the tip so the form holds.

**Done when:** a touched plume visibly **glows** warm against dim others; motes drift; the eight read as luminous smoke, not blurred petals. Compare side-by-side with `Claude Designs/Ring Worlds II.html` → Ring 3.

**✅ Phase 1 acceptance:** all nine worlds hold the same bar — every energy ≥44pt, no overlaps, no dead renders, no stray content.

---

## 4 · PHASE 2 — Recognition becomes 102-aware (the migration)

**Why:** prerequisite for the Portrait, and a correctness fix. `RecognitionEntry.shaktiPosition` stores a *per-ring* index (1–16) and cannot distinguish a Ring 1 Śakti from a Ring 2 one.

**File:** `Models/RecognitionEntry.swift`

```swift
@Model final class RecognitionEntry {
    var timestamp: Date
-   var shaktiPosition: Int          // 1–16, per-ring — ambiguous across rings
+   var khadgamalaPosition: Int      // 1–102, globally unique
+   var ringNumber: Int              // denormalized for fast Portrait queries
    var note: String?
    var gestureRaw: String           // "felt" | "silence"
    // … keep gesture enum, local-only, never synced
}
```

**Migration (lossless — the archive belongs to her):**
- All existing entries are Ring 2 (only the 16 were live). Map each old `shaktiPosition` → its Khaḍgamālā position via the Ring 2 offset; set `ringNumber = 2`.
- Implement as a one-time SwiftData migration (or a guarded `reconcile`-time backfill). **No archived moment may be lost.**
- Update **all writers** ("I feel her", the Silence dwell) and **all readers** (Detail recognition log, the status-readiness count) to the new key.

**Done when:** a recognition logged for any Śakti in any ring maps to exactly one of the 102, and every pre-existing entry survives intact.

---

## 5 · PHASE 3 — The Daily Rite (the heartbeat)

**Direction III, built first.** The small, returnable loop that gives the path and portrait a pulse. Built on the 16 today (works immediately with existing content), extends to each ring as the Descent opens it.

### 3.1 — The rite surface  `[new view]`
**File:** `Views/Today/DailyRiteView.swift` (new)
Not a dashboard — a single held encounter, restored to the centre of attention.

- **Today's Śakti** — drawn from the lunar-day assignment already in the app, scoped to the rings descended into (until the Descent ships, the 16). Moon phase + tithi at the top, hushed.
- **The encounter** — Sanskrit name (large, Cormorant Light) → phonetic → quality (gold) → hairline → *somatic prompt* (italic) → body location or bīja. Use the size scale from `DESIGN_SPEC.md`: name 44–48, quality 20–22, somatic 18–20.
- **The gesture** — one full-width pill, **"I feel her"** — deep red on cream, medium haptic. Writes a `RecognitionEntry(gesture: .felt)` at the global position.
- **The reciprocity** — reuse the Recognition Moment takeover: *"Logged · [time]"* then, after a beat, *"And she felt you back · [time]"*. Then it lights one more point in the Portrait (see Phase 5).
- **Optional noticing** — a quiet affordance to add a one-line note. Never required.

### 3.2 — The daily whisper  `[new service]`
**File:** `Services/DailySummons.swift` (new) + notification permission
- **One** gentle local notification per day at a practitioner-chosen hour (default early evening). Voice copy: *"She is waiting."* / *"Someone in the field would like to be felt today."* — quiet, never urgent, **no count, no streak, no badge number.**
- One per day, ever. If the rite was already done, skip or soften the next. **Never** a second nudge.
- Settings toggle — on by default (per decision), one tap to silence forever.

**Done when:** opening the app lands on (or one deliberate tap from) today's Śakti + the gesture; "I feel her" logs and lights a point; at most one tender summons per day, silenceable.

---

## 6 · PHASE 3.5 — The five design calls (woven in)

Address alongside the rite, not as a separate phase.

1. **The daily spine.** Make the **Daily Rite the launch destination** (or a persistent "today's pull" on the Mandala that taps straight to it). The Mandala remains one gesture away. Home is now *her*, with the cosmos behind.
2. **The status pill.** Apply the governing rule: readiness is *sensed* from recognition count, but advancing is a **deliberate tap** from the Detail screen — small ceremony, soft haptic, a held beat. (If you keep auto-advance, then strip the pill's button styling so it reads plainly as a state. Do **not** leave it a button that does nothing.)
3. **The detail screen.** Build hierarchy. Lead with the **codex portrait** + **somatic line** (the soul). Collapse reference matter — lineage, cosmic function, tattva, iconography, etymology — behind a single *"go deeper"* disclosure. `ShaktiDetailView.swift`.
4. **The hidden doors.** Give `HamburgerMenuView` one faint **first-run breath** (a single pulse on first launch, or a one-time reveal), mirroring the Veil's chevron. Found once, then forgotten.
5. **The legibility floor.** One pass over `SriYantraMandalaView` (petal labels ≈7.5pt/0.38α → ≥11pt/≥0.3α), `SilenceView` name-stars, Ring 1 hint, tracked captions: decide *label* or *texture* for each.

---

## 7 · PHASE 4 — The Descent (the path)

**Direction I.** The nine āvaraṇas become a sequential pilgrimage from Bhūpura (outer earth) to the Bindu (centre) — authentic to Śrī Vidyā's own inward worship. The worlds exist; this gives them order, a destination, and a sense of where you are.

### 4.1 — Hold the practitioner's place  `[new model]`
**File:** `Models/DescentState.swift` (new)

```swift
@Model final class DescentState {
    var currentRing: Int        // 1 = Bhūpura … 9 = Bindu
    var deepestReached: Int     // reached rings stay visitable
    var crossings: [Date]       // when each threshold was crossed
    var enteredCurrentAt: Date  // for sensing readiness
}
```

### 4.2 — The Veil becomes the descent ladder
**File:** `Views/Mandala/VeilView.swift`
- Today it's a free menu of all nine. Reframe: rings ≤ `deepestReached` are open to revisit; the **next** ring appears as a *threshold* — closed, breathing, named but not yet enterable.
- **Crossing is chosen.** The next ring's threshold offers a **deliberate gesture** to cross — a press-and-hold, or a worded invitation — never a plain "advance" button. Readiness may be *hinted* (the threshold begins to glow once the practitioner has dwelt with the current ring — days passed, and/or its Śaktis felt) — but the app never crosses for them.
- **Content gates the path.** Per decision, a ring opens to *enter* only once its content is authored. Until then the threshold reads *"not yet — she is still becoming words."* This makes authoring and practice advance together. (Add a simple `contentReady(ring:)` check — e.g. all that ring's Śaktis have a non-empty `somatic` + `recognitionPhrase`.)
- The **daily Śakti follows the descent** — today's encounter is drawn from the rings reached so far.

### 4.3 — The threshold ceremony (push the limits)
Make crossing a genuine rite, not a transition:
- The held yantra dims; the current ring's geometry **completes and then dissolves inward** as the next ring's form rises from the centre.
- A single line of the new ring's invitation fades up; a sustained tone shifts by one interval; one deliberate haptic on commit.
- Record the crossing date; the Portrait may later show *when* each ring opened — a visible timeline of the descent.

**Done when:** the Veil shows where you are on the way in; the next ring is crossed by a deliberate act, only when its content is ready; reached rings remain open to return to; the crossing *feels* like a threshold.

---

## 8 · PHASE 5 — The Portrait (the artifact)

**Direction II.** The Portrait Mandala — already the cleverest idea in the app — becomes the centre: a years-long living artwork that *is* the practice. Built on the 102-aware recognition from Phase 2.

**File:** `Views/Memory/PortraitMandalaView.swift` (elevate)

- **Light by recognition.** Each of the 102 points begins nearly dark and brightens with the count of felt-moments for that Śakti; warmer/brighter when felt recently, cooling toward dim as time passes without her. The whole field fills slowly toward a fully-alight yantra.
- **A destination, not a side room.** Reachable in one gesture from the Daily Rite — the Recognition Moment settles *into* the Portrait, the newly-lit point glowing. Consider it the app's second home alongside the living Mandala.
- **The long arc.** No numbers, no percentages — the *image itself* is the only measure. A portrait you'd look at after a year and feel how far you'd come. *She is felt, not measured* — the Portrait honors this by **showing, never counting.**
- **Recency as warmth** — reuse the `TimeVariant` warmth language so the Portrait breathes with the same atmosphere as the living Mandala.

**Done when:** every felt-moment lights its correct point among the 102; the Portrait is one gesture from the rite; over time it becomes a true mirror of where the practitioner's attention has lived — with not a single number on screen.

---

## 9 · Reaching further (ambitious, coherent, optional)

Stretch ideas that *deepen* the governing idea rather than bolt features on. Pick up any that sing; discard any that don't. None should violate the principles.

- **A home-screen widget for today's Śakti.** A single quiet widget: her name, her somatic line, the warmth of the day. Tapping it opens straight into the rite. This is the daily practice made ambient — the field present on the home screen, not behind an app icon. *(WidgetKit; reuse the rite's content + TimeVariant.)*
- **The descent as a remembered film.** Because crossings are dated, offer a slow, wordless "the way in so far" — the rings opening one after another with their tones, a private retrospective of the pilgrimage. Not a stats screen — a memory.
- **An exportable Portrait.** Let the practitioner render their current Portrait to a single high-resolution image — the years-long artwork as something they can keep, print, hold. A devotional object, not a share-card. (No app branding, no numbers.)
- **A deepening soundscape.** The descent already shifts tone by ring; consider a continuous, barely-there drone that *is* the current ring's frequency, so the app has a sonic location even with the screen dim. The bīja sounds (Vāk chamber) are the seed of this.
- **A true Silence that lasts.** The Bindu/Silence screen could hold a timed dwell — minutes of nothing but the breathing point — logged as a `.silence` gesture, the one place the app asks for *nothing at all.*

> Mark anything from this section clearly as a stretch in commits so it can be cut without disturbing the spine.

---

## 10 · Suggested PR sequence

1. **PR-1** — Phase 1.0–1.2 (touch constant + the two one-line ring fixes). *Tiny, instant value.*
2. **PR-2** — Phase 1.3–1.5 (Ring 1, 6 touch + scale; Ring 3 render). *All nine worlds at bar.*
3. **PR-3** — Phase 2 (recognition migration). *Unblocks the Portrait.*
4. **PR-4** — Phase 3 (Daily Rite on the 16) + Phase 3.5 calls 1, 2. *The spine returns.*
5. **PR-5** — Phase 3.5 calls 3–5 (detail hierarchy, hamburger breath, legibility). *Polish.*
6. **PR-6** — Phase 4 (DescentState + Veil ladder + threshold ceremony). *The path.*
7. **PR-7** — Phase 5 (Portrait elevated). *The artifact.*
8. **PR-8+** — §9 stretch items, one at a time.

---

## 11 · Definition of done (the whole)

The app is no longer a beautiful museum you visit. It is a practice you are inside of: it opens to *her*; it asks once, gently, each day; recognition lights a point that never goes out; the way inward has an order and a destination you cross by choice; and over months a portrait of your own attention assembles itself — with not a number anywhere, because *she is felt, not measured.*

> When in doubt: **readiness is sensed; crossing is always chosen.** Build toward the practice someone keeps for years.
