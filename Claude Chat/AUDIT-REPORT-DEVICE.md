# AUDIT-REPORT-DEVICE — Bindu Mandala (Session 2 of 2, device-side)

**Audit date:** 2026-09-06 (evening EDT; UTC dates below cross midnight into 09-07) · **Auditor:** Claude Code on Ashrey's MacBook · **Repo:** `main` @ `522cdd3` (verified = audited tip; working tree clean)
**Device:** "Neev" — iPhone 16 Plus (`iPhone17,4`, A18), UDID `3E9910F6-9782-5F95-A086-908C9F982723`. Installed app: **Bindu Mandala 0.1.0 (build 34)**, `builtByDeveloper: true`, **no TestFlight app installed on the phone**.
**Companion:** `AUDIT-REPORT.md` (Session 1). This report covers only Session 1's BLOCKED items. Verdicts: CONFIRMED / REFUTED / PARTIAL / BLOCKED + evidence.
**Method:** Phase-1 capture per the sequencing law (installed-build identity → untouched container snapshot → live-launch attempt), then three multi-agent passes — container forensics (plist + SwiftData autopsies → cross-reference arbiter → independent adversarial verification that re-derived every load-bearing number), Mac health (clean-clone build, unit suite, archive, simulator fidelity on Pro-Max + SE), and this synthesis. 8 epoch conversions re-computed by hand during verification; the core verdict survived a deliberate refutation attempt and was strengthened by it.
**Laws honored:** no code edits, no commits/pushes, no queue manipulation, no reinstall/delete, no auditor-intended Airtable writes; read-only Airtable GETs only (Session-1 precedent). **One unintended Airtable write sequence occurred as an audit side effect — one row created plus one no-op letter PATCH — fully disclosed in §Disclosure**; it turned out to be evidentially valuable.
**Evidence archive (keep this):** `~/Desktop/BinduMandala-DeviceAudit-2026-09-06/` — pristine container tar (pre-any-launch), post-WAL-merge forensics copy (`forensics-copy-postWALmerge.tar.gz`, holding `default.store` and the Preferences plist all queries below ran against), the full forensic write-ups (`container-forensics-findings.md`), Mac-health results (`mac-health-findings.json`), both simulator screenshot sets, `c1-build.log`, `c2-test.log`, device app inventory JSON, and the read-only Airtable check script.

**Sequencing law — HONORED.** Phase 1 executed in order before anything else touched the phone: A3-installed (app inventory read, 22:15 EDT) → A2 (container downloaded untouched and sealed as the pristine tar, 22:18–22:19 EDT) → A3-live (two console-attach launches, 22:21/22:24 EDT, after the seal; both yielded no os_log relay). **No dev build was ever installed on Neev** — the device disconnected before Phase 3/4, so zero device writes carry a working PAT; the one PAT-carrying write of the session came from a Phase-5 simulator (§Disclosure), not the phone.

---

## The answer to the session's core question (read this first)

**Usage never stopped. The pipe broke. — CONFIRMED, adversarially verified.**

The phone holds **74 RecognitionEntry rows, and Core Data persistent history proves none was ever deleted** (zero delete-type changes across 10,509 `ACHANGE` records; unbroken chain of 476 `ATRANSACTION` rows 2026-05-20 → 2026-09-06, every one authored by `com.ashrey.bindu-mandala` — no second writer, no wipe, no delete-and-reinstall; the two fault-era installs were install-over events that preserved the container). Queries ran against the sealed store in the evidence archive (`forensics-copy-postWALmerge.tar.gz` → `Library/Application Support/default.store`); full dumps in `container-forensics-findings.md`. **29 recognitions — 2026-07-09 through the morning of this audit — exist only on the phone.** That is a sustained near-every-other-day practice across 60 days, ranging the whole instrument (rings 1–9, kp 6 → 102, including Ring 9/kp102 twice), with living notes: "Ram Japa" (07-25), "I feel you Mommy" (08-04), and the morning of the audit itself, Prākāmya (kp 7): *"I appreciate you the most."*

That last one was **caught live in `pendingRecognitions` with `failCount=0`** — affirmative, same-day proof that a write fired and failed, not an inference from absence.

**The fault window:** the phone's last successful content sync stamped all 126 synced rows (102 Śakti + 9 Āvaraṇa + 15 Nityā) in one 9 ms burst at **2026-07-05 00:45:21 UTC — and never again in 63 days**. The first recognition that never reached Airtable is pk46, **2026-07-09 14:25:35 UTC**. Schema-migration transactions pin the fault-era build's first launch to **2026-07-08 02:41:28 UTC**, with a second install 2026-07-14 02:18:08 UTC (= 07-13 22:18 EDT, the TestFlight-era evening). **Both fault-era installs failed from first contact: no write and no content sync ever succeeded on them.**

**The 07-13 Kāmākarṣiṇī pair is confirmed dev-harness from the device side:** the phone has zero kp29 activity in July at all. True Kāmākarṣiṇī practice count = 1 (2026-06-01); the last phone recognition to reach Airtable is Śabdākarṣiṇī, **2026-07-04 19:13 UTC**. Even the lone Airtable Crossing row (2026-07-12 02:54 UTC = 07-11 22:54 EDT) is proven non-phone: the phone's DescentState was untouched between its 07-08 creation and 07-14 12:33 UTC, with zero Core Data transactions anywhere near the crossing instant — a phone-origin crossing without a local DescentState write is impossible in the shipped architecture.

**Cause classification — PARTIAL (leading cause, not proven):** every PAT-requiring path (recognition write, letter PATCH, activity write, crossing write, content sync) failed uniformly from the fault build's first day — the exact signature of `guard let token = pat else { return false }` (nil/unresolved `AIRTABLE_PAT` in the installed build's Info.plist). A device-side network/ATS block on `api.airtable.com` or a revoked token would leave an identical artifact trail; no HTTP status survives anywhere (Session 1 §A1's logging limitation). The three discriminating tests are queued in §Remaining-captures; none survived the device's disconnection tonight.

---

## Verdict summary

| Item | Verdict | Item | Verdict | Item | Verdict |
|---|---|---|---|---|---|
| Core question | **CONFIRMED: usage continues, writes fail** | B1 the 86 render | PARTIAL (store + sim; device walk deferred) | H1 fidelity pass | PARTIAL (sim halves done) |
| A1 live capture | PARTIAL (queue-caught failure) | B2 staleness/sync loop | PARTIAL | H2/H3/H4 by feel | PARTIAL |
| A2 queue autopsy | CONFIRMED | B3 degradation guards | CONFIRMED (on-screen) | H5 VoiceOver/DynType | BLOCKED |
| A3 PAT + build identity | PARTIAL | C1 clean build | CONFIRMED | H6 ceremony felt | BLOCKED |
| A4-device arbiter | CONFIRMED | C2 test suite | CONFIRMED (65/65) | H7 sound in hand | BLOCKED |
| A6 letter exposure | CONFIRMED (mechanism corrected) | C3 sizes | PARTIAL | H8 summons | PARTIAL |
| Question 0 | BLOCKED (moot for mechanism) | C4 Xcode Cloud | BLOCKED | G5 perf baseline | BLOCKED |

---

## A · Ledger & pipe forensics — device half

### A1 — Live capture of one real recognition — **PARTIAL** (stronger artifact than the planned one; ceremony not re-performed)

- Live console attachment failed twice: `devicectl … launch --console` (with and without `OS_ACTIVITY_DT_MODE`) relays no `os.Logger` output from the Release build, and `log collect --device` requires root (no sudo in this session). The planned Ashrey-performed rites did not occur before the device disconnected.
- **The equivalent evidence arrived anyway:** the morning-of-audit recognition (Prākāmya kp7, feltAt 2026-09-06 14:34:41 UTC, note "I appreciate you the most") was captured **inside `pendingRecognitions` at `failCount=0`** — per `recordRecognition`'s semantics (inline attempt → enqueue only on failure) this is affirmative proof the write fired and failed that morning. Airtable GET (read-only) confirms: no Recognition row after 2026-07-13 exists.
- Timing microstructure (verified): entry inserted 14:33:42.936 (21 µs after `daily_summons_last_rite_completed`), updated 14:34:40 (note committed), queued feltAt 14:34:41 — the ceremony's two-phase write behaving exactly as Session 1 documented.
- Failure classification (422 vs auth vs network) remains impossible from logs by design (response bodies discarded pre-log, Session 1 §A1) — see Remaining-captures.
- Audit-trail note: the auditor launched the installed app twice (≈22:21 and ≈22:24 EDT) attempting console capture, after the container snapshot was sealed. Each launch runs a flush pass; per the 3-strike rule these launches likely advanced the queued item's failCount from 0 toward drop. The item's full content is preserved in the pristine snapshot for backfill.

### A2 — Queue + ledger autopsy — **CONFIRMED** (complete; one queue was NOT empty)

From the pristine snapshot (`Library/Preferences/com.ashrey.bindu-mandala.plist`):

| Key | State |
|---|---|
| `pendingRecognitions` | **1 item** — verbatim: `[{"note":"I appreciate you the most","source":"Today","moonPhase":"Waning Crescent","feltAt":810398081.097376,"shaktiRecordId":"recu08aAkKsbnb4hw","lunarDay":25,"failCount":0}]` (= Prākāmya kp7, 2026-09-06 14:34:41 UTC). `failCount` still 0 after ~11.5 h because no flush pass ran between enqueue and the snapshot — the app was not foregrounded again that day (consistent with the transaction log: no store activity after 14:34:40 UTC); the auditor's two post-snapshot launches were the first flushes since. |
| `pendingActivities` / `pendingLetters` / `pendingCrossings` | **ABSENT** — expected under every failure mode (3-strike drop); excludes nothing |
| `ledgeredLetters` | **`["recVjJTPkaNHajJK0"]`** — KP44 Śarīrākarṣiṇī only; KP29 and KP39 not present |

Settings keys: `daily_summons_hour=6`; `daily_summons_enabled` absent (default enabled); `lr_sound=true` (stored but never read back — Session 1's observation confirmed from the device: the defect is the missing restore, not the missing save); `last_destination="memory"`, `last_destination_day=2441` (= 2026-09-06); `daily_summons_last_rite_completed` = 2026-09-06 14:33:42.936 UTC (**the rite was completed the morning of the audit**). Also present: `hasLaunched`, `hamburger_first_run_seen`, `hasSeenMandalaPulse`, `summons_hour_migrated_to_6am`, legacy `unlockedRings=[1…9]`, and an older notification-design trio (`notifications_enabled=true`, `notifications_interval_hours=6`, `notifications_start_hour=9`).

### A3 — PAT + build identity — **PARTIAL**

- **Installed build:** 0.1.0 (**34**) — consistent with Xcode Cloud's `ci_pre_xcodebuild.sh` stamping (the repo pins `CURRENT_PROJECT_VERSION 1`), though a manual local version bump cannot be excluded. `devicectl` reports `builtByDeveloper: true` and **no TestFlight app exists on the phone** — the install channel is unresolved (Ashrey's memory or ASC will settle it; no `.xcarchive`/`.ipa` artifact of build 34 exists on this Mac, and no Xcode Archives folder exists at all).
- **PAT presence in build 34: undetermined directly** (no sudo for device logs; bundle container unreadable via `devicectl`; device disconnected before a dev-build A/B test). **Functionally:** all five PAT-requiring paths failed uniformly from first launch (07-08 02:41 UTC) — consistent with nil PAT, network block, or dead token; nil PAT remains the leading cause (a green PAT-less Xcode Cloud build is a designed outcome of `ci_post_clone.sh:18–21`).
- Install timeline from schema-migration transactions: fault-era install #1 first-launched **2026-07-08 02:41:28 UTC**; install #2 **2026-07-14 02:18:08 UTC** (07-13 22:18 EDT — the same evening as the compliance-clearance commit and the dev-harness Airtable rows; pk48 was felt 109 s after that install).

### A4-device — The arbiter — **CONFIRMED** (full row-by-row reconciliation)

- **74 local rows** (54 felt, 20 silence), PKs 1–74 contiguous. Pre-sync era pk1–23 (05-20 → 05-31) correctly absent from Airtable. Synced era pk24–45: **22 local rows reconcile onto 21 Airtable objects** (12 phone Recognition events + 9 Silence rows; match tolerance ±60 s, empirically validated by the 58 s entry→feltAt lag of pk74) — the pk40/pk41 pair (06-12 19:00:13 no-note / 19:00:32 "Atlas emergence") collapses onto Airtable's single 19:01 row, so exactly one June event never got its own Airtable row (which of the two is undecidable and immaterial). **Total device-only felt rows: 30 — the 29 fault-era rows plus that one June event**; the fault-era count of 29 is the core figure. Airtable's 06-01 KP44 duplicate is **server-side** (one device event; `serverRecognitionCount` counts it once).
- **Fault era: all 29 felt rows pk46–74 (07-09 → 09-06) unmatched in Airtable.** New-model shape (shaktiPosition=0, true kp/ring) throughout.
- **Letters (bodies withheld; lengths only):** 16 slots; 3 non-empty — pos 12/KP40 (14 B, 2026-05-20; **local-only — Airtable has no KP40 letter**), pos 11/KP39 (13 B, 2026-05-31; in sync), pos 16/KP44 (**69 B, rewritten 2026-08-24 01:11:19 UTC** — never landed). Pos 1/KP29: **cleared to 0 B at 2026-08-24 01:11:11 UTC** after 12 object revisions — see A6.
- **DescentState:** deepestReached=9 ✓; currentRing=6, entered **2026-09-05 18:40:47 UTC — the descent instrument was in use the day before the audit**. Local crossings blob: 6 crossings, fully consistent with Ruling 8's once-per-new-deepest contract (`crossings.append` lives inside the strict-new-deepest branch, `DescentState.swift:41–53`): the 5 same-instant entries (07-14 12:33:25–29 UTC) are a stepwise rapid descent through five successively deeper rings, and the 07-25 15:38 UTC entry is the Ring-9 arrival that set deepestReached=9 — 81 s after the kp102 recognition pk53. None of the 6 are in Airtable. The single Airtable Crossing row (2026-07-12 02:54 UTC = 07-11 22:54 EDT) is not in the blob and is proven non-phone (see core section — the proof rests on the transaction gap, with the blob as corroboration).
- **Silence rows (D3 historical record):** 20 local `.silence` rows, 2026-05-20 → 2026-06-24, all old-model. The 9 on/after sync-live match Airtable's 9 Silence rows exactly. The 06-24 stop is now explained on the device side too: zero silence rows after 06-24 — **usage of the dwell stopped before the code died** (Session 1's "usage- or device-side" is resolved to usage-side).

### A6 — Letter dedup exposure — **CONFIRMED**, with a mechanism correction to Session 1

**Correction (verified first-hand at `AirtableService.swift:1012–1038`):** the `ledgeredLetters` mark is applied **after** the letter-PATCH attempt and **only for non-empty bodies** (Session 1's "marked before the network attempt" described the ledger-activity write that follows the mark, not the letter PATCH). So *unmarked ≠ never-PATCHed*: empty-body saves PATCH without ever marking.

| Letter | Ledger mark | Finding |
|---|---|---|
| KP44 | **marked** | A non-empty save post-07-08 fired the letter PATCH **and the first-ever eligible "Letter Written" ledger attempt from the phone — both died in the fault window.** This refines Session 1's "no ledger write was ever attempted": exactly one was, and it was lost. Airtable holds an older KP44 body than the phone's 08-24 rewrite. |
| KP29 | unmarked | The 08-24 **clear** (empty body) fired a PATCH that also died — **Airtable retains the letter Ashrey deleted locally.** Demonstrated live: a fresh simulator re-seeded the KP29 body straight from Airtable (the exact reinstall re-seed path Session 1 predicted). Disposition of the retained body is Ashrey's. |
| KP39 | unmarked | Untouched since 2026-05-31 (pre-ledger); in sync; no exposure. |
| KP40 | unmarked, no Airtable record | Local-only letter (2026-05-20). If the pipe is fixed and the letter is ever re-saved, it will produce a "first letter" ledger row dated then, not 05-20. |

---

## Disclosure — the one audit-caused Airtable write (and the app bug it exposed)

At **2026-09-07T02:38:36Z (22:38:36 EDT)**, during the H1 simulator pass, the iPhone 17 Pro Max simulator created App Activity row **`recGDqNCecjqBKC6K`** — Source App **Mandala**, Activity Type **Letter Written**, "A letter to Kāmākarṣiṇī", `Link to Mandala` → `recVTjgXCpARyvRGN`, Detail "First letter written", Activity Date 2026-09-06 — **the first Mandala row in the table's history**. It also PATCHed the KP29 letter with the identical body it had just seeded from Airtable (a no-op; letter content unchanged).

The agent only *opened* the letter editor for a screenshot — no typing. **Root cause is a genuine app bug:** `WellView`'s initial-load guard is inverted (`load()` sets `loaded=true` synchronously at `WellView.swift:243`, but `.onChange(of: draft)` at `:184` fires later in the same update cycle, when `loaded` is already true) — so **merely viewing a letter marks it dirty**, and the 5-second autosave (`:246–253`) fires a full save. Attribution chain: editor opened ≈22:38:31 → autosave/write 22:38:36 (row createdTime) → screenshot 22:38:41 → sim plist mark flushed 22:39:14. A fix-it task chip was filed for a separate session (this session is report-only). The row was left in place — deleting it would itself be a write; disposition is Ashrey's.

**Evidentiary value:** (1) **the ledger pipe is proven working end-to-end against today's live schema** — `createActivityRow`, the `Letter Written` select value, and `Link to Mandala` all function; the App Activity path was never broken, only the phone's connection is. (2) It demonstrates the A6 second-device duplicate exposure live, with a wrong date, and shows the trigger threshold is worse than predicted: viewing suffices.

## Audit-window Airtable rows produced (complete)

1. `recGDqNCecjqBKC6K` — the disclosed side-effect row above (+ the no-op KP29 letter PATCH at the same instant).
2. Nothing else. All auditor API access was GET; the two app launches on Neev wrote nothing (verified by before/after reads). The Feed-app rows dated 2026-09-06/09-04 are Ashrey's own use of a different app, pre-existing the audit window.

---

## B · The 86 on device

**B1 — PARTIAL** (the brief's per-ring Detail walk — rings 1, 4, 5, 6, 7, 8, 9 — was not performed on any screen; only ring 3 (kp45) and ring 2 (kp29) were opened, on simulators). What was established: the phone's cache is fully populated — 102/102 non-empty for codexPortrait, etymology, iconography, somaticPoetry, quality, devanagari, appreciationPhrase (store dump, `container-forensics-findings.md`) — so a blank Detail section on device is impossible on data grounds, which is the risk B1 exists to catch. `shaktiFunction` is empty on exactly the 16 Ring-2 rows in the cache; whether that mirrors the live server was not re-verified (inferred, not confirmed — the cache is 63 days stale). Renders verified where opened: kp29 shows the full Ring-2 data shape; kp45 (Anaṅga-Kusumā) renders codex, somatic poetry, etymology, iconography correctly on Pro Max and SE.
**B2 — PARTIAL.** `lastSyncedAt` dumped for every row — uniformly 2026-07-05 00:45:21 UTC (the finding itself). The manual-sync/300-s-tick observation is moot until the pipe works (sync cannot stamp anything with the current build) and the device disconnected before a dev-build test; the 300-s loop remains code-confirmed (Session 1).
**B3 — CONFIRMED on-screen (both simulators, kp45):** no "INNER INSTRUMENT" label anywhere (cluster row omitted entirely; kp29 correctly shows its real cluster); phonetic cleanly absent — no empty gap (kp29 correctly shows KAH·MAH·KAR·SHI·NEE); somatic section shows her own poem line. All three guards hold.

## C · Build & test health (Mac)

**C1 — CONFIRMED.** Fresh clone (HEAD verified 522cdd3) builds clean: Xcode 26.5 (17F42), SDK `iphonesimulator26.5`, deployment target 17.0 confirmed, objectVersion-71/filesystem-synchronized project opens with zero format complaints. **Zero compiler warnings.** The only distinct warning line is tool-level and benign (`appintentsmetadataprocessor` metadata skip). Local-first mode held (clone builds green without `Config.local.xcconfig`). Log: evidence archive `c1-build.log`.
**C2 — CONFIRMED.** **65/65 unit tests pass** across all 14 expected classes (per-class counts match the inventory exactly); test execution 0.74 s (387 s wall including build + sim boot). XCUITests **skipped by decision** (they write live Airtable rows); compiled but never executed. Log: `c2-test.log`.
**C3 — PARTIAL.** Unsigned Release archive succeeded: **.app = 3.07 MB on disk** — executable 1.71 MB (56 %), Cormorant fonts 1.07 MB (matches the known 1.1 M), `Assets.car` 305 K (the 460 K AppIcon PNG compresses well), Info.plist 1.5 K. No embedded frameworks or Swift dylibs. Thinned sizes not measured (requires signed export; keychain interaction out of scope).
**C4 — BLOCKED.** App Store Connect unreachable this session (Chrome extension not connected; no stored session available to the in-app browser). The decisive checks remain: last Xcode Cloud build number/status (is build 34 a Cloud product?) and workflow → Environment → Variables → existence of a secret named exactly `AIRTABLE_PAT`.

## G5 · Performance baseline — **BLOCKED** (device disconnected before the instrumented run)

Captured: device model **iPhone 16 Plus (`iPhone17,4`, A18)** — the baseline hardware identity. FPS/memory/thermal/cold-launch require the phone + Ashrey's hands (pinch, descent); the capture recipe stands in Remaining-captures. One transferable observation: under a heavily loaded host, both simulators showed staged first paint (all-black frame ~6–10 s post-launch on Mandala/Field/pushed Detail, complete by 10–16 s) — worth confirming paint latency on hardware during the baseline.

## H · Felt experience, UX & accessibility

**H1 — PARTIAL** (simulator halves complete on the FIDELITY rule-7 pair; device-feel pass deferred). Screens captured and judged against the 8-point checklist on **iPhone 17 Pro Max** (11 screens) and **SE-check** (12 screens incl. Settings and the OPEN_SILENCE descent). Of the 8 points, the still-judgeable subset (atmosphere presence, composition, legibility, layout/clipping, blank-section and degradation checks) was judged per screen — no failures on either size; the motion/feel points (animation pacing, haptic weight, small-device thumb reach) are exactly what the deferred device pass covers. Gaps stated plainly: Settings was captured only at SE width (Pro-Max Settings not judged); per-screen-per-point grids with the verdict text live in `mac-health-findings.json` + both screenshot sets in the evidence archive. **PR #25's Portrait glow clamp holds on both widths — hamburger on-screen.** Homecoming appears and passes. Real findings are under Also-observed: SE Well-header collision, Mandala z-order overlap, sans-face tokens, staged first paint.
**H2/H3/H4 — PARTIAL.** Sim-verifiable subset done: both ghost exit hints render as designed (present, faint); no dead end encountered on any captured screen; hamburger reachable everywhere including Portrait. The by-feel items (tier-hint legibility at 9.5 pt on device, unlit seat names, the ~19 pt "↑ return to the field" thumb test) are deferred to the device pass.
**H5 — BLOCKED** (VoiceOver walk, Dynamic Type, reduce-motion residue all need the phone + human). Static expectations from Session 1 stand unchallenged.
**H6 — BLOCKED** as a felt verdict. Mechanically, the ceremony demonstrably completes in daily practice (the morning-of-audit rite completed at 10:33:42 EDT and produced its local row + note 58 s later — the two-phase write functioning end-to-end locally). The corrected staging facts (2.6 s / 4.1 s / 5.1 s, accentBright italic) carry forward for the felt session.
**H7 — BLOCKED** (in-hand). One plist fact: `lr_sound` stores `true` — the ♪ choice *is* persisted; the defect is that `LivingMandalaView` never reads it back (restore missing, Session 1 Also-observed #1 sharpened).
**H8 — PARTIAL.** Code intent was already CONFIRMED (Session 1). Device corroboration: `daily_summons_hour=6`, summons enabled (key absent = default on), migration flag set, and `daily_summons_last_rite_completed` was updated the morning of the audit (2026-09-06 10:33 EDT) — the summons→rite loop was alive that day. The pending-notification dump (≤14 `summons.Y-M-D` ids, per-day naming) and the 6 am delivery observation were not performed (need dev build + lldb / an observation window).

---

## Also observed (device session; one line each, no fixes)

1. **WellView dirty-on-load bug (live-proven):** viewing a letter for ~5 s triggers a real save — Airtable letter PATCH + (on any install with an unmarked id) a spurious wrong-dated "Letter Written" ledger row. Fix-chip filed; see §Disclosure.
2. **Brief erratum:** `OPEN_LETTER=<pos>` takes ring-relative position 1–16, not kp 29–44 — `OPEN_LETTER=29` silently no-ops (`WellView.swift:75` matches `Shakti.position`).
3. `OPEN_NITYA` is defeated by same-day tab restore unless paired with `START_TAB=rite`; `START_TAB` literal values are `mandala | rite | well | 102 | memory`.
4. **SE-width Well header collision:** the hamburger ≡ overlaps the final "m" of "Your Letters to Them" (SE screenshot 03-well.png).
5. Minor Mandala z-order: a bright seat glow renders partly under the zoom-control column (both widths; controls stay legible/tappable).
6. Type-token observation: the quality-description paragraph (Detail, both kp29/kp45) and the Settings sheet title render in a system sans rather than Cormorant — deliberate or a fidelity slip; flagged for the design eye.
7. Staged first paint under host load (see G5) — verify paint latency on hardware.
8. `serverRecognitionCount` is frozen at the pre-07-13 snapshot (12 events) — Detail's embodiment-readiness thresholds have been operating on stale counts for 63 days and will jump when sync resumes.
9. Legacy keys in the device plist: `unlockedRings=[1…9]` (pre-open-instrument era) and a `notifications_*` trio from an early notification design, coexisting harmlessly with the summons keys.
10. Install-channel puzzle: build 34 + `builtByDeveloper: true` + no TestFlight app on the phone; no build-34 artifact (archive/IPA) on this Mac; Xcode Archives folder does not exist. Ashrey's memory or ASC will settle how build 34 was installed.
11. The 06-24 Silence stop is usage-side (device shows zero dwells after 06-24 while the write path still existed) — closing Session 1's open "no code explanation" note.
12. Practice-fidelity nuance for backfill: `Activity Date` is a device-local day; the 29 stranded recognitions carry full UTC instants in the store — backfill from the snapshot, not from memory.

## Question 0 — **BLOCKED (moot for mechanism)**

Ashrey does not recall when `Link to Mandala` was created; the API cannot date it. Tonight's side-effect row proves the field exists and links correctly *now*. Whether it existed before 2026-09-06 no longer bears on any finding: the phone attempted no ledger writes it could have received (the one attempt, KP44's, died at the PAT/network layer, not at the schema). Check the base's revision history if the historical record matters.

---

## Remaining captures (the short list for the next device session)

Everything below needs Neev connected (and mostly Ashrey's hands). In evidentiary order:

1. **Cause proof (one of three suffices):** (a) `sudo /usr/bin/log collect --device-udid 3E9910F6-9782-5F95-A086-908C9F982723 --last 3d` then grep the archive for `No PAT — local-only mode.` vs `[Phase 1] sync starting…` at any launch; (b) App Store Connect → Xcode Cloud → workflow → Environment Variables → is `AIRTABLE_PAT` present, and is build 34 a Cloud product; (c) install the dev build (working PAT) over the same bundle ID — if sync immediately succeeds on the same phone/network, the installed build's PAT was the fault.
2. **The recovery that matters (not an audit step):** the dev build's first launch will flush any still-queued recognitions with their true timestamps — then backfill the dropped ones (29 total) from the sealed snapshot. Reconciliations awaiting Ashrey's ruling: the two 07-13 dev-harness rows, the server-side 06-01 KP44 duplicate, the Airtable-retained KP29 letter body, the local-only KP40 letter, the stale Airtable KP44 body, and tonight's `recGDqNCecjqBKC6K`.
3. A1/H6 live rite with Console.app attached (subsystem `com.ashrey.bindu-mandala`), on a working build.
4. G5 baseline (Instruments: Animation Hitches during tier-0→2 pinch + descent; App Launch ×3; memory at rest/deepest; thermal over 10 min).
5. H5 VoiceOver + Dynamic Type + reduce-motion-mid-session walks; H7 sound/haptics in hand; H8 pending-notification dump; H1–H4 device-feel passes.

---

*Produced read-only: no code edits, no commits, no pushes, no queue manipulation, no reinstall. One disclosed side-effect Airtable row (§Disclosure), left in place. This file exists only in the local working tree — never committed. The map's maker leaves one footprint, and names it.*
