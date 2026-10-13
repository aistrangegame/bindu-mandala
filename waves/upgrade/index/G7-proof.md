# G7 proof: index of registers 19 to 22

**Output:** `waves/upgrade/index/G7.jsonl` holds 1,042 rows, G7-0001 to G7-1042.

## Reading

Before indexing I read `waves/register/READER-BRIEF-2.md` (42 lines) and `waves/upgrade/INDEX-BRIEF.md` in full.

Every assigned register file was then read in full with the Read tool, line 1 to the end. Long files were paged in consecutive ranges.

| File | wc -l | Ranges read (Read tool) | md5 (8) | Rows extracted from it | Rows citing it |
|---|---|---|---|---|---|
| 19-code-mandala-today.md | 869 | 1–607, 608–870 | 321eed80 | 227 (G7-0001 to G7-0227) | 227 |
| 20-code-play-rooms.md | 816 | 1–420, 420–817 | f9a39a93 | 265 (G7-0228 to G7-0492) | 276 |
| 21-code-layers.md | 239 | 1–239 | aa8e551b | 115 (G7-0493 to G7-0607) | 115 |
| 22-code-tests.md | 823 | 1–280, 280–560, 560–824 | 90e81672 | 435 (G7-0608 to G7-1042) | 443 |

"Rows citing it" can be higher than "rows extracted" because some rows from one file also list a source line in another file. Examples are the 20 and 22 game, Leela and seed rows, and the 19 and 20 chakra-room rows.

## How the register material was turned into rows

- **Parity lines.** Every line marked built, partial, not, wrong or deliberate is its own row with its code references. This covers 19 §B3 (Mandala, Veil, ring worlds and Living Rite), 20 §B.1 and §B.2, and 21 §B1 to §B4.
- **Chakra rooms.** File 20 has one row per chakra room, 1 to 33 (G7 "Chakra room N … today vs the braid"). Each row joins the §B.1 "what renders today" table with the §C.1 braid to build: practice, wake-up, gate and the code that can be reused. Rulings 2, 3, 8 and 17 are noted on rooms 18, 19, 30, 32 and 33.
- **Games.** File 20 has one row per game, 36 in all. Each row carries the game's address, hand-off, the chakra rooms that lead to it, its family world, its physics constants and its verbatim lines.
- **Lifted rules in tests.** Every test that encodes a lifted rule is a row with world `verification`, kind `defect` and a "how" that says what to do with it. These come from 22 §B.1 and number 90, one per test reference.
- **Floor tests.** Every floor test is a row of kind `floor`, 97 per-reference rows from 22 §B.1, plus floor rows from the test inventory and from registers 19 to 21: 152 rows in total. Floors that have no test (no generated voice, dissolutions once a day, Homecoming at each launch) are rows of kind `defect` with status `not-built`.
- **Craft and harness tests.** These are rows of kind `verification`, written with their numbers. Their content is also indexed as gifts in their own worlds, from 22 §B.5.
- **Story material.** Story material is flagged with `bindu-feed` and nature `story` under ruling 5.
- **Rulings.** Rulings 11 to 17 are noted where they apply. Examples: the line "her siddhi is still on the instrument" is dropped under 15. App-added once-a-day limits are lifted under 16, and dissolutions stay once a day. Relationship Field connections follow 11, and one tuning follows 12.

## Rows by world

A row can belong to more than one world.

| World | Rows |
|---|---|
| verification | 374 |
| game | 160 |
| the-33 | 159 |
| mandala | 118 |
| data | 110 |
| her-home | 96 |
| memory | 79 |
| today-rite | 75 |
| rings | 68 |
| time | 64 |
| her-presence | 62 |
| spine | 57 |
| climb | 52 |
| home | 51 |
| modes | 49 |
| visual | 40 |
| sound | 39 |
| beneath | 23 |
| well | 18 |
| relationship | 13 |
| bindu-feed | 11 |

## Rows by kind

| Kind | Rows |
|---|---|
| design-element | 238 |
| defect | 190 |
| gift | 183 |
| floor | 152 |
| verification | 98 |
| mechanism | 95 |
| conflict | 46 |
| data | 24 |
| ruling | 16 |

## Rows by status

| Status | Rows |
|---|---|
| built | 669 |
| not-built | 162 |
| wrong | 120 |
| partial | 53 |
| n/a | 38 |

Nothing outside `waves/upgrade/index/` was modified. Temporary build scripts are in the session scratchpad.
