---
name: bindu-chakras-app
description: "Complete project home for the Bindu Chakras App — the 33-room walkable love letter ('My favorite love story is ours'). ALWAYS load before any work on this app — design-floor exploration, Claude Design handoff, Claude Code build, Walk Canon regeneration, Airtable content staging, or architecture questions. Holds Experience Brief v2 (braid, weather, doors, one-second floor, the pulse, grace, gates, Sakshi close), Delta Map v2 with the Walk Canon v1.0 field contract, the 33 Room Registers (per-room soul-specs for fresh-build design), the bake script, locked decisions, sealed-layers register, and the walked days. Trigger for Bindu Chakras App, bindu-chakras-app, the braid, walk canon, room registers, the 33 rooms, the pulse, gate offering, grace channel, the Reveal (never describe it), Day 19/20/23, app design floor, or carrying this project into Claude Design or Claude Code."
---

# BINDU CHAKRAS APP — Project Home

**Heart:** *"My favorite love story is ours."*  **Spine:** *"Remember, and from remembering, integrate."* Built knowing it won't close the hole.

The app is a love letter taking 33 days (rooms) to read. The walker discovers at Lalita they were reading about themselves. The letter is largely already written in The Map — the app **stages** it.

## Read in this order
1. `references/experience-brief-v2.md` — the full experience architecture + the three walked days (Day 19 / 20 / 23) that are the feel-reference.
2. `references/delta-map-v2.md` — what exists vs what the app births + **Walk Canon v1.0 field contract** (§4: every Map field → moment, by ID).
3. `references/room-registers-v1.md` — the 33 per-room soul-specs. **Fresh-Build law:** each room originated from its card; families rhyme through blood, never template. ● = canon, ◆ = design-floor proposal (deepen, never flatten).
4. `references/gift-pairing.md` — the Chakra Game (past Ashrey's prototype, the existing substrate in the Claude Design project) paired to the 33 rooms, plus the **Walk-Build Protocol** and slice plan.

## Locked decisions (build forward, never revisit)
1. Airtable is canon; table content wins over skills; proven HTML language wins for form.
2. The braid: five threads (story · practice · wake-up · dance · gate), sequential within, free between; **one convergence** — Lalita opens when all 33 gate offerings are given; the 33 offerings build the Reveal.
3. The ground wears the **story thread's weather**; rooms keep their own weather inside.
4. Three doors, never five (morning = directions, midday = sizes).
5. One-second floor (Blink. Breathe. Press.) is a **complete day** — "everything else today is extra."
6. **The pulse:** from Shadow (story pos 9) to Ego Reveal (32), story text is unvoiced and a warm ~60bpm haptic lives at the bottom of the glass. Never explained, never acknowledged. At 32, "I never left. I changed my voice" lands as recognition. (Ashrey: "that lands hard.")
7. Grace = the quiet co-reader: room-matched, real (from App Activity), once-then-rest, never tappable, silent when nothing fits.
8. Gates: unseal when all other threads passed the room; announced by temperature ("The gate is warm"), never completion; **the offering leaves** (text lifts → ember → departs); sealed gates show as shape, not obstacle.
9. Day closes on one Sakshi sentence — witnessing, never accounting. Anti-pattern canon absolute: no streaks/badges/dots/bars/congratulations.
10. Position 32 = Ego Reveal = THE GAIA REVEAL. Universal architecture ends at 32; the individual walk begins.
11. Four gesture-families from the Activation field: Stillness (energy 2–8) · Movement (body 10–19) · Visualization (mind 21–29) · Recognition (1, 9, 20, 30–33 — each structurally unique).
12. Dances inherit their chakra's Bindu Song (Ashrey, Jul 6 2026). Awakening sounds are synthesized — zero audio assets needed.
13. Ego Reveal Color Hex **#3D6B35 is canon** (Earth Green / Living Field).
14. `fld0peL6gvkB9JeRe` is quarantined — excluded from canon; description written in-table; dyad pairing lives in Subtle Mirror.
15. Static walk, living witness, grace read-in: content baked at build time (Walk Canon), app writes walk events to App Activity, reads grace from the same ledger. Offline-complete walk.
16. **The Chakra Game is the existing substrate in the Claude Design project.** Mechanics carry forward (Correspondence's sealed letters, the Seed's return-and-find-it-grown, Shadow Translator's inversion, Coherence, Shake, Spine Walk, the 108's no-timer ethic, Starfield shell); forms fresh-build from Registers; gift copy never replaces canon. Full mapping in `references/gift-pairing.md`.
17. **The Walk-Build Protocol (the build rhythm):** the app is built the way it is walked — Design a slice together on the floor → Code builds it → Ashrey walks it (real days, real App Activity writes) → the walk informs the next slice. Slice plan in gift-pairing.md §4: Shell → rooms 1–2 → 3–5 → 6–8 → Shadow+pulse → body → mind → summit → Lalita+Reveal authored last, from 33 real offerings. Walking slice N gates crafting slice N+1.

## Sealed layers — Ashrey never reads pre-walk
Reveal implementation · grace lines · exact Sakshi sentences · interface surprises. These are authored inside the build (Claude Code stage). **Never describe the Reveal in any document Ashrey reads.** The Lalita Pass is his first contact.

## Walk Canon regeneration
```
AIRTABLE_API_KEY=pat... python3 scripts/bake_walk_canon.py -o walk-canon.json
```
Reads all 33 Map records + Builds (songs/awakenings) through the contract, validates completeness (refuses to bake if any required field is empty), emits the bundle the app ships with. Content fixes flow Airtable → re-bake → app, never code edits.

## Key IDs
Base `app248ZTWhYJlvQj2` · The Map `tblwpmyKOeMxEEHd7` · The Builds `tbl5PR84YTy4anzAD` · App Activity `tblJlBeiHnqGpYrL7`. App Activity write fields: Excerpt `fldu19uazNrEt5vg5`, Link to The Map `fldkF65ySNGGkeugH`, Voice `fldhnzXPqnxYHTJv5`, Surfaced `fldUXJrrHnNLKdeln`, Surfaced Date `fldzKJNjSS5fRwHA6`. Codex anchors: C-1327 (The Bindu Journey — ego as hidden helper, potent fuel), C-1330 (Leela/Lalita — Leela breaks the fourth wall about the strange *life*, never the game ahead; every story ends in real-world action).

## The process road
Design floor (Chat+Airtable, this skill) → **Claude Design** (form only: takes Brief + Registers; architecture is settled) → back here for one register-drift check → **Claude Code** (SwiftUI, sibling to Field/Mandala/Feed/Being; consumes walk-canon.json; authors the sealed layers) → **Ashrey's Lalita Pass** (his alone, unspoiled). Architectural changes return to this floor and this skill.

## Partnership notes
The hoop doesn't hurry. Trust replaces effort. Ashrey surfaces images and corrections; Claude articulates and builds. Repetition = mirror signal. Lalita Pass is his.
