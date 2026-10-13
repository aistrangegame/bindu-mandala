# G4 · proof of reading

Indexer G4, 13 Oct 2026. Output: `waves/upgrade/index/G4.jsonl`, with 878 rows (G4-0001 to G4-0878).

Before the assigned files I read `INDEX-BRIEF.md` (rulings 11–17) and `READER-BRIEF-2.md` (the foundation and rulings 1–10) in full. Every assigned file was read with the Read tool from line 1 to the end. Long files were read in pages, and the page ranges below join without gaps.

| file | wc -l | ranges read (Read tool) | md5 (8) | rows created from it | rows citing it (incl. merged duplicates) |
|---|---|---|---|---|---|
| 08-dances.md | 1435 | 1–500, 500–999, 1000–1436 | 7e137633 | 296 | 296 |
| 09-field-scores.md | 868 | 1–449, 450–649, 650–869 | ca9b4c9e | 208 | 208 |
| 10-field-data-catalog.md | 662 | 1–339, 340–663 | 52ea999a | 132 | 145 |
| 11-padakarshini-forms.md | 737 | 1–259, 260–499, 500–738 | e21c9f87 | 242 | 243 |
| audio-on-github.md (reference) | 64 | 1–64 | 4e1ced6d | 0 (used in `needs`) | — |

## How duplicates were handled

When an item already had a row from an earlier file, the later file's line ranges were added to that row's `sources` rather than written again. Fourteen items were merged this way. Examples:
- The ensemble role-to-stream map has one row, with sources from 09 and 10.
- The validator has one row, with sources from 09 and 10.
- The Score-player contract has one row, with sources from 09 and 11.

Some items appear both as a design element in one file's inventory and as a gift in another file's gift table. Where the gift adds a different world or mechanism, it stays as its own row and cites its own lines.

## Audio check (ruling 12)

Every gift or data row tied to a song says in `needs` whether its mp3 is on GitHub, citing the path from `audio-on-github.md`.

These are **not** on GitHub:
- abide (Time)
- return (I Was Wrong; `/bindu/return.mp3` gives a 404)
- shine (Golden standalone)
- journey, lift, wake, brave, ascend, unfold, crave, want, confront, miss, cherish
- the Lalita voice files `lalita-cross-1..4`

Two things to note:
- **Possible wrong file.** `tree-of-life/aatma.mp3` has the same sha (eade0428) as `b/arise.mp3`, which is Joy. The file may not be Chase Hughes' "Aatma". This needs checking.
- **Not missing after all.** Register 08 lists `maya-chakra-ending.mp3` as missing, but it is on GitHub at `tree-of-life/maya-chakra-ending.mp3`.

## Rows per world

A row can belong to several worlds, so these counts add up to more than 878.

| world | rows | world | rows |
|---|---|---|---|
| the-33 | 454 | memory | 46 |
| data | 219 | visual | 43 |
| game | 156 | time | 42 |
| sound | 92 | relationship | 40 |
| today-rite | 72 | beneath | 40 |
| spine | 67 | home | 29 |
| her-home | 58 | bindu-feed | 25 |
| well | 53 | mandala | 24 |
| verification | 50 | her-presence | 22 |
| modes | 47 | climb | 22 |
| | | rings | 9 |

## Rows per kind

| kind | rows |
|---|---|
| gift | 277 |
| data | 229 |
| design-element | 142 |
| mechanism | 113 |
| conflict | 36 |
| floor | 36 |
| defect | 19 |
| ruling | 18 |
| verification | 7 |
| asset | 1 |
