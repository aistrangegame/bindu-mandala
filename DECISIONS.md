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

## 2026-09-21 · The Homes grammar — the pure half of a room, ported ahead of the renderer ruling

`iOS/Bindu Mandala/Homes/HomeGrammar.swift` ports `Claude Design Round 2/homes/homes-grammar.js`: the physics classifier, the displacement kernel, the per-archetype formulas, the altitude curve, the family dispatch and the label composition. Nothing in it imports SceneKit or SwiftUI and it draws nothing — the renderer ruling (§2.4) decides how a room is *drawn*, and this layer is what a room *is*, which ports one-to-one either way.

**No bundled roster, and no card table.** Design's JavaScript carries `SYLLABLE`, `CROSSED` and `ATTRIBUTE` because it could not reach Airtable. The app can, so every input is read off `Shakti` — `tattva`, `quality`, `bodilyLocation`, `bija`, `khadgamalaPosition`, `ringNumber`. Her seed syllable comes from the existing `Shakti.bijaSyllable`, not from a copied table. Ring 2's crossing *pair* ("form, answered in ear") is therefore absent from the grammar: Design derives it from her quality and her tattva, so it belongs to the rooms layer, reading her row, rather than to a 16-entry literal here. The Ring 2 near label falls back to Design's own un-paired wording in the meantime.

**Two orderings are pinned as behaviour, because both are load-bearing and both look untidy.** The fifty classifier rules fire first-match-wins in Design's order, in which `source` is read nine rules before `icchā` — that is why kp 99 and kp 101 resolve to the same physics, and `testTheRuleOrderIsLoadBearing` fails on any re-sort. The eleven body zones are the same: "between the eyes" reaches the *eyes* rule before the *third eye* one and so sits at 0.26, which is Design's reading and is now asserted rather than inherited by accident.

**SOURCING is the one archetype whose near label is not prefixed by her quality.** Everywhere else the composition is uniform — the lowercased quality, a middle dot, the archetype's tag. Design wrote Ring 8's three corners as whole sentences ("will, before there is anything to will"), and a quality in front of one says the same thing twice; charter §4 asks for faithfulness to Design's handoff where Design has spoken, and here it has. `HomeGrammar.prefixesQuality(_:)` names the exception so it is visible rather than buried.

**Ring 9 returns `nil`, not a room.** The Bindu's room is authored, so the grammar declines to speak for her. That makes 101 grammared rooms, not 102, and the tests say so out loud.

**`Measuring` in `HomesHarnessTests.swift` is now module-internal rather than file-private** — a one-word change, no pattern touched. Design's nine `MEASURING` patterns are reused by `HomeGrammarTests` instead of copied; a second copy would drift, and a drifted detector is worse than none.

**The eighty-six are synthetic in the tests, and deliberately so.** Only the sixteen Karṣiṇīs ship in the binary; the rest live in Airtable. `HomeGrammarTests` drives Ring 2 from `ShaktiBootstrap` as itself and builds the other rings from real tattva *vocabulary* — never copied cards — which is the honest way to ask whether the classifier reads a vocabulary at all. A bundled 102-card fixture would have been the ghost roster in test clothing.

**Run on a dedicated simulator.** The recipe's `DE414BA2…` was being driven by the other branches at the same time and killed test runs mid-bootstrap; the suite was run on a fresh `claude-homes-grammar` iPhone 17 instead. A scheduling detail, not a code one — same scheme, same destination class.

**A finding to carry forward, not to tune away.** Driving the classifier over a spread of real tattva vocabulary shows the fifty rules have no reading for the six kañcukas — Māyā, Kāla, Niyati, Rāga, Vidyā, Kalā — nor for the Spanda words (Spanda, Vimarśa, Unmeṣa, Nimeṣa) or for Saṃskāra, Vṛtti and Guṇa. A Śakti whose tattva line is only one of those falls through to `breathe`. That is a gap in Design's vocabulary, not in the port, so nothing here was widened to hide it; the rooms layer should add rules for them once the live tattva lines are read off the base, and until then the fall-through is honest rather than silent. On the sixteen real cards in the binary it never fires at all.


## 2026-09-21 · The resolution order — which room a Śakti gets, keyed by position

`iOS/Bindu Mandala/Homes/HomeRooms.swift` brings the three logic layers — the grammar, the nine worlds and her attribute — under Design's own rule (handoff §4.3, `homes-chambers.js`'s `buildChamber`): her **authored** mechanism first; else her ring's **archetype** tuned by her own row through the grammar; else her **seat**, gem-lit. Her attribute is then added to whatever room resulted — never a fourth branch. Pure logic: no SceneKit, no SwiftUI, no view, no geometry, so the renderer ruling (§2.4) can draw it either way.

**The authored map is keyed by `khadgamalaPosition`, and this is not a preference.** Design keys its eight mechanisms by Śakti *name*, and four of those keys are ghost spellings that match no card — `Animā` against `Aṇimā`, `Vaśitā` against `Vaśitva`, `Sarvayoni` against `Sarva-Yoni`, `Sarvatrikhaṇḍā` against `Sarva-Trikhaṇḍā`. In Design's own shipped Axis those four rooms are never reached: the lookup misses and the walker silently gets the grammar instead, and `homes-verify.js` cannot see it happen because its only coverage question is whether *some* room was built. Ported by position — `{1: contract, 2: endless, 3: release, 4: press, 6: known, 27: membrane, 28: triple, 102: dissolve}` (errata §3.x) — the miss cannot happen, and `testEveryAuthoredPositionReachesItsAuthoredMechanism` asserts all eight arrive. That is the test Design lacked.

The pairing is Design's own, read off the cards at those positions rather than guessed: kp 2 is Vastness and kp 3 is Lightness, **not** the other way round. A map keyed by name cannot tell you that; a map keyed by position cannot get it wrong.

**The dispatch is built; the mechanisms are Phase 3.3.** The eight authored rooms are geometry — a descending ceiling, a floor that lets go, a wall passing through you — and they belong under the ruled renderer. What exists now is the `HomeMechanism` protocol they will conform to and eight named placeholders, with the dispatch proven to hand each authored position its own and no other's.

**One duplicated helper, unified.** The grammar and the attribute layers were built on parallel branches and each ported Design's `bodyAltitude` with its own copy of the eleven body zones. They are now one table: `HomeGrammar.bodyZones` — the faithful port, which keeps each zone's JavaScript literal beside its pattern — and `HomeAttribute.bodyAltitude(forBodilyLocation:)` forwards to it, so an attribute can never drift from the room it acts in. The ASCII `muladhara` that only the attribute layer carried moved into the grammar's pattern with it, so the merge lost nothing; it is the one place Design's literal is widened, and only by a transliteration.

**One duplicated fixture, unified.** `HomeGrammarTests` and `HomesHarnessTests` had each begun a synthetic 102-row roster. They now share `iOS/Bindu MandalaTests/HomesCorpus.swift`, so a check cannot pass in one suite against data the other never saw.

## 2026-09-21 · The two harness checks the rooms unblocked, and what they found

`HomesHarnessTests` carried eleven checks that could not run before rooms existed. Two now run, and their entries have moved out of the header's not-yet list into real tests over all 102 — Ring 2 from the sixteen that genuinely ship and sync, the other eighty-six from real tattva *vocabulary* keyed off position, because their rows live in Airtable and a bundled card table would be the ghost roster.

**Language uniqueness · passes.** No two Śaktis in a ring compose the same near words, and no room says the same thing at the second adaptation as at the first. Ring 2's sixteen are real data and pass on it.

**Sister divergence, at the level of logic · passes, with room to spare.** Design's `divergence` is ported exactly — the fraction of fingerprint components that differ — but applied one level beneath the geometry that waits on the renderer: what the grammar *produces*. Nineteen components, quantised to two decimals as Design quantises: where her displacement kernel puts a thing at eight moments of a stay, where her attribute is mounted and what it does at those same moments, her altitude, her mode, and the shape that acts. Physics and phase are folded into the motion samples rather than counted once each, because that is the share of the room they actually drive. Nineteen components means the tenth bites at two of them, and `testTheDivergenceThresholdBites` proves it: one component in nineteen is 0.053 and **fails**; two is 0.105 and is the smallest possible pass.

Closest adjacent pair in each ring, against a threshold of 0.100:

| ring | closest pair | divergence |
|---|---|---|
| 1 | kp 19 ↔ 20 (synthetic) | 0.895 |
| **2** | **kp 31 ↔ 32 (real)** | **0.421** |
| 3 | kp 51 ↔ 52 (synthetic) | 0.895 |
| 4 | kp 57 ↔ 58 (synthetic) | 0.895 |
| 5 | kp 67 ↔ 68 (synthetic) | 0.895 |
| 6 | kp 77 ↔ 78 (synthetic) | 0.895 |
| 7 | kp 93 ↔ 94 (synthetic) | 0.579 |
| 8 | kp 99 ↔ 100 (synthetic) | 1.000 |

**Nothing collides, and the margin is not the interesting part — the shape of it is.** Two observations worth carrying into Phase 3, neither of them a failure and neither tuned away:

- **Ring 7 is structurally the thinnest, by 0.3.** `phaseDivisor` is `nil` for SOUNDING and SOURCING, so a Vāk Devī's room carries no per-Śakti phase and her motion is driven by her tattva alone. Where the other rings separate sisters twice over (physics *and* phase), Ring 7 separates them once, and falls back on her mode number and her attribute's shape. It holds today because the base gives the twelve distinct tattvas. It would not hold if two of them ever read alike: kp 89 and kp 90 already resolve to the **same attribute shape** — the card words are `cup` and `water`, and Design's `KIN` sends `water` to `cup` — so two sisters with a shared tattva line would be separated by a mode number and nothing else, which is 1/19 = 0.053 and below the tenth. Design phases SOUNDING by node index within the mode instead; that is geometry, and Phase 3.6 should carry it rather than leave the ring resting on the base's vocabulary.
- **Ring 2's 0.421 is the only number here taken against real rows, and it is exactly 8/19** — the eight motion samples differ and nothing else does. kp 31 and kp 32 share an altitude — their `bodilyLocation` words are `solar` and `ears`, and neither is in Design's eleven zones (`solar plexus` needs both words), so both sit at the middle — and they share an attribute shape, because their card words `hand` and `ear` both resolve to `palm` through Design's `KIN`. Her room is hers because she *moves* differently, not because anything about her is placed differently. That is a true reading of the grammar and not a defect, but it means the two zone words the base actually uses for Ring 2 fall outside the vocabulary Design wrote, and the fix belongs with the live rows rather than here.

**What did not move.** The other nine entries in the header's not-yet list stand, narrowed only where a layer that blocked them now exists: the geometric half of sister divergence, the premise reversing in the *room* rather than in its words, her world conditioning her room, the five legibility renders, "every one of the 102 resolves to a *built* room", the six canon checks, and the seven iconography checks. Every one of them is blocked on the renderer ruling, on Phase 3.3's geometry, or on the cards being Chat-side documents.


## 2026-09-21 · Ring 2 would have collapsed into one motion, and Design never named why it doesn't

The grammar layer found this while porting Design's 50-rule physics classifier, and it is the most valuable thing to come out of the Phase 3 foundation.

Every Karṣiṇī's quality begins "she who attracts" — sixteen Śaktis, one verb. That phrase trips Design's `ākarṣaṇa` rule. But `ākarṣaṇa` sits at rule 12, **two behind the five elements**, so for every one of the sixteen it is her *tattva* that claims her first and decides her room, and the verb all sixteen share is only the fallback nobody reaches.

Sort those rules into any tidier order and the whole of Ring 2 — Ashrey's home ring, the sixteen rooms Phase 3.4 builds first — collapses into a single identical motion. Design's ordering is load-bearing and its file never says so. There is now a test that asserts the full ordered list, so a future tidying fails the suite instead of the instrument.

Two other orderings are pinned the same way: `source` is read nine rules before `icchā`, which is why kp 99 and kp 101 share a physics; and the body zones are first-match, so "between the eyes" reaches the *eyes* rule before the *third eye* one.

**Also recorded, not papered over:** the six kañcukas, the Spanda words and Saṃskāra / Vṛtti / Guṇa have no classifier rule at all, so a Śakti whose tattva line carries only one of those falls through to `breathe`. It never fires on the sixteen real cards. The rooms layer adds rules for them once the live tattva lines are read, rather than inventing vocabulary now.

## 2026-09-21 · Host saturation, and the discipline that replaces it

The Phase 3 foundation ran three layers concurrently while the Garimā spike ran two more. Load average passed **600** on an 8-core machine with 13+ concurrent `xcodebuild` processes, `posix_spawn` began returning `EAGAIN`, and agents lost their shells entirely — one finished a clean build and then could not run `git commit`, so a whole layer sat uncommitted until the orchestrator recovered it by hand.

This is the second time tonight that host contention, not code, cost real work. It reads as test failure ("Test crashed with signal kill before establishing connection", "Early unexpected exit") and is not.

**The discipline from here, and it costs less speed than it looks:** at most two `xcodebuild` processes on this machine at once; every concurrent agent gets its own named `-derivedDataPath` and its own simulator; branches merge serially with one suite run each. The parallelism that pays is in *writing* — three logic layers written at once is free, because writing costs no simulator. Only the verifying has to queue.
## 2026-09-21 · Ashrey releases the letters hard stop (charter §7, narrowed)

**Ruled by Ashrey, 2026-09-21, unprompted:** "on the letters migration failing on a container copy, I haven't really recorded much there, so even if we lost the information, it is alright."

He is factually right about the state. Three letters carry words — 13 bytes, 14 bytes, and one real 69-byte letter to Śarīrākarṣiṇī — and a fourth he deliberately cleared himself on 2026-08-24. The Well is barely begun.

**Effect, narrow and deliberate:** charter §7's first halt condition — "the letters migration fails on the container copy" — is **released**. If the migration fails on a copy, the build logs it here and in `RULINGS-QUEUE.md` and continues rather than halting. The locked-phone ruling (queue item 1) drops from consequential to routine.

**What this does NOT release, and I am reading it narrowly on purpose.** He said letters. He did not say practice data. The other three §7 conditions stand in full, and the second one — *any path would lose, duplicate or corrupt his practice data* — still covers the 74 recognition entries, the six crossings, and every ledger row. That is sixty days of daily practice and the entire reason Phase 0 existed. A narrow reading costs the build nothing; a broad one could cost him the thing he actually cares about.

**And the letters are safer than either of us needs them to be:** all three non-empty bodies are mirrored server-side in each Śakti's `Letter` field (`fldgASyV031Hr4sHp`), and `seedLetterIfMissing` restores a server body into a blank local row on sync. Local loss is recoverable from Airtable without a migration at all.

## 2026-09-21 · A non-ruling on the renderer, discarded before it could mislead

> **Superseded by "Renderer (charter §4)", further down this file.** That entry is the ruling; this one is only the record of why a first attempt produced none. Nothing here decides anything.

An agent reported a renderer ruling of "(a) SceneKit" that rested on the charter's default clause alone. It was honest about why: neither Garimā room existed, because both variant agents died before starting — `Could not read the repository git config to neutralize filter drivers` — so there was nothing to compare.

**Not accepted as the ruling.** The charter asks for the spike run two ways with the numbers logged, and a default taken in the absence of evidence is not that. Both rooms are now being built in prepared worktrees, and the real decision will supersede this note.

## 2026-09-21 · Why the first spike produced nothing: a host-contention failure of my own making

Worth recording because it will recur otherwise. Three agents were building concurrently, and two of them invoked `xcodebuild` with the **same** `-derivedDataPath`, corrupting each other's output. Host load passed 300 on an 8-core machine and `posix_spawn` began returning `EAGAIN`, so builds died with "Early unexpected exit" and "could not spawn" that look like test failures and are not.

The spike agent wrote eight good files and could never commit them; they were recovered and committed by hand as `55cf92b`. Its baseline census survives and is the trustworthy half — a pure function of the canvas's branch structure with no GPU or scheduler in it, so it reproduces exactly anywhere. Its *timing* half was taken at host load ~17 on 8 cores and is explicitly untrustworthy.

**The rule from here:** every concurrent agent gets its own named `-derivedDataPath`, never a generic one it chooses itself, and a spawn failure is treated as contention to wait out rather than a defect to edit around.

## 2026-09-21 · Renderer (charter §4)

**Ruled: (a) SceneKit geometry under a SwiftUI shader pass.** This supersedes the non-ruling entry above, which is left in place only as the record of why a first attempt produced nothing. There is one renderer decision in this file and this is it.

The charter's rule is narrow and I held myself to it: SceneKit holds the default, and **only** a measured performance failure, or a demonstrated inability to carry Design's three-layer depth and prismatic light where the canvas can, may displace it. Neither limb was met. The canvas did not lose on taste — it lost on the two questions the charter actually asks.

### How the comparison was run, so the numbers can be trusted

Both rooms were brought onto one branch (`spike-compare`, from the spike harness at `55cf92b`, merging `spike-scenekit` and `spike-canvas`, whose files are disjoint) and measured **in the same process, back to back, against the same control floor**, rather than by trusting two separate reports. Three passes: iPhone 17 (`DE414BA2`), iPhone 17 Pro Max (`16D04433`), then iPhone 17 again. Release configuration with the spike apparatus compiled in (`SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH" ENABLE_TESTABILITY=YES`), one `-derivedDataPath` reserved to this task and no other.

Every figure is a **simulator** figure on an 8-core M1 Air. Only relative standing means anything, which is why the control floor is subtracted everywhere and the shipped Mandala is measured in the same breath.

**Host load is stated rather than pretended away.** This machine has a standing background floor of roughly 5 tonight (`spotlightknowledged`, `fseventsd`, the wallpaper extension), and `xcodebuild` itself adds three or four. Every window sat between 4.4 and 11.1 — the same band the two builders' own accepted runs sat in, and nowhere near the 15–23 that had windows thrown out. The second simulator was shut down for the third pass to buy what headroom there was. The band is not clean, but it is **shared**: every number below faced the same weather in the same minute as the number beside it, and the ruling turns on the differences, not the absolutes.

### Frame cost, CPU milliseconds per frame above the control floor

Presented cadence discriminates nothing — every window in every pass pinned at 16.67 ms p95 — so CPU per frame is the number that does.

| scene | pass 1 · iPhone 17 | pass 2 · Pro Max | pass 3 · iPhone 17 | mean |
|---|---|---|---|---|
| **Garimā · SceneKit · first adaptation** | 2.955 | 2.371 | 3.210 | **2.845** |
| **Garimā · SceneKit · past the second** | 1.751 | 1.609 | 2.410 | **1.923** |
| **Garimā · SceneKit · reduce motion** | 0.050 | 0.553 | 0.128 | **0.244** |
| **Garimā · Canvas · first adaptation** | 3.178 | 2.582 | 3.299 | **3.020** |
| **Garimā · Canvas · past the second** | 3.085 | 2.632 | 3.044 | **2.920** |
| **Garimā · Canvas · reduce motion** | 0.022 | 0.055 | −0.007 | **0.023** |
| shipped · tier 0, all 102 seats · A | 1.795 | 1.960 | 2.164 | 1.973 |
| shipped · tier 0, all 102 seats · B | 2.071 | 1.710 | 1.711 | 1.831 |
| shipped · deep-zoom bloom · A | 3.171 | 2.573 | 3.152 | 2.965 |
| shipped · deep-zoom bloom · B | 2.671 | 2.859 | 2.881 | 2.804 |
| shipped · the descent · A | 3.985 | 3.397 | — | 3.691 |
| shipped · the descent · B | 3.829 | 3.692 | — | 3.761 |

Control floor, taken in each same session: 0.314 · 1.173 · 0.363 ms.

**Read it three ways and it says the same thing each time.**

- **Both variants are inside the envelope the shipped app already lives in**, on one of Design's heaviest rooms. Neither misses the performance bar. So the bar does not displace the default — it does not even come close to it.
- **SceneKit is cheaper at both adaptations, on both devices, in all three passes.** At the first adaptation the gap is small and inside the noise (2.845 against 3.020). Past the second it is not: **1.923 against 2.920**, a third less, and the sign never flips. The reason is structural rather than lucky. The SceneKit room gets *cheaper* as the room reverses — the rake dims, the shafts thin, the shadow caster lifts — while the canvas gets very slightly dearer, because a canvas re-issues every primitive every frame whatever the room is doing. Past the second adaptation is the state a practitioner who stays actually reaches.
- **The tail is markedly better.** SceneKit's worst frame was 37.0 ms once at the opening (first shadow map and shader warm) and 16.67 — nothing at all — in five of the other eight windows. The canvas's worst frames at the first adaptation were 48.8, 51.2 and 73.6 ms across the three passes. The shipped canvas in the same sessions produced 105 ms and 303 ms worsts. A canvas's cost is a long CPU closure that can be interrupted; a scene graph's is a submission.

### Memory, and the honest reading of it

On the two iPhone 17 passes, where the whole process is one arena and the shipped scenes sit between the two rooms: canvas 39.7–40.1 MB peak, shipped Mandala 40.3–41.3, **SceneKit 46.6–47.9**. About **+6.5 MB**, and it is accountable rather than mysterious — a 1024² forward shadow map, three strata meshes for base plus two morph targets, and SceneKit's own runtime. It does not grow between the first and second adaptation.

The Pro Max pass cannot be read for memory and I am not going to quote it as though it can: `phys_footprint` is a process high-water mark, the canvas suite happened to run first in that process, and its 58.7 MB therefore carries the launch that the later control's 51.4 MB does not. That is an ordering artefact, not a finding.

+6.5 MB is a real cost and it is the price of the ruling. It is not a performance failure.

### Draw cost, exactly, from the deterministic censuses on this branch

| | per frame |
|---|---|
| Garimā · SceneKit | **15 draw submissions** (13 colour, 1 shadow, 1 SwiftUI light pass), 24,346 triangles, 460 points — constant across all three windows |
| Garimā · Canvas | **125.7 mean / 128 worst** primitives — air 2, farWall 2, sideWalls 3, mass 14, strata 30, crests 10, impression 2, bloom 2, dust 62, veil 1 |
| shipped · tier 0 | 263.1 / 270 |
| shipped · deep-zoom bloom | 79.6 / 85 |

These two counts are **not comparable one for one** and nobody should quote "15 against 126" as a win: a canvas primitive is a fill or a stroke, a SceneKit draw is a whole indexed mesh. What is comparable is how each **scales**. Adding a fourth object to a SceneKit room costs one more submission. Adding a fourth layer to a canvas room costs however many fills that layer contains, on the CPU, every frame. The canvas builder's own honest example is the one that decides it: Sarva-Yoni's membrane is a two-dimensional surface, and a 30×30 mesh in that idiom is 900 fills rather than 30. Ring 4's fourteen nested shells and Mahātripurasundarī's nine depths are the same shape of problem. The heaviest of Design's authored eight lands mid-envelope in SceneKit, which means the other seven have headroom; in the canvas the surface rooms do not.

### The second limb: depth and prismatic light

This is where the canvas's own case collapses, and it collapses on a finding its builder reported against itself.

**The SwiftUI shader needs a `.metal` file in a build target.** `ShaderLibrary` builds only from a compiled `.metallib`; there is no from-source initialiser. A `.metal` file cannot be `#if DEBUG`-ed out. The canvas builder called this its headline finding, could not engineer around it, and therefore **shipped a room with no shader at all** — every lighting term in it is hand-derived arithmetic. It then reasoned that SceneKit "gets the same capability for free."

I checked that both ways rather than taking either side's word.

- **The claim about the file is true, and it is true of this branch right now.** `default.metallib` (11,232 bytes) is present in the Release `.app`, built from `GarimaSceneKitRoom.metal`, even though every Swift file in `Views/Spike/` is compiled out of Release. The folder header's promise that "nothing here can exist in a build that reaches Neev" is false for exactly one file. Named, not buried — see the consequence below.
- **The inference from it is wrong.** SceneKit does not need that file to carry a shader. `GarimaSceneKitRoom` already runs its dust through `material.shaderModifiers`, which is a **Swift string compiled by SceneKit at runtime** — no build-target file, nothing in the shipping binary. `SCNProgram` and `SCNTechnique` take source the same way. So the permanent Metal file is *optional* for SceneKit and *unavoidable* for a canvas, because a canvas has nowhere else to put a shader.

Which means the charter's second limb reads the opposite way round from how the canvas argues it. Design's three-layer depth — the building, the world, her mechanism — is a compositing discipline in a canvas and simply the truth in a scene graph: three z positions and occlusion, perspective and fog resolve themselves. And on prismatic light, **neither renderer can do true dispersion today** — SceneKit's lights are RGB and it would take a custom `SCNTechnique` — but the canvas is strictly further from it, not closer. (b) does not carry the light where (a) cannot. The reverse.

Two further asymmetries in the same direction, both from the handoff rather than from preference. The gem table (§4.1) is a **light behaviour** table: topaz 0.20 hard, pearl 0.95 "sourceless — no directional light at all", cat's eye 0.10 "one hard travelling band". In SceneKit, Ring 7 having no directional light is one line. In a canvas every one of those is a gradient somebody authors and a falloff somebody fakes, 102 times. And the defects Design actually hit — five rooms going dark, one blowing out to white, Ring 8's triangle falling off-frame, Ring 1's Mātṛkās reading as one flat surface with no floor for light to fall across — are *authoring* defects of exactly the kind a hand-projected renderer produces and a projection matrix does not. The canvas builder shipped four visually wrong versions of this one room before the fifth; multiplied by 101 that is a schedule, not a rounding error.

### The strongest argument against this ruling

**It is the aniconic law, it is real, and I can see it in the evidence rather than only read about it.**

A lit 3D solid reads as a THING in a way a canvas fill never does. The SceneKit builder said so plainly and named four passes of work to get one mark to stop reading as an object. It is not fixed. In the composite still of the SceneKit room past the second adaptation, her mark has grown into a large pink lozenge lying on the floor in the middle of the frame — lit, discrete, plainly a solid. It does not trip `LawsTests`, and it is not figural, and it is still exactly the failure the law exists to prevent: a free-standing object where there should be an action. The canvas's same moment is an impression in the ground that has become the room's source, and it could not be mistaken for a thing.

Multiply that by 102 rooms and 26 attribute forms — a noose, a cup, a bow, a plough, a skull-cup as lit solids — and the risk is a props cupboard. `LawsTests` cannot catch it, because it is about what a lit mesh *looks like*. The canvas keeps you honest by default; SceneKit will not.

**So the ruling carries a rule, and the rule is binding rather than advisory.** Every attribute in every room is **an action on the room's own material** — an impression, a furrow, a crack, a swell, a compaction — and never a free-standing emissive solid. Phase 3.1 encodes this as an API shape, not a note: the room-building layer offers no way to mount a lit object that is not bound to the surface it acts on. Design's own §4.4 already says the attribute stops being an object past the second adaptation and grows into the room; SceneKit makes obeying that mandatory rather than optional.

I also weighed the charter's restraint clause — *when in doubt, choose the more restrained option* — because it is the one thing that could have flipped this. It does not, and the reason matters. That clause governs what a room **does**, not what draws it; it is an instruction to build the quieter room, which is as available in SceneKit as in a canvas. Reading it as "choose the renderer that is harder to overdo" would let it override the charter's own §4 test, which is specific and which SceneKit passes. The restraint belongs in the material rule above, where it now is.

Second-strongest, and worth stating because it costs real work: **SwiftUI cannot screenshot a `CAMetalLayer`.** `drawHierarchy(afterScreenUpdates:)` returns the shader layer floating on black, and `ImageRenderer` will do the same. Design's legibility register is 204 real renders — the check that found five dark rooms and one white one — and under this ruling it has to go around SwiftUI to `xcrun simctl io`. The Portrait's `ImageRenderer`, any share card and any snapshot test inherit that. Measured here, not assumed: the in-process SceneKit snapshot of this room reads mean luminance 0.077 → 0.079 across the two adaptations with the light pass *missing*, against the canvas's 26→168 and 24→251 out of 255 from a real `ImageRenderer`. The geometry half alone passes the never-black floor; the composite is only visible off the simulator's display.

### What would have to be true to revisit this

Any one of these, and it is reopened rather than defended:

1. **A room whose surface is two-dimensional costs more than the descent.** Sarva-Yoni's membrane and Ring 4's fourteen shells are the two that would show it first. The bar is the shipped descent's 3.7 ms above the floor, on the same ruler in the same session.
2. **The +6.5 MB does not stay flat with nine ring worlds resident.** It is one shadow map and one mesh set today. If nine lighting rigs and their maps live at once, re-measure before Phase 3.2 ships.
3. **The material rule cannot be enforced in code.** If Phase 3.1 cannot express "an action on the room's own material" as the *only* way to mount an attribute, then the aniconic risk is unbounded and the argument above loses its answer.
4. **The composite capture cannot be automated.** If the 204-render legibility register cannot be driven off the simulator's display reliably, the charter's §3 checks lose a register and this ruling loses a precondition.
5. **A ring's lighting rig cannot be tuned without a person looking.** Nine rigs is nine tuning passes. If the luminance-spread check cannot stand in for the eye, that is a one-person-maintaining-102-rooms problem the numbers do not see.

### What Phase 3.1 creates first, under the ruled renderer

The rite of entering is the charter's next queue item, but it cannot be the first file — it needs a room to arrive into. In order:

1. `iOS/Bindu Mandala/Homes/Render/RoomUnits.swift` — the conversion, written down **once**. Design's constants are three.js numbers: light intensity, emission, world scale, field of view, the rim box's proportions. The SceneKit builder had to re-derive almost every one of them by hand for a single room. 102 rooms is 102 sets of that unless this file exists before the second room does.
2. `iOS/Bindu Mandala/Homes/Render/RoomMaterial.swift` — the aniconic rule as an API. An attribute mounts as an action on a surface — impression, furrow, crack, swell — and there is no call that mounts a free-standing emissive solid. This is the answer to the strongest argument against the ruling, so it is built before anything that would need it.
3. `iOS/Bindu Mandala/Homes/Render/RoomScene.swift` — the spine. `SCNScene` assembly with the three depth layers as named node roots (the seat shell, the world's weather, her mechanism), the camera, the stride-smoothed ground follow that stops the 1.5-unit pop at a bed seam, and the `pose(at:)` seam that keeps a room a pure function of scene time so it stays assertable without a renderer.
4. `iOS/Bindu Mandala/Homes/Render/RoomLightRig.swift` — the `Atmosphere` port as light rather than as palette. Her hue from `Atmosphere.derive`, `HomeGem.diffusion` driving shadow radius, intensity and **whether the room has a directional light at all** (Ring 7's pearl at 0.95 has none), the world's `veil` as fog density and its `tempo` scaling the world clock only, never her adaptation clock.
5. `iOS/Bindu Mandala/Homes/Render/RoomLightPass.metal` — the full-screen light pass, moved out of `Views/Spike/` to a real home. It is production code the moment this ruling lands, and moving it also ends the one false sentence in the tree: the Spike folder's header promises nothing in it reaches a Release build, and `GarimaSceneKitRoom.metal` compiles into `default.metallib` in Release regardless of `#if DEBUG`.
6. `iOS/Bindu Mandala/Homes/Render/RoomView.swift` — the `SCNView` bridge plus the `.colorEffect` pass, and the real non-animated reduce-motion path: `isPlaying = false`, `rendersContinuously = false`, `scene.isPaused = true`, pose once, draw once. Measured at 0.05–0.13 ms above the floor on iPhone 17, so it is genuinely still rather than slowed down, which FIDELITY requires.
7. `iOS/Bindu Mandala/Views/Rooms/RiteOfEnteringView.swift` — the three beats as the distance travelled toward her, self-paced by touch, compressed on return, never a timer and never skipped.
8. `iOS/Bindu MandalaTests/RoomSceneTests.swift` — the geometric half of sister divergence (Design's fingerprint check, above 10%, which is the only automated defence against a room keeping her numbers and losing her look), the per-room continuity assertion against the seam pop, and the luminance-spread floor at both adaptations.
9. `iOS/Bindu MandalaTests/RoomCaptureTests.swift` — the composite capture that goes around SwiftUI, because the legibility register depends on it and `ImageRenderer` cannot see the layer.

Items 1, 2 and 5 are the three that exist because of *this* ruling rather than in spite of it. If the ruling is ever revisited, they are the files to read first.

### The suite

310 tests executed, 0 failures, 10 skipped (the gated bench windows, which were run separately in Release), zero Swift warnings. `LawsTests` reads the real source tree and judged **both** spike rooms as production files; neither draws anything figural, says a number out loud, or adds a second POST.

## 2026-09-21 · Phase 3.1a · The render spine, and the binding condition made unrepresentable

`iOS/Bindu Mandala/Homes/Render/` is the layer all 102 rooms are built on: `RoomUnits`, `RoomMaterial`, `RoomScene`, `RoomLightRig`, `RoomLightPass.metal`, `RoomView`, with `RoomSceneTests` and `RoomCaptureTests` judging them. 423 tests, 0 failures, zero Swift warnings on a clean Release build and a clean Debug test build.

**The binding condition is the point of this phase, and it is now four different kinds of impossible rather than one kind of discouraged.** The renderer ruling named its own precondition — *"if Phase 3.1 cannot express 'an action on the room's own material' as the only way to mount an attribute, then the aniconic risk is unbounded and the argument above loses its answer."* A free-standing lit solid needs four things, and the spine withholds all four:

1. **A place in the air.** The only placement vocabulary is `SurfaceCoordinate` — two numbers on a surface. There is no type in `RoomMaterial.swift` that can name a point in space, so there is nowhere for a free object to be. Its third number is not a parameter: it is whatever the surface *is* at that point, after it has been acted on.
2. **A body.** `RoomMaterial.swift` imports Foundation and nothing else, and names no mesh, node, geometry or shape. The vocabulary contains no noun that denotes an object — only five verbs that denote something happening to material: impression, furrow, crack, swell, compaction, which is the ruling's own list and is not extended.
3. **Its own light.** `SurfaceAction.glow` is not a brightness. `RoomMaterial.emission(at:)` multiplies it by how far that action actually moved the material at that point, so **a mark that does nothing to the surface emits nothing, anywhere, at any strength.** That is arithmetic, not a convention, and `testLightCannotExistWithoutDeformation` proves it over all five verbs at full brightness and zero depth.
4. **A constructor.** `SurfaceAction`'s memberwise initialiser is private; the five verbs are the only way one exists. A sixth has to be written into the file where the ruling is.

And two more registers beyond the type system. **The mechanism hook**, `RoomSurfaceMechanism.actions(at:stage:) -> [RoomSurfaceKind: [SurfaceAction]]`, is the door Phase 3.3's authored eight walk through: its return type has no path out for a node, a mesh, a light or a shape, and the `RoomStage` it is handed carries no scene to reach around into. **The scene graph**: Design's third depth layer is her mechanism, and under this shape it holds **no geometry at all** — only the light in the mark it made. `RoomScene.solidsInHerLayer` is a number the tests read, and it is zero in every room. The `SCNScene` is never handed out; a room is installed into a view or captured.

**The room is the body, and that is what makes one conversion enough.** The finding the whole units file rests on: *the grammar's altitude curve and the attribute's mount are the same curve in different units.* The grammar writes `(0.5 - alt) * 9` in rings 1–3 and `* 8` elsewhere; the attribute writes `(0.5 - alt) * 6.4 - 0.4`. Normalise the grammar's span into the room's own height and add the mount's own offset, and the two land on the same point in every ring at every altitude, exactly. `testTheTwoAltitudeCurvesAreOneCurve` asserts it across nine rings and twenty-one altitudes. So `RoomUnits.height(forBodyAltitude:)` — which reads `HomeAttribute.mount` rather than restating it — is the only vertical conversion in the instrument, and everything else is a consequence:

- the **floor** stands where the soles' extreme resolves to, the **canopy** where the crown's does;
- the **eye** stands where the body's own eyes are, read off `HomeGrammar.bodyZones` through the same conversion, not chosen;
- which **surface** an attribute acts on is whichever the altitude is nearest — the floor, the canopy, or a working face of the same stone standing at her altitude on a riser out of the floor.

**The consequence is the thing the spike had to find by trial, and it is now structural.** The SceneKit spike's first draft put a soles Śakti's eye 1.4 units above the floor and her mark climbed into the *upper* half of the frame — the inversion of a Śakti felt at the soles. Here nothing is tuned: `testHerMarkLandsWhereHerBodyAltitudeSays` asserts a soles mark below 55% of the frame and a crown mark above 50%, at the opening, at the first adaptation and past the second, and further asserts that **all eleven body zones read in order down the frame**. That last one is the check that fails the moment anybody tunes a camera per room.

**Four constants are genuinely new, and each says why in the file**: the room reaches four body-heights across and away; the eye inclines 0.55 of the way toward her mark (at 1 every Śakti's mark is dead centre and altitude stops meaning anything; at 0 the mark leaves the frame when the second adaptation brings it close); Design's 62° field of view, carried from the spike; and the two clip planes. `testTheRoomIsTheBody` reads all five render sources off disk and fails if 6.4, −4.6, 0.94, 227 or 347 is ever written down again.

**Ring 7's sourcelessness is one `if`, and it is a real absence.** `RoomLightRig.key` is `nil` in the seventh āvaraṇa — not dimmed — and with no directional light there is nothing to cast, which is Design's "no shadow anywhere" without a second setting to keep in step. The shader learns the same fact exactly once, as a zero rake direction, rather than from a ring number. The ambient is a single law for all nine (`ambientFloor + keyIntensity × diffuse × 0.45`), so the Crown ends up the brightest-ambient room in the instrument **because its gem is the most diffuse**, not because a branch was written to rescue it. Measured offscreen: mean luminance 0.528 at the first adaptation and 0.504 past the second, against ring 1's 0.109 → 0.126, ring 4's 0.042 → 0.066 and ring 6's 0.082 → 0.102. Design's first legibility check — neither black nor blown out at both adaptations — passes on all four, and it now runs on every room the moment one exists.

**The verb is read from the motion, never assigned by name.** Design's twenty-six forms already say in numbers what each moving part does at every instant, so `RoomInscription` classifies which of the five verbs a part is performing from its own velocity — fast and bright is a crack, coming down is an impression, going up is a swell, travelling across is a furrow, bearing down without moving is a compaction. That is the same discipline `HomeGrammar` uses for her physics, and it means law 1 holds here too: nothing is keyed by a form's name.

**Two things verified rather than assumed.** The `.metal` file: `PBXFileSystemSynchronizedRootGroup` picked it up with no pbxproj edit, and `roomLightPass` is in `default.metallib` in the **Release** `.app` (22,576 bytes) as well as Debug — `testTheLightPassCompiledIntoTheBundle` reads the built bundle at run time rather than trusting the build system. And the still path: `RoomDriver.posesApplied` reaches one with reduce motion on and stays there through three seconds of run loop, while the animated path passes ten poses in a second and a half; the camera does not move, and the pose it is frozen at is the settled one, `HomeMemory.secondAdaptationEnd` read rather than restated. A pose costs 0.034 ms on this host, so the still path's per-frame cost is not small — it is absent.

**Three smaller calls, logged because they are edits to files this phase did not own.**

- The spike's `private final class RoomScene` is renamed `GarimaRoomScene`. Swift refuses two top-level declarations of one name in a module even when one is file-private, and the ruling names the production file `RoomScene.swift`. A mechanical rename inside one spike file; nothing else moved.
- **The Spike folder's header was false, and is now true.** It promised that nothing in the folder can exist in a build reaching Neev; `GarimaSceneKitRoom.metal` compiles into `default.metallib` in Release regardless of `#if DEBUG`, because a `.metal` file cannot be conditionally compiled out of a target. The ruling had already named this; both headers now say it out loud. The spike's shader was **not** moved — moving it would break the room that is its only caller while the spike still measures, and the production pass is a new file rather than a relocated one. It leaves with the spike.
- A surface's emission map is written as four channels rather than one. A single-channel 8-bit `CGImage` reaches Metal as `r8Unorm_sRGB`, which the simulator's device rejects with a hard assertion — `pixelFormat (11) is not a valid MTLPixelFormat` — taking the whole test process down with it. Grey in RGB is the same light in a format every device carries.

**One finding recorded rather than papered over, in the same spirit as the grammar's kañcuka gap.** The nine worlds are one vertical climb, and `RoomUnits.worldFloorY(ring:)` keys it by ring rather than by the region's words — because two of Design's nine region names fall outside its own zone vocabulary. `Pelvis` reaches no rule at all and lands at the middle of the body, and `Above crown` reaches the `crown|above` rule and so shares the Crown's altitude exactly. Read off those words the climb would put a world below the one beneath it and two worlds at the same height. `testTheWorldClimbIsMonotoneAndTheRegionVocabularyHasTwoGaps` asserts both gaps out loud, so they stay a known finding; the fix belongs with the live rows, not with a word invented in the spine.

**What is deliberately not built.** The eight authored mechanisms are Phase 3.3 and this phase builds only the door they walk through. The rite of entering (`Views/Rooms/RiteOfEnteringView.swift`) is item 7 of the ruling's own list and is the next file, not this one — it needs a room to arrive into, and now there is one. The prismatic pass carries no true dispersion, exactly as the ruling recorded of both renderers.
