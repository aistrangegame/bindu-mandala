# Wave 3 · notes — the Origin and the 33

*12 October 2026 · Build Charter II · built on `wave/1-light` (b2192dc)*

## The bake (The Map → the yantra)

- **Source, read live and read-only on 12 Oct 2026:** The Map `tblwpmyKOeMxEEHd7` (all 33
  records, every field the bake carries), the Mandala table `tblrRwXJD0uP8HU8G` (Khadgamala
  Position, Sanskrit Name and Shakti Family of all 102), and Codex C-1343 / C-1344 / C-1345 in
  `tblDF4OCMcRoxkQjU` (Codex Log 343–345). Nothing was written to Airtable.
- **The Map carries no khaḍgamālā position.** So the bake joins the Map's Shakti Name to the
  Mandala's seats, ring by ring, and writes each join's reason into the file (`joinedBy`).
  Spelling variants resolved by hand: Samkshobhini → Sarva-Saṅkṣobhiṇī (Devī), not the Mudrā
  sister at kp 19 (the Map's Avarana select says 14 Triangles); Dwandwakshayankari →
  Dvandvakṣayaṅkarī; Sarvagya → Sarvajñā; Sarvadhara Swarupa → Sarvādhārasvarūpā; Kamesvari →
  Kāmeśī; Jayani → Jayinī; Sarvesvari → Sarveśī; Kameshvari → Kāmeśvarī; Vajreshvari → Vajreśī;
  Mahendri → Indrāṇī.
- **Families** come from the Mandala's own Shakti Family field, not from inference: Mūlādhāra
  = the ten Siddhis (kp 1–10), Svādhiṣṭhāna = the eight Mātṛkās (11–18), Maṇipūra = the ten
  Mudrās (19–28), Anāhata = the sixteen Karṣiṇīs (29–44), Viśuddha / Ājñā = the two halves of
  the Anaṅgas (45–48 / 49–52).
- **Presiding forms are not seats.** Tripureśī (Sahasrāra, presiding Avarana 2) and Tripura
  Siddhāmbā (Integration, presiding Avarana 7) are not among the 102, so those two chakras live
  at the level of their whole ring with an empty `kp`. Tripura Mālinī (Armin) likewise.
- **Ring from the Map's own words** where the Avarana select is "n/a" or "Bindu inverted":
  the Bindu and Lalitā at 9 (Shakti Name: "Avarana 9"); Maya and Ego Reveal at 8 (Shakti
  Function: "of the 8th avarana"). The bake asserts every select-derived ring agrees with the
  join.
- **Gaps found in The Map** (left empty in the bake, never filled):
  - Ego Reveal has no Sanskrit.
  - Panel Verb is set on only 10 of 33 (not carried; Verb is set on all 33).
  - The Avarana select is "n/a" on five rows (Bindu, Shadow, Armin, Ego Reveal, Lalitā) and
    "Bindu inverted" on Maya — the ring lives in the prose, as above.
  - Crow's verb: the Map says RELEASE; the HTML said CROW (C-1345 notes it as unresolved).
    The bake carries RELEASE.
  - Primary Color for the body is a dyad ("Red + Cyan"); the drawing uses Color Hex only.
- Regenerate: `waves/wave-3/bake_chakra_constellation.py <map-export.json> <out.json>` — the
  input is The Map's records as the Airtable MCP returns them (cellValuesByFieldId); the join
  table inside it is the whole of its logic. Content fixes flow Airtable → re-bake → app.

## Calls made in the build

- **Canon B is the constellation; canon A stays the Climb's.** The Map's addresses are what the
  Mandala draws. Soles sits at āv 4 here (kp 53) and stays band 1 on the Climb: two lenses.
- **Anāhata and Sahasrāra share the 16-petal ring** as the Map says: Anāhata as a thread through
  the sixteen Karṣiṇīs, Sahasrāra as a breath of light round the whole ring (the presiding
  register). Same for the two halves of the eight petals and the three rings of the Bhūpura:
  each thread runs a hair inside the seats, offset by its section number, so threads that share
  a ring never lie on one another.
- **Colour** is the Map's Color Hex, lifted toward cream (more for the very dark body colours)
  so additive light of #060D30 is still visible on the indigo sky.
- **The thresholds ride the inward fall only**, like the ring crossings they hang off, and a
  fall through both meets both in order. The Road plays each when it stands on it and does not
  also fire the zoom's. Sound obeys the Mandala's existing sound switch (`lr_sound`); haptics
  and light always. Neither moment hit-tests anything — the field is never held.
- **The Road moves the camera and nothing else.** It records no crossing and writes no row;
  walking it is looking, not doing.
- **Homecoming on every launch.** First: the whole Origin (≈16 s to the covenant, words
  "You have always felt them." / "Now you will know their names.", Design's "rest one finger
  on the glass, and be still", and "tap to enter" at its pinned 11 pt / 0.5 α). Every return:
  one breath of the Bindu's 4 s — blink at 0.35 s, the yantra drawing outward 0.9 → 3.7 s,
  open at 4 s. A finger down holds the breath open; held still for one breath it is the
  covenant; lifted, it is a way in. The XCTest host stays quiet; `SKIP_HOMECOMING` unchanged.
- **The covenant hands into today's ceremony** (`RecognitionMomentView`, source Today), so it
  writes the same ledger row the Rite's "I feel her" does, and settles to the Portrait as the
  Rite does. The two lines are untouched (that file was not edited).
- **The point's sound** is 136.1 Hz with its fifth and octave, on the first touch only.
- **Grace** reads App Activity rows linked to a Mandala row in the last moon (one GET, by
  name, through the existing `fetch`), prefers today's Śakti's own room, then a sister in the
  same enclosure, speaks once, and rests three days. It never repeats a row. Rest is kept on
  this phone (UserDefaults) because the topology law allows no PATCH to App Activity —
  the ledger's Surfaced fields stay the Chakras app's. Silence when nothing fits, when sync
  is off, or offline. The lines themselves are authored in `Services/RiteDay.swift` and are
  not quoted here (the Chakras brief keeps them sealed until walked).
- **The pulse** lives under the thumb on "I feel her" on days her ring is 4–8 (the Shadow →
  Ego Reveal span, in yantra terms). ~60 bpm, lub-dub, soft. Never named. The tap still
  opens the ceremony on lift.
- **Three doors** sit under the Rite's foot: morning = directions, midday = sizes, evening =
  the close; one is always the one-second floor. Nothing marks a door as walked.
- **The floor** is Blink. Breathe. Press. (4-4-4, a 1.8 s hold), then the canon line, then it
  lets him go. Its day-mark is local (this phone) and is read only by the Sakshi close. It is
  **not** written to the ledger yet — a new Activity Type is a schema change in the shared
  base; left for the lead to rule.
- **The Sakshi close** names what today held from the phone's own record — who he stopped for,
  whom he kept a silence with, how deep the Mandala fell (only when today's crossing is the
  deepest), whether the floor was walked — and what waited. Past three names it says
  "and others", so it can never be read as a tally.

## Tests

- Added `ChakraConstellationTests` (+ `ChakraRoadTests` in the same file): 33 entries, Road
  order 1…33 unique, every kp in 1…102, Shadow at [3, 4], Armin at [6, 7], the point at both
  ends, sections in their rings, seat/ring/threshold addresses consistent with the Mandala's
  own ring map, the body's ten seats, empty Map cells absent (Ego Reveal's Sanskrit), the
  malformed-file path, thresholds crossed by a fall, the canonical seat equal to
  `MandalaWorld.seats`, spoken labels without digits; the Road: 33 stops, out to the Bhūpura
  and spiralling home, every stop a legal camera, rests and travel bounded.
- Added `RiteDayTests`: three doors never five with the floor always, the pulse span, the
  floor's words, grace (her room first, a sister's enclosure, silence when nothing fits, rest
  and no repeats, "when" in words), the Sakshi close (no digits, "and others", an empty day is
  not a debt), and the Homecoming score (one breath, drawn outward, the blink, the condensing).
- No existing test was rewritten. `SnapshotBaselines/` untouched.

## For the lead

- Wave 2's Mandala work will meet these hooks in `LivingMandalaView` (the overlay sits after
  `controls`; the two switches stand at the top-leading edge, 70 pt down, mirroring the zoom
  column) and in `updateEntered()`.
- The Veil peek still answers during a Road walk (it sits above the walk's touch catcher).
- The silent switch: new sounds go through `BijaSoundService`, which plays in `.playback`
  (ignores the switch), as every existing sound does. Wave 2 owns the sound engine.
