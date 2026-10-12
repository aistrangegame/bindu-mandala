# Wave 6 · Slice D — memory, the sister apps, and the live data

Built on `wave/6-whole` beside slices A, B, C and E. Every call is taken in the
charter's direction (the fuller version), and each names what it protects.

## 1 · Storage (no `@Model` touched, no schema version)

All new practice data lives in `Application Support/Practice/` through
`PracticeVault` (atomic write-beside-and-rename; an unreadable file copied aside
before anything writes over it; nothing ever deleted):

| File | What | Ledger |
|---|---|---|
| `correspondence.json` (existing) | river letters now carry optional `recipient` (her · an age · a memory · past self · later self) and `voiceFile`; the archive carries optional `lights` (light sent back) | `Letter Sealed` (recipient words in the name, a back letter's moment in `Detail`), `Light Sent Back` |
| `bindu-memory.json` | the higher-self name, every name ever kept (`history`, never overwritten) | `Name Kept`, linked to the point's row (kp 102), the name in `Notes` |
| `codex-notes.json` | his words sent to the Codex, kept for the Book and the Month | none — the Codex row is the note (R17: not an event) |
| `play-traces.json` | each `Played` act, kept locally for the Portrait's layers | the existing `Played` row (unchanged) |
| `voice/*.m4a` | his own voice (letters, Codex notes, the month's answer) | none — phone + backup only |

Every new optional field decodes old files (`RiverArchive.lights` is optional on
purpose: a non-optional default would make a Wave 5 file throw and be copied
aside). `TheRiverTests`' Wave 5 fixture is joined by a Wave-5-shaped file test.

UserDefaults (catalog, not practice): `shaktiFacts.v1` (`ShaktiFactsCache`),
`ringFacts.v1` (three new optional fields), `herDeepening.*` (the per-position
return marker), `heartRegister.sa.v1`, and the `pendingCodexNotes` queue.

## 2 · The ledger and the Codex

- Two new types, vocabulary only in `ActivityLedger.swift` and added to
  `LawsTests.eventVocabulary`: **`Light Sent Back`**, **`Name Kept`**. Born by
  typecast — the Airtable ledger's warning stands: if the token cannot edit the
  schema the POST 422s and waits in the never-drop queue. **Pre-create both
  choices** (with the eight the Airtable ledger already lists).
- **The raw Codex write** (`Data/CodexWrite.swift`, `AirtableService.writeCodexNote`):
  Title (his first line) · Date · RAW voice memo (his words) · Source App
  "Bindu Mandala"; **Status never written** (asserted). Field ids read from the
  live schema, read-only. Its own UserDefaults queue under `PendingQueuePolicy`
  (never dropped); a retry first reads the Codex rows of that day from this app
  and matches on the normalised words (fail-open).
- `LawsTests.testTheOnlyPostInTheTreeGoesToTheLedger` became
  `testTheOnlyPostsInTheTreeGoToTheLedgerAndTheCodex`: exactly two POSTs, to App
  Activity and the Codex; the Mandala table still only receives record-addressed
  PATCHes; topology `POST → App Activity · POST → Codex · PATCH → Mandala`.
- **River restore** (`AirtableService.restoreRiverFromLedger`, every sync):
  `Letter Sealed` / `Letter Opened` / `Light Sent Back` / `Name Kept` rows → the
  river. Merged **on identity** (position + instant to the second + words), not
  "only when empty" — the margin's lesson (an emptiness guard closes for good
  after one offline launch). Forward letters find their day again from the
  opening + the instant (the moon is deterministic); a back letter's moment is
  now written into `Detail` as an ISO instant so it comes home; letters written
  before Wave 6 return to the day they were sent. Voice-only letters cannot come
  back (their sound lived on the phone). Restored items arrive already ledgered.
  The name comes home only when the phone holds none.

## 3 · Her screen deepens (C-1354)

`HerDeepeningSection` on her Detail: one more layer per return (what she does ·
what her ring sets down · what her ring gives · the root of her name · how she is
known · her enclosure's paragraph). A return counts once per 20 minutes; the
marker is per position, phone-only, never shown. **Iconography is left out**
(Law 4: `LawsTests` refuses her iconographic prose on a render path).
Her **Seed Verb** (live) heads the section when present; ring-2 Śaktis carry the
door to **the heart register**.

## 4 · From Bindu Feed

- **One breath clock** (`Theme/BreathClock.swift`): breath = 8 s (the Field's
  wall clock), beat = 1 s, one epoch. `FieldBreath.phase` now reads it, so the
  Mandala, the Rite, the 102 and every atmosphere breathe off one clock; the nine
  ring periods (3·8·9·11·13·15·18·4 s, Design's own) are whole numbers of its
  beats and were **kept** — re-quantising Design's metabolisms would have been a
  loss. A Score's tempo snaps to the beat. **Rooms are not yet on it** — their
  `breathRate`s run on the chamber clock (`MembraneRoom`, `TripleRoom`); moving
  them is a renderer change left for the room owner.
- **One point**: `BinduPoint` (breathing on the clock, never explained) on the
  Book, the Month, the heart register, the light sent back, Bindu memory. The
  Portrait's own point is untouched ("the Portrait does not breathe").
- **The Archive as a book** (`ArchiveBookView`): readable letters, margin notes,
  words left with a recognition, light-with-words, Codex notes — oldest first,
  yellowing by their own age; the exact middle is a door into the descent
  (`DescentFilmView`); the last page **seals it forward** and leaves a word in
  the Codex. A frontispiece carries the kept name.
- **Day glyph + month letter** live in the Month Mirror (below).

## 5 · Being's Month Mirror (`MonthMirrorView`, `Models/MonthReading.swift`)

The month as a field of day glyphs round the point → what moved (each ring
touched, her names, one sentence of his) → the turning (the latest day carrying
his own words) → the month witnessed (the letter) + the witness line → the
MonthSitting (*it lands · say more · leave my own word* — the last writes to the
Codex, spoken or typed). Words only from his record.
**Ruled in the stricter direction:** Feed's "an ember per thing sealed", Being's
weighted field and "which voice stayed nearest" are all counts of his practice
becoming size or rank, which `LawsDrawnMeasureTests` forbids (a count becomes a
state and nothing else). So: an ember is there or not; a ring is lit or not; the
"nearest" line is dropped; the turning is chosen by his words, not by the
fullest day.

## 6 · The Living Mandala's play-fed layers

`PlayGameHost.writeOnce` keeps each `Played` act on the phone too
(`PlayTraceStore`). `LivingPlayLayers` on the Portrait draws the bead ring
(Garland — every seat the garland touched holds its light), the root web (Drum /
Root System), body-axis petals (the body's games), the seed bloom (the growing
games) and the practice wheel (a spoke per game played). Each is dormant or
kindled; warmth cools by real time to an ember, never to nothing; forty games
and one game draw the same layer. A moment light was sent back to warms its
own day's year bead.

## 7 · The heart register (C-1169, C-1222)

`Services/HeartRegister.swift` + `HeartRegisterView`: a harmonium-like drone on
his chosen Sa (C…F, remembered), breathing on the one clock (bellows), and a
sung-like call on bare scale motifs, then a breath of silence for his answer.
Every sample synthesised; no lyric, no recording. `.ambient` (the switch is
honoured; `.mixWithOthers` is not passed — `HomeVoiceTests` records that it
throws with `.ambient`). **Slice B's `SoundConductor` was not in this tree**:
the engine is self-contained and stops what it started; `HeartRegisterEngine.start`
is the one place to ask the conductor when it lands.

## 8 · Field's absent fifth as ground

`HomeSoundService`: a ground fifth at carrier × ¾ (the fifth, an octave down),
level 0.035, rising with the crossing **from the first beat**; the Mandala's own
fifth (× 1½) still arrives as completion after dwelling. A Score may grant the
upper fifth from the start (`granted`), keep only the ground (`ground`), or
leave the grammar (`withheld`), and may set the ground's level.

## 9 · Live data reads (no Airtable writes)

- Āvaraṇa rows: **Mudra** → the Gates of Release (under the ring's words);
  **Phase** → the Shadow / Armin thresholds ("into Sthiti", "into Saṃhāra");
  **Notes** → the Veil, on the row where he stands.
- Śakti rows: **Score JSON** (tolerant decode; a broken Score is no Score) →
  light + tempo veil over the room (`ScoreLightVeil`) and carrier / fifth /
  ground overrides through `HomeVoice` → `HomeSoundService.score`; **Phonetic**
  → written into the existing `phonetic` column when present (no new stored
  property; the bundled one stands when the base is blank); **Seed Verb** → her
  Detail; **Related Shaktis** (+ reverse) → resolved to positions at sync, and
  the third door in her room (`NeighbourDoors.sister`), found by link order,
  never by name (55's namesake 21 is listed first, so every namesake pair meets;
  a Karṣiṇī's door opens to 55).
- **Grace** reads Feed and Learning moments linked to her (`Source App` now read;
  `sisterVerb` speaks only the type: "you finished a door in your reading").
  Today no Feed/Learning row links a Mandala row, so this is a ready channel.
- **Field Connections** re-keyed to khaḍgamālā positions 31 / 40 / 42 (were
  ring-2 local 3 / 12 / 14); a not-yet-synced bootstrap row is still found by its
  local index.

## 10 · Shared files touched (small, hook-shaped)

`ActivityLedger.swift` (types, builders, restore mappers, `Row.Fields.sourceApp`),
`AirtableService.swift` (field reads, reconcile, two appended extensions,
two lines in `sync`/`flushPending`), `RingFactsCache.swift`, `RiteDay.swift`
(grace fields + `sisterVerb`), `HomeSoundService.swift` (ground fifth, `score`),
`HomeVoice.swift` (`score` instrument member, `sound`, `position:`),
`DayLight.swift` (one line), `ShaktiDetailView.swift` (one line),
`PortraitMandalaView.swift` (one layer, a door row, two covers, warmed beads),
`CorrespondenceView.swift`, `GatesOfReleaseLayer.swift`,
`MandalaThresholdMoment.swift`, `MandalaVeil.swift`, `NeighbourDoorsView.swift`,
`HerRoomDoor.swift`, `RiteOfEnteringView.swift` (one veil, one argument),
`PlayGameHost.swift` (one call), `SettingsView.swift`, `Info.plist`,
`LawsTests.swift`.

## 11 · Follow-ups

- Pre-create `Light Sent Back` and `Name Kept` in Activity Type.
- Rooms onto the one breath clock (renderer owner).
- The Well's per-Śakti editor does not yet take voice (G1) — `VoiceWordButton`
  drops in beside its editor.
- Ask B's `SoundConductor` from the heart register once it exists.
