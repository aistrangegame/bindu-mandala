# Bindu Mandala — Device-Side Audit Brief (Session 2 of 2)

**For:** a fresh Claude Code session on Ashrey's MacBook, with Xcode, the iOS simulator, and Ashrey's iPhone connected.
**Repo:** `aistrangegame/bindu-mandala`, branch `main` @ `522cdd3` (the audited tip — verify `git rev-parse HEAD` matches; there are zero commits after 2026-07-13).
**Companion document:** `AUDIT-REPORT.md` from Session 1 (attach it to the new chat). Session 1 completed everything reachable from code, git history, and live Airtable. **Do not redo sections C-static, D, E, F, G1–G4, or the H static sweeps — they are done and verified.** This brief covers only what was BLOCKED.

**Mode: READ-ONLY toward Airtable and the codebase.** No code edits, no Airtable writes by the auditor, no field creation, no queue flushes forced by the auditor. The one sanctioned Airtable mutation is Ashrey himself performing recognitions as normal practice (item A1/H6 below — that is his devotion, not an audit write).

**EVIDENCE-PRESERVATION LAW (unchanged and now sharper):** do NOT delete or reinstall the app on the phone. Session 1 proved the retry queues self-destroy evidence (3-strike drop under every failure mode), so the surviving evidence is: the local SwiftData store, `ledgeredLetters` in UserDefaults, and the installed build itself. A dev build installed **over** the same bundle ID preserves the data container and is fine — but see the SEQUENCING section: several answers must be captured from the *currently installed* build before any dev build replaces it.

**Verdicts:** every item gets `CONFIRMED / REFUTED / PARTIAL / BLOCKED` + evidence (log line, screenshot name, command output, sqlite query result). Deliverable: one file, `AUDIT-REPORT-DEVICE.md`, at repo root, **never committed or pushed** — handed back as a file.

---

## 0 · What Session 1 established (hold this; do not re-derive)

1. **The old hypothesis is dead.** The `Link to Mandala` field exists in the live App Activity schema (as of 2026-09-07) with exactly the name the code writes; every field name and select value in `createActivityRow`'s payload exists live. More decisively: **no Mandala ledger write was ever attempted** — the ledger shipped 2026-07-07 (`7fe8353`), and every first-felt recognition (the only trigger for "Shakti Recognized") happened 2026-05-31 → 2026-06-24, before the feature existed. The only post-ledger recognitions (2× Kāmākarṣiṇī, 07-13) were non-firsts. Nothing failed; nothing was dropped; there was never an eligible event.
2. **The real finding:** the Mandala table has received nothing since 2026-07-13 — the exact day all development stopped. The two 07-13 rows are plausibly dev-harness writes (both are position 29 = the XCUITest's pinned `ENERGY_POS=29`, landing inside the verification-commit window). The last unambiguous practice recognition is **2026-07-04 (Śabdākarṣiṇī)**. Silence rows stopped 2026-06-24 with no code explanation (the write path lived until 07-11). **This session's core job: decide between "usage stopped" and "usage continues but writes fail."**
3. **Leading suspect if writes fail:** the phone runs a TestFlight build whose Xcode Cloud workflow lacks the `AIRTABLE_PAT` secret. TestFlight distribution began exactly 07-12/13 (`#10` build auto-increment, `#24` compliance clearance); a missing secret produces a green build that never syncs (`ci_scripts/ci_post_clone.sh:18–21` exits 0, "local-first mode").
4. **Queue expectations:** the four pending queues (`pendingActivities`, `pendingRecognitions`, `pendingLetters`, `pendingCrossings`) are expected EMPTY regardless of what happened — every flush pass bumps `failCount` even with a nil PAT, and items drop during their 3rd flush (~4 total attempts). Empty queues exclude nothing. `ledgeredLetters` is the decisive key: it is append-only, never cleared, and marked **before** the network attempt — marked ids = a Letter-Written ledger attempt fired (and died); unmarked = never attempted.
5. **Log limits:** all HTTP failures collapse to `URLError(.badServerResponse)` before logging — Console **cannot** distinguish a 422 from any other server error (response bodies discarded at `Data/AirtableService.swift:1212–1214`, `:763–765`, `:1066–1068`). Classification needs a breakpoint or proxy.

### Live-Airtable ground truth (2026-09-07) for device comparisons

**All 15 Recognition rows ever** (Row Type=Recognition, all Source="Today"):

| Felt At (UTC) | Śakti (KP) |
|---|---|
| 2026-05-31 01:09 | Amṛtākarṣiṇī (43) |
| 2026-06-01 13:05 ×2 rows (duplicate pair) | Śarīrākarṣiṇī (44) |
| 2026-06-01 19:00 | Kāmākarṣiṇī (29) |
| 2026-06-04 02:12 | Ahaṅkārākarṣiṇī (31) |
| 2026-06-04 22:35 | Śabdākarṣiṇī (32) |
| 2026-06-05 23:09 | Sparśākarṣiṇī (33) |
| 2026-06-06 19:00 | Rūpākarṣiṇī (34) |
| 2026-06-11 03:35 | Dhairyākarṣiṇī (38) |
| 2026-06-11 19:39 | Smṛtyākarṣiṇī (39) |
| 2026-06-12 19:01 | Nāmākarṣiṇī (40) |
| 2026-06-24 04:02 | Cittākarṣiṇī (37) |
| 2026-07-04 19:13 | Śabdākarṣiṇī (32) |
| 2026-07-13 20:51 | Kāmākarṣiṇī (29) |
| 2026-07-13 21:25 | Kāmākarṣiṇī (29) |

**Counts:** 11 Śaktis with Recognition Count > 0, all Ring 2: KP29=3, KP32=2, and 1 each for KP31/33/34/37/38/39/40/43/44. **Letters:** exactly 3 non-empty (KP29, KP39, KP44). **Silence rows:** 9, 2026-05-31 → 2026-06-24. **Crossing rows:** 1 (Descent Ring 9, 2026-07-11 22:54 EDT — the PR-8 verification run). **App Activity:** 46 rows, zero Mandala.

**Question 0 (for Ashrey, no tooling needed):** was the `Link to Mandala` field created in Airtable on/after 2026-09-06 (by you or anyone), or has it existed longer? Session 1 could not date it via API. If you created it yesterday during the reconciliation session, say so in the report — it changes nothing about the no-attempts finding but closes the last historical unknown.

---

## SEQUENCING LAW — order of operations (violating this destroys evidence)

**Phase 1 — capture the phone as it is (before ANY dev build, before opening the app if avoidable):**
1. A3-installed: identify the installed build (TestFlight app or Xcode → Window → Devices and Simulators → installed apps: version/build number).
2. A2: download the app's data container (Devices and Simulators → Bindu Mandala → ⚙ → Download Container) and archive it untouched. All UserDefaults and SwiftData reads below run against a *copy* of this snapshot.
3. A3-live: with Console attached (subsystem `com.ashrey.bindu-mandala`), launch the **installed** app once and watch the first sync: `No PAT — local-only mode.` at sync start = PAT absent in this build (the second-cause confirmed without touching the binary). `[Phase 1] sync starting…` followed by fetch lines = PAT present. NOTE: this launch will flush/drop any queued items — that is why the container snapshot in step 2 comes first.

**Phase 2 — live instrumented tests** (still the installed build where possible; Console attached; Ashrey drives).

**Phase 3 — dev-build passes** (build from this repo in Xcode, install over the same bundle ID — container persists). Dev builds carry the Mac's `Config.local.xcconfig` PAT, so from here on the app can write to Airtable with a working token; that is expected and fine for Ashrey's real practice, but note in the report which writes originated in Phase 3. Debug launch args available: `START_TAB=`, `ENERGY_POS=<kp>`, `OPEN_THRESHOLD=<ring>`, `OPEN_DETAIL=<kp>`, `OPEN_RING=<ring>`, `OPEN_LETTER=<pos>`, `OPEN_SILENCE`, `RECOGNIZE_AUTOCLOSE`, `SKIP_SUMMONS`, `SKIP_HOMECOMING`.

**Phase 4 — Mac-only work** (clean build, tests, sizes, Xcode Cloud) — any time.

---

## A · Ledger & pipe forensics — device half

**A1. Live capture of one real recognition.** Console attached (subsystem `com.ashrey.bindu-mandala`, category `airtable`); Ashrey performs one recognition end-to-end (see H6 for the felt half — do them together).
- Choose deliberately and record which Śakti: an **already-felt** one (e.g. today's if it's one of the 11) exercises only the recognition write; a **never-felt** one (91 candidates) also fires a genuine first-felt "Shakti Recognized" ledger write — the live end-to-end verification the original audit reserved for the repair phase. Recommended: do one of each.
- Success path strings: none logged on success for the row create; watch for absence of failures plus (on a first-felt) no `Activity write failed`. Failure path strings (exact): `Recognition write failed: …`, `Recognition queued (queue size: N)`, `Activity write failed: …`, `Activity queued: …`, `Letter write failed: …`, `Crossing write failed: …`, and later `… dropped after N failures …`.
- If any failure appears and classification matters, re-run with a breakpoint at `AirtableService.swift:1212` / `:764` and `po String(data: data, encoding: .utf8)` — wait, the data is discarded; instead break on the `guard` and `po response` for the status code, or use a proxy. A single observed live failure is conclusive; absence of historical logs is not (unified logs persist hours-to-days).
- Afterward, verify in Airtable (Ashrey's own UI, read-only look): did the Recognition row land? Did the ledger row land (first-felt case)? Report both.

**A2. Queue + ledger autopsy (from the Phase-1 container snapshot).**
- UserDefaults plist: `<container>/Library/Preferences/com.ashrey.bindu-mandala.plist` — report contents/counts of `pendingActivities`, `pendingRecognitions`, `pendingLetters`, `pendingCrossings` (expected empty — say so explicitly if so; non-empty contents are gold: decode the JSON blobs and list every item with its `failCount`), and **`ledgeredLetters`** (string array of Airtable record ids — decisive per §0.4; map ids → Śaktis: recVTjgXCpARyvRGN=KP29 Kāmākarṣiṇī, rec2iQRUZuiwWgtTo=KP39 Smṛtyākarṣiṇī, recVjJTPkaNHajJK0=KP44 Śarīrākarṣiṇī).
- Also report `daily_summons_enabled`/`daily_summons_hour`, `lr_sound`, `last_destination`/`last_destination_day` while you're in there (context for H8 and the Mandala sound observation).

**A3. PAT + build identity.** From Phase 1: installed build number + channel; the Console PAT verdict. From App Store Connect (Ashrey's browser): Xcode Cloud last build status, and workflow → Environment → Variables — does a secret named exactly `AIRTABLE_PAT` exist? Report which build config the device runs (TestFlight = Release).

**A4-device. The arbiter: local store vs Airtable.** From the container snapshot, open the SwiftData store (`<container>/Library/Application Support/default.store` — it is SQLite; use `sqlite3` on a copy):
- Dump all `RecognitionEntry` rows (table likely `ZRECOGNITIONENTRY`): count, dates, khadgamalaPosition, gesture. Compare against the 15-row Airtable table in §0:
  - Local rows **after 2026-07-13** with no Airtable twin ⇒ **usage continued, writes fail** → the fault window opens at the first missing row; correlate with A3.
  - No local rows after 07-13 ⇒ **usage stopped** (of the recognition gesture, at least).
  - Presence/absence of the 07-13 Kāmākarṣiṇī pair locally settles whether the phone or the dev Mac wrote them (absent locally = Mac/simulator wrote them; then Kāmākarṣiṇī's true practice count is 1 and the last phone recognition is 07-04).
  - Note: local entries with `gesture = silence` would be pre-07-11 Mauna dwells (kept for compatibility) — report their count/dates for the D3 historical record.
- Dump `ShaktiLetter` rows (expect 3, positions 1–16 keyed; report which positions and their modification dates if present).
- Dump `DescentState` (expect `deepestReached = 9`, one or more crossing dates).

**A6-device.** Covered by A2's `ledgeredLetters` read. Cross-reference: marked ids vs the 3 live letters → which of the two exposure states from Session 1's A6 holds (never-attempted [unmarked] vs attempted-and-died [marked]).

---

## B · The 86 on device

**B1.** Open Detail for at least one Śakti from each of rings 1, 3, 4, 5, 6, 7, 8, 9 (dev build's `OPEN_DETAIL=<kp>` launch arg makes this fast; pick e.g. kp 1, 45, 53, 67, 77, 87, 99, 102). Per ring: do Iconography, Etymology, Appreciation Phrase, Cosmic Function, Somatic Signature, Codex Portrait, Devanagari render with real content? (Airtable data is complete for all 102 — any blank is cache, not data.)
**B2.** If any are blank: the model carries per-row freshness — dump `lastSyncedAt` for those rows from the SwiftData store (or lldb). Then trigger a manual sync (foreground the app; launch sync fires at `RootView.swift:109`) and re-check. Confirm the 300-second foreground loop ticks: leave the app foregrounded ≥ 6 minutes with Console attached and catch a second `[Phase 1] sync starting…`. Caveat: the per-row sync dump logs the codex portrait as `<private>` — use `lastSyncedAt`/lldb, not that log line.
**B3.** Already CONFIRMED in code (Session 1). On device, spot-check the same three guards visually on one 86-Śakti: no "INNER INSTRUMENT" cluster label, phonetic absent (not blank), somatic prompt shows her poem line or the universal invitation.

---

## C · Build & test health (Mac, any time)

**C1.** Clean build from a fresh clone: report Xcode version (project was created with Xcode 26.5, `LastUpgradeCheck 2650`), iOS SDK used (SDKROOT is unpinned `iphoneos`), deployment target confirmation (17.0), and **every warning** (list each; expect deprecations against the current SDK — none are known yet). Note whether objectVersion 71 / filesystem-synchronized groups open cleanly.
**C2.** Run the full suite (`Bindu MandalaTests`, app-hosted): pass/fail per file + total runtime. Expected inventory: 14 unit files / 65 methods + 1 UI file / 2 methods (AtmosphereTests 7, DailyEnergyServiceTests 8, DescentMirrorTests 4, ElementTests 3, KhadgamalaMapTests 4, LunarPhaseServiceTests 5, MandalaCameraTests 9, MandalaWorldTests 7, RecognitionMigratorTests 3, RiteCompositionTests 5, SchemaMigrationTests 2, SeatLightingTests 3, ShaktiStatusTests 3, TimeVariantModulationTests 2; UITests 2). `AppRuntime.isUnitTesting` silences launch side effects for unit tests. **Warning:** the XCUITests launch the real app with the Mac's PAT and write to live Airtable (`ENERGY_POS=29` — this is how the 07-13 rows likely arose). Either skip the UI tests, or run them knowingly and note the rows they create.
**C3.** App binary size (archive → Organizer, report .app and thinned sizes). Asset catalog is 476 K, fonts 1.1 M (known); confirm on-disk .app matches expectations. Min-OS reality already CONFIRMED (17.0 everywhere, zero `@available` above it).
**C4.** Xcode Cloud: does the workflow still build? Last build status + the `AIRTABLE_PAT` secret presence (same App Store Connect visit as A3).

---

## G5 · Performance baseline (the Homes before-picture)

On Ashrey's iPhone (report the model identifier — Settings → General → About, include chip if known):
- **Frame rate** during (a) the Mandala's deep zoom, tier 0 → 2 pinch (`LivingMandalaView`) and (b) the Bindu → Lalitā descent (tap the Bindu; `openDescent()`): Xcode FPS gauge or Instruments (Core Animation / Hitches). Report sustained fps and worst dips.
- **Memory** at rest (Rite screen) and at deepest zoom (Xcode memory gauge).
- **Thermal** across a 10-minute continuous Mandala session (`ProcessInfo.thermalState` via Xcode's Energy gauge or Instruments; report any elevation).
- **Cold-launch time** (kill first; Instruments App Launch template, or stopwatch-to-first-frame ×3, report median).
Context for interpretation (from Session 1): the whole Mandala is ONE SwiftUI `Canvas` redrawn per frame by a `TimelineView`; there is no Metal/SpriteKit/shader escape hatch anywhere; DustMotes are per-mote SwiftUI views. This baseline is what every Homes fidelity-vs-performance call gets measured against.

---

## H · Felt experience, UX & accessibility (device register)

**H1.** Run `iOS/FIDELITY.md`'s 8-point per-screen pass for the five destinations (Rite, Mandala, Well, Field, Portrait) + Detail, Recognition, Threshold, Homecoming, Settings. Verdict per screen per point. Session 1's component census (in AUDIT-REPORT.md §H1) tells you what code puts on each screen — the device pass judges how it *lands*, on the real phone and ideally also a small-device simulator (FIDELITY rule 7 wants Pro-Max + small).
**H2/H3/H4.** Already swept statically (31 readability sites, 8 touch-target violations, no dead ends — tables in AUDIT-REPORT.md). On device, verify only the top items *by feel*: the Mandala tier hint (9.5 pt @ 0.42 — the app's only navigation instruction), the unlit seat names, the two ghost exit hints (Homecoming, Recognition), and the "↑ return to the field" button (~19 pt hit target) — does a real thumb hit it first try?
**H5.** VoiceOver walk of Rite → Detail → Recognition. Expectations from static analysis: labeled elements speak phonetic-first; the 86 fall back to raw diacritized Sanskrit (report how VoiceOver actually pronounces one); the Devanagari line in Detail is unlabeled raw text; **the entire canvas Mandala is silent to VoiceOver** (no elements) — confirm and report. Dynamic Type at one large setting: expect *nothing* to scale (152 fixed-size font sites in Views, zero scaled styles) — confirm and note the worst screen. Reduce-motion ON: walk the same flow; loops must pause (all 9 repeatForever loops are gated in code; the one residue: toggling reduce-motion mid-session does not stop already-running mote loops — verify by toggling while on the Rite).
**H6.** The ceremony, felt — with Ashrey present, one real recognition end-to-end (pair with A1). **Corrected script (the old "+3 s" brief line does not match shipped code):** "she was felt here" fades in at 2.6 s; "and she felt you back" at 4.1 s (~1.5 s after act 1), italic, in the element's `accentBright` (gold-family, per-element, not literal gold); the note prompt lands at 5.1 s and cannot dismiss the moment (it swallows its own taps; close is tap-anywhere elsewhere). Subjective verdict welcomed — does the timing and weight land on this device? This is the one item where feel outranks measurement.
**H7.** Sound & haptics in the hand. What actually plays today: bīja tap sounds (Detail, Lalitā source, Mandala deep-zoom) — synthesized sine/drone, no voice files exist; the opt-in ring chime in the Mandala (♪ toggle — note: the toggle resets every session, a known defect); 29 haptic sites. The nine per-ring voices (drone, home breath, Shepard, triad…) are **dormant — zero callers** — so silence outside the above is expected, not broken. Report: per-ring chime character correct? levels? clicks/pops on enter/leave? anything that breaks the quiet?
**H8.** The summons. Verify via observation over the audit window **or** pending-notification inspection (dev build + lldb: `UNUserNotificationCenter.current().getPendingNotificationRequests` — expect up to 14 `summons.Y-M-D` entries at the chosen hour, each named for that future day's presiding Śakti; today's absent if the rite is done). Known code facts: alert-only (no sound); duplicates structurally impossible; a summons already *delivered* before the rite is not retracted (only pending ones drop). Report: does it arrive at 6 am, correctly named, once, and drop when the rite is already done?

---

## Also observed (device session)

Anything real found outside these items: one line each, no fixes. Candidates to keep an eye on: whether the phone's `lr_sound`/soundOn reset annoys in practice; whether the Portrait glow clamp (522cdd3) holds on the physical screen; any thermal/battery observation during H7/G5.

## Closing law

Report, never repair. No Airtable writes by the auditor, no field creation, no queue manipulation, no reinstall, no commits, no pushes. Ashrey's own practice (recognitions, letters) is not an audit action and proceeds naturally — but note in the report which Airtable rows the audit window produced, so the record stays clean. The audit's gift is a true map; the map's maker leaves no footprints.
