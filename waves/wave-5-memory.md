# Wave 5 — Memory and words

**Branch:** `wave/5-memory` (built on `wave/1-light`) · **Charter:** Build Charter II (Emergence)

What the instrument remembers, and the words he alone writes into it.

| Piece | Where | What comes home |
|---|---|---|
| **The Portrait as the Living Mandala** | `Views/Memory/PortraitMandalaView.swift`, `LivingMandalaLayers.swift`, `Models/LivingMandala.swift`, `Services/PortraitStrokeStore.swift` | His strokes drawn into the Portrait, mirrored by the ring he draws in (28 · 16 · 8 · 14 · 10 · 10 · 12 · 3 · 1); the year accreting round the rim, one bead per practised day, no empty slots; the centre's eye closed while a letter is sealed; all of it in the exported Record (long press → `ImageRenderer` → share) |
| **The Well as a river** | `Views/Memory/CorrespondenceView.swift`, `Services/CorrespondenceStore.swift`, a door in the Well's header | Letters back to a moment; letters sealed forward to her day (the next Pūrṇimā, Amāvasyā, the return of this tithi, or her own next day) — no peek, revealed word by word, no reply ever; pages yellow by real time; drafts kept |
| **The somatic way in** | `Views/Memory/WhereSheSpeaksView.swift`, `Models/SomaticRegion.swift` | His body as places of light; touching one lights the Śaktis whose own `bodilyLocation` names it; touching her opens her screen |
| **The Bindu gaze + the five clocks** | `Views/Memory/ThePointView.swift`, `Services/Ephemeris.swift` | Hold the phone still and the field steadies; the hour (with the three sandhyās), tithi, nakṣatra, ṛtu and sun (rāśi, ayana) turn round the point, read off a real ephemeris |
| **The random gift** | `Services/EnergyGift.swift`, Settings, `RootView` | One Śakti's Appreciation Phrase or Function at an hour he will not expect, at most once a day, inside his window; opening it lands on her |
| **Codex on her screen** | `Views/Common/HerDoorwaysSection.swift` | The everyday doorway (her element + one line of her row), the seal his hand holds to call her back, the Wager ("watch for her today… did she appear?") |

**One moon.** `LunarPhaseService` is now a façade over the ephemeris, so the Rite's
Nityā, the ledger's `Lunar Day` and the clocks never disagree.

**Ledger:** `Letter Sealed`, `Letter Opened`, `Portrait Drawn`, `Wager Resolved` — one row per act, linked, never dropped.

**Done when:** "Waves — test" is green, merged to `main`, TestFlight delivers, and he walks it.
