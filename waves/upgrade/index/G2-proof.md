# G2 · proof of reading

Indexer G2. Read the brief and its context first: `waves/upgrade/INDEX-BRIEF.md` (32 lines, rulings 11–17) and `waves/register/READER-BRIEF-2.md` (1–42, the foundation and rulings 1–10). Both were read in full.

| Assigned file | `wc -l` | md5 (first 8) | Ranges read with Read | Rows extracted |
|---|---|---|---|---|
| `waves/register/04-briefs-audits-frames.md` | 874 (Read shows 875: no trailing newline) | 1e0ed12c | 1–281, 282–481, 482–681, 682–875 | 476 |
| `waves/register/05-chakra-corpus.md` | 3392 | 5175d0c3 | 1–250, 251–500, 501–800, 801–1080, 1081–1380, 1381–1680, 1680–1979, 1980–2279, 2280–2559, 2560–2819, 2820–3119, 3119–3393 | 460 |
| **Total** | | | | **936** (G2-0001 … G2-0936) |

A row is counted against a file when one of its sources points into that file. No row cites both files.

## How the rows were made

- **04.** Each register entry is its own row. That covers DS, CB0, HO1, HO2, FB, UXA, DA1, RFB, MBB, DA2, FH, R2R, RBB, KP, XMB, EXP, HDP, CRD, CCH, THR, RMF/SUP, MTH, GH, SH, AB/DAB, AR/ARD, BV2, ERR, CN, BC, WV and RD.
  - Entries were merged only where the register already stated them together, for example "MTH-03/04". The row title carries every ID it covers.
  - **Frames F01–F40** each have their own row: kind `verification`, `frames` set to the F-id, `what` = what the frame shows, `worlds` = the world it is a reference for. Duplicate frames (F06, F16, F17, F20) also get their own rows, marked as duplicates.
  - One extra row records the frame gaps: the worlds that have no frame at all.
  - Conflicts C1–C40 are one row each, kind `conflict`.
  - Section E repeats items already rowed. Only two of its points were new, and those two have rows of their own.
- **05.**
  - Section A.0 gives the built choreography: room 1 shell, the legacy pages for rooms 1, 2, 3 and 30, and the Svadhisthana dance. Each mechanism, timing and defect in it is a row.
  - Section A.1 has one row per room, 33 in all, carrying the full walk-canon line: verb, hex, voice, system, activation, gate, bīja, awakening Hz and songs.
  - Section A.2 has up to 8 rows per room: register mechanism, arrival, story, practice and mudrā, wake-up and frequency, gate, depth (the Śakti / avaraṇa thread link) and Leela. Story and Leela rows carry world `bindu-feed`, nature `story`, and a note on Ruling 5.
  - Sections B, C and E: every game, experience, shell engine, storage key, bug, gap and law has its own row.
- **Room 32 (Ego Reveal).** Its rows cover structure only: mechanism, form, thread link and character counts. Its words are not reproduced, under Rulings 2 and 17. The source line ranges are given so a builder can read it there.
- **Sealed material.** The Living Mandala row (sealed territory) is tagged builder-only, and so are the SakshiClose prototype fragments.
- **Rulings 11–17** and the settled points are applied in `notes` wherever they bear on a row. Examples:
  - Axis 18 and Crow 19
  - Maya 30 and Ātma 31
  - Mind walked in the Map's sequence (one row records the Innocence → Integration ordinals)
  - Vision → Manipura, and OM (Ajna)
  - the after-effect felt but never named
  - lifted limits on grace and Leela
  - no counts about him
  - songs from his GitHub recordings
  - one tuning

## Rows per world

A row can belong to more than one world.

| World | Rows | World | Rows |
|---|---|---|---|
| the-33 | 432 | memory | 55 |
| rings | 134 | mandala | 49 |
| data | 128 | time | 37 |
| sound | 109 | climb | 33 |
| her-home | 108 | beneath | 28 |
| verification | 100 | modes | 20 |
| game | 83 | well | 20 |
| visual | 76 | her-presence | 17 |
| bindu-feed | 74 | relationship | 12 |
| spine | 67 | home | 12 |
| today-rite | 60 | | |

## Rows per kind

| Kind | Rows |
|---|---|
| mechanism | 267 |
| design-element | 217 |
| data | 127 |
| floor | 78 |
| verification | 68 (incl. 40 frame rows) |
| ruling | 64 |
| defect | 54 |
| conflict | 52 |
| gift | 5 |
| asset | 4 |

## Validation

All 936 rows were checked with `python3 -I`:

- every `worlds` value is in the brief's vocabulary
- every `kind` and `status` value is legal
- every row has at least one source

Nothing outside the two output files was modified.
