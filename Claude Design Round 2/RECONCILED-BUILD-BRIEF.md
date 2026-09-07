# Bindu Mandala — The Living Rite · Reconciled Build Brief

**This is the single source of truth for the rebuild.** It supersedes `README.md`
and `DESIGN_SPEC.md` in this folder wherever they conflict.
It reconciles the Round 2 "Living Rite" design against the app **as actually shipped on `main`**
(the later, deliberate mind), and records Ash's rulings on every conflict the audit surfaced
(32 verified; 8 high). When a Round 2 doc and this brief disagree, **this wins**; when this brief
and the shipped code disagree, treat it as a bug in this brief and reconcile up to the code.

> **Governing idea:** *Time is the medium* — a practice you are inside of, for one practitioner, across years.
> **Governing rule (amended):** *Readiness is sensed; crossing is chosen* — applies to **status/embodiment**.
> It does **not** gate the descent: the instrument is fully open (Ruling 2).
> **She is felt, not surveilled** — recognition syncs and is ledgered under the hood, but is never shown to her as a score (Ruling 4).

---

## 0 · Locked rulings (decided with Ash, 2026-07)

The prototype (`prototype/`) is the source of truth for **look, motion, behavior**. These rulings
override the Round 2 prose where it describes a gated/lunar/local-only world the app has outgrown.

| # | Fork | Ruling |
|---|---|---|
| 1 | Mandala vs nine ring-worlds | **The semantic-zoom Mandala replaces the nine worlds.** They survive only as Field/102 rows. → **Round 2 "Phase 1" ring-repairs are cut** (throwaway). |
| 2 | Open vs gated descent | **Open instrument is permanent.** Every ring enters on a tap. **Delete** the dormant `.threshold`/`.becoming`/`.unseen` + hold-to-cross machinery in `VeilView`. `DescentState` is memory only. |
| 3 | "Today" source | **All-102 shuffle (`DailyEnergyService`) is canonical.** Repoint the Mandala highlight and RingTwoWorld off `LunarPhaseService.todayPetalIndex()`. Strike "keep lunar / scoped to descent." |
| 4 | Recognition sync | **Airtable sync + App Activity ledger governs.** Rewrite the "never synced" principle to "private-facing, not surveilled." `serverRecognitionCount` stays the readiness source. |
| 5 | Six archetypes | **Confirmed.** Rebuild `DailyRiteView` as six element-layout branches over one content model; **retire** `.body`/`.bija` + `today_variant_raw`. |
| 6 | Element source for the 86 | **Per-ring table (match prototype).** Ring 2 from `tattva`; rings 1,3–9 from a fixed map. Per-Śakti jitter keeps sisters distinct within one archetype. |
| 7 | 86-content leaks | **Graceful degradation now.** Suppress cluster dot/label when absent, poem-as-invitation for the 86, hide empty phonetic. Author real content later as a separate pass. |
| 8 | Descent durability | **Mirror `DescentState.crossings` to Airtable** so a store reset can't erase the descent timeline. |

---

## 1 · What is already shipped vs new

| Round 2 phase | Shipped today | This brief |
|---|---|---|
| P1 — nine ring-world repairs | Nine `fullScreenCover` worlds exist | **Cut** (Ruling 1) — do not spend the bar here |
| P2 — Recognition 102-aware | `RecognitionMigrator` done; `RecognitionEntry` carries `khadgamalaPosition`+`ringNumber` | ✅ Done |
| P3 — Daily Rite | `DailySummons` done; `DailyRiteView` is 2-variant; all-102 `DailyEnergyService` | Six archetypes = **biggest new build** |
| P4 — Descent (gated) | Veil **fully open**; gating is dead code | **Retired** (Ruling 2). New Mandala/descent is the semantic-zoom space (§4) |
| P5 — Portrait | Underway (exportable Portrait + Descent Film) | Elevate; reads from Atmosphere |

**Load-bearing data fact:** only the 16 Ring-2 Karṣiṇīs carry `tattva`/`cluster`/`somatic`/
`somaticPoetry`/`recognition`. The other **86 are ~`{name, ring, pos}`**. Every engine must degrade
gracefully for 84% of the app (Ruling 6/7) or it renders blank.

---

## 2 · The engine foundation (build FIRST — everything reads it)

### 2.1 `Theme/Atmosphere.swift` (new)
`struct Atmosphere` with `static func derive(from: Shakti, at: TimeVariant) -> Atmosphere` — pure,
deterministic, testable (port `lrAtmosphere`, core.jsx ~L208). One **hue seed** → `glow`, `ground`,
`groundDeep`, `accent`, `accentBright/Soft/Faint`, all inside the existing token family. Seed: Ring 2
from its cluster hue (`LR_CLUSTER_HUES`); rings 1,3–9 from the per-ring hue (`LR_RING_HUES`);
`lrJitter(kp, 14)` rotates each sister slightly. **Do not hand-pick colors per screen** — Today,
Detail, Mandala, Portrait all read from here. `lrBackdrop` (core.jsx ~L354) → `backgroundGradient(for: element)` (fire low, water pooled, air high-asym, ether pervasive, earth grounded, light central).

### 2.2 `element` on `Shakti` (Ruling 6)
Add a computed `element: Element`. Ring 2 parses `tattva`; rings 1,3–9 use the fixed map:
`1:earth, 3:air, 4:water, 5:fire, 6:ether, 7:air, 8:fire, 9:light`. Mechanical, no content work.

### 2.3 TimeVariant → modulation deltas (do NOT naively "extend")
Native `TimeVariant` returns **absolute** colors; the spec needs **hue/sat/lum deltas** applied over
a per-Śakti seed (`lrApplyTime`, core.jsx ~L164: dawn warms/violets, noon clarifies/cools, dusk
deepens, night darkens/saturates). Convert `TimeVariant` to deltas that `Atmosphere` applies. Keep
the current absolute palette available for the held-yantra rendering until it too migrates.
(Note: prototype uses a 4-state time model; native has 5 incl. `newmoon` — keep `newmoon`.)

### 2.4 Safety guard (before any model change)
Add a `VersionedSchema` / `SchemaMigrationPlan`; make every new stored property optional-or-defaulted.
Today any non-lightweight migration trips `PersistenceRecovery`, which moves the store aside and opens
a **fresh empty** one. Do this before adding embodiment/element/atmosphere/descent-mirror fields.

### 2.5 kp-ordering verification
Prototype `kp` is **derived** (ring-then-source order); native `khadgamalaPosition` is **stored**.
Only Ring 2's bridge (`position+28`) is proven. `kp` seeds jitter, mood, and day-selection — dump
Airtable `khadgamalaPosition` per ring and diff against prototype `pos` for rings 1,3–9. If any
diverge, key the engine off `khadgamalaPosition` (don't assume they coincide beyond Ring 2).

---

## 3 · The screens

### 3.1 Daily Rite — six archetypes (`Views/Today/DailyRiteView.swift`) — Ruling 5
Her `element` selects one of six compositions (`LR_ARCHETYPE_BY_ELEMENT`, core.jsx ~L317):
fire→ascension, water→descent, air→horizon, ether→veil, earth→foundation, light→radiance.
`lrComposition(s)` adds per-Śakti lean/spin/scale/tier jitter seeded from `kp`. One shared content
model (name, phonetic, quality, hairline, somatic prompt, bīja, sigil); **six SwiftUI layout branches**
off `atmosphere.element`. Size scale: name 44–48, quality 20–22, somatic 18–20. One constant pill —
**"I feel her."** Retire `.body`/`.bija`/`today_variant_raw`. Today's Śakti = `DailyEnergyService`
(all-102). **86-degradation (Ruling 7):** suppress the cluster dot/label when `clusterGroup` empty
(Atmosphere accent carries color); the somatic *prompt* is her poem for the 86; hide `phonetic` when empty.

### 3.2 Her Presence + embodiment (`ShaktiDetailView.swift`)
Lead with the **soul** (name, quality, somatic, slow-spinning ring-geometry hero, element-lit). Then:
the **embodiment track** Mapped→Exploring→Active→Embodied (`LR_STATUS_THRESH = [0,1,3,7]`); readiness
**sensed from `serverRecognitionCount`** (Ruling 4 — not the local count the spec names); crossing is a
deliberate **press-and-hold**, persisted per-Śakti (store the crossed level on `Shakti` or a small
`EmbodimentState`). Bīja below the fold (tap to sound). Single **"go deeper"** disclosure hides the
reference matter. **"I feel her"** opens the ceremony. The existing bottom "I feel her" (any-energy
recognition, source `.mandala`) stays.

### 3.3 Recognition ceremony (`RecognitionMomentView`)
Full-takeover that **responds in her element** (`LR_RECOG`, core.jsx ~L344): fire flares, water pools,
air disperses, ether blooms, earth settles, light radiates. Sequence: name + phrase ("she was felt
here · time") → held beat → "and she felt you back · time" → optional "What did you notice?" (never
dismisses) → collapse inward into the Portrait. **"felt back" phrase:** keep native's per-Śakti chain
`recognition`→`appreciationPhrase` (confirm `appreciationPhrase` populated for the 86, or the line
vanishes). Writes `RecognitionEntry(gesture:.felt)` at the global 1–102 position **and syncs** per
Ruling 4 (Airtable Recognition row + PATCH + first-felt ledger).

### 3.4 The living Mandala (`SriYantraMandalaView` + descent) — Ruling 1, net-new architecture
One continuous **semantic-zoom** space: cosmic (all 102 seats) → mid (a ring resolves) → seat (one
Śakti blooms). Build with `Canvas`/`TimelineView` (or SpriteKit) + a matched-geometry camera.
Carry the four capabilities from `living-rite-mandala.jsx`: **fly-to-seat** (guard every tap with a
`moved` flag), **constellation threading** (animated `Path` strokes to her family — Ring 2 by cluster,
others by āvaraṇa; others dim ~28%), **Bindu→Lalitā descent** (the finale — red point blooms, Lalitā
emerges, 102 gather as a returning field), **ring-entry chimes** (`lrRingChime`, deeper=lower, opt-in,
persisted toggle default off). Preserve the `moved`/`animating`/re-arm guards. **The nine ring-worlds
are removed** — they survive only as Field rows. **Auto-descent decision:** the prototype auto-fires
the fall on deep zoom (`scale>4.3 && center<64px`) which tensions with "never auto-advance"; since this
is net-new, choose at build: finale on a chosen tap/hold (honors the rule) or sanctioned auto-descent
(a documented exception). Recommend chosen tap.

### 3.5 Field / Well / Portrait (`TheHundredTwoView`, archive, `PortraitMandalaView`)
Field = the whole khaḍgamālā as a calm grid, each seat lit by its Atmosphere (this is where the nine
"worlds" now live). Well = private notes/letters archive, first-line previews. Portrait = the years-long
artifact; each of 102 points brightens with felt-count, warms with recency (reuse `TimeVariant` warmth).
**No numbers, ever.** The recognition moment settles *into* the Portrait, the new point glowing.

---

## 4 · Durability & data (Rulings 4, 8)

- **Recognition/letters** already sync + restore from Airtable (this session's work). Keep.
- **DescentState.crossings → Airtable (Ruling 8):** add a mirror + restore-if-empty so a store reset
  can't erase the descent/first-visit timeline (mirror the existing recognition-restore pattern).
- **Ledger:** first-felt "Shakti Recognized" + first-letter "Letter Written" to `tblJlBeiHnqGpYrL7`
  stays. (Known: Letter dedup is local-only — see [[letter-written-dedup-local]].)

---

## 5 · Doc hygiene (fix in the Round 2 folder, no app code)

- `DESIGN_SPEC.md` is **byte-identical** to `Bindu Mandala - Final Handoff.md` — delete one; this brief is canonical. *(Done 2026-09-07, Brief v2 Phase 1.6: `Final Handoff.md` deleted after `cmp`; `DESIGN_SPEC.md` kept.)*
- Prototype entry is **`prototype/index.html`**, not "Bindu Mandala - The Living Rite.html."
- Prototype field is **`recognition`** (fallback `appreciationPhrase`), not `recognitionPhrase`; `LR_RECOG` is an *animation* spec, not a phrase. Key remaps: `short`→`shortName`, `location`→`bodilyLocation`, `description`→`qualityDescription`, `recognition`→`recognitionPhrase`, CLUSTER_INFO `self`→enum `selfBody`.
- "Eight modules" undercounts — 12 files incl. the two data modules (data, not chrome).
- Phase-1 line detail references a brief (`Bindu Mandala - Claude Code Brief.md`) that does not exist by that name; moot anyway since P1 is cut (Ruling 1).
- Fix the false `RecognitionEntry.swift:5` "Never synced" comment (Ruling 4).

---

## 6 · Recommended build sequence (reconciled)

1. **Doc reconciliation** — retire the duplicate; this brief is the source of truth. *(this file)*
2. **Safety guard** — `SchemaMigrationPlan` + optional/defaulted new props (§2.4); the `DescentState`→Airtable mirror (§4).
3. **Data foundation** — computed `element` (§2.2); kp diff (§2.5).
4. **Engine (PR-4)** — `Atmosphere.derive` (§2.1); TimeVariant→deltas (§2.3). *Land before any screen.*
5. **Screens** — six-archetype Daily Rite (§3.1) → Detail embodiment (§3.2) → recognition ceremony (§3.3).
6. **Mandala (PR-8)** — semantic-zoom + constellation + Bindu→Lalitā (§3.4); the nine worlds fold into the Field.
7. **Cleanup** — delete the open-instrument dead code in `VeilView` (Ruling 2); repoint the Mandala/RingTwo "today" to `DailyEnergyService` (Ruling 3).
8. **Portrait (PR-9)** + stretches (ring drone, widget, descent film).

**Definition of done:** the app opens to *her*, rendered in her element and re-lit by the hour; asks
once, gently, each day; recognition responds in her nature and lights a point that never goes out; the
Mandala is one continuous space you fall through to the Bindu where Lalitā waits; and over months a
Portrait of your attention assembles itself — with not a number anywhere.
