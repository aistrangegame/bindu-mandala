# Wave 2 — One building

**Branch:** `wave/2-building` (stacked on `wave/1-light`) · **Charter:** Build Charter II (Emergence)

Charter §3, law 6: *every place is reachable from every place that makes sense. You can
fly into her light, open neighbour doors, or descend. Leaving is one gesture, never
punished.* Law 5: *sound is everywhere.* Design is the floor.

| Piece | Where | What comes home |
|---|---|---|
| **The climb holds the 102** | `Homes/TheBuilding.swift` (`ClimbLights`), `Homes/Render/WorldClimbScene.swift`, `Views/Rooms/WorldClimbView.swift` | Every Śakti a breathing point of light at her altitude (Design's Axis), the core light for a Śakti he has stood with or felt (*she was expecting you*), the crown light on today's Śakti, the rail of nine, the weather sentences, drag to turn |
| **Fly into her light** | `WorldClimbView`, `ClimbFlight` | A touch on a light flies the eye into it as the air thickens, and her rite of entering begins inside it |
| **One threshold, many doors** | `Views/Rooms/HerRoomDoor.swift` | Her room from the Mandala seat (card: *be with her ›*), the Rite (her seat in the foot), the Field (each seat's doorway arch), the climb, her Detail — all through the one rite of entering |
| **Neighbour doors** | `NeighbourDoorsView`, `Garland` | From inside a room, the seat before and the seat after her in the garland (kp ±1, the circle closing 102 → 1), each through her own rite |
| **Leaving** | `TheEdgeWayOut` | The 2.2 s held way out stays; an equal swipe in from the leading edge beside it |
| **The way down, always** | `TheDescent`, `DescentReach` | Offered at once; the shaft reaches three stations until her room adapts (or his dwell opened it), then all five |
| **Sound everywhere** | `RingFieldVoice`, `RingAudioService`, `GlissandoVoice`, `MandalaFieldVoice` | The six dead ring voices wired into the climb (crossfaded on its own weights, with HomeSoundService's nine grounds) and the Mandala (on by default, silent switch honoured); the descent's glissando; 136.1 Hz for the witness and the point |
| **Gates of Release** | `GatesOfReleaseLayer`, `TheGates` | Falling inward through an enclosure he may hold and set down its Mental State; coming out, receive its Siddhi — the ring's own rows, live (Siddhi read from `fldx9jXyTVWxp19o1`) |
| **The Ring Worlds, reborn in the rings** | `ClimbLights` mechanisms, `MandalaFieldVoice` | Ring 3 scatters at touch and gathers in stillness; Ring 6's light follows the finger and names whisper; Ring 7's twelve-voice chord; Ring 8's three tones (and lights) gliding into one |
| **The centre** | `Views/Mandala/TheCentre.swift`, `MaunaSilence` | Mauna (tap the point for silence — its own `Silence Held` ledger event, never felt), G17's centre bloom (hold), Ring 9's Praveśa (hold inside the silence: the endless fall with the Shepard tone, handing into Lalitā) |

New ledger types (born by typecast): `State Set Down`, `Siddhi Received`. Mauna writes a
`Silence Held` linked to the point's Śakti (kp 102).

**Done when:** "Waves — test" is green, merged to `main`, TestFlight delivers, and he walks it.
Decisions: `waves/wave-2/notes.md`.
