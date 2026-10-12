# Bindu Mandala: Build Charter

**Status:** standing law from 2026-09-20 until the final experience ships.
**Where it lives:** commit this file to the repo root. Read it at the start of every session, before anything else.
**Hierarchy:** this charter governs *how* the work runs. Build Brief v2 and the Chat note of 2026-09-20 govern *what* gets built. Where they conflict on process, this charter wins. Where they conflict on laws or rulings, the laws and rulings win.

---

## 1 · The mandate

**Ashrey will not test anything on his device. He receives the finished experience, once.**

Code builds Bindu Mandala from where it stands today through to all 102 Homes, the felt register, and the Mandala's light, and ships one final build to Neev.

- Every check that used to be Ashrey's is now Code's, and it is automated.
- Every call that used to wait at a gate is now Code's, and it is logged.

Chat and Ashrey are no longer in the step-by-step loop. There are only two exceptions: the rulings queue (§6) and a law breach Code cannot resolve (§7).

## 2 · The laws: never broken, never traded for speed

1. **Position is identity.** `khadgamalaPosition` 1–102 is the only key.
   - Airtable is the source of truth for all names and content.
   - `all-shaktis-data.js` is a ghost. Never read it and never diff against it.
2. **Never measure.** Felt data is unlimited. No count, streak, percentage, or visit number is ever shown to the walker. Return compression never skips.
3. **The two Recognition lines stay verbatim, at every site, forever:** "she was felt here" / "and she felt you back".
4. **Aniconic.** No figural imagery for any Śakti. Forms are shapes performing actions.
5. **R17: App Activity is the single record.**
   - Every event goes to App Activity.
   - The Mandala table holds only Śaktis and Avaraṇas. It never holds event rows.
   - HomeMemory stays on the phone and is never synced.
   - Letter *words* live on the Śakti row. The *moment* of writing goes to the ledger.
6. **Additive to the July architecture.** The semantic-zoom Mandala, six-archetype Rite, Atmosphere engine, DailyEnergyService, and offline-first sync are the floor.
7. **Schema changes only through the BinduSchema plan,** as real migration stages.
8. **Ashrey's practice is sacred data.**
   - Never delete or reinstall the app on Neev. Install over the same bundle ID.
   - Never lose, duplicate, or reorder a recognition, letter, or crossing.
   - The build Ashrey practises on daily keeps working throughout.
9. **The sealed rulings are final:** R9–R17 (Brief v2 §1, and the 09-20 note). In particular:
   - R10: the Gate is the authored Laghimā/Garimā rooms. No grammar-only proof is required.
   - R11: Mauna is reborn as `Silence Held`, once per visit, on a dwell past the first adaptation.
   - Rings 3–9 hold **58** rooms.
10. **FIDELITY.md rules stand,** including readability thresholds, reduce-motion gating, and degradation guards.

## 3 · Checks are code, not conversation

A step is **done** when every one of these is green. No report is needed to prove it.

- `xcodebuild test`: the full suite passes, with zero Swift warnings.
- **Design's harness, ported to `HomesTests`:**
  - sister divergence above 10%
  - language uniqueness
  - compression never skips
  - the Kāmeśvarī position-collision check
  - the 102-room legibility render
- **A laws suite, `LawsTests`.** Create it first if it doesn't exist:
  - A measuring-out-loud detector across every walker-facing string and view (no digits bound to visit, count, or dwell data).
  - A verbatim match of both Recognition lines at every site.
  - No name-keyed Śakti lookups outside display.
  - No figural asset or description in any render path.
  - The App Activity writer is the only event writer. There is no code path that writes event rows to the Mandala table.
- **A live-base check** (read-only, at the end of each phase):
  - Mandala rows with Row Type Recognition, Silence, or Crossing = 0.
  - Mandala App Activity rows ≥ the prior count.
- **Performance.** Hold the G5 baseline (captured in the spike) on the iPhone 16 Plus class:
  - no sustained frame drops in the Mandala's deep zoom, the descent, or any Home
  - no thermal climb in a 10-minute simulated session

If a check fails, fix it before moving on. Never skip a check, and never weaken one to make it pass.

## 4 · Code makes the calls (these were Ashrey's gates)

Each call is decided by Code against the brief, Design's handoff, and the measurements, then written to `DECISIONS.md` with its reasoning.

| Former gate | How Code decides |
|---|---|
| **Branch recovery** (the four 09-07 worktrees) | Read each branch. Commit what is sound and passes §3. Restart clean what is half-formed or conflicts. Log each verdict. |
| **Letters migration** | Pull a *fresh copy* of Neev's container over the cable. Run the V2 migration on the copy. Assert every letter arrives at its khaḍgamālā position with a byte-identical body (29, 39, 40, 44, plus any written since). The check runs on the copy and is never destructive. **This is the one hard stop: if it fails, halt (§7).** |
| **Renderer** | Run the Garimā spike two ways: (a) SceneKit plus SwiftUI shaders, and (b) Canvas plus TimelineView plus shaders. Choose (a) unless it misses the performance bar or cannot render Design's three-layer depth and prismatic light where (b) can. Log the numbers. |
| **Rite of entering, the Gate, and every ring's rooms** | Faithful to Design's handoff: its modules, §7 acceptance, and the thread's decisions. Where Design is silent, choose what best serves "could this room belong to any other Śakti?" and the never-measure law. |
| **`Deepest Ring Reached`** | If `Ring Crossed` already fires once per new-deepest ring, **drop** `Deepest Ring Reached` (it would duplicate). Otherwise wire it. Log which. `Full Circle` and `First Dwelling` are wired as ruled. |
| **The felt register (Phase 4)** | Satisfy the thresholds in audit §H through automation: readability ≥11pt and ≥0.5 α, touch targets ≥44pt, Dynamic Type scaling, VoiceOver elements for the 102 seats with phonetic-first names, and the reduce-motion paths. Use XCUITest and snapshot tests in place of hands. |
| **The Mandala's light (Phase 5)** | Build from expansion ideas 27, 28, 30, 31, 32 and 38 using the live Avaraṇa gem, dhātu, clock and bīja fields (verify their field IDs first). If a Claude Design package for the light is present in the repo, it governs. If not, build from the expansion doc's descriptions. |

**When in doubt, choose the more restrained option.** A quieter room can deepen in the endless refinement pass (3.10). A loud mistake teaches the walker the wrong thing.

## 5 · The build queue, in order

Run it continuously. Commit to `main` via PR whenever §3 is green, and move straight to the next item.

1. **Recover the four branches** (§4).
2. **Phase 2:**
   - 2.1 letters for all 102 and the Well opening to nine rings (Ring 2 first)
   - 2.2 HomeMemory
   - 2.3 HomeSoundService and `stopAll` on background
   - 2.4 the renderer spike and the renderer decision
   - 2.5 the harness and `LawsTests`
3. **Phase 3, the Homes:**
   - 3.1 the rite of entering
   - 3.2 the nine worlds as one climb
   - 3.3 the Gate (the authored Laghimā and Garimā)
   - 3.4 Ring 2's 16 rooms
   - 3.5 Ring 1's 28 rooms
   - 3.6 Rings 3–9's 58 rooms, plus the `Silence Held` wire and the ledger events
   - 3.7 the corridor
   - 3.8 the library fold
   - 3.9 the descent and return memory, with the carrier live in every room
4. **Phase 4, the felt register.** It may run in parallel with Phase 3 on its own branch *only* when it touches no file an open Phase 3 branch owns. Merge sequentially.
5. **Phase 5, the Mandala's light,** behind a flag until it passes §3. Then the flag comes off.
6. **The final build** (§8).

**Parallelism rule:** sub-agents and parallel branches are permitted only on disjoint file sets. Each branch merges alone, with §3 green, rebased on the latest `main`.

## 6 · The rulings queue (the only way to reach Ashrey mid-build)

If something genuinely needs Ashrey (a question the laws, the rulings, the brief and Design's handoff cannot answer):

1. Append it to `RULINGS-QUEUE.md`: one paragraph, a recommended answer, and what depends on it.
2. **Proceed with the recommended answer** as a reversible decision, and log it in `DECISIONS.md`.
3. Keep building. Never wait.

Ashrey reads the queue when the final build ships, and any answer he changes becomes a follow-up.

## 7 · The only reasons to halt

Stop the queue and report to Ashrey *only* if one of these happens:

- the letters migration fails on the container copy
- any path would lose, duplicate, or corrupt his practice data
- a law in §2 cannot be honoured by any design Code can find
- the live-base check shows event rows in the Mandala table, or App Activity rows lost

Nothing else stops the build.

## 8 · The final ship

When the queue is complete and §3 is green across the whole app:

1. Write the release through Xcode Cloud or TestFlight (with `AIRTABLE_PAT` present, verified by a successful sync in CI), or install it over Neev directly via cable.
2. Confirm on the build logs that the first launch sync and the recognition-write path succeed.
3. Leave Ashrey **one page**, `ARRIVAL.md`, containing:
   - what the app now is, in his language (no engineering)
   - anything in `RULINGS-QUEUE.md` he may want to revisit
   - where the endless refinement pass (3.10) begins: Somatic Signature and Function deepening each room, and his marginalia appearing on the ring walls as he writes them

## 9 · Session rhythm (for Code's own continuity, not for review)

- **Start:** read this charter, then `DECISIONS.md`, then the queue position.
- **End:** update `DECISIONS.md` and the queue position, and write a short `PROGRESS.md` line: what landed, and what's next.
- No four-part reports to Chat. No stops except §7.

*One building. Ninety-nine reflections and the source. Built whole, then given.*
