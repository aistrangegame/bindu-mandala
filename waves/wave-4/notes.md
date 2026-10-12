# Wave 4 · Play — decisions

1. **Addresses are positions, verified against the rows.** Read live on
   2026-10-12 (Mandala table `fldI0aV1sfOeNybHI`, The Map `tblwpmyKOeMxEEHd7`):
   69 Sarva-Priyaṅkarī, 70 Sarva-Maṅgalakāriṇī, 71 Sarva-Kāmapradā, 80
   Sarvajñānamayī, 84 Sarvānandamayī, 94 Kaulinī — the walk's table, all
   confirmed. Where the walk named a chakra rather than a Śakti, The Map's Body
   rows gave the seat: Soles → Sarva Saṅkṣobhiṇī of the 14 triangles (kp 53),
   Forge → Sarva Mantramayī (65), Crow → Sarvādhārasvarūpā (82). The energy
   chakras live at a whole ring; a game needs one Śakti to hand to, so the rows'
   body locations chose: Mūlādhāra → Garimā (4, "sit-bones / soles"),
   Svādhiṣṭhāna → Vārāhī (15, "belly / sacrum"). The names live only in
   `PlayAddressTests`, so no screen is keyed by one.
2. **Two hand-offs, never an end screen.** Seat games hand to
   `RecognitionMomentView(source: .play)`; Corridor, Water, Shake and the Bīja
   tones hand to stillness — the light gathered to one breathing point. In
   stillness, if the game had a seat, the point is a door to her Recognition.
   Leaving is one "‹ leave", always there.
3. **One ledger row per game.** `ActivityLedger.played` (`Played`, `Play`,
   `Duration (sec)`, no Notes). Written once: when the game hands off (before
   any light moves), or on leaving if he really played (three acts, six seconds).
   A Śakti not yet synced is filed on her ring's Avaraṇa row rather than dropped.
   It rides `logActivity`'s queue, so offline play drains with everything else.
   The vocabulary pin in `LawsTests` gains "Played", with a comment.
4. **The garland is the door for the other 86.** Rather than a play door only on
   the twelve seated Śaktis, every Detail opens either her game or her own bead
   in the 102-bead rosary. Position stays the only key, and every one of the 102
   can be played with.
5. **TouchSense / LightBody, implemented here.** Bindu Feed's code is not in this
   repo, so the idea is built: a `UIView` surface reads each finger's force (or
   its pad size where there is no force sensor) through a soft saturation —
   force absorbed, never punished. `PlayMotion` reads gravity and user
   acceleration (CoreMotion device motion — no Info.plist key needed).
6. **Sound.** Play's own small synth (`PlaySound`): struck tones, the earth
   thump, the lub-dub, one looping drone. The session is `.ambient` while a game
   is open (the silent switch is honoured) and handed back as `.playback`.
   Pitches: the point's 136.1 Hz, the walk's Awakening table (174, 210, 320,
   341, 384, 426, 480, 528; the Bindu is silence) — no solfeggio ladder.
7. **The screen never counts him.** No digit, no bar, no "n / 24". Every game's
   progress is physics: the door's light, the root's depth, the water's mirror.
   `PlayScreenTests` reads every file in `Views/Play/` for numbers, bound
   measures, red-as-failure, verdict words and private stores.
8. **Hooks kept small.** `ShaktiDetailView` (+`herPlay`, one cover),
   `LalitaSourceView` (+ "play in her field", one cover), `RootView`
   (`.playFieldPresenter()`), `ActivityLedger` (+type, +source, +builder),
   `AirtableService` (+`RecognitionSource.play`). Launch argument `OPEN_PLAY` /
   `OPEN_PLAY=<game>` opens the field or one game for the harness.

## For Wave 3

The Shadow threshold opens the corridor with `PlayField.open(.corridor)`; from
inside an existing full-screen cover use
`PlayField.host(.corridor) { … }` in your own cover instead.
