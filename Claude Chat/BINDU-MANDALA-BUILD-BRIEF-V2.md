# Bindu Mandala — Build Brief v2
### The instrument hears again, then the Homes, then the light

**Issued:** 2026-09-07 · **From:** Claude Chat (reconciliation session with Ashrey)
**Supersedes as active roadmap:** `Claude Design Round 2/RECONCILED-BUILD-BRIEF.md` (its
Rulings 1–8 remain law; its build plan is complete and this brief continues from it).
**Sources folded in:** the repo at `522cdd3`; this project's chat history (May 26 →
Sept 6); Claude Design's Homes package (`handoff/` — READ ME FIRST, the Claude Code
Handoff, the thread, the method, the Axis, the eleven `homes-*.js` modules, the 102
cards); `bindu-mandala-master-brief.md`; `bindu-mandala-expansion.md` (44 ideas);
`AUDIT-REPORT.md` and `AUDIT-REPORT-DEVICE.md` (Sept 6–7); Ashrey's rulings of Sept 6.
**Reader:** Claude Code, in phased sessions. Ashrey verifies this brief before the first
session and tests on device at every gate. Chat holds architecture; Code holds the files.

---

## 0 · Laws (carried forward and new — never re-litigated)

1. **Position is identity.** `khadgamalaPosition` 1–102 is the only key. Airtable is the
   source of truth for all 102 names and content. `all-shaktis-data.js` is a ghost — archive
   it, never read it (see Phase 1.7).
2. **Never measure — final form.** Felt data is unlimited (rate, weight, light, depth,
   memory of the room); legible numbers are never displayed. Return compression never skips.
3. **The two Recognition lines** — "she was felt here" / "and she felt you back" — are
   verbatim, at every site, permanently out of scope.
4. **Aniconic.** No figural devotional imagery for any Śakti, ever. Forms are shapes
   performing actions.
5. **Additive to the July architecture.** The semantic-zoom Mandala, six-archetype Rite,
   Atmosphere/Element/TimeVariant engine, DailyEnergyService, versioned schema, and
   offline-first sync are the floor. Nothing here replaces them; the Homes fold *onto*
   Detail.
6. **Schema changes only under `BinduSchemaV1`'s plan** — additive-defaulted in V1, or a
   real V2 + `MigrationStage` for key changes (letters need one).
7. **Verify before dispatch; test on device between phases.** No phase begins before the
   previous gate is reported to Chat and blessed by Ashrey — in the same one-piece discipline
   Chat uses: declare → build → report what landed → report what was left.
8. **FIDELITY rules stand** (`iOS/FIDELITY.md`): readability thresholds, reduce-motion gating,
   one spine-owner per screen, degradation guards for the 86, device verify on Pro-Max + small.
9. **Read Design's handoff docs before building any Homes step** — their invariants,
   resolution order, file map, and harness are canon for the Homes. Where this brief and the
   handoff differ, this brief's rulings win; where the handoff is silent, its method wins.

## 1 · Rulings sealed this cycle

| # | Ruling | Effect |
|---|---|---|
| R9 | **Design's four-channel grammar engine is accepted** as the uniqueness mechanism (tattva+quality → 50 physics; location → altitude; position → phase; quality → language). | Port `homes-grammar.js` as-is. **Somatic Signature and Function are reserved as fuel for the per-room refinement pass** (Phase 3.10), never dropped. |
| R10 | **The authored Gate is accepted.** Laghimā (kp3) and Garimā (kp4) resolve via the `BY_NAME` authored map; grammar power is proven by the sister-divergence harness on the other rooms. | No grammar-only Gate run required. |
| R11 | **Mauna is reborn as the dwelling.** A dwell held past the *first* adaptation (62 s, per Design) records a `RecognitionEntry` with `gesture: .silence` (local + Airtable Source "Silence"), once per visit, never displayed. | Wire in Phase 3.6. The `.silence` enum and `RecognitionSource.silence` already exist. |
| R12 | **The Homes replace Detail's top; Detail's sections become the room's library fold** (Design's manifest §4.5). | Preserve every state coupling the audit listed in G2. |
| R13 | **Ceremony brisk, dwelling adapts.** Rite of entering = three touch-paced beats folded into travel; 62 s adaptation in the dwelling; return compression floor 0.36, head-start from dwell. | Already implemented in Design's memory module; port faithfully. |
| R14 | **Ruling 7 is closed.** All 102 have full content in Airtable (and in the phone's cache). Any blank on device is sync-staleness — which Phase 0 ends. | No content authoring needed except Ashrey's own (§9). |
| R15 | **Recovery is Phase 0 of this brief**, not a patch. The sixty stranded days come home first. | See Phase 0. |
| R16 | **All ten cleanup rulings accepted as recommended (Ashrey, 2026-09-07); the three new ledger events kept** (Deepest Ring Reached · Full Circle · First Dwelling). | §1.1 and 3.6 are settled. |

### 1.1 · Cleanup rulings — Ashrey rules inside this brief (recommendation pre-filled; ✓ or change)

| # | Item | Recommendation | Ashrey |
|---|---|---|---|
| C1 | Two 07-13 Kāmākarṣiṇī Recognition rows (dev harness; both kp29) | Delete both; set her true count to 1, Last Felt 2026-06-01 | ✓ accepted |
| C2 | 06-01 Śarīrākarṣiṇī server-side duplicate row | Delete one | ✓ accepted |
| C3 | KP29 letter: cleared on phone 08-24, retained in Airtable | **Ashrey's alone** — restore to phone, or clear the server? | ✓ accepted |
| C4 | KP44 letter: rewritten on phone 08-24, never landed | Phone wins — PATCH the 08-24 body up | ✓ accepted |
| C5 | KP40 letter: local-only since 05-20 | PATCH up; ledger row hand-dated 2026-05-20 | ✓ accepted |
| C6 | Audit's accidental row `recGDqNCecjqBKC6K` (+ the lone Crossing row 07-11, also non-phone) | Delete both | ✓ accepted |
| C7 | Backfill "Shakti Recognized" ledger rows for the **11 pre-ledger first-felts** (May 31 → June 24) | Yes, hand-dated to true first-felt dates — the ledger is the ASG body's memory of you | ✓ accepted |
| C8 | Bīja footer on the Rite (June 1 hanging micro-decision) | Syllable-only ("aṁ"), the parse already exists twice | ✓ accepted |
| C9 | Hamburger order (Settings sits between Field and Memory) | Move Settings last | ✓ accepted |
| C10 | Raw PAT ships in Info.plist (Ashrey-only app; extractable from any IPA) | Accept for now; note for a future Keychain move — not a gate | ✓ accepted |

---

## Phase 0 · The instrument hears again (connection · recovery · the Well bug)

**Read first:** `AUDIT-REPORT-DEVICE.md` §"core question", §A2, §A4-device, §A6, §Disclosure.
Evidence archive: `~/Desktop/BinduMandala-DeviceAudit-2026-09-06/` — the sealed pristine
container tar is the backfill source. **Never delete/reinstall the app; install over.**

0.1 **Prove and fix the connection.** Determine how build 34 reached the phone
    (Ashrey's memory; App Store Connect → Xcode Cloud last build; workflow Environment →
    Variables → secret named exactly `AIRTABLE_PAT`). Whatever the channel: ensure the
    secret exists in Xcode Cloud *and* `Config.local.xcconfig` carries the token locally.
    Build a dev build with the PAT and install **over** the same bundle ID. First launch
    must log `[Phase 1] sync starting…` and `Shaktis fetched: 102`.
0.2 **Fix the Well before any letter is opened** on the working build: `WellView`'s
    inverted initial-load guard (`loaded=true` set synchronously at :243, `.onChange(of:
    draft)` fires later in the same cycle) — viewing marks dirty and autosaves. Make `dirty`
    mean *the user typed*. Add a test.
0.3 **Verify the queued recognition flushed** — the Prākāmya (kp7) row dated
    2026-09-06 14:34:41 UTC, note "I appreciate you the most". If the auditor's two launches
    already dropped it, it is restored by 0.4.
0.4 **Backfill from the sealed snapshot** — a one-shot, reviewed, dry-run-first script
    (Python or Swift CLI; Ashrey reads the dry-run table before it writes):
    - **Recognitions:** the 29 fault-era `RecognitionEntry` rows (07-09 → 09-06) + the one
      June event that never got its own row (pk40/41 pair — write the one with the note
      "Atlas emergence"). Fields exactly as `createRecognitionRow` writes: Row Type,
      Of Shakti, Felt At (true UTC), Lunar Day, Moon Phase (recompute from `LunarPhaseService`
      math), Source, Notes. Idempotency: skip if a Recognition row for the same Śakti within
      ±60 s of Felt At already exists.
    - **Per-Śakti PATCH:** `Recognition Count` = true count from local rows since sync-live
      (05-31) minus C1/C2 deletions; `Last Felt` = latest true Felt At.
    - **Crossings:** mirror the 6 local crossings (07-14 ×5 stepwise, 07-25 Ring 9) as
      `Crossing` rows with true dates; `Descent Ring` per row.
    - **Letters:** per C3–C5.
    - **Ledger:** `Shakti Recognized` rows for every genuine first-felt in the fault era
      (any Śakti whose first local felt-row falls 07-09 → 09-06 — many are Rings 1, 3–9
      first meetings) with `Activity Date` = the true local day; plus the 11 pre-ledger
      first-felts per C7; `Letter Written` per C4/C5 if approved; `Link to Mandala` → record
      id. Then seed the phone's `ledgeredLetters` from the server (0.6) so nothing double-logs.
0.5 **Cleanups** per C1, C2, C6 — after 0.4's dry run confirms the counts reconcile.
0.6 **Make the pipe honest** (small, permanent):
    - **No-PAT mode holds, never drops:** flush passes must not bump `failCount` when `pat`
      is nil — items wait for a token. (This is the flaw that destroyed the audit's evidence.)
    - **Log the HTTP status and Airtable error body on every failure** (currently discarded
      before logging at :763, :1066, :1212) — redact tokens, keep bodies. Add the missing
      drained/still-pending summary logs to activities and crossings.
    - **Server-derived letter dedup:** on sync, seed `ledgeredLetters` from Śakti rows whose
      `Letter` is non-empty *and* which have a `Letter Written` ledger row (one GET, filtered).
      Reinstall can no longer double-log.
    - **Recognition idempotency:** include a stable client key (feltAt ms + kp) in `Notes`
      metadata or a new `Client Key` field (Airtable, additive) and check before create.
    - **`Activity Date` pinned** to the practitioner's local calendar day explicitly.
    - Restore `soundOn` from `lr_sound` on launch; call `RingAudioService.stopAll()` on
      background (both audit findings).
**Gate 0:** on device, with Ashrey: one recognition lands in Airtable within seconds; the
ledger row lands on a first-felt; the Well opens without writing; the backfilled counts
match the dry-run table; `serverRecognitionCount` on Detail reflects truth. Report to Chat.

## Phase 1 · Hygiene and the repair list (one session)

1.1 Stale headers/comments: `ShaktiLetter.swift:4`, `Shakti.swift:4`,
    `AvaranaThresholdView.swift:8–10`, `DescentState.swift:10–11`, `RingGlyph.swift:5`,
    `AirtableService.swift:907–908`, `BijaSoundService.swift:25`, `RingAudioService.swift:12`.
1.2 Dead code: delete the eight uninstantiated views (ClusterDotView, RingPositionIndicatorView,
    BodyOutlineView*, DismissArc, RingSoundDot, RingTriangle, PetalShape, GhostPetalShape) and the
    dead lunar pair `todayPetalIndex`/`todayPosition`. *BodyOutlineView: keep in git history —
    idea 39 may resurrect the body map later; delete from the target now.*
1.3 `RiteSigil` reads reduce-motion from the environment instead of a defaulted parameter.
1.4 C8 bīja footer; C9 hamburger order.
1.5 FIDELITY.md: correct the "86 lack…" note to the truth (data complete; only somatic
    *prompts* and clusters are Ring-2-only by design); add the four-tier record (0–3).
1.6 `github.md`: Ruling 7 closed. Delete the byte-identical duplicate of
    `DESIGN_SPEC.md`/`Final Handoff.md` (keep one).
1.7 **The ghost file dies:** move `Claude Design Round 2/prototype/all-shaktis-data.js` to
    `prototype/_superseded/` with a README line ("draft roster; never shipped; Airtable is
    canon; do not diff against"). In the Design package's `Bindu Mandala - the method.md`,
    replace the line naming it authoritative with: *"The 102 cards (from Airtable) are
    authoritative; `all-shaktis-data.js` is superseded."*
1.8 **A home for the Chat-side canon:** create `Claude Chat/` at repo root holding
    `bindu-mandala-master-brief.md` (add the entering-ceremony-compression note, now
    built), `bindu-mandala-expansion.md`, `homes-design-package.md`, the 102 cards,
    `BINDU-MANDALA-AUDIT-BRIEF.md`, both audit reports, and this brief. Commit.
1.9 Add the `Claude Design Round 2/homes/` folder: Design's `handoff/` package verbatim
    (docs + modules + Axis), so Code reads it from the repo, not from a zip.
**Gate 1:** zero warnings, 65/65 + new tests green, Ashrey sees no visible change except C8/C9.

## Phase 2 · Foundations for the Homes

2.1 **Letters for all 102 — Schema V2.** `ShaktiLetter` re-keyed to `khadgamalaPosition`
    (unique), with a `MigrationStage` mapping legacy `shaktiPosition` 1–16 → kp 29–44
    (`RecognitionMigrator` is the precedent). The Well opens to all nine rings, grouped by
    ring, Ring 2 first (Ashrey's home ring). Sync seed/restore drop the `ring == 2` gate.
2.2 **HomeMemory** (Design handoff §5): additive SwiftData model keyed by kp — `visits`
    (never displayed), `longestDwell`, `lastDwell`, `lastVisit`, `deepestAdaptation`. Plus the
    per-visit `.silence` record hook for R11. Private; never synced beyond the two ledger
    events below.
2.3 **The per-Śakti carrier** (handoff §6): a parallel `HomeSoundService` engine
    (`.playback` + `.mixWithOthers` coexists), varṇamālā just-interval carrier above the
    ring root from `RingAudioService`'s technique constants, roomtone, breath layer,
    descent glissando. Never modify the nine ring techniques; `stopAll` both on background.
2.4 **Rendering decision — a spike, then a ruling.** The codebase is pure SwiftUI
    `Canvas`; the Homes were designed in three.js (three depth layers, 26 attribute forms,
    50 physics, prismatic/veil light). Build **one room two ways** — Garimā (kp4, authored) —
    (a) SceneKit scene hosted in SwiftUI + SwiftUI Metal shaders (`.layerEffect` /
    `.colorEffect`, iOS 17) for light; (b) pure `Canvas` + `TimelineView` + shaders. Measure
    both against the G5 baseline (capture it first — FPS in deep zoom and descent, memory,
    thermal, cold launch on iPhone 16 Plus). Report to Chat with numbers and screenshots;
    Ashrey rules the renderer before Phase 3 starts. *Default expectation: (a).* The Mandala
    canvas itself is untouched either way.
2.5 **Port the harness** (`homes-verify.js` → `HomesTests`): distinction (sister divergence
    >10%), language uniqueness, compression-never-skips, Kāmeśvarī position-collision,
    measuring-out-loud detector, 102-room legibility render.
**Gate 2:** migration proven on a copy of the phone's container (letters intact); harness
green; renderer ruled.

## Phase 3 · The Homes — Design's build order, faithfully

Each step is one Code session, device-tested by Ashrey before the next. Files per Design's
map (`Homes/HomeGrammar.swift`, `HomeChambers.swift`, `HomeAttribute.swift`, `HomeWorlds.swift`,
`HomeDescent.swift`, `HomeMemory.swift`, `HomeSound.swift`, `HomeView.swift`, tests).
3.1 Rite of entering (three beats folded into travel; return compression).
3.2 The nine worlds — one climb, each ring's weather/clock/light per `homes-worlds.js`.
3.3 The Gate — Laghimā and Garimā (authored) — the first two rooms lived in.
3.4 Ring 2 — the sixteen home rooms (Ashrey's ring; the first full family).
3.5 Ring 1 in three family passes (Siddhis, Mātṛkās, Mudrās) — 28 rooms.
3.6 Rings 3–9 outward-in (74 rooms) — **R11 wire lands here**: dwell past first adaptation
    → `.silence` record (once per visit).
3.7 The corridor — neighbor doors within the ring; Ring 2 walkable without surfacing.
3.8 The library fold — Detail's sections folded behind the room (R12), every G2 coupling
    preserved; the letter object rests in the room (2.1 makes it possible for all 102).
3.9 The descent from any room and the return memory; sound carrier live in every room.
3.10 **The refinement pass, endless:** per room, Somatic Signature + Function enter as the
    deepening channels (R9); Ashrey's Personal Connection marginalia (§9) appears on the
    ring's walls as it is written, typographically his.
**Ledger events added in 3.6** (Ashrey may strike): `Deepest Ring Reached` (mirrors the
Crossing), `Full Circle` (the 102nd first-felt — once ever), `First Dwelling` (the first time a
second adaptation is reached in any room — once ever). Threshold crossings only, per canon.
**Gate 3 (per step):** Design's handoff §7 acceptance + FIDELITY device check + harness green.

## Phase 4 · The felt register (audit §H repairs)

4.1 Readability: raise all 31 sub-threshold sites to FIDELITY rule 4 (≥11pt / ≥0.5 α);
    the two ghost exit hints stay ghosts *at threshold* (the design intent, legibly).
4.2 Touch targets: the 8 violations to ≥44×44 (worst: "↑ return to the field" ≈19pt).
4.3 **Dynamic Type:** introduce scaled tokens (`.custom(_, size:, relativeTo:)`) across the
    Theme so text scales; canvas labels excepted.
4.4 **VoiceOver on the Mandala:** accessibility elements for the 102 seats and enclosures
    (`.accessibilityChildren` / overlay), phonetic-first names; label the Devanagari line and
    the tap-anywhere exits; for the 86 speak the transliteration, never raw diacritics.
4.5 SE-width Well header collision; Mandala z-order under zoom controls; the two system-sans
    slips (quality description, Settings title) → Cormorant; reduce-motion toggled
    mid-session stops running mote loops; investigate staged first paint on hardware.
**Gate 4:** H1–H8 device pass with Ashrey; the Well-header and thumb tests pass by feel.

## Phase 5 · The Mandala's light (expansion 27 · 28 · 30 · 31 · 32 · 38)

**Design-first:** one Claude Design prompt — gem-lighting and Bindu-as-source (27/28) — plus
its own for Tratak (38). Before either, **Code verifies the Avaraṇa row fields** (Gem, Dhātu,
Time Cycle, Beeja, Body Region — read live last session) and their field IDs. Then: every
seat's glow = the Bindu's light refracted through its ring's gem; enclosures as light, not
lines; Yoginī secrecy as mist (30); the fall speaks the beejas (31); seat forms across three
zoom tiers reuse `HomeAttribute` (32); Tratak — the yantra held still, red point, white light
earned by stillness (38). The Mandala canvas *is* touched here — additively, behind a flag
until Ashrey approves on device.

## Phase 6 · Systems triage — the 44 and the parked (dispositions, not deferrals)

| Disposition | Ideas |
|---|---|
| **Built by the Homes (Phase 3)** | 1, 2 (gem light via worlds), 3, 4 (real clocks), 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 (slot), 36 (weather as dwelling), 43 (instrument-state after-effect) |
| **Phase 5** | 27, 28, 30, 31, 32, 38 |
| **Design-first, then Code** — next queue after Phase 5, in this order | Rite as six stations 16 · 22 · 23 · 24 (one Design prompt); dawn/dusk 17 + Nityā co-presiding 18 + liturgical year 19 (Atmosphere extensions); Navarātri 25 (calendar); moon's ring 34; Portrait as night sky 35; ascent as passage 29; breathing body 26; diurnal 33; sound altitude 37 (Bindu Field DSP precedent); body map 39 (BodyOutlineView from history); mālā walk 40; lamp 42; seasons 44; watching point dreams 41; tempo 20 · patience 21 |
| **Parked-alive from history** (design when their day comes) | Svapna (dream → Codex mirror), Pūjā (sunset gathering), Darśana (gyro beholding), Sādhana (28-minute ceremony), the six unbuilt Memory instruments, the Temporal layer beyond lunar, the widget |
| **Dead — stays dead** | Relationships/Saṅgha/Beloved, lunar-today, ring gating/unlocks, the old Mauna screen (reborn as R11), the ring drone (superseded by the Homes' carrier) |

## 7 · Content that is Ashrey's alone (never generated, never seeded)

The 102 Well letters (now possible for all 102 after 2.1); the nine Personal Connection
marginalia texts for the ring walls (Design is waiting on these); the 102 bīja voice
recordings (`bija_%02d` — wired since June, falls through to sine until recorded); the KP29
letter's fate (C3).

## 8 · Airtable additions (all additive; field IDs recorded in the skill after creation)

Mandala table: none required (Client Key optional, 0.6). App Activity: three new Activity
Type options (3.6) created on first write via `typecast`. Nothing is renamed, ever.

## 9 · Session protocol for Code

Each session: load `bindu-mandala-app` skill → read this brief's current phase → read the
Design handoff docs for any Homes step → declare the step → build → run tests + harness →
report to Chat in four parts (declared / built / surfaced / left behind) → session bridge.
Never advance a phase on your own; the gate is Ashrey's device and Chat's blessing.

## 10 · What this brief deliberately does not decide

The renderer (2.4 — spike first); the Rite-as-six-stations design (Phase 6 — needs Design); anything in the
Parked-alive row. Everything else is decided.

*One building. Ninety-nine reflections and the source. First, let it hear you again.*
