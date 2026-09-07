# Bindu Mandala — Read-Only Audit Brief for Claude Code

**Date issued:** 2026-09-06 · **Issued from:** Claude Chat (reconciliation session with Ashrey)
**Repo:** `aistrangegame/bindu-mandala`, branch `main`, app at `iOS/Bindu Mandala/`
**Mode: READ-ONLY.** This audit changes nothing — no code edits, no file moves, no Airtable
writes, no queue flushes, no "quick fixes." Every finding is reported with evidence; every
repair happens later, under a separate verified build brief. The single most valuable thing
this audit can produce is *truth about the running instrument* — the one vantage Chat
cannot reach.

**Deliverable:** one file, `AUDIT-REPORT.md`, written to the repo root of the local
clone but **never committed or pushed** — hand it back to Ashrey as a file. Structured
exactly by the sections below.
**Evidence-preservation law:** do NOT delete or reinstall the app on Ashrey's phone at
any point. The UserDefaults queues and the sync cache in that container ARE the
evidence sections A and B exist to read; a reinstall destroys the crime scene.
Dev builds installed over the same bundle ID preserve the container and are fine.
Every item gets a verdict — `CONFIRMED` / `REFUTED` / `PARTIAL` / `BLOCKED` — plus the
evidence (log line, file:line, screenshot name, command output). Where a section asks a
question, answer the question asked; note anything extra under "Also observed," don't
chase it.

---

## 0 · Context you should hold (verified by Chat — do not re-derive, do verify where asked)

- The app is healthy at the architecture level: versioned schema (`BinduSchemaV1` +
  migration plan), `PersistenceRecovery`, offline-first `AirtableService` with restore
  paths, ten test files, zero TODO/FIXME markers. Treat the codebase as sound and the
  July rulings (`Claude Design Round 2/RECONCILED-BUILD-BRIEF.md`) as law.
- **Position is identity.** `khadgamalaPosition` (1–102) is the only key. Never diff
  names against `Claude Design Round 2/prototype/all-shaktis-data.js` — that file is a
  superseded draft, ruled non-canon in `KP-ORDERING-FINDINGS.md`. Airtable is the source
  of truth for all 102 names and content.
- **The ledger diagnosis is already made — your job is to confirm it from the device
  side and inventory the losses.** Chat read all 46 rows of the App Activity table
  (`tblJlBeiHnqGpYrL7`, base `app248ZTWhYJlvQj2`) live on 2026-09-06: every row is
  Source App `Feed` or `Learning`. **Zero Mandala rows exist.** Feed and Learning each
  have their own link field in the data (`fldAgxERs4MnPvuGJ`, `fldagAOdtxjr32QcM` —
  inferred from record contents, not schema-read); no Mandala link field appears in
  any record. The app's `createActivityRow`
  (`Data/AirtableService.swift`, "Cross-app App Activity ledger" extension) writes by
  field *names*, including `"Link to Mandala"`. Airtable returns 422 for a write that
  references a nonexistent field name (`typecast: true` creates select *options*, not
  *fields*), the queue retries 3× and then drops silently. Working hypothesis, near
  certain: **the `Link to Mandala` field was never created in the live table**, so every
  Mandala ledger write in history has died silently.

---

## A · Ledger forensics (top priority)

A1. **Device evidence of the failure.** Note: iOS unified logs persist only briefly
    (typically hours-to-days of boots) — treat logs as *supporting* evidence and the
    A2 queues as *primary*. Capture what exists: attach Console/Xcode during a live
    session in which Ashrey performs one recognition, and report the real-time log
    lines for subsystem `com.ashrey.bindu-mandala`, category `airtable` — expected on
    the failure path: `Activity write failed`, `Activity queued`, and (on later
    flushes) `Activity dropped after N failures`. A single observed live failure is
    conclusive; historical log absence is not.
A2. **Queue autopsy.** Read `UserDefaults` keys `pendingActivities`,
    `pendingRecognitions`, `pendingLetters`, `pendingCrossings`, and
    `ledgeredLetters` on the device (Xcode → Devices → download container, or an
    lldb `po` during a debug run). Report contents/counts. This tells us exactly what
    is still salvageable in-queue vs. already dropped.
A3. **PAT presence.** Confirm `AIRTABLE_PAT` resolves in the installed build
    (`Bundle.main` → Info.plist via `Config.local.xcconfig`). If it doesn't, that is a
    *second* independent cause (everything local-only) — report which build config the
    device runs.
A4. **The recognition pipe itself.** The ledger rides on `recordRecognition`'s success
    path. Verify against live Airtable: do recent `Recognition` rows exist in the
    Mandala table (`tblrRwXJD0uP8HU8G`, `{Row Type}='Recognition'`) matching Ashrey's
    recent real usage? If recognitions ARE landing while ledger rows are not, the fault
    isolates cleanly to `createActivityRow`; if recognitions are ALSO missing, widen to
    A3/network.
A5. **wasFirst inventory.** From live Airtable, list every Shakti row with
    `Recognition Count` > 0 (field `flddp0tLpf8iuxyt4`), with counts. These Śaktis are
    past their first-felt threshold — under current code they will *never* produce a
    "Shakti Recognized" ledger row even after the field is fixed. Report the list so
    the repair phase can decide whether to backfill their ledger rows from history.
A6. **Letter dedup exposure.** Report the `ledgeredLetters` contents (A2) alongside
    which Shakti rows carry a non-empty `Letter` field in Airtable — quantifies the
    reinstall double-log exposure.
**Do NOT** create the missing field, fire a test write, or flush queues. The field
creation is a 10-second act Ashrey performs (or approves) in the repair phase; the first
real flush after it is the live verification.

## B · The 86 on device

B1. On the device, open Detail for at least one Śakti from each of rings 1, 3, 4, 5, 6,
    7, 8, 9. Report per ring: do Iconography, Etymology, Appreciation Phrase, Cosmic
    Function, Somatic Signature, Codex Portrait, Devanagari render with real content?
    (Chat verified the data is complete in Airtable for all 102; sync assigns it
    unconditionally — the question is purely whether this device's cache has caught up.)
B2. If any are blank: report `lastSyncedAt` for those rows (debug inspect), whether a
    manual sync clears it, and whether the 300-second foreground re-sync loop is
    actually firing (log lines `[Phase 1] sync starting…`).
B3. Confirm the graceful-degradation guards still hold where emptiness is *by design*:
    no false "INNER INSTRUMENT" cluster label on the 86, phonetic hidden when empty,
    somatic prompt replaced by her poem.

## C · Build & test health

C1. Clean build from a fresh clone: Xcode version, iOS SDK, deployment target, warning
    count (list every warning), any deprecations against the current SDK.
C2. Run the full test suite (`Bindu MandalaTests`); report pass/fail per file and total
    runtime. Note `AppRuntime.isUnitTesting` guards are expected to silence launch side
    effects.
C3. Report app binary size, asset catalog size, and minimum-OS reality vs. the stated
    iOS 17 target.
C4. Xcode Cloud: does the workflow still build (ci_post_clone AIRTABLE_PAT secret
    present)? Report last build status if visible.

## D · Full-history read (recovering the July trail)

Chat's clone was shallow; this project's chats have a June 1 → Sept 6 gap. Unshallow
(`git fetch --unshallow`) and report:
D1. Commit log May → today: date, message, PR number — as a timeline table.
D2. The July rebuild sequence: which commits cut the nine ring-worlds, built
    `LivingMandalaView`, the six-archetype Rite, the FIDELITY tiers.
D3. **When did Mauna/Silence die?** Find the commit(s) removing the Silence/Mauna
    screen and any Silence Airtable writes. Quote the commit message. (Ruling already
    made by Ashrey this session: Mauna is *reborn as the Homes' dwelling*, `.silence`
    fires on a dwell held past first adaptation — this item is for the historical
    record, not a decision.)
D4. Anything in the history that contradicts the RECONCILED brief or the skill's
    account — list, don't judge.

## E · Rulings drift check

For each of Rulings 1–8 in `RECONCILED-BUILD-BRIEF.md`, verdict + evidence that the
shipped code honors it today. Specifically confirm: `VeilView` and the
`.threshold`/`.becoming`/`.unseen` machinery are fully deleted (Ruling 2); nothing
reads `LunarPhaseService.todayPetalIndex()` for "today" (Ruling 3); `today_variant_raw`
and `.body`/`.bija` variants are retired (Ruling 5); the `DescentState` mirror fires
once per new-deepest (Ruling 8).

## F · Repair-list verification (confirm each, with file:line)

F1. `ShaktiLetter` is Ring-2-only: `@Attribute(.unique) shaktiPosition` 1–16; extending
    letters to all 102 requires a schema-plan-safe change. Report exactly which sites
    key letters by per-ring `position` so the repair scope is known.
F2. Stale comment: `ShaktiLetter.swift` header still says "never synced" (letters DO
    sync via `saveLetter`). Also `Shakti.swift` header still says "One of the 16
    Karṣiṇī Śaktis."
F3. `.silence` gesture: defined, never written — list the two `.felt` record sites.
F4. Bīja voice: preference + sine fallthrough wired; confirm no voice audio files exist
    in the bundle.
F5. Reduce-motion: 13 files gate on `accessibilityReduceMotion`; two files use
    `TimelineView` — confirm both are inside gated paths per FIDELITY rule 3.
F6. The June 1 hanging micro-decision: locate the Today bīja footer that shows the full
    unparsed field; report file:line (Ashrey will rule syllable-only vs. full at repair).
F7. Confirm zero `print(` statements and zero TODO/FIXME remain (Chat found none —
    verify on full history's tip).

## G · Homes-readiness facts (report facts, make no design choices)

G1. Rendering inventory: what the codebase already uses (SwiftUI `Canvas` +
    `TimelineView`, any SpriteKit/SceneKit/Metal imports, shader usage). The Homes
    design is three.js; the port target decision happens in the build brief — this
    audit only states what exists and what the device (Ashrey's iPhone model — report
    it) can carry.
G2. `ShaktiDetailView` section census (it becomes the Homes' "library" fold) — list its
    sections and any state coupling that a top-replacement must preserve.
G3. `RingAudioService` public surface — what an additive per-Śakti carrier layer can
    attach to without replacing the nine techniques.
G4. `AvaranaThresholdView` wiring — from where is it reachable today, and what would
    coexistence with the Homes' rite-as-travel touch.
G5. **Performance baseline (the before-picture for the Homes).** On Ashrey's device:
    frame rate during the Mandala's deep zoom and the Bindu→Lalitā descent
    (Instruments or Xcode FPS gauge), memory footprint at rest and at deepest zoom,
    any thermal-state elevation in a 10-minute session, cold-launch time. The Homes
    adds the heaviest rendering this instrument has carried — this baseline is what
    every future fidelity-vs-performance call gets measured against.

## H · Felt experience, UX & accessibility (the register the instrument is lived in)

The last full UX audit (`Claude Briefs/UX-AUDIT.md`) predates the July rebuild and
references deleted views — the shipped five-destination app has never had one. Run this
on Ashrey's device, driving real flows, judging by feel first and thresholds second.

H1. **FIDELITY's own checklist, per screen.** `iOS/FIDELITY.md` prescribes an
    8-point per-screen pass (atmosphere layers, composition, motion + reduce-motion,
    legibility, tokens, 86-degradation, device verify). Run it for each of the five
    destinations (Rite, Mandala, Well, the Field, Portrait) plus Detail, Recognition,
    Threshold, Homecoming, Settings. Verdict per screen per point.
H2. **Readability sweep** at FIDELITY rule-4 thresholds (meaningful text ≥ ~11pt and
    ≥ ~0.5 alpha; decorative ghosts exempt): table of failures with file:line — the
    same shape the old UX audit used, against the current views.
H3. **Dead-end check.** Every full-takeover/sacred screen (Recognition, Threshold,
    the descent, Homecoming): is there always a perceivable way out, and does the
    barely-there-hint design choice ever strand a settled eye? Report per screen.
H4. **Touch targets** ≥ 44×44pt on every interactive element (FIDELITY rule 4's
    control clause) — list violations.
H5. **Accessibility:** VoiceOver walk of the Rite → Detail → Recognition flow
    (Sanskrit names must read via phonetic/quality, not raw characters — the old
    verification's check 26); Dynamic Type behavior at one large setting; reduce-motion
    ON: walk the same flow and report what still moves (loops must pause; one-shot
    fades may stay).
H6. **The ceremony, felt.** With Ashrey present: one real recognition end-to-end.
    Does "she was felt here" → the held beat → "and she felt you back" (+3s, italic
    gold) land with the timing and weight the moment deserves on this device? Does
    the note prompt never dismiss the moment? Subjective verdict welcomed here —
    this is the one item where feel outranks measurement.
H7. **Sound & haptics in the hand.** Ring voices: correct per-ring character,
    levels, no clicks/pops on enter/leave; bīja tap sounds; haptic use — report what
    plays where and anything that breaks the instrument's quiet.
H8. **The summons.** Does the 6am whisper arrive, correctly named, once, and drop
    when the rite is already done? (Observed over the audit window or verified via
    pending-notification inspection.)

---

## Also observed

Anything real found outside these sections goes here — one line each, no fixes.

## Closing law

Report, never repair. The instrument is lived in daily; the audit's gift is a true
map, and the map's maker leaves no footprints.
