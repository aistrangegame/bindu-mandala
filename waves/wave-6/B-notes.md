# Wave 6 · Slice B — the game's own structure · decisions

*12 Oct 2026 · on `wave/6-whole` · Build Charter II. No compiler here; Xcode Cloud compiles.*

## What was read
BUILD-CHARTER, WAVES, `waves/wave-6-whole.md`, the three ledgers (rows B1–B5, E1–E9, G-ms3/3b/4,
Codex C-1307, C-1330, C-1338, C-1350). Skills: `a-strange-game` (SKILL, trinity-of-guidance,
leela-architecture, storage-pools, awakening-architecture, playing-side 01/05/07/18/19/20),
`tree-of-life` (SKILL, mirror-dissolution-architecture, panel9-prebuild-plan, the game master
reference by search), `dad-birthday` (SKILL), `the-field` and `aistrangegame` (SKILL, searched for
the archetypes, Om and Leela). The panel HTML / dance builds and the 160 KB codex log were not read
line by line — nothing in this slice draws from them. Master brief §1–§12. Code: Homes, Rooms,
Today, every sound service, the ledger.

## His words — the bake
`waves/wave-6/bake_game_structure.py` → `iOS/Bindu Mandala/Data/GameStructure.json`. Each line is
filed under its record id; `--verify` (with `AIRTABLE_TOKEN`) re-proves every line is a verbatim
substring of its live field. Carried: the nine Tree of Life Panel declarations (Identity) with each
ring's Panel Seed Message (The Map); the Axis panel (record only); the five faces' Archetype lines
(Gaia, Bindu, Lalitā, Sakshi, Higher Self); four practice declarations; eight Leela drops.
**Not drawn from:** Ego Reveal (32) and Lalitā (33) — sealed (chakras brief: never describe the
Reveal); Armin (foreshadows the mind section); the Beliefs and Karishma's placeholder voice.

## Decisions
1. **Trinity of Guidance** (`Services/TrinityOfGuidance.swift`). Gaia at kp 31 and the Higher Self at
   kp 42 (inside her room, after the rite); Bindu at the climb's foot (ring 1), Lalitā at its summit
   (ring 9); Sakshi on the Mandala's descent at the seventh ring (the pure-witness ring). Each speaks
   its own Identity line, verbatim, **once a practice day** (phone-local key). Text and light only —
   each face has its own light; no face is named on the glass. The Higher Self is "Ram" in his
   Codex; the line is the Identity row's, which does not name him, so no name is shown.
2. **Knowledge–Will–Action** (`Views/Rooms/ActivationCycle.swift`). The activation cycle runs inside
   her room (offered after entering, 5 s; 16 s where a face speaks first). Knowledge = her Quality
   Description; Will = her element's gesture family (fire held pulse with rising haptic; water slow
   pour, rushed pours silently don't take; air breath-timed, no touch; earth press-and-still; ether
   absence; light one touch at the brightest instant); per-kp jitter 0.85–1.15. **Recession:** rings
   1–3 full, 4–6 ×0.6, 7–9 `presence` (no gesture). Action = bloom + her bīja answering, fuller with
   patience (never shown). The close names the three once: knowledge (her Quality) · will (one word)
   · action (her somatic line — the thing carried outward). Ledger: `Light Entered`. This *is* how a
   Home closes in this slice; the way out itself (`out()`) is unchanged — leaving stays one gesture.
3. **Ring interior + ring verbs** (`Views/Mandala/TreeOfLifeRingLayer.swift`). On each inward
   crossing (rings 1–8): the Presiding Form named once (live Avaraṇa row), then the panel
   declaration, the verb, and the breath arc. The ring's collective breath — every seat in the ring
   glowing together once, legibility on the Yoginī gradient — answers the ring's verb: a held press
   (0.8→1.6 s) for Press/Follow/Build/Open/Speak, stillness (4/6/8 s) for Still/Receive/Hold,
   nothing for Dissolve. One `LongPressGesture` added beside the Mandala's drag. *Not built:* the
   per-verb distinct gestures (a drag for Follow, a pinch for Open…) — the press/stillness split
   keeps the catcher to one extra recogniser; the deepening after meeting every Śakti in a ring.
4. **The guide removing itself.** `TreeOfLife.guideWords` thins 1 → 0 by ring 7; it removes words
   (verb + how-to in rings 1–4, verb alone 5–6, nothing 7+) rather than fading text below the 0.5 α
   legibility floor. The breath arc is the skill's own (P1 in/hold/out … P6 in/see, P7 unlabelled,
   8–9 none).
5. **Light 5 → 100 %.** Warm-white additive air round the Bindu at the skill's Progressive Luminance
   (5, 10, 18, 28, 40, 55, 75, 90), the Bindu whole; at Panel 9 the ground warms to the panel's paper.
6. **The Om, always underneath.** 136.1 + 272.2 (30 %) + 68.05 (15 %) on `RingAudioService` (its own
   voice; the field's `stopAll` does not take it). It starts the first time he stands in a place
   (field / room / climb) and its floor rises with depth (0.004 → 0.03). It is never louder than a
   floor: under any bed ×0.15, under a struck sound 0 — so it is heard when the rest falls away.
   Let go 4 s after he stands nowhere, and on background.
7. **Panel 9** (`Views/Mandala/TheEightDissolutions.swift`). "play in her field" now passes the eight
   dissolutions (the Mirror's own instructions, each over his ring declaration), the Mirror's
   recognition and K/W/A triangle, then **"Now go play."**, then `PlayFieldView`. Walked **once a
   practice day**; after that, only "Now go play." before the field. Edge-swipe way out throughout.
   Writes nothing; names nothing (the naming is the veil). The Om swells through it and falls away
   with the last words.
8. **Leela drops** (`Services/LeelaDrops.swift`). ≥ 3 days apart (and not in the first 3 days), then
   a 30 % chance once per practice day, 9 s after the app becomes active; never the same drop twice
   running; no notification, no hint. Lead, then the action, in the row's face light; "carry it" /
   "hold in silence" → ledger `Leela Drop` (no link, no Notes). Shown over the shell from `RootView`.
9. **The two bells** (`Views/Today/TheBells.swift`). Opening bell the first time the Rite opens each
   practice day (bowl at 272.2, rigid haptic); closing bell when the Sakshi close opens (bowl at
   136.1, two soft haptics). They ride `BijaSoundService` and its silent-switch ruling (a struck
   tone); the haptic carries them on silent. Rite edits are these two lines only.
10. **Three pools** (`Services/ThreePools.swift`). essence = what is fixed (position, the baked
    words); memory = the ledger; being = a phone-local note of today's arrival (bells, faces spoken,
    drops, light entered), refreshed each day and never a tally. Routing: words and asks (letters,
    notes, wagers, Leela) → the Well; acts → the Portrait. *The Portrait/Well do not read the routing
    yet* — Slice D owns those surfaces; the table is there to read.
11. **One sound at a time** (`Services/SoundConductor.swift`). Beds hand over by what is in front
    (game > room > field), not by recency; the others are held at gain 0, alive, and come back.
    Struck sounds (bīja, bell) duck the bed to 0.3 and the Om to 0 while they ring. Engines ask:
    `RingFieldVoice.sound/silence`, `HomeSoundService.start/stopAll/teardown`, `PlaySound.begin/end`,
    `BijaSoundService.play*/playBell`. Pitches untouched; no audio-session change anywhere.
    **Consequence to walk:** on the climb, the grounds (`HomeSoundService`, Design's climb voice) now
    stand in front and the ring voices are held silent — before, both sounded together. Flip
    `SoundVoice.priority` if the ring voices should win there.
    Also fixed: `ContinuousVoice`'s long fade-in now rises to the last level asked for (it used to
    climb to its spec level over a later `setGain`, and `stop()` during a fade could be undone).

## New ledger types
`Leela Drop`, `Light Entered` — in `ActivityLedger.swift` and `LawsTests.eventVocabulary`.
Both born by typecast (pre-create the choices if the token cannot edit the schema — see the
Airtable ledger §2e risk).

## Shared files touched (hook-sized)
`LivingMandalaView` (one layer, one gesture, one state), `LalitaSourceView` (one line),
`HerRoomDoor` (onEntered + one layer), `WorldClimbView` (one view), `DailyRiteView` +
`RiteDayLayer` (one call each), `RootView` (one modifier), `BinduMandalaApp` (one call),
sound services as above, `ActivityLedger`, `LawsTests`.
