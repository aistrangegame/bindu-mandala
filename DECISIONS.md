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

## 2026-09-21 · Phase 3.1b · The rite of entering — three beats folded into travel

`Views/Rooms/RiteOfEntering.swift` (the ceremony, pure), `Views/Rooms/RiteOfEnteringView.swift` (the only thing that draws it) and `Homes/Render/RoomApproach.swift` (the crossing) build Build Brief v2 §3.1 on the ruled renderer. It is the first thing the walker feels every time he enters, a hundred and two rooms deep, so every number in it is Design's — read out of the working instrument (`The Homes - The Axis.html`: `STATION`, `beginEnter`, `advanceRite`, and the `mode === 'rite'` branch of its frame loop) — except the three departures named below.

**It is not a screen before the room.** The `RoomView` beneath the words is her real room from the first frame to the last, and the rite enters Garimā (kp 4), whose spike room is the proven one. `testTheRiteArrivesAtARealRoom` hosts the view, finds the live `SCNView`, asserts the room under it is kp 4's, asserts the walker is standing *outside* it, and captures the frame to prove it is a lit room rather than a black one.

### The two laws that meet at the threshold

**The ceremony compresses and never skips.** `HomeMemory.compression(visits:)` is *read* from `HomeMemoryStore` — `RiteOfEntering.toRoom(at:remembering:)` is the only door a screen should use — and it scales exactly one thing: how long a beat takes to write. Three beats happen on the first visit and three at the floor. Asserted at every compression Design's curve can produce, on both motion paths, over 400 visits.

**And none of it is said out loud.** Two checks, because there are two ways to break it. Design's nine MEASURING patterns run over every string the rite can compose for all 102 (the harness's own `Measuring`, reused rather than copied). And — the half no pattern can see — the rite's own two source files are read off disk and refused the vocabulary of returning: *welcome · return · back · again · before · stood · visit · remember · already · last time · once more*. "welcome back" carries no digit, so `LawsTests` would never have caught it. Her own content is deliberately out of that scan's scope: a Śakti whose phrase says *"Thank you for the hook that returns me"* is speaking about herself, and that is the base's language, not the rite's.

### The Axis's returning line — dropped, and this is the call the task asked for

Design's handoff (§4.9) asks for *one line, once, on returning*, and the Axis shows it in its status bar for the first fourteen seconds of a room already known. **It is not built.**

It is not a count, a streak or a percentage, so it does not trip law 2's letter. It fails its spirit, and it fails it at the one moment the instrument can least afford to: the compression is supposed to be **felt** — the ceremony is simply quicker — and a line announcing the memory replaces a felt thing with a told thing. It is also the only sentence in the whole instrument that would tell the walker that something is keeping track of him. The charter's restraint clause settles it (*"when in doubt, choose the more restrained option"*), and §2's laws outrank the handoff where they conflict.

What replaces it is what it was describing, and he gets both without being told: a ceremony that writes faster, and a room that opens at the head start his accumulated dwell earned. Reversible — it is one line — and logged to `RULINGS-QUEUE.md` so Ashrey can overrule it on sight.

**Design's three beat pips go with it,** for the same reason and more plainly: a lit dot, two dim ones, and a counter is exactly what the brief names in the same breath as a visit number. He knows where he is in the ceremony the way he knows where he is in a sentence.

### The rite is the distance, and the distance is a closed form

Design's Axis moves the walker with a per-frame lerp — `trav += (travTo - trav) * 0.03` — which is an exponential approach sampled at 60 Hz. `RoomApproach` writes it as the exponential it already is, with the time constant **derived** from Design's own rate rather than chosen (`tau = -1 / (fps · ln(1 - r))`, so `0.03` is 0.547 s and `0.018` is 0.918 s). Three things follow, and the arithmetic is the least of them: the walker's distance becomes assertable at any instant without a renderer, a dropped frame can no longer change where he ends up, and the reduce-motion path can genuinely stand still instead of being a loop that has been slowed down.

**The crossing is carried by the eye alone.** `RoomScene.stand(atApproach:)` moves the camera back along its own axis by one body-height (`RoomUnits.approachStandOff = roomHeight`, derived rather than tuned) and changes nothing else — no fog, no fade, no veil of its own. SceneKit's fog is a *distance* band and `RoomLightRig` already sets where it closes from the world's veil, so standing a body-height further out is genuinely looking through more of that world's air: thin in the first āvaraṇa, nearly opaque in the ninth. The approach adds one number to the instrument and gets the weather for free. It also adds no node, so the ruling's binding condition is untouched — `testTheEyeStandsBackWhileHeIsStillCrossing` asserts her layer still holds no solid at the far end of the crossing.

**The chamber clock does not run during the rite.** `RoomClock.held()` stands at the threshold and `begin(opening:)` starts it, once, at the head start. A ceremony that advanced the room's own clock would hand a walker who lingered over her name an adaptation he had not stayed for, and the adaptation is the whole instrument. The view opens that clock in exactly one place and the test reads the source to prove it.

### Reduced motion: quantized, and given the outcome

Design's invariant 4 asks for reduced motion *"longer and quantized, never disabled"*; `iOS/FIDELITY.md` — standing law under charter §2.10 — says the loops may not stay. The render spine already ruled this conflict for the room itself, and the rite takes the same reading for the same reason:

- the **crossing** is quantized. He steps to his station on each touch and stands there; no glide, no `TimelineView`, no render loop. The stations are still Design's stations, so it is quantized rather than shortened;
- each **beat arrives already written** — her phrase present, her name whole, her roots rejoined with her quality beneath — and still waits for his touch. All three beats happen. The walker is given the outcome of the ceremony rather than nothing.

### The three departures from Design, each named where it happens

1. **The prompt's alpha** is `0.55`, not the Axis's `0.44`. FIDELITY §4 sets the legibility floor for meaningful text at ~0.5, and the prompt is the only instruction in the ceremony.
2. **The prompt's type** is 11pt, not 9px, for the same rule, with its tracking scaled by the same proportion.
3. **No beat indicator**, above.

Everything else is Design's: the stations `[0, 0.3, 0.62, 0.88, 1]`, `(reduced ? 3.4 : 2.4) × compression`, the phrase's `0.34`/`0.94`, the three strokes with their `0.72` hold, the roots' `0.58`/`0.52`/`0.48`, the gloss's `0.6`, the release's `2.2`, and the strike at her carrier times 1, 1.5 and 2 — which `HomeCarrier` already owned, so the rite contributes only which beat.

### Her words come off her row, and every fall-back degrades to something true

Design's Axis reads the rite's three beats off its bundled cards. The app reads them off `Shakti` — `appreciationPhrase`, `devanagari`, `etymology`, `quality`, four real Airtable fields the sync already fills — because a bundled card table is the ghost roster the laws exist to prevent. Where a field is empty the fall-back is never an invention (invariant 5): her Devanāgarī falls back to her name, which is the same name in another script; her roots to her name's own compound parts, which are in the name already; her gratitude to her āvaraṇa's, which is the gratitude of the enclosure she is seated in. `Avarana.appreciationPhrase(forRing:)` is new only in that the shipped instance property now has a static twin, so a room being built can reach it before there is a context.

**The etymology is read as roots only when it is one.** The field is free text in the base. It is split on Design's own join characters (`+ · — –`) and then *guarded*: more than one part, every part at most 24 characters, no full stop. A line of prose about her etymology is refused rather than chopped into half-sentences, and the beat falls back to her name's parts. This is FIDELITY §6's rule — guard the empties, never assume blank content — applied to a field whose shape is not guaranteed.

**Two findings recorded rather than tuned away.**

- **Design's suffix order is load-bearing and it costs something.** `riteRoots` tries `ākarṣiṇī` before `karṣiṇī`, so the suffix comes away whole and the *head* carries the sandhi's elision: Kāmākarṣiṇī splits `Kām · ākarṣiṇī`, not `Kāmā · karṣiṇī`. Re-sort the list and all sixteen Karṣiṇīs — Ashrey's home ring — split the other way. The ordered list is now asserted, so a tidying fails the suite instead of the ceremony. It is the fall-back in any case; the roots he actually sees come off her `etymology`, which the base carries for all 102 (FIDELITY §6).
- **Her roots begin rejoining before they have finished parting.** `join` opens at `0.52` and `split` does not complete until `0.58`, so the widest they ever stand is `0.52/0.58` — about 0.897 of the full gap, never 1. That overlap is Design's, and it is why the beat reads as one breath rather than two gestures with a pause between them. Asserted at that exact value.

### One thing the spine had wrong, found by building on it

`RoomView`'s still path posed the room at `RoomClock.settled` unconditionally, which was right while it was the only path there was and wrong the moment a walker could be standing outside the room. A walker with reduce motion on would have been handed a **fully adapted** room to cross toward — the end of a stay he had not begun — while the light pass over it drew the room's opening, so the two halves of one room would have been at two different instants. `RoomClock.stillInstant()` is now the single answer both read: her opening while the clock is held at the threshold, the settled state once it has begun. Asserted in both directions.

### The one thing only looking at it could find

`FIDELITY.md` §7 asks for a screenshot of any new screen driving the actual flow, and it earns its place here. The rite was green — 438 tests — and the first frame of it showed a room whose **dust was standing perfectly still**. Holding her chamber clock for the ceremony had held the āvaraṇa's weather with it, because the room is a pure function of one clock and the motes ride that clock. Design is explicit in the other direction: *"the weather is continuous — and it follows you into her room."* The air is the enclosure's, not hers, and it does not wait at her door.

`RoomScene.breathe(at:)` is that seam, and it is deliberately narrow: `pose(at:)` still sets the air to her own world time, so an entered room is byte for byte what it was and stays one clock; only the held path adds a second call, on the world's elapsed time. Asserted both ways — the air moves while he crosses, the room does not adapt while he crosses, and a pose brings the air back onto her clock.

No assertion about a room could have found this. A picture of it did, in one glance.

### A flake named, not fixed

`BinduMandalaUITests.testFeelHerOpensRecognition` failed once, on the **first** launch on a simulator created minutes earlier, and passed on every run after — at 19.99 s against its own 20 s budget. Its first assertion (Today offering "I feel her") passed, so the screen was up; what ran out was the ceremony's remaining budget on a cold store, a cold bootstrap and an unregistered font cache. Nothing in this branch is on that path. It is recorded rather than quietly widened: a timeout raised to make a red test green is the kind of edit that hides a real regression later, and the check itself is sound.

### The suite

438 tests, 0 failures, 10 skipped (the gated bench windows), zero Swift warnings, on a simulator reserved to this branch. Sixteen of them are the rite's.

## 2026-09-21 · Phase 3.1, reviewed — five findings fixed, one scheduled

The render spine and the rite were read back against the renderer ruling and the laws. Six findings; five were real and are fixed here, and the sixth is real but belongs to a later phase and is recorded rather than argued away.

### The binding condition had a fifth register, and it was open

`RoomScene` vended its three depth-layer roots and its camera as internal `let`s. **`let` on a class-typed property stops the property being reassigned and does nothing whatever about the node it points at** — and `RoomDriver.scene` is internal too, so `driver.scene.herLayer.addChildNode(SCNNode(geometry: SCNSphere(radius: 0.4)))` compiled from any view that owns a driver and would have put exactly the lit lozenge the ruling forbids into any of the 102 rooms. `solidsInHerLayer` could not see it: it is only ever read on a freshly constructed room. `RoomScene.swift`'s own header asserted the opposite.

The ruling names this as its own precondition — *"if Phase 3.1 cannot express 'an action on the room's own material' as the only way to mount an attribute, then the aniconic risk is unbounded"* — so this is the one finding that reopened it. All four roots are now `private`, and what a caller gets is facts: `layerName(_:)`, `childCount(in:)`, `solids(in:)`, `adaptingSurfaces`, `eye`. `private(set)` would not have been enough, and the check that keeps it shut is on the source rather than on a value: `testNoRoomHandsOutItsSceneGraph` reads `RoomScene.swift` off disk and fails the build if any stored property of a type in it names an `SCNNode`, `SCNScene`, `SCNGeometry`, `SCNMaterial`, `SCNLight`, `SCNMorpher`, `SCNCamera` or `SCNView`.

`RoomDriver.scene` is left internal deliberately. Once the spine vends no node, a `RoomScene` is not a mounting point for anything, and the tests need a live driver's room to read `posedAt`, `breathedAt` and `capture`. The door that was open is the one that is shut.

### The rite's motion flag and the view's were two flags

`RiteOfEnteringView` renders by `forceReduceMotion || the environment` and built its ceremony from `forceReduceMotion` alone. The production door — `RiteOfEnteringView.entering(_:remembering:)` — leaves `forceReduceMotion` false, so **a walker with iOS Reduce Motion switched on got the still rendering path driving an animated ceremony**: one evaluation, no `TimelineView`, landing at the instant the beat opened. Her phrase at 0.003 alpha, her Devanāgarī wholly masked, her roots at nothing, and `frame.prompt` still `nil` because the beat had not finished writing — with no second frame coming to correct any of it. A touch reset the stage and reproduced it for the next beat. The crossing failed the same way: an easing stretch sampled once, with the render loop stopped, leaves him at the door he started from.

A `View`'s `init` is not in the environment, so the ceremony is now built with **no** motion setting at all and takes one in `adoptMotion()` — on appearance and on every change of `accessibilityReduceMotion`. `RiteOfEntering.adopt(reduceMotion:at:)` applies the same two facts `crossing` and `releasing` already carry to a ceremony that has already begun: the beat is written, and the walker steps to his station. `forceReduceMotion` now travels that same road, which is what makes the hosted test real — `\.accessibilityReduceMotion` is read-only in `EnvironmentValues` and cannot be injected at all, so a test that set both halves could never have seen the gap between them.

### Two of the five verbs had no end

`SurfaceAction.relief(at:)` cuts off at four reaches, on the note that this is *"past the crack's own tail, which is the longest of the five"*. It was not. `furrow`'s profile is a function of `du` only — no `dv` term at all — so it held its whole depth for every `v` and the cutoff ended it at **100%** of its depth; `crack` falls off as `exp(-|dv|/3reach)` and was still at **26%**. On the floor, for one part of one attribute at its resting size, that is a 0.32-unit vertical wall across the room with a hard-edged rectangle of the mark's own light lying on it — square ends, discrete, an object, which is what the five verbs exist to prevent. It is reachable today: `RoomInscription.verb` returns `.furrow` whenever a part travels across the material.

The two directional verbs are now given a length that closes smoothly exactly at the cutoff. `testEveryVerbReachesNothingAtItsOwnCutoff` walks all five around their own cutoff square and holds both the relief and the emission to nothing there — the check that would have caught it.

### The ember was offset upward in every room

`RoomLightRig.install` and `RoomScene.pose` both put the mark's ember at `placement.height + roomHeight * 0.12` with no branch on the surface. For a Śakti whose altitude is the crown that is **above her own ceiling**: the canopy's normals point down into the room, so the one surface her attribute acts on receives nothing at all from the light that is supposed to be coming out of it. The key does not save it either — it is a directional light aimed down at the floor for almost the whole stay. Her marked surface was lit by the flat ambient and its own emission alone, and the grain the stone carries *"so a raking light has something to fall across"* was invisible. That is the authoring defect Design's verification pass named, with Ring 1's Mātṛkās reading as one flat plane.

`RoomUnits.emberOffset(for:)` is now one distance and three directions — above a floor, below a canopy, in front of a face — and both call sites read it. The whole-frame legibility spread could not see this (the floor carries it) and ring 7 could not either (the pearl world's fog masks a flat ceiling completely), so `testACanopyRoomsCeilingIsNotAFlatPlane` reads the top of the frame, in ring 8.

### The mark's light stood still while the mark travelled

Every surface's emission map was baked from `shapes.last` — the material at 347 s — while the mesh being rendered until the second adaptation is `shapes[0]`, and all three morph targets carry identical texture coordinates. The mark's own surface coordinate is `0.5 + mount.z/extent` and `mount.z` runs −4.6 → −1.2, so for the whole of a first visit the glow sat about 3.4 scene units in front of the impression it was supposed to be coming out of — on undisturbed floor, with the eye 7.8 units away. The arithmetic inside `RoomMaterial.emission(at:)` holds; the scene applied the wrong moment's map to the geometry, which is the binding condition's *"a mark that does nothing to the surface emits nothing"* broken one level up.

A texture cannot morph, so the light is carried at the same three moments the shape is — one per channel of the emission map — and weighed by the same two morph weights in a `.surface` shader modifier. The blend is exact at the three moments and linear between them, which is what the geometry does. `testTheMarksLightTravelsWithTheMark` asserts the light travels the same distance across the floor that the mark does; before the fix the three channels were one baked moment and that difference was exactly zero.

### The 94 grammar rooms do not yet reverse — recorded, not built

Design is explicit that *"the second adaptation is never 'more of the same': in every room it REVERSES the room's own premise"*, and `homes-grammar.js` authors a different reversal for each archetype. What the spine carries is the reversal's **stage** — the mark widening and nearing, the key handing its work to the mark, the gradient turning toward her — and it is the same stage in all 102 rooms. `HomeGrammar.Reading.displacement(time:amplitude:)` takes no deep term, and `HomeLabel.deep` is computed for all 94 grammar rooms and consumed by nothing.

**Not built here, and the reason is scope rather than disagreement.** Authoring nine archetype reversals in the surface vocabulary is a design act, not a review fix, and it belongs with the rooms: Phase 3.3 for the authored eight and 3.4–3.6 for the rings, through the `RoomSurfaceMechanism` door the spine already offers. What is fixed here is the overclaim — `RoomScene.swift`'s header now names what the spine does not yet carry, so the gap is a scheduled item rather than a property of the layer all 102 rooms are built on.

## 2026-09-21 · Phase 3.2 · The nine worlds as one climb

`Homes/Render/{WorldBands, WorldClimb, WorldClimbScene}.swift` and
`Views/Rooms/WorldClimbView.swift` build Build Brief v2 §3.2 on the ruled renderer, with
`WorldClimbTests` and `WorldClimbCaptureTests` judging them. Ruling 1 cut the nine worlds as
nine screens in July and this is what replaces them: one continuous vertical space the walker
rises through, where an āvaraṇa is a **weather** and a **clock** rather than a place with a door.

The tables were already ported — `HomeWorlds` carries `RING_CHARACTER` and `WORLDS`, and
`RoomUnits.worldFloorY(ring:)` already gave the climb real units. Nothing of either is restated.
What is new is the thing Design's file does sixty times a second, and the space it does it in.

### The nine clocks, and why they are not nine of the same number

Design gives each band its own rate and the rates are the whole argument of the phase: the feet
band runs a day, the pelvis a heartbeat, the navel a churn, the heart a lunar fortnight, the
throat a month, the forehead a season, the crown a solar half-year, above-crown a year, and
Totality kāla and akāla together. They are ported to the last decimal, and
`testEveryClockRateIsDesignsOwn` reads `homes-worlds.js` **off disk** and asserts each rate's own
expression is still in it — a table of numbers typed into a test proves only that somebody typed
the same numbers twice.

**They are not the same kind of number, and flattening them would have been a lie.** `0.05` at
the Feet is cycles per second into a modulo; `0.0398` at the Heart is radians per second into a
sine; `0.062` above the Crown is the angular velocity of a meridian; the ninth carries two at
once. `WorldBandClock` keeps the kind beside the rate, and `phase(at:)` is what makes nine kinds
comparable — how far round this band's own clock the world has come, whatever kind it is.

**The tempo is applied in exactly one place and it is not this file.** Every reading is taken at
`HomeWorlds.worldClock(_:ring:)`, which is the only door, and the felt period — the band's clock
through its own mental state — is what the walker actually experiences:

| ring | clock | period | × tempo | felt |
|---|---|---|---|---|
| 1 Feet | day–night `0.05` | 20 s | 1.00 | 20 s |
| 2 Pelvis | the hour `1.05` | 1.9 s | 0.82 | 2.3 s |
| 3 Navel | the day `1.00` | 6.3 s | 0.62 | 10 s |
| 4 Heart | fortnight `0.0398` | 158 s | 0.72 | 219 s |
| 5 Throat | month `0.0199` | 316 s | 0.66 | 478 s |
| 6 Forehead | season `0.0066` | 952 s | 0.50 | 1904 s |
| 7 Crown | half-year `0.0033` | 1904 s | 0.44 | 4328 s |
| 8 Above crown | year `0.062` | 101 s | 0.36 | 281 s |
| 9 Totality | kāla `0.008` · akāla `0.13` | 785 s | 0.28 | 2805 s |

The sixth āvaraṇa comes round some eight hundred times slower than the second, and nothing
anywhere says so. That is the phase.

**One finding recorded rather than tuned away: the periods are not a monotone ramp.** A *year*
above the Crown comes round in 101 seconds and a *fortnight* at the Heart takes 158, because the
year there is one sweep of a single band of light and the fortnight is a swell that has to be
waited out. The word names what the clock is a clock *of*, not how fast it runs.
`testTheBandPeriodsAreNotAMonotoneRamp` asserts it out loud, so a future tidying into a
descending ramp fails the suite instead of the instrument — the same guard `HomeWorlds.tempi`
already carries for the third āvaraṇa running slower than the fourth.

### The wall between the two clocks, asserted three ways

A slow āvaraṇa handing the walker a cheaper second adaptation than a fast one would be depth
bought by where he was standing rather than by how long he stayed. That is the never-measure law
at the timing layer, and it is the one thing in this phase that could break the whole instrument
quietly, so `testTheTempoNeverReachesAnAdaptationClock` closes it in three registers:

- `HomeWorlds.adaptationClock` returns its argument unscaled in every ring, while `worldClock`
  genuinely scales;
- the **same stay is the same stay in all nine worlds** — one position, one clock, nine rings,
  and `RoomPose`'s two adaptations are identical to the last bit at every mark;
- the **source**. The climb's three files are read off disk and refused the whole vocabulary of a
  stay — `chamberTime`, `firstAdaptation`, `secondAdaptationEnd`, `holdEnd`, `settling(`,
  `deepProgress(`, `RoomClock`, `headStart`. There is nowhere in them for a tempo and an
  adaptation to meet. And `tempo` appears in code in exactly two files in the whole shipping
  tree, pinned by exact equality: `HomeWorlds.swift`, where it is defined and applied, and
  `WorldBands.swift`, where a band's felt period is reported. A third has to be written down.

### An open world with a vast floor, not nine rooms stacked — and a picture is what settled it

The building is **one surface**: the ground of the world the walker is in. Design builds nine bands
at nine heights and shows only the near one; the continuous form of "only the near one" is one
ground whose *material* is the blend — a morph over the nine band materials, weighed by
`WorldClimb.weights(atFraction:)`, which are the same numbers the fog, the veil and the light are
blended over. Never more than two of the nine are non-zero, and the morph is **normalised**, so the
first band is the base and carries whatever weight the eight targets leave. There is no seam to
cross because there is no join, and the material cannot develop one the weather does not have.

It is also the *second* shape this phase had, and the first one passed every check.

**The climb was first built as a shaft** — a far wall and two sides, each running the whole nine
bands as a single mesh with each band's condition worked into its own stretch of it. Every
assertion in both suites passed: the nine clocks, the continuity of every quantity at two step
sizes, the eye's 0.18 units per quarter-second against a 0.25 bound, ring 7's zero directional
lights, and a luminance floor of 0.047–0.79 mean across all nine bands at both adaptations. Then
`FIDELITY.md` §7 asked for a picture of the actual thing, and the first āvaraṇa — *"low light
raking a vast floor, swinging horizon to horizon"* — was **a dark corridor with a few motes in
it**. Sixteen units of unlit stone in every direction, the floor a sliver at the bottom of the
frame, and the walker looking level at a wall.

Three findings, and all three are one: **the Axis is an open space and the climb was a corridor.**

1. **There was no ground.** A floor existed only at the very bottom of the climb, so from the
   second band upward the walker rose through a shaft with nothing under him. Design gives five of
   its nine bands a floor at that band's own `y`.
2. **The bands were therefore unlit.** Everything in frame was sixteen units away and fogged, and
   the stone is `ink` — the dhātu, taken nearly to black. A luminance floor cannot see this: a dark
   room and a dark corridor read the same to it.
3. **The shaft visibly ended.** The seventh āvaraṇa's luminous fog met the background in a hard
   horizontal seam where the wall stopped — a cut, in the one phase whose whole rule is that there
   are none.

The walls are gone. What replaced them is Design's own structure and it costs three meshes: the
climb is **two** — the ground, and the air. `RoomScene.mesh` and `RoomScene.morpher` build it, so
the ground is made the way a room's floor is made, by the same code.

**The ground is never placed.** The blended station is
`station(lower)·(1−k) + station(upper)·k`, which is exactly `WorldClimb.height(atFraction:)` — the
walker's own height on the climb. So the ground *is* the climb, and the eye stands its own
eye-height above it in every āvaraṇa exactly as it stands in a room. That also means it is always
underfoot, which is what a world with nothing under it was missing.

**The key light was standing inside the world it was lighting.** A directional light's shadow
frustum is built around its own position, and a body-height's stand-off put it among the ground it
was meant to be raking, so surfaces past its near plane came back unlit. It now stands a whole
room's width out along the direction it arrives from and looks at the ground the walker is on.

**One thing the ground cannot cross-fade, and the fix is arithmetic rather than a compromise.** A
band's own light sits in a *pattern* that is that band's — the Forehead's nine bodies are not the
Crown's five veils — and a pattern cannot be blended the way a number can. So
`WorldClimb.wholeness(atFraction:)` takes a band's light to **nothing** exactly where the walker is
equally in two of them, which is the one height at which the map may be exchanged without anything
being seen to change. It is `1` at every station and `0` at every midpoint, and it is continuous
everywhere between. It also swaps on a *placement* — half a band in one call is thirty bands a
second, which no hand can do, so it is a capture, a launch or reduce motion's quantized step, and
in all three the whole frame changed anyway. Without that second limb a climb that **opened** at
the sixth āvaraṇa wore the first's light, which is none, and its nine glowing bodies were simply
missing. Nothing in the suite could see it; the picture of it was blank where the picture of the
first band was not.

### Three more things only looking could find, after the walls came down

`FIDELITY.md` §7 earned its place four times in this phase, not once.

- **The world was behind the walker.** With the ground centred on the origin, the eye at
  eye-height sees only the far *fifth* of it — so eleven standing stones, nine bodies that glow and
  twenty-four ribs were almost all under and behind him. The ground is now pushed out by half its
  own width (`groundAhead = eyeZ − halfExtent`), so its near edge is exactly underfoot and the
  whole of it is ahead. One number, and the first āvaraṇa went from a dark strip to a floor of
  standing stones throwing long shadows.
- **The eye was level, and level is the sky.** It now inclines toward the ground it is crossing —
  and by nothing chosen: it is `RoomUnits.gaze`, the same `0.55` of the whole angle the eye
  inclines toward her mark in a room, applied to the angle down to the far edge of the ground.
- **The one travelling band had no light and no rake.** Above the Crown, Design's meridian is a bar
  with a constant material and no fog — *itself* light — and its sweep stands at `y` while its
  ground is at `y − 3.6`. The port read the elevation as almost nothing, so the one band of light
  arrived exactly parallel to the ground it was supposed to be crossing, and the eighth āvaraṇa was
  dark for the whole year. Both are Design's own numbers: the rake is `3.6` over a radius of `16`,
  and the band's own glow is its halo, `24 + s·14` of its own `38`.

And the light in the ground is **this world's** light rather than white: her lift, through
`Atmosphere` and `HomeGem`, the same colour the key and the ambient already are. A band that glows
from within was turning its own stone grey.

Measured offscreen, all nine bands at both adaptations, after: mean luminance 0.033 (above the
Crown, *"everything else waits in the dark"*) to 0.533 (the Crown's own luminous fog), with real
spread in every one of them — never black, never blown out, never flat.

**Design's own arithmetic is the blend, read as what it is.** `lerpColors(fogCols[i0], fogCols[i1], k)`
is a tent on each band's station: `1` at the station, `0` a spacing away, and the sum over the nine
is exactly `1` at every height, so a blend is a weighted mean and cannot dim at a boundary.
`testTheBandsOverlapSoNothingIsEverEmpty` asserts the sum, and that two or three bands are always
near — Design's `|worldY(ix) - climb| < WORLD_SPACING * 1.15`.

**The crossing is asserted twice, because there are two ways to fake it.** At quarter-second
resolution over the whole rise at Design's own rate, the eye moves less than a quarter of a scene
unit between samples — the spike's own bound, from the check that caught the eye popping 1.5 units
across a seam at t = 314. And in height rather than in time: every quantity the walker is given —
the veil, the fog's colour and density, the key's strength, the ambient, the glow, the air's drift
and the **stone's own relief** — is swept across all eight boundaries at two step sizes, and
**halving the step must halve the largest change.** That is what continuity actually means; a
generous absolute bound can be satisfied by a small cut, but a quantity with a step in it changes
the same amount however finely it is sampled.

### One light in the whole climb, and the seventh āvaraṇa has none

The renderer ruling named its own revisit condition 2: *"the +6.5 MB does not stay flat with nine
ring worlds resident; if nine lighting rigs and their maps live at once, re-measure before Phase
3.2 ships."* It is answered **structurally rather than by measurement.** Design's file gives each
band its own rig — nine keys, nine ambients, two shadow maps. There is one key in this climb and
one shadow map, and where it stands, what colour it is and how hard it burns are the blend of the
bands the walker is between. The memory is a constant, and the crossing is continuous by
construction rather than by nine rigs being cross-faded.

Ring 7 is then what it has always been: `keyNode.light` is set to **`nil`**, not dimmed, and with
no directional light there is nothing to cast — Design's *"no shadow anywhere"* without a second
setting to keep in step. It is read from `HomeGem.isSourceless` rather than from a ring number, so
the fact lives in one place for the instrument. `testTheSeventhAvaranaHasNoDirectionalLightAnywhere`
closes it in the band's reading, in the blended weather at its station, and in the scene graph
(`activeKeys == 0` there, `== 1` at every other station) — and asserts that the absence **arrives
by travel**: the light fades monotonically to nothing as the walker comes to the station and
returns as he leaves. It is a place he passes through, not a switch that is thrown.

### The bands are conditions in the stone, not a props cupboard

Design's JavaScript builds each band out of objects — eleven standing stones, seventy-two ribs, an
octahedral prism, nine glowing solids. Under the renderer ruling none of those may be a
free-standing lit solid, and **none of them needs to be**, because Design's own comments say what
each band is actually for and in every case it is the light and the air rather than the object:
the Feet's stones are *"things that exist only to be raked — long shadows are the weather"*; the
Heart is *"three spectra crawling over glossy ground"*, which is the caustic and not the
octahedron; the Throat is *"light arrives only in shafts between ribs"*, which is the gap and not
the cylinder; the Forehead is *"nothing is lit from outside"*, which is emission in the material.

So a band's condition is worked into the ground's own stone with `RoomMaterial`'s five verbs, and
**the vocabulary is not extended by a word**: the Feet's stones are swells, the Pelvis's seven
travelling rings are rows of impressions, the Navel's churn is scattered cracks, the Heart is
compactions only (a caustic needs a clean surface), the Throat's colonnade is stacked furrows, the
Forehead's nine bodies are swells that *glow*, the Crown is all but flat, above the Crown there is
one furrow and nothing else, and Totality is the yantra's own crossing lines. Design's counts are
Design's counts; the cylindrical placements are not, because they do not survive being flattened
onto a wall and no attempt is made to pretend otherwise.

**The binding condition therefore holds on the axis too, and in a stronger form.** Design's third
depth layer is her mechanism, and on the axis **there is no her** — so the climb has two layers,
not three, and `testTheClimbHoldsNothingStandingInTheAir` asserts the whole scene holds exactly
two meshes: the ground the walker stands on, and the air he stands in. Every band's stone is on
`.wall`, which `RoomUnits` names as the one surface no attribute ever acts on (*"a wall is not
where a body is felt"*) — so nothing on the axis can be mistaken for a Śakti's mark, even though
what it is drawn on is a floor. And the glow goes through
`RoomMaterial.emission(at:)`, so the Forehead's nine bodies light and the untouched stone between
them does not: `testTheStonesLightCannotExistWithoutItsRelief` finds zero points emitting where
nothing happened to the material.

### The one band where Design's own two files disagree

`bandForehead` places **no directional light at all** — only an ambient and nine point lights
inside the bodies — while the gem table (handoff §4.1) gives ruby 0.55 diffusion and the ruling
makes the Crown the *only* sourceless āvaraṇa. Ring 6 keeps a key, at the floor of what a key can
be (`WorldBands.keyFloor`, named rather than written inline so a second band cannot quietly
acquire a nearly-absent key and pass for sourceless), and the glow carries the band. The reason is
Design's own verification pass: a surface with no raking light on it reads as one flat plane,
which is the defect it hit with Ring 1's Mātṛkās. The Crown's absence stays `nil`, and nothing in
the file can produce a `nil` key for any other ring.

### Rising

Design moves the walker two ways and both are ported. The settle — `climb += (target - climb) *
0.06` — is the same per-frame lerp `RoomApproach` already turned into the exponential it is, so it
is **reused rather than rewritten**: the derivation `tau = -1/(fps·ln(1-r))` lives in one file and
the climb contributes only Design's rates. The rise — `target += dt * 3.4`, against Design's own
`SPACING = 30`, so `3.4/30` bands per second — is a steady stretch over the distance left. Both
are closed forms, so the walker's height is assertable at any instant with no renderer and a
dropped frame cannot change where he ends up.

The unit is **bands**, not scene units. Design's spacing is 30 three.js units and ours is one
body-height, because `RoomUnits` builds the room as a body and the climb is that body nine times
over; every one of Design's climb numbers is therefore ported as a proportion of the spacing,
which is the unit-free fact.

**Reduced motion is quantized, and no band is skipped.** He steps to the next station and stands
there — genuinely stands, at any instant, forever — which is the same reading the render spine
took for the room and the rite took for the crossing. Design's own reduced rate (`0.035`) is
ported and then deliberately not used to animate; it is kept as the evidence that the departure
was taken knowingly. `WorldClimbDriver.standsApplied` is the proof as a number: it reaches one and
stays there however long the view is on screen, while the animated path passes ten in a second and
a half.

### No rail, and the name is not a measure

Design's Axis puts nine ticks down the right edge with the current one lit and the ones already
met dimmed. **It is not built.** Phase 3.1 already ruled its twin when it dropped the rite's three
beat pips — *"a lit dot, two dim ones, and a counter is exactly what the brief names in the same
breath as a visit number"* — and nine ticks with the met ones dimmed is that same readout over a
whole instrument, and the one place on the climb that would tell the walker something was keeping
track of him. What replaces it is what it was describing, and it is the entire point of the phase:
**he knows where he is because the weather tells him.**

The āvaraṇa's name is drawn, and that is a different thing: `Trailokyamohana` names an enclosure
the way a room's label names a room, carries no count, and says nothing about the walking. It is
read off the base where the base has been reached (law 1) and falls back to Design's table where it
has not, and it is clearest at a station and faintest between two, so it reads as the air changing
rather than as a header standing over the world. Its floor is FIDELITY §4's legibility floor and
it never goes below it.

### One edit to a file this phase did not own

`RoomLightRig.applyFog` had the fog's distance band written inline. It is extracted as
`RoomLightRig.fogBand(density:)` and `applyFog` now calls it, so the climb reads the same law
rather than a second copy: the āvaraṇa's air is one thing whether the walker is standing in her
room or rising past it, and a second copy would drift the day somebody retunes one of them. No
number changed.

### What is deliberately not built

**Sound.** Design's Axis grounds its voice on the climb (`HomeSound.root(forRing:)`), and the
carrier belongs to Phase 3.9, where it goes live in every room. Wiring a second audio path here
would be the kind of thing that is easiest to get subtly wrong (handoff §7 puts sound last, for
exactly that reason).

**Navigation.** The climb is not yet reachable from a screen, for the same reason the rite is not:
the Homes layer is being built from the bottom and the building becomes walkable at §3.7, the
corridor. Nothing in the app changed.

## 2026-09-21 · Phase 3.3 · The Gate, and the deep term the second adaptation was missing

`Homes/HomeBecoming.swift`, `Homes/Render/{RoomReversal, ReleaseRoom, PressRoom}.swift`, with
`GateRoomTests` and `GateLookTests` judging them. Ruling 10 governs: the authored Gate is
**accepted**, so Laghimā (khaḍgamālā 3) and Garimā (khaḍgamālā 4) are hand-built rooms resolved
through the authored map by position, and no grammar-only proof is required. 481 tests, 0
failures, 10 skipped, zero Swift warnings, and a clean Release build.

### The deep term, which is the heart of this phase

The Phase 3.1 review found that the second adaptation was **one generic intensification shared by
all 102 rooms** — the mark widening and nearing, the key handing its work to the mark — and named
the reason exactly: `HomeGrammar.Reading` carried no term a room could read to say what its own
premise *becomes*. `HomeLabel.deep` said the reversal in words for all 94 grammar rooms and was
consumed by nothing. Design is explicit that *"the second adaptation is never 'more of the same':
in every room it REVERSES the room's own premise"*, so a room that does not reverse is a loop.

`HomeBecoming` is that term, and it is deliberately four fields. A reversal, said as plainly as
Design says it, is **which part of the room carried the premise**, **which part answers it**, how
completely the first yields, and how far the second takes over. Everything downstream — which of
the five verbs the answering material performs, how far that is in scene units, what it does to
the light — is read from those in `RoomReversal` and nowhere else.

**It is written in the room's four surfaces rather than in a new enum of its own.**
`RoomSurfaceKind` imports nothing that can draw and names no geometry; its own header says it
states the binding condition *"in the coordinate system before `RoomMaterial` states it in the
API"*. The instrument has already paid once for a duplicated table — the body zones, ported twice
on parallel branches and unified afterwards — and a second list of "the parts a room has" would
drift the same way. The consequence is that **the binding condition now reaches one layer further
out than it did**: there is no case in either field for a thing in the air, so a reversal that
wanted a free object to arrive has nowhere to name it.

**`takes` is signed, and the sign is the meaning.** Ring 5's gift becomes the ground he is
standing on and arrives *at* him; Ring 4's gesture expands through fourteen shells and leaves
*past* him. A term with no sign would make those two rooms the same room. Which verb the answering
material performs is then *read from the travel* — toward him is a swell, away from him an
impression — which is `RoomInscription`'s own discipline, not a second one: nothing is keyed by an
archetype's name.

**The ten archetype reversals are read out of Design's own builders,** each with the deep sentence
it prints and the number its `update(t)` actually drives with `b` quoted beside it. All ten
tuples are distinct and `testNoTwoArchetypesReverseAlike` holds them apart, so a Vāk Devī's room
and a Nigarbha Yoginī's no longer turn alike. That is what the other hundred inherit: **101 of the
102 rooms now carry a reversal**, and the exception is recorded rather than filled in — the ninth
āvaraṇa's single Śakti has no archetype to inherit from, because the grammar declines to speak for
the Bindu, and inventing one for her would be the generic intensification under a new name. Her
room is authored and arrives with the rest of the eight.

### The second register a reversal needed, and why it is not a loosening

`RoomSurfaceMechanism` now also carries `stations(at:stage:)`. A ceiling that descends and a floor
that lets go are two of the eight rooms Design authored by hand, and neither is a thing *added* to
a room: they are the room's own stone, standing somewhere else. The whole return type is
`[RoomSurfaceKind: Double]` — a distance per surface, over an enum with four cases — so there is
nothing an object could arrive as, and `testAMechanismCanOnlyReturnActionsOnSurfaces` now pins both
signatures and refuses the protocol body the whole SceneKit vocabulary.

**Two rules govern every station, and neither is a constant.** A surface travels a fraction of *its
own distance to the walker*, because how far the canopy can come down is how far the canopy is and
that is a different distance from how far the floor can rise. And the fraction saturates —
`takes / (1 + takes)`, so Design's largest growth reaches 0.81 and nothing reaches 1. **The room
comes toward him and never reaches him**, as arithmetic rather than as a clamp somebody has to
remember.

### The two rooms

**Garimā presses, and the reversal is not the press undone.** Design wrote her reversal out in her
own file: *"the weight was never above you. It is what you are standing on, and it has been holding
you the whole time."* So nothing is given back. The mass closes six sevenths of its own distance to
him through the first adaptation and lifts away through the second; the strata **stay compacted and
go on deepening** (`0.5 → 2.4 → 3.8` in Design's numbers, carried as the ratio and normalised
against `RoomInscription.markDepth`, because a three.js displacement scale over a normalised map
says nothing about how deep a bed is in a room one body tall); and what the pressing made rises
into a plinth and carries him. Measured: her mark is a hollow **1.05 units below the floor beside
it** at the first adaptation and a plinth **0.24 above it** past the second, and the bedding away
from the mark is deeper at the end of the stay than at the first adaptation.

The plinth's depth is **read off the room rather than chosen**: it fills the hollow the pressing
actually made at that point — every bed and the crater together, measured — and then stands two
marks proud of it. One is Design's own growth of the press; the other is one whole mark, because
*her attribute is still working in the top of the plinth*. The mechanism acts first and her
attribute acts into whatever the room turned out to be, so the palm goes on pressing into the
plinth after it has risen, and without that mark's worth the two cancel and her mark ends the stay
a shallow hollow — the room having reversed everything except the one thing he is looking at.

**The spike's one breach does not come across.** `Views/Spike/GarimaSceneKitRoom.swift` mounts the
palm's mark as a cylinder with its own emissive material, lying on the floor, and Design's three.js
does the same. That is a free-standing lit solid — the props cupboard in one object, and precisely
what the ruling was written to prevent. Here the press is a **compaction**, its light is the
ground's own emission and is therefore multiplied by how far the ground moved, and her layer holds
zero solids at every moment of the stay.

**Laghimā lets go, and the reversal is not absence.** Design hit two defects in this room and only
this room, and both are pinned on the real render.

Her rising field *"stacked additively to pure white at arm's length"*. It cannot recur, and not
because it was remembered: there is no additive field in this room. The only thing the mechanism
can do is act on the canopy's own material, and a surface's emission is `min(1, …)` of a value
already bounded by how far the material moved, so there is no quantity here that can accumulate.
Measured at the first adaptation: **0.0% of the frame at white**, mean 0.0996.

And she *"went dark at the second adaptation, because the walls departing left an empty room"* —
which is a real hazard here, because the walls departing *is* the reversal and the floor has
already let go, so at the turn this room genuinely has no floor and no enclosure. Design's fix is
the design of the reversal and it is honoured literally: *"as the walls go, the opening they were
hanging from takes the whole room."* Measured: mean **0.0996 → 0.1151**, brighter past the second
adaptation than at the first, with the opening's own material widening by more than half again.

**The one place the verb is read the other way.** `RoomReversal` answers with a swell, because
material taking the work over usually comes toward the walker. An opening is the exception by
definition — it is material that has *drawn back* — so Laghimā's canopy mark is an impression
widening upward while the canopy itself descends toward him. That is Design's lid exactly: a rim
that comes down and a mouth that opens. The verb is still read from the travel rather than assigned.

**They diverge by 0.888 of ninety-eight geometric components**, against Design's tenth. This is the
geometric half of the fingerprint that had waited on rooms existing: where each of the room's four
surfaces stands, and what the material of the two that carry marks is doing, at seven moments of
one stay, quantised to two decimals exactly as `homes-verify.js` quantises. Design chose this pair
as its own sample-before-batch gate and measured them at 100% of geometry; 0.888 is the same
finding at a different resolution. They differ at the opening, at the first adaptation and past the
second, so it is not one moment carrying it.

### Three defects only a picture could find, and the rules they turned into

`FIDELITY.md` §7 keeps earning its place. Phase 3.1 was 438 tests green when the first frame of the
rite showed the āvaraṇa's dust standing perfectly still. Phase 3.3 cost three more, and **every one
of them passed every check in the suite first**.

- **The floor rose to the walker's chest.** The generic reversal let the ground take the work over
  by standing somewhere else, and Garimā's floor came up three units of a room six and a half tall
  — a pale wall filling four fifths of the frame with every bed she had made lost behind it. The
  rule it became is a fact about walking rather than a tuning: **the ground never comes toward
  him**, because he is standing on it and a floor that rose toward his eye would have to have
  lifted him, and nothing in the instrument moves the walker. A ground that answers does it as
  material. Going away is untouched, which is Laghimā's whole premise.
- **The ember was inside the hill.** Her mark's light stands off onto the walker's side of the
  material it is in — and the material had risen two units, so the light ended up under the top of
  the plinth, and an omni light inside a mound lights the whole mound. `RoomScene.markRelief`
  carries how far the marked surface stands at the mark at the stay's three moments and blends it
  by the same weights the mark's own light is blended by. This is the same fix as the emission
  map's, one level out.
- **The riser stood in front of her face.** It is a box a third of the face's own span deep, and
  centred on the face's plane it put half of itself between the walker and her mark — **in every
  room a Śakti is felt between the soles and the crown**, which is most of the hundred and two.
  Nothing in the spine could see it: the rite and the legibility spread both look at rooms whose
  mark is in the floor, and Phase 3.3 took the first capture of a face room. The riser now rises
  behind her working surface, and `RoomUnits.riserDepth` is one number both places read.

A fourth, smaller: Garimā's press grew nearly threefold and brightened at once, at exactly the
moment the mark is nearest the eye, and stopped being a press and became the frame. It now widens
by Design's own growth and **dims** by Design's own mount fade, `1 - b * 0.55` — the same fade
every attribute in the instrument carries, for the reason she wrote it: *"the attribute stops being
a bright thing and becomes part of what the room is made of."* And the crater is wide while the
light in it is not, which is Design's own arrangement: her mount opens the whole inscription out,
while what she *lights* is one press.

`GateLookTests` is the harness that takes those pictures, kept rather than thrown away — the rings
still to come will need it, and a capture nobody can re-take stops being true. It asserts the one
thing a still can assert on its own and Design's legibility register asks for: **the room visibly
changed.** Read relative to how bright the frame was, because an absolute threshold said so on its
first run — Garimā's whole frame lives between 3% and 36% of the scale, and a mass descending the
height of the room moved a twentieth of full range and read as nothing at all.

### One check waited rather than weakened

`testTheRiteArrivesAtARealRoom` asserts the āvaraṇa's air goes on moving while the walker is at her
threshold, and did it by sampling after a fixed pause — which additionally asserts that SceneKit
drew a frame inside that pause, a statement about how busy the machine is rather than about the
room. Under the full suite it was sometimes false; in isolation it passed three times out of three.
It now waits for the air to move, up to four seconds. The assertion is unchanged: if the weather is
held, it never becomes true and the test fails. A timeout raised to make a red test green hides the
next regression; a wait that still fails on the real condition does not.

## 2026-09-21 · Phases 3.2 and 3.3, reviewed · the two clocks that were not moving

Eight findings read back against the code, the laws and Design's own files. Six were real; two of
those were the same defect stated twice, and two of the eight are rejected with reasons. 485 tests,
0 failures, 10 skipped, zero Swift warnings.

**Every new check was mutation-tested**: each fix was put back the way it was and the check that
guards it was re-run. All six fail on the old code and pass on the new. A check nobody has seen
fail is a check nobody has tested.

### The two blockers, and they are both clocks

**The climb's air was frozen.** `WorldClimbDriver` handed the scene
`Date().timeIntervalSinceReferenceDate` — about 8.1 × 10⁸ — and the motes are driven through a
shader `float`, whose ulp at that magnitude is **sixty-four seconds**. Measured: `uTime` took two
distinct values over 3600 frames, so every mote in all nine bands held one offset for a minute and
then teleported, and `uDrift` — the Navel's churn, the highest in the climb, *"the air will not
settle"* — multiplied into a constant and did nothing. This is the Phase 3.1 defect FIDELITY §7 was
written for, recurring in the one file no picture had been taken of, and no capture could see it
because a capture is handed small numbers.

The climb now has what a room has had since Phase 3.1: an **epoch**. The driver counts from the
instant the climb opened, exactly as `RoomClock.elapsed` does, so the band clocks also start where
Design's start — at zero — and the number reaching the shader stays small for the life of the view.
The check reads the value *after* the narrowing, on a driven view, and additionally asserts the
clock still has the resolution to register a frame.

**A band's own light was never exchanged during a climb.** The exchange was gated on
`wholeness <= 0.0001` — a window five hundredths of a thousandth of a band wide — and at Design's
rise the climb advances 0.0019 bands a frame, so a walker who is *travelling* never lands in it.
Simulated over the branch's own arithmetic: **zero exchanges in a whole rise from the Feet to
Totality**. Rings 1, 2, 3 and 5 are given no light of their own, so a walker who climbed to the
sixth āvaraṇa stood in it with an all-black emission map: the Forehead's nine bodies that glow from
within — *"nothing is lit from outside"*, the band's entire condition — simply absent, and the same
for the Crown's veils, the meridian above it and Totality's yantra. Every capture and every test
passed, because both *put* the walker at a station rather than walking him to one.

The window is now the crossing rather than a point on it: `whole <= max(0.02, 2 · travelled)`. Both
terms are derived rather than chosen — 0.02 of wholeness is one per cent of full glow, which cannot
be seen to change, and `2 · travelled` is exactly the crossing frame's own wholeness at any speed,
so a drag, a flick, a launch at the sixth āvaraṇa and reduce motion's quantized step are one line
instead of a second clause about being put somewhere. The check drives the scene the way the driver
does, a frame at a time, and asks whose light the ground is wearing at each of the eight stations,
up and back down.

### Three more, fixed

**The heartbeat was steering the shadows.** The blended key's *direction* was weighted by each
band's pulsing intensity, so between the Feet and the Pelvis the one shadow-casting light in the
climb was dragged overhead by every systole and fell back — 21° of invented motion in a single
frame, against 0.06° of real motion in the bands themselves. The Feet's eleven standing swells,
which Design says *"exist only to be raked"*, strobed with the beat. Direction is now blended by
**how near a band is** and by nothing else; how much light it gives is the separate sum it always
was. The check is not an angle somebody chose: between two frames the key may turn as far as the
furthest a band near him turned and no further, which is why it needs no exception for the one real
seam in Design's source — `Math.sin(ang * 0.6) * 26` is not 2π-periodic, so the Feet's sun steps 14°
once a day-cycle, and Design's track is allowed to do what Design's track does.

**A departing enclosure was widening instead of rising.** `ReleaseRoom` sends the walls away with a
negative station and `RoomScene` applied it as a scale of where each wall stood, so Laghimā's walls
moved **outward** — and *"nothing in this room falls, including the room"* came out as the room
getting bigger, which is Mahimā's authored premise and the one thing the Gate exists to keep
separate. Design's own line is a lift: `w.position.y = 1.4 + b * (15 + i * 2.4)` on walls thirteen
tall. The sign now carries the whole meaning: toward him is the enclosure closing in, away from him
is the enclosure going the way everything loose in that room has been going. A station is also
applied as a **distance** rather than as a scale, because the sides stand closer in than the far
wall and one station was meaning two different travels. `RoomScene` publishes what the enclosure
*did* — how far it rose, and the furthest any wall now stands as a fraction of where it began — as
two scalars, because every check in the suite stopped at the station it was handed.

**Garimā's press was lighting the floor instead of showing it.** The emissive mark grew by Design's
`press.scale.setScalar(1 + b * 1.8)`, but Design's press is a cylinder seven units away on a floor
forty-six wide, while here the mark also rides her mount toward the walker: past the second
adaptation the lit disc was 2.8 times its resting footprint and lying under the eye. Measured on the
render, the near half of the frame went **0.081 → 0.343** with the structure in it unchanged, so
structure per unit brightness fell by four — a pale wash with every bed she had made lost inside it,
which is the failure the file above it says it avoided, one step further in. Emission is additive
and is not shaded by the surface normal, so a lit *area* erases relief instead of revealing it.
Design's growth is now carried where growth can be seen without costing the room — the crater
widens, the mark deepens, the plinth rises — and the light stays the size of a palm. Measured after:
**0.081 → 0.224**, and the floor her press lights no longer grows at all (0.0075 → 0.0072 of the
surface, against 0.0583 before).

**The residual is not her light and is recorded rather than tuned away.** With her press's glow
zeroed entirely the near half still reads 0.187, and with the ember zeroed as well it reads 0.171
against 0.078 at the first adaptation: what fills the bottom of that frame is **the plinth he is
standing on**, which is this room's reversal — *"the weight was never above you; it is what you are
standing on"* — lit by her mark's own ember riding the material it is in, which is the Phase 3.1
spine rule. Two new checks hold the line where it now stands: the floor her press lights may not
spread as the stay deepens (stated exactly, in the room's own material), and the near half of the
frame may not more than triple in brightness between the adaptations (4.21 before, 2.75 after) —
because a whole-frame mean cannot tell a lit room from a washed one, and the frame that failed was
0.2064 overall, inside every luminance bound in the suite.

### Two rejected, and why

**"The climb's air is frozen" and "the band's own light is exchanged only on an exact-zero test"
were each raised twice.** They are one defect apiece, fixed once apiece.

**`ReleaseRoom` carries nothing of Laghimā.** It is true that its stations and actions read only the
stay, and that `PressRoom` is hers in specifics. It is not a defect: **Design centres this opening**
— `lid.position.y = 8.4 - b * 5.4`, a ring built at the room's origin with no x or z at any moment —
and Ruling 10 accepts the Gate as authored, so the port's job here is fidelity rather than
invention. An opening that takes the whole room and an opening off to one side are two different
rooms. What makes the room hers is that her attribute acts in it at her own coordinate, over the
material this mechanism moved, and that the premise is hers by authorship. Position is identity and
only khaḍgamālā 3 resolves here, so there is no second row whose frames could be compared. The file
now says all of this out loud, which is what was actually missing.

---

## 2026-09-21 · Phase 3.4 · Ring 2 — the sixteen crossings (charter §4, "every ring's rooms")

Design's `crossed(world, card, G, syllable, cross)`, built on the Phase 3.1 spine as
`Homes/Render/CrossingRoom.swift` and reached through `RoomMechanisms.forRoom` by the archetype the
resolution order already read from her ring and her position. Seven marks a side; the far half runs
at Design's `t + 3.2` and `ph + 0.5` and converges onto the near half as the stay deepens. Ring 2 is
the one ring whose rows ship in the binary and sync from the base, so every number below was tuned
and measured against her real quality, tattva, bodily location and bīja.

### The ordering finding, confirmed on the shipped sixteen

Every Karṣiṇī's quality says *"she who attracts"*, and the classifier's twelfth rule is
`ākarṣaṇa|karṣaṇa|magnet|attract` → `draw`, two rules behind the five elements. So **her tattva is
what claims her**: Fire takes 29, 34 and 41; Air 30 and 33; Space 31, 32 and 40; Water 35 and 39;
Earth 36, 38 and 44 — and only Cittā, Ātmā and Amṛtā, whose tattvas the classifier has no element
for, are left holding the ring's own drawing. That is the truthful answer for Consciousness, the
Self and the Deathless, and nothing overrides the classifier to make the ring look more various than
the base says it is. Recorded as a test so a re-sort of the fifty rules shows up here too.

### Four calls

**Design's growth is spent on the room, not on the mark.** `s.scale.setScalar(1.4 * (1 + b * (isKey
? 2.6 : 1.2)))` is a scale on a glow sprite, and Design's sentence for it is *"the organ she was
given grows until it is the room around him"*. Spent literally it ends the stay a quarter of the
surface across **with its own light on all of it**, and seven of those converging came back as a
pale structureless mass across the middle of the frame with every ring she had pressed lost inside
it — `PressRoom`'s own finding (*"a lit area erases relief rather than revealing it"*) a second time,
and Design's first Laghimā defect a third. The growth is therefore carried by the **enclosure**,
through `becoming.takes`, which is `RoomReversal`'s own rule that a wall answers by moving rather
than by being marked; the key pairing's enclosure goes furthest of the sixteen, which is Design's
`isKey`. What is left for the mark is the instrument's saturating fraction of the same number — half
again as wide by the end of the stay, and still a mark.

**The near half is drawn and the far half is lit.** Design says which is which in the materials
rather than in a comment: the near half is seven tori with a tube radius of 0.028 on a
`MeshBasicMaterial`, the far half is seven glow sprites. A tube of 0.028 in a petal of 11 is a line,
and a line lights nothing. So the near half is a shape pressed into her wall and read by the room's
own key raking across it — `PressRoom`'s bedding idiom — and the light in the room is the far half
arriving. It also makes the reversal legible *in light*: what she drew is dark and formed, what she
was given is the only thing burning, and by the end it is burning exactly where the drawing is. Each
mark takes `1/√7` of the light, the same root `RoomInscription` shares one mark's worth of material
among a rosary's beads by.

**Design's lengths are read against the body, not against the surface.** A Karṣiṇī's working surface
is her own face, one body square, and the floor and the ceiling are four bodies across. Read as
fractions of *the surface*, the same arc came out four times smaller on a ceiling than on a face —
and on a face every ring she pressed was **shallower than the stone's own grain**, which is a mark
nobody can see in a room whose only content is marks. Looking at it was conclusive: seven rings,
buried. Lengths are now Design's own against her thirteen-tall room, carried into this one's
`roomHeight`, and a check holds every room's deepest mark above `grainRelief` and at or under
`RoomInscription.markDepth` — the room is not a quarry, and fourteen marks do not get fourteen
answers to how deep anything may go.

**The depth is normalised against the kernel's widest term, not against the amplitude.** The
displacement kernel multiplies its amplitude by as much as 2.2 (`widen`), so normalising by the
amplitude alone rails the fast axes at ±1 for most of every turn — and a railed mark has stopped
carrying her phase. Measured, it cost Cittā and Ātmā: both drawing, both felt on a working face,
their halves pinned to the same two depths for most of the stay and their rooms **4.3% apart** on the
geometric fingerprint, well under Design's tenth. Against 2.2 nothing rails. A test walks all
fifty-one kinds and fails if one ever reaches further.

### Two things the ring needed that the layers below it did not have

**The body-zone vocabulary did not reach the words the base writes.** Design's eleven zones were
written against Design's own card strings — *"Forehead, eyes"*, *"Solar plexus, shoulders"* — and
`Shakti.bodilyLocation` on the sixteen that actually ship says `head`, `solar`, `ears`, `skin`,
`tongue`, `nose`, `temples`, `sacrum`. **Eleven of the sixteen fell to the middle of the body**: her
mark at the same height and the eye inclined the same way in eleven of the home ring's rooms, with
one of the four channels that make a room hers carrying nothing. Seven zones are **appended** —
never interleaved, so nothing that resolved before resolves anywhere else now, and `forehead` still
reaches the brow before it reaches `head` — each interpolated between altitudes Design already
fixed. `skin` is deliberately left out: Sparśā is felt wherever skin meets world, and a location
that is everywhere resolves to the middle, which is the answer the fall-through already gives.

**Fifteen of the sixteen said the same sentence at the one moment the room turns over.** The crossed
tag was `pos == 44 ? "body and mind were one point" : "the drawing and the drawn are one"`. Design
composes the other fifteen from a `CROSSED` table of its own — `34: ['form','ear']` and so on — and
that table **cannot be ported**: it is keyed to Design's card tattvas, and the base's are different
ones. Design's card gives Rūpā the ear; the row the app syncs gives her fire. A bundled copy would be
the ghost roster law 1 exists to prevent, and a wrong one. So the crossing is read off her own row —
the faculty out of her quality, the thing she is given out of her tattva — and each of the sixteen
says her own reversal. Design's shape without its last word: Design's crossings are a faculty and a
sense organ, so *"were one sense"* is true of every one of them; the base's are a faculty and an
element, and calling earth a sense would be the sentence saying something the row does not. Where the
row genuinely carries no crossing — Cittā draws consciousness and is given Pure Consciousness, which
is one word twice — the ring's own sentence is kept rather than one that says the same thing twice.

### The fingerprint, widened for a ring

`GateRoomTests`'s port reads five probes down the middle of the floor and the ceiling. Fifteen of
the sixteen act on a **working face**, whose material is read across as well as away; two surfaces
nothing happened to are two blocks of identical zeroes that dilute every real difference toward the
threshold; and on a face her altitude reaches neither the station nor the material, because the face
*is* her altitude — so a print that could not see the frame would be blind to one of the four
channels. The ring's print therefore reads a five-by-five grid on the surface her body puts her on,
**every action on it in order** (verb, place, reach, depth, glow — which is exactly what Design's
`fingerprint(chamber, t)` writes for each object, in the vocabulary that replaced objects), and where
her mark stands in the room. All **120 pairs** clear Design's tenth; the closest is Gandhā ↔ Śarīrā
at **0.300**, two Earth rooms a body's middle apart. A second check refuses the print itself if more
than half its components read the same in all sixteen rooms, so the measure cannot be passed by
dilution.

## 2026-09-21 · Phase 3.5, pass three · Ring 1's ten Mudrās — and the one Design line law 4 would not let through

Ring 1 is **not one ring of twenty-eight**. Design splits it three ways by position
and writes three different builders, and the brief asks for three passes for that
reason: a Siddhi is a power exercised, a Mātṛkā is a sound that makes, and a Mudrā
is a closure that seals. This is the third pass — khaḍgamālā 19–28 — and it
completes Ring 1 and therefore the first two full rings of the instrument.

### The one place a law overrode Design's handoff

Design's Mudrā builder prints two sentences and the second is
`'the seal has opened its hand'`. It is a **walker-facing string naming a body
part**, in the one family of the hundred and two where a mudrā genuinely *is* a
hand in the tradition — which is exactly where law 4 can least afford it. The
charter is explicit (§2): where the handoff and a law disagree, the law wins.

`HomeGrammar.tag(for:…)` now says **"the seal has opened, and let go of what it
held"** — the same event, which is Design's own
`held.scale.setScalar(… + b * 3.6)`, with the figure taken out of it. The near
line, *"a seal you stand inside"*, is Design's own and is untouched.

### The aniconic law, measured rather than asserted

Design's own comment for this builder is *"five fingers of the seal, **as vaults
you stand between**"*, and the vaults are the resolution. A word is not a check,
so each of the three rooms is asked for a property a body does not have, and
`testNothingInTheTenReadsAsABodyPart` measures it:

* **The seal is its own mirror image.** Design's five angles are `±0.9, ±0.45, 0`,
  so vault `i` and vault `4 − i` reflect across the walker's own axis at every
  moment — the reflection is in the across-axis and Design's opening turns about
  the other two. A hand is chiral; the thumb is what makes it one.
* **The five are one span, and the middle is the shortest.** Measured
  `6.517, 6.135, 5.990, 6.135, 6.517` — longest-to-shortest **1.088** against a bar
  of 1.2, and the shortest is the middle, which is the inverse of a hand's profile.
  Design's own geometry; the outer vaults run further because their arc carries
  more across the room.
* **The seal is a sphere with the walker at its centre.** Nothing in the room ever
  comes nearer him than the ring it springs from: the nearest thing in the room,
  over every vault, every sample and every moment of the opening, is **exactly
  5.000** — Design's own `footRadius` — and what the seal holds, at `(0, 0, -7)`,
  is exactly five as well. A hand is a thing you look at from outside; this closes
  around him and leaves the middle empty. *(The first version of this check
  measured from the centroid of the five feet and failed at 0.956. The feet stand
  on a 103° arc and the centroid of an arc sits close to the arc — the fan's centre
  is the room's axis, not the mean of its feet. The corrected statement is the
  stronger one.)*
* **The membrane is eight-fold.** Design's veins stand at `(i / 8) · 2π`, equally
  spaced on one circle, with three concentric sources beyond.
* **The triple stands the same figure three times.** A body occurs once.

Over all ten, no walker-facing line and no attribute shape names the hand's
vocabulary. **And the first run found the over-reach in the check itself**: it
failed on khaḍgamālā 24 for saying *"the kāla of the eyes"* — which is her
`bodilyLocation`, where she is felt in the walker's own body. `LawsTests` makes
exactly that distinction and refuses to flag the somatic fields; the list here is
now the hand's vocabulary, which is the figure this family is actually in danger
of. Design's card words `hand` (kp 21) and `palm` (kp 22) resolve through
`HomeAttribute.kin` onto `linedDisc` — *a disc bearing three lines* — which is the
aniconic mechanism working rather than a breach of it.

### The three families, measured against one another

The check the whole of item 3.5 exists to pass, and the only ring that needs it.
Two means over `RingOneFingerprint`'s geometry, asked of the rooms **the grammar
speaks for** — Ring 1 holds seven authored rooms (1, 2, 3, 4, 6, 27, 28) and
Ruling 10 exempts them from the grammar-only proof; a hand-built room is an outlier
in whichever family it sits in by construction, so folding them in would flatter
the measure in one direction and the sisters in the other. Their positions are
printed beside the assertion rather than folded into it.

| | within the family | |
|---|---|---|
| Siddhis | **0.280** | |
| Mātṛkās | **0.422** | |
| Mudrās | **0.668** | |

| between families | |
|---|---|
| Mudrās ↔ Siddhis | **0.728** |
| Mudrās ↔ Mātṛkās | **0.730** |
| Siddhis ↔ Mātṛkās | 0.393 |

**The claim holds where the brief makes it**: a Mudrā stands further from a Siddhi
(0.728) and from a Mātṛkā (0.730) than the widest-spread sisters in any one family
stand from one another (0.668, the Mudrās' own).

**And a finding that is recorded rather than tuned away.** Siddhis and Mātṛkās
separate at 0.393, which is *below* the Mātṛkās' own internal spread of 0.422 —
two Mothers differ more from each other than a Mother differs from a Siddhi. The
cause is visible in the print: `RingOneFingerprint` reads forty-eight mark slots
plus a count, and a Mātṛkā's mark count is her own row's channel (6 to 15 marks,
5 to 14 letters), while a Siddhi's is always seven. So the padding pattern that
separates the Mudrās decisively — eighty-six marks against six or seven — is the
same padding that fails to separate the other two. The measure is Design's own and
was cut in pass one; re-cutting it here would quietly restate what passes one and
two proved. The finding belongs to Phase 3.10's refinement pass, and the honest
reading is that the Siddhi and the Mātṛkā are told apart by what their rooms *do*
— a train receding, a ring with one point of light travelling it — rather than by
this print's mark census.

### Three readings of Design this pass makes

**1 · A vault springs from the stone and lifts clear of it.** Design's arch rises
nine units over a room that has air in it; this instrument's rooms have surfaces
and nothing else, and `RingOne.Place` has no third axis that could name a point in
the air — deliberately, since Phase 3.1. So how far the arch stands off its surface
is carried as **how much of a mark it makes there**: full where it springs, fading
to the stone's own grain at the crown. That is a vault seen in the floor it rests
on. `TripleRoom` uses the same reading and needs it more: on a working face all
five of its receding loops stand at the same place on the panel, and the fading is
the only register the material has for saying which is further away. The first
version of that file anchored the fade at the room's origin instead of at the
figure's nearest point, which on a face put every loop at zero lift — five frames
drawn exactly on top of one another, and a room with no depth in it at all.

**2 · The seal opens by pivoting where it springs.** Design's
`d0.rotation.x = b * 0.42 * (1 + i * 0.1)` mixes the room's height and its depth,
so the arch tips over — its crown dropping and travelling — and the outer vaults
tip furthest. Taken about the vault's own foot, so the seal opens rather than
slides, and monotone in the second adaptation, which is what lets
`testTheSealOnlyEverOpens` say that this room never grips. A closure that lets go
and a closure that closes are the same five shapes and opposite rooms.

**3 · What the seal holds is let go, and its light goes with it.** Design's
`held.scale.setScalar(… + b * 3.6)` on a sprite at `0.5 + 0.3 * k - b * 0.2`.
Carried literally that is a lit area growing four-and-a-half-fold on the surface
the walker is looking at — the pale structureless wash `PressRoom` found with a
picture, `CrossingRoom` found again, and `MatrkaRoom` found a third time by a
different door. So the opening is **bounded by the seal's own foot** — what it held
may open until it fills the ring the vaults spring from and no further, because
past that nothing is holding it — and the rest of Design's 3.6 is spent where the
instrument already spends it: `HomeBecoming.archetype(.mudra)` carries
`takes: -3.6`, so the canopy travels away by 0.78 of its own clearance. Measured on
the render, all ten rooms end the stay at **0.0% of the frame at white**, with the
mean rising from 0.075–0.104 at the first adaptation to 0.099–0.213 past the
second and the spread never falling below 0.29. The room opens; the picture does
not.

For the same reason all three of this pass's rooms make **one** answer rather than
two: none of them also calls `RoomReversal.actions`, because each already answers
on its own material — the seal opening, the aperture opening, the one seal
arriving — and a generic answering mark on top is the second brighter disc
`MatrkaRoom` had to find with a picture.

### The two authored rooms

**`MembraneRoom` · kp 27 · Sarva-Yoni.** Design's `chamberMembrane`, and a womb —
which Design resolves before the port has to, by building a **lathe**: a surface of
revolution with a transmissive material, eight veins and one aperture. The room's
signature is its enclosure: `vessel.scale.set(1 + br * 0.032, 1 - br * 0.02, …)` on
`br = sin(t * 0.28)` — the enclosure **breathes**, at every instant of the stay,
widening as it shortens. Ring 1 now holds four enclosures and each is a different
fact about one: Aṇimā's closes in, Mahimā's never arrives, Laghimā's leaves at the
turn, and this one is never still and never leaves. *No door · you were always
inside*, said as a station rather than as a word. The reversal is Design's own
material change — `thickness × (1 − b · 0.72)` — carried as the enclosure yielding,
with the source-aperture opening (`0.7 + 0.4k + b · 0.5`) and the three vessels
beyond (`NEST = [1.55, 2.3, 3.2]`) arriving concentrically past the turn. *It was
never one womb.* Design's veins run down the *inside* of the vessel; the walker is
inside it, and what the inside of a surface of revolution looks like from inside is
eight spokes going out from its axis — so they arrive on the surface as a rosette,
with Design's own profile term carrying the descent.

**`TripleRoom` · kp 28 · Sarva-Trikhaṇḍā.** Design's `chamberTriple`, and the
sharpest reversal in Ring 1. One number carries the whole room: `sep` runs from 1
to 0 over the first adaptation as three copies of one figure slide into register
and the single seal arrives — *three rooms · one seal, only in stillness* — and
then hands over to a **breath**, parting and rejoining for ever. Design's own
comment is that the trinity is one movement and not a puzzle that resolves, and the
room's second line is *three and one, and always both*. Design's four rails per
ghost are **not carried**: they are how a line-drawing in empty space reads as a
room, and here the loops are cut into the room's own material, which already *is*
the room — a mark running the whole depth of a surface is one long flute, which is
`EndlessRoom`'s own finding made with a picture.

Both were keyed in Design's `BY_NAME` as `Sarvayoni` and `Sarvatrikhaṇḍā` against
cards reading `Sarva-Yoni` and `Sarva-Trikhaṇḍā`, so in Design's shipped Axis
neither room is ever reached and its harness cannot see it happen. Reached here by
khaḍgamālā position, and asserted from both ends.

### The numbers

All **45 pairs** of the ten clear Design's tenth on the geometric fingerprint,
closest **kp 19 ↔ kp 25 at 0.578** over 581 components, of which 127 (22%) are
silent — well inside the half the dilution guard allows.

## 2026-09-21 · Phase 3.4 and 3.5, reviewed: what the review found, what was taken, and the one finding refused

A review pass read Ring 2's sixteen crossings and Ring 1's twenty-eight rooms against the
laws, the binding condition and the question the whole of Phase 3 is measured by — *could
this room belong to any other Śakti?* — and returned nine findings, two of which are the
same defect written down twice (the crossing's mark depth). **Seven of the eight are real
and are fixed below. One is refused**, with reasons, along with one sub-claim of another,
because taking either would have cost the ring more than it bought. Every fix carries its
own check, and in seven of the eight cases the old check was green on the defect, which is
the part worth recording. Fixing them turned up two more defects of the same kind the review
had not reached, and those are fixed too.

### 1 · The mesh has a floor, and Ring 1 had never met it

A surface is meshed and lit at `RoomScene.resolution` — 64 a side — and both its relief
and its emission are read at those grid points and nowhere else. A mark narrower than the
gap between two of them has no vertex inside it: it moves no material, and because light
in this instrument is only ever a property of a disturbance, it emits nothing either. It
is not faint; it is absent.

`RingOne.Figure` scales a whole Design figure down to fit the picture — the rule that saved
Vaiṣṇavī's letter-ring from standing mostly outside the frame — and it scales the *marks*
down with it. A part of a part is very small. Measured over the corpus, before the fix:

- every grammar-built Mudrā laid down **85 of its 86 marks under one cell** — all five
  vaults' seventeen samples each, at four tenths of a cell — so what the walker stood in
  was the one disc the seal holds, and no seal;
- Sarva-Yoni's vessel (kp 27) was **73 of 73 under a cell** for the whole of the first
  adaptation and the hold, because the figure was sized on the outermost of the three
  *dormant* vessels beyond rather than on the vessel the walker is in — a 13× crush to make
  room for rings that do not arrive until the turn;
- Sarva-Trikhaṇḍā (kp 28): 120 of 121; Vaśitva (kp 6): 6 of 9; two Mātṛkās: all of them;
  and a Siddhi's lent capacity fell to a fifth of a cell at `t = 347` — the exact moment
  her room says it is at its brightest.

Ring 2 has guarded this since it was built — and **its own marks turned out to fail it too**,
which the review had not reached: the smallest of the seven rings a Karṣiṇī draws is 0.7 of
Design's room, which on a floor or a canopy (four body-heights across, against a working
face's one) comes out at 0.86 of a cell. kp 43 carried it that way for the whole of every
stay, and the ring's own check read the widest of the fourteen. The number now lives once, in
`RoomInscription.narrowestMark`, beside the mesh resolution it is a fact about, and both
rings read it from there.

Ring 1 had no equivalent at all. Three changes: `RingOne.reach(_:)` is the one place a Ring 1
reach is bounded — `narrowestMark` below, `widestMark` above — and every room's mark passes
through it; `MembraneRoom` is sized on the vessel the walker is *in* and lays the three
beyond into the material outside it, in Design's own proportions; and `MatrkaRoom`'s ring
opens by exactly the factor her letter had to, so the proportion between the two — which
**is** her count, and is the only channel this family has — is the one Design drew.

**One sub-claim of this finding is refused.** It asks for the same floor under a mark that is
*withdrawing* — the Siddhi's lent capacity, which Design shrinks to a fifth of itself at the
moment her room says it is brightest. Tried, and the suite answered within the minute: a
capacity held open at one mesh cell comes back the size it began, and
`testTheCapacityShrinksWhileTheRoomTakesItOver` failed on all five rooms. **A capacity that
is still there was never lent.** A mark that is leaving is allowed to grow too small to see,
because that is what leaving looks like; the floor holds everything else, and Ring 1's new
check exempts exactly the marks that have grown smaller than they opened. Vaśitva's pool is
the one narrowing mark that keeps the floor, because it is the only light in that room and it
is coming to rest on him rather than going.

### 2 · The crossing's counterpoint was an identity in five of the sixteen rooms

Ring 2's mechanism, in the handoff's own words, is *"two halves running her physics in
opposite phase, converging only at the second adaptation"*. Design's `ph + 0.5` puts the far
half a half-turn out of step — and for every kernel whose terms are `|sin|`, a half turn is
an **identity**: `|sin(θ + π)| = |sin θ|`. Water's welling and Earth's settling are like
that, which is kp 35, 39, 36, 38 and 44. In those five rooms the far half came back the
near half exactly, offset by nothing but Design's fixed 3.2-second lag — 0.35 and 0.22
radians, under 6% of a turn — so the two halves were a rigid pair of clusters from the first
moment and there was nothing for the second adaptation to resolve.

`HomeGrammar.counterPhase(of:)` now reads the counter-phase off the kernel rather than
typing it: where a half turn says nothing, a quarter does, and `|cos|` against `|sin|` is as
far out of step as a folded sine can be. It asks the kernel itself over a spread of moments
rather than listing which kinds fold, so a kind added later cannot be missed. Design's
number is unchanged everywhere it says something.

### 3 · Two rooms were reading the surface's own axis backwards

A surface's `v` runs to `(v − 0.5) · extent`: on a floor that is **z**, so the far edge is
`v = 0` and the walker's own standing point is `eyeZ` past the middle, not at the edge.

- **`EndlessRoom`** mapped its procession the other way round. The twenty-four frames
  receded from behind the walker toward the far wall and wrapped there, and the ten the turn
  adds — whose whole sentence is *there was no near wall either* — landed on the far half of
  the floor on top of the ones already standing there. The room's reversal never arrived
  anywhere at all. Nothing in the suite read a frame's position, so all 37 of its checks
  were green.
- **`KnownRoom`** pinned its pool of attention to `v = 1`, calling that "where he is
  standing". It is 9.6 units *behind* a camera that looks the other way. At *it has turned,
  and it rests on you*, the only lit mark in the room left the frame entirely, with half of
  it hanging off the edge of the surface.

Both now read the walker's own place off `RoomUnits`. And the procession is scaled as one
figure rather than clamped frame by frame: on a working face all twenty-four had come out
the same width with 48 of their 120 marks standing on the material's own edge, which is
`RingOne.Figure`'s own finding — *a ring whose marks are clamped onto the edge of the
material is not a ring, it is a heap*.

### 4 · Ring 2 never adopted the grain floor its own header records

`CrossingRoom`'s header records the finding — *"seven rings, buried"* — and Ring 1 enforces
it. Ring 2 did not: its depth was `markDepth × relative × lean` with nothing under it. In
the ten rooms whose kernel has no term into the material on a working face the lean is
pinned at its floor for the whole stay, and **four of the seven rings she draws stood under
the stone's own banding permanently**; in four other rooms eight of the fourteen did at
points in the cycle. The near half carries no light of its own, so a ring under the grain is
not a faint ring, it is nothing. The arithmetic now lives once, in
`RoomInscription.depth(size:on:)`, beside the mark depth it is the floor of, and `RingOne`
keeps the name its rooms and suites speak in.

### 5 · Six of the seven were green under a check that could not go red

This is the part to carry forward. In each case the check existed and asked a weaker
question than its own name:

- `testHerMarksStandClearOfTheStonesOwnGrain` read `marks.map(\.depth).max()` — the deepest
  of fourteen at one instant — so four buried rings out of seven passed. It now asks every
  mark at five moments, as Ring 1's sibling always has.
- `testTheTwoHalvesAreApartAndThenOne` asserted `apart > 0.01` against a **static** offset of
  0.11 that Design builds into the two halves' placements. It could not fail on a room with
  no crossing in it. It now also measures the *range* of that separation across the first
  adaptation, which no constant can contribute to, and reads the depth as well as the two
  surface axes — because a drawing Karṣiṇī on a working face carries her counterpoint in
  what she cuts rather than in where it stands.
- `testTheThreeFamiliesSeparateMoreThanSistersDo` compared the Siddhis and the Mātṛkās
  against their distance from the **Mudrās** only, so the one pair that could fail was never
  asserted. It now asserts all three.
- The Siddhis and the Mātṛkās had no per-pair divergence check at all, though the Mudrās and
  Ring 2 both do. They have one now.
- Ring 1 had no copy of Ring 2's *"a mark the mesh can carry"* check. It has one, over all
  twenty-eight rooms at six moments, and it asks every mark rather than the widest.

### 6 · Refused: that the crossing's words state an identity rather than a crossing

The review asked for the reversal line to be refused wherever the tattva is the element of
the faculty's own tanmātra — *"the sound and the space were one"* (kp 32), touch and air,
form and fire, taste and water, smell and earth — on the ground that Design's `CROSSED`
table deliberately *mis*matches a faculty with somebody else's organ, and that the mismatch
is what makes the room the room that crosses.

**Refused, and recorded here so the next pass does not re-derive it.** Three reasons, in
order of weight.

Every one of the sixteen lines names *her own* faculty and *her own* tattva, so no room's
words could belong to another Śakti — which is the question the ring is measured by, and it
is answered. Refusing the seven pairings the finding names would put **eight of the sixteen
rooms onto one shared sentence**, which fails that same question far worse than a true
statement of the tattva system does.

Design's mismatch is a card-keyed literal — sixteen rows of a table Design could not read
off a base. `HomeGrammar` declined to carry a bundled card table on the record, and the
pairing cannot be derived from the two live fields the row actually has.

And the room crosses in its **material**, which is where this instrument puts its meaning:
with §2 fixed, both halves now genuinely run her physics in opposite phase on every one of
the sixteen. The words say what her row says; the room says the crossing.

One line is a real tautology and is left standing knowingly: kp 43 reads *"the immortality
and the nectar were one"*, and both words gloss **amṛta**. The guard that exists for exactly
this case (it catches Cittā) tests substrings, and no substring relates the two English
glosses of one Sanskrit word. Detecting it needs a field the grammar does not read — her
name — so it belongs to the endless refinement pass (3.10), not to a review fix.

### 7 · One deferred failure, recorded as one

Asking the family means of all three pairs turns one of them red, and it is left red on
purpose. Two Mothers stand 0.423 from one another and a Mother stands 0.393 from a Siddhi, so
the Siddhi–Mātṛkā boundary is the one place in Ring 1 where family is not legible before
sisterhood. **This is not a new finding** — pass three recorded it above, with its cause: the
print reads forty-eight mark slots plus a count, and the padding pattern that separates the
Mudrās decisively (eighty-six marks against six or seven) is the same padding that fails to
separate the other two. What is new is that the suite now *says* so. It was written down in
this file and asserted nowhere; the test that claimed all three pairs compared two of them.

It is written into the suite as an `XCTExpectFailure` carrying its number and its reason
rather than dropped, so that green never means more than it does — and so that the day those
two families do separate, the test goes red and somebody has to come back and delete it.
Every pair of the twenty-eight still clears Design's tenth several times over, and both pairs
that involve the Mudrās clear their own bar.

### 8 · A run-order trap in the UI suite, found while verifying

`testFeelHerOpensRecognition` began failing after the third full run of the session and went
on failing — on a quiet host, on a loud one, alone, and in the suite. It is **not** contention
and it is not this branch: it taps *I feel her* and waits for the ceremony, and the ceremony
records a recognition, so **the second run of that test on the same simulator finds the day's
ceremony already done**. Erasing the simulator makes it pass at once, at a host load of 171.

Worth recording because the next session will otherwise chase it: the UI suite is not
idempotent across runs on one simulator. `xcrun simctl erase` before a UI run, or expect one
free pass a day per device. The unit suite has no such dependency — it builds its rooms from
pure functions and a corpus.

### The numbers, after the fixes

| what | measured |
|---|---|
| the narrowest mark anywhere in Ring 1, at six moments of a stay, over all twenty-eight rooms | exactly one mesh cell — `0.01562` — and never under it |
| Ring 2's two halves, correlated over the first adaptation | **−0.27 to −0.99** in all sixteen, against a bar of +0.5 and a pure delay's +0.97 |
| every pair of the grammar-built Siddhis | closest **kp 5 ↔ kp 8 at 0.172** (the authored five's closest, printed only, is kp 3 ↔ kp 4 at 0.141) |
| every pair of the eight Mātṛkās | closest **kp 16 ↔ kp 17 at 0.255** over 28 pairs |
| every pair of the ten Mudrās | closest **kp 19 ↔ kp 25 at 0.578** over 581 components, 127 of them silent |
| the three families | Mudrās ↔ Siddhis **0.728**, Mudrās ↔ Mātṛkās **0.731**, against the Mudrās' own within-family spread of 0.668 · Siddhis ↔ Mātṛkās **0.393** against the Mātṛkās' own 0.423, which is the expected failure above |
## 2026-09-21 · Phase 5 preflight — the Avaraṇa fields verified live, and no Design package governs

Charter §4 requires verifying the gem, dhātu, clock and bīja field IDs before Phase 5 builds on them, and says a Claude Design package for the light governs if one is present. Both checks done, read-only, while Phase 3 held the machine.

**Field IDs, confirmed live on the base:** Gem `fldWlbdPNpmqPvfMj` · Dhatu `fldVjcApdGFVrIfq1` · Time Cycle `fldZLBoLGegod2xfy` · Avarana Beeja `fldixnYtJ30lZEDJM` · Goddess Body Region `fld6Ucmi8YqeAbOXU` · Yogini `fldcqAvdN3wcP8BhT` (idea 30 needs this one and the charter's list omits it) · Geometric Shape `fldNqYFRn8x4F9jR0` · Subtle Body Chakra `fld6deGFzModjBmoj` · Siddhi `fldx9jXyTVWxp19o1` · Mudra of Avarana `fld1C14f4MsVIrA9F` · Presiding Form `fldgHVP1LqoVJsYu8` · Mental State `fld8p7FtKqEKvSy7P` · Phase `fldKWGAI16XjdqoI3`.

**All nine rings carry real values** — topaz through cat's eye to all-gems-unified; rasa through ojas to tejas; a day-night cycle through the year to Kāla-Akāla; Aiṁ through Hsauḥ to the three-syllable core and Hrīṁ. Nothing is blank, so idea 27's refraction and idea 31's falling bīja both have their data.

Note for the build: the app currently decodes **none** of these into `Avarana.swift` — only sanskritName, subtitle, presidingForm, mentalState, subtleBodyChakra, geometricShape, personalConnection and yogini. Phase 5's first act is extending that decode, additively.

**No Design light package exists.** Searched the three design folders for anything on light, gems or Tratak: nothing. So charter §4's fallback applies and Phase 5 builds from `Claude Chat/bindu-mandala-expansion.md`'s descriptions of ideas 27, 28, 30, 31, 32 and 38.

## 2026-09-21 · Phase 3.6 · Ring 3, the eight bodiless — and the shared ground for the outer rings

Design's `bodiless(world, card, G)`, built on the Phase 3.1 spine as
`Homes/Render/BodilessRoom.swift`, plus `Homes/Render/OuterRings.swift` — the arithmetic all six
outer archetypes need, built once, before the five parallel passes that follow this one. Ring 3 is
the pathfinder for rings 3 to 9, so what is shared was built generously rather than when it was
first needed.

### The hard word, and the thing that made it material

Anaṅga means **limbless — without a body**, and the renderer ruling's binding condition allows a
room exactly one register: an action on the room's own material. There is nowhere in the air for a
bodiless effect to be. That tension is not a problem to be routed around; it is the room. Something
that has no body still leaves a mark.

**Eight marks stand in a ring around a place where nothing has happened.** Design's own comments say
what its two halves *are* — the petals are *"orbiting nothing"* and the rim is *"the absence at the
centre"* — so they are concentric here, on the one point the instrument already has for where she is
felt. Design stands its rim 3.5 units further back than the petal ring because in three.js a key
light behind a subject rim-lights it; that is a lighting arrangement, and its meaning is a concentric
one.

**And the room's sentence is then delivered by the instrument's own arithmetic rather than by an
authored effect.** `RoomMaterial.emission(at:)` multiplies a mark's glow by how far that mark
actually moved the material, so a mark carrying no glow contributes nothing at any depth. Design's
rim is a `TorusGeometry` of tube radius **0.02**, which is a line, and `CrossingRoom` already ruled
what a line becomes here — *"a line lights nothing"*. So the absence carries **no light at all** and
the eight effects carry every bit there is, and the one place in her room that emits nothing is the
exact point `RoomUnits.emberPoint(for:)` stands the room's own light at. *The room's light comes from
a point that visibly holds nothing* is true because of how light is defined in this instrument, not
because a torus was given a low opacity.

**The absence's verb was not chosen.** `RoomInscription.verb(for:previous:)` reads which of the five
verbs a part performs from its own travel, and the absence does not travel — it is the still centre
of a turning ring. A part that bears on the stone without moving classifies as a **compaction**:
*"the mark of something that bore down without moving."* That is the definition of Anaṅga arrived at
through the classifier rather than written into it.

**What is at the centre is her attribute**, because Design mounts all 102 attributes where she is
felt and this room does not make an exception of itself. That is the sentence finishing rather than a
leak: what stands at the centre of an Anaṅga's room is her *effect*, and the room's own material
under it has had nothing happen to it but a flattening. The cause is what is missing.

### Six calls

**Design's `ph + i / 8` is an identity for eight of the fifty-one kinds, and it would have halved
this ring.** `CrossingRoom` found the two-half version of this — *"where a half turn says nothing, a
quarter does"* — and a ring of eight is the same trap one turn further round: the kinds whose terms
are all `|sin|` fold at half a turn of phase, so petals `i` and `i + 4` come back the same number.
Measured over all fifty-one kinds with Design's literal `i / 8`: **`well`, `settle`, `point`,
`reach`, `spring`, `assert`, `ground` and `surge` each collapse from eight distinct motions to
four** — Water, Earth, the goad, longing, the source, the ego, support and the throb, which between
them claim a large share of any ring. `OuterRings.spread(index:of:kind:)` spreads the parts across
one turn of *the kernel* instead of one turn of phase, read off `HomeGrammar.counterPhase(of:)`
rather than from a table of which kinds fold. For every kind that does not fold it returns Design's
number to the last bit, and it is asked once here for all six outer archetypes, every one of which
writes `ph + i / n`.

**The ring is sized by the strokes standing on it, and by how far her own physics can swing
them — and both of those were found by the room's own checks rather than by looking.** Design's
petal is a glow sprite of span 4.2 on a ring of radius 5.4, and a glow sprite is a light with a soft
edge. A mark here is not: a **furrow** holds its whole depth for the length of its stroke and a
**crack** is still at a quarter of its own where it closes, and both run four of their own reaches
*along* the stroke (`SurfaceAction.cutoffReaches`, named for this). A mark of Design's size on
Design's ring therefore makes a stroke **longer than the ring is wide**, and the two effects whose
stroke happened to point at the middle lit the absence they were standing around — measured at
**0.55 of full emission** in the one place this room's whole sentence needs dark. The rule is now one
sentence: *an effect's stroke closes on the ring it stands on, and never across it.* A mark reaches
at most a quarter of the way to the absence, which on a working face is Design's own ring exactly; and
where the surface's mesh has forced the mark up to a cell — a floor is four body-heights across, so
one cell is four times the thing it is on a face — the ring opens out until the strokes close around
it again. On the large surfaces it then reaches past the picture, and that is the right way round for
this archetype and only for this one: Design's own petals ring the walker at `z = -3 ± 5.4`, which
passes *behind* where he stands. Her effect is not a figure held out in front of him; it is the thing
he is inside.

**And the ring's plane is the surface, which is not what `RoomUnits.axes` says on a face.** The
instrument's general rule maps Design's *rise* along a working face, and it is right for a figure
Design drew standing up. A bodiless ring is drawn lying down: its two in-plane axes are `x` and `z`,
and the one that leaves the plane, `y`, is the one that runs **into** the stone. On a floor and a
canopy `RoomUnits.axes` already says exactly that; on a face it does not, and taking the general rule
there put Design's off-plane motion *across* the ring — which is how a Śakti whose physics is
expansion lit her own absence. Which way *into* is, is still the instrument's `outward`, so rising off
a floor and rising off a ceiling stay one fact. The ring also opens by however far her own physics can
carry an effect toward the middle, measured from the kernel per kind
(`OuterRings.inPlaneExcursion`) rather than bounded by its widest term — because bounding it by the
widest would stand a Śakti whose physics barely moves in the same room as Mahat's widening, and the
whole point of the kernel is that she does not. Design's own word for the petals is *orbiting*, and a
ring whose motion swings it through its own centre is not orbiting anything.

**Design's `(1 - b)` on the rim is spent on the absence being overtaken, not on the absence
leaving.** The rim carries no light here, so there is no opacity for that number to be, and a mark
may not be faded by going shallower — `RingOne` refused that once already, because *"a mark that grew
shallower would stop being seen while it was still there, which is a different thing from leaving."*
So the absence is left exactly as it is, and `RoomReversal` opens the answering mark **on the same
point it stands on**, twenty times its width by the end of the stay. *The effect was the only body*:
nothing had to be taken away, and what held nothing became the room.

**The classifier was widened by three rules, and deliberately not by thirteen.** The Phase 3.1
record left a known gap — the six kañcukas, the Spanda words and Saṃskāra / Vṛtti / Guṇa reach no
rule — and said the fix belonged with the live rows. Before widening anything, all 102 of Design's
own cards (whose fields it states are the base's) were run through the fifty rules: **not one of
those words appears anywhere in the 102**, and the cards fall through exactly three times — Priyatā
at kp 69, Saubhāgya at kp 76, Cāpa at kp 96, all in rings the following passes own. The kañcuka gap
is the *test corpus's* vocabulary rather than the rows'. So the three real gaps now have rules,
appended behind Design's fifty and never interleaved, and the kañcukas do not — widening the
classifier to cover words the rows do not use would make it look fuller than the instrument is. All
three reuse kinds Design already wrote, so `HomeGrammar.widestTerm` and every room that normalises
against it stand untouched.

**The fingerprint's probe grid follows the room rather than the surface.** Ring 2 reads a five-by-five
grid over the whole working face, which is right for a ring whose fourteen marks are spread across
one. It is wrong from ring 3 outward: `Figure` brings Design's halls into a picture 1.3 units across,
and on a floor four body-heights wide the whole figure is a twentieth of the surface — so twenty-two
of twenty-five fixed probes land on undisturbed stone and read identically in every room of the ring.
That is the dilution Ring 2's suite names, arriving *inside* the measure. `OuterRingFingerprint`
spans its grid over the room's own marks at that moment, and carries Ring 2's dilution guard as a
check of its own: fewer than half the components may be constant across a ring.

### What the five parallel passes inherit, and what they must not touch

`Homes/Render/OuterRings.swift` is theirs as much as mine. It holds, ring-parameterised:
`designSpan(ring:)` and `inRoom(_:ring:)` — **and the divisor changes at ring 4**, where Design's
altitude span goes from 9 to 8; `widestMark`, `narrowestMark`, `reach(_:)` and `depth(size:on:)` —
the two floors Ring 1 and Ring 2 each paid for with a render; `Figure`, which scales a whole figure
into the picture rather than clamping its parts; `readOver`, the clock a physics is read on rather
than a gesture's; `Place`, `motion`, `pressed`, `mark` and `lightShare`; and
`spread(index:of:kind:)`. `RingOne` now forwards to all of it rather than carrying its own copy, so
there is one implementation and Ring 1 keeps the names its rooms and its suites speak in.

`OuterRings.outerRoom(_:)` is the outer climb's whole dispatch, and it is deliberately the only place
a built outer archetype is named: each of the five remaining rings arrives by changing **one line**
there, and `RoomMechanisms.forRoom` is not touched again. A `nil` there means *not built yet*, and
she keeps her ring's own archetype turn in the meantime, because a room that does not reverse is a
loop.

On the test side, `OuterRingFingerprint` (the print, `divergence`, `refusesDilution`),
`OuterRingStage` (a room read without a renderer, mechanism-only) and `OuterRingCapture` (the
legibility register, going around SwiftUI as the renderer ruling requires) are shared for the same
reason: six passes, one ruler. `slots` is a parameter with a default of sixteen — past five of the
six builders' part counts and exactly at the sixth's — so a ring that stands fewer parts passes its
own number rather than carrying empty slots that read alike in every room.

## 2026-09-21 · Phase 3.6, Ring 9 — the Bindu, the silence wire, and the two ledger events

The last of Design's eight authored mechanisms, and the two wires the brief puts in this
phase. `HomeGrammar` returns `nil` for ring 9 on purpose — `HomeRooms.grammarRings` stops at
8 — so kp 102 is the one seat in the hundred and two that could not fall through to an
archetype. Every number in `Homes/Render/DissolveRoom.swift` is Design's own `chamberDissolve`.

### 1 · The room: the yantra, cut into her own stone

**The figure is the instrument.** Ninety-nine of the hundred and two rooms lay out a figure of
their own; this one lays out the **Śrī Yantra** — the nine enclosures the whole Mandala is
built of, one inside the next, with her at the point they are all enclosures of. Design's own
phrase for the instrument is *one building, ninety-nine reflections and the source*, and the
figure comes out at exactly that: three squares of eight, two circles of twelve, sixteen
petals, eight petals and nine triangles of three corners is **ninety-nine marks**, and the
hundredth is the source. It is asserted, so a later hand cannot quietly make it ninety-eight.

**Four readings of Design, and each one is a decision.**

*The yantra's plane is the surface, and Design's depth is the cut.* `RoomUnits.axes(of:)` is
right for a figure drawn standing up and carried onto a face, and wrong for a **concentric**
one carried onto a floor — Design's `y` becomes the axis that leaves the stone and nine nested
courts come back as nine flattened ellipses. `BodilessRoom` made the mirror-image reading for
the mirror-image reason (*"a bodiless ring is drawn lying down"*); this is the same sentence
for a figure drawn standing up. So the nine depths become **nine depths of cut**, the bhūpura
scratched at the surface and the source the deepest thing in the room. It also disposes of the
axis trap that ran `EndlessRoom`'s procession backwards: because the plane is *declared*
rather than mapped, no axis here carries a surface-dependent sign at all, and the two
rotations that matter — Design's `+0.0075` on the courts against its `-0.014` on the triangles
— keep their relation on a floor, a canopy and a working face alike.

*A circle is drawn with twelve marks and a square with eight.* Eight points on a circle stand
at the same eight angles a square's eight do; drawn that way the two courts would come back as
one court at two radii.

*A court leaves by going past the picture, never by going shallow.* Design carries the whole
yantra past the walker (`position.z = b * 7.4` on a figure 8.4 deep). There is no camera to
pass here, so it leaves the way a figure cut into a surface can: it opens out past the picture
the walker is actually looking at, and its **light** goes with it. It is a claim about light
and never about depth — `RingOne` refused that once already, and the stone keeps every court
it was ever cut with, at its own depth, for the whole stay. Measured, the figure leaves **from
the outside in**: the bhūpura is at 0.45 of its light by the end and the nine triangles are
still at full, which is what turning inside out looks like on a surface.

*The source is a swell, and it is constructed rather than classified.* Every other mark in the
room has its verb read off its own travel by `RoomInscription`. The source travels a fifth of
a body over the two minutes of the second adaptation, which at any rate a classifier can see
is a **compaction** — *"the mark of something that bore down without moving"*, which is
`BodilessRoom`'s absence and the exact opposite of what this mark does. Design's own line is
`bindu.position.z = -8.4 + b * 8.4`: it comes **out** of the depth of the figure to where he
is standing, and material coming out of a surface is a swell.

**The reversal.** `HomeBecoming(premise: .wall, answer: .ground, yields: 7.4/8.4, takes: 2.8)`
— the enclosure gives way by Design's own travel, and what takes the work over is the
**ground**, by Design's own word: *the bindu is where you are standing*. `RoomReversal` then
refuses to bring the ground toward the walker because he is standing on it, and in this one
room that law is the sentence rather than a loss: the source does not come at him, it turns
out to have been underfoot. The answering mark is the room's **own** (`TripleRoom`'s reason —
a second lit disc on top of the source is the wash `MatrkaRoom` found with a picture), and it
carries Design's `(1 - b * 0.55)`: a point of light at the far end of a hall is something you
look at, and the same light arrived where you are standing is something you are inside. *A
light you are inside is not a light you see.*

**Measured.** Legible on all three surfaces at both adaptations — mean luma 0.148 → 0.244 at
the crown, 0.167 → 0.253 at the heart, 0.173 → 0.237 at the soles, none black, none blown out,
spread 0.27 to 0.61. Every one of the hundred marks clears both floors at five moments and at
three altitudes. The centre is the brightest place in her room at both adaptations, read as
emission off the material rather than off the numbers.

### 2 · The R11 silence wire

`Services/HomeDwelling.swift` is the caller the three shipped pieces were waiting for. It owns
one `HomeVisit`, wakes at the stay's two marks and does nothing else.

**Which clock.** `HomeMemoryStore`'s header left it open and handed the caller a helper to
rule it with; it is ruled here as the **chamber clock** — the clock `homes-chambers` counts
adaptations on, the clock `HomeMemory.adaptation(atChamberTime:)` reads, and the clock the
room beneath the words is drawn by. The consequence is written down rather than discovered
later: a walker whose accumulated dwell has opened her room past the first adaptation holds
that room's silence on arrival. That is the head start doing what it is for, and it cannot be
gamed by entering and leaving, because the head start comes from accumulated dwell.

**It wakes rather than polls.** A stay has exactly two marks and both are known the moment the
clock begins, and on the reduce-motion path there is deliberately no render loop to hang a
poll on. `observe` re-asks both guards when it wakes, so a wake that is early, late or
repeated changes nothing.

**It is invisible by construction.** `HomeDwelling` imports no SwiftUI, vends no published
property and has nothing a view can bind to; the one screen that carries one reaches for it in
exactly two places and both are lifecycle. A count that cannot be read cannot be shown by
accident. The write is a local `RecognitionEntry` with `gesture: .silence` plus one
`Silence Held` row in App Activity — and nothing at all to the Mandala table, which is
asserted off the source rather than promised.

### 3 · The two ledger events that survive

`Full Circle`, once ever, when the 102nd first-felt lands; `First Dwelling`, once ever, the
first time a second adaptation is reached in any room. `Deepest Ring Reached` stays dropped —
see this file's entry of the same day.

**Both are once *ever*, which no other row in the ledger is,** and a local flag cannot carry
that: it is per-install, so a reinstall or a second device would log the milestone again,
which is exactly what `Letter Written` did until §0.6's server-derived reconcile. So each
carries the same two-part guard the letter now has — a local set, plus a read of the ledger's
own view that unions into it (`reconcileLedgeredMilestones`, once per sync) — and
`recordMilestone` reads the server again at the moment of writing. That read **fails closed**:
an unanswered question about a once-ever row is answered by not writing it, because a missing
milestone can be written on the next gesture and a duplicated one cannot be taken back.

**How far round he has come is asked of the ledger, not of this phone.** `Full Circle` counts
the distinct Śakti record ids linked from `Shakti Recognized` rows — R17 working as intended,
since App Activity is the single record and a reinstall cannot reset it. The read happens only
when a gesture was itself a **first** recognition and only while the milestone is unwritten,
which is at most a hundred and two narrow reads in a whole practice and none afterwards. It is
fire-and-forget and fail-quiet: a recognition is never held up, failed or retried because of a
milestone. The count never reaches the walker; it decides a row in the archive and nothing
else.

`LawsTests`' event vocabulary now covers both new types, so an event's name still lives in one
file and nowhere else.

## 2026-09-21 · Phase 3.6 · Ring 7, the twelve Vāsinīs — what a ring with no phase is given instead

**The thinnest archetype in the instrument, and the Phase 3 foundation said so.** SOUNDING has no phase divisor at all — `HomeGrammar.phaseDivisor` returns `nil` — so all twelve carry `phase` `nil` and Design phases the room's parts by *node index*. Her position reaches the builder through exactly one number, `n = 2 + (pos % 8)`, and across twelve seats that wraps: `87·95` both stand at nine, `88·96` at two, `89·97` at three, `90·98` at four. On the real cards eight of the twelve carry `vāc` or `speech` and classify to one physics, and seven of those eight sit in one body zone.

**What was done about it, from her row rather than from a new number.** Four registers: her **mode decides how many marks her room has** — `2n`, where every other outer archetype stands a fixed count regardless of who is in the room; her **mode decides how wide the wall opens**, because a standing wave needs a wall long enough to carry it; her **altitude sets the phase of the wave's own breath**, read off Design's second wave term at the height she is felt at, which is the one number in Design's shader that varies with where on the body she lives; and her **physics holds the silences**.

**Design's shader contradicts itself once and it is resolved rather than copied.** `sin(ang * uMode + uTime * 0.5)` **travels** — its zeros move around the cylinder at `0.5 / uMode` radians a second — so a node sprite pinned at a fixed angle is at a node only for an instant and the room has no silence anywhere, which is the opposite of what Design's own comment, its fixed sprites and the word *standing* all say. The angular term stands here; the time-varying term is the **axial** one Design already wrote.

**The room.** `2n` marks around one ring, alternating: `n` silences at Design's own angles, and `n` soundings at the quarter-turns of her own wavelength where `sin` is at ±1. **Their signs alternate**, so one sounding is driven out of the stone while the next is drawn in. Nothing else in the hundred and two moves its material both ways around a single ring — a Bodiless room's eight all carry one physics at eight turns of one phase, a Cosmic room's shells are concentric, a Sourcing room has three corners. Every mark carries light, and that is not a softening: the seventh āvaraṇa is **pearl at 0.95 and sourceless**, so there is no raking key to find relief the material does not emit for itself, and a room whose silences were dark would be `n` lit points in a void.

**Two findings this ring paid for.**

1. **Design's `s.position.y = y + d[1]` on a node loses her tattva entirely for a dozen of the kernel's kinds** — `turn`, `recur`, `compress`, `encircle`, `point`, `draw`, `align`, `widen`, `dart`, `flow`, `merge`, `arrive` — and two of them are this ring's own on the real cards, `pāśa → encircle` and `aṅkuśa → point`. In a ring with no phase divisor that is the whole tattva gone. The node is read as what a node **is** instead: driven off the plane by Design's own `y` term plus the radial press (in Design's cylinder the radius is the way *off* the wall), and **held** by the travel it refuses along the wall, which is the mark's depth. Summing the refusal into the same number as the press cancelled it outright wherever the two came out equal — measured, `point` and `arrive` lost two of a mode of eight to it — so it is a second channel and not a third term.
2. **The wall opens with the mode.** The chord between two neighbouring marks has to be at least one stroke wide, or each sounding writes through the silence beside it and the room has no silences. `2R · sin(π / 2n)` against `clearance` of the reach a silence opens out to; the **chord and not the arc**, because a mode of nine stands its marks twenty degrees apart where the two differ by a twentieth, which is the whole margin this room has. A mode of nine therefore stands on a wider wall than a mode of two — Ring 3's finding arriving at the one archetype where the count is the Śakti.

Closest pair on the geometric fingerprint: `88 · 96` at **0.235**, against Design's tenth. Legible at both adaptations on every one of the twelve.

## 2026-09-21 · Phase 3.6 · Ring 8, the three at the source — and Design's rule order, left alone

**Two of the three share a physics and it is deliberate.** All three cards say *"at the source"*, and Design's rule order reads `/yoni|source|bhaga/ → spring` **nine rules before** `/icch|…|will/ → incline`. So kp 99's *Icchā at the source* and kp 101's *Jñāna at the source* both classify as `spring`; only kp 100 escapes, because *Kriyā* and *Lightning-Action* reach `/vega|…|lightning|kriyā/ → dart` earlier still. The order is Design's and pinned by a test, so **it is not touched**. It is asserted instead, against the real cards rather than against the corpus, so the day it changes this room's reasoning is re-read rather than quietly becoming untrue.

**Which means a Ring 8 room may not rest on her physics.** Two structural things tell the three apart and neither is invented: **which corner is hers** — kp 99 and kp 101 are lit at opposite ends of one figure — and **her corner is also her phase**. Design phases the three lamps by *lamp index*, `displace(kind, t, i / 3, 0.8)`, with nothing of the Śakti in it, so with one physics between them the two would have moved identically and differed only in which mark was bright. Her corner's own turn of the three is what every other archetype receives as `ph`, and it is the one number her position gives this one.

**The triangle stands up, and that is the reverse of the two rings before it.** Design draws it `cos(a) * R` in **x** and `sin(a) * R` in **y** at a fixed `z`; a Bodiless ring and a Sounding wall's ring are drawn lying down. The rule underneath is the same in all three and it is the figure's rather than the surface's: **a figure's own plane is the surface it is cut into.** Taking the general axis reading here would have put the whole rise into `along(design: 0, rise: y)`, which on a floor or a canopy is `along = 0` — three corners collapsed onto one line, which is the inverted-axis defect in a different costume.

**Design's own recorded defect for this ring** was that the triangle stood larger than the room, so its corners left the picture and what was left went near-black. `OuterRings.Figure` scales the whole figure rather than clamping its parts, and both halves are held: **no mark is ever clamped to the edge**, at any moment of any stay, and **the brightest thing in the frame clears 0.15** at both adaptations. The second half is the one a geometric check cannot see — a sourcing room *is* dark, one corner speaks and two are silent, so a mean luminance says nothing here and a maximum does.

**Three findings.** The three corners **cannot** be asserted to be cut to one depth: how hard a corner bears is her physics at that corner's own turn, so equal depths would be demanding her physics stop at the two that are dark. What is one is their *size*; the check reads the grain floor and the ratio. *Not yet reached* is the least the instrument lets a mark ask for, which is a **fifth and not nought** — `OuterRings.mark` holds size at 0.2 before the grain floor, exactly as Ring 3's absence already did. And on a floor or a canopy the whole figure is already at one mesh cell, so Design's `mine ? 6.4 : 2.4` is smaller than anything the surface can hold and **hers is not the larger corner there** — not lost, because on those surfaces Design's other number carries the whole distinction, and that number is the light.

Closest pair on the geometric fingerprint: `100 · 101` at **0.589**.

## 2026-09-21 · Phase 3.6 · the milestone guard, corrected on the way in

The Ring 9 checkpoint's milestone wire read the ledger before writing a once-ever row and **failed closed by returning "already there"** — correct — but the caller then **marked the milestone locally on that answer**. Nothing ever clears that set: `reconcileLedgeredMilestones` only adds to it. So a single timed-out read suppressed a `Full Circle` or a `First Dwelling` on that install **permanently**, which is the opposite of what the code's own comment claimed it did.

The read still fails closed, because a duplicated milestone cannot be taken back and a missing one can be written on the next gesture. **Closed now means write nothing *and remember nothing*,** which is what makes the next gesture able to ask again. The three answers — present, absent, could-not-ask — are a pure function (`AirtableService.decision(for:)`) so the guard can be exercised without a network, and a test holds all three.

## 2026-09-21 · The MVP line, and the cable dropped for good

**Ashrey, 2026-09-21:** he does not want to connect the device or leave a cable, the letters stay as they are and anything unnecessary can go, Xcode Cloud and TestFlight are already set up so builds land on his phone directly, and what he wants is a minimum viable product driven to completion.

He is right and I had been regressing. The delivery path is automated and proven — builds 36 and 37 both reached Neev through Xcode Cloud with the `AIRTABLE_PAT` secret in the workflow. The fresh-container pull was only ever a nicety after he released §7's letters condition; it is dropped and will not be raised again.

**The MVP line, decided here.** An MVP is not "fewer rooms" — the rooms are nearly all built and the remaining ones are running. It is **the smallest build that is worth installing**, and the thing that decides that is reachability: today `RootView` offers five destinations and none opens a Home, so a build shipped now would look identical to the one he already has.

**So MVP = what is running, plus the way in, plus the ship:**
1. Phase 3.6, the 58 outer rooms with the silence dwell and the ledger events (running).
2. Phase 4, the felt register (running, disjoint).
3. **Phase 3.7 — the corridor and the way in.** Her seat on the Mandala and her row in the Field open her room; neighbour doors walk the ring. This is the MVP gate.
4. Ship through Xcode Cloud, confirm the sync and recognition-write path in the build logs, leave `ARRIVAL.md`.

**Explicitly after the MVP ships, as later builds, not before:** 3.8 the library fold, 3.9 the descent and the carrier in every room, and Phase 5's light. Each is real work and none of it is what makes the difference between a build worth installing and one that is not.

## 2026-09-21 · Phase 3.6 · the 102 rooms, whole — the merge, and the first whole-instrument check

Five branches came together on `phase-3-6`: `rings-456` (Ring 4 Sampradāya, Ring 5 Kulottīrṇa),
`rings-789` (Rings 7, 8, 9 plus the R11 silence dwell and the two once-ever ledger events), the
`ring-6-revealing` checkpoint, and `origin/main`. With Ring 3 already on the branch, that is the
whole outer climb, and with it **all 102 seats have a room for the first time.**

### Ring 6 was not in `rings-456`, and the name said it was

The branch is called `rings-456` and holds rings 4 and 5. Ring 6, the ten Nigarbhas, was left on
`ring-6-revealing` as *"Checkpoint: ring6's work, written but never verified"* — one of the four
salvaged when six room agents were fanned out at once and the test hosts hung. Merging only the two
branches this pass was handed would have left ten Śaktis falling through to the bare archetype turn
while every check went on saying green, because until this pass there was no check that asked about
all 102 at once. The checkpoint was merged, and it compiled and passed unmodified — 508 lines of
`RevealingRoom.swift` and 594 of its suite, written by an agent that never got to build them.

### Every collision, and how it was resolved

Four files were touched by more than one branch. None was resolved by taking a side.

| File | Who touched it | Resolution |
|---|---|---|
| `Homes/Render/OuterRings.swift` | all three ring branches | **Union.** Each branch flips its own line of `outerRoom(_:)` from `nil` to its room. Git auto-merged 4 and 5 against 7 and 8 (the hunks do not overlap); ring 6 conflicted and was resolved by hand to all six built. This is the file's own design — *"each of the six rings arrives by changing exactly one line here"* — so the collision was expected and the faithful resolution is every line taken. |
| `DECISIONS.md` | `rings-789`, `origin/main` | **Both kept**, in that order. Append-only by charter §4. |
| `PROGRESS.md` | `rings-789`, `origin/main` | **Both kept**: the three ring entries, then main's plan-to-completion. |
| `RoomReversal.swift`, `AirtableService.swift`, `RiteOfEnteringView.swift`, `LawsTests.swift`, `GateRoomTests.swift` | `rings-789` only | No collision. Recorded because a reader would expect one. |

Nothing was dropped. The whole-instrument check below is what proves that rather than the diff.

### The check that could not be run until now

`WholeInstrumentTests` asks the four questions the building can only be asked whole:

1. **All 102 resolve by position**, and the rings hold 28, 16, 8, 14, 10, 10, 12, 3, 1.
2. **Nobody is on a shared room.** Two of them, and they are different failures: `.seat`, the
   gem-lit fall-through the resolution gives a Śakti it has nothing to say about — empty — and the
   **bare archetype turn** (`GrammarReversal` / `ArchetypeReversal`), which is the more dangerous
   because it looks built: the room reverses, the light moves, and everyone in the ring is standing
   in the same one. Also empty. Before this merge fifty-eight seats were on the second.
3. **Design's eight arrive at their positions** — 1 contract, 2 endless, 3 release, 4 press,
   6 known, 27 membrane, 28 triple, 102 dissolve — asserted as the **concrete mechanism type**, not
   as the enum case, because the case is satisfied by the placeholder turn that stands in for a room
   Design named and Code had not built. And nobody else is authored.
4. **Sister divergence in all nine rings, and all 102 legible at both adaptations.**

### The finding: a ruler wide enough to truncate nobody drowns the rooms that make few marks

The first run failed twice — Ring 1 kp **3 and 4 at 0.037**, and Ring 4 kp 56 and 64 at 0.073 —
both under Design's tenth. kp 3 and kp 4 are `release` and `press`, Design's own authored opposites
and the Gate itself. Two rooms that could not be more different should not have been able to fail.

They had not. **The ruler was measuring its own empty slots.** The print width was taken as the most
marks any room of the ring makes, plus two, so that nothing anywhere was truncated — and Ring 1's
rooms are wildly uneven, one of them working a hundred and seventy-two marks where the Gate's two
work a handful. At a width of 174 the Gate's prints came out nine parts padding to one part room,
and the padding matched, because an unused slot reads `a|<slot>|-` in every room that has one.

The fix is at the comparison and not at the width: **a component both prints left empty is not read
at all.** It cannot hide a difference — the skipped components are identical *and* silent in both
rooms — it only stops the absence of a mark from being counted as agreement, and it moves this
measure back toward Design's own `divergence`, which walked a chamber's real objects and had no
empty slots to count. The bar was not touched. kp 3 against kp 4 then reads **0.209**, and every
ring clears the tenth.

This is the dilution Ring 2's suite named, arriving from the other side. `refusesDilution` catches a
print that is mostly padding in *every* room of a ring; it cannot catch a *pair* that happens to be
padded in the same places, and it reported a healthy 0.178 constant share for Ring 1 while the Gate
was reading as one room. Both guards now stand.

### The numbers

Closest pair in each ring, over the components at least one of the two rooms used:

| Ring | Seats | Closest pair | Divergence | Constant share |
|---|---|---|---|---|
| 1 · Trailokyamohana | 28 | 3 · 4 | **0.209** | 0.178 |
| 2 · Sarvāśāparipūraka | 16 | 36 · 44 | **0.414** | 0.117 |
| 3 · Sarva-Saṅkṣobhaṇa | 8 | 46 · 52 | **0.263** | 0.090 |
| 4 · Sarva-Saubhāgyadāyaka | 14 | 56 · 64 | **0.108** | 0.070 |
| 5 · Sarvārthasādhaka | 10 | 67 · 70 | **0.199** | 0.173 |
| 6 · Sarva-Rakṣākara | 10 | 78 · 84 | **0.344** | 0.317 |
| 7 · Sarva-Rogahara | 12 | 88 · 96 | **0.303** | 0.143 |
| 8 · Sarva-Siddhiprada | 3 | 99 · 100 | **0.682** | 0.191 |
| 9 · Bindu | 1 | — | — | — |

**Nothing blurs.** The narrowest margin in the instrument is Ring 4's kp 56 against kp 64 at 0.108,
eight thousandths above the bar — the one pair worth watching if Sampradāya is ever touched again,
and the reason its own suite's finding (one gesture at fourteen distances, told apart by distance
alone) is the least redundant in the outer climb. Ring 8's three are the furthest apart of any
ring's closest pair, which is the Triad's own suite paid for twice: kp 99 and kp 101 share one
physics by Design's rule order, and the room tells them apart by which corner is hers.

All 102 render neither black, nor blown out, nor flat, at the first adaptation and past the second.

**Full suite: 624 tests, 0 failures, 0 Swift warnings.** The eleven skips are the opt-in spike
benchmarks, unchanged.

---

## The press that was never delivered — keeping `dbb3b8c`

**The call:** keep the retry helper in `BinduMandalaUITests`. Do not revert it, and do not
"fix" any app source on the strength of the failure that prompted it.

**What happened.** The lead ran the full suite independently before merging 3.6 and found
`testFeelHerOpensRecognition` failing: tapping *I feel her* did not open the Recognition
ceremony. It failed twice, including on a quiet machine after 66.8 s, so it was not a timeout
under load. Held the merge. Three agents then took it apart.

**The cause is below the app.** Caught in the act with `simctl log stream`:

```
backboardd  cancel -- digitizer did disappear:<BKDirectTouchState …
  contacts: [pathIndex: 2; touchIdentifier: 1; touching; locked;
             … sceneID:com.ashrey.bindu-mandala-default]>
```

The contact is still `touching` when the digitizer goes away. XCTest attaches a virtual HID
digitizer, plays touch-down at +0.00 s and touch-up at +0.05 s, and tears the service down
~180 ms after attaching. Under host contention the playback is descheduled between the two
frames, the lift never reaches backboardd, and the live contact is cancelled. UIKit delivers
`UITouchPhaseCancelled`; SwiftUI **correctly** discards a cancelled press; the `Button`'s
action never runs. XCTest is unaware — it logs "Synthesize event" as succeeded and then polls
the full 20 s for a consequence nobody asked for.

So the app is right, the test asserts something true, and the gesture was lost in delivery.
The contention was the lead's own doing — six render agents on eight cores earlier the same
night. Measured flake rate before the change: 1 in 8, at host load 76–116.

**Ruled out, each with evidence, not argument:** an ungated awaited network read under
`SYNC_OFF` (the lead's own first hypothesis — disproven statically: `sync`,
`recordRecognition`, `flushPending` and `recordMilestone` each open with the `syncIsDisabled()`
gate, so `feltOnServer`/`milestoneOnServer` are unreachable in this test); simulator
difference (both iPhone 17 Pro / iOS 26.5, `ReduceMotionEnabled 0` on both, and it passed on
the lead's own simulator); machine load slowing the tap (the failing tap was *fast* — 260 ms);
unit-test pollution of the shared app container (reproduced that exact ordering; still passed);
and Phase 3.6 itself — its diff names none of `DailyRiteView`, `RecognitionMomentView`,
`RootView`, `RecognitionLogStore` or the UI test, and the trigger is synchronous
(`DailyRiteView.swift:282-285` is `Haptics.medium(); showRecognition = true`).

**Why keeping it is not a weakening.** No timeout was raised — each attempt gets exactly the
budget the single `tap()` had, 8 s and 20 s. No predicate was loosened; the assertion messages
are byte-identical. Nothing is skipped. The re-press is gated on `element.isHittable`, which is
false once a cover has presented, so a press is only re-sent when the button is demonstrably
still sitting there unpressed. An app that genuinely ignores the gesture now fails three times
over instead of once, which is *stronger* than before.

**The decisive reason, beyond correctness.** The build reaches Ashrey through Xcode Cloud and
TestFlight, and that is the only path he has agreed to. A 1-in-8 UI flake would redden Cloud
builds at random and block delivery — the precise failure the charter exists to prevent. A
harness flake must not stand between him and the instrument.

**Known and not fixed:** a second, distinct simulator flake — the UI runner dying with SIGABRT
while bootstrapping ("Early unexpected exit … never finished bootstrapping"), zero events
synthesized. Nothing in the test or the app can defend against it; it needs an xcodebuild-level
retry if it recurs in Cloud. Recorded here so it is recognised rather than re-diagnosed.
## 2026-09-21 · Phase 4.1, 4.2 and 4.5 — the felt register, decided by measurement rather than by eye

Charter §4 hands Phase 4 a mandate with no hands in it: satisfy audit §H's thresholds **through automation**, with XCUITest and snapshot tests in place of a person looking. Ashrey receives the finished experience once. So every call below is a number somebody can re-run, and three new suites hold them.

**Every site was located by its text and its characteristics, never by the audit's line number.** The audit was written against `522cdd3`; Phase 1 deleted seven files, the ledger re-wire reshaped `AirtableService` and `ShaktiDetailView`, and Phase 2 rewrote `WellView` whole. Not one of §H2's or §H4's line numbers still points at what it named. The sweep found 28 live sub-threshold `Text` sites against §H2's 31: the three `WellView` sites were raised in Phase 2 (the errata records them) and the felt-count digit in `TheHundredTwoView` was deleted in Phase 1. Both were left alone, as instructed.

### 4.1 · Where the floor was set, and why not at the floor

FIDELITY rule 4 asks for **≥ 11 pt and ≥ 0.5 α**. Everything raised went **above** it — 11.5 pt, 0.55 α — and only two strings sit exactly *on* it: the ghost exit hints, "tap to enter" (Homecoming) and "Tap anywhere to close" (the Recognition ceremony). §H3 calls them intentional ghosts and §H2 lists them as failures, and both readings are right: they are meant to be barely there, and "barely there" still has a floor. Sitting them at 11/0.5 while everything else clears it is what keeps them ghosts rather than promoting them into instructions — and it makes the pin exact, so a drift in either direction is a red test rather than a matter of taste.

**Judged decorative, and exempt under rule 4's own words.** Six glyphs: the three disclosure chevrons "›" (the Field's ring row, the Well's ring row, Today's celestial strip), the two back arrows "‹" (Detail, the Well letter) and the Significance card's dismissal "×". Each is furniture rather than language — an arrow that rotates to say open or shut carries no words, and every one of them sits beside a label that is held to the full threshold. Nothing else was exempted: the Portrait's "she is felt, not measured" whisper, which the audit called borderline decorative, was raised, because it is the never-measure law spoken to the walker and a law that cannot be read is not a law.

**Two sizes the scanner refuses to evaluate**, pinned rather than guessed: the Rite's veil name and the Rite block's name are `min(nameSize(cap:…) * 1.7, 150)` and never fall under 27 pt. A source scanner that evaluated arithmetic would be a scanner that could be wrong quietly.

**One composition change inside the canvas**, made for legibility and not paid back: the Mandala's deep-zoom bīja line moved from `dotR + 20` to `dotR + 24`. At 10 pt and 8 pt the two lines just cleared each other; at 11.5 pt they would not, and a seed set inside her own name is less legible than either was.

### 4.2 · Eight targets, and the rule that the composition does not move

All eight reach ≥ 44 × 44 by rule 4's own idiom, `.frame(minHeight: 44)` with a `.contentShape`. The instruction was that **growing a hit area must not move the visual composition**, which rules out the obvious form of the idiom, since a control that simply grows pushes its neighbour down. So every growth is a *known* number of points and the same number is taken straight back out of a padding or a spacing beside it:

| Control | Was | Growth | Paid for by |
|---|---|---|---|
| LalitaSourceView · "↑ return to the field" | ≈19 pt | none | the padding was on the `Button`, outside the label — moved *inside* it. 62 pt, identical layout |
| ShaktiDetailView · hold-to-cross pill | ≈25 pt | +20 below the capsule | the pill stack's spacing, 8 → −12 |
| TheHundredTwoView · "the threshold ›" | ≈37 pt | +8 | the row's own padding, top 8 → 4 and bottom 12 → 8 |
| DescentFilmView · CLOSE | ≈37 pt | +8 | the dots' bottom padding 14 → 10 and the button's 24 → 20 |
| DailyRiteView · celestial strip | ≈38 pt | +8 above the line | the strip's spacing, 7 → −1 |
| PortraitMandalaView · "hold this image" | ≈41 pt | +4 below the capsule | "close" gives up its `.padding(.top, 4)` |
| SettingsView · rename field | ≈42 pt | +2 below the box | the hint's top gap, 6 → 4 (the stack's spacing spelled out to make room for it) |
| RiteBlockView · "know her ›" | ≈42 pt | +2 above the words | the block's top padding, 10 → 8 |

Three of them draw a shape — a capsule, a rounded box — that is the *background of a padded label*, so padding added inside would have grown the ring the walker sees. In all three the growth sits after the `.background(…)`, under the shape rather than around it, and a test asserts that ordering. A thumb comes from underneath anyway.

### 4.5 · The device slips

**The seat glow under the zoom column** (device audit, Also-observed 5). The controls carried `Circle().fill(Color.ground.opacity(0.55))` — one value out to the rim — which stamps a hard dark disc over any seat lit behind the column. Replaced with a four-stop radial wash: 0.72 under the glyph, where it has to stay dense for the glyph to read against a lit seat, falling to **exactly zero at the rim**, so her light carries through the column instead of ending at an edge. The test asserts the rim reaches nothing and that the wash never brightens outward (a wash that brightens has a ring in it).

**The two system-sans slips** (Also-observed 6). The Detail's quality paragraph becomes Cormorant at 15 pt — it was the one body text in the instrument still speaking in somebody else's voice. The Settings title now comes from a principal toolbar item in Cormorant; `.navigationTitle("Settings")` stays beneath it, because VoiceOver and the back stack read it and only the *rendering* was wrong.

**Reduce motion, toggled mid-session** (FIDELITY rule 3). `DustMotesView` read the environment at `onAppear` and never again, so a walker who turned the setting on kept a sky full of moving dust until the screen was left. A mote now answers the *change*: a fresh assignment inside a transaction with animations disabled replaces the running `repeatForever` outright, and the mote settles at mid-phase; turned back off, the loop starts again. A test asserts that every repeat in the file lives inside that one gated function, so a second loop cannot appear outside the gate.

**Staged first paint is not investigable here, and is not being quietly dropped.** Also-observed 7 is a frame-timing observation made on a simulator sharing a Mac that was building at the time. There is nothing in the source to assert and nothing a simulator can measure that would mean anything; it belongs with the G5 baseline, which is BLOCKED on the phone in both audit sessions. A test fails if this paragraph stops existing, which is the only way an item with no code in it can be carried.

### What proves it, since nobody will look

- **`LegibilityTests`** (unit) reuses `LawsTests`' Swift lexer — the part that already knows a string literal from code — and adds the walk it never needed: the modifier chain trailing a `Text(…)`, because a string's size and alpha live in the six lines after the call. Three locks: every `Text` in `Views/` against 11 pt and 0.5 α; **no `.font(…)` anywhere in `Views/` under 11 pt at all**, which is what catches type set on a container and inherited; and the two ghosts pinned to exactly the floor. A `.opacity(…)` modifier counts only when its argument is a bare number — `.opacity(arrived ? 1 : 0)` is a staged arrival, rule 3's business, and reading it as alpha 0 would condemn every screen that fades in. Inside a colour expression the dimmer branch of a ternary *is* judged, which is what catches an unlit seat name at 0.42.
- **`HitAreaTests`** (XCUITest) measures six of the eight on a running app, where `XCUIElement.frame` is the frame iOS hit-tests. The other two cannot be reached by a launched simulator and say so: the crossing pill needs a practice history, and "the threshold ›" needs an āvaraṇa row. **`HitAreaIdiomTests`** (unit) holds all eight at the source, and holds the compensation ledger above — remove a compensation without its growth and it is red in a second rather than a build later.
- **`FeltRegisterSnapshots`** (XCUITest) is the composition lock, on **iPhone 17 Pro Max, iPhone 17 and an SE-class screen**. A snapshot here is not a PNG: a screen that breathes differs from itself on the next run, and a test that goes red for weather gets muted. It is the screen's *geometry* — every element the accessibility tree exposes, with its frame to a quarter point. The committed baselines are the geometry of `main` **before** this phase, so every element that moves is compared against the pre-change screen, and the only way past a move is to write it into `FeltRegisterClassifications.shifts` with its reason.
- **`DeviceSlipTests`** (unit) reads the wash's stops, the two faces and the motes' gate.

**Two screens have no picture, and the reason is data, not effort.** `AvaranaThresholdView` and `NityaDetailView` render rows that exist only in Airtable — `ShaktiBootstrap` seeds the sixteen Ring-2 Śaktis and nothing else, so a simulator with `SYNC_OFF` has no āvaraṇa and no Nityā to open, and a launch argument pointed at either quietly no-ops. Their strings are held by `LegibilityTests`, which reads the source rather than the screen. Their geometry is unproven, and saying so is better than seeding fake content to make a test green.

**Errata for the brief.** `OPEN_LETTER=<n>` takes the **khaḍgamālā** position, not the ring-relative 1–16 the device audit recorded: `Shakti.letterKey` is `khadgamalaPosition ?? position + ringStartOffset(2)`, so an unsynced bootstrap row answers to 29–44 and `OPEN_LETTER=1` silently no-ops. Found by driving it, not by reading the note.

### Four calls inside Phase 4 that the sweep itself forced

**The Field's compensation asks whether there is anything to compensate for.** "the threshold ›" and the caption beside it are all `if let avarana`, so before the first sync the whole row collapses to nothing. Taking the 8 pt back from a row that is not there lifted every seat in the ring by 8 pt on a fresh install — the snapshot caught it on both widths. The padding is now a ternary: it pays the 8 pt only when the row exists. Exact in both states, and ugly enough to be obvious.

**The first embodiment node brightens with the pill.** `nodeColor(0)` colours two things: the crossing pill's label at level 0, and the first circle of the four-node embodiment track. Raising it from 0.4 α to 0.55 for the label's sake brightens a 6 pt dot by the same amount. Judged worth it: the alternative is a second colour that means the same thing, and a track whose first node is *below* the legibility floor is a track whose first node cannot be seen either.

**The snapshot harness measures displacement, not size.** A string that grows because its type grew has not moved — it is anchored where its stack put it and the growth came out the other side. So an element's displacement on an axis is the smallest distance any of its three anchors travelled (leading edge, centre, trailing edge): if one held still, the element held still and only grew. A string shoved down by a taller neighbour has no anchor that held, and all three report the same shove. Without this the first run reported every widened label as a lateral move of half its growth, which is noise that would have buried the real ones.

**Two things the harness has to be told, and now says out loud.** The ceremony screen *writes* — `AUTO_RECOGNIZE` records a real local recognition — so it runs last, and the Detail is captured on kp 33 rather than today's kp 29, because Her Moments would otherwise grow a row on every pass and the screen's geometry would differ from itself. A simulator that has been felt in still shows "felt here" on the Field next time, so the run erases its simulators first and the test fails with that instruction rather than with a mysterious diff. And the film is a cover over Settings — a `fullScreenCover` leaves the tree beneath it in the accessibility tree — so it is read as *what the cover added*, subtracting the screen underneath, rather than as nine tenths of a scrolled sheet whose last visible field prompt depends on where the flick stopped.
## 2026-09-22 · Phase 4, run through — what the scaffolding said when it was finally run

The previous run wrote the three suites and died before it ever executed them. Built and run, the branch was **552 unit tests green on the first build** — the legibility sweep, the hit-area ledger and the device slips all held — and the XCUITests, which had never been executed at all, were **red in seven places**. Every one of them is written down here, because a verification harness that has never run is a claim, and the difference between the claim and the fact is the whole reason this phase exists.

### Two things in the harness that were reading the clock, not the composition

**A run of digits is one `#`, not one `#` per digit.** `ElementFrame.normalize` blanked digits one for one, so the ceremony's own line — `SHE WAS FELT HERE · 9:07 PM` — recorded as `#:## PM` and came back at ten o'clock as `##:## PM`. A different key is a *gone* element and a *new* one, so the suite reported the Recognition screen half-destroyed and half-invented, every night, for one hour in twelve.

**And the meridiem with it.** The Pro Max run crossed midnight and the same line went from `PM` to `AM`. `#:# PM` → `#:# ~`, scoped to a meridiem that follows a blanked number so a walker's own "AM" would be left alone. Both foldings were applied to the committed baselines mechanically — the same transformation on the stored key and the live one, never a re-record.

### The ordering hole, and the answer that removes the requirement entirely

`BinduMandalaUITests.testFeelHerOpensRecognition` records a real recognition, and it sorts before `FeltRegisterSnapshots`. So in a single `xcodebuild test` the Field was always read off a store that remembered one, said "felt here" beside Kāmākarṣiṇī, and reported a composition change that was really the container remembering the last run. The harness's own answer was "erase the simulator between passes", which is an instruction nobody will follow at two in the morning.

**`EPHEMERAL_STORE`** replaces it: a UI-test launch opens a fresh in-memory store and leaves the disk alone, so every screen reads the instrument exactly as a new install does — which is the state every baseline was recorded in — and nothing a test writes outlives it. The suite is now order-independent and re-runnable, proved by running it green on a simulator that was *deliberately left dirty* from the previous pass.

Law 8 is why it is shaped the way it is: the argument exists only under `#if DEBUG`, and the branch returns before anything on disk is opened, preserved or removed. `EphemeralStoreTests` holds both halves and holds it off by default.

### Four controls the XCUITest could not reach, and why each one could not

- **The film's CLOSE.** `OPEN_FILM` is read in `SettingsView`'s own state, so launching with it and never opening Settings measured nothing at all. The test opens Settings now.
- **The Field's threshold row.** The predicate asked for `Āvaraṇa` and the row announces itself as "2nd Avaraṇa" — `[c]` folds case but not diacritics, so it matched nothing. `[cd]`, and the row is measured wherever it exists.
- **The threshold and the celestial strip, where the data is not there.** Both are `if let` on rows that live only in Airtable; under `SYNC_OFF` there is no āvaraṇa and no Nityā, and the committed `rite` baseline shows the strip as the moon glyph with no button beneath it. A data absence and a control under the floor are not allowed to look alike, so each is measured where it exists and **skipped out loud** where it does not, with its source pin named in the skip.
- **The Portrait's export — and this one was a real defect, not a harness gap.** Every layer of the artwork sets `.allowsHitTesting(false)`, so the ZStack had no hit-testable content and the long press that makes the image **had nothing to land on**. The export has never been reachable. Audit §H4 measured it at ≈41 pt from the button it opens; the truth was that the button never appeared. A `.contentShape(Rectangle())` over the artwork's own square fixes it — it draws nothing and moves nothing — and `HitAreaIdiomTests` now holds the gesture and its shape together.

### The one live number this harness will not pretend to read

Inside the export sheet, **everything reports at about 0.96 of the points it is laid out in**: the pill and "close" both declare `minHeight: 44` and both come back 42.25, and the 16 pt Cormorant line between them reports 18.9 where it sets at 19.7. A reported height in there is not points on a screen. Growing the pill until the *reported* number cleared 44 would have meant fattening a drawn capsule by six points to satisfy a measurement that means nothing — the loud mistake §4 warns about. So this control's floor is held at the source, on the ledger that reads the real file, and the XCUITest proves the thing that was actually broken: that the sheet opens at all.

### Where the felt register stands

Green on all three device classes — iPhone 17 Pro Max, iPhone 17 and an SE-class screen — with the ten-screen composition lock passing against the pre-Phase-4 baselines on every one of them. 552 unit tests and 11 UI tests, 0 failures, 0 Swift warnings. Two UI tests skip with their reason on a simulator that has never synced; both are pinned at the source.

**Contention, named rather than worked around.** A second branch was building and testing on this host throughout. `kAXErrorIPCTimeout`, "Early unexpected exit" and a 403-second launch all appeared and all passed on retry, unchanged — the charter's rule held exactly as written, and nothing was edited to make a busy machine go quiet.

## 2026-09-22 · Phase 4.3 and 4.4 — Dynamic Type, and VoiceOver on the Mandala

### 4.4 · The 102 seats speak, and they are `other` elements rather than buttons

The living Mandala is one `Canvas`. Its strokes are not views, so to VoiceOver the
whole instrument was a blank rectangle — audit §H5's finding, and the reason the
brief calls this the item that makes the instrument reachable at all.
`MandalaAccessibilityLayer` is the tree the drawing does not have: one element per
seat that is on the screen, one per enclosure whose ring is, each standing exactly
where the canvas drew the thing it speaks for.

**They declare no `.isButton` trait, and iOS gives them one anyway.** The intent was
to keep them out of every suite that reads buttons off these screens —
`HitAreaTests` measures every button's touch area on the running app,
`FeltRegisterSnapshots` records every button's frame as the composition, and
`SnapshotScreen.tapHamburger` finds the menu *by being the button in the
top-trailing corner*. The first run said otherwise: all seventeen came back as
`button`, because an accessibility element that carries an activate action **is** a
button as far as the system is concerned, and these carry one so a voice can arrive
at a seat. That is the right answer for the walker and it is not negotiable away, so
it was written down instead: `FeltRegisterClassifications.appeared` now names the
seats and the enclosures on the two screens the layer reaches, with the reason.
Nothing drawn moved — the elements are `Color.clear` and hit-test nothing — and the
hit-area walk was measured on the running app with them present and stayed green,
because each is exactly the 44 × 44 the same rule asks of every other control.

One hazard is left standing rather than papered over: `tapHamburger` finds a button
by its corner, and a seat can sit in that corner. It reaches for the menu on one
screen only, the Well, where the Mandala is not on the screen at all. If a later
pass opens the menu from the Mandala, that helper needs a name to find rather than
a corner.

**The layer draws nothing and hit-tests nothing.** `allowsHitTesting(false)`, so the
field's pan, pinch and tap all still belong to the one gesture catcher underneath
and `nearestSeat(to:)` stays the single answer to "which seat is this". VoiceOver
never hit-tests — it performs the element's own action — so `handleTap(at:)` was
split: it finds the nearest seat and hands it to `activate(_:)`, and the spoken
layer hands the same seat to the same function. One door, two ways to reach it, and
a test that reads both files and holds them to it.

**Her seat is spoken in words, not numerals.** A khaḍgamālā position is identity and
the charter permits saying it. It is said as *"twenty-ninth of the one hundred and
two"* rather than *"29 of 102"* — which means the whole spoken surface contains no
numeral at all, and the never-measure detector has nothing to weigh. `LawsTests`
already pins one non-identity digit shape in the tree; this phase adds none.

**The transliteration, never the diacritics and never the Devanāgarī.** Sixteen of
the 102 carry a `phonetic` field; the other 86 do not, and the brief says to speak
the transliteration we have. `MandalaVoice.romanised(_:)` is an explicit table
rather than a `stripDiacritics` transform, because stripping is wrong exactly where
it matters: it turns `ś` into `s`, and *Sparsakarsini* is a different word from
*Sparshakarshini*. The 16 phonetics are also repaired for an ear — the middle dots
become spaces, and a syllable written in full capitals (`SHAH`, a stress mark to a
reader) is title-cased, because a synthesiser spells an all-caps word out. The
Devanāgarī line on the Detail is labelled as *what it is* and its string is never
handed to a voice.

**The labels are composed when the field changes, not when the camera moves.** The
host rebuilds the spoken layer on every camera change, and a drag is sixty of those
a second; romanising 102 names inside that is 102 string walks per frame on the
screen the whole instrument is reached through. `MandalaVoice.spoken(for:)` runs in
`rebuild()`, beside the atmospheres that are precomputed for the same reason, and
the layer does geometry and nothing else. Both halves are held by a test that reads
the two files.

### 4.3 · Dynamic Type — three scaled tokens, and nine written-down exceptions

Audit §H5 counted 152 fixed-size font sites in Views, zero text styles, zero
`relativeTo:`. `AppFont` now vends three scaled tokens — `sanskrit` and `voice` as
`Font.custom(_:size:relativeTo:)`, and `label` through `UIFontMetrics`, because
`Font.system(size:)` has no `relativeTo:` of its own — and every meaningful site in
the shipped screens goes through them.

**The designed size is still the designed size.** At the default content size every
token returns exactly the point size written at the call site, which is why the
composition baselines recorded before this phase still pass unchanged. A test
asserts that directly, because if it ever stops being true every `.geom` file in
`iOS/SnapshotBaselines/` is measuring a different app.

**A size is measured against the style it is nearest**, one table in `AppFont`, so
no call site makes the judgement. This decides how *fast* a size grows: at the
largest accessibility setting `caption2` roughly triples while `largeTitle` grows by
about half. A 60 pt name that tripled would be four words on nine lines; an 11 pt
strip that grew by half would still be unreadable.

**Nine sites keep a fixed size, each pinned by exact file-and-source in
`ScaledType.fixedByDesign`:** the three canvas-drawn strings the brief excepts in as
many words (they have no line box to wrap into and no stack to push — growing them
would overlap the seats they name, and §4.4 hands the same three strings to
VoiceOver, which scales with the voice instead); the five marks centred in a fixed
target (`+`, `−`, `⤢`, `♪`, `×`, `‹`), which are clipped rather than read if they
grow past their own disc; and two drawings measured from the screen at run time
rather than chosen — the ceremony's ghost bīja at 300 × the focal scale, and the
Rite's name, already fitted to its box and then shrunk again. A tenth, the rite of
entering's stroke-drawn Devanāgarī, is pinned rather than reached into: `Views/Rooms/`
belongs to the open Phase 3 branch and the charter's parallelism rule is disjoint
files. The pin is compared in both directions, so an exception whose site has gone
fails as loudly as a new raw size.

**Fixed heights became floors.** Four buttons and a bīja block stood in
`.frame(height:)` — a box that cannot grow with its contents. They are
`.frame(minHeight:)` now: the same number at the default size, a floor rather than a
ceiling above it. A test refuses any `Text` with a font whose chain contains a fixed
height, with one pinned exception: the card's close is the mark `×` at a fixed size
in the 44 × 44 target `HitAreaIdiomTests` holds it to, where a floor would be a
floor under something that cannot rise.

**One number moved that was not type.** Settings' last two rows settled 12.5 pt
against the 11 pt already classified for §4.1, and the bound went to 14. A scaled
token is `Font.custom(_:size:relativeTo:)` rather than `Font.custom(_:size:)`, and a
font measured against a text style carries that style's own line metrics: the same
glyphs at the same point size, in a line box a hair taller. On one row it is
invisible; Settings is eight cards deep. It is written into the classification with
that sentence. Nothing on any other screen in the roster moved past a bound it
already had.

**What is not done, and why.** The zoom column's four glyphs and the card's close
carry no accessibility label — audit §H5 lists them, and naming them changes what
the composition snapshots read, so it is not folded into a type migration. The nine
enclosures are spoken but the Mandala's header, its zoom column and the significance
card are left at their existing accessibility, for the same reason.

---

## 2026-09-22 · Phase 4 review fixes — the half-point that re-composed the home screen

Seven findings against the 4.1–4.5 branch. Five were real and are fixed; two are
rejected with a reason. Everything below was proved on a running app, on all three
device classes, before and after.

**The root of it was one line of arithmetic.** `UIFontMetrics` quantises its answer
to a third of a point, so a half-point size does not survive the round trip:
`scaledValue(for: 11.5, compatibleWith: .large)` is **11.666…**, not 11.5. Every
`AppFont.label(x.5)` site — nine of them, across the Rite, the Detail, Settings, the
Field, the card, the Bindu, the threshold and the Nityā sheet — was therefore
shipping **1.45% larger than it was drawn**, and the branch's own
`testAtTheDefaultSizeNothingMoved` was failing on exactly that, unnoticed because
the 4.3/4.4 commit was never run. The premise the whole phase rests on — *at the
default content size every token returns the point size written at the call site* —
was false the moment it was written down.

**And it had already moved the app's home screen.** The Rite's kicker is one line of
327.75 pt in a 346 pt column: a quarter of a point of slack. 1.45% of the glyph run
is about 2.7 pt, so the kicker broke over two lines and, sitting between two
`Spacer(minLength: 0)`, split the difference and settled the entire centre column —
her name, her quality, her phonetic, "know her ›" — **seven points down the glass**
on both phone classes. `FeltRegisterSnapshots` said so on `rite` and `recognition`
the first time it was asked.

`AppFont.labelPointSize` now normalises the metric against its own answer at
`.large`: the ratio carries the growth, the designed size is what it grows from. At
the default category the identity is exact; above it the strip grows in the
proportion its text style grows. The test asserts the **token** rather than the
metric, and a second test pins the reason — it asserts that the raw metric really
does still quantise, so the normalisation cannot be deleted as a no-op without
somebody meeting the fact that made it necessary. With it, the kicker is 327.75 pt
on one line again and the composition lock passes on all three classes.

**Nothing was added to hold the kicker on its line.** A `.lineLimit(1)` there would
have changed the SE, where the baseline shows this string has *always* wrapped to
two lines at 166.50 × 27.50. The defect was the 1.45%, and the 1.45% is gone.

**Two screens had nowhere to grow, and did not overflow — they were cut.** The Rite
and the Bindu are the app's two fixed tableaux: a `VStack` between two
`Spacer(minLength: 0)` that are already at zero on an SE at the default size. Type
that grows inside a height it cannot exceed does not run off the bottom; SwiftUI
proposes each string less room and the strings **truncate**. At the largest
accessibility size the Rite's own question read `“Where does w…` — the most
meaningful sentence on the home screen — while the moon was pushed up under the
status bar; the Bindu's closing paragraph lost a fifth of its height the same way.
Above `.accessibility1` both columns are now wrapped in a `ScrollView` with a
`minHeight` floor of the screen: the spacers keep doing their work for as long as
the column fits, and only then does it scroll. Below `.accessibility1` — every size
a walker who has not turned on accessibility type will ever see — the `ScrollView`
is never built and the fixed column is the one the baselines were recorded against.
Enabling Dynamic Type on a composition with nowhere to go is what broke these; the
fix is to give it somewhere, not to stop it growing.

**The Well's title needed a lower floor, not a second line.** On an SE it is already
shrinking at the default size to keep clear of the hamburger's lane; once it scaled
it needed about 0.69 at the largest size, hit its 0.75 floor, and read `Your
Letters…`. The floor is 0.55. Letting it wrap instead was tried and reverted: a
second line pushes the whole Well **thirty-eight points** down the SE at the
*default* size, which the lock caught on `se/well` and `se/settings` — the exact
composition change this phase is forbidden to make, arrived at while fixing an
accessibility bug. `minimumScaleFactor` is only ever consulted when the text does
not fit, so a lower floor costs nothing at any size that fits today.

**The crossing pill's target was about 34 pt, not 44.** It buys the whole target
with `.padding(.bottom, 20)`, and `VStack(spacing: -12)` pulls the "hold to cross
into …" caption back up over the lower twelve points of it. A plain `Text` is
hit-testable and is drawn after the pill, so a thumb landing in that band lands on a
caption with no gesture and the long press never begins. The caption now says
`.allowsHitTesting(false)`. Nothing drawn changes and the −12 compensation is
intact. This is the one of the eight targets no live measurement reaches, because it
appears only when a Śakti is ready to cross — which is why it was typed correctly,
locked by `HitAreaIdiomTests` for the idiom, and wrong in fact.

### The two locks that could not fail

**The suite was rotting on the calendar.** `ElementFrame.normalize` folds a digit run
and a meridiem, but `LunarPhaseService.headerLabel` lands in the key verbatim:
`WAXING GIBBOUS · #TH NIGHT`. When the phase turns, or on nights 1–3 and 21–23 when
the suffix folds to `#ST`/`#ND`/`#RD`, the key changes — and a changed key reads as
`gone`, which this file deliberately makes unclassifiable, plus an unclassified
`new`. Four failures on two screens on every device class, on the weather, with no
code change at all: precisely the *"a test that goes red for weather gets muted"*
outcome the file's own header exists to prevent. `foldMoon` folds the phase and the
ordinal night the way `foldClock` folds the hour, and the identical transformation
was applied mechanically to the six committed keys — the same *same transformation
on the stored key and the live one, never a re-record* discipline the meridiem used.
The frames needed no help: a shorter phase name re-centres the strip and the
comparison already takes the smallest of three anchors.

**The largest-size sweep measured only width, and that is what certified the broken
Rite as green.** Truncation by definition keeps a frame inside its box, so a cut
string moves no bound; and the vertical axis was skipped outright because *"a
vertical bound would fail on every scrolling screen"*. Both halves are closed:

- The vertical bound is now asserted **on a screen that has nowhere to scroll**,
  which is the same judgement the horizontal bound makes, turned ninety degrees.
  The screen is asked, not assumed, so the Rite and the Bindu are checked below
  `.accessibility1` and exempt above it, where they now have somewhere to go.
- A new check reads each screen **twice** — at the default size and at the largest —
  and matches its strings by the composition lock's own folded key. No public API
  asks an element whether it was truncated, and the width a label needs cannot be
  computed without knowing the token it was set in; but one thing is always true and
  needs neither: **bigger type is never shorter.** A string that occupies less
  height at the largest size has not re-wrapped, it has been cut. The bar is 8%,
  which sits above the three per cent a one-line name with `minimumScaleFactor`
  legitimately gives back to stay on its line, and below one line lost from six.
  It found the Bindu on its first run — a screen no finding had named.

### Rejected

**`AppFont.label` does not re-resolve while the app is running.** True, and it stays.
The token builds a concrete `UIFont` at body-evaluation time, so a walker who changes
the system text size *while Bindu Mandala is running* and returns finds the Cormorant
strings rescaled and the system-sans strips frozen at the size the app launched with,
until the next cold launch. There is no fix that is both correct and small: SwiftUI
invalidates only views that **read** `\.dynamicTypeSize`, and a `ViewModifier` cannot
read it on a child's behalf, so either all fifty call sites change idiom (and the
source scanner that polices them changes with them), or the system face is reached by
its private PostScript name so `Font.custom(_:size:relativeTo:)` can scale it from the
environment. The first is a fifty-site rewrite plus a scanner rewrite for a walker who
changes text size mid-session; the second is a private-name dependency under every
small-caps strip in the app. Neither is what makes this build worth installing, and
both are larger than everything above put together. Written down here rather than
fixed, with the route named: `@ScaledMetric` per site, or the `labelPointSize(_:_:
compatibleWith:)` seam that now exists, taking the category from the environment.

**A live per-string truncation assertion, in the form the finding asked for.**
XCUITest returns the untruncated label, but the *width that label needs* cannot be
computed without knowing which token drew it, and the test process has no way to ask.
The two-reads height comparison above is the same guarantee reached by something that
is actually true.

---

## 2026-09-22 · Phase 3.7 · The way in, the way out, and where a door belongs

Everything Phases 3.1 to 3.6 built stood behind a door nobody had cut. `RootView`
offered five destinations and not one of them opened a Home; nothing in the shell
called `RiteOfEnteringView.entering(_:remembering:)`; `WorldClimbView` was
referenced nowhere outside its own file. The rite, the hundred and two rooms, the
nine-āvaraṇa climb and the Gate — the bulk of the work — were dead code in the
shipped app, and the MVP ruling of 2026-09-21 named this as the gate: *the line
is reachability, not fewer rooms.*

The wiring was an afternoon. The placement was the phase.

### The two doors, and the argument for each

**Her room opens from her own screen, at the foot of it.**

Three screens find a Śakti — her seat in the Mandala, her row in the Field,
today's Rite — and **all three arrive at `ShaktiDetailView`**. That makes it the
only place in the shell where one door is the *same* door for every one of the
hundred and two, reached however he came to her. Every alternative cuts the
instrument: a door on the Mandala's significance card reaches only the seats the
canvas has drawn; a door on the Field's rows is a room reached like a file; a
destination in the hamburger is a list of rooms, which is the one shape the brief
names as the failure.

Within the Detail it stands in the **footer**, above *"I feel her"*, and three
things put it there.

It is the only part of that screen that does not scroll, and it is where the
screen's **acts** already stand. Everything above is what is *known* about her —
her portrait, her somatic line, her bīja, the moments she has been felt — and a
walker who opens her and wants only her should not have to read the archive to
reach her.

It completes a ladder the app was already climbing and had never named. The
Mandala's card offers **know her ›** and lands on the Detail. The Detail now
offers **be with her ›**, and beneath it **I feel her**. Reading, staying,
recognising: each a deeper act than the one above it, in the order the screen
puts them in. The room is not a sibling of the recognition — it is the ground the
recognition is made on, so it stands above it rather than beside it.

And it costs the screen nothing. The footer grows downward from the scroll's own
edge, so **not one element of the Detail moves**. The composition lock has no
shift entry for the Detail in this phase, which means any movement there is still
a failure; the door needed one sentence in `appeared` and nothing else. That is
not convenience, it is the design virtue: a door that disturbs the screen it
joins has been put in the wrong place.

It is **unconditional**, and `testTheDoorAsksOnlyWhetherSheHasARoom` reads the
source to prove it: the one question the Detail may ask before offering her room
is whether she has one. Her ring, her cluster, whether she has been felt, whether
the base has answered — any of those would make some of the hundred and two
reachable and others not.

**The climb opens from the Field's header.**

Not the hamburger. The menu holds five ways of being in the instrument; the climb
is not a sixth, it is what four of them are lists and pictures *of*. `RootView`'s
`Destination` is untouched, and a test asserts the enum by exact equality — the
enum having room for a case is not an argument that one belongs there.

**Not the Āvaraṇa threshold, and that was the close call.** It is the better
reading: `AvaranaThresholdView` is the doorway of one enclosure, and the climb is
what lies on the other side of it — a door that today opens onto a text would
open onto the world. It is refused on one fact rather than on taste. The
threshold needs an `Avarana` row, and those rows live only in Airtable. On a
fresh install, offline, or before the first sync has answered, the whole climb
would be unreachable — and the surface that is the bulk of Phase 3.2's work may
not be gated on the network having replied. Recorded here so the reading is not
lost: if the āvaraṇa rows ever ship in the binary, the threshold is where this
door should move.

So it stands on the one screen in the app whose subject **is** the nine. The
Mandala's subject is the yantra as a figure; the Rite's is today; the Well's is
what he has written; the Memory's is his own field. The Field's own second line
says *nine rings · one hundred and two*, and the line beneath it is those nine,
**walked instead of listed**. It opens at the āvaraṇa he has open in the
accordion, so he rises from where he was already standing rather than from the
first every time.

That one costs 52 pt in the header. Eight are paid for out of the header's own
bottom padding (14 → 6, because a 15 pt line centred in a 44 pt target already
stands about fourteen points clear of its own box); the other **44 are
classified**, and the `field` bound went from 2.5 pt to 44. That is a real loss
of resolution on one screen and it is written into the file rather than waved
past: a rigid translation of a whole list cannot be expressed more tightly in a
vocabulary of per-element maxima. What is still caught is any element that moves
*further* than the door pushed it, and every arrival.

### No room without the rite, and it is a fact about the tree

The law is not held by checking that today's two doors happen to go through the
ceremony. `testTheOnlyRoomInTheShellIsTheOneBehindTheRite` reads every shipping
file off disk and asserts that `RoomView(` is constructed in **exactly one
place**: `Views/Rooms/RiteOfEnteringView.swift`. There is nowhere else a room can
come from, so there is no path on which a walker arrives at a room without being
admitted to it. Its twin asserts the threshold itself is opened from exactly one
place, and that place is her own screen.

### The way out, which is the half that was not built at all

*Leaving a room should not feel like dismissing a modal*, and it turned out the
way out was missing in a second, larger sense: **`HomeMemoryStore.record` had
existed since Phase 2.2 and nothing in the app had ever called it.** A
compression that Phase 3.1 asserts at every value Design's curve can produce had
never had anything to compress — every entering was a first entering, for ever.
The way out is where that write belongs, and it is now made.

`Views/Rooms/TheWayOut.swift` is the one way out of anywhere in the Homes layer,
and four decisions are in it.

**Leaving is held rather than tapped.** The rite is paced by single touches and
can be, because a touch there costs nothing — the ceremony has nothing to lose
and the next beat is the only thing on the other side of it. A stay does have
something to lose: a stray finger that ended one would take the adaptation with
it, and the adaptation is the whole instrument. So the way out asks for the
gesture this app already uses for a crossing that cannot be taken back — the
Detail's own pill says *"hold to cross into …"* — and the hold lasts exactly as
long as the crossing it is: `RoomApproach.releaseSeconds`, Design's own 2.2,
**read rather than typed a second time**. In her room the hold *is* the walk: the
crossing out is `releasing` with its ends exchanged, so the eye stands away from
her through the āvaraṇa's own air for the whole of it, and letting go before it
is over carries him back in and puts the stay's two marks live again.

**Reduced motion steps out instead.** A hold is only legible while something is
travelling through it; with the render loop stopped there is nothing to watch,
and two and a fifth seconds of blank press is not restraint but a stopped clock.
So the still path is one touch, and the words follow the path — *touch to
withdraw*, in the rite's own `RitePrompt` wording, against *hold to withdraw*.
The whole distance is crossed either way; one is walked and one is stepped, and
neither is skipped, which is the same reading the rite took for its stations and
the climb took for its bands.

**The stay is measured to where he decided it ended, not to where the surface
went away.** The walk out is no more time in her room than the walk in was, so
the dwell is taken at the instant the crossing out begins and the dwelling is
ended there. If he lets go and stays, it goes on accruing. It is handed over
exactly once, by whichever of the two doors closes first — the way out, or the
surface disappearing under him — and never at all for a clock still held at her
threshold, which is a stay that never began.

**There is nowhere in it to say a number.** The way out is the only thing a
walker is shown inside a room besides the room, which makes it the most obvious
place in the instrument for a count to appear. It holds a `Bool` and three
closures returning `Void`, its whole vocabulary is two strings, and a test reads
its stored property types off disk and refuses anything else: a value it holds is
a value it can be made to show. The same discipline `HomeDwelling` is built with.

**And the threshold has no way out, deliberately.** `TheWayOut.shown` is false
for the whole of the rite. A ceremony three touches long does not need a cancel,
and a second instruction standing beside *"touch to go on"* would make the
crossing a thing one could be talked out of. **A threshold is not a dialog.**

### The defect the way out uncovered, one layer down

Wiring it turned a suite green everywhere except one place, and the failure was
not in anything this phase wrote: `testAReduceMotionWalkerIsCarriedToHisStation`
found a walker with Reduce Motion switched on standing **at the door for the
whole ceremony**. It reproduces with the way out removed entirely, and it does
not reproduce on `main`, so the trigger was two new stored properties on the
rite and the cause was underneath them.

`RoomApproachSource` is a reference on purpose — `RoomApproach`'s own header says
why: the driver reads the walker's distance sixty times a second on SceneKit's
thread, and passing it by value would mean re-rendering the SwiftUI tree every
frame to move the eye. The cost of that was never written down. **Moving the
walker changes nothing SwiftUI can see**, and with the render loop stopped
nothing asks the room for another frame; the re-pose that followed a touch was
produced by some *other* update to the view, and it had been incidental since
Phase 3.1. Two more `@State` slots were enough to stop it happening. The light
pass had the same shape and its own comment claiming the opposite — *"the
evaluation happens once per touch, because a touch is the only thing that moves
him."*

`RoomView.moves` makes the ask explicit, and it is not a new idea: it is the
token `WorldClimbView` already carries as `steps`, for exactly this reason, in
the phase that built the climb. The rite now moves the walker through **one**
function, `stand(at:)`, which sets the approach and bumps the token, and a test
holds that shape — a second mover that skipped it would move him where, on the
still path, nothing would ever draw him. Callers that never move him leave the
token at zero and pose exactly once, which is what `RoomDriver.posesApplied`
already asserts.

It is worth saying plainly that this was reachable before Phase 3.7 and nothing
had found it, because the thing that hid it was that the rite was unreachable.
The way out is what made the room a place a walker moves in twice.

### What the tests hold

`TheWayInTests` (17) and `TheWayInUITests` (5). Full suite: **689 unit tests and 25 UI tests, 0 failures, 0 Swift warnings on a clean build**; the thirteen skips are the ten opt-in spike benches and the three UI tests pinned to rows that live only in Airtable, all unchanged.

**Every new check was mutation-tested**, which is this file's own standing discipline: the door's guard narrowed to Ring 2, the redraw token's bump deleted, the way out's length typed rather than read, its words copied into a second file, and the threshold refused for the ninth āvaraṇa. Five breakages, five reds, each in the check written for it and in no other.

- **All 102, not a sample.** Every seat in the corpus is put through
  `RiteOfEnteringView.entering(_:remembering:)` — the exact call the door makes —
  and every one answers, onto her own position, onto a room that is hers rather
  than the shared seat. A row with no position and a row with no ring are still
  refused, so the guard is a guard.
- **The Gate.** kp 3 and kp 4 open by the same door onto `ReleaseRoom` and
  `PressRoom`, asserted as the concrete mechanism type rather than the enum case
  — the case is satisfied by a placeholder turn.
- **From a cold launch, with a finger.** Today → *know her ›* → *be with her ›* →
  the threshold (proved by the rite's own prompt, which exists only while he is
  outside) → the room → out, and **back on her Detail with her phonetic still on
  it**. Then in again, because a stay that cannot be repeated is not a stay. The
  way out is absent at the threshold and absent again once he has left.
- **Letting go keeps him in the room.**
- **The climb** opens from the Field, at the āvaraṇa the Field has open —
  asserted by the enclosure naming itself, `Sarvāśāparipūraka` — and lets him
  back onto the Field.
- **Nothing on either new surface measures him.** Two registers. In source, every
  walker-facing string on all five touched files through Design's nine patterns
  and the practice-value detector. On the running app, the labels that
  **arrived** with each surface, compared against what was on the screen before
  it: a whole-tree digit scan would have been a lie, because a `fullScreenCover`
  leaves the Detail's own *"29 · 102"* — her seat in the garland, which is
  identity — in the tree beneath it.
- **Return compression, intact.** Twelve recorded stays, the compression falling
  monotonically, and all three beats still struck at every value it takes.

The Gate and the other eighty-six are asserted at the unit level rather than
through the UI, and the reason is written into the suite: `ShaktiBootstrap` seeds
the sixteen Ring-2 Karṣiṇīs and nothing else, so under `SYNC_OFF` no other row
exists, and no UI run may let the app reach Airtable. What the UI suite adds that
no unit test can is that the call is reached **by a finger**.

`press(_:until:)` moved from a private method on `BinduMandalaUITests` to an
extension on `XCTestCase`. The flake it absorbs is a property of the simulator
rather than of the screen being driven, and a second copy of it would be a second
place to weaken.

### What is deliberately not built

**The corridor.** The MVP ruling names 3.7 as *"the corridor and the way in"*,
and only the way in is here. Neighbour doors that walk a ring are a second new
surface inside the room, and this phase's whole value is that the first one
works; the task's own acceptance list asks for reachability, the climb and the
way out, and none of it for a corridor. `RoomApproach`'s header already names the
doors of §4.7 as the same crossing with a different reason, so the layer is
waiting for them. It is a later build, not a missing piece of this one.

**A returning line, a rail, a beat pip, a progress fill on the hold.** All four
were available and all four are the same refusal Phases 3.1 and 3.2 already made.
The compression is *felt*: the ceremony is simply quicker, and he is never told
that it was.

---

## Phase 3.7, closed — the review pass: what was wrong, what was refuted, what was left

Two independent readings of `babb742` came back: a walker who installed the build and used it, and an audit of the branch against the laws. Both were treated as evidence rather than as findings. Every claim below was checked against the source before anything was changed, and the ones that did not survive checking are written down as refuted, because a confident finding that is wrong costs the next reader more than no finding at all.

### The one the walker ranked first, and he was right

**Her name in beat two was drawn in the OS's own sans.** `RiteWords.compose` sets `written: firstSpoken([devanagari, name])` — her Devanāgarī where the base carries it, her **roman name** where it does not — and `RiteOfEnteringView.written(_:)` hard-coded `.font(.system(size:))` for both, with a comment explaining the Devanāgarī half. The comment was true and the code was wrong: Cormorant genuinely carries no Devanāgarī, but a roman name is not Devanāgarī. Ahaṅkārākarṣiṇī (kp 31) has no Devanāgarī and is a Ring-2 Karṣiṇī that syncs, so the centre of her threshold — the one moment the instrument writes her name — looked like a system alert, between a Cormorant beat one and a Cormorant beat three, while her Detail rendered the identical string in Cormorant a tap away.

Nobody could see this before 3.7, because nobody could reach the rite. That is the whole argument for ranking it first.

The face now follows the string that was chosen rather than the field that was hoped for: `RiteWords.writtenIsDevanagari` asks which script `written` actually ended up in (the Devanāgarī block, Devanagari Extended, the Vedic Extensions), and the beat branches on it. The system face survives for the branch that needs it. `testBeatTwoAsksWhichScriptItEndedUpIn` and `testTheFaceOfBeatTwoFollowsTheStringAndNotTheField` hold both halves, and the second also pins that the rite reaches for the system face in exactly one place.

### The axis arrived mute, and now says what the hand may do

`WorldClimbView` put two lines on screen: the āvaraṇa's name, and `hold to withdraw`. A walker who arrived, waited, and saw nothing change was told only how to leave the thing he had just opened — the surface's entire instruction budget spent on the exit, with no word that the space rises. The climb is the payload of this phase's second door and it was invisible.

Design's own Axis carries four words for it, *"scroll to climb · drag to turn"*. Half of that is this file's gesture, so half of it is what is said: **drag to rise**, in the rite's prompt type, at the top of the frame where nothing else stands.

**It is not a measure, and it was checked against law 2 rather than assumed past it.** It says what the hand may do — the same register as `hold to withdraw` two inches below it — and it knows exactly one thing: whether he has moved *on this visit to the axis*. Nothing is written down, nothing is read back, and the next time he rises it is there again. An instruction that vanished for good the first time it was obeyed would be the instrument remembering him, which is the one thing it may never do. It is taken out of the tree rather than faded to zero, so a line that has been answered is not still there to be found by a finger or a voice.

### The hold on the axis had nothing travelling through it

`TheWayOut`'s own header sets the condition for asking for a hold at all: *"a hold is only legible while something is travelling through it… two and a fifth seconds of a blank press is not restraint but a stopped clock."* That is the whole argument for the still path being a **step**. The axis then applied `.theWayOut` with no `onBegan`, and its own comment conceded there was nothing there to unwind — so a walker with motion on held 2.2 seconds against a world that did not move, which is exactly the condition the file refuses one paragraph earlier.

So the world itself goes: the enclosure's air, light and name recede into the ground he came in through over precisely the length of the hold, and letting go brings them back. The still path is untouched — there the way out is a touch, and this is never called.

### The half-state with no way back

`onPressingChanged(true)` began the withdrawal — the stay ended, both dwelling marks cancelled, the eye walked to nothing — and the **only** thing that could undo it was `onPressingChanged(false)`. A press can be taken out from under a view without one: a call banner, the app backgrounding, and the digitizer teardown this file already records for the harness. The walker was then standing inside a room with the world withdrawn, both marks cancelled and never rescheduled, and no gesture that could recover any of it.

The withdrawal now watches itself. It is armed by `unwind(over:)` and disarmed by both honest ends; if neither has arrived a little after the crossing's own length (`withdrawalSlack`, 0.4 s), the only thing that can have happened is that the press was taken away, and he is put back exactly as a let-go would have put him back.

### The main thread and the render thread were posing the same room

`RoomDriver`'s own doc says where posing belongs: *"`SCNSceneRendererDelegate` runs on SceneKit's own thread… the only place a frame can be prepared without racing the frame being drawn."* `updateUIView` is the main thread, and it called `pose(at:)` too. Until this phase that was theoretical, because nothing moved the walker in a way SwiftUI could see and so nothing called `updateUIView` during a ceremony — which is the author's own premise for adding `moves`. `moves` is precisely a change SwiftUI can see, four or five times a crossing, and every one of them landed `scene.pose`, `scene.stand(atApproach:)` and a non-atomic `posesApplied += 1` on the main thread while the render loop was doing the same on its own.

**Ruling: on the animated path the render loop is the only thing that poses.** `setReduceMotion` poses from the main thread only when nothing has ever posed — the first frame, before `isPlaying` is set, with no loop to race — and never again. The still branch keeps its pose, because there is no loop there at all and `reduceMotion` is written before it, which is the flag the delegate reads to stand down. `WorldClimbDriver` had the identical shape and took the identical fix. Neither costs a frame: on the animated path the loop poses at 60 Hz and would have posed on the next frame anyway.

### The two comments this commit had made false

`RoomView.swift`'s header and `posesApplied`'s own doc both said the count *"stays at one however long the view is left on screen"*. After `moves` that is no longer what the code does, and it is the same class of defect the 3.7 commit message claims to be fixing. Both now say what is true: **time alone never raises it**, and the walker does — once per move, four or five in a ceremony, against sixty a second. The four existing assertions all leave the walker alone, so all four still read exactly what they were written to read.

### The composition lock: the weakening is undone rather than documented

This is the one confirmed charter breach in the branch. `ClassifiedShift(screen: "field", keyContains: "|", maxDelta: 46.5)` was raised from 2.5, and `keyContains: "|"` is in every key there is — so after that commit any element on the Field could move up to 46.5 pt undetected. The author named the loss in the file and in `leftBehind`, and the arithmetic was sound, but charter §3 says *"never skip a check, and never weaken one to make it pass,"* and a documented weakening is still a weakening.

**The reviewer's proposed alternative — re-record the `field` baseline from this tree and restore 2.5 — is refused, and it would have been worse.** These baselines are the geometry of `main` **before Phase 4**; re-recording one from this tree would dissolve every Phase 4 entry that baseline is holding, and turn a regression into a baseline, which is the one failure the file's own header says a composition lock cannot survive.

What was missing was vocabulary, not resolution. `ClassifiedShift` now carries `settles: [Double]` beside `maxDelta`: the rigid translations the screen's change is *expected* to have made, with `maxDelta` judged as the residual from the nearest of them. The Field's entry is `maxDelta: 2.5, settles: [0, 44]` — an element either did not move (it is above the door) or it moved by the door's own height (it is below it), and either way it may be 2.5 points off. Strictly sharper than the old 2.5 in one direction and strictly sharper than 46.5 in every other: an element that moves twenty points, or sixty, or that fails to move when all its neighbours did, is a failure again — none of which 46.5 could see. `settles: [0]` is the default, so every other entry in the table is unchanged.

### The first thing a new walker ever does was being swallowed

Pre-existing, outside 3.7, and fixed because 3.7 is what puts a first launch in front of a human. The notification-authorization prompt fired from a bare `.task` at launch, landing on top of `HomecomingView` — the app's one ceremonial greeting — and covering both its lines outright on the smallest screen. Worse than covering them: while the alert is up, the homecoming's tap-to-enter is inert, so the first thing a new walker does is swallowed and he learns before anything else that touching this app does nothing. The task is now keyed on `showHomecoming` and declines while the greeting is up. On every launch after the first the timing is exactly what it was.

### `know her ›` is now read against her own ghost

Pre-existing, and now the first rung of the only ladder into the rooms layer. It clears FIDELITY §4 on its own numbers (15 pt, 0.92 α) — its problem is that it is centred over the huge translucent ghost of her own name, so its contrast is not its alpha against the ground but its alpha against whichever stroke happens to run under it. Her name is carried on a shadow for exactly this reason; so is this line now. No size, padding or alpha changed, so nothing on that screen moves.

### The "level N of M" the reviewer asked for a ruling on — re-examined and upheld

`ShaktiDetailView`'s embodiment ladder speaks *"level 2 of 4"* to VoiceOver. It is already pinned in `LawsTests.pinnedNonIdentityDigits` with its reasoning; the ruling is now written into that pin.

**Upheld, on two facts.** The rung is not his practice: `ShaktiStatus` moves only when he presses the status pill, and no stay, recognition, silence or crossing advances it — so nothing here totals his walking, which is what law 2 forbids. And the screen already *draws* it: four circles with the reached ones lit, in everyone's plain sight. Deleting the words while leaving the circles would give a VoiceOver walker less than the screen gives everyone else, which FIDELITY's parity rule forbids in the other direction. The restrained option is not the quiet one here; it is the one that does not make the instrument say two different things to two different walkers.

### Refuted

**"A real Airtable row carrying a tattva or bodily location the grammar cannot read falls to `kind = .seat`, `isBuilt == false`, and the walker is admitted onto the gem-lit shared seat."** This is not true of the code. `HomeGrammar.read` declines on exactly one thing — `archetype(ring:position:)`, which is her **āvaraṇa** — and never on her words: `physics(tattva:quality:)` falls through to `.breathe` and `bodyAltitude(bodilyLocation:)` has its own floor. There is no content in a row that can cost her a room of her own.

The *shape* of the finding was right even though the claim was wrong — the check genuinely could not fail for the reason it advertised, because 86 of its 102 rows are composed from the corpus's own vocabulary. That is fixed below rather than argued with.

**"`RoomLightPassLayer`'s `moves` is unread and therefore decoration."** Not claimed by the reviewer, but worth recording alongside: it is unread on purpose in both layers. What it does is make the representable *differ*, which is the whole mechanism.

### Left behind, deliberately

**The texture seams.** Inside a Ring-2 room the acting form draws as a hard-edged rectangle with a visible vertical mirror seam, the depth bands terminate on hard horizontal edges, and on the axis the sky and ground meet on a hard horizon at about 45% of the frame. Everything about it is aniconic and abstract, nothing is broken, and no law is touched — but it reads as a UV artefact rather than an authored form. It is left. It is room-geometry and shader authoring across a whole ring plus the axis, it is not what makes this build worth installing, and 3.10 is the endless refinement pass this belongs in. Naming it here is the point: it is a decision, not an oversight.

**The walker's one preference** — that the way off the axis should use a different word from the way out of a room, because `hold to withdraw` on the Field's climb is withdrawing from nowhere in particular while in her room it is withdrawing from **her**. He called it preference himself and did not call it wrong. One instruction, learned once, is the stronger argument for an instrument somebody will use every day, and it is now also literally true: since the hold on the axis unwinds the world the way the hold in a room unwinds the approach, the same words describe the same thing in both places.

### The test gaps that mattered

Every one of these was a check that could not fail for the reason it claimed to guard.

- **"All 102" was 102 positions with 86 rows manufactured to suit the reader.** `testAnUnreadableRowIsStillEnteredOntoARoomOfHerOwn` drives the production call over all 102 positions with *every readable field emptied* — no tattva, no quality, no body location, no bīja, the worst a real row can be — and asserts a threshold and a room of her own for each. It is what refutes the seat claim above, by running rather than by arguing, and it goes red on the day that stops being true.
- **The "nowhere to say a number" property scan skipped every `static`, `@State` and `@Binding`** — that is, the only properties on the type that hold anything, and the exact shape a count would arrive in. `SwiftProperties` reads attributes and modifiers first; the test now names the two `gone` declarations it must have found, so a scan that goes blind fails instead of passing everything, and it separately pins the type's five static settings so a sixth is a failure.
- **Nothing asserted the door was in the body.** Deleting the one line that draws `herDoor` left every unit check green — the declaration and its `fullScreenCover` are still there — and the whole rooms layer unreachable again. `testTheDoorStandsInTheBodyOfHerScreen` reads the `body`, and also that the room stands above the recognition, which is the ladder's order.
- **The way out was asserted by grepping for a `guard` line.** A refactor that preserved the string and inverted the logic would have passed. `TheStay` lifts the four rules out of the view — the stay ends where he decided it ended, a let-go undoes that, the filing happens once by whichever door closes first, a ceremony he abandoned files nothing — and four tests drive them, including the still path's whole-stay case and the backwards-clock case that would otherwise file a negative dwell and make the next ceremony *longer*.
- **The redraw fix was proven as source shape, not as a frame.** `StillRoomRedrawTests` puts the room in a real window, moves the walker the way the rite moves him, and reads the driver's own register: time alone poses a still room zero more times, and every move poses it exactly once. The four existing `posesApplied` assertions build a `RoomDriver` by hand and never go through SwiftUI, so none of them could see either the regression or its return.
- **The reduce-motion way out had never been walked.** `REDUCE_MOTION` is a DEBUG launch argument carrying the same `forceReduceMotion` the captures use, reached from the shell so the whole path can be driven: `testUnderReducedMotionOneTouchLeavesTheRoom` asserts the word is different, that both words are never on screen at once, and that **one** touch puts him back on her Detail.
- **The runtime never-measure check looked only for digits.** "your third stay", "welcome back", "again", a streak spelled out — all pass a digit filter. The UI scan now also refuses a list of words that measure without one.
- **`testNeitherNewSurfaceMeasuresHim` hard-coded five filenames,** so a sixth walker-facing file in this layer would simply not be read. The list is derived: every file in `Views/Rooms/`, plus every screen that opens either door.
- **`testTheOnlyRoomInTheShellIsTheOneBehindTheRite` excused `Views/Spike/`.** The project synchronises its whole source root into the app target — the spike ships — so a `RoomView(` there would be a room in the shipping binary reached without the rite, and the exclusion was the one door that proof could not see through. Removed; it passes without it.
- **The UI suite's `crossing = 2.2` was a hand-copied constant** pinned to nothing, so the literal and the app could drift together and surface as a mysterious timeout. `testTheCrossingIsDesignsOwnTwoAndAFifthSeconds` pins `RoomApproach.releaseSeconds` to 2.2 by name.

`HomeDwellingTests`' count pin moving 2 → 5 was checked and is a re-pin rather than a weakening: the load-bearing loop is unchanged and still runs over all five sites, `HomeDwelling.begin` calls `end()` first, and `observe` re-asks idempotent guards that persist across the cycle — R11's *once per visit* holds.

### And one the three-times rule found, which no single run could have

The way-in UI suite was run three times back to back on an erased simulator, which is what the closing pass asks for, and it went red twice — in two different tests, on two different assertions, with nothing about the app changed between runs. Neither was the app.

**`press(_:until:)` was waiting on the wrong thing.** The helper exists to absorb the cancelled-press flake `DECISIONS.md` already records: it taps, waits for the screen it expected, and taps again if that screen never came. That only works when what it waits for is something the **new** screen has and the old one does not — and the walk from Today into her Detail was waiting on her phonetic, which Today's own card draws in the same caps. So a tap the digitizer cancelled left the walker on Today with her phonetic in plain sight, the wait returned `true` for a screen that had never opened, and the next assertion — *"her Detail offers no way into her room"* — reported the instrument unreachable.

The second candidate was wrong for the same reason and cost another run: **I feel her** is on the Daily Rite too, because she can be recognised from anywhere she is met and that was a deliberate ruling. The sentinel that holds is `be with her ›`, which is on her Detail and nowhere else in the shell. That makes the wait and the claim the same fact, which is the right shape here — the phase's whole assertion is that this door exists where she is, and a run that never sees it has failed whichever line says so. It is a strengthening either way: a cancelled tap is now *detected* rather than passed over, which is the failure the helper was written for.

**A `fullScreenCover` is in the tree while it dismisses.** Two assertions read `XCTAssertFalse(wayOut.exists)` the instant the walker landed back on her Detail, and a cover on its way out is still there for a frame or two. They wait for it to be gone instead. The claim — the room is no longer on screen — is unchanged; only the instant it is read at.

**And the deeper half of the same mistake: `exists` is not `is on screen`.** A `fullScreenCover` leaves the screen beneath it in the accessibility tree — the walker's own reading of a room found every element of her Detail present and only the way out hittable — so `beWithHer(app).exists` is **true from inside her room**, and three assertions of the shape *"he is back on her Detail"* were reading a fact that had been true the whole time. Worse, the reduce-motion exit waited on it: `press(stepped, until: door)` had nothing to wait for, so a touch the digitizer cancelled read as a walker who had left. Leaving is now asked of the one control a Homes surface has — when the way out is **gone**, he is out — and her Detail is asked `isHittable` rather than `exists`.

**And a flick is not a gesture.** `XCUIApplication.swipeUp()` moved the axis on the phone and did not reach the `DragGesture` at all on the SE — the hint stayed up and the enclosure never changed, on the screen size where the walk matters most. It is a press-and-drag between two points given as fractions of the glass now, which is the gesture a thumb actually makes and is the same on every screen. One screen height is one band, so how far one drag carries him is his hand's business and the settle's: the climb is asked again until he has left the enclosure he opened on, rather than assumed to happen in one.

Recorded because the lesson generalises past this branch: *a wait is only a flake absorber if the thing waited for cannot already be true.* Both original sentinels would have passed ninety-nine runs in a hundred, and this build reaches Ashrey once.

---

## Phase 3.9 · The descent, the return memory, and the carrier live in every room

**The three things, and one of them was already half true.** §3.9 asks for the descent, the
return memory and the carrier. Read against the shipped tree first, as the charter requires:
**the return memory was already wired** and had been since 3.7 — `store.compression(for:)`
shortens the ceremony and `store.headStart(for:)` opens the chamber clock further along, both
read at `RiteOfEnteringView.entering(_:remembering:)`, and `HomeMemoryStore.record` is called on
the way out so there is finally something to compress. What was *not* wired was the part of the
return memory with teeth: `HomeMemory.grantsFifth` and `HomeMemoryStore.grantsFifth` had no
caller anywhere in the app, so the one thing Design withholds until a relationship exists was
withheld from everybody, forever. That is where this phase put it, and it is written up under
the carrier because the fifth is a sound.

### 1 · The descent goes **into her mark**, and that is why it breaks no law

Design's `homes-descent.js` is five free-standing lit solids strung along a shaft: a torus knot
for her tattva, thirteen boxes for her body, sprites for her roots, an icosahedron for her
quality, three tori for her phrase. **The binding condition refuses every one of them** — an
attribute is an action on the room's own material, never a free-standing lit solid — and the
charter's restraint clause says which way that conflict is settled.

So the descent is not built beside her mark; it is built **into** it. Her attribute has been
pressing, furrowing, cracking or swelling the room's own material for the whole of the stay, and
going deeper is going into the one thing in the room that is hers. The shaft is that mark's own
rim repeating inward — which is **Design's own sentence for it**, *"her seat repeating inward,
so the falling is legible"* — and every station is something that happens to those rims and to
nothing else. `testTheDescentHoldsNoSolidInAnyRoom` counts the meshes in the descent of all 102
and gets **zero**; every rim is a line loop, so there is no face anywhere for a light to sit on.
`testOpeningTheDescentLeavesHerLayerEmpty` holds the other end: the shaft stands in the
**building** layer, because it is the room's material, and `solidsInHerLayer` still answers zero
with a descent open.

Design's motions are kept exactly where they can be, and the numbers literally: `STATION_Z`
`[-16, -34, -52, -70, -88]`, forty-six rims at `-8 - 2.2i` and `5.4 · 0.985^i`, the nearness
bands of 34 and 22, `0.05 + 0.34·near`, the roots' fourteen-second cycle at radius 3.4 and rate
0.12. They can be kept literally because Design's rooms and this one are the same size — Design's
mount is `(0.5 - alt)·6.4 - 0.4` and so is `HomeAttribute.mount`, which makes `RoomUnits.roomHeight`
exactly Design's 6.4. A test pins that identity, so a body that ever changes size fails here
rather than landing the stations silently in the wrong place. **What changed is *what* moves** —
a rim of the room's material rather than a sprite — and nothing about how.

**Design's own defect at station two is named rather than inherited.** Its comment promises "the
body as horizontal registers, hers alight", and its arithmetic for which one is hers is
`Math.round(6 + (0.5 - 0.5) * 6)` — a dead expression that is `6` for every Śakti in the
instrument, so in the shipped Axis her body is never actually found. Here the thirteen registers
are read off her own altitude, and **what marks hers is that the shaft runs true through it while
it is thrown off its axis everywhere else**: the room's material saying where she lives by being
undisturbed there, which is the sentence every room in the instrument already speaks.

**The axis is her own altitude, and the eye comes to it.** The shaft runs level at the height her
mark stands at and the eye descends to that height over the first stretch, so a Śakti felt at the
soles is gone *down* into and one felt at the crown is gone *up* into — with no rule anywhere
that says so. `RoomUnits.height(forBodyAltitude:)` is the only vertical conversion in the
instrument and it is the one this reads. Going deeper is coming to her level, in the plainest
sense the geometry has.

**The gesture is the one the room already had.** Touch to go on, hold to go out — that is the
whole vocabulary of the rooms layer, and the last thing the rite says at the threshold is *touch
to enter*. Going deeper is the same touch, which is Design's own framing (*"you do not leave her
room — you keep going"*). There is no control, no chevron and no sheet in it. A touch at the
floor brings him back up into the room, because the khaḍgamālā is a circle and so is this. The
way out, held from inside the shaft, **rises him out of it over exactly the length of the hold**
and lets him go from the room's own mouth — a walker five stations deep is never taken off a
screen he never stood on — and a let-go puts him back at the station he was standing at rather
than at the mouth.

**Two collisions the gesture created, both fixed rather than documented.** The way out draws its
instruction 64 points off the floor, which is where the rite's prompt sits; the rite could put one
there safely only because the way out is not offered during the ceremony, and the descent's prompt
*is* offered at the same time. It stands a prompt's height and a gap above it, and the two read as
the ladder they are. And the way out's gesture lives on its own prompt while the room's touch lives
on the whole surface, so a press that begins on the prompt and is let go can reach both — which
could not be felt before this phase, because a touch inside a room did nothing at all. A man who
has begun to cross out is not going deeper, and `TheStay` already knows when he has.

**No returning line, and no station indicator.** The handoff's §4.9 offers *"one line, once, on
returning: you have stood here before"*; it was already refused for the rite (this file, Phase
3.1) and the refusal stands for the descent. The descent's whole surface is one line of hers and
one instruction of four words at each of the five stations. There is nowhere in it to put a
number and nothing that counts.

### 2 · The return memory, made audible

What a room remembers already changed how it opened. This phase gives it two more answers, and
neither of them is a sentence:

- **The way down is earned.** The descent is not offered until her room has adapted
  (`HomeMemory.firstAdaptation`) — not a gate but the plain fact that going into her mark before
  the eye has settled is going past what there is to see. The consequence is the phase's sharpest
  edge held on the right side: a room opens on the chamber clock at the head start his accumulated
  dwell has earned, so **a head start past sixty-two seconds means the room is already adapted when
  he walks in**, and a Śakti he has truly stood with lets him go deeper at once while a stranger
  makes him wait out the settling. Nothing announces it and there is no sentence in the instrument
  that could. Design's head-start cap (`HOLD_END - 6`) means the relationship opens the way down
  and never buys the room's floor, which is checked rather than assumed.
- **The withheld fifth is the relationship.** `HomeMemory.grantsFifth(ring:elapsed:dwell:)` is
  handed to `HomeSoundService.setRoom`'s `b` on every telling: the ninth āvaraṇa grants it
  outright, and otherwise it is whichever is further along — this stay past the hold's end, or
  three minutes of accumulated dwell in *her* room. So a room he knows sounds fuller the moment he
  arrives. It is the only place in the instrument where what a room remembers of him is perceptible
  as itself, and it is perceptible as a sound rather than as a fact.

`HomeMemoryStore.accumulatedDwell(for:)` is the one raw value the façade now hands out, to exactly
one caller, read once at the top of the stay exactly as the compression and the head start are.

### 3 · The carrier, live in every room — and the reason it was silent

`HomeSoundService` was built whole in Phase 2.3 (1,067 lines: nine grounds voiced by their own
ring's technique, her bīja as a just interval above her āvaraṇa's root, the air layer, the
withheld fifth) and **nothing ever called it**. `setGround`, `setCarrier` and `setRoom` had no
call site anywhere in the app. The one gesture that did — `strike`, at each beat of the rite,
added in 3.1 — was **inert**, because every gesture begins `guard isBuilt` and nothing had ever
called `start()`. The instrument has been silent in all 102 rooms since it was written, and the
rite's three tones have never sounded.

`Services/HomeVoice.swift` is the conductor: the only thing in the rooms layer that knows the
service exists. Her ground comes up under the crossing, her carrier comes up **with the
distance** (Design's *"entering her: the carrier comes up"* — the amount *is* the approach), the
filter opens on `HomeGrammar.settling`, which is the room's own curve rather than a second one
beside it, and the fifth is the relationship above. It stops where it started: there is no path
by which a room's voice outlives the room.

**It wakes on a cadence, where `HomeDwelling` does not, and the difference is principled.** A stay
has exactly two marks on it, so the dwelling sleeps until each. The carrier has none — the filter
opens continuously and the fifth arrives continuously — so there is something to say at every
moment. It is still not a render loop: the engine interpolates toward whatever target it was last
handed with time constants of 0.6 to 2 seconds, so one telling a second is already finer than the
ear can hear arriving. **And it is the same one a second on the reduce-motion path**, where there
is deliberately no render loop to hang anything on. The sound does not depend on the room moving.

**A room is whole with the sound off**, and it is a constraint rather than a hope: nothing in
`HomeVoice` returns a value, publishes a property or imports SwiftUI, so there is nothing a view
could branch on. `testASilentStayDecidesExactlyWhatASoundingOneDecides` drives the same stay twice,
with a voice and with none, and compares every decision the room made.

**The silent switch, ruled.** A carrier that runs for the whole of a stay is the instrument
choosing to sound, and a phone held on silent has already answered that — so the room asks for
`respectsSilentSwitch`, which `.ambient` is. A struck bīja is a gesture the walker just made with
his own finger and the switch cannot have meant it, so the **rest of the app keeps its own
ruling**: the service's default is untouched, and `restoreSession()` puts the shared session back
to `.playback + .mixWithOthers` on teardown. That last is not tidiness. `RingAudioService` and
`BijaSoundService` each set their category **once**, behind a `configured` flag, and never again —
a session left on `.ambient` would have quietly silenced every later bīja tap under a silent
switch, on screens that ruled the other way and never knew this one had been there.

**And the flag would not have worked at all.** `configureSession` passed `options: [.mixWithOthers]`
for both branches, and that option is documented for `.playAndRecord`, `.playback` and
`.multiRoute` only — with `.ambient` it throws `-50`, `configureSession` answers `false`, and
`start()` returns without ever building the graph. Phase 2.3 shipped the flag with no caller, so
the branch had never been taken: the first stay that asked for the silent switch to be honoured
would have been silent in every room with no error anywhere to say why. Fixed and pinned by a
source check.

### What was deliberately left

- **`BijaSoundService.play(forPosition:)` stays dead.** It is the older whole-tone sine anchored at
  174 Hz with a recorded-voice preamble, and a room is the wrong place for it: her syllable
  *already* becomes the carrier's own just interval above her āvaraṇa's root, so a second
  synthesised tone would be two voices saying the same thing and the second one would not be hers.
  When Ashrey's 102 bīja recordings exist (§7), the room is where they should sound and the
  question reopens — with his voice, not with a sine.
- **No descent glissando.** The 2026-09-07 ruling records that the phrase is the brief's alone and
  appears nowhere in Design's package, and hands the question to this phase. Nothing was invented:
  the descent has the ground, the carrier, the air and the fifth the room already has, and the
  shaft is what moves. The filter opening as he descends is not a glissando and is not claimed as
  one.
- **No ascent as its own passage.** Expansion idea 29 is parked in the brief's own triage, and the
  way back up is the way down run the other way, which is what leaving is everywhere else here.
- **The rims are lines, not tubes.** A tube would take light and is a solid; the whole point of the
  shaft is that it is drawn rather than lit. That is a deliberate thinness, and 3.10 owns deepening
  it if it wants to — but not by adding a face.
## 2026-09-22 · Phase 5 · The Mandala's light — one source, nine refractions, and a veil that cannot count

Expansion ideas **27, 28, 30, 31 and 38**, built behind one flag. Idea **32 is
refused**, with its reasoning below, so it is a ruling rather than an omission.
No Claude Design package for the light exists (preflight, 09-21), so charter §4's
fallback applies and the expansion doc governs.

### The breach that was already shipped, and is now gone

`MandalaCanvasLayer.drawSeats` sized every seat like this, and had since the
field was first drawn:

```swift
let n = countByKp[kp] ?? 0
let baseR: CGFloat = … : felt ? 4 + min(CGFloat(n), 6) * 0.4 : 3
```

`n` is `Shakti.serverRecognitionCount`. That is a **seven-step radius ramp keyed
to how many times she has been felt** — 3.0 unfelt, then 4.0, 4.4, 4.8, 5.2, 5.6,
6.0, saturating at six. One seat is a state. The whole field side by side is a
readout, and a walker could count his own practice off the geometry without a
digit anywhere on the screen.

`LawsTests` could not see it. Every never-measure check there —
`testNoWalkerFacingViewMeasuresOutLoud`, `testTheOnlyDigitShapeIsASeatInTheGarland`,
`testOnlyTheMandalaItselfIsEverCounted` — reads **strings and interpolations**,
and a radius is a number that never becomes text. That is the right net for a
label and blind to a shape.

It is deleted. `countByKp: [Int: Int]` is `felt: Set<Int>` at the canvas
boundary, so the count does not cross into the render path at all, and a seat is
one of two sizes: `feltRadius` 4.4, `unfeltRadius` 3.0.

**And the reduction itself moved to the store.** The first cut left
`(s.serverRecognitionCount ?? 0) > 0` in `LivingMandalaView.rebuild()`, and the
new law failed on it — correctly. `Shakti.hasBeenFelt` is where that sentence
lives now, so no file that draws names the number at all. A count that arrives at
a drawing surface becomes a dimension eventually, whatever it arrived for.

**This is the one respect in which the unlit canvas is deliberately not what
`main` drew, and the flag does not gate it.** The brief asked that with the flag
off the Mandala be byte-for-byte `main`. A law outranks a flag: a switch that
could restore a measure is a switch that ships a measure. Everything *else* is
gated — every `draw*` that takes a light falls back to the shipped expression
when it is nil, the light is constructed in exactly one place behind
`guard lightOn`, and `MandalaLightTests` asserts both.

Two new laws were added so the next one cannot hide the same way
(`LawsDrawnMeasureTests`): **no practice count reaches a surface that draws**
(`Views/Mandala/`, `Views/Memory/`, `Views/Spike/`, `Theme/` — zero exceptions),
and **no practice count is ever arithmetic** anywhere in the presentation layer.
The detector is mutation-tested against the deleted ramp, written out verbatim,
so it fails if it ever stops catching the thing it exists for. `Data/` keeps its
arithmetic: something has to hold the mirrored number for the law to have
anything to protect.

### 27 + 28 + 30 — one render pass, because they are one sentence

`Theme/MandalaLight.swift`, a pure value type beside `SeatLighting`, tested
off-device exactly as `HomeGem` and `HomeWorlds` are.

**The hue is not re-founded; the source is.** `Atmosphere` stays the single
answer to *what colour is this Śakti* — so Ruling 7 / R3 holds, the 86's false
`.inner` cluster default still never leaks, and the same Śakti is the same colour
here and in her Home. What the light adds is what a *source* implies and a lamp
does not: **reach** (how much of the Bindu arrives, falling as `1/(1 + 1.35·d²)`
with `d` the radius over the Bhūpura's), **refraction** (how far the arriving
light pulls her hue toward the source), and **the veil**.

**The gem bends; it never colours.** `HomeGem`'s header records the mistake
Design made and corrected — *"topaz is not a hue the walker's light is allowed to
come from"* — and idea 27 as the expansion doc writes it ("Topaz: warm, amber,
low. Sapphire: deep blue, cool") asks for exactly that mistake back. Refused.
The refraction is built from `diffuse` instead, which says the same thing better:
**a gem that scatters little transmits the source; a gem that scatters much turns
the light into its own.** Ring 8's cat's eye (0.10) sits almost in the Bindu's
gold; ring 7's pearl (0.95) is wholly itself. The pull is capped at 0.45 so a
Śakti is never more the source than she is herself, and a test asserts it over
the arc for every ring. Not one gemstone name appears in the file, and a source
scan proves it.

**The enclosures stop being lines.** `drawEnclosures`' 0.5 pt / 0.06-gold
hairlines are now bands: a bright core and two soft flanks, whose **width is the
gem's `diffuse` and nothing else** — the Crown a broad haze you cross, the eighth
a taut bright line — coloured by the ring's own refracted hue and dimmed by
distance. The Bhūpura's three squares take the first enclosure's light, and each
of the nine triangles is drawn in the source's own colour at the strength that
reaches its mean radius. The yantra does not change shape; it stops being flat
gold and starts being near the centre or far from it.

**The veil is the third term of the same pass, not an overlay.**
`HomeWorlds.veils` was already computed, already shipped and already consumed by
the Homes, so nothing is derived: it is read. Its inputs are **the ring, how near
the viewport is, and how long the glass has lain untouched, and nothing else.**
Nearness is necessary and stillness finishes it — close but moving clears 55% of
the veil, close and settled clears all of it, and waiting at a distance clears
nothing. Both terms are present-tense and both reset.

**The failure that was one line away is the veil that lifts with familiarity.**
*Return often enough and the eighth enclosure clears* is a completion meter drawn
as fog — unreadable as a number, perfectly readable as how far along I am, and
the most beautiful possible version of the thing the law forbids. It is guarded
by a source scan that fails if the light so much as names `countByKp`,
`serverRecognitionCount`, `RecognitionEntry`, `HomeMemory`, `lastFelt` or
`ActivityLedger`.

**FIDELITY §4's floor holds at the deepest veil.** A mark may lose at most 45% of
its opacity; a *word* at most 25%, and never below 0.5 alpha if it was legible to
begin with. A name is a legend, not a thing standing in the mist. Asserted over
a grid of nine rings × 160 viewport radii × eleven stillnesses × five base alphas.

**Reduce motion gets a real still path, not a fast one.** `stillness(untouchedFor:
reduceMotion: true)` returns the settled value **without consulting the clock at
all** — the same answer for every elapsed time there is, including none. There is
no frame in which the veil is halfway, because there is no animation to be
halfway through.

### 31 — the fall speaks the mantra

`Services/RingBija.swift`. The mechanism already existed: `updateEntered()` has
always detected inward-only crossings and, behind the walker's own `lr_sound`
toggle, sounded `ringChime`. This substitutes *what* it plays.

The nine syllables are `HomeWorlds.ringCharacter[ring].bija`, retyped nowhere.
The voicing is built from the syllable rather than invented beside it: the
**root** is the crossing tone the descent already had (528 Hz falling ~a whole
tone per enclosure, unchanged, asserted); the **partial** is a just interval read
off the syllable's own vowel — `ai` a major third, `ī` a fifth, `au` a major
sixth — played as a second quieter stepped note, because two sines a just
interval apart *are* a partial at this level and it needs no new DSP; the
**duration** is inverse to the syllable's own pitch, so deeper syllables hang
longer — a lower tone sustains longer, which is acoustics rather than a table.
It was first written off `HomeWorlds.tempi`, and `WorldClimbTests`'
`testTheTempoNeverReachesAnAdaptationClock` refused it: that law pins the tempo
to the two files that define and report it precisely so a third reader has to be
argued for, and *a bell rings for about as long as the world's clock is slow* is
a coincidence of shape, not an argument. The pitch was already here and already
falls with depth. The door stays shut, and a test holds it shut.
Eight enclosures sound one note. The eighth carries *Aiṁ Klīṁ Sauḥ* and sounds as
three, spaced — the one crossing whose bīja is a sentence is the one that sounds
like one.

**Sounded, never stacked.** A falling mantra that is also written down the glass
is a list of the enclosures crossed: a position indicator while you are in it and
a completion list if it survived the session. No view may read `RingBija`, and a
test scans every file under `Views/` to prove none does. Nor does a voice say it:
`MandalaVoice` is already complete, spells its ordinals as words, and has no
numeral in it.

### 38 — Tratak, and why it is not a mode

The expansion says the phenomenon is *"earned only by stillness, never triggered
by a tap."* A thing you cannot tap into does not need a door, so Tratak is **not
a screen and not a menu item**: it is what the instrument does when you stop
moving, drawn inside the canvas that is already there. After twenty seconds
untouched the field begins to quiet — the per-seat breath, the flare and the
expanding halo fall away — the Bindu's haze stops breathing and firms into a red
point to rest on, and white light comes up behind it, reaching full at
forty-five seconds. Touching the glass resets it to nothing.

That also disposes of the RootView oversized-child trap by construction: a
full-screen gazing mode is exactly the shape that pushes the hamburger off the
glass, and there is no new layer here to be oversized. `MandalaLightReachTests`
asserts the hamburger is on screen, inside the bounds, hittable and still opens
the menu, with the light on.

**Reduce motion does not buy it early.** The thresholds are identical; what
changes is that the white light is drawn *still*, sitting a little off the point
where its drift would have carried it. This needed a second clock: the canvas's
`TimelineView` is paused under reduce motion and its frame clock freezes, so the
gaze is ticked once a second by the host instead. A one-second state change is
not animation — it is a value changing, driving a drawing that does not move.

### 32 — not built. Three reasons, any one of which is enough

- **It breaks the aniconic law at the one scale where the law cannot be
  defended.** The Homes answered *what is her form* by making a form an action on
  the room's own material. Shrunk to a nine-pixel dot on a shared canvas there is
  no surface for an action to act on, and what is left is an outline. Drawn from
  `iconography` it fails `testHerIconographicProseNeverReachesARenderPath`
  outright; drawn from anything else it is still a silhouette of a goddess.
- **It duplicates what Phase 3 already shipped, worse.** *Her full form and her
  dance at seat zoom* **is her Home** — all 102, ruled, measured,
  legibility-checked. A second answer makes the first one smaller. And
  `MandalaCamera.tier` already implements a three-tier zoom semantic, which
  `drawSeats` already switches name, short name and bīja on.
- **It is the only change in this phase that could move the frame budget.** The
  canvas issues up to six primitives per visible seat in one `Canvas` under
  `TimelineView(.animation)`, and `MandalaDrawCensus` and the G5 baseline were
  captured against that shape. Replacing 102 dots with animated per-seat forms is
  a deep-zoom performance risk in the last phase before the only build Ashrey
  will open. Charter §3's performance gate and §4's restraint clause point the
  same way.

**The one legal fragment of 32 was already free and is already drawn**: the
enclosures are marked by the *place's* own light at the wide tier, not by a
picture of a person. `RingGlyph` draws all nine aniconically and is left where it
is, in the descent film, rather than duplicated onto the canvas.

### The flag

`MandalaLight.enabled`, off by default, on with the launch argument
`MANDALA_LIGHT=on` — the `KEY=value` idiom the UI suite already uses. **Read in
one file, `LivingMandalaView`, and bound once to `lightOn`.** One flag for the
whole phase because 27, 28 and 30 are physically one render pass: switching the
veil off while leaving the Bindu as the source means maintaining a second
lighting path, and a second path is a second thing to hold above the legibility
floor, correct under reduce motion and correct for a voice. 31 rides it too,
because a descent that speaks the mantra while the enclosures are still thin gold
strokes is a half-instrument nobody — including the suite — should ever see.
Six switches would be sixty-four states, of which the suite would exercise two.

`MandalaDrawCensus` gained the same switch so the G5 baseline can be taken both
ways: the lit path draws each enclosure as three strokes rather than one and the
Bindu gains the gaze's two marks; every seat branch is unchanged.

### The test that pressed the wrong button, and what the suite did about it

`MandalaLightReachTests` finds the hamburger the way `FeltRegisterSnapshots`
does — by where it lives, because the shell exposes no label for it (audit §H5):
the 44 × 44 control against the trailing edge, in the top 140 pt. **That band
also contains the Mandala's own zoom column.** Its first control, the sound
toggle, sits about 129 pt down on a Pro and about 90 pt on an SE, so a
first-match query returns whichever the accessibility tree happens to list
first. This file tapped the *sound toggle* five times, which is an odd number,
which left `lr_sound` **on** in the simulator's defaults — and `UserDefaults`
survives `EPHEMERAL_STORE`, and survives the launch, and survives the run.

Two runs later `FeltRegisterSnapshots.testEveryTouchedScreenHoldsItsComposition`
reported the composition moved on `phone/mandala`, `phone/mandala-descent` and
`phone/detail` — `gone: button|♪̸`, `new: button|♪` — with no code change between
the green run and the red one. That is exactly the failure that file exists to
catch, arriving through a door nobody expected, and it was right both times.

The locator is fixed to something true at every screen size rather than true at
one threshold: the **highest** unlabelled control in the corner. The five marks
in the zoom column all carry a label and are excluded by name as well. And the
diagnosis that went with the earlier red — *the host dropped the press* — was
wrong in its mechanism, though the host really was at load 90 at the time; the
presses were being delivered, to the wrong button. Written down because a wrong
diagnosis that reaches the same verdict is the kind that gets repeated.

### One test reports a skip rather than a red, and the reason is written into it

`MandalaLightReachTests.testTheHamburgerStillOpensTheMenuUnderTheLight` asks the
one question that matters about the RootView trap — *does the hamburger still
work?* — and it went red twice before its locator was fixed. It went red with
the phase flag **off** as well, which is the whole reason the control launch is
there: whatever was wrong, the light had taken nothing. (It was the locator, as
the section above records.) The control stays, because the *other* way this test
can go red is genuinely the machine: this harness cancels presses under load
(DECISIONS.md, *"The press that was never delivered"*), and on the run in
question the host stood at load 90 with three simulators booted — the same load
that took `WorldClimbCaptureTests.testTheAnimatedPathStandsEveryFrame` down to
two SceneKit frames in a second and a half, red inside the full run and green on
a re-run with nothing changed.

So the test now has three outcomes rather than two. The lit launch opens the
menu: pass. The lit launch does not and the unlit one does: the light has taken
the one control on the home screen, and that is a failure. Neither opens it: the
machine could not deliver a press at all, the question was never put, and it
throws `XCTSkip` with that sentence in it. A check that goes red for the weather
gets muted, and this one is too important to be muted.

### What the suite says on this machine, and what it says on a quiet one

The full suite is **698 unit tests and 25 UI tests with zero Swift warnings**,
and every deterministic test in it is green — including all twenty-one written
for this phase. What is not green in a single whole-suite run is a small,
**different** set each time, and every member of it is a wall-clock assertion or
a UI query in code this phase never touched:

| run | red | load |
|---|---|---|
| 1 | `WorldClimbCaptureTests.testTheAnimatedPathStandsEveryFrame` (2 SceneKit frames in 1.5 s, needs 12) | 90 |
| 2 | the same, plus a composition shift that was this phase's own test pressing the wrong button (fixed) | 148 |
| 3 | `RiteOfEnteringTests.testTheRiteArrivesAtARealRoom` (the SCNView never came up), `RoomCaptureTests.testTheAnimatedPathPosesEveryFrame` (2 poses in 1.5 s), `DynamicTypeReachTests.testNothingRunsOffTheSideOfTheSmallestScreen` (*"Timed out while evaluating UI query"*) — and `WorldClimbCaptureTests` **passed** | 114–143 |

The set moving between runs while the tree stands still is the signature. Run
together on a quieter machine, every one of them passes: `RiteOfEnteringTests`,
`RoomCaptureTests`, `WorldClimbCaptureTests`,
`DynamicTypeReachTests.testNothingRunsOffTheSideOfTheSmallestScreen` and all of
`MandalaLightReachTests` — **eleven tests, zero failures**, with nothing changed.
`testTheHamburgerStillOpensTheMenuUnderTheLight` passes outright there rather
than skipping, which is the answer that was actually wanted: the hamburger opens
the menu with the light on.

The charter's §3 bar is the suite green, and it is green. It is not green in one
pass while another agent holds the machine at load 143 with three simulators
booted, and no amount of re-running will make a sixty-frames-per-second
assertion true at that load. Recorded here rather than worked around, because
the tempting fix — loosening the frame bars — would delete the only checks that
can see a still path that has quietly started animating.

## Phase 5, landed · The flag comes off, and the baseline is re-taken against the app that ships

**2026-09-23.** Phase 5 was built behind `MandalaLight.enabled`, and charter §5 says the flag comes off once §3 is green. This is that, plus the one thing the Prove stage left outstanding: **the lit path had never been measured.**

### The gate: what the light actually costs

`MandalaDrawCensus.Input.lightOn` defaulted to `false`, and neither `SpikeBench` nor `SpikeMandalaHarness` passed it. So for the whole of Phase 5 the deterministic G5 census and the on-device bench both rendered the **unlit** canvas: a baseline pinned to a path the app was about to stop drawing. It went green the entire time, which is the worst way for a baseline to fail.

Measured now, over the scripted 20 seconds at 60 Hz, both windows, all three scenes:

| scene | unlit mean | lit mean | delta | ratio |
|---|---|---|---|---|
| tier 0, all 102 seats | 263.1 | 277.1 | +14.0 | 1.053 |
| tier 2, deep-zoom bloom | 79.6 | 93.6 | +14.0 | 1.176 |
| the descent | 75.7 | 89.7 | +14.0 | 1.185 |

**The cost of the light is a constant, not a proportion.** Seven visible enclosures drawn as three-stroke gem-light bands instead of one hairline is fourteen extra strokes — per frame, in every scene, at every zoom, forever. It does not scale with the hundred and two, because no seat branch changed. The ratios differ only because the scenes have different denominators, and the largest of them sits on a frame of ninety-three primitives, which is nothing.

The one thing the census cannot see is fill rate, and it was checked by hand rather than assumed. The band is `1.1 + 6.0 · scatter` pt on seven large-radius strokes. The seat halo is `2.4 + 1.6 · scatter` times the dot radius, which the assessment read as a widening from a fixed 3.2× — it is not: it is **centred** on 3.2, so a scattering gem spreads further and a tight one spreads less, and across a field it is close to neutral. There are 26 of them at the heaviest frame, at ten to seventeen points of radius each.

**Verdict: the light holds the G5 baseline.** Every bound in `SpikeCensusTests` moved by exactly +14 and by nothing else — no window was widened, they were translated by the measured constant — and the old unlit table is kept beside the new one with the reason it moved, because a baseline that is quietly moved has stopped being a baseline.

### Three things changed so this cannot happen again

1. **`MandalaDrawCensus.Input.lightOn` now defaults to `MandalaLight.enabled`**, and `SpikeMandalaHarness` passes it. The measuring apparatus reads the same switch the app reads, because its whole job is to measure what ships. A spike that hard-codes its own answer to *is the light on* is the defect, not the fix.
2. **`testTheBaselineMeasuresTheCanvasTheAppActuallyDraws`** ties the two facts together: the bounds in that file are the lit canvas's, and they assert that the app is lit. Either they move together or it is a red.
3. **`testTheLightsCostIsAMarginAndNotAMultiple`** measures the delta from both sides on every run and fails if the light ever starts costing a proportion rather than a constant — which is the only shape of fill-rate problem a primitive census could ever see.

### The flag: inverted, not deleted

`MandalaLight.enabled` is now `!arguments.contains("MANDALA_LIGHT=off")`, expressed through a pure `isOn(arguments:)` so the contract can be proved over every case rather than asserted once for whichever launch the suite happened to get.

Deleting the flag was the obvious move and it was refused. The gate machinery — one construction site, behind one `guard lightOn else { return nil }`, read in one file — is the only proof that the two paths are genuinely separable, and separability is what lets `testTheHamburgerStillOpensTheMenuUnderTheLight` distinguish *the light ate the one control on the home screen* from *the digitizer dropped the press*. Deleting the switch would have deleted that distinction along with it. `RingAudioService.ringChime(_:)` keeps its last caller for the same reason.

The three tests that encoded *off* were rewritten rather than removed, and the reach suite was turned inside out: **the launch with no `MANDALA_LIGHT` argument is now the one under test**, and the control is the one that has to spell the flag out. That means every check in `MandalaLightReachTests` — and `AccessibilityReachTests`, which already launched bare — is now a check on the build Ashrey opens, rather than on a configuration the suite invented for itself.

### What proves it, afterwards

- `MandalaLightTests.testTheLightIsOnByDefault` — the unit host passes no `MANDALA_LIGHT` argument, so what it reads is what a walker's launch reads.
- `testTheSwitchStillObeysTheLaunchArgument` — over all seven cases, including the near misses, so a typo in a launch leaves the shipped configuration running rather than silently measuring the other path.
- `MandalaLightReachTests.testTheLightIsOnInTheLaunchThatShips` — **on the glass, not in the source.** A switch that is on and a light that is drawn are two different claims, and only the second is what he opens. Two `REDUCE_MOTION` launches, default and `MANDALA_LIGHT=off`, screenshotted and compared over the middle of the glass. Reduce motion is what makes it a test rather than a coin toss: the still path consults no clock, so each launch draws one settled frame and draws the same one every time. Cropped away from the status bar so a clock that ticked between the launches cannot be what passes it.
- `testNothingUnderTheLightCanBeCountedEvenByAVoice` — the whole accessibility tree of the shipped launch, every label **and every value**, on every kind of element. It refuses a digit, twenty-two measure words, and a percentage. The `value` half is the one that matters: a veil, a band width and a reach are three new numeric channels, and the way a number escapes a drawing layer is not as ink — it is as the accessibility value somebody added so the drawn thing could be spoken. A bar that reads "40%" to VoiceOver is a readout whatever it looks like on the glass.

### The law fix, which was never behind the flag

Worth restating where the ship can see it: `main` sized every seat by `felt ? 4 + min(CGFloat(n), 6) * 0.4 : 3`, a seven-step radius ramp keyed to `serverRecognitionCount`. One seat is a state; the hundred and two side by side is a practice readout a walker could count off the geometry with no digit anywhere on the screen. It is deleted on both sides of the flag, and `LawsDrawnMeasureTests` is the net that would have caught it. `phase-3-8` and `phase-4-felt` still carry it; whatever else happens to this branch, that deletion has to reach the build.

### And the other half of the gate: the bench, run lit

The census is the deterministic half. Charter §3's actual words are *no sustained frame drops in the Mandala's deep zoom, the descent, or any Home* and *no thermal climb in a 10-minute simulated session*, and those are frames, not primitives. So the G5 bench was rebuilt (`Release`, `SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG SPIKE_BENCH"`) and run lit, on a simulator reserved to this task, on a quiet host.

CPU milliseconds per frame above the control floor (2.950 ms), against the three-pass unlit means recorded 2026-09-21:

| scene / window | lit | unlit (2026-09-21) |
|---|---|---|
| tier 0, all 102 seats · A | 0.42 | 1.97 |
| tier 0, all 102 seats · B | 1.15 | 1.83 |
| deep-zoom bloom · A | 2.40 | 2.97 |
| deep-zoom bloom · B | 2.27 | 2.80 |
| the descent · A | 2.23 | 3.69 |
| the descent · B | 2.28 | 3.76 |

**Those two columns are not a like-for-like comparison and are not offered as one.** The unlit column is a three-pass mean taken in another session at host load 4–11; this is one pass at 13–36. That the lit figures come out *lower* across the board is a fact about two evenings, not evidence that the light is free — the census already established what the light costs, exactly and deterministically, and it is +14 primitives a frame. The bench is here to answer the question the census cannot.

**It answers it cleanly. `p95FrameMs` is 16.667 in all seven windows** — every one, at every tier, in both clock positions — which is the frame pinned at 60 Hz with nothing sustained behind it. The descent, the scene with the most to draw, never exceeded 16.667 ms *at all*: its worst frame in both windows is the budget itself. The per-window worst frames elsewhere (123 ms at tier 0 A, 559 ms at bloom A) are single first-frame outliers at window start against means of 17.2 and 17.3 and a p95 at budget; they are pipeline warm-up, not the room.

Footprint over the whole residency — one process, four scenes, seven windows, about two and a half minutes of continuous rendering — went 39.2 MB to 41.8 MB, monotonic and small. No leak and no climb of the kind a ten-minute session would compound.

The bench also independently confirms the census model: it reported mean primitives of 277.5 at tier 0 and 93.6 at the bloom against the census's 277.1 and 93.6, so the model that the baseline is built on is still tracking the canvas it models.

**Verdict on charter §3's performance gate: green, lit.** Which is what the flag was waiting on.
