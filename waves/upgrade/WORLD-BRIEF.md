# World brief — the upgrade map, world by world (stage 2)

Bindu Mandala is being upgraded, not updated. Everything has been read (the register, `waves/register/01…22`), and every item in it has been indexed (`waves/upgrade/index/ALL.jsonl`, 6,473 rows, sliced by world in `waves/upgrade/index/by-world/`). Your job is to turn your world's slice into the **complete design of that world as it will be built** — the way the Bindu Feed upgrade was mapped: every gift placed, nothing compressed, every piece with its numbers, its reference, its code to reuse and how it will be proven.

Read first, in full: `waves/register/READER-BRIEF-2.md` (foundation, fifteen worlds, rulings 1–10, floors) and `waves/upgrade/INDEX-BRIEF.md` (rulings 11–17 and the settled points). Then read **every row** of your assigned slice file(s) (JSONL — use python3 -I to print them into readable text in your scratch directory and Read that in full). When a row's detail is thin, open its `sources` in the register and read those lines. You may grep other slices for cross-references.

## The fifteen worlds and the spine (for reference)

Home (the Bindu) · Today/the Rite · the Mandala (held yantra + Veil) · the nine rings · Her Home · Her Presence · the Climb · the 33 · A Strange Game · the Modes · Time · Memory · the Well · Beneath · the Relationship Field. The spine: the point (touch → home) in every world, the always-available menu (drawn as a constellation of world-points), doors along the three threads (her position kp 1–102, the chakra 1–33, the day), search, the Veil, gestures as extra doors, back to exactly where you were, crossings that travel through the point (blooms from the touch, in the colour of the world entered). Each world is its own space; nothing is laid over another world.

## Principles for the design

- **Abundance.** Place every gift. If two gifts compete for the same moment, design both (one as a door, a mode, a second visit, a gesture) rather than dropping one. Reject only what breaks a floor or ruling, and say which.
- **Mechanism, never mood.** Every element is described as what it does, with numbers (timings, Hz, colours, sizes, counts of things — never counts about him), the gesture, the data it reads, and what the person sees and hears second by second where it matters.
- **Energies, not stories.** Story material goes to the Bindu Feed list (section 6), not into the world. Text in the world is always revealed through a form (a beat per screen, a hold, the moving point, stillness), never a page.
- **Reuse what is built.** The code readers found a lot already built (sound conductor, carriers, ephemeris, room engine keyed by kp, ledger, Shadow corridor, Praveśa, Pointy, letters' river…). Say what is reused, what is moved into this world, and what is new.
- **Design is the floor.** Where Design made it (a frame F01–F40, a prototype with numbers), the build matches Design first, then goes further.

## Write `waves/upgrade/worlds/<world>.md`

1. **The world** — what it is, in his words (Codex C-numbers) and Design's; then the full experience: arriving (from where, the crossing), being there (every element, every interaction, every sound, light, motion, timing), going deeper, leaving (to where). Its visual language (tokens) and sound. Write it so a builder can build it without opening any other file — and give the source refs so they can.
2. **Every element, placed** — a table: # · element · what it does (mechanism + numbers) · source (index ids + register refs) · status today (built/partial/not/wrong + code refs) · reuse / move / new.
3. **Parity ledger** — also written as `waves/upgrade/ledger/<world>.csv` with columns: `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by` (verify_by = one or more of: screenshot-vs-frame Fxx, measure-light, measure-sound, measure-timing, ui-walk-step, unit-test, his-walk). One row per checkable element.
4. **Data contract** — Airtable fields (ids where known), bundled assets (mp3 paths from `waves/register/audio-on-github.md`), local stores, App Activity types written.
5. **Doors** — every way in and out along the threads and the spine, to and from which worlds.
6. **To Bindu Feed** — story material from this slice, with sources.
7. **Conflicts settled and open** — settle from evidence and the rulings where you can (say the evidence); list only genuine questions for Ashrey.
8. **Coverage** — every index id in your slice, each marked: placed (§2 row #) / merged into (id) / to Bindu Feed / rejected (floor or ruling) / not this world (which world). None missing — a script check over your slice ids is required; paste its result.

Return: the paths, line counts, number of elements placed, ledger rows, and the five strongest things in this world's design.
