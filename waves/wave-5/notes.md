# Wave 5 · decisions and notes

Built on `wave/1-light` in parallel with Waves 2–4. Every call below is taken in
the charter's direction (the fuller version), with what it protects named.

## 1 · Storage — JSON files, not a schema version

- **Decision:** his strokes, river letters (and the river draft) and wagers live in
  `Application Support/Practice/{portrait-strokes,correspondence,wagers}.json`
  (`Services/PracticeVault.swift`). **No `@Model` changed; no schema version added.**
- **Why not `BinduSchemaV4`:** BinduSchema's header makes a new entity in a new
  version the safe road — for one branch at a time. Waves 2, 3 and 4 are being
  built beside this one; two branches each adding a different V4 would merge into
  two schemas under one version number, and a launch meeting the "other" V4 takes
  `PersistenceRecovery`'s preserve path (the whole store moved aside). Files cannot
  collide with any schema work, and touch no migration.
- **Safety rules:** atomic writes (`.atomic`, write-beside-and-rename); a file that
  cannot be decoded is copied aside as `<name>.unreadable-<time>.json` before
  anything can write over it; nothing is ever deleted; every stroke is written the
  moment the finger lifts; a sitting cut short by a kill is closed on relaunch with
  its strokes.
- **Restore after reinstall:** the ledger carries each sealed/sent letter's words in
  `Notes`, so they are never only on the phone. A restore-from-ledger mapper for
  river letters is **not** written yet (follow-up; the existing note restore is the
  pattern to copy). Strokes and wagers are phone + Application-Support-backup only.

## 2 · The ledger (R17)

- New types, born by `typecast: true`, vocabulary only in `ActivityLedger.swift`
  (and added to `LawsTests.LedgerIsTheRecord.eventVocabulary`):
  `Letter Sealed` (forward *and* sent back; his words in `Notes`), `Letter Opened`,
  `Portrait Drawn` (one per sitting, linked to the Avaraṇa of the ring most drawn
  in), `Wager Resolved` (linked to her row; "She appeared" / "Watched for, and left
  open" — neither a verdict).
- **Never dropped:** each record carries its own handed-over stamp
  (`ledgeredAt` / `sealLedgeredAt` / `openLedgeredAt`). `PracticeLedger.flush`
  stamps on the main actor before the await, then hands to
  `AirtableService.logActivity`, whose queue never drops. A letter or wager for a
  Śakti whose row has no `airtableRecordId` yet simply waits for a later sweep.
  Sweeps run on the Portrait/river appearing, after each act, and on every
  `.active`. With sync off (tests) nothing is handed and nothing stamped.
- Every row is linked, so the create-time dedup (type + link + `Felt At` to the
  second) keeps a retried POST to one row.

## 3 · The ephemeris — one moon

- `Services/Ephemeris.swift`: Sun (Meeus ch. 25, low accuracy), Moon (Meeus ch. 47,
  the 60 longitude terms of table 47.A + A1/L′−F/A2), Lahiri ayanāṃśa
  23.857092° at J2000 + 50.290966″/yr. **The brief's "≈24.1° in 2026" is low: the
  Lahiri value for October 2026 is ≈24.23°**, and the nakṣatra fixture (Aśvinī →
  Bharaṇī at 12:11 UT on 26 Oct 2026, two sources) confirms 24.23.
- Checked against USNO before writing a line of Swift (a Python port of the same
  series): every 2026 Sept–Nov phase within 0.02° (≈2 min); sunrise/noon/sunset at
  Bensalem within one minute of USNO.
- **Reconciled, not duplicated:** `LunarPhaseService.phaseFraction` = true
  elongation / 360; `currentDay` = the true tithi (1–30). So the Rite's Nityā, the
  Today header's night, the ledger's `Lunar Day` and the clocks read one moon.
  Consequences, all deliberate:
  - The ledger's `Lunar Day` is now the true tithi rather than the mean synodic
    day. `ActivityLedgerTests`' fixture instant (2026-09-06 14:34 UT) reads 26, not
    25 — the Moon was 300.3° from the Sun (Kṛṣṇa Ekādaśī). The service-derived
    assertions now read `lunarFromService = 26`; the queue-item `Moment` fixtures
    keep 25 (that is what the old queue wrote).
  - `HomesHarnessTests.aSynodicMonth` samples twice a day: a true tithi runs
    19–26 h, so one sample a day misses short ones (11 and 16 in Jan 2026).
  - The new-moon time state is the `.newMoon` phase on **both** sides of the
    conjunction (fraction < 0.03 or ≥ 0.97); on the true moon the conjunction itself
    reads 0.9999…, so the after-side-only rule would have missed the dark night.
- Ṛtu and ayana are reckoned on the **tropical** Sun (Śiśira from the winter
  solstice; uttarāyaṇa solstice to solstice) — the Sun's real course. The sun clock
  also shows the **sidereal** rāśi.
- **Sandhyās** need a place. The instrument asks no location permission: home is
  Bensalem, PA (40.1046, −74.9516); in another time zone the longitude follows the
  zone's standard meridian and the latitude stays home's (`TemporalPlace`). Tithi,
  nakṣatra, ṛtu and ayana don't depend on place.

## 4 · The Living Mandala

- Mirror n = the seats in the ring the stroke **begins** in (a fact about the
  yantra): 28, 16, 8, 14, 10, 10, 12, 3, 1. Stored in unit coordinates so the stroke
  is the same on every screen and in the Record.
- "Draw into her rings" opens a sitting; "set it down" closes it → one ledger row.
  While drawing, the whole artwork takes the finger (the export long-press is
  covered); otherwise a 56 pt centre target opens the point.
- The year: one bead per practised day this calendar year (recognitions, sittings,
  river letters), spaced evenly round the **whole** rim — never 1/365 slots, so no
  day is ever an empty slot and the ring is whole on day one. Each bead in the light
  of the Śakti who presided that day.
- The eye: while any river letter is sealed, a lid of light closes over the point.
- The 102-point field, the lotus and the settle are untouched. The Record is the
  existing long-press export, now carrying the strokes and the year.

## 5 · The river

- The Well's one-letter-per-Śakti editor is untouched (its scenePhase save and 2 s
  debounce stay); the river is a door in the Well's header and on the Portrait.
- Forward openings are found on the real moon (`Panchanga.nextStart(ofTithi:)`,
  Newton on the elongation): the next Pūrṇimā / Amāvasyā begins, this tithi's
  return, or her own next day (the 6 am turn of the 102).
- No peek: a sealed card shows her light, her name and the day — no words; `open`
  refuses before the instant. Opening reveals word by word (0.24 s a word; a touch
  shows all; reduce motion shows all). No reply, no generated text, anywhere.
- Patina = 1 − e^(−days/240), tinting the page amber over the years.
- The composer keeps a draft (2 s debounce, on disappear, on leaving `.active`).

## 6 · Somatic way in, gaze, gift, Codex

- Regions are matched from her `bodilyLocation` (diacritics folded; a row may name
  several places; nowhere-known → the whole field). Fixtures are the base's own
  words, read from Airtable 2026-10-12. Drawn as places of light along an axis with
  an aura — no outline, no figure, and it is his body.
- Gaze: CoreMotion device motion (no permission needed); ~6 s of stillness steadies
  fully; the wheels tremble with unsteadiness; a soft haptic when fully still. No
  record — it is a state, not an event.
- Gift: seeded per (day, per-install salt) so redrawing the fortnight on every
  `.active` keeps each day's gift where it was — never twice. Off when "Let her
  arrive" is off, when the gift toggle is off, or without permission. Window default
  10:00–20:00 in Settings. Her Appreciation Phrase, else her Function; a seat with
  neither passes the day to the next seat that has one. `GiftRouter` (installed in
  `App.init`) lands a tapped gift on her Detail; foreground gifts show as a quiet
  banner, the summons stays silent in the foreground as before.
- Codex on her screen (`HerDoorwaysSection`, between her appreciation phrase and her
  embodiment — the library shelves stay last): the doorway by her tattva with the
  first line of her somatic signature; the seal (hold 2.4 s → her Appreciation
  Phrase); the Wager (answerable from 17:00 local or any later day; both answers
  close it). The Detail's own file still writes nothing down — the wager is practice
  data held in its own store.

## 7 · Shared files touched (small, additive)

`ShaktiDetailView.swift` (one line), `WellView.swift` (header door + cover),
`SettingsView.swift` (gift section; summons toggle also redraws gifts),
`RootView.swift` (gift provider in `primeSummons`, gift landing),
`BinduMandalaApp.swift` (delegate install; gift reschedule + ledger sweep on
`.active`), `ActivityLedger.swift` (four types + builders), `LunarPhaseService.swift`
(façade), `Info.plist` (`NSPhotoLibraryAddUsageDescription`, so "Save Image" from the
Record's share sheet cannot crash).

## 8 · Follow-ups

- Restore river letters from the ledger after a reinstall (mapper + merge on
  identity, as the margin does).
- A home-place setting if he travels for long (today: zone meridian fallback).
- `HomesHarnessTests` could read the four new builders into its never-measure
  corpus; `TheRiverTests` asserts their composed words carry no digit meanwhile.
