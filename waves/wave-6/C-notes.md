# Wave 6 · Slice C — Modes, rites and his laws · notes

Branch `wave/6-slice-c`, from `wave/6-whole` (04864ba). Decisions, in the expansive direction, with the Codex line each answers to.

## His laws, honoured where the build ran against them

1. **The centre is shown, never reached by doing (C-1307).** `TheCentre` no longer opens Mauna on a tap. The point *notices him*: fallen in to ring ≥ 7, the point within 28 % of the glass's middle, the glass untouched for one breath (8 s) → Mauna arrives (`CentreArrival`, `Views/Mandala/StillnessAtTheCentre.swift`). Once per stillness: the glass must move before it arrives again. VoiceOver: the point's accessibility action. Inside Mauna the Praveśa fall is no longer a press-and-hold: `MaunaDepth` deepens while the **phone** is still (`StillnessSensor`, CoreMotion, already in the tree) and loosens when it moves; the fall begins at half depth; when the recognition is whole and he has rested in it 4 s, the point opens to Lalitā (`onFallThrough`). A tap anywhere still leaves (one gesture). VoiceOver has a "Rest here" action that stands for a still phone. The bloom (G17 hold) stays: it is play at the point, it opens nothing.
   - Lalitā's seat tap (ring 9 in `activate`) and the Veil's "the Bindu" row still open her source directly. Left as is: she is one of the 102 seats and every seat is reachable (one building). Flag for Ashrey if he wants the source itself to arrive only by stillness.
   - **The empty summit (C-1260).** `ClimbSummit` (`Homes/ClimbSummit.swift`): rising into Totality, the ninth āvaraṇa's light thins away (`WorldClimbScene.standPresences`), no name is spoken, and *"I am what I am becoming."* arrives, then the Totality close *"I already did."* (C-1278/C-1281). Her light stays in the building: a touch where it stood still opens her room.
2. **No clock on his silence (C-1355).** `Mauna.captions` / `caption(at:)` removed. `Mauna.recordedAfter` (ledger floor, never shown) kept.
3. **The year ring keeps its lived gaps (C-1348).** `LivingMandala.dayAngle(_:)`: each bead at its own day of the year, 1 Jan at 12 o'clock; days not practised are space. Minimal edit in `YearRingLayer` only (slice D also touches the Portrait). `beadAngle` kept, unused, for the record.
4. **Release as an offering (C-1230).** Gates of Release: inward instruction *"hold to offer it"*; the words rise and open into the light (`TheGates.offer`, was `putDown` falling); after answering, *"offered — the space it leaves is yours"* / *"received"*. Ledger type `State Set Down` kept (vocabulary other instruments read, and every earlier row carries it); its row now says *"— offered"* / *"Offered · …"*.
5. **"She was expecting you" for all 102 (C-1284).** `ClimbLights.breath` ignores `met` (every light gets Design's welcomed breath); `WorldClimbScene.hold` gives every light the core. Only an authored room's light is larger (describes the building) and only today's Śakti carries the crown.
6. **The Door absorbs force (C-1357).** `DoorHold.step`: under a hard press nothing changes (no dim). The idle settle when no finger is on it stays (the door waiting, not an answer to him).
7. **The Wager → "she might appear today" (C-1195).** Nothing is placed, nothing asks. Her screen: *SHE MIGHT APPEAR TODAY · Not to be watched for — only, perhaps, noticed in passing.* and one touch, *I noticed her*, at any hour (`WagerStore.notice(for:)`, `noticedToday(for:)`). An open Wave 5 watch is answered by the same noticing (never orphaned). No "not this time": nothing was owed. Ledger row name *"— noticed in passing"*.
8. **"Embodiment … level 4 of 4" removed (C-1338).** The track is `accessibilityHidden`; the pill still names her stage. `NeverMeasure.pinnedNonIdentityDigits` is now empty and `ShaktiStatus.allCases.count` left `structuralCounts`.

## Modes and rites

9. **The mode door** — a fifth control on the Mandala's column (`◌`, "The modes") opens `ModesDoorView` (`Views/Modes/`). Order leans with the hour (dream first at dawn, offering first at dusk); nothing locked. Mauna is named there, not opened.
   - **Darśana** — `DarshanaDepth`: stillness gathers (Design's 3 s / 30 s / 2 min shape as a pace), movement loosens; words *hold still · she wakes* → *beholding* → *∞* (Design's "· 30s" dropped). The yantra wakes from a breath of line, turns, the point brightens, radiance at the deepest.
   - **Sādhana** — saṅkalpa (Design's), then the 102 names in garland order at Design's 28-minute pace (≈16.5 s each, never shown), each seat lit as she is said (the said keep a quiet light), bīja sounded if ♪ is on, *"You leave … You enter …"* at each ring (Avaraṇa row names), visarjana at the point, then *"Every name has been said. What remains is what was always there."* (Design's "One hundred and two have been said" reworded to avoid a count). Kept in `RitesPractice` as a place (whole / the enclosure reached), ledger `Garland Recited` linked to Lalitā's row.
   - **Smṛti** — every felt seat lit, binary (C-1286); seats felt on the same practice day threaded. No counts (Design's "23 catches", "day 191 of 264", "most alive" not drawn). Reads only.
   - **Svapna** — yesterday's felt Śaktis (practice day − 1, this phone's record) as dream-light drifting near their seats on a dawn ground, names faint; *"The night was still."* when none. Nothing asks him to recall. Reads only.
   - **Pūjā** — today's catches as lights; hold *offer the day* → they draw to the point, rise, dissolve; *"The day is received. Tomorrow opens again."*; *"sleep with the field"*. A day with no catch is offered whole. Ledger `Day Offered` linked to today's Śakti; calls `RiteHooks.dayClosed`.
   - Each mode ends in stillness; edge way out + one word at the foot.
10. **The Rite.** Nine-beat arrival and Wave 3's day layer untouched.
   - **Arrival (opening)** — `RiteOpeningView` before the nine beats, once in the light half and once in the dark half of a practice day (UserDefaults key, per-viewer convenience): the hour's call (dawn Prātaḥ/Śṛṣṭi *"Open the eyes before the world opens them for you."*, dusk Saṃhāra *"What you carried today may be offered here."*), then *"Stop. Breathe. Remember."* (C-1303), then the Sacred Pause, three 7 s breaths (C-1160). A touch passes it. Skipped under unit tests and `SKIP_HOMECOMING` / `SKIP_OPENING` so the UI suites read the Rite as before.
   - **Dawn/dusk (#17)** — tint and words by hour; the **102-day liturgical year (#19)** as the opening's light (`RiteOpening.yearLight`), never numbered.
   - **Six stations (#16)** — Arrival (opening) → Summons (nine beats) → Meeting (ceremony) → Being-with (the composed Rite) → **Offering** (her Appreciation Phrase, else recognition phrase) → **Carry** (her somatic line, `SensoryDoorway.line`), shown after the ceremony closes, once per practice day (#24), tap to rest.
   - **Bell hook for slice B** — `RiteHooks.openingBegan` / `RiteHooks.dayClosed` (static closures, `Services/RiteOpenings.swift`), called at the opening and at Pūjā's offering. B can set them; no Rite layout is reserved beyond that.
11. **Codex concepts.**
   - *"Who is saying that?"* is Mauna's threshold line, over the colourless Maya light that thins while he is still and returns when he moves (C-1305); beneath it, *"awareness is the space it is said in"*.
   - **Pointy** — 102 particles (one per seat) morph line → circle → ∞ → heart with the silence's depth; *"the pointy loves"* (C-1306).
   - *"I already did"* — the Totality close at the climb's summit.
   - **Witness page** (C-1280) — `HerWitnessPage` on her Detail (under her doorways): sealed; a 1.8 s held *ask for help* opens it; the page is her own row (Function, else Quality Description — never generated; `codexPortrait` is refused on a render path by the aniconic law); he writes beside it. Kept in `RitesPractice` (`Application Support/Practice/rites.json`, atomic, append-only — every save its own entry, blank never erases) and mirrored to the ledger as `Witness Written`, words in `Notes`. No `@Model` touched. Placed on her Detail rather than inside the SceneKit room: the room is slice-shared render code; flag if Ashrey wants it inside the room itself.
   - **One-page answer** (C-1279) — at the head of her Detail: her one line (Appreciation Phrase, else Quality) and *or the whole of her home ›* (her room). Both always present; the choice is not remembered.
   - **Low-state door** (C-1002, C-1120) — *I am low* in the Rite's top-leading corner (outside the column so the composed Rite does not move); opens his own lines one at a time — margin notes, Well letters, readable river letters (sealed ones never peeked), witness writings — split at sentences, each once, the day choosing where it opens. Never a prompt; his state is not recorded.

## Ledger

New types in `ActivityLedger.ActivityType` (born by typecast): `Witness Written`, `Garland Recited`, `Day Offered`; builders in `Data/ActivityLedgerRites.swift`; flushed by one line in `PracticeLedger.flush` (`RitesPractice.takeUnledgered`, stamped before the await like Wave 5's stores). Added to `LedgerIsTheRecord.eventVocabulary`.

## Tests rewritten to the law (each cites its C-number)

- `OneBuildingTests`: Mauna captions → `testMaunaFollowsHisStillnessAndNeverAClock` (C-1355) + `testTheSilenceArrivesByStillnessAtTheCentreAndIsNeverOpened` (C-1307) + `testThePointOpensOnlyAfterHeRestsInTheRecognition` + `testPointyDraws…` (C-1306); met-calmer → `testEveryLightBreathesTheSameWelcomeMetOrNot` (C-1284); put-down → `testTheInwardGateIsAnOfferingAndBothWaysAreGains` (C-1230).
- `WorldClimbTests`: cores = met → `testEveryLightCarriesTheCoreAndTheCrownIsTodays` (C-1284); presence solids now 102 × 2 + 2; new `testTheSummitIsEmptyAndSaysHisLine` (C-1260).
- `LivingMandalaTests`: even spacing → beads at their own days, gaps kept (C-1348).
- `PlayTests`: `testTheDoorOpensToALightHoldAndAbsorbsForceWithoutCorrecting` (C-1357).
- `TheRiverTests`: evening question → `testSheMightAppearAndIsNoticedOnlyIfHeWishes` (C-1195).
- `LawsTests`: embodiment digit pin removed (C-1338), structural count removed, three event words added.
- New `ModesAndRitesTests` for the pure logic.

## Shared files touched (small, hook-shaped)

`LivingMandalaView` (TheCentre args, one control, one cover), `DailyRiteView` (opening/closing overlays, low door, `beginArrival` gate), `ShaktiDetailView` (two sections, one accessibility line), `HerDoorwaysSection` (wager block), `WagerStore` (+notice), `PracticeLedger` (+1 line), `ActivityLedger` (+3 types, two row wordings), `TheBuilding` (Mauna, breath, gates), `WorldClimbScene` / `WorldClimbView` (core for all, summit), `LivingMandala` + `LivingMandalaLayers` (year ring, minimal), `PlayPhysics` / `PlayGamesPassage` (Door, minimal), `GatesOfReleaseLayer`.
