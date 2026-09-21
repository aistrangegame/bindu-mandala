# DECISIONS

Every call the charter (§4) hands to Code, with its reasoning. Append-only.
Charter: `BUILD-CHARTER.md`. Rulings for Ashrey: `RULINGS-QUEUE.md`. Queue position: `PROGRESS.md`.

---

## 2026-09-21 · Branch recovery (charter §4, queue item 1)

Four worktrees were left mid-flight when the 2026-09-07 session ended. All four were read before anything was committed or discarded. No two touched the same file, so the `WellView.swift` collision the Chat note feared never happened.

| Branch | Verdict | Reasoning |
|---|---|---|
| `phase-2a` | **Commit and continue** | Held a sound commit (letters re-keyed to khaḍgamālā position, Schema V2 with a real migration stage) plus an uncommitted Well rewrite that compiled and passed 170 tests on first run. Finished to 209 tests green. |
| `phase-2b-sound` | **Commit as a checkpoint, then verify** | 1,138 lines of `HomeSoundService` plus tests, never compiled. Far too much sound-looking work to discard unread; verification is cheap by comparison. |
| `spike-baseline` | **Commit the harness, restart the two rooms** | The measuring apparatus (metrics, census, bench, cold-launch) is reusable and sound. Neither Garimā room was ever begun — those branches do not exist — so they start clean. |
| `phase-4` | **Commit the two repairs, restart the sweep** | Only 2 of ~40 audited sites, both correct and well reasoned (the tier hint raised to threshold; the zoom-control backing changed to a radial wash so a seat's glow is no longer stamped out). The rest is a clean sweep. |

## 2026-09-21 · `Deepest Ring Reached` — dropped (charter §4)

**Dropped.** The charter's condition is met: `Ring Crossed` already fires once per new-deepest ring, so the new event would duplicate it exactly.

Evidence from shipped code, not inference. `DescentState.enter(ring:)` appends a crossing and returns true only when `ring > deepestReached`; `LivingMandalaView.recordCrossing` writes to the ledger only on that true. Both call sites — the zoom path and the ring-9 descent arrival — pass through the same gate, and re-entering a ring already reached records nothing. The code's own comment names Ruling 8. Every `Ring Crossed` row carries `Descent Ring`, so "how deep has he gone" is a maximum over rows that already exist.

`Full Circle` and `First Dwelling` are wired as ruled, in Phase 3.

## 2026-09-21 · Letters migration — gate run on the sealed container, fresh pull deferred (charter §4, §6)

The charter asks for a **fresh** copy of Neev's container over the cable, and calls this the one hard stop. Neev is paired and its tunnel connects, but the developer disk image will not mount: `kAMDMobileImageMounterDeviceLocked`. The phone is locked, and the charter forbids waiting (§6).

**The migration did not fail — it could not be run against today's data.** It *was* run, and passed, against the sealed pristine container of 2026-09-06 (`~/Desktop/BinduMandala-DeviceAudit-2026-09-06/neev-container-PRISTINE-*.tar.gz`), which is a genuine V1 store carrying his real letters. Measured two independent ways (sqlite3 on the raw file, and SwiftData opened through `BinduSchemaV1`), migrated through the app's own door, then re-measured: 16 rows in and 16 out, legacy positions 1–16 becoming khaḍgamālā 29–44 one-to-one, every body byte-identical by hash, `updatedAt` preserved, recognitions and crossings and the 102 Śakti rows untouched.

Three things make proceeding safe rather than merely convenient: the migration now writes an fsync'd sidecar of every letter body *before* it deletes anything, so even a kill mid-stage is recoverable; the same code path maps all sixteen legacy slots, so a letter written since 09-06 migrates identically; and the letters are additionally mirrored server-side in each Śakti's `Letter` field, which the sync seeds back into a blank local row.

**Reversible, and revisited:** the fresh pull is retried before the final ship (§8), and the gate re-run for real if the phone is reachable then. Logged to `RULINGS-QUEUE.md`.
