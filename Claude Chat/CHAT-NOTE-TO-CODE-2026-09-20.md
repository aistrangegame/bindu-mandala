# Note from Chat to Code: rulings, corrections, and the order from here

**Date:** 2026-09-20 · **From:** Claude Chat, walked with Ashrey · **Replies to:** your plan "where we are, and the road to the finish" (verified live 2026-09-18)

**Read this before resuming any branch.** It amends Build Brief v2. Where the two differ, this note wins.

---

## 1 · Your plan is accepted

Your read of the state is accurate and your road to the finish matches the brief. Phase 0, Phase 1 and the ledger re-wire are closed; nothing further is owed on them. The three recognitions since 09-15, which landed correctly with no one watching, are accepted as the proof that Gate 0 holds in the wild. The finishing line you named is the right one.

Four things amend it: one ruling sealed, one correction to your plan, one correction to the brief, and one change to how the work moves.

## 2 · R17 is sealed: App Activity is the single record

Ashrey made this call with you, and Chat now records it as law:

- **Every event the app writes goes to App Activity** (`tblJlBeiHnqGpYrL7`, Source App `Mandala`, linked through `Link to Mandala`).
- **The Mandala table holds only the Śaktis and Avaraṇas themselves.** Rows with Row Type Recognition, Silence or Crossing stay at **zero, forever**. Keep your verification check for this.
- **What this supersedes in Brief v2:** every instruction to write `Recognition`, `Crossing` or `Silence` rows to the Mandala table, including 0.4's crossing backfill (already done your way), R11's "local + Airtable Source Silence" wording, and 3.6's ledger wording. Read them all as App Activity rows.

Here is how R17 applies to the work ahead:

| Event | Where it lives |
|---|---|
| Recognition (first meeting or return) | App Activity: `Shakti Recognized` (distinguishing first vs. return, as it does now) |
| Mauna reborn (R11): a dwell held past the first adaptation | App Activity: `Silence Held`, **once per visit**, never displayed. Wired in Phase 3, per the brief. |
| Descent | App Activity: `Ring Crossed` |
| Letter | The **words** stay on the Śakti's own row (`Letter` field). Only the **moment** goes to App Activity: `Letter Written`. |
| The three new events (Deepest Ring Reached · Full Circle · First Dwelling) | App Activity, when Phase 3 wires them |
| HomeMemory (visits, dwell times, deepest adaptation) | **Phone only. Never synced, never a row.** This is the never-measure law holding at the data layer. |

**Two confirmations requested in your next report (report only; change nothing):**

1. **Letters.** Confirm that letter *bodies* live on the Śakti row and only `Letter Written` goes to the ledger. If the re-wire moved them somewhere else, say where.
2. **`Ring Crossed` vs. `Deepest Ring Reached`.** Report exactly when `Ring Crossed` fires today: every descent, or once per new-deepest ring (Ruling 8's mirror)? If it already fires once per new-deepest ring, the new event would duplicate it, and Ashrey will rule whether to drop it or redefine it. Don't wire `Deepest Ring Reached` until he does.

## 3 · Correction to your plan: the Gate (R10)

Your plan says Laghimā and Garimā "must be unmistakable from each other with no hand-work or the grammar is wrong." **That is the earlier lock, and Ashrey released it on 2026-09-06.**

**R10 (sealed):** the authored Gate is accepted. Laghimā (kp 3) and Garimā (kp 4) resolve through Design's authored `BY_NAME` map, as hand-built rooms. The grammar's power is proven instead by the sister-divergence harness across the other rooms (no two sisters within 10% of each other, no two speak alike). **No grammar-only Gate proof is required.** Phase 3.3 builds and lives in the two authored rooms. Its gate is Design's handoff §7 acceptance plus the harness, not a test of the grammar alone.

## 4 · Correction to the brief: 58, not 74

Your count is right. Brief v2 §3.6 says "Rings 3–9 … (74 rooms)", which counted Ring 2 twice. The correct figures are **102 = 28 (Ring 1) + 16 (Ring 2) + 58 (Rings 3–9).** Use 58 throughout, and fix the brief's line when it's next touched in the repo (`Claude Chat/`).

## 5 · How the work moves from here: one branch at a time

The 09-07 session ran four workflows at once. They collided on `WellView.swift`, and three ended with nothing committed. Ashrey walks one piece at a time, and from here the build does too.

**Step 1: recover, report only.** Before resuming or restarting anything, read the uncommitted work in all four worktrees (`phase-2a`, `phase-2b-sound`, `spike-baseline`, `phase-4`). For each one, report in a table:

- what is there
- whether it is sound, half-formed, or conflicting
- how far along it really is
- your recommendation: commit, resume, or restart clean

Then **stop, and bring the table to Chat and Ashrey.** Nothing gets committed or discarded until he rules.

**Step 2: land the branches one at a time, each gated,** in this order:

1. **`phase-2a`:** the Well opening to all nine rings (grouped by ring, Ring 2 first), HomeMemory, and the runnable harness slice. **Gate:** the letters migration is proven against a **fresh** copy of the phone's container. Assert that four letters arrive at kp 29, 39, 40 and 44 with byte-identical bodies. The 09-07 snapshot is stale, because he has practised and may have written since.
2. **`phase-2b-sound`:** HomeSoundService, the one-line `stopAll` on background, and its tests.
3. **`spike-baseline`:** capture the G5 baseline first, then build Garimā's room two ways: (a) SceneKit plus SwiftUI shaders, and (b) Canvas plus TimelineView plus shaders. Bring the numbers and screenshots.
4. **The renderer ruling.** Ashrey feels both versions on Neev and rules. **Phase 3 waits on this.**
5. **`phase-4`:** the felt register, including the Well sites it had to skip while 2-A owned that file. Once Phase 4 no longer shares files with an open branch, it may run alongside Phase 3 steps. **It may never run alongside Phase 2.**

**Step 3: Phase 3.1,** the rite of entering. This step sets the register for all 102 rooms.

## 6 · Laws that carry forward unchanged

- **Evidence preservation:** never delete or reinstall the app on Neev. Install over the same bundle ID. The fresh container pull for 2-A's gate is a *copy*; the phone is never touched destructively.
- **Position is identity.** `all-shaktis-data.js` is a ghost; never diff against it.
- **Never measure.** Felt data is unlimited; no number is ever shown.
- **The two Recognition lines are verbatim and untouched.**
- **Everything is aniconic.**
- **Schema changes go through the BinduSchema plan only.**
- **Device test at every gate.**

## 7 · How each session reports

Every session, including Step 1, reports to Chat in four parts:

1. **Declared:** what the session set out to do.
2. **Built:** what landed (for Step 1, what was *read*).
3. **Surfaced:** anything found, including drift from this note or the brief.
4. **Left behind:** what was not done or not read.

Never advance to the next branch or phase on your own. The gate is Ashrey's device and Chat's blessing.

*One building. Ninety-nine reflections and the source. Recover first, then one room at a time.*
