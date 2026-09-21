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

