# Build Brief v2 — Errata

**Established:** 2026-09-07, the Session 0-A / Session 1 recon · **Against:** `BINDU-MANDALA-BUILD-BRIEF-V2.md` (this folder, unedited)

The brief is kept as issued; this file travels beside it and records where the recon found the
ground different from the brief's picture of it. Each entry names the brief's section, then the
correction and its evidence as the recon stated them. Where the brief and this file differ, the
brief's *rulings* still win (Law 9's order); these are corrections of *fact*, not of law.

---

## Phase 0 · The instrument hears again

### 0.1 — How build 34 reached the phone

Build 34 was an Xcode Cloud build of 522cdd3 installed via Xcode; Cloud builds 10–34 shipped token-less because ci_scripts sat at the repo root and Apple runs it only beside the .xcodeproj — moved to iOS/ci_scripts in Session 0-A (#26); the AIRTABLE_PAT secret was added to workflow "Default" on 2026-09-07.

### 0.3 / 0.6 — The flush, the queued kp7 item, the discarded bodies

One launch runs the flush twice, so the queued kp7 item was dropped by the auditor's two launches (confirmed: pendingRecognitions absent in the 2026-09-07 pull) and was restored from the local row by the backfill. Nine HTTP sites discarded bodies, not three. flushPending had no re-entrancy guard. All fixed in #26.

### 0.4 — The backfill, as executed 2026-09-07

The note-bearing June row (pk41 "Atlas emergence") was already on the server; the missing row was note-less pk40 — created with Source "Today" (June's Rite used the 16-petal lunar rule). Crossing blob stores dates only; rings 3,4,5,6,7 on 07-14 and 9 on 07-25 were assigned by ruling; no ring-8 date exists. Crossing rows carry Source "Mandala". RecognitionEntry has no Source; rule: "Today" when kp equals the practice-day pick, else "Mandala". C4 KP44 was a no-op (server already equalled the phone). A second simulator artifact (Crossing recNwmcYvDspVV3fd, 2026-09-07 02:36Z) was deleted with C6. C3 KP29: server cleared to match the phone's deliberate clear. Ledger first-felts on the local basis (38 rows, adding kp35 and kp41 felt only in May); Letter Written for KP40 (05-20), KP39 (05-30, the New York day), KP44 (05-25). Result: server 42 Recognition = local since sync-live, 6 Crossing, 9 Silence, 41 App Activity; re-plan shows zero pending.

---

## Phase 1 · Hygiene and the repair list

### 1.5 — FIDELITY.md

The brief's replacement wording would have dropped the still-true phonetic/bīja/cluster gaps for the 86; FIDELITY keeps them.

### 1.6 — github.md

github.md exists only in Design's package; it entered the repo with 1.9.

### 1.7 — The ghost file

prototype/index.html loaded the ghost file; its src now points at _superseded/. A second copy remains in Claude Designs/ (May canvases).

### 1.8 — The audit reports in the repo

The audit brief said the audit reports must never be committed; Brief v2 (verified by Ashrey) supersedes that and they live here.

---

## Phase 2 · Foundations for the Homes

### 2.1 note — Schema V2

PersistenceRecovery hardcodes BinduSchemaV1.models; a V2 must move it to the latest version. RecognitionMigrator is a launch-time backfill, not a MigrationStage — letters need a real MigrationStage.

### 2.2 note — HomeMemory

Design's HomeMemory stores visits + accumulated dwell (capped 4000 s); compression and head start derive from those; the brief's longestDwell/lastDwell/lastVisit/deepestAdaptation are additions.

### 2.3 note — The per-Śakti carrier

"roomtone" and "descent glissando" appear only in the brief, not in Design's handoff; Design's per-ring roots (55→123.47 Hz) are its own choice and disagree with RingAudioService, which has no root for rings 4, 5, 7 — a ruling is needed before 2.3.

---

## Phase 3 · The Homes

### 3.x — Room counts, section pointers, the authored map, R11's clock

Rings 3–9 are 58 rooms, not 74 (8+14+10+10+12+3+1). Handoff section pointers: HomeMemory is §4.9, sound §5, acceptance §8; the brief's Phase-3 file map is the JS manifest (§10), Design's Swift map is §3. Design's authored-room map is keyed by name with four ghost spellings (only Laghimā, Garimā, Mahimā, Mahātripurasundarī resolve in the Axis) — port keyed by kp {1,2,3,4,6,27,28,102}. R11 timing: on return visits the chamber clock starts at the head start, so "past the first adaptation" on the chamber clock arrives in under 62 s of real dwell — rule which clock R11 means.

---

## §0 · Laws

### Law 2 — Never measure

TheHundredTwoView printed the recognition count as a digit for felt seats — removed in Phase 1.

---

## Open

Whether the nine Personal Connection marginalia are the existing May-28 Avaraṇa field (already synced and shown on the Threshold) or new text of Ashrey's own; two canon-referenced docs are missing everywhere (claude-design-project-plan.md, descent-experience-architecture.md); KP39's live letter was outside C3–C5 (it was already in sync).
