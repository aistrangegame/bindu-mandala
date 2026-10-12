# Wave 6 · Slice A — The 33 alive · notes

*12 October 2026 · Build Charter II · on `wave/6-whole` (04864ba)*

## The re-bake (The Map → `Data/ChakraConstellation.json`)

- **Source:** a full read of every field of all 33 records of The Map (`tblwpmyKOeMxEEHd7`,
  base `app248ZTWhYJlvQj2`), 12 Oct 2026, read-only through the Airtable MCP. Nothing written.
  The bake script is `waves/wave-3/bake_chakra_constellation.py` (extended in place); its input
  is the MCP export (cellValuesByFieldId). The export itself is not committed (as in Wave 3).
- **Every Wave 3 field is byte-identical** after the re-bake (checked field by field); the join
  table is untouched. Each chakra's Airtable record id was already carried (`recordId`).
- **Added, verbatim, absent where the Map is empty:** Core Question, Signature Phrase, Hero
  Threshold, Practice Prompt, Three Ways In, Practice Gate Type, Gate Text, Story Thread, Leela
  Story, Act 1 Voice, Act 2 Voice (10/33), Bindu Reflection, Witness Perspective, Voice, Writing
  Prompt, Writing Reflection, Mirror Frequency Instruction (33), Mirror Frequency (10), Subtle
  Mirror, Codex References (4/33). All decode as optional `var`s with a nil default, so an older
  bake still decodes.
- **Not carried, on purpose:** Gaia Voice — the walk's own canon (`walk-canon.json` laws:
  `author_substrate_never_surfaced_verbatim`) marks it author substrate, never shown. Teaching
  Text / Post-Engagement Teaching (large; the one-page-answer layer belongs to Slice C's reading)
  and the minor captions. Re-bake to add them.
- **Cross-check:** the walk app's `walk-canon.json` (in the design upload) matches the live Map
  exactly on every long field, under different names. The mapping, for whoever meets it next:
  walk-canon `story.story_thread` = Map **Act 1 Voice**; `story.after_story` = **Bindu
  Reflection**; `story.interlude` = **Act 2 Voice**; `depth.leela_story` = **Story Thread**;
  `gate.gate_text` = **Leela Story**; `gate.gate_interaction` = **Gate Text**;
  `practice.go_deeper` = **Three Ways In**; `practice.bindu_reflection` = Post-Engagement
  Teaching; `arrival.seed_message` = Hero Threshold. The app follows the Map's own names.
- The Map's Sahasrāra Writing Reflection says "the part of you that has been keeping score" —
  it is the Map speaking *against* scorekeeping, shown as written.

## Calls made in the build

- **Rooms are reached by touch, not by a new screen in the menu.** With the constellation on
  (✦), every one of the 33 lights is a 44 pt door (`ChakraConstellationVoices(onOpen:)`); each
  Road stop has "enter its room" (the Road waits while the room is open); the ten body chakras
  on the Climb open theirs. One cover per surface, attached to the overlay view itself
  (`.chakraRoom`), never in the same modifier chain as `herRoom`. A pan that *begins* exactly on
  one of the 33 light spots (44 pt) does not pan — the price of the lights being touchable.
- **The room's shape** follows the Chakras brief: arrival (Voice kicker, name, Sanskrit,
  subtitle, verb, Core Question, Hero Threshold, Signature Phrase as the seed) → story (Story
  Thread; the voice layers one at a time behind it) → practice (Practice Prompt; Three Ways In as
  three doors, the first sentence the door and the rest behind it — cut only at the Map's own
  blank lines and ①②③) → the body's held movements → wake-up (bīja; Mirror Frequency
  Instruction; a "sound" only where the bīja is a syllable — LAM, OM, HAM… — never for the
  poetic ones) → the gate → doors.
- **The gate** is held (1.4 s) on the Map's own button words (its "Button: …" line). Textarea
  and Canvas gates take his words first, under the Writing Prompt. Walked: the offering *leaves*
  — held one breath, lifted to an ember — with the brief's line "The room keeps what you gave it.
  You walk lighter.", then the Writing Reflection, then the **Leela Story**, which nothing
  foreshadows (it is the Map's after-gate text). The four gates with no button (Maya, Aatma, Ego
  Reveal, Lalitā) hold on the Map's Verb.
- **Doors into the Home:** a seated chakra (body, mind, summit, the point) opens her seat's room
  through `HerRoomPassage` — the rite of entering, unchanged. An energy chakra opens the Climb
  standing in its ring (`ChakraRingClimb`). A threshold is a crossing and has no Home door.
  The game is offered where Wave 4 placed one at the chakra's address (`ChakraTeaching.games`):
  Shadow → the Corridor, Pulse → Pulse and Coherence, Mūlādhāra → Root System, Svādhiṣṭhāna →
  Water Level, Forge → Fire, Axis → Spine Walk, Innocence → the Door, the point → Śrī Yantra…
- **The ten body chakras on the Climb (canon A, both lenses kept).** Heights are the body's own:
  the Map's Book Position walks them sole to crown; Soles stands at band 1 (it stays āv 4 in the
  constellation) and Crow at band 7 — Sahasrāra's band, which is Crow's own Subtle Mirror in the
  Map — and the eight between stand evenly up the spine. They stand on the axis (the climb turns
  about it), move one band per `pointsPerBand` of glass exactly as the drag does, and are present
  only within ¾ band of the eye. Drawn as a SwiftUI overlay, not SceneKit nodes, to keep the
  shared `WorldClimbScene` untouched (one line in `WorldClimbView`).
- **Shadow and Armin speak the Map's own words.** Shadow: its Signature Phrase "please come back
  home.", each word arriving in its place in the order the Map's own Act 2 Voice gives (home /
  come / please / back — "the word back arriving last"). Armin: **Tat · Tvam · Asi** one word at a
  time (the three words read from Armin's Mirror Frequency Instruction, "Tat. Tvam. Asi. / One
  word at a time…"), then "Nothing needed repair. Only arrival.", and the light parts into its
  colours (the Map's "Spectrum / Aurora"). Both moments now last 9.2 s (5 s still under reduce
  motion; the words whole); the Road stands through them.
- **The Road's stations.** Atma (Book Position 31) and the Gaia reveal (32 — canon's ruling on
  "Ego Reveal") are dwelt in for 16 s, with C-1330's kicker ("Atma", "the Gaia reveal") and the
  Map's own Story Thread for the place. Every stop now also carries its Core Question. In the
  rooms, Atma's triangle is gold and the Gaia reveal's ground rises green beneath it.
- **The body chakras as movement and breath** (`ChakraMovement`, `ChakraMovementPractice`): the
  euphoria pulse (Hands, Pulse — shake the phone, or rub the glass fast; the heart sends rings of
  light across the glass, three lub-dubs); roar and silence (Sonar, Viśuddha — hold to roar,
  release into the throat's silence); last memories, photo-free (Vision — name a memory or not,
  close the eyes, vibrate, open: **nothing is stored unless he turns on "these words will be
  kept"**, and then only in the row's Notes); Ham · Het · Hum (Echo/HAM, Viśuddha/HET, Sonar/HUM,
  on the Rite's 4-4-4, that room's syllable in gold); fear in waves (Mūlādhāra — hold: it washes;
  release: "a deep breath of life, of prana"; up to three waves, then "This is all an
  illusion." — no fear is ever named); feeling it through (Soles — touch where it is, stay, it
  permeates and dissipates; "Realign."); restlessness allowed (Crow — the light moves with the
  phone, nothing asks for stillness); the heart, home (Anāhata — awareness goes to the finger
  and returns to the hṛdayam). Every line is his, from the Codex entry named in the source.
- **Sound** goes through `BijaSoundService` (the house's existing path) at 110 Hz for the room
  (charter §3.5, rooms about him), only when the Mandala's `lr_sound` is on. Slice B's conductor
  can re-route these call sites.

## The ledger

- New Activity Type **`Chakra Practiced`** (`ActivityLedger.ActivityType.chakraPracticed`, born
  by typecast like Wave 4/5's types — the lead may want to pre-create the choice), Gesture Source
  **Mandala**, one row per practice walked per visit: the gate (his offering in Notes), or a held
  practice (its title in Detail, Duration kept, never shown).
- **`Link to The Map` (`fldkF65ySNGGkeugH`)** is filled with the chakra's record id as an array.
  `Link to Mandala` carries her Shakti row (seated chakras, the point), or the Avaraṇa row
  (ring-level chakras), or nothing (Shadow, Armin).
- `PendingActivity.linkToMap` is optional with a nil default — a queue written before Wave 6
  still decodes and drains; nothing is dropped. Create-time dedup: linked rows dedup on Link to
  Mandala as before; the two thresholds (no Mandala link) dedup on Link to The Map + Felt At to
  the second (`ActivityLedger.mapRowMatches`, `AirtableService.mapActivityExistsOnServer`).
- `LawsTests` pins "Chakra Practiced" in the ledger's vocabulary (comment beside it).

## Tests

- `ChakraRoomTests`: the re-bake carries every teaching field (partial columns stay partial),
  no blank cells, the Map's words verbatim, an old bake still decodes; three ways for all 33;
  the gate's button; which bījas are sounded; home doors; games per address; Tat Tvam Asi and
  Shadow's reveal order from the rows; the Road stands through the threshold words; the two
  stations; the Climb heights, sole to crown, and the band-to-glass ratio equal to the hand's;
  where each Codex practice lives; nothing a practice says measures or carries a digit; the
  charge never goes negative; the ledger row's payload, the threshold's Map-only link, the Map
  dedup, and the queue's round trip with an old item.
- No existing test rewritten. `SnapshotBaselines/` untouched.

## For the lead

- Pre-create the App Activity choice `Chakra Practiced` (typecast risk, as in the ledger's §2e).
- The Map's 8 mind-chakra "Rahasya Mudra" rows still disagree with the ring (Sarva-Khecarī);
  the rooms do not show the mudrā field, so nothing here depends on that fix.
- Shared files touched (small, hook-shaped): `ActivityLedger.swift`, `AirtableService.swift`
  (one dedup branch + one function), `LawsTests.swift` (one vocabulary entry),
  `WorldClimbView.swift` (one line), `ChakraConstellationLayer.swift`, `ChakraLayerOverlay.swift`,
  `ChakraRoad.swift`, `MandalaThresholdMoment.swift`, `ChakraConstellation.swift`.
