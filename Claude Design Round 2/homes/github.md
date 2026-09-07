# Source repository

repo: aistrangegame/bindu-mandala
branch: main
path: iOS/Bindu Mandala

The live SwiftUI + SwiftData app. This project (design briefs + HTML prototypes)
is the design room; the repo is the built instrument. The repo follows its own
`Claude Design Round 2/RECONCILED-BUILD-BRIEF.md`, which supersedes this project's
`Bindu Mandala - Master Build Brief.html`.

## Last sync

date: 2026-09-06T22:33:11Z
(commit sha omitted — read at branch head `main`)

### Updated in this project
- Read `Atmosphere.swift` and `Element.swift` to write the Claude Code handoff
  against the real types. Three divergences found and corrected on the design
  side: the design had derived saturation/lightness from the gemstones rather
  than using the repo's own per-ring HSL; it lacked the ±7° per-Śakti hue jitter
  keyed off khaḍgamālā position; and it seeded Ring 2 from one ring hue where the
  app seeds from five cluster hues. `homes-chambers.js` is now a verbatim port.
- Wrote `Claude Code Handoff - The Homes.md` — the implementation architecture,
  additive to the shipped types, with the name reconciliation as a blocking
  decision for Chat.
- Assembled `handoff/` as a review package.

### Earlier this session
- Ported `DailyEnergyService` exactly into `homes-today.js`; ring spans confirmed
  against `KhadgamalaMap.swift` (1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 ·
  87–98 · 99–101 · 102) and used verbatim.
- Found that the bundled roster diverges from the Śakti cards for **61 of 102**
  names: Ring 1 carries no Garimā and its Mudrā slots hold Ring 4 Devī names;
  Ring 2 is empty. Recorded as a reconciliation for Code, not resolved here.

## Screen map

| App surface | Repo files |
|---|---|
| Daily Rite (six archetypes) | Views/Today/DailyRiteView.swift · Views/Today/Rite/* · Views/Today/DustMotesView.swift · Views/Today/BodyOutlineView.swift · Theme/Atmosphere.swift · Theme/Element.swift |
| Recognition ceremony | Views/Recognition/RecognitionMomentView.swift |
| Living Mandala (semantic-zoom → Bindu→Lalitā) | Views/Mandala/LivingMandalaView.swift · MandalaCanvasLayer.swift · MandalaCamera.swift · MandalaWorld.swift · RingGlyph.swift · TimeVariant.swift · SignificanceCard.swift · LalitaSourceView.swift |
| The Field (the 102) | Views/Common/TheHundredTwoView.swift |
| Shakti detail + embodiment | Views/Common/ShaktiDetailView.swift |
| Avarana threshold | Views/Common/AvaranaThresholdView.swift |
| The Well (letters) | Views/Common/WellView.swift |
| Portrait + Descent film | Views/Memory/PortraitMandalaView.swift · DescentFilmView.swift |
| Nityā temporal layer | Views/Today/NityaDetailView.swift · MoonPhaseView.swift · Services/LunarPhaseService.swift |
| Homecoming / return | Views/Common/HomecomingView.swift |
| Settings + menu + root shell | Views/Common/SettingsView.swift · Views/Root/RootView.swift · HamburgerMenuView.swift |
| Sound (ring + bīja) | Services/RingAudioService.swift · Services/BijaSoundService.swift |
| Daily selection engine | Services/DailyEnergyService.swift · Services/DailySummons.swift |
| Design tokens | Theme/Color+Tokens.swift · Fonts.swift · HSL.swift · DepthOverlay.swift · SeatLighting.swift · Layout.swift |
| Recognition data spine | Models/RecognitionEntry.swift · Services/RecognitionMigrator.swift · Services/RecognitionLogStore.swift · Models/DescentState.swift |
| Shakti data spine | Models/Shakti.swift · Avarana.swift · Cluster.swift · KhadgamalaMap.swift · NityaDevi.swift · ShaktiLetter.swift · ShaktiStatus.swift · Data/ShaktiBootstrap.swift · Data/AirtableService.swift |
| The Homes (design room → Code handoff) | `Claude Code Handoff - The Homes.md` · `handoff/` · `The Homes - The Axis.html` · homes-*.js. Maps to: Theme/Atmosphere.swift · Element.swift · Views/Common/ShaktiDetailView.swift · Services/RingAudioService.swift · Services/DailyEnergyService.swift · Models/KhadgamalaMap.swift |

## Note for the Code handoff

The Homes package (`uploads/homes-design-package.md` + the two Śakti-card files) is the
**Ruling-7 content pass**: it supplies Quality / Function / Somatic / Tattva / Bīja /
Etymology / Iconography for all 102, not just Ring 2's sixteen. When these land, the
graceful-degradation branches (`clusterGroup` empty, poem-as-invitation, hidden phonetic)
stop being the common case for 84% of the app. The nine ring-worlds return here as
*conditions inside a room* feeding `Atmosphere`, not as the nine `fullScreenCover`
screens Ruling 1 cut.

## Sync history

### 2026-09-02T02:42:37Z (tree 522cdd39ce86)
- No upstream change: the tracked subtree resolved to the same tree hash as the
  2026-08-22 sync, so nothing was rebuilt.
- Screen map re-verified, and extended with surfaces already in the repo but
  previously unmapped: Mandala world/time-variant/significance layers, the Rite
  subfolder, Homecoming, Settings, the Bīja and Summons services, Theme tokens.

### 2026-08-22T05:00:00Z (tree 522cdd39ce86)
- Compared the Master Build Brief against the shipped app to find the delta.
- Confirmed the app pivoted to the Reconciled brief: nine ring-worlds cut, one
  semantic-zoom Mandala; descent fully open; six-archetype Atmosphere-driven Rite.
- Recognition-102 migration, Daily Rite, Portrait all built or underway — the
  Master Build Brief is now largely historical.

## 2026-09-07 — Ruling 7 is CLOSED

Ruling 7 is CLOSED — all 102 carry full content in Airtable (verified live 2026-09-06); the Homes package is not a content pass; any blank on device is sync staleness. (Build Brief v2 R14; this supersedes the "Note for the Code handoff" above, which called the Homes package the Ruling-7 content pass.)
