# AUDIT-REPORT — Bindu Mandala (read-only)

**Audit date:** 2026-09-07 · **Auditor:** Claude Code (remote Linux container)
**Repo state audited:** `main` @ `522cdd3` — identical to `origin/main` and to the working branch; the clone carries **full history** (43 commits, 2026-05-20 → 2026-07-13; no unshallow was needed and none was run).
**Airtable evidence:** read live on 2026-09-07 via read-only API calls only (schema reads, record lists, counts). **No write of any kind was made** — no field created, no test write fired, no queue flushed, no record touched. Letter *text* was never read; only letter *presence*.
**Vantage limits, stated up front:** this container has no Xcode, no Swift toolchain, no simulator, and no access to the phone. Every item that requires the device or a Mac carries a **BLOCKED** verdict plus exact capture instructions (collected in §Device-Session Capture Card at the end). Nothing was fabricated to fill those gaps.
**Method:** live Airtable forensics performed directly; code/history audit fanned out across 7 specialist passes, each independently re-verified by an adversarial citation-checker (every `file:line` and commit hash re-opened; 596 citations checked), then swept by a completeness critic against the brief. Corrections from verification are folded into this report — where a first-pass claim was wrong, only the corrected version appears here.

---

## The finding that reframes the brief (read this first)

The brief's working hypothesis — *"the `Link to Mandala` field was never created in the live table, so every Mandala ledger write in history has died silently (422 → 3 retries → dropped)"* — is **REFUTED as a mechanism, on two independent grounds**, while its observable core is **CONFIRMED**:

1. **Zero Mandala ledger rows: CONFIRMED.** All 46 App Activity rows (`tblJlBeiHnqGpYrL7`) are Source App = Feed or Learning. No Mandala row has ever existed there.

2. **The field exists — live, today, with exactly the right name.** The live schema (read 2026-09-07) contains `Link to Mandala` (`fldzsEMInQmNIxTNu`, multipleRecordLinks → the Mandala table `tblrRwXJD0uP8HU8G`), plus Source App option `Mandala` and Activity Type options `Shakti Recognized` and `Letter Written`. Every field name `createActivityRow` writes (`Source App`, `Activity Type`, `Activity Name`, `Detail`, `Activity Date`, `Link to Mandala` — `Data/AirtableService.swift:1138–1143`) exists in today's schema; both select values exist. **A 422-on-unknown-field-name is impossible against today's schema.** Whether the field existed *before* 2026-09-06 is undeterminable from the API (Airtable exposes no field-creation timestamps, and Chat's Sept-6 inference came from record JSON, where an all-empty link field is invisible — Airtable omits empty fields from record data). Either someone created it in the ~24 h between Chat's read and this audit, or it existed all along and the Sept-6 inference was mistaken. **Only Ashrey can settle which** (see Capture Card, item 0).

3. **It doesn't matter for history — because no Mandala ledger write was ever attempted.** The ledger extension shipped in one commit, `7fe8353`, 2026-07-07. The `Shakti Recognized` write fires only on a first-ever recognition (`wasFirst = (previousCount == 0)`, `AirtableService.swift:716`). The live per-row dates prove **every one of the 11 first-felt events happened 2026-05-31 → 2026-06-24 — all at least 13 days before the ledger existed.** The only recognitions after 2026-07-07 are the two Kāmākarṣiṇī rows of 07-13, at previousCount 1 and 2 — `wasFirst == false`, no ledger call. The `Letter Written` write fires only on an actual letter *edit* (`WellView.swift:257 guard dirty`), and letters shipped 05-31, five weeks before the ledger; whether any of the 3 live letters was edited after 07-07 on a ledger-capable build is decidable on-device from `ledgeredLetters` (the mark is written *before* the network attempt, `AirtableService.swift:1029–1030`, so marked = attempted, unmarked = never attempted). **Nothing died silently on this path so far as any evidence shows: there was never an eligible event.**

4. **The real casualty is upstream, and bigger: the Mandala table itself has received nothing since 2026-07-13** — the exact day all development stopped (final commit `522cdd3`, 07-13 22:48 EDT). And the 07-13 recognitions themselves are suspect: both are position 29, the precise value the XCUITest pins (`ENERGY_POS=29`, `Bindu MandalaUITests/BinduMandalaUITests.swift:16`, committed 87cdd06 that evening), landing minutes around the verification-harness commits (dee77ab 16:53 EDT added `RECOGNIZE_AUTOCLOSE`; rows at 16:51 and 17:25 EDT). They are plausibly dev-verification writes from the Mac, not phone devotion — in which case the **last real practice recognition in Airtable is 2026-07-04 (Śabdākarṣiṇī)**. Whether the phone stopped being used, or kept being used while its writes fail (new TestFlight build without the PAT secret is the leading candidate — see A3/C4), is exactly what the device session must decide. The phone's local SwiftData `RecognitionEntry` store is the arbiter: it records every recognition locally regardless of network (see Capture Card, item 1).

**One warning that changes the A2 expectations:** the retry queues are **not a durable evidence store**. Every flush pass bumps `failCount` even when the PAT is nil (`AirtableService.swift:1178` returns false → `:1224–1232` bumps), and flushes run at launch, on every return-to-foreground, and every 300 s — so under *any* persistent failure mode a queued item is destroyed during its third flush (~4 total attempts, potentially within 10–15 minutes). Expect the four pending queues to be empty on the device no matter what happened. The durable device evidence is: local `RecognitionEntry` rows, local `ShaktiLetter` rows, `ledgeredLetters`, and the installed build's Info.plist. **The evidence-preservation law stands: do not delete or reinstall the app** — `ledgeredLetters` and the local stores are the crime scene now.

---

## Verdict summary

| Item | Verdict | Item | Verdict | Item | Verdict |
|---|---|---|---|---|---|
| §0 hypothesis (mechanism) | REFUTED | C1 build | BLOCKED¹ | F1–F7 | CONFIRMED ×7 |
| §0 zero-Mandala-rows | CONFIRMED | C2 tests run | BLOCKED¹ | G1–G4 | CONFIRMED ×4 |
| A1 device capture | BLOCKED¹ | C3 sizes | PARTIAL | G5 baseline | BLOCKED¹ |
| A2 queue autopsy | BLOCKED¹ | C4 Xcode Cloud | PARTIAL | H1 fidelity pass | PARTIAL |
| A3 PAT in installed build | BLOCKED¹ | D1 timeline | CONFIRMED | H2 readability | CONFIRMED |
| A4 recognition pipe | CONFIRMED | D2 rebuild seq | CONFIRMED | H3 dead-ends | CONFIRMED |
| A5 wasFirst inventory | CONFIRMED | D3 Mauna's death | CONFIRMED | H4 touch targets | CONFIRMED |
| A6 letter dedup exposure | PARTIAL | D4 contradictions | CONFIRMED | H5 accessibility | PARTIAL |
| B1 the 86 on device | BLOCKED¹ | E1–E3 | CONFIRMED | H6 ceremony felt | BLOCKED¹ |
| B2 cache staleness | BLOCKED¹ | E4 | PARTIAL | H7 sound in hand | BLOCKED¹ |
| B3 degradation guards | CONFIRMED | E5–E8 | CONFIRMED | H8 the summons | PARTIAL |

¹ BLOCKED = requires Mac/device/App-Store-Connect; every code-side fact that *can* be established is reported below, and the capture card lists exactly what remains.

---

## A · Ledger forensics

### A1 — Device evidence of the failure — **BLOCKED** (device); code side CONFIRMED

The live Console capture itself requires the phone. What the capture must look for (all verified in code):

- Logger: subsystem **`com.ashrey.bindu-mandala`**, category **`airtable`** (`Data/AirtableService.swift:5`).
- Ledger path strings: `Activity write failed: <desc>` (error, :1183) · `Activity queued: <type> (queue size: N)` (notice, :1259) · `Activity queue: flushing N item(s)` (:1220) · `Activity dropped after N failures: <type>` (:1229). The brief's expected phrases are correct as prefixes.
- Adjacent strings worth watching in the same capture: `No PAT — local-only mode.` (:50) · `Recognition write failed:` (:728) / `Recognition queued` (:893) / `Recognition dropped after` (:682) · `Letter write failed:` (:1047) / `Letter queued for` (:1122) / `Letter dropped after` (:1084) · `Crossing write failed:` (:923) / `Crossing dropped after` (:963) · `[Phase 1] sync starting…` (:54).
- **Capture caveat that limits what the log can prove:** every HTTP failure is collapsed to `URLError(.badServerResponse)` *before* logging — the status code and Airtable's error JSON are discarded (`let (_, response)` at :1212–1214; same in `createRecognitionRow` :763–765 and `patchLetter` :1066–1068). Console alone **cannot distinguish a 422 from any other server error.** If failure classification is ever needed, it takes a proxy (Charles/mitmproxy) or an Xcode breakpoint on the response.
- Per §"reframes the brief": a live failure is only expected if the installed build's PAT is broken — the ledger path itself has never had an eligible event to fail on.

### A2 — Queue autopsy — **BLOCKED** (device contents); mechanics CONFIRMED

Queue mechanics (all in `Data/AirtableService.swift`; one shared `maxFailures = 3`, :617):

| UserDefaults key | Enqueued by | Flushed by | Drop log | Notes |
|---|---|---|---|---|
| `pendingRecognitions` (:616) | recordRecognition failure (:651–654 → :889–894) | flushPendingRecognitions :669–693 | :682 | drained/still-pending summary logged :689/:691 |
| `pendingLetters` (:1005) | saveLetter failure (:1117–1123) | flushPendingLetters :1071–1095 | :1084 | enqueue dedups to latest body per Śakti (:1119) |
| `pendingActivities` (:1149) | logActivity failure (:1172–1174 → :1255–1260) | flushPendingActivities :1217–1235 | :1229 | **no** drained-summary log, unlike recognitions/letters |
| `pendingCrossings` (:904) | recordCrossing failure (:912–914 → :989–994) | flushPendingCrossings :951–969 | :963 | |
| `ledgeredLetters` (:1150) | markLetterLedgered :1269–1274 | **not a queue — a permanent dedup set** | n/a | **never cleared anywhere in code** |

- Flush cadence (identical for all four queues, `flushPending` :662–667): start of every `sync()` (:47 — **before** the PAT guard at :49, so flushes run even in no-PAT mode), which fires at launch (`RootView.swift:109`) and every 300 s foregrounded (`BinduMandalaApp.swift:108–112`); plus every scene-active transition (`BinduMandalaApp.swift:77–78`).
- Drop timing, precisely: an item enqueues at failCount 0, is retried on each flush, and is destroyed *during its third flush pass* (failCount reaches 3 in that pass and it is not re-appended, :1224–1232). Total write attempts: 1 initial + 3 flush retries = 4. The drop is UI-silent by design (doc :659–661 "dropped silently — local SwiftData is already canonical") but **is** logged at notice level.
- **Consequence:** under any persistent failure (422, no-PAT, no network long enough), the pending queues self-empty within a few foreground events. The device autopsy should still read all five keys (Xcode → Devices → download container, or lldb `po UserDefaults.standard.dictionaryRepresentation()` filtered) — but a finding of empty queues is *expected under every failure hypothesis* and excludes nothing. `ledgeredLetters` is the one key whose contents are decisive (see A6).

### A3 — PAT presence — **BLOCKED** (installed build); resolution chain CONFIRMED

Chain, hop by hop: `Config.local.xcconfig` (gitignored; real token; example file `Config.local.example.xcconfig:5`) → optionally included by committed `Config.xcconfig:13` (`#include?` — absence doesn't break the build) → base configuration for both Debug and Release (`project.pbxproj:447,474`) → `Info.plist:54–55` maps `AIRTABLE_PAT = $(AIRTABLE_PAT)` → `AirtableService.pat` (:34–39) returns nil if the value is absent, empty, or the **literal unexpanded `"$(AIRTABLE_PAT)"`** (the no-local-file case).

- When PAT is nil: `sync()` logs `No PAT — local-only mode.` and returns; every `processX` returns false instantly (:699, :918, :1042, :1178). **The brief-embedded expectation "missing PAT = everything local-only, items queue forever" is half right:** everything is local-only, but queued items do NOT wait — flush passes bump failCount on the nil-PAT false exactly as on a network failure, and the item drops after its third flush. A no-PAT install leaves *empty* queues, not full ones.
- Xcode Cloud injection: `ci_scripts/ci_post_clone.sh` recreates `Config.local.xcconfig` from a **workflow secret env var `AIRTABLE_PAT`** (:23–25). **If the secret is unset the build succeeds anyway** and ships PAT-less local-first (:18–21 exits 0: "AIRTABLE_PAT not set — building in local-first mode."). A TestFlight build from a workflow missing the secret compiles green and never syncs — this is the leading candidate mechanism for the post-07-13 silence, given that TestFlight distribution began exactly then (build auto-increment #10 on 07-12; "Missing Compliance" cleared #24 on 07-13 22:10, *after* the last recognition row).
- Device must report: does `AIRTABLE_PAT` resolve in the installed build's Info.plist; which build number/channel the phone runs (see Capture Card items 3–4).

### A4 — The recognition pipe itself — **CONFIRMED** (answered; the fault does *not* isolate to `createActivityRow`)

**Do recent Recognition rows exist matching recent real usage? No — there is no recent usage evidence at all.** The isolation test the brief proposed is degenerate: nothing has landed in the Mandala table since 2026-07-13, so "recognitions landing while ledger rows are not" is false on both sides. The complete live Recognition record (15 rows, all Source="Today"):

| Felt At (UTC) | Śakti (KP) | Note |
|---|---|---|
| 2026-05-31 01:09 | Amṛtākarṣiṇī (43) | first row ever |
| 2026-06-01 13:05 | Śarīrākarṣiṇī (44) | **duplicate pair** — two rows, same Felt At, created 13:05:01 and 13:14:44 |
| 2026-06-01 19:00 | Kāmākarṣiṇī (29) | |
| 2026-06-04 02:12 | Ahaṅkārākarṣiṇī (31) | |
| 2026-06-04 22:35 | Śabdākarṣiṇī (32) | |
| 2026-06-05 23:09 | Sparśākarṣiṇī (33) | |
| 2026-06-06 19:00 | Rūpākarṣiṇī (34) | |
| 2026-06-11 03:35 | Dhairyākarṣiṇī (38) | |
| 2026-06-11 19:39 | Smṛtyākarṣiṇī (39) | |
| 2026-06-12 19:01 | Nāmākarṣiṇī (40) | |
| 2026-06-24 04:02 | Cittākarṣiṇī (37) | last first-felt ever |
| 2026-07-04 19:13 | Śabdākarṣiṇī (32) | **last row not attributable to the dev harness** |
| 2026-07-13 20:51 | Kāmākarṣiṇī (29) | inside the verification-harness window (see below) |
| 2026-07-13 21:25 | Kāmākarṣiṇī (29) | last row ever |

- The write path itself is intact and unchanged through the rebuild: `recordRecognition` introduced 0bd9542 (05-31); last material change 7fe8353 (07-07, added the wasFirst→ledger hook); after that `AirtableService.swift` was touched only by 718f5f6 (crossings queue), 3244f54 (comment), and 0409e11 (07-11 — removes the PendingSilence queue, hardens `restoreDescentIfLocalEmpty` date parsing, redacts two log lines; **the recognition write path untouched**). Nothing changed on 07-12/13; commit 464f6fa's ceremony rebuild preserved the `recordRecognition` call intact. **The stop correlates with the end of all development, not with any code change to the pipe.**
- Payload-vs-live-schema check: every field name in both writes (`Row Type`, `Of Shakti`, `Felt At`, `Lunar Day`, `Moon Phase`, `Source`, `Notes`; PATCH: `Last Felt`, `Recognition Count`; `Status` on deliberate advance) exists live; no 422 risk evident. The identical payload demonstrably landed 15 times through 07-13.
- Historical contrast that *would* have isolated the fault had attempts existed: the Crossing write (`createCrossingRow`, same by-name pattern, same base, Mandala table) succeeded live on 07-11 22:54 EDT while the App Activity path has zero rows — but per §reframe, the App Activity path has zero rows because it had zero eligible events, not because it fails.
- Two-phase write worth knowing for device forensics: the **local** record + `markRiteCompleted` fire at ceremony `onAppear` (`RecognitionMomentView.swift:255–262` — merely reaching the screen counts as the rite); the **Airtable** write fires only in `finishClose()` (:323–327). An exit that bypasses close leaves a local record with no Airtable row. `RECOGNIZE_AUTOCLOSE` (dee77ab) drives exactly that close in verification runs.

### A5 — wasFirst inventory — **CONFIRMED** (list produced; these 11 can never self-ledger)

Live Śaktis with `Recognition Count` > 0 — all Ring 2, counts sum 14 vs 15 rows (the Śarīrākarṣiṇī duplicate incremented once):

| KP | Śakti | Count | Status | First felt | Last Felt |
|---|---|---|---|---|---|
| 29 | Kāmākarṣiṇī | 3 | Active | 2026-06-01 | 2026-07-13 |
| 31 | Ahaṅkārākarṣiṇī | 1 | Active | 2026-06-04 | 2026-06-04 |
| 32 | Śabdākarṣiṇī | 2 | Active | 2026-06-04 | 2026-07-04 |
| 33 | Sparśākarṣiṇī | 1 | Active | 2026-06-05 | 2026-06-05 |
| 34 | Rūpākarṣiṇī | 1 | Active | 2026-06-06 | 2026-06-06 |
| 37 | Cittākarṣiṇī | 1 | Exploring | 2026-06-24 | 2026-06-24 |
| 38 | Dhairyākarṣiṇī | 1 | Exploring | 2026-06-11 | 2026-06-11 |
| 39 | Smṛtyākarṣiṇī | 1 | Exploring | 2026-06-11 | 2026-06-11 |
| 40 | Nāmākarṣiṇī | 1 | Active | 2026-06-12 | 2026-06-12 |
| 43 | Amṛtākarṣiṇī | 1 | Exploring | 2026-05-31 | 2026-05-31 |
| 44 | Śarīrākarṣiṇī | 1 | Exploring | 2026-06-01 | 2026-06-01 |

- Gate confirmed: `wasFirst = (previousCount == 0)` (`AirtableService.swift:716`), where previousCount is the **server-side** count GET-read just before the increment PATCH (:791–798, :820). Sole call site of `Shakti Recognized`. For all 11 above, every future recognition reads previousCount ≥ 1 → the ledger call is unreachable forever; no schema/PAT/queue fix changes that. Their "first felt" ledger rows can only exist by backfill — this table is the backfill source.
- Escape-hatch note, corrected: the decode is name-keyed with `?? 0` (:793, :798) — if the server's `Recognition Count` *values* were cleared (field name intact) the gate would re-fire once per Śakti. A *renamed* field would instead 422 the PATCH before the gate is ever reached (`patchShaktiAfterRecognition` is awaited at :702–706, throws on non-2xx :816–819, and the wasFirst check at :716 never runs) — the recognition write itself would start failing. Noted as behavior, not recommendation.
- Backfill nuance: if the 07-13 Kāmākarṣiṇī pair proves to be dev-harness writes, her true practice count is 1 (06-01), not 3.

### A6 — Letter dedup exposure — **PARTIAL** (Airtable + code halves done; device half BLOCKED)

- **Airtable half:** exactly **3** Shakti rows carry a non-empty `Letter`: **KP 29 Kāmākarṣiṇī, KP 39 Smṛtyākarṣiṇī, KP 44 Śarīrākarṣiṇī** — all Ring 2. (Presence only; text unread.)
- **Code half:** `ledgeredLetters` is a UserDefaults string array of Airtable Shakti *record ids* — append-only, never cleared, per-install (no App Group, no iCloud). The mark is written **before** the ledger write is awaited and stands regardless of outcome (:1029–1030, doc :1027) — so if an attempt ever fired and its queued item later hit the 3-strike drop, the milestone is both lost *and* permanently deduped on that install.
- **Reinstall exposure, quantified:** a reinstall wipes the set; all three letters are Ring-2 and re-seed locally from Airtable on sync (`seedLetterIfMissing`, :296–304, :313–319); the next *edit* of each (viewing never fires — `guard dirty`, `WellView.swift:257`) produces a fresh "Letter Written" row → **maximum 3 duplicate rows**, each dated by the edit, not the true first-letter date. The commit that shipped the ledger declared this itself (7fe8353: "a reinstall or second device could double-log one harmless duplicate row").
- **Mirror-image exposure on the current install, no reinstall needed:** if the three letters were last saved before the running build contained 7fe8353 (letters shipped 05-31; ledger 07-07), all three ids are unmarked today and each letter's next edit will produce a late "first letter" row with a wrong (current) date.
- **Device half (BLOCKED):** read `ledgeredLetters`. Marked ids = attempts were made (and, given zero live rows, died); unmarked = never attempted. This single read closes the last open branch of the ledger diagnosis.

**Not done, per the brief's law:** no field creation, no test write, no queue flush. Nothing in the base was modified.

---

## B · The 86 on device

### B1 — Per-ring Detail render — **BLOCKED** (device cache)

Requires the phone. What the code guarantees while walking it: the sync mapping assigns Devanagari, Iconography, Codex Portrait, Etymology, Appreciation Phrase, Function and serverRecognitionCount **unconditionally on every successful sync** (`AirtableService.swift:275–284`), so a blank section on device means that row has never been through a post-content sync on this install (or PAT is absent — the `:49–52` local-only guard). One asymmetry worth knowing during the walk: quality/qualityDescription/somaticPoetry/bija/bodilyLocation/tattva are guarded `if !v.isEmpty` (:255–266) and are never cleared, while the five straight-assigned fields above would be nulled by a server nil.

### B2 — lastSyncedAt / manual sync / 300-s loop — **BLOCKED** (device), with corrected instructions

- **The model does carry per-row freshness** — `Shakti.lastSyncedAt` (`Models/Shakti.swift:35–36`), stamped on every reconcile (`AirtableService.swift:306`; also :831, :848; equivalents on `Avarana` and `NityaDevi`). The device check should dump `lastSyncedAt` for any blank row directly, not infer freshness from logs.
- The 300-second foreground re-sync loop is real: `BinduMandalaApp.swift:104–114` (`task(id: scenePhase)`, `.active` only, 300-s sleep → `sync`); launch sync at `RootView.swift:109`. Log line to watch: `[Phase 1] sync starting…` (:54), then `[Phase 1] Shaktis fetched: N` (:495).
- Log caveat: the per-row dump logs the codex-portrait prefix with `privacy: .private` (:499–501) — it renders as `<private>` in Console unless private-data logging is profiled on. Names/devanagari are public. Use `lastSyncedAt` or lldb, not the portrait log line.

### B3 — Graceful-degradation guards — **CONFIRMED** (all three hold in code)

1. **No false "INNER INSTRUMENT" on the 86:** `hasCluster = (ring == 2)` gates every cluster surface — `ShaktiDetailView.swift:25` (label row :236–248, with the in-code comment "never the false 'INNER INSTRUMENT' the .inner default would print"), `RiteContent.swift:24–25` (nils cluster off-ring), `RiteBlockView.swift:42,:56` (dot + label), `LivingMandalaView.swift:405–410` (familyLabel appends cluster only if ring 2). No other view prints `Cluster.label` (grep-verified).
2. **Phonetic hidden when empty:** `ShaktiDetailView.swift:198`; `SignificanceCard.swift:16–19` (+ `if let` at :54); `RiteContent.swift:27–28` + `RiteBlockView.swift:79–88`. Spoken labels fall back to the name, never an empty string (:34–43).
3. **Somatic prompt replaced by her poem:** `RiteContent.swift:42–51` — somatic question → first line of her poetry → "Where do you feel her, right now?" (never blank); Detail hides the whole Somatic section when empty (`ShaktiDetailView.swift:418–430`). Same-spirit guards: bīja section hidden when empty (:446–453; `MandalaCanvasLayer.swift:277–281`).

---

## C · Build & test health

### C1 — Clean build — **BLOCKED** (no Xcode in this container: `which xcodebuild` / `which swift` both empty). Static facts extracted:

| Setting | Value | Where (project.pbxproj) |
|---|---|---|
| Created / last touched with | **Xcode 26.5** (`CreatedOnToolsVersion = 26.5` :189,193,196; `LastUpgradeCheck = 2650` :186; `compatibilityVersion "Xcode 16.0"` :202) | |
| objectVersion | 71 (filesystem-synchronized groups — requires modern Xcode) | :6 |
| SDK | `SDKROOT = iphoneos` — no pinned version; SDK = whatever the building Xcode ships | :380,438 |
| IPHONEOS_DEPLOYMENT_TARGET | **17.0 in all 8 configurations** (project + 3 targets × Debug/Release) | :292,311,375,434,458,484,505,523 |
| SWIFT_VERSION | 5.0 in all **6 target-level** configs (project-level configs don't set it) | :297,316,467,493,510,528 |
| Device family | iPhone-only (`TARGETED_DEVICE_FAMILY = 1`); portrait-only, dark UI style (Info.plist:41–48) | |
| Warnings config | `SWIFT_TREAT_WARNINGS_AS_ERRORS` absent; no strict-concurrency/upcoming-feature flags | grep: none |
| Signing | `CODE_SIGN_STYLE = Automatic` on all targets (:288 et al.); `DEVELOPMENT_TEAM VADN2G8B83` at project level and both test targets — the app target inherits it | :290,309,357,422,503,521 |
| Versions | `MARKETING_VERSION 0.1.0`; `CURRENT_PROJECT_VERSION 1` (6 occurrences; rewritten in CI, see C4) | :463; :289,308,452,479,502,520 |
| Dependencies | **Zero** — no SPM/CocoaPods/Carthage anywhere; 100 % first-party code | grep: none |
| Info.plist notables | `ITSAppUsesNonExemptEncryption=false` (:23–24); bare `UILaunchScreen` (:32–36); **`AIRTABLE_PAT = $(AIRTABLE_PAT)`** (:54–55); `UIAppFonts` = 2 Cormorant ttfs; no background modes, no notification usage-description keys (none needed for UNUserNotificationCenter) | |

Warning count/deprecations: BLOCKED — a Mac session must build and capture the list.

### C2 — Test suite — **BLOCKED** to run (app-hosted XCTest, `TEST_HOST` pbxproj:299); inventory CONFIRMED:

**14 unit-test files (65 test methods) + 1 UI-test file (2 methods).** (Brief §0 said "ten test files" — stale, in the codebase's favor.)

| File | Tests | Covers (its own header) |
|---|---|---|
| AtmosphereTests | 7 | atmosphere engine, reference numbers |
| DailyEnergyServiceTests | 8 | 6 am boundary + deterministic all-102 shuffle |
| DescentMirrorTests | 4 | Ruling 8: enter fires only on new-deepest; restore never regresses |
| ElementTests | 3 | per-ring table, tattva parse, never nil |
| KhadgamalaMapTests | 4 | kp → ring mapping |
| LunarPhaseServiceTests | 5 | offline lunar math |
| MandalaCameraTests | 9 | camera arithmetic |
| MandalaWorldTests | 7 | seat placement geometry |
| RecognitionMigratorTests | 3 | Phase-2 backfill |
| RiteCompositionTests | 5 | six archetypes, deterministic jitter |
| SchemaMigrationTests | 2 | versioned container round-trip |
| SeatLightingTests | 3 | no false `.inner` seat light (Ruling 7) |
| ShaktiStatusTests | 3 | advance-only status |
| TimeVariantModulationTests | 2 | time-of-day modulation regression |
| BinduMandalaUITests (UI) | 2 | Today→Detail; "I feel her"→Recognition→Portrait (`ENERGY_POS=29`) |

`AppRuntime.isUnitTesting` guards confirmed: defined `BinduMandalaApp.swift:9` (env `XCTestConfigurationFilePath`); consulted at :77 (scene-active flush/summons), :83 (notification auth), :108 (300-s loop), `RootView.swift:103` (bootstrap/sync). **Note:** the flag is set in the *unit-test* process only — an XCUITest-launched app performs real Airtable syncs/writes with whatever PAT the building Mac injected (see the 07-13 rows, §A4).

### C3 — Sizes & minimum-OS — **PARTIAL** (binary BLOCKED; static proxies captured)

- Asset catalog: **476 K** total — AppIcon 460 K (a single 459,607-byte PNG = 97 % of the catalog), AccentColor 8 K. No other assets.
- Fonts: **1.1 M** — CormorantGaramond-Light.ttf (665,964 B) + LightItalic (407,240 B); README.md excluded from the bundle via the membership-exception set (pbxproj:33–45).
- Source: app target **67 Swift files, 11,342 lines** (9,021 non-blank/non-comment): Views 36/7,138 · Data 4/1,716 · Services 7/1,386 · Models 9/535 · Theme 10/451. Tests 15 files/888 lines.
- Minimum-OS reality: **consistent** — 17.0 in all 8 configs, and **zero** `@available(iOS`/`#available(iOS` anywhere; nothing silently requires newer than 17.0.

### C4 — Xcode Cloud — **PARTIAL** (chain verified; last build status BLOCKED)

Chain: workflow **secret env var `AIRTABLE_PAT`** → `ci_post_clone.sh` writes it to `Config.local.xcconfig` (:23–25; value never echoed) → optional include → Info.plist → runtime. **Absent secret = successful PAT-less build** (deliberate: :10–12 "valid, non-failing build"). `ci_pre_xcodebuild.sh:33` stamps `CI_BUILD_NUMBER` over all 6 `CURRENT_PROJECT_VERSION` occurrences (BSD sed, valid on Cloud runners), keeping app + test targets in step. No post-build script exists. Last build status and the secret's presence are readable only at App Store Connect → Xcode Cloud (workflow → Environment → Variables) — capture card item 4.

---

## D · Full-history read

**Clone note:** already full history — 43 commits; `git fetch --unshallow` unnecessary, not run. `main` = `origin/main` = working branch = `522cdd3`; zero divergence; **zero commits from 2026-07-14 to today**.

### D1 — Timeline (complete; times as committed, UTC-04:00)

| # | Date | Hash | Subject | PR |
|---|---|---|---|---|
| 1 | 05-20 09:39 | 847bbaf | She breathes — full nine phases run on simulator. | — |
| 2 | 05-20 11:22 | 4df816d | Polish pass + app icon · ready for device. | — |
| 3 | 05-20 11:59 | 2c5ae7b | Fix: every petal opens its own Śakti. | — |
| 4 | 05-31 16:05 | 0bd9542 | All nine ring worlds — Sessions A through D + readability + dismiss | — |
| 5 | 06-01 11:18 | 58fc7a5 | Phase 1 (repairs) + Phase 2 (recognition migration) | — |
| 6 | 06-01 11:49 | 15a840b | Phase 3 — the Daily Rite (the heartbeat) | — |
| 7 | 06-01 12:03 | 9d3b3d7 | Phase 3.5 — design calls 2 through 5 | — |
| 8 | 06-01 12:11 | a4530d8 | Phase 4 — the Descent (the path) | — |
| 9 | 06-01 12:18 | 151b3e1 | Phase 5 — the Portrait (the artifact) | — |
| 10 | 06-01 12:24 | 90847bf | §9 stretches — exportable Portrait + descent film | — |
| 11 | 07-05 18:26 | 97727e3 | Morning greeting across all 102 · durability · open instrument · tests | — |
| 12 | 07-05 18:58 | d41b824 | Add Xcode Cloud post-clone hook to inject Airtable PAT | — |
| 13 | 07-07 15:53 | 7fe8353 | Write threshold crossings to the shared App Activity ledger | — |
| 14 | 07-11 16:24 | b306596 | PR-0 · Living Rite rebuild — kp-ordering audit + Airtable prep + reconciled brief | via #1 |
| 15 | 07-11 16:35 | 718f5f6 | PR-2 · Living Rite — durability foundation (versioned schema + descent mirror) | via #2 |
| 16 | 07-11 16:55 | 8129922 | PR-4 · Living Rite — the Atmosphere engine (per-Śakti palette + element + time) | via #3 |
| 17–19 | 07-11 21:01 | e59b327/312b45b/69e361a | Merge PRs #1, #2, #3 | #1–#3 |
| 20 | 07-11 21:04 | ed70d60 | PR-3 · Living Rite — correct the RecognitionEntry sync contract (Ruling 4) | via #4 |
| 21 | 07-11 21:05 | 561d068 | Merge PR #4 | #4 |
| 22 | 07-11 21:39 | d5fdeb6 | PR-5 · Living Rite — the Daily Rite becomes six element archetypes (Milestone A) | via #5 |
| 23 | 07-11 21:40 | 3689620 | Merge PR #5 | #5 |
| 24 | 07-11 21:59 | e671bb7 | Light the Field & Portrait from the Atmosphere engine (PR-6) | #6 |
| 25 | 07-11 22:16 | 16d12c3 | Degrade ShaktiDetailView for the 86 (PR-7) | #7 |
| 26 | 07-11 22:59 | 3244f54 | The living Mandala — one continuous semantic-zoom Śrī Yantra (PR-8) | #8 |
| 27 | 07-11 23:33 | 0409e11 | Security gate hardening — PR-9 findings (PASS-WITH-NOTES) | #9 |
| 28 | 07-12 00:27 | 8469843 | Auto-increment the TestFlight build number in Xcode Cloud | #10 |
| 29 | 07-12 02:30 | 707caec | Fix: the Daily Rite hid the menu — an oversized sigil pushed it off-screen | #11 |
| 30 | 07-12 11:07 | 6cf9dab | Tier 0 — correctness: responsive Rite, reachable Mandala controls, keyed bīja, restored Nityā prose | #12 |
| 31 | 07-12 11:39 | e1a600f | Tier 1 — the soul, part 1: atmosphere-lit Śakti Detail + shared depth/mote primitives | #13 |
| 32 | 07-12 11:47 | 464f6fa | Tier 1 — the soul, part 2: the Recognition ceremony's element-response layer | #14 |
| 33 | 07-12 12:07 | 75be342 | Tier 1 — the soul, part 3: the Field's felt dimension + atmosphere-lit Well | #15 |
| 34 | 07-12 12:29 | 8462462 | Tier 1 — the soul, part 4: shell transitions, same-day restore, contextual back-label | #16 |
| 35 | 07-12 12:52 | 27fe448 | Tier 2 — polish, part 1: Today's atmosphere + unified celestial strip | #17 |
| 36 | 07-12 20:42 | 3890e2f | Tier 2 — polish, part 2: Living Mandala tier labels/gestures + Portrait fly-out settle | #18 |
| 37 | 07-12 20:47 | acb14d6 | Tier 2 — polish, part 3: Avaraṇa data model + threshold gratitude/ordinal/count | #19 |
| 38 | 07-13 01:25 | da92f92 | Tier 2 — polish, part 4: Śakti Detail finish — dividers, bodily seat, bīja rings | #20 |
| 39 | 07-13 01:37 | 06d7697 | Tier 3 — process: legibility + tap-target sweep, fidelity checklist, stretch dispositions | #21 |
| 40 | 07-13 16:53 | dee77ab | Verification launch-args: open Threshold / Letter / Nityā, and auto-close Recognition | #22 |
| 41 | 07-13 21:49 | 87cdd06 | Add XCUITest target: tap-through verification of Today→Detail and →Recognition | #23 |
| 42 | 07-13 22:10 | ea46b12 | Declare non-exempt encryption compliance (clears TestFlight "Missing Compliance") | #24 |
| 43 | 07-13 22:48 | 522cdd3 | Fix: Portrait had no exit — clamp its glow so the hamburger stays on-screen | #25 |

PR-numbering quirks: no internal "PR-1" label exists (labels jump PR-0 → PR-2); GitHub #3 merged branch `living-rite/pr-4` while #4 merged `living-rite/pr-3` (crossed); from #6 on, labels and numbers align. All 28 non-merge July commits carry a Claude co-author trailer; the 5 GitHub merge commits carry none.

### D2 — The July rebuild sequence — **CONFIRMED**

Preflight 07-05/07-07 (97727e3 durability + open instrument; d41b824 CI PAT; 7fe8353 ledger). Rebuild 07-11 16:24 → 07-13 22:48 (30 commits): **b306596** lands `RECONCILED-BUILD-BRIEF.md` as canonical + the kp-ordering audit + Airtable prep (adds `Descent Ring`; "the `Crossing` Row-Type option is created on first write via typecast"); **718f5f6** durability foundation (BinduSchemaV1, `DescentState.enter(ring:)→Bool` "true only on a new deepest", recordCrossing); **8129922** Atmosphere engine; **ed70d60** rewrites the RecognitionEntry sync contract; **d5fdeb6** the six-archetype Rite ("Retired the .body/.bija variants, today_variant_raw, the body outline, the bīja background, and the nine-dot indicator"); **3244f54** cuts the nine ring-worlds and builds `LivingMandalaView` in one commit — **15 files deleted, 5,992 deletions** ("Replace the nine ring-worlds with a single continuous space you fall through… Deleted (folded into the Field's rows): MandalaScreenView, VeilView, the nine ring-worlds + RingWorldView + RingTwoWorldView, and the now-orphaned SriYantraMandalaView + TemporalMarkView"); **0409e11** security hardening over the whole rebuild diff. FIDELITY tiers: Tier 0 (#12) → Tier 1 ×4 (#13–16) → Tier 2 ×4 (#17–20) → Tier 3 (#21, which *creates* `iOS/FIDELITY.md`).

### D3 — When did Mauna/Silence die? — **CONFIRMED**

Two death commits, both 2026-07-11, quoted verbatim:

1. **Screen death — 3244f54 (22:59 EDT)** deletes `Views/Common/SilenceView.swift`: *"SilenceView retired — the silence-dwell write is replaced by the finale's explicit 'enter her presence' path; the `.silence` gesture case is kept for stored-entry compatibility."*
2. **Airtable-write death — 0409e11 (23:33 EDT)**: *"Remove the retired silence-write path (recordSilence + its UserDefaults retry queue), dead since SilenceView was replaced by the Bindu finale."* Removes `PendingSilence`/`recordSilence`/`processSilence`/`createSilenceRow`/`flushPendingSilences`.

Birth, for the record: the local `.silence` gesture write existed from the first commit (847bbaf, 05-20; `SilenceView.swift:178`); the Airtable Silence write shipped 0bd9542 (05-31). **Full life of Mauna in code: 2026-05-20 → 2026-07-11.** Two `.silence` enum cases survive at HEAD: `RecognitionEntry.Gesture.silence` (`Models/RecognitionEntry.swift:59` — the compatibility case) and `AirtableService.RecognitionSource.silence` (`:600` — the write-side Source select value); neither is ever written.

Correlation with live data: the 9 Silence rows end **2026-06-24 — seventeen days before the code death.** No commit between 06-24 and 07-11 touches the silence path (the repo has zero commits 06-02…07-04, and 97727e3's diff contains no silence changes) — **the 06-24 stop has no code explanation; it is usage- or device-side.** The code removal on 07-11 then made it permanent. The one Crossing row (07-11 22:54:33 EDT) was written five minutes *before* PR-8's commit landed, with the mirror capability shipped earlier that day (718f5f6, 16:35) — i.e., during the PR-8 verification evening ("Verified on device across cosmic / focus+constellation / Lalitā finale").

### D4 — History vs the RECONCILED brief and the skill — **CONFIRMED** (list, no judgment)

1. Skill says the `.silence` gesture was "deliberately unbuilt by choice." History: it **was** built and written by shipped code for ~7 weeks (847bbaf 05-20 → 3244f54 07-11); "defined but never written" became *true* at 3244f54 (deletion of its last writer) and was first *documented* at 06d7697 (07-13). The other two "unbuilt" items check out (no `import WidgetKit` ever; ring-drone noted optional).
2. Skill's Non-Negotiable #7 "Lunar cycle drives daily assignment" — superseded in shipped code since 97727e3 (07-05): `DailyEnergyService` deterministic all-102 shuffle, codified as Ruling 3.
3. Skill's unlock model ("tapping a locked ring… Enter this Avarana… 3rd–9th manual") — no unlock has existed in shipped code since 07-05; Ruling 2 made the open instrument permanent; acb14d6 reshaped the Threshold as a gratitude/info ceremony.
4. Skill says "three tiers of polish"; history shows **four** labeled tiers (0–3) across ten commits. (Also, the rebuild is now dated: 07-11 16:24 → 07-13 22:48.)
5. Brief §5 doc-hygiene never executed: `DESIGN_SPEC.md` and `Bindu Mandala - Final Handoff.md` are still byte-identical at HEAD ("delete one" never happened).
6. Brief §6 labels "Portrait (PR-9)"; in history PR-9 is security hardening; the Portrait's atmosphere landed as PR-6.
7. Brief §6 sequences the ceremony before the Mandala; in history the ceremony's element layer (#14) landed after the Mandala (#8). The §3.2 press-and-hold crossing is built at HEAD keyed on `Shakti.status` (no `EmbodimentState` type exists outside the brief's own text).
8. Brief §6 step 7 planned "delete the open-instrument dead code in VeilView"; history deleted VeilView entirely, one step earlier (inside PR-8).
9. Brief §6 lists "descent film" among future stretches; it had shipped six weeks earlier (90847bf, 06-01).
10. 7fe8353's message describes a working ledger ("Activity Type options are pre-created in Airtable") and its code comment claims "Values verified live via the Airtable schema" (`AirtableService.swift:1135–1136`) — against live data showing zero Mandala rows ever. Per §reframe, both statements can be literally true with zero rows: options pre-created, names verified, and no eligible event since. The comment is evidence of what the author believed about the schema on 07-07 — worth reconciling with Ashrey's memory of when the field was created.
11. Ruling-1 nuance (corrects an easy misreading): the Round-2 "Phase-1 ring-repairs" **were landed** on 06-01 (58fc7a5, five weeks before the ruling) and then thrown away with the whole ring-world layer on 07-11 — which is what the ruling's "(throwaway)" anticipated; they did not go straight from 0bd9542 to deletion.

---

## E · Rulings drift check

Rulings 1–8 extracted verbatim from `Claude Design Round 2/RECONCILED-BUILD-BRIEF.md:24–31`.

| Ruling | Verdict | Evidence (spot) |
|---|---|---|
| 1 — semantic-zoom Mandala replaces nine worlds | **CONFIRMED** | 3244f54 (15 files deleted, −5,992 lines); `RootView.swift:55–56` sole `.mandala` host; zero `RingWorld` identifiers anywhere; rings survive as the Field's rows (`TheHundredTwoView.swift:4–8`) |
| 2 — open instrument permanent; Veil machinery deleted | **CONFIRMED** | `VeilView`/`VeilState`/`holdToCross`/`.threshold`/`.becoming`/`.unseen`: **zero matches** tree-wide (pre-deletion enum verified at `git show 3244f54^` VeilView.swift:257–261); `DescentState` has no gating API; every surviving "threshold" occurrence audited: Avaraṇa info screen, embodiment readiness thresholds `[1,3,7]`, first-felt ledger comments, camera zoom tiers, plus two benign doc residues (`DescentState.swift:10–11` "the Veil always offers them as open rows"; `RingGlyph.swift:5` "unused in the Veil") — prose only, no machinery |
| 3 — DailyEnergyService canonical; nothing reads todayPetalIndex for today | **CONFIRMED** | `todayPetalIndex` (`LunarPhaseService.swift:32`) has exactly one caller — its own wrapper `todayPosition` (:38) — which has **zero call sites**; both are dead code. Every today-selection reads `DailyEnergyService.todaysPosition()` (DailyRiteView:32, LivingMandalaView:46, WellView:28, TheHundredTwoView:124, DailySummons:134). Legitimate non-today lunar survivors: `currentTimeVariant` (9 sites/7 files), moon strip, Lunar Day/Moon Phase stamps on Recognition rows (:648–649), paksha labels, and the Nityā-of-the-tithi selection (`DailyRiteView.swift:289–301` — selects the presiding Nityā from the 15, not today's Śakti) |
| 4 — sync + ledger governs; "never synced" rewritten; serverRecognitionCount readiness | **PARTIAL** | Code honors all clauses: recordRecognition (:635–726), wasFirst ledger (:716–724), letter ledger (:1028–1038), `serverRecognitionCount` drives readiness (ShaktiDetailView:387; LivingMandalaView:372; TheHundredTwoView:146); RecognitionEntry header rewritten by ed70d60 ("Private-facing, not surveilled (Ruling 4)"). PARTIAL because (a) in *practice* the ledger arm has never governed — zero rows, for the no-eligible-event reason in §A, and the sync arm shows nothing since 07-13; (b) residue: `ShaktiLetter.swift:4` still says "Local-only, never synced" (= F2) |
| 5 — six archetypes; variants retired | **CONFIRMED** | `RiteComposition.forElement` — exactly six branches (ascension/descent/horizon/veil/foundation/radiance) over one `RiteContent` model; `today_variant`/`todayVariant`: zero matches; the `Variant{body,bija}` enum removed in d5fdeb6 (the one surviving `case bija` is an Airtable CodingKeys field-ID mapping, `AirtableService.swift:154`, unrelated) |
| 6 — element source per-ring table | **CONFIRMED** | `Element.forRing` (`Theme/Element.swift:14–24`) byte-matches the ruled map; Ring 2 from tattva parse with `.ether` terminal fallback (never nil/blank); computed property, no migration; kp-seeded jitter keeps sisters distinct (`RiteComposition.swift:63–79`) |
| 7 — 86 graceful degradation | **CONFIRMED** | Code half at every named point (see B3); the "author real content later" clause is satisfied per the brief's own §0 ground truth ("Chat verified the data is complete in Airtable for all 102"); on-device rendering is B1's question, not a drift question |
| 8 — DescentState mirror, once per new-deepest | **CONFIRMED** | `enter(ring:)` returns true only on strict `ring > deepestReached` (`DescentState.swift:41–54`); sole UI wrapper gates the write (`LivingMandalaView.swift:346–351`); durable (pendingCrossings) + restorable (`restoreDescentIfLocalEmpty`, floor 2, never regresses); `DescentMirrorTests` covers it. The **single live Crossing row (Descent Ring 9)** is *exactly* what this design produces: bootstrap floor is 2 (`ShaktiBootstrap.swift:298`), the first descent jumped 2→9 in one `enter()` (one row, rings 3–8 never individually mirrored), and 9 being maximal, no further row can ever fire. Cosmetic drift: the comment at `AirtableService.swift:907–908` says "fires once per ring" — the true contract is once per new-deepest |

---

## F · Repair-list verification

**F1 — ShaktiLetter is Ring-2-only — CONFIRMED.** `@Attribute(.unique) var shaktiPosition: Int` (`Models/ShaktiLetter.swift:8`; doc :5 "1–16"). Note: there is **no numeric 1–16 range check on letters anywhere** — the restriction is structural (docs, WellView's Ring-2 filter, the sync seed gate). Every site keying letters by per-ring position (repair scope), complete:

| # | Site | Role |
|---|---|---|
| 1 | `Models/ShaktiLetter.swift:8,12–13` | the unique key itself |
| 2 | `Services/RecognitionLogStore.swift:60–63` | `LetterStore.letter(for:)` fetch + insert |
| 3 | `Data/AirtableService.swift:296–304` | sync restore, gated `if ring == 2,` (:300) |
| 4 | `Data/AirtableService.swift:313–318` | `seedLetterIfMissing` predicate + insert |
| 5 | `Views/Common/WellView.swift:14–17` | `ring2Shaktis` roster filter |
| 6 | `WellView.swift:21–23` | `lettersByPosition` dict (defensively deduped) |
| 7 | `WellView.swift:100` | row preview lookup |
| 8 | `WellView.swift:240` | editor load |
| 9 | `WellView.swift:260–262` | editor save |
| 10 | `Bindu MandalaTests/SchemaMigrationTests.swift:28` | test fixture |
| 11 | `WellView.swift:73–76` | **debug** `OPEN_LETTER=<pos>` launch arg resolves per-ring position within Ring 2 |

Extension facts: per-ring 1–16 collides across rings (Ring-2 kp = position + 28, `RecognitionMigrator.swift:14`); re-keying the unique attribute is not an additive defaulted change, so it falls under `BinduSchema.swift:10–14`'s explicit V2 + MigrationStage clause (`ShaktiLetter` registered in V1 at :23); recognitions have a migration precedent (`RecognitionMigrator`), letters have none. Airtable-side letter writes are unaffected (keyed by record id).

**F2 — Stale headers — CONFIRMED.** `ShaktiLetter.swift:4` — "A private letter to one of the 16 Śaktis. Local-only, never synced, never read by anyone." — contradicted three ways (PATCHed up via `saveLetter` :1012 from WellView:269; restored down on sync :296–303; first-letter ledgered :1023–1037). `Shakti.swift:4` — "One of the 16 Karṣiṇī Śaktis of the 2nd Avaraṇa." — model holds all 102 (`khadgamalaPosition`, `ringNumber` in the same file). The Airtable corroboration (3 letters live) is from this audit's own read.

**F3 — `.silence` defined, never written — CONFIRMED.** `RecognitionEntry.Gesture.silence` (`Models/RecognitionEntry.swift:57–60`). No write site: the only `gesture:` arguments anywhere are `.felt`. The two `.felt` record sites: (1) `Views/Recognition/RecognitionMomentView.swift:255–259` (the live ceremony); (2) `Data/AirtableService.swift:364–369` (`restoreRecognitionsIfLocalEmpty`). Also never fired: the *remote* Source value `RecognitionSource.silence = "Silence"` (`AirtableService.swift:597–600` — the write-side Source select enum; only `.today` and `.mandala` are ever passed). FIDELITY.md:62–65 documents the dormancy verbatim.

**F4 — Bīja voice + sine fallthrough; no voice files — CONFIRMED.** The "preference" is code-level prefer-bundled-voice (no user setting exists): `BijaSoundService.swift:28` and `:106` try `playVoiceFile` first (`bija_%02d`.mp3/m4a/wav, :41–42), falling through to synthesized sine (:30–35, :63–96) or hashed pentatonic drone (:107–153); comment :25–27 "the gesture is never silent." No voice files: repo-wide find across 9 audio extensions = **zero files**; Assets holds only AppIcon + AccentColor; Fonts only the two ttfs. (Because the targets are filesystem-synchronized, the bundle mirrors these folders — the file-search is the conclusive proof, and it is conclusive.)

**F5 — Reduce-motion — CONFIRMED.** `@Environment(\.accessibilityReduceMotion)` gates in exactly **13 files** (14 declaration sites; RootView declares twice): RecognitionMomentView, RootView, DustMotesView, ShaktiDetailView, AvaranaThresholdView, HomecomingView, TheHundredTwoView, RingPositionIndicatorView (dead view), DailyRiteView, LivingMandalaView, LalitaSourceView, DescentFilmView, PortraitMandalaView. `TimelineView` appears in exactly **2 files / 3 sites** — `MandalaCanvasLayer.swift:30`, `LalitaSourceView.swift:37,:59` — all three in the exact `TimelineView(.animation(paused: reduceMotion))` form FIDELITY rule 3 prescribes (MandalaCanvasLayer receives the flag from LivingMandalaView's gated environment read; LalitaSourceView additionally zeroes rotation/breath under the flag). Both inside gated paths: **honored**.

**F6 — Today bīja footer, full unparsed field — CONFIRMED.** `Views/Today/DailyRiteView.swift:259–262`:
```swift
Text("\(content.kp) of 102" + (content.bija.map { " · bīja \($0)" } ?? ""))
    .font(.system(size: 11)).tracking(1.6)
    .foregroundStyle(Color.cream.opacity(0.44))
```
`content.bija` is only whitespace-trimmed (`RiteContent.swift:29–30`); for Type-2 values ("Kaṃ — governs K-row…", documented at `ShaktiDetailView.swift:432–436`) the footer renders the whole field. The syllable-only parse already exists twice elsewhere (`RecognitionMomentView.swift:40–42`; `ShaktiDetailView.swift:437–444`). Ruling reserved for Ashrey at repair, as briefed.

**F7 — Zero `print(`, zero TODO/FIXME — CONFIRMED.** On tip `522cdd3`: zero `print(`/`debugPrint` in any file under `iOS/` (all logging is `os.Logger`); zero TODO/FIXME/HACK/XXX in any non-.md file. Chat's finding reproduces exactly on full history's tip.

---

## G · Homes-readiness facts (facts only; no design choices)

**G1 — Rendering inventory — CONFIRMED.** Everything is pure SwiftUI drawing; **no GPU-framework escape hatch exists**: zero imports of SpriteKit/SceneKit/Metal/MetalKit/RealityKit (full app-target import census: SwiftUI, SwiftData, Foundation, AVFoundation, UIKit, CoreGraphics, UserNotifications, os); zero SwiftUI shaders (`.colorEffect`/`.distortionEffect`/`.layerEffect`/`ShaderLibrary`); zero `.metal`/`.sks`/`.scn` files; zero `drawingGroup()`; zero CAEmitter/SKEmitter/CADisplayLink. `Canvas`: 18 call sites in 9 files — the big one is `MandalaCanvasLayer.swift:32` (the entire living field in ONE Canvas per frame: starfield, 9 enclosures, yantra triangles, constellation threads, 102 seats, names, bindu glow), plus LalitaSourceView, RingGlyph, AvaranaThresholdView (8 static ring geometries at 0.045 opacity), PortraitMandalaView ×3, RiteSigil (drawn once, spun by `.rotationEffect` repeatForever), DepthOverlay (`rendersAsynchronously: true` film grain), BodyOutlineView (dead), DismissArc (dead). `TimelineView`: the 3 gated sites (F5). Particles: `DustMotesView` only — one blurred Circle per mote, repeatForever, element-directed; hosts pass 6–16 motes; **gates reduce-motion in-file** (`:14` environment read; `:97` guard pins phase and never starts the loop — the sole residue is that toggling reduce-motion *mid-session* does not stop an already-running loop). One UIKit interop point exists (not rendering): `SwipeBackEnabler.swift:11`, a `UIViewControllerRepresentable` gesture bridge. Device carrying capacity (iPhone model) is BLOCKED — G5.

**G2 — ShaktiDetailView census — CONFIRMED.** 898 lines. Render order: atmosphereLayer (AtmosphereBackground + counter-rotating RiteSigil + DustMotes(10) + DepthOverlay, :93–107) → navBar (:141) → heroSection (:170: kicker→name→devanagari→phonetic→quality→cluster chip) → codexPortraitSection (:620, unlabeled — "the soul of the screen") → somaticSection (:419) → bijaSection (:448, tap-to-hear + 3 resonance rings) → appreciationPhraseSection (:579) → embodimentSection (:270, long-press crossing → `advanceStatus`, thresholds 1/3/7 from `serverRecognitionCount` :386–397) → fieldConnectionSection (:540, conditional) → herMomentsSection (:567; local `RecognitionLogStore` shown immediately, `fetchRecognitions` becomes authoritative) → goDeeperSection fold (:685: iconography, lineage, cosmic function, tattva, bodily seat, etymology) → recognitionFooter ("I feel her") → fullScreenCover → RecognitionMomentView(source: .mandala). State coupling a top-replacement must preserve: `@Bindable shakti`, `backLabel`, modelContext/dismiss/reduceMotion environments, 7 `@State`s, service calls (advanceStatus :405, fetchRecognitions :881, playBija :501, Haptics ×5), nav chrome (`.navigationBarBackButtonHidden`, `.toolbar(.hidden)`, `.enableSwipeBack()`), and the cross-screen chain: the covered ceremony posts `didSettleNotification` (:331) which RootView observes (:94–101) to land on `.memory`. Presented from 3 hosts (Field push, Mandala cover, Rite cover).

**G3 — RingAudioService surface — CONFIRMED.** 607 lines, `@MainActor final class`, singleton, **not** ObservableObject, zero published properties. Callable surface: `groundDroneStart/Stop` (Ring 1), `homeBreathStart/Gain/Stop` (Ring 2), `sustainedVoiceStart/Gain/Stop` (Rings 3/6), `playSteppedNote` (Rings 4/5 — delegates to BijaSoundService), `ringChime(_:)`, `R8Target` + `r8Start/Set/Stop` (Ring 8 triad), `shepardStart/Set/Stop` (Ring 9), `stopAll`. Attach-point facts: the `AVAudioEngine` and every voice slot are `private` (file-scoped — an extension in another file cannot reach them); the internal `ContinuousVoice`/`TriadVoice`/`ShepardVoice` classes accept *any* engine in their inits (:279, :419, :524), and the session is `.playback` + `.mixWithOthers` (:35), so a parallel engine coexists at session level. **Live usage today: exactly one call site in the whole codebase** — `ringChime` from `LivingMandalaView.swift:338`, opt-in via `soundOn`. The nine ring techniques are defined and dormant (zero callers), and `stopAll` — documented "used on app background" — has zero call sites.

**G4 — AvaranaThresholdView wiring — CONFIRMED.** 516 lines. Reachable from exactly one production path: hamburger → the Field (`RootView.swift:62`) → ring accordion open → "the threshold ›" (`TheHundredTwoView.swift:256–263`) → `navigationDestination` push (:32–34); plus debug `OPEN_THRESHOLD=<ring>`. **Not** reachable from LivingMandalaView, the Rite, or Detail. Reads one `Avarana` model read-only + reduceMotion; writes nothing but its own reveal `@State`s; no service calls, no audio, no haptics; exit is the system back/edge-swipe. Coexistence-relevant facts (no design choice made): it is fully decoupled from the Mandala's descent machinery (which is an in-place overlay inside LivingMandalaView), holds no model state, and nothing else references it — a rite-as-travel layer would touch its one presentation site and nothing inside it. Stale doc: its header (:8–10) claims sheet presentation with `presentationDetents` — the shipped wiring is a push.

**G5 — Performance baseline + device model — BLOCKED.** Requires the phone: FPS during deep zoom and the Bindu→Lalitā descent (Instruments/Xcode gauge), memory at rest and deepest zoom, thermal state over a 10-minute session, cold-launch time, and the iPhone model identifier. Capture card item 7.

---

## H · Felt experience, UX & accessibility

**H1 — FIDELITY 8-point per-screen pass — PARTIAL** (component census done; the on-device judgment pass is BLOCKED — FIDELITY rule 7 wants Pro-Max + small-device screenshots). Atmosphere-component census per screen:

| Screen | AtmosphereBackground | RiteSigil | DustMotes | DepthOverlay | reduce-motion |
|---|---|---|---|---|---|
| DailyRiteView (Rite) | ✓ | ✓ | ✓ | ✓ | ✓ |
| ShaktiDetailView (Detail) | ✓ | ✓ | ✓ | ✓ | ✓ |
| LivingMandalaView (Mandala) | — (own canvas + day-glow gradient) | — | — | — | ✓ |
| RecognitionMomentView | — (own two-gradient focal atmosphere) | ✓ | ✓ | — | ✓ |
| TheHundredTwoView (Field) | — | ✓×2 | — | — | ✓ |
| PortraitMandalaView (Portrait) | — (clamped ambient glow) | — | ✓ | — | ✓ |
| WellView (Well) | — (bespoke RadialGradient :42–44) | — | — | — | n/a (no animations) |
| AvaranaThresholdView | — (ring watermark 0.045) | — | — | — | ✓ |
| HomecomingView | — (silenceGround + vignette) | — | — | — | ✓ |
| SettingsView | — | — | — | — | n/a |

DepthOverlay exists only on Rite and Detail; Well and Settings are the flattest screens in code. Whether each bespoke atmosphere *feels* right is the device pass.

**H2 — Readability sweep — CONFIRMED** (sweep complete: all 36 Views + 10 Theme files). **31 live sites fall below FIDELITY rule-4 thresholds** (F = fails, m = marginal 10–10.5 pt / 0.42–0.48 α); the failures table, same shape as the old UX audit:

| file:line | element | value | verdict |
|---|---|---|---|
| Mandala/LivingMandalaView.swift:127–128 | tier hint — the only navigation instruction | 9.5 pt · cream 0.42 | F size+alpha |
| Mandala/MandalaCanvasLayer.swift:99–101 | ring ordinal·form labels | 9 pt · gold 0.6 | F size |
| Mandala/MandalaCanvasLayer.swift:272–273 | seat name labels | 10 pt · 0.85 lit / 0.42 unlit | F size; F alpha unlit |
| Mandala/MandalaCanvasLayer.swift:285 | "bīja X" deep-zoom | 8 pt | F size |
| Mandala/LalitaSourceView.swift:78 | "NINTH ĀVARAṆA · THE BINDU" | 10.5 pt | m size |
| Mandala/LalitaSourceView.swift:138 | "SOUND THE SOURCE" | 10 pt · 0.5 | F size |
| Mandala/SignificanceCard.swift:36 | family label | 9.5 pt | F size |
| Mandala/SignificanceCard.swift:56–57 | phonetic | 10 pt · 0.5 | F size |
| Mandala/SignificanceCard.swift:82–83 | "SOUND HER" | 10 pt · 0.42 | F size+alpha |
| Today/NityaDetailView.swift:38–40 | tithi label | 10 pt · gold 0.7 | F size |
| Today/DailyRiteView.swift:259–262 | kp·bīja footer | 11 pt · 0.44 | F alpha |
| Common/WellView.swift:88–91 | header instruction | 10 pt · 0.5 | F size |
| Common/WellView.swift:120–122 | empty-state invitation | 14 pt · 0.32 | F alpha |
| Common/WellView.swift:168–170 | letter-editor placeholder | 19 pt · 0.28 | F alpha |
| Common/SettingsView.swift:174–177 | section titles | 10 pt · gold 0.85 | F size |
| Common/SettingsView.swift:255 | rename placeholder | 18 pt · 0.45 | m alpha |
| Common/TheHundredTwoView.swift:106–108 | "NINE RINGS · ONE HUNDRED AND TWO" | 10.5 pt · 0.45 | m size+alpha |
| Common/TheHundredTwoView.swift:215–218 | ring seat count | 10.5 pt | m size |
| Common/TheHundredTwoView.swift:244–247 | enclosure-form caption | 10 pt | F size |
| Common/TheHundredTwoView.swift:316–319 | felt-count (has a11y label) | 10.5 pt | m size |
| Common/HomecomingView.swift:49–52 | "TAP TO ENTER" exit hint | 10 pt · 0.40 | F size+alpha (intentional ghost-hint) |
| Common/AvaranaThresholdView.swift:68–71 | āvaraṇa kicker | 10.5 pt · 0.75 | m size |
| Common/ShaktiDetailView.swift:157–160 | "kp · 102" | 11 pt · 0.45 | m alpha |
| Common/ShaktiDetailView.swift:200–204 | hero phonetic | 12 pt · 0.48 | m alpha |
| Common/ShaktiDetailView.swift:321–324,411 | status pill (.mapped) | 10.5 pt · 0.35 | F size; F alpha |
| Common/ShaktiDetailView.swift:330–331 | "she lives in you" | 13 pt · 0.42 | F alpha |
| Common/ShaktiDetailView.swift:339–342,283 | crossing-pill label | 10.5 pt · 0.4 @level 0 | F size (+alpha) |
| Common/ShaktiDetailView.swift:480–483 | "TAP TO SOUND HER" | 10 pt · 0.4 idle | F size+alpha |
| Common/ShaktiDetailView.swift:748–751 | Detail section titles | 10.5 pt · 0.55 | m size |
| Recognition/RecognitionMomentView.swift:235–238 | "TAP ANYWHERE TO CLOSE" exit hint | 10 pt · 0.40 | F size+alpha (intentional ghost-hint) |
| Memory/PortraitMandalaView.swift:120–123 | "she is felt, not measured" whisper | 13 pt · 0.40 | m alpha (borderline decorative) |

Judged exempt as decorative ghosts (FIDELITY's own exemption): threshold ring geometry at 0.045, the 300 pt ghost bīja, the Rite's giant veil name (accentFaint 0.24 — though it is also the tap target), chevrons, sigils/canvas strokes/motes/hairlines. Dead-code sub-threshold text (never rendered): ClusterDotView:14, RingSoundDot:29–31.

**H3 — Dead-end check — CONFIRMED (no dead ends at HEAD).** Per takeover screen: RecognitionMomentView — tap-anywhere close (:79–85); the `guard nameVisible` gate is set synchronously in `stage()` (reduce-motion path immediate), so exit is live from the first frame; the recognition is logged at onAppear so an early exit loses nothing. HomecomingView — ungated tap-anywhere (:57–58); hint fades in at 7 s but the tap works from frame 1. AvaranaThresholdView — system back + edge-swipe (nav bar never hidden). Descent (LivingMandalaView→LalitaSourceView overlay) — "enter her presence" (54 pt) and "↑ return to the field" buttons; visually they emerge at ~1.5 s but opacity doesn't gate hit-testing; the hamburger sits above the overlay in RootView's outer ZStack and stays reachable. DescentFilmView — explicit CLOSE + tap-to-advance. ShaktiDetailView as cover — custom back button (minHeight 44) always present (edge-swipe inert inside a cover by UIKit design; restored as a push). Portrait — the 522cdd3 class-of-bug is fixed and holds: the 600×540 glow is inside `Color.clear.overlay` (`PortraitMandalaView.swift:83–93`, with an in-code warning comment); **no *unclamped* fixed frame ≥ 420 pt survives anywhere in Views** (the only ≥ 420 pt fixed frame *is* the clamped glow; the other fixed frames are 172 and 300 pt). Caveat for the device pass: both barely-there exit hints are themselves H2 failures — the surface saves the settled eye, the hint does not.

**H4 — Touch targets — CONFIRMED (sweep complete; 8 violations).** All 28 Button sites + every tap/long-press gesture inspected, plus two verifier-caught non-Button interactives:

| file:line | element | est. hit size |
|---|---|---|
| Mandala/LalitaSourceView.swift:161–171 | "↑ return to the field" — an exit affordance | ≈19 pt tall (worst; bare Text, padding outside the label) |
| Common/ShaktiDetailView.swift:339–370 | embodiment crossing pill (hold-to-cross) | ≈25–27 pt |
| Common/TheHundredTwoView.swift:256–263 | "the threshold ›" | ≈37 pt |
| Memory/DescentFilmView.swift:61–68 | "CLOSE" | ≈37 pt |
| Today/DailyRiteView.swift:170–189 | celestial strip (Nityā opener) | ≈38 pt |
| Memory/PortraitMandalaView.swift:586–595 | export ShareLink "hold this image" | ≈41 pt |
| Common/SettingsView.swift:246–261 | rename TextField | ≈42 pt |
| Today/Rite/RiteBlockView.swift:91–99 | "know her ›" | ≈42 pt (borderline) |

Compliant with credit: the 44×44 close ×, Detail back/go-deeper/bīja (118 pt), Well back/rows (~70 pt), Portrait close, hamburger + menu items (minHeight 44), Mandala controls (46×46), canvas seat taps (34 pt-radius nearest-seat = 68 pt effective), Field seat rows (~45 pt) and ring headers (48 pt), both "I feel her" buttons (60/56 pt).

**H5 — Accessibility — PARTIAL** (device VoiceOver walk BLOCKED; static census done). **11** `accessibilityLabel` sites (MoonPhaseView:17; DailyRiteView:158,257; RiteBlockView:76; TheHundredTwoView:309,319; ShaktiDetailView:136,189,311,371,477), 2 `accessibilityHidden`, 2 `accessibilityElement`, 2 `.isButton` traits. Phonetic-first spoken names are wired wherever labels exist (`RiteContent.spokenName`, Detail's `headerSpokenLabel`, Field rows) — but for the 86 (no phonetic) every one falls back to the raw diacritized Sanskrit, and the Devanagari renders as raw unlabeled `Text` at `ShaktiDetailView:191–195` — the old check-26 concern is statically present there. **Gaps (zero accessibility modifiers in-file):** SignificanceCard, LivingMandalaView + MandalaCanvasLayer (the entire canvas Mandala exposes no accessibility elements — the 102 seats are invisible to VoiceOver), RecognitionMomentView (tap-anywhere exit unlabeled), HomecomingView, AvaranaThresholdView, NityaDetailView, WellView rows, LalitaSourceView. **Dynamic Type: none at all** — 152 fixed-size font sites in Views (57 `.system(size:)` + 95 `.custom`; 155 app-wide), zero text styles, zero `relativeTo:`. **Reduce-motion:** 13 gating files (F5); all 9 repeatForever loops gated; both TimelineViews paused; only ungated animations are HamburgerMenuView's three one-shot 0.3 s eases (permitted by rule 3).

**H6 — The ceremony, felt — BLOCKED** (requires Ashrey's hand and eye). Static facts the felt session should carry in: the shipped staging is act 1 "she was felt here" fading in at **2.6 s** (`RecognitionMomentView.swift:279`), act 2 "and she felt you back" at **4.1 s** (:284 — ~1.5 s after act 1 appears, via an explicit comment rejecting a pre-computed act1+3 s offset; only the *displayed timestamp fallback* is act1Time+3 s, :220), note card at **5.1 s** (:291); act 2 renders italic in `atmo.accentBright` — gold-family, per-element, not literal `Color.gold`. **The brief's own script ("+3 s, italic gold") does not match shipped code — reconcile the expectation before judging the feel.** The note prompt cannot dismiss the moment: the NoteCard swallows its own taps (:376–378) and the close is a separate tap-anywhere.

**H7 — Sound & haptics in the hand — BLOCKED** (in-hand verification). Static census for the session: **29 `Haptics.*` call sites** across Views; sound surfaces are exactly: bīja taps (`ShaktiDetailView:501`, `LalitaSourceView:128`, `LivingMandalaView:151`), the opt-in ring chime (`LivingMandalaView:338`, toggle :162), and nothing else live — the nine per-ring techniques are dormant (G3), and the summons is alert-only, no sound (`DailySummons.swift:53–56`). Known quiet-breakers to listen for: none statically evident; `stopAll` never runs on background (G3 note) but no continuous voice currently ever starts.

**H8 — The summons — PARTIAL** (code intent CONFIRMED; delivery observation BLOCKED). Scheduling: one non-repeating `UNCalendarNotificationTrigger` per day for a rolling 14-day window at the chosen hour (default 6; `DailySummons.swift:104–147`), ids `summons.Y-M-D`. Correctly named: title = the presiding Śakti's name, body = her quality, keyed by `DailyEnergyService.todaysPosition(for:)` per future morning (primed pre- and post-sync from RootView:108–128; fallback "She is waiting."). Once: every reschedule first removes all pending `summons.` requests (:105–107); deterministic per-day ids make double-adds replace. Dropped when the rite is done: `markRiteCompleted` fires on every recognition (`RecognitionMomentView:262`) and the reschedule skips today (:128); re-evaluated on foreground and launch. Nuance for the observation: no `removeDeliveredNotifications` call exists — a summons that already fired before the rite stays in Notification Center; only pending ones drop. Device: observe over the window or dump `pendingNotificationRequests`.

---

## Also observed

One line each; no fixes proposed.

1. **The Mandala's sound preference is written but never read back** — `soundOn` starts `false` and persists to UserDefaults `"lr_sound"` (`LivingMandalaView.swift:26,324`) without ever restoring it; the ♪ choice resets every session.
2. All 15 live Recognition rows are Source="Today"; the Detail ceremony has passed `source: .mandala` since 97727e3 (`ShaktiDetailView.swift:86`) — no Detail-screen recognition has ever landed in Airtable.
3. The 06-01 Śarīrākarṣiṇī duplicate pair (same Felt At, created 9 min apart, count +1 once) shows the recognition path had no server-side dedup; letters got a dedup design, recognitions never did.
4. The recognition is a two-phase write: local record + rite-completion at ceremony *appear*; Airtable write only at *close* — reaching the screen counts as the rite even on an instant back-out.
5. `flushPendingActivities` and `flushPendingCrossings` lack the drained/still-pending summary logs their recognition/letter siblings emit.
6. `Activity Date` is formatted `yyyy-MM-dd` with no pinned timeZone (`AirtableService.swift:1189–1192`) — ledger dates are device-local days; relevant to backfill reconciliation.
7. The raw Airtable PAT ships in plaintext in the app bundle's Info.plist (`:54–55`) — extractable from any distributed IPA.
8. `RingAudioService.stopAll()` is documented "used on app background" but has zero call sites; `TriadVoice.glide(to:tau:)` ignores its `tau` (both noted in G3's file).
9. Eight view types are dead code with zero instantiations: ClusterDotView, RingPositionIndicatorView, BodyOutlineView, DismissArc, RingSoundDot, RingTriangle, PetalShape, GhostPetalShape; `RingAudioService.swift:12` still references the nonexistent RingSoundDot toggle.
10. Dead lunar pair retained: `todayPetalIndex`/`todayPosition` (zero call sites; Ruling 3 residue).
11. Stale doc residues beyond F2: `AvaranaThresholdView.swift:8–10` (claims sheet presentation; it's a push), `DescentState.swift:10–11` ("the Veil always offers them as open rows"), `RingGlyph.swift:5` ("unused in the Veil"), `AirtableService.swift:907–908` ("fires once per ring" vs once-per-new-deepest), `BijaSoundService.swift:25` (16-wide sample naming vs 102-wide seeds at :104–106).
12. `WellView.swift:22–23` defensively dedupes letter rows (`uniquingKeysWith`) — an acknowledgment the per-ring key can in principle collide.
13. `RiteSigil.swift:13` takes `reduceMotion: Bool = false` as a defaulted parameter rather than reading the environment — all current callers pass the gated value; the default is motion-on.
14. Hamburger order oddity: Settings sits between The Field and The Memory (`HamburgerMenuView.swift:33–43`).
15. The 86's names in the Mandala are the least reachable text in the app — 10 pt at cream 0.42 unlit *and* invisible to VoiceOver (canvas has no accessibility elements).
16. AppIcon is a single 460 KB PNG = 97 % of the asset catalog.
17. The App Activity table has evolved well beyond the June-30 map: link fields now exist for The Map, Feed, Mandala, Bindu Field, Field, and a Mirror table, plus Excerpt/Voice/Surfaced fields — the ledger is becoming the cross-app spine the architecture intended.
18. The Mandala table carries a stray auto-created `From field: Related Shaktis` link field (`fldtAau1NIP4QDZrk`) alongside the real `Related Shaktis`.
19. XCUITest-launched app instances bypass `isUnitTesting` and write to live Airtable with the dev Mac's PAT — the mechanism by which the 07-13 rows (and Kāmākarṣiṇī's count of 3) most plausibly arose.
20. Brief-staleness corrections for future briefs: "ten test files" → 14 + 1; the H6 "+3 s" script → 4.1 s staging (see H6); the §0 ledger mechanism → see §A.

---

## Device-Session Capture Card (everything BLOCKED, in evidentiary order)

**Law carried forward: do NOT delete or reinstall the app.** The local stores and `ledgeredLetters` are now the primary evidence. Dev builds over the same bundle ID preserve the container and are fine.

0. **Ask Ashrey / check Airtable base history:** was `Link to Mandala` created on/after 2026-09-06, or did it exist earlier? (API can't date it; a human memory or the base's activity view can.)
1. **Local truth vs Airtable truth (the single most decisive read):** dump the phone's SwiftData `RecognitionEntry` rows (count + dates + gestures) and compare against the 15 Airtable rows. Local rows after 07-13 with no Airtable twins ⇒ the pipe is broken (go to 3–4); no local rows after 07-13 ⇒ usage stopped; presence/absence of the 07-13 Kāmākarṣiṇī pair locally settles whether the phone or the Mac wrote them. Also dump local `ShaktiLetter` rows (3 expected).
2. **UserDefaults:** read `pendingActivities`, `pendingRecognitions`, `pendingLetters`, `pendingCrossings` (expected empty under every failure mode — see §A2) and **`ledgeredLetters`** (decisive: marked ids = letter-ledger attempts happened and died; unmarked = never attempted).
3. **Installed build:** build number (= Xcode Cloud `CI_BUILD_NUMBER` if TestFlight), install channel, and whether `AIRTABLE_PAT` resolves in its Info.plist (nil/placeholder ⇒ the second independent cause is live).
4. **App Store Connect → Xcode Cloud:** last build status; workflow Environment → Variables: does a secret named exactly `AIRTABLE_PAT` exist?
5. **Live Console capture** during one real recognition (subsystem `com.ashrey.bindu-mandala`, category `airtable`; strings in §A1) — knowing the log cannot classify a 422 (response bodies discarded); breakpoint/proxy if classification is needed.
6. **B1/B2:** Detail walk across rings 1, 3–9; for any blank section dump that row's `lastSyncedAt` (`Shakti.swift:35–36`); watch `[Phase 1] sync starting…` at launch and at the 300-s tick.
7. **G5 baseline:** iPhone model; FPS during deep zoom and the descent; memory at rest/deepest; thermal over 10 min; cold launch.
8. **H device passes:** H1 screenshot pass per FIDELITY; H5 VoiceOver walk (expect the canvas Mandala to be silent to VO; Sanskrit fallback for the 86); H6 with the corrected 2.6/4.1/5.1-s staging; H7 in hand; H8 summons observation or pending-notification dump.

---

*Report produced read-only: no code edits, no file moves, no Airtable writes, no queue flushes, no commits, no pushes. This file exists only in the local clone and is handed back as a file. The map's maker leaves no footprints.*
