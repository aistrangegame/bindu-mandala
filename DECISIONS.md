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

## 2026-09-21 · Ashrey releases the letters hard stop (charter §7, narrowed)

**Ruled by Ashrey, 2026-09-21, unprompted:** "on the letters migration failing on a container copy, I haven't really recorded much there, so even if we lost the information, it is alright."

He is factually right about the state. Three letters carry words — 13 bytes, 14 bytes, and one real 69-byte letter to Śarīrākarṣiṇī — and a fourth he deliberately cleared himself on 2026-08-24. The Well is barely begun.

**Effect, narrow and deliberate:** charter §7's first halt condition — "the letters migration fails on the container copy" — is **released**. If the migration fails on a copy, the build logs it here and in `RULINGS-QUEUE.md` and continues rather than halting. The locked-phone ruling (queue item 1) drops from consequential to routine.

**What this does NOT release, and I am reading it narrowly on purpose.** He said letters. He did not say practice data. The other three §7 conditions stand in full, and the second one — *any path would lose, duplicate or corrupt his practice data* — still covers the 74 recognition entries, the six crossings, and every ledger row. That is sixty days of daily practice and the entire reason Phase 0 existed. A narrow reading costs the build nothing; a broad one could cost him the thing he actually cares about.

**And the letters are safer than either of us needs them to be:** all three non-empty bodies are mirrored server-side in each Śakti's `Letter` field (`fldgASyV031Hr4sHp`), and `seedLetterIfMissing` restores a server body into a blank local row on sync. Local loss is recoverable from Airtable without a migration at all.

## 2026-09-21 · A non-ruling on the renderer, discarded before it could mislead

An agent reported a renderer ruling of "(a) SceneKit" that rested on the charter's default clause alone. It was honest about why: neither Garimā room existed, because both variant agents died before starting — `Could not read the repository git config to neutralize filter drivers` — so there was nothing to compare.

**Not accepted as the ruling.** The charter asks for the spike run two ways with the numbers logged, and a default taken in the absence of evidence is not that. Both rooms are now being built in prepared worktrees, and the real decision will supersede this note.

## 2026-09-21 · Why the first spike produced nothing: a host-contention failure of my own making

Worth recording because it will recur otherwise. Three agents were building concurrently, and two of them invoked `xcodebuild` with the **same** `-derivedDataPath`, corrupting each other's output. Host load passed 300 on an 8-core machine and `posix_spawn` began returning `EAGAIN`, so builds died with "Early unexpected exit" and "could not spawn" that look like test failures and are not.

The spike agent wrote eight good files and could never commit them; they were recovered and committed by hand as `55cf92b`. Its baseline census survives and is the trustworthy half — a pure function of the canvas's branch structure with no GPU or scheduler in it, so it reproduces exactly anywhere. Its *timing* half was taken at host load ~17 on 8 cores and is explicitly untrustworthy.

**The rule from here:** every concurrent agent gets its own named `-derivedDataPath`, never a generic one it chooses itself, and a spawn failure is treated as contention to wait out rather than a defect to edit around.
