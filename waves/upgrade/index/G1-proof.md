# G1 · Index proof

Indexer G1 · 2026-10-13 · output `waves/upgrade/index/G1.jsonl` (781 rows, ids G1-0001 … G1-0781, every line parsed as valid JSON).

Read first: `waves/upgrade/INDEX-BRIEF.md` (1–31) and `waves/register/READER-BRIEF-2.md` (1–42), in full. Rulings 11–17 were applied in the `notes` field wherever they bear on a row.

## Assigned files

| file | wc -l | md5 (first 8) | ranges read with the Read tool | rows (first-source) | id range |
|---|---|---|---|---|---|
| 01-homes.md | 1043 | 8381e766 | 1–173, 174–343, 344–493, 494–593, 594–743, 744–893, 894–1043 (EOF) | 414 | G1-0001 … G1-0414 |
| 02-rite-axis-field.md | 1673 | c9cb6e9b | 1–140, 140–299, 300–469, 470–639, 639–808, 808–977, 977–1146, 1147–1316, 1317–1496, 1497–1673 (EOF) | 187 | G1-0415 … G1-0601 |
| 03-mandala-worlds-layers.md | 995 | de0c0687 | 1–150, 151–290, 291–410, 411–520, 521–629, 630–728, 729–828, 829–995 (EOF) | 180 | G1-0602 … G1-0781 |

All three files were read from line 1 to the last line. The ranges are contiguous with no gaps.

## How rows were made

- **One row per Śakti room.** The 102 rows G1-0142 … G1-0243 were taken straight from the H-TABLE in 01-homes.md, lines 482–583. Each row keeps the table's own values: name, app name, family, archetype, physics, altitude, attribute, tint, syllable, carrier Hz, hue, near and deep words, and doors.
- **One row per verification check.** The 66 Verification V3 checks were taken straight from 01-homes.md, lines 850–931, one row per numbered check, each tagged with its register: G1-0341 … G1-0406.
- **One row per attribute form.** There are 26 rows, one for each form in 01-homes.md, lines 600–625: G1-0249 … G1-0274.
- **Everything else was written by hand, one row per distinct item.** That covers mechanisms, Design elements, rulings, conflicts, defects, floors, data tables and assets. Verbatim lines are quoted exactly as the register gives them. Where an item appears in more than one place, it is written once and every source is listed.
- **Story rows.** Rows whose `nature` is "both" (story material) also carry `bindu-feed` among their worlds.

## Rows by kind and status

- **Kind:** design-element 326, mechanism 110, data 98, verification 78, defect 31, ruling 30, asset 30, gift 29, conflict 28, floor 21.
- **Status:** not-built 505, n/a 155, partial 70, wrong 34, built 17.

## Rows per world

A row can belong to several worlds, so these counts add up to more than 781.

her-home 301 · rings 138 · visual 115 · verification 93 · data 74 · mandala 66 · memory 65 · time 55 · spine 55 · her-presence 45 · climb 37 · today-rite 36 · sound 35 · modes 31 · home 30 · relationship 23 · the-33 9 · well 8 · beneath 5 · bindu-feed 4. No row was tagged game.

Nothing outside `waves/upgrade/index/G1.jsonl` and this proof file was written.
