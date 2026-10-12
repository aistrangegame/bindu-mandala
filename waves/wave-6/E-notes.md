# Wave 6 · Slice E — Every game · decisions

All twenty games are built on Wave 4's host, without changing its shape. Each one has its own model, sound, haptics and light, and ends in Recognition (source **Play**) or in stillness. Each writes one `Played` row through `PlayLedger`, and the row's shape is unchanged.

## 1 · Addresses, read against the rows (2026-10-12)

I read the Mandala table live: name `fldJOatnYrw9l6tff`, kp `fldI0aV1sfOeNybHI`, body location `fld6P1u43B0eqKU5e`, siddhi `fldnwcu7zv7uV1ta2`. I also read The Map bake (`ChakraConstellation.json`). The rows decided every seat.

`PlayAddressTests` pins each name. As in Wave 4, no screen is keyed by a name.

| Game | Address | Why this seat |
|---|---|---|
| The Seed | 26 Sarva-Bīja (Mudrā) | "the seed that holds everything"; "patience with what has not yet sprouted" |
| Colour Rivers | 20 Sarva-Vidrāviṇī (Mudrā) | "Melting", "joints / fluid systems" |
| Bhakti at Maṇipūra | 24 Sarva-Mahāṅkuśā (Mudrā) | Maṇipūra is kp 19–28. The only row there whose body location is the navel is "Navel hook / third eye" |
| Mirror Maze | 30 Buddhyākarṣiṇī | Buddhi, "forehead, eyes" — the mind that reflects |
| Still · Ājñā | 51 Anaṅga-Aṅkuśā | Ājñā is kp 49–52. This row's body location is "between the eyes" |
| Body Map | 77 Sarvajñā | The Map: Vision |
| The Letter | 88 Kāmeśī | The Map: Intention ("HOLD") |
| Flash · Intuition | 91 Aruṇā | The Map: Intuition |
| Join | 92 Jayinī | The Map: Invention — "the third thing that appears when two things that have never touched finally meet" |
| Shadow Translator | 101 Bhagamālinī | The Map: Ego Reveal, which is the Pairing Floor's "inversion" |
| Leela on the 33 | 102 Mahātripurasundarī | Lalitā, "the game knowing itself". It sits beside the Śrī Yantra, which keeps the door at 102 |
| The Scrolls | threshold 3→4 | Shadow (Sacred Experiences B) |
| Tat Tvam Asi | threshold 6→7 | Armin (Sacred Experiences "Arrive") |
| Mandala Completion | ring 7 | Integration has no seat: it is the whole ring |
| The Twelve | ring 7 | The Vāk ring of twelve |
| Turn | ring 8 | The three made one |
| The World in a Box | ring 9 | Lalitā's field as a living world |
| Rām japa | ring 9 | See §3 |
| The Sandhyā | ring 2 | The lotus that follows the sun |
| The Great Wheel | ring 1 | The year, the outermost ground of time |

## 2 · No live AI (charter law 8)

The corpus built Mirror Maze, Shadow Translator, Flash and the Shadow word on `window.claude.complete`. All three are now authored.

- **Shadow Translator.** He names his burden in his own word. Turning it over shows one of the ten Siddhi Śaktis (kp 1–10), with her name and her own Appreciation Phrase from her row. The same word always turns into the same Śakti, so the result is never random. The game hands him to her Recognition.
  - I did not use the ring's Mental State → Siddhi, because those rows are states of consciousness ("Jagrat — waking"), not burdens.
- **Mirror Maze.** The seven lenses are The Map's seven energy chakras, each with its own colour and essence line.
- **Flash.** Flash gives back his own word as light.
- **Join.** The "third thing" is the essence line of Invention's own Map row.

**His words.** A word given to a game is play. It is released when the game ends, and the ledger row carries no `Notes` (Wave 4 §3). The Letter is the one exception, and the words are not lost there:
- it seals them into his river with `CorrespondenceStore.seal(…, opening: .tithiReturns)`;
- the river's own flush writes its `Letter Sealed` row.

## 3 · Rām japa and bhakti (C-1222, C-1230)

**Rām japa.** The name is his higher self's (C-1262, C-1325), so it is not a Śakti's. It is addressed to ring 9, the point, and always ends in stillness, never at a seat.
- The mālā has 108 beads, and one bead moves per whole breath: hold while the breath comes in, let go as it leaves (1.8–14 s).
- A flick moves nothing.
- The name drawn is राम.
- I did not build the higher-self name entry (Codex F6). If it lands later, the japa should read it.

**Bhakti** is an ārati. He carries a lamp round her light at the navel, sunwise, at an even pace. Each whole circle comes back as light received, so it is a gain and never a renunciation (C-1230).
- A rushed circle only makes the flame flicker.
- A circle the other way does not gather.
- Seven circles hand him to her Recognition.

## 4 · The Seed and the World keep a little on the phone

`Services/PlayGardenStore.swift` is a `PracticeVault` file (`play-garden.json`). Like the river and the wagers, it needs no schema change and no `@Model`. It keeps three things:
- **one trace per game played**, written beside the ledger row in `PlayGameHost.writeOnce`;
- **every seed planting.** A bloom's Recognition plants the next seed; nothing is ever uprooted or removed;
- **the World's last visit.**

Play still keeps no store of its own under `Views/Play/`; `PlayScreenTests` checks this. The ledger remains the single record of events. The store is the phone's own memory of the same acts, so the World and the Great Wheel can be drawn offline.

The World draws one object per trace, never a total. Gifts arrive at one per day away, capped at three, so they are never a debt.

## 5 · The year's small practices

These are light, not dashboards. No hour, date or count is drawn.

**Sandhyā.** The practice is the junction nearest to now, by the day's own sun (`Panchanga.sunTimes`). Deep night belongs to the dusk that began it, or to the dawn ahead.
- **Dawn:** draw the horizon up, slowly.
- **Noon:** lay the phone face up and still, or rest a still finger. Light gathers over about forty seconds of stillness.
- **Dusk:** press and lower the light.
- Each uses the Temporal Layer's own invitation.

**Seasonal yantra.** `SeasonLight` gives each of the six ṛtus a colour, an intensity and two lines of poetry. Śiśira and Varṣā take their neighbour's lines.
- It tints Lalitā's whole field with the season (one glow).
- It lights the Śrī Yantra at the Great Wheel's heart.
- I left tinting the Mandala itself to Slice D's layers.

**Great Wheel.** The six seasons are sectors. The days he played are small lights on the rim, and a day without play is simply space. He flings the wheel; near rest it is drawn the last little way so today comes to the point at the top.

## 6 · Ring Worlds mechanisms (rings 1, 2, 4, 5 and Ring 8's vertex)

These are pure offsets in `Homes/RingMechanisms.swift`, an extension of `ClimbLights`. The hook is small:
- `ClimbGestures` gains fields, every one defaulting to "no offset";
- `WorldClimbScene.placed` adds the offsets;
- `WorldClimbDriver.stand()` computes them in `standTheWholeMechanisms`.

What each ring does:
- **Rings 1, 4 and 5** answer a still hand (touching, not moving):
  - Ring 1: the three families settle onto the Bhūpura's three squares.
  - Ring 4: a teaching wave lifts each seat in turn, one seat per 0.6 s.
  - Ring 5: the lights overflow their circle.
- **Ring 2** opens and closes with the sun (`LotusSun`, read once a minute).
- **Ring 8:** when he flies into one vertex, the other two collapse into it over the first half of the flight.

Every offset is zero at rest, so the climb is unchanged until a hand asks. I did not hook the mechanisms into the Mandala's own rings; that layer belongs to Slice D.

## 7 · Lalitā's field holds thirty-six

- **Shared addresses.** `PlayFieldLayout.point(for:)` now spreads games that share a ring or a threshold. A second game at the Bindu's seat stands beside the point, and the Śrī Yantra stays on it.
- **Relaxation.** `PlayFieldLayout.relaxed` eases every light apart to at least 50 pt, with the yantra pinned. I checked it at 375, 390 and 430 pt widths: minimum separation 50 pt.
- **Size.** The field radius grew a little (0.42 w / 0.36 h), and the verb labels went to 12 pt.

## 8 · The host's two small hooks

- **`give(word:session:)` and `PlaySession.ask(_:prompt:)`.** A game can ask for his word, and the host shows one `TextField` over the game.
- **`meet(_:)`.** Each game receives the Śaktis' own words by position: name, Appreciation Phrase, Function, quality.

Both have default no-op implementations, so Wave 4's sixteen games are unchanged.

## 9 · Left for him to rule

- **Leela.** The arrows and snakes are the skill's first draft (5→8, 12→18, 13→20, 26→29; 15→6, 19→10, 28→21, 30→9). Square 32 is held. The die is thrown by hold-and-release, or by shaking the phone.
- **The Scrolls.** They keep the corpus line "None of it was wrong." It is drawn as the Shadow's own words, not a verdict on him.
- **The Door's hard-press dimming** is Slice C's to remove. I did not touch it.
